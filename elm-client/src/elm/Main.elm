
module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class,id,hidden, style)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, nullable, list)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Json.Decode.Extra exposing (date)
import Json.Encode as Encode exposing (..)

import Model exposing (..)
import View exposing(..)
import Time exposing (..)
import String exposing (split)
import List exposing (..)


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
                    h3 [style [("color", "rgb(1,5,200)")]] [text "Todays stuff"],
                    taskListView model
                ],
                 div [ class "col-sm" ] [
                    h3 [ style [("color", "rgb(100,200,256)")] ] [text "New task"],
                    newTaskFormView model.newTaskForm
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


-- The function to fetch task, returns command
fetchTask : Config -> Cmd MsgType
fetchTask config =
    let
        url = config.apiUrl ++ "/task/"
        request = Http.get url tasksDecoder
    in
        Http.send FetchTaskResult request

submitTask : NewTaskForm -> Config -> Cmd MsgType
submitTask taskForm config =
    let
        url = config.apiUrl ++ "/task/"
        body =
            taskForm
                |> taskFormEncoder
                |> Http.jsonBody
        request = Http.post url body taskDecoder
     in
       Http.send SubmitTaskResult request

processCommand : TaskId -> Operation -> Config -> Cmd MsgType
processCommand taskId op config =
    let
        url = config.apiUrl ++ "/task/" ++ toString taskId
        body =
            op
                |> taskCommandEncoder
                |> Http.jsonBody
        request = Http.request
              { method = "PATCH"
              , headers = []
              , url = url
              , body = body
              , expect = Http.expectJson taskDecoder
              , timeout = Nothing
              , withCredentials = False
              }
     in
       Http.send TaskCommandResult request

taskCommandEncoder : Operation -> Encode.Value
taskCommandEncoder operation =
    Encode.object [ ("op", Encode.string "stop") ]

taskFormEncoder : NewTaskForm -> Encode.Value
taskFormEncoder form =
    Encode.object [
        ("description", Encode.string form.descInput),
        ("tags",  Encode.list  (List.map string form.tags))
    ]

tasksDecoder : Decoder TaskList
tasksDecoder =
    decode TaskList
        |> required "tasks" (Json.Decode.list taskDecoder)

taskDecoder : Decoder TaskEntry
taskDecoder =
    decode TaskEntry
        |> required "id" Json.Decode.int
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
    FetchTaskResult (Err err) -> ({model | error = toString err}, Cmd.none)

    -- Submitting new task
    SubmitTaskCommand newTaskForm -> (model, submitTask newTaskForm model.config)

    -- Responses from API for submitting task
    SubmitTaskResult (Ok task) -> ({model | newTaskForm = emptyTaskForm } , Cmd.none)
    SubmitTaskResult (Err err) -> ({model | error = toString err}, Cmd.none)

    -- Task commands
    TaskCommand id operation -> (model, processCommand id operation model.config)
    TaskCommandResult (Ok task) -> (model, Cmd.none)
    TaskCommandResult (Err err) -> ({model | error = toString err}, Cmd.none)

    -- Updating time
    Tick time ->
            ({model | timeNow = time}, Cmd.none)

    NewTaskFormInput subtype -> ( { model | newTaskForm = updateNewTask subtype model.newTaskForm } , Cmd.none)

updateNewTask : InputMessage -> NewTaskForm -> NewTaskForm
updateNewTask msg taskForm =
    case msg of
        OnTagInput tagInput ->
            if String.isEmpty tagInput then
                { taskForm |
                    tagInput = takeLast taskForm.tags |> Maybe.withDefault "",
                    tags = takeAllButLast taskForm.tags |> reverse }
            else
                { taskForm |
                    tags = append taskForm.tags <| (splitWords tagInput |> takeAllButLast |> filter (\s -> s /= "" )),
                    tagInput = splitWords tagInput |> takeLast |> Maybe.withDefault "" |> String.cons ' ' }
        OnDescInput some -> { taskForm | descInput = some }

splitWords : String -> List String
splitWords input =
    split " " input

takeAllButLast : List a -> List a
takeAllButLast list =
    tail (reverse list) |> Maybe.withDefault []

takeLast : List a -> Maybe a
takeLast =
    List.foldl (Just >> always) Nothing


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
    ,newTaskForm= emptyTaskForm
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

