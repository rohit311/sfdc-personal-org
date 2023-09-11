({
	doInit: function(component,event,helper){
        console.log('in Do-init');
        var parentId = component.get("v.loanApplicationId");
        console.log('in Do-init w/ parent id : '  + parentId);
        helper.getApplicantPickListValues(component,parentId);
       	helper.getUserProfile(component);
        //execute callApexMethod() again after 5 sec each
	   // window.setInterval(helper.hideUploadButton(component),5000); 
    },
    
    onApplicantChange : function(component, event, helper) {
        var selectedApplicant = component.find("applicant_Select").get("v.value");
        component.set("v.selectedApplicant", selectedApplicant);
        console.log('selectedApplicant ------->> '+selectedApplicant);
	},
    
    onVerificationChange : function(component, event, helper) {
        var selectedVerification = component.find("verificationType_Select").get("v.value");
        component.set("v.selectedVerification", selectedVerification);
        console.log('selectedVerification ------->> '+selectedVerification);
	},
    
    salesStatusChange : function(component, event, helper) {
        var selectedStatus = component.find("salesStatus_Select").get("v.value");
        component.set("v.selectedStatus", selectedStatus);
        console.log('salesStatusChange ------->> '+selectedStatus);
	},
    
    creditStatusChange : function(component, event, helper) {
        var selectedStatus = component.find("creditStatus_Select").get("v.value");
        component.set("v.selectedStatus", selectedStatus);
        console.log('creditStatusChange ------->> '+selectedStatus);
	},
    
    opsStatusChange : function(component, event, helper) {
        var selectedStatus = component.find("opsStatus_Select").get("v.value");
        component.set("v.selectedStatus", selectedStatus);
        console.log('opsStatusChange ------->> '+selectedStatus);
	},
    
    saveData : function(component, event, helper){
        console.log('inside saveData');
        helper.saveDataHelper(component, component.get("v.selectedApplicant"), component.get("v.selectedVerification"), component.get("v.selectedStatus"));
    }                      
})