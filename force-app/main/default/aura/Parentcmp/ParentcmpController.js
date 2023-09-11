({
	doInit1 : function(component, event, helper) {
		var action=component.get("c.getParent1s");
        
        action.setCallback(this,function(response){
            
            var state=response.getState();
            
            if(component.isValid() && state==="SUCCESS")
                {
                    
                    component.set("v.pList",response.getReturnValue());
                    console.log("--> "+component.get("v.pList"));
                    
                }
            else
            {
                console.log("failed with "+state);
            }
            console.log("--> "+component.get("v.pList"));
            
            $A.enqueueAction(action);
        });
        
        
	}
})