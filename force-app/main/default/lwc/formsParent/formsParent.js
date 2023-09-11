import { LightningElement } from 'lwc';

export default class FormsParent extends LightningElement {

  get options() {
    return [
        { label: 'New', value: 'new' },
        { label: 'In Progress', value: 'inProgress' },
        { label: 'Finished', value: 'finished' },
    ];
  }

  handleValidate() {
    const childcomp = this.template.querySelector('c-forms-demo');

    const inputFields = childcomp.querySelectorAll(".inp-cls");
    console.log("inputFields  ",JSON.parse(JSON.stringify(inputFields)));
  }

   _selected = [];

    get options() {
        return [
            { label: 'English', value: 'en' },
            { label: 'German', value: 'de' },
            { label: 'Spanish', value: 'es' },
            { label: 'French', value: 'fr' },
            { label: 'Italian', value: 'it' },
            { label: 'Japanese', value: 'ja' },
        ];
    }

    get selected() {
        return this._selected.length ? this._selected : 'none';
    }

    handleChange(e) {
        this._selected = e.detail.value;
    }
}