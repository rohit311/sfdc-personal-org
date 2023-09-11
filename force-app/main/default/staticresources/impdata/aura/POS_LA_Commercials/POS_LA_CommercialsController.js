({
    doinit:function (component,event,helper) {
    	if(component.get("v.shouldBeDisable") == true && component.get("v.OppObj").StageName != 'Post Approval Sales')
        	helper.disableForm(component);
        component.set("v.account",component.get("v.childAccount"));
        
    },
    
	validatePF : function(component, event, helper) {
        console.log(component.find("approvedPf").get("v.value"));
        component.set("v.OppObj.Processing_Fees__c", (''+component.get("v.OppObj.Processing_Fees__c")).replace(/[a-zA-z]/g, ''));
       	if(component.get("v.OppObj.Processing_Fees__c")){
            var flatPf;
            if(component.get("v.productOffering.Bonds_Value__c"))
            	flatPf = parseFloat(component.get("v.productOffering.Bonds_Value__c"));
            else
                flatPf = 0;
            //14213 S
            // US : 23080
           /* if(component.get("v.stpNonStp") == 'STP'){
             helper.addRemoveInputError(component, "approvedPf", parseFloat(component.get("v.OppObj.Processing_Fees__c")) < flatPf && "Approved PF can not be lower than Base Rate");
            } */
        }
         
    },
    validateROI : function(component, event, helper) {
        component.set("v.OppObj.Approved_Rate__c", (''+component.get("v.OppObj.Approved_Rate__c")).replace(/[a-zA-z]/g, ''));
       	if(component.get("v.OppObj.Approved_Rate__c")){
            var flatRoi;
            if(component.get("v.productOffering.Revised_Offer_ROI__c"))
            	flatRoi = parseFloat(component.get("v.productOffering.Revised_Offer_ROI__c"));
            else
                flatRoi = 0;
             //14213 S
            // US : 23080
           /* if(component.get("v.stpNonStp") == 'STP'){
            helper.addRemoveInputError(component, "approvedRoi", parseFloat(component.get("v.OppObj.Approved_Rate__c")) < flatRoi && "Approved ROI can not be lower than Base Rate");

            } */
       }
         
	},
    validateInsurance : function(component, event, helper) {
        component.set("v.account.Approved_Insurance__c", (''+component.get("v.account.Approved_Insurance__c")).replace(/[a-zA-z]/g, ''));
        if(component.get("v.account.Approved_Insurance__c")){
            var flatInsurance = 0 ;
            if(component.get("v.productOffering.Shares_value__c"))
            	flatInsurance = parseFloat(component.get("v.productOffering.Shares_value__c"));
            else
                flatInsurance = 0;
             //14213 S
            // US : 23080
           /* if(component.get("v.stpNonStp") == 'STP'){
             helper.addRemoveInputError(component, "approvedInsurance", parseFloat(component.get("v.account.Approved_Insurance__c")) < flatInsurance && "Approved Insurance can not be lower than Base Rate");

            } */
        }
	},
    saveDetails : function(component, event, helper) {
        if(helper.validateCommercialTab(component)){
            
                      
      /*//  var selectedSkills = $('[id$=picklist]').select2("val");
        var values = '';
        for(var i=0;i< selectedSkills.length;i++){
            values = values+ selectedSkills[i]+';';
         }
            
       component.set("v.account.VAS__c",values);*/
            
         	helper.SaveCommercial(component, event, helper);
        }
	},
    onRecordUpdated:function (component,event,helper) {
        
        var changeType = event.getParams().changeType;
		console.log(component.get("v.OppObj.EMI_CAM__c"));
        if (changeType === "ERROR") { /* handle error; do this first! */ }
        else if (changeType === "LOADED") {  }
        else if (changeType === "REMOVED") { /* handle record removal */ }
        else if (changeType === "CHANGED") { /* handle record change */ }

        

    },
    disableCommercialForm : function (component,event,helper) {
        console.log('==YK==>> '+event.getParam("loanStage"));
        if(event.getParam("loanStage") == 'Branch Ops' || event.getParam("loanStage") == 'Moved To Finnone') {
            helper.disableForm(component,event);
        }
    },
    disableFrom : function (component,event,helper) {
  		helper.disableForm(component,event);
    }
})