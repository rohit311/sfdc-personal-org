import { LightningElement } from 'lwc';

export default class GrandChildComp extends LightningElement {
  constructor(){
    super();
    console.log("In grandchild - constructor:");
  }

  connectedCallback() {
    console.log("In grandchild - connectedCallback");
  }
  renderedCallback() {
    console.log("In grandchild - renderedCallback");
  }
}