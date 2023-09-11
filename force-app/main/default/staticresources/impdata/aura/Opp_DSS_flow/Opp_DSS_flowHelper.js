({
    activateTab: function(component, tabId) {
        
        $A.util.removeClass(component.find("loanTab"), "slds-active");
        $A.util.removeClass(component.find("documentTab"), "slds-active"); 
        $A.util.removeClass(component.find("ActionTab"), "slds-active");
        $A.util.addClass(component.find(tabId), "slds-active");
        
        this.showHideDiv(component, "loanTabContent", false);
        this.showHideDiv(component, "documentTabContent", false);
        this.showHideDiv(component, "ActionTabContent", false);
        this.showHideDiv(component, tabId+"Content", true);
    },
    showHideDiv: function(component, divId, show){
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    }
})