
module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Model exposing(Task)

-- Model
type alias ModelType = { currentTask : Task }
model : ModelType
model = { currentTask = Task "Some description" }

-- View
view : ModelType -> Html MsgType
view model =
    div []
        [ button [ onClick Increment ] [ text "-" ]
        , text model.currentTask.description
        ]

-- Update
type MsgType = Increment

update : MsgType -> ModelType -> ModelType
update msg model = ModelType (Task "new description")


-- Entry
main =
    beginnerProgram {
        model = model,
        view = view,
        update = update
    }

