({
	createUser : function(component, event) {
        var conJson = JSON.stringify([component.get("v.newContact")]);
        console.log(conJson);
        this.executeApex(component,"createNewUser",{"conStr":conJson},
                         function(error, result){
            				if(!error && result){
                                var response = JSON.parse(result);
                                 console.log(response);
                                var toastEvent = $A.get("e.force:showToast");
                                
                               
                                if(result.Status == 'Success'){
                                    toastEvent.setParams({
            							mode: 'dismissible',
                                        duration:' 5000',
            							message: result.msg,
            							type : 'success'
        							});
                                    
                                }
                                else if(result.Status == 'Failure'){
                                    toastEvent.setParams({
            							mode: 'dismissible',
                                        duration:' 5000',
            							message: result.msg,
            							type : 'error'
        							});
                                    
                                }
                                else{
                                    toastEvent.setParams({
            							mode: 'dismissible',
                                        duration:' 5000',
            							message: result.msg,
            							type : 'info'
        							});    
                                }
                                
                                toastEvent.fire();
                            }
            
        });
		
	},
    executeApex: function(component, method, params, callback){
        var action = component.get("c."+method);
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                callback.call(this, null, response.getReturnValue());
            } else if(state === "ERROR") {
                var errors = [];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message){
                        errors.push(item.message);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    closeCmp : function(component,event){
        console.log('in destroy');
        component.destroy();
        
    }
})