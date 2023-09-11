/** 

* File Name:  LoanChecklistIndex

* Description: This trigger is used to update

* number of Doc  checklists

* Copyright : Wipro Technologies Limited Copyright (c) 2010 * 

* @author : Wipro

* Modification Log 

* =============================================================== 

* Ver   Date        Author      Modification 

* --- ---- ------ ------------- ---------------------------------

* 1.0   10-Feb-10  Bibhu Created 
* 1.1   13-Feb-10  Raji Modified 

*/ 
trigger LoanChecklistIndex on Checklist__c (after insert,after update) {   
    //declaration of variables
    id id1;
    set<id> OppId = new set<id>();
    set<id> chkId = new set<id>();
     List<CheckList__c> ObjChk= new List<CheckList__c>();
    integer a=0,b=0,c=0,d=0,flag=0;
    Boolean chkStatus=false;
    Boolean updateDevfields = false;//Bug: 15259 
    Id LoanId;
    Id opptyId;
    List<Opportunity>Opp=new List<Opportunity>();
    for(Checklist__c chk:Trigger.new){
       if(chk.Applicant__c!=null){
           System.debug('chk.LoanId__c'+chk.LoanId__c);
            LoanId=chk.LoanId__c;          
            /*Bug 15259 commenting code
            flag=0;
            for(integer n=0;n<OppId.size();n++){
                if(OppId[n]==LoanId)
                flag=1;
              }
                if(flag==0)   */ 
               OppId.add(LoanId);
       } 
       //Bug: 15259 start 
       else
       {
           OppId.add(chk.Loan_Application__c);   
           updateDevfields = true;
       }  
      //Bug: 15259 end
    }
    If(OppId.size() > 0){ 
   Opp = [select id,Received__c,FlagChecklist__c,Pending__c,Deffered__c,Waived__c from Opportunity where Id in :OppId];
    try{
    ObjChk = [select DocStatus__c,Mandatory__c,Applicant__r.Loan_Application__c from CheckList__c where Applicant__r.Loan_Application__c in :OppId];
       if(ObjChk.size()>0 && !updateDevfields ){//Bug: 15259 Added condition
         for(integer i=0;i<Opp.size();i++) {
         a=0;b=0;c=0;d=0;  
          chkStatus=false; 
            for(integer k=0;k<ObjChk.size();k++){
                If(ObjChk[k].DocStatus__c=='Received'  && ObjChk[k].Applicant__r.Loan_Application__c==Opp[i].Id){
                   a=a+1;
                   }
                   If (ObjChk[k].DocStatus__c=='Pending' && ObjChk[k].Applicant__r.Loan_Application__c==Opp[i].Id){
                   b=b+1;
                   }
                   If (ObjChk[k].DocStatus__c=='Deffered' && ObjChk[k].Applicant__r.Loan_Application__c==Opp[i].Id){
                   c=c+1;
                   }
                   If (ObjChk[k].DocStatus__c=='Waived' && ObjChk[k].Applicant__r.Loan_Application__c==Opp[i].Id){
                   d=d+1;
                   }
                   If (ObjChk[k].DocStatus__c=='Waived' && ObjChk[k].Mandatory__c==true && ObjChk[k].Applicant__r.Loan_Application__c==Opp[i].Id){
                   chkStatus=true;   
                   } 
               }// end of for
            Opp[i].Received__c = a;
            Opp[i].Pending__c = b;
            Opp[i].Deffered__c = c;
            Opp[i].Waived__c = d;
            Opp[i].Checklist_Waived__c=chkStatus;
            decimal flag1=0;
            if(Opp[i].FlagChecklist__c >=0 || Opp[i].FlagChecklist__c<0 ){
            flag1=Opp[i].FlagChecklist__c+1;
            }
            else{
            flag1=1;
            }
            Opp[i].FlagChecklist__C=flag1;
            
          }// end of for for oppty  
      }   //  if(ObjChk.size()>0){
    }// end of try
    catch(Exception e){}
  }//  end of If(OppId.size() > 0){   
    //updating the checklist status in opportunity
    If(Opp.size() > 0 && !Test.isRunningTest()){
        System.debug('updatin opp');   
        Update Opp;
    }
}