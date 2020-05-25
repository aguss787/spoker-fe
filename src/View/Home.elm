module View.Home exposing (view)

import Auth.Utils
import Bootstrap.Button as Button
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Css exposing (px)
import Html.Attributes exposing (for)
import Html.Styled exposing (Html, div, fromUnstyled, span, text, toUnstyled)
import Html.Styled.Attributes exposing (class, css)
import Message exposing (Message(..))
import Model exposing (Model)
import Reservation.Message exposing (ReservationMessage(..))
import Routing.Message as Routing
import View.Style exposing (StyledDocument)


view : Model -> StyledDocument Message
view model =
    { title = "Ready for an adventure?"
    , body =
        [ fromUnstyled <|
            Grid.container []
                [ Grid.row [] <|
                    case model.token of
                        Nothing ->
                            [ Grid.col [] [ toUnstyled <| loginCard model ]
                            ]

                        _ ->
                            [ Grid.col [] [ toUnstyled <| reserveCard model ]
                            , Grid.col [] [ toUnstyled <| joinCard model ]
                            ]
                , Grid.row []
                    [ Grid.col [] [ toUnstyled <| whyCard ]
                    ]
                ]
        ]
    }


loginCard : Model -> Html Message
loginCard model =
    cardWrapper <|
        fromUnstyled <|
            (Card.config []
                |> Card.block []
                    [ Block.titleH4 [] [ toUnstyled <| text "Start your journey here!" ]
                    , Block.text []
                        [ toUnstyled <|
                            fromUnstyled <|
                                Button.button
                                    [ Button.primary
                                    , Button.onClick <|
                                        RoutingMessage <|
                                            Routing.ExternalRequest <|
                                                Auth.Utils.getAuthUrl model.flag
                                    ]
                                    [ toUnstyled <| text "Login with agus.dev" ]
                        ]
                    ]
                |> Card.view
            )


cardWrapper : Html Message -> Html Message
cardWrapper html =
    div [ css [ Css.paddingBottom <| px 10 ] ] [ html ]


joinCard : Model -> Html Message
joinCard model =
    cardWrapper <|
        fromUnstyled <|
            (Card.config []
                |> Card.block []
                    [ Block.titleH4 [] [ toUnstyled <| text "Or, simply join your friend" ]
                    , Block.text []
                        [ toUnstyled <| joinForm model
                        ]
                    ]
                |> Card.view
            )


joinForm : Model -> Html Message
joinForm model =
    fromUnstyled <|
        Grid.container []
            [ Form.form []
                [ Form.label [ for "join_room_id" ] [ toUnstyled <| text "Room ID" ]
                , Form.row []
                    [ Form.col []
                        [ Input.text
                            [ Input.id "join_room_id"
                            , Input.onInput <| ReservationMessage << SetSelectRoomID
                            , Input.value model.selectRoom.roomID
                            , if model.selectRoom.validation == Nothing then
                                Input.success

                              else
                                Input.danger
                            ]
                        , Form.invalidFeedback [] [ toUnstyled <| text <| Maybe.withDefault "" model.selectRoom.validation ]
                        ]
                    ]
                , Form.row []
                    [ Form.col []
                        [ Button.submitButton
                            [ Button.primary
                            , Button.onClick <| ReservationMessage ValidateAndJoin
                            ]
                            [ toUnstyled <| text "Join party" ]
                        ]
                    ]
                ]
            ]


reserveCard : Model -> Html Message
reserveCard model =
    cardWrapper <|
        fromUnstyled <|
            (Card.config []
                |> Card.block []
                    [ Block.titleH4 [] [ toUnstyled <| text "Reserve a room now!" ]
                    , Block.text []
                        [ toUnstyled <| reservationForm model
                        ]
                    ]
                |> Card.view
            )


reservationForm : Model -> Html Message
reservationForm model =
    fromUnstyled <|
        Grid.container []
            [ Form.form []
                [ Form.label [ for "room_id" ] [ toUnstyled <| text "Room ID" ]
                , Form.row []
                    [ Form.col []
                        [ Input.text
                            [ Input.id "room_id"
                            , Input.onInput <| ReservationMessage << SetRoomID
                            , Input.value model.reservation.roomID
                            , if model.reservation.validation == Nothing then
                                Input.success

                              else
                                Input.danger
                            ]
                        , Form.invalidFeedback [] [ toUnstyled <| text <| Maybe.withDefault "" model.reservation.validation ]
                        ]
                    , Form.col [ Col.sm3 ]
                        [ Button.resetButton
                            [ Button.onClick <| ReservationMessage RandomizeRoomID
                            ]
                            [ toUnstyled <| span [ class "material-icons" ] [ text "shuffle" ] ]
                        ]
                    ]
                , Form.row []
                    [ Form.col []
                        [ Button.submitButton
                            [ Button.primary
                            , Button.onClick <| ReservationMessage ValidateAndSend
                            ]
                            [ toUnstyled <| text "Start you battle!" ]
                        ]
                    ]
                ]
            ]


whyCard : Html Message
whyCard =
    cardWrapper <|
        fromUnstyled <|
            (Card.config []
                |> Card.block []
                    [ Block.titleH4 [] [ toUnstyled <| text "Why I made this?" ]
                    , Block.text [] [ toUnstyled <| text "Because of scrumpoker.online" ]
                    ]
                |> Card.view
            )
