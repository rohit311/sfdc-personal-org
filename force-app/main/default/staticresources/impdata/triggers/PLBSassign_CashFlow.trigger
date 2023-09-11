/** 

* File Name: PLBSassign_CashFlow

* Description: This trigger is used to update Cash Flow

* for the BLoan
* Copyright : Wipro Technologies Limited Copyright (c) 2010 * 

* @author : Wipro

* Modification Log 

* =============================================================== 

* Ver   Date        Author      Modification 

* --- ---- ------ ------------- ---------------------------------

* 1.0   28-Jan-10  Raji Created 

*/ 
trigger PLBSassign_CashFlow on Cash_Flow__c (before insert,before update) {
    //declaration of variables   
    List<PL_BS__c> PLBSs  = new List<PL_BS__c>(); 
    List<Id> LoanIds      = new  List<Id>();
    Cash_Flow__c cashFlow = new Cash_Flow__c();
    
    for(Cash_Flow__c cashFlows:trigger.new){
        LoanIds.add(cashFlows.Loan_Application__c);
    }     
   
    PLBSs=[select Id,Type_of_Year__c,Applicant__c,Year_Type__c from PL_BS__c where Loan_App__c in :LoanIds];
    
    for(Cash_Flow__c cashFlows:trigger.new){   
    integer countPr=0,countPro=0,CountCurr=0;     
        for(integer i=0;i<PLBSs.size();i++){
            /*if ( (PLBSs[i].Applicant__c==null) && (cashFlows.Product_Type__c=='PSBL')) {
                    if (PLBSs[i].Type_of_Year__c=='Previous') {
                        cashFlows.Previous_Year_PLBS__c=PLBSs[i].Id;                        
                    } 
                    else if (PLBSs[i].Type_of_Year__c=='Current') {
                        cashFlows.Current_Year_PLBS__c=PLBSs[i].Id;                      
                    }
                    else if (PLBSs[i].Type_of_Year__c=='Provisional') {//added for p2p case Start--
                        cashFlows.Provisional_Year_PLBS__c=PLBSs[i].Id;                      
                    } else if (PLBSs[i].Type_of_Year__c=='PreviousToPrevious') {
                        cashFlows.PreviousToPrevious_Year_PLBS__c=PLBSs[i].Id;                      
                    }// end--
            }*/
                        
            if ( (PLBSs[i].Applicant__c!=null) && (cashFlows.Applicant__c!=null) && (PLBSs[i].Applicant__c==cashFlows.Applicant__c) /*&& (cashFlows.Product_Type__c!='PSBL')*/) {
               
                
                
            if (PLBSs[i].Year_type__c=='Previous' ){
                    cashFlows.Previous_Year_PLBS__c=PLBSs[i].Id;
                     countPr=1  ;                 
                }
                                      
              else if (PLBSs[i].Year_type__c=='Current') {
                    cashFlows.Current_Year_PLBS__c=PLBSs[i].Id;
                    CountCurr=1;                 
                } 
               
              else if (PLBSs[i].Year_type__c=='Provisional') {
                    cashFlows.Provisional_Year_PLBS__c=PLBSs[i].Id;  
                    countPro=1;               
                }else if (PLBSs[i].Type_of_Year__c=='PreviousToPrevious') {//added for p2p case Start--
                        cashFlows.PreviousToPrevious_Year_PLBS__c=PLBSs[i].Id;                      
                    }// end--  
                       
            }//end of if
        } // end of plbs loop
        if(countPr==0 && cashFlows.Applicant__c!=null)cashFlows.Previous_Year_PLBS__c=null;
        if(countPro==0 && cashFlows.Applicant__c!=null)cashFlows.Provisional_Year_PLBS__c=null;
        if(CountCurr==0 && cashFlows.Applicant__c!=null)cashFlows.Current_Year_PLBS__c=null;
        
        if(cashFlows.Working_Capital_Effect1__c == null){
                   	cashFlows.Working_Capital_Effect1__c = 0;
                   	 System.debug('cashFlows.Working_Capital_Effect1__c' +cashFlows.Working_Capital_Effect1__c);
         }
                   
        if(cashFlows.Working_Capital_Effect1__c != null){
                   
                 cashFlows.Working_Capital_Effect1__c = cashFlows.Stock__c  +  cashFlows.Debtors__c  +  
                 cashFlows.Loans_and_advances__c  +  cashFlows.Creditors__c  +  cashFlows.Other_Liability__c 
                  +  cashFlows.Provision__c  +  cashFlows.Change_in_CC__c;
      			 System.debug('cashFlows.Working_Capital_Effect1__c %%% '+cashFlows.Working_Capital_Effect1__c);
          }	
          if(cashFlows.Net_Case1__c  == null){
          		cashFlows.Net_Case1__c = 0;
          }
          if(cashFlows.Net_Case1__c  != null){
                   		cashFlows.Net_Case1__c = cashFlows.Purchase_Sale_of_Fixed_Assets__c  + cashFlows.Purchase_Sal_Inv__c 
                   								+ cashFlows.Interest_Received__c;
          }
          System.debug('cashFlows.Net_Case1__c %%' +cashFlows.Net_Case1__c);
          if(cashFlows.Cash_Closing_Balance1__c == null){
                   	cashFlows.Cash_Closing_Balance1__c = 0;
                   	 System.debug('cashFlows.Cash_Closing_Balance1__c' +cashFlows.Cash_Closing_Balance1__c);
         }
           if(cashFlows.Cash_Closing_Balance1__c  != null){
                   		cashFlows.Cash_Closing_Balance1__c = cashFlows.Cash_Opening_Balance__c + 
                   		cashFlows.NetDecrease_Increase__c - cashFlows.Net_Other_Income__c - cashFlows.Profit_on_sale_of_Fixed_Assets_Investme__c - 
                   		cashFlows.Loss_on_sale_of_Fixed_Assets_Investment__c;
           }
           
           //added for p2p
           if(cashFlows.Pro_Cash_Closing_Bal1__c == null){
                   	cashFlows.Pro_Cash_Closing_Bal1__c = 0;
                   	 System.debug('cashFlows.Pro_Cash_Closing_Bal1__c' +cashFlows.Pro_Cash_Closing_Bal1__c);
         }
           if(cashFlows.Pro_Cash_Closing_Bal1__c  != null){
                   		cashFlows.Pro_Cash_Closing_Bal1__c = cashFlows.Pro_Cash_Opening_Balance__c + 
                   		cashFlows.Pro_Net_Decrease_Increase_in_Cash__c - cashFlows.Pro_Net_Other_Income__c - cashFlows.Profit_on_sale_of_Fixed_Assets_Investme__c - 
                   		cashFlows.Loss_on_sale_of_Fixed_Assets_Investment__c;
           }
           
           System.debug('cashFlows.Pro_Cash_Closing_Bal1__c'+cashFlows.Pro_Cash_Closing_Bal1__c);									
    } //end of cash loop
}