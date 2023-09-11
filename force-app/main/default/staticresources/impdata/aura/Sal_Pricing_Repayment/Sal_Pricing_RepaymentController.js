({
	editRecord : function(component, event, helper) {
        helper.editRecord(component, event);
	},
    addNewRecord : function(component, event, helper) {
        helper.addRecord(component, event);
	},
    addNewRecordNew : function(component, event, helper) {
        helper.addRecordNew(component, event);
	},
    handleUpdateRepay : function(component, event, helper){
        helper.handleUpdateRepay(component, event);
    },
    deleteRecord : function(component, event, helper){
        helper.deleteRecord(component, event);
    },
    callECS : function(component, event, helper){
    	helper.callECS(component, event);
    },
    
    //Bug:20391 changes Start (Handle visiblity of initiate Open ECS)
    doInit : function(component, event, helper) {
        console.log('Repaylist****'+JSON.stringify(component.get('v.repayList')));
         console.log('bankAccount****'+JSON.stringify(component.get('v.bankAccount')))
        var prodLabel = $A.get("$Label.c.Top_Up_Unsecured_Products");
        //console.log('dsdsd'+component.get("v.loan").Id+prodLabel);
        console.log(" ---> ",component.get('v.loan'));
        if(prodLabel && !$A.util.isEmpty(component.get('v.loan'))){
            if(prodLabel.toUpperCase().split(';').includes((component.get('v.loan.Product__c')).toUpperCase())){
                console.log("in if");
                component.set('v.isValidProduct',true);
            }
        }
        
        /*** start : fetching repayment data ***/
        //added for temp purpose to avoid null conditions in controllers /START
        var accountValidate = ["IMPS_Account_Validate__c"];
        var selectListNameMap = {};
        selectListNameMap["Current_Disbursal_Details__c"] = accountValidate;
        //added for temp purpose to avoid null conditions in controllers /END
        
        var action = component.get("c.fetchData");
        action.setParams({"loanAppId": component.get("v.loanId"),
                          "objectFieldJSON" : JSON.stringify(selectListNameMap)
                         });
        action.setCallback(this, function( res){
            /*this.executeApex(component, 'fetchData', {
            "loanAppId": "0060k000006spfK",
            "objectFieldJSON" : JSON.stringify()
        },function(error, result){
            if(!error && result){
                if(!$A.util.isEmpty(result))
                {*/
            if (res.getReturnValue()){
                var dataObj = JSON.parse(res.getReturnValue());
                component.set("v.repayList",dataObj.repayList);
            }
        });
        $A.enqueueAction(action);
        /**** END : Fetching repayment data *******/
    },
    //Bug:20391 Changes End
   
})