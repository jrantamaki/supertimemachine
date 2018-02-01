package service

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
	"supertimemachine/model"
)

// This is the "datasource" for now :)
var Data *[]model.Task;

func AddNewTaskHandler(c *gin.Context){
	var task model.Task
	c.BindJSON(&task)

	AddNewTask(task, Data)

	c.JSON(http.StatusOK, task)
}

func GetTaskHandler(c *gin.Context){
	id :=  c.Param("id")
	i, err := strconv.Atoi(id)

	if err != nil { //FIXME there must be a better way to validate the parameter, that it is an int.
		c.JSON(http.StatusBadRequest, "id must be a number");
		return
	}

	e, task := GetTask(i, Data)

	if e != nil {
		c.JSON(http.StatusBadRequest, e.Error())
		return
	}

	c.JSON(http.StatusOK, task);
}

func GetAllTasksHandler(c *gin.Context) {
	err, allTasks := GetAllTasks(Data)

	if err != nil {
		c.JSON(http.StatusInternalServerError, "Could not get all tasks");
		return
	}
	c.JSON(http.StatusOK, allTasks)
}