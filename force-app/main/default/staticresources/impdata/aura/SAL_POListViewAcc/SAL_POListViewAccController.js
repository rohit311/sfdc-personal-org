({
	doInit : function(component, event, helper) {
        console.log('in doinit');
		
	},
    toggletab : function(component, event, helper) {
        helper.toggleAccordion(component,event);
    },
})