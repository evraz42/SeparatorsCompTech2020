package ws

import (
	"encoding/json"
	"errors"
	"evraz/SeparatorsCompTech2020/backend/api/models"
	"evraz/SeparatorsCompTech2020/backend/util/gpool"
	"github.com/gobwas/ws"
	"github.com/gobwas/ws/wsutil"
	log "github.com/sirupsen/logrus"
	"io"
	"io/ioutil"
	"net"
	"net/http"
	"time"
)

type Channel struct {
	conn         net.Conn
	send         chan interface{}
	close        chan struct{}
	noWriterYet  bool
	pool         *gpool.Pool
	connector    *models.Connector
	reqPerMinute [60]int
	reqPerSecond int
	ban          bool
	lastReqTime  time.Time
	db           models.Database
}

func NewChannel(conn net.Conn, pool *gpool.Pool, connector *models.Connector, db models.Database) *Channel {
	c := &Channel{
		conn:        conn,
		send:        make(chan interface{}),
		close:       make(chan struct{}),
		noWriterYet: true,
		pool:        pool,
		connector:   connector,
		db:          db,
	}
	return c
}

func (ch *Channel) Close() error {
	ch.connector.UnSubscribeAll(ch.send)
	ch.close <- struct{}{}
	return ch.conn.Close()
}

func (ch *Channel) Receive() {
	reader := wsutil.NewServerSideReader(ch.conn)

	pkt, err := ch.readPacket(reader)
	if err != nil {
		log.Error(err)
		if err == io.EOF {
			err = ch.conn.Close()
			if err != nil {
				log.Error(err)
			}
			return
		}
	}
	err = ch.handlerPacket(pkt)
	if err != nil {
		var errorResp *models.ErrorResponse
		if errors.As(err, &errorResp) {
			if errorResp.Err != nil {
				log.Info(err)
			}
			ch.SendErrorResponse(errorResp.Nonce, errorResp.Message, errorResp.Code)
		} else {
			log.Error(err)
		}
	}
}

func (ch *Channel) Send(p interface{}) {
	if ch.noWriterYet {
		ch.noWriterYet = false
		ch.pool.Schedule(ch.writer)
	}
	ch.send <- p
}

func (ch *Channel) SendResponse(typeResp string, nonce int64, p interface{}) {
	ch.Send(models.Response{
		ResponseHeader: models.ResponseHeader{
			Type:     typeResp,
			NonceReq: nonce,
		},
		ResponseBody: p,
	})
}

func (ch *Channel) SendErrorResponse(nonce int64, message string, code int) {
	ch.SendResponse("error", nonce, models.ErrorResponse{
		Message: message,
		Code:    code,
	})
}

func (ch *Channel) writer() {
	writer := wsutil.NewWriter(ch.conn, ws.StateServerSide, ws.OpText)
	encoder := json.NewEncoder(writer)

	for {
		select {
		case pkt := <-ch.send:
			err := writePacket(writer, encoder, pkt)
			if err != nil {
				log.Error(err)
				return
			}
		case <-ch.close:
			close(ch.send)
			close(ch.close)
			return
		}
	}
}

func writePacket(writer *wsutil.Writer, encoder *json.Encoder, pkt interface{}) error {
	err := encoder.Encode(&pkt)
	if err != nil {
		return err
	}
	err = writer.Flush()
	if err != nil {
		return err
	}
	return nil
}

func (ch *Channel) readPacket(reader *wsutil.Reader) ([]byte, error) {
	header, err := reader.NextFrame()
	if err != nil {
		return nil, err
	}

	if header.OpCode == ws.OpClose {
		return nil, io.EOF
	}

	msg, err := ioutil.ReadAll(reader)
	if err != nil {
		return nil, err
	}

	return msg, err
}

