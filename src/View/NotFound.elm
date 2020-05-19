module View.NotFound exposing (view)

import Css exposing (Style, px)
import Html.Styled exposing (Html, div, text)
import Html.Styled.Attributes exposing (css)
import View.Style exposing (StyledDocument, centered)


view : StyledDocument msg
view =
    { title = "Why are you here?"
    , body =
        [ centered
            [ big404
            , lostText
            ]
        ]
    }


big404 : Html msg
big404 =
    div
        [ css
            [ Css.fontSize (px 150) ]
        ]
        [ text "404" ]


lostText : Html msg
lostText =
    div
        [ css
            [ Css.fontSize (px 20) ]
        ]
        [ text "You seem to be lost, do you need any help? :/" ]
