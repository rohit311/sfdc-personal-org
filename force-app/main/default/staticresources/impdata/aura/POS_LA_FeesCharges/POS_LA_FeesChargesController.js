({
	doInit : function(component, event, helper) {
		//helper.getFeesNChargesRecords(component, event);
		if(component.get("v.feesNChargesList") && component.get("v.feesNChargesList").length > 0)
            component.find("saveId").set("v.disabled","false");
        if(component.get("v.shouldBeDisable") == true && component.get("v.oppoObject").StageName != 'Post Approval Sales')
        	helper.disableFeesAndChargesForm(component);
        
        component.set("v.DueDate",component.get("v.oppoObject.Due_Day__c"));
	},
    
    validatechargeAmount: function(component, event, helper){
    	helper.validatechargeAmount(component)
    },
    
    onchangeamount: function(component, event, helper){
    	helper.validateCharge(component, event, helper)
    },
    fetchCharges : function(component, event, helper) {
        if(helper.validateForm(component, event))
           helper.callFetchCharges(component, event);
   },
    disableFeesAndChargesForm : function(component, event, helper) {
        if(event.getParam("loanStage") == 'Branch Ops' || event.getParam("loanStage") == 'Moved To Finnone') {
            helper.disableFeesAndChargesForm(component);
        }
    },
    
    saveCharges : function(component, event, helper)
    {
        if(helper.validatechargeAmount(component, event) == true)
        	helper.saveChargesHelper(component, event);
    }
})