({
	activateTab: function(component, tabId) {
		if(tabId !== "customerTab" && !component.get("v.isSubmitted")){
            var infoEvent = $A.get("e.force:showToast");
            if(infoEvent != undefined){
                infoEvent.setParams({
                    "title": "Info : ",
                    "message": "Please save customer details to access documents and disposition tab.",
                    "type" : "info",
                    "mode" : "dismissible",
                	"duration" : "5000"
                });
                infoEvent.fire();
            } else {
                var customToast = component.find("customToast");
                $A.util.removeClass(customToast,"slds-hide");
            }
        } else {
            $A.util.removeClass(component.find("customerTab"), "slds-active");
            $A.util.removeClass(component.find("documentTab"), "slds-active");
            $A.util.removeClass(component.find("dispositionTab"), "slds-active");
            $A.util.addClass(component.find(tabId), "slds-active");
            
            this.showHideDiv(component, "customerTabContent", false);
            this.showHideDiv(component, "documentTabContent", false);
            this.showHideDiv(component, "dispositionTabContent", false);
            this.showHideDiv(component, tabId+"Content", true);
        }
	}, 
    setSubmitted: function(component, event){
		component.set("v.isSubmitted", true);
    },
    closeToast: function(component){
        this.showHideDiv(component, "customToast", false);
    },
    showHideDiv: function(component, divId, show){
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    }
})