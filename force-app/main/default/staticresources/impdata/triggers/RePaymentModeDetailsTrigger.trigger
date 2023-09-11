trigger RePaymentModeDetailsTrigger on RePayment_mode_detail__c (after insert,after delete,after Update) {
    //Added for Bug 24313 start
    
    static Set<id> LoanIdsSet = new Set<id>(); // 24313
    static List<Opportunity> oppLstSt;// 24313
    
    if(Trigger.isAfter && Trigger.isInsert){
        set<Id> setLoan = new set<id>();
        for(RePayment_mode_detail__c RMD:trigger.new) {   
            //system.debug('RMD'+RMD);
            if(RMD.Loan_Application__c != null)
                setLoan.add(RMD.Loan_Application__c);
        }
        //system.debug('setLoans'+setLoan);
        GeneralUtilities.ResendConsentMailValidation('RePayment_mode_detail__c',setLoan);
    }
    if(Trigger.isAfter && Trigger.isDelete ){
        
        set<Id> setLoan = new set<id>();
        for(RePayment_mode_detail__c RMD:trigger.old){
            System.debug('Inside Delete Repay');
            if(RMD.Loan_Application__c != null)
                setLoan.add(RMD.Loan_Application__c);
        }
        GeneralUtilities.ResendConsentMailValidation('RePayment_mode_detail__c',setLoan);
    }
    // Added for Bug 24313 stop     
    /*Retrigger BRE 24313/20939 s */
    if(Trigger.isAfter && trigger.isUpdate){
        for(RePayment_mode_detail__c RMD:trigger.new){
            
            LoanIdsSet.add(RMD.Loan_Application__c);//24313
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
        for(RePayment_mode_detail__c RMD:trigger.new){
            Opportunity Loan = new Opportunity();
            if(oppMap != null && oppMap.containsKey(RMD.Loan_Application__c) && oppMap.get(RMD.Loan_Application__c) != null){
                Loan = oppMap.get(RMD.Loan_Application__c);
            }
            
            system.debug('in mobility'+Loan.Account.Flow__c);
            if(Loan != null && Loan.Account.Flow__c == 'Mobility V2'){
                Map<String, SOL_Policy__c> solPolicyMAPToUpdate=new Map<String, SOL_Policy__c>();
                Map<String,Object> rmdFields = new Map<String,Object>();
                if(!commonutility.isEmpty(allMap)){
                    rmdFields = (Map<String,Object>)ALLMap.get('RePayment_mode_detail__c');
                    System.debug('Hi'+RMDFields );
                    if(!commonutility.isEmpty(rmdFields)){
                        solPolicyToUpdateMap = GeneralUtilities.reTriggerBREGen(Trigger.oldmap.get(RMD.Id),RMD,Loan,rmdFields,solPolicyToUpdateMap);
                    }
                }
            }
            
        }
        if(solPolicyToUpdateMap != null && solPolicyToUpdateMap.size() > 0){
            update solPolicyToUpdateMap.values();  
        }
        /*Retrigger BRE 24313/20939 e */
    }
    
}