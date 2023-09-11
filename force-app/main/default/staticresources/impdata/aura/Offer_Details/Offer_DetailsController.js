({
    showLoanNumber: function(component, event, helper){
        helper.setLoanNumber(component, event);
    },
    setOffer : function(component, event, helper){
        helper.setOfferDetails(component, event);
    },
    // Bug 15855 S 
    navigateToCPV : function(component, event, helper){
        console.log('Navigated to Loan'); 
        var oppId = component.get("v.loanId");
        console.log('oppId : '+ oppId);
		var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
          "recordId": oppId,
          "slideDevName": "related"
        });
        navEvt.fire();
        
    },
    previous : function(component, event, helper){
        component.set("v.showLoan", "false");
        //console.log('Back to documents');
        var verificationCmp = component.find('oppVerificationPopUp');
        verificationCmp.destroy();
    },
    // Bug 15855 E    
    openmodalCibil: function(component,event,helper) {
       
        var displayCibilEvent = $A.get("e.c:showCibilModal");
        console.log(displayCibilEvent);
        console.log('PO ID ',component.get("v.strPOID"));
        displayCibilEvent.setParams({ 
            "showCibil": 'True',
            "poId":component.get("v.strPOID")
        });
        displayCibilEvent.fire();
        
    },
     closeModalCibil:function(component,event,helper){    
        var cmpTarget = component.find('ModalboxCibil');
        var cmpBack = component.find('ModalbackdropCibil');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    }
})