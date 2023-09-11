({	
   GetStatus: function(component) {
		//alert(component.get("v.recordId"));
        // console.log(component.get("v.recordId"));
        this.executeApex(component,"GetRequestStatus", {
            
            "taskid" : component.get("v.recordId"),           
        },function(error, result) {
            if(!error && result) {
                
                if(result!='' || result!= null)
                {
                    if(result=='Request Not Found')
                    {
                    component.set("v.StatusVal", 'Request not found/merged with other Id.');   
                    }
                    else
                    {
                      component.set("v.StatusVal", 'Status of Current request is '+result);
                    }
                    
                   
                }
                //var customToast = component.find("customToast");
                //$A.util.removeClass(customToast,"slds-hide");  
              
            }
           
        });
    },
    executeApex: function(component, method, params, callback){
        var action = component.get("c."+method); 
        action.setParams(params);
        //console.log(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
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
     showHideDiv: function(component, divId, show){
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
    closeToast: function(component){
        this.showHideDiv(component, "customToast", false);       
    },

})