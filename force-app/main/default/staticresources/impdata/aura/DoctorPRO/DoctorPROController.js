({
	menuItemClick: function(component, event, helper){ 
        helper.activateTab(component, event.target.getAttribute('id'));
    },
    enableDocAndDispos : function(component, event, helper){
        helper.setSubmitted(component, event);
    },
    gotoNextTab: function(component, event, helper){
        helper.activateTab(component, event.getParam('tabId'));
    },
    closeCustomToast : function(component, event, helper){
        helper.closeToast(component);
    }
})