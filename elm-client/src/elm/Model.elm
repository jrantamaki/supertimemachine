module Model exposing (..)

import Date exposing (Date)
import Time exposing (..)

-- ***************
-- **** Model ****
-- ***************
type alias Config =  { apiUrl : String }
type alias ModelType = {
    currentTask : TaskEntry,
    config : Config,
    error: String,
    timeNow: Time }

type alias TaskEntry = {
    description : String,
    tags : List String,
    startedAt : Date,
    stoppedAt : Maybe Date }
