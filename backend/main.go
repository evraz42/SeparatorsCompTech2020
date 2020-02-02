package main

import (
	"evraz/SeparatorsCompTech2020/backend/api/models"
	websocket "evraz/SeparatorsCompTech2020/backend/api/ws"
	"evraz/SeparatorsCompTech2020/backend/util/gpool"
	"evraz/SeparatorsCompTech2020/backend/util/logging"
	"fmt"
	"github.com/gobwas/ws"
	"github.com/mailru/easygo/netpoll"
	log "github.com/sirupsen/logrus"
	"gopkg.in/yaml.v2"
	"io/ioutil"
	"net"
	"time"
)

func main() {
	configRaw, err := ioutil.ReadFile("config.yml")
	if err != nil {
		log.Warn("config.yml: ", err)
	}

	config := Config{}
	err = yaml.Unmarshal(configRaw, &config)
	if err != nil {
		log.Warn("invalid config file: ", err)
	}

	var passDB string
	if config.DBPass == "" {
		passDBRaw, err := ioutil.ReadFile("/run/secret/password_db")
		if err != nil {
			log.Warn("unable to read password: ", err)
		}
		passDB = string(passDBRaw)
	} else {
		passDB = config.DBPass
	}

	// Database --------------------------------------------------------------------------------------------------------

	configDB := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable",
		config.DBHost, config.DBPort, config.DBUser, passDB, config.DBName)

	log.Info("Connecting to database")
	db, err := models.NewDB(configDB)
	if err != nil {
		log.Warn(err)
		log.Exit(1)
	}
	defer func() {
		err = db.Close()
		if err != nil {
			log.Error(err)
		}
	}()
	log.Info("Connect database successful")

	// Logging ---------------------------------------------------------------------------------------------------------

	log.AddHook(logging.NewDBHook(db))

	// Pool of goroutines ----------------------------------------------------------------------------------------------

	pool := gpool.NewPool(1000)

	// Connector -------------------------------------------------------------------------------------------------------

	connector := models.NewConnector()
	pool.Schedule(connector.Run)

	// Listener --------------------------------------------------------------------------------------------------------

	log.Info("Running DB listener...")
	listener := models.ConnectListener(configDB)

	pool.Schedule(func() {
		err = models.RunListener(listener, "flags", connector.GetChannel())
		if err != nil {
			log.Warn(err)
		}
	})
	log.Info("Run DB listener")

	// Start listen tcp ------------------------------------------------------------------------------------------------

	log.Info("Starting listen tcp...")
	ln, err := net.Listen("tcp", config.WSAddress)
	if err != nil {
		log.Warn(err)
		log.Exit(2)
	}
	defer func() {
		err = ln.Close()
		if err != nil {
			log.Warn(err)
		}
	}()
	log.Info("Start listen tcp")

	// Create netpool --------------------------------------------------------------------------------------------------

	poller, err := netpoll.New(nil)
	if err != nil {
		log.Warn(err)
		log.Exit(3)
	}

	upgrader := &ws.Upgrader{}

	func() {
		for {
			conn, err := ln.Accept()
			if err != nil {
				log.Error(err)
				continue
			}
			err = pool.ScheduleTimeout(time.Second, func() {
				_, err = upgrader.Upgrade(conn)
				if err != nil {
					log.Error(err)
					return
				}

				ch := websocket.NewChannel(conn, pool, connector, db)
				ch.Send(models.InfoResponse{
					Status: "Successful connection",
				})

				desc, err := netpoll.HandleRead(conn)
				if err != nil {
					log.Error(err)
					return
				}

				err = poller.Start(desc, func(ev netpoll.Event) {
					if ev&netpoll.EventReadHup != 0 {
						err = poller.Stop(desc)
						if err != nil {
							log.Error(err)
						}
						err = ch.Close()
						if err != nil {
							log.Error(err)
						}
						return
					}

					pool.Schedule(func() {
						ch.CheckReqLimit()
						ch.Receive()
					})
				})
				if err != nil {
					log.Error(err)
				}
			})
			if err != nil {
				log.Warn("Mo free workers")
			}
		}
	}()
}
