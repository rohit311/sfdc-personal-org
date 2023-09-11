({
    doInit : function(component, event, helper) {
        var oppId = component.get("v.oppId");
        var fetchFinnoneRecordAction = component.get("c.getFinnoneDetails");
        fetchFinnoneRecordAction.setParams({"loanId":oppId});
        fetchFinnoneRecordAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var response = JSON.parse(response.getReturnValue() );
                component.find("loanRecordHandler").reloadRecord(true, function(){
                    component.set('v.finnoneRecordId', response.finnoneId);
                    component.find("finnoneRecordHandler").reloadRecord();
                });
            }
        });
        $A.enqueueAction(fetchFinnoneRecordAction);
    },
})