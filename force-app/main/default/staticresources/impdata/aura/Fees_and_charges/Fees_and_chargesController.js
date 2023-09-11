({
	 subscribetoFFR : function(component,event,helper){
         helper.subscribetoFFR(component,event);     
	},
     closeToastnew: function (component, event, helper) {
		helper.closeToastnew(component, event.target.id);
	},
	closeToastError: function (component, event, helper) {
		helper.closeToastError(component, event.target.id);
	},
    
})