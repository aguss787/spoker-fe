module Update exposing (..)

import Auth.Update
import Join.Update
import Message exposing (Message(..))
import Model exposing (Model)
import Reservation.Message exposing (ReservationMessage(..))
import Reservation.Update
import Room.Update
import Routing.Update


update : Message -> Model -> ( Model, Cmd Message )
update msg old_model =
    let
        model =
            case msg of
                NavbarMessage _ ->
                    old_model

                ReservationMessage (RandomizeRoomIDDone _) ->
                    old_model

                ReservationMessage RandomizeRoomID ->
                    old_model

                _ ->
                    { old_model | ok = True }
    in
    handleOk <|
        case msg of
            Noop ->
                ( model, Cmd.none )

            NavbarMessage state ->
                ( { model | navbarState = state }, Cmd.none )

            RoutingMessage message ->
                Routing.Update.update message model

            AuthMessage authMessage ->
                Auth.Update.update authMessage model

            ReservationMessage reservationMessage ->
                Reservation.Update.update reservationMessage model

            JoinMessage joinMessage ->
                Join.Update.update joinMessage model

            RoomMessage roomMessage ->
                Room.Update.update roomMessage model


handleOk : ( Model, Cmd Message ) -> ( Model, Cmd Message )
handleOk ( model, cmd ) =
    if model.ok then
        ( { model | errorMessage = Nothing }, cmd )

    else
        ( model, cmd )
