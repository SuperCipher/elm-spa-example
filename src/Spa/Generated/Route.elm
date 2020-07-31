module Spa.Generated.Route exposing
    ( Route(..)
    , fromUrl
    , toString
    )

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser)


type Route
    = Top
    | NotFound
    | PageA
    | PageB


fromUrl : Url -> Maybe Route
fromUrl =
    Parser.parse routes


routes : Parser (Route -> a) a
routes =
    Parser.oneOf
        [ Parser.map Top Parser.top
        , Parser.map NotFound (Parser.s "not-found")
        , Parser.map PageA (Parser.s "page-a")
        , Parser.map PageB (Parser.s "page-b")
        ]


toString : Route -> String
toString route =
    let
        segments : List String
        segments =
            case route of
                Top ->
                    []
                
                NotFound ->
                    [ "not-found" ]
                
                PageA ->
                    [ "page-a" ]
                
                PageB ->
                    [ "page-b" ]
    in
    segments
        |> String.join "/"
        |> String.append "/"