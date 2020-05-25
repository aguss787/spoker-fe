module Main exposing (main)

import Auth.Command exposing (inspectToken)
import Bootstrap.Navbar as Navbar
import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Navigation
import Join.Model exposing (initialJoinModel)
import Message exposing (Message(..))
import Model exposing (Flag, Model, Page(..))
import Reservation.Model exposing (initialReservationModel, initialSelectRoomModel)
import Room.Message exposing (RoomMessage(..))
import Room.Model exposing (initialRoomModel)
import Room.Ports exposing (initialized, meta, roomError, vote)
import Routing.Message
import Routing.Page exposing (urlToPage)
import Update exposing (update)
import Url exposing (Url)
import View.Adventure
import View.Home
import View.Join
import View.NotFound
import View.Style exposing (toUnstyledDocument)
import View.Template exposing (withTemplate)


init : Flag -> Url.Url -> Navigation.Key -> ( Model, Cmd Message )
init flag url key =
    let
        ( navBarState, navBarCmd ) =
            Navbar.initialState NavbarMessage

        model : Model
        model =
            { flag = flag
            , navKey = key
            , navbarState = navBarState
            , token = flag.token
            , user = Nothing
            , page = NotFound
            , isLoading = False
            , errorMessage = Nothing
            , ok = True
            , reservation = initialReservationModel
            , selectRoom = initialSelectRoomModel
            , join = initialJoinModel
            , room = initialRoomModel flag.roomID flag.role
            }

        ( nextModel, nextCmd ) =
            (urlToPage url).init model

        userCmd =
            case model.token of
                Just token ->
                    inspectToken model.flag.api token

                Nothing ->
                    Cmd.none
    in
    ( nextModel
    , Cmd.batch
        [ navBarCmd
        , userCmd
        , nextCmd
        ]
    )


view : Model -> Document Message
view model =
    let
        content =
            case model.page of
                NotFound ->
                    View.NotFound.view

                Home ->
                    View.Home.view model

                Join ->
                    View.Join.view model

                Adventure ->
                    View.Adventure.view model
    in
    content
        |> withTemplate model
        |> toUnstyledDocument


onUrlRequest : UrlRequest -> Message
onUrlRequest urlRequest =
    Message.RoutingMessage <|
        case urlRequest of
            Internal url ->
                Routing.Message.InternalRequest url

            External url ->
                Routing.Message.ExternalRequest url


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.batch
        [ Navbar.subscriptions model.navbarState NavbarMessage
        , roomError (RoomMessage << ErrorMessage)
        , initialized (RoomMessage << Initialized)
        , vote (RoomMessage << Vote)
        , meta (RoomMessage << Meta)
        ]


main : Program Flag Model Message
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = onUrlRequest
        , onUrlChange = RoutingMessage << Routing.Message.InternalJump
        }
