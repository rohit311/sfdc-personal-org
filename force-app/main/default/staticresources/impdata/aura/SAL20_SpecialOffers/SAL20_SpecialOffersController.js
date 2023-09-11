({
	onInit : function(component, event, helper) {
        if(component.get('v.oppId'))
        {
            var rId = component.get("v.oppId");            
            var action = component.get("c.getGroupType");
            action.setParams({oId: rId} );
            action.setCallback(this, function( res){
                var gType = res.getReturnValue();
                if(gType !== undefined && gType !== null && gType !== '')
                {
                    component.set('v.groupType',gType); // Bug 22065
                }
                else
                {
                    alert("Something went wrong. Please check your data once. ");
                }
                
            });            
            $A.enqueueAction(action);
        }
        else{
            alert('Please check opportunity Id or its grouptype.');
        }
    },
    
})