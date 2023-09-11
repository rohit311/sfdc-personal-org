({
    subscribeToOffer : function(component, event, helper) {
        helper.subscribeToOffer(component, event);
    },
    // Bug 24313 S
    closeModal : function(component,event){    
        var cmpTarget = component.find('overrideModalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        
    },
    //Made changes to this method for bug 24313.
    saveOffers : function(component, event, helper) {
        debugger;
        var timestamp = component.get("v.applicantObj.IP_Address_Timestamp__c");
        var appformtime = component.get("v.applicantObj.Application_Form_Timestamp__c");
        var cmpTarget = component.find('overrideModalbox');
        var cmpBack = component.find('Modalbackdrop');
        
        if(timestamp && appformtime){
            if(timestamp.includes('Accepted') || appformtime.includes('Accepted')){
                $A.util.addClass(cmpTarget, 'slds-fade-in-open');
                $A.util.addClass(cmpBack,'slds-backdrop--open');
            }
            else{
                
                $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
                $A.util.removeClass(cmpBack,'slds-backdrop--open');
                helper.saveOffersHelper(component, event);  
            }
        } else {
            helper.saveOffersHelper(component, event);
            
        }        
    },
    saveoffersModal:function(component, event, helper) {
        var cmpTarget = component.find('overrideModalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        helper.saveOffersHelper(component, event);
    },
    //Bug 24313 e
	//Added for Bug 24667
    doInit : function (component, event, helper) {
       
        console.log('doinitPricOFF'+component.get("v.isPreapproved"));
  		helper.validateSolList(component, event);
        helper.handleUpdateSol(component, event);
    },
    deleteRecord :function(component, event, helper) {
      helper.deleteRecord(component, event);  
    },
    editRecord :function(component, event, helper) {
        helper.editRecord(component, event);
    },
    addNewRecord : function(component, event, helper) {
        helper.validateSolList(component, event);
        helper.addNewRecord(component, event);
    },
    handleUpdateSol : function(component, event, helper) {
       helper.handleUpdateSol(component, event);
	}
    //Added for Bug 24667
})