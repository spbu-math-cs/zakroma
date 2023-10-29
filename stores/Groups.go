package stores

import (
	"sync"
	"zakroma/schemas"
)

type GroupsStore struct {
	sync.Mutex

	Groups map[int]schemas.Group
	NextId int
}

func CreateGroupsStore() *GroupsStore {
	return &GroupsStore{Groups: make(map[int]schemas.Group), NextId: 0}
}
