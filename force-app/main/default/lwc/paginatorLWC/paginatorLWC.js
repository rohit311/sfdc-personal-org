import { LightningElement, wire } from "lwc";
import fetchRecords from "@salesforce/apex/paginatorController.fetchRecords";

export default class PaginatorLWC extends LightningElement {
  @wire(fetchRecords) wiredRecords({ data, error }) {
    if (data) {
      this.records = data;
      this.recordsToDisplay = this.records.slice(
        0,
        Number(this.recordsPerPage)
      );
    } else {
      this.error = error;
    }
  }
  records = [];
  recordsToDisplay;
  error = "";
  columns = [
    { label: "Account Name", fieldName: "Name" },
    { label: "Phone", fieldName: "Phone", type: "phone" },
    { label: "Active", fieldName: "Active__c" }
  ];
  recordsPerPage = "10";

  handlePageSizeChange(event) {
    this.recordsPerPage = event.detail.value;
    this.recordsToDisplay = this.records.slice(0, Number(this.recordsPerPage));
    console.log("recordsPerPage : ", this.recordsPerPage);
  }

  handleNavigation(event) {
    console.log("event : ", event.target.name);
    const buttonClicked = event.target.name;

    if (buttonClicked === "first") {
      this.navigateToPage(1);
    }
  }

  navigateToPage(pageNumber) {}

  get recordsPerPageOptions() {
    return [
      { label: "10", value: "10" },
      { label: "20", value: "20" },
      { label: "50", value: "50" }
    ];
  }

  scrollCheck(event){
    console.log('Current value of the input: ' + event.target.scrollTop);
    console.log('Current value of the input: ' + event.target.scrollBottom);
  }

  renderedCallback() {
    /*let div= this.refs.myDiv;
    console.log(':div:',div)
    div.onscroll = this.scrollCheck;*/
  }
}