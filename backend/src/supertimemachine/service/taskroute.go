package service

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
	"supertimemachine/model"
	"gopkg.in/mgo.v2"
)

// This is the "datasource" for now :)
var Session *mgo.Session;

func AddNewTaskHandler(c *gin.Context){
	var task model.Task
	c.BindJSON(&task)

	AddNewTask(task, Session)

	c.JSON(http.StatusOK, task)
}

func GetTaskHandler(c *gin.Context){
	id :=  c.Param("id")
	i, err := strconv.Atoi(id)

	if err != nil { //FIXME there must be a better way to validate the parameter, that it is an int.
		c.JSON(http.StatusBadRequest, "id must be a number");
		return
	}

	e, task := GetTask(i, Session)

	if e != nil {
		c.JSON(http.StatusBadRequest, e.Error())
		return
	}


	c.JSON(http.StatusOK, gin.H{
		"id": task.Id,
		"description": task.Description,
		"started_at": task.Started_at,
		// Oh shit, how ugly can this get?! Give me the ternary operator pretty please
		"stopped_at": func() *string { if task.Stopped_at != "" { return &task.Stopped_at } else { return nil } }(),
		"tags": task.Tags,
		});
}

func GetAllTasksHandler(c *gin.Context) {
	err, allTasks := GetAllTasks(Session)

	if err != nil {
		c.JSON(http.StatusInternalServerError, "Could not get all tasks");
		return
	}
	c.JSON(http.StatusOK, allTasks)
}