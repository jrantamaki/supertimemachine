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

taskListView : ModelType -> Html MsgType
taskListView model =
    table [class "table"] (List.append (taskRows model) [ tr[] [newTaskFormView model.newTaskForm] ])

taskRows : ModelType -> List (Html MsgType)
taskRows model =
    (List.map (\task -> taskView task model.timeNow) model.taskList.tasks)

taskView : TaskEntry -> Time -> Html MsgType
taskView task timeNow =
    tr [] [
        div [class "container border"] [
            div [class "row"] [
                div [] (renderTags task.tags)
            ],
            div [class "row"] [
                div [class "col-sm-2"] [ text (formatDate task.startedAt)],
                div [class "col-sm-2"] [ text (formatMaybeDate task.stoppedAt)],
                div [class "col-sm-4"] [ span [ class "font-italic" ] [text task.description ]],
                div [class "col-sm-2"] [ text (printDuration task.startedAt task.stoppedAt timeNow)],
                div [class "col-sm-2"] [ button [ hidden (isSomething task.stoppedAt), class "btn btn-primary", onClick (TaskCommand task.id Stop)] [ text "Stop"] ]
            ]
        ]
    ]

newTaskFormView : NewTaskForm -> Html MsgType
newTaskFormView taskForm =
    div [class "container border"] [
            div [class "row"] [ div [] [ span [] (renderTags taskForm.tags) ] ],
            div [class "row"] [
                div [class "col-sm-4"] [ input [ placeholder "tags", value taskForm.tagInput, onInput (NewTaskFormInput << OnTagInput)] [] ],
                div [class "col-sm-4"] [ input [ placeholder "Description", value taskForm.descInput, onInput (NewTaskFormInput << OnDescInput)] []],
                div [class "col-sm-2"] [],
                div [class "col-sm-2"] [ button [class "btn btn-primary", onClick (SubmitTaskCommand taskForm)] [ text "Start" ] ]
            ]
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

isNothing : Maybe a -> Bool
isNothing m =
  case m of
    Nothing -> True
    Just _  -> False

isSomething : Maybe a -> Bool
isSomething m = not (isNothing m)