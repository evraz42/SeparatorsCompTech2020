package models

import (
	"encoding/json"
	"time"
)

const RequestTypeInfo = "info"

type RequestHeader struct {
	Type  string `json:"type"`
	Nonce int64  `json:"nonce"`
}

type ResponseHeader struct {
	Type     string `json:"type"`
	NonceReq int64  `json:"nonce_req"`
}

type ResponseBody interface{}

type Response struct {
	ResponseHeader
	ResponseBody `json:"body"`
}

type IDDevice struct {
	IDDevice string `json:"id_device"`
}

type SubscribeMessage struct {
	IDDevice
}

type UnSubscribeMessage struct {
	IDDevice
}

type Filters struct {
	IDDevice
	StartTime             int64   `json:"start_time"`
	EndTime               int64   `json:"end_time"`
	TypeFlag              int     `json:"type_flag"`
	Positions             []int   `json:"positions"`
	ProbabilityCurrentMin float64 `json:"probability_current_min"`
	ProbabilityCurrentMax float64 `json:"probability_current_max"`
}

type HistoricalRequest struct {
	Filters
}

type DataFields struct {
	IDDevice
	Time      Time      `json:"time"`
	TypeFlag  int       `json:"type_flag"`
	Positions []float64 `json:"position"`
	ImagePath string    `json:"image_path"`
}

type HistoricalResponse struct {
	Data []DataFields `json:"data"`
}

type DataMessageResponse struct {
	DataFields
}

type DevicesListResponse struct {
	Devices []Devices `json:"devices"`
}

type InfoResponse struct {
	Status string `json:"status"`
}

type ErrorResponse struct {
	Message string `json:"message"`
	Code    int    `json:"code"`
	Nonce   int64  `json:"-"`
}

func (e *ErrorResponse) Error() string {
	return e.Message
}

type Time struct {
	time.Time
}

func (t Time) MarshalJSON() ([]byte, error) {
	return json.Marshal(t.Time.Unix())
}
