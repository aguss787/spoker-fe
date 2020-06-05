module Room.Message exposing (..)

import Room.Model exposing (RoomConfig)


type RoomMessage
    = ErrorMessage ( String, String )
    | Initialized (Maybe String)
    | Vote { observers : List String, participants : List String, votes : List ( String, String ) }
    | Meta { title : String, description : String }
    | Config RoomConfig
    | SetTitle String
    | SetDescription String
    | CastVote String
    | ClearVote
    | Rejoin
    | Kick String
    | SetConfig RoomConfig
    | SetFreezeAfterVote Bool
