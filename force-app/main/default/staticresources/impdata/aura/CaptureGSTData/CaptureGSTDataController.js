({
	doInit: function(component,event,helper){
        if(component.get("v.whoId") == 'none')
            component.set("v.applicantAbsentFlag", true);
        else
        	helper.getGstRecordDetails(component,component.get("v.whatId"), component.get("v.whoId"));
    },
    
    saveGSTData : function(component, event, helper) {
		helper.validateGSTData(component, event);
	},
    
    onCityChange : function(component, event, helper) {
        var selectedCity = component.find("city_Select").get("v.value");
        console.log('selectedCity ------->> '+selectedCity);
        if(selectedCity != '--Select--')
        {
            component.set("v.addressDetailsObj.City__c", selectedCity);
            var cityToStateMap = component.get("v.cityToStateMap");
            var stateName = cityToStateMap[selectedCity];
            component.set("v.addressDetailsObj.State__c", stateName);
        }
        else
        {
            component.set("v.addressDetailsObj.City__c", selectedCity);
            component.set("v.addressDetailsObj.State__c", '');
        }
	},
    
    exemptionApplicableChange : function(component, event, helper) {
        helper.exemptionApplicableChange(component, event);
	},
    
    considerForLoanChange : function(component, event, helper) {
        helper.considerForLoanChange(component, event);
	},
    
    enableDisableSubmitButton : function(component, event, helper){
        if(event.getSource().get("v.value") != undefined)
        {
            if(event.getSource().get("v.value").length == 15)
                component.find("submitButtonId").set("v.disabled",false);
            else
                component.find("submitButtonId").set("v.disabled",true);
        }
    },
    
    closeCustomToast : function(component, event, helper){
        var customToast = component.find("customToast");
        $A.util.addClass(customToast,"slds-hide");
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme,"slds-theme--error");
        $A.util.removeClass(toastTheme,"slds-theme--success");
    },
    
    closeOverrideModal : function(component,event,helper){
        event.preventDefault();
        helper.closeOverrideModal(component,event);
    },
    
    overrideSave : function(component,event,helper) {
        event.preventDefault();
        helper.closeOverrideModal(component,event);
        helper.overrideSave(component,event);
    },
    
    closeSelectYesModal : function(component,event,helper){
        event.preventDefault();
        helper.closeSelectYesModal(component,event);
    }
})