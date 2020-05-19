module Room.Message exposing (..)


type RoomMessage
    = ErrorMessage ( String, String )
    | Initialized (Maybe String)
    | Vote { observers : List String, participants : List String, votes : List ( String, String ) }
    | Meta { title : String, description : String }
    | SetTitle String
    | SetDescription String
    | CastVote String
    | ClearVote
    | Rejoin
    | Kick String
