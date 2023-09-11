({
    doinitToFetchCibilandDeDupe : function(component, event, helper){
        var LAid = component.get('v.oppId');
        var action = component.get('c.getApplicantData');
        action.setParams({
            loanApplicationId : LAid 
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS')
            {
                var jsonData = JSON.parse(response.getReturnValue());
                component.set('v.primaryApplicant',jsonData.applicantPrimary);
                component.set('v.cam',jsonData.camObj);
                component.set('v.cibil',jsonData.cibil);
                component.set('v.dedupe',jsonData.dedupeObj);
                component.set('v.cibilExt1',jsonData.cibilExt1);
                component.set('v.cibilTempObj',jsonData.cibilTempObj);
                component.set('v.theme',jsonData.theme);
                component.set('v.isCommunityUsr',jsonData.isCommunityUsr);
                if(component.get('v.cibilExt1.Number_of_Hl_Loans__c') == 0 || component.get('v.cibilExt1.Number_of_Hl_Loans__c') == null)
                    component.set('v.HLEver', 'No');
                else
                    component.set('v.HLEver', 'Yes');
            }
            else if(state == 'ERROR')
                console.log('Error while creating Contact Record!!');
        });
        $A.enqueueAction(action);
    }
 })