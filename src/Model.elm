module Model exposing (..)

import Bootstrap.Navbar as Navbar
import Browser.Navigation as Navigation
import Join.Model exposing (JoinModel)
import Reservation.Model exposing (ReservationModel)
import Room.Model exposing (RoomModel)


type Page
    = NotFound
    | Home
    | Join
    | Adventure


type alias Flag =
    { token : Maybe String
    , roomID : Maybe String
    , role : Maybe String
    , sso : String
    , clientID : String
    , callbackUrl : String
    , api : String
    , ws : String
    }


type alias Model =
    { flag : Flag
    , navKey : Navigation.Key
    , navbarState : Navbar.State
    , token : Maybe String
    , user : Maybe String
    , page : Page
    , isLoading : Bool
    , errorMessage : Maybe String
    , ok : Bool
    , reservation : ReservationModel
    , join : JoinModel
    , room : RoomModel
    }
