package service

import (
	"supertimemachine/model"
	"log"
	"fmt"
)


func GetAllTasks() (error, []model.Task) {
	log.Print("Getting all tasks! ")
	task1 := model.Task{Description:"Deploying to heroku for the first time.", Tags:[]string{"STM", "CODING", "HEROKU", "CONFIGURATION"}};
	task2 := model.Task{Description:"Refactoring the main class for STM", Tags:[]string{"STM", "CODING", "REFACTORING"}};
	task3 := model.Task{Description:"Playing Street Fighter at the office.", Tags:[]string{"games", "entertainment", "beer-friday"}};
	task4 := model.Task{Description:"Implementing the service structure for STM", Tags:[]string{"STM", "CODING"}};

	tasks := make([]model.Task,4)

	tasks[0] = task1
	tasks[1] = task2
	tasks[2] = task3
	tasks[3] = task4

	return nil, tasks
}

func GetTask(id int) (error, *model.Task) {
	log.Print("Getting tasks id: ", id)

	e, task := GetAllTasks();

	if e != nil {
		return e, nil
	}
	if id < 0 || id >= len(task) {
		return fmt.Errorf("Invalid task id: %d", id), nil
	}

	return nil, &task[id]

}