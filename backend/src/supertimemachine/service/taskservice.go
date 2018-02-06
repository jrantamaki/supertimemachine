package service

import (
	. "supertimemachine/model"
	"log"
	"time"
	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"
)

func GetAllTasks(session *mgo.Session) (error, []Task) {
	log.Print("Getting all tasks! ")

	s := session.Copy()
	defer s.Close()

	c := s.DB("supertimemachine-dev").C("tasks")

	var allTasks []Task
	err := c.Find(bson.M{}).All(&allTasks)

	if err != nil {
		log.Fatal(err)
	}

	return nil, allTasks
}

func GetTask(id int,session *mgo.Session) (error, *Task) {
	log.Print("Getting tasks id: ", id)

	s := session.Copy()
	defer s.Close()

	c := s.DB("supertimemachine-dev").C("tasks")
	var task Task

	err := c.Find(bson.M{"id": id}).One(&task)

	if err != nil {
		log.Fatal(err)
	}

	return nil, &task
}

func AddNewTask(task Task, session *mgo.Session) (error, Task) {
	log.Print("Adding a new fantastic task")

	s := session.Copy()
	defer s.Close()

	c := s.DB("supertimemachine-dev").C("tasks")

	task.Started_at = time.Now().UTC().Format(time.RFC3339)
	err := c.Insert(task)

	if err != nil {
		log.Fatal(err)
	}

	return nil, task
}

