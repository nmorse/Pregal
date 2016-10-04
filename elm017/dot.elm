import Html exposing (Html)
import Html.App as App
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)
import Math.Matrix4 exposing (..)
import Math.Vector3 exposing (..)


main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL
type alias Point =
  {x: Int, y: Int}

type alias NodeView =
  {pos: Point, r: Int}

type alias Node =
  {id: Int, name: String, view: NodeView}

type alias Edge =
  {from: Int, to: Int, name: String}

type alias Model =
  {t: Time, st: Time, n: List Node, e: List Edge, rot: Float}

init : (Model, Cmd Msg)
init =
  ({ n=[ {id=1,name="a",view={r=10,pos={x=100,y=100}}}
        ,{id=2,name="b",view={r=10,pos={x=50 ,y=200}}}]
    ,e=[{from=1, to=2, name="connect"}]
    ,t=0,st=0, rot=0}, Cmd.none)


-- UPDATE

type Msg
  = Tick Time


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      if model.st == 0 then
        ({model | st = newTime}, Cmd.none)
      else
        ({model | t = newTime}, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every Time.second Tick


-- VIEW

view : Model -> Html Msg
view model =
  let
    --angle =
    --  turns (Time.inSeconds model.t)
    rot_trans =
      Math.Matrix4.rotate ((Time.inSeconds (model.t - model.st))*1) (Math.Vector3.vec3 30.0 60.0 20.0) Math.Matrix4.identity
  in
    svg [ viewBox "0 0 500 300", width "500px" ]
      (
        List.append
          (List.map (viewEdge model.n rot_trans) model.e)
          (List.map (viewNode rot_trans) model.n)
      )

viewEdge all_nodes t edge =
  let
    from_n: Maybe Node
    from_n =
      List.head (List.filter (\n -> n.id == edge.from) all_nodes)
    to_n: Maybe Node
    to_n =
      List.head (List.filter (\n -> n.id == edge.to) all_nodes)
    get_x: Maybe Node -> Int
    get_x n =
      case n of
        Just {id, name, view} ->
          round (getX (Math.Matrix4.transform t (toVec3 view.pos)))
        _ ->
          20
    get_y: Maybe Node -> Int
    get_y n =
      case n of
        Just {id, name, view} ->
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
      toString (getX (Math.Matrix4.transform t (toVec3 n.view.pos)))
    ypos =
      toString (getY (Math.Matrix4.transform t (toVec3 n.view.pos)))
    radius =
      toString n.view.r
  in
    circle [ cx xpos, cy ypos, r radius, fill "#dd0000"] []

toVec3 pos =
  Math.Vector3.vec3 (toFloat pos.x) (toFloat pos.y) 0.0
