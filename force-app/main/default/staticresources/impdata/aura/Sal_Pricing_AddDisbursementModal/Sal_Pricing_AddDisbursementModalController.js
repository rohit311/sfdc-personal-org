({
    goBack : function (component, event, helper){
        component.destroy();
    },
    cloneFromRepay : function(component, event, helper){
        helper.cloneFromRepayHelper(component, event);
    },
    makeFieldsEditable: function(component, event, helper){
        var sts=''+JSON.stringify(component.get("v.checkboxStatus"));
        if(sts =='true')
        {
        helper.cloneFromRepayHelper(component, event);
        component.set("v.checkboxStatus",false);

        }
        else{
		component.set("v.checkboxStatus",true);
                    component.find('Repay_Disb_Diff__c').set('v.disabled',true );
              component.find('ifscCode').set('v.disabled',false );
            component.find('bankName').set('v.disabled',false);
            component.find('favouring').set('v.disabled',false);
            component.find('bankAccount').set('v.disabled',false);
        }
        /*  var diff=''+JSON.stringify(component.get("v.checkboxStatus"));
        console.log('diff value is'+diff);
        if(diff == 'true'){
            component.find('ifscCode').set('v.disabled',false );
            component.find('bankName').set('v.disabled',false);
            component.find('favouring').set('v.disabled',false);
            component.find('bankAccount').set('v.disabled',false);
            component.set("v.checkboxStatus",false); //by default, not checked and fields diabled
        }
        else{
            component.set("v.checkboxStatus",true); 
           // component.find('ifscCode').set('v.disabled',true );
           // component.find('bankName').set('v.disabled',true);
           // component.find('favouring').set('v.disabled',true);
           // component.find('bankAccount').set('v.disabled',true);
            helper.cloneFromRepayHelper(component, event);
        }
        */
        
        
    },
    displayMandatoryFields: function(component, event, helper){
        console.log('in displayMandatory');
        helper.markMandatoryFieldsRed(component,event);
    },
    saveDisbursement : function(component, event, helper){
        
        var selectedValue=component.find('disbursalMode').get("v.value");
        if(selectedValue=="")
        {
            helper.displayToastMessage(component,event,'Error','Please Enter Disbursal Mode','error');
        }
        else
            helper.checkMandatoryFields(component,event);
    },
    doInit : function(component, event, helper){
        helper.fetchData(component, event);
        
        
    },
    fetchData : function(component, event, helper){
        helper.fetchData(component, event);
        
    },
    
    ifscOnBlur : function(component, event, helper){
        console.log('in ifscOnBlur');
        
        helper.handleOnBlur(component, event, "IFSC_Code__c");
    },
    
    beforeSave : function(component, event, helper){
        this.showhidespinner(component,event,true);
    },
    handleSuccess : function(component, event, helper){
        helper.handleSuccess(component,event);
    },
    
    
    
    
})