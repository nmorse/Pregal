module Node (Model, init, Action, update, view) where

type alias Model = {
  id : String,
  data : String
  }

init : String -> String -> Model
init new_id new_data = {
  id = new_id,
  data = new_data
  }
  
type Action

update : Action -> Model -> Model

view : Signal.Address Action -> Model -> Html
