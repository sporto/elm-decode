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



{-
   Current way to enforce values being decoded into the correct field
-}


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


decoder2 =
    { first = "", middle = "", last = "" }
        |> toDecoder
        |> decodeNext (Decode.field "first" Decode.string) (\r v -> { r | first = v })
        |> decodeNext (Decode.field "middle" Decode.string) (\r v -> { r | middle = v })
        |> decodeNext (Decode.field "last" Decode.string) (\r v -> { r | last = v })


toDecoder : record -> Decode.Decoder record
toDecoder record =
    Decode.succeed record


decodeNext : Decode.Decoder a -> (record -> a -> record) -> Decode.Decoder record -> Decode.Decoder record
decodeNext decoder setter result =
    result
        |> Decode.andThen
            (\record ->
                decoder
                    |> Decode.andThen
                        (\value ->
                            Decode.succeed (setter record value)
                        )
            )


result =
    Decode.decodeString decoder1 json


result2 =
    Decode.decodeString decoder2 json



-- Other alternative http://package.elm-lang.org/packages/eeue56/elm-alternative-json/latest


main =
    text (toString result2)
