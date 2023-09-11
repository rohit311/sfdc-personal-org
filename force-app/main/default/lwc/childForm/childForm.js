import { LightningElement } from 'lwc';

export default class ChildForm extends LightningElement {

  handleSubmit() {
    const inputArray = this.template.querySelectorAll(".inp-cls");

    inputArray.forEach(inp => {
      if(typeof inp.setCustomValidity === "function") {
        console.log("setCustomValidity present !!!");
      }
      else {
        console.log("call custom function");
      }
    });
  }
}