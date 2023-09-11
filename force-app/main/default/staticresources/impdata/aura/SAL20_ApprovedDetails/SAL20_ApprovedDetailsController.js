({
	doInit : function(component, event, helper) 
    {
        helper.doInitHandler(component, event, helper);
	},
    
    calculateDroplinePeriod : function(component, event, helper)
    {
        var tenor; 
        var pureFlexiPeriod = component.get('v.applicantRecord.Pure_Flexi_Period__c');
        var dropLineFlexi  = component.get('v.applicantRecord.Drop_Line_Flexi_Period__c');
        var loanProduct = component.get('v.loanRecord.Product__c');
        var profile = component.get('v.profileName');

        var tenor=component.get('v.loanRecord.Approved_Tenor__c');
        var temp = tenor - pureFlexiPeriod;
   		component.set('v.applicantRecord.Drop_Line_Flexi_Period__c',temp);
    },
    
    onSave : function(component, event, helper) 
    {
        var utility = component.find("toastCmp");
        
        component.set("v.isProcessing", true);
        var returnMessage = helper.onSaveHandler(component,event,helper);
        if(returnMessage)
        {
        	utility.showToast('Error!', returnMessage , 'error'); 
            component.set("v.isProcessing", false);
        }
		else
        {
            component.find("loanRecordHandler").saveRecord($A.getCallback(function(saveResult) {
            
                var loanAmount = component.get('v.loanRecord.Loan_Amount_with_Premium__c');
                var pureFlexiPeriod = component.get('v.applicantRecord.Pure_Flexi_Period__c');
                var dropLineFlexi  = component.get('v.applicantRecord.Drop_Line_Flexi_Period__c');
                var approvedRate = component.get('v.loanRecord.Approved_Rate__c');
                var approvedTenor = component.get('v.loanRecord.Approved_Tenor__c');
                
                if(component.get('v.loanRecord'))
                {
                    if(component.get('v.applicantRecord') && component.get('v.IsHybridFlexi'))
                    {
                        var result= 0.0;
                        if(loanAmount && pureFlexiPeriod && approvedRate){
                            result = Math.round((loanAmount * approvedRate) / 1200);
                            console.log('result-->'+result);
                        }
                        component.set('v.applicantRecord.Pure_Flexi_EMI__c',result);
                        if(loanAmount && approvedRate)
                        {
                            var loanEMI = helper.calculate(parseFloat(approvedRate / 1200), parseInt(dropLineFlexi), loanAmount);
                            component.set('v.loanRecord.EMI_CAM__c',loanEMI);
                        }
                    }
                    else
                    {
                        if(loanAmount && approvedTenor && approvedRate)
                        {
                            var loanEMI = helper.calculate(parseFloat(approvedRate / 1200), parseInt(approvedTenor), loanAmount);
                            component.set('v.loanRecord.EMI_CAM__c',loanEMI);
                        }
                    }
                } 
                if (saveResult.state === "SUCCESS"){
                    component.find("applicantRecordHandler").saveRecord($A.getCallback(function(saveResult1) {
                        if (saveResult1.state === "SUCCESS" || saveResult1.state === "DRAFT") {
                            utility.showToast('Success!', 'Record Saved Successfully!!' , 'success');
                        } else{
                            console.log('Error while saving record****');
                        }
                    }));
                } 
                component.set("v.isProcessing", false);
            }));
        }
	},
    
})