module Join.Model exposing (..)


type alias JoinModel =
    { roomID : String
    , role : String
    }


initialJoinModel : JoinModel
initialJoinModel =
    initialJoinModelWithRoomID ""


initialJoinModelWithRoomID : String -> JoinModel
initialJoinModelWithRoomID roomID =
    { roomID = roomID
    , role = "observer"
    }
