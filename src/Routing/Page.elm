module Routing.Page exposing (urlToPage)

import Auth.Command exposing (exchangeAuthCode)
import Browser.Navigation as Navigation
import Join.Model exposing (initialJoinModelWithRoomID)
import Message exposing (Message(..))
import Model exposing (Model, Page(..))
import Reservation.Command exposing (randomizeRoomID)
import Reservation.Model exposing (initialReservationModel)
import Room.Ports exposing (openConnectionIfNecessary)
import Routing.Utils exposing (noAction, requireLogin, withAction)
import Url exposing (Url)
import Url.Parser as Url exposing ((</>), (<?>), Parser)
import Url.Parser.Query as Query
import Utils.Update exposing (handleNonExistenceSession, startLoading)


type alias PageSpec model msg =
    { init : model -> ( model, Cmd msg )
    }


urlToPage : Url -> PageSpec Model Message
urlToPage url =
    url
        |> Url.parse urlParser
        |> Maybe.withDefault notFoundSpec


urlParser : Parser (PageSpec Model Message -> a) a
urlParser =
    Url.oneOf
        [ Url.map homeSpec Url.top
        , Url.map callbackSpec (Url.top </> Url.s "callback" <?> Query.string "auth_code")
        , Url.map joinSpec (Url.top </> Url.s "join" </> Url.string)
        , Url.map adventureSpec (Url.top </> Url.s "adventure")
        ]


adventureSpec : PageSpec Model Message
adventureSpec =
    { init =
        requireLogin
            << withAction
                (\model ->
                    if model.room.roomID == Nothing || model.room.role == Nothing then
                        Navigation.pushUrl model.navKey "/"

                    else
                        openConnectionIfNecessary
                            { baseUrl = model.flag.ws
                            , token = model.token
                            , roomID = Maybe.withDefault "" model.room.roomID
                            , role = Maybe.withDefault "" model.room.role
                            , callback = Nothing
                            }
                )
            << noAction Adventure
    }


joinSpec : String -> PageSpec Model Message
joinSpec roomID =
    { init =
        requireLogin
            << (\model ->
                    let
                        joinModel =
                            model.join
                    in
                    ( { model
                        | page = Join
                        , join = { joinModel | roomID = roomID }
                      }
                    , Cmd.none
                    )
               )
    }


notFoundSpec : PageSpec Model Message
notFoundSpec =
    { init = noAction NotFound
    }


homeSpec : PageSpec Model Message
homeSpec =
    { init =
        \model ->
            ( { model
                | page = Home
                , reservation = initialReservationModel
              }
            , randomizeRoomID
            )
    }


callbackSpec : Maybe String -> PageSpec Model Message
callbackSpec authCodeQuery =
    { init =
        case authCodeQuery of
            Just authCode ->
                \model ->
                    startLoading
                        ( { model
                            | page = Home
                          }
                        , exchangeAuthCode model.flag.api authCode
                        )

            Nothing ->
                \model ->
                    handleNonExistenceSession "Unable to retrieve access token"
                        ( model
                        , Cmd.none
                        )
    }
