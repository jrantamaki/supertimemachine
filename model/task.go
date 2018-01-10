package model

type Task struct {
	Description      string    `json:"description"`
	Tags             []string  `json:"tags"`
	Project			 string    `json:"project"`
}
