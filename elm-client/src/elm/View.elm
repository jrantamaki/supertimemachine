module View exposing (taskView)

import Date exposing (Date)
import Model exposing(..)
import Html exposing (..)
import Html.Attributes exposing (class,id,hidden)
import Date.Extra.Format as Format exposing (format, formatUtc, isoMsecOffsetFormat)
import Date.Extra.Config.Config_en_us exposing (config)
import Date.Extra.Period as Period
import Date.Extra.Duration as Duration
import Time exposing (..)

taskView : ModelType -> Html msg
taskView model =
    let
        task = model.currentTask
    in
    ul [ class "list-group list-group-flush"] [
        li [class "list-group-item"] [ text task.description],
        li [class "list-group-item"] [ span [] [ text (formatDate task.startedAt)]],
        li [class "list-group-item"] [ span [] [ text (printStopTime task.stoppedAt)]],
        li [class "list-group-item"] [ text (printDuration task.startedAt task.stoppedAt model.timeNow)],
        li [class "list-group-item"] (List.map (\s -> span [] [ span [ class "badge badge-primary" ] [text s], text " "]) task.tags)
    ]

printStopTime : Maybe Date -> String
printStopTime maybe =
    case maybe of
        Nothing -> ""
        Just val -> formatDate val

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
