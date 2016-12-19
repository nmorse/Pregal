module Main exposing (..)

import Html exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)
import Math.Matrix4 exposing (..)
import Math.Vector3 exposing (..)
import Html.Events exposing (onClick)

-- for drag axis view
import Html.Attributes exposing (..)
import Html.Events exposing (on)
import Json.Decode as Decode
import Mouse exposing (Position)
--

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

--type alias Vec3 =
--  { x : Float, y : Float, z : Float }

type alias NodeView =
  { pos : Point, r : Int }

type alias EdgeView =
  { ports : List EdgePort }

type alias EdgePort =
  { incident : Vec3, transmitted : Vec3, pos: Point }

type alias Node =
  { id : Int, name : String, view : NodeView }

type alias Edge =
  { from : Int, to : Int, name : String, view : EdgeView }

type alias Drag =
  { start : Position
  , current : Position
  }

type alias Model =
  { drag : Maybe Drag
  , animate_on: Bool
  , animate_start: Bool
  , ct : Time, st : Time
  , n : List Node
  , ed : List Edge
  , rot : Float
  , rot_drag : Float
  }

init : ( Model, Cmd Msg )
init =
    ( {
      n =
            [ { id = 1, name = "a is 1", view = { r = 25, pos = { x = -50, y = 100, z = 0 } } }
            , { id = 2, name = "b is 2", view = { r = 20, pos = { x = 50, y = -100, z = -50 } } }
            , { id = 3, name = "c is 3", view = { r = 15, pos = { x = 50, y = 100, z = 0 } } }
            , { id = 4, name = "d", view = { r = 10, pos = { x = -50, y = -100, z = 100 } } }
            ]
      , ed = [ { from = 1, to = 2, name = "connect", view = {ports=[{ incident=(Math.Vector3.vec3 25.0 0.0 0.0), transmitted=(Math.Vector3.vec3 0.0 0.0 0.0), pos={ x = 0, y = 0, z = 0 } }]} }
            , { from = 1, to = 3, name = "click", view = {ports=[{incident=(Math.Vector3.vec3 15.0 20.0 0.0), transmitted=(Math.Vector3.vec3 0.0 0.0 0.0), pos={ x = 0, y = 0, z = 0 } }]} }
            , { from = 2, to = 3, name = "clack", view = {ports=[{incident=(Math.Vector3.vec3 15.0 12.0 0.0), transmitted=(Math.Vector3.vec3 0.0 0.0 0.0), pos={ x = 0, y = 0, z = 0 } }]} }
            , { from = 1, to = 4, name = "cluck", view = {ports=[{incident=(Math.Vector3.vec3 20.0 15.0 0.0), transmitted=(Math.Vector3.vec3 0.0 0.0 0.0), pos={ x = 0, y = 0, z = 0 } }]} }
            ]
      , ct = 0
      , st = 0
      , rot = 0
      , rot_drag = 0
      , animate_on = False
      , animate_start = False
      , drag = Nothing
      }
    , Cmd.none
    )


-- UPDATE

type Msg
    = Tick Time
    | StopAndGo
    | DragStart Position
    | DragAt Position
    | DragEnd Position



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            if model.animate_start then
              ( { model | rot = model.rot + Time.inSeconds (model.ct - model.st),
                          st = newTime, ct = newTime, animate_start = False }, Cmd.none )
            else
              ( { model | ct = newTime }, Cmd.none )

        StopAndGo ->
            if model.animate_on then
              ( { model | animate_on = False }, Cmd.none )
            else
              ( { model | animate_on = True, animate_start = True }, Cmd.none )

        DragStart xy ->
            ( { model | drag = if model.animate_on then Nothing else (Just (Drag xy xy))}, Cmd.none )

        DragAt xy ->
            ( { model | rot_drag = (getPosition model), drag = (Maybe.map (\{start} -> Drag start xy) model.drag)}, Cmd.none )

        DragEnd _ ->
            ( { model | rot = model.rot + model.rot_drag, rot_drag = 0, drag = Nothing}, Cmd.none )


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  if model.animate_on then
    Time.every (Time.second * 0.1) Tick
  else
    case model.drag of
      Nothing ->
        Sub.none

      Just _ ->
        Sub.batch [ Mouse.moves DragAt, Mouse.ups DragEnd ]



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
            ((Time.inSeconds (model.ct - model.st) + model.rot + model.rot_drag) * 0.6)
            (Math.Vector3.vec3 0.0 1.0 0.2) trans
    in
      div [Html.Attributes.style [("width", "100%"), ("height", "100%")]] [
        button [onClick StopAndGo] [Html.text "toggle"],
        svg [ viewBox "0 0 500 300", Svg.Attributes.width "500px" ]
            (List.append
                (List.map (viewEdge model.n rot_trans) model.ed)
                (List.map (viewNode rot_trans) model.n)
            ),
        div [onMouseDown, Html.Attributes.style [("width", "100%"), ("height", "30px"), ("background-color", "#CCCCEE")]] []
      ]

