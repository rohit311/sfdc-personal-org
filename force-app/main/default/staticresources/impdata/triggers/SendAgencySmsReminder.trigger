/** 

* File Name: SendAgencySmsReminder

* Description: This trigger is used to send sms

* agency mobile for reminder

* Copyright : Wipro Technologies Limited Copyright (c) 2010 * 

* @author : Wipro

* Modification Log 

* =============================================================== 

* Ver   Date        Author      Modification 

* --- ---- ------ ------------- ---------------------------------

* 1.0   01-Jun-10  Raji Created 
*/ 
trigger SendAgencySmsReminder on Verification__c (before update) {
String mess,ph=null;
/*Responsys Dynamic Parameters Bug 15653 s*/
List < verification__c > verList1 = new List < verification__c> (); 
List < verification__c > verList2 = new List < verification__c> ();
List < verification__c > verList3 = new List < verification__c> ();
List < Opportunity > LoanList = new List < Opportunity> ();
/*Responsys Dynamic Parameters Bug 15653 e*/

//3371
Set < String > DOCProducts = new Set < String > ();
if (LaonApplicationCreation__c.getValues('Professional Loan Product') != null) {
            String Doc_LineProducts = LaonApplicationCreation__c.getValues('Professional Loan Product').ProfessionalLoan__c;
            if (Doc_LineProducts != null) {
                system.debug('***Doc_LineProducts***' + Doc_LineProducts);
                String[] arr = Doc_LineProducts.split(';');
                for (String str: arr) {
                    DOCProducts.add(str);
                }
            }
        }

/*Responsys Dynamic Parameters Bug 15653 s*/
List < Id > oppId = new List < Id> ();
for(Verification__c ver: trigger.new){
  oppId.add(ver.Loan_Application__c);
}
List<Opportunity> LoanListId = new List<Opportunity>(); 
Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
LoanListId = [SELECT id from Opportunity where Id IN: oppId];
for(Opportunity opp:LoanListId){
  oppMap.put(opp.id,opp);
}
/*Responsys Dynamic Parameters Bug 15653 e*/
for (Verification__c ver: trigger.new){ 
    LoanList.add(oppMap.get(ver.Loan_Application__c)); //Responsys Dynamic Parameters Bug 15653   
    /*Start BUG-16959 added by sainath*/
    boolean isPSBLProductLineProduct = false;  
    transient string PSBLProductLineProducts = Label.PSBL_ProductLine_Products;
    if(PSBLProductLineProducts != null && PSBLProductLineProducts != '' )
    {
        set < string > setPSBLProdName = new set < string > ();
        setPSBLProdName.addAll(PSBLProductLineProducts.split(';'));
        if (setPSBLProdName != null && setPSBLProdName.size() > 0 && ver != null && ver.Product__c != null) 
        {
            if(setPSBLProdName.contains(ver.Product__c.toUpperCase()))
            isPSBLProductLineProduct = true; 
        }
    }
    /*End BUG-16959*/         
     if(/*Bug: 16959 S*/ !isPSBLProductLineProduct /*Bug: 16959 E*/ && ver.Product__c !='DOCTORS' && ver.Product__c!=null && !DOCProducts.contains(ver.Product__c.toUppercase()) && ver.Product__c !='RDL'){
     //for reminder sms
        if(ver.HL_Reminder_SMS_FV__c==true   && (ver.Verification_Type__c=='Bank Statements'|| ver.Verification_Type__c=='ITR'||ver.Verification_Type__c=='Residence verification' || ver.Verification_Type__c=='Office verification'|| ver.Verification_Type__c=='Pay Slips' ||ver.Verification_Type__c=='Property Verification')){
          //mess='Dear Sir/Mam, This is just a gentle reminder  to submit verification report for'+ver.Contact_Name__c+', pls ignore if submitted, Thank you.';
          verList1.add(ver); //Responsys Dynamic Parameters Bug 15653 
          /*Commenting  for Responsys Dynamic Parameters Bug 15653 start
          ph=ver.agency_mobile__c;
          if(ph!=null)
          sendsms.message(ph,mess);
          Commenting  for Responsys Dynamic Parameters Bug 15653 end*/
          ver.HL_Reminder_SMS_FV__c=false;  
          system.debug('1111');
         }
          if(ver.HL_Reminder_SMS_FV__c==true   &&(ver.Verification_Type__c=='FCU' || ver.Verification_Type__c=='Valuation'  ||ver.Verification_Type__c=='Legal')){
         // mess='Dear Sir/Mam, This is just a gentle reminder  to submit valuation report for'+ver.Contact_Name__c+', pls ignore if submitted, Thank you.';
          verList2.add(ver); //Responsys Dynamic Parameters Bug 15653
          /*Commenting  for Responsys Dynamic Parameters Bug 15653 start
          ph=ver.agency_mobile__c;
          if(ph!=null)
          sendsms.message(ph,mess);
          Commenting  for Responsys Dynamic Parameters Bug 15653 end*/
          ver.HL_Reminder_SMS_FV__c=false; 
          system.debug('222'); 
         }
         
         //sms if sgency breaches deadline
          if(ver.HL_Agency_TAT_Breach_SMS__c==true   && (ver.Verification_Type__c=='Bank Statements'|| ver.Verification_Type__c=='ITR'||ver.Verification_Type__c=='Residence verification' || ver.Verification_Type__c=='Office verification'|| ver.Verification_Type__c=='Pay Slips' ||ver.Verification_Type__c=='Property Verification')){
          //mess='Dear Sir/Mam, This is just a gentle reminder  to submit report for'+ver.Contact_Name__c+', pls ignore if submitted, Thank you.';
          verList3.add(ver); //Responsys Dynamic Parameters Bug 15653 
          /*Commenting  for Responsys Dynamic Parameters Bug 15653 start
          ph=ver.agency_mobile__c;
          if(ph!=null)
          sendsms.message(ph,mess);
          Commenting  for Responsys Dynamic Parameters Bug 15653 end*/
          ver.HL_Agency_TAT_Breach_SMS__c=false;
          system.debug('333');  
         }
          if(ver.HL_FCU_VAL_LEGAL_TAT_Breach_SMS__c==true   &&(ver.Verification_Type__c=='FCU' || ver.Verification_Type__c=='Valuation'  ||ver.Verification_Type__c=='Legal')){
          // mess='Dear Sir/Mam, This is just a gentle reminder  to submit report for'+ver.Contact_Name__c+', pls ignore if submitted, Thank you.';
          verList3.add(ver); //Responsys Dynamic Parameters Bug 15653
          /*Commenting  for Responsys Dynamic Parameters Bug 15653 start
          ph=ver.agency_mobile__c;
          if(ph!=null)
          sendsms.message(ph,mess);
          Commenting  for Responsys Dynamic Parameters Bug 15653 end*/
          ver.HL_FCU_VAL_LEGAL_TAT_Breach_SMS__c=false;
          system.debug('444');  
         }

     
     }// end of if
}//end of for
/*Responsys Dynamic Parameters Bug 15653 s*/
  GeneralCommunicationHandler.sendSMS(LoanList,verList1, 'Verification Reminder');
  GeneralCommunicationHandler.sendSMS(LoanList,verList2, 'Verification Reminder1');
  GeneralCommunicationHandler.sendSMS(LoanList,verList3, 'Verification Reminder2');
  /*Responsys Dynamic Parameters Bug 15653 e*/
}//end of trigger