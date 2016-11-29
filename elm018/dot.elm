module Main exposing (..)

import Html exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)
import Math.Matrix4 exposing (..)
import Math.Vector3 exposing (..)
import Html.Events exposing (onClick)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Point =
    { x : Int, y : Int, z : Int }


type alias NodeView =
    { pos : Point, r : Int }


type alias Node =
    { id : Int, name : String, view : NodeView }


type alias Edge =
    { from : Int, to : Int, name : String }


type alias Model =
    { animate_on: Bool, animate_start: Bool, ct : Time, st : Time, n : List Node, e : List Edge, rot : Float }


init : ( Model, Cmd Msg )
init =
    ( { n =
            [ { id = 1, name = "a is 1", view = { r = 25, pos = { x = -50, y = 100, z = 0 } } }
            , { id = 2, name = "b is 2", view = { r = 20, pos = { x = 50, y = -100, z = -50 } } }
            , { id = 3, name = "c is 3", view = { r = 15, pos = { x = 50, y = 100, z = 0 } } }
            , { id = 4, name = "d", view = { r = 10, pos = { x = -50, y = -100, z = 100 } } }
            ]
      , e = [ { from = 1, to = 2, name = "connect" }
            , { from = 1, to = 3, name = "click" }
            , { from = 2, to = 3, name = "clack" }
            , { from = 1, to = 4, name = "cluck" }
            ]
      , ct = 0
      , st = 0
      , rot = 0
      , animate_on = False
      , animate_start = False

      }
    , Cmd.none
    )


-- UPDATE

type Msg
    = Tick Time
    | StopAndGo


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            if model.animate_start then
              ( { model | rot = model.rot + Time.inSeconds (model.ct - model.st), st = newTime, ct = newTime, animate_start = False }, Cmd.none )
            else
              ( { model | ct = newTime }, Cmd.none )

        StopAndGo ->
            if model.animate_on then
              ( { model | animate_on = False }, Cmd.none )
            else
              ( { model | animate_on = True, animate_start = True }, Cmd.none )


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  if model.animate_on then
    Time.every (Time.second * 0.1) Tick
  else
    Sub.none


-- VIEW

trans =
    Math.Matrix4.makeTranslate3 150.0 150.0 0.0


view : Model -> Html Msg
view model =
    let
        --angle =
        --  turns (Time.inSeconds model.t)
        rot_trans =
            Math.Matrix4.rotate
            ((Time.inSeconds (model.ct - model.st) + model.rot) * 0.6)
            (Math.Vector3.vec3 0.0 1.0 0.2) trans
    in
      div [] [
        button [onClick StopAndGo] [Html.text "toggle"],
        svg [ viewBox "0 0 500 300", width "500px" ]
            (List.append
                (List.map (viewEdge model.n rot_trans) model.e)
                (List.map (viewNode rot_trans) model.n)
            )
      ]

viewEdge all_nodes t edge =
    let
        from_n : Maybe Node
        from_n =
            List.head (List.filter (\n -> n.id == edge.from) all_nodes)

        to_n : Maybe Node
        to_n =
            List.head (List.filter (\n -> n.id == edge.to) all_nodes)

        get_x : Maybe Node -> Int
        get_x n =
            case n of
                Just { id, name, view } ->
                    round (getX (Math.Matrix4.transform t (toVec3 view.pos)))

                _ ->
                    20

        get_y : Maybe Node -> Int
        get_y n =
            case n of
                Just { id, name, view } ->
                    round (getY (Math.Matrix4.transform t (toVec3 view.pos)))

                _ ->
                    20

        mx1 =
            toString (get_x from_n)

        my1 =
            toString (get_y from_n)

        mx2 =
            toString (get_x to_n)

        my2 =
            toString (get_y to_n)
    in
        line [ x1 mx1, y1 my1, x2 mx2, y2 my2, stroke "#0000aa" ] []


viewNode t n =
    let
        xpos =
            getX (Math.Matrix4.transform t (toVec3 n.view.pos))

        ypos =
            getY (Math.Matrix4.transform t (toVec3 n.view.pos))

        radius =
            toString n.view.r
    in
      Svg.g [] [
        circle [ cx (toString xpos), cy (toString ypos), r radius, fill "#dd0000" ] [],
        Svg.text_ [x (toString (xpos - toFloat n.view.r + 2.0)), y (toString ypos)] [Svg.text n.name]
      ]


toVec3 pos =
    Math.Vector3.vec3 (toFloat pos.x) (toFloat pos.y) (toFloat pos.z)
