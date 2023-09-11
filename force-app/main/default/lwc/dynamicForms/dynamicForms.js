import { LightningElement , track, wire, api } from 'lwc';
import fetchFieldsFromFieldSet from '@salesforce/apex/DynamicFormsController.fetchFieldsFromFieldSet';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DynamicForms extends LightningElement {
    @api objectName = 'Contact';
    @track fieldApiNames = [];
    @api fieldSetName = 'General';
    @api recordId = '0012800000ExMLpAAN';

    @wire(fetchFieldsFromFieldSet,{objectName : '$objectName',fieldSetName : '$fieldSetName'})
    wiredApiNames({data, error}){
        if(data){
            this.fieldApiNames = data;
        }
        else if (error) {
            this.showNotification('Error','Error while fetching meta-data','error');
        }
    }

    handleSuccess(event){
        console.log('in handleSuccess');
        this.showNotification('Success','Record saved successfully','success');
    }

    showNotification(title,message,variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode:'dismissable'
        });
        this.dispatchEvent(evt);
    }
}