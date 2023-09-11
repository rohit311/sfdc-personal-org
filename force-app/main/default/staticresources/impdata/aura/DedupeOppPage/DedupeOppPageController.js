({
	redirectToViewCibilReport : function (component, event, helper) {
        console.log(component.get("v.cibil.Id"));
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
    sectionOne : function(component, event, helper) {
      helper.displaySec(component,event,'articleOne');
    },
    doInit: function(component, event, helper) {
		var LANnumber = component.get("v.LANnumber");
        if (!$A.util.isEmpty(LANnumber)) {
        	helper.getoppDetailsonLAN(component, event);
        }
       
    }
})