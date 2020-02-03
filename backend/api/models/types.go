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
	*IDDevice
	StartTime             *int64   `json:"start_time"`
	EndTime               *int64   `json:"end_time"`
	TypeFlag              *int     `json:"type_flag"`
	Positions             *[]int64 `json:"positions"`
	ProbabilityCurrentMin *float64 `json:"probability_current_min"`
	ProbabilityCurrentMax *float64 `json:"probability_current_max"`
}

type SortFlags struct {
	Time        *int `json:"time"`
	Position    *int `json:"position"`
	Probability *int `json:"probability"`
}

type HistoricalRequest struct {
	Filters *Filters   `json:"filters"`
	Sort    *SortFlags `json:"sort"`
	Limit   int        `json:"limit"`
	Offset  int        `json:"offset"`
}

type FlagFields struct {
	IDDevice
	Time               Time      `json:"time"`
	TypeFlag           int       `json:"type_flag"`
	Positions          []float64 `json:"positions" gorm:"type:real[]"`
	CurrentPosition    int       `json:"current_position"`
	CurrentProbability float64   `json:"current_probability"`
	ImagePath          string    `json:"image_path"`
}

type HistoricalResponse struct {
	Flags *[]FlagFields `json:"flags"`
}

type DataMessageResponse struct {
	Type string `json:"type"`
	FlagFields
}

type DevicesListResponse struct {
	Devices []Device `json:"devices"`
}

type InfoResponse struct {
	Status string `json:"status"`
}

type ErrorResponse struct {
	Message string `json:"message"`
	Code    int    `json:"code"`
	Nonce   int64  `json:"-"`
	Err     error  `json:"-"`
}

func (e *ErrorResponse) Error() string {
	return e.Message + ": " + e.Err.Error()
}

type Time struct {
	time.Time
}

func (t Time) MarshalJSON() ([]byte, error) {
	return json.Marshal(t.Time.UnixNano() / 1000)
}
