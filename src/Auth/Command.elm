module Auth.Command exposing (..)

import Auth.Message exposing (AuthMessage(..))
import Http
import Json.Decode
import Json.Encode
import Message exposing (Message(..))


exchangeAuthCode : String -> String -> Cmd Message
exchangeAuthCode baseUrl authCode =
    let
        body =
            Json.Encode.encode 0 <| Json.Encode.object [ ( "auth_code", Json.Encode.string authCode ) ]
    in
    Http.post
        { url = baseUrl ++ "/exchange"
        , body = Http.stringBody "application/json" body
        , expect = Http.expectString (AuthMessage << ExchangeDone)
        }


inspectToken : String -> String -> Cmd Message
inspectToken baseUrl token =
    let
        body =
            Json.Encode.encode 0 <| Json.Encode.object [ ( "token", Json.Encode.string token ) ]
    in
    Http.post
        { url = baseUrl ++ "/inspect"
        , body = Http.stringBody "application/json" body
        , expect = Http.expectString (AuthMessage << InspectDone)
        }
