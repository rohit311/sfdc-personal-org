import { LightningElement, wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContactList';


export default class ParentContact extends LightningElement {
  @wire(getContacts) contacts;

  get _contacts() {
    const contactList = this.contacts.data;

    return contactList;
  }
}