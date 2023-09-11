({
    getdata : function(component, event) {
        console.log('in callVerificationAPI');
        var action = component.get('c.getCardData');
       
        action.setParams({
            "oppId" : component.get('v.oppId')
            
        });
        action.setCallback(this, function(response){
            //this.hideSpinner(component);
            var state = response.getState();
            if (state == "SUCCESS") {
                console.log('success');
                var data = JSON.parse(response.getReturnValue());
                console.log(data); 
                
                component.set('v.primaryApplicant',data.applicantPrimary);
                component.set('v.loan',data.opp);
                component.set('v.accObj',data.accObj);
                component.set('v.applicantObj',data.applicantPrimary);
                if (!$A.util.isEmpty(data.accObj) && !$A.util.isEmpty(data.accObj.Employer__c)) {
                    var employerSearchKeyword = data.accObj.Employer__r.Name;
                    if (employerSearchKeyword.toUpperCase() == 'COMPANY NOT LISTED' || employerSearchKeyword.toUpperCase() == 'OTHER' || employerSearchKeyword.toUpperCase() == 'OTHERS') {
                        component.set("v.isOther", true);
                    }
                }
            }
            else
                alert('error');
            // this.displayMessage(component, 'displayErrorToast', 'displayErrorMsg', '<b>Error!</b>,Error while processing!');
        });
        $A.enqueueAction(action);
        
    }
})