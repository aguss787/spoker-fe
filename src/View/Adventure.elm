module View.Adventure exposing (..)

import Bootstrap.Button as Button
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Css exposing (pct, px)
import Dict
import Html.Styled exposing (Html, div, fromUnstyled, h3, h5, input, label, span, text, toUnstyled)
import Html.Styled.Attributes exposing (class, css, type_, value)
import Html.Styled.Events exposing (onClick, onInput)
import Message exposing (Message(..))
import Model exposing (Model)
import Room.Message exposing (RoomMessage(..))
import View.Style exposing (StyledDocument)


view : Model -> StyledDocument Message
view model =
    { title = "Adventure"
    , body =
        [ fromUnstyled <|
            Grid.container []
                [ Grid.row [] [ Grid.col [] [ toUnstyled <| renderMeta model ] ]
                , Grid.row [] [ Grid.col [] [ toUnstyled <| renderVote model ] ]
                ]
        ]
    }


renderVote : Model -> Html Message
renderVote model =
    fromUnstyled <|
        Grid.containerFluid []
            [ Grid.row []
                [ Grid.col []
                    [ toUnstyled <|
                        div [ css [ Css.displayFlex, Css.flexDirection Css.column ] ] <|
                            List.concat
                                [ if model.room.role == Just "participant" then
                                    [ div [ css [ Css.paddingBottom <| px 10 ] ] [ renderVotingBox ] ]

                                  else
                                    []
                                , [ div [ css [ Css.paddingBottom <| px 10 ] ] [ renderControlBox model ]
                                  ]
                                ]
                    ]
                , Grid.col [] [ toUnstyled <| renderCurrentVote model ]
                ]
            ]


renderControlBox : Model -> Html Message
renderControlBox model =
    fromUnstyled <|
        (Card.config []
            |> Card.headerH4 [] [ toUnstyled <| text "Control box" ]
            |> Card.block []
                [ Block.text []
                    [ toUnstyled <|
                        div [ css [ Css.paddingBottom <| px 10, Css.displayFlex ] ]
                            [ div [ css [ Css.paddingRight <| px 10 ] ]
                                [ fromUnstyled <|
                                    Button.button
                                        [ Button.danger
                                        , Button.onClick (RoomMessage ClearVote)
                                        ]
                                        [ toUnstyled <| text "Clear" ]
                                ]
                            , div [ css [ Css.paddingRight <| px 10 ] ]
                                [ fromUnstyled <|
                                    Button.button
                                        [ Button.warning
                                        , Button.onClick (RoomMessage Rejoin)
                                        ]
                                        [ toUnstyled <| text "Rejoin" ]
                                ]
                            ]
                    , toUnstyled <|
                        div []
                            [ text <|
                                "Invite link: https://spoker.agus.dev/join/"
                                    ++ Maybe.withDefault "" model.room.roomID
                            ]
                    , toUnstyled <|
                        div [ css [ Css.paddingTop <| px 20 ] ]
                            [ h5 [] [ text "Current users" ]
                            , div [ css [ Css.displayFlex, Css.flexDirection Css.column ] ] <|
                                List.map
                                    (\username ->
                                        div [ css [ Css.displayFlex ] ]
                                            [ span
                                                [ class "material-icons"
                                                , css
                                                    [ Css.display Css.inlineBlock
                                                    , Css.color <| Css.rgba 239 19 19 0.902
                                                    , Css.cursor Css.pointer
                                                    ]
                                                , onClick (RoomMessage <| Kick username)
                                                ]
                                                [ text "clear" ]
                                            , div [] [ text username ]
                                            ]
                                    )
                                    model.room.users
                            ]
                    ]
                ]
            |> Card.view
        )


renderVotingBox : Html Message
renderVotingBox =
    fromUnstyled <|
        (Card.config []
            |> Card.headerH4 [] [ toUnstyled <| text "Voting box" ]
            |> Card.block []
                [ Block.text []
                    [ toUnstyled <|
                        div [ css [ Css.displayFlex, Css.flexWrap Css.wrap ] ] <|
                            List.map
                                (\value ->
                                    div [ css [ Css.paddingRight <| px 5, Css.paddingBottom <| px 10 ] ]
                                        [ fromUnstyled <|
                                            Button.button
                                                [ Button.outlinePrimary, Button.onClick (RoomMessage <| CastVote value) ]
                                                [ toUnstyled <| text value ]
                                        ]
                                )
                                [ "0", "0.5", "1", "2", "3", "5", "8", "13", "20", "40", "100" ]
                    ]
                ]
            |> Card.view
        )


renderCurrentVote : Model -> Html Message
renderCurrentVote model =
    let
        votes =
            model.room.votes
                |> List.map (\vote -> ( vote.username, vote.value ))
                |> Dict.fromList
    in
    fromUnstyled <|
        (Card.config []
            |> Card.headerH4 [] [ toUnstyled <| text "Current vote" ]
            |> Card.block []
                [ Block.text [] <|
                    (model.room.participants
                        |> List.sort
                        |> List.map
                            (\username ->
                                toUnstyled <|
                                    div
                                        [ css [ Css.displayFlex ] ]
                                        [ div [ css [ Css.width <| pct 50 ] ] [ text username ]
                                        , div [ css [ Css.width <| pct 50 ] ] [ text <| Maybe.withDefault "-" <| Dict.get username votes ]
                                        ]
                            )
                    )
                ]
            |> Card.view
        )


renderMeta : Model -> Html Message
renderMeta model =
    let
        flexBox =
            css [ Css.displayFlex, Css.paddingBottom <| px 10 ]

        labelAttr =
            css [ Css.width <| px 101 ]

        inputAttr =
            css [ Css.width <| pct 100 ]
    in
    div []
        [ div [ flexBox ]
            [ label [ labelAttr ] [ text "Title" ]
            , input
                [ type_ "text"
                , inputAttr
                , value model.room.title
                , onInput (RoomMessage << SetTitle)
                ]
                []
            ]
        , div [ flexBox ]
            [ label [ labelAttr ] [ text "Description" ]
            , input
                [ type_ "text"
                , inputAttr
                , value model.room.description
                , onInput (RoomMessage << SetDescription)
                ]
                []
            ]
        ]
