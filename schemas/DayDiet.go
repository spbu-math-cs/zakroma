package schemas

type DayDiet struct {
	Id      int      `json:"id"`
	TimeTag string   `json:"time-tag"`
	Rations []Ration `json:"rations"`
}
