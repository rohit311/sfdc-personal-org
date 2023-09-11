({
	doInit : function(component, event, helper) {
		
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:SAL_PricingCmp",
            componentAttributes: {
                recordId : component.get("v.recordId")
            }
        });
        evt.fire();
        
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
		dismissActionPanel.fire();

    }
})