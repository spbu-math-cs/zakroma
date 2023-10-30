package schemas

type Ration struct {
	Name  string       `json:"name"`
	Meals []RationMeal `json:"meals"`
}
