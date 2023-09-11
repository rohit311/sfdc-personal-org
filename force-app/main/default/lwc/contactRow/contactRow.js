import { LightningElement, api } from 'lwc';
import { getSObjectValue } from '@salesforce/apex';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import TITLE_FIELD from '@salesforce/schema/Contact.Title';


export default class ContactRow extends LightningElement {
  @api contact;


  get name() {
    return getSObjectValue(this.contact, NAME_FIELD);
  }
  get title() {
    return getSObjectValue(this.contact, TITLE_FIELD);
  }
}