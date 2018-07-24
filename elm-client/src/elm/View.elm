module View exposing (taskListView, newTaskFormView, navBarView)

import Date exposing (Date)
import Model exposing(..)
import Html exposing (..)
import Html.Attributes exposing (class,id,hidden, placeholder,value,style,attribute,href,type_)
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

navBarView : ModelType -> Html MsgType
navBarView model =
    nav [ class "navbar navbar-expand-lg navbar-light bg-light" ]
        [ a [ class "navbar-brand", href "#" ]
            [ text "Navbar" ]
        , button [ attribute "aria-controls" "navbarSupportedContent", attribute "aria-expanded" "false", attribute "aria-label" "Toggle navigation", class "navbar-toggler", attribute "data-target" "#navbarSupportedContent", attribute "data-toggle" "collapse", type_ "button" ]
            [ span [ class "navbar-toggler-icon" ]
                []
            ]
        , div [ class "collapse navbar-collapse", id "navbarSupportedContent" ]
            [ ul [ class "navbar-nav mr-auto" ]
                [ li [ class "nav-item active" ]
                    [ a [ class "nav-link", href "#" ]
                        [ text "Home "
                        , span [ class "sr-only" ]
                            [ text "(current)" ]
                        ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ class "nav-link", href "#" ]
                        [ text "Link" ]
                    ]
                , li [ class "nav-item dropdown" ]
                    [ a [ attribute "aria-expanded" "false", attribute "aria-haspopup" "true", class "nav-link dropdown-toggle", attribute "data-toggle" "dropdown", href "#", id "navbarDropdown", attribute "role" "button" ]
                        [ text "Dropdown        " ]
                    , div [ attribute "aria-labelledby" "navbarDropdown", class "dropdown-menu" ]
                        [ a [ class "dropdown-item", href "#" ]
                            [ text "Action" ]
                        , a [ class "dropdown-item", href "#" ]
                            [ text "Another action" ]
                        , div [ class "dropdown-divider" ]
                            []
                        , a [ class "dropdown-item", href "#" ]
                            [ text "Something else here" ]
                        ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ class "nav-link disabled", href "#" ]
                        [ text "Disabled" ]
                    ]
                ]
            , form [ class "form-inline my-2 my-lg-0" ]
                [ input [ attribute "aria-label" "Search", class "form-control mr-sm-2", placeholder "Search", type_ "search" ]
                    []
                , button [ class "btn btn-outline-success my-2 my-sm-0", type_ "submit" ]
                    [ text "Search" ]
                ]
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