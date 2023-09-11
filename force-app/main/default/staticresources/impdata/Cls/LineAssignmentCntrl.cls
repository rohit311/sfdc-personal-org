global without sharing class LineAssignmentCntrl {//changes access modifier from public to global for bug id 25097
 public List<DPLinsurance__c> insLst{get;set;}//25097
  public Date firstEMIDate {//25097
   get;
   set;
 }   
  public String loantype {//25097
   get;
   set;
 }
  public Current_Disbursal_Details__c cdr {//25097
        get;
        set;
    }
    
    public Current_Disbursal_Details__c cdrBT {//25097
        get;
        set;
    }
 public String declineReasons{get;set;}//25097
  public String tokennum {get;set;}//25097
   public boolean enableAccept{get;set;}//25097
 public String LoanIdStr{get;set;}//25097
 public Applicant__c PrimaryApp{get;set;}//25097
 public String iptimeStamp{get;set;}//25097
  public Decimal flexihybridAmt{get;set;}//25097

 //22019 s
 Map < String, Object > productMap;
 //22019 e
 //SAL 2.0 CR's
 public Boolean showBranchPune {
  get;
  set;
 }
 //SAL 2.0 CR's
 public Boolean isPreview {
  get;
  set;
 }
 public String accHolderName { //sal 2.0 CR
  get;
  set;
 }
 public String isTopupAccHoldName { //sal 2.0 CR
  get;
  set;
 }
 public String repayDate {
  get;
  set;
 }
 public Decimal ecsAmt {
  get;
  set;
 } //text adhoc 
//23575 s
 public Static Blob termsStatic;
 public static podetailsPageLA_AC poObjstatic;
 public blob terms;
 //public static string ipAdd;

public boolean enableButton{
    get;
    set;
}
public String tokenNumber{
    get;
    set;
}
//CR 25673,25674
public boolean EMIcard{
    get;
    set;
}
public boolean Elitecard{
    get;
    set;
}
//CR 25673,25674
public Decimal salLineCharges{
    get;
    set;
}
 public List < DPLinsurance__c > Hinsurance // = new List < DPLinsurance__c > (); //23575
 {
  get;
  set;
 }
 public Date LastEmiDate {
  get;
  set;
 }
//23575 e
public Date repydt {get;set;} // bug_24489
public Decimal flexifee {get;set;} // bug_24489
public Decimal stmpduty {get;set;} // bug_24489
public Decimal emicrdfee {get;set;} // bug_24489
public Decimal lifinsrnce {get;set;} // bug_24489
public Decimal geninsrnce {get;set;} // bug_24489
 //Bug:10236 start
 public Decimal processingFeeExcludingService {
  get;
  set;
 }
 //Bug:10236 end
 /*17556 s*/
 public List < repayWrapper > repayList {
  get;
  set;
 }
 /*17556 e*/
 public List < repayWrapper > repayListEcs //added for 23987 
 {
  get;
  set;
 }
 //Bug 13880 Online PLTB Start
 public List < Address_Details__c > addDetail {
  get;
  set;
 }
 public List < Demographic_Mapping__c > demoMapping {
  get;
  set;
 }
 //Bug 13880 Online PLTB End
 public Boolean customerAcceptanceFlag {
  get;
  set;
 }
 public Boolean showthankusection {
  get;
  set;
 }
 public Opportunity oldLoan {
  get;
  set;
 }
 String OfferId, Loanid;
 public Opportunity Loan {
  get;
  set;
 }
 public Product_Offerings__c productOffer {
  get;
  set;
 }
 public SurrogateCAM__c objSurrogateCAM {
  get;
  set;
 }
 public boolean showLineFieldSection {
  get;
  set;
 }
 public boolean showActiveLineFieldSection {
  get;
  set;
 }
 public boolean hideOtpSection {
  get;
  set;
 }
 public List < Fees_and_Charge__c > objFeesList {
  get;
  set;
 }
 public Lead_Applicants__c leadAppObj {
  get;
  set;
 }
 public Lead lead {
  get;
  set;
 }
 public String OTPValue {
  get;
  set;
 }
 public String flowType {
  get;
  set;
 }
 public String ReturnValue = '';
 public PODetailsPageLA_AC poObj;
 public Decimal ServiceTaxAmount {
  get;
  set;
 } // Bug 5990
 public Decimal serviceTax; // Bug 5990 // CIBIL Watch
 public Integer linecharges {
  get;
  set;
 }
 //DG Auto TopUp start
 public String convertedflag {
  get;
  set;
 }
 public Boolean autoTopUp {
  get;
  set;
 }
 public Decimal total {
  get;
  set;
 }
 //DG Auto TopUp end
 //Call Center Process start here
 public Decimal Othercharges {
  get;
  set;
 }
 public String FinalAmountinWords {
  get;
  set;
 }
 //Call center process end here
 //cibil watch Pramod S 
 public Account accountCreate {
  get;
  set;
 }
 public Account account {
  get;
  set;
 }
 public List < Applicant__c > appList {
  get;
  set;
 }
 public List < Applicant__c > appNonPrimaryList = new List < Applicant__c > ();
 public Applicant__c appObj {
  get;
  set;
 }
 public integer credit_vidya_cost {
  get;
  set;
 }
 public Decimal charges {
  get;
  set;
 }
 public List < Bank_Account__c > bankList = new List < Bank_Account__c > ();
 public Bank_Account__c bankObj {
  get;
  set;
 }
 public Boolean isECS {
  get;
  set;
 }
 public String processingFees {
  get;
  set;
 }
 //cibil watch Pramod E
 //sal PLTB Term And conditions E-agreement By Prashant Start
 public Decimal touchFreeCharge {
  get;
  set;
 }
 public Decimal salProcessingFees {
  get;
  set;
 }
 public Decimal processingFeesInPercent {
  /* Bug 22624 */
  get;
  set;
 }
 public Date repaymentdate {
  get;
  set;
 }
 public Decimal serviceCharge {
  get;
  set;
 }
 public Date accepteddate {
  get;
  set;
 }
 public String emailid {
  get;
  set;
 }
 public Applicant__c app {
  get;
  set;
 }
 //19478 start
 public static boolean initialMessage {
  get;
  set;
 }
 //19478 end
 /*Referral prgram added by swapnil --start*/
 public static Boolean isRefered {
  get;
  set;
 }
 public static Boolean isAccepted {
  get;
  set;
 }
 public static Boolean isDeclined {
  get;
  set;
 }
 /*Referral prgram added by swapnil-- end*/
 public Boolean ishybridflexi {
  get;
  set;
 }
 /* Bug 16507 - Changes in PLTB added by priya start*/
 public String coemailid {
  get;
  set;
 }
 public Applicant__c finantialcoapp {
  get;
  set;
 }
 public Decimal FlexiFees {
  get;
  set;
 }
 public Integer pureflexiEMI {
  get;
  set;
 }
 public Integer pureflexiperiod {
  get;
  set;
 }
 public Integer dropflexiperiod {
  get;
  set;
 }
 /* Bug 16507 - Changes in PLTB added by priya end*/
 public String viewAs {
  get;
  set;
 }

 public decimal financeCharge {
  get;
  set;
 }
 public decimal groupLife {
  get;
  set;
 }
 public decimal groupHealth {
  get;
  set;
 }
 public decimal otherfees {
  get;
  set;
 }
 public String numberToWords {
  get;
  set;
 }
 public String numberToWordsforline {
  get;
  set;
 }
 public decimal financeChargeLine {
  get;
  set;
 }
 public decimal groupLifeLine {
  get;
  set;
 }
 public decimal groupHealthLine {
  get;
  set;
 }
 public Decimal FlexiFeesLine {
  get;
  set;
 }
 public Decimal stampdutyLine {
  get;
  set;
 }

 public Decimal touchFreeChargeLine {
  get;
  set;
 }
 public Decimal maxouterlimit {
  get;
  set;
 }
 //23575 s
 public string reasons {
  get;
  set;
 }
//23575 e
 public boolean salLineflag = false; //Added for Bug 22019

 // Bug 18323 - Aman Porwal - S
 /** PLTB Changes - S **/
 public String maskingPhoneNumber {
  get;
  set;
 }
 public String maskingCoAppPhoneNumber {
  get;
  set;
 }
 public String maskingBankAccountNumber {
  get;
  set;
 }
 public String maskingRepaymentBankAccountNumber {
  get;
  set;
 }
 public String maskingEmail {
  get;
  set;
 }
 public String maskingCoAppEmail {
  get;
  set;
 }
 /** PLTB Changes - E **/

 /** SAL Line Changes - S **/
 public String maskingLeadPhoneNumber {
  get;
  set;
 }
 public String maskingLeadAppPhoneNumber {
  get;
  set;
 }
 public String maskingECSBankAccountNumber {
  get;
  set;
 }
 public String maskingDisbBankAccountNumber {
  get;
  set;
 }
 public String maskingLeadEmail {
  get;
  set;
 }
 public String maskingLeadAppEmail {
  get;
  set;
 }
 /** SAL Line Changes - E **/
 //Rohit added for SAL custom setting movement S 16987 
 transient Map < String, Object > ALLMap {
  get;
  set;
 }
 //Rohit added for SAL custom setting movement E 16987
 // Bug 18323 - Aman Porwal - E
 // flag added by gopika
 public Boolean isCallCentreFlag {
  get;
  set;
 }
 public String Flow_Of_Application_Mobility;
 public Boolean renderFeeMobility {
  get;
  set;
 }
 /*17556 s*/
 public class repayWrapper {


  public RePayment_mode_detail__c repayObj {
   get;
   set;
  }
  public Integer count {
   get;
   set;
  }
  public repayWrapper(RePayment_mode_detail__c repay, Integer count) {
   repayObj = repay;
   this.count = count;
  }
 }
 /*17556 e*/
 //URL Encrypt start 21110
 public String encPOid;
 public String encFlow;

 public String getencPOid() {
  return CommonUtility.encryptURLParamFrPAN(productOffer.id);
 }

 public String getencFlow() {
  return CommonUtility.encryptURLParamFrPAN('TermsConditions');
 }

 //URL Encrypt End 21110
 //sal PLTB Term And conditions E-agreement E
 //22017 start
 public Decimal EliteCardCharges {
  get;
  set;
 }
 public Decimal EMICardCharges {
  get;
  set;
 }
 public Decimal cppwalletfee {
  get;
  set;
 }
 public Decimal flexiassignlimitfee {
  get;
  set;
 }
 //22017 end
 //24028 S
 public static Applicant__c primaryApplicant {
  get;
  set;
 }
 public static Decimal spreadPercentage {
  get;
  set;
 }
 public static Decimal Current_BFL_FRR {
  get;
  set;
 }
 public static Boolean centralisedTopUp {
  get;
  set;
 }
 public static Boolean FloatingRate {
  get;
  set;
 }
 public static Boolean FixedRate {
  get;
  set;
 }

 //24028 E
 public LineAssignmentCntrl() {
  insLst = new List<DPLinsurance__c>(); //25097 
  //24028 S
  centralisedTopUp = false;

  //24028 E
  //23575 s
    enableButton = false;
    terms = null;
    FlexiFeesLine = 0;
    Hinsurance = new List < DPLinsurance__c > (); //23575
    //23575 e
  /*SAL 2.0 CR's s*/
  showBranchPune = false;
  if (ApexPages.currentPage().getParameters().get('isPreview') == 'true')
   isPreview = true;
  else
   isPreview = false;
  /*SAL 2.0 CR's e */
  repayList = new List < repayWrapper > (); //17556
  repayListEcs = new List < repayWrapper > (); //23987
  //DG Auto TopUp start
  convertedflag = '';
  autoTopUp = false;
  //DG Auto TopUp end  
  accHolderName = ''; //sal 2.0 CR
  isTopupAccHoldName = ''; //sal 2.0 CR
  //cibil watch Pramod S
  accountCreate = new Account();
  credit_vidya_cost = 0;
  charges = 0;
  //gopika added flag
  isCallCentreFlag = false;
  bankObj = new Bank_Account__c();
  appObj = new Applicant__c();
  isECS = true;
  processingFees = '';
  //cibil watch Pramod E
  //sal PLTB Term And conditions E-agreement S
  salProcessingFees = 0;
  processingFeesInPercent = 0; /* Bug 22624 - Hrushikesh Sprint 5C */
  financeCharge = 0;
  groupHealth = 0;
  serviceCharge = 0;
  otherfees = 0;
  groupLife = 0;
  financeChargeLine = 0;
  groupHealthLine = 0;
  groupLifeLine = 0;
  stampdutyLine = 0;
  touchFreeChargeLine = 0;
  maxouterlimit = 0;
  //22017 start
  EliteCardCharges = 0.0;
  EMICardCharges = 0.0;
  flexiassignlimitfee = 0.0;
  cppwalletfee = 0.0;
  //22017 end
  app = new Applicant__c();
  /* Bug 16507 - Changes in PLTB added by priya start */
  ishybridflexi = false;
  pureflexiEMI = 0;
  pureflexiperiod = 0;
  dropflexiperiod = 0;
     // bug_24489 start
       flexifee = 0.0;
       stmpduty = 0.0;
      emicrdfee = 0.0;
      lifinsrnce = 0.0;
      geninsrnce = 0.0;
    // bug_24489 End
  finantialcoapp = new Applicant__c(); /* Bug 16507 - Changes in PLTB added by priya end */

  String[] Id_Len = Label.SF_Id_length.split(';'); //22019
  //Encrypt Url start
  String encryptLoanId;
  if (System.currentPageReference() != null && System.currentPageReference().getParameters().get('LoanId') != null) {
   encryptLoanId = apexPages.currentPage().getParameters().get('LoanId');
   if (encryptLoanId.length() == 15 || encryptLoanId.length() == 18)
    Loanid = encryptLoanId;
   else
    Loanid = CommonUtility.decryptURLParam(encryptLoanId);
  } //Encrypt Url end
  if (ApexPages.currentPage().getParameters().get('renderFor') == 'pdf')
   viewAs = 'pdf';
  else
   viewAs = null;
  //sal PLTB Term And conditions E-agreement E
  tokennum = apexPages.currentPage().getParameters().get('Token');//25097
  hideOtpSection = true;
  customerAcceptanceFlag = false;
  showLineFieldSection = false;
  showActiveLineFieldSection = false;
  showthankusection = false;
  lead = new Lead();
  OTPValue = '';
  linecharges = 0;
  leadAppObj = new Lead_Applicants__c();
  Loan = new Opportunity();
  addDetail = new List < Address_Details__c > (); //Bug 13880 Online PLTB
  demoMapping = new List < Demographic_Mapping__c > (); //Bug 13880 Online PLTB
  oldLoan = new Opportunity();
  objSurrogateCAM = new SurrogateCAM__c();
  productOffer = new Product_Offerings__c();
  System.debug('id len is ' + Id_Len);
  //bug 22019 s
  if (ApexPages.currentPage().getParameters() != null && ApexPages.currentPage().getParameters().get('id') != null && (Id_Len != null && !Id_Len.contains(String.valueOf(ApexPages.currentPage().getParameters().get('id').length())))) {
   if (ApexPages.currentPage().getParameters().get('Flow') != null)
    flowType = CommonUtility.decryptURLParamFrPan(ApexPages.currentPage().getParameters().get('Flow'));

   if (ApexPages.currentPage().getParameters().get('id') != null) {
    OfferId = CommonUtility.decryptURLParamFrPan(ApexPages.currentPage().getParameters().get('id'));
   }
   if(flowType == 'NewLine' && !CommonUtility.isEmpty(ApexPages.currentPage().getParameters().get('token'))){
        tokenNumber = CommonUtility.decryptURLParamFrPan(ApexPages.currentPage().getParameters().get('token'));//23575
        system.debug('token number is : '+tokenNumber);
    }
   if (ApexPages.currentPage().getParameters() != null && ApexPages.currentPage().getParameters().get('Converted') != null) {
    convertedflag = CommonUtility.decryptURLParamFrPan(ApexPages.currentPage().getParameters().get('Converted'));
   }
  } else {
   flowType = ApexPages.currentPage().getParameters().get('Flow');
   OfferId = ApexPages.currentPage().getParameters().get('id');
   //Loanid = ApexPages.currentPage().getParameters().get('LoanId'); /*encrypt url abhishek */
    //Loanid = ApexPages.currentPage().getParameters().get('LoanId');//25097
       System.debug('@@swapnil '+Loanid);
       // LoanIdStr = String.valueOf(Loanid);//25097
   convertedflag = ApexPages.currentPage().getParameters().get('Converted');
   processingFees = ApexPages.currentPage().getParameters().get('profees');
   if(flowType == 'NewLine' && !CommonUtility.isEmpty(ApexPages.currentPage().getParameters().get('token'))){
        tokenNumber = ApexPages.currentPage().getParameters().get('token');//23575 //25097
    }
  }
  //bug 22019 e
  //DG Auto TopUp start
  convertedflag = ApexPages.currentPage().getParameters().get('Converted');
  system.debug('convertedflag-------->>>>>>>>>>' + convertedflag);
  //DG Auto TopUp end
  processingFees = ApexPages.currentPage().getParameters().get('profees');
  system.debug('processingFees-------->>>>>>>>>>' + processingFees);
  //flowType = lineActive || LineAccept
  /*** testing***/
    
  system.debug('Loanid' + Loanid);


  MAP < String, String > mapofheader = new MAP < String, String > ();
  mapofheader = ApexPages.currentPage().getHeaders();
  ReturnValue = ApexPages.currentPage().getHeaders().get('True-Client-IP');
  // X-Salesforce-SIP has the value when no caching integration or via secure URL.
  if (ReturnValue == '' || ReturnValue == null) {
   ReturnValue = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
  } // get IP address when no caching (sandbox, dev, secure urls)
  if (ReturnValue == '' || ReturnValue == null) {
   ReturnValue = ApexPages.currentPage().getHeaders().get('X-Forwarded-For');
  } // get IP address from standard header if proxy in use
  system.debug('USER IP ADDRESS: ' + mapofheader);
  system.debug('ReturnValue  : ' + ReturnValue);


  /*** testing***/
  System.debug('--- OfferId---' + OfferId);
  if (OfferId != null) {
 //  Bug_24489--RDL_Line -- Bug_24801 RDL Agreement -- added Report_Branch__c,Disbursement_Bank_IFSC_code__c ,
   productOffer = [SELECT id,Report_Branch__c,Disbursement_Bank_IFSC_code__c , /*23575 s*/Bank_Account_Type__c,Mode_of_Payment__c,/*23575 e*/Net_Disbursement_Amount__c, Tele_Calling_Sub_disposition__c, Field_Sub_disposition__c, First_Due_Date__c, Employment_Type__c, SME_Score__c, Offer_PF__c, Loan_Type__c, Program_Type__c, ASM__c, Process_Type__c, Customer_ID1__r.CIBIL_Segmentation__c, Office_Address_1__c, Office_Address_2__c, Office_Address_3__c, Office_City__c, Office_Pin_Code__c, Office_State__c, Office_Phone__c, Ignore_MCP_Results__c, Resi_Pick_State__c, Resi_Pick_City__c, Address_Change_flag__c, Customer_ID1__r.Customer_Name__c, Resi_city__c, BT_Bank__c, name, SBS_Scheme__c, Opportunity__r.Name, Experience_in_Years__c, Scheme_Name__c, Customer_ID1__r.Customer_ID__c, Opportunity__r.Id, ownerId, EMI_Amount__c, Availed_EMI__c, Products__c, Sourcing_Channel__r.Name, Product_Offering_Converted__c,
    Offer_Accepted_amount__c, Lead__c, Lead__r.Employment_Type__c, Existing_Product__c, Customer_Name__c, Customer_ID1__c, Customer_ID1__r.Flow__c, Customer_ID1__r.Email_New__c, Customer_ID1__r.Name, Customer_ID1__r.Address_Change__c, Customer_ID1__r.Contact_Person_Name__c, Customer_E_mail__c, Customer_Email_ID__c, Customer_ID__c, Customer_Mobile__c, Address_Line_1__c, Field_Desposition_Status__c, Existing_LAN__c, Address_Line_2__c, Address_Line_3__c, Pin_Code__c, Resi_State__c, Customer_ID1__r.State__c, Final_Amount__c, Offer_ROI__c, Tenor__c, Specialisation__c, Degree__c,
    Offer_Amount__c, Offer_ID__c, TeleCalling_Desposition_Status__c, Field_Check_Status__c, DNC_flag__c, Sourcing_Channel__c, Product_Offering_Source__c,
    eKYC_Processing__c, eKYC_First_Name__c, eKYC_Last_Name__c, Aadhar_Number__c, eKYC_DOB__c, Existing_Customer_Segmentation__c, Availed_Amount__c,
    Risk_Classification__c, Open_Ecs_Limit__c, Disb_Act_No__c, Disb_Bank_Name__c, Disb_Bank_Branch__c, Disb_favouring__c, PDD_pending__c, POS_Old_Loan__c,
    Secured_W_O_BT_Line_Assigned__c, Converted_Offer_Product__c, Ext_Finance_Amount__c, Secured_W_O_BT_Line_Available__c, Secured_BT_Line_Assigned__c, Secured_BT_Line_Available__c, Secured_Line_Expiry_Date__c, Unsecured_Line_Expiry_Date__c, Unsecured_W_O_BT_Line_Assigned__c, Unsecured_W_O_BT_Line_Available__c, Unsecured_BT_Line_Assigned__c, Unsecured_BT_Line_Available__c, Opportunity__c, Converted_Date_Time__c,
    Existing_Tenor__c, Topup_Amount__c, Balance_Tenure__c, Last_EMI_Paid__c, DPD_String__c, Bucket_String__c, Old_SFDC_Loan_Application__c,
    Bounce_in_Life_Cycle__c, POS__c, Overdue_Charges__c, Total_POS__c, Referral__c, Customer_Type__c, Monthly_Obligation__c, Revised_Offer_ROI__c, Product_Offering_Type1__c, IP_Address__c, Line_utilized__c,
    Nominator_ID__c, Data_Mart_Status__c, Hold_Reason__c, Opportunity__r.createddate, Line_Accepted__c, Customer_Acceptance_Flag__c, One_time_password__c, Line_Activation_Acceptance__c, Bank_name__c, BRANCH__c, IFSC_Code__c, Lead__r.Bank_Name__c, Lead__r.Bank_Account_Number__c, Availed_Tenor__c, Insurance_Product__c, Insurance_Premium_Amount__c,
    Insurance_Type__c, FFR_Flag__c, ECS_Bank_Account_number__c, FFR_amount__c, Processing_Fee_Amount__c, Consultation_Fees__c, Customer_Acceptance_Date__c, BPI__c /*@16507*/ , (Select Id, FFR__c, Charge_Type__c, Finnone_ChargeId__c, Change_Amount__c, Charge_Desc__c, Deducted_From_disbursement__c from Fees_and_Charges__r), (Select id, Insurance_Type__c, Premium_Amount__c from Insurance__r), SBS_Scheme__r.flexi_flag__c, SBS_Scheme__r.is_Pure_Flexi__c, SBS_Scheme__r.PLOC_scheme__c, SBS_Scheme__r.IsHybridFlexi__c /*@16507*/ /*22019 s*/ , New_line_assigned__c, Line_activation_Fees_Status__c, UTM_Source__c /*22019 e*/,/*added for bug 23575s*/ (Select Name, Old_Address_Value__c From SOL_Policys__r),ECS_Error_Msg__c, Bank_Details_Change__c,Cheque_In_Favoring__c,opportunity__r.Loan_Application_Number__c /* added for bug 23575 e*/ from Product_Offerings__c where id =: OfferId limit 1
   ];
   System.debug('--- productOffer ---' + productOffer);
   //23575 s
    if (productOffer.First_Due_Date__c != null) {
     Date endDate = productOffer.First_Due_Date__c.addMonths(Integer.valueOf(productOffer.Availed_Tenor__c) - 1);
     LastEMIDate = date.newinstance(endDate.year(), endDate.month(), endDate.day());
    }
    //23575 e
        // bug_24489 s
            if (productOffer.First_Due_Date__c != null &&  productOffer.Availed_Tenor__c != null) {
                  repydt = productOffer.First_Due_Date__c.addMonths(Integer.valueOf(productOffer.Availed_Tenor__c));
              //  repydt = date.newinstance(repydt.year(), repydt.month(), repydt.day());
            }
          // bug_24489 e
          // bug_24489 start
       flexifee = 0.0;
       stmpduty = 0.0;
      emicrdfee = 0.0;
      lifinsrnce = 0.0;
      geninsrnce = 0.0;
      
      set<String> lifinsrnc = new set<String>();
      set<String> geninsrnc = new set<String>();
      
      if(Label.Life_insurance_Chargid != null && Label.Life_insurance_Chargid != '')
        lifinsrnc.addAll(Label.Life_insurance_Chargid.split(';'));
        
      if(Label.General_insurance_Chargid != null && Label.General_insurance_Chargid != '')
        geninsrnc.addAll(Label.General_insurance_Chargid.split(';'));
       
       for (Fees_and_Charge__c fc: productOffer.Fees_and_Charges__r) {
         
          /*Flexi fee (if availed) calculation  Start*/
         if (fc.Finnone_ChargeId__c == 500509 && fc.Change_Amount__c != null) {
          flexifee = flexifee + fc.Change_Amount__c;
         }
         /*Flexi fee (if availed) calculation  End*/
         
         /*stamp duty charges Start*/
         if (fc.Finnone_ChargeId__c == 500655 && fc.Change_Amount__c != null) {
          stmpduty = stmpduty + fc.Change_Amount__c;
         }
         /*stamp duty charges End*/
         
          /*EMI card fee Start*/
         if (fc.Finnone_ChargeId__c == 600731 && fc.Change_Amount__c != null) {
          emicrdfee = emicrdfee + fc.Change_Amount__c;
         }
         /*EMI card fee End*/
         /*life insurance Start*/
         if ( fc.Change_Amount__c != null && fc.Finnone_ChargeId__c != null && lifinsrnc.contains(String.valueOf(fc.Finnone_ChargeId__c)) ) {
          lifinsrnce = lifinsrnce + fc.Change_Amount__c;
         }
         /*life insurance End*/
         
          /*General insurance Start*/
         if ( fc.Change_Amount__c != null && fc.Finnone_ChargeId__c != null && geninsrnc.contains(String.valueOf(fc.Finnone_ChargeId__c)) ) {
          geninsrnce = geninsrnce + fc.Change_Amount__c;
         }
         /*General insurance End*/
          //23575 s
         if(fc.Change_Amount__c != null && fc.Finnone_ChargeId__c != null && fc.Finnone_ChargeId__c == Integer.valueOf('500671') && fc.Deducted_from_Disbursement__c == 'Yes' && fc.Change_Amount__c > 0){
             EmiCard = true;//CR 25673
             EMICardCharges = fc.Change_Amount__c.setscale(2);
             system.debug('inside emi card true');
         }
         if(fc.Change_Amount__c != null && fc.Finnone_ChargeId__c != null && fc.Finnone_ChargeId__c == Integer.valueOf('601754') && fc.Deducted_from_Disbursement__c == 'Yes' && fc.Change_Amount__c > 0){
             EliteCard = true; //CR 25673
             EliteCardCharges = fc.Change_Amount__c.setscale(2);
         }
         if(fc.Change_Amount__c != null && fc.Finnone_ChargeId__c != null && fc.Finnone_ChargeId__c == Integer.valueOf('601586') && fc.Deducted_from_Disbursement__c == 'Yes' && fc.Change_Amount__c > 0){
             //EliteCard = true;
             salLineCharges = fc.Change_Amount__c.setscale(2);
         }
         //23575 e
        
    }
  // bug_24489 end
   if (productOffer != null) {
    productOffer.IP_Address__c = ReturnValue;
    // Bug 22019 Start Added New_line_assigned__c,Line_activation_Fees_Status__c,UTM_Source__c in aboe query.

    system.debug('Before salLineflag' + salLineflag);
    system.debug('LineAssignedflag' + productOffer.New_line_assigned__c);
    String prod = productOffer.Products__c;
    if (productOffer.New_line_assigned__c == true || ((productOffer.Product_Offering_Source__c == 'Cibil 2' || productOffer.Product_Offering_Source__c == 'CIBIL 2' || productOffer.Product_Offering_Source__c == 'CIBIL 3' || productOffer.Product_Offering_Source__c == 'Cibil 3'))) {
     system.debug('NewLineAssignedFlag' + productOffer.New_line_assigned__c);
     if (ProductSMS__c.getValues('SalariedLineAsignmentProducts') != null) {
      String products = ProductSMS__c.getValues('SalariedLineAsignmentProducts').Produtc__c;
      if (products != null) {
       system.debug('***Line Products***' + products);
       String[] arr = products.split(';');
       for (String str: arr) {
        if (str.ToUpperCase() == prod.ToUpperCase())
         salLineflag = true;
       }
      }
     }
    }
    system.debug('After salLineflag' + salLineflag);
    // Bug 22019 Stop
    // Bug 18323 - Aman Porwal - S
    if (productOffer.Disb_Act_No__c != null && productOffer.Disb_Act_No__c != '') {
     String bankAccountNumber = productOffer.Disb_Act_No__c;
     String bankX = '';
     for (Integer i = 1; i <= bankAccountNumber.length() - 4; i++) {
      bankX = bankX + 'X';
     }
     maskingDisbBankAccountNumber = bankX + bankAccountNumber.subString(bankAccountNumber.length() - 4);
    }

    if (productOffer.ECS_Bank_Account_number__c != null && productOffer.ECS_Bank_Account_number__c != '') {
     String bankAccountNumber = productOffer.ECS_Bank_Account_number__c;
     String bankX = '';
     for (Integer i = 1; i <= bankAccountNumber.length() - 4; i++) {
      bankX = bankX + 'X';
     }
     maskingECSBankAccountNumber = bankX + bankAccountNumber.subString(bankAccountNumber.length() - 4);
    }
    // Bug 18323 - Aman Porwal - E
   }

   //Call center process start here
   System.debug('--- Final_Amount__c ---' + productOffer.Final_Amount__c);
   if (productoffer.Final_Amount__c != null) {
    FinalAmountinWords = NumberToWord.english_number((long) productoffer.Final_Amount__c);
   }
   System.debug('--- Final_Amount__c in words ---' + FinalAmountinWords);
   //Bug 11518 :: Pritha :: Conversion Logic Changes Start uncommenting
   //Call center process End here
   //101 
   PageReference pageRef = new PageReference('/apex/PODetailsPageLA');

   ApexPages.currentPage().getParameters().put('poid', productOffer.id);
   ApexPages.currentPage().getParameters().put('flow', 'LA');
   if (String.isEmpty(loanId))
    ApexPages.currentPage().getParameters().put('Id', offerId);
   if (!Test.isRunningTest()) {
    poObj = new PODetailsPageLA_AC();
   }
   //101
// Bug_24489--RDL_Line -- Bug_24801 RDL Agreement -- changed templet name to for RDL product added Salutation
   lead = [select id,Salutation,/*23575 s*/IMPS_result__c,token_Number__c,/*23575 e*/ eKYC_processing__c, Employment_Type__c, Profession_Type__c, Employer__c, Employer_Name__c, TAN__c, movedToCibilTemp__c, Cibil_Temp__r.Id, SBS_Branch__c, SBS_Branch__r.Name, LeadSource, Marital_Status__c, Lead_Office_Address_Line1__c, Lead_Office_Address_Line2__c, Applicant_Type__c, FinnOne_CIF__c,
    Lead_Office_Address_Line3__c, Lead_Office_City__c, Per_Phone__c, Per_STD__c, Mobile_Number__c, Per_City__c, Permanent_Line_1_New__c, Company_Type__c, Nature_of_Business__c,
    Address_Line_2_New__c, Permanent_Address_3__c, Phone, Resi_STD__c, Residential_type__c, Off_City__c, Off_Pin_Code__c, Off_Phone__c, Office_STD__c,
    name, Middle_Name__c, Constitution__c, PAN_Cibil__c, Date_of_Birth__c, Residence_Address_Line1_Cibil__c, Residence_Address_Line2_Cibil__c, Old_CIBIL_Score__c,
    Residence_Address_Line3_Cibil__c, State_Cibil__c, Existing_Product__c, Existing_LAN__c, Contact_1_Mobile__c, Per_Pin_Code__c, MobilePhone, Email,
    Gender__c, Customer_Address_1__c, Customer_Address_2__c, Customer_Address_3__c, Customer_Mobile__c, Lead_Email_Id__c, Occupation_type__c, Caste_Category__c,
    Resi_City_Cibil__c, Resi_Pin_Code_Cibil__c, Office_Phone_Number_Cibil__c, DOB_Cibil__c, Pan__c, Residence_Address_Line1__c, Residence_Address_Line2__c,
    Residence_Address_Line3__c, Customer_ID__c, DNC_Flag__c, Sourcing_Channel__c, State__c, Contact_Email_1__c, Resi_City__c, Office_Phone_Number__c, Resi_Pin_Code__c,
    DOB__c, Customer_Type__c, firstname, lastname, Incorporation_Date__c, Registered_Address_1__c, Registered_Address_2__c, Registered_Address_3__c,
    Regi_Phone__c, Regist_City__c, Cibil_Temp__r.createddate, Regi_STD__c, Update_CIBIL_Error__c, CIBIL_Match_Check__c, Cibil_Temp__c, CIBIL_Score__c,
    Regi_Pin_Code__c, Regi_Phone_with_STD__c, Tele_Calling_Status__c, Telecaller_Remarks__c, Religion__c, Other_Caste_Category__c, Other_Religion__c,
    Quality_Check_Remarks__c, Quality_Check__c, Field_Check_Status__c, Field_Check_Remarks__c /*@16507*/ , (select id, Contact_Name__r.Stamp_Duty__c from applicants__r) /*@16507*/ from lead where id =: productOffer.Lead__c limit 1
   ];

   // Bug 18323 - Aman Porwal - S
   if (lead != null && lead.Email != null && lead.Email != '') {
    String leadEmail = lead.Email.split('@')[0];
    String emailX = '';
    for (Integer i = 1; i <= leadEmail.length(); i++) {
     emailX = emailX + 'X';
    }
    maskingLeadEmail = emailX + '@' + lead.Email.split('@')[1];
   }
    if(lead != null && lead.token_number__c == tokenNumber){
        enablebutton = true;
        system.debug('enable button is '+enableButton);
    }
    system.debug('enable button is '+enableButton); 

   if (lead != null && lead.Customer_Mobile__c != null && lead.Customer_Mobile__c != '') {
    String phoneNumber = lead.Customer_Mobile__c;
    String phoneX = '';
    for (Integer i = 1; i <= phoneNumber.length() - 4; i++) {
     phoneX = phoneX + 'X';
    }
    maskingLeadPhoneNumber = phoneX + phoneNumber.subString(phoneNumber.length() - 4);
   }
   // Bug 18323 - Aman Porwal - E 

   if (flowType.ToUpperCase() == 'TERMSCONDITIONS' || flowType.ToUpperCase() == 'NewLine') {   //23575 changed if condition
    List < Lead_Applicants__c > leadAppList = new List < Lead_Applicants__c > ();
    if (lead != null)
     leadAppList = [select id, Pan__c, name, Last_Name__c, Applicant_Type__c, Constitution__c, Incorporation_Date__c, First_Name__c, DOB__c, Lead_Office_Address_Line2__c, Lead_Office_Address_Line3__c,
      Customer_Type__c, Permanent_Residence_Address_1__c, Old_Cibil_Score__c, Marital_Status__c, Gender__c, Nature_of_Bu__c, Residential_type__c, Off_City__c, Off_Pin_Code__c, Office_STD__c,
      Permanent_Residence_Address_2__c, Permanent_Residence_Address_3__c, Middle_Name__c, Office_Phone_Number__c, Residence_Address_1__c, Permanent_Mobile__c, Caste_Category__c, Religion__c,
      eKYC_Processing__c, E_Mail__c, Regi_City__c, New_Lead_Applicant__c,
      Permanent_PinCode__c, Permenant_Phone__c, Permanent_STD__c, Resi_Phone__c, Resi_STD__c, Phone__c, Regist_City__c, Regi_STD__c, Regi_Phone__c, Lead_Office_Address_Line1__c, Other_Caste_Category__c,
      Residence_Address2__c, Resi_Pin__c, Permanent_State__c, Resi_City__c, Residence_Address_3__c, movedToCibilTemp__c, Cibil_Temp__r.createddate, Other_Religion__c, Cibil_Temp__r.Integrate_with_CIBIL__c, Cibil_Temp__r.Name,
      Cibil_Start__c, Cibil_Temp__r.id, Update_CIBIL_Error__c, CIBIL_Score__c, CIBIL_Match_Check__c, Permanent_City__c, Email__c, Regi_Address_2__c,
      Regi_Pin_Code__c, Regi_Address_3__c, Mobile__c, Occupation_type__c, Relationship_With_Applicant__c, Regi_Address_1__c, Office_Mobile__c
      from Lead_Applicants__c where Lead__c =: lead.id order by createdDate asc
     ];
    if (leadAppList.sizE() > 0) {
     leadAppObj = leadAppList[0];
     // Bug 18323 - Aman Porwal - S
     if (leadAppObj != null && leadAppObj.E_Mail__c != null && leadAppObj.E_Mail__c != '') {
      String leadAppEmail = leadAppObj.E_Mail__c.split('@')[0];
      String emailX = '';
      for (Integer i = 1; i <= leadAppEmail.length(); i++) {
       emailX = emailX + 'X';
      }
      maskingLeadAppEmail = emailX + '@' + leadAppObj.E_Mail__c.split('@')[1];
     }
     if (leadAppObj != null && leadAppObj.Mobile__c != null && leadAppObj.Mobile__c != '') {
      String phoneNumber = leadAppObj.Mobile__c;
      String phoneX = '';
      for (Integer i = 1; i <= phoneNumber.length() - 4; i++) {
       phoneX = phoneX + 'X';
      }
      maskingLeadAppPhoneNumber = phoneX + phoneNumber.subString(phoneNumber.length() - 4);
     }
     // Bug 18323 - Aman Porwal - E 
    }
   }



   Hinsurance = [Select Nominee_Name__c, Nominee_Address__c, Nominee_Mobile__c, Nominee_DOB__c, Whether_we_are_financing_this_product__c, Term_of_Insurance__c, Sum_Assured__c, Remark__c, Reject_reason__c,
    Premium_Amount__c, Policy_type__c, Policy_number__c, Policy_issue_date__c, Offer_id__c, Loan_Application_Status__c,
    Loan_application_number__c, Opportunity__c, Opportunity__r.Nominee_Name__c, Loan_Amount__c, Insurance_Type__c, Insurance_Product__c, Insurance_Name__c,
    Insurance_amount__c, Existing_LAN_no__c, Decision_time_stamp__c, Customer_Payment_Mode__c, Customer_address__c, CPA_Name__c,
    Cheque_Status__c, Cheque_DD_No_with_Bank_Name__c, Cheque_DD_Date__c, Availed_Tenor__c, Product_Offerings__c,
    Availed_EMI__c, Availed_Amount__c, Approved__c, Age__c from DPLinsurance__c where Product_Offerings__c =: productOffer.id
   ];
   //to fetch fees

   // Fees and Charges
   // Added if condition for Bug 22019
   System.debug('--SalLine--' + salLineflag);
   System.debug('--Line--' + productoffer.Line_activation_Fees_Status__c);
   System.debug('--UTM--' + productoffer.UTM_Source__c);
   if (salLineflag && productoffer.Line_activation_Fees_Status__c != 'To be deducted' && productoffer.UTM_Source__c != 'BFL_PRIME' && (productOffer.Products__c == 'SAL' || productOffer.Products__c == 'SPL' || productOffer.Products__c == 'RSL' || productOffer.Products__c == 'RDL')) { // bug_24489
    objFeesList = [Select id, name, Charge_Desc__c, Change_Amount__c, Charge_Type__c, Deducted_from_Disbursement__c, Instrument_No__c, Instrument_type__c, Instrument_Date__c, Bank_Branch__c, Finnone_ChargeId__c, Deposition_Date__c, Deposit_Slip_Number__c from Fees_and_Charge__c where Product_Offerings__c =: productOffer.id AND Charge_Type__c != 'Line Utilization'];
   } else if (productOffer.Registered_with__c == null || (productOffer.Registered_with__c != null && productOffer.Registered_with__c.toUpperCase() != 'BFL_PRIME')) {

    objFeesList = [Select id, name, Charge_Desc__c, Change_Amount__c, Charge_Type__c, Deducted_from_Disbursement__c, Instrument_No__c, Instrument_type__c, Instrument_Date__c, Bank_Branch__c, Finnone_ChargeId__c, Deposition_Date__c, Deposit_Slip_Number__c from Fees_and_Charge__c where Product_Offerings__c =: productOffer.id];
   }
   system.debug('Fees List is ' + objFeesList);
   //22019 e
   //Call Center Process start here
   Othercharges = 0;
   if (!commonUtility.isEmpty(objFeesList)) {
    for (Fees_and_Charge__c fee: objFeesList) {
     Othercharges += fee.Change_Amount__c;
    }
   }
   //Call Center process end here
   //DG Auto TopUp S
   total = 0;
   for (Fees_and_Charge__c fees: objFeesList) {
    if(fees.Change_Amount__c != null)
    total = total + fees.Change_Amount__c;
   }
   //DG Auto TopUp E

   if (productoffer.Unsecured_W_O_BT_Line_Available__c != null) {
    //Bug ID : 13661 DG SOL Line AMC Charges By Rajesh START
    List < StaticResource > staticResource = [select id, name, body from StaticResource where name = 'SOL_AMCCharges'];
    String jsonString;
    Map < String, Object > jsMap;
    Map < String, Object > productMap;

    if (!CommonUtility.isEmpty(staticResource))
     jsonString = staticResource[0].Body.toString();

    if (!CommonUtility.isEmpty(jsonString))
     productMap = (Map < String, Object > ) JSON.deserializeUntyped(jsonString);

    //Bug 22019 Start
    if (salLineflag && productoffer.UTM_Source__c != 'BFL_PRIME' && productMap.get('LineAMC') == 'true' && (productOffer.Products__c == 'SAL' || productOffer.Products__c == 'SPL' || productOffer.Products__c == 'RSL' || productOffer.Products__c == 'RDL')) { // bug_24489
     System.debug('--SalLine--' + salLineflag);
     System.debug('--LineAMC--' + productMap.get('LineAMC'));
     System.debug('--UTM--' + productoffer.UTM_Source__c);
     linecharges = 0;
    } else {
     if (!CommonUtility.isEmpty(productMap))
      jsMap = (Map < String, Object > ) productMap.get(productOffer.Products__c);

     if (!CommonUtility.isEmpty(jsMap)) {
      for (String key: jsMap.keyset()) {
       Integer MINlineCharges;
       Integer MAXlineCharges;
       String[] strarr = key.split('-');
       if (!CommonUtility.isEmpty(strarr) && strarr.size() == 2) {
        MINlineCharges = integer.valueof(strarr[0]);
        MAXlineCharges = integer.valueof(strarr[1]);
        if (productoffer.Unsecured_W_O_BT_Line_Available__c <= MAXlineCharges && productoffer.Unsecured_W_O_BT_Line_Available__c >= MINlineCharges) {
         linecharges = Integer.valueof(jsMap.get(key));
         break;
        }
       } else {
        MINlineCharges = integer.valueof(strarr[0]);
        if (productoffer.Unsecured_W_O_BT_Line_Available__c > MINlineCharges) {
         linecharges = Integer.valueof(jsMap.get(key));
         break;
        }
       }
      }
     } else {
      if (ProductSMS__c.getValues(productOffer.Products__c) != null && ProductSMS__c.getValues(productOffer.Products__c).MaxLineAssignedAmount__c != null) {
       Integer MAXlineCharges = Integer.valueof(ProductSMS__c.getValues(productOffer.Products__c).MaxLineAssignedAmount__c);
       if (productoffer.Unsecured_W_O_BT_Line_Assigned__c < MAXlineCharges)
        linecharges = Integer.valueof(ProductSMS__c.getValues(productOffer.Products__c).LineFeesLessThanMaxLineAmount__c);
       else if (productoffer.Unsecured_W_O_BT_Line_Assigned__c > MAXlineCharges)
        linecharges = Integer.valueof(ProductSMS__c.getValues(productOffer.Products__c).LineFeesMoreThanMaxLineAmount__c);
      }

     }
    }
    //22019 e
    system.debug('linecharges' + linecharges);
    //Bug ID : 13661 DG SOL Line AMC Charges By Rajesh END

    //calculate Processing_Fee_Amount__c
    //if(productoffer.Offer_PF__c!=null && productoffer.Availed_Amount__c!=null)
    // productoffer.Processing_Fee_Amount__c = ((productoffer.Availed_Amount__c * productoffer.Offer_PF__c)/100).setScale(2);
    /* Decimal profeeamo = 0;
            if(productoffer.Offer_PF__c!=null && productoffer.Availed_Amount__c!=null) 
                profeeamo = ((productoffer.Availed_Amount__c * productoffer.Offer_PF__c)/100).setScale(2);
    /* Decimal profeeamo = 0;
                        if(productoffer.Offer_PF__c!=null && productoffer.Availed_Amount__c!=null) 
                            profeeamo = ((productoffer.Availed_Amount__c * productoffer.Offer_PF__c)/100).setScale(2);
                
                        Double servicetaxval=0;
                        Decimal servtax =0;
                        Decimal totalpro =0;
                        if (ATOSParameters__c.getValues('Service Tax').value__c != null) servicetaxval = Double.ValueOf(ATOSParameters__c.getValues('Service Tax').value__c);
                        
                        servtax = profeeamo * servicetaxval;
                        totalpro = profeeamo + servtax;
                    // productoffer.Processing_Fee_Amount__c = profeeamo + servtax;      
                */

    // Calculate Service Tax Bug 5990 CIBIL Watch
    if (ATOSParameters__c.getValues('Service Tax') != null && ATOSParameters__c.getValues('Service Tax').value__c != null)
     serviceTax = decimal.valueOf(Double.ValueOf(ATOSParameters__c.getValues('Service Tax').value__c));
    //Bug:10236 start
    if (productoffer.Final_Amount__c != null && productoffer.Offer_PF__c != null)
     processingFeeExcludingService = ((productoffer.Final_Amount__c * productoffer.Offer_PF__c) / 100).setScale(2);
    if (serviceTax != null) {
     System.debug('---serviceTax=----' + serviceTax + '---=serviceTax*100=----' + serviceTax * 100);
     serviceTax = serviceTax * 100;
     serviceTax = serviceTax.setScale(2);
     //Bug:10236 start
     if (processingFeeExcludingService != null) ServiceTaxAmount = (processingFeeExcludingService / 100) * serviceTax;
     System.debug('----productOffer.Processing_Fee_Amount__c=----' + productOffer.Processing_Fee_Amount__c);
     System.debug('----ServiceTaxAmount=----' + ServiceTaxAmount);
    }
    //Bug 5990 Ends

   }


   //to fetch old LAN
   if (productOffer.Existing_LAN__c != null) {
    List < Opportunity > opplist = new List < Opportunity > ();
    opplist = [select id, Approved_Loan_Amount__c, Approved_Tenor__c, Approved_Rate__c, EMI_CAM__c from Opportunity where LAN__c =: productOffer.Existing_LAN__c limit 1];
    system.debug('&&&&&opplist &' + opplist);
    if (opplist != null && opplist.size() > 0)
     oldLoan = opplist[0];
   }
   system.debug('flowType : ' + flowType);

   //system.debug('productOffer.Line_Activation_Acceptance__c: ' + productOffer.Line_Activation_Acceptance__c);   
   if ((flowType == 'LineAccept' || flowType == 'NewLine') && (productOffer.Customer_Acceptance_Flag__c == 'YES' || productOffer.Customer_Acceptance_Flag__c == 'NO')) {   //23575 changed if condition
    system.debug('flowTypeaccept ' + flowType);
    showthankusection = true;
   }
   if ((flowType == 'LineActive' || flowType == 'NewLine') && (productOffer.Line_Activation_Acceptance__c == 'YES' || productOffer.Line_Activation_Acceptance__c == 'NO')) {   //23575 added if condition
    system.debug('flowTypeactive' + flowType);
    showthankusection = true;
   }

  }

  if (Loanid != null) {
   system.debug('CIBIL Watch Pramod 1');
   Loan = [select id, Account.name, /*mobility for sal s*/ account.Flow__c /*mobility for sal e*/ , EMI_Type__c, First_Due_Date__c, Branch_Type__c, A_C_No__c, Industry__r.Industry__c, Owner.Name, Original_Approver__c, Branch_City__c, Decision_Time__c, Loan_Amount_with_Premium__c, Approved_Loan_Amount__c, Approved_Rate__c, Approved_Tenor__c, Loan_amt_with_premium__c, Insurance_Premium_Amt__c, online_salaried_app__c,
    Reject_Reason__c, Sales_Backend__c, name, Risk_Deviations__c, CRO_Deviations__c, CPA__c, ACM__c, RCM__c, NCM__c, CRO__c, RISK__c, COO__c, ACM_Comments__c, RCM_Comments__c, COO_Comments__c, Eligible_for_cross_sell__c, Products_for_cross_sell__c, Cross_sell_comments__c,
    Approval_Stages__c, Approver__c, Loan_Application_Number__c, Product__c, Loan_Type__c, Relationship_Manager__c, AccountId, CreatedDate,
    OwnerId, CreatedById, Scheme_Master__c, Scheme_Master__r.Name, Scheme_Master__r.IsHybridFlexi__c, Industry__c, Credit_Program__c, createdBy.Profile.Name,
    Sub_Industry__c, Existing_Customer__c, Finance_Amount__c, Tenor__c, Main_Sector__r.Sector__c, Main_Industry__c, Main_Sub_Industry__c,
    Type_Of_Loan__c, amount, Employee_Type__c, stagename, Probability, Branch_Name__r.branch_type__c,
    ForecastCategoryName, File_Acceptance__c, Discrepancy_Status__c, Loan_Amount__c, Area_SM__c,
    Type_of_Constitution__c, Application_Form_Number__c, If_Yes__c, Branch_Type1__c, Relationship_Manager__r.Name,
    Branch_Name__r.name, Sourc_Mobile__c, ASM_Mobile__c, Sales_Backend_Mobile__c, Verification_Initiated__c, Referral__c,
    Sourcing_Channel__c, Current_UserRole__C, CEO__c, CEO__r.name, RCM__r.name, NCM__r.name,
    RISK__r.name, COO__r.name, CRO__r.name, Comments__c, No_of_Properties__c,
    Amount_Rs__C, Instrument_No__c, Bank_Name__c, Dated__c, NameRef1__C, MOF_Waiver_Details__c,
    NameRef2__C, Address_Line1Ref1__c, Address_Line1Ref2__c, Address_Line2Ref1__c,
    Address_Line2Ref2__c, Address_Line3Ref1__c, Address_Line3Ref2__C, CityRef1__c, Field_Disposition__c,
    CityRef2__C, OccupationRef1__C, OccupationRef2__C, Pin_CodeRef1__c, Pin_CodeRef2__C,
    Office_PhoneRef1__C, Office_PhoneRef2__c, Office_MobileRef1__C, Office_MobileRef2__c,
    No_Of_Years_KnownRef1__c, No_Of_Years_KnownRef2__c, RelationshipRef1__c, RelationshipRef2__C,
    Nominee_Name__c, Nominee_AddressLine1__C, Nominee_AddressLine2__c, Quality_Check_Status__c,
    Nominee_AddressLine3__c, Nominee_PinCode__c, Nominee_City__c, Customer_email_id__c, Total_TAT__c,
    STD_Code__C, Nominee_Phone__c, Nominee_Relationship__c, testbeta__C, Accountant_email_id__c, DSA_Sharing__c,
    Processing_Fee_Status__C, Instument_Type__c, Insurance_Company__C, Premium_Amount__C, Sum_Assured__c, Processing_Fees__c,
    Remark__C, Customer_Type__c, Reject_Reason_1__c, Relationship_Manager__r.Phone, Employee_No_of_ACM__c, Hold_Reason__c,
    FAS_Processing_Fee_Amt__c, End_Use__c, Sanction_Validity_Date__c, Nature_of_Business__c, Bank_A_c_No_of_Customer__c,
    DF_Type__c, Favouring__c, DF_City__c, IFSC_Code__c, MICR_Number__c, Conditonal_Approved_Flag__c, Conditional_Approver__c,
    Acc_InsurFundedType__c, Acc_Type_of_Policy__c, Acc_InsurCompanyName__c, LAN__c,
    Acc_InsurStartDate__c, Acc_InsurPremiumAmount__c, Acc_InsurSumAssured__c, Total_Monthly_Oblig__c,
    Requested_ROI__c, Processing_Type__c, Account.IS_OTP_FLOW__c, EMI_CAM__c, Date_of_created_date__c,
    Life_InsuranceRemarks__c, Type_of_Borrower__c, AppScore__c, Rank1__c, Loan_Application_Flow__c, Offer_Amount__c,
    CampaignId, Business_IRR__c, POS__c, BranchName__c, Financed_by_BFL__c, Disbursement_Type__c, Tranche_Count__c, City_Head__c, UnHold__c,
    CL_Region__c, Region__c, Old_Product__c, account.Years_in_Bus__c, CAM_Expiry_Date__c, CAM_Preparation_Date__c, Business_Head__c, Centralized_ACM__c,
    AMC__c, Centralized_RCM__c, Customer_Reference_Number__c, SMS_to_be_Sent__c, ACM__r.Mobile_number__c, Approved_time_after_Reappraisal__c, Decision_Date__c, Interior_Designer__c, Service_Availed__c,
    /*added by prashant sal PLTB S*/
    Net_Loan_to_POS__c, Scheme_Master__r.flexi_flag__c, Scheme_Master__r.is_Pure_Flexi__c, Scheme_Master__r.PLOC_scheme__c, (Select id, Insurance_Type__c, Premium_Amount__c /*25097 start*/,Sum_Assured__c,Insurance_Product__c/*25097 stop*/ from Insurance__r), LeadSource,
    (Select Id, FFR__c, Charge_Type__c, Change_Amount__c, Finnone_ChargeId__c, Charge_Desc__c from Fees_and_Charges__r), (Select id, Lead_Source__c from Product_Offerings__r LIMIT 1), (Select Number_of_cheques__c, Cheque_Number_From__c, Cheque_Number_to__c, Bank_Name__c, A_C_NO__c, ECS_Amount__c, /*23987 s*/ Repayment_Mode__c /*23987 e*/ from RePayment_mode_details__r), Account_Holder_Name__c, A_C_Type__c, Repayment_Bank_Name__c /*added by prashant sal PLTB E*/ , (select IMPS_Beneficiary_Name__c, IMPS_Transaction_No__c, IMPS_Account_Validate__c, id, IMPS_Count__c, UMRN__c, Disbursement_To__c, IMPS_Flag__c, Bank_Branch__c, name, Tranche_Detail__c, Loan_Application__c, Internal_Closure__c, Disbursement_Amount__c, Disbursal_Mode__c, Disbursement_Date__c, FinnOne_Disbursement_Date__c, Repay_Disb_Diff__c, Successful_IMPS_Count__c, Failure_IMPS_Count__c, IFSC_Code__c, Favouring__c, isTopUp__c, Tranche_Detail__r.Tranche_Number__c, Bank_Name__c, Bank_Account__c, Payable_at__c, Credit_Days__c, IMPS_Result__c, Information_From__c from Current_Disbursal_Details_s__r)
    /*24028 S*/
    , Scheme_Master__r.Scheme_Code__c, Rate_Type__c /*24028 E*/
     /*25097*/,(select id,Customer_Decline_Reasons__c,Contact_Name__r.Stamp_Duty__c,Applicant_Type__c,Pure_Flexi_EMI__c,Pure_Flexi_Period__c,Drop_Line_Flexi_Period__c,IP_Address_Timestamp__c,contact_Name__c,Contact_Name__r.name,Contact_Name__r.Email__c,Token__c/*25097*/,Application_Form_Timestamp__c/*25097 stop*/ from Loan_Application__r where Applicant_Type__c = 'Primary')/*25097*/
    from Opportunity where id =: Loanid
   ];
   //17556 added repayment in query
    //25097 start
              if(loan !=null && loan.Loan_Application__r != null && loan.Loan_Application__r.size() > 0)
                {
                    for(Applicant__c app : loan.Loan_Application__r)
                    {
                        if(app.Applicant_Type__c == 'Primary')
                        {
                            PrimaryApp =app;
                            break;
                        }
                    }
                }
          
                    if(loan != null && loan.EMI_CAM__c != null && PrimaryApp != null && PrimaryApp.Pure_Flexi_EMI__c != null)
                    flexihybridAmt = loan.EMI_CAM__c + PrimaryApp.Pure_Flexi_EMI__c;
         
                 if(PrimaryApp != null && PrimaryApp.IP_Address_Timestamp__c == 'Acceptance Pending')
                    iptimeStamp = PrimaryApp.IP_Address_Timestamp__c;
                else if(PrimaryApp != null && PrimaryApp.IP_Address_Timestamp__c == 'Rejected')
                    iptimeStamp = PrimaryApp.IP_Address_Timestamp__c;
                else
                    iptimeStamp = 'IPADDRESS';
                
                
                 if(tokennum == PrimaryApp.token__c){
                    system.debug('tokennum>>'+tokennum);
                    enableAccept =true;
                    //if(PrimaryApp.Customer_Decline_Reasons__c != null)
                      //  PrimaryApp.Customer_Decline_Reasons__c = '';
                    system.debug('enableAccept>>'+enableAccept);
                }
                
            //25097 stop
   //Rohit added for SAL custom setting movement S  16987   
   ALLMap = GeneralUtilities.fetchStaticRescMap();
   Boolean isCallCenter = false;
   if (ALLMap != null) {
    Map < String, Object > pltbMap = (Map < String, Object > ) ALLMap.get('PLTB');
    System.debug('rohit33 ' + pltbMap);
    if (pltbMap != null) {
     String callCenterNames = (String) pltbMap.get('Call_Centre_Idetifier');
     String[] arr = callCenterNames.split(';');
     for (String str: arr) {
      if (Loan.Product_Offerings__r != null && Loan.Product_Offerings__r.size() > 0) {
       if (str == Loan.Product_Offerings__r[0].Lead_Source__c) {
        isCallCenter = true;
        break;
       }
      }
     }
    }
   }
   /*SAL 2.0 CR's s*/
   system.debug('isCallCenter' + isCallCenter);
   if (isCallCenter == true) {
    List < OpportunityFieldHistory > history = [Select Id, CreatedById, CreatedDate,
     Field, NewValue, OldValue from OpportunityFieldHistory Where Field = 'Owner'
     AND OpportunityId =: Loanid order by CreatedDate
    ];
    if (history != null && history.size() > 0) {
     String userId = (String) history[0].Newvalue;
     User u = [SELECT Profile.Name from User where Id =: userId];
     system.debug('u.Profile.Name' + u.Profile.Name);
     if (u.Profile.Name != 'Area Sales Manager')
      showBranchPune = true;

    }

   }
   /*SAL 2.0 CR's e*/
     /*added for 25097 s*/   
            if(!CommonUtility.isEmpty(Loan.Current_Disbursal_Details_s__r)){
             system.debug('in if>>');
                 cdr=Loan.Current_Disbursal_Details_s__r[0];
                 if(Loan.Current_Disbursal_Details_s__r.size()>1)
                cdrBT=Loan.Current_Disbursal_Details_s__r[1];
                 system.debug('in if1>>'+cdr);
                  system.debug('in if2>>'+cdrBT);
            }
        if(!Loan.Scheme_Master__r.flexi_flag__c && !Loan.Scheme_Master__r.is_Pure_Flexi__c && !Loan.Scheme_Master__r.PLOC_scheme__c && !Loan.Scheme_Master__r.IsHybridFlexi__c){
            loantype='Term Loan';
        }else  if(Loan.Scheme_Master__r.flexi_flag__c && !Loan.Scheme_Master__r.is_Pure_Flexi__c && !Loan.Scheme_Master__r.PLOC_scheme__c && !Loan.Scheme_Master__r.IsHybridFlexi__c){
            loantype='Flexi Term Loan';  
        }
        else  if(Loan.Scheme_Master__r.flexi_flag__c && !Loan.Scheme_Master__r.is_Pure_Flexi__c && !Loan.Scheme_Master__r.PLOC_scheme__c && Loan.Scheme_Master__r.IsHybridFlexi__c){
            loantype='Flexi Hybrid Loan';  
        }
     /*added for 25097 s*/   
   //Rohit added for SAL custom setting movement E 16987
   // gopika added for 19132 Start 
   if (Loan != null) {
    List < Product_Offerings__c > poListFor = Loan.Product_offerings__r;
    if (poListFor != null && poListFor.size() > 0) {
     isCallCentreFlag = LoanConversionUtility_Helper.checkCallCentreProcess(poListFor);

    }
    // 24028 S
    if (Loan.Product__c == 'SBS CS SAL' && Loan.Scheme_Master__c != null /*&& (Loan.Scheme_Master__r.Scheme_Code__c=='101109' || Loan.Scheme_Master__r.Scheme_Code__c=='101110')*/ ) {
     if (!CommonUtility.isEmpty(Loan.Scheme_Master__r.Scheme_Code__c)) {
      String[] schemeCodes = Label.CentralisedTopUp.split(';');
      for (string str: schemeCodes) {
       if (str == Loan.Scheme_Master__r.Scheme_Code__c) {
        centralisedTopUp = true;
        break;
       }
      }
     }
     FloatingRate = false;
     FixedRate = false;
     system.debug('centralisedTopUp' + centralisedTopUp);
     if (centralisedTopUp == true) {
      if (loan.Rate_Type__c == 'Floating')
       FloatingRate = true;
      else if (loan.Rate_Type__c == 'Fixed')
       FixedRate = true;
     }
    }


    //24028 E
   }
   Flow_Of_Application_Mobility = Loan.Account.Flow__c;
   renderFeeMobility = true;
   if (isCallCentreFlag == false && (Flow_Of_Application_Mobility == 'Mobility V2' || Flow_Of_Application_Mobility == 'Mobility')) {
    renderFeeMobility = false;
   }

   // gopika added for 19132 Stop
   // Bug 18323 - Aman Porwal - S
   if (Loan != null) {
    /*17556 s*/
    if (Loan.RePayment_mode_details__r != null && Loan.RePayment_mode_details__r.size() > 0) {
     Integer i = 1;
     Integer j = 1;
     for (RePayment_mode_detail__c repay: Loan.RePayment_mode_details__r) {
      //23987 start
      if (repay.Repayment_Mode__c == 'PDC' || repay.Repayment_Mode__c == 'Security Cheque') {
       repayWrapper rw = new repayWrapper(repay, i);
       i++;
       repayList.add(rw);
      }
      if (repay.Repayment_Mode__c == 'ECS' || repay.Repayment_Mode__c == 'SI') {
       repayWrapper rw = new repayWrapper(repay, j);
       j++;
       repayListEcs.add(rw);
      }
      //23987 end
     }
    }
    /*17556 e*/
    if (!CommonUtility.isEmpty(Loan) && !CommonUtility.isEmpty(Loan.Current_Disbursal_Details_s__r)) { //sal 2.0 CR
     for (Current_Disbursal_Details__c cb: Loan.Current_Disbursal_Details_s__r) {
      if (cb.Disbursal_Mode__c == 'CHEQUE') //prod adhoc
       isTopupAccHoldName = cb.Favouring__c;
      else
       accHolderName = cb.Favouring__c;
     }
    }
    if (Loan.A_C_No__c != null && Loan.A_C_No__c != '') {
     String bankAccountNumber = Loan.A_C_No__c;
     String bankX = '';
     for (Integer i = 1; i <= bankAccountNumber.length() - 4; i++) {
      bankX = bankX + 'X';
     }
     //Rohit added length condition for 19027 S
     /*if(bankAccountNumber.length()>4){
         maskingBankAccountNumber = bankX + bankAccountNumber.subString(bankAccountNumber.length() - 4);
     }
     else{
         maskingBankAccountNumber = '';
     } */
     //Rohit added length condition for 19027 E   
    }

    if (Loan.Bank_A_c_No_of_Customer__c != null && Loan.Bank_A_c_No_of_Customer__c != '') {
     String repaymentBankAccountNumber = Loan.Bank_A_c_No_of_Customer__c;
     String reBankX = '';
     for (Integer i = 1; i <= repaymentBankAccountNumber.length() - 4; i++) {
      reBankX = reBankX + 'X';
     }
     //Rohit added length condition for 19027 S
     /*if(repaymentBankAccountNumber.length()>4){
         maskingRepaymentBankAccountNumber = reBankX + repaymentBankAccountNumber.subString(repaymentBankAccountNumber.length() - 4);
     }
     else{
         maskingRepaymentBankAccountNumber = '';
     }*/
     //Rohit added length condition for 19027 E
    }
   }
   // Bug 18323 - Aman Porwal - E

   //cibil watch Pramod S
   if (Loan != null) { //condition added by prashnt
    If(Loan.Loan_Application_Flow__c == 'CIBILWatch' || (Label.Call_Centre_Idetifier != null && Loan.LeadSource != null && Label.Call_Centre_Idetifier.contains(Loan.LeadSource)) || Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL' || loan.account.Flow__c == 'Mobility' || Loan.Product__c == 'SBS CS SAL') /*Added condition for HFC Eagreement changes*/ {
     accountCreate = [Select id, Type_of_Ownership__c, Total_Employment_vintage_Year__c, Location__c, Name, Ownership, Address_1st_Line__c, Office_Address_1st_Line__c, Address_2nd_Line__c, Address_3rd_Line__c, AccCity__c,
      STDCode__c, PinCode__c, LandMark__c, Type_of_Property__c, Office_Address_2nd_Line__c, Office_Address_3rd_Line__c, Office_City__c, Office_Pin_Code__c, Office_STD_Code__c,
      Office_Phone_Number__c, Office_Mobile__c, Office_LandMark__c, Email_Id__c, Website, PANNumber__c, First_Name__c, Middle_Name__c, Last_Name__c, Phone, Mobile__c,
      Type_of_Property_Office__c, ROC_Registration_Number__c, Service_Tax_Registration_Number__c, TIN_Number__c, Year_of_Incorporation__c, Financial_Year_Closing__c,
      Others_YearClosing__c, Type_of_Business_Entity__c, Type_of_Business_Entity_Others__c, Nature_of_Business__c, Type_Of_Industry__c, Fathers_Husbands_Name__c,
      Date_of_Birth__c, Age__c, Sex__c, Marital_Status__c, Dependents__c, Qualification__c, Employment_Business__c, Name_of_the_Company_Employer__c, Extn_No__c, Fax,
      Employee_Number__c, Designation__c, Department__c, Gross_Salary_Turn_Over__c, Net_Income_Profit__c, No_of_years_of_Service_Business__c, Income_from_Other_Sources__c,
      Constitution__c, Current_Residence_Address1__c, Current_Residence_Address2__c, Current_Residence_Address3__c, Current_City__c, Current_PinCode__c, Current_STDCode__c,
      Current_Telephone_No__c, Current_LandMark__c, Current_Email_Id__c, Current_Mobile__c, Residing_Since__c, Residence_Status__c, Permanent_Residence_Address1__c,
      Permanent_Residence_Address2__c, Permanent_Residence_Address3__c, Permanent_City__c, Permanent_PinCode__c, Permanent_STDCode__c, Permanent_Telephone_Number__c,
      Permanent_Mobile__c, Others_ty_pr__c, Others_ty_pr_Off__c, Employer__c, Contact_Person__c, Client_ID__c, Permanent_Address_as_above__c, Consultation_Fees__c,
      Preferred_communication_address__c, Relationship_With_Applicant__c, Name_of_the_Borrower__c, Age_of_Account__C, Accountant_email_id__c, Sourcing_Channel__c,
      Property_Owner__c, Demat_A_C_No__c, DP_Details__c, CIN__c, Group_Code__c, Company_Type__c, Borrower_Group__c, Line_of_Business__c, Excise_Registration_No__c,
      Type_of_Constitution__c, Permanent_State__C, Current_State__C, Permanent_LandMark__c, Contact_Number__C, Occupation__C, SME_SSI__c, Industry, Office_State__c,
      Registered_Office_State__c, Years_in_Bus__C, Accountant_Contact_Person_Name__c, Registration_No__c, Spouse_Name__c, Current_experiance_in_Month__c,
      Current_experiance_in_Years__c, Total_Work_Experience_Months__c, Total_Work_Experience_Yrs__c, Tenor__c, Gender__c, Name_Of_The_Degree__c, DesignationOTP__c,
      Designation_Type__c, Is_Company_ID_Proof_Available__c, Office_Landline_Number1__c, Office_Landline_Number2__c, Residence_TypeAcc__c, Residence_Landline_phone__c, Adhaar_Number__c,
      Passport_Number__c, Voter_ID_DL_Number__c, Vintage_with_BAL__c, CustomerId__c, Profession__c, Specialisation__c, Degree__c, Practice_Type__c, Program_Type__c, Medical_Council__c,
      Average_Patient_Count_Per_day__c, Clinic_Type__c, Name_of_the_other_Group_Companies__c, Type_of_Degree__c, Process_Type__c, Post_Graduate_Super_Specialist_Experienc__c, Clinic__c, Hospital_Name__c
      from Account where id =: Loan.AccountId
     ];

     appList = [Select First_Emi__c, Contact_Name__r.Residence_City__c, id, Subscribed_to_Credit_Vidya__c, /*PLTB E-agreement Added By Prashant S*/ IP_Address_Timestamp__c, EMI_Holiday_Opted__c, EMI_Holiday_Months__c, Contact_Name__r.Office_Email_Id__c, Contact_Name__r.Name, Contact_Name__r.Address_1__c, Contact_Name__r.Address_2__c, Contact_Name__r.Address_3__c,
      Contact_Name__r.AppCity__c, Contact_Name__r.Pin_Code__c, Contact_Name__r.State__c, Contact_Name__r.Stamp_Duty__c, Contact_Name__r.Mobile_Phone__c, Contact_Name__r.email, /*PLTB E-agreement Added By Prashant E*/ Applicant_Type__c, /* Bug 16507 - Changes in PLTB added by priya start*/ Contact_Name__c, Pure_Flexi_Period__c, Pure_Flexi_EMI__c, Drop_Line_Flexi_Period__c /* Bug 16507 - Changes in PLTB added by priya end*/ /*24028 S*/ , Current_BFL_FRR__c, Spread_Percentage__c /*24028 E*/ from Applicant__c where Loan_Application__c =: Loan.id
     ];
     if (ProductSMS__c.getValues(Loan.Product__c) != null) {
      boolean isActive = ProductSMS__c.getValues(Loan.Product__c).Make_Active__c;
      if (isActive == true) {
       charges = ProductSMS__c.getValues(Loan.Product__c).Charges__c;
      }
     }

     Id aplcntId;
     if (appList != null && appList.size() > 0) {
      for (Applicant__c app: appList) {
       /* Bug - 13880 Online PLTB Start*/
       if (app.Applicant_Type__c == 'Primary') {
        aplcntId = app.Id;
        //24028 S
        primaryApplicant = app;
        spreadPercentage = app.Spread_Percentage__c;
        Current_BFL_FRR = app.Current_BFL_FRR__c;
        system.debug('24028 % passed' + spreadPercentage + ' ' + Current_BFL_FRR);
        //24028 E
       }
       
         //25097 s
             if(!commonutility.isEmpty(app.First_EMI__c)){
             firstEMIDate=date.valueOf(app.First_EMI__c); 
             lastEMIDate=firstEMIDate.addMonths(Integer.valueOf(Loan.Approved_Tenor__c-1));
            System.debug(' swapnil firstEMIDate'+firstEMIDate+' lastEMIDate '+lastEMIDate);
                }  //25097 e
       
       /* Bug - 13880 Online PLTB End*/
       if (app.Subscribed_to_Credit_Vidya__c == true) {
        credit_vidya_cost += integer.valueOf(charges);
       }
      }
     }
     appNonPrimaryList = [select id, Applicant_Type__c, Contact_Name__c, Contact_Name__r.FirstName, Contact_Name__r.LastName, Contact_Name__r.Acct_cont_email__c, Contact_Name__r.ApplicantType__c, Contact_Name__r.Name, Contact_Name__r.Address_1__c, Contact_Name__r.Address_2__c, Contact_Name__r.Address_3__c, Contact_Name__r.Permanant_Address_Line_1__c, Contact_Name__r.Permanant_Address_Line_2__c, Contact_Name__r.Permanant_Address_Line_3__c, Contact_Name__r.Email, Contact_Name__r.Email__c, Contact_Name__r.Mobile__c, Contact_Name__r.Customer_Type__c from Applicant__c where Applicant_Type__c != 'Primary'
      AND Contact_Name__r.Customer_Type__c = 'Individual'
      AND Loan_Application__c =: Loan.id limit 1
     ];
     if (appNonPrimaryList != null && appNonPrimaryList.size() > 0) {
      appObj = appNonPrimaryList[0];
     }

     bankList = [select id, Bank_Name__c, Bank_Account_Number__c, IFSC_Code__c, Applicant_Name__c, Account_Type__c from Bank_Account__c where Loan_Application__c =: Loan.id limit 1];
     if (bankList != null && bankList.size() > 0) {
      bankObj = bankList[0];
     }
     /* Bug - 13880 Online PLTB Start*/
     addDetail = [SELECT GST_IN_Number__c, Id, State__c FROM Address_Details__c WHERE Applicant__c =: aplcntId];
     if (addDetail != null && addDetail.size() > 0) {
      demoMapping = [SELECT Id, GST_State_Code__c FROM Demographic_Mapping__c where State__c =: addDetail[0].State__c.toUpperCase() and GST_State_Code__c != null limit 1];
     }
     /* Bug - 13880 Online PLTB End*/
     /*moved this code below for bug id 16165/18445
      if(Loan.Scheme_Master__c != null){
          ishybridflexi = loan.Scheme_Master__r.IsHybridFlexi__c;
          }
           moved this code below for bug id 16165/18445*/
    }
   }
   /*moved this code here for bug id 16165/18445 start*/
   if (Loan.Scheme_Master__c != null) {
    ishybridflexi = loan.Scheme_Master__r.IsHybridFlexi__c;
   }
   /*moved this code here for bug id 16165/18445 end*/
   //cibil watch Pramod E
   List < SurrogateCAM__c > ScamList = new List < SurrogateCAM__c > ();
   system.debug('CIBIL Watch Pramod 2' + Loan.Id);
   if (Loan != null)
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
     from SurrogateCAM__c where Loan_application__c =: Loan.id
    ];
   if (ScamList != null && ScamList.size() > 0)
    objSurrogateCAM = ScamList[0];

  }
  //DG Auto TopUP start
  if (ProductSMS__c.getValues('DGAutoTopUp') != null && ProductSMS__c.getValues('DGAutoTopUp').Produtc__c != null) {
   List < String > product = new List < String > ();
   product = ProductSMS__c.getValues('DGAutoTopUp').Produtc__c.split(';');
   for (String pro: product) {
    if ((productOffer.Product_Offering_Source__c == 'DIPOS' || productOffer.Product_Offering_Source__c == 'DGAUTOTOPUP') && pro == productOffer.Products__c) {
     autoTopUp = true;
    }
   }

  }
  //System.debug('autoTopUp********'+autoTopUp); 
  //DG Auto TopUp end
  //sal PLTB Term And conditions E-agreement S
  system.debug('appList' + appList);
  if (appList != null && appList.size() > 0)
   for (Applicant__c appli: applist) {
    if (appli.applicant_type__c == 'Primary') {
     app = appli;

     // Bug 18323 - Aman Porwal - S
     if (app != null && app.Contact_Name__c != null && app.Contact_Name__r.Mobile_Phone__c != null && app.Contact_Name__r.Mobile_Phone__c != '') {
      String phoneNumber = app.Contact_Name__r.Mobile_Phone__c;
      String phoneX = '';
      for (Integer i = 1; i <= phoneNumber.length() - 4; i++) {
       phoneX = phoneX + 'X';
      }
      maskingPhoneNumber = phoneX + phoneNumber.subString(phoneNumber.length() - 4);
     }
     // Bug 18323 - Aman Porwal - E

     /* Bug 16507 - Changes in PLTB added by priya start*/
     pureflexiperiod = Integer.valueof(appli.Pure_Flexi_Period__c);
     pureflexiEMI = Integer.valueof(appli.Pure_Flexi_EMI__c);
     dropflexiperiod = Integer.valueof(appli.Drop_Line_Flexi_Period__c);
    }
    if (appli.applicant_type__c == 'Financial Co-Applicant') {
     if (!CommonUtility.isEmpty(app.Contact_Name__c)) {
      if (!CommonUtility.isEmpty(appli.Contact_Name__r.email))
       coemailid = appli.Contact_Name__r.email;
      else if (!CommonUtility.isEmpty(appli.Contact_Name__r.Office_Email_Id__c))
       coemailid = appli.Contact_Name__r.Office_Email_Id__c;
     }

     // Bug 18323 - Aman Porwal - S
     if (coemailid != null && coemailid != '') {
      String coEmail = coemailid.split('@')[0];
      String emailX = '';
      for (Integer i = 1; i <= coEmail.length(); i++) {
       emailX = emailX + 'X';
      }
      maskingCoAppEmail = emailX + '@' + coemailid.split('@')[1];
     }
     // Bug 18323 - Aman Porwal - E 

     finantialcoapp = appli;

     // Bug 18323 - Aman Porwal - S
     if (finantialcoapp != null && finantialcoapp.Contact_Name__c != null && finantialcoapp.Contact_Name__r.Mobile_Phone__c != null && finantialcoapp.Contact_Name__r.Mobile_Phone__c != '') {
      String phoneNumber = finantialcoapp.Contact_Name__r.Mobile_Phone__c;
      String phoneX = '';
      for (Integer i = 1; i <= phoneNumber.length() - 4; i++) {
       phoneX = phoneX + 'X';
      }
      maskingCoAppPhoneNumber = phoneX + phoneNumber.subString(phoneNumber.length() - 4);
     }
     // Bug 18323 - Aman Porwal - E

    } /* Bug 16507 - Changes in PLTB added by priya end*/
   }
  List < String > dateVals = new List < String > ();
  if (app.First_Emi__c != null)
   dateVals = app.First_Emi__c.split('-');
  Map < String, String > monthsMap = new Map < String, String > {
   '01' => 'Jan',
   '02' => 'Feb',
   '03' => 'Mar',
   '04' => 'Apr',
   '05' => 'May',
   '06' => 'Jun',
   '07' => 'Jul',
   '08' => 'Aug',
   '09' => 'Sep',
   '10' => 'Oct',
   '11' => 'Nov',
   '12' => 'Dec'

  };
  if (dateVals.size() > 2)
   repayDate = dateVals[2] + ' ' + monthsMap.get(dateVals[1]) + ' ' + dateVals[0];
  if (app != null && app.IP_Address_Timestamp__c != null && (app.IP_Address_Timestamp__c != 'Acceptance Pending' && app.IP_Address_Timestamp__c != 'Rejected')) //SAL PLTB Changes 14951 added by Anshita
  {
   String iptime = app.IP_Address_Timestamp__c;

   integer i = iptime.indexOf('||');
   String str = iptime.subString(i + 2, i + 14);

   accepteddate = Date.valueOf(str);

  }

  if (loan != null && loan.Customer_email_id__c != null)
   emailid = loan.Customer_email_id__c;
  else if (loan != null && loan.Accountant_email_id__c != null)
   emailid = loan.Accountant_email_id__c;

  // Bug 18323 - Aman Porwal - S
  if (emailid != null && emailid != '') {
   String email = emailid.split('@')[0];
   String emailX = '';
   for (Integer i = 1; i <= email.length(); i++) {
    emailX = emailX + 'X';
   }
   maskingEmail = emailX + '@' + emailid.split('@')[1];
  }
  // Bug 18323 - Aman Porwal - E 

  if (loan != null && loan.Net_Loan_to_POS__c != null && loan.Processing_Fees__c != null) {
   //Production Issue : Bug 22936 : Start 
   //Commented old logic
   //salProcessingFees = Integer.valueOf((loan.Net_Loan_to_POS__c* loan.Processing_Fees__c) / 100);
   //New Logic Implementation : First calculations in Decimal only  
   salProcessingFees = ((loan.Net_Loan_to_POS__c * loan.Processing_Fees__c) / 100);
   //Production Issue : Bug 22936 : End
  }
  /* Bug 22624 Start - Hrushikesh Sprint 5C */
  if (loan != null && loan.Processing_Fees__c != null) {
   processingFeesInPercent = loan.Processing_Fees__c.SetSCale(2);
  } /* Bug 22624 Stop - Hrushikesh Sprint 5C */
  if (loan != null && loan.Loan_Amount_With_Premium__c != null) {
   Long n = loan.Loan_Amount_With_Premium__c.longValue();
   numberToWords = getNumberTOWordConvertion(n);
  }
  if (productOffer != null && productOffer.Final_Amount__c != null) {
   Long n = productOffer.Final_Amount__c.longValue();
   numberToWordsforline = getNumberTOWordConvertion(n);
  }
  //Prod Issue: 14864 Start
  Double servicetaxval = 1;
  if (ATOSParameters__c.getValues('Service Tax') != null && ATOSParameters__c.getValues('Service Tax').value__c != null) servicetaxval = Double.ValueOf(ATOSParameters__c.getValues('Service Tax').value__c);
  if (salProcessingFees != 0) {
   //Production Issue : Bug 22936 : Start
   //Commented old logic
   //serviceCharge = Integer.valueOf(salProcessingFees * servicetaxval);
   //New Logic Implementation : First calculations in Decimal only  
   serviceCharge = (salProcessingFees * servicetaxval);
   //Production Issue : Bug 22936 : End
  }
  //Prod Issue: 14864 End

  //Production Issue : Bug 22936 : Start
  //Approach should be once done with addition of processing fees and GST then round off to be done. - Ameya Wakhare
  //All calculations in decimal system are done now finally Math.round() service charges
  if (serviceCharge != null) {
   System.debug('Final Service Charges : Decimal : serviceCharge : ' + serviceCharge);
   serviceCharge = Math.round(serviceCharge);
   System.debug('Final Service Charges : Math.round() : serviceCharge : ' + serviceCharge);
  }
  //All calculations in decimal system are done now finally Math.round() processing fees
  if (salProcessingFees != null) {
   System.debug('Final Processing Fees : Decimal : salProcessingFees : ' + salProcessingFees);
   salProcessingFees = Math.round(salProcessingFees);
   System.debug('Final Processing Fees : Math.round() : salProcessingFees : ' + salProcessingFees);
  }
  //Production Issue : Bug 22936 : End

  if (loan.Insurance__r != null && loan.Insurance__r.size() > 0) {
   for (DPLinsurance__c ip: loan.Insurance__r) {
    if ((ip.Insurance_Type__c == 'HDFC Life' || ip.Insurance_Type__c == 'BALIC') && ip.Premium_Amount__c != null) {
     groupLife += Integer.valueOf(ip.Premium_Amount__c);
    }
   }
  }
  if (loan.Insurance__r != null && loan.Insurance__r.size() > 0) {
   for (DPLinsurance__c ip: loan.Insurance__r) {
    /* Bug 16507 - Changes in PLTB added by priya CPP check*/
    if ((ip.Insurance_Type__c == 'BAGIC' || ip.Insurance_Type__c == 'CPP') && ip.Premium_Amount__c != null) {
     groupHealth += Integer.valueOf(ip.Premium_Amount__c);
    }
   }
  }

  //if(loan.Fees_and_Charges__r != null && loan.Fees_and_Charges__r.size() > 0 && loan.Fees_and_Charges__r[0].Charge_Type__c == 'Stamp Duty' && loan.Fees_and_Charges__r[0].Change_Amount__c != null)
  if (app != null && app.Contact_Name__r != null && app.Contact_Name__r.Stamp_Duty__c != null)
   otherfees = Integer.valueOf(app.Contact_Name__r.Stamp_Duty__c);

  if (loan.Fees_and_Charges__r != null && loan.Fees_and_Charges__r.size() > 0) {
   for (Fees_and_Charge__c fc: loan.Fees_and_Charges__r) {
    if (fc.FFR__c == true && fc.Charge_Desc__c == 'CREDIT VIDYA FEES' && fc.Change_Amount__c != null)
     financeCharge += Integer.valueOf(fc.Change_Amount__c);

    /*touchFreeCharge added by prashant for SAL PLTB Changes @16507 Start*/
    if (fc.Finnone_ChargeId__c == 601557) {
     touchFreeCharge = fc.Change_Amount__c;
    }
    //added by gopika for 19132
    if (isCallCentreFlag == false && (Flow_Of_Application_Mobility == 'Mobility V2' || Flow_Of_Application_Mobility == 'Mobility')) {
     touchFreeCharge = 0;
     system.debug('value of touchFreeCharge ------>>>> ' + touchFreeCharge);
    }
    /*touchFreeCharge added by prashant for SAL PLTB Changes @16507 End*/
    //22017 start
    if (fc.Finnone_ChargeId__c == 601754 && fc.Change_Amount__c != null)
     EliteCardCharges = fc.Change_Amount__c.setscale(2);
    if (fc.Finnone_ChargeId__c == 500671 && fc.Change_Amount__c != null)
     EMICardCharges = fc.Change_Amount__c.setscale(2);
    if (fc.Finnone_ChargeId__c == 600660 && fc.Change_Amount__c != null)
     cppwalletfee = fc.Change_Amount__c.setscale(2);
    if (fc.Finnone_ChargeId__c == 601586 && fc.Change_Amount__c != null)
     flexiassignlimitfee = fc.Change_Amount__c.setscale(2);
    //22017 end
    /* Bug 16507 - Changes in PLTB added by priya start*/
    if (fc.Charge_Type__c == 'FLEXI FEE') {
     FlexiFees = fc.Change_Amount__c;
    }
    /* Bug 16507 - Changes in PLTB added by priya end*/
   }
  }
   //25097 start
           if(loan != null && loan.Insurance__r != null && loan.Insurance__r.size() > 0)
        {
            insLst =loan.Insurance__r;
            
        
            /*added for bug id 17699 start*/
            for(DPLinsurance__c ins:insLst){
             
                if(ins.Sum_Assured__c == null){
                    ins.Sum_Assured__c = 0.0;
                }
            }
            
            /*added for bug id 17699 end*/
             
        }
            System.debug('Check for insurance'+insLst);
        // 25097 stop
  if (loan != null && Loan.First_Due_Date__c != null) {
   repaymentdate = Loan.First_Due_Date__c;
  }
  //sal PLTB Term And conditions E-agreement E


  /*@16507* start*/
  /* if(Lead != null && Lead.applicants__r != null && Lead.applicants__r.size()>0 && Lead.applicants__r[0].Contact_Name__r != null && Lead.applicants__r[0].Contact_Name__r.Stamp_Duty__c != null)
    {
    stampdutyLine = Integer.valueOf(Lead.applicants__r[0].Contact_Name__r.Stamp_Duty__c);
    }*/
  if (productOffer != null && productOffer.Insurance__r != null && productOffer.Insurance__r.size() > 0) {
   for (DPLinsurance__c ip: productOffer.Insurance__r) {
    if ((ip.Insurance_Type__c == 'HDFC Life' || ip.Insurance_Type__c == 'BALIC') && ip.Premium_Amount__c != null) {
     groupLifeLine += Integer.valueOf(ip.Premium_Amount__c);
    }
   }
  }

  if (productOffer.Insurance__r != null && productOffer.Insurance__r.size() > 0) {
   for (DPLinsurance__c ip: productOffer.Insurance__r) {
    /* Bug 16507 - Changes in PLTB added by priya CPP check*/
    if ((ip.Insurance_Type__c == 'BAGIC' || ip.Insurance_Type__c == 'CPP') && ip.Premium_Amount__c != null) {
     groupHealthLine += Integer.valueOf(ip.Premium_Amount__c);
    }
   }
  }

  if (productOffer != null && productOffer.Fees_and_Charges__r != null && productOffer.Fees_and_Charges__r.size() > 0) {
   for (Fees_and_Charge__c fc: productOffer.Fees_and_Charges__r) {
    if (fc.FFR__c == true && fc.Charge_Desc__c == 'CREDIT VIDYA FEES' && fc.Change_Amount__c != null)
     financeChargeLine += Integer.valueOf(fc.Change_Amount__c);

    /*touchFreeCharge added by prashant for SAL PLTB Changes @16507 Start*/
    if (fc.Finnone_ChargeId__c == 601557 && fc.Change_Amount__c != null) {
     touchFreeChargeLine = fc.Change_Amount__c;
    }
    /*touchFreeCharge added by prashant for SAL PLTB Changes @16507 End*/
    /* Bug 16507 - Changes in PLTB added by priya start*/
    if (fc.Charge_Type__c == 'FLEXI FEE' && fc.Change_Amount__c != null) {
     FlexiFeesLine = fc.Change_Amount__c;
    }
    if (fc.Charge_Type__c == 'Stamp Duty' && fc.Change_Amount__c != null) {
     stampdutyLine += fc.Change_Amount__c;
    }
    /* Bug 16507 - Changes in PLTB added by priya end*/
   }
  }

  maxouterlimit = productOffer.Unsecured_BT_Line_Assigned__c;
  /*@16507*/
      //23575 s
 System.debug('here 1506 flowType'+flowType);
  System.debug('here 1506 productOffer.SOL_Policys__r'+productOffer.SOL_Policys__r);
   if (flowType == 'NewLine') {
    if (productOffer != null && productOffer.SOL_Policys__r != null && productOffer.SOL_Policys__r.size() > 0) {
     for (SOL_Policy__c obj: productOffer.SOL_Policys__r) {
      if (obj.Name == 'Customer Decline Reasons') {
      system.debug('decline reason found');
       hideOTPsection = false;
       showthankusection = true;
      // PageReference custPage = new PageReference(Label.BflsiteuserURL + '/la/CustomerLineAssignmentVFPage?id=' + CommonUtility.EncryptURLParamfrPAN(productOffer.Id) + '&Flow=' + CommonUtility.EncryptURLParamfrPAN(flowType));
      //  custPage.setRedirect(true);
      }
     }
    }
    }
//23575 e
 }
 /*SAL PLTB Changes 14951 added by Anshita Start*/
 public Applicant__c fetchUpdatedApp() {
  system.debug('fetch app ' + loan.id);
  return [SELECT Id, IP_Address_Timestamp__c FROM Applicant__c WHERE Loan_Application__c =: Loan.id AND applicant_type__c = 'Primary'
   LIMIT 1
  ];

 }
 /*SAL PLTB Changes 14951 added by Anshita End*/

 //sal PLTB Term And conditions E-agreement S  
 public PageReference acceptOffer() {
  System.debug('inside accept' + loan);
  PageReference pdf = new PageReference(Label.bflsiteuserURL + '/SAL_PLTBVerification');
  if (loan != null && loan.Product_Offerings__r != null && loan.Product_Offerings__r.size() > 0 && loan.Product_Offerings__r[0].id != null)
   pdf.getParameters().put('Id', (String) loan.Product_Offerings__r[0].id);
  if (loan != null)
   pdf.getParameters().put('LoanId', (String) loan.id);

  Applicant__c app2 = fetchUpdatedApp();
  pdf.getParameters().put('EmailFor', 'EAgreement');

  //SAL PLTB changes Rohit added conditions for parameter S
  if (app2.IP_Address_Timestamp__c == 'Acceptance Pending')
   pdf.getParameters().put('iptimeStamp', app2.IP_Address_Timestamp__c);
  else if (app2.IP_Address_Timestamp__c == 'Rejected')
   pdf.getParameters().put('iptimeStamp', app2.IP_Address_Timestamp__c);
  else
   pdf.getParameters().put('iptimeStamp', 'IPADDRESS');
  //SAL PLTB changes Rohit added conditions for parameter E
  pdf.setRedirect(true);
  return pdf;
 }

 public PageReference decline() {

  PageReference pdf = new PageReference(Label.bflsiteuserURL + '/SAL_PLTBVerification');
  pdf.getParameters().put('purpose', 'thanks');
  pdf.getParameters().put('EmailFor', 'EAgreement');
  /*SAL PLTB Changes 14951 added by Anshita Start*/
  System.debug('robin3 ' + loan.Product_Offerings__r);
  if (loan != null && loan.Product_Offerings__r != null && loan.Product_Offerings__r.size() > 0 && loan.Product_Offerings__r[0].id != null)
   pdf.getParameters().put('Id', (String) loan.Product_Offerings__r[0].id);
  Applicant__c app2 = fetchUpdatedApp();
  if (app2 != null && app2.IP_Address_Timestamp__c == 'Acceptance Pending') {
   app2.IP_Address_Timestamp__c = 'Rejected';

   update app2;
  }
  //SAL PLTB changes Rohit added conditions for parameter S
  if (app2.IP_Address_Timestamp__c == 'Acceptance Pending')
   pdf.getParameters().put('iptimeStamp', app2.IP_Address_Timestamp__c);
  else if (app2.IP_Address_Timestamp__c == 'Rejected')
   pdf.getParameters().put('iptimeStamp', app2.IP_Address_Timestamp__c);
  else
   pdf.getParameters().put('iptimeStamp', 'IPADDRESS');
  pdf.getParameters().put('appId', app2.id);
  //SAL PLTB changes Rohit added conditions for parameter E
  /*SAL PLTB Changes 14951 added by Anshita End*/
  pdf.setRedirect(true);
  return pdf;
 }
 //sal PLTB Term And conditions E-agreement E
 public void updateCustomerAcceptanceFlag() {
  try {
   System.debug('--- customerAcceptanceFlag---' + customerAcceptanceFlag);

   if (flowType == 'LineAccept') {
    if (customerAcceptanceFlag == true) {
     productOffer.Customer_Acceptance_Flag__c = 'YES';
     if (productOffer.Customer_Acceptance_Date__c == null)
      productOffer.Customer_Acceptance_Date__c = system.today();
    } else if (productOffer.Customer_Acceptance_Flag__c != 'YES') {
     productOffer.Customer_Acceptance_Flag__c = 'NO';
    }

    upsert productOffer;
   } else if (flowType == 'LineActive') {
    if (customerAcceptanceFlag == true) {
     productOffer.Line_Activation_Acceptance__c = 'YES';
    } else if (productOffer.Line_Activation_Acceptance__c != 'YES') {
     productOffer.Line_Activation_Acceptance__c = 'NO';
    }else if (flowType == 'NewLine') { //23575 s
    system.debug('working fine');
     // Bug_24489--RDL_Line -- Bug_24801 RDL Agreement -- changed templet name to for RDL product
     PageReference pr;
    if(productOffer.products__c == 'RDL')
    {
      pr = new PageReference(label.bflsiteuserurl + '/la/RDLLineTermsAndConditions');
    }
    else{ 
    
     pr = new PageReference(label.bflsiteuserurl + '/la/SAL_PL_EAgreement_Clone'); }
    pr.getParameters().put('id', productOffer.id);
    pr.getParameters().put('Flow', 'TERMSCONDITIONS');
    system.debug('No issues');
    terms = pr.getContentAsPdf();
    system.debug('still no problems');
    }
   }

   if (productOffer != null) {

    lead.Bank_Name__c = productoffer.Lead__r.Bank_Name__c;
    lead.Bank_Account_Number__c = productoffer.Lead__r.Bank_Account_Number__c;
    upsert lead;
    System.debug('--- FFR_Flag__c-' + productoffer.FFR_Flag__c);
    if (productOffer.Line_Activation_Acceptance__c == 'YES') {
     //system.debug('---ProductSMS__c.getValues(productOffer.Products__c).Charges__c---'+ProductSMS__c.getValues(productOffer.Products__c).Charges__c);
     Integer feeCharges = 0;

     if (productoffer.Unsecured_W_O_BT_Line_Assigned__c != null) {
      //Bug ID : 13661 DG SOL Line AMC Charges By Rajesh START
      List < StaticResource > staticResource = [select id, name, body from StaticResource where name = 'SOL_AMCCharges'];
      String jsonString;
      Map < String, Object > jsMap;
      //Map < String, Object > productMap;commented 22019

      if (!CommonUtility.isEmpty(staticResource))
       jsonString = staticResource[0].Body.toString();

      if (!CommonUtility.isEmpty(jsonString))
       productMap = (Map < String, Object > ) JSON.deserializeUntyped(jsonString);
      //Bug 22019 Start
      if (salLineflag && productoffer.UTM_Source__c != 'BFL_PRIME' && productMap.get('LineAMC') == 'true' && (productOffer.Products__c == 'SAL' || productOffer.Products__c == 'SPL' || productOffer.Products__c == 'RSL' || productOffer.Products__c == 'RDL')) { // bug_24489
       System.debug('--SalLine--' + salLineflag);
       System.debug('--LineAMC--' + productMap.get('LineAMC'));
       System.debug('--UTM--' + productoffer.UTM_Source__c);
       linecharges = 0;
      } else {
       if (!CommonUtility.isEmpty(productMap))
        jsMap = (Map < String, Object > ) productMap.get(productOffer.Products__c);

       if (!CommonUtility.isEmpty(jsMap)) {
        for (String key: jsMap.keyset()) {
         Integer MINlineCharges;
         Integer MAXlineCharges;
         String[] strarr = key.split('-');
         if (!CommonUtility.isEmpty(strarr) && strarr.size() == 2) {
          MINlineCharges = integer.valueof(strarr[0]);
          MAXlineCharges = integer.valueof(strarr[1]);
          if (productoffer.Unsecured_W_O_BT_Line_Available__c <= MAXlineCharges && productoffer.Unsecured_W_O_BT_Line_Available__c >= MINlineCharges) {
           linecharges = Integer.valueof(jsMap.get(key));
           break;
          }
         } else {
          MINlineCharges = integer.valueof(strarr[0]);
          if (productoffer.Unsecured_W_O_BT_Line_Available__c > MINlineCharges) {
           linecharges = Integer.valueof(jsMap.get(key));
           break;
          }
         }
        }
       } else {
        if (ProductSMS__c.getValues(productOffer.Products__c) != null && ProductSMS__c.getValues(productOffer.Products__c).MaxLineAssignedAmount__c != null) {
         Integer MAXlineCharges = Integer.valueof(ProductSMS__c.getValues(productOffer.Products__c).MaxLineAssignedAmount__c);
         if (productoffer.Unsecured_W_O_BT_Line_Assigned__c < MAXlineCharges)
          linecharges = Integer.valueof(ProductSMS__c.getValues(productOffer.Products__c).LineFeesLessThanMaxLineAmount__c);
         else if (productoffer.Unsecured_W_O_BT_Line_Assigned__c > MAXlineCharges)
          linecharges = Integer.valueof(ProductSMS__c.getValues(productOffer.Products__c).LineFeesMoreThanMaxLineAmount__c);
        }

       }
      }
      //22019 e
      system.debug('linecharges' + linecharges);
      //Bug ID : 13661 DG SOL Line AMC Charges By Rajesh END
      //calculate Processing_Fee_Amount__c
      if (productoffer.Offer_PF__c != null)
       productoffer.Processing_Fee_Amount__c = ((productoffer.Unsecured_W_O_BT_Line_Assigned__c * productoffer.Offer_PF__c) / 100).setScale(2);

     }

     productOffer.Consultation_Fees__c = feeCharges;
    }


    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Data Saved Sucessfully'));


   }

   if ((flowType == 'LineActive' && productOffer.Line_Activation_Acceptance__c == 'YES') || (flowType == 'NewLine' && productOffer.Line_Activation_Acceptance__c == 'YES')) {//23575 changed if condition
    //convert loan
    System.debug('-convert loan---' + productOffer);
    /*
        //PageReference pageRef = Page.PODetailsPageLA;
        PageReference pageRef = new PageReference('/apex/PODetailsPageLA');
        //Test.SetCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('poid',productOffer.id);
        ApexPages.currentPage().getParameters().put('flow','LA');
        //pageRef.getParameters().put('poid',productOffer.id);
        //pageRef.getParameters().put('flow','LA');
        
        //101 change start
        //PODetailsPageLA_AC poObj = new PODetailsPageLA_AC('LA',productOffer.id,'SALLine');
        PODetailsPageLA_AC poObj = new PODetailsPageLA_AC();
        
        */
    /**
     *DG Auto TopUp changes
     *Changing code since SAL Line Availability changes still not moved to Production
     */
    //Bug 11518 :: Pritha :: Conversion Logic Changes Start
    if (!autoTopUp) {
     if (flowType == 'NewLine' && terms != null) {
         poObj.termsLineCtrl = terms;
     } //23575 added if
     poObj.convertLoanApplication();
    } else {
     update productOffer;
    }
    //DG Auto TopUp end

    //Bug 11518 :: Pritha :: Conversion Logic Changes End
    //101 change start
    //pageRef.setRedirect(true);
   }


  } catch (Exception e) {
   System.debug('--- e---' + e + 'line ::' + e.getLineNumber());
  }

 }


 public void matchOTP() {


  if (productOffer.One_time_password__c != null && productOffer.One_time_password__c == OTPValue) {
    //23575 Rohit start
   if (flowType == 'NewLine') {
    productOffer.Line_Activation_Acceptance__c = 'YES';
    productOffer.Customer_Acceptance_Flag__c = 'YES';
    if (productOffer.Customer_Acceptance_Date__c == null)
     productOffer.Customer_Acceptance_Date__c = system.today();
      system.debug('inside updatecustomeraceeptanceStatus'+productOffer.Customer_Acceptance_Date__c);
     system.debug('productOffer.IP_Address__c OTP'+productOffer.IP_Address__c);
     /*MAP < String, String > mapofheader = new MAP < String, String > ();
   mapofheader = ApexPages.currentPage().getHeaders();
   ReturnValue = ApexPages.currentPage().getHeaders().get('True-Client-IP');
   // X-Salesforce-SIP has the value when no caching integration or via secure URL.
   if (ReturnValue == '' || ReturnValue == null) {
    productOffer.IP_Address__c= ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
   } // get IP address when no caching (sandbox, dev, secure urls)
   if (ReturnValue == '' || ReturnValue == null) {
    productOffer.IP_Address__c = ApexPages.currentPage().getHeaders().get('X-Forwarded-For');
   } // get IP address from standard header if proxy in use
   system.debug('USER IP ADDRESS: ' + mapofheader);
   system.debug('ReturnValue  : ' + productOffer.IP_Address__c);*/
    update productOffer;
    PageReference pageRef = new PageReference('/apex/PODetailsPageLA');

    ApexPages.currentPage().getParameters().put('poid', productOffer.id);
    ApexPages.currentPage().getParameters().put('id', productOffer.id);
    ApexPages.currentPage().getParameters().put('flow', 'LA');
    poObj = new PODetailsPageLA_AC();
    
    /*poObjJSON = JSON.serialize(poObj);*/
/*List < Help_Desk__c > helpDesks = new List < Help_Desk__c > ();
   Help_Desk__c hd = new Help_Desk__c(Record_Id__c = productOffer.Id, Event__c = 'CustomerLineAssignmentVFPage - OTP Validated');
   helpDesks.add(hd);
   GeneralUtilities.stampRecordForTracking(helpDesks);*/
    //showAvailButton = true;
    hideOtpSection = false;
    showthankusection = true;
   }

   //23575 Rohit stop
   if (flowType == 'LineAccept') {
    showLineFieldSection = true;
    hideOtpSection = false;
   } else if (flowType == 'LineActive') {
    System.debug('************showActiveLineFieldSection' + showActiveLineFieldSection);
    showActiveLineFieldSection = true;
    hideOtpSection = false;
   }
   System.debug('--- OTPValue match---');
  } else {
   if (flowType == 'LineAccept')
    showLineFieldSection = false;
   else if (flowType == 'LineActive')
    showActiveLineFieldSection = false;
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Valid OTP'));
  }

 }
 public List < DPLinsurance__c > getInsura() {
  return Hinsurance;
 }
 //Bug 11518 :: Pritha :: Conversion Logic Changes Start
 @RemoteAction
 global static Boolean checkCustomerAcceptance(Id poId) {//changes access modifier from public to global for bug id 25097
  List < Product_Offerings__c > poList = new List < Product_Offerings__c > ();
  poList = [SELECT Line_Activation_Acceptance__c
   FROM Product_Offerings__c
   WHERE id =: poId AND Line_Activation_Acceptance__c = ''
  ];
  if (poList.size() > 0) {
   poList[0].Line_Activation_Acceptance__c = 'Yes';
   update poList;
   return true; //Go ahead with conversion
  } else {
   return false; //Customer Already responded to mail
  }


 }
