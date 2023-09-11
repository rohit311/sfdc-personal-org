trigger StageToCentralizedUnderw on Salaried__c(after update, before update) {

 if (Trigger.isupdate) {
  for (Salaried__c salObj: Trigger.new) {
   if (Trigger.isbefore) {

    if (salObj.month1_sal__c != null)
     salObj.month1_sal__c = salObj.month1_sal__c.replace(',', '');
    if (salObj.month2_sal__c != null)
     salObj.month2_sal__c = salObj.month2_sal__c.replace(',', '');
    system.debug('---------salObj.month1_sal__c------------->' + salObj.month1_sal__c);
    system.debug('---------salObj.month2_sal__c------------->' + salObj.month2_sal__c);
	
	/* #10293 - Field Level Enhancement Start*/
	if (!CommonUtility.isEmpty(salObj.month1_sal__c) && CommonUtility.isEmpty(salObj.month2_sal__c))
		salObj.month2_sal__c = salObj.month1_sal__c;
	/* #10293 - Field Level Enhancement End*/
	
   } else if (Trigger.isafter && !ControlRecursiveCallofTrigger_Util.hasStagetoCenttriggerAfterUpdate()) {
    
    //Code added for bitly start            
    system.debug('salObj.Cust_Reference_No__c' + salObj.Cust_Reference_No__c);
    system.debug('Trigger.oldmap.get(salObj.id).Cust_Reference_No__c' + Trigger.oldmap.get(salObj.id).Cust_Reference_No__c);
    if (!CommonUtility.isEmpty(salObj.Cust_Reference_No__c) && (Trigger.oldmap.get(salObj.id).Cust_Reference_No__c != salObj.Cust_Reference_No__c || CommonUtility.isEmpty(salObj.Bitly_URL__c)) && !system.isFuture() && !System.isBatch() ) { //Bug 24640 - DG Online for SOL and PLCS  - bypass batch
     SOLDynamicController.getShortUrl(salObj.id);
    }
    //Code added for bitly End
    //Code for HL Track Start

    if (CommonUtility.isEmpty(salObj.Existing_HL_Track__c) && !CommonUtility.isEmpty(salObj.Product_Type__c) && (!CommonUtility.isEmpty(salObj.Pan__c) || !CommonUtility.isEmpty(salObj.Experia_Cust_Id__c)) && !system.isFuture() && !System.isBatch() ) { //Bug 24640 - DG Online for SOL and PLCS  - bypass batch

     SOLDynamicController.getExistingHLTrackRecord(salObj.id);
    }
    //Code for HL Track End
   }
   
  }

  if (Trigger.isafter && !ControlRecursiveCallofTrigger_Util.hasStagetoCenttriggerAfterUpdate()) {
   ControlRecursiveCallofTrigger_Util.setStagetoCenttriggerAfterUpdate();
   List < Opportunity > Loan = new List < Opportunity > ();
   List < Credit_Officer_Limit__c > creditLimit = new List < Credit_Officer_Limit__c > ();
   string creditofficerCity;
   List < String > creditofficerCity1;
   set < id > oppIdsSet = new set < id > ();

   List < User > UnderFinID = new List < User > ();
   ID Uid = Userinfo.getUserID();
   String lblUserIDS = '';
   lblUserIDS = label.DBA_User_ID;
   Set < String > usrIds = new Set < String > ();
   system.debug('lblUserID**********************' + lblUserIDS);
   for (String labelUsrids: lblUserIDS.split(';')) {
    usrIds.add(labelUsrids);
   }
   if (Test.isRunningTest() && !CommonUtility.isEmpty(usrIds)) {
    Uid = null; //lblUserIDS.split(';')[0];
   }
   system.debug('Uid**********************' + Uid);
   system.debug('usrIds**********************' + usrIds);
   if (!usrIds.contains(Uid)) {
    if (Trigger.New[0].Product_Type__c == 'LASOL') {
     system.debug(Trigger.New[0].LASOL_City__c + 'RRRRRRRRRRRRRR');
     creditLimit = [select Designation__c, Credit_Officer_Name__c, Product__c, city__c from Credit_Officer_Limit__c where Active_Flag__c = true];
     system.debug('RRRRRRRRRRRRRRcreditLimit' + creditLimit);
     Loan = [select Product__c, StageName, Approval_Stages__c, Approver__c from Opportunity where id = : Trigger.New[0].Loan_Application__c];
     system.debug('Loan' + Loan);
     if (creditLimit.size() > 0) {
      system.debug('Inside if');
      for (integer i = 0; i < creditLimit.size(); i++) {
       system.debug('Inside for');
       if (creditLimit[i].Product__c == 'LASOL') {
        system.debug('Inside product');
        system.debug('City' + Trigger.New[0].LASOL_City__c);
        creditofficerCity = creditLimit[i].city__c;
        creditofficerCity1 = creditofficerCity.split(';');
        for (string selectedValuesInstance: creditofficerCity1) {
         if (selectedValuesInstance == Trigger.New[0].LASOL_City__c)
          system.debug('Inside city');
         if (creditLimit[i].Designation__c == 'Centralized ACM') {
          system.debug('Inside Designation');
          if (Loan.size() > 0 && Loan[0].Product__c == 'LASOL' && Loan[0].StageName == 'Auto Approved Paid' && Trigger.New[0].Percentage_completion__c == '100') {
           system.debug('Inside if loan');
           Loan[0].StageName = 'Centralized Underwriting';
           Loan[0].Approval_Stages__c = 'Centralized Underwriting';
           system.debug('Credit office name ' + creditLimit[i].Credit_Officer_Name__c);
           system.debug('Approver ' + creditLimit[i].Designation__c);
           Loan[0].OwnerID = creditLimit[i].Credit_Officer_Name__c;
           Loan[0].Approver__c = creditLimit[i].Designation__c;
          }

         }
        }

       }
      }
     }

    }
    if (Loan.size() > 0) {
     update Loan[0];
    }
   }
  }
 }
}