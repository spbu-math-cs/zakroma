package routing

import (
	"github.com/gin-gonic/gin"
	"zakroma/handlers"
)

func GroupsRouting(router *gin.RouterGroup) {
	handler := handlers.CreateGroupsHandler()

	router.GET("/", handler.GetUserGroups)

	router.POST("/create", handler.CreateGroup)

	router.POST("/member/add", handler.AddMember)
	router.POST("/member/change", handler.SaveMemberRole)
	router.GET("/member/:group/:user", handler.GetMemberRole)

	router.POST("/menu/add", handler.AddMenu)
	router.GET("/menu/:group/:date", handler.GetMenuByDate)
}
