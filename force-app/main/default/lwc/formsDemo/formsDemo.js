import { LightningElement, track, wire, api } from 'lwc';
import { publish, MessageContext, subscribe, APPLICATION_SCOPE } from 'lightning/messageService';
import saveContacts from '@salesforce/apex/ContactController.saveContacts';
import getContacts from '@salesforce/apex/ContactController.getContactList';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';
import LMS_Demo from '@salesforce/messageChannel/LMS_Demo__c';
import { getRecords } from 'lightning/uiRecordApi';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';

const FIELDS = ["Contact.FirstName", "Contact.LastName"];


export default class FormsDemo extends LightningElement {
  editTable = false;
  subscription = null;
  @track contactList = [];
  @track contactRec = {};
  contactListToApex = [];
  color = 'red';
  saveBtnLabel = "Save";
  disableBtn = false;
  listOfIds = ['0032800000DnjzHAAR', '0032800000FxU0RAAV'];
  isEscalatedValue = false;
  showIsEscalated = false;
  /*@wire(MessageContext)
    messageContext;*/

    @wire(getRecords, {
      records: [
          {
              recordIds: '$listOfIds',
              fields: FIELDS
          }
      ]
  })
  wiredRecords(wireStream) {
    const {error , data}  = wireStream;
      console.log('******* WIRED RECORDS',wireStream);
      if(error) {
          console.log('*** error: ' + JSON.stringify(error));
      } else if(data) {
          console.log('*** ' + JSON.stringify(data));
      }
  }


  connectedCallback() {
    //this.listOfIds = ['0032800000DnjzHAAR', '0032800000FxU0RAAV'];
    this.fetchAllContacts();
    //this.subscribeToChannel();
    const btn =this.template.querySelector('.secondaryBtn');
    console.log("button in connectedCallback :",btn);
        btn?.click();

    this.editTable = true;
  }

  renderedCallback() {
    /*const btn =this.template.querySelector('.secondaryBtn');
    console.log("button in connectedCallback :",btn);
        btn?.click();*/
  }

  subscribeToChannel(){
    if (!this.subscription) {
        this.subscription = subscribe(
            this.messageContext,
            LMS_Demo,
            (message) => this.handleMessage(message),
            { scope: APPLICATION_SCOPE }
        );

    }
  }

  handleEdit() {
    this.editTable = true;
  }

  fetchAllContacts() {
    this.contactList = [];
    getContacts()
    .then(data => {
      console.log("testing ",data);
      data.forEach(obj => {
        this.contactList.push(Object.assign({}, obj));
      });
      this.contactRec = this.contactList[0];
    })
    .catch(error => {
      console.log("error ",error);
    })
  }

  handleChange(event) {
  let newList = [];
    this.contactList.forEach(obj => {
      console.log("in loop");
      newList.push(Object.assign({}, obj));
    });
    let contactRec = newList[event.target.dataset.id];
    contactRec[event.target.name] = event.detail.value;
    console.log("event : ",newList);
    this.contactListToApex = newList;
    const options = [
      { label: 'English', value: 'en' },
      { label: 'German', value: 'de' },
      { label: 'Spanish', value: 'es' },
      { label: 'French', value: 'fr' },
      { label: 'Italian', value: 'it' },
      { label: 'Japanese', value: 'ja' },
  ];
    publish(this.messageContext,LMS_Demo,{selectedValues: options});
  }

  handleSaveAll() {
    console.log("in Handle save");
    this.saveBtnLabel = "Saving...";
    this.disableBtn  =true;
    saveContacts({ contactList : this.contactListToApex})
    .then(data => {
      this.editTable = false;
      this.contactList.forEach(rec => {
        this.updateRecordView(rec.Id);
      });
      const toast = new ShowToastEvent({
        title: 'Updated',
        message: 'Resource Updated Successfully!',
        variant: 'success',
        mode: 'dismissable'
        });
this.dispatchEvent(toast);
        this.disableBtn  =false;
        this.saveBtnLabel = "Save";
    })
    .catch(error => {
      console.log("error ",error);
    })
  }

  handleCancel() {

  }

  handleMessage(message){
    console.log("from LMS ", message.selectedValues);
  }

  updateRecordView(recordId) {
    updateRecord({fields: { Id: recordId }});
}

searchBusiness() {
  console.log("searchBusiness :::");
}

get colorStyle(){
  return `background-color:${this.color}`;
}

handleNext() {
  const fieldsToValidate = this.template.querySelectorAll(".required");
  const isScreenValid = this.validateInput(fieldsToValidate);

  if(isScreenValid) {
    //Navigate to next screen
  }
  else {
    //show error messsage / or other handling
    console.log("In else ");
  }

}

validateInput(fieldsToValidate) {
  let isValid = true;
  fieldsToValidate.forEach(inputField => {
      if(!inputField.checkValidity()) {
          inputField.reportValidity();
          isValid = false;
      }
  });
  return isValid;
}

handleEsclation() {
  this.showIsEscalated = true;

  if (this.showIsEscalated) {
    //console.log("div", this.template.querySelector("div")); // getting proxy object, image attached
    //console.log("input",this.template.querySelector("input"));

    setTimeout(() => {
      console.log(this.template.querySelector('[data-id="escalated"]'));
    },0);
    //console.log(this.template.querySelector('[data-id="escalated"]'));
     //getting null in console
    // this.template.querySelector('[data-id="escalated"]').checked = this.caseRecordDetail.data.fields.IsEscalated.value;
// tried setting checked on the element but not working as element is not selected may be
}
}

/*handleCheckbox() {
  const checkBoxEl = this.template.querySelector('[data-id="escalated"]');
  console.log("checkBox ", checkBoxEl.checked);
}*/
}