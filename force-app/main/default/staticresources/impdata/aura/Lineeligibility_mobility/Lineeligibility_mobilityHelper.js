({
   
	 savedetails : function (component,event) {
        component.set("v.showspinnerflag",true);
		console.log('hello');
	     this.executeApex(component, "updatesurrogate", {
			scamobj : JSON.stringify([component.get("v.scam")])
		}, function (error, result) {
			if (!error && result) {
				console.log('inside leadexecute' + result);
                component.set("v.scam",result);
                component.set("v.showspinnerflag",false);
                this.displayMessage(component, 'SuccessToast1', 'successmsg1', 'Success! Saved Successfully');
			} 
            else
            {   component.set("v.showspinnerflag",false);
                this.displayMessage(component, 'ErrorToast', 'errormsg', 'Fail! Failed To Save Data');
            }
            
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
				callback.call(this, errors, response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	},
    displayMessage: function (component, toastid, messageid, message) {
        document.getElementById(toastid).style.display = "block";
		document.getElementById(messageid).innerHTML = message;
        console.log('message'+message);
		
		setTimeout(function () {
			document.getElementById(messageid).innerHTML = "";
			document.getElementById(toastid).style.display = "none";
		}, 5000);
	},
    closeToastnew: function (component) {
		document.getElementById('successmsg1').innerHTML = "";
		document.getElementById('SuccessToast1').style.display = "none";
	},
	closeToastError: function (component) {
		document.getElementById('errormsg').innerHTML = "";
		document.getElementById('ErrorToast').style.display = "none";
	},
   
})