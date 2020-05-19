module Reservation.Message exposing (..)

import Http


type ReservationMessage
    = SetRoomID String
    | RandomizeRoomID
    | RandomizeRoomIDDone String
    | ValidateAndSend
    | ReservationDone (Result Http.Error ())
