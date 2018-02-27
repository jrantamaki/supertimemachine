module Model exposing (..)

import Date exposing (Date)
import Time exposing (..)
import Http

-- ******************
-- **** Messages ****
-- ******************
type MsgType =
    -- Fired from UI to fetch a task
    FetchTaskCommand
    -- Message for fetching task result that carries the fetched task
    | FetchTaskResult (Result Http.Error TaskList)
    -- Fired from UI to post new task
    | SubmitTaskCommand NewTaskForm
    -- Result of POST task API call
    | SubmitTaskResult (Result Http.Error TaskEntry)
    -- Task operations
    | TaskCommand TaskId Operation
    | TaskCommandResult (Result Http.Error TaskEntry)
    -- To update current time
    | Tick Time
    | NewTaskFormInput InputMessage

type InputMessage = OnTagInput String | OnDescInput String
type Operation = Stop

-- ***************
-- **** Model ****
-- ***************
type alias Config =  { apiUrl : String }

type alias TaskId = String
type alias TaskEntry = {
    id: TaskId,
    description : String,
    tags : List String,
    startedAt : Date,
    stoppedAt : Maybe Date }

type alias TaskList = { tasks : List TaskEntry }

type alias NewTaskForm = {
    descInput: String,
    tagInput: String,
    tags: List String }

emptyTaskForm : NewTaskForm
emptyTaskForm = NewTaskForm "" "" []

type alias ModelType = {
    taskList : TaskList,
    config : Config,
    error: String,
    timeNow: Time,
    newTaskForm: NewTaskForm }


