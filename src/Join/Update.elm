module Join.Update exposing (update)

import Join.Message exposing (JoinMessage(..))
import Message exposing (Message)
import Model exposing (Model)
import Ports exposing (storeRole, storeRoomID)
import Room.Ports exposing (openConnection)


update : JoinMessage -> Model -> ( Model, Cmd Message )
update message model =
    let
        joinModel =
            model.join

        roomModel =
            model.room
    in
    case message of
        SetRole role ->
            ( { model
                | join =
                    { joinModel
                        | role = role
                    }
              }
            , Cmd.none
            )

        JoinRoom ->
            ( { model
                | room =
                    { roomModel
                        | roomID = Just joinModel.roomID
                        , role = Just joinModel.role
                    }
              }
            , Cmd.batch
                [ openConnection
                    { baseUrl = model.flag.ws
                    , token = model.token
                    , roomID = joinModel.roomID
                    , role = joinModel.role
                    , callback = Just "/adventure"
                    }
                , storeRoomID joinModel.roomID
                , storeRole joinModel.role
                ]
            )
