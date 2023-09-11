({
    showCustomToast : function(component, event, helper) {
        var title =  event.getParam("title");
        var message =  event.getParam("message");
        var type =  event.getParam("type");
        var hideDiv =  false;
        hideDiv = event.getParam("hideDiv");
        component.set("v.hideDiv", hideDiv);
        
        var customToast = component.find('customToast');
        $A.util.removeClass(customToast, 'slds-hide');
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme,"slds-theme--error");
        $A.util.removeClass(toastTheme,"slds-theme--success");
        $A.util.removeClass(toastTheme,"slds-theme--info");
        if(type == 'error')
        {
            $A.util.addClass(toastTheme,"slds-theme--error");
            component.find("messageicon").set("v.iconName","utility:error");
        }
        else if(type == 'success')
        {
            $A.util.addClass(toastTheme,"slds-theme--success");
            component.find("messageicon").set("v.iconName","utility:success");
        }
        else if(type == 'info')
        {
            $A.util.addClass(toastTheme,"slds-theme--info");
            component.find("messageicon").set("v.iconName","utility:info");
        }
        component.find("toastText").set("v.value", message);
        component.find("toastTtitle").set("v.value", title+' ! ');	
        window.setTimeout($A.getCallback(function() {
            var customToast = component.find("customToast");
            $A.util.addClass(customToast, "slds-hide");
            $A.util.removeClass(customToast,"slds-show");
        }),3000 );
        
    },
    closeCustomToast : function(component, event, helper){
        var customToast = component.find("customToast");
        $A.util.addClass(customToast,"slds-hide");
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme,"slds-theme--error");
        $A.util.removeClass(toastTheme,"slds-theme--success");
    },
    showToast :  function(component,event,helper) {
        console.log('show toast of custom toast mobility in controller');
        helper.showToast(component, event.getParam("title"), event.getParam("message"), event.getParam("type"));
    },
    closeCustomToastN: function(component, event, helper){
        helper.closeToast(component);
    }    
})