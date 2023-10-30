package stores

import (
	"fmt"
	"sync"
)

type GroupsMembersStore struct {
	sync.Mutex

	Rights map[int]map[int]int // Rights[<GroupId>][<UserId>] = RightsMask
}

func CreateGroupsMembersStore() *GroupsMembersStore {
	return &GroupsMembersStore{Rights: make(map[int]map[int]int)}
}

func (store *GroupsMembersStore) RightsViewGroup() int {
	return 1 << 0
}

func (store *GroupsMembersStore) RightsSaveGroup() int {
	return 1 << 1
}

func (store *GroupsMembersStore) RightsAddMember() int {
	return 1 << 2
}

func (store *GroupsMembersStore) RightsCreator() int {
	return store.RightsViewGroup() |
		store.RightsSaveGroup() |
		store.RightsAddMember()
}

func (store *GroupsMembersStore) CreateGroup(groupId int) {
	store.Lock()
	defer store.Unlock()

	store.Rights[groupId] = make(map[int]int)
}

func (store *GroupsMembersStore) ChangeMemberRights(groupId int, memberId int, rights int) error {
	if _, ok := store.Rights[groupId]; !ok {
		return fmt.Errorf("group with id=%d does not exist", groupId)
	}
	if _, ok := store.Rights[groupId]; !ok {
		store.Rights[groupId][memberId] = 0
	}
	store.Rights[groupId][memberId] |= rights

	return nil
}

func (store *GroupsMembersStore) CheckRights(userId int, groupId int, rightBit int) bool {
	store.Lock()
	defer store.Unlock()

	userGroupRights, ok := store.Rights[groupId][userId]
	if !ok {
		return false
	}

	return (userGroupRights >> rightBit) & 1
}

func (store *GroupsMembersStore) GetUserGroups(userId int) [][]int {
	store.Lock()
	defer store.Unlock()

	ans := make([][]int, 0)
	for groupId, rights := range store.Rights {
		right, ok := rights[userId]
		if !ok {
			continue
		}
		curr := make([]int, 2)
		curr[0] = groupId
		curr[1] = right
		ans = append(ans, curr)
	}

	return ans
}

func (store *GroupsMembersStore) AddMember(groupId int, memberId int) error {
	return store.ChangeMemberRights(groupId, memberId, store.RightsViewGroup())
}
