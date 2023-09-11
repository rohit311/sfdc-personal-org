({
    doInit: function(component, event, helper) {
        // As per logged in user fetch COQM object
        try {
            console.log('1 here -->');
            helper.fetchLoggedInUserDetails(component, event, helper);
        } catch (e) {
            console.log('Something went wrong in doinit --> ', e);
        }

    },
    handleSaveRecord: function(component, event, helper) {
        try {
            console.log('2 here -->');
            helper.saveRecord(component);
        } catch (e) {
            console.log('Something went wrong in save record --> ', e);
        }
    },
    getApp: function(component, event, helper) {
        try {
            console.log('3 here -->');
            helper.getAppHelper(component);
        } catch (e) {
            console.log('Something went wrong in get loan application --> ', e);
        }
    },
    closeCustomToast: function(component, event, helper) {
        helper.closeToast(component);
    },
    onChangeValue: function(component, event, helper) {
        var selectedA = component.find("a_Select").get("v.value");
        console.log('selectedA ------->> ' + selectedA);
        if (selectedA != '--Select--') {
            component.set("v.coqmObj.isAvailable__c", selectedA);
        } else {
            component.set("v.coqmObj.isAvailable__c", selectedA);
        }
    },
})