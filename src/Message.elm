module Message exposing (..)

import Auth.Message exposing (AuthMessage)
import Bootstrap.Navbar as Navbar
import Join.Message exposing (JoinMessage)
import Reservation.Message exposing (ReservationMessage)
import Room.Message exposing (RoomMessage)
import Routing.Message


type Message
    = Noop
    | NavbarMessage Navbar.State
    | RoutingMessage Routing.Message.Message
    | AuthMessage AuthMessage
    | ReservationMessage ReservationMessage
    | JoinMessage JoinMessage
    | RoomMessage RoomMessage
