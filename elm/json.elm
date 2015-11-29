import Html exposing (text)
import Json.Decode exposing (..)
import Json.Encode 

personJSONstring = "{\"name\": \"Erin\", \"age\":48}"

theperson =
    Json.Encode.object
      [ ("name", Json.Encode.string "Tom")
      , ("age", Json.Encode.int 42)
      ]




type alias Person = { name: String, age: Int }

-- Design the decoders

nameAndAge : Decoder (String,Int)
nameAndAge =
    object2 (,)
      ("name" := string)
      ("age" := int)

-- Example data

testdata1 = "{\"name\":\"Jane\",\"age\":47}"

newPerson = decodeString nameAndAge testdata1


compact = Json.Encode.encode 0 theperson


main =
  text (toString newPerson)
