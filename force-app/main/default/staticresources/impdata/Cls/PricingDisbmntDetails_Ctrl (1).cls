global class PricingDisbmntDetails_Ctrl {
 //Bug 22141 S
 public Boolean isConfirmBankAccount {
  get;
  set;
 }
 //Bug 21287--S
 public Set < String > impsEnabledBank {
  get;
  set;
 }
 public String impsBank {
  get;
  set;
 }
 // bug 23332 s
  public static String PDobjId {
  get;
  set;
 }
 // Bug 23332 E  
 
 public Boolean impsEnabled {
  get;
  set;
 }
 //Bug 21287 --E
 //Bug:19193 -  Top Up Changes Start : Garima
 public boolean invalidPOS {
  get;
  set;
 }
 //Bug:19193 -  Top Up Changes End : Garima 

 //Bug 22425 CC Code changes SME S
 public Boolean IsCreditatPO {
  get;
  set;
 }
 //Bug 22425 CC Code changes SME E
 //Bug 17556 s
 public static String loanIdfoMob {
  get;
  set;
 }
 public String mobilitystatus;
 public Id bioekycId {
  get;
  set;
 }
 public Boolean isBioEkycdone {
  get;
  set;
 }
 public Boolean isBioEkycenabled {
  get;
  set;
 }
 //Bug 17556 e
 // SAL Mobility Addition CR - Aman Porwal - S 
 boolean SALMobilityChangeAmount = false;
 // SAL Mobility Addition CR - Aman Porwal - E
 public String tokenNumber {
  get;
  set;
 } //added for bug id 16165
 //public static boolean cibilWatchComm {get;set;}//added for bug id 20296
 // public static BAFL_EmailServicesLogix.Attachment[] arrAttachment {get;set;}//added for bug id 20296
 public boolean salMobilityFlagV2 {
  get;
  set;
 }

 //Rohit 16111 CR start
 public Boolean aadharMandatoryState {
  get;
  set;
 }
  public static String encryptloanId {
  get;
  set;
 }
 public Boolean appEkyc {
  get;
  set;
 }
 //Rohit 16111 CR stop
 /* BUG ID 17470 S*/
 public boolean isPROProductLineProduct {
  get;
  set;
 }
 //OTPv3 TeleRM Rohit 15229 start
 public Set < String > salariedProducts = new Set < String > ();
 //OTPv3 TeleRM Rohit 15229 stop
 Set < String > setProdRes = new Set < String > (); //Responsys API Integration - added by Krish
 private List < Rack_Rate__c > rrMaster; //Responsys API Integration - added by Krish
 //V1 Refinement Enhancement Start
 public StaticResource SRFormula = new StaticResource();
 public boolean salMobilityFlag {
  get;
  set;
 }
 public String JsonStr {
  get;
  set;
 }
 Public StaticResource sendpricingemail; //salpl commercial consent
 public Boolean displayPricingGrid {
  get;
  set;
 }
 public Property_Details__c prop {
  get;
  set;
 }
 public Decimal sumBTAmount {
  get;
  set;
 }
 //Dedupe linking 13901 start
 public boolean IsDedupeLinkingOoneFlag {
  get;
  set;
 }
 //Dedupe linking 13901 end
 /*IMPS Account Validation :S*/
 public boolean IMPSsecShow {
  get;
  set;
 }
 public String selectedDisbursmentId;
 public List < Current_Disbursal_Details__c > IMPSResultLst {
  get;
  set;
 }
 /*IMPS Account Validation :E*/
 //Bug# 13793 S
 public Id lanId {
  get;
  set;
 }
 public Boolean hasInitiated {
  get;
  set;
 }
 public Boolean isTopUp {
  get;
  set;
 }
 public Boolean renderTopUp {
  get;
  set;
 }
 public Set < String > topuplbl = new Set < String > ();
 //Bug# 13793 E
 public Decimal sumTopAmount {
  get;
  set;
 }
 public Decimal sumBtROI {
  get;
  set;
 }
 public Decimal sumTopROI {
  get;
  set;
 }
 public Decimal sumBTPF {
  get;
  set;
 }
 public Decimal sumTopPF {
  get;
  set;
 }
 public Decimal sumLIAmount {
  get;
  set;
 }
 public Decimal sumGIAmount {
  get;
  set;
 }
 //V1 Refinement Enhancement End
 //added by akshata :Hybrid Flexi Inhancement : Start
 public boolean IsHybridFlexi {
  get;
  set;
 }
 //added by akshata :Hybrid Flexi Inhancement : End

 // 16175 added by akshata :Hybrid Flexi topup emi changes : Start
 public boolean IsTopupHybridFlexi {
  get;
  set;
 }
 // 16175 added by akshata :Hybrid Flexi topup emi changes : End

 /*SAL PLTB Bug 12108 start - krish */
 public boolean callCenterProcessFlag {
  get;
  set;
 }
 public boolean salLineFlag {
  get;
  set;
 }

 public boolean autoTopUp {
  get;
  set;
 }
 public Set < String > callCentrelbl = new Set < String > ();
 public Set < String > callCentreProdlbl = new Set < String > ();
 /*SAL PLTB Bug 12108 end - krish */

 // Pankaj : Capturing ECS barcode
 public Boolean repayFlag {
  get;
  set;
 }
 public String DuplicateLAN {
  get;
  set;
 }
 public String DuplicateBarCodeNo {
  get;
  set;
 }
 //Rate Approval start
 public Boolean rateflag {
  get;
  set;
 }
 /* ECS*/
 public Integer nachedFlag {
  get;
  set;
 }

 public Boolean AppValid {
  get;
  set;
 }

 /*Bug 14506 - HFC Fields - SFDC By Rajesh Start*/
 public Account account {
  get;
  set;
 }
 public Boolean BHFLProductsFlag {
  get;
  set;
 }
 /*Bug 14506 - HFC Fields - SFDC By Rajesh Start*/


 public Boolean branchValid {
  get;
  set;
 }
 //Rate Approval end
 //added by Suraj...Commercial Emailer start
 public boolean sendCommercialMailSelfemployed {
  get;
  set;
 }
 //added by Suraj...Commercial Emailer end
 public Boolean prodFlag {
  set;
  get;
 } //variable for fraud trigger enhancment - krish
 public String RepayListStr {
  get;
  set;
 } //Ops process added by Manasi

 // Start of BALIC HTS Integration phase 1
 static Map < String, Object > mapOfHTSCalculatorParams = new Map < String, Object > ();
 static Map < String, Object > IHGInputMap = new Map < String, Object > ();
 static public String result;
 public static Map < String, Object > ApplicantDOB {
  get;
  set;
 }
 // End of BALIC HTS Integration phase 1

 //--------------- Mortgage Re-Engg Start---------------------
 public decimal recommLTV {
  get;
  set;
 }
 public decimal actualLTV {
  get;
  set;
 }
 public decimal LTVtobrCons {
  get;
  set;
 }

 public boolean Mortgageflag {
  set;
  get;
 }

 public List < Property_Details__c > propertyList {
  set;
  get;
 }
 public List < Bank_Account__c > bankList {
  set;
  get;
 }
 public Fees_and_Charge__c feesMortgage {
  set;
  get;
 }
 public Boolean CentralisedOpsShow {
  set;
  get;
 }
 public List < Discrepancy__c > objdiscrepancyKitList {
  set;
  get;
 }
 public Tranche_Details__c objTranche;
 public String KitAcceptanceValue {
  set;
  get;
 }
 public List < SelectOption > KitAcceptanceSelect;
 public Discrepancy__c addNewDisbKit;
 public transient Blob attachmentBodyOutside {
  set;
  get;
 }
 public String attachmentNameOutside {
  set;
  get;
 }
 public List < Discrepancy__c > discrepancyListDis {
  get;
  set;
 }

 //--------------- Mortgage Re-Engg End-----------------------

 //Pricing Details:By Pritha ; start
 public List < Sales_Officer_Limit__c > solList {
  get;
  set;
 }
 public boolean solflag {
  get;
  set;
 }
 //Pricing Details :By Pritha ; end
 //system workflow Enhancement Pramod S
 public Date SOLStampdate;
 public boolean SOLStampFlag {
  get;
  set;
 }
 public String digiLoungeProducts {
  get;
  set;
 }
 public Set < String > digiProds = new Set < String > ();
 //system workflow Enhancement Pramod E  
 //ops process added by priya start
 public Boolean opsProductsFlag {
  get;
  set;
 }
 public decimal netdisb {
  get;
  set;
 }
 //ops process added by priya end

 //Charges API Enhacement Start

 public boolean chargesAPIManual {
  get;
  set;
 }
 public boolean chargesAPIAuto {
  get;
  set;
 }
 //Charges API Enhacement End

 /*prajyot : #10317*/
 String currentManager;
 string currentManagerName;
 string currentManagerDesignation;
 List < SelectOption > optionsPriAppr = new List < SelectOption > ();

 //pricing email changes start
 List < Fees_and_Charge__c > fees1 {
  get;
  set;
 }
 //pricing email changes end
 //emaildomincheck
 public Boolean EmailDomainCheck {
  get;
  set;
 }

 //Line amount
 public SurrogateCAM__c objSurrogateCAM {
  get;
  set;
 }
 public PageReference SaveInstrumentDetails() {
  return null;
 }
 //Cash in 60 minutes starts

 public Personal_Discussion__c pdobject {
  get;
  set;
 }
 public Boolean blindDataFlag {
  get;
  set;
 }
 public Boolean blindDatapresentFlag {
  get;
  set;
 }
 public Boolean isFlexiFlag {
  get;
  set;
 }
 public List < String > productlist {
  get;
  set;
 }
 //Cash in 60 minutes ends
 // OPS: Blind data S
 public List < String > schemelist {
  get;
  set;
 }
 // OPS: Blind data E

 //4450
 String LoanAppFlow;
 Date COLStampdate;
 boolean COLStampFlag;

 public PageReference addrowInstrument() {
  return null;
 }
 public String Grouptype {
  get;
  set;
 }

 List < SelectOption > optionscreditCardList = new List < SelectOption > ();
 List < SelectOption > optionsgetloanTypeList = new List < SelectOption > ();

 public String loanType {
  get;
  set;
 }
 public String brokenPeriodInt {
  get;
  set;
 }
 public String emi {
  get;
  set;
 }
 public String firtEMIDate {
  get;
  set;
 }
 public String lastEMIDate {
  get;
  set;
 }
 public String creditCard {
  get;
  set;
 }

 public Boolean viewsendEmail {
  get;
  set;
 }
 public Boolean viewsendEmailDis {
  get;
  set;
 } //Added for dis
 public Boolean sendMssgDis {
  get;
  set;
 } //Added for dis
 public boolean showsave {
  get;
  set;
 }
 public boolean showsubhold {
  get;
  set;
 }
 public boolean showback {
  get;
  set;
 }
 List < Discrepancy__c > sanctionList {
  get;
  set;
 }
 public Boolean editsanctionList {
  get;
  set;
 }
 List < Current_Disbursal_Details__c > DisbList = new List < Current_Disbursal_Details__c > ();
 public Boolean sendMssg {
  get;
  set;
 }
 List < Discrepancy__c > discrepancysend = new List < Discrepancy__c > ();
 List < RePayment_mode_detail__c > RepayList = new List < RePayment_mode_detail__c > ();
 public List < Document_Family__c > docFamilyMaster = new List < Document_Family__c > ();
 public List < Checklist__c > checklistTrnxList {
  get;
  set;
 }
 public List < DocumentWrapper > deviationDocWrapperList = new List < DocumentWrapper > ();
 List < Discrepancy__c > discrepancyData = new List < Discrepancy__c > ();
 public List < DocumentWrapper > docWrapperList = new List < DocumentWrapper > ();
 public Set < String > documentNameList = new Set < String > ();
 public Integer rowCount, devRowCount;
 public Id LoanId {
  get;
  set;
 } // Added for BALIC HTS Integration Phase 2
 public Opportunity Loan {
  get;
  set;
 }
 public Applicant__c applicantPrimary {
  get;
  set;
 }
 public static Applicant__c applicantPrimary1 { //added for bug id 16165
  get;
  set;
 }
 public Integer countIncrementer = 3;
 public List < Applicant__c > applicantList = new List < Applicant__c > ();
 public string InsuranceCPAname {
  get;
  set;
 }
 List < SelectOption > listTranche = new List < SelectOption > ();
 List < Tranche_Details__c > Tranche = new List < Tranche_Details__c > ();
 List < Fees_and_Charge__c > Fees {
  get;
  set;
 }
 public transient string StandedApprovedloanAmt {
  get;
  set;
 }
 public String message {
  get;
  set;
 }
 public boolean savedSuccessfull {
  get;
  set;
 }
 List < DPLinsurance__c > Hinsurance = new List < DPLinsurance__c > ();
 public Boolean addrow {
  get;
  set;
 }
 public List < CAM__c > allCAM = new List < CAM__c > ();
 public string LoanPremPlusInsuPre1 {
  get;
  set;
 }
 public decimal LoanPremPlusInsuPre {
  get;
  set;
 }
 set < string > IproductHolder = new set < string > ();
 decimal DPLinsurancePremAmt = 0;
 public string totalInsupre {
  get;
  set;
 }
 public Boolean editDiscrepancyDis {
  get;
  set;
 }
 public List < Discrepancy__c > discrepancysendDis = new List < Discrepancy__c > ();
 public transient string StandedTenor {
  get;
  set;
 }
 public transient string standedrate {
  get;
  set;
 }
 public string EmiwithLoanPremPlusInsuPre {
  get;
  set;
 }
 public List < FinnOne_Report__c > FinnOne {
  get;
  set;
 }
 public FinnOne_Report__c FinnOneObj {
  get;
  set;
 }
 public String StrVAContact = null;
 public Boolean showDiscrepancy {
  get;
  set;
 }
 List < Credit_Officer_Limit__c > CO = new List < Credit_Officer_Limit__c > ();
 List < SelectOption > optionsCOAppr = new List < SelectOption > ();
 Id userDisc, docid;
 public String chkListType {
  get;
  set;
 }
 public String docType {
  get;
  set;
 }
 List < Discrepancy__c > discrepancyListUpdate = new List < Discrepancy__c > ();
 List < Discrepancy__c > discrepancyList = new List < Discrepancy__c > ();
 //public List < Discrepancy__c > discrepancyListDis = new List < Discrepancy__c > (); Mortgage Re-Engg
 List < Discrepancy__c > discrepancyListLog = new List < Discrepancy__c > ();
 public Boolean addrowDisc {
  get;
  set;
 }
 Account acc;
 public Boolean editDiscrepancy {
  get;
  set;
 }
 public String StrVAContactDis = null;
 public String StrInsurerName {
  get;
  set;
 }
 List < SelectOption > optionsApplicant = new List < SelectOption > ();
 public Boolean showSanction {
  get;
  set;
 }
 public List < Discrepancy__c > discrepancyDataDis = new List < Discrepancy__c > ();
 public List < DocumentWrapper > standardDocWrapperList = new List < DocumentWrapper > ();
 Integer count = 0, countDis = 0, fcount = 0, discrepancyListCount = 0, discrepancyListCountDis = 0, sanctionListCount = 0;
 List < Sales_Officer_Limit__c > totalSolimt = new List < Sales_Officer_Limit__c > ();
 public List < Discrepancy__c > discrepancyListUpdateDis = new List < Discrepancy__c > ();
 List < SelectOption > optionsAppr = new List < SelectOption > ();
 public Boolean showDiscrepancyDis {
  get;
  set;
 }
 public boolean addrowDiscDis {
  get;
  set;
 }
 public String StrAppr {
  get;
  set;
 }
 public String StrCOAppr {
  get;
  set;
 }
 public String salesApprovedRate {
  get;
  set;
 }
 List < CAM__c > allCAM1 = new List < CAM__c > ();
 public String salesApprovedPF {
  get;
  set;
 }
 public boolean showOPApprovePanel {
  get;
  set;
 }
 public Contact conObj {
  get;
  set;
 }
 public List < Discrepancy__c > getdiscrepancyData() {
  return discrepancyData;
 }
 public List < Discrepancy__c > getdiscrepancyList() {
  return discrepancyList;
 }
 public List < Discrepancy__c > getsanctionList() {
  return sanctionList;
 }
 public List < SelectOption > getApplicantList() {
  return optionsApplicant;
 }
 public String getStrVAContact() {
  return StrVAContact;
 }
 public void setStrVAContact(String StrVAContact) {
  this.StrVAContact = StrVAContact;
 }
 /* new varible for defferal implementqation */
 public List < Checklist__c > objchecklistDis {
  get;
  set;
 }
 List < Checklist__c > objchecklistLog = new List < Checklist__c > ();
 List < Checklist__c > objchecklist = new List < Checklist__c > ();
 public Boolean add1Dis {
  get;
  set;
 }
 public Boolean add2Dis {
  get;
  set;
 }
 public Boolean viewDis {
  get;
  set;
 }
 public Boolean OTPFlowFlag {
  get;
  set;
 }
 //integer objchecklistcount;
 integer objchecklistDiscount;
 List < Checklist__c > objchecklisttDis = new List < Checklist__c > ();
 List < Checklist__c > objchecklisttoupdateDis = new List < Checklist__c > ();
 List < Checklist__c > objchecklisttodeleteDis = new List < Checklist__c > ();
 List < Checklist__c > objchecklisttoupdate = new List < Checklist__c > ();
 List < Checklist__c > objchecklisttodelete = new List < Checklist__c > ();

 //public List<Checklist__c> PropertyDocumentsDis = new List<Checklist__c>();
 public List < Checklist__c > PropertyDocumentsTempDis = new List < Checklist__c > ();
 public Boolean viewChecklistDis {
  get;
  set;
 }
 public List < Checklist__c > getobjchecklisttDis() {

  return objchecklisttDis;
 }
 Opportunity Oppty = new Opportunity();
 public Opportunity getobjOppty() {
  return Oppty;
 }
 List < SelectOption > optionsdocApp = new List < SelectOption > ();
 List < SelectOption > optionsListApp = new List < SelectOption > ();
 public List < SelectOption > getStrAppItems() {
  return optionsdocApp;
 }

 public List < SelectOption > getStrAppList() {
  return optionsListApp;
 }


 public Boolean sendMssgDoc {
  get;
  set;
 }
 public Boolean sendMssgDoc1 {
  get;
  set;
 }
 public String saveErrMsg {
  get;
  set;
 }
 public Boolean viewSaveErrMsg {
  get;
  set;
 }
 boolean error1 = false;
 public Boolean geterror1() {
  return error1;
 }
 // new variables added
 List < SurrogateCAM__c > ScamList = new List < SurrogateCAM__c > ();
 public SurrogateCAM__c Scam {
  get;
  set;
 }
 //cibil watch Pramod S
 public boolean cibilWatch {
  get;
  set;
 }
 //cibil watch Pramod E

 //SHOL communication S
 public boolean DGflag {
  set;
  get;
 }
 //SHOL communication E
 //Added By Rajendra For HBLS Product
 public boolean isNewProductFlowEnabled {
  get;
  set;
 }
 //Ended Here

 //Bug# 12646 S
 public boolean isCommunityUsr {
  get;
  set;
 }
 //Bug# 12646 E
 //14200 S

 public List < SelectOption > getoptionList() {
  List < SelectOption > optionList = new List < SelectOption > ();
  optionList.add(new SelectOption('', '--None--'));
  optionList.add(new SelectOption('ECS', 'ECS'));
  optionList.add(new SelectOption('ESCROW', 'ESCROW'));
  optionList.add(new SelectOption('Security Cheque', 'Security Cheque'));
  optionList.add(new SelectOption('Cancelled Cheque', 'Cancelled Cheque'));
  //17547--S
  if (showSALPL == true) {
   optionList.add(new SelectOption('SI', 'SI')); //Bug 17547 - SALPL_2.0 - OPS
  }
  //17547--E
  return optionList;
 }
 //14200 E
 //15580 S
 //17547- S
 public boolean showSALPL {
  get;
  set;
 }
 public Set < String > salplLabel = new Set < String > ();
 public boolean showSALCmp {
  get;
  set;
 } //Bug 17547 (Garima) Open component based on Product
 public Set < String > salPricingProd = new Set < String > (); //Bug 17547 (Garima) Open component based on Product
 //17547--E
 public boolean renderclonebank {
  get;
  set;
 }
 public String applicantDedupe {
  get;
  set;
 }
 //15580 E

 /*BUG-16959 added Prod condition for DBOL  by Rajesh */
 public boolean isPSBLProductLineProduct {
  get;
  set;
 }
 public boolean isPSBLProductLineCommunicationSkipEnabled {
  get;
  set;
 }

 // 17479 - VAS FOR UNSECURED SME Start
 public List < SelectOption > getVASList() {
  List < SelectOption > optionVAS = new List < SelectOption > ();
  optionVAS.add(new SelectOption('--None--', '--None--'));
  if (Label.CPP_SHIELD_VAS_Labels != null) {
   for (String prod: Label.CPP_SHIELD_VAS_Labels.split(',')) {
    optionVAS.add(new SelectOption(prod, prod));
   }
  }
  return optionVAS;
 }

 public boolean getshowVAS() {
  if (Label.CPPShield_Products.contains(Loan.Product__c))
   return true;
  else
   return false;
 }
 // 17479 - VAS FOR UNSECURED SME Start
 
    //Bug 22987 - FAS sourcing channel changes : Start
    public boolean isFASSourcingChannel;
    public boolean getisFASSourcingChannel(){
        boolean flag = false;
        try{
            if( Loan!=null && Loan.Sourcing_Channel__r!=null && String.isNotBlank( Loan.Sourcing_Channel__r.Name  )){
                flag = Label.FAS_Sourcing_Channels.split(';').contains( Loan.Sourcing_Channel__r.Name );
            }
            System.debug('getisFASSourcingChannel : '+flag);
        }catch(Exception e){
            System.debug('Exception : '+e);
        }
        return flag;
    }
    
    public void setisFASSourcingChannel(boolean isFASSourcingChannel){
        this.isFASSourcingChannel = isFASSourcingChannel;
    }
    //Bug 22987 - FAS sourcing channel changes : End

 //24028 S
    public static Boolean centralisedTopUp{get;set;}
    public static Decimal Current_BFL_FRR{get;set;}
    //24028 E
 public PricingDisbmntDetails_Ctrl() {
       //24028 S
     centralisedTopUp=false;     
     //24028 E
  // cibilWatchComm = false;//added for bug id 20296 
  callCenterProcessFlag = false;
  salLineFlag = false;
  autoTopUp = false;
  salMobilityFlag = false;
  //BUG ID 17470 
  isPROProductLineProduct = false;
  system.debug('label:-' + Label.Top_Up_Unsecured_Products);
  isNewProductFlowEnabled = false;
  //V1 Refinement Enhancement Start

  /*Responsys API Integration - added by Krish start*/
  rrMaster = new List < Rack_Rate__c > ();
  rrMaster = [SELECT name, Products__c, SMS_Text__c, Additional_SMS_Text__c, Campaign_Name__c, ReceipientsAPINames__c, resendFlag__c, SMS_Type__c, Dynamic_Parameters__c, isPriority__c, Event__c, Used_For__c from Rack_Rate__c where(Used_For__c = 'Responsys'
   or Used_For__c = 'Value First') AND(Event__c = 'Flexi SMS Cust'
   OR Event__c = 'Flexi SMS Int'
   OR Event__c = 'custagreementMsg')]; //changed event name from Customer Agreement SMS to custagreementMsg for bug id 16165
  String productListRes = '';
  if (AtosParameters__c.getValues('ResponsysAPI') != null && AtosParameters__c.getValues('ResponsysAPI').Product__c != null)
   productListRes = AtosParameters__c.getValues('ResponsysAPI').Product__c;
  setProdRes.addAll(productListRes.split(';'));
  system.debug('rrMaster' + rrMaster);
  /*Responsys API Integration - added by Krish e*/
  List < StaticResource > staticRsrcList;
  StaticResource staticRsrc = new StaticResource();
  StaticResource SRCust = new StaticResource();
  staticRsrcList = [SELECT Body, Id, Name FROM StaticResource WHERE(Name = 'ResponsysAPIIntegration'
   OR Name = 'SalariedCustomSettings'
   OR Name = 'PricingGridFormulas') limit 3];
  for (StaticResource rsrc: staticRsrcList) {
   if (rsrc.Name == 'ResponsysAPIIntegration') {
    staticRsrc = rsrc;
   }
   if (rsrc.Name == 'SalariedCustomSettings') {
    SRCust = rsrc;
    sendpricingemail = rsrc; //salpl commercial consent
   }
   if (rsrc.Name == 'PricingGridFormulas') {
    SRFormula = rsrc;
   }

  }
  //V1 Refinement Enhancement End  
  //--------------- Mortgage Re-Engg Start---------------------
  //Pankaj: Capturing ECS barcode
  DuplicateLAN = '';
  DuplicateBarCodeNo = '';
  DuplicateLoanId = '';
  repayFlag = false;
  nachedFlag = 0;
  Mortgageflag = false;
  CentralisedOpsShow = false;
  objdiscrepancyKitList = new List < Discrepancy__c > ();
  fees1 = new List < Fees_and_Charge__c > ();


  //--------------- Mortgage Re-Engg End-----------------------
  //code added by Suraj-pricing email enhancement-start
  sendCommercialMailSelfemployed = false;
  //code added by Suraj-pricing email enhancement-end
  //SHOL communication S
  DGflag = false;
  //SHOL communication E
  //OTPv3 TeleRM Rohit 15229 start
  if (Label.Salaried_Products_for_Pricing != null) {
   String[] arr = Label.Salaried_Products_for_Pricing.split(';');
   for (String str: arr)
    salariedProducts.add(str);
  }
  //OTPv3 TeleRM Rohit 15229 stop
  //Bug# 12646 S
  ID Proid = Userinfo.getProfileID();
  String profName = [select id, name from Profile where id =: Proid].name;
  isCommunityUsr = CommonUtility.hasCommunityProfile(new Set < String > {
   profName
  });
  //Bug# 12646 E


  //ops process added by priya start
  opsProductsFlag = false;
  string opsProducts = System.Label.ops_process_product;
  opsProducts = opsProducts.toUpperCase();
  System.debug('#####' + opsProducts);
  //ops process added by priya end
  objchecklistDis = new List < Checklist__c > ();
  objSurrogateCAM = new SurrogateCAM__c(); // Line assignment
  if (System.currentPageReference() != null && System.currentPageReference().getParameters() != null && System.currentPageReference().getParameters().get('grouptype') != null)
   Grouptype = System.currentPageReference().getParameters().get('grouptype');
  try {

   sanctionList = new List < Discrepancy__c > ();
   FinnOne = new List < FinnOne_Report__c > ();
   checklistTrnxList = new List < Checklist__c > ();
   if (System.currentPageReference() != null && System.currentPageReference().getParameters() != null && System.currentPageReference().getParameters().get('Id') != null)
    LoanId = System.currentPageReference().getParameters().get('Id');
   //Bug# 13793 S
   //17556 s
   if (loanIdfoMob != null) {
    LoanId = loanIdfoMob;
    salMobilityFlagV2 = true;
   } else
    salMobilityFlagV2 = false;
   system.debug('loan for mob' + loanIdfoMob + salMobilityFlagV2);
   //17556 e
   if (System.currentPageReference() != null && System.currentPageReference().getParameters() != null && System.currentPageReference().getParameters().get('Id') != null)
    lanId = System.currentPageReference().getParameters().get('Id');
   hasInitiated = false;
   renderTopUp = false;
   //isTopUp=false;
   //Bug# 13793 E
   //Bug# 13793 S
   system.debug('label:-' + Label.Top_Up_Unsecured_Products);
   if (Label.Top_Up_Unsecured_Products != null) {
    system.debug('label:-' + Label.Top_Up_Unsecured_Products);
    String[] arr1 = Label.Top_Up_Unsecured_Products.split(';');
    for (String str1: arr1) {
     topuplbl.add(str1.ToUpperCase());
    }
   }
   //Bug# 13793 E
   savedSuccessfull = false;
   showOPApprovePanel = false;
   showsubhold = false;
   showsave = false;
   showSALPL = false; //17547
   showback = false;
   //emaildomin
   EmailDomainCheck = false;
   message = '';
   //cibil watch Pramod S
   cibilWatch = false;
   //cibil watch Pramod E
   //15580 S
   renderclonebank = false;
   //15580 E
   //Commented  by Mahima -  bug- 11368 start
   //Charges API Enhacement Start
   /*chargesAPIManual = false;
         chargesAPIAuto = false;

         boolean ChargesAPIIntegration = LaonApplicationCreation__c.getValues('Charges API Integration').Integrate_Charges_API__c;
         if (ChargesAPIIntegration == true) {
             chargesAPIAuto = true;
             chargesAPIManual = false;
         } else {
             chargesAPIManual = true;
             chargesAPIAuto = false;
         }*/
   //Charges API Enhacement End
   //Commented  by Mahima -  bug- 11368 end

   //system workflow Enhancement Pramod S
   SOLStampdate = null;
   SOLStampFlag = false;
   //system workflow Enhancement Pramod E
   //charges API Enhancement start added Loan_Amount__c,Due_Day__c,Scheme_Master__r.Scheme_Code__c, in query
   //Bug# 13793 added CUSTOMER__c S
   //13793-15554--added Loan_Variant__c
   //15580 added CIF_Id__c,Dedupe_Linking_Done__c
   if (LoanId != null) {
    system.debug('inside loan');
    //bug 7061 -digital lounge system workflow added Flow__c,CUSTOMER__r.Owner.Email in query.
    //13901 added Scheme_Master__r.Blind_Data_Entry__c
    //Cash in 60 mins IFSC_Code__c, A_C_No__c, Mode_of_Disbursal__c, Bank_Name__c, Account_Holder_Name__c,Scheme_Master__r.flexi_flag__c Account.Mobile__c,Flexi_Customer_A_C_Number__c
    //Cash in 60 mins Repayment_Mode__c,Repayment_Account_Holder_Name__c,Account.Date_of_Birth__c,Account.Mobile__c.Account.Accountant_email_id__c,A_C_No__c,Account_Holder_Name__c ,A_C_Type__c,Scheme_Master__r.flexi_flag__c
    //Rate Approval Scheme_Master__r.flexi_flag__c, Scheme_Master__r.PLOC_scheme__c,Year_of_Incorporation__c 
    //V1 Refinement Enhancement Field Added to query Project_Name__r.Builder_Name__r.Builder_Category__c, Branch_Name__r.Branch_Type__c, Commitment_Fees__c, Nature_of_property__c BT_Bank_Type__c, BT_Amount__c, Top_Up_Amount__c, Requested_BT_ROI__c, Requested_Top_ROI__c, Requested_BT_PF__c, Requesetd_Top_PF__c
    Loan = [select /*Bug Id - 22425 */ Account.Process_Flow__c, /*Bug 19193 Start */ Scheme_Master__r.istopup__c, /*Bug 19193 End*/ /*17556 s*/ Area_SM__r.Email /*17556 e*/ , /* SAL Mobility Addition CR - Aman Porwal - S*/ Account.Flow__c, /* SAL Mobility Addition CR - Aman Porwal - E*/ /*Rohit 16111 S*/ Account.Current_State__c, /*Rohit 16111 E*/ id, Bundled__c, Branch_Name__r.Branch_Type__c, Loan_Variant__c, Commitment_Fees__c, Account.BT_Bank_Type__c, /*SAl Interest Subvention Rohit S bug id 12941*/ Account.Interest_Subvention_Applicable__c, /*SAl Interest Subvention Rohit E bug id 12941*/ CUSTOMER__c, Account.Year_of_Incorporation__c, Scheme_Master__r.PLOC_scheme__c, Account.Name, ACM__r.Email, Relationship_Manager__r.Email, Sourcing_Channel__r.sourcing_channel_email_id__c, Sourcing_channel_email_id__c, Account.Current_Email_Id__c, Repayment_Mode__c, Repayment_Account_Holder_Name__c, Account.Date_of_Birth__c, Account.Accountant_email_id__c, A_C_Type__c, A_C_No__c, Mode_of_Disbursal__c, Account_Holder_Name__c, Scheme_Master__r.flexi_flag__c, Flexi_Customer_A_C_Number__c, CPA_Acceptance_time__c, Sales_Kit_Pick_Date__c, CUSTOMER__r.Flow__c, CUSTOMER__r.Owner.Email, Sales_Submit_to_Branch_Ops_Date__C, File_Accept_Status__c, Dispatch_time__c, Agreement_Kit_Accepted_by_CPA__c, Agreement_Kit_Picked__c, Sent_To_Finnone__c, LAN__c, Disbursal_Date__c, Disbursed_Amount__c, Created_Time__c, QDP__c, Area_SM__c, Relationship_Manager__r.name, Date_of_created_date__c, Owner.Name, Original_Approver__c, Decision_Time__c, Loan_Amount_with_Premium__c, Approved_Loan_Amount__c, Approved_Rate__c, Approved_Tenor__c, Loan_amt_with_premium__c, Insurance_Premium_Amt__c, online_salaried_app__c, /* Salaried */
     Reject_Reason__c, Sales_Backend__c, name, Risk_Deviations__c, CRO_Deviations__c, CPA__c, ACM__c, RCM__c, NCM__c, CRO__c, RISK__c, COO__c, ACM_Comments__c, RCM_Comments__c, COO_Comments__c, Eligible_for_cross_sell__c, Products_for_cross_sell__c, Cross_sell_comments__c,
     Approval_Stages__c, Approver__c, Loan_Application_Number__c, Product__c, Loan_Type__c, Relationship_Manager__c, AccountId, CreatedDate,
     OwnerId, CreatedById, Scheme_Master__c, Scheme_Master__r.Name, Scheme_Master__r.Blind_Data_Entry__c, Industry__c, Credit_Program__c,
     Sub_Industry__c, Existing_Customer__c, Finance_Amount__c, Tenor__c, Main_Sector__r.Sector__c, Main_Industry__c, Main_Sub_Industry__c,
     Type_Of_Loan__c, amount, Employee_Type__c, stagename, Probability, EMI_CAM__c,
     ForecastCategoryName, File_Acceptance__c, Discrepancy_Status__c, Min_PF__c, Min_Insurance__c, Min_Rate__c, CUSTOMER__r.Name,
     Type_of_Constitution__c, Application_Form_Number__c, If_Yes__c, Final_Authority__c,
     Branch_Name__r.name, Sourc_Mobile__c, ASM_Mobile__c, Sales_Backend_Mobile__c, Verification_Initiated__c, Referral__c,
     Sourcing_Channel__c, Current_UserRole__C, CEO__c, CEO__r.name, RCM__r.name, NCM__r.name,
     RISK__r.name, COO__r.name, CRO__r.name, Comments__c, No_of_Properties__c, Loan_Amount__c, Due_Day__c, Scheme_Master__r.Scheme_Code__c,
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
     Acc_InsurFundedType__c, Acc_Type_of_Policy__c, Acc_InsurCompanyName__c,
     Acc_InsurStartDate__c, Acc_InsurPremiumAmount__c, Acc_InsurSumAssured__c,
     Requested_ROI__c, Processing_Type__c, Account.IS_OTP_FLOW__c, /*bug 14773 s*/ Account.Group_Type__c, /*bug 14773 e*/
     Life_InsuranceRemarks__c, Type_of_Borrower__c, MonthlyBonus__c, Loan_Application_Flow__c, Program_Type__c,
     CampaignId, Business_IRR__c, POS__c, BranchName__c, Financed_by_BFL__c, Disbursement_Type__c, Tranche_Count__c, City_Head__c, UnHold__c,
     CL_Region__c, Pricing_Details_Approved_by__c, Region__c, Old_Product__c, account.Years_in_Bus__c, CAM_Expiry_Date__c, CAM_Preparation_Date__c, Business_Head__c, Centralized_ACM__c,
     AMC__c, City_SM__c, Regional_SM__c, Zonal_SM__c, National_SM__c, Centralized_RCM__c, Customer_Reference_Number__c, SMS_to_be_Sent__c, ACM__r.Mobile_number__c, Approved_time_after_Reappraisal__c, Decision_Date__c, Interior_Designer__c, Service_Availed__c,
     ASM_email_id__c, If_Top_up_Existing_LAN_no__c, Account.Mobile__c, /*Bug 14506 - HFC Fields - SFDC*/ Account.Type_of_facility__c, /*Bug 14506 - HFC Fields - SFDC*/
     /*Mortgage*/
     (select id, Max_Permissible_LTV__c, name /*V1 refinement Enhancement Start*/ , Nature_of_property__c, BT_Amount__c, Top_Up_Amount__c, Requested_BT_ROI__c, Requested_Top_ROI__c, Requested_BT_PF__c, Requesetd_Top_PF__c, Project_Name__r.Builder_Name__r.Builder_Category__c /*V1 refinement Enhancement End*/ , Amount_fund_property__c from Property_Details__r), ELC_offer_accepted__c, Sourcing_Channel_Type__c, Business_Head__r.Email, Business_Head__r.Name, /*Prajyot-Pricing*/ Application_Source__c, account.Type_Of_Industry__c, Account.Employer__r.Company_Name__c, Account.Employer__r.name, Account.Employer__r.Company_Category__c, account.Name_of_the_Company_Employer__c, Net_Loan_to_POS__c,
     /*Bug 12108*/
     (Select New_line_assigned__c, Products__c, lead_source__c, Product_Offering_Source__c from Product_Offerings__r limit 1) /*Bug 12108*/
     /* Added By Ankush Start */
     , Account.Stamped_ROI_BT_ROI__c, Account.Stamped_Top_UP_ROI__c, Account.Stamped_PF__c, Account.Stamped_Insurance__c
     /*Added By Ankush End */
     /*Dedupe linikng 13901 start*/ , (select id, name, Applicant_Type__c, Contact_Name__c, Contact_Name__r.CIF_Id__c, Dedupe_Linking_Done__c from Loan_Application__r)
     /*Dedupe linikng 13901 End*/
     /*hybrid flexi :akshata*/
     , Scheme_Master__r.IsHybridFlexi__c
     /* Bug 14405 - BRD_Communication- Hybrid Flex Start */
     , Scheme_Master__r.is_Pure_Flexi__c, /* Bug 14405 - BRD_Communication- Hybrid Flex End */
     CM__c, CM_Amount__c, CM_Deviations__c, SCO__c, SCO_Amount__c, SCO_Deviations__c, CM__r.Mobile_number__c, SCO__r.Mobile_number__c, CM__r.name, SCO__r.name /*Bug id : 13016 - New Role Creation for Credit, added by Needhi*/
     /*Added BY Ankush Bug 14128 Start */
     , /* Added fields in queries-verification and sourcing chanel- Customer_Bank_Acc_Confirmation__c, Customer_Bank_Acc_Confirmation_IP__c,Verification_Type__c,Valuation_Type__c and Sourcing_Channel__r.Channel__c  Bug-22141*/ (select id, Level_of_Activity__c, Status__c, Customer_Bank_Acc_Confirmation__c, Customer_Bank_Acc_Confirmation_IP__c, Verification_Type__c, Valuation_Type__c from Verification__r ORDER BY CreatedDate DESC) /*Added BY Ankush Bug 14128 End*/
     /* Bug 15422 - Auto Approval - Loan Against Insurance_Revised Start */
     , Sourcing_Channel__r.Name, Sourcing_Channel__r.Channel__c /* Bug 15422 - Auto Approval - Loan Against Insurance_Revised Start */
     /*Bug 16173 - VRPL changes for HFC Strat*/
     , Scheme_Master__r.VRPL_Flag__c /*Bug 16173 - VRPL changes for HFC End*/
     /*Bug:19193 -  Top Up Changes Start : Garima */
     // Bug 23332 s
     ,(Select Id from Personal_Discussion_s__r where Loan_Application__c =: LoanId  Limit 1 )
     // Bug 23332 E
     ,(Select Id, DisbursementType__c, BalanceAmount__c from TelePDQuestionsMaster__r) /*Bug:19193-Top Up Changes End : Garima*/ /*Bug 22425 CC Code changes SME S */ , (SELECT Id, Flow_Identifier__c, CC_Number__c from SOL_Policys__r where Flow_Identifier__c = 'CC_MCP_DDUP'
      Limit 1) /*Bug 22425 CC Code changes SME E */ from Opportunity where id =: LoanId
    ];
    
    // Bug 23332 s
    if(Loan != null && Loan.Personal_Discussion_s__r != null && Loan.Personal_Discussion_s__r.size()>0 && Loan.Personal_Discussion_s__r[0] != null)
       PDobjId = Loan.Personal_Discussion_s__r[0].Id;
    // Bug 23332 E
    
    //Bug:19193 -  Top Up Changes Start : Garima                
    topUpChange(Loan);
    //Bug:19193 -  Top Up Changes End : Garima
    /*Bug 22425 CC Code changes SME S */
    IsCreditatPO = false;
    if (!commonUtility.isEmpty(Loan) && Loan != null && !commonUtility.isEmpty(Loan.SOL_Policys__r) && String.isNotBlank(Loan.SOL_Policys__r[0].CC_Number__c) && Loan.SOL_Policys__r[0].CC_Number__c != null && Loan.SOL_Policys__r[0].CC_Number__c != '') {
     IsCreditatPO = true;
    }
    /*Bug 22425 CC Code changes SME E */
    // BUG ID 17470 S
    transient set < string > setPROProdName = new set < string > ();
    if (!commonUtility.isEmpty(Label.PRO_ProductLine_Products))
     setPROProdName.addAll(Label.PRO_ProductLine_Products.split(';'));
    isPROProductLineProduct = setPROProdName.contains(Loan.Product__c);

    //BUG ID 17470 E
     //24028 S
       if(Loan.Product__c=='SBS CS SAL' && Loan.Scheme_Master__c !=null && String.isNotBlank(Label.CentralisedTopUp) /*&& (Loan.Scheme_Master__r.Scheme_Code__c=='101109' || Loan.Scheme_Master__r.Scheme_Code__c=='101110')*/ ) {
         if(!CommonUtility.isEmpty(Loan.Scheme_Master__r.Scheme_Code__c)){
            String[] schemeCodes = Label.CentralisedTopUp.split(';');
           for(string str: schemeCodes){
               if(str==Loan.Scheme_Master__r.Scheme_Code__c){
                   centralisedTopUp=true;    
                   break;
               }
           }
         }             
       }
     //24028 E
    //Bug# 13793 S
    //14200--added Repayment_Mode__c
    List < RePayment_mode_detail__c > reModeObjLst = new List < RePayment_mode_detail__c > ();
    reModeObjLst = [select id, Repayment_Mode__c from RePayment_mode_detail__c where Loan_Application__c =: LoanId limit 1];
    if (reModeObjLst != null && reModeObjLst.size() == 0 && Loan.Sent_To_Finnone__c == false) { //15580 added && Loan.Sent_To_Finnone__c==false
     hasInitiated = true;
    } else {
     hasInitiated = false;
    }
    //Bug# 13793 E
    //15580 S
    if (Loan.Sent_To_Finnone__c == false) {
     renderclonebank = true;
    }
    //15580 E
    //added by akshata :Hybrid Flexi Inhancement : Start
    if (!CommonUtility.isEmpty(loan.Scheme_Master__c) && !CommonUtility.isEmpty(loan.Scheme_Master__r.IsHybridFlexi__c) && loan.Scheme_Master__r.IsHybridFlexi__c == true)
     IsHybridFlexi = true;
    else
     IsHybridFlexi = false;
    System.debug('isHybridFlexi -->' + IsHybridFlexi);
    //added by akshata :Hybrid Flexi Inhancement : End 
    //IMPS Account validation :S
    IMPSsecShow = false;
    IMPSResultLst = new List < Current_Disbursal_Details__c > ();

    List < String > temp;
    if (Label.IMPS_Product != null)
     temp = String.valueOf(Label.IMPS_Product).split('-');

    List < String > IMPSProd;
    List < String > IMPSProfile;
    if (temp != null && temp.size() > 0 && temp[0] != null && temp[1] != null) {
     IMPSProd = temp[0].split(';');
     IMPSProfile = temp[1].split(';');
     if ((new Set < String > (IMPSProd)).Contains(Loan.product__c) && (new Set < String > (IMPSProfile)).Contains(profName)) {
      IMPSsecShow = true;
     } else {
      IMPSsecShow = false;
     }
    }
    //IMPS Account validation :E
    
    /*SAL PLTB Bug 12108 start - krish*/
    system.debug('inside po 12345' + loan.Product_Offerings__r + loan.Product_Offerings__r.size());
    if (loan.Product_Offerings__r != null && loan.Product_Offerings__r.size() > 0) {
     system.debug('inside po');
     Product_Offerings__c productoffer = loan.Product_Offerings__r[0];
     String prod = productOffer.Products__c;

     if (productOffer.New_line_assigned__c == true || productOffer.Product_Offering_Source__c == 'Cibil 2' || productOffer.Product_Offering_Source__c == 'CIBIL 2') {
      //Cibil Watch End
      if (ProductSMS__c.getValues('SalariedLineAsignmentProducts') != null) {
       String products = ProductSMS__c.getValues('SalariedLineAsignmentProducts').Produtc__c;
       if (products != null) {
        system.debug('***products***' + products);
        String[] arr = products.split(';');
        for (String str: arr) {
         if (str.ToUpperCase() == prod.ToUpperCase()) salLineflag = true;
        }
       }
      }
     }
     if (ProductSMS__c.getValues('DGAutoTopUp') != null && ProductSMS__c.getValues('DGAutoTopUp').Produtc__c != null) {
      List < String > product = new List < String > ();
      product = ProductSMS__c.getValues('DGAutoTopUp').Produtc__c.split(';');
      for (String pro: product) {
       if ((productOffer.Product_Offering_Source__c == 'DIPOS' || productOffer.Product_Offering_Source__c == 'DGAUTOTOPUP') && pro.toUpperCase() == productOffer.Products__c.toUpperCase()) {
        autoTopUp = true;
       }
      }

     }

     if (productOffer != null && productOffer.Lead_Source__c != null) {
      //Optimised for Call Center by Pramod S
      if (ProductSMS__c.getValues('SalariedLineAsignmentProducts') != null) {
       String products = ProductSMS__c.getValues('SalariedLineAsignmentProducts').Produtc__c;
       if (products != null) {
        system.debug('***products***' + products);
        String[] arr = products.split(';');
        for (String str: arr) {
         callCentreProdlbl.add(str.ToUpperCase());
        }
       }
      }
      if (Label.Call_Centre_Idetifier != null) {
       system.debug('label:-' + Label.Call_Centre_Idetifier);
       String[] arr1 = Label.Call_Centre_Idetifier.split(';');
       for (String str1: arr1) {
        callCentrelbl.add(str1.ToUpperCase());
       }
      }
      System.debug('productoffer' + productoffer);
      if (callCentreProdlbl != null && callCentreProdlbl.size() > 0 && callCentrelbl != null && callCentrelbl.size() > 0) {
       system.debug('inside callCentreProdlbl' + callCentreProdlbl + 'callCentrelbl' + callCentrelbl);
       if (callCentreProdlbl.contains(prod.ToUpperCase())) {
        if (callCentrelbl.contains(productOffer.Lead_Source__c.ToUpperCase())) {
         callCenterProcessFlag = true;
        }
       }
      }
     }
    }
    system.debug('callCenterProcessFlag ' + callCenterProcessFlag + autoTopUp + salLineflag);
    /*SAL PLTB Bug 12108 end - krish*/
    //Rate Approval start
    rateflag = false;
    appValid = false;
    branchValid = false;
    transient string ProductForFlowLabel = Label.New_Products_for_Flow;
    if ((Loan != null && Loan.Product__c != null && ProductForFlowLabel != null && ProductForFlowLabel != '' && ProductForFlowLabel.contains(Loan.Product__c)))
     isNewProductFlowEnabled = true;
    if (ProductSMS__c.getValues('RateApp') != null && ProductSMS__c.getValues('RateApp').Produtc__c != null) {
     rateflag = new Set < String > (ProductSMS__c.getValues('RateApp').Produtc__c.split(';')).contains(Loan.Product__c.toUpperCase());
     appValid = ProductSMS__c.getValues('RateApp').RA_Approve_Valid__c;
     branchValid = ProductSMS__c.getValues('RateApp').RA_Branch_Valid__c;
    }
    //Rate Approval end

    //Charges API Enhacement Start
    // Mahima -  bug- 11368-start
    chargesAPIManual = false;
    chargesAPIAuto = false;
    boolean ChargesAPIIntegration = false;
    boolean ChargesAPIIntegrationprod = LaonApplicationCreation__c.getValues('Charges API Integration').Integrate_Charges_API__c;
    String[] productsChargesList;
    string productsCharges;
    if (ChargesAPIIntegrationprod == true) {
     productsCharges = LaonApplicationCreation__c.getValues('Charges API Integration').Products__c;
     if (productsCharges != null && productsCharges != '')
      productsChargesList = productsCharges.split(',');
     if (productsChargesList != null && productsChargesList.size() > 0) {
      for (string prod: productsChargesList) {
       if (Loan.Product__c != null && Loan.Product__c.ToUpperCase() == prod.ToUpperCase()) {
        ChargesAPIIntegration = true;
        break;
       } else
        ChargesAPIIntegration = false;

      }
     }
     system.debug('***ChargesAPIIntegration if *' + ChargesAPIIntegration);
    }
    system.debug('***ChargesAPIIntegration *' + ChargesAPIIntegration);
    if (ChargesAPIIntegration == true) {
     chargesAPIAuto = true;
     chargesAPIManual = false;
    } else {
     chargesAPIManual = true;
     chargesAPIAuto = false;
    }
    //Charges API Enhacement End
    //by Mahima -  bug- 11368 end

    //Rate Approval end
    //Bug 14506 - HFC Fields - SFDC By Rajesh START
    account = new Account(Id = Loan.AccountId, Type_of_facility__c = Loan.Account.Type_of_facility__c);
    BHFLProductsFlag = false;
    String BHFLProducts = '';
    if (LaonApplicationCreation__c.getValues('BHFL Products') != null) {
     BHFLProducts = LaonApplicationCreation__c.getValues('BHFL Products').Products__c;
     if (!CommonUtility.isEmpty(BHFLProducts)) {
      SET < String > prodSet = new SET < String > (BHFLProducts.split(','));
      if (!CommonUtility.isEmpty(prodSet) && prodSet.Contains(Loan.product__c))
       BHFLProductsFlag = true;
     }
    }
    //Bug 14506 - HFC Fields - SFDC By Rajesh END

    /*BUG-16959 added Prod condition for DBOL  by Rajesh */
    transient set < string > setPSBLProdName = new set < string > ();
    if (!commonUtility.isEmpty(Label.PSBL_ProductLine_Products))
     setPSBLProdName.addAll(Label.PSBL_ProductLine_Products.split(';'));

    transient set < string > setSkipComm = new set < string > ();
    if (!commonUtility.isEmpty(Label.PSBL_Line_Skip_Communication_Products))
     setSkipComm.addAll(Label.PSBL_Line_Skip_Communication_Products.split(';'));

    isPSBLProductLineProduct = setPSBLProdName.contains(Loan.Product__c);
    isPSBLProductLineCommunicationSkipEnabled = setSkipComm.contains(Loan.Product__c);
    /*BUG-16959 added Prod condition for DBOL  by Rajesh */

    //Ops process added by priya start
    if (opsProducts.contains((Loan.product__c).toUpperCase())) {
     opsProductsFlag = true;
    }
    if (opsProductsFlag && ChargesAPIIntegration)
     getNetdisbAmount();
    //Ops process added by priya end
    //13793 S
    if (topuplbl.contains((Loan.product__c).toUpperCase())) {
     renderTopUp = true;
    }
    //13793 E
    //17547--S
    if (Label.SAL_PL_2_0 != null) {
     system.debug('label:-' + Label.SAL_PL_2_0);
     String[] arr1 = Label.SAL_PL_2_0.split(';');
     for (String str1: arr1) {
      salplLabel.add(str1.ToUpperCase());
     }
    }

    if (salplLabel.contains((loan.product__c).toUpperCase())) {
     showSALPL = true;
    }
    //Bug 17547 (Garima) Open component based on Product Start
    if (Label.salaried_pricing_product != null) {
     String[] prodName = Label.salaried_pricing_product.split(';');
     for (String str1: prodName) {
      salPricingProd.add(str1.ToUpperCase());
     }
    }
    if (salPricingProd != null && !salPricingProd.isEmpty() && salPricingProd.contains((Loan.product__c).toUpperCase())) {
     showSALCmp = true;
    } else {
     showSALCmp = false;
    } //Bug 17547 (Garima) Open component based on Product End
    system.debug('label1:-' + showSALPL);
    system.debug('label2:-' + Loan.product__c);
    //17547--E
    //code added by Suraj-pricing email enhancement-start
    transient String productforCommercialMail = LaonApplicationCreation__c.getValues('sendPricingEmailSelfEmployed').Products__c;
    transient set < String > ProductsforCommercialMail;
    if (productforCommercialMail != null)
     ProductsforCommercialMail = new Set < String > (productforCommercialMail.split(';'));
    if (ProductsforCommercialMail.contains(Loan.product__c)) {
     sendCommercialMailSelfemployed = true;
    }
    //code added by Suraj-pricing email enhancement-end


    //system workflow Enhancement Pramod S
    if (LaonApplicationCreation__c.getValues('Sales Hierarchy Stamping') != null) {
     String SOLDate = LaonApplicationCreation__c.getValues('Sales Hierarchy Stamping').Sales_Hierarchy_Stamping_Date__c;
     if (SOLDate != null) {
      system.debug('***SOLDate***' + SOLDate);
      SOLStampdate = date.parse(SOLDate);
     }
    }
    if (LaonApplicationCreation__c.getValues('Digital Lounge System Workflow Prods') != null) {
     digiLoungeProducts = LaonApplicationCreation__c.getValues('Digital Lounge System Workflow Prods').Products__c;
     if (digiLoungeProducts != null) {
      String[] arr = digiLoungeProducts.split(';');
      for (String str: arr) {
       digiProds.add(str.ToUpperCase());
      }
     }
    }

    //system workflow Enhancement Pramod E
    //4450


    COLStampdate = null;
    COLStampFlag = false;
    System.debug(LaonApplicationCreation__c.getValues('Hierarchy Stamping') + 'LaonApplicationCreation__c.getValues(Hierarchy Stamping)');
    if (LaonApplicationCreation__c.getValues('Hierarchy Stamping') != null) {
     String COLDate = LaonApplicationCreation__c.getValues('Hierarchy Stamping').Credit_Hierarchy_Stamping_Date__c;
     if (COLDate != null) {
      system.debug('***COLDate***' + COLDate);
      COLStampdate = date.parse(COLDate);
     }
    }
    system.debug('***COLStampdate***' + COLStampdate);
    system.debug('*** Loan.createddate***' + Loan.createddate);
    if (COLStampdate != null && Loan != null && COLStampdate < Loan.createddate) {
     COLStampFlag = true;
    }
    system.debug('***COLStampFlag &&&***' + COLStampFlag);
    if (COLStampFlag == true) {
     if (Loan != null) {
      LoanAppFlow = Loan.Loan_Application_Flow__c;
      System.debug('Loan.Loan_Application_Flow__c=' + Loan.Loan_Application_Flow__c + '=Loan.Program_Type__c=' + Loan.Program_Type__c);
      if (LoanAppFlow == null || LoanAppFlow == '') {
       LoanAppFlow = 'Normal';
      }
      System.debug('LoanAppFlow=' + LoanAppFlow);
     }
    }
    //Cash in 60 minutes starts
    ProductSMS__C prodsms = new ProductSMS__C();
    prodsms = ProductSMS__C.getValues('Product for blind data entry');
    String product = prodsms.Produtc__c;
    // OPS Enhancement Blind Data Start
    String schemeName = prodsms.SMS_Text__c;
    schemelist = new List < String > ();
    if (!String.isBlank(schemeName)) {
     schemelist = schemeName.split(';');

    }
    productlist = new List < String > ();
    if (product != null)
     productlist = product.split(';');
    //System.debug('********************productlist'+productlist);
    blindDataFlag = false;
    blindDatapresentFlag = false;
    system.debug('blindDatapresentFlag =====>' + Loan.Product__c);
    isFlexiFlag = false;
    if (productlist.size() > 0) {
     for (String str: productlist) {
      if (str == Loan.Product__c) {
       blindDataFlag = true;
       system.debug('blindDataFlag =====>' + blindDataFlag);
      }
     }
    }
    // OPS : Blind Data S this code will make Blind data skip for Sal Line Utilized Scheme type
    if (schemelist.size() > 0) {
     for (String schemnameIns: schemelist) {
      if (schemnameIns.equalsIgnoreCase(Loan.Scheme_Master__r.Scheme_Code__c)) {
       blindDataFlag = false;
       system.debug('blindDataFlag Updated =====>' + blindDataFlag);
      }
     }
    }
    // OPS : Blind Data E


   }
   if (Loan != null) {


    //SHOL communication S
    if (LaonApplicationCreation__c.getValues('Online Products') != null) {
     String DGproducts = LaonApplicationCreation__c.getValues('Online Products').Current_product__c;
     if (DGproducts != null) {
      system.debug('***OnlineProducts***' + DGproducts);
      String[] arr = DGproducts.split(';');
      for (String str: arr) {
       if (Loan.id != null) {
        if (str.equalsIgnoreCase(Loan.Product__c)) {
         DGflag = true;
        }
       }
      }
     }
    }
    //SHOL communication E



    //--------------- Mortgage Re-Engg Start---------------------
    if (LaonApplicationCreation__c.getValues('Mortgage Products') != null) {
     String MortgageProducts = LaonApplicationCreation__c.getValues('Mortgage Products').Current_product__c;
     if (MortgageProducts != null) {
      system.debug('***MortgageProducts***' + MortgageProducts);
      String[] arr = MortgageProducts.split(';');
      for (String str: arr) {
       if (Loan.id != null) {
        if (str.equalsIgnoreCase(Loan.Product__c)) {
         Mortgageflag = true;
        }
       }
      }
     }
    }


    //code changed by mahima- 11368
    system.debug('---Mortgageflag---' + Mortgageflag);
    if (Mortgageflag == true) {

     chargesAPIAuto = false;
     chargesAPIManual = false;
     //Added by Mahima- prod issue- 15146
     //Code not needed thats why commented the same.     -15318      
     /*String[] mortaggeProductsChargesList;
          string MortageProductsCharges;
           boolean mChargesAPIIntegrationprod=false;
           boolean mChargesAPIIntegration=false;
          if (LaonApplicationCreation__c.getValues('Mortgage Charges API Integration') != null) {
          if(!Test.isRunningtest())
           mChargesAPIIntegrationprod = LaonApplicationCreation__c.getValues('Mortgage Charges API Integration').Integrate_Charges_API__c;
            }
            if (LaonApplicationCreation__c.getValues('Mortgage Charges API Integration') != null) {
              if(!Test.isRunningtest())
             MortageProductsCharges = LaonApplicationCreation__c.getValues('Mortgage Charges API Integration').Products__c;
             }
            if (MortageProductsCharges != null && MortageProductsCharges != '')
            mortaggeProductsChargesList = MortageProductsCharges.split(',');
            if (mortaggeProductsChargesList != null && mortaggeProductsChargesList.size() > 0) {
            for (string prod: mortaggeProductsChargesList) {
            if (Loan.Product__c != null && Loan.Product__c.ToUpperCase() == prod.ToUpperCase()) {
             mChargesAPIIntegration = true;
              break;
            }
            }
            }
            system.debug('mChargesAPIIntegrationprod'+mChargesAPIIntegrationprod);
            system.debug('mChargesAPIIntegration'+mChargesAPIIntegration);
           if (mChargesAPIIntegrationprod == true && mChargesAPIIntegration == true) {
            chargesAPIAuto = false;
            chargesAPIManual = false;
           } else {
            chargesAPIManual = true;
            chargesAPIAuto = false;
           }*/
     //Added by MAhima- prod issue- 15146

    }
    system.debug('---chargesAPIAuto---' + chargesAPIAuto);
    system.debug('---chargesAPIManual---' + chargesAPIManual);
    //--------------- Mortgage Re-Engg End---------------------


    if (Loan.stagename == 'Moved To Finnone') {
     CentralisedOpsShow = true;
    }

    system.debug('---CentralisedOpsShow---' + CentralisedOpsShow);
    if (Mortgageflag) {
     propertyList = new List < Property_Details__c > ();
     propertyList = SelectQueriesHelperClass.QueryPropertyDetailsMortgage(Loan.id);
     System.debug(propertyList.size() + '=propertyList.size()');

     //SHL Requirement
     recommLTV = 0;
     actualLTV = 0;
     LTVtobrCons = 0;
     for (Property_Details__c p: propertyList) {
      if (p.Standard_LTV__c != null) {
       recommLTV += p.Standard_LTV__c;
      }

      if (p.Max_Permissible_LTV__c != null) {
       actualLTV += p.Max_Permissible_LTV__c;
      }

      if (p.LTV_Offered__c != null) {
       LTVtobrCons += p.LTV_Offered__c;
      }

     }
     System.debug('recommLTV=' + recommLTV + '==actualLTV=' + actualLTV + '==LTVtobrCons=' + LTVtobrCons);
     if (recommLTV > 0) {
      recommLTV = recommLTV / propertyList.size();
     }
     if (actualLTV > 0) {
      actualLTV = actualLTV / propertyList.size();
     }
     if (LTVtobrCons > 0) {
      LTVtobrCons = LTVtobrCons / propertyList.size();
     }

     System.debug('recommLTV=' + recommLTV + '==actualLTV=' + actualLTV);

     bankList = new List < Bank_Account__c > ();
     bankList = SelectQueriesHelperClass.QueryBankAccountsMortgage(Loan.id);
     System.debug(bankList.size() + '=bankList.size()');

     List < Fees_and_Charge__c > feesTempList = new List < Fees_and_Charge__c > ();


     feesTempList = SelectQueriesHelperClass.QueryFeesMortgage(Loan.id);
     if (feesTempList.size() > 0)
      feesMortgage = feesTempList[0];
     else {
      feesMortgage = new Fees_and_Charge__c();
      feesMortgage.Identifier__c = 'Mortgage';
      feesMortgage.Loan_Application__c = LoanId;
     }
     System.debug(feesTempList.size() + '=feesTempList.size()');

    }


    //--------------- Mortgage Re-Engg End-----------------------


    //cibil watch Pramod S
    if (Loan.Loan_Application_Flow__c == 'CIBILWatch') {
     cibilWatch = true;
    }
    //cibil watch Pramod E
    allCAM = [select id, name, Approved_CAM__c, Current_Year_PLBS__c, Current_Year_PLBS__r.Year__c, Previous_Year_PLBS__r.Year__c, Previous_Year_PLBS__c, Applicant__r.Contact_Name__c,
     Type_Cust__c, Type_of_Entity__c, Stake_of_co__c, Turnover_CY__c, Turnover_PY__c, Date_of_ITRs_CY__c, Date_of_ITRs_PY__c,
     Diff_Date_ITRs__c, PAT_Entity_CY__c, PAT_Entity_PY__c, Income_from_CY__c, Income_from_PY__c, Diff_Income_both_year__c,
     Rental_income_CY__c, Rental_income_PY__c, Less_TAX_PAID_CY__c, Less_TAX_PAID_PY__c, Diff_in_Tax_Paid__c, Net_Inc_CY__c, Net_Inc_PY__c,
     Diff_in_Net_Inc__c, NP_Consid_PY_Ind__c, Repayment_of_loan__c, Proportionate_depreciation__c, Actual_depreciation_CY__c, Actual_depreciation_PY__c,
     Applicants_share_CY__c, Applicants_share_PY__c, Dep_Consid__c, TOTAL__c, For_12_18_Mths__c, For_24_to_30Mths__c, For_30_36_Mts__c, Eligibility_for_tenor__c,
     Annual_Retail_Oblig__c, Annual_Term_Loan_Oblig__c, MAX_Loan_Amt_Indl__c, Proposed_Loan_Amt__c, IRR_TO__c, Tenor__c, EMI_on_Proposed_Loan_TO__c, Insurance_taken_TO__c,
     Premium_Amount_TO__c, Loan_Amt_Premium__c, EMI_with_Insurance_Premium_TO__c, Interest_Partners_CY__c, Interest_Partners_PY__c, Salary_Partners_CY__c, Salary_Partners_PY__c, Income_NP_Comments__c,
     Interest_on_term_loans__c, ROI__c, TOTAL_Elig_NP__c, Loan_eligibility__c, Max_Loan_Amt_Tier_NP__c, Type_of_CAM_Entity__c, C_P_PY__c, C_P_CY__c, EBITDA_Margins_PY__c,
     EBITDA_Margins_CY__c, EBITDA_Margins_Comments__c, NP_Annl_Retail_Oblig__c, Margin_applicable__c, Imputed_Income__c, Available_NCF__c, Max_Perm_Annl_EMI__c,
     Type_of_Industry__c, Segment_and_activity_Applicable__c, Industry_Margins_applicable__c, Applicant__c, App_Mon_Income__c,
     Debt_Equity_Post_Loan__c, DSCR_post_our_loan__c, Final_Net_An_Inc__c, Total_Income_GP__c, Monthly_CC_OD_interest__c,
     Loan_elig_TO__c, Loan_eligibility_Tier_I_II_TO__c, ELC_Line_Amounts__c, Average_Monthly_Net_Income2__c, Total_Obligation_EBIDTA__c, RTR_CATC_PL_5_lac__c, Movement_in_Debtors_Vs_Sales__c, Applicable_FOIR1__c, Deviation_on_FOIR__c, Max_Loan_Amount_for_IT_Company__c
     //Proposed_Loan_Amount_Comments_Indl__c            
     /*Prajyot For Pricing Mailer*/
     , Business_Continuty__c from CAM__c where Loan_Application__c =: Loan.id
    ];
    //Line assignment
    List < SurrogateCAM__c > ScamList = new List < SurrogateCAM__c > ();
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
     from SurrogateCAM__c where Loan_application__c =: Loan.Id
    ];
    if (ScamList.size() > 0)
     objSurrogateCAM = ScamList[0];
    system.debug('****objSurrogateCAM**' + objSurrogateCAM);


    FinnOne = [select Id, Finnone_Upload_Update__c, Finnone_Upload_Status__c, Finnone_Upload_Flag__c, FinOneSuccess__c, Applicant_ID__c, Applicant_Type__c, Applied_Loan_Amount__c, Loan_Application_Number__c from FinnOne_Report__c where Loan_Application__c =: Loan.id];

    optionscreditCardList.clear();
    optionscreditCardList.add(new SelectOption('-None-', '-None-'));
    optionscreditCardList.add(new SelectOption('Yes', 'Yes'));
    optionscreditCardList.add(new SelectOption('No', 'No'));

    optionsgetloanTypeList.clear();
    optionsgetloanTypeList.add(new SelectOption('-None-', '-None-'));
    optionsgetloanTypeList.add(new SelectOption('Flexi term loan', 'Flexi term loan'));
    optionsgetloanTypeList.add(new SelectOption('Term loan', 'Term loan')); //Replaced Normal Term loan with  Term loan. for bug id 16165
    optionsgetloanTypeList.add(new SelectOption('Step-Up Loan', 'Step-Up Loan'));
    optionsgetloanTypeList.add(new SelectOption('Flexi Hybrid Loan', 'Flexi Hybrid Loan')); //added for bug id 16165
    //pricing email changes start
    optionsgetloanTypeList.add(new SelectOption('LOC', 'LOC'));
    optionsgetloanTypeList.add(new SelectOption('Personal Line', 'Personal Line'));
    optionsgetloanTypeList.add(new SelectOption('Step Up', 'Step Up'));
    optionsgetloanTypeList.add(new SelectOption('Emi Holiday', 'Emi Holiday'));
    if (callCenterProcessFlag || salMobilityFlag || Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL') {
     optionsgetloanTypeList.add(new SelectOption('Flexi Interest-only Loan', 'Flexi Interest-only Loan'));
     // optionsgetloanTypeList.add(new SelectOption('Flexi Hybrid Loan', 'Flexi Hybrid Loan'));//commented for bug id 16165
     optionsgetloanTypeList.add(new SelectOption('Flexi Assigned Limit', 'Flexi Assigned Limit'));
     optionsgetloanTypeList.add(new SelectOption('Step-Down Loan', 'Step-Down Loan'));
    } else {
     //commercial emailer bug 16507 e
     //commented for bug id 16165 start
     //pricing email changes start
     //optionsgetloanTypeList.add(new SelectOption('LOC', 'LOC'));
     //optionsgetloanTypeList.add(new SelectOption('Personal Line', 'Personal Line'));
     // optionsgetloanTypeList.add(new SelectOption('Step Up', 'Step Up'));
     //pricing email changes ends
     //commented for bug id 16165 end
    }
    if (FinnOne.size() > 0)
     FinnOneObj = FinnOne[0];

    sanctionList = [select Discrepancy_Stage__c, Date_Time__c, Party_Type__c, Party_Name__c,
     Discrepancy_Description__c, LoanApplication__c,
     RaiserName__c, Description__c,
     Priority__c, Resolution_Remarks__c, Status__c, Discrepancy_Party__c, Applicant_Name__c,
     Raiser_Role__c, createddate, Category__c,
     Assigned_To__c, Closed_Date__c, Resolver_Name__c, OTPDiscrepancyCategory__c, OTPDiscrepancyDocuments__c, /*Added by sneha for  Bug -18583 Start*/ OTPDiscrepancyProduct__c /*Added by sneha for  Bug -18583 End*/
     /*Mortgage Start*/
     , Remarks__c, Discrepancy_Type__c /*Mortgage End*/
     from Discrepancy__c where LoanApplication__c =: Loan.Id and Type__c = 'SanctionCondition'
     order by Status__c asc, createddate asc
    ];
    //13793 added isTopUp__c
    DisbList = [select id, Disbursement_To__c, /*bug 14773*/ Required__c, /*bug 14773*/ IMPS_Flag__c, Bank_Branch__c, name, Tranche_Detail__c, Loan_Application__c, Internal_Closure__c, Disbursement_Amount__c, Disbursal_Mode__c, Disbursement_Date__c,
     IFSC_Code__c, isTopUp__c, Favouring__c, Tranche_Detail__r.Tranche_Number__c, Bank_Name__c, Bank_Account__c, Payable_at__c, Credit_Days__c, IMPS_Beneficiary_Name__c /* IMPS_Beneficiary_Name 20149 */ , /*IMPS Account validation*/ IMPSDateTime__c, IMPS_Count__c, IMPS_Result__c, Successful_IMPS_Count__c, Failure_IMPS_Count__c, IMPS_Account_Validate__c, IMPS_Transaction_No__c
     from Current_Disbursal_Details__c where Loan_Application__c =: Loan.id
    ];
    System.debug('DisbList :' + DisbList);
    impsEnabled = false; //Bug 21287
    /*IMPS Account Validation :S 13907 */
    //Bug 22141 S
    if (DisbList != null && DisbList.size() > 0) {
     isConfirmBankAccount = true;
    }
    //Bug 22141 E
    //Bug:23767(Related 21287 Prod issue)--S moved 21287 code here of fetching ifsc codes and added where condition in query
    set<String> ifscCodes = new set<String>();
    for (Current_Disbursal_Details__c dis: DisbList) {
        ifscCodes.add(dis.IFSC_Code__c);
    }
    impsEnabledBank = new Set < String > ();
    system.debug('ifsc from page***'+ifscCodes);
    list < IFSC_Master__c > ifscList = [Select Id, IFSC_Code__c, Branch__c from IFSC_Master__c WHERE Is_IMPS_Enabled__c = true AND IFSC_Code__c IN :ifscCodes];
    system.debug('ifscList****'+ifscList);
    for (IFSC_Master__c iList: ifscList) {
     impsEnabledBank.add(iList.IFSC_Code__c);
    }
    //Bug 22123--S (Replaced exisitng with this)
    impsBank = ',';
    for (String s: impsEnabledBank) {
     impsBank += s + ',';
    }
    impsBank = JSON.serialize(impsBank);
    //Bug 22123--E
    //Bug 23767(Related to 21287)--E
    for (Current_Disbursal_Details__c dis: DisbList) {
     System.debug('dis.Successful_IMPS_Count__c -->' + dis.Successful_IMPS_Count__c);
     System.debug('dis.Failure_IMPS_Count__c -->' + dis.Failure_IMPS_Count__c);
     if (dis.IMPS_Count__c == null)
      dis.IMPS_Count__c = 0;
     if (dis.Successful_IMPS_Count__c == null)
      dis.Successful_IMPS_Count__c = 0;
     if (dis.Failure_IMPS_Count__c == null)
      dis.Failure_IMPS_Count__c = 0;
     if (dis.IMPS_Transaction_No__c != null)
      IMPSResultLst.add(dis);
     //Bug 21287--S
     if (impsEnabledBank.contains(dis.IFSC_Code__c)) {
      impsEnabled = true;
     }
     //Bug 21287--E
     System.debug('dis.Successful_IMPS_Count__c12 -->' + dis.Successful_IMPS_Count__c);
     System.debug('dis.Failure_IMPS_Count__c 12-->' + dis.Failure_IMPS_Count__c);
    }
    /*IMPS Account Validation :E 13907 */
    //Cash in 60 min start added A_C_type__c in query // removed ECS_Barcode_No__c
    //17547-- added UMRN__c
    RepayList = [select id, A_C_type__c, UMRN__c, ECS_Barcode_No__c, Open_ECS_Facility__c, Open_ECS_Ex_Customer_Id__c, Open_Valid_till__c, Open_ECS_Max_Limit__c, ECS_Start_Date__c, ECS_End_Date__c, ECS_Amount__c, name, Loan_Application__c, A_C_NO__c, MICR_Code__c, PDC_START_DATE__c, IFSC_Code__c, Account_Holder_Name__c,
     Bank_Name__c, No_of_Cheques__c, Cheque_Serial_Number__c, Repayment_Mode__c, To_Cheque_Serial_Number__c,
     Cheque_Amount__c, Tranche_Detail__c,
     // Bug 4453 - Decentralized Disbursement Process Starts
     Bank_Branch__c, PDC_By_Name__c
     // Bug 4453 - Decentralized Disbursement Process Ends   
     from RePayment_mode_detail__c where Loan_Application__c =: Loan.Id
    ];

    if (RepayList.size() > 0)
     repayFlag = true;
    //added by Suraj...ECS Mandate enhancement
    if (Loan.Pricing_Details_Approved_by__c != null) {
     if (Loan.Approved_Rate__c != null) {
      salesApprovedRate = String.valueof(Loan.Approved_Rate__c);
     }
     if (Loan.Processing_Fees__c != null) {
      salesApprovedPF = string.valueof(Loan.Processing_Fees__c);
     }
    }
    //Pricing Details:By Pritha ; start
    solList = new List < Sales_Officer_Limit__c > ();
    //Pricing Details:By Pritha ; end
    //Pricing Details :By Pritha ; added to query :: FFR_Percent__c, WIRR__c, WPF__c, LI_PREMIUM__c, LI_Percent__c, HI_PREMIUM__c, HI_Percent__c,
    totalSolimt = [select id, FFR_Percent__c, WIRR__c, WPF__c, LI_PREMIUM__c, LI_Percent__c, HI_PREMIUM__c, HI_Percent__c, Sales_Officer_Name__r.email, Sales_Officer_Name__c, Sales_Officer_Name__r.Mobile_number__c, Sales_Officer_Name__r.name, Reporting_Manager_Name__c, /*Prajyot #10317*/ Reporting_Manager_Designation__c,
     Reporting_Manager_Name__r.Mobile_number__c, ASM_Branch__c, Selected_Flag__c, Designation__c, Location__c, Product__c,
     Max_Number__c, /*Prajyot-Pricing */ DesignationCount__c, Reporting_Manager_Name__r.name from Sales_Officer_Limit__c where Active__c = true And Sales_Officer_Name__r.IsActive = true and product__c =: Loan.Product__c and Location__c INCLUDES(: Loan.Branch_Name__r.name)
    ];
    //Pricing Details:By Pritha ; start
    solflag = false;
    System.debug('totalSolimt********' + totalSolimt);
    for (Sales_Officer_Limit__c sol: totalSolimt) {
     System.debug('sol.Sales_Officer_Name__c********' + sol.Sales_Officer_Name__c);
     System.debug('Loan.Relationship_Manager__c********' + Loan.Relationship_Manager__c);
     System.debug('sol.Product__c********' + sol.Product__c);
     System.debug('Loan.Product__c********' + Loan.Product__c);
     System.debug('sol.Designation__c********' + sol.Designation__c);
     System.debug('sol.ASM_Branch__c********' + sol.ASM_Branch__c);
     System.debug('sol.id********' + sol.id);
     System.debug('Loan.Branch_Name__r.name********' + Loan.Branch_Name__r.name);
     if (sol.Sales_Officer_Name__c == Loan.Relationship_Manager__c && sol.Product__c == Loan.Product__c && sol.Designation__c == 'Area Sales Manager' && sol.ASM_Branch__c == Loan.Branch_Name__r.name) {
      solList.add(sol);
     }
    }
    if (solList.size() > 0) solflag = true;
    System.debug('solList.size***' + solList.size() + 'solList' + solList);
    //Pricing Details:By Pritha ; end

    optionsAppr.clear();
    // Prajyot : pricing changes
    map < id, Sales_Officer_Limit__c > solHirearchy = new map < id, Sales_Officer_Limit__c > ();
    for (Sales_Officer_Limit__c sol: totalSolimt) {
     //Rate Approval Functionality:Condition added for SPL
     if ((sol.Product__c == 'SAL' && Loan.Product__c == 'SAL') || (sol.Product__c == 'SPL' && Loan.Product__c == 'SPL')) {
      solHirearchy.put(sol.Sales_Officer_Name__c, sol);
     }
    }
    decimal currentUsercount = 0;
    String currentDesignation = '';
    optionsPriAppr.clear();
    if ( /* Prajyot-Pricing*/ totalSolimt != null && totalSolimt.size() > 0) {
     ID Pid = Userinfo.getProfileID();
     String Pname = [select id, name from Profile where id =: Pid].name;
     for (integer i = 0; i < totalSolimt.size(); i++) {

      if ((totalSolimt[i].Sales_Officer_Name__c != null) && (totalSolimt[i].Location__c != null)) {
       //send to finnone enhancement added to fix the bug 6913 addded null check      
       if (totalSolimt[i].Location__c.toUpperCase().contains(Loan.Branch_Name__r.name.toUpperCase())) {
        if (totalSolimt[i].Designation__c != null) {
         optionsAppr.add(new SelectOption(totalSolimt[i].Sales_Officer_Name__r.name, totalSolimt[i].Sales_Officer_Name__r.name + ' - ' + totalSolimt[i].Designation__c.toUpperCase()));
        }

        //<!--code added by Prajyot-Pricing changes point1 start-->
        String currentName = totalSolimt[i].Sales_Officer_Name__r.Name;


        currentDesignation = totalSolimt[i].Designation__c;

        system.debug('userinfo.getName()=' + userinfo.getName());
        system.debug('currentName=' + currentName);
        system.debug('userinfo.getName()=' + userinfo.getName());
        system.debug('Pname=' + Pname);
        system.debug('currentDesignation=' + currentDesignation);
        if (currentName == userinfo.getName() && Pname == currentDesignation && grouptype == 'salaried') {

         currentUsercount = totalSolimt[i].DesignationCount__c;
         currentManager = totalSolimt[i].Reporting_Manager_Name__c;

         currentManagerDesignation = totalSolimt[i].Reporting_Manager_Designation__c;
         if (totalSolimt[i].Reporting_Manager_Name__c != null) {
          currentManagerName = totalSolimt[i].Reporting_Manager_Name__r.name;
          optionsPriAppr.add(new SelectOption(currentManager, currentManagerName + ' - ' + currentManagerDesignation));
         }
        }


       }
      }


     }
     system.debug('value of optionsPriAppr=' + optionsPriAppr);
     system.debug('current User=' + userinfo.getUserId());
     system.debug('currentManager=' + currentManager);
     for (integer i = 0; i < 10; i++) {
      system.debug('solHirearchy.get(currentManager)=' + solHirearchy.get(currentManager));
      if (currentManager != null && solHirearchy != null)
       if (solHirearchy.get(currentManager) != null && solHirearchy.get(currentManager).Reporting_Manager_Name__c != null) {

        optionsPriAppr.add(new SelectOption(solHirearchy.get(currentManager).Reporting_Manager_Name__c, solHirearchy.get(currentManager).Reporting_Manager_Name__r.name + ' - ' + solHirearchy.get(currentManager).Reporting_Manager_Designation__c));
        currentManager = solHirearchy.get(currentManager).Reporting_Manager_Name__c;

       }
     }
     // Prajyot-Pricing end
    }
    //For Branch OPs credit hirrachy approval
    // Commented for Bug 23547
    /*
    CO = [select id, name, City__c, Number_of_Deviations__c, Credit_Officer_Name__r.Isactive, Credit_Officer_Name__r.id, Credit_Officer_Name__r.name, Credit_Officer_Name__c, Designation__c, Loan_Amount__c, User_Type__c, Flow__c
     from Credit_Officer_Limit__c
     where product__C =: Loan.product__c AND Credit_Officer_Name__r.Isactive = true AND Active_Flag__c = true and User_Type__c = 'OPs User'
    ];

    system.debug('CO.size(): ' + CO.size());
    optionsCOAppr.clear();

    if (CO.size() > 0) {
     for (integer i = 0; i < CO.size(); i++) {
      if (Loan.Branch_Name__c == null) {
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Branch value is empty. Unable to continue'));
      }
      if ((CO[i].Credit_Officer_Name__c != null) && (CO[i].city__c != null)) {
       system.debug('CO[i].City__c.toUpperCase(): ' + CO[i].City__c.toUpperCase());
       system.debug('COLStampFlag  ' + COLStampFlag);
       if (COLStampFlag == true) {
        system.debug('Loan.Branch_Name__r.name ' + Loan.Branch_Name__r.name);
        if (CO[i].City__c.toUpperCase().contains(Loan.Branch_Name__r.name.toUpperCase()) && CO[i].Flow__c != null && CO[i].Flow__c.contains(LoanAppFlow)) {
         system.debug('if city matches');
         optionsCOAppr.add(new SelectOption(CO[i].Id, CO[i].Credit_Officer_Name__r.name + '-' + CO[i].Designation__c));

        }
       } else {
        if (CO[i].City__c.toUpperCase().contains(Loan.Branch_Name__r.name.toUpperCase())) {
         system.debug('if city matches');
         optionsCOAppr.add(new SelectOption(CO[i].Id, CO[i].Credit_Officer_Name__r.name + '-' + CO[i].Designation__c));

        }
       }
      }
     }

    } */
       
       //start  23547
       if (Loan.Branch_Name__c == null) {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Branch value is empty. Unable to continue'));
       }
       else{
           try{
               CO = [ select id, name, City__c, Number_of_Deviations__c, Credit_Officer_Name__r.Isactive, Credit_Officer_Name__r.id, 
                     Credit_Officer_Name__r.name, Credit_Officer_Name__c, Designation__c, Loan_Amount__c, User_Type__c, Flow__c
                     from Credit_Officer_Limit__c
                     where product__C =: Loan.product__c AND 
                     Credit_Officer_Name__r.Isactive = true AND 
                     Active_Flag__c = true and User_Type__c = 'OPs User' and 
                     Credit_Officer_Name__c != null and city__c != null and 
                     City__c includes (:Loan.Branch_Name__r.name)];
               system.debug('CO.size(): ' + CO.size());
               optionsCOAppr.clear();
               if (CO.size() > 0) {
                   for (integer i = 0; i < CO.size(); i++) {
                       system.debug('CO[i].City__c.toUpperCase(): ' + CO[i].City__c.toUpperCase());
                       system.debug('COLStampFlag  ' + COLStampFlag);
                       if (COLStampFlag == true) {
                           system.debug('Loan.Branch_Name__r.name ' + Loan.Branch_Name__r.name);
                           if (CO[i].flow__c!=null && CO[i].Flow__c.contains(LoanAppFlow)) {
                               system.debug('if city matches');
                               optionsCOAppr.add(new SelectOption(CO[i].Id, CO[i].Credit_Officer_Name__r.name + '-' + CO[i].Designation__c));
                           }
                       } else {
                           
                           system.debug('if city matches');
                           optionsCOAppr.add(new SelectOption(CO[i].Id, CO[i].Credit_Officer_Name__r.name + '-' + CO[i].Designation__c));
                       }
                   }
               }
           }
           
           catch(exception ex){
               system.debug('Exception Occured '+ ex+' Stackstrace: '+ex.getStackTraceString());
           } 
       }
       //ends 23547

    Tranche = [select id, name /*Mortgage Start*/ , Tranche_Number__c, Tranche_Type__c, Favoring__c, CHQ_DD_number__c, CHQ_DD_date__c, Mode_of_payment__c, Tranche_Status__c, Date_Cancellation_Hand_over__c, Remarks__c /*Mortgage End*/ from Tranche_Details__c where Loan_Application__c =: LoanId];
    //listTranche.add(new SelectOption('None','None')); 
    for (integer i = 0; i < Tranche.size(); i++)
     listTranche.add(new SelectOption(Tranche[i].Id, Tranche[i].Name));

    Fees = new List < Fees_and_Charge__c > ();
    //charges API enhancement start added Finnone_ChargeId__c,Charge_Desc__c in query     
    Fees = [select id, name, Finnone_ChargeId__c, Tranche_Detail__r.name, Deposition_Date__c, Charge_Desc__c, Deposit_Slip_Number__c, Loan_Application__r.name, Change_Amount__c, Charge_Type__c, Deducted_from_Disbursement__c,
     Service_Charge__c, Status__c, Tranche_Detail__c, Instrument_Date__c, Instrument_No__c, Bank_Branch__c, Instrument_type__c,
     Amount_after_Service_Change__c, Tranche_Detail__r.Tranche_Number__c from Fees_and_Charge__c where Loan_Application__c =: LoanId And Identifier__c != 'Mortgage' /*Mortgage*/
    ];


    //insuranceList = new List < DPLinsurance__c > (); // Commented redundant code for BALIC HTS Integration
    //Charges API :: added to query ,Note_code__c,Note_details__c,Payment_type__c,
    //Cash in 60 minutes added Blind_Data_Entry_Flag__c
    //Communication for SAL Line:  ContactName__c,Contact_Mobile__c, Contact_Name__r.Name,
    //Rate Approval :: ROIFlexi__c, ROILoc__c, ROINormal__c, ROI_PO__c, mail_to_Sales_Hierarchy__c, 
    //15580 --added Dedupe_Linking_Done__c
    applicantList = [select Financial_Health_Check_Guide__c, eKYC_Processing__c, /*bug 17556 s*/ PFApproveStatus__c /*bug 17556 e*/ , id, Existing_Customer__c, (select id, name, City_Residence__c, Dedupe_Lan_Matches__c, Applicant__c, Applicant__r.Contact_Name__c, Datafix_Updated__c,
      Application_ID__c, Customer_Status__c, Applicant__r.Contact_Name__r.Name, Applicant__r.Contact_Name__r.CIF_Id__c, Match_Status__c,
      Customer_ID__c, Address2_Residence__c, Present_Address__c, Area_Locality__c, PIN_Code__c, Address3_Residence__c, Customer_First_Name__c, Date_of_Birth__c, Customer_Last_Name__c, City__c, Company_Date_of_Incorporation__c, Mobile__c, PAN__c, Address1_Residence__c, Segment__c, SF_Base__c, Source_Or_Target__c, Dedupe_Target_Remarks__c, Dedupe_Source__c,
      createdDate from De_Dupes__r), Dedupe_Linking_Done__c, ROIFlexi__c, ROILoc__c, ROINormal__c, ROI_PO__c, mail_to_Sales_Hierarchy__c, /*emi holiday bug 10724*/ Months_per_year__c, EMI_Holiday_Months__c, Cycle_Day_Date__c, Blind_Data_Entry_Flag__c, Note_code__c, Note_details__c, Payment_type__c, ContactName__c, Contact_Mobile__c, Contact_Name__r.Name, name, Descriptin__c, SegmentaionResult__c, CIBIL_Score__c, Applicant_type__c, Contact_Name__r.Stamp_Duty__c, Company_Name_as_per_Domain_check__c, Official_Email_bounce_Flag__c, Domain_Created_Date__c, Domain_Check_Result__c, Registrant_Name__c, Registrant_Email_ID__c, /*Mortgage*/ Property_Dossier_Report__c, Send_pricing_email_to_customer__c, Commercial_Confirmation_Mail_Date__c, /*Prajyot-Pricing*/ FFR_Email_Sent__c, EMI_Holiday_Opted__c,
     /*10610 Referral Program*/
     Refferal_Identifier__c, RSA_flag__c, RSA_Loan_application_status__c, /*Fraud trigger start-krish*/ RCU_status__c, Samp_Status__c, MTFinnOne__c, Fraud_Case__c /*Fraud trigger end-krish*/ ,
     /*Start of BALIC HTS Integration phase 1 changes*/
     Contact_Name__r.Customer_Type__c /*End of BALIC HTS Integration phase 1 changes*/ , /*SAL PLTB Changes 14951 Added by Anshita S*/ IP_Address_Timestamp__c /*SAL PLTB Changes 14951 Added by Anshita E*/
     /*hybrid flexi*/
     , Pure_Flexi_Period__c, Drop_Line_Flexi_Period__c, Pure_Flexi_EMI__c /*bug 13560 s*/ , Contact_Name__r.Date_of_Birth__c /*bug 13560 end*/
     /* 16165 S*/
     , Customer_Decline_Reasons__c /*16165 E*/
     /*Bug 16173 - VRPL changes for HFC Start*/
     , Parent_Deal_ID__c /*Bug 16173 - VRPL changes for HFC End*/
     /* 16175 hybrid flexi topup emi changes S */
     , Is_Hybrid_Flexi_for_Topup__c, Topup_Pure_Flexi_Period__c, Topup_Dropline_Flexi_Period__c, Topup_Loan_Proposed_EMI__c, Topup_Pure_Flexi_EMI__c /* 16175 hybrid flexi topup emi changes E */,/*24028 Sainath start:*/Current_BFL_FRR__c, Spread_Percentage__c/* 24028 Sainath end:*/
     /* 22889 21288 Cross_Collateral_LAN__c  AP*/
     , Cross_Collateral_LAN__c     
     from Applicant__c
     where Loan_Application__c =: Loan.id
    ];
    if (applicantList.size() > 0) {
     optionsApplicant = new List < SelectOption > ();
     for (Applicant__c applicant: applicantList) {
      if (applicant.Applicant_Type__c == 'Primary') {
       applicantPrimary = new Applicant__c();
       applicantPrimary = applicant;
      }
      if (applicant.ContactName__c != null) {
       optionsApplicant.add(new SelectOption(applicant.Id, applicant.ContactName__c));
      }
     }

     /* 16175 hybrid flexi topup emi calculation changes start*/
     if (applicantPrimary != null && applicantPrimary.Is_Hybrid_Flexi_for_Topup__c) {
      IsTopupHybridFlexi = true;
     } else {
      IsTopupHybridFlexi = false;
     }
     /* 16175 hybrid flexi topup emi calculation changes ends*/

     // system.debug('applicantPrimary.EMI_Holiday_Months__c-->'+applicantPrimary.EMI_Holiday_Months__c);
     //Credit vidya email domain check
     if (applicantPrimary.Domain_Check_Result__c == 'NOT OK' || applicantPrimary.Domain_Check_Result__c == 'REFER') {
      EmailDomainCheck = true;
      /*bug 17556 s -- added if salmobilityflagv2 conditions */
      if (salmobilityflagv2 != null && !salmobilityflagv2) {
       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'You cannot approve the case due to Fraud trigger in Domain check.');
       ApexPages.addMessage(myMsg);
      }
     }
     if (applicantPrimary.Official_Email_bounce_Flag__c == true) {
      EmailDomainCheck = true;
      if (salmobilityflagv2 != null && !salmobilityflagv2) {
       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Official Email ID has bounced during domain check.');
       ApexPages.addMessage(myMsg);
      }
     } /*bug 17556 e*/
     //Dedupe linking 13901 start
     //15580 S
     /*List<Applicant__c> appList=new List<Applicant__c>();
                       appList=Loan.Loan_Application__r;
                       for(Applicant__c app:applist){
                                   if(app.Contact_Name__r.CIF_Id__c!=null){
                                       app.Dedupe_Linking_Done__c='SAVE';
                                   }
                               }
                               update applist; */

     IsDedupeLinkingOoneFlag = false;
     if (applicantList!=null && applicantList.size() > 0) {
      for (Applicant__c applicant: applicantList) {
       System.debug('applicant : ' + applicant + '\n >> ' + applicant.Dedupe_Linking_Done__c);

       if (applicant.Dedupe_Linking_Done__c == 'SAVE' || applicant.Dedupe_Linking_Done__c == 'RESET') {
        IsDedupeLinkingOoneFlag = true;

       } else {
        System.debug(' in else--applicant : ' + applicant);
        System.debug(' in else--IsDedupeLinkingOoneFlag : ' + applicant.De_Dupes__r.size());
        if (applicant.De_Dupes__r.size() > 0) {
         for (De_Dupe__c ded: applicant.De_Dupes__r) {
          System.debug(' segment and t' + ded.Segment__c + '' + ded.Source_Or_Target__c);
          if (ded.Segment__c == 'CF' && ded.Source_Or_Target__c == 'Target') {
           IsDedupeLinkingOoneFlag = false;
           System.debug(' in else1--IsDedupeLinkingOoneFlag : ' + IsDedupeLinkingOoneFlag);
           break;
          } else {
           IsDedupeLinkingOoneFlag = true;
          }
         }




        }

       }
       if (IsDedupeLinkingOoneFlag == false) {
        applicantDedupe = applicant.name;
        break;
       }
      }
     }
     System.debug('IsDedupeLinkingOoneFlag : ' + IsDedupeLinkingOoneFlag);
     //15580--E
     //Dedupe linking 13901 end

     //13901 S
     system.debug('blind Data' + Loan.Scheme_Master__r.Blind_Data_Entry__c);
     if (Loan.Scheme_Master__r.Blind_Data_Entry__c == true) {
      applicantPrimary.Blind_Data_Entry_Flag__c = true;

      blindDataFlag = false;

     }
     //13901 E
     if (blindDataFlag == true) {


      //if(loan.Account.Date_of_Birth__c != null && loan.Account.Mobile__c != null && loan.Account.Accountant_email_id__c != null && loan.Nominee_Name__c != null && loan.MICR_Number__c != null && loan.A_C_No__c != null && loan.Account_Holder_Name__c != null && loan.A_C_Type__c != null && loan.IFSC_Code__c!= null) 
      // {

      if (((applicantPrimary.Contact_Name__r.Customer_Type__c == 'Individual' && loan.Account.Date_of_Birth__c != null) || (applicantPrimary.Contact_Name__r.Customer_Type__c == 'Corporate' && loan.Account.Year_of_Incorporation__c != null)) && loan.MICR_Number__c != null && loan.A_C_No__c != null && loan.Account_Holder_Name__c != null && loan.A_C_Type__c != null && loan.IFSC_Code__c != null) {
       blindDatapresentFlag = true;
       system.debug('inside if blindDatapresentFlag =====>' + blindDatapresentFlag);
      }

     }
     if (Loan.Scheme_Master__c != null) {
      if (Loan.Scheme_Master__r.flexi_flag__c == true) {
       isFlexiFlag = true;
      }
     }
     //Cash in 60 minutes ends



    }
    conObj = new Contact();
    //Cash in 60 minutes Date_of_Birth__c,Year_of_Incorporation__c,Mobile__c, Office_Email_Id__c, Email__c
    List < Contact > conObjlist = [select Email, Stamp_Duty__c, Date_of_Birth__c, Year_of_Incorporation__c, Mobile__c, Office_Email_Id__c, Email__c from Contact where id =: applicantPrimary.Contact_Name__c limit 1];
    if (conObjlist.size() > 0)
     conObj = conObjlist[0];


    discrepancyList = [select Discrepancy_Stage__c, Party_Type__c, Party_Name__c,
     Discrepancy_Description__c, LoanApplication__c,
     RaiserName__c, Description__c, Name,
     Priority__c, Resolution_Remarks__c, Status__c, Discrepancy_Party__c, Applicant_Name__c,
     Raiser_Role__c, createddate, Category__c, Discrepancy_Category__c,
     Assigned_To__c, Closed_Date__c, Resolver_Name__c, OTPDiscrepancyCategory__c, OTPDiscrepancyDocuments__c, /*Added by sneha for  Bug -18583 Start*/ OTPDiscrepancyProduct__c /*Added by sneha for  Bug -18583 End*/
     /*Mortgage Start*/
     , Remarks__c, Discrepancy_Type__c /*Mortgage End*/
     from Discrepancy__c where LoanApplication__c =: Loan.Id and Type__c != 'SanctionCondition'
     order by Status__c asc, createddate asc
    ];
    //Added for disbursement
    discrepancyListDis = new List < Discrepancy__c > ();
    discrepancyListLog = new List < Discrepancy__c > ();
    for (Discrepancy__c ocl: discrepancyList) {
     system.debug('--cons--ocl.Checklist_type__c-- ' + ocl.Discrepancy_Category__c);
     if (ocl.Discrepancy_Category__c == 'Disbursement') {
      discrepancyListDis.add(ocl);
     } else {
      discrepancyListLog.add(ocl);
     }
    }

    //Mortgage Start
    objdiscrepancyKitList.addall(discrepancyList);
    //Mortgage End

    discrepancyList = new List < Discrepancy__c > ();
    discrepancyList = discrepancyListLog;
    if (discrepancyList.size() > 0)
     editDiscrepancy = true;
    discrepancyListCount = discrepancyList.size();
    //Assigning back to PropertyDocuments
    //Added for Disbursement
    if (discrepancyListDis.size() > 0)
     editDiscrepancyDis = true;
    discrepancyListCountDis = discrepancyListDis.size();

    discrepancyList = new List < Discrepancy__c > ();
    discrepancyList = discrepancyListLog;

   }
   if (Loan != null) {
    //Addition fields to FinnOne :fields added to query: Type_of_Insurance__c, Insurance_Party_type__c,Applicant_type__c,Insurance_form_number__c,Critical_Illness__c,Relation__c,Insurance_term__c,Declaration_of_good_health__c     
    //Insurance Field Mandatory Enhancement : Nominee_Relationship__c is added in following Query
    Hinsurance = [Select Insurance_Party_type__c, Type_of_Insurance__c, Applicant_type__c, Insurer_Name__c, Insurance_form_number__c, Critical_Illness__c, Relation__c, Insurance_term__c, Declaration_of_good_health__c, Nominee_Name__c, Nominee_Address__c, Nominee_Mobile__c, Nominee_DOB__c, Whether_we_are_financing_this_product__c, Term_of_Insurance__c, Sum_Assured__c, Remark__c, Reject_reason__c,
     Premium_Amount__c, Policy_type__c, Policy_number__c, Policy_issue_date__c, Offer_id__c, Loan_Application_Status__c,
     Loan_application_number__c, Opportunity__c, Opportunity__r.Nominee_Name__c, Loan_Amount__c, Insurance_Type__c, Insurance_Product__c, Insurance_Name__c,
     Insurance_amount__c, Existing_LAN_no__c, Decision_time_stamp__c, Customer_Payment_Mode__c, Customer_address__c, CPA_Name__c,
     Cheque_Status__c, Cheque_DD_No_with_Bank_Name__c, Cheque_DD_Date__c, Availed_Tenor__c, Critical_Illness_Declaration_of_Good_H__c, Nominee_Relationship__c,
     Availed_EMI__c, Availed_Amount__c, Approved__c, Age__c, /*Anjali-start*/ Plan_Option__c, Sum_Assured_Type__c, Policy_Tenure__c, Sum_Insured__c, Plan__c, DOB_of_Dependent_Life__c, DOB_of_Policyholder1__c,
     Appointee_DOB__c, Appointee_Name__c, Source__c, /*Bug - 12609 Form_Handover__c, Discrepant_at_TCS__c, Discrepant_Resolution__c,*/ Nominee_Age__c /*Anjali-end*/ from DPLinsurance__c where Opportunity__c =: Loan.id
    ];

    createChecklist();

    /* new code Devashree-- defffal */
    objchecklist = [Select c.Tranche_Detail__c, c.docValidity_Date__c, c.Ischecked__c, c.docTarget_Date__c, c.docRemarks__c, c.docReceived_Date__c, c.Target_Date__c, c.Status__c,
     c.Stages__c, c.Received_Date__c, c.Reason__c, c.RIC_Status__c, c.RIC_Req__c, c.Original__c, c.Name, c.Mandatory__c, c.Id,
     c.DocumentFmlyName__c, c.DocumentFmlyName__r.Name, c.DocStatus__c, c.Sales_Status__c, c.Comments__c, c.Checklist_Parameter__c, c.Property_Document__c,
     c.Applicant__c, c.Applicant__r.Type_of_Borrower__c, c.Applicant__r.Contact_Name__r.name, c.documents__c, to_be_approved_by__c,
     c.Deferral_Type__c, c.Expected_Resolution__c, Approval_Authority__r.name, DocumentFmlyName__r.FinnOne_Document_id__c,
     c.Type_of_Borrower__c, Document_Type__c, Checklist_type__c, DocumentFmlyName__r.Documents__c, Document_TYPE1__c, CPA_Status__c,
     PDD_OTC_Received_Date__c, PDD_OTC_Received_Status__c, PDD_OTC_Remarks__c, Property_Documents__c, Deferral_Taken_Date__c, CPA_Deferral_Clearance_Date__c, CPA_Deferral_Status__c, OpsDeferral_Clearance_Date__c,
     checkfordelete__c, review_flag__c, Approved_by__c, Approved_flag__c, IsCritical__c, IsNonCritical__c, Property_Details__r.Name, OPS_Deferral_Status__c,
     DocStatus1__c, Documents_Type__c, Details_of_Defferral_Docs__c, ACM_Remarks__c, OTPDeferralCategory__c, OTPDeferralDocuments__c From Checklist__c c
     where Applicant__r.Loan_Application__c =: Loan.id
    ];
   }
   objchecklistDis = new List < Checklist__c > ();
   objchecklistLog = new List < Checklist__c > ();
   if (objchecklist.size() > 0) {
    for (Checklist__c ocl: objchecklist) {
     system.debug('--cons--ocl.Checklist_type__c-- ' + ocl.Checklist_type__c);
     if (ocl.Checklist_type__c == 'Disbursement') {
      objchecklistDis.add(ocl);
     } else {
      objchecklistLog.add(ocl);
     }
    }
   }
   objchecklist = new List < Checklist__c > ();
   objchecklist = objchecklistLog;
   system.debug('--cons--objchecklistDis-- ' + objchecklistDis.size());
   system.debug('--cons--objchecklist-- ' + objchecklist.size());
   objchecklistDiscount = objchecklistDis.size();
   if (objchecklistDiscount > 0) {
    viewDis = true;
   }

   if (objchecklist.size() > 0) {
    for (integer k = 0; k < objchecklist.size(); k++) {
     try {
      objchecklist[k].Type_of_Borrower__c = objchecklist[k].Applicant__r.Type_of_Borrower__c;
     } catch (Exception e) {}
    }
   }
   // Disbursement
   if (objchecklistDis.size() > 0) {
    for (integer k = 0; k < objchecklistDis.size(); k++) {
     try {
      objchecklistDis[k].Type_of_Borrower__c = objchecklistDis[k].Applicant__r.Type_of_Borrower__c;
     } catch (Exception e) {}
    }
   }
   //Additional fields
   system.debug('all applicants are' + applicantList);
   if (applicantList!=null && applicantList.size() > 0) {
    for (integer i = 0; i < applicantList.size(); i++) {
     if (applicantList[i].Contact_Name__r.Name != null)
      optionsdocApp.add(new SelectOption(applicantList[i].Id, applicantList[i].Contact_Name__r.Name + '-' + applicantList[i].Applicant_type__c));
     optionsListApp.add(new SelectOption(applicantList[i].Contact_Name__r.Name, applicantList[i].Contact_Name__r.Name + '-' + applicantList[i].Applicant_type__c));
    }
    system.debug('optionsListApp===>' + optionsListApp);
   }
   if (objchecklistDis.size() > 0) {
    viewDis = true;
   } else {
    viewDis = false;
   }
   //V1 Refinement Enhancement Start
   prop = new Property_Details__c();
   if (!CommonUtility.isEmpty(Loan) && !CommonUtility.isEmpty(Loan.Property_Details__r)) {
    prop = Loan.Property_Details__r[0];
   }
   Map < String, Object > jsonBody = new Map < String, Object > ();
   String jsonString = '';
   displayPricingGrid = false;
   if (SRCust != null) {
    jsonString = SRCust.Body.toString();
   }
   jsonBody = (Map < String, Object > ) JSON.deserializeUntyped(jsonString);
   if (jsonBody.containsKey('V1_Refinement')) {
    jsonBody = (Map < String, Object > ) jsonBody.get('V1_Refinement');
    if ((String) jsonBody.get('Pricing_Grid_Products') != null && !CommonUtility.isEmpty(Loan) && ((String) jsonBody.get('Pricing_Grid_Products')).containsIgnoreCase(';' + Loan.Product__c + ';')) {
     displayPricingGrid = true;
    }
   }
   if (displayPricingGrid) {
    calculateformulas(Loan.Property_Details__r, Hinsurance);
   }
   //V1 Refinement Enhancement End
   /** Bug 10666 - fraud trigger enhancement start : krish **/
   OnLineSal_Products__c pro = OnLineSal_Products__c.getValues('Fraud Trigger Products');
   String products1 = pro.Product__c;
   if (!CommonUtility.isEmpty(Loan) && products1.toUpperCase().contains(loan.Product__c.toUpperCase())) {
    prodFlag = true;
   }
   /** Bug 10666 - fraud trigger enhancement end : krish **/

   //Bug 16173 - VRPL changes for HFC : In Constructor : Setting initial flag on page load Start
   if (Loan != null && Loan.Scheme_Master__c != null && Loan.Scheme_Master__r.VRPL_Flag__c != null && Loan.Scheme_Master__r.VRPL_Flag__c == 'YES') {
    showParentDealID = true;
   } else {
    showParentDealID = false;
   }
   if(applicantPrimary != null){
       ParentDealID = applicantPrimary.Parent_Deal_ID__c;
   }
   if(Loan != null)
   initialSchemeID = Loan.Scheme_Master__c;
   //Bug 16173 - VRPL changes for HFC : In Constructor : Setting initial flag on page load End 

   //Rohit 16111 CR S          
   aadharMandatoryState = false;

   Map < String, Object > ALLMapEkyc = GeneralUtilities.fetchEkycMap();
   System.debug('rohit ' + ALLMapEkyc);
   if (ALLMapEkyc != null) {
    Map < String, Object > stateMap = (Map < String, Object > ) ALLMapEkyc.get('states');
    Map < String, Object > productMap = (Map < String, Object > ) ALLMapEkyc.get('AadharMandatory');
    //SYstem.debug('robin ' + Loan.Account.Current_State__c);

    if (applicantPrimary != null) {
     appekyc = applicantPrimary.eKYC_Processing__c;
    }

    if (stateMap != null && Loan != null && Loan.Account != null && Loan.Account.Current_State__c != null && !CommonUtility.isEmpty((String) stateMap.get(Loan.Account.Current_State__c))) {
     System.debug('here 1');
     aadharMandatoryState = false;
    } else if (productMap != null && Loan != null && Loan.Product__c != null && !CommonUtility.isEmpty((String) productMap.get(Loan.Product__c)) && applicantPrimary.Contact_Name__r.Customer_Type__c != 'Corporate') {
     System.debug('robin 2 ' + Loan.Account.Current_State__c);
     aadharMandatoryState = true;
    }


   }
   //Rohit 16111 CR E

  } catch (Exception e) {
   if (salMobilityFlag) {
    Apexpages.addMessages(e);
    System.debug('****Exception: ' + e.getMessage() + ' Line number --> ' + e.getLineNumber());
    savedSuccessfull = true;
    message = e.getMessage() + '  ' + e.getLineNumber() + '  ' + e.getCause() + '  ' + e.getTypeName();
    //SendExceptionMail(message,'Exception came in MidOffice flow (Pricing Details)');
   } else
    System.debug('****Exception: ' + e.getMessage() + ' Line number --> ' + e.getLineNumber());
  }

 }

 public void SaveLoanDetails() {
  //if(Loan.CPA_Acceptance_time__c==null && Loan.File_Acceptance__c=='File Accepted')
  //Loan.CPA_Acceptance_time__c=System.now();

  /* Bug 14405 - BRD_Communication- Hybrid Flex Start */
  String BitlyLink, HybridFlexiBitlyLink, PureFlexiBitlyLink, DroplineFlexiBitlyLink;
  try {
   String baseURL = 'preprodtmp-bflloans.cs6.force.com';
   baseURL = System.Label.Flexi_Base_URL;
   System.debug('baseURL : ' + baseURL);

   String HybridFlexiVF = baseURL + '/' + 'FlexiComm_Hybrid_Flexi' + '_VF?id=' + Loan.Id;
   HybridFlexiBitlyLink = CommonUtility.googleShortenUrl(HybridFlexiVF);

   String PureFlexiVF = baseURL + '/' + 'FlexiComm_Pure_Flexi' + '_VF?id=' + Loan.Id;
   PureFlexiBitlyLink = CommonUtility.googleShortenUrl(PureFlexiVF);

   String DroplineFlexiVF = baseURL + '/' + 'FlexiComm_Dropline' + '_VF?id=' + Loan.Id;
   DroplineFlexiBitlyLink = CommonUtility.googleShortenUrl(DroplineFlexiVF);

   System.debug('HybridFlexiBitlyLink : ' + HybridFlexiBitlyLink);
   System.debug('PureFlexiBitlyLink : ' + PureFlexiBitlyLink);
   System.debug('DroplineFlexiBitlyLink : ' + DroplineFlexiBitlyLink);
  } catch (Exception e) {
   System.debug('\nException in SaveLoanDetails while generating bitly - google shortner \n' + e);
  }
  /* Bug 14405 - BRD_Communication- Hybrid Flex End */

  //13793--15554--added try catch
  try {
   upsert Loan;
  } catch (Exception e) {
   System.debug('Exception in : selecting correct scheme : \n' + e);
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Scheme does not match with Loan Variant'));
  }
  if (Loan != null) {
   //Cash in 60 mins IFSC_Code__c, A_C_No__c, Mode_of_Disbursal__c, Bank_Name__c, Account_Holder_Name__c,First_Due_Date__c, Repayment_Mode__c, Repayment_Bank_Name__c, Bank_A_c_No_of_Customer__c, Repayment_Account_Holder_Name__c,A_C_Type__c, MICR_Number__c,Scheme_Master__r.flexi_flag__c, Account.Mobile__c,Flexi_Customer_A_C_Number__c, Account.Date_of_Birth__c,Account.Accountant_email_id__c,A_C_No__c,Account_Holder_Name__c ,A_C_Type__c,Account.Year_of_Incorporation__c,   
   //Rate Approval Scheme_Master__r.flexi_flag__c, Scheme_Master__r.PLOC_scheme__c, Account.Year_of_Incorporation__c,
   //13793-15554 added Loan_Variant__c
   Loan = [select /*Bug Id - 22425 */ Account.Process_Flow__c, /* Bug 19193 Start*/ Scheme_Master__r.istopup__c, /* Bug 19193 End*/ /*17556 s*/ Area_SM__r.Email /*17556 e*/ , /* SAL Mobility Addition CR - Aman Porwal - S*/ Account.Flow__c, /* SAL Mobility Addition CR - Aman Porwal - E*/ /*Rohit 16111 S*/ Account.Current_State__c, /*Rohit 16111 E*/ id, /*SAl Interest Subvention Rohit S bug id 12941*/ Account.Interest_Subvention_Applicable__c, /*SAl Interest Subvention Rohit E 12941*/ Account.Name, Scheme_Master__r.PLOC_scheme__c, Relationship_Manager__r.Email, Sourcing_Channel__r.sourcing_channel_email_id__c, ACM__r.Email, Sourcing_channel_email_id__c, Account.Current_Email_Id__c, Loan_Amount__c, Due_Day__c, Scheme_Master__r.Scheme_Code__c, Mode_of_Disbursal__c, Account_Holder_Name__c, First_Due_Date__c, Repayment_Mode__c, Repayment_Bank_Name__c, Repayment_Account_Holder_Name__c, Scheme_Master__r.flexi_flag__c, Flexi_Customer_A_C_Number__c, Account.Date_of_Birth__c, Account.Accountant_email_id__c, A_C_No__c, A_C_Type__c, Account.Year_of_Incorporation__c, CPA_Acceptance_time__c, Sales_Kit_Pick_Date__c, Sales_Submit_to_Branch_Ops_Date__C, File_Accept_Status__c, Dispatch_time__c, Agreement_Kit_Accepted_by_CPA__c, Agreement_Kit_Picked__c, Sent_To_Finnone__c, LAN__c, Disbursal_Date__c, Disbursed_Amount__c, Created_Time__c, QDP__c, Area_SM__c, Relationship_Manager__r.name, Date_of_created_date__c, Owner.Name, Original_Approver__c, Decision_Time__c, Loan_Amount_with_Premium__c, Approved_Loan_Amount__c, Approved_Rate__c, Approved_Tenor__c, Loan_amt_with_premium__c, Insurance_Premium_Amt__c, online_salaried_app__c, /* Salaried */
    Reject_Reason__c, Loan_Variant__c, Sales_Backend__c, name, Risk_Deviations__c, CRO_Deviations__c, CPA__c, ACM__c, RCM__c, NCM__c, CRO__c, RISK__c, COO__c, ACM_Comments__c, RCM_Comments__c, COO_Comments__c, Eligible_for_cross_sell__c, Products_for_cross_sell__c, Cross_sell_comments__c,
    Approval_Stages__c, Approver__c, Loan_Application_Number__c, Product__c, Loan_Type__c, Relationship_Manager__c, AccountId, CreatedDate,
    OwnerId, CreatedById, Scheme_Master__c, Scheme_Master__r.Name, Industry__c, Credit_Program__c,
    Sub_Industry__c, Existing_Customer__c, Finance_Amount__c, Tenor__c, Main_Sector__r.Sector__c, Main_Industry__c, Main_Sub_Industry__c,
    Type_Of_Loan__c, amount, Employee_Type__c, stagename, Probability, EMI_CAM__c,
    ForecastCategoryName, File_Acceptance__c, Discrepancy_Status__c, Min_PF__c, Min_Insurance__c, Min_Rate__c,
    Type_of_Constitution__c, Application_Form_Number__c, If_Yes__c, Final_Authority__c,
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
    Acc_InsurFundedType__c, Acc_Type_of_Policy__c, Acc_InsurCompanyName__c,
    Acc_InsurStartDate__c, Acc_InsurPremiumAmount__c, Acc_InsurSumAssured__c,
    Requested_ROI__c, Processing_Type__c, Account.IS_OTP_FLOW__c,
    Life_InsuranceRemarks__c, Type_of_Borrower__c, MonthlyBonus__c,
    CampaignId, Business_IRR__c, POS__c, BranchName__c, Financed_by_BFL__c, Disbursement_Type__c, Tranche_Count__c, City_Head__c, UnHold__c,
    CL_Region__c, Pricing_Details_Approved_by__c, Region__c, Old_Product__c, account.Years_in_Bus__c, CAM_Expiry_Date__c, CAM_Preparation_Date__c, Business_Head__c, Centralized_ACM__c,
    AMC__c, City_SM__c, Regional_SM__c, Zonal_SM__c, National_SM__c, Centralized_RCM__c, Customer_Reference_Number__c, SMS_to_be_Sent__c, ACM__r.Mobile_number__c, Approved_time_after_Reappraisal__c, Decision_Date__c, Interior_Designer__c, Service_Availed__c,
    ASM_email_id__c, If_Top_up_Existing_LAN_no__c, Account.Mobile__c, /*Prajyot-Pricing*/ Application_Source__c, account.Type_Of_Industry__c, Account.Employer__r.Company_Name__c, Account.Employer__r.name, Account.Employer__r.Company_Category__c, account.Name_of_the_Company_Employer__c, Net_Loan_to_POS__c
    /*hybrid flexi*/
    , Scheme_Master__r.IsHybridFlexi__c, /*bug 14773 s*/ Account.Group_Type__c /*bug 14773 e*/
    /* Bug 14405 - BRD_Communication- Hybrid Flex Start */
    , Account.Email_Id__c, Relationship_Manager__r.Mobile_number__c, Scheme_Master__r.is_Pure_Flexi__c,
    /* Bug 14405 - BRD_Communication- Hybrid Flex End */
    CM__c, CM_Amount__c, CM_Deviations__c, SCO__c, SCO_Amount__c, SCO_Deviations__c, CM__r.Mobile_number__c, SCO__r.Mobile_number__c, CM__r.name, SCO__r.name /*Bug id : 13016 - New Role Creation for Credit, added by Needhi*/
    /*Added BY Ankush Bug 14128 Start bug 22141 Customer_Bank_Acc_Confirmation__c, Customer_Bank_Acc_Confirmation_IP__c,Verification_Type__c,Valuation_Type__c*/
    , (select id, Level_of_Activity__c, Status__c, Customer_Bank_Acc_Confirmation__c, Customer_Bank_Acc_Confirmation_IP__c, Verification_Type__c, Valuation_Type__c from Verification__r ORDER BY CreatedDate DESC) /*Added BY Ankush Bug 14128 End*/
    /* Bug 15422 - Auto Approval - Loan Against Insurance_Revised Start */
    , Sourcing_Channel__r.Name /* Bug 15422 - Auto Approval - Loan Against Insurance_Revised Start */
    /*Bug 16173 - VRPL changes for HFC Strat*/
    , Scheme_Master__r.VRPL_Flag__c /*Bug 16173 - VRPL changes for HFC End*/
    /*Bug:19193 -  Top Up Changes Start : Garima*/
    , (Select Id, DisbursementType__c, BalanceAmount__c from TelePDQuestionsMaster__r) /*Bug:19193-Top Up Changes End : Garima*/ from Opportunity where id =: LoanId
   ];
   //Bug:19193 -  Top Up Changes Start : Garima                
   topUpChange(Loan);
   //Bug:19193 -  Top Up Changes End : Garima

   //added by akshata :Hybrid Flexi Inhancement : Start
   System.debug('isHybridFlexi1 -->' + loan.Scheme_Master__c);
   if (!CommonUtility.isEmpty(loan.Scheme_Master__c) && !CommonUtility.isEmpty(loan.Scheme_Master__r.IsHybridFlexi__c) && loan.Scheme_Master__r.IsHybridFlexi__c == true)
    IsHybridFlexi = true;
   else
    IsHybridFlexi = false;
   System.debug('isHybridFlexi -->' + IsHybridFlexi);
   //added by akshata :Hybrid Flexi Inhancement : End
  }


  //Bug 16173 - VRPL changes for HFC 
  try {
   initialSchemeID = Loan.Scheme_Master__c;

   if (Loan != null && Loan.Scheme_Master__c != null && Loan.Scheme_Master__r.VRPL_Flag__c != null && Loan.Scheme_Master__r.VRPL_Flag__c == 'YES') {
    showParentDealID = true;
   } else {
    applicantPrimary.Parent_Deal_ID__c = null; // assigning parent ID to null for 'NO',NULL or Empty VRPL Flag
    showParentDealID = false;
   }

   updatePrimaryApplicant(); // Updating Parent ID for primary applicant 
  } catch (Exception e) {
   System.debug('Exception occurred in SaveLoanDetails : ' + e);
   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Save failed! Exception : ' + e));
   return;
  }
  //Bug 16173 - VRPL changes for HFC 


  /* Bug 14405 - BRD_Communication- Hybrid Flex Start */
  try {
   if (Loan != null && Loan.Id != null && Loan.Scheme_Master__c != null && Loan.Scheme_Master__r.Name != null && Loan.Scheme_Master__r.flexi_flag__c == true) {
    System.debug(Loan + '\n\nIn FLEXI Communication..................');
    System.debug('Loan.Scheme_Master__r.Name : ' + Loan.Scheme_Master__r.Name);
    String SMSSentNm = 'Cust ' + Loan.Scheme_Master__r.Name;
    if (SMSSentNm != null && SMSSentNm.length() > 80)
     SMSSentNm = SMSSentNm.substring(0, 79);
    String SMSSentNmInt = 'Int ' + Loan.Scheme_Master__r.Name;
    if (SMSSentNmInt != null && SMSSentNmInt.length() > 80)
     SMSSentNmInt = SMSSentNmInt.substring(0, 79);

    //Check if sms already sent for particular scheme
    List < SMS_Sent__c > smsListFlexi = new List < SMS_Sent__c > ();
    smsListFlexi = [select Name from SMS_Sent__c where(name =: SMSSentNm or name =: SMSSentNmInt) and LoanApplication__c =: Loan.Id];
    System.debug('smsListFlexi : ' + smsListFlexi);
    if (smsListFlexi != null && smsListFlexi.size() > 0) {
     System.debug('SMS already sent for scheme : ' + Loan.Scheme_Master__r.Name);
    } else {
     System.debug('Loan : Account : \n' + Loan.Account.Email_Id__c + '\n' + Loan.Account.Mobile__c);
     System.debug('Loan : Relationship Manager ; \n' + Loan.Relationship_Manager__r.Email + '\n' + Loan.Relationship_Manager__r.Mobile_number__c);
     //Setting Data for Email
     String templateName; //'FlexiComm_Dropline';//'FlexiComm_Hybrid_Flexi';//'FlexiComm_Pure_Flexi';
     Id whatId = Loan.Id;
     string fromName = 'noreply@bajajfinserv.in';
     string replyTo = '';
     string[] toAddresses = new String[] {};
     if (Loan.AccountId != null && Loan.Account.Email_Id__c != null)
      toAddresses.add(Loan.Account.Email_Id__c);
     String[] CC = new String[] {};
     if (Loan.Relationship_Manager__c != null && Loan.Relationship_Manager__r.Email != null)
      CC.add(Loan.Relationship_Manager__r.Email);
     string[] bcc;
     String Priority = 'Normal';
     String Subject = 'Know Your Flexi Loan';
     String CostCenter = 'bajaj';

     //Setting Data for SMS
     List < String > message = new List < string > ();
     List < string > mobileno = new List < string > ();

     //SMS Sent record list
     List < SMS_Sent__c > allsms = new List < SMS_Sent__c > ();
     /*Responsys Dynamic Parameters Bug 15653 s*/
     Rack_Rate__c flexiCust = new Rack_Rate__c();
     Rack_Rate__c flexiInt = new Rack_Rate__c();
     system.debug('rrMaster ' + rrMaster);
     if (rrMaster != null && rrMaster.size() > 0) {
      for (Rack_Rate__c rr: rrMaster) {
       Set < String > rrProd = new Set < String > ();
       if (rr.Products__c != null)
        rrProd.addAll(rr.Products__c.split(';'));
       if (rr.Event__c == 'Flexi SMS Cust' && rrProd.contains(Loan.Product__c)) {
        flexiCust = rr;
       }
       if (rr.Event__c == 'Flexi SMS Int' && rrProd.contains(Loan.Product__c)) {
        flexiInt = rr;
       }
      }
     }
     /*Responsys Dynamic Parameters Bug 15653 e*/
     //Seperate Logic for Email & SMS Start Bug 15129
     if (Loan.AccountId != null) {
      if (Loan.Scheme_Master__r.IsHybridFlexi__c == true) {
       BitlyLink = HybridFlexiBitlyLink;
       templateName = 'FlexiComm_Hybrid_Flexi';
      } else if (Loan.Scheme_Master__r.is_Pure_Flexi__c == true) {
       BitlyLink = PureFlexiBitlyLink;
       templateName = 'FlexiComm_Pure_Flexi';
      } else if (Loan.Scheme_Master__r.IsHybridFlexi__c == false && Loan.Scheme_Master__r.is_Pure_Flexi__c == false) {
       BitlyLink = DroplineFlexiBitlyLink;
       templateName = 'FlexiComm_Dropline';
      }
      System.debug('templateName : ' + templateName);
      System.debug('BitlyLink : ' + BitlyLink);

      System.debug('Sending SMS & Email to Primary Applicant...');
      Map < String, String > dynPar = new Map < String, String > (); //Responsys Dynamic Parameters Bug 15653
      String msgCust = 'Your app ID ' + Loan.Loan_Application_Number__c + ' is being processed with flexi benefits. To know about your product, click ' + BitlyLink + '. Detailed flexi features have been sent on your registered email ID as well. Regards, Bajaj Finserv';
      /*Responsys Dynamic Parameters Bug 15653 s*/
      if (setProdRes.contains(Loan.Product__c) && flexiCust.Used_For__c == 'Responsys') {
       dynPar.put('P_LAN', Loan.Loan_Application_Number__c);
       dynPar.put('P_BITLY', BitlyLink);
      }
      /*Responsys Dynamic Parameters Bug 15653 e*/
      System.debug('msgCust : ' + msgCust);
      SMS_Sent__c sms = new SMS_Sent__c();
      sms.LoanApplication__c = Loan.Id;
      String SMSSentName = 'Cust ' + Loan.Scheme_Master__r.Name;
      if (SMSSentName != null && SMSSentName.length() > 80)
       sms.Name = SMSSentName.substring(0, 79);
      else
       sms.Name = SMSSentName;
      sms.SMS_Receiver__c = 'Primary Applicant';

      if (toAddresses != null && toAddresses.size() > 0 && String.isNotEmpty(templateName)) {
       System.debug('Send Email to Primary Applicant......');
       sms.Email_sent__c = true;
       sms.Email_sent_at__c = toAddresses[0];
       sms.Email_sent_time__c = System.now();

       GeneralUtilities.SendEmailUsingBAFLLogix(templateName, whatId, 'bajaj', replyTo, toAddresses, CC, bcc, Priority, Subject, CostCenter);
       allsms.add(sms);
      }

      if (Loan.AccountId != null && Loan.Account.Mobile__c != null && templateName != null) {
       System.debug('Send SMS to Primary Applicant......');
       sms.SMS_Sent_Number__c = String.valueOf(Loan.Account.Mobile__c);
       /*Responsys Dynamic Parameters Bug 15653 s added if else*/
       if (!setProdRes.contains(Loan.Product__c) && flexiCust.Used_For__c == 'Responsys') {
        sms.SMS_Text_Sent__c = msgCust;
        sms.SMS_Sent_Time__c = system.now();
        sms.SMS_Sent__c = true;

        Datetime currtime = system.now();
        Integer hour = currtime.hour();
        if (hour > 9 && hour < 21)
         sms.Status__c = 'Sent';
        else
         sms.Status__c = 'Pending';
       } else {
        sms.Event__c = flexiCust.Campaign_Name__c;
        sms.SMS_Parameters__c = JSON.serialize(dynPar);
        sms.Status__c = 'Pending';
       }
       message.add(msgCust);
       mobileno.add(String.valueOf(Loan.Account.Mobile__c));
       allsms.clear();
       allsms.add(sms);
      }
     }


     if (Loan.Relationship_Manager__c != null && Loan.Relationship_Manager__r.Mobile_number__c != null) {
      System.debug('Sending SMS to Relationship Manager...');
      Map < String, String > dynPar = new Map < String, String > (); //Responsys Dynamic Parameters Bug 15653
      String msgInt = 'Flexi Features and transaction related information has been sent to ' + Loan.Account.Name + ' ' + Loan.Loan_Application_Number__c + '. Please connect with customer. Regards, Bajaj Finserv';
      //Responsys Dynamic Parameters Bug 15653 s
      if (setProdRes.contains(Loan.Product__c) && flexiInt.Used_For__c == 'Responsys') {
       dynPar.put('P_LAN', Loan.Loan_Application_Number__c);
       dynPar.put('P_CUSTOMERNAME', Loan.Account.Name);
      }
      //Responsys Dynamic Parameters Bug 15653 e
      System.debug('msgInt : ' + msgInt);
      SMS_Sent__c sms = new SMS_Sent__c();
      sms.LoanApplication__c = Loan.Id;
      String SMSSentName = 'Int ' + Loan.Scheme_Master__r.Name;
      if (SMSSentName != null && SMSSentName.length() > 80)
       sms.Name = SMSSentName.substring(0, 79);
      else
       sms.Name = SMSSentName;
      sms.SMS_Sent_Number__c = String.valueOf(Loan.Relationship_Manager__r.Mobile_number__c);
      //Responsys Dynamic Parameters Bug 15653 s                      
      if (!setProdRes.contains(Loan.Product__c) && flexiInt.Used_For__c == 'Responsys') {
       sms.SMS_Text_Sent__c = msgInt;
       sms.SMS_Sent_Time__c = system.now();
       sms.SMS_Sent__c = true;

       Datetime currtime = system.now();
       Integer hour = currtime.hour();
       if (hour > 9 && hour < 21)
        sms.Status__c = 'Sent';
       else
        sms.Status__c = 'Pending';
      } else {
       sms.Event__c = flexiInt.Campaign_name__c;
       sms.Status__c = 'Pending';
       sms.SMS_Parameters__c = JSON.serialize(dynPar);
      }
      //Responsys Dynamic Parameters Bug 15653 e
      sms.SMS_Receiver__c = 'Realtionship Manager';
      message.add(msgInt);
      mobileno.add(String.valueOf(Loan.Relationship_Manager__r.Mobile_number__c));
      allsms.add(sms);
     }


     System.debug('message : ' + message + '\nmobileno : ' + mobileno + '\nallsms : ' + allsms);
     if (message.size() > 0 && mobileno.size() > 0) {
      System.debug('Sending Bulk SMS : ' + allsms);
      if (!setProdRes.contains(Loan.Product__c) && (flexiCust.Used_For__c == 'Responsys' || flexiInt.Used_For__c == 'Responsys')) {} else {
       sendsms.sendBulkSMS(message, mobileno);
      }
      if (allsms != null)
       insert allsms;
     } else {
      if (allsms != null && allsms.size() > 0) {
       System.debug('Creating SMS Sent record in case only email Id is present....\n' + allsms);
       insert allsms;
      }
     }
     //Seperate Logic for Email & SMS End 
    }
   }
  } catch (Exception e) {
   System.debug('Exception in : Hybrid Flexi Communication : SaveLoanDetails : \n' + e);
  }
  /* Bug 14405 - BRD_Communication- Hybrid Flex End */

 }

 public void AddSanctionDetails() {
  sendMssg = false;
  system.debug('*************');

  showSanction = true;
  system.debug('*****showSanction********' + showSanction);
  Discrepancy__c addNewDisc = new Discrepancy__c();
  addNewDisc.LoanApplication__c = Loan.Id;
  addNewDisc.Discrepancy_Stage__c = Loan.StageName;
  addNewDisc.Status__c = 'Pending';
  addNewDisc.OTPDiscrepancyProduct__c = Loan.Product__c; // Added by sneha for Bug-18583
  String RoleName = Loan.Current_UserRole__C;
  addNewDisc.RaiserName__c = UserInfo.getUserId();
  addNewDisc.Raiser_Role__c = RoleName;

  //--------------- Mortgage Re-Engg Start---------------------
  if (Mortgageflag) {
   addNewDisc.Kit_Acceptance__c = KitAcceptanceValue;
  }
  //--------------- Mortgage Re-Engg End-----------------------

  sanctionList.add(addNewDisc);
  addrow = true;
  addrowDisc = true;
  sendMssg = false;
  system.debug('*****add row********' + addrowDisc);
  system.debug('*****add row********' + showSanction);
 }

 public void AddDiscrepancy() {
  sendMssg = false;
  system.debug('*************');
  if (discrepancyData.size() > 0) {
   if (StrVAContact != null) {
    integer count = discrepancyData.size();
    count = count - 1;
    discrepancyData[count].Discrepancy_Party__c = StrVAContact;
   }
  }
  showDiscrepancy = true;
  system.debug('*****showDiscrepancy********' + showDiscrepancy);
  Discrepancy__c addNewDisc = new Discrepancy__c();
  addNewDisc.LoanApplication__c = Loan.Id;
  addNewDisc.Discrepancy_Stage__c = Loan.StageName;
  addNewDisc.Status__c = 'Pending';
  String RoleName = Loan.Current_UserRole__C;
  addNewDisc.RaiserName__c = UserInfo.getUserId();
  addNewDisc.Raiser_Role__c = RoleName;
  discrepancyData.add(addNewDisc);
  addrow = true;
  addrowDisc = true;
  sendMssg = false;
  system.debug('*****add row********' + addrowDisc);
  system.debug('*****add row********' + showDiscrepancy);
 }

 public List < DocumentWrapper > getdeviationDocWrapperList() {
  return deviationDocWrapperList;
 }

 public void createChecklist() {

  docFamilyMaster = [select Name, Documents__c, Is_OTP_Standard_Document__c from Document_Family__c where(Document_Code__c != null OR Deviation_Code__c != null) /* Bug 23547 Start*/ AND Product__c INCLUDES(:Loan.Product__c) /*Bug 23547 Ends */];
  Map < id, Document_Family__c > docFamilyMap = new Map < id, Document_Family__c > ();
  for (Document_Family__c docFam: docFamilyMaster) {
   docFamilyMap.put(docFam.id, docFam);
   System.debug('docFam==' + docFam);
  }
  System.debug('docFamilyMap==' + docFamilyMap);
  checklistTrnxList = [select id, Sales_Status__c, CPA_Status__c, Document__c, Checklist_Parameter__c, Checklist_Parameter__r.Document_Family__r.Documents__c,
   Checklist_Parameter__r.Document_Family__r.Name, Checklist_Parameter__r.Mandatory__c, Mandatory__c,
   Checklist_Parameter__r.Active__c, Checklist_Parameter__r.Type_of_Document__c, Checklist_Parameter__r.DeviationMaster__c,
   Checklist_Parameter__r.Stages__c, Checklist_Parameter__r.Customer_Segmentation__c, Deviation_Master__r.Deviation_name__c, DocumentFmlyName__r.Name,
   Checklist_Parameter__r.DeviationMaster__r.Deviation_name__c, DocumentFmlyName__r.Document_Code__c, DocumentFmlyName__r.Deviation_Code__c, DocumentFmlyName__c,
   Deviation_Master__c, Manual__c from Checklist__c
   where Loan_Application__c =: Loan.Id and Manual__c = false
  ];
  System.debug('aftr checklistTrnxList==' + checklistTrnxList);
  if (checklistTrnxList != null && checklistTrnxList.size() > 0) {
   deviationDocWrapperList.clear();
   docWrapperList.clear();
   rowCount = 0;
   devRowCount = 0;
   for (Checklist__c checkListTrnx: checklistTrnxList) {

    System.debug('checkListTrnx.Sales_Status__c==' + checkListTrnx.Sales_Status__c);
    System.debug('**===' + checkListTrnx.Checklist_Parameter__r.Document_Family__c);
    Document_Family__c docFamObj = new Document_Family__c();
    docFamObj = (docFamilyMap.get(checkListTrnx.DocumentFmlyName__c));
    System.debug('*docFamObj*===' + docFamObj);
    if (docFamObj != null) {
     System.debug('*outside ddev prepare' + checkListTrnx.Deviation_Master__c);
     if (checkListTrnx.Deviation_Master__c != null) {
      devRowCount += 1;
      System.debug('*inside ddev prepare');
      DocumentWrapper wrapperObjForDev = new DocumentWrapper(checkListTrnx, docFamObj.Documents__c, devRowCount);
      deviationDocWrapperList.add(wrapperObjForDev);
     } else {
      rowCount += 1;
      System.debug('*inside std doc list prepare' + checkListTrnx);

      DocumentWrapper wrapperObj = new DocumentWrapper(checkListTrnx, docFamObj.Documents__c, rowCount);
      docWrapperList.add(wrapperObj);
     }
    }
   }
   System.debug('docWrapperList size==' + docWrapperList.size());
   System.debug('deviationDocWrapperList size==' + deviationDocWrapperList.size());
   documentNameList.clear();
   for (DocumentWrapper doc: docWrapperList) {
    System.debug('doc.selectedDoc==' + doc.selectedDoc);
    System.debug('doc.singleDoc==' + doc.singleDoc);
    if (doc.selectedDoc != null)
     documentNameList.add(doc.selectedDoc);

    else if (doc.singleDoc != null)
     documentNameList.add(doc.singleDoc);
   }
   for (DocumentWrapper doc1: deviationDocWrapperList) {
    System.debug('doc1.selectedDoc==' + doc1.selectedDoc);
    System.debug('doc1.singleDoc==' + doc1.singleDoc);
    if (doc1.selectedDoc != null)
     documentNameList.add(doc1.selectedDoc);

    else if (doc1.singleDoc != null)
     documentNameList.add(doc1.singleDoc);
   }
   System.debug('documentNameList size==' + documentNameList.size());
   System.debug('documentNameList==' + documentNameList);

  }

 }
 public PageReference SaveSanctionChanges() {
  System.debug('****sanctionList****' + sanctionList);


  for (integer k = 0; k < sanctionList.size(); k++) {
   if (sanctionList[k].Status__c == 'Discrepancy Resolved') {
    Id userResolved = UserInfo.getUserId();
    sanctionList[k].Resolver_Name__c = userResolved;
   }
   if (sanctionList[k].Status__c == 'Closed') {
    sanctionList[k].Closed_Date__c = System.Today();
   }

   sanctionList[k].Type__c = 'SanctionCondition';
   System.debug('****sancCond****' + sanctionList[k].Type__c);


  } //end of for

  if (sanctionList.size() > 0)
   upsert sanctionList;

  sendMssg = false;
  sanctionList = [select Date_Time__c, Discrepancy_Stage__c, Party_Type__c, Party_Name__c,
   Discrepancy_Description__c, LoanApplication__c,
   RaiserName__c, Description__c,
   Priority__c, Resolution_Remarks__c, Status__c, Discrepancy_Party__c, Applicant_Name__c,
   Raiser_Role__c, createddate, Category__c,
   Assigned_To__c, Closed_Date__c, Resolver_Name__c, Type__c, OTPDiscrepancyCategory__c, OTPDiscrepancyDocuments__c, /*Added by sneha for  Bug -18583 Start*/ OTPDiscrepancyProduct__c /*Added by sneha for  Bug -18583 End*/
   /*Mortgage Start*/
   , Remarks__c, Discrepancy_Type__c /*Mortgage End*/
   from Discrepancy__c where LoanApplication__c =: Loan.Id and Type__c = 'SanctionCondition'
   order by Status__c asc, createddate asc
  ];
  return null;
 }

 //Save function for editing discrepancy
 public PageReference SaveChanges() {

  system.debug('---docType---' + docType);
  if (docType == 'LogDiscr') {
   if (discrepancyListCount > 0) {
    for (integer k = 0; k < discrepancyList.size(); k++) {
     if (discrepancyList[k].Status__c == 'Discrepancy Resolved') {
      Id userResolved = UserInfo.getUserId();
      discrepancyList[k].Resolver_Name__c = userResolved;
     }
     if (discrepancyList[k].Status__c == 'Closed') {
      discrepancyList[k].Closed_Date__c = System.Today();
     }

     //--------------- Mortgage Re-Engg Start---------------------
     if (Mortgageflag) {
      //Mortgage Start
      string str = '\n\n----------------\n';
      str = str + ' Status==> ' + discrepancyList[k].Status__c;
      discrepancyList[k].remarks__c = discrepancyList[k].remarks__c + str + '\n Remarks==> ' + discrepancyList[k].Resolution_Remarks__c;
      system.debug('---discrepancyList.remarks__c---' + discrepancyList[k].remarks__c);
      //Mortgage Start
     }
     //--------------- Mortgage Re-Engg End-----------------------

    } //end of for
    update discrepancyList;
   }
  } else {
   if (discrepancyListCountDis > 0) {
    for (integer k = 0; k < discrepancyListDis.size(); k++) {
     if (discrepancyListDis[k].Status__c == 'Discrepancy Resolved') {
      Id userResolved = UserInfo.getUserId();
      discrepancyListDis[k].Resolver_Name__c = userResolved;
     }
     if (discrepancyListDis[k].Status__c == 'Closed') {
      discrepancyListDis[k].Closed_Date__c = System.Today();
     }
    } //end of for

    //--------------- Mortgage Re-Engg Start---------------------
    if (CentralisedOpsShow && docType == 'DisbDiscr') {
     for (Discrepancy__c objDiscr: discrepancyListDis) {
      string str = '\n\n----------------\n';
      str = str + ' Status==> ' + objDiscr.Status__c;
      objDiscr.remarks__c = objDiscr.remarks__c + str + '\n Remarks==> ' + objDiscr.Resolution_Remarks__c;
      system.debug('---objDiscr.remarks__c---' + objDiscr.remarks__c);

     }
    }
    //--------------- Mortgage Re-Engg End-----------------------
    update discrepancyListDis;
   }
  }

  // sendMssg=false;
  discrepancyList = [select id, name, Discrepancy_Stage__c, Party_Type__c, Party_Name__c,
   Discrepancy_Description__c,
   RaiserName__c, Description__c,
   Priority__c, Resolution_Remarks__c, Status__c, Discrepancy_Party__c, Applicant_Name__c,
   Raiser_Role__c, createddate, Category__c,
   Assigned_To__c, Closed_Date__c, Resolver_Name__c, Discrepancy_Category__c
   /*Mortgage Start*/
   , Remarks__c, Discrepancy_Type__c /*Mortgage End*/
   from Discrepancy__c where LoanApplication__c =: Loan.Id and Type__c != 'SanctionCondition'
   order by Status__c asc, createddate asc
  ];

  // Start of general communication framework
  if (Mortgageflag) {
   if (discrepancyList != null && discrepancyList.size() > 0) {
    Integer closedCount = 0;
    Integer pendingCount = 0;
    for (Discrepancy__c disObj: discrepancyList) {
     if (disObj.Status__c.equalsIgnoreCase('Discrepancy Resolved') || disObj.Status__c.equalsIgnoreCase('Closed')) {
      closedCount++;
     } else
     if (disObj.Status__c.equalsIgnoreCase('Pending') || disObj.Status__c.equalsIgnoreCase('Re-opened')) {
      pendingCount++;
     }
    }

    system.debug('Closed Discrepancies --> ' + closedCount);

    if (pendingCount >= 5 && (Loan.Product__c == 'SHL' || Loan.Product__c == 'HFC SHL')) {
     List < Opportunity > LoanList = new List < Opportunity > ();
     LoanList.add(Loan);

     if (Loan.StageName == 'Underwriting') {
      system.debug('Sending Discrepancies SMS to Customer and Credit for SHL');
      GeneralCommunicationHandler.sendSMS(LoanList, 'DiscrepanciesC SMS-Cust'); // For SHL
      GeneralCommunicationHandler.sendSMS(LoanList, 'DiscrepanciesC SMS-Int'); // For SHL

      system.debug('Sending Discrepancies Email to Customer and Credit for SHL');
      GeneralCommunicationHandler.sendEmail(LoanList, 'DiscrepanciesC SMS-Cust'); // For SHL
      GeneralCommunicationHandler.sendEmail(LoanList, 'DiscrepanciesC SMS-Int'); // For SHL
     } else
     if (Loan.StageName == 'Branch Ops') {
      system.debug('Sending Discrepancies SMS to Customer and Ops for SHL');
      GeneralCommunicationHandler.sendSMS(LoanList, 'DiscrepanciesO SMS-Cust'); // For SHL
      GeneralCommunicationHandler.sendSMS(LoanList, 'DiscrepanciesO SMS-Int'); // For SHL

      system.debug('Sending Discrepancies Email to Customer and Ops for SHL');
      GeneralCommunicationHandler.sendEmail(LoanList, 'DiscrepanciesO SMS-Cust'); // For SHL
      GeneralCommunicationHandler.sendEmail(LoanList, 'DiscrepanciesO SMS-Int'); // For SHL
     }
    }

    if (pendingCount >= 1 && (Loan.Product__c == 'Home Loan' || Loan.Product__c == 'HFC Home Loan' || Loan.Product__c == 'HML' || Loan.Product__c == 'HSL' || Loan.Product__c == 'LAP' || Loan.Product__c == 'HFC LAP' || Loan.Product__c == 'HBLD' || Loan.Product__c == 'HBLS' || Loan.Product__c == 'HBLR' || Loan.Product__c == 'HFD' || Loan.Product__c == 'HFR' || Loan.Product__c == 'SALLAP')) { // Bug 15388 Added SALLAP product, as communication is same as LAP : FOR Credit and OPS Discrepancy
     // HBLS,HBLR,HBLD,HFD,HFR in if condition added by Suraj...NCM communication enhancement 
     List < Opportunity > LoanList = new List < Opportunity > ();
     LoanList.add(Loan);
     if (Loan.StageName == 'Underwriting') {
      system.debug('Sending Discrepancies SMS to Customer and Credit for SHL');
      GeneralCommunicationHandler.sendSMS(LoanList, 'DiscrepanciesC SMS-Cust'); // For SHL
      GeneralCommunicationHandler.sendSMS(LoanList, 'DiscrepanciesC SMS-Int'); // For SHL

      system.debug('Sending Discrepancies Email to Customer and Credit for SHL');
      GeneralCommunicationHandler.sendEmail(LoanList, 'DiscrepanciesC SMS-Cust'); // For SHL
      GeneralCommunicationHandler.sendEmail(LoanList, 'DiscrepanciesC SMS-Int'); // For SHL
     } else
     if (Loan.StageName == 'Branch Ops') {
      system.debug('Sending Discrepancies SMS to Customer and Ops for SHL');
      GeneralCommunicationHandler.sendSMS(LoanList, 'DiscrepanciesO SMS-Cust'); // For SHL
      GeneralCommunicationHandler.sendSMS(LoanList, 'DiscrepanciesO SMS-Int'); // For SHL

      system.debug('Sending Discrepancies Email to Customer and Ops for SHL');
      GeneralCommunicationHandler.sendEmail(LoanList, 'DiscrepanciesO SMS-Cust'); // For SHL
      GeneralCommunicationHandler.sendEmail(LoanList, 'DiscrepanciesO SMS-Int'); // For SHL
     }
    }

   }
  }
  // End of general communication framework 

  //SHOL COmmunication S
  if (DGFlag) {
   if (discrepancyList != null && discrepancyList.size() > 0) {
    Integer pendingCount = 0;
    for (Discrepancy__c disObj: discrepancyList) {
     if (disObj.Status__c.equalsIgnoreCase('Pending')) {
      pendingCount++;
     }
    }

    if (pendingCount >= 5 && isNewProductFlowEnabled == false) {
     List < Opportunity > LoanList = new List < Opportunity > ();
     LoanList.add(Loan);
     system.debug('Sending Discrepancies SMS to Customer and Sales for SHL');
     GeneralCommunicationHandler.sendSMS(LoanList, 'Discrepancies SMS-Cust'); // For SHL/SHOL
     GeneralCommunicationHandler.sendSMS(LoanList, 'Discrepancies SMS-Int'); // For SHL/SHOL

     system.debug('Sending Discrepancies Email to Customer and Sales for SHL');
     GeneralCommunicationHandler.sendEmail(LoanList, 'Discrepancies SMS-Cust'); // For SHL/SHOL
     GeneralCommunicationHandler.sendEmail(LoanList, 'Discrepancies SMS-Int'); // For SHL/SHOL
    }

    if (pendingCount >= 1 && isNewProductFlowEnabled == false) {
     List < Opportunity > LoanList = new List < Opportunity > ();
     LoanList.add(Loan);
     system.debug('Sending Discrepancies SMS to Customer and Sales for Home Loan/LAP');
     GeneralCommunicationHandler.sendSMS(LoanList, 'Deferral SMS-Cust'); // For Home Loan/LAP
     GeneralCommunicationHandler.sendSMS(LoanList, 'Deferral SMS-Int'); // For Home Loan/LAP

     system.debug('Sending Discrepancies Email to Customer and Sales for Home Loan/LAP');
     GeneralCommunicationHandler.sendEmail(LoanList, 'Deferral SMS-Cust'); // For Home Loan/LAP
     GeneralCommunicationHandler.sendEmail(LoanList, 'Deferral SMS-Int'); // For Home Loan/LAP
    }
   }
  }


  //SHOL COmmunication E

  // Added for disbursement

  discrepancyListDis = new List < Discrepancy__c > ();
  discrepancyListLog = new List < Discrepancy__c > ();
  for (Discrepancy__c ocl: discrepancyList) {
   system.debug('--SaveChanges--ocl.Checklist_type__c-- ' + ocl.Discrepancy_Category__c);
   if (ocl.Discrepancy_Category__c == 'Disbursement') {
    discrepancyListDis.add(ocl);
   } else {
    discrepancyListLog.add(ocl);
   }
  }

  //Assigning back to PropertyDocuments
  discrepancyList = new List < Discrepancy__c > ();
  discrepancyList = discrepancyListLog;
  system.debug('--SaveChanges--discrepancyList-- ' + discrepancyList.size());
  system.debug('--SaveChanges--discrepancyListDis-- ' + discrepancyListDis.size());


  return null;
 }



 public PageReference SaveDiscrepancy() {


  try {
   system.debug('---docType---' + docType);
   if (docType == 'LogDiscr') {

    integer discrepancyListUpdateCount;
    discrepancyListUpdateCount = [Select count() from Discrepancy__c where LoanApplication__c =: Loan.Id
     and Discrepancy_Check__c = 1 and Discrepancy_Category__c = 'Login'
     and Type__c != 'SanctionCondition'
    ];
    if (discrepancyListUpdateCount > 0) {
     discrepancyListUpdate = [Select Discrepancy_Check__c
      from Discrepancy__c where LoanApplication__c =: Loan.Id
      and Discrepancy_Check__c = 1 and Discrepancy_Category__c = 'Login'
      and Type__c != 'SanctionCondition'
     ];
     for (integer k = 0; k < discrepancyListUpdate.size(); k++) {
      discrepancyListUpdate[k].Discrepancy_Check__c = 0;
     }
     update discrepancyListUpdate;
    }
    if (discrepancyData.size() > 0) {
     if (StrVAContact != null) {
      integer count = discrepancyData.size();
      count = count - 1;
      discrepancyData[count].Discrepancy_Party__c = StrVAContact;

     }

     //--------------- Mortgage Re-Engg Start---------------------
     //string str = '\n\n----------------\n';
     if (CentralisedOpsShow && Mortgageflag) {
      for (Discrepancy__c objDiscr: discrepancyData) {
       objDiscr.Discrepancy_Category__c = 'Disbursement';
      }

     }

     String str = 'Status==>' + discrepancyData[0].Status__c;
     discrepancyData[0].remarks__c = str + '\n' + discrepancyData[0].Resolution_Remarks__c;
     system.debug('---discrepancyData.remarks__c---' + discrepancyData[0].remarks__c);


     insert discrepancyData;

     if (CentralisedOpsShow && Mortgageflag) {
      if (attachmentBodyOutside != null) {
       System.debug('Outside photo');
       Attachment ousidephoto = new Attachment();
       ousidephoto.Name = 'Discrepancy Attchment';
       ousidephoto.Body = attachmentBodyOutside;
       ousidephoto.IsPrivate = true;
       ousidephoto.Description = 'Discrepancy Attchment';
       ousidephoto.ParentId = discrepancyData[0].id;
       insert ousidephoto;
       System.debug('Attachment added to ' + discrepancyData[0].id);
      }
     }
     //--------------- Mortgage Re-Engg End-----------------------
     // viewsendEmail=true;
    }
    showDiscrepancy = false;
    editDiscrepancy = true;
    // discrepancysend=discrepancyData;
    List < Discrepancy__c > discrepancyData1 = new List < Discrepancy__c > ();
    discrepancyData = discrepancyData1;
    addrowDisc = false;
    // sendMssg=false;


   } else {
    integer discrepancyListUpdateCountDis;
    discrepancyListUpdateCountDis = [Select count() from Discrepancy__c where LoanApplication__c =: Loan.Id
     and Discrepancy_Check__c = 1 and Discrepancy_Category__c = 'Disbursement'
     and Type__c != 'SanctionCondition'
    ];
    if (discrepancyListUpdateCountDis > 0) {
     discrepancyListUpdateDis = [Select Discrepancy_Check__c
      from Discrepancy__c where LoanApplication__c =: Loan.Id
      and Discrepancy_Check__c = 1 and Discrepancy_Category__c = 'Disbursement'
      and Type__c != 'SanctionCondition'
     ];
     for (integer k = 0; k < discrepancyListUpdateDis.size(); k++) {
      discrepancyListUpdateDis[k].Discrepancy_Check__c = 0;
     }
     update discrepancyListUpdateDis;
    }
    if (discrepancyDataDis.size() > 0) {
     if (StrVAContactDis != null) {
      integer count = discrepancyDataDis.size();
      countDis = count - 1;
      discrepancyDataDis[countDis].Discrepancy_Party__c = StrVAContactDis;

     }
     insert discrepancyDataDis;
     //  viewsendEmailDis=true;
    }
    showDiscrepancyDis = false;
    editDiscrepancyDis = true;
    discrepancysendDis = discrepancyDataDis;
    List < Discrepancy__c > discrepancyData1 = new List < Discrepancy__c > ();
    discrepancyDataDis = discrepancyData1;
    addrowDiscDis = false;
    //sendMssgDis=false;
   }


   discrepancyList = [select id, name, Discrepancy_Stage__c, Party_Type__c, Party_Name__c,
    Discrepancy_Description__c,
    RaiserName__c, Description__c,
    Priority__c, Resolution_Remarks__c, Status__c, Discrepancy_Party__c, Applicant_Name__c,
    Raiser_Role__c, createddate, Category__c,
    Assigned_To__c, Closed_Date__c, Resolver_Name__c, Discrepancy_Category__c
    /*Mortgage Start*/
    , Remarks__c, Discrepancy_Type__c /*Mortgage End*/
    from Discrepancy__c where LoanApplication__c =: Loan.Id and Type__c != 'SanctionCondition'
    order by Status__c asc, createddate asc
   ];

   // Start of general communication framework
   if (Mortgageflag) {
    if (discrepancyList != null && discrepancyList.size() > 0) {
     Integer pendingCount = 0;
     for (Discrepancy__c disObj: discrepancyList) {
      if (disObj.Status__c.equalsIgnoreCase('Pending') || disObj.Status__c.equalsIgnoreCase('Re-opened')) {
       pendingCount++;
      }
     }

     if (pendingCount >= 5 && (Loan.Product__c == 'SHL' || Loan.Product__c == 'HFC SHL')) {
      List < Opportunity > LoanList = new List < Opportunity > ();
      LoanList.add(Loan);
      if (Loan.StageName == 'Underwriting') {
       system.debug('Sending Discrepancies SMS to Customer and Credit for SHL');
       GeneralCommunicationHandler.sendSMS(LoanList, 'DiscrepanciesC SMS-Cust'); // For SHL
       GeneralCommunicationHandler.sendSMS(LoanList, 'DiscrepanciesC SMS-Int'); // For SHL

       system.debug('Sending Discrepancies Email to Customer and Credit for SHL');
       GeneralCommunicationHandler.sendEmail(LoanList, 'DiscrepanciesC SMS-Cust'); // For SHL
       GeneralCommunicationHandler.sendEmail(LoanList, 'DiscrepanciesC SMS-Int'); // For SHL
      } else
      if (Loan.StageName == 'Branch Ops') {
       system.debug('Sending Discrepancies SMS to Customer and Ops for SHL');
       GeneralCommunicationHandler.sendSMS(LoanList, 'DiscrepanciesO SMS-Cust'); // For SHL
       GeneralCommunicationHandler.sendSMS(LoanList, 'DiscrepanciesO SMS-Int'); // For SHL

       system.debug('Sending Discrepancies Email to Customer and Ops for SHL');
       GeneralCommunicationHandler.sendEmail(LoanList, 'DiscrepanciesO SMS-Cust'); // For SHL
       GeneralCommunicationHandler.sendEmail(LoanList, 'DiscrepanciesO SMS-Int'); // For SHL
      }
     }

     if (pendingCount >= 1 && (Loan.Product__c == 'Home Loan' || Loan.Product__c == 'HFC Home Loan' || Loan.Product__c == 'HML' || Loan.Product__c == 'HSL' || Loan.Product__c == 'LAP' || Loan.Product__c == 'HFC LAP' || Loan.Product__c == 'HBLD' || Loan.Product__c == 'HBLS' || Loan.Product__c == 'HBLR' || Loan.Product__c == 'HFD' || Loan.Product__c == 'HFR' || Loan.Product__c == 'SALLAP')) { // Bug 15388 Added SALLAP product, as communication is same as LAP : FOR Credit Discrepancy and OPS
      // HBLS,HBLR,HBLD,HFD,HFR in if condition added by Suraj...NCM communication enhancement                       
      List < Opportunity > LoanList = new List < Opportunity > ();
      LoanList.add(Loan);
      if (Loan.StageName == 'Underwriting') {
       system.debug('Sending Discrepancies SMS to Customer and Credit for SHL');
       GeneralCommunicationHandler.sendSMS(LoanList, 'DiscrepanciesC SMS-Cust'); // For Home Loan/LAP
       GeneralCommunicationHandler.sendSMS(LoanList, 'DiscrepanciesC SMS-Int'); // For Home Loan/LAP

       system.debug('Sending Discrepancies Email to Customer and Credit for SHL');
       GeneralCommunicationHandler.sendEmail(LoanList, 'DiscrepanciesC SMS-Cust'); // For Home Loan/LAP
       GeneralCommunicationHandler.sendEmail(LoanList, 'DiscrepanciesC SMS-Int'); // For Home Loan/LAP
      } else
      if (Loan.StageName == 'Branch Ops') {
       system.debug('Sending Discrepancies SMS to Customer and Ops for SHL');
       GeneralCommunicationHandler.sendSMS(LoanList, 'DiscrepanciesO SMS-Cust'); // For Home Loan/LAP
       GeneralCommunicationHandler.sendSMS(LoanList, 'DiscrepanciesO SMS-Int'); // For Home Loan/LAP

       system.debug('Sending Discrepancies Email to Customer and Ops for SHL');
       GeneralCommunicationHandler.sendEmail(LoanList, 'DiscrepanciesO SMS-Cust'); // For Home Loan/LAP
       GeneralCommunicationHandler.sendEmail(LoanList, 'DiscrepanciesO SMS-Int'); // For Home Loan/LAP
      }
     }
    }
   }
   // End of general communication framework 

   // Added for Disbursement
   discrepancyListDis = new List < Discrepancy__c > ();
   discrepancyListLog = new List < Discrepancy__c > ();
   for (Discrepancy__c ocl: discrepancyList) {
    system.debug('--savede--ocl.Checklist_type__c-- ' + ocl.Discrepancy_Category__c);
    if (ocl.Discrepancy_Category__c == 'Disbursement') {
     discrepancyListDis.add(ocl);
    } else {
     discrepancyListLog.add(ocl);
    }
   }

   //Assigning back to PropertyDocuments
   discrepancyList = new List < Discrepancy__c > ();
   discrepancyList = discrepancyListLog;
   system.debug('---saved-discrepancyList-- ' + discrepancyList.size());
   system.debug('--csaved-discrepancyListDis-- ' + discrepancyListDis.size());


   //Communication for SAL Line starts      

   System.debug(Loan.Product__c + 'Loan.Product__c***********');
   //SBS CS SAL
   //OTPv3 TeleRm Rohit 15229 condition checked from custom label       
   if (salariedProducts.size() > 0 && salariedProducts.contains(Loan.Product__c)) {

    /*Responsys Dynamic Parameters Bug 15653 s*/
    List < Applicant__c > appList = new List < Applicant__c > ();
    appList.add(applicantPrimary);
    List < Opportunity > LoanList = new List < Opportunity > ();
    LoanList.add(Loan);
    GeneralCommunicationHandler.sendSMS(LoanList, appList, 'LA DefferalBFL-Int');
    /*Responsys Dynamic Parameters Bug 15653 e*/
   }
   //Communication for SAL Line ends   

   savedSuccessfull = true;
   message = 'Saved successfully';
  } catch (Exception e) {
   System.debug('****Exception: ' + e.getMessage());
   savedSuccessfull = true;
   message = e.getMessage() + '  ' + e.getLineNumber() + '  ' + e.getCause() + '  ' + e.getTypeName();
   SendExceptionMail(message, 'Exception came in MidOffice flow (Eligibility)');

  }
  return null;
 }


 public PageReference SaveSanctionDetails() {
  integer discrepancyListUpdateCount;
  double x = 0;
  discrepancyListUpdateCount = [Select count()
   from Discrepancy__c where LoanApplication__c =: Loan.Id AND Type__c = 'SanctionCondition'
   and Discrepancy_Check__c = 1
  ];
  if (discrepancyListUpdateCount > 0) {
   discrepancyListUpdate = [Select Discrepancy_Check__c, LoanApplication__c
    from Discrepancy__c where LoanApplication__c =: Loan.Id AND Type__c = 'SanctionCondition'
    and Discrepancy_Check__c = 1
   ];
   for (integer k = 0; k < discrepancyListUpdate.size(); k++) {
    discrepancyListUpdate[k].Discrepancy_Check__c = 0;
   }
   update discrepancyListUpdate;
  }
  system.debug('*******discrepancyData******' + discrepancyData);

  if (discrepancyData.size() > 0) {
   x = 0;
   if (StrVAContact != null) {
    integer count = discrepancyData.size();
    count = count - 1;
    discrepancyData[count].Discrepancy_Party__c = StrVAContact;
   }
   for (integer k = 0; k < discrepancyData.size(); k++) {
    discrepancyData[k].Type__c = 'SanctionCondition';
   }
   //For SAL/SPL

   if (x == 0) {
    insert discrepancyData;
   } else {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You cannot enter duplicate document.'));
    return null;
   }
   system.debug('******insertted *discrepancyData******' + discrepancyData);
   // viewsendEmail=true;
  }
  showDiscrepancy = false;
  editDiscrepancy = true;
  discrepancysend = discrepancyData;
  List < Discrepancy__c > discrepancyData1 = new List < Discrepancy__c > ();
  discrepancyData = discrepancyData1;
  addrowDisc = false;
  sendMssg = false;

  discrepancyList = [select Discrepancy_Stage__c, Party_Type__c, Party_Name__c,
   Discrepancy_Description__c, LoanApplication__c,
   RaiserName__c, Description__c,
   Priority__c, Resolution_Remarks__c, Status__c, Discrepancy_Party__c, Applicant_Name__c,
   Raiser_Role__c, createddate, Category__c,
   Assigned_To__c, Closed_Date__c, Resolver_Name__c, Type__c, OTPDiscrepancyCategory__c, OTPDiscrepancyDocuments__c, /*Added by sneha for  Bug -18583 Start*/ OTPDiscrepancyProduct__c /*Added by sneha for  Bug -18583 End*/
   /*Mortgage Start*/
   , Remarks__c, Discrepancy_Type__c /*Mortgage End*/
   from Discrepancy__c where LoanApplication__c =: Loan.Id AND Type__c = 'SanctionCondition'
   order by Status__c asc, createddate asc
  ];
  return null;
 }
 /**************************  Wrapper Class  ****************************/
 public class DocumentWrapper {
  public Boolean showPicklist {
   get;
   set;
  }
  public String selectedDoc {
   get;
   set;
  }
  public String deviationName {
   get;
   set;
  }
  public String singleDoc;
  public Checklist__c docFamObj;
  public List < SelectOption > documentList;
  public List < String > docListTemp;
  public Integer rowNum;
  public String docName;
  public Boolean salesStausDisable;
  public DocumentWrapper(Checklist__c docfam, String docList, Integer num) {
   showPicklist = true;
   singleDoc = '';
   rowNum = num;
   docListTemp = new List < String > ();
   documentList = new List < SelectOption > ();
   docFamObj = new Checklist__c();
   docFamObj = docfam;
   docName = docfam.DocumentFmlyName__r.Name;
   docFamObj.Mandatory__c = docfam.Mandatory__c;
   System.debug('docFamObj.Checklist_Parameter__r.DeviationMaster__c==' + docFamObj.Deviation_Master__c);
   if (docFamObj.Deviation_Master__c != null) {
    System.debug('docFamObj.Deviation_Master__r.Deviation_name__c==' + docFamObj.Deviation_Master__r.Deviation_name__c);
    deviationName = docFamObj.Deviation_Master__r.Deviation_name__c;
   }
   System.debug('docListe==' + docList);
   if (docList != null && docList != '') {
    docList = docList.replaceAll('_', '');
    docListTemp = docList.split(';', -2);
   }
   if (docListTemp.size() > 0) {
    Set < String > docSet = new Set < String > ();
    docSet.addAll(docListTemp);
    if (docFamObj.Document__c != null && docFamObj.Document__c != '') {
     System.debug('inside document saved docSet before remove==' + docSet);
     docSet.remove(docFamObj.Document__c);
     System.debug('docSet after remove==' + docSet);
     //documentList.addAll(docSet);
     //documentList.clear();
     documentList.add(new SelectOption(docFamObj.Document__c, docFamObj.Document__c));
     for (String strDoc: docSet)
      documentList.add(new SelectOption(strDoc, strDoc));
     System.debug('documentList==' + documentList);
    } else {
     for (String doc: docListTemp) {
      System.debug('inside document not saved==' + docListTemp);
      documentList.add(new SelectOption(doc, doc));
     }
    }
   }
   if (documentList.size() == 1) {
    showPicklist = false;
    singleDoc = docListTemp[0];
   }
   if (docfam.Sales_Status__c == 'Received') {
    salesStausDisable = true;
    System.debug('obj.salesStausDisable ==' + salesStausDisable);

   }
  }
  public Checklist__c getdocFamObj() {
   return docFamObj;
  }
  public String getdocName() {
   return docName;
  }
  public String getdeviationName() {
   return deviationName;
  }
  public String getselectedDoc() {
   return selectedDoc;
  }
  public String getsingleDoc() {
   return singleDoc;
  }
  public Boolean getShowPicklist() {
   return showPicklist;
  }
  public Boolean getsalesStausDisable() {
   return salesStausDisable;
  }
  public Integer getrowNum() {
   return rowNum;
  }
  public List < SelectOption > getdocumentList() {
   return documentList;
  }
 }

 public List < RePayment_mode_detail__c > getRepayList() {
  RepayListStr = JSON.serialize(RepayList); //Ops process added by Manasi
  return RepayList;
 }

 public void addrowRepay() {
  RePayment_mode_detail__c addRepay = new RePayment_mode_detail__c();

  //added by Suraj...ECS Mandate enhancement
  //Ops process added by Manasi start
  //RepayList -- stores number of rows added
   if (opsProductsFlag == true) {
   //Bug:23402**S**
            string favouring = '';
            for(Current_Disbursal_Details__c cd: DisbList){
                if(cd.isTopUp__c == false){
                  favouring = cd.Favouring__c;
                   break;
                }
            }
            addRepay.Account_Holder_Name__c = favouring;
            addRepay.PDC_By_Name__c = favouring;
            //Bug:23402 **E**
            addRepay.Repayment_Mode__c ='ECS';
  }

  RepayListStr = JSON.serialize(RepayList);
  //Ops process added by Manasi end
  RepayList.add(addRepay);
  if (RepayList.size() > 0)
   repayFlag = true;
 }

 public String DuplicateLoanId {
  get;
  set;
 } // ECS Barcode pankaj
 public void SaveRepay() {
  try {
   DuplicateLoanId = ''; //BugId-15342
   DuplicateBarCodeNo = '';
   Boolean flag = true;
   List < String > BarNoList = new List < String > (); // List for newly inserting Instrument Details Records -BugId-15342
   List < String > BarNolistUpdate = new List < String > (); // List for already existing Records-//BugId-15342
   Set < String > duplicateSet = new Set < String > ();
   for (RePayment_mode_detail__c rList: RepayList) {
    if (rList.id == null && rList.ECS_Barcode_No__c != null) {
     BarNoList.add(rList.ECS_Barcode_No__c);
    } else {
     BarNolistUpdate.add(rList.ECS_Barcode_No__c);
    }
   }
   system.debug('List of new barcode number is##' + BarNoList);
   system.debug('List of already existing Barcode Number in same LAN##' + BarNolistUpdate);

   List < RePayment_mode_detail__c > FinalList = [select ECS_Barcode_No__c, Loan_Application__c from RePayment_mode_detail__c where ECS_Barcode_No__c != null and ECS_Barcode_No__c IN: BarNoList Limit 1];
   List < RePayment_mode_detail__c > FinalListUpdate = [select ECS_Barcode_No__c, Loan_Application__c from RePayment_mode_detail__c where ECS_Barcode_No__c != null and Loan_Application__c !=: LoanId and ECS_Barcode_No__c IN: BarNolistUpdate Limit 1];
   system.debug('List of Matched New Barcode number' + FinalList);
   system.debug('List of Matched old Barcode number' + FinalListUpdate);
   if (FinalList.size() > 0 && FinalList != null && FinalList[0].Loan_Application__c != null && FinalList[0].ECS_Barcode_No__c != null) {
    DuplicateLoanId = FinalList[0].Loan_Application__c;
    DuplicateBarCodeNo = FinalList[0].ECS_Barcode_No__c;
   } else {
    if (FinalListUpdate.size() > 0 && FinalListUpdate != null && FinalListUpdate[0].Loan_Application__c != null && FinalListUpdate[0].ECS_Barcode_No__c != null) {
     DuplicateLoanId = FinalListUpdate[0].Loan_Application__c;
     DuplicateBarCodeNo = FinalListUpdate[0].ECS_Barcode_No__c;
    }

   }


   system.debug('The DuplicateLoanId is' + DuplicateLoanId);
   system.debug('The DuplicateBarCodeNo is:' + DuplicateBarCodeNo);

   for (String bNo: BarnoList) {
    if (!duplicateSet.add(bNo)) {
     flag = false;
     DuplicateBarCodeNo = bNo;
    }
   }
   if (flag != true) {
    DuplicateLoanId = String.valueOf(LoanId);
   }
   if (DuplicateLoanId != '') {
    DuplicateLAN = DuplicateLoanId;
    system.debug('DuplicateLAN is ' + DuplicateLAN);
    // return;// Manasi 
   } else {
    DuplicateLAN = '';
   }


   List < RePayment_mode_detail__c > Repaydet = new List < RePayment_mode_detail__c > ();
   for (integer i = 0; i < RepayList.size(); i++) {
    RepayList[i].Loan_Application__c = LoanId;
    if (RepayList[i].Account_Holder_Name__c != null)
     Repaydet.add(RepayList[i]);
    if (RepayList.size() > 0)
     repayFlag = true;
    //added by Suraj...ECS Mandate enhancement  
   }
   system.debug('hello world');
   upsert Repaydet;
   if (RepayList.size() > 0)
    repayFlag = true;
   //added by Suraj...ECS Mandate enhancement          
   //cash in 60 min start
   if (Repaydet != null && Repaydet.size() > 0) {
    /*if(Repaydet[0].IFSC_Code__c!=null)
{
    Loan.IFSC_Code__c=Repaydet[0].IFSC_Code__c;
}*/
    if (Repaydet[0].MICR_Code__c != null) {
     Loan.MICR_Number__c = Repaydet[0].MICR_Code__c;
    }
    if (Repaydet[0].A_C_type__c != null) {
     Loan.A_C_Type__c = Repaydet[0].A_C_type__c;
    }
    if (Repaydet[0].Account_Holder_Name__c != null) {
     Loan.Repayment_Account_Holder_Name__c = Repaydet[0].Account_Holder_Name__c;
    }
    if (Repaydet[0].A_C_NO__c != null) {
     Loan.Bank_A_c_No_of_Customer__c = Repaydet[0].A_C_NO__c;
    }
    if (Repaydet[0].Bank_Name__c != null) {
     Loan.Repayment_Bank_Name__c = Repaydet[0].Bank_Name__c;
    }
    if (Repaydet[0].Repayment_Mode__c != null) {
     Loan.Repayment_Mode__c = Repaydet[0].Repayment_Mode__c;
    }
    if (Repaydet[0].ECS_Start_Date__c != null) {
     Loan.First_Due_Date__c = Repaydet[0].ECS_Start_Date__c;
    }
    if (Loan != null) {
     upsert Loan;
    }
    if (loan.Account.Date_of_Birth__c != null && loan.MICR_Number__c != null && loan.A_C_No__c != null && loan.Account_Holder_Name__c != null && loan.A_C_Type__c != null && loan.IFSC_Code__c != null) {
     blindDatapresentFlag = true;

    } else {
     blindDatapresentFlag = false;
    }
   }
   //cash in 60 min ends
   savedSuccessfull = true;
   message = 'Repayment mode Details Saved Successfully !!!';
  } catch (Exception e) {
   ApexPages.addMessages(e);
  }
 }

 public PageReference senttoFinnone() {
  //try {
  //ApexPages.CurrentPage().getParameters().put('Id',Loan.Id);
  System.debug('In senttoFinnone.........................');
  system.debug('in fin one, Loan: ' + Loan);
  //Bug 17556 s
  boolean approveROI = false;
  boolean approvePF = false;
  system.debug(applicantPrimary);
  if (salmobilityflagv2 != null && salmobilityflagv2) {
  /* Bug 22624 Start - Hrushikesh Sprint 5C */
    Decimal sumAllDisb=0; 
    Decimal Netdisb = 0.0;
    Decimal totalCharges =0.0; 
    List<Fees_and_Charge__c> charges = new  List<Fees_and_Charge__c>();
    if(Loan != null)
        charges = Loan.Fees_and_Charges__r;
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
    if (Loan != null && Loan.Loan_Amount_with_Premium__c != null) {
        Netdisb = Loan.Loan_Amount_with_Premium__c-totalCharges;
    }
     system.debug('Netdisb here is'+Netdisb);
    List<Current_Disbursal_Details__c> disbList= [select id, Disbursement_Amount__c, Loan_Application__c, Disbursal_Mode__c   from Current_Disbursal_Details__c where Loan_Application__c = : Loan.id  ];
    for(Current_Disbursal_Details__c disb: disbList)
    {
        sumAllDisb=sumAllDisb + disb.Disbursement_Amount__c;
    }
    if(sumAllDisb != Netdisb)
    {
        mobilitystatus = 'Disbursment Amount must be equal to Net Disbursement Amount';
    }
    /* Bug 22624 Stop - Hrushikesh Sprint 5C */
   if (!CommonUtility.isempty(applicantPrimary)) {
    //Bug #17924 S - Added for Mobility Flow
    Map < String, Object > jsonResp = (Map < String, Object > ) JSON.deserializeUnTyped(fdQuesValidate(Loan.id));
    String insError = '';
    system.debug('jsonResp ---->' + jsonResp);
    if (!Boolean.valueOf(jsonResp.get('isValid'))) {
     if (!String.isBlank(String.valueOf(jsonResp.get('msgStr1')))) {
      insError = String.valueOf(jsonResp.get('msgStr1'));
      //return null;
     } else if (!String.isBlank(String.valueOf(jsonResp.get('msgStr2')))) {
      insError = String.valueOf(jsonResp.get('msgStr2'));
      //return null;
     }
    }
    if (!String.isBlank(insError)) {
     mobilitystatus = insError;
     return null;

    }
    system.debug('mobilitystatus :::' + mobilitystatus);
    //Bug #17924 E - Added for Mobility Flow

    if (applicantPrimary.PFApproveStatus__c != null) {
     if (applicantPrimary.PFApproveStatus__c.contains('Pending')) {
      mobilitystatus = 'PF/ROI is not approved';
      return null;
     }
    }
    /*else{
                if(applicantPrimary.PFApproveStatus__c != null)
                {
                    if(applicantPrimary.PFApproveStatus__c.contains('Pending')){
                        mobilitystatus = 'PF is not approved';
                        return null;
                    }
                }
                if(applicantPrimary.ROIApproveStatus__c != null){
                    if(applicantPrimary.PFApproveStatus__c.contains('Pending')){
                        mobilitystatus = 'ROI is not approved';
                        return null;
                    }
                }
            }*/
   }
  }
  //Bug 17556 e
  //Bug 16173 - VRPL changes for HFC Start : Send Finnone validation
  try {
   System.debug('Loan : ' + Loan.Id);
   if (Loan != null && Loan.Scheme_Master__c != null) {
    if (initialSchemeID != null && Loan.Scheme_Master__r.VRPL_Flag__c != null && Loan.Scheme_Master__r.VRPL_Flag__c == 'YES' && (ParentDealID == null || ParentDealID == '')) {
     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Parent Deal ID is mandatory as this is a VRPL case'));
     return null;
    }
    if (initialSchemeID != null) {
     Loan.Scheme_Master__c = initialSchemeID; //Added to resolve scheme update issue in send to finnone 
    }
   }
  } catch (Exception e) {
   System.debug('Exception occurred in senttoFinnone : ' + e);
   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Send to Finnone operation failed! Exception : ' + e.getMessage()));
  }
  //Bug 16173 - VRPL changes for HFC End : Send Finnone Validation



  //13901 S
  if (Loan != null) {
   if (Loan.Scheme_Master__r.Blind_Data_Entry__c == true) {
    applicantPrimary.Blind_Data_Entry_Flag__c = true;

    blindDataFlag = false;

   }
  }

  //13901 E

  /* Added By Ankush Bug ID 14128 start */
  system.debug('In Side Send To Finnone  Verification ' + Loan.Verification__r);
  //15506 Pro Doc Invisible Monitoring 

  // Bug 14701 added size greater than condition AP
  //Added DBOL in productList for BUGID 16959
  String productsList = 'PSBL,PRO,Doctors,DBOL';

  if (Loan != null && productsList.contains(Loan.product__c) && Loan.Verification__r != null && Loan.Verification__r.size() > 0) {
   List < Verification__c > verLst = Loan.Verification__r;
   System.debug('verLst >>>> ' + verLst);
   System.debug('Level of Activity >>>> ' + verLst[0].Level_of_Activity__c);
   System.debug('verLst sTATUS >>>> ' + verLst[0].Status__c);
   system.debug('verLst >>>' + verLst);
   if (verLst != null && verLst.size() > 0) {
    for (Verification__c verObj: verLst) {
     if (verObj != null &&
      (verObj.Level_of_Activity__c != null && verObj.Level_of_Activity__c.equalsIgnoreCase('Mandatory Verification')) &&
      (verObj.Status__c != null && (verObj.Status__c.equalsIgnoreCase('Negative') /* || verObj.Status__c.equalsIgnoreCase('fraud') */ ))
     ) {
      System.debug('In Side IF block >>>');
      // Show Page Message and return
      ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Case Can not move to Finnone as Verification Status is Negative For Mandatory Verification Case');
      Apexpages.addMessage(errMsg);
      return null;
     }
    }
   }
  }

  // Merged the query for geotagging and Bug 22141
  List < Verification__c > verificationList = [SELECT Id, Geo_Tagging__c, Sales_Status__c, Credit_Status__c, Ops_Status__c, Customer_Bank_Acc_Confirmation__c, Customer_Bank_Acc_Confirmation_IP__c, Verification_Type__c FROM Verification__c WHERE Loan_Application__c =: Loan.Id ORDER BY CreatedDate DESC];

  /* Added By Ankush Bug ID 14128 End */
  /* Bug-22141 Start*/
  if (label.BankingValidationProducts != null && string.isNotBlank(Label.BankingValidationProducts)) {
   List < string > ListofProducts = Label.BankingValidationProducts.split(';');
   if (Loan != null && ListofProducts.contains(Loan.Product__c)) {
    Boolean isallowedfinnone = false;
    List < Verification__c > verificationObjList = new List < Verification__c > ();
    if (Loan != null && verificationList != null && verificationList.size() > 0) {
     for (Verification__c obj: verificationList) {
      if (obj.Verification_Type__c == 'Banking Validations') {
       verificationObjList.add(obj);
      }

     }
    }
    system.debug('verification object list' + verificationObjList);
    // to be added 
    if (Loan != null && Loan.Sourcing_Channel__c != null && verificationObjList != null && verificationObjList.size() > 0) {
     String Sourcing_channlVal = null;
     String custConfirmVal = null;
     if (Loan.Sourcing_Channel__r.Channel__c == '' || Loan.Sourcing_Channel__r.Channel__c == null) {
      Sourcing_channlVal = 'Blank';
     } else {
      Sourcing_channlVal = Loan.Sourcing_Channel__r.Channel__c;
     }
     if (verificationObjList[0].Customer_Bank_Acc_Confirmation__c == '' || verificationObjList[0].Customer_Bank_Acc_Confirmation__c == null) {
      custConfirmVal = 'Blank';
     } else {
      custConfirmVal = verificationObjList[0].Customer_Bank_Acc_Confirmation__c;
     }
     system.debug('sourcing chanlle val' + Sourcing_channlVal + 'custConfirmVal' + custConfirmVal);
     StaticResource sr = [select id, body from StaticResource Where Name = 'BankingValidationResource'];
     // if(sr!=null && sr!='')
     // {
     String validationJson = sr.body.toString();
     if (validationJson != null && validationJson != '') {
      //system.debug('json is'+validationJson);
      Map < string, object > validationMapSour = (Map < string, object > ) JSON.deserializeUntyped(validationJson);
      //system.debug('jsonmap is'+validationMap);
      if (!CommonUtility.isEmpty(validationMapSour)) {
       Map < string, object > validationMapCustVal = (Map < string, object > ) validationMapSour.get(Sourcing_channlVal);
       //system.debug('validationMap2'+validationMap2);
       if (!CommonUtility.isEmpty(validationMapCustVal)) {
        String finalvalue = (String) validationMapCustVal.get(custConfirmVal);
        system.debug('final value is' + finalvalue);
        if (finalvalue == 'Allowed') {
         isallowedfinnone = true;
        }
       }

      }

     }

     // }

    }
    if (isallowedfinnone == false) {
     ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'For this channel Type, Customer Bank Account Confirmation criteria is not met');
     Apexpages.addMessage(errMsg);
     return null;
    }
    if (verificationObjList == null || verificationObjList.size() == 0) {
     ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Cannot Proceed,Bank Account Verification Not Completed !');
     Apexpages.addMessage(errMsg);
     return null;
    }

   }
  }



  /* Bug-22141 End*/



  //YK Change related to CPV enhancement bug id - 12172  Start
  // List < Verification__c > verificationList = [SELECT Id, Sales_Status__c, Credit_Status__c, Ops_Status__c FROM Verification__c WHERE Geo_Tagging__c =: true AND Loan_Application__c =: Loan.Id];
  

  //changed for 22141
  List < Verification__c > verificationnewList = new List < Verification__c > ();
  for (Verification__c verificationObj: verificationList) {
   if (verificationObj.Geo_Tagging__c == true) {
    verificationnewList.add(verificationObj);
   }

  }

  if (verificationnewList != null && verificationnewList.size() > 0) {
   Boolean sendToFinOneFlag = false;
   for (Verification__c verificationObj: verificationnewList) {
    if ((verificationObj.Sales_Status__c == 'Positive' || verificationObj.Sales_Status__c == 'Deferral') &&
     ((verificationObj.Credit_Status__c == 'Complete' && verificationObj.Ops_Status__c == 'Complete') ||
      (verificationObj.Credit_Status__c == 'Required' && (verificationObj.Ops_Status__c == 'Complete' || verificationObj.Ops_Status__c == 'Deferral')) ||
      (verificationObj.Credit_Status__c == 'Not Required' && verificationObj.Ops_Status__c == 'Not Applicable'))) {
     sendToFinOneFlag = true;
    } else {
     sendToFinOneFlag = false;
     break;
    }
   }

   if (!sendToFinOneFlag) {
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Loan application can not be moved to FinOne, because it has failed either Office Verification or Residence Verification policy for Primary or Financial Co-Applicant.'));
    return null;
   }
  }
  //YK Change related to CPV enhancement bug id - 12172  End
  /* Customer Level Collateral Tracking added by priya start  */
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
      //List<Property_Details__c> propList = SelectQueriesHelperClass.QueryPropertyDetailsMortgage(Loan.id);
      system.debug('Loan.Property_Details__r>>>' + Loan.Property_Details__r);
      if (!CommonUtility.isEmpty(Loan.Property_Details__r) && (Loan.Property_Details__r).size() > 0) {
       decimal sum = 0;
       for (Property_Details__c obj: Loan.Property_Details__r) {
        if (!CommonUtility.IsEmpty(obj.Amount_fund_property__c)) {
         sum = sum + obj.Amount_fund_property__c;
        }
       }
       system.debug('sum>>' + sum + 'Loan.Approved_Loan_Amount__c>>' + Loan.Approved_Loan_Amount__c);
       if (!CommonUtility.IsEmpty(Loan.Approved_Loan_Amount__c) && sum != 0 && sum != Loan.Approved_Loan_Amount__c) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Amount funded on this property should be equal to Approved Loan Amount.'));
        return null;
       }
      }
     }
    }
   }
  }
  /* Customer Level Collateral Tracking added by priya end  */
  /* Prajyot 12830 GST implementation Start */
  List < Address_Details__c > addressList = new List < Address_Details__c > ();
  addressList = [select id, State__c, Skip_Validation_Rules__c, Exemption_Applicable__c,
   Adderss_Line_3__c, Address_Line_2__c, Address_Line_1__c, city__c, Loan_application__c,
   Contact_Person_Number__c, Consider_for_Loan__c, Applicant__c, Applicant__r.name, GST_IN_Number__c, Lead__c,
   Lead_Applicant__c, Pin_Code__c, Product_Offering__c
   from Address_Details__c where Loan_application__c =: loanid and GST_IN_Number__c != null
  ];
  Integer considerForLoanCount = 0;
  if (addressList != null && addressList.size() > 0) {
   system.debug('considerForLoanCount ---000-->> ' + considerForLoanCount);
   for (Address_Details__c adr: addressList) {
    if (adr.Consider_for_Loan__c == 'Yes') {
     considerForLoanCount = considerForLoanCount + 1;
    }
   }
   if (considerForLoanCount == 0) {
    system.debug('considerForLoanCount --222--->> ' + considerForLoanCount);
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No record  available to consider for loan.'));
    return null;
   } else if (considerForLoanCount > 1) {
    system.debug('considerForLoanCount --333--->> ' + considerForLoanCount);
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'More than one Consider for Loan records found.'));
    return null;
   }
  }
  /* Prajyot 12830 GST implementation End */

  //ApexPages.StandardController controller = new ApexPages.StandardController(Loan); //commented for 17556
  //Cibil Validation Enhancement-Leena-10661 -start
  String products;
  set < String > setProduct;
  if (LaonApplicationCreation__c.getValues('CibilTriggerValidationProducts') != null) {
   products = LaonApplicationCreation__c.getValues('CibilTriggerValidationProducts').Products__c;
   setProduct = new Set < String > (products.split(';'));
  }
  String flag;
  if (setProduct != null && setProduct.size() > 0 && setProduct.contains(Loan.Product__c)) {
   if (Loan.customer_type__c == 'Individual') {
    if (applicantPrimary != null && Loan != null)
     flag = CommonUtility.triggerCibilValidation(applicantPrimary, Loan);
   }
   if (Loan.customer_type__c == 'Corporate') {
    Applicant__c PrimaryFinnacialCOAPP;

    for (Applicant__c app: applicantList) {
     if (app.Applicant_type__C == 'Primary Financial Co-Applicant') {
      PrimaryFinnacialCOAPP = app;
     }
    }
    if (PrimaryFinnacialCOAPP != null && Loan != null)
     flag = CommonUtility.triggerCibilValidation(PrimaryFinnacialCOAPP, Loan);
   }
  }
  if (flag != null && flag != '' && flag.contains('true')) {
   List < String > setReturnedValues = new List < String > (flag.split(';'));
   //17556 added if else
   if (setReturnedValues != null && setReturnedValues.size() > 0) {
    if (salmobilityflagv2 != null && salmobilityflagv2)
     mobilitystatus = 'CIBIL  is  ' + setReturnedValues[1] + 'days old. Validity of CIBIL is expired as per policy. Kindly re-trigger CIBIL';
    else
     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'CIBIL  is  ' + setReturnedValues[1] + 'days old. Validity of CIBIL is expired as per policy. Kindly re-trigger CIBIL'));
   }
   return null;
  }
  //Cibil Validation Enhancement-Leena- 10661 -end
  System.debug('Calling SendFinnOne.................');
  SendFinnOne sendFin; // changed for 17556
  //bug 17556 s
  if (salmobilityflagv2 != null && salmobilityflagv2) {
   SendFinnOne.loanIdforMob = Loan.Id;
   ApexPages.StandardController controller = new ApexPages.StandardController(Loan);
   sendFin = new SendFinnOne(controller);

  } else {
   ApexPages.StandardController controller = new ApexPages.StandardController(Loan);
   sendFin = new SendFinnOne(controller);
  }
  //bug 17556 e
  PageReference finnnoneStatus;
  if (!TEST.isRunningTest()) {
   /* bug 17556 s -- added if else*/
   if (salmobilityflagv2 != null && salmobilityflagv2) {
    sendFin.sendfinn();
    mobilitystatus = sendFin.mobilityStatus;
   } else {
    finnnoneStatus = sendFin.sendfinn();
   }
   /* bug 17556 e*/
  } else {
   //Bug 17556 s
   if (salmobilityflagv2 != null && salmobilityflagv2) {
    sendFin.sendfinn();
    mobilitystatus = sendFin.mobilityStatus;
   } else {
    finnnoneStatus = new Pagereference('/' + Loan.Id);
   }
   //Bug 17556 e 

  }
  //17556 added conditions in if
  if ((salmobilityflagv2 != null && salmobilityflagv2 && mobilitystatus != null) || (salmobilityflagv2 != null && !salmobilityflagv2 && finnnoneStatus == null)) {
   return null;
  } else {

   Loan.stagename = 'Moved To Finnone';
   Loan.Sent_To_Finnone__c = true;
   /*HSOL product START*/
   if (Loan.product__c != null && Loan.product__c == 'SHOL' && Loan.Loan_Amount_with_Premium__c != null && Loan.Loan_Amount_with_Premium__c < 10000000) {
    System.debug('HSOL Loan Condition');
    Loan.product__c = 'HSOL';
   }
   /*HSOL product END*/
   if (Loan != null)
    upsert Loan;
   /* OPs Process Efficiency added by Priya start   */
   if (opsProductsFlag) {
    List < Current_Disbursal_Details__c > CDDListToUpdate = new List < Current_Disbursal_Details__c > ();
    system.debug('DisbList>>' + DisbList);
    if (DisbList.size() > 0) {
     for (Current_Disbursal_Details__c cdlist: DisbList) {
      cdlist.Disbursement_Date__c = system.today();
     }
     upsert DisbList;
    }
   }
   /* OPs Process Efficiency added by Priya end   */
   //code added by leena-Doctors/PRO communication framework-start
   if (ProductSMS__c.getValues('DoctorsPROCommunicationproducts') != null) {
    transient String appidsms = ProductSMS__c.getValues('DoctorsPROCommunicationproducts').Produtc__c;
    transient set < String > appidsmsProducts;
    if (appidsms != null)
     appidsmsProducts = new Set < String > (appidsms.split(';'));
    if (appidsmsProducts.contains(Loan.Product__c)) {
     system.debug('inside sent to finnone condition');
     List < Discrepancy__c > discrepancyList = new List < Discrepancy__c > ();
     discrepancyList = [select Status__c, LoanApplication__c, id from Discrepancy__c where LoanApplication__c =: Loan.id];
     if (discrepancyList.size() <= 0) {
      List < Opportunity > LoanList = new List < Opportunity > ();
      LoanList.add(Loan);
      GeneralCommunicationHandler.sendSMS(LoanList, 'loan disbursed-cust');
      GeneralCommunicationHandler.sendSMS(LoanList, 'loan disbursed-Int');
      GeneralCommunicationHandler.sendEmail(LoanList, 'loan disbursed-cust');
      GeneralCommunicationHandler.sendEmail(LoanList, 'loan disbursed-Int');
     } else {
      Boolean defferalcleared = true;
      for (Discrepancy__c dis: discrepancyList) {
       if (dis.Status__c == 'Pending' || dis.Status__c == 'Re-opened') {
        defferalcleared = false;
        system.debug('inside defferalcleared PRO SentToFinnoneDefferalClear' + defferalcleared);
       }
      }
      if (defferalcleared == true) {
       List < Opportunity > LoanList = new List < Opportunity > ();
       LoanList.add(Loan);
       GeneralCommunicationHandler.sendSMS(LoanList, 'loan disbursedCleared-cust');
       GeneralCommunicationHandler.sendSMS(LoanList, 'loan disbursedCleared-Int');
       GeneralCommunicationHandler.sendEmail(LoanList, 'loan disbursedCleared-Int');
      }
     }
    }
   }
   //code added by leena-Doctors/PRO communication framework-end
   //communication framework enhancement start send email to custome on send to finnone if no defferal
   /*BUG-16959 added Prod condition for DBOL  by Rajesh */
   if (((isPSBLProductLineProduct != null && isPSBLProductLineProduct) && (isPSBLProductLineCommunicationSkipEnabled != null && !isPSBLProductLineCommunicationSkipEnabled)) || (Loan != null && Loan.Product__c == 'SBS CS PSBL')) {
    List < Discrepancy__c > discrepancyList = new List < Discrepancy__c > ();
    discrepancyList = [select Status__c, LoanApplication__c, id from Discrepancy__c where LoanApplication__c =: Loan.id];
    if (discrepancyList.size() <= 0) {
     //send email to customer;
     string templateName = 'PSBL_SendToFinnoneCustomer';
     Id whatId = Loan.id;
     string fromName = 'noreply@bajajfinserv.in';
     string replyTo = 'otpofficeemailverification@6hifw8v4ew6qa26r5whiw37rq2yorch4vylpptp0njgfwqxjc.o-51mo2mam.cs5.apex.sandbox.salesforce.com';
     string[] toAddresses = new String[] {
      Loan.Account.Current_Email_Id__c
     };
     String[] CC;
     string[] bcc;
     String Priority = 'Normal';
     BAFL_EmailServicesLogix.Attachment[] Attachments = new BAFL_EmailServicesLogix.Attachment[] {};
     string Subject = 'Your loan ' + Loan.Loan_Application_Number__c + ' has been disbursed';
     String CostCenter = 'bajaj';
     if (!Test.isRunningTest())
      GeneralUtilities.SendEmailUsingBAFLLogix(templateName, whatId, fromName, replyTo, toAddresses, CC, bcc, Priority, Subject, CostCenter);
     //send email to inetrnal team
     templateName = 'PSBL_SendToFinnoneInteranlTeam';
     whatId = Loan.id;
     fromName = 'noreply@bajajfinserv.in';
     replyTo = 'otpofficeemailverification@6hifw8v4ew6qa26r5whiw37rq2yorch4vylpptp0njgfwqxjc.o-51mo2mam.cs5.apex.sandbox.salesforce.com';
     String[] toAddressesInternal = new String[] {};
     if (Loan.Relationship_Manager__r.Email != null)
      toAddressesInternal.add(Loan.Relationship_Manager__r.Email);
     if (Loan.Sourcing_Channel__r.sourcing_channel_email_id__c != null)
      toAddressesInternal.add(Loan.Sourcing_Channel__r.sourcing_channel_email_id__c);
     if (Loan.ACM__r.Email != null)
      toAddressesInternal.add(Loan.ACM__r.Email);
     Subject = 'Amount disbursed for loan application no' + Loan.Loan_Application_Number__c;
     if (!Test.isRunningTest())
      GeneralUtilities.SendEmailUsingBAFLLogix(templateName, whatId, fromName, replyTo, toAddressesInternal, CC, bcc, Priority, Subject, CostCenter);
    }
   }
   //communication framework enhancement ends

   //Communication for SAL Line starts
   //SBS CS SAL

   //OTPv3 TeleRm Rohit  15229 condition checked from custom label
   if (salariedProducts.size() > 0 && salariedProducts.contains(Loan.Product__c)) {
    List < Discrepancy__c > discrepancyList = new List < Discrepancy__c > ();
    discrepancyList = [select Status__c, LoanApplication__c, id from Discrepancy__c where LoanApplication__c =: Loan.id];
    if (discrepancyList.size() <= 0) {
     //commented for prod issue 11474 S
     /*
        ProductSMS__C prodsms = new ProductSMS__C();
        prodsms = ProductSMS__C.getValues('SAL LA SentToFinnoneNoDefferal');
        String smsmsg = prodsms.SMS_Text__c;
        smsmsg = smsmsg.replace('*LAN*', Loan.Loan_Application_Number__c);
        List < String > message = new List < string > ();
        List < string > mobileno = new List < string > ();
        if (applicantPrimary.Contact_Mobile__c != null) {
            message.add(smsmsg);
            mobileno.add(applicantPrimary.Contact_Mobile__c);
        }
        //Send SMS to customer

        if (message.size() > 0 && mobileno.size() > 0) sendsms.sendBulkSMS(message, mobileno);



        //Send SMS to BFL
        ProductSMS__C prodsmsBFL = new ProductSMS__C();
        prodsmsBFL = ProductSMS__C.getValues('SAL LA SentToFinnoneNoDefferalBFL');
        String smsmsgBFL = prodsmsBFL.SMS_Text__c;
        smsmsgBFL = smsmsgBFL.replace('*CUSTOMER NAME*', applicantPrimary.Contact_Name__r.Name);
        List < String > msgbfl = new List < string > ();
        List < String > mobileNumbers = new List < string > ();
        String creditmobile;

        if (LOan.Sourc_Mobile__c != null) {
            creditmobile = null;
            creditmobile = Loan.Sourc_Mobile__C;
            msgbfl.add(smsmsgBFL);
            mobileNumbers.add(creditmobile);
            System.debug('**********mobileNumbers' + mobileNumbers);
        }

        //to asm
        if (Loan.ASM_Mobile__c != null) {
            creditmobile = null;
            creditmobile = Loan.ASM_Mobile__c;
            msgbfl.add(smsmsgBFL);
            mobileNumbers.add(creditmobile);
        }

        System.debug('***********mobileNumbers' + mobileNumbers);
        if (msgbfl.size() > 0 && mobileNumbers.size() > 0) sendsms.sendBulkSMS(msgbfl, mobileNumbers);
           */
     //commented for prod issue 11474 E
     //communication framework enhancement start send email to custome on send to finnone if no defferal
     //send email to customer;
     string templateName = 'SAL_SendToFinnoneCustomer';
     Id whatId = Loan.id;
     string fromName = 'noreply@bajajfinserv.in';
     string replyTo = 'otpofficeemailverification@6hifw8v4ew6qa26r5whiw37rq2yorch4vylpptp0njgfwqxjc.o-51mo2mam.cs5.apex.sandbox.salesforce.com';
     string[] toAddresses = new String[] {
      Loan.Account.Current_Email_Id__c
     };
     String[] CC;
     string[] bcc;
     String Priority = 'Normal';
     BAFL_EmailServicesLogix.Attachment[] Attachments = new BAFL_EmailServicesLogix.Attachment[] {};
     string Subject = 'Disbursal of your loan application no' + Loan.Loan_Application_Number__c;
     String CostCenter = 'bajaj';
     if (!Test.isRunningTest())
      GeneralUtilities.SendEmailUsingBAFLLogix(templateName, whatId, fromName, replyTo, toAddresses, CC, bcc, Priority, Subject, CostCenter);
     //internal email
     templateName = 'SAL_SendToFinnoneInteranlTeam';
     whatId = Loan.id;
     fromName = 'noreply@bajajfinserv.in';
     replyTo = 'otpofficeemailverification@6hifw8v4ew6qa26r5whiw37rq2yorch4vylpptp0njgfwqxjc.o-51mo2mam.cs5.apex.sandbox.salesforce.com';
     string[] toAddressesInternal = new String[] {
      Loan.Relationship_Manager__r.Email, Loan.ACM__r.Email, Loan.Sourcing_Channel__r.sourcing_channel_email_id__c
     };
     if (Loan.Relationship_Manager__r != null && Loan.Relationship_Manager__r.Email != null) {
      System.debug('Loan.Relationship_Manager__r.Email' + Loan.Relationship_Manager__r.Email);
     }
     Subject = 'Loan documents received from ' + Loan.Account.Name;
     if (!Test.isRunningTest())
      GeneralUtilities.SendEmailUsingBAFLLogix(templateName, whatId, fromName, replyTo, toAddressesInternal, CC, bcc, Priority, Subject, CostCenter);
     //communication framework enhancement ends
    } else {
     Boolean defferalcleared = true;
     for (Discrepancy__c dis: discrepancyList) {
      if (dis.Status__c == 'Pending' || dis.Status__c == 'Re-opened') {
       defferalcleared = false;
      }
     }
     if (defferalcleared == true) {
      //commented for prod issue 11474 S
      /*
      ProductSMS__C prodsms = new ProductSMS__C();
      prodsms = ProductSMS__C.getValues('SAL LA SentToFinnoneDefferalClear');
      String smsmsg = prodsms.SMS_Text__c;
      smsmsg = smsmsg.replace('*LAN*', Loan.Loan_Application_Number__c);
      List < String > message = new List < string > ();
      List < string > mobileno = new List < string > ();
      if (applicantPrimary.Contact_Mobile__c != null) {
      message.add(smsmsg);
      mobileno.add(applicantPrimary.Contact_Mobile__c);
      }
      //Send SMS to customer

      if (message.size() > 0 && mobileno.size() > 0) sendsms.sendBulkSMS(message, mobileno);




      //Send SMS to BFL
      ProductSMS__C prodsmsBFL = new ProductSMS__C();
      prodsmsBFL = ProductSMS__C.getValues('SAL LA SentToFinnoneDefferalClearBFL');
      String smsmsgBFL = prodsmsBFL.SMS_Text__c;
      smsmsgBFL = smsmsgBFL.replace('*CUSTOMER NAME*', applicantPrimary.Contact_Name__r.Name);
      List < String > msgbfl = new List < string > ();
      List < String > mobileNumbers = new List < string > ();
      String creditmobile;

      if (LOan.Sourc_Mobile__c != null) {
      creditmobile = null;
      creditmobile = Loan.Sourc_Mobile__C;
      msgbfl.add(smsmsgBFL);
      mobileNumbers.add(creditmobile);
      System.debug('**********mobileNumbers' + mobileNumbers);
      }

      //to asm
      if (Loan.ASM_Mobile__c != null) {
      creditmobile = null;
      creditmobile = Loan.ASM_Mobile__c;
      msgbfl.add(smsmsgBFL);
      mobileNumbers.add(creditmobile);
      }

      System.debug('***********mobileNumbers' + mobileNumbers);
      if (msgbfl.size() > 0 && mobileNumbers.size() > 0) sendsms.sendBulkSMS(msgbfl, mobileNumbers);
       */
      //commented for prod issue 11474 E
      //communication framework enhancement start send email to internal team on send to finnone if no defferal
      //internal email
      string templateName = 'SAL_SndToFinnDeferalAddedCleared';
      Id whatId = Loan.id;
      string fromName = 'noreply@bajajfinserv.in';
      string replyTo = 'otpofficeemailverification@6hifw8v4ew6qa26r5whiw37rq2yorch4vylpptp0njgfwqxjc.o-51mo2mam.cs5.apex.sandbox.salesforce.com';
      String[] toAddressesInternal = new String[] {};
      if (Loan.Relationship_Manager__r.Email != null)
       toAddressesInternal.add(Loan.Relationship_Manager__r.Email);
      if (Loan.Sourcing_Channel__r.sourcing_channel_email_id__c != null)
       toAddressesInternal.add(Loan.Sourcing_Channel__r.sourcing_channel_email_id__c);
      if (Loan.ACM__r.Email != null)
       toAddressesInternal.add(Loan.ACM__r.Email);
      String[] CC;
      string[] bcc;
      String Priority = 'Normal';
      BAFL_EmailServicesLogix.Attachment[] Attachments = new BAFL_EmailServicesLogix.Attachment[] {};
      string Subject = 'Disbursal for ' + Loan.Account.Name + ',Application no ' + Loan.Loan_Application_Number__c;
      String CostCenter = 'bajaj';
      if (!Test.isRunningTest())
       GeneralUtilities.SendEmailUsingBAFLLogix(templateName, whatId, fromName, replyTo, toAddressesInternal, CC, bcc, Priority, Subject, CostCenter);
      //communication framework enhancement ends
     }
    }

   }
   //communication framework enhancement start send email to internal team if documents are pending and it is mandetory
   boolean sendEmailtoBFL = false;
   for (Checklist__c chcklistObj: objchecklist) {
    if (chcklistObj.CPA_Status__c == 'No' && chcklistObj.Mandatory__c == true) {
     sendEmailtoBFL = true;
     break;
    }
   }
   //SBS CS SAL
   //OTPv3 TeleRm Rohit 15229 condition checked from custom label
   if (salariedProducts.size() > 0 && salariedProducts.contains(Loan.Product__c)) {
    if (sendEmailtoBFL) {
     string templateName = 'SAL_SendToFinnoneInternalTeamPendingDoc';
     Id whatId = Loan.id;
     string fromName = 'noreply@bajajfinserv.in';
     string replyTo = 'otpofficeemailverification@6hifw8v4ew6qa26r5whiw37rq2yorch4vylpptp0njgfwqxjc.o-51mo2mam.cs5.apex.sandbox.salesforce.com';
     String[] toAddressesInternal = new String[] {};
     if (Loan.Relationship_Manager__r.Email != null)
      toAddressesInternal.add(Loan.Relationship_Manager__r.Email);
     if (Loan.Sourcing_Channel__r.sourcing_channel_email_id__c != null)
      toAddressesInternal.add(Loan.Sourcing_Channel__r.sourcing_channel_email_id__c);
     if (Loan.ACM__r.Email != null)
      toAddressesInternal.add(Loan.ACM__r.Email);
     String[] CC;
     string[] bcc;
     String Priority = 'Normal';
     BAFL_EmailServicesLogix.Attachment[] Attachments = new BAFL_EmailServicesLogix.Attachment[] {};
     string Subject = 'Disbursal pending for application no  ' + Loan.Loan_Application_Number__c;
     String CostCenter = 'bajaj';
     if (!Test.isRunningTest())
      GeneralUtilities.SendEmailUsingBAFLLogix(templateName, whatId, fromName, replyTo, toAddressesInternal, CC, bcc, Priority, Subject, CostCenter);
    }
   }
   //communication framework enhancement end 
   system.debug('at line 1866');

   //bug 7061-start digital lounge system workflow
   //system workflow Enhancement Pramod S
   if (digiProds != null && digiProds.size() > 0 && digiProds.contains(Loan.Product__c.ToUpperCase())) {
    if (SOLStampdate != null && SOLStampdate < Loan.createddate) {
     SOLStampFlag = true;
    }
    system.debug('***SOLStampFlag***' + SOLStampFlag);
    if (SOLStampFlag) {
     if (Loan.CUSTOMER__r.Flow__c == 'Digital Lounge' || Loan.CUSTOMER__r.Flow__c == 'DigitalLounge') {
      system.debug('inside digital lounge system workflow');
      string templateName = 'Digital Lounge sent to finnone alert';
      Id whatId = Loan.id;
      string fromName = 'noreply@bajajfinserv.in';
      string replyTo = 'otpofficeemailverification@6hifw8v4ew6qa26r5whiw37rq2yorch4vylpptp0njgfwqxjc.o-51mo2mam.cs5.apex.sandbox.salesforce.com';
      string[] toAddresses = new String[] {};
      if (Loan.CUSTOMER__r.Owner.email != null)
       toAddresses.add(Loan.CUSTOMER__r.Owner.email);
      String[] CC;
      string[] bcc;
      String Priority = 'Normal';
      BAFL_EmailServicesLogix.Attachment[] Attachments = new BAFL_EmailServicesLogix.Attachment[] {};
      string Subject = ' Loan Application is disptached ' + Loan.Name + 'LAN ' + Loan.Loan_Application_Number__c;
      String CostCenter = 'bajaj';
      if (!Test.isRunningTest())
       GeneralUtilities.SendEmailUsingBAFLLogix(templateName, whatId, fromName, replyTo, toAddresses, CC, bcc, Priority, Subject, CostCenter);
     }
    }
   }
   //system workflow Enhancement Pramod E
   //bug 7061-end digital lounge system workflow

   // Start of general communication framework
   if (Mortgageflag) {
    List < Opportunity > LoanList = new List < Opportunity > ();
    List < Discrepancy__c > discrepancyList = new List < Discrepancy__c > ();

    discrepancyList = [select Status__c, LoanApplication__c, id from Discrepancy__c where LoanApplication__c =: Loan.id];

    if (discrepancyList != null && discrepancyList.size() > 0) {
     Integer closedCount = 0;
     Integer pendingCount = 0;
     for (Discrepancy__c disObj: discrepancyList) {
      if (disObj.Status__c.equalsIgnoreCase('Discrepancy Resolved') || disObj.Status__c.equalsIgnoreCase('Closed')) {
       closedCount++;
      } else
      if (disObj.Status__c.equalsIgnoreCase('Pending') || disObj.Status__c.equalsIgnoreCase('Re-opened')) {
       pendingCount++;
      }
     }

     LoanList.add(Loan);
     system.debug('Closed Discrepancies --> ' + closedCount);
     if (closedCount == discrepancyList.size()) {

      system.debug('Sending Discrepancies cleared SMS to Customer and Sales for Home Loan/LAP');
      GeneralCommunicationHandler.sendSMS(LoanList, 'Deferral cleared-Cust'); // For Home Loan/LAP
      GeneralCommunicationHandler.sendSMS(LoanList, 'Deferral cleared-Int'); // For Home Loan/LAP               
      system.debug('Sending Discrepancies cleared Email to Customer and Sales for Home Loan/LAP');
      GeneralCommunicationHandler.sendEmail(LoanList, 'Deferral cleared-Cust'); // For Home Loan/LAP
      GeneralCommunicationHandler.sendEmail(LoanList, 'Deferral cleared-Int'); // For Home Loan/LAP

     }
     if (pendingCount >= 1) {
      system.debug('Sending Discrepancies SMS to Customer and Sales for Home Loan/LAP');
      GeneralCommunicationHandler.sendSMS(LoanList, 'Deferral SMS-Cust'); // For Home Loan/LAP
      GeneralCommunicationHandler.sendSMS(LoanList, 'Deferral SMS-Int'); // For Home Loan/LAP

      system.debug('Sending Discrepancies Email to Customer and Sales for Home Loan/LAP');
      GeneralCommunicationHandler.sendEmail(LoanList, 'Deferral SMS-Cust'); // For Home Loan/LAP
      GeneralCommunicationHandler.sendEmail(LoanList, 'Deferral SMS-Int'); // For Home Loan/LAP
     }

     system.debug('Sending Loan disbursement SMS to Customer and Sales');
     GeneralCommunicationHandler.sendSMS(LoanList, 'Loan disbursed-Cust'); // For SHL, Home Loan and LAP
     GeneralCommunicationHandler.sendSMS(LoanList, 'Loan disbursed-Int'); // For SHL, Home Loan and LAP
     system.debug('Sending Loan disbursement SMS to Customer and Sales');
     GeneralCommunicationHandler.sendSMS(LoanList, 'Disbursal details-Cust'); // Only for SHL
     GeneralCommunicationHandler.sendSMS(LoanList, 'Disbursal details-Int'); // Only for SHL

     system.debug('Sending Loan disbursement Email to Customer and Sales');
     GeneralCommunicationHandler.sendEmail(LoanList, 'Loan disbursed-Cust'); // For SHL, Home Loan and LAP
     GeneralCommunicationHandler.sendEmail(LoanList, 'Loan disbursed-Int'); // For SHL, Home Loan and LAP
     system.debug('Sending Loan disbursement email to Customer and Sales');
     GeneralCommunicationHandler.sendEmail(LoanList, 'Disbursal details-Cust'); // Only for SHL
     GeneralCommunicationHandler.sendEmail(LoanList, 'Disbursal details-Int'); // Only for SHL

    }

    //Bug 15388 As event for SALLAP is senttofinnone only Start
    if (Loan != null && Loan.Product__c != null && Loan.Product__c == 'SALLAP') {
     System.debug('\n\n\tBEFORE ----- Loan.Product__c : ' + Loan.Product__c + ' ------ \n');

     system.debug('\n\n\tSending Loan disbursement SMS to Internal Sales');
     GeneralCommunicationHandler.sendSMS(new List < Opportunity > {
      Loan
     }, 'Loan disbursed-Int'); // For SALLAP
     GeneralCommunicationHandler.sendSMS(new List < Opportunity > {
      Loan
     }, 'Loan disbursed-Cust'); // For SALLAP

     system.debug('\n\n\tSending Loan disbursement Email to Internal Sales');
     GeneralCommunicationHandler.sendEmail(new List < Opportunity > {
      Loan
     }, 'Loan disbursed-Int'); // Only SALLAP
     GeneralCommunicationHandler.sendEmail(new List < Opportunity > {
      Loan
     }, 'Loan disbursed-Cust'); // Only SALLAP

     System.debug('\n\n\tAFTER ----- Loan.Product__c : ' + Loan.Product__c + ' ------ \n');
    }
    //Bug 15388 As event for SALLAP is senttofinnone only End

   }
   //Send sms and email to customer and internal users after loan application is moved to Sent to Finone stage when product = FAS  //YK
   else if (Loan.Product__c != null && Loan.Product__c == 'FAS') {
    System.debug('In FAS Sent to Finone.................................................');
    List < Opportunity > LoanList = new List < Opportunity > ();
    LoanList.add(Loan);
    System.debug('FAS Sending 1...... SMS .......................Sent to Finone-Cust');
    GeneralCommunicationHandler.sendSMS(LoanList, 'Sent to Finone-Cust');
    System.debug('FAS Sending 2...... SMS .......................Sent to Finone-Int');
    GeneralCommunicationHandler.sendSMS(LoanList, 'Sent to Finone-Int');
    System.debug('FAS Sending 3...... Email ......................Sent to Finone-Cust');
    GeneralCommunicationHandler.sendEmail(LoanList, 'Sent to Finone-Cust');
    System.debug('FAS Sending 4...... Email........................Sent to Finone-Int');
    GeneralCommunicationHandler.sendEmail(LoanList, 'Sent to Finone-Int');
    System.debug('FAS Sending-------------------------------------------------------- End');
   }
   // End of general communication framework

   // Start of insurance SMS changes by Niraj

   // Start of SMS N functionality changes - 17923
   /*Map<String, String> productCodeMap = new Map<String, String>();
           Set<String> productCodeSet = new Set<String>();
           for(DPLinsurance__c insObj : Hinsurance) {
             if(insObj.Insurance_Product__c != null) {
               productCodeSet.add(insObj.Insurance_Product__c);  
             }
           }

           for(Parameter_Master__c PMObj : [SELECT Product_Code__c, Product_Short_Code__c FROM Parameter_Master__c WHERE Product_Code__c IN : productCodeSet AND Active__c = true AND Product_Short_Code__c != null]) {
             productCodeMap.put(PMObj.Product_Code__c, PMObj.Product_Short_Code__c);
           }
           system.debug('productCodeMap in disbursement :: ' + productCodeMap);
           // End of SMS N functionality changes - 17923

                 List < Opportunity > LoanList = new List < Opportunity > ();
                 List < DPLinsurance__c > insuranceListWithNominee = new List < DPLinsurance__c > ();
                 List < DPLinsurance__c > insuranceListWithoutNominee = new List < DPLinsurance__c > ();
                 for (DPLinsurance__c tempIns: Hinsurance) {
                    if(productCodeMap.containsKey(tempIns.Insurance_Product__c)) { // Added for SMS N functionality changes - 17923
               if(tempIns.Nominee_Name__c != null && tempIns.Nominee_Name__c != '') {
                 insuranceListWithNominee.add(tempIns);
               } else {
                 insuranceListWithoutNominee.add(tempIns);
               }  
             }
         }
         system.debug('insuranceListWithNominee --> ' + insuranceListWithNominee);
         system.debug('insuranceListWithoutNominee --> ' + insuranceListWithoutNominee);
         system.debug('Sending insurance SMS to Customer and Sales for SHL/Home Loan/LAP');
         LoanList.add(Loan);
         if(isNewProductFlowEnabled == false)
         {
             GeneralCommunicationHandler.sendSMS(LoanList, insuranceListWithNominee, 'InsuranceWNom-Cust'); // For SHL/Home Loan/LAP
             GeneralCommunicationHandler.sendSMS(LoanList, insuranceListWithNominee, 'InsuranceWNom-Int'); // For SHL/Home Loan/LAP  
             GeneralCommunicationHandler.sendSMS(LoanList, insuranceListWithoutNominee, 'InsuranceWONom-Cust'); // For SHL/Home Loan/LAP
             GeneralCommunicationHandler.sendSMS(LoanList, insuranceListWithoutNominee, 'InsuranceWONom-Int'); // For SHL/Home Loan/LAP                               
             // End of insurance SMS changes by Niraj
         }*/
   //Communication for SAL Line ends
   Pagereference p = new pagereference('/006/o');
   // PageReference p = new PageReference('/'+loan.id); 
   p.setRedirect(true);
   return p;
  }
  /*} catch (Exception e) {
ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
}*/
  return null;
 }

 public List < Current_Disbursal_Details__c > getDisbList() {
  return DisbList;
 }
 public void addrowDis() {
  Current_Disbursal_Details__c addDis = new Current_Disbursal_Details__c();
  //Ops Process added by Priya start
  if (opsProductsFlag) {
   addDis.Payable_at__c = Loan.Branch_Name__r.name;
   //addDis.Disbursement_Amount__c = netdisb; //commented for #12163
   addDis.Disbursal_Mode__c = 'RTGS'; //Ops process added by manasi
  }
  //Ops Process added by Priya end
  //IMPS Account Change
  addDis.IMPS_Count__c = 0;
  DisbList.add(addDis);
 }
 public List < SelectOption > getStrApprList() {
  return optionsAppr;
 }

 //Prajyot : pricing enhancemet
 public List < SelectOption > getStrPriApprList() {
  return optionsPriAppr;
 }

 public List < SelectOption > getStrCOApprList() {
  return optionsCOAppr;
 }


 public void SaveDisburse() {
  try {
   List < Current_Disbursal_Details__c > disdet = new List < Current_Disbursal_Details__c > ();
   /*IMPS Account Validation :13907 S*/
   List < Current_Disbursal_Details__c > SelectedACCLst = new List < Current_Disbursal_Details__c > ();
   List < Current_Disbursal_Details__c > ListtobeUpdate = new List < Current_Disbursal_Details__c > ();
   if (IMPSsecShow) {
    for (Current_Disbursal_Details__c dis: DisbList) {
     if (dis.id == null) {
      SelectedACCLst.add(dis);
      //selectedAcc = dis;
      //break;
     }
    }
    for (Current_Disbursal_Details__c dis: DisbList) {
     for (Current_Disbursal_Details__c selectedAcc: SelectedACCLst) {
      if (dis.id != null && selectedAcc != null && selectedAcc.Bank_Account__c == dis.Bank_Account__c && selectedAcc.IFSC_Code__c == dis.IFSC_Code__c) {
       selectedAcc.IMPS_Count__c = dis.IMPS_Count__c;
       selectedAcc.Failure_IMPS_Count__c = dis.Failure_IMPS_Count__c;
       selectedAcc.Successful_IMPS_Count__c = dis.Successful_IMPS_Count__c;
       selectedAcc.IMPS_Result__c = dis.IMPS_Result__c;
       selectedAcc.IMPS_Transaction_No__c = dis.IMPS_Transaction_No__c;
       selectedAcc.IMPSDateTime__c = dis.IMPSDateTime__c;
       ListtobeUpdate.add(selectedAcc);
       //break;
      }
     }
    }
   }
   /*IMPS Account Validation :13907 E*/
   for (integer i = 0; i < DisbList.size(); i++) {
    DisbList[i].Loan_Application__c = LoanId;
    /*IMPS Account Validation :13907 S*/
    if (DisbList[i].id == null && IMPSsecShow) {
     for (Current_Disbursal_Details__c disobj: ListtobeUpdate) {
      if (DisbList[i].Bank_Account__c == disobj.Bank_Account__c && DisbList[i].IFSC_Code__c == disobj.IFSC_Code__c) {
       DisbList[i] = disobj;
      }
     }
     //DisbList[i] = selectedAcc;
    }
    /*IMPS Account Validation :13907 E*/
    if (DisbList[i].Disbursement_Amount__c != null)
     disdet.add(DisbList[i]);
   }
   upsert disdet;

   //cash in 60 min start
   //15430-13793 added if else condition // added Loan.favouring for Bug 16547
   if (DisbList != null && DisbList.size() > 0) {
    //15430-13793 added if else condition
    if (DisbList[0].isTopUp__c == false) {
     if (DisbList[0].IFSC_Code__c != null) {
      Loan.IFSC_Code__c = DisbList[0].IFSC_Code__c;
     }
     if (DisbList[0].Bank_Account__c != null) {
      Loan.A_C_No__c = DisbList[0].Bank_Account__c;
     }
     if (DisbList[0].Disbursal_Mode__c != null) {
      Loan.Mode_of_Disbursal__c = DisbList[0].Disbursal_Mode__c;
     }
     if (DisbList[0].Bank_Name__c != null) {
      Loan.Bank_Name__c = DisbList[0].Bank_Name__c;
     }
     if (DisbList[0].Favouring__c != null) {
      Loan.Account_Holder_Name__c = DisbList[0].Favouring__c;
     }
     if (DisbList[0].Favouring__c != null) {
      Loan.Favouring__c = DisbList[0].Favouring__c;
     }
    }
    //15430-13793 S
    else {
     if (DisbList[1].IFSC_Code__c != null) {
      Loan.IFSC_Code__c = DisbList[1].IFSC_Code__c;
     }
     if (DisbList[1].Bank_Account__c != null) {
      Loan.A_C_No__c = DisbList[1].Bank_Account__c;
     }
     if (DisbList[1].Disbursal_Mode__c != null) {
      Loan.Mode_of_Disbursal__c = DisbList[1].Disbursal_Mode__c;
     }
     if (DisbList[1].Bank_Name__c != null) {
      Loan.Bank_Name__c = DisbList[1].Bank_Name__c;
     }
     if (DisbList[1].Favouring__c != null) {
      Loan.Account_Holder_Name__c = DisbList[1].Favouring__c;
     }
     if (DisbList[1].Favouring__c != null) {
      Loan.Favouring__c = DisbList[1].Favouring__c;
     }
    }
    //15430-13793 E
    if (Loan != null) {
     upsert Loan;
    }
    if (loan.Account.Date_of_Birth__c != null && loan.MICR_Number__c != null && loan.A_C_No__c != null && loan.Account_Holder_Name__c != null && loan.A_C_Type__c != null && loan.IFSC_Code__c != null) {
     blindDatapresentFlag = true;

    } else {
     blindDatapresentFlag = false;
    }
   }
   //cash in 60 min ends

   savedSuccessfull = true;
   message = 'Disbursement Details Saved Successfully !!!';
  } catch (Exception e) {
   ApexPages.addMessages(e);
  }
 }
 public void getRefreshIRRPF() {
  RefreshIRRPF();
 }



 public double PMT(double rate, integer nper, double pv) {
  //integer n;
  // n=Integer.valueof(nper);
  return (pv * rate) / (1 - Math.pow(1 + rate, -nper));
 }

 public List < DocumentWrapper > getdocWrapperList() {
  return docWrapperList;
 }

 // Start of BALIC HTS Integration phase 1 changes 
 public static Object InsuranceBRECallout(Map < String, Object > paramsMap) {
  Object PremAmt;

  Set < String > setUnsecuredProd = new Set < String > ();
  if (Label.HTSCalcUnsecuredProds != null) {
   String[] name = Label.HTSCalcUnsecuredProds.split(',');
   for (String str: name)
    setUnsecuredProd.add(str);
  }

  ApplicantDOB = new Map < String, Object > ();
  if (paramsMap.get('isPOFlow') != null && !Boolean.valueOf(paramsMap.get('isPOFlow'))) {
   if (paramsMap.get('LoanId') != null && paramsMap.get('LoanId') != '') {
    String LoanId = String.valueOf(paramsMap.get('LoanId'));
    List < Applicant__c > applicantList = [select Financial_Health_Check_Guide__c, Contact_Name__r.Customer_Type__c, Applicant_Type__c, ContactName__c, Contact_Name__r.Date_of_Birth__c, /* bug 17556 s*/ PFApproveStatus__c /* bug 17556 e */ /*21288 AP : Defect 22889*/ , Cross_Collateral_LAN__c from Applicant__c where Loan_Application__c =: LoanId];

    if (applicantList != null && applicantList.size() > 0) {
     for (Applicant__c applicant: applicantList) {
      if (applicant.ContactName__c != null) {
       if (applicant.Contact_Name__r.Customer_Type__c != 'Corporate') {
        ApplicantDOB.put(applicant.ContactName__c + ' - ' + applicant.Applicant_Type__c, applicant.Contact_Name__r.Date_of_Birth__c);
       }
      }
     }
    }
   }
  } else {
   system.debug('name --> ' + paramsMap.get('insurerName') + ' dob --> ' + paramsMap.get('dob'));
   if (paramsMap.get('insurerName') != null && paramsMap.get('dob') != null) {
    ApplicantDOB.put(String.valueOf(paramsMap.get('insurerName')), paramsMap.get('dob'));
   }
  }

  if (String.valueOf(paramsMap.get('InsuranceType')) == 'HDFC Life') {
   mapOfHTSCalculatorParams.clear();
   mapOfHTSCalculatorParams.put('sumAssuredAmount', paramsMap.get('sumAssuredAmount') != null && paramsMap.get('sumAssuredAmount') != '' ? Double.valueOf(paramsMap.get('sumAssuredAmount')) : 0);
   mapOfHTSCalculatorParams.put('planType', paramsMap.get('planType') != null ? paramsMap.get('planType') : '');
   mapOfHTSCalculatorParams.put('dob', paramsMap.get('insurerName') != null && ApplicantDOB.get(String.valueOf(paramsMap.get('insurerName'))) != null ? ApplicantDOB.get(String.valueOf(paramsMap.get('insurerName'))) : Date.newInstance(1900, 01, 01));
   mapOfHTSCalculatorParams.put('proposalDate', Date.today());
   mapOfHTSCalculatorParams.put('originalLoanAmount', paramsMap.get('originalLoanAmount') != null && paramsMap.get('originalLoanAmount') != '' ? Double.valueOf(paramsMap.get('originalLoanAmount')) : 0);
   mapOfHTSCalculatorParams.put('sumAssuredType', paramsMap.get('sumAssuredType') != null ? paramsMap.get('sumAssuredType') : '');
   mapOfHTSCalculatorParams.put('policyTenure', paramsMap.get('policyTenure') != null && paramsMap.get('policyTenure') != '' ? Integer.valueOf(paramsMap.get('policyTenure')) : 2);
   mapOfHTSCalculatorParams.put('uniqueId', paramsMap.get('uniqueId') != null ? paramsMap.get('uniqueId') : '0');


   mapOfHTSCalculatorParams.put('dobDependentLife', paramsMap.get('dobDependentLife') != null ? paramsMap.get('dobDependentLife') : Date.newInstance(1900, 01, 01));
   mapOfHTSCalculatorParams.put('dobFirstLife', paramsMap.get('dobFirstLife') != null ? paramsMap.get('dobFirstLife') : Date.newInstance(1900, 01, 01));

   if (paramsMap.get('InsuranceProduct') != null && String.valueOf(paramsMap.get('InsuranceProduct')).toUpperCase() == 'HDFC CREDIT PROTECTION') {
    mapOfHTSCalculatorParams.put('lifeInsType', 'cp');
    PremAmt = String.valueOf(deserializeBreMap(mapOfHTSCalculatorParams, 'response', 'premiumPayable', Label.InsuranceHTSCalculatorLabel));
   } else
   if (paramsMap.get('InsuranceProduct') != null && String.valueOf(paramsMap.get('InsuranceProduct')).toUpperCase() == 'HDFC CREDIT PROTECTION PLUS') {
    if (paramsMap.get('HDFCCPPType') != null && String.valueOf(paramsMap.get('HDFCCPPType')) == 'Single') {
     mapOfHTSCalculatorParams.put('lifeInsType', 'single');
     // Start of bug 14219
     String productType;
     if (paramsMap.get('productType') != null) {
      productType = String.valueOf(paramsMap.get('productType'));
     }
     if (setUnsecuredProd != null && setUnsecuredProd.contains(productType)) {
      mapOfHTSCalculatorParams.put('productType', productType);
      mapOfHTSCalculatorParams.put('loanTenure', paramsMap.get('loanTenure') != null ? Integer.valueOf(paramsMap.get('loanTenure')) : 12);
     }
     // End of bug 14219
    } else
    if (paramsMap.get('HDFCCPPType') != null && String.valueOf(paramsMap.get('HDFCCPPType')) == 'Joint') {
     mapOfHTSCalculatorParams.put('lifeInsType', 'joint');
    }
    PremAmt = String.valueOf(deserializeBreMap(mapOfHTSCalculatorParams, 'response', 'premiumPayable', Label.InsuranceHTSCalculatorLabel));
   }
  }

  if (String.valueOf(paramsMap.get('InsuranceType')) == 'BAGIC') {
   /*if(String.valueOf(paramsMap.get('InsuranceProduct')) == 'FAMILY FLOATER HEALTH GUARD') {
             mapOfHTSCalculatorParams.clear();
             mapOfHTSCalculatorParams.put('Date_of_Birth__c', paramsMap.get('Date_of_Birth__c') != null ? paramsMap.get('Date_of_Birth__c') : Date.newInstance(1900,01,01));
             mapOfHTSCalculatorParams.put('insuranceType', 'FFHG');
             mapOfHTSCalculatorParams.put('id', paramsMap.get('id') != null ? paramsMap.get('id') : '0');
             mapOfHTSCalculatorParams.put('PLAN__c', paramsMap.get('PLAN__c') != null ? paramsMap.get('PLAN__c') : '');
             mapOfHTSCalculatorParams.put('Sum_Insured_Options__c', paramsMap.get('Sum_Insured_Options__c') != null && paramsMap.get('Sum_Insured_Options__c') != '' ? Integer.valueOf(paramsMap.get('Sum_Insured_Options__c')) : 0);

             PremAmt = String.valueOf(deserializeBreMap(mapOfHTSCalculatorParams, 'output', 'finalPremium', Label.BagicCalloutLabel));   
         }*/

   /*if(String.valueOf(paramsMap.get('InsuranceProduct')) == 'INDIVIDUAL HEALTH GUARD') {
             mapOfHTSCalculatorParams.clear();
             IHGInputMap.put('sumInsuredIHG', paramsMap.get('sumInsuredIHG') != null ? paramsMap.get('sumInsuredIHG') : '0');
             IHGInputMap.put('dateOfBirthIHG', paramsMap.get('dateOfBirthIHG') != null ? paramsMap.get('dateOfBirthIHG') : Date.newInstance(1900,01,01));
             mapOfHTSCalculatorParams.put('insuranceType', 'IHG');
             mapOfHTSCalculatorParams.put('input', IHGInputMap);
             mapOfHTSCalculatorParams.put('id', paramsMap.get('id') != null ? paramsMap.get('id') : '0');

             PremAmt = String.valueOf(deserializeBreMap(mapOfHTSCalculatorParams, 'output', 'finalPremium', Label.BagicCalloutLabel));
         }*/

   if (String.valueOf(paramsMap.get('InsuranceProduct')) == 'BAGIC EXTRA CARE') {
    mapOfHTSCalculatorParams.clear();
    mapOfHTSCalculatorParams.put('Date_of_Birth__c', paramsMap.get('Date_of_Birth__c') != null ? paramsMap.get('Date_of_Birth__c') : Date.newInstance(1900, 01, 01));
    mapOfHTSCalculatorParams.put('insuranceType', 'EXTRA CARE');
    mapOfHTSCalculatorParams.put('id', paramsMap.get('id') != null ? paramsMap.get('id') : '0');
    mapOfHTSCalculatorParams.put('PLAN__c', paramsMap.get('PLAN__c') != null ? (String.valueOf(paramsMap.get('PLAN__c')).substringBefore('-').toUpperCase().trim()) : '');
    mapOfHTSCalculatorParams.put('Plan_Opted__c', paramsMap.get('Plan_Opted__c') != null ? paramsMap.get('Plan_Opted__c') : '');

    PremAmt = String.valueOf(deserializeBreMap(mapOfHTSCalculatorParams, 'output', 'finalPremium', Label.BagicCalloutLabel));
   }
  }
  return PremAmt;
 }

 public static Integer deserializeBreMap(Map < String, Object > mapOfHTSCalculatorParams, String JSONKey, String premiumKey, String endpoint) {
  String JSONString = JSON.serialize(mapOfHTSCalculatorParams);
  system.debug('JSONString --------> ' + JSONString);
  Integer PremiumAmount = 0;
  if (!Test.isRunningTest()) {
   result = BRECallout.insuranceAPICallout(endpoint, JSONString);
   system.debug('--------result--' + result);
   Map < String,
    Object > DeserializedResult = (Map < String, Object > ) JSON.deserializeUntyped(result);
   system.debug('DeserializedResult' + DeserializedResult);
   Map < String,
    Object > lstInsurance = (Map < String, Object > ) DeserializedResult.get(JSONKey);
   system.debug('lstInsurance' + lstInsurance);
   system.debug(lstInsurance.get(premiumKey));
   PremiumAmount = (Integer) lstInsurance.get(premiumKey);
   system.debug('PremiumAmount' + PremiumAmount);
  } else {
   HTTPResponse res = new HTTPResponse();
   res.setBody('{"basicSumAssured":20000,"revisedSumAssured":null,"basicPremium":0,"serviceTaxandApplicableCess":0.00,"premiumPayable":4314,"rate":null,"age":41.06182795698925},"Action":true}');
   system.debug(res);
  }
  return PremiumAmount;
 }
 // End of BALIC HTS Integration phase 1 changes 

 // Added by Anjali -- HTS calculator Build - end
 // production issue 10258 by akshata S
 public Integer parseMonths(String emiMonths) {
  if (emiMonths.equals('January')) {
   return 1;
  }
  if (emiMonths.equals('February')) {
   return 2;
  }
  if (emiMonths.equals('March')) {
   return 3;
  }
  if (emiMonths.equals('April')) {
   return 4;
  }
  if (emiMonths.equals('May')) {
   return 5;
  }
  if (emiMonths.equals('June')) {
   return 6;
  }
  if (emiMonths.equals('July')) {
   return 7;
  }
  if (emiMonths.equals('August')) {
   return 8;
  }
  if (emiMonths.equals('September')) {
   return 9;
  }
  if (emiMonths.equals('October')) {
   return 10;
  }
  if (emiMonths.equals('November')) {
   return 11;
  } else {
   return 12;
  }
 }

 // production issue 10258 by akshata E

 public Profees PFFields {
  get;
  set;
 }
 public List < Profees > PF {
  get;
  set;
 }
 public IRRvalues IRRFields {
  get;
  set;
 }
 public List < IRRvalues > IRR {
  get;
  set;
 }

 /*public Map<String,Decimal> calculateAggregate(List<Opportunity> oppIRRList){

    Map<String,Decimal> avgMap=new Map<String,Decimal>();
    Decimal sumLoanAmount=0;      
    Decimal loanROIMultiplication = 0;
    Decimal loanPFMultiplication = 0;
    for(Opportunity opp:oppIRRList){
    if(opp.Approved_Loan_Amount__c!=null && opp.Approved_Rate__c!=null)
    loanROIMultiplication=loanROIMultiplication+(opp.Approved_Loan_Amount__c * opp.Approved_Rate__c);

    if(opp.Approved_Loan_Amount__c!=null && opp.Processing_Fees__c!=null)     
    loanPFMultiplication=loanPFMultiplication+(opp.Approved_Loan_Amount__c * opp.Processing_Fees__c);

    if(opp.Approved_Loan_Amount__c!=null)
    sumLoanAmount+= opp.Approved_Loan_Amount__c;
    }
    system.debug('sumLoanAmount='+sumLoanAmount+'loanROIMultiplication='+loanROIMultiplication+'loanPFMultiplication='+loanPFMultiplication);
/* if(currentLoanAmt!=null)
    sumLoanAmount=sumLoanAmount+currentLoanAmt;

if(currentLoanAmt!=null && currentRate!=null)
    loanROIMultiplication=loanROIMultiplication+(currentLoanAmt * currentRate);

if(currentLoanAmt!=null && currentPF!=null)
    loanPFMultiplication=loanPFMultiplication+(currentLoanAmt * currentPF);   

system.debug('final sumLoanAmount='+sumLoanAmount+' final loanROIMultiplication='+loanROIMultiplication+' final loanPFMultiplication='+loanPFMultiplication);

    Decimal FinalIRR=0; 
    Decimal finalPF=0;
    if(loanROIMultiplication!=null && sumLoanAmount!=null && sumLoanAmount!=0)
    FinalIRR = loanROIMultiplication/sumLoanAmount;

    if(loanPFMultiplication!=null && sumLoanAmount!=null && sumLoanAmount!=0)
    FinalPF = loanPFMultiplication/sumLoanAmount;
    avgMap.put('FinalIRR',FinalIRR);
    avgMap.put('FinalPF',FinalPF);



    System.debug('avgMap.size()='+avgMap.size());   
return avgMap;          
}*/
 public Map < String, Decimal > calculateAggregateValue(List < Opportunity > oppIRRList, Decimal currentLoanAmt, Decimal currentRate, Decimal currentPF) {

  Map < String, Decimal > avgMap = new Map < String, Decimal > ();
  Decimal sumLoanAmount = 0;
  Decimal loanROIMultiplication = 0;
  Decimal loanPFMultiplication = 0;
  for (Opportunity opp: oppIRRList) {
   if (opp.Approved_Loan_Amount__c != null && opp.Approved_Rate__c != null)
    loanROIMultiplication = loanROIMultiplication + (opp.Approved_Loan_Amount__c * opp.Approved_Rate__c);

   if (opp.Approved_Loan_Amount__c != null && opp.Processing_Fees__c != null)
    loanPFMultiplication = loanPFMultiplication + (opp.Approved_Loan_Amount__c * opp.Processing_Fees__c);

   if (opp.Approved_Loan_Amount__c != null)
    sumLoanAmount += opp.Approved_Loan_Amount__c;
  }
  system.debug('sumLoanAmount=' + sumLoanAmount + 'loanROIMultiplication=' + loanROIMultiplication + 'loanPFMultiplication=' + loanPFMultiplication);
  if (currentLoanAmt != null)
   sumLoanAmount = sumLoanAmount + currentLoanAmt;

  if (currentLoanAmt != null && currentRate != null)
   loanROIMultiplication = loanROIMultiplication + (currentLoanAmt * currentRate);

  if (currentLoanAmt != null && currentPF != null)
   loanPFMultiplication = loanPFMultiplication + (currentLoanAmt * currentPF);

  system.debug('final sumLoanAmount=' + sumLoanAmount + ' final loanROIMultiplication=' + loanROIMultiplication + ' final loanPFMultiplication=' + loanPFMultiplication);

  Decimal FinalIRR = 0;
  Decimal finalPF = 0;
  if (loanROIMultiplication != null && sumLoanAmount != null && sumLoanAmount != 0)
   FinalIRR = (loanROIMultiplication / sumLoanAmount).setscale(2);

  if (loanPFMultiplication != null && sumLoanAmount != null && sumLoanAmount != 0)
   FinalPF = (loanPFMultiplication / sumLoanAmount).setscale(2);
  avgMap.put('FinalIRR', FinalIRR);
  avgMap.put('FinalPF', FinalPF);

  /*avgMap.put('AvgApprovedRate',avgRate);  
avgMap.put('SumLoanAmount',sumLoanAmount);
avgMap.put('AvgLoanAmount',avgLoanAmount);
avgMap.put('AvgProcessFee',avgProcessFee);*/

  System.debug('avgMap.size()=' + avgMap.size());
  return avgMap;
 }

 public void refreshIRRPF() {
  IRR = new List < IRRvalues > ();
  PF = new List < Profees > ();
  IRRFields = new IRRvalues();
  PFFields = new Profees();
  try {
   // Date currentMonthStart = date.parse('04/04/2015');  //Date.newInstance(2015,4,4);
   // Date currentMonthEnd =  date.parse('05/03/2015');  //Date.newInstance(2015,5,3);
   // Date previousMonthStart = date.parse('03/03/2015'); //Date.newInstance(2015,3,3);
   // Date previousMonthEnd = date.parse('04/03/2015');  //Date.newInstance(2015,4,3);
   Mid_office_BRE_flow__c currentMonthStart = Mid_office_BRE_flow__c.getValues('currentMonthStart');
   Mid_office_BRE_flow__c currentMonthEnd = Mid_office_BRE_flow__c.getValues('currentMonthEnd');
   Mid_office_BRE_flow__c previousMonthStart = Mid_office_BRE_flow__c.getValues('previousMonthStart');
   Mid_office_BRE_flow__c previousMonthEnd = Mid_office_BRE_flow__c.getValues('previousMonthEnd');
   IRRFields.IRRType = 'Current Month';
   decimal ApprovedLoan, ApprovedRate, ApprovedPF;
   ApprovedLoan = ApprovedRate = ApprovedPF = 0;
   if (Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName.contains('Re-Appraise')) {
    if (Loan.Approved_Loan_Amount__c != null)
     ApprovedLoan = Double.valueOf(Loan.Approved_Loan_Amount__c);

    if (Loan.Approved_Rate__c != null)
     ApprovedRate = Double.valueOf(Loan.Approved_Rate__c);


    if (Loan.Processing_Fees__c != null)
     ApprovedPF = Double.valueOf(Loan.Processing_Fees__c);
   }
   system.debug('&ApprovedLoan ' + ApprovedLoan + '**ApprovedRate :' + ApprovedRate);
   if (currentMonthStart != null && currentMonthStart.IIR_PF_Avg_Date__c != null && currentMonthEnd != null && currentMonthEnd.IIR_PF_Avg_Date__c != null) {
    if (Loan.Branch_Name__c != null) {
     List < Opportunity > avgResultsBranch = new List < Opportunity > ();
     avgResultsBranch = [select id, Loan_Amount__c, Due_Day__c, Scheme_Master__r.Scheme_Code__c, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.Branch_Name__c =: Loan.Branch_Name__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: currentMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: currentMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgResultsBranch loans ::' + avgResultsBranch);

     Map < String, Decimal > avgMap = calculateAggregateValue(avgResultsBranch, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalIRR') != null)
       IRRFields.avgBranchIRR = avgMap.get('FinalIRR');
     }

    }
    if (Loan.Relationship_Manager__c != null) {

     List < Opportunity > avgResultsASM = new List < Opportunity > ();
     avgResultsASM = [select id, Loan_Amount__c, Due_Day__c, Scheme_Master__r.Scheme_Code__c, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.Relationship_Manager__c =: Loan.Relationship_Manager__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: currentMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: currentMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgResultsASM loans ::' + avgResultsASM);

     Map < String, Decimal > avgMap = calculateAggregateValue(avgResultsASM, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalIRR') != null)
       IRRFields.avgASMIRR = avgMap.get('FinalIRR');
     }
    }
    if (Loan.City_SM__c != null) {

     List < Opportunity > avgResultsCitySM = new List < Opportunity > ();
     avgResultsCitySM = [select id, Loan_Amount__c, Due_Day__c, Scheme_Master__r.Scheme_Code__c, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.City_SM__c =: Loan.City_SM__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: currentMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: currentMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgResultsCitySM loans ::' + avgResultsCitySM);

     Map < String, Decimal > avgMap = calculateAggregateValue(avgResultsCitySM, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalIRR') != null)
       IRRFields.avgCitySMIRR = avgMap.get('FinalIRR');
     }


    }
    if (Loan.Regional_SM__c != null) {

     List < Opportunity > avgResultsRSM = new List < Opportunity > ();
     avgResultsRSM = [select id, Loan_Amount__c, Due_Day__c, Scheme_Master__r.Scheme_Code__c, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.Regional_SM__c =: Loan.Regional_SM__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: currentMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: currentMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgResultsRSM loans ::' + avgResultsRSM);

     Map < String, Decimal > avgMap = calculateAggregateValue(avgResultsRSM, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalIRR') != null)
       IRRFields.avgRSMIRR = avgMap.get('FinalIRR');
     }

    }
    if (Loan.Zonal_SM__c != null) {

     List < Opportunity > avgResultsZSM = new List < Opportunity > ();
     avgResultsZSM = [select id, Loan_Amount__c, Due_Day__c, Scheme_Master__r.Scheme_Code__c, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.Zonal_SM__c =: Loan.Zonal_SM__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: currentMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: currentMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgResultsZSM loans ::' + avgResultsZSM);

     Map < String, Decimal > avgMap = calculateAggregateValue(avgResultsZSM, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalIRR') != null)
       IRRFields.avgZSMIRR = avgMap.get('FinalIRR');
     }
    }

    if (Loan.National_SM__c != null) {
     List < Opportunity > avgResultsNSM = new List < Opportunity > ();
     avgResultsNSM = [select id, Loan_Amount__c, Due_Day__c, Scheme_Master__r.Scheme_Code__c, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.National_SM__c =: Loan.National_SM__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: currentMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: currentMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgResultsNSM loans ::' + avgResultsNSM);
     Map < String, Decimal > avgMap = calculateAggregateValue(avgResultsNSM, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalIRR') != null)
       IRRFields.avgNSMIRR = avgMap.get('FinalIRR');
     }
    }
   }
   IRR.add(IRRFields);
   IRRFields = new IRRvalues();
   IRRFields.IRRType = 'Previous Month';
   if (previousMonthStart != null && previousMonthStart.IIR_PF_Avg_Date__c != null && previousMonthEnd != null && previousMonthEnd.IIR_PF_Avg_Date__c != null) {
    if (Loan.Branch_Name__c != null) {
     /* List<Opportunity> avgResultsBranchPrev = [SELECT Branch_Name__c,Approved_Rate__c,Approved_Loan_Amount__c,Processing_Fees__c,Account.Mobile__c FROM Opportunity where Branch_Name__c=:Loan.Branch_Name__c and Product__c=:Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c and Sent_To_Finnone__c=true];

//system.debug(avgResultsBranchPrev);

Map<String,Decimal> avgMap=calculateAggregate(avgResultsBranchPrev);        
system.debug('avgMap='+avgMap);

if(avgMap.size()==4){
    if((Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName.contains('Re-Appraise')) && avgMap.get('AvgApprovedRate')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){

    IRRFields.avgBranchIRR=((((avgMap.get('AvgApprovedRate')+ ApprovedRate) / 2) * ((avgMap.get('AvgLoanAmount') + ApprovedLoan) / 2))/(avgMap.get('SumLoanAmount') + ApprovedLoan)).setscale(2);

    }
    else{
    if(avgMap.get('AvgApprovedRate')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){
        IRRFields.avgBranchIRR=((avgMap.get('AvgApprovedRate') * avgMap.get('AvgLoanAmount'))/avgMap.get('SumLoanAmount')).setscale(2);
    }
    }
}*/
     List < Opportunity > avgResultsBranchPrev = new List < Opportunity > ();
     avgResultsBranchPrev = [select id, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.Branch_Name__c =: Loan.Branch_Name__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgResultsBranchPrev loans ::' + avgResultsBranchPrev);
     Map < String, Decimal > avgMap = calculateAggregateValue(avgResultsBranchPrev, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalIRR') != null)
       IRRFields.avgBranchIRR = avgMap.get('FinalIRR');
     }


    }
    if (Loan.Relationship_Manager__c != null) {
     /* List<Opportunity> avgResultsASMPrev = [SELECT Area_SM__c,Approved_Rate__c,Approved_Loan_Amount__c,Processing_Fees__c,Account.Mobile__c FROM Opportunity where Area_SM__c=:Loan.Area_SM__c and Product__c=:Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c  and Sent_To_Finnone__c=true];

    system.debug(avgResultsASMPrev);

    Map<String,Decimal> avgMap=calculateAggregate(avgResultsASMPrev);        
    system.debug('avgMap='+avgMap);

    if(avgMap.size()==4){
        if((Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName.contains('Re-Appraise')) && avgMap.get('AvgApprovedRate')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){

        IRRFields.avgASMIRR=((((avgMap.get('AvgApprovedRate')+ ApprovedRate) / 2) * ((avgMap.get('AvgLoanAmount') + ApprovedLoan) / 2))/(avgMap.get('SumLoanAmount') + ApprovedLoan)).setscale(2);

        }
        else{
        if(avgMap.get('AvgApprovedRate')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){
            IRRFields.avgASMIRR=((avgMap.get('AvgApprovedRate') * avgMap.get('AvgLoanAmount'))/avgMap.get('SumLoanAmount')).setscale(2);
        }
        }
    }*/


     List < Opportunity > avgResultsASMPrev = new List < Opportunity > ();
     avgResultsASMPrev = [select id, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.Relationship_Manager__c =: Loan.Relationship_Manager__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgResultsASMPrev loans ::' + avgResultsASMPrev);
     Map < String, Decimal > avgMap = calculateAggregateValue(avgResultsASMPrev, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalIRR') != null)
       IRRFields.avgASMIRR = avgMap.get('FinalIRR');
     }

    }
    if (Loan.City_SM__c != null) {
     /* List<Opportunity> avgResultsCitySMPrev = [SELECT City_SM__c,Approved_Rate__c,Approved_Loan_Amount__c,Processing_Fees__c,Account.Mobile__c FROM Opportunity where City_SM__c=:Loan.City_SM__c and Product__c=:Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c  and Sent_To_Finnone__c=true];

system.debug(avgResultsCitySMPrev);

Map<String,Decimal> avgMap=calculateAggregate(avgResultsCitySMPrev);        
    system.debug('avgMap='+avgMap);

    if(avgMap.size()==4){
    if((Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName.contains('Re-Appraise')) && avgMap.get('AvgApprovedRate')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){

        IRRFields.avgCitySMIRR=((((avgMap.get('AvgApprovedRate')+ ApprovedRate) / 2) * ((avgMap.get('AvgLoanAmount') + ApprovedLoan)/ 2))/(avgMap.get('SumLoanAmount') + ApprovedLoan)).setscale(2);

    }
    else{
        if(avgMap.get('AvgApprovedRate')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){
        IRRFields.avgCitySMIRR=((avgMap.get('AvgApprovedRate') * avgMap.get('AvgLoanAmount'))/avgMap.get('SumLoanAmount')).setscale(2);
    }
    }
    }*/

     List < Opportunity > avgResultsCitySMPrev = new List < Opportunity > ();
     avgResultsCitySMPrev = [select id, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.City_SM__c =: Loan.City_SM__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgResultsCitySMPrev loans ::' + avgResultsCitySMPrev);
     Map < String, Decimal > avgMap = calculateAggregateValue(avgResultsCitySMPrev, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalIRR') != null)
       IRRFields.avgCitySMIRR = avgMap.get('FinalIRR');
     }

    }
    System.debug('**********************************>' + Loan.Regional_SM__c);
    if (Loan.Regional_SM__c != null) {
     /*List<Opportunity> avgResultsRSMPrev = [SELECT Regional_SM__c,Approved_Rate__c,Approved_Loan_Amount__c,Processing_Fees__c,Account.Mobile__c FROM Opportunity where Regional_SM__c=:Loan.Regional_SM__c and Product__c=:Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c  and Sent_To_Finnone__c=true];

    //system.debug(avgResultsRSMPrev);

    Map<String,Decimal> avgMap=calculateAggregate(avgResultsRSMPrev);        
    system.debug('avgMap='+avgMap);

    if(avgMap.size()==4){
        if((Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName.contains('Re-Appraise')) && avgMap.get('AvgApprovedRate')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){

        IRRFields.avgRSMIRR=((((avgMap.get('AvgApprovedRate')+ ApprovedRate) / 2) * ((avgMap.get('AvgLoanAmount') + ApprovedLoan) / 2))/(avgMap.get('SumLoanAmount') + ApprovedLoan)).setscale(2);

        }
        else{
        if(avgMap.get('AvgApprovedRate')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){
            IRRFields.avgRSMIRR=((avgMap.get('AvgApprovedRate') * avgMap.get('AvgLoanAmount'))/avgMap.get('SumLoanAmount')).setscale(2);
        }
        }
    }*/

     List < Opportunity > avgResultsRSMPrev = new List < Opportunity > ();
     avgResultsRSMPrev = [select id, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.Regional_SM__c =: Loan.Regional_SM__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgResultsRSMPrev loans ::' + avgResultsRSMPrev);
     Map < String, Decimal > avgMap = calculateAggregateValue(avgResultsRSMPrev, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalIRR') != null)
       IRRFields.avgRSMIRR = avgMap.get('FinalIRR');
     }

    }
    if (Loan.Zonal_SM__c != null) {
     /*List<Opportunity> avgResultsZSMPrev = [SELECT Zonal_SM__c,Approved_Rate__c,Approved_Loan_Amount__c,Processing_Fees__c,Account.Mobile__c FROM Opportunity where Zonal_SM__c=:Loan.Zonal_SM__c and Product__c=:Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c  and Sent_To_Finnone__c=true];

    system.debug(avgResultsZSMPrev);

    Map<String,Decimal> avgMap=calculateAggregate(avgResultsZSMPrev);        
    system.debug('avgMap='+avgMap);

    if(avgMap.size()==4){
        if((Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName.contains('Re-Appraise')) && avgMap.get('AvgApprovedRate')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){

        IRRFields.avgZSMIRR=((((avgMap.get('AvgApprovedRate')+ ApprovedRate) / 2) * ((avgMap.get('AvgLoanAmount') + ApprovedLoan) / 2))/(avgMap.get('SumLoanAmount') + ApprovedLoan)).setscale(2);

        }
        else{
        if(avgMap.get('AvgApprovedRate')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){
            IRRFields.avgZSMIRR=((avgMap.get('AvgApprovedRate') * avgMap.get('AvgLoanAmount'))/avgMap.get('SumLoanAmount')).setscale(2);
        }
        }
    }     */

     List < Opportunity > avgResultsZSMPrev = new List < Opportunity > ();
     avgResultsZSMPrev = [select id, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.Zonal_SM__c =: Loan.Zonal_SM__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgResultsZSMPrev loans ::' + avgResultsZSMPrev);
     Map < String, Decimal > avgMap = calculateAggregateValue(avgResultsZSMPrev, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalIRR') != null)
       IRRFields.avgZSMIRR = avgMap.get('FinalIRR');
     }
    }

    if (Loan.National_SM__c != null) {

     List < Opportunity > avgResultsNSMPrev = new List < Opportunity > ();
     avgResultsNSMPrev = [select id, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.National_SM__c =: Loan.National_SM__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgResultsNSMPrev loans ::' + avgResultsNSMPrev);
     Map < String, Decimal > avgMap = calculateAggregateValue(avgResultsNSMPrev, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalIRR') != null)
       IRRFields.avgNSMIRR = avgMap.get('FinalIRR');
     }

     /*AggregateResult[] avgResultsNSMPrev = [SELECT National_SM__c, AVG(Approved_Rate__c),AVG(Approved_Loan_Amount__c),SUM(Approved_Loan_Amount__c) FROM Opportunity where National_SM__c=:Loan.National_SM__c and Product__c=:Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c  and Sent_To_Finnone__c=true GROUP BY National_SM__c];
system.debug(avgResultsNSMPrev);
for (AggregateResult ar : avgResultsNSMPrev){
    if((Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName.contains('Re-Appraise')) && ar.get('expr0')!=null && ar.get('expr1')!=null && ar.get('expr2')!=null && ar.get('expr2')!=0){

    IRRFields.avgNSMIRR=(((((decimal)ar.get('expr0')+ ApprovedRate) / 2) * (((decimal)ar.get('expr1') + ApprovedLoan) / 2))/((decimal)ar.get('expr2') + ApprovedLoan)).setscale(2);

    }else{ 
    //if(ar.get('expr0')!=null)
    //IRRFields.avgNSMIRR=((Decimal)ar.get('expr0')).setscale(2);
    if(ar.get('expr0')!=null && ar.get('expr1')!=null && ar.get('expr2')!=null && ar.get('expr2')!=0){
        IRRFields.avgNSMIRR=((((decimal)ar.get('expr0')) * ((decimal)ar.get('expr1')))/((decimal)ar.get('expr2'))).setscale(2);
    }
    }
}*/
    }
   }
   IRR.add(IRRFields);

   system.debug('------------------------------>' + IRR);
   PFFields.PFType = 'Current Month';
   system.debug('ApprovedPF..::' + ApprovedPF);
   if (currentMonthStart != null && currentMonthStart.IIR_PF_Avg_Date__c != null && currentMonthEnd != null && currentMonthEnd.IIR_PF_Avg_Date__c != null) {
    if (Loan.Branch_Name__c != null) {
     /* List<Opportunity> avgPFResultsBranch = [SELECT Branch_Name__c,Processing_Fees__c,Approved_Loan_Amount__c,Approved_Rate__c,Account.Mobile__c FROM Opportunity where Branch_Name__c=:Loan.Branch_Name__c and Product__c=:Loan.Product__c and CreatedDate >=: currentMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: currentMonthEnd.IIR_PF_Avg_Date__c and Sent_To_Finnone__c=true];

    system.debug(avgPFResultsBranch);

    Map<String,Decimal> avgMap=calculateAggregate(avgPFResultsBranch);        
    system.debug('avgMap='+avgMap);

    if(avgMap.size()==4){
        if((Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName.contains('Re-Appraise')) && avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){                
        PFFields.BranchPF=((((avgMap.get('AvgProcessFee')+ ApprovedPF) / 2) * ((avgMap.get('AvgLoanAmount') + ApprovedLoan) / 2))/(avgMap.get('SumLoanAmount') + ApprovedLoan)).setscale(2);
        System.debug('PFFields.BranchPF='+PFFields.BranchPF);
        }
        else{
        if(avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){
        PFFields.BranchPF=((avgMap.get('AvgProcessFee') * avgMap.get('AvgLoanAmount'))/avgMap.get('SumLoanAmount')).setscale(2);
        System.debug('PFFields.BranchPF='+PFFields.BranchPF);
        }
        }
    }*/
     List < Opportunity > avgPFResultsBranch = new List < Opportunity > ();
     avgPFResultsBranch = [select id, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.Branch_Name__c =: Loan.Branch_Name__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: currentMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: currentMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgPFResultsBranch loans ::' + avgPFResultsBranch);
     Map < String, Decimal > avgMap = calculateAggregateValue(avgPFResultsBranch, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalPF') != null)
       PFFields.BranchPF = avgMap.get('FinalPF');
     }

    }
    if (Loan.Relationship_Manager__c != null) {
     /*List<Opportunity> avgPFResultsASM = [SELECT Area_SM__c,Processing_Fees__c,Approved_Loan_Amount__c,Approved_Rate__c,Account.Mobile__c FROM Opportunity where Area_SM__c=:Loan.Area_SM__c and Product__c=:Loan.Product__c and CreatedDate >=: currentMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: currentMonthEnd.IIR_PF_Avg_Date__c and Sent_To_Finnone__c=true];

    system.debug(avgPFResultsASM);

    Map<String,Decimal> avgMap=calculateAggregate(avgPFResultsASM);        
    system.debug('avgMap='+avgMap);

    if(avgMap.size()==4){
        if((Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName.contains('Re-Appraise')) && avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){

        PFFields.ASMPF=((((avgMap.get('AvgProcessFee')+ ApprovedPF) / 2) * ((avgMap.get('AvgLoanAmount') + ApprovedLoan)/ 2))/(avgMap.get('SumLoanAmount') + ApprovedLoan)).setscale(2);

        }
        else{
        if(avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){
            PFFields.ASMPF=((avgMap.get('AvgProcessFee') * avgMap.get('AvgLoanAmount'))/avgMap.get('SumLoanAmount')).setscale(2);
        }
        }
    }*/
     List < Opportunity > avgPFResultsASM = new List < Opportunity > ();
     avgPFResultsASM = [select id, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.Relationship_Manager__c =: Loan.Relationship_Manager__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: currentMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: currentMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgPFResultsASM loans ::' + avgPFResultsASM);
     Map < String, Decimal > avgMap = calculateAggregateValue(avgPFResultsASM, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalPF') != null)
       PFFields.ASMPF = avgMap.get('FinalPF');
     }


    }
    if (Loan.City_SM__c != null) {
     /*List<Opportunity> avgPFResultsCitySM = [SELECT City_SM__c,Processing_Fees__c,Approved_Loan_Amount__c,Approved_Rate__c,Account.Mobile__c FROM Opportunity where City_SM__c=:Loan.City_SM__c and Product__c=:Loan.Product__c and CreatedDate >=: currentMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: currentMonthEnd.IIR_PF_Avg_Date__c and Sent_To_Finnone__c=true];

    system.debug(avgPFResultsCitySM);

    Map<String,Decimal> avgMap=calculateAggregate(avgPFResultsCitySM);        
    system.debug('avgMap='+avgMap);

    if(avgMap.size()==4){
        if((Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName.contains('Re-Appraise')) && avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){

        PFFields.CitySMPF=((((avgMap.get('AvgProcessFee')+ ApprovedPF) / 2) * ((avgMap.get('AvgLoanAmount') + ApprovedLoan) / 2))/(avgMap.get('SumLoanAmount') + ApprovedLoan)).setscale(2);

        }
        else{
        if(avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){
            PFFields.CitySMPF=((avgMap.get('AvgProcessFee') * avgMap.get('AvgLoanAmount'))/avgMap.get('SumLoanAmount')).setscale(2);
        }
        }
    }*/
     List < Opportunity > avgPFResultsCitySM = new List < Opportunity > ();
     avgPFResultsCitySM = [select id, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.City_SM__c =: Loan.City_SM__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: currentMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: currentMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgPFResultsCitySM loans ::' + avgPFResultsCitySM);
     Map < String, Decimal > avgMap = calculateAggregateValue(avgPFResultsCitySM, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalPF') != null)
       PFFields.CitySMPF = avgMap.get('FinalPF');
     }

    }
    if (Loan.Regional_SM__c != null) {
     /*List<Opportunity> avgPFResultsRSM = [SELECT Regional_SM__c,Processing_Fees__c,Approved_Loan_Amount__c,Approved_Rate__c,Account.Mobile__c FROM Opportunity where Regional_SM__c=:Loan.Regional_SM__c and Product__c=:Loan.Product__c and CreatedDate >=: currentMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: currentMonthEnd.IIR_PF_Avg_Date__c and Sent_To_Finnone__c=true];

    system.debug(avgPFResultsRSM);

    Map<String,Decimal> avgMap=calculateAggregate(avgPFResultsRSM);        
    system.debug('avgMap='+avgMap);

    if(avgMap.size()==4){
        if((Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName.contains('Re-Appraise')) && avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){

        PFFields.RSMPF=((((avgMap.get('AvgProcessFee')+ ApprovedPF) / 2) * ((avgMap.get('AvgLoanAmount') + ApprovedLoan) / 2))/(avgMap.get('SumLoanAmount') + ApprovedLoan)).setscale(2);

        }
        else{
        if(avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){
            PFFields.RSMPF=((avgMap.get('AvgProcessFee') * avgMap.get('AvgLoanAmount'))/avgMap.get('SumLoanAmount')).setscale(2);
        }
        }
    }*/

     List < Opportunity > avgPFResultsRSM = new List < Opportunity > ();
     avgPFResultsRSM = [select id, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.Regional_SM__c =: Loan.Regional_SM__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: currentMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: currentMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgPFResultsRSM loans ::' + avgPFResultsRSM);
     Map < String, Decimal > avgMap = calculateAggregateValue(avgPFResultsRSM, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalPF') != null)
       PFFields.RSMPF = avgMap.get('FinalPF');
     }

    }
    if (Loan.Zonal_SM__c != null) {
     /* List<Opportunity> avgPFResultsZSM = [SELECT Zonal_SM__c,Processing_Fees__c,Approved_Loan_Amount__c,Approved_Rate__c,Account.Mobile__c FROM Opportunity where Zonal_SM__c=:Loan.Zonal_SM__c and Product__c=:Loan.Product__c and CreatedDate >=: currentMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: currentMonthEnd.IIR_PF_Avg_Date__c and Sent_To_Finnone__c=true]; 

    system.debug(avgPFResultsZSM);

    Map<String,Decimal> avgMap=calculateAggregate(avgPFResultsZSM);        
    system.debug('avgMap='+avgMap);

    if(avgMap.size()==4){
        if((Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName.contains('Re-Appraise')) && avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){

        PFFields.ZSMPF=((((avgMap.get('AvgProcessFee')+ ApprovedPF) / 2) * ((avgMap.get('AvgLoanAmount') + ApprovedLoan)/ 2))/(avgMap.get('SumLoanAmount') + ApprovedLoan)).setscale(2);

        }
        else{
        if(avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){
            PFFields.ZSMPF=((avgMap.get('AvgProcessFee') * avgMap.get('AvgLoanAmount'))/avgMap.get('SumLoanAmount')).setscale(2);
        }
        }
    }*/

     List < Opportunity > avgPFResultsZSM = new List < Opportunity > ();
     avgPFResultsZSM = [select id, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.Zonal_SM__c =: Loan.Zonal_SM__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: currentMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: currentMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgPFResultsZSM loans ::' + avgPFResultsZSM);
     Map < String, Decimal > avgMap = calculateAggregateValue(avgPFResultsZSM, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalPF') != null)
       PFFields.ZSMPF = avgMap.get('FinalPF');
     }
    }

    if (Loan.National_SM__c != null) {
     /*  List<Opportunity> avgPFResultsNSM = [SELECT National_SM__c,Processing_Fees__c,Approved_Loan_Amount__c,Approved_Rate__c,Account.Mobile__c FROM Opportunity where National_SM__c=:Loan.National_SM__c and Product__c=:Loan.Product__c and CreatedDate >=: currentMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: currentMonthEnd.IIR_PF_Avg_Date__c and Sent_To_Finnone__c=true];

    system.debug(avgPFResultsNSM);

    Map<String,Decimal> avgMap=calculateAggregate(avgPFResultsNSM);        
    system.debug('avgMap='+avgMap);

    if(avgMap.size()==4){
        if((Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName.contains('Re-Appraise')) && avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){

        PFFields.NSMPF=((((avgMap.get('AvgProcessFee')+ ApprovedPF) / 2) * ((avgMap.get('AvgLoanAmount') + ApprovedLoan) / 2))/(avgMap.get('SumLoanAmount') + ApprovedLoan)).setscale(2);

        }
        else{
        if(avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){
            PFFields.NSMPF=((avgMap.get('AvgProcessFee') * avgMap.get('AvgLoanAmount'))/avgMap.get('SumLoanAmount')).setscale(2);
        }
        }
    }*/
     List < Opportunity > avgPFResultsNSM = new List < Opportunity > ();
     avgPFResultsNSM = [select id, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.National_SM__c =: Loan.National_SM__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: currentMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: currentMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgPFResultsNSM loans ::' + avgPFResultsNSM);
     Map < String, Decimal > avgMap = calculateAggregateValue(avgPFResultsNSM, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalPF') != null)
       PFFields.NSMPF = avgMap.get('FinalPF');
     }


    }

   }
   PF.add(PFFields);
   PFFields = new ProFees();
   PFFields.PFType = 'Previous Month';
   if (previousMonthStart != null && previousMonthStart.IIR_PF_Avg_Date__c != null && previousMonthEnd != null && previousMonthEnd.IIR_PF_Avg_Date__c != null) {
    if (Loan.Branch_Name__c != null) {
     /* List<Opportunity> avgPFResultsBranchPrev = [SELECT Branch_Name__c,Processing_Fees__c,Approved_Loan_Amount__c,Approved_Rate__c,Account.Mobile__c FROM Opportunity where Branch_Name__c=:Loan.Branch_Name__c and Product__c=:Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c and Sent_To_Finnone__c=true];

    system.debug(avgPFResultsBranchPrev);

    Map<String,Decimal> avgMap=calculateAggregate(avgPFResultsBranchPrev);        
    system.debug('avgMap='+avgMap);

    if(avgMap.size()==4){
        if((Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName.contains('Re-Appraise')) && avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){

        PFFields.BranchPF=((((avgMap.get('AvgProcessFee')+ ApprovedPF) / 2) * ((avgMap.get('AvgLoanAmount') + ApprovedLoan) / 2))/(avgMap.get('SumLoanAmount') + ApprovedLoan)).setscale(2);

        }
        else{
        if(avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){
            PFFields.BranchPF=((avgMap.get('AvgProcessFee') * avgMap.get('AvgLoanAmount'))/avgMap.get('SumLoanAmount')).setscale(2);
        }
        }
    }*/

     List < Opportunity > avgPFResultsBranchPrev = new List < Opportunity > ();
     avgPFResultsBranchPrev = [select id, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.Branch_Name__c =: Loan.Branch_Name__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgPFResultsBranchPrev loans ::' + avgPFResultsBranchPrev);
     Map < String, Decimal > avgMap = calculateAggregateValue(avgPFResultsBranchPrev, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalPF') != null)
       PFFields.BranchPF = avgMap.get('FinalPF');
     }

    }
    if (Loan.Relationship_Manager__c != null) {
     /* List<Opportunity> avgPFResultsASMPrev = [SELECT Area_SM__c,Processing_Fees__c,Approved_Loan_Amount__c,Approved_Rate__c,Account.Mobile__c FROM Opportunity where Area_SM__c=:Loan.Area_SM__c and Product__c=:Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c  and Sent_To_Finnone__c=true];

    system.debug(avgPFResultsASMPrev);

    Map<String,Decimal> avgMap=calculateAggregate(avgPFResultsASMPrev);        
    system.debug('avgMap='+avgMap);

    if(avgMap.size()==4){
        if((Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName.contains('Re-Appraise')) && avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){

        PFFields.ASMPF=((((avgMap.get('AvgProcessFee')+ ApprovedPF) / 2) * ((avgMap.get('AvgLoanAmount') + ApprovedLoan) / 2))/(avgMap.get('SumLoanAmount') + ApprovedLoan)).setscale(2);

        }
        else{
        if(avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){
            PFFields.ASMPF=((avgMap.get('AvgProcessFee')* avgMap.get('AvgLoanAmount'))/avgMap.get('SumLoanAmount')).setscale(2);
        }
        }
    }*/
     List < Opportunity > avgPFResultsASMPrev = new List < Opportunity > ();
     avgPFResultsASMPrev = [select id, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.Relationship_Manager__c =: Loan.Relationship_Manager__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgPFResultsASMPrev loans ::' + avgPFResultsASMPrev);
     Map < String, Decimal > avgMap = calculateAggregateValue(avgPFResultsASMPrev, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalPF') != null)
       PFFields.ASMPF = avgMap.get('FinalPF');
     }


    }
    if (Loan.City_SM__c != null) {
     /* List<Opportunity> avgPFResultsCitySMPrev = [SELECT City_SM__c,Processing_Fees__c,Approved_Loan_Amount__c,Approved_Rate__c,Account.Mobile__c FROM Opportunity where City_SM__c=:Loan.City_SM__c and Product__c=:Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c and Sent_To_Finnone__c=true];

    system.debug(avgPFResultsCitySMPrev);

    Map<String,Decimal> avgMap=calculateAggregate(avgPFResultsCitySMPrev);        
    system.debug('avgMap='+avgMap);

    if(avgMap.size()==4){
        if((Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName.contains('Re-Appraise')) && avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){

        PFFields.CitySMPF=((((avgMap.get('AvgProcessFee')+ ApprovedPF) / 2) * ((avgMap.get('AvgLoanAmount') + ApprovedLoan) / 2))/(avgMap.get('SumLoanAmount') + ApprovedLoan)).setscale(2);

        }
        else{
        if(avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){
            PFFields.CitySMPF=((avgMap.get('AvgProcessFee') * avgMap.get('AvgLoanAmount'))/avgMap.get('SumLoanAmount')).setscale(2);
        }
        }
    }*/
     List < Opportunity > avgPFResultsCitySMPrev = new List < Opportunity > ();
     avgPFResultsCitySMPrev = [select id, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.City_SM__c =: Loan.City_SM__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgPFResultsCitySMPrev loans ::' + avgPFResultsCitySMPrev);
     Map < String, Decimal > avgMap = calculateAggregateValue(avgPFResultsCitySMPrev, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalPF') != null)
       PFFields.CitySMPF = avgMap.get('FinalPF');
     }


    }
    if (Loan.Regional_SM__c != null) {
     /* List<Opportunity> avgPFResultsRSMPrev = [SELECT Regional_SM__c,Processing_Fees__c,Approved_Loan_Amount__c,Approved_Rate__c,Account.Mobile__c FROM Opportunity where Regional_SM__c=:Loan.Regional_SM__c and Product__c=:Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c and Sent_To_Finnone__c=true];

    system.debug(avgPFResultsRSMPrev);

    Map<String,Decimal> avgMap=calculateAggregate(avgPFResultsRSMPrev);        
    system.debug('avgMap='+avgMap);

    if(avgMap.size()==4){
        if((Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName.contains('Re-Appraise')) && avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){

        PFFields.RSMPF=((((avgMap.get('AvgProcessFee')+ ApprovedPF) / 2) * ((avgMap.get('AvgLoanAmount') + ApprovedLoan) / 2))/(avgMap.get('SumLoanAmount') + ApprovedLoan)).setscale(2);

        }
        else{
        if(avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){
            PFFields.RSMPF=((avgMap.get('AvgProcessFee') * avgMap.get('AvgLoanAmount'))/avgMap.get('SumLoanAmount')).setscale(2);
        }
        }
    }
           */

     List < Opportunity > avgPFResultsRSMPrev = new List < Opportunity > ();
     avgPFResultsRSMPrev = [select id, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.Regional_SM__c =: Loan.Regional_SM__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgPFResultsRSMPrev loans ::' + avgPFResultsRSMPrev);
     Map < String, Decimal > avgMap = calculateAggregateValue(avgPFResultsRSMPrev, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalPF') != null)
       PFFields.RSMPF = avgMap.get('FinalPF');
     }
    }
    if (Loan.Zonal_SM__c != null) {
     /*List<Opportunity>  avgPFResultsZSMPrev = [SELECT Zonal_SM__c,Processing_Fees__c,Approved_Loan_Amount__c,Approved_Rate__c,Account.Mobile__c FROM Opportunity where Zonal_SM__c=:Loan.Zonal_SM__c and Product__c=:Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c and Sent_To_Finnone__c=true];

    system.debug(avgPFResultsZSMPrev);

    Map<String,Decimal> avgMap=calculateAggregate(avgPFResultsZSMPrev);        
    system.debug('avgMap='+avgMap);

    if(avgMap.size()==4){
        if((Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName.contains('Re-Appraise')) && avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){

        PFFields.ZSMPF=((((avgMap.get('AvgProcessFee')+ ApprovedPF) / 2) * ((avgMap.get('AvgLoanAmount') + ApprovedLoan) / 2))/(avgMap.get('SumLoanAmount') + ApprovedLoan)).setscale(2);

        }
        else{
        if(avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){
            PFFields.ZSMPF=((avgMap.get('AvgProcessFee') * avgMap.get('AvgLoanAmount'))/avgMap.get('SumLoanAmount')).setscale(2);
        }
        }
    }*/

     List < Opportunity > avgPFResultsZSMPrev = new List < Opportunity > ();
     avgPFResultsZSMPrev = [select id, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.Zonal_SM__c =: Loan.Zonal_SM__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgPFResultsZSMPrev loans ::' + avgPFResultsZSMPrev);
     Map < String, Decimal > avgMap = calculateAggregateValue(avgPFResultsZSMPrev, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalPF') != null)
       PFFields.ZSMPF = avgMap.get('FinalPF');
     }
    }

    if (Loan.National_SM__c != null) {
     /*List<Opportunity> avgPFResultsNSMPrev = [SELECT National_SM__c,Processing_Fees__c,Approved_Loan_Amount__c,Approved_Rate__c,Account.Mobile__c FROM Opportunity where National_SM__c=:Loan.National_SM__c and Product__c=:Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c and Sent_To_Finnone__c=true];

    system.debug(avgPFResultsNSMPrev);

    Map<String,Decimal> avgMap=calculateAggregate(avgPFResultsNSMPrev);        
    system.debug('avgMap='+avgMap);

    if(avgMap.size()==4){
        if((Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName.contains('Re-Appraise')) && avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){

        PFFields.NSMPF=((((avgMap.get('AvgProcessFee')+ ApprovedPF) / 2) * ((avgMap.get('AvgLoanAmount') + ApprovedLoan) / 2))/(avgMap.get('SumLoanAmount') + ApprovedLoan)).setscale(2);

        }
        else{
        if(avgMap.get('AvgProcessFee')!=null && avgMap.get('SumLoanAmount')!=null && avgMap.get('AvgLoanAmount')!=null && avgMap.get('SumLoanAmount')!=0){
            PFFields.NSMPF=((avgMap.get('AvgProcessFee') * avgMap.get('AvgLoanAmount'))/avgMap.get('SumLoanAmount')).setscale(2);
        }
        }
    }*/

     List < Opportunity > avgPFResultsNSMPrev = new List < Opportunity > ();
     avgPFResultsNSMPrev = [select id, Approved_Rate__c, Approved_Loan_Amount__c, Processing_Fees__c, Account.Mobile__c from Opportunity where Id IN(select Loan_Application__c from FinnOne_Report__c where Applicant_Type__c = 'P'
      and Loan_Application__r.National_SM__c =: Loan.National_SM__c and Loan_Application__r.Product__c =: Loan.Product__c and CreatedDate >=: previousMonthStart.IIR_PF_Avg_Date__c and CreatedDate <=: previousMonthEnd.IIR_PF_Avg_Date__c)];

     system.debug('***avgPFResultsNSMPrev loans ::' + avgPFResultsNSMPrev);
     Map < String, Decimal > avgMap = calculateAggregateValue(avgPFResultsNSMPrev, ApprovedLoan, ApprovedRate, ApprovedPF);
     system.debug('avgMap=' + avgMap);

     if (avgMap != null && avgMap.size() > 0) {
      if (avgMap.get('FinalPF') != null)
       PFFields.NSMPF = avgMap.get('FinalPF');
     }
    }
   }
   PF.add(PFFields);

   system.debug('------------------------------>' + PF);
  } catch (Exception e) {
   System.debug('****Exception: ' + e.getMessage());
   message = e.getMessage() + '  Line number: ' + e.getLineNumber() + '  ' + e.getCause() + '  ' + e.getTypeName();
   SendExceptionMail(message, 'Exception came in OTP flow (refreshIRRPF())');
  }
 }

 public class IRRvalues {
  public String IRRType {
   get;
   set;
  }
  public Decimal avgBranchIRR {
   get;
   set;
  }
  public Decimal avgASMIRR {
   get;
   set;
  }
  public Decimal avgCitySMIRR {
   get;
   set;
  }
  public Decimal avgRSMIRR {
   get;
   set;
  }
  public Decimal avgZSMIRR {
   get;
   set;
  }
  public Decimal avgNSMIRR {
   get;
   set;
  }
 }


 public class ProFees {
  public String PFType {
   get;
   set;
  }
  public Decimal BranchPF {
   get;
   set;
  }
  public Decimal ASMPF {
   get;
   set;
  }
  public Decimal CitySMPF {
   get;
   set;
  }
  public Decimal RSMPF {
   get;
   set;
  }
  public Decimal ZSMPF {
   get;
   set;
  }
  public Decimal NSMPF {
   get;
   set;
  }
 }

 public List < SelectOption > getTrancheList() {
  return listTranche;
 }

 public List < Fees_and_Charge__c > getFees() {
  return Fees;
 }
 //Charges API Enhacement Start
 public void CallChargesAPI() {
  //system.debug('Loan.Loan_Application_Number__c====>' + Loan.Loan_Application_Number__c);
  //system.debug('Loan.Loan_Amount_with_Premium__c===>' + Loan.Loan_Amount_with_Premium__c);
  //system.debug('Loan.Due_Day__c' + Loan.Due_Day__c.day());
  //system.debug('Scheme' + Loan.Scheme_Master__r.Scheme_Code__c);
  // system.debug('RateOfInterest' + Loan.Approved_Rate__c);
  // system.debug('Tenure' + Loan.Approved_Tenor__c);
  BRECallout br = new BRECallout();
  Map < String, String > chargesAPIResponse = new MAP < String, String > ();
  Map < String, String > ChargesAPIMap = new Map < String, String > ();
  ChargesAPIMap.put('DealID', (Loan.Loan_Application_Number__c != null) ? String.valueof(Loan.Loan_Application_Number__c) : '0');
  ChargesAPIMap.put('LoanAmount', (Loan.Loan_Amount_with_Premium__c != null) ? String.valueof(Loan.Loan_Amount_with_Premium__c) : '0');
  ChargesAPIMap.put('DueDay', (Loan.Due_Day__c != null) ? String.valueof(Loan.Due_Day__c.day()) : '0');
  ChargesAPIMap.put('Scheme', (Loan.Scheme_Master__r.Scheme_Code__c != null) ? String.valueof(Loan.Scheme_Master__r.Scheme_Code__c) : '0');
  ChargesAPIMap.put('RateOfInterest', (Loan.Approved_Rate__c != null) ? String.valueof(Loan.Approved_Rate__c) : '0');
  ChargesAPIMap.put('Tenure', (Loan.Approved_Tenor__c != null) ? String.valueof(Loan.Approved_Tenor__c) : '0');
  system.debug('chargesAPIResponse======>' + ChargesAPIMap);

  if (!Test.isRunningTest()) {

   chargesAPIResponse = br.callCharegesAPIService(ChargesAPIMap);


  }
  system.debug('chargesAPIResponse======>' + chargesAPIResponse);
  if (chargesAPIResponse.get('result') == 'SUCCESS') {
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Fees and charges deatils saved sucessfully'));
   Fees = [select id, name, Finnone_ChargeId__c, Charge_Desc__c, Tranche_Detail__r.name, Deposition_Date__c, Deposit_Slip_Number__c, Loan_Application__r.name, Change_Amount__c, Charge_Type__c, Deducted_from_Disbursement__c,
    Service_Charge__c, Status__c, Tranche_Detail__c, Instrument_Date__c, Instrument_No__c, Bank_Branch__c, Instrument_type__c,
    Amount_after_Service_Change__c, Tranche_Detail__r.Tranche_Number__c from Fees_and_Charge__c where Loan_Application__c =: LoanId And Identifier__c != 'Mortgage' /*Mortgage*/
   ];
   //20713 AP S
   List < Fees_and_Charge__c > feesL = new List < Fees_and_Charge__c > ();
   for (Fees_and_Charge__c feesList: Fees) {
    if (feesList.Change_Amount__c > 0) {
     feesList.Deducted_from_Disbursement__c = 'Yes';
     feesList.Instrument_type__c = 'Deduct from Disb';
     feesList.Status__c = 'To be collected';
     feesL.add(feesList);
    }


   }
   upsert feesL;
   Fees = [select id, name, Finnone_ChargeId__c, Charge_Desc__c, Tranche_Detail__r.name, Deposition_Date__c, Deposit_Slip_Number__c, Loan_Application__r.name, Change_Amount__c, Charge_Type__c, Deducted_from_Disbursement__c,
    Service_Charge__c, Status__c, Tranche_Detail__c, Instrument_Date__c, Instrument_No__c, Bank_Branch__c, Instrument_type__c,
    Amount_after_Service_Change__c, Tranche_Detail__r.Tranche_Number__c from Fees_and_Charge__c where Loan_Application__c =: LoanId And Identifier__c != 'Mortgage' /*Mortgage*/
   ];

   //20713 AP E
   // SAL Mobility Addition CR - Aman Porwal - S  
   updatePrimaryApplicant();
   if (applicantPrimary != null && applicantPrimary.Financial_Health_Check_Guide__c == false && applicantPrimary.Applicant_Type__c == 'Primary') {
    system.debug('inside if>>' + applicantPrimary.Financial_Health_Check_Guide__c);
    SALMobilityChangeAmount = true;
   }
   boolean isUpdateFeesFlag = false;
   for (Fees_and_Charge__c fees1: Fees) {
    if (LaonApplicationCreation__c.getValues('SAL Mobility Charges API FFR Codes') != null) {
     String salMobilityFFRCode = LaonApplicationCreation__c.getValues('SAL Mobility Charges API FFR Codes').FFR_Finnone_charge_code__c;
     try {
      List < String > tempstr = salMobilityFFRCode.split(';');
      String temp = '';
      for (string str: tempstr) {
       if (Str.trim().length() > 0)
        temp = temp + str;
      }
      salMobilityFFRCode = temp;
      if (salMobilityFFRCode != null && loan != null && loan.Account.Flow__c == 'Mobility' && SALMobilityChangeAmount) {
       if (fees1.Finnone_ChargeId__c != null) {
        system.debug('fees1.Finnone_ChargeId__c=====>' + fees1.Finnone_ChargeId__c);
        String finnCode = String.valueOf(fees1.Finnone_ChargeId__c);
        if (salMobilityFFRCode.contains(finnCode)) {
         system.debug('inside if>>>');
         fees1.Change_Amount__c = 0;
         isUpdateFeesFlag = true;
         break;
        }
       }
      }
     } catch (Exception e) {
      system.debug('Exception is ====>' + e + '  at line number' + e.getLineNumber());
     }
    }
   }
   if (isUpdateFeesFlag && loan.Account.Flow__c == 'Mobility')
    update fees;
   // SAL Mobility Addition CR - Aman Porwal - E
   system.debug('sm response>>>' + Fees);
  } else {
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Problem while processing request........'));
  }
 }
 //Charges API Enhacement End
 /*17556 s*/
 public static Map < String, String > getFetchChargesConfigMap(Opportunity loanObj) {
  Map < String, String > ChargesAPIMap = new Map < String, String > ();
  ChargesAPIMap.put('DealID', (loanObj.Loan_Application_Number__c != null) ? String.valueof(loanObj.Loan_Application_Number__c) : '0');
  ChargesAPIMap.put('LoanAmount', (loanObj.Loan_Amount_with_Premium__c != null) ? String.valueof(loanObj.Loan_Amount_with_Premium__c) : '0');
  ChargesAPIMap.put('DueDay', (loanObj.Due_Day__c != null) ? String.valueof(loanObj.Due_Day__c.day()) : '0');
  ChargesAPIMap.put('Scheme', (loanObj.Scheme_Master__r.Scheme_Code__c != null) ? String.valueof(loanObj.Scheme_Master__r.Scheme_Code__c) : '0');
  ChargesAPIMap.put('RateOfInterest', (loanObj.Approved_Rate__c != null) ? String.valueof(loanObj.Approved_Rate__c) : '0');
  ChargesAPIMap.put('Tenure', (loanObj.Approved_Tenor__c != null) ? String.valueof(loanObj.Approved_Tenor__c) : '0');
  system.debug('chargesAPIResponse======>' + ChargesAPIMap);

  return ChargesAPIMap;
 }
 /*17556 e*/
 public void SaveFees() {
  try {
   List < Fees_and_Charge__c > Feesdet = new List < Fees_and_Charge__c > ();
   for (integer i = 0; i < Fees.size(); i++) {
    Fees[i].Loan_Application__c = LoanId;
    if (Fees[i].Change_Amount__c != null) {
     Feesdet.add(Fees[i]);
    }
   }
   upsert Feesdet;
   savedSuccessfull = true;
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Fees and Charges Details saved successfully.'));
   //Bug# 12163 S
   //13793--S
   if (DisbList != null && DisbList.size() > 0 && netdisb != null) {
    getNetdisbAmount();
    if (DisbList[0].isTopUp__c == true) {
     if (DisbList.size() > 1) {
      DisbList[1].Disbursement_Amount__c = netdisb - DisbList[0].Disbursement_Amount__c;
      upsert DisbList[1];
     }
    } else {
     DisbList[0].Disbursement_Amount__c = netdisb;
     upsert DisbList[0];
    }

   }
   //13793--E
   //Bug# 12163 E
  } catch (Exception e) {
   Apexpages.addMessages(e);
   System.debug('****Exception: ' + e.getMessage());
   savedSuccessfull = true;
   message = e.getMessage() + '  ' + e.getLineNumber() + '  ' + e.getCause() + '  ' + e.getTypeName();
   SendExceptionMail(message, 'Exception came in MidOffice flow (Pricing Details)');
  }
 }
 public void addrowFee() {
  Fees_and_Charge__c addFee = new Fees_and_Charge__c();
  Fees.add(addFee);
 }

 public void SendExceptionMail(String body, String Sub) {
  String mailBody = body;
  mailBody = mailBody.replace('"', '\\"');
  String Subject = Sub;
  List < String > emailList = new List < String > ();
  String[] toAddress = Label.MidOfficeExceptionMails.split(';');
  if (toAddress.size() > 0) {
   for (String emails: toAddress) {
    emailList.add(emails);
   }
   SOLsendEmail.LogixEmailForDG(emailList, Subject, mailBody);
  }
 }


 public void approve() {
      //24028 S
   centralisedTopUp=false;  
   //24028 E
  ApexPages.getMessages().clear();
  //Rate Approval start
  Boolean flag = false;
  System.debug('rateFlag*********' + rateflag);
  System.debug('Loan.Approved_Rate__c*********' + Loan.Approved_Rate__c);
  System.debug('applicantPrimary.mail_to_Sales_Hierarchy__c*********' + applicantPrimary.mail_to_Sales_Hierarchy__c);
  if (rateflag && appValid && !applicantPrimary.mail_to_Sales_Hierarchy__c) {
   if (Loan.Scheme_Master__r.flexi_flag__c == true && Loan.Approved_Rate__c < applicantPrimary.ROIFlexi__c) {
    flag = true;
   } else if (Loan.Scheme_Master__r.PLOC_scheme__c == true && Loan.Approved_Rate__c < applicantPrimary.ROILoc__c) {
    flag = true;
   } else if (Loan.Approved_Rate__c < applicantPrimary.ROINormal__c) {
    flag = true;
   }
   if (flag == true) {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Send mail to Sales Hierarchy is Mandatory! Proposed Rate is below the system prescribed rate. Please take necessary approvals before proceeding'));
    return;
   }

  }
  //Rate Approval end

  // 24028 S
     if(Loan.Product__c=='SBS CS SAL' && Loan.Scheme_Master__c !=null && String.isNotBlank(Label.CentralisedTopUp) /*&& (Loan.Scheme_Master__r.Scheme_Code__c=='101109' || Loan.Scheme_Master__r.Scheme_Code__c=='101110')*/ ) {
         if(!CommonUtility.isEmpty(Loan.Scheme_Master__r.Scheme_Code__c)){
            String[] schemeCodes = Label.CentralisedTopUp.split(';');
           for(string str: schemeCodes){
               if(str==Loan.Scheme_Master__r.Scheme_Code__c){
                   centralisedTopUp=true;    
                   break;
               }
           }
         }   
         system.debug('centralisedTopUp'+centralisedTopUp);  
          
       }
     //24028 E
  //Hybrid Flexi :akshata S
     if (applicantPrimary != null ){
         if(IsHybridFlexi != null && IsHybridFlexi) {
            upsert applicantPrimary;
            }  
  //Hybrid Flexi :Akshata E
   //24028 S
     else if(centralisedTopUp){
         //system.debug('applicantPrimary:' +applicantPrimary.Spread_Percentage__c+'; '+applicantPrimary.Current_BFL_FRR__c+' ; '+Current_BFL_FRR);
             update applicantPrimary;
             system.debug('upserted applicantPrimary::'+applicantPrimary);         
         }                    
     }
  //24028 E

  if (salesApprovedRate != null) {
   Loan.Requested_ROI__c = Loan.Approved_Rate__c;
   Loan.Approved_Rate__c = decimal.valueof(salesApprovedRate);
  }
  if (salesApprovedPF != null)
   Loan.Processing_Fees__c = decimal.valueof(salesApprovedPF);

  Loan.Pricing_Details_Approved_by__c = userinfo.getuserid();

  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Pricing Details Approved Successfully.'));

  upsert Loan;
  /*Bug 14506 - HFC Fields - SFDC By Rajesh Start*/
  if (BHFLProductsFlag)
   upsert account;
  /*Bug 14506 - HFC Fields - SFDC By Rajesh END*/

 }
 public void reject() {
  ApexPages.getMessages().clear();
 }
 public void Recommend() {
  ApexPages.getMessages().clear();
 }

 public PageReference SubmitToBranchOps() {
  if (Loan != null) {

   //Mortgage Re-Engg S
   system.debug('--- Inside SubmitToBranchOps ---');
   system.debug('--- Mortgageflag ---' + Mortgageflag);
   if (Mortgageflag) {
    List < Property_Details__c > objPropList = new List < Property_Details__c > ();
    objPropList = Loan.Property_Details__r;
    system.debug('--- Loan.Property_Details__r ---' + Loan.Property_Details__r);
    if (objPropList == null || objPropList.size() == 0) {
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Loan Application should have atleast one Property !!!'));
     return null;
    } else { // bug 13560 start

     commonPropertyMethods probMethods = new commonPropertyMethods();
     probMethods.CallDCM(propertyList, Loan, applicantPrimary);

    } // bug 13560 end
   }

   //Mortgage Re-Engg E

   //New code
   system.debug('-----StrCOAppr--------' + StrCOAppr);
   if (StrCOAppr == 'None') {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please select the Approver before submitting'));
    return null;
   }

   string approverDesignation1 = null;
   Integer loanAmt = 0;
   Credit_Officer_Limit__c tempCOL1 = new Credit_Officer_Limit__c();
   try {
    tempCOL1 = [select id, Designation__c, Loan_Amount__c, Credit_Officer_Name__r.id, Credit_Officer_Name__r.Employee_ID__c, Pre_Approved_Amount__c from Credit_Officer_Limit__c where id =: StrCOAppr];

    //approverDesignation1=tempCOL1.Designation__c;
    //loanAmt = Integer.valueof(tempCOL1.Loan_Amount__c);
    if (tempCOL1 != null) {
     approverDesignation1 = tempCOL1.Designation__c;
     if (COLStampFlag == true) {
      if (Loan.Program_Type__c == 'Pre-Approved') {
       loanAmt = Integer.valueof(tempCOL1.Pre_Approved_Amount__c);
      } else {
       loanAmt = Integer.valueof(tempCOL1.Loan_Amount__c);
      }
     } else {
      loanAmt = Integer.valueof(tempCOL1.Loan_Amount__c);
     }
    }

   } catch (Exception e) {
    System.debug('****Exception: ' + e.getMessage());
    savedSuccessfull = true;
    message = e.getMessage() + '  ' + e.getLineNumber() + '  ' + e.getCause() + '  ' + e.getTypeName();
    SendExceptionMail(message, 'Exception came in OTP flow (Eligibility)');
   }
   system.debug('--------1--------' + Loan.Approver__c);
   system.debug('--------approverDesignation1--------' + approverDesignation1);

   if (Loan.Approver__c == 'Centralized CPA') {

    StrCOAppr = tempCOL1.Credit_Officer_Name__r.id;
    system.debug('StrCOAppr:------ ' + StrCOAppr);
    Loan.ownerid = StrCOAppr;
    Loan.Approver__c = 'Centralized ACM';
    Loan.Centralized_ACM__c = StrCOAppr;
    Loan.Centralized_ACM_Amount__c = loanAmt;
    system.debug('StrAppr:---Loan.ownerid--- ' + Loan.ownerid);
   } else if (approverDesignation1 == 'Centralized RCM') {
    StrAppr = tempCOL1.Credit_Officer_Name__r.id;
    system.debug('StrAppr:------ ' + StrCOAppr);
    Loan.ownerid = StrCOAppr;
    Loan.Approver__c = 'Centralized RCM';
    Loan.Centralized_RCM_Amount__c = loanAmt;
    system.debug('StrAppr:---Loan.ownerid--- ' + Loan.ownerid);
    Loan.Centralized_RCM__c = StrCOAppr;
    // Code to initiate CIBIL
    System.debug('-- Salaried initiate CIBIL --' + applicantList.size());
    applicantList[0].Integrate_with_CIBIL__c = true;
    applicantList[0].Update_CIBIL_Error__c = false;
    applicantList[0].Description__c = '';
    update applicantList;
   } else if (Loan.Approver__c != 'Centralized CPA') {
    string approverDesignation = null;
    system.debug('*****StrCOAppr: ' + StrCOAppr);
    if ((StrCOAppr != null) && (StrCOAppr != 'None')) {
     Credit_Officer_Limit__c tempCOL = [select id, Designation__c, Credit_Officer_Name__r.id, Credit_Officer_Name__r.Employee_ID__c from Credit_Officer_Limit__c
      where Id =: StrCOAppr
     ];
     approverDesignation = tempCOL.Designation__c;
     system.debug('******approverDesignation: ' + approverDesignation);

     StrCOAppr = tempCOL.Credit_Officer_Name__r.id;
    }


    String Branch = Loan.BranchName__c;
    double acmamt = 0;
    //4450
    List < Credit_Officer_Limit__c > acmList = new List < Credit_Officer_Limit__c > ();
    System.debug('LoanAppFlow=' + LoanAppFlow);

    // strung proproduct=
    if (Branch != null && Loan.Product__c != null && StrCOAppr != null) {
     try {
      if (COLStampFlag == true && LoanAppFlow != null) {
       acmList = [select Loan_Amount__c, Pre_Approved_Amount__c from Credit_Officer_Limit__c
        where Credit_Officer_Name__c =: StrCOAppr
        and /**Product__c =:**/ Product__c =: Loan.Product__c and City__c INCLUDES(: Branch) and Flow__c INCLUDES(: LoanAppFlow) and Active_Flag__c = true limit 1
       ];

       if (acmList.size() > 0) {
        if (Loan.Program_Type__c == 'Pre-Approved') {
         acmamt = acmList[0].Pre_Approved_Amount__c;
        } else {
         acmamt = acmList[0].Loan_Amount__c;
        }
       }

      } else {
       acmamt = [select Loan_Amount__c from Credit_Officer_Limit__c
        where Credit_Officer_Name__c =: StrCOAppr and Product__c =: Loan.Product__c and City__c INCLUDES(: Branch) and Active_Flag__c = true limit 1
       ].Loan_Amount__c;
      }
     } catch (Exception e) {
      Apexpages.addMessages(e);
      System.debug('****Exception: ' + e.getMessage());
      savedSuccessfull = true;
      message = e.getMessage() + '  ' + e.getLineNumber() + '  ' + e.getCause() + '  ' + e.getTypeName();
      SendExceptionMail(message, 'Exception came in MidOffice flow (Eligibility)');
      return null;
     }
    }


    if (approverDesignation1 == 'Centralized Ops Officer') {
     Loan.ownerId = StrCOAppr;
     Loan.Approver__c = 'Centralized Ops Officer';
     Loan.CPA__c = StrCOAppr;
    } 
    //==#19281: Added CPA Login Partner condition start
    else if(approverDesignation1 == 'CPA Login Partner' )
    {
        Loan.ownerId = StrCOAppr;
        Loan.Approver__c = 'CPA Login Partner';
        Loan.CPA__c = StrCOAppr;
    }
    //==#19281: Added CPA Login Partner condition end
    else if (approverDesignation1 == 'OPs Officer') {
     Loan.ownerId = StrCOAppr;
     Loan.Approver__c = 'OPs Officer';
     Loan.CPA__c = StrCOAppr;
    } else if (approverDesignation1 == 'OPs Area Manager') {
     Loan.ownerId = StrCOAppr;
     Loan.Approver__c = 'OPs Area Manager';
     Loan.CPA__c = StrCOAppr;
    } else if (approverDesignation1 == 'OPs Regional Manager') {
     Loan.ownerId = StrCOAppr;
     Loan.Approver__c = 'OPs Regional Manager';
     Loan.CPA__c = StrCOAppr;
    } else if (approverDesignation1 == 'OPs Zonal Manager') {
     Loan.ownerId = StrCOAppr;
     Loan.Approver__c = 'OPs Zonal Manager';
     Loan.CPA__c = StrCOAppr;
    } else if (approverDesignation1 == 'OPs National Manager') {
     Loan.ownerId = StrCOAppr;
     Loan.Approver__c = 'OPs National Manager';
     Loan.CPA__c = StrCOAppr;
    } else {
     //Submit to Approver logic
     if (StrCOAppr != null)
      Loan.ownerid = StrCOAppr;
     Loan.CPA__c = StrCOAppr;
    }
   }
   Loan.stageName = 'Branch Ops';
   Loan.Sales_Submit_to_Branch_Ops_Date__c = System.now();
   update loan;
  }
  //  PageReference p = new PageReference('/apex/DisbursementDetailsPage?id='+loan.id);

  Pagereference p = new pagereference('/006/o');
  p.setRedirect(true);
  return p;

 }

 //code added by Prajyot-Pricing changes point1 start
 public void sendmailtoSelctedHirarchy() {

  try {
   List < String > toAddlist = new List < String > ();
   List < String > toAddlistCC = new List < String > ();
   String emailId = '';
   string name1 = '';
   String name = '';
   system.debug('value of StrAppr=' + StrAppr);
   if (totalSolimt != null && totalSolimt.size() > 0) {
    for (integer i = 0; i < totalSolimt.size(); i++) {
     name = totalSolimt[i].Sales_Officer_Name__c;
     system.debug('value of name=' + name);
     if (name == StrAppr) {
      emailId = totalSolimt[i].Sales_Officer_Name__r.email;
      name1 = totalSolimt[i].Sales_Officer_Name__r.Name;
      System.debug('name=' + name1);
     }

     system.debug('***** designation=' + totalSolimt[i].Sales_Officer_Name__r.name);
     system.debug('******** StrAppr=' + StrAppr);
     system.debug('****** value of emailId' + emailId);
    }
   }
   toAddlist.add(emailId);



   System.debug('In BH mail...');




   //if (loan.Accountant_email_id__c != null)
   //toAddlist.add('amitkumar_kohakade@persistent.co.in');

   if (toAddlist.size() > 0) {

    propertyList = SelectQueriesHelperClass.QueryPropertyDetailsMortgage(Loan.id);
    System.debug(propertyList.size() + '=propertyList.size()');
    bankList = SelectQueriesHelperClass.QueryBankAccountsMortgage(Loan.id);
    System.debug(bankList.size() + '=bankList.size()');

    List < Fees_and_Charge__c > feesTempList = new List < Fees_and_Charge__c > ();
    feesTempList = SelectQueriesHelperClass.QueryFeesMortgage(Loan.id);
    if (feesTempList.size() > 0)
     feesMortgage = feesTempList[0];


    String[] toAdd = toAddlist;
    String[] ccArray = toAddlistCC;
    String[] bccArray;
    System.debug('toAddlist' + toAddlist + 'toAddlistCC=' + toAddlistCC);

    decimal liPremium = 0;
    decimal hiPremium = 0;
    for (DPLinsurance__c tempIns: Hinsurance) {
     system.debug('tempIns.Insurance_Type__c=' + tempIns.Insurance_Type__c);
     if (tempIns.Insurance_Type__c == 'HDFC Life' || tempIns.Insurance_Type__c == 'BALIC') {
      if (tempIns.Insurance_amount__c != null)
       system.debug('liPremium b4=' + liPremium);
      //liPremium = tempIns.Insurance_amount__c + liPremium;
      liPremium = Integer.valueOf(tempIns.Premium_Amount__c) + liPremium;
      system.debug('liPremium after=' + liPremium);
      system.debug('tempIns.Insurance_Type__c=' + tempIns.Insurance_Type__c);

     }
    }

    for (DPLinsurance__c tempIns: Hinsurance) {
     if (tempIns.Insurance_Type__c == 'ICICI Lombard' || tempIns.Insurance_Type__c == 'BAGIC' || tempIns.Insurance_Type__c == 'MAX Bupa' || tempIns.Insurance_Type__c == 'CPP') {
      //hiPremium = tempIns.Premium_Amount__c + hiPremium;
      hiPremium = Integer.valueOf(tempIns.Premium_Amount__c) + hiPremium;
     }
    }

    String body = 'Hi ' + name1 + ',\n &nbsp;&nbsp; Please check request for pricing approval' + '\n\n';

    //body +='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><title>Bajaj Finserv</title><style type="text/css"></style></head><body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="color: #000000; font-family: Arial, Helvetica, sans-serif; font-size: 15px"><table width="780" border="0" cellpadding="0" cellspacing="0" style="border: 1px #949494 solid" align="center"><tr><td valign="top" colspan="5"><table border="0" cellpadding="0" cellspacing="0"><td ><a href="http://www.bajajfinserv.in/finance/?utm_source=May_PL_Email_Loan_Approved_BF&utm_medium=Email&utm_campaign=PL_Generic" target="_blank"><img src="https://c.cs31.visual.force.com/resource/1461839189000/BajajFinServLogo" height="83" alt="Bajaj Finserv" title="Bajaj Finserv" align="right" border="0" /></a></td></table></td></tr><tr> <td colspan="5" valign="top" style="padding: 5px 0 10px 12px;"><div style="font-size: 15px; font-weight: bold;">Commercial Approval Details</div></td></tr><tr><td height="366" colspan="5" valign="top" style="padding:0 0 5px 0;"><table width="100%" border="0" cellpadding="0" cellspacing="0" ><tr><td width="467px" height="361" valign="top"><table style="width: 100%;line-height: 2;" border="1"><tr><td style="width: 16%;">Customer Type </td><td style="width: 16%;">'+Loan.customer_type__c+'</td><td style="width: 16%;">Customer Segmentation</td><td style="width: 16%;">'+applicantPrimary.SegmentaionResult__c+'</td><td style="width: 16%;">SFDC ID</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Product </td><td style="width: 16'+Loan.Product__c+'</td><td style="width: 16%;">Loan type </td><td style="width: 16%;">'+Loan.Type_Of_Loan__c+'</td><td style="width: 16%;">Transcation type</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Flexi saver Scheme</td><td style="width: 16%;"></td><td style="width: 16%;">Location </td><td style="width: 16%;"></td><td style="width: 16%;">Customer Name</td><td style="width: 16%;">'+applicantPrimary.Contact_Name__r.Name+'</td></tr><tr><td style="width: 16%;">BT loan Amount </td><td style="width: 16%;"></td><td style="width: 16%;">BT Bank Name</td><td style="width: 16%;"></td><td style="width: 16%;">Top-up</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Stamped ROI BT </td><td style="width: 16%;"></td><td style="width: 16%;">Stamped ROI Top-up</td><td style="width: 16%;"></td><td style="width: 16%;">Requested BT ROI</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Requested Top ROI</td><td style="width: 16%;"></td><td style="width: 16%;">Requested ROI</td><td style="width: 16%;"></td><td style="width: 16%;">Stamped PF</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Requested BT PF</td><td style="width: 16%;"></td><td style="width: 16%;">Requesetd Top PF</td><td style="width: 16%;"></td><td style="width: 16%;">Stamped insurance </td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Requested  Insurance </td><td style="width: 16%;"></td> <td style="width: 16%;">Insurance GI </td><td style="width: 16%;"></td><td style="width: 16%;">Insurance LI </td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Insurance Type</td><td style="width: 16%;"></td><td style="width: 16%;">Insurance Term</td><td style="width: 16%;"></td><td style="width: 16%;">Property Dossier</td><td style="width: 16%;">'+applicantPrimary.Property_Dossier_Report__c+'</td></tr><tr><td style="width: 16%;">FFR</td><td style="width: 16%;"></td><td style="width: 16%;">ELC/REMI Card </td><td style="width: 16%;">'+Loan.ELC_offer_accepted__c+'</td><td style="width: 16%;">VAS 4</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">MOF waiver </td><td style="width: 16%;">'+Loan.Premium_Amount__c+'</td><td style="width: 16%;">VAS 5</td><td style="width: 16%;"></td><td style="width: 16%;">Overall WtIIR</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Channel Type </td><td style="width: 16%;">'+Loan.Sourcing_Channel_Type__c+'</td><td style="width: 16%;">Mortgage Plus loan amount </td><td style="width: 16%;"></td><td style="width: 16%;">Mortgage plus ROI </td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Mortgage Plus PF </td><td style="width: 16%;"></td><td style="width: 16%;">Disbusemnet mode </td><td style="width: 16%;">'+Loan.Disbursement_Type__c+'</td><td style="width: 16%;">CF/PF/Lock in FEE in Rs.</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Requested Payout</td><td style="width: 16%;"></td><td style="width: 16%;">Total loan amount (including insurance amount and PD)</td><td style="width: 16%;">'+Loan.Loan_Amount_with_Premium__c+'</td><td style="width: 16%;">BT-Top Disbursement together</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">AMC Charges</td><td style="width: 16%;">'+Loan.AMC__c+'</td><td style="width: 16%;">AMC %</td><td style="width: 16%;"></td><td style="width: 16%;">Foreclosuer charges</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Interest bearing letter</td><td style="width: 16%;"></td><td style="width: 16%;">Special Remarks</td><td style="width: 16%;"></td><td style="width: 16%;">Part-payment charges</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">SM/ASM Name</td><td style="width: 16%;"></td><td style="width: 16%;">Submitted To</td><td style="width: 16%;"></td><td style="width: 16%;">Special Recommendation</td> <td style="width: 16%;"></td></tr></table></td></tr></table></td></tr><tr><td style="padding:7px 14px 0 12px" colspan="5"><table width="228px" border="0" cellpadding="0" cellspacing="0" align="left"><tr><td valign="top"><img src="https://cs6.salesforce.com/servlet/servlet.ImageServer?id=015N0000000HrHj&oid=00DN0000000Un0W" width="111" height="35" alt="Connect with us" title="Connect with us" align="left" border="0" /></td><td valign="top"><a href="https://www.facebook.com/bajajfinserv?sk=app_190322544333196" target="_blank"><img src="https://cs6.salesforce.com/servlet/servlet.ImageServer?id=015N0000000HrHo&oid=00DN0000000Un0W" width="42" height="35" alt="Facebook" title="Facebook" align="left" border="0" /></a></td><td valign="top"><a href="https://twitter.com/Bajaj_Finserv" target="_blank"><img src="https://cs6.salesforce.com/servlet/servlet.ImageServer?id=015N0000000HrHy&oid=00DN0000000Un0W" width="40" height="35" alt="twitter" title="twitter" align="left" border="0" /></a></td><td valign="top"><a href="http://www.linkedin.com/company/1092003?trk=tyah" target="_blank"><img src="https://cs6.salesforce.com/servlet/servlet.ImageServer?id=015N0000000HrHt&oid=00DN0000000Un0W" width="35" height="35" alt="LinkedIn" title="LinkedIn" align="left" border="0" /></a></td></tr></table></td></tr><tr><td valign="top" colspan="5" style="padding: 10px 14px 10px 12px;"><div style="line-height:18px; font-size:13px;">Terms and conditions apply</div></td></tr><tr><td valign="top" colspan="5" style="padding: 10px 14px 10px 12px;"><div style="line-height:18px; font-size:13px;"><img src="https://c.cs31.visual.force.com/resource/1422952355000/BajajLowerLogo" width="179" height="21" alt="Bajaj Finserv" title="Bajaj Finserv" align="right" border="0" /></div></td></tr></table></body></html>';

    // body +='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><title>Bajaj Finserv</title><style type="text/css"></style></head><body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="color: #000000; font-family: Arial, Helvetica, sans-serif; font-size: 15px"><table width="780" border="0" cellpadding="0" cellspacing="0" style="border: 1px #949494 solid" align="center"><tr><td height="366" colspan="5" valign="top" style="padding:0 0 5px 0;"><table width="100%" border="0" cellpadding="0" cellspacing="0" ><tr><td width="467px" height="361" valign="top"><table style="width: 100%;line-height: 2;" border="1"><tr><td style="width: 16%;">Customer Type </td><td style="width: 16%;">'+Loan.customer_type__c+'</td><td style="width: 16%;">Customer Segmentation</td><td style="width: 16%;">'+applicantPrimary.SegmentaionResult__c+'</td><td style="width: 16%;">SFDC ID</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Product </td><td style="width: 16%;">'+Loan.Product__c+'</td><td style="width: 16%;">Loan type </td><td style="width: 16%;">'+Loan.Type_Of_Loan__c+'</td><td style="width: 16%;">Transcation type</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Flexi saver Scheme</td><td style="width: 16%;"></td><td style="width: 16%;">Location </td><td style="width: 16%;"></td><td style="width: 16%;">Customer Name</td><td style="width: 16%;">'+applicantPrimary.Contact_Name__r.Name+'</td></tr><tr><td style="width: 16%;">BT loan Amount </td><td style="width: 16%;"></td><td style="width: 16%;">BT Bank Name</td><td style="width: 16%;"></td><td style="width: 16%;">Top-up</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Stamped ROI BT </td><td style="width: 16%;"></td><td style="width: 16%;">Stamped ROI Top-up</td><td style="width: 16%;"></td><td style="width: 16%;">Requested BT ROI</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Requested Top ROI</td><td style="width: 16%;"></td><td style="width: 16%;">Requested ROI</td><td style="width: 16%;"></td><td style="width: 16%;">Stamped PF</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Requested BT PF</td><td style="width: 16%;"></td><td style="width: 16%;">Requesetd Top PF</td><td style="width: 16%;"></td><td style="width: 16%;">Stamped insurance </td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Requested  Insurance </td><td style="width: 16%;"></td> <td style="width: 16%;">Insurance GI </td><td style="width: 16%;"></td><td style="width: 16%;">Insurance LI </td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Insurance Type</td><td style="width: 16%;"></td><td style="width: 16%;">Insurance Term</td><td style="width: 16%;"></td><td style="width: 16%;">Property Dossier</td><td style="width: 16%;">'+applicantPrimary.Property_Dossier_Report__c+'</td></tr><tr><td style="width: 16%;">FFR</td><td style="width: 16%;"></td><td style="width: 16%;">ELC/REMI Card </td><td style="width: 16%;">'+Loan.ELC_offer_accepted__c+'</td><td style="width: 16%;">VAS 4</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">MOF waiver </td><td style="width: 16%;">'+Loan.Premium_Amount__c+'</td><td style="width: 16%;">VAS 5</td><td style="width: 16%;"></td><td style="width: 16%;">Overall WtIIR</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Channel Type </td><td style="width: 16%;">'+Loan.Sourcing_Channel_Type__c+'</td><td style="width: 16%;">Mortgage Plus loan amount </td><td style="width: 16%;"></td><td style="width: 16%;">Mortgage plus ROI </td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Mortgage Plus PF </td><td style="width: 16%;"></td><td style="width: 16%;">Disbusemnet mode </td><td style="width: 16%;">'+Loan.Disbursement_Type__c+'</td><td style="width: 16%;">CF/PF/Lock in FEE in Rs.</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Requested Payout</td><td style="width: 16%;"></td><td style="width: 16%;">Total loan amount (including insurance amount and PD)</td><td style="width: 16%;">'+Loan.Loan_Amount_with_Premium__c+'</td><td style="width: 16%;">BT-Top Disbursement together</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">AMC Charges</td><td style="width: 16%;">'+Loan.AMC__c+'</td><td style="width: 16%;">AMC %</td><td style="width: 16%;"></td><td style="width: 16%;">Foreclosuer charges</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Interest bearing letter</td><td style="width: 16%;"></td><td style="width: 16%;">Special Remarks</td><td style="width: 16%;"></td><td style="width: 16%;">Part-payment charges</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">SM/ASM Name</td><td style="width: 16%;"></td><td style="width: 16%;">Submitted To</td><td style="width: 16%;"></td><td style="width: 16%;">Special Recommendation</td> <td style="width: 16%;"></td></tr></table></td></tr></table></td></tr></table></body></html>';

    body += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><title>Bajaj Finserv</title><style type="text/css"></style></head><body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="color: #000000; font-family: Arial, Helvetica, sans-serif; font-size: 15px">';

    body += '<table width="800" border="1" cellpadding="0" cellspacing="0" style="border: 1px #949494 solid" align="center" ><tr style="text-align: center;"><td Style="Width:2%;">WIRR</td><td Style="Width:2%;">WPF</td><td Style="Width:5%;">LI PREMIUM</td><td Style="Width:4%;">LI Percent</td><td Style="Width:4%;">HI PREMIUM</td><td Style="Width:4%;">HI Percent</td><td Style="Width:4%;">FFR Percent</td></tr>';
    if (solList != null && solList.size() > 0) {
     body += '<tr style="text-align: center;"><td>' + solList[0].WIRR__c + '</td><td>' + solList[0].WPF__c + '</td><td>' + solList[0].LI_PREMIUM__c + '</td><td>' + solList[0].LI_Percent__c + '</td><td>' + solList[0].HI_PREMIUM__c + '</td><td>' + solList[0].HI_Percent__c + '</td><td>' + solList[0].FFR_Percent__c + '</td></tr>';
    }

    body += '</table><br/><br/><table width="800" border="1" cellpadding="0" cellspacing="0" style="border: 1px #949494 solid" align="center"><tr style="text-align: center;"><td Style="Width:2%;">SFDC ID</td><td Style="Width:4%;">Application Name</td><td Style="Width:3%;">SM</td><td Style="Width:3%;">Application Source</td><td Style="Width:2%;">ROI</td><td Style="Width:2%;">PF</td><td Style="Width:2%;">LI PREMIUM</td><td Style="Width:2%;">HI PREMIUM</td><td Style="Width:2%;">FFR (Y/N)</td></tr>';
    //Rate Approval start
    if (Loan.Amount_Rs__c == null && loan.Loan_Amount_with_Premium__c != null && loan.Processing_Fees__c != null) {
     Loan.Amount_Rs__c = (loan.Loan_Amount_with_Premium__c * loan.Processing_Fees__c) / 100;
    }
    //Rate Approval end
    if (applicantPrimary.FFR_Email_Sent__c == true) {
     body += '<tr style="text-align: center;"><td>' + Loan.Loan_Application_Number__c + '</td><td>' + applicantPrimary.Contact_Name__r.name + '</td><td>' + Loan.Relationship_Manager__r.name + '</td><td>' + Loan.Application_Source__c + '</td><td>' + Loan.Approved_Rate__c + '</td><td>' + Loan.Amount_Rs__c + '</td><td>' + liPremium + '</td><td>' + hiPremium + '</td><td>' + 'Y' + '</td></tr>';
    } else if (applicantPrimary.FFR_Email_Sent__c == false) {
     body += '<tr style="text-align: center;"><td>' + Loan.Loan_Application_Number__c + '</td><td>' + applicantPrimary.Contact_Name__r.name + '</td><td>' + Loan.Relationship_Manager__r.name + '</td><td>' + Loan.Application_Source__c + '</td><td>' + Loan.Approved_Rate__c + '</td><td>' + Loan.Amount_Rs__c + '</td><td>' + liPremium + '</td><td>' + hiPremium + '</td><td>' + 'N' + '</td></tr>';
    }




    body += '</table><br/><br/><table width="800" border="1" cellpadding="0" cellspacing="0" style="border: 1px #949494 solid" align="center" ><tr style="text-align: center;"><td Style="Width:2%;">Employer Name</td><td Style="Width:2%;">Employer Category</td><td Style="Width:5%;">Customer Segmentation</td><td Style="Width:4%;">Scheme/Product</td></tr>';
    if (loan.account.Employer__r.name != null) {
     body += '<tr style="text-align: center;"><td>' + loan.account.Employer__r.name + '</td><td>' + loan.account.Type_Of_Industry__c + '</td><td>' + applicantPrimary.SegmentaionResult__c + '</td><td>' + Loan.Product__c + '/' + Loan.Scheme_Master__r.name + '</td></tr>';
    } else {
     body += '<tr style="text-align: center;"><td>' + loan.account.Name_of_the_Company_Employer__c + '</td><td>' + loan.account.Employer__r.Company_Category__c + '</td><td>' + applicantPrimary.SegmentaionResult__c + '</td><td>' + Loan.Product__c + '/' + Loan.Scheme_Master__r.name + '</td></tr>';
    }

    body += '</table><br/><br/><table width="800" border="1" cellpadding="0" cellspacing="0" style="border: 1px #949494 solid" align="center" ><tr style="text-align: center;"><td Style="Width:2%;">Line(Y/N)</td><td Style="Width:2%;">LOC(Y/N)</td></tr>';
    body += '<tr style="text-align: center;"><td>' + objSurrogateCAM.Line_opted__c + '</td><td>' + allCAM[0].Business_Continuty__c + '</td>' + '</tr>';
    //Rate Approval start
    if (rateFlag) {
     body += '</table><br/><br/><table width="800" border="1" cellpadding="0" cellspacing="0" style="border: 1px #949494 solid" align="center" ><tr style="text-align: center;"><td Style="Width:2%;">Rack Rate Normal</td><td Style="Width:2%;">Rack Rate Flexi</td><td Style="Width:2%;">Rack Rate LOC</td><td Style="Width:2%;">Rack Rate from PO</td><td Style="Width:2%;">Proposed Rate</td><td Style="Width:2%;">Approved Loan Amount</td><td Style="Width:2%;">Approved Tenor</td></tr>';
     body += '<tr style="text-align: center;"><td>' + applicantPrimary.ROINormal__c + '</td><td>' + applicantPrimary.ROIFlexi__c + '</td><td>' + applicantPrimary.ROILoc__c + '</td><td>' + applicantPrimary.ROI_PO__c + '</td><td>' + Loan.Approved_Rate__c + '</td><td>' + Loan.Approved_Loan_Amount__c + '</td><td>' + Loan.Approved_Tenor__c + '</td></tr>';
    }
    //Rate Approval end
    body += '</table><br/><br/><p valign="top" style="padding:5px 20px;font-family:Arial, Helvetica, sans-serif; font-size:14px;line-height:22px;color:#197bb9">Warm regards,<br/>Bajaj Finserv</p>';

    //    body += '</table><br/><br/><table style="width: 100%;line-height: 2;" ><tr><td style="width: 16%;">Customer Type </td><td style="width: 16%;">' + Loan.Customer_Type__c + '</td><td style="width: 16%;">Customer Segmentation</td><td style="width: 16%;">' + applicantPrimary.SegmentaionResult__c + '</td><td style="width: 16%;">SFDC ID</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Product </td><td style="width: 16%;">' + Loan.Product__c + '</td><td style="width: 16%;">Loan type </td><td style="width: 16%;">' + Loan.Type_Of_Loan__c + '</td><td style="width: 16%;">Flexi saver Scheme</td><td style="width: 16%;">' + feesMortgage.Bank_Branch__c + '</td></tr><tr><td style="width: 16%;">Location </td><td style="width: 16%;">' + Loan.BranchName__c + '</td><td style="width: 16%;">Customer Name</td><td style="width: 16%;">' + applicantPrimary.Contact_Name__r.Name + '</td><td style="width: 16%;">Stamped PF</td><td style="width: 16%;">' + feesMortgage.Stamped_PF__c + '</td></tr><tr><td style="width: 16%;">Stamped insurance </td><td style="width: 16%;">' + feesMortgage.Stamped_insurance__c + '</td><td style="width: 16%;">Requested  Insurance </td><td style="width: 16%;">' + feesMortgage.Requested_Insurance__c + '</td><td style="width: 16%;">Insurance GI </td><td style="width: 16%;">' + feesMortgage.Requested_Insurance__c + '</td></tr><tr><td style="width: 16%;">Insurance LI </td><td style="width: 16%;">' + feesMortgage.Insurance_LI__c + '</td><td style="width: 16%;">Insurance Type</td><td style="width: 16%;">' + feesMortgage.AWB_number__c + '</td><td style="width: 16%;">Insurance Term</td><td style="width: 16%;">' + feesMortgage.Insurance_Term__c + '</td></tr><tr><td style="width: 16%;">Property Dossier</td><td style="width: 16%;">' + applicantPrimary.Property_Dossier_Report__c + '</td><td style="width: 16%;">FFR</td><td style="width: 16%;">' + feesMortgage.FFR__c + '</td><td style="width: 16%;">ELC/REMI Card </td><td style="width: 16%;">' + Loan.ELC_offer_accepted__c + '</td></tr><tr><td style="width: 16%;">VAS 4</td><td style="width: 16%;">' + feesMortgage.VAS4__c + '</td><td style="width: 16%;">MOF waiver </td><td style="width: 16%;">' + feesMortgage.Insurance_LI__c + '</td><td style="width: 16%;">VAS 5</td><td style="width: 16%;">' + feesMortgage.VAS5__c + '</td></tr><tr><td style="width: 16%;">Overall WtIIR</td><td style="width: 16%;">' + feesMortgage.Cheque_Number__c + '</td><td style="width: 16%;">Channel Type </td><td style="width: 16%;">' + Loan.Sourcing_Channel_Type__c + '</td><td style="width: 16%;">Mortgage Plus loan amount </td><td style="width: 16%;">' + feesMortgage.Paid_Amount__c + '</td></tr><tr><td style="width: 16%;">Mortgage plus ROI </td><td style="width: 16%;">' + feesMortgage.Mortgage_plus_ROI__c + '</td><td style="width: 16%;">Mortgage Plus PF </td><td style="width: 16%;">' + feesMortgage.Deposit_Slip_Number__c + '</td><td style="width: 16%;">Disbusemnet mode </td><td style="width: 16%;">' + Loan.Disbursement_Type__c + '</td></tr><tr>  <td style="width: 16%;">CF/PF/Lock in FEE in Rs.</td><td style="width: 16%;">' + feesMortgage.Instrument_No__c + '</td><td style="width: 16%;">Requested Payout</td><td style="width: 16%;">' + feesMortgage.Requested_Payout__c + '</td><td style="width: 16%;">Total loan amount (including insurance amount and PD)</td><td style="width: 16%;">' + Loan.Loan_Amount_with_Premium__c + '</td></tr><tr><td style="width: 16%;">BT-Top Disbursement together</td><td style="width: 16%;">' + feesMortgage.BT_Top_Disbursement_together__c + '</td><td style="width: 16%;">AMC Charges</td><td style="width: 16%;">' + feesMortgage.Payment_Status__c + '</td><td style="width: 16%;">AMC %</td><td style="width: 16%;">' + Loan.AMC__c + '</td></tr><tr><td style="width: 16%;">Foreclosuer charges</td><td style="width: 16%;">' + feesMortgage.Foreclosuer_charges__c + '</td><td style="width: 16%;">Interest bearing letter</td><td style="width: 16%;">' + feesMortgage.Interest_bearing_letter__c + '</td><td style="width: 16%;">Special Remarks</td><td style="width: 16%;">' + feesMortgage.RETURN_REASON__c + '</td></tr><tr><td style="width: 16%;">Part-payment charges</td><td style="width: 16%;">' + feesMortgage.Part_payment_charges__c + '</td><td style="width: 16%;">SM/ASM Name</td><td style="width: 16%;">' + feesMortgage.SM_ASM_Name__c + '</td><td style="width: 16%;">Special Recommendation</td><td style="width: 16%;">' + feesMortgage.TxnReferenceNo__c + '</td></tr></table>';


    body = body.replaceAll('\r\n', '<br/>');
    body = body.replaceAll('\n', '<br/>');
    //body = body.replaceAll('\'','"');
    body = body.replace('\\', '&#92;');
    body = body.replace('"', '\\"');


    String subject = 'Commercial Approval Details LAN No: ' + loan.Loan_Application_Number__c + ' Submitted for Approval';
    String[] SubWords = subject.split(' ');
    system.debug('body ' + body);
    String replyTo = 'deviationaction@1me8tlcb9shodbk998kdxf6nh.p-faieaa.cs31.apex.sandbox.salesforce.com';
    //Rate Approval start
    String email_from = 'noreply@bajajfinserv.in';
    if (rateFlag) {
     subject = 'Rate approval for ' + applicantPrimary.Contact_Name__r.name + ' Approved Loan Amount ' + Loan.Approved_Loan_Amount__c + ' LAN No: ' + Loan.Loan_Application_Number__c;
     email_from = 'pricingrateapproval@bajajfinserv.in';
     replyTo = ProductSMS__c.getValues('RateApp').EmailReplyTo__c;

    }
    //Rate Approval end
    BAFL_EmailServicesLogix.EmailServicesPort stub = new BAFL_EmailServicesLogix.EmailServicesPort();
    BAFL_EmailServicesLogix.SendEmailResponse er = stub.SendEmail(email_from,
     replyTo,
     toAdd,
     ccArray,
     bccArray,
     'Normal',
     new BAFL_EmailServicesLogix.Attachment[] {},
     subject,
     body,
     'bajaj');
    //Rate Approval Start
    applicantPrimary.mail_to_Sales_Hierarchy__c = true;
    update applicantPrimary;
    //Rate Approval end

   }
   string messagetodispaly = 'Pricing mail is sent sucessfully to selected hirarchy ' + name1 + '(' + emailId + ')';
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, messagetodispaly));
  } catch (Exception e) {
   System.debug(e.getMessage() + 'Line number===>' + e.getLineNumber());
  }
 }

 public void referforapproval() {
  System.debug('Sales Officer Emal ID : ' + StrAppr);
  ApexPages.getMessages().clear();

  //StrAppr
  User userObj = new User();
  List < User > userlist = [select email, id, profileId, Profile.Name from User where name =: StrAppr AND IsActive = true limit 1];
  /*String constMessage = 'Dear Sir/Madam'+'\n'+'\n'+'Credit officer Approved Pricing Details -'+'\n'+'\n'+'Credit Officer Approved Loan Amount : ' + Loan.Approved_Loan_Amount__c + '\n'+ 'Credit Officer Approved Tenor : '+ Loan.Approved_Tenor__c + '\n' + 'Credit Officer Approved ROI : '+Loan.Approved_Rate__c+'\n'+
          +'Sales officer Approved Pricing Details -'+'\n'+'\n'+'Sales Officer Approved ROI : '+salesApprovedRate+'\n'+'Sales Officer Approved Processing Fee : '+salesApprovedPF+ '\n'+ '\n'+'\n'+'**** Please Review and Approve/Reject Pricing Details ****'+ '\n'+'\n';
   */
  String body = '<b>Dear Sir/Mam</b><br/><br/>';
  body += '<div style=\\"margin-left:25px;\\">Loan Application(' + Loan.Loan_Application_Number__c + ') has been sent for your Pricing Details Approval. Please find Pricing Details below.</div><br/>';
  body += '<table width=\\"700\\" border=\\"1\\" cellpadding=\\"0\\" cellspacing=\\"0\\" style=\\"border:1px #949494 solid\\" align=\\"center\\">';
  body += '<tr><td><b>Credit Officer Approved Loan Amount - </b></td><td>';

  if (Loan.Approved_Loan_Amount__c != null)
   body += Loan.Approved_Loan_Amount__c;
  body += '</td></tr><tr><td><b>Credit Officer Approved Tenor         - </b></td><td>';
  if (Loan.Approved_Tenor__c != null)
   body += Loan.Approved_Tenor__c;
  body += '</td></tr><tr><td><b>Credit Officer Approved ROI            - </b></td><td>';
  if (Loan.Approved_Rate__c != null)
   body += Loan.Approved_Rate__c;
  body += '</td></tr><tr><td><b>Sales Officer Approved ROI             - </b></td><td>';
  if (salesApprovedRate != null)
   body += salesApprovedRate;
  body += '</td></tr><tr><td><b>Sales Officer Approved Processing Fee  - </b></td><td>';
  if (salesApprovedPF != null)
   body += salesApprovedPF;
  body += '</td></tr></table><br/>';
  body += '<div style=\\"margin-left:25px;\\">Please Review and Approve/Reject Pricing Details</div>';
  String emailAddr;
  if (userlist.size() > 0) {
   emailAddr = userlist[0].email;
  }

  String[] toAddresses = new String[] {
   emailAddr
  };
  String[] ccArray;
  String[] bccArray;

  //  SOLsendEmail.LogixEmailForDG(toAddresses,'Loan : '+Loan.Name+'('+Loan.Loan_Application_Number__c+')-Require Approval for Pricing Details',body);

  BAFL_EmailServicesLogix.EmailServicesPort stub = new BAFL_EmailServicesLogix.EmailServicesPort();
  stub.timeout_x = 120000;

  BAFL_EmailServicesLogix.SendEmailResponse er = stub.SendEmail('noreply@bajajfinserv.in',
   'noreply@bajajfinserv.in',
   toAddresses,
   ccArray,
   bccArray,
   'Normal',
   new BAFL_EmailServicesLogix.Attachment[] {},
   Loan.Name + '(' + Loan.Loan_Application_Number__c + ')-Require Approval for Pricing Details',
   body,
   'bajaj');

  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email Notification sent successfully. '));


  if (userlist.size() > 0) {
   userObj = userlist[0];
   Loan.OwnerId = userObj.id;
   Loan.Approver__c = userObj.Profile.Name;
   update Loan;
  }

 }



 public Pagereference SelectOPCreditOfficer() {
  // showOPApprovePanel = true;
   //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement start
  if(Grouptype=='professional' && loan.product__c=='PRO' || loan.product__c=='DOCTORS')
      {
      if(Label.ValidationOnSubmitToBranchOps=='true')
    {
  
      if (applicantPrimary != null && ((applicantPrimary.IP_Address_Timestamp__c == null) || (applicantPrimary.IP_Address_Timestamp__c != null && applicantPrimary.IP_Address_Timestamp__c == 'Acceptance Pending') || (applicantPrimary.Customer_Decline_Reasons__c != null && applicantPrimary.Customer_Decline_Reasons__c.contains(',')))) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Submit to branch Ops will be not allowed until customer accept consent'));
     return null;
          }
         
    }
    
      }
      //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement end
  if (Grouptype == 'salaried') {
   /* 16165 SALPL commercial consent start*/
   //gopika added
   String liveDateStr = Label.live_date;
   system.debug('date is: ' + liveDateStr);
   system.debug('Loan.CreatedDate: ' + Loan.CreatedDate);
   if (Loan.CreatedDate > datetime.valueof(liveDateStr)) {
    if ((callCenterProcessFlag == true || Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL') && salLineFlag == false && autoTopUp == false || cibilWatch == true) //changed cibilWatch from false to true  for bug id 20296
    {
     if (applicantPrimary != null && ((applicantPrimary.IP_Address_Timestamp__c == null) || (applicantPrimary.IP_Address_Timestamp__c != null && applicantPrimary.IP_Address_Timestamp__c == 'Acceptance Pending') || (applicantPrimary.Customer_Decline_Reasons__c != null && applicantPrimary.Customer_Decline_Reasons__c.contains(',')))) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Submit to branch Ops will be not allowed until customer accept consent'));
      return null;
     }
    }
   } //gopika for salpl commercial end
   /*16165 SALPL commercial consent end*/
   //Rate Approval start
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
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Send mail to Sales Hierarchy is Mandatory! Proposed Rate is below the system prescribed rate. Please take necessary approvals before proceeding'));
     return null;
    }
   }
   //Rate Approval end
   //code added by Suraj-pricing email enhancement-start
   transient String productforCommercialMail = LaonApplicationCreation__c.getValues('sendPricingEmailSelfEmployed').Products__c;
   transient set < String > ProductsforCommercialMail;
   if (productforCommercialMail != null)
    ProductsforCommercialMail = new Set < String > (productforCommercialMail.split(';'));
   if (ProductsforCommercialMail.contains(Loan.product__c)) {
    sendCommercialMailSelfemployed = true;
   }
   //code added by Suraj-pricing email enhancement-end
   if (loan.product__c != 'SHL' && loan.product__c != 'HFC SHL') {

    //SHOL differential journey ---- START
    if (loan.product__c == 'SHOL' || loan.product__c == 'SOL') {
     Loan.stageName = 'Branch Ops';
     Loan.Sales_Submit_to_Branch_Ops_Date__c = System.now();
     Loan.Approver__c = 'CPA Login Partner';
     Loan.ownerId = Loan.CPA__C;

     update Loan;

     Pagereference p = new pagereference('/006/o');
     p.setRedirect(true);
     return p;

    }
    //SHOL differential journey ---- END
    showOPApprovePanel = true; //adhoc changes for pricing 
   } else if (loan.product__c == 'SHL' || loan.product__c == 'HFC SHL') { //SHL Mortgage changes
    showOPApprovePanel = true;

   }

  } else {
   showOPApprovePanel = true;
  }
  return null;
 }
 public boolean showsendback {
  get;
  set;
 }
 public void showSendBack() {
  showsendback = true;
 }
 public PageReference SendBack() {
  /* if(Loan!=null){
  List<User> userList= new List<User>();
  if(Loan.Relationship_Manager__c!=null)
      userList = [SELECT FirstName,Profile.Name FROM User WHERE Id=:Loan.Relationship_Manager__c];
  if(userList!=null && userList.size()>0){
      system.debug('****Loan.createdById*'+userList);
      Loan.ownerId =   userList[0].id;
      Loan.approver__c = 'Area Sales Manager';
      Loan.stageName = 'Post Approval Sales';  
      update loan;
  }

  }*/
  try {
   //Opportunity Loan = LoanDetails_AC_Helper.sendBackStage(Loan);

   /* Bug 15422 - Auto Approval - Loan Against Insurance_Revised Start */
      boolean fasSourcingChannelFlag = getisFASSourcingChannel(); //Bug 22987 - FAS sourcing channel changes
   if (Loan != null && Loan.Sourcing_Channel__c != null && Loan.Sourcing_Channel__r.Name != null && String.isNotBlank(Loan.Sourcing_Channel__r.Name) && fasSourcingChannelFlag && Loan.StageName != null && Loan.StageName == 'Branch Ops' && Loan.Product__c != null && Loan.Product__c == 'FAS') { //Bug 22987 - FAS sourcing channel changes : Loan.Sourcing_Channel__r.Name == 'LAIP'

    if (Loan.ACM__c != null) {
     Loan.Approval_Stages__c = 'Sent Back';
     Loan.StageName = 'Underwriting';
     Loan.OwnerId = Loan.ACM__r.Id;
     Loan.Approver__c = 'Area Credit Manager';
    } else {
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Cannot perform Send Back as, Area Credit Manager for Loan Application is empty.'));
     return null;
    }
   } else {
    Opportunity Loan = LoanDetails_AC_Helper.sendBackStage(Loan);
   }
   /* Bug 15422 - Auto Approval - Loan Against Insurance_Revised End */

   update Loan;

   // Start of general communication framework
   List < Opportunity > LoanList = new List < Opportunity > ();
   LoanList.add(Loan);
   if (Mortgageflag) {
    system.debug('Sending return to sales SMS to Customer and Sales');
    GeneralCommunicationHandler.sendSMS(LoanList, 'Sales Return-Cust');
    GeneralCommunicationHandler.sendSMS(LoanList, 'Sales Return-Int');

    system.debug('Sending return to sales Email to Customer and Sales');
    GeneralCommunicationHandler.sendEmail(LoanList, 'Sales Return-Cust');
    GeneralCommunicationHandler.sendEmail(LoanList, 'Sales Return-Int');
   } //Send sms and email to internal users after loan is sent back to sales team when product = FAS//YK
   else if (Loan.Product__c != null && Loan.Product__c == 'FAS') {
    GeneralCommunicationHandler.sendSMS(LoanList, 'Queries By Branch Ops-Int');
    GeneralCommunicationHandler.sendEmail(LoanList, 'Queries By Branch Ops-Int');
   }
   // End of general communication framework  

   Pagereference p = new pagereference('/' + Loan.Id);
   return p;
  } catch (Exception e) {
   Apexpages.addMessages(e);
   return null;
  }

 }
 public PageReference cancelback() {
  showsendback = false;
  return null;
 }
 //Mortgage Re-Engg Change 23 Nov Start 
 public PageReference SubmitToACM() {

  if (Loan.ACM__c != null) {

   loan.ownerId = Loan.ACM__c;
   loan.Approver__c = 'Area Credit Manager';
   loan.StageName = 'Approved';

   RecordType recordtype_ACM = [SELECT id FROM RecordType WHERE Name = 'ACM'];
   loan.RecordTypeId = recordtype_ACM.id; //15856 Changes for PRO 

   update loan;
   PageReference p = new PageReference('/006');
   p.setRedirect(true);
   return p;
  } else if (Loan.CM__c != null) { // Bug id : 13016 - New Role Creation for Credit, added by Needhi
   loan.ownerId = Loan.CM__c;
   loan.Approver__c = 'Credit Manager';
   loan.StageName = 'Approved';
   update loan;
   PageReference p = new PageReference('/006');
   p.setRedirect(true);
   return p;
  } else {
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ACM is not present in Loan Application !!!'));
   savedSuccessfull = false;
   message = '';
   return null;
  }

 }
 //Mortgage Re-Engg Change 23 Nov End
 public Pagereference SendBackFunctionality() {
  try {
   Opportunity Loan = LoanDetails_AC_Helper.sendBackStage(Loan);
   update Loan;

   Pagereference p = new pagereference('/' + Loan.Id);

   // Start of general communication framework
   if (Mortgageflag) {
    List < Opportunity > LoanList = new List < Opportunity > ();
    LoanList.add(Loan);
    system.debug('Sending return to sales SMS to Customer and Sales');
    GeneralCommunicationHandler.sendSMS(LoanList, 'Sales Return-Cust');
    GeneralCommunicationHandler.sendSMS(LoanList, 'Sales Return-Int');

    system.debug('Sending return to sales Email to Customer and Sales');
    GeneralCommunicationHandler.sendEmail(LoanList, 'Sales Return-Cust');
    GeneralCommunicationHandler.sendEmail(LoanList, 'Sales Return-Int');
   }
   // End of general communication framework
   mobilitystatus = 'Success'; //17556
   return p;
  } catch (Exception e) {
   // 17556 s
   if (salmobilityflagv2 == true)
    mobilitystatus = 'Failed to send back';
   else
    Apexpages.addMessages(e);

   // 17556 e
   return null;
  }
 }

 public void back() {
  showback = true;
 }
 public PageReference hold() {
  showsubhold = true;
  return null;

 }
 public PageReference conthold() {
  try {
   String referal = LOan.Referral__c;
   if (referal == 'None') {
    Loan.Referral__c = null;
   }
   Loan.stagename = 'Hold';
   update Loan;
   showsave = false;
   Pagereference p = new pagereference('/' + Loan.Id);
   system.debug('xxxxxxxxxxx' + Loan.stagename);
   return p;

  } catch (Exception e) {
   Apexpages.addMessages(e);
   System.debug('****Exception: ' + e.getMessage());
   savedSuccessfull = true;
   message = e.getMessage() + '  ' + e.getLineNumber() + '  ' + e.getCause() + '  ' + e.getTypeName();
   if (!Test.isRunningTest()) {
    SendExceptionMail(message, 'Exception came in MidOffice flow (Eligibility)');
   }
   return null;
  }
 }
 public PageReference cancelhold() {
  showsubhold = false;
  return null;
 }
 public PageReference UnHold() {
  try {
   String referal = LOan.Referral__c;
   if (referal == 'None') {
    Loan.Referral__c = null;
   }
   Loan.UnHold__c = true;
   update Loan;
   Pagereference p = new pagereference('/' + Loan.Id);
   return p;
  } catch (Exception e) {
   Apexpages.addMessages(e);
   System.debug('****Exception: ' + e.getMessage());
   savedSuccessfull = true;
   message = e.getMessage() + '  ' + e.getLineNumber() + '  ' + e.getCause() + '  ' + e.getTypeName();
   if (!Test.isRunningTest()) {
    SendExceptionMail(message, 'Exception came in MidOffice flow');
   }

   return null;
  }
 }

 //Sending email for Pending discre
 public PageReference SendEmailPending() {
  /* Loan.Discrepancy_Pending__c=1;
String referal=LOan.Referral__c;
    if(referal=='None'){
Loan.Referral__c=null;
}
update Loan;
sendMssg=true;*/
  //Code for sending sms
  integer flag = 0;
  String ph;
  discrepancysend = new List < Discrepancy__c > ();
  discrepancysend = [Select Discrepancy_Type__c, Status__c, Discrepancy_Category__c from Discrepancy__c where LoanApplication__c =: Loan.id and Status__c = 'Pending'
   and Discrepancy_Category__c = ''
  ];
  system.debug('inside SendEmailPending---' + discrepancysend);
  system.debug('inside Loan Name---' + Loan.Name);
  if (discrepancysend.size() > 0) {

   Loan.Discrepancy_Pending__c = 1;
   Loan.Pending_Login_Discrepancy__c = discrepancysend.size();
   String referal = LOan.Referral__c;
   if (referal == 'None') {
    Loan.Referral__c = null;
   }
   update Loan;
   sendMssg = true;
   for (integer i = 0; i < discrepancysend.size(); i++) {
    if (discrepancysend[i].Discrepancy_Type__c == 'DOCUMENT') {
     flag = 1;
    }
   }
   if (flag == 1 && isNewProductFlowEnabled == false) {
    try {
     /*Responsys Dynamic Parameters Bug 15653 s*/
     List < Opportunity > loanList = new List < Opportunity > ();
     loanList.add(Loan);
     List < Applicant__c > appList = new List < Applicant__c > ();
     appList.add(applicantPrimary);
     GeneralCommunicationHandler.sendSMS(loanList, applicantList, 'Pending Discrepancies-Cust');
     GeneralCommunicationHandler.sendSMS(loanList, appList, 'Pending Discrepancies-Pri');
     /*Responsys Dynamic Parameters Bug 15653 e*/
    } // end of try
    catch (Exception e) {} // end of catch
   } //end of  if(flag==1){
   if (flag == 0 && isNewProductFlowEnabled == false) {
    /*Responsys Dynamic Parameters Bug 15653 s*/
    List < Opportunity > loanList = new List < Opportunity > ();
    loanList.add(Loan);
    GeneralCommunicationHandler.sendSMS(loanList, 'Pending Discrepancies-Int');
    /*Responsys Dynamic Parameters Bug 15653 e*/
   }

  }

  //end of code for sending sms
  return null;

 }

 // Added for disbursement 
 //Sending email for Pending discre
 public PageReference SendEmailPendingDis() {
  /* Loan.Discrepancy_Pending__c=1;
String referal=LOan.Referral__c;
    if(referal=='None'){
Loan.Referral__c=null;
    }
update Loan;
sendMssg=true;*/
  //Code for sending sms
  integer flag = 0;
  String ph;
  discrepancysendDis = [Select Discrepancy_Type__c from
   Discrepancy__c where LoanApplication__c =: Loan.Id and Status__c = 'Pending'
   and Discrepancy_Category__c = 'Disbursement'
  ];
  if (discrepancysendDis.size() > 0) {

   Loan.Discrepancy_Pending__c = 3; //previous value 1
   Loan.Pending_Disbursement_Discrepancy__c = discrepancysendDis.size();
   String referal = LOan.Referral__c;
   if (referal == 'None') {
    Loan.Referral__c = null;
   }
   update Loan;
   sendMssgDis = true;
   for (integer i = 0; i < discrepancysendDis.size(); i++) {
    if (discrepancysendDis[i].Discrepancy_Type__c == 'DOCUMENT') {
     flag = 1;
    }
   }
   if (flag == 1 && isNewProductFlowEnabled == false) {
    try {
     /*Responsys Dynamic Parameters Bug 15653 s*/
     List < Opportunity > loanList = new List < Opportunity > ();
     loanList.add(Loan);
     List < Applicant__c > appList = new List < Applicant__c > ();
     appList.add(applicantPrimary);
     GeneralCommunicationHandler.sendSMS(loanList, applicantList, 'Pending Discrepancies-Cust');
     GeneralCommunicationHandler.sendSMS(loanList, appList, 'Pending Discrepancies-Pri');
     /*Responsys Dynamic Parameters Bug 15653 e*/
    } // end of try
    catch (Exception e) {} // end of catch
   } //end of  if(flag==1){
   if (flag == 0 && isNewProductFlowEnabled == false) {
    /*Responsys Dynamic Parameters Bug 15653 s*/
    List < Opportunity > loanList = new List < Opportunity > ();
    loanList.add(Loan);
    GeneralCommunicationHandler.sendSMS(loanList, 'Pending Discrepancies-Int');
    /*Responsys Dynamic Parameters Bug 15653 e*/
   }

  }

  //end of code for sending sms
  return null;

 }
 //end

 //Sending email for All discrepancy
 public PageReference SendEmailAll() {
  Loan.Discrepancy_Pending__c = 2;
  String referal = LOan.Referral__c;
  if (referal == 'None') {
   Loan.Referral__c = null;
  }
  update Loan;
  /*Cash in 60 mins  Mode_of_Disbursal__c, Bank_Name__c, Account_Holder_Name__c,First_Due_Date__c, Repayment_Mode__c, Repayment_Bank_Name__c, Bank_A_c_No_of_Customer__c, Repayment_Account_Holder_Name__c,A_C_Type__c, MICR_Number__c,Scheme_Master__r.flexi_flag__c, Account.Mobile__c,Flexi_Customer_A_C_Number__c, Account.Date_of_Birth__c,
Account.Accountant_email_id__c,A_C_No__c,Account_Holder_Name__c ,A_C_Type__c,Account.Year_of_Incorporation__c,*/
  //Rate Approval Scheme_Master__r.flexi_flag__c, Scheme_Master__r.PLOC_scheme__c,
  //13793-15554 added Loan_Variant__c
  Loan = [select /*Bug Id - 22425 */ Account.Process_Flow__c, /* Bug 19193 Start*/ Scheme_Master__r.istopup__c, /* Bug 19193 End*/ /*17556 s*/ Area_SM__r.Email /*17556 e*/ , /* SAL Mobility Addition CR - Aman Porwal - S*/ Account.Flow__c, /* SAL Mobility Addition CR - Aman Porwal - E*/ id, /*SAl Interest Subvention Rohit S bug id 12941*/ Account.Interest_Subvention_Applicable__c, /*SAl Interest Subvention Rohit E bug id 12941*/ Scheme_Master__r.PLOC_scheme__c, Loan_Variant__c, Account.Name, Relationship_Manager__r.Email, Sourcing_Channel__r.sourcing_channel_email_id__c, ACM__r.Email, Sourcing_channel_email_id__c, Account.Current_Email_Id__c, Loan_Amount__c, Due_Day__c, Scheme_Master__r.Scheme_Code__c, Mode_of_Disbursal__c, First_Due_Date__c, Repayment_Mode__c, Repayment_Bank_Name__c, Repayment_Account_Holder_Name__c, Scheme_Master__r.flexi_flag__c, Flexi_Customer_A_C_Number__c, Account.Date_of_Birth__c,
   Account.Accountant_email_id__c, A_C_No__c, Account_Holder_Name__c, A_C_Type__c, Account.Year_of_Incorporation__c, Loan_Amount_with_Premium__c, Reject_Reason__c, Sales_Backend__c, name, Risk_Deviations__c, CRO_Deviations__c, CPA__c, ACM__c, RCM__c, NCM__c, CRO__c, RISK__c, COO__c, ACM_Comments__c, RCM_Comments__c, COO_Comments__c,
   Approval_Stages__c, Approver__c, Loan_Application_Number__c, Product__c, Loan_Type__c, Relationship_Manager__c, AccountId, CreatedDate,
   OwnerId, CreatedById, Scheme_Master__c, Industry__c, Credit_Program__c,
   Sub_Industry__c, Existing_Customer__c, Finance_Amount__c, Tenor__c,
   Type_Of_Loan__c, amount, Employee_Type__c, stagename, Probability,
   ForecastCategoryName, File_Acceptance__c, Discrepancy_Status__c,
   Type_of_Constitution__c, Application_Form_Number__c,
   Branch_Name__r.name, Sourc_Mobile__c,
   ASM_Mobile__c, Sales_Backend_Mobile__c, Verification_Initiated__c, Referral__c, Sourcing_Channel__c,
   Current_UserRole__C, Comments__c,
   Amount_Rs__C, Instrument_No__c, Bank_Name__c, Dated__c,
   NameRef1__C,
   NameRef2__C, Address_Line1Ref1__c, Address_Line1Ref2__c, Address_Line2Ref1__c,
   Address_Line2Ref2__c, Address_Line3Ref1__c,
   Address_Line3Ref2__C, CityRef1__c,
   CityRef2__C, OccupationRef1__C,
   OccupationRef2__C, Pin_CodeRef1__c, Pin_CodeRef2__C,
   Office_PhoneRef1__C, Office_PhoneRef2__c, /*Office_MobileRef1__C,*/ Office_MobileRef2__c,
   No_Of_Years_KnownRef1__c, No_Of_Years_KnownRef2__c,
   RelationshipRef1__c, RelationshipRef2__C, No_of_Properties__c,
   Nominee_Name__c, Nominee_AddressLine1__C, Nominee_AddressLine2__c,
   Nominee_AddressLine3__c, Nominee_PinCode__c, Nominee_City__c, Quality_Check_Status__c,
   STD_Code__C, Nominee_Phone__c, Nominee_Relationship__c, Total_TAT__c, MOF_Waiver_Details__c,
   Processing_Fee_Status__C, Instument_Type__c, Customer_email_id__c, Loan_amt_with_premium__c,
   Insurance_Company__C, Premium_Amount__C, Sum_Assured__c, Accountant_email_id__c, DSA_Sharing__c,
   Remark__C, Customer_Type__c, Reject_Reason_1__c, Relationship_Manager__r.Phone, Employee_No_of_ACM__c,
   DF_Type__c, Favouring__c, DF_City__c, IFSC_Code__c, MICR_Number__c, MonthlyBonus__c,
   Processing_Fees__c, LAN__c, CampaignId, If_Yes__c, Disbursement_Type__c, Created_Time__c, QDP__c, Approved_Loan_Amount__c, Approved_Tenor__c, Approved_Rate__c, ASM_email_id__c,
   FAS_Processing_Fee_Amt__c, End_Use__c, Sanction_Validity_Date__c, Nature_of_Business__c, Bank_A_c_No_of_Customer__c, Region__c, CL_Region__c, Account.Mobile__c, Net_Loan_to_POS__c,
   CM__c, CM_Amount__c, CM_Deviations__c, SCO__c, SCO_Amount__c, SCO_Deviations__c, CM__r.Mobile_number__c, SCO__r.Mobile_number__c, CM__r.name, SCO__r.name /*Bug id : 13016 - New Role Creation for Credit, added by Needhi*/
   /*Added BY Ankush Bug 14128 Start  22141 */
   , (select id, Level_of_Activity__c, Customer_Bank_Acc_Confirmation__c, Customer_Bank_Acc_Confirmation_IP__c, Verification_Type__c, Status__c from Verification__r) /*Added BY Ankush Bug 14128 End*/
   /* Bug 15422 - Auto Approval - Loan Against Insurance_Revised Start */
   , Sourcing_Channel__r.Name /* Bug 15422 - Auto Approval - Loan Against Insurance_Revised Start */
   /*Bug 16173 - VRPL changes for HFC Strat*/
   , Scheme_Master__r.VRPL_Flag__c /*Bug 16173 - VRPL changes for HFC End*/
   from Opportunity where id =: Loan.Id
  ];
  sendMssg = true;
  discrepancysend = [Select Discrepancy_Type__c from
   Discrepancy__c where LoanApplication__c =: Loan.Id
  ];
  //Code for sending sms
  integer flag = 0;
  String ph;
  String mess = 'Dear Customer , Certain document related discrepancies have been raised on your Loan Application ' + Loan.Name + '. Please contact your salesrepresentative and close the issues for speedy processing of your loan';
  if (discrepancysend.size() > 0) {

   for (integer i = 0; i < discrepancysend.size(); i++) {
    if (discrepancysend[i].Discrepancy_Type__c == 'DOCUMENT') {
     flag = 1;
    }
   }
   if (flag == 1 && isNewProductFlowEnabled == false) {
    try {
     /*Responsys Dynamic Parameters Bug 15653 s*/
     List < Opportunity > loanList = new List < Opportunity > ();
     loanList.add(Loan);
     List < Applicant__c > appList = new List < Applicant__c > ();
     appList.add(applicantPrimary);
     GeneralCommunicationHandler.sendSMS(loanList, applicantList, 'Resolved Discrepancies-Cust');
     GeneralCommunicationHandler.sendSMS(loanList, appList, 'Resolved Discrepancies-Pri');
     /*Responsys Dynamic Parameters Bug 15653 e*/
    } // end of try
    catch (Exception e) {} // end of catch
   } //end of  if(flag==1){
   if (flag == 0 && isNewProductFlowEnabled == false) {
    /*Responsys Dynamic Parameters Bug 15653 s*/
    List < Opportunity > loanList = new List < Opportunity > ();
    loanList.add(Loan);
    GeneralCommunicationHandler.sendSMS(loanList, 'Resolved Discrepancies-Int');
    /*Responsys Dynamic Parameters Bug 15653 e*/
   }
  }
  //end of code for sending sms
  return null;


 }

 // Added for disbursement
 //Sending email for All discrepancy
 public PageReference SendEmailAllDis() {
  Loan.Discrepancy_Pending__c = 4; //previous value 2
  String referal = LOan.Referral__c;
  if (referal == 'None') {
   Loan.Referral__c = null;
  }
  update Loan;
  /*Cash in 60 mins Mode_of_Disbursal__c, First_Due_Date__c, Repayment_Mode__c, Repayment_Bank_Name__c, Bank_A_c_No_of_Customer__c, Repayment_Account_Holder_Name__c,A_C_Type__c, MICR_Number__c,Scheme_Master__r.flexi_flag__c, Account.Mobile__c,Flexi_Customer_A_C_Number__c, Account.Date_of_Birth__c,
Account.Accountant_email_id__c,A_C_No__c,Account_Holder_Name__c ,A_C_Type__c,Account.Year_of_Incorporation__c,*/
  //Rate Approval Scheme_Master__r.flexi_flag__c, Scheme_Master__r.PLOC_scheme__c, 
  //13793-15554 added Loan_Variant__c
  Loan = [select /* Bug 19193 Start*/ Scheme_Master__r.istopup__c, /* Bug 19193 End*/ /*17556 s*/ Area_SM__r.Email /*17556 e*/ , /* SAL Mobility Addition CR - Aman Porwal - S*/ Account.Flow__c, /* SAL Mobility Addition CR - Aman Porwal - E*/ id, /*SAl Interest Subvention Rohit S bug id 12941*/ Account.Interest_Subvention_Applicable__c, /*SAl Interest Subvention Rohit E 12941*/ Scheme_Master__r.PLOC_scheme__c, Loan_Variant__c, Account.Name, ACM__r.Email, Relationship_Manager__r.Email, Sourcing_Channel__r.sourcing_channel_email_id__c, Sourcing_channel_email_id__c, Account.Current_Email_Id__c, Loan_Amount__c, Due_Day__c, Scheme_Master__r.Scheme_Code__c, Mode_of_Disbursal__c, First_Due_Date__c, Repayment_Mode__c, Repayment_Bank_Name__c, Repayment_Account_Holder_Name__c, A_C_Type__c, Scheme_Master__r.flexi_flag__c, Flexi_Customer_A_C_Number__c, Account.Date_of_Birth__c,
   Account.Accountant_email_id__c, A_C_No__c, Account_Holder_Name__c, Account.Year_of_Incorporation__c, Loan_Amount_with_Premium__c, Reject_Reason__c, Sales_Backend__c, name, Risk_Deviations__c, CRO_Deviations__c, CPA__c, ACM__c, RCM__c, NCM__c, CRO__c, RISK__c, COO__c, ACM_Comments__c, RCM_Comments__c, COO_Comments__c,
   Approval_Stages__c, Approver__c, Loan_Application_Number__c, Product__c, Loan_Type__c, Relationship_Manager__c, AccountId, CreatedDate,
   OwnerId, CreatedById, Scheme_Master__c, Industry__c, Credit_Program__c,
   Sub_Industry__c, Existing_Customer__c, Finance_Amount__c, Tenor__c,
   Type_Of_Loan__c, amount, Employee_Type__c, stagename, Probability,
   ForecastCategoryName, File_Acceptance__c, Discrepancy_Status__c,
   Type_of_Constitution__c, Application_Form_Number__c, EMI_CAM__c,
   Branch_Name__r.name, Sourc_Mobile__c,
   ASM_Mobile__c, Sales_Backend_Mobile__c, Verification_Initiated__c, Referral__c, Sourcing_Channel__c,
   Current_UserRole__C, Comments__c,
   Amount_Rs__C, Instrument_No__c, Bank_Name__c, Dated__c,
   NameRef1__C,
   NameRef2__C, Address_Line1Ref1__c, Address_Line1Ref2__c, Address_Line2Ref1__c,
   Address_Line2Ref2__c, Address_Line3Ref1__c,
   Address_Line3Ref2__C, CityRef1__c,
   CityRef2__C, OccupationRef1__C,
   OccupationRef2__C, Pin_CodeRef1__c, Pin_CodeRef2__C,
   Office_PhoneRef1__C, Office_PhoneRef2__c, /*Office_MobileRef1__C,*/ Office_MobileRef2__c,
   No_Of_Years_KnownRef1__c, No_Of_Years_KnownRef2__c,
   /*RelationshipRef1__c,*/
   RelationshipRef2__C, No_of_Properties__c,
   Nominee_Name__c, Nominee_AddressLine1__C, Nominee_AddressLine2__c,
   Nominee_AddressLine3__c, Nominee_PinCode__c, Nominee_City__c, Quality_Check_Status__c,
   STD_Code__C, Nominee_Phone__c, Nominee_Relationship__c, Total_TAT__c, MOF_Waiver_Details__c,
   Processing_Fee_Status__C, Instument_Type__c, Customer_email_id__c,
   Insurance_Company__C, Premium_Amount__C, Sum_Assured__c, Accountant_email_id__c, DSA_Sharing__c,
   Remark__C, Customer_Type__c, Reject_Reason_1__c, Relationship_Manager__r.Phone, Employee_No_of_ACM__c,
   DF_Type__c, Favouring__c, DF_City__c, IFSC_Code__c, MICR_Number__c, Loan_amt_with_premium__c,
   Processing_Fees__c, LAN__c, CampaignId, Created_Time__c, MonthlyBonus__c, QDP__c, Approved_Loan_Amount__c, Approved_Tenor__c, Approved_Rate__c, ASM_email_id__c,
   FAS_Processing_Fee_Amt__c, End_Use__c, Sanction_Validity_Date__c, Nature_of_Business__c, Bank_A_c_No_of_Customer__c, Region__c, CL_Region__c, Account.Mobile__c, Net_Loan_to_POS__c,
   CM__c, CM_Amount__c, CM_Deviations__c, SCO__c, SCO_Amount__c, SCO_Deviations__c, CM__r.Mobile_number__c, SCO__r.Mobile_number__c, CM__r.name, SCO__r.name /* Bug id : 13016 - New Role Creation for Credit, added by Needhi*/
   /*Added BY Ankush Bug 14128 Start Bug 22141*/
   , (select id, Level_of_Activity__c, Status__c, Customer_Bank_Acc_Confirmation__c, Customer_Bank_Acc_Confirmation_IP__c, Verification_Type__c from Verification__r) /*Added BY Ankush Bug 14128 End*/
   /* Bug 15422 - Auto Approval - Loan Against Insurance_Revised Start */
   , Sourcing_Channel__r.Name /* Bug 15422 - Auto Approval - Loan Against Insurance_Revised Start */ , Scheme_Master__r.Blind_Data_Entry__c
   /*Bug 16173 - VRPL changes for HFC Strat*/
   , Scheme_Master__r.VRPL_Flag__c /*Bug 16173 - VRPL changes for HFC End*/
   from Opportunity where id =: Loan.Id
  ];
  sendMssgDis = true;
  discrepancysendDis = [Select Discrepancy_Type__c from
   Discrepancy__c where LoanApplication__c =: Loan.Id
  ];
  //Code for sending sms
  integer flag = 0;
  String ph;
  String mess = 'Dear Customer , Certain document related discrepancies have been raised on your Loan Application ' + Loan.Name + '. Please contact your salesrepresentative and close the issues for speedy processing of your loan';
  if (discrepancysendDis.size() > 0) {

   for (integer i = 0; i < discrepancysendDis.size(); i++) {
    if (discrepancysendDis[i].Discrepancy_Type__c == 'DOCUMENT') {
     flag = 1;
    }
   }
   if (flag == 1 && isNewProductFlowEnabled == false) {
    try {
     /*Responsys Dynamic Parameters Bug 15653 s*/
     List < Opportunity > loanList = new List < Opportunity > ();
     loanList.add(Loan);
     List < Applicant__c > appList = new List < Applicant__c > ();
     appList.add(applicantPrimary);
     GeneralCommunicationHandler.sendSMS(loanList, applicantList, 'Resolved Discrepancies-Cust');
     GeneralCommunicationHandler.sendSMS(loanList, appList, 'Resolved Discrepancies-Pri');
     /*Responsys Dynamic Parameters Bug 15653 e*/
    } // end of try
    catch (Exception e) {} // end of catch
   } //end of  if(flag==1){
   if (flag == 0 && isNewProductFlowEnabled == false) {
    /*Responsys Dynamic Parameters Bug 15653 s*/
    List < Opportunity > loanList = new List < Opportunity > ();
    loanList.add(Loan);
    GeneralCommunicationHandler.sendSMS(loanList, 'Resolved Discrepancies-Int');
    /*Responsys Dynamic Parameters Bug 15653 e*/
   }
  }
  //end of code for sending sms
  return null;


 }
 //Send mail functionality for discrepancy
 //code added by Suraj-pricing email enhancement-start
 public void sendPricingEmailSelfEmployed() {
  System.debug('Inside .....sendPricingEmailSelfEmployed');
   //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement start added if else 
      if(Grouptype=='professional' && loan.product__c=='PRO' || loan.product__c=='DOCTORS')
      {
      sendPricingEmailDIPOS();
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Commercial mail sucessfully send to customer......'));
      
      }
       //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement added else
       else
       {
  string templateName = 'PricingemailSelfEmployed_new';
  Id whatId = loan.id;
  string fromName = 'noreply@bajajfinserv.in';
  string replyTo = 'otpofficeemailverification@6hifw8v4ew6qa26r5whiw37rq2yorch4vylpptp0njgfwqxjc.o-51mo2mam.cs5.apex.sandbox.salesforce.com';
  string[] toAddlist = new String[] {};
  string[] toAddlistCC = new String[] {};
  if (loan.Account.Current_Email_Id__c != null) {
   toAddlist.add(Loan.Account.Current_Email_Id__c);
  }
  if (conObj.Office_Email_Id__c != null) {
   toAddlist.add(conObj.Office_Email_Id__c);
  }
  if (loan.Customer_email_id__c != null)
   toAddlist.add(loan.Customer_email_id__c);
  if (loan.Accountant_email_id__c != null)
   toAddlist.add(loan.Accountant_email_id__c);
  if (loan.Relationship_Manager__r.Email != null)
   toAddlistCC.add(loan.Relationship_Manager__r.Email); //added by Suraj Commercial Emailer Enhancement
  System.debug('Inside SendEmail.....sendPricingEmailSelfEmployed toAddlist' + toAddlist);
  string[] bcc;
  String Priority = 'Normal';
  BAFL_EmailServicesLogix.Attachment[] Attachments = new BAFL_EmailServicesLogix.Attachment[] {};
  string Subject = 'Pricing Details LAN No: ' + loan.Loan_Application_Number__c;
  String CostCenter = 'bajaj';
  GeneralUtilities.SendEmailUsingBAFLLogix(templateName, whatId, fromName, replyTo, toAddlist, toAddlistCC, bcc, Priority, Subject, CostCenter);
  if (applicantPrimary != null) {
   System.debug('upsert applicantPrimary.......Start');
   applicantPrimary.Send_pricing_email_to_customer__c = true;
   applicantPrimary.Commercial_Confirmation_Mail_Date__c = System.now();
   update applicantPrimary;
   System.debug('upsert applicantPrimary.......End');
  }
  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Commercial mail sucessfully send to customer......'));
}
 }
 //code added by Suraj-pricing email enhancement-end
 public PageReference sendEmail() {
  integer flag = 0;
  //Code for sending sms
  if (discrepancysend.size() > 0) {
   for (integer i = 0; i < discrepancysend.size(); i++) {
    if (discrepancysend[i].Discrepancy_Type__c == 'DOCUMENT') {
     flag = 1;
    }
   }
   if (flag == 1 && isNewProductFlowEnabled == false) {
    try {
     /*Responsys Dynamic Parameters Bug 15653 s*/
     List < Opportunity > loanList = new List < Opportunity > ();
     loanList.add(Loan);
     List < Applicant__c > appList = new List < Applicant__c > ();
     appList.add(applicantPrimary);
     GeneralCommunicationHandler.sendSMS(loanList, applicantList, 'Discrepancies SMS-Cust');
     GeneralCommunicationHandler.sendSMS(loanList, appList, 'Discrepancies SMS-Pri');
     /*Responsys Dynamic Parameters Bug 15653 e*/
    } // end of try
    catch (Exception e) {} // end of catch
   } //end of  if(flag==1){
   if (flag == 0 && isNewProductFlowEnabled == false) {
    /*Responsys Dynamic Parameters Bug 15653 s*/
    List < Opportunity > loanList = new List < Opportunity > ();
    loanList.add(Loan);
    GeneralCommunicationHandler.sendSMS(loanList, 'Discrepancies SMS-Int');
    /*Responsys Dynamic Parameters Bug 15653 e*/
   }
  }
  //end of code for sending sms
  String referal = LOan.Referral__c;
  if (referal == 'None') {
   Loan.Referral__c = null;
  }
  Loan.New_Discrepancy__c = 1;
  update Loan;
  viewsendEmail = false;
  sendMssg = true;
  return null;
 }
 public Pagereference saveTransactionDocuments() {
  //DeviationsChecklistTrnxList
  //checklistTrnxList
  try {
   List < Checklist__c > checklistTrnxListToUpdate = new List < Checklist__c > ();
   for (DocumentWrapper obj: docWrapperList) {
    System.debug('obj.selectedDoc==' + obj.selectedDoc);
    System.debug('obj.docFamObj.id==' + obj.docFamObj.id);
    System.debug('obj.docFamObj.CPA_Status__c==' + obj.docFamObj.CPA_Status__c);
    System.debug('obj.docFamObj.Sales_Status__c==' + obj.docFamObj.Sales_Status__c);
    System.debug('obj.singleDoc==' + obj.singleDoc);
    if (obj.selectedDoc != null && obj.selectedDoc != '')
     obj.docFamObj.Document__c = obj.selectedDoc;
    else if (obj.singleDoc != null && obj.singleDoc != '')
     obj.docFamObj.Document__c = obj.singleDoc;
    checklistTrnxListToUpdate.add(obj.docFamObj);
   }
   for (DocumentWrapper obj: deviationDocWrapperList) {
    System.debug('obj.selectedDoc==' + obj.selectedDoc);
    System.debug('obj.docFamObj.id==' + obj.docFamObj.id);
    System.debug('obj.docFamObj.CPA_Status__c==' + obj.docFamObj.CPA_Status__c);
    System.debug('obj.docFamObj.Sales_Status__c==' + obj.docFamObj.Sales_Status__c);
    System.debug('obj.singleDoc==' + obj.singleDoc);
    if (obj.selectedDoc != null && obj.selectedDoc != '')
     obj.docFamObj.Document__c = obj.selectedDoc;
    else if (obj.singleDoc != null && obj.singleDoc != '')
     obj.docFamObj.Document__c = obj.singleDoc;
    checklistTrnxListToUpdate.add(obj.docFamObj);
    //obj.showPicklist = false;                 
   }
   System.debug('checklistTrnxListToUpdate==' + checklistTrnxListToUpdate);
   upsert checklistTrnxListToUpdate;
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Status has been saved successfully !!'));
   System.debug('checklistTrnxListToUpdate aftr==' + checklistTrnxListToUpdate);
   // if(checklistTrnxList.size()>0)
   // upsert checklistTrnxList;      
   savedSuccessfull = true;
   message = 'Details Saved Successfully !!!';
  } catch (Exception e) {
   //Apexpages.addMessages(e); 
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e + ''));
  }
  return null;
 }
 public void saveCreditstatus() {
  if (applicantPrimary != null) {
   upsert applicantPrimary;
  }
 }
 public void saveapprovedetails() {
  if (loan != null) {
   /*Hybrid Flexi :akshata Start*/
   System.debug('in method');
   if (applicantPrimary != null && IsHybridFlexi != null && IsHybridFlexi) {
    System.debug('in Loan.Loan_Amount_with_Premium__c ->' + Loan.Loan_Amount_with_Premium__c + 'Loan.Approved_Rate__c -->' + Loan.Approved_Rate__c);
    Double result = 0.0;
    if (Loan.Loan_Amount_with_Premium__c != null && applicantPrimary.Pure_Flexi_Period__c != null && Loan.Approved_Rate__c != null) {
     result = Math.round((Loan.Loan_Amount_with_Premium__c * Loan.Approved_Rate__c) / 1200);
     System.debug('result-->' + result);
    }
    applicantPrimary.Pure_Flexi_EMI__c = result;
    if (Loan.Loan_Amount_with_Premium__c != null && Loan.Approved_Rate__c != null)
     Loan.EMI_CAM__c = (PMT(double.valueOf(Loan.Approved_Rate__c / 1200), Integer.valueOf(applicantPrimary.Drop_Line_Flexi_Period__c), Loan.Loan_Amount_with_Premium__c));

    System.debug('applicantPrimary.Pure_Flexi_EMI__c-->' + applicantPrimary.Pure_Flexi_EMI__c);
    upsert applicantPrimary;

    upsert loan;

   } /*Hybrid Flexi :akshata End*/
   else {
    System.debug('Loan.Loan_Amount_with_Premium__c==' + Loan.Loan_Amount_with_Premium__c + '%%%rate ' + Loan.Approved_Rate__c + '%%%%Tenor' + Loan.Approved_Tenor__c);
    if (Loan.Loan_Amount_with_Premium__c != null && Loan.Approved_Tenor__c != null && Loan.Approved_Rate__c != null)
     Loan.EMI_CAM__c = (PMT(double.valueOf(Loan.Approved_Rate__c / 1200), Integer.valueOf(Loan.Approved_Tenor__c), Loan.Loan_Amount_with_Premium__c));
    // Loan.EMI_CAM__c=decimal.valueof((PMT(double.valueof(Loan.Approved_Rate__c/1200),integer.valueof(Loan.Approved_Tenor__c),double.valueof(LoanPremPlusInsuPre))).divide(1, 0, System.RoundingMode.UP)); 
    upsert loan;
   }


  }
 }
 public double PMT(double rate, integer nper, decimal pv) {
  system.debug('******rate********' + rate + '**nper*' + nper + '*pv**' + pv);
  Double result = 0.0;
  if (pv != null && rate != null && nper != null) {
   result = Math.round((pv * rate) / (1 - Math.pow(1 + rate, -nper)));
   system.debug('****result**' + result);
  }
  return result;
 }
 public void saveAdditionalCharges() {
  // system.debug('****conOb..Stamp_Duty__c**' + conObj.Stamp_Duty__c);
  if (conObj != null)
   upsert conObj;
  savedSuccessfull = true;
  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Charges Details saved successfully.'));
 }
 //End

 public List < SelectOption > getcreditCardList() {
  return optionscreditCardList;
 }
 public List < SelectOption > getloanTypeList() {
  return optionsgetloanTypeList;
 }
 public void addDocRowsDis() {
  String remarks = null;
  if (objchecklistDis.size() > 0) {
   remarks = objchecklistDis[0].docRemarks__c;
   system.debug('rrrrrriii' + objchecklistDis[0].docRemarks__c + objchecklistDis);
  }
  system.debug('rrrrrr' + remarks);
  objchecklisttDis.add(new Checklist__c(Loan_Application__c = Loan.id, docRemarks__c = remarks));
  viewChecklistDis = true;
  add1Dis = true;
  add2Dis = true;
  system.debug('-- add2dis --' + add2Dis);
 }

 public PageReference DeleteRec() {
  objchecklisttoupdateDis = new List < Checklist__c > ();
  for (Checklist__c chk: objchecklistDis) {
   If(chk.Ischecked__c == true && chk.Mandatory__c == false) {
    objchecklisttoupdateDis.add(chk);
   }
  }
  system.debug('objchecklisttoupdateDis : size is ' + objchecklisttoupdateDis.size());
  If(objchecklisttoupdateDis.size() > 0) {
   delete objchecklisttoupdateDis;
  }

  update loan;

  /*BUG-16959 added Prod condition for DBOL  by Rajesh */
  if (isPSBLProductLineProduct || isNewProductFlowEnabled == true || /* 6230 SBS CS PSBL */ Loan.Product__C == 'SBS CS PSBL' || Loan.Product__C == 'DOCTORS') {
   objchecklist = [Select c.Tranche_Detail__c, c.docValidity_Date__c, c.Ischecked__c, c.docTarget_Date__c, c.docRemarks__c, c.docReceived_Date__c, c.Target_Date__c, c.Status__c,
    c.Stages__c, c.Received_Date__c, c.Reason__c, c.RIC_Status__c, c.RIC_Req__c, c.Original__c, c.Name, c.Mandatory__c, c.Id,
    c.DocumentFmlyName__c, c.DocumentFmlyName__r.Name, c.DocStatus__c, c.Sales_Status__c, c.Comments__c, c.Checklist_Parameter__c, c.Property_Document__c,
    c.Applicant__c, c.Applicant__r.Type_of_Borrower__c, c.Applicant__r.Contact_Name__r.name, c.documents__c,
    c.Type_of_Borrower__c, c.Document_Type__c, c.Checklist_type__c, CPA_Status__c,
    c.Type_of_Document__c, c.Approved_by__c, Property_Details__r.Name, c.Branch_Status__c, c.Branch_Remark__c, c.Operation_Status__c, c.Ops_Status__c, c.Ops_Remark__c, c.Date_Auto_Punch1__c, c.Date_Auto_Punch2__c, c.PDD__c, c.OTC__c, OTC_main__c, PDD_main__c,
    c.Ageing__c, c.Document_Sent_to_NAX__c, to_be_approved_by__c, OTPDeferralCategory__c, OTPDeferralDocuments__c,
    c.Deferral_Type__c, c.Expected_Resolution__c, DocStatus1__c, Documents_Type__c, IsCritical__c, IsNonCritical__c, checkfordelete__c, Document_TYPE1__c, DocumentFmlyName__r.Documents__c, PDD_OTC_Received_Date__c, PDD_OTC_Received_Status__c, PDD_OTC_Remarks__c, Property_Documents__c, Deferral_Taken_Date__c, CPA_Deferral_Clearance_Date__c, CPA_Deferral_Status__c, OpsDeferral_Clearance_Date__c, OPS_Deferral_Status__c, Details_of_Defferral_Docs__c
    From Checklist__c c
    where Applicant__r.Loan_Application__c =: Loan.id
   ];
  } else {
   objchecklist = [Select c.Tranche_Detail__c, c.docValidity_Date__c, c.Ischecked__c, c.docTarget_Date__c, c.docRemarks__c, c.docReceived_Date__c, c.Target_Date__c, c.Status__c,
    c.Stages__c, c.Received_Date__c, c.Reason__c, c.RIC_Status__c, c.RIC_Req__c, c.Original__c, c.Name, c.Mandatory__c, c.Id,
    c.DocumentFmlyName__c, c.DocumentFmlyName__r.Name, c.DocStatus__c, c.Sales_Status__c, c.Comments__c, c.Checklist_Parameter__c, c.Property_Document__c,
    c.Applicant__c, c.Applicant__r.Type_of_Borrower__c, c.Applicant__r.Contact_Name__r.name, c.documents__c,
    c.Type_of_Borrower__c, c.Document_Type__c, c.Checklist_type__c, to_be_approved_by__c, CPA_Status__c,
    c.Type_of_Document__c, c.Approved_by__c, c.Branch_Status__c, Property_Details__r.Name, c.Branch_Remark__c, c.Operation_Status__c, c.Ops_Status__c, c.Ops_Remark__c, c.Date_Auto_Punch1__c, c.Date_Auto_Punch2__c, c.PDD__c, c.OTC__c, OTC_main__c, PDD_main__c,
    c.Ageing__c, c.Document_Sent_to_NAX__c, approved_flag__c, OTPDeferralCategory__c, OTPDeferralDocuments__c,
    c.Deferral_Type__c, c.Expected_Resolution__c, DocStatus1__c, Documents_Type__c, checkfordelete__c, IsCritical__c, IsNonCritical__c, Document_TYPE1__c, DocumentFmlyName__r.Documents__c, PDD_OTC_Received_Date__c, PDD_OTC_Received_Status__c, PDD_OTC_Remarks__c, Property_Documents__c, Deferral_Taken_Date__c, CPA_Deferral_Clearance_Date__c, CPA_Deferral_Status__c, OpsDeferral_Clearance_Date__c, OPS_Deferral_Status__c, Details_of_Defferral_Docs__c
    From Checklist__c c
    where Category__C = 'Applicant'
    and Applicant__r.Loan_Application__c =: Loan.id
   ];
  }

  system.debug('--DeleteRec--objchecklist--size()--' + objchecklist.size());
  objchecklistDis = new List < Checklist__c > ();
  for (Checklist__c ocl: objchecklist) {
   if (ocl.Checklist_type__c == 'Disbursement') {
    objchecklistDis.add(ocl);
   }

  }

  return null;
 }

 public PageReference savechecklistDis() {
  sendMssgDoc = false;
  sendMssgDoc1 = false;

  // Disbursement 
  system.debug('objchecklisttDis?*******' + objchecklisttDis);
  if (objchecklisttDis.size() > 0) {
   for (integer i = 0; i < objchecklisttDis.size(); i++) {

    if (objchecklisttDis[i].DocStatus__c == 'Received' || (objchecklisttDis[i].approved_by__c == 'STD OTC' || objchecklisttDis[i].approved_by__c == 'STD PDD' || objchecklisttDis[i].approved_by__c == 'NA')) {
     objchecklisttDis[i].approved_flag__c = true;
    }

    if (objchecklisttDis[i].DocStatus__c == 'Received' && objchecklisttDis[i].Received_Date__c != null) {
     objchecklisttDis[i].Received_Date__c = System.Today();
    }
    if (objchecklisttDis[i].DocStatus__c != 'Received') {
     objchecklisttDis[i].Received_Date__c = null;
    }
    objchecklisttDis[i].Category__C = 'Applicant';
    objchecklisttDis[i].Checklist_type__c = 'Disbursement';

    if (objchecklisttDis[i].OTC__c != objchecklisttDis[i].OTC_main__c || objchecklisttDis[i].PDD__c != objchecklisttDis[i].PDD_main__c) {
     //ERROR MSG
     saveErrMsg = 'Could not save the record for the newly added document family' + '. Please check if the permissible PDD/OPC are selected';
     viewSaveErrMsg = true;
    } else {
     viewSaveErrMsg = false;
    }
   }
  }
  if (objchecklistDis.size() > 0) {
   for (integer k = 0; k < objchecklistDis.size(); k++) {
    if (objchecklistDis[k].DocStatus__c == 'Received' && objchecklistDis[k].Received_Date__c != null) {
     objchecklistDis[k].Received_Date__c = System.Today();
    }
    if (objchecklistDis[k].DocStatus__c != 'Received') {
     objchecklistDis[k].Received_Date__c = null;
    }
    objchecklistDis[k].Type_of_Borrower__c = objchecklistDis[k].Applicant__r.Type_of_Borrower__c;

    if (objchecklistDis[k].OTC__c != objchecklistDis[k].OTC_main__c && objchecklistDis[k].PDD__c != objchecklistDis[k].PDD_main__c) {
     saveErrMsg = 'Could not save the record for document family ' + objchecklistDis[k].DocumentFmlyName__r.Name + '. Please check if the permissible PDD/OPC are selected';
     viewSaveErrMsg = true;
    } else {
     saveErrMsg = 'Could not save the record for document family ' + objchecklistDis[k].DocumentFmlyName__r.Name + '. Please check if the permissible PDD/OPC are selected';
     viewSaveErrMsg = false;
    }
    System.debug('------------*****-----------------***---' + objchecklistDis[k].DocumentFmlyName__r.Name);

   }
   update objchecklistDis;

  }
  double x = 0;

  if (objchecklisttDis.size() > 0) {
   x = 0;
   for (integer i = 0; i < objchecklisttDis.size(); i++) {
    for (integer j = 0; j < objchecklistDis.size(); j++) {
     If((objchecklisttDis[i].Applicant__c == objchecklistDis[j].Applicant__c) && (objchecklisttDis[i].OTPDeferralCategory__c == objchecklistDis[j].OTPDeferralCategory__c) && (objchecklisttDis[i].OTPDeferralDocuments__c == objchecklistDis[j].OTPDeferralDocuments__c)) {
      x = 1;
      system.debug('***********x=1 in 1*******' + objchecklisttDis);
     }
    }
   }
   system.debug('***********in iff *******' + objchecklisttDis);

   If(x == 0) {

    insert objchecklisttDis;
    system.debug('************objchecklisttDis**insertted*********' + objchecklisttDis);

   } else {
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Attempt to add Duplicate record'));

   }
   objchecklisttDis.clear();
  }



  savechecklist();
  add1Dis = false;
  add2Dis = false;
  return null;
 }
 public PageReference savechecklist() {
  /*BUG-16959 added Prod condition for DBOL  by Rajesh */
  if (isPSBLProductLineProduct || isNewProductFlowEnabled == true || /* 6230 SBS CS PSBL */ Loan.Product__C == 'SBS CS PSBL' || Loan.Product__C == 'DOCTORS' || Loan.Product__C == 'RDL') // || DOCProducts.contains(Loan.Product__c.toUppercase())
  {
   objchecklist = [Select c.docValidity_Date__c, c.Tranche_Detail__c,
    c.Ischecked__c,
    c.docTarget_Date__c,
    c.docRemarks__c,
    c.docReceived_Date__c,
    c.Target_Date__c,
    c.Status__c,
    c.Stages__c,
    c.Received_Date__c,
    c.Reason__c,
    c.RIC_Status__c,
    c.RIC_Req__c, c.Original__c,
    c.Name,
    c.Mandatory__c, c.Id,
    c.DocumentFmlyName__c,
    c.DocStatus__c,
    c.Sales_Status__c,
    c.Comments__c,
    c.Checklist_Parameter__c,
    c.Property_Document__c,
    c.Applicant__c,
    c.Applicant__r.Type_of_Borrower__c,
    c.Applicant__r.Contact_Name__r.name,
    c.documents__c,
    c.Type_of_Borrower__c,
    c.Document_Type__c,
    c.Checklist_type__c,
    c.Type_of_Document__c,
    c.Approved_by__c,
    c.Branch_Status__c,
    c.Branch_Remark__c,
    c.Operation_Status__c,
    c.Ops_Status__c,
    c.Ops_Remark__c,
    c.Date_Auto_Punch1__c,
    c.Date_Auto_Punch2__c,
    c.PDD__c,
    c.OTC__c,
    c.OTC_main__c,
    c.PDD_main__c,
    approved_flag__c,
    c.Ageing__c, CPA_Status__c,
    c.Document_Sent_to_NAX__c, OTPDeferralCategory__c, OTPDeferralDocuments__c,
    c.Deferral_Type__c, Property_Details__r.Name, IsCritical__c, DocStatus1__c, Documents_Type__c, IsNonCritical__c, C.Document_TYPE1__c, c.checkfordelete__c, c.Expected_Resolution__c, c.DocumentFmlyName__r.Documents__c, PDD_OTC_Received_Date__c, PDD_OTC_Received_Status__c, PDD_OTC_Remarks__c, DocumentFmlyName__r.Name, Property_Documents__c, Deferral_Taken_Date__c, CPA_Deferral_Clearance_Date__c, CPA_Deferral_Status__c, OpsDeferral_Clearance_Date__c, OPS_Deferral_Status__c, Details_of_Defferral_Docs__c
    From Checklist__c c
    where Applicant__r.Loan_Application__c =: Loan.id
   ];
  } else {
   objchecklist = [Select c.docValidity_Date__c, Tranche_Detail__c, c.Ischecked__c, c.docTarget_Date__c,
    c.docRemarks__c, c.docReceived_Date__c, c.Target_Date__c, c.Status__c,
    c.Stages__c, c.Received_Date__c, c.Reason__c, c.RIC_Status__c, c.RIC_Req__c,
    c.Original__c, c.Name, c.Mandatory__c, c.Id, c.DocumentFmlyName__c, c.DocStatus__c,
    c.Sales_Status__c, c.Comments__c, c.Checklist_Parameter__c, c.Property_Document__c,
    c.Applicant__c, c.Applicant__r.Type_of_Borrower__c, c.Applicant__r.Contact_Name__r.name,
    c.documents__c, c.Type_of_Borrower__c, c.Document_Type__c, c.Checklist_type__c,
    c.Type_of_Document__c, c.Approved_by__c, c.Branch_Status__c, c.Branch_Remark__c,
    c.Operation_Status__c, c.Ops_Status__c, c.Ops_Remark__c, c.Date_Auto_Punch1__c,
    c.Date_Auto_Punch2__c, c.PDD__c, c.OTC__c, c.OTC_main__c, c.PDD_main__c, approved_flag__c, CPA_Status__c,
    OTPDeferralCategory__c, OTPDeferralDocuments__c, c.Ageing__c, c.Document_Sent_to_NAX__c,
    c.Deferral_Type__c, IsCritical__c, Property_Details__r.Name, DocStatus1__c, Documents_Type__c, IsNonCritical__c, c.checkfordelete__c, C.Document_TYPE1__c, c.Expected_Resolution__c, c.DocumentFmlyName__r.Documents__c, PDD_OTC_Received_Date__c, PDD_OTC_Received_Status__c, PDD_OTC_Remarks__c, DocumentFmlyName__r.Name, Property_Documents__c, Deferral_Taken_Date__c, CPA_Deferral_Clearance_Date__c, CPA_Deferral_Status__c, OpsDeferral_Clearance_Date__c, OPS_Deferral_Status__c, Details_of_Defferral_Docs__c
    From Checklist__c c
    Where Category__C = 'Applicant'
    and
    Applicant__r.Loan_Application__c =: Loan.id
   ];
  }

  system.debug('**************Checklist Size: ' + objchecklist.size());

  // Added for disbursement
  objchecklistDis = new List < Checklist__c > ();
  for (Checklist__c ocl: objchecklist) {
   if (ocl.Checklist_type__c == 'Disbursement') {
    ocl.Loan_Application__c = Loan.id;
    objchecklistDis.add(ocl);
   }

  }
  objchecklist = new List < Checklist__c > ();
  if (objchecklistDis.size() > 0) {
   viewDis = true;
  }
  return null;
 }
 public void sendPricingEmail() {
  /* salpl commercial consent start */
  Map < String, Object > ALLMap = new Map < String, Object > ();
  Map < String, Object > sendpricingemap = new Map < String, String > ();
  Boolean send_email_to_sourcing = true;
  Boolean send_email_to_ASM = true;
  Boolean send_email_to_relationship_manager = true;
  String jsnBody;
  if (sendpricingemail != null) {
   jsnBody = sendpricingemail.Body.toString();
   ALLMap = (Map < String, Object > ) JSON.deserializeUnTyped(jsnBody);
   sendpricingemap = (Map < String, Object > ) ALLMap.get('sendpricingemail');
   send_email_to_sourcing = Boolean.valueOf(sendpricingemap.get('send_to_sourcing_email'));
   send_email_to_relationship_manager = Boolean.valueOf(sendpricingemap.get('send_to_relationship_manager'));
   send_email_to_ASM = Boolean.valueOf(sendpricingemap.get('send_to_asm_email'));
   System.debug('pkswitch' + send_email_to_sourcing + send_email_to_relationship_manager + send_email_to_ASM);
  }
  /* salpl commercial consent end*/
  encryptloanId = CommonUtility.encryptURLParam(loan.id);
  fees1 = [select id, name, Loan_Application__r.name, Charge_Type__c, Deducted_from_Disbursement__c, Deposition_Date__c, Deposit_Slip_Number__c,
   Service_Charge__c, Status__c, Change_Amount__c, Instrument_Date__c, Instrument_No__c, Bank_Branch__c, Charge__c, Instrument_type__c,
   Amount_after_Service_Change__c, Disbursement_Number__c from Fees_and_Charge__c where Loan_Application__c =: loan.id and Charge_Type__c = 'Line Utilization'
  ];
  System.debug('Inside SendEmail.....');
  List < DPLinsurance__c > insurenceList = new List < DPLinsurance__c > ();
  List < Fees_and_Charge__c > fees = new List < Fees_and_Charge__c > ();
  /*Prajyot : SAL Commercial Email Enahancemen*/
  List < Fees_and_Charge__c > feesFin = new List < Fees_and_Charge__c > ();
  String ffrCharges, rateOfInterest;

  decimal processingFee, profeeamo, servtax, serviceTax;
  //Commercial emailer added flexifee - 16507
  decimal flexiFee = 0, ffr = 0, loanAmount = 0, loanAmountInsurence = 0, tenorOfMonths = 0, touchFreeCharge = 0; //touchFreeCharge added by prashant for SAL PLTB Changes @16507 




  profeeamo = 0;
  processingFee = 0;
  /*  bug :11653 added by priya start*/
  if (loan != null && loan.Type_Of_Loan__c != null && (loan.Type_Of_Loan__c.toUpperCase().contains('TOP UP 1') || loan.Type_Of_Loan__c.toUpperCase().contains('TOP UP 2') || loan.Type_Of_Loan__c.toUpperCase().contains('TOP UP 3')) && loan.Processing_Fees__c != null) {
   profeeamo = (loan.Net_Loan_to_POS__c * loan.Processing_Fees__c) / 100;
  } else if (loan != null && loan.Loan_Amount_with_Premium__c != null && loan.Processing_Fees__c != null)
   profeeamo = (loan.Loan_Amount_with_Premium__c * loan.Processing_Fees__c) / 100;

  /*  bug :11653 added by priya end */

  Double servicetaxval = 0;
  if (ATOSParameters__c.getValues('Service Tax') != null && ATOSParameters__c.getValues('Service Tax').value__c != null)
   servicetaxval = Double.ValueOf(ATOSParameters__c.getValues('Service Tax').value__c);

  serviceTax = decimal.valueOf(servicetaxval);
  System.debug('serviceTax=' + serviceTax + '=serviceTax*100=' + serviceTax * 100);
  serviceTax = serviceTax * 100;
  serviceTax = serviceTax.setScale(2);
  System.debug('serviceTax=' + serviceTax);


  servtax = profeeamo * servicetaxval;
  processingFee = profeeamo + servtax;

  //pricing email changes added setScale
  processingFee = processingFee.setScale(2);


  if (Loan != null) {
   insurenceList = [Select id, Nominee_Relationship__c, Insurance_Type__c, Premium_Amount__c, Insurance_Product__c, Sum_Assured__c, Insurance_Party_type__c, Applicant_type__c, Insurance_form_number__c, Critical_Illness__c, Relation__c, Insurance_term__c, Declaration_of_good_health__c from DPLinsurance__c where Opportunity__c =: Loan.id];

   //charges API enhancement start added Finnone_ChargeId__c in query.
   /*Prajyot : Changing query for commerical email enhancement START*/
   //fees = [select id, name, Finnone_ChargeId__c, Charge_Desc__c, Loan_Application__c, Charge_Type__c, Change_Amount__c from Fees_and_Charge__c where Loan_Application__c = : loan.id and Charge_Type__c = 'Financial Health Check Guide ( Credit Vidya )'];
   feesFin = [select id, name, Finnone_ChargeId__c, Charge_Desc__c, Loan_Application__c, Charge_Type__c, Change_Amount__c from Fees_and_Charge__c where Loan_Application__c =: loan.id];

   for (Fees_and_Charge__c f: feesFin) {
    if (f.Charge_Type__c == 'Financial Health Check Guide ( Credit Vidya )') {
     fees.add(f);
    }
    /*Commercial emailer 16507 s*/
    if (f.Charge_Type__c == 'FLEXI FEE') {
     flexiFee = f.Change_Amount__c;
    }
    /*Commercial emailer 16507 e*/
    /*touchFreeCharge added by prashant for SAL PLTB Changes @16507 Start*/
    if (f.Finnone_ChargeId__c == 601557) {
     touchFreeCharge = f.Change_Amount__c;
    }
    /*touchFreeCharge added by prashant for SAL PLTB Changes @16507 End*/

   }
   /*Prajyot : Changiong query for commerical email enhancement END*/

   System.debug('insurenceList=' + insurenceList.size() + 'fees=' + fees.size());


  }

  for (Fees_and_Charge__c fee: fees) {
   ffr += fee.Change_Amount__c;
  }
  System.debug('ffr=' + ffr);

  if (ffr > 0) {
   ffrCharges = 'Yes (Rs.' + ffr + ' will get deducted from disbursement)';
  } else {
   ffrCharges = 'No';
  }

  if (loan != null) {
   loanAmount = loan.Approved_Loan_Amount__c;
   loanAmountInsurence = loan.Loan_Amount_with_Premium__c;
   tenorOfMonths = loan.Approved_Tenor__c;
   rateOfInterest = '' + loan.Approved_Rate__c;
  }


  System.debug('rateOfInterest=' + rateOfInterest + 'tenorOfMonths=' + tenorOfMonths + 'loanAmount=' + loanAmount + 'loanAmountInsurence=' + loanAmountInsurence + 'firtEMIDate=' + firtEMIDate + '-lastEMIDate-' + lastEMIDate + 'loantype=' + loantype + '=processingFee=' + processingFee + 'brokenPeriodInt=' + brokenPeriodInt + '-emi-' + emi + '=creditCard=' + creditCard + 'ffr=' + ffr);


  List < String > toAddlist = new List < String > ();
  List < String > toAddlistCC = new List < String > ();
  //System.debug('conObj.Office_Email_Id__c=' + conObj.Office_Email_Id__c + '=loan.Accountant_email_id__c=' + loan.Accountant_email_id__c+'loan.ASM_email_id__c'+loan.ASM_email_id__c);
  //prod issue 11237 by ranjit S
  // if (loan.Account.Current_Email_Id__c != null) {
  // toAddlist.add(Loan.Account.Current_Email_Id__c);
  //}
  //prod issue 11237 by ranjit E
  if (Loan.Sourcing_channel_email_id__c != null) {
   if (send_email_to_sourcing != null && send_email_to_sourcing) {
    System.debug('pkswitch send_email_to_sourcing' + send_email_to_sourcing);
    toAddlist.add(Loan.Sourcing_channel_email_id__c);
   }
  }
  if (conObj != null && conObj.Office_Email_Id__c != null) {
   toAddlist.add(conObj.Office_Email_Id__c);
  }
  //prod issue 11237 by ranjit S
  if (conObj != null && conObj.Email__c != null) {
   toAddlist.add(conObj.Email__c);
  }
  //HFC PLTB Eagreement changes CR :S
  if (conObj != null && conObj.Email != null) {
   toAddlist.add(conObj.Email);
  } //HFC PLTB Eagreement changes CR :E
  if (Loan.ASM_email_id__c != null) {
   if (send_email_to_ASM != null && send_email_to_ASM) {
    System.debug('pkswitch send_email_to_ASM' + send_email_to_ASM);
    toAddlist.add(Loan.ASM_email_id__c);
   }
  }
  //if (loan.Customer_email_id__c != null)
  //toAddlist.add(loan.Customer_email_id__c);
  //if (loan.Accountant_email_id__c != null)
  //toAddlist.add(loan.Accountant_email_id__c);
  //accountCreate1.Accountant_email_id__c
  //prod issue 11237 by ranjit E
  // Changed loan.ASM_Email_ID__c to Relationship_Manager__r.Email to resolve production issue 9593
  System.debug('loan.Relationship_Manager__r' + loan.Relationship_Manager__r);
  if (loan.Relationship_Manager__r != null && loan.Relationship_Manager__r.Email != null) {
   if (send_email_to_relationship_manager != null && send_email_to_relationship_manager)
    toAddlistCC.add(loan.Relationship_Manager__r.Email);
   System.debug('loan.Relationship_Manager__r.Email' + loan.Relationship_Manager__r.Email);
  }
  /*SAL 2.0 CR s*/
  if(loan.Area_SM__c != null && loan.Area_SM__r.Email != null)
      toAddlistCC.add(loan.Area_SM__r.Email); 
  /*SAL 2.0 CR e*/
  if (toAddlist.size() > 0) {

   String[] toAdd = toAddlist;
   String[] ccArray = toAddlistCC;
   String[] bccArray = new List < String > ();
   String[] SalPricingProd;

   /*Prajyot : SAL Commercial Email Enahancement : Custom setting to get charge types and products*/
   Set < String > finOneCode;
   Set < String > productsAllowed;
   if (LaonApplicationCreation__c.getValues('Commercial Email Enahancement') != null) {
    finOneCode = new Set < String > (LaonApplicationCreation__c.getValues('Commercial Email Enahancement').FFR_Finnone_charge_code__c.toUppercase().split(';'));
    productsAllowed = new Set < String > (LaonApplicationCreation__c.getValues('Commercial Email Enahancement').Products__c.toUppercase().split(';'));
   }
   /*Prajyot : SAL Commercial Email Enahancement : END */


   if (!Test.isRunningTest())
    SalPricingProd = Label.salaried_pricing_product.split(';');
   String ServiceGuaranteeEmail;
   if (!Test.isRunningTest())
    ServiceGuaranteeEmail = Label.ServiceG;
   boolean isProduct = false;
   System.debug('toAddlist' + toAddlist + 'toAddlistCC=' + toAddlistCC);
   if (SalPricingProd != null && SalPricingProd.size() > 0) {
    for (String prod: SalPricingProd) {
     if (Loan.Product__c.ToUpperCase() == prod.ToUpperCase()) {
      if (ServiceGuaranteeEmail != null && ServiceGuaranteeEmail == 'true') {
       isProduct = true;
      }
     }
    }
   }
   String body = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><title>Bajaj Finserv</title><style type="text/css"></style></head>';
   body += '<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="color: #000000; font-family: Arial, Helvetica, sans-serif; font-size: 15px"><table width="780" border="0" cellpadding="0" cellspacing="0" style="border: 1px #949494 solid" align="center"><tr><td valign="top" colspan="5"><table width="780" border="0" cellpadding="0" cellspacing="0"><td width="353" align="left">&nbsp;</td><td width="428" align="right">';
   body += '<a href="http://www.bajajfinserv.in/finance/?utm_source=May_PL_Email_Loan_Approved_BF&utm_medium=Email&utm_campaign=PL_Generic" target="_blank"><img src="{!$Label.Org_Base_Url}{!$Resource.LAbfllogo}" width="401" height="83" alt="Bajaj Finserv" title="Bajaj Finserv" align="right" border="0" /></a></td></table></td></tr>';
   body += '<tr><td colspan="5" valign="top" style="padding: 5px 0 10px 12px;"><div style="font-size: 28px; font-weight: bold;">Congratulations! Your Personal Loan<br />application has been approved </div></td></tr><tr><td height="366" colspan="5" valign="top" style="padding:0 0 5px 0;"><table width="100%" border="0" cellpadding="0" cellspacing="0" ><tr><td width="467px" height="361" valign="top"><img src="{!$Label.Org_Base_Url}{!$Resource.LABanner}" width="780" height="360" /></td></tr></table></td></tr>';
   /*SAL PLTB Bug 12108 start - krish*/
   System.debug('callCenterProcessFlag ' + callCenterProcessFlag + ' ' + '  ' + salLineFlag + ' ' + autoTopUp);
   if ((callCenterProcessFlag == true && salLineFlag == false && autoTopUp == false) || salMobilityFlag == true || Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL') {
    //PLTB prod issue - Rohit added loan id.
    body += '<tr><td colspan="5" valign="top" style="padding: 5px 0 10px 12px;"><a href="' + Label.bflsiteuserURL + '/PLTBTermsAndConditions?LoanId=' + Loan.Id + '&EmailFor=EAgreement" target="_blank" style="color:#000;text-decoration:none;"><strong><u>Click here </u></strong></a> to accept our terms and conditions.</td></tr>';

   }
   /*SAL PLTB Bug 12108 end - krish*/
   //commercial emailer added if condition and splitted body16507
   body += '<tr><td colspan="5"><table cellpadding="0" cellspacing="0" border="0" width="100%" ><tr><td  valign="top"><table width="780" border="0" style="padding:0 5px 0 0"><tr><td width="454" valign="top"> <div style="padding:0px 0 5px 0" > <table width="98%" border="0" cellpadding="0" cellspacing="0"><tr><td style="font-size:15px; font-family:Arial, Helvetica, sans-serif;color:#000000; line-height:22px;" > <div style="padding:0px 0 0 12px"><div align="justify">Dear Customer,<br /><br />Greetings from Bajaj Finserv.<br /><br />We are delighted to inform you that your Personal Loan application has been approved. Please note that further processing of your loan application would be subject to the terms and conditions mentioned in this mailer. Request you to acknowledge and reply with a confirmation, reading \'Ok\' from your official mail id. <br /><br /> ';
   if (callCenterProcessFlag == true || salMobilityFlag == true || Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL') {
    body += '<strong> A. Suite of products to choose from:<br/><br/>1. Term Loan</strong><br/>Term Loan is a monetary loan that can be repaid in regular payments over a set period of time. Here the principal, interest rate and tenor is fixed and there is no facility of credit line<br/><br/><strong>2. Flexi Term Loan</strong></br>You have the flexibility to pre-pay your loan with your surplus funds and thereby, save interest. You can re-draw the eligible amount at any time within the loan tenure without any additional documentation.<br/><br/><strong>3. Flexi Hybrid Loan</strong><br/>Flexi Hybrid Loan is a combination of Flexi Term Loan and Flexi Interest-only loan in the tenure ratio of 2:3 years.<br/><br/>Flexi Interest-only Loan construct: The loan will start as Flexi Interest-only product with only interest servicing on the utilised amount.<br/><br/>Flexi Term Loan construct: Post completion of Flexi Interest-only construct, Flexi Term loan will start for remaining tenure.<br/>';
   } else {
    body += '<strong> A. Suite of products to choose from:<br />1. Line of Credit (LOC) </strong> <br />LOC is a unique and innovative offering from Bajaj Finserv.It allows you to manage your cash flow more effectively and smartly. With LOC, you pay only the “Interest” on the amount utilized against the EMI as per regular amortization which reduces burden of your monthly cash flow. The principal can be paid during the term of the loan as per your convenience. LOC facility is offered for a period of 12 months post which it can be renewed for the additional term.<br /><br /><strong>2. Flexi Loan</strong><br />You have the flexibility to pre-pay your loan with your surplus funds & save interest. You can re-draw the eligible amount at any time within the loan tenor without any additional documentation.<br />';
    body += '<strong><br />3. Personal Line</strong><br /><br/>Personal line is an innovative facility designed to fulfill your future lending requirements. This is offered basis your loan eligibility and current disbursal. If you had utilized amount less than the personal line amount, the balance non utilized amount can be availed on just a call. This is an unmatched offer by Bajaj Finance with backed by our service time guarantee.<br /><br />';
    /*Prajyot : SAL Commercial Email Enahancement */
    if (productsAllowed != null && productsAllowed.contains(Loan.Product__c.toUppercase())) {
     body += '<strong><br />4. EMI Holiday</strong><br /><br/>Enjoy an EMI-free month every year for the duration of your loan after clearing your first 6 EMI’s. This month will either be March or October, whichever comes first. *If you opt for an EMI Holiday and wish to make a part payment, it will have to be made at one of our nearest branches. Part payment will result in reduction in EMI amount and the tenure of your loan will remain unchanged.<br /><br />';
    }
   }
   body += '<strong><br />B. Service Channels</strong><br />You can reach us through multiple channels:<br />Our dedicated customer service team will be your first point of contact for any request or grievance. We request you to avail this service so that you can avoid visiting our branch or trying to reach us though other modes.<br/><br/>Our service email id is <strong><a href="mailto:wecare@bajajfinserv.in" target="_blank">wecare@bajajfinserv.in</a></strong>. In case you do not get a satisfactory resolution you can write to our Grievance Redressal team <strong><a href="mailto:Grievanceredressalteam@bajajfinserv.in" target="_blank">Grievanceredressalteam@bajajfinserv.in</a></strong>.<u></u><br/>If you feel your issue has not been addressed by above channels <br/>you can write to <strong><a href="mailto:customerexperiencehead@bajajfinserv.in" target="_blank">customerexperiencehead@bajajfinserv.in</a></strong><u></u><br/>We are committed to resolve your query /grievance <span data-term="goog_856554801" tabindex="0">in 48 hours</span>, else we assure you a call back<u></u><br/><strong>Experia</strong> - our self-service Customer Portal, gives you access to all your loan details<u></u><br/>Updates through <strong>Email</strong> and <strong>SMS</strong> through Insta Info.<u></u><br/>A bi-directional SMS channel, SMS <strong>9227564444</strong> for any of your loan details like - LAN, Customer ID, Experia ID and more.';
   //commercial emailer added if condition 16507
   if (callCenterProcessFlag == true || salMobilityFlag == true || Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL') {
    body += '<strong><br /><br />C. Loan prepayment facility:<br/><br/>1. Loan Pre-closure:</strong><br/>You are allowed to pre-close loan outstanding any time post clearance of first EMI. <br/><br/><strong>Term Loan </strong>Charges applicable @ 4% of Principal Outstanding<br/><strong>Flexi Interest-only Loan: </strong>Charges applicable @ 4% of sanctioned amount<br/><strong>Flexi Hybrid Loan: </strong>Initial Tenure – 4% on sanctioned amount<br/>Subsequent Tenure – 4% on principle outstanding as per Flexi Term Loan amount<br/>Taxes will be applicable on charges towards full pre-closure of loan.<br/><br/>';
    body += '<strong>2. Part Prepayment</strong><br/>"We also offer you convenience of part prepayment towards your loan outstanding. The amount of part Pre-Payment shall be equal to a minimum sum of one EMI. Part payment charges are applicable @ 2%* plus applicable taxes on amount paid <br/><br/>For Flexi Term Loan & Flexi Hybrid Loan complete loan amount will be disbursed to the customer’s bank account at the time of loan booking. Customers can choose to part payment of any amount post disbursal" <br/><br/>*No charges are applicable on part prepayment of Flexi Term loan & Flexi Hybrid Loan.';
   }
   if (isProduct) {
    body += '<strong><br/> In addition, Bajaj Finserv also brings you the Big Sparkling Diwali contest, with the following amazing gifts to be won:<br/><br/>9 iPhone 7s, 9 iPad minis and 100 e-vouchers worth Rs.5000 each.<br/></strong><br/>To participate in the Sparkling Diwali contest, please answer the following question once your loan is disbursed.<br/><br/>Which contest is Bajaj Finserv running this Diwali?<br/><br/>A. &nbsp;&nbsp;&nbsp;&nbsp; Big Sparkling Diwali<br/>B. &nbsp;&nbsp;&nbsp;&nbsp; Amazing Diwali<br/>C. &nbsp;&nbsp;&nbsp;&nbsp; Cool Diwali<br/><br/>SMS&nbsp; <strong>DIWALI</strong><space><' + 'Your answer option> to 9773633633<br/><br/>Contest duration is 5th October to 4th December 2016.';
   }

   body += '</td></tr></table></div> </td><td width="316" style="padding:10px 0px 0px 0" bgcolor="#D5D5D5" valign="top"><div style="padding:0 0px 0 5px"><strong>Loan details:</strong></div></strong><strong> <br /></strong>';
   body += '<table width="315" height="407" border="1" style="padding:0 5px 0 5px">';

   if (objSurrogateCAM.Line_opted__c == 'YES' && (Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName == 'Branch Ops')) {
    body += '<tr><td width="171"><span class="style3">Approved Personal Line</span> </td><td width="128"><span class="style3">Rs.' + objSurrogateCAM.Line_assigned_basis_Credit_Assessment__c + '</span></td></tr>';
    body += '<tr><td width="171"><span class="style3">Personal Line facility to be availed</span> </td><td width="128"><span class="style3">' + objSurrogateCAM.Line_opted__c + '</span></td></tr>';
    body += '<tr><td width="171"><span class="style3">Annual fee for Personal Line (To be deducted from disbursal amount)</span> </td><td width="128"><span class="style3">' + (!CommonUtility.isEmpty(fees1) && !CommonUtility.isEmpty(fees1[0].Change_Amount__c) ? String.valueOf(fees1[0].Change_Amount__c) : '') + '</span></td></tr>';
    body += '<tr><td width="171"><span class="style3">Product variant opted</span> </td><td width="128"><span class="style3">' + Loan.Type_Of_Loan__c + '</br></span></td></tr>';
   }

   body += '<tr><td width="171"><span class="style3">Loan amount approved</span> </td><td width="128"><span class="style3">Rs.' + loanAmount + '</span></td></tr>';
   //Commercial emailer added if else -16507 
   if (callCenterProcessFlag == true || salMobilityFlag == true || Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL') {
    body += '<tr><td><span class="style3">Approved loan amount<br />including Insurance & CPP</span></td><td><span class="style3">Rs.' + loanAmountInsurence + '</span></td></tr>';
   } else {
    body += '<tr><td><span class="style3">Approved loan amount<br />including Insurance</span></td><td><span class="style3">Rs.' + loanAmountInsurence + '</span></td></tr>';
   }
   body += '<tr><td><span class="style3">Loan Type </span> </td><td> <span class="style3">' + loantype + '</span></td></tr>';

   for (DPLinsurance__c insurlist: insurenceList) {
    // Changed Insurance Amount (General Amount) to Insurance sum assured to resolve production issue bug - 9595
    body += '<tr><td><span class="style3">Insurance product type<br/>Insurance premium<br/>Insurance sum assured</span></td><td><span class="style3">' + insurlist.Insurance_Type__c + '<br/>Rs.' + insurlist.Premium_Amount__c + '<br/>Rs.' + insurlist.Sum_Assured__c + '</span></td></tr>';
   }

   body += '<tr><td><span class="style3">Rate of interest</span></td><td><span class="style3">' + loan.Approved_Rate__c + '</span></td></tr>';
   //body += '<tr><td><span class="style3">Processing fee<br />(including Service<br />tax  & Cess @' + serviceTax + '%)</span></td><td><span class="style3">Rs.' + processingFee + '</span></td></tr><tr><td><span class="style3">Indicative Broken period interest</span></td><td><span class="style3">Rs.' + brokenPeriodInt + '</span> </td> </tr> <tr><td><span class="style3">EMI</span></td><td><span class="style3">Rs.' + emi + '</span></td></tr><tr><td><span class="style3">Tenure In months</span></td><td>' + tenorOfMonths + '</td></tr><tr><td><span class="style3">First EMI date</span></td><td><span class="style3">' + firtEMIDate + '</span></td></tr><tr><td><span class="style3">Last EMI date</span></td><td><span class="style3">' + lastEMIDate + '</span></td></tr><tr><td><span class="style3">Stamp duty charge (To <br />be deducted from<br />adisbursal amount)</span></td><td><span class="style3">' + conObj.Stamp_Duty__c + '</span></td></tr><tr><td><span class="style3">Financial Fitness Report <br/>(To be deducted from </br>disbursal amount) </span></td><td><span class="style3">'+(!CommonUtility.isEmpty(fees) && !CommonUtility.isEmpty(fees[0].Change_Amount__c)?String.valueOf(fees[0].Change_Amount__c):'')+'</span></td></tr>';


   //body += '<tr><td><span class="style3">Processing fee<br />(including Service<br />tax  & Cess @' + serviceTax + '%)</span></td><td><span class="style3">Rs.' + processingFee + '</span></td></tr><tr><td><span class="style3">Indicative Broken period interest</span></td><td><span class="style3">Rs.' + brokenPeriodInt + '</span> </td> </tr> <tr><td><span class="style3">EMI</span></td><td><span class="style3">Rs.' + emi + '</span></td></tr><tr><td><span class="style3">Tenure In months</span></td><td>' + tenorOfMonths + '</td></tr><tr><td><span class="style3">First EMI date</span></td><td><span class="style3">' + firtEMIDate + '</span></td></tr><tr><td><span class="style3">Last EMI date</span></td><td><span class="style3">' + lastEMIDate + '</span></td></tr><tr><td><span class="style3">Stamp duty charge To <br />be deducted from<br /> disbursal amount</span></td><td><span class="style3">' + conObj.Stamp_Duty__c + '</span></td></tr><tr><td><span class="style3">Financial Fitness Report <br/>To be deducted from </br>disbursal amount </span></td><td><span class="style3">' + (!CommonUtility.isEmpty(fees) && !CommonUtility.isEmpty(fees[0].Change_Amount__c) ? String.valueOf(fees[0].Change_Amount__c) : '') + '</br></span></td></tr></table>';

   //Prajyot : Commercial Email Enahancement : START */
   decimal addedCharges = 0;


   system.debug('finOneCode=' + finOneCode);
   system.debug('fees=' + fees);

   for (Fees_and_Charge__c fc: feesFin) {
    system.debug('ees[0].Finnone_ChargeId__c=' + String.valueOf(fc.Finnone_ChargeId__c));
    system.debug('fc.Change_Amount__c=' + fc.Change_Amount__c);
    if (fc.Finnone_ChargeId__c != null && finOneCode.contains(String.valueOf(fc.Finnone_ChargeId__c).toUppercase()) && fc.Change_Amount__c != null) {
     addedCharges = addedCharges + fc.Change_Amount__c;

    }
   }


   if (productsAllowed != null && productsAllowed.contains(Loan.Product__c.toUppercase())) {
    body += '<tr><td><span class="style3">Processing fee<br />(including Service<br />tax  & Cess @' + serviceTax + '%)</span></td><td><span class="style3">Rs.' + processingFee + '</span></td></tr>';

    if (callCenterProcessFlag == true || salMobilityFlag == true || Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL') {
     body += '<tr><td><span class="style3">Touchfree Fee</span></td><td><span class="style3">Rs.' + touchFreeCharge + '</span> </td> </tr>';

     body += '<tr><td><span class="style3">* Indicative Broken period interest</span></td><td><span class="style3">Rs.' + brokenPeriodInt + '</span> </td> </tr> <tr><td><span class="style3">EMI</span></td><td><span class="style3">Rs.' + emi + '</span></td></tr><tr><td><span class="style3">EMI (Initial Tenure)(Applicable only for Flexi Hybrid Loan)</span></td><td><span class="style3">Rs.' + applicantPrimary.Pure_Flexi_EMI__c + '</span></td></tr><tr><td><span class="style3">EMI (Subsequent Tenure)<br/>(Applicable only for Flexi Hybrid Loan)</span></td><td><span class="style3">Rs.' + Loan.EMI_CAM__c + '</span></td></tr><tr><td><span class="style3">Tenure In months</span></td><td>' + tenorOfMonths + '</td></tr><tr><td><span class="style3">Tenure In months<br/>(Initial Tenure)</span></td><td>' + applicantPrimary.Pure_Flexi_Period__c + '</td></tr><tr><td><span class="style3">Tenure In months<br/>(Subsequent Tenure)<br/>(Applicable only for Flexi Hybrid Loan)</span></td><td>' + applicantPrimary.Drop_Line_Flexi_Period__c + '</td></tr><tr><td><span class="style3">First EMI date</span></td><td><span class="style3">' + firtEMIDate + '</span></td></tr><tr><td><span class="style3">Last EMI date</span></td><td><span class="style3">' + lastEMIDate + '</span></td></tr><tr><td><span class="style3">Stamp duty charge To <br />be deducted from<br /> disbursal amount</span></td><td><span class="style3">' + conObj.Stamp_Duty__c + '</span></td></tr><tr><td><span class="style3">Flexi Fee (Applicable for all Flexi Loans)</span></td><td><span class="style3">' + flexiFee + '</span></td></tr><tr><td><span class="style3">Financial Fitness Report <br/>To be deducted from </br>disbursal amount </span></td><td><span class="style3">' + (!CommonUtility.isEmpty(fees) && !CommonUtility.isEmpty(fees[0].Change_Amount__c) ? String.valueOf(fees[0].Change_Amount__c) : '') + '</br></span></td></tr><tr><td><span class="style3">Card Protection plan <br/>(Wallet Protect)to be deducted from <br/>disbursement (In Rs.)</span></td><td><span class="style3">' + addedCharges + '</br></span></td></tr></table>';
    } else {
     body += '<tr><td><span class="style3">* Indicative Broken period interest</span></td><td><span class="style3">Rs.' + brokenPeriodInt + '</span> </td> </tr> <tr><td><span class="style3">EMI</span></td><td><span class="style3">Rs.' + emi + '</span></td></tr><tr><td><span class="style3">Tenure In months</span></td><td>' + tenorOfMonths + '</td></tr><tr><td><span class="style3">First EMI date</span></td><td><span class="style3">' + firtEMIDate + '</span></td></tr><tr><td><span class="style3">Last EMI date</span></td><td><span class="style3">' + lastEMIDate + '</span></td></tr><tr><td><span class="style3">Stamp duty charge To <br />be deducted from<br /> disbursal amount</span></td><td><span class="style3">' + conObj.Stamp_Duty__c + '</span></td></tr><tr><td><span class="style3">Financial Fitness Report <br/>To be deducted from </br>disbursal amount </span></td><td><span class="style3">' + (!CommonUtility.isEmpty(fees) && !CommonUtility.isEmpty(fees[0].Change_Amount__c) ? String.valueOf(fees[0].Change_Amount__c) : '') + '</br></span></td></tr><tr><td><span class="style3">Credit Protection plan to be deducted from disbursement</span></td><td><span class="style3">' + addedCharges + '</br></span></td></tr></table>';
    }
   } else {
    body += '<tr><td><span class="style3">Processing fee<br />(including Service<br />tax  & Cess @' + serviceTax + '%)</span></td><td><span class="style3">Rs.' + processingFee + '</span></td></tr><tr><td><span class="style3">* Indicative Broken period interest</span></td><td><span class="style3">Rs.' + brokenPeriodInt + '</span> </td> </tr> <tr><td><span class="style3">EMI</span></td><td><span class="style3">Rs.' + emi + '</span></td></tr><tr><td><span class="style3">Tenure In months</span></td><td>' + tenorOfMonths + '</td></tr><tr><td><span class="style3">First EMI date</span></td><td><span class="style3">' + firtEMIDate + '</span></td></tr><tr><td><span class="style3">Last EMI date</span></td><td><span class="style3">' + lastEMIDate + '</span></td></tr><tr><td><span class="style3">Stamp duty charge To <br />be deducted from<br /> disbursal amount</span></td><td><span class="style3">' + conObj.Stamp_Duty__c + '</span></td></tr><tr><td><span class="style3">Financial Fitness Report <br/>To be deducted from </br>disbursal amount </span></td><td><span class="style3">' + (!CommonUtility.isEmpty(fees) && !CommonUtility.isEmpty(fees[0].Change_Amount__c) ? String.valueOf(fees[0].Change_Amount__c) : '') + '</br></span></td></tr></table>';
   }

   /*  Prajyot : #10660 Pricing Logic START  */

   if (Loan.Product__c == 'Home Loan' || Loan.Product__c == 'LAP') {

    Existing_Loan_Details__c exisingLoan = SelectQueriesHelperClass.QueryExistingLoanDetails(loan.id);
    if (exisingLoan != null) {
     system.debug('exisingLoan.id=' + exisingLoan.id);
     system.debug('exisingLoan.Type_Of_Loan__c=' + exisingLoan.Loan_Type__c);
     if (exisingLoan.Loan_Type__c == 'Housing Loan' || exisingLoan.Loan_Type__c == 'Property Loan' || exisingLoan.Loan_Type__c == 'LAP' || exisingLoan.Loan_Type__c == 'HL' || exisingLoan.Loan_Type__c == 'Hl Improvement Loan') {

      /* Commented and added by ankush for Bug: 13109 */
      // body += '<tr><td><span class="style3">Stamped Top up ROI</span></td><td><span class="style3">' + exisingLoan.Stamped_Top_UP_ROI__c + '</span></td></tr>';
      // body += '<tr><td><span class="style3">Stamped Insurance</span></td><td><span class="style3">' + exisingLoan.Stamped_Insurance__c + '</span></td></tr></table>';

      body += '<tr><td><span class="style3">Stamped Top up ROI</span></td><td><span class="style3">' + loan.Account.Stamped_Top_UP_ROI__c + '</span></td></tr>';
      body += '<tr><td><span class="style3">Stamped Insurance</span></td><td><span class="style3">' + loan.Account.Stamped_Insurance__c + '</span></td></tr></table>';

     }
    }

   }
   /*  Prajyot : #10660 Pricing Logic END  */


   /*Prajyot : SAL Commercial Email Enahancement END*/
   body += '<br/><span class="style3">* Broken Period Interest will be charged from the date of disbursement to the date of EMI commencement. Depending on the product availed, it will either get deducted from your loan amount apart from the charges mentioned or would be included in your first EMI.</span><br/><br/>';

   //body += '<strong><br />C. Loan prepayment facility:</strong><br /><br/><strong>1. Loan Pre-closure:</strong></br>You are allowed to pre-close loan outstanding any time post clearance of first EMI. Charges applicable @ 4% of Principal outstanding plus applicable taxes towards full pre-closure of loan.</br></br><strong>2. Part Prepayment</strong></br></br>"We also offer you convenience of part prepayment towards your loan outstanding. Post clearance of the 1st EMI, you are allowed to pay up to 6 times in a Calendar Year.The amount of part Pre-Payment shall be equal to a minimum sum of one EMI.Part payment charges are applicable @ 2% plus applicable taxes on amount paid <br/><br/> For Flexi loans, complete loan amount will be disbursed to the customer’s bank account at the time of loan booking. Customers can choose to part payment of any amount post disbursal <br/><br/> *No charges are applicable on part prepayment of Flexi loans & Line of Credit (LOC)."<strong><br /><br/>D. Annual Fee on Line facility:</strong></br></br>In order to continue with the Line facility for the new term each year, you need to pay the following annual fee<br /><ul type="disc"><li>Line of Credit (LOC): 1.0% of the sanctioned amount</li><li>Personal Line: Rs. 999/1999 (as per fee slab)</li></ul><strong><br />E. Instances under which Line facility (Personal Line of credit/ Personal line/ Flexi Loans) can be modified/blocked:</strong><br /><ul type="disc"><li>Bounce in BFL EMI</li><li>Drop in CIBIL Score</li><li>Change in organization/occupation</li></ul></br><strong><br />F. Click on <a href = "https://www.bajajfinserv.in/finance/downloads/Salaried-Personal-Loan-Agreement2.pdf">link</a> to download detailed loan T&C<br/></strong><br/>Thank you for choosing Bajaj Finserv Lending as your financial partner for your lending needs. We do believe that we offer superior product offerings that will best serve your need.</div> </td></tr></table></td></tr> </table></td></tr> </tr></tr><tr><td valign="top" colspan="5" style="padding: 5px 0 5px 12px;">';

   /*Prajyot : SAL Commercial Email Enahancement */
   if (productsAllowed != null && productsAllowed.contains(Loan.Product__c.toUppercase())) {
    if (callCenterProcessFlag == true || salMobilityFlag == true || Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL') {
     //commercial emailer added if condition 16507
     if (callCenterProcessFlag == true || salMobilityFlag == true || Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL') {
      body += '<strong><br />D. "Annual Maintenance Fee" for products offered:</strong></br></br>In order to continue with the Line facility for the new term each year, you need to pay the following annual fee<br /><ul type="disc"><li>Flexi Term Loan: 25bps AMC would be applicable on maximum withdrawal amount irrespective of utilization</li><li>Flexi Hybrid Loan: 25bps AMC would be applicable on maximum withdrawal amount irrespective of utilization.</li></ul><strong><br />E. Flexi Fee</strong><br/>Flexi fee is a mandatory fee for Flexi Term Loan/Flexi Hybrid Loan) and Rs.2999 will be charged at the time of disbursement.<br/><strong><br />F. Instances under which Flexi Loan facility (Flexi Term Loan/Flexi Hybrid Loan) can be modified/blocked:</strong><br /><ul type="disc"><li>Bounce in BFL EMI</li><li>Drop in CIBIL Score</li><li>Change in organization/occupation</li></ul></br>';

     } else {
      body += '<strong><br />C. Loan prepayment facility:</strong><br /><br/><strong>1. Loan Pre-closure:</strong></br>You are allowed to pre-close loan outstanding any time post clearance of first EMI. Charges applicable @ 4% of Principal outstanding plus applicable taxes towards full pre-closure of loan.</br></br><strong>2. Part Prepayment</strong></br></br>"We also offer you convenience of part prepayment towards your loan outstanding. Post clearance of the 1st EMI, you are allowed to pay up to 6 times in a Calendar Year.The amount of part Pre-Payment shall be equal to a minimum sum of one EMI.Part payment charges are applicable @ 2% plus applicable taxes on amount paid <br/><br/> For Flexi loans, complete loan amount will be disbursed to the customer’s bank account at the time of loan booking. Customers can choose to part payment the any amount post disbursal <br/><br/> *No charges are applicable on part prepayment of Flexi loans & Line of Credit (LOC)."';
      body += '<strong><br /><br/>D. "Annual Maintenance Fee" for products offered:</strong></br></br>In order to continue with the Line facility for the new term each year, you need to pay the following annual fee<br /><ul type="disc"><li>Line of Credit (LOC): 25bps AMC would be applicable on sanctioned amount.</li><li>Flexi Loan : 25bps AMC would be applicable on Flexi Dropline limit. </li><li>Personal Line: 25bps AMC would be applicable on available limit. Activation fee of 999/1999 as per slab on fresh line disbursement.</li></ul><strong><br />E. Instances under which Line facility (Personal Line of credit/ Personal line/ Flexi Loans) can be modified/blocked:</strong><br /><ul type="disc"><li>Bounce in BFL EMI</li><li>Drop in CIBIL Score</li><li>Change in organization/occupation</li></ul></br><strong><br/> F.Thank you for choosing Bajaj Finserv Lending as your financial partner for your lending needs. We do believe that we offer superior product offerings that will best serve your need.</strong>';

     }
     body += '</div> </td></tr></table></td></tr> </table></td></tr> </tr></tr><tr><td valign="top" colspan="5" style="padding: 5px 0 5px 12px;"';
    } else {
     body += '<strong><br />C. Loan prepayment facility:</strong><br /><br/><strong>1. Loan Pre-closure:</strong></br>You are allowed to pre-close loan outstanding any time post clearance of first EMI. Charges applicable @ 4% of Principal outstanding plus applicable taxes towards full pre-closure of loan.</br></br><strong><br/>2. Part Prepayment</strong></br></br>"We also offer you convenience of part prepayment towards your loan outstanding. The amount of part Pre-Payment shall be equal to a minimum sum of one EMI.Part payment charges are applicable @ 2% plus applicable taxes on amount paid <br/><br/> For Flexi loans, complete loan amount will be disbursed to the customer’s bank account at the time of loan booking. Customers can choose to part payment of any amount post disbursal" <br/><br/>*No charges are applicable on part prepayment of Flexi loans & Line of Credit (LOC).<strong><br /><br/>D.  "Annual Maintenance Fee" for products offered:</strong></br></br>In order to continue with the Line facility for the new term each year, you need to pay the following annual fee<br /><ul type="disc"><li>Line of Credit (LOC): 25bps AMC would be applicable on sanctioned amount.</li><li>Flexi Loan : 25bps AMC would be applicable on Flexi Dropline limit.</li><li>Personal Line : 25bps AMC would be applicable on available limit. Activation fee of 999/1999 as per slab on fresh line disbursement</li></ul><strong><br />E. Instances under which Line facility (Personal Line of credit/ Personal line/ Flexi Loans) can be modified/blocked:</strong><br /><ul type="disc"><li>Bounce in BFL EMI</li><li>Drop in CIBIL Score</li><li>Change in organization/occupation</li></ul></br><strong><br />F. Click on <a href = "https://www.bajajfinserv.in/finance/downloads/Salaried-Personal-Loan-Agreement2.pdf">link</a> to download detailed loan T&C<br/>Thank you for choosing Bajaj Finserv Lending as your financial partner for your lending needs. We do believe that we offer superior product offerings that will best serve your need.</div> </td></tr></table></td></tr> </table></td></tr> </tr></tr><tr><td valign="top" colspan="5" style="padding: 5px 0 5px 12px;">';
    }
   } else {
    body += '<strong><br />C. Loan prepayment facility:</strong><br /><br/><strong>1. Loan Pre-closure:</strong></br>You are allowed to pre-close loan outstanding any time post clearance of first EMI. Charges applicable @ 4% of Principal outstanding plus applicable taxes towards full pre-closure of loan.</br></br><strong>2. Part Prepayment</strong></br></br>"We also offer you convenience of part prepayment towards your loan outstanding. Post clearance of the 1st EMI, you are allowed to pay up to 6 times in a Calendar Year. The amount of part Pre-Payment shall be equal to a minimum sum of one EMI.Part payment charges are applicable @ 2% plus applicable taxes on amount paid <br/><br/> For Flexi loans, complete loan amount will be disbursed to the customer’s bank account at the time of loan booking. Customers can choose to part payment of any amount post disbursal" <br/><br/>*No charges are applicable on part prepayment of Flexi loans & Line of Credit (LOC).<strong><br /><br/>D. Annual Fee on Line facility:</strong></br></br>In order to continue with the Line facility for the new term each year, you need to pay the following annual fee<br /><ul type="disc"><li>Line of Credit (LOC): 1.0% of the sanctioned amount</li><li>Personal Line: Rs. 999/1999 (as per fee slab)</li></ul><strong><br />E. Instances under which Line facility (Personal Line of credit/ Personal line/ Flexi Loans) can be modified/blocked:</strong><br /><ul type="disc"><li>Bounce in BFL EMI</li><li>Drop in CIBIL Score</li><li>Change in organization/occupation</li></ul></br><strong><br />F. Click on <a href = "https://www.bajajfinserv.in/finance/downloads/Salaried-Personal-Loan-Agreement2.pdf">link</a> to download detailed loan T&C<br/>Thank you for choosing Bajaj Finserv Lending as your financial partner for your lending needs. We do believe that we offer superior product offerings that will best serve your need.</div> </td></tr></table></td></tr> </table></td></tr> </tr></tr><tr><td valign="top" colspan="5" style="padding: 5px 0 5px 12px;">';
   }
   //commercial emailer bug 16507 added if
   if (callCenterProcessFlag == true || salMobilityFlag == true || Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL') {
    body += '<br/><div style="background-color:#D5D5D5;"><p style="padding:15px 5px 15px 5px;margin:25px;font-size:15px; font-family:Arial, Helvetica, sans-serif;color:#000000;"><strong>Thank you for choosing Bajaj Finserv as your financial partner for your lending needs. We do believe that we offer superior product offerings that will best serve your need.</p></div><br/>';
   }
   body += '<a href="http://www.bajajfinserv.in/finance/?utm_source=May_PL_Email_Loan_Approved_BF_Finance&amp;utm_medium=Email&amp;utm_campaign=PL_Generic" target="_blank"><img src="{!$Label.Org_Base_Url}{!$Resource.LAvisit}" width="177" height="17" alt="Visit www.bajajfinserv.in" title="Visit www.bajajfinserv.in" align="left" border="0" /></a></td></tr><tr><td style="padding:7px 14px 0 12px" colspan="5"><table width="228px" border="0" cellpadding="0" cellspacing="0" align="left"><tr><td valign="top"><img src="{!$Label.Org_Base_Url}{!$Resource.LAconnect}" width="111" height="35" alt="Connect with us" title="Connect with us" align="left" border="0" /></td><td valign="top"><a href="https://www.facebook.com/bajajfinserv?sk=app_190322544333196" target="_blank"><img src="{!$Label.Org_Base_Url}{!$Resource.LAFacebook}" width="42" height="35" alt="Facebook" title="Facebook" align="left" border="0" /></a></td><td valign="top"><a href="https://twitter.com/Bajaj_Finserv" target="_blank"><img src="{!$Label.Org_Base_Url}{!$Resource.LAtwitter}" width="40" height="35" alt="twitter" title="twitter" align="left" border="0" /></a></td><td valign="top"><a href="http://www.linkedin.com/company/1092003?trk=tyah" target="_blank"><img src="{!$Label.Org_Base_Url}{!$Resource.LAlnk}" width="35" height="35" alt="LinkedIn" title="LinkedIn" align="left" border="0" /></a></td></tr></table></td></tr><tr><td valign="top" colspan="5" style="padding: 10px 14px 10px 12px;"><div style="line-height:18px; font-size:13px;">Terms and conditions apply</div></td></tr><tr><td valign="top " style="padding:5px 5px 5px 0 " colspan="5 "><img src="{!$Label.Org_Base_Url}{!$Resource.LAbflltd}" width="179 " height="21 " alt="Bajaj Finserv " title="Bajaj Finserv " align="right " border="0 " /></td></tr></table></body></html><!DOCTYPE html><html lang="en" xmlns="http://www.w3.org/1999/xhtml"><head><meta charset="utf-8" /><title></title></head><body></body></html>';

   if (objSurrogateCAM.Line_opted__c == 'YES' && (Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName == 'Branch Ops')) {
    body += 'Terms and Conditions: Please check the details of assigned line';
   }
   if (objSurrogateCAM.Line_opted__c == 'NO' && (Loan.StageName == 'Approved' || Loan.StageName == 'Post Approval Sales' || Loan.StageName == 'Branch Ops')) {
    body += 'Terms and Conditions: Please check the details of assigned line';
   }
   body = body.replaceAll('\r\n', '<br/>');
   body = body.replaceAll('\n', '<br/>');
   //body = body.replaceAll('\'','"');
   body = body.replace('\\', '&#92;');
   body = body.replace('"', '\\"');

   if (Grouptype == 'selfemployed') {
    body = body.replaceAll('Personal Loan', 'Business Loan');

   }


   String subject = 'Pricing Details LAN No: ' + loan.Loan_Application_Number__c;
   String[] SubWords = subject.split(' ');
   system.debug('=============>  LAN : ' + SubWords[4]);
   //String replyTo='otpofficeemailverification@2-ts7kreu4ln9259sftq01kgan.p-iadeay.cs31.apex.sandbox.salesforce.com';
   //String replyTo = 'otpofficeemailverification@2erwpc70t1emd8icvkxkdjbt8f7yj3b67837v2ztn6zhpm7jiz.9-hvufeag.ap1.apex.salesforce.com';
   //String replyTo='otpofficeemailverification@2nrzhj8tky9g6pfc6k8m7yt1k.p-iadeay.cs31.apex.sandbox.salesforce.com';
   String replyTo = Label.Pricing_Attchment_Email;
   system.debug('replay to ====>' + replyTo);

   // Start of production issue fix - bug 9594
   String fromEmail;
   if (Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL') {
    fromEmail = 'spl.mailconfirmation@bajajfinserv.in';
   } else {
    fromEmail = 'noreply@bajajfinserv.in';
   }
   // End of production issue fix - bug 9594
   system.debug('replyTo-------> ' + replyTo + 'toAdd-------> ' + toAdd + ' ccArray------>' + ccArray + ' bccArray' + bccArray);
   /* 16165 commercial mailer start */
   List < EmailTemplate > Templist = new List < EmailTemplate > ();
   String smsUrl = '';
   String smsUrlAppForm = '';
   Templist = [select id from EmailTemplate where Name = 'Commercial Concent Email VF'];
   system.debug('callCenterProcessFlag-------> ' + callCenterProcessFlag + 'salLineFlag-------> ' + salLineFlag + ' autoTopUp------>' + autoTopUp + ' cibilWatch' + cibilWatch);
   //Bug 20734 - commented cibilwatch
   //Rohit added for cc adhoc start 22314
   Map < String, Object > RescMap = new Map < String, Object > ();
   String ccId;
   RescMap = (Map < String, Object > )AllMap.get('BCCEmailId');// (Map < String, object > ) JSON.deserializeUntyped(CommonUtility.getStaticResourceData('SalariedCustomSettings', 'BCCEmailId', ''));
   //Rohit added for cc adhoc stop 22314
   if (((callCenterProcessFlag != null && callCenterProcessFlag == true) || Loan.Product__c == 'SBS CS SAL' || Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL') && salLineFlag != null && salLineFlag == false && autoTopUp != null && autoTopUp == false && cibilWatch != null && cibilWatch == false) {
    //added S
    if (loan.Account.Current_Email_Id__c != null) {
     toAdd.add(Loan.Account.Current_Email_Id__c);
    }
    //added E
    tokenNumber = String.valueOf(Integer.valueOf(Math.random() * 10000));
    applicantPrimary.token__c = tokenNumber;
    applicantPrimary1 = new Applicant__c();
    applicantPrimary1.token__c = applicantPrimary.token__c;
    smsUrl = Label.bflsiteuserURL + '/Customer_Commercial_Consent_Page?LoanId=' + encryptloanId  + '&EmailFor=EAgreement&Token=' + applicantPrimary.token__c;
    smsUrl = Commonutility.googleShortenUrl(smsUrl);
    smsUrlAppForm = Label.bflsiteuserURL + '/SAL_ApplicationForm?Id=' + encryptloanId;
    smsUrlAppForm = Commonutility.googleShortenUrl(smsUrlAppForm);
    applicantPrimary.Application_Form_Timestamp__c = 'Acceptance Pending'; //17556
    //Rohit added for cc adhoc start 22314

    if (!commonUtility.isEmpty(RescMap) ) {
     Map < String, Object > prodMap = new Map < String, Object > ();
     prodMap = (Map < String, Object > ) RescMap.get('PLTB');
     if (prodMap != null) //null check for map
     {
      ccId = (String) prodMap.get(Loan.Product__c.toUpperCase());
     if (ccId != null)
      ccArray.addAll(ccId.split(';'));
     }
     System.debug('robin ' + ccArray);
    }
    //Rohit added for cc adhoc stop 22314   
    PricingDisbmntDetails_Ctrl.SendEmailUsingBAFLLogix(conObj.id, loan.id, Templist[0].id, fromEmail, replyTo, toAdd, ccArray, bccArray, 'Normal', subject, 'bajaj');
   }
   /*16165 commercial mailer end*/
   //Cibil Watch Pramod S
   //commented for bug id 20296  start
   else if (cibilWatch) { //added else if for bug id 16165
    /*BAFL_EmailServicesLogix.Attachment[] arrAttachment = new List < BAFL_EmailServicesLogix.Attachment > ();
            PageReference pdf = new PageReference('/apex/CIBILWatchTermsAndConditions');
            pdf.getParameters().put('LoanId', (String) loan.id);
            pdf.getParameters().put('profees', String.valueOf(processingFee));
            pdf.setRedirect(true);
            Blob blobCibilWatchLetter;
            // Take the PDF content
            if (test.isrunningtest())
            blobCibilWatchLetter = Blob.valueOf('Test');
            else
            blobCibilWatchLetter = pdf.getContent();

            // Create Welcome Letter email attachment
           BAFL_EmailServicesLogix.Attachment eCibilWatchAtt = new BAFL_EmailServicesLogix.Attachment();
            eCibilWatchAtt.Name = 'CIBIL watch Terms and Conditions.pdf';
            String strCibilWatchLetter = EncodingUtil.base64Encode(blobCibilWatchLetter);
            eCibilWatchAtt.Data = strCibilWatchLetter;
            arrAttachment.add(eCibilWatchAtt);*/

    //system.debug('arrAttachment  Pramod--->>>' + arrAttachment);
    /*   BAFL_EmailServicesLogix.EmailServicesPort stub = new BAFL_EmailServicesLogix.EmailServicesPort();
            BAFL_EmailServicesLogix.SendEmailResponse er = stub.SendEmail(fromEmail,
            replyTo,
            toAdd,
            ccArray,
            bccArray,
            'Normal',
            arrAttachment,
            subject,
            body,
            'bajaj');*/
    //commented for bug id 20296  end
    //added for bug id 20296  start
    /* system.debug('inside cibilwatch'+cibilWatchComm);
            tokenNumber = String.valueOf(Integer.valueOf(Math.random()*10000));
            applicantPrimary.token__c = tokenNumber;
            applicantPrimary1 = new Applicant__c();
            applicantPrimary1.token__c = applicantPrimary.token__c;
            arrAttachment = new List < BAFL_EmailServicesLogix.Attachment > ();
                    PageReference pdf = new PageReference('/apex/CIBILWatchTermsAndConditions');
                    pdf.getParameters().put('LoanId', (String) loan.id);
                    pdf.getParameters().put('profees', String.valueOf(processingFee));
                    pdf.setRedirect(true);
                    Blob blobCibilWatchLetter;
                    // Take the PDF content
                    if (test.isrunningtest())
                    blobCibilWatchLetter = Blob.valueOf('Test');
                    else
                    blobCibilWatchLetter = pdf.getContent();

                    // Create Welcome Letter email attachment
                   BAFL_EmailServicesLogix.Attachment eCibilWatchAtt = new BAFL_EmailServicesLogix.Attachment();
                    eCibilWatchAtt.Name = 'CIBIL watch Terms and Conditions.pdf';
                    String strCibilWatchLetter = EncodingUtil.base64Encode(blobCibilWatchLetter);
                    eCibilWatchAtt.Data = strCibilWatchLetter;
                    arrAttachment.add(eCibilWatchAtt);
            cibilWatchComm = true;
            system.debug('flag is'+ cibilWatchComm);*/
    tokenNumber = String.valueOf(Integer.valueOf(Math.random() * 10000));
    applicantPrimary.token__c = tokenNumber;
    applicantPrimary1 = new Applicant__c();
    applicantPrimary1.token__c = applicantPrimary.token__c;
    PricingDisbmntDetails_Ctrl.SendEmailUsingBAFLLogix(conObj.id, loan.id, Templist[0].id, fromEmail, replyTo, toAdd, ccArray, bccArray, 'Normal', subject, 'bajaj');
    //added for bug id 20296  end

   }
   //Cibil Watch Pramod E
   else {
    BAFL_EmailServicesLogix.EmailServicesPort stub = new BAFL_EmailServicesLogix.EmailServicesPort();
    BAFL_EmailServicesLogix.SendEmailResponse er = stub.SendEmail(fromEmail,
     replyTo,
     toAdd,
     ccArray,
     bccArray,
     'Normal',
     new BAFL_EmailServicesLogix.Attachment[] {},
     subject,
     body,
     'bajaj');
   }
   /* 16165 sms code block start  */
   if (((callCenterProcessFlag == true || Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL' || Loan.Product__c == 'SBS CS SAL') && salLineFlag == false && autoTopUp == false && cibilWatch == false) || salMobilityFlag == true) {
    string smstext = '';

    if (Label.custagreementMsg != null && Label.custagreementMsg != '') {
     smstext = Label.custagreementMsg;
    }
    Map < String, String > dynPar = new Map < String, String > (); //Responsys Dynamic Parameters Bug 15653
    Rack_Rate__c custAgg = new Rack_Rate__c();
    system.debug('rrMaster ' + rrMaster);
    if (rrMaster != null && rrMaster.size() > 0) {
     for (Rack_Rate__c rr: rrMaster) {
      Set < String > rrProd = new Set < String > ();
      if (rr.Products__c != null)
       rrProd.addAll(rr.Products__c.split(';'));
      if (rr.Event__c == 'custagreementMsg' && rrProd.contains(Loan.Product__c)) { //changed event name from Customer Agreement SMS to custagreementMsg for bug id 16165
       custAgg = rr;
       system.debug('inside custagg>>>' + custAgg);
      }
     }
    }
    //Responsys Dynamic Parameters Bug 15653 s
    List < SMS_Sent__c > allsms = new List < SMS_Sent__c > ();
    if (setProdRes.contains(Loan.Product__c) && custAgg.Used_For__c == 'Responsys') {
     dynPar.put('P_LAN', Loan.Loan_Application_Number__c);
     dynPar.put('P_BITLY_AGREEMENT', smsUrl);
     dynPar.put('P_BITLY_APPFORM', smsUrlAppForm);
     system.debug('inside dynPar>>>' + dynPar);
     //dynPar.put('P_CUSTOMERNAME',applicantPrimary.Contact_Name__r.name);//commented for bug id 16165
    } else {
     if (!commonutility.isEmpty(applicantPrimary.Contact_Name__c))
      //smstext = smstext.replace('<Customer Name>', applicantPrimary.Contact_Name__r.name);//commented for bug id 16165
      smstext = smstext.replace('<LAN>', loan.Loan_Application_Number__c);
     smstext = smstext.replace('<Bitly_Agreement>', smsUrl);
     smstext = smstext.replace('<Bitly_App_Form>', smsUrlAppForm);
    }
    /*16165 sms code block end*/
    //Responsys Dynamic Parameters Bug 15653 e
    system.debug('smstext >>' + smstext);
    List < String > message = new List < string > ();
    List < string > mobileno = new List < string > ();

    /* 16165 sms insert code block start*/
    SMS_Sent__c sms = new SMS_Sent__c();
    sms.LoanApplication__c = Loan.Id;
    sms.Name = 'Customer Consent';
    sms.SMS_Receiver__c = 'Primary Applicant';
    sms.Email_sent__c = true;
    if (conObj != null && conObj.Office_Email_Id__c != null) {
     sms.Email_sent_at__c = conObj.Office_Email_Id__c;
    } else if (conObj != null && conObj.Email__c != null) {
     sms.Email_sent_at__c = conObj.Email__c;
    } else
     sms.Email_sent_at__c = toAddlist[0];

    sms.Email_sent_time__c = System.now();

    System.debug('Send SMS to Primary Applicant......');
    sms.SMS_Sent_Number__c = String.valueOf(applicantPrimary.Contact_Mobile__c);
    //Responsys Dynamic Parameters Bug 15653 s added if else
    if (!setProdRes.contains(Loan.Product__c) && custAgg.Used_For__c == 'Responsys') {
     sms.SMS_Text_Sent__c = smstext;
     sms.SMS_Sent_Time__c = system.now();
     sms.SMS_Sent__c = true;
     System.debug('here1 ');
     Datetime currtime = system.now();
     Integer hour = currtime.hour();
     if (hour > 9 && hour < 21)
      sms.Status__c = 'Sent';
     else
      sms.Status__c = 'Pending';

     System.debug('here2 ' + sms.Status__c);
    } else {
     sms.Event__c = custAgg.Campaign_name__c;
     sms.SMS_Parameters__c = JSON.serialize(dynPar);
     sms.Status__c = 'Pending';
    }
    allsms.add(sms);
    if (applicantPrimary.Contact_Mobile__c != null) {
     message.add(smstext);
     mobileno.add(applicantPrimary.Contact_Mobile__c);
    }
    if (message.size() > 0 && mobileno.size() > 0) {
     system.debug('inside sendsms');
     if (!setProdRes.contains(Loan.Product__c) && custAgg.Used_For__c == 'Responsys') {
      system.debug('inside responsys if');
     } else {
      system.debug('inside responsys else');
      sendsms.sendBulkSMS(message, mobileno);
     }
    }
    insert allsms;
    /*16165 sms insert code block end*/
    //Responsys Dynamic Parameters Bug 15653 e
   }
   // SAL PLTB changes added by priya end 

  }
  /* 16165 SALPL commercial consent start*/
  if (Grouptype == 'salaried' && applicantPrimary != null) {
   applicantPrimary.Send_pricing_email_to_customer__c = true;
   applicantPrimary.Commercial_Confirmation_Mail_Date__c = System.now();
   //Rohit commented cibil watch - 20734
   if ((callCenterProcessFlag == true || Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL') && salLineFlag == false && autoTopUp == false && cibilWatch == false) {
    applicantPrimary.IP_Address_Timestamp__c = 'Acceptance Pending';
    String mailerdata = firtEMIDate + ';' + lastEMIDate + ';' + emi;
    applicantPrimary.Customer_Decline_Reasons__c = mailerdata;
   }
   //tokenNumber = String.valueOf(Integer.valueOf(Math.random()*10000));
   //applicantPrimary.token__c = tokenNumber;
   upsert applicantPrimary;
  }
  /*16165 SALPL commercial consent end*/
  rateOfInterest = '';
  tenorOfMonths = 0;
  loanAmount = 0;
  loanAmountInsurence = 0;
  firtEMIDate = '';
  lastEMIDate = '';
  loantype = '-None-';
  processingFee = 0;
  brokenPeriodInt = '';
  emi = '';
  creditCard = '-None-';
  ffr = 0;
  if (Grouptype == 'salaried' && applicantPrimary != null) {
   applicantPrimary.Send_pricing_email_to_customer__c = true;
   applicantPrimary.Commercial_Confirmation_Mail_Date__c = System.now();
   /*SAL PLTB Changes 14951 added by Anshita Start*/
   if ((callCenterProcessFlag == true && salLineFlag == false && autoTopUp == false) || salMobilityFlag == true || Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL') {
    applicantPrimary.IP_Address_Timestamp__c = 'Acceptance Pending';
   }
   /*SAL PLTB Changes 14951 added by Anshita End*/
   upsert applicantPrimary;
  }

 }
 public void saveTopupDetails() {
  if (loan != null) {
   upsert loan;
  }
 }
 //End
 public void saveLineDetails() {
  if (objSurrogateCAM != null) {
   //if(objSurrogateCAM.Line_opted__c=='YES'){
   //objSurrogateCAM.Line_flag__c='I';
   //}

   //if(objSurrogateCAM.Line_opted__c=='NO')
   //objSurrogateCAM.Line_flag__c='';
   if (objSurrogateCAM.Line_assigned_basis_Credit_Assessment__c != null && objSurrogateCAM.Line_assigned_basis_Credit_Assessment__c > 0) {
    //if line assigned is >0 AND customeracceptanceflag = y AND feespaid = y, then lineactiveflag = y
    if (objSurrogateCAM.Line_opted__c == 'YES' && objSurrogateCAM.Fees_Paid__c == 'YES')
     objSurrogateCAM.Line_Active_Flag__c = 'YES';
    else if (objSurrogateCAM.risk_category__c == 'High')
     objSurrogateCAM.Line_Active_Flag__c = 'NO';

   }



   upsert objSurrogateCAM;
  }
  if (objSurrogateCAM.Line_opted__c == 'NO') {
   fees = new List < Fees_and_Charge__c > ();
   fees = [select id, name, Loan_Application__r.name, Charge_Type__c, Deducted_from_Disbursement__c, Deposition_Date__c, Deposit_Slip_Number__c,
    Service_Charge__c, Status__c, Change_Amount__c, Instrument_Date__c, Instrument_No__c, Bank_Branch__c, Charge__c, Instrument_type__c,
    Amount_after_Service_Change__c, Disbursement_Number__c from Fees_and_Charge__c where Loan_Application__c =: loan.id and Charge_Type__c = 'Line Utilization'
    and Change_Amount__c != null and Deducted_from_Disbursement__c = 'Yes'
   ];
   if (fees.sizE() > 0)
    delete fees;

  }

  if (objSurrogateCAM.Line_opted__c == 'YES') {

   system.debug('*** fees size ' + fees1.size());
   if (fees1.size() == 0) {
    system.debug('create fees');
    Fees_and_Charge__c fee = new Fees_and_Charge__c();
    fee.Charge_Type__c = 'Line Utilization';
    fee.Deducted_from_Disbursement__c = 'Yes';
    fee.Loan_Application__c = Loan.id;
    fee.Status__c = 'Collected';
    fee.Instrument_type__c = 'Deduct from Disb';
    /*if(ProductSMS__c.getValues(Loan.product__c).Charges__c!=null){
    fee.Change_Amount__c=Integer.valueof(ProductSMS__c.getValues(Loan.product__c).Line_Charges__c);

}*/
    integer lineCharges = 0;
    if (objSurrogateCAM.Line_assigned_basis_Credit_Assessment__c != null) {
     if (ProductSMS__c.getValues(loan.Product__c) != null && ProductSMS__c.getValues(loan.Product__c).MaxLineAssignedAmount__c != null) {
      Integer MAXlineCharges = Integer.valueof(ProductSMS__c.getValues(loan.Product__c).MaxLineAssignedAmount__c);
      if (objSurrogateCAM.Line_assigned_basis_Credit_Assessment__c < MAXlineCharges)
       lineCharges = Integer.valueof(ProductSMS__c.getValues(loan.Product__c).LineFeesLessThanMaxLineAmount__c);
      else if (objSurrogateCAM.Line_assigned_basis_Credit_Assessment__c > MAXlineCharges)
       lineCharges = Integer.valueof(ProductSMS__c.getValues(loan.Product__c).LineFeesMoreThanMaxLineAmount__c);
     }
    }
    fee.Change_Amount__c = lineCharges;
    objSurrogateCAM.Fee_Amount__c = lineCharges;


    insert fee;
   }
  }
 }


 //Open ECS
 public void callOpenECS() {
  //primary applicant contact 
  Contact contObj = new Contact();
  List < Contact > primConObjlist = new List < contact > ();

  primConObjlist = [select CIF_Id__c, Email__c, id from Contact where id =: applicantPrimary.Contact_Name__c limit 1];
  if (primConObjlist.size() > 0)
   contObj = primConObjlist[0];
  if (contObj.CIF_Id__c != null) {
   //Cash in 60 mins :: added in quer A_C_type__c 
   //ECS_Barcode_No__c removed
   //17547--added UMRN__c
   RepayList = [select id, UMRN__c, A_C_type__c, ECS_Barcode_No__c, Open_ECS_Facility__c, Open_ECS_Ex_Customer_Id__c, Open_Valid_till__c, Open_ECS_Max_Limit__c, ECS_Start_Date__c, ECS_End_Date__c, ECS_Amount__c, name, Loan_Application__c, A_C_NO__c, MICR_Code__c, PDC_START_DATE__c, IFSC_Code__c, Account_Holder_Name__c,
    Bank_Name__c, No_of_Cheques__c, Cheque_Serial_Number__c, Repayment_Mode__c, To_Cheque_Serial_Number__c,
    Cheque_Amount__c, Tranche_Detail__c,
    Bank_Branch__c, PDC_By_Name__c
    from RePayment_mode_detail__c where Loan_Application__c =: Loan.Id
   ];
   if (RepayList.size() > 0)
    repayFlag = true;
   //added by Suraj...ECS Mandate enhancement      
   MAP < String, String > openESCMAP = new MAP < String, String > ();
   openESCMAP = BRECallout.RestAPICallForOpenECS(contObj.CIF_Id__c);
   system.debug('--openESCMAP --' + openESCMAP);
   if (openESCMAP != null && openESCMAP.size() > 0) {
    if (openESCMAP.get('ecsErrMsg') == null) {
     if (RepayList != null && RepayList.size() > 0) {
      system.debug('--openESCMAP.get-ecsErrMsg--' + openESCMAP.get('ecsErrMsg'));
      if (openESCMAP.get('balLimit') != null)
       RepayList[0].Open_ECS_Max_Limit__c = Decimal.valueOf(openESCMAP.get('balLimit'));
      RepayList[0].MICR_Code__c = Decimal.valueOf(openESCMAP.get('micrCode'));
      RepayList[0].ECS_End_Date__c = Date.valueOf(openESCMAP.get('endDate'));
      RepayList[0].Bank_name__c = openESCMAP.get('bankName');
      RepayList[0].A_C_NO__c = openESCMAP.get('accNo');
      //RepayList[0].A_C_NO__c = openESCMAP.get('ecsErrMsg');
      RepayList[0].Loan_Application__c = Loan.Id;
      upsert RepayList;
      if (RepayList.size() > 0)repayFlag = true;
      //added by Suraj...ECS Mandate enhancement  
     } else {
      RePayment_mode_detail__c repayObj = new RePayment_mode_detail__c();
      repayObj.Open_ECS_Max_Limit__c = Decimal.valueOf(openESCMAP.get('balLimit'));
      repayObj.MICR_Code__c = Decimal.valueOf(openESCMAP.get('micrCode'));
      repayObj.ECS_End_Date__c = Date.valueOf(openESCMAP.get('endDate'));
      repayObj.Bank_name__c = openESCMAP.get('bankName');
      repayObj.A_C_NO__c = openESCMAP.get('accNo');
      // repayObj.ECS_Error_Msg__c = openESCMAP.get('ecsErrMsg');
      repayObj.Loan_Application__c = Loan.Id;
      upsert repayObj;
      if (RepayList.size() > 0)
       repayFlag = true;
      //added by Suraj...ECS Mandate enhancement  

     }
    }
   }

  }
 }

 //--------------- Mortgage Re-Engg Start---------------------
 public List < SelectOption > getKitAcceptanceSelect() {
  List < SelectOption > options = new List < SelectOption > ();
  options.add(new SelectOption('None', 'None'));
  options.add(new SelectOption('Accepted', 'Accepted'));
  options.add(new SelectOption('Not Accepted', 'Not Accepted'));
  return options;
 }

 public void saveApprovalDetails() {
  try {
   List < sObject > Objects = new List < SObject > ();
   if (Loan.Loan_Amount_with_Premium__c != null && Loan.AMC__c != null) {
    feesMortgage.Payment_Status__c = (Loan.Loan_Amount_with_Premium__c * Loan.AMC__c) / 100;
    system.debug('---feesMortgage.Payment_Status__c---' + feesMortgage.Payment_Status__c);
   }

   upsert feesMortgage;
   feesMortgage = [Select Bank_Branch__c, Change_Amount__c, AWB_number__c, Cheque_Status__c, Courier_company_name__c, Cheque_Number__c, Paid_Amount__c, Deposit_Slip_Number__c, Instrument_No__c, Payment_Status__c, Service_Charge__c, RETURN_REASON__c, TxnReferenceNo__c, Requested_Insurance__c, Insurance_LI__c,
    Insurance_Term__c, FFR__c, VAS4__c, VAS5__c, Mortgage_plus_ROI__c, Requested_Payout__c, BT_Top_Disbursement_together__c, Interest_bearing_letter__c, Part_payment_charges__c, SM_ASM_Name__c, Stamped_PF__c, Stamped_insurance__c, Foreclosuer_charges__c
    From Fees_and_Charge__c Where id =: feesMortgage.id
   ];
   Objects.add(applicantPrimary);
   Objects.add(Loan);update Objects;
  } catch (Exception e) {
   System.debug(e.getMessage());
  }

 }

 public void saveBankDetails() {
  try {
   if (bankList.size() > 0) {
    update bankList;
   }
   bankList = SelectQueriesHelperClass.QueryBankAccountsMortgage(Loan.id);
   System.debug(bankList.size() + '=bankList.size()');

  } catch (Exception e) {
   System.debug(e.getMessage());
  }
 }

 public void savePropDetails() {
  try {
   if (propertyList.size() > 0) {
    update propertyList;
   }
   propertyList = SelectQueriesHelperClass.QueryPropertyDetailsMortgage(Loan.id);
   System.debug(bankList.size() + '=bankList.size()');
   //V1 refinement Enhancement start
   prop = propertyList[0];
   if (displayPricingGrid) {calculateformulas(propertyList, Hinsurance);
   }
   //V1 refinement Enhancement end

  } catch (Exception e) {
   System.debug(e.getMessage());
  }
 }

 public void sendEmailToBH() {
  try {
   List < String > toAddlist = new List < String > ();
   List < String > toAddlistCC = new List < String > ();

   System.debug('In BH mail...');

   if (loan.Business_Head__c != null) {
    System.debug('Email=' + loan.Business_Head__r.Email);
    toAddlist.add(loan.Business_Head__r.Email);
   }

   //if (loan.Accountant_email_id__c != null)
   //toAddlist.add('amitkumar_kohakade@persistent.co.in');

   if (toAddlist.size() > 0) {

    propertyList = SelectQueriesHelperClass.QueryPropertyDetailsMortgage(Loan.id);
    System.debug(propertyList.size() + '=propertyList.size()');
    bankList = SelectQueriesHelperClass.QueryBankAccountsMortgage(Loan.id);
    System.debug(bankList.size() + '=bankList.size()');

    List < Fees_and_Charge__c > feesTempList = new List < Fees_and_Charge__c > ();
    feesTempList = SelectQueriesHelperClass.QueryFeesMortgage(Loan.id);
    if (feesTempList.size() > 0)
     feesMortgage = feesTempList[0];


    String[] toAdd = toAddlist;
    String[] ccArray = toAddlistCC;
    String[] bccArray;
    System.debug('toAddlist' + toAddlist + 'toAddlistCC=' + toAddlistCC);

    String body = 'Hi ' + loan.Business_Head__r.Name + ',\n &nbsp;&nbsp; Please check Commercial Approval Details and reply to same mail as Approve or Reject without changing Subject Line. Please find details below:\n\n Loan Application Number: ' + loan.Loan_Application_Number__c + '\nName: ' + applicantPrimary.Contact_Name__r.Name + '\n\n';

    //body +='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><title>Bajaj Finserv</title><style type="text/css"></style></head><body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="color: #000000; font-family: Arial, Helvetica, sans-serif; font-size: 15px"><table width="780" border="0" cellpadding="0" cellspacing="0" style="border: 1px #949494 solid" align="center"><tr><td valign="top" colspan="5"><table border="0" cellpadding="0" cellspacing="0"><td ><a href="http://www.bajajfinserv.in/finance/?utm_source=May_PL_Email_Loan_Approved_BF&utm_medium=Email&utm_campaign=PL_Generic" target="_blank"><img src="https://c.cs31.visual.force.com/resource/1461839189000/BajajFinServLogo" height="83" alt="Bajaj Finserv" title="Bajaj Finserv" align="right" border="0" /></a></td></table></td></tr><tr> <td colspan="5" valign="top" style="padding: 5px 0 10px 12px;"><div style="font-size: 15px; font-weight: bold;">Commercial Approval Details</div></td></tr><tr><td height="366" colspan="5" valign="top" style="padding:0 0 5px 0;"><table width="100%" border="0" cellpadding="0" cellspacing="0" ><tr><td width="467px" height="361" valign="top"><table style="width: 100%;line-height: 2;" border="1"><tr><td style="width: 16%;">Customer Type </td><td style="width: 16%;">'+Loan.customer_type__c+'</td><td style="width: 16%;">Customer Segmentation</td><td style="width: 16%;">'+applicantPrimary.SegmentaionResult__c+'</td><td style="width: 16%;">SFDC ID</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Product </td><td style="width: 16'+Loan.Product__c+'</td><td style="width: 16%;">Loan type </td><td style="width: 16%;">'+Loan.Type_Of_Loan__c+'</td><td style="width: 16%;">Transcation type</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Flexi saver Scheme</td><td style="width: 16%;"></td><td style="width: 16%;">Location </td><td style="width: 16%;"></td><td style="width: 16%;">Customer Name</td><td style="width: 16%;">'+applicantPrimary.Contact_Name__r.Name+'</td></tr><tr><td style="width: 16%;">BT loan Amount </td><td style="width: 16%;"></td><td style="width: 16%;">BT Bank Name</td><td style="width: 16%;"></td><td style="width: 16%;">Top-up</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Stamped ROI BT </td><td style="width: 16%;"></td><td style="width: 16%;">Stamped ROI Top-up</td><td style="width: 16%;"></td><td style="width: 16%;">Requested BT ROI</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Requested Top ROI</td><td style="width: 16%;"></td><td style="width: 16%;">Requested ROI</td><td style="width: 16%;"></td><td style="width: 16%;">Stamped PF</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Requested BT PF</td><td style="width: 16%;"></td><td style="width: 16%;">Requesetd Top PF</td><td style="width: 16%;"></td><td style="width: 16%;">Stamped insurance </td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Requested  Insurance </td><td style="width: 16%;"></td> <td style="width: 16%;">Insurance GI </td><td style="width: 16%;"></td><td style="width: 16%;">Insurance LI </td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Insurance Type</td><td style="width: 16%;"></td><td style="width: 16%;">Insurance Term</td><td style="width: 16%;"></td><td style="width: 16%;">Property Dossier</td><td style="width: 16%;">'+applicantPrimary.Property_Dossier_Report__c+'</td></tr><tr><td style="width: 16%;">FFR</td><td style="width: 16%;"></td><td style="width: 16%;">ELC/REMI Card </td><td style="width: 16%;">'+Loan.ELC_offer_accepted__c+'</td><td style="width: 16%;">VAS 4</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">MOF waiver </td><td style="width: 16%;">'+Loan.Premium_Amount__c+'</td><td style="width: 16%;">VAS 5</td><td style="width: 16%;"></td><td style="width: 16%;">Overall WtIIR</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Channel Type </td><td style="width: 16%;">'+Loan.Sourcing_Channel_Type__c+'</td><td style="width: 16%;">Mortgage Plus loan amount </td><td style="width: 16%;"></td><td style="width: 16%;">Mortgage plus ROI </td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Mortgage Plus PF </td><td style="width: 16%;"></td><td style="width: 16%;">Disbusemnet mode </td><td style="width: 16%;">'+Loan.Disbursement_Type__c+'</td><td style="width: 16%;">CF/PF/Lock in FEE in Rs.</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Requested Payout</td><td style="width: 16%;"></td><td style="width: 16%;">Total loan amount (including insurance amount and PD)</td><td style="width: 16%;">'+Loan.Loan_Amount_with_Premium__c+'</td><td style="width: 16%;">BT-Top Disbursement together</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">AMC Charges</td><td style="width: 16%;">'+Loan.AMC__c+'</td><td style="width: 16%;">AMC %</td><td style="width: 16%;"></td><td style="width: 16%;">Foreclosuer charges</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Interest bearing letter</td><td style="width: 16%;"></td><td style="width: 16%;">Special Remarks</td><td style="width: 16%;"></td><td style="width: 16%;">Part-payment charges</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">SM/ASM Name</td><td style="width: 16%;"></td><td style="width: 16%;">Submitted To</td><td style="width: 16%;"></td><td style="width: 16%;">Special Recommendation</td> <td style="width: 16%;"></td></tr></table></td></tr></table></td></tr><tr><td style="padding:7px 14px 0 12px" colspan="5"><table width="228px" border="0" cellpadding="0" cellspacing="0" align="left"><tr><td valign="top"><img src="https://cs6.salesforce.com/servlet/servlet.ImageServer?id=015N0000000HrHj&oid=00DN0000000Un0W" width="111" height="35" alt="Connect with us" title="Connect with us" align="left" border="0" /></td><td valign="top"><a href="https://www.facebook.com/bajajfinserv?sk=app_190322544333196" target="_blank"><img src="https://cs6.salesforce.com/servlet/servlet.ImageServer?id=015N0000000HrHo&oid=00DN0000000Un0W" width="42" height="35" alt="Facebook" title="Facebook" align="left" border="0" /></a></td><td valign="top"><a href="https://twitter.com/Bajaj_Finserv" target="_blank"><img src="https://cs6.salesforce.com/servlet/servlet.ImageServer?id=015N0000000HrHy&oid=00DN0000000Un0W" width="40" height="35" alt="twitter" title="twitter" align="left" border="0" /></a></td><td valign="top"><a href="http://www.linkedin.com/company/1092003?trk=tyah" target="_blank"><img src="https://cs6.salesforce.com/servlet/servlet.ImageServer?id=015N0000000HrHt&oid=00DN0000000Un0W" width="35" height="35" alt="LinkedIn" title="LinkedIn" align="left" border="0" /></a></td></tr></table></td></tr><tr><td valign="top" colspan="5" style="padding: 10px 14px 10px 12px;"><div style="line-height:18px; font-size:13px;">Terms and conditions apply</div></td></tr><tr><td valign="top" colspan="5" style="padding: 10px 14px 10px 12px;"><div style="line-height:18px; font-size:13px;"><img src="https://c.cs31.visual.force.com/resource/1422952355000/BajajLowerLogo" width="179" height="21" alt="Bajaj Finserv" title="Bajaj Finserv" align="right" border="0" /></div></td></tr></table></body></html>';

    // body +='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><title>Bajaj Finserv</title><style type="text/css"></style></head><body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="color: #000000; font-family: Arial, Helvetica, sans-serif; font-size: 15px"><table width="780" border="0" cellpadding="0" cellspacing="0" style="border: 1px #949494 solid" align="center"><tr><td height="366" colspan="5" valign="top" style="padding:0 0 5px 0;"><table width="100%" border="0" cellpadding="0" cellspacing="0" ><tr><td width="467px" height="361" valign="top"><table style="width: 100%;line-height: 2;" border="1"><tr><td style="width: 16%;">Customer Type </td><td style="width: 16%;">'+Loan.customer_type__c+'</td><td style="width: 16%;">Customer Segmentation</td><td style="width: 16%;">'+applicantPrimary.SegmentaionResult__c+'</td><td style="width: 16%;">SFDC ID</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Product </td><td style="width: 16%;">'+Loan.Product__c+'</td><td style="width: 16%;">Loan type </td><td style="width: 16%;">'+Loan.Type_Of_Loan__c+'</td><td style="width: 16%;">Transcation type</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Flexi saver Scheme</td><td style="width: 16%;"></td><td style="width: 16%;">Location </td><td style="width: 16%;"></td><td style="width: 16%;">Customer Name</td><td style="width: 16%;">'+applicantPrimary.Contact_Name__r.Name+'</td></tr><tr><td style="width: 16%;">BT loan Amount </td><td style="width: 16%;"></td><td style="width: 16%;">BT Bank Name</td><td style="width: 16%;"></td><td style="width: 16%;">Top-up</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Stamped ROI BT </td><td style="width: 16%;"></td><td style="width: 16%;">Stamped ROI Top-up</td><td style="width: 16%;"></td><td style="width: 16%;">Requested BT ROI</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Requested Top ROI</td><td style="width: 16%;"></td><td style="width: 16%;">Requested ROI</td><td style="width: 16%;"></td><td style="width: 16%;">Stamped PF</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Requested BT PF</td><td style="width: 16%;"></td><td style="width: 16%;">Requesetd Top PF</td><td style="width: 16%;"></td><td style="width: 16%;">Stamped insurance </td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Requested  Insurance </td><td style="width: 16%;"></td> <td style="width: 16%;">Insurance GI </td><td style="width: 16%;"></td><td style="width: 16%;">Insurance LI </td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Insurance Type</td><td style="width: 16%;"></td><td style="width: 16%;">Insurance Term</td><td style="width: 16%;"></td><td style="width: 16%;">Property Dossier</td><td style="width: 16%;">'+applicantPrimary.Property_Dossier_Report__c+'</td></tr><tr><td style="width: 16%;">FFR</td><td style="width: 16%;"></td><td style="width: 16%;">ELC/REMI Card </td><td style="width: 16%;">'+Loan.ELC_offer_accepted__c+'</td><td style="width: 16%;">VAS 4</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">MOF waiver </td><td style="width: 16%;">'+Loan.Premium_Amount__c+'</td><td style="width: 16%;">VAS 5</td><td style="width: 16%;"></td><td style="width: 16%;">Overall WtIIR</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Channel Type </td><td style="width: 16%;">'+Loan.Sourcing_Channel_Type__c+'</td><td style="width: 16%;">Mortgage Plus loan amount </td><td style="width: 16%;"></td><td style="width: 16%;">Mortgage plus ROI </td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Mortgage Plus PF </td><td style="width: 16%;"></td><td style="width: 16%;">Disbusemnet mode </td><td style="width: 16%;">'+Loan.Disbursement_Type__c+'</td><td style="width: 16%;">CF/PF/Lock in FEE in Rs.</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Requested Payout</td><td style="width: 16%;"></td><td style="width: 16%;">Total loan amount (including insurance amount and PD)</td><td style="width: 16%;">'+Loan.Loan_Amount_with_Premium__c+'</td><td style="width: 16%;">BT-Top Disbursement together</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">AMC Charges</td><td style="width: 16%;">'+Loan.AMC__c+'</td><td style="width: 16%;">AMC %</td><td style="width: 16%;"></td><td style="width: 16%;">Foreclosuer charges</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Interest bearing letter</td><td style="width: 16%;"></td><td style="width: 16%;">Special Remarks</td><td style="width: 16%;"></td><td style="width: 16%;">Part-payment charges</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">SM/ASM Name</td><td style="width: 16%;"></td><td style="width: 16%;">Submitted To</td><td style="width: 16%;"></td><td style="width: 16%;">Special Recommendation</td> <td style="width: 16%;"></td></tr></table></td></tr></table></td></tr></table></body></html>';
    System.debug('loan.Business_Head__r.Name' + loan.Business_Head__r.Name);
    system.debug('loan.Loan_Application_Number__c' + loan.Loan_Application_Number__c);
    system.debug('applicantPrimary.Contact_Name__r.Name ' + applicantPrimary.Contact_Name__r.Name);
    body += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><title>Bajaj Finserv</title><style type="text/css"></style></head><body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="color: #000000; font-family: Arial, Helvetica, sans-serif; font-size: 15px">';

    body += '<table width="800" border="1" cellpadding="0" cellspacing="0" style="border: 1px #949494 solid" align="center" ><tr style="text-align: center;"><td Style="Width:2%;">Sr No</td><td Style="Width:2%;">Property</td><td Style="Width:5%;">Property Address</td><td Style="Width:4%;">Property Type</td><td Style="Width:4%;">Transaction Type</td><td Style="Width:4%;">Property Usage</td></tr>';

    integer cnt;

    for (integer i = 0; i < propertyList.size(); i++) {
     cnt = i + 1;
     body += '<tr style="text-align: center;"><td>' + cnt + '</td><td>' + propertyList[i].Name + '</td><td>' + propertyList[i].Address__c + '</td><td>' + propertyList[i].Property_Type__c + '</td><td>' + propertyList[i].Property_Transaction_Type__c + '</td><td>' + propertyList[i].Property_Usage__c + '</td></tr>';
    }

    body += '</table><br/><br/><table width="800" border="1" cellpadding="0" cellspacing="0" style="border: 1px #949494 solid" align="center"><tr style="text-align: center;"><td Style="Width:2%;">Sr No</td><td Style="Width:4%;">BT Bank Name</td><td Style="Width:3%;">BT loan Amount</td><td Style="Width:3%;">Top-up</td><td Style="Width:2%;">Stamped ROI BT</td><td Style="Width:2%;">Stamped ROI Top-up</td>';
    body += '<td Style="Width:2%;">Requested BT ROI</td><td Style="Width:2%;">Requested Top ROI</td><td Style="Width:2%;">Requested ROI</td><td Style="Width:3%;">Requested BT PF</td><td Style="Width:3%;">Requesetd Top PF</td></tr>';

    for (integer i = 0; i < bankList.size(); i++) {
     cnt = i + 1;
     body += '<tr style="text-align: center;"><td>' + cnt + '</td><td>' + bankList[i].Buy_Over_Bank1__c + '</td><td>' + bankList[i].BT_Loan_Amount1__c + '</td><td>' + bankList[i].BT_Loan_Amount2__c + '</td><td>' + bankList[i].Avg_mthly_bal_Coapp_SAL__c + '</td><td>' + bankList[i].Rate_of_OD_CC__c + '</td><td>' + bankList[i].BT_MOB3__c + '</td><td>' + bankList[i].BT_MOB2__c + '</td><td>' + bankList[i].roi__c + '</td><td>' + bankList[i].BT_MOB1__c + '</td><td>' + bankList[i].BT_Loan_Amount3__c + '</td></tr> ';
    }

    body += '</table><br/><br/><table style="width: 100%;line-height: 2;" ><tr><td style="width: 16%;">Customer Type </td><td style="width: 16%;">' + Loan.Customer_Type__c + '</td><td style="width: 16%;">Customer Segmentation</td><td style="width: 16%;">' + applicantPrimary.SegmentaionResult__c + '</td><td style="width: 16%;">SFDC ID</td><td style="width: 16%;"></td></tr><tr><td style="width: 16%;">Product </td><td style="width: 16%;">' + Loan.Product__c + '</td><td style="width: 16%;">Loan type </td><td style="width: 16%;">' + Loan.Type_Of_Loan__c + '</td><td style="width: 16%;">Flexi saver Scheme</td><td style="width: 16%;">' + feesMortgage.Bank_Branch__c + '</td></tr><tr><td style="width: 16%;">Location </td><td style="width: 16%;">' + Loan.BranchName__c + '</td><td style="width: 16%;">Customer Name</td><td style="width: 16%;">' + applicantPrimary.Contact_Name__r.Name + '</td><td style="width: 16%;">Stamped PF</td><td style="width: 16%;">' + feesMortgage.Stamped_PF__c + '</td></tr><tr><td style="width: 16%;">Stamped insurance </td><td style="width: 16%;">' + feesMortgage.Stamped_insurance__c + '</td><td style="width: 16%;">Requested  Insurance </td><td style="width: 16%;">' + feesMortgage.Requested_Insurance__c + '</td><td style="width: 16%;">Insurance GI </td><td style="width: 16%;">' + feesMortgage.Requested_Insurance__c + '</td></tr><tr><td style="width: 16%;">Insurance LI </td><td style="width: 16%;">' + feesMortgage.Insurance_LI__c + '</td><td style="width: 16%;">Insurance Type</td><td style="width: 16%;">' + feesMortgage.AWB_number__c + '</td><td style="width: 16%;">Insurance Term</td><td style="width: 16%;">' + feesMortgage.Insurance_Term__c + '</td></tr><tr><td style="width: 16%;">Property Dossier</td><td style="width: 16%;">' + applicantPrimary.Property_Dossier_Report__c + '</td><td style="width: 16%;">FFR</td><td style="width: 16%;">' + feesMortgage.FFR__c + '</td><td style="width: 16%;">ELC/REMI Card </td><td style="width: 16%;">' + Loan.ELC_offer_accepted__c + '</td></tr><tr><td style="width: 16%;">VAS 4</td><td style="width: 16%;">' + feesMortgage.VAS4__c + '</td><td style="width: 16%;">MOF waiver </td><td style="width: 16%;">' + feesMortgage.Insurance_LI__c + '</td><td style="width: 16%;">VAS 5</td><td style="width: 16%;">' + feesMortgage.VAS5__c + '</td></tr><tr><td style="width: 16%;">Overall WtIIR</td><td style="width: 16%;">' + feesMortgage.Cheque_Number__c + '</td><td style="width: 16%;">Channel Type </td><td style="width: 16%;">' + Loan.Sourcing_Channel_Type__c + '</td><td style="width: 16%;">Mortgage Plus loan amount </td><td style="width: 16%;">' + feesMortgage.Paid_Amount__c + '</td></tr><tr><td style="width: 16%;">Mortgage plus ROI </td><td style="width: 16%;">' + feesMortgage.Mortgage_plus_ROI__c + '</td><td style="width: 16%;">Mortgage Plus PF </td><td style="width: 16%;">' + feesMortgage.Deposit_Slip_Number__c + '</td><td style="width: 16%;">Disbusemnet mode </td><td style="width: 16%;">' + Loan.Disbursement_Type__c + '</td></tr><tr>  <td style="width: 16%;">CF/PF/Lock in FEE in Rs.</td><td style="width: 16%;">' + feesMortgage.Instrument_No__c + '</td><td style="width: 16%;">Requested Payout</td><td style="width: 16%;">' + feesMortgage.Requested_Payout__c + '</td><td style="width: 16%;">Total loan amount (including insurance amount and PD)</td><td style="width: 16%;">' + Loan.Loan_Amount_with_Premium__c + '</td></tr><tr><td style="width: 16%;">BT-Top Disbursement together</td><td style="width: 16%;">' + feesMortgage.BT_Top_Disbursement_together__c + '</td><td style="width: 16%;">AMC Charges</td><td style="width: 16%;">' + feesMortgage.Payment_Status__c + '</td><td style="width: 16%;">AMC %</td><td style="width: 16%;">' + Loan.AMC__c + '</td></tr><tr><td style="width: 16%;">Foreclosuer charges</td><td style="width: 16%;">' + feesMortgage.Foreclosuer_charges__c + '</td><td style="width: 16%;">Interest bearing letter</td><td style="width: 16%;">' + feesMortgage.Interest_bearing_letter__c + '</td><td style="width: 16%;">Special Remarks</td><td style="width: 16%;">' + feesMortgage.RETURN_REASON__c + '</td></tr><tr><td style="width: 16%;">Part-payment charges</td><td style="width: 16%;">' + feesMortgage.Part_payment_charges__c + '</td><td style="width: 16%;">SM/ASM Name</td><td style="width: 16%;">' + feesMortgage.SM_ASM_Name__c + '</td><td style="width: 16%;">Special Recommendation</td><td style="width: 16%;">' + feesMortgage.TxnReferenceNo__c + '</td></tr></table>';


    body = body.replaceAll('\r\n', '<br/>'); body = body.replaceAll('\n', '<br/>');
    //body = body.replaceAll('\'','"');
    body = body.replace('\\', '&#92;');body = body.replace('"', '\\"');


    String subject = 'Commercial Approval Details LAN No: ' + loan.Loan_Application_Number__c + ' Submitted for Approval';
    String[] SubWords = subject.split(' ');
    system.debug('body ' + body);
    String replyTo = 'deviationaction@1me8tlcb9shodbk998kdxf6nh.p-faieaa.cs31.apex.sandbox.salesforce.com';

    BAFL_EmailServicesLogix.EmailServicesPort stub = new BAFL_EmailServicesLogix.EmailServicesPort();
    BAFL_EmailServicesLogix.SendEmailResponse er = stub.SendEmail('noreply@bajajfinserv.in',
     replyTo,
     toAdd,
     ccArray,
     bccArray,
     'Normal',
     new BAFL_EmailServicesLogix.Attachment[] {},
     subject,
     body,
     'bajaj');

   }

  } catch (Exception e) {
   System.debug('Exception occurred : 7575 ' + e);
   System.debug(e.getMessage());
  }

 }



 //--------------- Mortgage Re-Engg End-----------------------
 //ADhoc related to pricing email before branch ops
 public void updateSendPricingEmailToCustomer() {

  if (applicantPrimary.Send_pricing_email_to_customer__c == true) {
   //prod issue 11237 by ranjit S  
   //sendPricingEmail();
   //prod issue 11237 by ranjit E
   applicantPrimary.Commercial_Confirmation_Mail_Date__c = System.now();
   upsert applicantPrimary;
  }
 }

 //******* reEngg_OfferLetter  - START @gaurav
 public PageReference emailOfferLetterToCustomer() {

  // Define the email
  Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

  // Reference the attachment page and pass in the Loan ID
  PageReference pdf = Page.ReEngg_OfferLetter;

  //added by mahima- start-- sanction letter enhancement
  if (loan.product__c == 'Home Loan' || loan.product__c == 'LAP')
   pdf = Page.ReEngg_OfferLetter_HL_LAP;
  //added by mahima- end-- sanction letter enhancement

  pdf.getParameters().put('id', (String) LoanId);
  pdf.setRedirect(true);

  PageReference pdf_ann = Page.HL_Annexure;
  pdf_ann.getParameters().put('id', (String) LoanId);
  pdf_ann.setRedirect(true);

  Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
  Messaging.EmailFileAttachment efb = new Messaging.EmailFileAttachment();

  // Take the PDF content
  if (!Test.isRunningTest()) {
   Blob b = pdf.getContent();
   Blob c = pdf_ann.getContent();

   // Create the email attachment
   efa.setFileName('Offer Letter.pdf');efa.setBody(b);
   efb.setFileName('Annexure.pdf');efb.setBody(c);
   email.setFileAttachments(new Messaging.EmailFileAttachment[] {
    efa,
    efb
   });
  }

  EmailTemplate templateId = [Select id from EmailTemplate where name = 'ReEngg_OfferLetter'
   Limit 1
  ];
  system.debug('Template Id: ' + templateId.Id);
  // Set the paramaters of the email
  email.setTemplateID(templateId.Id);


  //15580--added Dedupe_Linking_Done__c 
  List < Applicant__c > AppList = [SELECT Financial_Health_Check_Guide__c, id, Dedupe_Linking_Done__c, EMI_Holiday_Opted__c, Contact_ID__c, Applicant_Type__c, Contact_Name__r.Id, Contact_Name__r.Employer__r.Company_Name__c, Contact_Name__r.Employer__r.Company_Category__c, Cycle_Day_Date__c, RSA_flag__c, RSA_Loan_application_status__c, /* bug 17556 s*/ PFApproveStatus__c /* bug 17556 e*/ /*21288 AP : Defect 22889*/ , Cross_Collateral_LAN__c from Applicant__c where Loan_Application__c =: LoanId AND Applicant_Type__c = 'Primary'];
  if (!CommonUtility.isEmpty(AppList)) {
   Applicant__c app = AppList[0];
   email.setTargetObjectId(app.Contact_ID__c);
   //Added by mahima- SME offer letter-- start
   List < String > toAddres = new List < String > ();
   if (loan.account != null && loan.account.Current_Email_Id__c != null) {
    toAddres.add(loan.account.Current_Email_Id__c);
   }
   email.setToAddresses(toAddres);
   email.setTreatTargetObjectAsRecipient(false);
   //Added by mahima- SME offer letter-- start
   email.setReplyTo('noreply@bajajfinserv.in');
   email.setWhatId(LoanId);
   email.setsaveAsActivity(false);

   //Send Email
   if (!Test.isRunningTest() && isNewProductFlowEnabled == false) {
    Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
     email
    });
    if (!CommonUtility.isEmpty(r))
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email sent successfully. '));
   }

  }
  return null;
 }

 public PageReference viewOfferLetterPDFToCustomer() {
  PageReference pdf = new PageReference('/apex/ReEngg_OfferLetter?id=' + LoanId);

  //Added by mahima- Sanction letter enhancment- Start-
  if (loan.product__c == 'Home Loan' || loan.product__c == 'LAP') {
   pdf = new PageReference('/apex/ReEngg_OfferLetter_HL_LAP?id=' + LoanId);
  }
  //Added by mahima- Sanction letter enhancment- end-

  return pdf;
 }
 //****** reEngg_OfferLetter  - END @gaurav



 //changes done by pankaj gupta; date -- 18 oct,2016 ; start 

 //Modified, @Gaurav: 2 getter methods removed from here, 
 // also checklist query and conditions from viewannexureLetter(),
 // and added to HL_Annexure_Ctrl 5/12/2016

 public PageReference viewannexureLetter() {
  PageReference pdf = new PageReference('/apex/HL_Annexure?id=' + LoanId);
  return pdf;
 }

 //pankja gupta END  

 //Bug# 13793 S
 public PageReference repayReload() {
  //Bug: 20085 (Garima) - Added UMRN__c field in query
  RepayList = [select id, UMRN__c, A_C_type__c, Open_ECS_Facility__c, Open_ECS_Ex_Customer_Id__c, ECS_Barcode_No__c, Open_Valid_till__c, Open_ECS_Max_Limit__c, ECS_Start_Date__c, ECS_End_Date__c, ECS_Amount__c, name, Loan_Application__c, A_C_NO__c, MICR_Code__c, PDC_START_DATE__c, IFSC_Code__c, Account_Holder_Name__c,
   Bank_Name__c, No_of_Cheques__c, Cheque_Serial_Number__c, Repayment_Mode__c, To_Cheque_Serial_Number__c,
   Cheque_Amount__c, Tranche_Detail__c,
   // Bug 4453 - Decentralized Disbursement Process Starts
   Bank_Branch__c, PDC_By_Name__c
   // Bug 4453 - Decentralized Disbursement Process Ends
   from RePayment_mode_detail__c where Loan_Application__c =: Loan.Id
  ];
  List < RePayment_mode_detail__c > reModeObjLst = new List < RePayment_mode_detail__c > ();
  reModeObjLst = [select id from RePayment_mode_detail__c where Loan_Application__c =: LoanId limit 1];
  if (reModeObjLst != null && reModeObjLst.size() == 0 && Loan.Sent_To_Finnone__c == false) { //15580 added && Loan.Sent_To_Finnone__c==false
   hasInitiated = true;
  } else {
   hasInitiated = false;
  }
  return null;
 }
 public Current_Disbursal_Details__c cddc {
  get;
  set;
 }
 public List < Bank_Account__c > bankAcc {
  get;
  set;
 }
 public PageReference splitTopUp() {
  system.debug('isTopUp1' + isTopUp);
  List < TelePDQuestionMaster__c > lstTPDQ = [select id, ExistingLAN__c, BalanceAmount__c, DisbursementType__c,
   CustomerName__c, ApiResponse__c, LoanApplication__c from TelePDQuestionMaster__c where LoanApplication__c =: Loan.Id AND DisbursementType__c = 'Close Existing'
  ];



  //15580 --Commented bankAcc  
  //bankAcc=[select Name,Applicant__c,Applicant__r.Applicant_Type__c,Bank_Acct_Number__c,Loan_Application__c from Bank_Account__c where Loan_Application__c = : Loan.id AND Applicant__r.Applicant_Type__c ='Primary'];                                         

  List < Current_Disbursal_Details__c > delTPDQ = [select id, Disbursement_To__c, IMPS_Flag__c, Bank_Branch__c, name, Tranche_Detail__c, Loan_Application__c, Internal_Closure__c, Disbursement_Amount__c, Disbursal_Mode__c, Disbursement_Date__c,
   IFSC_Code__c, Favouring__c, isTopUp__c, Tranche_Detail__r.Tranche_Number__c, Bank_Name__c, Bank_Account__c, Payable_at__c, Credit_Days__c
   from Current_Disbursal_Details__c where Loan_Application__c =: Loan.id AND isTopUp__c = true
  ];

  if (delTPDQ != null && delTPDQ.size() > 0) {

   delete delTPDQ;
  }

  if (lstTPDQ != null && lstTPDQ.size() > 0) {
   system.debug('TeleList' + lstTPDQ[0]);

   cddc = new Current_Disbursal_Details__c();
   cddc.Favouring__c = 'Bajaj Finance Limited';
   /*if(bankAcc[0].Bank_Acct_Number__c!=null){
             cddc.Bank_Account__c=bankAcc[0].Bank_Acct_Number__c;}*/ //commented for 15580
   cddc.Bank_Account__c = lstTPDQ[0].ExistingLAN__c; //15580
   cddc.IFSC_Code__c = '';
   cddc.Bank_Name__c = '';
   cddc.Bank_Branch__c = '';
   cddc.IMPS_Flag__c = '';
   cddc.Payable_at__c = Loan.Branch_Name__r.name;
   cddc.Disbursal_Mode__c = 'CHEQUE';
   cddc.Disbursement_Date__c = system.today();
   cddc.Disbursement_Amount__c = 0;
   cddc.Loan_Application__c = Loan.Id;
   cddc.Internal_Closure__c = 'Yes';
   cddc.isTopUp__c = true;
   for (Integer i = 0; i < lstTPDQ.size(); i++) {
    system.debug('TeleValues' + lstTPDQ[i].BalanceAmount__c);
    cddc.Disbursement_Amount__c += lstTPDQ[i].BalanceAmount__c;
   }
   isTopUp = true;
  }

  /*if(bankAcc.Bank_Acct_Number__c!=null)
          {
          system.debug('bank'+bankAcc.Bank_Acct_Number__c);
          cddc.Bank_Account__c = bankAcc.Bank_Acct_Number__c;
          //String TIMEPASS = String.valueOf(bankAcc[0].Bank_Acct_Number__c);
          //cddc.Bank_Account__c = '12345';
          //system.debug('TIMEPASS 1 '+TIMEPASS);
          }
   */

  if (lstTPDQ != null && lstTPDQ.size() > 0) {
   insert cddc;
  }
  system.debug('isTopUp2' + isTopUp);

  return null;
 }
 //Bug# 13793 E  
 //10610 Enhancement Referral Program [MGM] by Deepak 
 public void saveRefferalCode() {
  if (grouptype == 'salaried') {
   update applicantPrimary;
  } else {
   System.debug('Refferal code not applicable for ' + grouptype);
  }
 }
 //10610 Enhancement Referral Program [MGM] by Deepak 
 /* ops Process added by priya start */
 public void getNetdisbAmount() {
  System.debug('loan =====> ' + loan);
  if (loan != null) {
   Integer chargesAPI = 0;
   netdisb = 0;
   List < Fees_and_Charge__c > fees = new List < Fees_and_Charge__c > ();
   fees = [select id, name, Finnone_ChargeId__c, Finnone_ChargeCode__c, Charge_Desc__c, Loan_Application__r.name, Charge_Type__c, Deducted_from_Disbursement__c,
    Service_Charge__c, Status__c, Change_Amount__c, Instrument_Date__c, Instrument_No__c, Bank_Branch__c, Charge__c, Instrument_type__c,
    Amount_after_Service_Change__c, Disbursement_Number__c from Fees_and_Charge__c where Loan_Application__c =: loan.id
   ];
   system.debug('Line 618' + fees.size());
   for (Fees_and_Charge__c feescharges: fees) {
    system.debug('fees here is' + feescharges);
    if (feescharges.Deducted_from_Disbursement__c == 'Yes') {
     system.debug('after yes here is' + feescharges.Deducted_from_Disbursement__c);
     if (feescharges.Change_Amount__c != null) {
      chargesAPI = chargesAPI + Integer.valueOf(feescharges.Change_Amount__c);
      system.debug('cost here is' + chargesAPI);
     }
    }
   }
   system.debug('******chargesAPI' + chargesAPI);
   //if (loan.Loan_Amount_with_Premium__c != null && chargesAPI != null && chargesAPI != 0) {
   if (loan.Loan_Amount_with_Premium__c != null) {
    netdisb = loan.Loan_Amount_with_Premium__c - chargesAPI;
    System.debug('netdisb = loan.Loan_Amount_with_Premium__c - chargesAPI =====> ' + netdisb);
   }


  }



 }
 /* ops Process added by priya end */
 //V1 Refinement Enhancement Start
 public void calculateformulas(List < Property_Details__c > propList, List < DPLinsurance__c > Hinsurance) {
  sumBTAmount = 0.00;
  sumTopAmount = 0.00;
  sumBTROI = 0.00;
  sumTopROI = 0.00;
  sumBTPF = 0.00;
  sumTopPF = 0.00;
  sumLIAmount = 0.00;
  sumGIAmount = 0.00;
  for (Property_Details__c property: propList) {
   if (property.BT_Amount__c != null) sumBTAmount = sumBTAmount + property.BT_Amount__c;
   if (property.Top_Up_Amount__c != null) sumTopAmount = sumTopAmount + property.Top_Up_Amount__c;
   if (property.Requested_BT_ROI__c != null) sumBTROI = sumBTROI + property.Requested_BT_ROI__c;
   if (property.Requested_Top_ROI__c != null) sumTopROI = sumTopROI + property.Requested_Top_ROI__c;
   if (property.Requested_BT_PF__c != null) sumBTPF = sumBTPF + property.Requested_BT_PF__c;
   if (property.Requesetd_Top_PF__c != null) sumTopPF = sumTopPF + property.Requesetd_Top_PF__c;
  }
  for (DPLinsurance__c insurance: Hinsurance) {
   if (insurance.Type_of_Insurance__c == 'Life Insurance' && insurance.Premium_Amount__c != null)
    sumLIAmount = sumLIAmount + Decimal.valueOf(insurance.Premium_Amount__c);
   if (insurance.Type_of_Insurance__c == 'General Insurance' && insurance.Premium_Amount__c != null)
    sumGIAmount = sumGIAmount + Decimal.valueOf(insurance.Premium_Amount__c);
  }
  List < String > formulas = (SRFormula.Body.toString()).split(';');
  Map < String, String > formulamap = new Map < String, String > ();
  JSONstr = '';
  for (String str: formulas) {
   String exp = str;
   str = str.substringAfter('=').trim();
   if (str.containsIgnoreCase('sumBTAmount'))
    str = str.replace('sumBTAmount', String.valueOF(sumBTAmount));
   if (str.containsIgnoreCase('sumTopAmount'))
    str = str.replace('sumTopAmount', String.valueOF(sumTopAmount));
   if (str.containsIgnoreCase('sumBTROI'))
    str = str.replace('sumBTROI', String.valueOF(sumBTROI));
   if (str.containsIgnoreCase('sumTopROI'))
    str = str.replace('sumTopROI', String.valueOF(sumTopROI));
   if (str.containsIgnoreCase('sumBTPF'))
    str = str.replace('sumBTPF', String.valueOF(sumBTPF));
   if (str.containsIgnoreCase('sumTopPF'))
    str = str.replace('sumTopPF', String.valueOF(sumTopPF));
   if (str.containsIgnoreCase('sumLIAmount'))
    str = str.replace('sumLIAmount', String.valueOF(sumLIAmount));
   if (str.containsIgnoreCase('sumGIAmount'))
    str = str.replace('sumGIAmount', String.valueOF(sumGIAmount));
   if (exp.substringBefore('=').containsIgnoreCase('PropertyDossier') && !applicantprimary.Property_Dossier_Report__c)
    str = str.replace(str, '0.00');
   formulamap.put(exp.substringBefore('=').trim(), str);

  }
  JSONstr = JSON.serialize(formulamap);
 }
 //V1 Refinement Enhancement End
 /*Customer Commercial Consent :16165 S*/
 public static void SendEmailUsingBAFLLogix(Id targetId, Id whatId, ID templateId, String fromName, String replyTo,
  String[] toAddresses, String[] CC, String[] bcc, String Priority,
  String Subject, String CostCenter) {
  Messaging.SingleEmailMessage[] previewEmails = new Messaging.SingleEmailMessage[] {};
  String mailBody;
  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
  //List <EmailTemplate> tempID = [SELECT Id,HTMLValue,Name,Subject  FROM EmailTemplate WHERE name =: templateName LIMIT 1];
  system.debug('Inside new SendEmailUsingBAFLLogix() template id is --> ' + templateId);
  system.debug('Inside new SendEmailUsingBAFLLogix() whatId is --> ' + whatId);
  system.debug('Inside new SendEmailUsingBAFLLogix() toAddresses is --> ' + toAddresses);
  system.debug('Inside new SendEmailUsingBAFLLogix() CC is --> ' + CC);
  system.debug('Inside new SendEmailUsingBAFLLogix() bcc is --> ' + bcc);
  system.debug('Inside new SendEmailUsingBAFLLogix() fromName is --> ' + fromName);
  system.debug('Inside new SendEmailUsingBAFLLogix() replyTo is --> ' + replyTo);
  if (templateId != null && whatId != null) {
   try {
    //subject = tempID[0].Subject; 
    mail.setToAddresses(toAddresses);
    mail.setTargetObjectId(targetId);
    mail.setTemplateId(templateId);
    mail.setReplyTo('noreply@bajajfinserv.in');
    mail.setWhatId(whatId);
    mail.setsaveAsActivity(false);
    mail.setTreatTargetObjectAsRecipient(false);
    previewEmails.add(mail);
    Messaging.SingleEmailMessage secondPreviewEmail = new Messaging.SingleEmailMessage();
    previewEmails.add(secondPreviewEmail);
    List < Messaging.SendEmailResult > previewResult = Messaging.sendEmail(previewEmails);
   } catch (Exception e) {
    system.debug('Exception' + e + e.getLineNumber());
    System.debug('****Exception: ' + e.getMessage() + ' Line number --> ' + e.getLineNumber());
    //system.debug('token is'+applicantPrimary1.token__c);
    system.debug('mail:' + mail + ':mailbody:' + mail.getHTMLBody());
    mailBody = mail.getHTMLBody();
    if (mailBody != null && mailBody != '' && (!string.isEmpty(mailBody))) {
     mailBody = mailBody.replace('"', '\\"');
     // Start of changes by Niraj
     mailBody = mailBody.replaceAll('<p>\\s', '<p>');
     mailBody = mailBody.trim();
     mailBody = mailBody.replaceAll('(\\s+)', ' ');
     // End of changes by Niraj
     mailBody = mailBody.replaceAll('dummyloanid',encryptloanId);/*Encrypt Url*/
     mailBody = mailBody.replaceAll('dummytokennum', applicantPrimary1.token__c);
     mailBody = mailBody.replaceAll('encryptEmailForEagreement','EAgreement');/*Encrypt URL*/
    }
    system.debug('MailBody' + mailBody);
    system.debug('Invocation count' + Limits.getEmailInvocations());
   }
   //added for bug id 20296 start
   BAFL_EmailServicesLogix.EmailServicesPort stub = new BAFL_EmailServicesLogix.EmailServicesPort();
   /* system.debug('flag is1'+ cibilWatchComm);
                 if(cibilWatchComm == true){
                     system.debug('inside if>>>'+ cibilWatchComm);
                     BAFL_EmailServicesLogix.SendEmailResponse er1 = stub.SendEmail(fromName,
                     'otpofficeemailverification@6hifw8v4ew6qa26r5whiw37rq2yorch4vylpptp0njgfwqxjc.o-51mo2mam.cs5.apex.sandbox.salesforce.com',
                     toAddresses,
                     CC,
                     bcc,
                     'Normal',
                     arrAttachment,
                     Subject,                    
                     mailBody,
                     'bajaj');   
                     }else{  //added for bug id 20296 end*/
   stub.timeout_x = 120000;
   System.debug('pkfromname' + fromName);
   BAFL_EmailServicesLogix.SendEmailResponse er = stub.SendEmail(fromName,
    'otpofficeemailverification@6hifw8v4ew6qa26r5whiw37rq2yorch4vylpptp0njgfwqxjc.o-51mo2mam.cs5.apex.sandbox.salesforce.com',
    toAddresses,
    CC,
    bcc,
    'Normal',
    new BAFL_EmailServicesLogix.Attachment[] {},
    Subject,
    mailBody,
    'bajaj');
   // }

  } else {
   system.debug('EmailTemplate list is empty !!');
  }

 }
 /* Customer commercial consent :16165 E*/
 /*IMPS Account Validation :13907 S*/
 public Current_Disbursal_Details__c selectedAcc;
 public String resultmsg {
  get;
  set;
 }
 public List < String > errorcodes = Label.IMPS_Error_codes.split(';');
 public void checkIMPS() {
  try {
   System.debug('in method');
   Map < String, Object > IMPSinput = new Map < String, Object > ();
   Map < String, String > IMPSresponse = new Map < String, String > ();
   List < Current_Disbursal_Details__c > lsttobeupdated = new List < Current_Disbursal_Details__c > ();
   Boolean flag = false;
   resultmsg = '';
   String errormsg = '';
   selectedAcc = new Current_Disbursal_Details__c();
   selectedDisbursmentId = apexpages.currentpage().getparameters().get('IMPSRecId');
   List < String > Dismode = (Label.IMPS_Disbursal_Mode).split(';');
   System.debug('selectedDisbursmentId -->' + selectedDisbursmentId);
   Current_Disbursal_Details__c selectedAcc = [select IMPS_Account_Validate__c, IMPSDateTime__c, IMPS_Transaction_No__c, id, Favouring__c, IFSC_Code__c, Successful_IMPS_Count__c, IMPS_Result__c, IMPS_Count__c, Failure_IMPS_Count__c, Disbursal_Mode__c, Bank_Account__c from Current_Disbursal_Details__c where id =: selectedDisbursmentId];
   if (selectedAcc.IMPS_Count__c == null)selectedAcc.IMPS_Count__c = 0;
   if (selectedAcc.Successful_IMPS_Count__c == null)selectedAcc.Successful_IMPS_Count__c = 0;
   if (selectedAcc.Failure_IMPS_Count__c == null)selectedAcc.Failure_IMPS_Count__c = 0;

   if (selectedAcc != null && selectedAcc.Disbursal_Mode__c != null && (new Set < String > (Dismode)).contains(selectedAcc.Disbursal_Mode__c) && !flag) {
    String reqno = String.valueOf(Datetime.now());

    String str = reqno.deleteWhitespace();
    str = str.remove('-');
    str = str.remove(':');
    System.debug('reqno-->' + str);
    IMPSinput.put('requestId', str);
    IMPSinput.put('beneIFSCCode', selectedAcc.IFSC_Code__c);
    IMPSinput.put('beneAccNumber', selectedAcc.Bank_Account__c);
    IMPSinput.put('source', 'HTS');
    IMPSinput.put('amount', Label.IMPS_Transaction_charge);
    IMPSinput.put('remitterName', selectedAcc.Favouring__c);
    IMPSinput.put('remitterMobile', Loan.Account.Mobile__c);
    System.debug('IMPSinput : ' + IMPSinput);
    IMPSresponse = BRECallout.CallIMPSWebService(IMPSinput);
    System.debug('IMPSresponse : ' + IMPSresponse);
    //System.debug('IMPSresponse.get(respCode) -->'+IMPSresponse.get('respCode') +'IMPSresponse.get(respDesc)'+IMPSresponse.get('respDesc'));
    //System.debug((new Set<String>(errorcodes)).Contains(IMPSresponse.get('respCode')));
    if (IMPSresponse != null && IMPSresponse.size() > 0) {
     if ((IMPSresponse.get('respCode') != null && ((new Set < String > (errorcodes)).Contains(IMPSresponse.get('respCode')))) || IMPSresponse.get('respDesc') == 'Internal Server Error') {
      selectedAcc.IMPS_Transaction_No__c = IMPSresponse.get('traceNumber');
      selectedAcc.IMPS_Result__c = IMPSresponse.get('respDesc');
      selectedAcc.IMPSDateTime__c = IMPSresponse.get('dateTime');
      selectedAcc.IMPS_Beneficiary_Name__c = IMPSresponse.get('beneName'); // Bug 20149   
      resultmsg = 'Internal Server Error.';
     } else if (IMPSresponse.get('respDesc') != null) {
      selectedAcc.IMPS_Transaction_No__c = IMPSresponse.get('traceNumber');
      selectedAcc.IMPS_Result__c = IMPSresponse.get('respDesc');
      selectedAcc.IMPSDateTime__c = IMPSresponse.get('dateTime');
      selectedAcc.IMPS_Beneficiary_Name__c = IMPSresponse.get('beneName'); // Bug 20149   
      if (IMPSresponse.get('respDesc') == 'Successful Transaction') {
       selectedAcc.Successful_IMPS_Count__c++;
       selectedAcc.IMPS_Count__c++;
       resultmsg = 'Account Validated Succesfully,so no need to collect cancelled cheque.';

      } else {
       selectedAcc.Failure_IMPS_Count__c++;
       selectedAcc.IMPS_Count__c++;
       resultmsg = selectedAcc.IMPS_Result__c; // bug 18378
      }
     }
    }
    System.debug('checkIMPS : DisbList : ' + DisbList);
    for (Current_Disbursal_Details__c dis: DisbList) {
     if (selectedAcc != null && selectedAcc.id != dis.id && selectedAcc.Bank_Account__c == dis.Bank_Account__c && selectedAcc.IFSC_Code__c == dis.IFSC_Code__c) {
      dis.IMPS_Count__c = selectedAcc.IMPS_Count__c;
      dis.Failure_IMPS_Count__c = selectedAcc.Failure_IMPS_Count__c;
      dis.Successful_IMPS_Count__c = selectedAcc.Successful_IMPS_Count__c;
      dis.IMPS_Result__c = selectedAcc.IMPS_Result__c;
      dis.IMPS_Transaction_No__c = selectedAcc.IMPS_Transaction_No__c;
      dis.IMPSDateTime__c = selectedAcc.IMPSDateTime__c;
      dis.IMPS_Beneficiary_Name__c = selectedAcc.IMPS_Beneficiary_Name__c; // 20149 Bug
      lsttobeupdated.add(dis);
     }

     if (selectedAcc != null && selectedAcc.id == dis.id) {
      dis = selectedAcc;lsttobeupdated.add(dis);
     }
    }
    if (IMPSresponse != null && IMPSresponse.size() > 0) {
     update lsttobeupdated;
    }
   } else {
    flag = true;errormsg = 'IMPS Functionality only available for RTSG,IMPS and NEFT disbursal mode';
   }
   if (flag) {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, errormsg));
   }
  } catch (Exception e) {
   System.debug('Exception -->' + e);
   System.debug('****Exception: ' + e.getMessage() + ' Line number --> ' + e.getLineNumber());

   // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e));
  }

 }
 public void recheckIMPS() {
  try {
   Map < String, Object > IMPSrecheckinput = new Map < String, Object > ();
   Map < String, String > IMPSrecheckresponse = new Map < String, String > ();
   List < Current_Disbursal_Details__c > lsttobeupdated = new List < Current_Disbursal_Details__c > ();
   String selectedRecId = apexpages.currentpage().getparameters().get('RecheckIMPSId');
   System.debug('selectedRecId -->' + selectedRecId);
   List < String > temp = selectedRecId.split('_');
   System.debug('temp -->' + temp[0]);
   Current_Disbursal_Details__c selectedAcc = [select IMPS_Account_Validate__c, IMPSDateTime__c, IMPS_Transaction_No__c, id, Favouring__c, IFSC_Code__c, Successful_IMPS_Count__c, IMPS_Result__c, IMPS_Count__c, Failure_IMPS_Count__c, Disbursal_Mode__c, Bank_Account__c from Current_Disbursal_Details__c where id =: temp[0]];

   if (selectedAcc != null) {
    String reqno = String.valueOf(Datetime.now());

    String str = reqno.deleteWhitespace();
    str = str.remove('-');
    str = str.remove(':');
    System.debug('reqno-->' + str);
    IMPSrecheckinput.put('requestId', str);
    IMPSrecheckinput.put('traceNumber', selectedAcc.IMPS_Transaction_No__c);
    IMPSrecheckresponse = BRECallout.CallIMPSRecheckWebService(IMPSrecheckinput);
    if (IMPSrecheckresponse != null && IMPSrecheckresponse.size() > 0) {
     if ((IMPSrecheckresponse.get('respCode') != null && (new Set < String > (errorcodes)).Contains(IMPSrecheckresponse.get('respCode'))) || IMPSrecheckresponse.get('respDesc') == 'Internal Server Error' || (selectedAcc.IMPS_Result__c != null && selectedAcc.IMPS_Result__c == IMPSrecheckresponse.get('respDesc'))) {
      resultmsg = IMPSrecheckresponse.get('respDesc');
     } else if (IMPSrecheckresponse.get('respDesc') != null && IMPSrecheckresponse.get('respDesc') != '') {
      selectedAcc.IMPS_Transaction_No__c = IMPSrecheckresponse.get('traceNumber');
      selectedAcc.IMPS_Result__c = IMPSrecheckresponse.get('respDesc');
      selectedAcc.IMPSDateTime__c = IMPSrecheckresponse.get('dateTime');
      if (IMPSrecheckresponse.get('respDesc') == 'Successful Transaction') {
       selectedAcc.Successful_IMPS_Count__c++;
       //  selectedAcc.IMPS_Count__c++;  // commented for bug 18385
       resultmsg = 'Account Validated Succesfully,so no need to collect cancelled cheque.';

      } else {
       selectedAcc.Failure_IMPS_Count__c++;
       //  selectedAcc.IMPS_Count__c++;  // commented for bug 18385
       resultmsg = selectedAcc.IMPS_Result__c; // bug 18378
      }
     }
     System.debug('RecheckIMPS : DisbList : ' + DisbList);
     for (Current_Disbursal_Details__c dis: DisbList) {
      if (selectedAcc != null && selectedAcc.id != dis.id && selectedAcc.Bank_Account__c == dis.Bank_Account__c && selectedAcc.IFSC_Code__c == dis.IFSC_Code__c) {
       dis.IMPS_Count__c = selectedAcc.IMPS_Count__c;
       dis.Failure_IMPS_Count__c = selectedAcc.Failure_IMPS_Count__c;
       dis.Successful_IMPS_Count__c = selectedAcc.Successful_IMPS_Count__c;
       dis.IMPS_Result__c = selectedAcc.IMPS_Result__c;
       dis.IMPS_Transaction_No__c = selectedAcc.IMPS_Transaction_No__c;
       dis.IMPSDateTime__c = selectedAcc.IMPSDateTime__c;
       dis.IMPS_Beneficiary_Name__c = selectedAcc.IMPS_Beneficiary_Name__c; // 20149 Bug
       lsttobeupdated.add(dis);
      }

      if (selectedAcc != null && selectedAcc.id == dis.id) {
       dis = selectedAcc;lsttobeupdated.add(dis);
      }
     }

    }
    if (IMPSrecheckresponse != null && IMPSrecheckresponse.size() > 0) {
     update lsttobeupdated;
    }
   }
  } catch (Exception e) {
   System.debug('Exception -->' + e);
  }
 }
 public void saveIMPSResult() {
  try {update IMPSResultLst;
  } catch (Exception e) {
   System.debug('exception -->' + e);
  }
 }

 /*IMPS Account Validation :13907 E*/

 //Bug 16173 - VRPL changes for HFC Start
 public Boolean showParentDealID {
  get;
  set;
 } //Flag to check VRPL scheme - Parent ID mandatory dependency 
 public String ParentDealID {
  get;
  set;
 } //to store parent Deal Id in primary applicant
 public String initialSchemeID {
  get;
  set;
 } //to store scheme's Id

 //Use : to set value of showParentDealID, dpending upon scheme selected
 public PageReference checkShowParentDealID() {
  try {
   if (Loan != null && Loan.Scheme_Master__c != null) {
    List < Scheme_Master__c > schemeList = [select Id, Name, VRPL_Flag__c from Scheme_Master__c where Id =: Loan.Scheme_Master__c];

    if (schemeList != null && schemeList.size() > 0) {
     String VRPLfg = schemeList[0].VRPL_Flag__c;
     if (VRPLfg == null || VRPLfg == 'NO') {
      showParentDealID = false;
      applicantPrimary.Parent_Deal_ID__c = null;
     } else if (VRPLfg == 'YES') {showParentDealID = true;
     }
    }
   }
   System.debug('showParentDealID : ' + showParentDealID);
  } catch (Exception e) {
   System.debug('Exception occurred in checkShowParentDealID : ' + e);
  }

  return null;
 }

 //Use : to updated primary applicant record
 public void updatePrimaryApplicant() {
  if (applicantPrimary != null && applicantPrimary.id != null) {
   update applicantPrimary;

   applicantPrimary = [select eKYC_Processing__c, id, Existing_Customer__c, ROIFlexi__c, ROILoc__c, ROINormal__c, ROI_PO__c, mail_to_Sales_Hierarchy__c, Months_per_year__c, EMI_Holiday_Months__c,
    Cycle_Day_Date__c, Blind_Data_Entry_Flag__c, Note_code__c, Note_details__c, Payment_type__c, ContactName__c, Contact_Mobile__c, Contact_Name__r.Name,
    name, Descriptin__c, SegmentaionResult__c, CIBIL_Score__c, Applicant_type__c, Contact_Name__r.Stamp_Duty__c, Company_Name_as_per_Domain_check__c,
    Official_Email_bounce_Flag__c, Domain_Created_Date__c, Domain_Check_Result__c, Registrant_Name__c, Registrant_Email_ID__c, Property_Dossier_Report__c, Send_pricing_email_to_customer__c, Commercial_Confirmation_Mail_Date__c, FFR_Email_Sent__c, EMI_Holiday_Opted__c,
    Refferal_Identifier__c, RSA_flag__c, RSA_Loan_application_status__c, RCU_status__c, Samp_Status__c, MTFinnOne__c, Fraud_Case__c,
    Contact_Name__r.Customer_Type__c, Pure_Flexi_Period__c, Drop_Line_Flexi_Period__c, Pure_Flexi_EMI__c, Contact_Name__r.Date_of_Birth__c, Parent_Deal_ID__c /* 16165 S*/ , Customer_Decline_Reasons__c, IP_Address_Timestamp__c /*16165 E*/ /*SAL Mobility Addition CR - Aman Porwal - S*/ , Financial_Health_Check_Guide__c /*SAL Mobility Addition CR - Aman Porwal - e*/
    /*21288 AP : Defect 22889*/
    , Cross_Collateral_LAN__c 
    from Applicant__c where Id =: applicantPrimary.id limit 1
   ];
   if(applicantPrimary.Parent_Deal_ID__c != null)
   ParentDealID = applicantPrimary.Parent_Deal_ID__c; //updating initial parent deal ID
   System.debug('ParentDealID : ' + ParentDealID);
  }
 }
 //Bug 16173 - VRPL changes for HFC  End
 //Bug #17924 S
 webservice static String fdQuesValidate(String Loanid) {
  List < String > insProd = system.label.SAL_PL_Prod.split(';');
  List < String > loanProd = system.label.SAL_PL_Loan_Prod.split(';');
  Boolean errMsg = false;
  Boolean isValid = true;
  Map < String, Object > resMap = new Map < String, Object > ();
  String jsonRes = '';

  List < DPLinsurance__c > lstDpl = [select id, Name, Insurance_Product__c, Opportunity__r.Product__c, Declaration_of_good_health__c, (select id, Feedback_Answer11__c, Feedback_Answer__c from Feedbacks__r) from DPLinsurance__c where Opportunity__c =: Loanid];

  resMap.put('isValid', true);
  for (DPLinsurance__c objIns: lstDpl) {
   //system.debug('The Product'+objIns.Opportunity__r.Product__c );
   //system.debug('Insurance Product '+objIns.Insurance_Product__c);
   //system.debug('The Product health'+objIns.Declaration_of_good_health__c);
   if (objIns.Opportunity__r.Product__c != null && (new Set < String > (loanProd).contains(objIns.Opportunity__r.Product__c))) {
    if (objIns.Insurance_Product__c != null && (new Set < String > (insProd).contains(objIns.Insurance_Product__c))) {
     if (objIns.Declaration_of_good_health__c != null) {
      String decGdhlth = objIns.Declaration_of_good_health__c;

      if (decGdhlth.equals('N')) {
       if (objIns.Feedbacks__r.size() == 0) {
        isValid = false;
        resMap.put('isValid', false);
        resMap.put('msgStr1', 'Please fill the medical questionnaire for insurance product(s)');
        break;
       }
       if (objIns.Feedbacks__r != null && objIns.Feedbacks__r.size() > 0) {
        for (Feedback__c objFD: objIns.Feedbacks__r) {
         system.debug('objFD.answer ' + objFD.Feedback_Answer__c);
         if (objFD.Feedback_Answer__c != null && objFD.Feedback_Answer__c.equals('No')) isValid = false;
         else if (objFD.Feedback_Answer__c != null && objFD.Feedback_Answer__c.equals('Yes')) {
          isValid = true;break;
         }
        }
       }


      }
     }
    }
   }

  }
  if (!isValid) {
   resMap.put('isValid', false);
   resMap.put('msgStr2', 'Atleast one medical question with Yes answer needed');

  }

  system.debug('resMap ::' + resMap);
  jsonRes = JSON.serialize(resMap);
  return jsonRes;
 }
 //Bug #17924 E
 /* Bug : 17556 S  Pricing */

 //Hrushikesh added for IMPS Validation 

 //Bug:19193 -  Top Up Changes Start : Garima        
 public void topUpChange(Opportunity loanData) {
  list < TelePDQuestionMaster__c > telepdData = new list < TelePDQuestionMaster__c > ();
  invalidPOS = true;
  for (TelePDQuestionMaster__c telePD: loanData.TelePDQuestionsMaster__r) {
   //CR:21750--S (Existing 19193 code is removed)
   if (telePD.BalanceAmount__c >= 0) {
    invalidPOS = false;
    break;
   }
   //CR:21750--E
  }
 }
 //Bug:19193 -  Top Up Changes End : Garima
 //Bug-22141 S
 public pagereference ConfirmBankDetails() {
  try {
   system.debug('Loan id is' + LoanId);
   if (LoanId != null && Loan != null) {

    Boolean isVerified = false;

    List < Verification__c > currentRecords = [select id, Verification_Type__c, Customer_Bank_Acc_Confirmation__c from Verification__c where Verification_Type__c = 'Banking Validations'
     and Loan_Application__c =: LoanId
    ];
    if (currentRecords != null && currentRecords.size() > 0) {
     for (Verification__c verificationObj: currentRecords) {
      if (verificationObj.Customer_Bank_Acc_Confirmation__c == 'Accept' || verificationObj.Customer_Bank_Acc_Confirmation__c == 'Reject') {
       isVerified = true;
      }
     }
     if (isVerified == true) {
      ApexPages.Message showMsg = new ApexPages.Message(ApexPages.Severity.Info, 'Bank Details for Customer is already verified !');
      Apexpages.addMessage(showMsg);
      return null;
     } else {
      delete currentRecords;
      Verification__c newVerificationRecord = new Verification__c();
      newVerificationRecord.Verification_Type__c = 'Banking Validations';
      newVerificationRecord.Loan_Application__c = Loan.Id;
      insert newVerificationRecord;
      sendMessage(Loan.Id);
      system.debug('confirmsms');
      ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Customer Bank Account(s) Verification Initiated!');
      Apexpages.addMessage(myMsg);
      return null;
     }
    } else {
     Verification__c newVerificationObj = new Verification__c();
     newVerificationObj.Verification_Type__c = 'Banking Validations';
     newVerificationObj.Loan_Application__c = Loan.Id;
     insert newVerificationObj;
     sendMessage(Loan.Id);
     system.debug('confirmsms');
     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Customer Bank Account(s) Verification Initiated!!');
     Apexpages.addMessage(myMsg);
     return null;
    }

   } else {
    return null;
   }

  } catch (Exception e) {String exceptionMessage = e.getMessage() + '\n' + e.getLineNumber() + '\n' + e.getCause() + '\n' + e.getTypeName();
   system.debug('Exception :###' + exceptionMessage);
   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, exceptionMessage);
   Apexpages.addMessage(myMsg);return null;

  }

 }
  //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement start
  public void sendPricingEmailDIPOS() {
   Map < String, Object > ALLMap = new Map < String, Object > ();
   Map < String, Object > sendpricingemap = new Map < String, String > ();
   Boolean send_email_to_sourcing = true;
   Boolean send_email_to_ASM = true;
   Boolean send_email_to_relationship_manager = true;
   String jsnBody;
       if(loan!=null)
   encryptloanId = CommonUtility.encryptURLParam(loan.id);
   if (sendpricingemail != null) {
    jsnBody = sendpricingemail.Body.toString();
    ALLMap = (Map < String, Object > ) JSON.deserializeUnTyped(jsnBody);
    sendpricingemap = (Map < String, Object > ) ALLMap.get('sendpricingemailDIPOS');
    send_email_to_sourcing = Boolean.valueOf(sendpricingemap.get('send_to_sourcing_email'));
    send_email_to_relationship_manager = Boolean.valueOf(sendpricingemap.get('send_to_relationship_manager'));
    send_email_to_ASM = Boolean.valueOf(sendpricingemap.get('send_to_asm_email'));
    System.debug('pkswitch' + send_email_to_sourcing + send_email_to_relationship_manager + send_email_to_ASM);
   }
   List < String > toAddlist = new List < String > ();
   List < String > toAddlistCC = new List < String > ();
   if (Loan.Sourcing_channel_email_id__c != null) {
    if (send_email_to_sourcing != null && send_email_to_sourcing) {
     System.debug('pkswitch send_email_to_sourcing' + send_email_to_sourcing);
     toAddlist.add(Loan.Sourcing_channel_email_id__c);
    }
   }
   if (conObj != null && conObj.Office_Email_Id__c != null) {
    toAddlist.add(conObj.Office_Email_Id__c);
   }
   if (conObj != null && conObj.Email != null) {
    toAddlist.add(conObj.Email);
   }
   if (Loan.ASM_email_id__c != null) {
    if (send_email_to_ASM != null && send_email_to_ASM) {
     System.debug('pkswitch send_email_to_ASM' + send_email_to_ASM);
     toAddlist.add(Loan.ASM_email_id__c);
    }
   }
   if (loan.Relationship_Manager__r != null && loan.Relationship_Manager__r.Email != null) {
    if (send_email_to_relationship_manager != null && send_email_to_relationship_manager)
     toAddlistCC.add(loan.Relationship_Manager__r.Email);
    System.debug('loan.Relationship_Manager__r.Email' + loan.Relationship_Manager__r.Email);
   }
   if (toAddlist.size() > 0) 
   {
    String[] toAdd = toAddlist;
    String[] ccArray = toAddlistCC;
    String[] bccArray = new List < String > ();

    String fromEmail;

    fromEmail = 'profloans.mailconfirmation@bajajfinserv.in';
String replyTo = Label.Pricing_Attchment_Email;
  String subject = 'Pricing Details LAN No: ' + loan.Loan_Application_Number__c;
    /* 16165 commercial mailer start */
    List < EmailTemplate > Templist = new List < EmailTemplate > ();
   
    Templist = [select id from EmailTemplate where Name = 'Commercial Concent Email DIPOS'];


    if (loan.Account.Current_Email_Id__c != null)
     toAdd.add(Loan.Account.Current_Email_Id__c);


    tokenNumber = String.valueOf(Integer.valueOf(Math.random() * 10000));
    applicantPrimary.token__c = tokenNumber;
    applicantPrimary1 = new Applicant__c();
    applicantPrimary1.token__c = applicantPrimary.token__c;
    
    applicantPrimary.Application_Form_Timestamp__c = 'Acceptance Pending'; //17556
    PricingDisbmntDetails_Ctrl.SendEmailUsingBAFLLogix(conObj.id, loan.id, Templist[0].id, fromEmail, replyTo, toAdd, ccArray, bccArray, 'Normal', subject, 'bajaj');
    }
     string smstext = '';
      String smsUrl = '';
    String smsUrlAppForm = '';

    system.debug('smstest==>'+smstext );
    Map < String, String > dynPar = new Map < String, String > (); //Responsys Dynamic Parameters Bug 15653
    Rack_Rate__c custAgg = new Rack_Rate__c();
    system.debug('rrMaster ' + rrMaster);
    if (rrMaster != null && rrMaster.size() > 0) {
     for (Rack_Rate__c rr: rrMaster) {
      Set < String > rrProd = new Set < String > ();
      if (rr.Products__c != null)
       rrProd.addAll(rr.Products__c.split(';'));
      if (rr.Event__c == 'custagreementMsg' && rrProd.contains(Loan.Product__c)) { //changed event name from Customer Agreement SMS to custagreementMsg for bug id 16165
       custAgg = rr;
       system.debug('inside custagg>>>' + custAgg);
      }
     }
    }
    smsUrl = Label.bflsiteuserURL + '/EAgreementProfessionalLoan?Loanid=' + loan.id + '&EmailFor=EAgreement&Token=' + applicantPrimary.token__c;
     system.debug('smsUrlAppForm ==>'+smsUrl);
    smsUrl = Commonutility.googleShortenUrl(smsUrl);
    smsUrlAppForm = Label.bflsiteuserURL + '/EApplicationProfessionalLoan?oppid=' + loan.id;
    system.debug('smsUrlAppForm ==>'+smsUrlAppForm);
    smsUrlAppForm = Commonutility.googleShortenUrl(smsUrlAppForm);
     system.debug('smsUrlAppForm shortener agreement ==>'+smsUrl );
      system.debug('smsUrlAppForm shortner==>'+smsUrlAppForm);
    //Responsys Dynamic Parameters Bug 15653 s
    List < SMS_Sent__c > allsms = new List < SMS_Sent__c > ();
    if (setProdRes.contains(Loan.Product__c) && custAgg.Used_For__c == 'Responsys') {
     dynPar.put('P_LAN', Loan.Loan_Application_Number__c);
     dynPar.put('P_BITLY_AGREEMENT', smsUrl);
     dynPar.put('P_BITLY_APPFORM', smsUrlAppForm);
     system.debug('inside dynPar>>>' + dynPar);
     
    } else {
    smstext=custAgg.SMS_Text__c;
     if (!commonutility.isEmpty(applicantPrimary.Contact_Name__c))
      //smstext = smstext.replace('<Customer Name>', applicantPrimary.Contact_Name__r.name);//commented for bug id 16165
         if(smstext!=null){
      smstext = smstext.replace('<LAN>', loan.Loan_Application_Number__c);
     smstext = smstext.replace('<Bitly_Agreement>', smsUrl);
             smstext = smstext.replace('<Bitly_App_Form>', smsUrlAppForm);}
      system.debug('smstext  inside else==>'+smstext );
    }
    /*16165 sms code block end*/
    //Responsys Dynamic Parameters Bug 15653 e
    system.debug('smstext >>' + smstext);
    List < String > message = new List < string > ();
    List < string > mobileno = new List < string > ();

    /* 16165 sms insert code block start*/
    SMS_Sent__c sms = new SMS_Sent__c();
    sms.LoanApplication__c = Loan.Id;
    sms.Name = 'Customer Consent';
    sms.SMS_Receiver__c = 'Primary Applicant';
    sms.Email_sent__c = true;
    if (conObj != null && conObj.Office_Email_Id__c != null) {
     sms.Email_sent_at__c = conObj.Office_Email_Id__c;
    } else if (conObj != null && conObj.Email__c != null) {
     sms.Email_sent_at__c = conObj.Email__c;
    } else
     sms.Email_sent_at__c = toAddlist[0];

    sms.Email_sent_time__c = System.now();

    System.debug('Send SMS to Primary Applicant......' + applicantPrimary.Contact_Mobile__c);
    sms.SMS_Sent_Number__c = String.valueOf(applicantPrimary.Contact_Mobile__c);
    //Responsys Dynamic Parameters Bug 15653 s added if else
    if (!setProdRes.contains(Loan.Product__c) && custAgg.Used_For__c == 'Responsys') {
     sms.Event__c = custAgg.Campaign_name__c;
     sms.SMS_Parameters__c = JSON.serialize(dynPar);
     sms.Status__c = 'Pending';
    } else {
     
     sms.SMS_Text_Sent__c = smstext;
     sms.SMS_Sent_Time__c = system.now();
     sms.SMS_Sent__c = true;
     System.debug('here1 ');
     Datetime currtime = system.now();
     Integer hour = currtime.hour();
     if (hour > 9 && hour < 21)
      sms.Status__c = 'Sent';
     else
      sms.Status__c = 'Pending';

     System.debug('here2 ' + sms.Status__c);
    }
    allsms.add(sms);
    if (applicantPrimary.Contact_Mobile__c != null) {
     message.add(smstext);
     mobileno.add(applicantPrimary.Contact_Mobile__c);
    }
    if (message.size() > 0 && mobileno.size() > 0) {
     system.debug('inside sendsms');
     if (!setProdRes.contains(Loan.Product__c) && custAgg.Used_For__c == 'Responsys') {
      system.debug('inside responsys if');
     } else {
      system.debug('inside responsys else');
      sendsms.sendBulkSMS(message, mobileno);
     }
    }
    insert allsms;
    applicantPrimary.Send_pricing_email_to_customer__c = true;
    applicantPrimary.Commercial_Confirmation_Mail_Date__c = System.now();
    applicantPrimary.IP_Address_Timestamp__c = 'Acceptance Pending';
    String mailerdata = firtEMIDate + ';' + lastEMIDate + ';' + emi;
    applicantPrimary.Customer_Decline_Reasons__c = mailerdata;
    upsert applicantPrimary;
   
   }
  //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement end
 @future(callout = true)
 public static void sendMessage(String oppId) {
  List < opportunity > oppobjList = new List < opportunity > ();
  oppobjList = [select id, name, Product__c from opportunity where id =: oppId];
  GeneralCommunicationHandler.sendSMS(oppobjList, 'Validate_Bank_Details');
 }
 //Bug-22141 E
}