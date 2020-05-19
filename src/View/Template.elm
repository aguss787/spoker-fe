module View.Template exposing (withTemplate)

import Auth.Message exposing (AuthMessage(..))
import Bootstrap.Alert as Alert
import Bootstrap.Button as Button
import Bootstrap.Grid as Grid
import Bootstrap.Navbar as Navbar
import Bootstrap.Spinner as Spinner
import Bootstrap.Text as Text
import Css exposing (pct, px)
import Html.Attributes as Unstyled
import Html.Styled exposing (Html, div, fromUnstyled, node, p, text, toUnstyled)
import Html.Styled.Attributes exposing (css, href, id, rel)
import Message exposing (Message(..))
import Model exposing (Model)
import View.Style exposing (StyledDocument)


withTemplate : Model -> StyledDocument Message -> StyledDocument Message
withTemplate model document =
    { title = document.title ++ " - Spoker"
    , body =
        document.body
            |> withNavbar model
            |> withCss
    }


withCss : List (Html Message) -> List (Html Message)
withCss content =
    List.concat
        [ [ cssLink "https://cdn.agus.dev/bootstrap.min.css"
          , cssLink "https://cdn.agus.dev/font-awesome.min.css"
          , cssLink "https://fonts.googleapis.com/icon?family=Material+Icons"
          ]
        , content
        ]


withNavbar : Model -> List (Html Message) -> List (Html Message)
withNavbar model content =
    List.map
        fromUnstyled
    <|
        List.concat
            [ [ Navbar.config NavbarMessage
                    |> Navbar.withAnimation
                    |> Navbar.brand [ Unstyled.href "/" ] [ toUnstyled <| text "SPOKER" ]
                    |> Navbar.items
                        []
                    |> withLoginLogoutButton model.token model.user
                    |> Navbar.view model.navbarState
              ]
            , case model.errorMessage of
                Nothing ->
                    []

                Just message ->
                    [ Alert.simpleDanger [] [ toUnstyled <| text message ] ]
            , [ Grid.container [ Unstyled.style "margin-top" "10px" ] <| List.map toUnstyled content ]
            , if model.isLoading then
                [ toUnstyled <| loadingOverlay ]

              else
                []
            ]


withLoginLogoutButton : Maybe a -> Maybe String -> Navbar.Config Message -> Navbar.Config Message
withLoginLogoutButton token user =
    Navbar.customItems
        [ Navbar.textItem [] <|
            case token of
                Nothing ->
                    [ toUnstyled <| text "" ]

                Just _ ->
                    [ toUnstyled <| helloMessage user
                    , Button.button
                        [ Button.primary
                        , Button.small
                        , Button.onClick (AuthMessage Logout)
                        ]
                        [ toUnstyled <| text "Logout" ]
                    ]
        ]


helloMessage : Maybe String -> Html msg
helloMessage user =
    case user of
        Nothing ->
            text ""

        Just username ->
            text <| "Hi, " ++ username ++ "\t"


navItem : String -> Html msg
navItem content =
    div [ css [ Css.paddingTop (px 5) ] ] [ text content ]


loadingOverlay : Html msg
loadingOverlay =
    div
        [ css
            [ Css.height (pct 100)
            , Css.width (pct 100)
            , Css.position Css.fixed
            , Css.zIndex (Css.int 1)
            , Css.top (px 0)
            , Css.left (px 0)
            , Css.textAlign Css.center
            , Css.backgroundColor (Css.rgba 0 0 0 0.9)
            ]
        ]
        [ div
            [ css
                [ Css.position Css.relative
                , Css.top (pct 20)
                ]
            ]
            [ fromUnstyled <| Spinner.spinner [ Spinner.large, Spinner.color Text.primary ] [] ]
        ]


cssLink str =
    node "link"
        [ rel "stylesheet"
        , href str
        ]
        []