func (ch *Channel) handlerPacket(pkt []byte) error {
	log.Info("Receive packet: ", string(pkt))
	requestHeader := models.RequestHeader{}
	err := json.Unmarshal(pkt, &requestHeader)
	if err != nil {
		return &models.ErrorResponse{Message: "Invalid request", Code: http.StatusBadRequest, Err: err}
	}

	switch requestHeader.Type {
	case "devices_list":
		devicesListResp := models.DevicesListResponse{}
		devicesListResp.Devices, err = ch.db.GetDevices()
		if err != nil {
			return &models.ErrorResponse{Message: "Internal error", Code: http.StatusInternalServerError,
				Nonce: requestHeader.Nonce, Err: err}
		}
		ch.SendResponse(requestHeader.Type, requestHeader.Nonce, devicesListResp)

	case "subscribe":
		subMsg := models.SubscribeMessage{}
		err = json.Unmarshal(pkt, &subMsg)
		if err != nil {
			return &models.ErrorResponse{Message: "Invalid request", Code: http.StatusBadRequest, Err: err}
		}
		if !ch.connector.CheckExistChannel(subMsg.IDDevice.IDDevice) {
			return &models.ErrorResponse{Message: "The device not exist", Code: http.StatusOK}
		}
		if ch.connector.CheckSubscribe(subMsg.IDDevice.IDDevice, ch.send) {
			return &models.ErrorResponse{Message: "You are already subscribed to this device", Code: http.StatusOK}
		}
		ch.connector.Subscribe(subMsg.IDDevice.IDDevice, ch.send)
		ch.SendResponse(models.RequestTypeInfo, requestHeader.Nonce, models.InfoResponse{Status: "Successful subscribe"})

	case "unsubscribe":
		unSubMsg := models.UnSubscribeMessage{}
		err = json.Unmarshal(pkt, &unSubMsg)
		if err != nil {
			return &models.ErrorResponse{Message: "Invalid request", Code: http.StatusBadRequest, Err: err}
		}
		if !ch.connector.CheckExistChannel(unSubMsg.IDDevice.IDDevice) {
			return &models.ErrorResponse{Message: "The device not exist", Code: http.StatusOK}
		}
		if !ch.connector.CheckSubscribe(unSubMsg.IDDevice.IDDevice, ch.send) {
			return &models.ErrorResponse{Message: "You are not subscribed to this device", Code: http.StatusOK}
		}
		ch.connector.UnSubscribe(unSubMsg.IDDevice.IDDevice, ch.send)
		ch.SendResponse(models.RequestTypeInfo, requestHeader.Nonce, models.InfoResponse{Status: "Successful unsubscribe"})

	case "historical":
		histMsg := models.HistoricalRequest{}
		err = json.Unmarshal(pkt, &histMsg)
		if err != nil {
			return &models.ErrorResponse{Message: "Invalid request", Code: http.StatusBadRequest, Err: err}
		}
		flags, err := ch.db.GetHistoricalData(histMsg.Filters, histMsg.Sort, histMsg.Limit, histMsg.Offset)
		if err != nil {
			return &models.ErrorResponse{Message: "Internal error", Code: http.StatusInternalServerError,
				Nonce: requestHeader.Nonce, Err: err}
		}
		ch.SendResponse("historical", requestHeader.Nonce, models.HistoricalResponse{Flags: flags})

	default:
		return &models.ErrorResponse{Message: "Unknown method type ", Code: http.StatusBadRequest, Nonce: requestHeader.Nonce}
	}

	return nil
}

func (ch *Channel) CheckReqLimit() bool {
	defer func() {
		ch.lastReqTime = time.Now()
	}()
	if ch.ban {
		if time.Since(ch.lastReqTime) > time.Minute {
			ch.ban = false
			return false
		}
		return true
	}

	currentSecond := time.Now().Second()
	if time.Since(ch.lastReqTime) > time.Second {
		ch.reqPerMinute[currentSecond] = ch.reqPerSecond
		ch.reqPerSecond = 0
	}
	ch.reqPerSecond++
	if ch.reqPerSecond > 5 {
		ch.ban = true
		return true
	}

	if sumIntArray(ch.reqPerMinute) > 150 {
		ch.ban = true
		return true
	}
	return false
}

func sumIntArray(a [60]int) int {
	var sum int
	for i := 0; i < 60; i++ {
		sum += a[i]
	}
	return sum
}
