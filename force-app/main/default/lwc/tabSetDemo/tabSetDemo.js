import { LightningElement, track } from 'lwc';

export default class TabSetDemo extends LightningElement {
  @track activetabvalue = 'search';
  isGuestUser = false;
  isCmpLoaded = false;

  renderedCallback() {
    //this.template.querySelector('lightning-tab').focus();
    if(!this.isCmpLoaded) {
      this.isCmpLoaded = true;
      this.template.querySelector('lightning-tab').focus();
    }

  }
}