import Html exposing (div, button, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import StartApp.Simple as StartApp


{-| Read more about StartApp and how this works at:

    https://github.com/evancz/start-app

The rough idea is that we just specify a model, a way to view it,
and a way to update it. That's all there is to it!
-}
main =
  StartApp.start { model = initModel, view = view, update = update }

type alias Model =
  { style : String
  , tick : Int
  }

initModel = 
    { tick = 0, style = "none" }

view address model =
  div []
    [ button [ onClick address Decrement ] [ text "-" ]
    , div [ style [("color", "red")] ] [ text (toString model.tick) ]
    , button [ onClick address Increment ] [ text "+" ]
    , div []
    [ button [ onClick address Decrement ] [ text "-" ]
    , div [ style [("color", "blue")] ] [ text (toString model.tick) ]
    , button [ onClick address Increment ] [ text "+" ]
    ]
    ]



type Action = Increment | Decrement


update action model =
  case action of
    Increment -> { model | tick = model.tick + 2 }
    Decrement -> { model | tick = model.tick - 1 }
