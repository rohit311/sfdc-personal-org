import { LightningElement } from 'lwc';

export default class LwcTag extends LightningElement {

  dtValue;

  renderedCallback() {
    console.log(` Rohit!!! ${this.getElementsByClassName('light-header')}`)
 }

  handleKeyUp(event) {
    if (event.key === "Enter" || event.keyCode === 13 || event.which === 13) {
      console.log("Enter key pressed");
    }
  }

  handleDateTimeChange() {
    console.log("In change");
  }
  handleDateTimeKeyUp() {

    console.log("In keyup");
  }

  handleOnBlur(event) {
    const dtField = this.template.querySelector("[data-field='dtField']");

    if (dtField) {
       console.log("checkValidity" , dtField.checkValidity());
    }
    const isfieldValid = event.target.validity.valid;
    console.log("isfieldValid" , isfieldValid);
  }

  handleClick() {
    const menuItems = this.template.querySelector(".menuItems");
      if (menuItems) {
        menuItems.classList.toggle("slds-is-open");
      }
  }

  handleMenuItemClick(event) {
    const dataId = event.currentTarget.dataset.id;
    console.log("dataId ", dataId);
    //do something on click
    const menuItems = this.template.querySelector(".menuItems");
      if (menuItems) {
        menuItems.classList.toggle("slds-is-open");
      }
  }
}