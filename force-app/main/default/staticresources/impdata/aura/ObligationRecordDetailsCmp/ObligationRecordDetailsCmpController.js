({
	doInit : function(component, event, helper) {
        helper.setFieldData(component);
	},
    
    handleSalMobFlowEventFired : function(component, event, helper) {
        console.log('loanAppID ------->> '+component.get("v.loanAppID"));
          helper.handleSalMobFlowEventHelper(component, event);
          
	},
    redirectToViewCibilReport : function (component, event, helper) {
        console.log(component.get("v.cibil.Id"));
        /*24997 added if else*/
        if(component.get("v.theme") == 'Theme4t')
            component.set("v.isViewReportModalOpen", true);
        else
            window.open('/apex/OTPOneViewCIBILpage?id=' + component.get("v.cibil.Id")+'&appId='+component.get("v.applicantObj.Id"),'_blank', 'toolbar=0,location=0,menubar=0');
    },
    closeModel : function (component, event, helper) {
    	component.set("v.isViewReportModalOpen", false);
        component.set("v.showcibilpopup",false );
    },
	redirectToOneViewCibilReport : function (component, event, helper) {
        if(component.get("v.theme") == 'Theme4t')
            component.set("v.isOneViewReportModalOpen", true);
        else
            window.open('/apex/DetailedCibilReportPage?id=' + component.get("v.cibil.Id"),'_blank', 'toolbar=0,location=0,menubar=0'); 
    },
    closeOneViewModel : function (component, event, helper) {
    	component.set("v.isOneViewReportModalOpen", false);
    }, 
    opencibilpopup: function (component, event, helper) {
        if(!$A.util.isEmpty(component.get("v.secondaryCibilRecs")))
    	   component.set("v.showcibilpopup",true );
    }, 
})