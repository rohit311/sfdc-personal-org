({
	showToast: function(component, title, message, type){
        var toastEvent = $A.get("e.force:showToast");
			//alert('toastEvent'+toastEvent);
		console.log('toastEvent -->', toastEvent);
        if(toastEvent){
            console.log('in toast std');
            toastEvent.setParams({ 
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "3000"
            });    
            toastEvent.fire();
        } 
        else 
        {
        
        console.log('show toast of custom toast mobility in helper');
            var toastTheme = component.find("toastTheme");
            $A.util.removeClass(toastTheme, "slds-theme--error");
            $A.util.removeClass(toastTheme, "slds-theme--success");
            $A.util.removeClass(toastTheme, "slds-theme--info");

            if(type == 'error')
            {
                $A.util.addClass(toastTheme, "slds-theme--error");
                component.find("messageicon").set("v.iconName","utility:error");
            }
            else if(type == 'success')
            {
                $A.util.addClass(toastTheme, "slds-theme--success");
                component.find("messageicon").set("v.iconName","utility:success");
            }
            else if(type == 'info')
            {
                $A.util.addClass(toastTheme, "slds-theme--info");
                component.find("messageicon").set("v.iconName","utility:info");
            }
            component.find("toastText").set("v.value", message);
            component.find("toastTtitle").set("v.value", title+'! ');
            this.showHideDiv(component, "customToast", true);
            window.setTimeout($A.getCallback(function() {
                var customToast = component.find("customToast");
                $A.util.addClass(customToast, "slds-hide");
                $A.util.removeClass(customToast,"slds-show");
            }),3000 );
        }
    },
    showHideDiv: function(component, divId, show){
		$A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
		$A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
	},
    closeToast: function(component){
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme, "slds-theme--error");
        $A.util.removeClass(toastTheme, "slds-theme--success");
        $A.util.removeClass(toastTheme, "slds-theme--info");
        this.showHideDiv(component, "customToast", false);
    },
})