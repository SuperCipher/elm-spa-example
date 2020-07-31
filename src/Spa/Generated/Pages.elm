module Spa.Generated.Pages exposing
    ( Model
    , Msg
    , init
    , load
    , save
    , subscriptions
    , update
    , view
    )

import Pages.NotFound
import Pages.PageA
import Pages.PageB
import Pages.Top
import Shared
import Spa.Document as Document exposing (Document)
import Spa.Generated.Route as Route exposing (Route)
import Spa.Page exposing (Page)
import Spa.Url as Url



-- TYPES


type Model
    = Top__Model Pages.Top.Model
    | NotFound__Model Pages.NotFound.Model
    | PageA__Model Pages.PageA.Model
    | PageB__Model Pages.PageB.Model


type Msg
    = Top__Msg Pages.Top.Msg
    | NotFound__Msg Pages.NotFound.Msg
    | PageA__Msg Pages.PageA.Msg
    | PageB__Msg Pages.PageB.Msg



-- INIT


init : Route -> Shared.Model -> ( Model, Cmd Msg )
init route =
    case route of
        Route.Top ->
            pages.top.init ()

        Route.NotFound ->
            pages.notFound.init ()

        Route.PageA ->
            pages.pageA.init ()

        Route.PageB ->
            pages.pageB.init ()



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update bigMsg bigModel =
    case ( bigMsg, bigModel ) of
        ( Top__Msg msg, Top__Model model ) ->
            pages.top.update msg model

        ( NotFound__Msg msg, NotFound__Model model ) ->
            pages.notFound.update msg model

        ( PageA__Msg msg, PageA__Model model ) ->
            pages.pageA.update msg model

        ( PageB__Msg msg, PageB__Model model ) ->
            pages.pageB.update msg model

        _ ->
            ( bigModel, Cmd.none )



-- BUNDLE - (view + subscriptions)


bundle : Model -> Bundle
bundle bigModel =
    case bigModel of
        Top__Model model ->
            pages.top.bundle model

        NotFound__Model model ->
            pages.notFound.bundle model

        PageA__Model model ->
            pages.pageA.bundle model

        PageB__Model model ->
            pages.pageB.bundle model


view : Model -> Document Msg
view model =
    (bundle model).view ()


subscriptions : Model -> Sub Msg
subscriptions model =
    (bundle model).subscriptions ()


save : Model -> Shared.Model -> Shared.Model
save model =
    (bundle model).save ()


load : Model -> Shared.Model -> ( Model, Cmd Msg )
load model =
    (bundle model).load ()



-- UPGRADING PAGES


type alias Upgraded params model msg =
    { init : params -> Shared.Model -> ( Model, Cmd Msg )
    , update : msg -> model -> ( Model, Cmd Msg )
    , bundle : model -> Bundle
    }


type alias Bundle =
    { view : () -> Document Msg
    , subscriptions : () -> Sub Msg
    , save : () -> Shared.Model -> Shared.Model
    , load : () -> Shared.Model -> ( Model, Cmd Msg )
    }


upgrade : (model -> Model) -> (msg -> Msg) -> Page params model msg -> Upgraded params model msg
upgrade toModel toMsg page =
    let
        init_ params shared =
            page.init shared (Url.create params shared.key shared.url) |> Tuple.mapBoth toModel (Cmd.map toMsg)

        update_ msg model =
            page.update msg model |> Tuple.mapBoth toModel (Cmd.map toMsg)

        bundle_ model =
            { view = \_ -> page.view model |> Document.map toMsg
            , subscriptions = \_ -> page.subscriptions model |> Sub.map toMsg
            , save = \_ -> page.save model
            , load = \_ -> load_ model
            }

        load_ model shared =
            page.load shared model |> Tuple.mapBoth toModel (Cmd.map toMsg)
    in
    { init = init_
    , update = update_
    , bundle = bundle_
    }


pages :
    { top : Upgraded Pages.Top.Params Pages.Top.Model Pages.Top.Msg
    , notFound : Upgraded Pages.NotFound.Params Pages.NotFound.Model Pages.NotFound.Msg
    , pageA : Upgraded Pages.PageA.Params Pages.PageA.Model Pages.PageA.Msg
    , pageB : Upgraded Pages.PageB.Params Pages.PageB.Model Pages.PageB.Msg
    }
pages =
    { top = Pages.Top.page |> upgrade Top__Model Top__Msg
    , notFound = Pages.NotFound.page |> upgrade NotFound__Model NotFound__Msg
    , pageA = Pages.PageA.page |> upgrade PageA__Model PageA__Msg
    , pageB = Pages.PageB.page |> upgrade PageB__Model PageB__Msg
    }