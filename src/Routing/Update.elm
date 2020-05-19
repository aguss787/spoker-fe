module Routing.Update exposing (..)

import Browser.Navigation as Navigation
import Message exposing (Message)
import Model exposing (Model)
import Routing.Message
import Routing.Page exposing (urlToPage)
import Url


update : Routing.Message.Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        Routing.Message.ExternalRequest url ->
            ( model, Navigation.load url )

        Routing.Message.InternalRequest url ->
            ( model, Navigation.pushUrl model.navKey <| Url.toString url )

        Routing.Message.InternalJump url ->
            let
                ( nextModel, nextCmd ) =
                    (urlToPage url).init model
            in
            ( { nextModel | ok = False }
            , nextCmd
            )
