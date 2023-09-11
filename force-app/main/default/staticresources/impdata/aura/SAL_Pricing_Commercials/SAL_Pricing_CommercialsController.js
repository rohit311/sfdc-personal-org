({
    doInit: function(component, event, helper) {
        console.log('ABC++'+component.get('v.applicantPrimary.ROI_PO__c'));
    },
    savePricingDetails: function(component, event, helper){
        if(component.find("salesapprovepf").get("v.validity").valid && component.find("approvedRateId").get("v.validity").valid)
        	helper.savePricingData(component,event);        
         else{
            component.find("salesapprovepf").showHelpMessageIfInvalid();
			component.find("approvedRateId").showHelpMessageIfInvalid();
            helper.displayMessage(component, 'ErrorLoanMsg', 'errormsg', 'Error! Please fill all required data')
        }
    },
    calculateDroplinePeriod: function(component,event,helper){
        if(component.get('v.isHybirdFlexi')==true){
            helper.calcDropLinePeriod(component,event);
        }
    },
    successLoanMsg: function (component, event, helper) {
        helper.successLoanMsg(component, event.target.id);
    },
    errorLoanMsg: function (component, event, helper) {
        helper.errorLoanMsg(component, event.target.id);
    }
})