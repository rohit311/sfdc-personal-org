({
	
    executeApex: function(component, method, params, callback){
        var action = component.get("c."+method); 
        action.setParams(params);
      //  component.set("v.spinnerFlag","true");
        action.setCallback(this, function(response) {
      //      component.set("v.spinnerFlag","false");
            var state = response.getState();
            if(state === "SUCCESS"){
                callback.call(this, null, response.getReturnValue());
            } else if(state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message){
                        errors.push(item.message);
                    }
                }
                this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    saveDiscrepancies : function(component) {
        console.log('updated discrepancylist'+ component.get("v.DiscrepancyObj[0].Resolution_Remarks__c"));
		this.executeApex(component, "saveDiscrepanciesctrl", {
            "loanId": component.get("v.loanId"),
            "updatedDiscrepancyList":component.get("v.DiscrepancyObj")
        }, function(error, result){  
            if(!error && result){
                console.log('updateDescription'+result);
                component.set("v.DiscrepancyObj",result)
                this.showToast(component,'success:	','Discrepancies updated Successfully !','success');                             
            }
           
        });
		
	},
        showToast: function(component, title, message, type){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({ 
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "30000"
            });    
            toastEvent.fire();
        } else {
            var toastTheme = component.find("toastTheme");
            $A.util.removeClass(toastTheme, "slds-theme--error");
            $A.util.removeClass(toastTheme, "slds-theme--success");
            if(type == 'error'){
                $A.util.addClass(toastTheme, "slds-theme--error");
            } else if(type == 'success'){
                $A.util.addClass(toastTheme, "slds-theme--success");
            }
            component.find("toastText").set("v.value", message);
            component.find("toastTtitle").set("v.value", title+' ');
            this.showHideDiv(component, "customToast", true);
        }
    },
    closeToast: function(component){
        console.log('inside close toast');
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme, "slds-theme--error");
        $A.util.removeClass(toastTheme, "slds-theme--success");
        this.showHideDiv(component, "customToast", false);
    },
     showHideDiv: function(component, divId, show){
         console.log('first time');
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
    
    
    
    
})