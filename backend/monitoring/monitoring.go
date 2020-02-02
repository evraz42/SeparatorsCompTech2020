package monitoring

import (
	"github.com/prometheus/client_golang/prometheus/promhttp"
	log "github.com/sirupsen/logrus"
	"net/http"
)

type Monitoring struct {
}

func (m *Monitoring) Run() {
	http.Handle("/metrics", promhttp.Handler())

	for {
		if err := http.ListenAndServe(":2112", nil); err != nil {
			log.Error(err)
		}

	}
}
