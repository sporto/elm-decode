module Main exposing (..)

import Html exposing (..)
import Json.Decode as Decode


json =
    """
{
  "first": "Sam",
  "last": "Sample"
}
"""


decoder =
    Decode.field "first" Decode.string
        |> Decode.andThen
            (\first ->
                Decode.field "last" Decode.string
                    |> Decode.andThen
                        (\last ->
                            Decode.succeed
                                { first = first
                                , last = last
                                }
                        )
            )


result =
    Decode.decodeString decoder json


main =
    text (toString result)
