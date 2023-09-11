({
	doInit : function(component, event, helper) {
		var action = component.get("c.fetchProfiles");
        
        action.setCallback(this,function(response){
            let state = response.getState();
            
            if(state == "SUCCESS"){
                if(response.getReturnValue() && response.getReturnValue().length >0){
                    component.set("v.profileList",response.getReturnValue());
                }
            }
            else{
                alert('Error occured !');
            }
            
        });
		
        $A.enqueueAction(action);
    
    },
    
    handleProfileChange : function(component, event, helper) {
    	console.log(component.get('v.selProfile'));
        
        var action = component.get("c.fetchPermissions");
        action.setParams({"fetchPermissions":component.get('v.selProfile')});
        
        action.setCallback(this,function(response){
            let state = response.getState();
            
            if(state == "SUCCESS"){
                console.log('permissions ',response.getReturnValue());
            }
            else{
                alert('Error occured !');
            }
            
        });
		
        $A.enqueueAction(action);
        
    },
})