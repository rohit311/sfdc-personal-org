({
    goBack : function (component, event, helper){
        component.destroy();
        
    },
    saveRepay : function(component, event, helper){
        helper.saveRepay(component, event);
    },
    
    doInit : function(component, event, helper){
       // component.set(component.find('umrn').disabled,'true');
            component.set("v.disableSIFields",false);

        $A.util.addClass(component.find("ecs_barcode"), 'slds-has-error ');       
        
        $A.util.addClass(component.find("repay_mode"), 'slds-has-error ');       
        
        console.log('do init'+component.get("v.Ex_customer_id"));
         console.log('do init'+component.get("v.loanId"));
        helper.fetchData(component, event);
         
        window.setTimeout(
            $A.getCallback(function() {
                // $A.util.removeClass(component.find("repay_mode"), 'slds-scope ');       
                
                $A.util.addClass(component.find("repay_mode"), 'slds-has-error ');       
                //  $A.util.addClass(component.find("repay_mode"), 'slds-scope ');       
            }), 4000
        );
       helper.selectRepay(component, event);
    },
    beforeSave : function(component, event, helper){
        this.showhidespinner(component,event,true);
    },
    handleSuccess : function(component, event, helper){
        helper.handleSuccess(component,event);
    },
    ifscOnBlur : function(component, event, helper){
        helper.handleOnBlur(component, event, "IFSC_Code__c");
    },
    micrOnBlur : function(component, event, helper){
        helper.handleOnBlur(component, event, "MICR__c");
    },
    selectRepay : function(component, event, helper){
        helper.selectRepay(component, event);
    },
    handleOnLoad : function(component, event, helper){
        helper.handleOnLoad(component, event);
    },
    checkDuplicateBarcode:function(component, event, helper){
        helper.checkDuplicateBarcode(component, event);
    },
     //Added by swapnil
    HandleChangeECSFacility :  function(component, event, helper) {
        helper.HandleChangeECSFacility(component, event);
    }
    
})