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

	return executeQuery(session, func(c *mgo.Collection)(error, []Task){
		var allTasks []Task
		err := c.Find(bson.M{}).All(&allTasks)
		return err, allTasks
	})
}

func GetTask(id string,session *mgo.Session) (error, *Task) {

	err, tasks := executeQuery(session, func(c *mgo.Collection)(error, []Task){
		var task Task
		err := c.FindId(bson.ObjectIdHex(id)).One(&task)
		return err, []Task{task}
	})

	if err != nil {
		return err, nil
	}

	return err, &tasks[0]
}


func StopTask(id string, session *mgo.Session) (error, *Task) {

	err, _ := executeQuery(session, func(c *mgo.Collection)(error, []Task){
		change := bson.M{"$set": bson.M{"stopped_at": nowToString()}}
		err := c.UpdateId(bson.ObjectIdHex(id), change)
		return err, nil
	})

	if err != nil {
		return err, nil
	}

	return GetTask(id, session)
}

func AddNewTask(task Task, session *mgo.Session) (error, Task) {
	task.Started_at = nowToString()
	task.Id = bson.NewObjectId()
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
		log.Print("Error executing query: ", err)
	}

	return err,tasks
}

func nowToString() string {
	return time.Now().UTC().Format(time.RFC3339)
}

