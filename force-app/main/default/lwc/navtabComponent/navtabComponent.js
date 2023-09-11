import { LightningElement,api } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';

export default class navtabComponent extends NavigationMixin(LightningElement) {
    @api tabName;
    @api label;
    navigateNext(){
        this[NavigationMixin.Navigate]({
            type: 'standard__Account',
            attributes: {
                apiName: this.tabName,
            }
        });
    }

    navigateToObjectHome(){
        this[NavigationMixin.Navigate]({
            type:'standard__objectPage',
            attributes:{
                objectApiName: 'Case',
                actionName: 'home'
            }
        });

    }

    navigateToListView(){
        this[NavigationMixin.Navigate]({
            type:'standard__objectPage',
            attributes:{
                objectApiName: 'Contact',
                actionName: 'list'
            }
        });
    }
}