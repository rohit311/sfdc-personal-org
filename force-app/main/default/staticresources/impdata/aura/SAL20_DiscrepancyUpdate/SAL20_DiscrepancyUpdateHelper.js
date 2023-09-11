({
    showToast : function(component, title, message, type){
        var self = this;
        console.log(self);
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "3000"
            });    
            toastEvent.fire();
        }
        else{
            var customToast = component.find('customToast');
            $A.util.removeClass(customToast, 'slds-hide');
            var toastTheme = component.find("toastTheme");
            $A.util.removeClass(toastTheme,"slds-theme--error");
            $A.util.removeClass(toastTheme,"slds-theme--success");
            if(type == 'error'){
                $A.util.addClass(toastTheme,"slds-theme--error");
            }
            else if(type == 'success'){
                $A.util.addClass(toastTheme,"slds-theme--success");
            }
            component.find("toastText").set("v.value", message);
            component.find("toastTtitle").set("v.value", title+' ');
            
            setTimeout($A.getCallback(() => this.closeToast(component)), 3000);
        }
    },
    closeToast : function(component){
        var customToast = component.find("customToast");
        $A.util.addClass(customToast,"slds-hide");
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme,"slds-theme--error");
        $A.util.removeClass(toastTheme,"slds-theme--success");
    },
    handleCallbackResponse : function(component, res, successMsg, errorMsg){
        let state = res.getState();
        console.log(state);
        if (state === "SUCCESS") {
            // Process server success response
            if ( !res.getReturnValue().startsWith('FAILURE')){ 
                var response = JSON.parse(res.getReturnValue() );
                console.log(response);
                component.set("v.attributeWrapperObj" , response);
                if(successMsg)
                    this.showToast(component,'Success!', successMsg, 'success');
            }else{
                console.log(res.getReturnValue());
                if(errorMsg)
                    this.showToast(component,'Error!', errorMsg+' \n '+res.getReturnValue(), 'error');
            }
        }
        else if (state === "ERROR") {
            // Process error returned by server
            if(errorMsg)
                this.showToast(component,'Error!', errorMsg, 'error');
        }
    }
})