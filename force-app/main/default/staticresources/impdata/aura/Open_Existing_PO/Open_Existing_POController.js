({
	doInit : function(component, event, helper) {      
		var poId = component.get("v.recordId");
        //if(!poId)	component.set("v.recordId","a100k000000Twq3");
        helper.doinit(component, event);
    }
})