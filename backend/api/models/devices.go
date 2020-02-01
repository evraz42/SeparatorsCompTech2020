package models

type Devices struct {
	ID           int    `json:"id_device" gorm:"id_device"`
	Name         string `json:"name_device" gorm:"name_device"`
	NumberDevice int    `json:"number_device" `
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
