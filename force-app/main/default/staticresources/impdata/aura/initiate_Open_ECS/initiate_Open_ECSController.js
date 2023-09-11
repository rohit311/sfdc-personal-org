({
	doInit : function(component, event, helper) {
		var oppId = component.get("v.oppId");
        
        console.log('Opp Id - '+oppId);
        helper.checkCustomer(component);
	},
    closeModalWindow : function(component, event, helper) {  
        console.log('in Close Functionality JS');
        component.set("v.isOpen", false);
        
    },
    cloneRepayDetails : function(component, event, helper){
        console.log('in Clone Functionality JS');
        var LanId = component.get("v.oppId");
        helper.createCloneRepay(component);
        event.preventDefault();
        
        //component.set("v.isOpen", false);
    },
	

})