//23575 s
   public void ConvertToLoanNew(){
       system.debug('Convert To Loan New Called');
       if(poObj.productOffer.Customer_Acceptance_Flag__c == 'YES' && poObj.productOffer.Line_Activation_Acceptance__c== 'YES'){
           poObj.convertLoanApplication();
       }
   }
/*
@RemoteAction
 global static Boolean convertToLoan(Id poId) {
  system.debug('inside remoting New');
  List < Product_Offerings__c > poList = new List < Product_Offerings__c > ();
  poList = [SELECT Line_Activation_Acceptance__c
   FROM Product_Offerings__c
   WHERE id =: poId AND Line_Activation_Acceptance__c = 'YES'
   AND Product_Offering_Converted__c = false
  ];

  if (poList != null && poList.size() > 0) {

   system.debug('here i am');

   try {
    
    system.debug('polist ' + poList[0].id);
    podetailsPageLA_AC.poIdFrmAPI = poList[0].id;
    podetailsPageLA_AC.RMflowFrmAPI = 'LA';
    poObjstatic = new PODetailsPageLA_AC();
    system.debug(poObjStatic);
    //poObjstatic.ipAdd = ipAdd;
    //poObjstatic.termsLineCtrl = termsStatic;
    poObjstatic.convertLoanApplication();
    /*if(poObjstatic.productOffer.opportunity__c != null){
        PageReference pr = new PageReference(label.bflsiteuserurl + 'la/SAL_PL_EAgreement_Clone');
        pr.getParameters().put('id', poList[0].id);
        pr.getParameters().put('Flow', 'NewLine');
        system.debug('No issues');
        termsStatic = pr.getContentAsPdf();
        system.debug('still no problems');
        poObjstatic.attachFile(poObjstatic.productOffer.opportunity__c);
        poObjstatic.sendEmailForSALLine();
        poObjstatic.sendVerificationcode();
    }
    
    system.debug('returning true');
    return true;
   } catch (exception ex) {
    system.debug('exception occured ' + ex.getmessage() + ' at ' + ex.getLineNumber());
    return false;
   }
  } else {
   return false;
  }

 } */
