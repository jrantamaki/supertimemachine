package model

import "gopkg.in/mgo.v2/bson"

// TODO: We need to get the json out so that we produce null or no values at all for empty strings instead of ""
// Maybe the 'omitempty' as used in https://stackoverflow.com/questions/39153419/golang-mongo-insert-with-self-generated-id-using-bson-newobjectid-resulting-i
// Currently handled in taskroute
type Task struct {
	Id          	bson.ObjectId		`bson:"_id" json:"id"`
	Description 	string    		`json:"description"`
	Tags        	[]string		`json:"tags"`
	Started_at	string			`json:"started_at"`
	Stopped_at	string			`json:"stopped_at"`
}


type Command struct {
	Operation	string		`json:"op"`
}
