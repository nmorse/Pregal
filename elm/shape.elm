import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)

--type MyShape =
type MyList a = Empty | Node a (MyList a)
-- mkList converts MyList to a standard List
mkList : MyList Form -> List Form
mkList l =
    case l of
      Empty ->
          []

      Node first rest ->
          List.append [first] (mkList rest)



--things = (Node 1.3 (Node 2 (Node 3.2 Empty))) 
things = (mkList
    ( Node (ngon 4 75
        |> filled clearGrey
        |> move (-10,0))
     ( Node (ngon 5 75
        |> filled clearGrey
        |> move (50,10))
       Empty)))

main : Element
main =
  collage 300 300
    things


clearGrey : Color
clearGrey =
  rgba 111 111 111 0.6

