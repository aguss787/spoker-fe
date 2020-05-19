module Room.Model exposing (..)


type alias RoomModel =
    { roomID : Maybe String
    , role : Maybe String
    , title : String
    , description : String
    , users : List String
    , observers : List String
    , participants : List String
    , votes : List { username : String, value : String }
    }


initialRoomModel : Maybe String -> Maybe String -> RoomModel
initialRoomModel roomID role =
    { roomID = roomID
    , role = role
    , title = ""
    , description = ""
    , users = []
    , observers = []
    , participants = []
    , votes = []
    }
