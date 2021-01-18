port module Pages.Bch exposing (Model, Msg, Params, page)

import Dict exposing (Dict)
import Element exposing (..)
import Element.Font as Font
import Html
import Html.Attributes
import Json.Decode as JsonDecode exposing (Decoder, Value, field, int, map3, string)
import Shared
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)



-- PORT


port gettingCashInfo : String -> Cmd msg


port gotCashInfo : (CashInfo -> msg) -> Sub msg



-- INIT


type alias Params =
    ()


type alias CashInfo =
    { balance : Int
    , cashAddress0 : String
    }


type alias Model =
    CashInfo


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared url =
    let
        wallet =
            Dict.get "w" url.query

        _ =
            Debug.log "wallet" url.query
    in
    case Dict.get "w" url.query of
        Just query ->
            ( { balance = 0, cashAddress0 = "" }, gettingCashInfo query )

        Nothing ->
            let
                _ =
                    Debug.log "url.query" "nothing"
            in
            ( { balance = 0, cashAddress0 = "" }, Cmd.none )


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
    = MsgCashInfo CashInfo


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MsgCashInfo cashInfo ->
            let
                _ =
                    Debug.log "debug" cashInfo
            in
            ( { balance = cashInfo.balance, cashAddress0 = cashInfo.cashAddress0 }, Cmd.none )


save : Model -> Shared.Model -> Shared.Model
save model shared =
    shared


load : Shared.Model -> Model -> ( Model, Cmd Msg )
load shared model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    gotCashInfo MsgCashInfo


view : Model -> Document Msg
view model =
    { title = "Bitcoin Cash"
    , body =
        [ el [ Font.size 32 ] <| text model.cashAddress0
        , el [ Font.size 32 ] <| text (String.fromInt model.balance)
        ]
    }
