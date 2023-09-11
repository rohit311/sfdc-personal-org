({
    updateidentifierhelper : function(component,eventName,oppId,appId)
    {
           //alert('inside update 3');
        console.log('inside updateidentifier helper');
        this.executeApex(component,'updateidentifierNew', {
            "eventName" : eventName,
            "oppId" : oppId,
            "appId" : appId
        }, function (error, result) {
            //alert(result);
           //alert('inside update 4');
            if (!error && result) {
            }
        });    
    },
    executeApex: function (component, method, params, callback) {
        var action = component.get("c." + method);
        action.setParams(params);
        console.log('calling method' + method);
        console.log('inside update 0'+action);
        action.setCallback(this, function (response) {
            var state = response.getState();
           // alert('inside update 5'+state);
            if (state === "SUCCESS") {
                console.log('response.getReturnValue()' + response.getReturnValue());
                callback.call(this, null, response.getReturnValue());
            } else if (state === "ERROR") {
                console.log('error');
                	console.log(response.getError());
                
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for (var i = 0; i < array.length; i++) {
                    var item = array[i];
                    if (item && item.message) {
                        errors.push(item.message);
                    }
                }
                console.log('calling method failed ' + method);
                //this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})