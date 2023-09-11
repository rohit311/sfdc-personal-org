({
	saveSanctionDiscDetailsHelper : function(component,event) {
        this.showhidespinner(component,event,true);
		this.executeApex(component, 'saveSanctionDetailsMethod', {
            "loanid" :component.get("v.loan.Id") , "JSONDiscrepancyList" :JSON.stringify(component.get("v.existingDisList"))
            
        },
                         
                         function (error, result) {
                             
                             if (!error && result) {
                                 this.displayToastMessage(component,event,'Success','Discrepancy details saved successfully','success');
                                 this.showhidespinner(component,event,false);
                                 if(!$A.util.isEmpty(result))
                                 {
                                     component.set("v.existingDisList",result);
                                     console.log('result is '+JSON.stringify(result));
                                     console.log(result);
                                 }
                             }
                             else{
                                 this.displayToastMessage(component,event,'error','Error in Saving','error');
                                 this.showhidespinner(component,event,false);
                             }
                             
                             
                         });	
	},
    executeApex: function(component, method, params,callback){
        
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
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },
    displayToastMessage:function(component,event,title,message,type)
    {
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    },
})