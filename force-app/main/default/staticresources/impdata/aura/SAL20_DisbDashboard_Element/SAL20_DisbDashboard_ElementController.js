({
	navigateComponent : function(component, event, helper) {
        var evt = component.get("v.Event");
        if(evt)
        {
            var appEvent = $A.get("e.c:SAl20_DisbDashboard_Navigator");
            appEvent.setParams({
                "SAL20_Dashboard_Component" :  component.get("v.Event")});
            appEvent.fire();
        }
        else{
            alert('Something went wrong! Please contact your administrator~!');
        }
	}
})