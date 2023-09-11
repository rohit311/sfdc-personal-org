({
    doInit : function(component, event, helper){
        helper.getHideAadhaarSectionHelper(component);//Added For Bug 22047
       console.log('indoinit  '+component.get("v.recordId"));
        component.set("v.oppId",component.get("v.recordId"));
        var action = component.get("c.checkRedirectionValidity");
        action.setParams({
            "oppId": component.get("v.recordId"),
            "flowName": 'pricingFlow',
            "version" :'Mobility V2'
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var wrapperObj = response.getReturnValue();
                
                console.log('wrapperObj.errorMessageString--->> '+wrapperObj.errorMessageString);
                if(wrapperObj.errorMessageString != 'NO_ERROR')
                {
                    helper.showhidespinner(component,event,false);
                    component.set("v.cmpLoadMsg", wrapperObj.errorMessageString);
                }
                else
                    helper.onLoadPricingData(component, event);
            }
        });
        $A.enqueueAction(action); 
        //helper.getCardData(component, event);
    },
    sendback : function(component,event,helper){
        helper.showhidespinner(component,event,true);
        helper.backToStdRecordPage(component, event,component.get("v.oppId"));
    },
  callaccordianmethod : function(component, event, helper){ //1652    
        
        var activeSectionName = component.find("accordion").get('v.activeSectionName');
        if(activeSectionName == 'LoanDetails')
        {   // alert('i am atestat ');
         var cmp = component.find("loanDetail");
         cmp.checkHierarchyCondtions();
         
        }

    },
    
})