trigger PLBSassign_BI_BU on CAM__c (before insert,before update) {

if (!ControlRecursiveCallofTrigger_Util.hasPLBSassign()) {
      ControlRecursiveCallofTrigger_Util.setPLBSassign();

    Id PLBSPreviousYear,PLBSCurrentYear;  
    List<PL_BS__c> plbs= new List<PL_BS__c>();
    Id LoanId;
    DateTime currentDate; 
    Double rate=0;
    String nperString;
    Double pmt=0;
    Double pv=0;
    Double prempv=0;
    Decimal nper1=0.0;
    integer nper;
        Opportunity Loan = new Opportunity();
    
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
     //end   
    
  //added for digital grid
    Set<String> prods = new Set<String>();
    String labelProd = '';
    Boolean digitalFlow = false;
    labelProd = label.digitalProducts;
    for(String s: labelProd.split(',')){
        prods.add(s.toUppercase());
    }
/*Added for New prodcut creation HDL-Bug 1256- Start*/
      String labelLAPProducts = '';
      Set<String> LAPprods = new Set<String>(); 
/*Added for New prodcut creation HDL -Bug 1256-END*/
    //CAMDetails_AC CAMcalc = new CAMDetails_AC();  
    //harsit---------optimization START
    Set<ID> oppIDs = new SET<ID>();
    for(CAM__c cam : Trigger.New){
        oppIDs.add(cam.Loan_Application__c);
    }
    Map<Id, Opportunity> oppMap;
    if(!CommonUtility.isEmpty(oppIDs)){
        List<Opportunity> oppLst = [select id, product__C,Account.IS_OTP_FLOW__c, CreatedDate,
                                    (Select  id,product__c,Type_of_Year__c from PLBS__r where Type_of_Year__c='Current' or Type_of_Year__c='Previous' or Type_of_Year__c='PrevSummary' or Type_of_Year__c='CurrSummary')
                                    from Opportunity where id in : oppIDs];
        if(!CommonUtility.isEmpty(oppLst)){
            oppMap = new Map<Id, Opportunity>();
            for(Opportunity opp : oppLst)
                oppMap.put(opp.Id,opp);
        }
    }
    
    CAMDetails_AC CAMcalc;








     //harsit---------optimization END
    for(CAM__c cam:trigger.new){
        LoanId=cam.Loan_Application__c;
            //harsit---------optimization START
            //getting the opp Record through map
            /*List < Opportunity > opplist = new List < Opportunity > ();
            opplist = [select id, product__C, CreatedDate from Opportunity where id = : LoanId];
            if (opplist != null && opplist.size() > 0) Loan = opplist[0];*/
             
            if(oppMap != null && oppMap.containsKey(LoanId) && oppMap.get(LoanId) != null)
                Loan = oppMap.get(LoanId);
            
            //harsit---------optimization END
        //added for digital grid
        if(prods.contains(Loan.Product__c))
          digitalFlow = true;    
        System.debug('*****digitalFlow: '+digitalFlow);
        
        
        currentDate=Loan.CreatedDate;
        if(digitalFlow || loan.product__c=='PSBL' || loan.product__c == 'DOCTORS' || DOCProducts.contains(loan.Product__c.toUppercase()) || loan.product__c == 'RDL'|| loan.product__c=='SBS CS PSBL'){
                if(cam.IRR_TO__c!=null)
                rate=(cam.IRR_TO__c)/1200;
                else if(cam.ROI__c!=null)
                rate=(cam.ROI__c)/1200;
                if(cam.Max_Perm_Annl_EMI__c!=null)
                pmt=(cam.Max_Perm_Annl_EMI__c)/12;
                if(cam.Tenor__c!=null){
                 nper1=cam.Tenor__c;
                 nper=nper1.intvalue();
                }
                pv=cam.Proposed_Loan_Amt__c;
                prempv=cam.Loan_Amt_Premium__c;
                
                System.debug('********pmt*****************'+pmt);
                
                CAMcalc = new CAMDetails_AC(); 
                CAM.Total_dep_NP__c=CAM.TOTAL__c;
                CAM.TOTAL_NP__c=CAM.Total_Inc_Depr__c;
                CAM.TO_Final_Loan_code__c=CAM.TO_Final_Loan_Hidden__c;
                CAM.Avg_Mthly_Net_Inc1__c=CAM.Avg_Mthly_Net_Inc__c;
                System.debug('********(rate,nper,pmt)*****************'+rate+'   nper : '+nper);
                if((rate!=null)&&(rate!=0)&&(nper!=null)){
                    if(pmt!=null)
                        CAM.Loan_elig_TO__c=CAMcalc.PV(rate,nper,pmt);
                    if(pv!=null)
                        CAM.EMI_on_Proposed_Loan_TO__c=CAMcalc.PMT(rate,nper,pv);
                    if(CAM.Premium_Amount_TO__c!=null)
                        CAM.EMI_with_Insurance_Premium_TO__c=CAMcalc.PMT(rate,nper,prempv);
                }
                System.debug('********CAM.Loan_elig_TO__c************'+CAM.Loan_elig_TO__c);

      }   
        try{
           plbs= Loan.PLBS__r;
           //Condition added by mahima for RLP- rural Dss- 13485
            if(!CommonUtility.isEmpty(plbs)){  
                for(integer i=0;i<plbs.size();i++){
                    if((digitalFlow || plbs[i].product__C=='PSBL' || plbs[i].product__C=='DOCTORS' || DOCProducts.contains(plbs[i].Product__c.toUppercase()) || plbs[i].product__C=='RDL'|| plbs[i].product__C=='SBS CS PSBL') && plbs[i].Type_of_Year__c=='CurrSummary' ) //  Current
                      PLBSCurrentYear=plbs[i].Id;
                    if((digitalFlow || plbs[i].product__C=='PSBL' || plbs[i].product__C=='DOCTORS' || DOCProducts.contains(plbs[i].Product__c.toUppercase()) || plbs[i].product__C=='RDL'|| plbs[i].product__C=='SBS CS PSBL') && plbs[i].Type_of_Year__c=='PrevSummary' ) //  Previous
                      PLBSPreviousYear=plbs[i].Id;
                    if((plbs[i].product__C=='Home Loan' || plbs[i].product__C=='LAP' || plbs[i].product__C=='RLP' || LAPprods.contains( plbs[i].product__C.toUppercase()) || plbs[i].product__C=='SBS CS LAP' || plbs[i].product__C=='SBS CS HL')  && plbs[i].Type_of_Year__c=='CurrSummary' )
                      PLBSCurrentYear=plbs[i].Id;
                    if((plbs[i].product__C=='Home Loan' || plbs[i].product__C=='LAP' || plbs[i].product__C=='RLP' || LAPprods.contains( plbs[i].product__C.toUppercase())|| plbs[i].product__C=='SBS CS LAP' || plbs[i].product__C=='SBS CS HL')  && plbs[i].Type_of_Year__c=='PrevSummary' )
                      PLBSPreviousYear=plbs[i].Id;    
                }   
                if( PLBSPreviousYear !=null)
                    CAM.Previous_Year_PLBS__c=PLBSPreviousYear;
                if(PLBSCurrentYear !=null)
                    CAM.Current_Year_PLBS__c=PLBSCurrentYear;
            }   
        }
        catch(Exception e){}      
    }

    //harsit---------optimization START
   //Merged all the below commented code in above 'for' iteration
  /*try{
   plbs=[Select  id,product__c,Type_of_Year__c from PL_BS__c where Loan_App__c=:LoanId and 
        (Type_of_Year__c='Current' or   Type_of_Year__c='Previous'
       or   Type_of_Year__c='PrevSummary' or   Type_of_Year__c='CurrSummary')];
   //Added for New prodcut creation HDL-Bug 1256- Start     
        // LAPproductsflowFlag = false ;
      labelLAPProducts = label.LAP_Products;       
          for(String s: labelLAPProducts.split(';')){
                LAPprods.add(s.toUppercase());
           }
          
          //Added for New prodcut creation HDL -Bug 1256-END
   for(integer i=0;i<plbs.size();i++){
      if((digitalFlow || plbs[i].product__C=='PSBL' || plbs[i].product__C=='DOCTORS' || DOCProducts.contains(plbs[i].Product__c.toUppercase()) || plbs[i].product__C=='RDL'|| plbs[i].product__C=='SBS CS PSBL') && plbs[i].Type_of_Year__c=='CurrSummary' ) //  Current
      PLBSCurrentYear=plbs[i].Id;
      if((digitalFlow || plbs[i].product__C=='PSBL' || plbs[i].product__C=='DOCTORS' || DOCProducts.contains(plbs[i].Product__c.toUppercase()) || plbs[i].product__C=='RDL'|| plbs[i].product__C=='SBS CS PSBL') && plbs[i].Type_of_Year__c=='PrevSummary' ) //  Previous
      PLBSPreviousYear=plbs[i].Id;
      if((plbs[i].product__C=='Home Loan' || plbs[i].product__C=='LAP' || LAPprods.contains( plbs[i].product__C.toUppercase()) || plbs[i].product__C=='SBS CS LAP' || plbs[i].product__C=='SBS CS HL')  && plbs[i].Type_of_Year__c=='CurrSummary' )
      PLBSCurrentYear=plbs[i].Id;
      if((plbs[i].product__C=='Home Loan' || plbs[i].product__C=='LAP' || LAPprods.contains( plbs[i].product__C.toUppercase())|| plbs[i].product__C=='SBS CS LAP' || plbs[i].product__C=='SBS CS HL')  && plbs[i].Type_of_Year__c=='PrevSummary' )
      PLBSPreviousYear=plbs[i].Id;    
      }   
   }
   catch(Exception e){} 
   
    for(CAM__c CAM:trigger.new){
        if( PLBSPreviousYear !=null)
        CAM.Previous_Year_PLBS__c=PLBSPreviousYear;
        if(PLBSCurrentYear !=null)
        CAM.Current_Year_PLBS__c=PLBSCurrentYear;
        
        if(digitalFlow || loan.product__c=='PSBL' || loan.product__c=='DOCTORS' || DOCProducts.contains(loan.Product__c.toUppercase()) || loan.product__c=='RDL'|| loan.product__c=='SBS CS PSBL'){
                CAMDetails_AC CAMcalc = new CAMDetails_AC(); 
                CAM.Total_dep_NP__c=CAM.TOTAL__c;
                CAM.TOTAL_NP__c=CAM.Total_Inc_Depr__c;
                CAM.TO_Final_Loan_code__c=CAM.TO_Final_Loan_Hidden__c;
                CAM.Avg_Mthly_Net_Inc1__c=CAM.Avg_Mthly_Net_Inc__c;
                System.debug('********(rate,nper,pmt)*****************'+rate+'   nper : '+nper);
                    if((rate!=null)&&(rate!=0)&&(nper!=null)){
                    if(pmt!=null)
                        CAM.Loan_elig_TO__c=CAMcalc.PV(rate,nper,pmt);
                    if(pv!=null)
                        CAM.EMI_on_Proposed_Loan_TO__c=CAMcalc.PMT(rate,nper,pv);
                    if(CAM.Premium_Amount_TO__c!=null)
                        CAM.EMI_with_Insurance_Premium_TO__c=CAMcalc.PMT(rate,nper,prempv);
                    }
                    System.debug('********CAM.Loan_elig_TO__c************'+CAM.Loan_elig_TO__c);
                }   // FOR PSBL
                
      
    }
     */
    //harsit---------optimization END    
    //New code for income field in OTP 
       if(Trigger.isUpdate && Trigger.isBefore){
            for(CAM__c cam:Trigger.new){
                //harsit---------optimization START
                 /*List<Opportunity> opplist = new List<Opportunity>();
                 if(cam.Loan_Application__c!=null)
                 opplist =  [select Account.IS_OTP_FLOW__c,  id, Product__c from Opportunity where id=:cam.Loan_Application__c];*/
                
                if(oppMap != null && oppMap.containsKey(cam.Loan_Application__c) && oppMap.get(cam.Loan_Application__c) != null)
                    Loan = oppMap.get(LoanId);

                System.debug('**opplist *****'+Loan);
                if(Loan!=null){
                //Bug Id : 17501 SHL change
                boolean isSHOLProductLineProduct = false;  
                transient string SHOLProductLineProducts = Label.SHOL_ProductLine_Products;
                if(SHOLProductLineProducts != null && SHOLProductLineProducts != '' )
                {
                    set < string > setSHOLProdName = new set < string > ();
                    setSHOLProdName.addAll(SHOLProductLineProducts.split(';'));
                    if (setSHOLProdName != null && setSHOLProdName.size() > 0 && Loan != null && Loan.product__c != null) 
                    {
                        if(setSHOLProdName.contains(Loan.product__c))
                        isSHOLProductLineProduct = true; 
                    }
                }
                
                        if(Loan.Account.IS_OTP_FLOW__c== true && !CommonUtility.isEmpty(Loan.product__c) && !(isSHOLProductLineProduct || Loan.product__c == 'SOL')){  //SHOL backend changes
                            if(cam.Avg_Net_Sal__c!=null && cam.Monthly_Reimbursement__c!=null)
                                cam.Average_Monthly_Net_Income2__c = cam.Avg_Net_Sal__c + cam.Monthly_Reimbursement__c;
                        }else{
                            if(cam.Avg_Net_Sal__c!=null && cam.Monthly_Reimbursement__c!=null && cam.Avg_mthly_incntve_3mts__c!=null)
                            cam.Average_Monthly_Net_Income2__c = cam.Avg_Net_Sal__c + cam.Monthly_Reimbursement__c +cam.Avg_mthly_incntve_3mts__c;
                            System.debug('**onthly_Net_Income2__c**'+  cam.Average_Monthly_Net_Income2__c);
                        }
                }
                //harsit---------optimization END
            }
       }
    }// End Recur
}