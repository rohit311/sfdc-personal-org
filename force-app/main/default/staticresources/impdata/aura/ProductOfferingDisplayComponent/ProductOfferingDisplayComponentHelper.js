({
	 generateOTPhelper : function(component,event,phonenumber)
    {     
        console.log('befor modal : '+component.find("graboffermodal"));
        $A.util.removeClass(component.find("graboffermodal"), "slds-hide");
        $A.util.addClass(component.find("graboffermodal"), "slds-show");
        //var phonenumber = component.get("v.item.Lead__r.Customer_Mobile__c");
       console.log('inside generateOTP helper'+phonenumber);
        this.executeApex(component, 'generateOtp', {
            "mobilenumber" : phonenumber,"poId" : component.get("v.poID") //20939
        }, function (error, result) {
            if (!error && result) {
                component.set("v.oldotpValue", result);
                 var appEvent = $A.get("e.c:setOtp");
                 var productofferid = component.get("v.poID");
              if(appEvent){
                  appEvent.setParams({ "Otpvalue" : result,"poId" : productofferid});
                  appEvent.fire();
              }
            }
        });    
       /* var phonenumber = component.get("v.item.Lead__r.Customer_Mobile__c");
        var evt = $A.get("e.c:Open_OTP");
        evt.setParams({
            "phone" : phonenumber,
        });
        evt.fire();*/
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
    clickViewOffer : function(component, event, helper) {
        this.showhidespinner(component,event,true);
        var productofferid = event.getSource().get('v.value');
        console.log('inside clickviewoffer'+productofferid);
        var evt = $A.get("e.c:navigateToParent");
        evt.setParams({
            "showgrabcomp" : false,
            "productOfferingId": productofferid
        });
        evt.fire();
        component.destroy();
        /*console.log('testtt'+event.getSource().get('v.value'));
        var evt = $A.get("e.c:SetPOId");
        evt.setParams({
            "productOfferingId" : event.getSource().get('v.value')
        });
        evt.fire();
        component.destroy();*/
    },
    assign2telecaller : function(component, event, helper) {
        var productofferid = event.getSource().get('v.value');
        console.log('inside assignTelecaller'+productofferid);
             var evt = $A.get("e.c:SetPOId");
                evt.setParams({
                    "productOfferingId": productofferid,
                     "assigntotelecaller":true,
                    "graboffer":false
                });
                evt.fire();
        this.executeApex(component, 'assignToTelecaller', {
            "productofferid" : productofferid
        }, function (error, result) {
            if (!error && result) {
                
            }
        });  
        this.displayToastMessage(component,event,'Success','PO is Assigned to Tele-Caller','success');

       
    },
    changeOwnerOfPOFunction: function(component, event, helper) {
        var buttonid = component.get("v.poID");
        console.log('myId '+buttonid);
        $A.util.addClass(component.find(buttonid), "slds-hide"); 
         component.set("v.showgraboffer",true);
             var evt = $A.get("e.c:SetPOId");
                evt.setParams({
                    "productOfferingId": buttonid,
                     "assigntotelecaller":false,
                    "graboffer":true
                });
                evt.fire();
        this.executeApex(component, 'changeOwnerFunction', {
            "productofferid" : buttonid
        }, function (error, result) {
            if (!error && result) {
               
            }
        });    
       this.showhidespinner(component,event,false);
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
    }  
        
})