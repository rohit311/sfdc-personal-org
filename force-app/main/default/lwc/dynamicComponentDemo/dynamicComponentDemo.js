import { LightningElement } from 'lwc';

export default class DynamicComponentDemo extends LightningElement {
  componentConstructor;
  // Use connectedCallback() on the dynamic component
  // to signal when it's attached to the DOM
  connectedCallback() {
    import("c/contactListCmp")
      .then(({ default: ctor }) => (this.componentConstructor = ctor))
      .catch((err) => console.log("Error importing component"));
  }
}