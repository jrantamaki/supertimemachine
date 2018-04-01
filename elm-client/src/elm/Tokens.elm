module Tokens exposing(..)

import Jwt exposing(..)
import Jwt.Decoders exposing (JwtToken)
import Json.Decode as Json exposing (Decoder, field)

--type alias ExtendedToken a = { a | userName: String }
--type alias CognitoToken = ExtendedToken(JwtToken)

userName : String -> String
userName token =
    decode token |> Result.map .userId |> Result.map (Maybe.withDefault "") |> Result.withDefault ""

decode : String -> Result JwtError JwtToken
decode token =
    decodeToken coqnitoDecoder token

coqnitoDecoder : Decoder JwtToken
coqnitoDecoder =
    Json.succeed JwtToken
        |> andMap (field "iat" Json.int) -- JwtToken.iat
        |> andMap (field "exp" Json.int) -- JwtToken.exp
        |> andMap (Json.maybe <| field "sub" Json.string) -- JwtToken.userId
        |> andMap (Json.maybe <| field "email" Json.string) -- JwtToken.email
--        |> andMap (field "coqnito:username" Json.string) -- CognitoToken.userName

andMap : Decoder a -> Decoder (a -> b) -> Decoder b
andMap =
    Json.map2 (|>)
