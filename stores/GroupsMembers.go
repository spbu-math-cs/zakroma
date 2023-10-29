package stores

import "sync"

type GroupsMembersStore struct {
	sync.Mutex

	Rights map[int]map[int]int // Menus[<GroupId>][<UserId>] = RightsMask
}

func CreateGroupsMembersStore() *GroupsMembersStore {
	return &GroupsMembersStore{Rights: make(map[int]map[int]int)}
}
