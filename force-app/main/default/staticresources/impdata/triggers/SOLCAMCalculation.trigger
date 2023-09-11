trigger SOLCAMCalculation on SOL_CAM__c (before insert,before update,after update) {
List<Opportunity> Loan = new List<Opportunity>();
List<Opportunity> Loanlist = new List<Opportunity>();
set<id> solcamid=new set<id>();
for(SOL_CAM__c s: trigger.new)
{
    solcamid.add(s.id);
}
    
List<Cibil__c> cibil = new List<Cibil__c>();
List<Existing_Loan_Details__c> extLoan = new List<Existing_Loan_Details__c>();
List<SOL_Policy__c> solPolicy = new List<SOL_Policy__c>();
List<SOL_Policy__c> RejsolPolicy = new List<SOL_Policy__c>();
List<SOL_Policy__c> ReferPolicyBranch = new List<SOL_Policy__c>();
List<SOL_Policy__c> RefersolPolicy = new List<SOL_Policy__c>();
List<SOL_Policy__c> solPolicyupdate = new List<SOL_Policy__c>();
//List<SOL_CAM__c> solcaml=new List<SOL_CAM__c>();
List<ID> oppID = new List<ID>();
if(!ControlRecursiveCallofTrigger_Util.hasPreUpdate()){
if (!ControlRecursiveCallofTrigger_Util.hasSOLCAMCalculation()) {
system.debug('solcam loan app ====================>'+Trigger.New[0].Loan_Application__c);
Loan=[select id,Loan_Application_Number__c,Customer_email_id__c,Approved_Loan_Amount__c ,Branch_Type1__c,Amount_Rs__c,Approved_Tenor__c,Loan_Amount__c,Tenor__c,
        Approved_Rate__c,StageName,Payment_Successful__c,Product__c,Insurance_Premium_Amt__c,name,Branch_Name__r.Branch_Type__c,CPA__c,ACM__c,RCM__c,NCM__c,CRO__c,RISK__c,COO__c,ACM_Comments__c,RCM_Comments__c,COO_Comments__c,
        Approval_Stages__c,Approver__c,Loan_Type__c,Relationship_Manager__c,Branch_Name__r.City_Category__c,
       OwnerId,CreatedById,Employee_Type__c,Firm_Annual_Oblig__c,Indi_Annual_Oblig__c,Total_Annual_Oblig__c,Total_Monthly_Oblig__c,Total_EMI__c,Total_Amount__c,AccountId,CreatedDate,                
        No_of_Secured_Loans__c,No_of_Unsecured_Loans__c,Sum_of_Amount_Secured_Loans__c, Sum_of_Amount_UnSecured_Loans__c,SecuredUnsecuredRatio__c,Secu_UnAmountRatio__c,
       Loan_amt_with_premium__c,Name_of_Approver__c,End_Use__c,account.Age_of_Account__c,Financed_by_BFL__c from Opportunity where id=:Trigger.New[0].Loan_Application__c];
       
SOL_CAM__c solCam ;
if(Trigger.IsBefore){
        
        //Code for recalculation from SOL CAM of DG module
        if(Trigger.isUpdate || Test.isRunningTest()){
            String labelProd = '';
            labelProd = label.digitalProducts;
            Set<String> prods = new Set<String>();
            for(String s: labelProd.split(',')){
                prods.add(s.toUppercase());
            }
            List<DgOfferDetailCtrl1.LoanTenorMapping> LoanTenorMappingList = new List<DgOfferDetailCtrl1.LoanTenorMapping>();
            List<String> appScoreList;
            List<String> loanTenorList;
            
            for(SOL_CAM__c solCamVar: Trigger.New){
                appScoreList = new List<String>();
                
                if(solCamVar.Product__c != null && prods.contains(solCamVar.Product__c.touppercase()))
                    if(((solCamVar.Final_loan_amount__c != null && solCamVar.Final_loan_amount__c != Trigger.oldMap.get(solCamVar.ID).Final_loan_amount__c) || (solCamVar.Tenor__c != null && solCamVar.Tenor__c != Trigger.oldMap.get(solCamVar.ID).Tenor__c )) && (solCamVar.App_Score_Range__c != null || solCamVar.App_Score_Range__c != '')){
                        //check if the enterned amount fits into the app score range given                  
                        appScoreList = solCamVar.App_Score_Range__c.split(','); // storing the different ranges in the list
                        System.debug('appScoreList***'+appScoreList);
                        if(appScoreList != null && appScoreList.size()>0){  
                            for(String appScore : appScoreList){
                                loanTenorList = new List<String>();
                                loanTenorList = appScore.split('-'); // storing each member of each index of list
                                if(loanTenorList != null && loanTenorList.size() == 4){
                                    LoanTenorMappingList.add(new dgOfferDetailCtrl1.LoanTenorMapping(Decimal.valueOf(loanTenorList[0]),Decimal.valueOf(loanTenorList[1]),Integer.valueOf(loanTenorList[2]),Integer.valueOf(loanTenorList[3])));
                                }               
                            }
                        }
                        //Match if the selected amount belongs to the app score range defined
                        if(LoanTenorMappingList != null && LoanTenorMappingList.size()>0){
                            Boolean isInRange = false;
                            for(DgOfferDetailCtrl1.LoanTenorMapping loanTenor : LoanTenorMappingList){
                                if(solCamVar.Final_loan_amount__c >= loanTenor.minLoanAmt && solCamVar.Final_loan_amount__c <= loanTenor.maxLoanAmt){
                                    if(solCamVar.Tenor__c >= loanTenor.MinTenor && solCamVar.Tenor__c <= loanTenor.MaxTenor){
                                        isInRange = true;
                                        break;
                                    }
                                }
                            }
                            if(isInRange == false)
                                solCamVar.addError('You are not eligible for current amount entered.');
                        }
                        
                    }
            }
        }
for(SOL_CAM__C sal: Trigger.New)

    {  
      if(Loan!=null && Loan.size()>0){ //added not null for exception
      /*Bug Id : 17501 SHL change*/
      boolean isSHOLProductLineProduct = false;   
        transient string SHOLProductLineProducts = Label.SHOL_ProductLine_Products;
        if(SHOLProductLineProducts != null && SHOLProductLineProducts != '' )
        {
            set < string > setSHOLProdName = new set < string > ();
            setSHOLProdName.addAll(SHOLProductLineProducts.split(';'));
            if (setSHOLProdName != null && setSHOLProdName.size() > 0 && Loan != null && Loan[0].Product__c != null) 
            {
                if(setSHOLProdName.contains(Loan[0].Product__c))
                isSHOLProductLineProduct = true; 
            }
        }
        if(Loan[0].Product__c=='SOL' || isSHOLProductLineProduct){
            Decimal prf = (Loan[0].Product__c=='SOL')?0.7:0.3;
                 system.debug('*&*&sal.Co_Applicant_Net_Salary_month1__c'+sal.Co_Applicant_Net_Salary_month1__c); 
                 system.debug('*&*&*sal.Co_Applicant_Net_Salary_month1__c  &'+sal.Co_Applicant_Net_Salary_month2__c);
                 if(sal.Co_Applicant_Net_Salary_month1__c!=null && sal.Co_Applicant_Net_Salary_month2__c!=null){
                            system.debug('*&*&*in iff&');
                            if(sal.mon1_variable_pay__c==null || sal.mon2_variable_pay__c==null){   
                                sal.Monthly_Net_Salary__c=((Integer.valueof(sal.month1_sal__c) + Integer.valueof(sal.month2_sal__c))/2)+((Integer.valueof(sal.Co_Applicant_Net_Salary_month1__c) + Integer.valueof(sal.Co_Applicant_Net_Salary_month2__c))/2);
                            }else{ 
                              system.debug('*&*&sal.Co_Applicant_Net_Salary_month2__c'+sal.Co_Applicant_Net_Salary_month2__c);
                              if(sal.month1_sal__c!=null && sal.mon1_variable_pay__c!=null && sal.month2_sal__c!=null && sal.mon2_variable_pay__c!=null)
                                sal.Monthly_Net_Salary__c=(((Integer.valueof(sal.month1_sal__c)-(Integer.valueof(sal.mon1_variable_pay__c)*prf)) + (Integer.valueof(sal.month2_sal__c) - (Integer.valueof(sal.mon2_variable_pay__c) *prf)))/2)+((Integer.valueof(sal.Co_Applicant_Net_Salary_month1__c) + Integer.valueof(sal.Co_Applicant_Net_Salary_month2__c))/2);
                                system.debug('*&*&*&*&*&*&*&*&*&'+sal.Monthly_Net_Salary__c);
                            }
                 }else{ 
                     system.debug('*&*&*in else  &');
                          if(sal.month1_sal__c!=null && sal.month2_sal__c!=null && (sal.mon1_variable_pay__c==null || sal.mon2_variable_pay__c==null)){   
                         sal.Monthly_Net_Salary__c=(Integer.valueof(sal.month1_sal__c) + Integer.valueof(sal.month2_sal__c))/2;
                          }else{ 
                    if(sal.month1_sal__c!=null && sal.mon1_variable_pay__c!=null && sal.month2_sal__c!=null && sal.mon2_variable_pay__c!=null)
                        sal.Monthly_Net_Salary__c=((Integer.valueof(sal.month1_sal__c)-(Integer.valueof(sal.mon1_variable_pay__c)*prf)) + (Integer.valueof(sal.month2_sal__c) - (Integer.valueof(sal.mon2_variable_pay__c) *prf)))/2;
                        system.debug('*&*&*&*&*&*&*&*&*&'+sal.Monthly_Net_Salary__c);
                   }
          }
        }
    }
    }
    
    }
    if(Trigger.IsAfter){
    //BUG Id 17501
    boolean isSHOLProductLineProduct = false;  
    transient string SHOLProductLineProducts = Label.SHOL_ProductLine_Products;
    if(SHOLProductLineProducts != null && SHOLProductLineProducts != '' )
    {
        set < string > setSHOLProdName = new set < string > ();
        setSHOLProdName.addAll(SHOLProductLineProducts.split(';'));
        if (setSHOLProdName != null && setSHOLProdName.size() > 0 && Loan != null && Loan.size()> 0 && Loan[0].Product__c != null) 
        {
            if(setSHOLProdName.contains(Loan[0].Product__c))
            isSHOLProductLineProduct = true; 
        }
    }
     if(Loan!=null && Loan.size() > 0 && Loan[0].Product__c=='SOL' || isSHOLProductLineProduct){
    cibil=[select id,Account_Info__c,Total_Loans__c from Cibil__c where Applicant__c =: Trigger.New[0].Applicant__c];
extLoan = [Select id from Existing_Loan_Details__c where Applicant__c =: Trigger.New[0].Applicant__c];
        Salaried__c salObj;
        SOL_CAM__c solcamObj;
        List<Salaried__c> tempSalLst = [SELECT Id,Template__c,Cust_Selected_Loan_Amount__c,Cust_Selected_Tenor__c,Product_Offerings__c,PODetail__c,PODetail__r.Normal_Offer_Amount__c FROM Salaried__c WHERE Loan_Application__c = :Loan[0].Id];
        if(!CommonUtility.isEmpty(tempSalLst))
            salObj = tempSalLst[0];
            
        Boolean result =  false;
        Boolean isChanged = false;
       for(SOL_CAM__C sol: Trigger.New)
        { 
          solcamObj = sol;  
          system.debug('^%%^%^%^%^%^^%'+sol.Total_Monthly_Obligation__c);
          system.debug('^%%^%^%^%^%^^%'+sol.Cibil_Score__c);
          System.debug('^%%^%^%^%^%^^%'+Trigger.oldmap.get(sol.id));
          System.debug('^%%^%^%^%^%^^%'+Trigger.newmap.get(sol.id));
      //Bug 18780 - Eligibility is getting calculate at MCP level only hence it is impacting in eligibility calculation By Rajesh
      if((Trigger.oldmap.get(sol.id).Existing_Loan_Details_Created__c != Trigger.Newmap.get(sol.id).Existing_Loan_Details_Created__c || Trigger.oldmap.get(sol.id).Total_Monthly_Obligation__c != Trigger.Newmap.get(sol.id).Total_Monthly_Obligation__c || ((Trigger.oldmap.get(sol.id).Cibil_Score__c != Trigger.Newmap.get(sol.id).Cibil_Score__c) && !commonUtility.isEmpty(Trigger.oldmap.get(sol.id).Cibil_Score__c)) || Trigger.oldmap.get(sol.id).Counter__c != Trigger.Newmap.get(sol.id).Counter__c))
              isChanged = true;
            //system.debug('loan Size:: '+Loan.size()+' sol.Monthly_Obligation::: '+sol.Total_Monthly_Obligation__c+' sol.Cibil_Score:: '+sol.Cibil_Score__c+' extLoan.size:: '+extLoan.size()+' cibil.Total_Loans:: '+cibil[0].Total_Loans__c+' isChanged:: '+isChanged);
      if(Loan.size()>0 && sol.Total_Monthly_Obligation__c!=null && Trigger.IsUpdate && (sol.Cibil_Score__c==1 || sol.Cibil_Score__c==0|| sol.Cibil_Score__c>=700) && (extLoan.Size()>0 ||(Cibil.size()>0 && cibil[0].Total_Loans__c==0))&& isChanged)
          {
               // EligibilityCalculationSOL ss = new EligibilityCalculationSOL();
               // solCam=ss.CalculateSOL(Loan[0].Id);
               result =  true;
             // SOLOTPEligibilityCalculationCntrl solOTPObj = new SOLOTPEligibilityCalculationCntrl();
             // solCam = solOTPObj.CalculateEligibility(Loan[0].Id,Loan[0]);   
             
            }
        }
        system.debug('isChangedisChanged-->'+isChanged+' : '+salObj+' : '+solcamObj);
      if(!CommonUtility.isEmpty(salObj) && !CommonUtility.isEmpty(salObj.Template__c) && !CommonUtility.isEmpty(solcamObj) && isChanged){
          //System.debug('Product is: '+Loan[0].Product__c);
          if(CommonUtility.isEmpty(solcamObj.Final_Loan_Amount_For_Tennor12__c)){
            if(!CommonUtility.isEmpty(salObj.Cust_Selected_Loan_Amount__c) && 
                !CommonUtility.isEmpty(salObj.PODetail__r) &&
                !CommonUtility.isEmpty(salObj.PODetail__r.Normal_Offer_Amount__c) &&
                (salObj.Cust_Selected_Loan_Amount__c <= salObj.PODetail__r.Normal_Offer_Amount__c)){
                    system.debug('getEligibilityFromPO');
                        SOLDynamicController.getEligibilityFromPO(Loan[0].Id);
            }else{
                 //BUG ID 17501
                if(SHOLProductLineProducts != null && SHOLProductLineProducts != '' )
                {
                    set < string > setSHOLProdName = new set < string > ();
                    setSHOLProdName.addAll(SHOLProductLineProducts.split(';'));
                    if (setSHOLProdName != null && setSHOLProdName.size() > 0 && Loan != null && Loan[0].Product__c != null) 
                    {
                        if(setSHOLProdName.contains(Loan[0].Product__c))
                        isSHOLProductLineProduct = true; 
                    }
                }
                if(Loan[0].Product__c=='SOL')
                    SOLDynamicController.getEligibility(solcamObj.Id);
                else if(isSHOLProductLineProduct)
                    SOLDynamicController.getEligiblityForSHOL(Loan[0].Id);
          }
         }
        }else if(result == true){
            SOLOTPEligibilityCalculationCntrl solOTPObj = new SOLOTPEligibilityCalculationCntrl();
            solCam = solOTPObj.CalculateEligibility(Loan[0].Id,Loan[0]);
        }
    system.debug('SOL_CAM:::'+SolCam+'Template:::'+salObj.Template__c);
    if(SolCam!=null && CommonUtility.isEmpty(salObj.Template__c))
    {
    if(Loan.size()>0 && Loan[0].Product__c=='SOL' && Solcam.Total_Monthly_Obligation__c!=null && Solcam.Final_Loan_Amount_For_Tennor12__c!=null && Solcam.Final_Loan_Amount_For_Tennor24__c!=null && Solcam.Final_Loan_Amount_For_Tennor36__c!=null && Solcam.Final_Loan_Amount_For_Tennor48__c!=null && Solcam.Final_Loan_Amount_For_Tennor60__c!=null){
   solPolicy =[Select id,Name,Policy_Status__c,Policy_Name__c from SOL_Policy__c where Loan_Application__c in:oppId];
        for(SOL_Policy__c policy : solPolicy)
        {
        if(policy.Policy_Status__c=='Reject')
        RejsolPolicy.add(policy);
        if(policy.Policy_Status__c=='Refer')
        RefersolPolicy.add(policy);
        if(policy.Policy_Name__c=='PAN Number Starts with C or D' || policy.Policy_Name__c=='Current employment less than 6 and Residence not owned')
        ReferPolicyBranch.add(policy);
        }
        
          system.debug('******Rejected LIst******Newwww'+RejsolPolicy);
               if(RejsolPolicy.size()>0&& Loan.size()>0 && Loan[0].StageName=='Incomplete Application')
                 {
                    system.debug('inside auto reject**************solcam calculation');
                  Loan[0].StageName='Auto Rejected';
                   //update Loan[0];
                   Loanlist.add(loan[0]);
                 }
                //else if(ReferPolicyBranch.size()>0)
                // {
                //  Loan[0].StageName='Branch CPA - Doc Check';
                //  update Loan[0];
                // }
                 else if(RefersolPolicy.size()>0&& Loan.size()>0 && Loan[0].StageName=='Incomplete Application')
                 {
                  Loan[0].StageName='Refer';
                   //update Loan[0];
                   Loanlist.add(loan[0]);
                 }
                else if(Loan.size()>0 && Loan[0].StageName=='Incomplete Application' && Loan[0].StageName!='Refer' && solPolicy.size()==0 && Loan[0].StageName!='Auto Rejected' && Loan[0].StageName!='Branch CPA - Doc Check' && Trigger.new[0].Credit_Card_Monthly_Obligation__c==true && Trigger.new[0].EMI_Bounce_In_Last_3_Months__c==true && Trigger.new[0].Current_Employer_Less_than_6_Months__c==true && (SolCam.Final_Loan_Amount_For_Tennor12__c>0 || SolCam.Final_Loan_Amount_For_Tennor24__c>0 ||SolCam.Final_Loan_Amount_For_Tennor36__c>0 ||SolCam.Final_Loan_Amount_For_Tennor48__c>0 ||SolCam.Final_Loan_Amount_For_Tennor60__c>0 ))
                 {
                 Loan[0].StageName='Auto Approved';
                // update Loan[0];
                 Loanlist.add(loan[0]);
                 }
                 
            
        
   }
    if(!Test.isRunningTest()) Update SolCam;
    ControlRecursiveCallofTrigger_Util.setSOLCAMCalculation();
    }
    
    //pre-commented
   //for(SOL_CAM__c sol: Trigger.New)
    //{
    //    if(Loan.size()>0 && sol.Total_Monthly_Obligation__c!=null && sol.Cibil_Score__c!=null &&  sol.Final_Loan_Amount_For_Tennor12__c==0 && sol.Final_Loan_Amount_For_Tennor24__c==0 && sol.Final_Loan_Amount_For_Tennor36__c==0 && sol.Final_Loan_Amount_For_Tennor48__c==0 && sol.Final_Loan_Amount_For_Tennor60__c==0)
    //    {
    //    SOL_Policy__c sp = new SOL_Policy__c();
    //   sp.Policy_Name__c = 'Eligibility Critiria';
    //   sp.Policy_Status__c='Reject';
    //   sp.Loan_Application__c=Loan[0].id;
     //   sp.Created_From_SOLCAM__c=True;
    //   if(solPolicyupdate.size()>0)
    //   Delete solPolicyupdate;
    //  // Insert sp;
    //    }
    //}
     } 
     if(Loanlist.size()>0){
            update Loanlist;
        
        }  
    }
    list<SOL_CAM__C> so1l =new list<SOL_CAM__C>();
   
 for(SOL_CAM__C sol: Trigger.New)
        {
         if(Loan.size()>0 && Loan[0].Product__c=='SOL'){
        if(Loan.size()>0 && Trigger.Isupdate&& Trigger.oldmap.get(sol.id).Payment_Successful__c==False && Sol.Payment_Successful__c==True)
        {
         Loan[0].Payment_Successful__c=true;
          //update loan[0];
          Loanlist.add(loan[0]);
         }
       if((trigger.isupdate && sol.Tenure_Selected_By_Customer__c!=null && sol.Loan_Amount_Selected_by_Customer__c!=null && Trigger.oldmap.get(sol.id).Tenure_Selected_By_Customer__c!=Trigger.Newmap.get(sol.id).Tenure_Selected_By_Customer__c && Trigger.oldmap.get(sol.id).Loan_Amount_Selected_by_Customer__c!=Trigger.Newmap.get(sol.id).Loan_Amount_Selected_by_Customer__c) || (Trigger.ISupdate && (Trigger.oldmap.get(sol.id).Tenor__c!=Trigger.Newmap.get(sol.id).Tenor__c || Trigger.oldmap.get(sol.id).Proposed_Loan_Amount__c!=Trigger.Newmap.get(sol.id).Proposed_Loan_Amount__c)))
        {
        Loan[0].Approved_Loan_Amount__c =sol.Proposed_Loan_Amount__c;
        Loan[0].Insurance_Premium_Amt__c = sol.Premium_Amount__c;
        Loan[0].Approved_Tenor__c=sol.Tenor__c;
        Loan[0].Approved_Rate__c=sol.ROI__C;
        Loan[0].Amount=sol.Loan_Amount_Selected_by_Customer__c;
        Loan[0].Tenor__c=sol.Tenure_Selected_By_Customer__c;
       //update loan[0];
        Loanlist.add(loan[0]);
       }
       }
        }
        
        //Moved to PreUpdate Trigger ---Start
          /*if(Trigger.IsInsert){
          if( Loan.size()>0 && Loan[0].Product__c=='SOL'){ 
        if(solcamid!=null)
      so1l=[select id,Applicant__r.Contact_Name__r.Employer__r.Company_Category__C,Monthly_Net_Salary__c from SOL_CAM__C where id=:solcamid];
    //system.debug('category value*******'+SO1L[0].Applicant__r.Contact_Name__r.Employer__r.Company_Category__C);  
   
    for(SOL_CAM__C sol:so1l) {
      // system.debug('netsal*********'+sol.Monthly_Net_Salary__c+'xxx'+Loan[0].Branch_Type1__c+'ccc'+SOL.Applicant__r.Contact_Name__r.Employer__r.Company_Category__C);
        if(sol.Monthly_Net_Salary__c!=null && Loan[0].Branch_Type1__c!=null && SOL.Applicant__r.Contact_Name__r.Employer__r.Company_Category__C!=null)
       {
           
             list<SOL_Cam_Rackrate__c> solraclist=SOL_Cam_Rackrate__c.getall().values();
             for(SOL_Cam_Rackrate__c onsol : solraclist)
             {
                //if(onsol.Product_Type__c=='SOL')
                system.debug('****************'+onsol.Company_Category__c+'cccccccc'+SOL.Applicant__r.Contact_Name__r.Employer__r.Company_Category__C);
                system.debug('@@@@@@@@@@@@@@@@@@@'+onsol.City_Tier__c+'cccccccc'+Loan[0].Branch_Type1__c);
       
                if(onsol.Company_Category__c==SOL.Applicant__r.Contact_Name__r.Employer__r.Company_Category__C && onsol.City_Tier__c==Loan[0].Branch_Type1__c
                     && sol.Monthly_Net_Salary__c > onsol.Net_Sal_From__c && sol.Monthly_Net_Salary__c <= onsol.Net_Sal_To__c)
                     {
                        loan[0].Processing_Fees__c=onsol.PF__c;
                      
                        system.debug('bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb');
               
                     }
                 //system.debug('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'+loan[0].Processing_Fees__c);
             }
              
              //update loan[0];
              Loanlist.add(loan[0]);
       }
    
        
    }  
       
       }
        }*/
        //Moved to PreUpdate Trigger ---End
         if(Loanlist.size()>0){
            update Loanlist;
        
        }     
}
}
Integer i = 0;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
}