({
    goBack : function (component, event, helper){
        component.destroy();
    },
    cloneFromRepay : function(component, event, helper){
        helper.cloneFromRepayHelper(component, event);
    },
    makeFieldsEditable: function(component, event, helper){
        var sts = component.find("Repay_Disb_Diff__c").get("v.checked");
        //var sts= component.get("v.disb.Repay_Disb_Diff__c");
        //console.log('field val is '+component.get("v.disb").Disbursal_Mode__c);
        if(sts =='true' || sts == true)
        {
            //component.set("v.checkboxStatus",true);
            //component.find('Repay_Disb_Diff__c').set('v.disabled',true );
            component.find('ifscCode').set('v.disabled',false );
            component.find('bankName').set('v.disabled',false);
            component.find('favouring').set('v.disabled',false);
                        component.find('bankAccount').set('v.disabled',false);            //24315 line is same
 //24315s
        	var bank= component.get("v.bankAccount");
            if(bank!=null && (bank.Perfios_account_same_as_Salary_account__c==true))
            {
                                    component.find('bankAccount').set('v.disabled',true);
            }
            //24315e
            //component.set("v.checkboxStatus",false);

        }
        else{
			helper.cloneFromRepayHelper(component, event);
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
        
        //Bug 20391 : Bug 22062  : Handling disbursement amount validation : Start
        try{
            var isDisbDashboard = component.get("v.isDisbDashboard");
            if(isDisbDashboard){
                var allow_sum_Disbursement_Amount = component.get('v.allow_sum_Disbursement_Amount');
                var current_Disbursement_Amount = component.get('v.disb.Disbursement_Amount__c');
                if( allow_sum_Disbursement_Amount != null &&  current_Disbursement_Amount!=null ){
                    allow_sum_Disbursement_Amount = parseInt(allow_sum_Disbursement_Amount);
                    current_Disbursement_Amount = parseInt(current_Disbursement_Amount);
                    var diffAmt = allow_sum_Disbursement_Amount - current_Disbursement_Amount;
                    console.log('diffAmt : '+diffAmt);
                    if(diffAmt!=null && diffAmt!=undefined && diffAmt>=0){
                        //helper.displayToastMessage(component,event,'Error','Sum of all disbursement amount is not matching with actual Disbursed Loan Amount. Please check.','error');
                    }else{
                        helper.displayToastMessage(component,event,'Error','Sum of all disbursement amount is not matching with actual Disbursed Loan Amount. Please check.','error');
                        return;
                    }   
                }
            }
        }catch(e){console.log(e)}
        //Bug 20391 : Bug 22062  : Handling disbursement amount validation : End
        
        var selectedValue=component.find('disbursalMode').get("v.value");
        var isvalid = true
        var list = ["disbursalMode","favouring","bankName", "bankAccount","bankBranch","disbAmount","payableAt"];
        for (var i = 0; i < list.length; i++) {
            console.log(component.find(list[i]));
            if (component.find(list[i]) && !component.find(list[i]).get("v.validity").valid)
            {
                isvalid = false;
                component.find(list[i]).showHelpMessageIfInvalid();
            }
        }
        console.log('pk isvalid'+isvalid);
        if(!isvalid)
        {
            helper.displayToastMessage(component,event,'Error','Please Fill Mandatory Fields','error');
        }
        else
            helper.saveDisb(component, event);
            //helper.checkMandatoryFields(component,event);
    },
    doInit : function(component, event, helper){
        //console.log('opp is::'+component.get("v.opp"));
         //console.log('opp is1::'+component.get("v.opp").Scheme_Master__r.flexi_flag__c);
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
    /*handleSuccess : function(component, event, helper){
        helper.handleSuccess(component,event);
    },*/
    
    
    
    
})