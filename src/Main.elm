module Main exposing (..)

import Html exposing (..)
import Json.Decode as Decode


json =
    """
{
  "first": "Sam",
  "middle": "S",
  "last": "Sample"

}
"""


decoder1 =
    Decode.field "first" Decode.string
        |> Decode.andThen
            (\first ->
                Decode.field "middle" Decode.string
                    |> Decode.andThen
                        (\middle ->
                            Decode.field "last" Decode.string
                                |> Decode.andThen
                                    (\last ->
                                        Decode.succeed
                                            { first = first
                                            , middle = middle
                                            , last = last
                                            }
                                    )
                        )
            )



{-
   What I want

   decoder =
       send (Decode.field "first" Decode.string) (\first r -> {r | first = first})
           |> send (Decode.field "middle" Decode.string) (\middle r -> {r | middle = middle})
            |> send (Decode.field "last" Decode.string) (\last r -> {r | last = last})

-}


result =
    Decode.decodeString decoder1 json


main =
    text (toString result)
