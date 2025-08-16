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

  handleCompare() {
    const vtest = "test";
    const buttons = this.template.querySelector(`lightning-button[data-id="${vtest}"]`);
  //const buttons = this.template.querySelector('[data-id="'+j.pId+'"]');
  //const buttons = this.template.querySelector('.'+j.planName);
  buttons.classList.add('slds-hide');
  }
}