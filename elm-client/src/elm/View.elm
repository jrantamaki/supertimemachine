module View exposing (taskView)

import Model exposing(Task)
import Html exposing (..)
import Html.Attributes exposing (class,id)


taskView : Task -> Html msg
taskView task =
    ul [ class "list-group list-group-flush"] [
        li [class "list-group-item"] [ text task.description],
        li [class "list-group-item"] [ text "Today 08:12 - "],
        li [class "list-group-item"] [ text "3h 15min"],
        li [class "list-group-item"] (List.map (\s -> span [ class "badge badge-primary" ] [text s]) task.tags)
    ]