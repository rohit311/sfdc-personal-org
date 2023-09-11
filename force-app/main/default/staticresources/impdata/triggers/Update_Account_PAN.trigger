// Bug Id : 16618 - NSDL PAN Check.

trigger Update_Account_PAN on Account (after update) {
if (CreditCardController.handleRecursion) { // CC Code changes SME
   Set<ID> AccidsNew = new Set<ID>();  //Retrigger BRE Priya 20939
   Set<ID> Accids = new Set<ID>();      // current Account's  id. who is updated.
   if (label.Active_Account_Flag == 'True') {
                                  
                                  Set<ID> reqAccids = new Set<ID>();   // required acc id's whose stage is either ( UR || Re-Apperesal )
                               
                            System.debug('Inside Acc trigger');
       for(Account updatedAcc : Trigger.new){
           AccidsNew.add(updatedAcc.id);
          //Commented below code and moved it below 20939
           
         if(  ( (trigger.oldmap.get(updatedAcc.id).PANNumber__c == null && updatedAcc.PANNumber__c != null) && (trigger.oldmap.get(updatedAcc.id).id == updatedAcc.id) )||
              ( (trigger.oldmap.get(updatedAcc.id).id == updatedAcc.id) && (trigger.oldmap.get(updatedAcc.id).PANNumber__c!= null && !trigger.oldmap.get(updatedAcc.id).PANNumber__c.equalsIgnoreCase(updatedAcc.PANNumber__c)))
           ) {       
                       Accids.add(updatedAcc.id);
                    
               }
             }  
    
    System.debug('Taken all ids of updated acc in  Acc trigger' + Accids);


  if (  AccidsNew.size() > 0) {
     
     
     
    if(Trigger.isUpdate && Trigger.isAfter){
    Map<Id, Opportunity> oppMap;
    
         // Bug 22141 Added inner query for Verification
        List<Opportunity> oppLst = [select Account.Offer_Inhanced__c,Account.Flow__c,id, product__C,Account.IS_OTP_FLOW__c, CreatedDate,
                                    (select id,name,Old_Loan_Application__c,Policy_Name__c,Remarks__c,Disposition_Status__c,Checklist_Policy_Status__c from SOL_Policys__r),
                                    (select id from verification__r where Verification_Type__c ='Banking Validations')
                                    from Opportunity where AccountId in : AccidsNew];
                                                /* Bug 22141 Starts */
            if(label.BankingValidationProducts != null && string.isNotBlank(Label.BankingValidationProducts)){
                List<Id>requiredAccId = new List<Id>();
                List<string> ListofProducts = Label.BankingValidationProducts.split(';');  
                List<Opportunity> opptempList = oppLst;
                List<verification__c> verificationList = new List<verification__c>();
            
                if(ListofProducts!=null && ListofProducts.size()>0){
                    for(Account updatedAcc : Trigger.new){
                        if(trigger.oldmap.get(updatedAcc.id).Mobile__c!=trigger.newmap.get(updatedAcc.id).Mobile__c && ListofProducts!=null && ListofProducts.size()>0 && ListofProducts.contains(trigger.newmap.get(updatedAcc.id).Product__c))
                        {
                            requiredAccId.add(trigger.newmap.get(updatedAcc.id).id);
                        }
                    }
                    if(requiredAccId!=null && requiredAccId.size()>0){
                        if(oppLst!=null && oppLst.size()>0){
                            for(Opportunity oppObj:oppLst){
                               // system.debug('requiredAccId'+requiredAccId + 'oppObj.Account.Id'+oppObj.Account.Id);
                                if(requiredAccId.contains(oppObj.Account.Id))
                                {
                                    if(oppObj.verification__r!=null && oppObj.verification__r.size()>0){
                                        for(verification__c verificationObj :oppObj.verification__r ){
                                            verificationList.add(verificationObj);
                                        }
                                    }
                                }
                            }
                        }
                        delete verificationList;
                    }
                    
                }
            }
           /* Bug 22141 Ends*/
        if(!CommonUtility.isEmpty(oppLst)){
            oppMap = new Map<Id, Opportunity>();
            for(Opportunity opp : oppLst)
                oppMap.put(opp.AccountId,opp);
        }
    
    Map<String,Object> allMap = new Map<String,Object>();
    allMap = GeneralUtilities.fetchRetriggerRescMap();
    Map<String,SOL_Policy__c> solPolicyToUpdateMap = new map<String,SOL_Policy__c>();
    for ( Account acc : Trigger.New){
        Opportunity Loan = new Opportunity();
        if(oppMap != null && oppMap.containsKey(acc.Id) && oppMap.get(acc.Id) != null){
            Loan = oppMap.get(acc.Id);
        }
        
            system.debug('in mobility'+Loan.Account.Flow__c);
            if(Loan != null && Loan.Account.Flow__c == 'Mobility V2'){
                List<SOL_Policy__c> solPolicyList = new List<SOL_Policy__c>();
                Map<String,Object> appFields = new Map<String,Object>();
                
                if(!commonutility.isEmpty(allMap)){
                    appFields = (Map<String,Object>)allMap.get('Account');
                    System.debug('Hi'+appFields );
                    if(!commonutility.isEmpty(appFields)){
                        solPolicyToUpdateMap = GeneralUtilities.reTriggerBREGen(Trigger.oldmap.get(acc.Id),acc,Loan,appFields,solPolicyToUpdateMap);
                        
                    }
                }
                
               
            }
            
        }
        if(solPolicyToUpdateMap != null && solPolicyToUpdateMap.size() >0){
            update solPolicyToUpdateMap.values();
        }
    }
    }
    //System.debug('Considered only those account, whose Opportunity  stage is either  UR || Re-Apperesal '+ reqAcclst);
    if (  Accids.size() > 0) {
    List<Account> reqAcclst  = new List<Account>(); // req acc list whose stage is either ( UR || Re-Apperesal )
    List<Account> allAcclst = [ select id, PANNumber__c ,( select id, StageName from Opportunities ) from Account where id =:Accids ];
    
        for ( Account actlacc :  allAcclst )
            for( Opportunity op : actlacc.Opportunities){
                if( op.StageName == 'Underwriting' || op.StageName == 'Re-Appraise- Loan amount' ){
                    reqAccids.add(actlacc.id);
                    reqAcclst.add(actlacc);   
                }
                
            }           
    System.debug('Considered only those account, whose Opportunity  stage is either  UR || Re-Apperesal '+ reqAcclst);
     
    List<Contact> cnList = [select id, Customer_Type__c, ApplicantType__c, PAN_Number__c from Contact where AccountId in : reqAccids ];
System.debug('All Contact list related to account, which is again related to Opportunity whose stage is either  UR || Re-Apperesal '+cnList);
    
    List<Contact> updatedConList = new List<Contact>(); // req cont list which are either ( PRI--Ind OR Corporate--Pri-Fina-co-app ) .
               
        for ( Account ac : reqAcclst ) {
                       System.debug('in for loop ' + cnList);               
            for (Contact c : cnList){
                        System.debug('inside account trigger -->' + c);
           if(
                (c.Customer_Type__c.equalsIgnoreCase('Individual') && c.ApplicantType__c.equalsIgnoreCase('Primary')) ||
                (c.Customer_Type__c.equalsIgnoreCase('Corporate') && c.ApplicantType__c.equalsIgnoreCase('Primary Financial Co-Applicant'))
                    ){
                      
                       c.PAN_Number__c = ac.PANNumber__c;
                       System.debug('updating pri.Applicants Pan for Loan_Pan updation --- inside acc trigger --> for Contact' + c);
                        updatedConList.add(c);
                }
              }
           }
                 System.debug('Printing updatedConList ' + updatedConList); 
         if(updatedConList!= null && updatedConList.size()>0){
           update updatedConList;  
           }      
     }
   
   

   // CC Code changes SME start
    if(Trigger.isUpdate && Trigger.isAfter) {
        // Check if parameters are changed mobile pin code and date of birth
        Set<Id> aIds = new Set<Id>();
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        for (Account acc : Trigger.oldMap.values()) {
            System.debug('Old Account::'+acc);
            Account newValue = Trigger.newMap.get(acc.Id);
            System.debug('New value::'+newValue);
            /*US : 2702*/
            if ((acc.CC_Disposition__c != null || acc.CC_Variant__c != null) && newValue != null && (newValue.Mobile__c != acc.Mobile__c || newValue.Date_of_Birth__c != acc.Date_of_Birth__c || newValue.Current_PinCode__c != acc.Current_PinCode__c || newValue.Degree__c != acc.Degree__c || newValue.Specialisation__c != acc.Specialisation__c)) {
                aIds.add(newValue.Id);
            }
        }
        System.debug('aIds -->' + aIds.size());
        if (aIds.size() > 0) {
            oppMap = new Map<Id, Opportunity>([Select Id, AccountId From Opportunity where AccountId IN:aIds]);
        }
        System.debug('oppMap -->' + oppMap.size());
        if (oppMap.size() > 0) {
            // fetch SOL Policy of type CC and check application number is not generated, TODO replace Name with CC Application number field
            List<SOL_Policy__c> solPLst = [Select Id, Loan_Application__c From SOL_Policy__c where Loan_Application__c IN: oppMap.keySet() AND Flow_Identifier__c =: CreditCardController.CC_SME_IDENTIFIER AND CC_Number__c = null];
            System.debug('solPLst -->' + solPLst.size());
            if (solPLst != null && solPLst.size() > 0) {
                CreditCardController.handleRecursion = true;
                accIds = new Set<Id>();
                List<Account> accToUpdate = new List<Account>();
                
                for (SOL_Policy__c sp : solPLst) {
                    if (oppMap.get(sp.Loan_Application__c) != null && oppMap.get(sp.Loan_Application__c).AccountId != null) {
                        accIds.add(oppMap.get(sp.Loan_Application__c).AccountId);
                    }
                }
                if (accIds.size() > 0) {
                    List<Account> lLst = [Select Id,CC_Disposition__c,CC_Variant__c, Name from Account where Id IN:accIds];
                    for (Account l : lLst) {
                        l.CC_Disposition__c = null; /*US : 2702*/
                        l.CC_Variant__c = null;
                        accToUpdate.add(l);
                    }
                }
                if (accToUpdate.size() > 0) {
                    update accToUpdate;
                    // delete SOL Policy
                    delete solPLst;
               }
            }
        }// CC Code changes SME end
    }
   
   }
   }
}