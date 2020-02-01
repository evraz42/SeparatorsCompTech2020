package models

import (
	"github.com/jinzhu/gorm"
)

type Database interface {
	GetHistoricalData(filters Filters)
	GetDevices() ([]Devices, error)
}

type DB struct {
	*gorm.DB
}

func NewDB(param string) (*DB, error) {
	db, err := gorm.Open("postgres", param)
	if err != nil {
		return nil, err
	}

	err = db.DB().Ping()
	if err != nil {
		return nil, err
	}
	return &DB{db}, nil
}

func (db *DB) GetHistoricalData(filters Filters) {

}
