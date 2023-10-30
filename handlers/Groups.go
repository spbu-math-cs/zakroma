package handlers

import (
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
	"zakroma/schemas"
	"zakroma/stores"
)

type GroupsHandler struct {
	GroupsStore         *stores.GroupsStore
	GroupsMembersStore  *stores.GroupsMembersStore
	GroupsDayDietsStore *stores.GroupsDayDietsStore
}

func CreateGroupsHandler() *GroupsHandler {
	return &GroupsHandler{
		GroupsStore:         stores.CreateGroupsStore(),
		GroupsMembersStore:  stores.CreateGroupsMembersStore(),
		GroupsDayDietsStore: stores.CreateGroupsDayDietsStore(),
	}
}

func (handler *GroupsHandler) CreateGroup(c *gin.Context) {
	session := sessions.Default(c)
	userId, _ := strconv.Atoi(session.Get("id").(string))

	id := handler.GroupsStore.CreateGroup()

	handler.GroupsMembersStore.CreateGroup(id)
	err := handler.GroupsMembersStore.ChangeMemberRights(id, userId, handler.GroupsMembersStore.RightsCreator())
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"id": id,
	})
}

func (handler *GroupsHandler) SaveGroup(c *gin.Context) {
	session := sessions.Default(c)
	userId, _ := strconv.Atoi(session.Get("id").(string))

	var group schemas.Group
	err := c.BindJSON(&group)
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	if !handler.GroupsMembersStore.CheckRights(userId, group.Id, handler.GroupsMembersStore.RightsSaveGroup()) {
		c.String(http.StatusBadRequest,
			"user with id=%d do not have permission to save group with id=%d", userId, group.Id)
		return
	}

	err = handler.GroupsStore.SaveGroup(group)
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	c.Status(http.StatusOK)
}

func (handler *GroupsHandler) GetUserGroups(c *gin.Context) {
	session := sessions.Default(c)
	userId, _ := strconv.Atoi(session.Get("id").(string))
	groups := handler.GroupsMembersStore.GetUserGroups(userId)

	c.JSON(http.StatusOK, groups)
}

func (handler *GroupsHandler) AddMember(c *gin.Context) {
	session := sessions.Default(c)
	userId, _ := strconv.Atoi(session.Get("id").(string))

	var group schemas.Group
	err := c.BindJSON(&group)
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	if !handler.GroupsMembersStore.CheckRights(userId, group.Id, handler.GroupsMembersStore.RightsAddMember()) {
		c.String(http.StatusBadRequest,
			"user with id=%d do not have permission to save group with id=%d", userId, group.Id)
		return
	}

	memberId, err := strconv.Atoi(c.Params.ByName("id"))
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	err = handler.GroupsMembersStore.AddMember(group.Id, memberId)
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	c.Status(http.StatusOK)
}

func (handler *GroupsHandler) AddDayDiet(c *gin.Context) {
	session := sessions.Default(c)
	userId, _ := strconv.Atoi(session.Get("id").(string))

	groupId, err := strconv.Atoi(c.Params.ByName("group"))
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	if !handler.GroupsMembersStore.CheckRights(userId, groupId, handler.GroupsMembersStore.RightsSaveGroup()) {
		c.String(http.StatusBadRequest,
			"user with id=%d do not have permission to save group with id=%d", userId, groupId)
		return
	}

	date := c.Params.ByName("date")
	dayDietId, err := strconv.Atoi(c.Params.ByName("id"))
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	handler.GroupsDayDietsStore.SaveDayDiet(groupId, date, dayDietId)

	c.Status(http.StatusOK)
}

func (handler *GroupsHandler) GetDayDiet(c *gin.Context) {
	session := sessions.Default(c)
	userId, _ := strconv.Atoi(session.Get("id").(string))

	groupId, err := strconv.Atoi(c.Params.ByName("group"))
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	if !handler.GroupsMembersStore.CheckRights(userId, groupId, handler.GroupsMembersStore.RightsViewGroup()) {
		c.String(http.StatusBadRequest,
			"user with id=%d do not have permission to save group with id=%d", userId, groupId)
		return
	}

	date := c.Params.ByName("date")

	dayDiet, err := handler.GroupsDayDietsStore.GetDayDiet(groupId, date)
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	c.JSON(http.StatusOK, dayDiet)
}
