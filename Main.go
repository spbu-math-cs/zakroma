package main

import (
	"github.com/gin-contrib/sessions"
	"github.com/gin-contrib/sessions/cookie"
	"github.com/gin-gonic/gin"
	"zakroma/middleware"
	"zakroma/routing"
)

func setupSession(router *gin.Engine) {
	cookieStore := cookie.NewStore(secret)
	cookieStore.Options(sessions.Options{MaxAge: 60 * 60 * 24}) // expire in a day
	router.Use(sessions.Sessions("zakroma_session", cookie.NewStore(secret)))
}

func runHttp(router *gin.Engine) {
	err := router.Run(":8080")
	if err != nil {
		return
	}
}

var secret = []byte("zakrooooooma_secreeeeet")

func main() {
	router := gin.Default()
	router.Use(gin.Recovery())

	setupSession(router)

	routing.AuthRouting(router.Group("/auth"))
	routing.MealsRouting(router.Group("/meals", middleware.Auth))
	routing.DayDietsRouting(router.Group("/diets/day", middleware.Auth))

	runHttp(router)
}
