({
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called when component is initialized. 
    * 						Fires e.force:showToast if available.
    * 						Displays custom toast message if e.force:showToast is not available.
    *   @version		: 	1.0
    */
    doInit : function(component, event, helper) {        
        // Get all attribute values
        var message = component.get("v.message");
        var type = component.get("v.type");
        var title = component.get("v.title");
        
        // Get reference to e.force:showToast
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent) {
            // Fire e.force:showToast event if available
            toastEvent.setParams({
                "title" : title,
                "message" : message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : component.get("v.fadeTimeout")
            });
            toastEvent.fire();
        } else {
            // Create custom toast message using CSS if e.force:showToast event is not available
            var customToast = component.find("customToast");
            $A.util.addClass(customToast, "customContainer");
            $A.util.removeClass(customToast, "slds-hide");
            var toastTheme = component.find("toastTheme");
            $A.util.removeClass(toastTheme, "slds-theme--error");
            $A.util.removeClass(toastTheme, "slds-theme--success");
            if(type == "error") {
                $A.util.addClass(toastTheme, "slds-theme--error");
            } else 
                if(type == "success") {
                    $A.util.addClass(toastTheme, "slds-theme--success");
                } else 
					if(type == "warning") {
						$A.util.addClass(toastTheme, "slds-theme--warning");
					}
            component.find("toastText").set("v.value", message);
            component.find("toastTitle").set("v.value", title + " ");
        }
	},
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called when toast message is closed.
    *   @version		: 	1.0
    */
    closeCustomToast : function(component, event, helper) {
        // Hide toast message using CSS
        var customToast = component.find("customToast");
        $A.util.removeClass(customToast, "customContainer");
        $A.util.addClass(customToast, "slds-hide");
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme, "slds-theme--error");
        $A.util.removeClass(toastTheme, "slds-theme--success");
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called component is rendered.
    *   @version		: 	1.0
    */
    doneRendering : function(component, event, helper) {
        // Destroy component after fadeTimeout if isAutoClose is true
        window.setTimeout($A.getCallback(function() {
            if(component.isValid()) {
                if(component.get("v.isAutoClose")) {
                	component.destroy();    
                }
            }
        }), component.get("v.fadeTimeout"));
    },
})