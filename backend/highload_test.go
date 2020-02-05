package main

import (
	"encoding/json"
	"fmt"
	"golang.org/x/net/websocket"
	"testing"
	"time"
)

func Test(t *testing.T) {
	t.Run("Test1000Connections", func(t *testing.T) {
		var (
			err error
		)
		subReq := struct {
			Type     string `json:"type"`
			Nonce    int64  `json:"nonce"`
			IDDevice string `json:"id_device"`
		}{
			Type:     "subscribe",
			Nonce:    1,
			IDDevice: "328a88bb-ede2-40e3-85a6-a6c685de9b84",
		}
		subReqJSON, err := json.Marshal(&subReq)
		if err != nil {
			t.Error(err)
		}
		conns := make([]*websocket.Conn, 1000)
		for i := 0; i < 1000; i++ {
			conns[i], err = websocket.Dial("ws://ec2-35-169-150-209.compute-1.amazonaws.com:2092/api/v1", "", "http://ec2-35-169-150-209.compute-1.amazonaws.com/")
			if err != nil {
				t.Error(err, i)
				return
			}
			fmt.Println("connect", i)

			_, err = conns[i].Write(subReqJSON)
			if err != nil {
				t.Error(err)
				return
			}
		}
		time.Sleep(time.Second * 5)
	})
}
