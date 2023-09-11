({
	getApplicantPickListValues : function(component,parentId){
    	var action = component.get("c.getApplicantPickListValues");
        action.setParams({
            "loanAppId": parentId
        });
        action.setCallback(this, function(response){
        	var state = response.getState();
        	if (component.isValid() && state === "SUCCESS") {
                var optionStr = response.getReturnValue();
                component.set("v.applicantList", optionStr);
        	}
    	});
        $A.enqueueAction(action);
    },
    
    getUserProfile : function(component){
    	var action = component.get("c.getUserProfile");
        action.setCallback(this, function(response){
        	var state = response.getState();
        	if (component.isValid() && state === "SUCCESS") {
                var profileName = response.getReturnValue();
                console.log('profileName ------>> '+profileName);
                if(profileName == 'Area Sales Manager')
                {
                	component.set("v.salesStatusFlag", true);
                }else if(profileName == 'Area Credit Manager')
                {
					component.set("v.creditStatusFlag", true);
                }else if(profileName == 'OPs Officer' || profileName == 'CPA Login Partner')
                {
					component.set("v.opsStatusFlag", true);
                }
                
        	}
    	});
        $A.enqueueAction(action);
    }, 
    
    hideUploadButton : function(component){
        var toggleText = component.find("Upload");
        console.log('toggleText ---->> '+toggleText);
        $A.util.addClass(toggleText, "slds-hide");
    },
    
    saveDataHelper : function(component, selectedApplicant, verificationType, status){
        console.log(selectedApplicant);
        console.log(verificationType);
        console.log(status);
        
        var saveDataMethod = component.get("c.saveVerificationData");
        saveDataMethod.setParams({
            "applicantName": selectedApplicant,
            "verificationType": verificationType,
            "status": status
        });
        saveDataMethod.setCallback(this, function(response){
        	var state = response.getState();
        	if (component.isValid() && state === "SUCCESS") {
                var verificationId = response.getReturnValue();
                console.log('verificationId ----->> '+verificationId);
        	}
    	});
        $A.enqueueAction(saveDataMethod); 
    }
    
})