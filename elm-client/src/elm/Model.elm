module Model exposing (..)

import Date exposing (Date)
import Time exposing (..)

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

type alias ModelType = {
    taskList : TaskList,
    config : Config,
    error: String,
    timeNow: Time }


