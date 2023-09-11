({
	fireComponentEvent : function(component, event, helper) {
		var cmpEvent=component.getEvent("cmpEvent");
        cmpEvent.setParams({"message":"new message."});
        cmpEvent.fire();
	}
})