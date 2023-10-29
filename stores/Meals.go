package stores

import (
	"fmt"
	"sync"
	"zakroma/schemas"
)

type MealsStore struct {
	sync.Mutex

	Meals  map[int]schemas.Meal
	NextId int
}

func CreateMealsStore() *MealsStore {
	store := &MealsStore{Meals: make(map[int]schemas.Meal), NextId: 0}

	store.Lock()
	defer store.Unlock()

	store.Meals[0] = schemas.Meal{
		Id:       0,
		Name:     "Омлет с овощами",
		Calories: 350,
		Protein:  20,
		Fat:      10,
		Carbs:    45,
		Tags: []string{
			"завтрак",
			"омлет",
		},
		Ingredients: []schemas.Ingredient{
			{
				Name:              "Яйцо",
				Amount:            2,
				UnitOfMeasurement: "шт",
			},
			{
				Name:              "Помидор",
				Amount:            50,
				UnitOfMeasurement: "г",
			},
			{
				Name:              "Перец",
				Amount:            50,
				UnitOfMeasurement: "г",
			},
			{
				Name:              "Лук",
				Amount:            20,
				UnitOfMeasurement: "г",
			},
			{
				Name: "Специи",
			},
			{
				Name: "Соль",
			},
		},
		Recipe: "Взбейте яйца, нарежьте овощи, обжарьте их в сковороде, добавьте яйца и готовьте до затвердения.",
	}

	store.Meals[1] = schemas.Meal{
		Id:       1,
		Name:     "Фруктовый салат с орехами",
		Calories: 250,
		Protein:  5,
		Fat:      8,
		Carbs:    45,
		Tags: []string{
			"завтрак",
			"салат",
			"легкий",
			"фрукты",
		},
		Ingredients: []schemas.Ingredient{
			{
				Name:              "Апельсин",
				Amount:            2,
				UnitOfMeasurement: "шт",
			},
			{
				Name:              "Банан",
				Amount:            2,
				UnitOfMeasurement: "шт",
			},
			{
				Name:              "Грецкий орех",
				Amount:            30,
				UnitOfMeasurement: "г",
			},
		},
		Recipe: "Нарежьте фрукты и орехи, смешайте их в салате.",
	}

	store.Meals[2] = schemas.Meal{
		Id:       2,
		Name:     "Куриный салат Цезарь",
		Calories: 400,
		Protein:  25,
		Fat:      20,
		Carbs:    35,
		Tags: []string{
			"обед",
			"салат",
			"легкий",
		},
		Ingredients: []schemas.Ingredient{
			{
				Name:              "Куриное филе",
				Amount:            150,
				UnitOfMeasurement: "г",
			},
			{
				Name:              "Салат Романо",
				Amount:            50,
				UnitOfMeasurement: "г",
			},
			{
				Name:              "Гренки",
				Amount:            40,
				UnitOfMeasurement: "г",
			},
			{
				Name:              "Пармезан",
				Amount:            30,
				UnitOfMeasurement: "г",
			},
			{
				Name:              "Соус Цезарь",
				Amount:            30,
				UnitOfMeasurement: "г",
			},
		},
		Recipe: "Обжарьте куриную грудку, нарежьте ее, смешайте с салатом, гренками, сыром и соусом.",
	}

	store.Meals[3] = schemas.Meal{
		Id:       3,
		Name:     "Лосось с картофельным пюре и шпинатом",
		Calories: 450,
		Protein:  30,
		Fat:      20,
		Carbs:    35,
		Tags: []string{
			"обед",
			"рыба",
			"легкий",
		},
		Ingredients: []schemas.Ingredient{
			{
				Name:              "Филе лосося",
				Amount:            150,
				UnitOfMeasurement: "г",
			},
			{
				Name:              "Картофельное пюре",
				Amount:            150,
				UnitOfMeasurement: "г",
			},
			{
				Name:              "Шпинат",
				Amount:            100,
				UnitOfMeasurement: "г",
			},
			{
				Name: "Лимонный сок",
			},
			{
				Name: "Масло",
			},
			{
				Name: "Соль",
			},
		},
		Recipe: "Запеките лосось с лимонным соком, подавайте с картофельным пюре и обжаренным шпинатом.",
	}

	store.Meals[4] = schemas.Meal{
		Id:       4,
		Name:     "Курица с киноа и зеленью",
		Calories: 380,
		Protein:  25,
		Fat:      10,
		Carbs:    45,
		Tags: []string{
			"ужин",
			"курица",
			"легкий",
		},
		Ingredients: []schemas.Ingredient{
			{
				Name:              "Куриное филе",
				Amount:            150,
				UnitOfMeasurement: "г",
			},
			{
				Name:              "Киноа",
				Amount:            100,
				UnitOfMeasurement: "г",
			},
			{
				Name:              "Петрушка",
				Amount:            30,
				UnitOfMeasurement: "г",
			},
			{
				Name: "Лимонный сок",
			},
			{
				Name: "Масло",
			},
			{
				Name: "Соль",
			},
		},
		Recipe: "Обжарьте курицу, приготовьте киноа, смешайте с петрушкой и лимонным соком.",
	}

	store.Meals[5] = schemas.Meal{
		Id:       5,
		Name:     "Паста с томатным соусом и брокколи",
		Calories: 360,
		Protein:  12,
		Fat:      8,
		Carbs:    60,
		Tags: []string{
			"ужин",
			"паста",
		},
		Ingredients: []schemas.Ingredient{
			{
				Name:              "Спагетти",
				Amount:            100,
				UnitOfMeasurement: "г",
			},
			{
				Name:              "Томатный соус",
				Amount:            150,
				UnitOfMeasurement: "г",
			},
			{
				Name:              "Брокколи",
				Amount:            50,
				UnitOfMeasurement: "г",
			},
			{
				Name:              "Пармезан",
				Amount:            30,
				UnitOfMeasurement: "г",
			},
			{
				Name: "Оливковое масло",
			},
			{
				Name: "Специи",
			},
		},
		Recipe: "Варите спагетти, приготовьте томатный соус с брокколи и смешайте с пастой.",
	}

	store.NextId = 6

	return store
}

