({
	doInit : function(component, event, helper) {
             //          console.log('inhrvas'+component.get("v.currentStageIsMydetails")); //stage gets change to POST APProval, so its false
        //if(component.get("v.currentStageIsMydetails")!=true)
        //{
        //spinner call start
        helper.getDisbursmentData(component,event);
        helper.getFeesAndChargesData(component,event);
        // Added by Anurag for 22181 23390 S
        if (!component.get("v.showInDisbSectionFlag")){
			helper.getInsuranceList(component,event);
        	console.log('after insurance');
        }
        if(component.get("v.displayReadOnly")==true)
        {
            if(!component.get("v.showInDisbSectionFlag")){
        		// var valInsBtn = component.find("validateInsuranceBtn");
            	// console.log('val Ins Btn '+valInsBtn);
			   // valInsBtn.set("v.disabled", true);
			   component.set("v.isValInsDisabled", true);
            }
        }

		// Added by Anurag for 22181 23390 E
		console.log('Fees list recieved '+ component.get('v.FeesListRecieved'));
        if(component.get('v.FeesListRecieved') != true){
        	helper.callFeesAndCharges(component,event); 
        }
        //spinner call end 
         var cmpTarget = component.find('overrideModalbox');
        $A.util.removeClass(cmpTarget, 'slds-show');
        $A.util.addClass(cmpTarget, 'slds-hide');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack, 'slds-backdrop_open');
       // }
	},
	
	// Start of changes - 22181
	validateInsurance : function(component, event, helper) {
		helper.validateInsuranceHelper(component, event, helper);
    },
	// End of changes - 22181
	// Added by Anurag for 22181 23390 S
	hideValIns : function(component, event, helper){
        if (!component.get("v.showInDisbSectionFlag")){
            var lstIns = event.getParam("insuranceList");
            // var valInsBtn = component.find("validateInsuranceBtn");
            // console.log("lstIns: ",JSON.stringify(lstIns));
            if(lstIns && lstIns.length)
                component.set("v.isValInsDisabled", false);
            else
                component.set("v.isValInsDisabled", true);
        }
	},
	// Added by Anurag for 22181 23390 E
    saveFees : function(component, event, helper) {
        helper.saveFeesAndCharges(component,event);
    },
    NavigateToNext : function(component,event,helper) {
		// Start of changes - 22181
		var nextBtn = component.find("Next");
		if(nextBtn) {
			nextBtn.set("v.disabled", true);
			helper.validateInsuranceBeforeNextStageHelper(component, event, helper);
		}
		// End of changes - 22181
    },
    // Added by Anurag for 22181 S
    insValidationOnDsbrsmntScrn : function(component,event,helper) {
        console.log("VALIDATION EVT HANDLED");
        // event.stopPropagation();
        // event.pause();
        
		helper.validateInsuranceBeforeNextStageHelper(component, event, helper);
    },
    destoryCmp : function (component, event, helper) {
        this.superUnrender();
        component.destroy();
    },
    // Added by Anurag for 22181 E
    showMessage : function(component,event,helper){
       // alert('in click');
        var cmpTarget = component.find('overrideModalbox');
         var cmpBack = component.find('Modalbackdrop');
        var chargeId = event.currentTarget.id;
		//var chargeId = a.getLocalId();
        /*var source = event.getSource();
        var chargeId = source.get("v.aura:Id");*/
        console.log('aura:id is '+ chargeId);
        if(chargeId == '500735'){
             component.set("v.HelpText","Financial Fitness Report (FFR) helps you assesses your credit standing basis your credit score, income and current financial commitments. \n Features and Benefits: \n 1. Detailed assessment and evaluation of your credit worthiness, borrowing power and saving potential \n 2. Do's and Don'ts of good credit behaviour \n 3. Credit score description  and  your performance across various components of the score \n 4. Assessment of credit behaviour, credit mix and credit health ratio \n");
        }
        else if(chargeId == '600928'){
        }
        else if(chargeId == '28025'){
                
        }
        //$A.util.addClass(cmpTarget, 'slds-fade-in-open');
         $A.util.removeClass(cmpTarget, 'slds-hide');
         $A.util.addClass(cmpTarget, 'slds-show');
         $A.util.addClass(cmpBack, 'slds-backdrop_open');
    },
    closeMessage : function(component,event,helper){
        var cmpTarget = component.find('overrideModalbox');
         var cmpBack = component.find('Modalbackdrop');
        //$A.util.addClass(cmpTarget, 'slds-fade-in-open');
         $A.util.removeClass(cmpTarget, 'slds-show');
         $A.util.addClass(cmpTarget, 'slds-hide');
         $A.util.removeClass(cmpBack, 'slds-backdrop_open');
    }
})