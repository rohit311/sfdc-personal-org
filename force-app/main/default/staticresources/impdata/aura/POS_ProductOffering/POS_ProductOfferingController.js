({
    getDetails: function(component, event, helper){ 
        component.set("v.poId", event.getParam("po").Id);
        
        //POS YK s
        component.set("v.stpNonStp", event.getParam("po").Process_Master__c); //Bug-18337--changed to offer
        
        var offer = event.getParam("offer");
        component.set("v.loanId",offer.loanId);
        //POS YK e
       
        if(offer.converted === "true"|| offer.converted === true){
            component.set("v.isconvertedPO", true);
         
            
        }	
       
        
        helper.getProductOfferings(component, !!offer.converted, !!offer.submitted);
        helper.populateFieldDispositionData(component, !!offer.converted);
       
        if(offer.converted === "true" || offer.converted === true){
            helper.disableForm(component);
            helper.triggerPostConvertEvent(component, offer.loanNumber, offer.loanId);
        }
    },
    onfieldDispoChange: function(component, event, helper) {
        helper.closeToast(component);
        helper.onDataChange(component);
        // 8734:USERSTORY_Disposition starts 
        helper.populateDispositionData(component,false,false);
        // 8734:USERSTORY_Disposition ends 
        helper.showHideFollowupFields(component);
	},
    onDispoChange: function(component, event, helper) {
        helper.closeToast(component);
        helper.onDataChange(component);
        helper.populateFieldCheckData(component,false,false);
	},
    onOfferDateChange: function(component, event, helper){debugger;
        console.log(component.find("offerDate").get("v.value"));
    },
    onCreditOfficerChange: function(component, event, helper){
        helper.closeToast(component);
      //  alert('onCreditOfficerChange --->> ');
        helper.disableButtons(component, false, true, true, true, !component.find("creditOfficer").get("v.value"));
    },
    populateCreditSelectList: function(component, event, helper){
        helper.closeToast(component);
    	helper.populateCreditSelectList(component); 
    },
    convertToLoanApplication: function(component, event, helper) {
        helper.closeToast(component);
        console.log('campaign type --> ' + component.get("v.po.Campaign_Type__c"));// US : 13265
        console.log('data source --> ' + component.get("v.po.Lead__r.Data_Source__c"));// US : 13265
    	if (
            component.get("v.CkycMandate") == true && 
            ($A.util.isEmpty(component.get("v.po.Campaign_Type__c")) && $A.util.isEmpty(component.get("v.po.Lead__r.Data_Source__c")))
        ) {// US : 13265
            helper.showToast(component, "Error!","Please initaite CKYC for this product offering", "error");// US : 13265
        } else {// US : 13265
            helper.convertToLoanApplication(component);// US : 13265
        }// US : 13265
        //helper.convertToLoanApplication(component);
    	//helper.convertToLoanApplication1(component);
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
              // Bug 22425 CC Code changes SME S 
              debugger;
            if(component.get("v.ccAlert")) { // US : 2702
                helper.showToast(component, "Error",'You have not checked Credit Card Preference of Customer', "Error");// US : 2702
                return;
            }// US : 2702
            // Bug 22425 CC Code changes SME E
           // Bug 24487 EMI Card
            helper.getEmiCardPrefValidation(component);
            //helper.saveDispositionData(component);
        }
	},
    validateMobileNumber: function(component, event, helper){
        component.set("v.po.Alternate_Mobile_No__c", (''+component.get("v.po.Alternate_Mobile_No__c")).replace(/[a-zA-z]/g, ''));
        helper.onDataChange(component);
    	console.log(helper.validateField(component, "alternateMobileNumber", /^[7-9]\d{9}/, "mobile number"));
    },
    closeCustomToast: function(component, event, helper){
        helper.closeToast(component);
    },
    showSpinner: function(component, event, helper){
        $A.util.removeClass(component.find("waiting"),"slds-hide");
    },
    hideSpinner: function(component, event, helper){
        $A.util.addClass(component.find("waiting"),"slds-hide");
    }, 
    
    setStpNonStpData : function(component, event, helper){
        component.set("v.stpNonStp", event.getParam('flowName'));
    },
    
     gotoLoanApplication : function(component, event, helper) {
     
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            //componentDef : "c:POS_LA_Pro_Cmp",
            componentDef : "c:Open_Existing_LAN",
            componentAttributes: {
                //LoanId : component.get("v.loanId")
                recordId : component.get("v.loanId")
            }
        });
        evt.fire();
         var dismissActionPanel = $A.get("e.force:closeQuickAction");
		dismissActionPanel.fire();

	},
	setccData:function(component, event, helper) {//US : 2702
        debugger;
        console.log('setccData here --> ');
        try {
            var resp = event.getParam("ccData");
            if (!$A.util.isEmpty(resp)) {
               console.log('resp --> ', resp);
               component.set("v.ccAlert", false);
            } else {
                component.set("v.ccAlert", true);
            }
        } catch (e) {
            console.log('exception in CC_Data event from CC --> ', e);
        }
    }
 
})