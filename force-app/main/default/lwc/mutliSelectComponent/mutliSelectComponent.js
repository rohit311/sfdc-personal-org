import { LightningElement, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import LMS_Demo from '@salesforce/messageChannel/LMS_Demo__c';

export default class MutliSelectComponent extends LightningElement {
    _selected = [];

    @wire(MessageContext)
    messageContext;

    get options(){
        return [
            { label: 'English', value: 'en' },
            { label: 'German', value: 'de' },
            { label: 'Spanish', value: 'es' },
            { label: 'French', value: 'fr' },
            { label: 'Italian', value: 'it' },
            { label: 'Japanese', value: 'ja' },
        ];
    }

    handleChange(e){
        this._selected = e.detail.value;
        publish(this.messageContext,LMS_Demo,{selectedValues:this._selected});
    }

}