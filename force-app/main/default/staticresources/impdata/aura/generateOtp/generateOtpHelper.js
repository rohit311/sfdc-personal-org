({
    submitOTP: function(component,event) {
        console.log('inside helper submit otp'+component.get("v.parentId"));
        if(!$A.util.isEmpty(component.get("v.parentId")))
        this.executeApex(component, 'updateOtp', {
            "otpValue" :component.get("v.otpValue"),
            "parentId" : component.get("v.parentId")
        }, function (error, result) {
            if (!error && result) {
                component.set("v.oldotpValue", result);
            }
        });
        else
            console.log('hi');
    }, 
    generateOTP : function(component,event)
    {
         console.log('inside generateOTP helper');
        this.executeApex(component, 'generateOtp', {
            "mobilenumber" : component.get("v.phonenumber")
        }, function (error, result) {
            if (!error && result) {
                component.set("v.oldotpValue", result);
             this.displayToastMessage(component,event,'Success','OTP sent to your mobile successfully','success');

            }
            else
             this.displayToastMessage(component,event,'Error','Failed to regenerate OTP','error');
        });    
    },
    executeApex: function (component, method, params, callback) {
        var action = component.get("c." + method);
        action.setParams(params);
        console.log('calling method' + method);
        action.setCallback(this, function (response) {
            var state = response.getState();
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
                this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    displayToastMessage:function(component,event,title,message,type)
    {//added for bug id 22018/24962 start
        	 var toastEvent = $A.get("e.force:showToast");
		if(toastEvent){
           // alert('in toast std');
            toastEvent.setParams({ 
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "3000"
            });    
            toastEvent.fire();
        } else{
            //added for bug id 22018/24962 stop
        //alert('inside displayToastMessage'+message+type);
        var showhideevent =  $A.get("e.c:ShowCustomToast");
		showhideevent.setParams({
			"title": title,
            "message":message,
            "type":type
		});
		showhideevent.fire();
    }
    }
})