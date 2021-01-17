port module Pages.Bch exposing (Model, Msg, Params, page)

import Dict exposing (Dict)
import Element exposing (..)
import Element.Font as Font
import Html
import Html.Attributes
import Shared
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)



-- PORT


port gettingCashInfo : String -> Cmd msg


port gotCashInfo : (String -> msg) -> Sub msg



-- INIT


type alias Params =
    ()


type alias Model =
    Url Params


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared url =
    let
        wallet =
            Dict.get "w" url.query

        _ =
            Debug.log "debug" shared
    in
    case Dict.get "w" url.query of
        Just query ->
            ( url, gettingCashInfo query )

        Nothing ->
            ( url, Cmd.none )


page : Page Params Model Msg
page =
    Page.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , save = save
        , load = load
        }



-- UPDATE


type Msg
    = MsgCashInfo String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MsgCashInfo balance ->
            let
                _ =
                    Debug.log "debug" balance
            in
            ( model, Cmd.none )


save : Model -> Shared.Model -> Shared.Model
save model shared =
    shared


load : Shared.Model -> Model -> ( Model, Cmd Msg )
load shared model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    gotCashInfo MsgCashInfo



-- VIEW


view : Model -> Document Msg
view model =
    let
        _ =
            Debug.log "debug" model
    in
    { title = "PageA"
    , body =
        [ el [ Font.size 32 ] <| text "Page A"
        ]
    }
