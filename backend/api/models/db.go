package models

import (
	"github.com/jinzhu/gorm"
	"github.com/lib/pq"
	log "github.com/sirupsen/logrus"
	"time"
)

type Database interface {
	GetHistoricalData(filters *Filters, sort *SortFlags, limit int, offset int) (*[]FlagFields, error)
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

func (db *DB) GetHistoricalData(filters *Filters, sort *SortFlags, limit int, offset int) (*[]FlagFields, error) {
	query := db.Table("flags").Select("id_device, time, type_flag, positions, image_path, current_position, current_probability")
	if filters != nil {
		if filters.IDDevice != nil {
			query = query.Where("id_device = $1", filters.IDDevice.IDDevice)
		}
		if filters.StartTime != nil {
			query = query.Where("time >= $1", time.Unix(0, *filters.StartTime))
		}
		if filters.EndTime != nil {
			query = query.Where("time <= $1", time.Unix(0, *filters.EndTime))
		}
		if filters.TypeFlag != nil && *filters.TypeFlag != 0 {
			query = query.Where("type_flag = $1", filters.TypeFlag)
		}
		if filters.Positions != nil {
			query = query.Where("current_position = ANY($1)", filters.Positions)
		}
		if filters.ProbabilityCurrentMax != nil {
			query = query.Where("current_probability <= $1", filters.ProbabilityCurrentMax)
		}
		if filters.ProbabilityCurrentMin != nil {
			query = query.Where("current_probability >= $1", filters.ProbabilityCurrentMin)
		}
	}

	if sort != nil {
		if sort.Time != nil {
			if *sort.Time == 0 {
				query = query.Order("time")
			} else {
				query = query.Order("time DESC")
			}
		}
		if sort.Position != nil {
			if *sort.Position == 0 {
				query = query.Order("current_position")
			} else {
				query = query.Order("current_position DESC")
			}
		}
		if sort.Probability != nil {
			if *sort.Probability == 0 {
				query = query.Order("current_probability")
			} else {
				query = query.Order("current_probability DESC")
			}
		}
	}

	var flags []FlagFields

	rows, err := query.
		Limit(limit).
		Offset(offset).
		Rows()
	if err != nil {
		return nil, err
	}
	defer func() {
		err = rows.Close()
		if err != nil {
			log.Error(err)
		}
	}()

	for rows.Next() {
		flag := FlagFields{}
		positions := pq.Float64Array{}
		err = rows.Scan(&flag.IDDevice.IDDevice, &flag.Time.Time, &flag.TypeFlag, &positions, &flag.ImagePath, &flag.CurrentPosition, &flag.CurrentProbability)
		if err != nil {
			return nil, err
		}
		flag.Positions = positions
		flags = append(flags, flag)
	}

	return &flags, nil
}
