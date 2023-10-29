package schemas

type Meal struct {
	Id          int          `json:"id"`
	Name        string       `json:"name"`
	Calories    float32      `json:"calories"`
	Protein     float32      `json:"protein"`
	Fat         float32      `json:"fat"`
	Carbs       float32      `json:"carbs"`
	Tags        []string     `json:"tags"`
	Ingredients []Ingredient `json:"ingredients"`
	Recipe      string       `json:"recipe"`
}
