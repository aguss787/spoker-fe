module View.Join exposing (view)

import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Fieldset as Fieldset
import Bootstrap.Form.Radio as Radio
import Html.Styled exposing (fromUnstyled, h1, p, text, toUnstyled)
import Html.Styled.Attributes exposing (id)
import Join.Message exposing (JoinMessage(..))
import Message exposing (Message(..))
import Model exposing (Model)
import View.Style exposing (StyledDocument)


view : Model -> StyledDocument Message
view model =
    { title = "Join a Party!"
    , body =
        [ h1 [] [ text "Welkam to da klab!" ]
        , fromUnstyled <|
            Form.form []
                [ Fieldset.config
                    |> Fieldset.asGroup
                    |> Fieldset.legend [] [ toUnstyled <| text "Role" ]
                    |> Fieldset.children
                        (Radio.radioList "role"
                            [ createRadio model "observer" "Observer"
                            , createRadio model "participant" "Participant"
                            ]
                        )
                    |> Fieldset.view
                , Button.button [ Button.primary, Button.onClick (JoinMessage JoinRoom) ] [ toUnstyled <| text "Join" ]
                ]
        ]
    }


createRadio : Model -> String -> String -> Radio.Radio Message
createRadio model id label =
    Radio.create
        [ Radio.id id
        , Radio.checked (id == model.join.role)
        , Radio.onClick (JoinMessage <| SetRole id)
        ]
        label
