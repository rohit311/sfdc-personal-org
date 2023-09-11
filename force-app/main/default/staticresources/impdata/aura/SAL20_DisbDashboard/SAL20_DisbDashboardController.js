({
	onInit : function(component, event, helper) {
        console.log("do init SAL20");
        var surogateselectList = ["Line_opted__c"];
        var purposeOfLoan  = ["Purpose_of_Facility__c","Preffered_Mode_to_Connect__c"];
         var verSelectList = ["Status__c","Sales_Status__c"];
        var accountValidate = ["IMPS_Account_Validate__c"];
        var selectListNameMap = {};
        selectListNameMap["SurrogateCAM__c"] = surogateselectList;
        selectListNameMap["Account"] = purposeOfLoan;
        selectListNameMap["Verification__c"] = verSelectList;
        selectListNameMap["Current_Disbursal_Details__c"] = accountValidate;
        var action = component.get("c.fetchData");

        action.setParams({"loanAppId": component.get("v.recordId"),
            			"objectFieldJSON" : JSON.stringify(selectListNameMap)
                         });
        
        action.setCallback(this, function( res){

            if (res.getReturnValue())
            {
                    var dataObj = JSON.parse(res.getReturnValue());
                    console.log("dataObj"+JSON.stringify(dataObj));
                    component.set("v.disbList",dataObj.disburement);
                    console.log("disbList"+JSON.stringify(dataObj.disburement));
                    component.set("v.record",dataObj.opp);
                	component.set("v.repayList",dataObj.repayList);
                	component.set("v.userProfile",dataObj.myProflieName);
                	component.set("v.sanctionList",dataObj.sanctionList);
                    component.set("v.existingDisList",dataObj.existingDisList);
                    component.set("v.Applicant",dataObj.applicantPrimary);//DMS 24317
                	var picklistFields = dataObj.picklistData;
                	var disbPickFlds = picklistFields["Current_Disbursal_Details__c"];
                	component.set('v.accntValidateList',disbPickFlds["IMPS_Account_Validate__c"]);
            }
        });
        $A.enqueueAction(action);
        
        
        helper.getPickListVals(component);
	},
})