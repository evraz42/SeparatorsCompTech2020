package models

import "github.com/google/uuid"

type Device struct {
	ID           uuid.UUID `json:"id_device" gorm:"column:id_device"`
	Name         string    `json:"name_device" gorm:"column:name_device"`
	NumberDevice int       `json:"number_device"`
}

type Devices []Device

func (db *DB) GetDevices() (Devices, error) {
	var devices Devices
	err := db.
		Find(&devices).
		Error

	if err != nil {
		return nil, err
	}

	return devices, nil
}

func (d *Devices) GetIDs() []string {
	devicesIDs := make([]string, len(*d))
	for i, name := range *d {
		devicesIDs[i] = name.ID.String()
	}
	return devicesIDs
}
