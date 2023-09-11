/**

* File Name: SendFinnOne

* Description: This Apex Class is used to Create Finnone Report records fetching data from
contacts,opportunity,property details



@ 2.0 SALT2C this is for new process when QDP flag is set true in Opportunity  (refer method QDP() )

* Copyright : Wipro Technologies Limited Copyright (c) 2011 *

* @author : Wipro

* Modification Log

* ===============================================================

* Ver   Date        Author      Modification

* --- ---- ------ ------------- ---------------------------------

* 1.0   06-Apr-11   Ahilesh        Created
* 2.0   22-june-12  Murali Krishna Modified

*/
public class SendFinnOne {
    /* bug 17556 s*/
    public static String loanIdforMob {
        get;
        set;
    }
    public boolean salmobilityv2flag {
        get;
        set;
    }
    public String mobilitystatus {
        get;
        set;
    }
    /*bug 17556 e*/
    //Re-engineering
    SurrogateCAM__C Scam;
    static boolean InsurancesmsSent; //bug-12479-Anjali
    public Opportunity Loan;
    Id LoanId;
    List < Applicant__c > apps = new List < Applicant__c > ();
    List < Property_Details__c > properties = new List < Property_Details__c > ();
    List < Verification__c > verificationRec = new List < Verification__c > ();
    List < checklist__c > checklistdocs = new List < checklist__c > ();
    List < checklist__c > propertyDocumentsforPrimapp = new List < checklist__c > ();
    public List < DPLinsurance__c > ListDPLinsurance = new List < DPLinsurance__c > ();
    
    //Added by Anjali for invisible monitoring mortgage start
    public Boolean Mortgageflag {
        get;
        set;
    }
    public Set < String > MortgageProducts = new Set < String > ();
    //Added by Anjali for invisible monitoring mortgage end
    
    public Boolean validationFlag {
        get;
        set;
    }
    //Home Loan Line Products - RHL start
    public Set < String > HLProducts = new Set < String > ();
    //rhl end
    //3371
    public Set < String > DOCProducts = new Set < String > ();
    //3367
    //Adhoc Salproduct change
    public Set < String > SALProducts = new Set < String > ();
    //
    public boolean mortgage {
        get;
        set;
    }
    // Start of Mortgage production issues 15 Nov - Point 109
    public boolean MortgageSMEProductsFlag {
        set;
        get;
    }
    // End of Mortgage production issues 15 Nov - Point 109
    //13793 S
    public List < TelePDQuestionMaster__c > TeleList = new List < TelePDQuestionMaster__c > ();
    public String agreement {
        get;
        set;
    }
    //13793 E
    List < FinnOne_Report__c > FinnoneReportListForChecklist = new List < FinnOne_Report__c > ();
    List < FinnOne_Report__c > PrimappFinnoneReport = new List < FinnOne_Report__c > ();
    List < Document_Finnone_Report__c > DocumentFinnoneReportList = new List < Document_Finnone_Report__c > ();
    List < Applicant__c > applicant11 = new List < Applicant__c > (); // For QDP
    public Boolean approvedflag;
    List < Fees_and_Charge__c > feesCharges;
    
    /* Start Enhancement :11735 : Insurance Premium Validation  */
    // start new Changes
    List < Fees_and_Charge__c > lstFeesPremVal = null;
    // end new Changes
    /* End Enhancement :11735 : Insurance Premium Validation  */
    string[] splitstr;
    String cpn;
    //7660 S
    Decimal stdCode;
    String regPhoNumStr;
    //7660 E
    //public Integer finalvalTot1{get;set;}
    //public Integer finalvalTot{get;set;}
    ID pid;
    string pLoan;
    integer totalyes = 0;
    boolean firstProcessOK = false;
    boolean sendtofinoneOK = true;
    Integer cnt = 0;
    integer processStart = 0;
    List < RePayment_mode_detail__c > repaymentmodes = new List < RePayment_mode_detail__c > ();
    List < checklist__c > AfterFilterCheclistTemp = new List < checklist__c > ();
    public boolean DocFinnoneReport = false;
    /* Code added by Varsha
Start Date :    12-01-2017
Bug id :        10,604
Description :   Foreclosure and Part payment Enhancement
*/
    /*public List < Bank_Account__c > bankAccountList {
set;
get;
}*/
    /*Foreclosure end*/
    public Boolean ErrorFlag {
        get;
        set;
    }
    //for validations
    List < Applicant__c > primaryAppList = new List < Applicant__c > ();
    public List < Current_Disbursal_Details__c > CDDList = new List < Current_Disbursal_Details__c > ();
    cam__c camAppr = new cam__c();
    HL_CAM__c hlcamAppr = new HL_CAM__c();
    
    public List < Applicant__c > coprimaryAppList = new List < Applicant__c > ();
    public List < Contact > contactlist = new List < Contact > ();
    public List < Contact > contactlist1 = new List < Contact > ();
    
    String labelLAPProducts = '';
    Set < String > LAPprods = new Set < String > ();
    public Boolean LAPproductsflowFlag {
        get;
        set;
    }
    Boolean FFRSMEProductflag;
    Set < String > FFRSMEProductList = new Set < String > ();
    
    //FAS
    Map < Id, Bank_Account__c > banlAccMap = new Map < Id, Bank_Account__c > ();
    
    //LA phase - II
    public List < SurrogateCAM__c > surrogateList = new List < SurrogateCAM__c > ();
    public List < Product_Offerings__c > proOfferList = new List < Product_Offerings__c > ();
    public Product_Offerings__c POObject {
        get;
        set;
    }
    public Boolean isExisting {
        get;
        set;
    }
    public Boolean isNew {
        get;
        set;
    }
    // Bug - 12755 - added by Asmita
    Map < String, Id > mapFinnAppl = new Map < String, Id > ();
    //LA phase - II
    //Added By Rajendra For New Product HBLS 
    public Boolean isNewProductFlowEnabled {
        get;
        set;
    }
    // start nominee validation for products changes by rohit mourya
    public List < StaticResource > srList;
    // end nominee validation for products changes by rohit mourya
    //Ended here by rajendra 
    /*BUG-16959 S*/
    public boolean isPSBLProductLineProduct {
        get;
        set;
    }
    /*BUG-16959 E*/
    //BUG ID 17470 
    public boolean isPROProductLineProduct {
        get;
        set;
    }
    //19500
    public static Decimal changeAmtsum {
        get;
        set;
    }
    //20833
    public static Boolean HFCFlag {
        get;
        set;
    }
    
