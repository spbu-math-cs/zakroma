package handlers

import (
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
	"net/http"
	"zakroma/middleware"
	"zakroma/schemas"
	"zakroma/stores"
)

type AuthHandler struct {
	UsersStore *stores.UsersStore
	Tokens     []string
}

func CreateAuthHandler() *AuthHandler {
	return &AuthHandler{
		UsersStore: stores.CreateUsersStore(),
		Tokens:     make([]string, 0),
	}
}

func (handler *AuthHandler) generateToken(username string) (string, error) {
	token, _ := middleware.GenerateJWT(username)
	handler.Tokens = append(handler.Tokens, token)

	return token, nil
}

func (handler *AuthHandler) Login(c *gin.Context) {
	var user schemas.User
	err := c.BindJSON(&user)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
			"message": err.Error(),
		})
		return
	}

	id, err := handler.UsersStore.ValidateUser(user.Username, user.Password)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
			"message": err.Error(),
		})
		return
	}

	session := sessions.Default(c)
	session.Set("id", id)
	if err := session.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": "Failed to save session",
		})
		return
	}

	token, err := handler.generateToken(user.Username)

	c.JSON(http.StatusOK, gin.H{
		"token": token,
	})
}
