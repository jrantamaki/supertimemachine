module View exposing (taskListView, newTaskFormView)

import Date exposing (Date)
import Model exposing(..)
import Html exposing (..)
import Html.Attributes exposing (class,id,hidden, placeholder,value)
import Html.Events exposing (onInput,onClick)
import Date.Extra.Format as Format exposing (format, formatUtc, isoMsecOffsetFormat)
import Date.Extra.Config.Config_en_us exposing (config)
import Date.Extra.Period as Period
import Date.Extra.Duration as Duration
import Time exposing (..)

taskListView : ModelType -> Html msg
taskListView model =
    div [] (List.map (\task -> taskView task model.timeNow) model.taskList.tasks)


taskView : TaskEntry -> Time -> Html msg
taskView task timeNow =
    ul [ class "list-group list-group-flush"] [
        li [class "list-group-item"] [ text task.description],
        li [class "list-group-item"] [ span [] [ text (formatDate task.startedAt)]],
        li [class "list-group-item"] [ span [] [ text (formatMaybeDate task.stoppedAt)]],
        li [class "list-group-item"] [ text (printDuration task.startedAt task.stoppedAt timeNow)],
        li [class "list-group-item"] (renderTags task.tags)
    ]

newTaskFormView : NewTaskForm -> Html MsgType
newTaskFormView taskForm =
    div [] [
        input [ placeholder "Description", value taskForm.descInput, onInput (NewTaskFormInput << OnDescInput)] [],
        div [] [ span [] (renderTags taskForm.tags) ],
        input [ placeholder "tags", value taskForm.tagInput, onInput (NewTaskFormInput << OnTagInput)] [],
        div [ ] [ button [class "btn btn-primary", onClick (SubmitTaskCommand taskForm)] [ text "Start" ] ]
    ]

renderTags : List String -> List (Html msg)
renderTags tasks =
    (List.map (\s -> span [] [ span [ class "badge badge-primary" ] [text s], text " "]) tasks)


printDuration : Date -> Maybe Date -> Time -> String
printDuration start stop timeNow =
    let
        period = Period.diff (Maybe.withDefault (Date.fromTime timeNow) stop) start
        duration = Duration.diff (Maybe.withDefault (Date.fromTime timeNow) stop) start
    in
        toString (( (period.week * 7 + period.day) * 24) + duration.hour) ++ "h " ++
        toString duration.minute ++ "m " ++
        toString duration.second ++ "s"

formatDate : Date -> String
formatDate d = Format.format config "%d.%m.%Y %H:%M:%S" d

formatMaybeDate : Maybe Date -> String
formatMaybeDate maybe =
    case maybe of
        Nothing -> ""
        Just val -> formatDate val

