port module Ports exposing (..)


port setKey : { key : String, value : String } -> Cmd msg


port removeKey : String -> Cmd msg


removeToken : Cmd msg
removeToken =
    removeKey "token"


storeToken : String -> Cmd msg
storeToken token =
    setKey
        { key = "token"
        , value = token
        }


storeRoomID : String -> Cmd msg
storeRoomID roomID =
    setKey
        { key = "roomID"
        , value = roomID
        }


storeRole : String -> Cmd msg
storeRole role =
    setKey
        { key = "role"
        , value = role
        }


removeRoomInfo : Cmd msg
removeRoomInfo =
    Cmd.batch
        [ removeKey "roomID"
        , removeKey "role"
        ]
