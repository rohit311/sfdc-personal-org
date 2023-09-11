({
	handleApplicationEvent : function(component, event, helper) {
		var message = event.getParam("message");
 
        // set the handler attributes based on event data
        component.set("v.messageFromEvent", message);
        var numEventsHandled = parseInt(component.get("v.numEvents")) + 1;
        component.set("v.numEvents", numEventsHandled);
	}
})