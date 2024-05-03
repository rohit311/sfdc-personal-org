import { LightningElement, track } from 'lwc';

export default class ParentCmp extends LightningElement {

  @track parentProp = "Rohit";

  constructor(){
    super();
    console.log("In parent - constructor");
  }

  connectedCallback() {
    console.log("In parent - connectedCallback");
  }
  renderedCallback() {
    console.log("In parent - renderedCallback");
  }
}