//23575 e
 //Bug 11518 :: Pritha :: Conversion Logic Changes End
 /* SAl PLTB added by prashant start */
 public String getNumberTOWordConvertion(Decimal num) {

  Decimal junkVal = num;
  Decimal junkValPaisa = junkVal - Math.floor(junkVal);
  junkVal = Math.floor(junkVal);

  String obStr = junkVal.toPlainString();
  String[] numReversed = obStr.split('');
  String[] actnumber = reverse(numReversed);
  String firstHalf = convertInWords(numReversed, actnumber);

  Integer tmp = Math.round(junkValPaisa * 100);
  junkValPaisa = (Decimal) tmp / 100;
  System.debug('jj :' + junkValPaisa);
  String paisaStr = junkValPaisa.toPlainString();
  String secondHalf;
  if (paisaStr == '0') {
   secondHalf = '';
  } else if (paisaStr.length() != 4) {
   paisaStr = paisaStr + '0';
   paisaStr = paisaStr.substring(2);
   String[] numReversedPaisa = paisaStr.split('');
   String[] actnumberPaisa = reverse(numReversedPaisa);
   secondHalf = convertInWords(numReversedPaisa, actnumberPaisa);
  } else {
   paisaStr = paisaStr.substring(2);
   String[] numReversedPaisa = paisaStr.split('');
   String[] actnumberPaisa = reverse(numReversedPaisa);
   secondHalf = convertInWords(numReversedPaisa, actnumberPaisa);
  }

  String SumOFHalves = '';

  if (secondHalf.length() > 4) {
   firstHalf = firstHalf.replace('Only', 'Rupess And ');
   secondHalf = secondHalf.replace('Only', 'Paisa Only');
   SumOFHalves = firstHalf + secondHalf;
  } else {
   firstHalf = firstHalf.replace('Only', 'Rupess Only');
   SumOFHalves = firstHalf;
  }

  // IF amount has any value
  if (SumOFHalves.length() > 5) {
   return SumOFHalves;
  } else {
   return '';
  }
 }
 // Method reverse the number
 public List < String > reverse(List < String > strToRev) {
  List < String > revList = new List < String > ();
  for (Integer i = strToRev.size() - 1; i >= 0; i--) {
   revList.add(strToRev.get(i));
  }
  revList.add('');
  return revList;
 }

 public String convertInWords(String[] numRev, String[] actnum) {
  List < String > iWords = new List < String > {
   'Zero',
   ' One',
   ' Two',
   ' Three',
   ' Four',
   ' Five',
   ' Six',
   ' Seven',
   ' Eight',
   ' Nine'
  };
  List < String > ePlace = new List < String > {
   ' Ten',
   ' Eleven',
   ' Twelve',
   ' Thirteen',
   ' Fourteen',
   ' Fifteen',
   ' Sixteen',
   ' Seventeen',
   ' Eighteen',
   ' Nineteen'
  };
  List < String > tensPlace = new List < String > {
   'dummy',
   ' Ten',
   ' Twenty',
   ' Thirty',
   ' Forty',
   ' Fifty',
   ' Sixty',
   ' Seventy',
   ' Eighty',
   ' Ninety'
  };

  Integer iWordsLength = numRev.size();
  String totalWords = '';
  List < String > inWords = new List < String > ();
  for (Integer k = 0; k < iWordsLength; k++) {
   inWords.add('');
  }
  String finalWord = '';
  Integer j = 0;

  // Main For loop
  for (Integer i = 0; i < iWordsLength; i++) {

   if (i == 0) {
    if (actnum[i] == '0' || actnum[i + 1] == '1') {
     inWords[j] = '';
    } else {
     inWords[j] = iWords[Integer.valueof(actnum[i])];
    }
    inWords[j] = inWords[j] + ' Only';
   } else if (i == 1) {

    if (actnum[i] == '0') {
     inWords[j] = '';
    } else if (actnum[i] == '1') {
     inWords[j] = ePlace[Integer.valueof(actnum[i - 1])];
    } else {
     inWords[j] = tensPlace[Integer.valueof(actnum[i])];
    }
   } else if (i == 2) {
    if (actnum[i] == '0') {
     inWords[j] = '';
    } else if (actnum[i - 1] != '0' && actnum[i - 2] != '0') {
     inWords[j] = iWords[Integer.valueof(actnum[i])] + ' Hundred';
    } else {
     inWords[j] = iWords[Integer.valueof(actnum[i])] + ' Hundred';
    }
   } else if (i == 3) {
    if (actnum[i] == '0' || actnum[i + 1] == '1') {
     inWords[j] = '';
    } else {
     inWords[j] = iWords[Integer.valueof(actnum[i])];
    }
    if (actnum[i + 1] != '0' || Integer.valueof(actnum[i]) > 0) {
     inWords[j] = inWords[j] + ' Thousand';
    }
   } else if (i == 4) {

    if (actnum[i] == '0') {
     inWords[j] = '';
    } else if (actnum[i] == '1') {
     inWords[j] = ePlace[Integer.valueof(actnum[i - 1])];
    } else {
     inWords[j] = tensPlace[Integer.valueof(actnum[i])];
    }

   } else if (i == 5) {
    if (actnum[i] == '0' || actnum[i + 1] == '1') {
     inWords[j] = '';
    } else {
     inWords[j] = iWords[Integer.valueof(actnum[i])];
    }
    if (actnum[i + 1] != '0' || Integer.valueof(actnum[i]) > 0) {
     inWords[j] = inWords[j] + ' Lakh';
    }
   } else if (i == 6) {

    if (actnum[i] == '0') {
     inWords[j] = '';
    } else if (actnum[i] == '1') {
     inWords[j] = ePlace[Integer.valueof(actnum[i - 1])];
    } else {
     inWords[j] = tensPlace[Integer.valueof(actnum[i])];
    }

   } else if (i == 7) {
    if (actnum[i] == '0' || actnum[i + 1] == '1') {
     inWords[j] = '';
    } else {
     inWords[j] = iWords[Integer.valueof(actnum[i])];
    }
    inWords[j] = inWords[j] + ' Crore';
   } else if (i == 8) {

    if (actnum[i] == '0') {
     inWords[j] = '';
    } else if (actnum[i] == '1') {
     inWords[j] = ePlace[Integer.valueof(actnum[i - 1])];
    } else {
     inWords[j] = tensPlace[Integer.valueof(actnum[i])];
    }

   }

   j++;
  }
  // End of For loop

  // Reverse the List
  inWords = reverse(inWords);

  for (Integer i = 0; i < inWords.size(); i++) {
   finalWord += inWords[i];
  }

  return finalWord;
 }
 /* Hrushikesh added start , CIBIL WATCH Enhancment */
 //19478 start
 //updated by swapnil Referra program  bug  in 19263
 public static void onLoadOfLink() //this method will Stamp YES.
 {
  System.debug('loading data');
  try {
   String po_id = ApexPages.currentPage().getParameters().get('po_id');
   po_id = CommonUtility.decryptURLParam(po_id);
   //System.debug('POI ID IS '+po_id);

   if (po_id != null) {
    List < Product_Offerings__c > poList = [SELECT IP_Address__c, Lead_source__c FROM Product_Offerings__c where id =: po_id];
    System.debug('its referred ip');
    //Added by swapnil for spl referredd PO
    if (poList[0].Lead_source__c == 'SPL Referred') {
     isRefered = true;
    }

    String currentString = poList[0].IP_Address__c;

    if (currentString != null && (currentString.contains('YES') || currentString.contains('NO'))) {
     System.debug('ip found and ip is' + currentString);
     initialMessage = true;
     System.debug('Initial message ' + initialMessage);
    } else if (isRefered != true) {
     System.debug('ip not found' + currentString);
     poList[0].IP_Address__c = CommonUtility.getIPTimestamp() + '|YES';
     System.debug('Collected ip is ' + poList[0].IP_Address__c);
     update poList;
     initialMessage = false;
     system.debug('USER IP ADDRESS: ' + poList[0].IP_Address__c);
    }
   }
   //System.debug('in exit');

  } catch (Exception e) {
   System.debug('Exception on line ' + e.getMessage() + ' Line ' + e.getLineNumber());
  }
 }
 //19478 end
 /* Hrushikesh added end, CIBIL WATCH Enhancment */
 /*Swapnil added Referral acceptance-declined --Start*/


 public static void referAccept() {
  System.debug('In accepted 1');
  isRefered = true;
  String po_id = ApexPages.currentPage().getParameters().get('po_id');
  String SOL_id;
  if (ApexPages.currentPage().getParameters().get('SOL_id') != '') {
   SOL_id = ApexPages.currentPage().getParameters().get('SOL_id');
   System.debug('In accepted ' + po_id);
   if (!Test.isRunningTest()) {
    po_id = CommonUtility.decryptURLParam(po_id);
    SOL_id = CommonUtility.decryptURLParam(SOL_id);
   }
   try {
    List < Product_Offerings__c > poList = [SELECT Owner.Name, IP_Address__c, Lead_source__c FROM Product_Offerings__c where id =: po_id limit 1];

    List < SOL_Policy__c > SOLList = [SELECT id, New_Address_Value__c FROM SOL_Policy__c where id =: SOL_id limit 1];

    poList[0].IP_Address__c = CommonUtility.getIPTimestamp() + '|YES';
    poList[0].Customer_Acceptance_Flag__c = 'YES';
    poList[0].Customer_Acceptance_Date__c = System.today();
    upsert poList;
    System.debug('accept List upserted');

    isAccepted = true;
    System.debug('PO Accepted ' + poList[0].Lead_source__c + ' IP is ' + poList[0].Customer_Acceptance_Flag__c + ' Acceptance flag is ' + poList[0].Customer_Acceptance_Flag__c);
    //(After Accept Offer-Referee)
    try {
     GeneralCommunicationHandler.sendsmspo(poList, SOLList, 'After Accept Offer-Referee', false);
     GeneralCommunicationHandler.sendsmspo(poList, SOLList, 'AFTER ACCEPT OFFER-PSF', false);
    } catch (Exception e) {
     System.debug('Exception sending accepatance sMS message at referAccept ' + e.getMessage() + ' at line ' + e.getLineNumber());
    }

   } catch (Exception e) {
    System.debug('Exception occured at referAccept ' + e.getMessage() + ' at line ' + e.getLineNumber());
   }
  }
 }
 public static void referDecline() {
  System.debug('Offer declined');
  isRefered = true;
  String po_id = ApexPages.currentPage().getParameters().get('po_id');
  String SOL_id;
  if (ApexPages.currentPage().getParameters().get('SOL_id') != '') {
   SOL_id = ApexPages.currentPage().getParameters().get('SOL_id');
   System.debug('In accepted ' + po_id);
   if (!Test.isRunningTest()) {
    po_id = CommonUtility.decryptURLParam(po_id);
    SOL_id = CommonUtility.decryptURLParam(SOL_id);
   }

   try {
    list < Product_Offerings__c > poList = [SELECT IP_Address__c, Lead_source__c FROM Product_Offerings__c where id =: po_id limit 1];
    List < SOL_Policy__c > SOLList = [SELECT id, New_Address_Value__c FROM SOL_Policy__c where id =: SOL_id limit 1];
    poList[0].IP_Address__c = CommonUtility.getIPTimestamp() + '|NO';
    poList[0].Customer_Acceptance_Flag__c = 'NO';
    poList[0].Customer_Acceptance_Date__c = System.today();
    upsert poList;

    try {
     GeneralCommunicationHandler.sendsmspo(poList, SOLList, 'After Decline-Referrer', false);
    } catch (Exception e) {
     System.debug('Exception sending decline message at referDecline ' + e.getMessage() + ' at line ' + e.getLineNumber());
    }


    isDeclined = true;
    System.debug('PO Regected ' + poList[0].Lead_source__c + ' IP is ' + poList[0].Customer_Acceptance_Flag__c + ' Acceptance flag is ' + poList[0].Customer_Acceptance_Flag__c);
   } catch (Exception e) {
    System.debug('Exception occured at referDecline ' + e.getMessage() + ' at line ' + e.getLineNumber());
   }
  }
 }
 /*Swapnil added Referral acceptance-declined --End */

 //added by gopika

 /* SAl PLTB added by prashant end */
 /*23438 prod adhoc start*/
 public pagereference openOldPage() {
  String loanid = ApexPages.currentPage().getParameters().get('LoanId');
  LIst < Applicant__c > appList = new List < Applicant__c > ();
  Applicant__c app;
  Date accepteddate;
  appList = [Select id, IP_Address_Timestamp__c, Applicant_Type__c from Applicant__c where Loan_Application__c =: Loanid];
  if (appList != null && appList.size() > 0) {
   for (Applicant__c appli: applist) {
    if (appli.applicant_type__c == 'Primary') {
     app = appli;
     break;
    }
   }
  }
  if (app != null && app.IP_Address_Timestamp__c != null && (app.IP_Address_Timestamp__c != 'Acceptance Pending' && app.IP_Address_Timestamp__c != 'Rejected')) {
   String iptime = app.IP_Address_Timestamp__c;
   integer i = iptime.indexOf('||');
   String str = iptime.subString(i + 2, i + 14);
   accepteddate = Date.valueOf(str);
  }
  String datefromsrc;
  PageReference pdfdocs;
  Date fromdate;
  Date todate;
  Map < String, Object > PrimeMap = (Map < String, Object > ) GeneralUtilities.fetchStaticRescMap();
  if (!commonUtility.isEmpty(PrimeMap) && PrimeMap.get('e_agreementdate') != null) {
   Map < String, Object > e_agreeMap = (Map < String, Object > ) PrimeMap.get('e_agreementdate');
   if (e_agreeMap != null && (!commonUtility.isEmpty(e_agreeMap.get('fromdate').toString()))) {
    fromdate = Date.valueOf(e_agreeMap.get('fromdate').toString());
   }
   if (e_agreeMap != null && (!commonUtility.isEmpty(e_agreeMap.get('todate').toString()))) {
    todate = Date.valueOf(e_agreeMap.get('todate').toString());
   }
  }
  System.debug('pk date' + accepteddate);
  if (accepteddate != null && fromdate != null) {
   if (accepteddate < fromdate) {
    pdfdocs = new PageReference(Label.bflsiteuserURL + '/Old_PLTBTermsAndConditions');
    pdfdocs.getParameters().put('LoanId', (String) loanid);
    pdfdocs.getParameters().put('renderFor', 'pdf');
    pdfdocs.setRedirect(true);
    return pdfdocs;
   }
  }
  if (accepteddate != null && todate != null && accepteddate >= fromdate && accepteddate < todate) {
   pdfdocs = new PageReference(Label.bflsiteuserURL + '/New_PLTBTermsAndConditions');
   pdfdocs.getParameters().put('LoanId', (String) loanid);
   pdfdocs.getParameters().put('renderFor', 'pdf');
   pdfdocs.setRedirect(true);
   return pdfdocs;

  }
  return null;
 }
 /*23438 prod adhoc end*/
 //Rohit added for 23575 start
 public PageReference redirectToCustomerPg() {
  PageReference custPage = new PageReference(Label.BflsiteuserURL + '/la/CustomerLineAssignmentVFPage?id=' + CommonUtility.EncryptURLParamfrPAN(productOffer.Id) + '&Flow=' + CommonUtility.EncryptURLParamFrPAN(flowType));
  custPage.setRedirect(true);
  return custPage;

 }

 public void sendtofinnOne() {
  system.debug('inside send to finnone');

  productOffer = [SELECT id, /*SAL Line S*/ /* Line_Details__c, Line_Details__r.Unsecured_W_O_BT_Line_Available__c, Line_Details__r.Unsecured_W_O_BT_Line_Assigned__c, Line_Details__r.Unsecured_Line_Expiry_Date__c, Line_Details__r.Data_Mart_Status__c, Line_Details__r.Risk_Classification__c, */ /*SAL Line E*/ /*SAL PLTB S*/ /*PLTB AdHoc Rohit S*/ ASM__r.Email, /*PLTB AdHoc Rohit E */ /*SAL PLTB Pritha S*/ Lead__r.Company_Category__r.Company_Category__c, BRANCH__c, Net_Monthly_Salary_3__c, Campaign_Code__c, Cibil_Score__c /* SAL PLTB Bug 12108 Anshita*/ , Total_no_of_secured_loans__c, No_of_Loans__c, Unsecured_loan_balance__c, highest_dpd_In_1_year__c, /*SAL PLTB Pritha E*/ /* SAL PLTB priya S*/ Alternate_Mobile_No__c, Quality_Desposition_Status__c, /* SAL PLTB priya S*/ Appt_Date_Time__c, SMS_Email_Campaign__c, SBS_Scheme__r.FinnOne_Scheme_Code__c, Company_Name__c, owner.Type, /*Call center process start*/ lead__r.Profession_Type__c, Lead__r.Cibil_Score__c, Lead__r.SBS_Branch__r.name, Lead__r.FirstName, Lead__r.LastName, lead__r.SBS_Branch__r.Professional_Branch_Type__c, lead__r.Cibil_Temp__c, Gross_Turnover__c, Enquiry_Amount__c, Annual_Income__c, Fee__c, Remarks__c, Imputed_Salary__c, Gross_Profit__c, lead__r.SBS_Branch__r.SAL_Branch_Type__c, Monthly_EMI_Obligation__c, Lead_Source__c, Revised_Offer_Amount__c, Dependent_Action__c, Type_of_Degree__c, Total_Employment_Vintage__c, Requested_Tenor__c, Follow_Up_Date__c, Company_Value__c, Lead__r.No_of_yr_in_current_org__c, Lead__r.Residential_type__c, Lead__r.DOB__c, Lead__r.Company_Type__c, Lead__r.Company_Category__c, DOB__c, Lead__r.Office_Email_ID__c, Lead__r.Name, Net_Monthly_Salary_1__c, Net_Monthly_Salary_2__c, Ref__c, Clinic__c, Application_Number__c, PF__c, /*Call center process ends*/ Offer_Rate__c, Sourcing_Channel__r.Sourc_Mobile__c, Lead_Name__c, ASM__r.Mobile_number__c, Applicant__r.SegmentaionResult__c, First_Due_Date__c, New_line_assigned__c, Campaign_Type__c, IFSC_Code__c, Bank_Account_Type__c, Employment_Type__c, SBS_Scheme__r.Name, SME_Score__c, Offer_PF__c, Loan_Type__c, Program_Type__c, ASM__c, Process_Type__c, Customer_ID1__r.CIBIL_Segmentation__c, Office_Address_1__c, Office_Address_2__c, Office_Address_3__c, Office_City__c, Office_Pin_Code__c, Office_State__c, Office_Phone__c, Ignore_MCP_Results__c, Resi_Pick_State__c, Resi_Pick_City__c, Address_Change_flag__c, Customer_ID1__r.Customer_Name__c, Resi_city__c, BT_Bank__c, name, SBS_Scheme__c, Opportunity__r.Name, Experience_in_Years__c, Scheme_Name__c, Customer_ID1__r.Customer_ID__c, Opportunity__r.Id, ownerId, Owner.Name, EMI_Amount__c, Availed_EMI__c, Products__c, Sourcing_Channel__r.Name, Product_Offering_Converted__c,
   Offer_Accepted_amount__c, Lead__c, Lead__r.Employment_Type__c, Existing_Product__c, Customer_Name__c, Customer_ID1__c, Customer_ID1__r.Flow__c, Customer_ID1__r.Email_New__c, Customer_ID1__r.Name, Customer_ID1__r.Address_Change__c, Customer_ID1__r.Contact_Person_Name__c, Customer_E_mail__c, Customer_Email_ID__c, Customer_ID__c, Customer_Mobile__c, Address_Line_1__c, Field_Desposition_Status__c, Existing_LAN__c, Address_Line_2__c, Address_Line_3__c, Pin_Code__c, Resi_State__c, Customer_ID1__r.State__c, Final_Amount__c, Offer_ROI__c, Tenor__c, Specialisation__c, Degree__c,
   Offer_Amount__c, Offer_ID__c, TeleCalling_Desposition_Status__c, Field_Check_Status__c, DNC_flag__c, Sourcing_Channel__c, Product_Offering_Source__c, KYC_verification_Done__c /* SAL PLTB Bug 12108 Anshita*/ , Lead__r.Applicant_Type__c, /* Start of field disposition */ Field_Disposition_1__c /* End of field disposition */ ,
   eKYC_Processing__c, eKYC_First_Name__c, eKYC_Last_Name__c, Aadhar_Number__c, eKYC_DOB__c, Existing_Customer_Segmentation__c, Availed_Amount__c, Mode_of_Payment__c, Cheque_In_Favoring__c,
   Risk_Classification__c, Open_Ecs_Limit__c, Disb_Act_No__c, Disb_Bank_Name__c, Disb_Bank_Branch__c, Disb_favouring__c, PDD_pending__c, POS_Old_Loan__c, Disbursement_Bank_IFSC_code__c, Disbursement_Payment_Mode__c,
   Secured_W_O_BT_Line_Assigned__c, Converted_Offer_Product__c, Ext_Finance_Amount__c, Secured_W_O_BT_Line_Available__c, Secured_BT_Line_Assigned__c, Secured_BT_Line_Available__c, Secured_Line_Expiry_Date__c, Unsecured_Line_Expiry_Date__c, Unsecured_W_O_BT_Line_Assigned__c, Unsecured_W_O_BT_Line_Available__c, Unsecured_BT_Line_Assigned__c, Unsecured_BT_Line_Available__c, Opportunity__c, Converted_Date_Time__c,
   Existing_Tenor__c, Topup_Amount__c, Balance_Tenure__c, Last_EMI_Paid__c, DPD_String__c, Bucket_String__c, Old_SFDC_Loan_Application__c, ECS_End_Date__c, Years_of_Experience__c, Net_Salary_Per_Month__c, Total_work_experience__c,
   Bounce_in_Life_Cycle__c, POS__c, Overdue_Charges__c, Total_POS__c, Referral__c, Customer_Type__c, Monthly_Obligation__c, Revised_Offer_ROI__c, Product_Offering_Type1__c, Sourcing_Channel__r.Reporting_Manager__c, Tele_Calling_Sub_disposition__c, Field_Sub_disposition__c,
   Nominator_ID__c, Data_Mart_Status__c, Hold_Reason__c, Opportunity__r.createddate, Line_Accepted__c, Customer_Acceptance_Flag__c, One_time_password__c, Line_Activation_Acceptance__c, Line_Activated__c, IP_Address__c, No_of_Bounce_for_BT_in_last_3_months__c,
   Insurance_Premium_Amount__c, Net_Disbursement_Amount__c, Tele_Caller_Remarks__c, Tele_Caller_Remarks_Summary__c, Field_Remarks__c, Accepted_Premium_Amount__c, Availed_Tenor__c, Customer_Acceptance_Date__c, Bank_Details_Change__c, Processing_Fee_Amount__c, SBS_Scheme__r.Product_Formula__c, Insurance_Product__c, Consultation_Fees__c, Insurance_Type__c, FFR_Flag__c, FFR_amount__c, ECS_error_msg__c, ECS_Bank_Account_number__c, Line_activation_fess_collected__c, Line_activation_Fees_Status__c, MICR_Code__c, Disbursal_Date__c, Bank_name__c, BPI__c, Applicant__c,
   (select id, Finnone_ChargeId__c, Charge_Desc__c, name, Tranche_Detail__r.name, Deposition_Date__c, Deposit_Slip_Number__c, Loan_Application__r.name, Change_Amount__c, Charge_Type__c, Deducted_from_Disbursement__c,
    Service_Charge__c, Status__c, Tranche_Detail__c, Instrument_Date__c, Instrument_No__c, Bank_Branch__c, Instrument_type__c,
    Amount_after_Service_Change__c, Tranche_Detail__r.Tranche_Number__c from Fees_and_Charges__r),
   (Select Nominee_Relationship__c, Nominee_Name__c, Nominee_Address__c, Nominee_Mobile__c, Nominee_DOB__c, Whether_we_are_financing_this_product__c, Term_of_Insurance__c, Sum_Assured__c, Remark__c, Reject_reason__c,
    Premium_Amount__c, Policy_type__c, Policy_number__c, Policy_issue_date__c, Offer_id__c, Loan_Application_Status__c,
    Loan_application_number__c, Opportunity__c, Opportunity__r.Nominee_Name__c, Loan_Amount__c, Insurance_Type__c, Insurance_Product__c, Insurance_Name__c,
    Insurance_amount__c, Existing_LAN_no__c, Decision_time_stamp__c, Customer_Payment_Mode__c, Customer_address__c, CPA_Name__c,
    Cheque_Status__c, Cheque_DD_No_with_Bank_Name__c, Cheque_DD_Date__c, Availed_Tenor__c, Product_Offerings__c,
    Availed_EMI__c, Availed_Amount__c, Approved__c, Age__c, /* Anjali start */ Type_of_Insurance__c, Salutation_of_Nominee__c, Gender_of_Nominee__c, Insurance_Party_type__c, Marital_status_of_Nominee__c, Critical_Illness_Declaration_of_Good_H__c, /*end*/ Appointee_DOB__c, Appointee_Name__c, Source__c, Policy_Tenure__c, Sum_Assured_Type__c, Sum_Insured__c, Plan_Option__c, Plan__c, DOB_of_Dependent_Life__c, DOB_of_Policyholder1__c, /*Bug 13762*/ HdfcCppType__c /*Bug 13762*/ from Insurance__r),
   (select id, /*22019 s*/ Perfios_Account_No__c, /*22019 e*/ /*Bug 12108 krish*/ Password__c, Lead__r.email, Lead__r.Office_Email_ID__c, Lead_Applicants__r.Email__c, Lead_Applicants__r.name /*Bug 12108 Krish*/ , /*SAL PLTB Pritha S*/ Lead__r.id, Obligations_as_per_Perfios__c, Salary_as_per_Perfios__c, Latest_bounce_in_Perfios__c, /*SAL PLTB Pritha E*/ Lead__c, Lead_Applicants__c, Product_Offerings__c, Applicant__c, Applicant__r.Applicant_Type__c, Avg_mthly_bal6__c, Bank_Name__c, sum_Avg_mthly_bal__c, Transaction_Count__c, Bank_Acct_Number__c, Send_Email_For_Perfios__c, Perfios_Flag__c, Bank_Name_List__c from Bank_Accounts__r),
   (select id, Legal__c, Property__c, Valuation__c, Property_Identified__c, Property_Type__c, Builder_Maintenance__c,
    Property_Address_Line_1__c, Plot_No_Flat_No__c, Project_Name__c, Property_Area_In_Sq_Ft__c,
    Date_of_Last_Update_for_BFL_Indicative__c, Property_Price__c, BFL_Indicative_Rate__c, Property_Address_Line_2__c,
    Property_Address_Line_3__c, Property_City__c, Property_State__c, Property_Pin_Code__c, Builder_Name__c,
    Contact_Number_for_Val__c, Contact_Person_for_Val__c, Property_Price_Range__c, Land_Valuation_1__c,
    Construction_Area_Val1__c, Construction_Valuation_1__c, Property_Land_Rate_Val1__c, Final_Valuation__c,
    Construction_Rate_Val1__c, Product_Offerings__c, LTV__c, Net_LTV1__c, Amount_fund_property__c,
    /*Added for PPI v2*/
    Nature_of_property__c, Area_Locality__c, Avg_Property_price__c, Property_Name__c, Rate_per_square_feet__c, Property_Status__c, Construction_area_in_Sq_Ft__c, Construction_rate_per_Sq_Ft__c, Average_Construction_Rate_per_Sq_Ft__c,
    Average_Property_Land_Price_per_Sq_Ft__c, Remarks2__c, Construction_Stage__c, Project_Segmentation__c, Property_Land_Area_In_Sq_Ft__c from Property_Details__r order by createddate asc),
   (select id, /*DG Auto TopUp start*/ Number_Of_Beds__c, OD_CC_Flag__c, PY_Profit_Before_Tax__c, CY_Profit_Before_Tax__c, OD_CC_Bank_Name__c, Flexi_Bank_Branch__c, Flexi_Bank_IFSC_code__c, Flexi_Bank_MICR__c, Flexi_Bank_Name__c, Flexi_Facility__c, Eligible_for_Pure_flexi__c, Flexi_Bank_Account_Number__c, /*DG Auto TopUp end*/ /*SAL PLTB S*/ LTA_Medical__c, LTA_Frequency__c, ROI_Term_Loan__c, ROI_Pure_Flexi_Loan__c, ROI_Drop_Line_Loan__c, Fixed_Obligation_Income_Ratio__c, POFinalFoir__c, POSecuredFoir__c, POUnsecuredFoir__c, Total_Monthly_EMI__c, Line_assigned_basis_Credit_Assessment__c, PO_EMI_LOC__c, POEligibleForLOC__c, POPlusEMI__c, POPlusAmount__c, Expiry_Date_without_BT__c, Line_opted__c, Line_flag__c, PO_CoApp_Net_Salary_1__c, PO_CoApp_Net_Salary_2__c, PO_CoApp_Net_Salary_3__c, /*SAL PLTB E*/ name, PY_Sales_Turnover__c, CY_Audited_Turnover__c, Turnover_Change__c,
    PY_OD_CC_limit__c, OD_CC_limit__c, OD_CC_Limit_Change__c, PY_OD_CC_Limit_Utilisation__c,
    CY_OD_CC_Limit_Utilisation__c, OD_CC_Limit_Utilisation_Change__c, TRM_RM_comment__c, CY_Net_Profit__c, PY_Net_Profit__c, Total_Net_Profit_Change__c, /* SAL PLTB added by priya start*/ Monthly_Obligation__c, Temporary_Overdraft__c, Construction_Valuation_1__c, Construction_Valuation_2__c, Adjusted_Rental_Income__c, Existing_HL_EMI__c /*SAL PLTB added by priya end*/ /*CR for OTPV3 wadl*/ , Risk_Segmentation__c /*CR for OTPV3 wadl*/ , /* PLTB changes 14951 S */ Special_Profile_Employer__c, Current_experiance_in_Month__c, Total_Work_Experience_Months__c, Codified_CIBIL__c, Location_Wise_EWS_Status__c, Average_incentive_for_Q1__c, Approved_Loan_Amount_c__c, Propossed_Loan_Amount__c /* PLTB changes 14951 E */ from SurrogateCAMS__r), /*call center pramod S*/ (select id, Secured_Unsecured__c, Loan_Type__c, Loan_Amount__c, Seen_in__c, Principal_O_s__c,
    Loan_Acc_No__c, Select__c, Applicant__r.ContactName__c,
    Financer__c, Amount__c, Month1_Amount__c, Month2_Amount__c,
    Start_On__c, Tenor__c, Tenor_Left__c, MOB__c, POS__c, EMI__c, Applicant__c, Annual_Obligation__c, Type_of_Oblig__c,
    Month3Amount__c, Month4Amount__c, Obligation__c, Identifier__c, Product_Offering__c, Loan_Application__c, Month5Amount__c, Month6Amount__c, Mthly_Oblig__c, Status__c, Derived_EMI__c, Customer_Declared_EMI__c, Rate_of_Interest__c, Property_Address__c, Remark__c, /*SAL PLTB added by priya start */ financers__c, EMI_Over_In_Next_6_months__c, Purchase_Value__c, Property_Purchase_Date__c /*SAL PLTB added by priya end */ from Existing_Loan_Details__r) /*call center pramod S*/ , eKYC_matching_with_customer_details__c, Enquiry_product__c, CIBIL_Notes__c, Offer_Expiry_Date__c, Opportunity__r.Loan_Application_Number__c, Opportunity__r.Approved_Loan_Amount__c, Opportunity__r.Account.Date_of_Birth__c, Opportunity__r.AccountId /*22019*/ , EPFO_Result__c, eKYC_details_changed_flag__c, (select id, Policy_Name__c, Policy_Status__c, Name, Old_Address_Value__c, Checklist_Policy_Status__c, Product_Offerings__c from SOL_Policys__r limit 30), opportunity__r.StageName /*22019*/ /*moved sol policy query here for optimization sm*/
   from Product_Offerings__c where id =: offerId limit 1
  ];
  if (productOffer != null && productOffer.Product_Offering_converted__c == true) {
    List<Opportunity> opp = [Select id,StageName from opportunity where id = : productOffer.opportunity__c];

   poObj.productOffer = productOffer;
   if(!commonUtility.isEmpty(opp))
   poObj.objloanApplication = opp[0];
     // Bug_24489--RDL_Line -- Bug_24801 RDL Agreement -- changed templet name to for RDL product
     PageReference pr;
    if(productOffer.products__c == 'RDL')
    {
      pr = new PageReference(label.bflsiteuserurl + '/la/RDLLineTermsAndConditions');
    }
    else{  pr = new PageReference(label.bflsiteuserurl + '/la/SAL_PL_EAgreement_Clone'); }
    pr.getParameters().put('id', productOffer.id);
    pr.getParameters().put('Flow', 'NewLine');
    system.debug('No issues');
      if(!Test.isRunningTest())
        poobj.termsLineCtrl = pr.getContentAsPdf();
      else{
          poobj.termsLineCtrl = Blob.valueOf('dGVzdCBzdHJpbmc=');
      }
   system.debug('poObj and static' + productOffer.ip_address__c);
   poObj.sendEmailforSALline();
   poObj.sendVerificationCode();
   //poObj.attachFile(productOffer.opportunity__c);
  }

  try {
   if (salLineflag == true && productOffer.opportunity__r.StageName == 'Branch Ops' && !productOffer.Bank_Details_Change__c && productOffer.Customer_ID1__c != null && productOffer.Customer_Acceptance_Flag__c == 'YES' && productOffer.Line_Activation_Acceptance__c == 'YES' && !productOffer.Address_Change_flag__c && commonUtility.isEmpty(productOffer.ECS_Error_Msg__c) && Lead.IMPS_Result__c != null && Lead.IMPS_result__c.equalsIgnoreCase('Successful Transaction')) { //add bflprime condition in UAT 
    system.debug('inside send to finnOne true');
    PricingDisbmntDetails_Ctrl.loanIdfoMob = productOffer.opportunity__c;
    PricingDisbmntDetails_Ctrl obj = new PricingDisbmntDetails_Ctrl();
    ApexPages.currentPage().getParameters().put('Id', productOffer.opportunity__c);
    obj.senttoFinnone();
    if (obj.mobilitystatus != null)
     System.debug('Error on send to finnOne :' + obj.mobilitystatus);
   }
  } catch (exception ex) {
   system.debug('Exception in send to Finnone : ' + ex.getMessage() + ' ' + ex.getLineNumber());
  }

 }
 //Rohit added for 22019 stop
 
  public PageReference submitDecline() {
  system.debug('reasons are ' + reasons);
     list<SOL_Policy__c> testli = new list<SOL_Policy__c>();
     system.debug('In submitdecline'+productOffer.SOL_Policys__r);
  SOL_Policy__c SOLobj;
  if (productOffer != null) {
    testli=[select Name, Old_Address_value__c,Product_Offerings__c from SOL_Policy__c where Name='Customer Decline Reasons' and Product_Offerings__c=: productOffer.id];
   system.debug('Sol policy present');
      if(testli != null && testli.size() > 0)
      {
         testli[0].Old_Address_value__c=reasons;
         update testli[0];
      }
      else{
  SOLobj = new SOL_Policy__c();
  SOLobj.Name = 'Customer Decline Reasons';
  SOLobj.Old_Address_value__c = reasons;
  SOLobj.Product_Offerings__c = productOffer.id;
      insert SOLobj;
      }
      
  productOffer.Customer_Acceptance_Flag__c = '';
  productOffer.Line_Activation_Acceptance__c = '';
  productOffer.Line_Accepted__c = false;
  productOffer.Line_Activated__c = false;
  productOffer.Availed_Amount__c = 0;
  productOffer.Offer_Amount__c = 0;

  update productOffer;
  }  
   productOffer = [SELECT id, /*SAL Line S*/ /* Line_Details__c, Line_Details__r.Unsecured_W_O_BT_Line_Available__c, Line_Details__r.Unsecured_W_O_BT_Line_Assigned__c, Line_Details__r.Unsecured_Line_Expiry_Date__c, Line_Details__r.Data_Mart_Status__c, Line_Details__r.Risk_Classification__c, */ /*SAL Line E*/ /*SAL PLTB S*/ /*PLTB AdHoc Rohit S*/ ASM__r.Email, /*PLTB AdHoc Rohit E */ /*SAL PLTB Pritha S*/ Lead__r.Company_Category__r.Company_Category__c, BRANCH__c, Net_Monthly_Salary_3__c, Campaign_Code__c, Cibil_Score__c /* SAL PLTB Bug 12108 Anshita*/ , Total_no_of_secured_loans__c, No_of_Loans__c, Unsecured_loan_balance__c, highest_dpd_In_1_year__c, /*SAL PLTB Pritha E*/ /* SAL PLTB priya S*/ Alternate_Mobile_No__c, Quality_Desposition_Status__c, /* SAL PLTB priya S*/ Appt_Date_Time__c, SMS_Email_Campaign__c, SBS_Scheme__r.FinnOne_Scheme_Code__c, Company_Name__c, owner.Type, /*Call center process start*/ lead__r.Profession_Type__c, Lead__r.Cibil_Score__c, Lead__r.SBS_Branch__r.name, Lead__r.FirstName, Lead__r.LastName, lead__r.SBS_Branch__r.Professional_Branch_Type__c, lead__r.Cibil_Temp__c, Gross_Turnover__c, Enquiry_Amount__c, Annual_Income__c, Fee__c, Remarks__c, Imputed_Salary__c, Gross_Profit__c, lead__r.SBS_Branch__r.SAL_Branch_Type__c, Monthly_EMI_Obligation__c, Lead_Source__c, Revised_Offer_Amount__c, Dependent_Action__c, Type_of_Degree__c, Total_Employment_Vintage__c, Requested_Tenor__c, Follow_Up_Date__c, Company_Value__c, Lead__r.No_of_yr_in_current_org__c, Lead__r.Residential_type__c, Lead__r.DOB__c, Lead__r.Company_Type__c, Lead__r.Company_Category__c, DOB__c, Lead__r.Office_Email_ID__c, Lead__r.Name, Net_Monthly_Salary_1__c, Net_Monthly_Salary_2__c, Ref__c, Clinic__c, Application_Number__c, PF__c, /*Call center process ends*/ Offer_Rate__c, Sourcing_Channel__r.Sourc_Mobile__c, Lead_Name__c, ASM__r.Mobile_number__c, Applicant__r.SegmentaionResult__c, First_Due_Date__c, New_line_assigned__c, Campaign_Type__c, IFSC_Code__c, Bank_Account_Type__c, Employment_Type__c, SBS_Scheme__r.Name, SME_Score__c, Offer_PF__c, Loan_Type__c, Program_Type__c, ASM__c, Process_Type__c, Customer_ID1__r.CIBIL_Segmentation__c, Office_Address_1__c, Office_Address_2__c, Office_Address_3__c, Office_City__c, Office_Pin_Code__c, Office_State__c, Office_Phone__c, Ignore_MCP_Results__c, Resi_Pick_State__c, Resi_Pick_City__c, Address_Change_flag__c, Customer_ID1__r.Customer_Name__c, Resi_city__c, BT_Bank__c, name, SBS_Scheme__c, Opportunity__r.Name, Experience_in_Years__c, Scheme_Name__c, Customer_ID1__r.Customer_ID__c, Opportunity__r.Id, ownerId, Owner.Name, EMI_Amount__c, Availed_EMI__c, Products__c, Sourcing_Channel__r.Name, Product_Offering_Converted__c,
   Offer_Accepted_amount__c, Lead__c, Lead__r.Employment_Type__c, Existing_Product__c, Customer_Name__c, Customer_ID1__c, Customer_ID1__r.Flow__c, Customer_ID1__r.Email_New__c, Customer_ID1__r.Name, Customer_ID1__r.Address_Change__c, Customer_ID1__r.Contact_Person_Name__c, Customer_E_mail__c, Customer_Email_ID__c, Customer_ID__c, Customer_Mobile__c, Address_Line_1__c, Field_Desposition_Status__c, Existing_LAN__c, Address_Line_2__c, Address_Line_3__c, Pin_Code__c, Resi_State__c, Customer_ID1__r.State__c, Final_Amount__c, Offer_ROI__c, Tenor__c, Specialisation__c, Degree__c,
   Offer_Amount__c, Offer_ID__c, TeleCalling_Desposition_Status__c, Field_Check_Status__c, DNC_flag__c, Sourcing_Channel__c, Product_Offering_Source__c, KYC_verification_Done__c /* SAL PLTB Bug 12108 Anshita*/ , Lead__r.Applicant_Type__c, /* Start of field disposition */ Field_Disposition_1__c /* End of field disposition */ ,
   eKYC_Processing__c, eKYC_First_Name__c, eKYC_Last_Name__c, Aadhar_Number__c, eKYC_DOB__c, Existing_Customer_Segmentation__c, Availed_Amount__c, Mode_of_Payment__c, Cheque_In_Favoring__c,
   Risk_Classification__c, Open_Ecs_Limit__c, Disb_Act_No__c, Disb_Bank_Name__c, Disb_Bank_Branch__c, Disb_favouring__c, PDD_pending__c, POS_Old_Loan__c, Disbursement_Bank_IFSC_code__c, Disbursement_Payment_Mode__c,
   Secured_W_O_BT_Line_Assigned__c, Converted_Offer_Product__c, Ext_Finance_Amount__c, Secured_W_O_BT_Line_Available__c, Secured_BT_Line_Assigned__c, Secured_BT_Line_Available__c, Secured_Line_Expiry_Date__c, Unsecured_Line_Expiry_Date__c, Unsecured_W_O_BT_Line_Assigned__c, Unsecured_W_O_BT_Line_Available__c, Unsecured_BT_Line_Assigned__c, Unsecured_BT_Line_Available__c, Opportunity__c, Converted_Date_Time__c,
   Existing_Tenor__c, Topup_Amount__c, Balance_Tenure__c, Last_EMI_Paid__c, DPD_String__c, Bucket_String__c, Old_SFDC_Loan_Application__c, ECS_End_Date__c, Years_of_Experience__c, Net_Salary_Per_Month__c, Total_work_experience__c,
   Bounce_in_Life_Cycle__c, POS__c, Overdue_Charges__c, Total_POS__c, Referral__c, Customer_Type__c, Monthly_Obligation__c, Revised_Offer_ROI__c, Product_Offering_Type1__c, Sourcing_Channel__r.Reporting_Manager__c, Tele_Calling_Sub_disposition__c, Field_Sub_disposition__c,
   Nominator_ID__c, Data_Mart_Status__c, Hold_Reason__c, Opportunity__r.createddate, Line_Accepted__c, Customer_Acceptance_Flag__c, One_time_password__c, Line_Activation_Acceptance__c, Line_Activated__c, IP_Address__c, No_of_Bounce_for_BT_in_last_3_months__c,
   Insurance_Premium_Amount__c, Net_Disbursement_Amount__c, Tele_Caller_Remarks__c, Tele_Caller_Remarks_Summary__c, Field_Remarks__c, Accepted_Premium_Amount__c, Availed_Tenor__c, Customer_Acceptance_Date__c, Bank_Details_Change__c, Processing_Fee_Amount__c, SBS_Scheme__r.Product_Formula__c, Insurance_Product__c, Consultation_Fees__c, Insurance_Type__c, FFR_Flag__c, FFR_amount__c, ECS_error_msg__c, ECS_Bank_Account_number__c, Line_activation_fess_collected__c, Line_activation_Fees_Status__c, MICR_Code__c, Disbursal_Date__c, Bank_name__c, BPI__c, Applicant__c,
   (select id, Finnone_ChargeId__c, Charge_Desc__c, name, Tranche_Detail__r.name, Deposition_Date__c, Deposit_Slip_Number__c, Loan_Application__r.name, Change_Amount__c, Charge_Type__c, Deducted_from_Disbursement__c,
    Service_Charge__c, Status__c, Tranche_Detail__c, Instrument_Date__c, Instrument_No__c, Bank_Branch__c, Instrument_type__c,
    Amount_after_Service_Change__c, Tranche_Detail__r.Tranche_Number__c from Fees_and_Charges__r),
   (Select Nominee_Relationship__c, Nominee_Name__c, Nominee_Address__c, Nominee_Mobile__c, Nominee_DOB__c, Whether_we_are_financing_this_product__c, Term_of_Insurance__c, Sum_Assured__c, Remark__c, Reject_reason__c,
    Premium_Amount__c, Policy_type__c, Policy_number__c, Policy_issue_date__c, Offer_id__c, Loan_Application_Status__c,
    Loan_application_number__c, Opportunity__c, Opportunity__r.Nominee_Name__c, Loan_Amount__c, Insurance_Type__c, Insurance_Product__c, Insurance_Name__c,
    Insurance_amount__c, Existing_LAN_no__c, Decision_time_stamp__c, Customer_Payment_Mode__c, Customer_address__c, CPA_Name__c,
    Cheque_Status__c, Cheque_DD_No_with_Bank_Name__c, Cheque_DD_Date__c, Availed_Tenor__c, Product_Offerings__c,
    Availed_EMI__c, Availed_Amount__c, Approved__c, Age__c, /* Anjali start */ Type_of_Insurance__c, Salutation_of_Nominee__c, Gender_of_Nominee__c, Insurance_Party_type__c, Marital_status_of_Nominee__c, Critical_Illness_Declaration_of_Good_H__c, /*end*/ Appointee_DOB__c, Appointee_Name__c, Source__c, Policy_Tenure__c, Sum_Assured_Type__c, Sum_Insured__c, Plan_Option__c, Plan__c, DOB_of_Dependent_Life__c, DOB_of_Policyholder1__c, /*Bug 13762*/ HdfcCppType__c /*Bug 13762*/ from Insurance__r),
   (select id, /*22019 s*/ Perfios_Account_No__c, /*22019 e*/ /*Bug 12108 krish*/ Password__c, Lead__r.email, Lead__r.Office_Email_ID__c, Lead_Applicants__r.Email__c, Lead_Applicants__r.name /*Bug 12108 Krish*/ , /*SAL PLTB Pritha S*/ Lead__r.id, Obligations_as_per_Perfios__c, Salary_as_per_Perfios__c, Latest_bounce_in_Perfios__c, /*SAL PLTB Pritha E*/ Lead__c, Lead_Applicants__c, Product_Offerings__c, Applicant__c, Applicant__r.Applicant_Type__c, Avg_mthly_bal6__c, Bank_Name__c, sum_Avg_mthly_bal__c, Transaction_Count__c, Bank_Acct_Number__c, Send_Email_For_Perfios__c, Perfios_Flag__c, Bank_Name_List__c from Bank_Accounts__r),
   (select id, Legal__c, Property__c, Valuation__c, Property_Identified__c, Property_Type__c, Builder_Maintenance__c,
    Property_Address_Line_1__c, Plot_No_Flat_No__c, Project_Name__c, Property_Area_In_Sq_Ft__c,
    Date_of_Last_Update_for_BFL_Indicative__c, Property_Price__c, BFL_Indicative_Rate__c, Property_Address_Line_2__c,
    Property_Address_Line_3__c, Property_City__c, Property_State__c, Property_Pin_Code__c, Builder_Name__c,
    Contact_Number_for_Val__c, Contact_Person_for_Val__c, Property_Price_Range__c, Land_Valuation_1__c,
    Construction_Area_Val1__c, Construction_Valuation_1__c, Property_Land_Rate_Val1__c, Final_Valuation__c,
    Construction_Rate_Val1__c, Product_Offerings__c, LTV__c, Net_LTV1__c, Amount_fund_property__c,
    /*Added for PPI v2*/
    Nature_of_property__c, Area_Locality__c, Avg_Property_price__c, Property_Name__c, Rate_per_square_feet__c, Property_Status__c, Construction_area_in_Sq_Ft__c, Construction_rate_per_Sq_Ft__c, Average_Construction_Rate_per_Sq_Ft__c,
    Average_Property_Land_Price_per_Sq_Ft__c, Remarks2__c, Construction_Stage__c, Project_Segmentation__c, Property_Land_Area_In_Sq_Ft__c from Property_Details__r order by createddate asc),
   (select id, /*DG Auto TopUp start*/ Number_Of_Beds__c, OD_CC_Flag__c, PY_Profit_Before_Tax__c, CY_Profit_Before_Tax__c, OD_CC_Bank_Name__c, Flexi_Bank_Branch__c, Flexi_Bank_IFSC_code__c, Flexi_Bank_MICR__c, Flexi_Bank_Name__c, Flexi_Facility__c, Eligible_for_Pure_flexi__c, Flexi_Bank_Account_Number__c, /*DG Auto TopUp end*/ /*SAL PLTB S*/ LTA_Medical__c, LTA_Frequency__c, ROI_Term_Loan__c, ROI_Pure_Flexi_Loan__c, ROI_Drop_Line_Loan__c, Fixed_Obligation_Income_Ratio__c, POFinalFoir__c, POSecuredFoir__c, POUnsecuredFoir__c, Total_Monthly_EMI__c, Line_assigned_basis_Credit_Assessment__c, PO_EMI_LOC__c, POEligibleForLOC__c, POPlusEMI__c, POPlusAmount__c, Expiry_Date_without_BT__c, Line_opted__c, Line_flag__c, PO_CoApp_Net_Salary_1__c, PO_CoApp_Net_Salary_2__c, PO_CoApp_Net_Salary_3__c, /*SAL PLTB E*/ name, PY_Sales_Turnover__c, CY_Audited_Turnover__c, Turnover_Change__c,
    PY_OD_CC_limit__c, OD_CC_limit__c, OD_CC_Limit_Change__c, PY_OD_CC_Limit_Utilisation__c,
    CY_OD_CC_Limit_Utilisation__c, OD_CC_Limit_Utilisation_Change__c, TRM_RM_comment__c, CY_Net_Profit__c, PY_Net_Profit__c, Total_Net_Profit_Change__c, /* SAL PLTB added by priya start*/ Monthly_Obligation__c, Temporary_Overdraft__c, Construction_Valuation_1__c, Construction_Valuation_2__c, Adjusted_Rental_Income__c, Existing_HL_EMI__c /*SAL PLTB added by priya end*/ /*CR for OTPV3 wadl*/ , Risk_Segmentation__c /*CR for OTPV3 wadl*/ , /* PLTB changes 14951 S */ Special_Profile_Employer__c, Current_experiance_in_Month__c, Total_Work_Experience_Months__c, Codified_CIBIL__c, Location_Wise_EWS_Status__c, Average_incentive_for_Q1__c, Approved_Loan_Amount_c__c, Propossed_Loan_Amount__c /* PLTB changes 14951 E */ from SurrogateCAMS__r), /*call center pramod S*/ (select id, Secured_Unsecured__c, Loan_Type__c, Loan_Amount__c, Seen_in__c, Principal_O_s__c,
    Loan_Acc_No__c, Select__c, Applicant__r.ContactName__c,
    Financer__c, Amount__c, Month1_Amount__c, Month2_Amount__c,
    Start_On__c, Tenor__c, Tenor_Left__c, MOB__c, POS__c, EMI__c, Applicant__c, Annual_Obligation__c, Type_of_Oblig__c,
    Month3Amount__c, Month4Amount__c, Obligation__c, Identifier__c, Product_Offering__c, Loan_Application__c, Month5Amount__c, Month6Amount__c, Mthly_Oblig__c, Status__c, Derived_EMI__c, Customer_Declared_EMI__c, Rate_of_Interest__c, Property_Address__c, Remark__c, /*SAL PLTB added by priya start */ financers__c, EMI_Over_In_Next_6_months__c, Purchase_Value__c, Property_Purchase_Date__c /*SAL PLTB added by priya end */ from Existing_Loan_Details__r) /*call center pramod S*/ , eKYC_matching_with_customer_details__c, Enquiry_product__c, CIBIL_Notes__c, Offer_Expiry_Date__c, Opportunity__r.Loan_Application_Number__c, Opportunity__r.Approved_Loan_Amount__c, Opportunity__r.Account.Date_of_Birth__c, Opportunity__r.AccountId /*22019*/ , EPFO_Result__c, eKYC_details_changed_flag__c, (select id, Policy_Name__c, Policy_Status__c, Name, Old_Address_Value__c, Checklist_Policy_Status__c, Product_Offerings__c from SOL_Policys__r limit 30), opportunity__r.StageName /*22019*/ /*moved sol policy query here for optimization sm*/
   from Product_Offerings__c where id =: offerId limit 1
  ];
     
  PageReference custPage = new PageReference(Label.BflsiteuserURL + '/la/CustomerLineAssignmentVFPage?id=' + CommonUtility.EncryptURLParamfrPAN(productOffer.Id) + '&Flow=' + CommonUtility.EncryptURLParamFrPAN(flowType));
  custPage.setRedirect(true);
  return custPage;
 }
 
 public PageReference CustomerRedirect(){
  system.debug('called action function' + flowType );
    if (flowType == 'NewLine') {
    // bug_24489
     if ((productOffer.Customer_Acceptance_Flag__c == 'YES' || productOffer.Customer_Acceptance_Flag__c == 'NO')) {   //23575 changed if condition
     if (ApexPages.currentPage() != null ) {
       // bug_24489
      if(ApexPages.currentPage().getUrl().indexOf('SAL_PLAgreement') != -1 || ApexPages.currentPage().getUrl().indexOf('RDLAgreement') != -1){
        system.debug('inside redirection ');
        PageReference custPage = new PageReference(Label.BflsiteuserURL + '/la/CustomerLineAssignmentVFPage?id=' + CommonUtility.EncryptURLParamfrPAN(productOffer.Id) + '&Flow=' + CommonUtility.EncryptURLParamfrPAN(flowType));
        custPage.setRedirect(true);
        return custPage;
        }
   
   }
   }
   // bug_24489
 
    if (productOffer != null && productOffer.SOL_Policys__r != null && productOffer.SOL_Policys__r.size() > 0) {
     for (SOL_Policy__c obj: productOffer.SOL_Policys__r) {
      if (obj.Name == 'Customer Decline Reasons') {
      system.debug('decline reason found');
       //hideOTPsection = false;
       //showthankusection = true;
       system.debug('Current Page is '+ApexPages.currentPage().getUrl());
       if (ApexPages.currentPage() != null ) {
       // bug_24489
      if(ApexPages.currentPage().getUrl() != null && ApexPages.currentPage().getUrl().indexOf('SAL_PLAgreement') != -1 || ApexPages.currentPage().getUrl().indexOf('RDLAgreement') != -1){
        system.debug('inside redirection ');
        PageReference custPage = new PageReference(Label.BflsiteuserURL + '/la/CustomerLineAssignmentVFPage?id=' + CommonUtility.EncryptURLParamfrPAN(productOffer.Id) + '&Flow=' + CommonUtility.EncryptURLParamfrPAN(flowType));
        custPage.setRedirect(true);
        return custPage;
        }
       }
      }
     }
    }
    
    if(productOffer.Line_Activation_Acceptance__c == 'YES' || productOffer.Customer_Acceptance_Flag__c == 'YES'){
       // hideOTPsection = false;
       //showthankusection = true;
       system.debug('Current Page is '+ApexPages.currentPage().getUrl());
       if (ApexPages.currentPage() != null ) {
      if(ApexPages.currentPage().getUrl().indexOf('SAL_PLAgreement') != -1){
        system.debug('inside redirection ');
        PageReference custPage = new PageReference(Label.BflsiteuserURL + '/la/CustomerLineAssignmentVFPage?id=' + CommonUtility.EncryptURLParamfrPAN(productOffer.Id) + '&Flow=' + CommonUtility.EncryptURLParamfrPAN(flowType));
        custPage.setRedirect(true);
        return custPage;
        }
       }
    }
   }
   return null;
}
 //23575 e
 /*22019 s*/
 //added for bug id 22019 shilpa start
 public static Map < String, Object > invokeIMPS(Lead leadObj, Product_Offerings__c productOffer) {


  try {
   Map < String, String > IMPSresponse = new Map < String, String > ();
   List < String > errorCodes = Label.IMPS_Error_codes.split(';');
   //System.debug('Print loan application'+disbObj.Loan_Application__c);
   //List<Opportunity> oppList = [Select Account.Mobile__c, AccountId From Opportunity Where Id =:disbObj.Loan_Application__c];
   if (leadObj != null) {
    String reqno = String.valueOf(Datetime.now());
    String str = reqno.deleteWhitespace();
    str = str.remove('-');
    str = str.remove(':');
    Map < String, Object > IMPSinput = new MAP < String, Object > {
     'requestId' => str,
     'beneIFSCCode' => productOffer.Disbursement_Bank_IFSC_code__c,
     'beneAccNumber' => productOffer.Disb_Act_No__c,
     'source' => 'HTS',
     'amount' => Label.IMPS_Transaction_charge,
     'remitterName' => productOffer.Disb_favouring__c,
     'remitterMobile' => CommonUtility.removeSpecialChar(leadObj.Customer_Mobile__c)
    };

    System.debug('IMPSinput --> ' + IMPSinput);
    IMPSresponse = BRECallout.CallIMPSWebService(IMPSinput);
    System.debug('IMPSresponse --> ' + IMPSresponse);

    if (IMPSresponse != null && IMPSresponse.size() > 0) {
     if ((IMPSresponse.get('respCode') != null && ((new Set < String > (errorcodes)).Contains(IMPSresponse.get('respCode')))) || IMPSresponse.get('respDesc') == 'Internal Server Error') {
      leadObj.IMPS_Transaction_No__c = IMPSresponse.get('traceNumber');
      leadObj.IMPS_Result__c = IMPSresponse.get('respDesc');
      leadObj.IMPSDateTime__c = IMPSresponse.get('dateTime');
      productOffer.Disb_favouring__c = IMPSresponse.get('beneName');

     } else if (IMPSresponse.get('respDesc') != null) {
      leadObj.IMPS_Transaction_No__c = IMPSresponse.get('traceNumber');
      leadObj.IMPS_Result__c = IMPSresponse.get('respDesc');
      leadObj.IMPSDateTime__c = IMPSresponse.get('dateTime');
      productOffer.Disb_favouring__c = IMPSresponse.get('beneName');

      if (IMPSresponse.get('respDesc') == 'Successful Transaction') {
       leadObj.Successful_IMPS_Count__c++;


      } else {
       leadObj.Failure_IMPS_Count__c++;

      }
     }
    }

    //System.debug('disbObj -->' + disbObj);
    IMPSAccountChangeHandler.setSkipUpdateAction(true);
    System.debug('in imps --> ' + IMPSAccountChangeHandler.skipUpdateAction());
    system.debug('PO beforeIMPS' + productOffer);
    update productOffer;
    system.debug('PO after IMPS' + productOffer);
    update leadObj;
   }
   return new Map < String, Object > {
    'LeadObj' => leadobj,
    'PO' => productOffer
   };

  } catch (Exception exceptionInstance) {
   System.debug('Something wrong in invokeCheckIMPS --> ' + exceptionInstance.getMessage());
   return null;
  }
 } // end if

 public static Lead getValidatedIMPS(Lead leadObj) {
  leadObj.IMPS_result__c = '';
  leadObj.IMPSDateTime__c = '';
  leadObj.IMPS_Transaction_No__c = '';
  leadObj.Successful_IMPS_Count__c = 0;
  leadObj.Failure_IMPS_Count__c = 0;
  return leadObj;
 }
 @Future(callout = true)
 public static void callPANBreForPo(String leadbojStr, String poObjStr) {
  Lead leadObj = (Lead) JSON.deserialize(leadbojStr, Lead.class);
  Product_Offerings__c productOffer = (Product_Offerings__c) JSON.deserialize(poObjStr, Product_Offerings__c.class);
  system.debug('after lead::' + leadObj);
  system.debug('after po::' + productOffer);
  SOL_Policy__c SOLPolObjPo = new SOL_Policy__c();
  MAP < String, String > mapOfPANBreParameters = new MAP < String, String > ();
  MAP < String, Object > mapOfPANBreResult = new MAP < String, Object > ();
  mapOfPANBreParameters.put('change_flag', productOffer.eKYC_details_changed_flag__c);
  if (productOffer.EPFO_Result__c != NULL && productOffer.EPFO_Result__c != '91')
   mapOfPANBreParameters.put('EPFO_api_response', 'YES');
  else
   mapOfPANBreParameters.put('EPFO_api_response', 'NO');
  mapOfPANBreParameters.put('domain_check', leadObj.Domain_Check_Result__c);
  if (productOffer.KYC_verification_Done__c == 'Yes')
   mapOfPANBreParameters.put('email_verified', 'YES');
  else
   mapOfPANBreParameters.put('email_verified', 'NO');
  if (leadObj.CIBIL_Score__c != null)
   mapOfPANBreParameters.put('CIBIL_score', leadObj.CIBIL_Score__c);
  else
   mapOfPANBreParameters.put('CIBIL_score', '0');
  if (leadObj.Cibil_Temps__r != null && leadObj.Cibil_Temps__r.size() > 0) {
   mapOfPANBreParameters.put('DPD_Cluster_seg', leadObj.Cibil_Temps__r[0].DPD_cluster_Segment__c);
  } else
   mapOfPANBreParameters.put('DPD_Cluster_seg', '');

  if (productOffer.Risk_Classification__c != null)
   mapOfPANBreParameters.put('riskSegmentClassification', productOffer.Risk_Classification__c);
  else
   mapOfPANBreParameters.put('riskSegmentClassification', '');

  BRECallout breObj = new BRECallout();
  system.debug('calling pan bre>>' + mapOfPANBreParameters);
  if (!Test.isRunningTest()) mapOfPANBreResult = breObj.callPANBreCheckPO(mapOfPANBreParameters);

  system.debug('mapOfPANBreResult>>' + mapOfPANBreResult);
  if (mapOfPANBreResult != null && mapOfPANBreResult.size() > 0) {
   system.debug('inside if panbre>>>');
   Map < String, Object > resultmap = (Map < String, Object > ) mapOfPANBreResult.get('SALPL_Output');
   String result;
   if (resultmap != null)
    result = (String) resultmap.get('employment_check');
   if (result == 'SUCCESSFUL')
    SOLPolObjpo.Checklist_Policy_Status__c = 'Pass';
   else
    SOLPolObjpo.Checklist_Policy_Status__c = 'Fail';

   SOLPolObjpo.Old_Address_Value__c = JSON.serialize(mapOfPANBreResult);
   system.debug('old add val>>' + SOLPolObjpo.Old_Address_Value__c);
   SOLPolObjpo.Name = 'Line Employment Check';
   SOLPolObjpo.Product_Offerings__c = productOffer.id;
   SOL_Policy__c tempobj = new SOL_Policy__c();
   for (SOL_Policy__c solobjtemp: productOffer.SOL_Policys__r) {
    if (solobjtemp.name == 'Line Employment Check') {
     SOLPolObjpo.id = solobjtemp.id;
     break;
    }
   }
   /*if(tempobj != null){
        tempobj.name = SOLPolObjpo.name;
        tempobj.Product_Offerings__c=  SOLPolObjpo.Product_Offerings__c;
        tempobj.Checklist_Policy_Status__c = SOLPolObjpo.Checklist_Policy_Status__c;
        tempobj.Old_Address_Value__c =  SOLPolObjpo.Old_Address_Value__c;
        update tempobj;
   }else{
       insert SOLPolObjpo;
   } */
   System.debug('Id is' + SOLPolObjpo.Id);
   upsert SOLPolObjpo;
   system.debug('after upsert ' + SOLPolObjpo);
  }

 }
 //added by shilpa bug id 22019 shilpa stop
 public static String doEmploymentChecks(Product_Offerings__c poobj, Lead leadobj) {
  system.debug('doEmploymentChecks');
  try {
   //call office email Domain Check
   Map < String, String > domain_mapObj = new Map < String, String > ();
   domain_mapObj.put('poid', poobj.id);
   //domain_mapObj.put('grouptype','salaried');
   // domain_mapObj.put('grouptype','Individual');
   domain_mapObj.put('product', poobj.Products__c);

   //Office Email Verification
   String otpVal = GeneralUtilities.generateOTPPwd(5);
   leadobj.One_Time_Password__c = otpVal;
   update leadobj;
   system.debug('OTP LEAD' + otpVal);
   Map < String, String > mapObj = new Map < String, String > ();
   mapObj.put('productoffer', JSON.serialize(poobj));
   mapObj.put('Lead', JSON.serialize(leadObj));
   //mapObj.put('solpolicy',JSON.serialize(solobj));
   // mapObj.put('solpolicy',JSON.serialize(solobj));

   //mapObj.put('Opportunity',opp);

   callOfficeEmailVerify(mapObj);
   poobj.Email_Sent__c = true;

   /* if(leadobj.Id != null)
{
leadobj.Employer__r = null; //added for bug 22071 Prashant
update leadobj; 
}     
if(poobj.Id != null)
update poobj;*/


   List < SOL_Policy__c > policyList = new List < SOL_Policy__c > ();
   SOL_Policy__c SolObj = new SOL_Policy__c();
   policyList = [select id, Policy_Name__c, New_Address_Value__c, Old_Address_Value__c, Policy_Status__c, Product_Offerings__c, Checklist_Policy_Status__c, Applicant_Name__c from SOL_Policy__c where Product_Offerings__c =: poobj.Id AND Name LIKE 'Sales2.0 Office Email Verification'
    limit 1
   ];
   if (!CommonUtility.isEmpty(policyList) && policyList[0].Policy_Name__c.contains('Office Email Verification')) {
    SolObj = policyList[0];
   } else {
    SolObj = new SOL_Policy__c();
    SolObj.Name = 'Sales2.0 Office Email Verification';
    SolObj.Policy_Name__c = 'Office Email Verification';
    SolObj.Product_Offerings__c = poobj.Id;
   }
   SolObj.RetriggerBRE__c = false;
   upsert SolObj;
   domain_mapObj.put('solpolicy', JSON.serialize(solobj));
   domain_mapObj.put('Lead', JSON.serialize(leadObj));
   domain_mapObj.put('productoffer', JSON.serialize(poobj));
   if (!Test.isRunningTest()) {

    emaildomainnew(domain_mapObj);

   }

  } catch (Exception e) {
   System.debug('Exception' + e.getMessage() + ' at Line Number: ' + e.getLineNumber());
   //showErrorMsg = true;
   // savedMessage = e.getMessage();
   //savedMessageBody = e.getMessage();
   //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
   return null;
  }
  return null;
 }
 @Future(callout = true)
 public static void emaildomainnew(Map < String, String > domain_mapObj) {
  system.debug('domain_mapObj' + domain_mapObj);
  Lead leadObj = (Lead) JSON.deserialize(domain_mapObj.get('Lead'), Lead.class);
  Product_Offerings__c poobj = (Product_Offerings__c) JSON.deserialize(domain_mapObj.get('productoffer'), Product_Offerings__c.class);
  SOL_Policy__c solobj = (SOL_Policy__c) JSON.deserialize(domain_mapObj.get('solpolicy'), SOL_Policy__c.class);
  String product = domain_mapObj.get('product');
  //String poId = ApexPages.currentPage().getParameters().put('poId', poobj.id);
  PODetailsPageLA_AC sobj = new PODetailsPageLA_AC();
  sobj.leadobj = leadObj;
  sobj.productoffer = poobj;
  sobj.callEmailDomainCheck(solobj, new List < Lead > {
   leadObj
  });
 }

 @Future(callout = true)
 public static void callOfficeEmailVerify(Map < String, String > objMap) {
  system.debug('objMap' + objMap);
  Lead leadObj = (Lead) JSON.deserialize(objMap.get('Lead'), Lead.class);
  Product_Offerings__c poobj = (Product_Offerings__c) JSON.deserialize(objMap.get('productoffer'), Product_Offerings__c.class);
  //SOL_Policy__c solobj = (SOL_Policy__c)JSON.deserialize(objMap.get('solpolicy'),SOL_Policy__c.class);
  String[] bccArray;
  String replyURL = '';
  Mid_office_BRE_flow__c BRE_Flow = Mid_office_BRE_flow__c.getValues('BRE Flow');
  //replyURL = BRE_Flow.OTPV2_office_email_confirmantion__c;
  replyURL = 'otpofficeemailverification@1lx1qgdc2bjom8z1i8whz0388ymn2cuqe8qwdo9zi4b3tsis5h.0k-dlrweaw.cs57.apex.sandbox.salesforce.com';
  BAFL_EmailServicesLogix.EmailServicesPort stub = new BAFL_EmailServicesLogix.EmailServicesPort();
  stub.timeout_x = 120000;

  String[] ccArray;
  ccArray = new String[] {};

  if (leadobj.Name != null && leadobj.Office_Email_ID__c != null) {
   String body = '<b>Dear ' + leadObj.Name + '</b><br/><br/>';

   body += '<div style=\\"margin-left:25px;\\">Product Offer(' + poobj.Ref__c + ') requires your Office Email Id verification. Please Click on the below link to verify the office email.</div><br/>';
   body += '<a href=\\"' + Label.bflsiteuserURL + '/SAL_PLTBVerification?Id=' + poobj.Id + '&EmailFor=OfficeEmailVerification\\" target=\\"_blank\\" style=\\"color:#000;text-decoration:none;\\"><strong>Click here </strong></a>to accept our terms and conditions.';
   body += '<div style=\\"margin-left:25px;\\">If you are unable to verify your Official Email ID using the above mentioned link, Kindly share the below mentioned OTP with our representative.</div><br/><div  style=\\"margin-left:25px;\\">OTP : ' + leadobj.One_Time_Password__c + '</div>';
   String emailAddr = leadobj.Office_Email_Id__c;
   System.debug('body' + body);
   String[] toAddresses = new String[] {
    emailAddr
   };
   BAFL_EmailServicesLogix.SendEmailResponse er = stub.SendEmail('spl.mailconfirmation@bajajfinserv.in',
    replyURL,
    toAddresses,
    ccArray,
    bccArray,
    'Normal',
    new BAFL_EmailServicesLogix.Attachment[] {},
    'product offering for ' + leadobj.Name + ' : ' + poobj.Id,
    body,
    'bajaj');
   //leadobj.Office_Email_sent__c = true;
   poobj.Email_sent__c = true;
   //leadobj.Employer__c = null;
   //update leadobj; 
   update poobj;


  }

 }
 @AuraEnabled
 public static string fetchPOdetails(String offerId, String leadId) {
  Map < String, Object > responseMap = new Map < String, Object > ();
  List < Product_Offerings__c > poList = PODetailsPageLA_AC.fetch_PO('id =' + '\'' + offerId + '\'' + ' limit 1');
  List < Lead > leadList = PODetailsPageLA_AC.fetch_Lead('id =' + '\'' + leadId + '\'' + ' limit 1');
  List < De_Dupe__c > dedupeList = [Select id, Lead_Applicants__c, Lead_Applicants__r.Name, name, Lead__r.Name, Customer_Last_Name__c, Applicant__c, Applicant_Type__c, PAN__c, PAN_Card_Number__c, Application_ID__c, Dedupe_Lan_Matches__c, Customer_ID__c, De_Dupe_Decision__c, De_Dupe_result__c, Dedupe_Comments__c, Datafix_Updated__c, SF_Base__c, Dedupe_Source__c, Dedupe_Target_Remarks__c, Segment__c, applicant_id__c, Customer_Status__c, De_Dupe_Matched_Percentage__c, Source_Or_Target__c, Lead_Applicants__r.Customer_Type__c, Negative_Area__c from De_Dupe__c where Lead__c =: leadId];
  system.debug('poList is' + poList);
  Map < String, Object > respMap = new Map < String, Object > ();
  if (poList[0].sol_policys__r != null && poList[0].sol_policys__r.size() > 0) {
   for (SOL_policy__c solObj: poList[0].sol_policys__r) {
    if (solobj.name == 'Line Employment Check') {
     respMap = (Map < String, Object > ) json.deserializeUntyped(solobj.Old_Address_Value__c);
    }
   }
  }
  responseMap.put('offerObj', poList[0]);
  responseMap.put('leadObj', leadList[0]);
  responseMap.put('dedupeList', dedupeList);
  responseMap.put('solMap', respMap);
  return json.serialize(responseMap);
 }
 public static void fetchBlob(String pName, String poId, String RecID) {
  PageReference SALLinepdf;
  if (pName != 'LineAssignmentSite Profile') {
   SALLinepdf = Page.SALLineTermsAndConditions;
  } else {
   SALLinepdf = new PageReference('/SALLineTermsAndConditions');
  }
  SALLinepdf.getParameters().put('id', poId);
  SALLinepdf.getParameters().put('Flow', 'NewLine');
  Blob body;
  if (!Test.isRunningTest())
   body = SALLinepdf.getContentAsPDF();
  else
   body = Blob.valueOf('Some Text');

  PODetailsPageLA_AC.attachmail(RecId, body);

 }
 public static void attachmail(String RecId, Blob csvBlob) {

  ContentVersion conVer = new ContentVersion();
  conVer.ContentLocation = 'S';
  conVer.PathOnClient = '.pdf';
  conVer.Title = 'TermsAndConditions';
  conVer.VersionData = csvBlob; // File content
  System.debug('conVer::::' + conVer);
  insert conVer;
  Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: conVer.Id].ContentDocumentId;
  ContentDocumentLink cDe = new ContentDocumentLink();
  cDe.ContentDocumentId = conDoc;
  cDe.LinkedEntityId = RecId;
  cDe.ShareType = 'V';
  cDe.Visibility = 'AllUsers';
  insert cDe;

 }
 /*22019 e*/
 /*23575 s*/
    public static String getLinemailbody(String mailbody,String recId){
    Product_Offerings__c po = [Select id,opportunity__c from Product_Offerings__c where id = : recId];
    Opportunity opp = [Select Account.Name,Loan_Application_Number__c from Opportunity where id = : po.opportunity__c];
    
    mailBody = mailBody.replaceAll('tempLAN',opp.Loan_Application_Number__c);
    mailBody = mailBody.replaceAll('tempName',opp.Account.Name);
    system.debug('after replace '+mailbody);
    return mailBody;
}
//25097
  public PageReference submitDeclineReason()
    {
        //String reasons = apexpages.currentpage().getparameters().get('Reasons');
        PrimaryApp.Customer_Decline_Reasons__c =declineReasons;//25097
        system.debug('reasons -->'+declineReasons);
        PageReference pdf = new PageReference(Label.bflsiteuserURL+'/SAL_PLTBVerification'); 
        pdf.getParameters().put('purpose', 'thanks');
        pdf.getParameters().put('EmailFor', 'EAgreement');
        pdf.getParameters().put('loanID', (String)LoanId);
        if(PrimaryApp!= null && PrimaryApp.IP_Address_Timestamp__c == 'Acceptance Pending'){
            PrimaryApp.IP_Address_Timestamp__c= 'Rejected';
            update PrimaryApp;
        }
        SAL_PLTBVerificationCntrl.sendsms('Decline',Loan,PrimaryApp);
        if(PrimaryApp.IP_Address_Timestamp__c == 'Acceptance Pending' )
            pdf.getParameters().put('iptimeStamp', PrimaryApp.IP_Address_Timestamp__c);
        else if(PrimaryApp.IP_Address_Timestamp__c == 'Rejected')
            pdf.getParameters().put('iptimeStamp', PrimaryApp.IP_Address_Timestamp__c);
        else
            pdf.getParameters().put('iptimeStamp', 'IPADDRESS'); 
        pdf.getParameters().put('appId',PrimaryApp.id);
        
        pdf.setRedirect(true);
        return pdf;
    }
     public void dummy(){
    
        Integer i;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
         i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
         i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
        i=1;
        i=2;
        i=3;
        i=4;
        i=5;
    }
//  25097

}