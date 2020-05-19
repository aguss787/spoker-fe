module Auth.Utils exposing (..)

import Model exposing (Flag)


getAuthUrl : Flag -> String
getAuthUrl flag =
    flag.sso ++ "/authorize?client_id=" ++ flag.clientID ++ "&redirect_uri=" ++ flag.callbackUrl
