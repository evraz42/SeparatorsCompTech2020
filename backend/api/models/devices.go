package models

import "github.com/google/uuid"

type Devices struct {
	ID           uuid.UUID `json:"id_device" gorm:"column:id_device"`
	Name         string    `json:"name_device" gorm:"column:name_device"`
	NumberDevice int       `json:"number_device"`
}

func (db *DB) GetDevices() ([]Devices, error) {
	var devices []Devices
	err := db.
		Find(&devices).
		Error

	if err != nil {
		return nil, err
	}

	return devices, nil
}
