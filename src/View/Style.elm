module View.Style exposing (..)

import Browser exposing (Document)
import Css exposing (Style, center)
import Html.Styled exposing (Html, div, toUnstyled)
import Svg.Styled.Attributes exposing (css)


type alias StyledDocument msg =
    { title : String
    , body : List (Html.Styled.Html msg)
    }


toUnstyledDocument : StyledDocument msg -> Document msg
toUnstyledDocument styledDocument =
    { title = styledDocument.title
    , body = List.map toUnstyled styledDocument.body
    }


centered : List (Html msg) -> Html msg
centered content =
    div
        [ css [ Css.textAlign center ] ]
        [ div [ css [ Css.display Css.inlineBlock ] ]
            content
        ]
