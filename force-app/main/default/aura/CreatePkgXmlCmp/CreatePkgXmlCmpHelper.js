({
	fetchOrgData : function(component,event) {
		var action = component.get("c.fetchMetadata");
        action.setParams({"dataType":component.get("v.dataType")});
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log(response.getState());
            if(state === "SUCCESS"){
                component.set('v.compLst',response.getReturnValue()[component.get("v.dataType")]);
                console.log(response.getReturnValue()[component.get("v.dataType")]);
            }
            
        });
        
        $A.enqueueAction(action);
	}
})