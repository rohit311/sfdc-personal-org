import { LightningElement, wire, track, api } from 'lwc';
import accFieldSet from '@salesforce/apex/FieldSetUtility.getAccountList';

export default class FieldSetDemo extends LightningElement {

    @track accs;
    @track error;
    @api recordId;

    @wire(accFieldSet, { accId: '$recordId' })
    wiredContacts({ error, data }) {
        if (data) {
            this.accs = data;
            this.error = undefined;
            console.log('accs data ',this.accs);
        } else if (error) {
            this.error = error;
            this.accs = undefined;
        }
    }

}