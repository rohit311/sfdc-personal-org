({
    
    fetchSOLDetails: function(component,event){
        debugger;
        var action = component.get("c.fetchSOLData");
        
        action.setParams({});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.SOLList",response.getReturnValue());
                component.set("v.fetchSOLSuccess",true);
                 var solList=component.get("v.SOLList");
                if(solList.length ==1 ){
                    component.set("v.solPicDisable",true);
                    //component.set("v.SOLobj",solList[0]);
                }else{
                     component.set("v.solPicDisable",false);
                    // component.set("v.SOLobj",solList[0]);
                }
                component.set("v.SOLobj",solList[0]);
                console.log('SOLList>>>'+JSON.stringify(response.getReturnValue()));
            }         
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action); 
    }
})