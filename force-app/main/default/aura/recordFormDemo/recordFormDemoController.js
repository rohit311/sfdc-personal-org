({
	
	handleLoad : function(component, event, helper) {
		console.log('handle handleLoad');
        component.set("v.showSpinner", false);
	},
    handleSubmit: function(component, event, helper){
    	event.preventDefault(); // Prevent default submit
        var fields = event.getParam("fields");
        
        component.find('createContactForm').submit(fields); // Submit form
		console.log('handle handleSubmit');
	},
    handleSuccess : function(component, event, helper) {
		console.log('record updated successfully');
        
        
        component.set("v.showSpinner", false);
	},
})