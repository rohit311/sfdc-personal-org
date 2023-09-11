({
    openModalPopup : function(component, event, helper) {
        //debugger;
        var jsonStr = event.getSource().get("v.value");//ctarget.dataset.value;
        jsonStr = JSON.parse(jsonStr);
        //console.log('jsonStr -->', jsonStr.objectName + jsonStr.refNum);
        component.set("v.objectName", jsonStr.objectName);
        component.set("v.refNum", jsonStr.refNum);
        component.set("v.identifier", jsonStr.identifier);
        //debugger;

        if (component.get("v.coqmObj").QueueValue__c != null && component.get("v.coqmObj").QueueValue__c != undefined && jsonStr.identifier == 'Queue') {
            // convert comma separated string into list and set attribute
            //console.log('inside if -->',(component.get("v.coqmObj").QueueValue__c).split(','));
            component.set("v.selectedData", (component.get("v.coqmObj").QueueValue__c).split(','));            
        }
        if (component.get("v.coqmObj").ExceptionQueueValue__c != null && component.get("v.coqmObj").ExceptionQueueValue__c != undefined  && jsonStr.identifier == 'ExceptionQueue') {
            // convert comma separated string into list and set attribute
            component.set("v.selectedData", (component.get("v.coqmObj").ExceptionQueueValue__c).split(','));            
        }

        
        //console.log('reached -->');
        component.set("v.isLoaded", true);
        var cmpTarget = component.find('customPopup');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
    },
    handleSaveRecord: function(component, event, helper) {
        component.find("COQMRecordLoader").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                // handle component related logic in event handler
                console.log("Record is saved successfully.");
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                
                console.log(saveResult.error);
                var errMsg = '';
                var errors = saveResult.error;
                if(errors[0] && errors[0].message) {// To show other type of exceptions
                    console.log('errors[0].message 00== >', errors[0].message);//component.set("v.message", errors[0].message);
                	errMsg = errors[0].message;
                }
                if(errors[0] && errors[0].pageErrors) {// To show DML exceptions
                    console.log('errors[0].message 11== >', errors[0].pageErrors[0].message);//component.set("v.message", errors[0].pageErrors[0].message);
                    errMsg = errors[0].pageErrors[0].message;
                }
                if (errMsg != '' && errMsg != undefined && errMsg != null) {
                    helper.showToast(component, "Message!", JSON.stringify(errMsg), "error");
                } else {
                    helper.showToast(component, "Message!", JSON.stringify(saveResult.error), "error");
                }
                console.log('identifier --> ' , component.get("v.identifier"));
                
                
                if (component.get("v.identifier") == 'ExceptionQueue') {
                    var v2 = component.get("v.oldExceptionQVal");
                    component.set("v.coqmObj.ExceptionQueueValue__c",v2);
                } else {
                    if (component.get("v.identifier") == 'Queue') {
                        var v1 = component.get("v.oldQueueValue");
                        component.set("v.coqmObj.QueueValue__c", v1);
                    }
                }
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));
    },
    handleRecordUpdated: function(component, event, helper) {
        console.log('rId -->' + component.get("v.recordId"));
        console.log('v.coqmObj -->', component.get("v.coqmObj"));
        
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
           // record is loaded (render other component which needs record data value)
            console.log("Record is loaded successfully.");
            component.set("v.isRecordLoaded", true);
            
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
            console.log('changed -->');
            component.find("COQMRecordLoader").reloadRecord();
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    },
    getEventSelectedValues: function(component, event, helper) {
        console.log('2 here -->');
        var valuesFromChild = event.getParam("selectedValuesList");
        var loadVal = event.getParam("isLoadDone");
        var lookupField = event.getParam("lookupField");
        
        console.log('valuesFromChild --> ', JSON.stringify(valuesFromChild));
        var finalData = [];
        //if (valuesFromChild != null && valuesFromChild != undefined && valuesFromChild.length > 0 ) {
            // convert comma separated string into list and set attribute
            for (var check in valuesFromChild) {
                console.log('valuesFromChild[i] -->', valuesFromChild[check]);
                //for (var index in valuesFromChild[check]) {
                    console.log('index --> ', valuesFromChild[check][lookupField]);
                    finalData.push((valuesFromChild[check][lookupField]).toUpperCase());
                //}
            }            
            console.log('finalData --------> ', finalData.join());
            console.log('inside valuesFromChild --> ', finalData.join());
            console.log('inside  --> ', component.get("v.identifier"));
            if (component.get("v.identifier") == 'Queue') {
                var v1 = component.get("v.coqmObj.QueueValue__c");
                component.set("v.oldQueueValue", v1);                
                component.set("v.coqmObj.QueueValue__c", finalData.join());                
                console.log('inside 2 --> ', component.get("v.coqmObj.QueueValue__c"));
            }
            if (component.get("v.identifier") == 'ExceptionQueue') {
                var v2 = component.get("v.coqmObj.ExceptionQueueValue__c");
                component.set("v.oldExceptionQVal", v2);
                component.set("v.coqmObj.ExceptionQueueValue__c", finalData.join());                
            }
            var saveMethod = component.get('c.handleSaveRecord');
        	$A.enqueueAction(saveMethod);

            component.set("v.isLoaded", loadVal);
        //}
    },
    closeModal : function(component, event, helper) {
        component.set("v.isLoaded", false);
    },
    closeCustomToast: function(component, event, helper){
        helper.closeToast(component);
    },
})