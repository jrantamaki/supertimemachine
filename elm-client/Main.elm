
module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


type alias Model = Int
myModel : Model
myModel = 1

type Msg = Increment


myView : Model -> Html Msg
myView model =
    div []
        [ button [ onClick Increment ] [ text "-" ]
        , text (toString model)
        ]

myUpdate : Msg -> Model -> Model
myUpdate msg model = model + 1

main =
    beginnerProgram {
        model = myModel,
        view = myView,
        update = myUpdate
    }

