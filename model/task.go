package model

type Task struct {
	Description string    `json:"description"`
	Tags        []string  `json:"tags"`
}
// Tasks struct contains all tasks
type Tasks struct {
	Tasks   	[]Task `json:"tasks"`
}


