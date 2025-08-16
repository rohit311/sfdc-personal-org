import { LightningElement, api } from 'lwc';

export default class ChildField extends LightningElement {

  isCheckbox = true;
  @api config;
  @api editMode = false;

  handleFieldChange(event) {

    let propName = event.target.getAttribute('data-recid');
    console.log(`propName : ${propName}`);
    console.log('tried with class'); //class is same as field name
    console.log(this.template.querySelector('.abc__c'));

    // tried querySelectorAll
    let inputs = this.template.querySelectorAll("lightning-input");
    inputs.forEach(function(element){
        //console.log('element name ' + element.name); //only the current checkbox(the one that the user clicks) is available //Training__c is available. Not the Workshop__c.
    });

    if (this.isCheckbox) {
      let value = event.target.checked;

        if(this.config.Field_API_Name__c === 'abc__c'){
            if(value){
                console.log('mark the other checkbox true::: ', this.template.querySelector('lightning-input[data-recid="xyz__c "]'));
                console.log('mark the other checkbox true::: ', this.template.querySelector('.xyz__c'));
                this.template.querySelector('lightning-input[data-recid="xyz__c "]').checked = true; //does not work
            }else{
                console.log('mark the other checkbox false');
                this.template.querySelector('.xyz__c').checked = false; //does not work
            }
        }
    }
}
}