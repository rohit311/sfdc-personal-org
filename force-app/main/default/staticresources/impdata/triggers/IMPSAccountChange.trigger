/*
    created by : akshata Rajmane (Persistent)
    purpose : If user changes the account no of existing record to another tries to check imps , the imps count should reset to 0.
    inhancement id : 13907
*/
//added after delete event for bug 24313
trigger IMPSAccountChange on Current_Disbursal_Details__c (before update,after insert,after update,after delete) {
    static Set<id> LoanIdsSet = new Set<id>(); // 24313
    static List<Opportunity> oppLstSt;// 24313
    if(trigger.isbefore && trigger.isupdate)
    {
        System.debug('in trigger');
        IMPSAccountChangeHandler.impsInfoUpdate(trigger.new,trigger.oldMap);
    }
    
     //Bug 22141c  S
    if(Label.BankingValidationProducts!=null && string.isNotBlank(Label.BankingValidationProducts)){
        List<String> BankingValidProducts = Label.BankingValidationProducts.split(';');
        if(trigger.isafter && trigger.isinsert)
        {
            List<Verification__c> verificationList = new List<Verification__c>();
            List<ID> oppIds = new List<ID>();
            for(Current_Disbursal_Details__c cddObject:trigger.new){
                System.debug('insert after trigger');
                oppIds.add(cddObject.Loan_Application__c);
            }       
            if(oppIds!=null && oppIds.size()>0){
                verificationList = [select id,Verification_Type__c from Verification__c where Loan_Application__c IN :oppIds and Loan_Application__r.Product__c  IN :BankingValidProducts  and Verification_Type__c ='Banking Validations'];
            }
            if(verificationList!=null && verificationList.size()>0){
                    delete verificationList;
            }
        }
        if(trigger.isafter && trigger.isupdate)
        {   
            Boolean isfieldchanged = false;
            List<Verification__c> verificationList = new List<Verification__c>();
            List<ID> oppIds = new List<ID>();
            for(Current_Disbursal_Details__c cddObject:trigger.new){
                //Favouring__c,Bank_Account__c,IFSC_Code__c,Bank_Name__c,Bank_Branch__c,Disbursement_Amount__c              
                System.debug('upadte after trigger');       
                if(label.CDDfieldsForBankConfirmation != null && string.isNotBlank(Label.CDDfieldsForBankConfirmation)){
                    List<string> ListofFields = Label.CDDfieldsForBankConfirmation.split(',');
                    for(string strField : ListOfFields)
                    {   
                        if(trigger.newmap.get(cddObject.id).get(strField)  != trigger.oldmap.get(cddObject.id).get(strField))
                        {
                            isfieldchanged = true;                          
                        }
                    }
                    if(isfieldchanged==true){
                        oppIds.add(cddObject.Loan_Application__c);
                    }
                }
            }
            if(oppIds!=null && oppIds.size()>0){
                verificationList = [select id,Verification_Type__c from Verification__c where Loan_Application__c IN :oppIds and Loan_Application__r.Product__c  IN:BankingValidProducts and Verification_Type__c ='Banking Validations'];
                if(verificationList!=null && verificationList.size()>0){
                    delete verificationList;
                }
            }
        }   
    }   

    //Bug 22141  E
	//Added for Bug 24313 start
    if(Trigger.isAfter && Trigger.isInsert ){
        
        system.debug('inside insert nnn');
        set<Id> setLoan = new set<id>();
        for(Current_Disbursal_Details__c cdd:trigger.new){
            
            if(cdd.Loan_Application__c != null)
                setLoan.add(cdd.Loan_Application__c);
        }
        system.debug('inside insert nnn LoanIdSet'+setLoan);
        GeneralUtilities.ResendConsentMailValidation('Current_Disbursal_Details__c',setLoan);
    }
    if(Trigger.isAfter && Trigger.isDelete ){
        system.debug('inside delete nnn');
        set<Id> setLoan = new set<id>();
        for(Current_Disbursal_Details__c cdd:trigger.old){
            
            if(cdd.Loan_Application__c != null)
                setLoan.add(cdd.Loan_Application__c);
        }
        GeneralUtilities.ResendConsentMailValidation('Current_Disbursal_Details__c',setLoan);
    }
    /*Retrigger BRE 24313/20939 s */
    if(Trigger.isAfter && trigger.isUpdate){
        system.debug('inside update nnn');
        for(Current_Disbursal_Details__c cdd:trigger.new){
            if(cdd.Loan_Application__c != null)
            LoanIdsSet.add(cdd.Loan_Application__c);//24313
        }
        
        Map<Id, Opportunity> oppMap;
        System.debug('loanIDset'+LoanIdsSet);
        if(!CommonUtility.isEmpty(LoanIdsSet)){
            
            oppLstSt = GeneralUtilities.getOpportunities(LoanIdsSet);//Bug 24313
            List<Opportunity> oppLst = oppLstSt;//24313
            if(!CommonUtility.isEmpty(oppLst)){
                oppMap = new Map<Id, Opportunity>();
                for(Opportunity opp : oppLst)
                    oppMap.put(opp.Id,opp);
            }
            System.debug('Yes'+oppMap);
        }
        Map<String,Object> allMap = new Map<String,Object>();
        allMap = GeneralUtilities.fetchRetriggerRescMap();
        Map<String,SOL_Policy__c> solPolicyToUpdateMap = new map<String,SOL_Policy__c>();
        for(Current_Disbursal_Details__c cdd:trigger.new){
            Opportunity Loan = new Opportunity();
            if(oppMap != null && oppMap.containsKey(cdd.Loan_Application__c) && oppMap.get(cdd.Loan_Application__c) != null){
                Loan = oppMap.get(cdd.Loan_Application__c);
            }
            
            system.debug('in mobility'+Loan.Account.Flow__c);
            if(Loan != null && Loan.Account.Flow__c == 'Mobility V2'){
                Map<String, SOL_Policy__c> solPolicyMAPToUpdate=new Map<String, SOL_Policy__c>();
                Map<String,Object> cddFields = new Map<String,Object>();
                if(!commonutility.isEmpty(allMap)){
                    cddFields = (Map<String,Object>)ALLMap.get('Current_Disbursal_Details__c');
                    System.debug('Hi'+cddFields );
                    if(!commonutility.isEmpty(cddFields)){
                        solPolicyToUpdateMap = GeneralUtilities.reTriggerBREGen(Trigger.oldmap.get(cdd.Id),cdd,Loan,cddFields,solPolicyToUpdateMap);
                    }
                }
            }
            
        }
        if(solPolicyToUpdateMap != null && solPolicyToUpdateMap.size() > 0){
            update solPolicyToUpdateMap.values();  
        }
        /*Retrigger BRE 24313/20939 e */
    }
    
    // Added for Bug 24313 stop  
    
}