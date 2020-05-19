module View.Home exposing (view)

import Auth.Utils
import Bootstrap.Button as Button
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Html.Attributes exposing (for)
import Html.Styled exposing (Html, fromUnstyled, span, text, toUnstyled)
import Html.Styled.Attributes exposing (class)
import Message exposing (Message(..))
import Model exposing (Model)
import Reservation.Message exposing (ReservationMessage(..))
import Routing.Message as Routing
import View.Style exposing (StyledDocument, centered)


view : Model -> StyledDocument Message
view model =
    { title = "Ready for an adventure?"
    , body =
        [ fromUnstyled <|
            Grid.container []
                [ Grid.row []
                    [ Grid.col [] [ toUnstyled <| reserveOrLoginCard model ]
                    , Grid.col [] [ toUnstyled <| whyCard ]
                    ]
                ]
        ]
    }


reserveOrLoginCard : Model -> Html Message
reserveOrLoginCard model =
    fromUnstyled <|
        (Card.config []
            |> Card.block []
                [ Block.titleH4 [] [ toUnstyled <| text "Reserve a room now!" ]
                , Block.text []
                    [ toUnstyled <|
                        case model.token of
                            Nothing ->
                                fromUnstyled <|
                                    Button.button
                                        [ Button.primary
                                        , Button.onClick <|
                                            RoutingMessage <|
                                                Routing.ExternalRequest <|
                                                    Auth.Utils.getAuthUrl model.flag
                                        ]
                                        [ toUnstyled <| text "Login with agus.dev" ]

                            Just _ ->
                                reservationForm model
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
                    , Form.col [ Col.sm2 ]
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
    fromUnstyled <|
        (Card.config []
            |> Card.block []
                [ Block.titleH4 [] [ toUnstyled <| text "Why I made this?" ]
                , Block.text [] [ toUnstyled <| text "Because of scrumpoker.online" ]
                ]
            |> Card.view
        )
