import {Component, bootstrap, EventEmitter} from 'angular2/angular2';


class EventService {
  signal_emitter: EventEmitter = new EventEmitter();
  rxEmitter: any;
  constructor() {
    this.rxEmitter = this.signal_emitter.toRx();
  }
  broadcast(data){
    this.rxEmitter.next(data);
  }
}


@Component({
  selector : 'demo-button-cmp',
  template : `<p><button (click)="add_a_node()">switch it</button></p><br>`
})
class DemoButtonCmp {
  constructor(evt: EventService) {
    this.evt = evt;
  }
  add_a_node() {
    this.evt.broadcast('switch');

  }
}


@Component({
  selector : 'parent-cmp',
  template : `<p>Parent Component: light is:{{light}}</p><br>
              <demo-button-cmp></demo-button-cmp>
              <demo-button-cmp></demo-button-cmp>
              <demo-button-cmp></demo-button-cmp>
              `,
	directives : [DemoButtonCmp]
})
class ParentCmp {
  light: boolean;
  constructor(evt: EventService) {
    //rx emitter
    evt.rxEmitter.subscribe((data) => {
      if (data === 'switch') {
        this.light = !this.light;
      }
      console.log("I'm the parent component and I got this light command", data));
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
    this.evt.broadcast('switch');
  }
}


bootstrap(GraphletEditor, [EventService]);
