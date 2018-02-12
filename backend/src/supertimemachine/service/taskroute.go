package service

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
	. "supertimemachine/model"
	"gopkg.in/mgo.v2"
)

// This is the "datasource" for now :)
var Session *mgo.Session;

// There is this mysterious map[string]interface{} type which I dont understand :)
type StructAsMap gin.H

func AddNewTaskHandler(c *gin.Context){
	var task Task
	c.BindJSON(&task)

	e, created := AddNewTask(task, Session)

	if e != nil {
		c.JSON(http.StatusBadRequest, e.Error())
		return
	}

	c.JSON(http.StatusOK, ToMap(&created))
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

	c.JSON(http.StatusOK, ToMap(task));
}


func GetAllTasksHandler(c *gin.Context) {
	err, allTasks := GetAllTasks(Session)

	if err != nil {
		c.JSON(http.StatusInternalServerError, "Could not get all tasks");
		return
	}

	var taskList []StructAsMap
	for _, task := range allTasks {
		taskList = append(taskList, ToMap(&task))
	}

	c.JSON(http.StatusOK, StructAsMap{ "tasks": taskList })
}

func ToMap(task *Task) StructAsMap {
	return StructAsMap{
		"id": task.Id,
		"description": task.Description,
		"started_at": task.Started_at,
		// Oh shit, how ugly can this get?! Give me the ternary operator pretty please
		"stopped_at": func() *string { if task.Stopped_at != "" { return &task.Stopped_at } else { return nil } }(),
		"tags": task.Tags,
	}
}