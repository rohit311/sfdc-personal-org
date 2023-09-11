({
	doInit: function(component, event, helper) {
		
	},
    savedetails : function(component,event,helper){
        helper.savedetails(component,event);
    },
    closeToastnew: function (component, event, helper) {
		helper.closeToastnew(component, event.target.id);
	},
	closeToastError: function (component, event, helper) {
		helper.closeToastError(component, event.target.id);
	},
   
})