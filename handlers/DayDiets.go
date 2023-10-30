package handlers

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
	"zakroma/schemas"
	"zakroma/stores"
)

type DayDietsHandler struct {
	DayDietsStore *stores.DayDietsStore
}

func CreateDayDietsHandler() *DayDietsHandler {
	return &DayDietsHandler{
		DayDietsStore: stores.CreateDayDietsStore(),
	}
}

func (handler *DayDietsHandler) CreateDayDiet(c *gin.Context) {
	id := handler.DayDietsStore.CreateDayDiet()

	c.JSON(http.StatusOK, gin.H{
		"id": id,
	})
}

func (handler *DayDietsHandler) SaveDayDiet(c *gin.Context) {
	var dayDiet schemas.DayDiet
	err := c.BindJSON(&dayDiet)
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	err = handler.DayDietsStore.SaveDayDiet(dayDiet)
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	c.Status(http.StatusOK)
}

func (handler *DayDietsHandler) GetDayDiet(c *gin.Context) {
	id, err := strconv.Atoi(c.Params.ByName("id"))
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	dayDiet, err := handler.DayDietsStore.GetDayDiet(id)
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	c.JSON(http.StatusOK, dayDiet)
}

func (handler *DayDietsHandler) CreateRation(c *gin.Context) {
	dayDietId, err := strconv.Atoi(c.Params.ByName("id"))
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	order, err := strconv.Atoi(c.Params.ByName("order"))
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	var ration schemas.Ration
	err = c.BindJSON(&ration)
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	err = handler.DayDietsStore.CreateRation(dayDietId, order, ration)
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	c.Status(http.StatusOK)
}

func (handler *DayDietsHandler) SaveRation(c *gin.Context) {
	dayDietId, err := strconv.Atoi(c.Params.ByName("id"))
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	order, err := strconv.Atoi(c.Params.ByName("order"))
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	var ration schemas.Ration
	err = c.BindJSON(&ration)
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	err = handler.DayDietsStore.SaveRation(dayDietId, order, ration)
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	c.Status(http.StatusOK)
}

func (handler *DayDietsHandler) GetRation(c *gin.Context) {
	dayDietId, err := strconv.Atoi(c.Params.ByName("id"))
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	order, err := strconv.Atoi(c.Params.ByName("order"))
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	ration, err := handler.DayDietsStore.GetRation(dayDietId, order)
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	c.JSON(http.StatusOK, ration)
}
