package service

import (
	. "supertimemachine/model"
	"log"
	"time"
	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"
	"math/rand"
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

func StopTask(id int, session *mgo.Session) (error, *Task) {
	s := session.Copy()
	defer s.Close()

	c := s.DB("supertimemachine-dev").C("tasks")
	change := bson.M{"$set": bson.M{"stopped_at": nowToString()}}
	err := c.Update(bson.M{"id": id}, change)

	if err != nil {
		log.Fatal(err)
	}

	return GetTask(id, session)
}

func AddNewTask(task Task, session *mgo.Session) (error, Task) {
	log.Print("Adding a new fantastic task")

	s := session.Copy()
	defer s.Close()

	c := s.DB("supertimemachine-dev").C("tasks")

	task.Started_at = nowToString()
	task.Id = rand.Int()
	err := c.Insert(task)

	if err != nil {
		log.Fatal(err)
	}

	return nil, task
}

func nowToString() string {
	return time.Now().UTC().Format(time.RFC3339)
}

