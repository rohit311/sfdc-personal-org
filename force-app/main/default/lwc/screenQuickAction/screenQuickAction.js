import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class ScreenQuickAction extends LightningElement {
  @api recordId;
  @api objectApiName;

  handleSuccess(e){
    this.dispatchEvent(new CloseActionScreenEvent());
    this.dispatchEvent(new ShowToastEvent({
      title: 'Success',
      message: 'Opportunity Record Updated!',
      variant: 'success'
    }));
  }

}