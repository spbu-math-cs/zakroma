package stores

import (
	"fmt"
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

func (store *GroupsStore) CreateGroup() int {
	store.Lock()
	defer store.Unlock()

	store.Groups[store.NextId] = schemas.Group{Id: store.NextId}
	store.NextId++

	return store.Groups[store.NextId-1].Id
}

func (store *GroupsStore) SaveGroup(group schemas.Group) error {
	store.Lock()
	defer store.Unlock()

	if _, ok := store.Groups[group.Id]; !ok {
		return fmt.Errorf("group with id=%d not found", group.Id)
	}

	store.Groups[group.Id] = group
	return nil
}
