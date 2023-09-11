({
    doInit : function(component, event, helper){
        var bankObj = component.get("v.bankObj");
         var disbObj = component.get("v.disbObj");//24315
                var repayObj = component.get("v.repayObj");//24315

        if(!$A.util.isEmpty(bankObj)){
            var abbvalue = bankObj.Perfios_abb02__c + bankObj.Perfios_abb05__c + bankObj.Perfios_abb10__c;
            if(abbvalue != 0)
                abbvalue  = abbvalue / 3;
            component.set("v.abbvalue",abbvalue);  //24315s
            if(!$A.util.isEmpty(bankObj)&&!$A.util.isEmpty(disbObj)&&!$A.util.isEmpty(repayObj)){
            	if(component.get("v.displayReadOnly") || bankObj.Perfios_account_same_as_Salary_account__c || ((disbObj.Bank_Account__c == repayObj.A_C_NO__c) && (bankObj.Perfios_Account_No__c == repayObj.A_C_NO__c) && (disbObj.Bank_Account__c == bankObj.Perfios_Account_No__c))){component.set("v.displayReadOnly",true);}            
            }//24315e
        }
    },
     toggleAssVersion : function(component, event, helper) {
    	helper.toggleAssVersion(component, event);     
    },
    redirectToPerfiosRecord : function (component, event, helper) {
    	helper.redirectToPerfiosRecord(component,event);
    },
     DestroyChildCmp: function(component, event, helper) {
        //component.set("v.body",'');
        component.destroy();
    },
      //24315s 
    updateBankAccount : function(component, event, helper){
        console.log('saveBankAccountctrljs');
        helper.updateBnkAccHelper(component, event);     
    }//24315s
})