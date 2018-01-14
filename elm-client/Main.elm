
module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Model exposing(Task)

-- Model
type alias ModelType = { currentTask : Task }
model : ModelType
model = { currentTask = Task "Not fetched yet" }

-- View
view : ModelType -> Html MsgType
view model =
    div []
        [ button [ onClick FetchTaskCommand ] [ text "-" ]
        , br
        , text "Current task: "
        , text model.currentTask.description
        ]

-- Update
type MsgType = FetchTaskCommand
    | FetchTaskResult Task


fetchTask : FetchTaskResult
fetchTask = FetchTaskResult Task "Fetched task!"

update : MsgType -> ModelType -> ModelType
update msg model =
    case msg of FetchTaskCommand -> ModelType fetchTask
    case msg of FetchTaskResult ->
        ModelType (Task "new descriptio")


-- Entry
main =
    beginnerProgram {
        model = model,
        view = view,
        update = update
    }

