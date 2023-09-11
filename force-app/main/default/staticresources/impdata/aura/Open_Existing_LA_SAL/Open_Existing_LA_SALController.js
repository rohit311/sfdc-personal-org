({
	doInit : function(component, event, helper) {
		console.log('in nav');
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:SAL_SalesCmp",
            componentAttributes: {
                recordId : component.get("v.recordId")
            }
        });
        evt.fire();
        
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
		dismissActionPanel.fire();

    }
})