({
	menuItemClick: function(component, event, helper){ 
        helper.activateTab(component, event.target.getAttribute('id'));
    },
    doInit : function(component, event, helper) {
		/*
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:Opp_DSS_flow",
            componentAttributes: {
                oppId : component.get("v.recordId")
            }
        });
        evt.fire();
        
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
		dismissActionPanel.fire();*/
        if(component.get("v.oppId") != '')
        {
            component.set("v.recordId",component.get("v.oppId"));
        }
        console.log('oppId in parent'+component.get("v.recordId"));
        /*if("empty(v.recordId)"){
            component.set("v.oppId",'0065D0000027pqF');
        }*/
        
        //YK check component loading start...
    	var action = component.get("c.checkRedirectionValidity");
        action.setParams({
            "oppId": component.get("v.recordId"),
            "flowName": 'dssOppFlow',
            "version":'Mobility' //17138 added version
        });
        action.setCallback(this, function(response){
        	var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
                console.log('...inside success...');
                var wrapperObj = response.getReturnValue();
                
                console.log('wrapperObj.errorMessageString--->> '+wrapperObj.errorMessageString);
           		if(wrapperObj.errorMessageString != 'NO_ERROR')
                {
                    component.set("v.cmpLoadMsg", wrapperObj.errorMessageString);
                }    
        	}
    	});
        $A.enqueueAction(action);        
        //YK check component loading end...     
    },
    disableTabs : function(component, event, helper) {
        var disabling = event.getParam("disableTrue");
        $A.util.addClass(component.find("documentTab"), disabling ? "slds-hide" : "slds-show");
        $A.util.addClass(component.find("ActionTab"), disabling ? "slds-hide" : "slds-show");
            
    }
})