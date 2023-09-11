({
    LOAN_APPLICATION_ID : '',
    FILES_COUNT : 0,
    // Bug 15855 S - Added Extra function parameter to differentiate flow
	getApplicantPickListValues : function(component,parentId,parentObj){
       
    	this.LOAN_APPLICATION_ID = parentId;
    	var action = component.get("c.getApplicantPickListValues");
        action.setParams({
            "parentId": parentId,
            "parentObj": parentObj
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
    	getsubmitflagValue : function(component,parentId,parentObj){
        
    
        var action = component.get("c.getflagValue");
        action.setParams({
            "parentId": parentId,
            "parentObj": parentObj
        });
        action.setCallback(this, function(response){
        	var state = response.getState();
           
        	if (component.isValid() && state === "SUCCESS") {
                var submitflag = response.getReturnValue();
              
               if(!submitflag){
                   return true;
				}                
                return false;
                              
        	}
    	});
        $A.enqueueAction(action);
    	
    },
    
    getUserProfile : function(component,parentId,parentObj){
    	var action = component.get("c.getUserProfile");
        action.setParams({
            "parentId": parentId,
            "parentObj" : parentObj
        });
        action.setCallback(this, function(response){
        	var state = response.getState();
        	if (component.isValid() && state === "SUCCESS") {
                var returnedString = response.getReturnValue();        
            
                if(returnedString == 'true')
                    component.set("v.showSubmitButtonFlag", true);
                else
                	component.set("v.showSubmitButtonFlag", false);
                
                 if(component.get("v.flowV3forPricing") == 'mobilityv2_pricing'){ /* 17556 */
                    component.set("v.showSubmitButtonFlag", true); 
                }
        	}
    	});
        $A.enqueueAction(action);
    },
    
    saveDataHelper : function(component, selectedApplicant, verificationType, status, parentId, flow){
	// Bug 15855 E
    	console.log('inside savedatahelper');
        self = this;
        if(selectedApplicant == '' || selectedApplicant == null || selectedApplicant == '--Select--')
        {
          
            if(component.get("v.flow") != 'Mobility2')
            	self.showToast(component,'Error!', 'Kindly select an applicant first.', 'error' );
            else
            	this.displayToastMessage(component,event,'Error','Kindly select an applicant first.','error');
            component.find("saveButtonId").set("v.disabled",false);
            return;
        }else if(verificationType == '' || verificationType == null || verificationType == '--Select--')
        {
           	if(component.get("v.flow") != 'Mobility2')
            	self.showToast(component,'Error!', 'Kindly select a verification type first.', 'error' );
            else
                this.displayToastMessage(component,event,'Error','Kindly select a verification type first.','error');
            component.find("saveButtonId").set("v.disabled",false);
            return;
        }else if(status == '' || status == null || status == '--Select--')
        {
    		if(component.get("v.flow") != 'Mobility2')
            	self.showToast(component,'Error!', 'Kindly select a status first.', 'error' );
            
            else
                this.displayToastMessage(component,event,'Error','Kindly select a status first.','error');
            component.find("saveButtonId").set("v.disabled",false);
            return;
        }
        
        if((status == 'Positive' || status == 'Negative') && self.FILES_COUNT < 1)
        {
            if(component.get("v.flow") != 'Mobility2')
            	self.showToast(component,'Error!', 'Select a minimum of one file to proceed further.', 'error' );
            else
                this.displayToastMessage(component,event,'Error','Select a minimum of one file to proceed further.','error');
            component.find("saveButtonId").set("v.disabled",false);
            return;
        }
    
        var saveDataMethod = component.get("c.saveVerificationData");
        saveDataMethod.setParams({
            "applicantName": selectedApplicant,
            "verificationType": verificationType,
            "status": status,
            "parentId": parentId,
            "flow": flow			//Bug 15855 - Added Extra parameter
        });
        saveDataMethod.setCallback(this, function(response){
        	var state = response.getState();
        	if (component.isValid() && state === "SUCCESS") {
                var verificationId = response.getReturnValue();
				// Bug 15855 S
    
                component.set("v.verificationId", verificationId);
    
    
    
                //self.showToast(component,'Success!', 'Verification record saved successfully.', 'success' );//Bug 15855 - Commented by hemant.
				component.find("saveButtonId").set("v.disabled",false);
                if(this.FILES_COUNT < 1){
                    component.find("saveButtonId").set("v.disabled",false);
                    if(status === 'Deferral'){
                        this.updateVerificationListEvent(component);
                    }
                }else
                    //console.log('gfgh');
                	this.triggerPostVerificationSaveEvent(component);

                //if(component.get("v.parentObj") === 'PO')
                	this.resetData(component);
				// Bug 15855 E
        	}
    	});
        $A.enqueueAction(saveDataMethod); 
        
    },
    
    triggerPostVerificationSaveEvent: function(component){
       
        if(component.find("file-uploader-11")){
            var cmp = component.find("file-uploader-11");
            if(cmp.get("v.imageUpload")  === "true")
            	cmp.callSave();
           //  	alert('first done');
            }
        
	if(component.find("file-uploader-12")){
            var cmp = component.find("file-uploader-12");
            if(cmp.get("v.imageUpload")  === "true")
            	cmp.callSave();
       		  //  alert('second done');
            }
        
        if(component.find("file-uploader-13")){
            var cmp = component.find("file-uploader-13");
            if(cmp.get("v.imageUpload")  === "true")
            	cmp.callSave();
            //	alert('third done');
            }
        
       // var verificationInsertEvent = $A.get("e.c:VerificationInsertEvent");
       // verificationInsertEvent.setParams({ 
           // "verificationId": component.get("v.verificationId"),		//	bug 15855
          //  "selectFileErrorFlag": false
        //});
        //verificationInsertEvent.fire();
    },
	// bug 15855 s - Added updateVerificationListEvent, resetData functions
    updateVerificationListEvent : function(component){
        var verficationUpdateEvent = $A.get("e.c:UpdateVerificationList"); 
        if(verficationUpdateEvent){
            verficationUpdateEvent.fire();
        }
    },
    resetData : function(component){
        component.find("applicant_Select").set("v.value","--Select--") ;
        component.find("verificationType_Select").set("v.value","--Select--");
        component.find("salesStatus_Select").set("v.value","--Select--") ;
    },
	// Bug 15855 E
    showToast : function(component, title, message, type){
        if(component.get("v.flowV2") != 'mobilityV2'){
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
    
    countFilesBrowsed : function(component,event){
        var isImageSelected = event.getParam("isImageSelected");
        
        if(isImageSelected == true)
        {
            this.FILES_COUNT = this.FILES_COUNT + 1;
        }
        else if(isImageSelected == false && this.FILES_COUNT > 0)
        {
            this.FILES_COUNT = this.FILES_COUNT - 1;
        }
        
    },
    
    enableSubmitButton : function(component, event){
        this.updateVerificationListEvent(component);
        component.find("saveButtonId").set("v.disabled",false);
        if(this.FILES_COUNT < 1)
        {
            component.find("saveButtonId").set("v.disabled",false);
        
            //Bug 15855 S
            this.showToast(component,'Success!', 'Verification record saved successfully.', 'success' );
            //Bug 15855 E
        }
    },
    disableSubmitButton : function(component, event){
    
	 component.find("saveButtonId").set("v.disabled",true);
     component.find("applicant_Select").set("v.disabled",true);
     component.find("verificationType_Select").set("v.disabled",true);
     component.find("salesStatus_Select").set("v.disabled",true);
        
        
        
    },
    showhidespinner:function(component, event, showhide){
        console.log('here');
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },
    displayToastMessage:function(component,event,title,message,type)
    {
        console.log('inside displayToastMessage'+message+type);
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type,
            
        });
        showhideevent.fire();
    },
    
})