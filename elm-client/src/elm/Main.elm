
module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class,id)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)


import Model exposing(Task)
import View exposing(..)

-- ***************
-- **** Model ****
-- ***************
type alias Config =  { apiUrl : String }
type alias ModelType = { currentTask : Task, config : Config }

-- **************
-- **** View ****
-- **************
view : ModelType -> Html MsgType
view model =
    div [ class "container" ]
        [
            div [ class "row" ] [
                div [ class "col-sm" ] [
                    h3 [] [text "Todays stuff"]
                ],
                 div [ class "col-sm" ] [
                    h3 [] [text "Current"],
                    taskView model.currentTask
                ],
                 div [ class "col-sm" ] [
                    h3 [] [text "Temp"],
                    button [ class "btn btn-primary", onClick (FetchTaskCommand model.config)] [ text "Fetch task #2" ]
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
    | FetchTaskResult (Result Http.Error Task)

-- The function to fetch task, returns command
fetchTask : Config -> Cmd MsgType
fetchTask config =
    let
        url = config.apiUrl ++ "/task/2"
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

    FetchTaskCommand config ->
        (model, fetchTask config)

    -- Handling the result of fetching the task
    FetchTaskResult (Ok fetchedTask) ->
        ({ model | currentTask = fetchedTask }, Cmd.none) -- Lets update the current task field of the model record

    -- Handling the http error while fetching task
    FetchTaskResult (Err _) ->
        (model, Cmd.none)


-- Entry

init : Config -> (ModelType, Cmd MsgType)
init config =
    (initialModel config, Cmd.none)

initialModel : Config -> ModelType
initialModel configIn =
    { currentTask = Task "Task not get yet!"
-- TODO: we should just take the whole config in
    ,config = Config configIn.apiUrl
    }

subscriptions : ModelType -> Sub MsgType
subscriptions model =
  Sub.none


main =
    Html.programWithFlags {
        init = init,
        view = view,
        update = update,
        subscriptions = subscriptions
    }

