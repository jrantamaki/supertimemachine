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

	return executeQuery(session, func(c *mgo.Collection)(error, []Task){
		var allTasks []Task
		err := c.Find(bson.M{}).All(&allTasks)
		return err, allTasks
	})
}

func GetTask(id int,session *mgo.Session) (error, *Task) {
	log.Print("Getting tasks id: ", id)

	err, tasks := executeQuery(session, func(c *mgo.Collection)(error, []Task){
		var task Task
		err := c.Find(bson.M{"id": id}).One(&task)
		return err, []Task{task}
	})

	return err, &tasks[0]
}


func StopTask(id int, session *mgo.Session) (error, *Task) {

	executeQuery(session, func(c *mgo.Collection)(error, []Task){
		change := bson.M{"$set": bson.M{"stopped_at": nowToString()}}
		err := c.Update(bson.M{"id": id}, change)
		return err, nil
	})

	return GetTask(id, session)
}

func AddNewTask(task Task, session *mgo.Session) (error, Task) {
	log.Print("Adding a new fantastic task")

	task.Started_at = nowToString()
	task.Id = random(1000,100000000)
	executeQuery(session, func(c *mgo.Collection)(error, []Task){
		err := c.Insert(task)
		return err, nil
	})
	return nil, task
}

type Query func(c *mgo.Collection) (error, []Task)

func executeQuery(session *mgo.Session, query Query) (error, []Task) {

	s := session.Copy()
	defer s.Close()

	c := s.DB("supertimemachine-dev").C("tasks")
	err, tasks := query(c)
	if err != nil {
		log.Fatal(err)
	}

	return err,tasks
}

func nowToString() string {
	return time.Now().UTC().Format(time.RFC3339)
}

func random(min, max int) int {
	rand.Seed(time.Now().Unix())
	return rand.Intn(max - min) + min
}

