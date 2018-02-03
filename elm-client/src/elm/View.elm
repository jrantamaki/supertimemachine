module View exposing (taskView)

import Model exposing(Task)
import Html exposing (..)

taskView : Task -> Html msg
taskView task =
    div [] [
        text "Description: ",
        text task.description
    ]