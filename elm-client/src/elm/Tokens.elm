module Tokens exposing(..)

import Jwt exposing(..)
import Jwt.Decoders exposing (JwtToken)
import Json.Decode as Json exposing (Decoder, field)

type alias CognitoToken =
    { iat : Int
    , exp : Int
    , userId : Maybe String
    , email : Maybe String
    , userName : Maybe String
    }

userName : String -> String
userName token =
    decode token |> Result.map .userName |> Result.map (Maybe.withDefault "") |> Result.withDefault "ERR_JWT"

decode : String -> Result JwtError CognitoToken
decode token =
    decodeToken coqnitoDecoder token

coqnitoDecoder : Decoder CognitoToken
coqnitoDecoder =
    Json.succeed CognitoToken
        |> andMap (field "iat" Json.int)
        |> andMap (field "exp" Json.int)
        |> andMap (Json.maybe <| field "sub" Json.string)
        |> andMap (Json.maybe <| field "email" Json.string)
        |> andMap (Json.maybe <| field "cognito:username" Json.string)

andMap : Decoder a -> Decoder (a -> b) -> Decoder b
andMap =
    Json.map2 (|>)
