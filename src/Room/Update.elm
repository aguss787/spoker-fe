module Room.Update exposing (..)

import Browser.Navigation as Navigation
import Message exposing (Message)
import Model exposing (Model)
import Ports exposing (removeRoomInfo)
import Room.Message exposing (RoomMessage(..))
import Room.Model exposing (initialRoomModel)
import Room.Ports exposing (castVote, clearVote, kick, sendMeta, setConfig)
import Utils.Update exposing (reportError)


update : RoomMessage -> Model -> ( Model, Cmd Message )
update message model =
    let
        roomModel =
            model.room

        configModel =
            roomModel.config
    in
    case message of
        ErrorMessage ( errorType, errorMessage ) ->
            reportError (errorType ++ ": " ++ errorMessage) <|
                if errorMessage == "kicked" then
                    ( { model
                        | room = initialRoomModel Nothing Nothing
                      }
                    , Cmd.batch
                        [ Navigation.pushUrl model.navKey "/"
                        , removeRoomInfo
                        ]
                    )

                else
                    ( model
                    , Navigation.pushUrl model.navKey <|
                        case model.room.roomID of
                            Nothing ->
                                "/"

                            Just roomID ->
                                "/join/" ++ roomID
                    )

        Initialized callback ->
            case callback of
                Nothing ->
                    ( model, Cmd.none )

                Just url ->
                    ( model, Navigation.pushUrl model.navKey url )

        Vote record ->
            ( { model
                | room =
                    { roomModel
                        | users = record.participants ++ record.observers
                        , participants = record.participants
                        , observers = record.observers
                        , votes = List.map (\( username, value ) -> { username = username, value = value }) record.votes
                    }
              }
            , Cmd.none
            )

        Meta record ->
            ( { model
                | room =
                    { roomModel
                        | title = record.title
                        , description = record.description
                    }
              }
            , Cmd.none
            )

        SetTitle title ->
            ( { model
                | room =
                    { roomModel
                        | title = title
                    }
              }
            , sendMeta { title = title, description = roomModel.description }
            )

        SetDescription description ->
            ( { model
                | room =
                    { roomModel
                        | description = description
                    }
              }
            , sendMeta { title = roomModel.title, description = description }
            )

        CastVote value ->
            ( model, castVote value )

        ClearVote ->
            ( model, clearVote "" )

        Rejoin ->
            ( model, Navigation.pushUrl model.navKey <| "/join/" ++ Maybe.withDefault "" model.room.roomID )

        Kick username ->
            ( model, kick username )

        SetConfig roomConfig ->
            ( model, setConfig roomConfig )

        Config config ->
            ( { model
                | room =
                    { roomModel
                        | config = config
                    }
              }
            , Cmd.none
            )

        SetFreezeAfterVote value ->
            ( { model
                | room =
                    { roomModel
                        | config =
                            { configModel
                                | freezeAfterVote = value
                            }
                    }
              }
            , setConfig
                { configModel
                    | freezeAfterVote = value
                }
            )
