package routing

import (
	"github.com/gin-gonic/gin"
	"zakroma/handlers"
)

func MealsRouting(router *gin.RouterGroup) {
	handler := handlers.CreateMealsHandler()

	router.GET("/full/id/:id", handler.GetMealById)

	router.GET("/short/id/:id", handler.GetMealShortById)
	router.GET("/short/tags/:tags", handler.GetMealsShortByTags)
}
