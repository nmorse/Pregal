var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var angular2_1 = require('angular2/angular2');
var EventService = (function () {
    function EventService() {
        this.signal_emitter = new angular2_1.EventEmitter();
        this.rxEmitter = this.signal_emitter.toRx();
    }
    EventService.prototype.broadcast = function (data) {
        this.rxEmitter.next(data);
    };
    return EventService;
})();
var DemoButtonCmp = (function () {
    function DemoButtonCmp(evt) {
        this.evt = evt;
    }
    DemoButtonCmp.prototype.add_a_node = function () {
        this.evt.broadcast('switch');
    };
    DemoButtonCmp = __decorate([
        angular2_1.Component({
            selector: 'demo-button-cmp',
            template: "<p><button (click)=\"add_a_node()\">switch it</button></p><br>"
        }), 
        __metadata('design:paramtypes', [EventService])
    ], DemoButtonCmp);
    return DemoButtonCmp;
})();
var ParentCmp = (function () {
    function ParentCmp(evt) {
        var _this = this;
        evt.rxEmitter.subscribe(function (data) {
            if (data === 'switch') {
                _this.light = !_this.light;
            }
            console.log("I'm the parent component and I got this light command", data);
        });
    }
    ParentCmp = __decorate([
        angular2_1.Component({
            selector: 'parent-cmp',
            template: "<p>Parent Component: light is:{{light}}</p><br>\n              <demo-button-cmp></demo-button-cmp>\n              <demo-button-cmp></demo-button-cmp>\n              <demo-button-cmp></demo-button-cmp>\n              ",
            directives: [DemoButtonCmp]
        }), 
        __metadata('design:paramtypes', [EventService])
    ], ParentCmp);
    return ParentCmp;
})();
var GraphletEditor = (function () {
    function GraphletEditor(evt) {
        this.evt = evt;
    }
    GraphletEditor.prototype.example_sendData = function () {
        this.evt.broadcast('switch');
    };
    GraphletEditor = __decorate([
        angular2_1.Component({
            selector: 'graphlet-editor',
            template: "\n\t  <parent-cmp></parent-cmp>\n\t",
            directives: [ParentCmp]
        }), 
        __metadata('design:paramtypes', [EventService])
    ], GraphletEditor);
    return GraphletEditor;
})();
exports.GraphletEditor = GraphletEditor;
angular2_1.bootstrap(GraphletEditor, [EventService]);
