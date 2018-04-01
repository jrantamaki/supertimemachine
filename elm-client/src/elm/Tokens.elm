module Tokens exposing(..)

type alias CognitoToken = {
    sub: String,
    userName: String }



userName : String -> String
userName token =
    (decode token).userName

decode : String -> CognitoToken

decode token =
    CognitoToken "subject" "userName"