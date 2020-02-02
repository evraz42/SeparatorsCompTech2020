package models

import (
	"encoding/json"
	"github.com/lib/pq"
	log "github.com/sirupsen/logrus"
	"time"
)

func ConnectListener(config string) *pq.Listener {
	return pq.NewListener(config, time.Second*10, time.Minute*5, func(event pq.ListenerEventType, err error) {
		if err != nil {
			log.Error(event)
		}
	})
}

func RunListener(listener *pq.Listener, channel string, receiveChan chan<- FlagFields) error {
	err := listener.Listen(channel)
	if err != nil {
		return err
	}

	dataMessage := FlagFields{}
	zeroDataMessage := FlagFields{}

	for {
		select {
		case event := <-listener.Notify:
			dataMessage = zeroDataMessage
			err = json.Unmarshal([]byte(event.Extra), &dataMessage)
			if err != nil {
				log.Error(err)
				continue
			}
			receiveChan <- dataMessage

		case <-time.After(time.Minute * 2):
			log.Info("received no work for 2 minutes, checking connect")
			err = listener.Ping()
			if err != nil {
				log.Warn("notify connect is closed, try reconnect")
				err = listener.Listen(channel)
				if err != nil {
					return err
				}
			}
		}
	}
}
