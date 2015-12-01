import Html exposing (text)
import Json.Decode exposing (..)
import Json.Encode 



type alias Node = {id: String, name: String, node_type: Int }

-- Design the decoders

nodeDec : Decoder (String,String,Int)
nodeDec =
    object3 (,,)
      ("id" := string)
      ("name" := string)
      ("node_type" := int)

-- Example data

testdata1 = "{\"id\":\"n1\",\"name\":\"Start\",\"node_type\":47}"

newNode = decodeString nodeDec testdata1

--compact = Json.Encode.encode 0 newNode


main =
  text (toString newNode)
