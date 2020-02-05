package pools

import (
	"github.com/gobwas/ws/wsutil"
	"sync"
)

type ReaderPool struct {
	sync.Pool
}

func NewReaderPool() *ReaderPool {
	return &ReaderPool{
		Pool: sync.Pool{
			New: func() interface{} {
				return new(wsutil.Reader)
			},
		},
	}
}
