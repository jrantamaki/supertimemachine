package model

import "gopkg.in/mgo.v2/bson"

type Task struct {
	Id          	bson.ObjectId		`bson:"_id" json:"id"`
	Description 	string    		`json:"description"`
	Tags        	[]string		`json:"tags"`
	Started_at	string			`json:"started_at"`
	Stopped_at	string			`json:"stopped_at,omitempty"`
}

type TaskList struct {
	Tasks		[]Task			`json:"tasks"`
}

type Command struct {
	Operation	string		`json:"op"`
}
