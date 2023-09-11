({
	doInit : function(component, event, helper) {
    	//helper.onLoadRecordCheck(component, event);
        $A.util.removeClass(component.find("sendToCreditId") ,'slds-checkbox--faux');
        helper.eKycCheck(component, event);
    },
    initiateKYCForm : function(component, event) {
        component.set("v.kyc", event.getParam("kyc"));
        component.set("v.isEkycdone", true);
        console.log("kyc details"+event.getParam("kyc"));
    },
    operationSelectCreditOfficer : function(component, event, helper) {
        var loanAppId = component.get('v.parentId'); 
        var isPerfiosMsg = true;
        var action = component.get('c.getSelectCreditOfficer');
        action.setParams({
            loanApplicationId : loanAppId 
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('result+Doc'+response.getReturnValue());
            if(state == 'SUCCESS')
            {
                component.set('v.showCredit',JSON.parse(response.getReturnValue()).isCheckListRecord);
                var docError = component.set('v.documentMessage',JSON.parse(response.getReturnValue()).status); 
            }
            else if(state == 'ERROR')
            {
                console.log('Error while creating Contact Record!!');
            }
        });
        console.log('Contact Record Saved Successfully!!'+isPerfiosMsg);
        if(isPerfiosMsg == true)
        {
            var sendToCreditVar = component.find("sendToCreditId").get("v.checked");
            //helper.eKycCheck(component, event);
            var isEkyc = component.get("v.kyc");
            var isDocument = component.get("v.documentMessage");
            console.log('flag++'+sendToCreditVar+'--'+isEkyc+'--'+isDocument);
            if (sendToCreditVar != null && sendToCreditVar == true && isDocument != 'Document Error')
            {
            	$A.enqueueAction(action);
            	helper.loadData(component, event);
                component.set('v.isBoxEnabled',true);
                console.log('RC+');
            }
        	else if(sendToCreditVar == false)
            {
            	component.set('v.showCredit',false);
                helper.displayMessage(component, 'displayInfoToast', 'displayInfoMsg', '<b>Info!</b>,Please check confirmation checkbox!');
            }
           /* Rohit 16111 CR added condition S  else if($A.util.isEmpty(isEkyc) && sendToCreditVar == true)
                helper.displayMessage(component, 'displayInfoToast', 'displayInfoMsg', '<b>Info!</b>,Please initiate Aadhaar!');
           else  if((component.get('v.isEkycMandatory') == true && component.get('v.isEkycdone') == false)){
               helper.displayMessage(component, 'displayInfoToast', 'displayInfoMsg', '<b>Info!</b>,Please initiate Ekyc!');
           }   // Rohit 16111 CR added condition E
           */
            else if(isDocument == 'Document Error')
                helper.displayMessage(component, 'displayInfoToast', 'displayInfoMsg', '<b>Info!</b>,All mandatory documents are not collected. You cannot proceed to CPA stage!');
        } 
        else
            console.log('Aman Porwal!!'+isPerfiosMsg);
	},
    sendToCreditOfficer : function(component, event, helper) {
    	helper.applicantRecord(component, event);
    },
    getChecklistDoc :  function(component, event, helper) {
        helper.showSpinner(component);
    	helper.getDocuments(component,event,helper);
	},
    savedocumentList :  function(component, event, helper) {
        console.log($A.util.isEmpty(component.get("v.standardChecklist")));
        if($A.util.isEmpty(component.get("v.standardChecklist")) && $A.util.isEmpty(component.get("v.deviationChecklist"))){
            helper.displayMessage(component, 'displayInfoToast', 'displayInfoMsg', 'No Documents to save!');
        }
        else{
             helper.showSpinner(component);
        	 helper.saveDocuments(component,event,helper);
        }
       
    },
     closeParentSuccessToast: function (component, event, helper) {
		helper.closeSuccessToastHelper(component);
	},
    closeParentErrorToast: function (component, event, helper) {
		helper.closeErrorToastHelper(component);
	},
    closeInfoToastToast: function (component, event, helper) {
		helper.closeInfoToastHelper(component);
	}
})