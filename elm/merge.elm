import Graphics.Element exposing (..)
import Window
import Mouse


type Update = MouseMove (Int,Int) | WinDim (Int, Int)

updates : Signal Update
updates =
    Signal.merge
        (Signal.map MouseMove Mouse.position)
        (Signal.map WinDim Window.dimensions)

main : Signal Element
main =
  Signal.map view updates


view : Update -> Element
view update =
  case update of
    MouseMove (x,y) -> container x y middle (show (x,y))
    WinDim (w,h) -> container w h middle (show (w,h))

