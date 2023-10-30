package stores

import (
	"fmt"
	"sync"
)

type GroupsDayDietsStore struct {
	sync.Mutex

	DayDiets map[int]map[string]int // DayDiets[<GroupId>][<Date>] = DayDietId
}

func CreateGroupsDayDietsStore() *GroupsDayDietsStore {
	return &GroupsDayDietsStore{DayDiets: make(map[int]map[string]int)}
}

func (store *GroupsDayDietsStore) GetDay(groupId int, date string) (int, error) {
	store.Lock()
	defer store.Unlock()

	id, ok := store.DayDiets[groupId][date]
	if ok {
		return id, nil
	} else {
		return -1, fmt.Errorf("dayDiet with groupId=%d and date=%s not found", groupId, date)
	}
}

func (store *GroupsDayDietsStore) SaveMenuIdByDate(groupId int, date string, dayDietId int) {
	store.Lock()
	defer store.Unlock()

	groupDayDiets, ok := store.DayDiets[groupId]
	if !ok {
		store.DayDiets[groupId] = make(map[string]int)
		groupDayDiets = store.DayDiets[groupId]
	}
	groupDayDiets[date] = dayDietId
}
