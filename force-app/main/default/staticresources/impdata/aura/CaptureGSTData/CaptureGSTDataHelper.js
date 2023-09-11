({
    PAN_NUMBER : '',
    STATE_TO_STATE_CODE_MAP : {},
    VALIDATION_ERROR_FLAG : false,
    OVERRIDE_FLAG : false,
    REQUIRED_DETAILS_MAP : {},
    
	getGstRecordDetails : function(component,whatId,whoId){
    	var action = component.get("c.getGstRecordDetails");
        action.setParams({
            "whatId": whatId,
            "whoId": whoId
        });
        action.setCallback(this, function(response){
        	var state = response.getState();
        	if (component.isValid() && state === "SUCCESS") {
                console.log('inside success...');
                var wrapperObj = response.getReturnValue();
                component.set("v.addressDetailsObj", wrapperObj.gstRecord);
                if(component.get("v.addressDetailsObj").City__c != undefined)
                	component.get("v.addressDetailsObj").City__c = component.get("v.addressDetailsObj").City__c.toUpperCase();
                component.set("v.cityToStateMap", wrapperObj.cityToStateMap);
                component.set("v.cityList", wrapperObj.cityNameSet);
                
                if(component.get("v.addressDetailsObj").Exemption_Applicable__c == undefined)
                    component.get("v.addressDetailsObj").Exemption_Applicable__c = 'No';
                if(component.get("v.addressDetailsObj").Consider_for_Loan__c == undefined)
                    component.get("v.addressDetailsObj").Consider_for_Loan__c = 'No';
                
                this.PAN_NUMBER = wrapperObj.panNumber;
                this.STATE_TO_STATE_CODE_MAP = wrapperObj.stateToStateCodeMap;
                
                this.REQUIRED_DETAILS_MAP = wrapperObj.requiredDetailsMap;
                if(this.REQUIRED_DETAILS_MAP['WHAT_ID_OBJECT_NAME'] == 'Opportunity')
                    component.get("v.addressDetailsObj").Loan_application__c = whatId;
                else if(this.REQUIRED_DETAILS_MAP['WHAT_ID_OBJECT_NAME'] == 'Product_Offerings__c')
                    component.get("v.addressDetailsObj").Product_offering__c = whatId;
                
                if(this.REQUIRED_DETAILS_MAP['WHO_ID_OBJECT_NAME'] == 'Applicant__c')
                    component.get("v.addressDetailsObj").Applicant__c = whoId;
                else if(this.REQUIRED_DETAILS_MAP['WHO_ID_OBJECT_NAME'] == 'Lead')
                    component.get("v.addressDetailsObj").Lead__c = whoId;
                else if(this.REQUIRED_DETAILS_MAP['WHO_ID_OBJECT_NAME'] == 'Lead_Applicants__c')
                    component.get("v.addressDetailsObj").Lead_Applicant__c = whoId;
                
                component.get("v.addressDetailsObj").Skip_Validation_Rules__c = true;
                component.set("v.addressDetailsObjList", wrapperObj.otherGstRecordList);
                
                var gstNumber = component.get("v.addressDetailsObj.GST_IN_Number__c");
                if(gstNumber != null && gstNumber.length == 15)
                    component.find("submitButtonId").set("v.disabled",false);   
        	}
    	});
        $A.enqueueAction(action);
    },
    
    validateGSTData : function(component, event){
        var gstNumber = component.get("v.addressDetailsObj.GST_IN_Number__c");
        
        this.VALIDATION_ERROR_FLAG = false;
        if(component.get("v.addressDetailsObj.City__c") == '--Select--' || component.get("v.addressDetailsObj.City__c") == '' || component.get("v.addressDetailsObj.City__c") == null)
            this.showToast(component,'Error!', 'Kindly select a city.', 'error', true);
        else if(gstNumber.substring(0, 2) != this.STATE_TO_STATE_CODE_MAP[component.get("v.addressDetailsObj.State__c").toUpperCase()])
            this.showToast(component,'Error!', 'GST Number does not contain state code in it.', 'error', true);
        else if(this.PAN_NUMBER == '' || this.PAN_NUMBER == null)
            this.showToast(component,'Error!', 'Applicant does not have PAN number. Can not save GST record for this applicant.', 'error', true );
        else if(gstNumber.substring(2, 12).toUpperCase() != this.PAN_NUMBER.toUpperCase())
            this.showToast(component,'Error!', 'GST Number does not contain PAN Number of applicant.', 'error', true );
        else if(component.get("v.addressDetailsObj.Address_Line_1__c") == null || component.get("v.addressDetailsObj.Address_Line_1__c") == '')
            this.showToast(component,'Error!', 'Address Line 1 field can not be left blank.', 'error', true);
        else if(component.get("v.addressDetailsObj.Pin_Code__c") == null || component.get("v.addressDetailsObj.Pin_Code__c") == '')
            this.showToast(component,'Error!', 'Pincode field can not be left blank.', 'error', true);
        else if(isNaN(component.get("v.addressDetailsObj.Pin_Code__c")))
            this.showToast(component,'Error!', 'Pincode can not contain alphabets.', 'error', true);
        else if(component.get("v.addressDetailsObj.Pin_Code__c").toString().length != 6)
            this.showToast(component,'Error!', 'Pincode should be of 6 digits.', 'error', true);
        
        if(!this.VALIDATION_ERROR_FLAG)
        	this.callSaveGSTData(component, event);
    },

    callSaveGSTData : function(component, event)
    {
        var saveRecordsList = [];
        if(!this.VALIDATION_ERROR_FLAG)
        {
            var considerForLoan = component.get("v.addressDetailsObj.Consider_for_Loan__c");
            console.log('---considerForLoan-->> '+considerForLoan);
            if(component.get("v.addressDetailsObjList").length == 0)
            {
                if(considerForLoan == 'Yes')
                {
                    // CALL SAVE FUNCTION
                    console.log('component.get("v.addressDetailsObjList").length == 0 AND considerForLoan == Yes');
                    saveRecordsList.push(component.get("v.addressDetailsObj"));
                    this.saveGstData(component, event, saveRecordsList);
                    
                }else if(considerForLoan == 'No')
                {
                    // SHOW POP UP AND ASK USER TO SELECT YES IN CONSIDER FOR LOAN FIELD
                    this.openSelectYesModal(component,event);
                    console.log('component.get("v.addressDetailsObjList").length == 0 AND considerForLoan == No');
                }
            }else if(component.get("v.addressDetailsObjList").length > 0)
            {
                var existingConsiderForLoanFlag = false;
                for(var key in component.get("v.addressDetailsObjList"))
                {
                    if(component.get("v.addressDetailsObjList")[key].Consider_for_Loan__c == 'Yes')
                    {
                        existingConsiderForLoanFlag = true;
                        break;
                    }
                }
                
                if(considerForLoan == 'Yes')
                {
                    if(existingConsiderForLoanFlag)
                    {
                        // SHOW POPUP TO ASK IF USER WANT TO OVERRIDE.
                        if(this.OVERRIDE_FLAG)
                        {
                            //call save function
                            console.log('inside overide flag true...');
                            for(var key in component.get("v.addressDetailsObjList"))
                            {
                                component.get("v.addressDetailsObjList")[key].Consider_for_Loan__c = 'No';
                            }
                          	var allRecords = component.get("v.addressDetailsObjList");
                            allRecords.push(component.get("v.addressDetailsObj"));
                            component.set("v.addressDetailsObjList",allRecords);
                            console.log(component.get("v.addressDetailsObjList"));
                            this.OVERRIDE_FLAG = false;
                            this.saveGstData(component, event, component.get("v.addressDetailsObjList"));
                        }
                        else
                            //show override modal flag
                            this.openOverrideModal(component,event);
                    }else
                    {
                        // call save function..
                        saveRecordsList.push(component.get("v.addressDetailsObj"));
                        this.saveGstData(component, event, saveRecordsList);
                    }
                    	
                }else if(considerForLoan == 'No')
                {
                    if(existingConsiderForLoanFlag)
                    {
                        // call save function..
                        saveRecordsList.push(component.get("v.addressDetailsObj"));
                        this.saveGstData(component, event, saveRecordsList);
                        
                    }else
                    {
                        // SHOW POPUP TO ASK USER SELECT YES IN CONSIDER FOR LOAN FIELD
                        this.openSelectYesModal(component,event);
                    }
                }
                
            }
        }
    },
    
    saveGstData : function(component, event, gstRecordsList1)
    {
        var action = component.get("c.saveGstDataCntrl");
        action.setParams({
            "gstRecordsStr": JSON.stringify(gstRecordsList1)
        });
        action.setCallback(this, function(response){
        	var state = response.getState();
        	if (component.isValid() && state === "SUCCESS") {
                var saveResponse = response.getReturnValue();
                console.log('saveResponse ----->> '+saveResponse);
             	if(saveResponse.indexOf("error") == -1)
                {
                    this.showToast(component,'Success!', saveResponse,'success', false);
                    this.getGstRecordDetails(component,component.get("v.whatId"), component.get("v.whoId"));
                }
                else
                    this.showToast(component,'Error!', saveResponse, 'error', false);
        	}
    	});
        $A.enqueueAction(action);
    },
    
    overrideSave: function(component,event) {
        this.OVERRIDE_FLAG = true;
        this.callSaveGSTData(component, event);
    },
    
    exemptionApplicableChange : function(component, event) {
        var exemptionApplicable = component.find("exemptionApplicable_Select").get("v.value");
        console.log('exemptionApplicable ---2222---->> '+exemptionApplicable);
        component.set("v.addressDetailsObj.Exemption_Applicable__c", exemptionApplicable);
        console.log('v.addressDetailsObj.Exemption_Applicable__c -->> '+JSON.stringify(component.get("v.addressDetailsObj.Exemption_Applicable__c")));
	},
    
    considerForLoanChange : function(component, event) {
        var considerForLoan = component.find("considerForLoan_Select").get("v.value");
        console.log('considerForLoan ---2222---->> '+considerForLoan);
        component.set("v.addressDetailsObj.Consider_for_Loan__c", considerForLoan);
        console.log('v.addressDetailsObj.Consider_for_Loan__c -->> '+JSON.stringify(component.get("v.addressDetailsObj.Consider_for_Loan__c")));
	},
    
    showToast : function(component, title, message, type, validationErrorFlag){
        var toastEvent = $A.get("e.force:showToast");
        this.VALIDATION_ERROR_FLAG = validationErrorFlag;
        if(toastEvent){
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "5000"
            });    
            toastEvent.fire();
        }
        else{
            var customToast = component.find('customToast');
            $A.util.removeClass(customToast, 'slds-hide');
            var toastTheme = component.find("toastTheme");
            $A.util.removeClass(toastTheme,"slds-theme--error");
            $A.util.removeClass(toastTheme,"slds-theme--success");
            if(type == 'error'){
                $A.util.addClass(toastTheme,"slds-theme--error");
            }
            else if(type == 'success'){
                $A.util.addClass(toastTheme,"slds-theme--success");
            }
            component.find("toastText").set("v.value", message);
            component.find("toastTtitle").set("v.value", title+' ');
        }
    },
    
    closeOverrideModal : function(component,event){    
        var cmpTarget = component.find('overrideModalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    
    openOverrideModal : function(component,event) {
        var cmpTarget = component.find('overrideModalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
    },
    
    closeSelectYesModal : function(component,event){    
        var cmpTarget = component.find('selectYesModalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    
    openSelectYesModal : function(component,event) {
        var cmpTarget = component.find('selectYesModalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
    }
})