({
	getLead : function(component, event, helper) {
		var action = component.get("c.dummyleadcheck");
        action.setCallback(this, function(a){
            console.log(a.getState());
            console.log("return values ==> " , a.getReturnValue());
            component.set("v.LeadValue", a.getReturnValue());
            console.log('value');
            console.log(component.get("v.LeadValue"));
        });
        
        $A.enqueueAction(action);
	}
})