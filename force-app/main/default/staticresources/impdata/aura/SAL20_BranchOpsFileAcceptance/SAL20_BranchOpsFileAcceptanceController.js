({
	doInit : function(component, event, helper) {
        helper.doInitHandler(component, event, helper);
	},
    
    onProductSegmentChange : function(component,event,helper){
        try{
            var getloanTypeValues = component.get("c.getTypeofLoan");
            getloanTypeValues.setParams({productSegment: component.get("v.loanRecord.Loan_Type__c")} );
            getloanTypeValues.setCallback(this, function(response){
                if (response.getReturnValue()){
                    var optsLT = [];    optsLT.push({ label: '--None--', value: null });
                    var optsLoanType =  response.getReturnValue();
                    if (optsLoanType){
                        for (var i = 0; i < optsLoanType.length; i++){ 
                            if (optsLoanType[i]){
                                optsLT.push({
                                            label: optsLoanType[i],
                                            value: optsLoanType[i]
                                            });
                             }
                         }
                    }
                    component.set("v.optionsLoanType",optsLT);
                }
            });
            $A.enqueueAction(getloanTypeValues);
        }
        catch(err){
            console.log('Error when changing product segment');
        }
    },
    
    onSave : function(component,event,helper){
        component.set("v.isProcessing",true);
        
        var utility = component.find("toastCmp");
        
        var scheme = '';
        if(component.get('v.schemeSelected')){
        	scheme = component.get('v.schemeSelected');
        }
        else if(component.get("v.lookupCleared")== 'false'){
            scheme = component.get("v.loanRecord.Scheme_Master__c");
        }
        component.set("v.loanRecord.Scheme_Master__c",scheme);

        if(component.get("v.loanRecord.Loan_Type__c") && component.get("v.loanRecord.Type_Of_Loan__c"))
        {
            try
            {
                var saveaAction = component.get("c.saveLoan");
                saveaAction.setParams({loanData: component.get("v.loanRecord")} );
                saveaAction.setCallback(this, function(response){
                    if(response.getReturnValue()=='Success')
                    {
                        utility.showToast('Success!', 'Record Saved successfully' , 'success');
                    }
                    else
                    {
                        utility.showToast('Error!', response.getReturnValue(), 'error'); //Bug 23273
                    }
                    component.set("v.isProcessing",false );
                });
                $A.enqueueAction(saveaAction);
            }
            catch(err)
            {
                console.log('Error in saving record');
                component.set("v.isProcessing",false );
            }
        }
        else{
          utility.showToast('Error!', 'Please enter all required values', 'error');
          component.set("v.isProcessing",false );
        }
    },
    
})