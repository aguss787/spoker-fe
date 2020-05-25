module Reservation.Model exposing (..)


type alias ReservationModel =
    { roomID : String
    , validation : Maybe String
    }


type alias SelectRoomModel =
    { roomID : String
    , validation : Maybe String
    }


initialReservationModel : ReservationModel
initialReservationModel =
    { roomID = ""
    , validation = Nothing
    }


initialSelectRoomModel : SelectRoomModel
initialSelectRoomModel =
    { roomID = ""
    , validation = Nothing
    }
