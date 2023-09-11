import { LightningElement, track } from 'lwc';

export default class MyComponent extends LightningElement {
  @track isRequired;
  @track isDisabled;
  picklistOptions = [
    {label: "Zerodha",value:"1"},
    {label: "Groww",value:"2"},
    {label: "HDFC Sec",value:"3"}
  ];

  handleSelectionChange(event){
    console.log("changed value ",event.detail);
  }
}