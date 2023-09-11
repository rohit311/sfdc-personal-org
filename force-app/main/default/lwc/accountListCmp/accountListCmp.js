import { LightningElement, wire, api } from 'lwc';
import {getListUi} from 'lightning/uiListApi';

import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';

const columns = [
    { label: 'Label', fieldName: 'name' }
];

export default class AccountListCmp extends LightningElement {

    @wire(getListUi,{
        objectApiName: ACCOUNT_OBJECT,
        listViewApiName: 'AllAccounts',
        sortBy: NAME_FIELD,
        pageSize: 10
    })
    listView;

    @api
    get accounts() {
        console.log('accounts ',this.listView.data);
        if(this.listView.data && this.listView.data.records && this.listView.data.records.records)
        return this.listView.data.records.records;
    }
}