module Main exposing (..)

import Html exposing (..)
import Json.Decode as Decode


json =
    """
{
  "name": "Sam"
}
"""


decoder =
    Decode.field "name" Decode.string


result =
    Decode.decodeString decoder json


main =
    text (toString result)
