import { LightningElement, track } from 'lwc';

export default class TableDemo extends LightningElement {
  actualHoursItems = [{Id:1,Name:"abc",totalHours:2},
    {Id:2,Name:"pqr",totalHours:3},
    {Id:3,Name:"xyz",totalHours:4}
  ];

  @track modifiedActualHoursItems = [];

  connectedCallback() {
    this.modifiedActualHoursItems = this.actualHoursItems.map((obj,index,array) => ({ ...obj, isDisabled: index !== array.length-1 }));
  }

  handleClick() {
    const arrayLength = this.modifiedActualHoursItems.length;
    this.modifiedActualHoursItems[arrayLength - 1].isDisabled  = true;

    const newObj = {Id: this.modifiedActualHoursItems.length,Name: "wer" ,totalHours:5,isDisabled: false};
    this.modifiedActualHoursItems.push(newObj);
  }
}