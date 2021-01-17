module Pages.Bch exposing (Model, Msg, Params, page)

import Dict exposing (Dict)
import Element exposing (..)
import Element.Font as Font
import Html
import Html.Attributes
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)


page : Page Params Model Msg
page =
    Page.static
        { view = view
        }


type alias Model =
    Url Params


type alias Msg =
    Never



-- VIEW


type alias Params =
    ()


view : Url Params -> Document Msg
view url =
    let
        wallet =
            Dict.get "w" url.query

        _ =
            Debug.log "debug" wallet
    in
    { title = "PageA"
    , body =
        [ el [ Font.size 32 ] <| text "Page A"
        ]
    }
