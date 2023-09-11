({
	callPANBreHelper : function(component, event) {
        console.log('in final offer bre');
        console.log(JSON.stringify(component.get("v.priAppObj")));
        this.showhidespinner(component,event,true);
        this.executeApex(component, "callPANBreOnDemographic", {
            'oppObj': JSON.stringify(component.get("v.oppObj")),
            'accObj': JSON.stringify(component.get("v.account")),
            'conObj': JSON.stringify(component.get("v.contact")),
            'appObj': JSON.stringify(component.get("v.priAppObj")),
            'loanId': component.get("v.oppId")
        }, function (error, result) {
            console.log('result test: ' + result);
            if (!error && result) {
                console.log('result -->'+result);
                
                var objlst = JSON.parse(result);
                console.log('objlistr -->'+JSON.stringify(objlst));
                
                if(!$A.util.isEmpty(objlst))
                {
                    if(!$A.util.isEmpty(objlst.status))
                    {
                        if(objlst.status == 'PANBRE Done' || objlst.status == 'Success' )
                        {
                            this.showhidespinner(component,event,false);
                            this.displayToastMessage(component,event,'Success','PAN Check has already been done','success'); 
                        }
                        else{
                            this.showhidespinner(component,event,false);
                            console.log('hv + '+objlst.status);
                            if(objlst.status.includes('CIBIL And Dedupe response are not recived yet'))
                            {
                               this.displayToastMessage(component,event,'Pending',objlst.status,'error'); 
                            }
                            else
                            {
                               this.displayToastMessage(component,event,'Error',objlst.status,'error'); 
                            }
                            if(!$A.util.isEmpty(objlst.applicantPrimary))
                            {
                                component.set("v.priAppObj" , objlst.applicantPrimary);
                            }
                        }
                    }
                    
                    
                }
                
                
                
            }
            else{
                this.showhidespinner(component,event,false);
            }
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
    executeApex: function (component, method, params, callback) {
        var action = component.get("c." + method);
        action.setParams(params);
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state'+state);
            if (state === "SUCCESS") {
                console.log('response.getReturnValue()' + response.getReturnValue());
                callback.call(this, null, response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for (var i = 0; i < array.length; i++) {
                    var item = array[i];
                    if (item && item.message) {
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