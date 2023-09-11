import { LightningElement, wire, track } from 'lwc';
import getContactList from '@salesforce/apex/ContactController.getContactList';
import fetchContact from '@salesforce/apex/ContactController.fetchContacts';
import getContacts from '@salesforce/apex/ContactController.getContactList';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import { reduceErrors } from 'c/ldsUtils';

const COLUMNS = [
    { label: 'First Name', fieldName: FIRSTNAME_FIELD.fieldApiName, type: 'text' },
    { label: 'Last Name', fieldName: LASTNAME_FIELD.fieldApiName, type: 'text' },
    { label: 'Email', fieldName: EMAIL_FIELD.fieldApiName, type: 'text' }
];

export default class ApexWireMethodToProperty extends LightningElement {
    columns = COLUMNS;
    @wire(getContacts) contacts;

    @track contactName = '';
    @track contacts;
    get errors() {
        return (this.contacts.error) ?
            reduceErrors(this.contacts.error) : [];
    }

    fetchContacts(event){

        this.contactName = event.target.value;

        if(this.contactName.length > 3){
            fetchContact({conName : this.contactName})
            .then(result => {
                this.contacts = result;
                //console.log('result', result);
            })
            .catch(error => {
            });
            

        }
        else{
            getContactList()
            .then(result => {
                this.contacts = result;

            })
            .catch(
                error => {
            });
        }

    }

}