import {Component, View, bootstrap, EventEmitter} from 'angular2/angular2';


class EventService {
  _emitter: EventEmitter = new EventEmitter();
  rxEmitter: any;
  constructor() {
    this.rxEmitter = this._emitter.toRx();
  }
  doSomething(data){
    this.rxEmitter.next(data);
  }
}


@Component({
  selector : 'demo-button-cmp',
  template : `<p><button (click)="add_a_node()">Add a node</button></p><br>`
})
class DemoButtonCmp {
  constructor(evt: EventService) {
    this.evt = evt;
  }
  add_a_node() {
    this.evt.doSomething(Math.random());
  }
}


@Component({
  selector : 'parent-cmp',
  template : `<p>Parent Component: The Random Number is:{{myData}}</p><br>
              <demo-button-cmp></demo-button-cmp>`,
	directives : [DemoButtonCmp]
})
class ParentCmp {
  myData: any;
  constructor(evt: EventService) {
    //rx emitter
    evt.rxEmitter.subscribe((data) => {
      this.myData = data;
      console.log("I'm the parent cmp and I got this data", data));
    }
  }
}

@Component({
    selector: 'graphlet-editor'
	template: `
	  <parent-cmp></parent-cmp>
	`,
	directives : [ParentCmp]
})
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
export class GraphletEditor {
  constructor(evt: EventService) {
    this.evt = evt;
  }
  example_sendData() {
    console.log("Sending Data");
    this.evt.doSomething(Math.random()*100+1);
  }
}


bootstrap(GraphletEditor, [EventService]);
