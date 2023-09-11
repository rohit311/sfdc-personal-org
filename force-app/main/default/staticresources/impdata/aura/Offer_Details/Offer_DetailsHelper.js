({
	setLoanNumber: function(component, event){
        component.set("v.loanNumber", event.getParam('loanNumber'));
        component.set("v.loanId", event.getParam('loanId'));	// Bug 15855
        this.showHideDiv(component, "loanNumberField", true);
    },
    setOfferDetails: function(component, event){
        console.log("PO ID ",component.get("v.poID"));
        var offer = event.getParam('offer') || {};
        //PSL changes : Nikhil Bugfix #11800 Added isempty check 
        if(!this.isEmpty(offer) && 
           (!this.isEmpty(offer.offerAmount) || !this.isEmpty(offer.segmentation) || !this.isEmpty(offer.cibilScore))){
            component.set("v.offerAmount", offer.offerAmount);
            component.set("v.segmentation", offer.segmentation);
            component.set("v.cibilScore", offer.cibilScore);
            component.set("v.loanNumber", offer.loanNumber);
			component.set("v.loanId", offer.loanId);
            console.log('PO id ',offer.strPOID);
            component.set("v.strPOID",offer.strPOID);
            console.log('cibil id ',offer.strCIBILID);
            component.set("v.cibilID",offer.strCIBILID);
            this.showHideDiv(component, "offerDetails", true);
            this.showHideDiv(component, "loanNumberField", false);
        }
    },
    showHideDiv: function(component, divId, show){
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
    //PSL changes : Nikhil Bugfix #11800
    /*
     * @author	: Nikhil S
     * @date	: 03/07/2017 
     * @desc	: This method return true if the given value is empty or undefined
     * 
     */
    isEmpty: function(value){
        return ($A.util.isEmpty(value) || $A.util.isUndefined(value));
    }
})