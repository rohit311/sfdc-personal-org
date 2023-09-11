({
	subscribetoFFR : function (component,event) {
		console.log('hello');
         component.set("v.showspinnerflag",true);
        this.executeApex(component, "subscribeFFR", {
            jsonappobj : JSON.stringify([component.get("v.applicantObj")]),
            jsonconobj : JSON.stringify([component.get("v.contObj")]),
			loanId :component.get("v.oppId")
           
		}, function (error, result) {
            console.log('inside leadexecute' + result);
			if (!error && result) {
				console.log('inside leadexecute' + result);
                var data = JSON.parse(result);
                console.log(data);
                var app = component.get("v.applicantObj");
                app.Subscribed_to_Credit_Vidya__c = data.applicantPrimary.Subscribed_to_Credit_Vidya__c;
                app.Financial_Health_Check_Guide__c = data.applicantPrimary.Financial_Health_Check_Guide__c;
                app.Refferal_Identifier__c = data.applicantPrimary.Refferal_Identifier__c;
                
                component.set("v.applicantObj",app);
                var cont = component.get("v.contObj");
                cont.Stamp_Duty__c = data.contPrimary.Stamp_Duty__c;
                component.set("v.contObj",cont);
                
               component.set("v.showspinnerflag",false);
                this.displayMessage(component, 'SuccessToastfees', 'successmsgfees', 'Success! Saved Successfully');
			} 
            else
              this.displayMessage(component, 'ErrorToastfees', 'errormsgfees', 'Fail! Failed To Save Data');
              
            component.set("v.showspinnerflag",false);
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
				//this.showToast(component, "Error!", errors.join(", "), "error");
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
		document.getElementById('successmsgfees').innerHTML = "";
		document.getElementById('SuccessToastfees').style.display = "none";
	},
	closeToastError: function (component) {
		document.getElementById('errormsgfees').innerHTML = "";
		document.getElementById('ErrorToastfees').style.display = "none";
	},
	
})