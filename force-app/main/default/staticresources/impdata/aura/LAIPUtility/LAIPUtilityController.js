({    
    navigateToSearchBulk : function(component, event, helper)
    {        
        component.set("v.homeFlag",false);
        $A.createComponent(
            "c:DataUploader",{},
            function(newComponent,status,errorMessage){
                //  alert(component.get("v.body"));
                //  alert(newComponent);
                component.set("v.body",newComponent);
                
                if (status === "SUCCESS") 
                {
                    console.log('SUCCESS');
                }
                else if (status === "INCOMPLETE")
                {
                    console.log("No response from server or client is offline.")
                }
                else if (status === "ERROR")
                {
					console.log("Error: " + errorMessage);
                }
            }
        )        
    },
    navigateToSearchSingle : function(component, event, helper)
    {        
        component.set("v.homeFlag",false);
        $A.createComponent(
            "c:LAIPCustomerCreation",{},
            function(newComponent,status,errorMessage)
            {
                component.set("v.body",newComponent);
                if (status === "SUCCESS") 
                {
                    console.log('SUCCESS');
                }
                else if (status === "INCOMPLETE")
                {
                    console.log("No response from server or client is offline.")
                }
				else if (status === "ERROR")
                {
                    console.log("Error: " + errorMessage);
                }
            }
        )
    },    
})