func (store *MealsStore) GetMealsWithTags(tags []string) []schemas.Meal {
	store.Lock()
	defer store.Unlock()

	var meals []schemas.Meal

	for id := range store.Meals {
		k := 0
		for i := range tags {
			flag := false
			for j := range store.Meals[id].Tags {
				if tags[i] == store.Meals[id].Tags[j] {
					flag = true
				}
			}
			if flag {
				k += 1
			}
		}

		if k == len(tags) {
			meals = append(meals, store.Meals[id])
		}
	}

	return meals
}

func getMealShort(meal schemas.Meal) schemas.Meal {
	return schemas.Meal{
		Id:       meal.Id,
		Name:     meal.Name,
		Calories: meal.Calories,
		Protein:  meal.Protein,
		Fat:      meal.Fat,
		Carbs:    meal.Carbs,
	}
}

func (store *MealsStore) GetMealsShortWithTags(tags []string) []schemas.Meal {
	store.Lock()
	defer store.Unlock()

	var mealsShort []schemas.Meal

	for id := range store.Meals {
		k := 0
		for i := range tags {
			flag := false
			for j := range store.Meals[id].Tags {
				if tags[i] == store.Meals[id].Tags[j] {
					flag = true
				}
			}
			if flag {
				k += 1
			}
		}
		if k == len(tags) {
			mealsShort = append(mealsShort, getMealShort(store.Meals[id]))
		}
	}

	return mealsShort
}

func (store *MealsStore) GetMealShortWithId(id int) (schemas.Meal, error) {
	store.Lock()
	defer store.Unlock()

	m, ok := store.Meals[id]
	if ok {
		return getMealShort(m), nil
	} else {
		return schemas.Meal{}, fmt.Errorf("meal with id=%d not found", id)
	}
}

func (store *MealsStore) GetMealWithId(id int) (schemas.Meal, error) {
	store.Lock()
	defer store.Unlock()

	m, ok := store.Meals[id]
	if ok {
		return m, nil
	} else {
		return schemas.Meal{}, fmt.Errorf("meal with id=%d not found", id)
	}
}
