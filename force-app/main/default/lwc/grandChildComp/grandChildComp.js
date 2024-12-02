import { LightningElement, api} from 'lwc';

export default class GrandChildComp extends LightningElement {

  @api
  myRecordId;

  constructor(){
    super();
    console.log("In grandchild - constructor:");
  }

  connectedCallback() {
    console.log("In grandchild - connectedCallback");
  }
  renderedCallback() {
    console.log("In grandchild - renderedCallback");
  }

  get acceptedFormats() {
    return ['.pdf', '.png'];
}

handleUploadFinished(event) {
    // Get the list of uploaded files
    const uploadedFiles = event.detail.files;
}
}