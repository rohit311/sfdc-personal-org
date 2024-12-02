/* eslint-disable @lwc/lwc/no-async-operation */
import { LightningElement, track } from 'lwc';
import getAccounts from '@salesforce/apex/AccountListViewCtrl.getAccounts';
import getTotalAccountRecords from '@salesforce/apex/AccountListViewCtrl.getTotalAccountRecords';
import getAccountsBySearch from '@salesforce/apex/AccountListViewCtrl.getAccountsBySearch';
import updateAccounts from '@salesforce/apex/AccountListViewCtrl.updateAccounts';
import { ShowToastEvent } from "lightning/platformShowToastEvent";


const PAGE_SIZE = 10;
export default class CustomDataTable extends LightningElement {
  @track records = [];
  @track recordsToEdit = {};
  @track pageNumber = 0;
  @track totalPages = 0;
  @track apexCallIsInProgress = false;
  @track debounceTimer;
  @track showSortIcon = false;
  @track showSortIconOnHover = false;
  @track columns = [
    {
      name: "Account Name",
      id: "Name",
      sortable: false,
      editable: false,
      editModeIsVisible: false,
      showEditIcon: false
    },
    {
      name: "Industry",
      id:"Industry",
      sortable: true,
      editable: false,
      sortOrderIsAsc: true,
      editModeIsVisible: false,
      showEditIcon: false
    },
    {
      name: "Annual Revenue",
      id: "AnnualRevenue",
      sortable: true,
      editable: true,
      sortOrderIsAsc: true,
      editModeIsVisible: false,
      showEditIcon: true
    }
  ];

  constructor() {
    super();
    this.navigateToPage();
  }

  connectedCallback() {
    getTotalAccountRecords()
    .then(resp => {
      this.totalPages = Math.ceil(resp/PAGE_SIZE);
      console.log("totalPages: ", this.totalPages);
    })
    .catch(error => {
      console.log("Error", error);
    })
    .finally(() => {
      this.apexCallIsInProgress = false;
    });
  }

  navigateToPage(sortField="Name", sortOrder="ASC") {
    this.apexCallIsInProgress = true;
    getAccounts({pageSize: PAGE_SIZE, pageNumber: this.pageNumber? this.pageNumber : 0,sortField: sortField, sortOrder: sortOrder})
    .then(resp => {
      this.records = resp.map((rec) => {
        return {...rec, url: `/${rec.Id}`};
      });
      console.log("records:", resp);
    })
    .catch(error => {
      console.log("Error", error);
    })
    .finally(() => {
      this.apexCallIsInProgress = false;
    });
  }

  handleNavigation(event) {
    const buttonClicked = event.target.name;

    if (buttonClicked === "previous" && this.pageNumber > 1) {
      this.pageNumber -= 1;
    } else if (buttonClicked === "first") {
      this.pageNumber = 1;
    } else if (buttonClicked === "last") {
      this.pageNumber = this.totalPages - 1;
    } else {
      this.pageNumber += 1;
    }

    this.navigateToPage();
  }

  handleSearchKeyUp(searchString) {

    this.pageNumber = 1;

    // Debounce the event for 1 second
    window.clearTimeout(this.debounceTimer);
    this.debounceTimer = setTimeout(()=>{
      console.log("search keyword :", searchString);
      this.apexCallIsInProgress = true;
      getAccountsBySearch({
        searchKeyword: searchString,
        pageSize: PAGE_SIZE,
        pageNumber: this.pageNumber? this.pageNumber : 1
      })
      .then((resp) => {
        this.records = resp;
      })
      .catch((error) => {
        console.log("Error", error);
      })
      .finally(() => {
        this.apexCallIsInProgress = false;
      });
  }, 1000)
  }

  handleCommit(event) {
    const searchString = event.target.value;
    console.log("search keyword :", searchString);

    if (!searchString) {
      this.pageNumber = 1;
      this.navigateToPage();

      return;
    }

    this.handleSearchKeyUp(searchString);
  }

