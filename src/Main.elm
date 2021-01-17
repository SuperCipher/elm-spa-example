module Main exposing
    ( conf
    , main
    )

import Browser
import Browser.Navigation as Nav
import Html.String
import Html.String.Attributes
import Html.String.Extra
import Shared exposing (Flags)
import Spa.Document as Document exposing (Document)
import Spa.Generated.Pages as Pages
import Spa.Generated.Route as Route exposing (Route)
import Starter.ConfMain
import Starter.ConfMeta
import Starter.SnippetHtml
import Starter.SnippetJavascript
import Url exposing (Url)


conf : Starter.ConfMain.Conf
conf =
    { urls = [ "/", "/bch", "/page-b" ]
    , assetsToCache = []
    }


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view >> Document.toBrowserDocument
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }



-- INIT


type alias Model =
    { shared : Shared.Model
    , page : Pages.Model
    }


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ( shared, sharedCmd ) =
            Shared.init flags url key

        ( page, pageCmd ) =
            Pages.init (fromUrl url) shared
    in
    ( Model shared page
    , Cmd.batch
        [ Cmd.map Shared sharedCmd
        , Cmd.map MsgPages pageCmd
        ]
    )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | Shared Shared.Msg
    | MsgPages Pages.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked (Browser.Internal url) ->
            ( model
            , Nav.pushUrl model.shared.key (Url.toString url)
            )

        LinkClicked (Browser.External href) ->
            ( model
            , Nav.load href
            )

        UrlChanged url ->
            let
                original =
                    model.shared

                shared =
                    { original | url = url }

                ( page, pageCmd ) =
                    Pages.init (fromUrl url) shared
            in
            ( { model | page = page, shared = Pages.save page shared }
            , Cmd.map MsgPages pageCmd
            )

        Shared sharedMsg ->
            let
                ( shared, sharedCmd ) =
                    Shared.update sharedMsg model.shared

                ( page, pageCmd ) =
                    Pages.load model.page shared
            in
            ( { model | page = page, shared = shared }
            , Cmd.batch
                [ Cmd.map Shared sharedCmd
                , Cmd.map MsgPages pageCmd
                ]
            )

        MsgPages pageMsg ->
            let
                ( page, pageCmd ) =
                    Pages.update pageMsg model.page

                shared =
                    Pages.save page model.shared
            in
            ( { model | page = page, shared = shared }
            , Cmd.map MsgPages pageCmd
            )


view : Model -> Document Msg
view model =
    Shared.view
        { page =
            Pages.view model.page
                |> Document.map MsgPages
        , toMsg = Shared
        }
        model.shared


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Shared.subscriptions model.shared
            |> Sub.map Shared
        , Pages.subscriptions model.page
            |> Sub.map MsgPages
        ]



-- URL


fromUrl : Url -> Route
fromUrl =
    Route.fromUrl >> Maybe.withDefault Route.NotFound
