import { LightningElement, api } from 'lwc';
import sendMessageToWhatsApp from '@salesforce/apex/WhatsappIntegrationController.sendMessageToWhatsApp';

export default class WhatsappMessaging extends LightningElement {

  @api recordId;

  onSendMessage(){
    /*sendMessageToWhatsApp({caseId : this.recordId})
    .then(result => {
      window.alert("Message sent to user !");
    })
    .catch(error => {
      window.alert("Message failed !");
    })*/

    let data = {
      "messaging_product" : "whatsapp",
      "to": "919561877784",
      "text": {"body" : "Hi rohit , How are you ?"}
    };
    let apiToken = "EAAQLManPO14BAPGUMmlGXQ7rzgpkzqVSuQbTg3riTZAyHNMLb418g7yxqcOO0hStfe3u27lwzPBDwehIZB4JurGQofhQhAfFmewUUeAsqbz46ohcJFTYR7WsroUeZC0Jy8KFxlzRohoRJWbzpnVhkcyOX64SXiEGhfIIXYJIvZChTktNFXvnGRRrpYsmODzPRybhoW3qPZBn8URIp9RZAlFGZBlPTDldEcZD";
    fetch("https://graph.facebook.com/v14.0/109063111941688/messages",{
      method: 'POST',
      headers: {
        "Authorization": `Bearer ${apiToken}`,
        "Content-type": "application/json"
      },
      referrerPolicy: 'no-referrer',
      body: JSON.stringify(data)
    })
    .then(response => {
      const resp = response.json();

      resp.then(res => {
        console.log("resp : ",res);
      })
      .catch(error => {
        console.log("inner error : ",error);
      })
    })
    .catch(error => {
      console.log("error ",error);
    })

  }
}