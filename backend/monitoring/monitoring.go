package monitoring

import (
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"net/http"
)

type Monitoring struct {
	WsConnections prometheus.Gauge
}

func (m *Monitoring) Run(address string) error {
	m.WsConnections = prometheus.NewGauge(
		prometheus.GaugeOpts{
			Name: "ws_connections",
		})
	err := prometheus.Register(m.WsConnections)
	if err != nil {
		return err
	}

	http.Handle("/metrics", promhttp.Handler())

	if err := http.ListenAndServe(address, nil); err != nil {
		return err
	}
	return nil
}
