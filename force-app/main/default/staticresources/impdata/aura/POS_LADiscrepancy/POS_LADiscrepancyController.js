({
		doInit: function(component, event, helper) {
       
        
        
        
	},
    saveDiscrepancy: function(component, event, helper) {
       
           helper.saveDiscrepancies(component);
        
        
	},
    showToast :  function(component,event,helper) {
        event.getParam("");
       helper.showToast(component, event.getParam("title"), event.getParam("message"), event.getParam("type"));
    },
	 closeCustomToast :  function(component,event,helper) {
      helper.closeToast(component);
      
    },
    
})