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

	router.POST("/diets/day/add/:group/:date/:id", handler.AddDayDiet)
	router.GET("/diets/day/:group/:date", handler.GetDayDiet)
}
