({
	doInit : function(component, event, helper) {
        helper.doInit(component);
	},
    googleCheck : function(component, event, helper) {
        helper.googleCheck(component, event, helper);
        helper.doInit(component);
	},
    saveData : function(component, event, helper) {
    	 helper.saveData(component);
    },
    resultchanged : function(component, event, helper) {
		var appId= event.currentTarget.id;
        var Ele = document.getElementById(appId+"_nonPositiveResult").
        console.log(Ele.innerHTML);
        Ele.getElementsByTagName('select');
        Ele.disabled = true;
	},
    closeCustomToast: function(component, event, helper){
        helper.closeToast(component);
    },
    showSpinner: function(component, event, helper){
        helper.showSpinner(component);
    },
    hideSpinner: function(component, event, helper){
        helper.hideSpinner(component);
    }
})