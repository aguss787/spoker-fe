module Auth.Message exposing (AuthMessage(..))

import Http


type AuthMessage
    = ExchangeDone (Result Http.Error String)
    | InspectDone (Result Http.Error String)
    | Logout
