({
	  getData : function(component,event){
        var oppId = component.get("v.OppId");
         // alert('Opp id '+component.get("v.OppId"));
        if(oppId != null){
            this.executeApex(component, "getLACardData", {
                "oppId" : oppId
            }, function (error, result) {
                
                if (!error && result) { 
                    console.log('result '+result);
                    var objlst = JSON.parse(result);
                    component.set("v.oppObj",objlst.opp);
                }          
            });
        }
    },
      executeApex : function(component, method, params,callback){
        
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
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
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
})