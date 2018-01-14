
module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

-- Model
type alias ModelType = Int
model : ModelType
model = 1

-- View
view : ModelType -> Html MsgType
view model =
    div []
        [ button [ onClick Increment ] [ text "-" ]
        , text (toString model)
        ]

-- Update
type MsgType = Increment

update : MsgType -> ModelType -> ModelType
update msg model = model + 1


-- Entry
main =
    beginnerProgram {
        model = model,
        view = view,
        update = update
    }

