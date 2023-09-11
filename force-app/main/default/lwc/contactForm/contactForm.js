import { LightningElement } from 'lwc';
import Contact_Object from '@salesforce/schema/Contact';
import lastName_field from '@salesforce/schema/Contact.LastName';
import preQualified from '@salesforce/schema/Contact.Prequalified__c';


export default class ContactForm extends LightningElement {

    contactObj = Contact_Object;
    contactFields = [lastName_field,preQualified];

    handleContactCreated(){

        console.log('contact created');
    }

}