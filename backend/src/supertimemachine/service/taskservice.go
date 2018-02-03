package service

import (
	"supertimemachine/model"
	"log"
	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"
)

func GetAllTasks(session *mgo.Session) (error, []model.Task) {
	log.Print("Getting all tasks! ")

	s := session.Copy()
	defer s.Close()

	c := s.DB("supertimemachine-dev").C("tasks")

	var allTasks []model.Task
	err := c.Find(bson.M{}).All(&allTasks)

	if err != nil {
		log.Fatal(err)
	}

	return nil, allTasks
}

func GetTask(id int,session *mgo.Session) (error, *model.Task) {
	log.Print("Getting tasks id: ", id)

	s := session.Copy()
	defer s.Close()

	c := s.DB("supertimemachine-dev").C("tasks")
	var task model.Task

	err := c.Find(bson.M{"id": id}).One(&task)

	if err != nil {
		log.Fatal(err)
	}

	return nil, &task
}

func AddNewTask(task model.Task, session *mgo.Session) (error, model.Task) {
	log.Print("Adding a new fantastic task")

	s := session.Copy()
	defer s.Close()

	c := s.DB("supertimemachine-dev").C("tasks")

	err := c.Insert(task)

	if err != nil {
		log.Fatal(err)
	}

	return nil, task
}

