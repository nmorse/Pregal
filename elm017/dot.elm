import Html exposing (Html)
import Html.App as App
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)



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
  {t: Time, st: Time, n: List Node, e: List Edge}


init : (Model, Cmd Msg)
init =
  ({ n=[ {id=1,name="a",view={r=10,pos={x=100,y=100}}}
        ,{id=2,name="b",view={r=10,pos={x=50 ,y=200}}}]
    ,e=[{from=1, to=2, name="connect"}]
    ,t=0,st=0}, Cmd.none)


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
  Time.every second Tick



-- VIEW


view : Model -> Html Msg
view model =
  let
    --angle =
    --  turns (Time.inSeconds model.t)
    slew =
      round (Time.inSeconds (model.t - model.st))
  in
    svg [ viewBox "0 0 500 300", width "500px" ]
      (
        List.append
          (List.map (viewEdge model.n slew) model.e)
          (List.map (viewNode slew) model.n)
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
          view.pos.x + t
        _ ->
          20
    get_y: Maybe Node -> Int
    get_y n =
      case n of
        Just {id, name, view} ->
          view.pos.y
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
      toString (n.view.pos.x + t)
    ypos =
      toString n.view.pos.y
    radius =
      toString n.view.r
  in
    circle [ cx xpos, cy ypos, r radius, fill "#dd0000"] []
