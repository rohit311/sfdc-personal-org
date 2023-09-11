({
    doInit : function(component, event, helper) {
       component.set("v.showSpinner",true);
         helper.getRecord(component)
      // helper.getPicklistValues(component)
    },
     handleSaveRecord: function(component, event, helper) {
       
         var multislect = component.find("rejectReason");
         if(multislect)
          var mySelectedvalues = multislect.bindData('rejectReasonId');
         
          multislect = component.find("crosssellproduct");
           if(multislect)
          mySelectedvalues = multislect.bindData('crosssellproductId');
         
          if(helper.validateRecord(component))
          helper.saveData(component);
    },

    /**
     * Control the component behavior here when record is changed (via any component)
     */
    handleRecordUpdated: function(component, event, helper) { 
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
           
        } 
    },
    handleChange: function(component){
       var selectedOptionValue = event.getParam("value");
        
    },
    cancelClick:function(component){
    component.set("v.recordLoadFlag", false);  
         //window.location.replace("/006/o");
    },
     onControllerFieldChange: function(component,event, helper) {   
          helper.fieldChange(component);
         component.set("v.Opportunity.Reject_Reason__c",'');
         var multislect = component.find("rejectReason");
         if(multislect)
         multislect.setRejectReason(component.get("v.Opportunity.Reject_Reason__c"),'rejectReasonId');
       
     },
     closeCustomToast : function(component, event, helper){
        /*
         * Method Name:	 	closeCustomToast
         * Functionality: 	To peform close activity on Custom Toast Message
         * @param: 			component, event, helper
         * @return:			NA
         * From requirement number: Bug 20391 - Ops 2.0 Lightning
         * Invoked from: 	Custom Toast : Close  button
         * Invoking:		SAL20_DiscrepancyUpdate : helper.closeToast
        */
        
        helper.closeToast(component);
    } 
})