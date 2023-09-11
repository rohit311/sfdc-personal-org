({
	/*
    *   @description	: 	Method is called when user selects a record from the list of records. 
    * 						Fires SelectedRecordEvent to pass the selected record reference to the child component.
    *   @version		: 	1.0
    */ 
    selectRecord : function(component, event, helper){      
         // Get the selected record from list  
         var getSelectRecord = component.get("v.record");
         
         // Call the event   
         var compEvent = component.getEvent("SelectedRecordEvent");
    
         // Set the selected record to the event attribute.
         compEvent.setParams({
             "record" : getSelectRecord 
         });  
    
         // Fire the event  
         compEvent.fire();
    },
})