({
    getDetails: function(component, event, helper){ 
        component.set("v.poId", event.getParam("po").Id);
        var offer = event.getParam("offer");
        helper.getProductOfferings(component, !!offer.converted, !!offer.submitted);
        helper.populateFieldDispositionData(component, !!offer.converted);
        if(offer.converted){
            helper.disableForm(component);
            helper.triggerPostConvertEvent(component, offer.loanNumber,offer.loanId);
        }
    },
    onfieldDispoChange: function(component, event, helper) {
        helper.closeToast(component);
        helper.onDataChange(component);
        helper.populateDispositionData(component);
        helper.showHideFollowupFields(component);
	},
    onDispoChange: function(component, event, helper) {
        helper.closeToast(component);
        helper.onDataChange(component);
        helper.populateFieldCheckData(component);
	},
    onOfferDateChange: function(component, event, helper){debugger;
        console.log(component.find("offerDate").get("v.value"));
    },
    onCreditOfficerChange: function(component, event, helper){
        helper.closeToast(component);
        helper.disableButtons(component, false, true, true, true, !component.find("creditOfficer").get("v.value"));
    },
    populateCreditSelectList: function(component, event, helper){
        helper.closeToast(component);
    	helper.populateCreditSelectList(component); 
    },
    convertToLoanApplication: function(component, event, helper) {
        helper.closeToast(component);
    	helper.convertToLoanApplication(component);
	},
    submitCreditApprover: function(component, event, helper) {
        helper.closeToast(component);
        helper.submitCreditApprover(component);
	},
    onDataChange: function(component, event, helper){
        helper.closeToast(component);
        helper.onDataChange(component);
    },
    saveDispositionData: function(component, event, helper) {
        helper.closeToast(component);
        if(helper.validate(component)){
            helper.saveDispositionData(component);
        }
	},
    validateMobileNumber: function(component, event, helper){
        helper.onDataChange(component);
    	helper.validateField(component, "alternateMobileNumber", /^[7-9]\d{9}/, "mobile number");
    },
    closeCustomToast: function(component, event, helper){
        helper.closeToast(component);
    },
    showSpinner: function(component, event, helper){
        $A.util.removeClass(component.find("waiting"),"slds-hide");
    },
    hideSpinner: function(component, event, helper){
        $A.util.addClass(component.find("waiting"),"slds-hide");
    }
})