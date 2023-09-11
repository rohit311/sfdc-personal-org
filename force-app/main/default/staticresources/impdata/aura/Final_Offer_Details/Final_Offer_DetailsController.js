({
    doInit : function(component, event, helper) {
                        console.log('CAMI IS +' +JSON.stringify(component.get("v.camObj")));
	helper.showhidespinner(component,event,true); 
  if(!component.get("v.isPreapproved") && component.get('v.account.Offer_Inhanced__c')) //US 1652
        {
            component.find("fetchOff").set("v.disabled",true);//US 1652
            component.find("loanVariant").set("v.disabled",true);//US 1652
        }


      //Added for Bug-26686 total Obligation calculation - Raghu start
        var obligLst1 =  component.get("v.obligLst")
        var totalObligation = 0;
        console.log('obligLst1--'+JSON.stringify(obligLst1));        
        for(var i=0; i<obligLst1.length; i++){
            
            if(obligLst1[i].exObj.Status__c == 'Live' && obligLst1[i].exObj.Obligation__c == 'Yes'){
                
                if(obligLst1[i].exObj.EMI__c != null && obligLst1[i].exObj.EMI__c > 0){
                    
                    if(obligLst1[i].exObj.Loan_Type__c == 'Credit Card'){
                        if(obligLst1[i].exObj.POS__c  > 0)
                        totalObligation = totalObligation+parseFloat((obligLst1[i].exObj.POS__c * 5) / 100);
                    }
                    else{
                        totalObligation = totalObligation+parseFloat(obligLst1[i].exObj.EMI__c);
                        console.log('declared--'+totalObligation);
                    }
                    
                }
                else if(obligLst1[i].exObj.Derived_EMI__c != null && obligLst1[i].exObj.Derived_EMI__c > 0){
                    if(obligLst1[i].exObj.Loan_Type__c == 'Credit Card'){
                        if(obligLst1[i].exObj.POS__c  > 0)
                        totalObligation = totalObligation+parseFloat((obligLst1[i].exObj.POS__c * 5) / 100);
                    }
                    else{
                        totalObligation = totalObligation+parseFloat(obligLst1[i].exObj.Derived_EMI__c);
                        
                    }
                }
            }
        }
        console.log('totalObligations----'+totalObligation);
        component.set("v.totalObligations",Math.round(totalObligation)); 
        //Added for Bug-26686 total Obligation calculation - Raghu end
        console.log('Cibil score is'+component.get("v.applicant.CIBIL_Score__c")+component.get("v.loan.Loan_Application_Number__c"));
        /* CR 22307 s */
        var stage = component.get("v.stageName");
       if(component.get("v.isCredit") == true){
			if(stage == 'Underwriting' || component.get("v.loan.Consider_for_Re_Appraisal__c") == true || stage == 'Re-Appraise- Loan amount' || stage == 'Re-Appraise- IRR' || stage == 'Re-Appraise- Reject Case' || stage == 'Re-Appraise- Tenor')
			{
			component.set("v.displayReadOnly",false);
              //if(!component.get("v.account.Offer_Inhanced__c"))
               // helper.CheckPO(component,event); //1652 commented
			} 
			else{
				component.set("v.displayReadOnly",true);

			  
			}
			 
		}
       if(component.get("v.stageName") != 'DSA/PSF Login' && component.get("v.isCredit") == false) {
		 component.set("v.displayReadOnly",true);
		
	   }
       /* CR 22307 e */ 
	    // Bug 23064 start
       if(stage == 'Underwriting' && component.get("v.salesprofilecheck") == true)
            {
            component.set("v.displayReadOnly",true);
             
            } 
        // Bug 23064 stop
        if(component.get("v.account.Offer_Inhanced__c")==true || component.get("v.displayReadOnly") == true) /* CR 22307 */
        {
            component.find("enhanceOfferButton").set("v.disabled",true);
        }
          // user story 978 s
         if(component.get("v.stageName") == 'DSA/PSF Login' && component.get("v.isCredit") == false) {
		  var updateidentifier =  $A.get("e.c:Update_identifier");
        updateidentifier.setParams({
            "eventName": 'Offer',
            "oppId":component.get("v.loan").Id
        });
        //updateidentifier.fire();
	    }
          // user story 978 end 
        helper.showhidespinner(component,event,false);
    },
    closeModal : function(component,event){    
        var cmpTarget = component.find('overrideModalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        
    },
    callBREFinalOffer : function(component, event, helper) {
         console.log('in final offer bre'+component.get("v.camObj").Id+component.get("v.dsaUser"));
        if(component.get("v.account.Offer_Inhanced__c")==false && component.get("v.dsaUser")==false)
        {
            console.log('in final offer bre')
            helper.showhidespinner(component,event,true);
            helper.CheckPO(component,event);
        }
        else if(component.get("v.stageName") == 'DSA/PSF Login' && component.get("v.isCredit") == false) {
		  var updateidentifier =  $A.get("e.c:Update_identifier");
        updateidentifier.setParams({
            "eventName": 'Offer',
            "oppId":component.get("v.loan").Id
        });
        updateidentifier.fire();
	    }
          // user story 978 end 
        
        
        
    },
 fetchOfferOnButtonClick : function(component, event, helper) {//US 1652
        console.log('in fetchOfferOnButtonClick')
        helper.showhidespinner(component,event,true);
        helper.CheckPO(component,event);
    },
    updateCamObj : function(component, event, helper) {
        var list = ["tenor","FinalPF","Finalloanamount","FinalROI"];
        var isvalid =true;
        for (var i = 0; i < list.length; i++) {
          
            if (component.find(list[i]) && !component.find(list[i]).get("v.validity").valid)
            {
                isvalid = false;
                component.find(list[i]).showHelpMessageIfInvalid();
            }
        }
        if(isvalid)
            helper.updateCamObjHelper(component,event);
        else
            helper.displayToastMessage(component,event,'Error','Please fill all required data ','error');
        
    },
    updateCamObjOnly : function(component, event, helper) {
        var list = ["tenor","FinalPF","Finalloanamount","FinalROI"];
        var isvalid =true;
        for (var i = 0; i < list.length; i++) {
            if (component.find(list[i]) && !component.find(list[i]).get("v.validity").valid )
            {
                isvalid = false;
                component.find(list[i]).showHelpMessageIfInvalid();
            }
        }
        var camObj = component.get("v.camObj");
        var loan = component.get("v.loan");
        if(camObj.Proposed_Loan_Amt__c > loan.Offer_Amount__c)
            helper.displayToastMessage(component,event,'Error','Requested loan amount should be less than offer amount','error');
        else  if(isvalid)
            helper.saveCamObjectOnly(component,event);
            else
                helper.displayToastMessage(component,event,'Error','Please fill all required data ','error');
        
    },
    checkTopup : function(component, event, helper) {
        console.log('in controller');
        var typeofloan = component.get("v.loan.Type_Of_Loan__c");
        if(typeofloan == 'Top Up 1')
        {
            var myLabel = component.find("ExistingLANR");
            $A.util.removeClass(myLabel, 'slds-hide');
            var myLabel1 = component.find("ExistingLAN");
            $A.util.removeClass(myLabel1, 'slds-show');
            $A.util.addClass(myLabel1, 'slds-hide');
        }
        // helper.saveEligibility(component);
        
    },
    confirmEnhanceOffer: function(component, event, helper) {
        var cmpTarget = component.find('overrideModalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack,'slds-backdrop--open');
    },
    enhanceOffer: function(component, event, helper) {
        var cmpTarget = component.find('overrideModalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        
        console.log('in enhance offer'+component.get("v.account.Id"))
        var enhance = component.find("enhance");
        $A.util.removeClass(enhance, 'slds-hide');
        $A.util.addClass(enhance, 'slds-show');
        console.log('in controller');
        helper.enhanceOffer(component , event);
    },
     setParentAttributVar : function(component, event, helper){
        if (!$A.util.isEmpty(event.getParam("SecName"))) {    
              if(event.getParam("SecName") == "eligibility"){ 
                 component.set("v.camObj", event.getParam("camObj"));
              }
        } 
    },
     saveBankRecordcntrl : function(component, event, helper) {
            helper.showhidespinner(component,event,true);
            helper.saveBankRecordcntrl(component,event);
    },
    
})