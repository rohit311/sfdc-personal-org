({
    
    
    handleSaveCam : function(component, event, helper) {
        console.log('OppId'+component.get("v.oppId"));
        var validEligibility = component.find('eligibilityForm').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
       console.log('validEligibility'+validEligibility); 
        if(validEligibility){
            /*component.find("camRecordHandler").saveRecord($A.getCallback(function(saveResult) {
                if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                    // handle component related logic in event handler
                    helper.callEligibiltySegm(component);
                } else if (saveResult.state === "INCOMPLETE") {
                    console.log("User is offline, device doesn't support drafts.");
                    
                } else if (saveResult.state === "ERROR") {
                    console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                    
                } else {
                    console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                }
            }));*/
            
           helper.updateCamObj(component);
        }
        else{
    		helper.displayMessage(component, 'ErrorToast2', 'errormsg2', '<b>Error!</b>,Please fill all mandatory fields!');
		}
        
 		
	},
    
    callEligibilityTab : function(component, event, helper){
        helper.callEligibiltySegm(component);
    },
    
    recordUpdated : function(component, event, helper){
        /*var changeType = event.getParams().changeType;
        if (changeType === "CHANGED") { 
            
             handle record change; reloadRecord will cause you to lose your current record, including any changes you’ve made 
            component.find("camRecordHandler").reloadRecord();
        }*/
    },
        
    closeToastSuc: function (component, event, helper) {
        helper.closeToastSuc(component, event.target.id);
    },
    closeToastErr: function (component, event, helper) {
        helper.closeToastErr(component, event.target.id);
    },
                
})