({
    doInit: function(component, event, helper) {
        helper.doinitToFetchCibilandDeDupe(component, event);      
    },
    fetchApplicant : function(component, event, helper) {
        var primaryApp = event.getParam("primaryApp");
        var dedupe = event.getParam("dedupe");
        var cibil = event.getParam("cibil");
        var cam = event.getParam("cam");
        var cibilExt1 = event.getParam("cibilExt1");
        var cibilTempObj = event.getParam("cibilTempObj");
        var maxEligibleLoanAmtMCP = event.getParam("maxEligibleLoanAmtMCP");
        component.set("v.primaryApplicant",primaryApp);
        component.set("v.dedupe",dedupe);
        component.set("v.cibil",cibil);
        component.set("v.cam",cam);
        component.set("v.cibilExt1",cibilExt1);
        component.set("v.cibilTempObj",cibilTempObj);
        component.set("v.maxEligibileLoanAmount",maxEligibleLoanAmtMCP);
        console.log('firing event');
        console.log('dpdddd>>>'+component.get("v.primaryApplicant.Cibil_Extension1s__r[0].Tradelines_30plus_DPD__c")+'>>maxEligibleLoanAmtMCP>>'+maxEligibleLoanAmtMCP);
    },
    redirectToViewCibilReport : function (component, event, helper) {
    	component.set("v.isViewReportModalOpen", true);
    },
    closeModel : function (component, event, helper) {
    	component.set("v.isViewReportModalOpen", false);
    },
	redirectToOneViewCibilReport : function (component, event, helper) {
    	component.set("v.isOneViewReportModalOpen", true);
    },
    closeOneViewModel : function (component, event, helper) {
    	component.set("v.isOneViewReportModalOpen", false);
    },    
})