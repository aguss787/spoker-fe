module Reservation.Command exposing (..)

import Http
import Json.Encode
import Message exposing (Message(..))
import Random
import Random.Char
import Random.String
import Reservation.Message exposing (ReservationMessage(..))


randomizeRoomID : Cmd Message
randomizeRoomID =
    Random.generate
        (ReservationMessage << RandomizeRoomIDDone)
        (Random.String.rangeLengthString 5 7 Random.Char.english)


reserveRoomID : String -> Maybe String -> String -> Cmd Message
reserveRoomID baseUrl token roomID =
    let
        body =
            Json.Encode.encode 0 <| Json.Encode.object [ ( "room_id", Json.Encode.string roomID ) ]
    in
    Http.request
        { method = "POST"
        , url = baseUrl ++ "/reserve"
        , headers = [ Http.header "Authorization" (Maybe.withDefault "" token) ]
        , body = Http.stringBody "application/json" body
        , expect = Http.expectWhatever (ReservationMessage << ReservationDone)
        , timeout = Nothing
        , tracker = Nothing
        }
