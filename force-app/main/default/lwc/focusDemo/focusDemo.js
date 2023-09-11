import { LightningElement } from 'lwc';

export default class FocusDemo extends LightningElement {

  handleClick(event) {
    const fieldId = event?.currentTarget?.dataset?.id;
    console.log("fieldId2",fieldId);
    this.template.querySelector(`[data-id="${fieldId}_input"]`).focus();
  }
}