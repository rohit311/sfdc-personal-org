({
	/*
    *   @description	: 	Method is called when user enters text in search box. 
    * 						Calls apex method to get results for SearchKeyWord.
    *   @version		: 	1.0
    */
    searchHelper : function(component, event, getInputkeyWord) {
	  	// Call the apex class method 
     	var action = component.get("c.getRecords");
	 	var ObjectName = component.get("v.ObjectName");
        var FieldName = component.get("v.FieldName");
        var isSALMobilityFlow = component.get("v.isSALMobilityFlow");
        //alert('selectedRecord++'+selectedRecord);
        var FieldSet = [];
        FieldSet.push(FieldName);
       
        // Set parameters to the method  
        action.setParams({
			"ObjectName" : ObjectName,
            "FieldList" : FieldSet,
            "IdList" : null,
            "searchCriteria" : getInputkeyWord,
            "isSALMobilityFlow" : isSALMobilityFlow
		});
      
        // Set a callback to get results
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              	
                // If storeResponse is empty, display No Result Found... message on screen
                if (storeResponse.length == 0) {
                    component.set("v.Message", "No Result Found...");
                } else {
                    component.set("v.Message", "Search Result...");
                }
                
                // Set searchResult list with return value from server
                component.set("v.listOfSearchRecords", storeResponse);
            }
 
        });
      	// Enqueue the action  
        $A.enqueueAction(action);
	},
})