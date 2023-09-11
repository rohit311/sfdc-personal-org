({
	fireApplicationEvent : function(component, event, helper) {
        var appEvent = $A.get("e.c:aeEvent");
        appEvent.setParams({
            "message" : "An application event fired me. " +
            "It all happened so fast. Now, I'm everywhere!"
        });
        
        appEvent.fire();
	}
})