({
	doInit : function(component, event, helper) {
        console.log('isReadOnly ---->> '+component.get("v.isReadOnly"));
        helper.setFieldData(component);
        if (component.get("v.shouldBeDisable") == true  && component.get("v.OppObj").StageName != 'Post Approval Sales') {
            helper.disableObligationForm(component, event, helper);
        }
    },
    processToDisbursal : function(component, event, helper) {
        if(component.get("v.stpNonStp") == "STP") { // 3rd July 2019 Needhi - Adhoc S
            console.log('if');
            helper.isCPVDone(component);
        } else {
            console.log('else -->');
            helper.processToDisbursal(component , event);
        } // 3rd July 2019 Needhi - Adhoc E
	},
    enableObligationForm : function(component, event, helper) {
        helper.enableObligationForm(component , event); //AP 17664 
    },
})