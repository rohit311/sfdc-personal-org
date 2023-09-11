({
    LEAD_ID : '',
    FILES_COUNT : 0,
    
	getApplicantPickListValues : function(component,parentId){
    	this.LEAD_ID = parentId;
    	
    	var action = component.get("c.CpvApplicants");
        action.setParams({
            "id1": parentId
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
    
    isAllowBrowse : function(component){
    	var selApplicant = component.get("v.selectedApplicant");
    	var selVerfType = component.get("v.selectedVerification");
    	var selStatus = component.get("v.selectedStatus");
    	if(selApplicant != null && selApplicant != undefined && selApplicant != '' && selApplicant != '--Select--' &&
    		selVerfType != null && selVerfType != undefined && selVerfType != '' && selVerfType != '--Select--' ){
    		
    		component.set("v.allowBrowse",true);
    	}
    	else{
    		component.set("v.allowBrowse",false);
    	}
    },
    
    
    saveDataHelper : function(component, selectedApplicant, verificationType, status, POid){
        self = this;
        self.imageCount(component);
        if(selectedApplicant == '' || selectedApplicant == null || selectedApplicant == '--Select--' || selectedApplicant == undefined)
        {
            self.showToast(component,'Error!', 'Kindly select an applicant first.', 'error' );
            component.find("saveButtonId").set("v.disabled",false);
            return;
        }else if(verificationType == '' || verificationType == null || verificationType == '--Select--' || verificationType == undefined)
        {
            self.showToast(component,'Error!', 'Kindly select a verification type first.', 'error' );
            component.find("saveButtonId").set("v.disabled",false);
            return;
        }else if(status == '' || status == null || status == '--Select--' || status == undefined)
        {
            self.showToast(component,'Error!', 'Kindly select a status first.', 'error' );
            component.find("saveButtonId").set("v.disabled",false);
            return;
        }
        
        if((status == 'Positive' || status == 'Negative') && this.FILES_COUNT < 1)
        {
            self.showToast(component,'Error!', 'Select a minimum of one file to proceed further.', 'error' );
            component.find("saveButtonId").set("v.disabled",false);
            return;
        }
        var saveDataMethod = component.get("c.saveVerificationData");
        saveDataMethod.setParams({
            "applicantName": selectedApplicant,
            "verificationType": verificationType,
            "status": status,
            "POid": POid
        });
        saveDataMethod.setCallback(this, function(response){
        	var state = response.getState();
        	if (component.isValid() && state === "SUCCESS") {
                var verificationId = response.getReturnValue();
                component.set("v.parentId", verificationId);
                if(this.FILES_COUNT < 1)
                    component.find("saveButtonId").set("v.disabled",false);
                else
                	this.triggerPostVerificationSaveEvent(component);
        	}
    	});
        $A.enqueueAction(saveDataMethod); 
    },
    
    triggerPostVerificationSaveEvent: function(component){
    	var imgs = component.find("Premise");
        if(imgs != undefined)
        for(var i=0;i<imgs.length;i++){
        	if(imgs[i].get("v.allowUpload") == "true"){
        		imgs[i].set("v.parentId",component.get("v.parentId"));
        		imgs[i].doUpload();
        	}
        }
    },
    
    showToast : function(component, title, message, type){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "3000"
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
    
    enableSubmitButton : function(component, event){
    	this.imageCount(component);
        if(this.FILES_COUNT == 0)
        {
            component.find("saveButtonId").set("v.disabled",false);
            component.set("v.selectedApplicant",'--Select--');
            component.set("v.selectedVerification",'--Select--');
            component.set("v.selectedStatus",'--Select--');
            self.showToast(component,'Success!', 'Verification record saved successfully.', 'success' );
        }
    },
    imageCount : function(component){
    	this.FILES_COUNT = 0;
        var imgs = component.find("Premise");
        if(imgs != undefined)
        for(var i=0;i<imgs.length;i++){
        	if(imgs[i].get("v.allowUpload") == "true"){
        	this.FILES_COUNT = this.FILES_COUNT + 1 ;
        	}
        }
    },
  
    disableForm: function(component){
        component.find("saveButtonId").set("v.disabled", true);
    }
})