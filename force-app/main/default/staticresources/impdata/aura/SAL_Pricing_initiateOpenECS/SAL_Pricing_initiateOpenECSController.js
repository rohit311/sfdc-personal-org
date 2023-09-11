({
	doInit : function(component, event, helper) {
		var oppId = component.get("v.oppId");
        console.log('in do init');
        helper.checkCustomer(component);
	},
    closeModalWindow : function(component, event, helper) {  
       
        component.set("v.isOpen", false);
        
    },
    cloneRepayDetails : function(component, event, helper){
           helper.showhidespinner(component,event,true);
        var LanId = component.get("v.oppId");
        helper.createCloneRepay(component);
        event.preventDefault();
        
        //component.set("v.isOpen", false);
    },
	

})