package routing

import (
	"github.com/gin-gonic/gin"
	"zakroma/handlers"
)

func DayDietsRouting(router *gin.RouterGroup) {
	handler := handlers.CreateDayDietsHandler()

	router.POST("/create", handler.CreateDayDiet)
	router.POST("/save", handler.SaveDayDiet)
	router.GET("/:id", handler.GetDayDiet)

	router.POST("/ration/save", handler.SaveRation)
	router.GET("/ration/:id/:order", handler.GetRation)
}
