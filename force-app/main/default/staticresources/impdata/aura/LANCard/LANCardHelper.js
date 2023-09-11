({
	  showHideDiv: function(component, divId, show){
        if(divId !== "nextButtonId"){
            $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        }
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
    
    getDiscrepancies_pos : function(component) {
		this.executeApex(component, "getDiscrepancies", {
            "loanId": component.get("v.recordId") // testing
        }, function(error, result){  
            if(!error && result){
                console.log('Description'+result);
               component.set("v.DiscrepancyObj",result);
                console.log('The discrepancies are'+component.get("v.DiscrepancyObj"));
                if(component.get("v.oppObj").StageName == 'Branch Ops' || component.get("v.oppObj").StageName == 'Moved To Finnone'){
                    this.disableLoanCard(component); 
                	component.set("v.docDisableFlag",true);// User Story 2357 Starts
                }
					
            }
        });
		
	},
   

    callSendBack : function(component, event, helper) {  
        component.set("v.spinnerFlag","true");
        this.executeApex(component, "sendback ", {"loanId" : component.get("v.recordId")}, function(error, result) {
            
            if(!error && result) {
                component.set("v.spinnerFlag","false");
                result = JSON.parse(result);
                if (result.status == "Success") 
                {   
                    this.ShowToast(component, "Success!",result.message , "success");
                     this.FetchOpportunity(component);
                }else{
                    this.ShowToast(component, "Error!",result.message , "erroe");
                }  
            }
            
        });
    },
    FetchOpportunity : function(component){
        this.executeApex(component, "queryData", {"oppId" : component.get("v.recordId")}, function(error, result) {
            if(!error && result) {
                console.log(result[0]);
                component.set("v.oppObj",result[0]);
                this.updateProgessBar(component);
                // this is to trigger event to enable relevant tabs
                if (component.get("v.oppObj").StageName == 'DSA/PSF Login') {
                    this.enableLoanCard(component);
                    this.triggerEnableFormEvent(component, component.get("v.oppObj").StageName);
                }
              }
        });
    },
    triggerEnableFormEvent: function(component, loanStage){
        var event = $A.get("e.c:EnableFormEventOnSendBack");;
        event.setParams({"loanStage": loanStage});
        event.fire();
    },
    ShowToast : function(component, title, message, type){
        var ShowToastEvent = $A.get("e.c:ShowToastEvent");
        ShowToastEvent.setParams({
            "title": title,
            "message":message,
            "type":type,
        });
        ShowToastEvent.fire();
    },
    updateProgessBar : function(component){
        
        var oppStage = component.get("v.oppObj.StageName");
       // if(component.get("v.theme") == 'Theme4d')
       // {
         //   var cmpTarget = component.find('boxBorder');
           // $A.util.addClass(cmpTarget, 'slds-box slds-box_x-small');
       // }
        console.log(oppStage);
        if(oppStage != null)
        {
            if(oppStage == 'DSA/PSF Login')
            {
                component.set("v.stageCompletion","20%") ;
            }
            else if(oppStage == 'Underwriting')
            {
                component.set("v.stageCompletion","40%");
            }
                else if(oppStage == 'Post Approval Sales')
                {
                    component.set("v.stageCompletion","60%");
                }
                    else if(oppStage == 'Branch Ops')
                    {
                        component.set("v.stageCompletion","80%");
                    }
                        else if(oppStage == 'Moved To Finnone')
                        {
                            component.set("v.stageCompletion","100%");
                            $A.util.addClass(component.find("progressSpan"),"slds-progress-bar__value_success");
                        	console.log('inside finnone');
                        }
        }
        
    }, 
    executeApex: function(component, method, params, callback){
        var action = component.get("c."+method); 
        action.setParams(params);
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if(state === "SUCCESS"){
                callback.call(this, null, response.getReturnValue());
            } else if(state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message){
                        errors.push(item.message);
                    }
                }
                this.ShowToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    disableLoanCard : function(component) {
        // disable button 2357
     
       // if (component.find("uploadId") != undefined) component.find("uploadId").set("v.disabled", true);
        if (component.find("sendBackId") != undefined) component.find("sendBackId").set("v.disabled", true);
        if (component.find("discrepancyId") != undefined) component.find("discrepancyId").set("v.disabled", true);
      //  console.log('component.find("uploadId")'+component.find("uploadId"));
        console.log('component.find("sendBackId")'+component.find("sendBackId"));
        console.log('component.find("discrepancyId")'+component.find("discrepancyId"));
        component.set("v.docDisableFlag",true);// User Story 2357 Starts
    },
    enableLoanCard : function(component) {
        // disable button
       // if (component.find("uploadId") != undefined) component.find("uploadId").set("v.disabled", false);
        if (component.find("sendBackId") != undefined) component.find("sendBackId").set("v.disabled", false);
        if (component.find("discrepancyId") != undefined) component.find("discrepancyId").set("v.disabled", false);
    },
    saveReasonCall : function(component, event, helper) {
        component.set("v.spinnerFlag","true");
        var opp = {'Id':component.get("v.oppObj").Id, 'COO_Comments__c':component.get("v.oppObj").COO_Comments__c};
        this.executeApex(component, "saveReason ", {"opp" : JSON.stringify(opp)}, function(error, result) {
            component.set("v.spinnerFlag","false");
            console.log('b on saving send back comment -->', result);
            if(!error && result) {
                //result = JSON.parse(result);
                if (result == "Success") {
                    // invoke send back method
                    var cmpTarget = component.find('sendBackReasonModal');
                    var cmpBack = component.find('sendBackModalbackdrop');
                    $A.util.removeClass(cmpBack,'slds-backdrop--open');
                    $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
                    this.showHideDiv(component, "sendBackReasonModal", false);
                    this.callSendBack(component, event);
                } else {
                    this.ShowToast(component, "Error!",result.message , "error");
                }
            }
        });
    },
})