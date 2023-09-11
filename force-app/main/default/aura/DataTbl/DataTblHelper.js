({
	createcmp :function(component,Name,params,divName){
        var cmpName = "c:"+Name;
        
         console.log('in create');
            $A.createComponent(
                cmpName,params,
            function(newComponent,status,errorMessage){
                if (status === "SUCCESS") {
                        console.log('SUCCESS');
                    var targetCmp = component.find(divName);
                    	var body = targetCmp.get("v.body");
                    	body.push(newComponent);
                    	targetCmp.set("v.body", body);
                    
                    }
                    else if (status === "INCOMPLETE") {
                       console.log("No response from server or client is offline.")
                    }
                        else if (status === "ERROR") {
                            console.log("Error: " + errorMessage);
                    }
            }
        )
        
    }
})