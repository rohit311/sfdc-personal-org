({
	validateCommercialTab : function(component,id) {
		var opp = component.get("v.OppObj");
		var account = component.get("v.account");
       
		var isEmpty, isValid = true;
        var result = false;
		var lst = [
			{value: opp.Processing_Fees__c, auraId: "approvedPf", message: "Please Enter Approved PF"},
			{value: opp.Approved_Rate__c, auraId: "approvedRoi", message: "Please Enter Approved Rate"},
			{value: account.Approved_Insurance__c, auraId: "approvedInsurance", message: "Please Enter Approved Insurance"},
		];
			
		for(var i = 0; i < lst.length; i++){ 
			isEmpty = this.isEmpty(lst[i].value);
			isValid = isValid && !isEmpty;
			console.log(isEmpty);
			this.addRemoveInputError(component, lst[i].auraId, isEmpty && lst[i].message);
		}
	
		debugger;
		var flatRoi = parseFloat(component.get("v.productOffering.Revised_Offer_ROI__c"));
		var flatInsurance = parseFloat(component.get("v.productOffering.Shares_value__c"));
		var flatPf = parseFloat(component.get("v.productOffering.Bonds_Value__c"));
		//14213 Need to test the same S
		console.log(isValid);
       // US : 23080 start commented below
      /*  if(component.get("v.stpNonStp") == 'STP'  && isValid){
    	result =  parseFloat(opp.Approved_Rate__c) < flatRoi;
		this.addRemoveInputError(component, "approvedRoi", result && "Approved ROI can not be lower than Base Rate");
		isValid = isValid && !result;
            
    	result = parseFloat(account.Approved_Insurance__c) < flatInsurance;
		this.addRemoveInputError(component, "approvedInsurance", result && "Approved Insurance can not be lower than Base Rate");
		isValid = isValid && !result;
    
    	result = parseFloat(opp.Processing_Fees__c) < flatPf;
		this.addRemoveInputError(component, "approvedPf", result && "Approved PF can not be lower than Base Rate");
		isValid = isValid && !result;
    	}   
    
     else */  // US : 23080 end
     if(isValid){
    	result = parseFloat(account.Approved_Insurance__c) < 0 ;
		this.addRemoveInputError(component, "approvedInsurance", result && "Approved Insurance should be greater than or equal to zero");
		isValid = isValid && !result;
    
    	result = parseFloat(opp.Processing_Fees__c) <= 0;
		this.addRemoveInputError(component, "approvedPf", result && "Approved PF should be greater than zero");
		isValid = isValid && !result;
        
            result = parseFloat(opp.Approved_Rate__c) <= 0;
            this.addRemoveInputError(component, "approvedRoi", result && "Approved ROI should be greater than zero");
            isValid = isValid && !result;
     }
	//14213 E
		console.log(isValid);
		return isValid;
       
    	// return this.validateFieldValues(component, isValid); // US : 23080
	},
 
	validateFieldValues : function(component, isValidPassed)
	{
        var opp = component.get("v.OppObj");
		var account = component.get("v.account");
       
		var isValid = isValidPassed;
        var result = false;
        
        var flatRoi;
        if(component.get("v.productOffering.Revised_Offer_ROI__c"))
        	flatRoi = parseFloat(component.get("v.productOffering.Revised_Offer_ROI__c"));
        else
            flatRoi = 0; 
        
        var flatInsurance
        if(component.get("v.productOffering.Shares_value__c"))
            flatInsurance = parseFloat(component.get("v.productOffering.Shares_value__c"));
        else
            flatInsurance = 0;
        
        var flatPf;
        if(component.get("v.productOffering.Bonds_Value__c"))
           flatPf = parseFloat(component.get("v.productOffering.Bonds_Value__c"));
		else
		  flatPf = 0;
		
        if(!this.isEmpty(opp.Approved_Rate__c))
        {
            result =  parseFloat(opp.Approved_Rate__c) < flatRoi;
            this.addRemoveInputError(component, "approvedRoi", result && "Approved ROI can not be lower than Base Rate");
            isValid = isValid && !result;
        }
        
        if(!this.isEmpty(account.Approved_Insurance__c))
        {
            result = parseFloat(account.Approved_Insurance__c) < flatInsurance;
            this.addRemoveInputError(component, "approvedInsurance", result && "Approved Insurance can not be lower than Base Rate");
            isValid = isValid && !result;
        }
    	
        if(!this.isEmpty(opp.Processing_Fees__c))
        {
            result = parseFloat(opp.Processing_Fees__c) < flatPf;
            this.addRemoveInputError(component, "approvedPf", result && "Approved PF can not be lower than Base Rate");
            isValid = isValid && !result;
        }
		console.log(isValid);
		return isValid;
    },
 
	isEmpty: function(value){
		return ($A.util.isEmpty(value) || $A.util.isUndefined(value) || value === 0 || isNaN(value)); // US : 23080
	},
	sendCommercialEmailtoUser : function(component, key, message){
		var body = '<p>Dear User,</p>';
			body += '<p>Below are the Commercial Details for Loan Application : '+component.get("v.OppObj.Loan_Application_Number__c")+'</p>';
			body += '<p>Approved PF : '+component.get("v.OppObj.Processing_Fees__c")+'</p>';
			body += '<p>Approved ROI :'+component.get("v.OppObj.Approved_Rate__c")+'</p>';
			body += '<p>Approved Insurance : '+component.get("v.account.Approved_Insurance__c")+'</p>';
			body += '<p>Regards,</p>';
			body += '<p>Bajaj Finserv</p>';
		var subject = 'Commercial Details for Loan Application : '+ component.get("v.OppObj.Loan_Application_Number__c");
		this.executeApex(component, "sendCommercialEmail", {"emailId":$A.get("$SObjectType.CurrentUser.Email"),"subject":subject,"body":body}, function(error, result){
			if(!error && result){
				this.setSelectOptions(component, result, "Account Type", "accountType");
			}
		});
	},
	addRemoveInputError: function(component, key, message){
		component.find(key).set("v.errors", [{message: message ? (message) : ""}]);
	},
	ShowToast : function(component, title, message, type){
		var ShowToastEvent = $A.get("e.c:ShowToastEvent");
		ShowToastEvent.setParams({
			"title": title,
			"message":message,
			"type":type,
		});
		ShowToastEvent.fire();
	},
	showHideDiv: function(component, divId, show){
		$A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
		$A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
	},
	SaveCommercial : function(component, event, helper) {
		var oppSaved = false;
        component.get("v.account").Is_Commercial_Data_Saved__c = true;
		/*component.find("OppRecordLoader").saveRecord($A.getCallback(function(saveResult) {
			
			if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
				oppSaved = true;
				
			} else if (saveResult.state === "INCOMPLETE") {
				console.log("User is offline, device doesn't support drafts.");
			} else if (saveResult.state === "ERROR") {
				console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
			} else {
				console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
			}
		}));*/
        debugger;
        console.log('component.get("v.applicant")');
        console.log(component.get("v.applicant"));
        console.log( JSON.stringify(component.get("v.applicant")));
          helper.executeApex(component, "saveCommercialDetails", {loan : component.get("v.OppObj"), applicantPrimary : component.get("v.applicant"), account : component.get("v.account")}, function(error, result){
            console.log(result);
            result = JSON.parse(result);
            if(result.status == 'Success'){
            	helper.ShowToast(component, "Success", "Commercial Details Saved Successfully..", "success");
              	helper.FetchOpportunity(component);
            }else{
                helper.ShowToast(component, "Error!", result.message, "error");
            }
         });
		/*component.find("AccRecordLoader").saveRecord($A.getCallback(function(saveResult) {
			if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {

					
			} else if (saveResult.state === "INCOMPLETE") {
				console.log("User is offline, device doesn't support drafts.");
			} else if (saveResult.state === "ERROR") {
				console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
			} else {
				console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
			}
		})); */
		this.sendCommercialEmailtoUser(component);
       
	},
   FetchOpportunity : function(component){
        this.executeApex(component, "queryData", {"oppId" : component.get("v.recordId")}, function(error, result) {
            console.log(result);
            if(!error && result) {
              component.set("v.OppObj",result[0]);
              component.set("v.childAccount",result[0].Account);
                var POSNavigateToTab = $A.get("e.c:POSNavigateToTab");
                        POSNavigateToTab.setParams({
                        	"TabId": "Insurance",
                        });
                        POSNavigateToTab.fire();
            }
        });
   	},
	executeApex: function(component, method, params, callback){
		var action = component.get("c."+method); 
		action.setParams(params);
		component.set("v.spinnerFlag","true");
		action.setCallback(this, function(response) {
			component.set("v.spinnerFlag","false");
			var state = response.getState();
			if(state === "SUCCESS"){
				callback.call(this, null, response.getReturnValue());
			} else if(state === "ERROR") {
				var errors = ["Some error occured. Please try again. "];
				var array = response.getError();
				for(var i = 0; i < array.length; i++){
					var item = array[i];
					if(item && item.message){
						errors.push(item.message);
					}
				}
				this.ShowToast(component, "Error!", errors.join(", "), "error");
				callback.call(this, errors, response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	},
        disableForm: function(component,event){
        //    var TabList = event.getParam("TabList");
        //    if(TabList.indexOf("Commercial") != -1){
                var list = [
                    "approvedPf","approvedRoi","approvedInsurance", "vas"
                ];
                for(var i = 0; i < list.length; i++){
                    if(component.find(list[i]))
                        component.find(list[i]).set("v.disabled", true);
                }
                component.find("submitcommercialId").set("v.disabled", true);
         //   }
        }
})