({
    openModalPopup: function(component, event, helper) {
        var jsonStr = event.getSource().get("v.value");
        jsonStr = JSON.parse(jsonStr);
        component.set("v.objectName", jsonStr.objectName);
        component.set("v.refNum", jsonStr.refNum);
        component.set("v.identifier", jsonStr.identifier);

        if (component.get("v.qmObj").Location__c != null && component.get("v.qmObj").Location__c != undefined && jsonStr.identifier == 'Location') {
            component.set("v.selectedData", (component.get("v.qmObj").Location__c).split(','));
        }
        component.set("v.isLoaded", true);
        var cmpTarget = component.find('customPopup');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
    },
    handleSaveRecord: function(component, event, helper) {
        component.find("QMRecordLoader").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                // handle component related logic in event handler
                console.log("Record is saved successfully.", component.get("v.qmObj"));
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                console.log('identifier --> ', component.get("v.identifier"));
                
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
                
                if (component.get("v.identifier") == 'Location') {
                    var v1 = component.get("v.oldLocVal");
                    component.set("v.qmObj.Location__c", v1);
                }
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));
    },
    handleRecordUpdated: function(component, event, helper) {
        console.log('rId -->' + component.get("v.recordId"));
        console.log('v.coqmObj -->', component.get("v.qmObj"));

        var eventParams = event.getParams();
        if (eventParams.changeType === "LOADED") {
            // record is loaded (render other component which needs record data value)
            console.log("Record is loaded successfully.");
            component.set("v.isRecordLoaded", true);

        } else if (eventParams.changeType === "CHANGED") {
            // record is changed
            console.log('changed -->');
            component.find("QMRecordLoader").reloadRecord();
        } else if (eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if (eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    },
    getEventSelectedValues: function(component, event, helper) {
        console.log('2 here -->');
        var valuesFromChild = event.getParam("selectedValuesList");
        var loadVal = event.getParam("isLoadDone");
        var lookupField = event.getParam("lookupField");

        console.log('valuesFromChild --> ', JSON.stringify(valuesFromChild));
        console.log('lookupField --> ', lookupField);
        var finalData = [];
        for (var check in valuesFromChild) {
            console.log('valuesFromChild[i] -->', valuesFromChild[check]);
            //for (var index in valuesFromChild[check]) {
                var d = valuesFromChild[check];
                console.log('d --> ', d[lookupField]);
                finalData.push(d[lookupField].toUpperCase());
            //}
        }
        if (component.get("v.identifier") == 'Location') {
            var v1 = component.get("v.qmObj.Location__c");
            component.set("v.oldLocVal", v1);
            component.set("v.qmObj.Location__c", finalData.join());
            console.log('inside 2 --> ', component.get("v.qmObj.Location__c"));
        }
        var saveMethod = component.get('c.handleSaveRecord');
        $A.enqueueAction(saveMethod);

        component.set("v.isLoaded", loadVal);

    },
    closeModal: function(component, event, helper) {
        component.set("v.isLoaded", false);
    },
    closeCustomToast: function(component, event, helper) {
        helper.closeToast(component);
    },
})