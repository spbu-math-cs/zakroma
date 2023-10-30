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

	router.POST("/ration/create/:id/:order", handler.CreateRation)
	router.POST("/ration/save/:id/:order", handler.SaveRation)
	router.GET("/ration/:id/:order", handler.GetRation)
}
