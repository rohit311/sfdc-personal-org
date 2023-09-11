import { LightningElement, track , api } from 'lwc';
import serachAccs from '@salesforce/apex/AccountsController.retriveAccs';

// datatable columns
const columns = [
    {
        label: 'Name',
        fieldName: 'AccName',
        type: 'url',
        typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}
    }, {
        label: 'Industry',
        fieldName: 'Industry',
    }, {
        label: 'Phone',
        fieldName: 'Phone',
        type: 'phone',
    }, {
        label: 'Type',
        fieldName: 'Type',
        type: 'text'
    },
];

export default class accountSearch extends LightningElement {

    @track searchData;
    @track columns = columns;
    @track errorMsg = '';
    @track showLoading = false;
    strSearchAccName = '';

    handleAccountName(event) {
        this.strSearchAccName = event.detail.value;
    }

    handleSearch() {
        if(!this.strSearchAccName) {
            
            this.errorMsg = 'Please enter account name to search.';
            this.searchData = undefined;
            return;
        }

        this.showLoading = true;
        serachAccs({strAccName : this.strSearchAccName})
        .then(result => {
            result.forEach((record) => {
                record.AccName = '/' + record.Id;
            });
            console.log('searchData',result);
            this.searchData = result;
            
        })
        .catch(error => {
            this.searchData = undefined;
            window.console.log('error =====> '+JSON.stringify(error));
            if(error) {
                this.errorMsg = 'Account not found !';
            }
        }) 
        .finally(() => this.showLoading = false)
    }
}