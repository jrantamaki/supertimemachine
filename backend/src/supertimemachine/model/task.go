package model

// TODO: We need to get the json out so that we produce null or no values at all for empty strings instead of ""
// Currently handled in taskroute
type Task struct {
	Id          int		  `json:"id"`
	Description string    `json:"description"`
	Tags        []string  `json:"tags"`
	Started_at	string	  `json:"started_at"`
	Stopped_at	string	  `json:"stopped_at"`
}


