package schemas

type RationMeal struct {
	Meal     Meal    `json:"meal"`
	Portions float64 `json:"portions"`
}
