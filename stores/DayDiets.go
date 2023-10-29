package stores

import (
	"fmt"
	"sync"
	"zakroma/schemas"
)

type DayDietsStore struct {
	sync.Mutex

	DayDiets map[int]schemas.DayDiet
	NextId   int
}

func CreateDayDietsStore() *DayDietsStore {
	DayDiets := make(map[int]schemas.DayDiet)

	return &DayDietsStore{DayDiets: DayDiets, NextId: 0}
}

func (store *DayDietsStore) GetDayDiet(id int) (schemas.DayDiet, error) {
	store.Lock()
	defer store.Unlock()

	m, ok := store.DayDiets[id]
	if ok {
		return m, nil
	} else {
		return schemas.DayDiet{}, fmt.Errorf("dayDiet with id=%d not found", id)
	}
}

func (store *DayDietsStore) CreateDayDiet() int {
	store.Lock()
	defer store.Unlock()

	store.DayDiets[store.NextId] = schemas.DayDiet{Id: store.NextId}
	store.NextId++

	return store.DayDiets[store.NextId].Id
}

func (store *DayDietsStore) SaveDayDiet(dayDiet schemas.DayDiet) error {
	store.Lock()
	defer store.Unlock()

	if _, ok := store.DayDiets[dayDiet.Id]; !ok {
		return fmt.Errorf("dayDiet with id=%d not found", dayDiet.Id)
	}

	store.DayDiets[dayDiet.Id] = dayDiet
	return nil
}

func (store *DayDietsStore) SaveRation(dayDietId int, order int, ration schemas.Ration) error {
	store.Lock()
	defer store.Unlock()

	_, ok := store.DayDiets[dayDietId]
	if !ok {
		return fmt.Errorf("dayDiet with id=%d not found", dayDietId)
	}

	dayDiet := store.DayDiets[dayDietId]

	for order >= len(dayDiet.Rations) {
		dayDiet.Rations = append(dayDiet.Rations, schemas.Ration{})
	}

	dayDiet.Rations[order] = ration
	store.DayDiets[dayDietId] = dayDiet

	return nil
}

func (store *DayDietsStore) GetRation(dayDietId int, order int) (schemas.Ration, error) {
	store.Lock()
	defer store.Unlock()

	m, ok := store.DayDiets[dayDietId]
	if !ok {
		return schemas.Ration{}, fmt.Errorf("dayDiet with id=%d not found", dayDietId)
	}

	if order >= len(m.Rations) {
		return schemas.Ration{}, fmt.Errorf("no such ration with order=%d in dayDiet=%d", order, dayDietId)
	}

	return m.Rations[order], nil
}