  handleColumnSort(event) {
    event.preventDefault();

    let sortOrder = "ASC";
    if (!this.showSortIcon) {
      this.showSortIcon = true;
    }
    const columnId = event.currentTarget.dataset.id;

    const indexOfColumn = this.columns.findIndex((col) => col.id === columnId);

    if (indexOfColumn !== -1) {
      this.columns[indexOfColumn].showSortIcon = true;
      this.columns[indexOfColumn].sortOrderIsAsc = !this.columns[indexOfColumn].sortOrderIsAsc;
      sortOrder = this.columns[indexOfColumn].sortOrderIsAsc ? "ASC" : "DESC";
    }

    this.navigateToPage(columnId, sortOrder);

  }

  handleMouseOverForSort(event) {

    const columnId = event.currentTarget.dataset.id;
    const indexOfColumn = this.columns.findIndex((col) => col.id === columnId);

    if (indexOfColumn !== -1 && !this.columns[indexOfColumn].showSortIcon) {
      this.columns[indexOfColumn].showSortIconOnHover = true;
    }

  }

  handleMouseLeaveForSort(event) {
    const columnId = event.currentTarget.dataset.id;
    const indexOfColumn = this.columns.findIndex((col) => col.id === columnId);

    if (indexOfColumn !== -1 && !this.columns[indexOfColumn].showSortIcon) {
      this.columns[indexOfColumn].showSortIconOnHover = false;
    }
  }

  handleMouseOverForEdit(event) {
    const recordId = event.currentTarget.dataset.id;
    const currentRecord = this.records.findIndex((rec) => rec.Id === recordId);
    this.records[currentRecord].showEditIcon = true;
  }

  handleMouseLeaveForEdit(event) {
    const recordId = event.currentTarget.dataset.id;
    const currentRecord = this.records.findIndex((rec) => rec.Id === recordId);
    this.records[currentRecord].showEditIcon = false;
  }

  handleInlineEdit(event) {
    const recordId = event.currentTarget.dataset.id;
    console.log("recordId: ", recordId);
    const currentRecord = this.records.findIndex((rec) => rec.Id === recordId);
    this.records[currentRecord].showFieldEdit = true;
  }

  handleRevenueChange(event) {
    this.recordsToEdit[event.currentTarget.dataset.id] =  event.detail.value;
  }

  handleInlineSave() {
    const recordsMap = {...this.recordsToEdit};
    this.apexCallIsInProgress = true;
    updateAccounts({accList: JSON.stringify(recordsMap)})
    .then((res) => {
      console.log("res", res);
      this.recordsToEdit = new Map();
      this.navigateToPage();
      this.showNotification("Success", "Records updated !", "success");
    })
    .catch(() => {
      this.showNotification("Error", "Error while saving, please contact Administrator", "error");
    })
    .finally(() => {
      this.apexCallIsInProgress = false;
    });
  }

  showNotification(titleText,messageText, variant) {
    const evt = new ShowToastEvent({
      title: titleText,
      message: messageText,
      variant: variant,
    });
    this.dispatchEvent(evt);
  }

  isEmpty(value) {
    for (let prop in value) {
      if (value.hasOwnProperty(prop)) return false;
    }
    return true;
  }

  get areRecordsAvailable() {
    return this.records.length > 0;
  }

  get prevoiusBtnIsDisabled() {
    return this.pageNumber === 1 || this.apexCallIsInProgress;
  }

  get nextBtnIsDisabled() {
    return this.pageNumber > this.totalPages || this.apexCallIsInProgress;
  }

  get showSaveButton() {
    return !this.isEmpty(this.recordsToEdit);
  }

  get disableFirstPageBtn() {
    return this.pageNumber === 1;
  }

  get disableLastPageBtn() {
    return this.pageNumber === this.totalPages - 1;
  }

}