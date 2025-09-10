import { LightningElement, api, wire } from 'lwc';
import getNewCases from '@salesforce/apex/RealTimeCaseController.getNewCases';
import {
    subscribe,
    unsubscribe,
    onError,
    setDebugFlag,
    isEmpEnabled,
} from 'lightning/empApi';
import {refreshApex} from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [
    { label: 'Case Number', fieldName: 'CaseNumber' },
    { label: 'Subject', fieldName: 'Subject'},
    { label: 'Priority', fieldName: 'Priority'},
    { label: 'Status', fieldName: 'Status' },
    { label: 'Type', fieldName: 'Type'},
];

export default class RealTimeCaseView extends LightningElement {
  channelName = '/event/Case_Creation_PE__e';

  isSubscribeDisabled = false;
  isUnsubscribeDisabled = !this.isSubscribeDisabled;

  subscription = {};

  // Initializes the component
  connectedCallback() {
    // Register error listener
    this.registerErrorListener();
    this.handleSubscribe();
  }

  disconnectedCallback() {
    this.handleUnsubscribe();
  }

  columns = columns;
  @api recordLimit = 20;

  @wire(getNewCases, {recordLimit: '$recordLimit'})
  cases;

  // Handles subscribe button click
  handleSubscribe() {
      // Callback invoked whenever a new event message is received
      const messageCallback = (response) => {
          console.log('New message received: ', JSON.stringify(response));
          this.handlePlatformEvent(response);
          // Response contains the payload of the new message received
      };

      // Invoke subscribe method of empApi. Pass reference to messageCallback
      subscribe(this.channelName, -1, messageCallback).then((response) => {
          // Response contains the subscription information on subscribe call
          console.log(
              'Subscription request sent to: ',
              JSON.stringify(response.channel)
          );
          this.subscription = response;
      }).catch(error => {
        console.log("Error : ", error);
      });
  }

  // Handles unsubscribe button click
    handleUnsubscribe() {

      // Invoke unsubscribe method of empApi
      unsubscribe(this.subscription, (response) => {
          console.log('unsubscribe() response: ', JSON.stringify(response));
          // Response is true for successful unsubscribe
      });
    }

  async handlePlatformEvent(response) {
    try {
      const eventData = response?.data.payload;

      if (eventData) {
        const caseId = eventData.Case_Id__c;

        if (caseId) {
          await refreshApex(this.cases);
          this.showToast("Success", "New Case created", "success");
        }
      }
    } catch(error) {
      console.log('Error while event handling: ', error);
    }
  }

  showToast(title, message, variant) {
    const event = new ShowToastEvent({
        title,
        message,
        variant
    });
    this.dispatchEvent(event);
  }

  registerErrorListener() {
      // Invoke onError empApi method
      onError((error) => {
        console.log('Received error from server: ', JSON.stringify(error));
        // Error contains the server-side error
      });
  }
}