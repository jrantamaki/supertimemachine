package service

import (
	"supertimemachine/model"
	"log"
	"fmt"
)

func InitTaskData() *[]model.Task {
	task1 := model.Task{Id: 0, Description:"Deploying to heroku for the first time.", Tags:[]string{"STM", "CODING", "HEROKU", "CONFIGURATION"}};
	task2 := model.Task{Id: 1, Description:"Refactoring the main class for STM", Tags:[]string{"STM", "CODING", "REFACTORING"}};
	task3 := model.Task{Id: 2, Description:"Playing Street Fighter at the office.", Tags:[]string{"games", "entertainment", "beer-friday"}};
	task4 := model.Task{Id: 3, Description:"Implementing the service structure for STM", Tags:[]string{"STM", "CODING"}};

	tasks := make([]model.Task,1000)

	tasks[0] = task1
	tasks[1] = task2
	tasks[2] = task3
	tasks[3] = task4

	return &tasks
}

func GetAllTasks(tasks *[]model.Task) (error, []model.Task) {
	log.Print("Getting all tasks! ")

	return nil, *tasks
}

func GetTask(id int, tasks *[]model.Task) (error, *model.Task) {
	log.Print("Getting tasks id: ", id)

	e, task := GetAllTasks(tasks);

	if e != nil {
		return e, nil
	}
	if id < 0 || id >= len(task) {
		return fmt.Errorf("Invalid task id: %d", id), nil
	}

	return nil, &task[id]
}

func AddNewTask(task model.Task, tasks *[]model.Task) (error, model.Task) {
	log.Print("Adding a new fantastic task")

	if task.Id != 0 {
		(*tasks)[task.Id] = task
	}

	return nil, task
}