    public SendFinnOne(ApexPages.StandardController controller) {
        //BUG ID 17470
        isPROProductLineProduct = false;
        salmobilityv2flag = false; //17556
        //19500
        changeAmtsum = 0;
        //20833
        HFCFlag = false;
        
        //Bug:16959
        
        isPSBLProductLineProduct = false;
        transient string ProductForFlowLabel = Label.New_Products_for_Flow;
        isNewProductFlowEnabled = false;
        /* Start Enhancement :11735 : Insurance Premium Validation  */
        // start new Changes
        feesCharges = new List < Fees_and_Charge__c > ();
        
        // end new Changes
        /* End Enhancement :11735 : Insurance Premium Validation  */
        // start nominee validation for products changes by rohit mourya
        Set < String > staticResourcesList = new Set < String > ();
        staticResourcesList.add('NomineeProducts');
        staticResourcesList.add('PremiumCharge');
        staticResourcesList.add('PropertyTypeFlowToFinnOne');
        staticResourcesList.add('AdditionalFiledsToFlowFinnoneInsuranceType');
        staticResourcesList.add('AdditionalFiledsToFlowFinnone');
        srList = [SELECT Id, Name, Body FROM StaticResource WHERE Name IN: staticResourcesList];
        // end nominee validation for products changes by rohit mourya
        
        validationFlag = false;
        MortgageSMEProductsFlag = false;
        InsurancesmsSent = true; //bug-12479-Anjali
        //LA phase - II
        isExisting = false;
        isNew = false;
        POObject = new Product_Offerings__c();
        //LA phase - II
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
        // adhoc sal change
        if (LaonApplicationCreation__c.getValues('Salaried Products finnone') != null) {
            String salProductsStr = LaonApplicationCreation__c.getValues('Salaried Products finnone').Products__c;
            if (salProductsStr != null) {
                system.debug('***salProductsStr***' + salProductsStr);
                String[] arr = salProductsStr.split(';');
                for (String str: arr) {
                    SALProducts.add(str);
                }
            }
        }
        //end
        //Home Loan Line Products - RHL start
        if (LaonApplicationCreation__c.getValues('HL Line Products') != null) {
            String HLLineProducts = LaonApplicationCreation__c.getValues('HL Line Products').Current_product__c;
            if (HLLineProducts != null) {
                system.debug('***HLLineProducts***' + HLLineProducts);
                String[] arr = HLLineProducts.split(';');
                for (String str: arr) {
                    HLProducts.add(str.toUppercase());
                }
            }
        }
        System.debug('HLProducts.size()=' + HLProducts.size() + '=HLProducts=' + HLProducts);
        //Home Loan Line Products - RHL End
        //3367
        mortgage = false;
        
        LAPproductsflowFlag = false;
        labelLAPProducts = label.LAP_Products;
        for (String s: labelLAPProducts.split(';')) {
            LAPprods.add(s.toUppercase());
        }
        //17556 added if condition
        if (System.currentPageReference() != null)
            LoanId = System.currentPageReference().getParameters().get('Id');
        else if (loanIdforMob != null) {
            LoanId = loanIdforMob;
            salmobilityv2flag = true;
        }
        this.Loan = (Opportunity) controller.getRecord();
        system.debug('DDDDDDDDDDD' + Loanid);
        // start insurance distribution changes. added leadSource in query
        if (LoanId != null) {
            //CIBIL Watch Remarks__C
            Loan = [select id,/*20939 s*/ Account.Flow__c, /*20939 e*/ /*Bug 21463 S*/ End_Use__c, /*Bug 21463 E*/ /*Prod Issue 10773 S*/ Branch_Name__r.Name, /*Prod Issue 10773 E*/ Account.Group_Type__c, Account.Office_Landline_Number1__c, Account.Accountant_email_id__c, EMI_CAM__c, Favouring__c, Scheme_Master__r.Name, Scheme_Master__r.IsHybridFlexi__c, Scheme_Master__r.is_Pure_Flexi__c, Scheme_Master__r.flexi_flag__c, IFSC_Code__c, Mode_of_Disbursal__c, A_C_No__c,
                    Referral__r.Name, createddate, product__c, Name_On_Card_ELC__c, Sent_To_Finnone__c, stagename, Application_Number__c,
                    Customer_email_id__c, MICR_Number__c, leadSource, Scheme_Master__c, QDP__c, Bank_A_c_No_of_Customer__c, Doc_Approved__c, Accountant_email_id__c,
                    ELC_charges__c, ELC_offer_accepted__c, Referral__c, Relationship_Manager__r.name, Nature_of_Business__c,
                    Sourcing_Channel__r.FinnOne_Code__c, Approved_Tenor__c, Type_Of_Loan__c, Scheme_Master__r.Active__c, EMI_Type__c,
                    Approved_time_after_Reappraisal__c, Sanction_Validity_Date__c, Application_Form_Number__c, Dispatch_time__c, File_Inward__c
                    /*CIBIL Watch start*/
                    , Remark__c, Loan_Application_Flow__c /*CIBIL Watch End*/
                    /*SAl Interest Subvention start bug id 12941*/
                    , Account.Interest_Subvention_Applicable__c, Account.Customer_Contribution__c, Account.Builder_Contribution__c, Account.Interest_Subvention_Type__c, Account.Subvention_End_Date__c, Scheme_Master__r.Discount_Rate__c /*SAl interest subvention end bug id 12941*/
                    /* bug 13560 s*/
                    , Approved_Loan_Amount__c /*bug 13560 e*/
                    /*10603 Collateral Communication*/
                    , Account.Name, Account.Email_Id__c, Account.Mobile__c, Account.Current_Email_Id__c, CPA__r.Mobile_number__c, CPA__r.Profile.Name, CPA__r.email,
                    Loan_Application_Number__c,customer_type__c, BranchName__c, Relationship_Manager__r.email, Relationship_Manager__r.Mobile_number__c, (select id, name, Applicant_Type__c, Contact_Name__c, Contact_Name__r.Name, Contact_Name__r.Mobile__c, Contact_Name__r.Email__c, Contact_Name__r.Customer_Type__c from Loan_Application__r where Applicant_Type__c = 'Primary'
                                                                                                                                                          limit 1)
                    /*10603 Collateral Communication*/
                    /*Bug 14506 - HFC Fields - SFDC*/
                    , Eligible_for_PSL__c, Account.PMAY__c, Account.EWS_LIG__c, Account.Plain_Area_Hilly_Area_flagging__c, Account.Type_of_facility__c /*Bug 14506 - HFC Fields - SFDC*/
                    /*#15333 s*/
                    , Loan_Amount_with_Premium__c /*#15333 e*/
                    /*Bug 16173 - VRPL changes for HFC Start*/
                    , Scheme_Master__r.VRPL_Flag__c /*Bug 16173 - VRPL changes for HFC End*/ , /*19500 S*/ CUSTOMER__r.Payment_received__c, (select id, Tags__c from Product_Offerings__r) /*19500 E*/ 
                    from Opportunity where id =: LoanId
                   ];
            //Account.Office_Landline_Number1__c,Account.Accountant_email_id__c added by Suraj...Audit Finnone enhancement
            /*    Code added by Varsha
Start Date :    12-01-2017
Bug id :        10,604
Description :   Foreclosure and Part payment Enhancement
*/
            /*system.debug('foreclosure loan'+LoanId);
bankAccountList = [select id, Foreclosure_Partpayment_Penalty__c, Loan_Application__c,  MOB_FROM__c, MOB_TO__c, PREPAY_PENALTY__c, FORECLOSURE_PENALTY__c, Is_delete__c
from Bank_Account__c where Loan_Application__c = : LoanId AND Foreclosure_Partpayment_Penalty__c = : 'Deviation'
for update
];
system.debug('foreclosure size'+bankAccountList.size());*/
            
            /*foreclosure end*/
            //3533
            if (Loan != null) {
                FFRSMEProductflag = false;
                //3533 FFR
                if (PD_Sheet__c.getValues('FFR') != null) {
                    String products = PD_Sheet__c.getValues('FFR').FFRSME__c;
                    if (products != null) {
                        system.debug('***FFRSMEproducts***' + products);
                        String[] arr = products.split(';');
                        for (String str: arr) {
                            FFRSMEProductList.add(str);
                        }
                        
                        system.debug('***FFRSMEproducts***' + FFRSMEProductList);
                        if (Loan.Product__c != null && FFRSMEProductList.contains(Loan.Product__c.ToUpperCase())) {
                            system.debug('***FFRSMEproducts***' + FFRSMEProductflag);
                            FFRSMEProductflag = true;
                        }
                    }
                }
                
                system.debug('***FFRSMEproducts***' + FFRSMEProductflag);
                //3533 FFR
                
                // Start of Mortgage production issues 15 Nov - Point 109
                MortgageSMEProductsFlag = false;
                if (LaonApplicationCreation__c.getValues('Mortgage SME Products') != null) {
                    
                    String MortgageSalProducts = LaonApplicationCreation__c.getValues('Mortgage SME Products').Current_product__c;
                    if (MortgageSalProducts != null) {
                        String[] arr = MortgageSalProducts.split(';');
                        for (String str: arr) {
                            if (str.equalsIgnoreCase(Loan.Product__c)) {
                                MortgageSMEProductsFlag = true;
                            }
                        }
                    }
                }
                // End of Mortgage production issues 15 Nov - Point 109
                //BUG ID 17470 -> S
                transient set < string > setPROProdName = new set < string > ();
                if (!commonUtility.isEmpty(Label.PRO_ProductLine_Products))
                    setPROProdName.addAll(Label.PRO_ProductLine_Products.split(';'));
                if (Loan.Product__c != null) {
                    isPROProductLineProduct = setPROProdName.contains(Loan.Product__c.toUpperCase());
                }
                //BUG ID 17470 -> E
                if ((Loan != null && Loan.Product__c != null && ProductForFlowLabel != null && ProductForFlowLabel != '' && ProductForFlowLabel.contains(Loan.Product__c)))
                    isNewProductFlowEnabled = true;
                /*Bug: 16959 S*/
                transient string PSBLProductLineProducts = Label.PSBL_ProductLine_Products;
                if (PSBLProductLineProducts != null && PSBLProductLineProducts != '') {
                    set < string > setPSBLProdName = new set < string > ();
                    setPSBLProdName.addAll(PSBLProductLineProducts.split(';'));
                    if (setPSBLProdName != null && setPSBLProdName.size() > 0 && Loan != null && Loan.Product__c != null)
                        if (setPSBLProdName.contains(Loan.Product__C.toUpperCase()))
                        isPSBLProductLineProduct = true;
                }
                /*Bug: 16959 E*/
            }
            
            //3367
            if (Loan != null) {
                if (Loan.product__c == 'LAP' || Loan.product__c == 'SBS CS LAP' || Loan.product__c == 'SBS CS HL' || Loan.product__c == 'Home Loan' || Loan.product__c == 'SHL') mortgage = true;
            }
            //end
            
            //Added by Anjali for invisible monitoring mortgage-start
            Mortgageflag = false;
            if (LaonApplicationCreation__c.getValues('Mortgage Products') != null) {
                
                String MortgageSalProducts = LaonApplicationCreation__c.getValues('Mortgage Products').Current_product__c;
                if (MortgageSalProducts != null) {
                    String[] arr = MortgageSalProducts.split(';');
                    for (String str: arr) {
                        if (str.equalsIgnoreCase(Loan.Product__c)) {
                            Mortgageflag = true;
                        }
                        MortgageProducts.add(str);
                    }
                }
                System.debug('MortgageProducts.size()=' + MortgageProducts.size() + '=MortgageProducts=' + MortgageProducts + 'mortgageflag' + Mortgageflag);
            }
            //Added by Anjali for invisible monitoring mortgage-end   
            
            // fetching all verification records relating to this opporutiny
            verificationRec = [select name, Status__c, /*20939 s*/ RSA_Reason__c /*20939 e*/ from Verification__c where Loan_Application__c =: Loan.id];
            
            
            system.debug('Products----->' + LAPprods);
            system.debug('selected product----->' + Loan.Product__c);
            if (LAPprods.contains(Loan.Product__c)) {
                system.debug('selected product----->' + Loan.Product__c);
                LAPproductsflowFlag = true;
            }
            //13793-s
            TeleList = [select id, ExistingLAN__c, BalanceAmount__c, DisbursementType__c,
                        CustomerName__c, ApiResponse__c, LoanApplication__c from TelePDQuestionMaster__c where LoanApplication__c =: Loan.id AND DisbursementType__c = 'Close Existing'
                       ];
            
            //13793-E
            
            //getting Current Disbursal Details
            //13793 added condition isTopUp__c
            //15580--added isCloned__c
            CDDList = [select id, Favouring__c, isCloned__c, isTopUp__c, IFSC_Code__c, Disbursal_Mode__c, Disbursement_Amount__c, Bank_Account__c, Bank_Name__c, Flexi_Adjustment__c from Current_Disbursal_Details__c where Loan_Application__c =: Loan.id and Internal_Closure__c = 'No' // Flexi_Adjustment__c added for 1643
                       and Disbursement_Number__c = '1'
                       and isTopUp__c = false /* added condition 'and isTopUp__c=false' for CR 15430 */
                       limit 5
                      ];
            
            //getting Property Details
            if (Loan != null && Loan.Product__c != 'FAS') {
                properties = [Select /*21463 S*/ Extra_Amenities_Val1__c, Property_Land_Rate_Val1__c, Basic_Rate__c, Top_Up_Percentage__c, Total_Valuation__c, Seperate_access_to_the_property__c, Construction_Rate_Val1__c, /*21463 E*/ /*Property Dedupe - Anshita S */ LinkedPropertyCode__c, Geolocation__Latitude__s, Geolocation__Longitude__s, Area_Locality__c, /*Property Dedupe - Anshita E */ id, Name, Select__C, Property_Address_Line_1__C, Property_Address_Line_2__C, Property_Address_Line_3__C, Property_City__c,
                              Property_Pin_Code__C, Property_State__C, Property_Type__C, Property_Value__c, Dealer_Master__c, Dealer_Master__r.Dealer_ID__c,
                              Type_Of_Measurement__C, Total_Valuation_1__c, Total_Valuation_2__c, Final_Valuation__c,
                              Asset_Master__c, Asset_Cost__c, Asset_Type__c, Valuation_amount__c, Asset_Level__c,
                              Asset_Model__c, Asset_FinnOne_Code__c, Asset_Category__c, Asset_Manufacturer__c, Manufacturing_Date__c, Asset_Master__r.Name
                              /* Decentralized Disb Code Start */
                              , Property_Description__c, Construction_Area_Val1__c /*Bug_22616*/ , Building_Name__c, Second_Appraisal_By__c, First_Appraisal_By__c, Land_Valuation_1__c, Land_Valuation_2__c,
                              Property_Status__c, Average_Of_Two_Valuations__c, Builder_Maintenance__r.Name, Project_Name__r.Name, APF_Number__c, Plot_Flat_No__c
                              /* Decentralized Disb Code End */
                              /*Mortgage Change S*/
                              , Property_Pic_1__latitude__s, Property_Pic_1__longitude__s, Property_Pic_2__latitude__s, Property_Pic_2__longitude__s, Property_Pic_3__latitude__s, Property_Pic_3__longitude__s, Property_Identified__c, /*bug 13560 s*/ Property_Usage__c, Construction_Rate__c, Distance_Outside_Municipal_limits__c, Net_LTV1__c, No_of_tenants_Relative__c, Separate_Access_to_the_property__c, Top_floor_property__c, Approach_Road_Mortgage__c, Developer_Name__r.Builder_Segmentation__c, Builder_Maintenance__r.Builder_Segmentation__c, Developer_Name__r.Name, Developer_Name__c, Stage_of_Construction__c, Nature_of_property__c, Avg_Property_price__c, Property_Land_Area_In_Sq_Ft__c, Property_Age__c, Construction_Area_SBU__c, Total_valuation_As_per_PE_PPIV2__c /*bug 13560 e */
                              /*Mortgage Change E*/
                              , /* Customer Level Collateral Tracking added by priya start*/ Existing_Loan_Funded_amount__c /*Customer Level Collateral Tracking added by priya end*/ , sallap_scheme__c /*Bug-17095*/
                              from Property_Details__c where Loan_Application__C =: LoanId and Property_Type__c != 'Shares' /*Mortgage Re-Engg*/
                              AND property_details__c = null /*Mortgage Re-Engg*/
                              ORDER BY createddate DESC
                             ];
            } else {
                properties = [Select /*21463 S*/ Extra_Amenities_Val1__c, Property_Land_Rate_Val1__c, Basic_Rate__c, Top_Up_Percentage__c, Total_Valuation__c, Seperate_access_to_the_property__c, Construction_Rate_Val1__c, /*21463 E*/ /*Property Dedupe - Anshita S */ LinkedPropertyCode__c, Geolocation__Latitude__s, Geolocation__Longitude__s, Area_Locality__c, /*Property Dedupe - Anshita E */ id, Name, Select__C, Property_Address_Line_1__C, Property_Address_Line_2__C, Property_Address_Line_3__C, Property_City__c,
                              Property_Pin_Code__C, Property_State__C, Property_Type__C, Property_Value__c, Dealer_Master__c, Dealer_Master__r.Dealer_ID__c,
                              Type_Of_Measurement__C, Total_Valuation_1__c, Total_Valuation_2__c, Final_Valuation__c,
                              Asset_Master__c, Asset_Cost__c, Asset_Type__c, Valuation_amount__c, Asset_Level__c,
                              Asset_Model__c, Asset_FinnOne_Code__c, Asset_Category__c, Asset_Manufacturer__c, Manufacturing_Date__c, Asset_Master__r.Name
                              //* Decentralized Disb Code Start */
                              , Property_Description__c, Construction_Area_Val1__c /*Bug_22616*/ , Building_Name__c, Second_Appraisal_By__c, First_Appraisal_By__c, Land_Valuation_1__c, Land_Valuation_2__c,
                              Property_Status__c, Average_Of_Two_Valuations__c, Builder_Maintenance__r.Name, Project_Name__r.Name, APF_Number__c, Plot_Flat_No__c
                              /* Decentralized Disb Code End */
                              /*Mortgage Change S*/
                              , Property_Pic_1__latitude__s, Property_Pic_1__longitude__s, Property_Pic_2__latitude__s, Property_Pic_2__longitude__s, Property_Pic_3__latitude__s, Property_Pic_3__longitude__s, Property_Identified__c, /*bug 13560 s*/ Property_Usage__c, Construction_Rate__c, Distance_Outside_Municipal_limits__c, Net_LTV1__c, No_of_tenants_Relative__c, Separate_Access_to_the_property__c, Top_floor_property__c, Approach_Road_Mortgage__c, Developer_Name__r.Builder_Segmentation__c, Builder_Maintenance__r.Builder_Segmentation__c, Developer_Name__r.Name, Developer_Name__c, Stage_of_Construction__c, Nature_of_property__c, Avg_Property_price__c, Property_Land_Area_In_Sq_Ft__c, Property_Age__c, Construction_Area_SBU__c, Total_valuation_As_per_PE_PPIV2__c /*bug 13560 e */
                              /*Mortgage Change E*/
                              , /* Customer Level Collateral Tracking added by priya start*/ Existing_Loan_Funded_amount__c /*Customer Level Collateral Tracking added by priya end*/ , sallap_scheme__c /*Bug-17095*/
                              from Property_Details__c where Loan_Application__C =: LoanId /*Mortgage Re-Engg*/ AND property_details__c = null /*Mortgage Re-Engg*/
                              ORDER BY createddate DESC
                             ];
            }
            
            
            
            
            system.debug('properties' + properties);
            //system.debug('properties' + properties.size());
            checklistdocs = [Select id, Ischecked__c, DocStatus__c, Applicant__r.id, Loan_Application__c, Sales_Status__c, Comments__c, Category__C, Received_Date__c, Property_Document__c,
                             From__C, To__C, Document_Date__c, Property_Details__C, Property_Details__r.Property_Address_Line_1__c, Document_Type__c,
                             Checklist_type__c, Applicant__r.Applicant_Type__c, Approved_flag__c,
                             Type_of_Document__c, Approved_by__c, Branch_Status__c, Branch_Remark__c, Operation_Status__c, Ops_Status__c, Ops_Remark__c, Date_Auto_Punch1__c, Date_Auto_Punch2__c, PDD__c, OTC__c, OTC_main__c, PDD_main__c,
                             Ageing__c, Document_Sent_to_NAX__c,
                             Deferral_Type__c, Expected_Resolution__c, Property_Details__r.Name, DocStatus1__c, Documents_Type__c, Target_Date__c, IsCritical__c, IsNonCritical__c, checkfordelete__c, Document_TYPE1__c, DocumentFmlyName__r.Documents__c,
                             DocumentFmlyName__r.FinnOne_Document_id__c, PDD_OTC_Received_Date__c, PDD_OTC_Received_Status__c, PDD_OTC_Remarks__c, DocumentFmlyName__r.Name, Property_Documents__c, Deferral_Taken_Date__c, CPA_Deferral_Clearance_Date__c, CPA_Deferral_Status__c, OpsDeferral_Clearance_Date__c, OPS_Deferral_Status__c, Details_of_Defferral_Docs__c
                             From Checklist__c where Loan_Application__c =: LoanId and Applicant__r.Applicant_Type__c = 'Primary'
                            ];
            
            
            //Added DK-Sart-Bug 718
            //getting repaymentmodes Details
            /* Start Enhancement :11735 : Insurance Premium Validation  */
            // start new Changes
            lstFeesPremVal = [Select id, /*19500 S*/ Instrument_type__c, /*19500 E*/ Finnone_ChargeId__c, Charge_Desc__c, Charge_ID__c, Disbursement_Number__c, Rate_Amount__c, Charge__c, Deducted_from_Disbursement__c, Charge_Type__c, Change_Amount__c from Fees_and_Charge__c where Loan_Application__c =: LoanId And Identifier__c != 'Mortgage' /*Mortgage*/ ];
            // end new Changes
            
            /* End Enhancement :11735 : Insurance Premium Validation  */
            
            //19500 S
            
            system.debug('lstFeesPremVal.size()' + lstFeesPremVal.size());
            for (Fees_and_Charge__c fees: lstFeesPremVal) {
                if (fees.Finnone_ChargeId__c != null && fees.Instrument_type__c == 'Deduct from Disb') {
                    if (Label.FandCChargeIDforEliteCard.contains(String.valueOf(fees.Finnone_ChargeId__c))) {
                        changeAmtsum += fees.Change_Amount__c;
                        system.debug('changeAmtsum in loop' + changeAmtsum);
                    }
                }
                
                
            }
            system.debug('changeAmtsum out of  loop' + changeAmtsum);
            
            //19500 E
            if (LAPprods.size() > 0) {
                if (LAPprods.contains(loan.Product__c.toUppercase())) {
                    system.debug('selected product----->' + Loan.Product__c);
                    //17547-- added UMRN__c
                    repaymentmodes = [select id, UMRN__c, MICR_Code__c, Bank_Name__c, A_C_NO__c, Bank_Branch__c, Loan_Application__c, Tranche_Detail__r.Tranche_Number__c,
                                      Repayment_Mode__c, Open_ECS_Facility__c, Open_ECS_Ex_Customer_Id__c, Open_Valid_till__c, Open_ECS_Max_Limit__c, ECS_Start_Date__c,
                                      ECS_End_Date__c, ECS_Amount__c, Account_Holder_Name__c, PDC_By_Name__c, PDC_START_DATE__c, Cheque_Amount__c, IFSC_Code__c, ECS_Barcode_No__c, A_C_Type__c
                                      from RePayment_mode_detail__c where Loan_Application__c =: LoanId
                                     ]; //query modified by gopika
                    //barcode field added by Suraj...Mandate enhancement
                    //A_C_Type__c field added by Suraj...Finnone Audit enhancement
                    system.debug('repayment-->' + repaymentmodes);
                    //charges API enhancement start added Finnone_ChargeId__c in query
                    /* Start Enhancement :11735 : Insurance Premium Validation  */
                    // start new Changes
                    /*feesCharges = [Select id, Finnone_ChargeId__c, Charge_ID__c, Charge_Desc__c, Disbursement_Number__c, Rate_Amount__c, Charge__c, Deducted_from_Disbursement__c, Charge_Type__c, Change_Amount__c from Fees_and_Charge__c where Loan_Application__c = : LoanId AND Disbursement_Number__c = '1'
And Identifier__c != 'Mortgage' /*Mortgage*/
                    /*
];*/
                    for (Fees_and_Charge__c fees: lstFeesPremVal) {
                        if (fees.Disbursement_Number__c == '1') {
                            feesCharges.add(fees);
                        }
                    }
                    // end new Changes
                    /* End Enhancement :11735 : Insurance Premium Validation  */
                    system.debug('feesCharges!!!!!!!!!!' + feesCharges);
                } else {
                    //17547-- added UMRN__c
                    repaymentmodes = [select id, UMRN__c, MICR_Code__c, Bank_Name__c, A_C_NO__c, Bank_Branch__c, Loan_Application__c, Tranche_Detail__r.Tranche_Number__c,
                                      Repayment_Mode__c, Open_ECS_Facility__c, Open_ECS_Ex_Customer_Id__c, Open_Valid_till__c, Open_ECS_Max_Limit__c, ECS_Start_Date__c,
                                      ECS_End_Date__c, ECS_Amount__c, Account_Holder_Name__c, PDC_By_Name__c, PDC_START_DATE__c, Cheque_Amount__c, IFSC_Code__c, ECS_Barcode_No__c, A_C_Type__c
                                      from RePayment_mode_detail__c where Loan_Application__c =: LoanId
                                     ];
                    //barcode field added by Suraj___Mandate enhancement
                    //A_C_Type__c field added by Suraj...Finnone Audit enhancement
                    system.debug('repayment-->' + repaymentmodes);
                    //charges API enhancement start added Finnone_ChargeId__c in query
                    /* Start Enhancement :11735 : Insurance Premium Validation  */
                    // start new Changes
                    /*
feesCharges = [Select id, Finnone_ChargeId__c, Charge_Desc__c, Charge_ID__c, Disbursement_Number__c, Rate_Amount__c, Charge__c, Deducted_from_Disbursement__c, Charge_Type__c, Change_Amount__c from Fees_and_Charge__c where Loan_Application__c = : LoanId And Identifier__c != 'Mortgage' /*Mortgage*/
                    /* ];
*/
                    // end new Changes
                    feesCharges = lstFeesPremVal;
                    /* End Enhancement :11735 : Insurance Premium Validation  */
                    // system.debug('feesCharges!!!!!!!!!!' + feesCharges);
                }
            }
            //Added DK-End-Bug 718
            
            /*if (properties.size() > 0) {
system.debug('===Property size===' + properties.size());
system.debug('ppppppppppppppppppppid!!!!!!!!!!' + properties[0].id);
system.debug('dealer*******************' + properties[0].Dealer_Master__c);
system.debug('sssssssss&&&&&&&&&&&&&&&&&&' + properties[0].Dealer_Master__r.Dealer_ID__c);
}*/
            // getting Applicant Details
            //*************************** EMI Holiday Query Fields Add up
            //CIN DIN Enhancement fields added  by pankaj 
            /*Added Product field in query - Bug 13950 */
            apps = [select Dedupe_Linking_Done__c,/*20939 s*/Score_card__c,/*20939 e*/id, name, /* Bug Id:14441: added RCU_Status */ RCU_Status__c, Contact_Name__r.CIN__c, Contact_Name__r.DIN__c, Contact_Name__r.Stamp_Duty__c, EMI_Holiday_Opted__c, EMI_Holidays_Across_tenure__c, Contact_Name__c, Contact_Name__r.Name, Contact_Name__r.Customer_Profile__c,
    Contact_Name__r.Designation__c, Contact_Name__r.Employer_Name__c, Contact_Name__r.Qualification__c, Contact_Name__r.Address_1__c, /* 21288 AP Cross_Collateral_LAN__c */ Cross_Collateral_LAN__c, /* 21505 AP */ Contact_Name__r.Father_Spouse__c, Address_Proof__c, Contact_Name__r.Father_Spouse_Salutation__c, Contact_Name__r.Father_Spouse_First_Name__c, Contact_Name__r.Father_Spouse_Middle_Name__c, Contact_Name__r.Father_Spouse_Last_Name__c, Contact_Name__r.Mother_First_Name__c, Contact_Name__r.Mother_Middle_Name__c, Contact_Name__r.Mother_Last_Name__c, Contact_Name__r.Occupation_CKYC__c, Proof_of_Identity__c, Identity_Document_No__c, Identity_Document_Expiry_Date__c, CKYC_No__c, Proof_of_Residence_Address_Submitted__c, /* 21505 E AP */
                    PD_Status__c, Bank_Status__c, Contact_Name__r.Address_2__c, Applicant_Type__c, Contact_Name__r.Customer_Type__c, Contact_Name__r.ApplicantType__c,
                    Contact_Name__r.Date_of_Birth__c, Contact_Name__r.PAN_Number__c, Contact_Name__r.Year_of_Incorporation__c, Contact_Name__r.FathersHusbands_Name__c,
                    Contact_Name__r.Bank_Account_No__c, Contact_Name__r.VoterID_Number__c, Contact_Name__r.ROC_Regn_No__c, Contact_Name__r.Address_3__c, Contact_Name__r.AppCity__c,
                    Contact_Name__r.Pin_Code__c, Contact_Name__r.Phone, Contact_Name__r.MobilePhone, Contact_Name__r.Email, Contact_Name__r.Address_Line_One__c, Contact_Name__r.Address_2nd_Line__c, Contact_Name__r.Address_3rd_Line__c,
                    Contact_Name__r.Office_City__c, Contact_Name__r.Office_Pin_Code__c, Contact_Name__r.Office_STD_Code__c, Contact_Name__r.Office_Phone_Number__c,
                    Contact_Name__r.Mobile_Phone__c, Contact_Name__r.Office_Email_Id__c, Contact_Name__r.Middle_Name__c, Customer_Acceptance__c,
                    Contact_Name__r.FirstName, Contact_Name__r.LastName, Contact_Name__r.Permanant_Address_Line_1__c, Contact_Name__r.Permanant_Address_Line_2__c, Contact_Name__r.Permanant_Address_Line_3__c,
                    Contact_Name__r.Permanent_STD__c, Contact_Name__r.Permanent_Pin_Code__c, Contact_Name__r.Year_in_Present_Job__c, Contact_Name__r.Year_in_Previous_Job__c, Contact_Name__r.Name_of_the_company_Employer__c,
                    Contact_Name__r.Nature_of_Business__c, Contact_Name__r.Employment_Status__c, Contact_Name__r.Gender__c, Contact_Name__r.Age__c, Contact_Name__r.Employment_Type__c, Contact_Name__r.STD_Code__c, Contact_Name__r.Phone_Number__c, Contact_Name__r.Residence_Landline_phone__c,
                    Contact_Name__r.Name_of_Employer__c, Designation__c, Contact_Name__r.Type_Of_Constitution__c, Contact_Name__r.Marital_Status__c, Contact_Name__r.Father_s_Name__c, Contact_Name__r.Other_Caste_Category__c, Contact_Name__r.Other_Religion__c, Contact_Name__r.Caste_Category__c, Contact_Name__r.Religion__c, Contact_Name__r.Residence_Type__c, Contact_Name__r.State__c, Contact_Name__r.Residence_City__c
                    /*invisible monitoring DL by akshata*/
                    , Pure_Flexi_Period__c
                    /*Bug 14506 - HFC Fields - SFDC*/
                    , (SELECT Id, Income_of_Borrower__c FROM SurrogateCAMS__r), (SELECT Id, Income_of_Borrower__c FROM CAMS__r) /*Bug 14506 - HFC Fields - SFDC*/ , RSA_flag__c, RSA_Loan_application_status__c, Contact_Name__r.TAN_Number__c, Loan_Application__r.Product__c, Contact_Name__r.CIF_Id__c
                    /*Bug 16173 - VRPL changes for HFC Start*/
                    , Parent_Deal_ID__c, Parent_Deal_ID__r.Loan_Application_Number__c /*Bug 16173 - VRPL changes for HFC End*/ /*19500 S*/ , Membership_charges__c, Opt_For_Elite_Card__c /*19500 E*/
                    from Applicant__c where Loan_Application__c =: Loan.Id
                   ];
            
            //LA phase - II //cibil watch  Enquiry_Amount__c,Offer_Expiry_Date__c, Tele_Calling_Sub_disposition__c
            proOfferList = [SELECT id, name, Enquiry_Amount__c, Offer_Expiry_Date__c, Tele_Calling_Sub_disposition__c, Customer_ID1__r.Customer_ID__c, Opportunity__r.Id, ownerId, EMI_Amount__c, Availed_EMI__c, Products__c,
                            Sourcing_Channel__r.Name, Product_Offering_Converted__c, Offer_Accepted_amount__c, Lead__c, Lead__r.Employment_Type__c, Existing_Product__c,
                            Customer_Name__c, Customer_ID1__c, Customer_ID1__r.Flow__c, Customer_ID1__r.Email_New__c, Customer_ID1__r.Name, Customer_ID1__r.Address_Change__c,
                            Customer_ID1__r.Contact_Person_Name__c, Customer_E_mail__c, Customer_Email_ID__c, Customer_ID__c,
                            Customer_Mobile__c, Address_Line_1__c, Field_Desposition_Status__c, Existing_LAN__c, Address_Line_2__c, Address_Line_3__c, Pin_Code__c, Resi_State__c,
                            Customer_ID1__r.State__c, Final_Amount__c, Offer_ROI__c, Tenor__c, New_line_assigned__c, Existing_line_utilized__c, Line_updated__c,
                            Offer_Amount__c, Offer_ID__c, TeleCalling_Desposition_Status__c, Field_Check_Status__c, DNC_flag__c, Sourcing_Channel__c, Product_Offering_Source__c,
                            eKYC_Processing__c,
                            Existing_Customer_Segmentation__c, Availed_Amount__c,
                            Risk_Classification__c, Open_Ecs_Limit__c, Disb_Act_No__c, Disb_Bank_Name__c, Disb_Bank_Branch__c, Disb_favouring__c, PDD_pending__c, POS_Old_Loan__c,
                            Secured_W_O_BT_Line_Assigned__c,
                            Secured_W_O_BT_Line_Available__c, Secured_BT_Line_Assigned__c, Secured_BT_Line_Available__c, Secured_Line_Expiry_Date__c, Unsecured_Line_Expiry_Date__c,
                            Unsecured_W_O_BT_Line_Assigned__c, Unsecured_W_O_BT_Line_Available__c, Unsecured_BT_Line_Assigned__c, Unsecured_BT_Line_Available__c
                            from Product_Offerings__c where Opportunity__r.Id =: Loan.Id limit 1000
                           ];
            system.debug('@@@@@@@@Product Offerings@@@@@@@@' + proOfferList.size());
            surrogateList = [Select Tenor_for_Line_assignment_in_yrs__c, Expiry_Date_without_BT__c, Expiry_Date_with_BT__c, Total_Loan_amount_basis_Max_eligible_EMI__c, Line_assigned_basis_Credit_Assessment__c,
                             Existing_Emi_that_can_be_closed__c, Additional_Line_Availability_for_DC__c, Total_Line_available_including_DC__c,
                             Line_assigned_basis_Credit_Assessment_DC__c, Unsecured_Line_assigned_with_BT__c, Unsecured_Line_assigned_without_BT__c, Customer_Acceptance_Flag__c,
                             Customer_Accepted_Date__c, Line_Active_Flag__c, OptOutURL__c, OptInURL__c, Line_flag__c, Line_Assigned_Date__c
                             From SurrogateCAM__c where Loan_Application__c =: Loan.Id limit 1
                            ];
            //system.debug('@@@@@@@@ Surrogate CAM @@@@@@@@' + surrogateList.size());
            
            
            
            //LA phase - II
            
            //FAS
            if (Loan != null && Loan.Product__c == 'FAS') {
                for (Bank_Account__C bank: [select Id, Applicant__c, Applicant__r.Id, ClientId__c, Depository_Participant_Id__c from Bank_Account__c where Loan_Application__c =: Loan.Id]) {
                    banlAccMap.put(bank.Applicant__r.Id, bank);
                }
            }
            /*---Added by Asmita for Insurance BRD for SFDC----*/
            /*Moved below query in constructor as need to add validations on DLPInurance object fields*/
            
            /* Rohit Mourya: Fields added for Insurance BRD for SFDC Phase 2
Appointee_DOB__c,Appointee_Name__c,Discrepant_Resolution__c,Discrepant_at_TCS__c,Source__c */
            //Applicant__r.name - Added for Bug - 12755 by Asmita
            
            ListDPLinsurance = [SELECT Name, Applicant_type__c, Type_of_Insurance__c, Critical_Illness__c, Declaration_of_good_health__c, Insurance_form_number__c, Insurance_ID__c,
                                Insurance_Party_type__c, Insurance_Product__c, Nominee_Name__c, Insurance_term__c, Insurance_Type__c, Insurer_Name__c, Premium_Amount__c, Nominee_Relationship_with_Policy_Holder__c,
                                Sum_Assured__c, Relation__c, Nominee_DOB__c, Nominee_Mobile__c, Nominee_Age__c, Nominee_Relationship__c, Nominee_Address__c, Form_Handover__c,
                                Opportunity__r.Dispatch_time__c, Opportunity__r.File_Inward__c, Appointee_DOB__c, Appointee_Name__c, Discrepant_Resolution__c, Discrepant_at_TCS__c,
                                Source__c, Applicant__r.name, Applicant__c, Applicant__r.Contact_Name__r.Name FROM DPLinsurance__c where Opportunity__c =: Loan.Id
                               ];
            
            System.debug('In DPL insurance:  ListDPLinsurance' + ListDPLinsurance);
            
        }
        
    }
    
    
    
    
    public PageReference sendfinn() {
        /**
integer status=0;
for(integer rr=0; rr > verificationRec.size(); rr++){

if(verificationRec[rr].Status__c == null && Loan.QDP__c == true){


// ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Verification record status is Blank');
//        Apexpages.addMessage(myMsg);
// break;
}
}

**/
        /*20939 s*/
        Applicant__c appPrim = new APplicant__c();
        for (Applicant__c app: apps) {
            if (app.Applicant_Type__c != null && app.Applicant_Type__c == 'Primary') {
                appPrim = app;
            }
        }
        if (Loan.Account.Flow__c == 'Mobility V2') {
            for (Verification__c ver: verificationRec) {
                if (ver.RSA_Reason__c == 'Initiated through RSA' && ver.Status__c != 'Positive' && ver.Status__c != 'Refer') {
                    if (salmobilityv2flag)
                        mobilitystatus = 'RSA verifications are not yet completed';
                    else {
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'RSA verifications are not yet completed'));
                    }
                    ErrorFlag = true;
                    return null;
                }
            }
            if(appPrim.Score_card__c > 8){
                if (salmobilityv2flag)
                    mobilitystatus = 'App score is greater than 8. Case cannot be moved to Finnone';
                else {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'App score is greater than 8. Case cannot be moved to Finnone'));
                }
                ErrorFlag = true;
                return null;    
            }
        }
        /*20939 e*/
        //19500 S
        // if(Loan.CUSTOMER__r.Payment_received__c==true){
        Boolean ECErrorflag = false;
        if (apps != null) {
            for (Applicant__c app: apps) {
                if (app.Applicant_Type__c != null && app.Applicant_Type__c == 'Primary') {
                    system.debug('checking in Applicant');
                    if (app.Opt_For_Elite_Card__c == true) {
                        if (app.Membership_charges__c != null) {
                            if (changeAmtsum != app.Membership_charges__c) {
                                ECErrorflag = true;
                            }
                        } else {
                            ECErrorflag = true;
                        }
                    }
                }
            }
        }
        if (ECErrorflag == true) {
            if (Loan.Product_Offerings__r != null && Loan.Product_Offerings__r.size() > 0) {
                system.debug('checking in PO');
                for (Product_Offerings__c po: Loan.Product_Offerings__r) {
                    if (po.Tags__c != null && (Decimal.valueOf(po.Tags__c) == changeAmtsum)) {
                        ECErrorflag = false;
                    }
                }
            }
        }
        system.debug('Elite card flag' + ECErrorflag);
        if (ECErrorflag == true) {
            ErrorFlag = true;
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Charges not collected against Elite Card'));
            return null;
        }
        // }     
        //19500 E
        //20833 S
        List < String > HFCProducts = Label.HFCPropertyValidation.split(';');
        for (String product: HFCProducts) {
            if (product.equalsIgnoreCase(Loan.Product__c)) {
                HFCFlag = true;
            }
        }
        if (HFCFlag == true) {
            if (Loan != null && Loan.Id != null && Loan.Loan_Amount_with_Premium__c != null) {
                HFCValuation val = new HFCValuation();
                Boolean result = val.InitiateValidation(Loan.Id, Loan.Loan_Amount_with_Premium__c);
                system.debug('20833 result:' + result);
                if (result == false) {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Valuation amount and/or valuation verification agency as per norms not updated'));
                    return null;
                    
                }
            }
        }
        //20833 E          
        
        // send to finnone for checklist documents
        system.debug('function call');
        System.debug('Loan record:  ' + Loan);
        if (Loan.Id != null) {
            
            /*** START: Enh.- #15333 LTV to Salesforce @YS Dec. 2017 ***/
            if (Label.LTV_Products != NULL) {
                List < String > ltvProducts = Label.LTV_Products.split(',');
                Set < String > sLtvProducts = new Set < String > ();
                sLtvProducts.addAll(ltvProducts);
                system.debug('777: Loan.Product__c' + Loan.Product__c + '; sLtvProducts' + sLtvProducts);
                if (sLtvProducts.contains(Loan.Product__c)) {
                    Decimal loanAmt = null;
                    if (Loan.Loan_Amount_with_Premium__c != NULL && Loan.Loan_Amount_with_Premium__c != 0.0) {
                        loanAmt = Loan.Loan_Amount_with_Premium__c;
                    } else if (Loan.Approved_Loan_Amount__c != NULL && Loan.Approved_Loan_Amount__c != 0.0) {
                        loanAmt = Loan.Approved_Loan_Amount__c;
                    }
                    
                    System.debug('--- Loan amt ---' + loanAmt);
                    if (loanAmt != NULL) {
                        List < Property_Details__c > lProperties = new List < Property_Details__c > ();
                        lProperties = [
                            SELECT /*21463 S*/ Extra_Amenities_Val1__c, Property_Land_Rate_Val1__c, Basic_Rate__c, Top_Up_Percentage__c, Total_Valuation__c, Approach_Road_Mortgage__c, Top_floor_property__c, Seperate_access_to_the_property__c, /*21463 E*/ Id, Final_Valuation__c /*#17186 s*/ , Existing_Collateral_POS__c /*#17186*/
                            FROM Property_Details__c
                            WHERE Loan_Application__c =: Loan.Id
                        ];
                        
                        System.debug('--- checking properties for LTV ---');
                        if (lProperties != NULL && lProperties.size() > 0) {
                            System.debug('--- LTV properties are not null ---');
                            Boolean flag = true;
                            Decimal summation = 0.0;
                            Decimal sumCollateralPos = 0.0; //#17186 - Added for holding sum of Existing collateral POS
                            
                            for (Property_Details__c oProp: lProperties) {
                                //#17186 - Adding condition for Existing_Collateral_POS__c
                                
                                //#17910 - Removed this condition and modified version is given below - if(oProp.Final_Valuation__c == NULL || oProp.Existing_Collateral_POS__c == NULL)
                                if (oProp.Final_Valuation__c == NULL) {
                                    flag = false;
                                    break;
                                }
                                
                                summation += oProp.Final_Valuation__c;
                                //#17910 - Handled NULL condition so that it can work with null values as well(by giving zero as substitue).
                                sumCollateralPos += (oProp.Existing_Collateral_POS__c == NULL ? 0.0 : oProp.Existing_Collateral_POS__c); //#17186 - Summing up Existing collateral POS
                            }
                            
                            
                            Decimal percentage = 0.0;
                            if (summation != 0.0) {
                                percentage = ((loanAmt + sumCollateralPos) / summation) * 100; //#17186 - Adding condition for collateral POS
                            }
                            
                            System.debug('Collateral POS Summation: ' + sumCollateralPos);
                            System.debug('Summation: ' + summation);
                            System.debug('percentage: ' + percentage);
                            
                            /**** START : #17186 Adding conditions dynamically ****/
                            Double boundryValue1 = NULL, boundryValue2 = NULL;
                            Double lowCondition = NULL, medCondition = NULL, highCondition = NULL;
                            Boolean dynamicflag = false;
                            List < String > dataFromLabel = Label.LTV_conditions.split('-');
                            if (dataFromLabel != NULL && dataFromLabel.size() == 2) {
                                List < String > valFromLabel = dataFromLabel[0].split(';');
                                if (valFromLabel != NULL & valFromLabel.size() == 2) {
                                    List < String > conditionFromLabel = dataFromLabel[1].split(';');
                                    if (conditionFromLabel != NULL && conditionFromLabel.size() == 3) {
                                        boundryValue1 = Double.valueOf(valFromLabel[0]);
                                        boundryValue2 = Double.valueOf(valFromLabel[1]);
                                        highCondition = Double.valueOf(conditionFromLabel[0]);
                                        medCondition = Double.valueOf(conditionFromLabel[1]);
                                        lowCondition = Double.valueOf(conditionFromLabel[2]);
                                        dynamicflag = true;
                                    }
                                }
                            }
                            
                            
                            //checking validations 
                            if (dynamicflag) {
                                if (loanAmt >= 0 && loanAmt <= boundryValue1) {
                                    if (percentage > highCondition) {
                                        ErrorFlag = true;
                                        //17556  
                                        if (salmobilityv2flag)
                                            mobilitystatus = 'Loan amount is not within the Max LTV maintained.';
                                        else
                                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Loan amount is not within the Max LTV maintained.'));
                                        return null;
                                    }
                                } else if (loanAmt > boundryValue1 && loanAmt <= boundryValue2) {
                                    if (percentage > medCondition) {
                                        ErrorFlag = true;
                                        //17556  
                                        if (salmobilityv2flag)
                                            mobilitystatus = 'Loan amount is not within the Max LTV maintained.';
                                        else
                                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Loan amount is not within the Max LTV maintained.'));
                                        return null;
                                    }
                                } else if (loanAmt > boundryValue2) {
                                    if (percentage > lowCondition) {
                                        ErrorFlag = true;
                                        //17556  
                                        if (salmobilityv2flag)
                                            mobilitystatus = 'Loan amount is not within the Max LTV maintained.';
                                        else
                                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Loan amount is not within the Max LTV maintained.'));
                                        return null;
                                    }
                                }
                            } else if (!dynamicflag) {
                                if (loanAmt >= 0 && loanAmt <= 3000000) {
                                    if (percentage > 90.001) {
                                        ErrorFlag = true;
                                        //17556  
                                        if (salmobilityv2flag)
                                            mobilitystatus = 'Loan amount is not within the Max LTV maintained.';
                                        else
                                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Loan amount is not within the Max LTV maintained.'));
                                        return null;
                                    }
                                } else if (loanAmt > 3000000 && loanAmt <= 7500000) {
                                    if (percentage > 80.001) {
                                        ErrorFlag = true;
                                        //17556  
                                        if (salmobilityv2flag)
                                            mobilitystatus = 'Loan amount is not within the Max LTV maintained.';
                                        else
                                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Loan amount is not within the Max LTV maintained.'));
                                        return null;
                                    }
                                } else if (loanAmt > 7500000) {
                                    if (percentage > 75.001) {
                                        ErrorFlag = true;
                                        //17556  
                                        if (salmobilityv2flag)
                                            mobilitystatus = 'Loan amount is not within the Max LTV maintained.';
                                        else
                                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Loan amount is not within the Max LTV maintained.'));
                                        return null;
                                    }
                                }
                            }
                            /**** END : #17186 Adding conditions dynamically @YS Mar. 2018****/
                            
                        }
                    }
                }
            }
            
            /***   END: Enh.- #15333 LTV to Salesforce @YS Dec. 2017 ***/
            
            /* Prajyot 12830 GST implementation Start */
            List < Address_Details__c > addressList = new List < Address_Details__c > ();
            addressList = [select id, State__c, Skip_Validation_Rules__c, Exemption_Applicable__c,
                           Adderss_Line_3__c, Address_Line_2__c, Address_Line_1__c, city__c, Loan_application__c,
                           Contact_Person_Number__c, Consider_for_Loan__c, Applicant__c, Applicant__r.name, GST_IN_Number__c, Lead__c,
                           Lead_Applicant__c, Pin_Code__c, Product_Offering__c
                           from Address_Details__c where Loan_application__c =: Loan.Id and GST_IN_Number__c != null
                          ];
            Integer considerForLoanCount = 0;
            if (addressList != null && addressList.size() > 0) {
                for (Address_Details__c adr: addressList) {
                    if (adr.Consider_for_Loan__c == 'Yes') {
                        considerForLoanCount = considerForLoanCount + 1;
                    }
                }
                if (considerForLoanCount == 0) {
                    ErrorFlag = true;
                    //17556 s
                    if (salmobilityv2flag)
                        mobilitystatus = 'No record  available to consider for loan.';
                    else
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No record  available to consider for loan.'));
                    
                    return null;
                } else if (considerForLoanCount > 1) {
                    ErrorFlag = true;
                    //17556 s
                    if (salmobilityv2flag)
                        mobilitystatus = 'More than one Consider for Loan records found.';
                    else
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'More than one Consider for Loan records found.'));
                    return null;
                }
            }
            /* Prajyot 12830 GST implementation End */
            // start Insurance distribution changes
            if (loan.Product__c == 'DPL' && loan.leadSource == 'Insurance Distribution' && loan.StageName != 'Approved') {
                ErrorFlag = true;
                system.debug('=====> error');
                //17556 s
                if (salmobilityv2flag)
                    mobilitystatus = 'Loan Application must be QC2 approved';
                else {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Loan Application must be QC2 approved');
                    Apexpages.addMessage(myMsg);
                }
                return null;
            }
            // end Insurance distribution changes
            
            if (date.newinstance(2013, 7, 5) < Loan.createddate && (loan.Product__c == 'LAP' || LAPprods.contains(loan.Product__c.toUppercase()) || loan.Product__c == 'Home Loan' || loan.Product__c == 'SBS CS HL' || loan.Product__c == 'SBS CS LAP' || loan.Product__c == 'SBS CS SHL')) {
                system.debug('=====> checklistdocs');
                List < Parameter_Master__c > checkPara = [select Send_To_Finnone__c from Parameter_Master__c where Product__c =: loan.Product__c];
                if (checkPara.size() > 0 && checkPara[0].Send_To_Finnone__c == true) {
                    for (Checklist__c temp: checklistdocs) {
                        if (temp.docstatus__c != 'Received' && temp.approved_by__c != 'STD OTC' && temp.approved_by__c != 'STD PDD' && temp.approved_by__c != 'NA') {
                            if (temp.approved_flag__c == false && temp.Checklist_type__c != 'Login') {
                                ErrorFlag = true;
                                system.debug('=====> error');
                                //17556 s
                                if (salmobilityv2flag)
                                    mobilitystatus = 'All Primary Applicant Checklist document should be Approved';
                                else {
                                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'All Primary Applicant Checklist document should be Approved');
                                    Apexpages.addMessage(myMsg);
                                }
                                return null;
                            }
                        }
                    }
                }
            }
        }
        //system.debug('=====> Deviation check out');
        /* // 3367-  send to finnone reject case for Collateral Deviation PDD
if(Loan.Id !=null && mortgage==true && date.newinstance(2015,07,15) < Loan.createddate){         
system.debug('=====> Deviation check');
List<Deviation_Transaction__c> devStatus=[select Deviation_Status__c from Deviation_Transaction__c where Loan_Application__c=:Loan.Id];
system.debug('devstatus size '+devStatus.size());
for(Deviation_Transaction__c temp:devStatus){
if(temp.Deviation_Status__c !='Approve'){                   
ErrorFlag = true;
system.debug('=====> Deviation not yet approved='+temp.Deviation_Status__c);
ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'All Property deviation must be Approved');
Apexpages.addMessage(myMsg);
return null;

}
}

}    */
        
        //Code changes for validations
        if (Loan.Id != null) {
            //***********EMI Holiday Query Field Add UP
            //cash in 60 mins EMI_Holiday_Months__c
            primaryAppList = [select id, RCU_Status__c, RSA_flag__c, Pure_Flexi_Period__c, RSA_Loan_application_status__c, EMI_Holiday_Months__c, EMI_Holiday_Opted__c, Contact_Name__r.Stamp_Duty__c, EMI_Holidays_Across_tenure__c, name, Contact_Name__r.TAN_Number__c, Contact_Name__c, Applicant_Type__c, /*bug 13560 s*/ Contact_Name__r.Date_of_Birth__c /* bug 13560 e*/ from Applicant__c where Loan_Application__c =: Loan.Id and Applicant_Type__c = 'Primary'];
            
            coprimaryAppList = [select id, name, RCU_Status__c, Contact_Name__c, Applicant_Type__c, Contact_Name__r.Stamp_Duty__c, Contact_Name__r.TAN_Number__c from Applicant__c where Loan_Application__c =: Loan.Id and Applicant_Type__c != 'Primary'];
            
            if (Loan.Bank_A_c_No_of_Customer__c != null) {
                String Acnumber = Loan.Bank_A_c_No_of_Customer__c;
                system.debug('******Acnumber *****' + Acnumber);
                //Boolean Numresult = REGEX(Acnumber,'[0-9]') ;
                
                //Boolean Test = Pattern.matches('^[0-9]+$', Acnumber);
                Boolean Test = Pattern.matches('^[a-zA-Z0-9]+$', Acnumber);
                system.debug('******Test *****' + Test);
                if (Test == false) {
                    ErrorFlag = true;
                    //17556
                    if (salmobilityv2flag)
                        mobilitystatus = 'Beneficiary Ac No cannot contain characters';
                    else {
                        ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.INFO, 'Beneficiary Ac No cannot contain characters');
                        Apexpages.addMessage(myMsg1);
                    }
                    validationFlag = true;
                    
                    //return null;
                }
                
            }
            // Finnone Validation Starts Bug 5048 Starts
            if (Loan.A_C_No__c != null) {
                system.debug('---Loan.A_C_No__c---' + Loan.A_C_No__c);
                String BenACNumber = Loan.A_C_No__c;
                
                system.debug('---BenACNumber---' + BenACNumber);
                
                if (!BenACNumber.contains('0') && !BenACNumber.contains('1') && !BenACNumber.contains('2') && !BenACNumber.contains('3') && !BenACNumber.contains('4') && !BenACNumber.contains('5') && !BenACNumber.contains('6') && !BenACNumber.contains('7') && !BenACNumber.contains('8') && !BenACNumber.contains('9')) {
                    system.debug('Inside ---BenACNumber---');
                    ErrorFlag = true;
                    //17556 s
                    if (salmobilityv2flag)
                        mobilitystatus = 'Beneficiary Ac No should should contain atleast one numeric digit !!!';
                    else {
                        ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.INFO, 'Beneficiary Ac No should should contain atleast one numeric digit !!!');
                        Apexpages.addMessage(myMsg2);
                    }
                    validationFlag = true;
                    //return null;
                }
                if (BenACNumber.length() > 20) {
                    ErrorFlag = true;
                    //17556 s
                    if (salmobilityv2flag)
                        mobilitystatus = 'Beneficiary Ac No length cannot be greater than 20 !!!';
                    else {
                        ApexPages.Message myMsg3 = new ApexPages.Message(ApexPages.Severity.INFO, 'Beneficiary Ac No length cannot be greater than 20 !!!');
                        Apexpages.addMessage(myMsg3);
                    }
                    validationFlag = true;
                    //return null;
                }
                
            }
            
            // Finnone Validation Starts Bug 5048 Ends
        }
        //Cibil Validation Enhancement-Leena-start Prod bug_23040
        String products;
        if(LaonApplicationCreation__c.getValues('CibilTriggerValidationProducts')!=null)
            products =LaonApplicationCreation__c.getValues('CibilTriggerValidationProducts').Products__c;
        set<String> setProduct;
        if(products!=null)
            setProduct=new Set<String>(products.split(';'));
        String flag;
        if (setProduct != null && setProduct.size() > 0 && setProduct.contains(Loan.Product__c)) 
        {
            system.debug('inside triigercibil validation finnone');   
            if(Loan.customer_type__c=='Individual')
            {
                system.debug('inside triigercibil validation finnone individual');   
                if(primaryAppList !=null && Loan!=null && primaryAppList.size()>0)
                    flag=CommonUtility.triggerCibilValidation(primaryAppList[0],Loan);
                system.debug('inside triigercibil validation finnone individual flag is==>'+flag);   
            }
            if(Loan.customer_type__c=='Corporate')
            {
                Applicant__c PrimaryFinnacialCOAPP;
                
                for(Applicant__c app:apps)
                {
                    if(app.Applicant_type__C=='Primary Financial Co-Applicant')
                    {
                        PrimaryFinnacialCOAPP=app;
                    }
                }
                if(PrimaryFinnacialCOAPP!=null && Loan!=null)
                    flag=CommonUtility.triggerCibilValidation(PrimaryFinnacialCOAPP,Loan); 
            }
        }
        
        if (flag != null && flag != '' && flag.contains('true')) {
            List < String > setReturnedValues = new List < String > (flag.split(';'));
            //17556 added if else
            if (setReturnedValues != null && setReturnedValues.size() > 0){
                if( salmobilityv2flag!=null && salmobilityv2flag)
                    mobilitystatus = 'CIBIL  is  ' + setReturnedValues[1] + 'days old. Validity of CIBIL is expired as per policy. Kindly re-trigger CIBIL';
                else
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'CIBIL  is  ' + setReturnedValues[1] + 'days old. Validity of CIBIL is expired as per policy. Kindly re-trigger CIBIL'));
            }
            return null;
        }
        ErrorFlag=true;
        //Cibil Validation Enhancement-Leena-end Prod bug_23040
        //Addded based on bug # 538 -Start
        if (Loan.Id != null) {
            if (Loan.Scheme_Master__r.Active__c == false) {
                ErrorFlag = true;
                //17556 s
                if (salmobilityv2flag)
                    mobilitystatus = 'The Selected scheme is not active';
                else {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'The Selected scheme is not active');
                    Apexpages.addMessage(myMsg);
                }
                return null;
            }
            /*---Added by Asmita -for Insurance BRD for SFDC---*/
            // Below Code is commented for Integration purpose
            /*if (Loan.File_Inward__c == null) {
ErrorFlag = true;
ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'File inward is not specified');
Apexpages.addMessage(myMsg);
return null;
}
if (Loan.Dispatch_time__c == null) {
ErrorFlag = true;
ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'File dispatch time is not specified');
Apexpages.addMessage(myMsg);
return null;
}*/
            /*---Added by Asmita -end---*/
            
        }
        //Addded based on bug # 538 -End  
        //Added by Anjali for invisible monitoring mortage-start
        if (Mortgageflag) {
            system.debug('morrtgage flag is true');
            //system.debug('primaryAppList[0].RSA_flag__c ' + primaryAppList[0].RSA_flag__c);
            //bug 13560 start
            System.debug('Primary Applicant List: ' + primaryAppList);
            commonPropertyMethods probMethods = new commonPropertyMethods();
            if (primaryAppList != null)
                probMethods.CallDCM(properties, Loan, primaryAppList[0]);
            //bug 13560 end
            //Changed By Rajendra:- BUG ID :- 16418:- OR Condition is changed into && condition cause even though All RSA Verifications were marked as not fraud then due to RSA flag condition it was giving Error.
            if (primaryAppList[0].RSA_flag__c == true && primaryAppList[0].RSA_Loan_application_status__c == 'Fraud') {
                system.debug('inside my condition');
                ErrorFlag = true;
                //17556 s
                if (salmobilityv2flag)
                {
                    if(string.isNotBlank(Label.RSA_Finnone_Products) && !Label.RSA_Finnone_Products.containsIgnoreCase(Loan.product__c))
                        mobilitystatus = 'This loan application is identified for fraud!!';
                }
                else 
                {
                    if(string.isNotBlank(Label.RSA_Finnone_Products) && !Label.RSA_Finnone_Products.containsIgnoreCase(Loan.product__c))
                    {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'This loan application is identified for fraud!!');
                        Apexpages.addMessage(myMsg);
                    }
                }
                validationFlag = true;
                return null;
            }
        }
        //Added by Anjali for invisible monitoring mortage-end
        system.debug('***primaryAppList ****' + primaryAppList.size());
        if (primaryAppList == null || primaryAppList.size() == 0) {
            ErrorFlag = true;
            //17556 s
            if (salmobilityv2flag)
                mobilitystatus = 'At least one primary applicant should exists in the loan application';
            else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'At least one primary applicant should exists in the loan application');
                Apexpages.addMessage(myMsg);
            }
            return null;
        } else {
            
            if (primaryAppList != null && primaryAppList.size() > 1) {
                ErrorFlag = true;
                //17556 s
                if (salmobilityv2flag)
                    mobilitystatus = 'There should not be more than one primary applicant in an application';
                else {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'There should not be more than one primary applicant in an application');
                    Apexpages.addMessage(myMsg);
                }
                return null;
            }
            if (primaryAppList != null && primaryAppList.size() == 1) {
                contactlist = [select id, Contact.firstName, Contact.Stamp_Duty__c, Pin_Code__c, ApplicantType__c, Customer_Type__c from Contact where id =: primaryAppList[0].Contact_Name__c];
                if (contactlist != null && contactlist.size() > 0) {
                    system.debug('---contactlist---' + contactlist);
                    if (contactlist[0].ApplicantType__c != primaryAppList[0].Applicant_Type__c) {
                        ErrorFlag = true;
                        //17556 s
                        if (salmobilityv2flag)
                            mobilitystatus = 'Value of applicant type of Contact should be same as the value of Applicant type of related Applicant';
                        else {
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Value of applicant type of Contact should be same as the value of Applicant type of related Applicant ');
                            Apexpages.addMessage(myMsg);
                        }
                        return null;
                    }
                    if (contactlist[0].Customer_Type__c == 'Individual') {
                        if (contactlist[0].firstName == '' || contactlist[0].firstName == null) {
                            ErrorFlag = true;
                            //17556 s
                            if (salmobilityv2flag)
                                mobilitystatus = 'First Name cannot be blank For Individual Applicant';
                            else {
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'First Name cannot be blank For Individual Applicant');
                                Apexpages.addMessage(myMsg);
                            }
                            return null;
                        }
                    }
                }
            }
            //Cash in 60 mins Validation start
            System.debug('**********primaryAppList[0].EMI_Holiday_Opted__c' + primaryAppList[0].EMI_Holiday_Opted__c + '********primaryAppList[0].EMI_Holiday_Months__c' + primaryAppList[0].EMI_Holiday_Months__c);
            if (primaryAppList[0].EMI_Holiday_Opted__c == true) {
                if (primaryAppList[0].EMI_Holiday_Months__c == null || primaryAppList[0].EMI_Holiday_Months__c == '') {
                    ErrorFlag = true;
                    //17556 s
                    if (salmobilityv2flag)
                        mobilitystatus = 'EMI Holiday Months cannot be empty for EMI Holiday Scheme';
                    else {
                        ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.INFO, 'EMI Holiday Months cannot be empty for EMI Holiday Scheme');
                        Apexpages.addMessage(myMsg1);
                    }
                    
                    validationFlag = true;
                }
            }
            //Cash in 60 mins Validation end
            if (coprimaryAppList != null && coprimaryAppList.size() > 0) {
                
                List < id > idlist = new List < id > ();
                system.debug('****coprimaryAppList********' + coprimaryAppList);
                for (Applicant__c coapp: coprimaryAppList) {
                    if (coapp.Contact_Name__c != null) idlist.add(coapp.Contact_Name__c);
                }
                
                if (idlist != null && idlist.size() > 0) {
                    contactlist1 = [select id, firstName, Contact.Stamp_Duty__c, Customer_Type__c, Pin_Code__c, ApplicantType__c from Contact where id in: idlist];
                }
                system.debug('***contactlist1 *******' + contactlist1);
                for (Applicant__c coapp: coprimaryAppList) {
                    
                    for (Contact con: contactlist1) {
                        
                        if (coapp.Contact_Name__c == con.id) {
                            if (con.ApplicantType__c != coapp.Applicant_Type__c) {
                                system.debug('***ApplicantType not same ****');
                                ErrorFlag = true;
                                //17556 s
                                if (salmobilityv2flag)
                                    mobilitystatus = 'Value of Applicant type of contact should be same as the value of Applicant type of related Applicant';
                                else {
                                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Value of Applicant type of contact should be same as the value of Applicant type of related Applicant');
                                    Apexpages.addMessage(myMsg);
                                }
                                return null;
                            }
                            if (con.Customer_Type__c == 'Individual') {
                                system.debug('***firstName****' + con.firstName);
                                if (con.firstName == '' || con.firstName == null) {
                                    ErrorFlag = true;
                                    //17556 s
                                    if (salmobilityv2flag)
                                        mobilitystatus = 'First name cannot be blank for Indivisual Co-Applicant';
                                    else {
                                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'First name cannot be blank for Indivisual Co-Applicant');
                                        Apexpages.addMessage(myMsg);
                                    }
                                    return null;
                                }
                            }
                            
                        }
                    }
                    
                }
                
            } //co-app if
            // Finnone Validation Starts Bug 5048 Starts
            // Decentralized Disb code Start
            //if conduitons Added by leena to skip repayment mode validation for LAS FAS and LASOL changes in LAS 
            if (Loan.product__c != 'LAS' && Loan.product__c != 'FAS' && Loan.product__c != 'LASOL') {
                if (repaymentmodes != null && repaymentmodes.size() > 0) {
                    
                    system.debug('repayment-->' + repaymentmodes);
                    for (RePayment_mode_detail__c objRepaymentMode: repaymentmodes) {
                        
                        //added by gopika for 17509 
                        if (LAPprods.size() > 0) {
                            if (LAPprods.contains(loan.Product__c.toUppercase())) {
                                if (objRepaymentMode.Tranche_Detail__r.Tranche_Number__c == null) {
                                    ErrorFlag = true;
                                    //17556
                                    if (salmobilityv2flag)
                                        mobilitystatus = 'Tranche Number cannot be blank !!!';
                                    else {
                                        ApexPages.Message myMsg50 = new ApexPages.Message(ApexPages.Severity.INFO, 'Tranche Number cannot be blank !!!');
                                        Apexpages.addMessage(myMsg50);
                                    }
                                    validationFlag = true;
                                }
                            }
                        }
                        
                        
                        if (objRepaymentMode.A_C_NO__c != null) {
                            system.debug('---repaymentmodes[0].A_C_NO__c---' + objRepaymentMode.A_C_NO__c);
                            String RepayACNumber = objRepaymentMode.A_C_NO__c;
                            
                            system.debug('---RepayACNumber---' + RepayACNumber);
                            
                            if (!RepayACNumber.contains('0') && !RepayACNumber.contains('1') && !RepayACNumber.contains('2') && !RepayACNumber.contains('3') && !RepayACNumber.contains('4') && !RepayACNumber.contains('5') && !RepayACNumber.contains('6') && !RepayACNumber.contains('7') && !RepayACNumber.contains('8') && !RepayACNumber.contains('9')) {
                                system.debug('Inside ---RepayACNumber---');
                                ErrorFlag = true;
                                //17556 s
                                if (salmobilityv2flag)
                                    mobilitystatus = 'Ac No of Repayment Mode should should contain atleast one numeric digit !!!';
                                else {
                                    ApexPages.Message myMsg4 = new ApexPages.Message(ApexPages.Severity.INFO, 'Ac No of Repayment Mode should should contain atleast one numeric digit !!!');
                                    Apexpages.addMessage(myMsg4);
                                }
                                validationFlag = true;
                                //return null;
                            }
                            if (RepayACNumber.length() > 20) {
                                ErrorFlag = true;
                                //17556 s
                                if (salmobilityv2flag)
                                    mobilitystatus = 'Ac No of Repayment Mode length cannot be greater than 20 !!!';
                                else {
                                    ApexPages.Message myMsg5 = new ApexPages.Message(ApexPages.Severity.INFO, 'Ac No of Repayment Mode length cannot be greater than 20 !!!');
                                    Apexpages.addMessage(myMsg5);
                                }
                                validationFlag = true;
                                //return null;
                            }
                        }
                        
                        
                        if (objRepaymentMode.Repayment_Mode__c != null) {
                            //Validations if Repayment_Mode__c =='PDC'
                            if (objRepaymentMode.Repayment_Mode__c == 'PDC') {
                                if (objRepaymentMode.PDC_By_Name__c == null || objRepaymentMode.PDC_By_Name__c == '') {
                                    ErrorFlag = true;
                                    //17556 s
                                    if (salmobilityv2flag)
                                        mobilitystatus = 'Repayment Mode Details "PDC By Name" field should not be blank or null !!!';
                                    else {
                                        ApexPages.Message myMsg51 = new ApexPages.Message(ApexPages.Severity.INFO, 'Repayment Mode Details "PDC By Name" field should not be blank or null !!!');
                                        Apexpages.addMessage(myMsg51);
                                    }
                                    validationFlag = true;
                                    //return null;
                                }
                                if (objRepaymentMode.PDC_START_DATE__c == null) {
                                    ErrorFlag = true;
                                    //17556 s
                                    if (salmobilityv2flag)
                                        mobilitystatus = 'Repayment Mode Details "PDC START DATE" field should not be blank or null !!!';
                                    else {
                                        ApexPages.Message myMsg56 = new ApexPages.Message(ApexPages.Severity.INFO, 'Repayment Mode Details "PDC START DATE" field should not be blank or null !!!');
                                        Apexpages.addMessage(myMsg56);
                                    }
                                    validationFlag = true;
                                    //return null;
                                }
                                if (objRepaymentMode.Cheque_Amount__c == null) {
                                    ErrorFlag = true;
                                    //17556 s
                                    if (salmobilityv2flag)
                                        mobilitystatus = 'Repayment Mode Details "Cheque Amount" field should not be blank or null !!!';
                                    else {
                                        ApexPages.Message myMsg59 = new ApexPages.Message(ApexPages.Severity.INFO, 'Repayment Mode Details "Cheque Amount" field should not be blank or null !!!');
                                        Apexpages.addMessage(myMsg59);
                                    }
                                    validationFlag = true;
                                    //return null;
                                }
                                if (objRepaymentMode.IFSC_Code__c == null || objRepaymentMode.IFSC_Code__c == '') {
                                    ErrorFlag = true;
                                    //17556 s
                                    if (salmobilityv2flag)
                                        mobilitystatus = 'Repayment Mode Details "IFSC Code" field should not be blank or null !!!';
                                    else {
                                        ApexPages.Message myMsg60 = new ApexPages.Message(ApexPages.Severity.INFO, 'Repayment Mode Details "IFSC Code" field should not be blank or null !!!');
                                        Apexpages.addMessage(myMsg60);
                                    }
                                    validationFlag = true;
                                    //return null;
                                }
                                if (objRepaymentMode.MICR_Code__c == null) {
                                    ErrorFlag = true;
                                    //17556 s
                                    if (salmobilityv2flag)
                                        mobilitystatus = 'Repayment Mode Details "MICR Code" field should not be blank or null !!!';
                                    else {
                                        ApexPages.Message myMsg61 = new ApexPages.Message(ApexPages.Severity.INFO, 'Repayment Mode Details "MICR Code" field should not be blank or null !!!');
                                        Apexpages.addMessage(myMsg61);
                                    }
                                    validationFlag = true;
                                    //return null;
                                }
                                
                                
                            }
                            //Validations if Repayment_Mode__c =='ECS'
                            if (objRepaymentMode.Repayment_Mode__c == 'ECS') {
                                if (objRepaymentMode.ECS_Start_Date__c == null) {
                                    ErrorFlag = true;
                                    //17556 s
                                    if (salmobilityv2flag)
                                        mobilitystatus = 'Repayment Mode Details "ECS Start Date" field should not be blank or null !!!';
                                    else {
                                        ApexPages.Message myMsg52 = new ApexPages.Message(ApexPages.Severity.INFO, 'Repayment Mode Details "ECS Start Date" field should not be blank or null !!!');
                                        Apexpages.addMessage(myMsg52);
                                    }
                                    validationFlag = true;
                                    //return null;
                                }
                                if (objRepaymentMode.ECS_End_Date__c == null) {
                                    ErrorFlag = true;
                                    //17556 s
                                    if (salmobilityv2flag)
                                        mobilitystatus = 'Repayment Mode Details "ECS End Date" field should not be blank or null !!!';
                                    else {
                                        ApexPages.Message myMsg53 = new ApexPages.Message(ApexPages.Severity.INFO, 'Repayment Mode Details "ECS End Date" field should not be blank or null !!!');
                                        Apexpages.addMessage(myMsg53);
                                    }
                                    validationFlag = true;
                                    //return null;
                                }
                                if (objRepaymentMode.ECS_End_Date__c != null && objRepaymentMode.Open_Valid_till__c != null) {
                                    system.debug('---objRepaymentMode.ECS_End_Date__c---' + objRepaymentMode.ECS_End_Date__c);
                                    system.debug('---objRepaymentMode.Open_Valid_till__c---' + objRepaymentMode.Open_Valid_till__c);
                                    if (objRepaymentMode.ECS_End_Date__c != objRepaymentMode.Open_Valid_till__c) {
                                        ErrorFlag = true;
                                        //17556 s
                                        if (salmobilityv2flag)
                                            mobilitystatus = 'Repayment Mode Details "ECS End Date" should be equal to "Open Valid Till Date" !!!';
                                        else {
                                            ApexPages.Message myMsg513 = new ApexPages.Message(ApexPages.Severity.INFO, 'Repayment Mode Details "ECS End Date" should be equal to "Open Valid Till Date" !!!');
                                            Apexpages.addMessage(myMsg513);
                                        }
                                        validationFlag = true;
                                        //return null;
                                    }
                                }
                                if (objRepaymentMode.Open_Valid_till__c == null) {
                                    ErrorFlag = true;
                                    //17556 s
                                    if (salmobilityv2flag)
                                        mobilitystatus = 'Repayment Mode Details "Open Valid till" field should not be blank or null !!!';
                                    else {
                                        ApexPages.Message myMsg54 = new ApexPages.Message(ApexPages.Severity.INFO, 'Repayment Mode Details "Open Valid till" field should not be blank or null !!!');
                                        Apexpages.addMessage(myMsg54);
                                    }
                                    validationFlag = true;
                                    //return null;
                                }
                                if (objRepaymentMode.Open_ECS_Facility__c == null || objRepaymentMode.Open_ECS_Facility__c == '') {
                                    ErrorFlag = true;
                                    //17556 s
                                    if (salmobilityv2flag)
                                        mobilitystatus = 'Repayment Mode Details "Open ECS Facility" field should not be blank or null !!!';
                                    else {
                                        ApexPages.Message myMsg55 = new ApexPages.Message(ApexPages.Severity.INFO, 'Repayment Mode Details "Open ECS Facility" field should not be blank or null !!!');
                                        Apexpages.addMessage(myMsg55);
                                    }
                                    validationFlag = true;
                                    //return null;
                                }
                                
                                if (objRepaymentMode.Open_ECS_Max_Limit__c == null) {
                                    ErrorFlag = true;
                                    //17556 s
                                    if (salmobilityv2flag)
                                        mobilitystatus = 'Repayment Mode Details "Open ECS Max Limit" field should not be blank or null !!!';
                                    else {
                                        ApexPages.Message myMsg57 = new ApexPages.Message(ApexPages.Severity.INFO, 'Repayment Mode Details "Open ECS Max Limit" field should not be blank or null !!!');
                                        Apexpages.addMessage(myMsg57);
                                    }
                                    validationFlag = true;
                                    //return null;
                                } else {
                                    if (objRepaymentMode.ECS_Amount__c != null) {
                                        if (objRepaymentMode.Open_ECS_Max_Limit__c != objRepaymentMode.ECS_Amount__c) {
                                            ErrorFlag = true;
                                            //17556 s
                                            if (salmobilityv2flag)
                                                mobilitystatus = 'Repayment Mode Details "Open ECS Max Limit" and "ECS Amount" should be equal !!!';
                                            else {
                                                ApexPages.Message myMsg527 = new ApexPages.Message(ApexPages.Severity.INFO, 'Repayment Mode Details "Open ECS Max Limit" and "ECS Amount" should be equal !!!');
                                                Apexpages.addMessage(myMsg527);
                                            }
                                            validationFlag = true;
                                            //return null;
                                        }
                                    }
                                    if (Loan.EMI_CAM__c != null) {
                                        if (objRepaymentMode.Open_ECS_Max_Limit__c == Loan.EMI_CAM__c) {} else {
                                            if (objRepaymentMode.Open_ECS_Max_Limit__c > Loan.EMI_CAM__c) {} else {
                                                ErrorFlag = true;
                                                //17556 s
                                                if (salmobilityv2flag)
                                                    mobilitystatus = 'Repayment Mode Details "Open ECS Max Limit" should be greater than or equal to "EMI" of Loan Application !!!';
                                                else {
                                                    ApexPages.Message myMsg527 = new ApexPages.Message(ApexPages.Severity.INFO, 'Repayment Mode Details "Open ECS Max Limit" should be greater than or equal to "EMI" of Loan Application !!!');
                                                    Apexpages.addMessage(myMsg527);
                                                }
                                                validationFlag = true;
                                                //return null;
                                            }
                                        }
                                    }
                                }
                                if (objRepaymentMode.IFSC_Code__c == null || objRepaymentMode.IFSC_Code__c == '') {
                                    ErrorFlag = true;
                                    //17556 s
                                    if (salmobilityv2flag)
                                        mobilitystatus = 'Repayment Mode Details "IFSC Code" field should not be blank or null !!!';
                                    else {
                                        ApexPages.Message myMsg62 = new ApexPages.Message(ApexPages.Severity.INFO, 'Repayment Mode Details "IFSC Code" field should not be blank or null !!!');
                                        Apexpages.addMessage(myMsg62);
                                    }
                                    validationFlag = true;
                                    //return null;
                                }
                                if (objRepaymentMode.MICR_Code__c == null) {
                                    ErrorFlag = true;
                                    //17556 s
                                    if (salmobilityv2flag)
                                        mobilitystatus = 'Repayment Mode Details "MICR Code" field should not be blank or null !!!';
                                    else {
                                        ApexPages.Message myMsg63 = new ApexPages.Message(ApexPages.Severity.INFO, 'Repayment Mode Details "MICR Code" field should not be blank or null !!!');
                                        Apexpages.addMessage(myMsg63);
                                    }
                                    validationFlag = true;
                                    //return null;
                                }
                            }
                        } else {
                            ErrorFlag = true;
                            //17556 s
                            if (salmobilityv2flag)
                                mobilitystatus = 'Repayment Mode Details "Repayment Mode" field should not be blank or null !!!';
                            else {
                                ApexPages.Message myMsg58 = new ApexPages.Message(ApexPages.Severity.INFO, 'Repayment Mode Details "Repayment Mode" field should not be blank or null !!!');
                                Apexpages.addMessage(myMsg58);
                            }
                            validationFlag = true;
                            //return null;
                            
                        }
                        
                    }
                } else {
                    
                    ErrorFlag = true;
                    if (salmobilityv2flag)
                        mobilitystatus = 'Repayment mode cannot be blank!!!!';
                    else {
                        ApexPages.Message myMsg50 = new ApexPages.Message(ApexPages.Severity.INFO, 'Repayment mode cannot be blank!!!!');
                        Apexpages.addMessage(myMsg50);
                    }
                    validationFlag = true;
                    //return null;
                }
                
                // Decentralized Disb code End
            }
            
            if (Loan != null) {
                Decimal tenor;
                //Mortgage march Point No 14 Added condition for group type  
                System.Debug('Loan.product__c ' + Loan.product__c + ' Loan.Account.Group_Type__c' + Loan.Account.Group_Type__c + ' Loan.Approved_Tenor__c ' + Loan.Approved_Tenor__c);
                if (Loan.product__c == 'LAP' && Loan.Account.Group_Type__c == null) {
                    System.Debug('Test LAP & Group Type');
                    if (Loan.Approved_Tenor__c != null) {
                        //System.debug('Test Aprpoved Tenor');
                        //if (!Loan.Scheme_Master__r.Name.contains('Flexi')) {
                        //System.Debug('Test Flexi scheme');
                        //tenor = Loan.Approved_Tenor__c * 12;
                        //} else {
                        
                        //} Commentted above code as all the Tenor are in months now Done By Rajendra for BUG ID 17517
                        tenor = Loan.Approved_Tenor__c;
                    }
                } else {
                    System.Debug('Default Elese for tenor');
                    tenor = Loan.Approved_Tenor__c;
                }
                if (tenor != null) {
                    string tenorLength = string.valueof(tenor);
                    //system.debug('---tenorLength---'+tenorLength);
                    system.debug('---tenorLength.length()---' + tenorLength.length());
                    if (tenorLength.length() > 3) {
                        System.Debug('Tenor Length is greater than 3');
                        ErrorFlag = true;
                        //17556 s
                        if (salmobilityv2flag)
                            mobilitystatus = 'Tenor Cannot be more than 3 digits !!!';
                        else {
                            ApexPages.Message myMsg6 = new ApexPages.Message(ApexPages.Severity.INFO, 'Tenor Cannot be more than 3 digits !!!');
                            Apexpages.addMessage(myMsg6);
                        }
                        validationFlag = true;
                        //return null;
                    }
                }
                
            }
            if (properties.size() > 0 && Loan.Product__c != 'FAS') {
                Integer porpCount = properties.size();
                system.debug('---porpCount---' + porpCount);
                // Start of Mortgage production issues 15 Nov - Point 109  
                // if (MortgageSMEProductsFlag && (Loan.Branch_Name__r.Name.touppercase() =='BANGALORE' || Loan.Branch_Name__r.Name.touppercase() =='MUMBAI' || Loan.Branch_Name__r.Name.touppercase() =='DELHI' || Loan.Branch_Name__r.Name.touppercase() =='PUNE' || Loan.Branch_Name__r.Name.touppercase() =='HYDERABAD')) {
                /**Bug id: 11705 - hard coded branch nd products -validation related to geo tagging on send to finnone. **/
                LaonApplicationCreation__c MortgageFlow = LaonApplicationCreation__c.getValues(Loan.Product__c);
                Set < String > branchList = new Set < String > ();
                Boolean MortgageGeoTag = false;
                if (MortgageFlow != null) {
                    if (MortgageFlow.BranchNames__c != null) {
                        for (String str: MortgageFlow.BranchNames__c.ToUppercase().split(';')) {
                            system.debug('str::' + str);
                            if (str == Loan.Branch_Name__r.Name.toUpperCase()) {
                                MortgageGeoTag = true;
                                system.debug('MortgageGeoTag::' + MortgageGeoTag);
                            }
                        }
                    }
                    if (MortgageFlow.BranchNamesNew__c != null) {
                        for (String str1: MortgageFlow.BranchNamesNew__c.ToUppercase().split(';')) {
                            system.debug('str1::' + str1);
                            if (str1 == Loan.Branch_Name__r.Name.toUpperCase()) {
                                MortgageGeoTag = true;
                                system.debug('MortgageGeoTag::' + MortgageGeoTag);
                            }
                        }
                    }
                    //bug 12568: added more fields for geo tagging start
                    if (MortgageFlow.branchnamesnew1__c != null) {
                        for (String str1: MortgageFlow.branchnamesnew1__c.ToUppercase().split(';')) {
                            system.debug('str1::' + str1);
                            if (str1 == Loan.Branch_Name__r.Name.toUpperCase()) {
                                MortgageGeoTag = true;
                                system.debug('MortgageGeoTag::' + MortgageGeoTag);
                            }
                        }
                    }
                    
                    if (MortgageFlow.branchnamesnew2__c != null) {
                        for (String str1: MortgageFlow.branchnamesnew2__c.ToUppercase().split(';')) {
                            system.debug('str1::' + str1);
                            if (str1 == Loan.Branch_Name__r.Name.toUpperCase()) {
                                MortgageGeoTag = true;
                                system.debug('MortgageGeoTag::' + MortgageGeoTag);
                            }
                        }
                    }
                    
                    if (MortgageFlow.branchnamesnew3__c != null) {
                        for (String str1: MortgageFlow.branchnamesnew3__c.ToUppercase().split(';')) {
                            system.debug('str1::' + str1);
                            if (str1 == Loan.Branch_Name__r.Name.toUpperCase()) {
                                MortgageGeoTag = true;
                                system.debug('MortgageGeoTag::' + MortgageGeoTag);
                            }
                        }
                    }
                    
                    
                    // bug 12568 end
                }
                if (MortgageGeoTag) {
                    if (surrogateList != null && surrogateList.size() > 0) {
                        boolean isGeoTaggingDone = true;
                        String propertyName;
                        //YK - 12866 start
                        List < Property_Details__c > propertiesListNew = new List < Property_Details__c > ();
                        if (MortgageFlow.Mortgage_Skip_Geo_Tagging_Validation__c == true) {
                            for (Property_Details__c propObj: properties) {
                                if (Loan.Branch_Name__r.Name != null && propObj.Property_City__c != null) {
                                    if ((String.valueOf(Loan.Branch_Name__r.Name)).toUpperCase() == (String.valueOf(propObj.Property_City__c)).toUpperCase()) {
                                        propertiesListNew.add(propObj);
                                    }
                                }
                            }
                        } else {
                            propertiesListNew.addAll(properties);
                        }
                        //YK - 12866 end
                        
                        for (Property_Details__c propObj: propertiesListNew) { //bug 12866
                            if (propObj.sallap_scheme__c == 'No' || propObj.SALLAP_scheme__c == '') { // Bug-17095
                                if (propObj.Property_Identified__c == 'Yes' && ((propObj.Property_Pic_1__latitude__s == null && propObj.Property_Pic_1__longitude__s == null) || (propObj.Property_Pic_2__latitude__s == null && propObj.Property_Pic_2__longitude__s == null) || (propObj.Property_Pic_3__latitude__s == null && propObj.Property_Pic_3__longitude__s == null))) {
                                    isGeoTaggingDone = false;
                                    propertyName = propObj.Name;
                                    break;
                                }
                            }
                        }
                        if (!isGeoTaggingDone) {
                            ErrorFlag = true;
                            //17556 s
                            if (salmobilityv2flag)
                                mobilitystatus = 'Please upload all photograph with Geo Tagging for property name : ' + propertyName;
                            else {
                                ApexPages.Message myMsg711 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please upload all photograph with Geo Tagging for property name : ' + propertyName);
                                Apexpages.addMessage(myMsg711);
                            }
                            validationFlag = true;
                        }
                    }
                }
                // End of Mortgage production issues 15 Nov - Point 109
                if (porpCount < 5) {
                    system.debug('---Inside if propcount is less than 5 ');
                    /*Address Limit changed from 35 to 50 by Aishwarya - BUG ID 18424*/
                    
                    for (integer i = 0; i < porpCount; i++) {
                        if (properties[i].Property_Address_Line_1__c != null && properties[i].Property_Address_Line_2__c != null && properties[i].Property_Address_Line_3__c != null) {
                            if (properties[i].Property_Address_Line_1__c.length() > 50 || properties[i].Property_Address_Line_2__c.length() > 50 || properties[i].Property_Address_Line_3__c.length() > 50) {
                                
                                ErrorFlag = true;
                                //17556 s
                                if (salmobilityv2flag)
                                    mobilitystatus = 'Property Address 1/2/3 should not me more than 35 character !!!';
                                else {
                                    ApexPages.Message myMsg7 = new ApexPages.Message(ApexPages.Severity.INFO, 'Property Address 1/2/3 should not me more than 35 character !!!');
                                    Apexpages.addMessage(myMsg7);
                                }
                                validationFlag = true;
                                //return null;
                            }
                        } else {
                            if (properties[i].Property_Address_Line_1__c == null || properties[i].Property_Address_Line_1__c == '') {
                                ErrorFlag = true;
                                //17556 s
                                if (salmobilityv2flag)
                                    mobilitystatus = 'Property Address 1 should not be null or blank !!!';
                                else {
                                    ApexPages.Message myMsg8 = new ApexPages.Message(ApexPages.Severity.INFO, 'Property Address 1 should not be null or blank !!!');
                                    Apexpages.addMessage(myMsg8);
                                }
                                validationFlag = true;
                                //return null;
                            }
                            if (properties[i].Property_Address_Line_2__c == null || properties[i].Property_Address_Line_2__c == '') {
                                ErrorFlag = true;
                                //17556 s
                                if (salmobilityv2flag)
                                    mobilitystatus = 'Property Address 2 should not be null or blank !!!';
                                else {
                                    ApexPages.Message myMsg9 = new ApexPages.Message(ApexPages.Severity.INFO, 'Property Address 2 should not be null or blank !!!');
                                    Apexpages.addMessage(myMsg9);
                                }
                                validationFlag = true;
                                //return null;
                            }
                            if (properties[i].Property_Address_Line_3__c == null || properties[i].Property_Address_Line_3__c == '') {
                                ErrorFlag = true;
                                //17556 s
                                if (salmobilityv2flag)
                                    mobilitystatus = 'Property Address 3 should not be null or blank !!!';
                                else {
                                    ApexPages.Message myMsg10 = new ApexPages.Message(ApexPages.Severity.INFO, 'Property Address 3 should not be null or blank !!!');
                                    Apexpages.addMessage(myMsg10);
                                }
                                validationFlag = true;
                                //return null;
                            }
                            if (properties[i].Property_Address_Line_1__c != null) {
                                if (properties[i].Property_Address_Line_1__c.length() > 50) {
                                    ErrorFlag = true;
                                    //17556 s
                                    if (salmobilityv2flag)
                                        mobilitystatus = 'Property Address 1 should not me more than 50 character !!!';
                                    else {
                                        ApexPages.Message myMsg11 = new ApexPages.Message(ApexPages.Severity.INFO, 'Property Address 1 should not me more than 50 character !!!');
                                        Apexpages.addMessage(myMsg11);
                                    }
                                    validationFlag = true;
                                    //return null;
                                }
                            }
                            if (properties[i].Property_Address_Line_2__c != null) {
                                if (properties[i].Property_Address_Line_2__c.length() > 50) {
                                    ErrorFlag = true;
                                    if (salmobilityv2flag)
                                        mobilitystatus = 'Property Address 2 should not me more than 50 character !!!';
                                    else {
                                        ApexPages.Message myMsg12 = new ApexPages.Message(ApexPages.Severity.INFO, 'Property Address 2 should not me more than 50 character !!!');
                                        Apexpages.addMessage(myMsg12);
                                    }
                                    validationFlag = true;
                                    //return null;
                                }
                            }
                            if (properties[i].Property_Address_Line_3__c != null) {
                                if (properties[i].Property_Address_Line_3__c.length() > 50) {
                                    ErrorFlag = true;
                                    //17556 s
                                    if (salmobilityv2flag)
                                        mobilitystatus = 'Property Address 3 should not me more than 50 character !!!';
                                    else {
                                        ApexPages.Message myMsg13 = new ApexPages.Message(ApexPages.Severity.INFO, 'Property Address 3 should not me more than 50 character !!!');
                                        Apexpages.addMessage(myMsg13);
                                    }
                                    validationFlag = true;
                                    //return null;
                                }
                            }
                            
                        }
                    }
                } else {
                    system.debug('---Inside else propcount is greater than 5 ');
                    for (integer i = 0; i < 5; i++) {
                        if (properties[i].Property_Address_Line_1__c != null && properties[i].Property_Address_Line_2__c != null && properties[i].Property_Address_Line_3__c != null) {
                            if (properties[i].Property_Address_Line_1__c.length() > 50 || properties[i].Property_Address_Line_2__c.length() > 50 || properties[i].Property_Address_Line_3__c.length() > 50) {
                                
                                ErrorFlag = true;
                                //17556 s
                                if (salmobilityv2flag)
                                    mobilitystatus = 'Property Address 1/2/3 should not me more than 50 character !!!';
                                else {
                                    ApexPages.Message myMsg14 = new ApexPages.Message(ApexPages.Severity.INFO, 'Property Address 1/2/3 should not me more than 50 character !!!');
                                    Apexpages.addMessage(myMsg14);
                                }
                                validationFlag = true;
                                //return null;
                            }
                        } else {
                            if (properties[i].Property_Address_Line_1__c == null || properties[i].Property_Address_Line_1__c == '') {
                                ErrorFlag = true;
                                //17556 s
                                if (salmobilityv2flag)
                                    mobilitystatus = 'Property Address 1 should not be null or blank !!!';
                                else {
                                    ApexPages.Message myMsg15 = new ApexPages.Message(ApexPages.Severity.INFO, 'Property Address 1 should not be null or blank !!!');
                                    Apexpages.addMessage(myMsg15);
                                }
                                validationFlag = true;
                                //return null;
                            }
                            if (properties[i].Property_Address_Line_2__c == null || properties[i].Property_Address_Line_2__c == '') {
                                ErrorFlag = true;
                                //17556 s
                                if (salmobilityv2flag)
                                    mobilitystatus = 'Property Address 2 should not be null or blank !!!';
                                else {
                                    ApexPages.Message myMsg16 = new ApexPages.Message(ApexPages.Severity.INFO, 'Property Address 2 should not be null or blank !!!');
                                    Apexpages.addMessage(myMsg16);
                                }
                                validationFlag = true;
                                //return null;
                            }
                            if (properties[i].Property_Address_Line_3__c == null || properties[i].Property_Address_Line_3__c == '') {
                                ErrorFlag = true;
                                //17556 s
                                if (salmobilityv2flag)
                                    mobilitystatus = 'Property Address 3 should not be null or blank !!!';
                                else {
                                    ApexPages.Message myMsg17 = new ApexPages.Message(ApexPages.Severity.INFO, 'Property Address 3 should not be null or blank !!!');
                                    Apexpages.addMessage(myMsg17);
                                }
                                validationFlag = true;
                                //return null;
                            }
                            if (properties[i].Property_Address_Line_1__c != null) {
                                if (properties[i].Property_Address_Line_1__c.length() > 50) {
                                    ErrorFlag = true;
                                    //17556 s
                                    if (salmobilityv2flag)
                                        mobilitystatus = 'Property Address 1 should not me more than 50 character !!!';
                                    else {
                                        ApexPages.Message myMsg18 = new ApexPages.Message(ApexPages.Severity.INFO, 'Property Address 1 should not me more than 50 character !!!');
                                        Apexpages.addMessage(myMsg18);
                                    }
                                    validationFlag = true;
                                    //return null;
                                }
                            }
                            if (properties[i].Property_Address_Line_2__c != null) {
                                if (properties[i].Property_Address_Line_2__c.length() > 50) {
                                    ErrorFlag = true;
                                    //17556 s
                                    if (salmobilityv2flag)
                                        mobilitystatus = 'Property Address 2 should not me more than 50 character !!!';
                                    else {
                                        ApexPages.Message myMsg19 = new ApexPages.Message(ApexPages.Severity.INFO, 'Property Address 2 should not me more than 50 character !!!');
                                        Apexpages.addMessage(myMsg19);
                                    }
                                    validationFlag = true;
                                    //return null;
                                }
                            }
                            if (properties[i].Property_Address_Line_3__c != null) {
                                if (properties[i].Property_Address_Line_3__c.length() > 50) {
                                    ErrorFlag = true;
                                    //17556 s
                                    if (salmobilityv2flag)
                                        mobilitystatus = 'Property Address 3 should not me more than 50 character !!!';
                                    else {
                                        ApexPages.Message myMsg20 = new ApexPages.Message(ApexPages.Severity.INFO, 'Property Address 3 should not me more than 50 character !!!');
                                        Apexpages.addMessage(myMsg20);
                                    }
                                    validationFlag = true;
                                    //return null;
                                }
                            }
                        }
                    }
                }
            }
            system.debug('Validations for Applicants');
            if (apps.size() > 0 && apps != null) {
                for (Applicant__c applicant1: apps) {
                    if (applicant1.Contact_Name__c != null) {
                        if (applicant1.Applicant_Type__c != applicant1.Contact_Name__r.ApplicantType__c) {
                            ErrorFlag = true;
                            //17556 s
                            if (salmobilityv2flag)
                                mobilitystatus = 'Applicant and Contact Applicant Type field Mismatch !!!';
                            else {
                                ApexPages.Message myMsg21 = new ApexPages.Message(ApexPages.Severity.INFO, 'Applicant and Contact Applicant Type field Mismatch !!!');
                                Apexpages.addMessage(myMsg21);
                            }
                            validationFlag = true;
                            //return null;
                        }
                        if (applicant1.Contact_Name__r.Customer_Type__c == null) {
                            ErrorFlag = true;
                            //17556 s
                            if (salmobilityv2flag)
                                mobilitystatus = 'Contact Customer Type should not be null !!!';
                            else {
                                ApexPages.Message myMsg22 = new ApexPages.Message(ApexPages.Severity.INFO, 'Contact Customer Type should not be null !!!');
                                Apexpages.addMessage(myMsg22);
                            }
                            validationFlag = true;
                            //return null;
                        }
                        
                        if (applicant1.Contact_Name__r.Address_1__c != null) {
                            if (applicant1.Contact_Name__r.Address_1__c.length() > 50) {
                                ErrorFlag = true;
                                //17556 s
                                if (salmobilityv2flag)
                                    mobilitystatus = 'Contact Regi/Resi Address 1 should not me more than 50 character !!!';
                                else {
                                    ApexPages.Message myMsg23 = new ApexPages.Message(ApexPages.Severity.INFO, 'Contact Regi/Resi Address 1 should not me more than 50 character !!!');
                                    Apexpages.addMessage(myMsg23);
                                }
                                validationFlag = true;
                                //return null;
                            }
                        } else {
                            //24,25,26
                            ErrorFlag = true;
                            //17556 s
                            if (salmobilityv2flag)
                                mobilitystatus = 'Contact Regi/Resi Address 1 should not be null !!!';
                            else {
                                ApexPages.Message myMsg24 = new ApexPages.Message(ApexPages.Severity.INFO, 'Contact Regi/Resi Address 1 should not be null !!!');
                                Apexpages.addMessage(myMsg24);
                            }
                            validationFlag = true;
                        }
                        if (applicant1.Contact_Name__r.Pin_Code__c == null) {
                            ErrorFlag = true;
                            //17556 s
                            if (salmobilityv2flag)
                                mobilitystatus = 'Contact Pincode should not be null !!!';
                            else {
                                ApexPages.Message myMsg25 = new ApexPages.Message(ApexPages.Severity.INFO, 'Contact Pincode should not be null !!!');
                                Apexpages.addMessage(myMsg25);
                            }
                            validationFlag = true;
                            //return null;
                        } /* added for invisible monitoring by akshata 27th june 2016 start*/
                        /*---Added by Asmita - for Insurance BRD for SFDC---*/
                        // Below Code is commented for Integration purpose
                        /*if (applicant1.Contact_Name__r.Date_of_Birth__c == null) {
ErrorFlag = true;
String errMsg = 'Contact DOB of Applicant '+ applicant1.name + ' should not be NULL !!!';
//ApexPages.Message myMsg25 = new ApexPages.Message(ApexPages.Severity.INFO, 'Contact DOB should not be null !!!');
ApexPages.Message myMsg25 = new ApexPages.Message(ApexPages.Severity.INFO, errMsg);
Apexpages.addMessage(myMsg25);
validationFlag = true;
}
if (applicant1.Contact_Name__r.Gender__c == null) {
ErrorFlag = true;
String errMsg = 'Contact Gender of Applicant '+ applicant1.name + ' should not be NULL !!!';
//ApexPages.Message myMsg25 = new ApexPages.Message(ApexPages.Severity.INFO, 'Contact Gender should not be null !!!');
ApexPages.Message myMsg25 = new ApexPages.Message(ApexPages.Severity.INFO, errMsg);
Apexpages.addMessage(myMsg25);
validationFlag = true;
}*/
                        /*---Added by Asmita - end ---*/
                        
                        //SAL Invisible monitoring start (Bug 13374)
                        //Changed By Rajendra:- BUG ID :- 16418:- OR Condition is changed into && condition cause even though All RSA Verifications were marked as not fraud then due to RSA flag condition it was giving Error.
                        //Added condition of applicant1.RSA_Loan_application_status__c == 'Fraud' for RSA Automation 16418
                        else if (((applicant1.RSA_flag__c == true && applicant1.RSA_Loan_application_status__c == 'Fraud') && (Loan.product__c == 'DOCTORS' || isPROProductLineProduct || Loan.product__c == 'PSBL')) || ((applicant1.RSA_flag__c == true && applicant1.RSA_Loan_application_status__c == 'Fraud') && ((applicant1.RCU_Status__c == null) || (applicant1.RCU_Status__c == 'Fraud') || (applicant1.RCU_Status__c == 'Negative')) && (Loan.product__c == 'SAL' || Loan.product__c == 'SPL'))) {
                            ErrorFlag = true;
                            //17556 s
                            if (salmobilityv2flag)
                            {
                                if(string.isNotBlank(Label.RSA_Finnone_Products) && !Label.RSA_Finnone_Products.containsIgnoreCase(Loan.product__c))
                                    mobilitystatus = 'This loan application is identified for fraud.';
                            }
                            else {
                                if(string.isNotBlank(Label.RSA_Finnone_Products) && !Label.RSA_Finnone_Products.containsIgnoreCase(Loan.product__c))
                                {
                                    ApexPages.Message myMsg26 = new ApexPages.Message(ApexPages.Severity.INFO, 'This loan application is identified for fraud.');
                                    Apexpages.addMessage(myMsg26);
                                }
                            }
                            //System.debug('rohit finn');
                            //SAL Invisible monitoring end
                            validationFlag = true;
                        } /* added for invisible monitoring by akshata 27th june 2016 end*/
                    }
                    
                    //Bug 16173 - VRPL changes for HFC Start :  Added Parent Deal ID validation
                    try {
                        System.debug('Loan : ' + Loan.Id);
                        if (Loan != null && Loan.Scheme_Master__c != null && applicant1 != null && applicant1.Applicant_Type__c == 'Primary') {
                            if (Loan.Scheme_Master__r.VRPL_Flag__c != null && Loan.Scheme_Master__r.VRPL_Flag__c == 'YES' && (applicant1.Parent_Deal_ID__c == null || applicant1.Parent_Deal_ID__c == '')) {
                                //17556 s
                                if (salmobilityv2flag)
                                    mobilitystatus = 'Parent Deal ID is mandatory as this is a VRPL case';
                                else {
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Parent Deal ID is mandatory as this is a VRPL case'));
                                    validationFlag = true;
                                }
                                
                            }
                        }
                    } catch (Exception e) {
                        System.debug('Exception Occurred :' + e);
                    }
                    //Bug 16173 - VRPL changes for HFC End :  Added Parent Deal ID validation
                    
                }
            }
            system.debug('Validations for DPLInsurance records');
            /*Code added by Asmita Rajput. (Insurance BRD for SFDC)
Comment : code to flow DPLinsurance fields to FinnOne Report and Document Finnone Report
*/
            Set < String > hdfcProductLblSet = new Set < String > ();
            Boolean msgFlag = false;
            String errMsg;
            Map < String, List < String >> errMsgMap = new Map < String, List < String >> ();
            List < String > emptyFieldsList = new List < String > ();
            if (Label.HDFCInsuranceProduct != null) {
                String[] name = Label.HDFCInsuranceProduct.split(';');
                for (String str: name)
                    hdfcProductLblSet.add(str);
            }
            
            if (ListDPLinsurance != null && ListDPLinsurance.size() > 0) {
                // start nominee validation for products changes by rohit mourya
                String jsonString;
                Boolean isJsonFound = true;
                
                map < String, String > mapProduct = new map < String, String > ();
                if (srList != null && srList.size() > 0) {
                    for (StaticResource sr: srList) {
                        if (sr.Name == 'NomineeProducts')
                            jsonString = sr.Body.toString();
                    }
                    //jsonString = srList[0].Body.toString();
                } else {
                    isJsonFound = false;
                }
                if (isJsonFound) {
                    Map < String, Object > jsonBody = (Map < String, Object > ) JSON.deserializeUntyped(jsonString);
                    Map < String, Object > jsonField = (Map < String, Object > ) jsonBody.get('NomineeProducts');
                    
                    for (String key: jsonField.keySet()) {
                        //System.debug('Key:'+key+'  Value:'+jsonField.get(key));
                        String value = (String) jsonField.get(key);
                        mapProduct.put(key.toUpperCase(), value.toUpperCase());
                    }
                }
                // end nominee validation for products changes by rohit mourya
                for (DPLinsurance__c dplIns: ListDPLinsurance) {
                    errMsgMap.clear();
                    emptyFieldsList.clear();
                    // start nominee validation for products changes by rohit mourya
                    String product = '';
                    if (String.isNotBlank(dplIns.Insurance_Type__c) && String.isNotBlank(dplIns.Insurance_Product__c))
                        product = dplIns.Insurance_Type__c.toUpperCase() + '- ' + dplIns.Insurance_Product__c.toUpperCase();
                    // end nominee validation for products changes by rohit mourya
                    if (dplIns.Applicant__c == null) {
                        emptyFieldsList.add('Applicant');
                        msgFlag = true;
                    }
                    if (String.isBlank(dplIns.Insurer_Name__c)) {
                        emptyFieldsList.add('Insurer Name');
                        msgFlag = true;
                    }
                    
                    if (String.isBlank(dplIns.Insurance_term__c)) {
                        emptyFieldsList.add('Insurance Term');
                        msgFlag = true;
                    }
                    // Added for BUG -11570 - start
                    if (String.isBlank(dplIns.Insurance_ID__c)) {
                        emptyFieldsList.add('Insurance ID');
                        msgFlag = true;
                    }
                    // start nominee validation for products changes by rohit mourya
                    if (mapProduct.containsKey(product)) {
                        // Added for BUG -11570 - end
                        if (String.isBlank(dplIns.Nominee_Name__c)) {
                            emptyFieldsList.add('Nominee Name');
                            msgFlag = true;
                        }
                        
                        if (String.isBlank(String.valueOf(dplIns.Nominee_DOB__c))) {
                            emptyFieldsList.add('Nominee DOB');
                            msgFlag = true;
                        }
                        
                        if (String.isBlank(String.valueOf(dplIns.Nominee_Mobile__c))) {
                            emptyFieldsList.add('Nominee Mobile');
                            msgFlag = true;
                        }
                        
                        if (String.isBlank(String.valueOf(dplIns.Nominee_Age__c))) {
                            emptyFieldsList.add('Nominee Age');
                            msgFlag = true;
                        }
                        
                        // Mapping changed from Nominee Relationship with policy holder to Nominee_Relationship__c
                        //if(String.isBlank(dplIns.Nominee_Relationship__c)){
                        //    emptyFieldsList.add('Nominee Relationship');
                        //    msgFlag = true; 
                        //}
                        
                        if (String.isBlank(dplIns.Nominee_Address__c)) {
                            emptyFieldsList.add('Nominee Address');
                            msgFlag = true;
                        }
                    }
                    // end nominee validation for products changes by rohit mourya
                    if (String.isBlank(dplIns.Premium_Amount__c)) {
                        emptyFieldsList.add('premium Amount');
                        msgFlag = true;
                    }
                    
                    if (String.isBlank(String.valueOf(dplIns.Sum_Assured__c))) {
                        if (hdfcProductLblSet.contains(dplIns.Insurance_Product__c)) {
                            emptyFieldsList.add('Sum Assured');
                            msgFlag = true;
                        }
                    }
                    // Bug - 12609 -start
                    /*if(dplIns.Form_Handover__c == null){
emptyFieldsList.add('From Handover');
msgFlag = true;
}*/
                    
                    
                    /*--- Enhancement: Insurance BRD for SFDC Phase 2----
Rohit Mourya: Fields added for Insurance BRD for SFDC Phase 2 --*/
                    
                    /*if(dplIns.Nominee_Age__c != null && Integer.valueOf(dplIns.Nominee_Age__c) < 18){
if(dplIns.Appointee_DOB__c == null){
emptyFieldsList.add('Appointee DOB');
msgFlag = true;
}
if(dplIns.Appointee_Name__c == null){
emptyFieldsList.add('Appointee Name');
msgFlag = true;
}
if(dplIns.Discrepant_Resolution__c == null){
emptyFieldsList.add('BFL Discrepant Resolution');
msgFlag = true;
}
if(dplIns.Discrepant_at_TCS__c == null){
emptyFieldsList.add('Discrepant at TCS');
msgFlag = true;
}
if(dplIns.Source__c == null){
emptyFieldsList.add('Source');
msgFlag = true;
}
if(dplIns.Insurance_form_number__c == null){
emptyFieldsList.add('Insurance form number ');
msgFlag = true;
}
}*/
                    //Bug - 12609 end
                    /*Rohit Mourya: Fields added for Insurance BRD for SFDC Phase 2 --- End----*/
                    // Bug - 12609 - end
                    if (msgFlag == true) {
                        system.debug('emptyFieldsList ::' + emptyFieldsList);
                        
                        errMsgMap.put(dplIns.Insurance_Product__c, emptyFieldsList);
                        system.debug('errMsgMap::' + errMsgMap);
                        
                        if (!emptyFieldsList.isEmpty()) {
                            errMsg = 'Fields :' + errMsgMap.get(dplIns.Insurance_Product__c) + ' of ' + dplIns.Insurance_Product__c + ' insurance are missing !!!';
                            //17556 s
                            if (salmobilityv2flag)
                                mobilitystatus = errMsg;
                            else {
                                ApexPages.Message insMsg = new ApexPages.Message(ApexPages.Severity.INFO, errMsg);
                                Apexpages.addMessage(insMsg);
                            }
                        }
                        
                        ErrorFlag = true;
                        validationFlag = true;
                    }
                    if (dplIns.Applicant__c != null && String.isNotBlank(dplIns.Insurer_Name__c) && !dplIns.Insurer_Name__c.equalsIgnoreCase(dplIns.Applicant__r.Contact_Name__r.Name)) {
                        errMsg = 'For product : ' + dplIns.Insurance_Product__c + ' Insurer Name and Contact Name on its Applicant are different! For Send to Finnone, they must be the same.';
                        //17556 s
                        if (salmobilityv2flag)
                            mobilitystatus = errMsg;
                        else {
                            ApexPages.Message insMsg = new ApexPages.Message(ApexPages.Severity.INFO, errMsg);
                            Apexpages.addMessage(insMsg);
                        }
                        ErrorFlag = true;
                        validationFlag = true;
                    }
                }
            }
            
            /*--------code added by Asmita end-------------*/
            
            /*Code added by Asmita.
Enhancement :11735 : Insurance Premium Validation  */
            // start new changes
            // added product check to fire validation
            Set < String > allProductSet = new Set < String > (label.Loan_Products.split(';'));
            if (label.InsurancePremiumValidationSwitch.containsIgnoreCase('true') && allProductSet.contains(Loan.Product__c)) {
                system.debug('Inside true !!');
                premiumChrgAmtValidation();
            }
            
            
            // end new changes    
            system.debug('validationFlag 111 !!' + validationFlag);
            if (validationFlag == true) {
                return null;
            }
            // Finnone Validation Starts Bug 5048 Ends
            else {
                system.debug('ListDPLinsurance before firstStep***' + ListDPLinsurance);
                firstStep(Loan, properties, apps, verificationRec);
                if (validationFlag == true)
                    return null;
            }
            
        }
        system.debug('funcation call ends');
        
        
        //10603 Collateral Communication Start
        try {
            System.debug('Collateral COmmunication Start............................................');
            //-- #19281 :Profile OpsProfile=[select Id,Name from Profile where Name='OPs Officer' limit 1 ]; // temporary  or   Name='Sys Admin Persistent/ OPs Officer'
            //Profile sysAdminPersiProfile=[select Id,Name from Profile where Name='Sys Admin Persistent' limit 1 ];
            
            //-- #start : #19281 adding support for CPA Login partner profile.          
            Map < Id, Profile > OpsProfile = new Map < Id, Profile > ([SELECT Id, Name from Profile where Name = 'OPs Officer'
                                                                       or Name = 'CPA Login Partner'
                                                                      ]);
            //--#19281 if(UserInfo.getProfileId()==OpsProfile ){  //|| UserInfo.getProfileId()==sysAdminPersiProfile.Id
            
            if (OpsProfile.keySet().contains(UserInfo.getProfileId()))
                //-- #END : #19281 adding support for CPA Login partner profile
            {
                //CR Bug 14846 - Mail template 11 and 12 getting send to customer and RM for every document Start
                List < Checklist__c > checkDocList = [SELECT Id, Loan_Application__c, DocStatus__c, Property_Details__c, IsCollateral__c, isNonCollateral__c
                                                      FROM Checklist__c WHERE Loan_Application__c =: Loan.Id
                                                     ];
                System.debug('checkDocList : ' + checkDocList);
                Boolean Is_ProprtyAttached = false;
                if (checkDocList != NULL && checkDocList.size() > 0) {
                    for (Checklist__c chk: checkDocList) {
                        System.debug('Checklist chk : ' + chk);
                        if (chk.Property_Details__c != NULL) { //17545 : Added IsCollateral__c flag : commented as of now : && chk.IsCollateral__c==true : On Hold by BFL : Commented
                            Is_ProprtyAttached = true;
                            break;
                        }
                    }
                }
                System.debug('Is_ProprtyAttached : ' + Is_ProprtyAttached);
                //CR Bug 14846 - Mail template 11 and 12 getting send to customer and RM for every document End
                
                if (Is_ProprtyAttached) { //CR Bug 14846 - Mail template 11 and 12 getting send to customer and RM for every document
                    system.debug('collateral : Document required for cheque handover : Document status update2');
                    CollateralCommunication.callToCollateralCommunication('Document required for cheque handover', Loan);
                    CollateralCommunication.callToCollateralCommunication('Document status update2', Loan);
                }
                
            }
            System.debug('Collateral COmmunication End............................................');
        } catch (Exception e) {
            System.debug(e);
        }
        //10603 Collateral Communication End     
        
        return new Pagereference('/' + LoanId);
        
        
        // PageReference pageRef = new PageReference('/apex/FinnoneErrorPage');     
        //firstStep(Loan,properties,apps,verificationRec);
        
        //if(approvedflag==true){
        // return new Pagereference('/'+ LoanId);
        //}else{return pageRef; }
    }
    /*Code added by Asmita.
Enhancement :11735 : Insurance Premium Validation*/
    
    // function
    // Premium validation code end
    public void premiumChrgAmtValidation() {
        //System.debug('Inside validation !!!');
        String jsonString;
        //List<StaticResource> srList = [SELECT Body FROM StaticResource WHERE Name = 'PremiumCharge' LIMIT 1];
        // start nominee validation for products changes by rohit mourya
        if (srList != null && srList.size() > 0) {
            for (StaticResource sr: srList) {
                if (sr.Name == 'PremiumCharge')
                    jsonString = sr.Body.toString();
            }
            //jsonString = srList[0].Body.toString();
        }
        // end nominee validation for products changes by rohit mourya
        JSONParser parser = JSON.createParser(jsonString);
        parser.nextToken();
        System.JSONToken token;
        string text;
        Map < String, String > custSettingMap = new Map < String, String > ();
        Map < String, Set < String >> revCustSettingMap = new Map < String, Set < String >> ();
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.VALUE_STRING)) {
                text = parser.getText();
                String key = parser.getCurrentName();
                
                if (revCustSettingMap.containsKey(key))
                    revCustSettingMap.get(key).add(text.toUpperCase());
                else {
                    Set < String > valueSet = new Set < String > ();
                    valueSet.add(text.toUpperCase());
                    revCustSettingMap.put(key, valueSet);
                }
                custSettingMap.put(text.toUpperCase(), key);
                
            }
        }
        //System.debug('*****setting map******');
        
        system.debug('custSettingMap--->' + custSettingMap);
        system.debug('revCustSettingMap--->' + revCustSettingMap.size());
        
        //List<LaonApplicationCreation__c> laonAppList = [SELECT Name,Charge_Description__c,Products__c FROM LaonApplicationCreation__c WHERE Name LIKE 'ChargeDisc %'];
        
        //map<String, String > custSettingMap = new map<String,String>();
        map < String, String > feesMap = new map < String, String > ();
        map < String, Integer > mapProdPremium = new map < String, Integer > ();
        map < String, Integer > mapProdPremiumChrg = new map < String, Integer > ();
        List < String > listInsProd = new List < String > ();
        Set < String > setChrgProd = new Set < String > ();
        Set < String > setDplInsProd = new Set < String > ();
        
        // start new Changes
        String errFeesChrage = '';
        // end new Changes
        Map < String, String > mapInsProdForCharge = new Map < String, String > ();
        String errInsProd = '';
        String errCharge = '';
        String errMsgStr = '';
        Integer prevPremAmt = 0;
        Boolean valCheck = false;
        
        // Bug Id - 15416 *Start*
        List < Fees_and_Charge__c > finalFeesChargelst = new List < Fees_and_Charge__c > ();
        if (LAPprods != null && LAPprods.size() > 0) {
            if (LAPprods.contains(loan.Product__c.toUppercase())) {
                for (Fees_and_Charge__c fee: lstFeesPremVal) {
                    //system.debug('disbursement number ----->'+fee.disbursement_number__c); 
                    if (fee.disbursement_number__c == '1') {
                        finalFeesChargelst.add(fee);
                        valCheck = true;
                    }
                }
            } else {
                finalFeesChargelst = lstFeesPremVal;
                valCheck = true;
            }
        } else {
            finalFeesChargelst = lstFeesPremVal;
            valCheck = true;
        }
        // Bug Id - 15416 *End* 
        
        //system.debug('valCheck '+valCheck );
        system.debug('finalFeesChargelst ' + finalFeesChargelst);
        
        If(valCheck) { // Bug Id - 15416 
            //system.debug('feesCharges**'+feesCharges);
            if (finalFeesChargelst != null && finalFeesChargelst.size() > 0) {
                for (Fees_and_Charge__c feeCharge: finalFeesChargelst) {
                    String feeschargeAmt = String.valueOf(feeCharge.Change_Amount__c);
                    if (String.isBlank(feeschargeAmt))
                        feeschargeAmt = '0';
                    
                    system.debug('charge id ***' + String.valueOf(feeCharge.Finnone_ChargeId__c));
                    feesMap.put(String.valueOf(feeCharge.Finnone_ChargeId__c), feeschargeAmt);
                    
                    if (revCustSettingMap.get(String.valueOf(feeCharge.Finnone_ChargeId__c)) != null) {
                        listInsProd.addAll(revCustSettingMap.get(String.valueOf(feeCharge.Finnone_ChargeId__c)));
                        setChrgProd.addAll(revCustSettingMap.get(String.valueOf(feeCharge.Finnone_ChargeId__c)));
                    }
                }
                system.debug('listInsProd-->' + listInsProd);
                system.debug('feesMap*** ' + feesMap);
            }
            
            
            system.debug('ListDPLinsurance test ***' + ListDPLinsurance);
            if (ListDPLinsurance != null && ListDPLinsurance.size() > 0) {
                for (DPLinsurance__c dplIns: ListDPLinsurance) {
                    Integer prmAmnt = 0;
                    if (dplIns.Insurance_Product__c.toUpperCase() != null) {
                        if (mapProdPremium.containskey(dplIns.Insurance_Product__c.toUpperCase())) {
                            prmAmnt = mapProdPremium.get(dplIns.Insurance_Product__c.toUpperCase());
                            if (dplIns.Premium_Amount__c != null)
                                prmAmnt = prmAmnt + Integer.valueof(dplIns.Premium_Amount__c);
                        } else {
                            if (dplIns.Premium_Amount__c != null)
                                prmAmnt = Integer.valueof(dplIns.Premium_Amount__c);
                        }
                        if (mapProdPremiumChrg.containskey(custSettingMap.get(dplIns.Insurance_Product__c.toUpperCase()))) {
                            prmAmnt = mapProdPremiumChrg.get(custSettingMap.get(dplIns.Insurance_Product__c.toUpperCase()));
                            if (dplIns.Premium_Amount__c != null)
                                prmAmnt = prmAmnt + Integer.valueof(dplIns.Premium_Amount__c);
                        } else {
                            if (dplIns.Premium_Amount__c != null)
                                prmAmnt = Integer.valueof(dplIns.Premium_Amount__c);
                        }
                        mapProdPremium.put(dplIns.Insurance_Product__c.toUpperCase(), prmAmnt);
                        mapProdPremiumChrg.put(custSettingMap.get(dplIns.Insurance_Product__c.toUpperCase()), prmAmnt);
                        //dplInsChargeIds.add(custSettingMap.get(dplIns.Insurance_Product__c.toUpperCase()));
                        // start new Changes
                        if (feesMap.get(custSettingMap.get(dplIns.Insurance_Product__c.toUpperCase())) == null) {
                            errFeesChrage = errFeesChrage + dplIns.Insurance_Product__c.toUpperCase() + ',';
                        }
                        // end new Changes
                        //System.debug('prmAmt:::'+prmAmnt+'  '+custSettingMap.get(dplIns.Insurance_Product__c.toUpperCase()));
                        //String chargeId = custSettingMap.get(dplIns.Insurance_Product__c.toUpperCase());
                        /*System.debug('chargeId-->'+custSettingMap.get(dplIns.Insurance_Product__c.toUpperCase()));
if(chargeId != null)
mapInsProdForCharge.put(dplIns.Insurance_Product__c,chargeId);
Set<String> productSet = revCustSettingMap.get(String.valueOf(dplIns.Insurance_Product__c ));
for(String prod : productSet) {
if(prod == dplIns.Charge_Type__c)
mapInsProdForCharge.put(prod,String.valueOf(dplIns.ChargeId__c ));
}

*/
                    }
                    system.debug('prmAmnt  ***' + prmAmnt);
                }
                
                // start new Changes
                if (String.isNotBlank(errFeesChrage)) {
                    errFeesChrage = errFeesChrage.substring(0, errFeesChrage.length() - 1);
                    errMsgStr = 'For Insurance Product: ' + errFeesChrage + ' - corresponding Fees and Charge records does not exist!!!';
                    if (SalMobilityV2Flag) {
                        mobilitystatus = errMsgStr;
                    } else {
                        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.INFO, errMsgStr);
                        Apexpages.addMessage(errMsg);
                    }
                    //Bug 17556 e
                    //system.debug('errMsgStr -->'+errMsgStr );
                    validationFlag = true;
                }
                // end new Changes
                system.debug('mapProdPremium***' + mapProdPremium);
                for (DPLinsurance__c dplIns: ListDPLinsurance) {
                    //system.debug('desc in customSettingMap-->'+custSettingMap.get(dplIns.Insurance_Product__c.toUpperCase()));
                    Boolean isDplInsProdEmpty = true;
                    setDplInsProd.add(dplIns.Insurance_Product__c.toUpperCase());
                    String feeschargeAmt = feesMap.get(custSettingMap.get(dplIns.Insurance_Product__c.toUpperCase()));
                    system.debug('feeschargeAmt-->' + feeschargeAmt);
                    if (String.isBlank(feeschargeAmt))
                        feeschargeAmt = '0';
                    if (listInsProd != null && listInsProd.size() > 0) {
                        for (String insPrdObj: listInsProd) {
                            if (dplIns.Insurance_Product__c.equalsIgnoreCase(insPrdObj)) {
                                isDplInsProdEmpty = false;
                                break;
                            }
                        }
                    }
                    
                    //system.debug('isDplInsProdEmpty -->'+isDplInsProdEmpty +'::'+dplIns.Insurance_Product__c.toUpperCase());
                    if (String.isNotBlank(feeschargeAmt) && !isDplInsProdEmpty) {
                        
                        String insProdPremAmt = String.valueOf(mapProdPremiumChrg.get(custSettingMap.get(dplIns.Insurance_Product__c.toUpperCase())));
                        system.debug('feeschargeAmt inside if-->' + feeschargeAmt);
                        system.debug('custSettingMap -->' + custSettingMap.get(dplIns.Insurance_Product__c.toUpperCase()));
                        system.debug('insProdPremAmt -->' + insProdPremAmt);
                        system.debug('Product -->' + dplIns.Insurance_Product__c.toUpperCase());
                        if (String.isNotBlank(insProdPremAmt) && custSettingMap.get(dplIns.Insurance_Product__c.toUpperCase()) != null && !insProdPremAmt.equals(feeschargeAmt)) {
                            //errInsProd = errInsProd + dplIns.Insurance_Product__c + ',' ;
                            system.debug('Inside If -->' + dplIns.Insurance_Product__c.toUpperCase());
                            if (!errInsProd.contains(custSettingMap.get(dplIns.Insurance_Product__c.toUpperCase()))) {
                                errInsProd = errInsProd + custSettingMap.get(dplIns.Insurance_Product__c.toUpperCase()) + ',';
                                system.debug('errInsProd -->' + errInsProd);
                            }
                            //system.debug('errInsProd22 -->'+errInsProd );
                        }
                    }
                }
            }
            
            if (String.isNotBlank(errInsProd)) {
                errInsProd = errInsProd.substring(0, errInsProd.length() - 1);
                //errMsgStr = 'For product(s) '+errInsProd+ ' - Premium Amount and Charge Amount is not matching !!!';
                errMsgStr = 'For Finnone Charge ID: ' + errInsProd + ' - Premium Amount and Charge Amount is not matching !!!';
                //Bug 17556 s
                if (SalMobilityV2Flag) {
                    mobilitystatus = errMsgStr;
                } else {
                    ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.INFO, errMsgStr);
                    Apexpages.addMessage(errMsg);
                }
                //Bug 17556 e
                //system.debug('errMsgStr -->'+errMsgStr );
                validationFlag = true;
            }
            
            //system.debug('setDplInsProd -->'+setDplInsProd);
            //Check if charge record exist and corresponding Ins. record does not exist  
            
            system.debug('setChrgProd::' + setChrgProd);
            system.debug('mapProdPremium::' + mapProdPremium);
            for (String chrgProdMapping: revCustSettingMap.keyset()) {
                Boolean prdExistInIns = false;
                Boolean isValidChrg = false;
                Set < String > chrgProdMappingSet = revCustSettingMap.get(chrgProdMapping);
                for (String chrgProd: chrgProdMappingSet) {
                    
                    system.debug('COND1::' + setChrgProd.contains(chrgProd.toUpperCase()) + '::COND2::' + feesMap.get(custSettingMap.get(chrgProd)) + '::COND3::' + mapProdPremium.containsKey(chrgProd.toUpperCase()));
                    
                    if (setChrgProd.contains(chrgProd.toUpperCase()) && feesMap.get(custSettingMap.get(chrgProd)) != '0') {
                        isValidChrg = true;
                        system.debug('chrgProd:::' + chrgProd);
                        if (mapProdPremium.containsKey(chrgProd.toUpperCase()))
                            prdExistInIns = true;
                    }
                    
                }
                if (isValidChrg && !prdExistInIns)
                    errCharge = errCharge + chrgProdMapping + ',';
            }
            
            //RAKESH
            /*if(lstFeesPremVal != null && lstFeesPremVal.size()>0){
for(String strChrgDesc : feesMap.keyset()){
Set<String> chrgProdMappingSet = revCustSettingMap.get(strChrgDesc);
//String chrgProdMapping = mapInsProdForCharge.get(strChrgDesc);
for(String chrgProdMapping : chrgProdMappingSet) {
//String chrgProdMapping = revCustSettingMap.get(strChrgDesc);
system.debug('chrgProdMappingU-->'+chrgProdMapping);
system.debug('strChrgDesc-->'+strChrgDesc);
// If loop is Added for bug 12074 start
if(feesMap.get(strChrgDesc)!= '0'){
System.debug('feesMap.get(strChrgDesc)-->'+feesMap.get(strChrgDesc));
// if loop added if no insurance product is present in the list
System.debug('setDplInsProd-->'+setDplInsProd);
System.debug(' setDplInsProd.size()'+ setDplInsProd.size());
System.debug(' String.isNotBlank(chrgProdMapping)' +String.isNotBlank(chrgProdMapping));

if(ListDPLinsurance!=null && ListDPLinsurance.isEmpty()) {
if(revCustSettingMap.keySet().contains(strChrgDesc ))
errCharge = errCharge + strChrgDesc + ',' ;
}

else if(setDplInsProd!=null && setDplInsProd.size()>0 && String.isNotBlank(chrgProdMapping)){
// if loop is added for those charge descriptions which are not present in the 'charge descriptions' of custom setting

System.debug('setDplInsProd.contains(chrgProdMapping.toUpperCase())-->'+setDplInsProd.contains(chrgProdMapping.toUpperCase()));
if(!setDplInsProd.contains(chrgProdMapping.toUpperCase())){               
errCharge = errCharge + strChrgDesc + ',' ;
system.debug('errCharge -->'+errCharge );
}

}
}
}
}
}*/
            
            if (String.isNotBlank(errCharge)) {
                errCharge = errCharge.substring(0, errCharge.length() - 1);
                errMsgStr = 'Charge record(s) for Finnone Charge ID ' + errCharge + ' - is/are available but corresponding Insurance Product(s) is/are not present !!! ';
                //Bug 17556 s
                if (SalMobilityV2Flag) {
                    mobilitystatus = errMsgStr;
                } else {
                    ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.INFO, errMsgStr);
                    Apexpages.addMessage(errMsg);
                }
                //Bug 17556 e
                //system.debug('errMsgStr222 -->'+errMsgStr );
                validationFlag = true;
            }
            
            
            if (validationFlag) {
                ErrorFlag = true;
            }
        }
    }
    
    
    public void firstStep(Opportunity Loan, List < Property_Details__c > properties, List < Applicant__c > apps, List < Verification__c > verificationRecs) {
        integer sayYes = 0;
        // if QDP is true first call QDP() and then SendToFinnone()
        // QDP flag is false directly call SendToFinnone()
        
        if (Loan.QDP__c == true) {
            //approvedflag=true;
            for (integer rr = 0; rr < verificationRec.size(); rr++) {
                
                if (verificationRec[rr].Status__c == null) {
                    sayYes += 1;
                }
            }
            if (sayYes > 0) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Verification record status is Blank');
                Apexpages.addMessage(myMsg);
            } else {
                QDP(Loan, verificationRecs);
            }
            
        } else {
            
            if (validationFlag == false)
                system.debug('ListDPLinsurance before SendToFinnone***' + ListDPLinsurance);
            SendToFinnone(Loan, properties, apps, verificationRec);
        }
        
        
        /** 
if(Loan.QDP__c != true){
if(Loan.Doc_Approved__c=='Yes'){
SendToFinnone(Loan,properties,apps,verificationRec);

if(Loan.Doc_Approved__c=='Yes')
{
approvedflag=true;
}
else{approvedflag=false;}
}//else{
//PageReference pageRef = new PageReference('/apex/FinnoneErrorPage');

//}
}
**/
    } //method end  
    
    public void SendToFinnone(Opportunity Loan, List < Property_Details__c > properties, List < Applicant__c > apps, List < Verification__c > verificationRecs) {
        if (Loan.stagename == 'Approved' || Loan.stagename == 'Verifications' || Loan.stagename == 'Rejected' || Loan.stagename == 'Branch Ops' || Loan.stagename == 'Moved To Finnone' || (salmobilityv2flag && Loan.stagename == 'Post Approval Sales')) { //17556 added condtion
            List < FinnOne_Report__c > FinnoneListApp = new List < FinnOne_Report__c > ();
            List < FinnOne_Report__c > FinnoneListAsset = new List < FinnOne_Report__c > ();
            Applicant__c primary = new Applicant__c();
            List < Applicant__c > coapplicants = new List < Applicant__c > ();
            primary = [select Dedupe_Linking_Done__c,id, Contact_Name__r.TAN_Number__c, Payment_type__c, Note_code__c, Note_details__c, Employer__c, City__c, name, Contact_Name__c, Contact_Name__r.Name, Contact_Name__r.Customer_Profile__c,
                       Contact_Name__r.Designation__c, Contact_Name__r.Employer_Name__c, Contact_Name__r.Qualification__c, Contact_Name__r.Address_1__c,
                       PD_Status__c, Bank_Status__c, Contact_Name__r.Address_2__c, Applicant_Type__c, Contact_Name__r.Customer_Type__c, Contact_Name__r.ApplicantType__c,
                       Contact_Name__r.Date_of_Birth__c, Contact_Name__r.PAN_Number__c, Contact_Name__r.Year_of_Incorporation__c, Contact_Name__r.FathersHusbands_Name__c,
                       Contact_Name__r.Bank_Account_No__c, Contact_Name__r.VoterID_Number__c, Contact_Name__r.ROC_Regn_No__c, Contact_Name__r.Address_3__c, Contact_Name__r.AppCity__c, RCU_Status__c,
                       Contact_Name__r.Pin_Code__c, Contact_Name__r.Phone, Contact_Name__r.MobilePhone, Contact_Name__r.Email, Contact_Name__r.Address_Line_One__c, Contact_Name__r.Address_2nd_Line__c, Contact_Name__r.Address_3rd_Line__c,
                       Contact_Name__r.Office_City__c, Contact_Name__r.Office_Pin_Code__c, Contact_Name__r.Office_STD_Code__c, Contact_Name__r.Office_Phone_Number__c,
                       Contact_Name__r.Mobile_Phone__c, Contact_Name__r.Office_Email_Id__c, Contact_Name__r.Middle_Name__c, Customer_Acceptance__c,
                       Contact_Name__r.FirstName, Contact_Name__r.LastName, Contact_Name__r.Permanant_Address_Line_1__c, Contact_Name__r.Permanant_Address_Line_2__c, Contact_Name__r.Permanant_Address_Line_3__c,
                       Contact_Name__r.Permanent_STD__c, Contact_Name__r.Permanent_Pin_Code__c, Contact_Name__r.Year_in_Present_Job__c, Contact_Name__r.Year_in_Previous_Job__c, Contact_Name__r.Name_of_the_company_Employer__c,
                       Contact_Name__r.Nature_of_Business__c, Contact_Name__r.Employment_Status__c, Contact_Name__r.Gender__c, Contact_Name__r.Age__c, Contact_Name__r.Employment_Type__c, Contact_Name__r.STD_Code__c, Contact_Name__r.Phone_Number__c, Contact_Name__r.Residence_Landline_phone__c,
                       Contact_Name__r.Name_of_Employer__c, Designation__c, Contact_Name__r.Type_Of_Constitution__c, Contact_Name__r.Marital_Status__c, Contact_Name__r.Father_s_Name__c, Contact_Name__r.CIF_Id__c, StepUp_StepDown_EMI_Year_1__c, StepUp_StepDown_EMI_Year_2__c,
                       StepUp_StepDown_EMI_Year_3__c, StepUp_StepDown_EMI_Year_4__c, StepUp_StepDown_EMI_Year_5__c, Contact_Name__r.Residence_Type__c, Contact_Name__r.State__c, Contact_Name__r.Residence_City__c, Contact_Name__r.Stamp_Duty__c /*added by akshata stamp duty automation*/
                       // from Applicant__c where Loan_Application__c=:Loan.Id limit 1];
                       , /*hybrid flexi*/ Drop_Line_Flexi_Period__c, Pure_Flexi_Period__c
                       from Applicant__c where Applicant_Type__c = 'Primary'
                       and Loan_Application__c =: Loan.Id limit 1
                      ];
            
            /*Enhancement of Additional fields to finnone Insurance 
Date 27/04/2016
Bhagyashree 
*/
            
            
            //DPLinsurance__c ObjDPLinsurance=new DPLinsurance__c(); 
            /*List < DPLinsurance__c > ListDPLinsurance = new List < DPLinsurance__c > ();
System.debug('In DPL insurance:  ListDPLinsurance' + ListDPLinsurance);
ListDPLinsurance = [SELECT Applicant_type__c, Type_of_Insurance__c, Critical_Illness__c, Declaration_of_good_health__c, Insurance_form_number__c,
Insurance_Party_type__c, Insurance_Product__c, Nominee_Name__c, Insurance_term__c, Insurance_Type__c, Insurer_Name__c, Premium_Amount__c,
Sum_Assured__c, Relation__c, Nominee_DOB__c FROM DPLinsurance__c where Opportunity__c = : Loan.Id
];

System.debug('In DPL insurance:  ListDPLinsurance' + ListDPLinsurance); */
            
            //Decetralised code
            
            List < De_Dupe__c > objDedupeList = new List < De_Dupe__c > ();
            List < De_Dupe__c > objDedupeCoAppList = new List < De_Dupe__c > ();
            De_Dupe__c objDedupePrimary = new De_Dupe__c();
            De_Dupe__c objDedupe = new De_Dupe__c();
            
            if (Loan != null && Loan.Product__c == 'FAS') {
                objDedupeList = [Select id, Customer_ID__c, Applicant__c, Applicant__r.Contact_Name__r.ApplicantType__c
                                 from De_Dupe__c where Loan_Application__c =: Loan.Id
                                 AND Source_Or_Target__c = 'Target'
                                 AND Match_Status__c = 'Best Match'
                                ];
                //AND De_Dupe_Decision__c = 'Accept'
                //AND De_Dupe_result__c = 'Relevant'];
            } else {
                objDedupeList = [Select id, Customer_ID__c, Applicant__c, Applicant__r.Contact_Name__r.ApplicantType__c
                                 from De_Dupe__c where Loan_Application__c =: Loan.Id
                                 AND Source_Or_Target__c = 'Target'
                                 AND De_Dupe_Decision__c = 'Accept'
                                 AND De_Dupe_result__c = 'Relevant'
                                ];
            }
            
            
            //if (objDedupeList != null && objDedupeList.size() > 0) {
            //    objDedupe = objDedupeList[0];
            //}
            
            
            for (De_Dupe__c objDD: objDedupeList) {
                if (objDD.Applicant__c != null) {
                    if (objDD.Applicant__r.Contact_Name__r.ApplicantType__c != null) {
                        system.debug('---objDD.Applicant__r.Contact_Name__r.ApplicantType__c---' + objDD.Applicant__r.Contact_Name__r.ApplicantType__c);
                        if (objDD.Applicant__r.Contact_Name__r.ApplicantType__c == 'Primary') {
                            system.debug('--- Inside Primary App Dedupe Found ---');
                            objDedupePrimary = objDD;
                        }
                        if (objDD.Applicant__r.Contact_Name__r.ApplicantType__c != 'Primary') {
                            system.debug('--- Inside Co App Dedupe Found ---');
                            objDedupeCoAppList.add(objDD);
                        }
                    }
                } else {
                    system.debug('--- Inside NO App Dedupe Found ---');
                    objDedupe = objDedupeList[0];
                }
            }
            
            
            cnt = 0;
            
            
            //added for elc 
            if (loan.Product__c != 'DPL' && loan.Product__c != 'CRISL' && loan.Product__c != 'CE' && loan.Product__c != 'SAL' && loan.Product__c != 'SOL' && loan.Product__c != 'SPL' && loan.Product__c != 'SBS CS SAL') {
                try {
                    
                    if (loan.Product__c == 'SHL') {
                        
                        hlcamAppr = [select id, ELC_Line_Amounts__c, Avg_Net_Sal__c from HL_CAM__c where Loan_Application__c =: Loan.Id and(Approved_HLCAM__c = true OR Approve_HL_CAM__c = true) limit 1];
                    } else {
                        List < CAM__c > CAMList = [select id, ELC_Line_Amounts__c, Final_Net_An_Inc__c from cam__c where Approved_CAM__c = true and Loan_Application__c =: Loan.Id Limit 1];
                        if (CAMList.size() > 0) camAppr = CAMList[0];
                        else {
                            List < SurrogateCAM__C > ScamList = [Select id, ELC_Line_amount__C from SurrogateCAM__C where Loan_Application__C =: Loan.Id and Applicant__c =: NULL];
                            if (ScamList.size() > 0) {
                                Scam = ScamList[0];
                            }
                        }
                    }
                    
                    
                } catch (exception e) {
                    system.debug('Exception is' + e.getMessage() + 'Line number is' + e.getLineNumber());
                }
            }
            
            
            
            // Added for QDP
            for (Applicant__c applicant1: apps) {
                if (Loan.QDP__c == true) {
                    if (applicant1.Applicant_Type__c == 'Primary') {
                        applicant11.add(applicant1);
                        break;
                    }
                } else {
                    applicant11.add(applicant1);
                }
            }
            // End Of The Qdp
            for (Applicant__c applicant: apps) {
                if (applicant.Contact_Name__r.Customer_Type__c == 'Individual') {
                    cnt = cnt + 1;
                    cpn = applicant.Contact_Name__r.FirstName + ' ' + applicant.Contact_Name__r.LastName;
                    system.debug('--cpn--' + cpn);
                    // 7660 Adhoc change Start 
                    if (applicant.Contact_Name__r.STD_Code__c != null) {
                        stdCode = applicant.Contact_Name__r.STD_Code__c;
                    }
                    if (applicant.Contact_Name__r.Residence_Landline_phone__c != null) {
                        regPhoNumStr = applicant.Contact_Name__r.Residence_Landline_phone__c;
                    }
                    //7660 Adhoc change End 
                }
            }
            if (cnt == 0) {
                cpn = 'Bajaj';
                //7660 S 
                stdCode = 20;
                regPhoNumStr = '12345678';
                //7669 E
            }
            system.debug('--cpn--' + cpn);
            //system.debug('comming into fourth');
            if (Loan.Sent_To_Finnone__c == false) {
                // FinnOne Records for Applicants   
                for (Applicant__c applicant: applicant11) {
                    system.debug('applicant.Applicant_Type__c*************** ' + applicant.Applicant_Type__c);
                    
                    if (applicant.Applicant_Type__c != 'Non co-applicant party')
                        // if(applicant.Applicant_Type__c == 'Primary')
                    {
                        //system.debug('inside if@@@@@@@@@@@@@@');
                        FinnOne_Report__c FinnoneNew = new FinnOne_Report__c();
                        //FinnOne_Report__c FinnoneforDoc;
                        FinnoneNew.Loan_Application__c = Loan.Id;
                        /* Start DPL Loan Functionality Integration Handing 13950 */
                        if (applicant.Loan_Application__r.Product__c == 'DPL')
                            FinnoneNew.T2C_Flag__c = 'Y';
                        /* End DPL Loan Functionality Integration Handing 13950 */
                        
                        /*Code added by Asmita Rajput.
Comment : code to flow DPLinsurance fields to FinnOne Report and Document Finnone Report */
                        // Below Code is commented for Integration purpose
                        /*
FinnoneNew.Dispatch_time__c = Loan.Dispatch_time__c;
FinnoneNew.File_Inward__c = Loan.File_Inward__c;
//FinnoneNew.Age_of_Applicant__c = applicant.Contact_Name__r.Age_of_Applicant__c;
FinnoneNew.Date_of_Birth__c = applicant.Contact_Name__r.Date_of_Birth__c;
FinnoneNew.Gender__c = applicant.Contact_Name__r.Gender__c;
*/
                        /*--------code added by Asmita end-------------*/
                        
                        system.debug('opp and contacts added :: ' + FinnoneNew);
                        //FinnoneNew.Customer_Id__c =applicant.name;// added for applicant id
                        if (applicant.Applicant_Type__c == 'Primary') {
                            /*Hybrid flexi :akshata start*/
                            if (loan != null && loan.Scheme_Master__c != null && loan.Scheme_Master__r.IsHybridFlexi__c != null && applicant.Pure_Flexi_Period__c != null && loan.Scheme_Master__r.IsHybridFlexi__c == true) {
                                
                                FinnoneNew.Pure_Flexi_Period__c = applicant.Pure_Flexi_Period__c;
                                
                                // FinnoneNew.IsHybridFlexi__c = loan.Scheme_Master__r.IsHybridFlexi__c;
                            }
                            
                            /*Hybrid flexi :akshata end*/
                            FinnoneNew.TAN__c = applicant.Contact_Name__r.TAN_Number__c;
                        }
                        //14198-S
                        /*Hybrid flexi :akshata start */
                        if (Loan.Scheme_Master__r.IsHybridFlexi__c != null && Loan.Scheme_Master__r.IsHybridFlexi__c == true) {
                            FinnoneNew.IsHybridFlexi__c = 'H';
                        } else if (Loan.Scheme_Master__r.is_Pure_Flexi__c != null && Loan.Scheme_Master__r.is_Pure_Flexi__c == true) {
                            FinnoneNew.IsHybridFlexi__c = 'P';
                        } else if (Loan.Scheme_Master__r.is_Pure_Flexi__c != null && Loan.Scheme_Master__r.is_Pure_Flexi__c == false &&
                                   Loan.Scheme_Master__r.IsHybridFlexi__c != null && Loan.Scheme_Master__r.IsHybridFlexi__c == false &&
                                   Loan.Scheme_Master__r.flexi_flag__c != null && Loan.Scheme_Master__r.flexi_flag__c == true) {
                                       FinnoneNew.IsHybridFlexi__c = 'D';
                                   } else {
                                       FinnoneNew.IsHybridFlexi__c = '';
                                   }
                        //14198-E
                        /*Hybrid flexi :akshata end*/
                        //code added by leena for send to finone enhancement change request
                        for (DPLinsurance__c ObjDPLinsurance: ListDPLinsurance) {
                            
                            if (applicant.Contact_Name__r.Name == ObjDPLinsurance.Insurer_Name__c) {
                                FinnoneNew.Insurance_Taken__c = 'N';
                                //Code updated by Asmita for bug - 12011
                                //Added condition for General Insurance
                                if (ObjDPLinsurance.Type_of_Insurance__c == 'Life Insurance') {
                                    //system.debug('ObjDPLinsuranceID::'+ObjDPLinsurance.Id);   
                                    FinnoneNew.Insurance_Taken__c = 'Y';
                                    break;
                                }
                                
                                
                            }
                            
                        }
                        //end of code added by leena
                        
                        //21505 start
                        
                        String appProof = applicant.Proof_of_Identity__c, finnProof;
                        if (String.isNotEmpty(appProof)) {
                            if (appProof.contains('Passport'))
                                finnProof = 'A';
                            else if (appProof.contains('Voters ID card'))
                                finnProof = 'B';
                            else if (appProof.contains('PAN Card'))
                                finnProof = 'C';
                            else if (appProof.contains('Driving License'))
                                finnProof = 'D';
                            else if (appProof.contains('Aadhar'))
                                finnProof = 'E';
                        }
                        if (String.isNotEmpty(finnProof))
                            FinnoneNew.Identity_Document_Submitted__c = finnProof;
                        
                        String appAddProof = applicant.Proof_of_Residence_Address_Submitted__c, finnResProof;
                        if (String.isNotEmpty(appAddProof)) {
                            if(appAddProof.contains('Aadhar'))
                                finnResProof = '1';
                            if (appAddProof.contains('Passport'))
                                finnResProof = '2';
                            if (appAddProof.contains('Driving License'))
                                finnResProof = '3';
                            if (appAddProof.contains('Voters ID card'))
                                finnResProof = '4';
                            if (appAddProof.contains('Utility bill'))
                                finnResProof = 'S12';
                            if(appAddProof.contains('Municipal Tax Receipt'))
                                finnResProof = 'S13';
                            if(appAddProof.contains('Bank Statement'))
                                finnResProof = 'S14';
                            if(appAddProof.contains('Letter of allotment'))
                                finnResProof = 'S16';
                        }
                        if (String.isNotEmpty(finnResProof))
                            FinnoneNew.Address_Proof_Submitted__c = finnResProof;
                        
                        FinnoneNew.Identity_Document_Number__c = applicant.Identity_Document_No__c;
                        FinnoneNew.Identity_Document_Expiry_Date__c = applicant.Identity_Document_Expiry_Date__c;
                        FinnoneNew.Ckyc_Number__c = applicant.CKYC_No__c;
                        // if (applicant.Contact_Name__r.Employment_Type__c == 'Salaried' || applicant.Contact_Name__r.Employment_Type__c == 'salaried')
                        
                        if(String.isNotEmpty(applicant.Contact_Name__c)){
                            FinnoneNew.Employment_Type__c = applicant.Contact_Name__r.Employment_Type__c;
                            String appConOcc = applicant.Contact_Name__r.Occupation_CKYC__c, finnOcc;
                            if (String.isNotEmpty(appConOcc)) {
                                if (appConOcc == 'Business') finnOcc = 'B-01';
                                else if (appConOcc == 'Professional') finnOcc = 'O-01';
                                else if (appConOcc == 'Self Employed') finnOcc = 'O-02';
                                else if (appConOcc == 'Retired') finnOcc = 'O-03';
                                else if (appConOcc == 'Housewife') finnOcc = 'O-04';
                                else if (appConOcc == 'Public Sector') finnOcc = 'S-01';
                                else if (appConOcc == 'Private Sector') finnOcc = 'S-02';
                                else if (appConOcc == 'Government Sector') finnOcc = 'S-03';
                            }
                            if (String.isNotEmpty(finnOcc))
                                FinnoneNew.Occupation_CKYC__c = finnOcc;
                        if (applicant.Contact_Name__r.Customer_Type__c == 'Individual') FinnoneNew.Customer_Type__c = 'I';
                        else if (applicant.Contact_Name__r.Customer_Type__c == 'Corporate') FinnoneNew.Customer_Type__c = 'C';
                        
                        if (applicant.Contact_Name__r.ApplicantType__c == 'Primary') {
                            FinnoneNew.Applicant_Type__c = 'P';
                        } else if (applicant.Contact_Name__r.ApplicantType__c == 'Guarantor') {
                            FinnoneNew.Applicant_Type__c = 'G';
                        } else {
                            FinnoneNew.Applicant_Type__c = 'C';
                        }
                        
                            //Addy - for reducing class metadata requirement
                            String appCustProfile = applicant.Contact_Name__r.Customer_Profile__c, finnCusProfile;
                            if (appCustProfile == 'Salaried') finnCusProfile = '3';
                            else if (appCustProfile == 'SEP') finnCusProfile = '4';
                            else if (appCustProfile == 'SENP') finnCusProfile = '5';
                            else if (appCustProfile == 'EMPLOYEE') finnCusProfile = '14';
                            else if (appCustProfile == 'Others') finnCusProfile = '1';

                            if (String.isNotEmpty(finnCusProfile))
                            FinnoneNew.Customer_Profile__c = finnCusProfile;
                            
                            //Addy - for reducing class metadata requirement
                            String appMaritalStatus = applicant.Contact_Name__r.Marital_Status__c, finnMaritalStatus;
                            if (appMaritalStatus == 'Married') finnMaritalStatus = '1'; // Changed for Bug 21505 AP
                            else if (appMaritalStatus == 'Single') finnMaritalStatus = '2'; // Changed for Bug 21505 AP
                            else if (appMaritalStatus == 'Divorsed') finnMaritalStatus = 'D';
                            else if (appMaritalStatus == 'Widow') finnMaritalStatus = 'W';

                            if (String.isNotEmpty(finnMaritalStatus))
                                FinnoneNew.Marital_Status__c = finnMaritalStatus;
                            
                            // Adding for 21505 AP//Addy
                            String appFatherorSpouse = applicant.Contact_Name__r.Father_Spouse__c;
                            if (appFatherorSpouse == 'Father')
                                FinnoneNew.Father_or_Spouse__c = '01';
                            else
                                FinnoneNew.Father_or_Spouse__c = '02';
                            FinnoneNew.Father_or_Spouse_Salutation__c = applicant.Contact_Name__r.Father_Spouse_Salutation__c;
                            FinnoneNew.Father_or_Spouse_FirstName__c = applicant.Contact_Name__r.Father_Spouse_First_Name__c;
                            FinnoneNew.Father_or_Spouse_MiddleName__c = applicant.Contact_Name__r.Father_Spouse_Middle_Name__c;
                            FinnoneNew.Father_or_Spouse_LastName__c = applicant.Contact_Name__r.Father_Spouse_Last_Name__c;
                            FinnoneNew.Mother_FirstName__c = applicant.Contact_Name__r.Mother_First_Name__c;
                            FinnoneNew.Mother_MiddleName__c = applicant.Contact_Name__r.Mother_Middle_Name__c;
                            FinnoneNew.Mother_LastName__c = applicant.Contact_Name__r.Mother_Last_Name__c;
                        }
                        // 21505 End AP
                        
                        if(applicant.Contact_Name__c != null){
                        String appCons = applicant.Contact_Name__r.Type_Of_Constitution__c;
                        String finnTypeOfCons;
                        if (String.isNotEmpty(appCons)) {
                            if (appCons == 'PROBATIONARY') finnTypeOfCons = '1';
                            else if (appCons == 'REGULAR') finnTypeOfCons = '2';
                            else if (appCons == 'CONTRACTUAL') finnTypeOfCons = '3';
                            else if (appCons == 'PENSIONER') finnTypeOfCons = '4';
                            else if (appCons == 'PART TIME') finnTypeOfCons = '5';
                            else if (appCons == 'INDIRECT EARNERS') finnTypeOfCons = '6';
                            else if (appCons == 'GOVT ORGANIZATION') finnTypeOfCons = '7';
                            else if (appCons == 'LIMITED COMPANY') finnTypeOfCons = '8';
                            else if (appCons == 'PVT LIMITED COMPANY') finnTypeOfCons = '9';
                            else if (appCons == 'PARTNERSHIP') finnTypeOfCons = '10';
                            else if (appCons == 'PROPRIETARISHIP') finnTypeOfCons = '11';
                            else if (appCons == 'MNC') finnTypeOfCons = '12';
                            else if (appCons == 'OTHER') finnTypeOfCons = '13';
                        }
                        if(String.isNotEmpty(finnTypeOfCons))
                            FinnoneNew.Type_of_Constitution__c = finnTypeOfCons;
                        }
                        
                        FinnoneNew.First_Name__c = applicant.Contact_Name__r.FirstName;
                        FinnoneNew.Last_Name__c = applicant.Contact_Name__r.LastName;
                        //Added DK-Sart-Bug 718
                        FinnoneNew.Fathers_Name__c = applicant.Contact_Name__r.FathersHusbands_Name__c;
                        //Added DK-end-Bug 718
                        if (applicant.Contact_Name__r.Middle_Name__c != null) {
                            splitstr = (applicant.Contact_Name__r.Middle_Name__c).split(' ');
                            if (splitstr != null) FinnoneNew.Middle_Name__c = splitstr[0];
                        } else if (applicant.Contact_Name__r.FathersHusbands_Name__c != null) {
                            splitstr = (applicant.Contact_Name__r.FathersHusbands_Name__c).split(' ');
                            if (splitstr != null) FinnoneNew.Middle_Name__c = splitstr[0];
                        } else FinnoneNew.Middle_Name__c = ' ';
                        FinnoneNew.Dedupe_Linking_Done__c = applicant.Dedupe_Linking_Done__c;
                        FinnoneNew.PAN__c = applicant.Contact_Name__r.PAN_Number__c;
                        FinnoneNew.Date_of_Birth__c = applicant.Contact_Name__r.Date_of_Birth__c;
                        FinnoneNew.Designation__c = applicant.Contact_Name__r.Designation__c;
                        FinnoneNew.Office_Address_1__c = applicant.Contact_Name__r.Address_Line_One__c;
                        FinnoneNew.Office_Address_2__c = applicant.Contact_Name__r.Address_2nd_Line__c;
                        FinnoneNew.Office_Address_3__c = applicant.Contact_Name__r.Address_3rd_Line__c;
                        if (applicant.Contact_Name__r.Office_Pin_Code__c != null) FinnoneNew.Office_ZIP_Code__c = applicant.Contact_Name__r.Office_Pin_Code__c;
                        FinnoneNew.Office_STD_Code__c = string.valueof(applicant.Contact_Name__r.Office_STD_Code__c);
                        if (applicant.Contact_Name__r.Office_Phone_Number__c != null) FinnoneNew.Office_Phone_No__c = applicant.Contact_Name__r.Office_Phone_Number__c;
                        FinnoneNew.Permanent_Address_1__c = applicant.Contact_Name__r.Permanant_Address_Line_1__c;
                        FinnoneNew.Permanent_Address_2__c = applicant.Contact_Name__r.Permanant_Address_Line_2__c;
                        FinnoneNew.Permanent_Address_3__c = applicant.Contact_Name__r.Permanant_Address_Line_3__c;
                        FinnoneNew.Permanent_STD_Code__c = string.valueof(applicant.Contact_Name__r.Permanent_STD__c);
                        FinnoneNew.Permanent_ZIP_Code__c = string.valueof(applicant.Contact_Name__r.Permanent_Pin_Code__c);
                        FinnoneNew.Years_In_Present_Job__c = applicant.Contact_Name__r.Year_in_Present_Job__c;
                        FinnoneNew.Years_In_Previous_Job__c = applicant.Contact_Name__r.Year_in_Previous_Job__c;
                        FinnoneNew.Nature_Of_Business__c = applicant.Contact_Name__r.Nature_of_Business__c;
                        FinnoneNew.Employment_Status__c = applicant.Contact_Name__r.Employment_Status__c;
                        FinnoneNew.Other_Caste_Category__c = applicant.Contact_Name__r.Other_Caste_Category__c;
                        FinnoneNew.Other_Religion__c = applicant.Contact_Name__r.Other_Religion__c;
                        FinnoneNew.Caste_Category__c = applicant.Contact_Name__r.Caste_Category__c;
                        FinnoneNew.Religion__c = applicant.Contact_Name__r.Religion__c;
                        //Stamp duty automation by akshata s
                        FinnoneNew.Stamp_Duty__c = applicant.Contact_Name__r.Stamp_Duty__c;
                        
                        //Bug 14506 - HFC Fields - SFDC By Rajesh START
                        if (Loan.Account.Group_Type__c == 'salaried')
                            FinnoneNew.Income_of_Borrower__c = !CommonUtility.isEmpty(applicant.CAMs__r) ? applicant.CAMs__r[0].Income_of_Borrower__c : 0;
                        else
                            FinnoneNew.Income_of_Borrower__c = !CommonUtility.isEmpty(applicant.SurrogateCAMS__r) ? applicant.SurrogateCAMS__r[0].Income_of_Borrower__c : 0;
                        
                        // FinnoneNew.Income_of_Borrower__c = applicant.Contact_Name__r.Income_of_Borrower__c;
                        if (applicant.Applicant_Type__c == 'Primary') {
                            FinnoneNew.Type_of_facility__c = Loan.Account.Type_of_facility__c;
                            FinnoneNew.PSL__c = Loan.Eligible_for_PSL__c;
                            FinnoneNew.PMAY__c = Loan.Account.PMAY__c;
                            FinnoneNew.EWS_LIG__c = Loan.Account.EWS_LIG__c;
                            FinnoneNew.Plain_Area_Hilly_Area_flagging__c = Loan.Account.Plain_Area_Hilly_Area_flagging__c;
                        }
                        //Bug 14506 - HFC Fields - SFDC By Rajesh END
                        
                        
                        //Stamp duty automation by akshata e
                        //SHL Interest Subvention Rohit start bug id 12941
                        //Rohit interest subvention generic start
                        Boolean isInstSub = false;
                        if (Label.InterestSubventionProducts != null) {
                            List < String > intSubProds = new List < String > ();
                            intSubProds = Label.InterestSubventionProducts.split(';');
                            for (String str: intSubProds) {
                                if (Loan.Product__c != null && str.equalsIgnoreCase(Loan.Product__c)) {
                                    isInstSub = true;
                                    break;
                                } else
                                    isInstSub = false;
                            }
                        }
                        
                        //Rohit interest subvention generic stop
                        if (isInstSub && applicant.Applicant_Type__c == 'Primary' && Loan.Account != null) {
                            
                            //FinnoneNew.Interest_Subvention_Applicable__c = Loan.Account.Interest_Subvention_Applicable__c;
                            //Bug 14400 Rohit Start
                            if (Loan.Account.Interest_Subvention_Applicable__c != null) {
                                if (Loan.Account.Interest_Subvention_Applicable__c == 'Yes') {
                                    FinnoneNew.Interest_Subvention_Applicable__c = 'Y';
                                } else if (Loan.Account.Interest_Subvention_Applicable__c == 'No') {
                                    FinnoneNew.Interest_Subvention_Applicable__c = 'N';
                                }
                            }
                            //FinnoneNew.Interest_Subvention_Type__c = Loan.Account.Interest_Subvention_Type__c;
                            if (Loan.Account.Interest_Subvention_Type__c != null) {
                                if (Loan.Account.Interest_Subvention_Type__c == 'Full Subvention') {
                                    FinnoneNew.Interest_Subvention_Type__c = 'F';
                                } else if (Loan.Account.Interest_Subvention_Type__c == 'Partial Subvention') {
                                    FinnoneNew.Interest_Subvention_Type__c = 'P';
                                }
                            }
                            //Bug 14400 Rohit end
                            
                            FinnoneNew.Customer_Contribution__c = Loan.Account.Customer_Contribution__c;
                            FinnoneNew.Builder_Contribution__c = Loan.Account.Builder_Contribution__c;
                            FinnoneNew.Subvention_End_Date__c = Loan.Account.Subvention_End_Date__c;
                            
                            if (Loan.Scheme_Master__c != null) {
                                FinnoneNew.Discount_Rate__c = Loan.Scheme_Master__r.Discount_Rate__c;
                            }
                            //FinnoneNew.Application_Sign_Date__c = date.newinstance(Loan.CreatedDate.year(),Loan.CreatedDate.month(),Loan.CreatedDate.day());
                            //system.debug('Loan^^'+Loan.CreatedBy);
                            
                            if (Test.isRunningTest()) {
                                FinnoneNew.LAN_Creation_Date__c = date.newinstance(2000, 11, 11);
                            } else {
                                FinnoneNew.LAN_Creation_Date__c = date.newinstance(Loan.CreatedDate.year(), Loan.CreatedDate.month(), Loan.CreatedDate.day());
                            }
                            //FinnoneNew.LAN_Creation_Date__c = date.newinstance(2000,11,11);
                            
                            System.debug('rohit6 ' + FinnoneNew.Customer_Contribution__c);
                        }
                        //SHL Interest Subvention Rohit end bug id 12941
                        //CIN DIN Enhancement by pankaj start
                        if (applicant.Contact_Name__r.CIN__c != null) FinnoneNew.CIN__c = applicant.Contact_Name__r.CIN__c;
                        if (applicant.Contact_Name__r.DIN__c != null) FinnoneNew.DIN__c = applicant.Contact_Name__r.DIN__c;
                        //CIN DIN End
                        //SBS CS SAL condition added
                        if ( /*Bug :16959 S*/ isPSBLProductLineProduct == true /*Bug :16959 E*/ || isNewProductFlowEnabled == true || loan.product__c == 'SAL' || loan.product__c == 'SPL' || loan.product__c == 'SBS CS SAL') {
                            
                            FinnoneNew.Promotional_schemes__c = loan.Emi_type__c;
                            system.debug('Entered Emi Type = ' + loan.Emi_type__c);
                        }
                        //Added DK-Sart-Bug 718
                        
                        if (loan != null && loan.Referral__c != null && loan.Referral__r.Name != null) {
                            if ((loan.Referral__r.Name).length() > 12) {
                                FinnoneNew.Referrer_Name__c = (loan.Referral__r.Name).trim().substring(0, 11);
                            } else {
                                FinnoneNew.Referrer_Name__c = (loan.Referral__r.Name).trim();
                            }
                            
                        }
                        FinnoneNew.Sales_Manager_Name__c = loan.Relationship_Manager__r.Name;
                        FinnoneNew.Sales_Executive_Name__c = loan.Relationship_Manager__r.Name;
                        FinnoneNew.Nature_of_Business__c = loan.Nature_of_Business__c;
                        
                        //FAS
                        System.debug('Rajesh Log--->' + Loan.Product__c);
                        
                        if (Loan.Product__c == 'FAS') {
                            //System.debug('loan.Application_Number__c=' + loan.Application_Number__c);
                            FinnoneNew.Application_Form_Number__c = loan.Application_Number__c;
                            //FinnoneNew.Address_Type__c = applicant.Contact_Name__r.Residence_Type__c;
                            
                            if (applicant.Contact_Name__c != null) {
                                if (applicant.Contact_Name__r.Residence_Type__c == 'Owned by Self/Spouse') {
                                    FinnoneNew.Address_Type__c = 'O';
                                } else if (applicant.Contact_Name__r.Residence_Type__c == 'Owned by Parent/Sibling') {
                                    FinnoneNew.Address_Type__c = 'T';
                                } else if (applicant.Contact_Name__r.Residence_Type__c == 'Rented - Staying Alone' || applicant.Contact_Name__r.Residence_Type__c == 'Rented - With family') {
                                    FinnoneNew.Address_Type__c = 'R';
                                } else if (applicant.Contact_Name__r.Residence_Type__c == 'Rented - With friends') {
                                    FinnoneNew.Address_Type__c = 'S';
                                } else if (applicant.Contact_Name__r.Residence_Type__c == 'Company Provided') {
                                    FinnoneNew.Address_Type__c = 'C';
                                } else if (applicant.Contact_Name__r.Residence_Type__c == 'Hostel') {
                                    FinnoneNew.Address_Type__c = 'H';
                                } else if (applicant.Contact_Name__r.Residence_Type__c == 'Leased') {
                                    FinnoneNew.Address_Type__c = 'L';
                                } else if (applicant.Contact_Name__r.Residence_Type__c == 'Others') {
                                    FinnoneNew.Address_Type__c = 'E';
                                } else if (applicant.Contact_Name__r.Residence_Type__c == 'Paying Guest') {
                                    FinnoneNew.Address_Type__c = 'P';
                                } else if (applicant.Contact_Name__r.Residence_Type__c == 'Bachelor Rented Accomodation') {
                                    FinnoneNew.Address_Type__c = 'B';
                                }
                                
                                if (applicant.Contact_Name__r.State__c != null) {
                                    System.debug('applicant.Contact_Name__r.State__c=' + applicant.Contact_Name__r.State__c + '=applicant.Contact_Name__r.Residence_City__c=' + applicant.Contact_Name__r.Residence_City__c);
                                    FinnoneNew.State_DESC__c = (applicant.Contact_Name__r.State__c).touppercase();
                                }
                                
                                if (applicant.Contact_Name__r.Residence_City__c != null) {
                                    FinnoneNew.Ref_City__c = (applicant.Contact_Name__r.Residence_City__c).touppercase();
                                }
                            }
                            
                            if (banlAccMap.size() > 0 && banlAccMap.containsKey(applicant.id)) {
                                FinnoneNew.ClientId__c = banlAccMap.get(applicant.id).ClientId__c;
                                FinnoneNew.Depository_Participant_Id__c = banlAccMap.get(applicant.id).Depository_Participant_Id__c;
                            }
                            FinnoneNew.Final_Decision_Time__c = loan.Approved_time_after_Reappraisal__c;
                            FinnoneNew.Sanction_Validity_Date__c = loan.Sanction_Validity_Date__c;
                            
                            
                        }
                        //FAS End
                        
                        //Decentralised Code
                        
                        if (applicant.Contact_Name__r.ApplicantType__c == 'Primary') {
                            if (objDedupePrimary.id != null) {
                                if (applicant.id == objDedupePrimary.Applicant__c) {
                                    system.debug('--- Inside Primary App Dedupe Match---');
                                    system.debug('::objDedupePrimary::' + objDedupePrimary);
                                    if (objDedupePrimary.Customer_ID__c != null && !objDedupePrimary.Customer_ID__c.equalsIgnoreCase('No Match')) {
                                        String customerId = '';
                                        system.debug('---objDedupePrimary.Customer_ID__c---' + objDedupePrimary.Customer_ID__c);
                                        if (objDedupePrimary.Customer_ID__c.contains('||')) {
                                            
                                            customerId = objDedupePrimary.Customer_ID__c.substring(0, objDedupePrimary.Customer_ID__c.indexOf('||'));
                                        } else {
                                            if (objDedupePrimary.Customer_ID__c.contains('REJECT')) {
                                                customerId = objDedupePrimary.Customer_ID__c.substring(0, objDedupePrimary.Customer_ID__c.indexOf('REJECT'));
                                            } else {
                                                if (objDedupePrimary.Customer_ID__c.isNumeric()) {
                                                    customerId = objDedupePrimary.Customer_ID__c;
                                                }
                                            }
                                        }
                                        
                                        if (customerId != '') {
                                            FinnoneNew.Existing_Customer__c = customerId;
                                            system.debug('---FinnoneNew.Existing_Customer__c---' + FinnoneNew.Existing_Customer__c);
                                            FinnoneNew.Auto_De_dupe__c = 'Y';
                                        }
                                        
                                    } else {
                                        FinnoneNew.Auto_De_dupe__c = 'N';
                                    }
                                }
                            } else {
                                system.debug('--- Inside Primary App Not Dedupe Match---');
                                system.debug('::objDedupe::' + objDedupe);
                                if (objDedupe.Customer_ID__c != null && !objDedupe.Customer_ID__c.equalsIgnoreCase('No Match')) {
                                    String customerId = '';
                                    system.debug('---objDedupe.Customer_ID__c---' + objDedupe.Customer_ID__c);
                                    if (objDedupe.Customer_ID__c.contains('||')) {
                                        customerId = objDedupe.Customer_ID__c.substring(0, objDedupe.Customer_ID__c.indexOf('||'));
                                    } else {
                                        if (objDedupe.Customer_ID__c.contains('REJECT')) {
                                            customerId = objDedupe.Customer_ID__c.substring(0, objDedupe.Customer_ID__c.indexOf('REJECT'));
                                        } else {
                                            if (objDedupe.Customer_ID__c.isNumeric()) {
                                                customerId = objDedupe.Customer_ID__c;
                                            }
                                        }
                                    }
                                    
                                    if (customerId != '') {
                                        FinnoneNew.Existing_Customer__c = customerId;
                                        system.debug('---FinnoneNew.Existing_Customer__c---' + FinnoneNew.Existing_Customer__c);
                                        FinnoneNew.Auto_De_dupe__c = 'Y';
                                    }
                                    
                                } else {
                                    FinnoneNew.Auto_De_dupe__c = 'N';
                                }
                            }
                        } else {
                            if (objDedupeCoAppList != null && objDedupeCoAppList.size() > 0) {
                                for (De_Dupe__c objDDCoApp: objDedupeCoAppList) {
                                    if (applicant.id == objDDCoApp.Applicant__c) {
                                        system.debug('--- Inside Co App Dedupe Match---');
                                        system.debug('::objDDCoApp::' + objDDCoApp);
                                        if (objDDCoApp.Customer_ID__c != null && !objDDCoApp.Customer_ID__c.equalsIgnoreCase('No Match')) {
                                            String customerId = '';
                                            system.debug('---objDDCoApp.Customer_ID__c---' + objDDCoApp.Customer_ID__c);
                                            if (objDDCoApp.Customer_ID__c.contains('||')) {
                                                
                                                customerId = objDDCoApp.Customer_ID__c.substring(0, objDDCoApp.Customer_ID__c.indexOf('||'));
                                            } else {
                                                if (objDDCoApp.Customer_ID__c.contains('REJECT')) {
                                                    customerId = objDDCoApp.Customer_ID__c.substring(0, objDDCoApp.Customer_ID__c.indexOf('REJECT'));
                                                } else {
                                                    if (objDDCoApp.Customer_ID__c.isNumeric()) {
                                                        customerId = objDDCoApp.Customer_ID__c;
                                                    }
                                                }
                                            }
                                            
                                            if (customerId != '') {
                                                FinnoneNew.Existing_Customer__c = customerId;
                                                system.debug('---FinnoneNew.Existing_Customer__c---' + FinnoneNew.Existing_Customer__c);
                                                FinnoneNew.Auto_De_dupe__c = 'Y';
                                            }
                                            
                                        } else {
                                            FinnoneNew.Auto_De_dupe__c = 'N';
                                        }
                                    }
                                }
                            } else {
                                system.debug('--- Inside Co App Not Dedupe Match---');
                                system.debug('::objDedupe::' + objDedupe);
                                if (objDedupe.Customer_ID__c != null && !objDedupe.Customer_ID__c.equalsIgnoreCase('No Match')) {
                                    String customerId = '';
                                    system.debug('---objDedupe.Customer_ID__c---' + objDedupe.Customer_ID__c);
                                    if (objDedupe.Customer_ID__c.contains('||')) {
                                        
                                        customerId = objDedupe.Customer_ID__c.substring(0, objDedupe.Customer_ID__c.indexOf('||'));
                                    } else {
                                        if (objDedupe.Customer_ID__c.contains('REJECT')) {
                                            customerId = objDedupe.Customer_ID__c.substring(0, objDedupe.Customer_ID__c.indexOf('REJECT'));
                                        } else {
                                            if (objDedupe.Customer_ID__c.isNumeric()) {
                                                customerId = objDedupe.Customer_ID__c;
                                            }
                                        }
                                    }
                                    
                                    if (customerId != '') {
                                        FinnoneNew.Existing_Customer__c = customerId;
                                        system.debug('---FinnoneNew.Existing_Customer__c---' + FinnoneNew.Existing_Customer__c);
                                        FinnoneNew.Auto_De_dupe__c = 'Y';
                                    }
                                    
                                } else {
                                    FinnoneNew.Auto_De_dupe__c = 'N';
                                }
                            }
                            
                        }
                        
                        //End Decentraised
                        //sal lineassignment :: start
                        if (Loan.Scheme_Master__r.Name != null && Loan.Scheme_Master__r.Name.ToUpperCase() == 'SAL LINE UTILIZED') {
                            FinnoneNew.Existing_Customer__c = primary.Contact_Name__r.CIF_Id__c;
                            
                        }
                        //sal lineassignment :: end
                        System.debug('applicant.Contact_Name__r.Gender__c=' + applicant.Contact_Name__r.Gender__c);
                        
                        if (applicant.Contact_Name__r.Gender__c == 'Male') FinnoneNew.Gender__c = 'M';
                        else FinnoneNew.Gender__c = 'F';
                        
                        
                        //System.debug('FinnoneNew.Gender__c=' + FinnoneNew.Gender__c);
                        
                        FinnoneNew.Age__c = applicant.Contact_Name__r.Age__c;
                        if (applicant.Contact_Name__r.Employment_Type__c == 'Salaried' || applicant.Contact_Name__r.Employment_Type__c == 'salaried') FinnoneNew.Employment_Type__c = 'SAL';
                        FinnoneNew.Incorporation_Date__c = applicant.Contact_Name__r.Year_of_Incorporation__c;
                        FinnoneNew.Registered_Address_1__c = applicant.Contact_Name__r.Address_1__c;
                        FinnoneNew.Registered_Address_2__c = applicant.Contact_Name__r.Address_2__c;
                        FinnoneNew.Registered_Address_3__c = applicant.Contact_Name__r.Address_3__c;
                        FinnoneNew.Registered_Zip_Code__c = string.valueof(applicant.Contact_Name__r.Pin_Code__c);
                        FinnoneNew.Registered_STD_Code__c = string.valueof(applicant.Contact_Name__r.STD_Code__c);
                        if (applicant.Contact_Name__r.Phone_Number__c != null) FinnoneNew.Registered_Phone_No__c = applicant.Contact_Name__r.Phone_Number__c;
                        
                        if (Loan.Product__c == 'FAS' && applicant.Contact_Name__r.Phone_Number__c == null && applicant.Contact_Name__r.Residence_Landline_phone__c != null) {
                            FinnoneNew.Registered_Phone_No__c = applicant.Contact_Name__r.Residence_Landline_phone__c;
                            FinnoneNew.Residence_Phone__c = applicant.Contact_Name__r.Residence_Landline_phone__c;
                        }
                        //7660 S
                        if (Loan.Product__c == 'FAS' && applicant.Contact_Name__r.STD_Code__c == null) {
                            FinnoneNew.Registered_STD_Code__c = string.valueof(stdCode);
                        }
                        if (Loan.Product__c == 'FAS' && applicant.Contact_Name__r.Phone_Number__c == null && applicant.Contact_Name__r.Residence_Landline_phone__c == null) {
                            FinnoneNew.Registered_Phone_No__c = regPhoNumStr;
                        }
                        //7660 E
                        if (applicant.Contact_Name__r.Mobile_Phone__c != null) FinnoneNew.Registered_Mobile_No__c = applicant.Contact_Name__r.Mobile_Phone__c;
                        FinnoneNew.Residence_Address_1__c = applicant.Contact_Name__r.Address_1__c;
                        FinnoneNew.Residence_Address_2__c = applicant.Contact_Name__r.Address_2__c;
                        FinnoneNew.Residence_Address_3__c = applicant.Contact_Name__r.Address_3__c;
                        FinnoneNew.Residence_Pin_Code__c = string.valueof(applicant.Contact_Name__r.Pin_Code__c);
                        FinnoneNew.Residence_STD_Code__c = applicant.Contact_Name__r.STD_Code__c;
                        if (applicant.Contact_Name__r.Phone_Number__c != null) FinnoneNew.Residence_Phone__c = applicant.Contact_Name__r.Phone_Number__c;
                        if (applicant.Contact_Name__r.Mobile_Phone__c != null) FinnoneNew.Residence_Mobile__c = applicant.Contact_Name__r.Mobile_Phone__c;
                        if (loan.Customer_email_id__c != null && loan.Customer_email_id__c != '') FinnoneNew.Residence_E_Mail__c = loan.Customer_email_id__c;
                        else FinnoneNew.Residence_E_Mail__c = loan.Accountant_email_id__c;
                        FinnoneNew.Other_Employer_Name__c = applicant.Contact_Name__r.Name_of_Employer__c;
                        //added by Suraj...Audit Finnone enhancement...Start
                        FinnoneNew.office_email_id__c = loan.Account.Accountant_email_id__c;
                        FinnoneNew.Office_Landline_Number1__c = loan.Account.Office_Landline_Number1__c;
                        //added by Suraj...Audit Finnone enhancement...end
                        FinnoneNew.Contact_Person_Name1__c = cpn;
                        FinnoneNew.ROC_Registration_Number__c = applicant.Contact_Name__r.ROC_Regn_No__c;
                        FinnoneNew.Property_Status__c = applicant.Contact_Name__r.Residence_Type__c;
                        FinnoneNew.Property_Pin_Code__c = String.valueOf(applicant.Contact_Name__r.Pin_Code__c);
                        
                        //Loading Primary Applicant's Details
                        FinnoneNew.Primary_Date_of_Birth__c = primary.Contact_Name__r.Date_of_Birth__c;
                        FinnoneNew.Primary_First_Name__c = primary.Contact_Name__r.FirstName;
                        FinnoneNew.Primary_Last_Name__c = primary.Contact_Name__r.LastName;
                        //send to finnone enhancement
                        FinnoneNew.Note_code__c = primary.Note_code__c;
                        FinnoneNew.Note_details__c = primary.Note_details__c;
                        FinnoneNew.Payment_Type__c = primary.Payment_type__c;
                        FinnoneNew.Employer_Name__c = primary.Employer__c;
                        FinnoneNew.City__c = primary.City__c;
                        // added for to pass applicant id
                        FinnoneNew.Applicant_ID__c = applicant.name;
                        
                        // new filed CIF id added on 8/06/2012 by wipro  < -----god -----------siva------>
                        //FinnoneNew.CIF_Id__c = primary.Contact_Name__r.CIF_Id__c;//Commented for following Change Request : Bug 15137 - Update CIF ID of finnone report  
                        //Bug 15137 - Update CIF ID of finnone report    Dedupe Referal  Start
                        if (applicant.Contact_Name__c != null && applicant.Contact_Name__r.CIF_Id__c != null)
                            FinnoneNew.CIF_Id__c = applicant.Contact_Name__r.CIF_Id__c;
                        //Bug 15137 - Update CIF ID of finnone report    Dedupe Referal  End
                        
                        if (primary.Contact_Name__r.Middle_Name__c != null) {
                            splitstr = (primary.Contact_Name__r.Middle_Name__c).split(' ');
                            if (splitstr != null) FinnoneNew.Primary_Middle_Name__c = splitstr[0];
                        } else if (primary.Contact_Name__r.FathersHusbands_Name__c != null) {
                            
                            splitstr = (primary.Contact_Name__r.FathersHusbands_Name__c).split(' ');
                            if (splitstr != null) FinnoneNew.Primary_Middle_Name__c = splitstr[0];
                        } else FinnoneNew.Primary_Middle_Name__c = ' ';
                        
                        FinnoneNew.Primary_PAN__c = primary.Contact_Name__r.PAN_Number__c;
                        FinnoneNew.Primary_Incorporate_Date__c = primary.Contact_Name__r.Year_of_Incorporation__c;
                        FinnoneNew.Primary_ROC_Registration_Number__c = primary.Contact_Name__r.ROC_Regn_No__c;
                        
                        //Step Up Step Down Emi Details
                        if (loan.EMI_Type__c == 'Step-Up' || loan.EMI_Type__c == 'Step-Down') {
                            FinnoneNew.Year_1_EMI__c = primary.StepUp_StepDown_EMI_Year_1__c;
                            FinnoneNew.Year_2_EMI__c = primary.StepUp_StepDown_EMI_Year_2__c;
                            FinnoneNew.Year_3_EMI__c = primary.StepUp_StepDown_EMI_Year_3__c;
                            FinnoneNew.Year_4_EMI__c = primary.StepUp_StepDown_EMI_Year_4__c;
                            FinnoneNew.Year_5_EMI__c = primary.StepUp_StepDown_EMI_Year_5__c;
                        }
                        //End
                        /**
if(applicant .Contact_Name__r.ApplicantType__c=='Primary')
{
//system.debug('iiiiiiiiiiiiiiiii');
system.debug('iidddd'+applicant.id);
FinnoneNew.Primary_Applicant_Type__c='P';
}
else if(applicant.Contact_Name__r.ApplicantType__c=='Guarantor'){
FinnoneNew.Primary_Applicant_Type__c='G';
}

else 
{
//system.debug('eeeeeeeeeeee');
system.debug('iidddd'+applicant.id);
FinnoneNew.Primary_Applicant_Type__c='C'; 
} 

**/
                        
                        system.debug(checklistdocs.size() + 'sizeeeeeeee');
                        /** if(!checklistdocs.isempty())
{

system.debug(checklistdocs.size()+'sizeeeeeeee');
FinnoneNew.DocFinnoneReport__c=true;
}else{ 
FinnoneNew.DocFinnoneReport__c=false;    

}   
**/
                        //Added DK-Sart-Bug 718
                        if (loan != null) {
                            if (loan.Product__c == 'SHL') {
                                if (hlcamAppr != null) {
                                    FinnoneNew.Avg_Net_Income_Month__c = hlcamAppr.Avg_Net_Sal__c;
                                }
                            } else {
                                if (camAppr != null) {
                                    FinnoneNew.Avg_Net_Income_Month__c = camAppr.Final_Net_An_Inc__c;
                                }
                            }
                            
                        }
                        //Added DK-End-Bug 718
                        
                        if (primary.Contact_Name__r.ApplicantType__c == 'Primary' && loan.ELC_offer_accepted__c == true && loan.Product__c != 'DPL' && loan.Product__c != 'CRISL' && loan.Product__c != 'CE' && loan.Product__c != 'SAL' && loan.Product__c != 'SOL' && loan.Product__c != 'SPL' && loan.Product__c != 'SBS CS SAL') {
                            
                            
                            
                            if (loan.Product__c == 'SHL') {
                                FinnoneNew.ELC_Line_Amounts__c = hlcamAppr.ELC_Line_Amounts__c;
                            } else {
                                system.debug('----' + Scam);
                                if (camAppr.ELC_Line_Amounts__c != null) FinnoneNew.ELC_Line_Amounts__c = camAppr.ELC_Line_Amounts__c;
                                else if (Scam != null) {
                                    FinnoneNew.ELC_Line_Amounts__c = Scam.ELC_Line_Amount__c;
                                    system.debug('----' + Scam.ELC_Line_Amount__c);
                                }
                            }
                            if (FinnoneNew.ELC_Line_Amounts__c != null)
                                if (FinnoneNew.ELC_Line_Amounts__c > 0) {
                                    FinnoneNew.Name_On_Card_ELC__c = loan.Name_On_Card_ELC__c;
                                    FinnoneNew.ELC_flag__c = true;
                                    if ( /*Bug :16959 S*/ isPSBLProductLineProduct == true /*Bug :16959 E*/ || isNewProductFlowEnabled == true || loan.Product__c == 'SBS CS PSBL' || loan.Product__c == 'DOCTORS' || DOCProducts.contains(loan.Product__c.toUppercase()) || loan.Product__c == 'RDL') {
                                        FinnoneNew.ELC_processing_fee__c = loan.ELC_charges__c;
                                    } else {
                                        try {
                                            decimal feesch;
                                            feesch = [select id, Change_Amount__c from Fees_and_Charge__c where Charge_Type__c = 'ELC Processing Fee'
                                                      and Loan_Application__c =: Loan.Id limit 1
                                                     ].Change_Amount__c;
                                            FinnoneNew.ELC_processing_fee__c = feesch;
                                        } catch (exception e) {
                                            system.debug('Exception is' + e.getMessage() + 'Line number is' + e.getLineNumber());
                                        }
                                    }
                                    
                                }
                            
                            
                            
                            // FinnoneNew.ELC_processing_fee__c=999;  
                        }
                        
                        
                        
                        if (primary.Contact_Name__r.ApplicantType__c == 'Primary') {
                            system.debug('iiiiiiiiiiiiiiiii');
                            system.debug('iidddd' + applicant.id);
                            FinnoneNew.Primary_Applicant_Type__c = 'P';
                        } else if (primary.Contact_Name__r.ApplicantType__c == 'Guarantor') {
                            FinnoneNew.Primary_Applicant_Type__c = 'G';
                        } else {
                            //system.debug('eeeeeeeeeeee');
                            system.debug('iidddd' + applicant.id);
                            FinnoneNew.Primary_Applicant_Type__c = 'C';
                        }
                        
                        if (primary.Contact_Name__r.Customer_Type__c == 'Individual') FinnoneNew.Primary_Customer_Type__c = 'I';
                        else if (primary.Contact_Name__r.Customer_Type__c == 'Corporate') FinnoneNew.Primary_Customer_Type__c = 'C';
                        
                        if (primary.Contact_Name__r.Customer_Profile__c == 'Salaried') FinnoneNew.Primary_Customer_Profile__c = '3';
                        else if (primary.Contact_Name__r.Customer_Profile__c == 'SEP') FinnoneNew.Primary_Customer_Profile__c = '4';
                        else if (primary.Contact_Name__r.Customer_Profile__c == 'SENP') FinnoneNew.Primary_Customer_Profile__c = '5';
                        else if (primary.Contact_Name__r.Customer_Profile__c == 'EMPLOYEE') FinnoneNew.Primary_Customer_Profile__c = '14';
                        else if (primary.Contact_Name__r.Customer_Profile__c == 'Others') FinnoneNew.Primary_Customer_Profile__c = '1';
                        
                        if (primary.Contact_Name__r.Marital_Status__c == 'Married') FinnoneNew.Primary_Marital_Status__c = 'M';
                        else if (primary.Contact_Name__r.Marital_Status__c == 'Single') FinnoneNew.Primary_Marital_Status__c = 'S';
                        else if (primary.Contact_Name__r.Marital_Status__c == 'Divorsed') FinnoneNew.Primary_Marital_Status__c = 'D';
                        else if (primary.Contact_Name__r.Marital_Status__c == 'Widow') FinnoneNew.Primary_Marital_Status__c = 'W';
                        
                        if (primary.Contact_Name__r.Type_Of_Constitution__c == 'PROBATIONARY') FinnoneNew.Primary_Constitution_type__c = '1';
                        else if (primary.Contact_Name__r.Type_Of_Constitution__c == 'REGULAR') FinnoneNew.Primary_Constitution_type__c = '2';
                        else if (primary.Contact_Name__r.Type_Of_Constitution__c == 'CONTRACTUAL') FinnoneNew.Primary_Constitution_type__c = '3';
                        else if (primary.Contact_Name__r.Type_Of_Constitution__c == 'PENSIONER') FinnoneNew.Primary_Constitution_type__c = '4';
                        else if (primary.Contact_Name__r.Type_Of_Constitution__c == 'PART TIME') FinnoneNew.Primary_Constitution_type__c = '5';
                        else if (primary.Contact_Name__r.Type_Of_Constitution__c == 'INDIRECT EARNERS') FinnoneNew.Primary_Constitution_type__c = '6';
                        else if (primary.Contact_Name__r.Type_Of_Constitution__c == 'GOVT ORGANIZATION') FinnoneNew.Primary_Constitution_type__c = '7';
                        else if (primary.Contact_Name__r.Type_Of_Constitution__c == 'LIMITED COMPANY') FinnoneNew.Primary_Constitution_type__c = '8';
                        else if (primary.Contact_Name__r.Type_Of_Constitution__c == 'PVT LIMITED COMPANY') FinnoneNew.Primary_Constitution_type__c = '9';
                        else if (primary.Contact_Name__r.Type_Of_Constitution__c == 'PARTNERSHIP') FinnoneNew.Primary_Constitution_type__c = '10';
                        else if (primary.Contact_Name__r.Type_Of_Constitution__c == 'PROPRIETARISHIP') FinnoneNew.Primary_Constitution_type__c = '11';
                        else if (primary.Contact_Name__r.Type_Of_Constitution__c == 'MNC') FinnoneNew.Primary_Constitution_type__c = '12';
                        else if (primary.Contact_Name__r.Type_Of_Constitution__c == 'OTHER') FinnoneNew.Primary_Constitution_type__c = '13';
                        
                        
                        system.debug('Loan.product__c#####################' + Loan.product__c);
                        //Loading Property Details
                        /*Code added by Rakesh Shinde.
Date : 18 August 2015
Comment : Code commented to re-modify logic for Centralized Disbursement
*/
                        //PRO added
                        // Bug:17470
                        if (isPROProductLineProduct || Loan.product__c == 'Home Loan' || Loan.product__c == 'LAP' || LAPprods.contains(loan.Product__c.toUppercase()) || Loan.product__c == 'SBS CS HL' || Loan.product__c == 'SBS CS LAP' || Loan.product__c == 'CE' || Loan.product__c == 'SHL' || Loan.product__c == 'SBS CS SHL') {
                            system.debug('product if#####################' + properties.size());
                            if (properties.size() > 0) {
                                
                                //start Finnone report for every document
                                
                                system.debug('finnone for document');
                                FinnOne_Report__c FinnoneforDoc = new FinnOne_Report__c();
                                FinnoneforDoc.Property_Address_1__c = properties[0].Property_Address_Line_1__c;
                                FinnoneforDoc.Property_Address_2__c = properties[0].Property_Address_Line_2__c;
                                FinnoneforDoc.Property_Address_3__c = properties[0].Property_Address_Line_3__c;
                                FinnoneforDoc.FinnOne_Property_code__c = properties[0].Name;
                                FinnoneforDoc.Property_Pin_Code__c = string.valueof(properties[0].Property_Pin_Code__c);
                                //FinnoneNew.Property_State__c=properties[0].Property_State__c;
                                FinnoneforDoc.Type_of_Measurement__c = properties[0].Type_Of_Measurement__c;
                                FinnoneforDoc.Total_Valuation_1__c = properties[0].Total_Valuation_1__c;
                                FinnoneforDoc.Total_Valuation_2__c = properties[0].Total_Valuation_2__c;
                                //FinnoneforDoc.Final_valuation__c=properties[0].Final_Valuation__c;
                                system.debug('properties[0].Property_Type__c$$$$$$$$$$$$' + properties[0].Property_Type__c);
                                //code commented by leena for bug 8012 making it generic by static resource
                                /*if (properties[0].Property_Type__c == 'SOCP') FinnoneforDoc.Property_Type__c = 'SOCP';
else if (properties[0].Property_Type__c == 'SORP') FinnoneforDoc.Property_Type__c = 'SORP';
else if (properties[0].Property_Type__c == 'Plot') FinnoneforDoc.Property_Type__c = 'PLOT';
else if (properties[0].Property_Type__c == 'Rented Commercial') FinnoneforDoc.Property_Type__c = 'RENTCOM';
else if (properties[0].Property_Type__c == 'Rented Residential') FinnoneforDoc.Property_Type__c = 'RENTRESI';
else if (properties[0].Property_Type__c == 'Vacant Residential') FinnoneforDoc.Property_Type__c = 'VACANTRESI';
else if (properties[0].Property_Type__c == 'NRP') FinnoneforDoc.Property_Type__c = 'NRP';
else if (properties[0].Property_Type__c == 'Vacant Commercial') FinnoneforDoc.Property_Type__c = 'VACNTCOMM';
else if (properties[0].Property_Type__c == 'Mixed usage') FinnoneforDoc.Property_Type__c = 'MIXEDUSAGE';
*/
                                //code added by leena for bug 8012 making it generic by static resouce
                                // StaticResource srPropertyType = [select id, body from StaticResource Where Name = 'PropertyTypeFlowToFinnOne'];
                                // start nominee validation for products changes by rohit mourya
                                String contentsPropertyType = '';
                                for (StaticResource sr: srList) {
                                    if (sr.Name == 'PropertyTypeFlowToFinnOne')
                                        contentsPropertyType = sr.Body.toString();
                                }
                                // end nominee validation for products changes by rohit mourya
                                //String contentsPropertyType = srPropertyType.body.toString();
                                system.debug('body contents are' + contentsPropertyType);
                                if (contentsPropertyType != null && contentsPropertyType != '') {
                                    for (String line: contentsPropertyType.split('\n')) {
                                        if (line != null && line != '') {
                                            String[] arrayofPropertyType = line.split(',');
                                            if (properties[0].Property_Type__c == arrayofPropertyType[0]) {
                                                if (arrayofPropertyType.size() > 0 && arrayofPropertyType[1] != null) {
                                                    FinnoneforDoc.Property_Type__c = String.valueOf(arrayofPropertyType[1]);
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                }
                                //stop Finnone report for every document
                                
                                
                            }
                            
                        }
                        if (loan.Product__c == 'CE') {
                            FinnoneNew.Asset_Category__c = properties[0].Asset_Category__c;
                            FinnoneNew.Asset_Code__c = properties[0].Asset_Model__c;
                            FinnoneNew.Asset_Cost__c = properties[0].Asset_Cost__c;
                            FinnoneNew.Asset_Make__c = properties[0].Asset_Master__r.Name;
                            if (properties[0].Asset_FinnOne_Code__c != null) FinnoneNew.Asset_Model_Id__c = Decimal.valueof(properties[0].Asset_FinnOne_Code__c);
                            FinnoneNew.Contact_Person_Name1__c = cpn;
                            if (properties.size() > 0) FinnoneNew.Dealer_ID__c = properties[0].Dealer_Master__r.Dealer_ID__c;
                        }
                        
                        /*Code added by Rakesh Shinde.
Date : 16 August 2015
Comment : Code commented to re-modify logic for Centralized Disbursement
*/
                        /*
if(applicant.Applicant_Type__c=='Primary'){
//Added DK-Sart-Bug 718
if(repaymentmodes.size()>0){
for(integer k=0;k<repaymentmodes.size();k++){
if(k==0){
FinnoneNew.MICR__c=string.valueof(repaymentmodes[0].MICR_Code__c);
FinnoneNew.Bank__c=repaymentmodes[0].Bank_Name__c;
FinnoneNew.Bank_Branch__c=repaymentmodes[0].Bank_Branch__c;
FinnoneNew.Customer_A_C_No__c=repaymentmodes[0].A_C_NO__c;
FinnoneNew.ECS_BarcodeNo__c=repaymentmodes[0].ECS_Barcode_No__c;  //added by Suraj ...ECS MAndate enhancement
}
}
}

*/
                        
                        // Properties
                        /*Code added by Rakesh Shinde.
Date : 18 August 2015
Comment : Code commented to re-modify logic for Centralized Disbursement
*/
                        /*

if(feeCharge.Charge_Type__c == 'Financial Health Check Guide ( Credit Vidya )'){

//3533
if(FFRSMEProductflag==true){
FinnoneNew.SQUD_CHARGE_ID_1__c = 500173;
}
else
FinnoneNew.SQUD_CHARGE_ID_1__c = 600131;

FinnoneNew.Fin_Health_Check_Guide_Credit_Vidya__c = feeCharge.Change_Amount__c ;
}
else if(feeCharge.Charge_Type__c == 'EMI Card Charge'){
FinnoneNew.SQUD_CHARGE_ID_2__c = 500671;
FinnoneNew.EMI_Card_Charge__c = feeCharge.Change_Amount__c ;
}
else if(feeCharge.Charge_Type__c == 'Health Insurance'){
FinnoneNew.SQUD_CHARGE_ID_3__c = 600130;
FinnoneNew.Health_Insurance__c = feeCharge.Change_Amount__c ;
}
}
*/
                        /* Customer Level Collateral Tracking added by priya start  */
                        Boolean collateralFlag = false;
                        List < StaticResource > srcList = new List < StaticResource > ();
                        srcList = [SELECT Body, Id, Name FROM StaticResource WHERE Name = 'SalariedCustomSettings'
                                   limit 1
                                  ];
                        if (srcList.size() > 0) {
                            String jsnBodySal = srcList[0].Body.tostring();
                            Map < String, Object > salCustSet = (Map < String, Object > ) JSON.deserializeUntyped(jsnBodySal);
                            Map < String, Object > colVal = new Map < String, Object > ();
                            colVal = (Map < String, Object > ) salCustSet.get('customer_collateral');
                            if (colVal != null && colVal.get('Products') != null) {
                                String[] arr1 = String.valueof(colVal.get('Products')).split(';');
                                for (String str: arr1) {
                                    if (str.equalsIgnoreCase(Loan.Product__c)) {
                                        collateralFlag = true;
                                    }
                                }
                            }
                        }
                        /* Customer Level Collateral Tracking added by priya end  */
                        for (integer i = 0; i < properties.size(); i++) {
                            system.debug('Properties' + properties[i]);
                            if (i == 0) {
                                FinnoneNew.Property_Address_1__c = properties[0].Property_Address_Line_1__c;
                                FinnoneNew.Property_Address_2__c = properties[0].Property_Address_Line_2__c;
                                FinnoneNew.Property_Address_3__c = properties[0].Property_Address_Line_3__c;
                                FinnoneNew.FinnOne_Property_code__c = properties[0].Name;
                                FinnoneNew.Total_Valuation_1__c = properties[0].Total_Valuation_1__c;
                                FinnoneNew.Total_Valuation_2__c = properties[0].Total_Valuation_2__c;
                                FinnoneNew.Final_valuation__c = properties[0].Final_Valuation__c;
                                /* Property Dedupe Bug 12944 Start - Anshita*/
                                if (properties[0].LinkedPropertyCode__c != null) {
                                    FinnoneNew.PropertyCodefromFinnOne__c = properties[0].LinkedPropertyCode__c;
                                }
                                if (properties[0].Geolocation__Latitude__s != null) {
                                    FinnoneNew.Latitude__c = properties[0].Geolocation__Latitude__s;
                                }
                                if (properties[0].Geolocation__Longitude__s != null) {
                                    FinnoneNew.Longitude__c = properties[0].Geolocation__Longitude__s;
                                }
                                FinnoneNew.Property_Id__c = properties[0].Id;
                                if (properties[0].Area_Locality__c != null) {
                                    FinnoneNew.Area_Locality__c = properties[0].Area_Locality__c;
                                }
                                if (properties[0].Builder_Maintenance__c != null && properties[0].Builder_Maintenance__r.Name != null) {
                                    FinnoneNew.Builder_Name__c = properties[0].Builder_Maintenance__r.Name;
                                }
                                if (properties[0].Project_Name__c != null && properties[0].Project_Name__r.Name != null) {
                                    FinnoneNew.Project_Name__c = properties[0].Project_Name__r.Name;
                                }
                                /* Property Dedupe Bug 12944 End - Anshita*/
                                //Added DK-Sart-Bug 718
                                FinnoneNew.Type_of_Measurement__c = properties[0].Type_Of_Measurement__c;
                                FinnoneNew.Property_Country__c = 'India';
                                FinnoneNew.Property_State__c = properties[0].Property_State__c;
                                FinnoneNew.Property_City__c = properties[0].Property_City__c;
                                //Added DK-END-Bug 718
                                //FinnoneNew.Final_valuation__c=finalvalTot1;
                                if (properties[0].Property_Pin_Code__c != null) {
                                    FinnoneNew.Property_Pin_Code__c = String.valueof(properties[0].Property_Pin_Code__c);
                                }
                                // FinnoneNew.Property_State__c=properties[0].Property_State__c;
                                //FinnoneNew.Property_Type__c=properties[0].Property_Type__c;
                                if (properties[0].Property_Type__c == 'SOCP') FinnoneNew.Property_Type__c = 'SOCP';
                                else if (properties[0].Property_Type__c == 'SORP') FinnoneNew.Property_Type__c = 'SORP';
                                else if (properties[0].Property_Type__c == 'Plot') FinnoneNew.Property_Type__c = 'PLOT';
                                else if (properties[0].Property_Type__c == 'Rented Commercial') FinnoneNew.Property_Type__c = 'RENTCOM';
                                else if (properties[0].Property_Type__c == 'Rented Residential') FinnoneNew.Property_Type__c = 'RENTRESI';
                                else if (properties[0].Property_Type__c == 'Vacant Residential') FinnoneNew.Property_Type__c = 'VACANTRESI';
                                else if (properties[0].Property_Type__c == 'NRP') FinnoneNew.Property_Type__c = 'NRP';
                                else if (properties[0].Property_Type__c == 'Vacant Commercial') FinnoneNew.Property_Type__c = 'VACNTCOMM';
                                else if (properties[0].Property_Type__c == 'Mixed usage') FinnoneNew.Property_Type__c = 'MIXEDUSAGE';
                                
                                if (properties[0].Asset_Type__c == 'New') FinnoneNew.Loan_facility__c = 'New';
                                else if (properties[0].Asset_Type__c == 'Used') FinnoneNew.Loan_facility__c = 'Used';
                                else if (properties[0].Asset_Type__c == 'Refinance') FinnoneNew.Loan_facility__c = 'ReFin';
                                else if (properties[0].Asset_Type__c == 'Balance Transfer') FinnoneNew.Loan_facility__c = 'BalTrns';
                                else if (properties[0].Asset_Type__c == 'Bank Guarantee') FinnoneNew.Loan_facility__c = 'BankGte';
                                else if (properties[0].Asset_Type__c == 'Secured Working Capital') FinnoneNew.Loan_facility__c = 'SecWkCp';
                                else if (properties[0].Asset_Type__c == 'Re-Schedule') FinnoneNew.Loan_facility__c = 'RESCH';
                                else if (properties[0].Asset_Type__c == 'Balance Transfer-Top up') FinnoneNew.Loan_facility__c = 'BTTU';
                                else if (properties[0].Asset_Type__c == 'Secured Short Term Loan') FinnoneNew.Loan_facility__c = 'SSTL';
                                else if (properties[0].Asset_Type__c == 'Unsecured Loans') FinnoneNew.Loan_facility__c = 'UL';
                                /* Customer Level Collateral Tracking added by priya start  */
                                if (collateralFlag) {
                                    if (properties[0].Existing_Loan_Funded_amount__c != null) {
                                        FinnoneNew.Amount_Funded_on_Property1__c = properties[0].Existing_Loan_Funded_amount__c;
                                    }
                                }
                                /* Customer Level Collateral Tracking added by priya end  */
                                
                            }
                            if (i == 1) {
                                FinnoneNew.Property1_Address_1__c = properties[1].Property_Address_Line_1__c;
                                FinnoneNew.Property1_Address_2__c = properties[1].Property_Address_Line_2__c;
                                FinnoneNew.Property1_Address_3__c = properties[1].Property_Address_Line_3__c;
                                FinnoneNew.FinnOne_Property_code_1__c = properties[1].Name;
                                FinnoneNew.Property_1_Total_valuation__c = properties[1].Total_Valuation_1__c;
                                FinnoneNew.Property_1_Total_valuation_2__c = properties[1].Total_Valuation_2__c;
                                FinnoneNew.Final_valuation_1__c = properties[1].Final_Valuation__c;
                                //FinnoneNew.Final_valuation_1__c=finalvalTot1;
                                /* Property Dedupe Bug 12944 Start - Anshita*/
                                if (properties[1].LinkedPropertyCode__c != null) {
                                    FinnoneNew.PropertyCodefromFinnOne1__c = properties[1].LinkedPropertyCode__c;
                                }
                                if (properties[1].Geolocation__Latitude__s != null) {
                                    FinnoneNew.Latitude1__c = properties[1].Geolocation__Latitude__s;
                                }
                                if (properties[1].Geolocation__Longitude__s != null) {
                                    FinnoneNew.Longitude1__c = properties[1].Geolocation__Longitude__s;
                                }
                                FinnoneNew.Property_ID_1__c = properties[1].Id;
                                if (properties[1].Area_Locality__c != null) {
                                    FinnoneNew.Area_Locality1__c = properties[1].Area_Locality__c;
                                }
                                if (properties[1].Builder_Maintenance__c != null && properties[1].Builder_Maintenance__r.Name != null) {
                                    FinnoneNew.Builder_Name1__c = properties[1].Builder_Maintenance__r.Name;
                                }
                                if (properties[1].Project_Name__c != null && properties[1].Project_Name__r.Name != null) {
                                    FinnoneNew.Project_Name1__c = properties[1].Project_Name__r.Name;
                                }
                                /* Property Dedupe Bug 12944 End - Anshita*/
                                //Added DK-Sart-Bug 718
                                FinnoneNew.Type_of_Measurement_1__c = properties[1].Type_Of_Measurement__c;
                                FinnoneNew.Property1_Country__c = 'India';
                                FinnoneNew.Property1_State__c = properties[1].Property_State__c;
                                FinnoneNew.Property1_City__c = properties[1].Property_City__c;
                                //Added DK-END-Bug 718
                                if (properties[1].Property_Pin_Code__c != null) {
                                    
                                    FinnoneNew.Property1_Pin_Code__c = String.valueof(properties[1].Property_Pin_Code__c);
                                }
                                // FinnoneNew.Property1_State__c=properties[1].Property_State__c;
                                // FinnoneNew.Property1_Type__c=properties[1].Property_Type__c;
                                if (properties[1].Property_Type__c == 'SOCP') FinnoneNew.Property1_Type__c = 'SOCP';
                                else if (properties[1].Property_Type__c == 'SORP') FinnoneNew.Property1_Type__c = 'SORP';
                                else if (properties[1].Property_Type__c == 'Plot') FinnoneNew.Property1_Type__c = 'PLOT';
                                else if (properties[1].Property_Type__c == 'Rented Commercial') FinnoneNew.Property1_Type__c = 'RENTCOM';
                                else if (properties[1].Property_Type__c == 'Rented Residential') FinnoneNew.Property1_Type__c = 'RENTRESI';
                                else if (properties[1].Property_Type__c == 'Vacant Residential') FinnoneNew.Property1_Type__c = 'VACANTRESI';
                                else if (properties[1].Property_Type__c == 'NRP') FinnoneNew.Property1_Type__c = 'NRP';
                                else if (properties[1].Property_Type__c == 'Vacant Commercial') FinnoneNew.Property1_Type__c = 'VACNTCOMM';
                                else if (properties[1].Property_Type__c == 'Mixed usage') FinnoneNew.Property1_Type__c = 'MIXEDUSAGE';
                                /* Customer Level Collateral Tracking added by priya start  */
                                if (collateralFlag) {
                                    if (properties[1].Existing_Loan_Funded_amount__c != null)
                                        FinnoneNew.Amount_Funded_on_Property2__c = properties[1].Existing_Loan_Funded_amount__c;
                                }
                                /* Customer Level Collateral Tracking added by priya end  */
                            }
                            if (i == 2) {
                                FinnoneNew.Property2_Address_1__c = properties[2].Property_Address_Line_1__c;
                                FinnoneNew.Property2_Address_2__c = properties[2].Property_Address_Line_2__c;
                                FinnoneNew.Property2_Address_3__c = properties[2].Property_Address_Line_3__c;
                                FinnoneNew.FinnOne_Property_code_2__c = properties[2].Name;
                                FinnoneNew.Property_2_Total_valuation_1__c = properties[2].Total_Valuation_1__c;
                                FinnoneNew.Property_2_Total_valuation_2__c = properties[2].Total_Valuation_2__c;
                                FinnoneNew.Final_valuation_2__c = properties[2].Final_Valuation__c;
                                /* Property Dedupe Bug 12944 Start - Anshita*/
                                if (properties[2].LinkedPropertyCode__c != null) {
                                    FinnoneNew.PropertyCodefromFinnOne2__c = properties[2].LinkedPropertyCode__c;
                                }
                                if (properties[2].Geolocation__Latitude__s != null) {
                                    FinnoneNew.Latitude2__c = properties[2].Geolocation__Latitude__s;
                                }
                                if (properties[2].Geolocation__Longitude__s != null) {
                                    FinnoneNew.Longitude2__c = properties[2].Geolocation__Longitude__s;
                                }
                                FinnoneNew.Property_ID_2__c = properties[2].Id;
                                if (properties[2].Area_Locality__c != null) {
                                    FinnoneNew.Area_Locality2__c = properties[2].Area_Locality__c;
                                }
                                if (properties[2].Builder_Maintenance__c != null && properties[2].Builder_Maintenance__r.Name != null) {
                                    FinnoneNew.Builder_Name2__c = properties[2].Builder_Maintenance__r.Name;
                                }
                                if (properties[2].Project_Name__c != null && properties[2].Project_Name__r.Name != null) {
                                    FinnoneNew.Project_Name2__c = properties[2].Project_Name__r.Name;
                                }
                                /* Property Dedupe Bug 12944 Start - Anshita*/
                                //Added DK-Sart-Bug 718
                                FinnoneNew.Type_of_Measurement_2__c = properties[2].Type_Of_Measurement__c;
                                FinnoneNew.Property2_Country__c = 'India';
                                FinnoneNew.Property2_State__c = properties[2].Property_State__c;
                                FinnoneNew.Property2_City__c = properties[2].Property_City__c;
                                //Added DK-END-Bug 718
                                //FinnoneNew.Final_valuation_2__c=finalvalTot1;
                                if (properties[2].Property_Pin_Code__c != null) {
                                    FinnoneNew.Property2_Pin_Code__c = String.valueof(properties[2].Property_Pin_Code__c);
                                }
                                // FinnoneNew.Property2_State__c=properties[2].Property_State__c;
                                //FinnoneNew.Property2_Type__c=properties[2].Property_Type__c;
                                if (properties[2].Property_Type__c == 'SOCP') FinnoneNew.Property2_Type__c = 'SOCP';
                                else if (properties[2].Property_Type__c == 'SORP') FinnoneNew.Property2_Type__c = 'SORP';
                                else if (properties[2].Property_Type__c == 'Plot') FinnoneNew.Property2_Type__c = 'PLOT';
                                else if (properties[2].Property_Type__c == 'Rented Commercial') FinnoneNew.Property2_Type__c = 'RENTCOM';
                                else if (properties[2].Property_Type__c == 'Rented Residential') FinnoneNew.Property2_Type__c = 'RENTRESI';
                                else if (properties[2].Property_Type__c == 'Vacant Residential') FinnoneNew.Property2_Type__c = 'VACANTRESI';
                                else if (properties[2].Property_Type__c == 'NRP') FinnoneNew.Property2_Type__c = 'NRP';
                                else if (properties[2].Property_Type__c == 'Vacant Commercial') FinnoneNew.Property2_Type__c = 'VACNTCOMM';
                                else if (properties[2].Property_Type__c == 'Mixed usage') FinnoneNew.Property2_Type__c = 'MIXEDUSAGE';
                                /* Customer Level Collateral Tracking added by priya start  */
                                if (collateralFlag) {
                                    if (properties[2].Existing_Loan_Funded_amount__c != null)
                                        FinnoneNew.Amount_Funded_on_Property3__c = properties[2].Existing_Loan_Funded_amount__c;
                                }
                                /* Customer Level Collateral Tracking added by priya end  */
                            }
                            if (i == 3) {
                                FinnoneNew.Property3_Address_1__c = properties[3].Property_Address_Line_1__c;
                                FinnoneNew.Property3_Address_2__c = properties[3].Property_Address_Line_2__c;
                                FinnoneNew.Property3_Address_3__c = properties[3].Property_Address_Line_3__c;
                                FinnoneNew.FinnOne_Property_code_3__c = properties[3].Name;
                                FinnoneNew.Property_3_Total_valuation_1__c = properties[3].Total_Valuation_1__c;
                                FinnoneNew.Property_3_Total_valuation_2__c = properties[3].Total_Valuation_2__c;
                                FinnoneNew.Final_valuation_3__c = properties[3].Final_Valuation__c;
                                /* Property Dedupe Bug 12944 Start - Anshita*/
                                if (properties[3].LinkedPropertyCode__c != null) {
                                    FinnoneNew.PropertyCodefromFinnOne3__c = properties[3].LinkedPropertyCode__c;
                                }
                                if (properties[3].Geolocation__Latitude__s != null) {
                                    FinnoneNew.Latitude3__c = properties[3].Geolocation__Latitude__s;
                                }
                                if (properties[3].Geolocation__Longitude__s != null) {
                                    FinnoneNew.Longitude3__c = properties[3].Geolocation__Longitude__s;
                                }
                                FinnoneNew.Property_ID_3__c = properties[3].Id;
                                if (properties[3].Area_Locality__c != null) {
                                    FinnoneNew.Area_Locality3__c = properties[3].Area_Locality__c;
                                }
                                if (properties[3].Builder_Maintenance__c != null && properties[3].Builder_Maintenance__r.Name != null) {
                                    FinnoneNew.Builder_Name3__c = properties[3].Builder_Maintenance__r.Name;
                                }
                                if (properties[3].Project_Name__c != null && properties[3].Project_Name__r.Name != null) {
                                    FinnoneNew.Project_Name3__c = properties[3].Project_Name__r.Name;
                                }
                                /* Property Dedupe Bug 12944 Start - Anshita*/
                                //Added DK-Sart-Bug 718
                                FinnoneNew.Type_of_Measurement_3__c = properties[3].Type_Of_Measurement__c;
                                FinnoneNew.Property3_Country__c = 'India';
                                FinnoneNew.Property3_State__c = properties[3].Property_State__c;
                                FinnoneNew.Property3_City__c = properties[3].Property_City__c;
                                //Added DK-END-Bug 718
                                //FinnoneNew.Final_valuation_3__c=finalvalTot1;
                                if (properties[3].Property_Pin_Code__c != null) {
                                    FinnoneNew.Property3_Pin_Code__c = string.valueof(properties[3].Property_Pin_Code__c);
                                }
                                //FinnoneNew.Property3_State__c=properties[3].Property_State__c;
                                //FinnoneNew.Property3_Type__c=properties[3].Property_Type__c;
                                if (properties[3].Property_Type__c == 'SOCP') FinnoneNew.Property3_Type__c = 'SOCP';
                                else if (properties[3].Property_Type__c == 'SORP') FinnoneNew.Property3_Type__c = 'SORP';
                                else if (properties[3].Property_Type__c == 'Plot') FinnoneNew.Property3_Type__c = 'PLOT';
                                else if (properties[3].Property_Type__c == 'Rented Commercial') FinnoneNew.Property3_Type__c = 'RENTCOM';
                                else if (properties[3].Property_Type__c == 'Rented Residential') FinnoneNew.Property3_Type__c = 'RENTRESI';
                                else if (properties[3].Property_Type__c == 'Vacant Residential') FinnoneNew.Property3_Type__c = 'VACANTRESI';
                                else if (properties[3].Property_Type__c == 'NRP') FinnoneNew.Property3_Type__c = 'NRP';
                                else if (properties[3].Property_Type__c == 'Vacant Commercial') FinnoneNew.Property3_Type__c = 'VACNTCOMM';
                                else if (properties[3].Property_Type__c == 'Mixed usage') FinnoneNew.Property3_Type__c = 'MIXEDUSAGE';
                                /* Customer Level Collateral Tracking added by priya start  */
                                if (collateralFlag) {
                                    if (properties[3].Existing_Loan_Funded_amount__c != null)
                                        FinnoneNew.Amount_Funded_on_Property4__c = properties[3].Existing_Loan_Funded_amount__c;
                                }
                                /* Customer Level Collateral Tracking added by priya end  */
                            }
                            if (i == 4) {
                                FinnoneNew.Property4_Address_1__c = properties[4].Property_Address_Line_1__c;
                                FinnoneNew.Property4_Address_2__c = properties[4].Property_Address_Line_2__c;
                                FinnoneNew.Property4_Address_3__c = properties[4].Property_Address_Line_3__c;
                                FinnoneNew.FinnOne_Property_code_4__c = properties[4].Name;
                                FinnoneNew.Property_4_Total_valuation_1__c = properties[4].Total_Valuation_1__c;
                                FinnoneNew.Property_4_Total_valuation_2__c = properties[4].Total_Valuation_2__c;
                                FinnoneNew.Final_valuation_4__c = properties[4].Final_Valuation__c;
                                /* Property Dedupe Bug 12944 Start - Anshita*/
                                if (properties[4].LinkedPropertyCode__c != null) {
                                    FinnoneNew.PropertyCodefromFinnOne4__c = properties[4].LinkedPropertyCode__c;
                                }
                                if (properties[4].Geolocation__Latitude__s != null) {
                                    FinnoneNew.Latitude4__c = properties[4].Geolocation__Latitude__s;
                                }
                                if (properties[4].Geolocation__Longitude__s != null) {
                                    FinnoneNew.Longitude4__c = properties[4].Geolocation__Longitude__s;
                                }
                                FinnoneNew.Property_ID_4__c = properties[4].Id;
                                if (properties[4].Area_Locality__c != null) {
                                    FinnoneNew.Area_Locality4__c = properties[4].Area_Locality__c;
                                }
                                if (properties[4].Builder_Maintenance__c != null && properties[4].Builder_Maintenance__r.Name != null) {
                                    FinnoneNew.Builder_Name4__c = properties[4].Builder_Maintenance__r.Name;
                                }
                                if (properties[4].Project_Name__c != null && properties[4].Project_Name__r.Name != null) {
                                    FinnoneNew.Project_Name4__c = properties[4].Project_Name__r.Name;
                                }
                                /* Property Dedupe Bug 12944 Start - Anshita*/
                                //Added DK-Sart-Bug 718
                                FinnoneNew.Type_of_Measurement_4__c = properties[4].Type_Of_Measurement__c;
                                FinnoneNew.Property4_Country__c = 'India';
                                FinnoneNew.Property4_State__c = properties[4].Property_State__c;
                                FinnoneNew.Property4_City__c = properties[4].Property_City__c;
                                //Added DK-END-Bug 718
                                //FinnoneNew.Final_valuation_4__c=finalvalTot1;
                                if (properties[4].Property_Pin_Code__c != null) {
                                    FinnoneNew.Property4_Pin_Code__c = String.valueof(properties[4].Property_Pin_Code__c);
                                }
                                //FinnoneNew.Property4_State__c=properties[0].Property_State__c;
                                //FinnoneNew.Property4_Type__c=properties[0].Property_Type__c;
                                if (properties[4].Property_Type__c == 'SOCP') FinnoneNew.Property4_Type__c = 'SOCP';
                                else if (properties[4].Property_Type__c == 'SORP') FinnoneNew.Property4_Type__c = 'SORP';
                                else if (properties[4].Property_Type__c == 'Plot') FinnoneNew.Property4_Type__c = 'PLOT';
                                else if (properties[4].Property_Type__c == 'Rented Commercial') FinnoneNew.Property4_Type__c = 'RENTCOM';
                                else if (properties[4].Property_Type__c == 'Rented Residential') FinnoneNew.Property4_Type__c = 'RENTRESI';
                                else if (properties[4].Property_Type__c == 'Vacant Residential') FinnoneNew.Property4_Type__c = 'VACANTRESI';
                                else if (properties[4].Property_Type__c == 'NRP') FinnoneNew.Property4_Type__c = 'NRP';
                                else if (properties[4].Property_Type__c == 'Vacant Commercial') FinnoneNew.Property4_Type__c = 'VACNTCOMM';
                                else if (properties[4].Property_Type__c == 'Mixed usage') FinnoneNew.Property4_Type__c = 'MIXEDUSAGE';
                                /* Customer Level Collateral Tracking added by priya start  */
                                if (collateralFlag) {
                                    if (properties[4].Existing_Loan_Funded_amount__c != null)
                                        FinnoneNew.Amount_Funded_on_Property5__c = properties[4].Existing_Loan_Funded_amount__c;
                                }
                                /* Customer Level Collateral Tracking added by priya end  */
                            }
                            
                        }
                        
                        //13793 S
                        if (TeleList != null && TeleList.size() > 0) {
                            
                            FinnoneNew.Disbursement_Type__c = 'TOP UP';
                            FinnoneNew.Ex_LAN_POS__c = TeleList[0].BalanceAmount__c;
                            if (TeleList.size() > 1) {
                                agreement = TeleList[0].ExistingLAN__c + ',';
                                for (Integer i = 1; i < TeleList.size(); i++) {
                                    FinnoneNew.Ex_LAN_POS__c += TeleList[i].BalanceAmount__c;
                                    if (i == TeleList.size() - 1) {
                                        agreement += TeleList[i].ExistingLAN__c;
                                    } else {
                                        agreement += TeleList[i].ExistingLAN__c + ',';
                                    }
                                }
                                FinnoneNew.ExistingLAN__c = agreement;
                            } else {
                                FinnoneNew.ExistingLAN__c = TeleList[0].ExistingLAN__c;
                            }
                        }
                        //13793 E
                        //Added condition for FAS
                        System.debug('************Loan.Product__c************>' + Loan.Product__c + '=Loan.Account.Group_Type__c=' + Loan.Account.Group_Type__c);
                        if (Loan.Product__c == 'FAS' && Loan.Account.Group_Type__c != null) {
                            System.debug('************CDDList.size()************>' + CDDList.size());
                            if (CDDList.size() > 0) {
                                Loan.A_C_No__c = CDDList[0].Bank_Account__c;
                                Loan.IFSC_Code__c = CDDList[0].IFSC_Code__c;
                                //Loan.Mode_of_Disbursal__c = CDDList[0].Disbursal_Mode__c;
                            }
                        }
                        
                        //Favouring__c,IFSC_Code__c,Disbursal_Mode__c,Bank_Account__c 
                        if (LAPprods.size() > 0 || SALProducts.size() > 0) {
                            if (LAPprods.contains(loan.Product__c.toUppercase()) || SALProducts.contains(loan.Product__c.toUppercase()) || isPROProductLineProduct || loan.Product__c.toUppercase() == 'RDL') {
                                System.debug('************CDDList.size()************>' + CDDList.size());
                                if (CDDList != null) {
                                    for (integer i = 0; i < CDDList.size(); i++) {
                                        Current_Disbursal_Details__c CDD = new Current_Disbursal_Details__c();
                                        CDD = CDDList[i];
                                        system.debug('disbursal revcord is====>' + CDD);
                                        system.debug('disbursal revcord is====> CDD.Disbursal_Mode__c' + CDD.Disbursal_Mode__c);
                                        system.debug('disbursal revcord is====> CDD.Favouring__c' + CDD.Favouring__c);
                                        system.debug('disbursal revcord is====> i' + i);
                                        if (i == 0) {
                                            
                                            Loan.A_C_No__c = CDD.Bank_Account__c;
                                            Loan.IFSC_Code__c = CDD.IFSC_Code__c;
                                            Loan.Mode_of_Disbursal__c = CDD.Disbursal_Mode__c;
                                            
                                            if (CDD.Disbursal_Mode__c != 'CHEQUE') {
                                                Loan.IFSC_Code__c = CDD.IFSC_Code__c;
                                                Loan.Favouring__c = CDD.Favouring__c;
                                                system.debug('without check###' + Loan.Favouring__c);
                                            } else {
                                                if (CDD.Favouring__c != null) Loan.Favouring__c = CDD.Favouring__c + ' ';
                                                system.debug('with check1###' + Loan.Favouring__c);
                                                if (CDD.Bank_Name__c != null) {
                                                    if (Loan.Favouring__c != null) Loan.Favouring__c = Loan.Favouring__c + CDD.Bank_Name__c + ' ';
                                                    else Loan.Favouring__c = CDD.Bank_Name__c + ' ';
                                                    system.debug('with check2###' + Loan.Favouring__c);
                                                }
                                                
                                                if (CDD.Bank_Account__c != null) {
                                                    if (Loan.Favouring__c != null) Loan.Favouring__c = Loan.Favouring__c + CDD.Bank_Account__c;
                                                    else Loan.Favouring__c = CDD.Bank_Account__c;
                                                    system.debug('with check3###' + Loan.Favouring__c);
                                                }
                                                
                                            }
                                            FinnoneNew.Amount__c = CDD.Disbursement_Amount__c;
                                            //15580--S
                                            if (CDD.isCloned__c == true) {
                                                FinnoneNew.Cloned_Record__c = 'True';
                                            }
                                            //15580--E
                                            if(CDD.Flexi_Adjustment__c != null)
                                            // Added for 1643 Start
                                            if(CDD.Flexi_Adjustment__c != null){
                                            FinnoneNew.Flexi_Adjustment__c = CDD.Flexi_Adjustment__c;
                                            }// Added for 1643 End
                                        }
                                        if (i == 1) {
                                            if (CDD.Disbursal_Mode__c != 'CHEQUE') {
                                                FinnoneNew.IFSC_Code_1__c = CDD.IFSC_Code__c;
                                                FinnoneNew.In_Favour_of_1__c = CDD.Favouring__c;
                                            } else {
                                                
                                                if (CDD.Favouring__c != null) FinnoneNew.In_Favour_of_1__c = CDD.Favouring__c + ' ';
                                                
                                                if (CDD.Bank_Name__c != null) {
                                                    if (FinnoneNew.In_Favour_of_1__c != null) FinnoneNew.In_Favour_of_1__c = FinnoneNew.In_Favour_of_1__c + CDD.Bank_Name__c + ' ';
                                                    else FinnoneNew.In_Favour_of_1__c = CDD.Bank_Name__c + ' ';
                                                }
                                                
                                                if (CDD.Bank_Account__c != null) {
                                                    if (FinnoneNew.In_Favour_of_1__c != null) FinnoneNew.In_Favour_of_1__c = FinnoneNew.In_Favour_of_1__c + CDD.Bank_Account__c;
                                                    else FinnoneNew.In_Favour_of_1__c = CDD.Bank_Account__c;
                                                    system.debug('hello world');
                                                }
                                                
                                            }
                                            
                                            FinnoneNew.Amount_1__c = CDD.Disbursement_Amount__c;
                                            FinnoneNew.Payment_Mode_1__c = CDD.Disbursal_Mode__c;
                                            FinnoneNew.Beneficiary_Account_Number_1__c = CDD.Bank_Account__c;
                                             // Added for 1643 Start
                                            if(CDD.Flexi_Adjustment__c != null){
                                            FinnoneNew.Flexi_Adjustment__c = CDD.Flexi_Adjustment__c;
                                            }// Added for 1643 End
                                            //send finnone enhancement.
                                            // FinnoneNew.Payment_Type__c=CDD.Payment_Type__c;
                                        }
                                        if (i == 2) {
                                            
                                            if (CDD.Disbursal_Mode__c != 'CHEQUE') {
                                                FinnoneNew.IFSC_Code_2__c = CDD.IFSC_Code__c;
                                                FinnoneNew.In_Favour_of_2__c = CDD.Favouring__c;
                                            } else {
                                                
                                                if (CDD.Favouring__c != null) FinnoneNew.In_Favour_of_2__c = CDD.Favouring__c + ' ';
                                                
                                                if (CDD.Bank_Name__c != null) {
                                                    if (FinnoneNew.In_Favour_of_2__c != null) FinnoneNew.In_Favour_of_2__c = FinnoneNew.In_Favour_of_2__c + CDD.Bank_Name__c + ' ';
                                                    else FinnoneNew.In_Favour_of_2__c = CDD.Bank_Name__c + ' ';
                                                }
                                                
                                                if (CDD.Bank_Account__c != null) {
                                                    if (FinnoneNew.In_Favour_of_2__c != null) FinnoneNew.In_Favour_of_2__c = FinnoneNew.In_Favour_of_2__c + CDD.Bank_Account__c;
                                                    else FinnoneNew.In_Favour_of_2__c = CDD.Bank_Account__c;
                                                }
                                                
                                            }
                                            
                                            FinnoneNew.Amount_2__c = CDD.Disbursement_Amount__c;
                                            FinnoneNew.Payment_Mode_2__c = CDD.Disbursal_Mode__c;
                                            FinnoneNew.Beneficiary_Account_Number_2__c = CDD.Bank_Account__c;
                                             // Added for 1643 Start
                                            if(CDD.Flexi_Adjustment__c != null){
                                            FinnoneNew.Flexi_Adjustment__c = CDD.Flexi_Adjustment__c;
                                            }// Added for 1643 End
                                        }
                                        if (i == 3) {
                                            if (CDD.Disbursal_Mode__c != 'CHEQUE') {
                                                FinnoneNew.IFSC_Code_3__c = CDD.IFSC_Code__c;
                                                FinnoneNew.In_Favour_of_3__c = CDD.Favouring__c;
                                            } else {
                                                
                                                if (CDD.Favouring__c != null) FinnoneNew.In_Favour_of_3__c = CDD.Favouring__c + ' ';
                                                
                                                if (CDD.Bank_Name__c != null) {
                                                    if (FinnoneNew.In_Favour_of_3__c != null) FinnoneNew.In_Favour_of_3__c = FinnoneNew.In_Favour_of_3__c + CDD.Bank_Name__c + ' ';
                                                    else FinnoneNew.In_Favour_of_3__c = CDD.Bank_Name__c + ' ';
                                                }
                                                
                                                if (CDD.Bank_Account__c != null) {
                                                    if (FinnoneNew.In_Favour_of_3__c != null) FinnoneNew.In_Favour_of_3__c = FinnoneNew.In_Favour_of_3__c + CDD.Bank_Account__c;
                                                    else FinnoneNew.In_Favour_of_3__c = CDD.Bank_Account__c;
                                                }
                                                
                                            }
                                            FinnoneNew.Amount_3__c = CDD.Disbursement_Amount__c;
                                            FinnoneNew.Payment_Mode_3__c = CDD.Disbursal_Mode__c;
                                            FinnoneNew.Beneficiary_Account_Number_3__c = CDD.Bank_Account__c;
                                             // Added for 1643 Start
                                            if(CDD.Flexi_Adjustment__c != null){
                                            FinnoneNew.Flexi_Adjustment__c = CDD.Flexi_Adjustment__c;
                                            }// Added for 1643 End
                                        }
                                        if (i == 4) {
                                            if (CDD.Disbursal_Mode__c != 'CHEQUE') {
                                                FinnoneNew.IFSC_Code_4__c = CDD.IFSC_Code__c;
                                                FinnoneNew.In_Favour_of_4__c = CDD.Favouring__c;
                                            } else {
                                                
                                                if (CDD.Favouring__c != null) FinnoneNew.In_Favour_of_4__c = CDD.Favouring__c + ' ';
                                                
                                                if (CDD.Bank_Name__c != null) {
                                                    if (FinnoneNew.In_Favour_of_4__c != null) FinnoneNew.In_Favour_of_4__c = FinnoneNew.In_Favour_of_4__c + CDD.Bank_Name__c + ' ';
                                                    else FinnoneNew.In_Favour_of_4__c = CDD.Bank_Name__c + ' ';
                                                }
                                                
                                                if (CDD.Bank_Account__c != null) {
                                                    if (FinnoneNew.In_Favour_of_4__c != null) FinnoneNew.In_Favour_of_4__c = FinnoneNew.In_Favour_of_4__c + CDD.Bank_Account__c;
                                                    else FinnoneNew.In_Favour_of_4__c = CDD.Bank_Account__c;
                                                }
                                                
                                            }
                                            FinnoneNew.Amount_4__c = CDD.Disbursement_Amount__c;
                                            FinnoneNew.Payment_Mode_4__c = CDD.Disbursal_Mode__c;
                                            FinnoneNew.Beneficiary_Account_Number_4__c = CDD.Bank_Account__c;
                                             // Added for 1643 Start
                                            if(CDD.Flexi_Adjustment__c != null){
                                            FinnoneNew.Flexi_Adjustment__c = CDD.Flexi_Adjustment__c;
                                            }// Added for 1643 End
                                        }
                                    }
                                }
                            }
                        }
                        //******************* emi holiday start
                        
                        //system.debug('primaryAppList[0].EMI_Holidays_Across_tenure__c'+primaryAppList[0].EMI_Holidays_Across_tenure__c);
                        //Cash in 60 mins primaryAppList[0].EMI_Holiday_Months__c != null added
                        if (primaryAppList != null && primaryAppList.size() > 0 && primaryAppList[0].EMI_Holidays_Across_tenure__c != null && primaryAppList[0].EMI_Holiday_Opted__c == true && primaryAppList[0].EMI_Holiday_Months__c != null) {
                            integer length = 0, i;
                            splitstr = (primaryAppList[0].EMI_Holidays_Across_tenure__c).split(';');
                            
                            if (splitstr.size() != null)
                                length = ((splitstr.size() > 11) ? 11 : (splitstr.size() - 1));
                            for (i = 0; i <= length; i++) {
                                string field = 'EMI_Holiday_Month_' + string.valueOf(i + 1) + '__c';
                                if (splitstr[i] != null) FinnoneNew.put(field, date.valueOf(splitstr[i]));
                            }
                            
                        }
                        
                        //***************** emi holiday stop
                        
                        
                        if (proOfferList.size() > 0 && proOfferList != null) {
                            for (Product_Offerings__c pList: proOfferList) {
                                if (pList.New_line_assigned__c == true || pList.Existing_line_utilized__c == true || pList.Line_updated__c == true) {
                                    system.debug('In PO');
                                    POObject = pList;
                                    FinnoneNew.Risk_Classification__c = POObject.Risk_Classification__c;
                                    FinnoneNew.Open_Ecs_Limit__c = POObject.Open_Ecs_Limit__c;
                                    FinnoneNew.Disb_Act_No__c = POObject.Disb_Act_No__c;
                                    FinnoneNew.Disb_Bank_Name__c = POObject.Disb_Bank_Name__c;
                                    FinnoneNew.Disb_Bank_Branch__c = POObject.Disb_Bank_Branch__c;
                                    FinnoneNew.Disb_favouring__c = POObject.Disb_favouring__c;
                                    FinnoneNew.PDD_pending__c = POObject.PDD_pending__c;
                                    FinnoneNew.POS_Old_Loan__c = POObject.POS_Old_Loan__c;
                                    FinnoneNew.Secured_Without_BT_line_Assigned__c = POObject.Secured_W_O_BT_Line_Assigned__c;
                                    FinnoneNew.Secured_W_O_BT_Line_Available__c = POObject.Secured_W_O_BT_Line_Available__c;
                                    FinnoneNew.Secured_BT_Line_Assigned__c = POObject.Secured_BT_Line_Assigned__c;
                                    FinnoneNew.Secured_BT_Line_Available__c = POObject.Secured_BT_Line_Available__c;
                                    FinnoneNew.Secured_Line_Expiry_Date__c = POObject.Secured_Line_Expiry_Date__c;
                                    FinnoneNew.Unsecured_Line_Expiry_Date__c = POObject.Unsecured_Line_Expiry_Date__c;
                                    FinnoneNew.Unsecured_Without_BT_line_Assigned__c = POObject.Unsecured_W_O_BT_Line_Assigned__c;
                                    FinnoneNew.Unsecured_W_O_BT_Line_Available__c = POObject.Unsecured_W_O_BT_Line_Available__c;
                                    FinnoneNew.Unsecured_BT_Line_Assigned__c = POObject.Unsecured_BT_Line_Assigned__c;
                                    FinnoneNew.Unsecured_BT_Line_Available__c = POObject.Unsecured_BT_Line_Available__c;
                                }
                            }
                        }
                        system.debug('######surrogateList######### ' + surrogateList.size());
                        if (surrogateList != null && surrogateList.size() > 0) {
                            system.debug('In Surrogate CAM');
                            FinnoneNew.Tenor_for_Line_assignment_in_yrs__c = surrogateList[0].Tenor_for_Line_assignment_in_yrs__c;
                            FinnoneNew.Total_Loan_amount_basis_Max_eligible_EMI__c = surrogateList[0].Total_Loan_amount_basis_Max_eligible_EMI__c;
                            FinnoneNew.Existing_Emi_that_can_be_closed__c = surrogateList[0].Existing_Emi_that_can_be_closed__c;
                            FinnoneNew.Additional_Line_Availability_for_DC__c = surrogateList[0].Additional_Line_Availability_for_DC__c;
                            FinnoneNew.Total_Line_available_including_DC__c = surrogateList[0].Total_Line_available_including_DC__c;
                            FinnoneNew.Expiry_Date_with_BT__c = surrogateList[0].Expiry_Date_with_BT__c;
                            FinnoneNew.Expiry_Date_without_BT__c = surrogateList[0].Expiry_Date_without_BT__c;
                            // FinnoneNew.Secured_Without_BT_line_Assigned__c = surrogateList[0].Line_assigned_basis_Credit_Assessment__c;
                            //FinnoneNew.Secured_BT_Line_Assigned__c = surrogateList[0].Line_assigned_basis_Credit_Assessment_DC__c;
                            FinnoneNew.Unsecured_BT_Line_Assigned__c = surrogateList[0].Unsecured_Line_assigned_with_BT__c;
                            FinnoneNew.Unsecured_Without_BT_line_Assigned__c = surrogateList[0].Unsecured_Line_assigned_without_BT__c;
                            //New chnages
                            FinnoneNew.CustomerAcceptanceFlag__c = surrogateList[0].Customer_Acceptance_Flag__c;
                            FinnoneNew.Line_Assigned_Date__c = surrogateList[0].Line_Assigned_Date__c;
                            FinnoneNew.Customer_Accepted_Date__c = surrogateList[0].Customer_Accepted_Date__c;
                            FinnoneNew.Line_Active_Flag__c = surrogateList[0].Line_Active_Flag__c;
                            // FinnoneNew.OptOutURL__c = surrogateList[0].OptOutURL__c;
                            // FinnoneNew.OptInURL__c = surrogateList[0].OptInURL__c;
                            FinnoneNew.Line_Flag__c = surrogateList[0].Line_flag__c;
                            if (surrogateList[0].Customer_Acceptance_Flag__c != null) {
                                FinnoneNew.Unsecured_Without_BT_line_Assigned__c = surrogateList[0].Line_assigned_basis_Credit_Assessment__c;
                                // FinnoneNew.Secured_Without_BT_line_Assigned__c = 0;
                                // FinnoneNew.Secured_BT_Line_Assigned__c = 0;
                            } else {
                                FinnoneNew.Secured_Without_BT_line_Assigned__c = surrogateList[0].Line_assigned_basis_Credit_Assessment__c;
                                FinnoneNew.Secured_BT_Line_Assigned__c = surrogateList[0].Line_assigned_basis_Credit_Assessment_DC__c;
                                
                            }
                        }
                        
                        // CIBIL Watch Start   
                        if (Loan.Loan_Application_Flow__c == 'CIBILWatch') {
                            for (Product_Offerings__c POObject: proOfferList) {
                                
                                if (POObject.Product_Offering_Source__c == 'Cibil 2') {
                                    FinnoneNew.Enquiry_Amount__c = POObject.Enquiry_Amount__c;
                                    FinnoneNew.Offer_Expiry_Date__c = POObject.Offer_Expiry_Date__c;
                                    System.debug('-------------Enquiry_Amount__c' + POObject.Enquiry_Amount__c);
                                    System.debug('-------------POObject.Offer_Expiry_Date__c' + POObject.Offer_Expiry_Date__c);
                                }
                            }
                            FinnoneNew.Remark__c = Loan.Remark__c;
                            FinnoneNew.Customer_Acceptance__c = primary.Customer_Acceptance__c;
                            
                        }
                        // CIBIL Watch End
                        // start Insurance distribution changes
                        if (Loan.Product__c == 'DPL' && Loan.leadSource == 'Insurance Distribution' && Loan.StageName != 'Approved')
                            FinnoneNew.Record_Type__c = 'Insurance Distribution';
                        // end Insurance distribution changes 
                        
                        //Bug 16173 - VRPL changes for HFC Start
                        if (applicant != null && applicant.Applicant_Type__c != null && applicant.Applicant_Type__c == 'Primary') {
                            if (Loan != null && Loan.Scheme_Master__c != null) {
                                FinnoneNew.VRPL_Flag__c = Loan.Scheme_Master__r.VRPL_Flag__c != null && Loan.Scheme_Master__r.VRPL_Flag__c == 'YES' ? 'Y' : Loan.Scheme_Master__r.VRPL_Flag__c != null && Loan.Scheme_Master__r.VRPL_Flag__c == 'NO' ? 'N' : '';
                            }
                            if (applicant != null && applicant.Parent_Deal_ID__c != null) {
                                if (applicant.Parent_Deal_ID__r.Loan_Application_Number__c != null)
                                    FinnoneNew.Parent_Deal_ID__c = String.valueOf(applicant.Parent_Deal_ID__r.Loan_Application_Number__c);
                            }
                        }
                        //Bug 16173 - VRPL changes for HFC End
                        
                        // 21288 Addy Cross Link
                        if (applicant.Cross_Collateral_LAN__c != null)
                            FinnoneNew.Cross_Collateral_LAN__c = applicant.Cross_Collateral_LAN__c;
                        //stop mapping properties to Finnone
                        FinnoneListApp.add(FinnoneNew);
                        
                        system.debug('bbbbbbbbbbbbbbbb' + FinnoneListApp + 'size' + FinnoneListApp.size());
                    }
                }
                
                
                /* Prajyot 12830 GST implementation Start */
                List < Address_Details__c > addressList = new List < Address_Details__c > ();
                List < FinnOne_Report__c > FinnoneListAppNew = new List < FinnOne_Report__c > ();
                addressList = [select id, State__c, Skip_Validation_Rules__c, Exemption_Applicable__c,
                               Adderss_Line_3__c, Address_Line_2__c, Address_Line_1__c, city__c, Loan_application__c,
                               Contact_Person_Number__c, Consider_for_Loan__c, Applicant__c, Applicant__r.name, GST_IN_Number__c, Lead__c,
                               Lead_Applicant__c, Pin_Code__c, Product_Offering__c
                               from Address_Details__c where Loan_application__c =: loanid and GST_IN_Number__c != null
                              ];
                Integer considerForLoanCount = 0;
                if (addressList != null && addressList.size() == 0) {
                    insert FinnoneListApp;
                } else {
                    system.debug('considerForLoanCount ---000-->> ' + considerForLoanCount);
                    for (Address_Details__c adr: addressList) {
                        if (adr.Consider_for_Loan__c == 'Yes') {
                            considerForLoanCount = considerForLoanCount + 1;
                        }
                    }
                    if (considerForLoanCount == 1) {
                        system.debug('considerForLoanCount ---111-->> ' + considerForLoanCount);
                        for (FinnOne_Report__c fin: FinnoneListApp) {
                            for (Address_Details__c adr: addressList) {
                                
                                if (fin.Applicant_ID__c == adr.Applicant__r.name) {
                                    system.debug('fin.GST_State__c =' + adr.State__c);
                                    fin.GST_City__c = adr.city__c;
                                    fin.GST_State__c = adr.State__c;
                                    fin.GST_Address_Line_3__c = adr.Adderss_Line_3__c;
                                    fin.GST_Address_Line_1__c = adr.Address_Line_1__c;
                                    fin.GST_Address_Line_2__c = adr.Address_Line_2__c;
                                    fin.GST_Exemption_Applicable__c = (String.valueOf(adr.Exemption_Applicable__c) == 'Yes') ? 'Y' : 'N';
                                    fin.GST_Consider_for_Loan__c = (String.valueOf(adr.Consider_for_Loan__c) == 'Yes') ? 'Y' : 'N';
                                    fin.GST_IN_Number__c = adr.GST_IN_Number__c;
                                    fin.GST_Pin_Code__c = adr.Pin_Code__c;
                                }
                                
                            }
                            FinnoneListAppNew.add(fin);
                        }
                        insert FinnoneListAppNew;
                    }
                }
                /* Prajyot 12830 GST implementation End */
                
                /*Code added by Rakesh Shinde.
Date : 18 August 2015
Comment : Added logic to create same number records of Document Finnone Report as number of Property records.
Each DFR record will have FinnOne_Report__c populated with Primary Applicant record
*/
                if (Loan.Sent_To_Finnone__c == false) {
                    String primaryFinnRecordID = '';
                    for (FinnOne_Report__c objFinnone: FinnoneListApp) {
                        if (objFinnone.Applicant_Type__c == 'P') {
                            primaryFinnRecordID = objFinnone.Id;
                            break;
                        }
                    }
                    
                    /*Code added by Varsha
Start Date :    12-01-2017
Bug id :        10,604
Description :   Foreclosure and Part payment Enhancement
*/
                    
                    List < Document_Finnone_Report__c > lstDocFinReport = new List < Document_Finnone_Report__c > ();
                    
                    /*if(bankAccountList!=null && bankAccountList.size()>0){
for (Bank_Account__c bank: bankAccountList) {
Document_Finnone_Report__c objDocFinReport = new Document_Finnone_Report__c();
objDocFinReport.Record_Type__c = 'FORECLOSURE';
objDocFinReport.Foreclosure_Partpayment_Penalty__c = bank.Foreclosure_Partpayment_Penalty__c;
objDocFinReport.MOB_FROM__c = bank.MOB_FROM__c;
objDocFinReport.MOB_TO__c = bank.MOB_TO__c;
objDocFinReport.Opportunity__c = bank.Loan_Application__c;
objDocFinReport.PREPAY_PENALTY__c = bank.PREPAY_PENALTY__c;
objDocFinReport.FORECLOSURE_PENALTY__c = bank.FORECLOSURE_PENALTY__c;
objDocFinReport.FinnOne_Report__c = primaryFinnRecordID;
lstDocFinReport.add(objDocFinReport);  
}
system.debug('Foreclosure size' +  lstDocFinReport.size());
system.debug('Foreclosure list' +  lstDocFinReport);
}*/
                    /*foreclosure end*/
                    for (Property_Details__c objProperty: properties) {
                        Document_Finnone_Report__c objDocFinReport = new Document_Finnone_Report__c();
                        
                        if (loan.Product__c == 'CE') {
                            objDocFinReport.Asset_Category__c = objProperty.Asset_Category__c;
                            objDocFinReport.Asset_Code__c = objProperty.Asset_Model__c;
                            objDocFinReport.Asset_Cost__c = objProperty.Asset_Cost__c;
                            //objDocFinReport.Asset_Make__c = objProperty.Asset_Master__r.Name;
                            if (objProperty.Asset_FinnOne_Code__c != null) objDocFinReport.Asset_Model_Id__c = Decimal.valueof(objProperty.Asset_FinnOne_Code__c);
                            objDocFinReport.Contact_Person_Name1__c = cpn;
                            system.debug('--cpn--' + cpn);
                            system.debug('--objDocFinReport.Contact_Person_Name1__c--' + objDocFinReport.Contact_Person_Name1__c);
                            if (properties.size() > 0) objDocFinReport.Dealer_ID__c = objProperty.Dealer_Master__r.Dealer_ID__c;
                        }
                        
                        if (string.isNotBlank(primaryFinnRecordID)) objDocFinReport.FinnOne_Report__c = primaryFinnRecordID;
                        objDocFinReport.Opportunity__c = Loan.Id;
                        objDocFinReport.Record_Type__c = 'Property Details';
                        if (string.isNotBlank(primaryFinnRecordID)) objDocFinReport.FinnOne_Report__c = primaryFinnRecordID;
                        objDocFinReport.Property_Description__c = objProperty.Property_Description__c;
                        objDocFinReport.X1st_Appraised_value__c = objProperty.Land_Valuation_1__c;
                        objDocFinReport.X2nd_Appraised_value__c = objProperty.Land_Valuation_2__c;
                        objDocFinReport.Property_Status__c = objProperty.Property_Status__c;
                        objDocFinReport.Property_Value_As_per_Customer__c = objProperty.Average_Of_Two_Valuations__c;
                        objDocFinReport.Builder_Name__c = objProperty.Builder_Maintenance__r.Name;
                        objDocFinReport.Project_Name__c = objProperty.Project_Name__r.Name;
                        objDocFinReport.APF_No__c = objProperty.APF_Number__c;
                        objDocFinReport.Plot_No__c = objProperty.Plot_Flat_No__c;
                        
                        objDocFinReport.Property_Address_1__c = objProperty.Property_Address_Line_1__c;
                        objDocFinReport.Property_Address_2__c = objProperty.Property_Address_Line_2__c;
                        objDocFinReport.Property_Address_3__c = objProperty.Property_Address_Line_3__c;
                        objDocFinReport.FinnOne_Property_code__c = objProperty.Name;
                        objDocFinReport.Total_Valuation_1__c = objProperty.Total_Valuation_1__c;
                        objDocFinReport.Total_Valuation_2__c = objProperty.Total_Valuation_2__c;
                        objDocFinReport.Final_valuation__c = objProperty.Final_Valuation__c;
                        objDocFinReport.Type_of_Measurement__c = objProperty.Type_Of_Measurement__c;
                        objDocFinReport.Property_Country__c = 'India';
                        objDocFinReport.Property_State__c = objProperty.Property_State__c;
                        objDocFinReport.Property_City__c = objProperty.Property_City__c;
                        objDocFinReport.First_Appraisal_By__c = objProperty.First_Appraisal_By__c;
                        objDocFinReport.Second_Appraisal_By__c = objProperty.Second_Appraisal_By__c;
                        objDocFinReport.Building_Name__c = objProperty.Building_Name__c;
                        
                        if (contactlist != null && contactlist.size() > 0) {
                            system.debug('---contactlist---' + contactlist);
                            system.debug('---contactlist Pin_Code__c---' + contactlist[0].Pin_Code__c);
                            objDocFinReport.Property_Pin_Code__c = contactlist[0].Pin_Code__c;
                        }
                        
                        //Added DK-END-Bug 718 
                        //if (objProperty.Property_Pin_Code__c != null) objDocFinReport.Property_Pin_Code__c = objProperty.Property_Pin_Code__c;
                        
                        
                        if (objProperty.Property_Type__c == 'SOCP') objDocFinReport.Property_Type__c = 'SOCP';
                        else if (objProperty.Property_Type__c == 'SORP') objDocFinReport.Property_Type__c = 'SORP';
                        else if (objProperty.Property_Type__c == 'Plot') objDocFinReport.Property_Type__c = 'PLOT';
                        else if (objProperty.Property_Type__c == 'Rented Commercial') objDocFinReport.Property_Type__c = 'RENTCOM';
                        else if (objProperty.Property_Type__c == 'Rented Residential') objDocFinReport.Property_Type__c = 'RENTRESI';
                        else if (objProperty.Property_Type__c == 'Vacant Residential') objDocFinReport.Property_Type__c = 'VACANTRESI';
                        else if (objProperty.Property_Type__c == 'NRP') objDocFinReport.Property_Type__c = 'NRP';
                        else if (objProperty.Property_Type__c == 'Vacant Commercial') objDocFinReport.Property_Type__c = 'VACNTCOMM';
                        else if (objProperty.Property_Type__c == 'Mixed usage') objDocFinReport.Property_Type__c = 'MIXEDUSAGE';
                        
                        if (objProperty.Asset_Type__c == 'New') objDocFinReport.Loan_facility__c = 'New';
                        else if (objProperty.Asset_Type__c == 'Used') objDocFinReport.Loan_facility__c = 'Used';
                        else if (objProperty.Asset_Type__c == 'Refinance') objDocFinReport.Loan_facility__c = 'ReFin';
                        else if (objProperty.Asset_Type__c == 'Balance Transfer') objDocFinReport.Loan_facility__c = 'BalTrns';
                        else if (objProperty.Asset_Type__c == 'Bank Guarantee') objDocFinReport.Loan_facility__c = 'BankGte';
                        else if (objProperty.Asset_Type__c == 'Secured Working Capital') objDocFinReport.Loan_facility__c = 'SecWkCp';
                        else if (objProperty.Asset_Type__c == 'Re-Schedule') objDocFinReport.Loan_facility__c = 'RESCH';
                        else if (objProperty.Asset_Type__c == 'Balance Transfer-Top up') objDocFinReport.Loan_facility__c = 'BTTU';
                        else if (objProperty.Asset_Type__c == 'Secured Short Term Loan') objDocFinReport.Loan_facility__c = 'SSTL';
                        else if (objProperty.Asset_Type__c == 'Unsecured Loans') objDocFinReport.Loan_facility__c = 'UL';
                        
                        lstDocFinReport.add(objDocFinReport);
                    }
                    
                    for (RePayment_mode_detail__c objRePaymentModeDet: repaymentmodes) {
                        
                        if (objRePaymentModeDet.Repayment_Mode__c == 'ECS' || objRePaymentModeDet.Repayment_Mode__c == 'PDC' || objRePaymentModeDet.Repayment_Mode__c == 'SI') { //17547 added condition for SI
                            Document_Finnone_Report__c objDocFinReport = new Document_Finnone_Report__c();
                            if (string.isNotBlank(primaryFinnRecordID)) objDocFinReport.FinnOne_Report__c = primaryFinnRecordID;
                            objDocFinReport.Opportunity__c = Loan.Id;
                            objDocFinReport.Record_Type__c = 'Repayment Mode Details';
                            if (string.isNotBlank(primaryFinnRecordID)) objDocFinReport.FinnOne_Report__c = primaryFinnRecordID;
                            //Changes for Repayment Mode and Open ECS Facility Change Start
                            if (objRePaymentModeDet.Repayment_Mode__c != null) {
                                if (objRePaymentModeDet.Repayment_Mode__c == 'ECS') {
                                    objDocFinReport.Instrument_Mode__c = 'E';
                                }
                                if (objRePaymentModeDet.Repayment_Mode__c == 'PDC') {
                                    objDocFinReport.Instrument_Mode__c = 'P';
                                }
                                //17547--S
                                if (objRePaymentModeDet.Repayment_Mode__c == 'SI') {
                                    objDocFinReport.Instrument_Mode__c = 'SI';
                                }
                                //17547--E
                                /*if (objRePaymentModeDet.Repayment_Mode__c == 'ESCROW') {
objDocFinReport.Instrument_Mode__c = 'W';
}
if (objRePaymentModeDet.Repayment_Mode__c == 'Security Cheque') {
objDocFinReport.Instrument_Mode__c = '';
}
if (objRePaymentModeDet.Repayment_Mode__c == 'Cancelled Cheque') {
objDocFinReport.Instrument_Mode__c = '';
}*/
                            }
                            //17547--S
                            if (objRePaymentModeDet.UMRN__c != null) {
                                objDocFinReport.UMRN__c = objRePaymentModeDet.UMRN__c;
                            }
                            //17547--E
                            if (objRePaymentModeDet.Open_ECS_Facility__c != null) {
                                if (objRePaymentModeDet.Open_ECS_Facility__c == 'Yes') {
                                    objDocFinReport.Open_ECS_Facility__c = 'Y';
                                }
                                if (objRePaymentModeDet.Open_ECS_Facility__c == 'No') {
                                    objDocFinReport.Open_ECS_Facility__c = 'N';
                                }
                                if (objRePaymentModeDet.Open_ECS_Facility__c == 'Existing') {
                                    objDocFinReport.Open_ECS_Facility__c = 'W';
                                }
                            }
                            
                            //objDocFinReport.Instrument_Mode__c = objRePaymentModeDet.Repayment_Mode__c;
                            //objDocFinReport.Open_ECS_Facility__c = objRePaymentModeDet.Open_ECS_Facility__c;
                            
                            //Changes for Repayment Mode and Open ECS Facility Change End
                            objDocFinReport.MICR__c = objRePaymentModeDet.MICR_Code__c;
                            objDocFinReport.Bank__c = objRePaymentModeDet.Bank_Name__c;
                            objDocFinReport.Bank_Branch__c = objRePaymentModeDet.Bank_Branch__c;
                            objDocFinReport.Customer_A_C_No__c = objRePaymentModeDet.A_C_NO__c;
                            objDocFinReport.A_C_Type__c = objRePaymentModeDet.A_C_Type__c; // added by Suraj....Finnone Audit enhancement
                            objDocFinReport.Open_ECS_Ex_Customer_Id__c = objRePaymentModeDet.Open_ECS_Ex_Customer_Id__c;
                            objDocFinReport.Open_ECS_Valid_Till__c = objRePaymentModeDet.Open_Valid_till__c;
                            objDocFinReport.Open_ECS_Max_Limit__c = objRePaymentModeDet.Open_ECS_Max_Limit__c;
                            objDocFinReport.ECS_Start_Date__c = objRePaymentModeDet.ECS_Start_Date__c;
                            objDocFinReport.ECS_End_Date__c = objRePaymentModeDet.ECS_End_Date__c;
                            objDocFinReport.ECS_Amount__c = objRePaymentModeDet.ECS_Amount__c;
                            objDocFinReport.Dest_A_C_Holder__c = objRePaymentModeDet.Account_Holder_Name__c;
                            objDocFinReport.PDC_By_Name__c = objRePaymentModeDet.PDC_By_Name__c;
                            objDocFinReport.ECS_BarcodeNo__c = objRePaymentModeDet.ECS_Barcode_No__c; //added by Suraj...ECS Mandate Enhancement
                            
                            lstDocFinReport.add(objDocFinReport);
                        }
                        
                    }
                    
                    // Adding Fees & Charge Records in DFR
                    /** charges api new change**/
                    boolean ChargesAPIIntegrationProd = false;
                    String[] productsChargesList;
                    string productsCharges;
                    if (!Test.isRunningTest()) {
                        productsCharges = LaonApplicationCreation__c.getValues('Charges API Integration').Products__c;
                    }
                    if (productsCharges != null && productsCharges != '')
                        productsChargesList = productsCharges.split(',');
                    if (productsChargesList != null && productsChargesList.size() > 0) {
                        for (string prod: productsChargesList) {
                            if (loan.Product__c != null && loan.Product__c.ToUpperCase() == prod.ToUpperCase()) {
                                ChargesAPIIntegrationProd = true;
                                break;
                            } else
                                ChargesAPIIntegrationProd = false;
                        }
                    }
                    
                    /** charges api new chnage END**/
                    system.debug('feeCharge....');
                    for (Fees_and_Charge__c feeCharge: feesCharges) {
                        
                        //New code of Decentralized Disbursement Start
                        system.debug('feeCharge.... ::' + feeCharge.Charge_Type__c);
                        system.debug('---feesCharges---' + feesCharges);
                        Document_Finnone_Report__c objDocFinReport = new Document_Finnone_Report__c();
                        objDocFinReport.Record_Type__c = 'Fees and Charge';
                        if (string.isNotBlank(primaryFinnRecordID)) objDocFinReport.FinnOne_Report__c = primaryFinnRecordID;
                        if (string.isNotBlank(primaryFinnRecordID)) objDocFinReport.FinnOne_Report__c = primaryFinnRecordID;
                        objDocFinReport.Opportunity__c = Loan.Id;
                        //charges API enhancement start
                        boolean ChargesAPIIntegration = LaonApplicationCreation__c.getValues('Charges API Integration').Integrate_Charges_API__c;
                        if (ChargesAPIIntegration = true && ChargesAPIIntegrationProd == true) {
                            objDocFinReport.Charge_ID__c = feeCharge.Finnone_ChargeId__c;
                            objDocFinReport.Charge_description__c = feeCharge.Charge_Desc__c;
                        } else {
                            objDocFinReport.Charge_ID__c = feeCharge.Charge_ID__c;
                        }
                        //charges API enhancement end
                        objDocFinReport.Rate_Amount__c = feeCharge.Rate_Amount__c;
                        objDocFinReport.Amount__c = feeCharge.Change_Amount__c;
                        objDocFinReport.Rate__c = feeCharge.Charge__c;
                        objDocFinReport.Deal_ID__c = Loan.Application_Number__c;
                        objDocFinReport.Product_Code__c = Loan.Product__c;
                        objDocFinReport.Deductible_from_disbursement__c = feeCharge.Deducted_from_Disbursement__c;
                        lstDocFinReport.add(objDocFinReport);
                    }
                    /*Additional fields ehnacement Insurance
4/27/2016*/
                    System.debug('ListDPLinsurance******************mapping' + ListDPLinsurance);
                    
                    // Added by Asmita - changed the location of SOQL query (outside for loop)
                    // start nominee validation for products changes by rohit mourya
                    /*List < StaticResource > srInsurance = [select id, Name, body from StaticResource Where Name = 'AdditionalFiledsToFlowFinnoneInsuranceType'
OR
Name = 'AdditionalFiledsToFlowFinnone'
];*/
                    //Code added by  Asmita Rajput 
                    //Purpose: Fixed bug 12755 - start
                    if (FinnoneListApp != null && FinnoneListApp.size() > 0) {
                        for (FinnOne_Report__c objFinnone: FinnoneListApp) {
                            if (objFinnone.Applicant_ID__c != null)
                                mapFinnAppl.put(objFinnone.Applicant_ID__c, objFinnone.id);
                        }
                    }
                    // Bug - 12755 - end
                    
                    System.debug('ListDPLinsurance::' + ListDPLinsurance.size());
                    for (DPLinsurance__c ObjDPLinsurance: ListDPLinsurance) {
                        Document_Finnone_Report__c objDocFinReport = new Document_Finnone_Report__c();
                        //Commented below line by Rakesh for enhancement - Insurance- FLP Movement to FinnOne
                        //objDocFinReport.Record_Type__c = 'Repayment Mode Details';
                        objDocFinReport.Opportunity__c = Loan.Id;
                        //Code added by  Asmita Rajput 
                        //Purpose: Fixed bug 12755 - start
                        if (ObjDPLinsurance.Applicant__c != null && mapFinnAppl.containsKey(ObjDPLinsurance.Applicant__r.name))
                            objDocFinReport.FinnOne_Report__c = mapFinnAppl.get(ObjDPLinsurance.Applicant__r.name);
                        //Bug - 12755 - end
                        
                        //Commented below code by Asmita Rajput 
                        //Purpose: Fixed bug 12755
                        //if (string.isNotBlank(primaryFinnRecordID)) objDocFinReport.FinnOne_Report__c = primaryFinnRecordID;
                        
                        if (ObjDPLinsurance.Insurance_Party_type__c != null) {
                            if (ObjDPLinsurance.Insurance_Party_type__c == 'Party to Loan') {
                                objDocFinReport.Insurance_Party_type__c = 'P';
                            }
                            if (ObjDPLinsurance.Insurance_Party_type__c == 'No Party to Loan') {
                                objDocFinReport.Insurance_Party_type__c = 'N';
                            }
                        }
                        
                        //Condition added by Anurag so that DocFinnoneReport's ApplicantType__c picklist values are in sync on Salesforce and Finnone side
                        if (ObjDPLinsurance.Applicant_type__c == 'PRIMARY' || ObjDPLinsurance.Applicant_type__c == 'GUARANTOR')
                            objDocFinReport.Applicant_type__c = ObjDPLinsurance.Applicant_type__c;
                        else
                            objDocFinReport.Applicant_type__c = 'CO-APPLICANT';
                        
                        objDocFinReport.Insurance_form_number__c = ObjDPLinsurance.Insurance_form_number__c;
                        objDocFinReport.Insurance_term__c = ObjDPLinsurance.Insurance_term__c;
                        objDocFinReport.Critical_Illness__c = ObjDPLinsurance.Critical_Illness__c;
                        objDocFinReport.Declaration_of_good_health__c = ObjDPLinsurance.Declaration_of_good_health__c;
                        objDocFinReport.Relation__c = ObjDPLinsurance.Relation__c;
                        /* if(ObjDPLinsurance.Insurance_Type__c=='BAGIC')
{
objDocFinReport.Insurance_Company__c='1';
}
if(ObjDPLinsurance.Insurance_Type__c=='BALIC')
{
objDocFinReport.Insurance_Company__c='21';
}
if(ObjDPLinsurance.Insurance_Type__c=='HDFC Life')
{
objDocFinReport.Insurance_Company__c='24';
}
if(ObjDPLinsurance.Insurance_Type__c=='MAX Bupa')
{
objDocFinReport.Insurance_Company__c='25';
}*/
                        //StaticResource srInsurance = [select id, body  from StaticResource Where Name = 'AdditionalFiledsToFlowFinnoneInsuranceType'];
                        //if(srInsurance.Name == 'AdditionalFiledsToFlowFinnoneInsuranceType'){
                        
                        /*Code added by Asmita Rajput.
Comment : changed the location of SOQL query (outside for loop)  */
                        // start nominee validation for products changes by rohit mourya
                        for (StaticResource srIns: srList) {
                            
                            if (srIns.Name == 'AdditionalFiledsToFlowFinnoneInsuranceType') {
                                String contentsInsurance = srIns.body.toString();
                                system.debug('body contents are' + contentsInsurance);
                                if (contentsInsurance != null && contentsInsurance != '') {
                                    for (String line: contentsInsurance.split('\n')) {
                                        if (line != null && line != '') {
                                            String[] arrayofinsurance = line.split(',');
                                            if (ObjDPLinsurance.Insurance_Type__c == arrayofinsurance[0]) {
                                                if (arrayofinsurance.size() > 0 && arrayofinsurance[1] != null) {
                                                    objDocFinReport.Insurance_Company__c = String.valueOf(arrayofinsurance[1]);
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            if (srIns.Name == 'AdditionalFiledsToFlowFinnone') {
                                String contents = srIns.body.toString();
                                system.debug('body contents are' + contents);
                                if (contents != null && contents != '') {
                                    for (String line: contents.split('\n')) {
                                        if (line != null && line != '') {
                                            String[] arrayofinsurance = line.split(',');
                                            if (ObjDPLinsurance.Insurance_Product__c == arrayofinsurance[0]) {
                                                if (arrayofinsurance.size() > 0 && arrayofinsurance[1] != null) {
                                                    objDocFinReport.Insurance_Type__c = String.valueOf(arrayofinsurance[1]);
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        // end nominee validation for products changes by rohit mourya
                        objDocFinReport.Sum_Assured__c = ObjDPLinsurance.Sum_Assured__c;
                        objDocFinReport.Nominee_Name__c = ObjDPLinsurance.Nominee_Name__c;
                        // Below Nominee_Address__c Line is Uncommented for- Bug 13010 by Asmita
                        objDocFinreport.Nominee_Address__c = ObjDPLinsurance.Nominee_Address__c;
                        objDocFinReport.Nominee_DOB__c = ObjDPLinsurance.Nominee_DOB__c;
                        objDocFinReport.Premium_Amount__c = ObjDPLinsurance.Premium_Amount__c;
                        objDocFinReport.Insurer_Name__c = ObjDPLinsurance.Insurer_Name__c;
                        objDocFinReport.Type_of_Insurance__c = ObjDPLinsurance.Type_of_Insurance__c;
                        //UnCommented below line by Rakesh for enhancement - Insurance- FLP Movement to FinnOne
                        objDocFinReport.Record_Type__c = 'Insurance Details';
                        
                        /*Code added by Asmita Rajput.
Comment : code to flow DPLinsurance fields to FinnOne Report and Document Finnone Report */
                        //system.debug('nominee mobile***'+ObjDPLinsurance);
                        
                        objDocFinReport.Nominee_Mobile__c = ObjDPLinsurance.Nominee_Mobile__c;
                        objDocFinReport.Nominee_Relationship_with_Policy_Holder__c = ObjDPLinsurance.Nominee_Relationship_with_Policy_Holder__c;
                        objDocFinReport.Insurance_term__c = ObjDPLinsurance.Insurance_term__c;
                        objDocFinReport.Form_Handover__c = ObjDPLinsurance.Form_Handover__c;
                        objDocFinReport.Insurance_ID__c = ObjDPLinsurance.Insurance_ID__c;
                        // Added by Asmita bug - 13011 start
                        objDocFinReport.Nominee_Age__c = ObjDPLinsurance.Nominee_Age__c;
                        // Added by Asmita bug - 13011 end
                        
                        
                        /*Code added by Rohit Mourya.(Insurance BRD for SFDC Phase 2)
Comment : code to flow DPLinsurance fields to FinnOne Report and Document Finnone Report */
                        objDocFinReport.Appointee_DOB__c = ObjDPLinsurance.Appointee_DOB__c;
                        objDocFinReport.Appointee_Name__c = ObjDPLinsurance.Appointee_Name__c;
                        objDocFinReport.BFL_Discrepant_Resolution__c = ObjDPLinsurance.Discrepant_Resolution__c;
                        objDocFinReport.Discrepant_at_TCS__c = ObjDPLinsurance.Discrepant_at_TCS__c;
                        objDocFinReport.Source__c = ObjDPLinsurance.Source__c;
                        //objDocFinReport.Insurance_form_number__c = ObjDPLinsurance.Insurance_form_number__c;
                        //objDocFinReport.Nominee_Age__c = ObjDPLinsurance.Nominee_Age__c;
                        /*Code added by Rohit Mourya.(Insurance BRD for SFDC)
Comment : end */
                        
                        lstDocFinReport.add(objDocFinReport);
                    }
                    /*--------code added by Asmita end-------------*/
                    
                    if (lstDocFinReport != null & lstDocFinReport.size() > 0) {
                        try {
                            insert lstDocFinReport;
                            system.debug('---Fees & Charges Record Inserted---' + lstDocFinReport);
                        } catch (DMLException e) {
                            system.debug('---Exception in Inserting Fees & Charges Record---' + e.getmessage());
                        }
                    }
                    
                    //New code of Decentralized Disbursement Ends
                    
                    
                }
                
                
                PrimappFinnoneReport = [select id, Applicant_Type__c, name from FinnOne_Report__c where Loan_Application__c =: LoanId and Applicant_Type__c = 'P'];
                //start :finding Primary applicant FinnOne Report
                for (integer i = 0; i < PrimappFinnoneReport.size(); i++) {
                    if (PrimappFinnoneReport[i].Applicant_Type__c == 'P') pid = PrimappFinnoneReport[i].id;
                    system.debug('Primary Applicant Id' + pid);
                }
                
                //stop: finding Primary applicant FinnOne Report
                
                /********************************************************************************************* 
*  START : flowing dummy document
*  On particular type of Document and for Particular type of Product. @YS #12163 14th Apr. 2017 
*********************************************************************************************/
                
                if (Label.Unsecured_Products != NULL || Label.Unsecured_Products.trim() == '') {
                    
                    System.debug('@@SendFinnone -  In label ');
                    
                    //Preparing set from Products.
                    List < String > lstUnsecuredProducts = Label.Unsecured_Products.split(';');
                    Set < String > setUnsecProducts = new Set < String > ();
                    for (String strUnsecProduct: lstUnsecuredProducts) {
                        setUnsecProducts.add(strUnsecProduct.toLowerCase());
                    }
                    
                    if (setUnsecProducts.contains(Loan.product__c.toLowerCase())) {
                        List < Document_Finnone_Report__c > lstDFR = new List < Document_Finnone_Report__c > ();
                        
                        //preparing set for Doc. types
                        Set < String > setDocsToFlow = new Set < String > ();
                        if (Label.Docs_to_flow.trim() != NULL || Label.Docs_to_flow.trim() == '') {
                            List < String > lstDocsToFlow = Label.Docs_to_flow.split(';');
                            for (String strDocToFlow: lstDocsToFlow) {
                                setDocsToFlow.add(strDocToFlow.toLowerCase());
                            }
                        }
                        
                        
                        AfterFilterCheclistTemp = [
                            select
                            id, Loan_Application__c, Applicant__r.id, DocumentFmlyName__r.FinnOne_Document_id__c, DocumentFmlyName__c,
                            Document_Type__c, Property_Document__c, Property_Details__r.name, OTPDeferralCategory__c
                            from
                            checklist__c
                            where
                            Loan_Application__c =: LoanId and Applicant__r.Applicant_Type__c = 'Primary'
                        ];
                        
                        //fetching Dummy document to flow. 
                        List < Document_Family__c > lstDF = [SELECT FinnOne_Document_id__c, Name FROM Document_Family__c where Name = 'Deferral Checklist Document'];
                        
                        //checking it before processing any checklist. So as to avoid unnecessary processing. 
                        if (lstDF != NULL && lstDF.size() > 0 && lstDF[0].FinnOne_Document_id__c != NULL && lstDF[0].FinnOne_Document_id__c.trim() != '') {
                            for (Checklist__c objChecklist: AfterFilterCheclistTemp) {
                                if (objChecklist != NULL && objChecklist.OTPDeferralCategory__c != NULL && setDocsToFlow.contains(objChecklist.OTPDeferralCategory__c.toLowerCase())) {
                                    Document_Finnone_Report__c DocumentFinnoneReport = new Document_Finnone_Report__c();
                                    DocumentFinnoneReport.FinnOne_Report__c = pid;
                                    DocumentFinnoneReport.FinnOne_Document_id__c = lstDF[0].FinnOne_Document_id__c;
                                    DocumentFinnoneReport.Opportunity__c = LoanId;
                                    lstDFR.add(DocumentFinnoneReport);
                                }
                            }
                            
                            if (!lstDFR.isempty()) {
                                try {
                                    insert lstDFR;
                                    DocFinnoneReport = true;
                                } catch (Exception pokemon) {
                                    System.debug('Exception in SendToFinnone while flowing document: ' + pokemon);
                                }
                                
                            }
                        }
                    }
                }
                /********************************************************************************************* 
END : flowing dummy document
On particular type of Document and for Particular type of Product. @YS #12163 14th Apr. 2017 
*********************************************************************************************/
                if (Loan.product__c == 'Home Loan' || Loan.product__c == 'LAP' || LAPprods.contains(loan.Product__c.toUppercase()) || Loan.product__c == 'SBS CS HL' || Loan.product__c == 'SBS CS LAP' || Loan.product__c == 'CE' || Loan.product__c == 'SHL' || Loan.product__c == 'SBS CS SHL') {
                    
                    AfterFilterCheclistTemp = [select id, DocStatus__c, DocStatus1__c, Documents_Type__c, Received_Date__c, Target_Date__c, IsCritical__c, IsNonCritical__c, Deferral_Taken_Date__c, Loan_Application__c, Applicant__r.id, PDD_OTC_Remarks__c, name,
                                               DocumentFmlyName__r.FinnOne_Document_id__c, DocumentFmlyName__c, Document_Type__c, Property_Document__c, Property_Details__r.name
                                               from checklist__c where Loan_Application__c =: LoanId and Applicant__r.Applicant_Type__c = 'Primary'
                                              ];
                    
                    // added by murali krishna -admin siva
                    List < string > keyTemp = new List < string > ();
                    Map < string, checklist__c > checklistFilterMap = new Map < string, checklist__c > ();
                    for (checklist__c cp: AfterFilterCheclistTemp) {
                        if (cp.DocumentFmlyName__r.FinnOne_Document_id__c != null) {
                            checklistFilterMap.put(cp.DocumentFmlyName__r.FinnOne_Document_id__c, cp);
                            // keyTemp.add(cp.DocumentFmlyName__r.FinnOne_Document_id__c);
                        }
                    }
                    
                    /** for(integer l=0;l<checklistFilterMap.size();l++){
if(checklistFilterMap.get(keyTemp[l]) !=null){
propertyDocumentsforPrimapp.add(checklistFilterMap.get(keyTemp[l]));
}
}**/
                    propertyDocumentsforPrimapp = checklistFilterMap.values();
                    // added by murali krishna -admin siva
                    
                    //start: creating Document FinnOne Reports for Primary Applicants
                    
                    
                    for (integer i = 0; i < propertyDocumentsforPrimapp.size(); i++) {
                        Document_Finnone_Report__c DocumentFinnoneReport = new Document_Finnone_Report__c();
                        FinnOne_Report__c Finnoneforchecklist = new FinnOne_Report__c();
                        DocumentFinnoneReport.Opportunity__c = propertyDocumentsforPrimapp[i].Loan_Application__c;
                        DocumentFinnoneReport.Aplicant_ID__c = propertyDocumentsforPrimapp[i].Applicant__r.id;
                        DocumentFinnoneReport.Document_ID__c = propertyDocumentsforPrimapp[i].id;
                        DocumentFinnoneReport.Document_Description__c = propertyDocumentsforPrimapp[i].PDD_OTC_Remarks__c;
                        //DocumentFinnoneReport.Document_Status__c=propertyDocumentsforPrimapp[i].DocStatus__c;
                        DocumentFinnoneReport.ReceivedDate__c = propertyDocumentsforPrimapp[i].Received_Date__c;
                        DocumentFinnoneReport.Target_Date__c = propertyDocumentsforPrimapp[i].Target_Date__c;
                        DocumentFinnoneReport.IsCritical__c = propertyDocumentsforPrimapp[i].IsCritical__c;
                        DocumentFinnoneReport.IsNonCritical__c = propertyDocumentsforPrimapp[i].IsNonCritical__c;
                        
                        DocumentFinnoneReport.Document_Remarks__c = propertyDocumentsforPrimapp[i].PDD_OTC_Remarks__c;
                        DocumentFinnoneReport.Deferral_Date__c = propertyDocumentsforPrimapp[i].Deferral_Taken_Date__c;
                        //DocumentFinnoneReport.Original_Y_N__c=propertyDocumentsforPrimapp[i].Documents_Type__c;
                        DocumentFinnoneReport.FinnOne_Report__c = pid;
                        DocumentFinnoneReport.FinnOne_Document_id__c = propertyDocumentsforPrimapp[i].DocumentFmlyName__r.FinnOne_Document_id__c;
                        DocumentFinnoneReport.Document_Description__c = propertyDocumentsforPrimapp[i].Property_Document__c;
                        DocumentFinnoneReport.FinnOne_Property_code__c = propertyDocumentsforPrimapp[i].Property_Details__r.name;
                        if (propertyDocumentsforPrimapp[i].Document_Type__c == 'Original') {
                            DocumentFinnoneReport.Original_Y_N__c = 'Y';
                        }
                        if (propertyDocumentsforPrimapp[i].Document_Type__c == 'Photocopy') {
                            DocumentFinnoneReport.Original_Y_N__c = 'N';
                        }
                        
                        if (propertyDocumentsforPrimapp[i].DocStatus__c == 'OTC-Pending' || propertyDocumentsforPrimapp[i].DocStatus__c == 'OTC-Deferral') {
                            DocumentFinnoneReport.Document_Status__c = 'O';
                        } else if (propertyDocumentsforPrimapp[i].DocStatus__c == 'Received') {
                            DocumentFinnoneReport.Document_Status__c = 'R';
                        } else if (propertyDocumentsforPrimapp[i].DocStatus__c == 'Waived') {
                            DocumentFinnoneReport.Document_Status__c = 'W';
                        } else if (propertyDocumentsforPrimapp[i].DocStatus__c == 'PDD-Pending') {
                            DocumentFinnoneReport.Document_Status__c = 'B';
                        } else if (propertyDocumentsforPrimapp[i].DocStatus__c == 'Pending') {
                            DocumentFinnoneReport.Document_Status__c = 'P';
                        }
                        
                        DocumentFinnoneReportList.add(DocumentFinnoneReport);
                        
                    }
                    system.debug(DocumentFinnoneReportList.size() + 'sizeeeeeeee');
                    if (!DocumentFinnoneReportList.isempty()) {
                        insert DocumentFinnoneReportList;
                        DocFinnoneReport = true;
                    }
                    //stop: creating Document FinnOne Reports for Primary Applicants
                }
                
                
                if (DocFinnoneReport == true) {
                    list < FinnOne_Report__c > DocCheckTem1 = new list < FinnOne_Report__c > ();
                    list < FinnOne_Report__c > DocCheckTem = new list < FinnOne_Report__c > ();
                    DocCheckTem = [select id, DocFinnoneReport__c from FinnOne_Report__c where Loan_Application__c =: Loan.Id];
                    
                    for (FinnOne_Report__c fc: DocCheckTem) {
                        fc.DocFinnoneReport__c = true;
                        DocCheckTem1.add(fc);
                    }
                    if (!DocCheckTem1.isEmpty()) update DocCheckTem1;
                } else {
                    list < FinnOne_Report__c > DocCheckTem1 = new list < FinnOne_Report__c > ();
                    list < FinnOne_Report__c > DocCheckTem = new list < FinnOne_Report__c > ();
                    DocCheckTem = [select id, DocFinnoneReport__c, Document_Header_ID_WF__c from FinnOne_Report__c where Loan_Application__c =: Loan.Id];
                    
                    for (FinnOne_Report__c fc: DocCheckTem) {
                        fc.DocFinnoneReport__c = false;
                        fc.Document_Header_ID_WF__c = '';
                        DocCheckTem1.add(fc);
                    }
                    if (!DocCheckTem1.isEmpty()) update DocCheckTem1;
                }
                
                
                
                //FinnOne Records for Assets
                if (Loan.product__c == 'LAP' || LAPprods.contains(loan.Product__c.toUppercase())) {
                    
                    //for(Property_Details__c properties[0] :properties)
                    if (properties.size() > 0) {
                        List < FinnOne_Report__c > FinnoneNewAsset = new List < FinnOne_Report__c > ();
                        FinnOne_Report__c FinnoneNewassetrecord = new FinnOne_Report__c();
                        FinnoneNewassetrecord.Loan_Application__c = Loan.Id;
                        system.debug('imindocforfinnone');
                        //Loading Primary Applicant's Details
                        /*
FinnoneNewAsset.Primary_Date_of_Birth__c=primary.Contact_Name__r.Date_of_Birth__c;
FinnoneNewAsset.Primary_First_Name__c=primary.Contact_Name__r.FirstName;
FinnoneNewAsset.Primary_Last_Name__c=primary.Contact_Name__r.LastName;
if(primary.Contact_Name__r.Middle_Name__c != null)
{
splitstr = (primary.Contact_Name__r.Middle_Name__c).split(' ');
if(splitstr != null)
FinnoneNewAsset.Primary_Middle_Name__c=splitstr[0];
}
else
{
if(primary.Contact_Name__r.Father_s_Name__c!=null)
splitstr = (primary.Contact_Name__r.Father_s_Name__c).split(' ');
if(splitstr != null)
FinnoneNewAsset.Primary_Middle_Name__c=splitstr[0];
}

FinnoneNewAsset.Primary_PAN__c=primary.Contact_Name__r.PAN_Number__c;
FinnoneNewAsset.Primary_Incorporate_Date__c=primary.Contact_Name__r.Year_of_Incorporation__c;
FinnoneNewAsset.Primary_ROC_Registration_Number__c=primary.Contact_Name__r.ROC_Regn_No__c;

/**if(primary.Contact_Name__r.ApplicantType__c=='Primary')
FinnoneNewAsset.Primary_Applicant_Type__c='P';
else ******
FinnoneNewAsset.Primary_Applicant_Type__c='CMMM';

if(primary.Contact_Name__r.Customer_Type__c=='Individual')
FinnoneNewAsset.Primary_Customer_Type__c='I';
else if(primary.Contact_Name__r.Customer_Type__c=='Corporate')
FinnoneNewAsset.Primary_Customer_Type__c='C';

if(primary.Contact_Name__r.Customer_Profile__c=='Salaried')
FinnoneNewAsset.Primary_Customer_Profile__c='3';
else if(primary.Contact_Name__r.Customer_Profile__c=='SEP')
FinnoneNewAsset.Primary_Customer_Profile__c='4';
else if(primary.Contact_Name__r.Customer_Profile__c=='SENP')
FinnoneNewAsset.Primary_Customer_Profile__c='5';
else if(primary.Contact_Name__r.Customer_Profile__c=='EMPLOYEE')
FinnoneNewAsset.Primary_Customer_Profile__c='14';
else if(primary.Contact_Name__r.Customer_Profile__c=='Others')
FinnoneNewAsset.Primary_Customer_Profile__c='1';

if(primary.Contact_Name__r.Marital_Status__c=='Married')
FinnoneNewAsset.Primary_Marital_Status__c='M';
else if(primary.Contact_Name__r.Marital_Status__c=='Single')
FinnoneNewAsset.Primary_Marital_Status__c='S';
else if(primary.Contact_Name__r.Marital_Status__c=='Divorsed')
FinnoneNewAsset.Primary_Marital_Status__c='D';
else if(primary.Contact_Name__r.Marital_Status__c=='Widow')
FinnoneNewAsset.Primary_Marital_Status__c='W';

if(primary.Contact_Name__r.Type_Of_Constitution__c=='PROBATIONARY')
FinnoneNewAsset.Primary_Constitution_type__c='1';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='REGULAR')
FinnoneNewAsset.Primary_Constitution_type__c='2';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='CONTRACTUAL')
FinnoneNewAsset.Primary_Constitution_type__c='3';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='PENSIONER')
FinnoneNewAsset.Primary_Constitution_type__c='4';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='PART TIME')
FinnoneNewAsset.Primary_Constitution_type__c='5';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='INDIRECT EARNERS')
FinnoneNewAsset.Primary_Constitution_type__c='6';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='GOVT ORGANIZATION')
FinnoneNewAsset.Primary_Constitution_type__c='7';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='LIMITED COMPANY')
FinnoneNewAsset.Primary_Constitution_type__c='8';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='PVT LIMITED COMPANY')
FinnoneNewAsset.Primary_Constitution_type__c='9';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='PARTNERSHIP')
FinnoneNewAsset.Primary_Constitution_type__c='10';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='PROPRIETARISHIP')
FinnoneNewAsset.Primary_Constitution_type__c='11';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='MNC')
FinnoneNewAsset.Primary_Constitution_type__c='12';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='OTHER')
FinnoneNewAsset.Primary_Constitution_type__c='13';


FinnoneNewAsset.First_Name__c=primary.Contact_Name__r.FirstName;
FinnoneNewAsset.Last_Name__c=primary.Contact_Name__r.LastName;
FinnoneNewAsset.Middle_Name__c=primary.Contact_Name__r.Middle_Name__c;
if(primary.Contact_Name__r.Middle_Name__c != null)
{
splitstr = (primary.Contact_Name__r.Middle_Name__c).split(' ');
if(splitstr != null)
FinnoneNewAsset.Middle_Name__c=splitstr[0];
}
else
{
if(primary.Contact_Name__r.Father_s_Name__c!=null)
splitstr = (primary.Contact_Name__r.Father_s_Name__c).split(' ');
if(splitstr != null)
FinnoneNewAsset.Middle_Name__c=splitstr[0];
}

FinnoneNewAsset.ROC_Registration_Number__c=primary.Contact_Name__r.ROC_Regn_No__c;
FinnoneNewAsset.PAN__c=primary.Contact_Name__r.PAN_Number__c;
FinnoneNewAsset.Date_of_Birth__c=primary.Contact_Name__r.Date_of_Birth__c;
FinnoneNewAsset.Designation__c=primary.Contact_Name__r.Designation__c;
FinnoneNewAsset.Years_In_Present_Job__c=primary.Contact_Name__r.Year_in_Present_Job__c;
FinnoneNewAsset.Years_In_Previous_Job__c=primary.Contact_Name__r.Year_in_Previous_Job__c;
FinnoneNewAsset.Nature_Of_Business__c=primary.Contact_Name__r.Nature_of_Business__c;
FinnoneNewAsset.Employment_Status__c=primary.Contact_Name__r.Employment_Status__c;
if(primary.Contact_Name__r.Gender__c=='Male')
FinnoneNewAsset.Gender__c='M';
else
FinnoneNewAsset.Gender__c='F';
FinnoneNewAsset.Age__c=primary.Contact_Name__r.Age__c;
if(primary.Contact_Name__r.Employment_Type__c=='Salaried' || primary.Contact_Name__r.Employment_Type__c=='salaried')
FinnoneNewAsset.Employment_Type__c='SAL';
FinnoneNewAsset.Office_Address_1__c=primary.Contact_Name__r.Address_Line_One__c;
FinnoneNewAsset.Office_Address_2__c=primary.Contact_Name__r.Address_2nd_Line__c;
FinnoneNewAsset.Office_Address_3__c=primary.Contact_Name__r.Address_3rd_Line__c;
if(primary.Contact_Name__r.Office_Pin_Code__c != null)
FinnoneNewAsset.Office_ZIP_Code__c=primary.Contact_Name__r.Office_Pin_Code__c;
FinnoneNewAsset.Office_STD_Code__c=string.valueof(primary.Contact_Name__r.Office_STD_Code__c);
if(primary.Contact_Name__r.Office_Phone_Number__c != null)
FinnoneNewAsset.Office_Phone_No__c=primary.Contact_Name__r.Office_Phone_Number__c;
FinnoneNewAsset.Permanent_Address_1__c=primary.Contact_Name__r.Permanant_Address_Line_1__c;
FinnoneNewAsset.Permanent_Address_2__c=primary.Contact_Name__r.Permanant_Address_Line_2__c;
FinnoneNewAsset.Permanent_Address_3__c=primary.Contact_Name__r.Permanant_Address_Line_3__c;
FinnoneNewAsset.Permanent_STD_Code__c=string.valueof(primary.Contact_Name__r.Permanent_STD__c);
FinnoneNewAsset.Permanent_ZIP_Code__c=string.valueof(primary.Contact_Name__r.Permanent_Pin_Code__c);
FinnoneNewAsset.Years_In_Present_Job__c=primary.Contact_Name__r.Year_in_Present_Job__c;
FinnoneNewAsset.Years_In_Previous_Job__c=primary.Contact_Name__r.Year_in_Previous_Job__c;
FinnoneNewAsset.Nature_Of_Business__c=primary.Contact_Name__r.Nature_of_Business__c;
FinnoneNewAsset.Employment_Status__c=primary.Contact_Name__r.Employment_Status__c;
FinnoneNewAsset.Employment_Type__c=primary.Contact_Name__r.Employment_Type__c;
FinnoneNewAsset.Incorporation_Date__c=primary.Contact_Name__r.Year_of_Incorporation__c;
FinnoneNewAsset.Registered_Address_1__c=primary.Contact_Name__r.Address_1__c;
FinnoneNewAsset.Registered_Address_2__c=primary.Contact_Name__r.Address_2__c;
FinnoneNewAsset.Registered_Address_3__c=primary.Contact_Name__r.Address_3__c;
FinnoneNewAsset.Registered_Zip_Code__c=string.valueof(primary.Contact_Name__r.Pin_Code__c);
FinnoneNewAsset.Registered_STD_Code__c=string.valueof(primary.Contact_Name__r.STD_Code__c);
if(primary.Contact_Name__r.Phone_Number__c != null)
FinnoneNewAsset.Registered_Phone_No__c=primary.Contact_Name__r.Phone_Number__c;
if(primary.Contact_Name__r.Mobile_Phone__c != null)
FinnoneNewAsset.Registered_Mobile_No__c=primary.Contact_Name__r.Mobile_Phone__c;
FinnoneNewAsset.Residence_Address_1__c=primary.Contact_Name__r.Address_1__c;
FinnoneNewAsset.Residence_Address_2__c=primary.Contact_Name__r.Address_2__c;
FinnoneNewAsset.Residence_Address_3__c=primary.Contact_Name__r.Address_3__c;
FinnoneNewAsset.Residence_Pin_Code__c=string.valueof(primary.Contact_Name__r.Pin_Code__c);
FinnoneNewAsset.Residence_STD_Code__c=primary.Contact_Name__r.STD_Code__c;
if(primary.Contact_Name__r.Phone_Number__c != null)
FinnoneNewAsset.Residence_Phone__c=primary.Contact_Name__r.Phone_Number__c;
if(primary.Contact_Name__r.Mobile_Phone__c != null)
FinnoneNewAsset.Residence_Mobile__c=primary.Contact_Name__r.Mobile_Phone__c;
if(loan.Customer_email_id__c!=null && loan.Customer_email_id__c!='')
FinnoneNewAsset.Residence_E_Mail__c=loan.Customer_email_id__c;
else
FinnoneNewAsset.Residence_E_Mail__c=loan.Accountant_email_id__c;

//added by Suraj...Audit Finnone enhancement...Start
FinnoneNew.office_email_id__c = loan.Account.Accountant_email_id__c;
FinnoneNew.Office_Landline_Number1__c = loan.Account.Office_Landline_Number1__c;
//added by Suraj...Audit Finnone enhancement...end

FinnoneNewAsset.Other_Employer_Name__c=primary.Contact_Name__r.Name_of_Employer__c;

if(primary.Contact_Name__r.Customer_Type__c=='Individual')
FinnoneNewAsset.Customer_Type__c='I';
else if(primary.Contact_Name__r.Customer_Type__c=='Corporate')
FinnoneNewAsset.Customer_Type__c='C';

if(primary.Contact_Name__r.Marital_Status__c=='Married')
FinnoneNewAsset.Marital_Status__c='M';
else if(primary.Contact_Name__r.Marital_Status__c=='Single')
FinnoneNewAsset.Marital_Status__c='S';
else if(primary.Contact_Name__r.Marital_Status__c=='Divorsed')
FinnoneNewAsset.Marital_Status__c='D';
else if(primary.Contact_Name__r.Marital_Status__c=='Widow')
FinnoneNewAsset.Marital_Status__c='W';

/**if(primary.Contact_Name__r.ApplicantType__c=='Primary')
FinnoneNewAsset.Applicant_Type__c='P';
else *******
FinnoneNewAsset.Applicant_Type__c='C';

if(primary.Contact_Name__r.Customer_Profile__c=='Salaried')
FinnoneNewAsset.Customer_Profile__c='3';
else if(primary.Contact_Name__r.Customer_Profile__c=='SEP')
FinnoneNewAsset.Customer_Profile__c='4';
else if(primary.Contact_Name__r.Customer_Profile__c=='SENP')
FinnoneNewAsset.Customer_Profile__c='5';
else if(primary.Contact_Name__r.Customer_Profile__c=='EMPLOYEE')
FinnoneNewAsset.Customer_Profile__c='14';
else if(primary.Contact_Name__r.Customer_Profile__c=='Others')
FinnoneNewAsset.Customer_Profile__c='1';


if(primary.Contact_Name__r.Type_Of_Constitution__c=='PROBATIONARY')
FinnoneNewAsset.Type_of_Constitution__c='1';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='REGULAR')
FinnoneNewAsset.Type_of_Constitution__c='2';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='CONTRACzTUAL')
FinnoneNewAsset.Type_of_Constitution__c='3';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='PENSIONER')
FinnoneNewAsset.Type_of_Constitution__c='4';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='PART TIME')
FinnoneNewAsset.Type_of_Constitution__c='5';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='INDIRECT EARNERS')
FinnoneNewAsset.Type_of_Constitution__c='6';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='GOVT ORGANIZATION')
FinnoneNewAsset.Type_of_Constitution__c='7';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='LIMITED COMPANY')
FinnoneNewAsset.Type_of_Constitution__c='8';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='PVT LIMITED COMPANY')
FinnoneNewAsset.Type_of_Constitution__c='9';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='PARTNERSHIP')
FinnoneNewAsset.Type_of_Constitution__c='10';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='PROPRIETARISHIP')
FinnoneNewAsset.Type_of_Constitution__c='11';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='MNC')
FinnoneNewAsset.Type_of_Constitution__c='12';
else if(primary.Contact_Name__r.Type_Of_Constitution__c=='OTHER')
FinnoneNewAsset.Type_of_Constitution__c='13';

//Loading Asset Details
FinnoneNewAsset.Asset_Category__c=properties[0].Asset_Category__c;
FinnoneNewAsset.Asset_Code__c=properties[0].Asset_Model__c;
FinnoneNewAsset.Asset_Cost__c=properties[0].Asset_Cost__c;
FinnoneNewAsset.Asset_Make__c=properties[0].Asset_Master__r.Name;
if(properties[0].Asset_FinnOne_Code__c != null)
FinnoneNewAsset.Asset_Model_Id__c=Decimal.valueof(properties[0].Asset_FinnOne_Code__c);

FinnoneNewAsset.Contact_Person_Name1__c= cpn;

FinnoneListAsset.add(FinnoneNewAsset);
system.debug('aaaaaaaaaaaaaaaaaa'+FinnoneListAsset);
*/
                        system.debug('befadding');
                        FinnoneListAsset.add(FinnoneNewassetrecord);
                        // insert FinnoneListAsset;
                        //insert new FinnOne_Report__c(Loan_Application__c=Loan.Id);
                        system.debug('afteradding');
                    }
                    // insert FinnoneListAsset;
                }
                
                Loan.Sent_To_Finnone__c = true;
                update Loan;
                
                //Send sms and email to customer and internal users after loan application is moved to Sent to Finone stage when product = FAS  //YK
                if (Loan.Product__c != null && Loan.Product__c == 'FAS') {
                    List < Opportunity > LoanList = new List < Opportunity > ();
                    LoanList.add(Loan);
                    GeneralCommunicationHandler.sendSMS(LoanList, 'Sent to Finone-Cust');
                    GeneralCommunicationHandler.sendSMS(LoanList, 'Sent to Finone-Int');
                    GeneralCommunicationHandler.sendEmail(LoanList, 'Sent to Finone-Cust');
                    GeneralCommunicationHandler.sendEmail(LoanList, 'Sent to Finone-Int');
                }
                
                // Start of insurance SMS changes by Niraj
                if (InsurancesmsSent) { //bug-12479-Anjali
                    
                    // Start of SMS N functionality changes - 17923
                    Map < String, String > productCodeMap = new Map < String, String > ();
                    Set < String > productCodeSet = new Set < String > ();
                    for (DPLinsurance__c insObj: ListDPLinsurance) {
                        if (insObj.Insurance_Product__c != null) {
                            productCodeSet.add(insObj.Insurance_Product__c);
                        }
                    }
                    
                    for (Parameter_Master__c PMObj: [SELECT Product_Code__c, Product_Short_Code__c FROM Parameter_Master__c WHERE Product_Code__c IN: productCodeSet AND Active__c = true AND Product_Short_Code__c != null]) {
                        productCodeMap.put(PMObj.Product_Code__c, PMObj.Product_Short_Code__c);
                    }
                    system.debug('productCodeMap in sendfinnone :: ' + productCodeMap);
                    // End of SMS N functionality changes - 17923
                    
                    List < Opportunity > LoanList = new List < Opportunity > ();
                    LoanList.add(Loan);
                    //system.debug('insuranceList --> ' + ListDPLinsurance);
                    List < DPLinsurance__c > insuranceListWithNominee = new List < DPLinsurance__c > ();
                    List < DPLinsurance__c > insuranceListWithoutNominee = new List < DPLinsurance__c > ();
                    for (DPLinsurance__c tempIns: ListDPLinsurance) {
                        if (productCodeMap.containsKey(tempIns.Insurance_Product__c)) { // Added for SMS N functionality changes - 17923
                            if (tempIns.Nominee_Name__c != null && tempIns.Nominee_Name__c != '') {
                                insuranceListWithNominee.add(tempIns);
                            } else {
                                insuranceListWithoutNominee.add(tempIns);
                            }
                        }
                    }
                    system.debug('insuranceListWithNominee --> ' + insuranceListWithNominee);
                    system.debug('insuranceListWithoutNominee --> ' + insuranceListWithoutNominee);
                    system.debug('Sending insurance SMS to Customer and Sales for SHL/Home Loan/LAP');
                    GeneralCommunicationHandler.sendSMS(LoanList, insuranceListWithNominee, 'InsuranceWNom-Cust'); // For SHL/Home Loan/LAP
                    GeneralCommunicationHandler.sendSMS(LoanList, insuranceListWithNominee, 'InsuranceWNom-Int'); // For SHL/Home Loan/LAP  
                    GeneralCommunicationHandler.sendSMS(LoanList, insuranceListWithoutNominee, 'InsuranceWONom-Cust'); // For SHL/Home Loan/LAP
                    GeneralCommunicationHandler.sendSMS(LoanList, insuranceListWithoutNominee, 'InsuranceWONom-Int'); // For SHL/Home Loan/LAP  
                    InsurancesmsSent = false; //bug-12479-Anjali      
                    // Added by Anurag for 22531 S
                    List<SMS_Sent__c> smsList = [select id, DPLinsurance__c from SMS_Sent__c WHERE LoanApplication__c =: Loan.Id and (name like '%InsuranceWNom-Cust' OR name like '%InsuranceWONom-Cust')];
                    List<DPLInsurance__c> insList = [select id from DPLInsurance__c WHERE Opportunity__c =: Loan.Id];
                    for(Integer i = 0; i < smsList.size(); i++) {
                        if(i < insList.size()) {
                            smsList[i].DPLinsurance__c = insList[i].id;
                        }
                    }
                    System.debug('smsList DPLInsurance: '+smsList);
                    update smsList;
                    // Added by Anurag for 22531 E
                }
                // End of insurance SMS changes by Niraj
                
            }
        }
        //return new Pagereference('/'+ LoanId);
    }
    
    // new process for QDP by wipro<---------god----------siva>
    public void QDP(Opportunity opp, List < Verification__c > verificationRec) {
        
        List < Scheme_Master__c > totalSchemes = Database.query('select id,name from Scheme_Master__c');
        set < id > selectedSchemeids = new set < id > ();
        
        for (integer g = 0; g < totalSchemes.size(); g++) {
            if (opp.Product__c == 'SAL' || opp.Product__c == 'SPL' || opp.Product__c == 'SBS CS SAL' || opp.Product__c == 'SOL') {
                if (totalSchemes[g].name.contains('BT') || totalSchemes[g].name.contains('Topup') || totalSchemes[g].name.contains('TOP UP') || totalSchemes[g].name.contains('BT ') || totalSchemes[g].name.contains(' BT')) {
                    selectedSchemeids.add(totalSchemes[g].id);
                    system.debug('scheme name' + totalSchemes[g].name);
                }
            } //in side for
            else if (opp.Product__c == 'SBS CS PSBL' || /*Bug :16959 S*/ isPSBLProductLineProduct == true /*Bug :16959 E*/ || isNewProductFlowEnabled == true || opp.Product__c == 'DOCTORS' || DOCProducts.contains(opp.Product__c.toUppercase()) || opp.Product__c == 'RDL') {
                if (opp.Type_Of_Loan__c == 'Top Up 1' || opp.Type_Of_Loan__c == 'Top Up 2' || opp.Type_Of_Loan__c == 'Top Up 3') {
                    sendtofinoneOK = false;
                }
            }
        }
        
        // set flag = true if it is passed
        if (opp.stagename != null && opp.MICR_Number__c != null && (opp.Scheme_Master__c != null || opp.Type_Of_Loan__c != null)) {
            if (opp.Product__c == 'SAL' || opp.Product__c == 'SPL' || opp.Product__c == 'SBS CS SAL' || opp.Product__c == 'SOL') {
                if (opp.Scheme_Master__r.Active__c == false) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Selected Scheme master is not Active');
                    Apexpages.addMessage(myMsg);
                }
                if ((opp.stagename == 'Approved' || opp.stagename == 'Branch Ops' || opp.stagename == 'Moved To Finnone') && (!selectedSchemeids.contains(opp.Scheme_Master__c)) && opp.Scheme_Master__r.Active__c == true) {
                    firstProcessOK = true;
                    ErrorFlag = false;
                }
            } else if (opp.Product__c == 'SBS CS PSBL' || /*Bug :16959 S*/ isPSBLProductLineProduct == true /*Bug :16959 E*/ || isNewProductFlowEnabled == true || opp.Product__c == 'DOCTORS' || DOCProducts.contains(opp.Product__c.toUppercase()) || opp.Product__c == 'RDL') {
                if ((opp.stagename == 'Approved' || opp.stagename == 'Verifications' || opp.stagename == 'Branch Ops' || opp.stagename == 'Moved To Finnone') && sendtofinoneOK == true) firstProcessOK = true;
            } //inner iff
        }
        
        
        system.debug('firstProcessOK' + firstProcessOK + 'totalyes::' + totalyes);
        
        
        if (opp.Product__c == 'SAL' || opp.Product__c == 'SOL' || opp.Product__c == 'SPL' || opp.Product__c == 'SBS CS SAL' || /*Bug :16959 S*/ isPSBLProductLineProduct == true /*Bug :16959 E*/ || isNewProductFlowEnabled == true || opp.Product__c == 'DOCTORS' || DOCProducts.contains(opp.Product__c.toUppercase()) || opp.Product__c == 'RDL' || opp.Product__c == 'SBS CS PSBL') {
            if (firstProcessOK == true && totalyes == 0) {
                SendToFinnone(Loan, properties, apps, verificationRec);
            }
        }
        
        
        //else if(Loan.QDP__c == true){SendToFinnone(Loan,properties,apps,verificationRec);}
        //else(opp.Doc_Approved__c=='No'{
        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Deferral Documment not yet approved.so, you can not do the sendtoFinnone'));
        
        // }
        
        //else if(Loan.QDP__c == true){
        //SendToFinnone(Loan,properties,apps,verificationRec);
        // }
        // update opp;
    } // qdp method
    
  
    
    
}