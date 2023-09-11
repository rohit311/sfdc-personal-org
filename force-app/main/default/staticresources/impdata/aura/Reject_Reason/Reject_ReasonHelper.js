({
    getRecord :function(component) {
        component.set("v.showSpinner",true);
        this.executeApex(component, "fetchRecord", {"loanId": component.get("v.LoanId")}, function(error, result) {
           component.set("v.showSpinner", false);
            if(!error && result){
                component.set("v.Opportunity",result);
                this.getPicklistValues(component);
            } 
        })
    },
	getPicklistValues : function(component) {
      
        console.log('inside getProducts -->');
        component.set("v.showSpinner",true);
        this.executeApex(component, "fetchPicklistValues", {"objDetail": component.get("v.Opportunity"),"fields":component.get("v.fields")}, function(error, result) {
           component.set("v.showSpinner", false);
            if(!error && result){
                 component.set('v.productOptions', result.Product__c.values);
                 component.set('v.CrossSellProductOptions',result.Products_for_cross_sell__c.values );
                 component.set('v.eligiblecrosssellOptions', result.Eligible_for_cross_sell__c.values);
                 component.set('v.mapRejectReasonOptions',result.Reject_Reason__c.dependentValueMap );
                 component.set('v.mapRejectReason1Options',result.Reject_Reason_1__c.dependentValueMap );
                 component.set('v.mapPicklists', result);
                 this.fieldChange(component);
              /*
                var multislect = component.find("rejectReason");
                if(multislect)
                multislect.setRejectReason(component.get("v.Opportunity.Reject_Reason__c"),'rejectReasonId');
             
                var crosssellproductcmp = component.find("crosssellproduct");
                if(crosssellproductcmp)
                crosssellproductcmp.setRejectReason(component.get("v.Opportunity.Products_for_cross_sell__c"),'crosssellproductId');
                */
                component.set("v.recordLoadFlag", true);  
               // component.find('recordHandler').reloadRecord(true) 
                component.set("v.showSpinner",false);
              
            }
        });
    },
    fieldChange: function(component) {
        var controllerValueKey =component.get("v.Opportunity.Product__c") // get selected controller field value
        var mapRejectReason1Options = component.get("v.mapRejectReason1Options");
        var mapRejectReasonOptions = component.get("v.mapRejectReasonOptions");
        if (controllerValueKey != '--- None ---') {
            component.set("v.bDisabledDependentFld" , false);  
            
            if(mapRejectReasonOptions[controllerValueKey])
                component.set("v.rejectReasonOptions" , mapRejectReasonOptions[controllerValueKey]); 
            else          
                component.set("v.rejectReasonOptions" , []);  
            
            if(mapRejectReason1Options[controllerValueKey])
                component.set("v.rejectReason1Options" , mapRejectReason1Options[controllerValueKey]); 
            else
                component.set("v.rejectReason1Options" , []);  
            
        } else {
            component.set("v.bDisabledDependentFld" , true);
        }
    },
    validateRecord :function(component){
        var opportunity= component.get("v.Opportunity");
        var products= $A.get("$Label.c.RejectReason1Products");
        var errorMsg='';
        
        if(!opportunity.Reject_Reason__c)
            errorMsg=errorMsg+" Reject Reason value is empty. Unable to continue.";
        if(!products.includes(opportunity.Product__c) && !opportunity.Reject_Reason_1__c)
           errorMsg=errorMsg+" Reject Reason 1 value is empty. Unable to continue.";
        if(!opportunity.Branch_Name__c)
            errorMsg=errorMsg+" Branch value is empty. Unable to continue.";
         if(!opportunity.Scheme_Master__c)
            errorMsg=errorMsg+" Scheme name cannot be blank.";
        if(errorMsg.length>4){
            this.showToast(component,"Error",errorMsg,"error")
            return false;
        }
        else
            return true;
    },
    saveData:function(component){
        debugger;
        component.set("v.showSpinner", true);
        this.executeApex(component, "saveRejectReasonDetails", {"objOpportunity": component.get("v.Opportunity"),GroupType:component.get("v.GroupType")}, function(error, result) {
            component.set("v.showSpinner", false);
            if(result && result.length>4)
                this.showToast(component,"Error",result,"error")
                else{
                    this.showToast(component,"Success","Reject reason details saved successfully.","success")
                    window.location.replace("/006/o");
                }
        })
        
    },
      showToast : function(component, title, message, type){
     
      var self = this;
        var toastEvent = $A.get("e.force:showToast");
          var timeoutForToast="3000"
          if(type=='error')
             timeoutForToast=  "10000"
        if(toastEvent){ //Standard toast message : if supports standard toast message
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : timeoutForToast
            });    
            toastEvent.fire();
        }else{ //Custom toast message : if doesn not support standard toast message
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
            
            setTimeout($A.getCallback(() => this.closeToast(component)), timeoutForToast); //Auto close custom toast message
        }

    },
    closeToast : function(component){ 
       
        var customToast = component.find("customToast");
        $A.util.addClass(customToast,"slds-hide");
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme,"slds-theme--error");
        $A.util.removeClass(toastTheme,"slds-theme--success");
    }, 
    executeApex: function(component, method, params, callback){
        var action = component.get("c."+method); 
        action.setParams(params);
        try {
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS"){
                    console.log('response.getReturnValue() --> ' + response.getReturnValue());
                    callback.call(this, null, response.getReturnValue());
                    
                } else if(state === "ERROR") {
                    var errors = ["Some error occured. Please try again. "];
                    var array = response.getError();
                    for(var i = 0; i < array.length; i++) {
                        var item = array[i];
                        if(item && item.message) {
                            errors.push(item.message);
                        }
                    }
                    callback.call(this, errors, response.getReturnValue());
                }
            });
            //this.showSpinner(component);
        } catch (errorInstance) {
            alert('Exception --> ' + errorInstance.message + ' stack --> ' + errorInstance.stack);
        }
        $A.enqueueAction(action);
    }
})