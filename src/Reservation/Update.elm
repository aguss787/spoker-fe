module Reservation.Update exposing (update)

import Browser.Navigation as Navigation
import Http exposing (Error(..))
import Message exposing (Message(..))
import Model exposing (Model)
import Reservation.Command exposing (randomizeRoomID, reserveRoomID)
import Reservation.Message exposing (ReservationMessage(..))
import Utils.Update exposing (handleRequestError)


update : ReservationMessage -> Model -> ( Model, Cmd Message )
update message model =
    let
        reservationModel =
            model.reservation
    in
    case message of
        SetRoomID value ->
            ( { model
                | reservation =
                    { reservationModel
                        | roomID = value
                        , validation =
                            case isValid value of
                                Valid _ ->
                                    Nothing

                                Error reason ->
                                    Just reason
                    }
              }
            , Cmd.none
            )

        RandomizeRoomID ->
            ( model
            , randomizeRoomID
            )

        RandomizeRoomIDDone value ->
            ( { model
                | reservation =
                    { reservationModel
                        | roomID = value
                        , validation = Nothing
                    }
              }
            , Cmd.none
            )

        ValidateAndSend ->
            case isValid reservationModel.roomID of
                Valid roomID ->
                    ( model, reserveRoomID model.flag.api model.token roomID )

                Error reason ->
                    ( { model
                        | reservation =
                            { reservationModel
                                | validation = Just reason
                            }
                      }
                    , Cmd.none
                    )

        ReservationDone result ->
            case result of
                Ok _ ->
                    ( model
                    , Navigation.pushUrl model.navKey ("/join/" ++ reservationModel.roomID)
                    )

                Err error ->
                    case error of
                        BadStatus code ->
                            if code == 409 then
                                ( { model
                                    | reservation =
                                        { reservationModel
                                            | validation = Just "Room already taken :("
                                        }
                                  }
                                , Cmd.none
                                )

                            else
                                handleRequestError error ( model, Cmd.none )

                        _ ->
                            handleRequestError error ( model, Cmd.none )


isValid : String -> ValidationForm String
isValid roomID =
    Valid roomID
        |> validateLength
        |> validateCharSet


type ValidationForm a
    = Valid a
    | Error String


validateLength : ValidationForm String -> ValidationForm String
validateLength validation =
    case validation of
        Valid value ->
            if String.length value > 0 then
                Valid value

            else
                Error "Can't be empty"

        _ ->
            validation


validateCharSet : ValidationForm String -> ValidationForm String
validateCharSet validation =
    case validation of
        Valid value ->
            if String.all Char.isAlphaNum value then
                Valid value

            else
                Error "Must be alphanumeric"

        _ ->
            validation
