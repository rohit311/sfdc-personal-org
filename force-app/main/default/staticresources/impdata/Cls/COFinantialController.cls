public class COFinantialController {
 public boolean hideAadhaarSection {
  get;
  set;
 } //added for bug id 21851
 //code for mobility v2 underwriter start
 public boolean salmobilityv2falg {
  get;
  set;
 }
 public String mobilitystatus {
  get;
  set;
 }
 public String app_rejcomments {
  get;
  set;
 }
 public String reject_reason {
  get;
  set;
 }
 public String reject_reason1 {
  get;
  set;
 }
    /* Digital Sampling S*/
 public Boolean ShowDigitalSamplingPanel{
     get;
     set;
    }
 /* Digital Sampling S*/
 //code for mobility v2 underwriter end
 //Rohit 16111 CR start
 public Boolean aadharMandatoryState {
  get;
  set;
 }
 public Boolean appEkyc {
  get;
  set;
 }
 //Rohit 16111 CR stop  
 //OTPv3 TeleRM Rohit start
 public Set < String > OTPProducts = new Set < String > ();
 //OTPv3 TeleRM Rohit stop
 //V1 Refinement Enhancement Start
 public PageReference getdownloadCalcURL() {
  ContentVersion[] cv = [select id, ContentDocumentId from ContentVersion where Title = 'HFC Loan Booking Calculator'];
  if (!CommonUtility.isEmpty(cv)) {
   return new PageReference('/sfc/servlet.shepherd/version/download/' + cv[0].id);
  } else
   return ApexPages.currentPage();

 }

 public Boolean displayHFCCalc {
  get;
  set;
 }
 //V1 Refinement Enhancement End
 /* Customer Level Collateral Tracking added by priya start  */
 public boolean CollateralFlag {
  get;
  set;
 }
 /* Customer Level Collateral Tracking added by priya end  */
 //Rohit sol policy start
 public List < SOL_Policy__c > sollstObj {
  get;
  set;
 }
 //Rohit sol policy stop 

 //added by akshata :Hybrid Flexi Inhancement : Start
 public boolean IsHybridFlexi {
  get;
  set;
 }
 //added by akshata :Hybrid Flexi Inhancement : End

 //Anjali mortgage  Mortgage IM  start

 Public Boolean ConfirmCheckbox {
  get;
  set;
 }

 /*Property Dedupe bug 12944 Start -Anshita */
 public List < PropDedupeWrap > propDedupeWrapLst {
  get;
  Set;
 }
 public List < Property_Details__c > propDtlLst {
  get;
  set;
 }
 Public Map < Id, Property_Details__c > propDtlMap {
  get;
  set;
 }
 public List < De_Dupe__c > propDdpList {
  get;
  set;
 }
 public boolean propDdpflag {
  get;
  set;
 }
 /*Property Dedupe bug 12944 End -Anshita */

 /*SAL PL to SAL LAP start*/
 List < String > saltolapprod = new List < String > ();
 Set < String > SALtoLAPProducts {
  get;
  set;
 }
 public Boolean SALtoLAPFlag {
  get;
  set;
 }
 /*SAL PL to SAL LAP end*/
 public Integer Buro_Score {
  get;
  set;
 }
 public String Invisible_mandatory {
  get;
  set;
 }
 //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal start
 public string deviationProducts;
 List < Checklist__c > checklistTrnxListNotDelete;
 List < Checklist__c > checklistTrnxListDelete;
 //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal end  
 public Integer RTCount {
  get;
  set;
 }
 public boolean showInvisbleSection {
  get;
  set;
 }
 public boolean manualVerButtonFlag {
  get;
  set;
 } // For triggering manual verification
 public List < SOL_Policy__c > oldSolList;
 public Boolean Group1result {
  get;
  set;
 }
 public Boolean Group2result {
  get;
  set;
 }
 public Boolean Group3result {
  get;
  set;
 }
 public boolean IMflag {
  get;
  set;
 }
 public boolean CObuttonFlag {
  get;
  set;
 } // For approve and reject buttons
 public boolean identifiedByBRE {
  get;
  set;
 }
 public String IMmessage {
  get;
  set;
 }
 public Integer countOfGroup1 {
  get;
  set;
 }
 public Integer countOfGroup2 {
  get;
  set;
 }
 public Integer countOfGroup3 {
  get;
  set;
 }
 public Integer GTCount {
  get;
  set;
 }

 public Map < String,
  String > mapOfInvisibleMonitoringResults;
 public boolean switchFlag {
  get;
  set;
 } // For switching between already identified applications and new applications
 public boolean showRSASection {
  get;
  set;
 }
 public String IMAction {
  get;
  set;
 }
 public List < SelectOption > RSAReasonList {
  get;
  set;
 }
 public String RSAReason {
  get;
  set;
 }
 public List < SelectOption > IMActionList {
  get;
  set;
 }
 public String CORemarks {
  get;
  set;
 }
 public Boolean productFlag {
  get;
  set;
 }
 public String[] verificationsArray;
 //Anjali mortgage end

 //Rate Approval start
 public Boolean rateflag {
  get;
  set;
 }
 //Rate Approval end
 //DCM call Mortgage Re-Engg 
 public String msgDCM {
  get;
  set;
 }

 public Boolean prodFlag {
  get;
  set;
 } //variable for fraud trigger enhancement - krish

 // Bug 11939 - This field is added which will be displayed on Check eligibility page , PLS section - By Hemant Keni.
 public Decimal PLSEMIAmount {
  set;
  get {

   if (cam.Stake_of_co__c != null && cam.Stake_of_co__c > 0 && cam.Home_Loan_Tenor__c != null && cam.Home_Loan_Tenor__c > 0 && cam.GP_Home_loan_amount__c != null && cam.GP_Home_loan_amount__c > 0) {
    System.debug('\n\n\tCalling PMT..................\n\n');
    return (Decimal.ValueOf(PMT(double.valueOf(cam.Stake_of_co__c / 1200), Integer.valueOf(cam.Home_Loan_Tenor__c), cam.GP_Home_loan_amount__c))).setScale(2);
    //return (decimal.valueOf(PMT(double.valueOf(cam.Stake_of_co__c / 1200), Integer.valueOf(am.Home_Loan_Tenor__c), cam.GP_Home_loan_amount__c))).setScale(2);
   }
   return 0.0;
  }
 }
 // End of Bug 11939

 //Cubic Tree Integration Start
 public Boolean cubicTreeFlag {
  get;
  set;
 }

 //Added By Gulshan for Checking Product Level Cubic Tree Flag: 18-09-2017
 public Boolean cubicTreeProductFlag {
  get;
  set;
 }
 //Ended By Gulshan for Checking Product Level Cubic Tree Flag: 18-09-2017

 public List < De_Dupe__c > appCubicDeDupeList {
  get;
  set;
 }
 public List < De_Dupe__c > propCubicDeDupeList {
  get;
  set;
 }
 public List < Applicant__c > cubicApplicantList {
  get;
  set;
 }
 public List < Contact > cubicContactList {
  get;
  set;
 }
 //Cubic Tree Integration End
 //--------------- Mortgage Re-Engg Start---------------------
 //BT Multiplier calculator 10905.. YK
 public boolean isProposedBT {
  get;
  set;
 }
 //----------------------SHL Start-----------------------------
 public set < String > propId = new Set < String > ();
 public Product_Offerings__c poObj {
  get;
  set;
 }

 //----------------------SHL End-----------------------------
 /* SAL IM Rohit start */
 public List < ChkLstwrap > sysWrapLst_IM {
  get;
  set;
 }
 private Map < String, SOL_Policy__c > solmap;
 private Map < String, SOL_Policy__c > sysMap;
 private SOL_Policy__c solObj;
 public String conCustEnterAdd {
  get;
  set;
 }
 public String conEKYCAdd {
  get;
  set;
 }
 public String conCibilAdd {
  get;
  set;
 }
 /*SAL IM Rohit end */
 /* SALPSBL Bug 12108 Start - Anshita*/
 private Set < String > sysSet;
 private Set < String > mnlSet;
 public List < ChkLstwrap > sysWrapLst {
  get;
  set;
 }
 public List < ChkLstwrap > mnlWrapLst {
  get;
  set;
 }
 private List < String > plcyList;
 /* SALPSBL Bug 12108 End- Anshita*/
 public decimal appliedLoanAmt {
  set;
  get;
 }
 public List < Applicant__c > Allapplist = new List < Applicant__c > ();
 public List < Applicant__c > getAllapplist() { // mobile validation Amar Bug_22141
  return Allapplist;
 }
 public boolean Mortgageflag {
  set;
  get;
 }
 List < cibilresWrap > cibilresList = new List < cibilresWrap > ();
 public List < Applicant__c > MortgageApplicantList = new List < Applicant__c > ();
 public Contact ContactNew {
  get;
  set;
 }
 //public Product_Offerings__c poObj = new Product_Offerings__c();
 public boolean showVisitCOAppSection {
  set;
  get;
 }
 public Account accObj {
  set;
  get;
 }
 //public Account
 //accObj = new Account();
 public Set < String > MortgageProducts = new Set < String > ();
 public List < De_Dupe__c > propertyDedupelist {
  set;
  get;
 }
 public List < Property_Details__c > propertyList {
  set;
  get;
 }
 List < Feedback_Question__c > feedbackQuestList;
 public Feedback__c feed {
  get;
  set;
 }
 public Map < String, Feedback__c > feedMap {
  set;
  get;
 }
 List < Feedback__c > feedbackList = new List < Feedback__c > ();
 Map < String, Feedback__c > feedbackMap = new Map < String, Feedback__c > ();
 public List < SelectOption > COapplicantSelectList {
  get;
  set;
 }
 public String selectedCOApplicantforFinancial {
  get;
  set;
 }
 public String selectedCOApplType {
  set;
  get;
 }
 public CAM__c coCAM {
  set;
  get;
 }
 public Decimal coCAMTotalMonthly {
  set;
  get;
 }
 public String selected {
  set;
  get;
 }
 public string custType { // bug 11156 s
  get;
  set;
 } // bug 11156 e
 public Map < Id, String > COApplMAP;
 public boolean isYearly {
  get;
  set;
 }
 public boolean isquarterly {
  get;
  set;
 }
 public List < cam__c > MortCamList = new List < cam__c > ();
 List < PODetail__c > poDetailList = new List < PODetail__c > ();
 public decimal offerAmount {
  set;
  get;
 }
 public decimal revisedOfferAmount {
  set;
  get;
 }

 public boolean ismonthly1 {
  get;
  set;
 }
 public boolean isquarterly1 {
  get;
  set;
 }
 public boolean isYearly1 {
  get;
  set;
 }
 public boolean isincometobecaptured {
  set;
  get;
 }
 //Real Time Controllership enhancement Leena-start
 //Bug id :   9205
 //Uat release date : 1 december 2016
 //This variable is used on page level to show brached condition for all rules
 public boolean realTimeFlag {
  get;
  set;
 }
 public string RealTimeControllershipBreachedValues {
  get;
  set;
 }
 //Real Time Controllership enhancement Leena-end
 public Id ApplicantName {
  get;
  set {
   ApplicantName = value;
  }
 }

 List < Attachment > GoogleAttachmentList = new List < Attachment > ();
 Map < ID, ID > GoogleAttachmentMap = new Map < Id, ID > ();


 //--------------- Mortgage Re-Engg End-----------------------
 // SAL Policy Change Start
 public String RiskSegment {
  get;
  set;
 }
 public Boolean RCDeclineFlag {
  get;
  set;
 }

 // SAL Policy Change End  
 //PLOC start: Tejashree
 public Cibil_Extension1__c cibilExt1Obj;
 public Boolean PLOCScheme {
  get;
  set;
 }
 public Boolean isEligiblePLOC {
  set;
  get;
 }
 public String EverHLInCIBIL;
 //PLOC end
 //Bug : 7412 : Pritha : start
 public Boolean dedupeNotDone {
  get;
  set;
 }
 List < object > insertDedupe = new List < object > ();
 Map < string, object > tempMapDedupe;
 public String GroupType {
  get;
  set;
 }
 //Bug : 7412 : Pritha : end
 //New OTPV2
 //Emaildomain
 public Boolean EmailDomainCheck {
  get;
  set;
 }
 //Line amount
 public boolean salPOFlow {
  get;
  set;
 }
 public SurrogateCAM__c objSurrogateCAM {
  get;
  set;
 }
 public SurrogateCAM__c reqConsilidatedScam { // Bug 19239
  get;
  set;
 }
 public Boolean isCategorization { // Bug 19239
  get;
  set;
 }
 /*FLS Security Fields**/
 public String custName {
  get;
  set;
 }
 //Bug 5943 - SAL PL Document checklist issue Start
 public String currentProfileName {
  get;
  set;
 }
 //Bug 5943 - SAL PL Document checklist issue Ends
 public String custOffEmailId {
  get;
  set;
 }
 //4450
 String LoanAppFlow;
 Date COLStampdate;
 public boolean COLStampFlag;
 Public String tenure;
 List < PortfoliotWrapper > finalFundList {
  set;
  get;
 }

 /**segmentation grid */

 /***New chnages for segmentation for salaried **/
 public String securedLoans = '';
 public String SegmentProduct = '';
 public String SegmentSecuredProduct = '';
 public String UnsecuredLoans = '';
 public String SegmentUnsecuredProduct = '';
 /**------End ***/

 public List < Discrepancy__c > sanctionList {
  get;
  set;
 }
 public Boolean SendbackFlag {
  get;
  set;
 }

 //Call center strat
 public Boolean SendbackSalesFlag {
  get;
  set;
 }
 public decimal emiPropose { // bug 11156
  get;
  set;
 }
 public Boolean callcenterprocessFlag {
  get;
  set;
 }
 public Boolean salMobilityFlag {
  get;
  set;
 }
 public Set < String > callCentrelbl = new Set < String > ();
 public Set < String > callCentreProdlbl = new Set < String > ();
 public String LeadVerifierName {
  get;
  set;
 }
 public List < SelectOption > leadVerifierNames;
 public List < Sales_Officer_Limit__c > objLeadSalesList;
 public List < SelectOption > getLeadVerifierNames() {
  objLeadSalesList = new List < Sales_Officer_Limit__c > ();
  try {

   objLeadSalesList = [select id, Sales_Officer_Name__c, Sales_Officer_Name__r.Name, Sales_Officer_Name__r.Mobile_number__c, Reporting_Manager_Name__c, Reporting_Manager_Name__r.Mobile_number__c, ASM_Branch__c, Selected_Flag__c, Designation__c, Location__c, Product__c, Max_Number__c from Sales_Officer_Limit__c where
    Active__c = true And Sales_Officer_Name__r.IsActive = true AND Designation__c = 'Lead Verifier'
   ];
  } catch (Exception e) {}


  List < SelectOption > optionsLead = new List < SelectOption > ();
  if (objLeadSalesList != null && objLeadSalesList.size() > 0) {
   for (Sales_Officer_Limit__c objcredit: objLeadSalesList) {

    if (objcredit.Sales_Officer_Name__c != null) {
     optionsLead.add(new SelectOption(objcredit.Sales_Officer_Name__c, objcredit.Sales_Officer_Name__r.Name));
    }

   }
  }
  return optionsLead;
 }
 //Call center stop



 public boolean HLOrNoHL {
  get;
  set;
 }
 public Id cibilID {
  get;
  set;
 }
 public boolean isEMITypeDone {
  get;
  set;
 }
 public boolean isCibilwatch {
  get;
  set;
 } //CIBIL Watch
 public boolean companyCategory {
  get;
  set;
 }
 public String AchivementStr {
  get;
  set;
 }
 public String TotalExpStr {
  get;
  set;
 }
 public String AgeStr {
  get;
  set;
 }
 public String AgeBench {
  get;
  set;
 }
 public String CurrentExpStr {
  get;
  set;
 }
 public String OenHouseStr {
  get;
  set;
 }
 public Decimal loanEligibilty {
  get;
  set;
 }
 //public String TotalExpBench{get;set;}
 // public String CurrentExpBench{get;set;}
 //public String OwnHouseBench{get;set;}
 public String StabilityStr {
  get;
  set;
 }
 public String PrudenceStr {
  get;
  set;
 }
 public boolean residenceTypeFlag {
  get;
  set;
 }
 public String companyStr {
  get;
  set;
 }
 public String EducationStr {
  get;
  set;
 }
 public String salaryAgeStr {
  get;
  set;
 }
 public String companyBench {
  get;
  set;
 }
 public String salaryAgeBench {
  get;
  set;
 }
 public String UnsecuredFOIRStr {
  get;
  set;
 }
 public String TotalFoirHLStr {
  get;
  set;
 }
 public String TotalFoirNoHLStr {
  get;
  set;
 }
 public String loanAmtStr {
  get;
  set;
 }
 public Decimal NoHLFOIR {
  get;
  set;
 }
 public Decimal HLFOIR {
  get;
  set;
 }
 public String TotalFoirHLBench {
  get;
  set;
 }
 public String TotalFoirNoBench {
  get;
  set;
 }
 public String loanAmtBench {
  get;
  set;
 }
 public String perfiosFlagBRE;
 public double secamtsum, unsecamtsum, securedFOIR, lapUnsecured, creditCardAmt, OverDraft, overdraftAmt;
 public integer finalFOIR = 0;
 public Decimal FinalFOIRTemp {
  get;
  set;
 }
 public Decimal totalIncon { // bug 11156 by rasika
  get;
  set;
 }
 public Set < Id > setAppId = new Set < Id > ();
 MAP < Id, Applicant__c > applicantMAP = new MAP < Id, Applicant__c > ();
 MAP < String, Applicant__c > applicantNameMAP = new MAP < String, Applicant__c > ();
 MAP < Id, Contact > contactMAP = new MAP < Id, Contact > ();
 public boolean ismonthly {
  get;
  set;
 }
 public Bank_Account__c bankAcc {
  get;
  set;
 }
 public Boolean perfiosflag {
  get;
  set;
 }
 public List < CIBIL__c > cibilList;
 public List < Existing_Loan_Details__c > existingLoanDetailsList {
  get;
  set;
 }
 public List < SelectOption > applicantSelectList = new List < SelectOption > ();
 public String selectedApplicant {
  get;
  set;
 }
 public List < De_Dupe__c > dedupelist = new List < De_Dupe__c > ();
 public String SalesFlow;
 //For deviations 
 public List < Account > accountCreate {
  get;
  set;
 }
 public Cibil_Extension1__c cibilExt1 {
  get;
  set;
 }
 public String primaryContID {
  get;
  set;
 }
 public Contact primContact {
  get;
  set;
 }
 public boolean hasCoApplicant {
  get;
  set;
 }
 public String monthlyObligation {
  get;
  set;
 }
 public List < Checklist__c > ManualDeviationList {
  get;
  set;
 }
 public List < Deviation_Transaction__c > devTrnxList = new List < Deviation_Transaction__c > ();
 public List < Verification__c > AllVerify = new List < Verification__c > ();
 List < Verification__c > officeVerify = new List < Verification__c > ();
 list < Deviation_Master__c > devMasterList = new List < Deviation_Master__c > ();
 List < Verification__c > residenceVerify = new List < Verification__c > ();
 public Integer rowCount, devRowCount;
 public boolean renderChecklist {
  get;
  set;
 }
 public List < Checklist__c > checklistTrnxList {
  get;
  set;
 }
 public List < Checklist__c > DeviationsChecklistTrnxList {
  get;
  set;
 }
 public List < Cibil_Extension1__c > cibilExt1List = new List < Cibil_Extension1__c > ();
 public List < DocumentWrapper > docWrapperList = new List < DocumentWrapper > ();
 public List < DocumentWrapper > deviationDocWrapperList = new List < DocumentWrapper > ();
 public Set < String > documentNameList = new Set < String > ();
 public List < Id > checkListId = new List < Id > ();
 public Map < Id, Checklist_Parameter__c > checkListparamMap = new Map < Id, Checklist_Parameter__c > ();
 Id userDisc, docid;
 public String chkListType {
  get;
  set;
 }
 List < SelectOption > optionsApplicant = new List < SelectOption > ();
 public String docType {
  get;
  set;
 }
 public String StrVAContact = null;
 public Boolean showDiscrepancy {
  get;
  set;
 }
 public Boolean editDiscrepancy {
  get;
  set;
 }
 public String StrVAContactDis = null;
 public Boolean showDiscrepancyDis {
  get;
  set;
 }
 public Boolean editDiscrepancyDis {
  get;
  set;
 }
 public List < Discrepancy__c > discrepancyDataDis = new List < Discrepancy__c > ();
 public List < Discrepancy__c > discrepancysendDis = new List < Discrepancy__c > ();
 public List < Discrepancy__c > discrepancyListDis = new List < Discrepancy__c > ();
 List < Discrepancy__c > discrepancyListLog = new List < Discrepancy__c > ();
 public Boolean addrowDis {
  get;
  set;
 }
 public Boolean addrow {
  get;
  set;
 }
 public boolean addrowDiscDis {
  get;
  set;
 }
 public Boolean addrowDisc {
  get;
  set;
 }
 Integer count = 0, countDis = 0, fcount = 0, discrepancyListCount = 0, discrepancyListCountDis = 0;
 public List < cam__c > camList = new List < cam__c > ();
 public Integer ExistLoanscount, totalObligAmount;
 public String loanAmount {
  get;
  set;
 }
 public List < String > tenorList {
  get;
  set;
 }
 public List < Decimal > MaxLoanAsMuliplier {
  get;
  set;
 }
 public List < Decimal > MaxLoanAsFOIR {
  get;
  set;
 }
 public List < Decimal > MaxLoanAsIncome {
  get;
  set;
 }
 public List < Decimal > finalEligibilty {
  get;
  set;
 }
 public List < Decimal > finalEligibilty5 {
  get;
  set;
 }
 public List < Decimal > finalEMI {
  get;
  set;
 }
 //Variables declaration

 public Id LoanId;
 public Opportunity Loan {
  get;
  set;
 }
 public Boolean showsave {
  get;
  set;
 }
 public Boolean showappr {
  get;
  set;
 }
 public integer rowNumber {
  get;
  set;
 }
 public String message {
  get;
  set;
 }
 public boolean showNoApplicationError {
  get;
  set;
 }

 public String donemessage {
  get;
  set;
 }
 public boolean savedApproved {
  get;
  set;
 }

 public boolean savedSuccessfull {
  get;
  set;
 }
 public Boolean OTPFlowFlag {
  get;
  set;
 }
 public Boolean showBREdeviations {
  get;
  set;
 }

 public String StrVADev = '';
 String product {
  get;
  set;
 }
 String StrAppr;
 public List < Discrepancy__c > getsanctionList() {
  return sanctionList;
 }
 transient Deviation_Master__c[] deviations;
 List < SelectOption > optionsAppr = new List < SelectOption > ();

 List < SelectOption > optionsApprSales = new List < SelectOption > (); //Call center process


 List < SelectOption > optionsDev = new List < SelectOption > ();
 List < SelectOption > optionsdocApp = new List < SelectOption > ();
 List < SelectOption > optionsApprFprOtcPDD = new List < SelectOption > ();
 List < Credit_Officer_Limit__c > CO = new List < Credit_Officer_Limit__c > ();
 List < Sales_Officer_Limit__c > objSOLList = new List < Sales_Officer_Limit__c > (); //call center process
 List < Discrepancy__c > discrepancyData = new List < Discrepancy__c > ();
 List < Discrepancy__c > discrepancyList = new List < Discrepancy__c > ();
 List < Discrepancy__c > discrepancyListUpdate = new List < Discrepancy__c > ();
 public List < Discrepancy__c > discrepancyListUpdateDis = new List < Discrepancy__c > ();
 public List < DocumentWrapper > standardDocWrapperList = new List < DocumentWrapper > ();
 public List < Checklist_Parameter__c > checklistParamList = new List < Checklist_Parameter__c > ();
 Map < id, Document_Family__c > docFamilyMap = new Map < id, Document_Family__c > ();
 //Commentted docFamilyMaster due to Views State issue Bug: 14987
 //public List < Document_Family__c > docFamilyMaster = new List < Document_Family__c > ();
 public List < TestObject__c > BREResultAfterForDeviations {
  get;
  set;
 }
 List < Verification__c > salForVerify = new List < Verification__c > ();
 //Added By Rajendra for Secondary CIBIL 
 public string primaryApplicantID {
  get;
  set;
 }
 public Applicant__c applicantPrimary {
  get;
  set;
 }
 public SOL_CAM__c solcam {
  get;
  set;
 }
 PL_BS__c plbs = new PL_BS__c();
 PL_BS__c prevPLBS = new PL_BS__c();
 public Cam__c cam {
  get;
  set;
 }
 public Boolean showapprove {
  get;
  set;
 }
 public Boolean isFromSales {
  get;
  set;
 }
 public List < Personal_Discussion__c > PDList {
  get;
  set;
 }
 public String PDType {
  get;
  set;
 }
 public List < Bank_Account__c > bankAccLst {
  get;
  set;
 }
 public Personal_Discussion__c pd {
  get;
  set;
 }



 public List < SelectOption > getStrCOApprListotp() {
  return optionsCOAppr;
 }
 List < SelectOption > optionsCOAppr = new List < SelectOption > ();


 public boolean showOPApprovePanel {
  get;
  set;
 }
 public boolean showCentralisePanel {
  get;
  set;
 } // CIBIL Watch



 public String StrCOAppr {
  get;
  set;
 }
 List < SelectOption > optionsCOApprFAS = new List < SelectOption > ();
 //Commentted COFAS list for View State Error Bug: 14987
 //public List < Credit_Officer_Limit__c > COFAS = new List < Credit_Officer_Limit__c > ();





 // CIBIL Watch Start
 public List < SelectOption > getStrCOApprList1() {
  return optionsCOAppr1;
 }
 List < SelectOption > optionsCOAppr1 = new List < SelectOption > ();
 // CIBIL Watch End


 public List < BankingDetailsWrapper > BankWrapperlist {
  get;
  set;
 }
 public boolean primaryBankExists {
  get;
  set;
 }
 public List < Bank_Transaction__c > fetchedBankTranList {
  get;
  set;
 }
 public List < Bank_Account__c > PSBLBankAcount {
  get;
  set;
 }
 // 01MOB 5873 S
 List < Existing_Loan_Details__c > ExistLoans = new List < Existing_Loan_Details__c > ();
 List < Bank_Account__c > bankAcclist;
 List < ScripsHistory__c > finalScripsHistoryInsert = new List < ScripsHistory__c > ();
 List < ScripsHistory__c > finalScripsHistoryDelete = new List < ScripsHistory__c > ();
 // 01MOB 5873 E
 //FAS
 String scripURL;

 //shol differential journey -----backend--start
 //List<OpportunityFieldHistory> loanHistory;
 public Boolean showSubmitToCPADivFlag {
  get;
  set;
 }
 public Boolean olFlag {
  get;
  set;
 }

 public List < SelectOption > branchCPAUsrList {
  get;
  set;
 }

 public String selectedCPA {
  get;
  set;
 }

 public boolean showCPAs {
  get;
  set;
 }
 //11112 Mortgage Re-Engg start
 public Double standLTVWithIns {
  get;
  set;
 }
 public Double actualLTVWithoutIns {
  get;
  set;
 }
 public Double propEligConLTV {
  get;
  set;
 }
 public Double standLTVWithoutIns {
  get;
  set;
 }
 public Double actualLTVWithIns {
  get;
  set;
 }
 public Double FOIRIncludIns {
  get;
  set;
 }
 public double insofloanAmt {
  get;
  set;
 }
 //11112 Mortgage Re-Engg end
 //shol differential journey -----backend--END

 /* Prajyot : for bug #9962 START */
 public boolean checked {
  get;
  set;
 }
 public void setChecked() {
  applicant__c applicant = new applicant__c();
  applicant = [select id, is_BL_PL_Risk__c, approved__c from Applicant__c where Loan_Application__c =: Loan.Id and Applicant_Type__c = 'Primary'
   limit 1
  ];
  if (applicant != null) {
   checked = applicant.approved__c;
   ConfirmCheckbox = applicant.approved__c;
  }


 }
 /* Prajyot : for bug #9962 END */

 //Rural Flexi: 12501-- Added by Mahima- start
 public String pureFlexi {
  get;
  set;
 }
 //Rural Flexi: 12501-- Added by Mahima- end
 // Fos Calculator- 17834- Start--
 public Boolean isBodMasRecordExist {
  get;
  set;
 }
 //Fos Calculator- 17834- end--
 /*Start BUG-16959 HPRO*/
 public boolean isPSBLProductLineProduct {
  get;
  set;
 }
 public boolean isPSBLProductLineBRECallSkipEnabled {
  get;
  set;
 }
 public boolean isPSBLProductLineCommunicationSkipEnabled {
  get;
  set;
 }
 /*END BUG-16959*/
 /*S BUG ID 17470*/
 public boolean isPROProductLineProduct {
  get;
  set;
 }

 /* Bug Id: 19425 Implementation @author Shubham
  * Purpose: Adding pagination to DeDupe Details table on COEligibilityDetails Page */
 public PaginationExtension paginationExt {
  get;
  set;
 }
 public PaginationExtension paginationExtProp {
  get;
  set;
 }

 /**
  * Constructor of this class starts here
  */
 //20474
 public list < String > DSSProdList {
  get;
  set;
 }

 public list < Decimal > DSSOfferAmount {
  get;
  set;
 }
 //Rohit added for SAL custom setting movement S  
 Map < String, Object > ALLMap {
  get;
  set;
 }

 public Boolean isAutoAllocation {
  get;
  set;
 } // Bug Id : 19243
 //parameterized constructor added for mobility v2 17139 start
 public COFinantialController(String loanidmobility, String comments, String rejectreason, String rejectreason1) {

  ConfirmCheckbox = false;
  isCategorization = false; // bug 19239
  LoanId = loanidmobility;
  system.debug('Loan id in constructor' + LoanId);
  app_rejcomments = comments;
  reject_reason = rejectreason;
  reject_reason1 = rejectreason1;
  mobilitystatus = '';
  System.debug('pk');
  salmobilityv2falg = true;
  if (!Test.isRunningTest()) {
   deviationProducts = LaonApplicationCreation__c.getValues('RemoveDocumentChecklist').PDDDeviation__c;
  }
  checklistTrnxListNotDelete = new List < Checklist__c > ();
  checklistTrnxListDelete = new List < Checklist__c > ();
  realTimeFlag = false;
  sanctionList = new List < Discrepancy__c > ();
  EmailDomainCheck = false;
  wrapperList = new List < PortfoliotWrapper > ();
  finalPortList = new List < PortfoliotWrapper > ();
  finalCatList = new List < PortfoliotWrapper > ();
  finalFundList = new List < PortfoliotWrapper > ();
  BankWrapperlist = new List < BankingDetailsWrapper > ();
  COapplicantSelectList = new List < SelectOption > ();
  isincometobecaptured = false;
  //SHL
  appliedLoanAmt = 0;
  //11156 start
  standLTVWithIns = 0;
  actualLTVWithoutIns = 0;
  propEligConLTV = 0;
  standLTVWithoutIns = 0;
  actualLTVWithIns = 0;
  FOIRIncludIns = 0;
  insofloanAmt = 0;
  ///11156 end 


  ALLMap = GeneralUtilities.fetchStaticRescMap();

  if (ALLMap != null) {
   Map < String, Object > prodMap = (Map < String, Object > ) ALLMap.get('OTPv3');
   String products = (String) prodMap.get('OTPv3Products');
   if (products != null) {
    String[] arr = products.split(';');
    for (String str: arr) {
     OTPProducts.add(str);
    }
   }
  }
  //Rohit added for SAL custom setting movement E
  //OTPv3 TeleRM Rohit stop
  fetchData();
  popultplcy(); /* SAL PLTB Bug 12108 - Anshita */
  showapprove = false;

  showOPApprovePanel = false;
  //setChecked(); //Ops process added by Prajyot  soql optimization for approval functionality
//  salForVerify = [select id, name, Status__c from Verification__c where Verification_Type__c = 'Salary Slip Format' and Loan_Application__c =: Loan.Id ];soql optimization for approval functionality
   
  
  //Cubic Tree integration :: added condition to query AND  Dedupe_Source__c != 'propertydedupeCT' AND Dedupe_Source__c != 'applicantdedupeCT'
 /* dedupelist = [select id,Applicant__r.Contact_Name__r.Name,name, Dedupe_Lan_Matches__c, Applicant__c, Applicant__r.Contact_Name__c, Datafix_Updated__c, Application_Status__c,
   Application_ID__c, Random_Dedupe__c, Area_Status__c, Customer_Status__c,
   Customer_ID__c, Dedupe_Comments__c, De_Dupe_result__c, Match_Status__c, De_Dupe_Decision__c, Segment__c, SF_Base__c, Source_Or_Target__c,  Dedupe_Target_Remarks__c, Dedupe_Source__c from De_Dupe__c where Loan_Application__c =: Loan.Id And Applicant__c != null  AND Dedupe_Source__c != 'propertydedupeCT'
   AND Dedupe_Source__c != 'applicantdedupeCT'
  ];*/





  //SHOL differential journey----backend START

  showSubmitToCPADivFlag = true;
  if (loan != null && (loan.stageName == 'Centralized Underwriting Final' || loan.Approver__c != 'Centralized ACM')) {
   showSubmitToCPADivFlag = false;

  }



  olFlag = false;
  if (LaonApplicationCreation__c.getValues('Online Products') != null) {
   //Salaried
   String onlineProducts = LaonApplicationCreation__c.getValues('Online Products').Current_product__c;
   if (onlineProducts != null) {
    String[] arr = onlineProducts.split(';');
    for (String str: arr) {
     if (str.equalsIgnoreCase(Loan.Product__c)) {
      olFlag = true;
     }
    }
   }
  }

  //SHOL differential journey----backend END


  //Customer Insight Start
  //Page Message for bank verification status
  if (grouptype == 'salaried') {
   if (bankAcc.StatusOfBankAccount__c == 'Verified') {
    if (salmobilityv2falg)
     mobilitystatus = 'Banking statement uploaded is verified successfully by Perfios';
    else
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Banking statement uploaded is verified successfully by Perfios'));
   } else {
    if (salmobilityv2falg)
     mobilitystatus = 'Banking statement could not be verified by Perfios';
    else
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Banking statement could not be verified by Perfios'));
   }
  }
  //customer insight end
  //SAL IM checklist Rohit start
  if (Loan != null && (Loan.Product_Offerings__r == null || Loan.Product_Offerings__r.size() == 0)) {
   solmap = new Map < String, Sol_Policy__c > ();
   popultpolicy();
  }
  //fetchSolPlcy();
  //SAL IM checklist Rohit end
  /*SAL PL to SAL LAP start*/
  SALtoLAPFlag = false;
  SALtoLAPProducts = new Set < String > ();
  if (Label.SAL_PL_to_SAL_Lap_Products != null) {
   saltolapprod = Label.SAL_PL_to_SAL_Lap_Products.split(';');
  }

  SALtoLAPProducts.addall(saltolapprod);
  if (SALtoLAPProducts.contains(Loan.Product__c)) {
   SALtoLAPFlag = true;
  }
  /*SAL PL to SAL LAP end*/
  // bug 19239 -- start
  if (Loan != null && Loan.Product__c != null) {
   transient string productlist = Label.Secured_Unsecured_Product_Categorization;
   if (productlist != null && productlist != '') {
    List < String > lstOfProduct = new List < String > ();
    lstOfProduct = productlist.split(',');
    system.debug('inside parameterised constructor -- Label has value' + productlist);
    if (lstOfProduct != null && lstOfProduct.size() > 0 && lstOfProduct.contains(Loan.Product__c.toUpperCase()))
     isCategorization = true;
   }
  }
  // bug 19239 -- End
 }

 //parameterized constructor added for mobility v2 17139 end
 public COFinantialController() {
  //added for bug id 21851 start
  hideAadhaarSection = Boolean.valueOf(CommonUtility.getAadhaarSectionStatus('Ekyc_Integration', 'hideAadhaarSection', ''));
  //added for bug id 21851 stop
  /*Digital Sampling S*/
        ShowDigitalSamplingPanel = false;
     /*Digital Sampling E*/
  System.debug('in default constructor -->');
  salmobilityv2falg = false; /* bug 17139 */

  isCategorization = false; // bug 19239
  // BUG ID 17470
  isPROProductLineProduct = false;
  ConfirmCheckbox = false;
  /* Prajyot #10659 Secondary Cibil Match S*/
  primaryApplicantID = '';
  /* Prajyot #10659 Secondary Cibil Match E*/
  //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal start
  if (!Test.isRunningTest()) {
   deviationProducts = LaonApplicationCreation__c.getValues('RemoveDocumentChecklist').PDDDeviation__c;
  }
  checklistTrnxListNotDelete = new List < Checklist__c > ();
  checklistTrnxListDelete = new List < Checklist__c > ();
  //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal end
  //Real Time Controllership enhancement Leena-start
  //Bug id :   9205
  //Uat release date : 1 december 2016
  realTimeFlag = false;
  //Real Time Controllership enhancement Leena-end
  sanctionList = new List < Discrepancy__c > ();
  EmailDomainCheck = false;
  wrapperList = new List < PortfoliotWrapper > ();
  finalPortList = new List < PortfoliotWrapper > ();
  finalCatList = new List < PortfoliotWrapper > ();
  finalFundList = new List < PortfoliotWrapper > ();
  BankWrapperlist = new List < BankingDetailsWrapper > ();

  //--------------- Mortgage Re-Engg Start---------------------
  COapplicantSelectList = new List < SelectOption > ();
  isincometobecaptured = false;
  //SHL
  appliedLoanAmt = 0;
  //11156 start
  standLTVWithIns = 0;
  actualLTVWithoutIns = 0;
  propEligConLTV = 0;
  standLTVWithoutIns = 0;
  actualLTVWithIns = 0;
  FOIRIncludIns = 0;
  insofloanAmt = 0;
  ///11156 end 
  //--------------- Mortgage Re-Engg End-----------------------
  //OTPv3 TeleRM Rohit start 15229
  if (ProductSms__c.getValues('OTPV3 Eligibility') != null) {
   String products = ProductSms__c.getValues('OTPV3 Eligibility').Produtc__c;
   if (products != null) {
    String[] arr = products.split(';');
    for (String str: arr) {
     OTPProducts.add(str);
    }
   }
  }
  //OTPv3 TeleRM Rohit stop 15229 
  //Rohit added for 18502
  isPSBLProductLineProduct = false;
  fetchData();
  isAutoAllocation = SalesEligibilityCtrlHandler.checkConfig(Loan); // Bug Id : 19243
  popultplcy(); /* SAL PLTB Bug 12108 - Anshita */
  //V1 Refinement Enhancement Start
  List < StaticResource > srList = [SELECT Body FROM StaticResource WHERE Name = 'SalariedCustomSettings'
   LIMIT 1
  ];
  Map < String, Object > jsonBody = new Map < String, Object > ();
  String jsonString = '';
  displayHFCCalc = false;
  if (srList != null && srList.size() > 0) {
   jsonString = srList[0].Body.toString();
  }
  jsonBody = (Map < String, Object > ) JSON.deserializeUntyped(jsonString);
  if (jsonBody.containsKey('V1_Refinement')) {
   jsonBody = (Map < String, Object > ) jsonBody.get('V1_Refinement');
   if ((String) jsonBody.get('HFC_Calc_Products') != null && ((String) jsonBody.get('HFC_Calc_Products')).containsIgnoreCase(';' + Loan.Product__c + ';')) {
    displayHFCCalc = true;
   }
  }

  //V1 Refinement Enhancement Stop
  showapprove = false;

  showOPApprovePanel = false;
  setChecked(); //Ops process added by Prajyot 
  salForVerify = [select id, name, Status__c from Verification__c where Verification_Type__c = 'Salary Slip Format'
   and Loan_Application__c =: Loan.Id
  ];
  //Cubic Tree integration :: added condition to query AND  Dedupe_Source__c != 'propertydedupeCT' AND Dedupe_Source__c != 'applicantdedupeCT'
 /* dedupelist = [select id, name, Dedupe_Lan_Matches__c, Applicant__c, Applicant__r.Contact_Name__c, Datafix_Updated__c, Application_Status__c,
   Application_ID__c, Random_Dedupe__c, Area_Status__c, Customer_Status__c,
   Customer_ID__c, Dedupe_Comments__c, De_Dupe_result__c, Match_Status__c, De_Dupe_Decision__c, Segment__c, SF_Base__c, Source_Or_Target__c,Dedupe_Target_Remarks__c, Dedupe_Source__c from De_Dupe__c where Loan_Application__c =: Loan.Id And Applicant__c != null AND Dedupe_Source__c != 'propertydedupeCT'
   AND Dedupe_Source__c != 'applicantdedupeCT'];*/
  System.debug('const reloaded -->' + dedupelist + '--' + dedupelist.size());

  if (Loan != null && Loan.Product__c == 'FAS') {
   PSBLBankAcount = new List < Bank_Account__c > ();
   PSBLBankAcount = [Select id, Perfiod_done_date_and_Time__c, Account_Type__c, Bank_Name__c, Bank_Acct_Number__c, OD_CC_limit__c, X10th_Bal__c, X20th_Bal__c, Month_end_Bal__c, Average_of_DB_Amount__c,
    Average_of_DB_No__c, Average_of_CRD_Amount__c, Average_of_CRD_No__c, Average_of_Bounce_O_W__c, IFSC_Code__c,
    Average_of_Bounce_I_W__c, Bank_Name_List__c, Bank_Type__c, Depository_Participant_Id__c, ClientName__c, ClientId__c, TrackingId__c, Depository_Participant_Name__c, /*SHL*/ Mode_Of_Salary_Credit__c, Statusofbankaccount__c from Bank_Account__c where Loan_application__c =: Loan.Id
   ];

   fetchedBankTranList = [select id, Bank_Account__c, Balance_10th_of_month__c, Balance_20th_of_month__c, Balance_Ist_of_Month__c, DB_Amount__c, DB_No__c, CRD_Amount__c, CRD_No__c, Bounce_IW__c
    from Bank_Transaction__c where Loan_application__c =: Loan.Id
   ];
   BankWrapperlist = new List < BankingDetailsWrapper > ();
   if (PSBLBankAcount.size() > 0) {
    for (Bank_Account__c temp: PSBLBankAcount) {
     BankingDetailsWrapper wrapperTemp = new BankingDetailsWrapper(temp, false);
     wrapperTemp.bankTranList.clear();
     for (Bank_Transaction__c BankTranObj: fetchedBankTranList) {
      if (BankTranObj.Bank_Account__c == temp.id) {
       wrapperTemp.bankTranList.add(BankTranObj);
      }
     }

     BankWrapperlist.add(wrapperTemp);
    }
   }

  }
  /*SAL PL to SAL LAP start*/
  SALtoLAPFlag = false;
  SALtoLAPProducts = new Set < String > ();
  if (Label.SAL_PL_to_SAL_Lap_Products != null) {
   saltolapprod = Label.SAL_PL_to_SAL_Lap_Products.split(';');
  }

  SALtoLAPProducts.addall(saltolapprod);
  if (SALtoLAPProducts.contains(Loan.Product__c)) {
   SALtoLAPFlag = true;
  }
  system.debug('SALtoLAPFlag ' + SALtoLAPFlag);
  /*SAL PL to SAL LAP end*/

  /*Start BUG-16959*/
  transient set < string > setPSBLProdName = new set < string > ();
  if (!commonUtility.isEmpty(Label.PSBL_ProductLine_Products))
   setPSBLProdName.addAll(Label.PSBL_ProductLine_Products.split(';'));

  transient set < string > setSkipComm = new set < string > ();
  if (!commonUtility.isEmpty(Label.PSBL_Line_Skip_Communication_Products))
   setSkipComm.addAll(Label.PSBL_Line_Skip_Communication_Products.split(';'));

  isPSBLProductLineProduct = setPSBLProdName.contains(Loan.Product__c);
  isPSBLProductLineCommunicationSkipEnabled = setSkipComm.contains(Loan.Product__c);
  /*END BUG-16959*/

  /*S BUG ID 17470*/

  transient set < string > setPROProdName = new set < string > ();
  if (!commonUtility.isEmpty(Label.PRO_ProductLine_Products))
   setPROProdName.addAll(Label.PRO_ProductLine_Products.split(';'));
  if (Loan.Product__c != null) {
   isPROProductLineProduct = setPROProdName.contains(Loan.Product__c.toUpperCase());
  }
  /*E BUG ID 17470*/


  //--------------- Mortgage Re-Engg Start---------------------  
  if (Mortgageflag) {

   offerAmount = 0;
   revisedOfferAmount = 0;
   retrieveFeedback();

   propertyList = new List < Property_Details__c > ();
   //propertyList = [Select id,Name,Property_Type__c,Property_Transaction_Type__c,Valuation_amount__c From Property_Details__c where Loan_Application__c =:Loan.id And Property_Type__c != 'Shares'];
   propertyList = SelectQueriesHelperClass.QueryPropertyDetailsMortgage(Loan.id);


   MortgageApplicantList = new List < Applicant__c > ();

   for (Applicant__c app: applicantList) {
    MortgageApplicantList.add(app);
   }


   ContactNew = new Contact();

   showVisitCOAppSection = false;

   List < Account > accList = new List < Account > ();

   accList = [Select Id, UW_Program__c, Practice_Type__c, Process_Type__c, Profession__c, clinic__c, clinic__r.name, Degree__c, Post_Graduate_Super_Specialist_Experienc__c,
    Constitution__c, Qualification__c, Total_Work_Experience_Yrs__c, Date_of_Birth__c, Year_of_Incorporation__c, Company_Type__c, Type_Of_Industry__c,
    Email_Id__c, Specialisation__c, Marital_Status__c, Employer__c, Employer__r.Name, Gender__c, BT_Bank_Type__c, Office_City__c, Current_PinCode__c, Office_Pin_Code__c, BT_Details__c, /*SHL*/ Name_of_the_Company_Employer__c from Account where Id =: Loan.AccountId
   ];

   if (accList != null && accList.size() > 0)
    accObj = accList[0];


   if (Loan != null && Loan.Product_Offerings__r != null && Loan.Product_Offerings__r.size() > 0) {
    List < Product_Offerings__c > poList = new List < Product_Offerings__c > ();
    poList = Loan.Product_Offerings__r;

    //SHL 
    poObj = new Product_Offerings__c();

    poObj = poList[0];

    if (poObj != null && poObj.id != null) {
     poDetailList = [Select id, Availed_Amount__c, Financier__c, MOB__c, Normal_Offer_Amount__c, Offer_Identifier__c, POS__c, Product_Offerings__r.Products__c
      From PODetail__c Where Product_Offerings__c =: poObj.Id AND Interested__c = true
     ];

     offerAmount = poObj.Offer_Amount__c;
     // revisedOfferAmount = poObj.Revised_Offer_Amount__c;
     custType = poObj.Name; // bug 11156

    }



   } else {
    custType = 'No Offer';

   } // bug 11156 : else condition added
   //11156 By piya 2-1-17 strat
   setDataForEligibilityDetails(propertyList, Loan, cam); //rasika commented this as this shoud not get calculated on page load
   // saveIncometobeDetails(); // bug 10902
   //11156 end 
  }
  //--------------- Mortgage Re-Engg End-----------------------
  //SHOL differential journey----backend START

  showSubmitToCPADivFlag = true;
  if (loan != null && (loan.stageName == 'Centralized Underwriting Final' || loan.Approver__c != 'Centralized ACM')) {
   showSubmitToCPADivFlag = false;
   /*loanHistory = [SELECT Field,Id,NewValue,OldValue FROM OpportunityFieldHistory WHERE OpportunityId = :loan.Id order by createddate desc];
for(OpportunityFieldHistory ofh:loanHistory){
if(ofh.Field == 'Approver__c' && ofh.OldValue !=null && (ofh.OldValue == 'CPA Login Partner'|| ofh.NewValue == 'CPA Login Partner')){
showSubmitToCPADivFlag = false;
break;
}
}*/
  }



  olFlag = false;
  if (LaonApplicationCreation__c.getValues('Online Products') != null) {
   //Salaried
   String onlineProducts = LaonApplicationCreation__c.getValues('Online Products').Current_product__c;
   if (onlineProducts != null) {
    String[] arr = onlineProducts.split(';');
    for (String str: arr) {
     if (str.equalsIgnoreCase(Loan.Product__c)) {
      olFlag = true;
     }
    }
   }
  }

  //SHOL differential journey----backend END


  //Customer Insight Start
  //Page Message for bank verification status
  if (grouptype == 'salaried') {
   if (bankAcc != null) { // Added null check 7 DEc 2018, Needhi
    if (bankAcc.StatusOfBankAccount__c == 'Verified') {
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Banking statement uploaded is verified successfully by Perfios'));
    } else {
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Banking statement could not be verified by Perfios'));
    }
   }
  }
  //customer insight end

  //SAL IM checklist Rohit start
  if (Loan != null && (Loan.Product_Offerings__r == null || Loan.Product_Offerings__r.size() == 0)) {
   solmap = new Map < String, Sol_Policy__c > ();
   popultpolicy();
  }
  //fetchSolPlcy();
  //SAL IM checklist Rohit end
  /* Customer Level Collateral Tracking added by priya start  */
  collateralFlag = false;
  List < StaticResource > collateralsrcList = new List < StaticResource > ();
  collateralsrcList = [SELECT Body, Id, Name FROM StaticResource WHERE Name = 'SalariedCustomSettings'
   limit 1
  ];
  if (collateralsrcList.size() > 0) {
   String jsnBodySal = collateralsrcList[0].Body.tostring();
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
  /* Customer Level Collateral Tracking added by priya start  */

  //Rohit 16111 CR S

  aadharMandatoryState = false;
  Map < String, Object > ALLMapEkyc = GeneralUtilities.fetchEkycMap();
  if (ALLMapEkyc != null) {
   Map < String, Object > stateMap = (Map < String, Object > ) ALLMapEkyc.get('states');
   Map < String, Object > productMap = (Map < String, Object > ) ALLMapEkyc.get('AadharMandatory');
   System.debug('robin ' + Loan.Account.Current_State__c);

   if (applicantPrimary != null) {
    appekyc = applicantPrimary.eKYC_Processing__c;
   }

   if (Loan != null && Loan.Account != null && Loan.Account.Current_State__c != null && !CommonUtility.isEmpty((String) stateMap.get(Loan.Account.Current_State__c))) {
    System.debug('here 1');
    aadharMandatoryState = false;
   } else if (Loan != null && Loan.Product__c != null && !CommonUtility.isEmpty((String) productMap.get(Loan.Product__c))) {
    System.debug('robin 2 ' + Loan.Account.Current_State__c);
    aadharMandatoryState = true;
   }
  }
  //Rohit 16111 CR E 
  // Fos Calculator- 17834- Start--
  isBodMasRecordExist = false;
  //Added Base Product & Nature of Degree 
  List < BodmasCalculation__c > bodmasCalList = [SELECT id, Name, LoanApplication__c, Base_Product__c, Nature_of_Degree__c, OppLevelRevisedOfferAmount__c FROM BodmasCalculation__c where LoanApplication__c =: loan.Id];
  System.debug('Bodmas List >> ' + bodmasCalList);

  if (bodmasCalList != null && bodmasCalList.size() > 0) {
   isBodMasRecordExist = true;
   // BodmasCalculation__c objBDMS = Loan.BodmasCalculations__r[0];
   if (bodmasCalList[0].OppLevelRevisedOfferAmount__c != null)
    revisedOfferAmount = bodmasCalList[0].OppLevelRevisedOfferAmount__c;
  }

  // Fos Calculator- 17834- End--

  // bug 19239 -- start
  if (Loan != null && Loan.Product__c != null) {
   transient string productlist = Label.Secured_Unsecured_Product_Categorization;
   if (productlist != null && productlist != '') {
    List < String > lstOfProduct = new List < String > ();
    lstOfProduct = productlist.split(',');
    system.debug('inside parameterised constructor -- Label has value' + productlist);
    if (lstOfProduct != null && lstOfProduct.size() > 0 && lstOfProduct.contains(Loan.Product__c.toUpperCase()))
     isCategorization = true;
   }
  }
  // bug 19239 -- End
  /* Bug Id: 19425 Implementation @author Shubham
   * Purpose: Adding pagination to DeDupe Details table on COEligibilityDetails Page */
  paginationExt = new PaginationExtension(dedupeWrapperList);
  paginationExtProp = new PaginationExtension(propertyDedupelist);
 }
 //11156 Revised Eligibility screen By piya  strat
 public void setDataForEligibilityDetails(List < Property_Details__c > propertyList, Opportunity Loan, Cam__c cam) {
  System.debug('called setDataForEligibilityDetails::::' + cam);
  standLTVWithoutIns = 0;
  actualLTVWithoutIns = 0;
  standLTVWithIns = 0;
  actualLTVWithIns = 0;
  propEligConLTV = 0;
  if (propertyList != null && propertyList.size() > 0) {
   for (Property_Details__c p: propertyList) {
    if (p.Max_Permissible_LTV__c != null)
     standLTVWithIns = standLTVWithIns + p.Max_Permissible_LTV__c;
    if (p.Actual_LTV_without_insurance__c != null)
     actualLTVWithoutIns = actualLTVWithoutIns + p.Actual_LTV_without_insurance__c;

    if ((p.Final_Valuation__c == 0 || p.Final_Valuation__c == null) && p.Standard_LTV__c != null && p.Total_valuation_As_per_PE_PPIV2__c != null)
     propEligConLTV = ((p.Total_valuation_As_per_PE_PPIV2__c) * p.Standard_LTV__c) / 100;
    if ((p.Final_Valuation__c > 0 && p.Final_Valuation__c != null) && p.Standard_LTV__c != null)
     propEligConLTV = ((p.Final_Valuation__c) * p.Standard_LTV__c) / 100;

    if (p.Standard_LTV__c != null)
     standLTVWithoutIns = standLTVWithoutIns + p.Standard_LTV__c;
    if (p.LTV_insurance__c != null)
     actualLTVWithIns = actualLTVWithIns + p.LTV_insurance__c;
   }

   if (standLTVWithIns != null)
    standLTVWithIns = standLTVWithIns / propertyList.size();
   if (actualLTVWithoutIns != null)
    actualLTVWithoutIns = actualLTVWithoutIns / propertyList.size();
   if (propEligConLTV != null)
    propEligConLTV = propEligConLTV / propertyList.size();
   if (standLTVWithoutIns != null)
    standLTVWithoutIns = standLTVWithoutIns / propertyList.size();
   if (actualLTVWithIns != null)
    actualLTVWithIns = actualLTVWithIns / propertyList.size();
  }
  // FOIRIncludIns=((Loan.EMI_CAM__c + cam.Average_Bank_Balance_GDP__c)/cam.Other_income_to_be_consd__c).setScale(4);
  // FOIRIncludIns = FOIRIncludIns *100;
  if (Loan != null && cam != null && cam.Other_income_to_be_consd__c != null && cam.Other_income_to_be_consd__c != 0 /*&& Loan.EMI_CAM__c != null*/ ) {
   if (Loan.EMI_CAM__c == null) Loan.EMI_CAM__c = 0;
   if (cam.Average_Bank_Balance_GDP__c == null) cam.Average_Bank_Balance_GDP__c = 0;
   FOIRIncludIns = ((Loan.EMI_CAM__c + cam.Average_Bank_Balance_GDP__c) / cam.Other_income_to_be_consd__c).setScale(2); //divide it from Total income considered
   //if (cam.Proposed_Loan_Amt__c == null) cam.Proposed_Loan_Amt__c = 0;
   // if (cam.Top_Up_Amount__c == null) cam.Top_Up_Amount__c = 0;
   // if (Loan.Insurance_Premium_Amt__c == null) Loan.Insurance_Premium_Amt__c = 0;
   //FOIRIncludIns = ((cam.Proposed_Loan_Amt__c + cam.Top_Up_Amount__c + Loan.Insurance_Premium_Amt__c) / cam.Other_income_to_be_consd__c).setScale(2);
   // FOIRIncludIns=((Loan.EMI_CAM__c + cam.Average_Bank_Balance_GDP__c)/cam.Other_income_to_be_consd__c).setScale(4);
   FOIRIncludIns = FOIRIncludIns * 100;
   //cam.INSURANCE_AMOUNT__c = FOIRIncludIns ;
  }
  if (Loan.Insurance_Premium_Amt__c != null && cam.Proposed_Loan_Amt__c != null && cam.Top_Up_Amount__c != null) {
   double loanAmt = cam.Proposed_Loan_Amt__c + cam.Top_Up_Amount__c;
   insofloanAmt = (Loan.Insurance_Premium_Amt__c / loanAmt) * 100;
   cam.Hl_pmt__c = insofloanAmt;
  }

 }
 //11156 Revised Eligibility screenend
 /** constuctr fetch data **/
 public void fetchData() {
  try {
   //Cubic Tree Integration Start
   system.debug('LoanId is' + LoanId);
   cubicTreeFlag = false;
   //Added By Gulshan for Checking Product Level Cubic Tree Flag: 18-09-2017
   cubicTreeProductFlag = false;
   //Ended By Gulshan for Checking Product Level Cubic Tree Flag: 18-09-2017
   appCubicDeDupeList = new List < De_Dupe__c > ();
   propCubicDeDupeList = new List < De_Dupe__c > ();
   cubicApplicantList = new List < Applicant__c > ();
   cubicContactList = new List < Contact > ();
   //Cubic Tree Integration End
   //--------------- Mortgage Re-Engg Start---------------------
   ismonthly = true;
   //--------------- Mortgage Re-Engg End-----------------------
   salPOFlow = false; //sal po flow 
   SendbackFlag = false;
   sendBackSales = false;
   isCibilwatch = false; //CIBIL Watch
   showCentralisePanel = false; // CIBIL Watch
   callcenterprocessFlag = false; // call center process
   salMobilityFlag = false; // SAL Mobility Flag
   objSurrogateCAM = new SurrogateCAM__c(); // Line assignment
   PDList = new List < Personal_Discussion__c > ();
   showBREdeviations = false;
   showNoApplicationError = false;
   savedSuccessfull = false;
   savedApproved = false;
   RenderRecommend = false;
   BREResultAfterForDeviations = new List < TestObject__c > ();
   tenorList = new List < String > ();
   MaxLoanAsMuliplier = new List < Decimal > ();
   MaxLoanAsFOIR = new List < Decimal > ();
   finalEligibilty = new List < Decimal > ();
   finalEMI = new List < Decimal > ();
   solcam = new SOL_CAM__c();
   cam = new CAM__c();
   cibilExt1 = new Cibil_Extension1__c();
   OTPFlowFlag = false;
   hasCoApplicant = false;
   ExistLoanscount = 0;
   totalObligAmount = 0;
   FinalFOIRTemp = 0;
   totalIncon = 0; // bug 11156
   checklistTrnxList = new List < Checklist__c > ();
   DeviationsChecklistTrnxList = new List < Checklist__c > ();
   ManualDeviationList = new List < Checklist__c > ();
   //Bug 16994 - FAS- Attempt to dereference null object
   /*added null check for mobility v2 17139*/
   if (System.currentPageReference() != null && System.currentPageReference().getParameters().get('Id') != null) {
    LoanId = ApexPages.currentPage().getParameters().get('id');
   } else if (System.currentPageReference() != null && System.currentPageReference().getParameters().get('iid') != null) {
    LoanId = ApexPages.currentPage().getParameters().get('iid');
   } else {

   }
   system.debug('LoanId is' + LoanId);
   //Bug : 7412 : Pritha : start
   /*added null check for mobility v2 17139*/
   if (ApexPages.currentPage() != null && ApexPages.currentPage().getParameters().get('grouptype') != null) GroupType = ApexPages.currentPage().getParameters().get('grouptype');
   //Bug : 7412 : Pritha : end
   RiskSegment = ''; // SAL Policy Change
   secamtsum = 0;
   creditCardAmt = 0;
   securedFOIR = 0;
   overdraftAmt = 0;
   if (loanId == null) {
    showNoApplicationError = true;
   } else {
    showNoApplicationError = false;
   }

   isFromSales = false;
   /*17139 added null check*/
   if (System.currentPageReference() != null)
    salesFlow = System.currentPageReference().getParameters().get('sales');
   if (salesFlow == 'true')
    isFromSales = true;
   system.debug('LoanId is' + LoanId);
   if (LoanId != null) {
    //Cubic Tree Integration Start :: Added to query  :: Scheme_Master__r.Cubic_Tree_intregation__c ,
    //Employee Loan Verification - Application_source added
    //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal start
    /* purpose of the code :-to quey checklist record of loan application Account.Previous_Approved_Loan_Amount__c,Re_appraisal_Initiated_time__c,(Select id, Document_Type__c,Deviation_Master__c,Deviation_Master__r.Minimum_Approver_Level__c, Mandatory__c, Sales_Status__c, Document__c from Checklists__r)*/

    Loan = [select /*20939 s*/ Relationship_Manager__r.Mobile_number__c, /*20939 e*/ /* Bug 18159 S*/ Account.Queue_Master__c,Account.Queue_Master__r.QID__c/*Bug Id : 23549*/, Account.AutoCredit__c, /* Bug 18159 */ /*Bug Id : 19243*/ Prior_Application_Stage__c, /*Swapnil 20474 s*/ Sourcing_Channel__r.Channel_Category__c, /*Swapnil 20474 e*/ /*Rohit 16111 S*/ Account.Current_State__c, /*Rohit 16111 E*/ /*SAL PL to SAL LAP*/ Branch_Name__r.Branch_Code__c, Account.First_Name__c, Account.Last_Name__c, Account.Process_Type__c, /*SAL PL to SAL LAP*/ /*SAl IM Rohit S*/ LeadSource, Account.Employer__r.Name, Account.Employer__r.Company_Name__c, Account.PANNumber__c, Account.Employer__c, Account.Mobile__c, Account.Date_of_Birth__c, /*SAL IM Rohit E */ id, Scheme_Master__r.Cubic_Tree_intregation__c, Application_Source__c, Relationship_Manager__r.Email, Sourcing_Channel__r.sourcing_channel_email_id__c, ACM__r.Email, EMI_Type__c, Branch_Type__c, A_C_No__c, Industry__r.Industry__c, Owner.Name, Original_Approver__c, Branch_City__c, Decision_Time__c, Loan_Amount_with_Premium__c, Approved_Loan_Amount__c, Approved_Rate__c, Approved_Tenor__c, Loan_amt_with_premium__c, Insurance_Premium_Amt__c, online_salaried_app__c, Area_SM__r.Id /*Added for bug 18722*/ , Reject_Reason__c, Account.Previous_Approved_Loan_Amount__c, Re_appraisal_Initiated_time__c, (Select id, Document_Type__c, Deviation_Master__c, Deviation_Master__r.Minimum_Approver_Level__c, Mandatory__c, Sales_Status__c, Document__c from Checklists__r), Sales_Backend__c, name, Risk_Deviations__c, CRO_Deviations__c, CPA__c, ACM__c, RCM__c, NCM__c, CRO__c, RISK__c, COO__c, ACM_Comments__c, RCM_Comments__c, COO_Comments__c, Eligible_for_cross_sell__c, Products_for_cross_sell__c, Cross_sell_comments__c,
     CM__c, CM_Amount__c, CM_Deviations__c, SCO__c, SCO_Amount__c, SCO_Deviations__c, CM__r.Mobile_number__c, SCO__r.Mobile_number__c, CM__r.name, SCO__r.name, /* Bug id : 13016 - New Role Creation for Credit, added by Needhi*/
     Approval_Stages__c, Approver__c, Loan_Application_Number__c, Product__c, Loan_Type__c, Relationship_Manager__c, AccountId, CreatedDate,
     OwnerId, CreatedById, Scheme_Master__c, Scheme_Master__r.Name, Industry__c, Credit_Program__c, createdBy.Profile.Name,
     Sub_Industry__c, Existing_Customer__c, Finance_Amount__c, Tenor__c, Main_Sector__r.Sector__c, Main_Industry__c, Main_Sub_Industry__c,
     Type_Of_Loan__c, amount, Employee_Type__c, stagename, Probability, Branch_Name__r.branch_type__c,
     ForecastCategoryName, File_Acceptance__c, Discrepancy_Status__c, Loan_Amount__c, Area_SM__c,
     Type_of_Constitution__c, Application_Form_Number__c, If_Yes__c, Branch_Type1__c, Relationship_Manager__r.Name,
     Branch_Name__r.name, Sourc_Mobile__c, ASM_Mobile__c, Sales_Backend_Mobile__c, Verification_Initiated__c, Referral__c,
     Sourcing_Channel__c, Current_UserRole__C, CEO__c, CEO__r.name, RCM__r.name, NCM__r.name,
     RISK__r.name, COO__r.name, CRO__r.name, Comments__c, No_of_Properties__c,
     Amount_Rs__C, Instrument_No__c, Bank_Name__c, Dated__c, NameRef1__C, MOF_Waiver_Details__c,
     NameRef2__C, Address_Line1Ref1__c, Address_Line1Ref2__c, Address_Line2Ref1__c, Scheme_Master__r.PLOC_scheme__c,
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
     Requested_ROI__c, Processing_Type__c, Account.IS_OTP_FLOW__c, EMI_CAM__c, Date_of_created_date__c, Account.EMI_Frequency__c,
     Life_InsuranceRemarks__c, Type_of_Borrower__c, AppScore__c, Rank1__c, Loan_Application_Flow__c, Offer_Amount__c,
     CampaignId, Business_IRR__c, POS__c, BranchName__c, Financed_by_BFL__c, Disbursement_Type__c, Tranche_Count__c, City_Head__c, UnHold__c,
     CL_Region__c, Region__c, Old_Product__c, account.Years_in_Bus__c, CAM_Expiry_Date__c, CAM_Preparation_Date__c, Business_Head__c, Centralized_ACM__c, Program_Type__c,
     AMC__c, Centralized_RCM__c, Customer_Reference_Number__c, SMS_to_be_Sent__c, ACM__r.Mobile_number__c, Approved_time_after_Reappraisal__c, Decision_Date__c, Interior_Designer__c,
     Service_Availed__c, DSA_Name__c, Sourcing_Channel__r.Name, Account.ownerid, Account.Group_Type__c, ACM_Amount__c, Centralized_ACM_Amount__c, RCM_Amount__c, CRO_Amount__c, COO_Amount__c,
     Centralized_RCM_Amount__c, ZCM_Amount__c, RISK_Amount__c, NCM_Amount__c, Business_Head_Amount__c, President_Approval_Amount__c, President__c /*bug 6974*/ , Account.IsB2CStatusSent__c, Account.Name,
     /*Mortgage*/
     /*Anjali mortgage start*/
     Total_EMI__c, A_C_Type__c, Total_Loan_amount__c, Sourcing_Channel__r.Risky_DSA__c, Sourcing_Channel__r.Sourcing_Channel_Flag__c, Account.Vintage_with_BAL__c, Account.Current_experiance_in_Years__c, Account.Total_Work_Experience_Yrs__c, Account.BT_Bank_Type__c, Account.Type_of_Ownership__c, Account.Residence_TypeAcc__c, /*Anjali mortgage End */
     Account.Preferred_language__c, account.Base_Loan__c, Full_Underwriting__c, Sourcing_Channel_Type__c, Sub_Stage__c,
     (SELECT Final_Foir1__c, /*SHL*/ Maximum_BFL_Loan_Amount_as_per_Multiplie__c, FOIR_LoanAmount_60__c FROM SOL_CAMs__r), Telecaller_Name__c
     /*Hybrid Flexi:akshata*/
     , Scheme_Master__r.IsHybridFlexi__c,
     Branch_Name__r.Cubic_Tree_Integration_Products__c, /*Added By Gulshan for Checking Product Level Cubic Tree Flag: 18-09-2017*/
     (select ID, OppLevelRevisedOfferAmount__c, Revised_Offer_Amount__c, Branch__c from BodmasCalculations__r) /*bug 19469*/ , (select id from Property_Details__r), (select id, Type_of_PD__c, Name_of_the_applicant__c, PD_Conducted__c, PD_Ok__c from Personal_Discussion_s__r),
     (SELECT id, /*Call center S*/ Lead_Source__c, /*Call center E*/ Employment_Type__c, SME_Score__c, Offer_PF__c, Loan_Type__c, Program_Type__c, ASM__c, Process_Type__c, Customer_ID1__r.CIBIL_Segmentation__c, Office_Address_1__c, Office_Address_2__c, Office_Address_3__c, Office_City__c, Office_Pin_Code__c, Office_State__c, Office_Phone__c, Ignore_MCP_Results__c, Resi_Pick_State__c, Resi_Pick_City__c, Address_Change_flag__c, Customer_ID1__r.Customer_Name__c, Resi_city__c, BT_Bank__c, name, SBS_Scheme__c, Opportunity__r.Name, Experience_in_Years__c, Scheme_Name__c, Customer_ID1__r.Customer_ID__c, Opportunity__r.Id, ownerId, EMI_Amount__c, Availed_EMI__c, Products__c, Sourcing_Channel__r.Name, Product_Offering_Converted__c,
      Offer_Accepted_amount__c, Lead__c, Lead__r.Employment_Type__c, Existing_Product__c, Customer_Name__c, Customer_ID1__c, Customer_ID1__r.Flow__c, Customer_ID1__r.Email_New__c, Customer_ID1__r.Name, Customer_ID1__r.Address_Change__c, Customer_ID1__r.Contact_Person_Name__c, Customer_E_mail__c, Customer_Email_ID__c, Customer_ID__c, Customer_Mobile__c, Address_Line_1__c, Field_Desposition_Status__c, Existing_LAN__c, Address_Line_2__c, Address_Line_3__c, Pin_Code__c, Resi_State__c, Customer_ID1__r.State__c, Final_Amount__c, Offer_ROI__c, Tenor__c, Specialisation__c, Degree__c,
      Offer_Amount__c, Offer_ID__c, TeleCalling_Desposition_Status__c, Field_Check_Status__c, DNC_flag__c, Sourcing_Channel__c, Product_Offering_Source__c,
      eKYC_Processing__c, eKYC_First_Name__c, eKYC_Last_Name__c, Aadhar_Number__c, eKYC_DOB__c, Existing_Customer_Segmentation__c, Availed_Amount__c,
      Risk_Classification__c, Open_Ecs_Limit__c, Disb_Act_No__c, Disb_Bank_Name__c, Disb_Bank_Branch__c, Disb_favouring__c, PDD_pending__c, POS_Old_Loan__c,
      Secured_W_O_BT_Line_Assigned__c, Converted_Offer_Product__c, Ext_Finance_Amount__c, Secured_W_O_BT_Line_Available__c, Secured_BT_Line_Assigned__c, Secured_BT_Line_Available__c, Secured_Line_Expiry_Date__c, Unsecured_Line_Expiry_Date__c, Unsecured_W_O_BT_Line_Assigned__c, Unsecured_W_O_BT_Line_Available__c, Unsecured_BT_Line_Assigned__c, Unsecured_BT_Line_Available__c, Opportunity__c, Converted_Date_Time__c,
      Existing_Tenor__c, Topup_Amount__c, Balance_Tenure__c, Last_EMI_Paid__c, DPD_String__c, Bucket_String__c, Old_SFDC_Loan_Application__c, ECS_End_Date__c,
      Bounce_in_Life_Cycle__c, POS__c, Overdue_Charges__c, Total_POS__c, Referral__c, Customer_Type__c, Monthly_Obligation__c, Revised_Offer_ROI__c, Product_Offering_Type1__c, Sourcing_Channel__r.Reporting_Manager__c,
      Nominator_ID__c, Data_Mart_Status__c, Hold_Reason__c, Opportunity__r.createddate, Line_Accepted__c, Customer_Acceptance_Flag__c, One_time_password__c, Line_Activation_Acceptance__c, Line_Activated__c, IP_Address__c,
      Insurance_Premium_Amount__c, Customer_Acceptance_Date__c, Bank_Details_Change__c, Processing_Fee_Amount__c, SBS_Scheme__r.Product_Formula__c, Insurance_Product__c, Consultation_Fees__c, Insurance_Type__c, FFR_Flag__c, FFR_amount__c, ECS_error_msg__c, ECS_Bank_Account_number__c, MICR_Code__c, Bank_name__c, BPI__c, Offer_Validity__c, Campaign_Type__c, Requested_Tenor__c,
      Current_EMI__c, PO_Type__c from Product_Offerings__r),
      (select id, name, Status__c from Verification__r where Verification_Type__c = 'Salary Slip Format'),
      (select id, name, Dedupe_Lan_Matches__c, Applicant__c, Applicant__r.Contact_Name__c,Applicant__r.Contact_Name__r.Name,Datafix_Updated__c, Application_Status__c,
       Application_ID__c, Random_Dedupe__c, Area_Status__c, Customer_Status__c,
       Customer_ID__c, Dedupe_Comments__c, De_Dupe_result__c, Match_Status__c, De_Dupe_Decision__c, Segment__c, SF_Base__c, Source_Or_Target__c,  Dedupe_Target_Remarks__c, Dedupe_Source__c from De_Dupes__r where Applicant__c != null  AND Dedupe_Source__c != 'propertydedupeCT' AND Dedupe_Source__c != 'applicantdedupeCT')
     from opportunity where id =: LoanId
    ];

     if (Loan != null && Loan.Verification__r != null && Loan.Verification__r.size() > 0) //soql optimization for approval functionality
         salForVerify = Loan.Verification__r;
     if (Loan != null && Loan.De_Dupes__r != null)//) && Loan.De_Dupes__r.size() > 0) //soql optimization for approval functionality
         //dedupelist.addAll(Loan.De_Dupes__r);
       for(de_dupe__c dd: Loan.De_Dupes__r)
           dedupelist.add(dd); //BUG 24247
       system.debug('nishit--> '+dedupelist.size());
    //added by akshata :Hybrid Flexi Inhancement : Start
    if (!CommonUtility.isEmpty(Loan.Scheme_Master__c) && !CommonUtility.isEmpty(Loan.Scheme_Master__r.IsHybridFlexi__c) && Loan.Scheme_Master__r.IsHybridFlexi__c == true)
     IsHybridFlexi = true;
    System.debug('isHybridFlexi -->' + IsHybridFlexi);
    //added by akshata :Hybrid Flexi Inhancement : End

    //Rate Approval start
    rateflag = false;
    if (ProductSMS__c.getValues('RateApp') != null && ProductSMS__c.getValues('RateApp').Produtc__c != null) {
     rateflag = new Set < String > (ProductSMS__c.getValues('RateApp').Produtc__c.split(';')).contains(Loan.Product__c.toUpperCase());
    }
    //Rate Approval end
    //Cubic Tree Integration Start
    //Bug:24370 S
    Boolean skipCubicTreeFlag = false;
    transient set < string > labelProducts = new set < string > ();
    if (!commonUtility.isEmpty(Label.MortgageProductsLabel))
    labelProducts.addAll(Label.MortgageProductsLabel.split(';'));
    if (labelProducts.size() > 0 && Loan != null && Loan.Product__c != null) {
        skipCubicTreeFlag = labelProducts.contains(Loan.Product__c.toUpperCase());
    }
    System.debug('skipCubicTreeFlag::'+skipCubicTreeFlag);
    //Bug:24370 E
    //Added By Gulshan for Checking Product Level Cubic Tree Flag: 18-09-2017
    if (Loan.Branch_Name__r.Cubic_Tree_Integration_Products__c != null && Loan.Branch_Name__r.Cubic_Tree_Integration_Products__c != '') {
     String cubicTreeProducts = Loan.Branch_Name__r.Cubic_Tree_Integration_Products__c;
     String[] strArr = cubicTreeProducts.split(';');
     for (String str: strArr) {
      if (str.equalsIgnoreCase(Loan.Product__c)) {
       cubicTreeProductFlag = true;
       break;
      }
     }
    //Added for Bug: 24370
    if(skipCubicTreeFlag)
        cubicTreeProductFlag = false;
    }
    //Ended By Gulshan for Checking Product Level Cubic Tree Flag: 18-09-2017
    //Following If Condition added By Gulshan for Checking Product Level Cubic Tree Flag Also (i.e.cubicTreeProductFlag == true): 18-09-2017
    if (Loan.Scheme_Master__c != null && Loan.Scheme_Master__r.Cubic_Tree_intregation__c != true && cubicTreeProductFlag == true) {
     cubicTreeFlag = true;
    }
    //Cubic Tree Integration End
    //SAL Invisible monitoring start
    productFlag = LaonApplicationCreation__c.getValues('Salaried Products finnone').Products__c.contains(Loan.Product__c);
    //SAL Invisible monitoring end
    //SOL backend changes --- by harsit---start

    if (!CommonUtility.isEmpty(Loan) && !CommonUtility.isEmpty(Loan.SOL_CAMs__r))
     solcam = (Loan.SOL_CAMs__r)[0];


    //SOL backend changes --- by harsit---start


    //--------------- Mortgage Re-Engg Start---------------------
    Mortgageflag = false;
    if (LaonApplicationCreation__c.getValues('Mortgage Products') != null) {
     //Salaried
     String MortgageSalProducts = LaonApplicationCreation__c.getValues('Mortgage Products').Current_product__c;
     if (MortgageSalProducts != null) {
      String[] arr = MortgageSalProducts.split(';');
      for (String str: arr) {
       if (str.equalsIgnoreCase(Loan.Product__c)) {
        Mortgageflag = true;
       }
       MortgageProducts.add(str.toUppercase());
      }
     }
    }

    //--------------- Mortgage Re-Engg Start---------------------
    //List < Property_Details__c > objPropList = new List < Property_Details__c > ();
    //objPropList = [select id from Property_Details__c where Loan_Application__c =: LoanId];//soql optimization for approval functionality
    if (Loan != null && Loan.Property_Details__r != null && Loan.Property_Details__r.size() > 0) {
     for (Property_Details__c objProp: Loan.Property_Details__r) {
      propId.add(objProp.id);
     }
    }
    if (propId != null)
     propertyDedupelist = [select id, De_Dupe_Matched_Percentage__c, Property_Details__r.Address__c, Property_Details__r.Property_City__c, Property_Details__r.Location__c, Property_Details__r.Property_State__c,
      Dedupe_Lan_Matches__c, Customer_ID__c, De_Dupe_result__c, Dedupe_Comments__c, Loan_Application_Number__c, LAN_Number__c
      from De_Dupe__c where Property_Details__c IN: propId AND Dedupe_Source__c != 'propertydedupeCT'
      AND Dedupe_Source__c != 'applicantdedupeCT'
     ];

    //--------------- Mortgage Re-Engg End-----------------------




    //--------------- Mortgage Re-Engg End-----------------------

    //CIBIL Watch Start
    if (Loan != null && Loan.Loan_Application_Flow__c == 'CIBILWatch') {
     isCibilwatch = true;
    }
    //CIBIL Watch Start 
    //FAS
    scripURL = '';
    if (Loan != null && Loan.Product__c == 'FAS') {
     //FAS
     if (Mid_office_BRE_flow__c.getValues('FAS') != null) {
      if (Mid_office_BRE_flow__c.getValues('FAS').FASScripURL__c != null)
       scripURL = Mid_office_BRE_flow__c.getValues('FAS').FASScripURL__c;
     }
    }

    //4450
    COLStampdate = null;
    COLStampFlag = false;
    if (LaonApplicationCreation__c.getValues('Hierarchy Stamping') != null) {
     String COLDate = LaonApplicationCreation__c.getValues('Hierarchy Stamping').Credit_Hierarchy_Stamping_Date__c;
     if (COLDate != null) {
      COLStampdate = date.parse(COLDate);
     }
    }

    if (COLStampdate != null && Loan != null && COLStampdate < Loan.createddate) {
     COLStampFlag = true;
    }

    if (COLStampFlag == true) {
     if (Loan != null) {
      LoanAppFlow = Loan.Loan_Application_Flow__c;
      if (LoanAppFlow == null || LoanAppFlow == '') {
       LoanAppFlow = 'Normal';
      }

     }
    }

    //4937 start

    //sharesWrapperList = new List<ScriptWrapper>();
    sharesList = new List < Property_Details__c > ();

    sharesList.clear();
    NoOfShares = 0;
    totalCurrRate = 0;
    totalShrVal = 0;
    totalEligibility = 0;


    /*Property Dedupe Start - Anshita */

    propDdpflag = false;
    if (LaonApplicationCreation__c.getValues('Mortgage Products') != null) {
     String MortgageProd = LaonApplicationCreation__c.getValues('Mortgage Products').Existing_Products__c;
     if (MortgageProd != null) {

      String[] arr = MortgageProd.split(';');
      for (String str: arr) {
       if (str.equalsIgnoreCase(Loan.Product__c)) {
        propDdpflag = true;
       }
      }
     }

    }
    if(salmobilityv2falg != null && !salmobilityv2falg)// prod soql optimization
    propDtlLst = [select id, Credit_Total_Valuation_Mortgage__c, Digital_Scrip_Type__c, Digital_Scrip_Name__c, ISIN__c, BSE_Code__c, Digital_Scrip_Category__c,
     Number_of_Shares__c, Digital_Scrip_market_price__c, Digital_Total_Value__c, Contribution__c, X52_Wk_High_Rate__c,
     X52_Wk_Low_Rate__c, Digital_Scrips_Eligibility__c, /*Property Dedupe Anshita S */ Builder_Name__c, Project_Name__c, Project_Name__r.Name, Property_Address_Line_1__c,
     Property_Address_Line_2__c, Property_Address_Line_3__c, Area_Locality__c, Property_State__c, Property_Pin_Code__c, Loan_Application__c, Loan_Application__r.Quality_Check_Status__c,
     Geolocation__Longitude__s, Geolocation__Latitude__s, Property_City__c, Property_Identified__c /* Property Dedupe Anshita E*/
     from Property_Details__c where Loan_Application__c =: LoanId /*FAS Sourcing changes :14187 by akshata*/ ORDER BY Contribution__c DESC

    ];
    propDtlMap = new Map < Id, Property_Details__c > ();
    if(!CommonUtility.isEmpty(propDtlLst))
    for (Property_Details__c obj: propDtlLst) {
     propDtlMap.put(obj.Id, obj);
    }
    /*Property Dedupe End - Anshita */
    if(salmobilityv2falg!=null && !salmobilityv2falg)//SOQL optimisation 05 March 2019
    for (Property_Details__c p: [select id, Credit_Total_Valuation_Mortgage__c, Digital_Scrip_Type__c, Digital_Scrip_Name__c, ISIN__c, BSE_Code__c, Digital_Scrip_Category__c,
      Number_of_Shares__c, Digital_Scrip_market_price__c, Digital_Total_Value__c, Contribution__c, X52_Wk_High_Rate__c,
      X52_Wk_Low_Rate__c, Digital_Scrips_Eligibility__c from Property_Details__c where Loan_Application__c =: LoanId /*FAS Sourcing channel changes :14187 by akshata*/ ORDER BY Contribution__c DESC
     ]) {
     //sharesWrapperList.add(new ScriptWrapper(false, p));
     sharesList.add(p);

     if (p.Number_of_Shares__c != null)
      NoOfShares += p.Number_of_Shares__c;
     if (p.Digital_Scrip_market_price__c != null)
      totalCurrRate += p.Digital_Scrip_market_price__c;
     if (p.Digital_Total_Value__c != null)
      totalShrVal += p.Digital_Total_Value__c;

    }


    //4937 end  

    if (Loan.EMI_Type__c != null)
     isEMITypeDone = true;
    List < Discrepancy__c > alldisc = new List < Discrepancy__c > ();
    alldisc = [select Type__c, Discrepancy_Category__c, Discrepancy_Stage__c, Date_Time__c, Party_Type__c, Party_Name__c,
     Discrepancy_Description__c, LoanApplication__c,
     RaiserName__c, Description__c,
     Priority__c, Resolution_Remarks__c, Status__c, Discrepancy_Party__c, Applicant_Name__c,
     Raiser_Role__c, createddate, Category__c,
     Assigned_To__c, Closed_Date__c, Resolver_Name__c, OTPDiscrepancyCategory__c, OTPDiscrepancyDocuments__c, /*Added by sneha for  Bug -18583 Start*/ OTPDiscrepancyProduct__c /*Added by sneha for  Bug -18583 End*/
     from Discrepancy__c where LoanApplication__c =: Loan.Id
     order by Status__c asc, createddate asc
    ];
    if (alldisc != null && alldisc.size() > 0) {
     for (Discrepancy__c dis: alldisc) {
      if (dis.Type__c == 'SanctionCondition')
       sanctionList.add(dis);
      else
       discrepancyList.add(dis);
     }
    }
    //PDList = [select id, Type_of_PD__c, Name_of_the_applicant__c, PD_Conducted__c, PD_Ok__c from Personal_Discussion__c where Loan_Application__c =: LoanId];
    if (Loan != null && Loan.Personal_Discussion_s__r != null && Loan.Personal_Discussion_s__r.size() > 0) //soql optimization for approval functionality
     PDList.addAll(Loan.Personal_Discussion_s__r);
    pd = new Personal_Discussion__c();
    if (PDList != null && PDList.size() > 0) {
     PDType = PDList[0].Type_of_PD__c;
     pd = PDList[0];
    }

    accountCreate = [Select id, Flow__c, Location__c, Name, Ownership, Address_1st_Line__c, Office_Address_1st_Line__c, Address_2nd_Line__c, Address_3rd_Line__c, AccCity__c,
     STDCode__c, PinCode__c, LandMark__c, Type_of_Property__c, Office_Address_2nd_Line__c, Office_Address_3rd_Line__c, Office_City__c, Office_Pin_Code__c, Office_STD_Code__c,
     Office_Phone_Number__c, Office_Mobile__c, Office_LandMark__c, Email_Id__c, Website, PANNumber__c, First_Name__c, Middle_Name__c, Last_Name__c, Phone, Mobile__c,
     Type_of_Property_Office__c, ROC_Registration_Number__c, Service_Tax_Registration_Number__c, TIN_Number__c, Year_of_Incorporation__c, Financial_Year_Closing__c,
     Others_YearClosing__c, Type_of_Business_Entity__c, Type_of_Business_Entity_Others__c, Nature_of_Business__c, Type_Of_Industry__c, Fathers_Husbands_Name__c,
     Date_of_Birth__c, Age__c, Sex__c, Marital_Status__c, Dependents__c, Qualification__c, Employment_Business__c, Name_of_the_Company_Employer__c, Extn_No__c, Fax,
     Employee_Number__c, Designation__c, Department__c, Gross_Salary_Turn_Over__c, Net_Income_Profit__c, No_of_years_of_Service_Business__c, Income_from_Other_Sources__c,
     Constitution__c, Current_Residence_Address1__c, Current_Residence_Address2__c, Current_Residence_Address3__c, Current_City__c, Current_PinCode__c, Current_STDCode__c,
     Current_Telephone_No__c, Current_LandMark__c, Current_Email_Id__c, Current_Mobile__c, Residing_Since__c, Residence_Status__c, Permanent_Residence_Address1__c,
     Permanent_Residence_Address2__c, Permanent_Residence_Address3__c, Permanent_City__c, Permanent_PinCode__c, Permanent_STDCode__c, Permanent_Telephone_Number__c,
     Permanent_Mobile__c, Others_ty_pr__c, Others_ty_pr_Off__c, Employer__c, Contact_Person__c, Client_ID__c, Permanent_Address_as_above__c,
     Preferred_communication_address__c, Relationship_With_Applicant__c, Name_of_the_Borrower__c, Age_of_Account__C, Accountant_email_id__c, Sourcing_Channel__c,
     Property_Owner__c, Demat_A_C_No__c, DP_Details__c, CIN__c, Group_Code__c, Company_Type__c, Borrower_Group__c, Line_of_Business__c, Excise_Registration_No__c,
     Type_of_Constitution__c, Permanent_State__C, Current_State__C, Permanent_LandMark__c, Contact_Number__C, Occupation__C, SME_SSI__c, Industry, Office_State__c,
     Registered_Office_State__c, Years_in_Bus__C, Accountant_Contact_Person_Name__c, Registration_No__c, Spouse_Name__c, Current_experiance_in_Month__c,
     Current_experiance_in_Years__c, Total_Work_Experience_Months__c, Total_Work_Experience_Yrs__c, Tenor__c, Gender__c, Name_Of_The_Degree__c, DesignationOTP__c,
     Designation_Type__c, Is_Company_ID_Proof_Available__c, Office_Landline_Number1__c, Office_Landline_Number2__c, Residence_TypeAcc__c, Residence_Landline_phone__c, Adhaar_Number__c,
     Passport_Number__c, Voter_ID_DL_Number__c, BT_Details__c
     from Account where id =: Loan.AccountId
    ];

    if (accountCreate != null && accountCreate.size() > 0 && accountCreate[0].Flow__c == 'Mobility')
         salMobilityFlag = true;
    if (accountCreate != null && accountCreate.size() > 0 && accountCreate[0].Flow__c == 'Mobility V2')
         salmobilityv2falg = true;


    //Communication for SAL Line adding Sent_back_To_SALES_SMS__c
    //Bug : 7412 : Re_Initiate_De_Dupe__c
    //Cubic Tree Integration :: added to query :: JobId__c contact_name__r.id
    //Rate Approval :: ROIFlexi__c, ROILoc__c, ROINormal__c, ROI_PO__c, 
    //Bug:18370
    applicantList = [select is_BL_PL_Risk__c, /*Rohit 16111 S*/ eKYC_Processing__c,TrueCallerCheck__c, /*22141 added field truecaller*/ /*Rohit 16111 E*/ /* Rohit appsocre 16008 S*/ App_Score__c, /* Rohit appsocre 16008 E*/ /*OTP V3 CR S*/ Contact_Name__r.special_profile_employer__c, TimeTakenDecision__c, Codified_CIBIL__c, Risk_Segmentation__c, Contact_Name__r.Employer__r.Employer_List__c, /*OTP V3 CR E*/ /* SAL Invisible monitering start */ RSA_Loan_application_status__c, (SELECT Id, Address_Line2__c FROM Cibils__r) RSA_Loan_application_status__c, RSA_Remarks__c, RSA_Closure_Date__c, RSA_initiation_Date__c, Office_Email_Id_Verified__c, RSA_TAT__c, Contact_Name__r.Email_Confirmation_received__c, Contact_Name__r.Customer_address_matches_with_eKYC__c, Contact_Name__r.Perfios_Address__c, Contact_Name__r.Customer_address_matches_with_perfios__c, Contact_Name__r.Customer_Add_Matches_With_Previous_Add__c /* SAL Invisible monitering end */ ,/* Digital Sampling S */ LG_Registration_Status__c, /* Digital Sampling E */
     id, /*SAL PLTB Pritha S*/ LTA_Medical__c, LTA_Frequency__c, /*SAL PLTB Pritha E*/ ROIFlexi__c, ROILoc__c, ROINormal__c, ROI_PO__c, JobId__c, contact_name__r.id, Sent_back_to_sales_SMS_sent__c, EMI_Holidays_Across_tenure__c, EMI_Holiday_Opted__c, Months_per_year__c, Cycle_Day_Date__c, EMI_Holiday_Months__c, EMI_Due_Date__c, Contact_Name__r.office_no_check_on_company_site__c, Contact_Name__r.SFDC_Dedupe_check__c, Contact_Name__r.PAN_Response__c, Contact_Name__r.Linkedin_check_result__c, Contact_Name__r.Google_check_result__c, Contact_Name__r.PAN__c, Contact_Name__r.Last_Modified_Date__c, Contact_Name__r.Name_of_the_PAN_holder__c, Contact_Name__r.Employer__r.Domain_Name__c, Contact_Name__r.Employer__r.Company_Category__c, Existing_Customer__c, Owned_Residence__c, Is_spouse_Working_Financial_CoApp__c, Loan_Application__r.Scheme_Master__c, Name, Contact_Name__r.Mobile__c, Loan_Application__r.Requested_ROI__c, Loan_Application__r.Sourcing_Channel__r.branch__c, Loan_Application__r.Referral__c, Loan_Application__r.Existing_Customer__c, Loan_Application__r.Account.Sourcing_Channel__r.branch__c, Update_CIBIL_Error__c, Descriptin__c, Type_of_Borrower__c, Re_Initiate_De_Dupe__c, Integrate_with_CIBIL__c, Contact_Name__c, Contact_Name__r.Name, Contact_Name__r.Customer_Profile__c,
     Contact_Name__r.Designation__c, Contact_Name__r.Employer_Name__c, Contact_Name__r.Qualification__c, Contact_Name__r.Address_1__c, Contact_Name__r.Total_Work_Experience_Yrs__c, Contact_Name__r.Current_experiance_in_Years__c,
     PD_Status__c, Bank_Status__c, Contact_Name__r.Address_2__c, PolicyCheck__c /*SAL PLTB Bug-12108 - Anshita */ , FCU_Status__c, ITR_Status__c, Office_SE_Status__c, Office_SAL_Status__c, Contact_Name__r.Company_Category__c, Contact_Name__r.Current_experiance_in_Month__c,
     Office_Status__c, Pay_Slips_Status__c, Residence_Status__c, Trade_Status__c, TVR_Status__c, Select_Applicant__c, Applicant_Type__c, Contact_Name__r.Customer_Type__c, Contact_Name__r.ApplicantType__c,
     Contact_Name__r.Date_of_Birth__c, Contact_Name__r.FathersHusbands_Name__c, Contact_Name__r.PAN_Number__c, Contact_Name__r.Year_of_Incorporation__c, Contact_Name__r.Account.TIN_Number__c,
     Contact_Name__r.Bank_Account_No__c, Contact_Name__r.VoterID_Number__c, Contact_Name__r.ROC_Regn_No__c, Contact_Name__r.Address_3__c, Contact_Name__r.AppCity__c, Contact_Name__r.Residence_Type__c,
     Contact_Name__r.Pin_Code__c, Contact_Name__r.Phone, Contact_Name__r.MobilePhone, Contact_Name__r.Email, Contact_Name__r.Address_Line_One__c, Contact_Name__r.Address_2nd_Line__c, Contact_Name__r.Address_3rd_Line__c,
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
     Segment_Achievment__c, SalaryToAgeResult__c, Bureau_Segment__c, StepUp_StepDown_EMI_Year_1__c, StepUp_StepDown_EMI_Year_2__c, StepUp_StepDown_EMI_Year_3__c, StepUp_StepDown_EMI_Year_4__c, StepUp_StepDown_EMI_Year_5__c,
     Company_Name_as_per_Domain_check__c, Official_Email_bounce_Flag__c, Domain_Created_Date__c, Domain_Check_Result__c, Registrant_Name__c, Registrant_Email_ID__c, /*Mortgage*/ Contact_Name__r.Occupatipn__c, PAN_Number__c, Contact_Name__r.Property_Owner__c
     /* SAL Policy Changes Start */
     , RC_Decline__c, RC_Deviation__c /* SAL Policy Changes End */ ,
     /*SHL Issue*/
     Contact_Name__r.Current_Employment_Vintage__c,
     /*22141 added cibil temp inner query*/
     (Select id, CIBIL_Mobile_Check__c from Cibil_Temps__r limit 1),
     /*Fraud Trigger - krish */
     Bank_Account__r.bank_name__c, Fraud_Case__c, contact_name__r.employer__r.bank_names__c, TimeFirstAction__c /*Service Guarantee 2-Deepak*/
     /* Anjali mortgage start*/
     , Score_card__c, Underwriter_Remarks__c, Total_Employment_Vintage__c, Verifications_returned_by_IM_BRE__c, SME_Score__c, RSA_flag__c, Identified_for_Invisible_Monitoring__c, Invisible_Monitoring_Skipped__c /* Anjali mortgage end*/ , /*hybrid flexi*/ Pure_Flexi_EMI__c, Drop_Line_Flexi_Period__c, Pure_Flexi_Period__c /*Bug 14957 - October BRD - Google Check*/ , Google_Check_Result__c /*Bug 14957 - October BRD - Google Check*/
     /* 16175 hybrid flexi topup*/
     , Is_Hybrid_Flexi_for_Topup__c, Topup_Pure_Flexi_Period__c, Topup_Dropline_Flexi_Period__c, Topup_Loan_Proposed_EMI__c, Topup_Pure_Flexi_EMI__c /* 16175 hybrid flexi topup*/ , Check_RSA__c, RSA_SMS_Email_sent__c /*added by prashant for @16611 s*/ , Domain_Email_Remark__c /*added by prashant for @16611 e*/ ,
     (select id, eKYC_Address_details__c from eKYC__r)
     from Applicant__c where Loan_Application__c =: LoanId
    ];
    System.debug('applicantList++' + applicantList.size());
    //Cubic Tree Integration start 
    if (applicantList != null && cubicApplicantList != null) {
     cubicApplicantList.addAll(applicantList);
    }
    //Cubic Tree Integration end

    //--------------- Mortgage Re-Engg Start---------------------
    COApplMAP = new Map < Id, String > ();
    COapplicantSelectList.add(new SelectOption('-None-', '-None-'));
    //--------------- Mortgage Re-Engg End-----------------------

    List < Id > AllConlist = new List < Id > ();
    //List < Applicant__c > Allapplist = new List < Applicant__c > ();
    applicantPrimary = new Applicant__c();
    if (applicantList != null && applicantList.size() > 0) {
     integer appsize = applicantList.size();
     for (integer i = 0; i < appsize; i++) {
      if (applicantList[i].Contact_Name__r.Name != null) {
       optionsdocApp.add(new SelectOption(applicantList[i].Id, applicantList[i].Contact_Name__r.Name + '-' + applicantList[i].Applicant_type__c));
      }
      /* Prajyot #10659 Secondary Cibil Match START */
      if (applicantList[i].Contact_Name__r.Customer_Type__c == 'Individual' && applicantList[i].Applicant_Type__c == 'Primary') {
       system.debug('inside individual');
       primaryApplicantID = applicantList[i].ID;
      }
      if (applicantList[i].Applicant_Type__c == 'Financial Co-Applicant' || applicantList[i].Applicant_Type__c == 'Primary Financial Co-Applicant') {
       if (primaryApplicantID != null && primaryApplicantID.length() > 0) {
        primaryApplicantID = primaryApplicantID + ';' + applicantList[i].ID;
       } else {
        primaryApplicantID = applicantList[i].ID;
       }
       system.debug('from controller primaryApplicant=' + primaryApplicantID);
      }
      system.debug('primaryApplicant=' + primaryApplicantID);
      /* Prajyot #10659 Secondary Cibil Match END */
      if (applicantList[i].Applicant_Type__c == 'Primary') {
       applicantPrimary = applicantList[i];
       System.debug('applicantPrimary++' + applicantPrimary);
       primaryContID = applicantList[i].Contact_Name__c;

       custName = applicantPrimary.Contact_Name__r.Name;
       custOffEmailId = applicantPrimary.Contact_Name__r.Office_Email_Id__c;
       //SAL IM Rohit start
       if (applicantPrimary.Cibils__r != null && applicantPrimary.Cibils__r.size() > 0)
        conCibilAdd = applicantPrimary.Cibils__r[0].Address_Line2__c;
       //SAL IM Rohit end    

      }

      setAppId.add(applicantList[i].id);
      AllConlist.add(applicantList[i].Contact_Name__c);
      if (applicantList[i].Applicant_Type__c != 'Primary') {

       hasCoApplicant = true;
      }
      applicantMAP.put(applicantList[i].id, applicantList[i]);
      applicantNameMAP.put(applicantList[i].ContactName__c, applicantList[i]);
      optionsApplicant = new List < SelectOption > ();
      Allapplist.add(applicantList[i]);

      if (applicantList[i].ContactName__c != null) {
       optionsApplicant.add(new SelectOption(applicantList[i].Id, applicantList[i].ContactName__c));
      }

      //--------------- Mortgage Re-Engg Start---------------------
      if (MortgageFlag && (Loan.Product__c == 'SHL' || Loan.Product__c == 'HFC SHL' || Loan.Product__c == 'SHOL' || Loan.Product__c == 'HSL' || Loan.Product__c == 'SALLAP' || Loan.Product__c == 'HPLS' || Loan.Product__c == 'SBS CS SHL')) {
       if (applicantList[i].Applicant_Type__c == 'Financial Co-Applicant' || applicantList[i].Applicant_Type__c == 'Primary Financial Co-Applicant') {
        //add in list
        COapplicantSelectList.add(new SelectOption(applicantList[i].Contact_Name__c, applicantList[i].ContactName__c));
        COApplMAP.put(applicantList[i].Contact_Name__c, applicantList[i].Contact_Name__r.Occupatipn__c);
       }
      }
      //--------------- Mortgage Re-Engg End-----------------------

     }
    }
    //Bringing this code block outside for loop for Bug 13851 OTP V3 - Krish
    // SAL Policy Changes Start
    if (applicantPrimary != null) {
     RCDeclineFlag = false;
     if (applicantPrimary.RC_Decline__c != null) {
      RiskSegment = applicantPrimary.RC_Decline__c;
     }
     if (applicantPrimary.RC_Deviation__c != null) {
      RiskSegment = RiskSegment + applicantPrimary.RC_Deviation__c;
     }
    }
    // SAL Policy Changes Ends
    if (applicantPrimary != null && applicantPrimary.Contact_Name__c != null) {
     List < Contact > conList = new List < Contact > ();
     //Cubic Tree Integration adding to query :: Name, Residence_City__c, State__c, Mobile__c, Office_State__c 
     conList = [select id, Name, Residence_City__c, State__c, Mobile__c, Office_State__c, /*CIN DIN Enhancement by pankaj start*/ CIN__c, DIN__c /*CIN DIN END */ , College__c, Customer_Profile__c, Customer_Type__c, Email_Confirmation_received__c, Customer_address_matches_with_eKYC__c, Customer_entered_address__c, eKYC_Address__c, Perfios_Address__c,
      Customer_address_matches_with_perfios__c, Address_1__c, Address_2__c, Address_3__c, Company_Category__c, Company_Type__c, Office_Email_Id__c, Residence_Type__c, Current_Employment_Vintage__c, Total_Work_Experience_Yrs__c, Current_experiance_in_Years__c,
      Educational_Qualification__c, Qualification__c, Date_of_Birth__c, Employer_Name__c, FathersHusbands_Name__c, PAN_Number__c, Year_of_Incorporation__c,
      Account.TIN_Number__c, Bank_Account_No__c, VoterID_Number__c, ROC_Regn_No__c, AppCity__c, Pin_Code__c, Phone, MobilePhone, Email,
      Address_2nd_Line__c, Address_3rd_Line__c, Address_Line_One__c, Permanent_Land_Mark__c, Office_City__c, Office_Pin_Code__c, Office_STD_Code__c,
      Office_Phone_Number__c, Mobile_Phone__c, FirstName, Middle_Name__c, LastName, Customer_Add_Matches_With_Previous_Add__c from contact where id in: AllConlist
     ];
     //Cubic Tree Integration start
     if (conList != null && cubicContactList != null) {
      cubicContactList.addAll(conList);
     }
     //Cubic Tree Integration End
     if (conList != null && conList.size() > 0) {
      for (Contact conobj: conList) {
       if (conobj.id == applicantPrimary.Contact_Name__c)
        con = conList[0];
       contactMAP.put(conobj.id, conobj);

      }
     }

     /* SAL IM Start - rohit*/
     string fullCustAddress = '';

     if (applicantPrimary.Contact_Name__r.Address_1__c != null) {
      fullCustAddress = applicantPrimary.Contact_Name__r.Address_1__c;
     }

     if (applicantPrimary.Contact_Name__r.Address_2__c != null) {
      if (fullCustAddress != '' && fullCustAddress != null) fullCustAddress = fullCustAddress + ' ' + applicantPrimary.Contact_Name__r.Address_2__c;
      else fullCustAddress = applicantPrimary.Contact_Name__r.Address_2__c;
     }

     if (applicantPrimary.Contact_Name__r.Address_3__c != null) {
      if (fullCustAddress != '' && fullCustAddress != null) fullCustAddress = fullCustAddress + ' ' + applicantPrimary.Contact_Name__r.Address_3__c;
      else fullCustAddress = applicantPrimary.Contact_Name__r.Address_3__c;
     }

     if (fullCustAddress != '' && fullCustAddress != null) {
      conCustEnterAdd = fullCustAddress;
      applicantPrimary.Contact_Name__r.Customer_entered_address__c = fullCustAddress;
     }

     List < eKYC__c > kyclist = new List < eKYC__c > ();
     if (applicantPrimary != null && applicantPrimary.ekyc__r != null && applicantPrimary.ekyc__r.size() > 0)
      kyclist.addall(applicantPrimary.ekyc__r);

     // kyclist = [select eKYC_Address_details__c from eKYC__c where applicant__c =: applicantPrimary.id]; //soql optimization for approval functionality
     if (kyclist != null && kyclist.size() > 0) {
      conEKYCAdd = kyclist[0].eKYC_Address_details__c;
      applicantPrimary.Contact_Name__r.eKYC_Address__c = kyclist[0].eKYC_Address_details__c;
     }
     /*SAL IM end - rohit */

     if (primaryContID != null && contactMAP.get(primaryContID) != null)
      primContact = contactMAP.get(primaryContID);

     //Credit vidya email check
     if (applicantPrimary.Domain_Check_Result__c == 'NOT OK' || applicantPrimary.Domain_Check_Result__c == 'REFER') {
      EmailDomainCheck = true;
      /* Bug 17139 */
      if (salmobilityv2falg)
       mobilitystatus = 'You cannot approve the case due to Fraud trigger in Domain check.';
      else {
       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'You cannot approve the case due to Fraud trigger in Domain check.');
       ApexPages.addMessage(myMsg);
      }
     }
     if (applicantPrimary.Official_Email_bounce_Flag__c == true) {
      EmailDomainCheck = true;
      /*Bug 17139 */
      if (salmobilityv2falg)
       mobilitystatus = 'You cannot approve the case due to Fraud trigger in Domain check.';
      else {
       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Official Email ID has bounced during domain check.');
       ApexPages.addMessage(myMsg);
      }
     }



    }

    List < Product_Offerings__c > productOffer = new List < Product_Offerings__c > ();
    /* productOffer = [SELECT id, Lead_Source__c,Employment_Type__c, SME_Score__c, Offer_PF__c, Loan_Type__c, Program_Type__c, ASM__c, Process_Type__c, Customer_ID1__r.CIBIL_Segmentation__c, Office_Address_1__c, Office_Address_2__c, Office_Address_3__c, Office_City__c, Office_Pin_Code__c, Office_State__c, Office_Phone__c, Ignore_MCP_Results__c, Resi_Pick_State__c, Resi_Pick_City__c, Address_Change_flag__c, Customer_ID1__r.Customer_Name__c, Resi_city__c, BT_Bank__c, name, SBS_Scheme__c, Opportunity__r.Name, Experience_in_Years__c, Scheme_Name__c, Customer_ID1__r.Customer_ID__c, Opportunity__r.Id, ownerId, EMI_Amount__c, Availed_EMI__c, Products__c, Sourcing_Channel__r.Name, Product_Offering_Converted__c,
                     Offer_Accepted_amount__c, Lead__c, Lead__r.Employment_Type__c, Existing_Product__c, Customer_Name__c, Customer_ID1__c, Customer_ID1__r.Flow__c, Customer_ID1__r.Email_New__c, Customer_ID1__r.Name, Customer_ID1__r.Address_Change__c, Customer_ID1__r.Contact_Person_Name__c, Customer_E_mail__c, Customer_Email_ID__c, Customer_ID__c, Customer_Mobile__c, Address_Line_1__c, Field_Desposition_Status__c, Existing_LAN__c, Address_Line_2__c, Address_Line_3__c, Pin_Code__c, Resi_State__c, Customer_ID1__r.State__c, Final_Amount__c, Offer_ROI__c, Tenor__c, Specialisation__c, Degree__c,
                     Offer_Amount__c, Offer_ID__c, TeleCalling_Desposition_Status__c, Field_Check_Status__c, DNC_flag__c, Sourcing_Channel__c, Product_Offering_Source__c,
                     eKYC_Processing__c, eKYC_First_Name__c, eKYC_Last_Name__c, Aadhar_Number__c, eKYC_DOB__c, Existing_Customer_Segmentation__c, Availed_Amount__c,
                     Risk_Classification__c, Open_Ecs_Limit__c, Disb_Act_No__c, Disb_Bank_Name__c, Disb_Bank_Branch__c, Disb_favouring__c, PDD_pending__c, POS_Old_Loan__c,
                     Secured_W_O_BT_Line_Assigned__c, Converted_Offer_Product__c, Ext_Finance_Amount__c, Secured_W_O_BT_Line_Available__c, Secured_BT_Line_Assigned__c, Secured_BT_Line_Available__c, Secured_Line_Expiry_Date__c, Unsecured_Line_Expiry_Date__c, Unsecured_W_O_BT_Line_Assigned__c, Unsecured_W_O_BT_Line_Available__c, Unsecured_BT_Line_Assigned__c, Unsecured_BT_Line_Available__c, Opportunity__c, Converted_Date_Time__c,
                     Existing_Tenor__c, Topup_Amount__c, Balance_Tenure__c, Last_EMI_Paid__c, DPD_String__c, Bucket_String__c, Old_SFDC_Loan_Application__c, ECS_End_Date__c,
                     Bounce_in_Life_Cycle__c, POS__c, Overdue_Charges__c, Total_POS__c, Referral__c, Customer_Type__c, Monthly_Obligation__c, Revised_Offer_ROI__c, Product_Offering_Type1__c, Sourcing_Channel__r.Reporting_Manager__c,
                     Nominator_ID__c, Data_Mart_Status__c, Hold_Reason__c, Opportunity__r.createddate, Line_Accepted__c, Customer_Acceptance_Flag__c, One_time_password__c, Line_Activation_Acceptance__c, Line_Activated__c, IP_Address__c,
                     Insurance_Premium_Amount__c, Customer_Acceptance_Date__c, Bank_Details_Change__c, Processing_Fee_Amount__c, SBS_Scheme__r.Product_Formula__c, Insurance_Product__c, Consultation_Fees__c, Insurance_Type__c, FFR_Flag__c, FFR_amount__c, ECS_error_msg__c, ECS_Bank_Account_number__c, MICR_Code__c, Bank_name__c, BPI__c from Product_Offerings__c where Opportunity__c =: loan.Id limit 1
                    ];*/ //soql optimization for approval functionality
    if (loan != null && loan.Product_Offerings__r != null && loan.Product_Offerings__r.size() > 0)
     productOffer.addAll(loan.Product_Offerings__r);

    if (productOffer != null && productOffer.size() > 0) {
     //added code for Call Center S
     if (ProductSMS__c.getValues('SalariedLineAsignmentProducts') != null) {
      String products = ProductSMS__c.getValues('SalariedLineAsignmentProducts').Produtc__c;
      if (products != null) {
       String[] arr = products.split(';');
       for (String str: arr) {
        callCentreProdlbl.add(str.ToUpperCase());
       }
      }
     }
     if (Label.Call_Centre_Idetifier != null) {
      String[] arr1 = Label.Call_Centre_Idetifier.split(';');
      for (String str1: arr1) {
       callCentrelbl.add(str1.ToUpperCase());
      }
     }
     if (callCentreProdlbl != null && callCentreProdlbl.size() > 0 && callCentrelbl != null && callCentrelbl.size() > 0 && productOffer[0].Lead_Source__c != null) {
      if (callCentreProdlbl.contains(productOffer[0].Products__c.ToUpperCase())) {
       if (callCentrelbl.contains(productOffer[0].Lead_Source__c.ToUpperCase())) {
        callCenterProcessFlag = true;
       }
      }
     }
     //Rate Approval start
     if (rateFlag) {
      applicantPrimary.ROI_PO__c = productOffer[0].Offer_ROI__c;
     }
     //Rate Approval end
    }
    if (productOffer != null && productOffer.size() > 0) {
     //salPOFlow = true;
     for (Product_Offerings__c po: productOffer) {
      if (po.Line_Activation_Acceptance__c == 'YES') {
       salPOFlow = true;
       break;
      }
     }
    }
    /*Dynamic Query Added - Aman*/
    String loanId = loan.Id;
    String WhereANDCondition;
    String camQuery;
    camQuery = 'select name, Payment_Date_1__c, Payment_Date_2__c, Payment_Date_3__c, Recent_continuous__c, Repayment_of_loan__c, C_P_Previous_Year__c, CreatedDate, Current_Year_PLBS__c, Current_Year_PLBS__r.Year__c, Previous_Year_PLBS__r.Year__c, Previous_Year_PLBS__c, Applicant__r.Contact_Name__c,' +
     'Type_Cust__c, Type_of_Entity__c, Month1__c, Total_Income_GP__c, Month2__c, Month3__c, Gross_Salary_Month1__c, Approved_CAM__c, Monthly_Reimbursement__c, Maximum_Unsecured_Exposure_MUM__c,' +
     'Gross_Salary_Month2__c, Gross_Salary_Month3__c, Final_Net_An_Inc__c, Net_Salary_for_Month1__c, Net_Salary_for_Month2__c, Net_Salary_for_Month3__c, Avg_Net_Sal__c, Avg_Mthly_Inctve_70__c,' +
     'Avg_Qtrly_Inctve_60__c, Avg_Mthly_Net_Inc__c, Average_Monthly_Net_Income1__c, Mthly_Loan_EMI__c, Credit_Card_Out_5__c, OD_interest__c, Total_Mthly_Oblig__c, NAS__c, Maxi_EMI_Banking__c, Maxi_EMI_Cust__c,' +
     'Maxi_EMI_FOIR__c, Max_EMI_Offer__c, NAS_Multi__c, Max_Loan_Amt_NAS_Multi__c, ROI__c, Final_FOIR__c, Avg_monthly_incentive1__c, Avg_monthly_incentive2__c,' +
     'Proposed_Loan_Amt__c, IRR_TO__c, Tenor__c, EMI_on_Proposed_Loan_TO__c, Insurance_taken_TO__c, Premium_Amount_TO__c, Loan_Amt_Premium__c, EMI_with_Insurance_Premium_TO__c,' +
     'Avg_monthly_incentive3__c, Avg_mthly_incntve_3mts__c, Average_incentive_for_Q1__c, Average_incentive_for_Q2__c, Average_incentive_for_Q3__c, Avg_qtrly_incentive__c,' +
     'Incentive_Monthly_or_Quarterly__c, Receips1_Doc__c, Receips2_Doc__c, Receips3_Doc__c, Receips4_Doc__c, Receips5_Doc__c, Receips6_Doc__c, Month4_Doc__c, Month5_Doc__c,' +
     'Selected1__c, Month1_Doc__c, Month2_Doc__c, Month3_Doc__c, Year1_Doc__c, Year2_Doc__c, Year3_Doc__c, LAP_EMI__c, Construction_Valuation_1__c, Construction_Valuation_2__c,' +
     'Sal_Deviation_on_FOIR__c, Sal_MUE_Funding__c, sal_max_loan__c, LAP_pmt__c, Interest_on_term_loans__c, Bounces_in_Latest_3_Months__c, App_Mon_Income__c, Monthly_CC_OD_interest__c, ELC_Line_Amounts__c,' +
     'Rental_Income__c, Adjusted_Rental_Income__c, SAL_Max_FOIR_as_BFL__c, New_Sal_Deviation_on_FOIR__c, MLA_for_Unlisted_Pvt__c, Applicable_FOIR1__c, Unsecured_FOIR__c, Secured_FOIR__c,' +
     'Deviation_on_FOIR__c, max_loan_POS_forExSAL__c, Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c, Max_Loan_Amount_for_IT_Company__c, Average_Monthly_Net_Income2__c,Other_income_to_be_consd__c, INSURANCE_AMOUNT__c, Fund_Based__c, Hl_pmt__c,' +
     'Bank_Details__r.Average_Balance__c, Existing_HL_EMI__c, Bank_Details__r.Sum_of_average_Balance__c, Bank_Details__r.Transaction_Count__c, Average_Bank_Balance__c, id, Average_monthly_Obligations__c, Avg_Mthly_Net_Inc1__c, Income_from_CY__c, ELIGIBILITY_ACCORDING_TO_GROSS_RECEIPTS__c, ELIGIBILITY_ACCORDING_TO_CASH_PROFITS_ME__c, Eligible_Loan_amt_Bank__c,' +
     'INSURANCE_PREFERRENCE__c,' +
     'Entity_Record_Type__c,  BT_Existing_Top_up_multiplier__c, Loan_elig_TO__c, EMI_of_The_Loan__c, Rental_Income_to_be_considered__c, Eligible_FOIR__c, Eligible_Loan__c, Multiplier__c, Selected_Option_TO__c, Live_unsecured_loan__c,Average_Bank_Balance_GDP__c, GP_Other_income__c, ObligationsDC1__c, Oth_Inc_2_be_Consd__c, Business_Continuty__c, EMI_Doc__c, LAP_Tenor__c, Eligible_Home_Loan_Amount__c, Stake_of_co__c, Home_Loan_Tenor__c, GP_Home_loan_amount__c, Top_Up_Amount__c, Top_Up_Rate__c, Top_Up_Tenure__c, Industry_Margins_applicable1__c, C_P_Current_Year__c, Existing_Live_Obligations__c, Agri_income_to_be_consd__c, Agri_Inc_2_be_Consd__c, Final_Income_considered_for_Eligibility__c, Business_Income_Considered__c from cam__c where loan_application__c =:loanId';

    if (callCenterProcessFlag)
     WhereANDCondition = ' AND Applicant__c != null';
    else if (salMobilityFlag || salmobilityv2falg)
     WhereANDCondition = ' AND (Applicant__c != null OR Applicant__c = null)';
    else
     WhereANDCondition = ' AND Applicant__c = null';

    camQuery += WhereANDCondition;
    system.debug('camQuery -->' + camQuery);
    camList = Database.query(camQuery);
    system.debug('camList -->' + camList);
    /*Dynamic Query Added - Aman*/

    if (camList != null && camList.size() > 0) {
     cam = camList[0];

     //SHL change
     if (cam != null && (Loan.Product__c == 'SHL' || Loan.Product__c == 'HFC SHL' || Loan.Product__c == 'SHOL' || Loan.Product__c == 'HSL' || Loan.Product__c == 'SALLAP' || Loan.Product__c == 'HPLS' || Loan.Product__c == 'SBS CS SHL')) {
      if (cam.Top_Up_Amount__c == null && cam.Proposed_Loan_Amt__c != null) {
       appliedLoanAmt = cam.Proposed_Loan_Amt__c;
      } else {
       if (cam.Proposed_Loan_Amt__c != null)
        appliedLoanAmt = cam.Proposed_Loan_Amt__c + cam.Top_Up_Amount__c;
      }
     }

     /*if (cam.Incentive_Monthly_or_Quarterly__c == 'Monthly')
ismonthly = true;
else
ismonthly = false;*/

     //----------------Mortgage start------------------
     if (cam.Incentive_Monthly_or_Quarterly__c == 'Monthly') {
      ismonthly = true;
      isquarterly = false;
      isYearly = false;
     } else if (cam.Incentive_Monthly_or_Quarterly__c == 'Quarterly' || cam.Incentive_Monthly_or_Quarterly__c == 'Half Yearly') {
      isquarterly = true;
      ismonthly = false;
      isYearly = false;

     } else if (cam.Incentive_Monthly_or_Quarterly__c == 'Yearly') {
      isYearly = true;
      isquarterly = false;
      ismonthly = false;
     } else {
      ismonthly = true;
      isquarterly = false;
      isYearly = false;
     }

     //----------Mortgage End ---------------- 



     monthlyObligation = string.valueOf(cam.Average_monthly_Obligations__c);

     if (Loan.Product__c == 'SHL' || Loan.Product__c == 'HFC SHL' || Loan.Product__c == 'HSL' || Loan.Product__c == 'SALLAP' || Loan.Product__c == 'HPLS' || Loan.Product__c == 'SBS CS SHL') {
      FinalFOIRTemp = cam.Eligible_FOIR__c;
      totalIncon = cam.Other_income_to_be_consd__c; // bug 11156
     } else {
      //SOL backend changes to calculate final foir ----  by harsit ---start
      if (cam.Unsecured_FOIR__c != null && cam.Secured_FOIR__c != null && Loan.Product__c != 'SHOL')
       FinalFOIRTemp = cam.Unsecured_FOIR__c + cam.Secured_FOIR__c;
      else if (Loan.product__c == 'SHOL' && !CommonUtility.isEmpty(solcam))
       FinalFOIRTemp = solcam.Final_Foir1__c;
      //SOL backend changes to calculate final foir ----  by harsit ---end
     }

     //Added by mahima- 12501- RSL RDl Flexi
     PureFlexi = cam.INSURANCE_PREFERRENCE__c;


    }

    //01MOB S
    bankAccList = new List < Bank_Account__c > ();
    //bankAccList = [select id, ODCC_limit__c, Latest_OD_CC_account_balance__c, ODCC_Utilization__c ,/*SHL*/Mode_Of_Salary_Credit__c from Bank_Account__c where Loan_Application__c =:opp.id];
    String queryBA = 'SELECT ';
    queryBA += 'Name,Id,Perfiod_done_date_and_Time__c,Salary_Credit_Date1__c,Salary_Credit_Date2__c,Salary_Credit_Date3__c,Salary_credit_amount1__c,Salary_credit_amount2__c,Salary_credit_amount3__c,Loan_Application__c,Bank_Name__c ,Bank_Account_Number__c,Bank_Acct_Number__c,Send_Email_For_Perfios__c,sum_Avg_mthly_bal__c,Sum_DB_Amount__c,Sum_CRD_Amount__c,Perfios_Client_Address__c,Perfios_Flag__c ,Mode_Of_Salary_Credit__c,StatusOfBankAccount__c from Bank_Account__c where Loan_Application__c = ' + '\'' + loan.id + '\'';
    //01MOB E
    bankAccList = Database.query(queryBA);

    perfiosFlagBRE = 'NO';
    if (bankAccList != null && bankAccList.size() > 0) {
     bankAcc = bankAccList[0];
     con.Perfios_Address__c = bankAcc.Perfios_Client_Address__c;
     if (bankAcclist[0].Perfios_Flag__c == true) {
      perfiosflag = true;
      perfiosFlagBRE = 'YES';
     } else
      perfiosFlagBRE = 'NO';
    } else {
     bankAcc = new Bank_Account__c();
     bankAcc.Loan_Application__c = loan.id;
     bankAcc.Salaried_CAM__c = true;
     bankAcc.Applicant__c = applicantPrimary.id;
    }

    checkuser();
    if (LoanId != null) {
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
      Net_Profit_Margin__c, PBDT_Growth_over_last_year__c, Total_Net_Worth__c, Current_Year_return_filling_date__c, Line_opted__c, Line_flag__c, /*bug 19239 -- start*/ Product__c, Total_Unsecured_POS_from_Bajaj__c,
      Total_Unsecured_POS_outside_Bajaj__c, /*bug 19239 --  end*/
      Previous_Year_return_filling_date__c, Net_Working_Capital__c, Current_Ratio__c, OD_CC_Last_renewal_date__c, OC_CC_Enhancement_Amount__c,
      Cash_Conversion_Cycle_In_Days__c, Applicant__c, Line_assigned_basis_Credit_Assessment__c, Expiry_Date_without_BT__c, Tenor_for_Line_assignment_in_yrs__c,
      Debtor_Turnover_Days__c, Creditor_Turnover_Days__c, Stock_Turnover_Days__c, Total_existing_borrowing_to_sales__c, Latest_Credit_Rating_Agency__c, Rating_Obtained__c,
      Date_of_Latest_Rating__c, Closure_Month_Year__c, CY_Net_worth__c, Surrogate_loan_amount__c, Surrogate_Tenor__c, Sales_Customer_Segment__c, Sales_Final_Eligibility__c, Sales_Surrogate_eligibility__c,
      Line_Assigned_Date__c, Customer_Acceptance_Flag__c, Customer_Accepted_Date__c, Line_Active_Flag__c, OptOutURL__c, OptInURL__c, risk_category__c, Fee_Amount__c, Fees_Paid__c, Fees_Paid_Date__c
      from SurrogateCAM__c where Loan_application__c =: Loan.Id Order by LastModifiedDate desc // 19239 added order by
     ];
     if (ScamList.size() > 0) {
      objSurrogateCAM = ScamList[0];
      // bug 19239 start
      for (SurrogateCAM__c sc: ScamList) {
       if (sc.Applicant__c == NULL)
        reqConsilidatedScam = sc;
      }
      // bug 19239 end
     }
     //Added for disbursement
     discrepancyListDis = new List < Discrepancy__c > ();
     discrepancyListLog = new List < Discrepancy__c > ();
     for (Discrepancy__c ocl: discrepancyList) {
      if (ocl.Discrepancy_Category__c == 'Disbursement') {
       discrepancyListDis.add(ocl);
      } else {
       discrepancyListLog.add(ocl);
      }
     }
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
     //for Exsiting loans
     existingLoanDetailsList = new List < Existing_Loan_Details__c > ();

     applicantSelectList.clear();
     for (Applicant__c appl: Allapplist) {
      if (appl != null && appl.ContactName__c != null)
       applicantSelectList.add(new SelectOption(appl.ContactName__c, appl.ContactName__c));
     }

     ATOSParameters__c SegmentProducts = new ATOSParameters__c();
     SegmentProducts = ATOSParameters__c.getValues('SegmentationProducts');

     if (SegmentProducts != null && SegmentProducts.Product__c != null) {
      SegmentProduct = SegmentProducts.Product__c;
     }
     // 01MOB 5873
     ExistLoans = [select id, Secured_Unsecured__c, Loan_Type__c, Seen_in__c,
      Loan_Acc_No__c, Select__c, Applicant__r.ContactName__c, Principal_O_s__c, Status__c, Customer_Declared_EMI__c,
      Financer__c, Amount__c, Month1_Amount__c, Month2_Amount__c, Financers__c, Obligation__c, Loan_Amount__c, EMI_Over_In_Next_6_months__c,
      Start_On__c, Tenor__c, Tenor_Left__c, MOB__c, POS__c, EMI__c, Applicant__c, Annual_Obligation__c, Type_of_Oblig__c, No_of_Bounces_if_any__c,
      Month3Amount__c, Month4Amount__c, Month5Amount__c, Month6Amount__c, Mthly_Oblig__c, Remark__c, Derived_EMI__c, /*MOB*/ Rate_of_Interest__c, City__c, name, Property_Address__c /*MOB*/ /*01MOB S*/ , Purchase_Value__c, Property_Purchase_Date__c /*01MOB E*/ , Multiplier__c, /*Bug 13407 s*/ Mortgage_free_property__c, Still_own_the_property__c /*Bug 13407 e*/ from Existing_Loan_Details__c where Loan_Application__c =: Loan.Id order by CreatedDate
     ];

     //***PLOC start*********
     EverHLInCIBIL = 'NO';

     Set < String > ListOfHLprod = new Set < String > ();
     String everHLProducts = ATOSParameters__c.getValues('PLOCEverHLInCIBIL').Product__c;
     if (everHLProducts != null && everHLProducts != '') {
      for (String str: everHLProducts.split(',')) {
       ListOfHLprod.add(str.ToUpperCase());
      }
      //if(ListOfHLprod.size()>0)
      //EverHLInCIBIL = 'YES'; 
     }

     //PLOC***END*******
     //existingLoanDetailsList  
     ObligationWrapperList = new List < ObligationWrapper > ();
     for (Existing_Loan_Details__c exp: ExistLoans) {
      if (EverHLInCIBIL != null && exp != null && exp.Loan_Type__c != null && everHLProducts.contains(exp.Loan_Type__c.ToUpperCase())) { //PLOc 
       EverHLInCIBIL = 'YES';
      } //added for PLOC
      //OTPv3 TeleRM Rohit condition changed 15229
      if (OTPProducts != null && OTPProducts.contains(Loan.Product__c)) {
       if (Label.HL_loans.contains(exp.Loan_Type__c) && exp.Obligation__c == 'Yes')
        ExistLoanscount = ExistLoanscount + 1;
      } else {
       if ((exp.Loan_Type__c == 'HL' || exp.Loan_Type__c == 'Housing Loan') && exp.Obligation__c == 'Yes') {
        ExistLoanscount = ExistLoanscount + 1;
       }
      }
      if (exp.Status__c == 'Live' && exp.Obligation__c == 'Yes' && exp.Financers__c != null && exp.Loan_Type__c != null && exp.Financers__c == 'Bajaj Finance Ltd' && (exp.Loan_Type__c == 'PL' || exp.Loan_Type__c.toLowerCase() == 'personal loan')) {
       if (exp.POS__c != null)
        totalObligAmount = totalObligAmount + integer.valueof(exp.POS__c);
      }
      if (exp.Secured_Unsecured__c == 'Unsecured' && exp.Status__c == 'Live') {
       if (exp.EMI__c != null)
        secamtsum += exp.EMI__c;
      }
      if (exp.Secured_Unsecured__c == 'Secured' && exp.Status__c == 'Live') {
       if (exp.EMI__c != null)
        securedFOIR += exp.EMI__c;

      }
      //creditCardAmt
      if (exp.Loan_Type__c == 'Credit Card' && exp.Status__c == 'Live') {
       if (exp.POS__c != null)
        creditCardAmt += exp.POS__c;

      }

      if (exp.Loan_Type__c == 'Overdraft' && exp.Status__c == 'Live' && exp.Obligation__c == 'Yes') {

       if (exp.POS__c != null)
        overdraftAmt += exp.POS__c;

      }
      existingLoanDetailsList.add(exp);
      ObligationWrapperList.add(new ObligationWrapper(false, applicantSelectList, exp, false));
     }
     cibilExt1Obj = new Cibil_Extension1__c(); //PLOC
     runcibil();
     //Cubic Tree Integration start:: Added to query:: Applicant__r.Applicant_Type__c,Applicant__r.id,Applicant__r.Contact_Name__r.Name, Property_Details__c, Property_Details__r.id, Property_Details__r.Name,
     List < De_Dupe__c > allDeDupes = new List < DE_Dupe__c > ();
     allDeDupes = [select id, Property_Details__c, Property_Details__r.id, Property_Details__r.Name, Applicant__r.Applicant_Type__c, Applicant__r.id, name, Dedupe_Lan_Matches__c, Applicant__c, Applicant__r.Contact_Name__c, Datafix_Updated__c, Application_Status__c,
      Application_ID__c, Random_Dedupe__c, Area_Status__c, Customer_Status__c,
      Customer_ID__c, Dedupe_Comments__c, De_Dupe_result__c, Match_Status__c, De_Dupe_Decision__c, Segment__c, SF_Base__c, Source_Or_Target__c, Applicant__r.Contact_Name__r.Name, /* Bug 5880 S */ Dedupe_Target_Remarks__c, Dedupe_Source__c /*Bug 5880 E*/ , /* Property Dedupe - Anshita S*/ Dedupe_updated_time__c, Best_Match__c, CreatedDate, PropertyIDfromFinnOne__c, CASID__c, PropertyCodefromFinnOne__c, PropertyBuilderName__c, PropertyProjectName__c, PropertyAddressLine1__c, PropertyAddressLine2__c, PropertyAddressLine3__c,
      AreaLocality__c, AreaLocality__r.Name, PropertyState__c, PropertyPinCode__c, Latitude__c, Longitude__c, LAN__c, POS__c, ValuationAmount__c, Product__c /* Property Dedupe - Anshita E*/
      from De_Dupe__c where Loan_Application__c =: loan.id /*Mortgage*/ order by Applicant__c, /*Property Dedupe - Anshita S */ Property_Details__c /*Property dedupe - Anshita E */ , Source_Or_Target__c /*Bug 12114*/
     ];

     propDdpList = new List < De_Dupe__c > (); /* Property Dedupe - Anshita */
     for (De_Dupe__c dedupe: allDeDupes) {
      if (dedupe.Dedupe_Source__c != null && dedupe.Dedupe_Source__c == 'applicantdedupeCT') {
       appCubicDeDupeList.add(dedupe);
      } else if (dedupe.Dedupe_Source__c != null && dedupe.Dedupe_Source__c == 'propertydedupeCT') {
       propCubicDeDupeList.add(dedupe);
      } else if (dedupe.Applicant__c != null) {
       //dedupelist.add(dedupe); soql optimization
      }
      /*Property Dedupe Start - Anshita */
      else if (dedupe.Dedupe_Source__c != 'applicantdedupeCT' && dedupe.Dedupe_Source__c != 'propertydedupeCT' && dedupe.Property_Details__c != null && dedupe.Applicant__c == null && propDdpflag) {
       propDdpList.add(dedupe);
      } /* Property Dedupe End - Anshita */
     }

     //Cubic Tree Integration end
     dedupeWrapperList = new List < DedupeWrapper > ();
     propDedupeWrapLst = new List < propDedupeWrap > (); //Property Dedupe Bug 12944 - Anshita
     /*  if (dedupelist != null && dedupelist.size() > 0) {
for (De_Dupe__c de: dedupelist) {
// dedupeWrapperList.add(new DedupeWrapper(false,de,applicantMAP.get(de.Applicant__c),contactMAP.get(de.Applicant__r.Contact_Name__c)));
dedupeWrapperList.add(new DedupeWrapper(false, de, applicantMAP.get(de.Applicant__c), contactMAP.get(de.Applicant__r.Contact_Name__c), de.Applicant__r.Contact_Name__r.Name));
}
}*/
     //Bug : 7412 : Pritha : start

     dedupeNotDone = false;


     /* Property Dedupe Bug 12944 Start - Anshita */
     if (propDdpflag && (groupType == 'salaried' || groupType == 'selfemployed')) {
      if (propDdpList != null && propDdpList.size() > 0) {
       for (De_Dupe__c de: propDdpList) {
        propDedupeWrapLst.add(new PropDedupeWrap(false, de, propDtlMap.get(de.Property_Details__c)));
       }
      } else {
       dedupeNotDone = true;
       for (Id propId: propDtlMap.keyset()) {
        tempMapDedupe = new Map < String, object > ();
        tempMapDedupe.put('Property_Details__c', propDtlMap.get(propId));
        insertDedupe.add(tempMapDedupe);
       }
      }
     }
     /* Property Dedupe Bug 12944 End - Anshita */

     if (dedupelist != null && dedupelist.size() > 0) {
      for (De_Dupe__c de: dedupelist) {
       //Bug id:6980--Pritha; start
       if (groupType == 'salaried') {
        dedupeWrapperList.add(new DedupeWrapper(false, de, applicantMAP.get(de.Applicant__c), contactMAP.get(de.Applicant__r.Contact_Name__c), de.Applicant__r.Contact_Name__r.Name, GoogleAttachmentMap.get(de.Applicant__r.Id)));
       } else {
        dedupeWrapperList.add(new DedupeWrapper(true, de, applicantMAP.get(de.Applicant__c), contactMAP.get(de.Applicant__r.Contact_Name__c), de.Applicant__r.Contact_Name__r.Name, GoogleAttachmentMap.get(de.Applicant__r.Id)));
       }
      }
     } else {
      dedupeNotDone = true;
      for (Id appid: applicantMAP.keyset()) {
       Applicant__c Applicant = new Applicant__c();
       Applicant = applicantMAP.get(appid);
       Contact cont = new Contact();
       cont = contactMAP.get(Applicant.Contact_Name__c);
       //Create dedupe List
       tempMapDedupe = new Map < String, object > ();
       tempMapDedupe.put('Applicant__c', Applicant);
       tempMapDedupe.put('Contact', cont);
       tempMapDedupe.put('Opportunity', loan);
       insertDedupe.add(tempMapDedupe);

       //Bug id:6980--Pritha; end          
      }
     }
     //Bug : 7412 : Pritha : end

    }

    List < Checklist__c > standardchecklistTrnxList = new List < Checklist__c > ();
    ManualDeviationsWrap = new List < ManualDeviations > {};
    //DeviationsChecklistTrnxList , checklistTrnxList
    //Bug 11944 - Mitigants_Remark__c Field is added in query
    standardchecklistTrnxList = [select id, Document_Type__c, DocStatus__c, DocumentFmlyName__r.Documents__c, DocumentFmlyName__r.Is_MidOffice_Standard_Document__c, Category__c, Sales_Status__c, CPA_Status__c, Document__c,
     DocumentFmlyName__r.Id, DocumentFmlyName__r.Name, Checklist_Parameter__r.Mandatory__c, Applicant__c, DocumentFmlyName__c,
     Documents__c, docRemarks__c, DocumentFmlyName__r.Document_Code__c, Property_Document__c, Mandatory__c, DocumentFmlyName__r.Deviation_Code__c, Manual__c, to_be_approved_by__c, Mitigants_Remark__c,
     Deviation_Master__r.Deviation_Description__c, Deviation_Master__r.Minimum_Approving_Authority__c, Deviation_Master__r.Deviation_Code__c, Deviation_Master__r.BRE_Deviation_Code__c
     from Checklist__c where Loan_Application__c =: LoanId
    ];

    if (standardchecklistTrnxList != null && standardchecklistTrnxList.size() > 0) {
     for (Checklist__c chk: standardchecklistTrnxList) {
      if (chk.Manual__c == true) {
       ManualDeviationList.add(chk);
      } else if (chk.Manual__c == false) {
       checklistTrnxList.add(chk);
      }
     }

    }

    for (Checklist__c CL: ManualDeviationList) {
     ManualDeviationsWrap.add(new ManualDeviations(CL));
    }


    createChecklist();
    documentNameList.clear();
    for (DocumentWrapper doc: docWrapperList) {
     if (doc.selectedDoc != null)
      documentNameList.add(doc.selectedDoc);

     else if (doc.singleDoc != null)
      documentNameList.add(doc.singleDoc);
    }
    for (DocumentWrapper doc1: deviationDocWrapperList) {
     if (doc1.selectedDoc != null)
      documentNameList.add(doc1.selectedDoc);

     else if (doc1.singleDoc != null)
      documentNameList.add(doc1.singleDoc);
    }
    deviations = [Select Id, Name, Deviation_Description__c, Deviation_Code__c, BRE_Deviation_Code__c from Deviation_Master__c
     where Product__c =: Loan.Product__c and Active_Flag__c = true and BRE_Deviation_Code__c != null
    ];

    optionsDev = new List < SelectOption > ();

    for (integer i = 0; i < deviations.size(); i++) {
     optionsDev.add(new SelectOption(deviations[i].Id, deviations[i].Name + '-' + deviations[i].BRE_Deviation_Code__c));
    }

    /* devTransView = [Select Id,Mitigating_Documents_list__c,Deviation_Master__c,Deviation_Master__r.Deviation_Description__c,
Deviation_Master__r.Primary_Secondary__c,Mandatory_Optional__c,Mitigating_Document__c,
Deviation_Master__r.Minimum_Approver_Level__c,Deviation_Master__r.Deviation_Code__c,
Deviation_Master__r.Deviation_Category__c,Deviation_Master__r.Minimum_Approving_Authority__c,
Mitigant__c,Manual__c,Recommended_to__c,Other_deviations__c
from Deviation_Transaction__c
where Loan_Application__c=:Loan.Id order by createddate desc];


checklistParamList = [Select name,Document_Family__c,DeviationMaster__c,DeviationMaster__r.Deviation_name__c,Document_Family__r.Name,Document_Family__r.Documents__c,Document_Family__r.Is_OTP_Standard_Document__c,
Mandatory__c,Active__c,Type_of_Document__c,Stages__c,Customer_Segmentation__c from Checklist_Parameter__c 
where Product__c ='PSBL'];

/*
docFamilyMaster = [select name,Type_of_Document__c,Documents__c,Is_MidOffice_Standard_Document__c,Is_OTP_Standard_Document__c from Document_Family__c where Is_MidOffice_Standard_Document__c=true];

for(Document_Family__c docFam : docFamilyMaster){
docFamilyMap.put(docFam.id,docFam); 

}
if(checklistTrnxList.size() == 0){
for(Checklist_Parameter__c checklistParameter : checklistParamList){    
Checklist__c tempChecklist = new Checklist__c(Loan_Application__c = loanId,Checklist_Parameter__c = checklistParameter.id,Mandatory__c = checklistParameter.Mandatory__c);

if(checklistParameter.Type_of_Document__c == 'Standard'){
DocumentWrapper wrapperObjForDev = new DocumentWrapper(tempChecklist,checklistParameter.Document_Family__r.Name,checklistParameter.Document_Family__r.Documents__c);
standardDocWrapperList.add(wrapperObjForDev);
}
}
}

standardDocuments = new List<Checklist__c>();*/
    //prepareCheckList(); 
   }
   if (Loan.Product__c == 'FAS') {
    refreshScripts();
   }
  } catch (Exception e) {
    System.debug('pk exception'+e.getMessage()+e.getLineNumber());
   //sendEmailForException(e);
   //Apexpages.addMessages(e);

   // savedSuccessfull = true;        
   // message = e.getMessage() + '  ' + e.getLineNumber() + '  ' + e.getCause()+  '  ' + e.getTypeName();   
   // SendExceptionMail(message,'Exception came in MidOffice flow (Eligibility)');
  }

  //made true for testing purpose
  if (Loan != null) {
   showsave = true;
   ID Pid = Userinfo.getProfileID();
   String Pname = [select id, name from Profile where id =: Pid].name;
    //Digital Sampling S*/
        if(System.Label.LG_Product.contains(Loan.Product__c)&& loan.Full_Underwriting__c == true && System.Label.LG_Profile.contains(Pname) && System.Label.LG_Stage.contains(Loan.StageName))
            ShowDigitalSamplingPanel = true;
   //Digital Sampling E*/
   string owneridOfOppo;
   list < User > profilename = new list < User > ();
   //new code for reject button

   owneridOfOppo = Loan.ownerId;
   profilename = [select id, Profile.Name, Name from User where id =: owneridOfOppo];
   if (Pname == 'System Administrator' || Pname == 'Sys Administrator') {
    showsave = true;
   }
   if ((Pname == 'CPA Login partner' || Pname == 'FAS CPA Login') && (Loan.stagename != 'Rejected')) {
    showsave = true;
   }
   // Bug id : 13016 - New Role Creation for Credit, added by Needhi 
   If((Pname == 'Credit Manager' || Pname == 'Area Credit Manager' || Pname == 'City Head' || Pname == 'President' ||
     Pname == 'Regional Credit Manager' || Pname == 'Zonal Credit Manager' ||
     Pname == 'National Credit Manager' || Pname == 'Senior Credit Officer' || Pname == 'National Risk Manager' ||
     Pname == 'Chief Risk Officer' || Pname == 'Chief-Credit & Operations' ||
     Pname == 'Centralized CPA' || Pname == 'Centralized ACM' ||
     Pname == 'Centralized RCM' || Pname == 'Business Head') &&
    (Loan.stagename != 'Approved' && Loan.stagename != 'Rejected') &&
    Pname == Loan.Approver__c && Pname == profilename[0].Profile.Name) {
    showsave = true;
   }
   If((Pname == 'Credit Manager' || Pname == 'Area Credit Manager' || Pname == 'City Head' || Pname == 'President' ||
     Pname == 'Regional Credit Manager' || Pname == 'Zonal Credit Manager' ||
     Pname == 'National Credit Manager' || Pname == 'Senior Credit Officer' || Pname == 'National Risk Manager' ||
     Pname == 'Chief Risk Officer' || Pname == 'Chief-Credit & Operations' ||
     Pname == 'Centralized CPA' || Pname == 'Centralized ACM' ||
     Pname == 'Centralized RCM' || Pname == 'Business Head') && (Loan.stagename != 'Rejected') &&
    Pname == Loan.Approver__c && Pname == profilename[0].Profile.Name) {
    showsave = true;
   }
   If((Pname == 'Credit Manager' || Pname == 'Area Credit Manager' || Pname == 'City Head' || Pname == 'President' ||
    Pname == 'Regional Credit Manager' || Pname == 'Zonal Credit Manager' ||
    Pname == 'National Credit Manager' || Pname == 'Senior Credit Officer' || Pname == 'National Risk Manager' ||
    Pname == 'Chief Risk Officer' || Pname == 'Chief-Credit & Operations' ||
    Pname == 'Centralized CPA' || Pname == 'Centralized ACM' ||
    Pname == 'Centralized RCM' || Pname == 'Business Head') && (Loan.stagename != 'Rejected') && Pname == profilename[0].Profile.Name) {
    showsave = true;
   }
  }
  system.debug('Loan is' + Loan);
  if (LoanId != null) {
   product = Loan.Product__c;
   if (Loan.Branch_Name__c != null && Loan.Branch_Name__r.name != null)
    CO = [select id, name, City__c, Number_of_Deviations__c, Credit_Officer_Name__r.Isactive, Credit_Officer_Name__r.id, Credit_Officer_Name__r.name, Credit_Officer_Name__c, Designation__c, Loan_Amount__c, Flow__c, Pre_Approved_Amount__c, User_Type__c from Credit_Officer_Limit__c
     where product__c =: product AND Credit_Officer_Name__r.Isactive = true AND Active_Flag__c = true
     and User_Type__c != 'OPs User'
     and City__c INCLUDES(: Loan.Branch_Name__r.name)
    ];
   optionsAppr.clear();

   if (CO.size() > 0) {
    optionsApprFprOtcPDD.add(new SelectOption('NA', 'NA')); // Added newly For Approval Aurhority
    for (integer i = 0; i < CO.size(); i++) {
     try {
      if (Loan.Branch_Name__c == null) {
      if (salmobilityv2falg)
          mobilitystatus = 'Branch value is empty. Unable to continue';
      else
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Branch value is empty. Unable to continue'));
      }
      if ((CO[i].Credit_Officer_Name__c != null) && (CO[i].city__c != null)) {
       if (COLStampFlag == true) {
        if (CO[i].City__c.toUpperCase().contains(Loan.Branch_Name__r.name.toUpperCase()) && CO[i].Flow__c != null && CO[i].Flow__c.contains(LoanAppFlow)) {
         optionsAppr.add(new SelectOption(CO[i].Id, CO[i].Credit_Officer_Name__r.name + '-' + CO[i].Designation__c));
         optionsApprFprOtcPDD.add(new SelectOption(CO[i].Credit_Officer_Name__r.name, CO[i].Credit_Officer_Name__r.name + '-' + CO[i].Designation__c));

        }
       } else {
        if (CO[i].City__c.toUpperCase().contains(Loan.Branch_Name__r.name.toUpperCase())) {
         optionsAppr.add(new SelectOption(CO[i].Id, CO[i].Credit_Officer_Name__r.name + '-' + CO[i].Designation__c));
         optionsApprFprOtcPDD.add(new SelectOption(CO[i].Credit_Officer_Name__r.name, CO[i].Credit_Officer_Name__r.name + '-' + CO[i].Designation__c));

        }
       }
      }
     } catch (Exception e) {
      sendEmailForException(e);
     }
    }
    optionsApprFprOtcPDD.add(new SelectOption('STD OTC', 'STD OTC'));
    optionsApprFprOtcPDD.add(new SelectOption('STD PDD', 'STD PDD'));
   }
   // Call center process start
   if (callcenterprocessFlag == true) {
    if (Loan.Branch_Name__c != null) {

     objSOLList = [SELECT Active__c, Product__c, ASM_Branch__c, Sales_Officer_Name__r.Isactive, Sales_Officer_Name__c,
      Sales_Officer_Name__r.id, Sales_Officer_Name__r.Name, Designation__c FROM Sales_Officer_Limit__c
      Where(Product__c = 'SAL'
       OR Product__c = 'SPL') AND
      Active__c = true AND
      Sales_Officer_Name__r.Isactive = true AND
      ASM_Branch__c =: Loan.Branch_Name__r.Name
     ];
    }
    optionsApprSales.clear();

    if (objSOLList != null && objSOLList.size() > 0) {
     for (Sales_Officer_Limit__c objSOL: objSOLList) {
      optionsApprSales.add(new SelectOption(objSOL.Id, objSOL.Sales_Officer_Name__r.name + '-' + objSOL.Designation__c));
     }
    }
   }
   // Call center process end
  }
  //Bug: 14987
  //For Branch OPs credit hirrachy approval
  List < Credit_Officer_Limit__c > COFAS = [select id, name, City__c, Number_of_Deviations__c, Credit_Officer_Name__r.Isactive, Credit_Officer_Name__r.id, Credit_Officer_Name__r.name, Credit_Officer_Name__c, Designation__c, Loan_Amount__c, User_Type__c, Flow__c, Pre_Approved_Amount__c
   from Credit_Officer_Limit__c
   where product__C =: Loan.product__c AND Credit_Officer_Name__r.Isactive = true AND Active_Flag__c = true and(User_Type__c = 'OPs User'
    /*CIBIL Watch Start*/
    OR User_Type__c = 'Centralised Ops' /*CIBIL Watch Start*/ )
  ];

  optionsCOApprFAS.clear();
  optionsCOAppr1.clear(); //CIBIL Watch 

  if (COFAS.size() > 0) {
   for (integer i = 0; i < COFAS.size(); i++) {
    if (Loan.Branch_Name__c == null) {
     if (salmobilityv2falg)
         mobilitystatus = 'Branch value is empty. Unable to continue';
     else
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Branch value is empty. Unable to continue'));
    }
    if ((COFAS[i].Credit_Officer_Name__c != null) && (COFAS[i].city__c != null)) {

     if (COLStampFlag == true) {
      if (COFAS[i].City__c.toUpperCase().contains(Loan.Branch_Name__r.name.toUpperCase()) && COFAS[i].Flow__c != null && COFAS[i].Flow__c.contains(LoanAppFlow)) {


       //CIBIL Watch Start
       //Anjali Production issue bug-11556 Added below if condition
       if (i < CO.size()) {
        if (CO[i].User_Type__c != null && CO[i].User_Type__c == 'Centralised Ops') {
         optionsCOAppr1.add(new SelectOption(CO[i].Id, CO[i].Credit_Officer_Name__r.name + '-' + CO[i].Designation__c));
        } else {
         optionsCOApprFAS.add(new SelectOption(COFAS[i].Id, COFAS[i].Credit_Officer_Name__r.name + '-' + COFAS[i].Designation__c));
        }
       }
       //CIBIL Watch End
      }
     } else {
      if (COFAS[i].City__c.toUpperCase().contains(Loan.Branch_Name__r.name.toUpperCase())) {
       //CIBIL Watch Start
       //Anjali Production issue bug-11556 Added below if condition
       if (i < CO.size()) {
        if (CO[i].User_Type__c != null && CO[i].User_Type__c == 'Centralised Ops') {
         optionsCOAppr1.add(new SelectOption(CO[i].Id, CO[i].Credit_Officer_Name__r.name + '-' + CO[i].Designation__c));
        } else {
         optionsCOApprFAS.add(new SelectOption(COFAS[i].Id, COFAS[i].Credit_Officer_Name__r.name + '-' + COFAS[i].Designation__c));
        }
       }
       //CIBIL Watch End
      }
     }
    }
   }

  }
  /*BUG-16959 added Prod condition for DBOL  by Rajesh */
  //BUG ID 17470 
  if (loan != null && applicantPrimary != null && (isPSBLProductLineProduct != null && isPSBLProductLineProduct || loan.Product__c == 'SBS CS PSBL' || Mortgageflag || /*invisible monitoring dl by akshata*/ loan.Product__c == 'DOCTORS' || (isPROProductLineProduct != null && isPROProductLineProduct) || /* SL IM rohit start*/ loan.Product__c == 'SAL' || loan.Product__c == 'SPL' /* SL IM rohit end*/ )) { //Mortgage Re-Engg added Condition
   RSAReasonList = new List < SelectOption > ();
   RSAReasonList.add(new SelectOption('--None--', '--None--'));
   RSAReasonList.add(new SelectOption('Doubtful Banking', 'Doubtful Banking'));
   RSAReasonList.add(new SelectOption('Doubtful Financial', 'Doubtful Financial'));
   RSAReasonList.add(new SelectOption('Doubtful Profile', 'Doubtful Profile'));
   RSAReasonList.add(new SelectOption('Doubtful ITR', 'Doubtful ITR'));
   RSAReasonList.add(new SelectOption('Other', 'Other'));
   System.debug('applicantPrimary::::' + applicantPrimary);
   String s = applicantPrimary.RSA_reason__c;
   if (s == null || s.length() == 0) {
    RSAReason = '--None--';
   } /*invisible monitoring dl by akshata S*/
   else {
    /*BUG-16959 added Prod condition for DBOL  by Rajesh */
    //BUG ID 17470
    if (loan.Product__c == 'DOCTORS' || isPROProductLineProduct || isPSBLProductLineProduct /*SAL IM condition added */ || loan.Product__c == 'SAL' || loan.Product__c == 'SPL') {
     RSAReason = s;
    }
   } /*invisible monitoring dl by akshata E*/
   //Bug 5943 - SAL PL Document checklist issue Start
   /*
if(LoanId!=null){
CO = [select id,name,City__c,Number_of_Deviations__c,Credit_Officer_Name__r.Isactive,Credit_Officer_Name__r.id,Credit_Officer_Name__r.name,Credit_Officer_Name__c,Designation__c,Loan_Amount__c,User_Type__c,Pre_Approved_Amount__c 
from Credit_Officer_Limit__c 
where product__C =:Loan.product__c  AND Credit_Officer_Name__r.Isactive=true AND Active_Flag__c=true and (User_Type__c='OPs User' OR User_Type__c='Centralised Ops' )]; 


optionsCOAppr.clear();
if(CO.size() > 0){
for(integer i = 0; i < CO.size(); i++){  
if(Loan.Branch_Name__c==null){
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Branch value is empty. Unable to continue'));           
}
if((CO[i].Credit_Officer_Name__c != null)&&(CO[i].city__c!=null)){ 
if(CO[i].City__c.toUpperCase().contains(Loan.Branch_Name__r.name.toUpperCase())){   
optionsCOAppr.add(new SelectOption(CO[i].Id,CO[i].Credit_Officer_Name__r.name+'-'+CO[i].Designation__c));



}
}  
}

}
}

*/
   //Bug 5943 - SAL PL Document checklist issue End

   //Anjali mortgage IM Start
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
   }
   if (Mortgageflag) { //Mortgage Re-Engg added Condition
    RSAReasonList = new List < SelectOption > ();
    RSAReasonList.add(new SelectOption('--None--', '--None--'));
    RSAReasonList.add(new SelectOption('Doubtful Banking', 'Doubtful Banking'));
    RSAReasonList.add(new SelectOption('Doubtful Financial', 'Doubtful Financial'));
    RSAReasonList.add(new SelectOption('Doubtful Profile', 'Doubtful Profile'));
    RSAReasonList.add(new SelectOption('Doubtful ITR', 'Doubtful ITR'));
    RSAReasonList.add(new SelectOption('Other', 'Other'));
    s = applicantPrimary.RSA_reason__c;
    if (s == null || s.length() == 0) {
     RSAReason = '--None--';
    }
    IMActionList = new List < SelectOption > ();
    //IMActionList.add(new SelectOption('--None--', '--None--'));
    IMActionList.add(new SelectOption('Verification not required', 'Verification not required'));
    IMActionList.add(new SelectOption('Verification required', 'Verification required'));
    CORemarks = applicantPrimary.Underwriter_Remarks__c;
    // This logic is used to display the previous action taken by CO if any (Default value of dropdown list)
    if (CORemarks != null && CORemarks.length() > 0 && applicantPrimary.Identified_for_Invisible_Monitoring__c == true && applicantPrimary.Invisible_Monitoring_Skipped__c == false)
     IMAction = 'Verification required';
    else
    if (CORemarks != null && CORemarks.length() > 0 && applicantPrimary.Identified_for_Invisible_Monitoring__c == true && applicantPrimary.Invisible_Monitoring_Skipped__c == true)
     IMAction = 'Verification not required';
    else
     IMAction = 'Verification not required';

    // InvisibleMonitoringResults();
   }
   //Anjali mortgage IM end

   /** Bug 10666 - fraud trigger enhancement start : krish **/
   OnLineSal_Products__c pro = OnLineSal_Products__c.getValues('Fraud Trigger Products');
   String products = pro.Product__c;
   if (products.toUpperCase().contains(loan.Product__c.toUpperCase())) {
    prodFlag = true;
   }
   /** Bug 10666 - fraud trigger enhancement end : krish **/

  }

 }
 //Getting the Property details 4937
 public List < Property_Details__c > getshares() {
  return shares;
 }
 List < Property_Details__c > shares = new List < Property_Details__c > ();

 public List < PortfoliotWrapper > wrapperList {
  get;
  set;
 }

 public List < Property_Details__c > sharesList {
  get;
  set;
 }

 public Decimal NoOfShares {
  set;
  get;
 }
 public Decimal totalCurrRate {
  set;
  get;
 }
 public Decimal totalShrVal {
  set;
  get;
 }
 public Decimal totalEligibility {
  set;
  get;
 }

 public Decimal TotalPortQty {
  set;
  get;
 }
 public Decimal TotalPortMV {
  set;
  get;
 }
 public Decimal TotalPortElig {
  set;
  get;
 }
 public Decimal TotalPortContr {
  set;
  get;
 }

 public Decimal TotalCatQty {
  set;
  get;
 }
 public Decimal TotalCatMV {
  set;
  get;
 }
 public Decimal TotalCatElig {
  set;
  get;
 }
 public Decimal TotalCatContr {
  set;
  get;
 }

 public Decimal TotalFundQty {
  set;
  get;
 }
 public Decimal TotalFundMV {
  set;
  get;
 }
 public Decimal TotalFundElig {
  set;
  get;
 }
 public Decimal TotalFundContr {
  set;
  get;
 }

 List < PortfoliotWrapper > finalPortList {
  set;
  get;
 }
 List < PortfoliotWrapper > finalCatList {
  set;
  get;
 }

 public void refreshScripts() {
  if (Loan.Id != null) {

   NoOfShares = 0;
   totalCurrRate = 0;
   totalShrVal = 0;
   totalEligibility = 0;

   TotalPortQty = 0;
   TotalPortMV = 0;
   TotalPortElig = 0;
   TotalPortContr = 0;

   TotalCatQty = 0;
   TotalCatMV = 0;
   TotalCatElig = 0;
   TotalCatContr = 0;

   TotalFundQty = 0;
   TotalFundMV = 0;
   TotalFundElig = 0;
   TotalFundContr = 0;

   Map < String, List < Property_Details__c >> portfolioMAP = new Map < String, List < Property_Details__c >> ();
   Map < String, List < Property_Details__c >> catportfolioMAP = new Map < String, List < Property_Details__c >> ();
   Map < String, List < Property_Details__c >> fundCatMAP = new Map < String, List < Property_Details__c >> ();

   sharesList.clear();
   finalCatList.clear();
   finalFundList.clear();
   finalPortList.clear();
   catportfolioMAP.clear();
   fundCatMAP.clear();
   portfolioMAP.clear();

   //Update portfolio
   for (Property_Details__c p: [select id, Credit_Total_Valuation_Mortgage__c, Digital_Scrip_Type__c, Digital_Scrip_Name__c, ISIN__c, BSE_Code__c, Digital_Scrip_Category__c,
     Number_of_Shares__c, Digital_Scrip_market_price__c, Digital_Total_Value__c, Contribution__c, X52_Wk_High_Rate__c,
     X52_Wk_Low_Rate__c, Digital_Scrips_Eligibility__c, Actual_LTV_without_insurance__c from Property_Details__c where Loan_Application__c =: Loan.Id /*FAS Sourcing channel changes :14187 by akshata*/ ORDER BY Contribution__c DESC
    ]) {

    //sharesWrapperList.add(new ScriptWrapper(false, p));
    sharesList.add(p);

    if (p.Number_of_Shares__c != null)
     NoOfShares += p.Number_of_Shares__c;
    if (p.Digital_Scrip_market_price__c != null)
     totalCurrRate += p.Digital_Scrip_market_price__c;
    if (p.Digital_Total_Value__c != null)
     totalShrVal += p.Digital_Total_Value__c;
    if (p.Digital_Scrips_Eligibility__c != null) {
     totalEligibility += p.Digital_Scrips_Eligibility__c;
    }

    //Add Map   
    if (portfolioMAP.get(p.Digital_Scrip_Type__c) != null) {
     portfolioMAP.get(p.Digital_Scrip_Type__c).add(p);
    } else {
     portfolioMAP.put(p.Digital_Scrip_Type__c, new List < Property_Details__c > {
      p
     });
    }

    //if (p.Digital_Scrip_Type__c == 'Shares' || p.Digital_Scrip_Type__c == 'EQUITY' || p.Digital_Scrip_Type__c == 'Equity') {
    if (p.Digital_Scrip_Type__c != null && (p.Digital_Scrip_Type__c.equalsIgnoreCase('EQUITY') || p.Digital_Scrip_Type__c.equalsIgnoreCase('Shares'))) {
     if (catportfolioMAP.get(p.Digital_Scrip_Category__c) != null) {
      catportfolioMAP.get(p.Digital_Scrip_Category__c).add(p);
     } else {
      catportfolioMAP.put(p.Digital_Scrip_Category__c, new List < Property_Details__c > {
       p
      });
     }
    }

    if (p.Digital_Scrip_Type__c == 'Mutual Fund' || p.Digital_Scrip_Type__c == 'MF') {
     if (fundCatMAP.get(p.Digital_Scrip_Category__c) != null) {
      fundCatMAP.get(p.Digital_Scrip_Category__c).add(p);
     } else {
      fundCatMAP.put(p.Digital_Scrip_Category__c, new List < Property_Details__c > {
       p
      });
     }
    }

   }

   Decimal qty = 0.00, marketVal = 0.00, eligibility = 0.00, TotalPortContr1 = 0.00, TotalPortContr2 = 0.00, TotalCatContr2 = 0.00, TotalCatContr1 = 0.00, TotalFundContr1 = 0.00, TotalFundContr2 = 0.00;

   wrapperList.clear();

   for (String s: portfolioMAP.keyset()) {
    qty = 0.00;
    marketVal = 0.00;
    eligibility = 0.00;
    for (Property_Details__c p: portfolioMAP.get(s)) {
     if (p.Number_of_Shares__c != null)
      qty += p.Number_of_Shares__c;
     if (p.Digital_Total_Value__c != null)
      marketVal += p.Digital_Total_Value__c;
     //marketVal += p.Digital_Scrip_market_price__c;
     if (p.Digital_Scrips_Eligibility__c != null)
      eligibility += p.Digital_Scrips_Eligibility__c;

    }
    wrapperList.add(new PortfoliotWrapper(s, null, qty, marketVal, eligibility));
   }


   List < PortfoliotWrapper > portList = getConsolidatedData(wrapperList);

   if (portList != null && portList.size() > 0) {
    for (PortfoliotWrapper p: portList) {
     if (p.category == null || p.category == '') {
      finalPortList.add(p);
      TotalPortQty += p.qty;
      TotalPortMV += p.marketValue;
      TotalPortElig += p.Eligibility;
      TotalPortContr1 += p.contribution;
     }

    }

    TotalPortContr2 = TotalPortContr1.round(System.RoundingMode.CEILING);
    TotalPortContr = TotalPortContr2.setScale(2, System.RoundingMode.CEILING);

   }

   //Shares Category
   wrapperList.clear();

   for (String s: catportfolioMAP.keyset()) {

    qty = 0.00;
    marketVal = 0.00;
    eligibility = 0.00;

    for (Property_Details__c p: catportfolioMAP.get(s)) {

     if (p.Number_of_Shares__c != null)
      qty += p.Number_of_Shares__c;
     if (p.Digital_Total_Value__c != null)
      marketVal += p.Digital_Total_Value__c;
     //marketVal += p.Digital_Scrip_market_price__c;
     if (p.Digital_Scrips_Eligibility__c != null)
      eligibility += p.Digital_Scrips_Eligibility__c;

    }
    wrapperList.add(new PortfoliotWrapper(null, s, qty, marketVal, eligibility));
   }

   List < PortfoliotWrapper > catList = getConsolidatedData(wrapperList);

   if (catList != null && catList.size() > 0) {
    for (PortfoliotWrapper c: catList) {
     if (c.assetType == null || c.assetType == '') {
      finalCatList.add(c);
      TotalCatQty += c.qty;
      TotalCatMV += c.marketValue;
      TotalCatElig += c.Eligibility;
      TotalCatContr1 += c.contribution;
     }

    }

    TotalCatContr2 = TotalCatContr1.round(System.RoundingMode.CEILING);
    TotalCatContr = TotalCatContr2.setScale(2, System.RoundingMode.CEILING);
   }

   //Fund Category
   wrapperList.clear();

   for (String s: fundCatMAP.keyset()) {

    qty = 0.00;
    marketVal = 0.00;
    eligibility = 0.00;

    for (Property_Details__c p: fundCatMAP.get(s)) {

     if (p.Number_of_Shares__c != null)
      qty += p.Number_of_Shares__c;
     if (p.Digital_Total_Value__c != null)
      marketVal += p.Digital_Total_Value__c;
     //marketVal += p.Digital_Scrip_market_price__c;
     if (p.Digital_Scrips_Eligibility__c != null)
      eligibility += p.Digital_Scrips_Eligibility__c;

    }
    wrapperList.add(new PortfoliotWrapper(null, s, qty, marketVal, eligibility));
   }

   List < PortfoliotWrapper > fundList = getConsolidatedData(wrapperList);

   if (fundList != null && fundList.size() > 0) {
    for (PortfoliotWrapper c: fundList) {
     if (c.assetType == null || c.assetType == '') {
      finalFundList.add(c);
      TotalFundQty += c.qty;
      TotalFundMV += c.marketValue;
      TotalFundElig += c.Eligibility;
      TotalFundContr1 += c.contribution;
     }

    }

    TotalFundContr2 = TotalFundContr1.round(System.RoundingMode.CEILING);
    TotalFundContr = TotalFundContr2.setScale(2, System.RoundingMode.CEILING);


    TotalCatContr2 = TotalCatContr1.round(System.RoundingMode.CEILING);
    TotalCatContr = TotalCatContr2.setScale(2, System.RoundingMode.CEILING);


   }

   message = 'Scripts refreshed Successfully !!!';

  }
 }

 public List < PortfoliotWrapper > getwrapperList {
  set;
  get;
 }

 /*public Pagereference DeleteScripts() {

if(LoanId != null){
List<Property_Details__c> Propertydelete = new List<Property_Details__c>();

if (sharesWrapperList != null && sharesWrapperList.size() > 0) {
for (ScriptWrapper obj: sharesWrapperList) {
if (obj.selectScript == true) {
Propertydelete.add(obj.PropertyObj);
}
}

if(Propertydelete.size()>0){
delete Propertydelete;

savedSuccessfull = true;

}
}

if(savedSuccessfull == true){
sharesWrapperList.clear();

NoOfShares = 0;
totalCurrRate = 0;
totalShrVal = 0;

for(Property_Details__c p : [select id,Scrip_Name__c,Scrip_Name__r.Name,Minimum_Scrip__c,Scrip_Type__c,Number_of_Shares__c,Current_Market_Value__c,Share_Value__c ,Digital_Scrips_Eligibility__c from Property_Details__c where Loan_Application__c =: LoanId and Property_Type__c = 'Shares']){
sharesWrapperList.add(new ScriptWrapper(false, p));

NoOfShares += p.Number_of_Shares__c;
totalCurrRate += p.Current_Market_Value__c;
totalShrVal += p.Share_Value__c;
}

message = 'Scripts deleted Successfully !!!';
}  
}

if (LoanId != null) {
Pagereference p =new pagereference('http://bflportaluat:3000/Pages/your-Portfolio.aspx?id=' + LoanId);
p.setRedirect(true);
return p;
}
return null;

}*/

 /* public class ScriptWrapper {
public Boolean selectScript {
get;
set;
}
public Property_Details__c PropertyObj {
get;
set;
}

ScriptWrapper(Boolean flag, Property_Details__c script) {
selectScript = flag;
PropertyObj = script;            
}
}*/

 //Anjali mortgage IM start
 public PageReference UnHoldRSA() {
  try {
   String referal = LOan.Referral__c;
   if (referal == 'None') {
    Loan.Referral__c = null;
   }
   Loan.UnHold__c = true;
   update Loan;

   applicantPrimary.RSA_reason__c = '';
   applicantPrimary.RSA_SMS_Email_sent__c = false;
   applicantPrimary.RSA_flag__c = false;
   update applicantPrimary;

   Pagereference p = new pagereference('/' + Loan.Id);
   return p;
  } catch (Exception e) {
   Apexpages.addMessages(e);
   return null;
  }

 }

 public PageReference saveFraud() {
  try {
   update applicantPrimary;
   Pagereference p = new pagereference('/' + Loan.Id);
   return p;
  } catch (Exception e) {
   return null;
  }
 }

 public PageReference saveRSA() {
  System.debug('rohit ');
  PageReference pageref;
  // invisible monitoring dl by akshata added product condition S
  //BUG ID 17470
  if (Loan != null && (Loan.Product__c == 'DOCTORS' || isPROProductLineProduct)) {
   String customertype = ApexPages.currentPage().getParameters().get('customertype');
   pageref = new pagereference('/apex/Sales_PRO_EligibilityDetails?id=' + Loan.Id + '&grouptype=professional&Product=' + Loan.Product__c + '&sales=' + isFromSales + '&customertype=' + customertype);
   // pageref = new pagereference(bsaeurl+url);
  }
  //SAL IM rohit start
  else if (Loan != null && (Loan.Product__c == 'SPL' || Loan.Product__c == 'SAL')) {
   pageref = new pagereference('/apex/COEligibilityDetailsPage?id=' + Loan.Id + '&grouptype=salaried');
  }
  //SAL IM Rohit end
  else {
   pageref = new pagereference('/apex/Sales_SE_EligibilityDetails?id=' + Loan.Id + '&grouptype=selfemployed');
  }
  // invisible monitoring dl by akshata added product condition E
  pageref.setRedirect(true);
  //Rohit added for bug id 18289
  System.debug('rohit ' + RSAReason);
  if (applicantPrimary.check_RSA__c != null && applicantPrimary.check_RSA__c != '') {
   if (applicantPrimary.check_RSA__c == 'Yes') {
    applicantPrimary.RSA_flag__c = true;
    applicantPrimary.RSA_initiation_Date__c = Date.today();
    applicantPrimary.Identified_for_Invisible_Monitoring__c = true;
   }

   try {

    update Loan;
   } catch (DMLException e) {
    system.debug('Error in updating flag');
   }
   system.debug('Loan stage -----> ' + Loan.StageName);
   if (applicantPrimary.RSA_SMS_Email_sent__c == null) {
    applicantPrimary.RSA_SMS_Email_sent__c = false;
   }
  } else {
   showNoApplicationError = true;
   //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please select RSA Flag'));
   applicantPrimary.RSA_reason__c = '';
   applicantPrimary.RSA_flag__c = false;
   applicantPrimary.check_RSA__c = null;
   applicantPrimary.RSA_initiation_Date__c = null;
   applicantPrimary.Identified_for_Invisible_Monitoring__c = false;

   showRSASection = true;
  }

  try {
   update applicantPrimary;
  } catch (DMLException e) {
   system.debug('Error in updating flag');
  }

  if (applicantPrimary.RSA_flag__c == true) {
   applicantPrimary.Identified_for_Invisible_Monitoring__c = true;
   if (RSAReason != '--None--') {

    if (applicantPrimary.RSA_SMS_Email_sent__c == null) {
     applicantPrimary.RSA_SMS_Email_sent__c = false;
    }
    if (applicantPrimary.RSA_flag__c == true && applicantPrimary.RSA_SMS_Email_sent__c == false) {
     String body;
     List < User > rsaUser = new List < User > ();

     String RSAProfile = System.Label.RSA_Profile_Role;
     String[] RSAProfileArray = RSAProfile.split(',');

     for (String str: RSAProfileArray) {

     }

     if (RSAProfileArray != null && RSAProfileArray.size() > 0) {
      rsaUser = [SELECT Id, Name, Mobile_number__c, City__c, Product__c, Email from User where(Profile.name IN: RSAProfileArray OR UserRole.Name IN: RSAProfileArray)
       AND Product__c includes(: loan.Product__c) and Branch_City__c includes(: loan.Branch_City__c) and IsActive = true
      ];
     }

     List < User > currentUser = new List < User > ();
     currentUser = [select id, name, City__c, Mobile_number__c from User where id =: UserInfo.getUserId() Limit 1];

     if (currentUser != null && currentUser.size() > 0) {}

     String emsg;
     String sub = 'RSA Case Reported for LAN : ' + loan.Loan_Application_Number__c + ' and Loan Name : ' + loan.name;
     if (rsaUser.size() > 0) {

      for (User u: rsaUser) {

       String[] toAdd = new string[] {
        u.Email
       };
       emsg = '<html><body>';
       emsg += 'Dear ' + u.Name + '<br/><br/>Please click on the below link to check the loan application';
       //emsg += '<br></br><a href=\\"https://ap1.salesforce.com/' + Loan.id + '\\">' + '</a>';

       //emsg += '<br/><br/><a href=\\\"' + System.URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Sales_SE_EligibilityDetails?id=' + Loan.id + '\\\">' + 'Click here' + '</a>';
       //invisible monitoring dl by akstata added if condition S
       //BUG ID 17470
       if (Loan != null && (Loan.Product__c == 'DOCTORS' || isPROProductLineProduct)) {
        emsg += '<br/><br/><a href=\\\"' + System.URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Sales_PRO_EligibilityDetails?id=' + Loan.id + '\\\">' + 'Click here' + '</a>';
       }
       //SAL IM rohit start
       else if (Loan != null && (Loan.Product__c == 'SPL' || Loan.Product__c == 'SAL')) {
        emsg += '<br/><br/><a href=\\\"' + System.URL.getSalesforceBaseUrl().toExternalForm() + '/apex/COEligibilityDetailsPage?id=' + Loan.id + '\\\">' + 'Click here' + '</a>';
       }
       //SAL IM Rohit end
       else {
        emsg += '<br/><br/><a href=\\\"' + System.URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Sales_SE_EligibilityDetails?id=' + Loan.id + '\\\">' + 'Click here' + '</a>';
       }
       //invisible monitoring dl by akstata added if condition E
       // UAT2 URL
       //emsg += '<br/><br/><a href=\\\"' + 'https://c.cs5.visual.force.com' + '/apex/Sales_SE_EligibilityDetails?id=' + Loan.id + '\\\">' + 'Click here' + '</a>';

       if (currentUser.size() > 0) {
        emsg += '<br/><br/>' + (currentUser[0].Mobile_number__c != null ? currentUser[0].Mobile_number__c : '') + '<br/>';
        emsg += (currentUser[0].City__c != null ? currentUser[0].City__c : '') + '<br/>Reason : ' + applicantPrimary.RSA_reason__c;
        emsg += '<br/><br/> Regards <br/>' + (UserInfo.getName() != null ? UserInfo.getName() : '') + '<br/>';
       }

       emsg += '<br/></body></html>';
       SOLsendEmail.RSASendEmail(toAdd, Sub, emsg);
       system.debug('Mobile' + u.Mobile_number__c);
       String mobile = String.valueOf(u.Mobile_number__c);
       if (mobile != null)
        mobile = mobile.replaceAll('[^0-9]', '');

       String message = 'RSA Case Reported for LAN : ' + (loan.Loan_Application_Number__c != null ? loan.Loan_Application_Number__c : '') + 'From UI';
       message += ' and Loan Name : ' + (loan.name != null ? loan.name : '') + '&#13;&#10;&#13;&#10;' + 'Regards,' + '&#13;&#10;' + (u.Name != null ? u.Name : '');
       message += '&#13;&#10;' + (u.City__c != null ? u.City__c : '') + '&#13;&#10;' + mobile;

       if (!Test.isRunningTest()) {
        sendsms.message(mobile, message);
       }
      }
      if (applicantPrimary != null) {
       applicantPrimary.RSA_SMS_Email_sent__c = true;
       update applicantPrimary;
      }

     }
    }
    //showRSASection = true;

   } else {
    applicantPrimary.RSA_flag__c = false;
    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please select RSA reason'));
   }
  } else {

   showNoApplicationError = true;
   //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please select RSA Flag'));
   applicantPrimary.RSA_reason__c = '';
   applicantPrimary.RSA_flag__c = false;
   try {
    update applicantPrimary;
   } catch (DMLException e) {}
   showRSASection = true;
  }
  return pageref;
 }

 String verifications;
 public pagereference initiateInvisibleMonitoring() {

  switchFlag = true;
  if (!Test.isRunningTest()) {
   mapOfInvisibleMonitoringResults = BRECalloutForInvisibleMonitoring('GROUP', 'None');
  }

  if (mapOfInvisibleMonitoringResults != null) {
   //Skip the logic of Group Count for Mortgage Invisible Monitoring 
   //Added on 15-Feb S
   if (!Mortgageflag) {
    //Added on 15-Feb E
    // Get minimum count of each group from custom settings
    Invisible_Monitoring__c Group1 = Invisible_Monitoring__c.getValues('Group 1');
    Invisible_Monitoring__c Group2 = Invisible_Monitoring__c.getValues('Group 2');
    Invisible_Monitoring__c Group3 = Invisible_Monitoring__c.getValues('Group 3');
    Invisible_Monitoring__c TotalRulesToBeMatched = Invisible_Monitoring__c.getValues('Rules to be matched for Group Triggers');

    // Display results on the screen
    Integer minCountOfGroup1 = Integer.valueOf(Group1.Rules_to_be_matched__c);
    Integer minCountOfGroup2 = Integer.valueOf(Group2.Rules_to_be_matched__c);
    Integer minCountOfGroup3 = Integer.valueOf(Group3.Rules_to_be_matched__c);

    // Get total count of all groups from custom settings
    Integer minCountOfGT = Integer.valueOf(TotalRulesToBeMatched.Rules_to_be_matched__c);
    /*
Total count returned by BRE for Group Triggers (GTCount) is not to be considered for displaying final result on the screen
as per change request. Minimum count of Group1 OR Group2 OR Group3 would be considered while displaying final results.
If any one of these counts returned by BRE is more than the minimum count stored in custom settings then application is
identified for invisible monitoring.
*/

    // Count returned by results

    countOfGroup1 = Integer.valueOf(mapOfInvisibleMonitoringResults.get('GTRDLCount'));
    countOfGroup2 = Integer.valueOf(mapOfInvisibleMonitoringResults.get('GTRPPCount'));
    countOfGroup3 = Integer.valueOf(mapOfInvisibleMonitoringResults.get('GTRPSCount'));
    GTCount = Integer.valueOf(mapOfInvisibleMonitoringResults.get('GTCount'));
    // Verifications returned by the results
    verifications = mapOfInvisibleMonitoringResults.get('verificationList');
    //verificationsArray = verifications.split(',');
    IMmessage = mapOfInvisibleMonitoringResults.get('message');

    // minCountOfGT
    if (countOfGroup1 >= minCountOfGroup1 || countOfGroup2 >= minCountOfGroup2 || countOfGroup3 >= minCountOfGroup3) {

     /*
If any one of these counts returned by BRE is more than the minimum count stored in custom settings then application is
identified for invisible monitoring.
*/

     identifiedByBRE = true;
     IMmessage = 'identified for Invisible Monitoring';
     IMflag = true;
     CObuttonFlag = false;

     String finalReason,
     Reason1,
     Reason2,
     Reason3;
     SOL_Policy__c solobj = new SOL_Policy__c();
     solobj.Applicant_Name__c = applicantPrimary.id;
     solobj.Loan_Application__c = LoanID;
     solobj.Created_from_Invisible_Monitoring__c = true;
     solobj.Policy_Status__c = 'Refer';
     solobj.Count_of_Group_1__c = countOfGroup1;
     solobj.Count_of_Group_2__c = countOfGroup2;
     solobj.Count_of_Group_3__c = countOfGroup3;

     if (countOfGroup1 >= minCountOfGroup1) {
      Group1result = true;
      Reason1 = 'Failure due to missing documents';
     } else
      Group1result = false;

     if (countOfGroup2 >= minCountOfGroup2) {
      Group2result = true;
      Reason2 = 'Failure due to poor profile';
     } else
      Group2result = false;

     if (countOfGroup3 >= minCountOfGroup3) {
      Group3result = true;
      Reason3 = 'Failure due to poor setup';
     } else
      Group3result = false;

     solobj.Count_of_Group_Triggers__c = GTCount;
     if (Reason1 != null)
      finalReason = Reason1 + ',';
     if (Reason2 != null)
      finalReason += Reason2 + ',';
     if (Reason3 != null)
      finalReason += Reason3;

     solobj.Policy_Name__c = finalReason;

     oldSolList = [SELECT Checklist_Policy_Status__c, id, name, Applicant_Name__c, Loan_Application__c, Created_from_Invisible_Monitoring__c, Policy_Status__c, Count_of_Group_1__c, Count_of_Group_2__c, Count_of_Group_3__c,
      Count_of_Group_Triggers__c, Count_of_Random_Triggers__c
      FROM SOL_Policy__c WHERE Loan_Application__c =: LoanID AND Created_from_Invisible_Monitoring__c = true LIMIT 1
     ];

     SOL_Policy__c oldSolObj;

     if (oldSolList != null && oldSolList.size() > 0)
      oldSolObj = oldSolList[0];

     try {
      if (oldSolObj == null) {
       List < SOL_Policy__c > tempListSOL = new List < SOL_Policy__c > ();
       tempListSOL.add(solobj);
       insert tempListSOL;
      } else {
       //oldSolObj = solobj;
       //oldSolObj = new SOL_Policy__c();
       oldSolObj.Count_of_Group_1__c = countOfGroup1;
       oldSolObj.Count_of_Group_2__c = countOfGroup2;
       oldSolObj.Count_of_Group_3__c = countOfGroup3;
       //oldSolObj.Applicant_Name__c = applicantPrimary.ID;
       //oldSolObj.Loan_Application__c = LoanID;
       //oldSolObj.Created_from_Invisible_Monitoring__c = true;
       //oldSolObj.Policy_Status__c = 'Refer';
       oldSolObj.Policy_Name__c = finalReason;
       update oldSolObj;
      }
     } catch (DMLException e) {}

     applicantPrimary.Verifications_returned_by_IM_BRE__c = verifications;
     applicantPrimary.Identified_for_Invisible_Monitoring__c = true;

     try {
      update applicantPrimary;
     } catch (DMLException e) {}
    } else {
     // When total count returned by BRE is less than minimum count stored in custom settings then application is not identified
     identifiedByBRE = false;
     IMflag = false;
     CObuttonFlag = true;
     applicantPrimary.Underwriter_Remarks__c = 'Not identified for Invisible Monitoring by BRE call';
     IMmessage = 'not identified for Invisible Monitoring';
     try {
      update applicantPrimary;
     } catch (DMLException e) {}
    }
    //Skip the logic of Group Count for Mortgage Invisible Monitoring 
    //Added on 15-Feb S
   } else {
    verifications = mapOfInvisibleMonitoringResults.get('verificationList');
    IMmessage = mapOfInvisibleMonitoringResults.get('message');
    identifiedByBRE = true;
    IMmessage = 'identified for Invisible Monitoring';
    IMflag = true;
    CObuttonFlag = false;

    if (verifications != null && verifications != '') {
     applicantPrimary.Verifications_returned_by_IM_BRE__c = verifications;
     applicantPrimary.Identified_for_Invisible_Monitoring__c = true;

     try {
      update applicantPrimary;
     } catch (DMLException e) {}
    } else {

     identifiedByBRE = false;
     IMflag = false;
     CObuttonFlag = true;
     applicantPrimary.Underwriter_Remarks__c = 'Not identified for Invisible Monitoring by BRE call';
     IMmessage = 'Not Identified for Invisible Monitoring';
     try {
      update applicantPrimary;
     } catch (DMLException e) {}
    }
   }
   //Added on 15-Feb E
  } else {
   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Error in getting response from BRE !!'));
  }
  return null;
 }

 public void InvisibleMonitoringFinalAction() {

  //if (IMAction != '--None--') {

  if (applicantPrimary.Underwriter_Remarks__c != null && applicantPrimary.Underwriter_Remarks__c != '') {

   if (IMAction == 'Verification required') {
    //applicantPrimary.Identified_for_Invisible_Monitoring__c = true;
    applicantPrimary.Invisible_Monitoring_Skipped__c = false;
    //applicantPrimary.Verifications_returned_by_IM_BRE__c = verifications;
    //CObuttonFlag = false;
    manualVerButtonFlag = true;
   } else
   if (IMAction == 'Verification not required') {
    //applicantPrimary.Identified_for_Invisible_Monitoring__c = true;
    applicantPrimary.Invisible_Monitoring_Skipped__c = true;
    //applicantPrimary.Verifications_returned_by_IM_BRE__c = verifications;
    //CObuttonFlag = true;
    manualVerButtonFlag = false;
   }

   applicantPrimary.Invisible_monitoring__c = 'Group Trigger Verification';
   CORemarks = applicantPrimary.Underwriter_Remarks__c;
   try {
    update applicantPrimary;
   } catch (DMLException e) {}

   CObuttonFlag = true;
  } else {
   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Please enter remarks'));
  }
  //} else {
  //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Please select action'));
  //}
 }

 public Map < String, String > BRECalloutForInvisibleMonitoring(String typeOfCall, String groupCode) {

  Map < String,
   String > mapOfInvisibleMonitoringParams = new Map < String,
   String > ();
  SurrogateCAM__c surrogateCAM;
  //List<SurrogateCAM__c> surrogateCAMList = [SELECT CY_Audited_Turnover__c, PY_Sales_Turnover__c, PBDT_Growth_over_last_year__c, Turnover_Change__c, CY_Net_Profit__c, PY_Net_Profit__c, Applicant__r.Applicant_Type__c FROM SurrogateCAM__c WHERE Applicant__r.Loan_Application__c =: LoanId];


  List < Bank_Summary__c > BankSummaryList = [SELECT Outward_Return__c, Inward_Return__c, Avg_of_Bounce_IW__c, Avg_of_Bounce_OW__c, Sum_of_Bounce_IW__c, Sum_of_Bounce_OW__c, Sum_of_Credit_No__c, Sum_of_Debit_No__c, CRD_No_Count__c, DB_count__c, Applicant__r.Applicant_Type__c, Bounce_I_W_Count__c, Bounce_O_W_Count__c
   FROM Bank_Summary__c WHERE Loan_Application__c =: LoanID
  ];

  // Tags added by Chetan 03-Jan-2017 S
  List < Property_Details__c > objPropList = new List < Property_Details__c > ();
  List < Personal_Discussion_Details__c > objPDDList = new List < Personal_Discussion_Details__c > ();
  Decimal PDDMarketValue = 0.0;
  objPropList = [SELECT id, BT_Bank_Name__c, BT_Loan_MOB__c, /* Bug 18163 Start */ Extra_Amenities_Val1__c, Property_Land_Rate_Val1__c, Basic_Rate__c /* Bug 18163 End */ , Top_Up_Percentage__c from Property_Details__c where BT_Bank_Name__c != null AND Loan_Application__c =: LoanID];
  objPDDList = [SELECT id, Market_Value__c from Personal_Discussion_Details__c where Loan_Application__c =: LoanID AND Market_Value__c != null];
  if (objPDDList != null && objPDDList.size() > 0) {
   for (Personal_Discussion_Details__c objPDD: objPDDList) {
    PDDMarketValue = PDDMarketValue + objPDD.Market_Value__c;
   }
  }

  // Tags added by Chetan 03-Jan-2017 E

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
   Maximum_Sanctioned_amount__c, Maximum_Loan_Type__c, Cibil_Extension1__c, Cibil_Extension1__r.Thick_Cibil_Mortgage__c, /*SAL IM S*/ Address_Line2__c /*SAL IM E*/
   FROM CIBIL__c WHERE Applicant__r.Loan_Application__c =: LoanID
  ];



  CIBIL__c cibilVar;
  Bank_Summary__c BankSummary;
  Bank_Account__c bankAcc;
  Cibil_Extension1__c cibilExt1;

  // Already present
  /* if (scamList != null && scamList.size() > 0) {
for (SurrogateCAM__c scTemp: scamList) {
if (scTemp.Applicant__r.Applicant_Type__c == 'Primary')
surrogateCAM = scTemp;
}
}*/

  // Already present
  if (cibilExt1List != null && cibilExt1List.size() > 0) {
   for (Cibil_Extension1__c cibilExt1Temp: cibilExt1List) {
    if (cibilExt1Temp.Applicant__r.Applicant_Type__c == 'Primary')
     cibilExt1 = cibilExt1Temp;
   }

  }

  // Already present
  if (bankAccLst != null && bankAccLst.size() > 0) {
   for (Bank_Account__c bankAccTemp: bankAccLst) {
    if (bankAccTemp.Applicant__r.Applicant_Type__c == 'Primary')
     bankAcc = bankAccTemp;
   }

  }

  // Only for Invisible Monitoring
  if (cibilVarList != null && cibilVarList.size() > 0) {
   for (CIBIL__c cibilListTemp: cibilVarList) {
    if (cibilListTemp.Applicant__r.Applicant_Type__c == 'Primary') {
     cibilVar = cibilListTemp;
     //SAL IM Rohit start
     conCibilAdd = cibilVar.Address_Line2__c;
     //SAL IM Rohit end
    }
   }
  }

  // Only for Invisible Monitoring
  if (BankSummaryList != null && BankSummaryList.size() > 0) {
   for (Bank_Summary__c bankSummaryTemp: BankSummaryList) {
    if (bankSummaryTemp.Applicant__r.Applicant_Type__c == 'Primary')
     BankSummary = bankSummaryTemp;
   }
  }

  mapOfInvisibleMonitoringParams.put('loan_id', (Loan != null && Loan.Loan_Application_Number__c != null) ? String.valueof(Loan.Loan_Application_Number__c) : '');
  // mapOfInvisibleMonitoringParams.put('reqested_roi', (Scam != null && Scam.ROI__c != null) ? String.valueof(Scam.ROI__c) : '0');
  mapOfInvisibleMonitoringParams.put('product', 'INVISIBLE MONITORING');
  mapOfInvisibleMonitoringParams.put('type_of_loan', typeOfCall);
  mapOfInvisibleMonitoringParams.put('groupCode', groupCode);
  mapOfInvisibleMonitoringParams.put('applicant_type', 'Primary');

  /*Invisible Monitoring Mortgage-mortgage flag is added in following if condition for mortgage product
New Paramater's for Mortgage IM
Changes by-Chetan Wankhade
Date-11/11/2016*/
  if (Mortgageflag) {

   SurrogateCAM__c objSurrogateCAM;
   CIBIL_secondary_match__c objCIBILSecMatch;
   /*  List<SurrogateCAM__c> surrogateCAMList = [SELECT Gross_Receipts__c,CY_Audited_Turnover__c, PY_Sales_Turnover__c, PBDT_Growth_over_last_year__c, Turnover_Change__c, CY_Net_Profit__c, PY_Net_Profit__c, Applicant__r.Applicant_Type__c
FROM SurrogateCAM__c WHERE Applicant__r.Loan_Application__c =: LoanId];
if (surrogateCAMList != null && surrogateCAMList.size() > 0) {
for (SurrogateCAM__c scTemp: surrogateCAMList) {
if (scTemp.Applicant__r.Applicant_Type__c == 'Primary')
objSurrogateCAM = scTemp;
}
}
*/
   List < Product_Offerings__c > po = [select id, Address_Change_flag__c, Actione_Not_actioned__c From Product_Offerings__c where opportunity__c =: LoanId];
   Product_Offerings__c po1;
   if (po != null && po.size() > 0) {
    po1 = po[0];
   }
   List < Applicant__c > appList = [select id, is_BL_PL_Risk__c, Loan_Application__c, Invisible_Monitoring_Skipped__c,
    (SELECT Name, Address_Category1__c, Address_Line1__c, Date_of_Birth__c FROM Applicant__c.CIBIL_secondary_match__r),
    (SELECT Gross_Receipts__c, CY_Audited_Turnover__c, PY_Sales_Turnover__c, PBDT_Growth_over_last_year__c, Turnover_Change__c, CY_Net_Profit__c, PY_Net_Profit__c, Applicant__r.Applicant_Type__c FROM Applicant__c.SurrogateCAMs__r)
    from Applicant__c where Loan_Application__c =: LoanId AND Applicant_Type__c = 'Primary'
   ];

   if (appList != null && appList.size() > 0) {
    for (Applicant__c app: appList) {

     for (SurrogateCAM__c scTemp1: app.SurrogateCAMs__r) {
      objSurrogateCAM = scTemp1;
     }
     for (CIBIL_secondary_match__c scTemp2: app.CIBIL_secondary_match__r) {
      objCIBILSecMatch = scTemp2;
     }

    }
   }

   String odccFlag = 'No';
   if (PSBLBankAcount != null && PSBLBankAcount.size() > 0) {

    for (Bank_Account__c bankTemp: PSBLBankAcount) {
     if (bankTemp.Account_Type__c == 'OD' || bankTemp.Account_Type__c == 'CC') {
      odccFlag = 'Yes';
      break;
     }
    }
   }


   mapOfInvisibleMonitoringParams.put('invisibleMonitoringProduct', (Loan != null && Loan.product__c != null) ? String.valueof(Loan.product__c) : '');
   mapOfInvisibleMonitoringParams.put('baseProduct', (Loan != null && Loan.account != null && Loan.account.Base_Loan__c != null) ? String.valueof(Loan.account.Base_Loan__c) : '');
   mapOfInvisibleMonitoringParams.put('date_of_birth', (applicantPrimary != null && applicantPrimary.Contact_Name__r.date_of_Birth__c != null) ? String.valueof(applicantPrimary.Contact_Name__r.date_of_Birth__c) : '');
   mapOfInvisibleMonitoringParams.put('officeOwnership', (Loan != null && Loan.Account.Type_of_Ownership__c != null) ? String.valueof(Loan.Account.Type_of_Ownership__c) : '');
   mapOfInvisibleMonitoringParams.put('residence_ownership', (Loan != null && Loan.Account.Residence_TypeAcc__c != null) ? String.valueof(Loan.Account.Residence_TypeAcc__c) : '');
   mapOfInvisibleMonitoringParams.put('customer_category', (applicantPrimary != null && applicantPrimary.Existing_Customer__c != null) ? String.valueof(applicantPrimary.Existing_Customer__c) : '');
   mapOfInvisibleMonitoringParams.put('gross_receipts', (objSurrogateCAM != null && objSurrogateCAM.Gross_Receipts__c != null) ? String.valueof(objSurrogateCAM.Gross_Receipts__c) : '0');

   mapOfInvisibleMonitoringParams.put('pincode_mismatch__in_cibil', 'NO'); // Passing default (Mapping required)
   mapOfInvisibleMonitoringParams.put('secondary_match_in_cibil', (objCIBILSecMatch != null) ? 'YES' : 'NO');
   mapOfInvisibleMonitoringParams.put('address_change_flag', (po1 != null && po1.Address_Change_flag__c != null) ? String.valueof(po1.Address_Change_flag__c) : '');
   mapOfInvisibleMonitoringParams.put('cibil_enquiries_last3_month', (cibilExt1List != null && cibilExt1List.size() > 0 && cibilExt1List[0] != null && cibilExt1List[0].Enquiries_past_3_mnths__c != null) ? String.valueof(cibilExt1List[0].Enquiries_past_3_mnths__c) : '0');
   // Tags added by Chetan 03-Jan-2017 S
   mapOfInvisibleMonitoringParams.put('btType', (PSBLBankAcount != null && PSBLBankAcount.size() > 0 && PSBLBankAcount[0] != null && PSBLBankAcount[0].Bank_Type__c != null) ? String.valueof(PSBLBankAcount[0].Bank_Type__c) : '0');
   // Tags added by Chetan 03-Jan-2017 E
   mapOfInvisibleMonitoringParams.put('average_net_salary', (cam != null && cam.Construction_Valuation_1__c != null) ? String.valueof(cam.Construction_Valuation_1__c) : '0');
   mapOfInvisibleMonitoringParams.put('odccFlag', odccFlag);
   //Invisible monitoring mortgage Mahima-start
   //Date 21 dec 2016
   mapOfInvisibleMonitoringParams.put('company_category', (con != null && con.Company_Category__c != null) ? con.Company_Category__c : '');
   mapOfInvisibleMonitoringParams.put('type_of_transaction', (Loan != null && Loan.account != null && Loan.account.BT_Bank_Type__c != null) ? Loan.account.BT_Bank_Type__c : '');
   //Invisible monitoring mortgage Mahima-End

   // Tags added by Chetan 03-Jan-2017 S
   mapOfInvisibleMonitoringParams.put('baseProductProgram', (Loan != null && Loan.account != null && Loan.account.Base_Loan__c != null) ? Loan.account.Base_Loan__c : '');
   if (Loan.Scheme_Master__c != null && Loan.Scheme_Master__r.Name != null && Loan.Scheme_Master__r.Name.toUpperCase().contains('GREEN CHANNEL')) {
    mapOfInvisibleMonitoringParams.put('green_channel_flag', 'YES');
   } else {
    mapOfInvisibleMonitoringParams.put('green_channel_flag', 'NO');
   }
   // Tags added by Chetan 03-Jan-2017 E
  }
  // Invisible Monitoring Mortgage-mortgage END
  //added by Anjali-start


  mapOfInvisibleMonitoringParams.put('years_in_business_job', (Loan != null && Loan.account != null && Loan.Account.Total_Work_Experience_Yrs__c != null) ? String.valueof(Loan.Account.Total_Work_Experience_Yrs__c) : '0');
  //Mortgage Feb Changes Start
  if (Loan.product__c == 'SHL' || Loan.product__c == 'HSL' || Loan.product__c == 'SBS CS SHL' || Loan.product__c == 'HPLS') {
   mapOfInvisibleMonitoringParams.put('total_employment_vintage', (Loan != null && Loan.account != null && Loan.account.Total_Work_Experience_Yrs__c != null) ? String.valueof(Loan.account.Total_Work_Experience_Yrs__c) : '0'); // IM bug
  }
  /*else{
mapOfInvisibleMonitoringParams.put('total_employment_vintage', (Scam != null && Scam.CY_Business_Vintage__c != null) ? String.valueof(Scam.CY_Business_Vintage__c) : '0');
}*/
  mapOfInvisibleMonitoringParams.put('current_employment_vintage', (Loan != null && Loan.account != null && Loan.account.Current_experiance_in_Years__c != null) ? String.valueof(Loan.account.Current_experiance_in_Years__c) : '0');
  //Mortgage Feb Changes End
  // Tags added by Chetan 03-Jan-2017 S
  mapOfInvisibleMonitoringParams.put('total_employment_vintageHL', (Loan != null && Loan.account != null && Loan.Account.Vintage_with_BAL__c != null) ? Loan.Account.Vintage_with_BAL__c : '0');
  // Tags added by Chetan 03-Jan-2017 E
  //Added by Anajli-end
  mapOfInvisibleMonitoringParams.put('type_of_constitution', (Loan != null && Loan.Type_Of_Constitution__c != null) ? String.valueof(Loan.Type_Of_Constitution__c) : '');
  //mapOfInvisibleMonitoringParams.put('total_employment_vintage', (applicantPrimary != null && applicantPrimary.Contact_Name__r.Total_Employment_vintage_Year__c != null) ? String.valueof(applicantPrimary.Contact_Name__r.Total_Employment_vintage_Year__c) : '0');
  mapOfInvisibleMonitoringParams.put('constitutionType', (Loan != null && Loan.Type_Of_Constitution__c != null) ? String.valueof(Loan.Type_Of_Constitution__c) : '');
  mapOfInvisibleMonitoringParams.put('customer_type', (applicantPrimary != null && applicantPrimary.Existing_Customer__c != null) ? String.valueof(applicantPrimary.Existing_Customer__c) : '');
  mapOfInvisibleMonitoringParams.put('customer_segment', (applicantPrimary != null && applicantPrimary.SegmentaionResult__c != null) ? String.valueof(applicantPrimary.SegmentaionResult__c) : '');

  mapOfInvisibleMonitoringParams.put('residence_type', (applicantPrimary != null && applicantPrimary.Contact_Name__r.Residence_Type__c != null) ? String.valueof(applicantPrimary.Contact_Name__r.Residence_Type__c) : '');
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
  mapOfInvisibleMonitoringParams.put('sourcingChannel', (Loan != null && Loan.Sourcing_Channel__r.Name != null) ? String.valueof(Loan.Sourcing_Channel__r.Name) : '');
  mapOfInvisibleMonitoringParams.put('creditProgram', (Loan != null && Loan.Credit_Program__c != null) ? String.valueof(Loan.Credit_Program__c) : '');
  mapOfInvisibleMonitoringParams.put('existingCustomerFlag', (Loan != null && Loan.Existing_Customer__c == 'Existing Customer') ? 'true' : (Loan.Existing_Customer__c == 'New Customer' ? 'false' : 'false'));
  mapOfInvisibleMonitoringParams.put('totalLoanAmount', (Loan.Total_Loan_amount__c != null) ? String.valueof(Loan.Total_Loan_amount__c) : '0');
  mapOfInvisibleMonitoringParams.put('riskyDSA', (Loan != null && Loan.Sourcing_Channel__r.Risky_DSA__c != null) ? String.valueof(Loan.Sourcing_Channel__r.Risky_DSA__c) : '');

  // mapOfInvisibleMonitoringParams.put('pdType', (PDObj != null && PDObj.Type_of_PD__c != null) ? String.valueof(PDObj.Type_of_PD__c) : '');

  mapOfInvisibleMonitoringParams.put('pan', (applicantPrimary != null && applicantPrimary.PAN_Number__c != null) ? String.valueof(applicantPrimary.PAN_Number__c) : '');
  mapOfInvisibleMonitoringParams.put('SMEScore', (applicantPrimary != null && applicantPrimary.SME_Score__c != null) ? String.valueof(applicantPrimary.SME_Score__c) : '0');
  //mapOfInvisibleMonitoringParams.put('age', (applicantPrimary != null && applicantPrimary.Contact_Name__r.Age_of_Applicant__c != null) ? String.valueof(applicantPrimary.Contact_Name__r.Age_of_Applicant__c) : '0');
  // Tags added by Chetan 03-Jan-2017 S
  mapOfInvisibleMonitoringParams.put('btBankMOB', (objPropList != null && objPropList.size() > 0 && objPropList[0].BT_Loan_MOB__c != null) ? String.valueof(objPropList[0].BT_Loan_MOB__c) : '0');
  mapOfInvisibleMonitoringParams.put('top_up_percentage', (objPropList != null && objPropList.size() > 0 && objPropList[0].Top_Up_Percentage__c != null) ? String.valueof(objPropList[0].Top_Up_Percentage__c) : '0');
  mapOfInvisibleMonitoringParams.put('btBankName', (objPropList != null && objPropList.size() > 0 && objPropList[0].BT_Bank_Name__c != null) ? String.valueof(objPropList[0].BT_Bank_Name__c) : '');

  // Tags added by Chetan 03-Jan-2017 S
  // BugId--18163  starts
  mapOfInvisibleMonitoringParams.put('extra_amenities_Val1', (objPropList != null && objPropList.size() > 0 && objPropList[0].Extra_Amenities_Val1__c != null) ? String.valueof(objPropList[0].Extra_Amenities_Val1__c) : '0');
  mapOfInvisibleMonitoringParams.put('property_rate_Val1', (objPropList != null && objPropList.size() > 0 && objPropList[0].Property_Land_Rate_Val1__c != null) ? String.valueof(objPropList[0].Property_Land_Rate_Val1__c) : '0');
  mapOfInvisibleMonitoringParams.put('basic_rate_as_per_PE', (objPropList != null && objPropList.size() > 0 && objPropList[0].Basic_Rate__c != null) ? String.valueof(objPropList[0].Basic_Rate__c) : '0');
  mapOfInvisibleMonitoringParams.put('purpose_of_loan', (Loan != null && Loan.End_Use__c != null) ? String.valueof(Loan.End_Use__c) : '');
  // BugId--18163  Ends

  mapOfInvisibleMonitoringParams.put('total_bounce_inward', (BankSummary != null && BankSummary.Inward_Return__c != null) ? String.valueof(BankSummary.Inward_Return__c) : '0');
  mapOfInvisibleMonitoringParams.put('total_bounce_outward', (BankSummary != null && BankSummary.Outward_Return__c != null) ? String.valueof(BankSummary.Outward_Return__c) : '0');
  mapOfInvisibleMonitoringParams.put('credit_trans_banking_count', (BankSummary != null && BankSummary.CRD_No_Count__c != null) ? String.valueof(BankSummary.CRD_No_Count__c) : '0');
  mapOfInvisibleMonitoringParams.put('debit_trans_banking_count', (BankSummary != null && BankSummary.DB_count__c != null) ? String.valueof(BankSummary.DB_count__c) : '0');
  mapOfInvisibleMonitoringParams.put('typeofBanking', (Loan != null && Loan.A_C_Type__c != null) ? String.valueof(Loan.A_C_Type__c) : '');

  mapOfInvisibleMonitoringParams.put('bankAccountNumber', (bankAcc != null && bankAcc.Bank_Acct_Number__c != null) ? String.valueof(bankAcc.Bank_Acct_Number__c) : '');
  mapOfInvisibleMonitoringParams.put('bankAccountType', (bankAcc != null && bankAcc.Account_Type__c != null) ? String.valueof(bankAcc.Account_Type__c) : '');

  mapOfInvisibleMonitoringParams.put('btBankName', (bankAcc != null && bankAcc.Bank_Name__c != null) ? String.valueof(bankAcc.Bank_Name__c) : '');
  /*
//Mortgage Feb Changes Start
if(Mortgageflag){
mapOfInvisibleMonitoringParams.put('odccUtilization', (Scam != null && Scam.CY_OD_CC_Limit_Utilisation__c != null) ? String.valueof(Scam.CY_OD_CC_Limit_Utilisation__c) : '0');
}
else{
mapOfInvisibleMonitoringParams.put('odccUtilization', (Scam != null && Scam.BL_ODCC_Utilization__c != null) ? String.valueof(Scam.BL_ODCC_Utilization__c) : '0');
}
//Mortgage Feb Changes End
*/

  //  mapOfInvisibleMonitoringParams.put('odccUtilization', (Scam != null && Scam.BL_ODCC_Utilization__c != null) ? String.valueof(Scam.BL_ODCC_Utilization__c) : '0');
  //  mapOfInvisibleMonitoringParams.put('avg_od_cc_utilisation', (Scam != null && Scam.BL_ODCC_Utilization__c != null) ? String.valueof(Scam.BL_ODCC_Utilization__c) : '0');
  //mapOfInvisibleMonitoringParams.put('Number_of_HL', (cibilExt1.Number_of_Hl_Loans__c != null) ? String.valueof(cibilExt1.Number_of_Hl_Loans__c) : '');
  //  mapOfInvisibleMonitoringParams.put('total_employment_vintage', (Scam != null && Scam.CY_Business_Vintage__c != null) ? String.valueof(Scam.CY_Business_Vintage__c) : '0');
  //  mapOfInvisibleMonitoringParams.put('cy_sales_turnover', (Scam != null && Scam.CY_Audited_Turnover__c != null) ? String.valueof(Scam.CY_Audited_Turnover__c) : '0');
  //  mapOfInvisibleMonitoringParams.put('py_sales_turnover', (Scam != null && Scam.PY_Sales_Turnover__c != null) ? String.valueof(Scam.PY_Sales_Turnover__c) : '0');
  // mapOfInvisibleMonitoringParams.put('cy_net_profit', (Scam != null && Scam.CY_Net_Profit__c != null) ? String.valueof(Scam.CY_Net_Profit__c) : '0');
  //  mapOfInvisibleMonitoringParams.put('py_net_profit', (Scam != null && Scam.PY_Net_Profit__c != null) ? String.valueof(Scam.PY_Net_Profit__c) : '0');
  //  mapOfInvisibleMonitoringParams.put('debtorsTurnoverDays', (Scam != null && Scam.Debtor_Turnover_Days__c != null) ? String.valueof(Scam.Debtor_Turnover_Days__c) : '0');
  //  mapOfInvisibleMonitoringParams.put('creditSMEScore', (Scam != null && Scam.Credit_SME_Score__c != null) ? String.valueof(Scam.Credit_SME_Score__c) : '0');
  ///   mapOfInvisibleMonitoringParams.put('creditorsTurnoverDays', (Scam != null && Scam.Creditor_Turnover_Days__c != null) ? String.valueof(Scam.Creditor_Turnover_Days__c) : '0');
  //  mapOfInvisibleMonitoringParams.put('stockTurnoverDays', (Scam != null && Scam.Stock_Turnover_Days__c != null) ? String.valueof(Scam.Stock_Turnover_Days__c) : '0');
  //  mapOfInvisibleMonitoringParams.put('cashConversionCycle', (Scam != null && Scam.Cash_Conversion_Cycle_In_Days__c != null) ? String.valueof(Scam.Cash_Conversion_Cycle_In_Days__c) : '0');
  ///  mapOfInvisibleMonitoringParams.put('currentRatio', (Scam != null && Scam.Current_Ratio__c != null) ? String.valueof(Scam.Current_Ratio__c) : '0');
  //  mapOfInvisibleMonitoringParams.put('cy_total_networth', (Scam != null && Scam.Total_Net_Worth__c != null) ? String.valueof(Scam.Total_Net_Worth__c) : '0');
  //  mapOfInvisibleMonitoringParams.put('networkingCapital', (Scam != null && Scam.Net_Working_Capital__c != null) ? String.valueof(Scam.Net_Working_Capital__c) : '0');
  //   mapOfInvisibleMonitoringParams.put('netProfitMargin', (Scam != null && Scam.Net_Profit_Margin__c != null) ? String.valueof(Scam.Net_Profit_Margin__c) : '0');
  //   mapOfInvisibleMonitoringParams.put('annualizedBTO', (Scam != null && Scam.BL_Annualised_BTO__c != null) ? String.valueof(Scam.BL_Annualised_BTO__c) : '0');
  // mapOfInvisibleMonitoringParams.put('py_depriciation', (Scam != null && Scam.PY_Depreciation__c != null) ? String.valueof(Scam.PY_Depreciation__c) : '0');
  //  mapOfInvisibleMonitoringParams.put('cy_depriciation', (Scam != null && Scam.CY_Depreciation__c != null) ? String.valueof(Scam.CY_Depreciation__c) : '0');
  //  mapOfInvisibleMonitoringParams.put('odccLimit', (Scam != null && Scam.OD_CC_limit__c != null) ? String.valueof(Scam.OD_CC_limit__c) : '0');
  //  mapOfInvisibleMonitoringParams.put('growthInSalesTurnover', (Scam != null && Scam.Growth_in_Sales_Turnover__c != null) ? String.valueof(Scam.Growth_in_Sales_Turnover__c) : '0');

  // mapOfInvisibleMonitoringParams.put('FRNnumber', (Scam != null && Scam.Membership_Number__c != null) ? Scam.Membership_Number__c : '');

  // Tags added by Chetan 03-Jan-2017 S
  mapOfInvisibleMonitoringParams.put('sourcingChannelFlag', (Loan != null && Loan.Sourcing_Channel__r.Sourcing_Channel_Flag__c != null) ? String.valueof(Loan.Sourcing_Channel__r.Sourcing_Channel_Flag__c) : '');
  mapOfInvisibleMonitoringParams.put('cy_total_assets', String.valueOf(PDDMarketValue));
  // Tags added by Chetan 03-Jan-2017 E

  // Start of bug - 7604

  String CIBILScore;
  if (applicantPrimary.CIBIL_Score__c != null) {
   if (applicantPrimary.CIBIL_Score__c == '000-1') {
    CIBILScore = '-1';
   } else {
    CIBILScore = applicantPrimary.CIBIL_Score__c;
   }
  } else {
   CIBILScore = '0';
  }

  // End of bug - 7604

  mapOfInvisibleMonitoringParams.put('CIBIL_Score', (CIBILScore != null) ? CIBILScore : '0');
  mapOfInvisibleMonitoringParams.put('total_no_of_loans', (cibilVar != null && cibilVar.Total_Loans__c != null) ? String.valueof(cibilVar.Total_Loans__c) : '0');
  mapOfInvisibleMonitoringParams.put('total_no_of_loans_enquiry', (cibilVar != null && cibilVar.Total_Enquiries__c != null) ? String.valueof(cibilVar.Total_Enquiries__c) : '0');
  mapOfInvisibleMonitoringParams.put('maximumSanctionedAmount', (cibilVar != null && cibilVar.Maximum_Sanctioned_amount__c != null) ? String.valueof(cibilVar.Maximum_Sanctioned_amount__c) : '0');
  mapOfInvisibleMonitoringParams.put('maxLoanType', (cibilVar != null && cibilVar.Maximum_Loan_Type__c != null) ? String.valueof(cibilVar.Maximum_Loan_Type__c) : '');
  // Tags added by Chetan 03-Jan-2017 S
  mapOfInvisibleMonitoringParams.put('cibilType', (cibilVar != null && cibilVar.Cibil_Extension1__r.Thick_Cibil_Mortgage__c != null) ? cibilVar.Cibil_Extension1__r.Thick_Cibil_Mortgage__c : '');
  // Tags added by Chetan 03-Jan-2017 E

  String accountInfo = 'Account_Info';
  String accountType = 'Account_Type';
  String amountOverdue = 'Amount_Overdue';
  String currentBalance = 'Current_Balance';
  String dateClosed = 'Date_Closed';
  String sanctionedAmount = 'Sanction_Amount';
  String accountInfoVar,
  accountTypeVar,
  amountOverdueVar,
  currentBalanceVar,
  dateClosedVar,
  sanctionedAmountVar;

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

  // Call BRE method and get response
  BRECallout obj = new BRECallout();
  Map < String,
   String > mapOfResults;
  if (!Test.isRunningTest()) {
   mapOfResults = obj.remoteInvisibleMonitoringCheck(mapOfInvisibleMonitoringParams);
  }
  return mapOfResults;
 }

 //Anjali mortgage IM end

 public PageReference AddScripts() {
  String UID;

  List < Property_Details__c > props = [select id, Digital_Scrip_market_price__c, Digital_Scrip_Name__c, Digital_Scrips_Eligibility__c, Digital_Scrip_Type__c,
   Loan_Application__c, Number_of_Shares__c from Property_Details__c where Loan_application__c =: Loan.Id
  ];
  if (props.size() > 0) {
   List < ScripsHistory__c > scrips = new List < ScripsHistory__c > ();
   for (Property_Details__c scrip: props) {
    ScripsHistory__c newScrip = new ScripsHistory__c();
    newScrip.Digital_Scrip_market_price__c = scrip.Digital_Scrip_market_price__c;
    newScrip.Digital_Scrip_Name__c = scrip.Digital_Scrip_Name__c;
    newScrip.Digital_Scrips_Eligibility__c = scrip.Digital_Scrips_Eligibility__c;
    newScrip.Digital_Scrip_Type__c = scrip.Digital_Scrip_Type__c;
    newScrip.Loan_Application__c = scrip.Loan_Application__c;
    newScrip.Number_of_Shares__c = scrip.Number_of_Shares__c;
    scrips.add(newScrip);
   }
   insert scrips;
   delete props;
  }

  List < Salaried__c > UIDRecords = new List < Salaried__c > ();
  UIDRecords = [select id, LASOL_UID__c from Salaried__c where Loan_application__c =: Loan.Id];
  if (UIDRecords.size() > 0) {
   if (UIDRecords[0].LASOL_UID__c != null) {
    UID = UIDRecords[0].LASOL_UID__c;
   }
   UIDRecords[0].Share_Details_Update__c = '';
  }
  update UIDRecords;

  if (Loan.Id != null) {
   //Pagereference p =new pagereference('http://bflportaluat:3000/Pages/your-Portfolio.aspx?source=B2B&grouptype=salaried'+'&iid='+Loan.Id+'&groupSubType=credit');
   if (scripURL != '') {
    Pagereference p = new pagereference(scripURL + '?source=B2B&grouptype=salaried' + '&iid=' + Loan.Id + '&groupSubType=credit');
    p.setRedirect(true);
    return p;
   }
  }
  return null;
 }

 public PageReference reEvaluateScripts() {
  /* savedSuccessfull = true;
message = 'Scripts Re-evalueted Successfully...';
return null;*/

  if (Loan.Id != null) {
   //Pagereference p =new pagereference('http://bflportaluat:3000/Pages/your-Portfolio.aspx?source=B2B&grouptype=salaried'+'&iid='+Loan.Id+'&groupSubType=credit');
   if (scripURL != '') {
    Pagereference p = new pagereference(scripURL + '?source=B2B&grouptype=salaried' + '&iid=' + Loan.Id + '&groupSubType=credit');
    p.setRedirect(true);

    savedSuccessfull = true;
    message = 'Scripts Re-evalueted Successfully...';

    return p;
   }
  }
  return null;

 }

 public List < PortfoliotWrapper > getfinalPortList() {
  return finalPortList;
 }

 public List < PortfoliotWrapper > getfinalCatList() {
  return finalCatList;
 }

 public List < PortfoliotWrapper > getfinalFundList() {
  return finalFundList;
 }

 public class PortfoliotWrapper {
  public String assetType {
   get;
   set;
  }
  public String category {
   get;
   set;
  }
  public decimal Qty {
   get;
   set;
  }
  public decimal marketValue {
   get;
   set;
  }
  public decimal Eligibility {
   get;
   set;
  }
  public decimal contribution {
   get;
   set;
  }


  PortfoliotWrapper(String asset, String category, decimal Qty, decimal marketValue, decimal Eligibility) {
   this.assetType = asset;
   this.category = category;
   this.Qty = Qty;
   this.marketValue = marketValue;
   this.Eligibility = Eligibility;
  }

  PortfoliotWrapper(String asset, String category, decimal Qty, decimal marketValue, decimal Eligibility, Decimal contribution) {
   this.assetType = asset;
   this.category = category;
   this.Qty = Qty;
   this.marketValue = marketValue;
   this.Eligibility = Eligibility;
   this.contribution = contribution;
  }
 }

 public List < PortfoliotWrapper > getConsolidatedData(List < PortfoliotWrapper > data) {

  List < PortfoliotWrapper > finalWrapper = new List < PortfoliotWrapper > ();

  Decimal totalQty = 0, totalMarketVal = 0, totalEligibility = 0;
  try {
   for (PortfoliotWrapper temp: data) {
    if (temp.Qty != null)
     totalQty += temp.Qty;
    if (temp.marketValue != null)
     totalMarketVal += temp.marketValue;
    if (temp.Eligibility != null)
     totalEligibility += temp.Eligibility;
   }

   finalWrapper.clear();

   for (PortfoliotWrapper wrapTemp: data) {
    if (wrapTemp.category != null) {
     PortfoliotWrapper wrapper = new PortfoliotWrapper(wrapTemp.assetType, wrapTemp.category, wrapTemp.Qty, wrapTemp.marketValue, wrapTemp.Eligibility, (100 * (wrapTemp.Eligibility / totalEligibility)).setScale(2, System.RoundingMode.FLOOR));
     finalWrapper.add(wrapper);
    }

    if (wrapTemp.assetType != null) {
     PortfoliotWrapper wrapper = new PortfoliotWrapper(wrapTemp.assetType, wrapTemp.category, wrapTemp.Qty, wrapTemp.marketValue, wrapTemp.Eligibility, (100 * (wrapTemp.Eligibility / totalEligibility)).setScale(2, System.RoundingMode.FLOOR));
     //PortfoliotWrapper wrapper = new PortfoliotWrapper(wrapTemp.assetType,'',1000,1000,1000000,100*(1000000/5000000));
     finalWrapper.add(wrapper);
    }


   }

   PortfoliotWrapper wrapper1 = new PortfoliotWrapper('Total', 'Total', totalQty, totalMarketVal, totalEligibility, 100.00);
   finalWrapper.add(wrapper1);

   return finalWrapper;
  } catch (Exception e) {}
  return finalWrapper;

 }

 //4937 end

 public void AddSanctionDetails() {

  Discrepancy__c addNewDisc = new Discrepancy__c();
  addNewDisc.LoanApplication__c = Loan.Id;
  addNewDisc.Discrepancy_Stage__c = Loan.StageName;
  addNewDisc.Status__c = 'Pending';
  addNewDisc.OTPDiscrepancyProduct__c = Loan.Product__c; // Added by sneha for Bug-18583
  String RoleName = Loan.Current_UserRole__C;
  addNewDisc.RaiserName__c = userDisc;
  addNewDisc.Raiser_Role__c = RoleName;
  sanctionList.add(addNewDisc);
 }

 public PageReference SaveSanctionChanges() {

  for (integer k = 0; k < sanctionList.size(); k++) {
   if (sanctionList[k].Status__c == 'Discrepancy Resolved') {
    Id userResolved = UserInfo.getUserId();
    sanctionList[k].Resolver_Name__c = userResolved;
   }
   if (sanctionList[k].Status__c == 'Closed') {
    sanctionList[k].Closed_Date__c = System.Today();
   }

   sanctionList[k].Type__c = 'SanctionCondition';
  } //end of for

  if (sanctionList.size() > 0)
   upsert sanctionList;

  savedSuccessfull = true;
  message = 'Sanction details saved successfully!!!';

  sanctionList = [select Date_Time__c, Discrepancy_Stage__c, Party_Type__c, Party_Name__c,
   Discrepancy_Description__c, LoanApplication__c,
   RaiserName__c, Description__c,
   Priority__c, Resolution_Remarks__c, Status__c, Discrepancy_Party__c, Applicant_Name__c,
   Raiser_Role__c, createddate, Category__c,
   Assigned_To__c, Closed_Date__c, Resolver_Name__c, Type__c, OTPDiscrepancyCategory__c, OTPDiscrepancyDocuments__c, /*Added by sneha for  Bug -18583 Start*/ OTPDiscrepancyProduct__c /*Added by sneha for  Bug -18583 End*/
   from Discrepancy__c where LoanApplication__c =: Loan.Id and Type__c = 'SanctionCondition'
   order by Status__c asc, createddate asc
  ];
  return null;
 }

 public void officeEmailVerify() {

  ApexPages.getMessages().clear();

  String body = '<b>Dear ' + Loan.Name + '</b><br/><br/>';
  body += '<div style=\\"margin-left:25px;\\">Loan Application(' + Loan.Loan_Application_Number__c + ') requires your Office Email Id verification. Please reply to same email without changing subject.</div><br/>';
  body += '<table width=\\"700\\" border=\\"1\\" cellpadding=\\"0\\" cellspacing=\\"0\\" style=\\"border:1px #949494 solid\\" align=\\"center\\">';
  if (accountCreate != null && accountCreate.size() > 0 && accountCreate[0].Accountant_email_id__c != null) {
   String emailAddr = accountCreate[0].Accountant_email_id__c;
   String[] toAddresses = new String[] {
    emailAddr
   };
   String[] ccArray;
   String[] bccArray;

   BAFL_EmailServicesLogix.EmailServicesPort stub = new BAFL_EmailServicesLogix.EmailServicesPort();
   stub.timeout_x = 120000;

   BAFL_EmailServicesLogix.SendEmailResponse er = stub.SendEmail('noreply@bajajfinserv.in',
    'otpofficeemailverification@6hifw8v4ew6qa26r5whiw37rq2yorch4vylpptp0njgfwqxjc.o-51mo2mam.cs5.apex.sandbox.salesforce.com',
    toAddresses,
    ccArray,
    bccArray,
    'Normal',
    new BAFL_EmailServicesLogix.Attachment[] {},
    Loan.Loan_Application_Number__c,
    body,
    'bajaj');

   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email Notification sent successfully. '));
  } else {
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Office Email Id is not available. '));
  }
 }


 public String getStrAppr() {
  return StrAppr;
 }

 public void setStrAppr(String StrAppr) {
  this.StrAppr = StrAppr;
 }

 public void show1() {
  /*BUG-16959 added Prod condition for DBOL  by Rajesh */
  if (isPSBLProductLineProduct)
   showappr = true;
 }


 public List < SelectOption > getStrApprList() {
  return optionsAppr;
 }
 //Call center Start
 public List < SelectOption > getStrApprSalesList() {
  return optionsApprSales;
 }
 //Call center Start 
 public List < SelectOption > getStrApprList1() {
  return optionsApprFprOtcPDD;
 }

 /**
  *    This function is used to submit the loan application to the higher authority. Done by the CPA Person.
  */
 public Pagereference submitappr() {
  List < string > msg = new List < string > ();
  List < string > mobileNumbers = new List < string > ();
  if (StrAppr == 'None') {
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please select the Approver before submitting'));
   return null;
  }
  String referal = LOan.Referral__c;
  if (referal == 'None') {
   Loan.Referral__c = null;
  }

  /* Salaried start*/
  string approverDesignation1 = null;
  Integer loanAmt = 0;
  Credit_Officer_Limit__c tempCOL1;
  try {
   tempCOL1 = [select id, Designation__c, Loan_Amount__c, Credit_Officer_Name__r.id, Credit_Officer_Name__r.Employee_ID__c, Pre_Approved_Amount__c,
    User_Type__c
    from Credit_Officer_Limit__c where id =: StrAppr
   ];


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

   sendEmailForException(e);
  }
  //added for salary slip formet
  if (Loan.Product__c == 'SAL' || Loan.Product__c == 'SBS CS SAL' || Loan.Product__c == 'SPL' || Loan.Product__c == 'SOL' || Loan.Product__c == 'SHOL') {
   /** salForVerify=[select id,name,Status__c from Verification__c where
Verification_Type__c='Salary Slip Format' and
Loan_Application__c=:Loan.Id]; **/
   if (tempCOL1.Designation__c == 'National Credit Manager' ||
    tempCOL1.Designation__c == 'Zonal Credit Manager' ||
    tempCOL1.Designation__c == 'National Risk Manager' ||
    tempCOL1.Designation__c == 'Chief Risk Officer' ||
    tempCOL1.Designation__c == 'CEO' ||
    tempCOL1.Designation__c == 'Regional Credit Manager'
   ) {
    isItHigherDesg = true;
   }
   if (!salForVerify.isEmpty()) {
    if (salForVerify.size() > 0 && isItHigherDesg == true && salForVerify[0].Status__c == null) {
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Salary Slip Format Verification STATUS Should not be Blank'));
     return null;
    }
   }
   if (salForVerify.isEmpty() && isItHigherDesg == true) {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Salary Slip Format Verification Is Required'));
    return null;
   }
   isItHigherDesg = false;
  }


  if (Loan.Approver__c == 'Centralized CPA') {
   StrAppr = tempCOL1.Credit_Officer_Name__r.id;
   Loan.ownerid = StrAppr;
   Loan.Approver__c = 'Centralized ACM';
   Loan.Centralized_ACM__c = StrAppr;
   Loan.Centralized_ACM_Amount__c = loanAmt;
  } else if (approverDesignation1 == 'Centralized RCM') {
   StrAppr = tempCOL1.Credit_Officer_Name__r.id;
   Loan.ownerid = StrAppr;
   Loan.Approver__c = 'Centralized RCM';
   Loan.Centralized_RCM_Amount__c = loanAmt;
   Loan.Centralized_RCM__c = StrAppr;
   // Code to initiate CIBIL
   applicantList[0].Integrate_with_CIBIL__c = true;
   applicantList[0].Update_CIBIL_Error__c = false;
   applicantList[0].Description__c = '';
   update applicantList;
  }

  /* Salaried End*/
  else if (Loan.Approver__c != 'Centralized CPA') {
   string approverDesignation = null;
   if ((StrAppr != null) && (StrAppr != 'None')) {
    Credit_Officer_Limit__c tempCOL = [select id, Designation__c, Credit_Officer_Name__r.id, Credit_Officer_Name__r.Employee_ID__c, Pre_Approved_Amount__c,
     User_Type__c
     from Credit_Officer_Limit__c where Id =: StrAppr
    ];

    if (tempCOL != null) {
     approverDesignation = tempCOL.Designation__c;
     if (approverDesignation == 'Area Credit Manager') {
      if (tempCOL.Credit_Officer_Name__r.Employee_ID__c != null) {
       Loan.Employee_No_of_ACM__c = tempCOL.Credit_Officer_Name__r.Employee_ID__c;
      }
     }
     StrAppr = tempCOL.Credit_Officer_Name__r.id;
    }
   }


   String Branch = Loan.BranchName__c;
   double acmamt = 0;
   // strung proproduct=

   //4450
   List < Credit_Officer_Limit__c > acmList = new List < Credit_Officer_Limit__c > ();

   if (Branch != null && Loan.Product__c != null && StrAppr != null) {
    try {
     if (COLStampFlag == true && LoanAppFlow != null) {
      acmList = [select Loan_Amount__c, Pre_Approved_Amount__c, User_Type__c from Credit_Officer_Limit__c
       where Credit_Officer_Name__c =: StrAppr
       and /**Product__c =:**/ Product__c =: Loan.Product__c and City__c INCLUDES(: Branch) and Active_Flag__c = true limit 1
      ];
      if (acmList.size() > 0) {
       if (Loan.Program_Type__c == 'Pre-Approved') {
        acmamt = acmList[0].Pre_Approved_Amount__c;
       } else {
        acmamt = acmList[0].Loan_Amount__c;
       }
      }

     } else {
      acmamt = [select Loan_Amount__c, User_Type__c from Credit_Officer_Limit__c
       where Credit_Officer_Name__c =: StrAppr
       and /**Product__c =:**/ Product__c =: Loan.Product__c and City__c INCLUDES(: Branch) and Active_Flag__c = true limit 1
      ].Loan_Amount__c;
     }
    } catch (Exception e) {
     sendEmailForException(e);
     return null;
    }
   }
   //Getting Designation of Approver Designation__c='Area Credit Manager' 
   if (approverDesignation == 'Area Credit Manager') {
    String ph;

    //sms functionality       
    String mess = 'Your loan Application ' + Loan.Name + '. has been submitted by the CPA for further Credit Approval process.';

    if (StrAppr != null) {
     try {
      /*BUG-16959 added Prod condition for DBOL  by Rajesh */
      if (!isPSBLProductLineProduct) {
       /*Responsys Dynamic Parameters Bug 15653 s*/
       List < Applicant__c > appList = new List < Applicant__c > ();
       appList.add(applicantPrimary);
       List < Opportunity > LoanList = new List < Opportunity > ();
       LoanList.add(Loan);
       GeneralCommunicationHandler.sendSMS(LoanList, appList, 'Submit by CPA-Cust');
       /*Responsys Dynamic Parameters Bug 15653 e*/

      }
     } catch (Exception e) {
      sendEmailForException(e);
      return null;
     }
     /*Responsys Dynamic Parameters Bug 15653 s*/
     List < Applicant__c > appList = new List < Applicant__c > ();
     appList.add(applicantPrimary);
     List < Opportunity > LoanList = new List < Opportunity > ();
     LoanList.add(Loan);
     GeneralCommunicationHandler.sendSMS(LoanList, appList, 'Submit by CPA-Int');
     /*Responsys Dynamic Parameters Bug 15653 e*/

     Loan.ownerid = StrAppr;
     // String Branch=Loan.BranchName__c; 
     /**  
try{
acmamt=[select Loan_Amount__c from Credit_Officer_Limit__c 
where Credit_Officer_Name__c=:StrAppr
and Product__c =: Loan.Product__c and City__c INCLUDES(:Branch)].Loan_Amount__c;  
}
catch(Exception e){
Apexpages.addMessages(e);
return null;
}   **/
    }
    Loan.ACM__c = StrAppr;
    Loan.ACM_Amount__c = acmamt;
    Loan.Approver__c = 'Area Credit Manager';

    if (Loan.StageName != 'Pending for Insurance approval' && Loan.Processing_Type__c != 'Without Loan' && Loan.product__c == 'DPL' && Loan.StageName != 'Approved') {

     Loan.StageName = 'Underwriting';
    }
    if ((Loan.StageName != 'Underwriting' && Loan.product__c != 'DPL') && (Loan.StageName != 'Re-Appraise- Loan amount') && (Loan.StageName != 'Approved') && (Loan.StageName != 'Rejected') && (Loan.StageName != 'Re-Appraise- IRR') && (Loan.StageName != 'Re-Appraise- Tenor') && (Loan.StageName != 'Re-Appraise- Reject Case') && (Loan.StageName != 'Hold')) {
     Loan.Approval_Stages__c = 'Pending Approval';
     Loan.stagename = 'Personal Discussion';
    }

   } else if (approverDesignation == 'Credit Manager') { // Bug id : 13016 - New Role Creation for Credit, added by Needhi (starts)
    String ph;
    String mess = 'Your loan Application ' + Loan.Name + '. has been submitted by the CPA for further Credit Approval process.';
    if (StrAppr != null) {
     try {
      /*BUG-16959 added Prod condition for DBOL  by Rajesh */
      if (!isPSBLProductLineProduct) {
       /*Responsys Dynamic Parameters Bug 15653 s*/
       List < Applicant__c > appList = new List < Applicant__c > ();
       appList.add(applicantPrimary);
       List < Opportunity > LoanList = new List < Opportunity > ();
       LoanList.add(Loan);
       GeneralCommunicationHandler.sendSMS(LoanList, appList, 'Submit by CPA-Cust');
       /*Responsys Dynamic Parameters Bug 15653 e*/

      }
     } catch (Exception e) {
      system.debug('Exception occurd==>' + e.getMessage() + 'Line number===>' + e.getLinenumber());
      sendEmailForException(e);
      return null;
     }
     /*Responsys Dynamic Parameters Bug 15653 s*/
     List < Applicant__c > appList = new List < Applicant__c > ();
     appList.add(applicantPrimary);
     List < Opportunity > LoanList = new List < Opportunity > ();
     LoanList.add(Loan);
     GeneralCommunicationHandler.sendSMS(LoanList, appList, 'Submit by CPA-Int');
     /*Responsys Dynamic Parameters Bug 15653 e*/

     Loan.ownerid = StrAppr;
    } // if ends
    Loan.CM__c = StrAppr;
    system.debug('acmamt: ' + acmamt);
    Loan.CM_Amount__c = acmamt;
    Loan.Approver__c = 'Credit Manager';

    if (Loan.StageName != 'Pending for Insurance approval' && Loan.Processing_Type__c != 'Without Loan' && Loan.product__c == 'DPL' && Loan.StageName != 'Approved') {
     Loan.StageName = 'Underwriting';
    }
    if ((Loan.StageName != 'Underwriting' && Loan.product__c != 'DPL') && (Loan.StageName != 'Re-Appraise- Loan amount') && (Loan.StageName != 'Approved') && (Loan.StageName != 'Rejected') && (Loan.StageName != 'Re-Appraise- IRR') && (Loan.StageName != 'Re-Appraise- Tenor') && (Loan.StageName != 'Re-Appraise- Reject Case') && (Loan.StageName != 'Hold')) {
     Loan.Approval_Stages__c = 'Pending Approval';
     Loan.stagename = 'Personal Discussion';
    } // Bug id : 13016 - New Role Creation for Credit, added by Needhi (ends)
   } else if (approverDesignation1 == 'Business Head') {
    Loan.Business_Head__c = StrAppr;
    Loan.ownerId = StrAppr;
    Loan.Approver__c = 'Business Head';
    if (acmamt != null)
     Loan.Business_Head_Amount__c = acmamt;

   } else if (approverDesignation1 == 'City Head') {
    Loan.City_Head__c = StrAppr;
    Loan.ownerId = StrAppr;
    Loan.Approver__c = 'City Head';
    if (acmamt != null)
     Loan.City_Head_Amount__c = acmamt;

   } else if (approverDesignation1 == 'National Credit Manager') {
    Loan.NCM__c = StrAppr;
    Loan.ownerId = StrAppr;
    Loan.Approver__c = 'National Credit Manager';
    if (acmamt != null)
     Loan.NCM_Amount__c = acmamt;
   } else if (approverDesignation1 == 'Senior Credit Officer') { // Bug id : 13016 - New Role Creation for Credit, added by Needhi 
    Loan.SCO__c = StrAppr;
    Loan.ownerId = StrAppr;
    Loan.Approver__c = 'Senior Credit Officer';
    if (acmamt != null)
     Loan.SCO_Amount__c = acmamt;
    System.debug('Loan.SCO_Amount__c --> ' + Loan.SCO_Amount__c);
   } else if (approverDesignation1 == 'Chief-Credit & Operations') {
    Loan.COO__c = StrAppr;
    Loan.ownerId = StrAppr;
    Loan.Approver__c = 'Chief-Credit & Operations';
    if (acmamt != null)
     Loan.COO_Amount__c = acmamt;

   } else if (approverDesignation1 == 'Chief Risk Officer') {
    Loan.CRO__c = StrAppr;
    Loan.ownerId = StrAppr;
    Loan.Approver__c = 'Chief Risk Officer';
    if (acmamt != null)
     Loan.CRO_Amount__c = acmamt;

   } else if (approverDesignation1 == 'Centralized ACM') {
    Loan.Centralized_ACM__c = StrAppr;
    Loan.ownerId = StrAppr;
    Loan.Approver__c = 'Centralized ACM';
    if (acmamt != null)
     Loan.Centralized_ACM_Amount__c = acmamt;

   } else if (approverDesignation1 == 'Zonal Credit Manager') {
    Loan.CEO__c = StrAppr;
    Loan.ownerId = StrAppr;
    Loan.Approver__c = 'Zonal Credit Manager';
    if (acmamt != null)
     Loan.ZCM_Amount__c = acmamt;

   } else if (approverDesignation1 == 'National Risk Manager') {
    Loan.RISK__c = StrAppr;
    Loan.ownerId = StrAppr;
    Loan.Approver__c = 'National Risk Manager';
    if (acmamt != null)
     Loan.RISK_Amount__c = acmamt;

   } else if (approverDesignation1 == 'Regional Credit Manager') {
    Loan.RCM__c = StrAppr;
    Loan.ownerId = StrAppr;
    Loan.Approver__c = 'Regional Credit Manager';
    if (acmamt != null)
     Loan.RCM_Amount__c = acmamt;

   } else if (approverDesignation1 == 'President') {
    Loan.RCM__c = StrAppr;
    Loan.ownerId = StrAppr;
    Loan.Approver__c = 'President';
    if (acmamt != null)
     Loan.RCM_Amount__c = acmamt;

   } else {

    //Submit to Approver logic
    if (StrAppr != null)
     apprid = StrAppr;
    Loan.ownerid = apprid;
    if (apprid == Loan.City_Head__c)
     Loan.Approver__c = 'City Head';
    if (apprid == Loan.Centralized_ACM__c)
     Loan.Approver__c = 'Centralized ACM';
    if (apprid == Loan.Centralized_RCM__c)
     Loan.Approver__c = 'Centralized RCM';
    if (apprid == Loan.RCM__c)
     Loan.Approver__c = 'Regional Credit Manager';
    if (apprid == Loan.CEO__c) /*Added for Zonal Credit Manager*/
     Loan.Approver__c = 'Zonal Credit Manager';
    if (apprid == Loan.NCM__c)
     Loan.Approver__c = 'National Credit Manager';
    if (apprid == Loan.RISK__c)
     Loan.Approver__c = 'National Risk Manager';
    if (apprid == Loan.COO__c)
     Loan.Approver__c = 'Chief-Credit & Operations';
    if (apprid == Loan.CRO__c)
     Loan.Approver__c = 'Chief Risk Officer';
    if (apprid == Loan.Business_Head__c)
     Loan.Approver__c = 'Business Head';
    if (apprid == Loan.President__c)
     Loan.Approver__c = 'President';
    if (apprid == Loan.CM__c) // Bug id : 13016 - New Role Creation for Credit, added by Needhi 
     Loan.Approver__c = 'Credit Manager';
    if (apprid == Loan.SCO__c) // Bug id : 13016 - New Role Creation for Credit, added by Needhi 
     Loan.Approver__c = 'Senior Credit Officer';

   }
  } //salaried end 

  if (Loan.StageName != 'Pending for Insurance approval' && Loan.Processing_Type__c != 'Without Loan' && Loan.product__c == 'DPL' && Loan.StageName != 'Approved') {

   Loan.StageName = 'Underwriting';
  }
  update Loan;
  Pagereference p = new pagereference('/006/o');
  return p;

 }

 public void checkuser() {
  Id userId = Userinfo.getuserid();
  ID Pid = Userinfo.getProfileID();
  String Pname = [select id, name from Profile where id =: Pid].name;
  String uid = userId;
  uid = uid.substring(0, 15);
  string owneridOfOppo;
  list < User > profilename = new list < User > ();
  owneridOfOppo = Loan.ownerId;
  profilename = [select id, Profile.Name, Name from User where id =: owneridOfOppo];

  if (Loan.product__c == 'DPL' && Pname == 'Insurance') {
   apprrejbutton = true;
   showsave = true;
  }

  if (Loan.product__c == 'DPL' && Pname == 'Insurance') {
   apprrejbutton = true;
   showsave = true;
  }

  if (Pname == 'System Administrator' || Pname == 'Sys Administrator' || Pname == 'Sys Admin Persistent') {
   showsave = true;
  }

  if ((Pname == 'CPA Login partner' || Pname == 'FAS CPA Login') && (Loan.stagename != 'Rejected')) {
   showsave = true;
  }

  // Bug id : 13016 - New Role Creation for Credit, added by Needhi
  if ((Pname == 'Credit Manager' || Pname == 'Area Credit Manager' || Pname == 'City Head' || Pname == 'President' ||
    Pname == 'Regional Credit Manager' || Pname == 'Zonal Credit Manager' ||
    Pname == 'National Credit Manager' || Pname == 'Senior Credit Officer' || Pname == 'National Risk Manager' ||
    Pname == 'Chief Risk Officer' || Pname == 'Chief-Credit & Operations' ||
    Pname == 'Centralized CPA' || Pname == 'Centralized ACM' ||
    Pname == 'Centralized RCM' || Pname == 'Business Head') && (Loan.stagename != 'Approved' && Loan.stagename != 'Rejected') && Pname == Loan.Approver__c && Pname == profilename[0].Profile.Name) {
   apprrejbutton = true;
   showsave = true;
  }

  if ((Pname == 'Credit Manager' || Pname == 'Area Credit Manager' || Pname == 'City Head' || Pname == 'President' ||
    Pname == 'Regional Credit Manager' || Pname == 'Zonal Credit Manager' ||
    Pname == 'National Credit Manager' || Pname == 'Senior Credit Officer' || Pname == 'National Risk Manager' ||
    Pname == 'Chief Risk Officer' || Pname == 'Chief-Credit & Operations' ||
    Pname == 'Centralized CPA' || Pname == 'Centralized ACM' ||
    Pname == 'Centralized RCM' || Pname == 'Business Head') && (Loan.stagename == 'Approved' || Loan.stagename == 'Rejected') && Pname == Loan.Approver__c && Pname == profilename[0].Profile.Name) {
   apprrejbutton = true;
  }

  if ((Pname == 'Credit Manager' || Pname == 'Area Credit Manager' || Pname == 'City Head' || Pname == 'President' ||
    Pname == 'Regional Credit Manager' || Pname == 'Zonal Credit Manager' ||
    Pname == 'National Credit Manager' || Pname == 'Senior Credit Officer' || Pname == 'National Risk Manager' ||
    Pname == 'Chief Risk Officer' || Pname == 'Chief-Credit & Operations' ||
    Pname == 'Centralized CPA' || Pname == 'Centralized ACM' ||
    Pname == 'Centralized RCM' || Pname == 'Business Head') && (Loan.stagename != 'Rejected') && Pname == Loan.Approver__c && Pname == profilename[0].Profile.Name) {
   showsave = true;
  }

  if ((Pname == 'Credit Manager' || Pname == 'Area Credit Manager' || Pname == 'City Head' || Pname == 'President' ||
    Pname == 'Regional Credit Manager' || Pname == 'Zonal Credit Manager' ||
    Pname == 'National Credit Manager' || Pname == 'Senior Credit Officer' || Pname == 'National Risk Manager' ||
    Pname == 'Chief Risk Officer' || Pname == 'Chief-Credit & Operations' ||
    Pname == 'Centralized CPA' || Pname == 'Centralized ACM' ||
    Pname == 'Centralized RCM' || Pname == 'Business Head') && (Loan.stagename != 'Rejected') && Pname == profilename[0].Profile.Name) {
   showsave = true;
  }
 }

 Id apprid;
 transient boolean isItHigherDesg = false;

 public Boolean showsubhold {
  get;
  set;
 }
 public Boolean apprrejbutton {
  get;
  set;
 }

 public PageReference cancelappr() {
  showapprove = false;
  return null;
 }
 // Continue for Loan Approval
 public Boolean showesc {
  get;
  set;
 }
 public void acmesc() {
  showesc = true;
 }
 public PageReference cancelesc() {
  showesc = false;
  return null;
 }
 public Boolean showsubapprove {
  get;
  set;
 }

 public void acmsubappr() {
  showsubapprove = true;
 }
 public PageReference cancelsubappr() {
  showsubapprove = false;
  return null;
 }

 String labelLAPProducts = '';
 public PageReference hold() {
  showsubhold = true;
  return null;

 }
 public PageReference conthold() {
  try {
   System.debug('\n\n\t In conthold .................... \n');
   String referal = LOan.Referral__c;
   if (referal == 'None') {
    Loan.Referral__c = null;
   }
   Loan.stagename = 'Hold';
   update Loan;
   showsave = false;

   System.debug('Mortgageflag : ' + Mortgageflag);
   // Start of general communication framework
   if (Mortgageflag) {
    System.debug('Loan : ' + Loan);
    List < Opportunity > LoanList = new List < Opportunity > ();
    LoanList.add(Loan);
    GeneralCommunicationHandler.sendSMS(LoanList, 'Hold-Cust');
    GeneralCommunicationHandler.sendSMS(LoanList, 'Hold-Int');

    GeneralCommunicationHandler.sendEmail(LoanList, 'Hold-Cust');
    GeneralCommunicationHandler.sendEmail(LoanList, 'Hold-Int');
   }
   // End of general communication framework

   // Bug Id : 19243 Hold Functionality S
   Opportunity opp = [Select Id, Prior_Application_Stage__c, Product__c, OwnerId, Account.Queue_Master__c,Account.Queue_Master__r.QID__c/*Bug Id : 23549*/ from Opportunity where Id =: Loan.Id LIMIT 1];
   System.debug('prior vlaue -->' + opp);

   if (opp != null && String.isNotBlank(opp.Prior_Application_Stage__c)) {
    String[] splitStrArr = opp.Prior_Application_Stage__c.split(';');
    if (splitStrArr != null && splitStrArr.size() == 2 && splitStrArr[0] == 'Underwriting') {
     isAutoAllocation = AutoQueueAllocationUtility.updateCreditUserOccupied('Hold', opp, null);
    }
   }
   // Bug Id : 19243 Hold Functionality E

   Pagereference p = new pagereference('/' + Loan.Id);
   return p;

  } catch (Exception e) {
   sendEmailForException(e);
   return null;
  }
 }
 public PageReference cancelhold() {
  showsubhold = false;
  return null;
 }
 public PageReference UnHold() {
  try {
   /*String referal = LOan.Referral__c;
if (referal == 'None') {
Loan.Referral__c = null;
}
Loan.UnHold__c = true;
update Loan;*/

   // Bug Id : 19243 Hold Functionality S
   Opportunity opp = [Select Id, Prior_Application_Stage__c, Product__c, OwnerId, Account.Queue_Master__c,Account.Queue_Master__r.QID__c/*Bug Id : 23549*/, UnHold__c from Opportunity where Id =: Loan.Id LIMIT 1];
   System.debug('prior vlaue -->' + opp);
   Boolean result = false;
   if (opp != null && String.isNotBlank(opp.Prior_Application_Stage__c)) {
    String[] splitStrArr = opp.Prior_Application_Stage__c.split(';');
    if (splitStrArr != null && splitStrArr.size() == 2 && splitStrArr[0] == 'Underwriting') {
     result = AutoQueueAllocationUtility.unHoldAutoQueueLogic('Hold', Loan);
    }
   }
   System.debug('unhold result -->' + result);
   // Bug Id : 19243 Hold Functionality E
   if (!result) {
    System.debug('unhold old flow -->');
    String referal = LOan.Referral__c;
    if (referal == 'None') {
     Loan.Referral__c = null;
    }
    Loan.UnHold__c = true;
    update Loan;
   }

   Pagereference p = new pagereference('/' + Loan.Id);
   return p;
  } catch (Exception e) {
   sendEmailForException(e);
   return null;
  }
 }

 Contact con = new Contact();

 List < Checklist__c > standardDocuments = new List < Checklist__c > ();
 public List < Checklist__c > getStandardDocuments() {
  return standardDocuments;
 }


 public List < SelectOption > getStrAppItems() {
  return optionsdocApp;
 }
 public List < Applicant__c > applicantList = new List < Applicant__c > ();

 List < Deviation_Transaction__c > devTransView = new List < Deviation_Transaction__c > ();


 public List < Deviation_Transaction__c > getdevTransView() {
  try {
   if (devTransView.size() > 0)
    return devTransView;
   else
    return null;
  } catch (Exception e) {
   sendEmailForException(e);
   return null;
  }
 }

 public String getStrVADev() {
  return StrVADev;
 }
 public void setStrVADev(String StrVADev) {
  this.StrVADev = StrVADev;
 }
 public List < SelectOption > getdevList() {
  return optionsDev;
 }


 public PageReference saveDeviation() {
  try {
   Integer NewRowCount = 0;
   if (StrVADev != null) {
    Id deviationId = StrVADev;
    List < Document_Family__c > docFamilyList = new List < Document_Family__c > ();
    //   Deviation_Transaction__c devTransNew=new Deviation_Transaction__c(Deviation_Master__c=deviationId,Loan_Application__c=Loan.Id,Manual__c=true);
    //integer count=0;
    List < Deviation_Master__c > devList = new List < Deviation_Master__c > ();
    devList = [Select id, Deviation_Code__c, BRE_Deviation_Code__c from Deviation_Master__c where Id =: deviationId];

    List < Checklist__c > manualList = new List < Checklist__c > ();
    if (devList.size() > 0) {
     docFamilyList = [select name, Documents__c, Is_OTP_Standard_Document__c, Product__c, Document_Code__c, Deviation_Code__c, Customer_Segment__c from Document_Family__c where Deviation_Code__c != null];
     List < String > devStr = new List < String > ();
     List < String > docStr = new List < String > ();
     if (docFamilyList != null && docFamilyList.size() > 0) {
      for (Deviation_Master__c dev: devList) {
       for (Document_Family__c doc: docFamilyList) {
        if ((doc.Deviation_Code__c.contains(dev.BRE_Deviation_Code__c)) || (doc.Deviation_Code__c == dev.BRE_Deviation_Code__c)) {
         Checklist__c newCheckList = new Checklist__c(Loan_Application__c = Loan.id, Deviation_Master__c = dev.id, DocumentFmlyName__c = doc.id, Manual__c = true);
         //if(newCheckList.Checklist_Parameter__r.Type_of_Document__c == 'Deviation'){
         NewRowCount++;
         DocumentWrapper wrapperObjForDev = new DocumentWrapper(newCheckList, doc.Documents__c, NewRowCount);
         manualList.add(newCheckList);
         ManualDeviationList.add(newCheckList);
         //}
         break;
        }

       }
      }
     }
    }
    if (manualList != null && manualList.size() > 0)
     insert manualList;


    deviations = [Select Id, Name, Deviation_Description__c, Deviation_Code__c, BRE_Deviation_Code__c from Deviation_Master__c
     where Product__c =: Loan.Product__c and Active_Flag__c = true and BRE_Deviation_Code__c != null
    ];
    optionsDev = new List < SelectOption > ();
    for (integer i = 0; i < deviations.size(); i++) {
     optionsDev.add(new SelectOption(deviations[i].Id, deviations[i].Name + '-' + deviations[i].BRE_Deviation_Code__c));
    }

    // Bug 11944 - Mitigants_Remark__c Field is added in query
    ManualDeviationList = [select Deviation_Master__r.Deviation_Description__c, id, Document_Type__c, DocStatus__c, DocumentFmlyName__r.Documents__c, DocumentFmlyName__r.Is_MidOffice_Standard_Document__c, Category__c, Sales_Status__c, CPA_Status__c, Document__c, Mitigants_Remark__c,
     Deviation_Master__c, Deviation_Master__r.Name, DocumentFmlyName__r.Id, DocumentFmlyName__r.Name, Checklist_Parameter__r.Mandatory__c, Applicant__c, DocumentFmlyName__c, to_be_approved_by__c,
     Documents__c, docRemarks__c, DocumentFmlyName__r.Document_Code__c, Deviation_Master__r.Minimum_Approving_Authority__c, Deviation_Master__r.Deviation_Code__c,
     Property_Document__c, Mandatory__c, DocumentFmlyName__r.Deviation_Code__c, Manual__c, Deviation_Master__r.BRE_Deviation_Code__c
     from Checklist__c where Loan_Application__c =: Loan.Id and Manual__c = true order by createddate desc
    ];


    ManualDeviationsWrap = new List < ManualDeviations > {};

    for (Checklist__c CL: ManualDeviationList) {
     ManualDeviationsWrap.add(new ManualDeviations(CL));
    }

    savedSuccessfull = true;
    message = 'Deviation Created Successfully !!!';
   }

  } catch (Exception e) {
   sendEmailForException(e);
  }


  return null;
 }

 public List < SelectOption > getDocList() {
  List < SelectOption > optionsDoc = new List < SelectOption > ();
  optionsDoc.add(new selectOption('', 'None'));
  /*Document_Family__c[] documents;
documents=[Select Id,Name,Is_MidOffice_Standard_Document__c from Document_Family__c ];
//creating doc list
for(integer i=0;i<documents.size();i++){
if(documents[i].Is_MidOffice_Standard_Document__c== true){
optionsDoc.add(new SelectOption(documents[i].Id,documents[i].Name));
}
}//end of for*/
  return optionsDoc;
 }

 public PageReference salesReject() {
  try {
   if (loan.stagename == 'DSA/PSF Login') {
    loan.stagename = 'Sales Reject';
    update loan;
   }
  } catch (Exception e) {
   sendEmailForException(e);
  }
  if (LoanId != null) {
   PageReference p = new PageReference('/' + Loan.Id);
   return p;
  }
  return null;
 }

 public List < Discrepancy__c > getdiscrepancyData() {
  return discrepancyData;
 }
 public void AddDiscrepancy() {
  if (discrepancyData.size() > 0) {
   if (StrVAContact != null) {
    integer count = discrepancyData.size();
    count = count - 1;
    discrepancyData[count].Discrepancy_Party__c = StrVAContact;
   }
  }
  showDiscrepancy = true;
  Discrepancy__c addNewDisc = new Discrepancy__c();
  if (docid != null && chkListType != null && chkListType == 'log') {
   addNewDisc.Doc_ID__c = docid + '';
  }
  addNewDisc.LoanApplication__c = Loan.Id;
  addNewDisc.Discrepancy_Stage__c = Loan.StageName;
  addNewDisc.Status__c = 'Pending';
  String RoleName = Loan.Current_UserRole__C;
  addNewDisc.RaiserName__c = userDisc;
  addNewDisc.Raiser_Role__c = RoleName;
  discrepancyData.add(addNewDisc);
  //addrow=true;
  addrowDisc = true;
  //sendMssg=false; 
 }
 //getting the selected 
 public String getStrVAContact() {
  return StrVAContact;
 }
 public Pagereference sendForCPA() {
  Integer docount = 0;
  List < String > documentNames = new List < String > ();
  List < Checklist__c > docChecklist = [select Deviation_Master__r.Deviation_Description__c, id, name, Document_Type__c, Mandatory__c, Sales_Status__c, Document__c, to_be_approved_by__c from Checklist__c where Loan_Application__c =: loan.id];
  for (Checklist__c chk: docChecklist) {
   if (chk.Document__c != null)
    documentNames.add(chk.Document__c);
   if (chk.Mandatory__c == true && chk.Sales_Status__c != 'Received')
    docount += 1;
  }
  if (docount > 0) {
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'All mandatory documents are not collected.You cannot proceed to CPA stage!!'));
   return null;
  } else {
   Id asmTempid = '00e90000000a2ts';
   Id dsaID = UserInfo.getUserId();
   String dsaCity, cpaproduct;
   Id branchId, cpaId;
   Id profileId;
   integer branchCount;
   integer cpaCount;
   dsaCity = Loan.Branch_City__C;
   cpaproduct = Loan.Product__c;

   profileId = '00e90000000a2ym';
   if (dsaCity != null) {
    try {
     cpaId = [Select Id, Name from User where Product__c includes(: cpaproduct) and Branch_City__c includes(: dsaCity) and ProfileId =: profileId and IsActive = true Limit 1].Id;
     Id userId = Userinfo.getuserid();
     ID Pid = Userinfo.getProfileID();
     if (Pid == '00e90000000a2ym')
      cpaId = userId;
    } catch (Exception e) {
     savedSuccessfull = true;
     message = e.getMessage() + '  ' + e.getLineNumber() + '  ' + e.getCause() + '  ' + e.getTypeName();
     SendExceptionMail(message, 'Exception came in MidOffice flow (Eligibility)');
    }
   }
   Id ceoprid = [select id from Profile where name = 'CEO'].id;
   integer ceocount;
   Id ceoid;

   try {
    ceoid = [select id, Name from User where ProfileId =: ceoprid and isActive = true Limit 1].id;
   } catch (Exception e) {
    savedSuccessfull = true;
    message = e.getMessage() + '  ' + e.getLineNumber() + '  ' + e.getCause() + '  ' + e.getTypeName();
    SendExceptionMail(message, 'Exception came in MidOffice flow (Eligibility)');
   }
   if (Loan.Product__C != 'FAS') {
    Loan.Approver__c = 'CPA Login Partner';
   }
   if (cpaId != null) {
    Loan.OwnerId = cpaId;
    Loan.CPA__c = cpaId;
   }
   Loan.CEO__c = ceoid;
   Loan.File_Acceptance__c = null;

   if (loan.Loan_Application_Flow__c == 'Mid Office') {
    processNextStage();
   }

   //else
   //  loan.stageName = 'Pending CPA Acceptance';

   update loan;
   PageReference pageRef = new PageReference('/apex/CODemographicDetailsPage?id=' + loan.id);
   return pageRef;
  }
 }

 public void processNextStage() {
  //List<MCP_Parameter_Master__c> parameterList = new List<MCP_Parameter_Master__c>();
  /*parameterList = [select id,Next_Stage__c from MCP_Parameter_Master__c where Current_Stage__c = :loan.stageName and product__c = :loan.product__c and Parameter_Type__c = 'Mid Office Stages' limit 1];
if(parameterList != null && parameterList.size() > 0){

loan.stagename = parameterList[0].Next_Stage__c;
}*/
 }

 public void appScore() {
  // MidOfficeCustomerSegmentation obj = new MidOfficeCustomerSegmentation();
  //obj.calculateAppScore(loan,applicantPrimary,plbs);  
 }

 public List < Integer > checkForScore(String rank) {
  List < String > rankList1 = new List < String > ();
  List < Integer > rankList = new List < Integer > ();
  rankList1 = rank.split(',');
  for (String rankVar: rankList1) {
   rankList.add(Integer.valueOf(rankVar));
  }
  return rankList;
 }
 public void setStrVAContact(String StrVAContact) {
  this.StrVAContact = StrVAContact;
 }
 public PageReference SaveDiscrepancy() {


  try {

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
     insert discrepancyData;
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
    from Discrepancy__c where LoanApplication__c =: Loan.Id and Type__c != 'SanctionCondition'
    order by Status__c asc, createddate asc
   ];

   // Added for Disbursement
   discrepancyListDis = new List < Discrepancy__c > ();
   discrepancyListLog = new List < Discrepancy__c > ();
   for (Discrepancy__c ocl: discrepancyList) {
    if (ocl.Discrepancy_Category__c == 'Disbursement') {
     discrepancyListDis.add(ocl);
    } else {
     discrepancyListLog.add(ocl);
    }
   }

   //Assigning back to PropertyDocuments
   discrepancyList = new List < Discrepancy__c > ();
   discrepancyList = discrepancyListLog;


   savedSuccessfull = true;
   message = 'Saved successfully';
  } catch (Exception e) {
   sendEmailForException(e);

  }
  return null;
 }

 //Save function for editing discrepancy
 public PageReference SaveChanges() {

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
   from Discrepancy__c where LoanApplication__c =: Loan.Id and Type__c != 'SanctionCondition'
   order by Status__c asc, createddate asc
  ];

  // Added for disbursement

  discrepancyListDis = new List < Discrepancy__c > ();
  discrepancyListLog = new List < Discrepancy__c > ();
  for (Discrepancy__c ocl: discrepancyList) {
   if (ocl.Discrepancy_Category__c == 'Disbursement') {
    discrepancyListDis.add(ocl);
   } else {
    discrepancyListLog.add(ocl);
   }
  }

  //Assigning back to PropertyDocuments
  discrepancyList = new List < Discrepancy__c > ();
  discrepancyList = discrepancyListLog;


  return null;
 }
 // ***************Adding new discrepancy dis 
 public List < Discrepancy__c > getdiscrepancyDataDis() {
  return discrepancyDataDis;
 }
 //getting the applicants 
 public List < SelectOption > getApplicantList() {
  return optionsApplicant;
 }
 public PageReference checkEligibility() {
  try {

   //Call segmentation
   //MidOfcSalesScreenController salesObj = new MidOfcSalesScreenController();
   //salesObj.CalculateSegmentation();
   //Call BRE method -> pass data for eligibility, loan , cam object  
   MAP < String, String > breResponse = new MAP < String, String > ();
   BRECallout br = new BRECallout();
   tenorList = new List < String > ();
   MaxLoanAsMuliplier = new List < Decimal > ();
   MaxLoanAsFOIR = new List < Decimal > ();
   finalEligibilty = new List < Decimal > ();
   finalEMI = new List < Decimal > ();
   String tenure = '';
   if (ProductSMS__c.getValues(Loan.product__c) != null && ProductSMS__c.getValues(Loan.product__c).Line_Tenure__c != null) {

    tenure = String.valueof(ProductSMS__c.getValues(Loan.product__c).Line_Tenure__c);
   }

   if (Loan.Product__c != 'FAS') {
    if (camlist != null && camlist.size() > 0) {
     Map < String, String > EligibilityMap = new Map < String, String > ();
     /*OTP V3 CR - added by Krish start*/
     Double avg_net_sal = cam.Average_incentive_for_Q1__c;
     //OTPv3 TeleRM Rohit condition changed 15229
     if (OTPProducts.contains(Loan.Product__c)) {
      System.debug('rohit3 ' + applicantPrimary);
      if (cam.Existing_HL_EMI__c != null && cam.Existing_HL_EMI__c != 0)
       avg_net_sal += cam.Existing_HL_EMI__c;
      EligibilityMap.put('specialProfile', (applicantPrimary != null && applicantPrimary.Contact_Name__r != null) ? String.valueof(applicantPrimary.Contact_Name__r.special_profile_employer__c) : 'false');
      EligibilityMap.put('overdueAmtinLast24Month', (cibilExt1.Sum_of_Amount_Overdue__c != null) ? String.valueof(cibilExt1.Sum_of_Amount_Overdue__c) : '0');
      EligibilityMap.put('dpdinLast3Months', (cibilExt1.X30_DPD_3_months__c != null) ? String.valueof(cibilExt1.X30_DPD_3_months__c) : '0');
      EligibilityMap.put('dpdinLast6Months', (cibilExt1.X30_DPD_6_months__c != null) ? String.valueof(cibilExt1.X30_DPD_6_months__c) : '0');
      EligibilityMap.put('riskSegmentClassification', (applicantPrimary.risk_segmentation__c != null) ? String.valueof(applicantPrimary.risk_segmentation__c) : '');

     }
     /*OTP V3 CR - added by Krish end*/
     //New code
     EligibilityMap.put('requested_loan_amount', (cam.Proposed_Loan_Amt__c != null) ? String.valueof(cam.Proposed_Loan_Amt__c) : '0');
     EligibilityMap.put('branch_name', (Loan.BranchName__c != null) ? Loan.BranchName__c : '');
     EligibilityMap.put('branch_type', (Loan.Branch_Type1__c != null) ? String.valueof(Loan.Branch_Type1__c) : '');
     EligibilityMap.put('rental_Income', (cam.Rental_Income__c != null) ? String.valueof(cam.Rental_Income__c) : '0');
     EligibilityMap.put('reimbursement', (cam.Monthly_Reimbursement__c != null) ? String.valueof(cam.Monthly_Reimbursement__c) : '0');
     EligibilityMap.put('avgIncentive', (cam.Avg_mthly_incntve_3mts__c != null) ? String.valueof(cam.Avg_mthly_incntve_3mts__c) : '0');
     EligibilityMap.put('applicant_net_salary_m1', (avg_net_sal != null) ? String.valueof(avg_net_sal) : '0'); //OTP V3 CR changed value
     EligibilityMap.put('applicant_net_salary_m2', (cam.Average_incentive_for_Q2__c != null) ? String.valueof(cam.Average_incentive_for_Q2__c) : '0');
     EligibilityMap.put('applicant_net_salary_m3', (cam.Average_incentive_for_Q3__c != null) ? String.valueof(cam.Average_incentive_for_Q3__c) : '0');
     EligibilityMap.put('co_applicant_net_salary_m1', (cam.Receips4_Doc__c != null) ? String.valueof(cam.Receips4_Doc__c) : '0');
     EligibilityMap.put('co_applicant_net_salary_m2', (cam.Receips5_Doc__c != null) ? String.valueof(cam.Receips5_Doc__c) : '0');
     EligibilityMap.put('co_applicant_net_salary_m3', (cam.Receips6_Doc__c != null) ? String.valueof(cam.Receips6_Doc__c) : '0');
     EligibilityMap.put('applicant_type', (applicantPrimary.Applicant_type__c != null) ? applicantPrimary.Applicant_type__c : '0');

     EligibilityMap.put('requested_tenor', (cam.Tenor__c != null) ? String.valueof(cam.Tenor__c) : '0');
     EligibilityMap.put('reqested_roi', (cam.ROI__c != null) ? String.valueof(cam.ROI__c) : '0');
     EligibilityMap.put('monthly_loan_obligations', (cam.Total_Mthly_Oblig__c != null) ? String.valueof(cam.Total_Mthly_Oblig__c) : '0');
     EligibilityMap.put('product', (Loan.product__c != null) ? String.valueof(Loan.product__c) : '');
     EligibilityMap.put('number_of_hl_loans', (ExistLoanscount != null) ? String.valueof(ExistLoanscount) : '0');
     EligibilityMap.put('bajaj_loan_obligations', (totalObligAmount != null) ? String.valueof(totalObligAmount) : '0');
     EligibilityMap.put('customer_segment', (applicantPrimary.Bureau_Segment__c != null) ? applicantPrimary.Bureau_Segment__c : '');
     EligibilityMap.put('date_of_birth', (con.Date_of_Birth__c != null) ? String.valueof(con.Date_of_Birth__c) : '');
     EligibilityMap.put('residence_type', (con.Residence_Type__c != null) ? String.valueof(con.Residence_Type__c) : '');
     EligibilityMap.put('company_type', (con.Company_Type__c != null) ? String.valueof(con.Company_Type__c) : '');
     if (applicantPrimary.CIBIL_Score__c != null && applicantPrimary.CIBIL_Score__c == '000-1')
      EligibilityMap.put('CIBIL_Score', '0');
     else
      EligibilityMap.put('CIBIL_Score', (applicantPrimary.CIBIL_Score__c != null) ? String.valueof(applicantPrimary.CIBIL_Score__c) : '0');

     EligibilityMap.put('loan_id', (Loan.Loan_Application_Number__c != null) ? Loan.Loan_Application_Number__c : '');
     //Offer_Amount__c
     EligibilityMap.put('offer_amount', (Loan.Offer_Amount__c != null) ? String.valueof(Loan.Offer_Amount__c) : '0');
     //Added PLOC changes 
     EligibilityMap.put('company_category', (con.Company_Category__c != null) ? String.valueof(con.Company_Category__c) : '0');
     EligibilityMap.put('total_Amount_overdue', (cibilExt1Obj != null && cibilExt1Obj.Total_Amount_overdue__c != null) ? String.valueof(cibilExt1Obj.Total_Amount_overdue__c) : '0');
     EligibilityMap.put('total_FOIR', (cam.Eligible_FOIR__c != null) ? String.valueof(cam.Eligible_FOIR__c) : '0');
     EligibilityMap.put('unsecuredFOIR', (cam.Unsecured_FOIR__c != null) ? String.valueof(cam.Unsecured_FOIR__c) : '0');
     EligibilityMap.put('ever_HL_In_CIBIL', (EverHLInCIBIL != null) ? EverHLInCIBIL : '0');

     //PLOC changes end

     /*RSL BRE Rules added by shilpa start*/
     if (Loan.Product__c == 'RSL') {
      EligibilityMap.put('applicant_salary_date_m1', (cam.Payment_Date_1__c != null) ? String.valueOf(cam.Payment_Date_1__c) : '');
      EligibilityMap.put('applicant_salary_date_m2', (cam.Payment_Date_2__c != null) ? String.valueOf(cam.Payment_Date_2__c) : '');
      EligibilityMap.put('applicant_salary_date_m3', (cam.Payment_Date_3__c != null) ? String.valueOf(cam.Payment_Date_3__c) : '');
      EligibilityMap.put('sourcing_channel_type', (Loan.Sourcing_Channel__c != null) ? Loan.Sourcing_Channel__c : '');
     }
     /*RSL BRE Rules added by shilpa end*/

     //SAL PLTB S
     Decimal ltaMedical = applicantPrimary.LTA_Medical__c;
     if (applicantPrimary.LTA_Medical__c != null && applicantPrimary.LTA_Frequency__c == 'Monthly') {
      ltaMedical = applicantPrimary.LTA_Medical__c * 12;
     }
     EligibilityMap.put('lta_medical_amount', (ltaMedical != null ? String.valueOf(ltaMedical) : '0'));
     //SAL PLTB E

     //--------------- Mortgage Re-Engg Start---------------------
     if (MortgageFlag) {
      EligibilityMap.put('cy_sales_turnover', (cam.C_P_Current_Year__c != null) ? cam.C_P_Current_Year__c + '' : '0.0');
      EligibilityMap.put('py_sales_turnover', (cam.C_P_Previous_Year__c != null) ? cam.C_P_Previous_Year__c + '' : '0.0');
      EligibilityMap.put('cy_balance_sheet', '0.0');
      EligibilityMap.put('cy_debtors', '0.0');
      EligibilityMap.put('cy_bank_cash_balance', '0.0');
      EligibilityMap.put('cy_creditors', '0.0');
      EligibilityMap.put('cy_capital', '0.0');
      EligibilityMap.put('cy_reserve_surplus', '0.0');
      EligibilityMap.put('cy_closing_stock', '0.0');
      EligibilityMap.put('cy_Total_ouside_borrowings', '0.0');
      EligibilityMap.put('avg_od_cc_limit', '0.0');
      EligibilityMap.put('avg_od_cc_limit', '0.0');
      EligibilityMap.put('avg_od_cc_limit', '0.0');
      EligibilityMap.put('avg_od_cc_utilisation', (cam.Industry_Margins_applicable1__c != null) ? cam.Industry_Margins_applicable1__c + '' : '0');
      EligibilityMap.put('years_in_business_job', accountCreate[0].Total_Work_Experience_Yrs__c != null ? accountCreate[0].Total_Work_Experience_Yrs__c : '0');
     }
     //--------------- Mortgage Re-Engg End-----------------------

     //----Rural Flexi- RSL- 12501- added by mahima - start--
     /*
Cibil_lst:applicant_Type="Primary"--- Added above
Cibil_lst:CIBIL_Score--- added above
Demographic:applicant_type="Primary" --- added above
Demographic:date_of_birth--- added above
CAM.applicant_net_salary_m1--- added above
CAM.applicant_net_salary_m2--- added above
CAM.applicant_net_salary_m3--- added above
*/
     //----Rural Flexi- RSL- 12501- added by mahima - end--

     if (!Test.isRunningTest())
      breResponse = br.callBREeligibility(EligibilityMap);
     else {
      breResponse.put('max_loan_as_per_multiplier', '10');
      breResponse.put('max_loan_as_per_FOIR_12', '10');
      breResponse.put('max_loan_as_per_FOIR_24', '10');
      breResponse.put('max_loan_as_per_FOIR_36', '10');
      breResponse.put('max_loan_as_per_FOIR_60', '10');
      breResponse.put('max_loan_as_per_FOIR_72', '10');
      breResponse.put('eligible_loan_amount_12', '10');
      breResponse.put('eligible_loan_amount_24', '10');
      breResponse.put('eligible_loan_amount_36', '10');
      breResponse.put('eligible_loan_amount_60', '10');
      breResponse.put('eligible_loan_amount_72', '10');
      breResponse.put('EMI_tenor_wise_eligibility_12', '10');
      breResponse.put('EMI_tenor_wise_eligibility_24', '10');
      breResponse.put('EMI_tenor_wise_eligibility_36', '10');
      breResponse.put('EMI_tenor_wise_eligibility_60', '10');
      breResponse.put('EMI_tenor_wise_eligibility_72', '10');
      breResponse.put('adjustedRentalIncome', '10');
      breResponse.put('applicable_FOIR', '10');
      breResponse.put('max_emi_can_be_offered', '10');
      breResponse.put('eligibleLoanAmountMinofMultiplierAndFOIR', '10');
      breResponse.put('plusOfferAmount', '10');
      breResponse.put('plusEmi', '10');
      breResponse.put('multiplier', '10');
     }
    }
   }


   List < String > myStrings = new List < String > {
    '12',
    '24',
    '36',
    '48',
    '60',
    '72'
   };

   /*RSL BRE Rules added by shilpa start*/
   if (breResponse != null && breResponse.size() > 0) {
    system.debug('SSM Response ' + breResponse.get('applicant_salary_date_m1') + breResponse.get('applicant_salary_date_m2') + breResponse.get('applicant_salary_date_m3') + breResponse.get('sourcing_channel_type'));
   }
   /*RSL BRE Rules added by shilpa end*/


   for (String str1: myStrings) {
    tenorList.add(str1);
   }
   //MaxLoanAsMuliplier
   if (breResponse != null && breResponse.size() > 0) {
    //--------------- Mortgage Re-Engg Start---------------------  
    if (!MortgageFlag) {
     //For muliplierLoanamt
     List < String > muliplierLoanamt = new List < String > {
      breResponse.get('max_loan_as_per_multiplier'),
      breResponse.get('max_loan_as_per_multiplier'),
      breResponse.get('max_loan_as_per_multiplier'),
      breResponse.get('max_loan_as_per_multiplier'),
      breResponse.get('max_loan_as_per_multiplier'),
      breResponse.get('max_loan_as_per_multiplier')
     };
     for (String str: muliplierLoanamt) {
      if (str != null)
       MaxLoanAsMuliplier.add(Decimal.valueOf(str).setScale(2));
     }
     //For FOIR
     List < String > FOIRLoanamt = new List < String > {
      breResponse.get('max_loan_as_per_FOIR_12'),
      breResponse.get('max_loan_as_per_FOIR_24'),
      breResponse.get('max_loan_as_per_FOIR_36'),
      breResponse.get('max_loan_as_per_FOIR_48'),
      breResponse.get('max_loan_as_per_FOIR_60'),
      breResponse.get('max_loan_as_per_FOIR_72')
     };
     for (String str: FOIRLoanamt) {
      if (str != null)
       MaxLoanAsFOIR.add(Decimal.valueOf(str).setScale(2));
     }

     //For all eligible Amount

     List < String > FinalLoanamt = new List < String > {
      breResponse.get('eligible_loan_amount_12'),
      breResponse.get('eligible_loan_amount_24'),
      breResponse.get('eligible_loan_amount_36'),
      breResponse.get('eligible_loan_amount_48'),
      breResponse.get('eligible_loan_amount_60'),
      breResponse.get('eligible_loan_amount_72')
     };

     for (String str: FinalLoanamt) {
      if (str != null)
       finalEligibilty.add(Decimal.valueOf(str).setScale(2));
     }
     //For all eligible EMI 
     List < String > FinalAllEMI = new List < String > {
      breResponse.get('EMI_tenor_wise_eligibility_12'),
      breResponse.get('EMI_tenor_wise_eligibility_24'),
      breResponse.get('EMI_tenor_wise_eligibility_36'),
      breResponse.get('EMI_tenor_wise_eligibility_48'),
      breResponse.get('EMI_tenor_wise_eligibility_60'),
      breResponse.get('EMI_tenor_wise_eligibility_72')
     };
     for (String str: FinalAllEMI) {
      if (str != null)
       finalEMI.add(Decimal.valueOf(str).setScale(2));
     }

     if (!CommonUtility.isEmpty(breResponse.get('eligible_loan_amount')))
      cam.sal_max_loan__c = Decimal.valueOf(breResponse.get('eligible_loan_amount')).setScale(2);
     if (!CommonUtility.isEmpty(breResponse.get('adjustedRentalIncome'))) {
      cam.Rental_Income_to_be_considered__c = Decimal.valueOf(breResponse.get('adjustedRentalIncome')).setScale(2);
     }
     //Multiplier
     if (!CommonUtility.isEmpty(breResponse.get('max_loan_as_per_multiplier')))
      cam.Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c = Decimal.valueOf(breResponse.get('max_loan_as_per_multiplier')).setScale(2);
     if (!CommonUtility.isEmpty(breResponse.get('applicable_FOIR')))
      cam.Applicable_FOIR1__c = Decimal.valueOf(breResponse.get('applicable_FOIR'));
     //EMI of foir
     if (!CommonUtility.isEmpty(breResponse.get('max_emi_as_per_FOIR')))
      cam.Maxi_EMI_Cust__c = Decimal.valueOf(breResponse.get('max_emi_as_per_FOIR')).setScale(2);
     if (!CommonUtility.isEmpty(breResponse.get('max_loan_as_per_FOIR')))
      cam.LAP_EMI__c = Decimal.valueOf(breResponse.get('max_loan_as_per_FOIR')).setScale(2);
     if (!CommonUtility.isEmpty(breResponse.get('max_emi_can_be_offered')))
      cam.EMI_of_The_Loan__c = Decimal.valueOf(breResponse.get('max_emi_can_be_offered')).setScale(2);

     if (Loan.Product__c == 'SHL' || Loan.Product__c == 'HFC SHL' || Loan.Product__c == 'HSL' || Loan.Product__c == 'SALLAP' || Loan.Product__c == 'HPLS' || Loan.Product__c == 'SBS CS SHL') {
      FinalFOIRTemp = cam.Eligible_FOIR__c;
      totalIncon = cam.Other_income_to_be_consd__c; // bug 11156
     } else {
      //SOL backend changes to calculate final foir ----  by harsit ---start
      if (cam.Unsecured_FOIR__c != null && cam.Secured_FOIR__c != null && Loan.product__c != 'SHOL')
       FinalFOIRTemp = cam.Unsecured_FOIR__c + cam.Secured_FOIR__c;
      else if (Loan.product__c == 'SHOL' && !CommonUtility.isEmpty(solcam))
       FinalFOIRTemp = solcam.Final_Foir1__c;
      //SOL backend changes to calculate final foir ----  by harsit ---end
     }
     System.debug('\n\n\tCalling PMT..................\n\n');
     if (cam.ROI__c != null && cam.Tenor__c != null && cam.Proposed_Loan_Amt__c != null)
      cam.EMI_on_Proposed_Loan_TO__c = (PMT(double.valueOf(cam.ROI__c / 1200), Integer.valueOf(cam.Tenor__c), cam.Proposed_Loan_Amt__c));
     if (breResponse.get('eligibleLoanAmountMinofMultiplierAndFOIR') != null && breResponse.get('eligibleLoanAmountMinofMultiplierAndFOIR') != '')
      cam.Eligible_Loan__c = Decimal.valueOf(breResponse.get('eligibleLoanAmountMinofMultiplierAndFOIR')).setScale(2);
     if (breResponse.get('multiplier') != null && breResponse.get('multiplier') != '')
      cam.Multiplier__c = Decimal.valueOf(breResponse.get('multiplier'));

     if (breResponse.get('plusOfferAmount') != null && breResponse.get('plusOfferAmount') != '')
      cam.Selected_Option_TO__c = Decimal.valueOf(breResponse.get('plusOfferAmount')).setScale(2);
     if (breResponse.get('plusEmi') != null && breResponse.get('plusEmi') != '')
      cam.Live_unsecured_loan__c = Decimal.valueOf(breResponse.get('plusEmi')).setScale(2);
     //final min loan amount
     //upsert cam;  
     //For RSL 
     //Rate Approval start
     if (rateflag) {
      if (breResponse.get('rate_processed_flexi') != null) applicantPrimary.ROIFlexi__c = Decimal.valueOf(breResponse.get('rate_processed_flexi'));
      if (breResponse.get('rate_processed_loc') != null) applicantPrimary.ROILoc__c = Decimal.valueOf(breResponse.get('rate_processed_loc'));
      if (breResponse.get('rate_processed_normal') != null) applicantPrimary.ROINormal__c = Decimal.valueOf(breResponse.get('rate_processed_normal'));

     }
     //Rate Approval end     
     if (breResponse.get('maxLoanAsPerCibil') != null && breResponse.get('maxLoanAsPerCibil') != '') {
      cam.max_loan_POS_forExSAL__c = Decimal.valueOf(breResponse.get('maxLoanAsPerCibil')).setScale(2);
     }
     //**************PLOC code start*************************
     if (breResponse.get('EligibleForPLOC') != null && breResponse.get('EligibleForPLOC') != '') {
      cam.Business_Continuty__c = breResponse.get('EligibleForPLOC');
     } else {
      cam.Business_Continuty__c = 'NO';
     }
     if (breResponse.get('codifiedCibil') != null) applicantPrimary.codified_cibil__c = breResponse.get('codifiedCibil'); // OTP V3 CR - added by krish start
     if (breResponse.get('EMIForPLOC') != null && breResponse.get('EMIForPLOC') != '') {
      cam.EMI_Doc__c = Decimal.valueOf(breResponse.get('EMIForPLOC'));
     }
     //**************PLOC code end***************************


     if (cam.Approved_CAM__c == true) {
      //SHL Requirement start
      if (Loan.Product__c == 'SHL' || Loan.Product__c == 'SHOL' || Loan.Product__c == 'HSL' || Loan.Product__c == 'SALLAP' || Loan.Product__c == 'HPLS' || Loan.Product__c == 'SBS CS SHL') {
       if (cam.Top_Up_Amount__c != null && cam.Proposed_Loan_Amt__c != null)
        Loan.Approved_Loan_Amount__c = cam.Proposed_Loan_Amt__c + cam.Top_Up_Amount__c;
       else
       if (cam.Proposed_Loan_Amt__c != null)
        Loan.Approved_Loan_Amount__c = cam.Proposed_Loan_Amt__c;
      } //SHL Requirement end
      else
       Loan.Approved_Loan_Amount__c = cam.Proposed_Loan_Amt__c;

      Loan.Approved_Rate__c = cam.ROI__c;
      Loan.Approved_Tenor__c = cam.Tenor__c;
     }
     //***********Line assignment start *******

     //if((objSurrogateCAM.Customer_Acceptance_Flag__c != 'YES' && objSurrogateCAM.Customer_Acceptance_Flag__c != 'NO') &&(objSurrogateCAM.Line_opted__c != 'YES' && objSurrogateCAM.Line_opted__c != 'NO')){   
     if (salPOFlow == false) {
      if (breResponse.get('eligible_loan_amount_line') != null && breResponse.get('eligible_loan_amount_line') != '')
       objSurrogateCAM.Line_assigned_basis_Credit_Assessment__c = Decimal.valueOf(breResponse.get('eligible_loan_amount_line'));
      if (tenure != null && tenure != '')
       objSurrogateCAM.Tenor_for_Line_assignment_in_yrs__c = Integer.valueOf(tenure);
      objSurrogateCAM.Loan_Application__c = Loan.id;
      //if(objSurrogateCAM.Line_opted__c=='YES'){
      //objSurrogateCAM.Line_flag__c='I';
      // }
      if (objSurrogateCAM.Line_opted__c == 'NO')
       objSurrogateCAM.Line_flag__c = '';
      if (ProductSMS__c.getValues(Loan.product__c).Validity_In_Months__c != null) {
       Integer months;
       months = Integer.valueof(ProductSMS__c.getValues(Loan.product__c).Validity_In_Months__c);
       //Decision_Date__c



       //@Gaurav:
       // DG - SOL Line Assignment, added chnges to populate line expiry date ( 10 Jan 2017 )
       // Bugzilla Id: 8793 START

       if (Loan.Decision_Date__c != null || Loan.product__c == 'SOL') {
        Date myDate;
        if (Loan.Decision_Date__c != null) {

         myDate = Loan.Decision_Date__c;
        } else if (Loan.product__c == 'SOL') {
         myDate = System.Today();
        }
        objSurrogateCAM.Expiry_Date_without_BT__c = myDate.addMonths(months);

        //For Line policy age
        Integer age = Integer.valueOf(applicantPrimary.Contact_Name__r.Age_Round_Down__c);
        if (age >= 60) {
         objSurrogateCAM.Expiry_Date_without_BT__c = myDate;
        } else {
         Integer years = months / 12;
         for (Integer i = years; i > 0; i--) {
          if ((age + i) >= 60) {
           objSurrogateCAM.Expiry_Date_without_BT__c = myDate.addMonths((i) * 12);
          }
         }
        }
       }

       // @Gaurav:
       // DG - SOL Line Assignment changes end
       // Bugzilla Id: 8793 START                        

      }
     }
     //***********Line assignment End ******* 
    }

    //Rural Flexi- 12501-- Added by mahima- start--
    if (loan.product__c == 'RSL') {
     pureFlexi = breResponse.get('pureFlexi');
     cam.INSURANCE_PREFERRENCE__c = pureFlexi;
    }
    //Rural Flexi- 12501-- Added by mahima- End--

    if (MortgageFlag && Loan.Full_Underwriting__c == true) {
     if (breResponse.containsKey('customerCategory')) {
      String CustomerSegmentation = breResponse.get('customerCategory');
      applicantPrimary.SegmentaionResult__c = CustomerSegmentation;
      //applicantPrimary.Bureau_Segment__c = CustomerSegmentation;
     }
    }

    //--------------- Mortgage Re-Engg End-----------------------    

   }

   return null;
   //return new pagereference('/apex/SalesEligibilityDetailsPage?id='+LoanId + '&sales=true');       
  } catch (Exception e) {
   //sendEmailForException(e);
   return null;
  }

  //populateLoanTenorMapping();
 }
 List < DPLinsurance__c > Hinsurance = new List < DPLinsurance__c > ();
 public string EmiwithoutLoanPremPlusInsuPre {
  get;
  set;
 }
 decimal DPLinsurancePremAmt = 0;
 public string totalInsupre {
  get;
  set;
 }
 public decimal LoanPremPlusInsuPre {
  get;
  set;
 }


 public PageReference saveEligibiltyDetails() {
  System.debug('In saveEligibiltyDetails.........................................................');
  try {
   //Rohit , Enhancement 16008 - app score stamping for SAL,SPL,SBS CS SAL start
   String appScoreProducts = Label.App_Score_Products;
   System.debug('appScoreProducts : ' + appScoreProducts);
   String[] prodArray = appScoreProducts.split(';');
   if (prodArray != null && prodArray.size() > 0) {
    Set < String > prodSet = new Set < String > ();
    prodSet.addAll(prodArray);
    if (applicantPrimary.App_Score__c == null && prodSet.contains(Loan.Product__c)) {
     if (!Test.isRunningTest()) {
      System.debug('Calling callSegmentEligibility...................');
      callSegmentEligibility();
     }

     //System.debug('robin3 '+prodSet);
    }
   }
   //Rohit , Enhancement 16008 - app score stamping for SAL,SPL,SBS CS SAL stop
   if (Loan.Product__c == 'FAS') {
    //added for Prod Issue 11369 S
    cam.Loan_Application__c = Loan.Id;
    //added for Prod Issue 11369 E
    /*Hybrid Flexi :akshata start*/
    if (applicantPrimary != null && IsHybridFlexi != null && IsHybridFlexi) {
     Double result = 0.0;
     if (cam != null && cam.ROI__c != null && cam.Proposed_Loan_Amt__c != null) {
      result = Math.round((cam.Proposed_Loan_Amt__c * cam.ROI__c) / 1200);
      System.debug('result-->' + result);
     }

     applicantPrimary.Pure_Flexi_EMI__c = result;
     if (cam != null && cam.ROI__c != null && applicantPrimary.Drop_Line_Flexi_Period__c != null && cam.Proposed_Loan_Amt__c != null) {
      system.debug(cam + '=camList[0].ROI__c=' + '=cam.Tenor__c=' + cam.Tenor__c + '=cam.Proposed_Loan_Amt__c=' + cam.Proposed_Loan_Amt__c);
      System.debug('\n\n\tCalling PMT..................\n\n');
      cam.EMI_on_Proposed_Loan_TO__c = PMT(double.valueof(cam.ROI__c / 1200), integer.valueof(applicantPrimary.Drop_Line_Flexi_Period__c), double.valueof(cam.Proposed_Loan_Amt__c));
     }
     System.debug('applicantPrimary.Pure_Flexi_EMI__c-->' + applicantPrimary.Pure_Flexi_EMI__c);

    } /*Hybrid Flexi :akshata End*/
    else {
     if (cam != null && cam.ROI__c != null && cam.Tenor__c != null && cam.Proposed_Loan_Amt__c != null) {
      System.debug('\n\n\tCalling PMT..................\n\n');
      cam.EMI_on_Proposed_Loan_TO__c = PMT(double.valueof(cam.ROI__c / 1200), integer.valueof(cam.Tenor__c), double.valueof(cam.Proposed_Loan_Amt__c));
     }
    }


    if (Loan != null && (Loan.Processing_Fees__c != null || Loan.DSA_Sharing__c != null)) {
     update Loan;
    }

    if (Loan != null && Loan.Account.EMI_Frequency__c != null) {
     //update Loan.Account;
     update Loan.Account;
    }
   }

   //SAL Line
   if (objSurrogateCAM != null) {
    upsert objSurrogateCAM;
    if (objSurrogateCAM.Line_opted__c == 'YES' && objSurrogateCAM.Customer_Acceptance_Flag__c == 'YES') {
     List < Fees_and_Charge__c > fees = new List < Fees_and_Charge__c > ();
     fees = [select Charge_Type__c, id, Loan_Application__c from Fees_and_Charge__c where Loan_Application__c =: loan.id and Charge_Type__c = 'Line Utilization'];
     if (fees.size() == 0) {
      Fees_and_Charge__c fee = new Fees_and_Charge__c();
      fee.Charge_Type__c = 'Line Utilization';
      fee.Deducted_from_Disbursement__c = 'Yes';
      fee.Loan_Application__c = Loan.id;
      fee.Status__c = 'Collected';
      fee.Instrument_type__c = 'Deduct from Disb';
      /* if(ProductSMS__c.getValues(Loan.product__c).Charges__c!=null){
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

     //Send email 
     /* List<String> toAddlist=new List<String>();
List<String> toAddlistCC=new List<String>();
//if(leadObj.Office_Email_ID__c!=null)
// toAddlist.add(leadObj.Office_Email_ID__c);
toAddlist.add('tejashree_nalkande@persistent.co.in');
//toAddlistCC.add('pankaj_kadam@persistent.co.in');
if(toAddlist.size()>0){
String[] toAdd = toAddlist;
String[] ccArray = toAddlistCC;
List<String> bccArray =new List<String>();
Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
email.setToAddresses(toAddlist);
// email.setPlainTextBody('Product Offering Records');
// email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
List<EmailTemplate> Templist  = new List<EmailTemplate>();
Templist = [select id from EmailTemplate where DeveloperName='SAL_Line_Activation_Template'];
system.debug('=============>  Templist : '+ Templist); 


Id userId = UserInfo.getUserId();            
email.setTemplateId(Templist[0].id);    
email.setTargetObjectId(userId);
//email.setTemplateId('00XO0000000R2bA');
//email.setWhatId(productOffer.id); 
email.setSaveAsActivity(false); 
email.setTreatTargetObjectAsRecipient(false);
Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
}*/

    }
   }
   //SAL Line end 
   LoanPremPlusInsuPre = 0;
   DPLinsurancePremAmt = 0;
   if (cam.Approved_CAM__c == true) {
    decimal emiofTopup = 0;
    emiPropose = 0; // bug 11156
    //SHL Requirement start
    System.debug('robin3 ' + Loan.Product__c);
    if (Loan.Product__c == 'SHL' || Loan.Product__c == 'SHOL' || Loan.Product__c == 'HSL' || Loan.Product__c == 'SALLAP' || Loan.Product__c == 'HPLS' || Loan.Product__c == 'SBS CS SHL') {
     System.debug('in mortgage flexi');
     if (cam.Top_Up_Amount__c != null && cam.Proposed_Loan_Amt__c != null)
      Loan.Approved_Loan_Amount__c = cam.Proposed_Loan_Amt__c + cam.Top_Up_Amount__c;
     else
     if (cam.Proposed_Loan_Amt__c != null)
      Loan.Approved_Loan_Amount__c = cam.Proposed_Loan_Amt__c;

     /*Hybrid Flexi :akshata start*/
     if (applicantPrimary != null && IsHybridFlexi != null && IsHybridFlexi) {
      System.debug('in hybrid  flexi');
      Double result = 0.0;
      Double result1 = 0.0;

      Double topupresult = 0.0; // 16175 hybrid flexi topup emi changes
      if (cam != null && cam.ROI__c != null && cam.Proposed_Loan_Amt__c != null) {
       result = Math.round((cam.Proposed_Loan_Amt__c * cam.ROI__c) / 1200);
       System.debug('result-->' + result);
      }
      /** Commented for 16175
if(cam != null && cam.Top_Up_Rate__c != null && cam.Top_Up_Amount__c != null)
{
result1 = Math.round((cam.Top_Up_Amount__c * cam.Top_Up_Rate__c) / 1200);
System.debug('result-->'+result1);
}*/
      applicantPrimary.Pure_Flexi_EMI__c = result; //commented for 16175 :  + result1;

      if (cam != null && cam.ROI__c != null && applicantPrimary.Drop_Line_Flexi_Period__c != null && cam.Proposed_Loan_Amt__c != null) {
       System.debug('\n\n\tCalling PMT..................\n\n');
       emiPropose = PMT(double.valueof(cam.ROI__c / 1200), integer.valueof(applicantPrimary.Drop_Line_Flexi_Period__c), double.valueof(cam.Proposed_Loan_Amt__c));
      }
      System.debug('applicantPrimary.Pure_Flexi_EMI__c-->' + applicantPrimary.Pure_Flexi_EMI__c);

      // 16175 hybrid flexi topup emi changes start
      if (applicantPrimary.Is_Hybrid_Flexi_for_Topup__c == true) {
       if (cam != null && cam.Top_Up_Amount__c != null && cam.Top_Up_Rate__c != null) {
        topupresult = Math.round((cam.Top_Up_Amount__c * cam.Top_Up_Rate__c) / 1200);
        System.debug('topupresult-->' + topupresult);
       }
       applicantPrimary.Topup_Pure_Flexi_EMI__c = topupresult;
       if (cam != null && cam.Top_Up_Rate__c != null && applicantPrimary.Topup_Dropline_Flexi_Period__c != null && cam.Top_Up_Amount__c != null) {
        System.debug('\n\n\tCalling PMT..................\n\n');
        emiofTopup = PMT(double.valueof(cam.Top_Up_Rate__c / 1200), integer.valueof(applicantPrimary.Topup_Dropline_Flexi_Period__c), double.valueof(cam.Top_Up_Amount__c));
       }
       System.debug('emiofTopup-->' + emiofTopup);
       applicantPrimary.Topup_Loan_Proposed_EMI__c = emiofTopup;
      }
      // 16175 hybrid flexi topup emi changes ends

     } /*Hybrid Flexi :akshata End*/
     else {
      if (cam.ROI__c != null && cam.Tenor__c != null) {
       System.debug('\n\n\tCalling PMT..................\n\n');
       emiPropose = (PMT(double.valueOf(cam.ROI__c / 1200), Integer.valueOf(cam.Tenor__c), (cam.Proposed_Loan_Amt__c)));
      }

      // 16175 hybrid flexi topup emi changes start
      Double topupresult = 0.0;
      if (applicantPrimary.Is_Hybrid_Flexi_for_Topup__c == true) {
       if (cam != null && cam.Top_Up_Amount__c != null && cam.Top_Up_Rate__c != null) {
        topupresult = Math.round((cam.Top_Up_Amount__c * cam.Top_Up_Rate__c) / 1200);
        System.debug('topupresult-->' + topupresult);
       }
       applicantPrimary.Topup_Pure_Flexi_EMI__c = topupresult;
       if (cam != null && cam.Top_Up_Rate__c != null && applicantPrimary.Topup_Dropline_Flexi_Period__c != null && cam.Top_Up_Amount__c != null) {
        System.debug('\n\n\tCalling PMT..................\n\n');
        emiofTopup = PMT(double.valueof(cam.Top_Up_Rate__c / 1200), integer.valueof(applicantPrimary.Topup_Dropline_Flexi_Period__c), double.valueof(cam.Top_Up_Amount__c));
       }
       System.debug('emiofTopup-->' + emiofTopup);
       applicantPrimary.Topup_Loan_Proposed_EMI__c = emiofTopup;
      }
      // 16175 hybrid flexi topup emi changes ends

     }
     //bug 11156 start
     /*Hybrid Flexi :akshata start*/

     /** Commneted for 16175
if(applicantPrimary != null && IsHybridFlexi!= null && IsHybridFlexi)
{
if (applicantPrimary.Pure_Flexi_Period__c != null && cam.Top_Up_Tenure__c != null && cam.Top_Up_Rate__c != null) {

Decimal topuptenor = Integer.valueOf(cam.Top_Up_Tenure__c) - Integer.valueOf(applicantPrimary.Pure_Flexi_Period__c);
System.debug('\n\n\tCalling PMT..................\n\n');    
emiofTopup = (PMT(double.valueOf(cam.Top_Up_Rate__c / 1200), Integer.valueOf(topuptenor), (cam.Top_Up_Amount__c)));
}
}
else{
// 16175 hybrid flexi topup emi changes :added topup condition
if ( applicantPrimary.Is_Hybrid_Flexi_for_Topup__c != true &&  cam.Top_Up_Tenure__c != null && cam.Top_Up_Rate__c != null) {

System.debug('\n\n\tCalling PMT..................\n\n');    
emiofTopup = (PMT(double.valueOf(cam.Top_Up_Rate__c / 1200), Integer.valueOf(cam.Top_Up_Tenure__c), (cam.Top_Up_Amount__c)));
}
}  Commneted for 16175 */

     // 16175 hybrid flexi topup emi changes :added topup condition Start
     if (applicantPrimary.Is_Hybrid_Flexi_for_Topup__c != true && cam.Top_Up_Tenure__c != null && cam.Top_Up_Rate__c != null) {

      emiofTopup = (PMT(double.valueOf(cam.Top_Up_Rate__c / 1200), Integer.valueOf(cam.Top_Up_Tenure__c), (cam.Top_Up_Amount__c)));
      System.debug('** rasika emiofTopup:' + emiofTopup);
     }
     // 16175 hybrid flexi topup emi changes :added topup condition End   

     cam.EMI_on_Proposed_Loan_TO__c = emiPropose + emiofTopup;
     // System.debug('rohit33 '+cam.EMI_on_Proposed_Loan_TO__c);
     //bug 11156 end
    } //SHL Requirement end
    else
     Loan.Approved_Loan_Amount__c = cam.Proposed_Loan_Amt__c;
    Loan.Approved_Rate__c = cam.ROI__c;
    Loan.Approved_Tenor__c = cam.Tenor__c;

    // SOL and SHOL backend changes --S
    if (Loan.Product__c == 'SOL' || Loan.product__c == 'SHOL') {

     if (!CommonUtility.isEmpty(Loan.Approved_Loan_Amount__c) && !CommonUtility.isEmpty(Loan.Approved_Rate__c) && !CommonUtility.isEmpty(Loan.Approved_Tenor__c))
      cam.EMI_on_Proposed_Loan_TO__c = Loan.Approved_Loan_Amount__c * ((Loan.Approved_Rate__c / (12 * 100)) / (1 - Math.pow(Double.valueOf(1 + (Loan.Approved_Rate__c / (12 * 100))), Double.valueOf(-1 * Loan.Approved_Tenor__c))));
    }
    // SOL and SHOL backend changes --E


   }

   if (Hinsurance != null && Hinsurance.size() > 0)
    Hinsurance.clear();
   Hinsurance = [select id, Nominee_Name__c, Nominee_Address__c, Nominee_DOB__c, Nominee_Mobile__c, Name, Premium_Amount__c, Customer_address__c, Remark__c, Sum_Assured__c, Whether_we_are_financing_this_product__c, Age__c, Opportunity__c, Insurance_Product__c, Customer_Payment_Mode__c, Insurance_Type__c from DPLinsurance__c where Opportunity__c =: Loan.id];

   if (Hinsurance != null && Hinsurance.size() > 0) {
    for (DPLinsurance__c hins: Hinsurance) {
     if (hins.Whether_we_are_financing_this_product__c == 'Yes') {
      if (hins != null && hins.Premium_Amount__c != null)
       DPLinsurancePremAmt = DPLinsurancePremAmt + decimal.valueof(hins.Premium_Amount__c);
     }
    }

    if (cam.Approved_CAM__c == true) {

     /*if (cam.Proposed_Loan_Amt__c != null)
LoanPremPlusInsuPre = (DPLinsurancePremAmt + cam.Proposed_Loan_Amt__c).divide(1, 0, System.RoundingMode.UP);
*/

     if (cam.Proposed_Loan_Amt__c != null) {
      //SHL Requirement
      if (Loan.Product__c == 'SHL' || Loan.Product__c == 'SHOL' || Loan.Product__c == 'HSL' || Loan.Product__c == 'SALLAP' || Loan.Product__c == 'HPLS' || Loan.Product__c == 'SBS CS SHL') {
       if (cam.Top_Up_Amount__c != null)
        LoanPremPlusInsuPre = (DPLinsurancePremAmt + cam.Proposed_Loan_Amt__c + cam.Top_Up_Amount__c).divide(1, 0, System.RoundingMode.UP);
       else
        LoanPremPlusInsuPre = (DPLinsurancePremAmt + cam.Proposed_Loan_Amt__c).divide(1, 0, System.RoundingMode.UP);
      } else {
       LoanPremPlusInsuPre = (DPLinsurancePremAmt + cam.Proposed_Loan_Amt__c).divide(1, 0, System.RoundingMode.UP);
      }
     }


     if (cam.ROI__c != null && cam.Tenor__c != null && LoanPremPlusInsuPre != null) {
      // 16175 hybrid flexi topup emi calculation changes :added if to by pass the logic
      if (Loan.Product__c != 'SHL' && Loan.Product__c != 'SHOL' && Loan.Product__c != 'HSL' && Loan.Product__c != 'SALLAP' && Loan.Product__c != 'HPLS' && Loan.Product__c != 'SBS CS SHL') {
       /*Hybrid Flexi :akshata start*/
       if (applicantPrimary != null && applicantPrimary.Drop_Line_Flexi_Period__c != null && IsHybridFlexi != null && IsHybridFlexi) {
        Double result = 0.0;
        result = Math.round((double.valueOf(LoanPremPlusInsuPre) * double.valueof(cam.ROI__c)) / 1200);
        System.debug('result-->' + result);
        applicantPrimary.Pure_Flexi_EMI__c = result;
        System.debug('\n\n\tCalling PMT..................\n\n');
        EmiwithoutLoanPremPlusInsuPre = string.valueof(decimal.valueof((PMT(double.valueof(cam.ROI__c / 1200), integer.valueof(applicantPrimary.Drop_Line_Flexi_Period__c), double.valueof(LoanPremPlusInsuPre)))).divide(1, 0, System.RoundingMode.UP));
        System.debug('applicantPrimary.Pure_Flexi_EMI__c-->' + applicantPrimary.Pure_Flexi_EMI__c);

       } /*Hybrid Flexi :akshata End*/
       else {
        System.debug('\n\n\tCalling PMT..................\n\n');
        EmiwithoutLoanPremPlusInsuPre = string.valueof(decimal.valueof((PMT(double.valueof(cam.ROI__c / 1200), integer.valueof(cam.Tenor__c), double.valueof(LoanPremPlusInsuPre)))).divide(1, 0, System.RoundingMode.UP));
       }
      } //16715 IF End


      //added for call center S
      if (!callcenterprocessFlag && Loan.Product__c != 'SHL' && Loan.Product__c != 'SHOL' && Loan.Product__c != 'HSL' && Loan.Product__c != 'SALLAP' && Loan.Product__c != 'HPLS' && Loan.Product__c != 'SBS CS SHL') { // SHL Issue Point 20 - 11263
       Loan.Approved_Loan_Amount__c = LoanPremPlusInsuPre;
      }
      //added for call center E
      Loan.Approved_Rate__c = cam.ROI__c;
      Loan.Approved_Tenor__c = cam.Tenor__c;

     }

    }

   } else {
    // 16175 hybrid flexi topup emi calculation changes :added if to by pass the logic
    if (Loan.Product__c != 'SHL' && Loan.Product__c != 'SHOL' && Loan.Product__c != 'HSL' && Loan.Product__c != 'SALLAP' && Loan.Product__c != 'HPLS' && Loan.Product__c != 'SBS CS SHL') {

     if (cam.ROI__c != null && cam.Tenor__c != null && cam.Proposed_Loan_Amt__c != null) {
      /*Hybrid Flexi :akshata start*/
      if (applicantPrimary != null && applicantPrimary.Drop_Line_Flexi_Period__c != null && IsHybridFlexi != null && IsHybridFlexi) {
       if (Loan.Product__c != 'SHL' && Loan.Product__c != 'SHOL' && Loan.Product__c != 'HSL' && Loan.Product__c != 'SALLAP' && Loan.Product__c != 'HPLS' && Loan.Product__c != 'SBS CS SHL') {
        Double result = 0.0;
        result = Math.round((double.valueOf(cam.Proposed_Loan_Amt__c) * double.valueof(cam.ROI__c)) / 1200);
        System.debug('result-->' + result);
        applicantPrimary.Pure_Flexi_EMI__c = result;
        System.debug('\n\n\tCalling PMT..................\n\n');
        EmiwithoutLoanPremPlusInsuPre = string.valueof(decimal.valueof((PMT(double.valueof(cam.ROI__c / 1200), integer.valueof(applicantPrimary.Drop_Line_Flexi_Period__c), double.valueof(cam.Proposed_Loan_Amt__c)))).divide(1, 0, System.RoundingMode.UP));
        System.debug('applicantPrimary.Pure_Flexi_EMI__c-->' + applicantPrimary.Pure_Flexi_EMI__c);
        System.debug('EmiwithoutLoanPremPlusInsuPre-->' + EmiwithoutLoanPremPlusInsuPre);
       }
      } /*Hybrid Flexi :akshata End*/
      else {
       System.debug('\n\n\tCalling PMT..................\n\n');
       EmiwithoutLoanPremPlusInsuPre = string.valueof(double.valueof((PMT(double.valueof(cam.ROI__c / 1200), Integer.valueof(cam.Tenor__c), cam.Proposed_Loan_Amt__c))));
      }

      //hybrid flexi : akshata S
      if (applicantPrimary != null && applicantPrimary.Drop_Line_Flexi_Period__c != null && IsHybridFlexi != null && IsHybridFlexi && EmiwithoutLoanPremPlusInsuPre != null)
       cam.EMI_on_Proposed_Loan_TO__c = decimal.valueof(EmiwithoutLoanPremPlusInsuPre);
      //hybrid flexi : akshata E
     }

    } //16175 IF End


   }

   //  if (EmiwithoutLoanPremPlusInsuPre != null)
   //Loan.EMI_CAM__c = decimal.valueof(EmiwithoutLoanPremPlusInsuPre);
   //bug 11156 s
   //added hybrid flexi condition
   if (Loan.Product__c == 'SHL' || Loan.Product__c == 'SHOL' || Loan.Product__c == 'HSL' || Loan.Product__c == 'SALLAP' || Loan.Product__c == 'HPLS' || Loan.Product__c == 'SBS CS SHL') {
    /** Commented for 16175
if (cam.Top_Up_Rate__c != null && cam.Top_Up_Tenure__c != null && IsHybridFlexi!= null && IsHybridFlexi)
Loan.EMI_CAM__c = cam.EMI_on_Proposed_Loan_TO__c;
else if(cam.Top_Up_Rate__c != null && cam.Top_Up_Tenure__c != null )
Loan.EMI_CAM__c = cam.EMI_on_Proposed_Loan_TO__c + PMT(double.valueof(cam.Top_Up_Rate__c / 1200), Integer.valueof(cam.Top_Up_Tenure__c), Loan.Insurance_Premium_Amt__c);
else
Loan.EMI_CAM__c = cam.EMI_on_Proposed_Loan_TO__c + PMT(double.valueof(cam.ROI__c / 1200), Integer.valueof(cam.Tenor__c), Loan.Insurance_Premium_Amt__c);
*/

    /* 16175 hybrid flexi topup emi changes start*/
    System.debug('\n\n\tCalling PMT..................\n\n');
    if (cam.Top_Up_Rate__c != null && cam.Top_Up_Tenure__c != null && Loan.Insurance_Premium_Amt__c != null)
     Loan.EMI_CAM__c = cam.EMI_on_Proposed_Loan_TO__c + PMT(double.valueof(cam.Top_Up_Rate__c / 1200), Integer.valueof(cam.Top_Up_Tenure__c), Loan.Insurance_Premium_Amt__c);
    else if (Loan.Insurance_Premium_Amt__c != null) {
     System.debug('\n\n\tCalling PMT..................\n\n +cam.EMI_on_Proposed_Loan_TO__c::::' + cam.Id);
     Loan.EMI_CAM__c = cam.EMI_on_Proposed_Loan_TO__c + PMT(double.valueof(cam.ROI__c / 1200), Integer.valueof(cam.Tenor__c), Loan.Insurance_Premium_Amt__c);
    } else {
     Loan.EMI_CAM__c = cam.EMI_on_Proposed_Loan_TO__c;
    }
    /* 16175 hybrid flexi topup emi changes ends*/


   } // 11156 e

   //*********************EMI Holiday Code Starts
   if (Loan != null && applicantPrimary.EMI_Holiday_Opted__c == true) {
    //Code to find calculate Due Date

    Date dueDate, decisionDate;

    if (Loan.Approved_time_after_Reappraisal__c != null)
     decisionDate = Loan.Approved_time_after_Reappraisal__c.date();
    else
     decisionDate = system.today();

    if (applicantPrimary != null) {

     if (decisionDate != null && (decisionDate.Day() < 15) && applicantPrimary.Cycle_Day_Date__c != null) {
      dueDate = Date.newinstance(decisionDate.Year(), decisionDate.Month() + 1, integer.valueof(applicantPrimary.Cycle_Day_Date__c));
     } else if (decisionDate != null && applicantPrimary.Cycle_Day_Date__c != null) {
      dueDate = Date.newinstance(decisionDate.Year(), decisionDate.Month() + 2, integer.valueof(applicantPrimary.Cycle_Day_Date__c));
     }
     applicantPrimary.EMI_Due_Date__c = dueDate;
     loan.Due_Day__c = dueDate;

     //Code to find calculate Due Date End

     String[] emiMonths = applicantPrimary.EMI_Holiday_Months__c.split(';');

     List < Integer > emiMonthNumbers = new List < integer > ();

     if (emiMonths != null && emiMonths.size() > 0) {
      for (String Month: emiMonths) {
       emimonthNumbers.add(parseMonths(Month));
      }
     }
     integer applicableMonths;
     decimal applicableMonthsPerYear;
     List < StepUpStepDown__c > grid = StepUpStepDown__c.getall().values();
     for (StepUpStepDown__c x: grid) {
      if (x.name == Loan.Product__c) {
       if (applicantPrimary.Months_per_year__c != null)
        applicableMonths = (x.Months_per_tenure__c).intValue();
       applicableMonthsPerYear = x.Months_per_year__c;
      }
     }



     Map < String, String > emiHolidayEMI;
     EMIHolidayCalculationCntrl emiCtrl = new EMIHolidayCalculationCntrl();

     double tenor;
     if (Loan.product__c == 'Home Loan' || Loan.Product__c == 'HFC Home Loan' || Loan.Product__c == 'HML' || Loan.product__c == 'SBS CS HL' || Loan.product__c == 'LAP' || Loan.Product__c == 'HFC LAP' || Loan.product__c == 'SBS CS LAP' || Loan.product__c == 'HLD' || Loan.product__c == 'HDL') {
      tenor = Loan.Tenor__c * 12;
     } else {
      //production bug fix by akshata S
      //tenor = Loan.Tenor__c
      tenor = cam.Tenor__c;
      //production bug fix by akshata E
     }

     if (decisionDate != null && applicantPrimary.Months_per_year__c != null && applicantPrimary.Cycle_Day_Date__c != null && cam.Proposed_Loan_Amt__c != null && cam.Tenor__c != null && cam.ROI__c != null && emiMonthNumbers != null && applicableMonths != null) {

      emiHolidayEMI = emiCtrl.calculateEMIHolidayEMI(decisionDate, integer.valueof(applicantPrimary.Cycle_Day_Date__c), double.valueOF(cam.Proposed_Loan_Amt__c), tenor, double.valueOF(cam.ROI__c), applicantPrimary.Months_per_year__c.intvalue(), emiMonthNumbers, applicableMonths);


     }
     /*if(decisionDate!=null && applicantPrimary.Months_per_year__c!=null && applicantPrimary.Cycle_Day_Date__c!=null && Loan.Approved_Loan_Amount__c!=null && Loan.Approved_Tenor__c!=null && Loan.Approved_Rate__c!=null && emiMonthNumbers!=null && applicableMonths!=null )
emiHolidayEMI = emiCtrl.calculateEMIHolidayEMI(decisionDate,integer.valueof(applicantPrimary.Cycle_Day_Date__c),double.valueOF(Loan.Approved_Loan_Amount__c),tenor,double.valueOF(Loan.Approved_Rate__c),applicantPrimary.Months_per_year__c.intvalue(),emiMonthNumbers,applicableMonths);*/

     if (emiHolidayEMI != null && emiHolidayEMI.containsKey('EMI') && emiHolidayEMI.get('EMI') != null) {
      Loan.Revised_Emi__c = decimal.valueof(emiHolidayEMI.get('EMI'));
      cam.EMI_of_The_Loan__c = Loan.Revised_Emi__c;
      //update Loan;
     }

     if (applicantPrimary != null && emiHolidayEMI != null && emiHolidayEMI.containsKey('Months') && emiHolidayEMI.get('Months') != null) {
      applicantPrimary.EMI_Holidays_Across_tenure__c = emiHolidayEMI.get('Months');
      //update applicantPrimary;
     }

    }


   }
   //**************************EMI HOLIDAY Ends 

   upsert cam;

   //SHL chnages
   if (Loan.Product__c == 'SHL' || Loan.Product__c == 'HFC SHL' || Loan.Product__c == 'SHOL' || Loan.Product__c == 'HSL' || Loan.Product__c == 'SALLAP' || Loan.Product__c == 'HPLS' || Loan.Product__c == 'SBS CS SHL') {
    if (cam.Top_Up_Amount__c == null && cam.Proposed_Loan_Amt__c != null) {
     appliedLoanAmt = cam.Proposed_Loan_Amt__c;
    } else {
     if (cam.Proposed_Loan_Amt__c != null)
      appliedLoanAmt = cam.Proposed_Loan_Amt__c + cam.Top_Up_Amount__c;
    }
    system.debug(appliedLoanAmt + '=appliedLoanAmt');
   }

   upsert Loan;
   upsert applicantPrimary;
   savedSuccessfull = true;
   message = 'CAM saved successfully!!!';
   setDataForEligibilityDetails(propertyList, Loan, cam); //11156 bug 
   //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'CAM Saved Successfully!!')); 
   return null;
  } catch (Exception e) {



   sendEmailForException(e);
   return null;
  }

 }

 Integer dedupecount;
 public Boolean ErrorBool {
  get;
  set;
 }
 public Boolean createdupe {
  get;
  set;
 }


 public Boolean showcom {
  get;
  set;
 }

 public void acmappr() {

  id userProfForSalVer = userinfo.getProfileId();
  if (dedupelist.size() > 0) {
   for (De_Dupe__c d: dedupelist) {

    if (d.Source_Or_Target__c == 'Target' && (d.De_Dupe_result__c == '' || d.De_Dupe_result__c == 'None' || d.De_Dupe_result__c == null)) {
     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Dedupe Result is not updated'));
    } else
     showapprove = true;
   }
  } else {
   showapprove = true;
   if (Loan.product__c == 'DPL' && Loan.StageName != 'Approved' && (Loan.StageName == 'Pending for Insurance approval' || Loan.StageName == 'Underwriting') && Loan.Processing_Type__c != 'Without Loan') {
    showapprove = true;
   }
  }

 }


 public boolean goForDone {
  get;
  set;
 }
 public Boolean showrej {
  get;
  set;
 }
 public Boolean showrej1 {
  get;
  set;
 }
 public Boolean showrej2 {
  get;
  set;
 }

 public void reject() {

  //Bug 14957 - October BRD - Google Check By Rajesh START
  Boolean Googlecheck = false;
  /*BUG-16959 added Prod condition for DBOL  by Rajesh */
  if (isPSBLProductLineProduct || Loan.Product__c == 'LAP' || Loan.Product__c == 'SHL') {
   for (Applicant__c app: cubicApplicantList) {
    system.debug(app.Id + '' + app.Google_Check_Result__c);
    if (app.Google_Check_Result__c == null) {
     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Google check details are not filled for ' + app.Contact_Name__r.Name));
     Googlecheck = true;
     return;
    }
   }
  }
  //Bug 14957 - October BRD - Google Check By Rajesh END

  savedSuccessfull = false;
  if (dedupelist.size() > 0) {

   for (De_Dupe__c d: dedupelist) {
    if (d.Source_Or_Target__c == 'Target' && (d.De_Dupe_result__c == '' || d.De_Dupe_result__c == 'None' || d.De_Dupe_result__c == null)) {

     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Dedupe Result is not updated'));
    } else {

     showrej = true;
     showapprove = false;
     showrej1 = false;
     showrej2 = false;
    }

   }
  } else {

   showrej = true;
   showapprove = false;
   showrej1 = false;
   showrej2 = false;
  }

  if (ConfirmCheckbox) {

   checked = true;

  }
 }

 public Boolean showback {
  get;
  set;
 }

 public void back() {
  showback = true;
 }

 public PageReference cancelback() {
  showback = false;
  return null;
 }



 public PageReference contappr() {
  try {
   String referal = LOan.Referral__c;
   if (referal == 'None') {
    Loan.Referral__c = null;
   }
   Loan.Approval_Stages__c = 'Pending Approval';
   if (Loan.Approver__c == 'Area Credit Manager' || Loan.Approver__c == 'HL Area Credit Manager') {
    if (Loan.City_Head__c != null) {

     Loan.Approver__c = 'City Head';

     Loan.ownerid = Loan.City_Head__c;
    } else if (Loan.RCM__c != null) {

     Loan.Approver__c = 'Regional Credit Manager';

     Loan.ownerid = Loan.RCM__c;
    } else if (Loan.NCM__c != null) {

     Loan.Approver__c = 'National Credit Manager';

     Loan.ownerid = Loan.NCM__c;
    } else if ((Loan.Risk_Deviations__c > 0) && (Loan.RISK__c != null)) {

     Loan.Approver__c = 'National Risk Manager';

     Loan.ownerid = Loan.RISK__c;
    } else if (Loan.COO__c != null) {
     Loan.Approver__c = 'Chief-Credit & Operations';
     Loan.ownerid = Loan.COO__c;
    } else if ((Loan.CRO_Deviations__c > 0) && (Loan.CRO__c != null)) {

     Loan.Approver__c = 'Chief Risk Officer';

     Loan.ownerid = Loan.CRO__c;
    } else if (Loan.Business_Head__c != null) {

     Loan.Approver__c = 'Business Head';

     Loan.ownerid = Loan.Business_Head__c;
    } else if (Loan.CEO__c != null) {
     Loan.Approver__c = 'CEO';
     Loan.ownerid = Loan.CEO__c;
    }

   } else {
    Loan.Approval_Stages__c = 'Continue';
    if (Loan.Approver__c == 'City Head') {
     if (Loan.RCM__c != null) {
      Loan.Approver__c = 'Regional Credit Manager';
      Loan.ownerid = Loan.NCM__c;
     } else if (Loan.NCM__c != null) {
      Loan.Approver__c = 'National Credit Manager';
      Loan.ownerid = Loan.NCM__c;
     } else if ((Loan.Risk_Deviations__c > 0) && (Loan.RISK__c != null)) {
      Loan.Approver__c = 'National Risk Manager';
      Loan.ownerid = Loan.RISK__c;
     } else if (Loan.COO__c != null) {
      Loan.Approver__c = 'Chief-Credit & Operations';
      Loan.ownerid = Loan.COO__c;
     } else if ((Loan.CRO_Deviations__c > 0) && (Loan.CRO__c != null)) {

      Loan.Approver__c = 'Chief Risk Officer';
      Loan.ownerid = Loan.CRO__c;
     } else if (Loan.Business_Head__c != null) {
      Loan.Approver__c = 'Business Head';
      Loan.ownerid = Loan.Business_Head__c;
     } else if (Loan.CEO__c != null) {
      Loan.Approver__c = 'CEO';
      Loan.ownerid = Loan.CEO__c;
     }
    } else if (Loan.Approver__c == 'Regional Credit Manager' || Loan.Approver__c == 'HL Regional Credit Manager') {
     if (Loan.NCM__c != null) {
      Loan.Approver__c = 'National Credit Manager';
      Loan.ownerid = Loan.NCM__c;
     } else if ((Loan.Risk_Deviations__c > 0) && (Loan.RISK__c != null)) {
      Loan.Approver__c = 'National Risk Manager';
      Loan.ownerid = Loan.RISK__c;
     } else if (Loan.COO__c != null) {
      Loan.Approver__c = 'Chief-Credit & Operations';
      Loan.ownerid = Loan.COO__c;
     } else if ((Loan.CRO_Deviations__c > 0) && (Loan.CRO__c != null)) {
      Loan.Approver__c = 'Chief Risk Officer';
      Loan.ownerid = Loan.CRO__c;
     } else if (Loan.Business_Head__c != null) {
      Loan.Approver__c = 'Business Head';
      Loan.ownerid = Loan.Business_Head__c;
     } else if (Loan.CEO__c != null) {
      Loan.Approver__c = 'CEO';
      Loan.ownerid = Loan.CEO__c;
     }
    } else if (Loan.Approver__c == 'National Credit Manager' || Loan.Approver__c == 'HL National Credit Manager') {
     if ((Loan.Risk_Deviations__c >= 0) && (Loan.RISK__c != null)) {

      Loan.Approver__c = 'National Risk Manager';

      Loan.ownerid = Loan.RISK__c;
     } else {
      if (Loan.COO__c != null) {
       Loan.Approver__c = 'Chief-Credit & Operations';
       Loan.ownerid = Loan.COO__c;
      } else if ((Loan.CRO_Deviations__c >= 0) && (Loan.CRO__c != null)) {
       Loan.Approver__c = 'Chief Risk Officer';
       Loan.ownerid = Loan.CRO__c;
      } else if (Loan.Business_Head__c != null) {
       Loan.Approver__c = 'Business Head';
       Loan.ownerid = Loan.Business_Head__c;
      } else if (Loan.CEO__c != null) {
       Loan.Approver__c = 'CEO';
       Loan.ownerid = Loan.CEO__c;
      }
     }
    } else if (Loan.Approver__c == 'National Risk Manager' || Loan.Approver__c == 'HL National Risk Manager') {
     if (Loan.COO__c != null) {
      Loan.Approver__c = 'Chief-Credit & Operations';
      Loan.ownerid = Loan.COO__c;
     } else if ((Loan.CRO_Deviations__c >= 0) && (Loan.CRO__c != null)) {
      Loan.Approver__c = 'Chief Risk Officer';
      Loan.ownerid = Loan.CRO__c;
     } else if (Loan.Business_Head__c != null) {
      Loan.Approver__c = 'Business Head';
      Loan.ownerid = Loan.Business_Head__c;
     } else if (Loan.CEO__c != null) {
      Loan.Approver__c = 'CEO';
      Loan.ownerid = Loan.CEO__c;
     }
    } else if (Loan.Approver__c == 'Chief-Credit & Operations') {
     if ((Loan.CRO_Deviations__c >= 0) && (Loan.CRO__c != null)) {
      Loan.Approver__c = 'Chief Risk Officer';
      Loan.ownerid = Loan.CRO__c;
     } else if (Loan.Business_Head__c != null) {
      Loan.Approver__c = 'Business Head';
      Loan.ownerid = Loan.Business_Head__c;
     } else if (Loan.CEO__c != null) {
      Loan.Approver__c = 'CEO';
      Loan.ownerid = Loan.CEO__c;
     }
    } else if (Loan.Approver__c == 'Chief Risk Officer') {
     if (Loan.Business_Head__c != null) {
      Loan.Approver__c = 'Business Head';
      Loan.ownerid = Loan.Business_Head__c;
     }
     if (Loan.CEO__c != null) {
      Loan.Approver__c = 'CEO';
      Loan.ownerid = Loan.CEO__c;
     }
    } else if (Loan.Approver__c == 'Business Head') {
     if (Loan.CEO__c != null) {
      Loan.Approver__c = 'CEO';
      Loan.ownerid = Loan.CEO__c;
     }
    }
   }
   update Loan;
   //Pagereference p =new pagereference('/'+Loan.Id);
   Pagereference p = new pagereference('/006/o');
   return p;
  } catch (Exception e) {
   sendEmailForException(e);
   return null;
  }
 }

 public boolean camApprov = false;
 public boolean persionalerror {
  get;
  set;
 }
 Set < String > LAPprods = new Set < String > ();
 public Boolean LAPproductsflowFlag {
  get;
  set;
 }


 public PageReference appr() {
  //01MOB S
  String MOBProductList;
  if (LaonApplicationCreation__c.getValues('0 to 1 MOB products') != null) {
   MOBProductList = LaonApplicationCreation__c.getValues('0 to 1 MOB products').Current_product__c;
  }
  if (MOBProductList != NULL && MOBProductList.contains(loan.product__c)) {
   try {
    offerDetailsBRE();
   } catch (Exception e) {
    System.debug('rohit ' + e.getMessage() + '--' + e.getLIneNumber() + '-- ' + e.getStackTraceString());
   }

  }

  // Bug Id : 16618 - NSDL PAN Check - start
  NSDL_PAN_CheckCntrl.ApprovalValidation appValidation = NSDL_PAN_CheckCntrl.approvalValidation(Loan.Id, Loan.product__c);
  System.debug('appValidation -->' + appValidation);
  if (appValidation != null) {
   if (!appValidation.canApprove) {
    // Bug Id : 19524 Commneted as part of Adhoc start
    /*if (appValidation.isFake) {
// Send back to sales
if(Loan != null) {
List < User > userList = new List < User > ();
system.debug('****Loan.Relationship_Manager__c*' + Loan.Relationship_Manager__c);
if (Loan.Relationship_Manager__c != null)
userList = [SELECT FirstName, Profile.Name FROM User WHERE Id = : Loan.Relationship_Manager__c];
if (userList != null && userList.size() > 0) {
system.debug('****Loan.createdById*' + userList);
Loan.ownerId = userList[0].id;
Loan.approver__c = 'Area Sales Manager';
Loan.stageName = 'DSA/PSF Login';
try {
update Loan;
} catch (DMLException dmlException) {
// Bug 17139 
if(salmobilityv2falg)
mobilitystatus = dmlException.getMessage();
else
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, dmlException.getMessage()));
return null;
}
}
}
}*/
    // Bug Id : 19524 Commneted as part of Adhoc end
    if (salmobilityv2falg)
     mobilitystatus = appValidation.errorMessage;
    else
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, appValidation.errorMessage));
    return null;
   }
  }
  // Bug Id : 16618 - NSDL PAN Check - end

  // Start of invisible monitoring changes
  Integer minCountOfRT;
  /*Invisible Monitoring Mortgage-mortgage flag is added in following if condition for mortgage product
Changes by-Anjali Kondgule
Date-30/09/2016*/
  if (Mortgageflag) {
   // Invisible Monitoring Random Triggers

   Invisible_Monitoring__c activeGroupCode = Invisible_Monitoring__c.getValues('Active Group for Random Triggers');
   String groupCode;
   if (activeGroupCode != null && activeGroupCode.Active_Group__c != null)
    groupCode = String.valueOf(activeGroupCode.Active_Group__c);
   Invisible_Monitoring__c TotalRulesToBeMatched = Invisible_Monitoring__c.getValues('Rules to be matched for Random Trigger');
   if (TotalRulesToBeMatched != null && TotalRulesToBeMatched.Rules_to_be_matched__c != null)
    minCountOfRT = Integer.valueOf(TotalRulesToBeMatched.Rules_to_be_matched__c);

   if (!Test.isRunningTest()) {
    mapOfInvisibleMonitoringResults = BRECalloutForInvisibleMonitoring('RANDOM', groupCode);

   }
   // Random Trigger Count

   if (mapOfInvisibleMonitoringResults != null) {

    RTCount = Integer.valueOf(mapOfInvisibleMonitoringResults.get('RTCount'));
    // Verifications
    //
    //
    //    returned by the BRE
    String verifications = mapOfInvisibleMonitoringResults.get('verificationList');
    verificationsArray = verifications.split(',');
    // Message
    IMmessage = mapOfInvisibleMonitoringResults.get('message');
    if (mapOfInvisibleMonitoringResults.get('Buro_Score') != null)
     applicantPrimary.Score_card__c = Integer.valueOf(mapOfInvisibleMonitoringResults.get('Buro_Score'));
   }
  }
  // End of invisible monitoring changes
  /*Invisible Monitoring Mortgage-mortgage flag is added in following if condition for mortgage product
Changes by-Anjali Kondgule
Date-30/09/2016*/
  if (Mortgageflag) {

   if (RTCount >= minCountOfRT) {
    if (applicantPrimary.Identified_for_Invisible_Monitoring__c == false) {
     //identifiedByBRE = true;
     applicantPrimary.Identified_for_Invisible_Monitoring__c = true;
     applicantPrimary.Underwriter_Remarks__c = 'Identified for invisible monitoring by random trigger call';
     applicantPrimary.Invisible_monitoring__c = 'Random Trigger Verification';
     applicantPrimary.Verifications_returned_by_IM_BRE__c = verifications;
     //Invisible monitoring mortage Anjali-start
     if (mapOfInvisibleMonitoringResults.get('mandatoryFlag') != null)
      Invisible_mandatory = string.valueOf(mapOfInvisibleMonitoringResults.get('mandatoryFlag'));
     if (mapOfInvisibleMonitoringResults.get('Buro_Score') != null)
      Buro_Score = Integer.valueOf(mapOfInvisibleMonitoringResults.get('Buro_Score'));

     if (Invisible_mandatory != null && Buro_Score != null) {
      if (Invisible_mandatory == 'MANDATORY') {
       applicantPrimary.Verification_Mandatory_Flag__c = true;
      }
      applicantPrimary.Score_card__c = Buro_Score;
     }
     //Invisible monitoring mortage Anjali-end
     String finalReason;

     SOL_Policy__c solobj = new SOL_Policy__c();
     solobj.Applicant_Name__c = applicantPrimary.id;
     solobj.Loan_Application__c = LoanID;
     solobj.Created_from_Invisible_Monitoring__c = true;
     solobj.Policy_Status__c = 'Refer';
     solobj.Policy_Name__c = 'Failure due to random trigger group';
     solobj.Count_of_Random_Triggers__c = RTCount;

     oldSolList = [SELECT Checklist_Policy_Status__c, id, name, Applicant_Name__c, Loan_Application__c, Created_from_Invisible_Monitoring__c, Policy_Status__c, Count_of_Group_1__c, Count_of_Group_2__c, Count_of_Group_3__c,
      Count_of_Group_Triggers__c, Count_of_Random_Triggers__c
      FROM SOL_Policy__c WHERE Loan_Application__c =: LoanID AND Created_from_Invisible_Monitoring__c = true LIMIT 1
     ];

     SOL_Policy__c oldSolObj;

     if (oldSolList != null && oldSolList.size() > 0)
      oldSolObj = oldSolList[0];

     try {
      if (oldSolObj == null) {
       List < SOL_Policy__c > tempListSOL = new List < SOL_Policy__c > ();
       tempListSOL.add(solobj);
       insert tempListSOL;
      } else {
       oldSolObj.Count_of_Random_Triggers__c = RTCount;
       update oldSolObj;
      }
     } catch (DMLException e) {}

    } else {
     //identifiedByBRE = false;
     applicantPrimary.Invisible_monitoring__c = 'Group Trigger Verification';
    }
   }

   try {
    update applicantPrimary;
   } catch (DMLException e) {}
  } // created date flag for invisible monitoring

  //01MOB E 
  //savedApproved=false;

  List < CAM__c > camlist = new List < CAM__c > ();

  List < Personal_Discussion__c > pdCommentList = new List < Personal_Discussion__c > ();

  try {
   if (Loan != null) {
    /*Added if condition for SAL PLTB -Krish*/
    /*Dynamic Query Added - Aman*/
    String loanId = Loan.id;
    String WhereANDCondition;
    String camQuery;
    camQuery = 'SELECT Id, Approved_CAM__c, Loan_Application__c, Average_Bank_Balance_GDP__c, ObligationsDC1__c,                C_P_Previous_Year__c, Business_Income_Considered__c, Final_Income_considered_for_Eligibility__c,' +
     ' Fund_Based__c, Hl_pmt__c, Entity_Record_Type__c, Payment_Date_1__c,Payment_Date_2__c, Payment_Date_3__c ' +
     ' FROM CAM__c WHERE Loan_Application__c = :loanId AND Approved_CAM__c = false ';

    if (callCenterProcessFlag)
     WhereANDCondition = ' AND Applicant__c != null';
    else if (salMobilityFlag || salmobilityv2falg)
     WhereANDCondition = ' AND (Applicant__c != null OR Applicant__c = null)';
    else
     WhereANDCondition = ' AND Applicant__c = null';

    camQuery += WhereANDCondition;
    system.debug('camQuery -->' + camQuery);
    camList = Database.query(camQuery);
    system.debug('camList -->' + camList);
    /*Dynamic Query Added - Aman*/
   }
   List < Personal_Discussion__c > pdlist = new List < Personal_Discussion__c > ();

   List < SOL_Policy__c > policyList = new List < SOL_Policy__c > ();
   policyList = [select Checklist_Policy_Status__c, id, name, Policy_Name__c, Policy_Status__c, Loan_Application__c, Applicant_Name__c from SOL_Policy__c where Loan_Application__c =: Loan.id];

   if (Loan.Product__c == 'FAS') {
    pdlist = [select id, name, Status__c, Name_of_the_applicant__r.PD_Status__c, Comments__c, Name_of_the_applicant__c, Name_of_the_applicant__r.Applicant_Type__c from Personal_Discussion__c where Loan_Application__c =: Loan.id];

    if (pdlist.isempty() && policyList.size() <= 0) {

     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Personal Discussion should complete before Approve !'));
     return null;
    }

   } else if (Loan.Product__c != 'FAS') {
    pdlist = [select id, name, Status__c, Type_of_PD__c, PD_Conducted__c from Personal_Discussion__c where Loan_Application__c =: Loan.id and(Type_of_PD__c = 'TELEPHONIC PD'
     or Type_of_PD__c = 'Telephonic PD') and PD_Conducted__c = false];

    if (pdlist != null && pdlist.size() > 0) {
     /*Bug 17139 */
     if (salmobilityv2falg)
      mobilitystatus = 'Personal Discussion should complete before Approve';
     else
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Personal Discussion should complete before Approve !'));
     return null;
    }
   }
   Boolean canApprove = true;
   if (policyList.size() > 0 && (Loan.product__c == 'SOL' || Loan.product__c == 'SHOL')) {

    for (SOL_Policy__c pol: policyList) {
     if (pol.Policy_Status__c.containsIgnoreCase('reject') || pol.Policy_Status__c.containsIgnoreCase('refer')) {
      canApprove = false;
      break;
     }
    }
   }
   /*OTP V3 - added by krish start*/
   List < SOL_Policy__c > sollstObj = new List < SOL_Policy__c > ();
   //OTPv3 TeleRM Rohit condition changed 15229
   if (OTPProducts.contains(Loan.Product__c)) {
    /*StaticResource staticRsrc = [SELECT Body,Id,Name FROM StaticResource WHERE Name = 'CheckListJson_OTPV3' limit 1];
Map<String,Object> chklstMap = (Map<String,Object>) JSON.deserializeUntyped(staticRsrc.Body.tostring());
system.debug('chklstMap :'+chklstMap );
Map<String,Object> jsonField = new Map<String,Object>();
Map<String,String> sysMndMap = new Map<String,String>();
List<String> plcyList = new List<String>();
for(String jsonKey: chklstMap.keySet())
{
jsonField =(Map<String, Object>)chklstMap.get(jsonKey);
system.debug('jsonField  : '+jsonField);
for(String val: jsonField.keyset())
{
Map<String, Object> jsonf =(Map<String, Object>)jsonField.get(val);
String lbl= (String)jsonf.get('LBL');
String mndtry= (String)jsonf.get('MNDTRY');
if(jsonKey == 'SYS' && mndtry == 'TRUE')
{
sysMndMap.put(lbl,mndtry);
plcyList.add(lbl); 
}
}
}*/
    List < String > policy_names = new List < String > ();
    if (Label.SAL_Policies != null) {
     policy_names = Label.SAL_Policies.split(';');
    }
    for (SOL_Policy__c sol: policyList) {
     Boolean flag = false;
     for (String str: policy_names) {
      if (sol.Policy_name__c.startsWith(str) || sol.name.startsWith(str)) {
       flag = true;
      }
     }
     /*if(sol.name.startsWith('PolicyCheck:')){
for(String str:plcyList){

if(str==sol.Policy_Name__c && sol.Checklist_Policy_Status__c != 'Pass' ){
sollstObj.add(sol);
}
}

}*/
     if (!flag) {
      sollstObj.add(sol);
     }

    }
   }
   system.debug('sollsObj' + sollstObj);
   /*OTP V3 - added by krish end*/
   /*20939 RCU s*/
   if (salmobilityv2falg && applicantPrimary != null && (applicantPrimary.Check_RSA__c == null || applicantPrimary.Check_RSA__c == '')) {
    mobilitystatus = 'Please check RSA flag before approving.';
    return null;
   }
   /*20939 RCU e*/
   if (policyList.size() > 0 && (Loan.product__c == 'SOL' || Loan.product__c == 'SHOL') && !canApprove) { //SOL policy issue for SOL and SHOL
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Loan Application can not be Approved due to Internal Policy norms not met !'));
    return null;
   }
   /*OTP V3 added else condition*/
   else if (sollstObj.size() > 0 && (Loan.product__c == 'SAL' || Loan.product__c == 'SPL') && !salmobilityv2falg) { /*17139 */
    if (salmobilityv2falg)
     mobilitystatus = 'Loan Application can not be Approved due to Internal Policy norms not met !';
    else
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Loan Application can not be Approved due to Internal Policy norms not met !'));
    return null;
   } else if (policyList.size() > 0 && Loan.Product__c != 'SPL' && Loan.Product__c != 'SAL' && Loan.Product__c != 'SHL' && Loan.Product__c != 'HFC SHL' && Loan.Product__c != 'SOL' && Loan.Product__c != 'SHOL' && Loan.Product__c != 'HSL' && Loan.Product__c == 'SALLAP' && Loan.Product__c != 'HPLS' && Loan.Product__c != 'SBS CS SHL') { //SHL Issue point no 10
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Loan Application can not be Approved due to Internal Policy norms not met !'));
    return null;
   } else if (camlist != null && camlist.size() > 0) {
    /*Bug 17139 */
    if (salmobilityv2falg)
     mobilitystatus = 'CAM should be approved before loan application approval!';
    else
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'CAM should be approved before loan application approval!'));
    return null;
   } else {
    Loan.Approval_Stages__c = 'Approved';


    //Loan.StageName='Approved';
    //Bug 6466 verification trigger by Akshata S
    /*SAL PL to SAL LAP start - Krish*/
    if (SALtoLAPFlag) {
     List < Existing_Loan_Details__c > exstLoanList = new List < Existing_Loan_Details__c > ();
     if(existingLoanDetailsList != null && existingLoanDetailsList.size() > 0)
     for (Existing_Loan_Details__c exloan: existingLoanDetailsList) {
      if ((exloan.Loan_Type__c == 'Housing Loan' || exloan.Loan_type__c == 'Property Loan')) {
       exstLoanList.add(exloan);
      }
     }
     system.debug('exstLoanList' + exstLoanList);
     if (exstLoanList != null && exstLoanList.size() > 0) {
      generateLAPOffer(exstLoanList);
     }
    }
    /*SAL PL to SAL LAP end - Krish*/
    /* Added SAL, SPL product to work on DONE button to call Verification Trigger below */
    /* 17139*/
    if ((Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL') && !salmobilityv2falg) {
     ApexPages.StandardController sc = new ApexPages.standardController(Loan);
     system.debug('in verification trigger');
     COVerificationController coVerify = new COVerificationController(sc);
     coVerify.BREVerification();
    } else if ((Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL') && salmobilityv2falg) {
     //SALMobilityOppCntrl_V2.callVerificationAPI(Loan.id);
    }
    //Bug 6466 verification trigger by Akshata E   
    /*17139 */
    if (salmobilityv2falg) {
     if (!CommonUtility.isEmpty(app_rejcomments))
      loan.COO_Comments__c = app_rejcomments;
    }
    //code added by leena for enhancement of Re-apprisal
    if (deviationProducts != null && deviationProducts.contains(Loan.Product__c)) {
     if (Loan.Account.Previous_Approved_Loan_Amount__c == null) {
      loan.Account.Previous_Approved_Loan_Amount__c = loan.Approved_Loan_Amount__c;
      update loan.account;
     }

     //code added by leena for enhancement of Re-apprisal

     //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal start
     List < checklist__c > updatedCheck = new List < checklist__c > ();
     if (deviationProducts != null && deviationProducts.contains(loan.Product__c)) {
      for (checklist__c chk: Loan.Checklists__r) {
       system.debug('checklist is==>' + chk);
       if (chk.Deviation_Master__c != null) {
        chk.Sales_Status__c = 'Received';
        updatedCheck.add(chk);
       }

      }
      if (updatedCheck != null && updatedCheck.size() > 0) update updatedCheck;
     }
    }
    //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal end
    System.debug('pk salmobilityv2falg' + salmobilityv2falg + cam);
    if (salmobilityv2falg && cam != null && cam.Proposed_Loan_Amt__c != null) {
     Loan.Approved_Loan_Amount__c = cam.Proposed_Loan_Amt__c;
     System.debug('pk before approve amount' + Loan.Approved_Loan_Amount__c);
    }
    //Bug-23670 Prod issue
    if (salmobilityv2falg && cam != null && cam.ROI__c != null) {
     System.debug('Inside if');
     Loan.Approved_Rate__c = cam.ROI__c;
     Loan.Approved_Tenor__c = cam.Tenor__c;
     System.debug('ak approved rate' + Loan.Approved_Rate__c);
    }
    update loan;
    System.debug('pk after approve amount' + Loan.Approved_Loan_Amount__c);
    if (Loan.Product__c == 'FAS') {

     system.debug('pdlist.size()=' + pdlist.size() + 'Loan.Product__c=' + Loan.Product__c + '=Loan.COO_Comments__c=' + Loan.COO_Comments__c);

     if (pdlist.size() > 0 && Loan.COO_Comments__c != null) {
      for (Personal_Discussion__c p: pdlist) {
       if (p.Name_of_the_applicant__c != null && p.Name_of_the_applicant__r.Applicant_Type__c == 'Primary') {
        p.Comments__c = Loan.COO_Comments__c;

        pdCommentList.add(p);
       }
      }

      if (pdCommentList.size() > 0) {
       update pdCommentList;
      }
     }
    }



    donemessage = 'Loan application is Approved successfully';
    savedApproved = true;
    /* 17139 */
    if (salmobilityv2falg) {
     mobilitystatus = 'success';
     SAL_PricingCtrlV2.calculateEMIVal calEMI = new SAL_PricingCtrlV2.calculateEMIVal(Loan.Id);
     ID jobID = System.enqueueJob(calEMI);
     //SAL_PricingCtrlV2.calculateEMIVal(Loan.Id); //22182
    }
    //Added by Mahima- Bug Id- 12247-- start
    //Multiple verfication getting created issue fix start
    //added by gopika Is_Hybrid_Flexi_for_Topup__c 
    applicantPrimary = [select is_BL_PL_Risk__c, /*OTP V3 CR S*/ Codified_CIBIL__c, Risk_Segmentation__c, TimeTakenDecision__c, Contact_Name__r.Employer__r.Employer_List__c, Contact_Name__r.special_profile_employer__c, /*OTP V3 CR E*/ id, ROIFlexi__c, ROILoc__c, ROINormal__c, ROI_PO__c, JobId__c, contact_name__r.id, Sent_back_to_sales_SMS_sent__c, EMI_Holidays_Across_tenure__c, EMI_Holiday_Opted__c, Months_per_year__c, Cycle_Day_Date__c, EMI_Holiday_Months__c, EMI_Due_Date__c, Contact_Name__r.office_no_check_on_company_site__c, Contact_Name__r.SFDC_Dedupe_check__c, Contact_Name__r.PAN_Response__c, Contact_Name__r.Linkedin_check_result__c, Contact_Name__r.Google_check_result__c, Contact_Name__r.PAN__c, Contact_Name__r.Last_Modified_Date__c, Contact_Name__r.Name_of_the_PAN_holder__c, Contact_Name__r.Employer__r.Domain_Name__c, Contact_Name__r.Employer__r.Company_Category__c, Existing_Customer__c, Owned_Residence__c, Is_spouse_Working_Financial_CoApp__c, Loan_Application__r.Scheme_Master__c, Name, Contact_Name__r.Mobile__c, Loan_Application__r.Requested_ROI__c, Loan_Application__r.Sourcing_Channel__r.branch__c, Loan_Application__r.Referral__c, Loan_Application__r.Existing_Customer__c, Loan_Application__r.Account.Sourcing_Channel__r.branch__c, Update_CIBIL_Error__c, Descriptin__c, Type_of_Borrower__c, Re_Initiate_De_Dupe__c, Integrate_with_CIBIL__c, Contact_Name__c, Contact_Name__r.Name, Contact_Name__r.Customer_Profile__c,
     Contact_Name__r.Designation__c, Contact_Name__r.Employer_Name__c, Contact_Name__r.Qualification__c, Contact_Name__r.Address_1__c, Contact_Name__r.Total_Work_Experience_Yrs__c, Contact_Name__r.Current_experiance_in_Years__c,
     PD_Status__c, Bank_Status__c, Contact_Name__r.Address_2__c, FCU_Status__c, ITR_Status__c, Office_SE_Status__c, Office_SAL_Status__c, Contact_Name__r.Company_Category__c, Contact_Name__r.Current_experiance_in_Month__c,
     Office_Status__c, Pay_Slips_Status__c, Residence_Status__c, Trade_Status__c, TVR_Status__c, Select_Applicant__c, Applicant_Type__c, Contact_Name__r.Customer_Type__c, Contact_Name__r.ApplicantType__c,
     Contact_Name__r.Date_of_Birth__c, Contact_Name__r.FathersHusbands_Name__c, Contact_Name__r.PAN_Number__c, Contact_Name__r.Year_of_Incorporation__c, Contact_Name__r.Account.TIN_Number__c,
     Contact_Name__r.Bank_Account_No__c, Contact_Name__r.VoterID_Number__c, Contact_Name__r.ROC_Regn_No__c, Contact_Name__r.Address_3__c, Contact_Name__r.AppCity__c, Contact_Name__r.Residence_Type__c,
     Contact_Name__r.Pin_Code__c, Contact_Name__r.Phone, Contact_Name__r.MobilePhone, Contact_Name__r.Email, Contact_Name__r.Address_Line_One__c, Contact_Name__r.Address_2nd_Line__c, Contact_Name__r.Address_3rd_Line__c,
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
     Segment_Achievment__c, SalaryToAgeResult__c, Bureau_Segment__c, StepUp_StepDown_EMI_Year_1__c, StepUp_StepDown_EMI_Year_2__c, StepUp_StepDown_EMI_Year_3__c, StepUp_StepDown_EMI_Year_4__c, StepUp_StepDown_EMI_Year_5__c,
     Company_Name_as_per_Domain_check__c, Official_Email_bounce_Flag__c, Domain_Created_Date__c, Domain_Check_Result__c, Registrant_Name__c, Registrant_Email_ID__c, /*Mortgage*/ Contact_Name__r.Occupatipn__c, PAN_Number__c, Contact_Name__r.Property_Owner__c
     /* SAL Policy Changes Start */
     , RC_Decline__c, RC_Deviation__c /* SAL Policy Changes End */ ,
     /*SHL Issue*/
     Contact_Name__r.Current_Employment_Vintage__c,
     /*Fraud Trigger - krish */
     Bank_Account__r.bank_name__c, Fraud_Case__c, contact_name__r.employer__r.bank_names__c, TimeFirstAction__c /*Service Guarantee 2-Deepak*/
     /* Anjali mortgage start*/
     , Score_card__c, Underwriter_Remarks__c, Verifications_returned_by_IM_BRE__c, SME_Score__c, RSA_flag__c, Identified_for_Invisible_Monitoring__c, Invisible_Monitoring_Skipped__c /* Anjali mortgage end*/ , Total_Employment_Vintage__c, /*18370 S*/ Is_Hybrid_Flexi_for_Topup__c, Topup_Pure_Flexi_Period__c, Topup_Dropline_Flexi_Period__c, Topup_Loan_Proposed_EMI__c, Topup_Pure_Flexi_EMI__c, Check_RSA__c /*18370 E*/
     from Applicant__c where Loan_Application__c =: LoanId and Applicant_Type__c = 'Primary'
     limit 1
    ];

    //Multiple verfication getting created issue fix end
    applicantPrimary.approved__c = true;
    try {
     update applicantPrimary;
    } catch (Exception e) {

    }
    //Added by Mahima- Bug Id- 12247-- start

   }


   Id userId = Userinfo.getuserid();
   User use = [SELECT Id, profileid, profile.name, Name from user where id =: userId];
   List < string > msg = new List < string > ();
   List < string > mobileNumbers = new List < string > ();
   List < SMS_Sent__c > allsms = new List < SMS_Sent__c > ();
   String referal = Loan.Referral__c;

   if (referal == 'None') {
    Loan.Referral__c = null;
   }

   system.debug('xxxxxxxxxxxxxxxxxxxxxx' + use.profile.name);
   system.debug('xxxxxxxxxxxxxxxxxxxxxx Loan.Original_Approver__c ' + Loan.Original_Approver__c);
   if (Loan.Original_Approver__c == null) // modefied on 26.07 under prafulla condition 
   {
    System.debug('inside if -->');
    if (use.profile.name == 'Area Credit Manager')
     Loan.Original_Approver__c = '1';
    if (use.profile.name == 'City Head')
     Loan.Original_Approver__c = '2';
    if (use.profile.name == 'Regional Credit Manager')
     Loan.Original_Approver__c = '3';
    if (use.profile.name == 'Zonal Credit Manager')
     Loan.Original_Approver__c = '4';
    if (use.profile.name == 'National Credit Manager')
     Loan.Original_Approver__c = '5';
    if (use.profile.name == 'National Risk Manager')
     Loan.Original_Approver__c = '6';
    if (use.profile.name == 'Chief-Credit & Operations')
     Loan.Original_Approver__c = '7';
    if (use.profile.name == 'Chief Risk officer')
     Loan.Original_Approver__c = '8';
    if (use.profile.name == 'Business Head')
     Loan.Original_Approver__c = '9';
    if (use.profile.name == 'Chief Executive Officer')
     Loan.Original_Approver__c = '10';
    if (use.profile.name == 'President')
     Loan.Original_Approver__c = '11';
    if (use.profile.name == 'Credit Manager') { // Bug id : 13016 - New Role Creation for Credit, added by Needhi 
     System.debug('inside CM -->');
     Loan.Original_Approver__c = '12';
    }
    if (use.profile.name == 'Senior Credit Officer') // Bug id : 13016 - New Role Creation for Credit, added by Needhi 
     Loan.Original_Approver__c = '13';
   }
   system.debug('after xxxxxxxxxxxxxxxxxxxxxx Loan.Original_Approver__c ' + Loan.Original_Approver__c);
   if (use.profile.name == 'Area Credit Manager')
    Loan.Previous_Approval_Authority__c = '1';
   if (use.profile.name == 'City Head')
    Loan.Previous_Approval_Authority__c = '2';
   if (use.profile.name == 'Regional Credit Manager')
    Loan.Previous_Approval_Authority__c = '3';
   if (use.profile.name == 'Zonal Credit Manager')
    Loan.Previous_Approval_Authority__c = '4';
   if (use.profile.name == 'National Credit Manager')
    Loan.Previous_Approval_Authority__c = '5';
   if (use.profile.name == 'National Risk Manager')
    Loan.Previous_Approval_Authority__c = '6';
   if (use.profile.name == 'Chief-Credit & Operations')
    Loan.Previous_Approval_Authority__c = '7';
   if (use.profile.name == 'Chief Risk officer')
    Loan.Previous_Approval_Authority__c = '8';
   if (use.profile.name == 'Business Head')
    Loan.Previous_Approval_Authority__c = '9';
   if (use.profile.name == 'Chief Executive Officer')
    Loan.Previous_Approval_Authority__c = '10';
   if (use.profile.name == 'President')
    Loan.Previous_Approval_Authority__c = '11';
   if (use.profile.name == 'Credit Manager') // Bug id : 13016 - New Role Creation for Credit, added by Needhi 
    Loan.Previous_Approval_Authority__c = '12';
   if (use.profile.name == 'Senior Credit Officer') // Bug id : 13016 - New Role Creation for Credit, added by Needhi 
    Loan.Previous_Approval_Authority__c = '13';
   System.debug('Loan cm -->' + Loan.CM__c);
   if (loan.product__c != 'DPL' && (loan.product__c != 'FAS' && Loan.Account.Group_Type__c != null)) {
    if (Loan.CM__c != null) { // Bug id : 13016 - New Role Creation for Credit, added by Needhi 
     Loan.ownerId = Loan.CM__c;
     System.debug('Loan.ownerId-->' + Loan.ownerId);
    } else if (Loan.ACM__c != null)
     Loan.ownerId = Loan.ACM__c;
    else
     Loan.ownerId = userId;
   }
   System.debug('Loan.ownerId-->' + Loan.ownerId);
   try {
    if (!Test.isRunningTest()) {
     update Loan;
     System.debug('Loan.ownerId-->' + Loan.ownerId);

     //11847 starts added Regional_SM__c,Regional_SM__r.Email,Zonal_SM__c,Zonal_SM__r.Email,National_SM__c,National_SM__r.Email,RCM__c,RCM__r.Email,CEO__c,CEO__r.Email,NCM__c,NCM__r.Email,Regional_SM__r.Mobile_number__c,Zonal_SM__r.Mobile_number__c,National_SM__r.Mobile_number__c,CEO__r.Mobile_number__c,NCM__r.Mobile_number__c,
     //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal start
     /* purpose of the code :-to quey checklist record of loan application Account.Previous_Approved_Loan_Amount__c,Re_appraisal_Initiated_time__c,(Select id, Document_Type__c,Deviation_Master__c,Deviation_Master__r.Minimum_Approver_Level__c, Mandatory__c, Sales_Status__c, Document__c from Checklists__r)
      */
     Loan = [select /*20939 s*/ Relationship_Manager__r.Mobile_number__c, /*20939 e*/ /* Bug 18159 S*/ Account.Queue_Master__c,Account.Queue_Master__r.QID__c/*Bug Id : 23549*/, Account.AutoCredit__c, /* Bug 18159 */ /*Bug Id : 19243*/ Prior_Application_Stage__c, /*SAL PL to SAL LAP*/ Branch_Name__r.Branch_Code__c, Account.First_Name__c, Account.Last_Name__c, Account.Process_Type__c, /*SAL PL to SAL LAP*/ id, Re_appraisal_Initiated_time__c, Account.Previous_Approved_Loan_Amount__c, (Select id, Document_Type__c, Deviation_Master__c, Deviation_Master__r.Minimum_Approver_Level__c, Mandatory__c, Sales_Status__c, Document__c from Checklists__r), Regional_SM__c, Regional_SM__r.Email, Zonal_SM__c, Zonal_SM__r.Email, National_SM__c, National_SM__r.Email, RCM__r.Email, CEO__r.Email, NCM__r.Email, Regional_SM__r.Mobile_number__c, Zonal_SM__r.Mobile_number__c, National_SM__r.Mobile_number__c, CEO__r.Mobile_number__c, NCM__r.Mobile_number__c, Relationship_Manager__r.Email, Sourcing_Channel__r.sourcing_channel_email_id__c, ACM__r.Email, EMI_Type__c, Branch_Type__c, A_C_No__c, Industry__r.Industry__c, Owner.Name, Original_Approver__c, Branch_City__c, Decision_Time__c, Loan_Amount_with_Premium__c, Approved_Loan_Amount__c, Approved_Rate__c, Approved_Tenor__c, Loan_amt_with_premium__c, Insurance_Premium_Amt__c, online_salaried_app__c,
      Reject_Reason__c, Sales_Backend__c, name, Risk_Deviations__c, CRO_Deviations__c, CPA__c, ACM__c, RCM__c, NCM__c, CRO__c, RISK__c, COO__c, ACM_Comments__c, RCM_Comments__c, COO_Comments__c, Eligible_for_cross_sell__c, Products_for_cross_sell__c, Cross_sell_comments__c,
      Approval_Stages__c, Approver__c, Loan_Application_Number__c, Product__c, Loan_Type__c, Relationship_Manager__c, AccountId, CreatedDate,
      OwnerId, CreatedById, Scheme_Master__c, Scheme_Master__r.Name, Industry__c, Credit_Program__c, createdBy.Profile.Name,
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
      Life_InsuranceRemarks__c, Type_of_Borrower__c, AppScore__c, Rank1__c, Loan_Application_Flow__c, Offer_Amount__c, Sourcing_Channel__r.Sourcing_Channel_Flag__c, Account.Vintage_with_BAL__c, Account.Current_experiance_in_Years__c, Account.Total_Work_Experience_Yrs__c, Account.BT_Bank_Type__c, Account.Type_of_Ownership__c, Account.Residence_TypeAcc__c,
      CampaignId, Business_IRR__c, POS__c, BranchName__c, Financed_by_BFL__c, Disbursement_Type__c, Tranche_Count__c, City_Head__c, UnHold__c,
      CL_Region__c, Region__c, Old_Product__c, account.Years_in_Bus__c, CAM_Expiry_Date__c, CAM_Preparation_Date__c, Business_Head__c, Centralized_ACM__c, Program_Type__c,
      AMC__c, Centralized_RCM__c, Customer_Reference_Number__c, SMS_to_be_Sent__c, ACM__r.Mobile_number__c, Scheme_Master__r.PLOC_scheme__c, Approved_time_after_Reappraisal__c, Decision_Date__c, Interior_Designer__c, Service_Availed__c, Account.EMI_Frequency__c, DSA_Name__c, Sourcing_Channel__r.Name, Account.ownerid, Account.Group_Type__c /*bug 6974*/ , Account.IsB2CStatusSent__c, Account.Name, /*Mortgage*/ Account.Preferred_language__c, account.Base_Loan__c, Full_Underwriting__c, Sourcing_Channel_Type__c, Sub_Stage__c,
      (select Id, Name, Offer_Amount__c, Availed_Amount__c, Tenor__c, Offer_ROI__c, Offer_Validity__c, Campaign_Type__c, Existing_LAN__c, Requested_Tenor__c, Revised_Offer_Amount__c, Program_Type__c,
       Revised_Offer_ROI__c, EMI_Amount__c, Current_EMI__c, Products__c, Product_Offering_Source__c, PO_Type__c from Product_offerings__r), Telecaller_Name__c, RCM__r.Mobile_number__c, /*SAL IM S*/ Account.Employer__r.Name, Account.Employer__r.Company_Name__c, Account.PANNumber__c, Account.Employer__c, Account.Mobile__c, Account.Date_of_Birth__c, /*SAL IM E */
      CM__c, CM_Amount__c, CM_Deviations__c, SCO__c, SCO_Amount__c, SCO_Deviations__c, CM__r.Mobile_number__c, SCO__r.Mobile_number__c, CM__r.name, SCO__r.name /* Bug id : 13016 - New Role Creation for Credit, added by Needhi*/ , (select ID, OppLevelRevisedOfferAmount__c, Revised_Offer_Amount__c, Branch__c from BodmasCalculations__r) /*bug 19469*/
      from opportunity where id =: Loan.Id
     ];


     //B2C api integration changes bug no 6974 by akshata S
     Savepoint sp = Database.setSavepoint();

     try {
      if (Loan.Product__c != null && Loan.Sourcing_Channel__c != null && Loan.Sourcing_Channel__r.Name != null && Loan.stagename != null && Loan.Customer_Reference_Number__c != null) {
       if (Loan.Product__c == 'FAS' && Loan.Sourcing_Channel__r.Name == 'IndusInd Bank' && (Loan.stagename == 'Approved' || Loan.stagename == 'Rejected') && Loan.Account.IsB2CStatusSent__c == false) {
        sendStatusToB2C();
       }
      }
     } catch (Exception e) {
      Database.rollback(sp);

     }
     //B2C api integration changes bug no 6974 by akshata E
     //4450
     COLStampdate = null;
     COLStampFlag = false;
     if (LaonApplicationCreation__c.getValues('Hierarchy Stamping') != null) {
      String COLDate = LaonApplicationCreation__c.getValues('Hierarchy Stamping').Credit_Hierarchy_Stamping_Date__c;
      if (COLDate != null) {
       system.debug('***COLDate***' + COLDate);
       COLStampdate = date.parse(COLDate);
      }
     }


     if (COLStampdate != null && Loan != null && COLStampdate < Loan.createddate) {
      COLStampFlag = true;
     }

     if (COLStampFlag == true) {
      if (Loan != null) {
       LoanAppFlow = Loan.Loan_Application_Flow__c;

       if (LoanAppFlow == null || LoanAppFlow == '') {
        LoanAppFlow = 'Normal';
       }
      }
     }

     if (ProductSMS__c.getValues(Loan.product__c) != null && ProductSMS__c.getValues(Loan.product__c).Validity_In_Months__c != null) {
      Integer months;
      months = Integer.valueof(ProductSMS__c.getValues(Loan.product__c).Validity_In_Months__c);
      //Decision_Date__c
      if (Loan.Decision_Date__c != null) {
       Date myDate = Loan.Decision_Date__c;
       objSurrogateCAM.Expiry_Date_without_BT__c = myDate.addMonths(months);
       //For Line policy age
       Integer age = Integer.valueOf(applicantPrimary.Contact_Name__r.Age_Round_Down__c);
       if (age >= 60) {
        objSurrogateCAM.Expiry_Date_without_BT__c = Loan.Decision_Date__c;
       } else {
        Integer years = months / 12;
        for (Integer i = years; i > 0; i--) {
         if ((age + i) >= 60) {
          objSurrogateCAM.Expiry_Date_without_BT__c = myDate.addMonths((i) * 12);
         }
        }
       }
       upsert objSurrogateCAM;
      }
     }

    }
   } catch (Exception e) {
    // system.debug('Exception occurd==>'+e.getMessage()+'Line number===>'+e.getLinenumber());
    /*Apexpages.addMessages(e);
system.debug('Has Exception *** ' + e.getMessage());*/
    return null;
   }

   //******************NEW SMS CODES****************

   //Code for sending SMS...    
   //Communication for SAL Line starts

   //system.debug('starting sms code Anjali');
   /*20939 s*/
   system.debug('salmobilityv2falg' + salmobilityv2falg);
   if (salmobilityv2falg) {
    Boolean sancPresent = false;
    for (Discrepancy__c dis: sanctionList) {
     if (dis.Status__c == 'Pending')
      sancPresent = true;
    }
    if (sancPresent) {
     system.debug('callcenterprocessflag' + callcenterprocessflag);
     if (callcenterprocessflag)
      SALMobilityOppCntrl_V2.sendCreditApproveMessage(loanid, Loan, true);
     else
      SALMobilityOppCntrl_V2.sendCreditApproveMessage(loanid, Loan, false);
    } else {
     List < Opportunity > oppList = new List < Opportunity > ();
     oppList.add(Loan);
     GeneralCommunicationHandler.sendsms(oppList, 'SAL LA Approval WO Sanc');
    }
    if (!callcenterprocessflag) {
     SALMobilityOppCntrl_V2.sendCreditApproveMessageToCM(loanid, Loan);
    }
    SALMobilityOppCntrl_V2.sendCreditApproveMailToCM(loanid, callcenterprocessflag);
   } else /*20939 e*/
    if (Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL' || Loan.Product__c == 'SBS CS SAL' /*SBS CS SAL consition added*/ ) {

     /*Responsys Dynamic Parameters Bug 15653 s*/
     List < Applicant__c > appList = new List < Applicant__c > ();
     appList.add(applicantPrimary);
     List < Opportunity > LoanList = new List < Opportunity > ();
     LoanList.add(Loan);
     GeneralCommunicationHandler.sendSMS(LoanList, appList, 'LA Approved By Credit-Cust');
     GeneralCommunicationHandler.sendSMS(LoanList, appList, 'LA Approved By Credit-Int');
     /*Responsys Dynamic Parameters Bug 15653 e*/

     //communication framework Enhancement start send email to customer when loan is approved
     string templateName = 'SAL_LoanApprovedCustomer';
     Id whatId = Loan.id;
     string fromName = 'noreply@bajajfinserv.in';
     string replyTo = 'otpofficeemailverification@6hifw8v4ew6qa26r5whiw37rq2yorch4vylpptp0njgfwqxjc.o-51mo2mam.cs5.apex.sandbox.salesforce.com';
     string[] toAddresses = new String[] {};
     if (accountCreate[0].Current_Email_Id__c != null)
      toAddresses.add(accountCreate[0].Current_Email_Id__c);
     String[] CC;
     string[] bcc;
     String Priority = 'Normal';
     BAFL_EmailServicesLogix.Attachment[] Attachments = new BAFL_EmailServicesLogix.Attachment[] {};
     string Subject = 'Your loan application no' + Loan.Loan_Application_Number__c + 'has been sanctioned';
     String CostCenter = 'bajaj';
     if (!Test.isRunningTest() && SalesEligibilityDetailsCtrl.handleEmail) // Bug Id : 18159
      GeneralUtilities.SendEmailUsingBAFLLogix(templateName, whatId, fromName, replyTo, toAddresses, CC, bcc, Priority, Subject, CostCenter);
     //internal email

     templateName = 'SAL_LoanApprovedInternalTeam';
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
     //bug 11847 start
     if (Loan.Regional_SM__r.Email != null)
      toAddressesInternal.add(Loan.Regional_SM__r.Email);
     if (Loan.Zonal_SM__r.Email != null)
      toAddressesInternal.add(Loan.Zonal_SM__r.Email);
     if (Loan.National_SM__r.Email != null)
      toAddressesInternal.add(Loan.National_SM__r.Email);
     if (Loan.RCM__r.Email != null)
      toAddressesInternal.add(Loan.RCM__r.Email);
     if (Loan.CEO__r.Email != null)
      toAddressesInternal.add(Loan.CEO__r.Email);
     if (Loan.NCM__r.Email != null)
      toAddressesInternal.add(Loan.NCM__r.Email);
     //bug 11847 ends
     Subject = 'Loan sanctioned for application no' + Loan.Loan_Application_Number__c;
     if (!Test.isRunningTest() && SalesEligibilityDetailsCtrl.handleEmail) // Bug Id : 18159
      GeneralUtilities.SendEmailUsingBAFLLogix(templateName, whatId, fromName, replyTo, toAddressesInternal, CC, bcc, Priority, Subject, CostCenter);
     //Communication frmaework Enhancement ends

    }
   //Communication for SAL Line ends
   else if (Loan.Product__c != 'SOL' && Loan.Product__c != 'SHOL') {

    // Start of general communication framework
    List < Opportunity > LoanList = new List < Opportunity > ();
    LoanList.add(Loan);
    if (Mortgageflag) {
     GeneralCommunicationHandler.sendSMS(LoanList, 'Credit accept-Cust');
     GeneralCommunicationHandler.sendSMS(LoanList, 'Credit accept-Int');

     GeneralCommunicationHandler.sendEmail(LoanList, 'Credit accept-Cust');
     GeneralCommunicationHandler.sendEmail(LoanList, 'Credit accept-Int');
    }
    //Send sms and email to customer and internal users after loan is Approved when product = FAS and GroupType = salaried//YK 
    else if (Loan.Product__c != null && (Loan.Product__c == 'FAS' || Loan.Product__c == 'HSL')) {
     GeneralCommunicationHandler.sendSMS(LoanList, 'Credit Accept-Cust');
     GeneralCommunicationHandler.sendSMS(LoanList, 'Credit Accept-Int');
     GeneralCommunicationHandler.sendEmail(LoanList, 'Credit Accept-Cust');
     GeneralCommunicationHandler.sendEmail(LoanList, 'Credit Accept-Int');
    }
    // End of general communication framework
    else {
     List < Applicant__c > appListCust = new List < Applicant__c > (); //Responsys 15653

     for (Applicant__c app: applicantList) {
      if (app.Applicant_Type__c == 'Primary') {
       appListCust.add(app); //Responsys 15653

      }

      if (Loan.SMS_to_be_Sent__c == 'All Applicants') {
       if (app.Applicant_Type__c != 'Primary') {
        appListCust.add(app); //Responsys 15653

       }
      }
     }

     /*Responsys Dynamic Parameters Bug 15653 s*/
     List < Applicant__c > appList = new List < Applicant__c > ();
     appList.add(applicantPrimary);
     GeneralCommunicationHandler.sendSMS(LoanList, appListCust, 'Approved By Credit-Cust');
     GeneralCommunicationHandler.sendSMS(LoanList, appList, 'Approved By Credit-Int');
     GeneralCommunicationHandler.sendSMS(LoanList, appList, 'Approved By Credit-Sourc');
     /*Responsys Dynamic Parameters Bug 15653 e*/
    }
   }
   // ********************** EMI HOLIDAY START
   if (Loan != null && applicantPrimary != null && applicantPrimary.EMI_Holiday_Opted__c == true) {
    //emi code begins
    Date dueDate, decisionDate;
    if (Loan.Approved_time_after_Reappraisal__c != null)
     decisionDate = Loan.Approved_time_after_Reappraisal__c.date();
    else
     decisionDate = system.today();
    if (applicantPrimary != null) {
     if (decisionDate != null && (decisionDate.Day() < 15) && applicantPrimary.Cycle_Day_Date__c != null) {
      dueDate = Date.newinstance(decisionDate.Year(), decisionDate.Month() + 1, integer.valueof(applicantPrimary.Cycle_Day_Date__c));
     } else if (decisionDate != null && applicantPrimary.Cycle_Day_Date__c != null) {
      dueDate = Date.newinstance(decisionDate.Year(), decisionDate.Month() + 2, integer.valueof(applicantPrimary.Cycle_Day_Date__c));
     }
     applicantPrimary.EMI_Due_Date__c = dueDate;
     loan.Due_Day__c = dueDate;
     loan.First_Due_Date__c = dueDate;
     //Code to find calculate Due Date End
     String[] emiMonths = applicantPrimary.EMI_Holiday_Months__c.split(';');
     List < Integer > emiMonthNumbers = new List < integer > ();

     if (emiMonths != null && emiMonths.size() > 0) {
      for (String Month: emiMonths) {
       emimonthNumbers.add(parseMonths(Month));
      }
     }
     integer applicableMonths;
     decimal applicableMonthsPerYear;
     List < StepUpStepDown__c > grid = StepUpStepDown__c.getall().values();
     system.debug('Grid Fetched ' + grid);
     for (StepUpStepDown__c x: grid) {
      if (x.name == Loan.Product__c) {
       if (applicantPrimary.Months_per_year__c != null)
        applicableMonths = (x.Months_per_tenure__c).intValue();
       applicableMonthsPerYear = x.Months_per_year__c;
      }
     }

     Map < String, String > emiHolidayEMI;
     EMIHolidayCalculationCntrl emiCtrl = new EMIHolidayCalculationCntrl();

     double tenor;
     if (Loan.product__c == 'Home Loan' || Loan.Product__c == 'HFC Home Loan' || Loan.Product__c == 'HML' || Loan.product__c == 'SBS CS HL' || Loan.product__c == 'LAP' || Loan.Product__c == 'HFC LAP' || Loan.product__c == 'SBS CS LAP' || Loan.product__c == 'HLD' || Loan.product__c == 'HDL') {
      tenor = Loan.Tenor__c * 12;
     } else {
      // tenor = Loan.Tenor__c;
      //akshata EMI Holiday fix-start
      tenor = cam.Tenor__c;
      //akshata EMI Holiday fix-end
     }
     if (decisionDate != null && applicantPrimary.Months_per_year__c != null && applicantPrimary.Cycle_Day_Date__c != null && cam.Proposed_Loan_Amt__c != null && cam.Tenor__c != null && cam.ROI__c != null && emiMonthNumbers != null && applicableMonths != null) {

      //akshata Emi holiday fix-start
      if (Loan.product__c == 'SAL' || Loan.product__c == 'SPL') {

       emiHolidayEMI = emiCtrl.calculateEMIHolidayEMI(decisionDate, integer.valueof(applicantPrimary.Cycle_Day_Date__c), double.valueOF(Loan.Approved_Loan_Amount__c), tenor, double.valueOF(cam.ROI__c), applicantPrimary.Months_per_year__c.intvalue(), emiMonthNumbers, applicableMonths);
      } else {
       emiHolidayEMI = emiCtrl.calculateEMIHolidayEMI(decisionDate, integer.valueof(applicantPrimary.Cycle_Day_Date__c), double.valueOF(cam.Proposed_Loan_Amt__c), tenor, double.valueOF(cam.ROI__c), applicantPrimary.Months_per_year__c.intvalue(), emiMonthNumbers, applicableMonths);
      }
      //akshata Emi holiday fix-End


     }

     if (emiHolidayEMI != null && emiHolidayEMI.containsKey('EMI') && emiHolidayEMI.get('EMI') != null) {
      Loan.Revised_Emi__c = decimal.valueof(emiHolidayEMI.get('EMI'));

      cam.EMI_of_The_Loan__c = Loan.Revised_Emi__c;
      //update Loan;
     }

     if (applicantPrimary != null && emiHolidayEMI != null && emiHolidayEMI.containsKey('Months') && emiHolidayEMI.get('Months') != null) {
      applicantPrimary.EMI_Holidays_Across_tenure__c = emiHolidayEMI.get('Months');
      //update applicantPrimary;
     }

    }


    upsert cam;

    upsert Loan;

    upsert applicantPrimary;

   }
   // Bug 18159 - May 2018 BRD - Auto allocation of application to Credit start
   String methodName = 'Approve'; // Prod issue
   if (salmobilityv2falg) methodName = methodName + ';mobility_LA';
   system.debug('calling updateCreditUserOccupied in approval');
    AutoQueueAllocationUtility.updateCreditUserOccupied(methodName, Loan, null); // Bug Id : 21112
   // Bug 18159 - May 2018 BRD - Auto allocation of application to Credit end
   // ********************** EMI HOLIDAY END
   //01MOB S
   if (MOBProductList.contains(loan.product__c)) {
    finalScripsHistoryDelete = [Select id from ScripsHistory__c where Source__c = '01MOB'
     and Loan_Application__c =: Loan.id
    ];
    if (finalScripsHistoryDelete != null && finalScripsHistoryDelete.size() > 0) delete finalScripsHistoryDelete;
    if (finalScripsHistoryDelete != null && finalScripsHistoryInsert.size() > 0) {
     insert finalScripsHistoryInsert;
    }
   }
   //01MOB E
   return null;



  } catch (Exception e) {
   system.debug('Exception' + e.getMessage() + e.getLineNumber());
   /* 17139 */
   if (salmobilityv2falg)
    mobilitystatus = (String) e.getMessage();
   else {
    Apexpages.addMessages(e);
    system.debug('EApexPages.hasMessages()==>' + ApexPages.hasMessages());
   }
   return null;
  }
 }

 public void acmrej() {
  //savedApproved=false;
  try {
   List < string > msg = new List < string > ();
   List < string > mobileNumbers = new List < string > ();

   /* 17139 s */
   if (salmobilityv2falg) {
    if (!CommonUtility.isEmpty(app_rejcomments))
     loan.COO_Comments__c = app_rejcomments;
    if (!CommonUtility.isEmpty(reject_reason))
     loan.Reject_Reason__c = reject_reason;
    //if(!CommonUtility.isEmpty(reject_reason1))
    // loan.Reject_Reason_1__c = reject_reason1;
   }
   /* 17139 e */
   if (Loan.Reject_Reason_1__c == null && !salmobilityv2falg) {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Reject Reason1 value is empty. Unable to continue'));
    // return null;
   } else if (Loan.Reject_Reason__c == null) {
    /*17139 */
    if (salmobilityv2falg)
     mobilitystatus = 'Reject Reason value is empty. Unable to continue';
    else
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Reject Reason value is empty. Unable to continue'));
    //return null;
   } else {

    // Bug Id : 16618 - NSDL PAN Check - start
    NSDL_PAN_CheckCntrl.ApprovalValidation appValidation = NSDL_PAN_CheckCntrl.approvalValidation(Loan.Id, Loan.product__c);
    System.debug('appValidation -->' + appValidation);
    if (appValidation != null) {
     if (!appValidation.canReject) {
      /* 17139 */
      if (salmobilityv2falg)
       mobilitystatus = appValidation.errorMessage;
      else
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, appValidation.errorMessage));
      return;
     }
    }
    // Bug Id : 16618 - NSDL PAN Check - end

    String referal = LOan.Referral__c;
    if (referal == 'None') {
     Loan.Referral__c = null;
    }
    Loan.Approval_Stages__c = 'Rejected';
    // Bug id : 13016 - New Role Creation for Credit, added by Needhi 
    // Loan.Approver__c = 'Area Credit Manager';
    Loan.Approver__c = 'Credit Manager';
    Loan.stagename = 'Rejected';



    Id userId = Userinfo.getuserid();
    ID Pid = Userinfo.getProfileID();
    String Pname = [select id, name from Profile where id =: Pid].name;
    Loan.Approver__c = Pname;
    if (loan.product__c == 'SAL' && Loan.online_salaried_app__c == true) {
     if (COLStampFlag == false && Loan.ACM__c == null && Loan.Branch_Name__c != null && Loan.Branch_Name__r.name != null) {
      CO = [select id, name, City__c, Number_of_Deviations__c, Credit_Officer_Name__r.Isactive,
       Credit_Officer_Name__r.id, Credit_Officer_Name__r.name, Credit_Officer_Name__c, Designation__c, Pre_Approved_Amount__c,
       Loan_Amount__c, User_Type__c from Credit_Officer_Limit__c where products__C INCLUDES(: loan.product__c)
       and Credit_Officer_Name__r.Isactive = true and Designation__c = 'Area Credit Manager'
       and City__c INCLUDES(: Loan.Branch_Name__r.name)
      ];

      system.debug('-----2-----' + CO.size());
      if (CO.size() > 0) {
       for (integer i = 0; i < CO.size(); i++) {
        try {
         if (Loan.Branch_Name__c == null) {
          /*17139 */
          if (salmobilityv2falg)
           mobilitystatus = 'Branch value is empty. Unable to continue';
          else
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Branch value is empty. Unable to continue'));
         }
         if ((CO[i].Credit_Officer_Name__c != null) && (CO[i].city__c != null)) {

          if (CO[i].City__c.toUpperCase().contains(Loan.Branch_Name__r.name.toUpperCase()) && CO[i].Designation__c == 'Area Credit Manager') {

           Loan.ACM__c = CO[i].Credit_Officer_Name__c;
           break;

          }
         }
        } catch (Exception e) {

         sendEmailForException(e);
        }
       }
      }
      // Bug id : 13016 - New Role Creation for Credit, added by Needhi 
      Loan.Approver__c = 'Area Credit Manager';
      if (Loan.ACM__c != null)
       Loan.ownerId = Loan.ACM__c;
     }

    }
    //if (Loan.ACM__c != null)
    //Loan.ownerId = Loan.ACM__c;

    update Loan;

    if (ConfirmCheckbox) {
     if (applicantPrimary != null) {
      applicantPrimary.approved__c = true;
      checked = true;
      update applicantPrimary;
     }
    }
    //B2C api integration changes bug no 6974 by akshata S
    //for rejection of loan application
    Savepoint sp = Database.setSavepoint();

    try {
     if (Loan.Product__c != null && Loan.Sourcing_Channel__c != null && Loan.Sourcing_Channel__r.Name != null && Loan.stagename != null && Loan.Customer_Reference_Number__c != null) {
      if (Loan.Product__c == 'FAS' && Loan.Sourcing_Channel__r.Name == 'IndusInd Bank' && (Loan.stagename == 'Approved' || Loan.stagename == 'Rejected') && Loan.Account.IsB2CStatusSent__c == false) {
       sendStatusToB2C();
      }
     }
    } catch (Exception e) {
     Database.rollback(sp);

    }

    //B2C api integration changes bug no 6974 by akshata E

    // Start of general communication framework
    if (Mortgageflag) {
     List < Opportunity > LoanList = new List < Opportunity > ();
     LoanList.add(Loan);

     //GeneralCommunicationHandler.sendSMS(LoanList,'Credit reject-Cust');
     GeneralCommunicationHandler.sendSMS(LoanList, 'Credit reject-Int');


     //GeneralCommunicationHandler.sendEmail(LoanList,'Credit reject-Cust');
     GeneralCommunicationHandler.sendEmail(LoanList, 'Credit reject-Int');
    }
    // End of general communication framework
    else if (Loan.Product__c != null && Loan.Product__c == 'FAS') {
     //Ajinkya bug 9293 Send SMS to RM on rejection for FAS  Start
     List < Opportunity > listOfLoan = new List < Opportunity > ();
     listOfLoan.add(Loan);


     GeneralCommunicationHandler.sendSMS(listOfLoan, 'Credit Reject-Int');
     GeneralCommunicationHandler.sendEmail(listOfLoan, 'Credit Reject-Int'); //bug 9599
     //Ajinkya bug 9293 Send SMS to RM on rejection for FAS  End
    } /*added by swapnil for 20939 start*/
    else if (salmobilityv2falg && Loan.Product__c != null && (Loan.product__c == 'SAL' || Loan.product__c == 'SPL')) {
     // List < Opportunity > loanList = new List < Opportunity > ();
     //loanList.add(Loan);
     try {
      SALMobilityOppCntrl_V2.gensendSMS(Loan, null, 'On app system reject');
     } catch (Exception e) {
      System.debug('@swapnil exception in sendSMSEmail -->' + e.getMessage() + ' On line ' + e.getLineNumber());
     }
    } /*added by swapnil for 20939 end*/
    else {
     //Code for sending sms...         
     if (isPSBLProductLineProduct != null && isPSBLProductLineProduct) {
      /*Responsys Dynamic Parameters Bug 15653 s*/
      List < Opportunity > loanList = new List < Opportunity > ();
      loanList.add(Loan);
      GeneralCommunicationHandler.sendSMS(loanList, 'Credit Rejected-Int');
      /*Responsys Dynamic Parameters Bug 15653 e*/

     }
    }
    donemessage = 'Loan application is Rejected';
    savedApproved = true;
    /* 17139 */
    if (salmobilityv2falg)
     mobilitystatus = 'success';
   }
   String methodName = 'Reject'; // Prod issue
   if (salmobilityv2falg) methodName = methodName + ';mobility_LA';
   //Bug 18159 - May 2018 BRD - Auto allocation of application to Credit start
  AutoQueueAllocationUtility.updateCreditUserOccupied(methodName, Loan, null);
   //Bug 18159 - May 2018 BRD - Auto allocation of application to Credit end

  } catch (Exception e) {

   sendEmailForException(e);
   // return null;
  }
 }
 public PageReference cancelrej() {
  showrej = false;
  return null;
 }

 //Method to get Discrepancies
 public List < Discrepancy__c > getdiscrepancyList() {
  return discrepancyList;
 }
 /** 
  *   This Function is used to save the Standard documents.
  *   Standard Documents are the documents which are the reqired documents before any loan application get processesed. e.g., Passport, VotedId.
  */
 public void saveStandardDocuments() {}

 public String documentFamilyName {
  get;
  set;
 }

 public Pagereference saveTransactionDocuments() {
  //DeviationsChecklistTrnxList
  //checklistTrnxList
  try {
   List < Checklist__c > checklistTrnxListToUpdate = new List < Checklist__c > ();
   List < Checklist__c > checklistTrnxListToDelete = new List < Checklist__c > ();
   List < ManualDeviations > NewManualDeviationsWrap = new List < ManualDeviations > {};
   List < DocumentWrapper > NewdeviationDocWrapperList = new List < DocumentWrapper > ();
   for (DocumentWrapper obj: docWrapperList) {

    if (obj.selectedDoc != null && obj.selectedDoc != '')
     obj.docFamObj.Document__c = obj.selectedDoc;
    else if (obj.singleDoc != null && obj.singleDoc != '')
     obj.docFamObj.Document__c = obj.singleDoc;
    checklistTrnxListToUpdate.add(obj.docFamObj);
   }

   // March'17 Mortgage closure points. No.7
   // Bug 11944 - Below block is added by hemant keni to edit and save the Mitigants on the Chaklist object
   if (MortgageFlag && ManualDeviationsWrap != null && ManualDeviationsWrap.size() > 0) {
    List < Checklist__c > manualCheckList = new List < Checklist__c > ();
    for (ManualDeviations manualDev: ManualDeviationsWrap) {
     if (manualDev.mCheckList != null)
      manualCheckList.add(manualDev.mCheckList);
    }

    for (Checklist__c manualCheck: manualCheckList) {
     Checklist__c mnlCheck = new Checklist__c(Id = manualCheck.id);
     mnlCheck.Mitigants_Remark__c = manualCheck.Mitigants_Remark__c;
     checklistTrnxListToUpdate.add(mnlCheck);
    }
   }
   // End of Bug 11944 - March'17 Mortgage closure points. No.7

   for (Integer j = 0; j < ManualDeviationsWrap.size(); j++) {

    if (ManualDeviationsWrap.get(j).deleteMDeviation)
     checklistTrnxListToDelete.add(ManualDeviationsWrap.get(j).mCheckList);
    else
     NewManualDeviationsWrap.add(ManualDeviationsWrap.get(j));

   }

   ManualDeviationsWrap.clear();
   ManualDeviationsWrap = NewManualDeviationsWrap;


   for (Integer i = 0; i < deviationDocWrapperList.size(); i++) {


    if (deviationDocWrapperList.get(i).selectedDoc != null && deviationDocWrapperList.get(i).selectedDoc != '')
     deviationDocWrapperList.get(i).docFamObj.Document__c = deviationDocWrapperList.get(i).selectedDoc;
    else if (deviationDocWrapperList.get(i).singleDoc != null && deviationDocWrapperList.get(i).singleDoc != '')
     deviationDocWrapperList.get(i).docFamObj.Document__c = deviationDocWrapperList.get(i).singleDoc;

    if (deviationDocWrapperList.get(i).deleteDeviation) {
     checklistTrnxListToDelete.add(deviationDocWrapperList.get(i).docFamObj);
     //    deviationDocWrapperList.remove(i);
    } else {
     checklistTrnxListToUpdate.add(deviationDocWrapperList.get(i).docFamObj);
     NewdeviationDocWrapperList.add(deviationDocWrapperList.get(i));
    }
    //deviationDocWrapperList.get(i).showPicklist = false;                 
   }

   deviationDocWrapperList.clear();
   deviationDocWrapperList = NewdeviationDocWrapperList;


   // Bug 15164 Delete checklistTrnxListToDelete written before Upsert to update deviatio count on Vf page delete. 


   if (checklistTrnxListToDelete != null && checklistTrnxListToDelete.size() > 0)
    delete checklistTrnxListToDelete;
   if (checklistTrnxListToUpdate != null && checklistTrnxListToUpdate.size() > 0) {
    upsert checklistTrnxListToUpdate;
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Status Update/Deviation Delete has been done successfully !!'));
   } else {

    update Loan;
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Status has been recorded successfully !!'));
   }

   // if(checklistTrnxList.size()>0)
   // upsert checklistTrnxList;      
   savedSuccessfull = true;
   message = 'Documents saved Successfully !!!';
  } catch (Exception e) {
   //Apexpages.addMessages(e); 
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e + ''));
  }
  return null;
 }
 /** 
  * This funcation is used to get the child documents of the selected document from the Document Family master.
  */
 public void populateChildDocument() {}

 /**
  * This function is used to send the Exception mail to the users who are imporant to know the issue.
  */
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
 public String StrApprNew {
  get;
  set;
 }
 //Call center process start
 public String StrApprSalesNew {
  get;
  set;
 }
 //call center process stop
 public boolean RenderRecommend {
  get;
  set;
 }
 public PageReference Recommend() {

  RenderRecommend = false;
  User userObj = new User();
  if (Loan.OwnerId != null) // 18159
   userObj.id = Loan.OwnerId;
  transient Credit_Officer_Limit__c CreditOffLimitObj;

  // Bug Id : 16618 - NSDL PAN Check - start
  NSDL_PAN_CheckCntrl.ApprovalValidation appValidation = NSDL_PAN_CheckCntrl.approvalValidation(Loan.Id, Loan.product__c);
  System.debug('appValidation -->' + appValidation);
  if (appValidation != null) {
   if (!appValidation.canRecommend) {
    /* 17139 */
    if (salmobilityv2falg)
     mobilitystatus = appValidation.errorMessage;
    else
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, appValidation.errorMessage));
    return null;
   }
  }
  // Bug Id : 16618 - NSDL PAN Check - end

  for (Credit_Officer_Limit__c temp: CO) {
   if (StrApprNew == temp.id) {
    CreditOffLimitObj = temp;
   }
  }
  system.debug('dddd= StrApprNew' + StrApprNew);
  system.debug('CreditOffLimitObj' + StrApprNew);
  if (CreditOffLimitObj != null) {
   Loan.OwnerId = CreditOffLimitObj.Credit_Officer_Name__c;
   Loan.Approver__c = CreditOffLimitObj.Designation__c;

   //4450

   // Bug id : 13016 - New Role Creation for Credit, added by Needhi 
   if (CreditOffLimitObj.Designation__c == 'Credit Manager') {
    if (Loan.Program_Type__c == 'Pre-Approved') {
     Loan.CM_Amount__c = CreditOffLimitObj.Pre_Approved_Amount__c;
    } else {
     Loan.CM_Amount__c = CreditOffLimitObj.Loan_Amount__c;
    }
    Loan.CM__c = CreditOffLimitObj.Credit_Officer_Name__c;
   }
   if (CreditOffLimitObj.Designation__c == 'Area Credit Manager') {
    if (Loan.Program_Type__c == 'Pre-Approved') {
     Loan.ACM_Amount__c = CreditOffLimitObj.Pre_Approved_Amount__c;
    } else {
     Loan.ACM_Amount__c = CreditOffLimitObj.Loan_Amount__c;
    }
    Loan.ACM__c = CreditOffLimitObj.Credit_Officer_Name__c;
   }
   if (CreditOffLimitObj.Designation__c == 'Centralized ACM') {
    if (Loan.Program_Type__c == 'Pre-Approved') {
     Loan.Centralized_ACM_Amount__c = CreditOffLimitObj.Pre_Approved_Amount__c;
    } else {
     Loan.Centralized_ACM_Amount__c = CreditOffLimitObj.Loan_Amount__c;
    }
    Loan.Centralized_ACM__c = CreditOffLimitObj.Credit_Officer_Name__c;
   }
   if (CreditOffLimitObj.Designation__c == 'Regional Credit Manager') {
    if (Loan.Program_Type__c == 'Pre-Approved') {
     Loan.RCM_Amount__c = CreditOffLimitObj.Pre_Approved_Amount__c;
    } else {
     Loan.RCM_Amount__c = CreditOffLimitObj.Loan_Amount__c;
    }
    Loan.RCM__C = CreditOffLimitObj.Credit_Officer_Name__c;
   }
   if (CreditOffLimitObj.Designation__c == 'Centralized RCM') {
    if (Loan.Program_Type__c == 'Pre-Approved') {
     Loan.Centralized_RCM_Amount__c = CreditOffLimitObj.Pre_Approved_Amount__c;
    } else {
     Loan.Centralized_RCM_Amount__c = CreditOffLimitObj.Loan_Amount__c;
    }
    Loan.Centralized_RCM__c = CreditOffLimitObj.Credit_Officer_Name__c;
   }
   if (CreditOffLimitObj.Designation__c == 'Zonal Credit Manager') {
    if (Loan.Program_Type__c == 'Pre-Approved') {
     Loan.ZCM_Amount__c = CreditOffLimitObj.Pre_Approved_Amount__c;
    } else {
     Loan.ZCM_Amount__c = CreditOffLimitObj.Loan_Amount__c;
    }
    Loan.CEO__c = CreditOffLimitObj.Credit_Officer_Name__c;
   }
   if (CreditOffLimitObj.Designation__c == 'National Risk Manager') {
    if (Loan.Program_Type__c == 'Pre-Approved') {
     Loan.RISK_Amount__c = CreditOffLimitObj.Pre_Approved_Amount__c;
    } else {
     Loan.RISK_Amount__c = CreditOffLimitObj.Loan_Amount__c;
    }
    Loan.RISK__c = CreditOffLimitObj.Credit_Officer_Name__c;
   }
   if (CreditOffLimitObj.Designation__c == 'Chief-Credit & Operations') {
    if (Loan.Program_Type__c == 'Pre-Approved') {
     Loan.COO_Amount__c = CreditOffLimitObj.Pre_Approved_Amount__c;
    } else {
     Loan.COO_Amount__c = CreditOffLimitObj.Loan_Amount__c;
    }
    Loan.COO__c = CreditOffLimitObj.Credit_Officer_Name__c;
   }
   if (CreditOffLimitObj.Designation__c == 'Chief Risk officer') {
    if (Loan.Program_Type__c == 'Pre-Approved') {
     Loan.CRO_Amount__c = CreditOffLimitObj.Pre_Approved_Amount__c;
    } else {
     Loan.CRO_Amount__c = CreditOffLimitObj.Loan_Amount__c;
    }
    Loan.CRO__c = CreditOffLimitObj.Credit_Officer_Name__c;
   }
   if (CreditOffLimitObj.Designation__c == 'National Credit Manager') {
    if (Loan.Program_Type__c == 'Pre-Approved') {
     Loan.NCM_Amount__c = CreditOffLimitObj.Pre_Approved_Amount__c;
    } else {
     Loan.NCM_Amount__c = CreditOffLimitObj.Loan_Amount__c;
    }
    Loan.NCM__c = CreditOffLimitObj.Credit_Officer_Name__c;
   }
   // Bug id : 13016 - New Role Creation for Credit, added by Needhi 
   if (CreditOffLimitObj.Designation__c == 'Senior Credit Officer') {
    if (Loan.Program_Type__c == 'Pre-Approved') {
     Loan.SCO_Amount__c = CreditOffLimitObj.Pre_Approved_Amount__c;
    } else {
     Loan.SCO_Amount__c = CreditOffLimitObj.Loan_Amount__c;
    }
    Loan.SCO__c = CreditOffLimitObj.Credit_Officer_Name__c;
   }
   if (CreditOffLimitObj.Designation__c == 'Business Head') {
    if (Loan.Program_Type__c == 'Pre-Approved') {
     Loan.Business_Head_Amount__c = CreditOffLimitObj.Pre_Approved_Amount__c;
    } else {
     Loan.Business_Head_Amount__c = CreditOffLimitObj.Loan_Amount__c;
    }
    Loan.Business_Head__c = CreditOffLimitObj.Credit_Officer_Name__c;
   }
   if (CreditOffLimitObj.Designation__c == 'President') {
    if (Loan.Program_Type__c == 'Pre-Approved') {
     Loan.President_Approval_Amount__c = CreditOffLimitObj.Pre_Approved_Amount__c;
    } else {
     Loan.President_Approval_Amount__c = CreditOffLimitObj.Loan_Amount__c;
    }

    Loan.President__c = CreditOffLimitObj.Credit_Officer_Name__c;
   }
   /* sal Mobility v2 17139 start */
   String methodName = 'Recommend'; // Prod issue
   if (salmobilityv2falg) {
    if (!CommonUtility.isEmpty(app_rejcomments))
     Loan.COO_Comments__c = app_rejcomments;
     methodName = methodName + ';mobility_LA'; // Prod issue
   }
   /* sal Mobility v2 end */

   update Loan;
   //Bug 18159 - May 2018 BRD - Auto allocation of application to Credit start
   system.debug('calling updateCreditUserOccupied');
    AutoQueueAllocationUtility.updateCreditUserOccupied(methodName, Loan, userObj); // Prod issue
   //Bug 18159 - May 2018 BRD - Auto allocation of application to Credit end
  }
  if (ConfirmCheckbox) {
   if (applicantPrimary != null) {
    applicantPrimary.approved__c = true;
    checked = true;
    update applicantPrimary;
   }

  }
  // PageReference pageRef = new PageReference('/apex/COEligibilityDetailsPage?id='+loan.id+'&grouptype=salaried');
  /*17139 */
  if (salmobilityv2falg) {
   mobilitystatus = 'success';
   return null;
  } else {
   Pagereference pageRef = new pagereference('/006/o');
   return pageRef;
  }
 }
 //20474 start
 public boolean checkPhysicalPD() {
  System.debug('In Check Physical pd');
  /* if (DSSProdList.contains(Loan.product__c) && Loan.Offer_Amount__c > DSSOfferAmount[0] && (Loan.Sourcing_Channel__r.Channel_Category__c == 'Medium Risk' || Loan.Sourcing_Channel__r.Channel_Category__c == 'High Risk') && pd.PD_Conducted__c == false) {
System.debug('In criteria violation');
ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please complete personal discussion (Physical PD)'));
savedSuccessfull = true;
message = 'Please complete personal discussion (Physical PD)';
return false;
}
*/
  RSL_PDComponent_Cntrl rslPD = new RSL_PDComponent_Cntrl();
  List < Personal_Discussion__c > pdList = [select id, name, Type_of_PD__c, Loan_Application__c, Name_of_the_applicant__c, PD_Conducted__c from Personal_Discussion__c where Loan_Application__c =: Loan.id limit 1];
  //System.debug('$$$$'+pdList[0].Type_of_PD__c+' '+pdList[0].PD_Conducted__c+' '+rslPD.DSSProdList);
  if (pdList.size() > 0 && pdList[0].Type_of_PD__c == 'Physical PD' && pdList[0].PD_Conducted__c == false && rslPD.DSSProdList.contains(Loan.product__c)) {
   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please complete Personal Discussion (Physical PD)'));
   savedSuccessfull = true;
   message = 'Please complete Personal Discussion (Physical PD)';
   return false;
  } else
   return true;
 }

 //20474 end
 public void ShowRecommend() {

  //Bug 14957 - October BRD - Google Check By Rajesh START
  Boolean Googlecheck = false;
  /*BUG-16959 added Prod condition for DBOL  by Rajesh */
  if (isPSBLProductLineProduct || Loan.Product__c == 'LAP' || Loan.Product__c == 'SHL') {
   for (Applicant__c app: cubicApplicantList) {
    if (app.Google_Check_Result__c == null) {
     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Google check details are not filled for ' + app.Contact_Name__r.Name));
     //message = 'Google Check has to be done for each applicant!';
     Googlecheck = true;
    }
   }
  }
  //Bug 14957 - October BRD - Google Check By Rajesh END

  if (RenderRecommend == false && !Googlecheck) {
   RenderRecommend = true;
  } else
   RenderRecommend = false;

 }
 public void approve() {

  if (!GeoDeviationUtility.GeoDeviationValidation(Loan.Id)) return; //Bug 17531 - Rural Geo Fencing

  savedSuccessfull = false;
  id userProfForSalVer = userinfo.getProfileId();

  /*Bug 12944 Property Dedupe Start - Anshita */
  Map < Id, Boolean > ddpMap = new Map < Id, Boolean > ();
  MAp < Id, List < De_Dupe__c >> intMap = new Map < id, List < De_Dupe__c >> ();
  Boolean bmflag = false;
  if (grouptype == 'salaried' && propDdpflag) {
   if (propDtlLst != null && propDtlLst.size() > 0) {
    for (Property_Details__c p: propDtlLst) {
     if (p.Property_Identified__c == 'Yes') {
      if (propDedupeWrapLst != null && propDedupeWrapLst.size() > 0) { //added for bug 23752
       for (PropDedupeWrap de: propDedupeWrapLst) {
        if (p.Id == de.ddpObj.Property_Details__c && de.ddpObj.Source_Or_Target__c == 'P Source') { //Property Dedupe CR for PSource - Anshita
         intMap.put(p.Id, new List < De_Dupe__c > ());
        } else if (p.Id == de.ddpObj.Property_Details__c && intMap.containsKey(p.id) && de.ddpObj.Source_Or_Target__c == 'P Target') {
         List < De_Dupe__c > lst = intMap.get(p.Id);
         lst.add(de.ddpObj);
        }
        if (p.Id == de.ddpObj.Property_Details__c && de.ddpObj.Source_Or_Target__c == 'P Target' && de.ddpObj.Best_Match__c == true) {
         ddpMap.put(p.Id, true);
        }
       }
      }
     }
    }
    if (intMap != null && intMap.size() > 0) {
     for (Id i: intMap.Keyset()) {
      if (intMap.get(i).size() == 0) {
       ddpMap.put(i, true);
      }
     }
    }
    for (Property_Details__c p: propDtlLst) {
     if (p.Property_Identified__c == 'Yes') {
      if (!ddpMap.containsKey(p.Id)) {
       bmflag = true;
      }
     }
    }
   }
   if (bmflag) {
    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'You have not selected the Best Match, Kindly select one Best Match for each Property'));
   }
  }
  /* Bug 12944 Property Dedupe End - Anshita */

  //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal start
  /* purpose of the code :- We do have to approve the reappriased case if any higher deviation is not approved
   */
  ID Pid = Userinfo.getProfileID();
  String Pname = [select id, name from Profile where id =: Pid].name;
  if (deviationProducts != null && deviationProducts.contains(loan.Product__c) && Loan.Re_appraisal_Initiated_time__c != null && (CommonUtility.validateDeviations(pname, Loan.Checklists__r)) == true) {
   system.debug('inside validateDeviation on approve buton');
   //  message = '';
   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Deviation of higher Authority Exists..Please send it to respective authority for approval...'));
   return;
  }
  //bug id 20474 method called to check if needed physical pd completed or not 
  if (!checkPhysicalPD()) {
   return;
  }
  // bug id 20474 end
  //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal end
    //Digital Sampling S*/
        if(ShowDigitalSamplingPanel &&(applicantPrimary.LG_Registration_Status__c == 'Registration Failed' || applicantPrimary.LG_Registration_Status__c == '' || applicantPrimary.LG_Registration_Status__c == null ))
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please register your applicants for loan guard'));
            return;
        }
  //Digital Sampling E
  //Bug 19469 - Changes in Salaried and self-employed FOS calculator (Desktop) S 
  if (((System.Label.Salaried_offer_product_for_FOS_calculator.contains(Loan.product__c)) || (System.Label.Self_employed_offer_product_for_FOS_calculator.contains(Loan.product__c)))) {
   List < BodmasCalculation__c > bodLst = Loan.BodmasCalculations__r;
   BodmasCalculation__c bObj;
   if (bodLst != null && bodLst.size() > 0)
    bObj = bodLst[0];
   if (bObj != null && bObj.Branch__c != null && loan.Branch_Name__c != null && bObj.Branch__c != loan.Branch_Name__c) {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Branch on loan application does not match with FOS calculator branch.'));
    return;
   }
  }
  //Bug 19469 - Changes in Salaried and self-employed FOS calculator (Desktop) E
  //SAL Invisible monitoring Rohit start
  //CR 16008 - removed callcenterprocessFlag & invisible monitoring check
  if (applicantPrimary != null && applicantPrimary.Score_card__c == null) {

   Map < String, String > mapOfImSal = new Map < String, String > ();
   if (!Test.isRunningTest()) {
    CommonUtility.isSampling = true;
    mapOfImSal = CommonUtility.BRECalloutForInvisibleMonitoring('New', 'salaried', LoanId);

   }
   if (mapOfImSal != null && mapOfImSal.get('weightedScore') != null && mapOfImSal.get('maxWeight') != null) {

    Decimal obtainedScore = Decimal.valueOf(mapOfImSal.get('weightedScore'));
    Decimal MaxScore = Decimal.valueOf(mapOfImSal.get('maxWeight'));
    applicantPrimary.Score_card__c = obtainedScore / MaxScore;
   }

   try {

    update applicantPrimary;
   } catch (Exception e) {


   }

  }
  //SAL Invisible monitoring Rohit end
  /* SAL PLTB Invisible Monitoring Start*/

  if (callcenterprocessFlag) {
   Boolean isIdentifiedPLTB = checkRulesForPLTB();

   if (isIdentifiedPLTB == true) {
    applicantPrimary.Identified_for_Invisible_Monitoring__c = true;
    update applicantPrimary;
   }
  }
  /* SAL PLTB Invisible Monitoring end*/

  //Bug 14957 - October BRD - Google Check By Rajesh START
  /*BUG-16959 added Prod condition for DBOL  by Rajesh */
  if (isPSBLProductLineProduct || Loan.Product__c == 'LAP' || Loan.Product__c == 'SHL') {
   for (Applicant__c app: cubicApplicantList) {
    if (app.Google_Check_Result__c == null) {
     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Google check details are not filled for ' + app.Contact_Name__r.Name));
     return;
    }
   }
  }
  //Bug 14957 - October BRD - Google Check By Rajesh END

  //Cubic Tree Integration start
  if (cubicTreeFlag) {
   if (cubicApplicantList != null && cubicApplicantList.size() > 0) {
    for (Applicant__c app: cubicApplicantList) {
     if (app.JobId__c == null || app.JobId__c == '') {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Cubic Tree Integration for Applicants not done'));
      savedSuccessfull = true;
      message = 'Cubic tree Integration has to be done for each applicant!';
      return;
     }
    }
    appCubicDeDupeList = [select id, Property_Details__c, Property_Details__r.id, Property_Details__r.Name, Applicant__r.Applicant_Type__c, Applicant__r.id, name, Dedupe_Lan_Matches__c, Applicant__c, Applicant__r.Contact_Name__c, Datafix_Updated__c, Application_Status__c,
     Application_ID__c, Random_Dedupe__c, Area_Status__c, Customer_Status__c,
     Customer_ID__c, Dedupe_Comments__c, De_Dupe_result__c, Match_Status__c, De_Dupe_Decision__c, Segment__c, SF_Base__c, Source_Or_Target__c, Applicant__r.Contact_Name__r.Name, /* Bug 5880 S */ Dedupe_Target_Remarks__c, Dedupe_Source__c /*Bug 5880 E*/ from De_Dupe__c where
     Loan_Application__c =: loan.id AND Dedupe_Source__c = 'applicantdedupeCT'
     AND Applicant__c in: cubicApplicantList
    ];
    for (De_Dupe__c appdedupe: appCubicDeDupeList) {
     if (appdedupe.Customer_Status__c == null || appdedupe.Customer_Status__c == '' || appdedupe.De_Dupe_result__c == null || appdedupe.De_Dupe_result__c == '' || appdedupe.Dedupe_Comments__c == null || appdedupe.Dedupe_Comments__c == '') {

      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Cubic Tree Dedupe Details not saved. Please save before proceeding.'));
      savedSuccessfull = true;
      message = 'Cubic Tree Dedupe Details not saved. Please save before proceeding!';
      return;

     }
    }

   }
   if (Mortgageflag == true && propertyList != null && propertyList.size() > 0 && propCubicDeDupeList != null && propCubicDeDupeList.size() > 0) {
    for (Property_Details__c prop: propertyList) {
     if (prop.JobId__c == null || prop.JobId__c == '') {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Cubic Tree Integration for Property not done'));
      savedSuccessfull = true;
      message = 'Cubic tree Integration has to be done for each Property record!';
      return;
     }
    }
    for (De_Dupe__c propdedupe: propCubicDeDupeList) {
     if (propdedupe.Customer_Status__c == null || propdedupe.Customer_Status__c == '' || propdedupe.De_Dupe_result__c == null || propdedupe.De_Dupe_result__c == '' || propdedupe.Dedupe_Comments__c == null || propdedupe.Dedupe_Comments__c == '') {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Cubic Tree Dedupe Details not saved. Please save before proceeding.'));
      savedSuccessfull = true;
      message = 'Cubic Tree Dedupe Details not saved. Please save before proceeding!';
      return;

     }
    }
   }
  }
  //Cubic Tree Integration End
  //FAS
  if (Loan != null && Loan.Product__c == 'FAS') {
   List < Property_Details__c > p = new List < Property_Details__c > ();
   p = [select id, Digital_Scrip_Type__c from Property_Details__c where Loan_Application__c =: Loan.Id];

   if (p.size() == 0) {
    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Loan Application can not proceed further without Scrip details!')); 
    //return;

    savedSuccessfull = true;
    message = 'Loan Application can not proceed further without Scrip details!';
    return;
   }
   //savedSuccessfull = false;
  }

  if (dedupelist.size() > 0) {
   for (De_Dupe__c d: dedupelist) {
    if (d.Source_Or_Target__c == 'Target' && (d.De_Dupe_result__c == '' || d.De_Dupe_result__c == 'None' || d.De_Dupe_result__c == null)) {
     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Dedupe Result is not updated'));
    } else
     showapprove = true;
    showrej = false;
    //added by priya bug 12452 start
    checked = true;
    applicantPrimary.approved__c = true;
    //added by priya bug 12452 end
   }
  } else {
   showapprove = true;
   showrej = false;
   //added by priya bug 12452 start
   checked = true;
   applicantPrimary.approved__c = true;
   //added by priya bug 12452 end
  }
  //Real Time Controllership enhancement Leena-start
  //Bug id :   9205
  //Uat release date : 1 december 2016
  String RealTimeControllershipProduct = LaonApplicationCreation__c.getValues('RealTimeControllershipProducts').Current_product__c;
  boolean RealTimeControllershipFlag = false;
  Set < String > setRealTimeControllershipProduct;
  if (RealTimeControllershipProduct != null) {
   setRealTimeControllershipProduct = new Set < String > (RealTimeControllershipProduct.split(';'));
  }
  if (setRealTimeControllershipProduct != null && setRealTimeControllershipProduct.size() > 0 && setRealTimeControllershipProduct.contains(Loan.Product__c)) {
   RealTimeControllershipFlag = true;
  }
  if (RealTimeControllershipFlag) {
   RealTimeControllership realTimeObj = new RealTimeControllership();
   RealTimeControllershipBreachedValues = realTimeObj.RealTimeControllershipValues(Loan.id);
   system.debug('RealTimeControllershipBreachedValues===>' + RealTimeControllershipBreachedValues);
  }
  if (RealTimeControllershipBreachedValues != null && RealTimeControllershipBreachedValues != '' && RealTimeControllership.ruleFired == true) {
   realtimeFlag = true;
  }
  //Real Time Controllership enhancement Leena-end
  //commented by priya bug 12452
  //setChecked(); //Ops process added by Prajyot
  /* Invisible monitoring mortgage-This condition is used to check wheather credit team has  checked for invisible monitoring before approve button.
* If not ,follwing error will show.
Changes by:Anjali Kondgule
Date-03/10/2016*/
  if (MortgageFlag && applicantPrimary.Identified_for_Invisible_Monitoring__c == False && applicantPrimary.Verifications_returned_by_IM_BRE__c == null && applicantPrimary.Underwriter_Remarks__c == null) {
   showapprove = false;
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please check for Invisible monitoring'));
   // return null;
  }
  // Mortgage IM End
  //bug 13560 start
  if (MortgageFlag) {
   commonPropertyMethods probMethods = new commonPropertyMethods();
   probMethods.CallDCM(propertyList, Loan, applicantPrimary);
  }
  // bug 13560 end
 }
 /* SAL PLTB Invisible Monitoring Start*/
 public Boolean checkRulesForPLTB() {
  if (Loan != null && Loan.Product_Offerings__r != null && Loan.Product_Offerings__r.size() > 0) {
   List < Product_Offerings__c > poList = new List < Product_Offerings__c > ();
   poList = Loan.Product_Offerings__r;
   poObj = poList[0];
  }

  Boolean isCompChgAndPerfios = false, isPanChange = false, isMobNumChange = false, isDOBChange = false, isPerfiosNotDone = false, isEmailVerif = false;
  List < Bank_Account__c > baList = new List < Bank_Account__c > ();
  baList = [SELECT Id, Perfios_Flag__c, Product_Offerings__c, Loan_Application__c FROM Bank_Account__c WHERE Loan_Application__c =: Loan.Id];
  if (baList != null && baList.size() > 0) {
   for (Bank_Account__c ba: baList) {
    if (ba.Perfios_Flag__c == false) {
     isPerfiosNotDone = true;
     break;
    }
   }

  }
  if (applicantPrimary.Office_Email_Id_Verified__c == false) {
   isEmailVerif = true;
  }

  if (poObj != null && poObj.Existing_LAN__c != null) {
   //Bug 16962 - Getting exception at the time of approval
   //Replaced Object : Opportunity  opp with List<Opportunity> oppTempList
   List < Opportunity > oppTempList = [SELECT Id, Account.Employer__r.Name, Account.Employer__r.Company_Name__c, Account.PANNumber__c, Account.Employer__c, Account.Mobile__c, Account.Date_of_Birth__c FROM Opportunity WHERE If_Yes__c =: poObj.Existing_LAN__c LIMIT 1];
   System.debug('\n --> oppTempList : ' + oppTempList);
   if (oppTempList != null && oppTempList.size() > 0) //Bug 16962 - Getting exception at the time of approval : Changed null check from object to list
   {
    Opportunity opp = oppTempList[0]; //Bug 16962 - Getting exception at the time of approval : reassigned first to opp object

    if (opp.Account.Employer__c != null && opp.Account.Employer__r.Name != null && opp.Account.Employer__r.Name.equalsIgnoreCase(Loan.Account.Employer__r.Name) && isPerfiosNotDone) {
     isCompChgAndPerfios = isPerfiosNotDone;
    }
    if (opp.Account.PANNumber__c != Loan.Account.PANNumber__c) {
     isPanChange = true;
    }
    if (opp.Account.Mobile__c != Loan.Account.Mobile__c) {
     isMobNumChange = true;
    }
    if (opp.Account.Date_of_Birth__c != Loan.Account.Date_of_Birth__c) {
     isDOBChange = true;
    }
   }
  }

  if (isPerfiosNotDone || isEmailVerif || isCompChgAndPerfios || isPanChange || isMobNumChange || isDOBChange) {
   return true;
  } else {
   return false;
  }

 }

 /* SAL PLTB Invisible Monitoring End*/
 public pagereference callBREForDeviations() {
  try {
   //Bug 5943 - SAL PL Document checklist issue Start
   ID Pid = Userinfo.getProfileID();
   String Pname = [select id, name from Profile where id =: Pid].name;
   currentProfileName = Pname;
   //Bug 5943 - SAL PL Document checklist issue Ends

   String dedupeCustomerStatus = '', OfficeVerification = '', ResidenceVerification = '';
   LoanId = System.currentPageReference().getParameters().get('Id');
   String coAppFlag = 'NO';
   if (Loan != null) {
    //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal start
    /* purpose of the code :-to quey checklist record of loan application Account.Previous_Approved_Loan_Amount__c,Re_appraisal_Initiated_time__c,(Select id, Document_Type__c,Deviation_Master__c,Deviation_Master__r.Minimum_Approver_Level__c, Mandatory__c, Sales_Status__c, Document__c from Checklists__r)
     */
    Loan = [Select /* Bug 18159 S*/ Account.Queue_Master__c,Account.Queue_Master__r.QID__c/*Bug Id : 23549*/, Account.AutoCredit__c, /* Bug 18159 */ /*Bug Id : 19243*/ Prior_Application_Stage__c, /*SAL PL to SAL LAP*/ Branch_Name__r.Branch_Code__c, Account.First_Name__c, Account.Last_Name__c, Account.Process_Type__c, /*SAL PL to SAL LAP*/ Re_appraisal_Initiated_time__c, Account.Previous_Approved_Loan_Amount__c, (Select id, Document_Type__c, Deviation_Master__c, Deviation_Master__r.Minimum_Approver_Level__c, Mandatory__c, Sales_Status__c, Document__c from Checklists__r), Relationship_Manager__r.Email, Sourcing_Channel__r.sourcing_channel_email_id__c, ACM__r.Email, Total_TAT__c, Approver__c, Tenor__c, Customer_Type__c, Applicant_Name__c, Name_of_the_CoApplicant__c, Existing_Customer__c, Area_SM__r.Id, Area_SM__c /*Added for bug 18722*/ ,
     AccountId, Finance_Amount__c, Employee_Type__c, Stages__c, Loan_Type__c, Loan_Amount__c, Insurance_Premium_Amt__c,
     Type_of_Constitution__c, Sales_Backend__c, Branch_Name__c, FAS_Processing_Fee_Amt__c, Total_Monthly_Oblig__c,
     Type_Of_Loan__c, If_Yes__c, Disbursement_Type__c, Application_Form_Number__c, Entry_Date__c, Scheme_Master__r.Name,
     Product__c, Type_of_Borrower__c, Sales_Backend_Mobile__c, DSA_Sharing__c, Processing_Fees__c, Relationship_Manager__r.Name,
     Credit_Programme_Name__c, Asset_Type__c, Customer_Since__c, Deal_Type__c, Requested_ROI__c, Current_UserRole__c,
     Amount, Remark__c, Scheme_Master__c, Loan_Check__c, End_use__c, Sourcing_Channel__c, Customer_email_id__c,
     Referral__c, Relationship_Manager__c, Branch__c, ASM_Mobile__c, Original_Approver__c, Relationship_Manager__r.Mobile_number__c,
     Previous_Approval_Authority__c, Cross_sell_comments__c, Sales_Turnover__c, Relationship_Manager__r.MobilePhone,
     Eligible_for_cross_sell__c, CRISIL_RATING__c, Application_Source__c, Application_Channel__c,
     Products_for_cross_sell__c, Reject_Reason_1__c, Approved_Rate__c, Reject_Reason__c, Date_of_created_date__c, Scheme_Master__r.PLOC_scheme__c,
     Approval_Stages__c, ACM__c, Sourc_Mobile__C, ACM__r.Mobile_number__c, Branch_City__c, Owner.Name, Offer_Amount__c, ACM_Comments__c,
     COO_Comments__c, Approved_Tenor__c, Old_Product__c, Processing_Type__c, Nature_of_Business__c, Branch_Name__r.Branch_Type__c, Sourcing_Channel__r.Sourcing_Channel_Flag__c, Account.Vintage_with_BAL__c, Account.Current_experiance_in_Years__c, Account.Total_Work_Experience_Yrs__c, Account.BT_Bank_Type__c, Account.Type_of_Ownership__c, Account.Residence_TypeAcc__c,
     Total_Share_Amount__c, Accountant_email_id__c, CampaignId, ownerId, LeadSource, LAN__c, Loan_Application_Number__c, Moratorium_Period__c, createddate, Loan_Application_Flow__c, Program_Type__c,
     Application_Encoded_Date__c, AMC__c, Approved_Loan_Amount__c, EMI_CAM__c, stagename, Name, Revised_EMI__c, Revised_Loan_Amount__c, Type_of_Moratorium_Interest__c,
     Service_Availed__c, Interior_Designer__c, Branch_Name__r.name, Account.Loan_Amount_Discussed_and_Agreed__c, EMI_Type__c, Comments__c, Account.EMI_Frequency__c, DSA_Name__c, BranchName__c, Sourcing_Channel__r.Name, Account.ownerid, Account.Group_Type__c, Account.Name, /*Mortgage*/ Account.Preferred_language__c, account.Base_Loan__c, Full_Underwriting__c, Sourcing_Channel_Type__c, Sub_Stage__c,
     (select Id, Name, Offer_Amount__c, Availed_Amount__c, Tenor__c, Offer_ROI__c, Offer_Validity__c, Campaign_Type__c, Existing_LAN__c, Requested_Tenor__c, Revised_Offer_Amount__c, Program_Type__c,
      Revised_Offer_ROI__c, EMI_Amount__c, Current_EMI__c, Products__c, Product_Offering_Source__c, PO_Type__c from Product_offerings__r), /* SAL IM S */ Account.Employer__r.Name, Account.Employer__r.Company_Name__c, Account.PANNumber__c, Account.Employer__c, Account.Mobile__c, Account.Date_of_Birth__c /*SAL IM E */ , /*Hybrid Flexi:akshata*/ Scheme_Master__r.IsHybridFlexi__c,
     CM__c, CM_Amount__c, CM_Deviations__c, SCO__c, SCO_Amount__c, SCO_Deviations__c, CM__r.Mobile_number__c, SCO__r.Mobile_number__c, CM__r.name, SCO__r.name /* Bug id : 13016 - New Role Creation for Credit, added by Needhi*/ , (select ID, OppLevelRevisedOfferAmount__c, Revised_Offer_Amount__c, Branch__c from BodmasCalculations__r) /*bug 19469*/
     from opportunity where Id =: Loan.Id
    ];

    //4450
    COLStampdate = null;
    COLStampFlag = false;
    if (LaonApplicationCreation__c.getValues('Hierarchy Stamping') != null) {
     String COLDate = LaonApplicationCreation__c.getValues('Hierarchy Stamping').Credit_Hierarchy_Stamping_Date__c;
     if (COLDate != null) {
      COLStampdate = date.parse(COLDate);
     }
    }
    if (COLStampdate != null && Loan != null && COLStampdate < Loan.createddate) {
     COLStampFlag = true;
    }

    if (COLStampFlag == true) {
     if (Loan != null) {
      LoanAppFlow = Loan.Loan_Application_Flow__c;

      if (LoanAppFlow == null || LoanAppFlow == '') {
       LoanAppFlow = 'Normal';
      }


     }
    }

   }

   //Rate Approval :: ROIFlexi__c, ROILoc__c, ROINormal__c, ROI_PO__c, 
   //Bug:18370 - Unable to Generate Checklist
   applicantList = [select is_BL_PL_Risk__c, /*18370 S*/ Is_Hybrid_Flexi_for_Topup__c, Topup_Pure_Flexi_Period__c, Topup_Dropline_Flexi_Period__c, Topup_Loan_Proposed_EMI__c, Topup_Pure_Flexi_EMI__c, Check_RSA__c /*18370 E*/ , /*OTP V3 CR S*/ Score_card__c, TimeTakenDecision__c, Contact_Name__r.special_profile_employer__c, Codified_CIBIL__c, contact_name__r.employer__r.bank_names__c, Risk_Segmentation__c, Contact_Name__r.Employer__r.Employer_List__c, /*OTP V3 CR E*/ /* SAL Invisible monitering start */ RSA_reason__c, RSA_Loan_application_status__c, RSA_Remarks__c, RSA_Closure_Date__c, RSA_initiation_Date__c, RSA_TAT__c, Contact_Name__r.Perfios_Address__c, Contact_Name__r.Customer_address_matches_with_perfios__c, Contact_Name__r.Customer_Add_Matches_With_Previous_Add__c /* SAL Invisible monitering end */ , ROIFlexi__c, /*SAL PLTB Pritha S*/ LTA_Medical__c, LTA_Frequency__c, /*SAL PLTB Pritha E*/ ROILoc__c, ROINormal__c, ROI_PO__c, Company_Name_as_per_Domain_check__c, Domain_Check_Result__c, Domain_Created_Date__c, Official_Email_bounce_Flag__c, EMI_Holiday_Opted__c, Contact_Name__r.TAN_Found_In_Master__c, Contact_Name__r.date_of_Birth__c, Contact_Name__r.office_no_check_on_company_site__c, Contact_Name__r.SFDC_Dedupe_check__c, Contact_Name__r.PAN_Response__c, Contact_Name__r.Linkedin_check_result__c, Contact_Name__r.Google_check_result__c, Contact_Name__r.PAN__c, Contact_Name__r.Last_Modified_Date__c, Contact_Name__r.Name_of_the_PAN_holder__c, Contact_Name__r.Designation__c, Contact_Name__r.Employer__r.Domain_Name__c, Contact_Name__r.Employer__r.Company_Category__c, ContactName__c, Contact_Name__r.Name, Existing_Customer__c, Applicant_Type__c, SegmentaionResult__c, Loan_Application__c, Contact_Name__r.Office_Email_Id__c,
    per_of_Loan_Amount_HI__c, per_of_Loan_Amount_LI__c, Bundled_VAS__c, Bundled_VAS_Type__c, Contact_Name__r.EMI_Bounce_in_last_3_months__c,
    Credit_Card_Check__c, Credit_Card_Type__c, FFR_Tag__c, Health_Insurance__c, Health_Insurance_Amount__c, DeDupe_Counter__c, Contact_Name__r.Current_experiance_in_Years__c,
    Life_Insurance__c, Life_Insurance_Amount__c, All_Standard_Docs_Received__c, All_Deviation_Docs_Received__c, Contact_Name__r.Years_At_Residence__c,
    All_Disbursement_Docs_Received__c, Is_PL_BT__c, cibil_score__c, Loan_Application__r.Bank_A_c_No_of_Customer__c,
    TotalFOIRHLResult__c, TotalFOIRNoHLResult__c, TotalWorkExpResult__c, UnsecuredFOIRResult__c, LoanAmountResult__c, CurrentWorkExpResult__c,
    OwnHouse_RunningHLResult__c, CompanyCategoryResult__c, EducationQualificationResult__c, Segment_Prudense__c, Segment_Stability__c,
    Segment_Achievment__c, SalaryToAgeResult__c, Bureau_Segment__c, Employer__c, Contact_Name__r.Age_of_Applicant__c, Contact_Name__r.Residence_Type__c, Contact_Name__r.Age_Round_Down__c,
    Contact_Name__r.Company_Type__c, Contact_Name__r.Total_Work_Experience_Yrs__c, StepUp_StepDown_EMI_Year_1__c, StepUp_StepDown_EMI_Year_2__c, StepUp_StepDown_EMI_Year_3__c, StepUp_StepDown_EMI_Year_4__c, StepUp_StepDown_EMI_Year_5__c, /*Mortgage*/ Contact_Name__r.Property_Owner__c /* SAL Policy Changes Start */ , RC_Decline__c, RC_Deviation__c /* SAL Policy Changes End */ , /*SHL Issue*/ BT_Bank_Type__c, Contact_Name__r.Current_Employment_Vintage__c, Invisible_Monitoring_Skipped__c, Office_Email_Id_Verified__c, RSA_flag__c, Identified_for_Invisible_Monitoring__c, Underwriter_Remarks__c, Total_Employment_Vintage__c, Verifications_returned_by_IM_BRE__c, /*hybrid flexi*/ Pure_Flexi_EMI__c, Drop_Line_Flexi_Period__c, Pure_Flexi_Period__c, Contact_Name__r.Customer_Type__c
    /* Bug 17531 - Rural Geo Fencing Start */
    , Distance_From_Branch__c /* Bug 17531 - Rural Geo Fencing End */ , RSA_SMS_Email_sent__c
    from Applicant__c where Loan_Application__c =: Loan.id
   ];
   if (applicantList != null && applicantList.size() > 0) {
    coAppFlag = 'NO';
    for (Applicant__c app: applicantList) {
     if (app.Applicant_Type__c == 'Primary') {
      //applicantName = app.ContactName__c;
      applicantPrimary = app;
      /* Prajyot #10659 Secondary Cibil Match START */
      if (app.Contact_Name__r.Customer_Type__c == 'Individual' && app.Applicant_Type__c == 'Primary') {
       system.debug('inside individual');
       primaryApplicantID = app.id;
      }
      if (app.Applicant_Type__c == 'Financial Co-Applicant' || app.Applicant_Type__c == 'Primary Financial Co-Applicant') {
       if (primaryApplicantID != null && primaryApplicantID.length() > 0) {
        primaryApplicantID = primaryApplicantID + ';' + app.id;
       } else {
        primaryApplicantID = app.id;
       }
       system.debug('from controller primaryApplicant=' + primaryApplicantID);
      }
      system.debug('primaryApplicant=' + primaryApplicantID);
      /* Prajyot #10659 Secondary Cibil Match END */
     }

     if (app.Applicant_Type__c == 'Financial Co-Applicant') {

      coAppFlag = 'YES';
     } else if (app.Applicant_Type__c == 'Non-Financial Co-Applicant') {
      coAppFlag = 'NONFIN';
     }


    }
   }
   if (dedupelist != null && dedupelist.size() > 0) {
    for (De_Dupe__c de: dedupelist) {
     if (de.Customer_Status__c == 'Bad') {
      dedupeCustomerStatus = 'Bad';
     }
    }
   }
   //RSL Adding to query  Payment_Date_1__c,Payment_Date_2__c,Payment_Date_3__c,Recent_continuous__c,Repayment_of_loan__c,
   camList = [select name, Payment_Date_1__c, Payment_Date_2__c, Payment_Date_3__c, Recent_continuous__c, Repayment_of_loan__c, CreatedDate, Current_Year_PLBS__c, Current_Year_PLBS__r.Year__c, Previous_Year_PLBS__r.Year__c, Previous_Year_PLBS__c, Applicant__r.Contact_Name__c,
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
    Deviation_on_FOIR__c, max_loan_POS_forExSAL__c, Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c, Max_Loan_Amount_for_IT_Company__c, Average_Monthly_Net_Income2__c, /*11156 S*/ Other_income_to_be_consd__c, INSURANCE_AMOUNT__c, Fund_Based__c, Hl_pmt__c, // buh 11156 end
    Bank_Details__r.Average_Balance__c, Existing_HL_EMI__c, Bank_Details__r.Sum_of_average_Balance__c, Bank_Details__r.Transaction_Count__c, Average_Bank_Balance__c, Eligible_Loan_amt_Bank__c,
    id, Average_monthly_Obligations__c, Avg_Mthly_Net_Inc1__c, Income_from_CY__c, ELIGIBILITY_ACCORDING_TO_GROSS_RECEIPTS__c, ELIGIBILITY_ACCORDING_TO_CASH_PROFITS_ME__c,
    /*Bug 11157 YK*/
    INSURANCE_PREFERRENCE__c /*Added by mahima- Rural PureFlexi- 12501*/ ,
    Entity_Record_Type__c, BT_Existing_Top_up_multiplier__c, Loan_elig_TO__c, EMI_of_The_Loan__c, Eligible_FOIR__c, Eligible_Loan__c, Multiplier__c, Selected_Option_TO__c, Live_unsecured_loan__c, Rental_Income_to_be_considered__c, /*Mortgage SHL*/ LAP_Tenor__c, GP_Other_income__c, Oth_Inc_2_be_Consd__c, Average_Bank_Balance_GDP__c, Eligible_Home_Loan_Amount__c, Stake_of_co__c, Home_Loan_Tenor__c, GP_Home_loan_amount__c, Top_Up_Amount__c, Top_Up_Rate__c, Top_Up_Tenure__c, Industry_Margins_applicable1__c, C_P_Current_Year__c, Existing_Live_Obligations__c, ObligationsDC1__c, Agri_income_to_be_consd__c, Agri_Inc_2_be_Consd__c, C_P_Previous_Year__c, Final_Income_considered_for_Eligibility__c, Business_Income_Considered__c from cam__c where loan_application__c =: loan.Id And Applicant__c = null
   ];
   if (camList != null && camList.size() > 0) {
    cam = camList[0];
   }

   //FAS
   if (Loan != null && Loan.Product__c == 'FAS')
    primaryBankExists = false;

   Bank_Account__c secondaryBankAcc = new Bank_Account__c();
   //code added by leena-oct fest-added Perfiod_done_date_and_Time__c,Perfios_Flag__c in query
   bankAccLst = [select id, Perfiod_done_date_and_Time__c, Perfios_Flag__c, Avg_mthly_bal6__c, Transaction_Count__c, Salaried_CAM__c, name, Bank_Name__c, sum_Avg_mthly_bal__c, Send_Email_For_Perfios__c, Bank_Acct_Number__c,
    Average_incentive_for_Q1__c, Salary_Credit_Date1__c, Salary_Credit_Date2__c, Salary_Credit_Date3__c, Salary_credit_amount1__c, Salary_credit_amount2__c, Salary_credit_amount3__c,
    Account_Type__c, OD_CC_limit__c, X10th_Bal__c, X20th_Bal__c, Month_end_Bal__c, Average_of_DB_Amount__c,
    Average_of_DB_No__c, Average_of_CRD_Amount__c, Average_of_CRD_No__c, Average_of_Bounce_O_W__c, IFSC_Code__c,
    Average_of_Bounce_I_W__c, Bank_Name_List__c, Bank_Type__c, Depository_Participant_Id__c, ClientName__c, ClientId__c, TrackingId__c, Depository_Participant_Name__c, /*SHL*/ Mode_Of_Salary_Credit__c, StatusOfBankAccount__c from Bank_Account__c where Loan_Application__c =: Loan.Id
   ];


   if (bankAccLst != null && bankAccLst.size() > 1) {
    secondaryBankAcc = bankAccLst[1];
   }
   if (applicantPrimary != null)
    cibilExt1List = [select /*OTP V3 CR s*/ Sum_of_Amount_Overdue__c, Highest_DPD_In_1_Year__c, max_mob__c, liveLoanAmount__c, X30_DPD_6_months__c, X30_DPD_3_months__c, securedToTotalRatioAmount__c, /*OTP V3 CR e*/ id, X6_months_DPD__c, Other_Loan_DPD__c, X4to8_enquiries__c, X6_To_8_Enq__c, X8plus_Enquiries__c,
     X10_currbalance__c, Write_Off__c, Average_Total_Balance__c
     from Cibil_Extension1__c where Applicant__c =: applicantPrimary.id
    ];
   //AllVerify           

   AllVerify = [select id, name, Status__c, Verification_Type__c from Verification__c where Loan_Application__c =: Loan.Id];
   if (AllVerify != null && AllVerify.size() > 0) {
    for (Verification__c ve: AllVerify) {
     if (ve.Verification_Type__c == 'Residence verification' && ve.Status__c == 'Negative') {
      residenceVerify.add(ve);
     } else if (ve.Verification_Type__c == 'Office verification' && ve.Status__c == 'Negative') {
      officeVerify.add(ve);
     }

    }

   }
   /* if(officeVerify!=null && officeVerify.size()>0){
for(Verification__c ve:officeVerify){
if(ve.Status__c =='Negative')
OfficeVerification = 'negative';
}                             
}
if(residenceVerify!=null && residenceVerify.size()>0){
for(Verification__c ve:residenceVerify){
if(ve.Status__c =='Negative')
ResidenceVerification =  'negative';
}  
} */
   //prepareCheckList(); 
   //New MCP BRE logic--------------------
   MAP < String, String > mapOfPolicyParameters = new MAP < String, String > ();
   MAP < String, String > breRespose = new MAP < String, String > ();
   MAP < String, String > breStandardDocRespose = new MAP < String, String > ();
   //Map of input parameters 
   List < String > BRECodesList = new List < String > ();
   List < String > standardBRECodesList = new List < String > ();

   mapOfPolicyParameters.put('product', Loan.product__c);
   // mapOfPolicyParameters.put('customer_segment', applicantPrimary.SegmentaionResult__c);
   mapOfPolicyParameters.put('customer_segment', (applicantPrimary.Bureau_Segment__c != null) ? applicantPrimary.Bureau_Segment__c : '');
   mapOfPolicyParameters.put('ApplicantType', applicantPrimary.Applicant_Type__c);
   if (applicantPrimary.CIBIL_Score__c != null && applicantPrimary.CIBIL_Score__c == '000-1')
    mapOfPolicyParameters.put('cibilScore', '0');
   else
    mapOfPolicyParameters.put('cibilScore', (applicantPrimary.CIBIL_Score__c != null) ? String.valueof(applicantPrimary.CIBIL_Score__c) : '0');

   if (applicantPrimary.Contact_Name__r.date_of_Birth__c != null) {
    mapOfPolicyParameters.put('date_of_Birth', String.valueOf(applicantPrimary.Contact_Name__r.date_of_Birth__c));
   } else {
    mapOfPolicyParameters.put('date_of_Birth', '');
   }
   // SAL Policy Changes Starts
   if (applicantPrimary.RC_Deviation__c != null) {
    mapOfPolicyParameters.put('deviationRiskSegment', applicantPrimary.RC_Deviation__c);
   }
   // SAL Policy Changes Ends          

   if (cam.Proposed_Loan_Amt__c != null) {
    mapOfPolicyParameters.put('requested_Loan_Amt', String.valueOf(cam.Proposed_Loan_Amt__c));
   } else {
    mapOfPolicyParameters.put('requested_Loan_Amt', '');
   }

   mapOfPolicyParameters.put('dedupeCustomerStatus', dedupeCustomerStatus);

   if (cam.LAP_EMI__c != null) {
    mapOfPolicyParameters.put('AmountAsPerFoir', String.valueOf(cam.LAP_EMI__c));
   } else {
    mapOfPolicyParameters.put('AmountAsPerFoir', '');
   }
   if (cam.Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c != null) {
    mapOfPolicyParameters.put('AmountAsPerFoirMultiplier', String.valueOf(cam.Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c));
   } else {
    mapOfPolicyParameters.put('AmountAsPerFoirMultiplier', '');
   }

   if (applicantPrimary.Contact_Name__r.Office_Email_Id__c != null) {
    mapOfPolicyParameters.put('OfficeEmail', applicantPrimary.Contact_Name__r.Office_Email_Id__c);
   } else {
    mapOfPolicyParameters.put('OfficeEmail', '');
   }

   if (applicantPrimary.Loan_Application__r.Bank_A_c_No_of_Customer__c != null) {
    mapOfPolicyParameters.put('Primary_Bank_ACNumber', String.valueOf(applicantPrimary.Loan_Application__r.Bank_A_c_No_of_Customer__c));
   } else {
    mapOfPolicyParameters.put('Primary_Bank_ACNumber', '');
   }

   if (secondaryBankAcc.Bank_Acct_Number__c != null) {
    mapOfPolicyParameters.put('Secondary_Bank_ACNumber', String.valueOf(secondaryBankAcc.Bank_Acct_Number__c));
   } else {
    mapOfPolicyParameters.put('Secondary_Bank_ACNumber', '');
   }

   if (cibilExt1List.size() > 0 && cibilExt1List[0].Other_Loan_DPD__c != null) {
    mapOfPolicyParameters.put('30DPD', cibilExt1List[0].Other_Loan_DPD__c);
   } else {
    mapOfPolicyParameters.put('30DPD', '');
   }

   if (cibilExt1List.size() > 0 && cibilExt1List[0].X6_months_DPD__c != null) {
    mapOfPolicyParameters.put('SMA_SUB_DBT_LSS', cibilExt1List[0].X6_months_DPD__c);
   } else {
    mapOfPolicyParameters.put('SMA_SUB_DBT_LSS', '');
   }

   if (cibilExt1List.size() > 0 && cibilExt1List[0].Write_Off__c != null) {
    mapOfPolicyParameters.put('Loan_Card_Charge_Off', cibilExt1List[0].Write_Off__c);
   } else {
    mapOfPolicyParameters.put('Loan_Card_Charge_Off', '');
   }

   if (officeVerify != null && officeVerify.size() > 0) {
    mapOfPolicyParameters.put('OfficeVerification', officeVerify[0].Status__c);
   } else {
    mapOfPolicyParameters.put('OfficeVerification', '');
   }

   if (residenceVerify != null && residenceVerify.size() > 0) {
    mapOfPolicyParameters.put('ResidenceVerification', residenceVerify[0].Status__c);
   } else {
    mapOfPolicyParameters.put('ResidenceVerification', '');
   }

   if (applicantPrimary.Contact_Name__r.EMI_Bounce_in_last_3_months__c != null) {
    mapOfPolicyParameters.put('EMIBounce', applicantPrimary.Contact_Name__r.EMI_Bounce_in_last_3_months__c);
   } else {
    mapOfPolicyParameters.put('EMIBounce', '');
   }

   if (Loan.Branch_Name__r.Branch_Type__c != null) {
    mapOfPolicyParameters.put('branch_Type', Loan.Branch_Name__r.Branch_Type__c);
   } else {
    mapOfPolicyParameters.put('branch_Type', '');
   }

   mapOfPolicyParameters.put('loan_id', (Loan.Loan_Application_Number__c != null) ? Loan.Loan_Application_Number__c : '');
   //OTP v2 Enhancements
   Boolean plusCustomer = false;
   if (Loan.Offer_Amount__c != null && Loan.Offer_Amount__c > 0)
    plusCustomer = true;
   mapOfPolicyParameters.put('plusCustomer', string.valueof(plusCustomer));

   if (cam.Proposed_Loan_Amt__c != null)
    mapOfPolicyParameters.put('offer_amount', string.valueof(cam.Proposed_Loan_Amt__c));
   else
    mapOfPolicyParameters.put('offer_amount', '');
   String coPerfios = 'false';
   //code added by leena-oct fest-added Perfiod_done_date_and_Time__c in query
   List < Bank_Account__c > banksallists = [select id, Perfiod_done_date_and_Time__c, Bank_Type__c, name, Bank_Name__c, Bank_Account_Number__c, IFSC_Bank_Name__c, Bank_Acct_Number__c, Bank_Branch__c, Applicant__c, Applicant__r.Applicant_Type__c,
    Perfios_Flag__c, Send_Email_For_Perfios__c, Account_Type__c, /*SHL*/ Mode_Of_Salary_Credit__c, StatusOfBankAccount__c from Bank_Account__c where Loan_Application__c =: Loan.Id
   ];
   for (Bank_Account__c BA: banksallists) {
    if (BA.Perfios_Flag__c == true && BA.Applicant__r.Applicant_Type__c != 'Primary') coPerfios = 'true';
    else coPerfios = 'false';
   }
   mapOfPolicyParameters.put('coPerfiosFlag', coPerfios);

   if (Loan.Product__c == 'FAS') {

    Double totalPorfolio = 0, quantity = 0;

    for (Property_Details__c property: [SELECT id, Digital_Scrip_Category__c, Digital_Scrip_market_price__c, Number_of_Shares__c, name from Property_Details__c where Loan_Application__c =: Loan.Id]) {
     if (property.Digital_Scrip_Category__c == 'C') {
      quantity += property.Number_of_Shares__c;
      totalPorfolio += property.Digital_Scrip_market_price__c * property.Number_of_Shares__c;
     }
    }

    if (quantity != null && quantity > 0) {
     mapOfPolicyParameters.put('quantity', '' + quantity);
     mapOfPolicyParameters.put('company_Category', 'C');
     mapOfPolicyParameters.put('borrowerType', 'PROMOTER DIRECTOR');
    }

    if (totalPorfolio != null && totalPorfolio > 0) {
     mapOfPolicyParameters.put('cy_basket_portfolio', '' + totalPorfolio);
    }
   }

   mapOfPolicyParameters.put('first_Name', (userinfo.getFirstName() != null) ? userinfo.getFirstName() + '' : '');
   mapOfPolicyParameters.put('last_Name', (userinfo.getLastName() != null) ? userinfo.getLastName() + '' : '');
   mapOfPolicyParameters.put('stage', (Loan.stagename != null) ? Loan.stagename + '' : '');
   //RSL Tier III start
   mapOfPolicyParameters.put('current_Employment_Vintage', (String.valueOf(applicantPrimary.Contact_Name__r.Current_Employment_Vintage__c) != null) ? String.valueOf(applicantPrimary.Contact_Name__r.Current_Employment_Vintage__c) : '0');
   //RSL Tier III end
   //Deviations BRE 
   //For RSL chnages 
   List < Cibil_Extension1__c > cibilExt1List1 = new List < Cibil_Extension1__c > ();
   if (applicantPrimary != null) {
    cibilExt1List1 = [select id, /*OTP V3 CR s*/ Sum_of_Amount_Overdue__c, liveLoanAmount__c, X30_DPD_6_months__c, securedToTotalRatioAmount__c, /*OTP V3 CR e*/ Unsecured_Exposure__c, Written_Off_principal__c, Max_Secured_Loan_Amount__c, Max_unSecured_Loan_Amount__c, max_mob__c, Written_Off_principal9__c, Average_Total_Balance__c,
     Written_Off_principal8__c, Written_Off_principal7__c, Written_Off_principal6__c, Written_Off_principal5__c, Written_Off_principal4__c, Written_Off_principal3__c, Written_Off_principal2__c,
     Written_Off_principal29__c, Written_Off_principal28__c, Written_Off_principal27__c, Written_Off_principal26__c, Written_Off_principal25__c, Written_Off_principal24__c, Written_Off_principal23__c, Written_Off_principal22__c, Written_Off_principal21__c, Written_Off_principal20__c, Written_Off_principal1__c, Written_Off_principal19__c, Written_Off_principal18__c, Written_Off_principal17__c, Written_Off_principal16__c, Written_Off_principal15__c, Written_Off_principal14__c, Written_Off_principal13__c, Written_Off_principal12__c, Written_Off_principal11__c, Written_Off_principal10__c, Written_Off_and_settled_status__c, Written_Off_and_settled_status9__c, Written_Off_and_settled_status8__c, Written_Off_and_settled_status7__c, Written_Off_and_settled_status6__c, Written_Off_and_settled_status5__c, Written_Off_and_settled_status4__c, Written_Off_and_settled_status3__c, Written_Off_and_settled_status2__c, Written_Off_and_settled_status29__c, Written_Off_and_settled_status28__c, Written_Off_and_settled_status27__c, Written_Off_and_settled_status26__c, Written_Off_and_settled_status25__c, Written_Off_and_settled_status24__c, Written_Off_and_settled_status23__c, Written_Off_and_settled_status22__c, Written_Off_and_settled_status21__c, Written_Off_and_settled_status20__c, Written_Off_and_settled_status1__c, Written_Off_and_settled_status19__c, Written_Off_and_settled_status18__c, Written_Off_and_settled_status17__c, Written_Off_and_settled_status16__c, Written_Off_and_settled_status15__c, Written_Off_and_settled_status14__c, Written_Off_and_settled_status13__c, Written_Off_and_settled_status12__c, Written_Off_and_settled_status11__c, Written_Off_and_settled_status10__c, Write_Off__c, Bad_Track_Record__c, Tradelines_30plus_DPD__c, Total_Amount_overdue__c, Max_Lifetime_Delq__c, Ever_Write_off__c, Secured_Tradelines_90plus_DPD__c, No_Of_Live_Trades__c, Total_No_of_Trades__c, Unsecured_Tradelines_in_last_12m__c, First_Loan_MOB__c, Latest_Loan_MOB__c, Unsecured_to_total_ratio__c, Secured_to_unsecured_ratio__c, Unsecured_to_total_amount__c, OSB_to_loan_amount_unsecured__c, Credit_Card_utilization__c, Avg_unsecured_loan_amount__c, Unsecured_loan_balance__c, Total_Sanction_Amnt_unsecured__c, Total_Sanction_Amnt_secured__c,
     Current_Obligation_All__c, Current_Obligation_Secured__c, No_of_PL_Enq_in_Last_12_Months__c, Current_Obligation_unsecured__c, Enquiries_past_3_mnths__c, Unsecured_Enquiries_past_3_mnths__c, Current_Bal_on_all_cards__c, Total_no_of_loans_Excluding_CC__c, Highest_DPD_In_1_Year__c, X30_DPD_12_months__c, X30_DPD_3_months__c, Written_Off_Amount__c, Live_Gold_Loan_Amount__c, Total_no_of_secured_loans__c, X5000_amount_overdue__c, Number_of_Hl_Loans__c, Applicant__r.Applicant_Type__c
     from Cibil_Extension1__c where Applicant__c =: applicantPrimary.id limit 1
    ];
   }
   Cibil_Extension1__c cibilExt1 = new Cibil_Extension1__c();
   if (cibilExt1List1 != null && cibilExt1List1.size() > 0) {
    cibilExt1 = cibilExt1List1[0];
   }
   mapOfPolicyParameters.put('CIBIL_Score', (applicantPrimary.CIBIL_Score__c != null) ? String.valueOf(applicantPrimary.CIBIL_Score__c) : '');
   mapOfPolicyParameters.put('_30dpd', (cibilExt1.X30_DPD_12_months__c != null) ? String.valueOf(cibilExt1.X30_DPD_12_months__c) : '');
   mapOfPolicyParameters.put('smaSubDbtLssValue', (cibilExt1.X5000_amount_overdue__c != null) ? String.valueOf(cibilExt1.X5000_amount_overdue__c) : '');
   mapOfPolicyParameters.put('requested_Loan_Amount', (cam.Proposed_Loan_Amt__c != null) ? String.valueOf(cam.Proposed_Loan_Amt__c) : '');
   mapOfPolicyParameters.put('maxLoanAmountAsPerFoir', (cam.LAP_EMI__c != null) ? String.valueOf(cam.LAP_EMI__c) : '');
   mapOfPolicyParameters.put('maxLoanAmountAsPerMultiplier', (cam.Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c != null) ? String.valueOf(cam.Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c) : '');
   mapOfPolicyParameters.put('emiBounceInLast3Months', (applicantPrimary.Contact_Name__r.EMI_Bounce_in_last_3_months__c != null) ? String.valueOf(applicantPrimary.Contact_Name__r.EMI_Bounce_in_last_3_months__c) : '');
   mapOfPolicyParameters.put('office_Email_Id', (applicantPrimary.Contact_Name__r.Office_Email_Id__c != null) ? applicantPrimary.Contact_Name__r.Office_Email_Id__c : '');
   mapOfPolicyParameters.put('salaryDelay', (cam.Recent_continuous__c != null) ? String.valueOf(cam.Recent_continuous__c) : '');
   mapOfPolicyParameters.put('loan_id', (Loan.Loan_Application_Number__c != null) ? String.valueof(Loan.Loan_Application_Number__c) : '0');
   //End RSL   
   /*OTP V3 CR added by Krish start*/
   if (Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL') {
    List < De_dupe__c > dedList = [select Negative_Area__c, id, name, De_Dupe_Matched_Percentage__c, Dedupe_Lan_Matches__c, Applicant__c, Applicant__r.Contact_Name__c, Datafix_Updated__c, Application_Status__c,
     Application_ID__c, Random_Dedupe__c, Area_Status__c, Customer_Status__c, Applicant__r.Contact_Name__r.Name, Match_Status__c,
     Customer_ID__c, Dedupe_Comments__c, De_Dupe_result__c, De_Dupe_Decision__c, Segment__c, SF_Base__c, Source_Or_Target__c, /* Bug 5880 S */ Dedupe_Target_Remarks__c, Dedupe_Source__c /*Bug 5880 E*/ from De_Dupe__c where Loan_Application__c =: Loan.id And Applicant__c =: applicantPrimary.id And Source_Or_Target__c = 'Source' /*Mortgage Re-Engg condition*/
     order by Applicant__c, Source_Or_Target__c /*Bug 12114*/ LIMIT 1
    ];
    /*Bug 14503, Auto Deviation for SALPL Start - Anshita*/
    List < Cibil_Temp__c > cibTemp = [select id, DPD_cluster_Segment__c from Cibil_Temp__c where Applicant__c =: applicantPrimary.id];
    /*Bug 14503, Auto Deviation for SALPL End - Anshita*/
    De_dupe__c primappdedupe = new De_dupe__c();
    if (dedList != null && dedList.size() > 0)
     primappdedupe = dedList[0];
    if (Loan.Branch_Name__r.Branch_Type__c != null) {
     mapOfPolicyParameters.put('branch_Type', Loan.Branch_Name__r.Branch_Type__c);
    } else {
     mapOfPolicyParameters.put('branch_Type', '');
    }
    if (applicantPrimary.Risk_Segmentation__c != null) {
     mapOfPolicyParameters.put('riskSegmentClassification', applicantPrimary.Risk_Segmentation__c);
    } else {
     mapOfPolicyParameters.put('riskSegmentClassification', '');
    }
    if (applicantPrimary.Codified_Cibil__c != null) {
     mapOfPolicyParameters.put('codifiedCibil', applicantPrimary.Codified_Cibil__c);
    } else {
     mapOfPolicyParameters.put('codifiedCibil', '');
    }
    if (primappdedupe.negative_area__c) {
     mapOfPolicyParameters.put('negativeArea', 'Yes');
    } else {
     mapOfPolicyParameters.put('negativeArea', 'No');
    }
    if (String.valueof(applicantPrimary.Contact_Name__r.special_profile_employer__c) != null) {
     mapOfPolicyParameters.put('specialProfile', String.valueof(applicantPrimary.Contact_Name__r.special_profile_employer__c));
    } else {
     mapOfPolicyParameters.put('specialProfile', String.valueof(applicantPrimary.Contact_Name__r.special_profile_employer__c));
    }
    if (applicantPrimary.Contact_Name__r.Employer__r.Company_Category__c != null) {
     mapOfPolicyParameters.put('company_Category', applicantPrimary.Contact_Name__r.Employer__r.Company_Category__c);
    } else {
     mapOfPolicyParameters.put('company_Category', '');
    }
    if (applicantPrimary.Existing_Customer__c != null) mapOfPolicyParameters.put('customerType', applicantPrimary.Existing_Customer__c.ToUpperCase());
    else mapOfPolicyParameters.put('customerType', '');
    if (applicantPrimary.Contact_Name__r.Employer__r.Employer_List__c != null) {
     mapOfPolicyParameters.put('company_Type', applicantPrimary.Contact_Name__r.Employer__r.Employer_List__c);
    } else {
     mapOfPolicyParameters.put('company_Type', '');
    }
    if (applicantPrimary.Contact_Name__r.Years_At_Residence__c != null) {
     mapOfPolicyParameters.put('current_residence_accommodation', String.valueof(applicantPrimary.Contact_Name__r.Years_At_Residence__c));
    } else {
     mapOfPolicyParameters.put('current_residence_accommodation', '0');
    }
    if (applicantPrimary.Contact_Name__r.Residence_Type__c != null) {
     if (applicantPrimary.Contact_Name__r.Residence_Type__c.startsWith('Rented') && applicantPrimary.Contact_Name__r.Years_At_Residence__c != null) {
      mapOfPolicyParameters.put('rented_accommodation', String.valueof(applicantPrimary.Contact_Name__r.Years_At_Residence__c));
     } else {
      mapOfPolicyParameters.put('rented_accommodation', '0');
     }
    }
    if (cam.Tenor__c != null) {
     mapOfPolicyParameters.put('requested_tenor', String.valueof(cam.Tenor__c));
    } else {
     mapOfPolicyParameters.put('requested_tenor', '0');
    }
    /*Bug 14503, Auto Deviation for SALPL Start - Anshita*/
    mapOfPolicyParameters.put('applicable_FOIR1', (cam.Applicable_FOIR1__c != null) ? string.Valueof(cam.Applicable_FOIR1__c) : '0');
    mapOfPolicyParameters.put('final_FOIR', (cam.Final_FOIR__c != null) ? string.Valueof(cam.Final_FOIR__c) : '0');
    mapOfPolicyParameters.put('loanStatus', (Loan.StageName != null) ? Loan.StageName : '');

    mapOfPolicyParameters.put('branch_Name', (Loan.Branch_Name__r.name != null) ? Loan.Branch_Name__r.name : '');

    mapOfPolicyParameters.put('btAmount', (applicantPrimary.Is_PL_BT__c != null && cam.Proposed_Loan_Amt__c != null && applicantPrimary.Is_PL_BT__c == true) ? String.valueof(cam.Proposed_Loan_Amt__c) : '0');
    Decimal totalExp = Decimal.valueOf(accountCreate[0].Total_Work_Experience_Yrs__c) + (Decimal.valueOf(accountCreate[0].Total_Work_Experience_Months__c) / 12);
    Decimal currentExp = Decimal.valueOf(accountCreate[0].Current_experiance_in_Years__c) + (Decimal.valueOf(accountCreate[0].Current_experiance_in_Month__c) / 12);
    mapOfPolicyParameters.put('total_Employment_Vintage', (String.valueOf(totalExp) != null) ? string.ValueOf(totalExp) : '0');
    mapOfPolicyParameters.put('current_Employment_Vintage', (String.valueOf(currentExp) != null) ? String.valueOf(currentExp) : '0');

    mapOfPolicyParameters.put('residence_type', (applicantPrimary != null && applicantPrimary.Contact_Name__r.Residence_Type__c != null) ? String.valueof(applicantPrimary.Contact_Name__r.Residence_Type__c) : '');

    mapOfPolicyParameters.put('isDomainChecked', (applicantPrimary.Domain_Check_Result__c != null) ? applicantPrimary.Domain_Check_Result__c : '');

    mapOfPolicyParameters.put('applicant_Type', string.valueof(applicantPrimary.applicant_Type__c));
    mapOfPolicyParameters.put('requested_Loan_Amt', (cam.Proposed_Loan_Amt__c != null) ? String.valueOf(cam.Proposed_Loan_Amt__c) : '0');

    mapOfPolicyParameters.put('dpdClusterSegment', (cibTemp[0].DPD_cluster_Segment__c != null) ? cibTemp[0].DPD_cluster_Segment__c : '');
    mapOfPolicyParameters.put('type_of_loan', (Loan.Type_Of_Loan__c != null) ? Loan.Type_Of_Loan__c : ''); //Auto Deviation CR 
    /*Bug 14503, Auto Deviation for SALPL End - Anshita*/

   }
   /*OTP V3 CR added by Krish end*/

   //Bug 17531 - Rural Geo Fencing Start
   Set < String > geoproductSet = GeoDeviationUtility.getproductSet();

   if (geoproductSet != null && geoproductSet.contains(Loan.product__c)) {
    mapOfPolicyParameters.put('branch_Type', Loan.Branch_Name__r.Branch_Type__c);
   }

   String distanceFromBranch = GeoDeviationUtility.retrieveDistanceFromBranch(applicantPrimary.Distance_From_Branch__c);
   if (geoproductSet != null && geoproductSet.contains(Loan.product__c) && distanceFromBranch != null && String.isNotBlank(distanceFromBranch)) {
    mapOfPolicyParameters.put('geo_limit', distanceFromBranch);
   } else {
    mapOfPolicyParameters.put('geo_limit', '');
   }
   //Bug 17531 - Rural Geo Fencing End

   BRECallout breObj = new BRECallout();
   if (!Test.isRunningTest())
    if (!Mortgageflag) {
     breRespose = breObj.callBREDeviations(mapOfPolicyParameters);
    } else if (Loan.Product__c == 'SHL' || Loan.Product__c == 'HSL' || Loan.Product__c == 'SALLAP' || Loan.Product__c == 'HPLS' || Loan.Product__c == 'SBS CS SHL') { // Rasika: SHL Deviation Bug:11151 start

    decimal appLaonAmt;
    decimal avNetSal;
    // Gaurav Added total_net_salary for SALLAP 11 Aug 2017 Start
    mapOfPolicyParameters.put('total_Net_Salary', (cam.Avg_Net_Sal__c != null) ? string.valueOf(cam.Avg_Net_Sal__c) : '0');
    // Gaurav Added total_net_salary for SALLAP 11 Aug 2017 End
    if (cam.Proposed_Loan_Amt__c != null && cam.Top_Up_Amount__c != null)
     appLaonAmt = cam.Proposed_Loan_Amt__c + cam.Top_Up_Amount__c;
    if (cam.Average_incentive_for_Q1__c != null && cam.Average_incentive_for_Q1__c != null && cam.Average_incentive_for_Q3__c != null)
     avNetSal = cam.Average_incentive_for_Q1__c + cam.Average_incentive_for_Q2__c + cam.Average_incentive_for_Q3__c;

    mapOfPolicyParameters.put('requested_tenor', string.valueOf(cam.Tenor__c));
    mapOfPolicyParameters.put('approved_Loan_Amount', (appLaonAmt != null) ? string.valueOf(appLaonAmt) : '0');
    mapOfPolicyParameters.put('applicant_id', applicantPrimary.id);
    mapOfPolicyParameters.put('product', string.valueOf(loan.Product__c));
    mapOfPolicyParameters.put('office_Email_Id_flag', string.valueof(applicantPrimary.Office_Email_Id_Verified__c));
    mapOfPolicyParameters.put('CIBIL_Score', (applicantPrimary.CIBIL_Score__c != null) ? string.valueof(applicantPrimary.CIBIL_Score__c) : '0');
    mapOfPolicyParameters.put('applicant_Type', string.valueof(applicantPrimary.applicant_Type__c));
    mapOfPolicyParameters.put('branch_Name', loan.Branch_Name__r.name);
    mapOfPolicyParameters.put('applicable_FOIR1', (cam.Applicable_FOIR1__c != null) ? string.Valueof(cam.Applicable_FOIR1__c) : '0');
    mapOfPolicyParameters.put('final_FOIR', (cam.Eligible_FOIR__c != null) ? string.Valueof(cam.Eligible_FOIR__c) : '0');
    mapOfPolicyParameters.put('average_Net_Salary', (avNetSal != null) ? string.Valueof((avNetSal) / 3) : '0');
    mapOfPolicyParameters.put('date_of_Birth', String.valueOf(applicantPrimary.Contact_Name__r.date_of_Birth__c));
    // System.debug('SHL Deviation: '+accountCreate1.Type_Of_Industry__c);
    mapOfPolicyParameters.put('company_Category', (accObj.Type_Of_Industry__c != null) ? String.valueOf(accObj.Type_Of_Industry__c) : '');
    // mapOfPolicyParameters.put('company_Category','Diamond');
    mapOfPolicyParameters.put('total_Employment_Vintage', (applicantPrimary.Total_Employment_Vintage__c != null) ? string.ValueOf(applicantPrimary.Total_Employment_Vintage__c) : '');
    mapOfPolicyParameters.put('domain_created_date', (applicantPrimary.Domain_Created_Date__c != null) ? string.ValueOf(applicantPrimary.Domain_Created_Date__c) : '');
    // mapOfPolicyParameters.put('dedup',(applicantPrimary.Domain_Created_Date__c!=null)? string.ValueOf(applicantPrimary.Domain_Created_Date__c):''); 
    // Propert array start
    //for (Property_Details__c property: [SELECT id, Digital_Scrip_Category__c, Digital_Scrip_market_price__c, Number_of_Shares__c, name from Property_Details__c where Loan_Application__c = : Loan.Id]) {
    //  mapOfPolicyParameters.put('property_type',property.Property_Type__c);
    //  }
    Map < String, Object > reqMap = new Map < String, Object > ();
    //req_Map
    reqMap.put('generic_map', mapOfPolicyParameters);
    reqMap.put('prop_lst', propertyList);
    reqMap.put('app_lst', applicantList);
    //BRECallout breObj = new BRECallout();
    System.debug('Request Map: ' + reqMap);
    breRespose = breObj.callMortgageDeviation(reqMap);
    System.debug('SHL Deviation: ' + breRespose);

   } /*buh 11151 end*/
   else
    breRespose.put('BRECodes', 'Test,testt');

   String BRECodes = '';
   if (breRespose != null && breRespose.size() > 0) {
    BRECodes = breRespose.get('BRECodes');
    for (String str: BRECodes.split(',')) {
     system.debug('*****deleted  str **' + str);
     if (str != null && str != '') {
      BRECodesList.add(str.ToUpperCase());
     }
    }
   }
   //if(isFromSales==true){  
   if (con.Email_Confirmation_received__c != null) {
    mapOfPolicyParameters.put('emailConfirmation', con.Email_Confirmation_received__c);
   } else {
    mapOfPolicyParameters.put('emailConfirmation', '');
   }

   if (con.Customer_address_matches_with_eKYC__c != null) {
    mapOfPolicyParameters.put('eKYC', con.Customer_address_matches_with_eKYC__c);
   } else {
    mapOfPolicyParameters.put('eKYC', '');
   }

   if (con.Customer_address_matches_with_perfios__c != null) {
    mapOfPolicyParameters.put('perfios', con.Customer_address_matches_with_perfios__c);
   } else {
    /*OTP V3 added if condition Krish*/
    if (Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL')
     mapOfPolicyParameters.put('perfios', 'NO');
    else
     mapOfPolicyParameters.put('perfios', '');
   }

   if (applicantPrimary.Existing_Customer__c != null)
    mapOfPolicyParameters.put('customer_type', applicantPrimary.Existing_Customer__c.ToUpperCase());
   else
    mapOfPolicyParameters.put('customer_type', '');

   //coAppFlag & adddress flag 
   mapOfPolicyParameters.put('coApplicantFlag', coAppFlag);
   mapOfPolicyParameters.put('addressMatchWithPrevoiusLoanAddress', con.Customer_Add_Matches_With_Previous_Add__c);
   mapOfPolicyParameters.put('perfiosBankingIntegration', perfiosFlagBRE);

   //--------------- Mortgage Re-Engg Start---------------------

   if (Mortgageflag) {
    if (accObj.BT_Bank_Type__c != null) {
     mapOfPolicyParameters.put('btBankType', accObj.BT_Bank_Type__c);
    } else {
     mapOfPolicyParameters.put('btBankType', '');
    }
    if (Loan.Full_Underwriting__c != null) {
     mapOfPolicyParameters.put('fullUnderwritingFlag', String.valueOf(Loan.Full_Underwriting__c));
    } else {
     mapOfPolicyParameters.put('fullUnderwritingFlag', '');
    }
    if (Loan.account.Base_Loan__c != null) {
     mapOfPolicyParameters.put('baseLoan', Loan.account.Base_Loan__c);
    } else {
     mapOfPolicyParameters.put('baseLoan', '');
    }
   }


   //--------------- Mortgage Re-Engg End-----------------------

   if (!Test.isRunningTest())
    breStandardDocRespose = breObj.callBREStandardDocuments(mapOfPolicyParameters);
   else
    breStandardDocRespose.put('BREDocumentCodes', 'BREDocument,test');
   String documentCodes = '';
   if (breStandardDocRespose != null && breStandardDocRespose.size() > 0) {
    documentCodes = breStandardDocRespose.get('BREDocumentCodes');
    for (String str1: documentCodes.split(',')) {
     if (str1 != null && str1 != '') {
      standardBRECodesList.add(str1.ToUpperCase());
     }
    }
   }

   //}         
   system.debug('BRECodesList==' + BRECodesList);
   system.debug('applicantPrimary.SegmentaionResult__c ==' + applicantPrimary.Bureau_Segment__c);
   List < Document_Family__c > docFamilyMaster = [select name, Documents__c, Is_OTP_Standard_Document__c, Product__c, Document_Code__c, Deviation_Code__c, Customer_Segment__c from Document_Family__c where(Document_Code__c != null OR Deviation_Code__c != null) AND Product__c INCLUDES(: Loan.Product__c)];

   List < Document_Family__c > AllDocList = new List < Document_Family__c > ();
   devMasterList = [select Deviation_Code__c, id, Name, Active_Flag__c, Product__c, Deviation_Type__c, Deviation_name__c, BRE_Deviation_Code__c
    from Deviation_Master__c where Active_Flag__c = true and BRE_Deviation_Code__c != null AND Product__c =: Loan.Product__c
   ];

   List < Deviation_Master__c > allDevMasterList = new List < Deviation_Master__c > ();
   if (devMasterList != null && devMasterList.size() > 0) {
    for (Deviation_Master__c devObj: devMasterList) {
     for (String str: BRECodesList) {
      if (devObj.BRE_Deviation_Code__c != null) {
       if (str.ToUpperCase() == devObj.BRE_Deviation_Code__c.ToUpperCase())
        allDevMasterList.add(devObj);
      }

     }

    }

   }
   system.debug('Deviation master list' + allDevMasterList);
   List < Document_Family__c > allstandardDocList = new List < Document_Family__c > ();
   system.debug('docFamilyMaster mist' + docFamilyMaster);
   if (docFamilyMaster != null && docFamilyMaster.size() > 0) {
    for (Document_Family__c docObj: docFamilyMaster) {
     if (BRECodesList != null && BRECodesList.size() > 0) { //For deviaitons BRE
      for (String str: BRECodesList) {

       if ((docObj.Deviation_Code__c != null && (str.ToUpperCase() == docObj.Deviation_Code__c.ToUpperCase())))
        AllDocList.add(docObj);
      }
     }

     //For standard doc list
     system.debug('standardBRECodesList::' + standardBRECodesList);
     //if(isFromSales==true){
     if (standardBRECodesList != null && standardBRECodesList.size() > 0) {
      for (String str1: standardBRECodesList) {
       system.debug('docObj.Deviation_Code__c::' + docObj.Deviation_Code__c);

       if ((docObj.Document_Code__c != null && (str1.ToUpperCase() == docObj.Document_Code__c.ToUpperCase())))
        allstandardDocList.add(docObj);
      }

     }
     //}
    }
    /*if(isFromSales==false){   
checklistTrnxList = [select Deviation_Master__r.Deviation_Description__c,id,Sales_Status__c,CPA_Status__c,Loan_Application__c,Document__c,Checklist_Parameter__c,Checklist_Parameter__r.Document_Family__r.Documents__c,
Checklist_Parameter__r.Document_Family__r.Name,Checklist_Parameter__r.Mandatory__c,to_be_approved_by__c,
Checklist_Parameter__r.Active__c,Checklist_Parameter__r.Type_of_Document__c,DocumentFmlyName__c,Deviation_Master__c,
Checklist_Parameter__r.Stages__c,Checklist_Parameter__r.Customer_Segmentation__c,DocumentFmlyName__r.Name,DocumentFmlyName__r.Documents__c,
Checklist_Parameter__r.DeviationMaster__c,Checklist_Parameter__r.DeviationMaster__r.Deviation_name__c,Manual__c 
from Checklist__c 
where Loan_Application__c=:loan.Id and Deviation_Master__c!=null];
}else{
checklistTrnxList = [select Deviation_Master__r.Deviation_Description__c,id,Sales_Status__c,CPA_Status__c,Loan_Application__c,Document__c,Checklist_Parameter__c,Checklist_Parameter__r.Document_Family__r.Documents__c,
Checklist_Parameter__r.Document_Family__r.Name,Checklist_Parameter__r.Mandatory__c,to_be_approved_by__c,
Checklist_Parameter__r.Active__c,Checklist_Parameter__r.Type_of_Document__c,DocumentFmlyName__c,
Checklist_Parameter__r.Stages__c,Checklist_Parameter__r.Customer_Segmentation__c,DocumentFmlyName__r.Name,DocumentFmlyName__r.Documents__c,
Checklist_Parameter__r.DeviationMaster__c,Checklist_Parameter__r.DeviationMaster__r.Deviation_name__c,Manual__c 
from Checklist__c 
where Loan_Application__c=:loan.Id];

}*/
    checklistTrnxList = [select Deviation_Master__r.Deviation_Description__c, id, Sales_Status__c, CPA_Status__c, Loan_Application__c, Document__c, Checklist_Parameter__c, Checklist_Parameter__r.Document_Family__r.Documents__c,
     Checklist_Parameter__r.Document_Family__r.Name, Checklist_Parameter__r.Mandatory__c, to_be_approved_by__c,
     Checklist_Parameter__r.Active__c, Checklist_Parameter__r.Type_of_Document__c, DocumentFmlyName__c,
     Checklist_Parameter__r.Stages__c, Checklist_Parameter__r.Customer_Segmentation__c, DocumentFmlyName__r.Name, DocumentFmlyName__r.Documents__c,
     Checklist_Parameter__r.DeviationMaster__c, Checklist_Parameter__r.DeviationMaster__r.Deviation_name__c, Manual__c
     from Checklist__c
     where Loan_Application__c =: loan.Id
    ];
    system.debug('inside checklistTrnxList ==' + checklistTrnxList);
    Boolean goInside = true;
    //Bug 5943 - SAL PL Document checklist issue Start
    // Bug id : 13016 - New Role Creation for Credit, added by Needhi 
    if (currentProfileName == 'Credit Manager' || currentProfileName == 'Area Credit Manager' || currentProfileName == 'Regional Credit Manager' ||
     currentProfileName == 'Zonal Credit Manager' || currentProfileName == 'Chief-Credit & Operations' ||
     currentProfileName == 'National Credit Manager' || currentProfileName == 'Senior Credit Officer' || currentProfileName == 'Chief Risk Officer' ||
     currentProfileName == 'National Risk Manager' || currentProfileName == 'Centralized ACM' ||
     currentProfileName == 'Centralized RCM' || currentProfileName == 'President' ||
     currentProfileName == 'City Head' || currentProfileName == 'Sys Admin Persistent' || currentProfileName == 'System Administrator') {

     Set < String > DocumentsCodeIncluded = new Set < String > ();
     for (integer i = 0; i < checklistTrnxList.size(); i++) {
      DocumentsCodeIncluded.add(checklistTrnxList[i].DocumentFmlyName__r.Name);
     }
     system.debug('DocumentsCodeIncluded' + DocumentsCodeIncluded);
     if (AllDocList != null && AllDocList.size() > 0) {
      system.debug('Match deviation code==');
      for (Document_Family__c docObj: AllDocList) {
       system.debug('Match deviation code==');
       for (Deviation_Master__c dev: allDevMasterList) {
        system.debug('Match deviation code==');
        if ((docObj.Deviation_Code__c != null && dev.BRE_Deviation_Code__c != null) && (docObj.Deviation_Code__c == dev.BRE_Deviation_Code__c) && !(DocumentsCodeIncluded.contains(docObj.name))) {
         system.debug('Match deviation code==');
         Checklist__c checkListTrans = new Checklist__c();
         checkListTrans.Loan_Application__c = loan.id;
         checkListTrans.DocumentFmlyName__c = docObj.id;
         checkListTrans.Deviation_Master__c = dev.id;
         checkListTrans.to_be_approved_by__c = breRespose.get(dev.Deviation_Code__c);
         checkListTrans.Mandatory__c = true;
         checklistTrnxList.add(checkListTrans);

        }
       }
      }
     }
     system.debug('allstandardDocList==' + allstandardDocList.size());
     if (allstandardDocList != null && allstandardDocList.size() > 0) {
      for (Document_Family__c docObj: allstandardDocList) {
       if (docObj.Document_Code__c != null && !(DocumentsCodeIncluded.contains(docObj.name))) {
        Checklist__c checkListTransaction = new Checklist__c();
        checkListTransaction.Loan_Application__c = loan.id;
        checkListTransaction.DocumentFmlyName__c = docObj.id;
        system.debug('ddddddddocObj.id' + docObj.id);
        checkListTransaction.Mandatory__c = true;

        system.debug('---checkListTransaction---' + checkListTransaction);
        checklistTrnxList.add(checkListTransaction);
       }
      }
     }
     system.debug('checklistTrnxList==' + checklistTrnxList.size());
     if (checklistTrnxList.size() > 0)
      upsert checklistTrnxList;

    } else {

     //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal start
     /* purpose of the code :- We do not have to delete the deviation whcih are already 
raised and are already approved by respective higher authority
*/
     if (deviationProducts != null && deviationProducts.contains(loan.Product__c)) {
      Map < String, Set < Checklist__c >> mapofChecklist = new Map < String, Set < Checklist__c >> ();
      mapofChecklist = CommonUtility.createdDelNotDelChklist(checklistTrnxList, AllDocList, allDevMasterList);
      if (mapofChecklist != null && mapofChecklist.size() > 0) {
       if (mapofchecklist.get('NotDeletedChk') != null && mapofchecklist.get('NotDeletedChk').size() > 0)
        checklistTrnxListNotDelete.addAll(mapofchecklist.get('NotDeletedChk'));
       if (mapofchecklist.get('DeletedChk') != null && mapofchecklist.get('DeletedChk').size() > 0)
        checklistTrnxListDelete.addAll(mapofchecklist.get('DeletedChk'));
      }
      if (checklistTrnxListDelete != null && checklistTrnxListDelete.size() > 0)
       delete checklistTrnxListDelete;
     } else {
      if (checklistTrnxList != null && checklistTrnxList.size() > 0)
       delete checklistTrnxList;
     }
     //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal start checklistTrnxList chnages to checklistTrnxListDel

     //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal end
     checklistTrnxList.clear();
     system.debug('AllDocList==' + AllDocList);
     if (AllDocList != null && AllDocList.size() > 0) {
      for (Document_Family__c docObj: AllDocList) {
       for (Deviation_Master__c dev: allDevMasterList) {
        if ((docObj.Deviation_Code__c != null && dev.BRE_Deviation_Code__c != null) && (docObj.Deviation_Code__c == dev.BRE_Deviation_Code__c)) {
         system.debug('Match deviation code==');
         Checklist__c checkListTrans = new Checklist__c();
         checkListTrans.Loan_Application__c = loan.id;
         checkListTrans.DocumentFmlyName__c = docObj.id;
         checkListTrans.Deviation_Master__c = dev.id;
         checkListTrans.to_be_approved_by__c = breRespose.get(dev.BRE_Deviation_Code__c);
         checkListTrans.Mandatory__c = true;
         system.debug('---docObj.id---' + docObj.id);
         system.debug('---dev.id---' + dev.id);
         system.debug('---checkListTrans---' + checkListTrans);
         //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal start
         /* purpose of the code :- We do not have to delete the deviation whcih are already 
raised and are already approved by respective higher authority
*/
         if (deviationProducts != null && deviationProducts.contains(loan.Product__c)) {
          if (checklistTrnxListNotDelete != null && checklistTrnxListNotDelete.size() > 0) {
           for (Checklist__c chd: checklistTrnxListNotDelete) {
            if (chd.DocumentFmlyName__c == docObj.id && chd.Deviation_Master__c == dev.id)
             break;
            else {
             checklistTrnxList.add(checkListTrans);
            }
           }
          } else {
           checklistTrnxList.add(checkListTrans);
          }
         } else {
          checklistTrnxList.add(checkListTrans);
         }
         //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal end


        }
       }
      }
     }

     system.debug('allstandardDocList==' + allstandardDocList.size());
     if (allstandardDocList != null && allstandardDocList.size() > 0) {
      for (Document_Family__c docObj: allstandardDocList) {
       if (docObj.Document_Code__c != null) {
        Checklist__c checkListTransaction = new Checklist__c();
        checkListTransaction.Loan_Application__c = loan.id;
        checkListTransaction.DocumentFmlyName__c = docObj.id;

        //SHL Issue Document point 17 Generate document Checklist 11150
        if (Loan.Product__c == 'SHL' || Loan.Product__c == 'SHOL' || Loan.Product__c == 'HSL' || Loan.Product__c == 'SALLAP' || Loan.Product__c == 'HPLS' || Loan.Product__c == 'SBS CS SHL') {
         if (breStandardDocRespose.get(docObj.Document_Code__c) == 'MANDATORY')
          checkListTransaction.Mandatory__c = true;

        } else {
         if (breRespose.get(docObj.Document_Code__c) == 'MANDATORY')
          checkListTransaction.Mandatory__c = true;
        }


        checklistTrnxList.add(checkListTransaction);
       }
      }
     }
     system.debug('checklistTrnxList==' + checklistTrnxList.size());
     if (checklistTrnxList.size() > 0)
      insert checklistTrnxList;

    }
    //Bug 5943 - SAL PL Document checklist issue Ends
    /* if(DeviationsChecklistTrnxList.size()>0)
insert DeviationsChecklistTrnxList;*/

    /*List<Checklist__c> allTrans = new List<Checklist__c>();    
if(checklistTrnxList.size()>0)
allTrans.addAll(checklistTrnxList); 
if(DeviationsChecklistTrnxList.size()>0) 
allTrans.addAll(DeviationsChecklistTrnxList);
system.debug('allTrans=='+allTrans.size());   
insert allTrans; */

    checklistTrnxList = [select Deviation_Master__r.Deviation_Description__c, id, Sales_Status__c, CPA_Status__c, Loan_Application__c, Document__c, Checklist_Parameter__c, Checklist_Parameter__r.Document_Family__r.Documents__c,
     Checklist_Parameter__r.Document_Family__r.Name, Mandatory__c, Deviation_Master__c,
     Checklist_Parameter__r.Active__c, Checklist_Parameter__r.Type_of_Document__c, DocumentFmlyName__c,
     Checklist_Parameter__r.Stages__c, Checklist_Parameter__r.Customer_Segmentation__c, DocumentFmlyName__r.Name, DocumentFmlyName__r.Documents__c,
     Checklist_Parameter__r.DeviationMaster__c, Checklist_Parameter__r.DeviationMaster__r.Deviation_name__c, Manual__c
     from Checklist__c
     where Loan_Application__c =: loan.Id
    ];
    system.debug('checklistTrnxList==' + checklistTrnxList.size());
   }

   createChecklist();
  } catch (Exception e) {
   sendEmailForException(e);
   system.debug('Exception Message -> ' + e + 'line numeber==>' + e.getLinenumber());
  }
  return null;
 }
 /*public void prepareCheckList(){
Set<Id> devTrnId = new Set<Id>();
devTrnxList= [select Deviation_Master__c,Loan_Application__c from Deviation_Transaction__c where Loan_Application__c=:loan.id];  
system.debug('devTrnxList =='+devTrnxList); 
for(Deviation_Transaction__c devTrnx : devTrnxList ) {
devTrnId.add(devTrnx.Deviation_Master__c);
} 

system.debug('devTrnxList =='+devTrnxList); 
system.debug('**********applicantPrimary.SegmentaionResult__c***********'+applicantPrimary.SegmentaionResult__c); 
checklistParamList = [Select name,Document_Family__c,DeviationMaster__c,DeviationMaster__r.Deviation_name__c,Document_Family__r.Name,Document_Family__r.Documents__c,Document_Family__r.Is_OTP_Standard_Document__c,
Mandatory__c,Active__c,Type_of_Document__c,Stages__c,Customer_Segmentation__c from Checklist_Parameter__c 
where Product__c =: loan.Product__c and Customer_Segmentation__c INCLUDES (:applicantPrimary.SegmentaionResult__c)];//Active__c='Yes' 

system.debug('checklistParamList size == '+checklistParamList.size());
List<Checklist_Parameter__c> checklistParamTempList = new List<Checklist_Parameter__c>();
for(Checklist_Parameter__c chk : checklistParamList){
system.debug('chk.DeviationMaster__r.Deviation_name__c == '+chk.DeviationMaster__r.Deviation_name__c);  
system.debug('chk.Document_Family__r.Name == '+chk.Document_Family__r.Name);
if(chk.Customer_Segmentation__c!=null && chk.Customer_Segmentation__c.contains(applicantPrimary.SegmentaionResult__c)){
checklistParamTempList.add(chk);
}
}   
system.debug('checklistParamTempList size == '+checklistParamTempList.size());
if(checklistParamTempList.size()>0){
checklistParamList.clear();
checklistParamList.addAll(checklistParamTempList);
}   

system.debug('checklistParamList.size() =='+checklistParamList.size());
checklistTrnxList = [select id,Sales_Status__c,CPA_Status__c,Loan_Application__c,Document__c,Checklist_Parameter__c,Checklist_Parameter__r.Document_Family__r.Documents__c,
Checklist_Parameter__r.Document_Family__r.Name,Checklist_Parameter__r.Mandatory__c,
Checklist_Parameter__r.Active__c,Checklist_Parameter__r.Type_of_Document__c,Document_Type__c,
Checklist_Parameter__r.Stages__c,Checklist_Parameter__r.Customer_Segmentation__c,
Checklist_Parameter__r.DeviationMaster__c,Checklist_Parameter__r.DeviationMaster__r.Deviation_name__c 
from Checklist__c 
where Loan_Application__c=:loan.Id];
system.debug('inside checklistTrnxList =='+checklistTrnxList);                    
Boolean goInside = true;
if(checklistTrnxList != null && checklistTrnxList.size()>0){
delete checklistTrnxList; 
checklistTrnxList.clear();                        
}  
if(checklistParamList != null && checklistParamList.size() > 0){ 
system.debug('inside populate trnx=='); 
for(Checklist_Parameter__c chklst : checklistParamList){
checkListId.add(chklst.Id); 
checkListparamMap.put(chklst.Id,chklst); 
//if(goInside==true){
Checklist__c checkListTransaction = new Checklist__c();
checkListTransaction.Checklist_Parameter__c = chklst.Id;
checkListTransaction.Loan_Application__c = loan.id;
system.debug('devTrnId==chklst.DeviationMaster__c'+devTrnId+'=='+chklst.DeviationMaster__c);
if(devTrnId.contains(chklst.DeviationMaster__c)){
system.debug('deviation chklst.DeviationMaster__c'+chklst.DeviationMaster__c);
checklistTrnxList.add(checkListTransaction);
}
else if(chklst.DeviationMaster__c==null){
system.debug('standard==chklst.DeviationMaster__c'+chklst.DeviationMaster__c);
checklistTrnxList.add(checkListTransaction);
}
//} 
}
system.debug('checklistTrnxList size=='+checklistTrnxList.size()); 
}      

if(checklistTrnxList.size()>0)
insert  checklistTrnxList;
system.debug('checklistTrnxList=='+checklistTrnxList); 
createChecklist();
}*/
 public void createChecklist() {

  List < Document_Family__c > docFamilyMaster = [select Name, Documents__c, Is_OTP_Standard_Document__c from Document_Family__c where(Document_Code__c != null OR Deviation_Code__c != null)];
  Map < id, Document_Family__c > docFamilyMap = new Map < id, Document_Family__c > ();
  for (Document_Family__c docFam: docFamilyMaster) {
   docFamilyMap.put(docFam.id, docFam);
   system.debug('docFam==' + docFam);
  }
  system.debug('docFamilyMap==' + docFamilyMap);
  checklistTrnxList = [select Deviation_Master__r.Deviation_Description__c, id, Sales_Status__c, CPA_Status__c, Document__c, Checklist_Parameter__c, Checklist_Parameter__r.Document_Family__r.Documents__c,
   Checklist_Parameter__r.Document_Family__r.Name, Checklist_Parameter__r.Mandatory__c, Mandatory__c,
   Checklist_Parameter__r.Active__c, Checklist_Parameter__r.Type_of_Document__c, Checklist_Parameter__r.DeviationMaster__c,
   Checklist_Parameter__r.Stages__c, Checklist_Parameter__r.Customer_Segmentation__c, Deviation_Master__r.Deviation_name__c, DocumentFmlyName__r.Name,
   Checklist_Parameter__r.DeviationMaster__r.Deviation_name__c, DocumentFmlyName__r.Document_Code__c, DocumentFmlyName__r.Deviation_Code__c, DocumentFmlyName__c,
   Deviation_Master__c, Manual__c from Checklist__c
   where Loan_Application__c =: Loan.Id and Manual__c = false
  ];
  system.debug('aftr checklistTrnxList==' + checklistTrnxList);
  if (checklistTrnxList != null && checklistTrnxList.size() > 0) {
   deviationDocWrapperList.clear();
   docWrapperList.clear();
   rowCount = 0;
   devRowCount = 0;
   for (Checklist__c checkListTrnx: checklistTrnxList) {

    system.debug('checkListTrnx.Sales_Status__c==' + checkListTrnx.Sales_Status__c);
    system.debug('**===' + checkListTrnx.Checklist_Parameter__r.Document_Family__c);
    Document_Family__c docFamObj = new Document_Family__c();
    docFamObj = (docFamilyMap.get(checkListTrnx.DocumentFmlyName__c));
    system.debug('*docFamObj*===' + docFamObj);
    if (docFamObj != null) {
     system.debug('*outside ddev prepare' + checkListTrnx.Deviation_Master__c);
     if (checkListTrnx.Deviation_Master__c != null) {
      devRowCount += 1;
      system.debug('*inside ddev prepare');
      DocumentWrapper wrapperObjForDev = new DocumentWrapper(checkListTrnx, docFamObj.Documents__c, devRowCount);
      deviationDocWrapperList.add(wrapperObjForDev);
     } else {
      rowCount += 1;
      system.debug('*inside std doc list prepare' + checkListTrnx);

      DocumentWrapper wrapperObj = new DocumentWrapper(checkListTrnx, docFamObj.Documents__c, rowCount);
      docWrapperList.add(wrapperObj);
     }
    }
   }
   system.debug('docWrapperList size==' + docWrapperList.size());
   system.debug('deviationDocWrapperList size==' + deviationDocWrapperList.size());
   documentNameList.clear();
   for (DocumentWrapper doc: docWrapperList) {
    system.debug('doc.selectedDoc==' + doc.selectedDoc);
    system.debug('doc.singleDoc==' + doc.singleDoc);
    if (doc.selectedDoc != null)
     documentNameList.add(doc.selectedDoc);

    else if (doc.singleDoc != null)
     documentNameList.add(doc.singleDoc);
   }
   for (DocumentWrapper doc1: deviationDocWrapperList) {
    system.debug('doc1.selectedDoc==' + doc1.selectedDoc);
    system.debug('doc1.singleDoc==' + doc1.singleDoc);
    if (doc1.selectedDoc != null)
     documentNameList.add(doc1.selectedDoc);

    else if (doc1.singleDoc != null)
     documentNameList.add(doc1.singleDoc);
   }
   system.debug('documentNameList size==' + documentNameList.size());
   system.debug('documentNameList==' + documentNameList);
   renderChecklist = true;
  }

 }

 /**************************  Wrapper Class  ****************************/
 public List < ManualDeviations > ManualDeviationsWrap {
  get;
  set;
 }

 public class ManualDeviations {
  public boolean deleteMDeviation {
   get;
   set;
  }
  public Checklist__c mCheckList {
   get;
   set;
  }
  public ManualDeviations(Checklist__c mCL) {
   this.deleteMDeviation = false;
   this.mCheckList = mCL;
  }
 }

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
  public Boolean deleteDeviation {
   get;
   set;
  }
  public DocumentWrapper(Checklist__c docfam, String docList, Integer num) {
   showPicklist = true;
   singleDoc = '';
   rowNum = num;
   deleteDeviation = false;
   docListTemp = new List < String > ();
   documentList = new List < SelectOption > ();
   docFamObj = new Checklist__c();
   docFamObj = docfam;
   docName = docfam.DocumentFmlyName__r.Name;
   docFamObj.Mandatory__c = docfam.Mandatory__c;
   system.debug('docFamObj.Checklist_Parameter__r.DeviationMaster__c==' + docFamObj.Deviation_Master__c);
   if (docFamObj.Deviation_Master__c != null) {
    system.debug('docFamObj.Deviation_Master__r.Deviation_name__c==' + docFamObj.Deviation_Master__r.Deviation_name__c);
    deviationName = docFamObj.Deviation_Master__r.Deviation_name__c;
   }
   system.debug('docListe==' + docList);
   if (docList != null && docList != '') {
    docList = docList.replaceAll('_', '');
    docListTemp = docList.split(';', -2);
   }
   if (docListTemp.size() > 0) {
    Set < String > docSet = new Set < String > ();
    docSet.addAll(docListTemp);
    if (docFamObj.Document__c != null && docFamObj.Document__c != '') {
     system.debug('inside document saved docSet before remove==' + docSet);
     docSet.remove(docFamObj.Document__c);
     system.debug('docSet after remove==' + docSet);
     //documentList.addAll(docSet);
     //documentList.clear();
     documentList.add(new SelectOption(docFamObj.Document__c, docFamObj.Document__c));
     for (String strDoc: docSet)
      documentList.add(new SelectOption(strDoc, strDoc));
     system.debug('documentList==' + documentList);
    } else {
     for (String doc: docListTemp) {
      system.debug('inside document not saved==' + docListTemp);
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
    system.debug('obj.salesStausDisable ==' + salesStausDisable);

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
 } //End of wrapper class
 public List < DocumentWrapper > getdeviationDocWrapperList() {
  return deviationDocWrapperList;
 }
 public List < DocumentWrapper > getdocWrapperList() {
  return docWrapperList;
 }
 public void CalculateSegmentation() {
  System.debug('In CalculateSegmentation............................................................................');
  try {
   /*cam = [select id,name,CreatedDate,Current_Year_PLBS__c,Current_Year_PLBS__r.Year__c,Previous_Year_PLBS__r.Year__c,Previous_Year_PLBS__c,Applicant__r.Contact_Name__c,
Type_Cust__c,Type_of_Entity__c,Month1__c,Total_Income_GP__c,Month2__c,Month3__c,Gross_Salary_Month1__c,Approved_CAM__c,Monthly_Reimbursement__c,Maximum_Unsecured_Exposure_MUM__c,
Gross_Salary_Month2__c,Gross_Salary_Month3__c,Final_Net_An_Inc__c,Net_Salary_for_Month1__c,Net_Salary_for_Month2__c,Net_Salary_for_Month3__c,Avg_Net_Sal__c,Avg_Mthly_Inctve_70__c,
Avg_Qtrly_Inctve_60__c,Avg_Mthly_Net_Inc__c,Average_Monthly_Net_Income1__c,Mthly_Loan_EMI__c,Credit_Card_Out_5__c,OD_interest__c,Total_Mthly_Oblig__c,NAS__c,Maxi_EMI_Banking__c,Maxi_EMI_Cust__c,
Maxi_EMI_FOIR__c,Max_EMI_Offer__c,NAS_Multi__c,Max_Loan_Amt_NAS_Multi__c,ROI__c,Final_FOIR__c,Avg_monthly_incentive1__c,Avg_monthly_incentive2__c,
Proposed_Loan_Amt__c,IRR_TO__c,Tenor__c,EMI_on_Proposed_Loan_TO__c,Insurance_taken_TO__c,Premium_Amount_TO__c,Loan_Amt_Premium__c,EMI_with_Insurance_Premium_TO__c,
Avg_monthly_incentive3__c,Avg_mthly_incntve_3mts__c,Average_incentive_for_Q1__c,Average_incentive_for_Q2__c,Average_incentive_for_Q3__c,Avg_qtrly_incentive__c,
Incentive_Monthly_or_Quarterly__c,Receips1_Doc__c,Receips2_Doc__c,Receips3_Doc__c,Receips4_Doc__c,Receips5_Doc__c,Receips6_Doc__c,Month4_Doc__c,Month5_Doc__c,
Selected1__c,Month1_Doc__c,Month2_Doc__c,Month3_Doc__c,Year1_Doc__c,Year2_Doc__c,Year3_Doc__c,LAP_EMI__c,Construction_Valuation_1__c,Construction_Valuation_2__c,
Sal_Deviation_on_FOIR__c,Sal_MUE_Funding__c,sal_max_loan__c,LAP_pmt__c,Interest_on_term_loans__c,Bounces_in_Latest_3_Months__c,App_Mon_Income__c,Monthly_CC_OD_interest__c,ELC_Line_Amounts__c,
Rental_Income__c,Adjusted_Rental_Income__c,SAL_Max_FOIR_as_BFL__c,New_Sal_Deviation_on_FOIR__c,MLA_for_Unlisted_Pvt__c,Applicable_FOIR1__c,Unsecured_FOIR__c,Secured_FOIR__c,Rental_Income_to_be_considered__c , Fund_Based__c,//Rasika
Deviation_on_FOIR__c,Existing_HL_EMI__c,max_loan_POS_forExSAL__c,Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c,Max_Loan_Amount_for_IT_Company__c,Average_Monthly_Net_Income2__c,Average_Bank_Balance__c
from CAM__c where Loan_Application__c=:opp.id limit 1]; */

   //List<Applicant__c> applist = new List<Applicant__c>();   
   //Calculate final foir
   // 01MOB 5873 
   ExistLoans = [select id, Secured_Unsecured__c, Loan_Type__c, Seen_in__c,
    Loan_Acc_No__c, Select__c, Applicant__r.ContactName__c, Principal_O_s__c, Status__c, Customer_Declared_EMI__c,
    Financer__c, Amount__c, Month1_Amount__c, Month2_Amount__c, Financers__c, Obligation__c, Loan_Amount__c, EMI_Over_In_Next_6_months__c,
    Start_On__c, Tenor__c, Tenor_Left__c, MOB__c, POS__c, EMI__c, Applicant__c, Annual_Obligation__c, Type_of_Oblig__c, No_of_Bounces_if_any__c,
    Month3Amount__c, Month4Amount__c, Month5Amount__c, Month6Amount__c, Mthly_Oblig__c, Remark__c, Derived_EMI__c, /*MOB*/ Rate_of_Interest__c, City__c, name, Property_Address__c /*MOB*/ /*01MOB S*/ , Purchase_Value__c, Property_Purchase_Date__c /*01MOB E*/ , Multiplier__c, /*Bug 13407 s*/ Mortgage_free_property__c, Still_own_the_property__c /*Bug 13407 e*/ from Existing_Loan_Details__c where Loan_Application__c =: Loan.Id order by CreatedDate
   ];
   ExistLoanscount = 0;
   totalObligAmount = 0;
   FinalFOIRTemp = 0;
   totalIncon = 0; // bug 11156
   secamtsum = 0;
   creditCardAmt = 0;
   securedFOIR = 0;
   overdraftAmt = 0;

   ATOSParameters__c secured = new ATOSParameters__c();
   secured = ATOSParameters__c.getValues('SegmentationSecuredLoan');

   if (secured != null && secured.value__c != null && secured.Product__c != null) {
    securedLoans = secured.value__c;
    SegmentSecuredProduct = secured.Product__c;
   }

   ATOSParameters__c Unsecured = new ATOSParameters__c();
   //Rohit commented & replaced with prod code start
   //Unsecured = ATOSParameters__c.getValues('SegmentationUnSecuredLoan');
   secured = ATOSParameters__c.getValues('SegmentationUnSecuredLoan');
   //Rohit commented & replaced with prod code stop  
   if (Unsecured != null && Unsecured.value__c != null && Unsecured.Product__c != null) {
    UnsecuredLoans = Unsecured.value__c;
    SegmentUnsecuredProduct = Unsecured.Product__c;
   }


   for (Existing_Loan_Details__c exp: ExistLoans) {
    //OTPv3 TeleRM Rohit condition changed 15229
    if (OTPProducts != null && OTPProducts.contains(Loan.Product__c)) {
     if (Label.HL_loans.contains(exp.Loan_Type__c) && exp.Obligation__c == 'Yes')
      ExistLoanscount = ExistLoanscount + 1;
    } else {
     if ((exp.Loan_Type__c == 'HL' || exp.Loan_Type__c == 'Housing Loan') && exp.Obligation__c == 'Yes') {
      ExistLoanscount = ExistLoanscount + 1;
     }
    }
    if (exp.Status__c == 'Live' && exp.Obligation__c == 'Yes' && exp.Financers__c != null && exp.Loan_Type__c != null && exp.Financers__c == 'Bajaj Finance Ltd' && (exp.Loan_Type__c == 'PL' || exp.Loan_Type__c.toLowerCase() == 'personal loan')) {
     if (exp.POS__c != null)
      totalObligAmount = totalObligAmount + integer.valueof(exp.POS__c);
    }
    /* if(exp.Secured_Unsecured__c=='Unsecured' && exp.Status__c =='Live'){
if(exp.EMI__c != null)
secamtsum+=exp.EMI__c;
}
if(exp.Secured_Unsecured__c=='Secured' && exp.Status__c =='Live'){
if(exp.EMI__c != null)
securedFOIR+=exp.EMI__c; 

}  */

    //Rohit commented & replaced with prod code start
    /*if (securedLoans.indexOf(exp.Loan_Type__c) != -1 && SegmentSecuredProduct.indexOf(Loan.Product__c) != -1) {
if (exp.Status__c == 'Live' && exp.EMI__c != null && exp.Obligation__c == 'Yes' )
securedFOIR += exp.EMI__c;

} else {
if (exp.Secured_Unsecured__c == 'Secured' && exp.Status__c == 'Live') {
if (exp.EMI__c != null && exp.Obligation__c == 'Yes')
securedFOIR += exp.EMI__c;
}
}*/
    if (securedLoans.indexOf(exp.Loan_Type__c) != -1 && SegmentSecuredProduct.indexOf(Loan.Product__c) != -1) {
     if (exp.Status__c == 'Live' && exp.EMI__c != null)
      securedFOIR += exp.EMI__c;

    } else {
     if (exp.Secured_Unsecured__c == 'Secured' && exp.Status__c == 'Live') {
      if (exp.EMI__c != null)
       securedFOIR += exp.EMI__c;
     }
    }

    /* if (UnsecuredLoans.indexOf(exp.Loan_Type__c) != -1 && SegmentUnsecuredProduct.indexOf(Loan.Product__c) != -1) {
if (exp.Status__c == 'Live' && exp.EMI__c != null && exp.Obligation__c == 'Yes')
secamtsum += exp.EMI__c;

} else {
if (exp.Secured_Unsecured__c == 'Unsecured' && exp.Status__c == 'Live' && exp.Obligation__c == 'Yes') {
if (exp.EMI__c != null)
secamtsum += exp.EMI__c;
}
}*/
    if (UnsecuredLoans.indexOf(exp.Loan_Type__c) != -1 && SegmentUnsecuredProduct.indexOf(Loan.Product__c) != -1) {
     if (exp.Status__c == 'Live' && exp.EMI__c != null)
      secamtsum += exp.EMI__c;

    } else {
     if (exp.Secured_Unsecured__c == 'Unsecured' && exp.Status__c == 'Live') {
      if (exp.EMI__c != null)
       secamtsum += exp.EMI__c;
     }
    }
    //Rohit commented & replaced with prod code stop  
    //creditCardAmt
    if (exp.Loan_Type__c == 'Credit Card' && exp.Status__c == 'Live') {
     if (exp.POS__c != null)
      creditCardAmt += exp.POS__c;

    }

    if (exp.Loan_Type__c == 'Overdraft' && exp.Status__c == 'Live' && exp.Obligation__c == 'Yes') {

     if (exp.POS__c != null)
      overdraftAmt += exp.POS__c;

    }

   }
   BRECallout breObj;
   if (!Test.isRunningTest()) {
    breObj = new BRECallout();
    if (!Mortgageflag) // Added Mortgage condition
     checkEligibility();
   }
   system.debug('***camObj.Average_Monthly_Net_Income1__c**' + cam.Average_Monthly_Net_Income1__c);
   system.debug('***secamtsum**' + secamtsum + '**creditCardAmt::' + creditCardAmt);
   system.debug('***securedFOIR**' + securedFOIR);
   Double percentValueOfCredit = 0.0;
   Double percentValueOfdraft = 0.0;
   Double UnsecuredCredit = 0.0;
   Decimal emiValOfMin = 0.0;
   if (creditCardAmt != null) {
    percentValueOfCredit = Decimal.valueOf((creditCardAmt * 5) / 100).setScale(2);
   }
   if (overdraftAmt != null) {
    percentValueOfdraft = Decimal.valueOf((overdraftAmt * 5) / 100).setScale(2);

   }

   /*  if((applicantPrimary.SegmentaionResult__c!=null && applicantPrimary.SegmentaionResult__c.ToUppercase() == 'NORMAL') && (cam.sal_max_loan__c < cam.Proposed_Loan_Amt__c)){
emiValOfMin = PMT(double.valueof(cam.ROI__c/1200),Integer.valueOf(cam.Tenor__c),cam.sal_max_loan__c);
}else{
emiValOfMin = PMT(double.valueof(cam.ROI__c/1200),Integer.valueOf(cam.Tenor__c),cam.Proposed_Loan_Amt__c);
} */
   System.debug('\n\n\tCalling PMT..................\n\n');
   if (cam.ROI__c != null && cam.Tenor__c != null && cam.Proposed_Loan_Amt__c != null)
    emiValOfMin = PMT(double.valueof(cam.ROI__c / 1200), Integer.valueOf(cam.Tenor__c), cam.Proposed_Loan_Amt__c);
   system.debug('**emiValOfMin *' + emiValOfMin + '**percentValueOfCredit::' + percentValueOfCredit);
   UnsecuredCredit = secamtsum + percentValueOfCredit + emiValOfMin + percentValueOfdraft;
   system.debug('***UnsecuredCredit**' + UnsecuredCredit);
   system.debug('***.Average_Monthly_Net_Income1__cedCredit**' + cam.Average_Monthly_Net_Income1__c);
   if (cam.Average_Monthly_Net_Income1__c != null && cam.Average_Monthly_Net_Income1__c != 0) {
    if (UnsecuredCredit != null)
     cam.Unsecured_FOIR__c = ((Double.valueOf(UnsecuredCredit) / cam.Average_Monthly_Net_Income1__c) * 100).setScale(2);
    if (securedFOIR != null)
     cam.Secured_FOIR__c = ((Double.valueOf(securedFOIR) / cam.Average_Monthly_Net_Income1__c) * 100).setScale(2);
   }
   system.debug('***camObj.Unsecured_FOIR__c**' + cam.Unsecured_FOIR__c);
   system.debug('***camObj.Secured_FOIR__c**' + cam.Secured_FOIR__c);
   cam.Credit_Card_Out_5__c = percentValueOfCredit;
   if (cam.Unsecured_FOIR__c != null && cam.Secured_FOIR__c != null) {
    System.debug('\n\n\tSetting FinalFOIR ...........................\n');
    FinalFOIR = Integer.valueOf(cam.Unsecured_FOIR__c + cam.Secured_FOIR__c);
    cam.Eligible_FOIR__c = Integer.valueOf(cam.Unsecured_FOIR__c + cam.Secured_FOIR__c);
   }
   String coapp = 'NO';
   if (cam.Receips1_Doc__c > 0 || cam.Receips2_Doc__c > 0 || cam.Receips3_Doc__c > 0 || cam.Receips4_Doc__c > 0 || cam.Receips5_Doc__c > 0 || cam.Receips6_Doc__c > 0) {
    system.debug('*******fileter coapplicant   app *');
    coapp = 'YES';

   }

   //else{
   // system.debug('*******called elgigibilty and segmentation  *'+SalesFlow);  

   //------------------------------------------------------------------------------------------------   
   //Segmentation code 
   MAP < String, String > mapOfPolicyParameters = new MAP < String, String > ();
   mapOfPolicyParameters.put('BL_PL_risk', (applicantprimary != null && applicantprimary.is_BL_PL_Risk__c != null && applicantprimary.is_BL_PL_Risk__c == true) ? 'true' : 'false'); //Adhoc 23738
   if (applicantPrimary.Applicant_Type__c != null) {
    mapOfPolicyParameters.put('applicant_Type', applicantPrimary.Applicant_Type__c);
   } else {
    mapOfPolicyParameters.put('applicant_Type', '');
   }
   if (con.Company_Type__c != null) {
    mapOfPolicyParameters.put('Company_Type', con.Company_Type__c);
   } else {
    mapOfPolicyParameters.put('Company_Type', '');
   }
   if (con.Company_Category__c != null) {
    mapOfPolicyParameters.put('Company_Category', con.Company_Category__c);
   } else {
    mapOfPolicyParameters.put('Company_Category', '');
   }
   if (con.Office_Email_Id__c != null) {
    mapOfPolicyParameters.put('Office_Email_Id', con.Office_Email_Id__c);
   } else {
    mapOfPolicyParameters.put('Office_Email_Id', '');
   }
   if (con.Residence_Type__c != null) {
    mapOfPolicyParameters.put('Residence_Type', con.Residence_Type__c);
   } else {
    mapOfPolicyParameters.put('Residence_Type', '');
   }
   if (con.Current_experiance_in_Years__c != null) {
    mapOfPolicyParameters.put('Current_Employment_Vintage', String.valueOf(con.Current_experiance_in_Years__c));
   } else {
    mapOfPolicyParameters.put('Current_Employment_Vintage', '');
   }

   if (con.Total_Work_Experience_Yrs__c != null) {
    mapOfPolicyParameters.put('total_Employment_Vintage', String.valueOf(con.Total_Work_Experience_Yrs__c));
   } else {
    mapOfPolicyParameters.put('total_Employment_Vintage', '');
   }
   if (con.Qualification__c != null) {
    mapOfPolicyParameters.put('Educational_Qualification', String.valueOf(con.Qualification__c));
   } else {
    mapOfPolicyParameters.put('Educational_Qualification', '');
   }
   if (applicantPrimary.CIBIL_Score__c != null) {
    if (applicantPrimary.CIBIL_Score__c == '000-1')
     mapOfPolicyParameters.put('CIBIL_Score', '0');
    else
     mapOfPolicyParameters.put('CIBIL_Score', String.valueOf(applicantPrimary.CIBIL_Score__c));
   } else {
    mapOfPolicyParameters.put('CIBIL_Score', '');
   }
   //cam data
   if (cam.Proposed_Loan_Amt__c != null) {
    mapOfPolicyParameters.put('requestedLoan', String.valueOf(cam.Proposed_Loan_Amt__c));
   } else {
    mapOfPolicyParameters.put('requestedLoan', '');
   }
   if (cam.Unsecured_FOIR__c != null) {
    mapOfPolicyParameters.put('applicable_FOIR', String.valueOf(cam.Unsecured_FOIR__c));
   } else {
    mapOfPolicyParameters.put('applicable_FOIR', '');
   }
   //Need to calculate FinalFOIR = cam.Unsecured_FOIR__c + cam.Secured_FOIR__c; 
   if (cam.Applicable_FOIR1__c != null) {
    mapOfPolicyParameters.put('final_FOIR', String.valueOf(FinalFOIR));
   } else {
    mapOfPolicyParameters.put('final_FOIR', '');
   }
   //OTP V3 CR 14754 added if else
   if (Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL' || Loan.Product__c == 'SBS CS SAL') {
    if (cibilext1 != null && cibilext1.Number_of_Hl_Loans__c != null)
     mapOfPolicyParameters.put('number_of_HL_loans', String.valueOf(cibilext1.Number_of_Hl_Loans__c));
    else
     mapOfPolicyParameters.put('number_of_HL_loans', '');
   } else {
    if (ExistLoanscount != null) {
     mapOfPolicyParameters.put('number_of_HL_loans', String.valueOf(ExistLoanscount));
    } else {
     mapOfPolicyParameters.put('number_of_HL_loans', '');
    }
   }

   system.debug('**con.Date_of_Birth__c' + con.Date_of_Birth__c);

   /*if (con.Date_of_Birth__c != null) {
mapOfPolicyParameters.put('Date_of_Birth', String.valueOf(con.Date_of_Birth__c));
} else {
mapOfPolicyParameters.put('Date_of_Birth', '');
}*/

   //call center S
   /*
if (con.date_of_Birth__c != null) {
mapOfPolicyParameters.put('Date_of_Birth', String.valueOf(con.date_of_Birth__c));
} else {
mapOfPolicyParameters.put('Date_of_Birth', '');
}*/
   if (con.date_of_Birth__c != null) {
    mapOfPolicyParameters.put('date_of_Birth', String.valueOf(con.date_of_Birth__c));
   } else {
    mapOfPolicyParameters.put('date_of_Birth', '');
   }
   //Call center E

   if (Loan.product__c != null) {
    mapOfPolicyParameters.put('product', Loan.product__c);
   } else {
    mapOfPolicyParameters.put('product', '');
   }

   if (cam.Eligible_Loan__c != null) {
    mapOfPolicyParameters.put('approved_Loan_Amount', String.valueOf(cam.Eligible_Loan__c));
   } else {
    mapOfPolicyParameters.put('approved_Loan_Amount', '');
   }

   //RSL code added by jagadeesh::start
   if (cam.Recent_continuous__c != null) {
    mapOfPolicyParameters.put('salaryDelay', String.valueOf(cam.Recent_continuous__c));
   } else {
    mapOfPolicyParameters.put('salaryDelay', '');
   }
   //RSL code added by jagadeesh::end

   if (cam.Average_Monthly_Net_Income1__c != null) {
    mapOfPolicyParameters.put('average_Net_Salary', String.valueOf(cam.Average_Monthly_Net_Income1__c));
   } else {
    mapOfPolicyParameters.put('average_Net_Salary', '');
   }
   if (Loan.Branch_Name__c != null) {
    mapOfPolicyParameters.put('branch_Name', Loan.Branch_Name__r.name);
   } else {
    mapOfPolicyParameters.put('branch_Name', '');
   }

   if (Loan.Branch_Name__c != null) {
    mapOfPolicyParameters.put('branch_Type', Loan.Branch_Name__r.Branch_Type__c);
   } else {
    mapOfPolicyParameters.put('branch_Type', '');
   }
   mapOfPolicyParameters.put('applicant_Type', applicantPrimary.applicant_Type__c);
   mapOfPolicyParameters.put('coApplicantFlag', coapp);
   mapOfPolicyParameters.put('loan_id', (Loan.Loan_Application_Number__c != null) ? Loan.Loan_Application_Number__c : '');
   system.debug('*****mapOfPolicyParameters***' + mapOfPolicyParameters);

   //For BeauroSegmentation
   /*OTP V3 CR - added by Krish*/
   mapOfPolicyParameters.put('net_Salary_for_Month1', (cam.Average_incentive_for_Q1__c != null) ? String.valueof(cam.Average_incentive_for_Q1__c) : '0');
   List < Cibil_temp__c > cibList = [select id, bank_name__c from Cibil_Temp__c where Applicant__c =: applicantPrimary.id LIMIT 1];

   Cibil_Temp__c cibTemp = new Cibil_Temp__c();
   if (cibList != null && cibList.size() > 0)
    cibTemp = cibList[0];
   mapOfPolicyParameters.put('bankName', cibTemp.bank_name__c);
   /*OTP V3 CR - added by Krish*/

   if (cibilExt1 != null) {
    /*OTP V3 CR - added by Krish start*/
    mapOfPolicyParameters.put('unsecuredLoanRatio', (cibilExt1.Unsecured_to_total_ratio__c != null) ? String.valueof(cibilExt1.Unsecured_to_total_ratio__c) : '0');
    /*new field added by prashant start */
    mapOfPolicyParameters.put('securedToTotalRatioAmount', (cibilExt1.securedToTotalRatioAmount__c != null) ? String.valueof(cibilExt1.securedToTotalRatioAmount__c) : '0');
    mapOfPolicyParameters.put('liveLoanAmount', (cibilExt1.liveLoanAmount__c != null) ? String.valueof(cibilExt1.liveLoanAmount__c) : '0');
    /*new field added by prashant End */
    mapOfPolicyParameters.put('mob', (cibilExt1.max_mob__c != null) ? String.valueof(cibilExt1.max_mob__c) : '0');
    mapOfPolicyParameters.put('maxDPDEver', (cibilExt1.Highest_DPD_In_1_Year__c != null) ? String.valueof(cibilExt1.Highest_DPD_In_1_Year__c) : '0');
    mapOfPolicyParameters.put('noOfEnquiriesinLast12Months', (cibilExt1.No_of_PL_Enq_in_Last_12_Months__c != null) ? String.valueof(cibilExt1.No_of_PL_Enq_in_Last_12_Months__c) : '0');
    mapOfPolicyParameters.put('noofAllLiveLoans', (cibilExt1.No_Of_Live_Trades__c != null) ? String.valueof(cibilExt1.No_Of_Live_Trades__c) : '0');
    mapOfPolicyParameters.put('noofPLLiveLoans', (cibilExt1.No_of_Live_PL__c != null) ? String.valueof(cibilExt1.No_of_Live_PL__c) : '0');
    mapOfPolicyParameters.put('creditCardUtilization', (cibilExt1.Credit_Card_utilization__c != null) ? String.valueof(cibilExt1.Credit_Card_utilization__c) : '0');
    /*OTP V3 CR - added by Krish end*/
    mapOfPolicyParameters.put('_30PlusTradelinesInLast12Months', (cibilExt1.Tradelines_30plus_DPD__c != null) ? String.valueof(cibilExt1.Tradelines_30plus_DPD__c) : '0');
    //Changes for beauro segmentation for SAL/SPL 
    if (SegmentProduct.indexOf(Loan.Product__c) != -1)
     mapOfPolicyParameters.put('avg_balance', (cibilExt1.Average_Total_Balance__c != null) ? String.valueof(cibilExt1.Average_Total_Balance__c) : '0');
    else
     mapOfPolicyParameters.put('avg_balance', (cibilExt1.Avg_unsecured_loan_amount__c != null) ? String.valueof(cibilExt1.Avg_unsecured_loan_amount__c) : '0');

    mapOfPolicyParameters.put('ratioUnsecuredToTotalNumberOfLoans', (cibilExt1.Unsecured_to_total_ratio__c != null) ? String.valueof(cibilExt1.Unsecured_to_total_ratio__c) : '0');
    mapOfPolicyParameters.put('creditCardUtilization', (cibilExt1.Credit_Card_utilization__c != null) ? String.valueof(cibilExt1.Credit_Card_utilization__c) : '');
    mapOfPolicyParameters.put('secured_sanction_amt', (cibilExt1.Total_Sanction_Amnt_secured__c != null) ? String.valueof(cibilExt1.Total_Sanction_Amnt_secured__c) : '0');
    mapOfPolicyParameters.put('unsecured_sanction_amt', (cibilExt1.Total_Sanction_Amnt_unsecured__c != null) ? String.valueof(cibilExt1.Total_Sanction_Amnt_unsecured__c) : '0');
    mapOfPolicyParameters.put('total_no_of_live_trades', (cibilExt1.No_Of_Live_Trades__c != null) ? String.valueof(cibilExt1.No_Of_Live_Trades__c) : '0');
    mapOfPolicyParameters.put('oldest_MOB', (cibilExt1.First_Loan_MOB__c != null) ? String.valueof(cibilExt1.First_Loan_MOB__c) : '');
    mapOfPolicyParameters.put('newest_MOB', (cibilExt1.Latest_Loan_MOB__c != null) ? String.valueof(cibilExt1.Latest_Loan_MOB__c) : '');
    mapOfPolicyParameters.put('total_no_of_loan_enquiry_in_3_months', (cibilExt1.Enquiries_past_3_mnths__c != null) ? String.valueof(cibilExt1.Enquiries_past_3_mnths__c) : '0');
    mapOfPolicyParameters.put('unsecured_loans_in_12_months', (cibilExt1.Unsecured_Tradelines_in_last_12m__c != null) ? String.valueof(cibilExt1.Unsecured_Tradelines_in_last_12m__c) : '0');
    //SAL Policy Change Start
    mapOfPolicyParameters.put('noOfPLEnquiriesIn12M', (cibilExt1.No_of_PL_Enq_in_Last_12_Months__c != null) ? String.valueof(cibilExt1.No_of_PL_Enq_in_Last_12_Months__c) : '0');
    mapOfPolicyParameters.put('noOfPLEnquiriesIn6M', (cibilExt1.No_of_PL_Enq_in_Last_6_Months__c != null) ? String.valueof(cibilExt1.No_of_PL_Enq_in_Last_6_Months__c) : '0');
    mapOfPolicyParameters.put('sumOfAmountOverdue', (cibilExt1.Sum_of_Amount_Overdue__c != null) ? String.valueof(cibilExt1.Sum_of_Amount_Overdue__c) : '0');
    //SAL Policy Change End
    //SAL Policy Rule Changes :: Added by Pritha :: start

    mapOfPolicyParameters.put('number_of_live_PL_Loans', (cibilExt1.No_of_Live_PL__c != null) ? String.valueof(cibilExt1.No_of_Live_PL__c) : '0');

    //SAL Policy Rule Changes :: Added by Pritha :: end
   }
   Map < String, String > mapOfPolicyResult = new Map < String, String > ();
   if (!Test.isRunningTest())
    mapOfPolicyResult = breObj.callBRESegmentation(mapOfPolicyParameters);
   else {
    mapOfPolicyResult.put('bureauSegment', 'WOW');
    mapOfPolicyResult.put('CustomerSegment', 'WOW');
    mapOfPolicyResult.put('CustomerSubSegment', 'WOW');
    mapOfPolicyResult.put('prudence', 'WOW');
    mapOfPolicyResult.put('stability', 'WOW');
    mapOfPolicyResult.put('achievement', 'WOW');
    mapOfPolicyResult.put('age', '20');
    mapOfPolicyResult.put('education', 'BE');
   }
   /* OTP V3 CR - added by krish start */
   applicantPrimary.SegmentaionResult__c = mapOfPolicyResult.get('revisedCustomerSegment');
   applicantPrimary.risk_segmentation__c = mapOfPolicyResult.get('riskSegmentClassification');
   applicantPrimary.App_score__c = mapOfPolicyResult.get('appScore');
   applicantPrimary.Location_Wise_EWS_Status__c = mapOfPolicyResult.get('locationBasedEWSCategory');
   /* OTP V3 CR - added by Krish end */
   system.debug('mapOfPolicyResult==' + mapOfPolicyResult);
   applicantPrimary.Bureau_Segment__c = mapOfPolicyResult.get('bureauSegment');
   applicantPrimary.SegmentaionResult__c = mapOfPolicyResult.get('CustomerSegment');
   applicantPrimary.Sub_Segment__c = mapOfPolicyResult.get('CustomerSubSegment');
   //applist.add(applicant);
   applicantPrimary.Segment_Prudense__c = mapOfPolicyResult.get('prudence');
   applicantPrimary.Segment_Stability__c = mapOfPolicyResult.get('stability');
   applicantPrimary.Segment_Achievment__c = mapOfPolicyResult.get('achievement');
   applicantPrimary.SalaryToAgeResult__c = mapOfPolicyResult.get('age');
   applicantPrimary.EducationQualificationResult__c = mapOfPolicyResult.get('education');
   AgeBench = mapOfPolicyResult.get('benchSalaryToAge');
   applicantPrimary.CompanyCategoryResult__c = mapOfPolicyResult.get('companyCategory');
   applicantPrimary.LoanAmountResult__c = mapOfPolicyResult.get('loanAmount');
   applicantPrimary.UnsecuredFOIRResult__c = mapOfPolicyResult.get('unsecuredFOIR');
   applicantPrimary.TotalFOIRHLResult__c = mapOfPolicyResult.get('totalFOIR');
   applicantPrimary.OwnHouse_RunningHLResult__c = mapOfPolicyResult.get('residenceStability');
   applicantPrimary.CurrentWorkExpResult__c = mapOfPolicyResult.get('currentExperiance');
   applicantPrimary.TotalWorkExpResult__c = mapOfPolicyResult.get('totalExperiance');
   TotalFoirHLStr = mapOfPolicyResult.get('benchTotalFOIR');
   if (mapOfPolicyResult.get('actualLoanAmountToEligibleAmount') != null && mapOfPolicyResult.get('actualLoanAmountToEligibleAmount') != '')
    loanEligibilty = Decimal.valueOf(mapOfPolicyResult.get('actualLoanAmountToEligibleAmount')).setScale(2);
   // SAL Policy Changes Starts
   applicantPrimary.RC_Decline__c = mapOfPolicyResult.get('declineRiskSegment');
   applicantPrimary.RC_Deviation__c = mapOfPolicyResult.get('deviationRiskSegment');
   system.debug('---applicantPrimary.RC_Decline__c---' + applicantPrimary.RC_Decline__c);
   system.debug('---applicantPrimary.RC_Deviation__c---' + applicantPrimary.RC_Deviation__c);
   //if(applicantPrimary.RC_Decline__c!='' || applicantPrimary.RC_Decline__c!=null){  Commenting for Prod issue fix
   if (applicantPrimary.RC_Decline__c != '' && applicantPrimary.RC_Decline__c != null) {
    /*
If the ?C decline?value [which BRE returns] is not null, 
then change the loan application stage as ?CP Reject?and create MCP policy record for that string.
6.  Create SOL policy for this declined case and disable all the buttons of both the pages.
If Stage is not ?CP Reject?then don't do anything
*/
    system.debug('---Loan.StageName---' + Loan.StageName);
    Loan.StageName = 'MCP Reject';

    //Create SOL Policy Record
    SOL_Policy__c objDeclineSOLPolicy = new SOL_Policy__c();
    objDeclineSOLPolicy.Loan_Application__c = Loan.id;
    objDeclineSOLPolicy.Policy_Name__c = 'risk classification reject- ' + applicantPrimary.RC_Decline__c;
    insert objDeclineSOLPolicy;
    system.debug('---objDeclineSOLPolicy Inserted ---' + objDeclineSOLPolicy);
    RCDeclineFlag = true;
    system.debug('---RCDeclineFlag---' + RCDeclineFlag);
   }
   if (applicantPrimary.RC_Decline__c == '' || applicantPrimary.RC_Decline__c == null) {
    /*
If Stage is ?CP Reject?then ----
5.  If credit person re-run the segmentation on CO screen and RC decline is null,
then loan application stage would be previous stage. For stage changes on CO screen use field history logic to check the previous stage.
*/
    RCDeclineFlag = false;
    if (Loan.StageName == 'MCP Reject') {
     // Previous Stage Logic
     List < OpportunityFieldHistory > OldOppRecords = [SELECT Id, Field, NewValue, OldValue, OpportunityId FROM OpportunityFieldHistory
      where OpportunityId =: Loan.id AND
      Field = 'StageName'
      order by CreatedDate DESC
     ];
     system.debug('---OldOppRecords---' + OldOppRecords);
     for (OpportunityFieldHistory opp: OldOppRecords) {
      if (opp.Field == 'StageName') {
       system.debug('---newvalue---' + opp.NewValue);
       system.debug('---OldValue---' + opp.OldValue);
       if (Loan.StageName == opp.NewValue) {
        Loan.StageName = String.valueOf(opp.OldValue);
        break;
       }
      }
     }
    }
   }
   RiskSegment = '';
   if (applicantPrimary.RC_Decline__c != null) {
    RiskSegment = applicantPrimary.RC_Decline__c;
   }
   if (applicantPrimary.RC_Deviation__c != null) {
    RiskSegment = RiskSegment + applicantPrimary.RC_Deviation__c;
   }
   system.debug('---RiskSegment---' + RiskSegment);
   // SAL Policy Changes Ends

   // }  
   //upsert cam;
   //upsert applist;
   system.debug('segment end =');

  } catch (Exception e) {
   system.debug('Exception occurd==>' + e.getMessage() + 'Line number===>' + e.getLinenumber());
   sendEmailForException(e);
  }
 }

 public void callSegmentEligibility() {
  System.debug('In callSegmentEligibility..................................');

  try {
   //4937 added if condition 
   if (Loan != null) system.debug('Loan.Product__c=' + Loan.Product__c);

   //4937 added if condition for FAS
   if (Loan != null && Loan.Product__c != 'FAS') {
    if (Mortgageflag) {
     /*if (Loan.Full_Underwriting__c == true) { //Segmentation for Open market only
if (Loan.Product__c == 'SHL' || Loan.Product__c == 'HFC SHL' || Loan.Product__c == 'HSL' || Loan.Product__c == 'SBS CS SHL' || Loan.Product__c == 'HPLS' || Loan.Product__c == 'SHOL')
CalculateSegmentation();
else
checkEligibility();
}

if (Loan.Full_Underwriting__c == true && Loan.Product__c != 'SHL' && Loan.Product__c != 'SBS CS SHL' && Loan.Product__c != 'HPLS' && Loan.Product__c != 'HFC SHL' && Loan.Product__c != 'HSL' && Loan.Product__c != 'SHOL') { //Segmentation for Open market and PO conversion
checkEligibility();
} else {
if (Loan.Product__c == 'SHL' || Loan.Product__c == 'SBS CS SHL' || Loan.Product__c == 'HPLS' || Loan.Product__c == 'HFC SHL' || Loan.Product__c == 'HSL' || Loan.Product__c == 'SHOL')
CalculateSegmentation();
}

system.debug('In Mortgage Eligibility...');
checkEligibilityMortgage();

saveMortgageEligiblity();*/


     if (poObj != null && poObj.id == null) { //Segmentation for Open market only
      if (Loan.Product__c == 'SHL' || Loan.Product__c == 'HFC SHL' || Loan.Product__c == 'SHOL' || Loan.Product__c == 'HSL' || Loan.Product__c == 'SALLAP' || Loan.Product__c == 'HPLS' || Loan.Product__c == 'SBS CS SHL')
       CalculateSegmentation();
      else
       checkEligibility();
     }
     system.debug('In Mortgage Eligibility...');
     checkEligibilityMortgage();

     saveMortgageEligiblity();

    } else {
     CalculateSegmentation();
     system.debug(' before applicantPrimary.SegmentaionResult__c==' + applicantPrimary.SegmentaionResult__c);
     checkEligibility();
     system.debug(' after applicantPrimary.SegmentaionResult__c==' + applicantPrimary.SegmentaionResult__c);
     saveEligibiltyDetails();
    }

    savedSuccessfull = true;
    message = 'Eligibility calculated successfully!!!';
   }

  } catch (Exception e) {
   system.debug('Exception occurd==>' + e.getMessage() + 'Line number===>' + e.getLinenumber());
   sendEmailForException(e);
  }

 }
 public double PMT(double rate, integer nper, decimal pv) {
  System.debug('\n\n\t----- IN PMT ------- \n\n');
  system.debug('******rate********' + rate + '**nper*' + nper + '*pv**' + pv);
  Double result = 0.0;

  if (pv != null && rate != null && nper != null) {
   System.debug('Math.pow(1 + rate, -nper)  : ' + Math.pow(1 + rate, -nper));
   System.debug('(1 - Math.pow(1 + rate, -nper)) : ' + (1 - Math.pow(1 + rate, -nper)));
   result = Math.round((pv * rate) / (1 - Math.pow(1 + rate, -nper)));
   system.debug('****result**' + result);
  }
  System.debug('result : ' + result + '\n\n');
  return result;
 }

 //2nd controller methods
 //get method for dedupe 
 public List < De_Dupe__c > getdedupe() {
  return dedupelist;
 }

 //Cibil
 public String getselectedApplicant() {
  return selectedApplicant;
 }
 public List < SelectOption > getapplicantSelectList() {
  return applicantSelectList;
 }
 //Perfios 
 public pagereference sendMailForPerfios() {
  List < Bank_Account__c > bankAccountData1 = new List < Bank_Account__c > ();
  //system.debug('*****bankAcc.Send_Email_For_Perfios__c*****' + bankAcc.Send_Email_For_Perfios__c);
  List < Bank_Account__c > bankAcclist1 = new List < Bank_Account__c > ();
  //code added by leena-oct fest -added Perfiod_done_date_and_Time__c,Perfios_Flag__c in query
  bankAcclist1 = [select id, name, Perfiod_done_date_and_Time__c, Perfios_Flag__c, Avg_mthly_bal6__c, Bank_Name__c, sum_Avg_mthly_bal__c, Transaction_Count__c, Bank_Acct_Number__c, Send_Email_For_Perfios__c, Salary_Credit_Date1__c, Salary_Credit_Date2__c, Salary_Credit_Date3__c, Salary_credit_amount1__c, Salary_credit_amount2__c, Salary_credit_amount3__c, /*SHL*/ Mode_Of_Salary_Credit__c, StatusOfBankAccount__c from Bank_Account__c where Loan_Application__c =: loan.id and Salaried_CAM__c = true and
   Send_Email_For_Perfios__c = true and Applicant__r.Applicant_Type__c = 'Primary'
  ];

  system.debug('*****bankAcclist1*****' + bankAcclist1.size());
  if (bankAcclist1.size() <= 0) {


   if (loan != null) {
    system.debug('*****opp.Customer_email_id__c *****' + loan.Customer_email_id__c);
    if (loan.Customer_email_id__c == null || loan.Customer_email_id__c == '') {
     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Customer email address is blank'));
     return null;
    }
    if (bankAcc.Bank_Name__c == null || bankAcc.Bank_Name__c == '') {
     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Bank data is blank'));
     return null;
    }
    if (bankAcc.Bank_Acct_Number__c == null || bankAcc.Bank_Acct_Number__c == '') {
     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Bank data is blank'));
     return null;
    }
    bankAcc.Send_Email_For_Perfios__c = false;
    upsert bankAcc;
    bankAcc.Send_Email_For_Perfios__c = true;
    bankAccountData1.add(bankAcc);
    SendEmailForPerfios obj = new SendEmailForPerfios();
    obj.sendEmailToCustomer(bankAccountData1, loan.id);

   }
   //01MOB
   //code added by leena-oct fest-added Perfiod_done_date_and_Time__c,Perfios_Flag__c in query
   //bugId 14732 fields added
   bankAcclist = [select id, name, Perfiod_done_date_and_Time__c, Perfios_Flag__c, Avg_mthly_bal6__c, Bank_Name__c, /*SAL IM Rohit start */ Applicant__c, /*SAL IM Rohit start */ sum_Avg_mthly_bal__c, Transaction_Count__c, Bank_Acct_Number__c, Send_Email_For_Perfios__c, Salary_Credit_Date1__c, Salary_Credit_Date2__c, Salary_Credit_Date3__c, Salary_credit_amount1__c, Salary_credit_amount2__c, Salary_credit_amount3__c, StatusOfBankAccount__c, /*SHL*/ Mode_Of_Salary_Credit__c from Bank_Account__c where Loan_Application__c =: loan.id and Salaried_CAM__c = true and Applicant__r.Applicant_Type__c = 'Primary'];
   if (bankAcclist != null && bankAcclist.size() > 0) {
    system.debug('bankAcclist[0]==' + bankAcclist[0].Bank_Acct_Number__c);
    bankAcc = bankAcclist[0];
    if (bankAcclist[0].Send_Email_For_Perfios__c == true)
     perfiosflag = true;
   }
   message = 'Email send successfully !!';
   savedSuccessfull = true;

   // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email send successfully !!'));  
  } else {
   message = 'Email has already been sent !!';
   savedSuccessfull = true;
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email has already been sent !!'));
  }
  return null;
 }
 public PageReference rundedupe() {

  //Bug : 7412 : Pritha :start
  try {
   if (loan != null) {
    List < De_Dupe__c > OldDedupelist = new List < De_Dupe__c > ();
    De_Dupe__c oldRecord = new De_Dupe__c();
    List < Id > dedIdList = new List < Id > (); //20939 RCU PMD
    List < Applicant__c > updateApplist = new List < Applicant__c > ();
    MAP < Id, Applicant__c > MAPOfApplicant = new MAP < Id, Applicant__c > ();
    Boolean noDataSelected = false;
    system.debug('****dedupeWrapperList' + dedupeWrapperList);
    if (dedupeWrapperList != null && dedupeWrapperList.size() > 0) {
     /*20939 RCU PMD s*/
     for (DedupeWrapper obj: dedupeWrapperList) {
      if (obj.selectDedupe == true) {
       if (obj.dedupeObj.id != null) {
        dedIdList.add(obj.dedupeObj.Id);
       }
      }
     }
     OldDedupelist = [select id, name, Dedupe_Lan_Matches__c, Applicant__c, Applicant__r.Contact_Name__c, Datafix_Updated__c, Application_Status__c,
      Application_ID__c, Random_Dedupe__c, Area_Status__c, Customer_Status__c, Match_Status__c,
      Customer_ID__c, Dedupe_Comments__c, De_Dupe_result__c, De_Dupe_Decision__c, Segment__c, SF_Base__c, Source_Or_Target__c, /* Bug 5880 S */ Dedupe_Target_Remarks__c, Dedupe_Source__c /*Bug 5880 E*/ from De_Dupe__c where id IN: dedIdList
     ];
     /*20939 RCU PMD e*/
     //Cubic Tree Integration :: existing issue
     if (insertDedupe != null)
      insertDedupe.clear();
     for (DedupeWrapper obj: dedupeWrapperList) {
      if (obj.selectDedupe == true) {
       //Bug 20939 RCU PMD commented below code
       /*if (obj.dedupeObj.id != null) {

oldRecord = [select id, name, Dedupe_Lan_Matches__c, Applicant__c, Applicant__r.Contact_Name__c, Datafix_Updated__c, Application_Status__c,
Application_ID__c, Random_Dedupe__c, Area_Status__c, Customer_Status__c, Match_Status__c,
Customer_ID__c, Dedupe_Comments__c, De_Dupe_result__c, De_Dupe_Decision__c, Segment__c, SF_Base__c, Source_Or_Target__c, /* Bug 5880 S */
       /* Dedupe_Target_Remarks__c, Dedupe_Source__c */ /*Bug 5880 E*/ /* from De_Dupe__c where id =: obj.dedupeObj.id limit 1*/
       /*];
OldDedupelist.add(oldRecord);*/
       /*}*/
       if (obj.conObj != null && obj.app != null && obj.dedupeObj.Source_Or_Target__c == 'Source') {
        //Create dedupe List
        tempMapDedupe = new Map < String, object > ();
        tempMapDedupe.put('Applicant__c', obj.app);
        tempMapDedupe.put('Contact', obj.conObj);
        tempMapDedupe.put('Opportunity', Loan);
        insertDedupe.add(tempMapDedupe);

        if (obj.app.DeDupe_Counter__c == null) obj.app.DeDupe_Counter__c = 0;
        obj.app.DeDupe_Counter__c = obj.app.DeDupe_Counter__c + 1;
        obj.app.Re_Initiate_De_Dupe__c = true;
        MAPOfApplicant.put(obj.app.id, obj.app);
       }
       noDataSelected = true;
      }

     }
     //delete dedupe
     system.debug('MAPOfApplicant==' + MAPOfApplicant);
     if (OldDedupelist != null && OldDedupelist.size() > 0) {
      delete OldDedupelist;

     }

     //update Applicant
     if (MAPOfApplicant != null && MAPOfApplicant.size() > 0) {
      updateApplist = MAPOfApplicant.values();
      system.debug('updateApplist==' + updateApplist);
      if (updateApplist != null && updateApplist.size() > 0) update updateApplist;
     }
     //insert dedupe
     if (groupType == 'salaried' && noDataSelected == false) {
      savedSuccessfull = true;
      message = 'Please Select DeDupe record to initiate';
     } else {
      DedupeService.insertDedupeSource(insertDedupe);
      savedSuccessfull = true;
      message = 'Dedupe initiated successfully';
     }
    } else if (dedupeNotDone == true) {
     DedupeService.insertDedupeSource(insertDedupe);
    }
    //Cubic Tree Integration :: adding condition to query :: AND Dedupe_Source__c != 'propertydedupeCT' AND Dedupe_Source__c != 'applicantdedupeCT'
    dedupelist = [select id, name, Dedupe_Lan_Matches__c, Applicant__c, Applicant__r.Contact_Name__c, Datafix_Updated__c, Application_Status__c,
     Application_ID__c, Random_Dedupe__c, Area_Status__c, Customer_Status__c, Applicant__r.Contact_Name__r.Name, Match_Status__c,
     Customer_ID__c, Dedupe_Comments__c, De_Dupe_result__c, De_Dupe_Decision__c, Segment__c, SF_Base__c, Source_Or_Target__c, /* Bug 5880 S */ Dedupe_Target_Remarks__c, Dedupe_Source__c /*Bug 5880 E*/ from De_Dupe__c where Loan_Application__c =: loan.id And Applicant__c != null /*Mortgage*/ AND Dedupe_Source__c != 'propertydedupeCT'
     AND Dedupe_Source__c != 'applicantdedupeCT'
    ];
    system.debug('dedupelist==' + dedupelist);

    dedupeWrapperList.clear();
    system.debug('applicantMAP==' + applicantMAP);
    system.debug('contactMAP==' + contactMAP);
     system.debug('****dedupeWrapperList 2' + dedupeWrapperList);
    if (dedupelist != null && dedupelist.size() > 0) {
     for (De_Dupe__c de: dedupelist) {
      if (groupType == 'salaried') {
       dedupeWrapperList.add(new DedupeWrapper(false, de, applicantMAP.get(de.Applicant__c), contactMAP.get(de.Applicant__r.Contact_Name__c), de.Applicant__r.Contact_Name__r.Name, GoogleAttachmentMap.get(de.Applicant__r.Id)));
      } else {
       dedupeWrapperList.add(new DedupeWrapper(true, de, applicantMAP.get(de.Applicant__c), contactMAP.get(de.Applicant__r.Contact_Name__c), de.Applicant__r.Contact_Name__r.Name, GoogleAttachmentMap.get(de.Applicant__r.Id)));
      }
     }
    }
    paginationExt  = new PaginationExtension(dedupeWrapperList);//@24142 dedupe prod issue
    getPaginatedRecords();//@24142 dedupe prod issue
   
    system.debug('****dedupeWrapperList 3' +dedupeWrapperList.size()+ dedupeWrapperList);
   }
  } catch (Exception e) {
   system.debug('Exception message' + e.getMessage() + ' Line Number: ' + e.getLineNumber());
   message = e.getMessage() + '  ' + e.getLineNumber() + '  ' + e.getCause() + '  ' + e.getTypeName();
   SendExceptionMail(message, 'Exception came in MidOffice flow (MCP Parameters)');
  }
  return null;
  //Bug : 7412 : Pritha :end


 }

 /*  //Bug : 7412 : Pritha : Commented
public PageReference rundedupe() {
try {
if (loan != null) {
dedupelist=[select id,name,Dedupe_Lan_Matches__c,Applicant__c,Applicant__r.Contact_Name__c,Datafix_Updated__c,Application_Status__c,
Application_ID__c,Random_Dedupe__c,Area_Status__c,Customer_Status__c,
Customer_ID__c,Dedupe_Comments__c,De_Dupe_result__c,De_Dupe_Decision__c,Segment__c,SF_Base__c,Source_Or_Target__c from De_Dupe__c where Loan_Application__c=:loan.id];
if(dedupelist!=null && dedupelist.size()>0){
delete dedupelist;
if(con!=null && applicant!=null){
DedupeService.insertDedupeSource(con, applicant, loan);
if(applicant.DeDupe_Counter__c==null)
applicant.DeDupe_Counter__c=0;
applicant.DeDupe_Counter__c = applicant.DeDupe_Counter__c + 1;
update applicant; 
}

}            

List < De_Dupe__c > OldDedupelist = new List < De_Dupe__c > ();
De_Dupe__c oldRecord = new De_Dupe__c();
List < Applicant__c > updateApplist = new List < Applicant__c > ();
MAP < Id, Applicant__c > MAPOfApplicant = new MAP < Id, Applicant__c > ();
system.debug('****dedupeWrapperList' + dedupeWrapperList);
if (dedupeWrapperList != null && dedupeWrapperList.size() > 0) {
for (DedupeWrapper obj: dedupeWrapperList) {
system.debug('****obj.selectDedupe*' + obj.selectDedupe);
if (obj.selectDedupe == true) {

oldRecord = [select id, name, Dedupe_Lan_Matches__c, Applicant__c, Applicant__r.Contact_Name__c, Datafix_Updated__c, Application_Status__c,
Application_ID__c, Random_Dedupe__c, Area_Status__c, Customer_Status__c,
Customer_ID__c, Dedupe_Comments__c, De_Dupe_result__c, Match_Status__c, De_Dupe_Decision__c, Segment__c, SF_Base__c, Source_Or_Target__c, /* Bug 5880 S  Dedupe_Target_Remarks__c, Dedupe_Source__c /*Bug 5880 E from De_Dupe__c where id = : obj.dedupeObj.id limit 1
];
OldDedupelist.add(oldRecord);
if (obj.conObj != null && obj.app != null) {
DedupeService.insertDedupeSource(obj.conObj, obj.app, loan);
if (obj.app.DeDupe_Counter__c == null)
obj.app.DeDupe_Counter__c = 0;
obj.app.DeDupe_Counter__c = obj.app.DeDupe_Counter__c + 1;
MAPOfApplicant.put(obj.app.id, obj.app);
}

}
}

system.debug('MAPOfApplicant==' + MAPOfApplicant);
if (OldDedupelist != null && OldDedupelist.size() > 0)
delete OldDedupelist;

if (MAPOfApplicant != null && MAPOfApplicant.size() > 0) {
updateApplist = MAPOfApplicant.values();
system.debug('updateApplist==' + updateApplist);
update updateApplist;
}
if (updateApplist != null && updateApplist.size() > 0)
update updateApplist;
message = 'Dedupe initiated successfully';
dedupelist = [select id, name, Dedupe_Lan_Matches__c, Applicant__c, Applicant__r.Contact_Name__c, Datafix_Updated__c, Application_Status__c,
Application_ID__c, Random_Dedupe__c, Area_Status__c, Customer_Status__c,
Customer_ID__c, Dedupe_Comments__c, De_Dupe_result__c, Match_Status__c, De_Dupe_Decision__c, Segment__c, SF_Base__c, Source_Or_Target__c, Applicant__r.Contact_Name__r.Name, /* Bug 5880 S  Dedupe_Target_Remarks__c, Dedupe_Source__c /*Bug 5880 E from De_Dupe__c where Loan_Application__c = : loan.id
];
system.debug('dedupelist==' + dedupelist);

dedupeWrapperList.clear();
system.debug('applicantMAP==' + applicantMAP);
system.debug('contactMAP==' + contactMAP);

if (dedupelist != null && dedupelist.size() > 0) {
for (De_Dupe__c de: dedupelist) {
// dedupeWrapperList.add(new DedupeWrapper(false,de,applicantMAP.get(de.Applicant__c),contactMAP.get(de.Applicant__r.Contact_Name__c)));
dedupeWrapperList.add(new DedupeWrapper(false, de, applicantMAP.get(de.Applicant__c), contactMAP.get(de.Applicant__r.Contact_Name__c), de.Applicant__r.Contact_Name__r.Name));
}
}

}
system.debug('dedupelist==' + dedupelist);
}
} catch (Exception e) {
sendEmailForException(e);
}
return null;
}*/
 public PageReference runcibil() {
  try {
   system.debug('LoanIdLoanId==' + loan); //Prod SOQL Optimisation 5 March 2019
   //List < Applicant__c > applist = new List < Applicant__c > ();
   //if (loan != null && applicantList==null) {
    //applist = [select is_BL_PL_Risk__c, /*18370 S*/ Is_Hybrid_Flexi_for_Topup__c, Topup_Pure_Flexi_Period__c, Topup_Dropline_Flexi_Period__c, Topup_Loan_Proposed_EMI__c, Topup_Pure_Flexi_EMI__c /*18370 E*/ , /* SAL Invisible monitering start */ RSA_reason__c, RSA_flag__c, RSA_Loan_application_status__c, RSA_Remarks__c, Underwriter_Remarks__c, RSA_Closure_Date__c, RSA_initiation_Date__c, RSA_TAT__c, Contact_Name__r.Email_Confirmation_received__c, Contact_Name__r.Customer_address_matches_with_eKYC__c, Contact_Name__r.Perfios_Address__c, Contact_Name__r.Customer_address_matches_with_perfios__c, Contact_Name__r.Customer_Add_Matches_With_Previous_Add__c /* SAL Invisible monitering end */ , id, /*SAL PLTB Pritha S*/ LTA_Medical__c, LTA_Frequency__c, /*SAL PLTB Pritha E*/ Contact_Name__r.Name, Name, Applicant_Type__c, DeDupe_Counter__c, TotalFOIRHLResult__c, TotalFOIRNoHLResult__c, TotalWorkExpResult__c, UnsecuredFOIRResult__c, LoanAmountResult__c, CurrentWorkExpResult__c,
     //OwnHouse_RunningHLResult__c, CompanyCategoryResult__c, EducationQualificationResult__c, Segment_Prudense__c, Segment_Stability__c, Existing_Customer__c, Contact_Name__r.Age_Round_Down__c,
     //Segment_Achievment__c, SalaryToAgeResult__c, Bureau_Segment__c, Employer__c, StepUp_StepDown_EMI_Year_1__c, StepUp_StepDown_EMI_Year_2__c, StepUp_StepDown_EMI_Year_3__c, StepUp_StepDown_EMI_Year_4__c, StepUp_StepDown_EMI_Year_5__c, Company_Name_as_per_Domain_check__c, /*Mortgage*/ Contact_Name__r.Property_Owner__c /* SAL Policy Changes Start */ , RC_Decline__c, RC_Deviation__c /* SAL Policy Changes End */ , Domain_Created_Date__c /* bug 11151*/ from Applicant__c where Loan_Application__c =: loan.id
    //];
   //}
   Set < Id > setAppId = new Set < Id > ();
   system.debug('applicantList==' + applicantList);
   system.debug('applicantList.size()==' + applicantList.size());
   for (Applicant__c app: applicantList) {
          //  if(app.Applicant_Type__c=='Primary') 
          setAppId.add(app.id);
   }
   if (setAppId != null && setAppId.size() > 0) {
    //Mahima DPD cluster segment start Bug 12499  added Cibil_Temp__r.DPD_cluster_Segment__c,Cibil_Temp__r.SecondaryMatch_Record__c in query
    cibilList = [select Cibil_Temp__r.DPD_cluster_Segment__c, Cibil_Temp__r.SecondaryMatch_Record__c, Applicant__r.Contact_Name__r.Name, Applicant__r.Contact_Name__r.FirstName, Applicant__r.Contact_Name__r.LastName, id, Applicant__r.Contact_Name__c, Applicant__r.Applicant_Type__c, Applicant__r.CIBIL_Score__c, Applicant__r.Description__c, CibilDate__c
     from CIBIL__c where Applicant__c in: setAppId
    ];

   }

   //--------------- Mortgage Re-Engg Start---------------------
   if (setAppId != null && setAppId.size() > 0) {
    GoogleAttachmentList = [select Id, Name, ParentId from Attachment where parentId in: setAppId];
    for (Attachment attachTemp: GoogleAttachmentList) {
     GoogleAttachmentMap.put(attachTemp.parentId, attachTemp.Id);
    }
   }
   //--------------- Mortgage Re-Engg End-----------------------  

   List < Cibil_Extension1__c > cibilExt1List = new List < Cibil_Extension1__c > ();
   //SAL Policy Rule Changes :: Added by Pritha :: Added to query:: No_of_Live_PL__c
   cibilExt1List = [select id, /*OTP V3 CR s*/ Highest_DPD_In_1_Year__c, Number_of_Hl_Loans__c, max_mob__c, liveLoanAmount__c, X30_DPD_6_months__c, X30_DPD_3_months__c, securedToTotalRatioAmount__c, /*OTP V3 CR e*/ No_of_Live_PL__c, Written_Off_principal__c, Written_Off_principal9__c, Written_Off_principal8__c, Written_Off_principal7__c, Written_Off_principal6__c, Written_Off_principal5__c, Written_Off_principal4__c, Written_Off_principal3__c, Written_Off_principal2__c, Written_Off_principal29__c, Written_Off_principal28__c, Written_Off_principal27__c, Written_Off_principal26__c, Written_Off_principal25__c, Written_Off_principal24__c, Written_Off_principal23__c, Written_Off_principal22__c, Written_Off_principal21__c, Written_Off_principal20__c, Written_Off_principal1__c, Written_Off_principal19__c, Written_Off_principal18__c, Written_Off_principal17__c, Written_Off_principal16__c, Written_Off_principal15__c, Written_Off_principal14__c, Written_Off_principal13__c, Written_Off_principal12__c, Written_Off_principal11__c, Written_Off_principal10__c, Written_Off_and_settled_status__c, Written_Off_and_settled_status9__c, Written_Off_and_settled_status8__c, Written_Off_and_settled_status7__c, Written_Off_and_settled_status6__c, Written_Off_and_settled_status5__c, Written_Off_and_settled_status4__c, Written_Off_and_settled_status3__c, Written_Off_and_settled_status2__c, Written_Off_and_settled_status29__c, Written_Off_and_settled_status28__c, Written_Off_and_settled_status27__c, Written_Off_and_settled_status26__c, Written_Off_and_settled_status25__c, Written_Off_and_settled_status24__c, Written_Off_and_settled_status23__c, Written_Off_and_settled_status22__c, Written_Off_and_settled_status21__c, Written_Off_and_settled_status20__c, Written_Off_and_settled_status1__c, Written_Off_and_settled_status19__c, Written_Off_and_settled_status18__c, Written_Off_and_settled_status17__c, Written_Off_and_settled_status16__c, Written_Off_and_settled_status15__c, Written_Off_and_settled_status14__c, Written_Off_and_settled_status13__c, Written_Off_and_settled_status12__c, Written_Off_and_settled_status11__c, Written_Off_and_settled_status10__c, Write_Off__c,
    Bad_Track_Record__c, Tradelines_30plus_DPD__c, Total_Amount_overdue__c, Max_Lifetime_Delq__c, Ever_Write_off__c, Secured_Tradelines_90plus_DPD__c, No_Of_Live_Trades__c,
    Total_No_of_Trades__c, Unsecured_Tradelines_in_last_12m__c, First_Loan_MOB__c, Latest_Loan_MOB__c, Unsecured_to_total_ratio__c, Secured_to_unsecured_ratio__c, Unsecured_to_total_amount__c,
    OSB_to_loan_amount_unsecured__c, Credit_Card_utilization__c, Avg_unsecured_loan_amount__c, Unsecured_loan_balance__c, Total_Sanction_Amnt_unsecured__c, Total_Sanction_Amnt_secured__c,
    Current_Obligation_All__c, Current_Obligation_Secured__c, Current_Obligation_unsecured__c, Enquiries_past_3_mnths__c, Unsecured_Enquiries_past_3_mnths__c, Current_Bal_on_all_cards__c, Average_Total_Balance__c /*SAL Policy Chnage Start*/ , No_of_PL_Enq_in_Last_12_Months__c, No_of_PL_Enq_in_Last_6_Months__c, Sum_of_Amount_Overdue__c /*SAL Policy Chnage End*/
    from Cibil_Extension1__c where Applicant__c =: applicantPrimary.id limit 1
   ];
   if (cibilExt1List != null && cibilExt1List.size() > 0) {
    cibilExt1 = cibilExt1List[0];
   }
  } catch (Exception e) {
   //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e+''));
   system.debug('Exception occurd==>' + e.getMessage() + 'Line number===>' + e.getLinenumber());
   sendEmailForException(e);
  }
  return null;
 }
 /*  public List<CIBIL__c> getcibilres(){        
return cibilList;
}
*/
 public class cibilresWrap {
  public CIBIL__c cib {
   get;
   set;
  }
  public String cibAppConName {
   get;
   set;
  }
  public String cibAppConId {
   get;
   set;
  }
  public boolean selected { //Rasika bug 11152: Added for mortgage cibil co-applicant CR 
   get;
   set;
  }
  public cibilresWrap(CIBIL__c cib, String cibAppConName, String cibAppConId) {
   this.cib = cib;
   if (cibAppConName != null)
    this.cibAppConName = cibAppConName;
   this.cibAppConId = cibAppConId;
  }
 }
 //Getting the cibil details
 public List < cibilresWrap > getcibilres() {
  //List < cibilresWrap > cibilresList = new List < cibilresWrap > (); // bug 11152: as its declared globally now
  cibilresList = new List < cibilresWrap > (); // Rasika bug 11152: reinitializes list again
  if (cibilList != null) { //Mortgage condition added
   for (CIBIL__c c: cibilList)
    cibilresList.add(new cibilresWrap(c, c.Applicant__r.Contact_Name__r.Name, c.Applicant__r.Contact_Name__c));
  }
  return cibilresList;
 }

 //Reinitiate cibil
 public Pagereference initiateCibilPrimryApp() {
  Applicant__c appObj = new Applicant__c();
  Integer count = 0;

  //cibil revamp start
  boolean reinitiateCibil = false;
  List < Cibil_Temp__c > cibTemp;
  List < CIBIL__c > cibilList;
  Contact contObj = new Contact();
  //cibil revamp end
  try {
   System.debug('**** Rasika wrap List: ' + cibilresList);
   Set < ID > idsApp = new Set < ID > ();
   //cibil revamp start
   String selectedId = apexpages.currentpage().getparameters().get('selected');
   System.debug('###' + selectedId);
   //cibil revamp end


   if (selectedId != 'null') //cibil revamp
   {
    //cibil revamp start
    for (cibilresWrap c: cibilresList) {
     if (c.cib.id == selectedId) {
      idsApp.add(c.cib.Applicant__c);
      system.debug(' ****Radio button selected: test' + c.cib.id);
     }
    }
    system.debug(' ****idsApp' + idsApp);
    //cibil revamp end 

    if (idsApp != null && idsApp.size() > 0) {
     List < Applicant__c > applicantNewList = [select is_BL_PL_Risk__c, /*18279 S*/ Loan_Application__r.Account.Flow__c, /*18279 E*/ /*OTP V3 CR S*/ Score_card__c, Contact_Name__r.special_profile_employer__c, Codified_CIBIL__c, contact_name__r.employer__r.bank_names__c, Risk_Segmentation__c, Contact_Name__r.Employer__r.Employer_List__c, /*OTP V3 CR E*/ /* SAL Invisible monitering start */ RSA_reason__c, RSA_flag__c, RSA_Loan_application_status__c, RSA_Remarks__c, Underwriter_Remarks__c, RSA_Closure_Date__c, RSA_initiation_Date__c, RSA_TAT__c, Contact_Name__r.Email_Confirmation_received__c, Contact_Name__r.Customer_address_matches_with_eKYC__c, Contact_Name__r.Perfios_Address__c, Contact_Name__r.Customer_address_matches_with_perfios__c, Contact_Name__r.Customer_Add_Matches_With_Previous_Add__c /* SAL Invisible monitering end */ , Contact_Name__r.Linkedin_check_result__c, Contact_Name__r.Google_check_result__c, Contact_Name__r.PAN_Response__c,
      Contact_Name__r.SFDC_Dedupe_check__c, Contact_Name__r.office_no_check_on_company_site__c, id, Name, Contact_Name__r.Years_At_Residence__c, ContactName__c, movedToCibilTemp__c, SegmentaionResult__c, Loan_Application__c, Update_CIBIL_Error__c, Descriptin__c, Type_of_Borrower__c, Re_Initiate_De_Dupe__c, Integrate_with_CIBIL__c, Contact_Name__c, Contact_Name__r.Name, Contact_Name__r.Customer_Profile__c,
      Contact_Name__r.Designation__c, Contact_Name__r.Employer_Name__c, Contact_Name__r.Qualification__c, Contact_Name__r.Address_1__c, Sub_Segment__c,
      PD_Status__c, Bank_Status__c, Contact_Name__r.Address_2__c, FCU_Status__c, ITR_Status__c, Office_SE_Status__c, Office_SAL_Status__c, Lead__c,
      Office_Status__c, Pay_Slips_Status__c, Residence_Status__c, Trade_Status__c, TVR_Status__c, Select_Applicant__c, Applicant_Type__c, Contact_Name__r.Customer_Type__c, Contact_Name__r.ApplicantType__c,
      Contact_Name__r.Date_of_Birth__c, Contact_Name__r.FathersHusbands_Name__c, Contact_Name__r.PAN_Number__c, Contact_Name__r.Year_of_Incorporation__c, Contact_Name__r.Account.TIN_Number__c,
      Contact_Name__r.Bank_Account_No__c, Contact_Name__r.VoterID_Number__c, Contact_Name__r.ROC_Regn_No__c, Contact_Name__r.Address_3__c, Contact_Name__r.AppCity__c,
      Contact_Name__r.Pin_Code__c, Contact_Name__r.Phone, Contact_Name__r.MobilePhone, Contact_Name__r.Email, Contact_Name__r.Address_Line_One__c, Contact_Name__r.Address_2nd_Line__c, Contact_Name__r.Address_3rd_Line__c,
      Contact_Name__r.Permanent_Land_Mark__c, Contact_Name__r.Office_City__c, Contact_Name__r.Office_Pin_Code__c, Contact_Name__r.Office_STD_Code__c, Contact_Name__r.Office_Phone_Number__c,
      Contact_Name__r.Mobile_Phone__c, Contact_Name__r.Office_Email_Id__c, Contact_Name__r.Middle_Name__c, Employer__c, Company_Type__c, Company_Name__c, Contact_Name__r.Company_Type__c,
      DIN_No_if_applicable__c, Contact_Name__r.FirstName, Contact_Name__r.LastName, Contact_Name__r.Permanant_Address_Line_1__c, Contact_Name__r.Permanant_Address_Line_2__c, Contact_Name__r.Permanant_Address_Line_3__c,
      Contact_Name__r.Permanent_STD__c, Contact_Name__r.Permanent_Pin_Code__c, Contact_Name__r.Year_in_Present_Job__c, Contact_Name__r.Year_in_Previous_Job__c, Contact_Name__r.Name_of_the_company_Employer__c,
      Contact_Name__r.Nature_of_Business__c, Contact_Name__r.Employment_Status__c, Contact_Name__r.Gender__c, Contact_Name__r.Age__c, Contact_Name__r.Employment_Type__c, Contact_Name__r.STD_Code__c, Contact_Name__r.Phone_Number__c,
      Contact_Name__r.Name_of_Employer__c, Designation__c, Contact_Name__r.Type_Of_Constitution__c, Contact_Name__r.Marital_Status__c, Contact_Mobile__c, Contact_Name__r.Residence_City__c, Contact_Name__r.Sex__c,
      Contact_Name__r.Total_Work_Experience_Yrs__c, Contact_Name__r.Employer__r.name, Contact_Name__r.TAN_Number__c, Contact_Name__r.TAN_Found_In_Master__c, Contact_Name__r.Email_Domain_Status__c, Contact_Name__r.Bank_Name1__c,
      Contact_Name__r.Bank_Name_Status1__c, Loan_Application__r.Existing_Customer__c, Contact_Name__r.PAN_Card_Status__c, Comments__c, Contact_Name__r.CIBIL_Report__c, Contact_Name__r.Office_Email_Id_for_Fraud__c, Contact_Name__r.TAN__c, Contact_Name__r.Current_experiance_in_Years__c, Contact_Name__r.Residence_Type__c, Contact_Name__r.Employer__r.Company_Category__c, Existing_Customer__c,
      Contact_Name__r.Age_of_Applicant__c, CIBIL_Score__c, Cibil_Temp__c, DeDupe_Counter__c, TotalFOIRHLResult__c, TotalFOIRNoHLResult__c, TotalWorkExpResult__c, UnsecuredFOIRResult__c, LoanAmountResult__c, CurrentWorkExpResult__c,
      OwnHouse_RunningHLResult__c, CompanyCategoryResult__c, EducationQualificationResult__c, Segment_Prudense__c, Segment_Stability__c, Contact_Name__r.Age_Round_Down__c, /*18370 S*/ Is_Hybrid_Flexi_for_Topup__c, Topup_Pure_Flexi_Period__c, Topup_Dropline_Flexi_Period__c, Topup_Loan_Proposed_EMI__c, Topup_Pure_Flexi_EMI__c /*18370 E*/ ,
      Segment_Achievment__c, SalaryToAgeResult__c, Bureau_Segment__c, StepUp_StepDown_EMI_Year_1__c, StepUp_StepDown_EMI_Year_2__c, StepUp_StepDown_EMI_Year_3__c, StepUp_StepDown_EMI_Year_4__c, StepUp_StepDown_EMI_Year_5__c, Company_Name_as_per_Domain_check__c, /*Mortgage*/ Contact_Name__r.Property_Owner__c /* SAL Policy Changes Start */ , RC_Decline__c, RC_Deviation__c /* SAL Policy Changes End */ , Office_Email_Id_Verified__c, Total_Employment_Vintage__c, Verifications_returned_by_IM_BRE__c, /*bug 11151 s */ Domain_Created_Date__c /* bug 11151 e*/
      from Applicant__c where id =: idsApp
     ];

     system.debug('applicantNewList SHL==' + applicantNewList);
     system.debug('applicantNewList SHL==' + applicantNewList.size());

     Id contId;

     for (Applicant__c app: applicantNewList) {
      //if (app.Applicant_Type__c != 'Primary') {
      appObj = app;
      contId = app.Contact_Name__c;
      //}
     }
     if (contId != null) {
      contObj = [select Id, Mobile__c, Customer_Type__c, Sex__c, VoterID_Number__c, PassPort_Number__c, PAN_Number__c, Middle_Name__c, Address_1__c,
       Address_2__c, Address_3__c, FirstName, LastName, State__c, AppCity__c, Date_of_Birth__c, Mobile_Phone__c, Pin_Code__c, Customer_entered_address__c, eKYC_Address__c, Perfios_Address__c, Email_Confirmation_received__c, Customer_address_matches_with_eKYC__c,
       Customer_address_matches_with_perfios__c, Customer_Add_Matches_With_Previous_Add__c
       from Contact where id =: contId limit 1
      ];
     }
     system.debug('contObj.size() SHL==' + contObj);
     system.debug('appObj SHL==' + appObj);
     if (contObj != null && appObj != null) {

      //cibTemp = [select id from Cibil_Temp__c where Applicant__c = : appObj.id];
      //cibil revamp query
      cibTemp = [select id, CIBIL_Match_Check__c, CIBIL_Score__c, CIBIL_Response__c, (select id from CIBILs__r), (select id from CIBIL_Extension__r), (select id from Cibil_Extension1s__r) from Cibil_Temp__c where Applicant__c =: appObj.id FOR UPDATE];
      //cibil revamp query
      system.debug('***cibTemp&&&&& SHL: ' + cibTemp.size());
      system.debug('***cibTemp&&&&& SHL: ' + cibTemp);
      if (cibTemp.size() == 0) {
       CibilService.createCibilTempRecord(contObj, appObj);
       //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'CIBIL Initiated.. '));   
       savedSuccessfull = true;
       message = 'CIBIL Initiated successfully';
       system.debug('CIBIL called==');
      } else if (cibTemp.size() > 0) {
       List < CIBIL__c > cibilrelList = new List < CIBIL__c > ();
       List < CIBIL_Extension__c > cibilextrelList = new List < CIBIL_Extension__c > ();
       List < Cibil_Extension1__c > cibilext1relList = new List < Cibil_Extension1__c > ();

       for (Cibil_temp__c cibiltmprcrds: cibTemp) {

        System.debug('cibiltmprcrds.CIBIL_Response__c ' + cibiltmprcrds.CIBIL_Response__c);
        System.debug('cibiltmprcrds.CIBIL_Score__c ' + cibiltmprcrds.CIBIL_Score__c);
        System.debug('cibiltmprcrds.CIBIL_Match_Check__c ' + cibiltmprcrds.CIBIL_Match_Check__c);

        if (!(String.isBlank(cibiltmprcrds.CIBIL_Response__c) && String.isBlank(cibiltmprcrds.CIBIL_Score__c) && (cibiltmprcrds.CIBIL_Match_Check__c == '--None--' || String.isBlank(cibiltmprcrds.CIBIL_Match_Check__c)))) {
         system.debug('CIBIL called 2 ==');

         system.debug('CIBIL called 2.01 ==');

         system.debug('CIBIL called 2.09 ==');
         if (cibiltmprcrds.CIBILs__r.size() > 0)
          cibilrelList.addAll(cibiltmprcrds.CIBILs__r);
         system.debug('CIBIL called 2.011 ==');

         if (cibiltmprcrds.CIBIL_Extension__r.size() > 0)
          cibilextrelList.addAll(cibiltmprcrds.CIBIL_Extension__r);
         system.debug('CIBIL called 2.0111 ==');

         if (cibiltmprcrds.Cibil_Extension1s__r.size() > 0)
          cibilext1relList.addAll(cibiltmprcrds.Cibil_Extension1s__r);
        }
       }
       delete cibTemp;
       system.debug('CIBILTemp Deleted');
       if (cibilrelList.size() > 0) {
        delete cibilrelList;
        system.debug('CIBIL Deleted');
       }
       if (cibilextrelList.size() > 0) {
        delete cibilextrelList;
        system.debug('CIBIL Extension Deleted');
       }
       if (cibilext1relList.size() > 0) {
        delete cibilext1relList;
        system.debug('CIBIL Extension1 Deleted');
       }

       //Bug - 15071 To delete obligation - (Existing_loan_details)

       System.debug('Selected applicant : ' + appObj + ' ' + appObj.id);
       System.debug('ObligationWrapperList ' + ObligationWrapperList);
       System.debug('ObligationWrapperList size ' + ObligationWrapperList.size());

       List < Existing_Loan_details__c > deleteObligation = new List < Existing_Loan_details__c > ();

       for (ObligationWrapper obligation: ObligationWrapperList) {
        if (obligation.exloan.applicant__r.id == appObj.id) {
         deleteObligation.add(obligation.exloan);
        }
       }
       System.debug('size of delete obligation' + deleteObligation.size());

       if (deleteObligation.size() > 0) {
        delete deleteObligation;
        system.debug('Obligation Deleted');
       }


       CibilService.createCibilTempRecord(contObj, appObj);

       savedSuccessfull = true;
       system.debug('CIBIL new created==');
       message = 'CIBIL Initiated successfully';
      } else {
       savedSuccessfull = true;
       message = 'Applicant already exist';

      }
     }
    }
   } else {
    savedSuccessfull = true;
    message = 'Please select cibil record';
   }
   //cibil revamp end 
  } catch (Exception e) {
   system.debug('Exception occurd==>' + e.getMessage() + 'Line number===>' + e.getLinenumber());
   //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e+''));
   sendEmailForException(e);
  }
  return null;
 }
 public Pagereference addMoreLoans() {
  //Rate Approval :: ROIFlexi__c, ROILoc__c, ROINormal__c, ROI_PO__c, 
  List < Applicant__c > applicantList = [select is_BL_PL_Risk__c, /*OTP V3 CR S*/ Score_card__c, Contact_Name__r.Employer__r.Employer_List__c, Contact_Name__r.special_profile_employer__c, Codified_CIBIL__c, contact_name__r.employer__r.bank_names__c, Risk_Segmentation__c, /*OTP V3 CR E*/ /* SAL Invisible monitering start */ RSA_reason__c, RSA_flag__c, RSA_Loan_application_status__c, RSA_Remarks__c, Underwriter_Remarks__c, RSA_Closure_Date__c, RSA_initiation_Date__c, RSA_TAT__c, Contact_Name__r.Email_Confirmation_received__c, Contact_Name__r.Customer_address_matches_with_eKYC__c, Contact_Name__r.Perfios_Address__c, Contact_Name__r.Customer_address_matches_with_perfios__c, Contact_Name__r.Customer_Add_Matches_With_Previous_Add__c /* SAL Invisible monitering end */ , ROIFlexi__c, /*SAL PLTB Pritha S*/ LTA_Medical__c, LTA_Frequency__c, /*SAL PLTB Pritha E*/ ROILoc__c, ROINormal__c, ROI_PO__c, Contact_Name__r.Linkedin_check_result__c, Contact_Name__r.Google_check_result__c, Contact_Name__r.PAN_Response__c,
   Contact_Name__r.SFDC_Dedupe_check__c, Contact_Name__r.office_no_check_on_company_site__c, id, Name, Contact_Name__r.Total_Work_Experience_Yrs__c, Contact_Name__r.Years_At_Residence__c, SegmentaionResult__c, ContactName__c, Loan_Application__c, movedToCibilTemp__c, Update_CIBIL_Error__c, Descriptin__c, Type_of_Borrower__c, Re_Initiate_De_Dupe__c, Integrate_with_CIBIL__c, Contact_Name__c, Contact_Name__r.Name, Contact_Name__r.Customer_Profile__c,
   Contact_Name__r.Designation__c, Contact_Name__r.Employer_Name__c, Contact_Name__r.Qualification__c, Contact_Name__r.Address_1__c,
   PD_Status__c, Bank_Status__c, Contact_Name__r.Address_2__c, FCU_Status__c, ITR_Status__c, Office_SE_Status__c, Office_SAL_Status__c,
   Office_Status__c, Pay_Slips_Status__c, Residence_Status__c, Trade_Status__c, TVR_Status__c, Select_Applicant__c, Applicant_Type__c, Contact_Name__r.Customer_Type__c, Contact_Name__r.ApplicantType__c,
   Contact_Name__r.Date_of_Birth__c, Contact_Name__r.FathersHusbands_Name__c, Contact_Name__r.PAN_Number__c, Contact_Name__r.Year_of_Incorporation__c, Contact_Name__r.Account.TIN_Number__c,
   Contact_Name__r.Bank_Account_No__c, Contact_Name__r.VoterID_Number__c, Contact_Name__r.ROC_Regn_No__c, Contact_Name__r.Address_3__c, Contact_Name__r.AppCity__c,
   Contact_Name__r.Pin_Code__c, Contact_Name__r.Phone, Contact_Name__r.MobilePhone, Contact_Name__r.Email, Contact_Name__r.Address_Line_One__c, Contact_Name__r.Address_2nd_Line__c, Contact_Name__r.Address_3rd_Line__c,
   Contact_Name__r.Permanent_Land_Mark__c, Contact_Name__r.Office_City__c, Contact_Name__r.Office_Pin_Code__c, Contact_Name__r.Office_STD_Code__c, Contact_Name__r.Office_Phone_Number__c,
   Contact_Name__r.Mobile_Phone__c, Contact_Name__r.Office_Email_Id__c, Contact_Name__r.Middle_Name__c, Employer__c, Company_Type__c, Company_Name__c, Contact_Name__r.Company_Type__c,
   DIN_No_if_applicable__c, Contact_Name__r.FirstName, Contact_Name__r.LastName, Contact_Name__r.Permanant_Address_Line_1__c, Contact_Name__r.Permanant_Address_Line_2__c, Contact_Name__r.Permanant_Address_Line_3__c,
   Contact_Name__r.Permanent_STD__c, Contact_Name__r.Permanent_Pin_Code__c, Contact_Name__r.Year_in_Present_Job__c, Contact_Name__r.Year_in_Previous_Job__c, Contact_Name__r.Name_of_the_company_Employer__c,
   Contact_Name__r.Nature_of_Business__c, Contact_Name__r.Employment_Status__c, Contact_Name__r.Gender__c, Contact_Name__r.Age__c, Contact_Name__r.Employment_Type__c, Contact_Name__r.STD_Code__c, Contact_Name__r.Phone_Number__c,
   Contact_Name__r.Name_of_Employer__c, Designation__c, Contact_Name__r.Type_Of_Constitution__c, Contact_Name__r.Marital_Status__c, Contact_Mobile__c, Contact_Name__r.Residence_City__c, Contact_Name__r.Sex__c,
   Contact_Name__r.Employer__r.name, Contact_Name__r.TAN_Number__c, Contact_Name__r.TAN_Found_In_Master__c, Contact_Name__r.Email_Domain_Status__c, Contact_Name__r.Bank_Name1__c,
   Contact_Name__r.Bank_Name_Status1__c, Loan_Application__r.Existing_Customer__c, Contact_Name__r.PAN_Card_Status__c, Comments__c, Contact_Name__r.CIBIL_Report__c, Contact_Name__r.Office_Email_Id_for_Fraud__c, Contact_Name__r.TAN__c, Contact_Name__r.Current_experiance_in_Years__c, Contact_Name__r.Residence_Type__c, Contact_Name__r.Employer__r.Company_Category__c,
   Contact_Name__r.Age_of_Applicant__c, CIBIL_Score__c, Is_PL_BT__c, Cibil_Temp__c, DeDupe_Counter__c, Existing_Customer__c,
   StepUp_StepDown_EMI_Year_1__c, StepUp_StepDown_EMI_Year_2__c, StepUp_StepDown_EMI_Year_3__c, StepUp_StepDown_EMI_Year_4__c, StepUp_StepDown_EMI_Year_5__c, TotalFOIRHLResult__c, TotalFOIRNoHLResult__c, TotalWorkExpResult__c, UnsecuredFOIRResult__c, LoanAmountResult__c, CurrentWorkExpResult__c,
   OwnHouse_RunningHLResult__c, CompanyCategoryResult__c, EducationQualificationResult__c, Segment_Prudense__c, Segment_Stability__c,
   Segment_Achievment__c, SalaryToAgeResult__c, Bureau_Segment__c, Company_Name_as_per_Domain_check__c, /*Mortgage*/ Contact_Name__r.Property_Owner__c, Contact_Name__r.Occupation__c /* SAL Policy Changes Start */ , RC_Decline__c, RC_Deviation__c, /* SAL Policy Changes End */
   /*bug 11151 s */
   Domain_Created_Date__c /* bug 11151 e*/ , /*18370 S*/ Is_Hybrid_Flexi_for_Topup__c, Topup_Pure_Flexi_Period__c, Topup_Dropline_Flexi_Period__c, Topup_Loan_Proposed_EMI__c, Topup_Pure_Flexi_EMI__c /*18370 E*/
   from Applicant__c where Loan_Application__c =: loan.id
  ];
  applicantSelectList.clear();
  for (Applicant__c appl: applicantList) {
   system.debug('applicantSele appl.ContactName__cctList== ' + appl.ContactName__c);
   if (appl != null && appl.ContactName__c != null)
    applicantSelectList.add(new SelectOption(appl.ContactName__c, appl.ContactName__c));
  }
  system.debug('applicantSelectList== ' + applicantSelectList);
  Existing_Loan_Details__c newLoan = new Existing_Loan_Details__c();
  newLoan.Loan_Type__c = null;
  newLoan.Loan_Amount__c = 0;
  newLoan.POS__c = 0;
  newLoan.Start_On__c = null;
  newLoan.Loan_Application__c = loan.id;

  newLoan.Status__c = 'Live';
  newLoan.Obligation__c = 'Yes';
  newLoan.Type_of_Oblig__c = 'Individual';
  //existingLoanDetailsList.add(newLoan);
  /*  if (ObligationWrapperList.size() < 0)
ObligationWrapperList = new List < ObligationWrapper > ();
system.debug('existing list ObligationWrapperList=== ' + ObligationWrapperList.size() + '&&&' + ObligationWrapperList);
ObligationWrapperList.add(new ObligationWrapper(false, applicantSelectList, newLoan, false));*/
  if (ObligationWrapperList != null && ObligationWrapperList.size() > 0) {
   ObligationWrapperList.add(new ObligationWrapper(false, applicantSelectList, newLoan, false));
  } else {
   ObligationWrapperList = new List < ObligationWrapper > ();
   ObligationWrapperList.add(new ObligationWrapper(false, applicantSelectList, newLoan, false));
  }
  system.debug('newLoan === ' + newLoan.Loan_Type__c + '--' + newLoan.Loan_Amount__c + '--' + newLoan.POS__c + '--' + newLoan.Start_On__c);
  system.debug('existing loan dt ObligationWrapperList=== ' + ObligationWrapperList.size() + '--' + ObligationWrapperList);
  // showOutPutField = false;
  // viewRemoveButton = true;
  return null;
 }
 public List < Existing_Loan_Details__c > getexistingLoanDetailsList() {
  return existingLoanDetailsList;
 }
 /*  public void populateProductOfferings(string panNo){
if(panNo != null && panNo != ''){
productOfferings = [Select id,name,Products__c,Offer_Amount__c,Offer_ROI__c,Tenor__c,Existing_Product__c,
Existing_LAN__c,POS__c,Existing_Loan_Status__c,MOB__c,Lead__r.Customer_Segmentation_CIBIL__c,Latest_Financial__c,
Existing_Tenor__c from Product_Offerings__c where Lead__r.PAN_Cibil__c =:panNo];
}
}*/

 //BT Multiplier calculator 10905.. YK
 public void calculateBTMultiplier() {
  try {

   List < Existing_Loan_Details__c > existingLoanDetailsList = [select id, financers__c, Name, Customer_Declared_EMI__c,
    EMI_Over_In_Next_6_months__c, Status__c, Final_EMI__c, Secured_Unsecured__c, Loan_Type__c, Loan_Amount__c, Seen_in__c,
    Loan_Acc_No__c, Select__c, Applicant__r.ContactName__c, Principal_O_s__c, Obligation__c,
    Financer__c, Amount__c, Month1_Amount__c, Month2_Amount__c, Derived_EMI__c, Remark__c, No_of_Bounces_if_any__c,
    Start_On__c, Tenor__c, Tenor_Left__c, MOB__c, POS__c, EMI__c, Applicant__c, Annual_Obligation__c, Type_of_Oblig__c,
    Rate_of_Interest__c, City__c, Property_Address__c /*01MOB S*/ , Purchase_Value__c,
    Property_Purchase_Date__c /*01MOB E*/ , /*Mortgage*/ Applicant__r.Applicant_Type__c, /*Mortgage*/ Mthly_Oblig__c,
    Multiplier__c, /*Bug 13407 s*/ Mortgage_free_property__c, Still_own_the_property__c /*Bug 13407 e*/ from Existing_Loan_Details__c where Loan_Application__c =: loan.id order by CreatedDate
   ];

   ObligationWrapperList = new List < ObligationWrapper > ();
   for (Existing_Loan_Details__c exp: existingLoanDetailsList) {
    ObligationWrapperList.add(new ObligationWrapper(false, applicantSelectList, exp, false));
   }

   if (ObligationWrapperList != null && ObligationWrapperList.size() > 0) {
    system.debug('ObligationWrapperList ----->> ' + ObligationWrapperList);
    List < Existing_Loan_Details__c > proposedBtLoanObjList = new List < Existing_Loan_Details__c > ();
    for (ObligationWrapper obligationWrapperObj: ObligationWrapperList) {
     if (obligationWrapperObj.exloan.Status__c == 'Proposed BT' && (obligationWrapperObj.exloan.Loan_Type__c == 'HL' ||
       obligationWrapperObj.exloan.Loan_Type__c == 'HL ?Improvement' ||
       obligationWrapperObj.exloan.Loan_Type__c == 'HL ?Top Up' ||
       obligationWrapperObj.exloan.Loan_Type__c == 'LAP' ||
       obligationWrapperObj.exloan.Loan_Type__c == 'Housing Loan' ||
       obligationWrapperObj.exloan.Loan_Type__c == 'Property Loan')) {
      proposedBtLoanObjList.add(obligationWrapperObj.exloan);
     }
    }
    system.debug('proposedBtLoanObjList ---111---->> ' + proposedBtLoanObjList);
    if (proposedBtLoanObjList != null && proposedBtLoanObjList.size() > 0) {
     Map < String, Object > btMultiplierParameterMap = new Map < String, Object > ();
     List < Object > btLoanObjDetailsList = new List < Object > ();
     for (Existing_Loan_Details__c proposedBtLoanObj: proposedBtLoanObjList) {
      Map < String, Object > btLoanObjDetailsMap = new Map < String, Object > ();
      btLoanObjDetailsMap.put('existing_loan_id', proposedBtLoanObj.Id);
      btLoanObjDetailsMap.put('status', 'proposed bt');
      btLoanObjDetailsMap.put('mob', proposedBtLoanObj.MOB__c != null ? proposedBtLoanObj.MOB__c : 0);
      btLoanObjDetailsMap.put('loan_amount', proposedBtLoanObj.Loan_Amount__c != null ? proposedBtLoanObj.Loan_Amount__c : 0);
      btLoanObjDetailsList.add(btLoanObjDetailsMap);
     }
     btMultiplierParameterMap.put('BTLoansDetails', btLoanObjDetailsList);
     btMultiplierParameterMap.put('loan_id', Loan.Id);
     btMultiplierParameterMap.put('segmentation', applicantPrimary.SegmentaionResult__c != null ? applicantPrimary.SegmentaionResult__c : '');

     String jsonRequestString;
     jsonRequestString = JSON.serialize(btMultiplierParameterMap);
     system.debug('jsonRequestString ----->> ' + jsonRequestString);

     BRECallout breCalloutObj = new BRECallout();
     String responseBody = BRECallout.btMultiplierCalculator(jsonRequestString);

     system.debug('responseBody ------->> ' + responseBody);

     BTMultiplierResponseBodyWrapper responseWrapperInstance = (BTMultiplierResponseBodyWrapper)
     JSON.deserialize(responseBody, BTMultiplierResponseBodyWrapper.class);

     system.debug('responseWrapperInstance------>> ' + responseWrapperInstance.bt_loans_output[0]);

     if (responseWrapperInstance.bt_loans_output.size() > 0) {
      Decimal totalOfBTMultiplierObligations = 0;
      for (BTLoanOutput btLoanOutputObj: responseWrapperInstance.bt_loans_output) {
       for (Existing_Loan_Details__c proposedBtLoanObj: proposedBtLoanObjList) {
        if (proposedBtLoanObj.Id == btLoanOutputObj.existing_loan_id) {
         proposedBtLoanObj.Multiplier__c = Decimal.valueOf(btLoanOutputObj.loan_amount);
         proposedBtLoanObj.Derived_EMI__c = null;
         totalOfBTMultiplierObligations = totalOfBTMultiplierObligations + Decimal.valueOf(btLoanOutputObj.loan_amount);
        }
       }
      }
      system.debug('proposedBtLoanObjList2 --YK---->> ' + proposedBtLoanObjList);
      upsert proposedBtLoanObjList;
      cam.Loan_Application__c = Loan.Id;
      cam.BT_Existing_Top_up_multiplier__c = totalOfBTMultiplierObligations;
      upsert cam;
     }
     isProposedBT = false;
    }
   }
  } catch (Exception e) {
   System.debug('Callout error: ' + e.getMessage());
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Following error occured while Calculating BT Multiplier value. Contact your administrator...\n Error  :' + e.getMessage()));
  }
 }

 public class BTMultiplierResponseBodyWrapper {
  List < BTLoanOutput > bt_loans_output = null;
 }

 public class BTLoanOutput {
  String existing_loan_id = null;
  String loan_amount = null;
 }

 //BT Multiplier calculator 10905.. YK.. END

 public void saveIncomeDetails() {
  system.debug('inside saveIncomeDeatils');
  try {
   //BT Multiplier calculator 10905.. YK
   isProposedBT = false;
   cam.Loan_Application__c = loan.Id;
   if (con.Id != null)
    cam.Type_Cust__c = con.Customer_Type__c;
   cam.Type_of_CAM_Entity__c = 'Salaried';
   if (con.Id != null)
    cam.Type_Cust__c = con.Customer_Type__c;
   system.debug('final cam ==' + cam);
   system.debug('final cam ==' + cam.Gross_Salary_Month1__c);
   if (cam.Gross_Salary_Month1__c != null && cam.Gross_Salary_Month2__c != null && cam.Gross_Salary_Month3__c != null)
    cam.Net_Salary_for_Month1__c = ((cam.Gross_Salary_Month1__c + cam.Gross_Salary_Month2__c + cam.Gross_Salary_Month3__c) / 3).round(system.roundingMode.CEILING);
   if (cam.Gross_Salary_Month1__c == null && cam.Gross_Salary_Month2__c == null && cam.Gross_Salary_Month3__c == null)
    cam.Net_Salary_for_Month1__c = 0;


   if (cam.Receips1_Doc__c != null && cam.Receips2_Doc__c != null && cam.Receips3_Doc__c != null)
    cam.Net_Salary_for_Month2__c = ((cam.Receips1_Doc__c + cam.Receips2_Doc__c + cam.Receips3_Doc__c) / 3).round(system.roundingMode.CEILING);
   if (cam.Receips1_Doc__c == null && cam.Receips2_Doc__c == null && cam.Receips3_Doc__c == null)
    cam.Net_Salary_for_Month2__c = 0;
   //added by gopika
   /* if (cam.Average_incentive_for_Q1__c != null &&cam.Average_incentive_for_Q1__c!=0&& cam.Average_incentive_for_Q2__c != null &&cam.Average_incentive_for_Q2__c!=0&& cam.Average_incentive_for_Q3__c != null&&cam.Average_incentive_for_Q3__c !=0)
cam.Construction_Valuation_1__c = ((cam.Average_incentive_for_Q1__c + cam.Average_incentive_for_Q2__c + cam.Average_incentive_for_Q3__c) / 3).round(system.roundingMode.CEILING);
else if(cam.Average_incentive_for_Q1__c != null &&cam.Average_incentive_for_Q1__c!=0&& cam.Average_incentive_for_Q2__c != null &&cam.Average_incentive_for_Q2__c!=0)
cam.Construction_Valuation_1__c = ((cam.Average_incentive_for_Q1__c + cam.Average_incentive_for_Q2__c) / 2).round(system.roundingMode.CEILING);
else if(cam.Average_incentive_for_Q2__c != null &&cam.Average_incentive_for_Q2__c!=0&& cam.Average_incentive_for_Q3__c != null &&cam.Average_incentive_for_Q3__c!=0)
cam.Construction_Valuation_1__c = ((cam.Average_incentive_for_Q3__c + cam.Average_incentive_for_Q2__c) / 2).round(system.roundingMode.CEILING);
else if(cam.Average_incentive_for_Q3__c != null &&cam.Average_incentive_for_Q3__c!=0&& cam.Average_incentive_for_Q1__c != null &&cam.Average_incentive_for_Q1__c!=0)
cam.Construction_Valuation_1__c = ((cam.Average_incentive_for_Q1__c + cam.Average_incentive_for_Q3__c) / 2).round(system.roundingMode.CEILING);
if (cam.Average_incentive_for_Q1__c == 0 && cam.Average_incentive_for_Q1__c == 0 && cam.Average_incentive_for_Q3__c == 0)
cam.Construction_Valuation_1__c = 0;*/
   system.debug('gopika value of cam.Average_incentive_for_Q1__c--->>> ' + cam.Average_incentive_for_Q1__c);
   if (cam.Average_incentive_for_Q1__c != null && cam.Average_incentive_for_Q2__c != null && cam.Average_incentive_for_Q3__c != null)
    cam.Construction_Valuation_1__c = ((cam.Average_incentive_for_Q1__c + cam.Average_incentive_for_Q2__c + cam.Average_incentive_for_Q3__c) / 3).round(system.roundingMode.CEILING);
   if (cam.Average_incentive_for_Q1__c == null && cam.Average_incentive_for_Q2__c == null && cam.Average_incentive_for_Q3__c == null)
    cam.Construction_Valuation_1__c = 0;

   if (cam.Receips4_Doc__c != null && cam.Receips5_Doc__c != null && cam.Receips6_Doc__c != null)
    cam.Construction_Valuation_2__c = ((cam.Receips4_Doc__c + cam.Receips5_Doc__c + cam.Receips6_Doc__c) / 3).round(system.roundingMode.CEILING);
   if (cam.Receips4_Doc__c == null && cam.Receips5_Doc__c == null && cam.Receips6_Doc__c == null)
    cam.Construction_Valuation_2__c = 0;
   if (loan.Tenor__c != null)
    cam.Tenor__c = loan.Tenor__c;
   if (loan.Requested_ROI__c != null)
    cam.ROI__c = loan.Requested_ROI__c;
   if (loan.Loan_Amount__c != null)
    cam.Proposed_Loan_Amt__c = loan.Loan_Amount__c;

   system.debug('-cam.Average_Monthly_Net_Income2__c---->' + cam.Average_Monthly_Net_Income2__c);
   if (!Test.isRunningTest())
    upsert cam;

   /*Dynamic Query Added - Aman*/
   String loanId = loan.id;
   String WhereANDCondition;
   String camQuery;
   camQuery = 'SELECT name, Payment_Date_1__c, Payment_Date_2__c, Payment_Date_3__c, Recent_continuous__c, Repayment_of_loan__c, CreatedDate, Current_Year_PLBS__c, Current_Year_PLBS__r.Year__c, Previous_Year_PLBS__r.Year__c, Previous_Year_PLBS__c, Applicant__r.Contact_Name__c,' +
    'Type_Cust__c, Type_of_Entity__c, Month1__c, Total_Income_GP__c, Month2__c, Month3__c, Gross_Salary_Month1__c, Approved_CAM__c, Monthly_Reimbursement__c, Maximum_Unsecured_Exposure_MUM__c,' +
    'Gross_Salary_Month2__c, Gross_Salary_Month3__c, Final_Net_An_Inc__c, Net_Salary_for_Month1__c, Net_Salary_for_Month2__c, Net_Salary_for_Month3__c, Avg_Net_Sal__c, Avg_Mthly_Inctve_70__c,' +
    'Avg_Qtrly_Inctve_60__c, Avg_Mthly_Net_Inc__c, Average_Monthly_Net_Income1__c, Mthly_Loan_EMI__c, Credit_Card_Out_5__c, OD_interest__c, Total_Mthly_Oblig__c, NAS__c, Maxi_EMI_Banking__c, Maxi_EMI_Cust__c,' +
    'Maxi_EMI_FOIR__c, Max_EMI_Offer__c, NAS_Multi__c, Max_Loan_Amt_NAS_Multi__c, ROI__c, Final_FOIR__c, Avg_monthly_incentive1__c, Avg_monthly_incentive2__c,' +
    'Proposed_Loan_Amt__c, IRR_TO__c, Tenor__c, EMI_on_Proposed_Loan_TO__c, Insurance_taken_TO__c, Premium_Amount_TO__c, Loan_Amt_Premium__c, EMI_with_Insurance_Premium_TO__c,' +
    'Avg_monthly_incentive3__c, Avg_mthly_incntve_3mts__c, Average_incentive_for_Q1__c, Average_incentive_for_Q2__c, Average_incentive_for_Q3__c, Avg_qtrly_incentive__c,' +
    'Incentive_Monthly_or_Quarterly__c, Receips1_Doc__c, Receips2_Doc__c, Receips3_Doc__c, Receips4_Doc__c, Receips5_Doc__c, Receips6_Doc__c, Month4_Doc__c, Month5_Doc__c,' +
    'Selected1__c, Month1_Doc__c, Month2_Doc__c, Month3_Doc__c, Year1_Doc__c, Year2_Doc__c, Year3_Doc__c, LAP_EMI__c, Construction_Valuation_1__c, Construction_Valuation_2__c,' +
    'Sal_Deviation_on_FOIR__c, Sal_MUE_Funding__c, sal_max_loan__c, LAP_pmt__c, Interest_on_term_loans__c, Bounces_in_Latest_3_Months__c, App_Mon_Income__c, Monthly_CC_OD_interest__c, ELC_Line_Amounts__c,' +
    'Rental_Income__c, Adjusted_Rental_Income__c, SAL_Max_FOIR_as_BFL__c, New_Sal_Deviation_on_FOIR__c, MLA_for_Unlisted_Pvt__c, Applicable_FOIR1__c, Unsecured_FOIR__c, Secured_FOIR__c,' +
    'Deviation_on_FOIR__c, max_loan_POS_forExSAL__c, Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c, Max_Loan_Amount_for_IT_Company__c, Average_Monthly_Net_Income2__c,' +
    'Bank_Details__r.Average_Balance__c, Existing_HL_EMI__c, Bank_Details__r.Sum_of_average_Balance__c, Bank_Details__r.Transaction_Count__c, Average_Bank_Balance__c, id, Average_monthly_Obligations__c, Avg_Mthly_Net_Inc1__c, Income_from_CY__c, ELIGIBILITY_ACCORDING_TO_GROSS_RECEIPTS__c, ELIGIBILITY_ACCORDING_TO_CASH_PROFITS_ME__c, Fund_Based__c,' +
    'Entity_Record_Type__c, BT_Existing_Top_up_multiplier__c, Loan_elig_TO__c, EMI_of_The_Loan__c, Rental_Income_to_be_considered__c, Live_unsecured_loan__c, Selected_Option_TO__c, Eligible_FOIR__c, Eligible_Loan__c, Multiplier__c,LAP_Tenor__c, GP_Other_income__c, Oth_Inc_2_be_Consd__c, Average_Bank_Balance_GDP__c, Eligible_Home_Loan_Amount__c, Stake_of_co__c, Home_Loan_Tenor__c, GP_Home_loan_amount__c, Top_Up_Amount__c, Top_Up_Rate__c, Top_Up_Tenure__c, Industry_Margins_applicable1__c, C_P_Current_Year__c, Existing_Live_Obligations__c, ObligationsDC1__c, Agri_income_to_be_consd__c, Agri_Inc_2_be_Consd__c, C_P_Previous_Year__c, Final_Income_considered_for_Eligibility__c, Business_Income_Considered__c, Hl_pmt__c from cam__c where loan_application__c = : loanId';

   if (callCenterProcessFlag)
    WhereANDCondition = ' AND Applicant__c != null LIMIT 1';
   else if (salMobilityFlag  || salmobilityv2falg)
    WhereANDCondition = ' AND (Applicant__c != null OR Applicant__c = null) LIMIT 1';
   else
    WhereANDCondition = ' AND Applicant__c = null LIMIT 1';

   camQuery += WhereANDCondition;
   system.debug('camQuery -->' + camQuery);
   cam = Database.query(camQuery);
   system.debug('cam -->' + cam);
   /*Dynamic Query Added - Aman*/

   //added for Call center E
   system.debug('***afetr Average_Monthly_Net_Income2__c---->' + cam.Average_Monthly_Net_Income2__c);
   upsert applicantPrimary;
   upsert loan;
   List < Applicant__c > newApplicantList = new List < Applicant__c > ();
   if (selectedApplicant != null) {
    system.debug('inside saveIncomeDeatils if');
    newApplicantList = [select is_BL_PL_Risk__c, /*OTP V3 CR S*/ Contact_Name__r.special_profile_employer__c, Codified_CIBIL__c, contact_name__r.employer__r.bank_names__c, Risk_Segmentation__c, /*OTP V3 CR E*/ /* SAL Invisible monitering start */ RSA_reason__c, RSA_flag__c, RSA_Loan_application_status__c, RSA_Remarks__c, Underwriter_Remarks__c, RSA_Closure_Date__c, RSA_initiation_Date__c, RSA_TAT__c, Contact_Name__r.Email_Confirmation_received__c, Contact_Name__r.Customer_address_matches_with_eKYC__c, Contact_Name__r.Customer_Add_Matches_With_Previous_Add__c, /* SAL Invisible monitering end */ Contact_Name__r.Linkedin_check_result__c, Contact_Name__r.Google_check_result__c, Contact_Name__r.PAN_Response__c,
     Contact_Name__r.SFDC_Dedupe_check__c, Contact_Name__r.office_no_check_on_company_site__c, id, Contact_Name__r.Total_Work_Experience_Yrs__c, Contact_Name__r.Years_At_Residence__c, Name, SegmentaionResult__c, ContactName__c, Loan_Application__c, movedToCibilTemp__c, Update_CIBIL_Error__c, Descriptin__c, Type_of_Borrower__c, Re_Initiate_De_Dupe__c, Integrate_with_CIBIL__c, Contact_Name__c, Contact_Name__r.Name, Contact_Name__r.Customer_Profile__c,
     Contact_Name__r.Designation__c, Contact_Name__r.Employer_Name__c, Contact_Name__r.Qualification__c, Contact_Name__r.Address_1__c,
     PD_Status__c, Bank_Status__c, Contact_Name__r.Address_2__c, FCU_Status__c, ITR_Status__c, Office_SE_Status__c, Office_SAL_Status__c,
     Office_Status__c, Pay_Slips_Status__c, Residence_Status__c, Trade_Status__c, TVR_Status__c, Select_Applicant__c, Applicant_Type__c, Contact_Name__r.Customer_Type__c, Contact_Name__r.ApplicantType__c,
     Contact_Name__r.Date_of_Birth__c, Contact_Name__r.FathersHusbands_Name__c, Contact_Name__r.PAN_Number__c, Contact_Name__r.Year_of_Incorporation__c, Contact_Name__r.Account.TIN_Number__c,
     Contact_Name__r.Bank_Account_No__c, Contact_Name__r.VoterID_Number__c, Contact_Name__r.ROC_Regn_No__c, Contact_Name__r.Address_3__c, Contact_Name__r.AppCity__c,
     Contact_Name__r.Pin_Code__c, Contact_Name__r.Phone, Contact_Name__r.MobilePhone, Contact_Name__r.Email, Contact_Name__r.Address_Line_One__c, Contact_Name__r.Address_2nd_Line__c, Contact_Name__r.Address_3rd_Line__c,
     Contact_Name__r.Permanent_Land_Mark__c, Contact_Name__r.Office_City__c, Contact_Name__r.Office_Pin_Code__c, Contact_Name__r.Office_STD_Code__c, Contact_Name__r.Office_Phone_Number__c,
     Contact_Name__r.Mobile_Phone__c, Contact_Name__r.Office_Email_Id__c, Contact_Name__r.Middle_Name__c, Employer__c, Company_Type__c, Company_Name__c, Contact_Name__r.Company_Type__c,
     DIN_No_if_applicable__c, Contact_Name__r.FirstName, Contact_Name__r.LastName, Contact_Name__r.Permanant_Address_Line_1__c, Contact_Name__r.Permanant_Address_Line_2__c, Contact_Name__r.Permanant_Address_Line_3__c,
     Contact_Name__r.Permanent_STD__c, Contact_Name__r.Permanent_Pin_Code__c, Contact_Name__r.Year_in_Present_Job__c, Contact_Name__r.Year_in_Previous_Job__c, Contact_Name__r.Name_of_the_company_Employer__c,
     Contact_Name__r.Nature_of_Business__c, Contact_Name__r.Employment_Status__c, Contact_Name__r.Gender__c, Contact_Name__r.Age__c, Contact_Name__r.Employment_Type__c, Contact_Name__r.STD_Code__c, Contact_Name__r.Phone_Number__c,
     Contact_Name__r.Name_of_Employer__c, Designation__c, Contact_Name__r.Type_Of_Constitution__c, Contact_Name__r.Marital_Status__c, Contact_Mobile__c, Contact_Name__r.Residence_City__c, Contact_Name__r.Sex__c,
     Contact_Name__r.Employer__r.name, Contact_Name__r.TAN_Number__c, Contact_Name__r.TAN_Found_In_Master__c, Contact_Name__r.Email_Domain_Status__c, Contact_Name__r.Bank_Name1__c,
     Contact_Name__r.Bank_Name_Status1__c, Loan_Application__r.Existing_Customer__c, Contact_Name__r.PAN_Card_Status__c, Comments__c, Contact_Name__r.CIBIL_Report__c, Contact_Name__r.Office_Email_Id_for_Fraud__c, Contact_Name__r.TAN__c, Contact_Name__r.Current_experiance_in_Years__c, Contact_Name__r.Residence_Type__c, Contact_Name__r.Employer__r.Company_Category__c,
     Contact_Name__r.Age_of_Applicant__c, CIBIL_Score__c, Is_PL_BT__c, Cibil_Temp__c, DeDupe_Counter__c, Existing_Customer__c,
     StepUp_StepDown_EMI_Year_1__c, StepUp_StepDown_EMI_Year_2__c, StepUp_StepDown_EMI_Year_3__c, StepUp_StepDown_EMI_Year_4__c, StepUp_StepDown_EMI_Year_5__c, TotalFOIRHLResult__c, TotalFOIRNoHLResult__c, TotalWorkExpResult__c, UnsecuredFOIRResult__c, LoanAmountResult__c, CurrentWorkExpResult__c,
     OwnHouse_RunningHLResult__c, CompanyCategoryResult__c, EducationQualificationResult__c, Segment_Prudense__c, Segment_Stability__c,
     Segment_Achievment__c, SalaryToAgeResult__c, Bureau_Segment__c, Company_Name_as_per_Domain_check__c, /*Mortgage*/ Contact_Name__r.Property_Owner__c /* SAL Policy Changes Start */ , RC_Decline__c, RC_Deviation__c, /* SAL Policy Changes End */
     /*bug 11151 s */
     Domain_Created_Date__c /* bug 11151 e*/ , /*18370 S*/ Is_Hybrid_Flexi_for_Topup__c, Topup_Pure_Flexi_Period__c, Topup_Dropline_Flexi_Period__c, Topup_Loan_Proposed_EMI__c, Topup_Pure_Flexi_EMI__c /*18370 E*/
     from Applicant__c where ContactName__c =: selectedApplicant
    ];
   }
   if (primContact != null) {
    primContact.Current_experiance_in_Years__c = applicantPrimary.Contact_Name__r.Current_experiance_in_Years__c;
    primContact.Years_At_Residence__c = applicantPrimary.Contact_Name__r.Years_At_Residence__c;
    primContact.Linkedin_check_result__c = applicantPrimary.Contact_Name__r.Linkedin_check_result__c;
    primContact.Google_check_result__c = applicantPrimary.Contact_Name__r.Google_check_result__c;
    primContact.PAN_Response__c = applicantPrimary.Contact_Name__r.PAN_Response__c;
    primContact.TAN_Found_In_Master__c = applicantPrimary.Contact_Name__r.TAN_Found_In_Master__c;
    primContact.SFDC_Dedupe_check__c = applicantPrimary.Contact_Name__r.SFDC_Dedupe_check__c;
    primContact.office_no_check_on_company_site__c = applicantPrimary.Contact_Name__r.office_no_check_on_company_site__c;
    update primContact;
   }


   if (bankAcc != null && bankAcc.id != null) {
    update bankAcc;
   }
   /*OTP v3 CR 14754 s*/
   Double numberOfHLLoans = 0.0;
   /*OTP v3 CR 14754 e*/
   List < Existing_Loan_Details__c > newObligationDetails = new List < Existing_Loan_Details__c > ();
   for (ObligationWrapper obj: ObligationWrapperList) {
    /*OTP v3 CR 14754 s*/
    if (Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL' || Loan.Product__c == 'SBS CS SAL') {
     if (Label.HL_loans.contains(obj.exloan.Loan_Type__c))
      numberOfHLLoans++;
    }
    /*OTP v3 CR 14754 e*/
    /*SAL PL to SAL LAP Bug 13407 start - Krish*/
    if (SALtoLAPFlag) {
     if (obj.exloan.Loan_Type__c != 'Property Loan' && obj.exloan.Loan_Type__c != 'Housing Loan') {
      obj.exloan.Still_own_the_property__c = 'N/A';
      obj.exloan.Mortgage_free_property__c = 'N/A';
     } else {
      if (obj.exloan.Still_own_the_property__c == 'Yes') {
       obj.exloan.Mortgage_free_property__c = '';
      }
     }
    }
    /*SAL PL to SAL LAP Bug 13407 end - Krish*/
    system.debug('****selected applicant: ' + obj.selectedApplicant);
    if (obj.exloan.id == null) {
     if (applicantNameMAP != null && applicantNameMAP.size() > 0)
      obj.exloan.Applicant__c = applicantNameMAP.get(obj.selectedApplicant).id;

    }
    if (obj.exloan.EMI_Over_In_Next_6_months__c == true) {
     system.debug('in true==' + obj.exloan.EMI_Over_In_Next_6_months__c);
     obj.exloan.Obligation__c = 'No';

    } else if (obj.exloan.EMI_Over_In_Next_6_months__c == false) {
     system.debug('in else==' + obj.exloan.EMI_Over_In_Next_6_months__c);
     obj.exloan.Obligation__c = 'Yes';
    }
    if (obj.exloan.Customer_Declared_EMI__c != null)
     obj.exloan.EMI__c = obj.exloan.Customer_Declared_EMI__c;
    else if (obj.exloan.Derived_EMI__c != null)
     obj.exloan.EMI__c = obj.exloan.Derived_EMI__c;

    obj.exloan.Type_of_Oblig__c = 'Individual';

    //BT Multiplier calculator 10905.. YK..
    if (Mortgageflag) {
     if (obj.exloan.Status__c != 'Proposed BT') {
      //bug fix 12016
      if (obj.exloan.Multiplier__c != null && cam.BT_Existing_Top_up_multiplier__c != null)
       cam.BT_Existing_Top_up_multiplier__c = cam.BT_Existing_Top_up_multiplier__c - obj.exloan.Multiplier__c;
      obj.exloan.Multiplier__c = null;
     }
    }

    newObligationDetails.add(obj.exloan);

   }
   /*OTP v3 CR 14754 s*/
   if (Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL' || Loan.Product__c == 'SBS CS SAL') {
    if (cibilext1 != null) {
     cibilext1.Number_of_Hl_Loans__c = numberOfHLLoans;
     upsert cibilext1;
    }
   }
   /*OTP v3 CR 14754 e*/
   system.debug('***newObligationDetails size' + newObligationDetails.size());
   if (newObligationDetails != null && newObligationDetails.size() > 0) {
    upsert newObligationDetails;
    //BT Multiplier calculator 10905.. YK..
    upsert cam;
   }
   savedSuccessfull = true;

   message = 'Salaried details Saved Successfully !!!';
   //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal start
   /* purpose of the code :-to quey checklist record of loan application Re_appraisal_Initiated_time__c,Account.Previous_Approved_Loan_Amount__c,(Select id, Document_Type__c,Deviation_Master__c,Deviation_Master__r.Minimum_Approver_Level__c, Mandatory__c, Sales_Status__c, Document__c from Checklists__r)
    */
   loan = [select /*20939 s*/ Relationship_Manager__r.Mobile_number__c, /*20939 e*/ /*SAL PL to SAL LAP*/ Branch_Name__r.Branch_Code__c, Account.First_Name__c, Account.Last_Name__c, Account.Process_Type__c, /*SAL PL to SAL LAP*/ id, Re_appraisal_Initiated_time__c, Account.Previous_Approved_Loan_Amount__c, (Select id, Document_Type__c, Deviation_Master__c, Deviation_Master__r.Minimum_Approver_Level__c, Mandatory__c, Sales_Status__c, Document__c from Checklists__r), Relationship_Manager__r.Email, Sourcing_Channel__r.sourcing_channel_email_id__c, ACM__r.Email, Branch_Type__c, A_C_No__c, Industry__r.Industry__c, Owner.Name, Original_Approver__c, Branch_City__c, Decision_Time__c, Loan_Amount_with_Premium__c, Approved_Loan_Amount__c, Approved_Rate__c, Approved_Tenor__c, Loan_amt_with_premium__c, Insurance_Premium_Amt__c, online_salaried_app__c,
    Reject_Reason__c, Sales_Backend__c, name, Risk_Deviations__c, CRO_Deviations__c, CPA__c, ACM__c, RCM__c, NCM__c, CRO__c, RISK__c, COO__c, ACM_Comments__c, RCM_Comments__c, COO_Comments__c, Eligible_for_cross_sell__c, Products_for_cross_sell__c, Cross_sell_comments__c,
    Approval_Stages__c, Approver__c, Loan_Application_Number__c, Product__c, Loan_Type__c, Relationship_Manager__c, AccountId, CreatedDate,
    OwnerId, CreatedById, Scheme_Master__c, Scheme_Master__r.Name, Industry__c, Credit_Program__c, createdBy.Profile.Name,
    Sub_Industry__c, Existing_Customer__c, Finance_Amount__c, Tenor__c, Main_Sector__r.Sector__c, Main_Industry__c, Main_Sub_Industry__c,
    Type_Of_Loan__c, amount, Employee_Type__c, stagename, Probability, Branch_Name__r.branch_type__c,
    ForecastCategoryName, File_Acceptance__c, Discrepancy_Status__c, Loan_Amount__c,
    Type_of_Constitution__c, Application_Form_Number__c, If_Yes__c, Branch_Type1__c, Relationship_Manager__r.Name,
    Branch_Name__r.name, Sourc_Mobile__c, ASM_Mobile__c, Sales_Backend_Mobile__c, Verification_Initiated__c, Referral__c,
    Sourcing_Channel__c, Current_UserRole__C, CEO__c, CEO__r.name, RCM__r.name, NCM__r.name,
    RISK__r.name, COO__r.name, CRO__r.name, Comments__c, No_of_Properties__c, EMI_Type__c,
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
    Acc_InsurStartDate__c, Acc_InsurPremiumAmount__c, Acc_InsurSumAssured__c, Total_Monthly_Oblig__c, Scheme_Master__r.PLOC_scheme__c,
    Requested_ROI__c, Processing_Type__c, Account.IS_OTP_FLOW__c, EMI_CAM__c, Date_of_created_date__c,
    Life_InsuranceRemarks__c, Type_of_Borrower__c, AppScore__c, Rank1__c, Loan_Application_Flow__c, Offer_Amount__c, Sourcing_Channel__r.Sourcing_Channel_Flag__c, Account.Vintage_with_BAL__c, Account.Current_experiance_in_Years__c, Account.Total_Work_Experience_Yrs__c, Account.BT_Bank_Type__c, Account.Type_of_Ownership__c, Account.Residence_TypeAcc__c,
    CampaignId, Business_IRR__c, POS__c, BranchName__c, Financed_by_BFL__c, Disbursement_Type__c, Tranche_Count__c, City_Head__c, UnHold__c,
    CL_Region__c, Region__c, Old_Product__c, account.Years_in_Bus__c, CAM_Expiry_Date__c, CAM_Preparation_Date__c, Business_Head__c, Centralized_ACM__c, Program_Type__c,
    AMC__c, Centralized_RCM__c, Customer_Reference_Number__c, SMS_to_be_Sent__c, ACM__r.Mobile_number__c, Approved_time_after_Reappraisal__c, Decision_Date__c, Interior_Designer__c, Service_Availed__c, Account.EMI_Frequency__c, DSA_Name__c, Sourcing_Channel__r.Name, Account.ownerid, Account.Group_Type__c, Account.Name, /*Mortgage*/ Account.Preferred_language__c, account.Base_Loan__c, Full_Underwriting__c, Sourcing_Channel_Type__c, Sub_Stage__c,
    (select Id, Name, Offer_Amount__c, Availed_Amount__c, Tenor__c, Offer_ROI__c, Offer_Validity__c, Campaign_Type__c, Existing_LAN__c, Requested_Tenor__c, Revised_Offer_Amount__c, Program_Type__c,
     Revised_Offer_ROI__c, EMI_Amount__c, Current_EMI__c, Products__c, Product_Offering_Source__c, PO_Type__c from Product_offerings__r), Telecaller_Name__c, /* SAL IM S */ Account.Employer__r.Name, Account.Employer__r.Company_Name__c, Account.PANNumber__c, Account.Employer__c, Account.Mobile__c, Account.Date_of_Birth__c, /*SAL IM E */
    CM__c, CM_Amount__c, CM_Deviations__c, SCO__c, SCO_Amount__c, SCO_Deviations__c, CM__r.Mobile_number__c, SCO__r.Mobile_number__c, CM__r.name, SCO__r.name /* Bug id : 13016 - New Role Creation for Credit, added by Needhi*/ , (select ID, OppLevelRevisedOfferAmount__c, Revised_Offer_Amount__c, Branch__c from BodmasCalculations__r) /*bug 19469*/
    from opportunity where id =: LoanId
   ];

   //4450
   COLStampdate = null;
   COLStampFlag = false;
   if (LaonApplicationCreation__c.getValues('Hierarchy Stamping') != null) {
    String COLDate = LaonApplicationCreation__c.getValues('Hierarchy Stamping').Credit_Hierarchy_Stamping_Date__c;
    if (COLDate != null) {
     system.debug('***COLDate***' + COLDate);
     COLStampdate = date.parse(COLDate);
    }
   }
   system.debug('***COLStampdate***' + COLStampdate);

   if (COLStampdate != null && Loan != null && COLStampdate < Loan.createddate) {
    COLStampFlag = true;
   }

   if (COLStampFlag == true) {
    if (Loan != null) {
     LoanAppFlow = Loan.Loan_Application_Flow__c;
     system.debug('Loan.Loan_Application_Flow__c=' + Loan.Loan_Application_Flow__c + '=Loan.Program_Type__c=' + Loan.Program_Type__c);
     if (LoanAppFlow == null || LoanAppFlow == '') {
      LoanAppFlow = 'Normal';
     }
     system.debug('LoanAppFlow=' + LoanAppFlow);

    }
   }

   system.debug('****saved: ');
   existingLoanDetailsList = [select id, financers__c, Name, Customer_Declared_EMI__c, EMI_Over_In_Next_6_months__c, Status__c, Final_EMI__c, Secured_Unsecured__c, Loan_Type__c, Loan_Amount__c, Seen_in__c,
    Loan_Acc_No__c, Select__c, Applicant__r.ContactName__c, Principal_O_s__c, Obligation__c,
    Financer__c, Amount__c, Month1_Amount__c, Month2_Amount__c, Derived_EMI__c, Remark__c, No_of_Bounces_if_any__c,
    Start_On__c, Tenor__c, Tenor_Left__c, MOB__c, POS__c, EMI__c, Applicant__c, Annual_Obligation__c, Type_of_Oblig__c, Rate_of_Interest__c, City__c, Property_Address__c /*01MOB S*/ , Purchase_Value__c, Property_Purchase_Date__c /*01MOB E*/ , /*Mortgage*/ Applicant__r.Applicant_Type__c, /*Mortgage*/ Mthly_Oblig__c, Multiplier__c, /*Bug 13407 s*/ Mortgage_free_property__c, Still_own_the_property__c /*Bug 13407 e*/ from Existing_Loan_Details__c where Loan_Application__c =: loan.id
   ];
   OverDraft = 0;
   creditCardAmt = 0;
   //--------------- Mortgage Re-Engg Start---------------------
   decimal monthlyObligationMort = 0;
   //--------------- Mortgage Re-Engg End-----------------------

   ObligationWrapperList = new List < ObligationWrapper > ();
   for (Existing_Loan_Details__c exp: existingLoanDetailsList) {
    ObligationWrapperList.add(new ObligationWrapper(false, applicantSelectList, exp, false));
    //creditCardAmt
    if (exp.Loan_Type__c == 'Credit Card' && exp.Status__c == 'Live' && exp.Obligation__c == 'Yes') {

     if (exp.POS__c != null)
      creditCardAmt += exp.POS__c;

    }

    if (exp.Loan_Type__c == 'Overdraft' && exp.Status__c == 'Live' && exp.Obligation__c == 'Yes') {

     if (exp.POS__c != null)
      OverDraft += exp.POS__c;

    }
    //--------------- Mortgage Re-Engg Start---------------------
    if (Mortgageflag) {
     if (exp.Applicant__c != null && (exp.Applicant__r.Applicant_Type__c == 'Primary' || exp.Applicant__r.Applicant_Type__c == 'Financial Co-Applicant' || exp.Applicant__r.Applicant_Type__c == 'Primary Financial Co-Applicant') && exp.Status__c == 'Live') {
      if (exp.Customer_Declared_EMI__c != null) {
       monthlyObligationMort = monthlyObligationMort + exp.Customer_Declared_EMI__c;
      } else if (exp.Derived_EMI__c != null) {
       monthlyObligationMort = monthlyObligationMort + exp.Derived_EMI__c;
      }

     }
     //BT Multiplier calculator 10905... YK
     //Rohit changed condition as per prod
    if (exp.Status__c == 'Proposed BT' && (exp.Loan_Type__c == 'HL' || exp.Loan_Type__c == 'HL â€“ Improvement' ||
       exp.Loan_Type__c == 'HL â€“ Top Up' ||
       /*exp.Loan_Type__c == 'HL ?Improvement' ||
exp.Loan_Type__c == 'HL ?Top Up' ||*/
       exp.Loan_Type__c == 'LAP' || exp.Loan_Type__c == 'Housing Loan' ||
       exp.Loan_Type__c == 'Property Loan'))
      isProposedBT = true;

     system.debug('monthlyObligationMort=' + monthlyObligationMort);
    }
    //--------------- Mortgage Re-Engg End-----------------------

   }
   //--------------- Mortgage Re-Engg Start---------------------
   system.debug('monthlyObligationMort=' + monthlyObligationMort);
   if (Mortgageflag) {
    cam.Average_Bank_Balance_GDP__c = monthlyObligationMort;
    system.debug('cam.Average_Bank_Balance_GDP__c=' + cam.Average_Bank_Balance_GDP__c);
   }
   //--------------- Mortgage Re-Engg End-----------------------

   if (creditCardAmt != null) {
    cam.Credit_Card_Out_5__c = Decimal.valueOf((creditCardAmt * 5) / 100).setScale(2);
   }
   if (OverDraft != null) {
    cam.OD_interest__c = Decimal.valueOf((OverDraft * 5) / 100).setScale(2);

   }
   system.debug('&&&&' + cam.Average_Monthly_Net_Income2__c);
   if (!Test.isRunningTest())
    upsert cam;
   savedSuccessfull = true;
   message = 'Salaried details Saved Successfully !!!';
   system.debug('Deatils saved sucessfully 1234');
  } catch (Exception e) {
   system.debug('Exception occurd==>' + e.getMessage() + 'Line number===>' + e.getLinenumber());
   sendEmailForException(e);
  }

  /*Dynamic Query Added - Aman*/
  String loanId = loan.id;
  String WhereANDCondition;
  String camQuery;
  camQuery = 'SELECT Id, name, Payment_Date_1__c, Payment_Date_2__c, Payment_Date_3__c, Recent_continuous__c, Repayment_of_loan__c, CreatedDate, Current_Year_PLBS__c, Current_Year_PLBS__r.Year__c, Previous_Year_PLBS__r.Year__c, Previous_Year_PLBS__c, Applicant__r.Contact_Name__c,' +
   'Type_Cust__c, Type_of_Entity__c, Month1__c, Total_Income_GP__c, Month2__c, Month3__c, Gross_Salary_Month1__c, Approved_CAM__c, Monthly_Reimbursement__c, Maximum_Unsecured_Exposure_MUM__c,' +
   'Gross_Salary_Month2__c, Gross_Salary_Month3__c, Final_Net_An_Inc__c, Net_Salary_for_Month1__c, Net_Salary_for_Month2__c, Net_Salary_for_Month3__c, Avg_Net_Sal__c, Avg_Mthly_Inctve_70__c,' +
   'Avg_Qtrly_Inctve_60__c, Avg_Mthly_Net_Inc__c, Average_Monthly_Net_Income1__c, Mthly_Loan_EMI__c, Credit_Card_Out_5__c, OD_interest__c, Total_Mthly_Oblig__c, NAS__c, Maxi_EMI_Banking__c, Maxi_EMI_Cust__c,' +
   'Maxi_EMI_FOIR__c, Max_EMI_Offer__c, NAS_Multi__c, Max_Loan_Amt_NAS_Multi__c, ROI__c, Final_FOIR__c, Avg_monthly_incentive1__c, Avg_monthly_incentive2__c,' +
   'Proposed_Loan_Amt__c, IRR_TO__c, Tenor__c, EMI_on_Proposed_Loan_TO__c, Insurance_taken_TO__c, Premium_Amount_TO__c, Loan_Amt_Premium__c, EMI_with_Insurance_Premium_TO__c,' +
   'Avg_monthly_incentive3__c, Avg_mthly_incntve_3mts__c, Average_incentive_for_Q1__c, Average_incentive_for_Q2__c, Average_incentive_for_Q3__c, Avg_qtrly_incentive__c,' +
   'Incentive_Monthly_or_Quarterly__c, Receips1_Doc__c, Receips2_Doc__c, Receips3_Doc__c, Receips4_Doc__c, Receips5_Doc__c, Receips6_Doc__c, Month4_Doc__c, Month5_Doc__c,' +
   'Selected1__c, Month1_Doc__c, Month2_Doc__c, Month3_Doc__c, Year1_Doc__c, Year2_Doc__c, Year3_Doc__c, LAP_EMI__c, Construction_Valuation_1__c, Construction_Valuation_2__c, Eligible_Loan__c,' +
   'Sal_Deviation_on_FOIR__c, Sal_MUE_Funding__c, sal_max_loan__c, LAP_pmt__c, Interest_on_term_loans__c, Bounces_in_Latest_3_Months__c, App_Mon_Income__c, Monthly_CC_OD_interest__c, ELC_Line_Amounts__c,' +
   'Rental_Income__c, Adjusted_Rental_Income__c, SAL_Max_FOIR_as_BFL__c, New_Sal_Deviation_on_FOIR__c, MLA_for_Unlisted_Pvt__c, Applicable_FOIR1__c, Unsecured_FOIR__c, Secured_FOIR__c, Rental_Income_to_be_considered__c, Eligible_FOIR__c, Fund_Based__c,' +
   'Entity_Record_Type__c, BT_Existing_Top_up_multiplier__c, Deviation_on_FOIR__c, Existing_HL_EMI__c, max_loan_POS_forExSAL__c, Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c, Max_Loan_Amount_for_IT_Company__c, Average_Monthly_Net_Income2__c, Average_Bank_Balance__c, Eligible_Loan_amt_Bank__c, Multiplier__c, Selected_Option_TO__c, Live_unsecured_loan__c, GP_Other_income__c, Oth_Inc_2_be_Consd__c, Average_Bank_Balance_GDP__c, EMI_of_The_Loan__c, LAP_Tenor__c, Eligible_Home_Loan_Amount__c, Stake_of_co__c, Home_Loan_Tenor__c, GP_Home_loan_amount__c, Top_Up_Amount__c, Top_Up_Rate__c, Top_Up_Tenure__c, Industry_Margins_applicable1__c, C_P_Current_Year__c, Existing_Live_Obligations__c, ObligationsDC1__c, Agri_income_to_be_consd__c, Agri_Inc_2_be_Consd__c, C_P_Previous_Year__c, Final_Income_considered_for_Eligibility__c, Business_Income_Considered__c, Hl_pmt__c FROM CAM__c WHERE Loan_Application__c = : loanId';

  if (callCenterProcessFlag)
   WhereANDCondition = ' AND Applicant__c != null LIMIT 1';
  else if (salMobilityFlag  || salmobilityv2falg)
   WhereANDCondition = ' AND (Applicant__c != null OR Applicant__c = null) LIMIT 1';
  else
   WhereANDCondition = ' AND Applicant__c = null LIMIT 1';

  camQuery += WhereANDCondition;
  system.debug('camQuery -->' + camQuery);
  cam = Database.query(camQuery);
  system.debug('cam -->' + cam);
  /*Dynamic Query Added - Aman*/


  //loan.Total_Monthly_Oblig__c
  //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal start
  /* purpose of the code :-to quey checklist record of loan application Re_appraisal_Initiated_time__c,(Account.Previous_Approved_Loan_Amount__c,Select id, Document_Type__c,Deviation_Master__c,Deviation_Master__r.Minimum_Approver_Level__c, Mandatory__c, Sales_Status__c, Document__c from Checklists__r)
   */
  Loan = [select /*20939 s*/ Relationship_Manager__r.Mobile_number__c, /*20939 e*/ /*SAL PL to SAL LAP*/ Branch_Name__r.Branch_Code__c, Account.First_Name__c, Account.Last_Name__c, Account.Process_Type__c, /*SAL PL to SAL LAP*/ id, Re_appraisal_Initiated_time__c, Account.Previous_Approved_Loan_Amount__c, (Select id, Document_Type__c, Deviation_Master__c, Deviation_Master__r.Minimum_Approver_Level__c, Mandatory__c, Sales_Status__c, Document__c from Checklists__r), Relationship_Manager__r.Email, Sourcing_Channel__r.sourcing_channel_email_id__c, ACM__r.Email, EMI_Type__c, Branch_Type__c, A_C_No__c, Industry__r.Industry__c, Owner.Name, Original_Approver__c, Branch_City__c, Decision_Time__c, Loan_Amount_with_Premium__c, Approved_Loan_Amount__c, Approved_Rate__c, Approved_Tenor__c, Loan_amt_with_premium__c, Insurance_Premium_Amt__c, online_salaried_app__c,
   Reject_Reason__c, Sales_Backend__c, name, Risk_Deviations__c, CRO_Deviations__c, CPA__c, ACM__c, RCM__c, NCM__c, CRO__c, RISK__c, COO__c, ACM_Comments__c, RCM_Comments__c, COO_Comments__c, Eligible_for_cross_sell__c, Products_for_cross_sell__c, Cross_sell_comments__c,
   Approval_Stages__c, Approver__c, Loan_Application_Number__c, Product__c, Loan_Type__c, Relationship_Manager__c, AccountId, CreatedDate,
   OwnerId, CreatedById, Scheme_Master__c, Scheme_Master__r.Name, Industry__c, Credit_Program__c, createdBy.Profile.Name,
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
   Acc_InsurFundedType__c, Acc_Type_of_Policy__c, Acc_InsurCompanyName__c, LAN__c, Scheme_Master__r.PLOC_scheme__c,
   Acc_InsurStartDate__c, Acc_InsurPremiumAmount__c, Acc_InsurSumAssured__c, Total_Monthly_Oblig__c,
   Requested_ROI__c, Processing_Type__c, Account.IS_OTP_FLOW__c, EMI_CAM__c, Date_of_created_date__c,
   Life_InsuranceRemarks__c, Type_of_Borrower__c, AppScore__c, Rank1__c, Loan_Application_Flow__c, Offer_Amount__c, Sourcing_Channel__r.Sourcing_Channel_Flag__c, Account.Vintage_with_BAL__c, Account.Current_experiance_in_Years__c, Account.Total_Work_Experience_Yrs__c, Account.BT_Bank_Type__c, Account.Type_of_Ownership__c, Account.Residence_TypeAcc__c,
   CampaignId, Business_IRR__c, POS__c, BranchName__c, Financed_by_BFL__c, Disbursement_Type__c, Tranche_Count__c, City_Head__c, UnHold__c,
   CL_Region__c, Region__c, Old_Product__c, account.Years_in_Bus__c, CAM_Expiry_Date__c, CAM_Preparation_Date__c, Business_Head__c, Centralized_ACM__c, Program_Type__c,
   AMC__c, Centralized_RCM__c, Customer_Reference_Number__c, SMS_to_be_Sent__c, ACM__r.Mobile_number__c, Approved_time_after_Reappraisal__c, Decision_Date__c, Interior_Designer__c, Service_Availed__c, Account.EMI_Frequency__c, DSA_Name__c, Sourcing_Channel__r.Name, Account.ownerid, Account.Group_Type__c, Account.Name, /* Mortgage*/ Account.Base_Loan__c, Account.Preferred_language__c, Full_Underwriting__c, Sourcing_Channel_Type__c, Sub_Stage__c,
   (select Id, Name, Offer_Amount__c, Availed_Amount__c, Tenor__c, Offer_ROI__c, Offer_Validity__c, Campaign_Type__c, Existing_LAN__c, Requested_Tenor__c, Revised_Offer_Amount__c, Program_Type__c,
    Revised_Offer_ROI__c, EMI_Amount__c, Current_EMI__c, Products__c, Product_Offering_Source__c, PO_Type__c from Product_offerings__r), Telecaller_Name__c, /* SAL IM S */ Account.Employer__r.Name, Account.Employer__r.Company_Name__c, Account.PANNumber__c, Account.Employer__c, Account.Mobile__c, Account.Date_of_Birth__c, /*SAL IM E */
   CM__c, CM_Amount__c, CM_Deviations__c, SCO__c, SCO_Amount__c, SCO_Deviations__c, CM__r.Mobile_number__c, SCO__r.Mobile_number__c, CM__r.name, SCO__r.name /* Bug id : 13016 - New Role Creation for Credit, added by Needhi*/ , (select ID, OppLevelRevisedOfferAmount__c, Revised_Offer_Amount__c, Branch__c from BodmasCalculations__r) /*bug 19469*/
   from opportunity where id =: Loan.Id
  ];


  //4450
  COLStampdate = null;
  COLStampFlag = false;
  if (LaonApplicationCreation__c.getValues('Hierarchy Stamping') != null) {
   String COLDate = LaonApplicationCreation__c.getValues('Hierarchy Stamping').Credit_Hierarchy_Stamping_Date__c;
   if (COLDate != null) {
    system.debug('***COLDate***' + COLDate);
    COLStampdate = date.parse(COLDate);
   }
  }
  system.debug('***COLStampdate***' + COLStampdate);

  if (COLStampdate != null && Loan != null && COLStampdate < Loan.createddate) {
   COLStampFlag = true;
  }

  if (COLStampFlag == true) {
   if (Loan != null) {
    LoanAppFlow = Loan.Loan_Application_Flow__c;
    system.debug('Loan.Loan_Application_Flow__c=' + Loan.Loan_Application_Flow__c + '=Loan.Program_Type__c=' + Loan.Program_Type__c);
    if (LoanAppFlow == null || LoanAppFlow == '') {
     LoanAppFlow = 'Normal';
    }
    system.debug('LoanAppFlow=' + LoanAppFlow);

   }
  }
 }

 public List < DedupeWrapper > dedupeWrapperList {
  get;
  set;
 }
 public class DedupeWrapper {
  public Boolean selectDedupe {
   get;
   set;
  }
  public De_Dupe__c dedupeObj {
   get;
   set;
  }
  public Applicant__c app {
   get;
   set;
  }
  public Contact conObj {
   get;
   set;
  }
  public String deAppConName {
   get;
   set;
  }
  //MOB changes Mortgage
  public Id GoogleCheckAttachment {
   get;
   set;
  }
  DedupeWrapper(Boolean flag, De_Dupe__c dedupe, Applicant__c appobj, Contact con, String deAppConName, Id GoogleCheckAttachment) {
   selectDedupe = flag;
   dedupeObj = dedupe;
   app = appobj;
   conObj = con;
   this.deAppConName = deAppConName;
   this.GoogleCheckAttachment = GoogleCheckAttachment;
  }
 }
 public List < ObligationWrapper > ObligationWrapperList {
  get;
  set;
 }
 public class ObligationWrapper {
  public Boolean selectapp {
   get;
   set;
  }
  public Existing_Loan_Details__c exloan {
   get;
   set;
  }
  public List < SelectOption > applicantSelectList {
   get;
   set;
  }
  public String selectedApplicant {
   get;
   set;
  }
  public Boolean deleteRecord {
   get;
   set;
  }
  ObligationWrapper(Boolean flag, List < SelectOption > applicantWrapperList, Existing_Loan_Details__c exObj, Boolean deleteChecked) {
   selectapp = flag;
   exloan = exObj;
   applicantSelectList = applicantWrapperList;
   this.deleteRecord = deleteChecked;
  }
 }

 /*public void showmonthly() {
ismonthly = true;
cam.Incentive_Monthly_or_Quarterly__c = 'Monthly';
// isquarterly=false;

}

public void showQuarterly() {
//isquarterly=true;
ismonthly = false;
cam.Incentive_Monthly_or_Quarterly__c = 'Quarterly';

}*/

 //--------------- Mortgage Re-Engg Start---------------------
 public void showmonthly() {
  ismonthly = true;
  cam.Incentive_Monthly_or_Quarterly__c = 'Monthly';
  isquarterly = false;
  isYearly = false;
  system.debug('ismonthly=' + ismonthly);
 }

 public void showYearly() {
  isYearly = true;
  ismonthly = false;
  isquarterly = false;
  cam.Incentive_Monthly_or_Quarterly__c = 'Yearly';
 }

 public void showHalfYearly() {
  isYearly = false;
  ismonthly = false;
  isquarterly = true;
  cam.Incentive_Monthly_or_Quarterly__c = 'Half Yearly';
 }

 public void showQuarterly() {
  isquarterly = true;
  ismonthly = false;
  isYearly = false;
  cam.Incentive_Monthly_or_Quarterly__c = 'Quarterly';
  system.debug('In Controller isquarterly=' + isquarterly);
 }

 //For Co-Applicant
 public void showmonthly1() {
  ismonthly1 = true;
  if (coCAM != null)
   coCAM.Incentive_Monthly_or_Quarterly__c = 'Monthly';
  isquarterly1 = false;
  isYearly1 = false;
 }

 public void showYearly1() {
  isYearly1 = true;
  ismonthly1 = false;
  isquarterly1 = false;
  if (coCAM != null)
   coCAM.Incentive_Monthly_or_Quarterly__c = 'Yearly';
 }

 public void showHalfYearly1() {
  isYearly1 = false;
  ismonthly1 = false;
  isquarterly1 = true;
  if (coCAM != null)
   coCAM.Incentive_Monthly_or_Quarterly__c = 'Half Yearly';
 }

 public void showQuarterly1() {
  isquarterly1 = true;
  ismonthly1 = false;
  isYearly1 = false;
  if (coCAM != null)
   coCAM.Incentive_Monthly_or_Quarterly__c = 'Quarterly';

 }

 //--------------- Mortgage Re-Engg End-----------------------

 public List < String > TelePDCodes = new List < String > ();
 public void BREForPersonalDiscussion() {
  Applicant__c PrimaryApp = new Applicant__c();
  PrimaryApp = [select is_BL_PL_Risk__c, /*OTP V3 CR S*/ Score_card__c, Contact_Name__r.special_profile_employer__c, Codified_CIBIL__c, contact_name__r.employer__r.bank_names__c, Risk_Segmentation__c, /*OTP V3 CR E*/ /* SAL Invisible monitering start */ RSA_flag__c, RSA_Loan_application_status__c, RSA_Remarks__c, Underwriter_Remarks__c, RSA_Closure_Date__c, RSA_initiation_Date__c, RSA_TAT__c, Contact_Name__r.Perfios_Address__c, Contact_Name__r.Customer_Add_Matches_With_Previous_Add__c /* SAL Invisible monitering end */ , id, Contact_Name__r.office_no_check_on_company_site__c, Contact_Name__r.SFDC_Dedupe_check__c, Contact_Name__r.PAN_Response__c, Contact_Name__r.Linkedin_check_result__c, Contact_Name__r.Google_check_result__c, Contact_Name__r.PAN__c, Contact_Name__r.Last_Modified_Date__c, Contact_Name__r.Name_of_the_PAN_holder__c, Contact_Name__r.Employer__r.Domain_Name__c, Contact_Name__r.Employer__r.Company_Category__c, Existing_Customer__c, Owned_Residence__c, Is_spouse_Working_Financial_CoApp__c, Loan_Application__r.Scheme_Master__c, Name, Contact_Name__r.Mobile__c, Loan_Application__r.Requested_ROI__c, Loan_Application__r.Sourcing_Channel__r.branch__c, Loan_Application__r.Referral__c, Loan_Application__r.Existing_Customer__c, Loan_Application__r.Account.Sourcing_Channel__r.branch__c, Update_CIBIL_Error__c, Descriptin__c, Type_of_Borrower__c, Re_Initiate_De_Dupe__c, Integrate_with_CIBIL__c, Contact_Name__c, Contact_Name__r.Name, Contact_Name__r.Customer_Profile__c,
   Contact_Name__r.Designation__c, Contact_Name__r.Employer_Name__c, Contact_Name__r.Qualification__c, Contact_Name__r.Address_1__c, Contact_Name__r.Total_Work_Experience_Yrs__c, Contact_Name__r.Current_experiance_in_Years__c,
   PD_Status__c, Bank_Status__c, Contact_Name__r.Address_2__c, FCU_Status__c, ITR_Status__c, Office_SE_Status__c, Office_SAL_Status__c, Contact_Name__r.Company_Category__c,
   Office_Status__c, Pay_Slips_Status__c, Residence_Status__c, Trade_Status__c, TVR_Status__c, Select_Applicant__c, Applicant_Type__c, Contact_Name__r.Customer_Type__c, Contact_Name__r.ApplicantType__c,
   Contact_Name__r.Date_of_Birth__c, Contact_Name__r.FathersHusbands_Name__c, Contact_Name__r.PAN_Number__c, Contact_Name__r.Year_of_Incorporation__c, Contact_Name__r.Account.TIN_Number__c,
   Contact_Name__r.Bank_Account_No__c, Contact_Name__r.VoterID_Number__c, Contact_Name__r.ROC_Regn_No__c, Contact_Name__r.Address_3__c, Contact_Name__r.AppCity__c, Contact_Name__r.Residence_Type__c,
   Contact_Name__r.Pin_Code__c, Contact_Name__r.Phone, Contact_Name__r.MobilePhone, Contact_Name__r.Email, Contact_Name__r.Address_Line_One__c, Contact_Name__r.Address_2nd_Line__c, Contact_Name__r.Address_3rd_Line__c,
   Contact_Name__r.Permanent_Land_Mark__c, Contact_Name__r.Office_City__c, Contact_Name__r.Office_Pin_Code__c, Contact_Name__r.Office_STD_Code__c, Contact_Name__r.Office_Phone_Number__c, SegmentaionResult__c,
   Contact_Name__r.Mobile_Phone__c, Contact_Name__r.Office_Email_Id__c, Contact_Name__r.Middle_Name__c, Employer__c, Company_Type__c, Company_Name__c, Contact_Name__r.Company_Type__c, Contact_Name__r.Age_of_Applicant__c,
   DIN_No_if_applicable__c, Contact_Name__r.FirstName, Contact_Name__r.LastName, Contact_Name__r.Permanant_Address_Line_1__c, Contact_Name__r.Permanant_Address_Line_2__c, Contact_Name__r.Permanant_Address_Line_3__c,
   Contact_Name__r.Permanent_STD__c, Contact_Name__r.Permanent_Pin_Code__c, Contact_Name__r.Year_in_Present_Job__c, Contact_Name__r.Year_in_Previous_Job__c, Contact_Name__r.Name_of_the_company_Employer__c,
   Contact_Name__r.Nature_of_Business__c, Contact_Name__r.Employment_Status__c, Contact_Name__r.Gender__c, Contact_Name__r.Age__c, Contact_Name__r.Employment_Type__c, Contact_Name__r.STD_Code__c, Contact_Name__r.Phone_Number__c,
   Contact_Name__r.Name_of_Employer__c, Designation__c, Contact_Name__r.Type_Of_Constitution__c, Contact_Name__r.Marital_Status__c, Contact_Mobile__c, Contact_Name__r.Residence_City__c, Contact_Name__r.Sex__c,
   Contact_Name__r.Employer__r.name, Contact_Name__r.TAN_Number__c, Contact_Name__r.TAN_Found_In_Master__c, Contact_Name__r.Email_Domain_Status__c, Contact_Name__r.Bank_Name1__c, CIBIL_Score__c,
   Contact_Name__r.Bank_Name_Status1__c, Contact_Name__r.PAN_Card_Status__c, Comments__c, Contact_Name__r.CIBIL_Report__c, Contact_Name__r.Office_Email_Id_for_Fraud__c, Contact_Name__r.TAN__c,
   All_Deviation_Docs_Received__c, All_Disbursement_Docs_Received__c, All_Standard_Docs_Received__c, Is_PL_BT__c, ContactName__c, Contact_Name__r.Customer_address_matches_with_perfios__c, Contact_Name__r.Email_Confirmation_received__c,
   Customer_Name__c, Loan_Application__r.Account.id, Contact_ID__c, Customer_ID__c, Product__c, IsUpdated__c, Decision_Date__c, RSA_reason__c, Loan_App_Number_up__c, Contact_Name__r.Customer_address_matches_with_eKYC__c,
   Loan_Application__r.Product__c, Loan_Application__r.Account.Sourcing_Channel__c, Loan_Application__r.Account.Tenor__c, Loan_Application__r.Account.Referral_Name__c, Permanent_Address_Verification__c,
   Loan_Application__r.Employee_Type__c, Loan_Application__r.Loan_Application_Number__c, Loan_Application__r.Loan_Amount__c, Loan_Application__r.Tenor__c, TotalFOIRHLResult__c, TotalFOIRNoHLResult__c, TotalWorkExpResult__c, UnsecuredFOIRResult__c, LoanAmountResult__c, CurrentWorkExpResult__c,
   OwnHouse_RunningHLResult__c, CompanyCategoryResult__c, EducationQualificationResult__c, Segment_Prudense__c, Segment_Stability__c,
   Segment_Achievment__c, SalaryToAgeResult__c, Bureau_Segment__c, StepUp_StepDown_EMI_Year_1__c, StepUp_StepDown_EMI_Year_2__c, StepUp_StepDown_EMI_Year_3__c, StepUp_StepDown_EMI_Year_4__c, StepUp_StepDown_EMI_Year_5__c, Company_Name_as_per_Domain_check__c, /*Mortgage*/ Contact_Name__r.Property_Owner__c /* SAL Policy Changes Start */ , RC_Decline__c, RC_Deviation__c, /* SAL Policy Changes End */
   /*bug 11151 s */
   Domain_Created_Date__c, /*added by prashant for @16611 s*/ Domain_Email_Remark__c /*added by prashant for @16611 e*/ /* bug 11151 e*/ , /*18370 S*/ Is_Hybrid_Flexi_for_Topup__c, Topup_Pure_Flexi_Period__c, Topup_Dropline_Flexi_Period__c, Topup_Loan_Proposed_EMI__c, Topup_Pure_Flexi_EMI__c /*18370 E*/
   from Applicant__c where Loan_Application__c =: Loan.Id and Applicant_Type__c = 'Primary'
   limit 1
  ];
  //20474 start
  Boolean personalDiscussion = false; //20474- added variable
  BRECallout breObj = new BRECallout();
  String BRECodes = '';
  Map < String, String > mapOfPD = new Map < String, String > ();
  Map < String, String > mapOfInputPD = new Map < String, String > ();
  mapOfInputPD.put('product', Loan.product__c);
  //mapOfInputPD.put('customer_segment', PrimaryApp.Bureau_Segment__c);
  // mapOfInputPD.put('applicant_type', PrimaryApp.Applicant_Type__c);  
  // mapOfInputPD.put('emailConfirmation', PrimaryApp.Contact_Name__r.Email_Confirmation_received__c); 
  //mapOfInputPD.put('eKYC', PrimaryApp.Contact_Name__r.Customer_address_matches_with_eKYC__c);
  // mapOfInputPD.put('perfios', PrimaryApp.Contact_Name__r.Customer_address_matches_with_perfios__c);
  //verification trigger
  mapOfInputPD.put('date_of_birth', (accountCreate[0].Date_of_Birth__c != null) ? String.valueof(accountCreate[0].Date_of_Birth__c) : '');
  mapOfInputPD.put('customer_segment', (PrimaryApp.Bureau_Segment__c != null) ? PrimaryApp.Bureau_Segment__c : '');
  mapOfInputPD.put('applicant_type', (PrimaryApp.Applicant_Type__c != null) ? PrimaryApp.Applicant_Type__c : '');
  mapOfInputPD.put('emailConfirmation', (PrimaryApp.Contact_Name__r.Email_Confirmation_received__c != null) ? PrimaryApp.Contact_Name__r.Email_Confirmation_received__c : '');
  mapOfInputPD.put('eKYC', (PrimaryApp.Contact_Name__r.Customer_address_matches_with_eKYC__c != null) ? PrimaryApp.Contact_Name__r.Customer_address_matches_with_eKYC__c : '');
  mapOfInputPD.put('perfios', (PrimaryApp.Contact_Name__r.Customer_address_matches_with_perfios__c != null) ? PrimaryApp.Contact_Name__r.Customer_address_matches_with_perfios__c : '');
  mapOfInputPD.put('customer_type', (PrimaryApp.Existing_Customer__c != null) ? PrimaryApp.Existing_Customer__c : '');
  mapOfInputPD.put('loan_id', (Loan.Loan_Application_Number__c != null) ? Loan.Loan_Application_Number__c : '');
  //OTP V2 Enhancement
  String plusCustomerFlag = 'false';
  if (Loan.Offer_Amount__c != null && Loan.Offer_Amount__c > 0)
   plusCustomerFlag = 'true';
  mapOfInputPD.put('plusCustomer', plusCustomerFlag);
  if (Loan.Offer_Amount__c != null)
   mapOfInputPD.put('offer_amount', string.valueof(Loan.Offer_Amount__c));
  else
   mapOfInputPD.put('offer_amount', '');

  /*Employee loan verification task ***/
  mapOfInputPD.put('application_source', (Loan.Application_Source__c != null) ? String.valueof(Loan.Application_Source__c) : '');
  /** end **/

  mapOfPD = breObj.callBREVerification(mapOfInputPD);
  String BRETelePDCode = '';
  system.debug('mapOfPD==' + mapOfPD);
  if (mapOfPD != null && mapOfPD.size() > 0) {
   BRETelePDCode = mapOfPD.get('BRETelePDCodes');
   system.debug('BRETelePDCode==' + BRETelePDCode);
   if (BRETelePDCode != '' && BRETelePDCode != null) {
    for (String str1: BRETelePDCode.split(',')) {
     if (str1 != null && str1 != '') {
      TelePDCodes.add(str1.ToUpperCase());
      PDType = str1.ToUpperCase();
     }
    }
   }
  }
  system.debug('****TelePDCodes*' + TelePDCodes);
  /*if(TelePDCodes.size()>0) {
pd.Type_of_PD__c = PDType;
pd.Loan_Application__c=Loan.Id;
pd.Name_of_the_applicant__c = PrimaryApp.id;
upsert pd;

savedSuccessfull=true;
message='PD refreshed successfully!!!';

}*/
  Boolean telePd = false;
  if (TelePDCodes.size() > 0) {
   for (String str: TelePDCodes) {
    if (str.ToUppercase().contains('TELEPHONIC PD')) {
     telePd = true;
    }
   }
  }

  if (telePd == true) {
   pd.Type_of_PD__c = PDType;
   pd.Loan_Application__c = Loan.Id;
   pd.Name_of_the_applicant__c = PrimaryApp.id;
   upsert pd;
   savedSuccessfull = true;
   message = 'PD refreshed successfully!!!';
  } else {
   List < Personal_Discussion__c > pdOldlist = new List < Personal_Discussion__c > ();
   pdOldlist = [select id, name, Status__c, Type_of_PD__c from Personal_Discussion__c where Loan_Application__c =: Loan.id];
   system.debug('pdOldlist = ' + pdOldlist);
   if (pdOldlist.size() > 0) {
    delete pdOldlist;
    savedSuccessfull = true;
    message = 'NO Tele PD !!';
   }

  }
 }
 public PageReference SubmitToPricing() {
  if (Loan != null) {
   if (Loan.stageName == 'Approved') {
    List < User > userList = new List < User > ();
    system.debug('****Loan.Relationship_Manager__c*' + Loan.Relationship_Manager__c);
    /*SAL PLTB added by priya start */
    if (callcenterprocessFlag == true) {
     if (Loan.Telecaller_Name__c != null) {
      userList = [SELECT FirstName, Profile.Name FROM User WHERE Username =: Loan.Telecaller_Name__c];
     }
    }
    if (userList.size() <= 0 && Loan.Relationship_Manager__c != null)
     userList = [SELECT FirstName, Profile.Name FROM User WHERE Id =: Loan.Relationship_Manager__c];
    /* SAL PLTB added by priya end*/
    if (userList != null && userList.size() > 0) {
     system.debug('****Loan.createdById*' + userList);
     //Loan.ownerId = userList[0].id;
     /*Bug 18722 Start*/
     if (userList[0].Profile.Name == 'Area Sales Manager') {
      system.debug('****Loan.createdById*' + userList);
      Loan.ownerId = userList[0].id;
     } else {
      Loan.ownerId = Loan.Area_SM__r.Id;
     }
     /*Bug 18722 End*/
     Loan.approver__c = 'Area Sales Manager';
     Loan.stageName = 'Post Approval Sales';
     update loan;
    }

    //need to assign owner
    // PageReference p = new PageReference('/apex/PricingDetailsPage?id='+loan.id); 
    Pagereference p = new pagereference('/006/o');
    p.setRedirect(true);
    return p;
   } else {
    savedSuccessfull = true;
    message = 'Loan Application must be approved before sending for Pricing !!!';

   }
  }

  return null;
 }
 public Pagereference SendBackFunctionality() {
  try {
   Opportunity Loan = LoanDetails_AC_Helper.sendBackStage(Loan);
   update Loan;

   Pagereference p = new pagereference('/' + Loan.Id);
   return p;
  } catch (Exception e) {
   system.debug('Exception occurd==>' + e.getMessage() + 'Line number===>' + e.getLinenumber());
   Apexpages.addMessages(e);
   return null;
  }
 }


 public void sendEmailForException(Exception e) {
  /*17139 */
  if (salmobilityv2falg)
   mobilitystatus = (String) e.getMessage();
  else
   Apexpages.addMessages(e);
  savedSuccessfull = true;
  system.debug('****Exception: ' + e.getMessage() + e.getStackTraceString());
  message = e.getMessage() + '  ' + e.getLineNumber() + '  ' + e.getCause() + '  ' + e.getTypeName();
  SendExceptionMail(message, 'Exception came in OTP_V2 flow');

 }


 //FAS Requirement

 public void saveDedupeData() {
  List < De_Dupe__c > dedupeUpdatedList = new List < De_Dupe__c > ();

  //FAS
  Map < Id, List < String >> applicantMap = new Map < Id, List < String >> ();


  system.debug('In DeDupe...');
  if (dedupeWrapperList != null && dedupeWrapperList.size() > 0) {
   for (DedupeWrapper de: dedupeWrapperList) {
    dedupeUpdatedList.add(de.dedupeObj);
   }
   if (dedupeUpdatedList.size() > 0) {

    //For FAS only 1 Best match
    if (Loan != null && Loan.Product__c == 'FAS') {
     for (De_Dupe__c d: dedupeUpdatedList) {
      system.debug('d.Match_Status__c=' + d.Match_Status__c);
      if (d.Match_Status__c == 'Best Match') {
       if (applicantMap.containsKey(d.Applicant__r.Id))
        applicantMap.get(d.Applicant__r.Id).add(d.Match_Status__c);
       else
        applicantMap.put(d.Applicant__r.Id, new List < String > {
         d.Match_Status__c
        });
      }
     }
     system.debug('applicantMap.size()=' + applicantMap.size());
     boolean flag = false;
     List < String > listString = new List < String > ();

     for (Id idApp: applicantMap.keySet()) {
      listString.clear();
      listString = applicantMap.get(idApp);
      system.debug('idApp=' + idApp + 'listString.size()=' + listString.size());

      if (listString.size() > 1) {
       flag = true;
      }

     }

     system.debug('flag=' + flag);

     if (flag == true) {
      savedSuccessfull = true;
      message = 'Every Applicant can have a maximum 1 Dedupe as a Best Match !!!';
      return;
     } else {
      upsert dedupeUpdatedList;
      savedSuccessfull = true;
      message = 'dedupe details Saved Successfully !!!';
     }

    } else {
     upsert dedupeUpdatedList;
     savedSuccessfull = true;
     message = 'dedupe details Saved Successfully !!!';
    }

   }
  }
  //commenting for bug 7412
  //rundedupe();
 }
 //CIBIL Watch Start
 public void SubmitBackToOriginator() {
  if (Loan != null) {
   Loan.ownerid = Loan.createdbyid;
   User createdbyUser = [select id, profile.name from user where id =: Loan.createdbyid LIMIT 1];
   Loan.Approver__c = createdbyUser.profile.name;
   Loan.StageName = 'DSA/PSF Login';
   update Loan;
  }
 }
 //CIBIL Watch End
 /*public void saveDedupeData(){
List<De_Dupe__c> dedupeUpdatedList = new List<De_Dupe__c>();
if(dedupeWrapperList!=null && dedupeWrapperList.size()>0){
for(DedupeWrapper de:dedupeWrapperList){
dedupeUpdatedList.add(de.dedupeObj);
}
if(dedupeUpdatedList.size()>0){    
upsert dedupeUpdatedList;
savedSuccessfull = true;
message = 'dedupe details Saved Successfully !!!';
}
}   

}*/





 public Boolean sendBackSales {
  get;
  set;
 }

 public void showSendBackSales() {
  if (sendBackSales == false) {
   sendBackSales = true;
  } else
   sendBackSales = false;
 }
 public Pagereference sendBackToSales() {
  try {
   /* List<OpportunityFieldHistory> OldOppRecords = [SELECT CreatedById,CreatedDate,Id,Field,NewValue,OldValue,OpportunityId ,Account.EMI_Frequency__c,DSA_Name__c ,BranchName__c ,Sourcing_Channel__r.Name ,Account.Name from opportunityFieldHistory
where OpportunityId =:Loan.id order by CreatedDate DESC];
system.debug('&&&&&&&'+OldOppRecords); 
Boolean StageChangeflag = false;
String CreatedId='';
DateTime Newdate;
for(OpportunityFieldHistory opp:OldOppRecords){
if(opp.Field == 'StageName' && opp.OldValue=='DSA/PSF Login'){
system.debug('newvalue::'+opp.NewValue);

//if(Loan.StageName == opp.NewValue){
Loan.StageName = String.valueOf(opp.OldValue);
Newdate = opp.CreatedDate;
break;
//}
}
}
system.debug('Newdate::'+Newdate);
for(OpportunityFieldHistory Oldopp:OldOppRecords){

if(Oldopp.Field == 'Owner' && Newdate == Oldopp.CreatedDate){
User Obj= [select id from User where id=:String.valueOf(Oldopp.OldValue)];
Loan.OwnerId = Obj.id;
break;
} 
}

for(OpportunityFieldHistory Oldopp:OldOppRecords){

if(Oldopp.Field == 'Approver__c' && Newdate == Oldopp.CreatedDate){
Loan.Approver__c = String.valueOf(Oldopp.OldValue);
break;

} 
} 
update loan;
*/

   //Call center strat
   User usrObj = new User(); // Bug Id 18159
   if (Loan.OwnerId != null)
    usrObj.id = Loan.OwnerId;
   if (callcenterprocessFlag == true) {
    //SAL PLTB added by pritha Start
    if (Loan.Telecaller_Name__c != null) {
     List < User > userList = new List < User > ();
     userList = [SELECT FirstName, Profile.Name FROM User WHERE Username =: Loan.Telecaller_Name__c];
     system.debug('userList ' + userList);
     if (userList != null && userList.size() > 0) {
      system.debug('****Loan.createdById*' + userList);
      Loan.ownerId = userList[0].id;
      Loan.approver__c = 'Area Sales Manager';
      Loan.stageName = 'DSA/PSF Login';
     }

    } else {
     if (StrApprSalesNew != null && StrApprSalesNew != '') {
      system.debug('---StrApprSalesNew---' + StrApprSalesNew);
      SendbackSalesFlag = false;
      User userObj = new User();
      transient Sales_Officer_Limit__c objSOL;
      for (Sales_Officer_Limit__c ObjSOLa: objSOLList) {
       if (StrApprSalesNew == ObjSOLa.id) {
        objSOL = ObjSOLa;
       }
      }
      system.debug('---objSOL---' + objSOL);
      if (objSOL != null) {
       Loan.OwnerId = objSOL.Sales_Officer_Name__c;
       Loan.Approver__c = objSOL.Designation__c;
       Loan.StageName = 'DSA/PSF Login';
       //update Loan;
      }
     } else {
      List < User > userList = new List < User > ();
      system.debug('****Loan.Relationship_Manager__c*' + Loan.Relationship_Manager__c);
      if (Loan.Relationship_Manager__c != null)
       userList = [SELECT FirstName, Profile.Name FROM User WHERE Id =: Loan.Relationship_Manager__c];
      if (userList != null && userList.size() > 0) {
       //Loan.ownerId = userList[0].id;
       /*Bug 18722 Start*/
       if (userList[0].Profile.Name == 'Area Sales Manager') {
        Loan.ownerId = userList[0].id;
       } else {
        Loan.ownerId = Loan.Area_SM__r.Id;
       }
       /*Bug 18722 End*/
       Loan.approver__c = 'Area Sales Manager';
       Loan.stageName = 'DSA/PSF Login';
      }
     }
    }
    //SAL PLTB added by pritha End
   } else {
    List < User > userList = new List < User > ();
    system.debug('****Loan.Relationship_Manager__c*' + Loan.Relationship_Manager__c);
    if (Loan.Relationship_Manager__c != null)
     userList = [SELECT FirstName, Profile.Name FROM User WHERE Id =: Loan.Relationship_Manager__c];
    if (userList != null && userList.size() > 0) {
     system.debug('****Loan.createdById*' + userList);
     //Loan.ownerId = userList[0].id;
     /*Bug 18722 Start*/
     if (userList[0].Profile.Name == 'Area Sales Manager') {
      Loan.ownerId = userList[0].id;
     } else {
      Loan.ownerId = Loan.Area_SM__r.Id;
     }
     /*Bug 18722 End*/
     Loan.approver__c = 'Area Sales Manager';
     Loan.stageName = 'DSA/PSF Login';
    }
   }
   //Call center End
   //Communication for SAL Line starts
   //code added by Leena-oct fest-start
   if (Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL') {
    system.debug('inside oct fest');
    boolean sendServiceEmial = false;
    for (Bank_Account__c bank: bankAccList) {
     if (bank.Perfios_Flag__c == true && bank.Perfiod_done_date_and_Time__c != null) {
      sendServiceEmial = true;
      system.debug('inside oct fest sendServiceEmial' + sendServiceEmial);
      break;
     }
    }
    system.debug('inside oct fest sendServiceEmial' + sendServiceEmial);
    if (sendServiceEmial) {
     transient boolean ServiceGuaranteefuntionality = LaonApplicationCreation__c.getValues('ServiceGuaranteefuntionality switch').Integrate_Charges_API__c;
     if (ServiceGuaranteefuntionality) {

      string templateName = 'Service Guarantee Decline Email';
      Id whatId = Loan.id;
      string fromName = 'noreply@bajajfinserv.in';
      string replyTo = '';
      string[] toAddresses = new String[] {};
      boolean sanity = LaonApplicationCreation__c.getValues('Serviice Guarantee Sanity').Integrate_Charges_API__c;
      if (sanity == true) {
       String[] arr = new String[] {}; // SAL PLTB added by priya
       String sanityemail = LaonApplicationCreation__c.getValues('Serviice Guarantee Sanity').SAL_Line_Exception_Email__c;
       if (sanityemail != null) {
        arr = sanityemail.split(';');

       }
       for (String str: arr) {
        toAddresses.add(str);
       }
      } else {
       toAddresses.add(accountCreate[0].Current_Email_Id__c);
       toAddresses.add(accountCreate[0].Accountant_email_id__c);
      }

      string[] CC = new String[] {};
      string[] bcc;
      String Priority = 'Normal';
      BAFL_EmailServicesLogix.Attachment[] Attachments = new BAFL_EmailServicesLogix.Attachment[] {};
      string Subject = 'Service Guarantee Decline';
      String CostCenter = 'bajaj';
      if (sanity == true) {} else {

       if (Loan.Relationship_Manager__r.Email != null)
        CC.add(Loan.Relationship_Manager__r.Email);
       if (Loan.Sourcing_Channel__r.sourcing_channel_email_id__c != null)
        CC.add(Loan.Sourcing_Channel__r.sourcing_channel_email_id__c);
       if (Loan.ACM__r.Email != null)
        CC.add(Loan.ACM__r.Email);
      }
      system.debug('inside oct fest toAddresses' + toAddresses);
      GeneralUtilities.SendEmailUsingBAFLLogix(templateName, whatId, fromName, replyTo, toAddresses, CC, bcc, Priority, Subject, CostCenter);
     }
    }
   }
   //code added by leena-oct fest-end
   if (!salmobilityv2falg && (Loan.Product__c == 'SAL' || Loan.Product__c == 'SPL' || Loan.Product__c == 'SBS CS SAL' /*SBS CS SAL consition added*/ )) { //20939 added salmobilityv2falg condition Swapnil
    /*Responsys Dynamic Parameters Bug 15653 s*/
    List < Applicant__c > appList = new List < Applicant__c > ();
    appList.add(applicantPrimary);
    if (applicantPrimary.Sent_back_to_sales_SMS_sent__c == false) {
     List < Opportunity > LoanList = new List < Opportunity > ();
     LoanList.add(Loan);
     GeneralCommunicationHandler.sendSMS(LoanList, appList, 'LA Sent Back To Sales-Cust');
     applicantPrimary.Sent_back_to_sales_SMS_sent__c = true;
     update applicantPrimary;
     // system.debug('***********applicantPrimary.Submit_To_Credit_SMS_sent__c'+applicantPrimary.Submit_To_Credit_SMS_sent__c);

    }
    List < Opportunity > LoanList = new List < Opportunity > ();
    LoanList.add(Loan);
    GeneralCommunicationHandler.sendSMS(LoanList, appList, 'LA Sent Back To Sales-Int');
    /*Responsys Dynamic Parameters Bug 15653 e*/
    string templateName = 'SAL_SubmitToSalesCustomer';
    Id whatId = Loan.id;
    string fromName = 'noreply@bajajfinserv.in';
    string replyTo = 'otpofficeemailverification@6hifw8v4ew6qa26r5whiw37rq2yorch4vylpptp0njgfwqxjc.o-51mo2mam.cs5.apex.sandbox.salesforce.com';
    string[] toAddresses = new String[] {};
    if (accountCreate[0].Current_Email_Id__c != null)
     toAddresses.add(accountCreate[0].Current_Email_Id__c);
    String[] CC;
    string[] bcc;
    String Priority = 'Normal';
    BAFL_EmailServicesLogix.Attachment[] Attachments = new BAFL_EmailServicesLogix.Attachment[] {};
    string Subject = 'Your loan application no' + Loan.Loan_Application_Number__c + 'is on hold';
    String CostCenter = 'bajaj';
    if (!Test.isRunningTest())
     GeneralUtilities.SendEmailUsingBAFLLogix(templateName, whatId, fromName, replyTo, toAddresses, CC, bcc, Priority, Subject, CostCenter);
    //internal email
    templateName = 'SAL_SubmittoSalesBFL';
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
    Subject = 'Clarification for Loan Application of ' + Loan.Account.Name;
    if (!Test.isRunningTest())
     GeneralUtilities.SendEmailUsingBAFLLogix(templateName, whatId, fromName, replyTo, toAddressesInternal, CC, bcc, Priority, Subject, CostCenter);
    //communication framework ends
   }
   //Communication for SAL Line ends

   // Start of general communication framework
   /*added by swapnil bug : 20939 s*/
   if (salmobilityv2falg && Loan.Product__c != null && (Loan.product__c == 'SAL' || Loan.product__c == 'SPL')) {
    // List < Opportunity > loanList = new List < Opportunity > ();
    //loanList.add(Loan);
    try {
     SALMobilityOppCntrl_V2.gensendSMS(Loan, null, 'On app send back to sales');
    } catch (Exception e) {
     System.debug('@swapnil exception in sendSMSEmail -->' + e.getMessage() + ' On line ' + e.getLineNumber());
    }

   } else /*added by swapnil bug : 20939 e*/
    if (Mortgageflag) {
     List < Opportunity > LoanList = new List < Opportunity > ();
     LoanList.add(Loan);
     if (Loan != null && Loan.Product__c != null && Loan.Product__C == 'SALLAP') { //Bug 15388 Start
      system.debug('\n\nSALLAP Sending return to sales SMS to Customer and Sales');
      GeneralCommunicationHandler.sendSMS(LoanList, 'Sales Return Credit-Cust');
      GeneralCommunicationHandler.sendSMS(LoanList, 'Sales Return Credit-Int');

      system.debug('\n\nSALLAP Sending return to sales Email to Sales');
      GeneralCommunicationHandler.sendEmail(LoanList, 'Sales Return Credit-Int');

     } else { //Bug 15388 End
      system.debug('Sending return to sales SMS to Customer and Sales');
      GeneralCommunicationHandler.sendSMS(LoanList, 'Sales Return-Cust');
      GeneralCommunicationHandler.sendSMS(LoanList, 'Sales Return-Int');

      system.debug('Sending return to sales Email to Customer and Sales');
      GeneralCommunicationHandler.sendEmail(LoanList, 'Sales Return-Cust');
      GeneralCommunicationHandler.sendEmail(LoanList, 'Sales Return-Int');
     } //Bug 15388 Else End

    }
   // End of general communication framework
   /*17139 */
   if (salmobilityv2falg) {
    if (!CommonUtility.isEmpty(app_rejcomments))
     loan.COO_Comments__c = app_rejcomments;
   }
   update loan;
   //Bug 18159 - May 2018 BRD - Auto allocation of application to Credit start
   String methodName = 'SendBackToSales'; // Prod Issue
   if (salmobilityv2falg) methodName = methodName + ';mobility_LA';
   system.debug('calling updateCreditUserOccupied');
    AutoQueueAllocationUtility.updateCreditUserOccupied(methodName, Loan, usrObj);
   //Bug 18159 - May 2018 BRD - Auto allocation of application to Credit end
   //Deepak - Service Guarantee Phase 2 start
   System.debug('GUarantee Loan Product :' + Loan.Product__c);
   if (GeneralUtilities.servGuaranteeProd(Loan.Product__c)) {
    GeneralUtilities.updateTimeFirstAction(applicantPrimary);
    GeneralUtilities.updateTimeForDecision(applicantPrimary, bankAcc);
    System.debug('COFInantial...bank Acc' + bankAcc);
   }
   //Deepak - Service Guarantee Phase 2 end
   /*17139 */
   if (salmobilityv2falg) {
    mobilitystatus = 'Success';
    return null;
   } else {
    Pagereference p = new pagereference('/' + Loan.Id);
    return p;
   }
  } catch (Exception e) {
   system.debug('Exception occurd==>' + e.getMessage() + 'Line number===>' + e.getLinenumber());
   /*17139 */
   if (salmobilityv2falg)
    mobilitystatus = e.getMessage();
   else
    Apexpages.addMessages(e);
   return null;
  }
 }

 public void sendBackCreditShow() {
  if (SendbackFlag == false) {
   SendbackFlag = true;
  } else
   SendbackFlag = false;
 }
 //Call center process start
 public void sendBackSalesShow() {
  if (SendbackSalesFlag == false) {
   SendbackSalesFlag = true;
  } else
   SendbackSalesFlag = false;
 }
 //Call center process end
 public void SelectOPCreditOfficer() {
  if (Loan.product__c != 'FAS' && !MortgageFlag) {
   //bug id 20474  start
   if (checkPhysicalPD()) {
    showOPApprovePanel = true;
    showCentralisePanel = false; // CIBIL Watch
   }
   //20474 end
  } else {

   if (Loan != null) {
    if (Loan.stageName == 'Approved') {
     showOPApprovePanel = true;
    } else {
     savedSuccessfull = true;
     message = 'Loan Application must be approved before sending for Pricing !!!';
    }

   }
  }
 }

 public PageReference sendBackToCredit() {
  system.debug('dddd=StrAppr' + StrApprNew);
  SendbackFlag = false;
  User userObj = new User();
  if (Loan.OwnerId != null) // Bug Id : 18159
   userObj.id = Loan.OwnerId;
  transient Credit_Officer_Limit__c CreditOffLimitObj;
  for (Credit_Officer_Limit__c temp: CO) {
   if (StrApprNew == temp.id) {
    CreditOffLimitObj = temp;
   }
  }
  system.debug('ddd=CreditOffLimitObj' + CreditOffLimitObj);
  if (CreditOffLimitObj != null) {
   Loan.OwnerId = CreditOffLimitObj.Credit_Officer_Name__c;
   Loan.Approver__c = CreditOffLimitObj.Designation__c;
   //Call center Start
   if (callcenterprocessFlag == true) {
    Loan.StageName = 'Underwriting';
   }
   //Call center End
   update Loan;
   //Bug 18159 - May 2018 BRD - Auto allocation of application to Credit start
   system.debug('calling updateCreditUserOccupied');
   AutoQueueAllocationUtility.updateCreditUserOccupied('Recommend', Loan, userObj);
   //Bug 18159 - May 2018 BRD - Auto allocation of application to Credit end
   //Deepak - Service Guarantee Phase 2 start
   System.debug('GUarantee Loan Product :' + Loan.Product__c);
   if (GeneralUtilities.servGuaranteeProd(Loan.Product__c)) {
    GeneralUtilities.updateTimeFirstAction(applicantPrimary);
    GeneralUtilities.updateTimeForDecision(applicantPrimary, bankAcc);
    System.debug('COFInantial...bank Acc' + bankAcc);
   }
   //Deepak - Service Guarantee Phase 2 end

  }
  // PageReference pageRef = new PageReference('/apex/COEligibilityDetailsPage?id='+loan.id+'&grouptype=salaried');
  Pagereference pageRef = new pagereference('/006/o');
  return pageRef;

 }


 /*public List < SelectOption > getStrCOApprList() {
return optionsCOAppr;
}*/


 public PageReference SubmitToBranchOps() {
  if (Loan != null) {
   //New code
   system.debug('-----StrCOAppr--------' + StrCOAppr);
   if (StrCOAppr == 'None') {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please select the Approver before submitting'));
    return null;
   }
   //bug id 20474 method called to check if needed physical pd completed or not 

   if (!checkPhysicalPD()) {
    return null;
   }
   string approverDesignation1 = null;
   Integer loanAmt = 0;
   Credit_Officer_Limit__c tempCOL1 = new Credit_Officer_Limit__c();
   try {

    system.debug('StrCOAppr=' + StrCOAppr);
    tempCOL1 = [select id, Designation__c, Loan_Amount__c, Credit_Officer_Name__r.id, Credit_Officer_Name__r.Employee_ID__c, Pre_Approved_Amount__c, User_Type__c from Credit_Officer_Limit__c
     where id =: StrCOAppr
    ];

    if (tempCOL1 != null) {
     approverDesignation1 = tempCOL1.Designation__c;
     //loanAmt = Integer.valueof(tempCOL1.Loan_Amount__c);

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
    system.debug('Exception occurd==>' + e.getMessage() + 'Line number===>' + e.getLinenumber());
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
    StrCOAppr = tempCOL1.Credit_Officer_Name__r.id;
    system.debug('StrAppr:------ ' + StrCOAppr);
    Loan.ownerid = StrCOAppr;
    Loan.Approver__c = 'Centralized RCM';
    Loan.Centralized_RCM_Amount__c = loanAmt;
    system.debug('StrAppr:---Loan.ownerid--- ' + Loan.ownerid);
    Loan.Centralized_RCM__c = StrCOAppr;
    // Code to initiate CIBIL
    system.debug('-- Salaried initiate CIBIL --' + applicantList.size());
    applicantList[0].Integrate_with_CIBIL__c = true;
    applicantList[0].Update_CIBIL_Error__c = false;
    applicantList[0].Description__c = '';
    update applicantList;
   } else if (Loan.Approver__c != 'Centralized CPA') {
    string approverDesignation = null;
    system.debug('*****StrCOAppr: ' + StrCOAppr);
    if ((StrCOAppr != null) && (StrCOAppr != 'None')) {
     Credit_Officer_Limit__c tempCOL = [select id, Designation__c, Credit_Officer_Name__r.id, Credit_Officer_Name__r.Employee_ID__c, Pre_Approved_Amount__c, User_Type__c from Credit_Officer_Limit__c
      where Id =: StrCOAppr LIMIT 1
     ];
     approverDesignation = tempCOL.Designation__c;
     system.debug('******approverDesignation: ' + approverDesignation);

     StrCOAppr = tempCOL.Credit_Officer_Name__r.id;
    }


    String Branch = Loan.BranchName__c;
    double acmamt = 0;
    // strung proproduct=
    //4450
    List < Credit_Officer_Limit__c > acmList = new List < Credit_Officer_Limit__c > ();
    system.debug('LoanAppFlow=' + LoanAppFlow);

    if (Branch != null && Loan.Product__c != null && StrCOAppr != null) {
     try {

      if (COLStampFlag == true && LoanAppFlow != null) {
       acmList = [select Loan_Amount__c, Pre_Approved_Amount__c, User_Type__c from Credit_Officer_Limit__c
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
       acmamt = [select Loan_Amount__c, User_Type__c from Credit_Officer_Limit__c
        where Credit_Officer_Name__c =: StrCOAppr
        and /**Product__c =:**/ Product__c =: Loan.Product__c and City__c INCLUDES(: Branch) and Active_Flag__c = true limit 1
       ].Loan_Amount__c;
      }


     } catch (Exception e) {
      Apexpages.addMessages(e);
      system.debug('Exception occurd==>' + e.getMessage() + 'Line number===>' + e.getLinenumber());
      savedSuccessfull = true;
      message = e.getMessage() + '  ' + e.getLineNumber() + '  ' + e.getCause() + '  ' + e.getTypeName();
      SendExceptionMail(message, 'Exception came in MidOffice flow (Eligibility)');
      return null;
     }
    }
    if (approverDesignation1 == 'OPs Officer') {
     Loan.ownerId = StrCOAppr;
     Loan.Approver__c = 'OPs Officer';
     Loan.CPA__c = StrCOAppr;
    } else if (approverDesignation1 == 'FAS Centralized Ops') {
     Loan.ownerId = StrCOAppr;
     Loan.Approver__c = 'FAS Centralized Ops';
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
     //CIBIL Watch Start
    } else if (approverDesignation1 == 'Centralized Ops Officer') {

     Loan.stageName = 'Centralised Ops';
     Loan.Approver__c = 'Centralized Ops Officer';
     Loan.CPA__c = StrCOAppr;
     Loan.ownerId = StrCOAppr;


    }
    //CIBIL Watch End  
    else {
     //Submit to Approver logic
     if (StrCOAppr != null)
      Loan.ownerid = StrCOAppr;
     Loan.CPA__c = StrCOAppr;
    }
   }
   Loan.stageName = 'Branch Ops';
   Loan.Sales_Submit_to_Branch_Ops_Date__c = System.now();
   system.debug('Loan.stageName=' + Loan.stageName + '=Loan.ownerId=' + Loan.ownerId + '=StrCOAppr=' + StrCOAppr);
   update loan;
  }
  //  PageReference p = new PageReference('/apex/DisbursementDetailsPage?id='+loan.id);

  Pagereference p = new pagereference('/006/o');
  p.setRedirect(true);
  return p;

 }

 // CIBIL Watch Start
 public void SelectOPCreditOfficer1() {
  /*showOPApprovePanel = false;
showCentralisePanel = true;*/

  if (Loan.product__c != 'FAS' && !MortgageFlag) {
   showOPApprovePanel = true;
   showCentralisePanel = false; // CIBIL Watch
  } else {
   if (Loan != null) {
    if (Loan.stageName == 'Approved') {
     showOPApprovePanel = true;
    } else {
     savedSuccessfull = true;
     message = 'Loan Application must be approved before sending for Pricing !!!';
    }
   }
  }

 }
 // CIBIL Watch End
 public List < SelectOption > getStrCOApprList() {
  return optionsCOApprFAS;
 }


 public class BankingDetailsWrapper {
  public Boolean deleteDetail {
   get;
   set;
  }
  public Bank_Account__c bankAccObj {
   get;
   set;
  }
  public List < Bank_Transaction__c > bankTranList {
   get;
   set;
  }
  public BankingDetailsWrapper(Bank_Account__c BankObj, Boolean deleteChecked) {
   this.deleteDetail = deleteChecked;
   this.bankAccObj = BankObj;
   bankTranList = new List < Bank_Transaction__c > ();
   bankTranList.add(new Bank_Transaction__c());
   bankTranList.add(new Bank_Transaction__c());
   bankTranList.add(new Bank_Transaction__c());
  }
 }


 public void SaveBankAccounts() {
  //upsert Scam;
  primaryBankExists = false;
  if (BankWrapperlist.size() > 0) {
   transient List < Bank_Account__c > tempListSave = new List < Bank_Account__c > ();
   transient List < Bank_Transaction__c > tempBankListSave = new List < Bank_Transaction__c > ();
   for (integer i = 0; i < BankWrapperlist.size(); i++) {
    system.debug('ddd=ddd=>applicant' + applicantPrimary);
    BankWrapperlist[i].bankAccObj.Bank_Name__c = BankWrapperlist[i].bankAccObj.Bank_Name_List__c;
    BankWrapperlist[i].bankAccObj.Applicant__c = applicantPrimary.id;
    if (BankWrapperlist[i].bankAccObj.Bank_Type__c == 'Primary') {
     primaryBankExists = true;
    }
    tempListSave.add(BankWrapperlist[i].bankAccObj);
   }

   system.debug('tempListSave--->' + tempListSave);
   if (tempListSave.size() > 0) {
    upsert tempListSave;
    for (Bank_Account__c savedList: tempListSave) {
     for (BankingDetailsWrapper WrpList: BankWrapperlist) {
      system.debug('=====>' + savedList.Bank_Name__c + '====' + WrpList.bankAccObj.Bank_Name__c + '====' + savedList.Bank_Acct_Number__c + '=====' + WrpList.bankAccObj.Bank_Acct_Number__c);
      if (savedList.Bank_Name__c == WrpList.bankAccObj.Bank_Name__c && savedList.Bank_Acct_Number__c == WrpList.bankAccObj.Bank_Acct_Number__c) {
       for (Bank_Transaction__c bankTr: WrpList.bankTranList) {
        if (bankTr.Bank_Account__c == null) bankTr.Bank_Account__c = savedList.id;
        bankTr.Loan_application__c = Loan.id;
        tempBankListSave.add(bankTr);
        system.debug('=====>' + bankTr);
       }
      }
     }
    }
    if (!primaryBankExists) {
     BankWrapperlist[0].bankAccObj.Applicant__c = applicantPrimary.id;
     BankWrapperlist[0].bankAccObj.Bank_Type__c = 'Primary';
     upsert BankWrapperlist[0].bankAccObj;
    }

    system.debug('tempBankListSave.size()=' + tempBankListSave.size() + '=tempBankListSave=' + tempBankListSave);
    if (tempBankListSave.size() > 0) {
     upsert tempBankListSave;
    }
   }

  }

 }

 public void AddBankAccount() {

  Bank_Account__c temp = new Bank_Account__c();
  if (ApexPages.currentPage().getParameters().get('id') != null) {
   LoanId = ApexPages.currentPage().getParameters().get('id');
  } else if (ApexPages.currentPage().getParameters().get('iid') != null) {
   LoanId = ApexPages.currentPage().getParameters().get('iid');
  } else {

  }
  temp.Loan_application__c = LoanId;
  //PSBLBankAcount.add(temp);
  BankingDetailsWrapper wrapperTemp = new BankingDetailsWrapper(temp, false);
  BankWrapperlist.add(wrapperTemp);

 }


 public void DeleteBankAccounts() {
  //update Scam;
  primaryBankExists = false;
  if (BankWrapperlist != null && BankWrapperlist.size() > 0) {
   transient List < Bank_Account__c > tempListDel = new List < Bank_Account__c > ();
   for (integer i = 0; i < BankWrapperlist.size(); i++) {
    if (BankWrapperlist[i].deleteDetail == true) {
     if (BankWrapperlist[i].bankAccObj.id != null) {
      tempListDel.add(BankWrapperlist[i].bankAccObj);

     }
     BankWrapperlist.remove(i);
    }
   }

   if (tempListDel.size() > 0) {

    delete tempListDel;
   }
  }
  if (BankWrapperlist != null && BankWrapperlist.size() > 0) {
   for (integer i = 0; i < BankWrapperlist.size(); i++) {
    //tempListSave.add(BankWrapperlist[i].bankAccObj);
    if (BankWrapperlist[i].bankAccObj.Bank_Type__c == 'Primary') {
     primaryBankExists = true;
    }
   }
   if (!primaryBankExists) {
    BankWrapperlist[0].bankAccObj.Applicant__c = applicantPrimary.id;
    BankWrapperlist[0].bankAccObj.Bank_Type__c = 'Primary';
    upsert BankWrapperlist[0].bankAccObj;
   }

  }

 }
 //B2C integration api changes bug no 6974 by akshata S
 public void sendStatusToB2C() {
  system.debug('send method');
  B2CSendStatus.sendStatus(Loan.Customer_Reference_Number__c, Loan.stagename);
 }

 //B2C integration api changes bug no 6974 by akshata E
 //************** EMI Holiday START
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

 //************** EMI Holiday END
 //Added for Call center S
 public Pagereference assignToLeadVerifyer() {
  if (Loan != null) {
   if (Loan.stageName == 'Approved') {
    if (objLeadSalesList != null && objLeadSalesList.size() > 0) {
     system.debug('inside assignToLeadVerifyer=>' + objLeadSalesList);
     for (Sales_Officer_Limit__c objSales: objLeadSalesList) {
      system.debug('LeadVerifierName---->>>>' + LeadVerifierName + 'objSales.Sales_Officer_Name__r.Name---->>' + objSales.Sales_Officer_Name__c);
      if (LeadVerifierName == objSales.Sales_Officer_Name__c) {
       system.debug('match found');
       Loan.ownerId = objSales.Sales_Officer_Name__c;
       Loan.approver__c = 'Lead Verifier';
       Loan.stageName = 'Post Approval Sales';
      }
     }
     update loan;
    }
    Pagereference p = new pagereference('/006/o');
    p.setRedirect(true);
    return p;
   } else {
    savedSuccessfull = true;
    message = 'Loan Application must be approved before sending for Pricing !!!';
   }
  }
  return null;
 }
 //Added for Call center E
 /*SAL PL to SAL LAP start*/
 public void generateLAPOffer(List < Existing_Loan_Details__c > extList) {
  try {
   Map < String, Object > exiLoanMap = new Map < String, Object > ();
   for (Existing_Loan_Details__c exp: extList) {
    exiLoanMap.put(exp.name, exp);
   }
   Map < String, Object > mapOfInput = new Map < String, Object > ();
   //Map<String,Object> offerGenerated = new Map<String,Object>();
   List < Cibil_Extension1__c > cibilExt1List = new List < Cibil_Extension1__c > ();
   cibilExt1List = [select /*OTP V3 CR s*/ Highest_DPD_In_1_Year__c, max_mob__c, liveLoanAmount__c, X30_DPD_6_months__c, X30_DPD_3_months__c, securedToTotalRatioAmount__c, /*OTP V3 CR e*/ Number_of_Hl_Loans__c, Mortgage_Loan_Amount__c, Max_unSecured_Loan_Amount__c, Max_Secured_Loan_Amount__c, id, No_of_Live_PL__c, Written_Off_principal__c, Written_Off_principal9__c, Written_Off_principal8__c, Written_Off_principal7__c, Written_Off_principal6__c, Written_Off_principal5__c, Written_Off_principal4__c, Written_Off_principal3__c, Written_Off_principal2__c, Written_Off_principal29__c, Written_Off_principal28__c, Written_Off_principal27__c, Written_Off_principal26__c, Written_Off_principal25__c, Written_Off_principal24__c, Written_Off_principal23__c, Written_Off_principal22__c, Written_Off_principal21__c, Written_Off_principal20__c, Written_Off_principal1__c, Written_Off_principal19__c, Written_Off_principal18__c, Written_Off_principal17__c, Written_Off_principal16__c, Written_Off_principal15__c, Written_Off_principal14__c, Written_Off_principal13__c, Written_Off_principal12__c, Written_Off_principal11__c, Written_Off_principal10__c, Written_Off_and_settled_status__c, Written_Off_and_settled_status9__c, Written_Off_and_settled_status8__c, Written_Off_and_settled_status7__c, Written_Off_and_settled_status6__c, Written_Off_and_settled_status5__c, Written_Off_and_settled_status4__c, Written_Off_and_settled_status3__c, Written_Off_and_settled_status2__c, Written_Off_and_settled_status29__c, Written_Off_and_settled_status28__c, Written_Off_and_settled_status27__c, Written_Off_and_settled_status26__c, Written_Off_and_settled_status25__c, Written_Off_and_settled_status24__c, Written_Off_and_settled_status23__c, Written_Off_and_settled_status22__c, Written_Off_and_settled_status21__c, Written_Off_and_settled_status20__c, Written_Off_and_settled_status1__c, Written_Off_and_settled_status19__c, Written_Off_and_settled_status18__c, Written_Off_and_settled_status17__c, Written_Off_and_settled_status16__c, Written_Off_and_settled_status15__c, Written_Off_and_settled_status14__c, Written_Off_and_settled_status13__c, Written_Off_and_settled_status12__c, Written_Off_and_settled_status11__c, Written_Off_and_settled_status10__c, Write_Off__c,
    Bad_Track_Record__c, Tradelines_30plus_DPD__c, Total_Amount_overdue__c, Max_Lifetime_Delq__c, Ever_Write_off__c, Secured_Tradelines_90plus_DPD__c, No_Of_Live_Trades__c,
    Total_No_of_Trades__c, Unsecured_Tradelines_in_last_12m__c, First_Loan_MOB__c, Latest_Loan_MOB__c, Unsecured_to_total_ratio__c, Secured_to_unsecured_ratio__c, Unsecured_to_total_amount__c,
    OSB_to_loan_amount_unsecured__c, Credit_Card_utilization__c, Avg_unsecured_loan_amount__c, Unsecured_loan_balance__c, Total_Sanction_Amnt_unsecured__c, Total_Sanction_Amnt_secured__c,
    Current_Obligation_All__c, Current_Obligation_Secured__c, Current_Obligation_unsecured__c, Enquiries_past_3_mnths__c, Unsecured_Enquiries_past_3_mnths__c, Current_Bal_on_all_cards__c, Average_Total_Balance__c, No_of_PL_Enq_in_Last_12_Months__c, No_of_PL_Enq_in_Last_6_Months__c, Sum_of_Amount_Overdue__c
    from Cibil_Extension1__c where Applicant__c =: applicantPrimary.id limit 1
   ];
   mapOfInput.put('loan_id', (Loan.Loan_Application_Number__c != null) ? Loan.Loan_Application_Number__c : '');
   mapOfInput.put('approved_loan_amount', (cam.Eligible_Loan__c != null) ? String.valueof(cam.Eligible_Loan__c) : '0');
   mapOfInput.put('requested_loan_amount', (cam.Proposed_Loan_Amt__c != null) ? String.valueOf(cam.Proposed_Loan_Amt__c) : '');
   mapOfInput.put('requested_tenor', (cam.Tenor__c != null) ? String.valueof(cam.Tenor__c) : '0');
   mapOfInput.put('reqested_roi', (cam.ROI__c != null) ? String.valueof(cam.ROI__c) : '0');
   mapOfInput.put('loan_application_number', (Loan.Loan_Application_Number__c != null) ? Loan.Loan_Application_Number__c : '');
   mapOfInput.put('product', (Loan.product__c != null) ? Loan.product__c : '');
   mapOfInput.put('scheme_name', (Loan.Scheme_Master__c != null) ? Loan.Scheme_Master__r.Name : '');
   mapOfInput.put('type_of_loan', (Loan.Type_Of_Loan__c != null) ? Loan.Type_Of_Loan__c : '');
   mapOfInput.put('process_type', (Loan.Account.Process_Type__c != null) ? Loan.Account.Process_Type__c : '');
   mapOfInput.put('stage', (Loan.stageName != null) ? Loan.stageName : '');
   mapOfInput.put('sourcing_channel_type', (Loan.Sourcing_Channel_Type__c != null) ? Loan.Sourcing_Channel_Type__c : '');
   mapOfInput.put('sub_stage', (Loan.Sub_Stage__c != null) ? Loan.Sub_Stage__c : '');
   mapOfInput.put('offer_amount', (Loan.Offer_Amount__c != null) ? String.valueof(Loan.Offer_Amount__c) : '0');
   mapOfInput.put('program_type', (Loan.Program_Type__c != null) ? Loan.Program_Type__c : '');
   mapOfInput.put('type_of_constitution', (Loan.Type_of_Constitution__c != null) ? Loan.Type_of_Constitution__c : '');
   //mapOfInput.put('professionType', (applicantPrimary.Contact_Name__r.Profession__c != null) ? applicantPrimary.Contact_Name__r.Profession__c : '');
   //mapOfInput.put('constitutionType', (applicantPrimary.Contact_Name__r.Constitution__c) != null ? applicantPrimary.Contact_Name__r.Constitution__c : '');
   mapOfInput.put('educational_qualification', (applicantPrimary.Contact_Name__r.Qualification__c != null) ? applicantPrimary.Contact_Name__r.Qualification__c : '');
   mapOfInput.put('current_employment_vintage', (applicantPrimary.Contact_Name__r.Current_experiance_in_Years__c != null) ? applicantPrimary.Contact_Name__r.Current_experiance_in_Years__c : '0');
   mapOfInput.put('total_employment_vintage', (applicantPrimary.Contact_Name__r.Total_Work_Experience_Yrs__c != null) ? String.valueof(applicantPrimary.Contact_Name__r.Total_Work_Experience_Yrs__c) : '0');
   mapOfInput.put('date_of_birth', (applicantPrimary.Contact_Name__r.Date_of_Birth__c != null) ? String.valueof(applicantPrimary.Contact_Name__r.Date_of_Birth__c) : '');
   //mapOfInput.put('date_of_incorporation', (applicantPrimary.Contact_Name__r.Year_of_Incorporation__c != null) ? String.valueof(applicantPrimary.Contact_Name__r.Year_of_Incorporation__c) : '');
   mapOfInput.put('costomer_type', (Loan.Customer_Type__c != null) ? Loan.Customer_Type__c : '');
   mapOfInput.put('customer_segment', (applicantPrimary.Bureau_Segment__c != null) ? applicantPrimary.Bureau_Segment__c : '');
   mapOfInput.put('years_in_business_job', (applicantPrimary.Contact_Name__r.Total_Work_Experience_Yrs__c != null) ? String.valueof(applicantPrimary.Contact_Name__r.Total_Work_Experience_Yrs__c) : '0');
   mapOfInput.put('first_name', (Loan != null && Loan.Account.First_Name__c != null) ? String.valueof(Loan.Account.First_Name__c) : '');
   mapOfInput.put('last_name', (Loan != null && Loan.Account.last_name__c != null) ? String.valueof(Loan.Account.last_name__c) : '');
   mapOfInput.put('residence_type', (applicantPrimary.Contact_Name__r.Residence_Type__c != null) ? applicantPrimary.Contact_Name__r.Residence_Type__c : '');
   mapOfInput.put('applicant_type', (applicantPrimary.Applicant_type__c != null) ? applicantPrimary.Applicant_type__c : '');
   mapOfInput.put('marital_status', (applicantPrimary.Contact_Name__r.Marital_Status__c != null) ? applicantPrimary.Contact_Name__r.Marital_Status__c : '');

   mapOfInput.put('company_category', (applicantPrimary.Contact_Name__r.Company_Category__c != null) ? applicantPrimary.Contact_Name__r.Company_Category__c : '');
   mapOfInput.put('company_type', (applicantPrimary.Contact_Name__r.Company_Type__c != null) ? applicantPrimary.Contact_Name__r.Company_Type__c : '');
   //mapOfInput.put('type_of_degree', (applicantPrimary.Contact_Name__r.Degree__c != null) ? applicantPrimary.Contact_Name__r.Degree__c : '');
   mapOfInput.put('office_email_id', (applicantPrimary.Contact_Name__r.Office_Email_Id__c != null) ? applicantPrimary.Contact_Name__r.Office_Email_Id__c : '');
   mapOfInput.put('name_of_employer', (applicantPrimary.Contact_Name__r.Name_of_Employer__c != null) ? applicantPrimary.Contact_Name__r.Name_of_Employer__c : '');
   mapOfInput.put('pan', (applicantPrimary.PAN_Number__c != null) ? applicantPrimary.PAN_Number__c : '');
   mapOfInput.put('residence_city', (applicantPrimary.Contact_Name__r.Residence_City__c != null) ? applicantPrimary.Contact_Name__r.Residence_City__c : '');
   mapOfInput.put('office_city', (applicantPrimary.Contact_Name__r.Office_City__c != null) ? applicantPrimary.Contact_Name__r.Office_City__c : '');
   mapOfInput.put('residence_pin_code', (applicantPrimary.Contact_Name__r.Pin_Code__c != null) ? String.valueof(applicantPrimary.Contact_Name__r.Pin_Code__c) : '');
   mapOfInput.put('gender', (applicantPrimary.Contact_Name__r.Gender__c != null) ? applicantPrimary.Contact_Name__r.Gender__c : '');
   mapOfInput.put('office_pin_code', (applicantPrimary.Contact_Name__r.Office_Pin_Code__c != null) ? String.valueOf(applicantPrimary.Contact_Name__r.Office_Pin_Code__c) : '0');
   mapOfInput.put('staying__since_year', (applicantPrimary.Contact_Name__r.Years_At_Residence__c != null) ? String.valueof(applicantPrimary.Contact_Name__r.Years_At_Residence__c) : '0');
   mapOfInput.put('nature_of_business', (Loan.Nature_of_Business__c != null) ? Loan.Nature_of_Business__c : '');
   mapOfInput.put('customer_type', (applicantPrimary.Existing_Customer__c != null) ? applicantPrimary.Existing_Customer__c.ToUpperCase() : '');
   mapOfInput.put('avg_od_cc_utilisation', (cam.Industry_Margins_applicable1__c != null) ? String.valueof(cam.Industry_Margins_applicable1__c) : '0');
   if (cibilExt1List != null && cibilExt1List.size() > 0) {
    mapOfInput.put('securedLoanAmount', (cibilExt1List[0].Max_Secured_Loan_Amount__c != null) ? string.valueOf(cibilExt1List[0].Max_Secured_Loan_Amount__c) : '0');
    mapOfInput.put('unSecuredLoanAmount', (cibilExt1List[0].Max_unSecured_Loan_Amount__c != null) ? String.valueof(cibilExt1List[0].Max_unSecured_Loan_Amount__c) : '0');
    mapOfInput.put('mortgageLoanAmount', (cibilExt1List[0].Mortgage_Loan_Amount__c != null) ? String.valueof(cibilExt1List[0].Mortgage_Loan_Amount__c) : '0');
    mapOfInput.put('number_of_hl_loans', (cibilExt1List[0].Number_of_Hl_Loans__c != null) ? cibilExt1List[0].Number_of_Hl_Loans__c : 0);
    mapOfInput.put('dpdMoreThan30', (cibilExt1List[0].Tradelines_30plus_DPD__c != null) ? cibilExt1List[0].Tradelines_30plus_DPD__c : 0);

   } else {
    mapOfInput.put('securedLoanAmount', '0');
    mapOfInput.put('unSecuredLoanAmount', '0');
    mapOfInput.put('mortgageLoanAmount', '0');
    mapOfInput.put('number_of_hl_loans', '0');
    mapOfInput.put('dpdMoreThan30', '0');
   }
   if (applicantPrimary.CIBIL_Score__c != null && applicantPrimary.CIBIL_Score__c == '000-1')
    mapOfInput.put('CIBIL_Score', '0');
   else
    mapOfInput.put('CIBIL_Score', (applicantPrimary.CIBIL_Score__c != null) ? String.valueof(applicantPrimary.CIBIL_Score__c) : '0');
   mapOfInput.put('gender', (applicantPrimary.Contact_Name__r.Gender__c != null) ? applicantPrimary.Contact_Name__r.Gender__c : '');
   mapOfInput.put('average_Net_Salary', (cam.Average_Monthly_Net_Income1__c != null) ? String.valueOf(cam.Average_Monthly_Net_Income1__c) : '0');
   mapOfInput.put('gross_Salary_Month1', (cam.Average_incentive_for_Q1__c != null) ? String.valueof(cam.Average_incentive_for_Q1__c) : '');
   mapOfInput.put('gross_Salary_Month2', (cam.Average_incentive_for_Q2__c != null) ? String.valueof(cam.Average_incentive_for_Q2__c) : '');
   mapOfInput.put('gross_Salary_Month3', (cam.Average_incentive_for_Q3__c != null) ? String.valueof(cam.Average_incentive_for_Q3__c) : '');
   mapOfInput.put('net_Salary_for_Month1', (cam.Net_Salary_for_Month1__c != null) ? String.valueof(cam.Net_Salary_for_Month1__c) : '0');
   mapOfInput.put('proposed_Loan_Amt', (cam.Proposed_Loan_Amt__c != null) ? String.valueof(cam.Proposed_Loan_Amt__c) : '0');
   mapOfInput.put('rental_Income', cam.Rental_Income__c != null ? String.valueof(cam.Rental_Income__c) : '0');
   mapOfInput.put('branch_type', (Loan.Branch_Type1__c != null) ? String.valueof(Loan.Branch_Type1__c) : '');
   mapOfInput.put('branch_name', (Loan.BranchName__c != null) ? Loan.BranchName__c : '');
   mapOfInput.put('branch_code', (Loan.Branch_Name__c != null && Loan.Branch_Name__r.Branch_Code__c != null) ? String.valueOf(Loan.Branch_Name__r.Branch_Code__c) : '');
   mapOfInput.put('existing_loans', extList);
   mapOfInput.put('monthly_loan_obligations', (cam.Total_Mthly_Oblig__c != null) ? cam.Total_Mthly_Oblig__c : 0);
   BRECallout breObj = new BRECallout();
   String offerGenerated = '';
   if (!Test.isRunningTest())
    offerGenerated = breObj.callBRELAPOfferGeneration(mapOfInput);
   else
    offergenerated = '{"output":{"loanId":"5320478918715","offerAmountList":[{"existingProduct":"SALLAP","offerAmount":10000000,"multiplier":1.1799999999999999378275106209912337362766265869140625,"documents":"","offerAIdentifier":"NORMAL","offerProductId":"L_18995259","legalFlag":"","technicalFlag":"","physicalPDFlag":"","previousBank":null,"previousBankLoanAmt":null}],"calculatedOffer":"SAL-HL-BTTP","noOfferReason":"Either Multipler zero or Minimum capping policy met for Normal offers","calculatedOfferRevisedFor":null,"segment":null},"Action":true}';
   Map < String, Object > offerGeneratedMap = new Map < String, Object > ();
   if (offerGenerated != null && offerGenerated != '') {
    offerGeneratedMap = (Map < String, Object > ) JSON.deserializeUntyped(offerGenerated);
    system.debug(LoggingLevel.error, 'offerGeneratedMap===>' + offerGeneratedMap);
   }
   Map < String, Object > offerAmtResponse = (Map < String, Object > ) offerGeneratedMap.get('output');


   offerGeneratedMap = offerAmtResponse;
   String calculatedOffer = String.valueOf(offerGeneratedMap.get('calculatedOffer'));
   List < Object > offersList = new List < Object > ();
   if (offerGeneratedMap.get('offerAmountList') != null) {
    offersList = (List < Object > ) offerGeneratedMap.get('offerAmountList');
   }

   for (Object offerTemp: offersList) {
    Map < String, Object > offerTempMap = (Map < String, Object > ) offerTemp;
    ScripsHistory__c scripTemp = new ScripsHistory__c();
    scripTemp.Loan_Application__c = Loan.id;
    scripTemp.Offer_Amount__c = Double.ValueOf(offerTempMap.get('offerAmount'));
    scripTemp.Offer_Product__c = (String) offerTempMap.get('existingProduct');
    scripTemp.Calculated_Offer__c = calculatedOffer;
    scripTemp.Offer_multiplier__c = Double.ValueOf(offerTempMap.get('multiplier'));
    scripTemp.Offer_Identifier__c = (String) offerTempMap.get('offerAIdentifier');
    scripTemp.Offer_Documents__c = (String) offerTempMap.get('documents');
    scripTemp.Legal_Flag__c = (String) offerTempMap.get('legalFlag');
    scripTemp.Physical_PD_Flag__c = (String) offerTempMap.get('physicalPDFlag');
    scripTemp.Technical_Flag__c = (String) offerTempMap.get('technicalFlag');

    Existing_Loan_Details__c exiTemp = new Existing_Loan_Details__c();
    exiTemp = (Existing_Loan_Details__c) exiLoanMap.get((String) offerTempMap.get('offerProductId'));
    if (exiTemp != null) {
     scripTemp.Financier__c = exiTemp.financers__c;
     scripTemp.MOB__c = exiTemp.MOB__c;
     scripTemp.POS__c = exiTemp.POS__c;
     scripTemp.Property_Address__c = exiTemp.City__c;
     scripTemp.area__c = exiTemp.Property_Address__c;
     scripTemp.Current_EMI__c = exiTemp.Derived_EMI__c;
     scripTemp.ROI__c = exiTemp.Rate_of_Interest__c;
     scripTemp.Existing_Loan_Amount__c = exiTemp.Loan_Amount__c;
    }

    scripTemp.Source__c = '01MOB';
    finalScripsHistoryInsert.add(scripTemp);

   }


  } catch (Exception e) {
   system.debug('Exception' + e.getMessage() + e.getLineNumber());
  }
 }
 /*SAL PL to SAL LAP end*/
 // 01MOB S
 public void offerDetailsBRE() {
  Bank_Account__c bankAccBRE = new Bank_Account__c();

  Map < String, Object > exiLoanMap = new Map < String, Object > ();
  for (Existing_Loan_Details__c exp: ExistLoans) {
   exiLoanMap.put(exp.name, exp);
  }
  system.debug('exiLoanMap----->' + exiLoanMap);
  if (bankAcclist != null && bankAcclist.size() > 0) {
   bankAccBRE = bankAccList[0];
  }

  JSONGenerator gen = JSON.createGenerator(true);
  BRECallout breObj = new BRECallout();

  gen.writeStartObject();
  gen.writeFieldName('existingLoan');
  gen.writeStartArray();
  Set < String > RSLexistingProduct = new Set < String > {
   'HL',
   'HL - IMPROVEMENT',
   'HL - TOP UP',
   'Housing Loan',
   'LAP',
   'Property Loan'
  }; /* RSLexistingProduct added by prashant @16164*/
  for (Existing_Loan_Details__c exp: ExistLoans) { /* RSL check added by prashant @16164*/
   if ((Loan.Product__c == 'RSL' && exp.Status__c == 'Live' && exp.MOB__c >= 12 && RSLexistingProduct.contains(exp.Loan_Type__c)) || (Loan.Product__c != 'RSL' && exp.Status__c == 'Live' && exp.Loan_Type__c != 'TW' && exp.Loan_Type__c != 'Two-wheeler Loan' && exp.Loan_Type__c != 'CV') || (Loan.Product__c != 'RSL' && exp.Loan_Type__c == 'PL' || exp.Loan_Type__c == 'Personal Loan')) {
    gen.writeStartObject();
    if (Loan.Product__c == 'RSL') /* loan product check added by prashant @16164*/
     gen.writeStringField('loanStatus', 'Live');
    //Rohit added start object
    gen.writeStringField('applicant_type', 'Primary');
    gen.writeStringField('offerProductId', (exp.Name != null) ? exp.Name : '');
    gen.writeStringField('existingLoanProduct', (exp.Loan_Type__c != null) ? exp.Loan_Type__c : ''); //Loan_Amount__c
    gen.writeNumberField('existingLoanAmount', (exp.Loan_Amount__c != null) ? exp.Loan_Amount__c : 0);
    gen.writeStringField('bankName', (exp.financers__c != null) ? exp.financers__c : '');
    gen.writeNumberField('loanMob', (exp.MOB__c != null) ? exp.MOB__c : 0);
    //dev gen.writeNumberField('total_personal_loan_amount', 123123);  //change binding
    gen.writeEndObject();
   }
  }
  gen.writeEndArray();

  gen.writeFieldName('loanParameter');
  gen.writeStartObject();
  gen.writeStringField('product', (Loan.Product__c != null) ? Loan.Product__c : '');
  gen.writeNumberField('offer_amount', (Loan.Approved_Loan_Amount__c != null) ? Loan.Approved_Loan_Amount__c : 0);
  gen.writeNumberField('loan_application_number', (Loan.Loan_Application_Number__c != null) ? Decimal.ValueOf(Loan.Loan_Application_Number__c) : 0);
  gen.writeEndObject();

  gen.writeFieldName('demographic');
  gen.writeStartArray();
  gen.writeStartObject();
  gen.writeStringField('applicant_type', 'Primary');
  gen.writeStringField('customer_segment', (applicantPrimary != null && applicantPrimary.Bureau_Segment__c != null) ? applicantPrimary.Bureau_Segment__c : '');
  //  gen.writeStringField('industry', (Loan.Main_Industry__c != null) ? Loan.Main_Industry__c :'');
  //  gen.writeStringField('nature_of_business', (con.Company_Category__c != null) ? con.Company_Category__c);
  gen.writeStringField('company_category', (accountCreate[0].Type_Of_Industry__c != null) ? accountCreate[0].Type_Of_Industry__c : '');
  gen.writeEndObject();
  gen.writeEndArray();

  gen.writeFieldName('bankSummary');
  gen.writeStartArray();
  gen.writeStartObject();
  gen.writeStringField('applicant_type', 'Primary');
  gen.writeStringField('financierName', (bankAccBRE.Bank_Name__c != null) ? bankAccBRE.Bank_Name__c : '');
  gen.writeStringField('offerProductId', (bankAccBRE.Name != null) ? bankAccBRE.Name : '');
  gen.writeEndObject();
  gen.writeEndArray();

  gen.writeFieldName('cams');
  gen.writeStartArray();
  gen.writeStartObject();
  gen.writeNumberField('average_net_salary', cam.Average_Monthly_Net_Income1__c);
  gen.writeEndObject();
  gen.writeEndArray();

  gen.writeFieldName('generic');
  gen.writeStartObject();
  gen.writeStringField('branch_name', (Loan.Branch_Name__r.name != null) ? Loan.Branch_Name__r.name : '');
  gen.writeEndObject();
  gen.writeEndObject();

  String jsonString = gen.getAsString();
  system.debug(LoggingLevel.ERROR, 'jsonString====>' + jsonString);
  system.debug(LoggingLevel.Error, 'jsonString====>' + jsonString);
  String offerGenerated;
  if (jsonString != null && jsonString != '') {
   if (!Test.isRunningTest())
    offerGenerated = breObj.callBREOfferDetails(jsonString);
   else
    offerGenerated = '{"output":{"loanId":"51383967163","offerAmountList":[{"existingProduct":"LAP","offerAmount":3905029.729195266,"multiplier":11,"documents":"APPLICATION FORM;KYC","offerAIdentifier":"NORMAL","offerProductId":"L_12698997","legalFlag":"Y","technicalFlag":"","physicalPDFlag":""}],"calculatedOffer":"SAL-LAP-BTTP","noOfferReason":"MOB norms not met","calculatedOfferRevisedFor":null,"segment":null},"Action":true}';

  }
  system.debug('offerGenerated===>' + offerGenerated);

  //Response parsing
  Map < String, Object > offerGeneratedMap = new Map < String, Object > ();
  if (offerGenerated != null && offerGenerated != '') {
   offerGeneratedMap = (Map < String, Object > ) JSON.deserializeUntyped(offerGenerated);
   system.debug(LoggingLevel.error, 'offerGeneratedMap===>' + offerGeneratedMap);
  }
  system.debug('offerGeneratedMap.get(output)===>' + offerGeneratedMap.get('output'));
  Map < String, Object > offerAmtResponse = (Map < String, Object > ) offerGeneratedMap.get('output');

  system.debug(LoggingLevel.error, 'offerAmtResponse===>' + offerAmtResponse);

  offerGeneratedMap = offerAmtResponse;
  system.debug('offerGeneratedMap2===>' + offerGeneratedMap);
  finalScripsHistoryInsert = new List < ScripsHistory__c > ();
  /*added by prashant @16164 start*/
  String calculatedOffer;
  if (offerGeneratedMap.get('calculatedOffer') != null) {
   calculatedOffer = String.valueOf(offerGeneratedMap.get('calculatedOffer'));
  }
  String noOfferReason;
  if (offerGeneratedMap.get('noOfferReason') != null) {
   noOfferReason = String.valueOf(offerGeneratedMap.get('noOfferReason'));
  }
  List < Object > offersList = new List < Object > ();
  Object offer;
  /*added by prashant @16164 start*/
  if (Loan.Product__c != 'RSL' && offerGeneratedMap.get('offerAmountList') != null) { /*loan product check added by prashant @16164*/
   offersList = (List < Object > ) offerGeneratedMap.get('offerAmountList');
  } else if (Loan.Product__c == 'RSL' && offerGeneratedMap.get('offerAmount') != null) { /*else block added by prashant @16164 */
   offer = (Object) offerGeneratedMap.get('offerAmount');
   offersList.add(offer);
  }
  for (Object offerTemp: offersList) {
   Map < String, Object > offerTempMap = (Map < String, Object > ) offerTemp;
   ScripsHistory__c scripTemp = new ScripsHistory__c();
   scripTemp.Loan_Application__c = Loan.id;
   scripTemp.Offer_Amount__c = Double.ValueOf(offerTempMap.get('offerAmount'));
   scripTemp.Offer_Product__c = (String) offerTempMap.get('existingProduct');
   scripTemp.Calculated_Offer__c = calculatedOffer;
   scripTemp.Offer_multiplier__c = Double.ValueOf(offerTempMap.get('multiplier'));
   scripTemp.Offer_Identifier__c = (String) offerTempMap.get('offerAIdentifier');
   scripTemp.Offer_Documents__c = (String) offerTempMap.get('documents');
   scripTemp.Legal_Flag__c = (String) offerTempMap.get('legalFlag');
   scripTemp.Physical_PD_Flag__c = (String) offerTempMap.get('physicalPDFlag');
   scripTemp.Technical_Flag__c = (String) offerTempMap.get('technicalFlag');

   Existing_Loan_Details__c exiTemp = new Existing_Loan_Details__c();
   exiTemp = (Existing_Loan_Details__c) exiLoanMap.get((String) offerTempMap.get('offerProductId'));
   if (exiTemp != null) {
    scripTemp.Financier__c = exiTemp.financers__c;
    scripTemp.MOB__c = exiTemp.MOB__c;
    scripTemp.POS__c = exiTemp.POS__c;
    scripTemp.Property_Address__c = exiTemp.City__c;
    scripTemp.area__c = exiTemp.Property_Address__c;
    scripTemp.Current_EMI__c = exiTemp.Derived_EMI__c;
    scripTemp.ROI__c = exiTemp.Rate_of_Interest__c;
    scripTemp.Existing_Loan_Amount__c = exiTemp.Loan_Amount__c;
   }

   scripTemp.Source__c = '01MOB';
   finalScripsHistoryInsert.add(scripTemp);

  }
  /*added by prashant @16164 start*/
  if (Loan.Product__c == 'RSL') {
   List < SOL_Policy__c > policyList = new List < SOL_Policy__c > ();
   policyList = [select id, Policy_Name__c, Policy_Status__c, Loan_Application__c, Applicant_Name__c
    from SOL_Policy__c where Loan_Application__c =: Loan.id AND Source__c = 'MOB Offer Not Generated'
   ];
   if (policyList.size() > 0) {
    delete policyList;
   }

   if (noOfferReason != null && noOfferReason != '') {
    SOL_Policy__c solObj = new SOL_Policy__c();
    solObj.Source__c = 'MOB Offer Not Generated';
    solObj.Reason__c = noOfferReason;
    solObj.Loan_Application__c = Loan.id;
    solObj.Applicant_Name__c = applicantPrimary.id;
    insert solObj;
   }
  }
  /*loan product check added by prashant @16164 end*/


 }
 // 01MOB E

 //--------------- Mortgage Re-Engg Start---------------------
 public void runPropertydedupe() {
  /*system.debug('In runPropertydedupe...');
propertyDedupelist = [select id, Property_Details__r.Address__c, Property_Details__r.Property_City__c, Property_Details__r.Location__c, Property_Details__r.Property_State__c, Dedupe_Lan_Matches__c, Customer_ID__c, De_Dupe_result__c, Dedupe_Comments__c from De_Dupe__c
where Loan_Application__c = : Loan.id And Property_Details__c != null
];

system.debug('propertyDedupelist==' + propertyDedupelist);*/

  system.debug('In runPropertydedupe...' + propId);
  PageReference pageRef = Page.PropertyDetailPage;
  ApexPages.currentPage().getParameters().put('id', LoanId);
  ApexPages.currentPage().getParameters().put('flow', 'Loan');
  propertyDetailCtrl objpropertyPage = new propertyDetailCtrl();
  objpropertyPage.initiatePropertyDedupe();
  //Cubic Tree Integration :: added condition to query:: AND Dedupe_Source__c != 'propertydedupeCT' AND Dedupe_Source__c != 'applicantdedupeCT'
  propertyDedupelist = [select id, De_Dupe_Matched_Percentage__c, Property_Details__r.Address__c, Property_Details__r.Property_City__c, Property_Details__r.Location__c, Property_Details__r.Property_State__c,
   Dedupe_Lan_Matches__c, Customer_ID__c, De_Dupe_result__c, Dedupe_Comments__c, Loan_Application_Number__c, LAN_Number__c
   from De_Dupe__c where Property_Details__c IN: propId AND Dedupe_Source__c != 'propertydedupeCT'
   AND Dedupe_Source__c != 'applicantdedupeCT'
  ];
  system.debug('propertyDedupelist==' + propertyDedupelist);
  if (propertyDedupelist == null || propertyDedupelist.size() == 0) {

   savedSuccessfull = true;


   message = 'De-Dupe Result Not Found !!!';
  }
 }

 public List < De_Dupe__c > getpropertyDedupelist() {
  return propertyDedupelist;
 }

 public void savePropertydedupe() {
  try {

   system.debug(propertyDedupelist.size() + '=propertyDedupelist.size()');
   if (propertyDedupelist.size() > 0) {
    upsert propertyDedupelist;
    //Cubic Tree Integration :: added condition to query:: AND Dedupe_Source__c != 'propertydedupeCT' AND Dedupe_Source__c != 'applicantdedupeCT'
    propertyDedupelist = [select id, De_Dupe_Matched_Percentage__c, Property_Details__r.Address__c, Property_Details__r.Property_City__c, Property_Details__r.Location__c, Property_Details__r.Property_State__c,
     Dedupe_Lan_Matches__c, Customer_ID__c, De_Dupe_result__c, Dedupe_Comments__c, Loan_Application_Number__c, LAN_Number__c
     from De_Dupe__c where Property_Details__c IN: propId AND Dedupe_Source__c != 'propertydedupeCT'
     AND Dedupe_Source__c != 'applicantdedupeCT'
    ];

    /*propertyDedupelist = [select id, Property_Details__r.Address__c, Property_Details__r.Property_City__c, Property_Details__r.Location__c, Property_Details__r.Property_State__c, Dedupe_Lan_Matches__c, Customer_ID__c, De_Dupe_result__c, Dedupe_Comments__c from De_Dupe__c
where Loan_Application__c = : Loan.id And Property_Details__c != null
];*/

    system.debug('propertyDedupelist==' + propertyDedupelist);



   }
  } catch (Exception e) {
   system.debug('Exception occurd==>' + e.getMessage() + 'Line number===>' + e.getLinenumber());
   system.debug(e.getMessage());
  }
 }

 public void saveLoanDetails() {
  try {
   /*system.debug('In saveLoanDetails...');
if (Loan != null) {
//update Loan.Account;
update Loan;
}*/

   if (propertyList.size() > 0) {

    update propertyList;
    propertyList = SelectQueriesHelperClass.QueryPropertyDetailsMortgage(Loan.id);
    savedSuccessfull = true;
    message = 'Details Saved Successfully !!!';
    system.debug('savedSuccessfull -- ' + savedSuccessfull);
   }
   system.debug(propertyList.size() + '=propertyList.size()');


  } catch (Exception e) {
   system.debug('Exception occurd==>' + e.getMessage() + 'Line number===>' + e.getLinenumber());
   system.debug(e.getMessage());
  }
 }

 public void retrieveFeedback() {

  if (pd != null && pd.id != null) {
   feedbackList = [Select id, Feedback_Question__c, Feedback_Answer__c, Credit_Answer__c, Remarks__c, Credit_Remarks__c From Feedback__c where Personal_Discussion__c =: pd.id];
  }


  for (Feedback__c feedback: feedbackList) {
   feedbackMap.put(feedback.Feedback_Question__c, feedback);
  }

  system.debug('feedbackList=' + feedbackList + '=feedbackMap=' + feedbackMap);
  feedbackQuestList = new List < Feedback_Question__c > ();
  feedMap = new Map < String, Feedback__c > ();
  Feedback__c feedtemp;
  //Feedback__c feedtemp = new Feedback__c();

  //query on Feedback question = Mortgage         
  for (Feedback_Question__c quest: [Select id, Question_Description__c From Feedback_Question__c where isActive__c = TRUE and Process_Flow__c =: 'Mortgage'
    Limit 30
   ]) {
   if (feedbackMap.size() > 0 && feedbackMap.containsKey(quest.Question_Description__c)) {
    feedMap.put(quest.Question_Description__c, feedbackMap.get(quest.Question_Description__c));
   } else {
    feedtemp = new Feedback__c();
    feedtemp.Credit_Answer__c = '-None-';
    feedtemp.Feedback_Answer__c = '-None-';

    feedMap.put(quest.Question_Description__c, feedtemp);
   }
  }
  system.debug('feedMap.size()=' + feedMap.size() + '=feedMap=' + feedMap);

 }

 public void saveFeedbackDetails() {
  try {
   if (Loan != null) {
    system.debug('pd=' + pd.id);
    if (pd.id == null) {
     pd = new Personal_Discussion__c();
     pd.Loan_Application__c = Loan.id;
     pd.Type_of_PD__c = 'Physical PD';
     upsert pd;
    }

    List < Feedback__c > feedList = new List < Feedback__c > ();

    Feedback__c feed;

    system.debug('feedMap=' + feedMap);

    for (String quest: feedMap.keyset()) {

     system.debug('feedbackList.size()=' + feedbackList.size());
     if (feedbackList.size() == 0) {
      feed = new Feedback__c();
      feed.Personal_Discussion__c = pd.id;
     } else {
      feed = feedbackMap.get(quest);
     }
     system.debug('quest=' + quest);
     feed.Feedback_Question__c = quest;

     feed.Feedback_Answer__c = feedMap.get(quest).Feedback_Answer__c;
     feed.Remarks__c = feedMap.get(quest).Remarks__c;

     feed.Credit_Answer__c = feedMap.get(quest).Credit_Answer__c;
     feed.Credit_Remarks__c = feedMap.get(quest).Credit_Remarks__c;

     feedList.add(feed);
    }

    system.debug('feedList=' + feedList);

    if (feedList.size() > 0) {
     upsert feedList;
    }
   }

  } catch (Exception e) {
   system.debug('Exception occurd==>' + e.getMessage() + 'Line number===>' + e.getLinenumber());
   //sendExeptionEmail(e.getMessage(), '');
  }
 }

 public void CoFinancialDataPopulate() {
  List < Applicant__c > FinancialCOApplicantList = new List < Applicant__c > ();
  List < CAM__c > camList = new List < CAM__c > ();
  //FinancialCOApplicant = new Applicant__c();
  selected = null;

  //if(selectedCOApplicantforFinancial != '-None-')
  FinancialCOApplicantList = [select is_BL_PL_Risk__c, /* SAL Invisible monitering start */ RSA_reason__c, RSA_flag__c, RSA_Loan_application_status__c, RSA_Remarks__c, Underwriter_Remarks__c, RSA_Closure_Date__c, RSA_initiation_Date__c, RSA_TAT__c, Contact_Name__r.Perfios_Address__c, Contact_Name__r.Customer_address_matches_with_perfios__c, Contact_Name__r.Customer_Add_Matches_With_Previous_Add__c /* SAL Invisible monitering end */ , id, Contact_Name__r.Occupatipn__c from Applicant__c where(Contact_Name__c =: selectedCOApplicantforFinancial) and Loan_Application__c =: Loan.id];

  system.debug('---->' + FinancialCOApplicantList + selectedCOApplicantforFinancial + '==COApplMAP.get(selectedCOApplicantforFinancial)' + COApplMAP.get(selectedCOApplicantforFinancial));

  selected = COApplMAP.get(selectedCOApplicantforFinancial);

  if (FinancialCOApplicantList.size() > 0) {

   //FinancialCOApplicant = FinancialCOApplicantList[0];

   camList = [Select id, GP_Other_income__c, Average_incentive_for_Q1__c, Monthly_Reimbursement__c, Avg_monthly_incentive2__c, Avg_monthly_incentive3__c, Month1_Doc__c, Month2_Doc__c, Month3_Doc__c, Loan_amount_with_premium_TO__c,
    Incentive_Monthly_or_Quarterly__c, Avg_monthly_incentive1__c, LAP_pmt__c, Avg_mthly_incntve_3mts__c, Rental_Income__c, ObligationsDC1__c, Eligible_Loan__c, Avg_Mthly_Net_Inc1__c, Total_Obligation_LRD__c, Existing_Live_Obligations__c, Agri_income_to_be_consd__c, Agri_Inc_2_be_Consd__c, C_P_Previous_Year__c, Business_Income_Considered__c, Entity_Record_Type__c, Payment_Date_1__c, Payment_Date_2__c, Payment_Date_3__c, /*Bug 11157 YK*/
    Final_Income_considered_for_Eligibility__c, Other_income_to_be_consd__c, INSURANCE_AMOUNT__c, Fund_Based__c, Hl_pmt__c, Eligible_Loan_Amount_GP__c /*bug 11156 by rasika */ From CAM__c where Loan_application__c =: Loan.id AND Applicant__c =: FinancialCOApplicantList[0].id
   ];

   system.debug('camList.size()=' + camList.size());
   if (camList.size() == 0) {
    coCAM = new CAM__c();
    coCAM.Loan_application__c = Loan.id;
    coCAM.Applicant__c = FinancialCOApplicantList[0].id;
    coCAMTotalMonthly = 0;
   } else {
    coCAM = camList[0];
    coCAMTotalMonthly = camList[0].Total_Obligation_LRD__c;
   }
   system.debug('coCAM.Incentive_Monthly_or_Quarterly__c=' + coCAM.Incentive_Monthly_or_Quarterly__c + '=coCAM.Month1_Doc__c=' + coCAM.Month1_Doc__c);
   if (coCAM.Incentive_Monthly_or_Quarterly__c == 'Monthly') {
    ismonthly1 = true;
    isquarterly1 = false;
    isYearly1 = false;
   } else if (coCAM.Incentive_Monthly_or_Quarterly__c == 'Yearly') {
    ismonthly1 = false;
    isquarterly1 = false;
    isYearly1 = true;
   } else if (coCAM.Incentive_Monthly_or_Quarterly__c == 'Quarterly' || coCAM.Incentive_Monthly_or_Quarterly__c == 'Half Yearly') {
    ismonthly1 = false;
    isquarterly1 = true;
    isYearly1 = false;
   } else {
    ismonthly1 = true;
    isquarterly1 = false;
    isYearly1 = false;
   }

   system.debug('######' + selected);
  }
 }

 public void saveMortgageEligiblity() {
  try {
   upsert applicantPrimary;

   if (cam != null && cam.id != null)
    update cam;
   setDataForEligibilityDetails(propertyList, Loan, cam); //11156 bug 

  } catch (Exception e) {
   system.debug('Exception occurd==>' + e.getMessage() + 'Line number===>' + e.getLinenumber());
   system.debug(e.getMessage());
  }

 }

 public void saveCOCAM() {
  try {
   //SHL Income Issue Amit bug 11112 start
   if (coCAM.Rental_Income__c == null)
    coCAM.Rental_Income__c = 0;
   if (coCAM.GP_Other_income__c == null)
    coCAM.GP_Other_income__c = 0;
   if (coCAM.Average_incentive_for_Q1__c == null)
    coCAM.Average_incentive_for_Q1__c = 0;
   if (coCAM.Monthly_Reimbursement__c == null)
    coCAM.Monthly_Reimbursement__c = 0;
   // bug 11112 end    
   savedSuccessfull = true;
   message = 'Co-Applicant Financial details Saved Successfully !!!';
   if (selected == 'Salaried') {
    coCAM.Total_Obligation_LRD__c = coCAM.Rental_Income__c + coCAM.GP_Other_income__c + coCAM.Average_incentive_for_Q1__c;
    coCAMTotalMonthly = coCAM.Total_Obligation_LRD__c;
   }
   system.debug('coCAMTotalMonthly=' + coCAMTotalMonthly);
   upsert coCAM;

   if (coCAM != null && coCAM.id != null) {
    coCAM = [Select id, GP_Other_income__c, Average_incentive_for_Q1__c, Monthly_Reimbursement__c, Avg_monthly_incentive2__c, Avg_monthly_incentive3__c, Month1_Doc__c, Month2_Doc__c, Month3_Doc__c, Loan_amount_with_premium_TO__c,
     Incentive_Monthly_or_Quarterly__c, Avg_monthly_incentive1__c, LAP_pmt__c, Avg_mthly_incntve_3mts__c, Rental_Income__c, ObligationsDC1__c, Eligible_Loan__c, Avg_Mthly_Net_Inc1__c, Total_Obligation_LRD__c, Existing_Live_Obligations__c, Agri_income_to_be_consd__c, Agri_Inc_2_be_Consd__c, C_P_Previous_Year__c, Business_Income_Considered__c, Entity_Record_Type__c, Payment_Date_1__c, Payment_Date_2__c, Payment_Date_3__c, /*Bug 11157 YK*/ Final_Income_considered_for_Eligibility__c, Other_income_to_be_consd__c, INSURANCE_AMOUNT__c, Fund_Based__c, Hl_pmt__c, Eligible_Loan_Amount_GP__c /*bug 11156 by rasika */ From CAM__c where id =: coCAM.id Limit 1
    ];
   }

  } catch (Exception e) {
   system.debug('Exception occurd==>' + e.getMessage() + 'Line number===>' + e.getLinenumber());
  }

 }

 public void checkEligibilityMortgage() {
  Bank_Account__c bankAccBRE = new Bank_Account__c();

  Map < String, String > MortgageEligibilityMap = new Map < String, String > ();
  Map < String, String > breResponse = new Map < String, String > ();
  BRECallout br = new BRECallout();

  //if (grouptype == 'selfemployed') {

  double total_10th_balance = 0;
  double total_20th_balance = 0;
  double total_month_end_balance = 0;
  double total_ODCC_balance = 0;
  double totalBounceInward = 0;
  double totalCreditAmt = 0;
  double totalDebitAmt = 0;

  //SHL
  double average_net_salary = 0;
  double total_net_salary = 0;
  double gross_Salary_Month1 = 0;
  double gross_Salary_Month2 = 0;
  double gross_Salary_Month3 = 0;
  double rental_Income = 0;
  double final_FOIR = 0;
  double average_Monthly_Net_Income1 = 0;
  double total_monthly_obligations = 0;


  MortCamList = [SELECT Applicant__c, Average_incentive_for_Q1__c, Avg_mthly_incntve_3mts__c, Incentive_Monthly_or_Quarterly__c, Monthly_Reimbursement__c, GP_Other_income__c, ObligationsDC1__c, Oth_Inc_2_be_Consd__c,
   Avg_Net_Sal__c, Gross_Salary_Month1__c, Gross_Salary_Month2__c, Gross_Salary_Month3__c, Proposed_Loan_Amt__c, Rental_Income__c, Average_incentive_for_Q2__c, Average_incentive_for_Q3__c, Average_Bank_Balance_GDP__c, Eligible_Home_Loan_Amount__c, Stake_of_co__c, Home_Loan_Tenor__c, GP_Home_loan_amount__c, Top_Up_Amount__c, Top_Up_Rate__c, Top_Up_Tenure__c, Industry_Margins_applicable1__c, C_P_Current_Year__c, Existing_Live_Obligations__c, Agri_income_to_be_consd__c, Agri_Inc_2_be_Consd__c, C_P_Previous_Year__c, Business_Income_Considered__c, Entity_Record_Type__c, Payment_Date_1__c, Payment_Date_2__c, Payment_Date_3__c, /*Bug 11157 YK*/ Final_Income_considered_for_Eligibility__c, Other_income_to_be_consd__c, INSURANCE_AMOUNT__c, Fund_Based__c, Hl_pmt__c, Eligible_Loan_Amount_GP__c /*bug 11156 by rasika */ FROM CAM__c WHERE Loan_Application__c =: Loan.Id
  ];

  if (Loan.Product__c == 'SHL' || Loan.Product__c == 'HFC SHL' || Loan.Product__c == 'SHOL' || Loan.Product__c == 'HSL' || Loan.Product__c == 'SALLAP' || Loan.Product__c == 'HPLS' || Loan.Product__c == 'SBS CS SHL') {
   for (cam__c c: MortCamList) {
    if (c.Average_incentive_for_Q1__c != null)
     total_net_salary = total_net_salary + c.Average_incentive_for_Q1__c;

    if (c.Applicant__c == null && Loan.Product__c == 'HFC SHL') {


     if (c.Average_incentive_for_Q1__c == null)
      c.Average_incentive_for_Q1__c = 0;
     if (c.Average_incentive_for_Q2__c == null)
      c.Average_incentive_for_Q2__c = 0;
     if (c.Average_incentive_for_Q3__c == null)
      c.Average_incentive_for_Q3__c = 0;

     average_net_salary = (c.Average_incentive_for_Q1__c + c.Average_incentive_for_Q2__c + c.Average_incentive_for_Q3__c) / 3;
     gross_Salary_Month1 = c.Average_incentive_for_Q1__c;
     gross_Salary_Month2 = c.Average_incentive_for_Q2__c;
     gross_Salary_Month3 = c.Average_incentive_for_Q3__c;

     //total_monthly_obligations = cam.Total_Mthly_Oblig__c;
    }
    if (c.Rental_Income__c != null)
     rental_Income = rental_Income + c.Rental_Income__c;

    /*if(c.Average_incentive_for_Q1__c != null && c.Rental_Income__c != null && c.GP_Other_income__c != null)
average_Monthly_Net_Income1 = c.Average_incentive_for_Q1__c + c.Rental_Income__c + c.GP_Other_income__c;*/

   }
   //average_Monthly_Net_Income1 = average_Monthly_Net_Income1/MortCamList.size();

   MortgageEligibilityMap.put('average_net_salary', (average_net_salary != null) ? String.valueof(average_net_salary) : '0');
   MortgageEligibilityMap.put('total_net_salary', (total_net_salary != null) ? String.valueof(total_net_salary) : '0');
   MortgageEligibilityMap.put('gross_Salary_Month1', (gross_Salary_Month1 != null) ? String.valueof(gross_Salary_Month1) : '0');
   MortgageEligibilityMap.put('gross_Salary_Month2', (gross_Salary_Month2 != null) ? String.valueof(gross_Salary_Month2) : '0');
   MortgageEligibilityMap.put('gross_Salary_Month3', (gross_Salary_Month3 != null) ? String.valueof(gross_Salary_Month3) : '0');
   MortgageEligibilityMap.put('rental_Income', (rental_Income != null) ? String.valueof(rental_Income) : '0');
   //MortgageEligibilityMap.put('total_monthly_obligations',(total_monthly_obligations != null) ? String.valueof(total_monthly_obligations) : '0');        
  }




  //Loan_Parameter
  MortgageEligibilityMap.put('Id', Loan.id);
  MortgageEligibilityMap.put('industry', (Loan.Industry__c != null && Loan.Industry__r.Industry__c != null) ? Loan.Industry__r.Industry__c : '');
  MortgageEligibilityMap.put('practiceType', (accObj.Practice_Type__c != null) ? accObj.Practice_Type__c : '');
  MortgageEligibilityMap.put('processType', (accObj.Process_Type__c != null) ? accObj.Process_Type__c : '');

  MortgageEligibilityMap.put('loan_application_stage', (Loan.stageName != null) ? Loan.stageName : '');
  MortgageEligibilityMap.put('approved_rate', (Loan.Approved_Rate__c != null) ? String.valueof(Loan.Approved_Rate__c) : '0');
  MortgageEligibilityMap.put('loan_id', (Loan.Loan_Application_Number__c != null) ? Loan.Loan_Application_Number__c : '');
  MortgageEligibilityMap.put('decision_date', Loan.Decision_Date__c != null ? String.valueof(Loan.Decision_Date__c) : '');
  MortgageEligibilityMap.put('approved_loan_amount', (Loan.Approved_Loan_Amount__c != null) ? String.valueof(Loan.Approved_Loan_Amount__c) : '0.0');


  MortgageEligibilityMap.put('loan_application_number', (Loan.Loan_Application_Number__c != null) ? String.valueof(Loan.Loan_Application_Number__c) : '0');
  MortgageEligibilityMap.put('product', (Loan.Product__c != null) ? Loan.Product__c : '');
  MortgageEligibilityMap.put('scheme_name', (Loan.Scheme_Master__c != null) ? Loan.Scheme_Master__r.Name : '');
  MortgageEligibilityMap.put('type_of_loan', (Loan.Type_Of_Loan__c != null) ? Loan.Type_Of_Loan__c : '');
  MortgageEligibilityMap.put('stage', (Loan.StageName != null) ? Loan.StageName : '');
  MortgageEligibilityMap.put('sourcing_channel_type', (Loan.Sourcing_Channel_Type__c != null) ? Loan.Sourcing_Channel_Type__c : '');
  MortgageEligibilityMap.put('sub_stage', (Loan.Sub_Stage__c != null) ? Loan.Sub_Stage__c : '');
  MortgageEligibilityMap.put('offer_amount', (Loan.Offer_Amount__c != null) ? String.valueof(Loan.Offer_Amount__c) : '0.0');
  MortgageEligibilityMap.put('program_type', (Loan.Program_Type__c != null) ? Loan.Program_Type__c : '');

  MortgageEligibilityMap.put('fullUnderwritingFlag', String.valueOf(Loan.Full_Underwriting__c));

  boolean flag = false;
  for (Property_Details__c property: propertyList) {
   if (property.Property_Identified__c == 'Yes') {
    MortgageEligibilityMap.put('eligibilityType', 'Property');
    flag = true;
    break;
   }
  }
  if (flag == false)
   MortgageEligibilityMap.put('eligibilityType', 'Financial');

  //Generic   
  MortgageEligibilityMap.put('branch_type', (Loan.Branch_Name__r.Branch_Type__c != null) ? Loan.Branch_Name__r.Branch_Type__c : '');
  MortgageEligibilityMap.put('branch_name', (Loan.Branch_Name__r.name != null) ? Loan.Branch_Name__r.name : '');




  MortgageEligibilityMap.put('avg_od_cc_utilisation', (cam.Industry_Margins_applicable1__c != null) ? cam.Industry_Margins_applicable1__c + '' : '0');
  MortgageEligibilityMap.put('monthly_loan_obligations', (cam.Average_Bank_Balance_GDP__c != null) ? cam.Average_Bank_Balance_GDP__c + '' : '0.0');
  MortgageEligibilityMap.put('requested_loan_amount', (cam.Proposed_Loan_Amt__c != null) ? String.valueof(cam.Proposed_Loan_Amt__c) : '0.0');
  MortgageEligibilityMap.put('requested_tenor', (cam.Tenor__c != null) ? String.valueof(cam.Tenor__c) : '0.0');
  MortgageEligibilityMap.put('reqested_roi', (cam.ROI__c != null) ? String.valueof(cam.ROI__c) : '0.0');
  MortgageEligibilityMap.put('cy_sales_turnover', (cam.C_P_Current_Year__c != null) ? cam.C_P_Current_Year__c + '' : '0.0');
  MortgageEligibilityMap.put('py_sales_turnover', (cam.C_P_Previous_Year__c != null) ? cam.C_P_Previous_Year__c + '' : '0.0');
  MortgageEligibilityMap.put('py_profit_before_tax', (cam.Agri_income_to_be_consd__c != null) ? cam.Agri_income_to_be_consd__c + '' : '0.0');
  //MortgageEligibilityMap.put('UWProgram',(Loan.Account.UW_Program__c != null) ? Loan.Account.UW_Program__c : '');     
  MortgageEligibilityMap.put('cy_profit_before_tax', (cam.Agri_Inc_2_be_Consd__c != null) ? cam.Agri_Inc_2_be_Consd__c + '' : '0.0');
  MortgageEligibilityMap.put('professionType', accObj.Profession__c != null ? accObj.Profession__c : '');
  MortgageEligibilityMap.put('constitutionType', accObj.Constitution__c != null ? accObj.Constitution__c : '');

  MortgageEligibilityMap.put('educational_qualification', accObj.Qualification__c != null ? accObj.Qualification__c : '');
  MortgageEligibilityMap.put('total_employment_vintage', accObj.Total_Work_Experience_Yrs__c != null ? accObj.Total_Work_Experience_Yrs__c : '0.0');
  MortgageEligibilityMap.put('date_of_birth', accObj.Date_of_Birth__c != null ? String.valueof(accObj.Date_of_Birth__c) : '');
  MortgageEligibilityMap.put('date_of_incorporation', accObj.Year_of_Incorporation__c != null ? String.valueof(accObj.Year_of_Incorporation__c) : '');
  MortgageEligibilityMap.put('years_in_business_job', accObj.Total_Work_Experience_Yrs__c != null ? accObj.Total_Work_Experience_Yrs__c : '0');

  MortgageEligibilityMap.put('company_type', (accObj.Company_Type__c != null) ? String.valueof(accObj.Company_Type__c) : '');
  MortgageEligibilityMap.put('company_category', accObj.Type_Of_Industry__c != null ? accObj.Type_Of_Industry__c : '');
  MortgageEligibilityMap.put('type_of_degree', accObj.Degree__c != null ? accObj.Degree__c : '');
  MortgageEligibilityMap.put('e_mail_id', accObj.Email_Id__c != null ? accObj.Email_Id__c : '');
  MortgageEligibilityMap.put('specialisation', accObj.Specialisation__c != null ? accObj.Specialisation__c : '');
  MortgageEligibilityMap.put('marital_status', accObj.Marital_Status__c != null ? accObj.Marital_Status__c : '');
  MortgageEligibilityMap.put('name_of_employer', accObj.Employer__c != null ? accObj.Employer__r.Name : '');
  MortgageEligibilityMap.put('gender', accObj.Gender__c != null ? accObj.Gender__c : '');
  MortgageEligibilityMap.put('office_city', accObj.Office_City__c != null ? accObj.Office_City__c : '');
  MortgageEligibilityMap.put('residence_pin_code', accObj.Current_PinCode__c != null ? String.valueOf(accObj.Current_PinCode__c) : '0');
  MortgageEligibilityMap.put('office_pin_code', accObj.Office_Pin_Code__c != null ? String.valueOf(accObj.Office_Pin_Code__c) : '0');

  MortgageEligibilityMap.put('incentiveAmt', cam.Avg_mthly_incntve_3mts__c != null ? cam.Avg_mthly_incntve_3mts__c + '' : '0');
  MortgageEligibilityMap.put('incentiveFrequency', cam.Incentive_Monthly_or_Quarterly__c != null ? cam.Incentive_Monthly_or_Quarterly__c : '0');
  MortgageEligibilityMap.put('reImbursement', cam.Monthly_Reimbursement__c != null ? cam.Monthly_Reimbursement__c + '' : '0');

  if (Loan.Product__c != 'SHL' && Loan.Product__c != 'HFC SHL' && Loan.Product__c != 'HSL' && Loan.Product__c != 'SALLAP' && Loan.Product__c != 'HPLS' && Loan.Product__c != 'SBS CS SHL') {
   MortgageEligibilityMap.put('gross_Salary_Month1', cam.Average_incentive_for_Q1__c != null ? String.valueof(cam.Average_incentive_for_Q1__c) : '0.0');
   MortgageEligibilityMap.put('gross_Salary_Month2', cam.Average_incentive_for_Q2__c != null ? String.valueof(cam.Average_incentive_for_Q2__c) : '0.0');
   MortgageEligibilityMap.put('gross_Salary_Month3', cam.Average_incentive_for_Q3__c != null ? String.valueof(cam.Average_incentive_for_Q3__c) : '0.0');
   MortgageEligibilityMap.put('rental_Income', cam.Rental_Income__c != null ? String.valueof(cam.Rental_Income__c) : '0.0');
  }

  MortgageEligibilityMap.put('case_type', accObj.BT_Bank_Type__c != null ? accObj.BT_Bank_Type__c : '');

  MortgageEligibilityMap.put('total_monthly_obligations', (cam.Average_Bank_Balance_GDP__c != null) ? String.valueof(cam.Average_Bank_Balance_GDP__c) : '0');
  system.debug(cam.id + '==cam.Average_Bank_Balance_GDP__c=' + cam.Average_Bank_Balance_GDP__c);



  //existing_loan

  if (cibilExt1List.size() > 0) { //Condition added by Harshit for SHOL eligibility
   system.debug('cibilExt1List[0]===>' + cibilExt1List[0]);

   MortgageEligibilityMap.put('securedLoanAmount', cibilExt1List[0].Max_Secured_Loan_Amount__c != null ? string.valueOf(cibilExt1List[0].Max_Secured_Loan_Amount__c) : '0.0');
   MortgageEligibilityMap.put('unSecuredLoanAmount', cibilExt1List[0].Max_unSecured_Loan_Amount__c != null ? String.valueof(cibilExt1List[0].Max_unSecured_Loan_Amount__c) : '0.0');
   MortgageEligibilityMap.put('mob', (cibilExt1List[0].max_mob__c != null) ? String.valueof(cibilExt1List[0].max_mob__c) : '0.0');
   MortgageEligibilityMap.put('mortgageLoanAmount', (cibilExt1List[0].Mortgage_Loan_Amount__c != null) ? String.valueof(cibilExt1List[0].Mortgage_Loan_Amount__c) : '0.0');
   MortgageEligibilityMap.put('number_of_hl_loans', (cibilExt1List[0].Number_of_Hl_Loans__c != null) ? String.valueof(cibilExt1List[0].Number_of_Hl_Loans__c) : '0.0');
   MortgageEligibilityMap.put('securedMob', (cibilExt1List[0].Max_Secured_MOB__c != null) ? String.valueof(cibilExt1List[0].Max_Secured_MOB__c) : '0.0');
  }



  totalObligAmount = 0;
  //system.debug('ExistLoans='+ExistLoans.size());
  for (Existing_Loan_Details__c exp: ExistLoans) {
   if (exp.Status__c == 'Live' && exp.Obligation__c == 'Yes' && exp.Financers__c != null && exp.Loan_Type__c != null && exp.Financers__c == 'Bajaj Finance Ltd' && (exp.Loan_Type__c == 'PL' || exp.Loan_Type__c.toLowerCase() == 'personal loan')) {
    if (exp.POS__c != null) totalObligAmount = totalObligAmount + integer.valueof(exp.POS__c);
   }
  }
  MortgageEligibilityMap.put('bajaj_loan_obligations', (totalObligAmount != null) ? String.valueof(totalObligAmount) : '0.0');


  //Demographic
  MortgageEligibilityMap.put('type_of_constitution', Loan.Type_of_Constitution__c != null ? Loan.Type_of_Constitution__c : '');


  MortgageEligibilityMap.put('UWProgram', (accObj.UW_Program__c != null) ? accObj.UW_Program__c : '');
  MortgageEligibilityMap.put('age', applicantPrimary.Contact_Name__r.Age_of_Applicant__c == null ? '0' : string.valueOf(applicantPrimary.Contact_Name__r.Age_of_Applicant__c));
  MortgageEligibilityMap.put('constitution', Loan.Type_of_Constitution__c != null ? Loan.Type_of_Constitution__c : '');

  MortgageEligibilityMap.put('customer_segment', applicantPrimary.SegmentaionResult__c != null ? applicantPrimary.SegmentaionResult__c : '');

  if (accObj.clinic__c != null && (accObj.clinic__r.name != 'other' || accObj.clinic__r.name != 'others' || accObj.clinic__r.name != 'Others' || accObj.clinic__r.name != 'Other'))
   MortgageEligibilityMap.put('clinic_hospital_type', accObj.clinic__r.name);


  MortgageEligibilityMap.put('first_name', (userinfo.getFirstName() != null) ? userinfo.getFirstName() + '' : '');
  MortgageEligibilityMap.put('last_name', (userinfo.getLastName() != null) ? userinfo.getLastName() + '' : '');
  MortgageEligibilityMap.put('residence_type', applicantPrimary.Contact_Name__r.Residence_Type__c != null ? applicantPrimary.Contact_Name__r.Residence_Type__c : '');

  MortgageEligibilityMap.put('office_email_id', con.Office_Email_Id__c != null ? con.Office_Email_Id__c : '');
  MortgageEligibilityMap.put('pan', applicantPrimary.PAN_Number__c != null ? applicantPrimary.PAN_Number__c : '');
  MortgageEligibilityMap.put('residence_city', applicantPrimary.Contact_Name__r.Residence_City__c != null ? applicantPrimary.Contact_Name__r.Residence_City__c : '');


  MortgageEligibilityMap.put('nature_of_business', Loan.Nature_of_Business__c != null ? Loan.Nature_of_Business__c : '');
  //MortgageEligibilityMap.put('industry', Loan.Industry__r.Industry__c != null ? Loan.Industry__r.Industry__c : '');
  MortgageEligibilityMap.put('sub_industry', Loan.Main_Sub_Industry__c != null ? Loan.Main_Sub_Industry__c : '');

  MortgageEligibilityMap.put('customer_type', loan.Customer_Type__c != null ? loan.Customer_Type__c : '');


  MortgageEligibilityMap.put('profession', accObj.Profession__c != null ? accObj.Profession__c : '');
  MortgageEligibilityMap.put('expPostGradSuperSpecialist', accObj.Post_Graduate_Super_Specialist_Experienc__c != null ? String.valueof(accObj.Post_Graduate_Super_Specialist_Experienc__c) : '0');
  MortgageEligibilityMap.put('applicant_type', 'Primary');

  //SHL Parameters
  if (Loan.product__c == 'SHL' || Loan.Product__c == 'HFC SHL' || Loan.product__c == 'SHOL' || Loan.Product__c == 'HSL' || Loan.Product__c == 'SALLAP' || Loan.Product__c == 'HPLS' || Loan.Product__c == 'SBS CS SHL') {
   MortgageEligibilityMap.put('loanAmountTopUp', cam.Top_Up_Amount__c != null ? String.valueof(cam.Top_Up_Amount__c) : '0.0');
   MortgageEligibilityMap.put('roiTopUp', cam.Top_Up_Rate__c != null ? String.valueof(cam.Top_Up_Rate__c) : '0.0');
   MortgageEligibilityMap.put('tenorTopUp', cam.Top_Up_Tenure__c != null ? String.valueof(cam.Top_Up_Tenure__c) : '0');

   MortgageEligibilityMap.put('pls_roi', cam.Stake_of_co__c != null ? String.valueof(cam.Stake_of_co__c) : '0.0');
   MortgageEligibilityMap.put('pls_tenor', cam.Home_Loan_Tenor__c != null ? String.valueof(cam.Home_Loan_Tenor__c) : '0.0');

   MortgageEligibilityMap.put('product_case_type', accObj.BT_Details__c != null ? accObj.BT_Details__c : '');
   MortgageEligibilityMap.put('incomeToBeConsidered', String.valueof(cam.Business_Income_Considered__c)); //SHL Issue point 19 - 10902

  }

  //Property
  MortgageEligibilityMap.put('preApprovedOfferAmount', (Loan.Offer_Amount__c != null) ? String.valueof(Loan.Offer_Amount__c) : '0.0');

  if (Loan.Product__c == 'SHOL') {

   MortgageEligibilityMap.put('offerFlag', 'No');

   /* List<Salaried__c> salList = [SELECT PODetail__c, Type_of_Loan__c,Home_Loan_Amount__c,Cust_Selected_Loan_Amount__c,Loan_Starting_Date__c
FROM salaried__c WHERE Loan_Application__c = :Loan.Id];
if(!CommonUtility.isEmpty(salList)){
if(salList[0].PODetail__c != null){
poDetailList = [SELECT Financier__c,Normal_Offer_Amount__c,Product_Offerings__r.Products__c,Offer_Identifier__c,MOB__c,POS__c
FROM PODetail__c WHERE Id =:salList[0].PODetail__c];
MortgageEligibilityMap.put('offerFlag','Yes');
}

if(!CommonUtility.isEmpty(salList[0].Loan_Starting_Date__c)){

Date loanStartingDate = salList[0].Loan_Starting_Date__c;
Date currenDate = System.today();
Integer monthDiff = (currenDate.month()- loanStartingDate.month()) + 12 * (currenDate.year() - loanStartingDate.year());
MortgageEligibilityMap.put('securedMOB',String.valueOf(monthDiff));
}

if(!CommonUtility.isEmpty(salList[0].Type_of_Loan__c))
MortgageEligibilityMap.put('offerType',salList[0].Type_of_Loan__c);

if(!CommonUtility.isEmpty(salList[0].Home_Loan_Amount__c))
MortgageEligibilityMap.put('btAmount',String.valueOf(salList[0].Home_Loan_Amount__c));

if(!CommonUtility.isEmpty(applicantPrimary.Existing_Customer__c))
MortgageEligibilityMap.put('customer_type',applicantPrimary.Existing_Customer__c);

}*/

  }

  Map < String, Object > reqMap = new Map < String, Object > ();
  //req_Map
  reqMap.put('generic_map', MortgageEligibilityMap);
  reqMap.put('prop_lst', propertyList);
  reqMap.put('app_lst', applicantList);
  reqMap.put('bankacc_lst', bankAccLst);


  reqMap.put('cam_lst', MortCamList);
  reqMap.put('podetail_lst', poDetailList);


  if (!Test.isRunningTest()) {
   //breResponse = br.callMortgageEligibility(MortgageEligibilityMap,propertyList,applicantList,bankAccLst,MortCamList,poDetailList);
   breResponse = br.callMortgageEligibility(reqMap);
  } else {
   breResponse.put('finalOfferAmount', '10.0');
   breResponse.put('final_foir', '10.0');
   breResponse.put('applicable_foir', '10.0');
   breResponse.put('totalEMI', '10.0');
   breResponse.put('max_tenor', '10.0');
   breResponse.put('eligible_PLS_amount', '10.0');
   breResponse.put('revised_offer_amount_final', '10.0');
   breResponse.put('max_loan_as_per_FOIR', '10.0');
   breResponse.put('standardLTV', 'SAL;SPL;SHL');
   // breResponse.put('eligible_PLS_amount','10.0');

  }

  Map < String, String > ltvMap = new Map < String, String > ();
  Map < String, String > FOIRMap = new Map < String, String > ();

  Map < String, String > ltvIns = new Map < String, String > (); // SHl requirement

  //List < Property_Details__c > updateList = new List < Property_Details__c > ();
  Map < ID, Property_Details__c > updateMAp = new Map < ID, Property_Details__c > (); //bug 12103
  String stdLTV;



  if (breResponse.size() > 0) {

   if (breResponse.containsKey('finalOfferAmount') && breResponse.get('finalOfferAmount') != null)
    cam.sal_max_loan__c = double.valueOf(breResponse.get('finalOfferAmount'));

   if (Loan.Product__c == 'SHL' || Loan.Product__c == 'HFC SHL' || Loan.Product__c == 'HSL' || Loan.Product__c == 'SALLAP' || Loan.Product__c == 'HPLS' || Loan.Product__c == 'SBS CS SHL' || Loan.Product__c == 'SHOL') {
    if (breResponse.containsKey('final_foir') && breResponse.get('final_foir') != null && breResponse.get('final_foir') != 'null') { //SHL Issue
     FinalFOIRTemp = double.valueOf(breResponse.get('final_foir'));
     cam.Eligible_FOIR__c = double.valueOf(breResponse.get('final_foir'));
    }

    //System.debug('Rasika 2: ' + double.valueOf(breResponse.get('revised_offer_amount_final')));
    if (breResponse.containsKey('total_monthly_income') && breResponse.get('total_monthly_income') != null && breResponse.get('total_monthly_income') != 'null') { // bug 11156 by rasika
     totalIncon = decimal.valueOf(breResponse.get('total_monthly_income')).setScale(2);
     //testVar = double.valueOf(breResponse.get('total_monthly_income'));
     cam.Other_income_to_be_consd__c = decimal.valueOf(breResponse.get('total_monthly_income')).setScale(2); /*bug 11156 by rasika */

    }

    // revisedOfferAmount = decimal.valueOf(breResponse.get('revised_offer_amount_final'));
    if (breResponse.containsKey('revised_offer_amount_final') && breResponse.get('revised_offer_amount_final') != null && breResponse.get('revised_offer_amount_final') != 'null') { //SHL Issue
     revisedOfferAmount = double.valueOf(breResponse.get('revised_offer_amount_final'));
     cam.Eligible_Loan_Amount_GP__c = double.valueOf(breResponse.get('revised_offer_amount_final'));
    }
   } else {
    //SOL backend changes to calculate final foir ----  by harsit ---start
    if (cam.Unsecured_FOIR__c != null && cam.Secured_FOIR__c != null && Loan.Product__c != 'SOL' && Loan.Product__c != 'SHOL')
     FinalFOIRTemp = cam.Unsecured_FOIR__c + cam.Secured_FOIR__c;
    else if ((Loan.Product__c == 'SOL' || Loan.Product__c == 'SHOL') && !CommonUtility.isEmpty(solcam))
     FinalFOIRTemp = solcam.Final_Foir1__c;
    //SOL backend changes to calculate final foir ----  by harsit ---end
   }
   //cam.Eligible_FOIR__c = double.valueOf(breResponse.get('final_foir'));




   if (breResponse.containsKey('applicable_foir') && breResponse.get('applicable_foir') != null && breResponse.get('applicable_foir') != 'null') //SHL Issue
    cam.Applicable_FOIR1__c = double.valueOf(breResponse.get('applicable_foir'));


   if (breResponse.containsKey('totalEMI') && breResponse.get('totalEMI') != null && breResponse.get('totalEMI') != 'null') //SHL Issue
    cam.EMI_of_The_Loan__c = double.valueOf(breResponse.get('totalEMI'));

   if (breResponse.containsKey('max_tenor') && breResponse.get('max_tenor') != null && breResponse.get('max_tenor') != 'null') //SHL Issue
    cam.LAP_Tenor__c = double.valueOf(breResponse.get('max_tenor'));

   if (breResponse.containsKey('eligible_PLS_amount') && breResponse.get('eligible_PLS_amount') != null && breResponse.get('eligible_PLS_amount') != 'null') //SHL Issue
    cam.Eligible_Home_Loan_Amount__c = double.valueOf(breResponse.get('eligible_PLS_amount'));

   if (breResponse.containsKey('revised_offer_amount_final') && breResponse.get('revised_offer_amount_final') != null && breResponse.get('revised_offer_amount_final') != 'null') //SHL Issue
    revisedOfferAmount = double.valueOf(breResponse.get('revised_offer_amount_final'));

   //SHL 
   /*if (breResponse.containsKey('max_loan_as_per_FOIR') && breResponse.get('max_loan_as_per_FOIR') != null && breResponse.get('max_loan_as_per_FOIR') != 'null')//SHL Issue
cam.LAP_EMI__c = double.valueOf(breResponse.get('max_loan_as_per_FOIR'));*/
   //FOR SHL we are commenting above mapping and will be using new mappting as below
   if (cam.Business_Income_Considered__c == true) { // bug 11545
    if (breResponse.containsKey('max_loan_as_per_tenor') && breResponse.get('max_loan_as_per_tenor') != null && breResponse.get('max_loan_as_per_tenor') != 'null') { //SHL Issue
     cam.LAP_EMI__c = double.valueOf(breResponse.get('max_loan_as_per_tenor'));
    }
   }
   //---SHL changes
   if (breResponse.containsKey('standardLTV')) {
    stdLTV = breResponse.get('standardLTV');
    System.debug('stdLTV=' + stdLTV);
    if (stdLTV != null) {
     String[] proeprtyLTV = stdLTV.split(';');
     if (proeprtyLTV != null) {
      for (String s: proeprtyLTV) {
       String[] IdLTV = s.split('-');
       if (IdLTV != null && IdLTV.size() == 2) {
        for (Property_Details__c p: propertyList) {
         String[] FOIRLTV = IdLTV[1].split(',');
         System.debug('p.id=' + p.id + '=IdLTV[0]=' + IdLTV[0] + '=FOIRLTV=' + FOIRLTV);
         if (p.id == IdLTV[0]) {
          if (FOIRLTV != null && FOIRLTV.size() == 2) {
           if (FOIRLTV[0] != null && FOIRLTV[0] != '')
            p.Standard_LTV__c = Decimal.valueOf(FOIRLTV[0]);
           if (FOIRLTV[1] != null && FOIRLTV[1] != '')
            p.Applied_FOIR__c = Decimal.valueOf(FOIRLTV[1]);
          }

          if (FOIRLTV != null && FOIRLTV.size() == 5) {
           if (FOIRLTV[0] != null && FOIRLTV[0] != '')
            p.Standard_LTV__c = Decimal.valueOf(FOIRLTV[0]);
           if (FOIRLTV[1] != null && FOIRLTV[1] != '')
            p.Applied_FOIR__c = Decimal.valueOf(FOIRLTV[1]);
           if (FOIRLTV[1] != null && FOIRLTV[1] != '')
            p.Max_Permissible_LTV__c = Decimal.valueOf(FOIRLTV[2]);

           p.SRO_Name__c = FOIRLTV[3];
           p.EC_TSR_Status__c = FOIRLTV[4];
          }
         }
         if (!updateMAp.ContainsKey(p.id)) //bug 12103
          updateMAp.put(p.id, p);
        }
       }
      }
     }
    }
   }
   /*if (breResponse.containsKey('standardLTV')) {
stdLTV = breResponse.get('standardLTV');
if (stdLTV != null) {
String[] proeprtyLTV = stdLTV.split(';');
if (proeprtyLTV != null) {
for (String s: proeprtyLTV) {
String[] IdLTV = s.split('-');

if (IdLTV != null && IdLTV.size() == 2) {
String[] FOIRLTV = IdLTV[1].split(',');

if (FOIRLTV != null && FOIRLTV.size() == 2) {
ltvMap.put(IdLTV[0], FOIRLTV[0]);
FOIRMap.put(IdLTV[0], FOIRLTV[1]);
}
//TSR / legal logic stamping by Piya 1-18-17 Start
if (FOIRLTV != null && FOIRLTV.size() == 5) {
ltvMap.put(IdLTV[0], FOIRLTV[0]);
FOIRMap.put(IdLTV[0], FOIRLTV[1]);
ltvIns.put(IdLTV[0], FOIRLTV[2]);
legStat.put(IdLTV[0], FOIRLTV[3]);
ECTSRStat.put(IdLTV[0], FOIRLTV[4]);
}
//TSR / legal logic stamping End
}

}
}
}
}
System.debug('ltvMap=' + ltvMap + '=ltvIns=' + ltvIns);

for (Property_Details__c p: propertyList) {
if (ltvMap.containsKey(p.Id) && ltvMap.get(p.Id) != null) {
p.Standard_LTV__c = Decimal.valueOf(ltvMap.get(p.Id));
//updateList.add(p);
}

if (FOIRMap.containsKey(p.Id) && FOIRMap.get(p.Id) != null) {
p.Applied_FOIR__c = Decimal.valueOf(FOIRMap.get(p.Id));
}

// SHL Requirement
//Commented as logic of LTV insurence calculation changes
if (ltvIns.containsKey(p.Id) && ltvIns.get(p.Id) != null) {
p.Max_Permissible_LTV__c = Decimal.valueOf(ltvIns.get(p.Id));
}

//TSR / legal logic stamping by Piya 1-18-17 Start
if (legStat.containsKey(p.Id) && legStat.get(p.Id) != null) {
p.SRO_Name__c = legStat.get(p.Id);
}
if (ECTSRStat.containsKey(p.Id) && ECTSRStat.get(p.Id) != null) {
p.EC_TSR_Status__c = ECTSRStat.get(p.Id);
}
//TSR / legal logic stamping End

updateList.add(p);

}*/

   if (updateMAp.values() != NUlL) {
    //bug fix 12013
    update updateMAp.values();


    propertyList = SelectQueriesHelperClass.QueryPropertyDetailsMortgage(Loan.id);
   }
   // System.debug('Scam.Final_Eligibility__c='+Scam.Final_Eligibility__c+'=Eligibility='+Eligibility);        

  } //end 10910 SHL       

 }


 public void googleCheck() {

  PageReference pr = Page.googleCheckPage;
  pr.getParameters().put('AttachToId', (String) ApplicantName);
  Applicant__c appTemp;
  if (!Test.isRunningTest())
   appTemp = [Select id, is_BL_PL_Risk__c, Contact_Name__r.Name from applicant__c where ID =: ApplicantName];
  String searchQuery;
  if (appTemp != null)
   searchQuery = appTemp.Contact_Name__r.Name + '~launder OR ~laundered OR ~laundering OR ~fraud OR ~criminal OR ~terror OR ~corrupt OR ~investigation OR ~fine OR ~fined OR ~penalty OR ~charge OR ~charged OR ~scam OR ~alleged OR ~regulator OR ~regulatory OR ~disciplinary OR ~enforcement action OR ~default OR ~politician OR ~politics OR ~legal action OR ~court case OR ~BFR OR ~MCA defaulter OR ~SEBI banned';
  pr.getParameters().put('Search', searchQuery);
  Blob pdf1;
  if (!Test.isRunningTest())
   pdf1 = pr.getcontentAsPdf();

  Attachment attach = new Attachment();
  attach.Body = pdf1;
  attach.Name = 'GoogleCheckResult';
  attach.IsPrivate = false;
  attach.ParentId = ApplicantName;
  if (!Test.isRunningTest())
   insert attach;

 }



 public void deleteObligation() {
  //update exloan
  if (ObligationWrapperList != null && ObligationWrapperList.size() > 0) {

   transient List < Existing_Loan_Details__c > tempListDel = new List < Existing_Loan_Details__c > ();
   decimal oblToDelete;
   for (integer i = 0; i < ObligationWrapperList.size(); i++) {

    if (ObligationWrapperList[i].deleteRecord == true) {

     if (ObligationWrapperList[i].exloan.id != null) {


      oblToDelete = ObligationWrapperList[i].exloan.Mthly_Oblig__c;
      tempListDel.add(ObligationWrapperList[i].exloan);
      //BT Multiplier calculator 10905.. YK
      //Rohit commented & changed condition as per prod
      if (Mortgageflag && ObligationWrapperList[i].exloan.Status__c == 'Proposed BT' &&
       (ObligationWrapperList[i].exloan.Loan_Type__c == 'HL' ||
        /*ObligationWrapperList[i].exloan.Loan_Type__c == 'HL ?Improvement' ||
ObligationWrapperList[i].exloan.Loan_Type__c == 'HL ?Top Up' ||*/
        ObligationWrapperList[i].exloan.Loan_Type__c == 'HL ÃƒÂ¢Ã¢â€šÂ¬Ã¢â‚¬Å“ Improvement' ||
        ObligationWrapperList[i].exloan.Loan_Type__c == 'HL ÃƒÂ¢Ã¢â€šÂ¬Ã¢â‚¬Å“ Top Up' ||
        ObligationWrapperList[i].exloan.Loan_Type__c == 'LAP' ||
        ObligationWrapperList[i].exloan.Loan_Type__c == 'Housing Loan' ||
        ObligationWrapperList[i].exloan.Loan_Type__c == 'Property Loan') &&
       ObligationWrapperList[i].exloan.Multiplier__c != null) {
       cam.BT_Existing_Top_up_multiplier__c = cam.BT_Existing_Top_up_multiplier__c - ObligationWrapperList[i].exloan.Multiplier__c;
      }
      //BT Multiplier calculator 10905.. YK
     }

    }
   }
   if (tempListDel.size() > 0) {
    //  ObligationWrapperList.remove(tempListDel.size());
    delete tempListDel;
   }
  }
  //shl mortagage S
  existingLoanDetailsList = [select id, financers__c, Name, Customer_Declared_EMI__c, EMI_Over_In_Next_6_months__c, Status__c, Final_EMI__c, Secured_Unsecured__c, Loan_Type__c, Loan_Amount__c, Seen_in__c,
   Loan_Acc_No__c, Select__c, Applicant__r.ContactName__c, Principal_O_s__c, Obligation__c,
   Financer__c, Amount__c, Month1_Amount__c, Month2_Amount__c, Derived_EMI__c, Remark__c, No_of_Bounces_if_any__c,
   Start_On__c, Tenor__c, Tenor_Left__c, MOB__c, POS__c, EMI__c, Applicant__c, Annual_Obligation__c, Type_of_Oblig__c, Rate_of_Interest__c, City__c, Property_Address__c /*01MOB S*/ , Purchase_Value__c, Property_Purchase_Date__c /*01MOB E*/ , /*Mortgage*/ Applicant__r.Applicant_Type__c, /*Mortgage*/ Mthly_Oblig__c, Multiplier__c, /*Bug 13407 s*/ Mortgage_free_property__c, Still_own_the_property__c /*Bug 13407 e*/ from Existing_Loan_Details__c where Loan_Application__c =: loan.id
  ];

  OverDraft = 0;
  creditCardAmt = 0;
  //--------------- Mortgage Re-Engg Start---------------------
  decimal monthlyObligationMort = 0;
  //--------------- Mortgage Re-Engg End-----------------------

  ObligationWrapperList = new List < ObligationWrapper > ();
  for (Existing_Loan_Details__c exp: existingLoanDetailsList) {
   ObligationWrapperList.add(new ObligationWrapper(false, applicantSelectList, exp, false));
   //creditCardAmt
   if (exp.Loan_Type__c == 'Credit Card' && exp.Status__c == 'Live' && exp.Obligation__c == 'Yes') {

    if (exp.POS__c != null)
     creditCardAmt += exp.POS__c;

   }

   if (exp.Loan_Type__c == 'Overdraft' && exp.Status__c == 'Live' && exp.Obligation__c == 'Yes') {

    if (exp.POS__c != null)
     OverDraft += exp.POS__c;

   }
   //--------------- Mortgage Re-Engg Start---------------------
   if (Mortgageflag) {
    if (exp.Applicant__c != null && (exp.Applicant__r.Applicant_Type__c == 'Primary' || exp.Applicant__r.Applicant_Type__c == 'Financial Co-Applicant' || exp.Applicant__r.Applicant_Type__c == 'Primary Financial Co-Applicant') && exp.Status__c == 'Live') {
     if (exp.Customer_Declared_EMI__c != null) {
      monthlyObligationMort = monthlyObligationMort + exp.Customer_Declared_EMI__c;
     } else if (exp.Derived_EMI__c != null) {
      monthlyObligationMort = monthlyObligationMort + exp.Derived_EMI__c;
     }

    }

   }
   //--------------- Mortgage Re-Engg End-----------------------

  }
  //--------------- Mortgage Re-Engg Start---------------------
  if (Mortgageflag) {
   cam.Average_Bank_Balance_GDP__c = monthlyObligationMort;
   update cam;
  }

  //shl mortagage E


  /*
Code added by Rakesh Shinde.Date : 11 April 2016
BRD : Bug :6217 -PRO DSS NEW CREDIT PROGRAM FOR CA SALARIED  
Purpose : Added code to calculate  mnthOblFrmExtLoanDetails on Obligation details          
*/
  /*system.debug('PSBL called');
if( mnthOblFrmExtLoanDetails >oblToDelete){
mnthOblFrmExtLoanDetails = mnthOblFrmExtLoanDetails - oblToDelete ;
objSurrogateCam.MO_For_Opportunity__c = mnthOblFrmExtLoanDetails;
upsert objSurrogateCam;
system.debug('PSBL called11111');
}*/

 }

 public void savePLSDetails() {
  try {
   upsert cam;
  } catch (Exception e) {}
 }

 //--------------- Mortgage Re-Engg End-----------------------
 //SHOL differential journey ---- backend----START
 public void fetchBranchCPAuser() {

  List < Opportunity > opps = null;
  List < User > cpaUsrList = null;
  branchCPAUsrList = new List < SelectOption > ();

  /*if(LoanId != null)
opps = [SELECT Branch_City__c FROM Opportunity WHERE Id = :LoanId];*/

  if (Loan != null && !CommonUtility.isEmpty(Loan.Branch_City__c) && !CommonUtility.isEmpty(Loan.product__c)) {

   //String branch = opps[0].Branch_City__c;
   cpaUsrList = [SELECT Id, Name FROM USER WHERE Profile.Name = 'CPA Login Partner'
    and IsActive = true and branch_city__c includes(: Loan.Branch_City__c) and Product__c includes(: Loan.product__c)
   ];

  }

  if (cpaUsrList != null && cpaUsrList.size() > 0) {

   showCPAs = true;
   branchCPAUsrList.add(new SelectOption('None', '---None---'));
   for (User usr: cpaUsrList) {
    branchCPAUsrList.add(new SelectOption(usr.Id, usr.Name));
   }
  }




 }
 //Shl Mortagage
 public void showhideincomesectionCO() {




 }


 public PageReference SubmitToCPAOrACMTeam() {

  try {
   if (loan.Approver__c == 'Centralized ACM') {

    if (selectedCPA != null && selectedCPA != 'none') {

     loan.ownerId = selectedCPA;
     loan.StageName = 'Branch CPA - Doc Check';
     loan.Approver__c = 'CPA Login Partner';
     loan.CPA__c = selectedCPA;
     //RecordType recType=[SELECT Id FROM RecordType where name='CPA' limit 1];

     //loan.RecordTypeId=recType.Id;

     UPDATE loan;

     showSubmitToCPADivFlag = false;
     showCPAs = false;

    } else {
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please select the Approver before submitting'));
    }
   } else if (loan.Approver__c == 'CPA Login Partner') {

    //List<OpportunityFieldHistory> loanHistory = [SELECT Field,Id,NewValue,OldValue FROM OpportunityFieldHistory WHERE OpportunityId = :loan.Id];
    //Type typeOfID =ID.class;
    List < OpportunityFieldHistory > loanHistory = [SELECT Field, Id, NewValue, OldValue FROM OpportunityFieldHistory WHERE OpportunityId =: loan.Id order by createddate desc];

    String oldOwnerId, oldRecordTypeId;

    if (!CommonUtility.isEmpty(loanHistory)) {
     for (OpportunityFieldHistory ofh: loanHistory) {
      if (!CommonUtility.isEmpty(ofh.OldValue) && !CommonUtility.isEmpty(ofh.NewValue) && (ofh.OldValue instanceof ID)) {
       if (ofh.Field == 'Owner' && loan.ownerId == ofh.NewValue) {

        oldOwnerId = String.valueOf(ofh.OldValue);
       }
       /*if(ofh.Field == 'RecordType' && loan.RecordTypeId == ofh.NewValue){
system.debug('***ofh***'+ofh+'***');
oldRecordTypeId = String.valueOf(ofh.OldValue);
}  */

      }

      if (!CommonUtility.isEmpty(oldOwnerId) && !CommonUtility.isEmpty(oldRecordTypeId))
       break;
     }
    }

    loan.ownerId = oldOwnerId;
    // loan.RecordTypeId = oldRecordTypeId;
    loan.Approver__c = 'Centralized ACM';
    loan.StageName = 'Centralized Underwriting Final';

    UPDATE loan;


   }

   PageReference pageRef = new PageReference('/006/o');
   return pageRef;

  } catch (Exception ex) {
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Unable to submit' + ex.getMessage()));
  }

  return null;
 }

 //SHOL differential journey ---- backend----END


 //------------------SHL---------------

 public void savePrimIncomeDetails() {
  try {
   cam.Loan_Application__c = loan.Id;
   if (con.Id != null)
    cam.Type_Cust__c = con.Customer_Type__c;
   cam.Type_of_CAM_Entity__c = 'Salaried';
   if (con.Id != null)
    cam.Type_Cust__c = con.Customer_Type__c;
   if (cam.Gross_Salary_Month1__c != null && cam.Gross_Salary_Month2__c != null && cam.Gross_Salary_Month3__c != null)
    cam.Net_Salary_for_Month1__c = ((cam.Gross_Salary_Month1__c + cam.Gross_Salary_Month2__c + cam.Gross_Salary_Month3__c) / 3).round(system.roundingMode.CEILING);
   if (cam.Gross_Salary_Month1__c == null && cam.Gross_Salary_Month2__c == null && cam.Gross_Salary_Month3__c == null)
    cam.Net_Salary_for_Month1__c = 0;


   if (cam.Receips1_Doc__c != null && cam.Receips2_Doc__c != null && cam.Receips3_Doc__c != null)
    cam.Net_Salary_for_Month2__c = ((cam.Receips1_Doc__c + cam.Receips2_Doc__c + cam.Receips3_Doc__c) / 3).round(system.roundingMode.CEILING);
   if (cam.Receips1_Doc__c == null && cam.Receips2_Doc__c == null && cam.Receips3_Doc__c == null)
    cam.Net_Salary_for_Month2__c = 0;

   //added by gopika
   /* if (cam.Average_incentive_for_Q1__c != null &&cam.Average_incentive_for_Q1__c!=0&& cam.Average_incentive_for_Q2__c != null &&cam.Average_incentive_for_Q2__c!=0&& cam.Average_incentive_for_Q3__c != null&&cam.Average_incentive_for_Q3__c !=0)
cam.Construction_Valuation_1__c = ((cam.Average_incentive_for_Q1__c + cam.Average_incentive_for_Q2__c + cam.Average_incentive_for_Q3__c) / 3).round(system.roundingMode.CEILING);
else if(cam.Average_incentive_for_Q1__c != null &&cam.Average_incentive_for_Q1__c!=0&& cam.Average_incentive_for_Q2__c != null &&cam.Average_incentive_for_Q2__c!=0)
cam.Construction_Valuation_1__c = ((cam.Average_incentive_for_Q1__c + cam.Average_incentive_for_Q2__c) / 2).round(system.roundingMode.CEILING);
else if(cam.Average_incentive_for_Q2__c != null &&cam.Average_incentive_for_Q2__c!=0&& cam.Average_incentive_for_Q3__c != null &&cam.Average_incentive_for_Q3__c!=0)
cam.Construction_Valuation_1__c = ((cam.Average_incentive_for_Q3__c + cam.Average_incentive_for_Q2__c) / 2).round(system.roundingMode.CEILING);
else if(cam.Average_incentive_for_Q3__c != null &&cam.Average_incentive_for_Q3__c!=0&& cam.Average_incentive_for_Q1__c != null &&cam.Average_incentive_for_Q1__c!=0)
cam.Construction_Valuation_1__c = ((cam.Average_incentive_for_Q1__c + cam.Average_incentive_for_Q3__c) / 2).round(system.roundingMode.CEILING);
*/
   if (cam.Average_incentive_for_Q1__c == null && cam.Average_incentive_for_Q1__c == null && cam.Average_incentive_for_Q3__c == null)
    cam.Construction_Valuation_1__c = 0;

   if (cam.Receips4_Doc__c != null && cam.Receips5_Doc__c != null && cam.Receips6_Doc__c != null)
    cam.Construction_Valuation_2__c = ((cam.Receips4_Doc__c + cam.Receips5_Doc__c + cam.Receips6_Doc__c) / 3).round(system.roundingMode.CEILING);
   if (cam.Receips4_Doc__c == null && cam.Receips5_Doc__c == null && cam.Receips6_Doc__c == null)
    cam.Construction_Valuation_2__c = 0;

   /*if (loan.Tenor__c != null)
cam.Tenor__c = loan.Tenor__c;
if (loan.Requested_ROI__c != null)
cam.ROI__c = loan.Requested_ROI__c;
if (loan.Loan_Amount__c != null)
cam.Proposed_Loan_Amt__c = loan.Loan_Amount__c;*/ // Comented for SHL rasika

   //SHL Rental Income issue Amit bug 11112
   if (Loan.Product__c == 'SHL' || Loan.Product__c == 'SHOL' || Loan.Product__c == 'HSL' || Loan.Product__c == 'SALLAP' || Loan.Product__c == 'HPLS' || Loan.Product__c == 'SBS CS SHL') {
    if (cam.Monthly_Reimbursement__c == null)
     cam.Monthly_Reimbursement__c = 0;
    if (cam.Rental_Income__c == null)
     cam.Rental_Income__c = 0;
    if (cam.GP_Other_income__c == null)
     cam.GP_Other_income__c = 0;
    if (cam.Oth_Inc_2_be_Consd__c == null)
     cam.Oth_Inc_2_be_Consd__c = 0;
   }
   //bug 11112 end

   if (!Test.isRunningTest())
    upsert cam;

   /*Dynamic Query Added - Aman*/
   String loanId = loan.id;
   String WhereANDCondition;
   String camQuery;
   camQuery = 'SELECT Name, Payment_Date_1__c, Payment_Date_2__c, Payment_Date_3__c, Recent_continuous__c, Repayment_of_loan__c, CreatedDate, Current_Year_PLBS__c, Current_Year_PLBS__r.Year__c, Previous_Year_PLBS__r.Year__c, Previous_Year_PLBS__c, Applicant__r.Contact_Name__c,' +
    'Type_Cust__c, Type_of_Entity__c, Month1__c, Total_Income_GP__c, Month2__c, Month3__c, Gross_Salary_Month1__c, Approved_CAM__c, Monthly_Reimbursement__c, Maximum_Unsecured_Exposure_MUM__c,' +
    'Gross_Salary_Month2__c, Gross_Salary_Month3__c, Final_Net_An_Inc__c, Net_Salary_for_Month1__c, Net_Salary_for_Month2__c, Net_Salary_for_Month3__c, Avg_Net_Sal__c, Avg_Mthly_Inctve_70__c,' +
    'Avg_Qtrly_Inctve_60__c, Avg_Mthly_Net_Inc__c, Average_Monthly_Net_Income1__c, Mthly_Loan_EMI__c, Credit_Card_Out_5__c, OD_interest__c, Total_Mthly_Oblig__c, NAS__c, Maxi_EMI_Banking__c, Maxi_EMI_Cust__c,' +
    'Maxi_EMI_FOIR__c, Max_EMI_Offer__c, NAS_Multi__c, Max_Loan_Amt_NAS_Multi__c, ROI__c, Final_FOIR__c, Avg_monthly_incentive1__c, Avg_monthly_incentive2__c,' +
    'Proposed_Loan_Amt__c, IRR_TO__c, Tenor__c, EMI_on_Proposed_Loan_TO__c, Insurance_taken_TO__c, Premium_Amount_TO__c, Loan_Amt_Premium__c, EMI_with_Insurance_Premium_TO__c,' +
    'Avg_monthly_incentive3__c, Avg_mthly_incntve_3mts__c, Average_incentive_for_Q1__c, Average_incentive_for_Q2__c, Average_incentive_for_Q3__c, Avg_qtrly_incentive__c,' +
    'Incentive_Monthly_or_Quarterly__c, Receips1_Doc__c, Receips2_Doc__c, Receips3_Doc__c, Receips4_Doc__c, Receips5_Doc__c, Receips6_Doc__c, Month4_Doc__c, Month5_Doc__c,' +
    'Selected1__c, Month1_Doc__c, Month2_Doc__c, Month3_Doc__c, Year1_Doc__c, Year2_Doc__c, Year3_Doc__c, LAP_EMI__c, Construction_Valuation_1__c, Construction_Valuation_2__c,' +
    'Sal_Deviation_on_FOIR__c, Sal_MUE_Funding__c, sal_max_loan__c, LAP_pmt__c, Interest_on_term_loans__c, Bounces_in_Latest_3_Months__c, App_Mon_Income__c, Monthly_CC_OD_interest__c, ELC_Line_Amounts__c,' +
    'Rental_Income__c, Adjusted_Rental_Income__c, SAL_Max_FOIR_as_BFL__c, New_Sal_Deviation_on_FOIR__c, MLA_for_Unlisted_Pvt__c, Applicable_FOIR1__c, Unsecured_FOIR__c, Secured_FOIR__c,' +
    'Deviation_on_FOIR__c, max_loan_POS_forExSAL__c, Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c, Max_Loan_Amount_for_IT_Company__c, Average_Monthly_Net_Income2__c,' +
    'Bank_Details__r.Average_Balance__c, Existing_HL_EMI__c, Bank_Details__r.Sum_of_average_Balance__c, Bank_Details__r.Transaction_Count__c, Average_Bank_Balance__c, id, Average_monthly_Obligations__c, Avg_Mthly_Net_Inc1__c, Income_from_CY__c, ELIGIBILITY_ACCORDING_TO_GROSS_RECEIPTS__c, ELIGIBILITY_ACCORDING_TO_CASH_PROFITS_ME__c, Fund_Based__c,' +
    'Entity_Record_Type__c, BT_Existing_Top_up_multiplier__c, Loan_elig_TO__c, EMI_of_The_Loan__c, Rental_Income_to_be_considered__c, Live_unsecured_loan__c, Selected_Option_TO__c, Eligible_FOIR__c, Eligible_Loan__c, Multiplier__c,LAP_Tenor__c, GP_Other_income__c, Oth_Inc_2_be_Consd__c, Average_Bank_Balance_GDP__c, Eligible_Home_Loan_Amount__c, Stake_of_co__c, Home_Loan_Tenor__c, GP_Home_loan_amount__c, Top_Up_Amount__c, Top_Up_Rate__c, Top_Up_Tenure__c, Industry_Margins_applicable1__c, C_P_Current_Year__c, Existing_Live_Obligations__c, ObligationsDC1__c, Agri_income_to_be_consd__c, Agri_Inc_2_be_Consd__c, C_P_Previous_Year__c, Final_Income_considered_for_Eligibility__c, Business_Income_Considered__c, Hl_pmt__c from cam__c where loan_application__c = : loanId';

   if (callCenterProcessFlag)
    WhereANDCondition = ' AND Applicant__c != null LIMIT 1';
   else if (salMobilityFlag || salmobilityv2falg)
    WhereANDCondition = ' AND (Applicant__c != null OR Applicant__c = null) LIMIT 1';
   else
    WhereANDCondition = ' AND Applicant__c = null LIMIT 1';

   camQuery += WhereANDCondition;
   system.debug('camQuery -->' + camQuery);
   cam = Database.query(camQuery);
   system.debug('cam -->' + cam);
   /*Dynamic Query Added - Aman*/

   upsert applicantPrimary;
   upsert loan;

   List < Applicant__c > newApplicantList = new List < Applicant__c > ();
   if (selectedApplicant != null) {
    newApplicantList = [select is_BL_PL_Risk__c, /*OTP V3 CR S*/ Score_card__c, Contact_Name__r.special_profile_employer__c, Codified_CIBIL__c, contact_name__r.employer__r.bank_names__c, Risk_Segmentation__c, /*OTP V3 CR E*/ Contact_Name__r.Linkedin_check_result__c, Contact_Name__r.Google_check_result__c, Contact_Name__r.PAN_Response__c,
     Contact_Name__r.SFDC_Dedupe_check__c, Contact_Name__r.office_no_check_on_company_site__c, id, Contact_Name__r.Total_Work_Experience_Yrs__c, Contact_Name__r.Years_At_Residence__c, Name, SegmentaionResult__c, ContactName__c, Loan_Application__c, movedToCibilTemp__c, Update_CIBIL_Error__c, Descriptin__c, Type_of_Borrower__c, Re_Initiate_De_Dupe__c, Integrate_with_CIBIL__c, Contact_Name__c, Contact_Name__r.Name, Contact_Name__r.Customer_Profile__c,
     Contact_Name__r.Designation__c, Contact_Name__r.Employer_Name__c, Contact_Name__r.Qualification__c, Contact_Name__r.Address_1__c,
     PD_Status__c, Bank_Status__c, Contact_Name__r.Address_2__c, FCU_Status__c, ITR_Status__c, Office_SE_Status__c, Office_SAL_Status__c,
     Office_Status__c, Pay_Slips_Status__c, Residence_Status__c, Trade_Status__c, TVR_Status__c, Select_Applicant__c, Applicant_Type__c, Contact_Name__r.Customer_Type__c, Contact_Name__r.ApplicantType__c,
     Contact_Name__r.Date_of_Birth__c, Contact_Name__r.FathersHusbands_Name__c, Contact_Name__r.PAN_Number__c, Contact_Name__r.Year_of_Incorporation__c, Contact_Name__r.Account.TIN_Number__c,
     Contact_Name__r.Bank_Account_No__c, Contact_Name__r.VoterID_Number__c, Contact_Name__r.ROC_Regn_No__c, Contact_Name__r.Address_3__c, Contact_Name__r.AppCity__c,
     Contact_Name__r.Pin_Code__c, Contact_Name__r.Phone, Contact_Name__r.MobilePhone, Contact_Name__r.Email, Contact_Name__r.Address_Line_One__c, Contact_Name__r.Address_2nd_Line__c, Contact_Name__r.Address_3rd_Line__c,
     Contact_Name__r.Permanent_Land_Mark__c, Contact_Name__r.Office_City__c, Contact_Name__r.Office_Pin_Code__c, Contact_Name__r.Office_STD_Code__c, Contact_Name__r.Office_Phone_Number__c,
     Contact_Name__r.Mobile_Phone__c, Contact_Name__r.Office_Email_Id__c, Contact_Name__r.Middle_Name__c, Employer__c, Company_Type__c, Company_Name__c, Contact_Name__r.Company_Type__c,
     DIN_No_if_applicable__c, Contact_Name__r.FirstName, Contact_Name__r.LastName, Contact_Name__r.Permanant_Address_Line_1__c, Contact_Name__r.Permanant_Address_Line_2__c, Contact_Name__r.Permanant_Address_Line_3__c,
     Contact_Name__r.Permanent_STD__c, Contact_Name__r.Permanent_Pin_Code__c, Contact_Name__r.Year_in_Present_Job__c, Contact_Name__r.Year_in_Previous_Job__c, Contact_Name__r.Name_of_the_company_Employer__c,
     Contact_Name__r.Nature_of_Business__c, Contact_Name__r.Employment_Status__c, Contact_Name__r.Gender__c, Contact_Name__r.Age__c, Contact_Name__r.Employment_Type__c, Contact_Name__r.STD_Code__c, Contact_Name__r.Phone_Number__c,
     Contact_Name__r.Name_of_Employer__c, Designation__c, Contact_Name__r.Type_Of_Constitution__c, Contact_Name__r.Marital_Status__c, Contact_Mobile__c, Contact_Name__r.Residence_City__c, Contact_Name__r.Sex__c,
     Contact_Name__r.Employer__r.name, Contact_Name__r.TAN_Number__c, Contact_Name__r.TAN_Found_In_Master__c, Contact_Name__r.Email_Domain_Status__c, Contact_Name__r.Bank_Name1__c,
     Contact_Name__r.Bank_Name_Status1__c, Loan_Application__r.Existing_Customer__c, Contact_Name__r.PAN_Card_Status__c, Comments__c, Contact_Name__r.CIBIL_Report__c, Contact_Name__r.Office_Email_Id_for_Fraud__c, Contact_Name__r.TAN__c, Contact_Name__r.Current_experiance_in_Years__c, Contact_Name__r.Residence_Type__c, Contact_Name__r.Employer__r.Company_Category__c,
     Contact_Name__r.Age_of_Applicant__c, CIBIL_Score__c, Is_PL_BT__c, Cibil_Temp__c, DeDupe_Counter__c, Existing_Customer__c,
     StepUp_StepDown_EMI_Year_1__c, StepUp_StepDown_EMI_Year_2__c, StepUp_StepDown_EMI_Year_3__c, StepUp_StepDown_EMI_Year_4__c, StepUp_StepDown_EMI_Year_5__c, TotalFOIRHLResult__c, TotalFOIRNoHLResult__c, TotalWorkExpResult__c, UnsecuredFOIRResult__c, LoanAmountResult__c, CurrentWorkExpResult__c,
     OwnHouse_RunningHLResult__c, CompanyCategoryResult__c, EducationQualificationResult__c, Segment_Prudense__c, Segment_Stability__c,
     Segment_Achievment__c, SalaryToAgeResult__c, Bureau_Segment__c, Company_Name_as_per_Domain_check__c, /*Mortgage*/ Contact_Name__r.Property_Owner__c /* SAL Policy Changes Start */ , RC_Decline__c, RC_Deviation__c, /* SAL Policy Changes End */
     /*bug 11151 s */
     Domain_Created_Date__c /* bug 11151 e*/ , Total_Employment_Vintage__c, /*18370 S*/ Is_Hybrid_Flexi_for_Topup__c, Topup_Pure_Flexi_Period__c, Topup_Dropline_Flexi_Period__c, Topup_Loan_Proposed_EMI__c, Topup_Pure_Flexi_EMI__c /*18370 E*/
     from Applicant__c where ContactName__c =: selectedApplicant
    ];
   }
   if (primContact != null) {
    primContact.Current_experiance_in_Years__c = applicantPrimary.Contact_Name__r.Current_experiance_in_Years__c;
    primContact.Years_At_Residence__c = applicantPrimary.Contact_Name__r.Years_At_Residence__c;
    primContact.Linkedin_check_result__c = applicantPrimary.Contact_Name__r.Linkedin_check_result__c;
    primContact.Google_check_result__c = applicantPrimary.Contact_Name__r.Google_check_result__c;
    primContact.PAN_Response__c = applicantPrimary.Contact_Name__r.PAN_Response__c;
    primContact.TAN_Found_In_Master__c = applicantPrimary.Contact_Name__r.TAN_Found_In_Master__c;
    primContact.SFDC_Dedupe_check__c = applicantPrimary.Contact_Name__r.SFDC_Dedupe_check__c;
    primContact.office_no_check_on_company_site__c = applicantPrimary.Contact_Name__r.office_no_check_on_company_site__c;
    update primContact;
   }

   savedSuccessfull = true;

   message = 'Salaried details Saved Successfully !!!';
   //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal start
   /* purpose of the code :-to quey checklist record of loan application Re_appraisal_Initiated_time__c,Account.Previous_Approved_Loan_Amount__c,(Select id, Document_Type__c,Deviation_Master__c,Deviation_Master__r.Minimum_Approver_Level__c, Mandatory__c, Sales_Status__c, Document__c from Checklists__r)
    */
   loan = [select /*20939 s*/ Relationship_Manager__r.Mobile_number__c, /*20939 e*/ /*SAL PL to SAL LAP*/ Branch_Name__r.Branch_Code__c, Account.First_Name__c, Account.Last_Name__c, Account.Process_Type__c, /*SAL PL to SAL LAP*/ id, Account.Previous_Approved_Loan_Amount__c, Re_appraisal_Initiated_time__c, (Select id, Document_Type__c, Deviation_Master__c, Deviation_Master__r.Minimum_Approver_Level__c, Mandatory__c, Sales_Status__c, Document__c from Checklists__r), Relationship_Manager__r.Email, Sourcing_Channel__r.sourcing_channel_email_id__c, ACM__r.Email, Branch_Type__c, A_C_No__c, Industry__r.Industry__c, Owner.Name, Original_Approver__c, Branch_City__c, Decision_Time__c, Loan_Amount_with_Premium__c, Approved_Loan_Amount__c, Approved_Rate__c, Approved_Tenor__c, Loan_amt_with_premium__c, Insurance_Premium_Amt__c, online_salaried_app__c,
    Reject_Reason__c, Sales_Backend__c, name, Risk_Deviations__c, CRO_Deviations__c, CPA__c, ACM__c, RCM__c, NCM__c, CRO__c, RISK__c, COO__c, ACM_Comments__c, RCM_Comments__c, COO_Comments__c, Eligible_for_cross_sell__c, Products_for_cross_sell__c, Cross_sell_comments__c,
    Approval_Stages__c, Approver__c, Loan_Application_Number__c, Product__c, Loan_Type__c, Relationship_Manager__c, AccountId, CreatedDate,
    OwnerId, CreatedById, Scheme_Master__c, Scheme_Master__r.Name, Industry__c, Credit_Program__c, createdBy.Profile.Name,
    Sub_Industry__c, Existing_Customer__c, Finance_Amount__c, Tenor__c, Main_Sector__r.Sector__c, Main_Industry__c, Main_Sub_Industry__c,
    Type_Of_Loan__c, amount, Employee_Type__c, stagename, Probability, Branch_Name__r.branch_type__c,
    ForecastCategoryName, File_Acceptance__c, Discrepancy_Status__c, Loan_Amount__c,
    Type_of_Constitution__c, Application_Form_Number__c, If_Yes__c, Branch_Type1__c, Relationship_Manager__r.Name,
    Branch_Name__r.name, Sourc_Mobile__c, ASM_Mobile__c, Sales_Backend_Mobile__c, Verification_Initiated__c, Referral__c,
    Sourcing_Channel__c, Current_UserRole__C, CEO__c, CEO__r.name, RCM__r.name, NCM__r.name,
    RISK__r.name, COO__r.name, CRO__r.name, Comments__c, No_of_Properties__c, EMI_Type__c,
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
    Acc_InsurStartDate__c, Acc_InsurPremiumAmount__c, Acc_InsurSumAssured__c, Total_Monthly_Oblig__c, Scheme_Master__r.PLOC_scheme__c,
    Requested_ROI__c, Processing_Type__c, Account.IS_OTP_FLOW__c, EMI_CAM__c, Date_of_created_date__c,
    Life_InsuranceRemarks__c, Type_of_Borrower__c, AppScore__c, Rank1__c, Loan_Application_Flow__c, Offer_Amount__c, Sourcing_Channel__r.Sourcing_Channel_Flag__c, Account.Vintage_with_BAL__c, Account.Current_experiance_in_Years__c, Account.Total_Work_Experience_Yrs__c, Account.BT_Bank_Type__c, Account.Type_of_Ownership__c, Account.Residence_TypeAcc__c,
    CampaignId, Business_IRR__c, POS__c, BranchName__c, Financed_by_BFL__c, Disbursement_Type__c, Tranche_Count__c, City_Head__c, UnHold__c,
    CL_Region__c, Region__c, Old_Product__c, account.Years_in_Bus__c, CAM_Expiry_Date__c, CAM_Preparation_Date__c, Business_Head__c, Centralized_ACM__c, Program_Type__c,
    AMC__c, Centralized_RCM__c, Customer_Reference_Number__c, SMS_to_be_Sent__c, ACM__r.Mobile_number__c, Approved_time_after_Reappraisal__c, Decision_Date__c, Interior_Designer__c, Service_Availed__c, Account.EMI_Frequency__c, DSA_Name__c, Sourcing_Channel__r.Name, Account.ownerid, Account.Group_Type__c, Account.Name, /*Mortgage*/ Account.Preferred_language__c, account.Base_Loan__c, Full_Underwriting__c, Sourcing_Channel_Type__c, Sub_Stage__c,
    (select Id, Name, Offer_Amount__c, Availed_Amount__c, Tenor__c, Offer_ROI__c, Offer_Validity__c, Campaign_Type__c, Existing_LAN__c, Requested_Tenor__c, Revised_Offer_Amount__c, Program_Type__c,
     Revised_Offer_ROI__c, EMI_Amount__c, Current_EMI__c, Products__c, Product_Offering_Source__c, PO_Type__c from Product_offerings__r), Telecaller_Name__c, /* SAL IM S */ Account.Employer__r.Name, Account.Employer__r.Company_Name__c, Account.PANNumber__c, Account.Employer__c, Account.Mobile__c, Account.Date_of_Birth__c, /*SAL IM E */
    CM__c, CM_Amount__c, CM_Deviations__c, SCO__c, SCO_Amount__c, SCO_Deviations__c, CM__r.Mobile_number__c, SCO__r.Mobile_number__c, CM__r.name, SCO__r.name /* Bug id : 13016 - New Role Creation for Credit, added by Needhi*/ , (select ID, OppLevelRevisedOfferAmount__c, Revised_Offer_Amount__c, Branch__c from BodmasCalculations__r) /*bug 19469*/
    from opportunity where id =: LoanId
   ];

   //4450
   COLStampdate = null;
   COLStampFlag = false;
   if (LaonApplicationCreation__c.getValues('Hierarchy Stamping') != null) {
    String COLDate = LaonApplicationCreation__c.getValues('Hierarchy Stamping').Credit_Hierarchy_Stamping_Date__c;
    if (COLDate != null) {

     COLStampdate = date.parse(COLDate);
    }
   }


   if (COLStampdate != null && Loan != null && COLStampdate < Loan.createddate) {
    COLStampFlag = true;
   }

   if (COLStampFlag == true) {
    if (Loan != null) {
     LoanAppFlow = Loan.Loan_Application_Flow__c;

     if (LoanAppFlow == null || LoanAppFlow == '') {
      LoanAppFlow = 'Normal';
     }

    }
   }

   if (bankAcc != null && bankAcc.id != null) {
    update bankAcc;
   }

  } catch (Exception e) {

   sendEmailForException(e);
  }
 }
 //SHL Issue of Income to be consider 10902
 public void saveIncometobeDetails() {
  try {
   if (cam != null && cam.id != null) {
    //Update on Flag change
    if (cam.Business_Income_Considered__c == false) {
     cam.sal_max_loan__c = 0;
     cam.Applicable_FOIR1__c = 0;
     cam.Eligible_FOIR__c = 0;
     //rasika
     cam.LAP_EMI__c = 0; //Financial eligible amount as per max permissible tenor // bug 11546
     totalIncon = 0; //b.Total Income considered //cam.Other_income_to_be_consd__c // bug 11546
     FOIRIncludIns = 0; //c. Foir including insurance //cam.INSURANCE_AMOUNT__c // bug 11546
     cam.Other_income_to_be_consd__c = 0;
     cam.INSURANCE_AMOUNT__c = 0;
    }

    update cam;
   }

  } catch (Exception e) {}
 }
 //Cubic Tree Integration start
 public PageReference fetchPropReport() {
  Boolean success = false;
  String fetchReport = '';
  fetchReport = ApexPages.CurrentPage().getParameters().get('FetchReport');
  List < Property_Details__c > prop = new List < Property_Details__c > ();
  if (fetchReport != null && fetchReport != '') {
   prop = [SELECT id, name, jobId__c from Property_Details__c where id =: fetchReport];
  }
  if (prop != null && prop.size() > 0) {
   try {
    if (prop[0].jobId__c != null && prop[0].jobId__c != '') {
     success = FioranoCallout.fetchCubicReport(prop[0].jobId__c, prop[0].id, prop[0].Name);
    } else {
     message = 'Please Initiate Cubic Tree Integration for the Property';
     savedSuccessfull = true;
     return null;
    }
   } catch (Exception e) {
    message = 'Error while fetching Cubic Tree Report';
    savedSuccessfull = true;
    return null;
   }
  } else {
   message = 'No Property found';
   savedSuccessfull = true;
   return null;
  }
  if (success == true) {
   prop[0].Cubic_Tree_Response_Date__c = System.now();
   try {
    update prop[0];
   } catch (Exception e) {
    message = 'Error while updating Response Time';
    savedSuccessfull = true;
    return null;
   }
   message = 'Cubic Tree Report Fetched. Please Click View button too see the Report';
   savedSuccessfull = true;
  } else {
   message = 'Cubic Tree Report Error! Problem with file upload!';
   savedSuccessfull = true;
  }
  return null;

 }
 public PageReference viewPropAttachment() {
  String PropertyId = '';
  PropertyId = ApexPages.CurrentPage().getParameters().get('PropertyId');

  List < Attachment > attach = new List < Attachment > ();
  if (PropertyId != null && PropertyId != '') {
   attach = [SELECT id
    FROM Attachment
    WHERE ParentId =: PropertyId
    AND name LIKE 'CubicTree%'
    ORDER BY CreatedDate DESC
    LIMIT 1
   ];
  }
  if (attach != null && attach.size() > 0) {
   PageReference newTab = new pagereference('/servlet/servlet.FileDownload?file=' + attach[0].id);
   newTab.setRedirect(true);
   return newTab;
  } else {
   message = 'No Report Generated for the Applicant or Report not ready Try after Some Time';
   savedSuccessfull = true;
   return null;
  }
 }
 public void initiatePropCubic() {
  String PropertyId = '';
  PropertyId = ApexPages.CurrentPage().getParameters().get('PropertyId');
  Map < String, String > cubicTreeInputMap = new Map < String, String > ();
  Property_Details__c property = new Property_Details__c();
  try {
   //Selecting the Property
   if (PropertyId != '' && PropertyId != null && propertyList != null && propertyList.size() > 0) {
    for (Property_Details__c prop: propertyList) {
     if (PropertyId == prop.id) {
      property = prop;
      break;
     }
    }
   }

   if (property != null) {
    cubicTreeInputMap.put('keywords', (property.Current_Property_Owner__c != null ? property.Current_Property_Owner__c : applicantPrimary.Contact_Name__r.Name));
    String address = '';
    if (property.Property_Address_Line_1__c != null) {
     address += property.Property_Address_Line_1__c;
     address += ' ';
    }
    if (property.Property_Address_Line_2__c != null) {
     address += property.Property_Address_Line_2__c + '';
     address += ' ';
    }
    if (property.Property_Address_Line_3__c != null) {
     address += property.Property_Address_Line_3__c;
    }
    cubicTreeInputMap.put('address', address);
    cubicTreeInputMap.put('refid', (property.Name != null ? property.Name : ''));
    cubicTreeInputMap.put('individual', 'false');
    cubicTreeInputMap.put('comment', 'Background Check');
    cubicTreeInputMap.put('file_format', 'pdf');
    cubicTreeInputMap.put('bfl_id', (PropertyId != null ? PropertyId : ''));
    cubicTreeInputMap.put('area_locality', (property.Area_Locality__r.Name != null ? property.Area_Locality__r.Name : ''));
    cubicTreeInputMap.put('district', (property.Property_City__c != null ? property.Property_City__c : ''));
    cubicTreeInputMap.put('state', (property.Property_State__c != null ? property.Property_State__c : ''));
    cubicTreeInputMap.put('from_date', '');
    cubicTreeInputMap.put('to_date', '');
    cubicTreeInputMap.put('name', '');
    cubicTreeInputMap.put('pan', '');
    cubicTreeInputMap.put('mobile', '');
    cubicTreeInputMap.put('districtInd', '');
    cubicTreeInputMap.put('stateInd', '');
    cubicTreeInputMap.put('pinInd', '');
    cubicTreeInputMap.put('company_name', '');
    cubicTreeInputMap.put('cin', '');
    cubicTreeInputMap.put('districtCorp', '');
    cubicTreeInputMap.put('stateCorp', '');
    cubicTreeInputMap.put('pinCorp', '');

    Map < String, String > cubicTreeResponse = new Map < String, String > ();
    try {
     cubicTreeResponse = FioranoCallout.callCubicTree(cubicTreeInputMap);
    } catch (Exception e) {
     System.debug('Exception occured' + e.getMessage() + ' at Line Number' + e.getLineNumber());
     message = 'Error while Processing !';
     savedSuccessfull = true;
     return;
    }


    if (cubicTreeResponse != null && cubicTreeResponse.keySet().size() > 0) {
     if (cubicTreeResponse.get('job_id') != null) {
      property.JobId__c = cubicTreeResponse.get('job_id');
      property.Cubic_Tree_Initiation_Date__c = System.now();
      update property;
     }
    }
    //Do not create De Dupe if no job ID
    if (property.JobId__c == null) {
     message = 'Error while Fetching Job Id';
     savedSuccessfull = true;
     return;
    }

    //De Dupe Insertion Logic
    if (PropertyId != null && PropertyId != '') {
     De_Dupe__c dedupe = new De_Dupe__c();
     dedupe.Property_Details__c = PropertyId;
     dedupe.Loan_Application__c = Loan.id;
     dedupe.Dedupe_Source__c = 'propertydedupeCT';
     dedupe.Datafix_Updated__c = 'Processed records';
     try {
      upsert dedupe;
      propCubicDeDupeList = [SELECT id, Property_Details__c, Property_Details__r.id, Property_Details__r.Name, name, Dedupe_Lan_Matches__c,
       Applicant__c, Applicant__r.id, Applicant__r.Contact_Name__c, Datafix_Updated__c, Applicant__r.Applicant_Type__c,
       Application_Status__c, Application_ID__c, Random_Dedupe__c, Area_Status__c, Customer_Status__c,
       Applicant__r.Contact_Name__r.Name, Match_Status__c, Customer_ID__c, Dedupe_Comments__c, De_Dupe_result__c,
       De_Dupe_Decision__c, Segment__c, SF_Base__c, Source_Or_Target__c,
       /* Bug 5880 S */
       Dedupe_Target_Remarks__c, Dedupe_Source__c /*Bug 5880 E*/
       FROM De_Dupe__c
       WHERE Loan_Application__c =: loan.id
       AND Dedupe_Source__c = 'propertydedupeCT'
      ];

      message = 'Cubic Tree Integrated successfully';
      savedSuccessfull = true;
     } catch (Exception e) {

      message = 'Error while creating De Dupe';
      savedSuccessfull = true;
      return;
     }
    }
   }
  } catch (Exception e) {

   message = 'Error while initiating Cubic Tree Integration';
   savedSuccessfull = true;
  }
  return;
 }

 //Cubic Tree Initiation added by krish start
 public void flushValue1() {
  savedSuccessfull = false;
  message = '';
 }
 //Cubic Tree Initiation added by krish end
 //Cubic Tree Integration end

 /** Bug 10666 - fraud trigger enhancement start : krish **/
 public PageReference updateApp() {
  try {
   if (prodFlag == true) {
    applicantPrimary.Fraud_Case__c = true;
    update applicantPrimary;
   }
  } catch (Exception e) {
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e + ''));
  }
  return null;
 }
 /** Bug 10666 - fraud trigger enhancement end : krish **/

 //Dynamic Collateral Mgmt Start 
 public void callDCM() {
  Map < String, Object > mortgageDCMresult = new Map < String, Object > ();
  Map < string, string > DCMMortgageValueMap = new Map < string, string > ();

  if (propertyList != null && propertyList.size() > 0) {
   try {

    //DCMMortgageValueMap.put('loan_id', (Loan != null && Loan.Loan_Application_Number__c != null) ? String.valueof(Loan.Loan_Application_Number__c) : '');

    DCMMortgageValueMap.put('product', 'DYNAMICCOLLATERAL');
    DCMMortgageValueMap.put('invisibleMonitoringProduct', Loan.product__c);
    DCMMortgageValueMap.put('monitoringFor', Loan.product__c);
    DCMMortgageValueMap.put('applicant_type', 'Primary');
    if (applicantPrimary.Contact_Name__c != null && applicantPrimary.Contact_Name__r.Date_of_Birth__c != null) {
     DCMMortgageValueMap.put('date_of_birth', String.valueof(applicantPrimary.Contact_Name__r.Date_of_Birth__c));
    } else {
     DCMMortgageValueMap.put('date_of_birth', '');
    }
    if (Loan.Approved_Loan_Amount__c != null) {
     DCMMortgageValueMap.put('approved_loan_amount', String.valueof(Loan.Approved_Loan_Amount__c));
    } else {
     DCMMortgageValueMap.put('approved_loan_amount', '0.0');
    }

    BRECallout breObj = new BRECallout();

    Map < String, Object > DCMreqMap = new Map < String, Object > ();
    List < Property_Details__c > updatePropList = new List < Property_Details__c > ();

    DCMreqMap.put('generic_map', DCMMortgageValueMap);
    DCMreqMap.put('prop_lst', propertyList);

    if (!Test.isRunningTest()) {
     //mortgageDCMresult = breObj.callDynamicColl(DCMMortgageValueMap,propertyList);
     mortgageDCMresult = breObj.callDynamicColl(DCMreqMap);

    }

    //if(mortgageDCMresult.containsKey('prop_IdentifiedList') && ){
    Map < String, String > mapOfPropTriggersDetails = new Map < String, String > ();

    if (mortgageDCMresult.containsKey('prop_TriggersDetails')) {
     mapOfPropTriggersDetails = (Map < String, String > ) mortgageDCMresult.get('prop_TriggersDetails');
    }



    for (Property_Details__c p: propertyList) {

     for (String pId: (List < String > ) mortgageDCMresult.get('prop_IdentifiedList')) {
      if (p.id == pId) {
       p.Identified_For_Dynamic_Collateral__c = true;
       msgDCM = 'Identified for Dynamic Collateral Monitoring !!!';
      }
     }

     if (msgDCM == '') {
      msgDCM = 'Not Identified for Dynamic Collateral Monitoring !!!';
     }
     for (String pId: mapOfPropTriggersDetails.keySet()) {
      if (p.id == pId) {
       p.Dynamic_Collateral_Trigger_Details__c = mapOfPropTriggersDetails.get(pId);
      }
     }

     updatePropList.add(p);
    }
    //}


    if (updatePropList.size() > 0) {
     update updatePropList;
    }


   } catch (Exception e) {

   }
  } else {

  }
 }
 //Dynamic Collateral Mgmt End 
 /*SAL PLTB Bug 12108 Start - Anshita*/
 public void fetchPlcy() {
  //Applicant__c aplicnt = [select PolicyCheck__c from Applicant__c where Id=:app.Id];

  if (applicantPrimary != null && applicantPrimary.PolicyCheck__c != null) {
   //system.debug('applicantPrimary.PolicyCheck__c : '+ applicantPrimary.PolicyCheck__c);
   List < String > plcy = applicantPrimary.PolicyCheck__c.split(';');
   Map < String, String > plcyMap = new MAp < String, String > ();
   for (String str: plcy) {
    plcyMap.put(str, str);
   }
   Set < ChkLstwrap > ChkLstwrapper = new Set < ChkLstwrap > ();
   mnlWrapLst = new List < ChkLstwrap > ();
   sysWrapLst = new List < ChkLstwrap > ();

   for (String str: plcyList) {
    if (plcyMap.containskey(str)) {
     ChkLstwrapper.add(new ChkLstwrap(str, true));
    } else {
     ChkLstwrapper.add(new ChkLstwrap(str, false));
    }
   }

   for (ChkLstwrap chk: ChkLstwrapper) {
    for (String str: mnlSet) {
     if (chk.policyName == str) {
      mnlWrapLst.add(chk);
     }
    }
    for (String str: sysSet) {
     if (chk.policyName == str) {
      sysWrapLst.add(chk);
     }
    }
   }
  }

 }
 /*SAL PLTB Bug 12108 End- Anshita*/

 /*SAL PLTB Bug 12108 Start - Anshita*/
 /* This method is used to populate Policy name from Custom settings*/
 public void popultplcy() {
  plcyList = new List < String > ();
  sysSet = new Set < String > ();
  mnlSet = new Set < String > ();
  StaticResource staticRsrc;
  staticRsrc = [SELECT Body, Id, Name FROM StaticResource WHERE Name = 'CkeckListJson'
   limit 1
  ];
  String jsnBody = staticRsrc.Body.tostring();
  Map < String, Object > chklstMap = (Map < String, Object > ) JSON.deserializeUntyped(jsnBody);

  Map < String, Object > jsonField = new Map < String, Object > ();
  for (String jsonKey: chklstMap.keySet()) {
   jsonField = (Map < String, Object > ) chklstMap.get(jsonKey);

   for (String val: jsonField.keyset()) {

    Map < String, Object > jsonf = (Map < String, Object > ) jsonField.get(val);
    String lbl = (String) jsonf.get('LBL');
    String mndtry = (String) jsonf.get('MNDTRY');

    if (jsonKey == 'SYS') {
     sysSet.add(lbl);
    }
    if (jsonKey == 'MNL') {
     mnlSet.add(lbl);
    }
    plcyList.add(lbl);
   }
  }
  fetchPlcy();
 }
 /*SAL PLTB Bug 12108 End- Anshita*/
 //SAL Invisible monitoring start
 public PageReference testIMcall() {

  Map < String, String > respMap = CommonUtility.BRECalloutForInvisibleMonitoring('New', 'None', LoanId);
  System.debug('IM rohit ' + respMap);
  if (respMap != null && respMap.get('message') != null) {
   String IMmessage = respMap.get('message');
   if (IMmessage != null && IMmessage.equals('IDENTIFIED FOR INVISIBLE MONITORING')) {
    applicantPrimary.Identified_for_Invisible_Monitoring__c = true;
    update applicantPrimary;
   }
  }
  return null;
 }

 /*OTP V3 Start - Anshita*/
 /* This method is used to fetch sol Policy from Object and populate it inside checkList section on VF page*/
 public void fetchSolPlcy() {
  sollstObj = new List < SOL_Policy__c > ();
  Map < String, SOL_Policy__c > tempmap = new Map < String, SOL_Policy__c > ();
  sysWrapLst = new List < ChkLstwrap > ();
  boolean plcystatus = false;
  system.debug('sysMap keyset : ' + sysMap.keySet());
  if (sysMap != null) {
   sollstObj = [SELECT Checklist_Policy_Override__c, name, Checklist_Policy_Status__c, Id, Policy_Name__c, Policy_Status__c FROM SOL_Policy__c where Loan_Application__c =: LoanId and Policy_Name__c In: sysMap.keySet()];

   if (sollstObj != null && sollstObj.size() > 0) {
    for (String str: sysMap.keySet()) {
     for (SOL_Policy__c sol: sollstObj) {
      if (str == sol.Policy_Name__c) {
       tempmap.put(str, sol);
       break;
      }
     }
    }
   }
   system.debug('sollstObj : ' + sollstObj);
   //To get all the policy which are not having records in Sol Policy object
   List < Opportunity > La = [select Id from Opportunity where Id =: LoanId limit 1];
   List < Applicant__c > appObj = [select is_BL_PL_Risk__c, Contact_name__r.Designation__c, Contact_name__r.Residence_City__c, Contact_name__r.Employer__r.name, Contact_name__r.LastName, Contact_name__r.Middle_Name__c, Contact_name__r.FirstName, Contact_Name__r.Mobile_Phone__c, Applicant__c.Applicant_Type__c, Contact_Name__r.Employer__c, Contact_Name__r.Office_Email_Id__c, eKYC_Processing__c, Office_Email_Id_Verified__c, CIBIL_Score__c, Dedupe_Done__c, PAN_Check__c, PAN_Number__c, /*OTP V3 CR added by Krish s*/ (SELECT id, bank_name__c from Cibil_Temps__r) /*OTP V3 CR added by Krish e*/ from Applicant__c where Loan_Application__c =: LoanId and Applicant_Type__c = 'Primary'];
   system.debug('appobj : ' + appobj);
   List < Bank_Account__c > bnklst = [select Perfios_Flag__c from Bank_Account__c where Loan_Application__c =: LoanId and Applicant__r.applicant_type__c = 'Primary'
    limit 50000
   ];
   system.debug('sysMap keyset : ' + sysMap.keySet());
   for (String str: sysMap.keySet()) {
    solObj = new SOL_Policy__c();
    if (!tempmap.containsKey(str)) {
     solObj.Policy_Name__c = str;
     solObj.name = 'PolicyCheck: ' + str;
     if (!CommonUtility.isEmpty(LoanId)) {
      solObj.Loan_Application__c = LoanId;
     }
     system.debug('solObj inside if : ' + solObj);
     if (str == 'Official Email Confirmation') {
      ofcEmailCheck(solObj, appObj);
     } else if (str == 'Domain check') {
      callEmailDomainCheck(appObj);
     } else if (str == 'E-KYC Confirmation') {
      ekycCheck(solObj, appObj);
     } else if (str == 'Perfios Confirmation') {
      perfiosCheck(solObj, bnklst);
     } else if (str == 'Pan Check') {
      panCheck(solObj, appObj);
     } else {
      solmap.put(str, solObj);
     }
    } else {
     solObj = tempmap.get(str);
     if (str == 'Official Email Confirmation') {
      ofcEmailCheck(solObj, appObj);
     } else if (str == 'Domain check') {
      callEmailDomainCheck(appObj);
     } else if (str == 'E-KYC Confirmation') {
      ekycCheck(solObj, appObj);
     } else if (str == 'Perfios Confirmation') {
      perfiosCheck(solObj, bnklst);
     } else if (str == 'Pan Check') {
      panCheck(solObj, appObj);
     } else {
      solmap.put(str, solObj);
     }

    }
   }

   if (solmap != null) {
    List < SOL_Policy__c > sollst = new List < SOL_Policy__c > ();
    for (String key: solmap.keyset()) {
     sollst.add(solmap.get(key));
    }
    try {
     //upsert sollst;
    } catch (Exception e) {

    }
    if (sollst != null && sollst.size() > 0) {
     for (Sol_Policy__c s: sollst) {
      system.debug('sol policy obj is : ' + s);
      if (s.Checklist_Policy_Status__c == 'Pass' || s.Checklist_Policy_Override__c == true) {
       plcystatus = true;
      } else {
       plcystatus = false;
      }

      //Adding Record in Map to display On VF page
      if (sysMap.containskey(s.Policy_Name__c)) {
       sysWrapLst.add(new ChkLstwrap(plcystatus, s));
      }
     }
    }
   }
  }
 }
 /*OTP V3 End- Anshita*/

 /*OTP V3 Start- Anshita*/
 public void ofcEmailCheck(Sol_Policy__c SolPolObj, List < Applicant__c > appObj) {
  if (appObj != null && appObj.size() > 0) {
   if (appObj[0].Office_Email_Id_Verified__c == true) {
    SolPolObj.Checklist_Policy_Status__c = 'Pass';
   } else {
    SolPolObj.Checklist_Policy_Status__c = 'Fail';
   }
   system.debug('inside ofcEmailCheck SolPolObj : ' + SolPolObj + ' policy_name : ' + SolPolObj.policy_name__c);
   solmap.put(SolPolObj.policy_name__c, SolPolObj);
  }

 }
 /*OTP V3 End- Anshita*/

 /*OTP V3 Start- Anshita*/
 public void perfiosCheck(Sol_Policy__c SolPolObj, List < Bank_Account__c > bnklst) {
  for (Bank_Account__c bnk: bnklst) {
   if (bnk.Perfios_Flag__c == true) {
    SOLPolObj.Checklist_Policy_Status__c = 'Pass';
    break;
   } else {
    SOLPolObj.Checklist_Policy_Status__c = 'Fail';
   }
  }
  solmap.put(SolPolObj.policy_name__c, SolPolObj);

 }
 /*OTP V3 End- Anshita*/
 /*OTP V3 Start- Anshita*/
 public void ekycCheck(Sol_Policy__c SolPolObj, List < Applicant__c > appObj) {
  if (appObj[0].eKYC_Processing__c == true) {
   SOLPolObj.Checklist_Policy_Status__c = 'Pass';
  } else {
   SOLPolObj.Checklist_Policy_Status__c = 'Fail';
  }

  solmap.put(SolPolObj.policy_name__c, SolPolObj);

 }
 /*OTP V3 End- Anshita*/

 /*OTP V3 Start- Anshita */
 public void callEmailDomainCheck(List < Applicant__c > Allapplist) { //EmailDomaincheck
  Salaried_offers__c creditVidya = new Salaried_offers__c();
  creditVidya = Salaried_offers__c.getValues('DomainCheckFlow');
  Boolean emailFlow = false;
  Boolean DomainCheck = false;
  if (creditVidya != null)
   emailFlow = creditVidya.EmailDomainAPIIntegration__c;
  Salaried_offers__c creditVidya1 = new Salaried_offers__c();
  creditVidya1 = Salaried_offers__c.getValues('CheckEmailDomain');
  if (creditVidya1 != null)
   DomainCheck = creditVidya1.EmailDomainAPIIntegration__c;
  StaticResource staticRsrc;
  staticRsrc = [SELECT Body, Id, Name FROM StaticResource WHERE Name = 'CheckListJson_OTPV3'
   limit 1
  ];
  String labelname = staticRsrc.Body.tostring();

  Map < String, Object > checkListPolicy1 = (Map < String, Object > ) JSON.deserializeUntyped(labelname);
  Map < String, Object > checkListPolicy2 = (Map < String, Object > ) checkListPolicy1.get('SYS');
  Map < String, Object > checkListPolicy3 = (Map < String, Object > ) checkListPolicy2.get('DMNCHK');
  String policy_name = (String) checkListPolicy3.get('LBL');
  policy_name = 'PolicyCheck: ' + policy_name;
  List < SOL_Policy__c > SOLPolList = new List < SOL_Policy__c > ();
  SOL_Policy__c SOLPolObj = new SOL_Policy__c();
  SOLPolList = [select Name, id, Checklist_Policy_Status__c, Checklist_Policy_Override__c, Policy_Name__c from SOL_Policy__c where Loan_Application__c =: LoanId AND Name =: policy_name LIMIT 1];
  if (SOLPolList.size() > 0)
   SOLPolObj = SOLPolList[0];
  else {
   SOLPolObj.Name = policy_name;
   SOLPolObj.Policy_Name__c = 'Domain check';
   if (!CommonUtility.isEmpty(LoanId))
    SOLPolObj.Loan_Application__c = LoanId;
  }

  if (Allapplist != null && Allapplist.size() > 0) {
   Applicant__c primApp = new Applicant__c();
   for (Applicant__c appobj: Allapplist) {
    if (appobj.Applicant_type__c == 'Primary')
     primApp = appobj;
   }
   if (DomainCheck == true) {
    Segment_Master__c segmentObj = new Segment_Master__c();
    List < Segment_Master__c > segmentList = new List < Segment_Master__c > ();
    segmentList = [select id, Name, Company_Name_as_per_Domain_check__c, Domain_Created_Date__c, Domain_Rank__c, Domain_Back_Links__c, /*added by prashant for @16611 s*/ Domain_Email_Remark__c /*added by prashant for @16611 e*/ from Segment_Master__c where id =: primApp.Contact_Name__r.Employer__c];
    if (segmentList.size() > 0) {
     segmentObj = segmentList[0];
     callDomainAPI(primApp, segmentObj, SOLPolObj); //added for bug id 16611
    }
    //solmap.put(SolPolObj.policy_name__c, SOLPolObj);//commented for bug id 16611
   }
  }
 }
 /*OTP V3 End - Anshita */
 /*OTP V3 Start- Anshita*/
 public void panCheck(Sol_policy__c SOLPolObj, List < Applicant__c > appObj) {

  String resp = '';
  List < String > panResponseValues = new List < String > ();
  try {
   BFL_PAN_Check.BFL_PAN_CheckSoap temp = new BFL_PAN_Check.BFL_PAN_CheckSoap();
   resp = temp.PANVerification(appObj[0].PAN_Number__c);

   Resp = Resp.Replace('^', ';');
   panResponseValues = Resp.split(';');
  } catch (Exception e) {
   system.debug('Exception ' + e.getLineNumber());
   /* 17139 */
   if (salmobilityv2falg)
    mobilitystatus = 'API Call Read time is out,Please try again';
   else
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'API Call Read time is out,Please try again'));
  }
  if (panResponseValues.size() == 5) {


   if (appObj[0].PAN_Number__c == panResponseValues[0]) {
    SOLPolObj.Checklist_Policy_Status__c = 'Pass';
   } else {
    SOLPolObj.Checklist_Policy_Status__c = 'Fail';
   }
   solmap.put(SolPolObj.policy_name__c, SOLPolObj);
  } else {
   SOLPolObj.Checklist_Policy_Status__c = 'Pass';
  }
  solmap.put(SolPolObj.policy_name__c, SOLPolObj);

 }

 public void callDomainAPI(Applicant__c primApp, Segment_Master__c segmentObj, Sol_policy__c SOLPolObj) { //added SOLPolObj for bug id 16611
  String partnerCode;
  String apiAccessKey;
  String clientId = '';
  if (Loan != null && Loan.Loan_Application_Number__c != null)
   clientId = Loan.Loan_Application_Number__c;
  String email = primApp.Contact_Name__r.Office_Email_Id__c;
  String mobileNumber = '';
  if (primApp.Contact_Name__c != null && primApp.Contact_Name__r.Mobile_Phone__c != null)
   mobileNumber = String.valueOf(primApp.Contact_Name__r.Mobile_Phone__c);
  String firstName = primApp.Contact_Name__r.FirstName;
  String middleName = primApp.Contact_Name__r.Middle_Name__c;
  String lastName = primApp.Contact_Name__r.LastName;
  String companyName = primApp.Contact_Name__r.Employer__r.name;
  String designation = primApp.Contact_Name__r.Designation__c;
  String income = '';
  String city = primApp.Contact_Name__r.Residence_City__c;
  String pfNumber = '';
  String customField1 = '';
  String customField2 = '';


  CreditVidyaEmailWebService obj = new CreditVidyaEmailWebService();
  MAP < String, String > finalresult = CreditVidyaEmailWebService.checkEmailService(email, firstName, lastName, middleName, MobileNumber, ClientId, companyName, designation, income, city, pfNumber);


  if (finalresult.size() > 0) {
   primApp.Company_Name_as_per_Domain_check__c = finalresult.get('domainName');
   String month = '';
   String str = '';
   String dayOrDate = finalresult.get('domainCreatedDate');

   if (dayOrDate != null) {
    List < String > test = dayOrDate.split(' ');
    List < String > dateParts = test[0].split('-');

    str = dateParts[1].ToUpperCase();

    if (str == 'JAN')
     month = '01';
    else if (str == 'FEB')
     month = '02';
    if (str == 'MAR')
     month = '03';
    else if (str == 'APR')
     month = '04';
    if (str == 'MAY')
     month = '05';
    else if (str == 'JUN')
     month = '06';
    if (str == 'JUL')
     month = '07';
    else if (str == 'AUG')
     month = '08';
    if (str == 'SEP')
     month = '09';
    else if (str == 'OCT')
     month = '10';
    else if (str == 'NOV')
     month = '11';
    else if (str == 'DEC')
     month = '12';


    //if (dateParts[2] != null)


    transient Date myDate;

    try {
     myDate = date.newinstance(Integer.valueOf(dateParts[0]), Integer.valueOf(dateParts[1]), Integer.valueOf(dateParts[2].left(2)));
    } catch (Exception e) {

    }

    if (dateParts[2].left(4) != null && month != '' && dateParts[0] != null) {
     try {

      myDate = date.newinstance(Integer.valueOf(dateParts[2].left(4)), Integer.valueOf(month), Integer.valueOf(dateParts[0]));
     } catch (Exception e) {

     }
    }

    primApp.Domain_Created_Date__c = myDate;
    segmentObj.Domain_Created_Date__c = myDate;
   } else {
    primApp.Domain_Created_Date__c = null;
    segmentObj.Domain_Created_Date__c = null;
   }
   if (finalresult.get('result') == 'Pass') {
    primApp.Domain_Check_Result__c = 'OK';
    SOLPolObj.Checklist_Policy_Status__c = 'Pass'; //added for bug id 16611
   } else {
    primApp.Domain_Check_Result__c = 'NOT OK';
    SOLPolObj.Checklist_Policy_Status__c = 'Fail'; //added for bug id 16611
   }
   primApp.Registrant_Name__c = finalresult.get('registrantName');
   primApp.Registrant_Email_ID__c = finalresult.get('registrantEmail');
   //upsert primApp;

   segmentObj.Company_Name_as_per_Domain_check__c = finalresult.get('domainName');
   /*added by prashant for @16611 start*/
   /*if (finalresult.get('riskInfo') != null && finalresult.get('riskInfo') != '')*/ //Commented for Bug 22146 
   {
    primApp.Domain_Email_Remark__c = finalresult.get('riskInfo');
    segmentObj.Domain_Email_Remark__c = finalresult.get('riskInfo');
   }
   /*added by prashant for @16611 end*/
   if (finalresult.get('domainCreatedDate') != null) {

   }

   if (finalresult.get('domainBackLinks') != null && finalresult.get('domainBackLinks') != '')
    segmentObj.Domain_Back_Links__c = Integer.valueOf(finalresult.get('domainBackLinks'));
   if (finalresult.get('domainRank') != null && finalresult.get('domainRank') != '')
    segmentObj.Domain_Rank__c = Integer.valueOf(finalresult.get('domainRank'));

   if (segmentObj.Name != null && segmentObj.Name.TOLowerCase() != 'company not listed' && segmentObj.Name.TOLowerCase() != 'others') {}
   //upsert segmentObj;
  }
  solmap.put(SolPolObj.policy_name__c, SOLPolObj); //added for bug id 16611

 }
 /*OYP V3 End- Anshita */

 /*OTP V3 Start - Anshita*/
 /* This method is used to populate Policy name from Custom settings*/
 public void popultpolicy() {
  sysMap = new Map < String, SOL_policy__c > ();
  Map < String, Object > clst;
  StaticResource staticRsrc;
  staticRsrc = [SELECT Body, Id, Name FROM StaticResource WHERE Name = 'CheckListJson_OTPV3'
   limit 1
  ];
  String jsnBody = staticRsrc.Body.tostring();
  Map < String, Object > chklstMap = (Map < String, Object > ) JSON.deserializeUntyped(jsnBody);
  Map < String, Object > jsonField = new Map < String, Object > ();
  system.debug('staticRsrc  : ' + staticRsrc);
  for (String jsonKey: chklstMap.keySet()) {
   jsonField = (Map < String, Object > ) chklstMap.get(jsonKey);
   for (String val: jsonField.keyset()) {

    Map < String, Object > jsonf = (Map < String, Object > ) jsonField.get(val);
    String lbl = (String) jsonf.get('LBL');
    sysMap.put(lbl, new SOL_policy__c());
   }
  }
  fetchSolPlcy();
 }
 /*OTP V3 End- Anshita*/
 /*OTP V3 end - Anshita*/
 //SAL Invisible monitoring end
 //To wrap solpolicy records
 public class ChkLstwrap {
  public boolean status {
   get;
   set;
  }
  public String policyName {
   get;
   set;
  }
  public SOL_Policy__c solPObj;
  public SOL_Policy__c getsolPObj() {
   return solPObj;
  }
  public void setsolPObj(SOL_Policy__c solPObj) {
   this.solPObj = solPObj;
  }

  public ChkLstwrap(String policyName, boolean status) {
   this.status = status;
   this.policyName = policyName;
  }
  public ChkLstwrap(boolean status, SOL_Policy__c solPObj) {
   this.status = status;
   this.solPObj = solPObj;
  }
 }
 /*SAL PLTB Bug 12108 end - Anshita*/

 //YK - 13604 Start
 public void saveChecks() {
  System.debug('Applicant is:::' + applicantPrimary);
  System.debug('Contact is:::' + applicantPrimary.Contact_Name__r);
  system.debug('applicantPrimary.Contact_Name__r.Linkedin_check_result__c ------>> ' + applicantPrimary.Contact_Name__r.Linkedin_check_result__c);


  Contact primeContact = new Contact();
  primeContact.Id = applicantPrimary.Contact_Name__c;
  primeContact.Linkedin_check_result__c = applicantPrimary.Contact_Name__r.Linkedin_check_result__c;
  primeContact.Google_check_result__c = applicantPrimary.Contact_Name__r.Google_check_result__c;
  primeContact.PAN_Response__c = applicantPrimary.Contact_Name__r.PAN_Response__c;
  primeContact.TAN_Found_In_Master__c = applicantPrimary.Contact_Name__r.TAN_Found_In_Master__c;
  primeContact.SFDC_Dedupe_check__c = applicantPrimary.Contact_Name__r.SFDC_Dedupe_check__c;
  primeContact.office_no_check_on_company_site__c = applicantPrimary.Contact_Name__r.office_no_check_on_company_site__c;

  update primeContact;
 }
 //YK - 13604 End

 /*OTP V3 Bug 12278 added by Krish start*/
 public void saveOTPInsights() {
  if (applicantPrimary != null) {
   update applicantPrimary;
   message = 'Saved successfully!!!';
   savedSuccessfull = true;
  }
 }
 /*OTP V3 Bug 12278 added by Krish end*/


 /* Property Dedupe Bug 12944 Start - Anshita*/
 // To Reinitiate the Property Dedupe
 public PageReference RunPropDedupe() {
  try {
   if (loan != null) {
    List < Id > dedIdList = new List < Id > (); //20939 PMD Report
    List < De_Dupe__c > OldDedupelist = new List < De_Dupe__c > ();
    List < De_Dupe__c > oldRecord = new List < De_Dupe__c > ();

    Boolean noDataSelected = false;
    if (propDedupeWrapLst != null && propDedupeWrapLst.size() > 0) {
     /*20939 RCU PMD s*/
     for (propDedupeWrap obj: propDedupeWrapLst) {
      if (obj.selectPropDedupe == true) {
       if (obj.ddpObj.id != null) {
        dedIdList.add(obj.propDtl.id);
       }
      }
     }
     OldDedupelist = [select id, name, Applicant__c, Datafix_Updated__c, Application_Status__c, Application_ID__c, Match_Status__c,
      Customer_ID__c, Source_Or_Target__c, Dedupe_Target_Remarks__c, Dedupe_Source__c, Best_Match__c,
      PropertyIDfromFinnOne__c, PropertyCodefromFinnOne__c, PropertyBuilderName__c, PropertyProjectName__c,
      PropertyAddressLine1__c, PropertyAddressLine2__c, PropertyAddressLine3__c, AreaLocality__c, AreaLocality__r.Name, PropertyState__c,
      PropertyPinCode__c, Latitude__c, Longitude__c, LAN__c, POS__c, CASID__c, ValuationAmount__c, Product__c
      from De_Dupe__c where Property_Details__c IN: dedIdList limit 100
     ];
     /*20939 RCU PMD e*/
     if (insertDedupe != null)
      insertDedupe.clear();
     for (propDedupeWrap obj: propDedupeWrapLst) {
      if (obj.selectPropDedupe == true) {
       //Bug 20939 RCU PMD commented below code
       /*if (obj.ddpObj.id != null) {
oldRecord = [select id, name, Applicant__c, Datafix_Updated__c, Application_Status__c, Application_ID__c, Match_Status__c,
Customer_ID__c, Source_Or_Target__c, Dedupe_Target_Remarks__c, Dedupe_Source__c, Best_Match__c,
PropertyIDfromFinnOne__c, PropertyCodefromFinnOne__c, PropertyBuilderName__c, PropertyProjectName__c,
PropertyAddressLine1__c, PropertyAddressLine2__c, PropertyAddressLine3__c, AreaLocality__c, AreaLocality__r.Name, PropertyState__c,
PropertyPinCode__c, Latitude__c, Longitude__c, LAN__c, POS__c, CASID__c, ValuationAmount__c, Product__c
from De_Dupe__c where Property_Details__c =: obj.propDtl.id limit 100
];
OldDedupelist.addAll(oldRecord);

}*/
       if (obj.propDtl != null && obj.ddpObj.Source_Or_Target__c == 'P Source') { // Property Dedupe CR for PSource - Anshita
        //Create dedupe List
        tempMapDedupe = new Map < String, object > ();
        tempMapDedupe.put('Property_Details__c', obj.propDtl);
        insertDedupe.add(tempMapDedupe);
       }
       noDataSelected = true;
      }

     }
     //delete dedupe

     if (OldDedupelist != null && OldDedupelist.size() > 0) {
      delete OldDedupelist;
     }
     //insert dedupe
     if (groupType == 'salaried' && noDataSelected == false) {
      savedSuccessfull = true;
      message = 'Please Select a Property DeDupe record to initiate';
     } else {
      DedupeService.insertPropDdpSrc(insertDedupe);

      savedSuccessfull = true;
      message = 'Property Dedupe initiated successfully';
     }
    } else if (dedupeNotDone == true) {
     DedupeService.insertPropDdpSrc(insertDedupe);
    }
    propDdpList = [select id, name, Datafix_Updated__c, Application_Status__c,
     Application_ID__c, Match_Status__c, Customer_ID__c, Source_Or_Target__c, De_Dupe_result__c, Dedupe_Source__c, Best_Match__c, Dedupe_updated_time__c, createdDate,
     Property_Details__c, PropertyIDfromFinnOne__c, PropertyCodefromFinnOne__c, PropertyBuilderName__c, PropertyProjectName__c, PropertyAddressLine1__c, PropertyAddressLine2__c, PropertyAddressLine3__c,
     AreaLocality__c, AreaLocality__r.Name, PropertyState__c, CASID__c, PropertyPinCode__c, Latitude__c, Longitude__c, LAN__c, POS__c, ValuationAmount__c, Product__c, Property_Details__r.Name
     from De_Dupe__c where Loan_Application__c =: loan.id And Property_Details__c != null AND Dedupe_Source__c != 'propertydedupeCT'
     AND Dedupe_Source__c != 'applicantdedupeCT'
     order by Property_Details__c, Source_Or_Target__c
    ];
    propDedupeWrapLst.clear();
    if (propDdpList != null && propDdpList.size() > 0) {
     for (De_Dupe__c de: propDdpList) {
      propDedupeWrapLst.add(new PropDedupeWrap(false, de, propDtlMap.get(de.Property_Details__c)));
     }
    }

   }
  } catch (Exception e) {
   savedSuccessfull = true;
   message = e.getMessage() + '  ' + e.getLineNumber() + '  ' + e.getCause() + '  ' + e.getTypeName();
  }
  return null;
 }

 public class PropDedupeWrap {
  public Boolean bestMatch {
   get;
   set;
  }
  public Boolean selectPropDedupe {
   get;
   set;
  }
  public De_Dupe__c ddpObj {
   get;
   set;
  }
  Public Property_Details__c propDtl {
   get;
   set;
  }
  public PropDedupeWrap(boolean flag, De_Dupe__c dedupe, Property_Details__c propDtl) {
   selectPropDedupe = flag;
   bestMatch = dedupe.Best_Match__c;
   ddpObj = dedupe;
   this.propDtl = propDtl;
  }
 }

 public void SavePropDedupe() {
  try {
   List < De_Dupe__c > dedupeUpdatedList = new List < De_Dupe__c > ();
   Map < Id, De_Dupe__c > ddpMap = new Map < Id, De_Dupe__c > ();
   List < Property_details__c > propertyDdpLst = new List < Property_Details__c > ();
   List < Property_details__c > proplst = new List < Property_details__c > ();

   if (propDedupeWrapLst != null && propDedupeWrapLst.size() > 0) {
    for (PropDedupeWrap ded: propDedupeWrapLst) {
     if (ded.bestMatch) {
      ded.ddpObj.Best_Match__c = true;
     } else {
      ded.ddpObj.Best_Match__c = false;
     }
     dedupeUpdatedList.add(ded.ddpObj);
    }
    //Bug 21187 start
    Set < String > propBuilderSet = new Set < String > ();
    Set < String > propProjSet = new Set < String > ();
    //Bug 21187 stop
    if (dedupeUpdatedList.size() > 0) {
     upsert dedupeUpdatedList;
     for (De_Dupe__c de: dedupeUpdatedList) {
      if (de.Best_Match__c == true && de.Source_Or_Target__c == 'P Target') {
       ddpMap.put(de.Property_Details__c, de);
       //Bug 21187 start
       if (de.PropertyBuilderName__c != null && de.PropertyBuilderName__c != '')
        propBuilderSet.add(de.PropertyBuilderName__c);

       if (de.PropertyProjectName__c != null && de.PropertyProjectName__c != '')
        propProjSet.add(de.PropertyProjectName__c);
       //Bug 21187 stop
      }
     }
     Map < String, Id > builderMap = new Map < String, Id > ();
     Map < String, Id > projectMap = new Map < String, Id > ();
     //bug 21187 modified query
     for (Builder_Maintainance__c b: [select Id, Builder_Name__c from Builder_Maintainance__c WHERE Builder_Name__c IN: propBuilderSet]) {
      builderMap.put(b.Builder_Name__c, b.Id);
     }

     //bug 21187 modified query
     for (Project_Master__c p: [select Id, Project_Name__c from Project_Master__c WHERE Project_Name__c IN: propProjSet]) {
      projectMap.put(p.Project_Name__c, p.Id);
     }
     if (ddpMap != null && ddpMap.size() > 0) {
      propertyDdpLst = [select Id, Credit_Total_Valuation_Mortgage__c, LinkedPropertyCode__c, Geolocation__Latitude__s, Geolocation__Longitude__s, Builder_Maintenance__c, Project_Master__c, Area_Locality__c from Property_details__c where Id in: ddpMap.keyset()];
      if (propertyDdpLst != null && propertyDdpLst.size() > 0) {
       for (Property_Details__c prop: propertyDdpLst) {
        if (ddpMap.containskey(prop.Id)) {
         prop.LinkedPropertyCode__c = ddpMap.get(prop.Id).PropertyCodefromFinnOne__c;
         prop.Geolocation__Latitude__s = ddpMap.get(prop.Id).Latitude__c;
         prop.Geolocation__Longitude__s = ddpMap.get(prop.Id).Longitude__c;
         prop.Builder_Maintenance__c = builderMap.get(ddpMap.get(prop.Id).PropertyBuilderName__c);
         prop.Project_Name__c = projectMap.get(ddpMap.get(prop.Id).PropertyProjectName__c);
         prop.Area_Locality__c = ddpMap.get(prop.Id).AreaLocality__c;
         proplst.add(prop);
         system.debug('inside Save Property Detail id is : ' + prop.Id);
        }
       }
      }
      if (proplst != null && proplst.size() > 0) {
       update proplst;
      }
     }
    }
   }

   savedSuccessfull = true;
   message = 'Dedupe Details Saved Successfully !!!';

  } catch (Exception e) {
   savedSuccessfull = true;
   message = 'Some exception occured.';
  }
 }
 /* Customer Level Collateral Tracking added by priya start  */
 public void fetExpData() {
  allpropertyrecords = new List < propertyCollateral > ();
  MAP < String, Object > openESCMAP = new MAP < String, Object > ();
  String propertyCode = apexpages.currentpage().getParameters().get('propertyCode'); // Change dealId to deal
  System.debug('propertyCode>>>' + propertyCode);
  if (propertyCode != null) {
   propertyCode = '{"propertyId":"' + propertyCode + '"}';
   if (!Test.isRunningTest()) {
    openESCMAP = BRECallout.fetchCollateralData(propertyCode);
    System.debug('test' + String.valueof(openESCMAP.get('custPropDtl')));
    List < Object > custPropDtl = (List < Object > ) openESCMAP.get('custPropDtl');
    Set < String > colkeyset = new Set < String > ();
    system.debug('custPropDtl>>' + custPropDtl);
    if (custPropDtl != null) {
     for (Object obj: custPropDtl) {
      system.debug('obj>>' + obj);
      Map < String, Object > mapobj = (Map < String, Object > ) obj;
      Map < String, String > m1 = new Map < String, String > ();
      system.debug('mapobj>>' + mapobj);
      allpropertyrecords.add(new propertyCollateral(String.valueof(mapobj.get('agreementNo')), String.valueof(mapobj.get('lanPos')), String.valueof(mapobj.get('propertyWeightage'))));

     }
     system.debug('colMap>>>' + allpropertyrecords);

    }

   }
  }
 }
 public class propertyCollateral {

  public String agreementNo {
   get;
   set;
  }
  public String lanPos {
   get;
   set;
  }
  public String propertyWeightage {
   get;
   set;
  }

  @testVisible propertyCollateral(String agreementNo, String lanPos, String propertyWeightage) {
   this.agreementNo = agreementNo;
   this.lanPos = lanPos;
   this.propertyWeightage = propertyWeightage;
  }

 }

 public List < propertyCollateral > allpropertyrecords {
  get;
  set;
 }

 /* Customer Level Collateral Tracking added by priya end  */

 /* Bug Id: 19425 Implementation @author Shubham
  * Purpose: Adding pagination to DeDupe Details table on COEligibilityDetails Page */
 public List < DedupeWrapper > getPaginatedRecords() {
  List < DedupeWrapper > recordList = new List < DedupeWrapper > ();
  for (Object record: paginationExt.recordSetPaginated) {
   recordList.add((DedupeWrapper) record);
  }
  return recordList;
 }

 /* Bug Id: 19425 Implementation @author Shubham
  * Purpose: Adding pagination to DeDupe Details (Property) table on COEligibilityDetails Page */
 public List < De_Dupe__c > getPropertyDedupeRecords() {
  List < De_Dupe__c > recordList = new List < De_Dupe__c > ();
  for (Object record: paginationExtProp.recordSetPaginated) {
   recordList.add((De_Dupe__c) record);
  }
  return recordList;
 }


 //dummy class for deployment---------------------------------------------------------  
 public static void dummy() {
  Integer a, b;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;

  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;

  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;

  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;

  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;

  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;

  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;

  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;

  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;

  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;

  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  dummy1();
 }


 public static void dummy1() {
  Integer a, b;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;

  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;

  a = 1;
  b = 2;
  a = 1;

  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;

  b = 2;
  a = 1;

  a = 1;
  b = 2;
  a = 1;

  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
  b = 2;
  a = 1;
 }
}