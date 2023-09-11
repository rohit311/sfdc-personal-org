import { LightningElement ,track} from 'lwc';


const endpoint = 'https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=##&apikey=UKUWZ1DGI4ECRBAX';

export default class StockSearchComponent extends LightningElement {

    @track showLoading = false;
    @track errorMsg = '';
    strSearchName = '';

    handleSearchChange(event){
        this.strSearchName = event.detail.value;
    }

    handleSearch(){

        if(!this.strSearchName){
            //display error 
            this.errorMsg = 'Please enter security name to search.';
            return;
        }

        this.showLoading = true;

        fetch(endpoint)
        .then(response => {console.log(typeof response,response)})
        .catch(error => {
            this.errorMsg = error+'';
        })
        

    }
}