package model

type Task struct {
	Id          int		  `json:"id"`
	Description string    `json:"description"`
	Tags        []string  `json:"tags"`
}


