import { LightningElement, api } from 'lwc';
import sendMessageToWhatsApp from '@salesforce/apex/WhatsappIntegrationController.sendMessageToWhatsApp';

export default class WhatsappMessaging extends LightningElement {

  @api recordId;

  onSendMessage(){
    sendMessageToWhatsApp({caseId : this.recordId})
    .then(result => {
      window.alert("Message sent to user !");
    })
    .catch(error => {
      window.alert("Message failed !");
    })
  }
}