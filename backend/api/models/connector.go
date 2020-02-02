package models

import (
	"sync"
)

type Connector struct {
	receiveData chan FlagFields
	mutex       sync.RWMutex
	subscribers map[string][]chan<- interface{}

	subscribersIndex   map[string]map[chan<- interface{}]int
	reverseSubscribers map[chan<- interface{}][]string
}

func NewConnector() *Connector {
	return &Connector{
		mutex:              sync.RWMutex{},
		subscribers:        make(map[string][]chan<- interface{}),
		subscribersIndex:   make(map[string]map[chan<- interface{}]int),
		reverseSubscribers: make(map[chan<- interface{}][]string),
		receiveData:        make(chan FlagFields),
	}
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
	c.subscribersIndex[channel][send] = len(c.subscribers) - 1
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
}

func (c *Connector) UnSubscribeAll(send chan<- interface{}) {
	for _, channel := range c.reverseSubscribers[send] {
		c.UnSubscribe(channel, send)
	}
}

func (c *Connector) Run() {
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
	_, ok := c.subscribersIndex[channel][send]
	return ok
}
