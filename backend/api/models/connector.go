package models

import (
	log "github.com/sirupsen/logrus"
	"sync"
)

type Connector struct {
	receiveData chan FlagFields
	mutex       sync.RWMutex
	subscribers map[string][]chan<- interface{}

	subscribersIndex   map[string]map[chan<- interface{}]int
	reverseSubscribers map[chan<- interface{}][]string
}

func NewConnector(channels []string) *Connector {
	c := &Connector{
		mutex:              sync.RWMutex{},
		subscribers:        make(map[string][]chan<- interface{}),
		subscribersIndex:   make(map[string]map[chan<- interface{}]int),
		reverseSubscribers: make(map[chan<- interface{}][]string),
		receiveData:        make(chan FlagFields),
	}
	for _, channel := range channels {
		c.subscribers[channel] = make([]chan<- interface{}, 0)
	}
	return c
}

func (c *Connector) Subscribe(channel string, send chan<- interface{}) {
	c.mutex.Lock()
	defer c.mutex.Unlock()

	if _, ok := c.subscribers[channel]; !ok {
		c.subscribers[channel] = make([]chan<- interface{}, 0, 1)
	}
	if _, ok := c.subscribersIndex[channel]; !ok {
		c.subscribersIndex[channel] = make(map[chan<- interface{}]int)
	}

	c.subscribers[channel] = append(c.subscribers[channel], send)
	c.subscribersIndex[channel][send] = len(c.subscribers[channel]) - 1
	c.reverseSubscribers[send] = append(c.reverseSubscribers[send], channel)
}

func (c *Connector) UnSubscribe(channel string, send chan<- interface{}) {
	c.mutex.Lock()
	defer c.mutex.Unlock()

	if _, ok := c.subscribers[channel]; !ok {
		return
	}
	if _, ok := c.subscribersIndex[channel]; !ok {
		return
	}

	index, ok := c.subscribersIndex[channel][send]
	if !ok {
		return
	}

	c.subscribers[channel][index] = c.subscribers[channel][len(c.subscribers[channel])-1]
	c.subscribers[channel] = c.subscribers[channel][:len(c.subscribers[channel])-1]

	if len(c.subscribers[channel]) != 0 && len(c.subscribers[channel]) != index {
		c.subscribersIndex[channel][c.subscribers[channel][index]] = index
	}
	delete(c.subscribersIndex[channel], send)

	for i := range c.reverseSubscribers[send] {
		if c.reverseSubscribers[send][i] == channel {
			c.reverseSubscribers[send][i] = c.reverseSubscribers[send][len(c.reverseSubscribers[send])-1]
			c.reverseSubscribers[send] = c.reverseSubscribers[send][:len(c.reverseSubscribers[send])-1]
			break
		}
	}

	if len(c.reverseSubscribers[send]) == 0 {
		delete(c.reverseSubscribers, send)
	}
}

func (c *Connector) UnSubscribeAll(send chan<- interface{}) {
	c.mutex.RLock()
	channels := c.reverseSubscribers[send]
	c.mutex.RUnlock()
	for _, channel := range channels {
		c.UnSubscribe(channel, send)
	}
}

func (c *Connector) Run() {
	defer func() {
		if r := recover(); r != nil {
			log.Error(r)
		}
	}()
	msg := DataMessageResponse{
		Type: "data_message",
	}
	for {
		select {
		case dataMsg := <-c.receiveData:
			msg.FlagFields = dataMsg
			c.mutex.RLock()
			for i := range c.subscribers[dataMsg.IDDevice.IDDevice] {
				c.subscribers[dataMsg.IDDevice.IDDevice][i] <- msg
			}
			c.mutex.RUnlock()
		}
	}
}

func (c *Connector) GetChannel() chan<- FlagFields {
	return c.receiveData
}

func (c *Connector) CheckSubscribe(channel string, send chan<- interface{}) bool {
	c.mutex.RLock()
	defer c.mutex.RUnlock()
	_, ok := c.subscribersIndex[channel][send]
	return ok
}

func (c *Connector) CheckExistChannel(channel string) bool {
	c.mutex.RLock()
	defer c.mutex.RUnlock()
	_, ok := c.subscribers[channel]
	return ok
}
