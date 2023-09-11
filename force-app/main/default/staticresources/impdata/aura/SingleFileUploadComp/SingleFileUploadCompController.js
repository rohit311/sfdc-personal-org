({
    init: function(component, event, helper) {
    	if(component.get("v.fileName") !=undefined && component.get("v.fileName") !='' && component.get("v.fileName") != null){
    		component.find("file-name").set("v.value", component.get("v.fileName"));
    		if(component.get("v.fileName") != "No file chosen")
    		component.set("v.isUploaded",true);
    		else
    		component.set("v.isUploaded",false);
    	}
    	else{
    		component.set("v.isUploaded",false);
    	}
    },
    
    markRed : function(component, event, helper) {
    },
    
    onFileSelect : function(component, event, helper) {
        $A.util.removeClass(component.find("previewBlock"), 'slds-hide');
        helper.preview(component,event);
    },
    save : function(component, event, helper) {
    	component.set("v.allowUpload", "false");
        helper.save(component);
    },
    reset : function(component, event, helper) {
        helper.reset(component);
    },
    
    doUpload : function(component, event, helper) {
        helper.doUpload(component);
    },
    showOfferData: function(component, event, helper){
        helper.setOfferData(component, event);
    },
})