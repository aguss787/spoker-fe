module Auth.Update exposing (update)

import Auth.Command exposing (inspectToken)
import Auth.Message exposing (AuthMessage(..))
import Browser.Navigation as Navigation
import Message exposing (Message)
import Model exposing (Model)
import Ports exposing (removeToken, storeToken)
import Utils.Update exposing (finishLoading, handleNonExistenceSession, handleRequestError)


update : AuthMessage -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        ExchangeDone result ->
            case result of
                Ok token ->
                    ( { model | token = Just token }
                    , Cmd.batch
                        [ inspectToken model.flag.api token
                        , storeToken token
                        , Navigation.pushUrl model.navKey "/"
                        ]
                    )

                Err _ ->
                    finishLoading <|
                        handleNonExistenceSession "Please try again" ( model, Navigation.pushUrl model.navKey "/" )

        Logout ->
            finishLoading <|
                ( { model | token = Nothing, user = Nothing }
                , Cmd.batch
                    [ Navigation.pushUrl model.navKey "/"
                    , removeToken
                    ]
                )

        InspectDone result ->
            finishLoading <|
                case result of
                    Ok user ->
                        ( { model | user = Just user }
                        , Cmd.none
                        )

                    Err _ ->
                        handleNonExistenceSession "Session expired" ( model, Navigation.pushUrl model.navKey "/" )
