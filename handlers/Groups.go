package handlers

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"zakroma/stores"
)

type GroupsHandler struct {
	GroupsStore        *stores.GroupsStore
	GroupsMembersStore *stores.GroupsMembersStore
}

func CreateGroupsHandler() *GroupsHandler {
	return &GroupsHandler{
		GroupsStore:        stores.CreateGroupsStore(),
		GroupsMembersStore: stores.CreateGroupsMembersStore(),
	}
}

func (handler *GroupsHandler) GetUserGroups(c *gin.Context) {
	c.Status(http.StatusNotImplemented)
}

func (handler *GroupsHandler) CreateGroup(c *gin.Context) {
	c.Status(http.StatusNotImplemented)
}

func (handler *GroupsHandler) AddMember(c *gin.Context) {
	c.Status(http.StatusNotImplemented)
}

func (handler *GroupsHandler) SaveMemberRole(c *gin.Context) {
	c.Status(http.StatusNotImplemented)
}

func (handler *GroupsHandler) GetMemberRole(c *gin.Context) {
	c.Status(http.StatusNotImplemented)
}

func (handler *GroupsHandler) AddMenu(c *gin.Context) {
	c.Status(http.StatusNotImplemented)
}

func (handler *GroupsHandler) GetMenuByDate(c *gin.Context) {
	c.Status(http.StatusNotImplemented)
}
