public without sharing class SALMobilityPricingCntrl_V2 {
//25097 start
public List<SOL_Policy__c> solobjLst {get;set;}
public Fees_and_Charge__c FFRCharges  {get;set;}
 public Fees_and_Charge__c coBrandedCC {get;set;}
 public Fees_and_Charge__c CPPWalletfees {get;set;}
 public Fees_and_Charge__c EMICardFees {get;set;} 
 public String strImg  {get;set;} //26998
  public String ObjstrImg  {get;set;} //26998
 
public String insProduct{get;set;}
  public string bankAddress {get;set;}
  public String CPPWalletfeesNA {get;set;}
    public String EMICardFeesNA {get;set;}
    public String FFRChargesNA {get;set;}  
    public  String acceptanceDate {get;set;}
 //25097 stop
 //25097 start
    public List<InsuranceQuestionnaireCtrl.FeedbackQueWrapper> FeedbackWrpList{get;set;}
    
    public InsuranceQuestionnaireCtrl insQ{get;set;}
    //25097 stop
    //977
       public static Decimal crossSellAmt    {
        get;
        set;
    }//977
    /*SAL 2.0 CR's s*/
    public Boolean isPreview{
        get;
        set;
    }
    /*SAL 2.0 CR's e*/
//17556 start - hrushikesh
public String result;

public String getResult() {
    return result;
}
    //prod psf access CR start
    public String appMobile{get;set;}
    public String coAppMobile{get;set;}
    public String appPermMobile{get;set;}
    public String coAppPermMobile{get;set;}
    public String appPersonalMail{get;set;}
    public String coappPersonalMail{get;set;}
    public String appOfficeMail{get;set;}
    public String coappOfficeMail{get;set;}
    public String apptelphone{get;set;}
    public String coapptelephone{get;set;}
    public String appofftelno{get;set;}
    public String coappofftelno{get;set;}
    public String apppermtelephone{get;set;}
    public String coapppermtelephone{get;set;}
    //prod psf access CR end
public String viewAs {get;set;}
public String iptimeStamp{get;set;}
public String avgSal{get;set;}
public String avgSalCo{get;set;}
public Applicant__c applicantObj{get;set;}
public Applicant__c coapp{get;set;}
public Opportunity oppObj{get;set;}
public Account accObj{get;set;}
public RePayment_mode_detail__c repayObj{get;set;}
public DPLInsurance__c insObj{get;set;}
public List<DPLInsurance__c> insList{get;set;}
public ekyc__c ekycObj{get;set;}
public ekyc__c ekycObjCoapp{get;set;}
public static String DuplicateLoanId{get;set;}
public static String DuplicateBarCodeNo{get;set;}
public static String DuplicateLAN{get;set;}
public String encryptLoanId;//Encrypt URL
public SALMobilityPricingCntrl_V2()
{
     insProduct = '';//25097
     solobjlst = new list<SOL_Policy__c>();//25097
    /*SAL 2.0 CR's s*/
    if (ApexPages.currentPage().getParameters().get('isPreview') == 'true')
        isPreview = true;
    else
        isPreview = false;
    /*SAL 2.0 CR's e*/
    //String id = ApexPages.currentPage().getParameters().get('id');//Encrypt URL
        String id;//Encrypt URL S
       if(System.currentPageReference() != null && System.currentPageReference().getParameters().get('id') != null)
            {
              encryptLoanId = apexPages.currentPage().getParameters().get('id');
              if(encryptLoanId.length() == 15 || encryptLoanId.length() == 18)
                  id= encryptLoanId;
              else
                  id= CommonUtility.decryptURLParam(encryptLoanId); 
            }//Encrypt URL E
    String pROI = ApexPages.currentPage().getParameters().get('pROI');
    String pPF = ApexPages.currentPage().getParameters().get('pPF');
    String designation = ApexPages.currentPage().getParameters().get('desi');
    List<Applicant__c> appList;
    String pageName=ApexPages.currentPage().getUrl();
    if (ApexPages.currentPage().getParameters().get('renderFor') == 'pdf')
        viewAs = 'pdf';
    else
        viewAs = null;
    //application form starts
    List<Applicant__c> applicantList = [select Contact_Name__r.Office_Landline_Number1__c,Contact_Name__r.DesignationOTP__c,Contact_Name__r.Months_of_Residence__c,Applicant_Image__c,Application_Form_Timestamp__c,IP_Address_Timestamp__c ,Vehicle_Registration_number__c,Identity_Document_Expiry_Date__c,Proof_of_Identity__c,Proof_of_Residence_Address_Submitted__c ,Contact_Name__r.Permanent_Mobile__c, Contact_Name__r.Permenant_Phone__c,Proof_of_Address_Submitted_for_Permanent__c ,Contact_Name__r.Permanent_Address_same_as_Residence__c ,Contact_Name__r.Father_Spouse__c ,Pure_Flexi_Period__c,Pure_Flexi_EMI__c,Contact_Name__r.Father_Spouse_First_Name__c,Contact_Name__r.Father_Spouse_Middle_Name__c,Contact_Name__r.Father_Spouse_Last_Name__c ,
                                        Contact_Name__r.Mother_First_Name__c,Contact_Name__r.Mother_Middle_Name__c,Contact_Name__r.Mother_Last_Name__c,/*added for bug 23479*/Contact_Name__r.Email__c,/*added for bug 23479*/
                                        Contact_Name__r.Months_at_Residence__c,RC_Deviation__c,Contact_Name__r.Permanant_City__c,Refferal_Identifier__c,Financial_Health_Check_Guide__c,Elite_Card__c,Cibil_Retrigger_Initiated__c,Company_Name_as_per_Domain_check__c,Domain_Email_Remark__c,PANBREDone__c,/*Ekyc Start */Consent_on_app_form__c,eKYC_Processing__c,HashCode__c,/*Ekyc stop */id,Risk_Segmentation__c,Contact_Name__r.Years_At_Residence__c, Contact_Name__r.office_no_check_on_company_site__c, Contact_Name__r.SFDC_Dedupe_check__c, Contact_Name__r.PAN_Response__c, Contact_Name__r.Linkedin_check_result__c, Contact_Name__r.Google_check_result__c, Contact_Name__r.PAN__c, Contact_Name__r.Last_Modified_Date__c, Contact_Name__r.Name_of_the_PAN_holder__c, Contact_Name__r.Employer__r.Domain_Name__c, Contact_Name__r.Employer__r.Company_Category__c, Existing_Customer__c, Owned_Residence__c, Is_spouse_Working_Financial_CoApp__c, Loan_Application__r.Scheme_Master__c, Name, Contact_Name__r.Mobile__c, Loan_Application__r.Requested_ROI__c, Loan_Application__r.Sourcing_Channel__r.branch__c, Loan_Application__r.Referral__c, Loan_Application__r.Existing_Customer__c, Loan_Application__r.Account.Sourcing_Channel__r.branch__c, Update_CIBIL_Error__c, Descriptin__c, Type_of_Borrower__c, Re_Initiate_De_Dupe__c, Integrate_with_CIBIL__c, Contact_Name__c, Contact_Name__r.Name, Contact_Name__r.Customer_Profile__c,
                                        Contact_Name__r.Designation__c,Codified_CIBIL__c, Contact_Name__r.Employer_Name__c,Contact_Name__r.Residence_Landline_phone__c, Contact_Name__r.Qualification__c, Contact_Name__r.Address_1__c, Contact_Name__r.Total_Work_Experience_Months__c,Contact_Name__r.Total_Work_Experience_Yrs__c, Contact_Name__r.Current_experiance_in_Years__c,
                                        DPD_cluster_Segment__c,PD_Status__c, Bank_Status__c, FINANCIAL_VERIFICATION__c, Contact_Name__r.Address_2__c, FCU_Status__c, ITR_Status__c, Office_SE_Status__c, Office_SAL_Status__c, Contact_Name__r.Company_Category__c,
                                        Office_Status__c, Pay_Slips_Status__c, Residence_Status__c, Trade_Status__c, TVR_Status__c, Select_Applicant__c, Applicant_Type__c, Contact_Name__r.Customer_Type__c, Contact_Name__r.ApplicantType__c,
                                        Contact_Name__r.Office_Contact_Number__c,Contact_Name__r.Current_experiance_in_Month__c,Contact_Name__r.Date_of_Birth__c, Contact_Name__r.FathersHusbands_Name__c, Contact_Name__r.PAN_Number__c, Contact_Name__r.Year_of_Incorporation__c, Contact_Name__r.Account.TIN_Number__c,
                                        Contact_Name__r.Occupation_CKYC__c,Contact_Name__r.Bank_Account_No__c, Contact_Name__r.VoterID_Number__c, Contact_Name__r.ROC_Regn_No__c, Contact_Name__r.Address_3__c, Contact_Name__r.AppCity__c, Contact_Name__r.Residence_Type__c,
                                        Contact_Name__r.Pin_Code__c, Contact_Name__r.Phone, Contact_Name__r.MobilePhone, Contact_Name__r.Email, Contact_Name__r.Address_Line_One__c, Contact_Name__r.Address_2nd_Line__c, Contact_Name__r.Address_3rd_Line__c,
                                        Contact_Name__r.Driving_License_Number__c,Contact_Name__r.PassPort_Number__c,Contact_Name__r.Permanent_Land_Mark__c, Contact_Name__r.Office_City__c, Contact_Name__r.Office_Pin_Code__c, Contact_Name__r.Office_STD_Code__c, Contact_Name__r.Office_Phone_Number__c, SegmentaionResult__c,
                                        Contact_Name__r.Mobile_Phone__c,Contact_Name__r.Gross_Salary__c, Contact_Name__r.Office_Email_Id__c, Contact_Name__r.Middle_Name__c, Employer__c, Company_Type__c, Company_Name__c, Contact_Name__r.Company_Type__c, Contact_Name__r.Age_of_Applicant__c,
                                        DIN_No_if_applicable__c, Contact_Name__r.FirstName, Contact_Name__r.LastName, Contact_Name__r.Permanant_Address_Line_1__c, Contact_Name__r.Permanant_Address_Line_2__c, Contact_Name__r.Permanant_Address_Line_3__c,
                                        Contact_Name__r.Permanent_STD__c, Contact_Name__r.Permanent_Pin_Code__c, Contact_Name__r.Year_in_Present_Job__c, Contact_Name__r.Year_in_Previous_Job__c, Contact_Name__r.Name_of_the_company_Employer__c,
                                        Contact_Name__r.Nature_of_Business__c, Contact_Name__r.Employment_Status__c, Contact_Name__r.Gender__c, Contact_Name__r.Age__c, Contact_Name__r.Employment_Type__c, Contact_Name__r.STD_Code__c, Contact_Name__r.Phone_Number__c,
                                        Contact_Name__r.Aadhar_Number__c, Contact_Name__r.Name_of_Employer__c, Designation__c, Contact_Name__r.Type_Of_Constitution__c, Contact_Name__r.Marital_Status__c, Contact_Mobile__c, Contact_Name__r.Residence_City__c, Contact_Name__r.Sex__c,
                                        Contact_Name__r.Employer__r.name, Contact_Name__r.TAN_Number__c, Contact_Name__r.TAN_Found_In_Master__c, Contact_Name__r.Email_Domain_Status__c, Contact_Name__r.Bank_Name1__c, CIBIL_Score__c,
                                        Contact_Name__r.Bank_Name_Status1__c, Contact_Name__r.PAN_Card_Status__c, Comments__c, Contact_Name__r.CIBIL_Report__c, Contact_Name__r.Office_Email_Id_for_Fraud__c, Contact_Name__r.TAN__c,
                                        All_Deviation_Docs_Received__c, All_Disbursement_Docs_Received__c, All_Standard_Docs_Received__c, Is_PL_BT__c, ContactName__c, Contact_Name__r.Customer_address_matches_with_perfios__c, Contact_Name__r.Email_Confirmation_received__c,
                                        Customer_Name__c, Loan_Application__r.Account.id, Contact_ID__c, Customer_ID__c, Product__c, IsUpdated__c, Decision_Date__c, RSA_reason__c, Loan_App_Number_up__c, Contact_Name__r.Customer_address_matches_with_eKYC__c,
                                        Loan_Application__r.Product__c, Loan_Application__r.Account.Sourcing_Channel__c, Loan_Application__r.Account.Tenor__c, Loan_Application__r.Account.Referral_Name__c, Permanent_Address_Verification__c, Bureau_Segment__c,
                                        Loan_Application__r.Employee_Type__c, Loan_Application__r.Loan_Application_Number__c, Loan_Application__r.Loan_Amount__c, Loan_Application__r.Tenor__c, Contact_Name__r.Customer_Add_Matches_With_Previous_Add__c,
                                        Tele_PD__c, Physical_PD__c, CLINIC_HOSPITAL__c, PAN_Number__c, Employer_Check__c, PAN_Check__c ,Dedupe_Linking_Done__c,Reject_Reason__c,/*25097*/CKYC_No__c,/*25097*/
                                        (SELECT eKYC_First_Name__c,eKYC_Last_Name__c,eKYC_Photo__c from ekyc__r)
                                         from Applicant__c where Loan_Application__c =: id ];
    for(Applicant__c app : applicantList ){
        if(app.Applicant_Type__c == 'Primary'){
            applicantObj=app;
             //25097  //26998 s
                 String firstSubString ='';
                if(! CommonUtility.isEmpty(applicantObj) && !CommonUtility.isEmpty(applicantObj.Applicant_Image__c))
                  firstSubString = applicantObj.Applicant_Image__c;//.substringBetween('<img', 'img>');
                 if(!CommonUtility.isEmpty(firstSubString))
                     strImg = firstSubString.substringBetween('src="', '"');
                  System.debug('First substring: app ' + firstSubString);
                
                 System.debug('strImg: ' + strImg);
                //25097//26998 s
                
                //prod psf access CR start
                appMobile = String.valueOf(app.Contact_Name__r.Mobile__c);
                appPermMobile = app.Contact_Name__r.Permanent_Mobile__c;
                appOfficeMail = app.Contact_Name__r.Office_Email_Id__c;
                apptelphone = app.Contact_Name__r.Residence_Landline_phone__c;
                appofftelno = app.Contact_Name__r.Office_Phone_Number__c;
                apppermtelephone = app.Contact_Name__r.Permenant_Phone__c;
                //prod access CR end
            if(!CommonUtility.isEmpty(app.eKYC__r))
                ekycObj = app.eKYC__r[0];
                
             /*25097 start*/
                String iptime;
                if(!CommonUtility.isEmpty(app.IP_Address_Timestamp__c) && app.IP_Address_Timestamp__c != 'Acceptance Pending'){
                    iptime= app.IP_Address_Timestamp__c;             
                    integer i = iptime.indexOf('||');
                    String str = '';
                    if(i != -1)
                        str = iptime.subString(i + 2, i + 14);
                    
                    acceptanceDate = str;
                    system.debug('accepteddate>>>' + acceptanceDate); 
                }
                if(CommonUtility.isEmpty(acceptanceDate)){
                    acceptanceDate=String.valueof(System.Today());
                }
                    /*25097 end*/
        }
        else{
            coapp = app;
            
             /*26998 s*/
                 String firstSubString ='';
                if(! CommonUtility.isEmpty(coapp) && !CommonUtility.isEmpty(coapp.Applicant_Image__c))
                  firstSubString = coapp.Applicant_Image__c;//.substringBetween('<img', 'img>');
                 if(!CommonUtility.isEmpty(firstSubString))
                     ObjstrImg = firstSubString.substringBetween('src="', '"');
                  System.debug('First substring coapp: ' + firstSubString);
                
                 System.debug('strImg coapp: ' + ObjstrImg);
               /*26998 s*/
                
                //prod PSF access CR start
                coAppMobile = String.valueOf(app.Contact_Name__r.Mobile__c);
                coAppPermMobile = app.Contact_Name__r.Permanent_Mobile__c;
                coappPersonalMail = app.Contact_Name__r.Email;
                coappOfficeMail = app.Contact_Name__r.Office_Email_Id__c;
                coapptelephone= app.Contact_Name__r.Residence_Landline_phone__c;
                coappofftelno= app.Contact_Name__r.Office_Landline_Number1__c;
                coapppermtelephone = app.Contact_Name__r.Permenant_Phone__c;
                //prod PSF access CR end
            if(!CommonUtility.isEmpty(app.eKYC__r))
                ekycObjCoapp = app.eKYC__r[0];
        }
    }
    if(applicantObj != null && applicantObj.Application_Form_Timestamp__c == 'Acceptance Pending')
        iptimeStamp = applicantObj.Application_Form_Timestamp__c;
    else if(applicantObj != null && applicantObj.Application_Form_Timestamp__c == 'Rejected')
        iptimeStamp = applicantObj.Application_Form_Timestamp__c;
    else
        iptimeStamp = 'IPADDRESS';
    //system.debug('months at residence'+applicantObj.Contact_Name__r.Months_at_Residence__c);
    List<Opportunity> oppList = [SELECT CreatedDate,Sourcing_Channel__r.Branch__r.Name,CUSTOMER__c,CUSTOMER__r.Name,Created_Time__c, /*Pricing*/Area_SM__c, /*Pricing*/IFSC_Code__c ,A_C_No__c, Mode_of_Disbursal__c, Bank_Name__c, Account_Holder_Name__c, Favouring__c,MICR_Number__c ,Repayment_Account_Holder_Name__c, Bank_A_c_No_of_Customer__c, Repayment_Bank_Name__c, Repayment_Mode__c, First_Due_Date__c,  A_C_Type__c, Account.Flow__c,Relationship_Manager__c,Tenor__c,Approved_Rate__c,EMI_CAM__c,Requested_ROI__c,Sourcing_Channel__r.Id,Sourcing_Channel__r.Reporting_Manager__c,id,Industry__r.Industry__c,Offer_Amount__c,Reject_Reason__c,Name,StageName,Telecaller_Name__c,Customer_Type__c, Product__c,Main_Sub_Industry__c,Branch_Name__c,Branch_Name__r.SAL_Branch_Type__c, LAN__c, AccountId, Quality_Check_Status__c, Sourcing_Channel__c, Sourcing_Channel__r.Name, Referral__c, Referral__r.Name, Application_Source__c, Loan_Application_Number__c,Type_Of_Loan__c,COO_Comments__c,Approved_Loan_Amount__c,Scheme_Master__r.Name,Scheme_Master__r.IsHybridFlexi__c,Approved_Tenor__c,Processing_Fees__c,Branch_Name__r.name,
                                 (select id from Product_Offerings__r),
                                 (select id,LAP_EMI__c,EMI_on_Proposed_Loan_TO__c,Avg_qtrly_incentive__c,Average_incentive_for_Q1__c,Average_incentive_for_Q3__c,Average_incentive_for_Q2__c,Maxi_EMI_Cust__c,Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c,Average_Monthly_Net_Income1__c,Applicable_FOIR1__c,Loan_Application__c,EMI_of_The_Loan__c,Receips5_Doc__c,Receips6_Doc__c,Unsecured_FOIR__c,Eligible_FOIR__c,Total_Mthly_Oblig__c,EMI__c,ROI__c,sal_max_loan__c,Net_Salary_for_Month1__c,Net_Salary_for_Month2__c,Net_Salary_for_Month3__c,Proposed_Loan_Amt__c,Tenor__c,Eligible_Loan__c,Monthly_Reimbursement__c,Avg_mthly_incntve_3mts__c,Rental_Income__c,Receips4_Doc__c,Existing_HL_EMI__c,Month1_Doc__c,Month2_Doc__c,Month3_Doc__c,LAP_pmt__c,Avg_monthly_incentive1__c,Avg_monthly_incentive2__c,Avg_monthly_incentive3__c,Incentive_Monthly_or_Quarterly__c 
                                  from CAMs__r),
                                 (select Status__c,Obligation__c,Financers__c,Loan_Type__c,POS__c,EMI__c from Existing_Loan_Details__r),
                                 (select Customer_Status__c,Dedupe_Source__c,Source_Or_Target__c from De_Dupes__r),
                                 (select Salary_Credit_Date1__c,Salary_Credit_Date2__c,Salary_Credit_Date3__c,Perfios_inwardChqBounces__c,Perfios_inwardECSBounces__c,Perfios_Bank_Name__c from Bank_Account__r),
                                 (select /*Bug:23361-Added Account_Validated__c*/ Account_Validated__c,id,IMPS_Count__c, Repay_Disb_Diff__c,UMRN__c,Disbursement_To__c, IMPS_Flag__c, Bank_Branch__c, name, Tranche_Detail__c, Loan_Application__c, Internal_Closure__c, Disbursement_Amount__c, Disbursal_Mode__c, Disbursement_Date__c,
                                  FinnOne_Disbursement_Date__c,Successful_IMPS_Count__c,Failure_IMPS_Count__c ,IFSC_Code__c, Favouring__c,isTopUp__c,Tranche_Detail__r.Tranche_Number__c, Bank_Name__c, Bank_Account__c, Payable_at__c, Credit_Days__c, IMPS_Result__c
                                  from Current_Disbursal_Details_s__r),
                                   /*25097 Start */ ( SELECT Loan_application__c,Question__c, Question_Text__c,Insurance_ID__c, Sequence_Number__c,Feedback_Answer11__c,Feedback_Answer__c FROM Feedbacks__r),
                                    (select id,name,RetriggerBRE__c,Policy_Name__c,Old_Address_Value__c,Applicant_Name__r.Contact_Name__r.Name,New_Address_Value__c,Add_on_Holder_DOB__c,Add_on_Holder_Email__c,Add_on_Holder_First_Name__c,Add_on_Holder_Last_Name__c,Add_on_Holder_Middle_Name__c,Add_on_holder_Mobile__c,Add_on_Holder_Relation__c,Applicant_Name__c,Charge_Type__c,Remarks__c,Disposition_Status__c,Checklist_Policy_Status__c,Policy_Status__c from SOL_Policys__r),
                                 (Select Nominee_Name__c,Nominee_Relationship__c,Nominee_DOB__c,Nominee_Age__c,Nominee_Address__c,Nominee_Mobile__c ,Insurance_Product__c,Insurance_Type__c,Availed_Tenor__c,Premium_Amount__c,Declaration_of_good_health__c,Type_of_Insurance__c,Sum_Assured__c,Insurance_term__c from Insurance__r),/*25097*/
                                 (select id,Question1__c,Question2__c,Question3__c,Question4__c,Question5__c,Question6__c,Question7__c,Question8__c,Question9__c,Question10__c,Question11__c,Question12__c,Question13__c,Question14__c,Question15__c,Question16__c,Question17__c,Question18__c,Question19__c,Question20__c,Question21__c,Question22__c,Question23__c,Question24__c,Question25__c,Question26__c,Question27__c,Question28__c,Question29__c,Question30__c,
                                  Type_of_PD__c,Tele_PD_Applicability__c,Name_of_the_applicant__c,PD_Conducted__c, PD_Ok__c,CO_comment__c from Personal_Discussion_s__r),
                                 (SELECT Id, A_C_type__c,ECS_Barcode_No__c,Open_ECS_Facility__c, Open_ECS_Ex_Customer_Id__c, Open_Valid_till__c, Open_ECS_Max_Limit__c, ECS_Start_Date__c, ECS_End_Date__c, ECS_Amount__c, name, Loan_Application__c, A_C_NO__c, MICR_Code__c, PDC_START_DATE__c, IFSC_Code__c, Account_Holder_Name__c,Bank_Name__c, No_of_Cheques__c, Cheque_Serial_Number__c, Repayment_Mode__c, To_Cheque_Serial_Number__c, Cheque_Amount__c, Tranche_Detail__c, Bank_Branch__c, PDC_By_Name__c ,UMRN__c,Loan_Application__r.CUSTOMER__c  ,Mandate_Process_Stage__c FROM RePayment_mode_details__r)
                                 
                                 from Opportunity where id = : id];
                                    //25097 start
         InsuranceQuestionnaireCtrl.oppId = id;
         insQ = new InsuranceQuestionnaireCtrl();
         FeedbackWrpList = insQ.FeedbackWrpList;
         System.debug('feedback '+FeedbackWrpList);
         //25097 stop  
    insList = new List<DPLInsurance__c>();
    List<CAM__c> camList = new List<CAM__c>();
    CAM__c camObj = new CAM__c();
    if(!CommonUtility.isEmpty(oppList))
    {
        oppObj=oppList[0];
        insList = oppObj.Insurance__r;
        camList = oppObj.CAMs__r;
    }
      //25097
          if(!CommonUtility.isEmpty(oppList) && oppList[0].SOL_Policys__r != null && oppList[0].SOL_Policys__r.size() > 0){
            for(Sol_policy__c sol:oppList[0].SOL_Policys__r){
                if(sol.Policy_Name__c == 'Add on Card'){
                    solobjlst.add(sol);
                }
            }
        }
        if(insList !=null && insList.size()>0){
            insProduct = insProduct + insList[0].Insurance_Product__c;
            for(Integer i =0;i<insList.size()-1 ;i=i+1)
            {
                insProduct =insProduct +' and/ or '+ insList[i+1].Insurance_Product__c;
            }
            system.debug('insProduct::'+insProduct);  
        }
        //25097
    if(!CommonUtility.isEmpty(camList )){
        camObj = camList[0];
        Decimal amount1 = 0,amount2 = 0,amount3 = 0;
        Decimal averageSal = 0.0;
        if(!CommonUtility.isEmpty(camObj.Average_incentive_for_Q1__c))
            amount1 = camObj.Average_incentive_for_Q1__c;
        if(!CommonUtility.isEmpty(camObj.Average_incentive_for_Q2__c))
            amount2 = camObj.Average_incentive_for_Q2__c;
        if(!CommonUtility.isEmpty(camObj.Average_incentive_for_Q3__c))
            amount3 = camObj.Average_incentive_for_Q3__c;
        averageSal = amount1 + amount2 + amount3;
        if(averageSal != 0)
            avgSal = String.valueof((averageSal/3).setScale(2));
        Decimal amount4 = 0,amount5 = 0,amount6 = 0;
        Decimal averageSalCo = 0.0;
        if(!CommonUtility.isEmpty(camObj.Receips4_Doc__c))
            amount4 = camObj.Receips4_Doc__c;
        if(!CommonUtility.isEmpty(camObj.Receips5_Doc__c))
            amount5 = camObj.Receips5_Doc__c;
        if(!CommonUtility.isEmpty(camObj.Receips6_Doc__c))
            amount6 = camObj.Receips6_Doc__c;
        averageSalCo = amount4 + amount5 + amount6;
        if(averageSalCo != 0)
            avgSalCo = String.valueof((averageSalCo/3).setScale(2));
    }
    if(!CommonUtility.isEmpty(insList )){
        insObj = insList[0];
    }
    List<Account> accList = [SELECT Current_Email_Id__c,Purpose_of_Facility__c,Preffered_Mode_to_Connect__c,PAN_Check_Status__c,Preferred_language__c,Name_of_the_Company_Employer__c,Type_of_Salary__c,Educational_Qualification__c,Offer_Inhanced__c,Type_of_Educational_Institution__c,Current_experiance_in_Month__c,Current_experiance_in_Years__c,Total_Work_Experience_Months__c,Total_Work_Experience_Yrs__c,Qualification__c,Gross_Salary_Turn_Over__c,Residence_TypeAcc__c,Id,Name, First_Name__c,PinCode__c,Area_Locality__r.id,Area_Locality__r.Name,Area_Locality__r.Affluence__c,Area_Locality__c,Last_Name__c,Middle_Name__c,Current_City__c,Current_State__c,Date_of_Birth__c,Mobile__c,PANNumber__c,Gender__c,DesignationOTP__c,Office_Address_1st_Line__c,Office_Address_2nd_Line__c,Office_Address_3rd_Line__c,Office_Pin_Code__c,Office_Landline_Number1__c,Permanent_Residence_Address1__c,Permanent_Residence_Address2__c,Permanent_Residence_Address3__c,Permanent_PinCode__c,Permanent_Telephone_Number__c,Current_Residence_Address1__c,Current_Residence_Address2__c,Current_Residence_Address3__c,Current_PinCode__c,Employer__c,Type_Of_Industry__c,Email_Id__c,Marital_Status__c,Employer__r.Name,EPFO_Result__c,Employer__r.Sub_Industry__c,Downsizing_Reasons__c   from Account where Id =: oppList.get(0).AccountId ];
    if(!CommonUtility.isEmpty(accList))
    {
        accObj=accList[0];
            appPersonalMail = accObj.Current_Email_Id__c;//prod PSF access CR 
    }
    List<RePayment_mode_detail__c> repayList= [SELECT Id, A_C_type__c,ECS_Barcode_No__c,Open_ECS_Facility__c, Open_ECS_Ex_Customer_Id__c, Open_Valid_till__c, Open_ECS_Max_Limit__c, ECS_Start_Date__c, ECS_End_Date__c, ECS_Amount__c, name, Loan_Application__c, A_C_NO__c, MICR_Code__c, PDC_START_DATE__c, IFSC_Code__c, Account_Holder_Name__c,Bank_Name__c, No_of_Cheques__c, Cheque_Serial_Number__c, Repayment_Mode__c, To_Cheque_Serial_Number__c, Cheque_Amount__c, Tranche_Detail__c, Bank_Branch__c, PDC_By_Name__c ,UMRN__c,Loan_Application__r.CUSTOMER__c  ,Mandate_Process_Stage__c FROM RePayment_mode_detail__c where Loan_Application__c =: oppObj.Id];
    if(!CommonUtility.isEmpty(repayList)){
        repayObj =repayList[0]; 
        //25097 start s
        String IFSCJSON=fetchIFSCData(repayObj.IFSC_Code__c,'IFSC_Code__c');
         System.debug('@@@Swapnil IFSC '+IFSCJSON);
        //US5431s- List taken instead of IFSCMaster and zeroth record of List taken while fetching brnach
            //IFSC_Master__c IFSCobj =new IFSC_Master__c();
            List<IFSC_Master__c> IFSCobj =new List<IFSC_Master__c>();
        
        if(IFSCJSON !='Fail'){
                IFSCobj=(List<IFSC_Master__c>)JSON.deserialize(IFSCJSON, List<IFSC_Master__c>.class);
        }
       if(!CommonUtility.isEmpty(IFSCobj)&& IFSCobj.size()>0 && !CommonUtility.isEmpty(IFSCobj[0].Branch__c))//added null check for cr 26917
           bankAddress=IFSCobj[0].Branch__c;
            //US5431e
          //25097 e
    }
      /*25097 start*/
             
       Map<String,Object> chargeMap= getCharges(id);
       System.debug('Charge Map '+chargeMap);
        for (String chargeName : chargeMap.keySet()){
            if(chargeName.EqualsIgnoreCase('EMICard fees')){
              
               if(chargeMap.get(chargeName) != 'NA'){
                    EMICardFees=(Fees_and_Charge__c) chargeMap.get(chargeName); 
                    EMICardFeesNA = String.ValueOf(EMICardFees.Change_Amount__c);
                    System.debug('EMICard fees::'+EMICardFees);
                }
                else    
                    EMICardFeesNA='NA';                 
                System.debug('CPPWalletfees '+CPPWalletfees);  
                
            }else if(chargeName.EqualsIgnoreCase('CPPWallet fees')){
                if(chargeMap.get(chargeName) != 'NA'){
                    CPPWalletfees=(Fees_and_Charge__c) chargeMap.get(chargeName); 
                    CPPWalletfeesNA = String.ValueOf(CPPWalletfees.Change_Amount__c);
                }
                else    
                    CPPWalletfeesNA='NA';                   
                System.debug('CPPWalletfees:: '+CPPWalletfees);
            }else if(chargeName.EqualsIgnoreCase('co-brandedCC fees')){
                coBrandedCC= (Fees_and_Charge__c) chargeMap.get(chargeName);
                system.debug('coBrandedCC::'+coBrandedCC);  
            }
            else if(chargeName.EqualsIgnoreCase('FFR fees')){ 
               if(chargeMap.get(chargeName) != 'NA'){
                    FFRCharges=(Fees_and_Charge__c) chargeMap.get(chargeName); 
                    FFRChargesNA = String.ValueOf(FFRCharges.Change_Amount__c);
                }
                else    
                    FFRChargesNA='NA';                  
                System.debug('FFRChargesNA '+FFRChargesNA);
                System.debug('FFRCharges '+FFRCharges); 
            }
        }
       
         /*25097 end*/
    //system.debug('repayu acc'+repayObj.Id);
    //application form ends
    
    try{
        if(pageName.contains('approveROIandPFpage'))
        {      
            result='You are no longer authorized';
            if(pROI!='null')
            {
                
                if(!commonutility.isEmpty(id)){
                    appList = [select Drop_Line_Flexi_Period__c,Pure_Flexi_Period__c,Pure_Flexi_EMI__c,PFApproveStatus__c from Applicant__c where Loan_Application__c =: id  and Applicant_Type__c= 'Primary' LIMIT 1];
                    String beforeROI =appList[0].PFApproveStatus__c+' ';
                    if(beforeROI.contains(designation))
                    {
                        if(beforeROI.contains('Pending'))
                        {
                            System.debug('IN 1');
                            result='Approved Successfully';
                        }
                    }
                    else{
                        System.debug('IN 2');
                        result='You are no longer authorized';
                    }
                }
                
            }
            if(pPF!='null')
            {           
                if(!commonutility.isEmpty(id)){
                    appList = [select Drop_Line_Flexi_Period__c,Pure_Flexi_Period__c,Pure_Flexi_EMI__c,PFApproveStatus__c from Applicant__c where Loan_Application__c =: id  and Applicant_Type__c= 'Primary' LIMIT 1];
                    String beforePF=appList[0].PFApproveStatus__c+' ';
                    if(beforePF.contains(designation))
                    {
                        if(beforePF.contains('Pending')) 
                        {
                            System.debug('IN 3');
                            result='Approved Successfully';
                        }
                    }
                    else
                    {
                        System.debug('IN 4');
                        result='You are no longer authorized';
                    }                      
                }
            }
        }
        if(pageName.contains('rejectROIandPFpage'))
        {
            result='You are no longer authorized';
            if(pROI!='null')
            {
                
                if(!commonutility.isEmpty(id)){
                    appList = [select Drop_Line_Flexi_Period__c,Pure_Flexi_Period__c,Pure_Flexi_EMI__c,PFApproveStatus__c from Applicant__c where Loan_Application__c =: id  and Applicant_Type__c= 'Primary' LIMIT 1];
                    String beforeROI =appList[0].PFApproveStatus__c+' ';
                    if(beforeROI.contains(designation))
                    {
                        if(beforeROI.contains('Pending'))
                        {
                            result='Declined Successfully';
                        }
                    }
                    else{
                        result='You are no longer authorized';
                    }
                }
                
            }
            if(pPF!='null')
            {           
                if(!commonutility.isEmpty(id)){
                    appList = [select Drop_Line_Flexi_Period__c,Pure_Flexi_Period__c,Pure_Flexi_EMI__c,PFApproveStatus__c from Applicant__c where Loan_Application__c =: id  and Applicant_Type__c= 'Primary' LIMIT 1];
                    String beforePF=appList[0].PFApproveStatus__c+' ';
                    if(beforePF.contains(designation))
                    {
                        if(beforePF.contains('Pending')) 
                        {
                            result='Declined Successfully';
                        }
                    }
                    else
                    {
                        result='You are no longer authorized';
                    }                      
                }
            }
            
        }
    }catch(Exception e){
        System.debug('Exception in constructor '+e.getMessage() +e.getLineNumber());
    }
}

public static void approveROI_PF_Method()
{
    List<Applicant__c> appList;
    List<Opportunity> oppList;
    String id = ApexPages.currentPage().getParameters().get('id');
    String pROI = ApexPages.currentPage().getParameters().get('pROI');
    String pPF = ApexPages.currentPage().getParameters().get('pPF');
    String designation = ApexPages.currentPage().getParameters().get('desi');
    System.debug('String is '+pROI+'<-ROI   PF->'+pPF+' ID='+id+designation );
        List<CAM__c> camList = new List<CAM__c>();//prod issue
    try{
            System.debug('pROI:'+pROI);
        if(pROI != 'null' && pPF != 'null'){
            if(!commonutility.isEmpty(id)){
                appList = [select Drop_Line_Flexi_Period__c,Pure_Flexi_Period__c,Pure_Flexi_EMI__c,PFApproveStatus__c from Applicant__c where Loan_Application__c =: id  and Applicant_Type__c= 'Primary' LIMIT 1];
                String beforeROI =appList[0].PFApproveStatus__c+' ';
                if(beforeROI.contains(designation))
                {
                    if(beforeROI.contains('Pending'))
                    {
                        String afterROI= beforeROI.replace('Pending','Approved')+' ';
                        //afterROI= afterROI.replace('Rejected','Approved');
                        if(!Test.isRunningTest())
                          appList[0].PFApproveStatus__c=afterROI;
                        
                            oppList =[SELECT (select id,ROI__c from CAMs__r),EMI_CAM__c,Scheme_Master__c,Approved_Tenor__c,Loan_Amount_with_Premium__c,Scheme_Master__r.IsHybridFlexi__c ,Approved_Rate__c,Processing_Fees__c from Opportunity where id = :id LIMIT 1];
                            if(!CommonUtility.isEmpty(oppList))//prod issue
                            {
                                camList = oppList[0].CAMs__r;
                            }
                            if(!CommonUtility.isEmpty(camList )){//prod issue
                               camList[0].ROI__c = decimal.valueOf(pROI);
                               update camList[0];
                            }
                        oppList[0].Approved_Rate__c=decimal.valueOf(pROI);
                        oppList[0].Processing_Fees__c=decimal.valueOf(pPF);
                        String emiVal = SAL_PricingCtrlV2.calculateEMIValue(oppList[0],appList[0]); //22182
                        if(emiVal != null){
                            oppList[0].EMI_CAM__c = Decimal.valueof(emiVal); //22182
                            if(!CommonUtility.isEmpty(oppList[0].Scheme_Master__c) && !CommonUtility.isEmpty(oppList[0].Scheme_Master__r.IsHybridFlexi__c) && oppList[0].Scheme_Master__r.IsHybridFlexi__c == true)
                               appList[0].Pure_Flexi_EMI__c =  ((oppList[0].Loan_Amount_with_Premium__c *oppList[0].Approved_Rate__c) / 1200);
                        }
                        update applist[0];
                        update oppList[0];
                        
                        
                    }
                }
                else{
                    System.debug('Designation doesnt match');
                }
            }
        }
        else if(pROI!='null')
        {
            
            if(!commonutility.isEmpty(id)){
                appList = [select Drop_Line_Flexi_Period__c,Pure_Flexi_Period__c,Pure_Flexi_EMI__c,PFApproveStatus__c from Applicant__c where Loan_Application__c =: id  and Applicant_Type__c= 'Primary' LIMIT 1];
                String beforeROI =appList[0].PFApproveStatus__c+' ';
                if(beforeROI.contains(designation))
                {
                    if(beforeROI.contains('Pending'))
                    {
                        String afterROI= beforeROI.replace('Pending','Approved')+' ';
                        //afterROI= afterROI.replace('Rejected','Approved');
                        if(!Test.isRunningTest())
                          appList[0].PFApproveStatus__c=afterROI;
                        
                            oppList =[SELECT (select id,ROI__c from CAMs__r),EMI_CAM__c,Scheme_Master__c,Approved_Tenor__c,Loan_Amount_with_Premium__c,Scheme_Master__r.IsHybridFlexi__c ,Approved_Rate__c,Processing_Fees__c from Opportunity where id = :id LIMIT 1];
                           if(!CommonUtility.isEmpty(oppList))//prod issue
                            {
                                camList = oppList[0].CAMs__r;
                            }
                            if(!CommonUtility.isEmpty(camList )){//prod issue
                               camList[0].ROI__c = decimal.valueOf(pROI);
                               update camList[0];
                            }
                        oppList[0].Approved_Rate__c=decimal.valueOf(pROI);
                        String emiVal = SAL_PricingCtrlV2.calculateEMIValue(oppList[0],appList[0]); //22182
                        if(emiVal != null){
                            oppList[0].EMI_CAM__c = Decimal.valueof(emiVal); //22182
                            if(!CommonUtility.isEmpty(oppList[0].Scheme_Master__c) && !CommonUtility.isEmpty(oppList[0].Scheme_Master__r.IsHybridFlexi__c) && oppList[0].Scheme_Master__r.IsHybridFlexi__c == true)
                               appList[0].Pure_Flexi_EMI__c =  ((oppList[0].Loan_Amount_with_Premium__c *oppList[0].Approved_Rate__c) / 1200);
                        }
                        update applist[0];
                        update oppList[0];
                        
                        
                    }
                }
                else{
                    System.debug('Designation doesnt match');
                }
            }
            
        }
        else if(pPF!='null')
        {           
            if(!commonutility.isEmpty(id)){
                appList = [select Drop_Line_Flexi_Period__c,Pure_Flexi_Period__c,Pure_Flexi_EMI__c,PFApproveStatus__c from Applicant__c where Loan_Application__c =: id  and Applicant_Type__c= 'Primary' LIMIT 1];
                String beforePF=appList[0].PFApproveStatus__c+' ';
                system.debug('beforePF'+beforePF);
                if(beforePF.contains(designation))
                {
                    //if(beforePF.contains('Pending')) 
                   // {
                        String afterPF= beforePF.replace('Pending','Approved')+' ';
                        //afterPF= afterPF.replace('Rejected','Approved');
                        if(!Test.isRunningTest())
                          appList[0].PFApproveStatus__c=afterPF;
                        
                        oppList =[SELECT EMI_CAM__c,Scheme_Master__c,Approved_Tenor__c,Loan_Amount_with_Premium__c,Scheme_Master__r.IsHybridFlexi__c,Approved_Rate__c,Processing_Fees__c from Opportunity where id = :id];
                        oppList[0].Processing_Fees__c=decimal.valueOf(pPF);
                        String emiVal = SAL_PricingCtrlV2.calculateEMIValue(oppList[0],appList[0]); //22182
                        if(emiVal != null){
                            oppList[0].EMI_CAM__c = Decimal.valueof(emiVal); //22182
                            if(!CommonUtility.isEmpty(oppList[0].Scheme_Master__c) && !CommonUtility.isEmpty(oppList[0].Scheme_Master__r.IsHybridFlexi__c) && oppList[0].Scheme_Master__r.IsHybridFlexi__c == true)
                               appList[0].Pure_Flexi_EMI__c =  ((oppList[0].Loan_Amount_with_Premium__c *oppList[0].Approved_Rate__c) / 1200);
                        }
                        update applist[0];
                        update oppList[0];

                   // }//commented for 1652
                }
                else
                    System.debug('Designation doesnt match for PF');
                
            }
        }
    }catch(Exception e)
    {
        System.debug('Exception at approveROI_PF_Method() '+e.getLineNumber()+e.getMessage());
    }
    //return 'hello';
}


public static void rejectedROI_PF_Method()
{
    
    List<Applicant__c> appList;
    List<Opportunity> oppList;
    String id = ApexPages.currentPage().getParameters().get('id');
    String pROI = ApexPages.currentPage().getParameters().get('pROI');
    String pPF = ApexPages.currentPage().getParameters().get('pPF');
    String designation = ApexPages.currentPage().getParameters().get('desi');
    System.debug('In Rejection String is ID1='+id);
    System.debug('Value in Rejection '+pPF+pROI);
    try{
        
        if(pROI!='null')
        {
            if(!commonutility.isEmpty(id)){
                appList = [select Drop_Line_Flexi_Period__c,Pure_Flexi_Period__c,Pure_Flexi_EMI__c,PFApproveStatus__c from Applicant__c where Loan_Application__c =: id  and Applicant_Type__c= 'Primary' LIMIT 1];
                String beforeROI =appList[0].PFApproveStatus__c+' ';
                if(beforeROI.contains(designation))
                {
                    if(beforeROI.contains('Pending'))
                    {
                        String afterROI= beforeROI.replace('Pending','Rejected');
                        //afterROI= afterROI.replace('Approved','Rejected');
                        if(!Test.isRunningTest())
                          appList[0].PFApproveStatus__c=afterROI;
                        
                        oppList =[SELECT EMI_CAM__c,Scheme_Master__c,Approved_Tenor__c,Loan_Amount_with_Premium__c,Scheme_Master__r.IsHybridFlexi__c,Approved_Rate__c,Processing_Fees__c from Opportunity where id = :id]; //22182
                        String emiVal = SAL_PricingCtrlV2.calculateEMIValue(oppList[0],appList[0]); //22182
                        if(emiVal != null){
                            oppList[0].EMI_CAM__c = Decimal.valueof(emiVal); //22182
                            if(!CommonUtility.isEmpty(oppList[0].Scheme_Master__c) && !CommonUtility.isEmpty(oppList[0].Scheme_Master__r.IsHybridFlexi__c) && oppList[0].Scheme_Master__r.IsHybridFlexi__c == true)
                               appList[0].Pure_Flexi_EMI__c =  ((oppList[0].Loan_Amount_with_Premium__c *oppList[0].Approved_Rate__c) / 1200);
                        }
                        update applist[0];
                        update oppList[0];
                    }
                }
                else
                    System.debug('Designation doesnt match for ROI Reject');
            }
        }
        if(pPF!='null')
        {            
            if(!commonutility.isEmpty(id)){
                appList = [select Drop_Line_Flexi_Period__c,Pure_Flexi_Period__c,Pure_Flexi_EMI__c,PFApproveStatus__c from Applicant__c where Loan_Application__c =: id  and Applicant_Type__c= 'Primary' LIMIT 1];
                String beforePF=appList[0].PFApproveStatus__c+' ';
                if(beforePF.contains(designation))
                {
                    if(beforePF.contains('Pending'))
                    {
                        String afterPF= beforePF.replace('Pending','Rejected');
                        //afterPF= afterPF.replace('Approved','Rejected');
                        if(!Test.isRunningTest())
                          appList[0].PFApproveStatus__c=afterPF;
                        update applist[0];
                        oppList =[SELECT EMI_CAM__c,Scheme_Master__c,Approved_Tenor__c,Loan_Amount_with_Premium__c,Scheme_Master__r.IsHybridFlexi__c,Approved_Rate__c,Processing_Fees__c from Opportunity where id = :id]; //22182
                        String emiVal = SAL_PricingCtrlV2.calculateEMIValue(oppList[0],appList[0]); //22182
                        if(emiVal != null){
                            oppList[0].EMI_CAM__c = Decimal.valueof(emiVal); //22182
                            if(!CommonUtility.isEmpty(oppList[0].Scheme_Master__c) && !CommonUtility.isEmpty(oppList[0].Scheme_Master__r.IsHybridFlexi__c) && oppList[0].Scheme_Master__r.IsHybridFlexi__c == true)
                               appList[0].Pure_Flexi_EMI__c =  ((oppList[0].Loan_Amount_with_Premium__c *oppList[0].Approved_Rate__c) / 1200);
                        }
                        update applist[0];
                        update oppList[0];
                    }
                }
                else
                    System.debug('Designation doesnt match for PF');
            } 
        }                
        
    }catch(Exception e)
    {
        System.debug('Exception at approveROI_PF_Method() '+e.getLineNumber()+e.getMessage());
    }
    
}
/*public static void stampROIasPending(String id,String designation){
    try{
        System.debug('in ROIasPending '+designation);
        List<Applicant__c> appList;
        if(!commonutility.isEmpty(id)){
            appList = [select Drop_Line_Flexi_Period__c,Pure_Flexi_Period__c,Pure_Flexi_EMI__c,PFApproveStatus__c,ROIApproveStatus__c from Applicant__c where Loan_Application__c =: id  and Applicant_Type__c= 'Primary' LIMIT 1];
            appList[0].ROIApproveStatus__c='Pending;'+designation;
            update applist[0];
            
        }
    }catch(Exception e){
        System.debug('Exception on line + '+e.getLineNumber()+e.getMessage());
    }
}*/

public static void stampPFasPending(String id,String designation){
    try{
        List<Applicant__c> appList;
        if(!commonutility.isEmpty(id)){
            appList = [select Drop_Line_Flexi_Period__c,Pure_Flexi_Period__c,Pure_Flexi_EMI__c,PFApproveStatus__c from Applicant__c where Loan_Application__c =: id  and Applicant_Type__c= 'Primary' LIMIT 1];
            appList[0].PFApproveStatus__c='Pending;'+designation;
            update applist[0];
        }
    }catch(Exception e){
        System.debug('Exception on line + '+e.getLineNumber()+e.getMessage());
    }
}
//US5431s- added micr=blank condition post US 5431 deployment as a prod issue as data is not maintained properly on production- 
public static String fetchIFSCData(String ifscMicrCode, String field){
    
    try{
            System.debug('inside fetchIFSCData ');  
            if(ifscMicrCode!=null)          
            ifscMicrCode = String.escapeSingleQuotes(ifscMicrCode);
            
            List<IFSC_Master__c> IFSCList =[SELECT Bank__c, Branch__c, ECS__c, IFSC_Code__c, IFSC_Active__c, MICR__c FROM IFSC_Master__c WHERE IFSC_Code__c=: ifscMicrCode And (MICR_Flag__c='Active' Or MICR_Flag__c='')];
                        
            System.debug('fetchIFSCDataIFSCList '+IFSCList);            
            if(!CommonUtility.isEmpty(IFSCList)){
               
                return JSON.serialize(IFSCList);  
        }
        else{
            return 'Fail';
        }
    }
        catch(Exception e){System.debug('fetchIFSCData '+e.getMessage()+e.getLineNumber());
        return 'Error: '+e.getMessage();
    }
    }    
    //US5431e
    
    public static String deleteDisbursementObject(Id disbId, Id loanId){
    List< Current_Disbursal_Details__c > disbDeleteList = new List< Current_Disbursal_Details__c > ();
    List< Current_Disbursal_Details__c > disbUpdatedList = new List< Current_Disbursal_Details__c > ();
    List< Current_Disbursal_Details__c > disbList = [SELECT /*Bug:23361-Added Account_Validated__c*/ Account_Validated__c,Id,Disbursal_Mode__c,Bank_Branch__c,Favouring__c,Bank_Account__c,IFSC_Code__c,Bank_Name__c,Disbursement_Amount__c,IMPS_Flag__c,Payable_at__c,FinnOne_Disbursement_Date__c,IMPS_Count__c  FROM Current_Disbursal_Details__c WHERE Loan_Application__c =: loanId];
    for(Current_Disbursal_Details__c disb : disbList){
        System.debug('Loop disb Id'+disb.Id);
        System.debug('disb Id'+disbId);
        if(disb.Id == disbId){
            disbDeleteList.add(disb);
        }
        else{
            disbUpdatedList.add(disb);
        }
    }
    try{
        delete disbDeleteList;
        if(!CommonUtility.isEmpty(disbUpdatedList))
            return JSON.serialize(disbUpdatedList);
        else
            return 'Empty';
        
    } catch(Exception e){
        return 'Fail';
    } 
}
public static String deleteRepaymentObject(Id repayId, Id loanId){
    List< RePayment_mode_detail__c > repayDeleteList = new List< RePayment_mode_detail__c > ();
    List< RePayment_mode_detail__c > repayUpdatedList = new List< RePayment_mode_detail__c > ();
    List< RePayment_mode_detail__c > repayList = [SELECT Id, A_C_type__c,ECS_Barcode_No__c,Open_ECS_Facility__c, Open_ECS_Ex_Customer_Id__c, Open_Valid_till__c, Open_ECS_Max_Limit__c, ECS_Start_Date__c, ECS_End_Date__c, ECS_Amount__c, name, Loan_Application__c, A_C_NO__c, MICR_Code__c, PDC_START_DATE__c, IFSC_Code__c, Account_Holder_Name__c,Bank_Name__c, No_of_Cheques__c, Cheque_Serial_Number__c, Repayment_Mode__c, To_Cheque_Serial_Number__c, Cheque_Amount__c, Tranche_Detail__c, Bank_Branch__c, PDC_By_Name__c FROM RePayment_mode_detail__c WHERE Loan_Application__c =: loanId];
    for(RePayment_mode_detail__c repay : repayList){
        System.debug('Loop repay Id'+repay.Id);
        System.debug('repay Id'+repayId);
        if(repay.Id == repayId){
            repayDeleteList.add(repay);
        }
        else{
            repayUpdatedList.add(repay);
        }
    }
    try{
        delete repayDeleteList;
        if(!CommonUtility.isEmpty(repayUpdatedList))
            return JSON.serialize(repayUpdatedList);
        else
            return 'Empty';
    }
    catch(Exception e){
        return 'Fail';
    } 
}
public static String fetchRepayList(String loan, String repay){
    if(repay == null){ //in case of OPEN ECS CLONE Button
        SALMobilityOppCntrl_V2.oppData dss = new SALMobilityOppCntrl_V2.oppData();
        Opportunity loanobj =(Opportunity) JSON.deserialize(loan, Opportunity.class);
        SALMobilityOppCntrl_V2.getAllData(loanobj.id,dss); 
        return JSON.serialize(dss);
    }
    else{
        Opportunity oppObj = new Opportunity ();
        oppObj = (Opportunity) JSON.deserialize(loan,Opportunity.class);
        RePayment_mode_detail__c repayObj1 = new RePayment_mode_detail__c();
        repayObj1.id = repay;
        repayObj1.Loan_Application__c = oppObj.Id;
        System.debug('repay'+repay);
        
           // update repayObj1; prod issue
        List< RePayment_mode_detail__c > repayObj = [SELECT /*22501--S--*/ Cheque_Serial_Numbers__c,Cheque_Date__c,/*22501--E--*/Id,/*22018*/UMRN__c,/*22018*/Cheque_Number_From__c,Cheque_Number_to__c,Number_of_cheques__c, A_C_type__c,ECS_Barcode_No__c,Open_ECS_Facility__c, Open_ECS_Ex_Customer_Id__c, Open_Valid_till__c, Open_ECS_Max_Limit__c, ECS_Start_Date__c, ECS_End_Date__c, ECS_Amount__c, name, Loan_Application__c, A_C_NO__c, MICR_Code__c, PDC_START_DATE__c, IFSC_Code__c, Account_Holder_Name__c,Bank_Name__c, No_of_Cheques__c, Cheque_Serial_Number__c, Repayment_Mode__c, To_Cheque_Serial_Number__c, Cheque_Amount__c, Tranche_Detail__c, Bank_Branch__c, PDC_By_Name__c FROM RePayment_mode_detail__c WHERE Loan_Application__c =: oppObj.Id];
        if (!CommonUtility.isEmpty(repayObj)) {
            
            if (repayObj[0].MICR_Code__c != null) {
                oppObj.MICR_Number__c = repayObj[0].MICR_Code__c;
            }
            if (repayObj[0].A_C_type__c != null) {
                oppObj.A_C_Type__c = repayObj[0].A_C_type__c;
            }
            if (repayObj[0].Account_Holder_Name__c != null) {
                oppObj.Repayment_Account_Holder_Name__c = repayObj[0].Account_Holder_Name__c;
            }
            if (repayObj[0].A_C_NO__c != null) {
                oppObj.Bank_A_c_No_of_Customer__c = repayObj[0].A_C_NO__c;
            }
            if (repayObj[0].Bank_Name__c != null) {
                oppObj.Repayment_Bank_Name__c = repayObj[0].Bank_Name__c;
            }
            if (repayObj[0].Repayment_Mode__c != null) {
                oppObj.Repayment_Mode__c = repayObj[0].Repayment_Mode__c;
            }
            if (repayObj[0].ECS_Start_Date__c != null) {
                oppObj.First_Due_Date__c = repayObj[0].ECS_Start_Date__c;
            }
            if (oppObj != null) {
                try{
                    upsert oppObj;
                }
                catch(Exception e){
                    System.debug('Exception here'+ e.getMessage()+ '@Line No: '+e.getLineNumber());
                }
            } 
                try{
                        update repayObj1;
                   }
                    catch(Exception e){
                        System.debug('Exception repay record'+ e.getMessage()+ '@Line No: '+e.getLineNumber());
                    }
            SALMobilityOppCntrl_V2.oppData dss = new SALMobilityOppCntrl_V2.oppData();
            dss.opp = oppObj;
            dss.repayList = repayObj;
            return JSON.serialize(dss);
        }
        else
            return 'Fail';
    }
}
public static String fetchDisbursementList(String opp, String disburse){
    Opportunity Loan = new Opportunity ();
    Loan = (Opportunity) JSON.deserialize(opp,Opportunity.class);
    Current_Disbursal_Details__c disObj1 = new Current_Disbursal_Details__c();
    disObj1.id = disburse;
    disObj1.Loan_Application__c = Loan.Id;
    
    update disObj1;
    List< Current_Disbursal_Details__c > disbObj = [SELECT /*Bug:23361-Added Account_Validated__c*/ Account_Validated__c,/*23239--S--*/IMPS_Beneficiary_Name__c,/*23239--E--*//*21287 added IMPS_Transaction_No__c*/ IMPS_Transaction_No__c,Repay_Disb_Diff__c,Id,IMPS_Result__c,isTopUp__c,Disbursal_Mode__c,Bank_Branch__c,Favouring__c,Successful_IMPS_Count__c,Failure_IMPS_Count__c,Loan_Application__c,Bank_Account__c,IFSC_Code__c,Bank_Name__c,Disbursement_Amount__c,IMPS_Flag__c,Payable_at__c,FinnOne_Disbursement_Date__c,IMPS_Count__c  FROM Current_Disbursal_Details__c WHERE Loan_Application__c =: Loan.Id];
    if(!CommonUtility.isEmpty(disbObj))
    { 
        if(disbObj[0].isTopUp__c==false){
            System.debug('is not topup');
            if (disbObj[0].IFSC_Code__c != null) {
                Loan.IFSC_Code__c = disbObj[0].IFSC_Code__c;
            }
            if (disbObj[0].Bank_Account__c != null) {
                Loan.A_C_No__c = disbObj[0].Bank_Account__c;
            }
            if (disbObj[0].Disbursal_Mode__c != null) {
                Loan.Mode_of_Disbursal__c = disbObj[0].Disbursal_Mode__c;
            }
            if (disbObj[0].Bank_Name__c != null) {
                Loan.Bank_Name__c = disbObj[0].Bank_Name__c;
            }
            if (disbObj[0].Favouring__c != null) {
                Loan.Account_Holder_Name__c = disbObj[0].Favouring__c;
            }
            if (disbObj[0].Favouring__c != null) {
                Loan.Favouring__c = disbObj[0].Favouring__c;
            }
        }
        else
        {
            if (disbObj[1].IFSC_Code__c != null) {
                Loan.IFSC_Code__c = disbObj[1].IFSC_Code__c;
            }
            if (disbObj[1].Bank_Account__c != null) {
                Loan.A_C_No__c = disbObj[1].Bank_Account__c;
            }
            if (disbObj[1].Disbursal_Mode__c != null) {
                Loan.Mode_of_Disbursal__c = disbObj[1].Disbursal_Mode__c;
            }
            if (disbObj[1].Bank_Name__c != null) {
                Loan.Bank_Name__c = disbObj[1].Bank_Name__c;
            }
            if (disbObj[1].Favouring__c != null) {
                Loan.Account_Holder_Name__c = disbObj[1].Favouring__c;
            }
            if (disbObj[1].Favouring__c != null) {
                Loan.Favouring__c = disbObj[1].Favouring__c;
            }
        }
        if (Loan != null) {
            try{
                upsert Loan;
            }
            catch(Exception e){
                System.debug('Exception here'+ e.getMessage()+ '@Line No: '+e.getLineNumber());
            }
        }
        SALMobilityOppCntrl_V2.oppData dss = new SALMobilityOppCntrl_V2.oppData();
        dss.opp = Loan;
        dss.disburement = disbObj;
        return JSON.serialize(dss);
    }
    else
        return 'Fail';
}
 public static List< Current_Disbursal_Details__c > fetchDisbursementafterclone(String loanId){
  try{
  List< Current_Disbursal_Details__c > disbObj = [SELECT /*Bug:23361-Added Account_Validated__c*/ Account_Validated__c,Repay_Disb_Diff__c,Id,IMPS_Result__c,isTopUp__c,Disbursal_Mode__c,Bank_Branch__c,Favouring__c,Successful_IMPS_Count__c,Failure_IMPS_Count__c,Loan_Application__c,Bank_Account__c,IFSC_Code__c,Bank_Name__c,Disbursement_Amount__c,IMPS_Flag__c,Payable_at__c,FinnOne_Disbursement_Date__c,IMPS_Count__c  FROM Current_Disbursal_Details__c WHERE Loan_Application__c =: LoanId];
  return disbObj;
  }catch(exception e)
  {
    system.debug('inside catch pk'+e.getMessage());
    return null;
    }
  }
public static String saveRepayData(String repay){
    try{
        System.debug('repay-->'+repay);
        RePayment_mode_detail__c repayObj = new RePayment_mode_detail__c ();
        repayObj = (RePayment_mode_detail__c) JSON.deserialize(repay,RePayment_mode_detail__c.class);
        system.debug('repayObj=='+repayObj);
        update repayObj;
        return 'Success';
    }
    catch(Exception e){
        return 'Fail: '+e.getMessage();
    }
}
  public static String fetchRepaymentObject(String repayId,String objectFieldJSON,String oppId,String Primaryappid){//changed for 22017
    SALMobilityOppCntrl_V2.oppData dss = new SALMobilityOppCntrl_V2.oppData();
    system.debug('before object'+Primaryappid+'  '+oppId);
    if(objectFieldJSON != null && objectFieldJSON != '')
        dss.picklistData = LighteningUtilities.getPicklistValues(objectFieldJSON);
    List <Bank_Account__c> banksallists = [select Perfios_Account_Holder_Name__c,Perfios_Bank_Name__c,Perfios_Account_No__c,Account_Type__c,MICR_Code__c,IFSC_Code__c,Perfios_inwardChqBounces__c,Perfios_inwardECSBounces__c,Salary_credit_amount1__c,Salary_credit_amount2__c,Salary_credit_amount3__c,Salary_Credit_Date1__c,Salary_Credit_Date2__c,Salary_Credit_Date3__c,/*Submit to credit S*/SalCrdtDateInconsistencyInPerfiose__c,Salary_Date_Inconsistency_Found__c,Salary_Amount_Difference__c,
                narration1__c,narration2__c,narration3__c,HVTinPerfios__c,Latest_bounce_in_Perfios__c,/*Submit to credit E*/id, Bank_Type__c, name, Bank_Name__c, Bank_Account_Number__c, IFSC_Bank_Name__c, Bank_Acct_Number__c, Bank_Branch__c, Applicant__c, Applicant__r.Applicant_Type__c,Perfios_Flag__c,Send_Email_For_Perfios__c,StatusOfBankAccount__c,Source_Of_Data__c,Authenticity__c,Authenticity_Score_Flag__c,Perfios_Client_Address__c 
                from Bank_Account__c where Loan_Application__c = : oppId and Applicant__c =: Primaryappid and Perfios_Flag__c = true];
        if(!CommonUtility.isEmpty(banksallists)){
            dss.bankObj = banksallists[0]; 
        }
       
    List< RePayment_mode_detail__c > repayObj = [SELECT Id,/*22018*/UMRN__c,/*22018*/Copy_Perfios_Details__c,Cheque_Number_From__c,Cheque_Number_to__c,Number_of_cheques__c,A_C_type__c,ECS_Barcode_No__c,Open_ECS_Facility__c, Open_ECS_Ex_Customer_Id__c, Open_Valid_till__c, Open_ECS_Max_Limit__c, ECS_Start_Date__c, ECS_End_Date__c, ECS_Amount__c, name, Loan_Application__c, A_C_NO__c, MICR_Code__c, PDC_START_DATE__c, IFSC_Code__c, Account_Holder_Name__c,Bank_Name__c, No_of_Cheques__c, Cheque_Serial_Number__c, Repayment_Mode__c, To_Cheque_Serial_Number__c, Cheque_Amount__c, Tranche_Detail__c, Bank_Branch__c, PDC_By_Name__c ,Mandate_Process_Stage__c FROM RePayment_mode_detail__c WHERE Id =: repayId];
    if(!CommonUtility.isEmpty(repayObj)){
        dss.repObj = repayObj[0];
        dss.status= 'Success'; 
        //return JSON.serialize(repayObj[0]);
    }
    else{
        dss.repObj = new RePayment_mode_detail__c();
        dss.status = 'Fail';
    }
        //return 'Fail';
    return JSON.serialize(dss);
}
public static String cloneRepayRecord(String oppId){
    
    List< RePayment_mode_detail__c > repayObj = [SELECT Id,/*22018*/UMRN__c,/*22018*/ A_C_type__c,ECS_Barcode_No__c,Open_ECS_Facility__c, Open_ECS_Ex_Customer_Id__c, Open_Valid_till__c, Open_ECS_Max_Limit__c, ECS_Start_Date__c, ECS_End_Date__c, ECS_Amount__c, name, Loan_Application__c, A_C_NO__c, MICR_Code__c, PDC_START_DATE__c, IFSC_Code__c, Account_Holder_Name__c,Bank_Name__c, No_of_Cheques__c, Cheque_Serial_Number__c, Repayment_Mode__c, To_Cheque_Serial_Number__c, Cheque_Amount__c, Tranche_Detail__c, Bank_Branch__c, PDC_By_Name__c ,Mandate_Process_Stage__c FROM RePayment_mode_detail__c WHERE Loan_Application__r.Id =: oppId LIMIT 1];
    if(!CommonUtility.isEmpty(repayObj))
        return JSON.serialize(repayObj[0]);
    else
        return 'Fail';
}
public static String fetchDisbursementObject(String disbId,String Loanid, String objectFieldJSON){
    try{
    SALMobilityOppCntrl_V2.oppData dss = new SALMobilityOppCntrl_V2.oppData();
    system.debug('before object'+objectFieldJSON);
    if(objectFieldJSON != null && objectFieldJSON != '')
        dss.picklistData = LighteningUtilities.getPicklistValues(objectFieldJSON); 
    system.debug('after object');
    List< Current_Disbursal_Details__c > disbObj = [SELECT IMPS_Account_Validate__c,/*Bug:23361-Added Account_Validated__c*/ Account_Validated__c,Id,/* bug 20391 Added IMPS_Transaction_No__c */IMPS_Transaction_No__c,Repay_Disb_Diff__c,IMPS_Result__c,Disbursal_Mode__c,Bank_Branch__c,Favouring__c,Bank_Account__c,IFSC_Code__c,Successful_IMPS_Count__c,Failure_IMPS_Count__c,Bank_Name__c,Disbursement_Amount__c,IMPS_Flag__c,Payable_at__c,FinnOne_Disbursement_Date__c,Loan_Application__c,IMPS_Count__c  FROM Current_Disbursal_Details__c WHERE Id =: disbId];
    System.debug('list obj of disbObj'+disbObj);
        if(!CommonUtility.isEmpty(disbObj)){
        dss.disObj = disbObj[0];
        dss.status = 'Success';
    }
    else
    {  
        Opportunity loan  =new Opportunity ();
        if(!CommonUtility.isEmpty(Loanid)){
            loan =  [Select id,Branch_Name__r.name from Opportunity where id = : Loanid];
            dss.BranchName =loan.Branch_Name__r.name ;
        }
        
        dss.status = 'Fail';
        dss.disObj = new Current_Disbursal_Details__c();
    //Bug 20391 : Bug 22062  : Pre-populate values : Start
                if (Loanid != null) {
                    loan = [select id,Loan_Amount_with_Premium__c from Opportunity where id = :Loanid limit 1 ];
                    if(loan!=null){
                        Integer chargesAPI = 0;
                        Double netdisb =0;
                        List < Fees_and_Charge__c > fees = new List < Fees_and_Charge__c > ();
                        fees = [select id, name,Finnone_ChargeId__c,Finnone_ChargeCode__c,Charge_Desc__c, Loan_Application__r.name, Charge_Type__c, Deducted_from_Disbursement__c,
                                Service_Charge__c, Status__c, Change_Amount__c, Instrument_Date__c, Instrument_No__c, Bank_Branch__c, Charge__c, Instrument_type__c,
                                Amount_after_Service_Change__c, Disbursement_Number__c from Fees_and_Charge__c where Loan_Application__c = : loan.id
                               ];
                        for(Fees_and_Charge__c feescharges: fees){
                            if(feescharges.Deducted_from_Disbursement__c == 'Yes'){  
                                if(feescharges.Change_Amount__c!=null) {
                                    chargesAPI=chargesAPI+Integer.valueOf(feescharges.Change_Amount__c);
                                }
                            }
                        }
                        
                        if (loan.Loan_Amount_with_Premium__c != null) {
                            netdisb = loan.Loan_Amount_with_Premium__c - chargesAPI;
                        }
                        
                        List<Current_Disbursal_Details__c>    DisbList = [select id, Loan_Application__c, Disbursement_Amount__c
                                                                          from Current_Disbursal_Details__c where Loan_Application__c = : Loan.id
                                                                         ];
                        Double sum_Disbursement_Amount = 0;
                        for(Current_Disbursal_Details__c curDisb: DisbList){
                            if(curDisb.Disbursement_Amount__c!=null){
                                sum_Disbursement_Amount = sum_Disbursement_Amount + curDisb.Disbursement_Amount__c;
                            }
                        }
                        
                        Current_Disbursal_Details__c newDisbObj = new Current_Disbursal_Details__c();
                        
                        if(netdisb!=null && sum_Disbursement_Amount!=null && netdisb>=sum_Disbursement_Amount  ){
                            newDisbObj.Disbursement_Amount__c = netdisb - sum_Disbursement_Amount;
                            dss.disObj = newDisbObj;
                            
                        }
                    }
                }
                //Bug 20391 : Bug 22062  : Pre-populate values : End 
        
    }
        System.debug('Line'+dss);
    return JSON.serialize(dss);
    }catch(Exception e)
    {
        System.debug('Exception  '+ e.getLineNumber() + e.getMessage());
    }
    return null; 
}

//1652 below entire method - hrushikesh
      //1652 below entire method - gaurav ,logic updated for 15647
  
 public static String sendMail(String opp,Decimal approvedROI, Decimal proposedROI, Decimal approvedPF, Decimal proposedPF,String appObj){
        try{
            List < SALMobilityCntrl_V2.SelectOption > optionsAppr = new List < SALMobilityCntrl_V2.SelectOption > ();
            Decimal maxLimit;
            String loanType;
             Integer desIndex =-1;
             List<String> sequence = new List<String>{'Regional Sales Manager','Zonal Sales Manager','National Sales Manager','Business head'};
            Map < String, Object > wholeJSON, loc_categoryJSON, roi_pfJSON, loanTypeJSON;
            Map < String, Object > innerMap;
            Map < String, Object > innerMapType;
            Decimal insFactor;
            Boolean changeInROI=false, changeInPF=false,forInsuranceCheck=false,invalidPF=false,invalidROI=false;
            Decimal diffInROI = 0.0, diffInPF = 0.0;
           
            Opportunity Loan = (Opportunity) JSON.deserialize(opp, Opportunity.Class);
            Applicant__c app = (Applicant__c) JSON.deserialize(appObj, Applicant__c.Class);
            if(app != null)
                update app;
            
             Opportunity oppObject = [select id, Loan_variant__c,Insurance_Premium_Amt__c,Net_Loan_to_POS__c, Branch_Name__r.Location_Category__c,
            (select id,Add_on_Holder_First_Name__c,Add_on_Holder_Last_Name__c,Policy_Name__c,Name from SOL_Policys__r where Name='Sales2.0 Dynamic Offer Amount' OR  Name='Sales2.0 Pre Approved Case' LIMIT 2)
             from Opportunity where id =: Loan.id];
            if(Loan.Approved_Loan_Amount__c != null){
                oppObject.Approved_Loan_Amount__c = Loan.Approved_Loan_Amount__c;
                update oppObject;
            }
            
             List<SOL_Policy__c> allSols = oppObject.SOL_Policys__r;
            System.debug('allSols value='+allSols);
            
            Applicant__c applicant=[select id,EMI_Card__c,Financial_Health_Check_Guide__c from Applicant__c where Loan_Application__c =: Loan.id AND Applicant_Type__c = 'Primary' Limit 1 ];
            System.debug('emi card value='+applicant.EMI_Card__c);
            System.debug('ffr value='+applicant.Financial_Health_Check_Guide__c);
            if((applicant.EMI_Card__c==null || applicant.Financial_Health_Check_Guide__c==false) &&!commonutility.isEmpty(oppObject.Branch_Name__r.Location_Category__c) && oppObject.Branch_Name__r.Location_Category__c=='1-8' )
                desIndex=2;
            else if((applicant.EMI_Card__c==null || applicant.Financial_Health_Check_Guide__c==false) &&!commonutility.isEmpty(oppObject.Branch_Name__r.Location_Category__c) && oppObject.Branch_Name__r.Location_Category__c!='1-8' )
                desIndex=3;

            if (applicant.EMI_Card__c!=null && applicant.Financial_Health_Check_Guide__c==true){
                System.debug('inside emi not null and frr true ');
                
          if( allSols!=null && allSols.size()>0 && allSols[0].Add_on_Holder_First_Name__c!=null  && approvedROI < proposedROI && proposedROI < decimal.valueOf(allSols[0].Add_on_Holder_First_Name__c)      ){//this will run only in case if Dynamic offer ROI is diff
               proposedROI=proposedROI;
               
               System.debug('one');
              approvedROI=decimal.valueOf(allSols[0].Add_on_Holder_First_Name__c);
              }
         else if(allSols!=null && allSols.size()>0 && allSols[0].Add_on_Holder_First_Name__c!=null && decimal.valueOf(allSols[0].Add_on_Holder_First_Name__c) >approvedROI){//this will run only in case if Dynamic offer ROI is diff
               proposedROI=proposedROI;
               approvedROI=decimal.valueOf(allSols[0].Add_on_Holder_First_Name__c);
 
                 System.debug('two');
              }
          if(allSols!=null && allSols.size()>0 && allSols[0].Add_on_Holder_Last_Name__c!=null  &&  approvedPF < proposedPF && proposedPF < decimal.valueOf(allSols[0].Add_on_Holder_Last_Name__c)){
              proposedPF=proposedPF;
              System.debug('three');
              approvedPF=decimal.valueOf(allSols[0].Add_on_Holder_Last_Name__c);
       }
       else if(allSols!=null && allSols.size()>0 && allSols[0].Add_on_Holder_Last_Name__c!=null && decimal.valueOf(allSols[0].Add_on_Holder_Last_Name__c) >approvedPF){
              proposedPF=proposedPF;
                System.debug('four');
             approvedPF=decimal.valueOf(allSols[0].Add_on_Holder_Last_Name__c);
       }
            
                             System.debug('ROI or PF is changed before UW Approval  '+proposedROI+'  '+proposedPF);

            System.debug('approvedROI='+approvedROI);
            System.debug('proposedROI='+proposedROI);
            diffInROI = approvedROI - proposedROI;
            diffInPF = approvedPF - proposedPF;
            if (diffInROI != 0){ changeInROI = true;  diffInROI = Math.abs(diffInROI);}
            if (diffInPF != 0){ changeInPF = true;  diffInPF = Math.abs(diffInPF);}
            
            System.debug('** diffcs are '+diffInROI+ ' ||| '+diffInPF);

            
            if(oppObject.Net_Loan_to_POS__c!=null && oppObject.Insurance_Premium_Amt__c!=null && (oppObject.Net_Loan_to_POS__c - oppObject.Insurance_Premium_Amt__c)!=0)
                insFactor=((oppObject.Insurance_Premium_Amt__c * 100)/(oppObject.Net_Loan_to_POS__c - oppObject.Insurance_Premium_Amt__c)).setScale(2);
            System.debug('Insurance Factor = '+insFactor);
            if (!commonutility.isEmpty(oppObject.Loan_Variant__c) && (oppObject.Loan_Variant__c.containsIgnoreCase('HYBRID') || oppObject.Loan_Variant__c.containsIgnoreCase('FLEXI'))) {
                loanType = 'FLEXI';
            }
            if (!commonutility.isEmpty(oppObject.Loan_Variant__c) && (oppObject.Loan_Variant__c.containsIgnoreCase('REGULAR')||oppObject.Loan_Variant__c.containsIgnoreCase('TERM'))) {
                loanType = 'REGULAR';
            }
            System.debug('** loanType  '+loanType);
            wholeJSON = (Map < String, Object > ) CommonUtility.getMapFromStaticResource('EmployeeLoanStaticResource', 'SendMailToHierarchy');
            loc_categoryJSON = (Map < String, object > ) wholeJSON.get(oppObject.Branch_Name__r.Location_Category__c);
            System.debug('JSON='+loc_categoryJSON);
            
            if (changeInROI ) {
                System.debug ('inside ROI condition change='+diffInROI);
                roi_pfJSON = (Map < String, object >) loc_categoryJSON.get('ROI');
                loanTypeJSON = (Map < String, object > ) roi_pfJSON.get(loanType);
                String[] limits;
                for (String key: loanTypeJSON.keySet()) {
                    System.debug('key='+key);
                    limits = String.valueOf(loanTypeJSON.get(key)).split(';');
                    System.debug('** checking ROI between limits  '+limits[0]+' and '+limits[1]);
                    if (diffInROI >= Decimal.valueOf(limits[0]) && diffInROI <= Decimal.valueOf(limits[1])) {
                        System.debug ('condition true');
                        if (sequence.indexOf(key)>desIndex) desIndex=sequence.indexOf(key);
                    }
                }         
                if( desIndex== -1 )
                {
                    invalidROI=true;
                    forInsuranceCheck=false;
                }
                
            }
            System.debug('desIndex after ROI='+desIndex);
            if (changeInPF ) {
                roi_pfJSON = (Map < String, object > ) loc_categoryJSON.get('PF');
                loanTypeJSON = (Map < String, object > ) roi_pfJSON.get(loanType);
                String[] limits;
                for (String key: loanTypeJSON.keySet()) {
                    limits = String.valueOf(loanTypeJSON.get(key)).split(';');
                    System.debug('** checking PF between limits   '+limits[0]+' and '+limits[1]);
                    System.debug('Proposed PF is ='+proposedPF);
                    if (proposedPF>= Decimal.valueOf(limits[0]) && proposedPF <= Decimal.valueOf(limits[1])) {
                      if (sequence.indexOf(key)>desIndex) desIndex=sequence.indexOf(key);
                        System.debug('key='+key);
                    }
                }
                if( desIndex ==-1 )
                {
                    invalidPF=true;
                    forInsuranceCheck=false;
                }
            }
            System.debug('desIndex after PF='+desIndex);
                System.debug('insfactor value='+insFactor);
            //for insurance
            if(insFactor!=null && insFactor!=0)
            {
                roi_pfJSON = (Map < String, object > ) loc_categoryJSON.get('Insurance');
                String[] limits;
                for (String key: roi_pfJSON.keySet()) {
                    limits = String.valueOf(roi_pfJSON.get(key)).split(';');
                    System.debug('** checking insurance between limits  '+limits[0]+' and '+limits[1]);
                    if (insFactor >= Decimal.valueOf(limits[0]) && insFactor <= Decimal.valueOf(limits[1])) {
                       if (sequence.indexOf(key)>desIndex) desIndex=sequence.indexOf(key);
                    }
                }
                if( desIndex== -1 )
                    forInsuranceCheck=true;
                
            }
            System.debug('desIndex after ins='+desIndex);
            //for insurance End
            //conditions priority as described by BFL , first insurance , then ROI/PF , lastly default condition put up for on load of component.
            
            }
           if( desIndex== -1 && forInsuranceCheck )
                {
                   return 'show no error msg';//commented for bug 26506
                }
                
                if(invalidROI || invalidPF)
                {
                    return 'invalidROIPF';
                }

            // if EMI and FFR selected then and no change in any parameters then default condition , can procced with approval
            // hence control terminated here, no need to calculate hierarchy
            if (desIndex== -1 && applicant.EMI_Card__c!=null && applicant.Financial_Health_Check_Guide__c==true){
                return 'default';
             }
            // conditions for termination moved up to prevent unnecessary code execution
            
            List< Sales_Officer_Limit__c> allSOL = [select id,FFR_Percent__c, WIRR__c, WPF__c, LI_PREMIUM__c, LI_Percent__c, HI_PREMIUM__c, HI_Percent__c, Sales_Officer_Name__r.email, Sales_Officer_Name__c, Sales_Officer_Name__r.Mobile_number__c, Sales_Officer_Name__r.name, Reporting_Manager_Name__c, Reporting_Manager_Designation__c,
                                                    Reporting_Manager_Name__r.Mobile_number__c, ASM_Branch__c, Selected_Flag__c, Designation__c, Location__c, Product__c,
                                                    Max_Number__c,Sales_officer_Email__c,DesignationCount__c,Reporting_Manager_Name__r.name 
                                                    from Sales_Officer_Limit__c 
                                                    where Active__c = true And Sales_Officer_Name__r.IsActive = true 
                                                    and Product__c = : Loan.Product__c ];
            if(!CommonUtility.isEmpty(allSOL )){
                Map< Id, Sales_Officer_Limit__c > heirarchyMap = new Map< Id, Sales_Officer_Limit__c > ();
                Id tempId;
                if(Loan.Relationship_Manager__c != null){
                    system.debug('Area sales manager'+Loan.Relationship_Manager__c);
                    List<User> userList = [Select Profile.Name from User where id=: Loan.Relationship_Manager__c];
                    String profile = userList[0].Profile.Name;
                    if (profile == 'Area Sales Manager') {
                        tempId = Loan.Relationship_Manager__c;
                        System.debug('loan relManager='+tempId);
                        System.debug('in 1');
                    } else {
                        tempId = Loan.Area_SM__c;
                        System.debug('in 2');
                    }
                }
                
                for (Sales_Officer_Limit__c sol: allSOL) {
                    heirarchyMap.put(sol.Sales_Officer_Name__c, sol);   
                }
                System.debug('heirarchyMap' + heirarchyMap);
                System.debug('desIndex before heirarchy calculation='+desIndex);
                
                Sales_Officer_Limit__c finalSOL = new Sales_Officer_Limit__c (); 
                finalSOL = heirarchyMap.get(tempId);
                System.debug('desIndex'+desIndex);
                if( desIndex != -1 )
                {
                    Boolean desFlag = false;
                    //15647 s
                   
                    do {
                        
                       // System.debug ('finalSOl object in loop='+finalSOL.Sales_Officer_Name__r.Name);
                        if(finalSOL != null && finalSOL.Sales_Officer_Name__c != null  
                        && (finalsol.designation__c== sequence[desIndex] || desFlag==true)
                          && finalSOL.Reporting_Manager_Name__c != null){
                            desFlag=true;
                            //System.debug('@@Swapnil '+finalSOL.Id+' '+finalSOL.Sales_Officer_Name__r.name + '-' + finalSOL.Designation__c);
                            optionsAppr.add(new SALMobilityCntrl_V2.SelectOption(finalSOL.Id, finalSOL.Sales_Officer_Name__r.name + '-' + finalSOL.Designation__c));
                        }
                        
                        if (finalSOL!=null && finalSOL.Reporting_Manager_Name__c!= null)
                        {
                            finalSOL = heirarchyMap.get(finalSOL.Reporting_Manager_Name__c);
                            System.debug('sol updated='+finalSOL);
                        }
                            
                        
                         if (finalSOL!=null && finalSOL.Reporting_Manager_Name__c == null)
                        {
                            
                            System.debug('boundary condition postcheck='+finalSOL);
                            optionsAppr.add(new SALMobilityCntrl_V2.SelectOption(finalSOL.Id, finalSOL.Sales_Officer_Name__r.name + '-' + finalSOL.Designation__c));
                            finalSol=null;
                        }
                        
                    } while (finalSOL != null && finalSOL.Reporting_Manager_Name__c!= null); 
                    //15647 e
                }
                else
                    return 'ROI/PF cannot be approved';
                
                System.debug('options for heirarchy='+optionsAppr);
                return JSON.serialize(optionsAppr);
            }
            return 'Sales Master not maintained';
        } catch (Exception e) {
            system.debug('exception'+e.getMessage()+e.getLineNumber()+e.getCause()+'stack trace'+e.getStackTraceString());
            return 'Sales Master not maintained';
        }
    }
    
//15647 e

public static String fetchData(Id loanAppId, String objectFieldJSON){
    System.debug('loanAppId--->'+loanAppId);
    SALMobilityOppCntrl_V2.oppData dss = new SALMobilityOppCntrl_V2.oppData();
    SALMobilityOppCntrl_V2.getAllData(loanAppId,dss); 
    dss.picklistData = LighteningUtilities.getPicklistValues(objectFieldJSON); 
    User UserInfoDetails = [select id, Profile.Name, Name from User where id = : UserInfo.getUserId() LIMIT 1];
    dss.isCommunityUsr = CommonUtility.hasCommunityProfile(new Set<String>{UserInfoDetails.Profile.Name});
    dss.emiCardoptions= getpicklistvalnew('Applicant__c','EMI_Card__c');//22017
    dss.eliteCardoptions= getpicklistvalnew('Applicant__c','Elite_card_product__c');//22017
    System.debug('dss.Data'+dss.opp);
    if(dss.srcamObj == null)
        dss.srcamObj = new SurrogateCAM__c();
dss.maxLimitROI=salmobilitypricingcntrl_v2.checkMaxRateApproval(loanAppId); //Sprint 5C 22624
    
    return JSON.serialize(dss); 
    
}
public static String approvePricing(String oppObj,String appObj,String acc){
    Opportunity opp = (Opportunity) JSON.deserialize(oppObj, Opportunity.class);
    Applicant__c app = (Applicant__c) JSON.deserialize(appObj, Applicant__c.class);
    Account acc1 = (Account) JSON.deserialize(acc, Account.class);
    /*22182 s*/
    String emiVal = SAL_PricingCtrlV2.calculateEMIValue(opp,app); //22182
    if(emiVal != null){
       opp.EMI_CAM__c = Decimal.valueof(emiVal); //22182
       if(!CommonUtility.isEmpty(opp.Scheme_Master__c) && !CommonUtility.isEmpty(opp.Scheme_Master__r.IsHybridFlexi__c) && opp.Scheme_Master__r.IsHybridFlexi__c == true)
           app.Pure_Flexi_EMI__c =  ((opp.Loan_Amount_with_Premium__c *opp.Approved_Rate__c) / 1200);
    }
    /*22182 e*/
    update opp;
    if(app != null){
        //added for bug id 23507/22624 start
        if(app.PFApproveStatus__c != null)
        {
            app.PFApproveStatus__c = '';
        }
        //added for bug id 23507/22624 stop
        update app;
    }
    if(acc1 != null)
        update acc1;
            //prod issue start
            SALMobilityOppCntrl_V2.oppData dss = new SALMobilityOppCntrl_V2.oppData();
                dss.opp = opp;
                dss.applicantPrimary =app;
                dss.accObj = acc1;
            //prod issue end
        return JSON.serialize(dss);
}
//17556 stop - hrushikesh
    /* Bug : 17139 S */
public class pricingData {
    public Applicant__c applicantPrimary;    
    public eKYC__c ekycObj;
    public List<DPLinsurance__c> insuranceObjList;
    public Map<String, Map<String, List<String>>> picklistData;
    public List<DependentList> DependentList1;
    public List < Discrepancy__c > discrepancyList = new List < Discrepancy__c >(); //rename to sanctionList
    public List < Discrepancy__c > existingDisList = new List < Discrepancy__c >();
    public Account accObj;
    public Contact objCon;
    public List<String> statesEkyc;
    public List<Bank_Account__c> bankList;
    public Bank_Account__c bankObj;
    public RePayment_mode_detail__c repaymentModeDtlObj;//E-mandate check begins
    public List<RePayment_mode_detail__c> repayList=new List<RePayment_mode_detail__c>();//E-mandate check begins
    public List<Verification__c> veriList; 
    public List<De_Dupe__c> dedupeList; 
    public Opportunity opp;
    public List<Current_Disbursal_Details__c> disburement= new List < Current_Disbursal_Details__c >();
}
public class DependentList {
    @AuraEnabled          
    public String key;
    @AuraEnabled          
    public List<String> value;
    
    public DependentList(String key, List<String> value)
    {
        this.key=key;
        this.value=value;
    }
    
}
public static LIst<Discrepancy__c> saveSanctionDetails(String loanId,String JSONDiscrepancyList)
{
List <Discrepancy__c> genericDiscrepancyList = new List <Discrepancy__c>();
    try{
        
        genericDiscrepancyList = (List<Discrepancy__c>)JSON.deserialize(JSONDiscrepancyList, List<Discrepancy__c>.class);
        System.debug('List of Discr: '+genericDiscrepancyList);   
        upsert genericDiscrepancyList;
    }catch(Exception e){
        System.debug('Exception in saveSanction, Line number '+e.getLineNumber() +e.getMessage());
        return null;
    }
    return genericDiscrepancyList;
}
/* Bug : 17139 E */
//17556 start - hrushikesh
public static String saveOffers(String loanId, String JSONapplicantObj,String JSONsurrogateObj)
{
    try{
        SurrogateCAM__c surrogateObject = new SurrogateCAM__c();
        surrogateObject = (SurrogateCAM__c)JSON.deserialize(JSONsurrogateObj,SurrogateCAM__c.class);
        Applicant__c applicantObject = new Applicant__c();
        applicantObject = (Applicant__c)JSON.deserialize(JSONapplicantObj, Applicant__c.class);
    //added for 5284 /24667 start
            Opportunity loan = new Opportunity();
            List<Opportunity> oppList = [SELECT id,Application_Source__c,Loan_Amount_with_Premium__c,Loan_Application_Number__c ,Due_Day__c ,Scheme_Master__r.Scheme_Code__c, Approved_Rate__c ,Approved_Tenor__c,Processing_Fees__c,Approved_Loan_Amount__c,EMI_CAM__c,Scheme_Master__c,Scheme_Master__r.IsHybridFlexi__c, (select id,Lead__c,Lead__r.Number_of_Add_on_card__c from Product_Offerings__r)/*977 start*/,(select id, name, Finnone_ChargeId__c, Charge_Desc__c, Tranche_Detail__r.name, Deposition_Date__c, Deposit_Slip_Number__c, Loan_Application__r.name, Change_Amount__c, Charge_Type__c, Deducted_from_Disbursement__c,Service_Charge__c, Status__c, Tranche_Detail__c, Instrument_Date__c, Instrument_No__c, Bank_Branch__c, Instrument_type__c,
Amount_after_Service_Change__c, Tranche_Detail__r.Tranche_Number__c from Fees_and_Charges__r where Identifier__c != 'Mortgage')/*977 stop*/ from Opportunity where id = : loanId];
            if(!CommonUtility.isEmpty(oppList)){
                loan = oppList.get(0);
            }
            system.debug('applicantObject.EMI_Card__c is::'+applicantObject.EMI_Card__c);
            if(applicantObject.EMI_Card__c != null && applicantObject.EMI_Card__c != ''){
                system.debug('in if>>>'+applicantObject.EMI_Card__c);
                if(loan!= null && loan.Product_Offerings__r != null && loan.Product_Offerings__r.size() >0){
                    Product_Offerings__c  poTemp = loan.Product_Offerings__r[0];
                    if(poTemp.Lead__c != null && poTemp.Lead__r.Number_of_Add_on_card__c == 0|| poTemp.Lead__r.Number_of_Add_on_card__c ==1|| poTemp.Lead__r.Number_of_Add_on_card__c == 2){
                        return 'EMIError';
                    }
                }
            }
            //added for 5284 /24667 stop
        if(applicantObject.Financial_Health_Check_Guide__c)
            applicantObject.Subscribed_to_Credit_Vidya__c = true;
        upsert applicantObject;
        upsert surrogateObject;
        SpecialOfferCntrl specialoffer = new SpecialOfferCntrl(loanId);
        specialoffer.subscribeToFFR();
       // CallChargesAPI(loanId);//commented 977

        System.debug('Surrogate object - : '+surrogateObject+applicantObject);
        
       // upsert surrogateObject; //commented 977
    }catch(Exception e){
        System.debug('Exception in saveOffers, Line number '+e.getLineNumber() +e.getMessage());
    }
    return 'Pass';
}

public static String saveCustomerConsentMethod(String oppId,String bpi,String stampDuty, String firstEMI, String disbursmentObj,String lastEMI, String EMI)
{
    try{
 /* Bug 22624 Start - Hrushikesh Sprint 5C */
        if(oppId !=null && firstEMI!=null && lastEMI!=null ){
            List<Applicant__c> appList = [Select First_EMI__c, Last_EMI__c from Applicant__c where Loan_Application__c =: oppId AND Applicant_Type__c = 'Primary' Limit 1];
            appList[0].First_EMI__c=firstEMI;
            appList[0].Last_EMI__c=lastEMI;
            upsert appList;
        }            
        /* Bug 22624 Stop - Hrushikesh Sprint 5C */
        Current_Disbursal_Details__c disbursmentObjectToUpsert = (Current_Disbursal_Details__c)JSON.deserialize(disbursmentObj,Current_Disbursal_Details__c.class);
        //  System.debug('Sending Mail logic in Save Customer Consent');
        //  SALMobilityController.salMobilityFlagV2 = true;
        //   SALMobilityController.sendPricingEmailToCustomer(oppId,firstEMI,lastEMI,bpi, EMI);
        System.debug('Updated DisbursmentObject : '+disbursmentObjectToUpsert);
        upsert disbursmentObjectToUpsert;                   
    }catch(Exception e){
        System.debug('Exception in saveCustomerConsent, Line number '+e.getLineNumber() +e.getMessage());
    }
    return 'Pass';
}
public static String sendEaggrementMail(String oppId,String bpi,String stampDuty, String firstEMI, String disbursmentObj,String lastEMI, String EMI)
{
    try{        
        SALMobilityController.salMobilityFlagV2 = true;
        SALMobilityController.sendPricingEmailToCustomer(oppId,firstEMI,lastEMI,bpi, EMI);
/* Bug 22624 Start - Hrushikesh Sprint 5C */
        if(oppId !=null && firstEMI!=null && lastEMI!=null ){
            List<Applicant__c> appList = [Select First_EMI__c, Last_EMI__c from Applicant__c where Loan_Application__c =: oppId AND Applicant_Type__c = 'Primary' Limit 1];
            appList[0].First_EMI__c=firstEMI;
            appList[0].Last_EMI__c=lastEMI;
            upsert appList;
        }         
        /* Bug 22624 Stop - Hrushikesh Sprint 5C */
    }catch(Exception e){
        System.debug('Exception in sendEaggrementMail method, Line number '+e.getLineNumber() +e.getMessage());
    }
    return 'Pass';
}
// 17556 stop - hrushikesh
/* Bug : 17139 S */
public static String getSanctionDetailsMethod(String oppId)
{
    pricingData dss = new pricingData();
    if(!commonutility.isEmpty(oppId)){
        dss.discrepancyList=[select OTPDiscrepancyCategory__c,OTPDiscrepancyDocuments__c,Status__c,Resolution_Remarks__c from Discrepancy__c where LoanApplication__c =: oppId];
    }
    System.debug(dss.discrepancyList);
    
    return JSON.serialize(dss);       
    
}
public static String getDiscrepancyDetails(String myid,  String objectFieldJSON, String controllingField, String dependentField)
{
    pricingData dss = new pricingData();
    List<DependentList> DependentListTemp = new List<DependentList>();
    dss.picklistData = LighteningUtilities.getPicklistValues(objectFieldJSON);
    System.debug('hereiam');
    //to check
    Map<String,List<String>> dependentData = DynamicFieldsController.getFieldDependencies('Discrepancy__c',controllingField,dependentField);
    for (String key : dependentData.keySet()) {
        List<String> value = dependentData.get(key);
        System.debug('Key = ' + key + ', Value = ' + value);
        DependentList sol=new DependentList(key,value);
        
        DependentListTemp.add(sol); 
    }
    dss.DependentList1=DependentListTemp;
    system.debug('HH inside getDisposition 1'+dependentData );
    return JSON.serialize(dss);       
    
}
/* Bug : 17139 E */
// 17556 start - hrushikesh
public static String getPricingDashboardDetails(String oppId)
{   
    //hrushikesh start
    List<Applicant__c> applicantList=new List<Applicant__c>();
    List<eKYC__c> ekycList = new List<eKYC__c>();
    List<DPLinsurance__c> insuranceList = new List<DPLinsurance__c>();
    List<Account> accountList = new List<Account>();
    List<Contact> contactList = new List<Contact>();
    List<Bank_Account__c> bankAccountList = new List<Bank_Account__c>();
    List<Discrepancy__c> discrepancyList = new List<Discrepancy__c>();
    List<RePayment_mode_detail__c> repayList = new List<RePayment_mode_detail__c>();
    List<Verification__c> verificationList = new List<Verification__c>();
    List<De_Dupe__c> DeDupeList = new List<De_Dupe__c>();
    List<Opportunity> loanApplication = new List<Opportunity>();
    List<Current_Disbursal_Details__c> disburement = new List<Current_Disbursal_Details__c>();
    List<Verification__c> veriList = new List<Verification__c>();
    //pricingData data=new pricingData();
    
    SALMobilityOppCntrl_V2.oppData data = new SALMobilityOppCntrl_V2.oppData();
    SALMobilityOppCntrl_V2.getAllData(oppId,data);
    data.statesEkyc = getStates();
    
    
    
    //hrushikesh stop */
    return JSON.serialize(data);
    
}
//added by priyanka --start
@AuraEnabled 
public static String checkDuplicateLan(String oppId,String currentBarcode){
    try{
        List < RePayment_mode_detail__c > RepayList = new List < RePayment_mode_detail__c > ();
        RepayList = [select id,Copy_Perfios_Details__c, A_C_type__c,ECS_Barcode_No__c,Open_ECS_Facility__c, Open_ECS_Ex_Customer_Id__c, Open_Valid_till__c, Open_ECS_Max_Limit__c, ECS_Start_Date__c, ECS_End_Date__c, ECS_Amount__c, name, Loan_Application__c, A_C_NO__c, MICR_Code__c, PDC_START_DATE__c, IFSC_Code__c, Account_Holder_Name__c,
                     Bank_Name__c, No_of_Cheques__c, Cheque_Serial_Number__c, Repayment_Mode__c, To_Cheque_Serial_Number__c,
                     Cheque_Amount__c, Tranche_Detail__c,
                     Bank_Branch__c, PDC_By_Name__c
                     from RePayment_mode_detail__c where Loan_Application__c = : oppId
                    ];
        DuplicateLoanId = '';             
        DuplicateBarCodeNo = '';
        Boolean flag= true;
        List <String> BarNoList = new List <String> ();         // List for newly inserting Repayment Details Records 
        List <String> BarNolistUpdate = new List <String> ();   // List for already existing Records
        Set<String> duplicateSet = new Set<String>();
        
        
        if(RepayList.size()==0){
            
            BarNoList.add(currentBarcode);
            
        }
        
        else{
            for(RePayment_mode_detail__c rList:RepayList)
            {
                system.debug('currentBarcode=='+currentBarcode);
                if(rList.ECS_Barcode_No__c !=null && rList.ECS_Barcode_No__c!=currentBarcode )
                { 
                    BarNoList.add(rList.ECS_Barcode_No__c );
                    // BarNoList.add(currentBarcode ); 
                    
                }
                else
                {
                    BarNolistUpdate.add(rList.ECS_Barcode_No__c);
                    //BarNoList.add(currentBarcode );   
                }
            }
        }
        system.debug('List of new barcode number is##' + BarNoList);
        system.debug('List of already existing Barcode Number in same LAN##'+BarNolistUpdate);
        List<RePayment_mode_detail__c > FinalList = [select ECS_Barcode_No__c,Loan_Application__c from RePayment_mode_detail__c where ECS_Barcode_No__c!=null and Loan_Application__c !=:oppId  and  ECS_Barcode_No__c IN :BarNoList Limit 1];
        List<RePayment_mode_detail__c > FinalListUpdate = [select ECS_Barcode_No__c,Loan_Application__c from RePayment_mode_detail__c where ECS_Barcode_No__c!=null and Loan_Application__c !=:oppId and ECS_Barcode_No__c IN :BarNolistUpdate Limit 1];
        system.debug('List of Matched New Barcode number'+ FinalList);
        system.debug('List of Matched old Barcode number'+ FinalListUpdate);
        if(FinalList.size()>0 && FinalList!=null && FinalList[0].Loan_Application__c!=null && FinalList[0].ECS_Barcode_No__c!=null )
        {
            system.debug('Final List');
            DuplicateLoanId = FinalList[0].Loan_Application__c;
            DuplicateBarCodeNo = FinalList[0].ECS_Barcode_No__c;
        }
        else
        {
            if(FinalListUpdate.size()>0 && FinalListUpdate!=null && FinalListUpdate[0].Loan_Application__c!=null && FinalListUpdate[0].ECS_Barcode_No__c!=null )
            {
                system.debug('Final List Update');
                DuplicateLoanId = FinalListUpdate[0].Loan_Application__c;
                DuplicateBarCodeNo = FinalListUpdate[0].ECS_Barcode_No__c;
            }  
            
        }
        
        
        system.debug('The DuplicateLoanId is'+DuplicateLoanId);
        system.debug('The DuplicateBarCodeNo is:'+ DuplicateBarCodeNo);
        for(String bNo:BarnoList)
        {
            if(!duplicateSet.add(bNo)){
                flag=false;
                DuplicateBarCodeNo=bNo;
            }
        }
        if(flag!=true)
        {
            DuplicateLoanId = String.valueOf(oppId);
        }
        if(DuplicateLoanId!='')
        {
            DuplicateLAN=DuplicateLoanId;
            system.debug('DuplicateLAN is '+ DuplicateLAN);
            
        } 
        else
        {
            DuplicateLAN ='';
        }
        
    }catch(Exception e) {
        ApexPages.addMessages(e);
        
    }
    if(DuplicateLoanId!='' && DuplicateBarCodeNo!='')
        return  'DuplicateLoanId = '+DuplicateLAN +'\n DuplicateBarCodeNo = '+DuplicateBarCodeNo;
    else
        return 'fail';
}

@AuraEnabled
public static String getNachDef(String oppId)
{
    boolean isNachDef=false;
    List<Checklist__c> checkDocs=[select OTPDeferralDocuments__c,Loan_Application__c,Loan_Application__r.Product__c from Checklist__c where Loan_Application__r.Id=:oppId AND ( Loan_Application__r.Product__c!='HBLS' OR Loan_Application__r.Product__c!='HPLS' OR Loan_Application__r.Product__c!='SOL') ];
    
    for(Checklist__c check:checkDocs){
        if(check.OTPDeferralDocuments__c=='NACH Deferral'){
            isNachDef=true;
        }
    }
    if(isNachDef)
        return 'success';
    else
        return 'fail';
    
}

@AuraEnabled
public static Map<String,Object> getCharges(String oppId){
    transient string Upfrontchargescodes;
    transient string TouchFreechargescodes;
    transient string BPIcodes;
     /*25097*/
        transient string cppWallet;
        transient string ffrChagrges;
        transient string EMICardChages;
        transient string cobrandedCC;  
        transient string eliteCard;
        /*25097 e*/
    StaticResource staticresc;
    Decimal totalCharges =0.0;
    Map<String,Object> ALLMap = new Map<String,Object>();
    Map<String,Object> ChargeCodeMap = new Map<String,String>();
    Map<String,Object> chargeFCMap=new Map<String,Object>();
    String jsnBody;
    staticresc = [SELECT Body,Id,Name FROM StaticResource WHERE Name = 'SalariedCustomSettings' LIMIT 1]; 
    if(staticresc != null)
        jsnBody = staticresc.Body.toString();
    ALLMap = (Map<String,Object>)JSON.deserializeUnTyped(jsnBody);
    for(String key:ALLMap.keySet()){
        if(key=='Charges'){
            ChargeCodeMap=(Map<String,Object>) ALLMap.get(key);
        }
    }
    for(String key:ChargeCodeMap.keySet()){
        if(key=='Upfront_Charges'){
            Upfrontchargescodes=String.valueOf(ChargeCodeMap.get(key));
        }
        if(key=='TouchFree_Fee'){
            TouchFreechargescodes=String.valueOf(ChargeCodeMap.get(key));
        }
        if(key=='BPI'){
            BPIcodes=String.valueOf(ChargeCodeMap.get(key));
        }
         // 25097 s
            if(key=='EMICard_Charges'){  
                EMICardChages=String.valueOf(ChargeCodeMap.get(key)); 
            }
            if(key=='CPPWalletCharges'){
                cppWallet=String.valueOf(ChargeCodeMap.get(key)); 
                System.debug('cppWallet '+cppWallet);
            }
            if(key=='FFR_Charges'){
                ffrChagrges=String.valueOf(ChargeCodeMap.get(key)); 
                System.debug('ffrChagrges '+ffrChagrges);
            }if(key=='coBrandedCC'){
                cobrandedCC=String.valueOf(ChargeCodeMap.get(key)); 
                System.debug('cobrandedCC '+cobrandedCC);
                
            }
            if(key=='EliteCard_Charges'){
                eliteCard=String.valueOf(ChargeCodeMap.get(key)); 
                System.debug('eliteCard '+eliteCard);
            }
            // 25097 e
        
    }
    system.debug('TouchFreechargescodes==='+TouchFreechargescodes);
    system.debug('Upfrontchargescodes==='+Upfrontchargescodes);
    system.debug('BPIcodes==='+BPIcodes);
    Set<integer> codes=new Set<integer>();
    List<Fees_and_Charge__c> charges = new  List<Fees_and_Charge__c>();
    
    if (Upfrontchargescodes != null) {
        codes.add(Integer.valueOf(Upfrontchargescodes));
        
    }
    if (TouchFreechargescodes != null) {
        codes.add(Integer.valueOf(TouchFreechargescodes));
        
    }
    if (BPIcodes!= null) {
        codes.add(Integer.valueOf(BPIcodes));
        
    }
     //  25097 s
        if (EMICardChages!= null) {
            codes.add(Integer.valueOf(EMICardChages));
            
        }
        if (cppWallet!= null) {
            codes.add(Integer.valueOf(cppWallet));            
        }
        if (ffrChagrges!= null) {
            codes.add(Integer.valueOf(ffrChagrges));       
        }
        if (coBrandedCC!= null) {
            codes.add(Integer.valueOf(coBrandedCC));       
        }
        if (eliteCard!= null) {
            codes.add(Integer.valueOf(eliteCard));       
        }
        
        // 25097 e
    system.debug('code=='+codes);
    List<Opportunity> opplist = new List<Opportunity>();
    if(oppId != null)
    opplist = [SELECT id,Loan_Amount_with_Premium__c,Loan_Application_Number__c,/*22624 s*/ (select Disbursement_Amount__c from Current_Disbursal_Details_s__r), /*22624 e*/(select Charge_Desc__c,Finnone_ChargeCode__c,Deducted_from_Disbursement__c,Finnone_ChargeId__c,Loan_Application__c,Change_Amount__c/*25097*/,Instrument_type__c from Fees_and_Charges__r) from Opportunity where id = : oppId];
    if(opplist != null && opplist.size() > 0)
    charges = opplist[0].Fees_and_Charges__r;
    if(charges!=null){
        for(Fees_and_Charge__c fc:charges){
            if(fc.Finnone_ChargeId__c==Integer.valueOf(Upfrontchargescodes)){
                chargeFCMap.put('Upfront charge', fc);
            }
            if(fc.Finnone_ChargeId__c==Integer.valueOf(TouchFreechargescodes)){
                chargeFCMap.put('Touch free fees', fc);
            }
            if(fc.Finnone_ChargeId__c==Integer.valueOf(BPIcodes)){
                chargeFCMap.put('BPI fees', fc);
            }
            
             //25097
                if ( fc.Finnone_ChargeId__c==Integer.valueOf(EMICardChages)) {  
                    if(fc.Deducted_from_Disbursement__c == 'Yes' && fc.Instrument_type__c == 'Deduct from Disb')
                        chargeFCMap.put('EMICard fees', fc);
                    else 
                        chargeFCMap.put('EMICard fees', 'NA');
                    
                }
                if (fc.Finnone_ChargeId__c==Integer.valueOf(cppWallet)) {
                    if(fc.Deducted_from_Disbursement__c == 'Yes' && fc.Instrument_type__c == 'Deduct from Disb')
                        chargeFCMap.put('CPPWallet fees', fc);
                    else 
                        chargeFCMap.put('CPPWallet fees', 'NA');
                    
                }
                if (fc.Finnone_ChargeId__c==Integer.valueOf(ffrChagrges)) {
                    if(fc.Deducted_from_Disbursement__c == 'Yes' && fc.Instrument_type__c == 'Deduct from Disb')
                        chargeFCMap.put('FFR fees', fc);
                    else 
                        chargeFCMap.put('FFR fees', 'NA');
                }
                if (fc.Finnone_ChargeId__c==Integer.valueOf(cobrandedCC)) {      
                    chargeFCMap.put('co-brandedCC fees', fc);
                    
                }
                if (fc.Finnone_ChargeId__c==Integer.valueOf(eliteCard)) {
                    chargeFCMap.put('eliteCard fees', fc);
                    
                }
                //25097
            
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
      Decimal Netdisb = 0.0;
       if (opplist != null && opplist.size() > 0 && opplist[0].Loan_Amount_with_Premium__c != null) {
            Netdisb = opplist[0].Loan_Amount_with_Premium__c-totalCharges;
        }
        chargeFCMap.put('NetDisbAmt',String.valueOf(Netdisb.setScale(2)));
/*22624 s*/
Decimal sumAllDisb=0.0;
if(opplist != null && opplist.size() > 0 && opplist[0].Current_Disbursal_Details_s__r!=null && opplist[0].Current_Disbursal_Details_s__r.size()>0 )
{
List<Current_Disbursal_Details__c> disbList=opplist[0].Current_Disbursal_Details_s__r;
if(!commonutility.isEmpty(disbList))
{         
for(Current_Disbursal_Details__c disb: disbList)
{
    sumAllDisb=sumAllDisb + disb.Disbursement_Amount__c;
}
}
}
chargeFCMap.put('totalDisbAmount',String.valueOf(sumAllDisb.setScale(2)));
/*22624 e*/      
    return chargeFCMap;
}
//added by priyanka --end
public static List<String> getStates()
{
    List<String> states = new List<String>();
    StaticResource staticresc;
    Map<String,Object> ALLMap = new Map<String,Object>();
    String jsnBody;
    staticresc = [SELECT Body,Id,Name FROM StaticResource WHERE Name = 'Ekyc_Integration' limit 1]; 
    if(staticresc != null)
        jsnBody = staticresc.Body.toString();
    ALLMap = (Map<String,Object>)JSON.deserializeUnTyped(jsnBody);
    ALLMap =(Map<String,Object>)ALLMap.get('states');  // reuse AllMap
    for (String key : ALLMap.keySet())
    {
        states.add(((String)ALLMap.get(key)).toLowercase());
    }
    system.debug((states));
    return states;
}
//@Future(callout=true)//commented for us 977
public static void CallChargesAPI(String loanId) {
    Opportunity loan = new Opportunity();
     List<Fees_and_Charge__c> Fees = new  List<Fees_and_Charge__c>();
    if(!CommonUtility.isEmpty(loanId)){
        List<Opportunity> oppList = [SELECT id,/* 20934 s*/Application_Source__c,/*20934 e*/Loan_Amount_with_Premium__c,Loan_Application_Number__c ,Due_Day__c ,Scheme_Master__r.Scheme_Code__c, Approved_Rate__c ,Approved_Tenor__c,Processing_Fees__c/*977*/,Approved_Loan_Amount__c,EMI_CAM__c,Scheme_Master__c,Scheme_Master__r.IsHybridFlexi__c,(select id,Applicant_Type__c,Pure_Flexi_Period__c,Pure_Flexi_EMI__c from Loan_Application__r where Applicant_Type__c = 'Primary' limit 1) /*977*/ from Opportunity where id = : loanId];
        if(!CommonUtility.isEmpty(oppList)){
            loan = oppList.get(0);
        }
        BRECallout br = new BRECallout();
        Map < String, String > chargesAPIResponse = new MAP < String, String > ();
        Map < String, String > ChargesAPIMap = new Map < String, String > ();
        ChargesAPIMap.put('DealID', (Loan.Loan_Application_Number__c != null) ? String.valueof(Loan.Loan_Application_Number__c) : '0');
        ChargesAPIMap.put('LoanAmount', (Loan.Loan_Amount_with_Premium__c != null) ? String.valueof(Loan.Loan_Amount_with_Premium__c) : '0');
//bug 20934 s
      if(loan.Application_Source__c != null && loan.Application_Source__c.toLowerCase() == 'online employee loan')
        ChargesAPIMap.put('DueDay', (Loan.First_Due_Date__c != null) ? String.valueof(Loan.First_Due_Date__c.day()) : '0');
      else    //20934 e 
        ChargesAPIMap.put('DueDay', (Loan.Due_Day__c != null) ? String.valueof(Loan.Due_Day__c.day()) : '0');
        ChargesAPIMap.put('Scheme', (Loan.Scheme_Master__r.Scheme_Code__c != null) ? String.valueof(Loan.Scheme_Master__r.Scheme_Code__c) : '0');
        ChargesAPIMap.put('RateOfInterest', (Loan.Approved_Rate__c != null) ? String.valueof(Loan.Approved_Rate__c) : '0');
        ChargesAPIMap.put('Tenure', (Loan.Approved_Tenor__c != null) ? String.valueof(Loan.Approved_Tenor__c) : '0');
        system.debug('chargesAPIRequestmap======>' + ChargesAPIMap);
        
        if (!Test.isRunningTest()) {
            chargesAPIResponse = br.callCharegesAPIService(ChargesAPIMap);
        }
        system.debug('chargesAPIResponse======>' + chargesAPIResponse);
         //commented for 977 start
       /*if (chargesAPIResponse.get('result') == 'SUCCESS') {
       Fees = [select id, name, Finnone_ChargeId__c, Charge_Desc__c, Tranche_Detail__r.name, Deposition_Date__c, Deposit_Slip_Number__c, Loan_Application__r.name, Change_Amount__c, Charge_Type__c, Deducted_from_Disbursement__c,
          Service_Charge__c, Status__c, Tranche_Detail__c, Instrument_Date__c, Instrument_No__c, Bank_Branch__c, Instrument_type__c,
          Amount_after_Service_Change__c, Tranche_Detail__r.Tranche_Number__c from Fees_and_Charge__c where Loan_Application__c = : LoanId And Identifier__c != 'Mortgage' 
          ];

      List<Fees_and_Charge__c> feesL = new List<Fees_and_Charge__c>();
      for(Fees_and_Charge__c feesList : Fees)
      {
        if(feesList.Change_Amount__c > 0)
        {
          feesList.Deducted_from_Disbursement__c = 'Yes';
          feesList.Instrument_type__c = 'Deduct from Disb';
          feesList.Status__c ='To be collected';
          feesL.add(feesList);
        }
      }
      upsert feesL;
    } */
    //commented for 977 stop
}
}
  //977 start
    public static String updateFees(String loanId){
        crossSellAmt = 0;
        CallChargesAPI(loanId);
        Account accObj = new Account();
        Opportunity loan = new Opportunity();
        Applicant__c primApp = new Applicant__c();
        
        List<Opportunity> oppList = [SELECT Full_Underwriting__c,Account.id,Account.FeesChargeTotal__c,Account.Preferred_language__c,Account.PinCode__c,Sourcing_Channel__r.Channel_Category__c,/*23820 E*//*20391 Added Sent_TO_Finnone*/Sent_To_Finnone__c,PAN_Number__c,/*22307*/Consider_for_Re_Appraisal__c,POS__c,CUSTOMER__c,/*Bug id 20939 RCU start*/Loan_Amount_with_Premium__c,Account.DesignationOTP__c,Customer__r.Name,CUSTOMER__r.PAN_Demog__c,CUSTOMER__r.Mobile_Demog__c,CUSTOMER__r.DOB_Demog__c,CUSTOMER__r.Bank_account_number_demog__c,CUSTOMER__r.Residence_demog__c,CUSTOMER__r.Last_Modified_date_Demog__c,Existing_Customer__c, Link_Offer_id__c,Account.Offer_Inhanced__c,/*Bug id 20939 end*/Created_Time__c, /*Pricing*/Area_SM__c, /*Pricing*/IFSC_Code__c ,A_C_No__c, Mode_of_Disbursal__c, Bank_Name__c, Account_Holder_Name__c, Favouring__c,MICR_Number__c ,Repayment_Account_Holder_Name__c, Bank_A_c_No_of_Customer__c, Repayment_Bank_Name__c, Repayment_Mode__c, First_Due_Date__c,  A_C_Type__c, Account.Flow__c,Relationship_Manager__c,Tenor__c,Approved_Rate__c,EMI_CAM__c,Requested_ROI__c,Sourcing_Channel__r.Id,Sourcing_Channel__r.Reporting_Manager__c,id,Industry__r.Industry__c,Offer_Amount__c,Reject_Reason__c,Name,StageName,Telecaller_Name__c,Customer_Type__c, Product__c,Main_Sub_Industry__c,Branch_Name__c,Branch_Name__r.SAL_Branch_Type__c, LAN__c, AccountId, Quality_Check_Status__c, Sourcing_Channel__c, Sourcing_Channel__r.Name, Referral__c, Referral__r.Name, Application_Source__c, Loan_Application_Number__c,Type_Of_Loan__c,COO_Comments__c,Approved_Loan_Amount__c,Scheme_Master__r.Scheme_Code__c, Due_Day__c ,Scheme_Master__r.Name,Scheme_Master__r.IsHybridFlexi__c,Approved_Tenor__c,Processing_Fees__c,Branch_Name__r.name,(select id from Product_Offerings__r),(select Month1__c,Month2__c,Month3__c, id,LAP_EMI__c,EMI_on_Proposed_Loan_TO__c,Avg_qtrly_incentive__c,Average_incentive_for_Q1__c,Average_incentive_for_Q3__c,Average_incentive_for_Q2__c,Maxi_EMI_Cust__c,Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c,Average_Monthly_Net_Income1__c,Applicable_FOIR1__c,Loan_Application__c,EMI_of_The_Loan__c,Receips5_Doc__c,Receips6_Doc__c,Unsecured_FOIR__c,Eligible_FOIR__c,Total_Mthly_Oblig__c,EMI__c,ROI__c,sal_max_loan__c,Net_Salary_for_Month1__c,Net_Salary_for_Month2__c,Net_Salary_for_Month3__c,Proposed_Loan_Amt__c,Tenor__c,Eligible_Loan__c,Monthly_Reimbursement__c,Avg_mthly_incntve_3mts__c,Rental_Income__c,Receips4_Doc__c,Existing_HL_EMI__c,Month1_Doc__c,Month2_Doc__c,Month3_Doc__c,LAP_pmt__c,Avg_monthly_incentive1__c,Avg_monthly_incentive2__c,Avg_monthly_incentive3__c,Incentive_Monthly_or_Quarterly__c /*24997 s*/,Gross_Salary_Month1__c,Gross_Salary_Month2__c,Gross_Salary_Month3__c/*24997 e*/ from CAMs__r),
                                     /*Bug 20939 s*/(select id,name,RetriggerBRE__c,Policy_Name__c,/*Added for 22018 s*/Old_Address_Value__c,Applicant_Name__r.Contact_Name__r.Name,New_Address_Value__c,/*Added for 22018 e*/Add_on_Holder_DOB__c,Add_on_Holder_Email__c,Add_on_Holder_First_Name__c,Add_on_Holder_Last_Name__c,Add_on_Holder_Middle_Name__c,Add_on_holder_Mobile__c,Add_on_Holder_Relation__c,Applicant_Name__c,Charge_Type__c,Remarks__c,Disposition_Status__c,Checklist_Policy_Status__c,Policy_Status__c /*24673 s*/,Agreement_URL__c ,Challan_URL__c,Index_File_URL__c,Branch_Name__c,Bank_Name__c,Cheque_Transaction_Date__c,Cheque_Transaction_Number__c,Refundable_Deposit_Amount__c,Agreement_End_Date__c,Agreement_Start_Date__c,Agreement_Type__c,Approx_Built_Up_Area__c,Landlord_Email_Id__c,Landlord_DOB__c,Landlord_Gender__c,Property_Address__c,Landlord_Mobile__c,Landlord_PAN__c,Landlord_First_Name__c,Landlord_Last_Name__c,Landlord_Middle_Name__c,Variable_Rent__c,Salutation__c,Rent__c,Deposit_By__c,Landlord_Address__c,Landlord_City__c,Landlord_Pincode__c,accessories__c,property__c /*24673 e*/from SOL_Policys__r),/*Bug 20939 e*/
                                     (select Final_EMI__c,Status__c,Obligation__c,Financers__c,Loan_Type__c,POS__c,EMI__c from Existing_Loan_Details__r),
                                     (select /*20939 s*/Existing_cust_demog_change__c,Demog_change_action__c,/*20939 e*/ Customer_Status__c,Dedupe_Source__c,Source_Or_Target__c from De_Dupes__r limit 10),
                                     (select Salary_Credit_Date1__c,Salary_Credit_Date2__c,Salary_Credit_Date3__c,Perfios_inwardChqBounces__c,Perfios_inwardECSBounces__c,Perfios_Bank_Name__c from Bank_Account__r),
                                     (select /*20391 Added IMPS_Transaction_No__c,IMPS_Account_Validate__c*/IMPS_Transaction_No__c,IMPS_Account_Validate__c,id,IMPS_Count__c,UMRN__c,Disbursement_To__c, IMPS_Flag__c, Bank_Branch__c, name, Tranche_Detail__c, Loan_Application__c, Internal_Closure__c, Disbursement_Amount__c, Disbursal_Mode__c, Disbursement_Date__c,
                                      FinnOne_Disbursement_Date__c,Repay_Disb_Diff__c,Successful_IMPS_Count__c,Failure_IMPS_Count__c ,IFSC_Code__c, Favouring__c,isTopUp__c,Tranche_Detail__r.Tranche_Number__c, Bank_Name__c, Bank_Account__c, Payable_at__c, Credit_Days__c, IMPS_Result__c
                                      from Current_Disbursal_Details_s__r),
                                     (select id,Question1__c,Question2__c,Question3__c,Question4__c,Question5__c,Question6__c,Question7__c,Question8__c,Question9__c,Question10__c,Question11__c,Question12__c,Question13__c,Question14__c,Question15__c,Question16__c,Question17__c,Question18__c,Question19__c,Question20__c,Question21__c,Question22__c,Question23__c,Question24__c,Question25__c,Question26__c,Question27__c,Question28__c,Question29__c,Question30__c,
                                      /*added for RSL Mobility bug 22018 s*/Question31__c,Question32__c,Question33__c,Question34__c,Question35__c,Question36__c,Question37__c,Question38__c,Question39__c,Question40__c,Question41__c,/*added for RSL Mobility bug 22018 e*/ 
                                      Type_of_PD__c,Tele_PD_Applicability__c,Name_of_the_applicant__c,PD_Conducted__c, PD_Ok__c,CO_comment__c from Personal_Discussion_s__r),
                                     (SELECT Id,/*22107 s*/Copy_Perfios_Details__c/* 22107 end*/, A_C_type__c,ECS_Barcode_No__c,Open_ECS_Facility__c, Open_ECS_Ex_Customer_Id__c, Open_Valid_till__c, Open_ECS_Max_Limit__c, ECS_Start_Date__c, ECS_End_Date__c, ECS_Amount__c, name, Loan_Application__c, A_C_NO__c, MICR_Code__c, PDC_START_DATE__c, IFSC_Code__c, Account_Holder_Name__c,Bank_Name__c, No_of_Cheques__c, Cheque_Serial_Number__c, Repayment_Mode__c, To_Cheque_Serial_Number__c, Cheque_Amount__c, Tranche_Detail__c, Bank_Branch__c, PDC_By_Name__c ,Loan_Application__r.CUSTOMER__c  ,Mandate_Process_Stage__c,UMRN__c FROM RePayment_mode_details__r),
                                     (select /*20939 RCU s*/RSA_Reason__c ,Initiated_by_invisible_monitoring__c, /*20939 RCU e*/id, name, Status__c, Verification_Type__c,Credit_Status__c,Geo_Tagging__c,Image_Latitude_Longitude_Details__c from Verification__r),Scheme_Master__c,(select id,Applicant_Type__c,Pure_Flexi_Period__c,Pure_Flexi_EMI__c,Drop_Line_Flexi_Period__c from Loan_Application__r where Applicant_Type__c = 'Primary' limit 1),(select id, name, Finnone_ChargeId__c, Charge_Desc__c, Tranche_Detail__r.name, Deposition_Date__c, Deposit_Slip_Number__c, Loan_Application__r.name, Change_Amount__c, Charge_Type__c, Deducted_from_Disbursement__c,Service_Charge__c, Status__c, Tranche_Detail__c, Instrument_Date__c, Instrument_No__c, Bank_Branch__c, Instrument_type__c, Amount_after_Service_Change__c, Tranche_Detail__r.Tranche_Number__c from Fees_and_Charges__r where Identifier__c != 'Mortgage')
                                     from Opportunity where id = : loanId];
        
        if(!CommonUtility.isEmpty(oppList)){
            loan = oppList.get(0);
          accObj.Id = loan.Account.Id;
        }
        
        List<Fees_and_Charge__c> Fees = new  List<Fees_and_Charge__c>();
        if(loan!=null){
            for(Fees_and_Charge__c fee:[select id, name, Finnone_ChargeId__c, Charge_Desc__c, Tranche_Detail__r.name, Deposition_Date__c, Deposit_Slip_Number__c, Loan_Application__r.name, Change_Amount__c, Charge_Type__c, Deducted_from_Disbursement__c,Service_Charge__c, Status__c, Tranche_Detail__c, Instrument_Date__c, Instrument_No__c, Bank_Branch__c, Instrument_type__c, Amount_after_Service_Change__c, Tranche_Detail__r.Tranche_Number__c from Fees_and_Charge__c where Identifier__c != 'Mortgage' AND Loan_Application__c = :loan.id ]){
                Fees.add(fee);
            }
        }
        
        
        
        Map<String,Object> statMap = GeneralUtilities.fetchStaticRescMap();
        List<String> crossSellList = new List<String>();
        if(statMap != null){
            String crossCellStr = (String)statMap.get('CrossSellCharges');
            crossSellList = crossCellStr.split(';');
        }
        system.debug('crossSellList::'+crossSellList);
        
        List<Fees_and_Charge__c> feesL = new List<Fees_and_Charge__c>();
        for(Fees_and_Charge__c feesList : Fees)
        {
            if(feesList.Change_Amount__c > 0)
            {
                system.debug('hello1::'+feesList.Change_Amount__c);
                feesList.Deducted_from_Disbursement__c = 'Yes';
                feesList.Instrument_type__c = 'Deduct from Disb';
                feesList.Status__c ='To be collected';
                
                system.debug('in if fees1::'+String.valueOf(feesList.Finnone_ChargeId__c));
                if(crossSellList.contains(String.valueOf(feesList.Finnone_ChargeId__c))){
                    system.debug('in if crossSellAmt::'+crossSellAmt+' amt::'+feesList.Change_Amount__c);
                    crossSellAmt = crossSellAmt + feesList.Change_Amount__c;
                } 
                
                feesL.add(feesList);
            }
        }
        upsert feesL;
        
    
        if(!CommonUtility.isEmpty(loan) && loan.Loan_Application__r != null && loan.Loan_Application__r.size() > 0){
            primApp = loan.Loan_Application__r[0];
            loan = oppList.get(0);
        }
           accObj.FeesChargeTotal__c = crossSellAmt;
           upsert accObj;
        //loan.Approved_Loan_Amount__c = loan.Approved_Loan_Amount__c + crossSellAmt;
        //upsert loan;
        loan = [SELECT Full_Underwriting__c,Account.Preferred_language__c,Account.PinCode__c,Sourcing_Channel__r.Channel_Category__c,/*23820 E*//*20391 Added Sent_TO_Finnone*/Sent_To_Finnone__c,PAN_Number__c,/*22307*/Consider_for_Re_Appraisal__c,POS__c,CUSTOMER__c,/*Bug id 20939 RCU start*/Loan_Amount_with_Premium__c,Account.DesignationOTP__c,Customer__r.Name,CUSTOMER__r.PAN_Demog__c,CUSTOMER__r.Mobile_Demog__c,CUSTOMER__r.DOB_Demog__c,CUSTOMER__r.Bank_account_number_demog__c,CUSTOMER__r.Residence_demog__c,CUSTOMER__r.Last_Modified_date_Demog__c,Existing_Customer__c, Link_Offer_id__c,Account.Offer_Inhanced__c,/*Bug id 20939 end*/Created_Time__c, /*Pricing*/Area_SM__c, /*Pricing*/IFSC_Code__c ,A_C_No__c, Mode_of_Disbursal__c, Bank_Name__c, Account_Holder_Name__c, Favouring__c,MICR_Number__c ,Repayment_Account_Holder_Name__c, Bank_A_c_No_of_Customer__c, Repayment_Bank_Name__c, Repayment_Mode__c, First_Due_Date__c,  A_C_Type__c, Account.Flow__c,Relationship_Manager__c,Tenor__c,Approved_Rate__c,EMI_CAM__c,Requested_ROI__c,Sourcing_Channel__r.Id,Sourcing_Channel__r.Reporting_Manager__c,id,Industry__r.Industry__c,Offer_Amount__c,Reject_Reason__c,Name,StageName,Telecaller_Name__c,Customer_Type__c, Product__c,Main_Sub_Industry__c,Branch_Name__c,Branch_Name__r.SAL_Branch_Type__c, LAN__c, AccountId, Quality_Check_Status__c, Sourcing_Channel__c, Sourcing_Channel__r.Name, Referral__c, Referral__r.Name, Application_Source__c, Loan_Application_Number__c,Type_Of_Loan__c,COO_Comments__c,Approved_Loan_Amount__c, 
                Scheme_Master__r.Scheme_Code__c, Due_Day__c ,Scheme_Master__r.Name,Scheme_Master__r.IsHybridFlexi__c,Approved_Tenor__c,Processing_Fees__c,Branch_Name__r.name,
                (select id from Product_Offerings__r),
                (select Month1__c,Month2__c,Month3__c, id,LAP_EMI__c,EMI_on_Proposed_Loan_TO__c,Avg_qtrly_incentive__c,Average_incentive_for_Q1__c,Average_incentive_for_Q3__c,Average_incentive_for_Q2__c,Maxi_EMI_Cust__c,Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c,Average_Monthly_Net_Income1__c,Applicable_FOIR1__c,Loan_Application__c,EMI_of_The_Loan__c,Receips5_Doc__c,Receips6_Doc__c,Unsecured_FOIR__c,Eligible_FOIR__c,Total_Mthly_Oblig__c,EMI__c,ROI__c,sal_max_loan__c,Net_Salary_for_Month1__c,Net_Salary_for_Month2__c,Net_Salary_for_Month3__c,Proposed_Loan_Amt__c,Tenor__c,Eligible_Loan__c,Monthly_Reimbursement__c,Avg_mthly_incntve_3mts__c,Rental_Income__c,Receips4_Doc__c,Existing_HL_EMI__c,Month1_Doc__c,Month2_Doc__c,Month3_Doc__c,LAP_pmt__c,Avg_monthly_incentive1__c,Avg_monthly_incentive2__c,Avg_monthly_incentive3__c,Incentive_Monthly_or_Quarterly__c 
                 /*24997 s*/,Gross_Salary_Month1__c,Gross_Salary_Month2__c,Gross_Salary_Month3__c/*24997 e*/ from CAMs__r),
                /*Bug 20939 s*/(select id,name,RetriggerBRE__c,Policy_Name__c,/*Added for 22018 s*/Old_Address_Value__c,Applicant_Name__r.Contact_Name__r.Name,New_Address_Value__c,/*Added for 22018 e*/Add_on_Holder_DOB__c,Add_on_Holder_Email__c,Add_on_Holder_First_Name__c,Add_on_Holder_Last_Name__c,Add_on_Holder_Middle_Name__c,Add_on_holder_Mobile__c,Add_on_Holder_Relation__c,Applicant_Name__c,Charge_Type__c,Remarks__c,Disposition_Status__c,Checklist_Policy_Status__c,Policy_Status__c /*24673 s*/,Agreement_URL__c ,Challan_URL__c,Index_File_URL__c,Branch_Name__c,Bank_Name__c,Cheque_Transaction_Date__c,Cheque_Transaction_Number__c,Refundable_Deposit_Amount__c,Agreement_End_Date__c,Agreement_Start_Date__c,Agreement_Type__c,Approx_Built_Up_Area__c,Landlord_Email_Id__c,Landlord_DOB__c,Landlord_Gender__c,Property_Address__c,Landlord_Mobile__c,Landlord_PAN__c,Landlord_First_Name__c,Landlord_Last_Name__c,Landlord_Middle_Name__c,Variable_Rent__c,Salutation__c,Rent__c,Deposit_By__c,accessories__c,property__c ,Landlord_Address__c,Landlord_City__c,Landlord_Pincode__c/*24673 e*/ from SOL_Policys__r),/*Bug 20939 e*/
                (select Final_EMI__c,Status__c,Obligation__c,Financers__c,Loan_Type__c,POS__c,EMI__c from Existing_Loan_Details__r),
                (select /*20939 s*/Existing_cust_demog_change__c,Demog_change_action__c,/*20939 e*/ Customer_Status__c,Dedupe_Source__c,Source_Or_Target__c from De_Dupes__r limit 10),
                (select Salary_Credit_Date1__c,Salary_Credit_Date2__c,Salary_Credit_Date3__c,Perfios_inwardChqBounces__c,Perfios_inwardECSBounces__c,Perfios_Bank_Name__c from Bank_Account__r),
                (select /*20391 Added IMPS_Transaction_No__c,IMPS_Account_Validate__c*/IMPS_Transaction_No__c,IMPS_Account_Validate__c,id,IMPS_Count__c,UMRN__c,Disbursement_To__c, IMPS_Flag__c, Bank_Branch__c, name, Tranche_Detail__c, Loan_Application__c, Internal_Closure__c, Disbursement_Amount__c, Disbursal_Mode__c, Disbursement_Date__c,
                 FinnOne_Disbursement_Date__c,Repay_Disb_Diff__c,Successful_IMPS_Count__c,Failure_IMPS_Count__c ,IFSC_Code__c, Favouring__c,isTopUp__c,Tranche_Detail__r.Tranche_Number__c, Bank_Name__c, Bank_Account__c, Payable_at__c, Credit_Days__c, IMPS_Result__c
                 from Current_Disbursal_Details_s__r),
                (select id,Question1__c,Question2__c,Question3__c,Question4__c,Question5__c,Question6__c,Question7__c,Question8__c,Question9__c,Question10__c,Question11__c,Question12__c,Question13__c,Question14__c,Question15__c,Question16__c,Question17__c,Question18__c,Question19__c,Question20__c,Question21__c,Question22__c,Question23__c,Question24__c,Question25__c,Question26__c,Question27__c,Question28__c,Question29__c,Question30__c,
                 /*added for RSL Mobility bug 22018 s*/Question31__c,Question32__c,Question33__c,Question34__c,Question35__c,Question36__c,Question37__c,Question38__c,Question39__c,Question40__c,Question41__c,/*added for RSL Mobility bug 22018 e*/ 
                 Type_of_PD__c,Tele_PD_Applicability__c,Name_of_the_applicant__c,PD_Conducted__c, PD_Ok__c,CO_comment__c from Personal_Discussion_s__r),
                (SELECT Id,/*22107 s*/Copy_Perfios_Details__c/* 22107 end*/, A_C_type__c,ECS_Barcode_No__c,Open_ECS_Facility__c, Open_ECS_Ex_Customer_Id__c, Open_Valid_till__c, Open_ECS_Max_Limit__c, ECS_Start_Date__c, ECS_End_Date__c, ECS_Amount__c, name, Loan_Application__c, A_C_NO__c, MICR_Code__c, PDC_START_DATE__c, IFSC_Code__c, Account_Holder_Name__c,Bank_Name__c, No_of_Cheques__c, Cheque_Serial_Number__c, Repayment_Mode__c, To_Cheque_Serial_Number__c, Cheque_Amount__c, Tranche_Detail__c, Bank_Branch__c, PDC_By_Name__c ,Loan_Application__r.CUSTOMER__c  ,Mandate_Process_Stage__c,UMRN__c FROM RePayment_mode_details__r),
                (select /*20939 RCU s*/RSA_Reason__c ,Initiated_by_invisible_monitoring__c, /*20939 RCU e*/id, name, Status__c, Verification_Type__c,Credit_Status__c,Geo_Tagging__c,Image_Latitude_Longitude_Details__c from Verification__r),Scheme_Master__c,(select id,Applicant_Type__c,Pure_Flexi_Period__c,Pure_Flexi_EMI__c,Drop_Line_Flexi_Period__c from Loan_Application__r where Applicant_Type__c = 'Primary' limit 1),(select id, name, Finnone_ChargeId__c, Charge_Desc__c, Tranche_Detail__r.name, Deposition_Date__c, Deposit_Slip_Number__c, Loan_Application__r.name, Change_Amount__c, Charge_Type__c, Deducted_from_Disbursement__c,Service_Charge__c, Status__c, Tranche_Detail__c, Instrument_Date__c, Instrument_No__c, Bank_Branch__c, Instrument_type__c, Amount_after_Service_Change__c, Tranche_Detail__r.Tranche_Number__c from Fees_and_Charges__r where Identifier__c != 'Mortgage')
                from Opportunity where id = : loanId];
        system.debug('approved loanamt after upsert::'+loan.Approved_Loan_Amount__c );
        String emiStr = SAL_PricingCtrlV2.calculateEMIValue(loan,primApp);
        system.debug('loan is::'+loan);
        system.debug('primApp is::'+primApp);
        system.debug('emiStr is::'+emiStr);
        
        loan.EMI_CAM__c = Decimal.valueof(emiStr);
        system.debug('emi is::'+loan.EMI_CAM__c);
        upsert loan;
        return JSON.serialize(loan);
    } 
    //977 stop
//for pricing dashboard
public static String getUploadVerification(String AppId){ //DMS AppId added by swapnil 24317
    
    List<ContentVersion> docs = new List<ContentVersion>();
    List<ContentDocumentLink> docList = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: AppId]; //DMS AppId added by swapnil 24317
    List<id> docListId = new List<Id>();
    for(ContentDocumentLink cl : docList)
    {
        docListId.add(cl.ContentDocumentId);
    }
    docs = [SELECT Title FROM ContentVersion where ContentDocumentId IN: docListId];
    
    return JSON.serialize(docs);
}

public static void acceptOffer(String oppId){
    
    system.debug('in pricing controller');
    MAP < String, String > mapofheader = new MAP < String, String > ();
    String ReturnValue ='';
    List<Applicant__c> appList = [Select IP_Address_Timestamp__c from Applicant__c where Loan_Application__c =: oppId AND Applicant_Type__c = 'Primary' Limit 1];
    system.debug(ApexPages.currentPage());
    if(!CommonUtility.isEmpty(ApexPages.currentPage())){
        mapofheader = ApexPages.currentPage().getHeaders();
        ReturnValue = ApexPages.currentPage().getHeaders().get('True-Client-IP');
        system.debug('True-Client-IP'+ReturnValue);
        
        if (ReturnValue == '' || ReturnValue == null) {
            ReturnValue = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        } // get IP address when no caching (sandbox, dev, secure urls)
        
        if (ReturnValue == '' || ReturnValue == null) {
            ReturnValue = ApexPages.currentPage().getHeaders().get('X-Forwarded-For');
        } // get IP address from standard header if proxy in use
    }
    
    
    Applicant__c app = appList[0];
    // X-Salesforce-SIP has the value when no caching integration or via secure URL.
    
    system.debug('USER IP ADDRESS: ' + mapofheader);
    system.debug('ReturnValue  : ' + ReturnValue);
    
    String timestamp = String.valueof(datetime.now());
    //datetime myDateTime = datetime.now();
    //string timestamp= mydatetime.format();
    String Ip_time = ReturnValue+' || '+timestamp;
    System.debug('Ip**'+Ip_time);
    app.IP_Address_Timestamp__c = Ip_time+' || '+'Manually Uploaded';
    update app;
    //SALMobilityPricingCntrl_V2.sendmailTocustomer(oppId.id);
    
}

/*  @future(callout=true)
public static void sendmailTocustomer( ID LoanID)
{
system.debug('inside sendmail method');
Opportunity  loan= [Select id,Account.Current_Email_Id__c,product__c,Loan_Application_Number__c,Sourcing_channel_email_id__c,Customer_email_id__c,Accountant_email_id__c,Relationship_Manager__r.Email from Opportunity where Id = :LoanID];
Applicant__c  app = [Select Id,IP_Address_Timestamp__c,Contact_Name__r.Office_Email_Id__c from Applicant__c where Loan_Application__c =: loan.id AND Applicant_Type__c = 'Primary' limit 1];  
system.debug('Sending mail inside');
List < String > toAddlist = new List < String > ();
List < String > toAddlistCC = new List < String > ();
if (loan.Account.Current_Email_Id__c != null) {
toAddlist.add(Loan.Account.Current_Email_Id__c);
}
if (Loan.Sourcing_channel_email_id__c != null) {
toAddlist.add(Loan.Sourcing_channel_email_id__c);
}
if (app!= null && app.Contact_Name__r.Office_Email_Id__c != null) {
toAddlist.add(app.Contact_Name__r.Office_Email_Id__c);
}
if (loan.Customer_email_id__c != null)
toAddlist.add(loan.Customer_email_id__c);
if (loan.Accountant_email_id__c != null)
toAddlist.add(loan.Accountant_email_id__c);
if (loan.Relationship_Manager__r != null && loan.Relationship_Manager__r.Email != null){
toAddlistCC.add(loan.Relationship_Manager__r.Email);
System.debug('loan.Relationship_Manager__r.Email' + loan.Relationship_Manager__r.Email);
}

system.debug('Size of address list : '+toAddlist.size());

if (toAddlist.size() > 0) {

String[] toAdd = toAddlist;
//toAddlistCC.add('prashant_kumar@persistent.com');
String[] ccArray = toAddlistCC;
String[] bccArray;

String subject = 'Pricing Details LAN No: ' + loan.Loan_Application_Number__c;
String[] SubWords = subject.split(' ');

String replyTo = Label.Pricing_Attchment_Email;

String fromEmail;
if(Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL'){
fromEmail = 'spl.mailconfirmation@bajajfinserv.in';
} else {
fromEmail = 'noreply@bajajfinserv.in';
}
String Body = 'Thank you for showing Interest in Bajaj Finserv . Your Request will be processed shortly.';

BAFL_EmailServicesLogix.Attachment[] arrAttachment = new List < BAFL_EmailServicesLogix.Attachment > ();
List<ContentDocument> cd = [SELECT id FROM ContentDocument WHERE ParentId =: LoanID AND Title LIKE 'Customer consent on e-Agreement.%' LIMIT 1]; 
ContentDocument cdoc = cd[0];
// PageReference pdf = new PageReference(Label.bflsiteuserURL+'/PLTBTermsAndConditions');
// pdf.getParameters().put('LoanId', (String) loan.id);
// pdf.getParameters().put('renderFor','pdf');

//pdf.setRedirect(true);
//Blob blobePltbAgree;
// Take the PDF content
// if (test.isrunningtest())
// blobePltbAgree = Blob.valueOf('Test');
// else    //pdf.getContent();
// blobePltbAgree = cdoc.getContent();

// Create Welcome Letter email attachment
BAFL_EmailServicesLogix.Attachment ePltbAgree = new BAFL_EmailServicesLogix.Attachment();
ePltbAgree.Name = 'Sal PLTB Terms and Conditions.pdf';
String strePltbAgree = EncodingUtil.base64Encode(cdoc);
ePltbAgree.Data = strePltbAgree ;
arrAttachment.add(ePltbAgree);

system.debug('arrAttachment  prashant--->>>' + arrAttachment);
BAFL_EmailServicesLogix.EmailServicesPort stub = new BAFL_EmailServicesLogix.EmailServicesPort();
BAFL_EmailServicesLogix.SendEmailResponse er = stub.SendEmail(fromEmail,
replyTo,
toAdd,
ccArray,
bccArray,
'Normal',
arrAttachment,
subject,
body,
'bajaj');
}
system.debug('mail sent'); 
} 
*/
public class sendMailImplementation implements Queueable,database.Allowscallouts {
    private Id oppId;
    Decimal propROI;
    Decimal propPf;
    String designation;
    String salesOfficerEmail;
    Id solId;
    String templatename;
    boolean flag;
    public sendMailImplementation(Id oppId,Decimal propROI,Decimal propPf,String designation,String salesOfficerEmail,Id solId,String templatename,boolean flag) {
        this.oppId = oppId;
        this.propROI = propROI;
        this.propPf = propPf;
        this.designation = designation;
        this.salesOfficerEmail = salesOfficerEmail;
        this.solId = solId;
        this.templatename = templatename;
        this.flag= flag;
    }
    
    public void execute(QueueableContext context) {
        try{
        Decimal denom = 0;
        String propPfStr;
        String propROIStr;
        String CPP = 'N';
        String FFR = 'N';
        String subject = 'Heirarchy Approval for ';
        String[] bccArray ;
        Decimal CPPpercentage = 0;
        Decimal SumofPremiumAmountHI = 0;
        Decimal SumofPremiumAmountLI = 0;
        Decimal SumofPremiumAmountGI = 0;
        Decimal LIpercentage = 0;
        Decimal HIpercentage = 0;
        String body='';
        if(propPF != null)
            subject = subject + 'PF';
        if(propROI != null)
            subject = subject + ' ROI';
        System.debug('propPF value is = '+propPf);
        System.debug('propROI value is = '+propROI);
        Opportunity oppObj = new Opportunity();
        Sales_Officer_Limit__c saleslimit=new Sales_Officer_Limit__c();
        Applicant__c applicant=new Applicant__c();
        //String username=UserInfo.getName();
        List<EmailTemplate> emailTemp = [SELECT Id,HTMLValue,Body,Name from EmailTemplate where Name =:templatename ];
//1652 Insurance_Premium_Amt__c added       
    List<Opportunity> Loan_Application = [SELECT Insurance_Premium_Amt__c,Product__c,Name,Sourcing_channel_email_id__c,Relationship_Manager__c ,Branch_Name__r.Name,Loan_Application_Number__c, Loan_Amount_with_Premium__c,Approved_Tenor__c,Approved_Rate__c,Processing_Fees__c,Scheme_Master__r.Name,Scheme_Master__r.IsHybridFlexi__c,Relationship_Manager__r.Name ,Net_Loan_to_POS__c
                                              from Opportunity where id = : oppId];
             if(Loan_Application != null && Loan_Application.size() > 0)
            oppObj = Loan_Application[0];                                 
           //1652 emi_card__c added    
        List<Applicant__c> primaryApplicant = [Select emi_card__c,Contact_Name__r.Employer__r.Name,Employer__c,Contact_Name__c,Company_Type__c,Risk_Segmentation__c,Financial_Health_Check_Guide__c,Subscribed_to_Credit_Vidya__c from Applicant__c where Loan_Application__c =: oppId AND Applicant_Type__c =: 'Primary' Limit 1];
        if(primaryApplicant != null && primaryApplicant.size() > 0)
            applicant = primaryApplicant[0];
                
        
        List<Sales_Officer_Limit__c> salesOfficerLimitList = [Select /*20939 s*/Designation__c,Sales_Officer_Name__r.Mobile_number__c,/*20939 e*/FFR_Penetration__c,Weighted_Avg_PF_Curr_Month__c,Weighted_Avg_IRR_CurrMonth__c,CPP_Percent__c,Sales_Officer_Name__r.Name,WIRR__c,WPF__c,LI_Percent__c,HI_Percent__c,FFR_Percent__c from Sales_Officer_Limit__c where Id =: solId Limit 1] ;
         if(salesOfficerLimitList != null && salesOfficerLimitList.size() > 0)
            saleslimit = salesOfficerLimitList[0];
        List<DPLinsurance__c> insuranceList = [Select Premium_Amount__c,Insurance_Type__c,Type_of_insurance__c,Insurance_Product__c from DPLinsurance__c where Opportunity__c =: oppId];
        List<DPLinsurance__c> CPPSoldCasesList = new List<DPLinsurance__c>();
        if(!commonutility.isEmpty(insuranceList))
        {
            for(DPLinsurance__c insurance : insuranceList){
                if(insurance.insurance_Type__c == 'CPP' && insurance.Insurance_Product__c == 'Wallet Product' && insurance.Premium_Amount__c != null){
                    CPP = 'Y';
                    CPPSoldCasesList.add(insurance);
                }
                if(insurance.Type_of_insurance__c == 'Life Insurance')
                {
                    if(!commonutility.isEmpty(insurance.premium_amount__c))
                        SumofPremiumAmountLI += Decimal.valueOf(insurance.premium_amount__c); 
                }
                if(insurance.Type_of_insurance__c == 'General Insurance') 
                {
                    if(insurance.Insurance_type__c != 'CPP' && insurance.Insurance_type__c != 'Wallet Protect')
                    {
                        if(!commonutility.isEmpty(insurance.premium_amount__c))
                            SumofPremiumAmountHI += Decimal.valueOf(insurance.premium_amount__c);
                    }
                    
                    if(!commonutility.isEmpty(insurance.premium_amount__c))
                        SumofPremiumAmountGI += Decimal.valueOf(insurance.premium_amount__c);
                }
                
            }
        }
        if(!commonutility.isEmpty(Loan_Application[0].Net_Loan_to_POS__c) && !commonutility.isEmpty(SumofPremiumAmountLI) && !commonutility.isEmpty(SumofPremiumAmountGI)){
            denom = Loan_Application[0].Net_Loan_to_POS__c - (SumofPremiumAmountLI+SumofPremiumAmountGI);
        }
        if(!commonutility.isEmpty(SumofPremiumAmountLI) && !commonutility.isEmpty(SumofPremiumAmountGI) && denom !=0){
            LIpercentage = SumofPremiumAmountLI / denom;
            LIpercentage = LIpercentage+0.0;
            LIpercentage=LIpercentage.setscale(3);
            HIpercentage = SumofPremiumAmountHI / denom;
            HIpercentage = HIpercentage +0.0;
            HIpercentage=HIpercentage.setscale(3);
        }
        
        
        
        if(!commonutility.isEmpty(primaryApplicant)){
            if(primaryApplicant[0].Financial_Health_Check_Guide__c && primaryApplicant[0].Subscribed_to_Credit_Vidya__c){
                FFR = 'Y';
            }
        }
        
         List < String > toAddlist = new List < String > ();
        if(flag)
        {
          toAddlist.add(salesOfficerEmail);
        }else{
         toAddlist.add(UserInfo.getUserEmail());
         toAddlist.add(oppObj.Sourcing_channel_email_id__c);
        }
       
             
        
            
          System.debug('toAddlist :'+toAddlist);
        
   /*     
        List < String > toAddlist = new List < String > ();
        toAddlist.add(salesOfficerEmail);     
   */     
        List < String > ccArray = new List < String > ();
        //ccArray.add(UserInfo.getUserEmail());
        if(propPf != null){
            propPfStr=proppf.toPlainString();
        }
        else
            propPfStr='-';
        if(propROI != null){
            propROIStr=propROI.toPlainString();
        }
        else
            propROIStr='-';
        
        if(salesOfficerLimitList[0].WIRR__c == null)
            salesOfficerLimitList[0].WIRR__c=0;
        if(salesOfficerLimitList[0].WPF__c == null)
            salesOfficerLimitList[0].WPF__c=0;
        if(salesOfficerLimitList[0].LI_Percent__c == null)
            salesOfficerLimitList[0].LI_Percent__c=0;
        if(salesOfficerLimitList[0].HI_Percent__c == null)
            salesOfficerLimitList[0].HI_Percent__c=0;
        if(salesOfficerLimitList[0].FFR_Percent__c == null)
            salesOfficerLimitList[0].FFR_Percent__c=0;
        if(primaryApplicant[0].Company_Type__c == null)
            primaryApplicant[0].Company_Type__c=' ';
        if(primaryApplicant[0].Risk_Segmentation__c == null)
            primaryApplicant[0].Risk_Segmentation__c=' ';
        if(salesOfficerLimitList[0].CPP_Percent__c == null)
            salesOfficerLimitList[0].CPP_Percent__c=0;
        if(salesOfficerLimitList[0].FFR_Penetration__c == null)
            salesOfficerLimitList[0].FFR_Penetration__c = 0;
        if(salesOfficerLimitList[0].Weighted_Avg_IRR_CurrMonth__c == null)
            salesOfficerLimitList[0].Weighted_Avg_IRR_CurrMonth__c = 0;
        if(salesOfficerLimitList[0].Weighted_Avg_PF_Curr_Month__c == null)
            salesOfficerLimitList[0].Weighted_Avg_PF_Curr_Month__c = 0;
      
        system.debug('body ' + body);
        //Rate Approval start
        String email_from = 'SPL_Commercialconsent@bajajfinserv.in';
        //new changes start 
        Messaging.SingleEmailMessage[] previewEmails = new Messaging.SingleEmailMessage[]{};
        String mailBody;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();    
        system.debug('Inside new SendEmailUsingBAFLLogix() template id is --> ' + emailTemp[0].id);
       
        if(emailTemp != null && emailTemp.size() > 0 && oppId != null){      
        try
        {
            system.debug('Inside new SendEmailUsingBAFLLogix() template id is 2 --> ' + emailTemp[0].id);
            mail.setToAddresses(toAddlist);
            mail.setTargetObjectId(applicant.Contact_Name__c);
            mail.setTemplateId(emailTemp[0].id);
            mail.setReplyTo('noreply@bajajfinserv.in');
            mail.setWhatId(oppId);
            mail.setsaveAsActivity(false);
            mail.setTreatTargetObjectAsRecipient(false);
            previewEmails.add(mail);
            Messaging.SingleEmailMessage secondPreviewEmail = new Messaging.SingleEmailMessage();
            previewEmails.add(secondPreviewEmail);
            List<Messaging.SendEmailResult> previewResult = Messaging.sendEmail(previewEmails);
        }
        catch(Exception e)
        {
          
            System.debug('****Exception: ' + e.getMessage() + ' Line number --> ' + e.getLineNumber());
            mailBody = mail.getHTMLBody();
            if(mailBody!=null && mailBody!='' && (!string.isEmpty(mailBody))) 
            {
            mailBody = mailBody.replace('**Sales Officer Name**',String.valueOf(saleslimit.Sales_Officer_Name__r.Name));
            mailBody = mailBody.replace('**user name**',String.valueOf(UserInfo.getName()));
            mailBody = mailBody.replace('**Branch Name**',String.valueOf(oppObj.Branch_Name__r.Name));
            mailBody = mailBody.replace('**LAN**',String.valueOf(oppObj.Loan_Application_Number__c));
            mailBody = mailBody.replace('**LAN Name**',String.valueOf(oppObj.Name));
            mailBody = mailBody.replace('**Loan Amount**',String.valueOf(oppObj.Loan_Amount_with_Premium__c));
            mailBody = mailBody.replace('**Tenor**',String.valueOf(oppObj.Approved_Tenor__c));
            mailBody = mailBody.replace('**R.O.I**',String.valueOf(oppObj.Approved_Rate__c));
            mailBody = mailBody.replace('**P.F**',String.valueOf(oppObj.Processing_Fees__c));
            if(oppObj.Scheme_Master__c != null)
              mailBody = mailBody.replace('**Scheme**',String.valueOf(oppObj.Scheme_Master__r.Name));
            mailBody = mailBody.replace('**Raac PF**',String.valueOf(oppObj.Approved_Rate__c));
            mailBody = mailBody.replace('**WIRR**',String.valueOf(saleslimit.Weighted_Avg_IRR_CurrMonth__c));
            mailBody = mailBody.replace('**WPF**',String.valueOf(saleslimit.Weighted_Avg_PF_Curr_Month__c));
            mailBody = mailBody.replace('**LI**',String.valueOf(saleslimit.LI_Percent__c));
            mailBody = mailBody.replace('**HI**',String.valueOf(saleslimit.HI_Percent__c));
            mailBody = mailBody.replace('**CPP**',String.valueOf(saleslimit.CPP_Percent__c));
            mailBody = mailBody.replace('**FFR Penetration**',String.valueOf(saleslimit.FFR_Penetration__c));
            if(applicant.Contact_Name__c != null && applicant.Contact_Name__r.Employer__c != null)
              mailBody = mailBody.replace('**Employer Name**',String.valueOf(applicant.Contact_Name__r.Employer__r.Name));
            mailBody = mailBody.replace('**Employer Category**',String.valueOf(applicant.Company_Type__c));
            mailBody = mailBody.replace('**Risk Segment**',String.valueOf(applicant.Risk_Segmentation__c));
           // mailBody = mailBody.replace('**desi**',String.valueOf(designation));
            mailBody = mailBody.replace('**propROIStr**',String.valueOf(propROIStr));
            mailBody = mailBody.replace('**propPfStr**',String.valueOf(propPfStr));
            mailBody = mailBody.replace('**LIpercentage**',String.valueOf(LIpercentage));
           mailBody = mailBody.replace('**HIpercentage**',String.valueOf(HIpercentage));
                            mailBody = mailBody.replace('**propPfStr**',String.valueOf(propPfStr));//1652
                            mailBody = mailBody.replace('**CPPb**',String.valueOf(CPP)); //1652
                            mailBody =     mailBody.replace('**FFRbb**',String.valueOf(FFR));
                            //1652 Added below section
                            Decimal insFactor=0;
                            if(oppObj.Net_Loan_to_POS__c!=null && oppObj.Insurance_Premium_Amt__c!=null){
                            if((oppObj.Net_Loan_to_POS__c - oppObj.Insurance_Premium_Amt__c)!=0)
                                insFactor=((oppObj.Insurance_Premium_Amt__c * 100)/(oppObj.Net_Loan_to_POS__c - oppObj.Insurance_Premium_Amt__c)).setScale(2);
                                }
                            mailBody = mailBody.replace('**InsuranceFactor**',String.valueOf(insFactor));
                            
                            mailBody = mailBody.replace('**EMICardOpted**',(applicant.emi_card__c!=null)?'YES':'NO');
                            
           
          
            if(flag)
            {
            mailBody = mailBody.replace('**Approve**','<div align="center"><a href="'+Label.bitly_org_link+'/approveROIandPFpage?id='+oppId+'&&desi='+designation+'&&pROI='+propROI+'&&pPF='+propPF+'" class="button">Approve </a>&nbsp; &nbsp;<a href="'+Label.bitly_org_link+'/rejectROIandPFpage?id='+oppId+'&&desi='+designation+'&&pROI='+propROI+'&&pPF='+propPF+'" class="button">Decline</a></div>');
            }
            else
            {
            mailBody = mailBody.replace('**Approve**','');
            }
            mailBody = mailBody.replace('"','\\"');
            mailBody = mailBody.replaceAll('<p>\\s','<p>');
            mailBody = mailBody.trim();
            mailBody = mailBody.replaceAll('(\\s+)', ' ');
            }
            system.debug('MailBody'+mailBody);
            system.debug('Invocation count'+Limits.getEmailInvocations());
        }
            BAFL_EmailServicesLogix.EmailServicesPort stub = new BAFL_EmailServicesLogix.EmailServicesPort();
                        stub.timeout_x = 120000;
                        //System.debug('pkfromname'+fromName);
                        BAFL_EmailServicesLogix.SendEmailResponse er = stub.SendEmail('SPL_Commercialconsent@bajajfinserv.in',
                        'otpofficeemailverification@6hifw8v4ew6qa26r5whiw37rq2yorch4vylpptp0njgfwqxjc.o-51mo2mam.cs5.apex.sandbox.salesforce.com',
                        toAddlist,
                        ccArray,
                        bccArray,
                        'Normal',
                        new BAFL_EmailServicesLogix.Attachment[]{},
                        subject,                    
                        mailBody,
                        'bajaj');
                   
                
        } else {
            system.debug('EmailTemplate list is empty !!');
        }
        /*20939 RCU s*/
        if(flag){
        Set<String> setProdRes = new Set<String>();
        String productList = '';
        List<String> listmsg=new List<String>(); 
        
        SMS_Sent__c npsSMS = new SMS_Sent__c();
        if(AtosParameters__c.getValues('ResponsysAPI') != null && AtosParameters__c.getValues('ResponsysAPI').Product__c != null)
            productList = AtosParameters__c.getValues('ResponsysAPI').Product__c;
        setProdRes.addAll(productList.split(';'));
        List<Rack_Rate__c> rrMaster = new List<Rack_Rate__c>();
        rrMaster = [SELECT name,Products__c,SMS_Text__c,Additional_SMS_Text__c,Campaign_Name__c,ReceipientsAPINames__c,resendFlag__c,SMS_Type__c,Dynamic_Parameters__c,isPriority__c,Event__c,Used_For__c from Rack_Rate__c where Event__c='SAL Rate Approval - Int' LIMIT 2];
        String prodSMSMsg=rrMaster[0].SMS_Text__c;
        if(rrMaster[0].Additional_SMS_Text__c != null)
            prodSMSMsg += rrMaster[0].Additional_SMS_Text__c;
        String event;
       // Opportunity oppObj = Loan_Application[0];
       // Sales_Officer_Limit__c saleslimit = salesOfficerLimitList[0];
        Map<String, String> dynPar = new Map<String, String>();
        String bitlyLink = Label.bitly_org_link+'/SAL_RateApproval?oppId='+oppId+'&desi='+designation+'&pROI='+propROI+'&pPF='+propPF;
        if(setProdRes.contains(oppObj.Product__c) && rrMaster[0].Used_For__c == 'Responsys'){
             dynPar.put('P_REQUESTER_NAME',String.valueOf(saleslimit.Sales_Officer_Name__r.Name));
            dynPar.put('P_BRANCH_NAME',String.valueOf(oppObj.Branch_Name__r.Name));
            dynPar.put('P_LAN',oppObj.Loan_Application_Number__c);
            dynPar.put('P_APPROVEDLAN',String.valueOf(oppObj.Loan_Amount_with_Premium__c));
            dynPar.put('P_APPROVED_TENOR',String.valueOf(oppObj.Approved_Tenor__c));
            dynPar.put('P_EXISTING_RATE',String.valueOf(oppObj.Approved_Rate__c));
            dynPar.put('P_PROPOSED_RATE',String.valueOf(propROIStr));
            dynPar.put('P_WEIGHTED_IRR_R_NAME',String.valueOf(saleslimit.Sales_Officer_Name__r.Name));
            dynPar.put('P_W_IRR',String.valueOf(saleslimit.Weighted_Avg_IRR_CurrMonth__c));
            dynPar.put('P_BITLY',CommonUtility.googleShortenUrl(bitlyLink));
            npsSMS.LoanApplication__c = oppId;
            npsSMS.Name = rrMaster[0].Event__c;
            npsSMS.SMS_Sent_Number__c = String.valueOf(saleslimit.Sales_Officer_Name__r.Mobile_number__c);
            npsSMS.Status__c = 'Pending';
            npsSMS.Event__c = rrMaster[0].Campaign_Name__c;
            npsSMS.SMS_Type__c = rrMaster[0].SMS_Type__c;
            npsSMS.SMS_Receiver__c=saleslimit.Designation__c;
            npsSMS.SMS_Parameters__c = JSON.serialize(dynPar);
            
            System.debug('O '+npsSMS);
            
        }
        if(rrMaster[0].Used_For__c == 'Value First')
        {
            prodSMSMsg= prodSMSMsg.replace('*ReqName*',String.valueOf(saleslimit.Sales_Officer_Name__r.Name));
            prodSMSMsg= prodSMSMsg.replace('*Branch*',String.valueOf(oppObj.Branch_Name__r.Name));
            prodSMSMsg= prodSMSMsg.replace('*Opp*',oppObj.Loan_Application_Number__c);
            prodSMSMsg= prodSMSMsg.replace('*L_amt*',String.valueOf(oppObj.Loan_Amount_with_Premium__c));
            prodSMSMsg= prodSMSMsg.replace('*PTENOR*',String.valueOf(oppObj.Approved_Tenor__c));
            prodSMSMsg= prodSMSMsg.replace('*ERATE*',String.valueOf(oppObj.Approved_Rate__c));
            prodSMSMsg= prodSMSMsg.replace('*PRATE*',String.valueOf(propROIStr));
            prodSMSMsg= prodSMSMsg.replace('*reqName*',String.valueOf(saleslimit.Sales_Officer_Name__r.Name));
            prodSMSMsg= prodSMSMsg.replace('*IRR_R*',String.valueOf(saleslimit.Weighted_Avg_IRR_CurrMonth__c));
            prodSMSMsg= prodSMSMsg.replace('*bitly*',CommonUtility.googleShortenUrl(bitlyLink));
            
            
            npsSMS.LoanApplication__c = oppId;
            npsSMS.Name = rrMaster[0].Event__c;
            npsSMS.SMS_Sent_Number__c = String.valueOf(saleslimit.Sales_Officer_Name__r.Mobile_number__c);
            npsSMS.Status__c = 'Sent';
            npsSMS.SMS_Type__c = rrMaster[0].SMS_Type__c;
            npsSMS.SMS_Sent_Time__c = system.now();
            npsSMS.SMS_Receiver__c=saleslimit.Designation__c;
            if(prodSMSMsg.length() > 255) {
                npsSMS.SMS_Text_Sent__c = prodSMSMsg.substring(0,255).trim();
                npsSMS.Additional_SMS_Text_Sent__c = prodSMSMsg.substring(255,prodSMSMsg.length()).trim();
            } else {
                npsSMS.SMS_Text_Sent__c = prodSMSMsg.trim();  
            }
            //npsSMS.SMS_Text_Sent__c=prodSMSMsg;
            npsSMS.SMS_Sent__c = true;
            sendsms.message(String.valueOf(saleslimit.Sales_Officer_Name__r.Mobile_number__c), prodSMSMsg);//String.valueOf(oppObj.Account.Mobile__c)
            System.debug('O->  '+npsSMS);
        }
        
        if(npsSMS != null)
            insert npsSMS;
        }
        /*20939 RCU e*/
    //new changes end
      
     }catch(Exception e)
        {
            System.debug('Exception in send mail implementaion '+e.getLineNumber()+e.getMessage());
        }
    }
}


public static void getApplicationFormData()
{
    // String id = ApexPages.currentPage().getParameters().get('id');
    //List<Applicant__c> appList = [select id, name from Applicant__c where Loan_Application__c =: oppId and Applicant_Type__c = 'Primary'];
    
}
@Future(callout = true)
public static void updateApp(String appid){
    Applicant__c app = [SELECT Id,Application_Form_Timestamp__c from Applicant__c where Id =: appId];
    app.Application_Form_Timestamp__c = 'Rejected';
    update app;
}
public PageReference submitDecline()
{
    try{
    system.debug('in reject');
    PageReference pdf = new PageReference(Label.bflsiteuserURL+'/SAL_PLTBVerification'); 
    pdf.getParameters().put('purpose', 'thanks');
    pdf.getParameters().put('EmailFor', 'ApplicationForm');
    //pdf.getParameters().put('loanID', (String)oppObj.Id); Encrypt URL
     pdf.getParameters().put('loanID', CommonUtility.encryptURLParam((String)oppObj.Id));/*Encrypt URL*/
    if(applicantObj != null && applicantObj.Application_Form_Timestamp__c == 'Acceptance Pending'){
        applicantObj.Application_Form_Timestamp__c= 'Rejected';
        updateApp(applicantObj.Id);
        //update applicantObj;
    }
    //SAL_PLTBVerificationCntrl.sendsms('Decline',oppObj,applicantObj);
    if(applicantObj.Application_Form_Timestamp__c == 'Acceptance Pending' )
        pdf.getParameters().put('iptimeStamp', applicantObj.Application_Form_Timestamp__c);
    else if(applicantObj.Application_Form_Timestamp__c == 'Rejected')
        pdf.getParameters().put('iptimeStamp', applicantObj.Application_Form_Timestamp__c);
    else
        pdf.getParameters().put('iptimeStamp', 'IPADDRESS'); 
   // pdf.getParameters().put('appId',applicantObj.id); Encrypt URL
     pdf.getParameters().put('appId',CommonUtility.encryptURLParam(applicantObj.id));/*Encrypt URL*/
    
    pdf.setRedirect(true);
    system.debug('pdf is'+pdf);
    return pdf;
    }
    catch(Exception e){
        system.debug('Exception '+e.getMessage()+e.getLineNumber());
        return null;
    }
}
public PageReference submitAccept()
{
    PageReference pdf = new PageReference(Label.bflsiteuserURL+'/SAL_PLTBVerification'); 
    pdf.getParameters().put('EmailFor', 'ApplicationForm');
    //pdf.getParameters().put('loanID', (String)oppObj.Id);/*Encrypt URL*/
     pdf.getParameters().put('loanID', CommonUtility.encryptURLParam((String)oppObj.Id));/*Encrypt URL*/
    pdf.getParameters().put('iptimeStamp', iptimeStamp);
    //pdf.getParameters().put('appId',applicantObj.id);/*Encrypt URL*/
    pdf.getParameters().put('appId',CommonUtility.encryptURLParam(applicantObj.id));/*Encrypt URL*/
    
    pdf.setRedirect(true);
    return pdf;

}
//17556 stop - hrushikesh

//Referral Enhancement Start - Hrushikesh bug id : 19263 start

public static String updateLead_POMethod(List<Lead> newLeadsList, SALMobilityPricingCntrl_V2.ContactApplicantWrapper contactObj)
{
    
    System.debug('In updateLead_POMethod Mobile value is '+contactObj.contObj.Mobile__c);
    System.debug('New lead list '+newLeadsList+' Contact List '+contactObj);
    List<Lead> LeadListToUpdate=new List<Lead>();
    List<Lead> LeadListToInsert=new List<Lead>();
    List<Product_Offerings__c> POListToUpdate=new List<Product_Offerings__c>();
    List<Product_Offerings__c> POListToInsert=new List<Product_Offerings__c>();
    List<SOL_Policy__c> SOLPolicyList=new List<SOL_Policy__c>();
    StaticResource staticresc;
    
    Map<String,Object> ALLMap = new Map<String,Object>();
    String jsnBody;
    staticresc = [SELECT Body,Id,Name FROM StaticResource WHERE Name = 'SalariedCustomSettings' LIMIT 1]; 
    if(staticresc != null)
        jsnBody = staticresc.Body.toString();
    
    ALLMap = (Map<String,Object>)JSON.deserializeUnTyped(jsnBody);
    Map<String,Object> breMap =(Map<String,Object>)ALLMap.get('ReferralPODefaultEntry');
    String POName=(String)breMap.get('POName');
    Double POOffer_Amount = Double.valueOf(breMap.get('pOOffer_Amount__c'));
    Decimal POOffer_ROI  =Decimal.ValueOf((String)breMap.get('pOOffer_ROI__c'));
    Decimal POTenor =Decimal.ValueOf((String)breMap.get('POTenor__c'));
    String POProducts =(String)breMap.get('POProducts__c');
    String POLead_Source  = (String)breMap.get('POLead_Source__c');
    String POData_Mart_Status  = (String)breMap.get('Data_Mart_Status__c');  
    String status='';
    system.debug(POProducts);
    system.debug(POData_Mart_Status);
    
    
    for(Lead oneLeadObject : newLeadsList){
        
        String mobileNo = oneLeadObject.Customer_Mobile__c;
        //9568546999==>(956) 854-6999
        
        String MobileNoFormatted='('+mobileNo.substring(0, 3)+') '+mobileNo.substring(3, 6)+'-'+mobileNo.substring(6);
        
        List<Product_Offerings__c> poList;
        
        List<Lead> leadList= [SELECT id,Name FROM Lead where Customer_Mobile__c =: mobileNo or Customer_Mobile__c =: MobileNoFormatted   ORDER BY CreatedDate desc LIMIT 1];
        
        if(!CommonUtility.isEmpty(leadList))  //if lead is present already
        {
            
            leadList[0].LeadSource='SPL Referred';
            poList=[SELECT id,Products__c,CreatedDate,availed_amount__c  FROM Product_Offerings__c where Lead__c=: leadList[0].id AND Products__c='SPL' AND Data_Mart_Status__c ='LIVE' AND Product_Offering_Converted__c=false ORDER BY CreatedDate DESC LIMIT 1];
            
            if(!CommonUtility.isEmpty(poList))  //if PO is preseent
            {
                
                poList[0].Lead_Source__c='SPL Referred';
                if(poList[0].availed_amount__c==null || poList[0].availed_amount__c<1){
                    poList[0].availed_amount__c=1;
                }
                poList[0].Enquiry_Date__c = System.today();
                POListToUpdate.add(poList[0]);
                LeadListToUpdate.add(leadList[0]);
                
                System.debug('Lead Present, PO present');
            }
            else{ //create new PO, if PO is not present
                Product_Offerings__c po = new  Product_Offerings__c();
                po.Name=POName;
                po.Offer_Amount__c=POOffer_Amount;
                po.Offer_ROI__c=POOffer_ROI;
                po.Tenor__c=POTenor;
                po.Offer_Date__c= System.today(); 
                po.Products__c=POProducts;  
                po.Lead_Source__c=POLead_Source;
                po.Lead__c=leadList[0].id;
                po.Data_Mart_Status__c=POData_Mart_Status;
                po.Availed_Amount__c=1;
                LeadListToUpdate.add(leadList[0]);
                POListToInsert.add(po);  
            }    
        }
        else
        { //create Lead and PO both
            
            Lead leadObj= new Lead();
            
            String[] leadName=oneLeadObject.lastname.split(' ');
            if(leadName.size()==1){
                 leadObj.lastname= oneLeadObject.lastname; 
                 leadObj.firstName= oneLeadObject.lastname; 
            }else if(leadName.size()==2){
                leadObj.FirstName =leadName[0];
                leadObj.lastname= leadName[1];
            }else if(leadName.size()>=3){
                leadObj.FirstName =leadName[0];
                leadObj.lastname= leadName[1]+' '+leadName[2];
            }
          //  leadObj.lastname= oneLeadObject.lastname; //need to update
            leadObj.Customer_Mobile__c=oneLeadObject.Customer_Mobile__c;//need to update
            leadObj.LeadSource='SPL Referred';
            leadObj.Resi_City__c=oneLeadObject.Resi_City__c;
            leadObj.City__c  =oneLeadObject.Resi_City__c;
            leadObj.SBS_Branch__c = getSBSBranchForMGM(oneLeadObject.Resi_City__c); //need to discuss               
            leadObj.Applicant_Type__c='Primary Applicant';
            leadObj.Employer__c = oneLeadObject.Employer__c; //need to discuss
            leadObj.Company=oneLeadObject.Employer__c; //needs to DIscuss  - IMP 
            leadObj.status='Open';
            
            //insert leadObj;
            
            Product_Offerings__c po = new  Product_Offerings__c();
            po.Name=POName;
            po.Offer_Amount__c=POOffer_Amount;
            po.Offer_ROI__c=POOffer_ROI;
            po.Tenor__c=POTenor;
            po.Lead__c=leadObj.id;
            po.Data_Mart_Status__c=POData_Mart_Status;
            po.Offer_Date__c= System.today(); //need to discuss
            po.Products__c=POProducts;   //need to discuss
            po.Lead_Source__c=POLead_Source;
            po.Availed_Amount__c=1;
            // insert po; 
            LeadListToInsert.add(leadObj);
            POListToInsert.add(po); 
        }
    }  
    try{
        System.debug('Swapnil debug List size Lead list to insert '+ LeadListToInsert.size()+' lead list to update '+LeadListToUpdate.size()+' PO to insert '+POListToInsert.size()+' PO to update '+POListToUpdate.size());
        if(!CommonUtility.isEmpty(LeadListToUpdate)) {
            upsert  LeadListToUpdate;
            
        }
        if(!CommonUtility.isEmpty(POListToUpdate)){
            upsert POListToUpdate; 
            createSOL_Policy_Record(POListToUpdate,contactObj,SOLPolicyList);
            
        }
        if(!CommonUtility.isEmpty(LeadListToInsert)){
            insert LeadListToInsert;
            
        }
        integer i=0;
        for(Lead leadObj:LeadListToInsert)
        {
            POListToInsert[i].Lead__c=leadObj.id;
            
            i++;
        }
        if(!CommonUtility.isEmpty(POListToInsert)){ 
            try{
                System.debug('Inserting po '+POListToInsert);
                insert POListToInsert;
            }catch(Exception e){
                System.debug('Exception on line '+e.getMessage()+' Line '+e.getLineNumber());
            }
            
            createSOL_Policy_Record(POListToInsert,contactObj,SOLPolicyList);
        }
        try{
            insert SOLPolicyList; 
            //Send SMS Logic start
            for(SOL_Policy__c solObj: SOLPolicyList)
            {
                List<SOL_Policy__c> solListSms=new List<SOL_Policy__c>();
                solListSms.add(solObj);
                List<Product_Offerings__c> poListSms=[SELECT Id,Lead__r.Customer_Mobile__c FROM Product_Offerings__c where id=: solObj.Product_Offerings__c LIMIT 1];
                System.debug('Attach SMS To PO- '+poListSms);
                // GeneralCommunicationHandler.sendsmspo(poListSms,solListSms,'Referred Success-Referee',false);
                sendSmsToNewCustomer(JSON.serialize(poListSms[0]),JSON.serialize(solListSms[0]));
                GeneralCommunicationHandler.sendsmspo(poListSms,solListSms,'After Refer-ExistCust',false);    
                solListSms.clear();
            }
            //send SMS Logic Stop
            status='Lead inserted successfully';
        }
        catch(Exception e){
            System.debug('Exception'+e.getMessage()+e.getLineNumber());
            status='Exception occured while inserting leads ';
        } 
        
        
    }catch(Exception e)
    {
        System.debug('Exception'+e.getMessage()+e.getLineNumber());
        status='Exception occured while inserting leads ';
    }
    
    
    return status;   
}
    @Future(callout=true)
public static void sendSmsToNewCustomer(String poString,String solString){
    try{
        SOL_Policy__c solObj = (SOL_Policy__c) JSON.deserialize(solString,SOL_Policy__c.class);
        Product_Offerings__c poObj = (Product_Offerings__c) JSON.deserialize(poString,Product_Offerings__c.class);

        SMS_Sent__c sms2 = new SMS_Sent__c();
        sms2.Product_Offerings__c=poObj.id;
        sms2.Name='Referred Success-Referee';
        sms2.SMS_Receiver__c='Primary Applicant';
        sms2.SMS_Type__c = 'Application Saved';
        sms2.SMS_Sent_Number__c = poObj.Lead__r.Customer_Mobile__c;
        sms2.SMS_Receiver__c = 'Applicant';
        //String bitly=Label.bflsiteuserURL+'/CibilWatchAcceptancePage?po_id='+poObj.id+'&SOL_id='+solObj.id; //commented for Bug 19478/19263
        String bitly=Label.bflsiteuserURL+'/CibilWatchAcceptancePage?po_id='+CommonUtility.encryptURLParam(poObj.id)+'&SOL_id='+CommonUtility.encryptURLParam(solObj.id);//added for Bug 19478/19263 -hRUSHIKESH

        bitly = Commonutility.googleShortenUrl(bitly);
        
        Map<String, Object> dynPar = new Map<String, Object>();
        //  dynPar.put('P_SOL_ID','a1v0k0000014DB8AAM');
        // dynPar.put('P_PO_ID','Click Here    ');
        dynPar.put('P_RefCustName',solObj.Reason__c);
        dynPar.put('P_SITE_URL',bitly);
        
        sms2.sms_parameters__c = JSON.serialize(dynPar);
        sms2.status__c = 'Pending';
        sms2.Event__c = 'A_CONFIRMING_INTEREST';
        // insert sms2;
        sendSmsToNewCustomerHelper(JSON.serialize(sms2));
    }catch(Exception e){System.debug('Exception in sendSmsToNewCustomer'+e.getMessage()+e.getLineNumber());}
}        
public static void sendSmsToNewCustomerHelper(String smsObj){
    try{
        SMS_Sent__c sms = (SMS_Sent__c) JSON.deserialize(smsObj,SMS_Sent__c.class);
        
        insert sms;
    }catch(Exception e){System.debug('Exception in sendSmsToNewCustomer'+e.getMessage()+e.getLineNumber());}
}







public static void createSOL_Policy_Record(list<Product_Offerings__c> POListToUpdate,SALMobilityPricingCntrl_V2.ContactApplicantWrapper contactObj,list<SOL_Policy__c> SOLPolicyList){
    System.debug('In SOL create Mobile value is '+contactObj.contObj.Mobile__c);
    for(Product_Offerings__c po : POListToUpdate){
        System.debug('In SOL create for');
        SOL_Policy__c SOLPolicyObj =new SOL_Policy__c();
        SOLPolicyObj.Product_Offerings__c=po.Id;
        SOLPolicyObj.Name='SPL Referral Details';
        SOLPolicyObj.New_Address_Value__c=String.valueOf(contactObj.contObj.Mobile__c*1); //newly added  
        SOLPolicyObj.Reason__c=''+contactObj.contObj.Name; //newly added  
        SOLPolicyObj.Remarks__c=''+CommonUtility.encryptURLParam(po.Id+'');
        SOLPolicyObj.Remarks__c=''+CommonUtility.encryptURLParam(po.Id+'');
        
        SOLPolicyObj.Reference_Loan_Application__c=String.valueOf(contactObj.appObj.Loan_Application__r.id);
        
        SOLPolicyObj.Old_Address_Value__c= contactObj.contObj.Name+';'+contactObj.contObj.Email__c+';'+contactObj.contObj.Office_Email_Id__c+';'+contactObj.contObj.Id+';'+String.valueOf(contactObj.contObj.Mobile__c)+';'+contactObj.appObj.Loan_Application__r.Loan_Application_Number__c;
        System.debug('SOL Added '+SOLPolicyObj);
        SOLPolicyList.add(SOLPolicyObj);
    }
}
//Added by swapnil to map branch city to lead    
public static id getSBSBranchForMGM(String city){
    return [SELECT Id,name from Branch_Master__c where name=:city order by createdDate desc limit 1 ].id;
}


public static String getDiaryColor()
{
    String diaryColor='red';
    String currentUser= UserInfo.getUserId();
    List<Product_Offerings__c> poList=[SELECT id,createdDate,OwnerId from Product_Offerings__c where Lead_Source__c ='SPL Referred' AND OwnerId=:currentUser AND createdDate = LAST_N_DAYS:30 ];
    System.debug('Getting Diary color '+poList.size());
    if(!CommonUtility.isEmpty(poList)) 
    {
        
        Decimal referralCount=poList.size();
        StaticResource staticresc;
        Map<String,Object> ALLMap = new Map<String,Object>();
        String jsnBody;
        staticresc = [SELECT Body,Id,Name FROM StaticResource WHERE Name = 'SalariedCustomSettings' LIMIT 1]; 
        if(staticresc != null)
            jsnBody = staticresc.Body.toString();
        ALLMap = (Map<String,Object>)JSON.deserializeUnTyped(jsnBody);
        Map<String,Object> breMap =(Map<String,Object>)ALLMap.get('DiaryColorRange');
        
        String range = (String)breMap.get('red');
        List<String> rangeSet = new List<String>();
        rangeSet.addAll(range.split(';'));
        
        Decimal range1, range2, range3, range4, range5,range6;
        
        range1=Decimal.ValueOf(rangeSet[0]);
        range2=Decimal.ValueOf(rangeSet[1]);
        
        range = (String)breMap.get('yellow');
        rangeSet.clear();
        rangeSet.addAll(range.split(';'));
        range3=Decimal.ValueOf(rangeSet[0]);
        range4=Decimal.ValueOf(rangeSet[1]);
        
        range = (String)breMap.get('green');
        rangeSet.clear();
        rangeSet.addAll(range.split(';'));
        range5=Decimal.ValueOf(rangeSet[0]);
        range6=Decimal.ValueOf(rangeSet[1]);
        SYstem.debug(' '+range1+range2+range3+range4+range5+range6);
        if(referralCount>=range1 && referralCount<=range2)
        {
            diaryColor='red';
        }
        if(referralCount>=range3 && referralCount<=range4)
        {
            diaryColor='yellow';
        }
        if(referralCount>=range5 && referralCount<=range6)
        {
            diaryColor='green';
        }
    }  
    else
        return diaryColor;
    
    
    return diaryColor;
}

public static String getPOs(String searchLimit)
{
    String oppId; 
    String currentUser= UserInfo.getUserId();
    List<referralData> refList=new List<referralData>();
    List<Product_Offerings__c> poList;
    //Lead__r.customer_mobile__cfield 
    if(searchLimit=='15')
        poList =[SELECT id,Offer_Amount__c,Customer_Acceptance_Flag__c,(select id,name,Old_Address_Value__c from SOL_Policys__r where name='SPL Referral Details' order by createdDate asc LIMIT 1),Field_Disposition_1__c,Lead__r.name,Lead__r.customer_mobile__c,Lead__r.Status,name,createdDate,OwnerId,Products__c from Product_Offerings__c where Lead_Source__c ='SPL Referred' AND OwnerId=:currentUser AND createdDate = LAST_N_DAYS:15 ];
    if(searchLimit=='30')
        poList =[SELECT id,Offer_Amount__c,Customer_Acceptance_Flag__c,(select id,name,Old_Address_Value__c from SOL_Policys__r where name='SPL Referral Details' order by createdDate asc  LIMIT 1),Field_Disposition_1__c,Lead__r.name,Lead__r.customer_mobile__c,Lead__r.Status,name,createdDate,OwnerId,Products__c from Product_Offerings__c where Lead_Source__c ='SPL Referred' AND OwnerId=:currentUser AND createdDate = LAST_N_DAYS:30 ];
    if(searchLimit=='getAllReferredPO'){
        poList =[SELECT id,Offer_Amount__c, Name,Customer_Acceptance_Flag__c,Lead__r.name,Lead__r.Customer_mobile__c,  Field_Disposition_1__c,Lead__r.Status,createdDate,OwnerId,Product_Offering_Converted__c, Data_Mart_Status__c,Products__c from Product_Offerings__c where Lead_Source__c ='SPL Referred' AND Data_Mart_Status__c = 'LIVE' AND Product_Offering_Converted__c=FALSE  order by Field_Activity_In_Time__c desc];
    }
    if(searchLimit.contains(';'))
    {
        String [] dateSplit=new List<String>();
        dateSplit=searchLimit.split(';');
        String startdateString=dateSplit[0];
        String stopdateString=dateSplit[1];
        Date convertedStartDate = date.parse(startdateString);
        Date convertedStopDate = date.parse(stopdateString);
        System.debug(convertedStartDate +'   '+ convertedStopDate+'   '+  startdateString+'   '+ stopdateString);
        poList =[SELECT id,Offer_Amount__c,Customer_Acceptance_Flag__c,(select id,name,Old_Address_Value__c from SOL_Policys__r where name='SPL Referral Details' order by createdDate asc  LIMIT 1),Field_Disposition_1__c,Lead__r.name,Lead__r.Status,name,createdDate,OwnerId from Product_Offerings__c where Lead_Source__c ='SPL Referred' AND OwnerId=:currentUser AND createdDate>=: convertedStartDate AND createdDate<=: convertedStopDate ];  
    }
    if(!CommonUtility.isEmpty(poList)) 
    {
        for(Product_Offerings__c po:poList)
        {
            referralData dss=new referralData();
            dss.poObj=po;
            if(!CommonUtility.isEmpty(po.SOL_Policys__r))
            {
                dss.solObj=po.SOL_Policys__r[0];
                if(!CommonUtility.isEmpty(po.SOL_Policys__r[0].Old_Address_Value__c))
                {
                    List<Opportunity> oppList;
                    System.debug('Address value available for this SOL Policy '+  dss.poObj.Name);
                    String fullString= po.SOL_Policys__r[0].Old_Address_Value__c;
                    String [] array1 = new List<String>();
                    array1 = fullString.split(';');  
                    dss.referredByName= array1[0]; //contains name
                    if( array1[5]!=null) dss.referredByLAN=  array1[5]; //contains LAN
                    dss.referredByMobile= array1[4];  //contains Mobile
                    if( array1[5]!=null) oppId= array1[5];  //contains LAN
                    System.debug('Swapnil debug '+dss.referredByName+' '+dss.referredByLAN+' '+dss.referredByMobile+' '+ oppId);
                    if( array1[5]!=null) { 
                        oppList=[select id,name,convertCurrency(Loan_Amount__c),StageName from Opportunity where Loan_Application_Number__c =: oppId];
                        if(oppList.size()>0){
                            System.debug('Loan amount is '+oppList[0].Loan_Amount__c);
                            dss.loanObj= oppList[0]; System.debug('MYLOAN='+oppList);
                        }
                    }
                    
                    //contains mobile number //The name of Person Who is Referring, Mobile Number and the Loan Application Number
                }else{
                    System.debug('No Address value available for this SOL Policy '+  dss.poObj.Name);
                }
            }
            else{
                System.debug('SOL Policy available for this PO '+ dss.referredByName);
            }
            refList.add(dss);
        }
        System.debug('RefList is '+refList);
        if(searchLimit=='getAllReferredPO'){
            return JSON.serialize(poList);
        }
        return JSON.serialize(refList);
    }  
    return null;
    
}

public class referralData {
    public Product_Offerings__c poObj;    
    public SOL_Policy__c solObj;
    String referredByName;
    String referredByMobile;
    String referredByLAN;
    public Opportunity loanObj;
    
    
}
public Class ContactApplicantWrapper{
public  Contact contObj {get;set;}
public  Applicant__c appObj {get;set;}
}

/* Bug 22624 Start - Hrushikesh Sprint 5C */
    public static String checkMaxRateApproval(String oppId){
  /*Map<String,Object> allMap1;
        Map<String,Object> innerMap;
        Map<String,Object> innerMapType;
  String segmentType='Normal_Segment';
        Decimal maxLimit;
        String loanType='Term_Loan';
    Opportunity oppObject= [select id, Product__c,Scheme_Master__r.IsHybridFlexi__c,Scheme_Master__r.is_Pure_Flexi__c,Scheme_Master__r.flexi_flag__c from Opportunity where id=: oppid];
        Applicant__c primaryApplicant=[select id,Contact_Name__r.id,Risk_Segmentation__c,IP_Address_Timestamp__c,Application_Form_Timestamp__c,KYC_Verifications__c,Pure_Flexi_Period__c,Drop_Line_Flexi_Period__c,Pure_Flexi_EMI__c,CIBIL_Score__c from Applicant__c where Loan_Application__c =: oppId AND Applicant_Type__c ='Primary' ];  
        Contact conobj = [SELECT Employer__r.Company_Category__c   from Contact where id=: primaryApplicant.Contact_Name__r.id LIMIT 1];
System.debug('in check of rate app'+primaryApplicant.CIBIL_Score__c);           
  if(!CommonUtility.isEmpty(primaryApplicant.Risk_Segmentation__c) && primaryApplicant.Risk_Segmentation__c=='HR')
        {
            segmentType='Special_Segment';
        }
        if(conobj != null && conobj.Employer__r != null && conobj.Employer__r.Company_Category__c != null)
        {
            if(conobj.Employer__r.Company_Category__c =='Company not listed' || conobj.Employer__r.Company_Category__c =='Colleges' || conobj.Employer__r.Company_Category__c =='School' || conobj.Employer__r.Company_Category__c =='Government')
               segmentType='Special_Segment'; 
        }
        if(primaryApplicant.CIBIL_Score__c !=null)
        {
            if(primaryApplicant.CIBIL_Score__c =='000-1'|| Decimal.valueOf(primaryApplicant.CIBIL_Score__c) <700)
            {
                segmentType='Special_Segment';
            }
        }
        if(oppObject.Scheme_Master__r.IsHybridFlexi__c || oppObject.Scheme_Master__r.flexi_flag__c || oppObject.Scheme_Master__r.is_Pure_Flexi__c)
        {
            loanType='Flexi_Loan';
        }
        String product;
        //Added for RSL 22018
        product=oppObject.Product__c;
        System.debug('loanType='+loanType);
        System.debug('product='+product);
        System.debug('segmentType='+segmentType);
  
        
        if(product!=null)
        {
            allMap1= (Map<String,Object>) CommonUtility.getMapFromStaticResource('SalariedCustomSettings',segmentType);
            innerMap=(Map<String,object>)allMap1.get(loanType); //flexi or term
            innerMapType=(Map<String,object>)innerMap.get(product); //sal or spl 
            maxLimit= Decimal.valueOf(String.valueOf(innerMapType.get('No approver')));
    return String.valueOf(maxLimit); 
   }*/
return null; 
}
/* Bug 22624 Stop - Hrushikesh Sprint 5C */
//22017 start
 public static map<String,String> getpicklistvalnew(String objname,String fieldname){
 map<String,String> picklistmap = new map<String,String>();
 Map<String, Schema.SObjectField> objectcontains =  Schema.describeSObjects(new List<String>{objname}).get(0).fields.getmap();
 if(objectcontains.get(fieldname).getDescribe().getType() == Schema.DisplayType.Picklist)
 {
     Schema.DescribeFieldResult fieldResult = objectcontains.get(fieldname).getDescribe();
     List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
     for( Schema.PicklistEntry v : values) {
          picklistmap.put(v.getLabel(),v.getValue());
          System.debug('Picklist API Name:' + v.getValue());
          System.debug('Picklist label Name:' + v.getLabel());
          }
 }
 return picklistmap;
 }
 //22017 end
 /*24673 s*/ 
    
    public static List < IFSC_Master__c > fetchBank(String searchKeyWord) {
        List<IFSC_Master__c> finalList = new List<IFSC_Master__c>();
        Set<String> bankNames = new Set<String>();
        List<IFSC_Master__c> masterList = [SELECT Id,Bank__c from IFSC_Master__c where Name LIKE: ('%' + searchKeyWord + '%')];
        for(IFSC_Master__c ifsc : masterList){
            if(!bankNames.contains(ifsc.Bank__c)){
                finalList.add(ifsc);
                bankNames.add(ifsc.Bank__c);
            }
        }
        return finalList;
    }
    
    public static String saveLandlordDetailsMethod(String solpol){
        try{
            // System.debug('repay-->'+repay);
            Sol_policy__c solObj = new Sol_policy__c();
            solObj = (Sol_policy__c) JSON.deserialize(solpol,Sol_policy__c.class);
            solObj.Name = 'RDPL Rental Agreement';
            solObj.Policy_name__c= 'RDPL Rental Agreement';
            system.debug('solObj== '+solObj);
            upsert solObj;
            SALMobilityOppCntrl_V2.Oppdata opp = new SALMobilityOppCntrl_V2.Oppdata();
            if(!CommonUtility.isEmpty(solObj.Loan_Application__c))
                FioranoCallout.fetchRentalAgreement(solObj.Loan_Application__c);
            opp.solpolicyLandLord = solObj;
            return JSON.serialize(opp);
        }
        catch(Exception e){
            return 'Fail: '+e.getMessage();
        }
    }
    
    public static String checkRentalAggStatus(String oppId){
        String reultStr ='';
        try{
            List<SOL_Policy__c> solList = [SELECT ID, Name, Agreement_Document_Id__c from SOL_Policy__c where Loan_Application__c =: oppId AND Name = 'RDPL Rental Agreement'];
            if(solList != null &&solList[0]!=null)
                reultStr = FioranoCallout.callchkRentalAggStatus(solList[0].Agreement_Document_Id__c);
            if(solList != null &&solList[0]!=null && reultStr!= null && reultStr !=''){
                solList[0].Document_Status__c = reultStr;
                update solList[0];
            }
            system.debug('reultStr::'+reultStr);
        }catch(Exception e){
            system.debug('Error occured::'+e+e.getLineNumber());
        }
        return reultStr;
    }
    
    /*24673 e*/
 //25097 start
    public void submitAnswers(){
      
          InsuranceQuestionnaireCtrl.oppId = oppObj.Id;
          insQ.FeedbackAnsList = [SELECT Loan_application__c,Question__c, Question_Text__c,Insurance_ID__c, Sequence_Number__c,Feedback_Answer11__c,Feedback_Answer__c FROM Feedback__c WHERE Loan_application__c = :oppObj.Id];
          insQ.submitAnswers();
     
    
    }
    //25097 stop
}