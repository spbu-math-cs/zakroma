package schemas

type Ingredient struct {
	ProductId         int    `json:"product-id"`
	Name              string `json:"name"`
	Amount            int    `json:"amount"`
	UnitOfMeasurement string `json:"unit-of-measurement"`
}
