({
	getPickListVals : function(component) {
		var action = component.get("c.getPicklistValues");
        var feesAndChargeList = ["Deducted_from_Disbursement__c"];
        var selectListNameMap = {};
        selectListNameMap["Fees_and_Charge__c"] = feesAndChargeList;
        action.setParams({ objectFieldJSON : JSON.stringify(selectListNameMap) });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response) {
                var responseStr = JSON.parse(response.getReturnValue());
                var picklistFields = responseStr;
                var fnCPickFields = picklistFields["Fees_and_Charge__c"];

                component.set("v.dedFrmDisList",fnCPickFields["Deducted_from_Disbursement__c"]);
            }
            else if (state === "ERROR") 
            {
                var errors = response.getError();
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        console.log("Error message: " +errors[0].message);
                    }
                    else{
                        console.log("unknown error");
                    }
                }
            }
        });
        $A.enqueueAction(action);
	}
})