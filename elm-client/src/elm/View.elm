module View exposing (taskListView, newTaskFormView)

import Date exposing (Date)
import Model exposing(..)
import Html exposing (..)
import Html.Attributes exposing (class,id,hidden, placeholder,value,style)
import Html.Events exposing (onInput,onClick)
import Date.Extra.Format as Format exposing (format, formatUtc, isoMsecOffsetFormat)
import Date.Extra.Config.Config_en_us exposing (config)
import Date.Extra.Period as Period
import Date.Extra.Duration as Duration
import Time exposing (..)
import Array
import Char

tagColors = Array.fromList [
    "#D98880", "#F1948A","#C39BD3","#BB8FCE",
    "#7FB3D5","#7FB3D5","#76D7C4","#73C6B6",
    "#7DCEA0","#82E0AA","#F7DC6F","#F7DC6F",
    "#F0B27A","#E59866","#D7DBDD","#BFC9CA",
    "#B2BABB","#85929E","#808B96"
    ]

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
                div [class "col-sm-2"] [
                    span [
                        hidden (isSomething task.stoppedAt)
                        , style [("color", "red")]
                        , class "oi oi-media-stop"
                        , onClick (TaskCommand task.id Stop)] []]
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
                div [class "col-sm-2"] [
                    span [
                         style [("color", "green")]
                        , class "oi oi-media-play"
                        , onClick (SubmitTaskCommand taskForm)] []]
            ]
    ]

renderTags : List String -> List (Html msg)
renderTags tasks =
    (List.map (\s -> span [] [ span [ class "badge", badgeStyle s ] [text s], text " "]) tasks)


badgeStyle : String -> Attribute msg
badgeStyle text =
    style [("background-color", tagToColor text )]

tagToColor : String -> String
tagToColor tag =
    Array.get ((hash tag) % (Array.length tagColors)) tagColors |> Maybe.withDefault "red"

hash : String -> Int
hash from =
    String.toList from |> List.map Char.toCode |> List.foldl (+) 0

printDuration : Date -> Maybe Date -> Time -> String
printDuration start stop timeNow =
    let
        startSeconds = Date.toTime(start) |> Time.inSeconds |> truncate
        endSeconds = Maybe.withDefault (Date.fromTime timeNow) stop |> Date.toTime |> Time.inSeconds |> truncate
        diff = endSeconds - startSeconds
        hours = diff // (60*60)
        minutes = (diff - hours*60*60) // 60
        seconds = diff - hours*60*60 - minutes*60
    in
        toString hours ++ "h " ++
        toString minutes ++ "m " ++
        toString seconds ++ "s"

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