import { LightningElement, api } from 'lwc';

export default class ChildComp extends LightningElement {

  @api myProp = "";

  constructor(){
    super();
    console.log("In child - constructor:", this.myProp);
  }

  connectedCallback() {
    console.log("In child - connectedCallback", this.myProp);
  }
  renderedCallback() {
    console.log("In child - renderedCallback", this.myProp);
  }
}