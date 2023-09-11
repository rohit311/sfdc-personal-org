import { LightningElement, track, wire } from 'lwc';
import LMS_Demo from '@salesforce/messageChannel/LMS_Demo__c';
import { subscribe, MessageContext,APPLICATION_SCOPE } from 'lightning/messageService';

export default class LmsSubscriberComponent extends LightningElement {
    subscription = null;
    
    @track selectedLanguages;

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this.subscribeToChannel();
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

    handleMessage(message){
        this.selectedLanguages = message.selectedValues;
    }
}