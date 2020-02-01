package gpool

import (
	"github.com/pkg/errors"
	"time"
)

type Pool struct {
	work chan func()
	sem  chan struct{}
}

func NewPool(size int) *Pool {
	return &Pool{
		work: make(chan func()),
		sem:  make(chan struct{}, size),
	}
}

func (p *Pool) Schedule(task func()) {
	p.schedule(task, nil)
}

func (p *Pool) ScheduleTimeout(timeout time.Duration, task func()) error {
	return p.schedule(task, time.After(timeout))
}

func (p *Pool) schedule(task func(), timeout <-chan time.Time) error {
	select {
	case <-timeout:
		return errors.New("schedule error: timeout")
	case p.work <- task:
	case p.sem <- struct{}{}:
		go p.worker(task)
	}
	return nil
}

func (p *Pool) worker(task func()) {
	defer func() { <-p.sem }()
	for {
		task()
		task = <-p.work
	}
}
