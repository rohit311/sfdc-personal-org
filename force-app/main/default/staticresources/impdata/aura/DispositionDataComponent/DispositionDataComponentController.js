({
    handleOnload: function (component, event, helper) {
        var fieldDispositionValue = component.find("fieldDisposition").get("v.value");
        component.set("v.fieldDispositionValue",fieldDispositionValue);
        helper.handleRequiredField(component,event);
        component.set("v.spinnerFlag","false");
    },
    onDispChange : function(component,event,helper){
        component.set("v.fieldDispositionValue", component.find("fieldDisposition").get("v.value"));
        helper.handleRequiredField(component,event);
       
    },
    handleSubmit: function (component, event, helper) {
      helper.handleSubmitFunc(component,event);
    },
    handleSuccess: function (component, event, helper) {
      helper.handleSuccessFunc(component,event);
    },
    handleError: function (component, event, helper) {
      helper.handleErrorFunc(component,event);
    },
    closeDispositionModal: function(component,event,helper) {
        component.set('v.isOpen',false);
        
    },
    openDispositionModal: function(component,event,helper) {
        component.set('v.isOpen',true);
        component.set("v.spinnerFlag","true");
    }
})