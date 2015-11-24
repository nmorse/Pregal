type alias Model =
    { node1 : Node.Model
    , node2 : Node.Model
    , edge1 : Edge.Model
    }

init : Node -> Node -> Edge -> Model
init n1 n2 e1 =
    { node1 : Node.init n1
    , node2 : Node.init n2
    , edge1 : Edge.init e1
    }
