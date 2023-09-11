import { LightningElement } from 'lwc';
import fetchProfiles from '@salesforce/apex/LightningProfileController.fetchProfiles';

export default class ProfileModify extends LightningElement {
    profilesList = new Array();
    pageList = new Array();
    currentPage = 1;
    recordsPerPage = 10;
    totalPages = 1;
    isPreviousButtonDisabled = false;
    isNextButtonDisabled = false;
    isShowSpinner = false;
    error = '';

    connectedCallback(){
        this.isShowSpinner = true;
        fetchProfiles()
            .then(result => {
                this.profilesList = result;
                this.totalPages = Math.ceil(this.profilesList.length/this.recordsPerPage);
                this.setNavigationButtonsStatus();
                this.setPageRecords();
                console.log('total records ', this.profilesList.length);
            })
            .catch(error => {
                this.error = error;
            })
            .finally(() => {
                this.isShowSpinner = false;
            });
    }

    handlePreviousClick(){
        this.currentPage -= 1;

        this.setNavigationButtonsStatus();
        this.setPageRecords();
    }

    handleNextClick(){
        this.currentPage += 1;

        this.setNavigationButtonsStatus();
        this.setPageRecords();
    }

    setPageRecords(){
        let startIndex = (this.currentPage-1)*this.recordsPerPage;
        let stopIndex = startIndex+this.recordsPerPage;

        if(stopIndex > this.profilesList.length){
            stopIndex = this.profilesList.length;
        }

        this.pageList = this.profilesList.slice(startIndex,stopIndex);
    }

    setNavigationButtonsStatus(){
        if(this.currentPage === 1){
            this.isPreviousButtonDisabled = true;
            this.isNextButtonDisabled = false;
        }
        else if(this.currentPage === this.totalPages){
            this.isPreviousButtonDisabled = false;
            this.isNextButtonDisabled = true;
        }
        else{
            this.isPreviousButtonDisabled = false;
            this.isNextButtonDisabled = false;
        }
    }

}