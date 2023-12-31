({
	executeAction : function(component,action,callback){
        return new Promise(function(resolve,reject){
            
            
            action.setCallback(this,function(response){
                var state = response.getState();
                if(state == 'SUCCESS'){
                    var retVal = response.getReturnValue();
                    resolve(retVal);                    
                }
                else if(state == 'ERROR'){
                    var errors = response.getError();
                    if (errors) {
                    if (errors[0] && errors[0].message) {
                        reject(Error("Error message: " + errors[0].message));
                    }
                }
                else {
                    reject(Error("Unknown error"));
                }
                }
                
            });
            
            $A.enqueueAction(action);

        });  
        
    },
})