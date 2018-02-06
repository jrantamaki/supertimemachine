
module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class,id,hidden)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, nullable, list)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Json.Decode.Extra exposing (date)

import Model exposing (..)
import View exposing(..)
import Time exposing (..)


-- **************
-- **** View ****
-- **************
view : ModelType -> Html MsgType
view model =
    div [ class "container" ]
        [
            div [ class "row", hidden (String.isEmpty model.error) ] [
                div [ class "alert alert-danger"] [
                    text model.error
                ]
            ],
            div [ class "row" ] [
                div [ class "col-sm" ] [
                    h3 [] [text "Todays stuff"],
                    taskListView model
                ],
                 div [ class "col-sm" ] [
                    h3 [] [text "Current"]
                ],
                 div [ class "col-sm" ] [
                    h3 [] [text "Temp"],
                    button [ class "btn btn-primary", onClick (FetchTaskCommand model.config)] [ text "Fetch tasks" ]
                ]
            ]
        ]

-- ****************
-- **** Update ****
-- ****************
type MsgType =
    -- Fired from UI to fetch a task
    FetchTaskCommand Config
    -- Message for fetching task result that carries the fetched task
    | FetchTaskResult (Result Http.Error TaskList)
    -- To update current time
    | Tick Time

-- The function to fetch task, returns command
fetchTask : Config -> Cmd MsgType
fetchTask config =
    let
        url = config.apiUrl ++ "/task/"
        request = Http.get url tasksDecoder
    in
        Http.send FetchTaskResult request

tasksDecoder : Decoder TaskList
tasksDecoder =
    decode TaskList
        |> required "tasks" (list taskDecoder)

taskDecoder : Decoder TaskEntry
taskDecoder =
    decode TaskEntry
        |> required "description" Json.Decode.string
        |> required "tags" (Json.Decode.list Json.Decode.string)
        |> required "started_at" date
        |> required "stopped_at" (nullable date)


-- Our update function takes in message and model and returns a tuple of new model with possibly a command to perform
update : MsgType -> ModelType -> (ModelType, Cmd MsgType)
update msg model =
    -- Handling the request to fetch a task
    case msg of

    FetchTaskCommand config ->
        (model, fetchTask config)

    -- Handling the result of fetching the task
    FetchTaskResult (Ok tasks) ->
        ({ model | taskList = tasks, error="" }, Cmd.none) -- Lets update the current task field of the model record

    -- Handling the http error (or parsing) while fetching task
    FetchTaskResult (Err err) ->
        let
            _ = Debug.log "Error while getting tasks" err
        in
            ({model | error = toString err}, Cmd.none)

    -- Updating time
    Tick time ->
        let
            _ = Debug.log "Time " time
        in
            ({model | timeNow = time}, Cmd.none)

-- Entry

init : Config -> (ModelType, Cmd MsgType)
init config =
    (initialModel config, Cmd.none)


initialModel : Config -> ModelType
initialModel configIn =
    { taskList = TaskList []
-- TODO: we should just take the whole config in
    ,config = Config configIn.apiUrl
    ,error=""
    ,timeNow=0
    }

subscriptions : ModelType -> Sub MsgType
subscriptions model =
  every second Tick


main =
    Html.programWithFlags {
        init = init,
        view = view,
        update = update,
        subscriptions = subscriptions
    }

