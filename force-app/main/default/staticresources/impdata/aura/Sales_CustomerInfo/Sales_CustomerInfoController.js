({
	doInit : function(component, event, helper) {
		console.log('in child');
        var weakAcc = component.get("v.WeakAccn");
        var appObj = component.get("v.applObj");
        //helper.setData(component, event);
        console.log('inside '+weakAcc+'---'+appObj);
         
	},
    showmodal :function(component, event, helper) {
        var modalname = component.find("backendModal");
        $A.util.removeClass(modalname, "slds-hide");
        $A.util.addClass(modalname, "slds-show");
        component.set('v.isModal',true);
    },
    onClose :function(component, event, helper) {
        var modalname = component.find("backendModal");
        $A.util.addClass(modalname, "slds-hide");
        $A.util.removeClass(modalname, "slds-show");
         component.set('v.isModal',false);
    },
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
   },
    hideSpinner : function(component,event,helper){
       component.set("v.Spinner", false);
    }
})