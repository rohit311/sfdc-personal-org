({
	myAction : function(component, event, helper) {
        var phoneEvent=component.getEvent("messageEvent");
        var phonenumber=component.get("phone");
        phoneEvent.setParams({
            "phone":phonenumber
        });
        
        phoneEvent.fire();
	}
})