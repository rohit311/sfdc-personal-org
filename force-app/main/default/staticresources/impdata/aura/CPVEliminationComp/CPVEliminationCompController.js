({
	doInit: function(component,event,helper){
		if(component.get("v.leadID") == '' || component.get("v.leadID") == null || component.get("v.leadID") == undefined)
		helper.showToast(component,'Error!', 'Customer not assigned to this Product Offering', 'error' );
        helper.getApplicantPickListValues(component,component.get("v.leadID")); 
       	if (component.get("v.isConverted") == true)
        		helper.disableForm(component);
    },
    
    getGeoLocation: function(component, event, helper){
    },
    
    isAllowBrowse : function(component, event, helper){
        helper.isAllowBrowse(component);
    },
    
    saveData : function(component, event, helper){
        var btn = event.getSource();
		btn.set("v.disabled",true);
        helper.saveDataHelper(component, component.get("v.selectedApplicant"), component.get("v.selectedVerification"), component.get("v.selectedStatus"),component.get("v.POid"));
    },

    closeCustomToast : function(component, event, helper){
        var customToast = component.find("customToast");
        $A.util.addClass(customToast,"slds-hide");
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme,"slds-theme--error");
        $A.util.removeClass(toastTheme,"slds-theme--success");
    },

    enableSubmitButton : function(component, event, helper){
        helper.enableSubmitButton(component, event);
    },
    
    imageCount : function(component, event, helper){
    },
})