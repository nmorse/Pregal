
// Graphlet (diagram) Editor has two modes of operation:
//   1 is as an editor. In edit mode it mostly
//      listens for editor inputs. i.e to add a node to the diagram you would emit an 
//      add-node message, etc. (see editor inputs)
//   2 is an interactive diagram mode, where the diagram can be updated to reflect the
//      state of a running instance of the graph. It might be an interpretor that is simulating 
//      some states and transitions represented in the graph. this interpretor can both emit
//      messages to the graph (perhaps to hightlite an active node) and subscribe to diagram events 
//       (eg. pause the sumulation of state transitions when some node or edge is selected) 
//      
class GraphletEditor {


}
