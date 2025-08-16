import { getListInfoByName } from 'lightning/uiListsApi';
import { api, LightningElement, wire } from 'lwc';
import CONTACT_OBJECT from "@salesforce/schema/Contact";

export default class ContactListCmp extends LightningElement {
  error;
  displayColumns;
  @api recordId;
  @wire(getListInfoByName, {
    objectApiName: CONTACT_OBJECT.objectApiName,
    listViewApiName: "AllContacts",
  })
  listInfo({ error, data }) {
    if (data) {
      console.log("data: ", JSON.parse(JSON.stringify(data)));
      this.displayColumns = data.displayColumns;
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.displayColumns = undefined;
    }
  }

  get acceptedFormats() {
    return ['.pdf', '.png'];
}

handleUploadFinished(event) {
    // Get the list of uploaded files
    const uploadedFiles = event.detail.files;
    console.log("uploadedFiles: ", uploadedFiles);
}
}