package schemas

type User struct {
	Username   string `json:"username"`
	Password   string `json:"password"`
	OwnGroupId int    `json:"own-group-id"`
}
