/** 

* File Name: DevCalcupdate

* Description: This trigger is used to update

* Summary Id in devcalculator

* Copyright : Wipro Technologies Limited Copyright (c) 2010 * 

* @author : Wipro

* Modification Log 

* =============================================================== 

* Ver   Date        Author      Modification 

* --- ---- ------ ------------- ---------------------------------

* 1.0   10-Feb-10  Raji Created 

*/ 
trigger DevCalcupdate on Bank_Summary__c (after insert) {
  //variable declaration
  Id loanid;
  Id bankSummId;
  List<id> LoanIds= new List<Id>();
  Map<Id,Id> BankMap = new Map<Id,Id>();

  List<Deviation_Calculator__c> devCalc=new List<Deviation_Calculator__c>{};
      for (Bank_Summary__c bankSumm : trigger.new){
      loanid=bankSumm.Loan_Application__c;
      LoanIds.add(LoanId);
      bankSummId=bankSumm.Id;
         BankMap.put(LoanId,bankSummId);
     }
      
      
  devCalc=[Select Id,Bank_Summary__c,Loan_Application__c from Deviation_Calculator__c
  where Loan_Application__c in :loanids];
  
  
   for(integer k=0;k<devCalc.size();k++){
     devCalc[k].Bank_Summary__c=BankMap.get(devCalc[k].Loan_Application__c);
   }
      if( devCalc.size()>0){
      update devCalc;}
 }//end of trigger