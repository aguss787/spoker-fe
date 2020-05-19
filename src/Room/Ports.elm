port module Room.Ports exposing (..)


port openConnection : { baseUrl : String, token : Maybe String, roomID : String, role : String, callback : Maybe String } -> Cmd msg


port openConnectionIfNecessary : { baseUrl : String, token : Maybe String, roomID : String, role : String, callback : Maybe String } -> Cmd msg


port roomError : (( String, String ) -> msg) -> Sub msg


port initialized : (Maybe String -> msg) -> Sub msg


port vote : ({ observers : List String, participants : List String, votes : List ( String, String ) } -> msg) -> Sub msg


port meta : ({ title : String, description : String } -> msg) -> Sub msg


port sendMeta : { title : String, description : String } -> Cmd msg


port castVote : String -> Cmd msg


port clearVote : String -> Cmd msg


port kick : String -> Cmd msg
