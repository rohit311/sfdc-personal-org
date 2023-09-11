import { LightningElement } from 'lwc';

export default class SvgButtonDemo extends LightningElement {

  textDirection = "auto";

  handleTextareaChange(event) {
    console.log("text : ",event.target.value);
  }

  handleTextDirectionBtnClick() {
    const menuItems = this.template.querySelector(".text-direction-items");
    if (menuItems) {
      menuItems.classList.toggle("slds-is-open");
    }
  }

  handleTextDirectionClick(event) {
    console.log("event : ",event.currentTarget.dataset.id);
  }

  async handleMenuBlur() {
    const menuItems = this.template.querySelector(".text-direction-items");
    await Promise.resolve();

    if (menuItems) {
      menuItems.classList.remove("slds-is-open");
    }
  }

  get disableUserActions() {
    return false;
  }
}