package routing

import (
	"github.com/gin-gonic/gin"
	"zakroma/handlers"
)

func GroupsRouting(router *gin.RouterGroup) {
	handler := handlers.CreateGroupsHandler()

	router.GET("/", handler.GetUserGroups)

	router.POST("/create", handler.CreateGroup)
	router.POST("/save", handler.SaveGroup)

	router.POST("/member/add/:id", handler.AddMember)

	router.POST("/menu/add", handler.AddMenu)
	router.GET("/menu/:group/:date", handler.GetMenuByDate)
}
