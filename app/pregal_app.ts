import {Component} from 'angular2/core';

@Component({
  // Declare the tag name in index.html to where the component attaches
  selector: 'pregal-app',

  // Location of the template for this component
  templateUrl: 'app/pregal_app.html'
})
export class PregalApp {

  // Declaring the variable for binding with initial value
  yourName: string = '';
}
