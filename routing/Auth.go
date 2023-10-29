package routing

import (
	"github.com/gin-gonic/gin"
	"zakroma/handlers"
)

func AuthRouting(router *gin.RouterGroup) {
	handler := handlers.CreateAuthHandler()

	router.POST("/login", handler.Login)
}
