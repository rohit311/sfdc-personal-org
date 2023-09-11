import { LightningElement } from 'lwc';

export default class PageDemo extends LightningElement {


  firstPage = true;
 secondPage = false;
 currentvalue = 0;
 currentLabel = '';
 stages = [];

handleNext(){
    let currIndex = this.currentvalue-1;
       // this.currentvalue = this.stages[currIndex+1].value;
       // this.currentLabel = this.stages[currIndex+1].label;
        this.secondPage = true;
        this.firstPage = false;
}

handlePrevious(){
    console.log('current Value-- ', this.currentvalue);
    let currIndex = this.currentvalue-1;
    console.log('currIndex -- ', currIndex);
        //this.currentvalue = this.stages[currIndex-1].value;
        //this.currentLabel = this.stages[currIndex-1].label;
        this.firstPage = true;
        this.secondPage = false;
}
}