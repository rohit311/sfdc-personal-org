import { LightningElement, api } from 'lwc';

export default class LwrDemo extends LightningElement {
  @api maxHeight;
  strSearchAccName = '';

  handleAccountName(event) {
    this.strSearchAccName = event.detail.value;
}
}