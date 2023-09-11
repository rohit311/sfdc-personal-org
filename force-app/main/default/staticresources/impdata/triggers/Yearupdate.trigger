/** 

* File Name: Yearupdate

* Description: This trigger is used to update

* Pl/bs

* Copyright : Wipro Technologies Limited Copyright (c) 2010 * 

* @author : Wipro

* Modification Log 

* =============================================================== 

* Ver   Date        Author      Modification 

* --- ---- ------ ------------- ---------------------------------

* 1.0   27-Jan-10  Raji Created 

*/ 

trigger Yearupdate on PL_BS__c (after insert, after update) {
  if (!ControlRecursiveCallofTrigger_Util.hasAlreadyExecutedYearUpdate()) {
    //variable declarations
     //3371
        Set < String > DOCProducts = new Set < String > ();
        
    List<PL_BS__c> plbsUpdateList= new List<PL_BS__c>{};
    List<Deviation_Calculator__c> devCalc=new List<Deviation_Calculator__c>{};
    Id loanid;
    String Product;
    Id provisionalYear=null;
    Id previousYear=null;
    Id currentYear=null;
    List<id> LoanIds= new List<Id>();
    List<id> apps= new List<Id>();
    integer flag=0,flagapp=0;
    List<PL_BS__c> plRecords= new List<PL_BS__c>();
    List<PL_BS__c> plbss= new List<PL_BS__c>();
    List<id>plbsIds =new List<id>();
    
    
    
    for (PL_BS__c plbsRec : trigger.new){
        System.debug(plbsRec);
      //getting the list of plbs recs
      plbsIds.add(plbsRec.Id);
      loanid=plbsRec.Loan_App__c;
      product=plbsRec.Product__C;       
              flag=0;
                for(integer n=0;n<LoanIds.size();n++){
                    if(LoanIds[n]==loanid)
                    flag=1;
                  }
                    if(flag==0)    
                    LoanIds.add(loanid);   
     }
      //getting the relevant records 
      PlRecords=[select Id,Type_of_Year__c,Applicant__c,Loan_App__c,product__C,Year_Type__C,Previous_Year__c from PL_BS__c where Id in :plbsIds];
      // getting all plbs recs
      PLBSs=[select Id,Type_of_Year__c,Applicant__c,Loan_App__c,product__c,Year_Type__C,Previous_Year__c from PL_BS__c where Loan_App__c in :LoanIds];
     
       for(PL_BS__c plbs:plRecords){   
           Id current,previous, previousToPrevious, provisional, proSummary,prevSummary,currSummary,prevToPrevSummary;
        ///for psbl
         /* if ( plbs.Product__C=='PSBL') {       
            System.debug('PLBSs$$ '+PLBSs);  
            for(integer i=0;i<PLBSs.size();i++){
                  //getting current year id
                  if (PLBSs[i].Type_of_Year__c=='Current'  &&  PLBSs[i].Loan_App__c==plbs.Loan_App__c) {
                      current=PLBSs[i].Id;              
                    } 
                  if (PLBSs[i].Type_of_Year__c=='Previous'  &&  PLBSs[i].Loan_App__c==plbs.Loan_App__c) {
                      previous=PLBSs[i].Id;              
                  }
                  
                  //--start 3/1/11--
                  if (PLBSs[i].Type_of_Year__c=='PreviousToPrevious'  &&  PLBSs[i].Loan_App__c==plbs.Loan_App__c) {
                      previousToPrevious=PLBSs[i].Id;              
                  }
                  if (PLBSs[i].Type_of_Year__c=='Provisional'  &&  PLBSs[i].Loan_App__c==plbs.Loan_App__c) {
                      provisional=PLBSs[i].Id;              
                  }
                  //--End--
                     
                  System.debug('PLBSs[i].Type_of_Year__c' +PLBSs[i].Type_of_Year__c);
                  System.debug('previous$$'+previous); 
            }// end of for 
              System.debug('plbs.Type_of_Year__c$$ '+plbs.Type_of_Year__c);
               if(plbs.Type_of_Year__c=='Provisional')
                  plbs.Previous_Year__c=current;
                if(plbs.Type_of_Year__c=='Current')
                  plbs.Previous_Year__c=previous;
             /*   if(plbs.Type_of_Year__c=='Previous')
                  plbs.Previous_Year__c=previous; To add /*'
                  if(plbs.Type_of_Year__c=='Previous')
                  plbs.Previous_Year__c=previousToPrevious;// Added to handle the previous to previous year case
            }// end of if 
            */ // Removed psbll
            System.debug('plbs.Previous_Year__c%%'+plbs.Previous_Year__c);
            System.debug('PLBS %%%'+plbs);
          // if the product is not psbl
        //if ( plbs.Product__C!='PSBL') {        
            for(integer i=0;i<PLBSs.size();i++){              
                  if (PLBSs[i].Type_of_Year__c=='Current' && PLBSs[i].Year_Type__C=='Previous' &&  PLBSs[i].Loan_App__c==plbs.Loan_App__c   && PLBSs[i].Applicant__c==plbs.Applicant__c ) {
                      current=PLBSs[i].Id;              
                  } 
                  if (PLBSs[i].Type_of_Year__c=='Current'  &&  PLBSs[i].Year_Type__C=='Current' &&  PLBSs[i].Loan_App__c==plbs.Loan_App__c   && PLBSs[i].Applicant__c==plbs.Applicant__c ) {
                      current=PLBSs[i].Id;              
                  } 
                         
                  
                  if (PLBSs[i].Type_of_Year__c=='Previous'  &&   PLBSs[i].Year_Type__C=='Previous' && PLBSs[i].Loan_App__c==plbs.Loan_App__c  && PLBSs[i].Applicant__c==plbs.Applicant__c) {
                      previous=PLBSs[i].Id;              
                  } 
                 if (PLBSs[i].Type_of_Year__c=='Previous'  &&   PLBSs[i].Year_Type__C=='PreviousToPrevious' && PLBSs[i].Loan_App__c==plbs.Loan_App__c  && PLBSs[i].Applicant__c==plbs.Applicant__c) {
                      previous=PLBSs[i].Id;              
                  } 
                  
                  if (PLBSs[i].Type_of_Year__c=='PreviousToPrevious'  &&   PLBSs[i].Year_Type__C=='PreviousToPrevious' && PLBSs[i].Loan_App__c==plbs.Loan_App__c  && PLBSs[i].Applicant__c==plbs.Applicant__c) {
                      previousToPrevious=PLBSs[i].Id;              
                  }  
                 if (PLBSs[i].Type_of_Year__c=='Provisional'  &&  PLBSs[i].Year_Type__C=='Provisional' &&  PLBSs[i].Loan_App__c==plbs.Loan_App__c   && PLBSs[i].Applicant__c==plbs.Applicant__c ) {
                      provisional=PLBSs[i].Id;              
                  } 
                  
                  
                                 
                 if (PLBSs[i].Type_of_Year__c=='CurrSummary'  &&  PLBSs[i].Loan_App__c==plbs.Loan_App__c   ) {
                      currSummary=PLBSs[i].Id;              
                 } 
                 if (PLBSs[i].Type_of_Year__c=='PrevSummary'  &&  PLBSs[i].Loan_App__c==plbs.Loan_App__c  ) {
                      prevSummary=PLBSs[i].Id;              
                 }
                 if (PLBSs[i].Type_of_Year__c=='PrevToPrevSummary'  &&  PLBSs[i].Loan_App__c==plbs.Loan_App__c  ) {
                      prevToPrevSummary=PLBSs[i].Id;              
                 } 
                 if (PLBSs[i].Type_of_Year__c=='ProvSummary'  &&  PLBSs[i].Loan_App__c==plbs.Loan_App__c  ) {
                      prevToPrevSummary=PLBSs[i].Id;              
                 }                    
            }// end of for 
               if(plbs.Type_of_Year__c=='Provisional'){
                 plbs.Previous_Year__c=current;
                 plbs.PreviousToPrevious_Year__c = previous;
               }  
               if(plbs.Type_of_Year__c=='Current'){
                plbs.Previous_Year__c=previous;
                plbs.Provisional__c = provisional;
                plbs.PreviousToPrevious_Year__c = previousToPrevious;
               } 
               if(plbs.Type_of_Year__c=='Previous'){
                plbs.Previous_Year__c=previousToPrevious;
                plbs.Provisional__c = current;
               }
               if(plbs.Type_of_Year__c=='PreviousToPrevious'){
                plbs.Provisional__c = previous;
               }                   
                
                  if(plbs.Type_of_Year__c=='ProvSummary')
                plbs.Previous_Year__c=currSummary;
                  if(plbs.Type_of_Year__c=='CurrSummary')
                plbs.Previous_Year__c=prevSummary;
                  if(plbs.Type_of_Year__c=='PrevSummary')//Added for p2p
                plbs.Previous_Year__c=prevToPrevSummary;//added for p2p
     
          //}// end of if 
     
     }
    //update the records
    ControlRecursiveCallofTrigger_Util.setalreadyExecutedYearUpdate();
     update plRecords;
     System.debug('Updated Values on year update Trg### '+plRecords);
       //getting all deviation calculator records  
      devCalc=[Select Id,PL_BS__c,Loan_Application__c,product__c from Deviation_Calculator__c
      where Loan_Application__c in:loanids];
      //updating the current year Id  
      for(integer k=0;k<devCalc.size();k++){
      Id current;
      System.debug(devCalc[k]);
       //3371
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
        /*Start BUG-16959 added by sainath*/
        boolean isPSBLProductLineProduct = false;  
        transient string PSBLProductLineProducts = Label.PSBL_ProductLine_Products;
        if(PSBLProductLineProducts != null && PSBLProductLineProducts != '' )
        {
            set < string > setPSBLProdName = new set < string > ();
            setPSBLProdName.addAll(PSBLProductLineProducts.split(';'));
            if (setPSBLProdName != null && setPSBLProdName.size() > 0 && devCalc[k] != null && devCalc[k].Product__c != null) 
            {
                if(setPSBLProdName.contains(devCalc[k].Product__c.toUpperCase()))
                isPSBLProductLineProduct = true; 
            }
        }
        /*End BUG-16959*/        
        //for psbl
           if ( /*Bug: 16959 S*/ isPSBLProductLineProduct /*Bug: 16959 E*/  || devCalc[k].Product__C=='DOCTORS' || DOCProducts.contains(devCalc[k].Product__c.toUppercase()) || devCalc[k].Product__C=='RDL') {        
               for(integer i=0;i<PLBSs.size();i++){
                if (PLBSs[i].Type_of_Year__c=='CurrSummary'  &&  PLBSs[i].Loan_App__c==devCalc[k].Loan_Application__c) {
                      current=PLBSs[i].Id;              
                    } 
               } 
            }
         // if not psbl
          if ( /*Bug: 16959 S*/ !isPSBLProductLineProduct /*Bug: 16959 E*/  && devcalc[k].Product__C!='DOCTORS' && !DOCProducts.contains(devcalc[k].Product__c.toUppercase()) && devcalc[k].Product__C!='RDL') {
    
    
    ///////////Code added by Raji
    integer applicantCount=0,currentCount=0,flag1=0;
    for(integer i=0;i<PLBSs.size();i++){                                       
               if (PLBSs[i].Applicant__c!=null  && PLBSs[i].Type_of_Year__c=='Provisional' && PLBSs[i].Loan_App__c==devCalc[k].Loan_Application__c   ) {
                     applicantCount=applicantCount+1; 
                    if(PLBSs[i].Year_Type__C=='Current')
                    currentCount=currentCount+1; 
                 
               }                
            }// end of for 
    
    // if all the records are in current,previous format
    if(applicantCount==currentCount)
    flag1=1;
     
    
            
              for(integer i=0;i<PLBSs.size();i++){  
              if(flag1==1){                                     
                          if (PLBSs[i].Type_of_Year__c=='ProvSummary'  &&  PLBSs[i].Loan_App__c==devCalc[k].Loan_Application__c   ) {
                          current=PLBSs[i].Id;              
                           } 
              }  
              else{
    
                          if (PLBSs[i].Type_of_Year__c=='CurrSummary'  &&  PLBSs[i].Loan_App__c==devCalc[k].Loan_Application__c   ) {
                          current=PLBSs[i].Id;              
                           } 
    
               }             
            }// end of for 
    }               
      devCalc[k].PL_BS__c=current;
    }
     // updating deviation calculator 
      if( devCalc.size()>0){
          ControlRecursiveCallofTrigger_Util.setalreadyExecutedYearUpdate();
          update devCalc;
      } 
  }
}