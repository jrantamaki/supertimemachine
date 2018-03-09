package service

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
	. "supertimemachine/model"
	"gopkg.in/mgo.v2"
	"errors"
)

// This is the "datasource" for now :)
var Session *mgo.Session;

func AddNewTaskHandler(c *gin.Context){
	var task Task
	c.BindJSON(&task)

	e, created := AddNewTask(task, Session)

	if e != nil {
		c.JSON(http.StatusBadRequest, e.Error())
		return
	}

	SendTask(c,&created)
}



func GetTaskHandler(c *gin.Context){
	i, err := requirePathString(c, "id")
	if err != nil { return }

	e, task := GetTask(i, Session)

	if e != nil {
		c.JSON(http.StatusBadRequest, e.Error())
		return
	}

	SendTask(c, task);
}


func GetAllTasksHandler(c *gin.Context) {
	err, allTasks := GetAllTasks(Session)

	if err != nil {
		c.JSON(http.StatusInternalServerError, "Could not get all tasks");
		return
	}
	c.JSON(http.StatusOK, TaskList{allTasks})
}

func TaskPatchHandler(c *gin.Context) {

	id, err := requirePathString(c, "id")
	if err != nil { return }

	var command Command
	c.BindJSON(&command)

	switch command.Operation {
	case "stop":
		e, task := StopTask(id, Session)
		if e!= nil {
			SendError(c, e)
			return
		}
		SendTask(c, task)
		return
	default:
		SendError(c, errors.New("Unknown patch command: " + command.Operation))
	}

}

func SendTask(c *gin.Context, task *Task) {
	c.JSON(http.StatusOK, task);
}

// TODO: Move to some http helper module
func SendError(c *gin.Context, err error)  {
	c.JSON(http.StatusInternalServerError, err.Error())
}

// TODO: Move to some http helper module
func requirePathString(c *gin.Context, name string) (string, error) {

	value := c.Param(name)
	if value == "" {
		c.JSON(http.StatusBadRequest, "Missing path variable: " + name);
		return "",errors.New("Missing path variable: " + name)
	}

	return value,nil
}

func requirePathInt(c *gin.Context, name string) (int, error) {
	i, err := strconv.Atoi(c.Param(name))

	if err != nil {
		c.JSON(http.StatusBadRequest, name + " must be a integer but was " + c.Param(name));
		return -1,err
	}

	return i,nil
}

