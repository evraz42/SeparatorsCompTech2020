package logging

import (
	"evraz/SeparatorsCompTech2020/backend/api/models"
	"github.com/sirupsen/logrus"
	"time"
)

type dbLogHook struct {
	*models.DB
}

func (db *dbLogHook) Levels() []logrus.Level {
	return logrus.AllLevels
}

func NewDBHook(db *models.DB) *dbLogHook {
	return &dbLogHook{db}
}

type logEntry struct {
	Time    time.Time `json:"time"`
	Level   string    `json:"level"`
	Message string    `json:"message"`
}

func (db *dbLogHook) Fire(e *logrus.Entry) error {
	entry := logEntry{
		Time:    e.Time,
		Level:   e.Level.String(),
		Message: e.Message,
	}
	return db.
		Table("logs").
		Create(entry).
		Error
}
