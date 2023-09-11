import { LightningElement } from 'lwc';

export default class apiFunctionDemo extends LightningElement {
    handleClick(){
        this.template.querySelector('c-clock').refresh();
    }


}