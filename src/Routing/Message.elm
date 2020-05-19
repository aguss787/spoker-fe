module Routing.Message exposing (..)

import Url exposing (Url)


type Message
    = ExternalRequest String
    | InternalRequest Url
    | InternalJump Url
