({
	doInit : function(component, event, helper) 
    {
        try
        {            
            var utility = component.find("toastCmp");
            var action = component.get("c.fetchLineDetails");
            action.setParams({"loanId": component.get('v.oppId')});
            action.setCallback(this, function( res){
                if ('FAILURE' != res.getReturnValue())
                {
                    /*** START : Refresh the existing record, if we have line details id ***/
                    var oId = component.get("v.oppId");
                    if(oId !== undefined || oId !== '')
                    {
                        component.find("loanRecordHandler").reloadRecord(true, function(){
                        });
                    }
                    /*** END   : Refresh the existing record, if we have line details id ***/
                    
                    
                    var response = JSON.parse(res.getReturnValue() );                    
                    component.set('v.lineDetailRecordId', response.lineDetailId);
                    component.set('v.mortgageFlag', response.MortgageFlag);
                    component.set('v.profileName', response.ProfileName);
                    
                    if(!response.lineDetailId)
                    {
                        component.find("lineDetailRecordHandler").getNewRecord(
                            "SurrogateCAM__c", // sObject type (objectApiName)
                            null,      // recordTypeId
                            false,     // skip cache?
                            $A.getCallback(function() {
                                var rec = component.get("v.lineDetailTargetRecord");
                                var error = component.get("v.lineDetailRecordError");
                                if(error || (rec === null)) {
                                    return;
                                }
                                helper.housekeepingstuffs(component, event, helper, response);
                            })
                        );
                    }
                    else
                    {
                        /*** START : Refresh the existing record, if we have line details id ***/
                        var lineDetailsId = component.get("v.lineDetailRecordId");
                        if(lineDetailsId !== undefined || lineDetailsId !== '')
                        {
                            component.find("lineDetailRecordHandler").reloadRecord(true, function(){
                                helper.housekeepingstuffs(component, event, helper, response);
                            });
                        }
                        /*** END   : Refresh the existing record, if we have line details id ***/
                    }
                    
                }
                else{
                    utility.showToast('Error!', 'Something went wrong! Please check with your administrator!' , 'error');
                }
            });
            $A.enqueueAction(action);
        }catch(err){
			console.log('Exception occurred while fetching data');                
        }
	},
    
    onSave : function(component,event,helper)
    {
        component.set("v.isProcessing", true);
        try
        {
            var utility = component.find("toastCmp");
            var oppId = component.get("v.oppId");
            var lineOptedValue = component.get("v.lineDetailRecord.Line_opted__c");
            var creditAssessmentValue = component.get("v.lineDetailRecord.Line_assigned_basis_Credit_Assessment__c");
            var feesPaidValue = component.get("v.lineDetailRecord.Fees_Paid__c");
            var lineExpiryValue = component.get("v.lineDetailRecord.Expiry_Date_without_BT__c");

            if((creditAssessmentValue) && creditAssessmentValue>0)
            {
                if(lineOptedValue =='YES' && feesPaidValue == 'YES'){
                    component.set("v.lineDetailRecord.Line_Active_Flag__c", 'YES');
                }
                else{
                    if(component.get('v.lineDetailRecord.risk_category__c') == 'High'){
                        component.set("v.lineDetailRecord.Line_Active_Flag__c", 'NO');
                    }
                }                
            }
            if(lineOptedValue =='NO')
            {
                var fetchFeesAction = component.get("c.fetchFees");
                fetchFeesAction.setParams({"loanId":oppId});
                fetchFeesAction.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                    }
                    else{
                        console.log('Error deleting fees n charges****');
                    }
                });
                $A.enqueueAction(fetchFeesAction);
            }
            
            if(lineOptedValue =='YES')
            {
                var fetchFeesRecAction = component.get("c.fetchFeesRecord");
                fetchFeesRecAction.setParams({"loanId":oppId,
                                              "creditAssessment" : creditAssessmentValue,
                                              "loanProduct" : component.get('v.loanRecord.Product__c')
                                             });
                fetchFeesRecAction.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var lineCharges = response.getReturnValue();
                        if(lineCharges > 0){
                            component.set("v.lineDetailRecord.Fee_Amount__c", lineCharges);    
                        }
                    }
                    else{
                        console.log('Error inserting fees n charges****');
                    }
                });
                $A.enqueueAction(fetchFeesRecAction);
            }
            
            //Bug 21305 --S--- Moved save first If to Here
            component.set("v.lineDetailRecord.Loan_Application__c", component.get("v.oppId"));
            component.find("lineDetailRecordHandler").saveRecord($A.getCallback(function (saveResult) {
                if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                    utility.showToast('Success!', 'Record Saved Successfully!' , 'success');
                } else if (saveResult.state === "INCOMPLETE") {
                    console.log("User is offline, device doesn't support drafts.");
                } else if (saveResult.state === "ERROR") {
                    console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                } else {
                    console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                }
                component.set("v.isProcessing", false);
            }));
            //Bug 21305 --E---
        }
        catch(err){
			console.log('Exception occurred while saving data');
            component.set("v.isProcessing", false);
        }
    },
    
})