public without sharing class SAL_PricingCtrlV2{
   /*977*/
     @AuraEnabled
        public static String updateFees(String loanId){
            return SALMobilityPricingCntrl_V2.updateFees(loanId);
        }
    /*977*/
      /*24673 s*/
    @AuraEnabled
    public static String saveLandlordDetails(String solObjLandLord){
        return SALMobilityPricingCntrl_V2.saveLandlordDetailsMethod(solObjLandLord);
    }
    
    @AuraEnabled
    public static String checkRentalAggStatusApp(String oppId){
        return SALMobilityPricingCntrl_V2.checkRentalAggStatus(oppId);
    }
      @AuraEnabled
    public static List < IFSC_Master__c > fetchBank(String searchKeyWord) {
        return SALMobilityPricingCntrl_V2.fetchBank(searchKeyWord);
    }
    /*24673 e*/
    /* Bug : 17556 S  Pricing */
        @AuraEnabled
    public static String fetchIFSCData(String ifscmicrCode, String fieldAPI){
        System.debug('ifscmicrCode-->'+ifscmicrCode);
        return SALMobilityPricingCntrl_V2.fetchIFSCData(ifscmicrCode, fieldAPI);
    }
    @AuraEnabled
    public static String deleteRepaymentObject(Id repayId, Id loanId){
        return SALMobilityPricingCntrl_V2.deleteRepaymentObject(repayId, loanId);
    }
    @AuraEnabled 
    public static List<Current_Disbursal_Details__c> fetchDisbursementclone(String oppid) {
      system.debug('inside clone pk'+oppid);
        return SALMobilityPricingCntrl_V2.fetchDisbursementafterclone(oppid);
        
    }

     @AuraEnabled
    public static String deleteDisbursementObject(Id disbId, Id loanId){
        return SALMobilityPricingCntrl_V2.deleteDisbursementObject(disbId, loanId);
    }
    @AuraEnabled
    public static String fetchRepayList(String loan, String repay){
        return SALMobilityPricingCntrl_V2.fetchRepayList(loan, repay);
    }
     @AuraEnabled
    public static String fetchDisbursementList(String loan, String disburse){
        return SALMobilityPricingCntrl_V2.fetchDisbursementList(loan, disburse);
    }
    @AuraEnabled
    public static String saveRepayData(String repay){
        return SALMobilityPricingCntrl_V2.saveRepayData(repay);
    }
    @AuraEnabled
    public static String cloneRepayRecord(String oppId){
        return SALMobilityPricingCntrl_V2.cloneRepayRecord(oppId);
    }
    @AuraEnabled
    public static String fetchRepaymentObject(String repayId,String objectFieldJSON,String oppId,String PrimaryAppId){//changed for 22017
        return SALMobilityPricingCntrl_V2.fetchRepaymentObject(repayId,objectFieldJSON,oppId,PrimaryAppId);
        // return null;
    }
     @AuraEnabled
    public static String fetchDisbursementObject(String disbId,String Loanid,String objectFieldJSON){
        System.debug('inside fetchDisbursementObject '+disbId+Loanid+objectFieldJSON);
        return SALMobilityPricingCntrl_V2.fetchDisbursementObject(disbId,Loanid,objectFieldJSON);
       // return null;
    }
    @AuraEnabled
    public static String sendMail(String opp, Decimal approvedROI ,Decimal proposedROI,Decimal  approvedPF,Decimal  proposedPF,String appObj){
        return SALMobilityPricingCntrl_V2.sendMail(opp, approvedROI, proposedROI, approvedPF, proposedPF,appObj);
    }
    @AuraEnabled
    public static String sendMailAppr(String opp,Decimal approvedROI ,Decimal proposedROI,Decimal approvedPF,Decimal  proposedPF,String selectedOfficer){
        try{
            system.debug('selected is'+selectedOfficer);
            Decimal diffInROI = 0.0, diffInPF = 0.0;
            if(approvedROI != null && proposedROI != null)
            {
                diffInROI = approvedROI - proposedROI;
            }
            if(approvedPF != null && proposedPF != null)
            {
                diffInPF = approvedPF - proposedPF;
            }
            Opportunity Loan = (Opportunity) JSON.deserialize(opp, Opportunity.Class);
            List<Sales_Officer_Limit__c> soLList = [select id,FFR_Percent__c, WIRR__c, WPF__c, LI_PREMIUM__c, LI_Percent__c, HI_PREMIUM__c, HI_Percent__c, Sales_Officer_Name__r.email, Sales_Officer_Name__c, Sales_Officer_Name__r.Mobile_number__c, Sales_Officer_Name__r.name, Reporting_Manager_Name__c, Reporting_Manager_Designation__c,
                                                        Reporting_Manager_Name__r.Mobile_number__c, ASM_Branch__c, Selected_Flag__c, Designation__c, Location__c, Product__c,
                                                        Max_Number__c,Sales_officer_Email__c,DesignationCount__c,Reporting_Manager_Name__r.name from Sales_Officer_Limit__c where Id =: selectedOfficer
                                                       ];
            SALMobilityPricingCntrl_V2.stampPFasPending(Loan.Id,soLList[0].Designation__c);
          //  if(diffInROI!=0 && diffInPF!=0){
		  if (true){
                //SALMobilityPricingCntrl_V2.stampROIasPending(Loan.Id,soLList[0].Designation__c);  
                //SALMobilityPricingCntrl_V2.stampPFasPending(Loan.Id,soLList[0].Designation__c);
                SALMobilityPricingCntrl_V2.sendMailImplementation mailJob = new SALMobilityPricingCntrl_V2.sendMailImplementation(Loan.Id, proposedROI, proposedPF,solList[0].Designation__c,solList[0].Sales_officer_Email__c,soLList[0].Id, 'sendmailforROI', true);
                ID jobID = System.enqueueJob(mailJob);
                SALMobilityPricingCntrl_V2.sendMailImplementation mailJob1 = new SALMobilityPricingCntrl_V2.sendMailImplementation(Loan.Id, proposedROI, proposedPF,solList[0].Designation__c,solList[0].Sales_officer_Email__c,soLList[0].Id, 'sendmailforROI', false);
                ID jobID1 = System.enqueueJob(mailJob1);
                 //SALMobilityPricingCntrl_V2.sendMailImplementation(Loan.Id, proposedROI, proposedPF,solList[0].Designation__c,solList[0].Sales_officer_Email__c,soLList[0].Id, 'sendmailforROI', true);
                //SALMobilityPricingCntrl_V2.sendMailImplementation(Loan.Id, proposedROI, proposedPF,solList[0].Designation__c,solList[0].Sales_officer_Email__c,soLList[0].Id, 'sendmailforROI', false);
            
            
            }
         return 'Success';
        }
        catch(Exception e){
            return 'fail';
        }
    }
    @AuraEnabled
    public static String approvePricing(String loan,String appObj,String acc){
        System.debug('loan--->'+loan);
        return SALMobilityPricingCntrl_V2.approvePricing(loan,appObj,acc);
    }
    @AuraEnabled
    public static String fetchData(Id loanAppId, String objectFieldJSON){
        System.debug('loanAppId--->'+loanAppId);
        return SALMobilityPricingCntrl_V2.fetchData(loanAppId, objectFieldJSON);
    }
    /* Hrushikesh Pricing methods Start*/
    @AuraEnabled
    public static String saveCustomerConsent(String oppId,String bpi,String stampDuty, String firstEMI, String disbursmentObj,String lastEMI, String EMI,Decimal upfrontCharge,Decimal touchFreeFees)
    {
        // priyanka added to update change amount - start
       Map<String,Object> chargeFCMap=getCharges(oppId);
        List<Fees_and_Charge__c> chargeList=new List<Fees_and_Charge__c>();
        for(String key:chargeFCMap.keySet()){
             if(key=='Upfront charge'){
            Fees_and_Charge__c fc= (Fees_and_Charge__c)chargeFCMap.get(key);
                 fc.Change_Amount__c=upfrontCharge;
                    chargeList.add(fc);
                }
              if(key=='Touch free fees'){
            Fees_and_Charge__c fc=(Fees_and_Charge__c)chargeFCMap.get(key);
                 fc.Change_Amount__c=touchFreeFees;
                    chargeList.add(fc);
                }

        }
        update chargeList;
           // priyanka added to update change amount - end
        return SALMobilityPricingCntrl_V2.saveCustomerConsentMethod(oppId,bpi,stampDuty,firstEMI,disbursmentObj,lastEMI,EMI); 
    }
     @AuraEnabled
    public static String sendMailEAggrement(String oppId,String bpi,String stampDuty, String firstEMI, String disbursmentObj,String lastEMI, String EMI)
    {
        return SALMobilityPricingCntrl_V2.sendEaggrementMail(oppId,bpi,stampDuty,firstEMI,disbursmentObj,lastEMI,EMI); 
    }
    @AuraEnabled
    public static String saveOffersMethod(String loanId, String JSONapplicantObj,String JSONsurrogateObj)
    {
         return SALMobilityPricingCntrl_V2.saveOffers(loanId, JSONapplicantObj, JSONsurrogateObj); 
    }


    @AuraEnabled 
    public static String getPricingDashboardDetails(String oppId)
    {
        return SALMobilityPricingCntrl_V2.getPricingDashboardDetails(oppId);
    }
    
//added by priyanka --start
    @AuraEnabled 
    public static String checkDuplicateLan(String oppId,String currentBarcode){
        return SALMobilityPricingCntrl_V2.checkDuplicateLan(oppId,currentBarcode);
    }

@AuraEnabled
    public static String getNachDef(String oppId)
    {
         return SALMobilityPricingCntrl_V2.getNachDef(oppId);
        
    }
  
  
   /*DMS added by swapnil 24317 s*/
    @AuraEnabled
    public static Map<String,Object>  getDMSDocuments(String product){
        Map<String,Object> DMSDocs=new Map<String,Object>();
        DMSDocs= CommonUtility.getDMSDocuments(product);
        return DMSDocs;     
    }
    /*DMS added by swapnil 24317 e*/ 
  
  
    
    @AuraEnabled
    public static Map<String,Object> getCharges(String oppId){
        return SALMobilityPricingCntrl_V2.getCharges(oppId);
        
    }
    //added by priyanka --end
    
    //added by kishore for pricing dashboard
    //
    public class DetailsWrapperClass {
        @AuraEnabled
        public String errorMessageString{get;set;}
        @AuraEnabled        
        public Boolean showSalesHierarchyMsg{get;set;}
        @AuraEnabled
        public Map<String,String> coIdToCoNameMap{get;set;}
         
        //@AuraEnabled
        //public Boolean showEkycMandatoryMsg{get;set;}       
        
        
        public DetailsWrapperClass(Map<String, Object> parametersMap){
            if(parametersMap.containsKey('ID_TO_CO_NAME_MAP') && parametersMap.get('ID_TO_CO_NAME_MAP') != null)
                coIdToCoNameMap = (Map<String,String>)parametersMap.get('ID_TO_CO_NAME_MAP');
            if(parametersMap.containsKey('ERROR_MSG_STRING') && parametersMap.get('ERROR_MSG_STRING') != null)
                errorMessageString = (String)parametersMap.get('ERROR_MSG_STRING');
            if(parametersMap.containsKey('SHOW_SALES_HIERARCHY_MSG') && parametersMap.get('SHOW_SALES_HIERARCHY_MSG') != null)
                showSalesHierarchyMsg = (Boolean)parametersMap.get('SHOW_SALES_HIERARCHY_MSG');
            
            
                
        }  
    }
   
    @AuraEnabled
    public static ListView getLoanApplicationListViewsPAS(){
       ListView listviews = [SELECT Id, Name 
                              FROM ListView 
                              WHERE SobjectType = 'Opportunity'
                              AND Id = '00B90000009P7BQEA0' 
                              LIMIT 1];   //returns post approval sales list view
        return listviews;
    }
    
    @AuraEnabled
    public static DetailsWrapperClass callSubmitToBranchOpsCntrl(String oppId,String approverId){
        Map<String, Object> parametersMap = new Map<String, Object>();
 /* Bug 22624 Start - Hrushikesh Sprint 5C */
        Decimal sumAllDisb=0.0; 
        Decimal Netdisb = 0.0;
        Decimal totalCharges =0.0; 
        List<Fees_and_Charge__c> charges = new  List<Fees_and_Charge__c>();
        /* Bug 22624 Stop - Hrushikesh Sprint 5C */
       
        try
        {
            boolean PFApproved = false;
            boolean ROIApproved = false;
            boolean isValid = true;
            parametersMap.put('ERROR_MSG_STRING', 'NO_ERROR');
            List<Opportunity> loanList = [SELECT Id, Product__c,Loan_Amount_with_Premium__c, Scheme_Master__r.flexi_flag__c, Scheme_Master__r.PLOC_scheme__c, Approved_Rate__c, 
                createddate, Loan_Application_Flow__c, Branch_Name__c, Branch_Name__r.name, Program_Type__c, Approver__c, ownerid, BranchName__c,
 /*Bug 22624*/ (select Charge_Desc__c,Finnone_ChargeCode__c,Deducted_from_Disbursement__c,Finnone_ChargeId__c,Loan_Application__c,Change_Amount__c from Fees_and_Charges__r)
                FROM Opportunity Where Id =: oppId];
            
            List<Applicant__c> applicantList = [SELECT Id, mail_to_Sales_Hierarchy__c, ROIFlexi__c, ROILoc__c, ROINormal__c, PFApproveStatus__c  
                FROM Applicant__c WHERE  Loan_Application__c =: oppId AND Applicant_Type__c = 'Primary'];             
                
            /* Bug 22624 Start - Hrushikesh Sprint 5C */
            if(loanList[0] != null)
                charges = loanList[0].Fees_and_Charges__r;
            if(charges!=null){
                for(Fees_and_Charge__c fc:charges){
                    if(fc.Deducted_from_Disbursement__c == 'Yes')
                    {  
                        if(fc.Change_Amount__c!=null) 
                        {
                            totalCharges =totalCharges + Integer.valueOf(fc.Change_Amount__c);
                            system.debug('totalCharges here is'+totalCharges);
                        }
                    }
                }
            }
//System.debug('Debug99'+loanList[0].Loan_Amount_with_Premium__c);
            if (loanList[0] != null && loanList[0].Loan_Amount_with_Premium__c != null) {
                Netdisb = loanList[0].Loan_Amount_with_Premium__c-totalCharges;
            }
            system.debug('Netdisb here is'+Netdisb);
            List<Current_Disbursal_Details__c> disbList= [select id, Disbursement_Amount__c, Loan_Application__c, Disbursal_Mode__c   from Current_Disbursal_Details__c where Loan_Application__c = : loanList[0].id  ];
            if(!commonutility.isEmpty(disbList))
            {         
                for(Current_Disbursal_Details__c disb: disbList)
                {
                    sumAllDisb=sumAllDisb + disb.Disbursement_Amount__c;
                }
            }
            /* Bug 22624 Stop - Hrushikesh Stop Sprint 5C */ 
           
  /*if(commonutility.isEmpty(applicantList[0].ROIApproveStatus__c))
                ROIApproved = true;
            else{
                if(!applicantList[0].ROIApproveStatus__c.contains('Pending'))
                {
                    ROIApproved = true;
                }
            }
                */
            if(commonutility.isEmpty(applicantList[0].PFApproveStatus__c))
                PFApproved = true;
            else{
                if(!applicantList[0].PFApproveStatus__c.contains('Pending'))
                    {
                        PFApproved = true;
                    }
            }   
                if(loanList != null && loanList.size() > 0 && applicantList.size() > 0)
                {
                //Bug #17924 S - Added for Mobility Flow
                Map<String,Object> jsonResp = (Map<String,Object>)JSON.deserializeUnTyped(PricingDisbmntDetails_Ctrl.fdQuesValidate(oppId));
                String insError = '';
                system.debug('jsonResp ---->'+ jsonResp);
                if(!Boolean.valueOf(jsonResp.get('isValid'))){
                    if(!String.isBlank(String.valueOf(jsonResp.get('msgStr1')))){
                        insError = String.valueOf(jsonResp.get('msgStr1'));
                        //return null;
                    }
                    else if(!String.isBlank(String.valueOf(jsonResp.get('msgStr2')))){
                        insError = String.valueOf(jsonResp.get('msgStr2'));
                        //return null;
                    }
                }
                if(!String.isBlank(insError)){
                    parametersMap.put('ERROR_MSG_STRING', insError);
                    isValid = false;
                }
                system.debug('isValid :::' + isValid);
                //Bug #17924 E - Added for Mobility Flow
                if(isValid){
                    if(PFApproved){
                    Opportunity Loan = loanList[0];
                    String approverDesignation1 = null;
                    Integer loanAmt = 0;
                    List<Credit_Officer_Limit__c> COLimitList = new List<Credit_Officer_Limit__c>();
                    COLimitList = [select id, Designation__c, Loan_Amount__c, Credit_Officer_Name__r.id, Credit_Officer_Name__r.Employee_ID__c, Pre_Approved_Amount__c from Credit_Officer_Limit__c where id =: approverId];
                    if(COLimitList != null && COLimitList.size() > 0)
                    {
                        approverDesignation1 = COLimitList[0].Designation__c;
                        
                        Boolean COLStampFlag = false;
                        Date COLStampdate;
                        System.debug('LaonApplicationCreation__c.getValues(Hierarchy Stamping) ---->> '+LaonApplicationCreation__c.getValues('Hierarchy Stamping'));
                        if (LaonApplicationCreation__c.getValues('Hierarchy Stamping') != null)
                        {
                            String COLDate = LaonApplicationCreation__c.getValues('Hierarchy Stamping').Credit_Hierarchy_Stamping_Date__c;
                            if (COLDate != null) {
                                system.debug('COLDate ---->> ' + COLDate);
                                COLStampdate = date.parse(COLDate);
                            }
                        }
                        if (COLStampdate != null && Loan != null && COLStampdate < Loan.createddate)
                        {
                            system.debug('COLStampdate ---->> ' + COLStampdate);
                            system.debug('Loan.createddate ---->> ' + Loan.createddate);
                            COLStampFlag = true;
                        }
                        
                        if (COLStampFlag == true) {
                            if (Loan.Program_Type__c == 'Pre-Approved') {
                                loanAmt = Integer.valueof(COLimitList[0].Pre_Approved_Amount__c);
                            } else {
                                loanAmt = Integer.valueof(COLimitList[0].Loan_Amount__c);
                            }
                        } else {
                            loanAmt = Integer.valueof(COLimitList[0].Loan_Amount__c);
                        }
                        
                        if (Loan.Approver__c == 'Centralized CPA')
                        {
                            approverId = COLimitList[0].Credit_Officer_Name__r.id;
                            system.debug('approverId:------ ' + approverId);
                            Loan.ownerid = approverId;
                            Loan.Approver__c = 'Centralized ACM';
                            Loan.Centralized_ACM__c = approverId;
                            Loan.Centralized_ACM_Amount__c = loanAmt;
                            system.debug('StrAppr:---Loan.ownerid--- ' + Loan.ownerid);
                        } else if (approverDesignation1 == 'Centralized RCM')
                        {
                            approverId = COLimitList[0].Credit_Officer_Name__r.id;
                            system.debug('StrAppr:------ ' + approverId);
                            Loan.ownerid = approverId;
                            Loan.Approver__c = 'Centralized RCM';
                            Loan.Centralized_RCM_Amount__c = loanAmt;
                            system.debug('StrAppr:---Loan.ownerid--- ' + Loan.ownerid);
                            Loan.Centralized_RCM__c = approverId;
                            // Code to initiate CIBIL
                            System.debug('-- Salaried initiate CIBIL --' + applicantList.size());
                            applicantList[0].Integrate_with_CIBIL__c = true;
                            applicantList[0].Update_CIBIL_Error__c = false;
                            applicantList[0].Description__c = '';
                            update applicantList;
                        } else if (Loan.Approver__c != 'Centralized CPA')
                        {
                            approverId = COLimitList[0].Credit_Officer_Name__r.id;
                            String Branch = Loan.BranchName__c;
                            double acmamt = 0;
                            //4450
                            List < Credit_Officer_Limit__c > acmList = new List < Credit_Officer_Limit__c > ();
                            String LoanAppFlow = Loan.Loan_Application_Flow__c;
                            if(LoanAppFlow == null || LoanAppFlow == '')
                                LoanAppFlow = 'Normal';
                            System.debug('LoanAppFlow=' + LoanAppFlow);

                            if (Branch != null && Loan.Product__c != null && approverId != null) {
                                if (COLStampFlag == true && LoanAppFlow != null)
                                {
                                    acmList = [select Loan_Amount__c, Pre_Approved_Amount__c 
                                    from Credit_Officer_Limit__c
                                    where Credit_Officer_Name__c = : approverId
                                    and /**Product__c =:**/ Product__c = : Loan.Product__c and City__c INCLUDES(: Branch) 
                                    and Flow__c INCLUDES(: LoanAppFlow) and Active_Flag__c = true limit 1];
                                    if (acmList.size() > 0) {
                                        if (Loan.Program_Type__c == 'Pre-Approved') {
                                            acmamt = acmList[0].Pre_Approved_Amount__c;
                                        } else {
                                            acmamt = acmList[0].Loan_Amount__c;
                                        }
                                    }
                                } else 
                                {
                                    acmamt = [select Loan_Amount__c 
                                    from Credit_Officer_Limit__c
                                    where Credit_Officer_Name__c = : approverId and Product__c = : Loan.Product__c and City__c INCLUDES(: Branch) 
                                    and Active_Flag__c = true limit 1].Loan_Amount__c;
                                }
                            }

                            if (approverDesignation1 == null && approverDesignation1 == '')
                            {
                                Loan.ownerId = approverId;
                                Loan.Approver__c = approverDesignation1;
                                Loan.CPA__c = approverId;
                            }else
                            {
                                Loan.ownerid = approverId;
                                /* Bug id 20258 Added by swapnil*/
                                Loan.Approver__c = approverDesignation1;
                                Loan.CPA__c = approverId;
                            }
                        }
                        Loan.stageName = 'Branch Ops';
                        Loan.Sales_Submit_to_Branch_Ops_Date__c = System.now();
                        update Loan;
                    }
                    
                    }else{
                        parametersMap.put('ERROR_MSG_STRING', 'Pending approval of proposed ROI or PF');
                    } 
    // Bug 22624 Start - Hrushikesh Sprint 5C s*/
                    if(sumAllDisb != Netdisb)          
                    {
                        parametersMap.put('ERROR_MSG_STRING', 'Disbursment Amount must be equal to Net Disbursement Amount');
                    }   
                    // Bug 22624 Start - Hrushikesh Sprint 5C e*/
                }
            }
            return new DetailsWrapperClass(parametersMap);
        }catch(Exception exp)
        {
            parametersMap.put('ERROR_MSG_STRING', exp.getMessage());
            return new DetailsWrapperClass(parametersMap);
        }
    }
    
    @AuraEnabled
    public static DetailsWrapperClass selectOpsCreditOfficerCntrl(String oppId){
        Map<String, Object> parametersMap = new Map<String, Object>();
        try
        {            
            parametersMap.put('ERROR_MSG_STRING', 'NO_ERROR');         
            parametersMap.put('SHOW_SALES_HIERARCHY_MSG', false);
            List<Opportunity> loanList = [SELECT Account.Current_State__c,Id, Product__c, Scheme_Master__r.flexi_flag__c, Scheme_Master__r.PLOC_scheme__c, Approved_Rate__c, 
                createddate, Loan_Application_Flow__c, Branch_Name__c, Branch_Name__r.name
                FROM Opportunity Where Id =: oppId];
                
            List<Applicant__c> applicantList = [SELECT eKYC_Processing__c,(SELECT Id,bio_Ekyc__c FROM Ekyc__r),Id, mail_to_Sales_Hierarchy__c, ROIFlexi__c, ROILoc__c, ROINormal__c 
                FROM Applicant__c WHERE  Loan_Application__c =: oppId AND Applicant_Type__c = 'Primary'];
                
            if(loanList != null && applicantList != null && loanList.size() > 0 && applicantList.size() > 0)
            {
                Opportunity Loan = loanList[0];
                Applicant__c applicantPrimary = applicantList[0];
                Boolean rateflag = false;
                Boolean branchValid = false;
                rateflag = new Set < String > (ProductSMS__c.getValues('RateApp').Produtc__c.split(';')).contains(Loan.Product__c.toUpperCase());
                branchValid = ProductSMS__c.getValues('RateApp').RA_Branch_Valid__c;
                Boolean flag = false;
                if (rateFlag && branchValid && !applicantPrimary.mail_to_Sales_Hierarchy__c) {
                    if (Loan.Scheme_Master__r.flexi_flag__c == true && Loan.Approved_Rate__c < applicantPrimary.ROIFlexi__c) {
                        flag = true;
                    } else if (Loan.Scheme_Master__r.PLOC_scheme__c == true && Loan.Approved_Rate__c < applicantPrimary.ROILoc__c) {
                        flag = true;
                    } else if (Loan.Approved_Rate__c < applicantPrimary.ROINormal__c) {
                        flag = true;
                    }
                    if (flag == true) {
                        parametersMap.put('SHOW_SALES_HIERARCHY_MSG', true);
                    //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Send mail to Sales Hierarchy is Mandatory! Proposed Rate is below' + 
                    //      'the system prescribed rate. Please take necessary approvals before proceeding'));
                    //  return null;
                    }
                }
                
                if (Loan.Branch_Name__c == null)
                {
                    parametersMap.put('ERROR_MSG_STRING', 'Branch value is empty. Unable to continue');
                }
                else{
                    Boolean COLStampFlag = false;
                    Date COLStampdate;
                    System.debug('LaonApplicationCreation__c.getValues(Hierarchy Stamping) ---->> '+LaonApplicationCreation__c.getValues('Hierarchy Stamping'));
                    if (LaonApplicationCreation__c.getValues('Hierarchy Stamping') != null)
                    {
                        String COLDate = LaonApplicationCreation__c.getValues('Hierarchy Stamping').Credit_Hierarchy_Stamping_Date__c;
                        if (COLDate != null) {
                            system.debug('COLDate ---->> ' + COLDate);
                            COLStampdate = date.parse(COLDate);
                        }
                    }
                    if (COLStampdate != null && Loan != null && COLStampdate < Loan.createddate)
                    {
                        system.debug('COLStampdate ---->> ' + COLStampdate);
                        system.debug('Loan.createddate ---->> ' + Loan.createddate);
                        COLStampFlag = true;
                    }
                    
                    List<Credit_Officer_Limit__c> coList = [SELECT id, name, City__c, Number_of_Deviations__c, Credit_Officer_Name__r.Isactive, 
                        Credit_Officer_Name__r.id, Credit_Officer_Name__r.name, Credit_Officer_Name__c, Designation__c, Loan_Amount__c, User_Type__c, Flow__c
                        FROM Credit_Officer_Limit__c WHERE product__C = : Loan.product__c AND Credit_Officer_Name__r.Isactive = true AND 
                        Active_Flag__c = true AND User_Type__c = 'OPs User'];
                        
                    system.debug('coList is '+coList.size());
                    
                    if(coList != null && coList.size() > 0)
                    {
                        Map<String, String> coIdToCoNameMap = new Map<String, String>();
                        String LoanAppFlow = Loan.Loan_Application_Flow__c;
                        if(LoanAppFlow == null || LoanAppFlow == '')
                            LoanAppFlow = 'Normal';
                        for (integer i = 0; i < coList.size(); i++) 
                        {
                            if ((coList[i].Credit_Officer_Name__c != null) && (coList[i].city__c != null))
                            {
                                system.debug('coList[i].City__c.toUpperCase(): ' + coList[i].City__c.toUpperCase());
                                system.debug('COLStampFlag  ' + COLStampFlag);
                                if (COLStampFlag == true)
                                {                                   
                                    system.debug('Loan.Branch_Name__r.name ' + Loan.Branch_Name__r.name);
                                    if (coList[i].City__c.toUpperCase().contains(Loan.Branch_Name__r.name.toUpperCase()) && coList[i].Flow__c != null && coList[i].Flow__c.contains(LoanAppFlow))
                                    {
                                        system.debug('----->> if city matches... COLStampFlag == true');
                                        //optionsCOAppr.add(new SelectOption(coList[i].Id, coList[i].Credit_Officer_Name__r.name + '-' + coList[i].Designation__c));
                                        coIdToCoNameMap.put(coList[i].Id, coList[i].Credit_Officer_Name__r.name + '-' + coList[i].Designation__c);

                                    }
                                }
                                else 
                                {
                                    if (coList[i].City__c.toUpperCase().contains(Loan.Branch_Name__r.name.toUpperCase()))
                                    {
                                        system.debug('------>> if city matches');
                                        //optionsCOAppr.add(new SelectOption(coList[i].Id, coList[i].Credit_Officer_Name__r.name + '-' + coList[i].Designation__c));
                                        coIdToCoNameMap.put(coList[i].Id, coList[i].Credit_Officer_Name__r.name + '-' + coList[i].Designation__c);
                                    }
                                }
                            }
                        }
                        parametersMap.put('ID_TO_CO_NAME_MAP', coIdToCoNameMap);
                    }
                }
                //Rohit 16111 CR added for Ekyc S
                
                
                
            }
            return new DetailsWrapperClass(parametersMap);
        }catch(Exception exp)
        {
            parametersMap.put('ERROR_MSG_STRING', exp.getMessage());
            return new DetailsWrapperClass(parametersMap);
        }
    }
    
   @AuraEnabled
    public static String getUploadVerification(String PrimaryAppId) //DMS added by swapnil 24317
    {
        System.debug('SAL_PricingCtrlV2 App id '+PrimaryAppId);
        return SALMobilityPricingCntrl_V2.getUploadVerification(PrimaryAppId); //DMS added by swapnil 24317
    }
    
    @AuraENabled
    public static void acceptOffer(String oppId)
    {
        SALMobilityPricingCntrl_V2.acceptOffer(oppId);
    }
    
     @AuraEnabled
    public static String sendToFinnOne(String oppId){
        PricingDisbmntDetails_Ctrl.loanIdfoMob = oppId;
        PricingDisbmntDetails_Ctrl obj = new PricingDisbmntDetails_Ctrl();
        obj.senttoFinnone();
        system.debug(obj.mobilitystatus);
        return obj.mobilitystatus;
    }
    
    @AuraEnabled
    public static String saveDisbursementObj(String disb){
    
        Current_Disbursal_Details__c disbObj  = new Current_Disbursal_Details__c();
        if(disb != null)
            disbObj = (Current_Disbursal_Details__c) JSON.deserialize(disb, Current_Disbursal_Details__c.Class);
        if(disbObj != null)
            upsert disbObj;
        return disbObj.Id;
    }
  //Added for bug 24667 s
    @AuraEnabled
    public static String deleteSolObject(Id solId, Id loanId){
        try{
            List<SOL_Policy__c> delSolLst = new List<SOL_Policy__c>();
            List<SOL_Policy__c> UpdSolLst = new List<SOL_Policy__c>();
            List<SOL_Policy__c> solLst =[Select id,Loan_Application__c,Add_on_Holder_DOB__c,Add_on_Holder_Email__c,Add_on_Holder_First_Name__c,Add_on_Holder_Last_Name__c,Add_on_Holder_Middle_Name__c,Add_on_holder_Mobile__c,Add_on_Holder_Relation__c,Applicant_Name__c,Charge_Type__c from SOL_Policy__c where Loan_Application__c =:loanId and name like '%add on%'];
            for(SOL_Policy__c sols : solLst){
                if(sols.Id == solId){
                    delSolLst.add(sols);
                }
                else {
                    UpdSolLst.add(sols);
                }
            }  
            if(!CommonUtility.isEmpty(delSolLst)){
                SAL_PricingCtrlV2.UpdateAddOnFees(delSolLst[0],true); 
                delete delSolLst;
            }
            if(!CommonUtility.isEmpty(UpdSolLst))
                return JSON.serialize(UpdSolLst);
            else
                return 'Empty';
        }catch(Exception e) {
            
            System.debug('An exception occurred: ' + e.getMessage());
            return 'Fail';
        }
    }
    @AuraEnabled
    public static String fetchAddOnSolList(String opp){
        try{
            List< SOL_Policy__c > solObj = [Select id,Add_on_Holder_DOB__c,Add_on_Holder_Email__c,Add_on_Holder_First_Name__c,Add_on_Holder_Last_Name__c,Add_on_Holder_Middle_Name__c,Add_on_holder_Mobile__c,Add_on_Holder_Relation__c,Applicant_Name__c,Charge_Type__c from SOL_Policy__c where Loan_Application__c =:opp and name like '%add on%'];
            
            SALMobilityOppCntrl_V2.oppData dss = new SALMobilityOppCntrl_V2.oppData();
            
            dss.addOnSolList = solObj;
            return JSON.serialize(dss);        
        }catch(Exception e) {
            
            System.debug('An exception occurred: ' + e.getMessage());
            return 'Fail';
        }
    }
    
    @AuraEnabled
    public static String fetchAddOnSolObject(String solId,String Loanid, String objectFieldJSON){
        try{
            SALMobilityOppCntrl_V2.oppData dss = new SALMobilityOppCntrl_V2.oppData();
            system.debug('before object'+objectFieldJSON);
            if(objectFieldJSON != null && objectFieldJSON != '')
                dss.picklistData = LighteningUtilities.getPicklistValues(objectFieldJSON); 
            system.debug('after object');
            List< SOL_Policy__c > solObj = [SELECT Id,Add_on_Holder_DOB__c,Add_on_Holder_Email__c,Add_on_Holder_First_Name__c,Add_on_Holder_Last_Name__c,Add_on_Holder_Middle_Name__c,Add_on_holder_Mobile__c,Add_on_Holder_Relation__c,Applicant_Name__c,Charge_Type__c  FROM SOL_Policy__c WHERE Id =: solId];
            System.debug('list obj of solObj'+solObj);
            if(!CommonUtility.isEmpty(solObj)){
                dss.solObj = solObj[0];
                dss.status = 'Success';
                
            } 
            return JSON.serialize(dss);
        }catch(Exception e) {
            
            System.debug('An exception occurred: ' + e.getMessage());
            return 'Fail';
        }
    }
    @AuraEnabled
    public static String  saveAddOnCardDetails(String sol,String loanId){//changed return type for bug id 5284 / 24667
        try{
            System.debug('inside saveAddOnCardDetails'+sol); 
             //added for 5284/24667 start
            Opportunity loan = new Opportunity();
            List<Opportunity> oppList = [SELECT id,(select id,Lead__c,Lead__r.Number_of_Add_on_card__c from Product_Offerings__r),(select id,Applicant_Type__c,EMI_Card__c from Loan_Application__r where Applicant_Type__c = 'Primary' limit 1) from Opportunity where id = : loanId];
            if(!CommonUtility.isEmpty(oppList)){
                loan = oppList.get(0);
            }
             Applicant__c applicantObject = new Applicant__c();
             if(loan!= null && loan.Loan_Application__r != null &&loan.Loan_Application__r.size() >0 )
                    applicantObject = loan.Loan_Application__r[0];
                    
                if(loan!= null && loan.Product_Offerings__r != null && loan.Product_Offerings__r.size() >0){
                    Product_Offerings__c  poTemp = loan.Product_Offerings__r[0];
                    if(poTemp.Lead__c != null){
                        if(poTemp.Lead__r.Number_of_Add_on_card__c == -1){
                            if(applicantObject != null && applicantObject.EMI_Card__c == null)
                                return 'EMIError';
                        }   
                    }
                }
            //added for 5284/24667 stop
            SOL_Policy__c solObj  = new SOL_Policy__c();
            // SOL_Policy__c OldsolRec = new SOL_Policy__c();
            if(sol != null)
                solObj = (SOL_Policy__c) JSON.deserialize(sol, SOL_Policy__c.Class);
            if(solObj != null)
                solObj.Name = 'Sales 2.0 Add on Card';
              solObj.Policy_Name__c = 'Add on Card';
            if(solObj.id != null){
                List< SOL_Policy__c > OldsolRec = [SELECT Id,Loan_Application__c,Add_on_Holder_DOB__c,Add_on_Holder_Email__c,Add_on_Holder_First_Name__c,Add_on_Holder_Last_Name__c,Add_on_Holder_Middle_Name__c,Add_on_holder_Mobile__c,Add_on_Holder_Relation__c,Applicant_Name__c,Charge_Type__c  FROM SOL_Policy__c WHERE Id =: solObj.id];
                System.debug('OldsolRec'+OldsolRec);
                SAL_PricingCtrlV2.UpdateAddOnFees(OldsolRec[0],true); 
            }
            upsert solObj;
            System.debug('sol'+solObj.id);
            SAL_PricingCtrlV2.UpdateAddOnFees(solObj,false); 
            return JSON.serialize(solObj);//changed return type for bug id 5284/24667
        }catch(Exception e) {
            
            System.debug('An exception occurred: ' + e.getStacktraceString()+'  ---  '+e.getMessage());
            return null;
        }
    }
    
        /* Method to update fees and charge records*/ 
    public static String UpdateAddOnFees(Sol_Policy__c objName,Boolean isDelete){
        Map<String,Object> SrData= new Map<String,Object>(); 
        SrData = CommonUtility.getMapFromStaticResource('SalariedCustomSettings','AddOnCardChargeId');
        String FinnChargeId = '';
        system.debug('SrData'+SrData); 
       
        system.debug('ChargeType'+objName.Charge_Type__c);
        for(String Key:SrData.keySet()){
            if((String)SrData.get(key)==objName.Charge_Type__c)
            {
                FinnChargeId = key;
                break;
            }
        }
        
        
         system.debug('Finncharge'+FinnChargeId );
         
        List<Fees_and_Charge__c> AddOnFees = [Select id,Deducted_from_Disbursement__c,Instrument_type__c,Change_Amount__c,Finnone_ChargeId__c from Fees_and_Charge__c where Loan_Application__c =: objName.Loan_Application__c AND Finnone_ChargeId__c =: Decimal.Valueof(FinnChargeId)];
        //system.debug('FeesListCA'+AddOnFees);
        //system.debug('FeesListCA'+AddOnFees[0].Change_Amount__c);
        //system.debug('SOLChargeType'+objName.Charge_Type__c);
        try{
            if(!CommonUtility.isEmpty(AddOnFees)){
                if(!isDelete){
                    if(AddOnFees[0].Change_Amount__c == null){
                        system.debug('when charge amount null');
                        AddOnFees[0].Change_Amount__c = 0;
                        
                    }
                     system.debug('when charge amount should stamp');
                     AddOnFees[0].Change_Amount__c += Decimal.ValueOf(objName.Charge_Type__c);
                     /*AddOnFees[0].Deducted_from_Disbursement__c = 'Yes';
                     AddOnFees[0].Instrument_type__c = 'Deduct from Disb';*/
                    
                }
                else{
                    if(AddOnFees[0].Change_Amount__c >0){
                        system.debug('when charge amount deleted');
                        AddOnFees[0].Change_Amount__c -= Decimal.ValueOf(objName.Charge_Type__c); 
                        /*AddOnFees[0].Deducted_from_Disbursement__c = '';
                        AddOnFees[0].Instrument_type__c = '';*/
                    }
                    
                    
                }
                
                if(AddOnFees[0].Change_Amount__c !=0){
                         AddOnFees[0].Deducted_from_Disbursement__c = 'Yes';
                         AddOnFees[0].Instrument_type__c = 'Deduct from Disb';
                }
                else{
                    AddOnFees[0].Deducted_from_Disbursement__c = '';
                    AddOnFees[0].Instrument_type__c = '';
                }
                
                update AddOnFees[0];
            }
            
        }catch(Exception e){
            System.debug('Exception in UpdateAddOnFees '+e.getMessage()+' on line '+e.getLineNumber());
        }
        return 'success';
    } 
    
   //Added for bug 24667 e
    @AuraEnabled
    public static String saveRepaymentObj(String repay,String loanObj){
        System.debug('pk loan 1'+loanObj);
        RePayment_mode_detail__c repayObj = new RePayment_mode_detail__c();
        if(repay != null)
            repayObj = (RePayment_mode_detail__c) JSON.deserialize(repay, RePayment_mode_detail__c.Class);
    
            Opportunity oppObj = new Opportunity ();
            if(loanObj != null)
            oppObj = (Opportunity) JSON.deserialize(loanObj,Opportunity.Class);
            System.debug('pk loan'+oppObj );
            if (!CommonUtility.isEmpty(repayObj)) {
                
                if (repayObj.MICR_Code__c != null) {
                    oppObj.MICR_Number__c = repayObj.MICR_Code__c;
                }
                if (repayObj.A_C_type__c != null) {
                    oppObj.A_C_Type__c = repayObj.A_C_type__c;
                }
                if (repayObj.Account_Holder_Name__c != null) {
                    oppObj.Repayment_Account_Holder_Name__c = repayObj.Account_Holder_Name__c;
                }
                if (repayObj.A_C_NO__c != null) {
                    oppObj.Bank_A_c_No_of_Customer__c = repayObj.A_C_NO__c;
                }
                if (repayObj.Bank_Name__c != null) {
                    oppObj.Repayment_Bank_Name__c = repayObj.Bank_Name__c;
                }
                if (repayObj.Repayment_Mode__c != null) {
                    oppObj.Repayment_Mode__c = repayObj.Repayment_Mode__c;
                }
                if (repayObj.ECS_Start_Date__c != null) {
                    oppObj.First_Due_Date__c = repayObj.ECS_Start_Date__c;
                }
                }
                if (oppObj != null) {
                    try{
                        update oppObj;
                    }
                    catch(Exception e){
                        System.debug('Exception loan'+ e.getMessage()+ '@Line No: '+e.getLineNumber());
                    }
                } 

        if(repayObj != null){
           try{
               upsert repayObj;
               return repayObj.Id;
            }
            catch(Exception e){
             System.debug('Exception repay'+ e.getMessage()+ '@Line No: '+e.getLineNumber());
          
            }
          }
        return null;
    }
    @AuraEnabled
    public static String saveRepaymentObjnew(String repay,String loanObj){
        System.debug('pk loan 1'+loanObj);
        RePayment_mode_detail__c repayObj = new RePayment_mode_detail__c();
        if(repay != null)
            repayObj = (RePayment_mode_detail__c) JSON.deserialize(repay, RePayment_mode_detail__c.Class);
           
            Opportunity oppObj = new Opportunity ();
            if(loanObj != null)
            oppObj = (Opportunity) JSON.deserialize(loanObj,Opportunity.Class);
            System.debug('pk loan'+oppObj );
            if (!CommonUtility.isEmpty(repayObj)) {
                
                if (repayObj.MICR_Code__c != null) {
                    oppObj.MICR_Number__c = repayObj.MICR_Code__c;
                }
                if (repayObj.A_C_type__c != null) {
                    oppObj.A_C_Type__c = repayObj.A_C_type__c;
                }
                if (repayObj.Account_Holder_Name__c != null) {
                    oppObj.Repayment_Account_Holder_Name__c = repayObj.Account_Holder_Name__c;
                }
                if (repayObj.A_C_NO__c != null) {
                    oppObj.Bank_A_c_No_of_Customer__c = repayObj.A_C_NO__c;
                }
                if (repayObj.Bank_Name__c != null) {
                    oppObj.Repayment_Bank_Name__c = repayObj.Bank_Name__c;
                }
                if (repayObj.Repayment_Mode__c != null) {
                    oppObj.Repayment_Mode__c = repayObj.Repayment_Mode__c;
                }
                if (repayObj.ECS_Start_Date__c != null) {
                    oppObj.First_Due_Date__c = repayObj.ECS_Start_Date__c;
                }
                }
                try{
                if (oppObj != null) {
                        update oppObj;
                    }

              if(repayObj != null){
               upsert repayObj;
               return repayObj.Id;
              }
            }catch(Exception e){
             System.debug('Exception repay'+ e.getMessage()+ '@Line No: '+e.getLineNumber());
          
            }
          
        return null;
    }
    public class CurrentDisbDetailsWrapper {
        @AuraEnabled public Current_Disbursal_Details__c disbObj;
        @AuraEnabled public Boolean isTransactionalError;
        @AuraEnabled public Boolean isAPIError;
        @AuraEnabled public String errorMsg;
    }

        @AuraEnabled
    public static CurrentDisbDetailsWrapper invokeCheckIMPS(String cddObject){ 
       //  Current_Disbursal_Details__c currentDisbursalDetails) 
        Current_Disbursal_Details__c currentDisbursalDetails;
       try{
       System.debug('print object cdd  '+cddObject);
        currentDisbursalDetails = (Current_Disbursal_Details__c)JSON.deserialize(cddObject,Current_Disbursal_Details__c.class);
}catch(Exception e){System.debug('Exception '+e.getMessage());}
        System.debug('currentDisbursalDetails -->' + currentDisbursalDetails);
        Current_Disbursal_Details__c disbObj = (Current_Disbursal_Details__c)JSON.deserialize(cddObject, Current_Disbursal_Details__c.class);
        List<String> disMode = (Label.IMPS_Disbursal_Mode).split(';');
        System.debug('disMode --> ' + disMode);
        List<String> errorCodes = Label.IMPS_Error_codes.split(';');
        System.debug('errorCodes --> ' + errorCodes);
        Map<String,Object> IMPSinput = new Map<String,Object>();
        Map<String,String> IMPSresponse = new Map<String,String>();
        List<Current_Disbursal_Details__c> lstToUpdate = new List<Current_Disbursal_Details__c>();

        if (disbObj.Disbursal_Mode__c != null && (new Set<String>(disMode)).contains(disbObj.Disbursal_Mode__c)) {
            System.debug('inside if --> ');
            CurrentDisbDetailsWrapper cddWrapper = new CurrentDisbDetailsWrapper();
            if(disbObj.Successful_IMPS_Count__c == null) disbObj.Successful_IMPS_Count__c = 0;
            if(disbObj.Failure_IMPS_Count__c == null) disbObj.Failure_IMPS_Count__c = 0;

            try {
                System.debug('Print loan application'+disbObj.Loan_Application__c);
                List<Opportunity> oppList = [Select Account.Mobile__c, AccountId From Opportunity Where Id =:disbObj.Loan_Application__c];
                if (oppList != null && oppList.size() > 0) {
                    String reqno = String.valueOf(Datetime.now());
                    String str = reqno.deleteWhitespace();
                    str = str.remove('-');
                    str = str.remove(':');
                    System.debug('reqno --> ' + str);
                    IMPSinput.put('requestId' , str);
                    IMPSinput.put('beneIFSCCode' , disbObj.IFSC_Code__c);
                    IMPSinput.put('beneAccNumber' , disbObj.Bank_Account__c);
                    IMPSinput.put('source' , 'HTS');
                    IMPSinput.put('amount' , Label.IMPS_Transaction_charge);
                    IMPSinput.put('remitterName' , disbObj.Favouring__c);
                    IMPSinput.put('remitterMobile' , oppList[0].Account.Mobile__c);
                    System.debug('IMPSinput --> ' + IMPSinput);
                    if(!Test.isRunningTest()){
                    IMPSresponse = BRECallout.CallIMPSWebService(IMPSinput);
                    }
          else{
            IMPSresponse.put('respDesc','Successful Transaction');
          }
                    System.debug('IMPSresponse --> ' + IMPSresponse);

                    if(IMPSresponse != null && IMPSresponse.size() > 0) {
                        if((IMPSresponse.get('respCode') != null && ((new Set<String>(errorcodes)).Contains(IMPSresponse.get('respCode'))) )|| IMPSresponse.get('respDesc') == 'Internal Server Error') {
                            disbObj.IMPS_Transaction_No__c = IMPSresponse.get('traceNumber');
                            disbObj.IMPS_Result__c = IMPSresponse.get('respDesc');
                            disbObj.IMPSDateTime__c = IMPSresponse.get('dateTime'); 
                          //disbObj.Favouring__c = IMPSresponse.get('beneName'); // Bug -27298
                            disbObj.IMPS_Beneficiary_Name__c = IMPSresponse.get('beneName'); //Bug 26714 27298
                            cddWrapper.errorMsg = 'Internal Server Error.';
                            cddWrapper.isAPIError = true;
                        } else if(IMPSresponse.get('respDesc') != null) {
                            disbObj.IMPS_Transaction_No__c = IMPSresponse.get('traceNumber');
                            disbObj.IMPS_Result__c = IMPSresponse.get('respDesc');
                            disbObj.IMPSDateTime__c = IMPSresponse.get('dateTime'); 
                           // disbObj.Favouring__c = IMPSresponse.get('beneName');// Bug -27298
                            disbObj.IMPS_Beneficiary_Name__c = IMPSresponse.get('beneName'); //bug 26714 27298
                            cddWrapper.isTransactionalError = true;
                            if(IMPSresponse.get('respDesc') == 'Successful Transaction') {
                                disbObj.Successful_IMPS_Count__c++;
                                disbObj.IMPS_Count__c++;
                                cddWrapper.errorMsg = 'Account Validated Succesfully,so no need to collect cancelled cheque.';
                                cddWrapper.isAPIError = false;
                                cddWrapper.isTransactionalError = false;
                            } else {
                                disbObj.Failure_IMPS_Count__c++;
                                disbObj.IMPS_Count__c++;
                                cddWrapper.errorMsg = 'Invalid Bank Account NO.';
                            }
                        }
                    }

                    System.debug('disbObj -->' + disbObj);
                    IMPSAccountChangeHandler.setSkipUpdateAction(true);
                    System.debug('in imps --> ' + IMPSAccountChangeHandler.skipUpdateAction());
                    upsert disbObj;
                    cddWrapper.disbObj = disbObj;
                } // end if
                return cddWrapper;
            } catch (Exception exceptionInstance) {
                System.debug('Something wrong in invokeCheckIMPS --> ' + exceptionInstance.getMessage());
                return null;
            }
        } // end if
        return null;
    }
      @AuraEnabled
    public static List<Fees_and_Charge__c> queryFeesNCharges(Opportunity loanObject)
    {
        List<Fees_and_Charge__c> feesNCharges = new List<Fees_and_Charge__c>();
        return feesNCharges = [select id, name, Finnone_ChargeId__c, Charge_Desc__c, Tranche_Detail__r.name, Deposition_Date__c, Deposit_Slip_Number__c,        Loan_Application__r.name, Change_Amount__c, Charge_Type__c, Deducted_from_Disbursement__c,
        Service_Charge__c, Status__c, Tranche_Detail__c, Instrument_Date__c, Instrument_No__c, Bank_Branch__c, Instrument_type__c,
        Amount_after_Service_Change__c, Tranche_Detail__r.Tranche_Number__c from Fees_and_Charge__c where Loan_Application__c =: loanObject.Id And Identifier__c != 'Mortgage'];
    }
      @AuraEnabled
    public static List<Fees_and_Charge__c> fetchChargesCtrl(Opportunity loanObject)
    {
        Map<String, String> chargesValuesMap = PricingDisbmntDetails_Ctrl.getFetchChargesConfigMap(loanObject);
        system.debug('chargesValuesMap =====>> '+chargesValuesMap);
        BRECallout breCallout = new BRECallout();
        
        //Rohit added for test class
        if(!Test.isRunningTest()){
            Map <String, String> chargesAPIResponse = breCallout.callCharegesAPIService(chargesValuesMap);
            system.debug('chargesAPIResponse =====>> '+chargesAPIResponse);
            if (chargesAPIResponse.get('result') == 'SUCCESS') 
            {
                return queryFeesNCharges(loanObject);
            }
        }
        return null;
    }
    
    
    /* Bug : 17556 S */
     @AuraEnabled 
    public static String saveBankRecord(String bankRec) {
        return SALMobilityOppCntrl_V2.updateBankRec(bankRec);
        
    }
    //added for bug id 18669 start
     @AuraEnabled
    public static eKYC__c getEkycRec(String ranNum)
    {
       system.debug('ranNum inside aura apex : '+ranNum);
       return SALMobilityOppCntrl_V2.getEkycRec(ranNum);
    }
     //added for bug id 18669 end
       @AuraEnabled
    public static String sendBackToCredit(String oppObj){
        Opportunity oppOb = (Opportunity)JSON.deserialize(oppObj,Opportunity.class);
        update oppOb;
         PricingDisbmntDetails_Ctrl.loanIdfoMob = oppOb.id;
        PricingDisbmntDetails_Ctrl obj = new PricingDisbmntDetails_Ctrl();
        obj.SendBackFunctionality();
        system.debug('status is'+obj.mobilitystatus);
        return obj.mobilitystatus;
    }
    @AuraEnabled
    public static SALMobilityController.DetailsWrapperClass checkRedirectionValidity(String oppId, String flowName,string version)
    {
        return SALMobilityController.checkRedirectionValidity(oppId,flowName,version);
    }
    // added for bug id 21851 start
    @AuraEnabled
    public static boolean getHideAadhaarSection()
    {   
        return Boolean.valueOf(CommonUtility.getAadhaarSectionStatus('Ekyc_Integration','hideAadhaarSection',''));
    }
    //added for bug id 21851 stop
   //Bug Id 22182 start
       public static String calculateEMIValue(Opportunity loan,Applicant__c applicantprimary) {
           try{
        Decimal emiVal = 0.0;
        Boolean IsHybridFlexi;
        //List<Opportunity> oppList=[select id,EMI_CAM__c,Scheme_Master__c,Approved_Tenor__c,Approved_Rate__c,Loan_Amount_with_Premium__c,Scheme_Master__r.IsHybridFlexi__c from Opportunity where id =: oppId ];
        //Opportunity loan=oppList[0];
        //Applicant__c applicantprimary=[select id,Pure_Flexi_Period__c,Drop_Line_Flexi_Period__c,Pure_Flexi_EMI__c from Applicant__c where Loan_Application__c =: oppId AND Applicant_Type__c ='Primary' ];
        if (loan != null) {
            System.debug('isHybridFlexi1 -->'+loan.Scheme_Master__r.IsHybridFlexi__c);
            if(!CommonUtility.isEmpty(loan.Scheme_Master__c) && !CommonUtility.isEmpty(loan.Scheme_Master__r.IsHybridFlexi__c) && loan.Scheme_Master__r.IsHybridFlexi__c == true)
                IsHybridFlexi = true;
            else 
                IsHybridFlexi = false;  
            System.debug('isHybridFlexi -->'+IsHybridFlexi);
            
            /*Hybrid Flexi :akshata Start*/
            System.debug('in method'+Loan.Approved_Rate__c);
            if(applicantPrimary != null && IsHybridFlexi!= null && IsHybridFlexi)
            {   
                System.debug('in Loan.Loan_Amount_with_Premium__c ->'+Loan.Loan_Amount_with_Premium__c+'Loan.Approved_Rate__c -->'+Loan.Approved_Rate__c);
                Double result = 0.0;
                if(Loan.Loan_Amount_with_Premium__c != null && applicantPrimary.Pure_Flexi_Period__c != null && Loan.Approved_Rate__c != null)
                {
                    result = Math.round((Loan.Loan_Amount_with_Premium__c *Loan.Approved_Rate__c) / 1200);
                    System.debug('result-->'+result);
                }
                applicantPrimary.Pure_Flexi_EMI__c =  result;
                if (Loan.Loan_Amount_with_Premium__c != null && Loan.Approved_Rate__c != null)
                    Loan.EMI_CAM__c = (SAL_PricingCtrlV2.PMTV2(double.valueOf(Loan.Approved_Rate__c / 1200), Integer.valueOf(applicantPrimary.Drop_Line_Flexi_Period__c), Loan.Loan_Amount_with_Premium__c));
                
                System.debug('applicantPrimary.Pure_Flexi_EMI__c-->'+applicantPrimary.Pure_Flexi_EMI__c);
                //upsert applicantPrimary;
                
                //upsert loan;
                return String.valueof(Loan.EMI_CAM__c);
            }/*Hybrid Flexi :akshata End*/
            else{
                System.debug('Loan.Loan_Amount_with_Premium__c==' + Loan.Loan_Amount_with_Premium__c + '%%%rate ' + Loan.Approved_Rate__c + '%%%%Tenor' + Loan.Approved_Tenor__c);
                if (Loan.Loan_Amount_with_Premium__c != null && Loan.Approved_Tenor__c != null && Loan.Approved_Rate__c != null)
                    Loan.EMI_CAM__c = (SAL_PricingCtrlV2.PMTV2(double.valueOf(Loan.Approved_Rate__c / 1200), Integer.valueOf(Loan.Approved_Tenor__c), Loan.Loan_Amount_with_Premium__c));
                   //Loan.EMI_CAM__c=decimal.valueof((PMT(double.valueof(Loan.Approved_Rate__c/1200),integer.valueof(Loan.Approved_Tenor__c),double.valueof(LoanPremPlusInsuPre))).divide(1, 0, System.RoundingMode.UP)); 
                //upsert loan;
                return String.valueof(Loan.EMI_CAM__c);
            }
            
        }
        return null;
         }catch(Exception e)
         {
             System.debug('Exceptione e'+e.getMessage()+e.getLineNumber());
             return null;
         }
     }
     public class calculateEMIVal implements Queueable,database.Allowscallouts {
        private string oppId;
        
        public calculateEMIVal(string loanid) {
            this.oppId = loanid;
        }
        public void execute(QueueableContext context) {
            try{
                Decimal emiVal = 0.0;
                Boolean IsHybridFlexi;
                List<Opportunity> oppList=[select id,EMI_CAM__c,Scheme_Master__c,Approved_Tenor__c,Approved_Rate__c,Loan_Amount_with_Premium__c,Scheme_Master__r.IsHybridFlexi__c from Opportunity where id =: oppId ];
                Opportunity loan=oppList[0];
                Applicant__c applicantprimary=[select id,Pure_Flexi_Period__c,Drop_Line_Flexi_Period__c,Pure_Flexi_EMI__c from Applicant__c where Loan_Application__c =: oppId AND Applicant_Type__c ='Primary' ];
                if (loan != null) {
                    System.debug('isHybridFlexi1 -->'+loan.Scheme_Master__c);
                    if(!CommonUtility.isEmpty(loan.Scheme_Master__c) && !CommonUtility.isEmpty(loan.Scheme_Master__r.IsHybridFlexi__c) && loan.Scheme_Master__r.IsHybridFlexi__c == true)
                        IsHybridFlexi = true;
                    else 
                        IsHybridFlexi = false;  
                    System.debug('isHybridFlexi -->'+IsHybridFlexi);
                    
                    /*Hybrid Flexi :akshata Start*/
                    System.debug('in method'+Loan.Approved_Rate__c);
                    if(applicantPrimary != null && IsHybridFlexi!= null && IsHybridFlexi)
                    {   
                        System.debug('in Loan.Loan_Amount_with_Premium__c ->'+Loan.Loan_Amount_with_Premium__c+'Loan.Approved_Rate__c -->'+Loan.Approved_Rate__c);
                        Double result = 0.0;
                        if(Loan.Loan_Amount_with_Premium__c != null && applicantPrimary.Pure_Flexi_Period__c != null && Loan.Approved_Rate__c != null)
                        {
                            result = Math.round((Loan.Loan_Amount_with_Premium__c *Loan.Approved_Rate__c) / 1200);
                            System.debug('result-->'+result);
                        }
                        applicantPrimary.Pure_Flexi_EMI__c =  result;
                        if (Loan.Loan_Amount_with_Premium__c != null && Loan.Approved_Rate__c != null)
                            Loan.EMI_CAM__c = (SAL_PricingCtrlV2.PMTV2(double.valueOf(Loan.Approved_Rate__c / 1200), Integer.valueOf(applicantPrimary.Drop_Line_Flexi_Period__c), Loan.Loan_Amount_with_Premium__c));
                        
                        System.debug('applicantPrimary.Pure_Flexi_EMI__c-->'+applicantPrimary.Pure_Flexi_EMI__c);
                        upsert applicantPrimary;
                        
                        upsert loan;
                        
                    }/*Hybrid Flexi :akshata End*/
                    else{
                        System.debug('Loan.Loan_Amount_with_Premium__c==' + Loan.Loan_Amount_with_Premium__c + '%%%rate ' + Loan.Approved_Rate__c + '%%%%Tenor' + Loan.Approved_Tenor__c);
                        if (Loan.Loan_Amount_with_Premium__c != null && Loan.Approved_Tenor__c != null && Loan.Approved_Rate__c != null)
                            Loan.EMI_CAM__c = (SAL_PricingCtrlV2.PMTV2(double.valueOf(Loan.Approved_Rate__c / 1200), Integer.valueOf(Loan.Approved_Tenor__c), Loan.Loan_Amount_with_Premium__c));
                        //Loan.EMI_CAM__c=decimal.valueof((PMT(double.valueof(Loan.Approved_Rate__c/1200),integer.valueof(Loan.Approved_Tenor__c),double.valueof(LoanPremPlusInsuPre))).divide(1, 0, System.RoundingMode.UP)); 
                        upsert loan;
                    } 
                    
                }
            }catch(Exception e)
            {
                System.debug('Exceptione e'+e.getMessage()+e.getLineNumber());
                
            }
        }
    }
    
      public static double PMTV2(double rate, integer nper, decimal pv) {
        system.debug('******rate********' + rate + '**nper*' + nper + '*pv**' + pv);
        Double result = 0.0;
        if (pv != null && rate != null && nper != null) {
            result = Math.round((pv * rate) / (1 - Math.pow(1 + rate, -nper)));
            system.debug('****result**' + result);
        }
        return result;
    }  //Bug Id 22182
    
    //Bug:20391 Start
     @AuraEnabled
    public static CurrentDisbDetailsWrapper invokeRecheckIMPS(String cddObject){ 
       //  Current_Disbursal_Details__c currentDisbursalDetails)
       system.debug('Inside recheck'); 
       System.debug('print object cdd  '+cddObject);
         Current_Disbursal_Details__c currentDisbursalDetails = (Current_Disbursal_Details__c)JSON.deserialize(cddObject,Current_Disbursal_Details__c.class);

        System.debug('currentDisbursalDetails -->' + currentDisbursalDetails);
        Current_Disbursal_Details__c disbObj = currentDisbursalDetails;//(Current_Disbursal_Details__c)JSON.deserialize(currentDisbursalDetails, Current_Disbursal_Details__c.class);
        Map<String,Object> IMPSrecheckinput = new Map<String,Object>();
        Map<String,String> IMPSrecheckresponse = new Map<String,String>();
        List<String> errorCodes = Label.IMPS_Error_codes.split(';');
        System.debug('errorCodes --> ' + errorCodes);
        List<Current_Disbursal_Details__c> lstToUpdate = new List<Current_Disbursal_Details__c>();

        if (disbObj != null) {
            System.debug('inside if --> ');
            CurrentDisbDetailsWrapper cddWrapper = new CurrentDisbDetailsWrapper();
            //if(disbObj.Successful_IMPS_Count__c == null) disbObj.Successful_IMPS_Count__c = 0;
            //if(disbObj.Failure_IMPS_Count__c == null) disbObj.Failure_IMPS_Count__c = 0;

            try {
                System.debug('Print loan application'+disbObj.Loan_Application__c);
                List<Opportunity> oppList = [Select Account.Mobile__c, AccountId From Opportunity Where Id =:disbObj.Loan_Application__c];
                if (oppList != null && oppList.size() > 0) {
                    String reqno = String.valueOf(Datetime.now());
                    String str = reqno.deleteWhitespace();
                    str = str.remove('-');
                    str = str.remove(':');
                    System.debug('reqno --> ' + str);
                    IMPSrecheckinput.put('requestId' , str);
                    IMPSrecheckinput.put('traceNumber' , disbObj.IMPS_Transaction_No__c);
                    System.debug('IMPSrecheckinput --> ' + IMPSrecheckinput);
                    IMPSrecheckresponse = BRECallout.CallIMPSRecheckWebService(IMPSrecheckinput);
                    System.debug('IMPSrecheckresponse --> ' + IMPSrecheckresponse);

                    if(IMPSrecheckresponse != null && IMPSrecheckresponse.size() > 0) {
                        if((IMPSrecheckresponse.get('respCode') != null && ((new Set<String>(errorcodes)).Contains(IMPSrecheckresponse.get('respCode'))) )|| 
                        IMPSrecheckresponse.get('respDesc') == 'Internal Server Error' ||(disbObj.IMPS_Result__c != null && disbObj.IMPS_Result__c == IMPSrecheckresponse.get('respDesc')) ) {
                            cddWrapper.errorMsg = IMPSrecheckresponse.get('respDesc');
                        } else if(IMPSrecheckresponse.get('respDesc') != null && IMPSrecheckresponse.get('respDesc') != '') {
                            disbObj.IMPS_Transaction_No__c = IMPSrecheckresponse.get('traceNumber');
                            disbObj.IMPS_Result__c = IMPSrecheckresponse.get('respDesc');
                            disbObj.IMPSDateTime__c = IMPSrecheckresponse.get('dateTime'); 
                            disbObj.IMPS_Beneficiary_Name__c = IMPSrecheckresponse.get('beneName');// Bug-27298
                            disbObj.IMPS_Beneficiary_Name__c = IMPSrecheckresponse.get('beneName');
                            cddWrapper.isTransactionalError = true;
                            if(IMPSrecheckresponse.get('respDesc') == 'Successful Transaction') {
                                disbObj.Successful_IMPS_Count__c++;
                                cddWrapper.errorMsg = 'Account Validated Succesfully,so no need to collect cancelled cheque.';
                                cddWrapper.isAPIError = false;
                                cddWrapper.isTransactionalError = false;
                            } else {
                                disbObj.Failure_IMPS_Count__c++;
                                cddWrapper.errorMsg = disbObj.IMPS_Result__c;
                            }
                        }
                    }

                    System.debug('disbObj -->' + disbObj);
                    IMPSAccountChangeHandler.setSkipUpdateAction(true);
                    System.debug('in imps --> ' + IMPSAccountChangeHandler.skipUpdateAction());
                    upsert disbObj;
                    cddWrapper.disbObj = disbObj;
                } // end if
                return cddWrapper;
            } catch (Exception exceptionInstance) {
                System.debug('Something wrong in reCheckIMPS --> ' + exceptionInstance.getMessage());
                return null;
            }
        } // end if
        else
        return null;
    }
    //Bug:20391 End
    //Bug 22064 --S
  @AuraEnabled
    public static String fetchDisbList(String loanId){
        system.debug('inside fetch disb list');
        try{
           list<Current_Disbursal_Details__c> disbRecList = [Select Id,Name,Favouring__c from Current_Disbursal_Details__c where Loan_Application__c = : loanId];
            return JSON.serialize(disbRecList);
        }catch(Exception e)
        {
            System.debug('Exception  '+ e.getLineNumber() + e.getMessage());
        }
        return null;         
    }
    //Bug 22064--E
    
    //Bug 21287---S
    @AuraEnabled
    public static String getdataOnDisbLoad(String loanId){
      String profileId = userinfo.getProfileId();
      Profile userProfile = [select Name from profile where id = :profileId];
      set<String> bankIFSC = new set<String>(); //Bug:23767**PROD Issue**
      //list<Current_Disbursal_Details__c> disbDetails = [Select Id,Name,IFSC_Code__c from Current_Disbursal_Details__c
      //                                                 Where Loan_Application__c = :loanId];
      //SAL 2.0 issues ***S**
      list<Current_Disbursal_Details__c> disbDetails = [Select /*IMPS Account Validate Added Account_Validated__c*/ Account_Validated__c,/*20391 Added IMPS_Transaction_No__c,IMPS_Account_Validate__c,IMPS_Count__c*/IMPS_Count__c,IMPS_Transaction_No__c,IMPS_Account_Validate__c,id,Repay_Disb_Diff__c, UMRN__c,Disbursement_To__c, IMPS_Flag__c, Bank_Branch__c, name, Tranche_Detail__c, Loan_Application__c, Internal_Closure__c, Disbursement_Amount__c, Disbursal_Mode__c, Disbursement_Date__c,
                                          FinnOne_Disbursement_Date__c,Successful_IMPS_Count__c,Failure_IMPS_Count__c ,IFSC_Code__c, Favouring__c,isTopUp__c,Tranche_Detail__r.Tranche_Number__c, Bank_Name__c, Bank_Account__c, Payable_at__c, Credit_Days__c, IMPS_Result__c
                                          from Current_Disbursal_Details__c Where Loan_Application__c = :loanId];
      //SAL 2.0 issues ***E**
      //Bug:23767**PROD Issue**S**
      for(Current_Disbursal_Details__c dList: disbDetails){
          bankIFSC.add(dList.IFSC_Code__c);
      }
        system.debug('Banks from screen****'+bankIFSC);
      //Bug:23767**PROD Issue**E**
      list<Opportunity> loanData = [Select Id,Product__c,Name From Opportunity Where Id =:loanId];
      Map<String,String> Mymap = new Map<String,String>();
      list<String> impsBank = new list<String>();
      set<String> impsEnabledBank = new Set<String>();
      list<IFSC_Master__c> ifscList = [Select Id,IFSC_Code__c,Branch__c from IFSC_Master__c WHERE Is_IMPS_Enabled__c = true AND IFSC_Code__c IN :bankIFSC]; //Bug:23767**Added IFSC Code condition
      for(IFSC_Master__c iList: ifscList){
        impsEnabledBank.add(iList.IFSC_Code__c);
       }
        system.debug('Banks from query****'+impsEnabledBank);
      impsBank.addAll(impsEnabledBank);
      for(Current_Disbursal_Details__c dList: disbDetails ){
          if(impsBank.contains(dList.IFSC_Code__c)){
              Mymap.put(dList.Id,dList.IFSC_Code__c);
          }
      }
      system.debug('IFSC code list****'+Mymap);
      JSONGenerator jGen = JSON.createGenerator(true);
            jGen.writeStartObject();
            jGen.writeStringField('ProfileName', userProfile.Name);
            jGen.writeStringField('IMPSbanks', JSON.serialize(Mymap));
            jGen.writeStringField('LoanData', JSON.serialize(loanData));
            jGen.writeStringField('DisbData', JSON.serialize(disbDetails)); //SAL 2.0 issues
            jGen.writeEndObject();                                 
            return jGen.getAsString();
      }
    //Bug 21287--E
    
    //Bug-22785(Related to 20391) start
    @AuraEnabled
    public static String saveIMPSResponse(String disbId,String accountValidate){
    
        Current_Disbursal_Details__c disbObj  = new Current_Disbursal_Details__c();
        try{
            disbObj = [Select Id,Name,IMPS_Account_Validate__c from Current_Disbursal_Details__c where Id = : disbId];
            disbObj.IMPS_Account_Validate__c = accountValidate;
            if(disbObj != null){
                upsert disbObj;
            }
            return 'SUCCESS';
        }catch(Exception e)
        {
            System.debug('Exception  '+ e.getLineNumber() + e.getMessage());
            return null;
        }
    }
    //Bug-22785(Related to 20391) End
    @AuraEnabled
    public static String getvalidExotelProducts(){
        return SALMobilityPOCntrl_V2.getvalidExotelProduct();
    }
    /* added by swapnil for centralized sampling US 5331 s */
    @AuraEnabled
    public static String checkCentralizedSampling(String loanid,String jsonOppobj,String jsonAppobj,String jsonBankObj,String jsonAccountObj,String CentralisedSOL){
        return SALMobilityOppCntrl_V2.checkCentralizedSampling(loanid,jsonOppobj,jsonAppobj,jsonBankObj,jsonAccountObj,CentralisedSOL);         
    }
      /* added by swapnil for centralized sampling  US 5331 e */
    @auraenabled
    public static String callToCustomer(String frommobile,String tomobile,String Id,String objName,String Product){
        System.debug('Controller 1  frommobile '+frommobile+' tomobile '+tomobile+' Id '+Id+' objName '+objName+'PROD'+Product);
     //  return CommonUtility.callToCustomer(frommobile,tomobile,Id,objName);
     sObject commObj;
        if(objName.equalsIgnoreCase('Lead')){
            commObj=[select id,name from lead where id = : Id];
        }else if(objName.equalsIgnoreCase('Applicant__c')){
             commObj=[select id,name from Applicant__c where id = : Id];
        }
     // return 'null';
        return CommonUtility.callToCustomer(frommobile,tomobile,commObj.id,Product); // method signature changed by amar for Exotel enhancement
        
    } 
}