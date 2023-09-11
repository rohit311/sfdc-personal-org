({
    
    
      validatechargeAmount: function(component){
      console.log('ss'+component.get("v.feesNChargesList"));
      
          
    	for(var counter = 0; counter < component.get("v.feesNChargesList").length; counter++)
        {
            var record = component.get("v.feesNChargesList")[counter];
          
            console.log(record.Change_Amount__c < 0);
            console.log(record.Change_Amount__c);
            console.log(record.Change_Amount__c);
           //if(record.Change_Amount__c === undefined || record.Change_Amount__c === null || record.Change_Amount__c === ""  || record.Change_Amount__c < 0 || !/^(0|[1-9][0-9]*)$/.test(record.Change_Amount__c)) 
           if(record.Change_Amount__c === undefined || record.Change_Amount__c === null || record.Change_Amount__c === ""  || record.Change_Amount__c < 0 || !/^\d+(\.\d{1,2})?$/.test(record.Change_Amount__c))
            {
               
               this.showToast("Error", "Please Enter Valid Charge amount.", "error");
               return false;
           }

            
        }
      return true;
      },
    
    
    
    getFeesNChargesRecords : function(component, event) {
        
        console.log('==feesNChargesList==>> '+JSON.stringify(component.get("v.feesNChargesList")));
      /*  
		var action = component.get("c.queryFeesNCharges");
        action.setParams({
            "loanObject": component.get("v.oppoObject")
        });
        action.setCallback(this, function(response){
        	var state = response.getState();
            console.log('==111== '+response.getReturnValue());
        	if (component.isValid() && state === "SUCCESS") {
                component.set("v.feesNChargesList", response.getReturnValue());
        	}
    	});
        $A.enqueueAction(action);
      */
	},
    
    callFetchCharges : function(component, event) {
        
        if(component.get("v.DueDate")){
      		component.set("v.oppoObject.Due_Day__c",component.get("v.DueDate"));
            //component.set("v.oppoObject.First_Due_Date__c",component.get("v.DueDate"));
            
            	//First_Due_Date__c
            if(component.get("v.rmdObj.Id"))
           		component.set("v.rmdObj.ECS_Start_Date__c",component.get("v.DueDate"))
        	
        }
        
        console.log(component.get("v.DueDate"));
		var action = component.get("c.fetchChargesCtrl");
        action.setParams({
            "loanObject": component.get("v.oppoObject"),
            "rmdObj" : component.get("v.rmdObj")
        });
        component.set("v.spinnerFlag","true");
        action.setCallback(this, function(response){
        	var state = response.getState();
            console.log('====response '+response.getReturnValue());
        	if (component.isValid() && state === "SUCCESS") {
                if(response.getReturnValue() != null)
                {
                    this.showToast("Success", "Fetch Charges done Successfully", "success");
                    component.set("v.feesNChargesList", response.getReturnValue());
                    //console.log('====>> '+component.get("v.feesNChargesList").length);
                    if(component.get("v.feesNChargesList").length > 0)
                    {
                        this.setDefaultValues(component);
                        this.fireDisburseAmountEvent(component);
                        component.find("saveId").set("v.disabled","false");
                    }
            	}else
                    this.showToast("Error", "Some Error occured in Fetch Charges!", "error");
        	}
            component.set("v.spinnerFlag","false");
    	});
        $A.enqueueAction(action);
	},
	disableFeesAndChargesForm : function(component) {
        // disable button
        if (component.find("fetchChargesId") != undefined) component.find("fetchChargesId").set("v.disabled", true);
        if (component.find("saveId") != undefined) component.find("saveId").set("v.disabled", true);
        
        
    },
    
    setDefaultValues : function(component)
    {
        for(var counter = 0; counter < component.get("v.feesNChargesList").length; counter++)
        {
            var chargeAmount = component.get("v.feesNChargesList")[counter].Change_Amount__c;
            if(chargeAmount != null && chargeAmount > 0)
            {
                component.get("v.feesNChargesList")[counter].Status__c = 'To be collected';
                component.get("v.feesNChargesList")[counter].Deducted_from_Disbursement__c = 'Yes';
                component.get("v.feesNChargesList")[counter].Instrument_type__c = 'Deduct from Disb';
                component.get("v.feesNChargesList")[counter].Change_Amount__c = Math.round(component.get("v.feesNChargesList")[counter].Change_Amount__c);
            }
        }
    },
    
    fireDisburseAmountEvent : function(component)
    {
        var compEvents = $A.get("e.c:CalculateDisburseAmountEvent");
        console.log('CalculateDisburseAmountEvent ===>> '+compEvents);
        compEvents.fire();
    },
    
    saveChargesHelper : function(component, event) {
        this.setDefaultValues(component);
		var action = component.get("c.saveChargesRecords");
        console.log('component.get("v.feesNChargesList")'+ JSON.stringify(component.get("v.feesNChargesList")));
        action.setParams({
            "feesChargesRecordsJSON": JSON.stringify(component.get("v.feesNChargesList"))
        });
        component.set("v.spinnerFlag","true");
        action.setCallback(this, function(response){
        	var state = response.getState();
            console.log('==== '+response.getReturnValue());
        	if (component.isValid() && state === "SUCCESS") {
                if(response.getReturnValue() != null)
                {
                    var titleName = 'Success';
                    var errorType = 'success';
                    if(response.getReturnValue().includes("error"))
                    {    
                        titleName = 'Error';
                     	errorType = 'error';
                    }
                        
                    var ShowToastEvent = $A.get("e.c:ShowToastEvent");
                    ShowToastEvent.setParams({
                        "title": titleName,
                        "message": response.getReturnValue(),
                        "type": errorType,
                    });
                    ShowToastEvent.fire();
                    var feesList = component.get("v.feesNChargesList");
                    component.set("v.feesNChargesList", feesList);
                    this.fireDisburseAmountEvent(component);
            	}
        	}
            component.set("v.spinnerFlag","false");
    	});
        $A.enqueueAction(action);
	},
    
    showToast : function(title, message, type) {
        var ShowToastEvent = $A.get("e.c:ShowToastEvent");
        ShowToastEvent.setParams({
            "title": title,
            "message":message,
            "type":type,
        });
        ShowToastEvent.fire();
    },
    validateForm : function(component, event)
    {
        var isEmpty, isValid = true;
        var lst = [
            {value: component.get("v.DueDate"), auraId: "firstDueDate", message: "Enter First Due Date"}];
        
        for(var i = 0; i < lst.length; i++){ 
            isEmpty = this.isEmpty(lst[i].value);           
            isValid = isValid && !isEmpty;
            this.addRemoveInputError(component, lst[i].auraId, isEmpty && "Please "+lst[i].message);
        }
        return isValid;
       
    },
    validateCharge : function(component, event)
    {
        console.log('values are'+component.find("StampAmount").get("v.value"));
            component.find("StampAmount").set("v.value",component.find("StampAmount").get("v.value").replace(/[a-zA-z]/g, ''));  
        if(component.find("StampAmount").get("v.value") == null || component.find("StampAmount").get("v.value") == '' || component.find("StampAmount").get("v.value") == undefined)
            this.showToast("Error", "Kindly enter charge amount.", "error");
        else if(component.find("StampAmount").get("v.value") < 0)
            this.showToast("Error", "Charge amount can not be negative.", "error");
       
    },
    isEmpty: function(value){
    	return ($A.util.isEmpty(value) || $A.util.isUndefined(value) || value === 0);
	},
    addRemoveInputError: function(component, key, message){
        component.find(key).set("v.errors", [{message: message ? (message) : ""}]);
    }
})