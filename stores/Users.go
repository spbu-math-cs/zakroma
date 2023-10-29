package stores

import (
	"fmt"
	"sync"
	"zakroma/schemas"
)

type UsersStore struct {
	sync.Mutex

	Users  map[int]schemas.User
	NextId int
}

func CreateUsersStore() *UsersStore {
	store := &UsersStore{Users: make(map[int]schemas.User), NextId: 0}

	store.Lock()
	defer store.Unlock()

	store.Users[0] = schemas.User{
		Username: "admin",
		Password: "milka",
	}
	store.NextId = 1

	return store
}

func (store *UsersStore) ValidateUser(username string, password string) (int, error) {
	store.Lock()
	defer store.Unlock()

	for id := range store.Users {
		if store.Users[id].Username == username {
			if store.Users[id].Username == password {
				return id, nil
			}
			return -1, fmt.Errorf("incorrect password")
		}
	}

	return -1, fmt.Errorf("cannot find user with username=%s", username)
}
