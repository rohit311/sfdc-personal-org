import { LightningElement , api , track} from 'lwc';

export default class CustomToast extends LightningElement {
    @track iconName;
    @track message;
    @track showToast;

    @api changeshowToast(){
        this.showToast = !this.showToast;
    }

    @api changeMessage(message){
        this.message = message;
    }

    @api changeiconName(iconName){
        this.iconName = iconName;
    }

    handleCloseClick(){
        this.showtoast = false;
    }


}