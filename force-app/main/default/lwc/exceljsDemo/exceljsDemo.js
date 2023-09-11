import { LightningElement } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import ExcelJS from '@salesforce/resourceUrl/XLSX';


export default class ExceljsDemo extends LightningElement {
  currentUrl = window.location.href;

  async connectedCallback() {
    window.addEventListener('locationchange', function (event) {
      console.log("popstate ", event);
    });

    window.addEventListener("beforeunload", function (event) {
      alert("Hello");
    });
    this.initExcelJs();
  }

  renderedCallback() {
    this.currentUrl = window.location.href;
    console.log("changed url ",this.currentUrl);
  }


  async initExcelJs() {
    try {
      await loadScript(this,ExcelJS+'/unpkg/exceljs.min.js');
    } catch(error){
      console.log("error ", error);
    }
  }

  handleClick() {
    try {
      console.log("clicked");
    const workbook = new ExcelJS.Workbook();
    const worksheet = workbook.addworksheet('My worksheet');
    alert('line 13 sheet craeted');


  const fileName = 'MyData.xlsx';
  alert(filename);
    }catch(error) {
      console.log("error in excel workbook ",error.message);
    }

  }
}