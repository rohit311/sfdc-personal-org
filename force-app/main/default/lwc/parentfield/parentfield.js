import { LightningElement } from 'lwc';

export default class Parentfield extends LightningElement {
  fieldConfigs = [{Field_API_Name__c: "abc__c", Id: 1, fieldValue: false, MasterLabel : "abc"},
  {Field_API_Name__c: "xyz__c", Id: 2, fieldValue: false, MasterLabel : "xyz"}];
  editMode = true;
}