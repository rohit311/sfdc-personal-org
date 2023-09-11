({
    doInit : function(component, event, helper) {
       // if(component.get("v.currentStageIsMydetails")!=true)
        //{
            helper.showhidespinner(component,event,true);
            helper.getData(component);
            var oppId = component.get("v.oppId");
            console.log('in do init ',component.get("v.setTab"));
            // if(component.get("v.setTab"))
            	component.set("v.selTabId","tab4");
            helper.showhidespinner(component,event,false);
        	// Added by Anurag for 22181. Event to fire Insurance validations
        	// helper.firePassInsuranceEvent(component, []);
       // }
    },
    onInitiateOpenECS_Emandate : function(component, event, helper){
        helper.showhidespinner(component,event,true);
        //helper.getData(component);
        helper.checkCustomer(component);
        helper.getData(component);
    },
    clicksubmit : function(component, event, helper){
        
        /* if(!component.get("v.showValidationMsgOnSubmit"))
        {*/
        helper.showhidespinner(component,event,true);
        helper.clicksubmitMethod(component);
        //  }
        /*  else
        {
    helper.displayToastMessage(component,event,'Info','Please accept Application and E-Aggreement Form','message');	
        }*/
        
    },
    confirmTC : function(component, event, helper){
        // Added by Anurag for 22181. Event to fire Insurance validations
      	// helper.firePassInsuranceEvent(component, []);
        var confirmtc = component.find("checkBoxId").get("v.checked");
        if(component.get("v.repay")!=null){
            
            if (confirmtc != null && confirmtc == false)
            {
                helper.displayToastMessage(component,event,'Info','Please check confirmation checkbox','message');	
            }
            else{
                component.set("v.showSubmit",true);
                component.set("v.showConfirm",false);
                component.set("v.disableECSButton",true);
                component.set("v.showValidationMsgOnSubmit",true);
                helper.sendBothMails(component,event,helper);
            }  
        }
        else{
            helper.displayToastMessage(component,event,'info','Please hit Online Mandate Registration button before confirm','info');    
            helper.showhidespinner(component,event,false);   }
    },   
    showInfoMessage : function(component, event, helper){
        $A.util.removeClass(component.find("info1"), "slds-hide");
        console.log('sd');
    },
    hideInfoMessage : function(component, event, helper){
        $A.util.addClass(component.find("info1"), "slds-hide");
        console.log('sd');
    },
    showMessage : function(component,event,helper){
        var cmpTarget = component.find('overrideModalbox');
        var cmpBack = component.find('Modalbackdrop');
        //$A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpTarget, 'slds-hide');
        $A.util.addClass(cmpTarget, 'slds-show');
        $A.util.addClass(cmpBack, 'slds-backdrop_open');
    },
    closeMessage : function(component,event,helper){
        var cmpTarget = component.find('overrideModalbox');
        var cmpBack = component.find('Modalbackdrop');
        //$A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpTarget, 'slds-show');
        $A.util.addClass(cmpTarget, 'slds-hide');
        $A.util.removeClass(cmpBack, 'slds-backdrop_open');
    }
    
})