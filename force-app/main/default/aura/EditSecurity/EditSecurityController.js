({
	doInit : function(component, event, helper) {
		component.find("SecurityRecordCreator").getNewRecord(
        "Security__c",
         null,
         false,
            $A.getCallback(function(){
                var rec = component.get("v.newSecurity");
                var error = component.get("v.newSecurityError");
                if(error || (rec === null)){
                    console.log("Error initializing record template: " + error);
                    
                }
                else{
                    console.log("Record template initialized: " + rec.sobjectType);
                }
                
            })
        );
	},
    handleSaveSecurity : function(component, event, helper) {
        component.set("v.newSimpleSec.UserId__c", component.get("v.conId"));
        component.set("v.newSimpleSec.Security_Name__c", component.get("v.SecName"));
        component.set("v.newSimpleSec.Symbol__c", component.get("v.symbol"));
        component.set("v.newSimpleSec.Type__c", component.get("v.type"));
        component.find("SecurityRecordCreator").saveRecord(function(saveResult){
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                var resultsToast = $A.get("e.force:showToast");
                
                if(resultsToast){
                    resultsToast.setParams({
                        "title": "Saved",
                        "message": "The record was saved."
                    });
                    resultsToast.fire();
                    
                }
            }else if (saveResult.state === "INCOMPLETE") {
                    // handle the incomplete state
                    console.log("User is offline, device doesn't support drafts.");
                } else if (saveResult.state === "ERROR") {
                    // handle the error state
                    console.log('Problem saving contact, error: ' + 
                                 JSON.stringify(saveResult.error));
                } else {
                    console.log('Unknown problem, state: ' + saveResult.state +
                                ', error: ' + JSON.stringify(saveResult.error));
                }
            
            
        });
        
        
        
        
    },
    closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   } 
})