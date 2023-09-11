import { LightningElement, wire } from 'lwc';
import { getListUi } from 'lightning/uiListApi';

import CASE_OBJECT from '@salesforce/schema/Case';
import NUMBER_FIELD from '@salesforce/schema/Case.CaseNumber';

export default class ListViewComponent extends LightningElement {
  @wire(getListUi, {
    objectApiName: CASE_OBJECT,
    listViewApiName: 'My_Cases',
    sortBy: NUMBER_FIELD,
    pageSize: 10
})
listView;

get casesList() {
  console.log("records ",this.listView.data.records.records);
  return this.listView.data.records.records;
}
renderedCallback() {
  console.log("casesList ",this.casesList);
}
}