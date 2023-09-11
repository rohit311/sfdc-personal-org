({
    doInit : function(component, event, helper) {
        
        var staticLabel = $A.get("$Label.c.Customer_Insight_Email_Button");
		component.set("v.customEmailLabel", staticLabel.toUpperCase());
        console.log('tetsing'+component.get('v.applicantObj.Id'));
        var loanId = component.get('v.oppId');
        console.log('loanId+Perfios+'+loanId);
        helper.fetchBankAccountPickListVal(component, 'Bank_Name_List__c', 'bankAccountId');
        var action = component.get('c.getPerfiosFromBankAccount');
        console.log('action++'+action);
        action.setParams({
            fetchLAId : loanId 
        });
        
        action.setCallback(this,function(response){	
            var state = response.getState();
            if(state == 'SUCCESS')
            {
                console.log('JSON++'+JSON.stringify(response.getReturnValue()));
                component.set('v.bankAccount',response.getReturnValue());
                component.set('v.isSendFlagChecked',response.getReturnValue().Send_Email_For_Perfios__c);
            }
            else if(state == 'ERROR')
                console.log('Error while creating Contact Record!!');
        });
        
        var appPerfiosEvent = $A.get("e.c:Sal_Opp_Perfios");
            appPerfiosEvent.setParams({
                bankAccountPerfios : component.get('v.bankAccount.Perfios_Flag__c')
            });
            appPerfiosEvent.fire();
            console.log('Perfios Check++'+component.get('v.bankAccount.Perfios_Flag__c'));
        $A.enqueueAction(action);
        
    },
    operationOnPerfios : function(component, event, helper) {
        var bankobj = component.get('v.bankAccount');
        var loanId = component.get('v.oppId');
        console.log('loanId+Perfios+'+loanId);
        //bankobj.Send_Email_For_Perfios__c = component.get('v.isSendFlagChecked');
        bankobj.Applicant__c = component.get('v.applicantObj.Id');
        bankobj.Loan_Application__c = component.get('v.oppId');
       // console.log('mailsent'+component.set('v.bankAccount.Send_Email_For_Perfios__c'));
        bankobj.Send_Email_For_Perfios__c = component.get('v.isSendFlagChecked');
        //component.set('v.bankAccount.Applicant__r',component.get('v.applicantObj'));
        //component.set('v.bankAccount.Applicant__r.Applicant_Type__c',component.get('v.applicantObj.Applicant_Type__c'));
        var isPerfiosMsg = true;
        var bankAccountVar = component.find("bankAccountId");
        if(bankAccountVar.get("v.validity").valid)
            console.log('bankAccountId'+isPerfiosMsg);
        else{
            bankAccountVar.showHelpMessageIfInvalid();
            isPerfiosMsg = false;
        }
        
        var accountNumberId = component.find("accountNumberId");
        if(accountNumberId.get("v.validity").valid)
            console.log('accountNumberId'+isPerfiosMsg);
        else{
            accountNumberId.showHelpMessageIfInvalid();
            isPerfiosMsg = false;
        }
        console.log('Hello Prashant');
        var action = component.get('c.getSaveBankAccountForPerfios');
        action.setParams({
            jsonBankAccount : JSON.stringify([bankobj]),
            loanApplicationId : component.get('v.oppId')
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
           // console.log('result+'+response.getReturnValue()+' '+response.getReturnValue().Send_Email_For_Perfios__c);
            
            if(state == 'SUCCESS' && !$A.util.isEmpty(response.getReturnValue()))
            {   console.log(response.getReturnValue());
                component.set('v.bankAccount',response.getReturnValue());
              	component.set("v.disablepage",false);
                component.set('v.isSendFlagChecked',response.getReturnValue().Send_Email_For_Perfios__c);
                helper.displayMessage(component, 'perfiosSuccess', 'perfiosSuccessMsg', 'Success! Perfios record has been updated successfully.');
            }
            else if(state == 'ERROR')
            {
                console.log('Error while creating Contact Record!!');
                component.set("v.disablepage",false);
                helper.displayMessage(component, 'perfiosError', 'perfiosErrorMsg', 'Error !');
            }
        });
        console.log('Contact Record Saved Successfully!!'+isPerfiosMsg);
        if(isPerfiosMsg == true)
        {  
            //helper.showSpinner(component);
            component.set("v.disablepage",true);
            console.log('Contact Record Saved Successfully!!'+component.get('v.isSendFlagChecked'));
            var appPerfiosEvent = $A.get("e.c:Sal_Opp_Perfios");
            appPerfiosEvent.setParams({
                bankAccountPerfios : component.get('v.bankAccount.Perfios_Flag__c')
            });
            appPerfiosEvent.fire();
            console.log('Perfios Check++'+component.get('v.bankAccount.Perfios_Flag__c'));
            $A.enqueueAction(action);
        } 
        else
            helper.displayMessage(component, 'perfiosError', 'perfiosErrorMsg', 'Error! Please fill all required fields.');
    },
    uploadPerfios : function(component, event, helper) {
        helper.uploadPerfiosButton(component);
    },
    closeToastnew: function (component, event, helper) {
		helper.closeToastnew(component, event.target.id);
	},
	closeToastError: function (component, event, helper) {
		helper.closeToastError(component, event.target.id);
	},
    closeToastInfo: function (component, event, helper) {
		helper.closeToastInfo(component, event.target.id);
	},
    showSpinner: function (component) {
        helper.showSpinner(component);
    },
    hideSpinner: function (component) {
        helper.hideSpinner(component);
    },
    redirectToPerfiosRecord : function (component, event, helper) {
    	helper.redirectToPerfiosRecord(component,event);
    },  
})