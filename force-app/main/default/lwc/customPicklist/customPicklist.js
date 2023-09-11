import { LightningElement, api } from 'lwc';

export default class CustomPicklist extends LightningElement {

  @api isRequired = false;
  @api isDisabled;
  @api options;
  @api fieldLabel;

  connectedCallback(){}

  onSelectionChange(event){
    this.dispatchEvent(new CustomEvent('selectionchange',{detail: event?.target?.value}));
  }


}