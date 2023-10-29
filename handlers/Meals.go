package handlers

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
	"strings"
	"zakroma/stores"
)

type MealsHandler struct {
	MealsStore *stores.MealsStore
}

func CreateMealsHandler() *MealsHandler {
	return &MealsHandler{
		MealsStore: stores.CreateMealsStore(),
	}
}

func (handler *MealsHandler) GetMealsShortByTags(c *gin.Context) {
	tagsStr := c.Params.ByName("tags")
	tags := strings.Split(tagsStr, "$")

	meals := handler.MealsStore.GetMealsShortWithTags(tags)

	c.JSON(http.StatusOK, meals)
}

func (handler *MealsHandler) GetMealShortById(c *gin.Context) {
	id, err := strconv.Atoi(c.Params.ByName("id"))
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	meal, err := handler.MealsStore.GetMealShortWithId(id)
	if err != nil {
		c.String(http.StatusNotFound, err.Error())
		return
	}

	c.JSON(http.StatusOK, meal)
}

func (handler *MealsHandler) GetMealById(c *gin.Context) {
	id, err := strconv.Atoi(c.Params.ByName("id"))
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	meal, err := handler.MealsStore.GetMealWithId(id)
	if err != nil {
		c.String(http.StatusNotFound, err.Error())
		return
	}

	c.JSON(http.StatusOK, meal)
}