viewEdge all_nodes t edge =
    let
        from_n : Maybe Node
        from_n =
            List.head (List.filter (\n -> n.id == edge.from) all_nodes)

        to_n : Maybe Node
        to_n =
            List.head (List.filter (\n -> n.id == edge.to) all_nodes)

        get_incident_x : Maybe Node -> Int
        get_incident_x n =
            case n of
                Just { id, name, view } ->
                    round (getX (Math.Matrix4.transform t
                      (Math.Vector3.add
                        (toVec3 (Just view.pos))
                        (incidentOf (List.head edge.view.ports)) )))

                _ ->
                    20

        get_x : Maybe Node -> Int
        get_x n =
            case n of
                Just { id, name, view } ->
                    round (getX (Math.Matrix4.transform t
                      (toVec3 (Just view.pos))
                        ))

                _ ->
                    20

        get_incident_y : Maybe Node -> Int
        get_incident_y n =
            case n of
                Just { id, name, view } ->
                    round (getY (Math.Matrix4.transform t
                      (Math.Vector3.add
                        (toVec3 (Just view.pos))
                        (incidentOf (List.head edge.view.ports)) )))

                _ ->
                    20

        get_y : Maybe Node -> Int
        get_y n =
            case n of
                Just { id, name, view } ->
                    round (getY (Math.Matrix4.transform t
                        (toVec3 (Just view.pos))
                        ))

                _ ->
                    20

        mx1 =
            toString (get_incident_x from_n)

        my1 =
            toString (get_incident_y from_n)

        mx2 =
            toString (get_x to_n)

        my2 =
            toString (get_y to_n)
    in
        line [ x1 mx1, y1 my1, x2 mx2, y2 my2, stroke "#0000aa" ] []


incidentOf: Maybe EdgePort -> Vec3
incidentOf some_port =
  case some_port of
    Just p ->
      p.incident
    Nothing ->
      Math.Vector3.vec3 0.0 0.0 0.0

viewNode t n =
    let
        xpos =
            getX (Math.Matrix4.transform t (toVec3 (Just n.view.pos)))

        ypos =
            getY (Math.Matrix4.transform t (toVec3 (Just n.view.pos)))

        radius =
            toString n.view.r
    in
      Svg.g [] [
        circle [ cx (toString xpos), cy (toString ypos), r radius, fill "#dd0000" ] [],
        Svg.text_ [x (toString (xpos - toFloat n.view.r + 2.0)), y (toString ypos)] [Svg.text n.name]
      ]

toVec3: Maybe Point -> Vec3
toVec3 pos =
  case pos of
    Just p ->
      Math.Vector3.vec3 (toFloat p.x) (toFloat p.y) (toFloat p.z)
    Nothing ->
      Math.Vector3.vec3 0.0 0.0 0.0

getPosition: Model -> Float
getPosition m =
  case m.drag of
    Nothing ->
      0.0
    Just {start,current} ->
      (toFloat (current.x - start.x) * 0.01)


onMouseDown : Html.Attribute Msg
onMouseDown =
  on "mousedown" (Decode.map DragStart Mouse.position)
