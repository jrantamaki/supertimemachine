package model

import (
	"gopkg.in/mgo.v2/bson"
	"time"
)

type Task struct {
	Id          	bson.ObjectId		`bson:"_id" json:"id"`
	Description 	string    		`json:"description"`
	Tags        	[]string		`json:"tags"`
	Started_at	time.Time		`json:"started_at"`
	Stopped_at	*time.Time		`json:"stopped_at,omitempty"` // Having as pointer to make nullable
}

type TaskList struct {
	Tasks		[]Task			`json:"tasks"`
}

type Command struct {
	Operation	string		`json:"op"`
}
