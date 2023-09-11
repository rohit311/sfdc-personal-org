import { LightningElement, track, api } from 'lwc';

export default class clock extends LightningElement {
    @track timestamp = new Date();

    @api
    refresh(){
        this.timestamp = new Date();
    }

}