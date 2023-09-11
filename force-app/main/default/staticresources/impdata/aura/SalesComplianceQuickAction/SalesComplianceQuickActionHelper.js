({
	executeApex: function(component, method, params,callback){
        console.log('params'+JSON.stringify(params));
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            console.log('in execute apex');
            var state = response.getState();
            if(state === "SUCCESS"){
                callback.call(this, null, response.getReturnValue());
            } else if(state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message){
                        errors.push(item.message);
                    }
                }
                //this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
})