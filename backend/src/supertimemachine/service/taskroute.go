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
	i, err := requirePathInt(c, "id")
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

	var taskList []StructAsMap
	for _, task := range allTasks {
		taskList = append(taskList, ToMap(&task))
	}

	c.JSON(http.StatusOK, StructAsMap{ "tasks": taskList })
}

func TaskPatchHandler(c *gin.Context) {

	id, err := requirePathInt(c, "id")
	if err != nil { return }

	var command Command
	c.BindJSON(&command)

	switch command.Operation {
	case "stop":
		e, task := StopTask(id, Session)
		if e!= nil { SendError(c, e)  }
		SendTask(c, task)
		return
	default:
		SendError(c, errors.New("Unknown patch command: " + command.Operation))
	}

}

func SendTask(c *gin.Context, task *Task) {
	c.JSON(http.StatusOK, ToMap(task));
}

// TODO: Move to some http helper module
func SendError(c *gin.Context, err error)  {
	c.JSON(http.StatusInternalServerError, err.Error())
}

// TODO: Move to some http helper module
func requirePathInt(c *gin.Context, name string) (int, error) {
	i, err := strconv.Atoi(c.Param(name))

	if err != nil {
		c.JSON(http.StatusBadRequest, name + " must be a integer but was " + c.Param(name));
		return -1,err
	}

	return i,nil
}

// TODO: Move to Task?
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