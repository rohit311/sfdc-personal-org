public class CommonUtility {
     public static Boolean salMobilityFlag = false; /*SAL 2.0 checklist CR*/
      //SAL Invisible Monitoring Start
     public static Boolean isSampling = false;
     public static List < SurrogateCAM__c > ScamList = new List < SurrogateCAM__c > ();
     public static Id LoanId;
     public static List < Cibil_Extension1__c > cibilExt1List = new List < Cibil_Extension1__c > ();
     public static Applicant__c applicantPrimary {
      get;
      set;
     }
       public static ContentVersion cvSelected{get;set;}
     public static List < Bank_Account__c > bankAccLst {
      get;
      set;
     }
     
     public static Opportunity Loan {
        get;
        set;
       }
     public static SurrogateCAM__c objSurrogateCAM {
         get;
         set;
       }
     public static List < Personal_Discussion__c > PDList {
      get;
      set;
      }
     public static String PDType {
      get;
      set;
     }
     public static Personal_Discussion__c pd {
      get;
      set;
     }
      static Contact cont = new Contact();
      public static Cam__c cam {
      get;
      set;
     }
      public Static List < cam__c > camList = new List < cam__c > ();
      public static List < Id > AllConlist = new List < Id > ();
      public static List < Applicant__c > applicantList = new List < Applicant__c > ();
    
 
     
     public static void dataforIM()
     {
     
      if (LoanId != null) 
      {
      Loan = [select id, Branch_Name__r.Doctors_Branch_Type__c, Branch_Name__r.Professional_Branch_Type__c, Branch_Type__c, A_C_No__c, Area_SM__c, Industry__r.Industry__c, Owner.Name, Original_Approver__c, Branch_City__c, Decision_Time__c, Loan_Amount_with_Premium__c, Approved_Loan_Amount__c, Approved_Rate__c, Approved_Tenor__c, Loan_amt_with_premium__c, Insurance_Premium_Amt__c, online_salaried_app__c, Sourcing_Channel__r.Risky_DSA__c,
     Reject_Reason__c, Sales_Backend__c, name, Risk_Deviations__c, CRO_Deviations__c, CPA__c, ACM__c, RCM__c, NCM__c, CRO__c, RISK__c, COO__c, ACM_Comments__c, RCM_Comments__c, COO_Comments__c, Eligible_for_cross_sell__c, Products_for_cross_sell__c, Cross_sell_comments__c,
     Approval_Stages__c, Approver__c, Loan_Application_Number__c, Product__c, Loan_Type__c, Relationship_Manager__c, Relationship_Manager__r.Mobile_number__c, Relationship_Manager__r.MobilePhone, AccountId, CreatedDate,
     OwnerId, CreatedById, Scheme_Master__c,Scheme_Master__r.PLOC_scheme__c , Scheme_Master__r.Name, Industry__c, Credit_Program__c,
     Sub_Industry__c, Existing_Customer__c, Finance_Amount__c, Tenor__c, Main_Sector__r.Sector__c, Main_Industry__c, Main_Sub_Industry__c,
     Type_Of_Loan__c, amount, Employee_Type__c, stagename, Probability, Branch_Name__r.branch_type__c,
     ForecastCategoryName, File_Acceptance__c, Discrepancy_Status__c, Loan_Amount__c, Total_EMI__c, Sourcing_Channel__r.Name,
     Type_of_Constitution__c, Application_Form_Number__c, If_Yes__c, Branch_Type1__c, Relationship_Manager__r.Name,
     Branch_Name__r.name, Sourc_Mobile__c, ASM_Mobile__c, Sales_Backend_Mobile__c, Verification_Initiated__c, Referral__c,
     Sourcing_Channel__c,Sourcing_Channel__r.Sourcing_Channel_Flag__c, Current_UserRole__C, CEO__c, CEO__r.name, RCM__r.name, NCM__r.name,
     RISK__r.name, COO__r.name, CRO__r.name, Comments__c, No_of_Properties__c,
     Amount_Rs__C, Instrument_No__c, Bank_Name__c, Dated__c, NameRef1__C, MOF_Waiver_Details__c, Total_Obligation__c, sales_turnover__c,
     NameRef2__C, Address_Line1Ref1__c, Address_Line1Ref2__c, Address_Line2Ref1__c,
     Address_Line2Ref2__c, Address_Line3Ref1__c, Address_Line3Ref2__C, CityRef1__c, Field_Disposition__c,
     CityRef2__C, OccupationRef1__C, OccupationRef2__C, Pin_CodeRef1__c, Pin_CodeRef2__C,
     Office_PhoneRef1__C, Office_PhoneRef2__c, Office_MobileRef1__C, Office_MobileRef2__c, Offer_Amount__c,
     No_Of_Years_KnownRef1__c, No_Of_Years_KnownRef2__c, RelationshipRef1__c, RelationshipRef2__C,
     Nominee_Name__c, Nominee_AddressLine1__C, Nominee_AddressLine2__c, Quality_Check_Status__c,
     Nominee_AddressLine3__c, Nominee_PinCode__c, Nominee_City__c, Customer_email_id__c, Total_TAT__c,
     STD_Code__C, Nominee_Phone__c, Nominee_Relationship__c, testbeta__C, Accountant_email_id__c, DSA_Sharing__c,
     Processing_Fee_Status__C, Instument_Type__c, Insurance_Company__C, Premium_Amount__C, Sum_Assured__c, Processing_Fees__c,
     Remark__C, Customer_Type__c, Reject_Reason_1__c, Relationship_Manager__r.Phone, Employee_No_of_ACM__c, Hold_Reason__c,
     FAS_Processing_Fee_Amt__c, End_Use__c, Sanction_Validity_Date__c, Nature_of_Business__c, Bank_A_c_No_of_Customer__c,
     DF_Type__c, Favouring__c, DF_City__c, IFSC_Code__c, MICR_Number__c, Conditonal_Approved_Flag__c, Conditional_Approver__c,
     Acc_InsurFundedType__c, Acc_Type_of_Policy__c, Acc_InsurCompanyName__c, Branch_Name__r.Hub_Name__c,
     Acc_InsurStartDate__c, Acc_InsurPremiumAmount__c, Acc_InsurSumAssured__c, Owner.Profile.Name, Account.Name,/*invisible monitoring s*/Account.Residence_TypeAcc__c,Account.Type_of_Ownership__c,
     Requested_ROI__c, Processing_Type__c, Account.IS_OTP_FLOW__c, EMI_CAM__c, Date_of_created_date__c, Branch_Name__r.RBL_Branch_Type__c, Branch_Name__r.Branch_Code__c,Account.Current_experiance_in_Month__c,
     Life_InsuranceRemarks__c, Type_of_Borrower__c, AppScore__c, Rank1__c, Loan_Application_Flow__c, A_C_Type__c, Branch_Name__c, Program_Type__c,
     CampaignId, Business_IRR__c, POS__c, BranchName__c, Financed_by_BFL__c, Disbursement_Type__c, Tranche_Count__c, City_Head__c, UnHold__c, Total_Loan_amount__c, Scheme_name__c, Eligible_for_PSL__c,
     CL_Region__c, Region__c, Old_Product__c, account.Years_in_Bus__c, CAM_Expiry_Date__c, CAM_Preparation_Date__c, Business_Head__c, Centralized_ACM__c, Account.Total_Work_Experience_Yrs__c,Account.Total_Work_Experience_Months__c,
     AMC__c, Centralized_RCM__c, Customer_Reference_Number__c, SMS_to_be_Sent__c, ACM__r.Mobile_number__c, Approved_time_after_Reappraisal__c, Decision_Date__c, Interior_Designer__c, Service_Availed__c, EMI_Type__c, Pricing_Details_Approved_by__c,
     Account.Loan_Amount_Discussed_and_Agreed__c,/*added by akshata invisible monitoring for dl S*/Account.First_Name__c,Account.Last_Name__c/*added by akshata invisible monitoring for dl E*/, Account.Process_Type__c, Account.Specialisation__c, Account.Type_of_Degree__c, Account.Degree__c, Account.Current_experiance_in_Years__c, Account.date_of_Birth__c, Sub_Stage__c, (select Id, Name, Offer_Amount__c, Availed_Amount__c, Tenor__c, Offer_ROI__c, Offer_Validity__c, Campaign_Type__c, Existing_LAN__c, Requested_Tenor__c, Revised_Offer_Amount__c, Program_Type__c,
      Revised_Offer_ROI__c, EMI_Amount__c, Current_EMI__c, Products__c, Product_Offering_Source__c, PO_Type__c from Product_offerings__r), DSA_Name__c, Account.EMI_Frequency__c, Account.ownerid, Account.Group_Type__c,
     ACM_Amount__c, Centralized_ACM_Amount__c, RCM_Amount__c, CRO_Amount__c, COO_Amount__c, Centralized_RCM_Amount__c, ZCM_Amount__c, RISK_Amount__c, NCM_Amount__c, Business_Head_Amount__c, President_Approval_Amount__c,/* bug 6974 */ account.IsB2CStatusSent__c , /* bug 6974*/ 
     President__c from Opportunity where id = : LoanId
    ];
    }
    if (LoanId != null) {
     
     ScamList = [Select id, CY_Capital__c, PY_Capital__c, CY_Reserves_and_Surplus__c, PY_Reserves_and_Surplus__c, CY_Total_Existing_Borrowings_Excluding_O__c,
      PY_Total_Existing_Borrowings_Excluding_O__c, CY_Total_Creditors__c, PY_Total_Creditors__c, CY_Total_Debtors__c, PY_Total_Debtors__c,
      CY_Closing_Stock__c, PY_Closing_Stock__c, CY_Total_Cash_and_Bank_Balance__c, PY_Total_Cash_and_Bank_Balance__c, CY_Balance_Sheet_Total__c,
      PY_Balance_Sheet_Total__c, CY_Audited_Turnover__c, PY_Sales_Turnover__c, CY_Net_Profit__c, PY_Net_Profit__c, CY_Depreciation__c, PY_Depreciation__c,
      Surrogate_Type__c, Loan_Type__c, Propossed_Loan_Amount__c, MOB__c, Financier__c, Active_Closed__c, Rating_Agency__c,
      Turnover_as_per_Banking__c, OD_CC_limit__c, Banking_10th_Bal__c, Banking_20th_Bal__c, OD_CC_10th_Bal__c, OD_CC_20th_Bal__c, Last_Done_date__c,
      OD_CC_Month_end_Bal__c, Banking_Month_end_Bal__c, Banking_Cheque_Return_Inward__c, OD_CC_Cheque_Return_Inward__c, OD_CC_Cheque_Return_Outward__c,
      Banking_Cheque_Return_Outward__c, Banking_details_OD_CC_check__c, CY_Obligations__c, SME_Score__c, Final_Eligibility__c, Customer_Segment__c,
      Loan_amount__c, CY_tenor__c, ROI__c, EMI_of_Loan__c, Tenor_of_Loan__c, Proposed_Loan_Tenure__c, IRR__c, Rating__c, type_of_rating__c, Program_Type__c,
      Credit_Customer_Segment__c, Credit_Final_Eligibility__c, Credit_SME_Score__c, Credit_Surrogate_Eligibility__c,
      CY_Business_Vintage__c, CABank_Name__c, Membership_Number__c, Growth_in_Sales_Turnover__c, Negative_Area__c, Expiry_Date_with_BT__c,
      Net_Profit_Margin__c, PBDT_Growth_over_last_year__c, Total_Net_Worth__c, Current_Year_return_filling_date__c, Line_opted__c, Line_flag__c,
      Previous_Year_return_filling_date__c, Net_Working_Capital__c, Current_Ratio__c, OD_CC_Last_renewal_date__c, OC_CC_Enhancement_Amount__c,
      Cash_Conversion_Cycle_In_Days__c, Applicant__c, Line_assigned_basis_Credit_Assessment__c, Expiry_Date_without_BT__c, Tenor_for_Line_assignment_in_yrs__c,
      Debtor_Turnover_Days__c, Creditor_Turnover_Days__c, Stock_Turnover_Days__c, Total_existing_borrowing_to_sales__c, Latest_Credit_Rating_Agency__c, Rating_Obtained__c,
      Date_of_Latest_Rating__c, Closure_Month_Year__c, CY_Net_worth__c, Surrogate_loan_amount__c, Surrogate_Tenor__c, Sales_Customer_Segment__c, Sales_Final_Eligibility__c, Sales_Surrogate_eligibility__c,
      Line_Assigned_Date__c, Customer_Acceptance_Flag__c, Customer_Accepted_Date__c, Line_Active_Flag__c, OptOutURL__c, OptInURL__c, risk_category__c, Fee_Amount__c, Fees_Paid__c, Fees_Paid_Date__c
      /*invisible monitoring SAL*/
      ,BL_ODCC_Utilization__c,BL_Annualised_BTO__c,Applicant__r.Applicant_Type__c
      from SurrogateCAM__c where Loan_application__c = : Loan.Id
     ];
     if (ScamList.size() > 0)
      objSurrogateCAM = ScamList[0];
      
    }

 
    
    if( Loan != null)
    { 
     bankAccLst = [select id, Avg_mthly_bal6__c,/*SAL IM Rohit start */ Applicant__r.Applicant_Type__c,Applicant__r.SME_Score__c,Applicant__r.CIBIL_Score__c,/*SAL IM Rohit end */ Transaction_Count__c, Salaried_CAM__c, name, Bank_Name__c, sum_Avg_mthly_bal__c, Send_Email_For_Perfios__c, Bank_Acct_Number__c,
     Average_incentive_for_Q1__c, Salary_Credit_Date1__c, Salary_Credit_Date2__c, Salary_Credit_Date3__c, Salary_credit_amount1__c, Salary_credit_amount2__c, Salary_credit_amount3__c,
     Account_Type__c, OD_CC_limit__c, X10th_Bal__c, X20th_Bal__c, Month_end_Bal__c, Average_of_DB_Amount__c,
     Average_of_DB_No__c, Average_of_CRD_Amount__c, Average_of_CRD_No__c, Average_of_Bounce_O_W__c, IFSC_Code__c,
     Average_of_Bounce_I_W__c, Bank_Name_List__c, Bank_Type__c, Depository_Participant_Id__c, ClientName__c, ClientId__c, TrackingId__c, Depository_Participant_Name__c
     from Bank_Account__c where Loan_Application__c = : Loan.Id
    ];
    }
    
    PDList = new List < Personal_Discussion__c > ();
    PDList = [select id, Did_you_apply_for_a_loan_with_BFL__c ,Did_the_executive_explain_the_document_r__c,Did_you_sign_our_application_form__c ,Type_of_PD__c, Name_of_the_applicant__c, PD_Conducted__c, PD_Ok__c from Personal_Discussion__c where Loan_Application__c = : LoanId];
    pd = new Personal_Discussion__c();
    if (PDList.size() > 0) {
     PDType = PDList[0].Type_of_PD__c;
     pd = PDList[0];
    }
     
     
     
      camList = [select name, CreatedDate, Current_Year_PLBS__c, Current_Year_PLBS__r.Year__c, Previous_Year_PLBS__r.Year__c, Previous_Year_PLBS__c, Applicant__r.Contact_Name__c,
     Type_Cust__c, Type_of_Entity__c, Month1__c, Total_Income_GP__c, Month2__c, Month3__c, Gross_Salary_Month1__c, Approved_CAM__c, Monthly_Reimbursement__c, Maximum_Unsecured_Exposure_MUM__c,
     Gross_Salary_Month2__c, Gross_Salary_Month3__c, Final_Net_An_Inc__c, Net_Salary_for_Month1__c, Net_Salary_for_Month2__c, Net_Salary_for_Month3__c, Avg_Net_Sal__c, Avg_Mthly_Inctve_70__c,
     Avg_Qtrly_Inctve_60__c, Avg_Mthly_Net_Inc__c, Average_Monthly_Net_Income1__c, Mthly_Loan_EMI__c, Credit_Card_Out_5__c, OD_interest__c, Total_Mthly_Oblig__c, NAS__c, Maxi_EMI_Banking__c, Maxi_EMI_Cust__c,
     Maxi_EMI_FOIR__c, Max_EMI_Offer__c, NAS_Multi__c, Max_Loan_Amt_NAS_Multi__c, ROI__c, Final_FOIR__c, Avg_monthly_incentive1__c, Avg_monthly_incentive2__c,
     Proposed_Loan_Amt__c, IRR_TO__c, Tenor__c, EMI_on_Proposed_Loan_TO__c, Insurance_taken_TO__c, Premium_Amount_TO__c, Loan_Amt_Premium__c, EMI_with_Insurance_Premium_TO__c,
     Avg_monthly_incentive3__c, Avg_mthly_incntve_3mts__c, Average_incentive_for_Q1__c, Average_incentive_for_Q2__c, Average_incentive_for_Q3__c, Avg_qtrly_incentive__c,
     Incentive_Monthly_or_Quarterly__c, Receips1_Doc__c, Receips2_Doc__c, Receips3_Doc__c, Receips4_Doc__c, Receips5_Doc__c, Receips6_Doc__c, Month4_Doc__c, Month5_Doc__c,
     Selected1__c, Month1_Doc__c, Month2_Doc__c, Month3_Doc__c, Year1_Doc__c, Year2_Doc__c, Year3_Doc__c, LAP_EMI__c, Construction_Valuation_1__c, Construction_Valuation_2__c,
     Sal_Deviation_on_FOIR__c, Sal_MUE_Funding__c, sal_max_loan__c, LAP_pmt__c, Interest_on_term_loans__c, Bounces_in_Latest_3_Months__c, App_Mon_Income__c, Monthly_CC_OD_interest__c, ELC_Line_Amounts__c,
     Rental_Income__c, Adjusted_Rental_Income__c, SAL_Max_FOIR_as_BFL__c, New_Sal_Deviation_on_FOIR__c, MLA_for_Unlisted_Pvt__c, Applicable_FOIR1__c, Unsecured_FOIR__c, Secured_FOIR__c,
     Deviation_on_FOIR__c, max_loan_POS_forExSAL__c, Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c, Max_Loan_Amount_for_IT_Company__c, Average_Monthly_Net_Income2__c,
     Bank_Details__r.Average_Balance__c, Existing_HL_EMI__c, Bank_Details__r.Sum_of_average_Balance__c, Bank_Details__r.Transaction_Count__c, Average_Bank_Balance__c, id, Average_monthly_Obligations__c, Avg_Mthly_Net_Inc1__c, Income_from_CY__c, ELIGIBILITY_ACCORDING_TO_GROSS_RECEIPTS__c, ELIGIBILITY_ACCORDING_TO_CASH_PROFITS_ME__c, Eligible_Loan_amt_Bank__c,
     Loan_elig_TO__c, EMI_of_The_Loan__c, Rental_Income_to_be_considered__c, Eligible_FOIR__c, Eligible_Loan__c, Multiplier__c, Selected_Option_TO__c, Live_unsecured_loan__c,Business_Continuty__c,EMI_Doc__c
     from cam__c where loan_application__c = : loan.Id
    ];
    if (camList != null && camList.size() > 0) {
     cam = camList[0];
    }
    
    applicantList = [select id,PAN_Number__c, /*SAL IM Rohit start */ SME_Score__c,/*SAL IM Rohit end */Sent_back_to_sales_SMS_sent__c, EMI_Holidays_Across_tenure__c, EMI_Holiday_Opted__c, Months_per_year__c, Cycle_Day_Date__c, EMI_Holiday_Months__c, EMI_Due_Date__c, Contact_Name__r.office_no_check_on_company_site__c, Contact_Name__r.SFDC_Dedupe_check__c, Contact_Name__r.PAN_Response__c, Contact_Name__r.Linkedin_check_result__c, Contact_Name__r.Google_check_result__c, Contact_Name__r.PAN__c, Contact_Name__r.Last_Modified_Date__c, Contact_Name__r.Name_of_the_PAN_holder__c, Contact_Name__r.Employer__r.Domain_Name__c, Contact_Name__r.Employer__r.Company_Category__c, Existing_Customer__c, Owned_Residence__c, Is_spouse_Working_Financial_CoApp__c, Loan_Application__r.Scheme_Master__c, Name, Contact_Name__r.Mobile__c, Loan_Application__r.Requested_ROI__c, Loan_Application__r.Sourcing_Channel__r.branch__c, Loan_Application__r.Referral__c, Loan_Application__r.Existing_Customer__c, Loan_Application__r.Account.Sourcing_Channel__r.branch__c, Update_CIBIL_Error__c, Descriptin__c, Type_of_Borrower__c, Re_Initiate_De_Dupe__c, Integrate_with_CIBIL__c, Contact_Name__c, Contact_Name__r.Name, Contact_Name__r.Customer_Profile__c,
     Contact_Name__r.Designation__c, Contact_Name__r.Employer_Name__c, Contact_Name__r.Qualification__c, Contact_Name__r.Address_1__c, Contact_Name__r.Total_Work_Experience_Yrs__c, Contact_Name__r.Current_experiance_in_Years__c,
     PD_Status__c, Bank_Status__c, Contact_Name__r.Address_2__c, FCU_Status__c, ITR_Status__c, Office_SE_Status__c, Office_SAL_Status__c, Contact_Name__r.Company_Category__c, Contact_Name__r.Current_experiance_in_Month__c,
     Office_Status__c, Pay_Slips_Status__c, Residence_Status__c, Trade_Status__c, TVR_Status__c, Select_Applicant__c, Applicant_Type__c, Contact_Name__r.Customer_Type__c, Contact_Name__r.ApplicantType__c,
     Contact_Name__r.Date_of_Birth__c, Contact_Name__r.FathersHusbands_Name__c, Contact_Name__r.PAN_Number__c, Contact_Name__r.Year_of_Incorporation__c, Contact_Name__r.Account.TIN_Number__c,
     Contact_Name__r.Bank_Account_No__c, Contact_Name__r.VoterID_Number__c, Contact_Name__r.ROC_Regn_No__c, Contact_Name__r.Address_3__c, Contact_Name__r.AppCity__c, Contact_Name__r.Residence_Type__c,
     Contact_Name__r.Pin_Code__c, Contact_Name__r.Phone, Contact_Name__r.MobilePhone, Contact_Name__r.Email, Contact_Name__r.Address_Line_One__c, Contact_Name__r.Address_2nd_Line__c, Contact_Name__r.Address_3rd_Line__c,Contact_Name__r.Current_Employment_Vintage__c,
     Contact_Name__r.Permanent_Land_Mark__c, Contact_Name__r.Office_City__c, Contact_Name__r.Office_Pin_Code__c, Contact_Name__r.Office_STD_Code__c, Contact_Name__r.Office_Phone_Number__c, SegmentaionResult__c,
     Contact_Name__r.Mobile_Phone__c, Contact_Name__r.Office_Email_Id__c, Contact_Name__r.Middle_Name__c, Employer__c, Company_Type__c, Company_Name__c, Contact_Name__r.Company_Type__c, Contact_Name__r.Age_of_Applicant__c,
     DIN_No_if_applicable__c, Contact_Name__r.FirstName, Contact_Name__r.LastName, Contact_Name__r.Permanant_Address_Line_1__c, Contact_Name__r.Permanant_Address_Line_2__c, Contact_Name__r.Permanant_Address_Line_3__c,
     Contact_Name__r.Permanent_STD__c, Contact_Name__r.Permanent_Pin_Code__c, Contact_Name__r.Year_in_Present_Job__c, Contact_Name__r.Year_in_Previous_Job__c, Contact_Name__r.Name_of_the_company_Employer__c,
     Contact_Name__r.Nature_of_Business__c, Contact_Name__r.Employment_Status__c, Contact_Name__r.Gender__c, Contact_Name__r.Age__c, Contact_Name__r.Employment_Type__c, Contact_Name__r.STD_Code__c, Contact_Name__r.Phone_Number__c,
     Contact_Name__r.Name_of_Employer__c, Designation__c, Contact_Name__r.Type_Of_Constitution__c, Contact_Name__r.Marital_Status__c, Contact_Mobile__c, Contact_Name__r.Residence_City__c, Contact_Name__r.Sex__c,
     Contact_Name__r.Employer__r.name, Contact_Name__r.TAN_Number__c, Contact_Name__r.TAN_Found_In_Master__c, Contact_Name__r.Email_Domain_Status__c, Contact_Name__r.Bank_Name1__c, CIBIL_Score__c,
     Contact_Name__r.Bank_Name_Status1__c, Contact_Name__r.PAN_Card_Status__c, Comments__c, Contact_Name__r.CIBIL_Report__c, Contact_Name__r.Office_Email_Id_for_Fraud__c, Contact_Name__r.TAN__c,
     All_Deviation_Docs_Received__c, All_Disbursement_Docs_Received__c, All_Standard_Docs_Received__c, Is_PL_BT__c, ContactName__c, Contact_Name__r.Years_At_Residence__c,
     Customer_Name__c, Loan_Application__r.Account.id, Contact_ID__c, Customer_ID__c, Product__c, IsUpdated__c, Decision_Date__c, RSA_reason__c, Loan_App_Number_up__c, DeDupe_Counter__c,
     Loan_Application__r.Product__c, Loan_Application__r.Account.Sourcing_Channel__c, Loan_Application__r.Account.Tenor__c, Loan_Application__r.Account.Referral_Name__c, Sub_Segment__c,
     Loan_Application__r.Employee_Type__c, Loan_Application__r.Loan_Application_Number__c, Loan_Application__r.Loan_Amount__c, Loan_Application__r.Tenor__c,
     TotalFOIRHLResult__c, TotalFOIRNoHLResult__c, TotalWorkExpResult__c, UnsecuredFOIRResult__c, LoanAmountResult__c, CurrentWorkExpResult__c,
     OwnHouse_RunningHLResult__c, CompanyCategoryResult__c, EducationQualificationResult__c, Segment_Prudense__c, Segment_Stability__c, Contact_Name__r.Age_Round_Down__c,
     Segment_Achievment__c, SalaryToAgeResult__c, Bureau_Segment__c, StepUp_StepDown_EMI_Year_1__c, StepUp_StepDown_EMI_Year_2__c, StepUp_StepDown_EMI_Year_3__c, StepUp_StepDown_EMI_Year_4__c, StepUp_StepDown_EMI_Year_5__c
     from Applicant__c where Loan_Application__c = : LoanId
    ];
    integer appsize = applicantList.size();
     for (integer i = 0; i < appsize; i++) {
      
      if (applicantList[i].Applicant_Type__c == 'Primary') {
       applicantPrimary = new Applicant__c();
       applicantPrimary = applicantList[i];
       
      }
      
       if (applicantPrimary != null)
    {
     cibilExt1List = [select id, X6_months_DPD__c, Other_Loan_DPD__c, X4to8_enquiries__c, X6_To_8_Enq__c, X8plus_Enquiries__c,Applicant__r.Applicant_Type__c,Total_no_of_loans_Excluding_CC__c, 
      X10_currbalance__c, Write_Off__c, Average_Total_Balance__c,Tradelines_30plus_DPD__c ,Number_of_Hl_Loans__c,First_Loan_MOB__c,loan_Vintage_SAL_IM__c,No_Of_Live_Trades__c,Mortgage_Count_and_Amount__c 
      from Cibil_Extension1__c where Applicant__c = : applicantPrimary.id
     ];
    }
      
      AllConlist.add(applicantList[i].Contact_Name__c);
    
      }
      if (applicantPrimary != null && applicantPrimary.Contact_Name__c != null) {
     List < Contact > conList = new List < Contact > ();
     conList = [select id, College__c, Customer_Profile__c, Customer_Type__c, Email_Confirmation_received__c, Customer_address_matches_with_eKYC__c, Customer_entered_address__c, eKYC_Address__c, Perfios_Address__c,
      Customer_address_matches_with_perfios__c, Address_1__c, Address_2__c, Address_3__c, Company_Category__c, Company_Type__c, Office_Email_Id__c, Residence_Type__c, Current_Employment_Vintage__c, Total_Work_Experience_Yrs__c, Current_experiance_in_Years__c,
      Educational_Qualification__c, Qualification__c, Date_of_Birth__c, Employer_Name__c, FathersHusbands_Name__c, PAN_Number__c, Year_of_Incorporation__c,
      Account.TIN_Number__c, Bank_Account_No__c, VoterID_Number__c, ROC_Regn_No__c, AppCity__c, Pin_Code__c, Phone, MobilePhone, Email,
      Address_2nd_Line__c, Address_3rd_Line__c, Address_Line_One__c, Permanent_Land_Mark__c, Office_City__c, Office_Pin_Code__c, Office_STD_Code__c,
      Office_Phone_Number__c, Mobile_Phone__c, FirstName, Middle_Name__c, LastName, Customer_Add_Matches_With_Previous_Add__c from contact where id in : AllConlist
     ];

     if (conList != null && conList.size() > 0) {
      for (Contact conobj: conList) {
       if (conobj.id == applicantPrimary.Contact_Name__c)
        cont = conList[0];
      

      }
     }
    
     }
    }
    //added for bug id 19368/21851 start
   public static String getStaticResourceData(String StaticResourceName,String SRContentName,String SRContentVersion )
    {    
        StaticResource srObject = [select id,body from StaticResource Where Name =:StaticResourceName limit 1];
        String value; 
        Map<String,object> ALLMap = (Map<String,object>) JSON.deserializeUntyped(srObject.body.toString());
       
        if(string.isNotBlank(SRContentVersion)){
        Map<String,object> AadharConsentMap =(Map<String,object>) ALLMap.get(SRContentName);
        if(SRContentVersion == 'BFL_PRIME')
            value = JSON.serialize(AadharConsentMap);
        else
            value= (string) AadharConsentMap.get((string)ALLMap.get(SRContentVersion));  
        }
        else
          value  =(String)ALLMap.get(SRContentName);
        return value;
   
    }
    public static boolean getAadhaarSectionStatus(String StaticResourceName,String SRContentName,String SRContentVersion ){    
        Boolean hideAadharSection = Boolean.valueOf(getStaticResourceData(StaticResourceName,SRContentName,SRContentVersion));
        return hideAadharSection;
    }
      public static Map < String, String > BRECalloutForInvisibleMonitoring(String typeOfCall, String groupCode, Id Loan_id) {
    LoanId=Loan_id;
    dataforIM();
   Map < String, String > mapOfInvisibleMonitoringParams = new Map < String, String > ();
   SurrogateCAM__c surrogateCAM;
   //List<SurrogateCAM__c> surrogateCAMList = [SELECT CY_Audited_Turnover__c, PY_Sales_Turnover__c, PBDT_Growth_over_last_year__c, Turnover_Change__c, CY_Net_Profit__c, PY_Net_Profit__c, Applicant__r.Applicant_Type__c FROM SurrogateCAM__c WHERE Applicant__r.Loan_Application__c =: LoanId];
   //system.debug('SurrogateCAM List ---->' + scamList);

   List < Bank_Summary__c > BankSummaryList = [SELECT Avg_of_Bounce_IW__c, Avg_of_Bounce_OW__c, Sum_of_Bounce_IW__c, Sum_of_Bounce_OW__c, Sum_of_Credit_No__c, Sum_of_Debit_No__c, CRD_No_Count__c, DB_count__c, Applicant__r.Applicant_Type__c, Bounce_I_W_Count__c, Bounce_O_W_Count__c
    FROM Bank_Summary__c WHERE Loan_Application__c = : LoanID
   ];

   system.debug('BankSummary List ---->' + BankSummaryList);

   List < CIBIL__c > cibilVarList = [SELECT Total_Loans__c, Total_Enquiries__c, CIBIL_Score__c, Applicant__r.Applicant_Type__c,
    Account_Info__c, Account_Info1__c, Account_Info2__c, Account_Info3__c, Account_Info4__c, Account_Info5__c, Account_Info6__c,
    Account_Info7__c, Account_Info8__c, Account_Info9__c, Account_Info10__c, Account_Info11__c, Account_Info12__c, Account_Info13__c,
    Account_Info14__c, Account_Info15__c, Account_Info16__c, Account_Info17__c, Account_Info18__c, Account_Info19__c,
    Account_Type__c, Account_Type1__c, Account_Type2__c, Account_Type3__c, Account_Type4__c, Account_Type5__c, Account_Type6__c,
    Account_Type7__c, Account_Type8__c, Account_Type9__c, Account_Type10__c, Account_Type11__c, Account_Type12__c, Account_Type13__c,
    Account_Type14__c, Account_Type15__c, Account_Type16__c, Account_Type17__c, Account_Type18__c, Account_Type19__c,
    Amount_Overdue__c, Amount_Overdue1__c, Amount_Overdue2__c, Amount_Overdue3__c, Amount_Overdue4__c, Amount_Overdue5__c, Amount_Overdue6__c,
    Amount_Overdue7__c, Amount_Overdue8__c, Amount_Overdue9__c, Amount_Overdue10__c, Amount_Overdue11__c, Amount_Overdue12__c, Amount_Overdue13__c,
    Amount_Overdue14__c, Amount_Overdue15__c, Amount_Overdue16__c, Amount_Overdue17__c, Amount_Overdue18__c, Amount_Overdue19__c,
    Current_Balance__c, Current_Balance1__c, Current_Balance2__c, Current_Balance3__c, Current_Balance4__c, Current_Balance5__c, Current_Balance6__c,
    Current_Balance7__c, Current_Balance8__c, Current_Balance9__c, Current_Balance10__c, Current_Balance11__c, Current_Balance12__c, Current_Balance13__c,
    Current_Balance14__c, Current_Balance15__c, Current_Balance16__c, Current_Balance17__c, Current_Balance18__c, Current_Balance19__c,
    Date_Closed__c, Date_Closed1__c, Date_Closed2__c, Date_Closed3__c, Date_Closed4__c, Date_Closed5__c, Date_Closed6__c,
    Date_Closed7__c, Date_Closed8__c, Date_Closed9__c, Date_Closed10__c, Date_Closed11__c, Date_Closed12__c, Date_Closed13__c,
    Date_Closed14__c, Date_Closed15__c, Date_Closed16__c, Date_Closed17__c, Date_Closed18__c, Date_Closed19__c,
    Sanction_Amount__c, Sanction_Amount1__c, Sanction_Amount2__c, Sanction_Amount3__c, Sanction_Amount4__c, Sanction_Amount5__c, Sanction_Amount6__c,
    Sanction_Amount7__c, Sanction_Amount8__c, Sanction_Amount9__c, Sanction_Amount10__c, Sanction_Amount11__c, Sanction_Amount12__c, Sanction_Amount13__c,
    Sanction_Amount14__c, Sanction_Amount15__c, Sanction_Amount16__c, Sanction_Amount17__c, Sanction_Amount18__c, Sanction_Amount19__c,
    Maximum_Sanctioned_amount__c, Maximum_Loan_Type__c,Date_Opened__c
    FROM CIBIL__c WHERE Applicant__r.Loan_Application__c = : LoanID
   ];

   system.debug('CIBIL List ---->' + cibilVarList);

   CIBIL__c cibilVar;
   Bank_Summary__c BankSummary;
   Bank_Account__c bankAcc;
   Cibil_Extension1__c cibilExt1;

   // Already present
   if (scamList != null && scamList.size() > 0) {
    for (SurrogateCAM__c scTemp: scamList) {
     if (scTemp.Applicant__r.Applicant_Type__c == 'Primary')
      surrogateCAM = scTemp;
    }
   }

   // Already present
   if (cibilExt1List != null && cibilExt1List.size() > 0) {
    for (Cibil_Extension1__c cibilExt1Temp: cibilExt1List) {
     if (cibilExt1Temp.Applicant__r.Applicant_Type__c == 'Primary')
      cibilExt1 = cibilExt1Temp;
    }
    system.debug('CIBIL Extension Primary Applicant ---->' + cibilExt1);
   }

   // Already present
   if (bankAccLst != null && bankAccLst.size() > 0) {
    for (Bank_Account__c bankAccTemp: bankAccLst) {
     if (bankAccTemp.Applicant__r.Applicant_Type__c == 'Primary')
      bankAcc = bankAccTemp;
    }
    system.debug('Bank Account Primary Applicant ---->' + bankAcc);
   }

   // Only for Invisible Monitoring
   if (cibilVarList != null && cibilVarList.size() > 0) {
    for (CIBIL__c cibilListTemp: cibilVarList) {
     if (cibilListTemp.Applicant__r.Applicant_Type__c == 'Primary')
      cibilVar = cibilListTemp;
    }
    system.debug('CIBIL Primary Applicant ---->' + cibilVar);
   }

   // Only for Invisible Monitoring
   if (BankSummaryList != null && BankSummaryList.size() > 0) {
    for (Bank_Summary__c bankSummaryTemp: BankSummaryList) {
     if (bankSummaryTemp.Applicant__r.Applicant_Type__c == 'Primary')
      BankSummary = bankSummaryTemp;
    }
    system.debug('BankSummary Primary Applicant ---->' + BankSummary);
   }

   mapOfInvisibleMonitoringParams.put('loan_id', (Loan != null && Loan.Loan_Application_Number__c != null) ? String.valueof(Loan.Loan_Application_Number__c) : '');
   mapOfInvisibleMonitoringParams.put('reqested_roi', (surrogateCAM != null && surrogateCAM.ROI__c != null) ? String.valueof(surrogateCAM.ROI__c) : '0');
   if(loan.product__c == 'SAL')
   {
   mapOfInvisibleMonitoringParams.put('product', '');
   }
   else
   {
   mapOfInvisibleMonitoringParams.put('product', 'INVISIBLE MONITORING');
   }
   mapOfInvisibleMonitoringParams.put('type_of_loan', typeOfCall);
   mapOfInvisibleMonitoringParams.put('groupCode', groupCode);
   mapOfInvisibleMonitoringParams.put('applicant_type', 'Primary');

   mapOfInvisibleMonitoringParams.put('type_of_constitution', (Loan != null && Loan.Type_Of_Constitution__c != null) ? String.valueof(Loan.Type_Of_Constitution__c) : '');
   //mapOfInvisibleMonitoringParams.put('total_employment_vintage', (applicantPrimary != null && applicantPrimary.Contact_Name__r.Total_Employment_vintage_Year__c != null) ? String.valueof(applicantPrimary.Contact_Name__r.Total_Employment_vintage_Year__c) : '0');
   mapOfInvisibleMonitoringParams.put('constitutionType', (Loan != null && Loan.Type_Of_Constitution__c != null) ? String.valueof(Loan.Type_Of_Constitution__c) : '');
   //Rohit Changed customer type Bug 13372
   mapOfInvisibleMonitoringParams.put('customer_type', (applicantPrimary != null && applicantPrimary.Contact_Name__r != null && applicantPrimary.Contact_Name__r.Customer_Type__c!= null) ? String.valueof(applicantPrimary.Contact_Name__r.Customer_Type__c) : '');
   mapOfInvisibleMonitoringParams.put('customer_segment', (applicantPrimary != null && applicantPrimary.SegmentaionResult__c != null) ? String.valueof(applicantPrimary.SegmentaionResult__c) : '');

   //SAL Invisible monitoring Rohit (additional parameters for sampling) start
   //System.debug('rohit33 '+applicantPrimary.Contact_Name__r.Company_Category__c);
   mapOfInvisibleMonitoringParams.put('company_Type',(applicantPrimary != null && applicantPrimary.Contact_Name__r.Company_Category__c!=null) ? applicantPrimary.Contact_Name__r.Company_Category__c :'' );
   mapOfInvisibleMonitoringParams.put('total_no_of_loans_excl_cc', (cibilExt1 != null && cibilExt1.Total_no_of_loans_Excluding_CC__c != null) ? cibilExt1.Total_no_of_loans_Excluding_CC__c + '' : '0');
   //Rohit Bug 13399 start
   //mapOfInvisibleMonitoringParams.put('current_Employment_Vintage', (applicantPrimary != null && applicantPrimary.Contact_Name__r.Current_Employment_Vintage__c != null) ? String.valueof(applicantPrimary.Contact_Name__r.Current_Employment_Vintage__c): '0');
   
   if(loan!= null && loan.Account!=null && Loan.Account.Current_experiance_in_Years__c!=null && Loan.Account.Current_experiance_in_Month__c!=null)
    {
       
        mapOfInvisibleMonitoringParams.put('current_Employment_Vintage',String.valueof(Loan.Account.Current_experiance_in_Years__c) +'.' +String.valueof(Loan.Account.Current_experiance_in_Month__c));
    }
    else if(loan!= null && loan.Account!=null && Loan.Account.Current_experiance_in_Years__c!=null && Loan.Account.Current_experiance_in_Month__c==null ) 
    {
        mapOfInvisibleMonitoringParams.put('current_Employment_Vintage', String.valueof(Loan.Account.Current_experiance_in_Years__c));
    }
    else if(loan!= null && loan.Account!=null && Loan.Account.Current_experiance_in_Years__c==null && Loan.Account.Current_experiance_in_Month__c!=null)
    {
        mapOfInvisibleMonitoringParams.put('current_Employment_Vintage', '.'+String.valueof(Loan.Account.Current_experiance_in_Month__c));
    }
    else
    {
        mapOfInvisibleMonitoringParams.put('current_Employment_Vintage','0');
    }
     System.debug('rohit33 '+mapOfInvisibleMonitoringParams.get('current_Employment_Vintage'));
   
   //Rohit Bug 13399 end
   mapOfInvisibleMonitoringParams.put('businessVintage', (cibilExt1 != null && cibilExt1.loan_Vintage_SAL_IM__c!= null) ? String.valueof(cibilExt1.loan_Vintage_SAL_IM__c) : '0');

   //SAL Invisible monitoring Rohit (additional parameters for sampling) end
   
   mapOfInvisibleMonitoringParams.put('residence_type', (applicantPrimary != null && applicantPrimary.Contact_Name__r.Residence_Type__c != null) ? STring.valueOf(applicantPrimary.Contact_Name__r.Residence_Type__c) : '');
   System.debug('prashant '+mapOfInvisibleMonitoringParams.get('residence_type'));
   mapOfInvisibleMonitoringParams.put('nature_of_business', (Loan != null && Loan.Nature_of_Business__c != null) ? String.valueof(Loan.Nature_of_Business__c) : '');
   mapOfInvisibleMonitoringParams.put('industry', (Loan != null && Loan.Industry__r.Industry__c != null) ? String.valueof(Loan.Industry__r.Industry__c) : '');
   mapOfInvisibleMonitoringParams.put('industrySector', (Loan != null && Loan.Main_Sector__r.Sector__c != null) ? String.valueof(Loan.Main_Sector__r.Sector__c) : '');
   mapOfInvisibleMonitoringParams.put('mainIndustry', (Loan != null && Loan.Main_Industry__c != null) ? String.valueof(Loan.Main_Industry__c) : '');
   mapOfInvisibleMonitoringParams.put('sub_industry', (Loan != null && Loan.Main_Sub_Industry__c != null) ? String.valueof(Loan.Main_Sub_Industry__c) : '');
   mapOfInvisibleMonitoringParams.put('residence_city', (applicantPrimary != null && applicantPrimary.Contact_Name__r.Residence_City__c != null) ? String.valueof(applicantPrimary.Contact_Name__r.Residence_City__c) : '');
   mapOfInvisibleMonitoringParams.put('existingCDCustFlag', (Loan != null && Loan.Existing_Customer__c == 'Existing Customer') ? 'true' : (Loan.Existing_Customer__c == 'New Customer' ? 'false' : 'false'));
   mapOfInvisibleMonitoringParams.put('existingBLCustFlag', (Loan != null && Loan.Existing_Customer__c == 'Existing Customer') ? 'true' : (Loan.Existing_Customer__c == 'New Customer' ? 'false' : 'false'));
   mapOfInvisibleMonitoringParams.put('branch_name', (Loan != null && Loan.Branch_Name__r.Name != null) ? String.valueof(Loan.Branch_Name__r.Name) : '');
   mapOfInvisibleMonitoringParams.put('branch_type', (Loan != null && Loan.Branch_Type1__c != null) ? String.valueof(Loan.Branch_Type1__c) : '');
   mapOfInvisibleMonitoringParams.put('approved_loan_amount', (Loan != null && Loan.Approved_Loan_Amount__c != null) ? String.valueof(Loan.Approved_Loan_Amount__c) : '0');
   mapOfInvisibleMonitoringParams.put('stage', (Loan != null && Loan.stageName != null) ? String.valueof(Loan.stageName) : '');
   mapOfInvisibleMonitoringParams.put('totalEMI', (Loan != null && Loan.Total_EMI__c != null) ? String.valueof(Loan.Total_EMI__c) : '');
   mapOfInvisibleMonitoringParams.put('decision_date', (Loan != null && Loan.Decision_Date__c != null) ? String.valueof(Loan.Decision_Date__c) : '');
   mapOfInvisibleMonitoringParams.put('loanApplicationName', (Loan != null && Loan.Name != null) ? String.valueof(Loan.Name) : '');
   mapOfInvisibleMonitoringParams.put('scheme_name', (Loan != null && Loan.Scheme_Master__r.Name != null) ? String.valueof(Loan.Scheme_Master__r.Name) : '');
   mapOfInvisibleMonitoringParams.put('sourcingChannelMobile', (Loan != null && Loan.Sourc_Mobile__c != null) ? String.valueof(Loan.Sourc_Mobile__c) : '');
   mapOfInvisibleMonitoringParams.put('approved_rate', (Loan != null && Loan.Approved_Rate__c != null) ? String.valueof(Loan.Approved_Rate__c) : '0');
   
   mapOfInvisibleMonitoringParams.put('premiumAmount', (Loan != null && Loan.Premium_Amount__c != null) ? String.valueof(Loan.Premium_Amount__c) : '0');
   if(loan.product__c == 'SAL' || loan.product__c == 'SPL') //condition added by Rohit for SAL IM
   {
   mapOfInvisibleMonitoringParams.put('sourcingChannel', 'AIDING UNDERWRITER');
   }
   else
   {
   mapOfInvisibleMonitoringParams.put('sourcingChannel', (Loan != null && Loan.Sourcing_Channel__r.Name != null) ? String.valueof(Loan.Sourcing_Channel__r.Name) : '');
   }
   mapOfInvisibleMonitoringParams.put('creditProgram', (Loan != null && Loan.Credit_Program__c != null) ? String.valueof(Loan.Credit_Program__c) : '');
   mapOfInvisibleMonitoringParams.put('existingCustomerFlag', (Loan != null && Loan.Existing_Customer__c == 'Existing Customer') ? 'true' : (Loan.Existing_Customer__c == 'New Customer' ? 'false' : 'false'));
   mapOfInvisibleMonitoringParams.put('totalLoanAmount', (Loan.Total_Loan_amount__c != null) ? String.valueof(Loan.Total_Loan_amount__c) : '0');
   mapOfInvisibleMonitoringParams.put('riskyDSA', (Loan != null && Loan.Sourcing_Channel__r.Risky_DSA__c != null) ? String.valueof(Loan.Sourcing_Channel__r.Risky_DSA__c) : '');

   mapOfInvisibleMonitoringParams.put('pdType', (pd != null && pd.Type_of_PD__c != null) ? String.valueof(pd.Type_of_PD__c) : '');
  //sal IM pan capital 
       mapOfInvisibleMonitoringParams.put('PAN', (applicantPrimary != null && applicantPrimary.PAN_Number__c != null) ? String.valueof(applicantPrimary.PAN_Number__c) : '');

   mapOfInvisibleMonitoringParams.put('pan', (applicantPrimary != null && applicantPrimary.PAN_Number__c != null) ? String.valueof(applicantPrimary.PAN_Number__c) : '');
   mapOfInvisibleMonitoringParams.put('SMEScore', (applicantPrimary != null && applicantPrimary.SME_Score__c != null) ? String.valueof(applicantPrimary.SME_Score__c) : '0');
   //mapOfInvisibleMonitoringParams.put('age', (applicantPrimary != null && applicantPrimary.Contact_Name__r.Age_of_Applicant__c != null) ? String.valueof(applicantPrimary.Contact_Name__r.Age_of_Applicant__c) : '0');

   mapOfInvisibleMonitoringParams.put('total_bounce_inward', (BankSummary != null && BankSummary.Inward_Return__c != null) ? String.valueof(BankSummary.Inward_Return__c) : '0');
   mapOfInvisibleMonitoringParams.put('total_bounce_outward', (BankSummary != null && BankSummary.Outward_Return__c != null) ? String.valueof(BankSummary.Outward_Return__c) : '0');
   mapOfInvisibleMonitoringParams.put('credit_trans_banking_count', (BankSummary != null && BankSummary.CRD_No_Count__c != null) ? String.valueof(BankSummary.CRD_No_Count__c) : '0');
   mapOfInvisibleMonitoringParams.put('debit_trans_banking_count', (BankSummary != null && BankSummary.DB_count__c != null) ? String.valueof(BankSummary.DB_count__c) : '0');
   mapOfInvisibleMonitoringParams.put('typeofBanking', (Loan != null && Loan.A_C_Type__c != null) ? String.valueof(Loan.A_C_Type__c) : '');

   mapOfInvisibleMonitoringParams.put('bankAccountNumber', (bankAcc != null && bankAcc.Bank_Acct_Number__c != null) ? String.valueof(bankAcc.Bank_Acct_Number__c) : '');
   mapOfInvisibleMonitoringParams.put('bankAccountType', (bankAcc != null && bankAcc.Account_Type__c != null) ? String.valueof(bankAcc.Account_Type__c) : '');

   mapOfInvisibleMonitoringParams.put('btBankName', (bankAcc != null && bankAcc.Bank_Name__c != null) ? String.valueof(bankAcc.Bank_Name__c) : '');

   mapOfInvisibleMonitoringParams.put('odccUtilization', (surrogateCAM != null && surrogateCAM.BL_ODCC_Utilization__c != null) ? String.valueof(surrogateCAM.BL_ODCC_Utilization__c) : '0');
   mapOfInvisibleMonitoringParams.put('avg_od_cc_utilisation', (surrogateCAM != null && surrogateCAM.BL_ODCC_Utilization__c != null) ? String.valueof(surrogateCAM.BL_ODCC_Utilization__c) : '0');
   
   //Rohit Bug 13413 start
   
   
    if(loan!= null && loan.Account!=null && Loan.Account.Total_Work_Experience_Yrs__c!=null && Loan.Account.Total_Work_Experience_Months__c!=null)
    {
       
        mapOfInvisibleMonitoringParams.put('total_Employment_Vintage',String.valueof(Loan.Account.Total_Work_Experience_Yrs__c) +'.' +String.valueof(Loan.Account.Total_Work_Experience_Months__c));
    }
    else if(loan!= null && loan.Account!=null && Loan.Account.Total_Work_Experience_Yrs__c!=null && Loan.Account.Total_Work_Experience_Months__c==null ) 
    {
        mapOfInvisibleMonitoringParams.put('total_Employment_Vintage', String.valueof(Loan.Account.Total_Work_Experience_Yrs__c));
    }
    else if(loan!= null && loan.Account!=null && Loan.Account.Total_Work_Experience_Yrs__c==null && Loan.Account.Total_Work_Experience_Months__c!=null)
    {
        mapOfInvisibleMonitoringParams.put('total_Employment_Vintage', '.'+String.valueof(Loan.Account.Total_Work_Experience_Months__c));
    }
    else
    {
        mapOfInvisibleMonitoringParams.put('total_Employment_Vintage','0');
    }
     System.debug('rohit33 '+mapOfInvisibleMonitoringParams.get('total_Employment_Vintage'));
   //Rohit Bug 13413 end
      
   //mapOfInvisibleMonitoringParams.put('total_Employment_Vintage', (surrogateCAM != null && surrogateCAM.CY_Business_Vintage__c != null) ? String.valueof(surrogateCAM.CY_Business_Vintage__c) : '0');
   System.debug('rohit40 '+mapOfInvisibleMonitoringParams.get('total_Employment_Vintage'));
   //Rohit Bug 13399 start
      mapOfInvisibleMonitoringParams.put('customer_category',(applicantPrimary != null && applicantPrimary.Existing_Customer__c!= null) ? String.valueof(applicantPrimary.Existing_Customer__c) : '');
   //Rohit Bug 13399 end
   mapOfInvisibleMonitoringParams.put('cy_sales_turnover', (surrogateCAM != null && surrogateCAM.CY_Audited_Turnover__c != null) ? String.valueof(surrogateCAM.CY_Audited_Turnover__c) : '0');
   mapOfInvisibleMonitoringParams.put('py_sales_turnover', (surrogateCAM != null && surrogateCAM.PY_Sales_Turnover__c != null) ? String.valueof(surrogateCAM.PY_Sales_Turnover__c) : '0');
   mapOfInvisibleMonitoringParams.put('cy_net_profit', (surrogateCAM != null && surrogateCAM.CY_Net_Profit__c != null) ? String.valueof(surrogateCAM.CY_Net_Profit__c) : '0');
   mapOfInvisibleMonitoringParams.put('py_net_profit', (surrogateCAM != null && surrogateCAM.PY_Net_Profit__c != null) ? String.valueof(surrogateCAM.PY_Net_Profit__c) : '0');
   mapOfInvisibleMonitoringParams.put('debtorsTurnoverDays', (surrogateCAM != null && surrogateCAM.Debtor_Turnover_Days__c != null) ? String.valueof(surrogateCAM.Debtor_Turnover_Days__c) : '0');
   mapOfInvisibleMonitoringParams.put('creditSMEScore', (surrogateCAM != null && surrogateCAM.Credit_SME_Score__c != null) ? String.valueof(surrogateCAM.Credit_SME_Score__c) : '0');
   mapOfInvisibleMonitoringParams.put('creditorsTurnoverDays', (surrogateCAM != null && surrogateCAM.Creditor_Turnover_Days__c != null) ? String.valueof(surrogateCAM.Creditor_Turnover_Days__c) : '0');
   mapOfInvisibleMonitoringParams.put('stockTurnoverDays', (surrogateCAM != null && surrogateCAM.Stock_Turnover_Days__c != null) ? String.valueof(surrogateCAM.Stock_Turnover_Days__c) : '0');
   mapOfInvisibleMonitoringParams.put('cashConversionCycle', (surrogateCAM != null && surrogateCAM.Cash_Conversion_Cycle_In_Days__c != null) ? String.valueof(surrogateCAM.Cash_Conversion_Cycle_In_Days__c) : '0');
   mapOfInvisibleMonitoringParams.put('currentRatio', (surrogateCAM != null && surrogateCAM.Current_Ratio__c != null) ? String.valueof(surrogateCAM.Current_Ratio__c) : '0');
   mapOfInvisibleMonitoringParams.put('cy_total_networth', (surrogateCAM != null && surrogateCAM.Total_Net_Worth__c != null) ? String.valueof(surrogateCAM.Total_Net_Worth__c) : '0');
   mapOfInvisibleMonitoringParams.put('networkingCapital', (surrogateCAM != null && surrogateCAM.Net_Working_Capital__c != null) ? String.valueof(surrogateCAM.Net_Working_Capital__c) : '0');
   mapOfInvisibleMonitoringParams.put('netProfitMargin', (surrogateCAM != null && surrogateCAM.Net_Profit_Margin__c != null) ? String.valueof(surrogateCAM.Net_Profit_Margin__c) : '0');
   mapOfInvisibleMonitoringParams.put('annualizedBTO', (surrogateCAM != null && surrogateCAM.BL_Annualised_BTO__c != null) ? String.valueof(surrogateCAM.BL_Annualised_BTO__c) : '0');
   mapOfInvisibleMonitoringParams.put('py_depriciation', (surrogateCAM != null && surrogateCAM.PY_Depreciation__c != null) ? String.valueof(surrogateCAM.PY_Depreciation__c) : '0');
   mapOfInvisibleMonitoringParams.put('cy_depriciation', (surrogateCAM != null && surrogateCAM.CY_Depreciation__c != null) ? String.valueof(surrogateCAM.CY_Depreciation__c) : '0');
   mapOfInvisibleMonitoringParams.put('odccLimit', (surrogateCAM != null && surrogateCAM.OD_CC_limit__c != null) ? String.valueof(surrogateCAM.OD_CC_limit__c) : '0');
   mapOfInvisibleMonitoringParams.put('growthInSalesTurnover', (surrogateCAM != null && surrogateCAM.Growth_in_Sales_Turnover__c != null) ? String.valueof(surrogateCAM.Growth_in_Sales_Turnover__c) : '0');

   mapOfInvisibleMonitoringParams.put('FRNnumber', (surrogateCAM != null && surrogateCAM.Membership_Number__c != null) ? surrogateCAM.Membership_Number__c : '');

   //Bug 13845 Rohit start
   
   if(applicantPrimary != null && applicantPrimary.CIBIL_Score__c != null )    
   {
       Integer cibilIndex = applicantPrimary.CIBIL_Score__c.indexOf('-');
       if(cibilIndex > 0 )
       {
            mapOfInvisibleMonitoringParams.put('CIBIL_Score', '-1');
       }     
       else
       {        
            mapOfInvisibleMonitoringParams.put('CIBIL_Score', (applicantPrimary != null && applicantPrimary.CIBIL_Score__c != null) ? String.valueof(applicantPrimary.CIBIL_Score__c) : '0');
       }   
   }
   
   //Bug 13845 Rohit end
   mapOfInvisibleMonitoringParams.put('total_no_of_loans', (cibilVar != null && cibilVar.Total_Loans__c != null) ? String.valueof(cibilVar.Total_Loans__c) : '0');
   mapOfInvisibleMonitoringParams.put('total_no_of_loans_enquiry', (cibilVar != null && cibilVar.Total_Enquiries__c != null) ? String.valueof(cibilVar.Total_Enquiries__c) : '0');
   mapOfInvisibleMonitoringParams.put('maximumSanctionedAmount', (cibilVar != null && cibilVar.Maximum_Sanctioned_amount__c != null) ? String.valueof(cibilVar.Maximum_Sanctioned_amount__c) : '0');
   mapOfInvisibleMonitoringParams.put('maxLoanType', (cibilVar != null && cibilVar.Maximum_Loan_Type__c != null) ? String.valueof(cibilVar.Maximum_Loan_Type__c) : '');
   
  //Invisible monitoring for dl by akshata 30th june 2016 (extra parameter for dl) start sourcingChannelFlag
    mapOfInvisibleMonitoringParams.put('sourcingChannelFlag', (Loan != null && Loan.Sourcing_Channel__r.Sourcing_Channel_Flag__c != null) ? String.valueof(Loan.Sourcing_Channel__r.Sourcing_Channel_Flag__c) : '');
   mapOfInvisibleMonitoringParams.put('first_name', (Loan != null && Loan.Account.First_Name__c != null) ? String.valueof(Loan.Account.First_Name__c) : '');
   mapOfInvisibleMonitoringParams.put('last_name', (Loan != null && Loan.Account.Last_Name__c != null) ? String.valueof(Loan.Account.Last_Name__c) : '');
   mapOfInvisibleMonitoringParams.put('invisibleMonitoringProduct', (Loan != null && Loan.Product__c != null) ? String.valueof(Loan.Product__c) : '');
   mapOfInvisibleMonitoringParams.put('offer_amount', (Loan != null && Loan.Approved_Loan_Amount__c != null) ? String.valueOf(Loan.Approved_Loan_Amount__c) : '0');
   mapOfInvisibleMonitoringParams.put('requested_loan_amount', (surrogateCAM !=null && surrogateCAM.Loan_Amount__c != null) ? String.valueOf(surrogateCAM.Loan_Amount__c) : '0');
   mapOfInvisibleMonitoringParams.put('years_in_business_job', (Loan != null && Loan.Account.Total_Work_Experience_Yrs__c != null) ? String.valueof(Loan.Account.Total_Work_Experience_Yrs__c) : '0');
   mapOfInvisibleMonitoringParams.put('date_of_birth',(applicantPrimary != null && applicantPrimary.Contact_Name__r.date_of_Birth__c != null) ? String.valueof(applicantPrimary.Contact_Name__r.date_of_Birth__c) : '0');
   mapOfInvisibleMonitoringParams.put('type_of_degree', (Loan != null && Loan.Account.Specialisation__c!= null) ? String.valueof(Loan.Account.Specialisation__c) : '0');
   mapOfInvisibleMonitoringParams.put('residence_ownership', (Loan != null && Loan.Account.Residence_TypeAcc__c!= null) ? String.valueof(Loan.Account.Residence_TypeAcc__c) : '0');
   mapOfInvisibleMonitoringParams.put('officeOwnership',  (Loan != null && Loan.Account.Type_of_Ownership__c!= null) ? String.valueof(Loan.Account.Type_of_Ownership__c) : '0');
   if(Loan.Product__c == 'DOCTORS')
   {
    mapOfInvisibleMonitoringParams.put('mobileMismatchWithCibil', (pd != null && pd.Did_you_sign_our_application_form__c != null) ? String.valueof(pd.Did_you_sign_our_application_form__c) : '0');
   }
   mapOfInvisibleMonitoringParams.put('residenceMismatchWithCibil', (pd != null && pd.Did_you_apply_for_a_loan_with_BFL__c != null) ? String.valueof(pd.Did_you_apply_for_a_loan_with_BFL__c) : '0');
   mapOfInvisibleMonitoringParams.put('officeMismatchWithCibil', (pd != null && pd.Did_the_executive_explain_the_document_r__c != null) ? String.valueof(pd.Did_the_executive_explain_the_document_r__c) : '0');
   mapOfInvisibleMonitoringParams.put('numberOf30DpdTradeLine', (cibilExt1 != null && cibilExt1.Tradelines_30plus_DPD__c != null) ? String.valueof(cibilExt1.Tradelines_30plus_DPD__c) : '');
   mapOfInvisibleMonitoringParams.put('verificationCode',typeOfCall);
   mapOfInvisibleMonitoringParams.put('company_category', (cont!= null && cont.Company_Category__c != null) ? String.valueof(cont.Company_Category__c) : '0');
   mapOfInvisibleMonitoringParams.put('net_Salary_for_Month1', (cam!=null && cam.Average_incentive_for_Q1__c!= null) ? String.valueof(cam.Average_incentive_for_Q1__c) : '0');
   mapOfInvisibleMonitoringParams.put('average_net_salary', (cam!=null && cam.Average_Monthly_Net_Income1__c != null) ? String.valueof(cam.Average_Monthly_Net_Income1__c) : '0');
   mapOfInvisibleMonitoringParams.put('number_of_hl_loans', (cibilExt1 != null && cibilExt1.Number_of_Hl_Loans__c != null) ? String.valueof(cibilExt1.Number_of_Hl_Loans__c) : '0');
   //Invisible monitoring for dl by akshata 30th june 2016 (extra parameter for dl) end
    
    //Rohit Bug 13479 & 13483 start
     String[] mortgageParms = new String[2];
    if(cibilExt1 !=null && cibilExt1.Mortgage_Count_and_Amount__c!=null)
       mortgageParms = cibilExt1.Mortgage_Count_and_Amount__c.split('#');
    
    mapOfInvisibleMonitoringParams.put('noofMortgageLoan', (mortgageParms != null && mortgageParms[0] != null) ? mortgageParms[0] : '0');
    mapOfInvisibleMonitoringParams.put('mortgageLoanAmt', (mortgageParms != null && mortgageParms[1] != null) ? mortgageParms[1] : '0');
    
    //Rohit Bug 13479 & 13483 end
    //invisible monitoring for SAL by akshata 3rd july 2016 Start
    mapOfInvisibleMonitoringParams.put('numberOfPLEnquiries', (cibilExt1 != null && cibilExt1.Number_of_Hl_Loans__c != null) ? String.valueof(cibilExt1.Number_of_Hl_Loans__c) : '');
    mapOfInvisibleMonitoringParams.put('loanOpenedDate', (cibilVar != null && cibilVar.Date_Opened__c != null) ? String.valueof(cibilVar.Date_Opened__c) : '');
    if( Loan != null && (Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL'))
    {
        //Map<String ,String> SALMapResult=RulesForSALInvisibleMonitoring();
        //mapOfInvisibleMonitoringParams.putAll(SALMapResult);
    }
    //invisible monitoring for SAL by akshata 3rd july 2016 end
    
   String accountInfo = 'Account_Info';
   String accountType = 'Account_Type';
   String amountOverdue = 'Amount_Overdue';
   String currentBalance = 'Current_Balance';
   String dateClosed = 'Date_Closed';
   String sanctionedAmount = 'Sanction_Amount';
   String accountInfoVar, accountTypeVar, amountOverdueVar, currentBalanceVar, dateClosedVar, sanctionedAmountVar;

   for (Integer i = 0; i < 20; i++) {

    Integer y;

    if (i == 0) {
     accountInfoVar = accountInfo + '__c';
     accountTypeVar = accountType + '__c';
     amountOverdueVar = amountOverdue + '__c';
     currentBalanceVar = currentBalance + '__c';
     dateClosedVar = dateClosed + '__c';
     sanctionedAmountVar = sanctionedAmount + '__c';

     mapOfInvisibleMonitoringParams.put('accountInfo1', (cibilVar != null && cibilVar.get(accountInfoVar) != null) ? String.valueof(cibilVar.get(accountInfoVar)) : '0');
     mapOfInvisibleMonitoringParams.put('accountType1', (cibilVar != null && cibilVar.get(accountTypeVar) != null) ? String.valueof(cibilVar.get(accountTypeVar)) : '0');
     mapOfInvisibleMonitoringParams.put('amountOverdue1', (cibilVar != null && cibilVar.get(amountOverdueVar) != null) ? String.valueof(cibilVar.get(amountOverdueVar)) : '0');
     mapOfInvisibleMonitoringParams.put('currentBalance1', (cibilVar != null && cibilVar.get(currentBalanceVar) != null) ? String.valueof(cibilVar.get(currentBalanceVar)) : '0');
     mapOfInvisibleMonitoringParams.put('dateClosed1', (cibilVar != null && cibilVar.get(dateClosedVar) != null) ? String.valueOf(Date.valueOf(cibilVar.get(dateClosedVar))) : '');
     mapOfInvisibleMonitoringParams.put('sanctionedAmount1', (cibilVar != null && cibilVar.get(sanctionedAmountVar) != null) ? String.valueof(cibilVar.get(sanctionedAmountVar)) : '0');

    } else {

     accountInfoVar = accountInfo + i + '__c';
     accountTypeVar = accountType + i + '__c';
     amountOverdueVar = amountOverdue + i + '__c';
     currentBalanceVar = currentBalance + i + '__c';
     dateClosedVar = dateClosed + i + '__c';
     sanctionedAmountVar = sanctionedAmount + i + '__c';

     y = i + 1;

     mapOfInvisibleMonitoringParams.put('accountInfo' + y, (cibilVar != null && cibilVar.get(accountInfoVar) != null) ? String.valueof(cibilVar.get(accountInfoVar)) : '0');
     mapOfInvisibleMonitoringParams.put('accountType' + y, (cibilVar != null && cibilVar.get(accountTypeVar) != null) ? String.valueof(cibilVar.get(accountTypeVar)) : '0');
     mapOfInvisibleMonitoringParams.put('amountOverdue' + y, (cibilVar != null && cibilVar.get(amountOverdueVar) != null) ? String.valueof(cibilVar.get(amountOverdueVar)) : '0');
     mapOfInvisibleMonitoringParams.put('currentBalance' + y, (cibilVar != null && cibilVar.get(currentBalanceVar) != null) ? String.valueof(cibilVar.get(currentBalanceVar)) : '0');
     mapOfInvisibleMonitoringParams.put('dateClosed' + y, (cibilVar != null && cibilVar.get(dateClosedVar) != null) ? String.valueOf(Date.valueOf(cibilVar.get(dateClosedVar))) : '');
     mapOfInvisibleMonitoringParams.put('sanctionedAmount' + y, (cibilVar != null && cibilVar.get(sanctionedAmountVar) != null) ? String.valueof(cibilVar.get(sanctionedAmountVar)) : '0');

    }

   }


   String years;
   // Logic for calculating number of years of bureau history
   if (cibilExt1 != null && cibilExt1.First_Loan_MOB__c != null) {
    if (system.today().month() > cibilExt1.First_Loan_MOB__c.month()) {
     years = String.valueOf(system.today().year() - cibilExt1.First_Loan_MOB__c.year());
    } else {
     if (system.today().month() == cibilExt1.First_Loan_MOB__c.month() && system.today().day() >= cibilExt1.First_Loan_MOB__c.day()) {
      years = String.valueOf(system.today().year() - cibilExt1.First_Loan_MOB__c.year());
     } else {
      years = String.valueOf((system.today().year() - cibilExt1.First_Loan_MOB__c.year()) - 1);
     }
    }
   }

   mapOfInvisibleMonitoringParams.put('bureauHistory', (cibilExt1 != null && cibilExt1.First_Loan_MOB__c != null) ? years : '0');
//Invisible monitoring for dl by akshata 30th june 2016 start
 mapOfInvisibleMonitoringParams.put('cibilHistory', (cibilExt1 != null && cibilExt1.First_Loan_MOB__c != null) ? years : '0');
 //Invisible monitoring for dl by akshata 30th june 2016 end
   system.debug('Final map to be passed ---->' + mapOfInvisibleMonitoringParams);

   // Call BRE method and get response
   BRECallout obj = new BRECallout();
   Map < String, String > mapOfResults;
   if (!Test.isRunningTest()) {
   if(isSampling == false)
   {
       System.debug('rohit3 in else');
        mapOfResults = obj.remoteInvisibleMonitoringCheck(mapOfInvisibleMonitoringParams);
    }
   else{
       mapOfResults =  obj.SamplingBRECall(mapOfInvisibleMonitoringParams);
   }
   }
   System.debug('rohit9 '+mapOfResults);
   return mapOfResults;
  }
         //SAL Invisible Monitoring End

    Public static Map < String, Object > initializeDynamicPageData(Map < String, Object > filterParameterMap) { //String productName,string pagename, string sectionId, string compoKey) {
        List < Field__c > fieldLst = new List < Field__c > ();
        Map < String, Object > objectMap = new Map < String, Object > ();

       /* String queryHeader = 'SELECT FieldApiName__c,ObjectApiName__c,Label__c,Type__c,Validation__c,Length__c,Order__c,JsFunctions__c,Help_Text__c,Section__c, Row__c,IsAutoComplete__c,Parent_Object_API_Name__c,Parent_Field_API_Name__c,Query_Filter__c,Limit__c,Other_Label__c,Default__c FROM Field__c WHERE ';*/
       
       String queryHeader = 'SELECT FieldApiName__c,ObjectApiName__c,Label__c,Type__c,Validation__c,Length__c,Order__c,JsFunctions__c,Help_Text__c,Section__c, Row__c,IsAutoComplete__c,Parent_Object_API_Name__c,Parent_Field_API_Name__c,Query_Filter__c,Limit__c,Other_Label__c,Default__c,'
                            + 'Section__r.Next_Page__c, Section__r.Name__c, Section__r.Page__c, Section__r.Percentage_Completion__c, Section__r.BreFunction__c, Section__r.Section_Title__c, Section__r.Pixel_Codes_Onload__c, Section__r.Pixel_Codes_Onsubmit__c,Section__r.TabName__c, Section__r.Order__c,Section__r.Template__r.IsDefualtforMobileLead__c ,Section__r.Template__c'
                            + ' FROM Field__c WHERE ';
       
        String filterValue = '';
        String pagename = filterParameterMap.containsKey('pagename') ? (String) filterParameterMap.get('pagename') : null;

        System.debug('filterParameterMapfilterParameterMap--->' + filterParameterMap);
        String salId, templateId;
        Decimal nextOrder;
        if (filterParameterMap.containsKey('salId') && '' != filterParameterMap.get('salId') && filterParameterMap.get('salId') != null) {
            salId = (String) filterParameterMap.get('salId');
            List < Salaried__c > salObjLst = [SELECT Id,Product_Type__c , Template__c, Template__r.Flow__c,Percentage_Completion__c FROM Salaried__c WHERE Id = : salId];
            Salaried__c salObj;
            if (!CommonUtility.isEmpty(salObjLst)) {
                salObj = salObjLst[0];
            }

            if (!CommonUtility.isEmpty(salObj) /* && !CommonUtility.isEmpty(salObj.Template__c)*/ ) {

                List < Section__c > allASections = [SELECT Id, Template__c, Order__c,Percentage_Completion__c FROM Section__c WHERE Template__c = : salObj.Template__c];
                List < Section__c > completedSection;
                if (!CommonUtility.isEmpty(salObj.Template__c)){
                    //Code changed for optimization ----- harsit----START
                    completedSection = new List<Section__c>();
                    Section__c currentSection;
                    for(Section__c sec: allASections){
                        if(sec.Percentage_Completion__c == salObj.Percentage_Completion__c){
                            currentSection = sec;
                            break;
                        }
                    }
                    if(!CommonUtility.isEmpty(currentSection))
                        completedSection.add(currentSection);
                    //completedSection = [SELECT Id, Template__c, Order__c FROM Section__c WHERE Template__c = : salObj.Template__c AND Percentage_Completion__c = : salObj.Percentage_Completion__c];
                    //Code changed for optimization ----- harsit----END
                }    
                else if (!CommonUtility.isEmpty(Label.Modular_Default_Template_Old_Applications))
                    completedSection = [SELECT Id, Template__c, Order__c FROM Section__c WHERE Template__r.Name = : Label.Modular_Default_Template_Old_Applications AND Percentage_Completion__c = : salObj.Percentage_Completion__c];
                System.debug('completedsection' + completedsection);
                if (!CommonUtility.isEmpty(completedSection)) {
                    templateId = completedSection[0].Template__c;
                    if (allASections.size() > 1)
                        nextOrder = completedSection[0].Order__c + 1;
                    else if (allASections.size() == 1)
                        nextOrder = 1;
                    filterValue = 'Section__r.Template__c =: templateId AND Section__r.Order__c =: nextOrder';
                } else if (!CommonUtility.isEmpty(salObj.Template__c)) {
                    templateId = salObj.Template__c;
                    filterValue = 'Section__r.Template__c =: templateId AND Section__r.Order__c = 1';
                }
            }
        } else if (filterParameterMap.containsKey('sectionId') && '' != filterParameterMap.get('sectionId') && filterParameterMap.get('sectionId') != null) {
            string sectionId = (String) filterParameterMap.get('sectionId');
            filterValue = 'Section__r.id =: sectionId';
        } else if (filterParameterMap.containsKey('compoKey') && '' != filterParameterMap.get('compoKey') && filterParameterMap.get('compoKey') != null) {
            String compoKey = (String) filterParameterMap.get('compoKey');
            String status = 'Enabled';
            filterValue = 'Section__r.Template__r.TemplateCompositeKey__c =: compoKey AND Section__r.Template__r.Status__c =: status AND Section__r.Page__c =: pagename AND Section__r.Order__c = 1';
        }

        if (!isEmpty(filterValue)) {
            filterValue += ' ORDER BY Order__c';
            fieldLst = Database.query(queryHeader + filterValue);
        }

        if (CommonUtility.isEmpty(fieldLst) || fieldLst.size() < 1) {
            filterValue = 'Section__r.Page__c =: pagename AND Section__r.Template__r.IsDefault__c = true AND Section__r.Order__c = 1';
            filterValue += ' ORDER BY Order__c';
            fieldLst = Database.query(queryHeader + filterValue);
        }

        List < Object > fieldLstRenderer = new List < Object > ();

        Integer i = 0;
        List < Field__c > tempLst = new List < Field__c > ();
        Map < String, Object > picklistMap = new Map < String, Object > ();
        Map < Decimal, Decimal > rowCountMap = new Map < Decimal, Decimal > ();
        for (Field__c field: fieldLst) {
            if (('picklist').equalsIgnoreCase(field.Type__c) || ('radio').equalsIgnoreCase(field.Type__c)) {
                system.debug('@@@@@@@@');
                picklistMap.put(field.FieldApiName__c, getPicklistValues(field.ObjectApiName__c, field.FieldApiName__c));
            }
            tempLst.add(field);
            i++;
   //Second argument to the mod function will decides the number of fields rendered in each div 
   //eg. If 3 fields  are needed in one div , do  Math.mod(i,3)
   Integer noOfColums=3;
   if(pagename=='DoctorCA_OnlineUI'){
        noOfColums=1;    
   }

   if (0 == Math.mod(i, noOfColums) || 0 == (i - fieldLst.size())) {
  
     fieldLstRenderer.add(tempLst);
    tempLst = new List < Field__c > ();
   }
            if (!isEmpty(field.Row__c)) {

                if (rowCountMap.containsKey(field.Row__c)) {
                    rowCountMap.put(field.Row__c, rowCountMap.get(field.Row__c) + 1);
                } else
                    rowCountMap.put(field.Row__c, 1);

            }
        }

        system.debug('fieldLstRenderer--->' + fieldLstRenderer);
        Section__c sectionObj;
        Template__c templateObj;
        if (fieldLst.size() > 0) {
            /*sectionObj = [SELECT Id, Next_Page__c, Name__c, Page__c, Percentage_Completion__c, BreFunction__c, Section_Title__c, Pixel_Codes_Onload__c, Pixel_Codes_Onsubmit__c,TabName__c, Order__c, Template__c, Template__r.Id,Template__r.Product__r.Name__c FROM Section__c WHERE Id = : fieldLst[0].Section__c];
            sectionObj.Pixel_Codes_Onload__c = !CommonUtility.isEmpty(sectionObj.Pixel_Codes_Onload__c) ? sectionObj.Pixel_Codes_Onload__c.replaceAll('[\n\r]', '') : '';
            sectionObj.Pixel_Codes_Onsubmit__c = !CommonUtility.isEmpty(sectionObj.Pixel_Codes_Onsubmit__c) ? sectionObj.Pixel_Codes_Onsubmit__c.replaceAll('[\n\r]', '') : '';*/
           sectionObj = new Section__c();
                   
            sectionObj.Id = fieldLst[0].Section__c;
            sectionObj.Next_Page__c = fieldLst[0].Section__r.Next_Page__c;
            sectionObj.Name__c = fieldLst[0].Section__r.Name__c;
            sectionObj.Page__c = fieldLst[0].Section__r.Page__c;
            sectionObj.Percentage_Completion__c = fieldLst[0].Section__r.Percentage_Completion__c;
            sectionObj.BreFunction__c = fieldLst[0].Section__r.BreFunction__c;
            sectionObj.Section_Title__c = fieldLst[0].Section__r.Section_Title__c;
            sectionObj.TabName__c = fieldLst[0].Section__r.TabName__c;
            sectionObj.Order__c = fieldLst[0].Section__r.Order__c;
            System.debug('Section===========>'+fieldLst[0].Section__r);
            //sectionObj.Template__r.IsDefualtforMobileLead__c = fieldLst[0].Section__r.Template__r.IsDefualtforMobileLead__c;
            sectionObj.Template__c = fieldLst[0].Section__r.Template__c;
            sectionObj.Pixel_Codes_Onload__c = !CommonUtility.isEmpty(fieldLst[0].Section__r.Pixel_Codes_Onload__c) ? fieldLst[0].Section__r.Pixel_Codes_Onload__c.replaceAll('[\n\r]', '') : '';
            sectionObj.Pixel_Codes_Onsubmit__c = !CommonUtility.isEmpty(fieldLst[0].Section__r.Pixel_Codes_Onsubmit__c) ? fieldLst[0].Section__r.Pixel_Codes_Onsubmit__c.replaceAll('[\n\r]', '') : '';
            
            
        } else
            sectionObj = new Section__c();  
        System.debug('Section --->'+sectionObj);
        objectMap.put('section', sectionObj);
        objectMap.put('field_renderer', fieldLstRenderer);
        objectMap.put('fields', fieldLst);
        objectMap.put('picklist_values', picklistMap);
        objectMap.put('row_count', rowCountMap);
        system.debug('fieldLst----->' + fieldLst);
        return objectMap;
    }
    
     //Bug# 12646 S
    /**
     * Method to check if expected set of profiles are present in a custom setting.
     * parameter expectedProfilesSet - Set of expected profile Names
     * return true if expected profiles present, else false
     */
    public static Boolean hasCommunityProfile(Set<String> expectedProfilesSet) {
        LaonApplicationCreation__c loanApplicationRecord = LaonApplicationCreation__c.getValues('ASM Community Profiles');
        if(loanApplicationRecord != null) {
            String communityProfile = loanApplicationRecord.value__c;
            if (communityProfile != null) {
                List<String> communityProfileList = communityProfile.split(';');
                Set<String> communityProfileSet = new Set<String>(communityProfileList);
                if (
                    communityProfileSet != null &&
                    communityProfileSet.size() > 0 &&
                    communityProfileSet.containsAll(expectedProfilesSet)
                ) {
                    return true;
                } else {
                    return false;
                }
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

  //Bug# 12646 E

    public static list < string > getPicklistValues(String ObjectApi_name, String Field_name) {
        Map < String, Object > picklistOptions = new Map < String, Object > ();
        List < String > lstPickvals = new List < String > ();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name); //From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map < String, Schema.SObjectField > field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List < Schema.PicklistEntry > pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        System.debug('picklistentry' + pick_list_values);
        for (Schema.PicklistEntry a: pick_list_values) { //for all values in the picklist list
            lstPickvals.add(a.getValue()); //add the value  to our final list
        }
        system.debug('lstPickvals@@@@@' + lstPickvals);
        //picklistOptions.put(Field_name, lstPickvals);
        //system.debug('picklistOptions@@@' + picklistOptions);
        return lstPickvals;
    }

    /*
     * Fetch picklist Values 
     */
    public static List < SelectOption > getPicklistSelectoption(String ObjectApi_name, String Field_name) {

        List < SelectOption > options = new List < SelectOption > ();
        List < String > List1 = getPicklistValues(ObjectApi_name, Field_name);
        options.add(new SelectOption('--None--', '--None--'));
        for (String iteam: List1)
            options.add(new SelectOption(iteam, iteam));
        return options;

    }

    /*
     * Fetch met data for Previous sections
     */
    public static Map < String, Object > getDynamicPageDataForFreezeSections(Map < String, Object > reqMap) {
        Map < String, Object > resMap = new Map < String, Object > ();
        List < Field__c > totalPrevFldLst;
        if (!CommonUtility.isEmpty(reqMap)) {
            Section__c currentSection = reqMap.containsKey('section') ? (Section__c) reqMap.get('section') : null;
            String salId = reqMap.containsKey('salid') ? (String) reqMap.get('salid') : null;
            List < Field__c > currentFldLst = reqMap.containsKey('fields') ? (List < Field__c > ) reqMap.get('fields') : null;
            if (!CommonUtility.isEmpty(salId) && !CommonUtility.isEmpty(currentSection)) {
                Set < String > prevFldSelectSet = new Set < String > ();
                String prevFldSelectQry = '';

                if (currentSection.Order__c > 1) {
                    List < Section__c > prevSecLst = [SELECT Id, Name__c FROM Section__c WHERE Template__c = : currentSection.Template__c AND Page__c = : currentSection.Page__c AND Order__c < : currentSection.Order__c ORDER BY Order__c];
                    if (!CommonUtility.isEmpty(prevSecLst)) {
                        totalPrevFldLst = new List < Field__c > ();
                        for (Section__c tempSec: prevSecLst) {
                            Map < String, Object > secDataMap = initializeDynamicPageData(new Map < String, Object > {
                                'sectionId' => tempSec.Id
                            });
                            if (!CommonUtility.isEmpty(secDataMap)) {
                                resMap.put(tempSec.Name__c, secDataMap);
                                if (secDataMap.containsKey('fields'))
                                    totalPrevFldLst.addAll((List < Field__c > ) secDataMap.get('fields'));
                            }
                        }

                        for (Field__c prevFld: totalPrevFldLst) {
                            if (!CommonUtility.isEmpty(prevFld.FieldApiName__c)) {
                                //if(!CommonUtility.isEmpty(prevFldSelectQry))
                                //  prevFldSelectQry += ',';
                                //prevFldSelectQry += prevFld.FieldApiName__c;
                                prevFldSelectSet.add(prevFld.FieldApiName__c);
                            }
                        }
                    }
                }
                //also fetch current section fields from Salaried
                if (!CommonUtility.isEmpty(currentFldLst)) {
                    for (Field__c currFld: currentFldLst) {
                        if (!CommonUtility.isEmpty(currFld.FieldApiName__c)) {
                            //if(!CommonUtility.isEmpty(prevFldSelectQry))
                            //  prevFldSelectQry += ',';
                            //prevFldSelectQry += currFld.FieldApiName__c;
                            prevFldSelectSet.add(currFld.FieldApiName__c);
                        }
                    }
                }
                prevFldSelectSet.add('Experia_Cust_Id__c');
                prevFldSelectSet.add('Loan_Application__c');
                prevFldSelectSet.add('Type_of_Loan__c');
                prevFldSelectSet.add('Percentage_Completion__c');
                prevFldSelectSet.add('Product_Type__c');
                prevFldSelectSet.add('Employer__r.Name');
                prevFldSelectSet.add('Loan_Application__r.Account.Id');
                prevFldSelectSet.add('Branch__r.name');
                prevFldSelectSet.add('Loan_Application_Stage__c');
                prevFldSelectSet.add('Sourcing_Channel__r.name');
                System.debug('fieldset--->'+prevFldSelectSet);
                List < String > prevFldSelectLst = new List < String > ();
                prevFldSelectLst.addAll(prevFldSelectSet);

                for (String fieldName: prevFldSelectLst) {
                    if (!CommonUtility.isEmpty(prevFldSelectQry))
                        prevFldSelectQry += ',';
                    prevFldSelectQry += fieldName;
                }


                if (!CommonUtility.isEmpty(prevFldSelectQry)) {
                    system.debug('query---' + prevFldSelectQry);
                    //prevFldSelectQry += ',Employer__r.Name, Loan_Application__c,Type_of_Loan__c,Loan_Application__r.Account.Id,Percentage_Completion__c,Product_Type__c';
                    List < Salaried__c > prevSalDataLst = Database.query('SELECT ' + prevFldSelectQry + ' FROM Salaried__c WHERE Id = :salId LIMIT 1');
                    if (!CommonUtility.isEmpty(prevSalDataLst)) {
                        Salaried__c prevSalData = prevSalDataLst[0];
                        resMap.put('data', prevSalData);
                    }
                }
            }
        }
        return resMap;
    }


    /*
     * call BRE MCP wadl service
     */
    public static void BRECalloutMCPCheck(Map < String, Object > objMap) {
        try {
            system.debug('request Map=====>' + objMap);
            Salaried__c sal = objMap.containsKey('salObj') ? (Salaried__c) objMap.get('salObj') : null;
            Opportunity opp = objMap.containsKey('oppObj') ? (Opportunity) objMap.get('oppObj') : null;
            Applicant__c app = objMap.containsKey('appObj') ? (Applicant__c) objMap.get('appObj') : null;
            Contact con = objMap.containsKey('conObj') ? (Contact) objMap.get('conObj') : null;

            if (!CommonUtility.isEmpty(sal)) {
                Map < String, String > mapOfPolicyParameters = new Map < String, String > ();
                Map < String, String > mapOfPolicyResult = new Map < String, String > ();

                if (!CommonUtility.isEmpty(sal.Residence_Type__c))
                    mapOfPolicyParameters.put('residence_type', String.valueOf(sal.Residence_Type__c));

                if (sal.Total_Employment_vintage_Year__c != null && sal.Total_Employment_vintage_Year__c.toUpperCase() != 'YY')
                    mapOfPolicyParameters.put('years_in_business_job', String.valueOf(sal.Total_Employment_vintage_Year__c));

                if (!CommonUtility.isEmpty(sal.Percentage_Completion__c))
                    mapOfPolicyParameters.put('stage', sal.Percentage_Completion__c);

                if (!CommonUtility.isEmpty(sal.Mode_of_crediting_salary__c))
                    mapOfPolicyParameters.put('modeOfSalary', String.valueOf(sal.Mode_of_crediting_salary__c));

                if (!CommonUtility.isEmpty(sal.EMI_bounce__c))
                    mapOfPolicyParameters.put('emiBounceInLast3Months', String.valueOf(sal.EMI_bounce__c));

                if (!CommonUtility.isEmpty(sal.Pan__c))
                    mapOfPolicyParameters.put('pan', String.valueOf(sal.Pan__c));

                if (!CommonUtility.isEmpty(sal.Property_Status__c))
                    mapOfPolicyParameters.put('property_type', String.valueOf(sal.Property_Status__c));
                
                if (!CommonUtility.isEmpty(sal.Pin_code__c))
                    mapOfPolicyParameters.put('pincode', String.valueOf(sal.Pin_code__c));
                
                if (!CommonUtility.isEmpty(opp)) {
                    if (!CommonUtility.isEmpty(opp.Loan_Application_Number__c))
                        mapOfPolicyParameters.put('loan_id', opp.Loan_Application_Number__c);
                    if (!CommonUtility.isEmpty(opp.Product__c))
                        mapOfPolicyParameters.put('product', opp.Product__c);
                    if (!CommonUtility.isEmpty(opp.Branch_Type1__c))
                        mapOfPolicyParameters.put('branch_type', opp.Branch_Type1__c);
                }

                if (!CommonUtility.isEmpty(app)) {
                    if (!CommonUtility.isEmpty(app.Applicant_Type__c))
                        mapOfPolicyParameters.put('applicant_type', app.Applicant_Type__c);

                    if (!CommonUtility.isEmpty(app.Contact_Name__r) && !CommonUtility.isEmpty(app.Contact_Name__r.Company_Type__c))
                        mapOfPolicyParameters.put('company_type', app.Contact_Name__r.Company_Type__c);

                    if (!CommonUtility.isEmpty(app.Contact_Name__r) && !CommonUtility.isEmpty(app.Contact_Name__r.Company_Category__c))
                        mapOfPolicyParameters.put('company_category', app.Contact_Name__r.Company_Category__c);

                    if (app.month1_sal__c != null)
                        mapOfPolicyParameters.put('applicant_net_salary_m1', String.valueOf(app.month1_sal__c));

                    if (app.month2_sal__c != null)
                        mapOfPolicyParameters.put('applicant_net_salary_m2', String.valueOf(app.month2_sal__c));
                }

                if (!CommonUtility.isEmpty(con)) {
                    if (!CommonUtility.isEmpty(con.Date_Of_Birth__c)) {
                        DateTime dobT = datetime.newInstance(con.Date_Of_Birth__c.year(), con.Date_Of_Birth__c.month(), con.Date_Of_Birth__c.day());
                        mapOfPolicyParameters.put('date_of_birth', dobT.format('YYYY-MM-dd'));
                    }
                    if (con.AppCity__c != null)
                        mapOfPolicyParameters.put('branch_name', String.valueOf(con.AppCity__c));
                }

                system.debug('*****mapOfPolicyParameters***' + mapOfPolicyParameters);
                BRECalloutCls breObj = new BRECalloutCls();
                mapOfPolicyResult = breObj.callBREMCPCheck(mapOfPolicyParameters);
                String FinalMCPResult = '';
                system.debug('*****mapOfPolicyResult***' + mapOfPolicyResult);

                if (mapOfPolicyResult != null && mapOfPolicyResult.size() > 0) {

                    FinalMCPResult = mapOfPolicyResult.get('FinalResult');
                    system.debug('FinalMCPResult***' + FinalMCPResult);
                    String MCPResult = mapOfPolicyResult.get('MCPList');
                    if (('REJECT').equalsIgnoreCase(FinalMCPResult) || ('REJECTED').equalsIgnoreCase(FinalMCPResult) ||
                        ('AUTO REJECT').equalsIgnoreCase(FinalMCPResult) || ('AUTO REJECTED').equalsIgnoreCase(FinalMCPResult) ||
                        ('AUTOREJECT').equalsIgnoreCase(FinalMCPResult) || ('AUTOREJECTED').equalsIgnoreCase(FinalMCPResult) ||
                        ('REFER').equalsIgnoreCase(FinalMCPResult)) {

                        if (!isEmpty(MCPResult))
                            createPolicyRecord(MCPResult, FinalMCPResult, opp.id, app.id);

                        //update opportunity stage
                        if (isEmpty(opp.StageName) || (!isEmpty(opp.StageName) && !opp.StageName.toLowerCase().contains('reject'))) {
                            System.debug('updating opp stage');
                            opp.StageName = FinalMCPResult;
                            update opp;
                        }
                    }
                }
            }
        } catch (Exception e) {

        }
    }

    /*
     * call BRE Cibil wadl service
     */
    @
    Future(CallOut = true)
    public static void BRECalloutCibilCheck(Map < String, String > idMap) {
        try {
            String cibilId = idMap.containsKey('cibil_id') ? idMap.get('cibil_id') : '';
            Map < String, Object > objMap = getObjectMapFromCibil(cibilId);

            system.debug('request Map=====>' + objMap);

            Salaried__c sal = objMap.containsKey('salObj') ? (Salaried__c) objMap.get('salObj') : null;
            Opportunity opp = objMap.containsKey('oppObj') ? (Opportunity) objMap.get('oppObj') : null;
            Applicant__c app = objMap.containsKey('appObj') ? (Applicant__c) objMap.get('appObj') : null;
            CIBIL__c cibil = objMap.containsKey('cibilObj') ? (CIBIL__c) objMap.get('cibilObj') : null;
            Cibil_Extension1__c cibilExtn = objMap.containsKey('cibilExtension1Obj') ? (Cibil_Extension1__c) objMap.get('cibilExtension1Obj') : null;

            if (!CommonUtility.isEmpty(sal) && !CommonUtility.isEmpty(opp) && !CommonUtility.isEmpty(app) &&
                !CommonUtility.isEmpty(cibil) && !CommonUtility.isEmpty(cibilExtn)) {
                Map < String, String > mapOfPolicyParameters = new Map < String, String > ();
                Map < String, String > mapOfPolicyResult = new Map < String, String > ();

                mapOfPolicyParameters.put('loan_id', opp.Loan_Application_Number__c);
                mapOfPolicyParameters.put('product', opp.Product__c);
                mapOfPolicyParameters.put('applicant_type', app.Applicant_Type__c);

                if (!CommonUtility.isEmpty(cibil.CIBIL_Score__c)) mapOfPolicyParameters.put('CIBIL_Score', String.valueOf(cibil.CIBIL_Score__c));

                if (!CommonUtility.isEmpty(cibil.Member__c)) mapOfPolicyParameters.put('member', String.valueOf(cibil.Member__c));
                if (!CommonUtility.isEmpty(cibil.Member1__c)) mapOfPolicyParameters.put('member1', String.valueOf(cibil.Member1__c));
                if (!CommonUtility.isEmpty(cibil.Member2__c)) mapOfPolicyParameters.put('member2', String.valueOf(cibil.Member2__c));
                if (!CommonUtility.isEmpty(cibil.Member3__c)) mapOfPolicyParameters.put('member3', String.valueOf(cibil.Member3__c));
                if (!CommonUtility.isEmpty(cibil.Member4__c)) mapOfPolicyParameters.put('member4', String.valueOf(cibil.Member4__c));
                if (!CommonUtility.isEmpty(cibil.Member5__c)) mapOfPolicyParameters.put('member5', String.valueOf(cibil.Member5__c));
                if (!CommonUtility.isEmpty(cibil.Member6__c)) mapOfPolicyParameters.put('member6', String.valueOf(cibil.Member6__c));
                if (!CommonUtility.isEmpty(cibil.Member7__c)) mapOfPolicyParameters.put('member7', String.valueOf(cibil.Member7__c));
                if (!CommonUtility.isEmpty(cibil.Member8__c)) mapOfPolicyParameters.put('member8', String.valueOf(cibil.Member8__c));
                if (!CommonUtility.isEmpty(cibil.Member9__c)) mapOfPolicyParameters.put('member9', String.valueOf(cibil.Member9__c));
                if (!CommonUtility.isEmpty(cibil.Member10__c)) mapOfPolicyParameters.put('member10', String.valueOf(cibil.Member10__c));
                if (!CommonUtility.isEmpty(cibil.Member11__c)) mapOfPolicyParameters.put('member11', String.valueOf(cibil.Member11__c));
                if (!CommonUtility.isEmpty(cibil.Member12__c)) mapOfPolicyParameters.put('member12', String.valueOf(cibil.Member12__c));
                if (!CommonUtility.isEmpty(cibil.Member13__c)) mapOfPolicyParameters.put('member13', String.valueOf(cibil.Member13__c));
                if (!CommonUtility.isEmpty(cibil.Member14__c)) mapOfPolicyParameters.put('member14', String.valueOf(cibil.Member14__c));
                if (!CommonUtility.isEmpty(cibil.Member15__c)) mapOfPolicyParameters.put('member15', String.valueOf(cibil.Member15__c));
                if (!CommonUtility.isEmpty(cibil.Member16__c)) mapOfPolicyParameters.put('member16', String.valueOf(cibil.Member16__c));
                if (!CommonUtility.isEmpty(cibil.Member17__c)) mapOfPolicyParameters.put('member17', String.valueOf(cibil.Member17__c));
                if (!CommonUtility.isEmpty(cibil.Member18__c)) mapOfPolicyParameters.put('member18', String.valueOf(cibil.Member18__c));
                if (!CommonUtility.isEmpty(cibil.Member19__c)) mapOfPolicyParameters.put('member19', String.valueOf(cibil.Member19__c));

                if (!CommonUtility.isEmpty(cibil.Ownership__c)) mapOfPolicyParameters.put('ownership', String.valueOf(cibil.Ownership__c));
                if (!CommonUtility.isEmpty(cibil.Ownership1__c)) mapOfPolicyParameters.put('ownership1', String.valueOf(cibil.Ownership1__c));
                if (!CommonUtility.isEmpty(cibil.Ownership2__c)) mapOfPolicyParameters.put('ownership2', String.valueOf(cibil.Ownership2__c));
                if (!CommonUtility.isEmpty(cibil.Ownership3__c)) mapOfPolicyParameters.put('ownership3', String.valueOf(cibil.Ownership3__c));
                if (!CommonUtility.isEmpty(cibil.Ownership4__c)) mapOfPolicyParameters.put('ownership4', String.valueOf(cibil.Ownership4__c));
                if (!CommonUtility.isEmpty(cibil.Ownership5__c)) mapOfPolicyParameters.put('ownership5', String.valueOf(cibil.Ownership5__c));
                if (!CommonUtility.isEmpty(cibil.Ownership6__c)) mapOfPolicyParameters.put('ownership6', String.valueOf(cibil.Ownership6__c));
                if (!CommonUtility.isEmpty(cibil.Ownership7__c)) mapOfPolicyParameters.put('ownership7', String.valueOf(cibil.Ownership7__c));
                if (!CommonUtility.isEmpty(cibil.Ownership8__c)) mapOfPolicyParameters.put('ownership8', String.valueOf(cibil.Ownership8__c));
                if (!CommonUtility.isEmpty(cibil.Ownership9__c)) mapOfPolicyParameters.put('ownership9', String.valueOf(cibil.Ownership9__c));
                if (!CommonUtility.isEmpty(cibil.Ownership10__c)) mapOfPolicyParameters.put('ownership10', String.valueOf(cibil.Ownership10__c));
                if (!CommonUtility.isEmpty(cibil.Ownership11__c)) mapOfPolicyParameters.put('ownership11', String.valueOf(cibil.Ownership11__c));
                if (!CommonUtility.isEmpty(cibil.Ownership12__c)) mapOfPolicyParameters.put('ownership12', String.valueOf(cibil.Ownership12__c));
                if (!CommonUtility.isEmpty(cibil.Ownership13__c)) mapOfPolicyParameters.put('ownership13', String.valueOf(cibil.Ownership13__c));
                if (!CommonUtility.isEmpty(cibil.Ownership14__c)) mapOfPolicyParameters.put('ownership14', String.valueOf(cibil.Ownership14__c));
                if (!CommonUtility.isEmpty(cibil.Ownership15__c)) mapOfPolicyParameters.put('ownership15', String.valueOf(cibil.Ownership15__c));
                if (!CommonUtility.isEmpty(cibil.Ownership16__c)) mapOfPolicyParameters.put('ownership16', String.valueOf(cibil.Ownership16__c));
                if (!CommonUtility.isEmpty(cibil.Ownership17__c)) mapOfPolicyParameters.put('ownership17', String.valueOf(cibil.Ownership17__c));
                if (!CommonUtility.isEmpty(cibil.Ownership18__c)) mapOfPolicyParameters.put('ownership18', String.valueOf(cibil.Ownership18__c));
                if (!CommonUtility.isEmpty(cibil.Ownership19__c)) mapOfPolicyParameters.put('ownership19', String.valueOf(cibil.Ownership19__c));

                if (!CommonUtility.isEmpty(cibil.Suit_Filed_Status__c)) mapOfPolicyParameters.put('suitFiledStatus', String.valueOf(cibil.Suit_Filed_Status__c));
                if (!CommonUtility.isEmpty(cibil.Suit_Filed_Status1__c)) mapOfPolicyParameters.put('suitFiledStatus1', String.valueOf(cibil.Suit_Filed_Status1__c));
                if (!CommonUtility.isEmpty(cibil.Suit_Filed_Status2__c)) mapOfPolicyParameters.put('suitFiledStatus2', String.valueOf(cibil.Suit_Filed_Status2__c));
                if (!CommonUtility.isEmpty(cibil.Suit_Filed_Status3__c)) mapOfPolicyParameters.put('suitFiledStatus3', String.valueOf(cibil.Suit_Filed_Status3__c));
                if (!CommonUtility.isEmpty(cibil.Suit_Filed_Status4__c)) mapOfPolicyParameters.put('suitFiledStatus4', String.valueOf(cibil.Suit_Filed_Status4__c));
                if (!CommonUtility.isEmpty(cibil.Suit_Filed_Status5__c)) mapOfPolicyParameters.put('suitFiledStatus5', String.valueOf(cibil.Suit_Filed_Status5__c));
                if (!CommonUtility.isEmpty(cibil.Suit_Filed_Status6__c)) mapOfPolicyParameters.put('suitFiledStatus6', String.valueOf(cibil.Suit_Filed_Status6__c));
                if (!CommonUtility.isEmpty(cibil.Suit_Filed_Status7__c)) mapOfPolicyParameters.put('suitFiledStatus7', String.valueOf(cibil.Suit_Filed_Status7__c));
                if (!CommonUtility.isEmpty(cibil.Suit_Filed_Status8__c)) mapOfPolicyParameters.put('suitFiledStatus8', String.valueOf(cibil.Suit_Filed_Status8__c));
                if (!CommonUtility.isEmpty(cibil.Suit_Filed_Status9__c)) mapOfPolicyParameters.put('suitFiledStatus9', String.valueOf(cibil.Suit_Filed_Status9__c));
                if (!CommonUtility.isEmpty(cibil.Suit_Filed_Status10__c)) mapOfPolicyParameters.put('suitFiledStatus10', String.valueOf(cibil.Suit_Filed_Status10__c));
                if (!CommonUtility.isEmpty(cibil.Suit_Filed_Status11__c)) mapOfPolicyParameters.put('suitFiledStatus11', String.valueOf(cibil.Suit_Filed_Status11__c));
                if (!CommonUtility.isEmpty(cibil.Suit_Filed_Status12__c)) mapOfPolicyParameters.put('suitFiledStatus12', String.valueOf(cibil.Suit_Filed_Status12__c));
                if (!CommonUtility.isEmpty(cibil.Suit_Filed_Status13__c)) mapOfPolicyParameters.put('suitFiledStatus13', String.valueOf(cibil.Suit_Filed_Status13__c));
                if (!CommonUtility.isEmpty(cibil.Suit_Filed_Status14__c)) mapOfPolicyParameters.put('suitFiledStatus14', String.valueOf(cibil.Suit_Filed_Status14__c));
                if (!CommonUtility.isEmpty(cibil.Suit_Filed_Status15__c)) mapOfPolicyParameters.put('suitFiledStatus15', String.valueOf(cibil.Suit_Filed_Status15__c));
                if (!CommonUtility.isEmpty(cibil.Suit_Filed_Status16__c)) mapOfPolicyParameters.put('suitFiledStatus16', String.valueOf(cibil.Suit_Filed_Status16__c));
                if (!CommonUtility.isEmpty(cibil.Suit_Filed_Status17__c)) mapOfPolicyParameters.put('suitFiledStatus17', String.valueOf(cibil.Suit_Filed_Status17__c));
                if (!CommonUtility.isEmpty(cibil.Suit_Filed_Status18__c)) mapOfPolicyParameters.put('suitFiledStatus18', String.valueOf(cibil.Suit_Filed_Status18__c));
                if (!CommonUtility.isEmpty(cibil.Suit_Filed_Status19__c)) mapOfPolicyParameters.put('suitFiledStatus19', String.valueOf(cibil.Suit_Filed_Status19__c));

                if (!CommonUtility.isEmpty(cibil.Days_Past_Due__c)) mapOfPolicyParameters.put('daysPastDue', String.valueOf(cibil.Days_Past_Due__c));
                if (!CommonUtility.isEmpty(cibil.Days_Past_Due1__c)) mapOfPolicyParameters.put('daysPastDue1', String.valueOf(cibil.Days_Past_Due1__c));
                if (!CommonUtility.isEmpty(cibil.Days_Past_Due2__c)) mapOfPolicyParameters.put('daysPastDue2', String.valueOf(cibil.Days_Past_Due2__c));
                if (!CommonUtility.isEmpty(cibil.Days_Past_Due3__c)) mapOfPolicyParameters.put('daysPastDue3', String.valueOf(cibil.Days_Past_Due3__c));
                if (!CommonUtility.isEmpty(cibil.Days_Past_Due4__c)) mapOfPolicyParameters.put('daysPastDue4', String.valueOf(cibil.Days_Past_Due4__c));
                if (!CommonUtility.isEmpty(cibil.Days_Past_Due5__c)) mapOfPolicyParameters.put('daysPastDue5', String.valueOf(cibil.Days_Past_Due5__c));
                if (!CommonUtility.isEmpty(cibil.Days_Past_Due6__c)) mapOfPolicyParameters.put('daysPastDue6', String.valueOf(cibil.Days_Past_Due6__c));
                if (!CommonUtility.isEmpty(cibil.Days_Past_Due7__c)) mapOfPolicyParameters.put('daysPastDue7', String.valueOf(cibil.Days_Past_Due7__c));
                if (!CommonUtility.isEmpty(cibil.Days_Past_Due8__c)) mapOfPolicyParameters.put('daysPastDue8', String.valueOf(cibil.Days_Past_Due8__c));
                if (!CommonUtility.isEmpty(cibil.Days_Past_Due9__c)) mapOfPolicyParameters.put('daysPastDue9', String.valueOf(cibil.Days_Past_Due9__c));
                if (!CommonUtility.isEmpty(cibil.Days_Past_Due10__c)) mapOfPolicyParameters.put('daysPastDue10', String.valueOf(cibil.Days_Past_Due10__c));
                if (!CommonUtility.isEmpty(cibil.Days_Past_Due11__c)) mapOfPolicyParameters.put('daysPastDue11', String.valueOf(cibil.Days_Past_Due11__c));
                if (!CommonUtility.isEmpty(cibil.Days_Past_Due12__c)) mapOfPolicyParameters.put('daysPastDue12', String.valueOf(cibil.Days_Past_Due12__c));
                if (!CommonUtility.isEmpty(cibil.Days_Past_Due13__c)) mapOfPolicyParameters.put('daysPastDue13', String.valueOf(cibil.Days_Past_Due13__c));
                if (!CommonUtility.isEmpty(cibil.Days_Past_Due14__c)) mapOfPolicyParameters.put('daysPastDue14', String.valueOf(cibil.Days_Past_Due14__c));
                if (!CommonUtility.isEmpty(cibil.Days_Past_Due15__c)) mapOfPolicyParameters.put('daysPastDue15', String.valueOf(cibil.Days_Past_Due15__c));
                if (!CommonUtility.isEmpty(cibil.Days_Past_Due16__c)) mapOfPolicyParameters.put('daysPastDue16', String.valueOf(cibil.Days_Past_Due16__c));
                if (!CommonUtility.isEmpty(cibil.Days_Past_Due17__c)) mapOfPolicyParameters.put('daysPastDue17', String.valueOf(cibil.Days_Past_Due17__c));
                if (!CommonUtility.isEmpty(cibil.Days_Past_Due18__c)) mapOfPolicyParameters.put('daysPastDue18', String.valueOf(cibil.Days_Past_Due18__c));
                if (!CommonUtility.isEmpty(cibil.Days_Past_Due19__c)) mapOfPolicyParameters.put('daysPastDue19', String.valueOf(cibil.Days_Past_Due19__c));

                if (!CommonUtility.isEmpty(cibil.Current_Balance__c)) mapOfPolicyParameters.put('currentBalance', String.valueOf(cibil.Current_Balance__c));
                if (!CommonUtility.isEmpty(cibil.Current_Balance1__c)) mapOfPolicyParameters.put('currentBalance1', String.valueOf(cibil.Current_Balance1__c));
                if (!CommonUtility.isEmpty(cibil.Current_Balance2__c)) mapOfPolicyParameters.put('currentBalance2', String.valueOf(cibil.Current_Balance2__c));
                if (!CommonUtility.isEmpty(cibil.Current_Balance3__c)) mapOfPolicyParameters.put('currentBalance3', String.valueOf(cibil.Current_Balance3__c));
                if (!CommonUtility.isEmpty(cibil.Current_Balance4__c)) mapOfPolicyParameters.put('currentBalance4', String.valueOf(cibil.Current_Balance4__c));
                if (!CommonUtility.isEmpty(cibil.Current_Balance5__c)) mapOfPolicyParameters.put('currentBalance5', String.valueOf(cibil.Current_Balance5__c));
                if (!CommonUtility.isEmpty(cibil.Current_Balance6__c)) mapOfPolicyParameters.put('currentBalance6', String.valueOf(cibil.Current_Balance6__c));
                if (!CommonUtility.isEmpty(cibil.Current_Balance7__c)) mapOfPolicyParameters.put('currentBalance7', String.valueOf(cibil.Current_Balance7__c));
                if (!CommonUtility.isEmpty(cibil.Current_Balance8__c)) mapOfPolicyParameters.put('currentBalance8', String.valueOf(cibil.Current_Balance8__c));
                if (!CommonUtility.isEmpty(cibil.Current_Balance9__c)) mapOfPolicyParameters.put('currentBalance9', String.valueOf(cibil.Current_Balance9__c));
                if (!CommonUtility.isEmpty(cibil.Current_Balance10__c)) mapOfPolicyParameters.put('currentBalance10', String.valueOf(cibil.Current_Balance10__c));
                if (!CommonUtility.isEmpty(cibil.Current_Balance11__c)) mapOfPolicyParameters.put('currentBalance11', String.valueOf(cibil.Current_Balance11__c));
                if (!CommonUtility.isEmpty(cibil.Current_Balance12__c)) mapOfPolicyParameters.put('currentBalance12', String.valueOf(cibil.Current_Balance12__c));
                if (!CommonUtility.isEmpty(cibil.Current_Balance13__c)) mapOfPolicyParameters.put('currentBalance13', String.valueOf(cibil.Current_Balance13__c));
                if (!CommonUtility.isEmpty(cibil.Current_Balance14__c)) mapOfPolicyParameters.put('currentBalance14', String.valueOf(cibil.Current_Balance14__c));
                if (!CommonUtility.isEmpty(cibil.Current_Balance15__c)) mapOfPolicyParameters.put('currentBalance15', String.valueOf(cibil.Current_Balance15__c));
                if (!CommonUtility.isEmpty(cibil.Current_Balance16__c)) mapOfPolicyParameters.put('currentBalance16', String.valueOf(cibil.Current_Balance16__c));
                if (!CommonUtility.isEmpty(cibil.Current_Balance17__c)) mapOfPolicyParameters.put('currentBalance17', String.valueOf(cibil.Current_Balance17__c));
                if (!CommonUtility.isEmpty(cibil.Current_Balance18__c)) mapOfPolicyParameters.put('currentBalance18', String.valueOf(cibil.Current_Balance18__c));
                if (!CommonUtility.isEmpty(cibil.Current_Balance19__c)) mapOfPolicyParameters.put('currentBalance19', String.valueOf(cibil.Current_Balance19__c));

                if (!CommonUtility.isEmpty(cibil.Amount_Overdue__c)) mapOfPolicyParameters.put('amountOverdue', String.valueOf(cibil.Amount_Overdue__c));
                if (!CommonUtility.isEmpty(cibil.Amount_Overdue1__c)) mapOfPolicyParameters.put('amountOverdue1', String.valueOf(cibil.Amount_Overdue1__c));
                if (!CommonUtility.isEmpty(cibil.Amount_Overdue2__c)) mapOfPolicyParameters.put('amountOverdue2', String.valueOf(cibil.Amount_Overdue2__c));
                if (!CommonUtility.isEmpty(cibil.Amount_Overdue3__c)) mapOfPolicyParameters.put('amountOverdue3', String.valueOf(cibil.Amount_Overdue3__c));
                if (!CommonUtility.isEmpty(cibil.Amount_Overdue4__c)) mapOfPolicyParameters.put('amountOverdue4', String.valueOf(cibil.Amount_Overdue4__c));
                if (!CommonUtility.isEmpty(cibil.Amount_Overdue5__c)) mapOfPolicyParameters.put('amountOverdue5', String.valueOf(cibil.Amount_Overdue5__c));
                if (!CommonUtility.isEmpty(cibil.Amount_Overdue6__c)) mapOfPolicyParameters.put('amountOverdue6', String.valueOf(cibil.Amount_Overdue6__c));
                if (!CommonUtility.isEmpty(cibil.Amount_Overdue7__c)) mapOfPolicyParameters.put('amountOverdue7', String.valueOf(cibil.Amount_Overdue7__c));
                if (!CommonUtility.isEmpty(cibil.Amount_Overdue8__c)) mapOfPolicyParameters.put('amountOverdue8', String.valueOf(cibil.Amount_Overdue8__c));
                if (!CommonUtility.isEmpty(cibil.Amount_Overdue9__c)) mapOfPolicyParameters.put('amountOverdue9', String.valueOf(cibil.Amount_Overdue9__c));
                if (!CommonUtility.isEmpty(cibil.Amount_Overdue10__c)) mapOfPolicyParameters.put('amountOverdue10', String.valueOf(cibil.Amount_Overdue10__c));
                if (!CommonUtility.isEmpty(cibil.Amount_Overdue11__c)) mapOfPolicyParameters.put('amountOverdue11', String.valueOf(cibil.Amount_Overdue11__c));
                if (!CommonUtility.isEmpty(cibil.Amount_Overdue12__c)) mapOfPolicyParameters.put('amountOverdue12', String.valueOf(cibil.Amount_Overdue12__c));
                if (!CommonUtility.isEmpty(cibil.Amount_Overdue13__c)) mapOfPolicyParameters.put('amountOverdue13', String.valueOf(cibil.Amount_Overdue13__c));
                if (!CommonUtility.isEmpty(cibil.Amount_Overdue14__c)) mapOfPolicyParameters.put('amountOverdue14', String.valueOf(cibil.Amount_Overdue14__c));
                if (!CommonUtility.isEmpty(cibil.Amount_Overdue15__c)) mapOfPolicyParameters.put('amountOverdue15', String.valueOf(cibil.Amount_Overdue15__c));
                if (!CommonUtility.isEmpty(cibil.Amount_Overdue16__c)) mapOfPolicyParameters.put('amountOverdue16', String.valueOf(cibil.Amount_Overdue16__c));
                if (!CommonUtility.isEmpty(cibil.Amount_Overdue17__c)) mapOfPolicyParameters.put('amountOverdue17', String.valueOf(cibil.Amount_Overdue17__c));
                if (!CommonUtility.isEmpty(cibil.Amount_Overdue18__c)) mapOfPolicyParameters.put('amountOverdue18', String.valueOf(cibil.Amount_Overdue18__c));
                if (!CommonUtility.isEmpty(cibil.Amount_Overdue19__c)) mapOfPolicyParameters.put('amountOverdue19', String.valueOf(cibil.Amount_Overdue19__c));

                DateTime dt;
                String dtFormat = 'YYYY-MM-dd';
                if (!CommonUtility.isEmpty(cibil.Date_Reported__c)) {
                    dt = datetime.newInstance(cibil.Date_Reported__c.year(), cibil.Date_Reported__c.month(), cibil.Date_Reported__c.day());
                    mapOfPolicyParameters.put('dateReported', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Reported1__c)) {
                    dt = datetime.newInstance(cibil.Date_Reported1__c.year(), cibil.Date_Reported1__c.month(), cibil.Date_Reported1__c.day());
                    mapOfPolicyParameters.put('dateReported1', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Reported2__c)) {
                    dt = datetime.newInstance(cibil.Date_Reported2__c.year(), cibil.Date_Reported2__c.month(), cibil.Date_Reported2__c.day());
                    mapOfPolicyParameters.put('dateReported2', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Reported3__c)) {
                    dt = datetime.newInstance(cibil.Date_Reported3__c.year(), cibil.Date_Reported3__c.month(), cibil.Date_Reported3__c.day());
                    mapOfPolicyParameters.put('dateReported3', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Reported4__c)) {
                    dt = datetime.newInstance(cibil.Date_Reported4__c.year(), cibil.Date_Reported4__c.month(), cibil.Date_Reported4__c.day());
                    mapOfPolicyParameters.put('dateReported4', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Reported5__c)) {
                    dt = datetime.newInstance(cibil.Date_Reported5__c.year(), cibil.Date_Reported5__c.month(), cibil.Date_Reported5__c.day());
                    mapOfPolicyParameters.put('dateReported5', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Reported6__c)) {
                    dt = datetime.newInstance(cibil.Date_Reported6__c.year(), cibil.Date_Reported6__c.month(), cibil.Date_Reported6__c.day());
                    mapOfPolicyParameters.put('dateReported6', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Reported7__c)) {
                    dt = datetime.newInstance(cibil.Date_Reported7__c.year(), cibil.Date_Reported7__c.month(), cibil.Date_Reported7__c.day());
                    mapOfPolicyParameters.put('dateReported7', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Reported8__c)) {
                    dt = datetime.newInstance(cibil.Date_Reported8__c.year(), cibil.Date_Reported8__c.month(), cibil.Date_Reported8__c.day());
                    mapOfPolicyParameters.put('dateReported8', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Reported9__c)) {
                    dt = datetime.newInstance(cibil.Date_Reported9__c.year(), cibil.Date_Reported9__c.month(), cibil.Date_Reported9__c.day());
                    mapOfPolicyParameters.put('dateReported9', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Reported10__c)) {
                    dt = datetime.newInstance(cibil.Date_Reported10__c.year(), cibil.Date_Reported10__c.month(), cibil.Date_Reported10__c.day());
                    mapOfPolicyParameters.put('dateReported10', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Reported11__c)) {
                    dt = datetime.newInstance(cibil.Date_Reported11__c.year(), cibil.Date_Reported11__c.month(), cibil.Date_Reported11__c.day());
                    mapOfPolicyParameters.put('dateReported11', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Reported12__c)) {
                    dt = datetime.newInstance(cibil.Date_Reported12__c.year(), cibil.Date_Reported12__c.month(), cibil.Date_Reported12__c.day());
                    mapOfPolicyParameters.put('dateReported12', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Reported13__c)) {
                    dt = datetime.newInstance(cibil.Date_Reported13__c.year(), cibil.Date_Reported13__c.month(), cibil.Date_Reported13__c.day());
                    mapOfPolicyParameters.put('dateReported13', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Reported14__c)) {
                    dt = datetime.newInstance(cibil.Date_Reported14__c.year(), cibil.Date_Reported14__c.month(), cibil.Date_Reported14__c.day());
                    mapOfPolicyParameters.put('dateReported14', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Reported15__c)) {
                    dt = datetime.newInstance(cibil.Date_Reported15__c.year(), cibil.Date_Reported15__c.month(), cibil.Date_Reported15__c.day());
                    mapOfPolicyParameters.put('dateReported15', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Reported16__c)) {
                    dt = datetime.newInstance(cibil.Date_Reported16__c.year(), cibil.Date_Reported16__c.month(), cibil.Date_Reported16__c.day());
                    mapOfPolicyParameters.put('dateReported16', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Reported17__c)) {
                    dt = datetime.newInstance(cibil.Date_Reported17__c.year(), cibil.Date_Reported17__c.month(), cibil.Date_Reported17__c.day());
                    mapOfPolicyParameters.put('dateReported17', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Reported18__c)) {
                    dt = datetime.newInstance(cibil.Date_Reported18__c.year(), cibil.Date_Reported18__c.month(), cibil.Date_Reported18__c.day());
                    mapOfPolicyParameters.put('dateReported18', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Reported19__c)) {
                    dt = datetime.newInstance(cibil.Date_Reported19__c.year(), cibil.Date_Reported19__c.month(), cibil.Date_Reported19__c.day());
                    mapOfPolicyParameters.put('dateReported19', dt.format(dtFormat));
                }

                if (!CommonUtility.isEmpty(cibil.Date_Closed__c)) {
                    dt = datetime.newInstance(cibil.Date_Closed__c.year(), cibil.Date_Closed__c.month(), cibil.Date_Closed__c.day());
                    mapOfPolicyParameters.put('dateClosed', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Closed1__c)) {
                    dt = datetime.newInstance(cibil.Date_Closed1__c.year(), cibil.Date_Closed1__c.month(), cibil.Date_Closed1__c.day());
                    mapOfPolicyParameters.put('dateClosed1', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Closed2__c)) {
                    dt = datetime.newInstance(cibil.Date_Closed2__c.year(), cibil.Date_Closed2__c.month(), cibil.Date_Closed2__c.day());
                    mapOfPolicyParameters.put('dateClosed2', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Closed3__c)) {
                    dt = datetime.newInstance(cibil.Date_Closed3__c.year(), cibil.Date_Closed3__c.month(), cibil.Date_Closed3__c.day());
                    mapOfPolicyParameters.put('dateClosed3', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Closed4__c)) {
                    dt = datetime.newInstance(cibil.Date_Closed4__c.year(), cibil.Date_Closed4__c.month(), cibil.Date_Closed4__c.day());
                    mapOfPolicyParameters.put('dateClosed4', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Closed5__c)) {
                    dt = datetime.newInstance(cibil.Date_Closed5__c.year(), cibil.Date_Closed5__c.month(), cibil.Date_Closed5__c.day());
                    mapOfPolicyParameters.put('dateClosed5', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Closed6__c)) {
                    dt = datetime.newInstance(cibil.Date_Closed6__c.year(), cibil.Date_Closed6__c.month(), cibil.Date_Closed6__c.day());
                    mapOfPolicyParameters.put('dateClosed6', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Closed7__c)) {
                    dt = datetime.newInstance(cibil.Date_Closed7__c.year(), cibil.Date_Closed7__c.month(), cibil.Date_Closed7__c.day());
                    mapOfPolicyParameters.put('dateClosed7', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Closed8__c)) {
                    dt = datetime.newInstance(cibil.Date_Closed8__c.year(), cibil.Date_Closed8__c.month(), cibil.Date_Closed8__c.day());
                    mapOfPolicyParameters.put('dateClosed8', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Closed9__c)) {
                    dt = datetime.newInstance(cibil.Date_Closed9__c.year(), cibil.Date_Closed9__c.month(), cibil.Date_Closed9__c.day());
                    mapOfPolicyParameters.put('dateClosed9', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Closed10__c)) {
                    dt = datetime.newInstance(cibil.Date_Closed10__c.year(), cibil.Date_Closed10__c.month(), cibil.Date_Closed10__c.day());
                    mapOfPolicyParameters.put('dateClosed10', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Closed11__c)) {
                    dt = datetime.newInstance(cibil.Date_Closed11__c.year(), cibil.Date_Closed11__c.month(), cibil.Date_Closed11__c.day());
                    mapOfPolicyParameters.put('dateClosed11', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Closed12__c)) {
                    dt = datetime.newInstance(cibil.Date_Closed12__c.year(), cibil.Date_Closed12__c.month(), cibil.Date_Closed12__c.day());
                    mapOfPolicyParameters.put('dateClosed12', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Closed13__c)) {
                    dt = datetime.newInstance(cibil.Date_Closed13__c.year(), cibil.Date_Closed13__c.month(), cibil.Date_Closed13__c.day());
                    mapOfPolicyParameters.put('dateClosed13', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Closed14__c)) {
                    dt = datetime.newInstance(cibil.Date_Closed14__c.year(), cibil.Date_Closed14__c.month(), cibil.Date_Closed14__c.day());
                    mapOfPolicyParameters.put('dateClosed14', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Closed15__c)) {
                    dt = datetime.newInstance(cibil.Date_Closed15__c.year(), cibil.Date_Closed15__c.month(), cibil.Date_Closed15__c.day());
                    mapOfPolicyParameters.put('dateClosed15', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Closed16__c)) {
                    dt = datetime.newInstance(cibil.Date_Closed16__c.year(), cibil.Date_Closed16__c.month(), cibil.Date_Closed16__c.day());
                    mapOfPolicyParameters.put('dateClosed16', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Closed17__c)) {
                    dt = datetime.newInstance(cibil.Date_Closed17__c.year(), cibil.Date_Closed17__c.month(), cibil.Date_Closed17__c.day());
                    mapOfPolicyParameters.put('dateClosed17', dt.format(dtFormat));
                }
                if (!CommonUtility.isEmpty(cibil.Date_Closed18__c)) {
                    dt = datetime.newInstance(cibil.Date_Closed18__c.year(), cibil.Date_Closed18__c.month(), cibil.Date_Closed18__c.day());
                    mapOfPolicyParameters.put('dateClosed18', dt.format(dtFormat));
                }

                if (!CommonUtility.isEmpty(cibilExtn.Write_Off__c)) mapOfPolicyParameters.put('write_Off', String.valueOf(cibilExtn.Write_Off__c));

                if (!CommonUtility.isEmpty(cibilExtn.Written_Off_principal__c)) mapOfPolicyParameters.put('writtenOffPrincipal', String.valueOf(cibilExtn.Written_Off_principal__c));
                if (!CommonUtility.isEmpty(cibilExtn.Written_Off_principal1__c)) mapOfPolicyParameters.put('writtenOffPrincipal1', String.valueOf(cibilExtn.Written_Off_principal1__c));
                if (!CommonUtility.isEmpty(cibilExtn.Written_Off_principal2__c)) mapOfPolicyParameters.put('writtenOffPrincipal2', String.valueOf(cibilExtn.Written_Off_principal2__c));
                if (!CommonUtility.isEmpty(cibilExtn.Written_Off_principal3__c)) mapOfPolicyParameters.put('writtenOffPrincipal3', String.valueOf(cibilExtn.Written_Off_principal3__c));
                if (!CommonUtility.isEmpty(cibilExtn.Written_Off_principal4__c)) mapOfPolicyParameters.put('writtenOffPrincipal4', String.valueOf(cibilExtn.Written_Off_principal4__c));
                if (!CommonUtility.isEmpty(cibilExtn.Written_Off_principal5__c)) mapOfPolicyParameters.put('writtenOffPrincipal5', String.valueOf(cibilExtn.Written_Off_principal5__c));
                if (!CommonUtility.isEmpty(cibilExtn.Written_Off_principal6__c)) mapOfPolicyParameters.put('writtenOffPrincipal6', String.valueOf(cibilExtn.Written_Off_principal6__c));
                if (!CommonUtility.isEmpty(cibilExtn.Written_Off_principal7__c)) mapOfPolicyParameters.put('writtenOffPrincipal7', String.valueOf(cibilExtn.Written_Off_principal7__c));
                if (!CommonUtility.isEmpty(cibilExtn.Written_Off_principal8__c)) mapOfPolicyParameters.put('writtenOffPrincipal8', String.valueOf(cibilExtn.Written_Off_principal8__c));
                if (!CommonUtility.isEmpty(cibilExtn.Written_Off_principal9__c)) mapOfPolicyParameters.put('writtenOffPrincipal9', String.valueOf(cibilExtn.Written_Off_principal9__c));
                if (!CommonUtility.isEmpty(cibilExtn.Written_Off_principal10__c)) mapOfPolicyParameters.put('writtenOffPrincipal10', String.valueOf(cibilExtn.Written_Off_principal10__c));
                if (!CommonUtility.isEmpty(cibilExtn.Written_Off_principal11__c)) mapOfPolicyParameters.put('writtenOffPrincipal11', String.valueOf(cibilExtn.Written_Off_principal11__c));
                if (!CommonUtility.isEmpty(cibilExtn.Written_Off_principal12__c)) mapOfPolicyParameters.put('writtenOffPrincipal12', String.valueOf(cibilExtn.Written_Off_principal12__c));
                if (!CommonUtility.isEmpty(cibilExtn.Written_Off_principal13__c)) mapOfPolicyParameters.put('writtenOffPrincipal13', String.valueOf(cibilExtn.Written_Off_principal13__c));
                if (!CommonUtility.isEmpty(cibilExtn.Written_Off_principal14__c)) mapOfPolicyParameters.put('writtenOffPrincipal14', String.valueOf(cibilExtn.Written_Off_principal14__c));
                if (!CommonUtility.isEmpty(cibilExtn.Written_Off_principal15__c)) mapOfPolicyParameters.put('writtenOffPrincipal15', String.valueOf(cibilExtn.Written_Off_principal15__c));
                if (!CommonUtility.isEmpty(cibilExtn.Written_Off_principal16__c)) mapOfPolicyParameters.put('writtenOffPrincipal16', String.valueOf(cibilExtn.Written_Off_principal16__c));
                if (!CommonUtility.isEmpty(cibilExtn.Written_Off_principal17__c)) mapOfPolicyParameters.put('writtenOffPrincipal17', String.valueOf(cibilExtn.Written_Off_principal17__c));
                if (!CommonUtility.isEmpty(cibilExtn.Written_Off_principal18__c)) mapOfPolicyParameters.put('writtenOffPrincipal18', String.valueOf(cibilExtn.Written_Off_principal18__c));
                if (!CommonUtility.isEmpty(cibilExtn.Written_Off_principal19__c)) mapOfPolicyParameters.put('writtenOffPrincipal19', String.valueOf(cibilExtn.Written_Off_principal19__c));

                if (!CommonUtility.isEmpty(cibil.Member__c)) mapOfPolicyParameters.put('member', String.valueOf(cibil.Member__c));

                //if (!CommonUtility.isEmpty(cibil.Date_of_Enquiry__c)) mapOfPolicyParameters.put('dateOfEnquiry', String.valueOf(cibil.Date_of_Enquiry__c));
                /*** Bug Id :- 10694  START***/
                if (!CommonUtility.isEmpty(cibil.Date_of_Enquiry__c)){
                  if(cibil.Date_of_Enquiry__c.length() == 8){
                    dt = datetime.newInstance(Integer.valueof(cibil.Date_of_Enquiry__c.substring(4,8)), Integer.valueof(cibil.Date_of_Enquiry__c.substring(2,4)), Integer.valueof(cibil.Date_of_Enquiry__c.substring(0,2)));
                    mapOfPolicyParameters.put('dateOfEnquiry', dt.format(dtFormat)); 
                  }else
                    mapOfPolicyParameters.put('dateOfEnquiry', null);
                } 
                /*** Bug Id :- 10694  END***/  

                if (!CommonUtility.isEmpty(cibil.Enquiry_Purpose__c)) mapOfPolicyParameters.put('enquiryPurpose', String.valueOf(cibil.Enquiry_Purpose__c));
                if (!CommonUtility.isEmpty(cibil.Enquiry_Purpose1__c)) mapOfPolicyParameters.put('enquiryPurpose1', String.valueOf(cibil.Enquiry_Purpose1__c));
                if (!CommonUtility.isEmpty(cibil.Enquiry_Purpose2__c)) mapOfPolicyParameters.put('enquiryPurpose2', String.valueOf(cibil.Enquiry_Purpose2__c));
                if (!CommonUtility.isEmpty(cibil.Enquiry_Purpose3__c)) mapOfPolicyParameters.put('enquiryPurpose3', String.valueOf(cibil.Enquiry_Purpose3__c));
                if (!CommonUtility.isEmpty(cibil.Enquiry_Purpose4__c)) mapOfPolicyParameters.put('enquiryPurpose4', String.valueOf(cibil.Enquiry_Purpose4__c));
                if (!CommonUtility.isEmpty(cibil.Enquiry_Purpose5__c)) mapOfPolicyParameters.put('enquiryPurpose5', String.valueOf(cibil.Enquiry_Purpose5__c));
                if (!CommonUtility.isEmpty(cibil.Enquiry_Purpose6__c)) mapOfPolicyParameters.put('enquiryPurpose6', String.valueOf(cibil.Enquiry_Purpose6__c));
                if (!CommonUtility.isEmpty(cibil.Enquiry_Purpose7__c)) mapOfPolicyParameters.put('enquiryPurpose7', String.valueOf(cibil.Enquiry_Purpose7__c));
                if (!CommonUtility.isEmpty(cibil.Enquiry_Purpose8__c)) mapOfPolicyParameters.put('enquiryPurpose8', String.valueOf(cibil.Enquiry_Purpose8__c));
                if (!CommonUtility.isEmpty(cibil.Enquiry_Purpose9__c)) mapOfPolicyParameters.put('enquiryPurpose9', String.valueOf(cibil.Enquiry_Purpose9__c));
                if (!CommonUtility.isEmpty(cibil.Enquiry_Purpose10__c)) mapOfPolicyParameters.put('enquiryPurpose10', String.valueOf(cibil.Enquiry_Purpose10__c));
                if (!CommonUtility.isEmpty(cibil.Enquiry_Purpose11__c)) mapOfPolicyParameters.put('enquiryPurpose11', String.valueOf(cibil.Enquiry_Purpose11__c));
                if (!CommonUtility.isEmpty(cibil.Enquiry_Purpose12__c)) mapOfPolicyParameters.put('enquiryPurpose12', String.valueOf(cibil.Enquiry_Purpose12__c));
                if (!CommonUtility.isEmpty(cibil.Enquiry_Purpose13__c)) mapOfPolicyParameters.put('enquiryPurpose13', String.valueOf(cibil.Enquiry_Purpose13__c));
                if (!CommonUtility.isEmpty(cibil.Enquiry_Purpose14__c)) mapOfPolicyParameters.put('enquiryPurpose14', String.valueOf(cibil.Enquiry_Purpose14__c));
                if (!CommonUtility.isEmpty(cibil.Enquiry_Purpose15__c)) mapOfPolicyParameters.put('enquiryPurpose15', String.valueOf(cibil.Enquiry_Purpose15__c));
                if (!CommonUtility.isEmpty(cibil.Enquiry_Purpose16__c)) mapOfPolicyParameters.put('enquiryPurpose16', String.valueOf(cibil.Enquiry_Purpose16__c));
                if (!CommonUtility.isEmpty(cibil.Enquiry_Purpose17__c)) mapOfPolicyParameters.put('enquiryPurpose17', String.valueOf(cibil.Enquiry_Purpose17__c));
                if (!CommonUtility.isEmpty(cibil.Enquiry_Purpose18__c)) mapOfPolicyParameters.put('enquiryPurpose18', String.valueOf(cibil.Enquiry_Purpose18__c));
                if (!CommonUtility.isEmpty(cibil.Enquiry_Purpose19__c)) mapOfPolicyParameters.put('enquiryPurpose19', String.valueOf(cibil.Enquiry_Purpose19__c));

                if (!CommonUtility.isEmpty(cibil.Member_Name1__c)) mapOfPolicyParameters.put('memberName1', String.valueOf(cibil.Member_Name1__c));
                if (!CommonUtility.isEmpty(cibil.Member_Name2__c)) mapOfPolicyParameters.put('memberName2', String.valueOf(cibil.Member_Name2__c));
                if (!CommonUtility.isEmpty(cibil.Member_Name3__c)) mapOfPolicyParameters.put('memberName3', String.valueOf(cibil.Member_Name3__c));
                if (!CommonUtility.isEmpty(cibil.Member_Name4__c)) mapOfPolicyParameters.put('memberName4', String.valueOf(cibil.Member_Name4__c));
                if (!CommonUtility.isEmpty(cibil.Member_Name5__c)) mapOfPolicyParameters.put('memberName5', String.valueOf(cibil.Member_Name5__c));
                if (!CommonUtility.isEmpty(cibil.Member_Name6__c)) mapOfPolicyParameters.put('memberName6', String.valueOf(cibil.Member_Name6__c));
                if (!CommonUtility.isEmpty(cibil.Member_Name7__c)) mapOfPolicyParameters.put('memberName7', String.valueOf(cibil.Member_Name7__c));
                if (!CommonUtility.isEmpty(cibil.Member_Name8__c)) mapOfPolicyParameters.put('memberName8', String.valueOf(cibil.Member_Name8__c));
                if (!CommonUtility.isEmpty(cibil.Member_Name9__c)) mapOfPolicyParameters.put('memberName9', String.valueOf(cibil.Member_Name9__c));
                if (!CommonUtility.isEmpty(cibil.Member_Name10__c)) mapOfPolicyParameters.put('memberName10', String.valueOf(cibil.Member_Name10__c));
                if (!CommonUtility.isEmpty(cibil.Member_Name11__c)) mapOfPolicyParameters.put('memberName11', String.valueOf(cibil.Member_Name11__c));
                if (!CommonUtility.isEmpty(cibil.Member_Name12__c)) mapOfPolicyParameters.put('memberName12', String.valueOf(cibil.Member_Name12__c));
                if (!CommonUtility.isEmpty(cibil.Member_Name13__c)) mapOfPolicyParameters.put('memberName13', String.valueOf(cibil.Member_Name13__c));
                if (!CommonUtility.isEmpty(cibil.Member_Name14__c)) mapOfPolicyParameters.put('memberName14', String.valueOf(cibil.Member_Name14__c));
                if (!CommonUtility.isEmpty(cibil.Member_Name15__c)) mapOfPolicyParameters.put('memberName15', String.valueOf(cibil.Member_Name15__c));
                if (!CommonUtility.isEmpty(cibil.Member_Name16__c)) mapOfPolicyParameters.put('memberName16', String.valueOf(cibil.Member_Name16__c));
                if (!CommonUtility.isEmpty(cibil.Member_Name17__c)) mapOfPolicyParameters.put('memberName17', String.valueOf(cibil.Member_Name17__c));
                if (!CommonUtility.isEmpty(cibil.Member_Name18__c)) mapOfPolicyParameters.put('memberName18', String.valueOf(cibil.Member_Name18__c));
                if (!CommonUtility.isEmpty(cibil.Member_Name19__c)) mapOfPolicyParameters.put('memberName19', String.valueOf(cibil.Member_Name19__c));
                if (!CommonUtility.isEmpty(cibil.Member_Name20__c)) mapOfPolicyParameters.put('memberName', String.valueOf(cibil.Member_Name20__c));

                if (!CommonUtility.isEmpty(cibil.Account_Type__c)) mapOfPolicyParameters.put('accountType', String.valueOf(cibil.Account_Type__c));
                if (!CommonUtility.isEmpty(cibil.Account_Type1__c)) mapOfPolicyParameters.put('accountType1', String.valueOf(cibil.Account_Type1__c));
                if (!CommonUtility.isEmpty(cibil.Account_Type2__c)) mapOfPolicyParameters.put('accountType2', String.valueOf(cibil.Account_Type2__c));
                if (!CommonUtility.isEmpty(cibil.Account_Type3__c)) mapOfPolicyParameters.put('accountType3', String.valueOf(cibil.Account_Type3__c));
                if (!CommonUtility.isEmpty(cibil.Account_Type4__c)) mapOfPolicyParameters.put('accountType4', String.valueOf(cibil.Account_Type4__c));
                if (!CommonUtility.isEmpty(cibil.Account_Type5__c)) mapOfPolicyParameters.put('accountType5', String.valueOf(cibil.Account_Type5__c));
                if (!CommonUtility.isEmpty(cibil.Account_Type6__c)) mapOfPolicyParameters.put('accountType6', String.valueOf(cibil.Account_Type6__c));
                if (!CommonUtility.isEmpty(cibil.Account_Type7__c)) mapOfPolicyParameters.put('accountType7', String.valueOf(cibil.Account_Type7__c));
                if (!CommonUtility.isEmpty(cibil.Account_Type8__c)) mapOfPolicyParameters.put('accountType8', String.valueOf(cibil.Account_Type8__c));
                if (!CommonUtility.isEmpty(cibil.Account_Type9__c)) mapOfPolicyParameters.put('accountType9', String.valueOf(cibil.Account_Type9__c));
                if (!CommonUtility.isEmpty(cibil.Account_Type10__c)) mapOfPolicyParameters.put('accountType10', String.valueOf(cibil.Account_Type10__c));
                if (!CommonUtility.isEmpty(cibil.Account_Type11__c)) mapOfPolicyParameters.put('accountType11', String.valueOf(cibil.Account_Type11__c));
                if (!CommonUtility.isEmpty(cibil.Account_Type12__c)) mapOfPolicyParameters.put('accountType12', String.valueOf(cibil.Account_Type12__c));
                if (!CommonUtility.isEmpty(cibil.Account_Type13__c)) mapOfPolicyParameters.put('accountType13', String.valueOf(cibil.Account_Type13__c));
                if (!CommonUtility.isEmpty(cibil.Account_Type14__c)) mapOfPolicyParameters.put('accountType14', String.valueOf(cibil.Account_Type14__c));
                if (!CommonUtility.isEmpty(cibil.Account_Type15__c)) mapOfPolicyParameters.put('accountType15', String.valueOf(cibil.Account_Type15__c));
                if (!CommonUtility.isEmpty(cibil.Account_Type16__c)) mapOfPolicyParameters.put('accountType16', String.valueOf(cibil.Account_Type16__c));
                if (!CommonUtility.isEmpty(cibil.Account_Type17__c)) mapOfPolicyParameters.put('accountType17', String.valueOf(cibil.Account_Type17__c));
                if (!CommonUtility.isEmpty(cibil.Account_Type18__c)) mapOfPolicyParameters.put('accountType18', String.valueOf(cibil.Account_Type18__c));
                if (!CommonUtility.isEmpty(cibil.Account_Type19__c)) mapOfPolicyParameters.put('accountType19', String.valueOf(cibil.Account_Type19__c));

                system.debug('*****mapOfPolicyParameters***' + mapOfPolicyParameters);
                BRECalloutCls breObj = new BRECalloutCls();
                mapOfPolicyResult = breObj.callBRECIBILCheck(mapOfPolicyParameters);

                String FinalCIBILResult = '';
                system.debug('*****mapOfPolicyResult***' + mapOfPolicyResult);

                if (mapOfPolicyResult != null && mapOfPolicyResult.size() > 0) {

                    FinalCIBILResult = mapOfPolicyResult.get('FinalResult');
                    system.debug('FinalCIBILResult***' + FinalCIBILResult);
                    String CIBILResult = mapOfPolicyResult.get('PolicyList');
                    if (('REJECT').equalsIgnoreCase(FinalCIBILResult) || ('REJECTED').equalsIgnoreCase(FinalCIBILResult) ||
                        ('AUTO REJECT').equalsIgnoreCase(FinalCIBILResult) || ('AUTO REJECTED').equalsIgnoreCase(FinalCIBILResult) ||
                        ('AUTOREJECT').equalsIgnoreCase(FinalCIBILResult) || ('AUTOREJECTED').equalsIgnoreCase(FinalCIBILResult) ||
                        ('REFER').equalsIgnoreCase(FinalCIBILResult)) {

                        if (!isEmpty(CIBILResult))
                            createPolicyRecord(CIBILResult, FinalCIBILResult, opp.id, app.id);

                        //update opportunity stage
                        if (isEmpty(opp.StageName) || (!isEmpty(opp.StageName) && !opp.StageName.toLowerCase().contains('reject'))) {
                            opp.StageName = FinalCIBILResult;
                            update opp;
                        }
                    }
                }
            }
        } catch (Exception e) {
            //return null;
        }
    }

    public static void createPolicyRecord(String policyNames, String policyStatus, Id oppId, Id applicantId) {
        List < SOL_Policy__c > policyLists = new List < SOL_Policy__c > ();
        Map<String,Id> existingPolicyIdNameMap = new Map<String,Id>();
        List<SOL_Policy__c> policyToDelLst =  new List<SOL_Policy__c>(); 
        Schema.SObjectType result=oppId.getSObjectType();
            String resultFinal = String.valueOf(result);
            System.debug('final result'+resultFinal);
        if(resultFinal == 'Product_Offerings__c')
        {
            for(SOL_Policy__c sp:[SELECT Id,Policy_Name__c FROM SOL_Policy__c WHERE Product_Offerings__c = :oppId LIMIT :(Limits.getLimitQueryRows()- Limits.getQueryRows())]){
            existingPolicyIdNameMap.put(sp.Policy_Name__c,sp.Id);
            }
        }
        else{
            for(SOL_Policy__c sp:[SELECT Id,Policy_Name__c FROM SOL_Policy__c WHERE Loan_Application__c = :oppId LIMIT :(Limits.getLimitQueryRows()- Limits.getQueryRows())]){
            existingPolicyIdNameMap.put(sp.Policy_Name__c,sp.Id);
            }
        }
        
        for (String policyName: policyNames.split(',')) {
            
            if (!isEmpty(policyName) /* && str.ToUpperCase().contains('FAIL')*/ ) {
                String perPolicyStatus = policyStatus;
                String perPolicyName = policyName;
                List < String > polLst = policyName.split(':::');
                if (polLst.size() == 2) {
                    perPolicyName = polLst[0];
                    perPolicyStatus = polLst[1];
                }
                
                if(existingPolicyIdNameMap.containsKey(perPolicyName))
                    if(!isEmpty(existingPolicyIdNameMap.get(perPolicyName)))
                        policyToDelLst.add(new SOL_Policy__c(id=existingPolicyIdNameMap.get(perPolicyName)));
                
                SOL_Policy__c sp = new SOL_Policy__c();
                sp.Policy_Name__c = perPolicyName;
                sp.Policy_Status__c = perPolicyStatus.toUpperCase();
                if(resultFinal == 'Product_Offerings__c')
                {
                    sp.Product_Offerings__c = oppId;
                }else{
                    sp.Loan_Application__c = oppId;
                    sp.Applicant_Name__c = applicantId;
                }
                

                policyLists.add(sp);
                existingPolicyIdNameMap.put(perPolicyName,null);
            }
        }
        
        if(!isEmpty(policyToDelLst))
            Database.delete(policyToDelLst);
        
        if (!isEmpty(policyLists))
            Database.insert(policyLists);
    
    }


    /**
     *  @description - Checks the passed in input field for emptyness and return boolean value.
     *  @param value - name of the field
     *  @return flag -  value of input field
     */
    public static boolean isEmpty(String value) {
        boolean flag = false;
        if (value == null || ('').equals(value.trim()) || value.trim() == '') {
            flag = true;
        }
        return flag;
    }

    /**
     *  @description - Checks the passed in input field for emptyness and return boolean value.
     *  @param objList - List<SObject>
     *  @return flag -  value of input field
     */
    public static boolean isEmpty(List < SObject > objList) {
        if (objList == null || objList.size() == 0) {
            return true;
        } else {
            return false;
        }
    }

    /**
     *  @description - Checks the passed in input field for emptyness and return boolean value.
     *  @param obj - SObject
     *  @return flag -  value of input field
     */
    public static boolean isEmpty(SObject obj) {
        if (obj == null) {
            return true;
        } else {
            return false;
        }
    }

    /**
     *  @description - Checks the passed in input field for emptyness and return boolean value.
     *  @param objectMap - Map<String,Object>
     *  @return flag -  value of input field
     */
    public static boolean isEmpty(Map < String, Object > objectMap) {
        if (objectMap == null || (objectMap != null && objectMap.size() == 0)) {
            return true;
        } else {
            return false;
        }
    }

    /**
     *  @description - Checks the passed in input field for emptyness and return boolean value.
     *  @param obj - Object
     *  @return flag -  value of input field
     */
    public static boolean isEmpty(Object obj) {
        if (obj != null) {
            if (obj instanceof List < Object > ) {
                List < Object > lst = (List < Object > ) obj;
                if (lst.size() == 0) {
                    return true;
                } else
                    return false;
            } else {
                return false;
            }
        } else {
            return true;
        }

    }

    public static string generateReferenceNumber(String city, String pincode) {

        city = (!isEmpty(city)) ? city : 'other';
        pincode = (!isEmpty(pincode)) ? pincode : '000000';

        String refNum = city.substring(0, 3);
        system.debug('refNum' + refNum);
        refNum = refNum + pincode.substring(3, 6);
        system.debug('refNum' + refNum);

        String rand = String.valueOf(Integer.valueOf(math.round(Math.random() * 1000)));
        if (rand.length() == 1)
            rand = rand + '00';
        if (rand.length() == 2)
            rand = rand + '0';


        String rand1 = String.valueOf(Integer.valueOf(math.round(Math.random() * 1000)));
        if (rand1.length() == 1)
            rand1 = rand1 + '00';
        if (rand1.length() == 2)
            rand1 = rand1 + '0';


        refNum = refNum + rand + rand1;
        system.debug('refNum' + refNum);
        return refNum;
    }

    /*
     * Get Other object details required for CIBIL check from CIBIL Id
     */
    private static Map < String, Object > getObjectMapFromCibil(String cibilId) {
        Map < String, Object > objMap;
        if (!CommonUtility.isEmpty(cibilId)) {
            objMap = new Map < String, Object > ();
            List < CIBIL__c > cibil = [
                SELECT
                id, Applicant__c, Applicant__r.Loan_Application__c, Cibil_Temp__c,
                CIBIL_Score__c,
                Member__c, Member1__c, Member2__c, Member3__c, Member4__c, Member5__c, Member6__c, Member7__c, Member8__c, Member9__c, Member10__c, Member11__c, Member12__c, Member13__c, Member14__c, Member15__c, Member16__c, Member17__c, Member18__c, Member19__c,
                Ownership__c, Ownership1__c, Ownership2__c, Ownership3__c, Ownership4__c, Ownership5__c, Ownership6__c, Ownership7__c, Ownership8__c, Ownership9__c, Ownership10__c, Ownership11__c, Ownership12__c, Ownership13__c, Ownership14__c, Ownership15__c, Ownership16__c, Ownership17__c, Ownership18__c, Ownership19__c,
                Suit_Filed_Status__c, Suit_Filed_Status1__c, Suit_Filed_Status2__c, Suit_Filed_Status3__c, Suit_Filed_Status4__c, Suit_Filed_Status5__c, Suit_Filed_Status6__c, Suit_Filed_Status7__c, Suit_Filed_Status8__c, Suit_Filed_Status9__c, Suit_Filed_Status10__c, Suit_Filed_Status11__c, Suit_Filed_Status12__c, Suit_Filed_Status13__c, Suit_Filed_Status14__c, Suit_Filed_Status15__c, Suit_Filed_Status16__c, Suit_Filed_Status17__c, Suit_Filed_Status18__c, Suit_Filed_Status19__c,
                Days_Past_Due__c, Days_Past_Due1__c, Days_Past_Due2__c, Days_Past_Due3__c, Days_Past_Due4__c, Days_Past_Due5__c, Days_Past_Due6__c, Days_Past_Due7__c, Days_Past_Due8__c, Days_Past_Due9__c, Days_Past_Due10__c, Days_Past_Due11__c, Days_Past_Due12__c, Days_Past_Due13__c, Days_Past_Due14__c, Days_Past_Due15__c, Days_Past_Due16__c, Days_Past_Due17__c, Days_Past_Due18__c, Days_Past_Due19__c,
                Current_Balance__c, Current_Balance1__c, Current_Balance2__c, Current_Balance3__c, Current_Balance4__c, Current_Balance5__c, Current_Balance6__c, Current_Balance7__c, Current_Balance8__c, Current_Balance9__c, Current_Balance10__c, Current_Balance11__c, Current_Balance12__c, Current_Balance13__c, Current_Balance14__c, Current_Balance15__c, Current_Balance16__c, Current_Balance17__c, Current_Balance18__c, Current_Balance19__c,
                Amount_Overdue__c, Amount_Overdue1__c, Amount_Overdue2__c, Amount_Overdue3__c, Amount_Overdue4__c, Amount_Overdue5__c, Amount_Overdue6__c, Amount_Overdue7__c, Amount_Overdue8__c, Amount_Overdue9__c, Amount_Overdue10__c, Amount_Overdue11__c, Amount_Overdue12__c, Amount_Overdue13__c, Amount_Overdue14__c, Amount_Overdue15__c, Amount_Overdue16__c, Amount_Overdue17__c, Amount_Overdue18__c, Amount_Overdue19__c,
                Date_Reported__c, Date_Reported1__c, Date_Reported2__c, Date_Reported3__c, Date_Reported4__c, Date_Reported5__c, Date_Reported6__c, Date_Reported7__c, Date_Reported8__c, Date_Reported9__c, Date_Reported10__c, Date_Reported11__c, Date_Reported12__c, Date_Reported13__c, Date_Reported14__c, Date_Reported15__c, Date_Reported16__c, Date_Reported17__c, Date_Reported18__c, Date_Reported19__c,
                Date_Closed__c, Date_Closed1__c, Date_Closed2__c, Date_Closed3__c, Date_Closed4__c, Date_Closed5__c, Date_Closed6__c, Date_Closed7__c, Date_Closed8__c, Date_Closed9__c, Date_Closed10__c, Date_Closed11__c, Date_Closed12__c, Date_Closed13__c, Date_Closed14__c, Date_Closed15__c, Date_Closed16__c, Date_Closed17__c, Date_Closed18__c,
                Enquiry_Purpose__c, Enquiry_Purpose1__c, Enquiry_Purpose2__c, Enquiry_Purpose3__c, Enquiry_Purpose4__c, Enquiry_Purpose5__c, Enquiry_Purpose6__c, Enquiry_Purpose7__c, Enquiry_Purpose8__c, Enquiry_Purpose9__c, Enquiry_Purpose10__c, Enquiry_Purpose11__c, Enquiry_Purpose12__c, Enquiry_Purpose13__c, Enquiry_Purpose14__c, Enquiry_Purpose15__c, Enquiry_Purpose16__c, Enquiry_Purpose17__c, Enquiry_Purpose18__c, Enquiry_Purpose19__c,
                Member_Name1__c, Member_Name2__c, Member_Name3__c, Member_Name4__c, Member_Name5__c, Member_Name6__c, Member_Name7__c, Member_Name8__c, Member_Name9__c, Member_Name10__c, Member_Name11__c, Member_Name12__c, Member_Name13__c, Member_Name14__c, Member_Name15__c, Member_Name16__c, Member_Name17__c, Member_Name18__c, Member_Name19__c, Member_Name20__c,
                Account_Type__c, Account_Type1__c, Account_Type2__c, Account_Type3__c, Account_Type4__c, Account_Type5__c, Account_Type6__c, Account_Type7__c, Account_Type8__c, Account_Type9__c, Account_Type10__c, Account_Type11__c, Account_Type12__c, Account_Type13__c, Account_Type14__c, Account_Type15__c, Account_Type16__c, Account_Type17__c, Account_Type18__c, Account_Type19__c,
                Date_of_Enquiry__c
                FROM CIBIL__c
                WHERE Id = : cibilId
            ];

            if (cibil.size() > 0 && !CommonUtility.isEmpty(cibil[0].Applicant__c) &&
                !CommonUtility.isEmpty(cibil[0].Applicant__r.Loan_Application__c)) {
                List < Cibil_Extension1__c > cibilExtn = [
                    SELECT
                    Id, Cibil_Temp__c,
                    Write_Off__c,
                    Written_Off_principal__c, Written_Off_principal1__c, Written_Off_principal2__c, Written_Off_principal3__c, Written_Off_principal4__c, Written_Off_principal5__c, Written_Off_principal6__c, Written_Off_principal7__c, Written_Off_principal8__c, Written_Off_principal9__c, Written_Off_principal10__c, Written_Off_principal11__c, Written_Off_principal12__c, Written_Off_principal13__c, Written_Off_principal14__c, Written_Off_principal15__c, Written_Off_principal16__c, Written_Off_principal17__c, Written_Off_principal18__c, Written_Off_principal19__c
                    FROM Cibil_Extension1__c
                    WHERE Applicant__c = : cibil[0].Applicant__c
                ];

                List < Salaried__c > sal = [
                    SELECT
                    Id, Residence_Type__c,Product_Type__c , Date_Of_Birth__c, month1_sal__c, Total_Employment_vintage_Year__c, Branch_Name__c, Applicant_Type__c, First_Name__c, Last_Name__c, Mobile__c, Office_Email_ID__c, Percentage_Completion__c, Cust_Reference_No__c, Mobile_No_verification_code_to_Verify__c, Office_Email_Verification_Code_to_Verify__c, Mode_of_crediting_salary__c, EMI_bounce__c, Loan_Application__c, Loan_Application__r.Account.id, Loan_Application__r.Account.Applicant__c, Loan_Application__r.Account.Applicant__r.Lead__c, Loan_Application__r.Account.Applicant__r.Contact_Name__c,Branch__c, Branch__r.name
                    ,Sourcing_Channel__r.name,Template__r.Flow__c FROM Salaried__c
                    WHERE Loan_Application__c = : cibil[0].Applicant__r.Loan_Application__c
                ];

                if (sal.size() > 0 && !CommonUtility.isEmpty(sal[0].Loan_Application__r) &&
                    !CommonUtility.isEmpty(sal[0].Loan_Application__r.Account) && !CommonUtility.isEmpty(sal[0].Loan_Application__r.Account.Applicant__c) &&
                    cibilExtn.size() > 0) {
                    List < Opportunity > opp = [SELECT Id, Account.Vintage_with_BAL__c, StageName, Loan_Application_Number__c, Product__c FROM Opportunity WHERE Id = : cibil[0].Applicant__r.Loan_Application__c];
                    List < Applicant__c > app = [SELECT Id, Lead__c, Applicant_Type__c, Lead_Applicants__c FROM Applicant__c WHERE Id = : sal[0].Loan_Application__r.Account.Applicant__c];

                    if (opp.size() > 0 && app.size() > 0) {
                        objMap.put('salObj', sal[0]);
                        objMap.put('oppObj', opp[0]);
                        objMap.put('appObj', app[0]);
                        objMap.put('cibilObj', cibil[0]);
                        objMap.put('cibilExtension1Obj', cibilExtn[0]);
                    }
                }
            }
        }
        system.debug('hihiiii->' + objMap);
        return objMap;
    }

    /*
     * Check if a SOLPolicy is created for the application. 
     * And redirect to rejection/refer page as per applicable 
     *
     */
    public static ResponseDTO checkSOLPolicyForRejectionRefer(String salid, Salaried__c salariedObject, ResponseDTO resDTO, String urlKey) {

system.debug('salid=======>'+salid);
        if (CommonUtility.isEmpty(resDTO))
            resDTO = new ResponseDTO();
        if (CommonUtility.isEmpty(urlKey))
            urlKey = 'apex';
        if (CommonUtility.isEmpty(salariedObject) && !CommonUtility.isEmpty(salid)) {
            List < Salaried__c > salLst = [SELECT Id,Product_Type__c , Loan_Application__c,Template__r.Flow__c FROM Salaried__c WHERE Id = : salid];
            if (!CommonUtility.isEmpty(salLst)) {
                salariedObject = salLst[0];
            }
        }

        if (salariedObject != null) {
            if (salariedObject.Loan_Application__c != null) {
                //check if any SOL policy is refered or rejected
                List < SOL_Policy__c > solpolicyLst = [SELECT id, Loan_Application__c, Policy_Status__c FROM SOL_Policy__c WHERE Loan_Application__c = : salariedObject.Loan_Application__c and(Policy_Status__c LIKE '%reject%'
                    or Policy_Status__c LIKE '%refer%')];
                System.debug('checkSOLPolicyForRejectionRefer::solpolicyLst--->' + solpolicyLst);
                if (solpolicyLst.size() > 0) {
                    resDTO.status = 'FAILED';
                    Boolean isRejected = false;
                    for (SOL_Policy__c solpolicy: solPolicyLst) {
                        if (!CommonUtility.isEmpty(solpolicy.Policy_Status__c) && solpolicy.Policy_Status__c.containsIgnoreCase('reject')) {
                            isRejected = true;
                        }
                    }
                    if (isRejected) {
                        System.debug('checkSOLPolicyForRejectionRefer::--->Rejected');
                        resDTO.message = 'Auto Rejected';
                        resDTO.url = '/' + urlKey + '/digitalGridRejectPage';
                        return resDTO;
                    } else {
                        System.debug('invokeDynamicSave::--->Refer');
                        resDTO.message = 'Refer';
                        resDTO.url = '/' + urlKey + '/SOLReferPage';
                        return resDTO;
                    }
                }
            }
        } else {
            System.debug('invokeDynamicSave::--->Invalid SalId');
            resDTO.status = 'FAILED';
            resDTO.message = 'Invalid Reference Id';
        }
        return resDTO;
    }

    public static Double PMT(Double rate, Integer nper, Double pv) {
        if (rate != 0 && rate != null && nper != 0 && nper != null && pv != 0 && pv != null)
            return math.ceil((pv * rate) / (1 - Math.pow(1 + rate, -nper)));
        else
            return 0;
    }

     //Google URL Shortener start
    public static string googleShortenUrl(string longUrl)
    {
        string smsurl;
        
        try{
            generateBitly.WS_GenericBitlySoap genBitly = new generateBitly.WS_GenericBitlySoap();
            if(!Test.isRunningTest())
                smsurl = genBitly.generateBitly(5,6,'',longUrl,'','','','','','','','','','','','','','','','','','','','','','','','','','','','');
            else
                smsurl = 'https:etgsegs.dsgsdegsdgds';
            return smsurl;
        }
        catch(Exception e){
            System.debug('Class:GoogleUrlShortener;' +'Method:shortenUrl;' +'Message:'+e.getMessage());
            return 'ERROR'; 
        }
       /* Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        String body='';
        String api_key = Util.generateRandomKey();      // GoogleAPIRandomKey AdHoc
        
        httpReq.setMethod('POST');
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setEndpoint('https://www.googleapis.com/urlshortener/v1/url?key='+api_key);         //.GoogleAPIRandomKey AdHoc
        
        body = '{\"longUrl\": \"' + longUrl + '\"}';
        
        httpReq.setHeader('Content-Length', String.valueOf(body.length()));
        httpReq.setBody(body);
        
        try{
            Map<String,Object> resMap;
            if(!Test.isRunningTest()){
                httpRes = http.send(httpReq);
                resMap = (Map<String,Object>) JSON.deserializeUntyped(httpRes.getBody());
                System.debug('response map'+resMap);
            }
            return resMap.containsKey('id')?(String) resMap.get('id'):'';
        }
        catch(Exception e){
            System.debug('Class:GoogleUrlShortener;' +'Method:shortenUrl;' +'Message:'+e.getMessage());
            return 'ERROR'; 
        }*/
    }
    //Google URL Shortener end
  
  /*
     * Upsert SObject 
     */
    public static Map < String, Object > upsertGenericSObject(Map < String, Object > objFieldMap) {
        Map < String, Object > resMap = new Map < String, Object > ();
        List < SObject > SObjListInsert = new List < SObject > ();
        List < SObject > SObjListUpdate = new List < SObject > ();

        for (String ObjApiname: objFieldMap.KeySet()) {
            if (!CommonUtility.isEmpty(ObjApiname)) {
                System.debug('ObjApiname===========' + ObjApiname);
                Map < String, Object > fieldMap = (Map < String, Object > ) objFieldMap.get(ObjApiname);
                SObject instanceSObject = Schema.getGlobalDescribe().get(ObjApiname).newSObject();
                Boolean IsDml = false;
                if (fieldMap.containsKey('is_dml') && (Boolean) fieldMap.get('is_dml'))
                    isDml = true;
                fieldMap.remove('is_dml');

                for (String fieldApiname: fieldMap.KeySet()) {
                    if (!CommonUtility.isEmpty(fieldMap.get(fieldApiname)) && fieldMap.get(fieldApiname) != '') {

                        //if (fieldApiname != 'IsDml') {
                        Schema.DisplayType displayType = Schema.getGlobalDescribe().get(ObjApiname).getDescribe().fields.getMap().get(fieldApiname).getDescribe().getType();
                        system.debug('invokeDynamicSave::fieldApiname--->' + fieldApiname + ' displayType--->' + displayType + ' value--->' + fieldMap.get(fieldApiname));
                        if (Schema.DisplayType.Double == displayType) {
                            instanceSObject.put(fieldApiname, Double.valueOf(fieldMap.get(fieldApiname)));
                        } else if (Schema.DisplayType.Boolean == displayType) {
                            instanceSObject.put(fieldApiname, Boolean.valueOf(fieldMap.get(fieldApiname)));
                        } else if (Schema.DisplayType.Date == displayType) {
                            if(!CommonUtility.isEmpty(fieldMap.get(fieldApiname))){
                                String datestr = (String) fieldMap.get(fieldApiname);
                                String[] arr = datestr.split('/');
                                if(arr.size() == 3){
                                    Date dateObj = Date.newInstance(Integer.ValueOF(arr[2]),Integer.ValueOF(arr[0]),Integer.ValueOF(arr[1]));
                                    instanceSObject.put(fieldApiname, dateObj);
                                }
                            }
                        } else if (Schema.DisplayType.DateTime == displayType) {
                            instanceSObject.put(fieldApiname, DateTime.valueOf((String) fieldMap.get(fieldApiname)));
                        } else if (Schema.DisplayType.Percent == displayType) {
                            instanceSObject.put(fieldApiname, Double.valueOf(fieldMap.get(fieldApiname)));
                        } else {
                            instanceSObject.put(fieldApiname, fieldMap.get(fieldApiname));
                        }
                        //}

                    }
                }
                system.debug('isDml-----' + isDml);
                if (isDml) {
                    if (CommonUtility.isEmpty(instanceSObject.id))
                        SObjListInsert.add(instanceSObject);
                    else
                        SObjListUpdate.add(instanceSObject);
                }

                resMap.put(ObjApiname, instanceSObject);
            }
        }


        system.debug('SObjListInsert-----' + SObjListInsert);
        system.debug('SObjListUpdate-----' + SObjListUpdate);
        if (!CommonUtility.isEmpty(SObjListInsert))
            insert SObjListInsert;
        if (!CommonUtility.isEmpty(SObjListUpdate))
            insert SObjListUpdate;
        // system.debug('SObjList--------'+SObjList[0]);
        system.debug('resMap common-----' + resMap);
        return resMap;
    }
    //Google URL Shortener end
    
 //Whitelisting RM
 public static void callWhitelistingOnline(opportunity opp) {
  system.debug(LoggingLevel.INFO, 'inside callWhitelistingOnline');
  if (opp != null) {
   system.debug('inside callWhitelistingOnline Opp' + opp.Account.Mobile__c);
   system.debug('custtype=' + opp.Customer_Type__c + '=PAN=' + opp.Account.PANNumber__c + '=mobile=' + opp.Account.Mobile__c + '=email=' + opp.Account.Email_Id__c + '=DOB=' + opp.Account.Date_of_Birth__c + '=prod=' + opp.Product__c + 'Current Email Id' + opp.Account.Current_Email_Id__c);
   if (opp.Customer_Type__c != null && opp.Customer_Type__c.equalsIgnoreCase('Individual')) {
    //CommonUtility.sendCustInfoMail(opp.Account.PANNumber__c, string.valueOf(opp.Account.Mobile__c), string.valueOf(opp.Account.Email_Id__c), opp.Account.Date_of_Birth__c, opp.Product__c, opp.Customer_Type__c, 'PO');
    CommonUtility.sendCustInfoMail(opp.Account.PANNumber__c, string.valueOf(opp.Account.Mobile__c), string.valueOf(opp.Account.Current_Email_Id__c), opp.Account.Date_of_Birth__c, opp.Product__c, opp.Customer_Type__c, 'PO');
   } else if (opp.Customer_Type__c != null && (opp.Customer_Type__c.equalsIgnoreCase('Corporate') || opp.Customer_Type__c.equalsIgnoreCase('Entity'))) {
    //CommonUtility.sendCustInfoMail(opp.Account.PANNumber__c, string.valueOf(opp.Account.Mobile__c), string.valueOf(opp.Account.Email_Id__c), opp.Account.Date_of_Birth__c, opp.Product__c, opp.Customer_Type__c, 'PO');
    CommonUtility.sendCustInfoMail(opp.Account.PANNumber__c, string.valueOf(opp.Account.Mobile__c), string.valueOf(opp.Account.Current_Email_Id__c), opp.Account.Date_of_Birth__c, opp.Product__c, opp.Customer_Type__c, 'PO');
   }
  }
 }

 public static boolean sendCustInfoMail(String PAN, String Mobile, String Email, Date DOB, String Product, String custType, String identifier) {
  transient Map < String, List < String >> processMap = new Map < String, List < String >> ();
  transient Set < String > whitelistingProcessList = new Set < String > ();
  transient Set < String > whitelistingProductList = new Set < String > ();
  String currentProfileName;
  transient List < profile > profileList = new List < profile > ();
  transient Set < String > definedProfileList = new Set < String > ();
     //Added By Rajendra For new HBLS Product 
  transient string ProductForFlowLabel = Label.New_Products_for_Flow;
  transient boolean isNewProductFlowEnabled = false;
  if((Product != null && Product != null && ProductForFlowLabel != null && ProductForFlowLabel != '' && ProductForFlowLabel.contains(Product)))
        isNewProductFlowEnabled = true;  
  if (LaonApplicationCreation__c.getValues('Whitelisting RM') != null) {
   String products = LaonApplicationCreation__c.getValues('Whitelisting RM').Products__c;
   if (products != null) {
    system.debug('***products***' + products);
    system.debug('***Mobile***' + Mobile);
    String[] arr = products.split(';');
    for (String str: arr) {
     whitelistingProductList.add(str.toUppercase());
    }
   }

   String processes = LaonApplicationCreation__c.getValues('Whitelisting RM').Current_product__c;
   if (processes != null) {
    //system.debug('***processes***' + processes);
    String[] arr = processes.split(';');
    for (String str: arr) {
     whitelistingProcessList.add(str);
    }
   }
   System.debug('whitelistingProcessList=' + whitelistingProcessList);

   String profiles = LaonApplicationCreation__c.getValues('Whitelisting RM').Sales_Level_1__c;
   if (profiles != null) {
    //system.debug('***profiles***' + profiles);
    String[] arr = profiles.split(';');
    //System.debug('***arr***' + arr);
    for (String str: arr) {
     String[] processKey = str.split('-');
     processMap.put(processKey[0], processKey[1].split(','));
    }
    System.debug('***processMap***' + processMap);
   }
  }

  if (whitelistingProductList.contains(Product)) {
   system.debug('MobilePPPPPPPPPPPPPPPPPPPPPPPPPP' + Mobile);
   CUSTOMER_INFO__c customerInfo = checkCustomer(PAN, Mobile, Email, DOB, identifier);
   if (customerInfo != null) {

    id id1 = userinfo.getProfileId();

    currentProfileName = [select id, name from Profile where id = : id1].name;
    System.debug('currentProfileName=' + currentProfileName);

    //processType = customerInfo.Flow__c;
    System.debug('customerInfo.Flow__c=' + customerInfo.Flow__c);
    if (customerInfo.Flow__c != null && whitelistingProcessList.contains(customerInfo.Flow__c)) {
     if (processMap.containsKey(customerInfo.Flow__c)) {
      definedProfileList.clear();
      for (String str: processMap.get(customerInfo.Flow__c)) {
       definedProfileList.add(str);
      }
      System.debug('definedProfileList=' + definedProfileList);
      if (!definedProfileList.contains(currentProfileName)) {
       //Send Email to Product head
       System.debug('customerInfo.Relationship_Manager_Email__c=' + customerInfo.Relationship_Manager_Email__c);
       if (customerInfo.Relationship_Manager_Email__c != null && isNewProductFlowEnabled == false) {
        sendEmailToRM(customerInfo, identifier);

        System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        System.debug('2.Number of rows queried in this apex code so far: ' + Limits.getDmlRows());
        System.debug('3. Number of script statements used so far : ' + Limits.getDmlStatements());

        return true;
       }
      }
     }
    }
   }
  }

  System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
  System.debug('2.Number of rows queried in this apex code so far: ' + Limits.getDmlRows());
  System.debug('3. Number of script statements used so far : ' + Limits.getDmlStatements());

  return false;
 }

 public static CUSTOMER_INFO__c checkCustomer(String PAN, String Mobile, String Email, Date DOB, String identifier) {
  List < CUSTOMER_INFO__c > customerList = new List < CUSTOMER_INFO__c > ();
  system.debug('Mobile-------------------------' + Mobile);
  system.debug('Email-------------------------' + Email);
  try {
   if (PAN != null || PAN != '') {
    customerList = [Select id, PAN__c, Mobile__c, DOB__c, Email__c, Flow__C, Relationship_Manager_Email__c From CUSTOMER_INFO__c where PAN__c = : PAN LIMIT 1];

    System.debug(customerList.size() + '=customerList.size()');

    if (customerList.size() > 0) {
     return customerList[0];
    }
   }
   if (customerList.size() == 0 && !identifier.equalsIgnoreCase('Corporate') && !identifier.equalsIgnoreCase('Entity')) {
    //String.isNotEmpty(Mobile)
    if ((Mobile != null || Mobile != '') && (Email != null || Email != '') && DOB != null) {
     customerList = [Select id, PAN__c, Mobile__c, DOB__c, Email__c, Flow__C, Relationship_Manager_Email__c From CUSTOMER_INFO__c
      where(Mobile__c = : Mobile AND Email__c = : Email) OR(Email__c = : Email AND DOB__c = : DOB) OR(Mobile__c = : Mobile AND DOB__c = : DOB) LIMIT 1
     ];

     String SOQLuery = 'SELECT id, PAN__c, Mobile__c, DOB__c, Email__c, Flow__C, Relationship_Manager_Email__c FROM CUSTOMER_INFO__c WHERE ';
     SOQLuery = SOQLuery + '((Mobile__c = \'' + Mobile + '\' AND Email__c = ' + Email + ' ) OR (Email__c = ' + Email + ' AND DOB__c = ' + DOB + ' ) OR (Mobile__c = \'' + Mobile + '\' AND DOB__c = ' + DOB + ' )) LIMIT 1';
     system.debug('SOQLuery=>=>=>=>=>=>=>' + SOQLuery);

    }
    System.debug(customerList.size() + '=customerList.size()');

    if (customerList.size() > 0) {
     return customerList[0];
    }
   }
  } catch (Exception e) {
   System.debug(e.getMessage());
  }

  return null;
 }

 public static void sendEmailToRM(CUSTOMER_INFO__c customerInfo, String identifier) {
  List < String > toAddlist = new List < String > ();
  try {
   Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

   toAddlist.add(customerInfo.Relationship_Manager_Email__c);
   //toAddlist.add('amitkumar_kohakade@persistent.co.in');
   System.debug('toAddlist=' + toAddlist);
   email.setToAddresses(toAddlist);

   List < EmailTemplate > Templist = new List < EmailTemplate > ();

   if (identifier == 'DSS') {
    Templist = [select id from EmailTemplate where Name = 'RM White listing Barred'];
   } else {
    Templist = [select id from EmailTemplate where Name = 'RM White listing'];
   }

   System.debug('Templist.size()=' + Templist.size());

   if (Templist.size() > 0) {
    Id userId = userinfo.getUserId();

    email.setTemplateId(Templist[0].id);
    System.debug('userId=' + userId + '=Templist[0].id=' + Templist[0].id + '=customerInfo.id=' + customerInfo.id);
    email.setTargetObjectId(userId);
    //email.setTargetObjectId('005900000018D73');

    email.setWhatId(customerInfo.id);

    email.setSaveAsActivity(false);
    email.setTreatTargetObjectAsRecipient(false);
    //email.setOrgWideEmailAddressId('0D290000000Gmwt');
    email.setReplyTo('noreply@bajajfinserv.in');

    Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
     email
    });
    System.debug('Email is=' + email);
   }

  } catch (Exception e) {
   System.debug(e.getMessage());
  }

 }
 //Bug 15854 - December_2017_RTR Calculator Added new parameter By Rajesh START
  //BOL revamp start
 public static Map < String, String > BREMCPCheckForBOL(Salaried__c salariedObj, CIBIL__c cibilRec,Cibil_Extension1__c cibilExtn1, Integer flow) {
  BRECalloutCls breObj = new BRECalloutCls();
  //Template__c tmp=[SELECT Flow__c FROM Template__c WHERE Id=:salariedObj.Template__c LIMIT 1];
        /* Start added by Mahima for Bug-17588
Added By Gulshan for count of No. of Live or Closed (PL or BL or HL or LAP or AL or CC or OTHERS) from selecting CIBIL_Extension__r.Total_No_of_Specific_Trades__c
  */
        /* CIBIL_Extension__r.Number_of_live_AL__c,CIBIL_Extension__r.Number_of_live_HL__c,CIBIL_Extension__r.Number_of_live_LAP__c,Number_DPDs_in_last_24__c,Number_DPD_in_CC_gtr_24_month__c fields added in query by sneha for bug-20187*/
        List<CIBIL__c> lstcibil = [select Id,Cibil_Temp__c,Cibil_Temp__r.DPD_cluster_Segment__c, CIBIL_Extension__r.Total_No_of_Specific_Trades__c, CIBIL_Extension__r.Number_of_live_AL__c,CIBIL_Extension__r.Number_of_live_HL__c,CIBIL_Extension__r.Number_of_live_LAP__c,CIBIL_Extension__r.Number_DPDs_in_last_24__c,CIBIL_Extension__r.Number_DPD_in_CC_gtr_24_month__c from CIBIL__c where Id=:cibilRec.Id];
    CIBIL__c cibil= new CIBIL__c ();
    if(lstcibil != null && lstcibil .size()>0)   
    cibil = lstcibil [0];
        /*End added by Mahima for Bug-17588*/
  Map < String, String > mapOfPolicyParameters = new Map < String, String > ();
  Map < String, String > mapOfPolicyResult = new Map < String, String > ();
  mapOfPolicyParameters.put('dolVersion', String.valueOf(flow));
  mapOfPolicyParameters.put('specialisation', salariedObj.Specialisation__c);
  mapOfPolicyParameters.put('product', salariedObj.Product_Type__c);
  if (!salariedObj.Total_Employment_vintage_Year__c.contains('Select'))
   mapOfPolicyParameters.put('total_employment_vintage', salariedObj.Total_Employment_vintage_Year__c);
  if (!CommonUtility.isEmpty(salariedObj.Date_Of_Birth__c)) {
   DateTime dobT = datetime.newInstance(salariedObj.Date_Of_Birth__c.year(), salariedObj.Date_Of_Birth__c.month(), salariedObj.Date_Of_Birth__c.day());
   mapOfPolicyParameters.put('date_of_birth', dobT.format('YYYY-MM-dd'));
   //mapOfPolicyParameters.put('date_of_birth', '1986-02-02');
  }
  if (flow == 1) {
   system.debug('Entered flow 1');
   //mapOfPolicyParameters.put('product', salariedObj.Product_Type__c);
   mapOfPolicyParameters.put('process_type', salariedObj.Process_type__c);
   mapOfPolicyParameters.put('practiceType', salariedObj.Practice_Type__c);
   mapOfPolicyParameters.put('customer_type', 'individual');
   mapOfPolicyParameters.put('type_of_degree', salariedObj.Type_of_Degree__c);
   //BOL Revamp Leena start
    if(cibilRec.CIBIL_Score__c=='000-1')
     mapOfPolicyParameters.put('cibil_score','0');
     else
     mapOfPolicyParameters.put('cibil_score', cibilRec.CIBIL_Score__c);
   //BOL Revamp Leena end
   mapOfPolicyParameters.put('branch_name', salariedObj.Branch_Name__c);
   mapOfPolicyParameters.put('residence_type', salariedObj.Residence_Type__c);
   //mapOfPolicyParameters.put('dolVersion', String.valueOf(tmp.Flow__c));
    if (salariedObj.Template__r.Flow__c==1 && salariedObj.Product_Type__c== 'DOL') {
    //mapOfPolicyParameters.put('type_of_degree', salariedObj.Specialisation__c);
    if (!commonUtility.isEmpty(salariedObj.Clinic_Hospital_type__c) && !salariedObj.Clinic_Hospital_type__c.contains('Select'))
     mapOfPolicyParameters.put('Clinic_Hospital_type', salariedObj.Clinic_Hospital_type__c);
   }
   //mobility changes 
   if (salariedObj.utm_source1__c == 'PRO' || salariedObj.utm_source1__c == 'HPRO' || (salariedObj.utm_source1__c == 'proMobile' && salariedObj.Specialisation__c == 'CA' && salariedObj.Practice_Type__c == 'SEP')) {
    mapOfPolicyParameters.put('profession_type', 'CA');
    mapOfPolicyParameters.put('program_type', salariedObj.Practice_Type__c);
    mapOfPolicyParameters.put('Full_Time_COP', salariedObj.Full_Time_COP__c);
    mapOfPolicyParameters.put('Is_COP_Active', salariedObj.Is_COP_Active__c);
   }
   // BUG ID 17898 start    
   boolean isBOLProductLineProduct = false;
   transient string BOLProductLineProducts = Label.BOL_Line_Products;
   if(BOLProductLineProducts != null && BOLProductLineProducts != '' )
   {
        set < string > setBOLProdName = new set < string > ();
        setBOLProdName.addAll(BOLProductLineProducts.split(';'));
        if (setBOLProdName != null && setBOLProdName.size() > 0 && salariedObj != null && salariedObj.Product_Type__c != null) 
        {
            if(setBOLProdName.contains(salariedObj.Product_Type__c.toUpperCase()))
                 isBOLProductLineProduct = true; 
        }
    }
    // BUG ID 17898 End
   //BOL Revamp Leena start
   if (isBOLProductLineProduct) {
    system.debug('inside BOL Turnover in Current Year===>' + salariedObj.Turnover_in_Current_Year__c);
    mapOfPolicyParameters.put('cy_sales_turnover', salariedObj.Turnover_in_Current_Year__c == null ? '0' : String.valueOf(salariedObj.Turnover_in_Current_Year__c));
    mapOfPolicyParameters.put('years_in_business_job', salariedObj.Total_Employment_vintage_Year__c == null ? '0' : String.valueOf(salariedObj.Total_Employment_vintage_Year__c));
    
     //Bug 15854 - December_2017_RTR Calculator  By Rajesh START
    mapOfPolicyParameters.put('number_of_business_loans', CommonUtility.isEmpty(cibilExtn1.No_of_Live_BL__c) ? '0' : String.valueOf(cibilExtn1.No_of_Live_BL__c));
    mapOfPolicyParameters.put('outstanding_of_personal_loans', CommonUtility.isEmpty(cibilExtn1.No_of_Live_PL__c) ? '0' : String.valueOf(cibilExtn1.No_of_Live_PL__c));
    mapOfPolicyParameters.put('gross_turnover', CommonUtility.isEmpty(salariedObj.Turnover__c) ? '0' : salariedObj.Turnover__c);
    //Bug 15854 - December_2017_RTR Calculator  By Rajesh END
  //Added By Gulshan for count of No. of Live or Closed (PL or BL or HL or LAP or AL or CC or OTHERS) -- Bug 20245
      mapOfPolicyParameters.put('total_no_of_specific_trades', CommonUtility.isEmpty(cibil.CIBIL_Extension__r.Total_No_of_Specific_Trades__c) ? '0' : String.valueOf(cibil.CIBIL_Extension__r.Total_No_of_Specific_Trades__c));
                //Ended By Gulshan for count of No. of Live or Closed (PL or BL or HL or LAP or AL or CC or OTHERS)
                
                /* Start added parameter by Mahima for Bug-17588*/
                system.debug('salariedObj.Pan__c'+ salariedObj.Pan__c);
                mapOfPolicyParameters.put('pan', salariedObj.Pan__c == null ? '' : String.valueOf(salariedObj.Pan__c));
                /*if (!CommonUtility.isEmpty(salariedObj.Date_Of_Birth__c)) {
DateTime dobT = datetime.newInstance(salariedObj.Date_Of_Birth__c.year(), salariedObj.Date_Of_Birth__c.month(), salariedObj.Date_Of_Birth__c.day());
mapOfPolicyParameters.put('date_of_birth', dobT.format('YYYY-MM-dd'));
}*/
                mapOfPolicyParameters.put('nature_of_business', salariedObj.Nature_of_Business__c == null ? '' : salariedObj.Nature_of_Business__c);
                mapOfPolicyParameters.put('dpdCluserSegment', CommonUtility.isEmpty(cibil.Cibil_Temp__r.DPD_cluster_Segment__c) ? '' : cibil.Cibil_Temp__r.DPD_cluster_Segment__c);  
                mapOfPolicyParameters.put('number_of_personal_loans',  
                                          (CommonUtility.isEmpty(cibilExtn1.No_of_Live_PL__c) || cibilExtn1.No_of_Live_PL__c == 0)  ? '' : String.valueOf(cibilExtn1.No_of_Live_PL__c));
                
                
      mapOfPolicyParameters.put('bajajPLloanMOB', CommonUtility.isEmpty(cibilExtn1.Bajaj_PL_loan_MOB__c) ? '' : String.valueOf(cibilExtn1.Bajaj_PL_loan_MOB__c)); 
                mapOfPolicyParameters.put('noOf30DPD_GL_And_CC',  CommonUtility.isEmpty(cibilExtn1.No_30_DPD_12_Exld_CC_GL__c) ? '' : String.valueOf(cibilExtn1.No_30_DPD_12_Exld_CC_GL__c));
                
    mapOfPolicyParameters.put('process_type', 'BOLR');
/*End  parameter by Mahima for Bug-17588*/
                
                /* parameter added by sneha for bug-20187 Start*/
                mapOfPolicyParameters.put('number_of_live_AL', CommonUtility.isEmpty(cibil.CIBIL_Extension__r.Number_of_live_AL__c) ? '' : String.valueOf(cibil.CIBIL_Extension__r.Number_of_live_AL__c));  
                mapOfPolicyParameters.put('number_of_live_HL',  CommonUtility.isEmpty(cibil.CIBIL_Extension__r.Number_of_live_HL__c) ? '' : String.valueOf(cibil.CIBIL_Extension__r.Number_of_live_HL__c));
                mapOfPolicyParameters.put('number_of_live_LAP',  CommonUtility.isEmpty(cibil.CIBIL_Extension__r.Number_of_live_LAP__c) ? '' : String.valueOf(cibil.CIBIL_Extension__r.Number_of_live_LAP__c));
                mapOfPolicyParameters.put('dpd_in_last_24_month',  CommonUtility.isEmpty(cibil.CIBIL_Extension__r.Number_DPDs_in_last_24__c) ? '' : String.valueOf(cibil.CIBIL_Extension__r.Number_DPDs_in_last_24__c));
                mapOfPolicyParameters.put('overdueAmountGT5000',  CommonUtility.isEmpty(cibil.CIBIL_Extension__r.Number_DPD_in_CC_gtr_24_month__c) ? '' : String.valueOf(cibil.CIBIL_Extension__r.Number_DPD_in_CC_gtr_24_month__c));
                system.debug('number_of_live_AL-->'+cibil.CIBIL_Extension__r.Number_of_live_AL__c);
                system.debug('number_of_live_BL-->'+cibil.CIBIL_Extension__r.number_of_live_HL__c);
                system.debug('number_of_live_LAP-->'+cibil.CIBIL_Extension__r.Number_of_live_LAP__c);
                system.debug('dpd_in_last_24_month-->'+cibil.CIBIL_Extension__r.Number_DPDs_in_last_24__c);
                system.debug('overdueAmountGT5000-->'+cibil.CIBIL_Extension__r.Number_DPD_in_CC_gtr_24_month__c);
                /* parameter added by sneha for bug-20187 End*/
    system.debug('mapOfPolicyParameters====>' + mapOfPolicyParameters);
   }
   //BOL Revamp Leena end
  } else if (flow == 2) {
   mapOfPolicyParameters.put('practiceType', 'SEP');


   if (salariedObj.Product_Type__c.toUppercase() == 'PRO' || salariedObj.Product_Type__c.toUppercase() == 'HPRO') {
    mapOfPolicyParameters.put('process_type', 'PRE APPROVED');
    //mapOfPolicyParameters.put('negativeDatabase', 'N');
    mapOfPolicyParameters.put('profession_type', 'CA');
    mapOfPolicyParameters.put('product', 'PRO');

     if (salariedObj.Is_COP_Active__c != NULL) {
     mapOfPolicyParameters.put('Is_COP_Active', salariedObj.Is_COP_Active__c);
    }
  
    if (salariedObj.COP_Year__c != NULL) {
     //Calculating Difference between COP year n current year 
     Integer currentYear = Integer.valueOf(System.Today().year());
     Integer copYear = Integer.valueOf(salariedObj.COP_Year__c);
     Integer diffCount = currentYear - copYear;
     mapOfPolicyParameters.put('total_employment_vintage', String.valueOf(diffCount));
    }
    //Bug Id :11377, Enhancement:DOL_Pro revamp by PG on 15th March 2017 .end.

   }
  else if (salariedObj.Template__r.Flow__c==2 && salariedObj.Product_Type__c.toUppercase() == 'DOL') {

    if (salariedObj.State__c != NULL) {
     mapOfPolicyParameters.put('location', salariedObj.State__c);
   //mapOfPolicyParameters.put('residence_City',salariedObj.City__c);
   
    }
    

   }
   


  }
  system.debug('mapOfPolicyParameters -----'+mapOfPolicyParameters);   
  mapOfPolicyResult = breObj.callBREMCPCheck(mapOfPolicyParameters);
  return mapOfPolicyResult;
 }

//BOL revamp ends


public static Map < String, String > BREMCPCheckForDOL(Salaried__c salariedObj, CIBIL__c cibilRec, Integer flow) {

  BRECalloutCls breObj = new BRECalloutCls();
  //Template__c tmp=[SELECT Flow__c FROM Template__c WHERE Id=:salariedObj.Template__c LIMIT 1];
  Map < String, String > mapOfPolicyParameters = new Map < String, String > ();
  Map < String, String > mapOfPolicyResult = new Map < String, String > ();
  
   mapOfPolicyParameters.put('dolVersion', String.valueOf(flow));
  mapOfPolicyParameters.put('specialisation', salariedObj.Specialisation__c);
   mapOfPolicyParameters.put('product', salariedObj.Product_Type__c);
     if(!salariedObj.Total_Employment_vintage_Year__c.contains('Select'))
          mapOfPolicyParameters.put('total_employment_vintage', salariedObj.Total_Employment_vintage_Year__c);
      if (!CommonUtility.isEmpty(salariedObj.Date_Of_Birth__c)) {
           DateTime dobT = datetime.newInstance(salariedObj.Date_Of_Birth__c.year(), salariedObj.Date_Of_Birth__c.month(), salariedObj.Date_Of_Birth__c.day());
           mapOfPolicyParameters.put('date_of_birth', dobT.format('YYYY-MM-dd'));
           //mapOfPolicyParameters.put('date_of_birth', '1986-02-02');
      }
      
      if(flow == 1){
      mapOfPolicyParameters.put('product', salariedObj.Product_Type__c);
      mapOfPolicyParameters.put('process_type', salariedObj.Process_type__c);
      mapOfPolicyParameters.put('practiceType', salariedObj.Practice_Type__c);
      mapOfPolicyParameters.put('customer_type', 'individual');
      mapOfPolicyParameters.put('type_of_degree', salariedObj.Type_of_Degree__c);
      if(cibilRec != null)
      mapOfPolicyParameters.put('cibil_score', cibilRec.CIBIL_Score__c);
      mapOfPolicyParameters.put('branch_name', salariedObj.Branch_name_DOL__c);
      mapOfPolicyParameters.put('residence_type', salariedObj.Residence_Type__c);
     
      //mapOfPolicyParameters.put('dolVersion', String.valueOf(tmp.Flow__c));
    
      
    
      if (salariedObj.Template__r.Flow__c==1 && salariedObj.Product_Type__c== 'DOL') {
       //mapOfPolicyParameters.put('type_of_degree', salariedObj.Specialisation__c);
       if (!salariedObj.Clinic_Hospital_type__c.contains('Select'))
        mapOfPolicyParameters.put('Clinic_Hospital_type', salariedObj.Clinic_Hospital_type__c);
      }
    //mobility changes 
      if (salariedObj.utm_source1__c == 'PRO' || salariedObj.utm_source1__c == 'HPRO' || (salariedObj.utm_source1__c == 'proMobile' && salariedObj.Specialisation__c == 'CA' && salariedObj.Practice_Type__c == 'SEP')) {
       mapOfPolicyParameters.put('profession_type', 'CA');
       mapOfPolicyParameters.put('program_type', salariedObj.Practice_Type__c);
       mapOfPolicyParameters.put('Full_Time_COP', salariedObj.Full_Time_COP__c);
       mapOfPolicyParameters.put('Is_COP_Active', salariedObj.Is_COP_Active__c);
      }
      
       // BUG ID 17898 start    
       boolean isBOLProductLineProduct = false;
       transient string BOLProductLineProducts = Label.BOL_Line_Products;
       if(BOLProductLineProducts != null && BOLProductLineProducts != '' )
       {
            set < string > setBOLProdName = new set < string > ();
            setBOLProdName.addAll(BOLProductLineProducts.split(';'));           
            if (setBOLProdName != null && setBOLProdName.size() > 0 && salariedObj != null && salariedObj.Product_Type__c != null) 
            {
                if(setBOLProdName.contains(salariedObj.Product_Type__c.toUpperCase()))
                     isBOLProductLineProduct = true; 
            }
        }
        // BUG ID 17898 End
         //BOL Revamp Leena start
   if (isBOLProductLineProduct) {
    system.debug('inside BOL Turnover in Current Year===>' + salariedObj.Turnover_in_Current_Year__c);
    mapOfPolicyParameters.put('cy_sales_turnover', salariedObj.Turnover_in_Current_Year__c == null ? '0' : String.valueOf(salariedObj.Turnover_in_Current_Year__c));
    mapOfPolicyParameters.put('years_in_business_job', salariedObj.Total_Employment_vintage_Year__c == null ? '0' : String.valueOf(salariedObj.Total_Employment_vintage_Year__c));
    system.debug('mapOfPolicyParameters====>' + mapOfPolicyParameters);
   }
   //BOL Revamp Leena end
  }
  else if(flow == 2){
      mapOfPolicyParameters.put('practiceType', 'SEP');

system.debug('salariedObj--'+salariedObj);
system.debug('salariedObj.Template__r.Flow__c==2--'+salariedObj.Template__r.Flow__c);
system.debug('salariedObj.Product_Type__c--'+salariedObj.Product_Type__c); 
   if (salariedObj.Product_Type__c.toUppercase() == 'PRO' || salariedObj.Product_Type__c.toUppercase() == 'HPRO') {
    mapOfPolicyParameters.put('process_type', 'PRE APPROVED');
    //mapOfPolicyParameters.put('negativeDatabase', 'N');
    mapOfPolicyParameters.put('profession_type', 'CA');
    mapOfPolicyParameters.put('product', 'PRO');

    //Bug Id :11377, Enhancement:DOL_PRO revamp by PG on 15th March 2017 .start.
    //Added if conditions to eliminate NULL pointer exceptions if salariedObj.Is_COP_Active__c==NULL and salariedObj.COP_Year__c==NULL
    
    if(salariedObj.DOL_City__c!=NULL ){
        mapOfPolicyParameters.put('residence_City',salariedObj.DOL_City__c);
    }   
       
    if (salariedObj.Is_COP_Active__c != NULL) {
     mapOfPolicyParameters.put('Is_COP_Active', salariedObj.Is_COP_Active__c);
    }

    if (salariedObj.COP_Year__c != NULL) {
    //Calculating Difference between COP year n current year 
    Integer currentYear = Integer.valueOf(System.Today().year());
    Integer copYear = Integer.valueOf(salariedObj.COP_Year__c);
    Integer diffCount = currentYear - copYear;
    mapOfPolicyParameters.put('total_employment_vintage', String.valueOf(diffCount));
    }
    //Bug Id :11377, Enhancement:DOL_Pro revamp by PG on 15th March 2017 .end.

  }
   //Bug Id :11377, Enhancement:DOL_Pro revamp by PG on 15th March 2017 . start.
   //Added State as MCP parameter
     
   else if (salariedObj.Template__r.Flow__c==2 && salariedObj.Product_Type__c.toUppercase() == 'DOL') {

    if (salariedObj.State__c != NULL) {
        mapOfPolicyParameters.put('location', salariedObj.State__c);
  }
   
    if(salariedObj.DOL_City__c!=NULL ){
        mapOfPolicyParameters.put('residence_City',salariedObj.DOL_City__c);
    } 

   }
   //Bug Id :11377, Enhancement:DOL_Pro revamp by PG on 15th March 2017 end.



  }
   //mobility changes S
        if (salariedObj.utm_source1__c == 'proMobile') {
            system.debug('salariedObj.Gender__c==>' + salariedObj.Gender__c);
            mapOfPolicyParameters.put('gender', salariedObj.Gender__c);
            mapOfPolicyParameters.put('product', 'DOL');
            mapOfPolicyParameters.put('dolVersion', '1');
            mapOfPolicyParameters.put('specialisation', salariedObj.Specialisation__c);
            mapOfPolicyParameters.put('total_employment_vintage', salariedObj.Total_Employment_vintage_Year__c);
               system.debug('Outside CA SEP block Special==>'+salariedObj.Specialisation__c+'Practice Type==>'+salariedObj.Practice_Type__c);
            if(salariedObj.Specialisation__c == 'CA' && salariedObj.Practice_Type__c == 'SEP'){
            
                system.debug('Entered CA SEP block');
                mapOfPolicyParameters.put('product', 'PRO');
                mapOfPolicyParameters.put('process_type', 'PRE APPROVED');
                mapOfPolicyParameters.put('professionType', 'CA');
               // mapOfPolicyParameters.put('residence_type', 'OWNED');
                mapOfPolicyParameters.put('residence_type', salariedObj.Office_Factory_Plant_Ownership__c);
                mapOfPolicyParameters.put('Full_Time_COP', 'YES');
                mapOfPolicyParameters.put('Is_COP_Active', 'ACTIVE');
                
            }
        }
        //mobility changes E
  if(!Test.isRunningTest()){
    mapOfPolicyResult = breObj.callBREMCPCheck(mapOfPolicyParameters);
   }
   else{ 
            
       if( ( mapOfPolicyParameters.get('product')=='PRO' || mapOfPolicyParameters.get('product')=='HPRO' ) && mapOfPolicyParameters.get('dolVersion')=='2' ){
                mapOfPolicyResult.put('FinalResult','MCP FAIL');
                mapOfPolicyResult.put('MCPList','MINIMUM EXPERIENCE POLICY FAIL:::MCP FAIL');
                system.debug( 'mapOfPolicyResult---'+ mapOfPolicyResult);
       }
       else if ( mapOfPolicyParameters.get('product')=='DOL' && mapOfPolicyParameters.get('dolVersion')=='2' ){
            
               mapOfPolicyResult.put('FinalResult','MCP PASS');
               mapOfPolicyResult.put('MCPList','MINIMUM EXPERIENCE POLICY FAIL:::MCP FAIL');
               system.debug( 'mapOfPolicyResult---'+ mapOfPolicyResult);    
                
        }       
        
   }   
    
  return mapOfPolicyResult;
 }

  //code added by Leena-13487 Engineering Program start
public static Map<String,Set<String>> createSecuredNotSecuredSet(String product,String professionType,String EmploymentType){
    Map<String,set<String>>mapofSecuredNotSecured=new Map<String,set<String>>();
    Set<String>setOfSecured=new Set<String>();
    Set<String>setOfUnsecured=new Set<String>();
    String productforALUnsec,professionforALUnsec,employmentTypeforALUnsec,professionforALNotUnsecNotSec ;
    if(LaonApplicationCreation__c.getValues('CibileScoreRuleFireProducts')!=null){
        productforALUnsec = LaonApplicationCreation__c.getValues('CibileScoreRuleFireProducts').Products__c;
        professionforALUnsec = LaonApplicationCreation__c.getValues('CibileScoreRuleFireProducts').ProfessionalLoan__c;
        employmentTypeforALUnsec = LaonApplicationCreation__c.getValues('CibileScoreRuleFireProducts').Program_Types__c;
        professionforALNotUnsecNotSec = LaonApplicationCreation__c.getValues('CibileScoreRuleFireProducts').PO_Type__c;
    }
    if(productforALUnsec!=null && professionforALUnsec!=null && employmentTypeforALUnsec!=null && product!=null && professionType!=null && EmploymentType!=null &&  productforALUnsec.contains(product) && professionforALUnsec.contains(professionType) && employmentTypeforALUnsec.contains(EmploymentType)){
       system.debug('label selected is ===> Secured_Loans_PRO');
        for(string strsecPRO:Label.Secured_Loans_PRO.split(';')){
            setOfSecured.add(strsecPRO);
    }
        for(string strunsecPRO:Label.Unsecured_Loans_PRO.split(';')){
            setOfUnsecured.add(strunsecPRO);
        }
    }
    else if(professionforALNotUnsecNotSec!=null && professionType!=null && professionforALNotUnsecNotSec.contains(professionType)){
        system.debug('label selected is ===> Secured_Loans_Engineers');
        for(string strsecEng:Label.Secured_Loans_Engineers.split(';')){
            setOfSecured.add(strsecEng);
    }
        for(string strunsecEng:Label.Unsecured_Loans_Engineers.split(';')){
            setOfUnsecured.add(strunsecEng);
        }
    }
    else{
     system.debug('label selected is ===> Secured_Loans');
        for(string strsec:Label.Secured_Loans.split(';')){
            setOfSecured.add(strsec);
    }
        for(string strunsec:Label.Unsecured_Loans.split(';')){
            setOfUnsecured.add(strunsec);
        }
    }
    mapofSecuredNotSecured.put('SecuredSet',setOfSecured);
    mapofSecuredNotSecured.put('UnsecuredSet',setOfUnsecured);
    return mapofSecuredNotSecured;
}
 //code added by Leena-13487 Engineering Program end 

 public static Map < String, String > BREEligibilityCheckForDOL(Salaried__c salariedObj, CIBIL__c cibilRec, Cibil_Extension1__c cibilExt1Rec,Integer flow,String customer_segment) {
  String branchName = (!CommonUtility.isEmpty(salariedObj) && !CommonUtility.isEmpty(salariedObj.Branch__r) && !CommonUtility.isEmpty(salariedObj.Branch__r.Name))?salariedObj.Branch__r.Name:salariedObj.Branch_name_DOL__c;
   //BOL Revamp leena start
   
   
    // BUG ID 17898 start    
       boolean isBOLProductLineProduct = false;
       transient string BOLProductLineProducts = Label.BOL_Line_Products;
       if(BOLProductLineProducts != null && BOLProductLineProducts != '' )
       {
            set < string > setBOLProdName = new set < string > ();
            setBOLProdName.addAll(BOLProductLineProducts.split(';'));
            if (setBOLProdName != null && setBOLProdName.size() > 0 && salariedObj != null && salariedObj.Product_Type__c != null) 
            {
                if(setBOLProdName.contains(salariedObj.Product_Type__c.toUpperCase()))
                     isBOLProductLineProduct = true; 
            }
        }
    // BUG ID 17898 End
   
   
   
   
   // 18078 if (salariedObj.Product_Type__c  == 'BOL' 
  if (isBOLProductLineProduct)
   branchName = salariedObj.DOL_City__c;
  //BOL Revamp leena end
  BRECalloutCls breObj = new BRECalloutCls();
  Map < String, String > mapOfPolicyParameters = new Map < String, String > ();
  Map < String, String > mapOfPolicyResult = new Map < String, String > ();
  
  mapOfPolicyParameters.put('product', salariedObj.Product_Type__c);
     mapOfPolicyParameters.put('dolVersion', String.valueOf(flow));
     if (!CommonUtility.isEmpty(salariedObj.Date_Of_Birth__c)) {
       DateTime dobT = datetime.newInstance(salariedObj.Date_Of_Birth__c.year(), salariedObj.Date_Of_Birth__c.month(), salariedObj.Date_Of_Birth__c.day());
       mapOfPolicyParameters.put('date_of_birth', dobT.format('YYYY-MM-dd'));
       //mapOfPolicyParameters.put('date_of_birth', '1986-02-02');
      }
      mapOfPolicyParameters.put('customer_segment', 'Normal');
      if(!salariedObj.Total_Employment_vintage_Year__c.contains('Select'))
          mapOfPolicyParameters.put('total_employment_vintage', salariedObj.Total_Employment_vintage_Year__c);
      mapOfPolicyParameters.put('monthly_loan_obligations', String.valueOf(salariedObj.Total_Monthly_Obligations__c));
     
     
  if(flow == 1){
      Branch_Master__c branchMaster=[Select Doctors_Branch_Type__c,Professional_Branch_Type__c from Branch_Master__c WHERE Name =:branchName limit 1];
  System.debug('branch master pune-->'+branchMaster);
  mapOfPolicyParameters.put('process_type', salariedObj.Process_type__c);
  mapOfPolicyParameters.put('type_of_degree', salariedObj.Type_of_Degree__c);
  mapOfPolicyParameters.put('totalExposure', String.valueOf(cibilExt1Rec.Total_Exposure__c));
  mapOfPolicyParameters.put('CIBIL_Score', cibilRec.CIBIL_Score__c);
  mapOfPolicyParameters.put('practiceType', salariedObj.Practice_Type__c);
  mapOfPolicyParameters.put('branch_name', branchName);
  mapOfPolicyParameters.put('securedLoanAmount', String.valueOf(cibilExt1Rec.Max_Secured_Loan_Amount__c));
  mapOfPolicyParameters.put('unSecuredLoanAmount', String.valueOf(cibilExt1Rec.Max_unSecured_Loan_Amount__c));
  mapOfPolicyParameters.put('securedMob', String.valueOf(cibilExt1Rec.Max_Secured_MOB__c));
  mapOfPolicyParameters.put('unSecuredMob', String.valueOf(cibilExt1Rec.Max_Unsecured_MOB__c));
  mapOfPolicyParameters.put('branch_type', branchMaster.Professional_Branch_Type__c);
      //BOL Revamp Leena start
   if (isBOLProductLineProduct) {
    mapOfPolicyParameters.put('branch_name', salariedObj.DOL_City__c);
    mapOfPolicyParameters.put('maxAL', String.valueOf(cibilExt1Rec.MAX_AL_Loan__c));
    mapOfPolicyParameters.put('maxPL', String.valueOf(cibilExt1Rec.MAX_PL_Loan__c));
    mapOfPolicyParameters.put('maxBL', String.valueOf(cibilExt1Rec.MAX_BL_Loan__c));
    mapOfPolicyParameters.put('maxHL', String.valueOf(cibilExt1Rec.MAX_HL_Loan__c));
    mapOfPolicyParameters.put('maxLAP', String.valueOf(cibilExt1Rec.MAX_LAP_Loan__c));
   }
   //BOL Revamp Leena end
   if (salariedObj.Product_Type__c!= null && salariedObj.Template__r.Flow__c==1 && salariedObj.Product_Type__c.toUppercase() == 'DOL') {
         //mapOfPolicyParameters.put('branch_type', branchMaster.Doctors_Branch_Type__c);
        mapOfPolicyParameters.put('specialisation', salariedObj.Specialisation__c);
        if (!salariedObj.Clinic_Hospital_type__c.contains('Select'))
            mapOfPolicyParameters.put('Clinic_Hospital_type', salariedObj.Clinic_Hospital_type__c);
        mapOfPolicyParameters.put('requested_tenor', String.valueOf(salariedObj.Cust_Selected_Tenor__c));
        mapOfPolicyParameters.put('expPostGradSuperSpecialist', salariedObj.Join_dt_curr_emp_year__c);
         mapOfPolicyParameters.put('profession', 'DOCTOR');
  }

   if (salariedObj.Template__r.Flow__c==1 && ( salariedObj.Product_Type__c.toUppercase() == 'PRO' || salariedObj.Product_Type__c.toUppercase() == 'HPRO' )) {
   
   mapOfPolicyParameters.put('profession', 'CA');
   mapOfPolicyParameters.put('program_type', salariedObj.Practice_Type__c);
   
   
  }
  }
  else if(flow == 2){
      Branch_Master__c branchMaster=[Select Doctors_Branch_Type__c,Professional_Branch_Type__c from Branch_Master__c WHERE Name =:branchName.toUpperCase() limit 1];
     
      // mapOfPolicyParameters.put('doetype', 'DOE 1');
     
      mapOfPolicyParameters.put('branch_type', branchMaster.Professional_Branch_Type__c);
      if (salariedObj.Product_Type__c.toUppercase() == 'DOL') {
         
        mapOfPolicyParameters.put('specialisation', salariedObj.Specialisation__c);
       // mapOfPolicyParameters.put('requested_tenor', '60');
        mapOfPolicyParameters.put('profession', 'DOCTOR');
    }
      
    if (salariedObj.Product_Type__c.toUppercase() == 'PRO' || salariedObj.Product_Type__c.toUppercase() == 'HPRO') 
    {
                mapOfPolicyParameters.put('practiceType', 'SEP');
                mapOfPolicyParameters.put('profession', 'CA');
                mapOfPolicyParameters.put('process_type', 'PRE APPROVED');
                //mapOfPolicyParameters.put('negativeDatabase', 'N');
                mapOfPolicyParameters.put('profession_type', 'CA');
                mapOfPolicyParameters.put('product', 'PRO');
                //Calculating Difference between COP year n current year 
                Integer currentYear = Integer.valueOf(System.Today().year());
                Integer copYear = Integer.valueOf(salariedObj.COP_Year__c);
                Integer diffCount = currentYear - copYear;
                mapOfPolicyParameters.put('total_employment_vintage', String.valueOf(diffCount));
  }
      
     mapOfPolicyParameters.put('branch_name', branchName);
    //mapOfPolicyParameters.put('CIBIL_Score', '783');
    mapOfPolicyParameters.put('practiceType', 'SEP');
     mapOfPolicyParameters.put('process_type', 'Pre Approved');
     mapOfPolicyParameters.put('maximumLoanAvailed', String.valueOf(salariedObj.Maximum_Loan_Availed__c));
    // mapOfPolicyParameters.put('years_in_business_job', salariedObj.Total_Employment_vintage_Year__c);
    // mapOfPolicyParameters.put('securedLoanAmount', '7450000');
    //mapOfPolicyParameters.put('unSecuredLoanAmount', '0');
    //mapOfPolicyParameters.put('securedMob', '48');
   // mapOfPolicyParameters.put('unSecuredMob', '0');
   // mapOfPolicyParameters.put('Clinic_Hospital_type', 'Clinic');
   // mapOfPolicyParameters.put('expPostGradSuperSpecialist', '12');
   // mapOfPolicyParameters.put('totalExposure', '1000');
      
  }
   //mobility changes S
        system.debug('salariedObj.utm_source1__c===>' + salariedObj.utm_source1__c);
        if (salariedObj.utm_source1__c == 'proMobile') {
            system.debug('entered proMobile');
            Branch_Master__c branchMaster = [Select Doctors_Branch_Type__c, Professional_Branch_Type__c from Branch_Master__c WHERE Name = : branchName.toUpperCase() AND id=: salariedObj.Branch__c limit 1];
            mapOfPolicyParameters.put('gender', salariedObj.Gender__c);
            //testing
            mapOfPolicyParameters.put('product', 'DOL');
            mapOfPolicyParameters.put('specialisation', salariedObj.Specialisation__c);
            mapOfPolicyParameters.put('dolVersion', '1');
            mapOfPolicyParameters.put('doetype', 'DOE 3');
            mapOfPolicyParameters.put('customer_segment', customer_segment);
            // mapOfPolicyParameters.put('type_of_degree', salariedObj.Type_of_Degree__c);
            mapOfPolicyParameters.put('profession', 'DOCTOR');
            mapOfPolicyParameters.put('process_type', 'PRE APPROVED');
            mapOfPolicyParameters.put('professionType', 'PRE APPROVED');
            mapOfPolicyParameters.put('years_in_business_job', salariedObj.Total_Employment_vintage_Year__c);
            mapOfPolicyParameters.put('first_name', salariedObj.First_Name__c);
            mapOfPolicyParameters.put('last_name', salariedObj.Last_Name__c);
            mapOfPolicyParameters.put('monthly_loan_obligations', String.valueOf(salariedObj.Total_Monthly_Obligations__c));
            //hard coded 0 as response ids not received if sent null
            mapOfPolicyParameters.put('monthly_loan_obligations', '0');
            mapOfPolicyParameters.put('branch_name', branchName);
            mapOfPolicyParameters.put('branch_type', branchMaster.Doctors_Branch_Type__c);
            mapOfPolicyParameters.put('practiceType', 'Hospital'); //Loan.Account.Practice_Type__c 
            //mapOfPolicyParameters.put('Clinic_Hospital_type', 'Hospital');   
            mapOfPolicyParameters.put('requested_tenor', String.valueOf(salariedObj.Cust_Selected_Tenor__c));
            mapOfPolicyParameters.put('expPostGradSuperSpecialist', salariedObj.Join_dt_curr_emp_year__c);
            mapOfPolicyParameters.put('professionType', 'DOCTOR'); //accObj.Profession__c
            //  mapOfPolicyParameters.put('stage', 'Underwriting'); 
            //  mapOfPolicyParameters.put('mortgageLoanAmount', '123'); 
            // mapOfPolicyParameters.put('first_name', salariedObj.);
            //mapOfPolicyParameters.put('last_name', salariedObj.Last_Name__c);
            // mapOfPolicyParameters.put('process_type', salariedObj.Process_type__c);
            mapOfPolicyParameters.put('totalExposure', String.valueOf(cibilExt1Rec.Total_Exposure__c));
            mapOfPolicyParameters.put('CIBIL_Score', cibilRec.CIBIL_Score__c);
            system.debug('salariedObj.DOL_City__c.toUpperCase()===>' + salariedObj.DOL_City__c.toUpperCase());

            //mapOfPolicyParameters.put('branch_name', salariedObj.Branch_name_DOL__c);
            // mapOfPolicyParameters.put('branch_type', branchMaster.Doctors_Branch_Type__c);
            //mapOfPolicyParameters.put('practiceType', salariedObj.Practice_Type__c);
            mapOfPolicyParameters.put('securedLoanAmount', String.valueOf(cibilExt1Rec.Max_Secured_Loan_Amount__c));
            mapOfPolicyParameters.put('unSecuredLoanAmount', String.valueOf(cibilExt1Rec.Max_unSecured_Loan_Amount__c));
            mapOfPolicyParameters.put('securedMob', String.valueOf(cibilExt1Rec.Max_Secured_MOB__c));
            mapOfPolicyParameters.put('unSecuredMob', String.valueOf(cibilExt1Rec.Max_Unsecured_MOB__c));
            if(salariedObj.Specialisation__c == 'CA' && salariedObj.Practice_Type__c == 'SEP'){
                    mapOfPolicyParameters.put('product', 'PRO');
                    mapOfPolicyParameters.put('process_type', 'PRE APPROVED');
                    mapOfPolicyParameters.put('profession', salariedObj.Specialisation__c);
                    mapOfPolicyParameters.put('practiceType', salariedObj.Practice_Type__c);
                    system.debug('Entered CA SEP block Eligiblity');
                
                }
        }
        //mobility changes E
        //BOL Revamp Leena start
        //Bug ID - 13489 BOL Reinvent BY Rajesh START
        //Passing Turnover and Nature of Buisness parameter 
  if (isBOLProductLineProduct) {
  /* Start added by Mahima for Bug-17588*/
    //CIBIL__c cibil = [select Id,Cibil_Temp__c,Cibil_Temp__r.DPD_cluster_Segment__c from CIBIL__c where Id=:cibilRec.Id];
    CIBIL__c cb = [select CIBIL_Extension__c ,CIBIL_Extension__r.Number_DPD_in_CC_gtr_24_month__c ,CIBIL_Extension__r.Number_DPDs_in_last_24__c
    ,CIBIL_Extension__r.Sanction_amount_of_live_loans_of_AL__c,CIBIL_Extension__r.Sanction_amount_of_live_loans_of_BL__c,Cibil_Temp__r.DPD_cluster_Segment__c 
    ,CIBIL_Extension__r.Sanction_amount_of_live_loans_of_PL__c,CIBIL_Extension__r.Sanction_amount_of_live_loans_of_HL__c
    ,CIBIL_Extension__r.Sanction_amount_of_live_loans_of_LAP__c,CIBIL_Extension__r.Number_of_live_AL__c,CIBIL_Extension__r.Number_of_live_HL__c
    ,CIBIL_Extension__r.Number_of_live_LAP__c,CIBIL_Extension__r.Sum_of_sanction_amount_of_live_AL_loans__c,CIBIL_Extension__r.Sum_of_sanction_amount_of_live_PL_loans__c
    ,CIBIL_Extension__r.Sum_of_sanction_amount_of_live_BL_loans__c,CIBIL_Extension__r.Sum_of_sanction_amount_live_HL_loans__c,CIBIL_Extension__r.Sum_of_sanction_amount_live_LAP_loans__c 
    from CIBIL__c where id=:cibilRec.Id Limit 1];
  /* End added by Mahima for Bug-17588*/
   mapOfPolicyParameters.put('cy_sales_turnover', salariedObj.Turnover_in_Current_Year__c == null ? '0' : String.valueof(salariedObj.Turnover_in_Current_Year__c));
   mapOfPolicyParameters.put('turnover_band', salariedObj.Turnover__c == null ? '0' : salariedObj.Turnover__c);
   mapOfPolicyParameters.put('years_in_business_job', salariedObj.Total_Employment_vintage_Year__c == null ? '0' : String.valueOf(salariedObj.Total_Employment_vintage_Year__c));
   mapOfPolicyParameters.put('nature_of_business', salariedObj.Nature_of_Business__c   == null ? '' : String.valueOf(salariedObj.Nature_of_Business__c));
            
            /* Start added parameter by Mahima for Bug-17588*/
            mapOfPolicyParameters.put('number_of_bl_loans', (CommonUtility.isEmpty(cibilExt1Rec.No_of_Live_BL__c) || cibilExt1Rec.No_of_Live_BL__c== 0) ? '' : String.valueOf(cibilExt1Rec.No_of_Live_BL__c));
            mapOfPolicyParameters.put('number_of_personal_loans', (CommonUtility.isEmpty(cibilExt1Rec.No_of_Live_PL__c)|| cibilExt1Rec.No_of_Live_PL__c== 0) ? '' : String.valueOf(cibilExt1Rec.No_of_Live_PL__c));
            mapOfPolicyParameters.put('pan', salariedObj.Pan__c == null ? '' : String.valueOf(salariedObj.Pan__c));
            //mapOfPolicyParameters.put('years_in_business_job', salariedObj.Total_Employment_vintage_Year__c == null ? '0' : String.valueOf(salariedObj.Total_Employment_vintage_Year__c));
            
            //mapOfPolicyParameters.put('nature_of_business', salariedObj.Nature_of_Business__c == null ? '' : salariedObj.Nature_of_Business__c);
            mapOfPolicyParameters.put('maxHLLAP', (cibilExt1Rec.Max_HL_LAP__c == null || cibilExt1Rec.Max_HL_LAP__c== 0) ? '' : String.valueOf(cibilExt1Rec.Max_HL_LAP__c));
            mapOfPolicyParameters.put('maxALBLPLProf', (cibilExt1Rec.Max_AL_BL_PL_Prof__c == null || cibilExt1Rec.Max_AL_BL_PL_Prof__c== 0) ? '' : String.valueOf(cibilExt1Rec.Max_AL_BL_PL_Prof__c));
            mapOfPolicyParameters.put('dpdCluserSegment', cb.Cibil_Temp__r.DPD_cluster_Segment__c == null ? '' : cb.Cibil_Temp__r.DPD_cluster_Segment__c);//19478 deployment failed so added missing Cibil_Temp__r
            mapOfPolicyParameters.put('sanctionedLoanAmt',(cibilExt1Rec.Max_Credit_Card_amount__c == null || cibilExt1Rec.Max_Credit_Card_amount__c== 0) ? '' : String.valueOf(cibilExt1Rec.Max_Credit_Card_amount__c));
            mapOfPolicyParameters.put('maxALBLPL', (cibilExt1Rec.MAX_AL_BL_PL__c == null || cibilExt1Rec.MAX_AL_BL_PL__c== 0) ? '' : String.valueOf(cibilExt1Rec.MAX_AL_BL_PL__c));
            mapOfPolicyParameters.put('max2WGoldLoan', (cibilExt1Rec.MAX_2W_Gold__c == null || cibilExt1Rec.MAX_2W_Gold__c== 0)? '' : String.valueOf(cibilExt1Rec.MAX_2W_Gold__c));
            mapOfPolicyParameters.put('maxConsumerDurable', (cibilExt1Rec.Max_Consumer_Loan__c== null || cibilExt1Rec.Max_Consumer_Loan__c== 0)? '' : String.valueOf(cibilExt1Rec.Max_Consumer_Loan__c));
            
   mapOfPolicyParameters.put('bajajPLloanMOB', cibilExt1Rec.Bajaj_PL_loan_MOB__c == null ? '' : String.valueOf(cibilExt1Rec.Bajaj_PL_loan_MOB__c));
            mapOfPolicyParameters.put('noOf30DPD_GL_And_CC', cibilExt1Rec.No_30_DPD_12_Exld_CC_GL__c == null ? '' : String.valueOf(cibilExt1Rec.No_30_DPD_12_Exld_CC_GL__c));
            mapOfPolicyParameters.put('cibil_vintage', (cibilExt1Rec.Cibil_Vintage__c == null || cibilExt1Rec.Cibil_Vintage__c== 0)? '' : String.valueOf(cibilExt1Rec.Cibil_Vintage__c));
            System.debug('cibilExt1Rec.Cibil_Vintage__c---->'+cibilExt1Rec.Cibil_Vintage__c);
            system.debug('condition::'+(cibilExt1Rec.Cibil_Vintage__c == null || cibilExt1Rec.Cibil_Vintage__c== 0));
    //Added for BOL and DBOL 
    mapOfPolicyParameters.put('process_type', 'BOLR');
  System.debug('mapOfPolicyParameters---->'+mapOfPolicyParameters);
            /*End  parameter by Mahima for Bug-17588*/
            // Bug Id : 20187
            if(cb.CIBIL_Extension__c != null) {
                mapOfPolicyParameters.put('overdueAmountGT5000', cb.CIBIL_Extension__r.Number_DPD_in_CC_gtr_24_month__c == null ? '0' : String.valueOf(cb.CIBIL_Extension__r.Number_DPD_in_CC_gtr_24_month__c));
                mapOfPolicyParameters.put('dpdinLast24Months', cb.CIBIL_Extension__r.Number_DPDs_in_last_24__c == null ? '0' : String.valueOf(cb.CIBIL_Extension__r.Number_DPDs_in_last_24__c));
                mapOfPolicyParameters.put('sanction_amount_AL', cb.CIBIL_Extension__r.Sanction_amount_of_live_loans_of_AL__c == null ? '0' : String.valueOf(cb.CIBIL_Extension__r.Sanction_amount_of_live_loans_of_AL__c));
                mapOfPolicyParameters.put('sanction_amount_BL', cb.CIBIL_Extension__r.Sanction_amount_of_live_loans_of_BL__c == null ? '0' : String.valueOf(cb.CIBIL_Extension__r.Sanction_amount_of_live_loans_of_BL__c));
                mapOfPolicyParameters.put('sanction_amount_PL', cb.CIBIL_Extension__r.Sanction_amount_of_live_loans_of_PL__c == null ? '0' : String.valueOf(cb.CIBIL_Extension__r.Sanction_amount_of_live_loans_of_PL__c));
                mapOfPolicyParameters.put('sanction_amount_HL', cb.CIBIL_Extension__r.Sanction_amount_of_live_loans_of_HL__c == null ? '0' : String.valueOf(cb.CIBIL_Extension__r.Sanction_amount_of_live_loans_of_HL__c));
                mapOfPolicyParameters.put('sanction_amount_LAP', cb.CIBIL_Extension__r.Sanction_amount_of_live_loans_of_LAP__c == null ? '0' : String.valueOf(cb.CIBIL_Extension__r.Sanction_amount_of_live_loans_of_LAP__c));
                mapOfPolicyParameters.put('number_of_live_AL', cb.CIBIL_Extension__r.Number_of_live_AL__c == null ? '0' : String.valueOf(cb.CIBIL_Extension__r.Number_of_live_AL__c));
                mapOfPolicyParameters.put('number_of_live_HL', cb.CIBIL_Extension__r.Number_of_live_HL__c == null ? '0' : String.valueOf(cb.CIBIL_Extension__r.Number_of_live_HL__c));
                mapOfPolicyParameters.put('number_of_live_LAP', cb.CIBIL_Extension__r.Number_of_live_LAP__c == null ? '0' : String.valueOf(cb.CIBIL_Extension__r.Number_of_live_LAP__c));
                //Added By Rajendra BUG ID :- 23565
                mapOfPolicyParameters.put('liveAL', cb.CIBIL_Extension__r.Sum_of_sanction_amount_of_live_AL_loans__c == null ? '0' : String.valueOf(cb.CIBIL_Extension__r.Sum_of_sanction_amount_of_live_AL_loans__c));
                mapOfPolicyParameters.put('livePL', cb.CIBIL_Extension__r.Sum_of_sanction_amount_of_live_PL_loans__c == null ? '0' : String.valueOf(cb.CIBIL_Extension__r.Sum_of_sanction_amount_of_live_PL_loans__c));
                mapOfPolicyParameters.put('liveBL', cb.CIBIL_Extension__r.Sum_of_sanction_amount_of_live_BL_loans__c == null ? '0' : String.valueOf(cb.CIBIL_Extension__r.Sum_of_sanction_amount_of_live_BL_loans__c));
                mapOfPolicyParameters.put('liveHL', cb.CIBIL_Extension__r.Sum_of_sanction_amount_live_HL_loans__c == null ? '0' : String.valueOf(cb.CIBIL_Extension__r.Sum_of_sanction_amount_live_HL_loans__c));
                mapOfPolicyParameters.put('liveLAP', cb.CIBIL_Extension__r.Sum_of_sanction_amount_live_LAP_loans__c == null ? '0' : String.valueOf(cb.CIBIL_Extension__r.Sum_of_sanction_amount_live_LAP_loans__c));
                //Ended by Rajendra BUG ID :- 23565
            }
            
  }
      //Bug ID - 13489 BOL Reinvent BY Rajesh END
  //BOL Revamp Leena end
  if(!Test.isRunningTest())
    mapOfPolicyResult = breObj.callBREeligibility(mapOfPolicyParameters);
  return mapOfPolicyResult;
 }
 
  //mobility changes S
    public static Map < String, String > checkSegmentationforDOL(Salaried__c salariedObj, CIBIL__c cibilRec, Cibil_Extension1__c cibilExt1Rec) {
          //  try {

                Map < String, String > mapOfPolicyResult = new Map < String, String > ();
                MAP < String, String > mapOfPolicyParameters = new MAP < String, String > ();
                List < string > cibilFieldMissing = new List < string > ();
                BRECallout breObj = new BRECallout();
                mapOfPolicyParameters.put('total_Employment_Vintage', salariedObj.Total_Employment_vintage_Year__c != null ? string.valueOf(salariedObj.Total_Employment_vintage_Year__c) : '');
                if (cibilExt1Rec != null) {
                    // Cibil_Extension1__c cibilExt1Rec = new Cibil_Extension1__c();
                    // cibilExt1Rec = cibilExt1Rec;
                    //mapOfPolicyParameters.put('loan_id', newPO.id == null ? '' : newPO.id);
                    mapOfPolicyParameters.put('product', 'DOL');
                    mapOfPolicyParameters.put('applicant_Type', 'Primary');
                    //mapOfPolicyParameters.put('processType', 'Pre approved');
                    mapOfPolicyParameters.put('CIBIL_Score', cibilRec.CIBIL_Score__c == null ? '0' : cibilRec.CIBIL_Score__c);
                    mapOfPolicyParameters.put('total_no_of_loans_excl_cc', cibilExt1Rec.Total_no_of_loans_Excluding_CC__c != null ? cibilExt1Rec.Total_no_of_loans_Excluding_CC__c + '' : '0');
                    mapOfPolicyParameters.put('unsecured_live_loan_balance', cibilExt1Rec.Current_Obligation_unsecured__c != null ? cibilExt1Rec.Current_Obligation_unsecured__c + '' : '0');
                    mapOfPolicyParameters.put('highest_dpd_In_1_year', cibilExt1Rec.Highest_DPD_In_1_Year__c != null ? cibilExt1Rec.Highest_DPD_In_1_Year__c + '0' : '');
                    mapOfPolicyParameters.put('ratioCCUtil', cibilExt1Rec.Credit_Card_utilization__c != null ? cibilExt1Rec.Credit_Card_utilization__c + '' : '0');
                    mapOfPolicyParameters.put('total_no_of_secured_loans', cibilExt1Rec.Total_no_of_secured_loans__c != null ? cibilExt1Rec.Total_no_of_secured_loans__c + '' : '0');
                    mapOfPolicyParameters.put('specialisation', salariedObj.Specialisation__c == null ? '' : salariedObj.Specialisation__c);
                    mapOfPolicyParameters.put('type_of_degree', salariedObj.Type_of_Degree__c == null ? '' : salariedObj.Type_of_Degree__c);
                    /*  mapOfPolicyParameters.put('branch_Name', newPO.Lead__r.SBS_Branch__r.name == null ? '' : newPO.Lead__r.SBS_Branch__r.name); */

                    mapOfPolicyParameters.put('unsecured_sanction_amt', (cibilExt1Rec.Unsecured_loan_balance__c != null) ? String.valueof(cibilExt1Rec.Unsecured_loan_balance__c) : '');
                    mapOfPolicyParameters.put('total_no_of_secured_loans', (cibilExt1Rec.Total_no_of_secured_loans__c != null) ? String.valueof(cibilExt1Rec.Total_no_of_secured_loans__c) : '');
                    mapOfPolicyParameters.put('ratioCCUtil', (cibilExt1Rec.Credit_Card_utilization__c != null) ? String.valueof(cibilExt1Rec.Credit_Card_utilization__c) : '');
                    mapOfPolicyParameters.put('highest_dpd_In_1_year', (cibilExt1Rec.Tradelines_30plus_DPD__c != null) ? String.valueof(cibilExt1Rec.Tradelines_30plus_DPD__c) : '');
                    mapOfPolicyParameters.put('number_of_HL_loans', (cibilExt1Rec.Number_of_Hl_Loans__c != null) ? String.valueof(cibilExt1Rec.Number_of_Hl_Loans__c) : '');
                    mapOfPolicyParameters.put('profession', 'DOCTOR');
                    mapOfPolicyParameters.put('dolVersion', '1');
                    mapOfPolicyParameters.put('processType', 'PRE APPROVED');
                    /* mapOfPolicyParameters.put('first_Name', (userinfo.getFirstName() != null) ? userinfo.getFirstName() + '' : '');
                     mapOfPolicyParameters.put('last_Name', (userinfo.getLastName() != null) ? userinfo.getLastName() + '' : ''); */
                    mapOfPolicyParameters.put('age', salariedObj.Date_Of_Birth__c == null ? '' : string.valueOf(system.TODAY().year() - salariedObj.Date_Of_Birth__c.year()));
                    system.debug('mapOfPolicyParametersSegmentation==>' + mapOfPolicyParameters);
                    if(salariedObj.Specialisation__c == 'CA' && salariedObj.Practice_Type__c == 'SEP'){
                    system.debug('Entered CA block segmentation');
                    mapOfPolicyParameters.put('product', 'PRO');
                    mapOfPolicyParameters.put('process_type', 'PRE APPROVED');
                    mapOfPolicyParameters.put('profession', salariedObj.Specialisation__c);
                
                }
                    if (!Test.isRunningTest())
                        mapOfPolicyResult = breObj.callBRESegmentation(mapOfPolicyParameters);
                }
                
                system.debug('mapOfPolicyResult===>' + mapOfPolicyResult);
                return mapOfPolicyResult;
                /*
                        system.debug('mapOfPolicyResult.get === >' + mapOfPolicyResult.get('CustomerSegment'));
                        if (mapOfPolicyResult.get('CustomerSegment1') != null && mapOfPolicyResult.get('CustomerSegment1') != '') {
                            newPO.Existing_Customer_Segmentation__c = mapOfPolicyResult.get('CustomerSegment1'); 
                       }
                       */


         /*   } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Problem While Processing Request!! please Try again later', ''));
              
                return null;

            }*/
        }
        //mobility changes E

    
    /**
     * Author       - Nikhil
     * @date        - 9/6/2016
     * @description - Merge fields from source record to destination record & return destination record
     * @param       - sObject : Destination Record
     *                sObject : Source Record
     * @return      - sObject : Merged/Destination Record
     * @modifiedby  -
     */
    public static sObject mergeSObjectRecords(sObject destRec, sObject srcRec){
        system.debug('Inside mergeSObjectRecords');
        if(!isEmpty(srcRec)){
            if(isEmpty(destRec))
                destRec = srcRec;
            else{
                // Start of changes by Niraj
                String objName = srcRec.getSObjectType().getDescribe().getName();
                Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe(); 
                Schema.SObjectType objectType = globalDescribe.get(objName);
                Schema.DescribeSObjectResult objectDescribeResult = objectType.getDescribe();
                Map<String, Schema.SObjectField> objectFieldMap = objectDescribeResult.fields.getMap();
                // End of changes by Niraj
                
                for(String fldName: (srcRec.getPopulatedFieldsAsMap()).keySet()) {
                    
                    // Start of changes by Niraj
                    Schema.SObjectField objectField = objectFieldMap.get(fldName);
                    Schema.DescribeFieldResult fieldDescription = objectField.getDescribe();
                    if(fieldDescription.isUpdateable()){
                        system.debug('fldName --> ' + fldName);
                        system.debug('source fldName --> ' + srcRec.get(fldName));
                        destRec.put(fldName,srcRec.get(fldName));
                        system.debug('dest fldName --> ' + destRec.get(fldName));
                    }
                    // End of changes by Niraj
                }
                    
            }
        }
        return destRec;
    } 
   
    /**
     * Author       - Nikhil
     * @date        - 9/16/2016
     * @description - Check if a string is valid sobject ID
     * @param       - String : strId (Id as a string that is to be validated)
     * @return      - Boolean : true if Id is valid, false otherwise 
     * @modifiedby  -
     */
    public static Boolean isValidId(String strId) {
        return (strId InstanceOf ID) ? true : false ;
        //return isValid ;
    }
    
    @Future(callout=true)
    public static void BREMCPCheckForMobility(Map<String, String> MapofParameter)
    {
        Salaried__c salariedObj = new Salaried__c();
        CIBIL__c cibilRec = new CIBIL__c();
        Integer flow ;
        ID poID ;
        ID appID ;
        System.debug('in future---->');
        if(MapofParameter != null && MapofParameter.size() > 0)
        {
            if(MapofParameter.get('salariedObject') != null)
            {
                salariedObj = (Salaried__c) JSON.deserialize(MapofParameter.get('salariedObject'),Salaried__c.class);
            }
            if(MapofParameter.get('cibilRec') != null)
            {
                cibilRec =(CIBIL__c)JSON.deserialize(MapofParameter.get('cibilRec'),CIBIL__c.class);
            }
            else{
                cibilRec = null;
            }
            if(MapofParameter.get('flow') != null)
            {
                flow = Integer.valueOf(MapofParameter.get('flow'));
            }
            if(MapofParameter.get('POobjId') != null)
            {
                poID = MapofParameter.get('POobjId');
            }
            
        }
        
        Map<String, String> BreResult= new Map<String,String>();
        BreResult = BREMCPCheckForDOL(salariedObj,cibilRec,flow);
         String FinalMCPResult = '';
         System.debug('breresult--->'+BreResult);
        if (BreResult != null && BreResult.size() > 0) {

                    FinalMCPResult = BreResult.get('FinalResult');
                    system.debug('FinalMCPResult***' + FinalMCPResult);
                    String MCPResult = BreResult.get('MCPList');
                    if (('REJECT').equalsIgnoreCase(FinalMCPResult) || ('REJECTED').equalsIgnoreCase(FinalMCPResult) ||
                        ('AUTO REJECT').equalsIgnoreCase(FinalMCPResult) || ('AUTO REJECTED').equalsIgnoreCase(FinalMCPResult) ||
                        ('AUTOREJECT').equalsIgnoreCase(FinalMCPResult) || ('AUTOREJECTED').equalsIgnoreCase(FinalMCPResult) ||
                        ('REFER').equalsIgnoreCase(FinalMCPResult) || ('MCP FAIL').equalsIgnoreCase(FinalMCPResult)) {
                        System.debug('in mcp fail--->'+FinalMCPResult +'mcp result'+MCPResult);
                       /* if(poID != null){
                            List<SOL_Policy__c> solpollst = [SELECT Id,Policy_Name__c FROM SOL_Policy__c WHERE Product_Offerings__c = :poID];
                            if(solpollst != null && solpollst.size() > 0)
                            {
                                delete solpollst;
                            }
                        }*/
                        if (!isEmpty(MCPResult))
                            createPolicyRecord(MCPResult, FinalMCPResult, poID , appID );

                       
                    }
                }
    }
    
    /**
     * Author       - Rohit Mourya
     * @date        - 9/2/2017
     * @description - Check if given user is eligible to send SMS
     * @return      - Boolean : true if Id is valid, false otherwise 
     * @modifiedby  -
     */
    public static Boolean isEligibleToSendSMS(){
        List<String> profiles = label.Send_SMS_Profiles.split(';');
        System.debug(profiles);
        Set<String> profileSet = new Set<String>();
        for(String s:profiles){
            profileSet.add(s);
            
        }
        List <Profile> profileList = [SELECT Name FROM Profile WHERE id =: Userinfo.getProfileId()];
            
        if(profileList.size () > 0) {
            if (profileSet.contains (profileList[0].Name)) {      
                return true;            
            }
        }
        return false;
    }
    
    /**
     * Author       - Rakesh Shinde
     * @date        - 4/4/2017
     * @description - Check if given user is eligible to send Email
     * @return      - Boolean : true if Id is valid, false otherwise 
     * @modifiedby  -
     */
     public static Boolean isCustWithRMProfile(String profileId){
        List<String> profiles = label.RM_Profiles.split(';');
        System.debug(profiles);
        Set<String> profileSet = new Set<String>();
        for(String s:profiles){
            profileSet.add(s);            
        } 
        List <Profile> profileList = [SELECT Name FROM Profile WHERE id =: profileId];
            
        if(profileList.size () > 0) {
            if (profileSet.contains (profileList[0].Name)) {      
                return true;            
            }
        }
        return false;
    }
    
     /**
     * Author       - Akshata Rajmane
     * @date        - 21/4/2017
     * @description - Calculate net disbursed amount
     * @return      - Decimal 
     * @modifiedby  -
     */
    public static Decimal CalculateDisbursedAmount(String LoanID , Decimal LoanAmtWithPrimium){
        decimal totalchrg=0.00;      
        decimal netDisAmt=0.00;
        List<Fees_and_Charge__c> fees =new List<Fees_and_Charge__c>();
        System.debug('loanId ---->'+LoanID+'LoanAmtWithPrimium ---->'+LoanAmtWithPrimium);
        if(!CommonUtility.isEmpty(LoanID))
            fees= [select id,Finnone_ChargeId__c,Finnone_ChargeCode__c,Charge_Desc__c, name, Charge_Type__c, Change_Amount__c, Charge__c from Fees_and_Charge__c where Loan_Application__c = : LoanID AND Deducted_from_Disbursement__c='Yes'];
        
        if(!CommonUtility.isEmpty(fees)){
            for(Fees_and_Charge__c fe:fees){
                if( fe.Charge_Type__c!=null &&  fe.Change_Amount__c!=null){
                    totalchrg = totalchrg +  fe.Change_Amount__c;
                 }
                else{
                    if (fe.Charge_Desc__c!=null &&  fe.Change_Amount__c!=null){
                        totalchrg = totalchrg +  fe.Change_Amount__c;
                        }
                }
            }
        }

        netDisAmt = LoanAmtWithPrimium - totalchrg ;
        System.debug('NET DIS AMT : '+netDisAmt);
        return netDisAmt;
    }
      //Cibil Validation Enhancement-Leena-start
    public static String triggerCibilValidation(Applicant__c applicantPrimary,Opportunity Loan)
    {
        system.debug('inside triigercibil validation applicantPrimary==>'+applicantPrimary);      
        string flag;
        Integer difference;
        Integer noOfDays;
        if(LaonApplicationCreation__c.getValues('CibilTriggerValidationProducts')!=null)
        noOfDays =Integer.valueOf(LaonApplicationCreation__c.getValues('CibilTriggerValidationProducts').Numberofdays__c);
        List<CIBIL__c>CibilList=new List<CIBIL__c>();
        //15721--added limit 1
        CibilList=[select id,CreatedDate,CIBIL_Fired_time__c from CIBIL__c where Applicant__c=:applicantPrimary.id ORDER BY CreatedDate DESC limit 1];
        if(CibilList!=null && CibilList.size()>0)
        { 
            system.debug('inside cibilList'+CibilList);
            difference= Math.abs(system.now().Date().daysBetween(CibilList[0].CreatedDate.Date()));
            system.debug('inside cibilList difference===>'+difference);
            system.debug('inside cibilList noOfDays===>'+noOfDays);
            //15721--S
            flag = difference>noOfDays?'true;'+difference:'false';
            //15721--E
            //15721-- Commented Code for optimization
            /*if(difference>noOfDays)
            {
             flag='true';
            }
            else
            {
            flag='false';
            }
            }
            if(flag=='true')
            {
            flag=flag+';'+difference;*/
        }
          system.debug('inside triigercibil validation flag====>'+flag);      
        return flag;
   }
//Cibil Validation Enhancement-Leena-end
//Code added by Leena-BL DSS change request 10658-start
     // point no 9 Validation on Balance sheet
public static String triggerValidationBlnSht(SurrogateCAM__c selectedSurrogate)
    {
    transient  string balanceshtmsg='';
    transient string CYMessage,PYMessage;
    CYMessage='Asset ';
    PYMessage='Asset ';
    transient Integer CYcount,PYcount;
    CYcount=0;
    PYcount=0;
    Map<String,Double>mapOfAssetCY=new Map<String,Double>();
    Map<String,Double>mapOfAssetPY=new Map<String,Double>();
    //putting cy details in map
    mapOfAssetCY.put('CY Capital',selectedSurrogate.CY_Capital__c);
    mapOfAssetCY.put('CY Reserves and Surplus',selectedSurrogate.CY_Reserves_and_Surplus__c);
    mapOfAssetCY.put('CY Total Existing Borrowings Excluding OD/CC',selectedSurrogate.CY_Total_Existing_Borrowings_Excluding_O__c);
    mapOfAssetCY.put('CY Total Creditors',selectedSurrogate.CY_Total_Creditors__c);
    mapOfAssetCY.put('CY Total Debtors',selectedSurrogate.CY_Total_Debtors__c);
    mapOfAssetCY.put('CY Closing Stock',selectedSurrogate.CY_Closing_Stock__c);
    mapOfAssetCY.put('CY Total Cash and Bank ',selectedSurrogate.CY_Total_Cash_and_Bank_Balance__c);
    //putting py details in map
    mapOfAssetPY.put('PY Capital',selectedSurrogate.PY_Capital__c);
    mapOfAssetPY.put('PY Reserves and Surplus',selectedSurrogate.PY_Reserves_and_Surplus__c);
    mapOfAssetPY.put('PY Total Existing Borrowings Excluding OD/CC',selectedSurrogate.PY_Total_Existing_Borrowings_Excluding_O__c);
    mapOfAssetPY.put('PY Total Creditors',selectedSurrogate.PY_Total_Creditors__c);
    mapOfAssetPY.put('PY Total Debtors',selectedSurrogate.PY_Total_Debtors__c);
    mapOfAssetPY.put('PY Closing Stock',selectedSurrogate.PY_Closing_Stock__c);
    mapOfAssetPY.put('PY Total Cash and Bank ',selectedSurrogate.PY_Total_Cash_and_Bank_Balance__c);
    
    system.debug('mapOfAssetPY is==>'+mapOfAssetPY);
    system.debug('mapOfAssetCY is==>'+mapOfAssetCY);
      for (String fieldName : mapOfAssetCY.keySet()){
      if(mapOfAssetCY.get(fieldName)>selectedSurrogate.CY_Balance_Sheet_Total__c){
      CYcount++;
      CYMessage=CYMessage+fieldName+' ,';
      
      }
      }
       for (String fieldName : mapOfAssetPY.keySet()){
      if(mapOfAssetPY.get(fieldName)>selectedSurrogate.PY_Balance_Sheet_Total__c){
      PYcount++;
      PYMessage=PYMessage+fieldName+' ,';
      }
      }
      if(CYcount>=1){
      system.debug('Inside disply balance sheet message');
      CYMessage=CYMessage+' Exceeded  CY Balance Sheet Total !!!!!';
      balanceshtmsg=balanceshtmsg+CYMessage;
     }
     balanceshtmsg=balanceshtmsg+'<br>';
     balanceshtmsg=balanceshtmsg+'<br>';
     system.debug('Inside disply balance sheet message py count===>'+PYcount);
     if(PYcount>=1){
      system.debug('Inside disply balance sheet message py count');
      PYMessage=PYMessage+' Exceeded  PY Balance Sheet Total !!!!!';
      system.debug('Inside disply balance sheet message py count PYMessage==>'+PYMessage);
      balanceshtmsg=balanceshtmsg+PYMessage;
     }
     return balanceshtmsg;
   }
   //Code added by Leena-BL DSS change request 10658-end
   
    /**
     * Author       - Akshata Rajmane
     * @date        - 09/05/2017
     * @description - Send mail when exception occur
     * @return      - void 
     * @modifiedby  -
     */
     public static void SendExceptionMail(String str){
        SOLsendEmail.LogixEmailForDG(new List < String > {
            'akshata_rajmane@persistent.com',
            'dinesh_harde@persistent.com'
   }, UserInfo.getUserName().substringAfterLast('.') + ': LoanConversionUtility Exception: LonvertToloan', str);
   }
    //Code added by Anurag for encryption-- Start
    //Purpose of the code: Encrypting URL parameters using System.Label.cryptoKey
    public static String encryptURLParam (String paramToBeEncrypted){
        Blob strIV = Blob.valueOf(Label.IV_for_URL_Encryption);
        System.debug ('strIV: '+strIV);
        Blob cryptoKey = Blob.valueOf(Label.cryptoKey);
        System.debug ('cryptoKey: '+cryptoKey);
        Blob blobParamToBeEncrypted = Blob.valueOf(paramToBeEncrypted);
        Blob blobEncryptedParam = Crypto.encrypt('AES128', cryptoKey, strIV, blobParamToBeEncrypted);
        String encodedParam = EncodingUtil.base64Encode(blobEncryptedParam);
        encodedParam =encodedParam.replace('+','~');
        //String urlEncodedParam = EncodingUtil.urlEncode(encodedParam, 'UTF-8'); 
        //return urlEncodedParam;
        return encodedParam;
     }
     //Code added by Anurag for encryption-- End
      //Code added by Pratik for encryption-- Start
       public static String encryptURLParamFrPan (String paramToBeEncrypted){
        String encodedParam = '';
        encodedParam = encryptURLParamDef(paramToBeEncrypted,Label.Prd_IV_for_URL_Encryption,Label.Prd_cryptoKey );
        return encodedParam;
    } 
    
    public static String encryptURLParamDef (String paramToBeEncrypted,String strIV1,String strCryptoKey ){ 
        Blob strIV = Blob.valueOf(strIV1);
        System.debug ('strIV123: '+strIV1);
        Blob cryptoKey = Blob.valueOf(strCryptoKey);
        System.debug ('cryptoKey123: '+strCryptoKey);
        Blob blobParamToBeEncrypted = Blob.valueOf(paramToBeEncrypted);
        Blob blobEncryptedParam = Crypto.encrypt('AES128', cryptoKey, strIV, blobParamToBeEncrypted);
        String encodedParam = EncodingUtil.base64Encode(blobEncryptedParam);
        encodedParam =encodedParam.replace('+','~');
        //String urlEncodedParam = EncodingUtil.urlEncode(encodedParam, 'UTF-8'); 
        //return urlEncodedParam;
        return encodedParam;
        
    }
    //Code added by Pratik for encryption-- End
     //Code added by Anurag for decryption-- Start
     //Purpose of the code: Decrypting URL parameters encrypted using System.Label.cryptoKey
     // Do not use for VF Pages for which Controller/ Standard Controller = custom object
     public static String decryptURLParam (String encryptedParam){
        encryptedParam =encryptedParam.replace('~','+'); 
        Blob strIV = Blob.valueOf(Label.IV_for_URL_Encryption);
        Blob cryptoKey = Blob.valueOf(Label.cryptoKey);
        //String urlDecodedParam = EncodingUtil.urlDecode(encryptedParam, 'UTF-8');
        Blob blobDecodedParam = EncodingUtil.base64Decode(encryptedParam);
        Blob blobDecryptedParam = Crypto.decrypt('AES128', cryptoKey, strIV, blobDecodedParam);
        String decryptedParam = blobDecryptedParam.toString();
        return decryptedParam;
     }
     //Code added by Anurag for decryption-- End
     //Code added by Pratik for decryption-- Start
       public static String decryptURLParamFrPan (String encryptedParam){
        String decryptedParam = '';
        decryptedParam = decryptURLParamDef(encryptedParam,Label.Prd_IV_for_URL_Encryption,Label.Prd_cryptoKey );
        return decryptedParam;
    } 
    
    public static String decryptURLParamDef (String encryptedParam,String strIV1,String strCryptoKey ){ 
        Blob strIV = Blob.valueOf(strIV1);
        System.debug ('strIV123: '+strIV1);
        Blob cryptoKey = Blob.valueOf(strCryptoKey);
        System.debug ('cryptoKey123: '+strCryptoKey);
        encryptedParam = encryptedParam.replace('~','+'); 
        Blob blobDecodedParam = EncodingUtil.base64Decode(encryptedParam);
        Blob blobDecryptedParam = Crypto.decrypt('AES128', cryptoKey, strIV, blobDecodedParam);
        String decryptedParam = blobDecryptedParam.toString();
        return decryptedParam;   
    }
    //Code added by Pratik for decryption-- End
      /* City field for demographic added by prashant Start */
        public static Map<String,Map<String,String>> city_stateMapping(){
        List<Demographic_Mapping__c> demoList = new List<Demographic_Mapping__c>();
        Map<String,Map<String,String>> city_stateMap;
        Map<String,String> stateMap;
        demoList = [select id,STD_Code__c,Name, State__c,City__c from Demographic_Mapping__c Order By City__c ASC];
        city_stateMap=new Map<String,Map<String,String>>();
        if(demoList != null && demoList.size() > 0)
        {
            for(Demographic_Mapping__c dm : demoList)
            {  
              if(dm.city__c != null)
              {
               /*Map<String,String> stateMap = new Map<String, String>{'state' => dm.State__c, 'stdcode'=> dm.STD_Code__c};*/
               if(dm.State__c != null)
                stateMap = new Map<String, String>{'state' => dm.State__c.touppercase()};
               else
               stateMap = new Map<String, String>{'state' => ''};
               city_stateMap.put(dm.City__c.touppercase(),stateMap );
              
             }
             }
         }
    
         return city_stateMap;
        }
     
      /* City field for demographic added by prashant end*/
      @InvocableMethod
          public static void updatecity_state(List<String> Accid)
          {
                system.debug('prashant'+Accid);
                List<String> newaccid = new List<String>();
                List<account> accList = new List<Account>(); 
                List<Account> updatedaccList = new List<Account>(); 
                Map<String,Map<String,String>> cityMap = new Map<String,Map<String,String>>();
                cityMap  = city_stateMapping();
                String accstring1 = Accid[0];
                if(accstring1.contains('#') && Accid[0].split('#')[1] != null && Accid[0].split('#')[1] == 'true')
                {
                    for(String str : Accid)
                        {
                        String[] accstring = str.split('#');
                        system.debug('prashant1'+accstring[0]+accstring[1]);
                        newaccid .add(accstring[0]);
                        }
                accList= [select Id,Rural_Current_City__c,Rural_Office_City__c,Rural_Permanent_City__c,Rural_AccCity__c,Current_City__c,Office_City__c,Permanent_City__c,AccCity__c,Current_State__c,Office_State__c,Permanent_State__c,Registered_Office_State__c from account where Id IN :newaccid];
                system.debug('prashantif'+newaccid);
                for(Account acc : accList)
                {   
                    if(acc.Rural_Current_City__c != null && cityMap.get(acc.Rural_Current_City__c.touppercase()) != null)
                    acc.Current_State__c= cityMap.get(acc.Rural_Current_City__c.touppercase()).get('state');
                    
                    if(acc.Rural_Office_City__c != null && cityMap.get(acc.Rural_Office_City__c.touppercase()) != null)
                    acc.Office_State__c= cityMap.get(acc.Rural_Office_City__c.touppercase()).get('state');
                    
                    if(acc.Rural_Permanent_City__c!= null && cityMap.get(acc.Rural_Permanent_City__c.touppercase()) != null)
                    acc.Permanent_State__c= cityMap.get(acc.Rural_Permanent_City__c.touppercase()).get('state');
                    
                    if(acc.Rural_AccCity__c!= null && cityMap.get(acc.Rural_AccCity__c.touppercase()) != null)
                    acc.Registered_Office_State__c = cityMap.get(acc.Rural_AccCity__c.touppercase()).get('state');
                    acc.Current_City__c= acc.Rural_Current_City__c;
                    acc.Office_City__c= acc.Rural_Office_City__c;
                    acc.Permanent_City__c= acc.Rural_Permanent_City__c;
                    acc.AccCity__c= acc.Rural_AccCity__c;
                }
       
               }else{
                    accList= [select Id,Rural_Current_City__c,Rural_Office_City__c,Rural_Permanent_City__c,Rural_AccCity__c,Current_City__c,Office_City__c,Permanent_City__c,AccCity__c,Current_State__c,Office_State__c,Permanent_State__c,Registered_Office_State__c from account where Id IN :accid];
                    system.debug('prashantelse'+Accid+accList);
                    for(Account acc : accList)
                    {   
                        if(acc.Current_City__c != null && cityMap.get(acc.Current_City__c.touppercase())!= null) {
                            system.debug('pk'+acc.Current_City__c ); 
                            acc.Current_State__c= cityMap.get(acc.Current_City__c.touppercase()).get('state');
                            system.debug('pk1'+acc.Current_State__c); 
                        }
                        if(acc.Office_City__c != null && cityMap.get(acc.Office_City__c.touppercase())!= null) {
                            system.debug('pk2'+acc.Office_City__c);
                            acc.Office_State__c= cityMap.get(acc.Office_City__c.touppercase()).get('state');
                            system.debug('pk3'+acc.Office_State__c);
                        }
                        if(acc.Permanent_City__c != null && cityMap.get(acc.Permanent_City__c.touppercase()) != null) {
                            acc.Permanent_State__c= cityMap.get(acc.Permanent_City__c.touppercase()).get('state');
                            system.debug('pk4'+acc.Permanent_State__c);
                        }
                        if(acc.AccCity__c != null && cityMap.get(acc.AccCity__c.touppercase()) != null)
                            acc.Registered_Office_State__c = cityMap.get(acc.AccCity__c.touppercase()).get('state');
                    
                   }
                
                 }
                     try {
                       System.debug('accList.size()::'+accList.size());
                        if(accList.size() > 0) {
                            update accList;
                        }
                         }
                    catch(Exception e) {
                        system.debug('excep'+e.getMessage());
                        }
               
                    
            }

   /* City field for demographic added by prashant End */
 /* general function for removing space ( and - from phone field*/
    public static String removeSpecialChar(String phone)
    {
        if (phone != '')
        {
            phone = phone.remove(' ');
            phone = phone.remove('(');
            phone = phone.remove(')');
            phone = phone.remove('-');
            
        }
        return phone;
    }
      //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal start
     /* purpose of the code :-we need to through the validation if higher level validations are not approved
     */  
//Aggregate query issue     
public static boolean validateDeviations(string profileName,List<checklist__c>chklstOfLoan){return false;}//Plz remove this
public static boolean validateDeviations(string profileName,Opportunity loan)
{
    Map<String,Set<String>>mapofAuthorities=new Map<String,Set<String>>();
    // Bug id : 13016 - New Role Creation for Credit, added by Needhi 
    mapofAuthorities.put('Credit Manager',new Set<String>{'Area Credit Manager','City Head','Regional Credit Manager','Zonal Credit Manager','National Credit Manager','Senior Credit Officer','National Risk Manager','Chief Risk Officer','Business Head','Chief-Credit & Operations','President'});
    mapofAuthorities.put('Area Credit Manager',new Set<String>{'City Head','Regional Credit Manager','Zonal Credit Manager','National Credit Manager','National Risk Manager','Chief Risk Officer','Business Head','Chief-Credit & Operations','President'});
    mapofAuthorities.put('City Head',new Set<String>{'City Head','Chief Risk Officer','National Risk Manager','Zonal Credit Manager','Regional Credit Manager','National Credit Manager','Chief-Credit & Operations'});
    mapofAuthorities.put('Regional Credit Manager',new Set<String>{'Zonal Credit Manager','National Credit Manager','National Risk Manager','Chief Risk Officer','Business Head','Chief-Credit & Operations','President'});
    mapofAuthorities.put('Zonal Credit Manager',new Set<String>{'National Credit Manager','National Risk Manager','Chief Risk Officer','Business Head','Chief-Credit & Operations','President'});
    mapofAuthorities.put('National Credit Manager',new Set<String>{'National Risk Manager','Chief Risk Officer','Business Head','Chief-Credit & Operations','President'});
    mapofAuthorities.put('National Risk Manager',new Set<String>{'Chief Risk Officer','Business Head','Chief-Credit & Operations','President'});
    mapofAuthorities.put('Senior Credit Officer',new Set<String>{'Chief-Credit & Operations','Business Head','Chief Risk Officer','President'});
    mapofAuthorities.put('Chief-Credit & Operations',new Set<String>{'Business Head','Chief Risk Officer','President'});
    boolean decideFlag=false;
            //for(Checklist__c chk:chklstOfLoan)
            List<checklist__c> lstChecklist = new List<checklist__c>();
            lstChecklist = [Select id, Document_Type__c,Deviation_Master__c,Deviation_Master__r.Minimum_Approver_Level__c, Mandatory__c, Sales_Status__c, Document__c from checklist__c where Loan_Application__c =: Loan.id ];
            for(Checklist__c chk:lstChecklist)
            {
            system.debug('inside validateDeviations chk==>'+chk);
                if(validateChecklist(chk,profileName,mapofAuthorities))
                {
                decideFlag=true;
                break;
                }
            }
                  system.debug('inside decideFlag=>'+decideFlag);
    return decideFlag;
 }
public static boolean validateChecklist(Checklist__c chk,string profileName,Map<String,Set<String>>mapOfAutority)
{
  system.debug('inside validateDeviations chk.Deviation_Master__c==>'+chk.Deviation_Master__c);
   system.debug('inside validateDeviations mapOfAutority.get(profileName)==>'+mapOfAutority.get(profileName));
      system.debug('inside validateDeviations chk.Deviation_Master__r.Minimum_Approver_Level__c==>'+chk.Deviation_Master__r.Minimum_Approver_Level__c);
     if(chk!=null && profileName!=null &&  chk.Deviation_Master__c!=null && chk.Deviation_Master__r.Minimum_Approver_Level__c!=null  && mapOfAutority!=null && mapOfAutority.size()>0 && mapOfAutority.get(profileName)!=null && mapOfAutority.get(profileName).size()>0 && mapOfAutority.get(profileName).contains(chk.Deviation_Master__r.Minimum_Approver_Level__c) && chk.Sales_Status__c!='Received')
    {
    return true;
    }
    else 
    {
    return false;
    }   
    
}
public static Map<String,Set<Checklist__c>> createdDelNotDelChklist(List<Checklist__c>checklistTrnxList,List < Document_Family__c > AllDocList,List < Deviation_Master__c > allDevMasterList)
{
Map<String,set<Checklist__c>>mapofchecklist=new Map<String,set<Checklist__c>>();
 Set<Checklist__c> checklistTrnxListNotDel = new Set<Checklist__c> ();
Set<Checklist__c> checklistTrnxListDel = new Set<Checklist__c> ();
         if (AllDocList != null && AllDocList.size() > 0)
          {
             
                   for (Deviation_Master__c dev: allDevMasterList)
                   {
                       for(Checklist__c chk:checklistTrnxList)
                       {
                           if(chk.Deviation_Master__c!=null && chk.Deviation_Master__c == dev.id && chk.Sales_Status__c=='Received')
                           {
                          checklistTrnxListNotDel.add(chk);
                           }
                       }
                   }
               
           }
           /*SAL 2.0 checklist CR s*/
            if(salMobilityFlag != null && salMobilityFlag == true){
                for(Checklist__c chk:checklistTrnxList)
                {
                    if(chk.DocumentFmlyName__c !=null && chk.Deviation_Master__c == null && chk.Sales_Status__c=='Received')
                    {
                        checklistTrnxListNotDel.add(chk);
                    }
                }
            }
            /*SAL 2.0 checklist CR e*/
           for(Checklist__c ch1:checklistTrnxList)
           {
           if(!checklistTrnxListNotDel.contains(ch1))checklistTrnxListDel.add(ch1);
           }
           mapofchecklist.put('DeletedChk',checklistTrnxListDel);
           mapofchecklist.put('NotDeletedChk',checklistTrnxListNotDel);
             system.debug('checklistTrnxListDelete commmon===>'+checklistTrnxListDel);
          system.debug('checklistTrnxListNotDelete commmon===>'+checklistTrnxListNotDel);
           return mapofchecklist;
}
 //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal end

    /**
     * Method to stamp credit hierarchy while loan conversion
     * Bug id : 13016 - New Role Creation for Credit, added by Needhi 
     */
    public static Opportunity stampCreditHierarchy(
        List<Credit_Officer_Limit__c> objCreditList,
        String submitTo,
        List<Product_Offerings__c> productOfferObj,
        boolean COLStampFlag,
        Opportunity oppObj
    ){
        List<Credit_Officer_Limit__c> updateCreditList = new List<Credit_Officer_Limit__c>();
        if (submitTo == Label.Pool_User) { // Bug Id : 18159
            ControlRecursiveCallofTrigger_Util.setAlreadyExecutedLoanApproverBU();
            oppObj.CM__c = null; oppObj.ACM__c = null; oppObj.RCM__c = null; oppObj.CEO__c = null; oppObj.SCO__c = null; oppObj.COO__c = null; oppObj.NCM__c = null; oppObj.City_Head__c=null; oppObj.Business_Head__c=null;
            return oppObj;
        }
        for (Credit_Officer_Limit__c objcredit: objCreditList) {
            system.debug('objcredit.Credit_Officer_Name__r.id--'+objcredit.Credit_Officer_Name__r.id +'submitTo--'+submitTo);
            if (objcredit.Credit_Officer_Name__r.id == submitTo && objcredit.Designation__c == 'Credit Manager') { 
                system.debug('inside CM' + COLStampFlag + '  flag is===>' + productOfferObj[0].Program_Type__c);
                if (COLStampFlag == true && productOfferObj[0].Program_Type__c == 'Pre-Approved')
                oppObj.CM_Amount__c = objcredit.Pre_Approved_Amount__c;
                else
                oppObj.CM_Amount__c = objcredit.Loan_Amount__c;
                oppObj.Approver__c = objcredit.Designation__c;
                oppObj.CM__c = submitTo;
                objcredit.IsAssigned__c = true;
                updateCreditList.add(objcredit);
            } else if (objcredit.Credit_Officer_Name__r.id == submitTo && objcredit.Designation__c == 'Area Credit Manager') { 
                system.debug('inside ACM' + COLStampFlag + '  flag is===>' + productOfferObj[0].Program_Type__c);
                if (COLStampFlag == true && productOfferObj[0].Program_Type__c == 'Pre-Approved')
                oppObj.ACM_Amount__c = objcredit.Pre_Approved_Amount__c;
                else
                oppObj.ACM_Amount__c = objcredit.Loan_Amount__c;
                oppObj.Approver__c = objcredit.Designation__c;
                oppObj.ACM__c = submitTo;
                objcredit.IsAssigned__c = true;
                updateCreditList.add(objcredit);
            } else if (objcredit.Credit_Officer_Name__r.id == submitTo && objcredit.Designation__c == 'Regional Credit Manager') {
                if (COLStampFlag == true && productOfferObj[0].Program_Type__c == 'Pre-Approved')
                oppObj.RCM_Amount__c = objcredit.Pre_Approved_Amount__c;
                else
                oppObj.RCM_Amount__c = objcredit.Loan_Amount__c;
                oppObj.Approver__c = objcredit.Designation__c;
                oppObj.RCM__c = submitTo;
            } else if (objcredit.Credit_Officer_Name__r.id == submitTo && objcredit.Designation__c == 'Zonal Credit Manager') {
                if (COLStampFlag == true && productOfferObj[0].Program_Type__c == 'Pre-Approved')
                oppObj.ZCM_Amount__c = objcredit.Pre_Approved_Amount__c;
                else
                oppObj.ZCM_Amount__c = objcredit.Loan_Amount__c;
                oppObj.Approver__c = objcredit.Designation__c;
                oppObj.CEO__c = submitTo;
            } else if (objcredit.Credit_Officer_Name__r.id == submitTo && objcredit.Designation__c == 'National Credit Manager') {
                if (COLStampFlag == true && productOfferObj[0].Program_Type__c == 'Pre-Approved')
                oppObj.NCM_Amount__c = objcredit.Pre_Approved_Amount__c;
                else
                oppObj.NCM_Amount__c = objcredit.Loan_Amount__c;
                oppObj.Approver__c = objcredit.Designation__c;
                oppObj.NCM__c = submitTo;
            } else if (objcredit.Credit_Officer_Name__r.id == submitTo && objcredit.Designation__c == 'Senior Credit Officer') {
                if (COLStampFlag == true && productOfferObj[0].Program_Type__c == 'Pre-Approved')
                oppObj.SCO_Amount__c = objcredit.Pre_Approved_Amount__c;
                else
                oppObj.SCO_Amount__c = objcredit.Loan_Amount__c;
                oppObj.Approver__c = objcredit.Designation__c;
                oppObj.SCO__c = submitTo;
            } else if (objcredit.Credit_Officer_Name__r.id == submitTo && objcredit.Designation__c == 'Business Head') {
                if (COLStampFlag == true && productOfferObj[0].Program_Type__c == 'Pre-Approved')
                oppObj.Business_Head_Amount__c = objcredit.Pre_Approved_Amount__c;
                else
                oppObj.Business_Head_Amount__c = objcredit.Loan_Amount__c;
                oppObj.Approver__c = objcredit.Designation__c;
                oppObj.Business_Head__c = submitTo;
            } else if (objcredit.Credit_Officer_Name__r.id == submitTo && objcredit.Designation__c == 'City Head') {
                if (COLStampFlag == true && productOfferObj[0].Program_Type__c == 'Pre-Approved')
                oppObj.City_Head_Amount__c = objcredit.Pre_Approved_Amount__c;
                else
                oppObj.City_Head_Amount__c = objcredit.Loan_Amount__c;
                oppObj.Approver__c = objcredit.Designation__c;
                oppObj.City_Head__c = submitTo;
            } else if (objcredit.Credit_Officer_Name__r.id == submitTo && objcredit.Designation__c == 'Chief-Credit & Operations') {
                if (COLStampFlag == true && productOfferObj[0].Program_Type__c == 'Pre-Approved')
                oppObj.COO_Amount__c = objcredit.Pre_Approved_Amount__c;
                else
                oppObj.COO_Amount__c = objcredit.Loan_Amount__c;
                oppObj.Approver__c = objcredit.Designation__c;
                oppObj.COO__c = submitTo;
            } else if (objcredit.Credit_Officer_Name__r.id == submitTo && objcredit.Designation__c == 'Chief Risk Officer') {
                if (COLStampFlag == true && productOfferObj[0].Program_Type__c == 'Pre-Approved')
                oppObj.CRO_Amount__c = objcredit.Pre_Approved_Amount__c;
                else
                oppObj.CRO_Amount__c = objcredit.Loan_Amount__c;
                oppObj.Approver__c = objcredit.Designation__c;
                oppObj.CRO__c = submitTo;
            } else if (objcredit.Credit_Officer_Name__r.id == submitTo && objcredit.Designation__c == 'Centralized ACM') {
                if (COLStampFlag == true && productOfferObj[0].Program_Type__c == 'Pre-Approved')
                oppObj.Centralized_ACM_Amount__c = objcredit.Pre_Approved_Amount__c;
                else
                oppObj.Centralized_ACM_Amount__c = objcredit.Loan_Amount__c;
                oppObj.Approver__c = objcredit.Designation__c;
                oppObj.Centralized_ACM__c = submitTo;
            } else if (objcredit.Credit_Officer_Name__r.id == submitTo && objcredit.Designation__c == 'Centralized RCM') {
                if (COLStampFlag == true && productOfferObj[0].Program_Type__c == 'Pre-Approved')
                oppObj.Centralized_RCM_Amount__c = objcredit.Pre_Approved_Amount__c;
                else
                oppObj.Centralized_RCM_Amount__c = objcredit.Loan_Amount__c;
                oppObj.Approver__c = objcredit.Designation__c;
                oppObj.Centralized_RCM__c = submitTo;
            } else if (objcredit.Credit_Officer_Name__r.id == submitTo && objcredit.Designation__c == 'National Risk Manager') {
                if (COLStampFlag == true && productOfferObj[0].Program_Type__c == 'Pre-Approved')
                oppObj.RISK_Amount__c = objcredit.Pre_Approved_Amount__c;
                else
                oppObj.RISK_Amount__c = objcredit.Loan_Amount__c;
                oppObj.Approver__c = objcredit.Designation__c;
                oppObj.RISK__c = submitTo;
            } else if (objcredit.Credit_Officer_Name__r.id == submitTo && objcredit.Designation__c == 'President') {
                if (COLStampFlag == true && productOfferObj[0].Program_Type__c == 'Pre-Approved')
                oppObj.President_Approval_Amount__c = objcredit.Pre_Approved_Amount__c;
                else
                oppObj.President_Approval_Amount__c = objcredit.Loan_Amount__c;
                oppObj.Approver__c = objcredit.Designation__c;
                oppObj.President__c = submitTo;
            }
        } // for loop
        if (updateCreditList.size() > 0) update updateCreditList;
        return oppObj;
    }
    // Bug id : 13016 - New Role Creation for Credit, added by Needhi 
    
    // Start of Insurance HTS Calculator changes
    public static String getStaticResource(Map<String, Object> ParamsMap) {
        String body, resourceName, path;
        if(ParamsMap != null) {
            if(ParamsMap.containsKey('resourceName')) {
                resourceName = (String)ParamsMap.get('resourceName');
            }
            if(ParamsMap.containsKey('path')) {
                path = (String)ParamsMap.get('path');
            }
            
            try {
                List <StaticResource> srList = [SELECT Id, NamespacePrefix, SystemModstamp FROM StaticResource WHERE Name =: resourceName LIMIT 1];
                if(srList != null && srList.size() > 0) {
                    String prefix = srList[0].NamespacePrefix;
                    if(String.isEmpty(prefix)) {
                        prefix = '';
                    } else {
                        // If has NamespacePrefix
                        prefix += '__';
                    }
                    
                    String srPath = '/resource/' + srList[0].SystemModstamp.getTime() + '/' + prefix + path;
                    
                    system.debug('srPath --> ' + srPath);
                    if(Test.isRunningTest()) {
                        // Only for test classes
                        if(resourceName == 'APITagToFieldMapping') {
                            if(srPath != null) {
                                if(srPath.contains('BureauWatchAPIMapping')) {
                                  body = '{"productCategory":"Sub_Category2_Loan__c","otherLoanDetails":"Other_Loan_Details__c","lenderName":"Lender_Name__c","amount":"Loan_Amount__c","Overdue amount":"OverDue_Amount__c","outstandingAmount":"Outstanding_Amount__c","emi":"EMI__c","source":"Source__c","status":"Status__c","dateofbirth":"Follow_up_Date__c","loanStartDate":"Loan_Start_Date__c","loanEndDate":"Loan_End_Date__c"}';    
                                }
                                else if(srPath.contains('LeadAPIMapping')){
                                    body = '{"CustomerID":"Customer_ID__c","FirstName":"FirstName","LastName":"LastName","CompanyName":"Company","Mobile":"Customer_Mobile__c","CustomerAddress1":"Residence_Address_Line1__c","CustomerAddress2":"Residence_Address_Line2__c","CustomerAddress3":"Residence_Address_Line3__c","ResiState":"Resi_State__c","DateOfBirth":"Date_of_birth__c","Email":"Customer_Email_Id__c","CustomerType":"Customer_Type__c","RegiCity":"Resi_City__c","ResiPinCode":"Resi_Pin_Code__c"}';
                                }
                                else if(srPath.contains('POAPIMapping')){
                                    body = '{"UniqueID":"Offer_ID__c","CustomerID":"Customer_ID__c","CustomerFirstName":"FirstName__c","CustomerLastName":"LastName__c","ProductName":"Products__c","EnquiryProduct":"Enquiry_product__c","OfferDate":"Offer_Date__c","FDScheme":"Area__c","ProductPrice":"Offer_Amount__c","CustomerMobile":"Customer_Mobile_for_Identification__c","DealerContactNumber":"Office_Phone__c","Email":"Customer_E_mail__c","GrossTenor":"Tenor__c","ECSLimit":"Open_Ecs_Limit__c","EndUse":"End_use__c","ProductURL":"Quality_Remarks__c","DealerName":"Company_Name__c","DealerContactName":"Contact_person_name__c","EMI":"EMI_Amount__c","DownPayment":"Amount_Picked__c","PF":"Offer_PF__c","SchemeType":"Scheme_Name__c","SchemeSubType":"Processing_Type__c","ProductPrice":"Accepted_Premium_Amount__c","Source":"Lead_source__c","TelecallingStatus":"UTM_Source__c","ProductAttribute1":"Product_details__c","ProductAttribute2":"End_use__c","InitiatedBy":"Last_Updation_Done_By__c","Remarks":"Card_Field_Remarks__c","OrderID":"Nominator_ID__c"}';
                                }   // commented for HPRO - 17470  movement
                            }
                        } else 
                            if(resourceName == 'HTS_Calculator_WADL_Resource') {
                              body = '{"dob":"1986-07-24","uniqueID":"5220444659727","planOption":"","businessPricing":"","memberCovers":["abc","xyz","pqr"],"sumInsuredAssured":5000000,"policyTenure":1,"criticalIllness":"Y","age":0,"insuranceName":"PERSONAL ACCIDENT"}';    
                            }
                    } else {
                        PageReference pg = new PageReference(srPath);
                        body = pg.getContent().toString();  
                    }
                }
            } catch (Exception e) {
                system.debug('Exception --> ' + e + ' at line --> ' + e.getLineNumber());
            }   
        }
        return body;
    }
    
    public static Object createObject(Object obj, String type) {
        
        if(obj == null) {
            return null;
        }
        if(type == 'String') {
            return String.valueOf(obj);
        }
        if(type == 'Integer') {
            return Integer.valueOf(obj);
        }  
        if(type == 'Double') {
            return Double.valueOf(obj);
        } 
        if(type == 'Boolean') {
            return Boolean.valueOf(obj);
        } 
        if(type == 'Date') {
            return Date.valueOf(obj);
        }
        if(type == 'Datetime') {
            return Datetime.valueOf(obj);
        }
        return obj; 
    }
    
    public static String getObjectType(Object o) {
        if(o==null) 
            return '';
        if(o instanceof SObject)            
            return ((SObject)o).getSObjectType().getDescribe().getName()+''; 
        if(o instanceof Boolean)            
            return 'Boolean';
        if(o instanceof Id)                 
            return 'Id';
        if(o instanceof String)             
            return 'String';
        if(o instanceof Blob)               
            return 'Blob';
        if(o instanceof Date)               
            return 'Date';
        if(o instanceof Datetime)           
            return 'Datetime';
        if(o instanceof Time)               
            return 'Time';
        if(o instanceof String)             
            return 'String';
        if(o instanceof Integer)            
            return 'Integer';
        if(o instanceof Long)               
            return 'Long';
        if(o instanceof Decimal)            
            return 'Decimal';
        if(o instanceof Double)             
            return 'Double';
        if(o instanceof List<object>)       
            return 'List';
        return 'Object';
    }
    // End of Insurance HTS Calculator changes
    
    public static Map<String, Object> populateFields(Map<String, Object> FieldNameMap, Map<String, Object> FieldValueMap) {
        Map<String, Object> resultMap = new Map<String, Object>();
        for(String FieldName : FieldNameMap.keySet()) {
            if(FieldNameMap.get(FieldName) != null && !String.isEmpty(String.valueOf(FieldNameMap.get(FieldName))) && FieldValueMap.get(FieldName) != null && !String.isEmpty(String.valueOf(FieldValueMap.get(FieldName)))) {
                resultMap.put(String.valueOf(FieldNameMap.get(FieldName)), FieldValueMap.get(FieldName));
            }
        }
        return resultMap;
    }
        //Bug 15574 S - Flow Files - Hemant Keni
    public static void flowContentDocument(String fromId, String toFlowId){ 
    system.debug('common utility flow doc');
        try{  
            List<ContentDocumentLink> cdLinkList = new List<ContentDocumentLink>();
            cdLinkList=[select ContentDocumentId,LinkedEntityId  from ContentDocumentLink where LinkedEntityId =: fromId LIMIT 1000 FOR UPDATE ];     
            List<Id> cdID = new List<Id>();
            
            if(!isEmpty(cdLinkList)){
                List<ContentVersion> conVerListToInsert = new List<ContentVersion>();
                for(ContentDocumentLink cdlink : cdLinkList)
                    cdID.add(cdlink.ContentDocumentId);// po cdid   
                
                List<ContentVersion> conVerList = [SELECT Id, versionData, title, pathOnClient, origin FROM ContentVersion WHERE ContentDocumentId IN : cdID];
                if(!isEmpty(conVerList)){
                    for(ContentVersion conVer : conVerList){
                        ContentVersion cv = new ContentVersion();
                        cv.versionData = conVer.versionData;
                        cv.title = conVer.title;
                        cv.pathOnClient = conVer.pathOnClient;
                        cv.origin = conVer.origin;
                        conVerListToInsert.add(cv);
                    }
                    
                    insert conVerListToInsert;
                    
                    List<Id> conVerIdList = new List<Id>();
                    for(ContentVersion conVer : conVerListToInsert)
                        conVerIdList.add(conVer.Id);
                    System.debug('conVerIdList : '+ conVerIdList);
        
                    List<ContentVersion> conVerListInserted = [SELECT Id,versionData, ContentDocumentId, Title FROM ContentVersion WHERE ID IN : conVerIdList];
                    List<ContentDocumentLink> conDocLinkList = new List<ContentDocumentLink>();
                    if(!isEmpty(conVerListInserted)){
                        for(ContentVersion conVer : conVerListInserted){
                            System.debug('cv.ContentDocumentId: '+cdId );
                            ContentDocumentLink cdLnk = new ContentDocumentLink();
                            cdLnk.ContentDocumentId = conVer.ContentDocumentId ;
                            cdLnk.LinkedEntityId = toFlowId;
                            cdLnk.ShareType = 'I';
                            cdLnk.Visibility = 'AllUsers';
                            conDocLinkList.add(cdLnk);
                        }
                        insert conDocLinkList;
                    }
                     getCustomerPhoto(conVerListInserted);

                }
            }
        }catch(Exception e){
            System.debug('Exception in mobility_pro.flowContentDocument'+ e.getLinenumber());
        }
    }
      public static void getCustomerPhoto(List<ContentVersion> conVerListInserted)
    {
    //system.debug('inside getcustomerphoto');
     for(ContentVersion conVer : conVerListInserted){
         if(conVer.Title.Contains('CUSTOMER PHOTO')){
         cvSelected=conVer;
         break;}
     }
     //system.debug('inside getcustomerphoto cvSelected===>'+cvSelected);
    }
    //Bug 15574 E - Flow Files 
    //Bug 15574 S - Flow Attachments 
    public static void flowAttachments(String fromId, String toFlowId){
        try{
        system.debug('po id  '+fromId+'   opp id '+toFlowId);
            if(!isEmpty(fromId) && !isEmpty(fromId)){
                List<Attachment> AttachList = [select name,id,body from Attachment where ParentId =:fromId limit 1000];
                List<Attachment> AttachListTobeUpdated = new List<Attachment>();
                if(!isEmpty(AttachList)){
                    for(Attachment attch : AttachList){
                        Attachment att = new Attachment(name = attch.name, parentid = toFlowId );
                        att.body = attch.body ;
                        AttachListTobeUpdated.add(att);
                    }
                    if(!isEmpty(AttachListTobeUpdated)){
                        insert AttachListTobeUpdated;
                    }
                }
            }
        }Catch(Exception e){
            System.debug('Exception : '+ e.getCause()+' -> Line '+ e.getLineNumber());
        }
    }
    //addded by gopika-- adhoc 19206
    public static Boolean validateCkycOnSubmit(Opportunity opp)
    {
    system.debug('inside validateCkycOnSubmit');
    List<Applicant__c> applist;
    ID oppid= opp.id;
    applist=[Select id from Applicant__c where Loan_Application__c = : oppid AND Proof_of_Identity__c!=null AND Identity_Document_No__c!=NULL And Proof_of_Registered_Address_Submitted__c !=Null AND Proof_of_Address_Submitted_for_Permanent__c!=Null AND Contact_Name__r.Father_Spouse__c!=Null AND Contact_Name__r.Father_Spouse_Last_Name__c!=Null 
    AND Contact_Name__r.Mother_Last_Name__c!=Null AND Contact_Name__r.Mother_First_Name__c!=Null AND Contact_Name__r.Occupation_CKYC__c!=Null
    AND Contact_Name__r.Permanant_Address_Line_1__c!=Null AND Contact_Name__r.Permanant_Address_Line_2__c!=Null AND Contact_Name__r.Permanant_Address_Line_3__c!=Null
    AND Contact_Name__r.Permanent_Pin_Code__c!=Null AND Contact_Name__r.Permanant_City__c!=Null AND Contact_Name__r.Address_Line_One__c!=Null
    AND Contact_Name__r.Address_2nd_Line__c !=null  AND Contact_Name__r.Office_City__c!=NULL 
    AND Contact_Name__r.Office_Pin_Code__c!=NUll];
    system.debug('List of applicant ---- > ' + applist);
    if(applist.size()>0)
    {
    return true;
    }
    else
        return false;
    }
      //19478,19263 start
    public static string getIPTimestamp()
    {    
        String ipAddress = ApexPages.currentPage().getHeaders().get('True-Client-IP');
        // X-Salesforce-SIP has the value when no caching integration or via secure URL.
        if (ipAddress == '' || ipAddress == null) {
            ipAddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        } // get IP address when no caching (sandbox, dev, secure urls)
        if (ipAddress == '' || ipAddress == null) {
            ipAddress = ApexPages.currentPage().getHeaders().get('X-Forwarded-For');
        } // get IP address from standard header if proxy in use
        return ipAddress+'|'+String.valueof(datetime.now());
    }
    //19478,19263 end
    //method ends 
      //added for 20311 Cibil issue
    public static String dummyapplicantForCIBIL()
    {
        
       
        List<String> ApplicantName = new List<String>();
        if(!commonUtility.isempty(Label.DummyApplicant))
            ApplicantName.addAll(Label.DummyApplicant.split(';'));
             Double d = math.random() * (ApplicantName.size()-1) ;
        Integer i = d.intValue();
       system.debug('value of i---> '+i);
            if(ApplicantName.size()>0 && ApplicantName.size() < i)
              {return(ApplicantName[0]);}
        
       
        
        else{
        return(ApplicantName[i]);
        }
        
        
    }
    
    //bug id 22212 start
    public static Map<String,String> MockChargesAPIOPP(Map<String,String> ChargesRequestMap){
         Map<String,String> ResponseMap = new Map<String,String>();
            try{
            system.debug('Opp is::::::: '+ChargesRequestMap.get('DealID'));
            String LAN_No = chargesRequestMap.get('DealID');
            if(!CommonUtility.isEmpty(LAN_No)){
            Opportunity oppTemp = [select Id,Loan_Application_Number__c from Opportunity where Loan_Application_Number__c = :LAN_No];
            Fees_And_Charge__c Fees = new Fees_And_Charge__c();
            Fees.Loan_Application__c= oppTemp.id;
            Fees.Finnone_ChargeCode__c = (!CommonUtility.isEmpty(ChargesRequestMap) && !CommonUtility.isEmpty(ChargesRequestMap.get('Scheme')))? Decimal.ValueOf(ChargesRequestMap.get('Scheme')) : 0;
            Fees.Change_amount__c = 500;
            Fees.Finnone_ChargeId__c = 500284;
            Fees.Charge_Desc__c  = 'STAMP DUTY';
            insert Fees;
            
            Fees = new Fees_And_Charge__c();
            Fees.Loan_Application__c= oppTemp.id;
            Fees.Finnone_ChargeCode__c = (!CommonUtility.isEmpty(ChargesRequestMap) && !CommonUtility.isEmpty(ChargesRequestMap.get('Scheme')))? Decimal.ValueOf(ChargesRequestMap.get('Scheme')) : 0;
            Fees.Change_amount__c = 3000;
            Fees.Finnone_ChargeId__c = 500285;
            Fees.Charge_Desc__c  = 'UPFRONT CHARGES';
            insert Fees;
            
              ResponseMap.put('result','SUCCESS');
            } else{
                ResponseMap.put('result','Opp is null');
            }
            return ResponseMap;
            }
            catch(Exception e){
                ResponseMap.put('result',e.getMessage());
                return ResponseMap;
            }
    }
   //22212 stop
    
    //22362 start
     public static boolean getcheckLinePO(String custMobile,String custPAN,Date custDOB, String product){
                    Boolean linecheck = false;
                    Boolean prodcheck=false;
                    List<String> LineCheckProds = new List<String>();
                    Map<String,Object> checkLineRes = (Map<String,Object>)json.deserializeuntyped(CommonUtility.getStaticResourceData('SalariedCustomSettings','LineCheck','BFL_PRIME'));
                    if(checkLineRes != null){
                        LineCheckProds = String.valueOf(checkLineRes.get('Products')).split(';');
                        linecheck = ((String)checkLineRes.get('Flag') == 'True' || (String)checkLineRes.get('Flag') == 'true')?true:false;
                    }
                      if(LineCheckProds != null && LineCheckProds.size() > 0 && LineCheckProds.contains(product) && linecheck ){
           
                        return CommonUtility.isPOlineavailable(custMobile,custPAN,custDOB,product);
                       
                    }
                    else
                        return false;
   }
    public static string getformattedPhone(String mobile){
   if(!CommonUtility.isEmpty(mobile))
    mobile = '(' + mobile.substring(0, 3) + ') ' + mobile.substring(3, 6) + '-' + mobile.substring(6);
    
    return mobile;
   }
  public static boolean isPOlineavailable(String custMobile,String custPAN,Date custDOB,String product){

                    system.debug('inside here');
                    system.debug('custmobile:::::'+custMobile);
                    system.debug('custPAN:::::::'+custPAN);
                    //system.debug('DOB::::'+newAcc.Date_Of_Birth__c);
                        String formattedMob;
                        //Date FormattedDOB = date.newinstance(newAcc.Date_of_Birth__c.year(), newAcc.Date_of_Birth__c.month(), newAcc.Date_of_Birth__c.day());
                        formattedMob = CommonUtility.getformattedPhone(custMobile);
                        system.debug('formattedMob:::::::'+formattedMob);
                        //system.debug('formattedDOB:::::::'+FormattedDOB);
                        List<Lead> leadList = [SELECT (SELECT Id,New_line_assigned__c,Products__c FROM Product_Offerings__r WHERE New_line_assigned__c = true AND Product_Offering_Converted__c = false AND Data_Mart_Status__c = 'LIVE' AND Products__c =:product),id, PAN__c,DOB__c, Customer_Mobile__c FROM Lead WHERE (PAN__c =: custPAN AND DOB__c =: custDOB) OR (PAN__c =: custPAN AND (Customer_Mobile__c =: formattedMob OR Customer_Mobile__c =: custMobile)) OR (DOB__c =: custDOB AND (Customer_Mobile__c =: formattedMob OR Customer_Mobile__c =: custMobile))];
                        if(leadList != null && leadlist.size()>0){
                            for(Lead leadObj : leadList){
                                if(leadObj.Product_Offerings__r != null && leadObj.Product_Offerings__r.size()>0){
                                    
                                            return true;
                                         
                                        }
                                    }
                        
                                }
                        

                    return false;
   }
   /*20939 s*/
   public static Map<String,Object> getMapFromStaticResource(String resourceName,String mapName)
    {
        try{
                        
        String result;
            Map<String,Object> ALLMap = new Map<String,Object>();
            Map<String,Object> selectedMap = new Map<String,String>();
         
        if(!CommonUtility.isEmpty(resourceName) && !CommonUtility.isEmpty(mapName))
        {
            StaticResource staticresc;
            String SaveAttachmentTo;
           String jsnBody;
                    staticresc = [SELECT Body,Id,Name FROM StaticResource WHERE Name =: resourceName LIMIT 1]; 
            if(staticresc != null)
                jsnBody = staticresc.Body.toString();
            ALLMap = (Map<String,Object>)JSON.deserializeUnTyped(jsnBody);
                        
            selectedMap=(Map<String,Object>) ALLMap.get(mapName);
                    }
        return selectedMap;
        }catch(Exception e){System.debug('Exception  '+e.getLineNumber() +e.getMessage());}
        return null;
   }
    /*20939 e*/
   
/*Added by swapnil for Sprint 6 23064 s*/
     
    
     public static HttpResponse callExotelAPIDND(String sid, String token,String endpoint, String numbers){
         Map<String,String> result =new Map<String,String> ();
         if(sid != null && token !=null && numbers != null){
             HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            //https://<your_sid>:<your_token>@api.exotel.com/v1/Accounts/<your_sid>/Numbers/~number~
            endpoint = endpoint+numbers;
            endpoint = endpoint.replace('exotel_sid', sid);
            endpoint = endpoint.replace('exotel_token', token);
            req.setEndpoint(endpoint);
            System.debug('Endpoint :'+endpoint);

            req.setMethod('GET');
            req.setHeader('Authorization','Basic '+Encodingutil.Base64Encode(Blob.valueOf(sid+':'+token)));
            if(!Test.isRunningTest())
            res = http.send(req);
             System.debug('Result is '+res.getBody());
           if(!CommonUtility.isEmpty(res))
               return res;
             
         }
         return null;
    }
    
    public static map<String,String> handleDNDResponse(HttpResponse res){
        System.debug(' DND response is '+res.getBody());
         DOM.Document doc = res.getBodyDocument();
        Map<String,String> result =new Map<String,String> ();
        
        for(Dom.XmlNode respNode: doc.getRootElement().getChildElements()) {
            for(Dom.XmlNode respChildNode: respNode.getChildElements()) {
                if(respChildNode.getName().equalsIgnoreCase('DND')) {
                    System.debug('found identifiers are  '+respChildNode.getName());
                    result.put(respChildNode.getName(),respChildNode.getText());
                }
            }
        }
        
        if(!CommonUtility.isEmpty(result)){
            return  result;
        }
        return null;
    }

    public static String callToCustomer (String frommobile,String tomobile,sObject curObj,String Product){
      Map<String,Object> allMap= (Map<String,Object>) CommonUtility.getMapFromStaticResource('SalariedCustomSettings','ExotelAPIForDetails');
       
        String objeApiName=curObj.getSObjectType().getDescribe().getName();
        System.debug('Controller ***  frommobile '+frommobile+' tomobile '+tomobile+' Id '+curObj.Id+' objName '+objeApiName);
        
        
        System.debug('allMap '+allMap);
        Map<String,Object> objMap=(Map<String,Object>) allMap.get(objeApiName.trim());
        List<String> objFields=String.valueOf(objMap.get('FieldList')).split(';');
        List<String> UserMobileField =String.valueOf(objMap.get('UserMobileField')).split(';');
        list<String> respFieldsFirst= String.valueOf(objMap.get('responseIdentifierFirstCall')).split(';');
        list<String> respFieldsSecond= String.valueOf(objMap.get('responseIdentifierSecondCall')).split(';');
        list<String> DateTimeField=String.valueOf(objMap.get('DateTimeField')).split(';');
        String DNCFlag=String.valueOf(objMap.get('DNCActive'));//adhoc 24677 
        System.debug('DNCFlag '+DNCFlag);
        Map<String,String> result =new Map<String,String> ();
        
         if(!Test.isRunningTest() && !CommonUtility.isEmpty(tomobile) && !CommonUtility.isEmpty(allMap.get('token')) && !CommonUtility.isEmpty(allMap.get('SID'))){
            HttpResponse response = CommonUtility.callExotelAPIDND(allMap.get('SID').toString(), allMap.get('token').toString(),allMap.get('endpointDNC').toString(),tomobile);
            if(!CommonUtility.isEmpty(response)){
                 result=CommonUtility.handleDNDResponse(response);
              
                if(result.get('DND').equalsIgnoreCase('YES') && DNCFlag=='true'){ //adhoc 24677 
                    System.debug('DNC is active');
                    return 'DNC is activated for the Customer';
                }
            }
              
         }
        
        boolean prodMatch=false;
        String CallerId='';
        if(!CommonUtility.isEmpty(Product))
        {
            Map<String,Object> ExotelProducts= (Map<String,Object>) allMap.get('ExotelProducts');
            for(String obj :ExotelProducts.keySet()){
                System.debug('Active is '+((Map<String,Object>)ExotelProducts.get(obj)).get('Active'));
                String res=(String)((Map<String,Object>)ExotelProducts.get(obj)).get('Active');
                if(res=='true' && obj.equalsIgnoreCase(Product)){
                    prodMatch=true;
                    CallerId=(String)((Map<String,Object>)ExotelProducts.get(obj)).get('callerID');
                }
            }  
            
        }else
             return 'Product missing';
        
        if(!prodMatch){
            return 'Exotel is not valid for this product';
        }
        
        
      
        String query='';  
        System.debug(' frommobile 1'+frommobile);             
        
        //If User mobile number is not available at method call, we can find current user contact number using below logic
        if(frommobile.equalsIgnoreCase('none') || CommonUtility.isEmpty(frommobile)){
            query='SELECT ID,NAME';
            for(String field : UserMobileField){
                query=query+','+field;
            }
            String userId=System.UserInfo.getUserId();
            query=query+' from user where id =:userId';
            System.debug(' User Query '+query);
            User currentUser=Database.query(query);
            Boolean userFlag=false;
            
            for(String field : UserMobileField){
                if(!CommonUtility.isEmpty(currentUser.get(field))){
                    userFlag=true;
                    frommobile=(String)currentUser.get(field);
                    break;
                }                    
            }
            if(!userFlag){
                return 'User contact number missing';
            }
            System.debug('Flag is '+userFlag+' frommobile '+frommobile);
            
        }//Current user logic finish
        //Below logic is to fetch required details from Sobject to update response from first call to Exotel API
        
        query='SELECT ID,NAME ';
        
        for(String field :objFields ){
            query=query+', '+field;
        }
        String objId=curObj.Id;
        query=query+' from '+objeApiName+' where id =:objId';
        
        System.debug(' First Call Query '+query);
        curObj=Database.query(query);
        if(CommonUtility.isEmpty(curObj)){
            return 'Record not found for '+curObj;
        }
        try{
            frommobile=frommobile.replaceAll('[-+.^:,//( //)]',''); 
            tomobile=tomobile.replaceAll('[-+.^:,//( //)]','');
            
            System.debug('Call recording callback frommobile '+frommobile+' tomobile '+tomobile+' Id '+curObj.Id+' token '+allMap.get('token'));
             System.debug('CallerID '+CallerId+ 'Product '+Product+' SID '+allMap.get('SID'));
            HttpResponse res = new HttpResponse();
            if(!Test.isRunningTest() && !CommonUtility.isEmpty(frommobile) && !CommonUtility.isEmpty(tomobile) && !CommonUtility.isEmpty(allMap.get('token')) && !CommonUtility.isEmpty(allMap.get('SID')) && !CommonUtility.isEmpty(CallerId) )
                res=CommonUtility.callExotelAPI(allMap.get('SID').toString(), allMap.get('token').toString(), CallerId.trim(), frommobile.trim() , tomobile.trim());
            else if(Test.isRunningTest()){
               String testResponse='<?xml version="1.0" encoding="UTF-8"?><TwilioResponse> <Call>  <Sid>6fcf6899ac7f33ae4745a01d1aacd8f4</Sid>  <ParentCallSid></ParentCallSid>  <DateCreated>2019-02-18 11:25:43</DateCreated>  <DateUpdated>2019-02-18 11:26:21</DateUpdated>  <AccountSid>bajajfinserv9</AccountSid>  <To>07020069707</To>  <From>09689929596</From>  <PhoneNumberSid>02071171810</PhoneNumberSid>  <Status>failed</Status>  <StartTime>2019-02-18 11:25:43</StartTime>  <EndTime>2019-02-18 11:26:09</EndTime>  <Duration>25</Duration>  <Price>0.21</Price>  <Direction>outbound-api</Direction>  <AnsweredBy>human</AnsweredBy>  <ForwardedFrom></ForwardedFrom>  <CallerName></CallerName>  <Uri>/v1/Accounts/bajajfinserv9/Calls/6fcf6899ac7f33ae4745a01d1aacd8f4</Uri>  <RecordingUrl></RecordingUrl> </Call></TwilioResponse>' ; 
               res.setBody(testResponse);
            }else{
                System.debug('Incorrect details');
                return 'Can not make a call : Missing required data';
            }
            
            list<String> identifiers=new list<String>();
            
            for(String val: respFieldsFirst){
                system.debug('val is'+val);
                list<String> str=val.split('#');
                System.debug('str '+str.size());
                identifiers.add(str[0]);
            }
            
            System.debug(' response is '+res);
            result=getResult(res,identifiers);
            
            if(!CommonUtility.isEmpty(result)){
                for(String val : respFieldsFirst){
                    list<String> str=val.split('#');
                    if(DateTimeField.contains(str[1])){
                        curObj.put(str[1],Datetime.valueOf(result.get(str[0])));
                    }else if(String.valueOf(str[0]).equalsIgnoreCase('Sid')){ 
                        if(!CommonUtility.isEmpty(curObj.get(str[1]))){
                            String sidApp=curObj.get(str[1])+';'+result.get(str[0]);
                            curObj.put(str[1],sidApp);
                        }else{
                            curObj.put(str[1],result.get(str[0]));
                        }
                    }else
                        curObj.put(str[1],result.get(str[0]));
                }  
                upsert curObj;
                return 'Success';
            }
            
           
        }catch(Exception e){
            System.debug(' Exception in calling customer '+e.getMessage()+' on line '+e.getLineNumber());
            return e.getMessage()+'';
        }
         return 'Failed';
    }
    
    public static Map<String,String> getResult(HttpResponse res,list<String> identifiers){
        DOM.Document doc = res.getBodyDocument();
        Map<String,String> result =new Map<String,String> ();
     
            for(Dom.XmlNode respNode: doc.getRootElement().getChildElements()) {
                for(Dom.XmlNode respChildNode: respNode.getChildElements()) {
                    if(identifiers.contains(respChildNode.getName())) {
                        System.debug('found identifiers are  '+respChildNode.getName());
                        result.put(respChildNode.getName(),respChildNode.getText());
                    }
                }
            }
     
        if(!CommonUtility.isEmpty(result)){
            return  result;
        }
        return null;
        
    }
    
    public static String callToCustomerCallback(sObject curObj){
         String objeApiName=curObj.getSObjectType().getDescribe().getName();
      
        Map<String,Object> allMap= (Map<String,Object>) CommonUtility.getMapFromStaticResource('SalariedCustomSettings','ExotelAPIForDetails');
        Map<String,Object> objMap=(Map<String,Object>) allMap.get(objeApiName.trim());
        List<String> objFields=String.valueOf(objMap.get('FieldList')).split(';');
        List<String> UserMobileField =String.valueOf(objMap.get('UserMobileField')).split(';');
        list<String> respFieldsFirst= String.valueOf(objMap.get('responseIdentifierFirstCall')).split(';');
        list<String> respFieldsSecond= String.valueOf(objMap.get('responseIdentifierSecondCall')).split(';');
        list<String> DateTimeField=String.valueOf(objMap.get('DateTimeField')).split(';');
        Map<String,String> result =new Map<String,String> ();
        String respSid='';
      
        
        try{
            // Map<String,Object> allMap1= (Map<String,Object>) CommonUtility.getMapFromStaticResource('SalariedCustomSettings','ExotelAPIForDetails');
            if(!CommonUtility.isEmpty(curObj)){
                
                String query='SELECT ID,NAME ';
                
                for(String field :objFields ){
                    query=query+', '+field;
                }
                String objId=curObj.Id;
                query=query+' from '+objeApiName+' where id =:objId';
                
               // System.debug(' second call Query '+query);
                curObj=Database.query(query);
                if(CommonUtility.isEmpty(curObj)){
                    return 'Record not found for '+objeApiName;
                }
                
                for(String val : respFieldsFirst){
                    list<String> str=val.split('#');
                    if(str[0].equalsIgnoreCase('Sid')){
                        list<String> sidList=String.valueOf(curObj.get(str[1])).split(';');
                        if(!CommonUtility.isEmpty(sidList) && sidList.size()>0)
                            respSid=sidList[sidList.size()-1];
                        else
                            respSid=(String)curObj.get(str[1]);
                    }
                }  
                
                
                HttpResponse resp = new HttpResponse();
               // System.debug('respSid '+respSid);
                resp=CommonUtility.callExotelAPIForDetails(allMap.get('SID').toString(), allMap.get('token').toString(), respSid.trim());
                System.debug('resp '+resp.getBody());
                if(!CommonUtility.isEmpty(resp)){
                    list<String> identifiers=new list<String>();
                    
                    for(String val: respFieldsSecond){
                        system.debug('val is'+val);
                        list<String> str=val.split('#');
                     
                        identifiers.add(str[0]);
                    }
                    result=getResult(resp,identifiers);
                }
                
                if(!CommonUtility.isEmpty(result)){
                   
                        for(String val : respFieldsSecond){
                            list<String> str=val.split('#');
                            if(DateTimeField.contains(str[1])){
                                curObj.put(str[1],Datetime.valueOf(result.get(str[0])));
                            }else if(String.valueOf(str[0]).equalsIgnoreCase('response')){  
                                curObj.put(str[1],resp.getBody());
                            }else if(String.valueOf(str[0]).equalsIgnoreCase('RecordingUrl')){
                                if(result.get('Status').equalsIgnoreCase('completed') )
                                    curObj.put(str[1],result.get(str[0]));
                            }else
                                curObj.put(str[1],result.get(str[0]));
                        }  
                   
                    
                    upsert curObj;
                    return 'Success';
                }
            } else
            {
                System.debug('respSid '+respSid+' Id '+curObj.Id);
                return 'Incorrect data';
            }    
            
        }catch(Exception e){
            System.debug(' Exception '+e.getMessage()+' on line '+e.getLineNumber());
            
        } 
        return 'null';
    }    
   
    public static HttpResponse callExotelAPI(String sid, String token, String callerID, String fromNumber, String toNumber){
        if(sid != null && token !=null && callerID != null && fromNumber != null && toNumber != null){
            try{
                 Map<String,Object> allMap= (Map<String,Object>) CommonUtility.getMapFromStaticResource('SalariedCustomSettings','ExotelAPIForDetails');
                HttpRequest req = new HttpRequest();
                HttpResponse res = new HttpResponse();
                Http http = new Http();
                
                String endpoint = (String) allMap.get('endpoint')+'connect';//system.Label.CC_Exotel_API + 'connect';
                endpoint = endpoint.replace('exotel_sid', sid);
                endpoint = endpoint.replace('exotel_token', token);

                req.setEndpoint(endpoint);
                System.debug('Endpoint :'+endpoint);

                req.setMethod('POST');
                req.setHeader('Content-Type','application/x-www-form-urlencoded');
                req.setHeader('Authorization','Basic '+Encodingutil.Base64Encode(Blob.valueOf(sid+':'+token)));

                if(fromNumber.length() == 12) fromNumber ='0'+fromNumber.subString(2);
                if(toNumber.length() == 12) toNumber = '0'+toNumber.subString(2);

                String body = 'From='+fromNumber+'&To='+toNumber+'&CallerId='+callerID;
                req.setBody(body);
                System.debug('Request is :'+body);
                res = http.send(req);
                System.debug('Response is '+res.getBody());
                return res;
            }catch(Exception e){
                
            }
        }
        return null;
    }
  
  
public static HttpResponse callExotelAPIForDetails(String sid, String token, String callSID){
         if(sid != null && token !=null && callSID != null){
              Map<String,Object> allMap= (Map<String,Object>) CommonUtility.getMapFromStaticResource('SalariedCustomSettings','ExotelAPIForDetails');
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
         
            String endpoint = (String) allMap.get('endpoint')+callSID;
            endpoint = endpoint.replace('exotel_sid', sid);
            endpoint = endpoint.replace('exotel_token', token);
            req.setEndpoint(endpoint);
            System.debug('Endpoint :'+endpoint);

            req.setMethod('GET');
            req.setHeader('Authorization','Basic '+Encodingutil.Base64Encode(Blob.valueOf(sid+':'+token)));
            res = http.send(req);
             System.debug('Response is '+res);
            return res;
         }
         return null;
    }
    
    /*Added by swapnil for Sprint 6 23064 e*/
  
}