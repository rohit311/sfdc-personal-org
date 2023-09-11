({
	executeApex: function(component, method, params,callback){
        console.log('params'+JSON.stringify(params));
        var action = component.get("c."+method);
        console.log('calling utility method ');
        action.setParams(params);
        console.log('called required utility method ');
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('response.getState() '+ response.getState());
            if(state === "SUCCESS"){
                console.log('response.getReturnValue()123'+response.getReturnValue());
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
    officeemailverify : function(component, event) {
        this.executeApex(component, "verifyOtp",{"contObj" : JSON.stringify(component.get("v.contObj")), "applicantObj" :  JSON.stringify(component.get("v.applicantObj")), "otpValue" : component.get("v.otpValue")} , function (error, result) {
            console.log('result : ' + result);
            if (!error && result) {
                if(result == 'success'){
                    this.displayToastMessage(component,event,'Success','OTP validated successfully','success');
                    var app = component.get("v.applicantObj");
                    app.Office_Email_Id_Verified__c = true;
                    component.set("v.applicantObj",app);
                }
                else{
                    this.displayToastMessage(component,event,'Error','OTP did not match','error');
                }
                
            }
            this.showhidespinner(component,event,false);
            
        });
        
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
        console.log('inside displayToastMessage'+message+type);
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    },

})