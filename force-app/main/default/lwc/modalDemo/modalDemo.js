/* eslint-disable no-console */
import { LightningElement, wire, track } from 'lwc';
import { getPicklistValues, getPicklistValuesByRecordType, getObjectInfo } from 'lightning/uiObjectInfoApi';
import ACCOUNT_SOURCE from '@salesforce/schema/Account.AccountSource';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import createAccount from '@salesforce/apex/AccountProcessor.createAccount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
/*
    getPicklistValues -
        RecordtypeId - Required... 
        fieldApiName - Required
*/
/*
    getPicklistValuesByRecordType
        recordTypeId - Required Type Id (Real One)
        objectApiName - API Name of your Object

*/
export default class PicklistDemo extends LightningElement {
    @track pickListvalues;
    @track error;
    @track values;
    @track pickListvaluesByRecordType;
    @track accountsource;
    @track accObj = new Object();
    @track showtoast;

    @wire(getPicklistValues, {
        recordTypeId : '0120I000000nhOU',
        fieldApiName : ACCOUNT_SOURCE
    })
        wiredPickListValue({ data, error }){
            if(data){
                console.log(` Picklist values are `, data.values);
                this.pickListvalues = data.values;
                this.error = undefined;
            }
            if(error){
                console.log(` Error while fetching Picklist values  ${error}`);
                this.error = error;
                this.pickListvalues = undefined;
            }
        }
    @wire(getPicklistValuesByRecordType, {
        recordTypeId : '0120I000000nhOU',
        objectApiName : ACCOUNT_OBJECT
    })
        wiredRecordtypeValues({data, error}){
            if(data){
                console.log(' Picklist Values ', data.picklistFieldValues.Industry.values);
                this.pickListvaluesByRecordType = data.picklistFieldValues.Industry.values;
                this.accountsource = data.picklistFieldValues.AccountSource.values;
            }
            if(error){
                console.log(error);
            }
        }
    @wire(getObjectInfo,{
        objectApiName : ACCOUNT_OBJECT
    })
        wiredObject({data, error}){
            if(data){
                console.log(' Object iformation ', data);
                console.table(data);
            }
            if(error){
                console.log(error);
            }
        }


    handleChange(event){
        if(event.target.label == 'Name'){
            this.accObj.Name = event.target.value;
        }
        else if(event.target.label == 'E-mail'){
            this.accObj.Email = event.target.value;
        }
        else if(event.target.label == 'Type'){
            this.accObj.type = event.target.value;
        }
        console.log('picklistValues ');
    }

    handleSave(){
        console.log('accobj ',this.accObj);
        createAccount({jsonData : JSON.stringify(this.accObj)})
        .then(result => {
            console.log('here ',result);
            this.template.querySelector('c-custom-Toast').changeshowToast();
            this.template.querySelector('c-custom-Toast').changeMessage('Record saved successfully !');
            this.template.querySelector('c-custom-Toast').changeiconName('action:approval');
        })
        .catch(error => {
            this.error = error;
        });
    }


}