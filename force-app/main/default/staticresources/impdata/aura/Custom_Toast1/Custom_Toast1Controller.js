({
    showCustomToast : function(component, event, helper) {
        console.log('in old');
       var title =  event.getParam("title");
       var message =  event.getParam("message");
       var type =  event.getParam("type");
        var hideDiv =  false;
        hideDiv = event.getParam("hideDiv");
        component.set("v.hideDiv", hideDiv);
        console.log('inside showCustomToast'+message+type);
        var customToast = component.find('customToast');
        $A.util.removeClass(customToast, 'slds-hide');
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme,"slds-theme--error");
        $A.util.removeClass(toastTheme,"slds-theme--success");
        $A.util.removeClass(toastTheme,"slds-theme--info");
        if(type == 'error'){
            $A.util.addClass(toastTheme,"slds-theme--error");
            component.find("messageicon").set("v.iconName","utility:error");
        }
        else if(type == 'success'){
            $A.util.addClass(toastTheme,"slds-theme--success");
             component.find("messageicon").set("v.iconName","utility:success");
        }
        else if(type == 'info'){
            $A.util.addClass(toastTheme,"slds-theme--info");
             component.find("messageicon").set("v.iconName","utility:info");
        }
        component.find("toastText").set("v.value", message);
        component.find("toastTtitle").set("v.value", title+' ! ');	
        window.setTimeout($A.getCallback(function() {
             console.log('inside settimeout function');
            var customToast = component.find("customToast");
             $A.util.addClass(customToast, "slds-hide");
              $A.util.removeClass(customToast,"slds-show");
        }),4000 );
        /* window.setTimeout($A.getCallback(function() {
             console.log('inside settimeout function');
            if(component.isValid()) {
                if(component.get("v.isAutoClose")) {
                    component.destroy();    
                }
            }
        }), component.get("v.fadeTimeout"));*/
    },
    closeCustomToast : function(component, event, helper){
        var customToast = component.find("customToast");
        $A.util.addClass(customToast,"slds-hide");
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme,"slds-theme--error");
        $A.util.removeClass(toastTheme,"slds-theme--success");
    },
	showToast :  function(component,event,helper) {
        console.log('in new');
       helper.showToast(component, event.getParam("title"), event.getParam("message"), event.getParam("type"));
    },
    closeCustomToastN: function(component, event, helper){
        helper.closeToast(component);
    }    
})