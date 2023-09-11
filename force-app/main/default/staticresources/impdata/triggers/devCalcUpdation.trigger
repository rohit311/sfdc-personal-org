/** 

* File Name: devCalcUpdation

* Description: This trigger is used to update

* CAM Id in devcalculator

* Copyright : Wipro Technologies Limited Copyright (c) 2010 * 

* @author : Wipro

* Modification Log 

* =============================================================== 

* Ver   Date        Author      Modification 

* --- ---- ------ ------------- ---------------------------------

* 1.0   10-Feb-10  Raji Created 

*/ 
trigger devCalcUpdation on CAM__c (after insert,after update) {
static Set<id> LoanIdsSet = new Set<id>(); // 24313
static List<Opportunity> oppLstSt;// 24313
if (!ControlRecursiveCallofTrigger_Util.hasdevCalcUpdat()) {
      ControlRecursiveCallofTrigger_Util.setdevCalcUpdat();
      
    Id LoanId;
    Id approvedCAM;
    integer PLBScount;
    double emi;
    List<id> loanIdsMob= new List<Id>(); //Retrigger 20939    
    List<PL_BS__c> PLBS = new List<PL_BS__c>();
    Map<Id,Decimal>CAMMap = new Map<Id,Decimal>();
    Map<Id,Id>CAMIdMap = new Map<Id,Id>();
    Map<Id,Id>CAMIdMapNew = new Map<Id,Id>();
    List<id> LoanIds= new List<Id>();
    List<id> LoanIdsNew= new List<Id>();
    /*Start: Bug:16959 added by sainath*/
    boolean isPSBLProductLineProduct = false;
    /*End: Bug:16959*/
    
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
    
    List<Deviation_Calculator__c> devCalc=new List<Deviation_Calculator__c>{};
    //CAMDetails_AC CAMcalc = new CAMDetails_AC();  
        for(CAM__c cam:trigger.new){
                    

            if(CAM.product__c !='PSBL' && CAM.product__c !='DOCTORS' && !DOCProducts.contains(CAM.Product__c.toUppercase()) && CAM.product__c !='RDL'){
            LoanIdsNew.add(cam.Loan_Application__c);
            CAMIdMapNew.put(cam.Loan_Application__c,cam.Id);
            }
            /*Start BUG-16959 added by sainath*/
            isPSBLProductLineProduct = getPSBLorDBOLProductLineFlag(CAM.product__c);
            /*End BUG-16959*/
            if(cam.Approved_CAM__c==true  && (/*Bug: 16959 S*/ isPSBLProductLineProduct /*Bug: 16959 E*/ || CAM.product__c =='DOCTORS' || DOCProducts.contains(CAM.Product__c.toUppercase()) || CAM.product__c =='RDL')){
            approvedCAM=cam.Id;
            LoanId=cam.Loan_Application__c;
            LoanIds.add(LoanId);
            emi=cam.EMI_on_Proposed_Loan_TO__c;
            CAMMap.put(cam.Loan_Application__c,emi);
            CAMIdMap.put(cam.Loan_Application__c,cam.Id);
            }
        }//end of for
     
        
      if(LoanIds.size()>0){
      try{
      PLBS=[select id,name, EMI__c,Loan_App__c from PL_BS__c where Loan_App__c in :loanids];
      for(integer i=0;i<PLBS.size();i++){
      PLBS[i].EMI__c=CAMMap.get(PLBS[i].Loan_App__c);
      }
      if(PLBS.size()>0)
      update PLBS;
      }// end of try
      catch(Exception e){}
      }// end of if
     System.debug('$$$$$$$$$$$$$'+ LoanIds.size()+'***'+LoanIdsNew.size());
        if(LoanIds.size()>0   ||    LoanIdsNew.size()>0 ){
          try{
          devCalc=[Select Id,CAM__c,Loan_Application__c,product__C from Deviation_Calculator__c
          where (Loan_Application__c in :loanids or     Loan_Application__c in : LoanIdsNew )
           and cam__C =null];
              for(integer k=0;k<devCalc.size();k++){
                /*Start BUG-16959 added by sainath*/
                isPSBLProductLineProduct = getPSBLorDBOLProductLineFlag(devCalc[k].product__c);
                /*End BUG-16959*/
                if(/*Bug: 16959 S*/ isPSBLProductLineProduct /*Bug: 16959 E*/ || devCalc[k].product__C=='DOCTORS' || DOCProducts.contains(devCalc[k].Product__c.toUppercase()) || devCalc[k].product__C=='RDL')
                devCalc[k].CAM__c=CAMIdMap.get(devCalc[k].Loan_Application__c);
                ELSE
                devCalc[k].CAM__c=CAMIdMapNew.get(devCalc[k].Loan_Application__c);
              }
            if( devCalc.size()>0)
              update devCalc;
            }
            catch(Exception e){}    
        }     
                  
} //End of Recur
    /*Retrigger BRE 20939 s */
    if(Trigger.isUpdate && Trigger.isAfter){
        if (!ControlRecursiveCallofTrigger_Util.hasdevCalcUpdateTrig()) {
            ControlRecursiveCallofTrigger_Util.setdevCalcUpdateTrig();
            List<id> loanIdsMob= new List<Id>(); //Retrigger 20939
            for(CAM__c cam:trigger.new){
                loanIdsMob.add(cam.Loan_Application__c); //Retrigger 20939
				LoanIdsSet.add(cam.Loan_Application__c);//24313	
            }
            Map<Id, Opportunity> oppMap;
            if(!CommonUtility.isEmpty(LoanIdsSet)){
                /*List<Opportunity> oppLst = [select Account.Flow__c,Account.Offer_Inhanced__c,id, product__C,Account.IS_OTP_FLOW__c, CreatedDate,
                                            (select id,name,Old_Loan_Application__c,Policy_Name__c,Remarks__c,Disposition_Status__c,Checklist_Policy_Status__c from SOL_Policys__r),
                                            (Select  id,product__c,Type_of_Year__c from PLBS__r where Type_of_Year__c='Current' or Type_of_Year__c='Previous' or Type_of_Year__c='PrevSummary' or Type_of_Year__c='CurrSummary')
                                            from Opportunity where id in : loanIdsMob];*/
				oppLstSt = GeneralUtilities.getOpportunities(LoanIdsSet);//Bug 24313
                List<Opportunity> oppLst = oppLstSt; //Bug 24313
                if(!CommonUtility.isEmpty(oppLst)){
                    oppMap = new Map<Id, Opportunity>();
                    for(Opportunity opp : oppLst)
                        oppMap.put(opp.Id,opp);
                }
            }
            Map<String,Object> allMap = new Map<String,Object>();
            
            allMap = GeneralUtilities.fetchRetriggerRescMap();
            Map<String,SOL_Policy__c> solPolicyToUpdateMap = new map<String,SOL_Policy__c>();
            for(CAM__c cam:trigger.new){
                Opportunity Loan = new Opportunity();
                if(oppMap != null && oppMap.containsKey(cam.Loan_Application__c) && oppMap.get(cam.Loan_Application__c) != null){
                    Loan = oppMap.get(cam.Loan_Application__c);
                }
                
                system.debug('in mobility'+Loan.Account.Flow__c);
                if(Loan != null && Loan.Account.Flow__c == 'Mobility V2'){
                    Map<String,Object> appFields = new Map<String,Object>();
                    
                    if(!commonutility.isEmpty(allMap)){
                        appFields = (Map<String,Object>)allMap.get('CAM__c');
                        System.debug('Hi'+appFields );
                        if(!commonutility.isEmpty(appFields)){
                            solPolicyToUpdateMap = GeneralUtilities.reTriggerBREGen(Trigger.oldmap.get(cam.Id),cam,Loan,appFields,solPolicyToUpdateMap);
                            
                        }
                    }
                }
                
            }
            if(solPolicyToUpdateMap != null && solPolicyToUpdateMap.size() > 0){
                update solPolicyToUpdateMap.values();
            }
        }
    }  
        /*Retrigger BRE 20939 e */
    /*Start BUG-16959 added by sainath*/
    public boolean getPSBLorDBOLProductLineFlag(String product){
        boolean isPSBLProductLineProduct1 = false;
        transient string PSBLProductLineProducts = Label.PSBL_ProductLine_Products;
        if(PSBLProductLineProducts != null && PSBLProductLineProducts != '' )
        {
            set < string > setPSBLProdName = new set < string > ();
            setPSBLProdName.addAll(PSBLProductLineProducts.split(';'));
            if (setPSBLProdName != null && setPSBLProdName.size() > 0 && product !='' && product != null ) 
            {
                if(setPSBLProdName.contains(product.toUpperCase()))
                    isPSBLProductLineProduct1 = true;
            }
        }
      return isPSBLProductLineProduct1;
    }
    /*End BUG-16959*/ 
    //Bug:24598**S
    if((Label.Enable_new_flow_for_sourcing_Channel.equalsIgnoreCase('TRUE') && trigger.isAfter) && (trigger.isinsert || trigger.isupdate)) {
        list<Opportunity> loanDetails = new  list<Opportunity>();
        if(!ControlRecursiveCallofTrigger_Util.getsourcingChannel() && Trigger.New[0].Loan_Application__c!=null ){
            loanDetails = [Select Id,Product__c,Sourcing_Channel__c,Sourcing_Channel__r.Name,Sour_Channel_Name__c From Opportunity WHERE
                           id = : Trigger.New[0].Loan_Application__c];
           
            system.debug('Cam Query executed****');
            ControlRecursiveCallofTrigger_Util.setsourcingChannel();
            List<Opportunity> oppList = new List<Opportunity>();
            //Opportunity opp =new Opportunity();
            for( CAM__c cam : trigger.new){
                if(loanDetails!=null && loanDetails.size()>0 && (loanDetails[0].Sourcing_Channel__c != null &&
                   !(Label.Sourcing_Channel.equalsIgnoreCase(loanDetails[0].Sour_Channel_Name__c)))){
                 	if(cam.ROI__c!=Null){
                    	loanDetails[0].Approved_Rate__c=cam.ROI__c;
                        loanDetails[0].Requested_ROI__c=cam.ROI__c;
                        oppList.add(loanDetails[0]);
                    }
               }
            }  
            
            if(oppList != Null && oppList.size() > 0){
                update oppList;
            }
        }
        
        
    }
    //Bug:24598**E
} //end of trigger