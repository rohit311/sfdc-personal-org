({
	doInit: function(component,event,helper){
        //Bug 15855 S - December_2017_CPV for PRO - Hemant Keni 
     
        
        var parentObj = component.get("v.parentObj");
    
        if(!component.get("v.loanApplicationId"))
            component.set("v.loanApplicationId",component.get("v.recordId"));
        
        var parentId = component.get("v.loanApplicationId");
        
     
         //setTimeout(function(){         //Bug 17287 
        	 helper.getApplicantPickListValues(component,parentId,parentObj);
       
       		 helper.getUserProfile(component,parentId,parentObj);
        //}, 4000);
        if(component.get("v.flowV2") == 'test') /* 17556 */
		component.set("v.showSubmitButtonFlag", helper.getsubmitflagValue(component,parentId,parentObj));	
      
        if( component.get("v.showSubmitButtonFlag") == false)
           component.find("saveButtonId").set("v.disabled",true);
            
        // Bug 15855 E 
    },
    
    onApplicantChange : function(component, event, helper) {
        var selectedApplicant = component.find("applicant_Select").get("v.value");
        component.set("v.selectedApplicant", selectedApplicant);
      
	},
    
    onVerificationChange : function(component, event, helper) {
        var selectedVerification = component.find("verificationType_Select").get("v.value");
        component.set("v.selectedVerification", selectedVerification);
       
	},
    
    salesStatusChange : function(component, event, helper) {
        var selectedStatus = component.find("salesStatus_Select").get("v.value");
        component.set("v.selectedStatus", selectedStatus);
       
	},
    
    saveData : function(component, event, helper){
     
        var btn = event.getSource();
		btn.set("v.disabled",true);
        //Bug 15855 S - December_2017_CPV for PRO - Hemant Keni 
        var pId = component.get("v.loanApplicationId");
        helper.saveDataHelper(component, component.get("v.selectedApplicant"), component.get("v.selectedVerification"), component.get("v.selectedStatus"), pId , component.get("v.parentObj"));
        // Bug 15855 E
    },

    closeCustomToast : function(component, event, helper){
        var customToast = component.find("customToast");
        $A.util.addClass(customToast,"slds-hide");
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme,"slds-theme--error");
        $A.util.removeClass(toastTheme,"slds-theme--success");
    },
    
    countFilesBrowsed : function(component, event, helper){
        helper.countFilesBrowsed(component, event);
    },
    
    enableSubmitButton : function(component, event, helper){
        helper.enableSubmitButton(component, event);
        
    },
    disableSubmitButton : function(component, event, helper){
        helper.disableSubmitButton(component, event);
    }
})