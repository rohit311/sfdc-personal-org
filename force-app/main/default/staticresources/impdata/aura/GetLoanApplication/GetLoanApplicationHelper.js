({
    fetchLoggedInUserDetails: function(component, event, helper) {
        // initailize recordId
        var action = component.get("c.fetchLoggedInUserDetails");
        //console.log('inside getdatahelper -->');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                if (response.getReturnValue() == null) {
                    console.log('Something wrong !');
                    this.showToast(component, "Error!", 'You are not a credit user / data in queue is not maintained!', "error");
                    return;
                } else {
                    console.log('response -->', response.getReturnValue());
                    component.set("v.userInfo", response.getReturnValue().userInfo);
                    var strExceptionValue = response.getReturnValue().exceptionQValues;
                    if(strExceptionValue)
                        component.set("v.strExceptionQValues",strExceptionValue);
                    
                    component.set("v.coqmObj", response.getReturnValue().coqmObj);
                    // 23550 S
                   
                    this.getQDetails(component);
                    // 23550 E
                    if (component.get("v.coqmObj").isAvailable__c != 'No') {
                        component.set("v.isUpdated", true);
                    } else {
                        component.set("v.isUpdated", false);
                    }
                    component.set("v.availableValues", response.getReturnValue().availableValues);
                    component.set("v.areDetailsFetched", true);
                }
            } else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        this.showToast(component, "Error!", errors[0].message, "error"); // Bug Id : Concurrency Issue
                    }
                } else {
                    console.log("Unknown error");
                }
            } else {
                console.log('Something went wrong, Please check with your admin');
            }
        });
        $A.enqueueAction(action);
    },
    // 23550 S
	getQDetails: function(component) {
        
        var strExeptionQ = component.get("v.strExceptionQValues");	
        console.log('strExeptionQ' +strExeptionQ + '<--');
        var exceptionaction ;
        if(strExeptionQ)
        {
            console.log('Inside strExeptionQ loop');
            var exeptionQList = strExeptionQ.split(",");
            console.log('exeptionQList '+exeptionQList);
            var exceptionaction = component.get("c.fetchCaseDetails");
            exceptionaction.setParams({
                "qIDs": exeptionQList
            });
                exceptionaction.setCallback(this, function(response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    console.log('response.getReturnValue()'+JSON.stringify(response.getReturnValue()));
                    component.set("v.exceptionQDetails",response.getReturnValue());
                    console.log('v.exceptionQDetails'+component.get("v.exceptionQDetails"));
                }
                else if (state === 'ERROR') {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error while fetching Exception Queue names with Counts: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error while fetching Exception Queue names with Counts");
                    }
                } else {
                    console.log('Something went wrong while fetching Exception Queue names with Counts, Please check with your admin');
                }          
            });
            $A.enqueueAction(exceptionaction);
        }
        if(component.get("v.coqmObj.QueueValue__c"))
        {
            var qvalueList = component.get("v.coqmObj.QueueValue__c").split(",");
           // var ExqvalueList = component.get("v.coqmObj.ExceptionQueueValue__c").split(",");
            console.log('qvalueList'+qvalueList);
            var action = component.get("c.fetchCaseDetails");
            action.setParams({
                "qIDs": qvalueList            
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    console.log('response.getReturnValue()'+JSON.stringify(response.getReturnValue()));
                    component.set("v.QDetails",response.getReturnValue());
                    console.log('v.QDetails'+component.get("v.QDetails"));
                }
                else if (state === 'ERROR') {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error while fetching Queue names with Counts: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error while fetching Queue names with Counts");
                    }
                } else {
                    console.log('Something went wrong while fetching Queue names with Counts, Please check with your admin');
                }
                   
    
            });
            $A.enqueueAction(action);
    	}
        
    },
    // 23550 E
    saveRecord: function(component) {
        var action = component.get("c.saveCQOMRecord");
        //console.log('inside getdatahelper -->');
        action.setParams({
            "coqmObj": JSON.stringify(component.get("v.coqmObj"))
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                if (response.getReturnValue() == null || response.getReturnValue() != 'success') {
                    console.log('Something wrong !', response.getReturnValue());
                    this.showToast(component, "Message!", response.getReturnValue(), "error");
                    return;
                } else {
                    // show toast
                    this.showToast(component, "Message!", 'COQM record updated sucessfully!', "success");
                    if (component.get("v.coqmObj").isAvailable__c != 'No') {
                        component.set("v.isUpdated", true);
                    } else {
                        component.set("v.isUpdated", false);
                    }
                }
            } else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        this.showToast(component, "Message!", errors[0].message + ' !', "error");
                    }
                } else {
                    console.log("Unknown error");
                    this.showToast(component, "Message!", 'Unknown error !', "error");
                }
            } else {
                console.log('Something went wrong, Please check with your admin');
                this.showToast(component, "Message!", 'Something went wrong, Please check with your admin!', "error");
            }
        });
        $A.enqueueAction(action);
    },
    getAppHelper: function(component) {
        this.showSpinner(component);
        var action = component.get("c.getLoanApp");
        //console.log('inside getdatahelper -->');
        debugger;
        console.log('v.coqmObj -->' + JSON.stringify(component.get("v.coqmObj")));
        action.setParams({
            "coqmObj": JSON.stringify(component.get("v.coqmObj"))
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state -->', state);
            if (state === 'SUCCESS') {
                console.log('response.getReturnValue() -->', response.getReturnValue());
                console.log('error -->', response.error);
                if (response.getReturnValue() == undefined || response.getReturnValue() == null || response.getReturnValue() == 'failure') {
                    console.log('Something wrong !', response.getReturnValue());
                    //debugger;
                    this.hideSpinner(component);
                    this.showToast(component, "Message!", 'No Loan application found for assignment or you might have loan application in queue, kindly complete the same!', "error");
                    //return;
                } else {
                    // show toast
                    console.log('else response.getReturnValue() -->', response.getReturnValue());
                    try {
                        var resRec = JSON.parse(response.getReturnValue());
                        console.log('resRec opp -->', JSON.stringify(resRec.oppObj));
                        console.log('resRec cid -->', JSON.stringify(resRec.cId));
                        console.log('resRec coqm -->', JSON.stringify(resRec.coqmObj));
                        this.showSpinner(component);
                        if (resRec != undefined && resRec.oppObj != undefined && resRec.coqmObj != undefined && resRec.cId != undefined) {
                            debugger;
                            var action = component.get("c.invokeSubmitAppr");                        
                            action.setParams({
                                "oldestLA": JSON.stringify(resRec.oppObj), 
                                "colId": JSON.stringify(resRec.cId), 
                                "coqmRec": JSON.stringify(resRec.coqmObj)
                            });
                            action.setCallback(this, function(response) {
                                state = response.getState();
                                console.log('state 1  -->' , state);
                                debugger;
                                if (state === 'SUCCESS') {
                                    var resRec = JSON.parse(response.getReturnValue());
                                    if (resRec != undefined) {
                                        console.log('resRec -->', resRec.oppObj);
                                        if (resRec != undefined && resRec.oppObj != undefined)
                                            component.set("v.oppObj", resRec.oppObj);
                                        console.log('oppObj -->', component.get("v.oppObj"));
                                        if (resRec != undefined && resRec.coqmObj != undefined)
                                            component.set("v.coqmObj", resRec.coqmObj);
                                        //if(v != null && v.oppObj != null)
                                          // 23550 S
                                        this.getQDetails(component);
                                          // 23550 E
                                        this.showToast(component, "Message!", 'Loan Application ' + component.get("v.oppObj").Loan_Application_Number__c + ' is assigned sucessfully!', "success");
                                    }
                                } else if (state === 'ERROR') {
                                    var errors = response.getError();
                                    var action = component.get("c.unlockRecord"); // Bug Id : 25285 - Concurrency Issue start -unlock p2
                                    action.setParams({"coqmObj": JSON.stringify(component.get("v.coqmObj"))});
                                    action.setCallback(this, function(response) {
                                        var state = response.getState();
                                        console.log('State -->' , state);
                                        if(state === "SUCCESS"){}
                                        else if(state === "ERROR") {
                                            var errors = ["Some error occured. Please try again. "];
                                            var array = response.getError();
                                            for(var i = 0; i < array.length; i++){
                                                var item = array[i];
                                                if(item && item.message){
                                                    errors.push(item.message);
                                                }
                                            }
                                            this.showToast(component, "Error!", errors.join(", "), "error"); // Bug Id : 25285 - Concurrency Issue start -unlock p2
                                        }
                                    });
                                    $A.enqueueAction(action);// Bug Id : 25285 - Concurrency Issue end -unlock p2
                                    if (errors) {
                                        if (errors[0] && errors[0].message) {
                                            console.log("Error message: " + errors[0].message);
                                            this.showToast(component, "Message!", errors[0].message + ' !', "error");
                                        }
                                    } else {
                                        console.log("Unknown error");
                                        this.showToast(component, "Message!", 'Unknown error !', "error");
                                    }
                                }
                                this.hideSpinner(component);
                            });
                            $A.enqueueAction(action);
                        }
                        
                    } catch (e) {
                        this.hideSpinner(component);
                        this.showToast(component, "Message!", response.getReturnValue() + ' !', "error");
                    }
                }
            } else if (state === 'ERROR') {
                var errors = response.getError();
                var action = component.get("c.unlockRecord"); // Bug Id : 25285 - Concurrency Issue start -unlock p2
                action.setParams({"coqmObj": JSON.stringify(component.get("v.coqmObj"))});
				action.setCallback(this, function(response) {
                    var state = response.getState();
                    console.log('State -->' , state);
                    if(state === "SUCCESS"){}
                    else if(state === "ERROR") {
                        var errors = ["Some error occured. Please try again. "];
                        var array = response.getError();
                        for(var i = 0; i < array.length; i++){
                            var item = array[i];
                            if(item && item.message){
                                errors.push(item.message);
                            }
                        }
                        this.showToast(component, "Error!", errors.join(", "), "error"); // Bug Id : 25285 - Concurrency Issue start -unlock p2
                    }
                });
                $A.enqueueAction(action);// Bug Id : 25285 - Concurrency Issue end -unlock p2
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        this.hideSpinner(component);
                        this.showToast(component, "Message!", errors[0].message + ' !', "error");
                    }
                } else {
                    console.log("Unknown error");
                    this.hideSpinner(component);
                    this.showToast(component, "Message!", 'Unknown error !', "error");
                }
            } else {
                console.log('Something went wrong, Please check with your admin');
                this.hideSpinner(component);
                this.showToast(component, "Message!", 'Something went wrong, Please check with your admin!', "error");
            }            
        });
        $A.enqueueAction(action);
    },
    closeToast: function(component) {
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme, "slds-theme--error");
        $A.util.removeClass(toastTheme, "slds-theme--success");
        this.showHideDiv(component, "customToast", false);
    },
    showToast: function(component, title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type": type,
                "mode": "dismissible",
                "duration": "30000"
            });
            toastEvent.fire();
        } else {
            var toastTheme = component.find("toastTheme");
            $A.util.removeClass(toastTheme, "slds-theme--error");
            $A.util.removeClass(toastTheme, "slds-theme--success");
            if (type == 'error') {
                $A.util.addClass(toastTheme, "slds-theme--error");
            } else if (type == 'success') {
                $A.util.addClass(toastTheme, "slds-theme--success");
            }
            component.find("toastText").set("v.value", message);
            component.find("toastTtitle").set("v.value", title + ' ');
            this.showHideDiv(component, "customToast", true);
        }
    },
    showHideDiv: function(component, divId, show) {
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
    showSpinner: function(component) {
        this.showHideDiv(component, "waiting", true);
    },
    hideSpinner: function(component) {
        this.showHideDiv(component, "waiting", false);
    }
})