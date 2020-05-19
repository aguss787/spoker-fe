module Routing.Utils exposing (..)

import Browser.Navigation as Navigation
import Message exposing (Message)
import Model exposing (Model, Page)


noAction : Page -> Model -> ( Model, Cmd msg )
noAction page model =
    ( { model
        | page = page
      }
    , Cmd.none
    )


withAction : (Model -> Cmd msg) -> ( Model, Cmd msg ) -> ( Model, Cmd msg )
withAction cmdFunc ( model, cmd ) =
    ( model, Cmd.batch [ cmdFunc model, cmd ] )


requireLogin : ( Model, Cmd Message ) -> ( Model, Cmd Message )
requireLogin ( model, cmd ) =
    case model.token of
        Just _ ->
            ( model, cmd )

        Nothing ->
            ( { model
                | errorMessage = Just "Login required"
                , ok = False
              }
            , Navigation.pushUrl model.navKey "/"
            )
