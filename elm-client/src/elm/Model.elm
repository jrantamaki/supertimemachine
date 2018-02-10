module Model exposing (..)

import Date exposing (Date)
import Time exposing (..)
import Http

-- ******************
-- **** Messages ****
-- ******************
type MsgType =
    -- Fired from UI to fetch a task
    FetchTaskCommand Config
    -- Message for fetching task result that carries the fetched task
    | FetchTaskResult (Result Http.Error TaskList)
    -- Fired from UI to post new task
    | SubmitTaskCommand NewTaskForm
    -- Result of POST task API call
    | SubmitTaskResult (Result Http.Error TaskEntry)
    -- To update current time
    | Tick Time
    | NewTaskFormInput InputMessage

type InputMessage = OnTagInput String | OnDescInput String

-- ***************
-- **** Model ****
-- ***************
type alias Config =  { apiUrl : String }

type alias TaskEntry = {
    description : String,
    tags : List String,
    startedAt : Date,
    stoppedAt : Maybe Date }

type alias TaskList = { tasks : List TaskEntry }

type alias NewTaskForm = {
    descInput: String,
    tagInput: String,
    tags: List String }

type alias ModelType = {
    taskList : TaskList,
    config : Config,
    error: String,
    timeNow: Time,
    newTaskForm: NewTaskForm }


