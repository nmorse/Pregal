import Graphics.Element exposing (..)
import Window
import Mouse


type Update = MouseMove (Int,Int) | WinDim (Int, Int) | Clicked Bool

updates : Signal Update
updates =
    Signal.merge
        (Signal.map MouseMove Mouse.position)
        (Signal.merge (Signal.map WinDim Window.dimensions)
                     (Signal.map Clicked Mouse.isDown))

main : Signal Element
main =
  Signal.map view updates


view : Update -> Element
view update =
  case update of
    MouseMove (x,y) -> container x y middle (show (x,y))
    WinDim (w,h) -> container w h middle (show (w,h))
    Clicked (d) -> container 300 400 middle (show d)
