({
    doInit: function(component, event, helper) {
    },
    saveDisbursment : function(component, event, helper) {
       var emidate = component.get('v.EMI1stDate');
       var emi = component.get('v.EMI')
       var loanapp = component.get("v.loanApplication");
       var favouring = component.get("v.disbusment.Favouring__c");
       loanapp.First_Due_Date__c = emidate;
       loanapp.Favouring__c = favouring;
       loanapp.EMI_CAM__c = emi;
       component.set("v.loanApplication",loanapp);
        var isInValidMsg = true;
        var bpi = component.find("bpiId");
        if(bpi.get("v.validity").valid)
            console.log('bpi'+isInValidMsg);
        else{
            bpi.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        var emi = component.find("emiId");
        if(emi.get("v.validity").valid)
            console.log('emi'+isInValidMsg);
        else{
            emi.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        var favouring = component.find("favouringId");
        if(favouring.get("v.validity").valid)
            console.log('favouring'+isInValidMsg);
        else{
            favouring.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var loanType = component.find("loanTypeId");
        if(loanType.get("v.validity").valid)
            console.log('loanType'+isInValidMsg);
        else{
            loanType.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var bankAccount = component.find("bankAccountId");
        if(bankAccount.get("v.validity").valid)
            console.log('bankAccount'+isInValidMsg);
        else{
            bankAccount.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var IFSC = component.find("IFSCId");
        if(IFSC.get("v.validity").valid)
            console.log('conMonthAtResidence'+isInValidMsg);
        else{
            IFSC.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var bankNumber = component.find("bankNumberId");
        if(bankNumber.get("v.validity").valid)
            console.log('conPermanentAddress'+isInValidMsg);
        else{
            bankNumber.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var disAmount = component.find("disAmountId");
        if(disAmount.get("v.validity").valid)
            console.log('conPermanentPinCode'+isInValidMsg);
        else{
            disAmount.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var action = component.get("c.savePricingDisbusment");
        action.setParams({
            "jsonOppRecord": JSON.stringify([component.get("v.loanApplication")]),
            "jsonDisRecord": JSON.stringify([component.get("v.disbusment")]),
            "loanApplicationId": component.get("v.pricingId")
        });
        action.setCallback(this, function(response) {
           //alert("Action there!"+response.getReturnValue());
            if (response.getState() == "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.showspinnerflag",false);
                if(response.getReturnValue() != null)
                {
                	component.set("v.disbusment",response.getReturnValue());
                    helper.displayMessage(component, 'SuccessToastdis', 'successmsgdis', 'Success! Saved Successfully');
                }
                else
                	helper.displayMessage(component, 'ErrorToastdis', 'errormsgdis', 'Fail! Failed To Save Data');
            }
            else if(state == 'ERROR'){
                console.log('Hello Pricing Error');
                component.set("v.showspinnerflag",false);
                helper.displayMessage(component, 'ErrorToastdis', 'errormsgdis', 'Fail! Failed To Save Data');
            }
        });
        component.set("v.showspinnerflag",false);
        if(isInValidMsg == true)
        {
            component.set("v.showspinnerflag",true);
            var appEvent = $A.get("e.c:Sal_Pricing_Event");
            appEvent.setParams({
                "EMI1stDate" : component.get('v.EMI1stDate'),
                "EMILastDate" : component.get('v.EMILastDate'),
                "BPI" : component.get('v.BPI'),
                "EMI" : component.get('v.EMI')
            });
            appEvent.fire();
            $A.enqueueAction(action);
            console.log('If - Saved : '+ isInValidMsg);            
        } 
        else
          helper.displayMessage(component, 'ErrorToastdis', 'errormsgdis', 'Fail! Please fill all required fields.');        
    },
   closeToastnew: function (component, event, helper) {
		helper.closeToastnew(component, event.target.id);
	},
	closeToastError: function (component, event, helper) {
		helper.closeToastError(component, event.target.id);
	},
})