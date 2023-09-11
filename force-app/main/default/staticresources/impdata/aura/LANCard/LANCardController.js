({  
    doInit : function(component, event, helper){
		helper.getDiscrepancies_pos(component);	
       console.log(component.get("v.oppObj"));        
	},
    handleRecordUpdated: function(component, event, helper) {
        
        var eventParams = event.getParams();
        console.log(eventParams.changeType);
        if(eventParams.changeType === "LOADED") {
            // record is loaded (render other component which needs record data value)
            console.log("Record is loaded successfully.");
              console.log(component.get("v.oppObj").Id);
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
          
        }
        console.log(component.get("v.oppObj").Id);
        helper.updateProgessBar(component);
    },
    		
    openDiscrepancy:function(component, event, helper) {
      
        console.log('display');
        var cmpTarget = component.find('DiscrepancyModal');
        var cmpBack = component.find('ModalbackdropDiscrepancy');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
        helper.showHideDiv(component, "DiscrepancyModal", true);
       
       
	},
     closeDiscrepancyModal:function(component,event,helper){    
        var cmpTarget = component.find('DiscrepancyModal');
        var cmpBack = component.find('ModalbackdropDiscrepancy');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        helper.showHideDiv(component, "DiscrepancyModal", false);
    },
     /*callSendBack : function(component, event, helper) {
        console.log('in controller');
        helper.callSendBack(component , event);
    },*/
    disableLoanCard : function(component, event, helper) {
       
        console.log('inside disbale Loan card');
        if(event.getParam("loanStage") == 'Branch Ops' || event.getParam("loanStage") == 'Moved To Finnone') {
            helper.disableLoanCard(component);
            console.log('inside disbale if');
        }
    },
    openSendBack : function(component, event, helper) {
        console.log('inside send back -->');
        var cmpTarget = component.find('sendBackReasonModal');
        var cmpBack = component.find('sendBackModalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
        helper.showHideDiv(component, "sendBackReasonModal", true);
    },
    saveReasonCall :  function(component, event, helper) {
        console.log('save --> ', component.get("v.oppObj").COO_Comments__c);
        if (component.get("v.oppObj").COO_Comments__c != null && component.get("v.oppObj").COO_Comments__c != undefined && component.get("v.oppObj").COO_Comments__c != '') {
            component.find("sendBackReason").set("v.errors", [{message:""}]);
            helper.saveReasonCall(component);
        } else {
            console.log('else --> ', component.find("sendBackReason"));
            component.find("sendBackReason").set("v.errors", [{message:"Please enter reason to send back in Comment!"}]);
        }
    },
    closeModal : function(component,event,helper){    
        var cmpTarget = component.find('sendBackReasonModal');
        var cmpBack = component.find('sendBackModalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        helper.showHideDiv(component, "sendBackReasonModal", false);
    },
})