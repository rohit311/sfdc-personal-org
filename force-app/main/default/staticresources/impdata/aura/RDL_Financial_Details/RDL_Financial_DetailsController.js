({
 doInit: function(component, event, helper) {
  
  helper.getPicklistvalBankAccount(component);
  helper.getPicklistvalBankTrans(component);
  helper.setYearValues(component);
    
//helper.dummy(component, event, helper);

 },
 BankDetailsOpenClose: function(component, event, helper) {
  //   event.stopPropagation(); 
  component.set("v.isOpen", true);
  helper.AutopopulateData(component,helper);
    
     console.log('after AutopopulateData');
 },
 CloseEverything: function(component, event, helper) {
   
     component.set("v.isOpen", false);
   
        //component.set("v.spinnerFlag", "false");
        helper.saveFinancialDetaildummy(component, event, helper);

 },

 saveFinancialDetail: function(component, event, helper) {
  // alert('isnide saveFinancialDetails');
 
  helper.saveFinancialDetail(component, event, helper);
  //component.set("v.bankAccountObj.Average_Bank_Balance__c", 123);
  //helper.saveEMICard(component,event);

 }
})