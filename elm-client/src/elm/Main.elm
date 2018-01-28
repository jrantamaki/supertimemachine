
module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)


import Model exposing(Task)

-- ***************
-- **** Model ****
-- ***************
type alias ModelType = { currentTask : Task }
model : ModelType
model = { currentTask = Task "Not fetched yet" }

-- **************
-- **** View ****
-- **************
view : ModelType -> Html MsgType
view model =
    div []
        [
            button [ onClick FetchTaskCommand ] [ text "Fetch task #2" ],
            br [] [],
            text "Current task is: ",
            text model.currentTask.description
        ]

-- ****************
-- **** Update ****
-- ****************
type MsgType =
    -- Fired from UI to fetch a task
    FetchTaskCommand
    -- Message for fetching task result that carries the fetched task
    | FetchTaskResult (Result Http.Error Task)

-- The function to fetch task, returns command
fetchTask : Cmd MsgType
fetchTask =
    let
        url = "/task/2"
        request = Http.get url decodeTaskJson
    in
        Http.send FetchTaskResult request

decodeTaskJson : Decoder Task
decodeTaskJson =
    decode Task
        |> required "description" Json.Decode.string

-- Our update function takes in message and model and returns a tuple of new model with possibly a command to perform
update : MsgType -> ModelType -> (ModelType, Cmd MsgType)
update msg model =
    -- Handling the request to fetch a task
    case msg of

    FetchTaskCommand ->
        (model, fetchTask)

    -- Handling the result of fetching the task
    FetchTaskResult (Ok fetchedTask) ->
        ({ model | currentTask = fetchedTask }, Cmd.none) -- Lets update the current task field of the model record

    -- Handling the http error while fetching task
    FetchTaskResult (Err _) ->
        (model, Cmd.none)


-- Entry

init : Task -> (ModelType, Cmd MsgType)
init task =
    (ModelType task, Cmd.none)


subscriptions : ModelType -> Sub MsgType
subscriptions model =
  Sub.none


main =
    Html.program {
        init = init (Task "Not fetched yet"),
        view = view,
        update = update,
        subscriptions = subscriptions
    }

