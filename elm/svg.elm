import Svg exposing (..)
import Svg.Attributes exposing (..)
import Html exposing (div, button, text, br)
import Html.Events exposing (onClick)
import StartApp.Simple as StartApp
import Mouse exposing(..)

main : Signal Html.Html
main =
  StartApp.start { model = model, view = view, update = update }

model = {count = 0, color = "#AA2233", selected = False, pos_x = 0}

view address model =
  div [ Move Mouse.position ]
    [ button [ onClick address Decrement ] [ Html.text "-" ]
    , div [] [ Html.text ((toString model.count) ++ (toString model.selected) ++ (toString model.pos_x))]
    , button [ onClick address Increment ] [ Html.text "+" ]
    , br [] []
    , svg [ width "800", height "600", viewBox "0 0 800 600" ]
      [
        g [] [
          polygon [ fill model.color, points "100,100 300,100 250,200 150,200",
          onClick address Select ] []
          , Svg.text "testing now"
        ]
      ]
    ]

--updates : Signal Action
--updates =
--    Signal.map Move Mouse.position

type Action = Increment | Decrement | Color | Select | Move Signal (Int, Int)

update action model =
  case action of
    Increment -> {model | count = model.count + 1}
    Decrement -> {model | count = model.count - 1}
    Color -> {model | color = "#33BB00"}
    Select -> {model | selected = True, color = "#0033BB"}
    Move (x,y) -> {model | pos_x = x}
