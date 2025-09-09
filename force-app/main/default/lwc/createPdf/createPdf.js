import { LightningElement } from 'lwc';
import generatePdf from '@salesforce/apex/PdfLwcCntrl.generatePdf';

export default class CreatePdf extends LightningElement {

  saveAsPdf() {
    generatePdf({recordId: "0012800000ExMLpAAN"})
    .then((result) => {
      console.log("attachment id - ", result.Id);
    })
    .catch((error) => {
      console.log("error: ", error);
    });
  }
}