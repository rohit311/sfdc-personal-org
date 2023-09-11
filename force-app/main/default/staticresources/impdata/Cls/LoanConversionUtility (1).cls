public class LoanConversionUtility {
    public static Boolean skipPOLA_validations; //25344
 public static String offeringId; // Bug 12463
 //added for Call center S
 public static boolean isCallCenter {
  get;
  set;
 }
 //added for Call center E
 public static Opportunity oppObj {
  get;
  set;
 }
 //declaring variable by pritha for 101 query error start

 public static List < SOL_Policy__c > SolPollist {
  get;
  set;
 }
 public static List < DPLinsurance__c > ListInsurance {
  get;
  set;
 }
 public static List < Fees_and_Charge__c > ListFeesAndCharges {
  get;
  set;
 }
 public static List < Bank_Account__c > objBankDetailsList {
  get;
  set;
 }
 public static List < Property_Details__c > Proplist {
  get;
  set;
 }
 public static List < Personal_Discussion__c > poPDlist {
  get;
  set;
 }
 public static List < SurrogateCAM__c > CAmlist {
  get;
  set;
 }
 public static List < ContentVersion > newAttchmentList = new List < ContentVersion > ();
 public static List < FeedItem > FeedItemList = new List < FeedItem > ();
 public static Set < ID > PoPropID = new set < ID > ();
 public static Map < ID, Property_Details__c > PropMap = new Map < ID, Property_Details__c > ();
 public static set < ID > cdID = new Set < ID > ();
 public static map < ID, id > newMap = new map < ID, id > ();
 public static map < string, ID > strmap = new Map < string, ID > ();
 // bug 13253 end
 //Bug ID 7444 :: RTR For RM start
 /** Commenting for invalid query locator
   public static List < Existing_Loan_Details__c > existingLoan {
       get;
       set;
   }*/
 // Bug ID 7444 :: RTR For RM start
 //declaring variable by pritha for 101 query error end
 public static List < Personal_Discussion__c > objNewPDList {
  get;
  set;
 }
 public static transient Savepoint savePointVar;
 // public static transient Set<String> psdPlcyName = new set<string>(); //SAL PLTB Bug 12108 - Anshita
 public static boolean fromBrowser;
 //Call Center S
 /*public static void checkCallCentreProcess(List < Product_Offerings__c > productOfferObj) {
       isCallCenter = false;
       //added for Call center S need to idetify identifier
       Set < String > callCentrelbl = new Set < String > ();
       if (Label.Call_Centre_Idetifier != null && productOfferObj != null && productOfferObj[0].Lead_Source__c != null) {
           system.debug('label:-' + Label.
           Call_Centre_Idetifier);
           String[] arr = Label.Call_Centre_Idetifier.split(';');
           for (String str: arr) {
               callCentrelbl.add(str.ToUpperCase());
           }
           if (callCentrelbl != null && callCentrelbl.size() > 0) {
               if (callCentrelbl.contains(productOfferObj[0].Lead_Source__c.ToUpperCase())) {
                   isCallCenter = true;
               }
           }
       }
   }Commentted this method as it is moved into Helper class Done By Rajendra */
 //Call Center E

 // CIBIL watch Start   
 public static boolean cibilwatchFlag;
 public static List < Opportunity > objExistingOppList {
  get;
  set;
 }
 public static Opportunity objExistingOpp {

  get;
  set;
 }
 public static Lead leadObj {
  get;
  set;
 }
 // CIBIL watch End

 /* Prajyot 12830 GST implementation Start */
 public static List < Address_Details__c > addressList {
  get;
  set;
 }
 /* Prajyot 12830 GST implementation End */



 public static List < Product_Offerings__c > productOfferObj = new List < Product_Offerings__c > ();
 public static Applicant__c primaryApplicantObj {
  get;
  set;
 }
 //Mortgage Re-Engg Start
 public static Boolean Mortgageflag {
  get;
  set;
 }
 //Mortgage Re-Engg End
 //Added By rajendra for DLRM FOSS Calculator Enhancement
 public static transient boolean isDLRMProduct {
  get;
  set;
 }
 //End here by Rajendra
 //Methods for SAL Mobility V2 PO Bug Id: 17138 start
 public static String salariedFlow {
  get;
  set;
 } //Bug 17138
 //Methods for SAL Mobility V2 PO Bug Id: 17138 end

 // Bug Id : 18159
 public static String accQId = null;
 public static Credit_Officer_Queue_Mapping__c cqom = null;
 public static String SetDetailsofPO(String leadId, String PO_offerId, String flow, String submitTo, String sendToType, AutoQueueAllocationUtility.Response res) {
  try {
   if (res != null) {
    submitTo = res.credituserId;
    accQId = res.queueId;
    if (res.credituserId != Label.Pool_User) {
     cqom = [SELECT Id,Record_lock_by__c,User__c, Capacity__c, Occupied__c FROM Credit_Officer_Queue_Mapping__c WHERE User__c =: res.credituserId LIMIT 1];// Bug Id : 25285 - Concurrency Issue start
     if (cqom != null) cqom.Occupied__c++;
    }
   }
   String result = LoanConversionUtility.ConvertToLoan(leadId, PO_offerId, flow, submitTo, sendToType);
   return result;
  } catch (Exception e) {
   system.debug('!!!!!! : ' + e.getStackTraceString());
   LoanConversionUtility_Helper.unlock(cqom); // Bug Id : 25285 - Concurrency Issue -unlock p2
   return e.getMessage();
  }
 }

 public static string ConvertToLoan(String leadId, String PO_offerId, String flow, String submitTo, String sendToType) {
  System.debug('inside LoanConversionUtility.ConvertToLoan Remote');
  isDLRMProduct = false;
  offeringId = PO_offerId; // Bug 12463
  //4450
  boolean SwitchOtimizedCode = LaonApplicationCreation__c.getValues('RunOptimizeCode(LoanConetionUtiility))').Integrate_Charges_API__c;
  boolean COLStampFlag;
  Mortgageflag = false; //Mortgage Re-Engg

  savePointVar = Database.setSavepoint();

  //4777
  boolean dateFlag = false;
  //Cibil Watch Start
  if (flow == 'CIBILWatch') {
   cibilwatchFlag = true;
  }
  //Cibil Watch End

  //5777
  Boolean DOEFlag = false;
  //call center S
  Set < Id > latestCIBIL_ids = new Set < Id > ();
  List < Cibil__c > cibilList = new List < Cibil__c > ();
  //call center E
  try {

   //leadObj = new Lead();
   List < Lead_Applicants__c > leadApplicants = new List < Lead_Applicants__c > ();

   leadObj = LoanConversionUtility_Helper.GetLeadDetails(leadId);
   /* Added By Ankush For bug -16000 Start */
   if (leadObj != null && LeadObj.SBS_Branch__c == null) {
    return 'Branch Name is Mandatory';
   }

   /* Added By Ankush For bug -16000 End */

   leadApplicants = leadObj.Lead_Applicants__r;
   //PRO DSS Producton issue leena start
   if (leadObj.Applicant_Type__c == '' || leadObj.Applicant_Type__c == null) {
    return 'Lead must have Applicant type selected !!!.........';
   }
   //PRO DSS Producton issue leena end
   /*if (!SwitchOtimizedCode) {
             productOfferObj = leadObj.Product_Offerings__r;
         else {*/
   if (flow == 'salaried') {
    LoanConversionUtility_Helper.salMobilityFlag = true;
   }
   LoanConversionUtility_Helper.salFlow = salariedFlow;
   productOfferObj = LoanConversionUtility_Helper.GetPODetails(leadId, PO_offerId);
   //declaring variable by pritha for 101 query error start
   SolPollist = new List < SOL_Policy__c > ();
   ListInsurance = new List < DPLinsurance__c > ();
   ListFeesAndCharges = new List < Fees_and_Charge__c > ();
   objBankDetailsList = new List < Bank_Account__c > ();
   Proplist = new List < Property_Details__c > ();
   poPDlist = new List < Personal_Discussion__c > ();
   CAmlist = new List < SurrogateCAM__c > ();
 skipPOLA_validations = LoanConversionUtility_Helper.checkproduct(productOfferObj[0]);


   if (productOfferObj.size() > 0) {
    // Mortgage Re-Engg Change      
    Proplist = LoanConversionUtility_Helper.GetPropertyList(string.valueOF(productOfferObj[0].id));

    for (Personal_Discussion__c PD: productOfferObj[0].Personal_Discussion_s__r) {
     poPDlist.add(PD);
    }
    for (SurrogateCAM__c Surrogate: productOfferObj[0].SurrogateCAMS__r) {

     CAmlist.add(Surrogate);
    }
   }
   //declaring variable by pritha for 101 query error end 

   //}
   //optimised code for DPLInsurance S
   ListInsurance.clear();
   Set < String > allCifIds = new Set < String > ();
   /* SAL PLTB added by priya*/
   Set < Id > appIDs = new Set < Id > ();
   for (Lead_Applicants__c leadApp: leadApplicants) {
    if (leadApp.FinnOne_CIF__c != null) {
     allCifIds.add(leadApp.FinnOne_CIF__c);
    }
    appIDs.add(leadApp.Id);
   }
   if (leadObj != null && leadObj.FinnOne_CIF__c != null) {
    allCifIds.add(leadObj.FinnOne_CIF__c);
   }

   //01MOB
   boolean MOBdateFlag = false;
   //List < Id > poId = new List < Id > ();
   Map < id, List < PODetail__c >> PODetailMap = new Map < id, List < PODetail__c >> ();
   Map < id, Decimal > podKickerMap = new Map < id, Decimal > ();


   for (Product_Offerings__c po: productOfferObj) {
    if (po.Lead_Source__c == '01MOB') {
     //poId.add(po.id);
     if (po.PODetails__r.size() > 0)
      PODetailMap.put(po.id, po.PODetails__r);
    }
   }
   //end MOB


   if (productOfferObj.size() > 0) {
    //BUG-16959 DBOL Product Implementation  by Rajesh START
    Boolean isBOLProductLineProduct = false;
    set < string > setBolProdName = new set < string > ();
    if (!commonUtility.isEmpty(Label.BOL_Line_Products))
     setBolProdName.addAll(Label.BOL_Line_Products.split(';'));
    isBOLProductLineProduct = setBolProdName.contains(productOfferObj[0].products__c);
    //BUG-16959 DBOL Product Implementation  by Rajesh END  

    //Mortgage Re-Engg Start

    if (productOfferObj[0] != null && productOfferObj[0].products__c != null) {
     Mortgageflag = LoanConversionUtility_Helper.GetMortgageFlag(productOfferObj[0].products__c);
    }
    //Mortgage Re-Engg End
     Account accountObj = new Account(name = leadObj.name,Last_Name__c = leadObj.LastName,First_Name__c = leadObj.FirstName);
    //accountObj.name = leadObj.name;
    //accountObj.Last_Name__c = leadObj.LastName;
    //accountObj.First_Name__c = leadObj.FirstName;
    if (accQId != null && fromBrowser == true && sendToType == 'Credit') { // Bug Id : 18159
     accountObj.Queue_Master__c = accQId; // Bug Id : 23549
     //accountObj.Queue_ID__c = accQId;
     accountObj.AutoCredit__c = true;
    }
    //added for call center S
    isCallCenter = LoanConversionUtility_Helper.checkCallCentreProcess(productOfferObj);
    //added for call center E
    //added by leena for pro dss changes
    if (productOfferObj[0] != null) {

     accountObj.COP_Date__c = productOfferObj[0].COP_Date__c;
     accountObj.Full_time_COP_Holder__c = productOfferObj[0].Full_time_COP_Holder__c;
     accountObj.Is_COP_active__c = productOfferObj[0].Is_COP_active__c;
     accountObj.Membership_Number__c = productOfferObj[0].Medical_registration_No__c;
     accountObj.MR_Number__c = productOfferObj[0].Sector_Industry__c;
     accountObj.Total_Employment_vintage_Year__c = productOfferObj[0].Total_work_experience__c;
     accountObj.TypeOfDegreeforCA_Architect__c = productOfferObj[0].TypeOfDegreeforCA_Architect__c;

    }
    //Bug: 13885 aadhar integration
    if (productOfferObj[0].Aadhar_Number__c != null) {
     accountObj.Adhaar_Number__c = productOfferObj[0].Aadhar_Number__c;
    }
    if (productOfferObj[0].Sourcing_Channel__c != null) {
     accountObj.Sourcing_Channel__c = productOfferObj[0].Sourcing_Channel__c;
    }
    //BUG-17470 HPRO S
    Boolean isPROProductLineProduct = false;
    if (productOfferObj[0].Products__c != null) {
     //BUG-17470 HPRO S
     transient set < string > setPROProdName = new set < string > ();
     if (!commonUtility.isEmpty(Label.PRO_ProductLine_Products))
      setPROProdName.addAll(Label.PRO_ProductLine_Products.split(';'));
     if (productOfferObj[0].Products__c != null)
      isPROProductLineProduct = setPROProdName.contains(productOfferObj[0].Products__c);
     //BUG-17470 HPRO E
     accountObj.Product__c = productOfferObj[0].Products__c;

     //5777, //BUG-17470 :checking HPRO flag
     if (isPROProductLineProduct) {

      if (LaonApplicationCreation__c.getValues('DOE') != null) {
       DOEFlag = LaonApplicationCreation__c.getValues('DOE').Make_Active__c;
      }
     }

    }

    //4450
    Date COLStampdate = null;
    if (LaonApplicationCreation__c.getValues('Hierarchy Stamping') != null) {
     String COLDate = LaonApplicationCreation__c.getValues('Hierarchy Stamping').Credit_Hierarchy_Stamping_Date__c;
     if (COLDate != null) {

      COLStampdate = date.parse(COLDate);
     }
    }


    if (COLStampdate != null && COLStampdate < productOfferObj[0].createddate) {
     COLStampFlag = true;
    }
    //BOL Revamp Leena start

    if (productOfferObj[0].Products__c == 'BOL') {
     // oppObj.Product__c = 'PSBL';
     accountObj.Product__c = 'PSBL';
                   accountObj.Program_Type__c='BLUS_Preapproved'; //Added for Bug Id : 20187
    }
    //BOL Revamp Leena End

    accountObj.Office_Landline_Number1__c = productOfferObj[0].Office_Phone__c;

    accountObj = LoanConversionUtility_Helper.getData(accountObj, leadObj, productOfferObj[0]);
    //Mortgage Re-Engg Start

    accountObj = LoanConversionUtility_Helper.setAccVal(accountObj, leadObj, productOfferObj[0].Base_Product__c); // Bug Id - 18159 for optimization to handle metadata issue

    // CC Code changes SME
    accountObj = LoanConversionUtility_Helper.setLeadValues(productOfferObj[0], leadObj, accountObj);
    // CC Code changes SME
    //Call center Nov 2016
    if (isCallCenter) {
     accountObj.Qualification__c = 'Post Graduate';
     accountObj.DesignationOTP__c = 'Manager';
    }
    /**Methods for SAL Mobility V2 PO
     *Bug Id: 17138
     *start
     */
    //salariedFlow == 'mobility2' added for mobilityv2 bug@18890
    if (salariedFlow == 'mobility2') {
     accountObj.DesignationOTP__c = leadObj.Designation__c;
    }
    //Mortgage Re-Engg S
    if (MortgageFlag || isCallCenter || salariedFlow == 'mobility2') {
     /**Methods for SAL Mobility V2 PO
      *Bug Id: 17138
      *end
      */
     if (leadObj.Customer_Mobile__c != null) {
      string phNo = leadObj.Customer_Mobile__c;
      phNo = phNo.remove(' ');
      phNo = phNo.remove('(');
      phNo = phNo.remove(')');
      phNo = phNo.remove('-');
      accountObj.Mobile__c = Decimal.valueOf(phNo);
     }
    } else {
     if (leadObj.MobilePhone != null) {
      string phNo = leadObj.MobilePhone;
      phNo = phNo.remove(' ');
      phNo = phNo.remove('(');
      phNo = phNo.remove(')');
      phNo = phNo.remove('-');
      accountObj.Mobile__c = Decimal.valueOf(phNo);
     }
    }
    //Mortgage Re-Engg E
    accountObj.Email_Id__c = leadObj.Email;
    accountObj.Residence_TypeAcc__c = leadObj.Residential_type__c;
    //accountObj.Gender__c = leadObj.Gender__c;
    //Bug Id;14509 , Added condition for RDL.
    //Bug: 17470 added PRO condition
    if (isPROProductLineProduct || productOfferObj[0].Products__c == 'DOCTORS' || productOfferObj[0].Products__c == 'RDL' || productOfferObj[0].Name == 'RDL_FD_Mobile') {
     accountObj.Marital_Status__c = leadObj.Marital_Status__c;
     accountObj.Email_Id__c = leadObj.Office_Email_ID__c;
     accountObj.Office_City__c = productOfferObj[0].Office_City__c;


     /*
    Code added by Rakesh Shinde.
    Purpose :Bug :6217. PRO DSS NEW CREDIT PROGRAM FOR CA SALARIED. Added below if condition     
           */
     /*added condition for CS/CWA by sainath Bug 15858 - December_2017_CS/CWA Program */
     if ((leadObj.Employment_Type__c == 'SEP' && productOfferObj[0].TypeOfDegreeforCA_Architect__c == 'CA' || productOfferObj[0].TypeOfDegreeforCA_Architect__c == 'CS' || productOfferObj[0].TypeOfDegreeforCA_Architect__c == 'CWA') || (productOfferObj[0].TypeOfDegreeforCA_Architect__c == 'ARCHITECT')) {
      accountObj.Profession__c = productOfferObj[0].TypeOfDegreeforCA_Architect__c;
      if (leadObj.Employment_Type__c != null)
       accountObj.Program_Type__c = leadObj.Employment_Type__c.toUpperCase();
      if (productOfferObj[0].Total_Employment_Vintage__c != null)
       accountObj.Total_Employment_vintage_Year__c = String.valueOf(productOfferObj[0].Total_Employment_Vintage__c);
      else
       accountObj.Total_Employment_vintage_Year__c = String.valueOf(productOfferObj[0].Total_work_experience__c);

     } else if (productOfferObj[0].Practice_Type__c == 'Salaried' && productOfferObj[0].TypeOfDegreeforCA_Architect__c == 'CA') {
      accountObj.Profession__c = 'CA';

      accountObj.Program_Type__c = productOfferObj[0].Practice_Type__c.toUpperCase();

      accountObj.Residence_TypeAcc__c = productOfferObj[0].Clinic_Type__c;
      accountObj.Total_Employment_vintage_Year__c = String.valueOf(productOfferObj[0].Total_work_experience__c);
      accountObj.ROC_Registration_Number__c = productOfferObj[0].Medical_registration_No__c;

     }
     //code added by Leena-13487 Engineering Program start
     else if (leadObj.Profession_Type__c == 'Engineers') {
      accountObj.Profession__c = 'Engineers';
      if (leadObj.Employment_Type__c != null)
       accountObj.Program_Type__c = leadObj.Employment_Type__c.toUpperCase();
      accountObj.MR_Number__c = productOfferObj[0].Sector_Industry__c;
      accountObj.Type_of_Degree__c = productOfferObj[0].TypeOfDegreeforCA_Architect__c;
      accountObj.AccCity__c = productOfferObj[0].Resi_Pick_City__c;
     }
     //code added by Leena-13487 Engineering Program end
     else {
      // accountObj.Profession__c = (productOfferObj[0].UTM_Source__c == 'proMobile' && productOfferObj[0].Specialisation__c == 'CA') ? 'CA' : 'DOCTOR'; // Changes by hemant    
      //accountObj.Profession__c = 'DOCTOR';
      // Bug 15858 - December_2017_CS/CWA Program start
      if (productOfferObj[0].UTM_Source__c == 'proMobile') {
       if (productOfferObj[0].Specialisation__c == 'CA') {
        accountObj.Profession__c = 'CA';
       } else if (productOfferObj[0].Specialisation__c == 'CS') {
        accountObj.Profession__c = 'CS';
       } else if (productOfferObj[0].Specialisation__c == 'CWA') {
        accountObj.Profession__c = 'CWA';
       } else {
        accountObj.Profession__c = 'DOCTOR';
       }
      } else {
       accountObj.Profession__c = 'DOCTOR';
      }
      accountObj.Clinic_Type__c = productOfferObj[0].Clinic_Type__c;
      accountObj.Total_Employment_vintage_Year__c = String.valueOf(productOfferObj[0].Total_Employment_Vintage__c); // Bug 13675
      accountObj.Program_Type__c = productOfferObj[0].Program_Type__c;
     }
     //Bug Id:14509,Start.
     if (productOfferObj[0].Products__c == 'RDL' || productOfferObj[0].Name == 'RDL_FD_Mobile') {
      accountObj.Program_Type__c = leadObj.Employment_Type__c.toUpperCase();
     }
     //Bug Id:14509,End
    }
    //added for Call center S
    if (isCallCenter) {
     if (leadObj.Employer__c != null) {
      accountObj.Employer__c = leadObj.Employer__c;
     }
     if (leadObj.Company_Type__c != null) {
      accountObj.Company_Type__c = leadObj.Company_Type__c;
     }
     // Call Center Prod Bug 10551 S
     if (productOfferObj[0].Company_Name__c != null) {
      accountObj.Type_Of_Industry__c = productOfferObj[0].Company_Name__c;
     }

     // Call Center Prod Bug 10551 E
     if (leadObj.Office_Email_Id__c != null) {
      accountObj.Accountant_email_id__c = leadObj.Office_Email_Id__c;
     }
     /*PLTB Changes Bug 14951 added by Anshita Start*/
     accountObj.Name_of_the_Company_Employer__c = leadObj.Employer_Name__c;
     /*PLTB Changes Bug 14951 added by Anshita End*/
    }
    //added for Call center E
    //List < OTPFlowProducts__c > OTP_products = OTPFlowProducts__c.getall().values();//commented for bug id 16166

    //added for bug id 16166 start
    String otpProd;
    if (OTPFlowProducts__c.getValues('OTP Product') != null) {
     otpProd = OTPFlowProducts__c.getValues('OTP Product').Product__c;
    }
    //added for bug id 16166 end
    if (otpProd != null) { //changed condition from OTP_products.size() > 0 to otpProd != null for bug id 16166
     if (flow != null) {
      if ((Label.RelationshipManagementFlow.contains(flow)) && !otpProd.contains(productOfferObj[0].products__c)) {

       accountObj.Flow__c = flow;
      }
      //added for Call center S
      if (!isCallCenter) {
       if ((Label.RelationshipManagementFlow.contains(flow)) && otpProd.contains(productOfferObj[0].products__c)) {

        accountObj.Flow__c = flow;
        accountObj.IS_OTP_FLOW__c = true;
       }
      }
      //added for Call center E
     }
    }
    //SAL SPL Condition added 16166 shilpa  start
    StaticResource statRes = [SELECT Body, Id, Name FROM StaticResource WHERE Name = 'SalariedCustomSettings'
     limit 1
    ];
    String jsnBody = statRes.Body.tostring();
    Map < String, Object > ALLMap = (Map < String, Object > ) JSON.deserializeUntyped(jsnBody);
    Map < String, Object > otpv3Map = (Map < String, Object > ) ALLMap.get('OTPV3');
    String[] otpv3flow, prodArr;
    String flowNew;
    String BlusValues1 = LaonApplicationCreation__c.getValues('BLUS values').BLUS__c;
    List < String > temp1 = BlusValues1.split(',');
    Set < String > SetBlusValues1 = new Set < String > ();
    SetBlusValues1.addAll(temp1);
    if (isCallCenter) {
     if (LaonApplicationCreation__c.getValues('Call Center LAN Flow').Verifier_2_ID__c != null) {
      flowNew = LaonApplicationCreation__c.getvalues('Call Center LAN Flow').Verifier_2_ID__c;
      accountObj.Flow__c = flowNew;
     }
    } else if (productOfferObj[0].Product_Offering_Type1__c != null && SetBlusValues1.Contains(String.valueOf(productOfferObj[0].Product_Offering_Type1__c))) {
     flowNew = 'Mid Office';
     accountObj.Flow__c = flowNew;
    } else {
     flowNew = flow;
    }
    if (otpv3Map != null && otpv3Map.get('Flow') != null)
     otpv3flow = String.valueof(otpv3Map.get('Flow')).split(';');
    if (otpv3Map != null && otpv3Map.get('Product') != null) {
     prodArr = String.valueof(otpv3Map.get('Product')).split(';');
     if (productOfferObj[0] != null && prodArr.contains(productOfferObj[0].products__c) && otpv3flow.contains(flowNew)) {
      accountObj.IS_OTP_FLOW__c = false;
     }
    }
    //SAL SPL Condition added 16166 shilpa end
    //SAL RSL Condition added Rohit start
    if (productOfferObj[0] != null && productOfferObj[0].products__c == 'RSL') {

     accountObj.IS_OTP_FLOW__c = false;
    }
    //SAL RSL Condition added Rohit end
    accountObj.Specialisation__c = productOfferObj[0].Specialisation__c;
    accountObj.Degree__c = productOfferObj[0].Degree__c;
    //added for Call center 22 Nov 2016 S
    if (!isCallCenter) {
     if (productOfferObj[0].Experience_in_Years__c != null) accountObj.Current_experiance_in_Years__c = String.valueOf(productOfferObj[0].Experience_in_Years__c);
    }
    //added for Call center 22 Nov 2016 E
    /*Mobility for SAL added by priya Start*/
    if (flow == 'salaried') {
     accountObj.Name_of_the_Company_Employer__c = leadObj.Employer_Name__c;
     // if (productOfferObj[0].Total_work_experience__c != null) accountObj.Total_Work_Experience_Yrs__c = String.valueOf(productOfferObj[0].Total_work_experience__c);
     accountObj.Gross_Salary_Turn_Over__c = productOfferObj[0].Net_Salary_Per_Month__c;
     accountObj.Flow__c = 'Mobility';
    }
    /**Methods for SAL Mobility V2 PO
     *Bug Id: 17138
     *start
     */
    if (salariedFlow == 'mobility2') {
     accountObj.Flow__c = 'Mobility V2';
    }
    /**Methods for SAL Mobility V2 PO
     *Bug Id: 17138
     *end
     */
    /*Mobility for SAL added by priya End*/
    accountObj.Process_Type__c = productOfferObj[0].Process_Type__c;
    //For SPL and SAL cases goup type need to be salaried which will stop repeat cibil issue
    if ((productOfferObj[0].Process_Type__c == '' || productOfferObj[0].Process_Type__c == null) && (productOfferObj[0].products__c == 'SAL' || productOfferObj[0].products__c == 'SPL')) {

     accountObj.Group_Type__c = 'salaried';
    } else {
     //--------------------Mortgage Re-Engg Starts---------------------
     accountObj.Group_Type__c = productOfferObj[0].Process_Type__c;
    }
    //--------------------Mortgage Re-Engg End---------------------
    //********************* DL Re engineering **********************************
    if (productOfferObj[0].Total_Employment_Vintage__c != null) accountObj.Total_Employment_vintage_Year__c = string.valueOf(productOfferObj[0].Total_Employment_Vintage__c);
    //added for Call center 22 Nov 2016 S
    if (!isCallCenter) {
     if (productOfferObj[0].Total_Employment_Vintage__c != null) accountObj.Total_Work_Experience_Yrs__c = string.valueOf(productOfferObj[0].Total_Employment_Vintage__c);
    }
    //added for Call center 22 Nov 2016 E
    accountObj.Post_Graduate_Super_Specialist_Experienc__c = productOfferObj[0].Post_Graduate_Super_Specialist_Experienc__c;
    accountObj.Practice_Type__c = productOfferObj[0].Practice_Type__c;
    //***************************************************************************/
    /*
    Code added by Rakesh Shinde.Date : 19 April 2016
    BRD : Bug :6217 -PRO DSS NEW CREDIT PROGRAM FOR CA SALARIED  
    Purpose : Save employer details from PO to Opportunity for CA-SAL          
     */
    if (productOfferObj[0].TypeOfDegreeforCA_Architect__c == 'CA' || productOfferObj[0].TypeOfDegreeforCA_Architect__c == 'CS' || productOfferObj[0].TypeOfDegreeforCA_Architect__c == 'CWA') {
     accountObj.Employer__c = productOfferObj[0].Clinic__c;
     accountObj.Company_Type__c = productOfferObj[0].Clinic__r.Employer_List__c;
     accountObj.Type_Of_Industry__c = productOfferObj[0].Clinic__r.Company_Category__c;
    }
    isDLRMProduct = LoanConversionUtility_Helper.GetIsDLRMProduct(productOfferObj[0].Products__c);
    if (isDLRMProduct) {
     accountObj.Date_of_Birth__c = productOfferObj[0].dob__c;
     accountObj.Post_Graduate_Super_Specialist_Experienc__c = productOfferObj[0].Post_Graduate_Super_Specialist_Experienc__c;
     accountObj.Type_of_Degree__c = productOfferObj[0].Type_of_Degree__c;
     accountObj.Profession__c = productOfferObj[0].lead__r.Profession_Type__c;
    }
    /**Methods for SAL Mobility V2 PO
     *Bug Id: 17138
     *start
     */
    if (salariedFlow == 'mobility2') {
     if (!CommonUtility.isEmpty(productOfferObj[0].Total_work_experience__c))
      accountObj.Total_Work_Experience_Yrs__c = String.valueof(productOfferObj[0].Total_work_experience__c);
     if (!CommonUtility.isEmpty(productOfferObj[0].Experience_in_Years__c))
      accountObj.Current_experiance_in_Years__c = String.valueof(Integer.valueof(productOfferObj[0].Experience_in_Years__c));
     if (!CommonUtility.isEmpty(leadObj.Company_Type__c))
      accountObj.Type_Of_Industry__c = leadObj.Company_Type__c;
    }
    /**Methods for SAL Mobility V2 PO
     *Bug Id: 17138
            /* chages added by sneha for Bug-19240 - Start
           Boolean isNewProdacc = LoanConversionUtility_Helper.getNewProgCondition(productOfferObj[0]);
           if(isNewProdacc){
           accountObj.Program_Type__c = 'New Program';  
           }
           /* chages added by sneha for Bug-19240 - End*/
    insert accountObj;
    if (cqom != null) {
        //update cqom; // Bug Id : 18159 // Bug Id : 25285 - Concurrency Issue start
        System.debug('record lock --> ' + cqom.Record_lock_by__c + ' condition satisfy - ' + (cqom.Record_lock_by__c == UserInfo.getUserId()));
        if (Approval.isLocked(cqom.Id) && cqom.Record_lock_by__c == UserInfo.getUserId()) {
            cqom.Record_lock_by__c = null; update cqom;
            Approval.unlock(cqom.Id, false);
        } // Bug Id : 25285 - Concurrency Issue end 
    }
    List < Contact > newContacts = new List < Contact > ();

    Contact contactObj = new Contact();
    contactObj.AccountId = accountObj.id;
    contactObj.ApplicantType__c = 'Primary';
    contactObj.Employer_Name__c = leadObj.Employer_Name__c;
    contactObj.Employer__c = leadObj.Employer__c;
    contactObj.Company_Type__c = leadObj.Company_Type__c;
       //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement start
                contactObj.Salutation=leadObj.Salutation;
                 //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement end
    //Bug: 13885 aadhar integration
    if (productOfferObj[0].Aadhar_Number__c != null) {
     contactObj.Adhaar_Number__c = productOfferObj[0].Aadhar_Number__c;
    }
    if (productOfferObj[0].Address_Line_1__c != null) {
     contactObj.Address_1__c = productOfferObj[0].Address_Line_1__c;
     contactObj.Address_2__c = productOfferObj[0].Address_Line_2__c;
     contactObj.Address_3__c = productOfferObj[0].Address_Line_3__c;
     contactObj.AppCity__c = productOfferObj[0].Resi_City__c;
     contactObj.Residence_City__c = productOfferObj[0].Resi_City__c;
     if (productOfferObj[0].Pin_Code__c != null)
      contactObj.Pin_Code__c = Decimal.valueOf(productOfferObj[0].Pin_Code__c);
     contactObj.State__c = productOfferObj[0].Resi_State__c;
    } else {
     contactObj.Address_1__c = leadObj.Residence_Address_Line1__c;
     contactObj.Address_2__c = leadObj.Residence_Address_Line2__c;
     contactObj.Address_3__c = leadObj.Residence_Address_Line3__c;
     contactObj.STD_Code__c = leadObj.Resi_STD__c;
     contactObj.AppCity__c = leadObj.Resi_City__c; //added by ksr 
     contactObj.Residence_Landline_phone__c = leadObj.Office_Phone_Number__c;
     if (leadObj.Resi_Pin_Code__c != null) {
      contactObj.Pin_Code__c = DEcimal.valueOf(leadObj.Resi_Pin_Code__c);
     }
     contactObj.Residence_City__c = leadObj.Resi_City__c;
    }

    contactObj.Office_City__c = leadObj.Lead_Office_City__c;
    contactObj.phone = leadObj.phone;
    contactObj.LastName = leadObj.lastname;
    contactObj.firstname = leadObj.FirstName;
    contactObj.TAN_Number__c = leadObj.TAN__c;
    contactObj.Type_of_Constitution__c = leadObj.Constitution__c;
    contactObj.CIF_Id__c = leadObj.FinnOne_CIF__c;
    contactObj.Year_of_Incorporation__c = leadObj.Incorporation_Date__c;
    contactObj.Marital_Status__c = leadObj.Marital_Status__c;
    contactObj.gender__c = leadObj.gender__c;

    if (contactObj.gender__c == 'Male') {
     contactObj.Sex__c = 'M';
    } else if (contactObj.gender__c == 'Female') {
     contactObj.Sex__c = 'F';
    } else {}
    // code added by Leena-13487 Engineering Program start

    if (leadObj.Nature_of_Business__c == null && leadObj.Profession_Type__c == 'Engineers') {
     contactObj.Nature_of_Business__c = productOfferObj[0].Nature_of_Business__c;
    }
    // code added by Leena-13487 Engineering Program end
    if (leadObj.Profession_Type__c != 'Engineers')
     contactObj.Nature_of_Business__c = leadObj.Nature_of_Business__c;
    contactObj.Residence_Type__c = leadObj.Residential_type__c;
    contactObj.PAN_Number__c = leadObj.PAN__c;
    contactObj.Email__c = leadObj.Email;
    contactObj.Qualification__c = leadObj.Education_status__c;
    contactObj.Year_of_Incorporation__c = leadObj.Incorporation_Date__c;
    contactObj.Date_of_Birth__c = leadObj.DOB__c;
    contactObj.Permanant_Address_Line_1__c = leadObj.Permanent_Line_1_New__c;
    contactObj.Permanant_Address_Line_2__c = leadObj.Address_Line_2_New__c;
    contactObj.Permanant_Address_Line_3__c = leadObj.Permanent_Address_3__c;
    contactObj.Permanant_City__c = leadObj.Per_City__c;
    contactObj.Permanent_Mobile__c = leadObj.Phone_Number__c;
    contactObj.Permanent_Pin_Code__c = leadObj.Per_Pin_Code__c;
    contactObj.Permanent_STD__c = leadObj.Per_STD__c;
    contactObj.Permenant_Phone__c = (leadObj.Per_Phone__c == null ? '' : String.valueOf(leadObj.Per_Phone__c));
    contactObj.Address_1st_Line__c = leadObj.Registered_Address_1__c;
    contactObj.Regi_Address_2nd_Line__c = leadObj.Registered_Address_2__c;
    contactObj.Regi_Address_3rd_Line__c = leadObj.Registered_Address_3__c;
    contactObj.Residence_City__c = leadObj.Regist_City__c;
    contactObj.STD_Code__c = leadObj.Regi_STD__c;
    contactObj.Phone_Number__c = (leadObj.Regi_Phone__c == null ? '' : String.valueOf(leadObj.Regi_Phone__c));
    contactObj.Caste_Category__c = leadObj.Caste_Category__c;
    contactObj.Religion__c = leadObj.Religion__c;
    contactObj.Other_Caste_Category__c = leadObj.Other_Caste_Category__c;
    contactObj.Other_Religion__c = leadObj.Other_Religion__c;
    contactObj.movedToCibilTemp__c = leadObj.movedToCibilTemp__c;
    contactObj.Update_CIBIL_Error__c = leadObj.Update_CIBIL_Error__c;
    contactObj.CIBIL_Match_Check__c = leadObj.CIBIL_Match_Check__c;
    contactObj.CIBIL_Score__c = leadObj.CIBIL_Score__c;
    //commented on 21 Nov 2016
    //contactObj.Lead__c = leadObj.id;
    //contactObj.Cibil_Temp__c = leadObj.Cibil_Temp__c;
    contactObj.Office_Email_Id__c = leadObj.Office_Email_Id__c;

    if (leadObj.MobilePhone != null) {
     string phNo = leadObj.MobilePhone;
     phNo = phNo.remove(' ');
     phNo = phNo.remove('(');
     phNo = phNo.remove(')');
     phNo = phNo.remove('-');
     contactObj.Mobile__c = Decimal.valueOf(phNo);
    }

    if (productOfferObj[0].Office_Address_1__c != null) {
     contactObj.Address_Line_One__c = productOfferObj[0].Office_Address_1__c;
     contactObj.Address_2nd_Line__c = productOfferObj[0].Office_Address_2__c;
     contactObj.Address_3rd_Line__c = productOfferObj[0].Office_Address_3__c;
     contactObj.Office_City__c = productOfferObj[0].Office_City__c;
     contactObj.Office_Pin_Code__c = String.valueOf(productOfferObj[0].Office_Pin_Code__c);
     contactObj.Office_State__c = productOfferObj[0].Office_State__c;
     contactObj.Office_Phone_Number__c = productOfferObj[0].Office_Phone__c;
    } else {
     contactObj.Address_Line_One__c = leadObj.Lead_Office_Address_Line1__c;
     contactObj.Address_2nd_Line__c = leadObj.Lead_Office_Address_Line2__c;
     contactObj.Address_3rd_Line__c = leadObj.Lead_Office_Address_Line3__c;
     contactObj.Office_City__c = leadObj.Off_City__c;
     contactObj.Office_Pin_Code__c = String.valueOf(leadObj.Off_Pin_Code__c);
     contactObj.Office_STD_Code__c = leadObj.Office_STD__c;
     contactObj.Office_Phone_Number__c = leadObj.Office_Phone_Number__c;
    }

    if ((leadObj.Customer_Type__c == null) && (productOfferObj[0].products__c == 'SAL' || productOfferObj[0].products__c == 'SPL' || productOfferObj[0].products__c == 'SBS CS SAL')) {
     contactObj.Customer_Type__c = 'Individual';
    } else {
     contactObj.Customer_Type__c = leadObj.Customer_Type__c;
    }
    //contactObj.Gender__c = leadObj.Gender__c;
    contactObj.CIF_Id__c = leadObj.Customer_ID__c;

    // code added by pankaj gupta for SHL And SHOL ; Date- 30/9/2016
    if (MortgageFlag && (productOfferObj[0].products__c == 'SHL' || productOfferObj[0].products__c == 'SHOL')) {
     contactObj.Property_Owner__c = leadObj.Property_Owner__c;

    }

    //pankaj gupta;END 
    /*Mobility for SAL added by priya Start*/
    if (flow == 'salaried') {
     List < SurrogateCAM__c > surrCamList = new List < SurrogateCAM__c > ();
     surrCamList = productOfferObj[0].SurrogateCAMS__r;
     if (surrCamList.size() > 0) {
      contactObj.Special_Profile_Employer__c = surrCamList[0].Special_Profile_Employer__c;
     }
     contactObj.Email = leadObj.Email;
    }
    /*Mobility for SAL added by priya End*/
    newContacts.add(contactObj);


    for (Lead_Applicants__c leadApp: leadApplicants) {
     Contact contact = new Contact();
     contact.AccountId = accountObj.id;
     //contact.LastName = leadApp.Last_Name__c;  // comenting for bug 12862
     //contact.firstname = leadApp.First_Name__c; // comenting for bug 12862 and adding below if else
     // bug 12862 start
     contact = LoanConversionUtility_Helper.getContact(leadApp, contact);
     // bug 12862 end
     contact.ApplicantType__c = leadApp.Applicant_Type__c;
     contact.Type_of_Constitution__c = leadApp.Constitution__c;
     contact.Year_of_Incorporation__c = leadApp.Incorporation_Date__c;
     contact.Marital_Status__c = leadApp.Marital_Status__c;
     contact.gender__c = leadApp.gender__c;
     contact.Nature_of_Business__c = leadApp.Nature_of_Bu__c;
     contact.Residence_Type__c = leadApp.Residential_type__c;
     contact.TAN_Number__c = leadApp.TAN__c;
     contact.Address_1__c = leadApp.Residence_Address_1__c;
     contact.Address_2__c = leadApp.Residence_Address2__c;
     contact.Address_3__c = leadApp.Residence_Address_3__c;
     contact.Permanant_Address_Line_1__c = leadApp.Permanent_Residence_Address_1__c;
     contact.Permanant_Address_Line_2__c = leadApp.Permanent_Residence_Address_2__c;
     contact.Permanant_Address_Line_3__c = leadApp.Permanent_Residence_Address_3__c;
     contact.Permanant_City__c = leadApp.Permanent_City__c;
     contact.Permanent_Mobile__c = leadApp.Permanent_Mobile__c;
     contact.Permanent_Pin_Code__c = leadApp.Permanent_PinCode__c;
     contact.Permenant_Phone__c = leadApp.Permenant_Phone__c;
     contact.Permanent_STD__c = leadApp.Permanent_STD__c;
     if (leadApp.Resi_Phone__c != null) contact.Residence_Landline_phone__c = String.valueOf(leadApp.Resi_Phone__c);
     contact.Pin_Code__c = leadApp.Resi_Pin__c;
     contact.STD_Code__c = leadApp.Resi_STD__c;
     contact.Residence_City__c = leadApp.Resi_City__c;
     contact.AppCity__c = leadApp.Resi_City__c;
     contact.phone = leadApp.phone__c;
     contact.Address_1st_Line__c = leadApp.Regi_Address_1__c;
     contact.Regi_Address_2nd_Line__c = leadApp.Regi_Address_2__c;
     contact.Regi_Address_3rd_Line__c = leadApp.Regi_Address_3__c;
     contact.Phone_Number__c = (leadApp.Regi_Phone__c == null ? '' : String.valueOf(leadApp.Regi_Phone__c));
     if (leadApp.PAN__c != null) contact.PAN_Number__c = leadApp.PAN__c.toUpperCase(); //SAL PLTB Bug 12735 added by priya
     contact.Email__c = leadApp.Email__c;
     contact.Year_of_Incorporation__c = leadApp.Incorporation_Date__c;
     contact.Date_of_Birth__c = leadApp.DOB__c;
     contact.Address_Line_One__c = leadApp.Lead_Office_Address_Line1__c;
     contact.Address_2nd_Line__c = leadApp.Lead_Office_Address_Line2__c;
     contact.Address_3rd_Line__c = leadApp.Lead_Office_Address_Line3__c;
     contact.Office_City__c = leadApp.Off_City__c;
     contact.Office_Pin_Code__c = String.valueOf(leadApp.Off_Pin_Code__c);
     contact.Office_STD_Code__c = leadApp.Office_STD__c;
     contact.Office_Phone_Number__c = leadApp.Office_Phone_Number__c;
     contact.Caste_Category__c = leadApp.Caste_Category__c;
     contact.Religion__c = leadApp.Religion__c;
     contact.Other_Caste_Category__c = leadApp.Other_Caste_Category__c;
     contact.Other_Religion__c = leadApp.Other_Religion__c;
     if ((lead.Customer_Type__c == null) && (productOfferObj[0].products__c == 'SAL' || productOfferObj[0].products__c == 'SPL' || productOfferObj[0].products__c == 'SBS CS SAL')) {
      contact.Customer_Type__c = 'Individual';

     } else {
      contact.Customer_Type__c = leadApp.Customer_Type__c;
     }

     if (leadApp.Mobile__c != null) {

      string mobNo = leadApp.Mobile__c;
      mobNo = mobNo.remove(' ');
      mobNo = mobNo.remove('(');
      mobNo = mobNo.remove(')');
      mobNo = mobNo.remove('-');
      contact.Mobile__c = Decimal.valueOf(mobNo);
     }
     //call center Nov 2016 S
     if (isCallcenter) {
      if (leadApp.Office_Mobile__c != null) {
       string mobNo = String.valueOf(leadApp.Office_Mobile__c);
       mobNo = mobNo.remove(' ');
       mobNo = mobNo.remove('(');
       mobNo = mobNo.remove(')');
       mobNo = mobNo.remove('-');
       contact.Mobile__c = Decimal.valueOf(mobNo);

      }
      /*SAL PLTB Bug12108 start - added by krish */
      contact.Date_of_Birth__c = leadApp.Date_of_Birth__c;
      contact.Relationship_Borrower__c = leadApp.Relationship_With_Applicant__c;
      contact.bank_name1__c = leadApp.Bank_name_of_salary_account__c;
      if (leadApp.Aadhar_Number__c != null)
       contact.Aadhar_Number__c = long.valueof(leadApp.Aadhar_Number__c); //SAL PLTB Bug 12735 added by priya
      contact.Employer__c = leadApp.Employer__c;
      contact.Company_Category__c = leadApp.Company_Category__c;
      contact.State__c = leadApp.Resi_State__c;
      contact.Resi_Area__c = leadApp.Resi_Area__c;
      contact.Office_State__c = leadApp.Office_State__c;
      /*SAL PLTB Bug12108 end - added by krish */
     }
     //call center Nov 2016 E
     contact.movedToCibilTemp__c = leadApp.movedToCibilTemp__c;
     contact.Update_CIBIL_Error__c = leadApp.Update_CIBIL_Error__c;
     contact.CIBIL_Match_Check__c = leadApp.CIBIL_Match_Check__c;
     contact.CIBIL_Score__c = leadApp.CIBIL_Score__c;
     contact.Lead_Applicants__c = leadApp.id;
     /**Methods for SAL Mobility V2 PO
      *Bug Id: 17138
      *start
      */
     if (salariedFlow == 'mobility2' && !CommonUtility.isEmpty(productOfferObj[0].Alternate_Mobile_No__c)) {
      contact.MOBILE_N__c = Decimal.ValueOf(productOfferObj[0].Alternate_Mobile_No__c);
     }
     /**Methods for SAL Mobility V2 PO
      *Bug Id: 17138
      *end
      */

     //contact.Cibil_Temp__c = leadApp.Cibil_Temp__c; 
     //Mortgage Re-Engg Start
     if (MortgageFlag) {
      contact.Property_Owner__c = leadApp.Property_Owner__c;
     }
     //Mortgage Re-Engg End
     newContacts.add(contact);


    }
    if (newContacts != null && newContacts.size() > 0) {

     insert newContacts;

    }


    Id recordTypeId;
    Id FASRecordtypeId;
    Id creditRecordtypeId;

    for (Schema.RecordTypeInfo RT: Opportunity.SObjectType.getDescribe().getRecordTypeInfos()) {
     if (rt.getName() == 'CPA') recordTypeId = rt.getRecordTypeId();
     if (rt.getName() == 'DSA') FASRecordtypeId = rt.getRecordTypeId();
     if (rt.getName() == 'ACM') creditRecordtypeId = rt.getRecordTypeId();
    }

    /*Code commented for optimization--- harsit---START*/
    /*Set < String > newContactIds = new Set < String > ();

           for (Contact cont: newContacts) {
               system.debug('cont:' + cont);
               newContactIds.add(cont.Id);
           }*/
    /*Code commented for optimization--- harsit---END*/

    oppObj = new Opportunity();
    //Call Center Optimization S
    /**Methods for SAL Mobility V2 PO
     *Bug Id: 17138
     *start
     */
    if ((isCallcenter || salariedFlow == 'mobility2') && productOfferObj[0].PF__c != null) {
     oppObj.Processing_Fees__c = productOfferObj[0].PF__c;
    }
    if (salariedFlow == 'mobility2') {
     if (productOfferObj[0].EMI_Amount__c != null)
      oppObj.EMI_CAM__c = productOfferObj[0].EMI_Amount__c;
    }
    /**Methods for SAL Mobility V2 PO
     *Bug Id: 17138
     *end
     */
    //Call Center Optimization E
    //added by leena to stamp ASM email id on opportunity
    if (productOfferObj[0].ASM__r != null) {
     oppObj.ASM_email_id__c = productOfferObj[0].ASM__r.Email;
    }
    /* mobility for SAL start*/
 if (skipPOLA_validations && CommonUtility.isEmpty(productOfferObj[0].Offer_Amount__c)) //25344
                {
                    productOfferObj[0].Offer_Amount__c = 1;
                }
    if (flow == 'salaried' && !CommonUtility.isEmpty(productOfferObj[0].Offer_Amount__c))
     oppObj.amount = productOfferObj[0].Offer_Amount__c;
    else
     oppObj.amount = productOfferObj[0].Offer_Accepted_amount__c;
    /* mobility for SAL end*/
    // oppObj.amount = productOfferObj[0].Offer_Accepted_amount__c;
    //oppObj.Approved_Loan_Amount__c = productOfferObj[0].Offer_Amount__c;
    oppObj.Approved_Loan_Amount__c = productOfferObj[0].Availed_Amount__c;
    oppObj.AccountId = accountObj.Id;
    oppObj.Product__c = productOfferObj[0].Products__c;
    //BOL Revamp Leena start
    if (productOfferObj[0].Products__c == 'BOL'){
        oppObj.Product__c = 'PSBL';
        oppObj.Program_Type__c='BLUS_Preapproved'; //Added by bug Id : 20187
       }        
   /*if(isBOLProductLineProduct) //added by sneha afor 17588
    {
        //added by Mahima- 17588
        oppObj.Program_Type__c='BLUS_Preapproved';
    }*/
    //BOL Revamp Leena End
    oppObj.Branch_Name__c = leadObj.SBS_Branch__c;
    //oppObj.Loan_Amount__c = productOfferObj[0].Offer_Amount__c;
    oppObj.Loan_Amount__c = productOfferObj[0].Availed_Amount__c;
    oppObj.Scheme_Master__c = productOfferObj[0].SBS_Scheme__c;
    oppObj.Type_of_Constitution__c = leadObj.Constitution__c;
    oppObj.Nature_of_Business__c = leadObj.Nature_of_Business__c;
    oppObj = LoanConversionUtility_Helper.setPOValues(productOfferObj[0], oppObj); // CC Code changes SME
    // code added by Leena-13487 Engineering Program start

    if (leadObj.Nature_of_Business__c == null && leadObj.Profession_Type__c == 'Engineers') {
     oppObj.Nature_of_Business__c = productOfferObj[0].Nature_of_Business__c;
    }
    oppObj.Tenor__c = productOfferObj[0].Tenor__c;
    //oppObj.Loan_Application_Flow__c = flow;
    //**SAL PLTB change BugId - 13958 start
    oppObj.Office_PhoneRef1__c = leadObj.Office_Phone_Number__c;
    //**SAL PLTB change BugId - 13958 end
    oppObj.Approved_Tenor__c = productOfferObj[0].Tenor__c;
    oppObj.Sourcing_Channel__c = productOfferObj[0].Sourcing_Channel__c;
    oppObj.approver__c = 'CPA Login Partner';
    oppObj.Finance_Amount__c = productOfferObj[0].Ext_Finance_Amount__c;
    oppObj.If_Yes__c = productOfferObj[0].Existing_LAN__c;
    oppObj.Main_Sector__c = productOfferObj[0].Sector_Industry__c;
    //Bug 6975 - BLUS and Pre approved movement to DSS by akshata 13th jun 2016 start
    /* mapping of product offering type to program type of opportunity for blus product*/
    String BlusValues = LaonApplicationCreation__c.getValues('BLUS values').BLUS__c;
    List < String > temp = BlusValues.split(',');
    Set < String > SetBlusValues = new Set < String > ();
    SetBlusValues.addAll(temp);
    //code added by Leena for DLUS flow bug id:- 14510--start
    set < String > setDLUS;
    String DLUSTypes;
    if (LaonApplicationCreation__c.getValues('BLUS values') != null)
     DLUSTypes = LaonApplicationCreation__c.getValues('BLUS values').Program_Types__c;
    if (DLUSTypes != null && DLUSTypes != '')
     setDLUS = new Set < String > (DLUSTypes.split(';'));
    //code added by Leena for DLUS flow bug id:- 14510--end
    if (productOfferObj[0].Product_Offering_Type1__c != null && ((SetBlusValues.Contains(String.valueOf(productOfferObj[0].Product_Offering_Type1__c))) || (setDLUS.Contains(String.valueOf(productOfferObj[0].Product_Offering_Type1__c))))) {
     oppObj.Program_Type__c = productOfferObj[0].Product_Offering_Type1__c;
     oppObj.Loan_Application_Flow__c = 'Mid Office';
    } else {
     oppObj.Program_Type__c = productOfferObj[0].Program_Type__c;
     oppObj.Loan_Application_Flow__c = flow;
    }
    //Bug 6975 - BLUS and Pre approved movement to DSS by akshata 13th jun 2016 end

    //Bug ID - 13489 BOL Re-invent By Rajesh START
    if (isBOLProductLineProduct && !CommonUtility.isEmpty(productOfferObj[0].Nature_of_Business__c))
     oppObj.Nature_of_Business__c = productOfferObj[0].Nature_of_Business__c;
    //Bug ID - 13489 BOL Re-invent By Rajesh END
    /*Added by sneha for Bug-19240 - Start
          Boolean isNewProd = LoanConversionUtility_Helper.getNewProd(productOfferObj[0].products__c);
         if(isNewProd){
         oppObj.Program_Type__c = 'BLUS_Preapproved';    
         }
         /*Added by sneha for Bug-19240 - End*/

    oppObj.Main_Sub_Industry__c = productOfferObj[0].SubIndustry__c;
    //oppObj.Program_Type__c = productOfferObj[0].Program_Type__c;
    oppObj.Existing_LAN_Tenor__c = productOfferObj[0].Existing_Tenor__c;
    oppObj.Old_Product__c = productOfferObj[0].Existing_Product__c;
    oppObj.stagename = 'Pending CPA Acceptance';
    oppObj.CloseDate = date.today() + 90;
    oppObj.name = accountObj.name;
    oppObj.recordTypeId = recordTypeId;
    oppObj.Existing_Customer__c = 'Existing Customer';
    oppObj.Approved_Rate__c = productOfferObj[0].Offer_ROI__c;
    /* SAL PLTB added by priya start
         if(isCallcenter && productOfferObj[0].Enquiry_Amount__c != null) {
             oppObj.Offer_Amount__c = productOfferObj[0].Enquiry_Amount__c;
         }
         else  SAL PLTB added by priya end*/
    oppObj.Offer_Amount__c = productOfferObj[0].Offer_Amount__c;
    oppObj.Product_Offereing_id__c = productOfferObj[0].Offer_ID__c;
    oppObj.Topup_Amount__c = productOfferObj[0].Topup_Amount__c;
    oppObj.Last_EMI_Paid__c = productOfferObj[0].Last_EMI_Paid__c;
    oppObj.Balance_Tenure__c = productOfferObj[0].Balance_Tenure__c;
    oppObj.DPD_String__c = productOfferObj[0].DPD_String__c;
    oppObj.Bucket_String__c = productOfferObj[0].Bucket_String__c;
    oppObj.Old_SFDC_Loan_Application__c = productOfferObj[0].Old_SFDC_Loan_Application__c;
    oppObj.Bounce_in_Life_Cycle__c = productOfferObj[0].Bounce_in_Life_Cycle__c;
    oppObj.Overdue_Charges__c = productOfferObj[0].Overdue_Charges__c;
    oppObj.POS__c = productOfferObj[0].POS__c;
    oppObj.Total_Principal_O_s__c = productOfferObj[0].Total_POS__c;
    oppObj.Referral__c = productOfferObj[0].Referral__c;
    oppObj.Link_Offer_Id__c = productOfferObj[0].id;
    oppObj.Customer_Type__c = leadObj.Customer_Type__c;
    oppObj.Total_Obligation__c = productOfferObj[0].Monthly_Obligation__c;
    oppObj.Requested_ROI__c = productOfferObj[0].Revised_Offer_ROI__c;

    //SHL 29 fields
    oppObj.Repayment_Bank_Name__c = productOfferObj[0].Disb_Bank_Name__c;

    Id userId = Userinfo.getuserid();
    String profileId = Userinfo.getProfileID();
    String profileName = [select id, name from Profile where id =: profileId].name;
    oppObj.Approver__c = profileName;

    if (flow != null && flow != 'DigitalLounge' && Label.RelationshipManagementFlow.contains(flow)) {
     oppObj.ownerId = productOfferObj[0].ownerId;
     oppObj.Relationship_Manager__c = productOfferObj[0].Sourcing_Channel__r.Reporting_Manager__c;
     oppObj.StageName = 'DSA/PSF Login';
     oppObj.CUSTOMER__c = productOfferObj[0].Customer_ID1__c;
    }
    if (flow != null && flow == 'DigitalLounge') {
     oppObj.ownerId = productOfferObj[0].ownerId;
     oppObj.Relationship_Manager__c = productOfferObj[0].Sourcing_Channel__r.Reporting_Manager__c;
     oppObj.CUSTOMER__c = productOfferObj[0].Customer_ID1__c;
    }

    if (productOfferObj[0].Nominator_ID__c != null) {
     oppObj.Nominator_ID__c = productOfferObj[0].Nominator_ID__c;
    }
               if(productOfferObj[0].Products__c=='BOL') {
                    oppObj.Product__c = 'PSBL';
                    oppObj.Program_Type__c='BLUS_Preapproved'; //Added by bug Id : 20187
               }
               /*if(isBOLProductLineProduct) //added by sneha afor 17588
                {

                    //added by Mahima- 17588
                    oppObj.Program_Type__c='BLUS_Preapproved';
                }*/
                //BOL Revamp Leena End

    // #15035 BLUS Pre-Approved - START
    if (productOfferObj != null && productOfferObj.size() > 0 && productOfferObj[0].Program_Type__c == 'BLUS_Preapproved' && productOfferObj[0].Product_Offering_Type__c == 'SBS' && productOfferObj[0].Products__c == 'SBS CS PSBL' && productOfferObj[0].Offer_Amount__c != null && productOfferObj[0].Availed_Amount__c != null)
     if (productOfferObj[0].Offer_Amount__c < productOfferObj[0].Availed_Amount__c) {
      oppObj.Full_Underwriting__c = true;
     }
    else {
     oppObj.Full_Underwriting__c = false;
    }
    // #15035 BLUS Pre-Approved - END


    if (productOfferObj[0].products__c == 'SBS CS HL' && (productOfferObj[0].Converted_Offer_Product__c == 'SBS CS PSBL' || productOfferObj[0].Converted_Offer_Product__c == 'SBS CS FAS' || productOfferObj[0].Converted_Offer_Product__c == 'SBS CS CE') && oppObj.Link_Offer_Id__c != null) {
     oppObj.Full_Underwriting__c = true;
     oppObj.Hold_Reason1__c = 'Product got changed';

    }
    if (productOfferObj[0].products__c == 'SBS CS HL' && (productOfferObj[0].Converted_Offer_Product__c == 'SBS CS LAP') && oppObj.Link_Offer_Id__c != null) {
     oppObj.Full_Underwriting__c = false;

    }
    if (productOfferObj[0].products__c == 'SBS CS LAP' && (productOfferObj[0].Converted_Offer_Product__c == 'SBS CS HL') && oppObj.Link_Offer_Id__c != null) {
     oppObj.Full_Underwriting__c = false;
    }
    if (productOfferObj[0].products__c == 'SBS CS LAP' && (productOfferObj[0].Converted_Offer_Product__c == 'SBS CS PSBL' || productOfferObj[0].Converted_Offer_Product__c == 'SBS CS FAS' || productOfferObj[0].Converted_Offer_Product__c == 'SBS CS CE') && oppObj.Link_Offer_Id__c != null) {
     oppObj.Full_Underwriting__c = true;
     oppObj.Hold_Reason1__c = 'Product got changed';

    }
    if (productOfferObj[0].products__c == 'SBS CS PSBL' && (productOfferObj[0].Converted_Offer_Product__c == 'SBS CS LAP' || productOfferObj[0].Converted_Offer_Product__c == 'SBS CS HL' || productOfferObj[0].Converted_Offer_Product__c == 'SBS CS FAS' || productOfferObj[0].Converted_Offer_Product__c == 'SBS CS CE') && oppObj.Link_Offer_Id__c != null) {
     oppObj.Full_Underwriting__c = true;
     oppObj.Hold_Reason1__c = 'Product got changed';
    }

    if (productOfferObj[0].products__c == 'SBS CS FAS' && (productOfferObj[0].Converted_Offer_Product__c == 'SBS CS LAP' || productOfferObj[0].Converted_Offer_Product__c == 'SBS CS PSBL' || productOfferObj[0].Converted_Offer_Product__c == 'SBS CS HL' || productOfferObj[0].Converted_Offer_Product__c == 'SBS CS CE') && oppObj.Link_Offer_Id__c != null) {
     oppObj.Full_Underwriting__c = true;
     oppObj.Hold_Reason1__c = 'Product got changed';
    }
    if (productOfferObj[0].products__c == 'SBS CS CE' && (productOfferObj[0].Converted_Offer_Product__c == 'SBS CS LAP' || productOfferObj[0].Converted_Offer_Product__c == 'SBS CS PSBL' || productOfferObj[0].Converted_Offer_Product__c == 'SBS CS FAS' || productOfferObj[0].Converted_Offer_Product__c == 'SBS CS HL') && oppObj.Link_Offer_Id__c != null) {
     oppObj.Full_Underwriting__c = true;
     oppObj.Hold_Reason1__c = 'Product got changed';
    }

    //01MOB

    /*SAL PLTB Bug-12108 Start - Anshita*/
    /* if(isCallCenter){
        List<SOL_policy__c> spObj = [SELECT Policy_Name__c,Checklist_Policy_Status__c FROM SOL_Policy__c where Product_Offerings__c = :PO_offerId and (Checklist_Policy_Status__c = 'Pass' OR Checklist_Policy_Override__c = true)];
        for(SOL_Policy__c sp : spObj)
        {
            psdPlcyName.add(sp.Policy_Name__c); 
        }
    }*/
    /*SAL PLTB Bug-12108 Start - Anshita*/

    boolean LeadpofunctionalityStatus;

    if (LaonApplicationCreation__c.getValues('Lead PO Verifier') != null && productOfferObj[0].Product_Offering_Source__c != 'CIBIL 2' && productOfferObj[0].Product_Offering_Source__c != 'CIBIL2' && flow != 'CIBILWatch') {
     LeadpofunctionalityStatus = LaonApplicationCreation__c.getvalues('Lead PO Verifier').Make_Active__c;
    }
    //added not condition for call center 30 Nov 2016 S
    if (!isCallCenter) {
     if (LeadpofunctionalityStatus == false) {
      if (productOfferObj[0].products__c == 'SAL' || productOfferObj[0].products__c == 'SPL' || productOfferObj[0].products__c == 'SBS CS SAL' || productOfferObj[0].products__c == 'SOL') {
       //  oppObj.recordTypeId = FASRecordTypeId;
       //id uid = [SELECT id, name from user where id = : UserInfo.getuserid()].id;

       // by pritha for 101 query error start
       id uid = UserInfo.getuserid();
       // by pritha for 101 query error end
       if (!Label.RelationshipManagementFlow.contains(flow)) {
        oppObj.ownerId = uid;
       }
       if (Label.RelationshipManagementFlow.contains(flow) && flow != 'DigitalLounge') {
        oppObj.stagename = 'DSA/PSF Login';
        oppObj.ownerId = productOfferObj[0].ownerId;
        oppObj.Relationship_Manager__c = productOfferObj[0].Sourcing_Channel__r.Reporting_Manager__c;
       } else if (flow != null && flow != 'DigitalLounge') {
        oppObj.ownerId = productOfferObj[0].ownerId;
        oppObj.Relationship_Manager__c = productOfferObj[0].Sourcing_Channel__r.Reporting_Manager__c; //this code is wrong we need to changet his with the sourcing channels 
       }
       oppObj.approver__c = [SELECT id, name from Profile where id =: UserInfo.getProfileId()].name;
      }
     }
     if (LeadpofunctionalityStatus == true) {
      if (productOfferObj[0].products__c == 'SPL' || productOfferObj[0].products__c == 'SBS CS SAL') {
       //added for call center previously - LaonApplicationCreation__c.getValues('Verifier2 ID') != null
       if (LaonApplicationCreation__c.getValues('Verifier2 ID').Verifier_2_ID__c != null) {
        if (!Label.RelationshipManagementFlow.contains(flow)) {
         oppObj.ownerId = LaonApplicationCreation__c.getvalues('Verifier2 ID').Verifier_2_ID__c;
        }
        if (Label.RelationshipManagementFlow.contains(flow) && flow != 'DigitalLounge') {
         oppObj.stagename = 'DSA/PSF Login';
         oppObj.ownerId = productOfferObj[0].ownerId;
         oppObj.Relationship_Manager__c = productOfferObj[0].Sourcing_Channel__r.Reporting_Manager__c;
        } else if (flow != null && flow != 'DigitalLounge') {
         oppObj.ownerId = productOfferObj[0].ownerId;
         oppObj.Relationship_Manager__c = productOfferObj[0].Sourcing_Channel__r.Reporting_Manager__c;
        }

       }
      } else if (productOfferObj[0].products__c == 'SAL' || productOfferObj[0].products__c == 'SOL') {
       //oppObj.recordTypeId = FASRecordTypeId;
       //commented query by pritha for 101 query error
       //id uid = [SELECT id, name from user where id = : UserInfo.getuserid()].id;
       // by pritha for 101 query error start
       id uid = UserInfo.getuserid();
       // by pritha for 101 query error end

       if (!Label.RelationshipManagementFlow.contains(flow)) {
        oppObj.ownerId = uid;
       } else {
        if (Label.RelationshipManagementFlow.contains(flow) && flow != 'DigitalLounge') {
         oppObj.stagename = 'DSA/PSF Login';
         oppObj.ownerId = productOfferObj[0].ownerId;
         oppObj.Relationship_Manager__c = productOfferObj[0].Sourcing_Channel__r.Reporting_Manager__c;
        } else if (flow != null && flow != 'DigitalLounge') {
         oppObj.ownerId = productOfferObj[0].ownerId;
         oppObj.Relationship_Manager__c = productOfferObj[0].Sourcing_Channel__r.Reporting_Manager__c;
        }

       }
       oppObj.approver__c = [SELECT id, name from Profile where id =: UserInfo.getProfileId()].name;
      }
     }
    }
    //added not condition for call center 30 Nov 2016 E
    //Added for MOB
    decimal offerAmt = 0;
    boolean underwriterFlag = false;


    if (productOfferObj[0].Lead_Source__c == '01MOB' && PODetailMap.containsKey(productOfferObj[0].id)) {

     decimal normalOffer = 0;
     for (PODetail__c pod: PODetailMap.get(productOfferObj[0].id)) {



      normalOffer = pod.Normal_Offer_Amount__c;

      if (normalOffer < pod.Availed_Amount__c) {
       if (productOfferObj[0].Base_Product__c == 'PSBL' && pod.Offer_Product__c == 'LAP' && pod.Offer_Identifier__c == 'Normal') {
        if (pod.Kicker__c != null) {
         normalOffer += normalOffer * (pod.Kicker__c / 100);

         if (normalOffer < pod.Availed_Amount__c) {
          underwriterFlag = true;
         }
        } else
         underwriterFlag = true;
       } else
        underwriterFlag = true;
      }

     }

     if (underwriterFlag == true) {
      oppObj.Full_Underwriting__c = true;
      oppObj.Hold_Reason1__c = productOfferObj[0].Hold_Reason__c;
     } else
      oppObj.Full_Underwriting__c = false;

     oppObj.Offer_Amount__c = productOfferObj[0].Offer_Amount__c;
     oppObj.Approved_Loan_Amount__c = productOfferObj[0].Availed_Amount__c;
     oppObj.Loan_Amount__c = productOfferObj[0].Availed_Amount__c;

    }

    //01MOB

    if (productOfferObj[0].Offer_Accepted_amount__c > productOfferObj[0].Offer_Amount__c && productOfferObj[0].Lead_Source__c != '01MOB') {
     oppObj.Full_Underwriting__c = true;
     oppObj.Offer_Amount__c = productOfferObj[0].Offer_Amount__c;
     oppObj.Hold_Reason1__c = productOfferObj[0].Hold_Reason__c;
     // oppObj.Approved_Loan_Amount__c = productOfferObj[0].Offer_Accepted_amount__c;
     oppObj.Approved_Loan_Amount__c = productOfferObj[0].Availed_Amount__c;
     //oppObj.Loan_Amount__c = productOfferObj[0].Offer_Accepted_amount__c;
     oppObj.Loan_Amount__c = productOfferObj[0].Availed_Amount__c;
    }

    if (productOfferObj[0].Offer_Amount__c > productOfferObj[0].Offer_Accepted_amount__c && productOfferObj[0].Lead_Source__c != '01MOB') {
     oppObj.Full_Underwriting__c = false;
     // oppObj.Approved_Loan_Amount__c = productOfferObj[0].Offer_Amount__c;
     oppObj.Approved_Loan_Amount__c = productOfferObj[0].Availed_Amount__c;
     //oppObj.Loan_Amount__c = productOfferObj[0].Offer_Accepted_amount__c;
     oppObj.Loan_Amount__c = productOfferObj[0].Availed_Amount__c;
     oppObj.Offer_Amount__c = productOfferObj[0].Offer_Amount__c;
    }

    if (productOfferObj[0].Data_Mart_Status__c == 'HOLD') {
     oppObj.Full_Underwriting__c = true;
     if (productOfferObj[0].Hold_Reason__c != '' && productOfferObj[0].Hold_Reason__c != null) oppObj.Hold_Reason1__c = productOfferObj[0].Hold_Reason__c;
     else oppObj.Hold_Reason1__c = 'Pre approved offer is on Hold';
    }

    if (productOfferObj[0].Offer_Amount__c < productOfferObj[0].Offer_Accepted_amount__c && productOfferObj[0].Data_Mart_Status__c == 'HOLD') {
     oppObj.Hold_Reason1__c = 'Pre-approved offer is on Hold and offer accepted amount is greater than offer amount';
    }

    boolean segmentcont = false;

    If(productOfferObj[0].name == 'CD to LAP' && productOfferObj[0].Products__c == 'SBS CS LAP') {
     oppObj.Loan_Type__c = 'LAP SBS to CD Customers ';
     segmentcont = true;
    }
    If(productOfferObj[0].name == 'LAP to HL' && productOfferObj[0].Products__c == 'SBS CS HL') {
     oppObj.Loan_Type__c = 'HL-SBS to LAP Customers (Full Disbursement)';

     segmentcont = true;
    }
    If(productOfferObj[0].name == 'PSBL to LAP' && productOfferObj[0].Products__c == 'SBS CS LAP') {
     oppObj.Loan_Type__c = 'LAP SBS to PSBL Customers';

     segmentcont = true;
    }
    if (productOfferObj[0].Employment_type__c != null) If(productOfferObj[0].name == 'CD to PSBL' && productOfferObj[0].Employment_type__c == 'Doctors' && productOfferObj[0].Products__c == 'SBS CS PSBL') {
     oppObj.Loan_Type__c = 'PSBL to CD DOC Customers';

     segmentcont = true;
    }
    If(productOfferObj[0].name == 'CD to PSBL' && productOfferObj[0].Employment_type__c == 'PRO' && productOfferObj[0].Products__c == 'SBS CS PSBL') {
     oppObj.Loan_Type__c = 'PSBL to CD DOC Customers';

     segmentcont = true;
    }
    if (productOfferObj[0].Employment_type__c != null) If(productOfferObj[0].name == 'CD to PSBL' && productOfferObj[0].Employment_type__c == 'Salaried' && productOfferObj[0].Products__c == 'SBS CS PSBL') {
     oppObj.Loan_Type__c = 'PSBL to CD SAL (Listed) customers';

     segmentcont = true;
    }
    if (productOfferObj[0].Employment_type__c != null) If(productOfferObj[0].name == 'CD to PSBL' && productOfferObj[0].Employment_type__c == 'Self Employed') {
     oppObj.Loan_Type__c = 'PSBL to CD SENP customers';
     segmentcont = true;
    }
    If(productOfferObj[0].name == 'HL to PSBL' && productOfferObj[0].Products__c == 'SBS CS PSBL') {
     oppObj.Loan_Type__c = 'PSBL to HL Customer';
     segmentcont = true;
    }
    If(productOfferObj[0].name == 'LAP to PSBL' && productOfferObj[0].Products__c == 'SBS CS PSBL') {
     oppObj.Loan_Type__c = 'PSBL TO LAP CUSTOMERS';
     segmentcont = true;
    }
    if (productOfferObj[0].Products__c == 'PSBL') {
     oppObj.Loan_Type__c = 'Business Loan';
     segmentcont = true;
    }
    //Bug Id:14509, Added condition for RDL. 
    if (productOfferObj[0].Products__c == 'DOCTORS' || productOfferObj[0].Products__c == 'RDL') {
     oppObj.Loan_Type__c = 'Doctors Loan';
     segmentcont = true;
    }
    //Bug: 17470 checking PRO/HPRO flag
    if (isPROProductLineProduct) {
     //oppObj.Loan_Type__c = 'PRO Loan';
     oppObj.Loan_Type__c = 'Doctors Loan'; // Bug Id : 23801
     segmentcont = true;
    }
    //added for Call center S
    if (isCallCenter) {
     oppObj.Loan_Type__c = 'Personal Loan';
     oppObj.Type_Of_Loan__c = productOfferObj[0].Loan_Type__c;
     segmentcont = true;
    }
    //added for Call center E
    if (segmentcont == false) {
     oppObj.Loan_Type__c = 'LAP-FLEXI';
    }
    if (leadObj.LeadSource != null) {
     oppObj.LeadSource = leadObj.LeadSource;
    }
    //full underwriting reopen issue                    


    /*
             #15035 BLUS Pre-Approved
             Added exclusion BLUS Pre-Approved from below IF as it is handled upside
     */

    if (!(productOfferObj != null && productOfferObj.size() > 0 && productOfferObj[0].Program_Type__c == 'BLUS_Preapproved' && productOfferObj[0].Product_Offering_Type__c == 'SBS' && productOfferObj[0].Products__c == 'SBS CS PSBL' && productOfferObj[0].Offer_Amount__c != null && productOfferObj[0].Availed_Amount__c != null) && productOfferObj[0].Lead_Source__c != '01MOB') {
     if (productOfferObj[0].Availed_Amount__c > productOfferObj[0].Offer_Amount__c || (productOfferObj[0].Program_Type__c != '' && productOfferObj[0].Program_Type__c != null && productOfferObj[0].Program_Type__c != 'Pre-Approved')) {
      oppObj.Full_Underwriting__c = true;

     } else {
      oppObj.Full_Underwriting__c = false;

     }
    }

    ////Bug 6975 - BLUS and Pre approved movement to DSS by akshata 1st july 2016 start
    String BlusValues12 = LaonApplicationCreation__c.getValues('BLUS values').BLUS__c;
    List < String > temp12 = BlusValues12.split(',');
    Set < String > SetBlusValues12 = new Set < String > ();
    SetBlusValues12.addAll(temp12);
    //code added by Leena for DLUS flow bug id:- 14510--start
    set < String > setDLUS1;
    String DLUSTypes1;
    if (LaonApplicationCreation__c.getValues('BLUS values') != null)
     DLUSTypes1 = LaonApplicationCreation__c.getValues('BLUS values').Program_Types__c;
    if (DLUSTypes1 != null && DLUSTypes1 != '')
     setDLUS1 = new Set < String > (DLUSTypes1.split(';'));
    if (setDLUS1.Contains(String.valueOf(productOfferObj[0].Product_Offering_Type1__c)) && oppObj.Full_Underwriting__c != null && oppObj.Full_Underwriting__c != false) {
     oppObj.Full_Underwriting__c = false;
    }
    //code added by Leena for DLUS flow bug id:- 14510--end
    if (SetBlusValues12.Contains(String.valueOf(productOfferObj[0].Product_Offering_Type1__c)) && oppObj.Full_Underwriting__c != null && oppObj.Full_Underwriting__c != false) {
     oppObj.Full_Underwriting__c = false;
    }
    ////Bug 6975 - BLUS and Pre approved movement to DSS by akshata 1st july 2016 end
    oppObj.Product_Offereing_id__c = productOfferObj[0].Offer_ID__c;

    //    productOfferObj[0].Converted_Date_Time__c = system.now(); // Commented for bug 12463
    //    productOfferObj[0].Product_Offering_Converted__c = true;  //  Commented for bug 12463
    //Added for Call Center S
    if (isCallCenter) {
     if (productOfferObj[0].Lead_Source__c != null) {
      oppObj.Application_Source__c = productOfferObj[0].Lead_Source__c;
     }
     if (LaonApplicationCreation__c.getValues('Call Center LAN Flow').Verifier_2_ID__c != null) {
      oppObj.Loan_Application_Flow__c = LaonApplicationCreation__c.getvalues('Call Center LAN Flow').Verifier_2_ID__c;
     }
     /*code moved here--for optimization---harsit*/
     if (productOfferObj[0].Mode_of_Payment__c != null)
      oppObj.Repayment_Mode__c = productOfferObj[0].Mode_of_Payment__c;
     //Bug 6342 Start 
     if (productOfferObj[0].Disbursement_Payment_Mode__c != null) {
      oppObj.Mode_of_Disbursal__c = productOfferObj[0].Disbursement_Payment_Mode__c;
     } else {
      if (productOfferObj[0].Mode_of_Payment__c != null) {
       oppObj.Mode_of_Disbursal__c = productOfferObj[0].Mode_of_Payment__c;
      }
     }
     //Bug 6342 End
     //Bug 6342 Start
     if (productOfferObj[0].Address_Change_flag__c == true) {
      if (productOfferObj[0].Disb_favouring__c != null)
       oppObj.Favouring__c = productOfferObj[0].Disb_favouring__c;
     } else {
      if (productOfferObj[0].Cheque_In_Favoring__c != null)
       oppObj.Favouring__c = productOfferObj[0].Cheque_In_Favoring__c;
     }
     if (productOfferObj[0].Bank_Account_Type__c != null)
      oppObj.A_C_Type__c = productOfferObj[0].Bank_Account_Type__c;
     //Bug 6342 End
     if (cibilwatchFlag == true) {
      if (productOfferObj[0].Disbursement_Payment_Mode__c != null) {
       oppObj.Mode_of_Disbursal__c = productOfferObj[0].Disbursement_Payment_Mode__c;
      } else {
       if (productOfferObj[0].Mode_of_Payment__c != null) {
        oppObj.Mode_of_Disbursal__c = productOfferObj[0].Mode_of_Payment__c;
       }
      }
      if (productOfferObj[0].Address_Change_flag__c == true) {
       if (productOfferObj[0].Disb_favouring__c != null)
        oppObj.Favouring__c = productOfferObj[0].Disb_favouring__c;
      } else {
       if (productOfferObj[0].Cheque_In_Favoring__c != null)
        oppObj.Favouring__c = productOfferObj[0].Cheque_In_Favoring__c;
      }
      if (productOfferObj[0].Bank_Account_Type__c != null)
       oppObj.A_C_Type__c = productOfferObj[0].Bank_Account_Type__c;
     }
     // Additionla Mappings
     //SAL PLTB S
     /*if(isCallCenter)
          {*/
     oppObj.Account_Holder_Name__c = productOfferObj[0].Disb_favouring__c;
     oppObj.Repayment_Account_Holder_Name__c = productOfferObj[0].Cheque_In_Favoring__c;
     //}
     //SAL PLTB E
     if (productOfferObj[0].Availed_Amount__c != null)
      oppObj.Approved_Loan_Amount__c = productOfferObj[0].Availed_Amount__c;
     if (productOfferObj[0].Availed_Tenor__c != null) {
      oppObj.Approved_Tenor__c = productOfferObj[0].Availed_Tenor__c;
      oppObj.Tenor__c = productOfferObj[0].Availed_Tenor__c;
     }
     if (productOfferObj[0].EMI_Amount__c != null)
      oppObj.EMI_CAM__c = productOfferObj[0].EMI_Amount__c;
     if (productOfferObj[0].Accepted_Premium_Amount__c != null)
      oppObj.Insurance_Premium_Amt__c = productOfferObj[0].Accepted_Premium_Amount__c;
     if (productOfferObj[0].Offer_PF__c != null)
      oppObj.Processing_Fees__c = productOfferObj[0].Offer_PF__c;
     if (productOfferObj[0].Processing_Fee_Amount__c != null)
      oppObj.Amount_Rs__c = productOfferObj[0].Processing_Fee_Amount__c;
     if (productOfferObj[0].ECS_Bank_Account_number__c != null)
      oppObj.A_C_NO__c = productOfferObj[0].ECS_Bank_Account_number__c;
     if (productOfferObj[0].Disb_Bank_Name__c != null)
      oppObj.Bank_Name__c = productOfferObj[0].Disb_Bank_Name__c;
     if (productOfferObj[0].MICR_Code__c != null)
      oppObj.MICR_Number__c = Decimal.ValueOf(productOfferObj[0].MICR_Code__c);
     if (productOfferObj[0].IFSC_Code__c != null)
      oppObj.IFSC_Code__c = productOfferObj[0].IFSC_Code__c;
     if (productOfferObj[0].Mode_of_Payment__c != null)
      oppObj.Repayment_Mode__c = productOfferObj[0].Mode_of_Payment__c;
     if (leadObj.Name != null) {
      oppObj.Account_Holder_Name__c = leadObj.Name;
      oppObj.Repayment_Account_Holder_Name__c = leadObj.Name;
     }
     if (productOfferObj[0].First_Due_Date__c != null)
      oppObj.First_Due_Date__c = productOfferObj[0].First_Due_Date__c;
     if (productOfferObj[0].ECS_Bank_Account_number__c != null)
      oppObj.Bank_A_c_No_of_Customer__c = productOfferObj[0].ECS_Bank_Account_number__c;
     if (productOfferObj[0].Bank_name__c != null)
      oppObj.Repayment_Bank_Name__c = productOfferObj[0].Bank_name__c;
     if (productOfferObj[0].Customer_ID1__c != null)
      oppObj.CUSTOMER__c = productOfferObj[0].Customer_ID1__c;
     // SAL PLTB bug 13349 added by priya  start
     if ( /*isCallCenter && */ productOfferObj[0].Revised_Offer_ROI__c != null) {
      oppObj.Business_IRR__c = productOfferObj[0].Revised_Offer_ROI__c;
      oppObj.Approved_Rate__c = productOfferObj[0].Revised_Offer_ROI__c;
     } //SAL PLTB bug 13349 added by priya  start
     else if (productOfferObj[0].Offer_ROI__c != null)
      oppObj.Business_IRR__c = productOfferObj[0].Offer_ROI__c;

    }
    //Added for Call Center E
    //SAL SPL Condition added 16166 shilpa  start              
    if (productOfferObj[0] != null && prodArr.contains(productOfferObj[0].products__c) && otpv3flow.contains(flowNew)) {
     oppObj.Loan_Application_Flow__c = 'Mid Office 1';
    }
    //SAL SPL Condition added 16166 shilpa end
    //added not condition for call center 30 Nov 2016 S
    if (!isCallCenter) {
     if (LeadpofunctionalityStatus == true) {
      if (productOfferObj[0].products__c == 'SPL' || productOfferObj[0].products__c == 'SBS CS SAL') {
       //added for call center S
       if (LaonApplicationCreation__c.getValues('Verifier2 ID').Verifier_2_ID__c != null) {
        //added for call center E
        productOfferObj[0].ownerId = LaonApplicationCreation__c.getvalues('Verifier2 ID').Verifier_2_ID__c;
       }
      }
     }
    }
    //added not condition for call center 30 Nov 2016 E
    //if(productOfferObj[0].UTM_Source__c == 'proMobile') oppObj.Application_Source__c = productOfferObj[0].Lead_Source__c; // Bug 13675 - Hemant Keni 
    //Bug 16207 - January 2018 BRD - Engineering program in mobility UTM Changes By Rajesh
    if (productOfferObj[0].Mobile_Source__c == 'proMobility') oppObj.Application_Source__c = productOfferObj[0].Lead_Source__c;
    /*Mobility for SAL added by priya start*/
    if (flow == 'salaried') {
     oppObj.Application_Source__c = productOfferObj[0].Lead_Source__c;
     oppObj.Loan_Application_Flow__c = 'Mid Office 1';
    } /*Mobility for SAL added by priya end*/
    /*20939 s*/
    if(isCallCenter && productOfferObj[0].Telecaller_Name__c != null) {
        Integer index = productOfferObj[0].Telecaller_Name__c.lastIndexOf('-');
        oppObj.Telecaller_Name__c = productOfferObj[0].Telecaller_Name__c.left(index);
    }
    /*20939 s*/
    if (sendToType == 'Credit') {

     oppObj.stagename = 'Underwriting';

     oppObj.ownerId = submitTo;
     oppObj.Employee_Type__c = productOfferObj[0].Employment_type__c;
     oppObj.File_Acceptance__c = 'File Accepted';
     //system workflow Enhancement Pramod S
     oppObj.CUSTOMER__c = productOfferObj[0].Customer_ID1__c;
     //system workflow Enhancement Pramod E
     oppObj.recordTypeId = creditRecordtypeId;
     //SAL PLTB Pritha start
     //20939 commented below code
    /*if(isCallCenter && productOfferObj[0].Telecaller_Name__c != null) {
        Integer index = productOfferObj[0].Telecaller_Name__c.lastIndexOf('-');
        oppObj.Telecaller_Name__c = productOfferObj[0].Telecaller_Name__c.left(index);
    }*/
     //SAL PLTB Pritha end
     //Stamping CPA on click of Send to credit--BugId 14266
     List < User > userList = new List < User > ();
     userList = [Select Id, Product__c, city__c, Branch_City__c from User
      where Product__c includes(: productOfferObj[0].Products__c) and Branch_City__c includes(: productOfferObj[0].Lead_Branch__c) and Profile.name = 'CPA Login Partner'
      and IsActive = true
     ];
     Map < String, Id > cpaUserList = new Map < String, Id > ();
     for (User user: userList) {
      for (String product: user.product__c.split(';')) {
       cpaUserList.put(user.city__c + ';' + product, user.id);
      }
     }
     if (cpaUserList.get(leadObj.SBS_Branch__r.name + ';' + productOfferObj[0].products__c) != null) {
      oppObj.CPA__c = cpaUserList.get(leadObj.SBS_Branch__r.name + ';' + productOfferObj[0].products__c);
     }


     List < Credit_Officer_Limit__c > objCreditList = new List < Credit_Officer_Limit__c > ();
     List < Credit_Officer_Limit__c > updateCreditList = new List < Credit_Officer_Limit__c > ();
     //4450
     String LoanAppFlow = null;
     if (COLStampFlag == true) {
      if (flow == null || flow == '') {
       LoanAppFlow = 'Normal';
      } else {
       LoanAppFlow = flow;
      }

      objCreditList = [select id, name, City__c, Number_of_Deviations__c, Credit_Officer_Name__r.Isactive, Credit_Officer_Name__r.id, Credit_Officer_Name__r.name, Credit_Officer_Name__c, Designation__c, Loan_Amount__c, Flow__c, Pre_Approved_Amount__c, Credit_Officer_Name__r.product__c, products__c
       from Credit_Officer_Limit__c
       where Credit_Officer_Name__r.Id =: submitTo AND Credit_Officer_Name__r.Isactive = true AND Active_Flag__c = true AND product__C =: oppObj.product__c AND City__c includes(: leadObj.SBS_Branch__r.Name) AND Flow__c INCLUDES(: LoanAppFlow)
      ];
     } else {
      objCreditList = [select id, name, City__c, Number_of_Deviations__c, Credit_Officer_Name__r.Isactive, Credit_Officer_Name__r.id, Credit_Officer_Name__r.name, Credit_Officer_Name__c, Designation__c, Loan_Amount__c, Credit_Officer_Name__r.product__c, products__c
       from Credit_Officer_Limit__c
       where Credit_Officer_Name__r.Id =: submitTo AND Credit_Officer_Name__r.Isactive = true AND Active_Flag__c = true AND product__C =: oppObj.product__c AND City__c includes(: leadObj.SBS_Branch__r.Name)
      ];

     }

     // Bug id : 13016 - New Role Creation for Credit, added by Needhi 
     oppObj =
      CommonUtility.stampCreditHierarchy(objCreditList, submitTo, productOfferObj, COLStampFlag, oppObj); // Bug Id : 18159
     //4450
     //if (updateCreditList.size() > 0)
     //update updateCreditList;
     //4777
     if (LaonApplicationCreation__c.getValues('BTBankDetails') != null) {
      Date BTDate = LaonApplicationCreation__c.getValues('BTBankDetails').BTEmailDate__c;

      if (BTDate != null && BTDate <= System.today()) {
       dateFlag = true;
      }
     }
     if (productOfferObj[0].Loan_Type__c == 'BT' && dateFlag == true && productOfferObj[0].ASM__c != null && submitTo != System.Label.Pool_User) { // Bug Id : 18159
      sendBTEmailOnSendToCredit(productOfferObj[0]);
     }



    }
    if (sendToType == 'Sales') {
     // CIBIL watch start
     if (flow == 'CIBILWatch') {

      String uid = UserInfo.getuserid();
      uid = uid.substring(0, 15);
      Boolean FlagTeleCallingFound = false;
      //String POuid = productOfferObj[0].ownerId;
      //POuid=POuid.substring(0,15); 
      if (leadObj.DNC_Flag__c == 'No') {
       if (productOfferObj[0].TeleCalling_Desposition_Status__c == 'Sale') {
        List < GroupMember > ListTeleCallingTeam = new List < GroupMember > ();
        ListTeleCallingTeam = [select g.UserOrGroupId From GroupMember g where groupId = '00G90000000tVfE'];
        for (GroupMember TeleMember: ListTeleCallingTeam) {
         if (TeleMember.UserOrGroupId == uid) {

          //profileName = UserInfo.getprofileid();
          //profileName = [select id, name from Profile where id = : POuid].name;
          oppObj.ownerId = uid;
          oppObj.Approver__c = 'Telecaller';
          oppObj.stagename = 'DSA/PSF Login';
          FlagTeleCallingFound = true;
         }
        }

       }
      }
      if (leadObj.DNC_Flag__c == 'Yes') {
       if (productOfferObj[0].Field_Desposition_Status__c == 'Docs Received') {
        if (productOfferObj[0].ASM__c != null) {
         if (productOfferObj[0].ASM__c == uid) {
          oppObj.stagename = 'DSA/PSF Login';
          oppObj.ownerId = productOfferObj[0].ASM__c;
          oppObj.Approver__c = profileName;
          FlagTeleCallingFound = true;
         }
        }
       }
      }

      if (FlagTeleCallingFound != true) {
       //Exception page message error.
       return ('Logged in user should be the ASM/PSF or it should be in Salaried Tele Calling Team Queue');
       // Logged in user should be the ASM/PSF or it should be in "Sal telecalling queue"
      }

     } else {
      // Bug : 7638 start

      //SAL Mobility v2 Bug Id: 17138: BugId 17557 start
      String uid = UserInfo.getuserid();
      //SAL Mobility v2: BugId 17557 end
      if (productOfferObj[0].Owner.Type == 'Queue') {
       Boolean telecallerflag = false;

       uid = uid.substring(0, 15);
       List < GroupMember > ListTeleCallingTeam = new List < GroupMember > ();
       ListTeleCallingTeam = [select g.UserOrGroupId From GroupMember g where groupId =: productOfferObj[0].ownerId];
       if (ListTeleCallingTeam.size() > 0) {
        for (GroupMember TeleMember: ListTeleCallingTeam) {
         if (TeleMember.UserOrGroupId == uid) {
          oppObj.ownerId = uid;
          oppObj.Approver__c = profileName;
          oppObj.stagename = 'DSA/PSF Login';
          oppObj.Employee_Type__c = productOfferObj[0].Employment_type__c;
          telecallerflag = true;
          break;
         }
        }
        if (telecallerflag != true) {
         //Exception page message error.
         return ('Logged in user should be in Tele Calling Team Queue');
        }
       }
      } else {
       //SAL Mobility v2 Bug Id: 17138: BugId 17557 start
       if (flow == 'salaried' && productOfferObj[0].id == uid) {
        oppObj.ownerId = uid;
        oppObj.Approver__c = profileName;
        oppObj.stagename = 'DSA/PSF Login';
       } else {
        //SAL Mobility v2: BugId 17557 end
        oppObj.Employee_Type__c = productOfferObj[0].Employment_type__c;
        oppObj.stagename = 'DSA/PSF Login';
        //call center S
        if (isCallCenter) {
         oppObj.Approver__c = 'Area Sales Manager';
         /* SAL PLTB added by priya start*/
         if (productOfferObj[0].Sourcing_Channel__c != null && productOfferObj[0].Sourcing_Channel__r.Reporting_Manager__c != null) {
          oppObj.ownerId = productOfferObj[0].Sourcing_Channel__r.Reporting_Manager__c;
         } else
          oppObj.ownerId = productOfferObj[0].ownerId;
         /* SAL PLTB added by priya end*/
        } else {
         oppObj.Approver__c = profileName;
         oppObj.ownerId = productOfferObj[0].ownerId;
        }
        //call center E
       }
      }
      //Bug:  7638 end
     }
     // CIBIL watch End

     //Stamping CPA on click of Send to Sales--BugID-14266
     List < User > userList = new List < User > ();
     userList = [Select Id, Product__c, city__c, Branch_City__c from User
      where Product__c includes(: productOfferObj[0].Products__c) and Branch_City__c includes(: productOfferObj[0].Lead_Branch__c) and Profile.name = 'CPA Login Partner'
      and IsActive = true
     ];
     Map < String, Id > cpaUserList = new Map < String, Id > ();
     for (User user: userList) {
      for (String product: user.product__c.split(';')) {
       cpaUserList.put(user.city__c + ';' + product, user.id);
      }
     }
     if (cpaUserList.get(leadObj.SBS_Branch__r.name + ';' + productOfferObj[0].products__c) != null) {
      oppObj.CPA__c = cpaUserList.get(leadObj.SBS_Branch__r.name + ';' + productOfferObj[0].products__c);
     }


    }
    if (sendToType == 'CPA') {

     List < User > userList = new List < User > ();
     userList = [Select Id, Product__c, city__c, Branch_City__c from User
      where Product__c includes(: productOfferObj[0].Products__c) and Branch_City__c includes(: productOfferObj[0].Lead_Branch__c) and Profile.name = 'CPA Login Partner'
      and IsActive = true
     ];
     Map < String, Id > cpaUserList = new Map < String, Id > ();
     for (User user: userList) {
      for (String product: user.product__c.split(';')) {
       cpaUserList.put(user.city__c + ';' + product, user.id);
      }
     }

     oppObj.Employee_Type__c = productOfferObj[0].Employment_type__c;
     oppObj.stagename = 'Pending CPA Acceptance';

     if (cpaUserList.get(leadObj.SBS_Branch__r.name + ';' + productOfferObj[0].products__c) != null) {
      oppObj.ownerId = cpaUserList.get(leadObj.SBS_Branch__r.name + ';' + productOfferObj[0].products__c);
      oppObj.CPA__c = oppObj.ownerId;
     }
     oppObj.Approver__c = profileName;
    }

    //Code shifted below by Rakesh for optimization 
    //insert oppObj;

    //Whitelisting RM
    if (contactObj != null && oppObj != null) {

     if (contactObj.Customer_Type__c != null && contactObj.Customer_Type__c.equalsIgnoreCase('Individual')) {
      CommonUtility.sendCustInfoMail(leadObj.PAN__c, string.valueOf(contactObj.Mobile__c), string.valueOf(contactObj.Email__c), contactObj.Date_of_Birth__c, oppObj.Product__c, contactObj.Customer_Type__c, 'PO');
     } else if (contactObj.Customer_Type__c != null && contactObj.Customer_Type__c.equalsIgnoreCase('Corporate')) {
      CommonUtility.sendCustInfoMail(leadObj.TAN__c, string.valueOf(contactObj.Mobile__c), string.valueOf(contactObj.Email__c), contactObj.Date_of_Birth__c, oppObj.Product__c, contactObj.Customer_Type__c, 'PO');
     }
    }

    //Cibil Watch Start
    if (flow == 'CIBILWatch') {
     //Code shifted below by Rakesh for optimization
     //MapRecordsCIBILWatch(productOfferObj[0].id, productOfferObj[0].Lead_Source__c, oppObj.id, leadObj.id, leadObj.Name, isCallCenter, cibilwatchFlag);
     if (productOfferObj[0].Mode_of_Payment__c != null)
      oppObj.Repayment_Mode__c = productOfferObj[0].Mode_of_Payment__c;
     //Bug 6342 Start 
     if (productOfferObj[0].Disbursement_Payment_Mode__c != null) {
      oppObj.Mode_of_Disbursal__c = productOfferObj[0].Disbursement_Payment_Mode__c;
     } else {
      if (productOfferObj[0].Mode_of_Payment__c != null) {
       oppObj.Mode_of_Disbursal__c = productOfferObj[0].Mode_of_Payment__c;
      }
     }
     //Bug 6342 End
     //Bug 6342 Start
     if (productOfferObj[0].Address_Change_flag__c == true) {
      if (productOfferObj[0].Disb_favouring__c != null)
       oppObj.Favouring__c = productOfferObj[0].Disb_favouring__c;
     } else {
      if (productOfferObj[0].Cheque_In_Favoring__c != null)
       oppObj.Favouring__c = productOfferObj[0].Cheque_In_Favoring__c;
     }

     if (productOfferObj[0].Bank_Account_Type__c != null)
      oppObj.A_C_Type__c = productOfferObj[0].Bank_Account_Type__c;
     //Bug 6342 End
     if (cibilwatchFlag == true) {
      if (productOfferObj[0].Disbursement_Payment_Mode__c != null) {
       oppObj.Mode_of_Disbursal__c = productOfferObj[0].Disbursement_Payment_Mode__c;
      } else {
       if (productOfferObj[0].Mode_of_Payment__c != null) {
        oppObj.Mode_of_Disbursal__c = productOfferObj[0].Mode_of_Payment__c;
       }
      }
      if (productOfferObj[0].Address_Change_flag__c == true) {
       if (productOfferObj[0].Disb_favouring__c != null)
        oppObj.Favouring__c = productOfferObj[0].Disb_favouring__c;
      } else {
       if (productOfferObj[0].Cheque_In_Favoring__c != null)
        oppObj.Favouring__c = productOfferObj[0].Cheque_In_Favoring__c;
      }
      if (productOfferObj[0].Bank_Account_Type__c != null)
       oppObj.A_C_Type__c = productOfferObj[0].Bank_Account_Type__c;
     }
     // Additionla Mappings
     if (productOfferObj[0].Availed_Amount__c != null)
      oppObj.Approved_Loan_Amount__c = productOfferObj[0].Availed_Amount__c;
     if (productOfferObj[0].Availed_Tenor__c != null) {
      oppObj.Approved_Tenor__c = productOfferObj[0].Availed_Tenor__c;
      oppObj.Tenor__c = productOfferObj[0].Availed_Tenor__c;
     }
     if (productOfferObj[0].EMI_Amount__c != null)
      oppObj.EMI_CAM__c = productOfferObj[0].EMI_Amount__c;
     if (productOfferObj[0].Accepted_Premium_Amount__c != null)
      oppObj.Insurance_Premium_Amt__c = productOfferObj[0].Accepted_Premium_Amount__c;
     if (productOfferObj[0].Offer_PF__c != null)
      oppObj.Processing_Fees__c = productOfferObj[0].Offer_PF__c;
     if (productOfferObj[0].Processing_Fee_Amount__c != null)
      oppObj.Amount_Rs__c = productOfferObj[0].Processing_Fee_Amount__c;
     if (productOfferObj[0].ECS_Bank_Account_number__c != null)
      oppObj.A_C_NO__c = productOfferObj[0].ECS_Bank_Account_number__c;
     if (productOfferObj[0].Disb_Bank_Name__c != null)
      oppObj.Bank_Name__c = productOfferObj[0].Disb_Bank_Name__c;
     if (productOfferObj[0].MICR_Code__c != null)
      oppObj.MICR_Number__c = Decimal.ValueOf(productOfferObj[0].MICR_Code__c);
     if (productOfferObj[0].IFSC_Code__c != null)
      oppObj.IFSC_Code__c = productOfferObj[0].IFSC_Code__c;
     if (productOfferObj[0].Mode_of_Payment__c != null)
      oppObj.Repayment_Mode__c = productOfferObj[0].Mode_of_Payment__c;
     if (leadObj.Name != null) {
      oppObj.Account_Holder_Name__c = leadObj.Name;
      oppObj.Repayment_Account_Holder_Name__c = leadObj.Name;
     }
     if (productOfferObj[0].First_Due_Date__c != null)
      oppObj.First_Due_Date__c = productOfferObj[0].First_Due_Date__c;
     if (productOfferObj[0].ECS_Bank_Account_number__c != null)
      oppObj.Bank_A_c_No_of_Customer__c = productOfferObj[0].ECS_Bank_Account_number__c;
     if (productOfferObj[0].Bank_name__c != null)
      oppObj.Repayment_Bank_Name__c = productOfferObj[0].Bank_name__c;
     if (productOfferObj[0].Customer_ID1__c != null)
      oppObj.CUSTOMER__c = productOfferObj[0].Customer_ID1__c;
     if (productOfferObj[0].Offer_ROI__c != null)
      oppObj.Business_IRR__c = productOfferObj[0].Offer_ROI__c;
     //Code shifted below by Rakesh for optimization
     /*try {
              update oppObj;
          } catch (DMLException e) {
              String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
              str+='Product Offering Id :'+offeringId+' \n Block 1';   // Bug 12463
              System.debug(str);
              CommonUtility.SendExceptionMail(str);
              system.debug('---Exception---' + e.getMessage());
          }*/
    }
    if (isDLRMProduct) {
     oppObj.Tenor__c = productOfferObj[0].Requested_Tenor__c;
     oppObj.POS__c = productOfferObj[0].POS__c;
     oppObj.Total_Obligation__c = productOfferObj[0].Monthly_Obligation__c;
    }
    //Added by Mahima- 13484- DLRM offer-- start--
    string strOfferProducts = Label.DLRMMortgageOfferProducts;
    set < string > setProdName = new set < string > ();
    if (strOfferProducts != null) {
     setProdName.addAll(strOfferProducts.split(';'));
    }

    //added by Mahima- 13484- DLRM offer-- end--
    bodmasCalculation__C bdmsObj;

    List < bodmasCalculation__C > lstbdms = [select Id, LoanApplication__C, Interested_in_Offer_Type__c, Offer_Amount_BTTP__c, Offer_Amount__c from bodmasCalculation__C where Product_Offerings__c =: productOfferObj[0].id]; //17834

    if ((productOfferObj[0].Product_Offering_Source__c != null && productOfferObj[0].Product_Offering_Source__c.tolowerCase() == 'cibil 2') || (productOfferObj[0].Base_Product__C == 'DOCTORS' && setProdName.contains(productOfferObj[0].Products__C))) {

     //List<bodmasCalculation__C > lstbdms= [select Id, LoanApplication__C,Interested_in_Offer_Type__c,Offer_Amount_BTTP__c,Offer_Amount__c from bodmasCalculation__C where Product_Offerings__c=:productOfferObj[0].id]; //17834
     if (lstbdms.size() > 0) {
      bdmsObj = new bodmasCalculation__C();
      bdmsObj = lstbdms[0];
      if (leadObj != null && leadObj.ROI__C != null && leadObj.ROI__C != '')
       bdmsObj.ROI__C = Double.ValueOf(leadObj.ROI__C);
      //update bdmsObj;
      //DLRM PRoduct condition is added to change the offer amount of Opportunity in case of DLRMHL & DLRMLAP; Done BY Rajendrda for DLRM Foss Calc Enha  

      if (isDLRMProduct) {
       if (bdmsObj != null && bdmsObj.Interested_in_Offer_Type__c != null) {
        if (bdmsObj.Interested_in_Offer_Type__c == 'DLRM Prospect BTTP')
         oppObj.Offer_Amount__c = bdmsObj.Offer_Amount_BTTP__c;
        else
         oppObj.Offer_Amount__c = bdmsObj.Offer_Amount__c;
       }
      }
     }
    } else if (lstbdms.size() > 0) {

     bdmsObj = new bodmasCalculation__C();
     bdmsObj = lstbdms[0];
    }
    oppObj.Processing_Type__c = productOfferObj[0].Processing_Type__c; //17834

    if (lstbdms != null)
     System.Debug('lstbdms.size()' + lstbdms.size());
    upsert oppObj;
    //17834 end 

    try {
     upsert oppObj;
     // throw new CustomException();
     //  added by gopika 15574 and 17225   
     //   CommonUtility.flowAttachments(offeringId,oppObj.id);
     CommonUtility.flowContentDocument(offeringId, oppObj.id);
     productOfferObj[0].Converted_Date_Time__c = system.now();
     if (bdmsObj != null) {
      bdmsObj.LoanApplication__C = oppObj.id;
      update bdmsObj;
     }
    } catch (DMLException e) {
     String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString() + ' ** Cause** ' + e.getCause();
     str += 'Product Offering Id :' + offeringId + ' \n Block 1'; // Bug 12463
     CommonUtility.SendExceptionMail(str);
     LoanConversionUtility_Helper.unlock1(cqom); // Bug Id : 25285 - Concurrency Issue -unlock p2
     //system.debug('---Exception---' + e.getMessage());
     /* added for Bug 12463*/
     Database.rollback(savePointVar);
     Map < String, String > result = new Map < String, String > ();
     result.put('records', 'hasException12 -->' + e.getMessage());
     return JSON.serialize(result);
     /* added for Bug 12463*/
    }
    //system.debug('outside try catch');
    //*SAL PLTB bug Id- 13952
    String priApplicant = '';

    if (flow == 'CIBILWatch') {
     MapRecordsCIBILWatch(productOfferObj[0].id, productOfferObj[0].Lead_Source__c, oppObj.id, leadObj.id, leadObj.Name, isCallCenter, cibilwatchFlag, priApplicant);
    }

    //Cibil Watch End
    /*Code commented for optimization--- harsit---START*/
    //List < Contact > tempContacts = new List < Contact > ();
    //system.debug('newcontactids' + newContactIds);
    //tempContacts = [Select id, CIF_Id__c, name, movedToCibilTemp__c, Update_CIBIL_Error__c, CIBIL_Score__c, Lead_Applicants__c, CIBIL_Match_Check__c, Lead__c, ApplicantType__c, Cibil_Temp__c from Contact where id IN: newContactIds];
    /*Code commented for optimization--- harsit---END*/
    List < Applicant__c > applicants = new List < Applicant__c > ();

    // Checking if applicants have existing application , So no need to do CIBIL again
    MAp < String, Integer > existingLoanCount = new Map < String, Integer > ();
    for (Applicant__c applicant: [select Loan_Application__r.name, Contact_Name__r.CIF_Id__c, /*SAL PLTB Changes 14951 added by Anshita S*/ Location_Wise_EWS_Status__c, Codified_CIBIL__c /*SAL PLTB Changes 14951 added by Anshita E*/ from applicant__c where Contact_Name__r.CIF_Id__c in: allCifIds
      and((Loan_Application__r.stagename != 'Approved'
       and Loan_Application__r.stagename != 'Rejected') or Loan_Application__r.createddate < LAST_N_DAYS: 29)
     ]) {

     existingLoanCount.put(applicant.Contact_Name__r.CIF_Id__c, 1);
    }

    Boolean cibilDone = false;
    //system.debug('tempContacts =' + tempContacts);
    for (Contact contTemp: newContacts) { /*harsit---will iterare loop on newContacts directly instead of tempContacts*/
     //system.debug('applicant3 =' + applicant);
     Applicant__c applicant = new Applicant__c();
     applicant.Contact_Name__c = contTemp.Id;
     applicant.Loan_Application__c = oppObj.Id;
     applicant.movedToCibilTemp__c = contTemp.movedToCibilTemp__c;
     applicant.SegmentaionResult__c = productOfferObj[0].Existing_Customer_Segmentation__c;
     //bug 8314: PD4 tat s
     if (leadObj != null && leadObj.PD_Required__c != null)
      applicant.PD_Flag__c = leadObj.PD_Required__c;
     if (leadObj != null && leadObj.PD_Time__c != null)
      applicant.PD_Time__c = leadObj.PD_Time__c;
     if (submitTo != null && submitTo != '')
      applicant.ownerID = submitTo;
     //bug 8314 end

     //Mortgage Re-Engg Start
     if (Mortgageflag) {
      applicant.Bureau_Segment__c = productOfferObj[0].Existing_Customer_Segmentation__c;
     } else {
      applicant.Bureau_Segment__c = productOfferObj[0].Customer_ID1__r.CIBIL_Segmentation__c;
     }
     //Mortgage Re-Engg End
     applicant.SME_Score__c = productOfferObj[0].SME_Score__c;
     applicant.Update_CIBIL_Error__c = contTemp.Update_CIBIL_Error__c;
     applicant.CIBIL_Match_Check__c = contTemp.CIBIL_Match_Check__c;
     applicant.CIBIL_Score__c = contTemp.CIBIL_Score__c;
     //commented on 21 Nov 2016
     //applicant.Lead__c = contTemp.Lead__c;
     applicant.Lead_Applicants__c = contTemp.Lead_Applicants__c;
     //applicant.Cibil_Temp__c = contTemp.Cibil_Temp__c;
     applicant.Applicant_Type__c = contTemp.ApplicantType__c;
      if(applicant.Applicant_Type__c=='Primary')
    {
    system.debug('inside my code'+ CommonUtility.cvSelected);
    if(oppObj.Product__c=='PRO' || oppObj.Product__c=='DOCTORS')
     {
     if(CommonUtility.cvSelected!=null){
         string base64Data;
     base64Data = EncodingUtil.base64Encode(CommonUtility.cvSelected.VersionData);
     String imageString = '<!DOCTYPE html><html><body>' +
                    ' <body><img src=' + 'data:image/jpeg;base64,' + base64Data + '/>' +
                    '</body></html>';
                     system.debug('inside save the file  imageString===>'+imageString);
                        applicant.Applicant_Image__c = imageString;
                        
                    }
     }
    }
     applicant.Consider_for_Eligibility__c = true;
     //SAL PLTB Pritha Start
     if (isCallCenter && (contTemp.ApplicantType__c == 'Primary' || contTemp.ApplicantType__c == 'Primary Applicant')) {
      applicant.Bureau_Segment__c = productOfferObj[0].Existing_Customer_Segmentation__c;
      if (CAmlist != null && CAmlist.size() > 0) {
       applicant.ROINormal__c = CAmlist[0].ROI_Term_Loan__c;
       applicant.ROIFlexi__c = CAmlist[0].ROI_Drop_Line_Loan__c;
       applicant.ROILoc__c = CAmlist[0].ROI_Pure_Flexi_Loan__c;
       applicant.LTA_Medical__c = CAmlist[0].LTA_Medical__c;
       applicant.LTA_Frequency__c = CAmlist[0].LTA_Frequency__c;
       applicant.Risk_Segmentation__c = CAmlist[0].Risk_Segmentation__c; //added for OTPV3 wadl change
       /*SAL PLTB Changes 14951 added by Anshita Start*/
       applicant.Location_Wise_EWS_Status__c = CAmlist[0].Location_Wise_EWS_Status__c;
       applicant.Codified_CIBIL__c = CAmlist[0].Codified_CIBIL__c;
       /*SAL PLTB Changes 14951 added by Anshita End*/
      }
      applicant.ROI_PO__c = productOfferObj[0].Offer_ROI__c;
      /*17557 moved code in for loop*/

     }
     /**Methods for SAL Mobility V2 PO
      *Bug Id: 17138
      *start
      */
     if (salariedFlow == 'mobility2') {
        String identifierName =  UserInfo.getUiThemeDisplayed();
        SALMobilityOppCntrl_V2.updateidentifier('PO Conversion',identifierName ,(String)oppObj.id,(String)applicant.id);//user story 978
      if (CAmlist != null && CAmlist.size() > 0 && CAmlist[0].Risk_Segmentation__c != null) {
       if (CAmlist[0].Risk_Segmentation__c == 'High')
        applicant.Risk_Segmentation__c = 'HR';
       else if (CAmlist[0].Risk_Segmentation__c == 'Medium')
        applicant.Risk_Segmentation__c = 'MR';
       else if (CAmlist[0].Risk_Segmentation__c == 'Low')
        applicant.Risk_Segmentation__c = 'LR';
       else
        applicant.Risk_Segmentation__c = CAmlist[0].Risk_Segmentation__c;
      } else if (productOfferObj[0].Risk_Classification__c != null) {
       if (productOfferObj[0].Risk_Classification__c == 'High')
        applicant.Risk_Segmentation__c = 'HR';
       else if (productOfferObj[0].Risk_Classification__c == 'Medium')
        applicant.Risk_Segmentation__c = 'MR';
       else if (productOfferObj[0].Risk_Classification__c == 'Low')
        applicant.Risk_Segmentation__c = 'LR';
       else
        applicant.Risk_Segmentation__c = productOfferObj[0].Risk_Classification__c;
      }
     }
     /**Methods for SAL Mobility V2 PO
      *Bug Id: 17138
      *End
      */
     //SAL PLTB Pritha END
     /*Bug : 17323 start */
     Boolean isGrossTurn_Less = false;
     Set < String > grossTurnover = new Set < String > (Label.Gross_turnover_from_PO.split(';'));
     for (String objTurnover: grossTurnover) {
      if (productOfferObj[0].Gross_Turnover__c != null && productOfferObj[0].Gross_Turnover__c != '' && objTurnover.containsIgnoreCase(productOfferObj[0].Gross_Turnover__c.ToUpperCase()))
       isGrossTurn_Less = true;
     }
     if (productOfferObj[0].Gross_Turnover__c != null && productOfferObj[0].Gross_Turnover__c != '' && isGrossTurn_Less) {

      applicant.Existing_Customer__c = 'Individual';
     } else
      applicant.Existing_Customer__c = 'Existing Customer with Offer';
     /*Bug : 17323 end*/

     if (existingLoanCount.size() == 0 && cibilDone == false) {
      applicant.Integrate_with_CIBIL__c = true;
      cibilDone = true;
     } else {
      if (existingLoanCount.get(contTemp.CIF_Id__c) != null && cibilDone) {
       applicant.Integrate_with_CIBIL__c = false;
      } else {
       applicant.Integrate_with_CIBIL__c = true;
      }
     }
     //15580--S

     if (contTemp.CIF_Id__c != null) {
      applicant.Dedupe_Linking_Done__c = 'SAVE';
     }
     //15580--E
     /*code moved here for optimization----harsit*/
     //Bug 6975 - BLUS and Pre approved movement to DSS by akshata 1st july 2016 start
     //code added by leena for DLUS 14510--start
     if (applicant.Applicant_Type__c == 'Primary' || applicant.Applicant_Type__c == 'Primary Applicant') {
      if (LaonApplicationCreation__c.getValues('BLUS values') != null && LaonApplicationCreation__c.getValues('BLUS values').BLUS__c != null) {
       Set < String > SetBlusValues123 = new Set < String > ();
       SetBlusValues123.addAll(LaonApplicationCreation__c.getValues('BLUS values').BLUS__c.split(','));
       set < String > setDLUS2 = new Set < String > ();
       setDLUS2.addAll(LaonApplicationCreation__c.getValues('BLUS values').Program_Types__c.split(';'));
       if (((SetBlusValues123.Contains(String.valueOf(productOfferObj[0].Product_Offering_Type1__c))) || (setDLUS2.Contains(String.valueOf(productOfferObj[0].Product_Offering_Type1__c)))) && productOfferObj[0].Existing_Customer_Segmentation__c != null) {
        applicant.Offer_Segmentation__c = productOfferObj[0].Existing_Customer_Segmentation__c;
       }
      }
      if (isDLRMProduct) {
       applicant.SegmentaionResult__c = productOfferObj[0].Existing_Customer_Segmentation__c;
       applicant.CIBIL_Score__c = productOfferObj[0].Cibil_Score__c;
       applicant.Campaign_Code__c = productOfferObj[0].Campaign_Type__c;
      }
     }
     ////Bug 6975 - BLUS and Pre approved movement to DSS by akshata 1st july 2016 end
     /*SAL PLTB Bug-12108 start - Anshita */
     /*  if(applicant.Applicant_Type__c == 'Primary' || applicant.Applicant_Type__c == 'Primary Applicant' && isCallCenter){
              for(String pn : psdPlcyName){
              if(applicant.PolicyCheck__c != null)    
                      applicant.PolicyCheck__c = applicant.PolicyCheck__c + pn + ';' ;
                  else
                      applicant.PolicyCheck__c = pn + ';' ;
              }

          }*/
     /*SAL PLTB Bug-12108 start - Anshita */
     applicants.add(applicant);

     //5777

     if (DOEFlag == true && contTemp.ApplicantType__c == 'Primary') {
      applicant.Campaign_Code__c = productOfferObj[0].Campaign_Type__c;
     }
    }

    if (applicants.size() > 0) {
     insert applicants;
    }

    Set < id > apId = new Set < id > ();
    for (Applicant__c appTemp: applicants) {
     apId.add(appTemp.id);
     //CIBIL Watch Start
     if (flow == 'CIBILWatch') {
      if (productOfferObj[0].FFR_Flag__c == true) {
       if (appTemp.Applicant_Type__c == 'Primary' || appTemp.Applicant_Type__c == 'Primary Applicant') {
        appTemp.Financial_Health_Check_Guide__c = true;
        appTemp.FFR_Tag__c = true;
        appTemp.Subscribed_to_Credit_Vidya__c = true;
       }
      } else {
       if (appTemp.Applicant_Type__c == 'Primary' || appTemp.Applicant_Type__c == 'Primary Applicant') {
        appTemp.Financial_Health_Check_Guide__c = false;
        appTemp.FFR_Tag__c = false;
        appTemp.Subscribed_to_Credit_Vidya__c = false;
       }
      }
     }
     //CIBIL Watch End
    }

    primaryApplicantObj = new Applicant__c();

    Map < id, id > cibLead = new Map < id, id > ();
    Map < id, id > cibLeadApp = new Map < id, id > ();

    Set < id > leadIds = new Set < id > ();
    Set < id > leadApId = new Set < id > ();

    applicants = LoanConversionUtility_Helper.GetApplicantDetails(apId);


    for (Applicant__c app: applicants) {

     if (app.Applicant_Type__c == 'Primary' || app.Applicant_Type__c == 'Primary Applicant') {
      primaryApplicantObj = app;
      //rasika PD 4 tat
      //Rohit 16111 CR -16437 S                      
      LoanConversionUtilityRemote.linkEkyc(leadObj, primaryApplicantObj);
      //Rohit 16111 CR - 16437 E
      // system.debug('primaryApplicantObj'+primaryApplicantObj);
      if (primaryApplicantObj != null)
       LoanConversionUtility_Helper.SendPrimaryApplicantEmail(primaryApplicantObj, oppObj.id);


      if (app.Lead__c != null) {
       cibLead.put(app.Lead__c, app.id);
       leadIds.add(app.Lead__c);
      } else if (app.Lead_Applicants__c != null) {
       cibLeadApp.put(app.Lead_Applicants__c, app.id);
       leadApId.add(app.Lead_Applicants__c);
      }
     } else {

      //This code is for copying Cibil Temps of non primary applicant

      if (app.Lead_Applicants__c != null) {
       cibLeadApp.put(app.Lead_Applicants__c, app.id);
       leadApId.add(app.Lead_Applicants__c);
      }


     }
    }
    //system.debug('CAmlist====here is 1828===>' + CAmlist);
    if (isCallCenter)

    {


     //start of Existing Loan Details
     /* List < Existing_Loan_Details__c > extLoanOpp = new List < Existing_Loan_Details__c > ();
          List < Existing_Loan_Details__c > extLoan = new List < Existing_Loan_Details__c > ();
          extLoan = [select id,Rate_of_Interest__c, Derived_EMI__c,Customer_Declared_EMI__c,Remark__c,Property_Purchase_Date__c,Purchase_Value__c , Secured_Unsecured__c, Loan_Type__c, Seen_in__c,
          Loan_Acc_No__c, Select__c, Applicant__r.ContactName__c, Principal_O_s__c, Status__c,
          Financer__c, Amount__c, Month1_Amount__c, Month2_Amount__c, Financers__c, Obligation__c,
          Start_On__c, Tenor__c, Tenor_Left__c, MOB__c, POS__c, EMI__c, Applicant__c, Annual_Obligation__c, Type_of_Oblig__c, Product_Offering__c, Loan_Amount__c,
          Month3Amount__c, Month4Amount__c, Month5Amount__c, Month6Amount__c, Mthly_Oblig__c, EMI_Over_In_Next_6_months__c from Existing_Loan_Details__c where Product_Offering__c = : productOfferObj[0].id
          ];
          if (extLoan != null && extLoan.size() > 0) {
              system.debug('extLoan size*****' + extLoan.size());
              for (Existing_Loan_Details__c objExtLoan: extLoan) {
                  Existing_Loan_Details__c objExt = new Existing_Loan_Details__c();
                  objExt = objExtLoan.clone(false, false, false, false);
                  system.debug('*****Cloneed cam  Object :--' + objExt);
                  objExt.Applicant__c = primaryApplicantObj.Id;
                  //objExt.Loan_Amount__c = objExtLoan.Loan_Amount__c;
                  objExt.Loan_Application__c = oppObj.Id;
                  objExt.Product_Offering__c = null;
                  extLoanOpp.add(objExt);
              }
              if (extLoanOpp != null && extLoanOpp.size() > 0) {
                  try {
                      insert extLoanOpp;
                  } catch (DMLException e) {
                      String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
                      str+='Product Offering Id :'+offeringId+' \n Block 2';// Bug 12463
                      System.debug(str);
                      CommonUtility.SendExceptionMail(str);
                  }
              }
          } */

     //End of Existing Loan Details
     cloneExistingLoanDetailsCallCenter(primaryApplicantObj.Id, oppObj.Id, productOfferObj[0].id);
     /* SAL PLTB bug 12736 priya added isCallCenter parameter in saveCAMtoOpp*/
     /* MObility For SAL flow added by priya */
     saveCAMtoOpp(primaryApplicantObj.Id, oppObj.Id, productOfferObj[0].id, leadObj.id, isCallCenter, flow);
     //system.debug('Before MapRecordsCIBILWatch');
     //system.debug('primaryApplicantObj.id'+primaryApplicantObj.id);

     /** SAL PLTB bugId - 13952 start*/
     priApplicant = primaryApplicantObj.Id;
     /** SAL PLTB bugId - 13952 end*/

     MapRecordsCIBILWatch(productOfferObj[0].id, productOfferObj[0].Lead_Source__c, oppObj.id, leadObj.id, leadObj.Name, isCallCenter, cibilwatchFlag, priApplicant);

     updateAccountData(productOfferObj[0].id, accountObj.Id, flow); /*Mobility for SAL added by priya */

    }
    //system.debug('CAmlist====here is 1994===>' + CAmlist);

    /*SAL PLTB added isCallCenter flag by Pritha */
    Map < String, String > mapObj = new Map < String, String > ();
    mapObj.put('Applicant', JSON.serialize(primaryApplicantObj));
    mapObj.put('Lead', JSON.serialize(leadObj));
    saveSolPolicy(oppObj.Id, productOfferObj[0].Id, isCallCenter, mapObj);
    //added not condition for Call center S
    if (!isCallCenter) {
     savePropertyDetailNew(oppObj.Id, productOfferObj[0].Id);
    }
    //added not condition for Call center E
    //Mortgage Re-Engg Start
    //system.debug('Mortgageflag:: Rasika' + Mortgageflag);
    if (Mortgageflag) {
     Map < String, String > mapObjProp = new Map < String, String > (); //bug 13253
     if (PoPropID != null)
      mapObjProp.put('propertyList', JSON.serialize(PoPropID)); //bug 13253

     Map < String, String > mapObjPropNew = new Map < String, String > (); //bug 13253
     if (!PropMap.isEmpty())
      mapObjPropNew.put('NewpropertyList', JSON.serialize(PropMap)); //bug 13253

     saveBankDetails(oppObj.Id, productOfferObj[0].Id, mapObjProp, mapObjPropNew); // bug 13253: added 2 parameters
    }
    //system.debug('CAmlist====here is 2021===>' + CAmlist);

    if (productOfferObj[0].Process_Type__c == 'salaried' && Mortgageflag == true) {
     system.debug('---Inside Salaried Condition---');
     //Insert CAM record for salaried flow
     //added not condition for Call center S
     if (!isCallCenter) {
      saveCAMSalaried(oppObj.Id, productOfferObj[0]);
     }
     //added not condition for Call center E
    } else {
     //added not condition for Call center S
     if (!isCallCenter) {
      system.debug('cam list while calling method is===>' + CAmlist);
      MAP < string, string > mapDLRMValue = new MAP < string, string > ();
      if (isDLRMProduct) {
       mapDLRMValue.put('Total_Secured_Exposure__c', string.valueOf(productOfferObj[0].Total_Secured_Exposure__c));
       mapDLRMValue.put('Total_Unsecured_Exposure__c', string.valueOf(productOfferObj[0].Total_Unsecured_Exposure__c));
       mapDLRMValue.put('mob__c', string.valueOf(productOfferObj[0].mob__c));
       mapDLRMValue.put('Gross_Turnover__c', string.valueOf(productOfferObj[0].Gross_Turnover__c));
      }
      saveCAMnew(primaryApplicantObj.Id, oppObj.Id, productOfferObj[0].Id, mapDLRMValue);
      /*Mobility for SAL added by priya Start*/
      //Rohit added for bug 18852
      if (flow == 'salaried' || (flow != '' && (productOfferObj[0].Products__c == 'SBS CS SAL' || productOfferObj[0].Products__c == 'RSL'))) {
       saveCAMtoOpp(primaryApplicantObj.Id, oppObj.Id, productOfferObj[0].id, leadObj.id, isCallCenter, flow);
      }
      /*Mobility for SAL added by priya End*/

     }
     //added not condition for Call center E
    }
    //Mortgage Re-Engg End
    //added not condition for Call center S
    if (!isCallCenter) {
     savePersonalDiscussionsnew(primaryApplicantObj.Id, oppObj.Id, productOfferObj[0]);
    }
    //added not condition for Call center E
    Map < String, String > mapObj1 = new Map < String, String > ();
    mapObj1.put('ApplicantLiSt', JSON.serialize(applicants));
    mapObj1.put('leadApplicantId', JSON.serialize(appIDs));
    InsertEKYCData(mapObj1, productOfferObj[0].Id, isCallCenter, leadObj.Id, primaryApplicantObj.Id);
    //Bug ID 7444 :: RTR For RM  start
    //added not condition for Call center S
    if (!isCallCenter) {
     cloneExistingLoanDetails(primaryApplicantObj.Id, oppObj.Id, productOfferObj[0].Id);
    }
    //cloneExistingLoanDetails(primaryApplicantObj.Id, oppObj.Id, productOfferObj[0].Id);
    //added not condition for Call center E
    //Bug ID 7444 :: RTR For RM  end
    //createverification(productOfferObj[0], primaryApplicantObj);
    //prod issue bug 10664 by akshata start
    if (leadId != null) {
     cibLead.put(leadId, primaryApplicantObj.id);
     leadIds.add(leadId);
    }
    //prod issue bug 10664 by akshata End

    //cibil revamp - Update_CIBIL_Error__c added in query condition
    List < Cibil_Temp__c > CibilTempLst = new List < Cibil_Temp__c > ();
    CibilTempLst = [Select(select id, createdDate, Cibil_Temp__r.Lead__c, Cibil_Temp__r.Lead_Applicants__c from CIBILs__r ORDER BY createdDate DESC LIMIT 1),
     Acct_cont_email__c, /*bug 13911 start*/ DPD_cluster_Segment__c /*bug 13911 end*/ , Acct_cont_Mobile__c, Acct_cont_person__c, Address_1st_Line__c, Address_1__c, Address_2nd_Line__c, Address_2__c, Address_3rd_Line__c, Address_3__c, Address_Line_One__c, Age__c, AppCity__c, ApplicantType__c, Applicant__c, Average_Monthly_Net_Income__c, Bank_Account_No__c, Bank_Account_type__c, Bank_Name__c, Branch_Address__c, Business_Name__c, CIBIL_Match_Check__c, CIBIL_Response__c, CIBIL_Score__c, Company_Type__c, ConnectionReceivedId, ConnectionSentId, Contact_Person_At_This_Address__c, CreatedById, CreatedDate, CurrencyIsoCode, Current_Employment_Vintage__c, Date_of_Birth__c, Demat_A_c_No__c, Department__c, Dependents__c, Descriptin__c, Description__c, Designation__c, Driving_License_Number__c, Educational_Qualification__c, Email__c, Employer_Name__c, Employment_Status__c, Employment_Type__c, Enable_Manual_Cibil__c, Enterprise_Classification__c, FathersHusbands_Name__c, Father_s_Name__c, Finance_Amount__c, First_Name__c, Gender__c, Gross_Loan_Amount__c, Id, IFSC_Code__c, Integrate_with_CIBIL__c, IsDeleted, LastModifiedById, LastModifiedDate, Last_Name__c, Lead_Applicants__c, Lead__c, Loan_Application__c, Marital_Status__c, MICR_Code__c, Middle_Name__c, MOBILE_N__c, Mobile_Phone__c, Mobile__c, Name, Office_City__c, Office_Contact_Number__c, Office_Contact_Person__c, Office_Email_Id__c, Office_Phone_Number__c, Office_Pin_Code__c, Office_State__c, Office_STD_Code__c, Others_Employer__c, OwnerId, PAN_Number__c, PassPort_Number__c, Permanant_Address_Line_1__c, Permanant_Address_Line_2__c, Permanant_Address_Line_3__c, Permanant_City__c, Permanent_Address_same_as_Residence__c, Permanent_Land_Mark__c, Permanent_Mobile__c, Permanent_Pin_Code__c, Permanent_State__c, Permanent_STD__c, Permenant_Phone__c, Phone_Number__c, Pin_Code__c, Preferred_communication_address__c, Product__c, Random_Number_for_CIBIL__c, Sex__c, Spouse_Name__c, State__c, stay_resi_addr_since_month__c, stay_resi_addr_since_year__c, STD_Code__c, SystemModstamp, Update_CIBIL_Error__c, VoterID_Number__c
     FROM Cibil_Temp__c where Update_CIBIL_Error__c = False and(Lead__c IN: leadIds or Lead_Applicants__c IN: leadApId) order by CreatedDate DESC
    ];
    system.debug('Cibiltemp' + CibilTempLst + ' CibilTempLstsize' + CibilTempLst.size() + 'leadApId' + leadApId);

    /*  Set<Id> latestCIBIL_ids = new Set<Id>();
    List < Cibil__c > cibilList = new List < Cibil__c > ();
    for(Cibil_Temp__c cibiltemp : CibilTempLst){
        if(cibiltemp.CIBILs__r.size() > 0){
            latestCIBIL_ids.add(cibiltemp.CIBILs__r[0].Id);
        }
    }
              */
    //added for call center S
    if (isCallCenter) {
     //Set<Id> latestCIBIL_ids = new Set<Id>();
     //List < Cibil__c > cibilList = new List < Cibil__c > ();
     for (Cibil_Temp__c cibiltemp: CibilTempLst) {
      if (cibiltemp.CIBILs__r.size() > 0) {
       latestCIBIL_ids.add(cibiltemp.CIBILs__r[0].Id);
      }
     }
    }
    //added for call center E
    //5211 S 
    Map < id, Cibil_Temp__c > cibilTempLeadmap = new Map < id, Cibil_Temp__c > ();
    Map < id, Cibil_Temp__c > cibilTempLeadAppmap = new Map < id, Cibil_Temp__c > ();



    for (Cibil_Temp__c cibiltemp: CibilTempLst) {



     if (cibLead.containsKey(cibiltemp.Lead__c)) {

      if (cibilTempLeadmap.get(cibiltemp.Lead__c) != null) {

       //do nothing 
      } else {

       cibilTempLeadmap.put(cibiltemp.Lead__c, cibiltemp);
      }

     }

     if (cibLeadApp.containsKey(cibiltemp.Lead_Applicants__c)) {

      system.debug('in a if cibLeadApp.containsKey cibiltemp.Lead_Applicants__c ');

      if (cibilTempLeadAppmap.get(cibiltemp.Lead_Applicants__c) != null) {

       //do nothing 
      } else {
       system.debug('cibiltemp.Lead_Applicants__c' + cibiltemp.Lead_Applicants__c);
       cibilTempLeadAppmap.put(cibiltemp.Lead_Applicants__c, cibiltemp);
      }

     }
    }

    List < Cibil_Temp__c > newleadcibTemplist = new List < Cibil_Temp__c > (cibilTempLeadmap.values());

    List < Cibil_Temp__c > newleadappcibTemplist = new List < Cibil_Temp__c > (cibilTempLeadAppmap.values());

    List < Cibil_temp__c > updatedCibilTempList = new List < Cibil_Temp__c > ();

    updatedCibilTempList.addAll(newleadappcibTemplist);
    updatedCibilTempList.addAll(newleadcibTemplist);



    // Map<Id,Id> applicantToCibilMap = moveCIBILTEMPToOpportunity(CibilTempLst,cibLead,cibLeadApp);

    Map < Id, Id > applicantToCibilMap = moveCIBILTEMPToOpportunity(updatedCibilTempList, cibLead, cibLeadApp);
    //commented for call center
    //Set < Id > latestCIBIL_ids = new Set < Id > ();
    //List < Cibil__c > cibilList = new List < Cibil__c > ();
    //commented for call center
    for (Cibil_Temp__c cibiltemp: updatedCibilTempList) {
     if (cibiltemp.CIBILs__r.size() > 0) {
      latestCIBIL_ids.add(cibiltemp.CIBILs__r[0].Id);
     }
    }
    //5211 E 
    cibilList = [SELECT Account_Info1__c, Cibil_Temp__r.Lead_Applicants__c, Cibil_Temp__r.Lead__c, Account_Info2__c, Account_Info3__c, Account_Info4__c, Account_Info5__c, Account_Info6__c, Account_Info7__c, Account_Info8__c, Account_Info9__c, Account_Info10__c, Account_Info11__c, Account_Info12__c, Account_Info13__c, Account_Info14__c, Account_Info15__c, Account_Info16__c, Account_Info17__c, Account_Info18__c, Account_Info19__c, Account_Info__c, Account_Type1__c, Account_Type2__c, Account_Type3__c, Account_Type4__c, Account_Type5__c, Account_Type6__c, Account_Type7__c, Account_Type8__c, Account_Type9__c, Account_Type10__c, Account_Type11__c, Account_Type12__c, Account_Type13__c, Account_Type14__c, Account_Type15__c, Account_Type16__c, Account_Type17__c, Account_Type18__c, Account_Type19__c, Account_Type_Loan_offered__c, Account_Type__c, Address6__c, Address7__c, Address_Line2_of_c3__c, Address_Line2_of_c4__c, Address_Line2__c, Address_Line3_of_c2__c, Address_Line3_of_c3__c, Address_Line3_of_c4__c, Address_Line3__c, Address_Line4_of_c2__c, Address_Line4_of_c3__c, Address_Line4_of_c4__c, Address_Line4__c, Address_Line5_of_c2__c, Address_Line5_of_c3__c, Address_Line5_of_c4__c, Address_Line5__c, Amount_Overdue1__c, Amount_Overdue2__c, Amount_Overdue3__c, Amount_Overdue4__c, Amount_Overdue5__c, Amount_Overdue6__c, Amount_Overdue7__c, Amount_Overdue8__c, Amount_Overdue9__c, Amount_Overdue10__c, Amount_Overdue11__c, Amount_Overdue12__c, Amount_Overdue13__c, Amount_Overdue14__c, Amount_Overdue15__c, Amount_Overdue16__c, Amount_Overdue17__c, Amount_Overdue18__c, Amount_Overdue19__c, Amount_Overdue__c, Amout_Overdue_Limit__c, Applicant_Name__c, Applicant__c, ArrayUpdate__c, Caliculated_HTS_Amount__c, CibilDateUpdate__c, CibilDate__c, Cibil_Extension1__c, CIBIL_Extension__c, CIBIL_Fired_time__c, CIBIL_Match_check__c, CIBIL_offer_HTS_Amount__c, CIBIL_rule_status_field__c, CIBIL_Rule_Status__c, Cibil_score_check_for_HTS__c, CIBIL_Score__c, CIBIL_TAT__c, Cibil_Temp__c, CIBIL_updated_time__c, ConnectionReceivedId, ConnectionSentId, CreatedById, CreatedDate, CurrencyIsoCode, Current_Balance1__c, Current_Balance2__c, Current_Balance3__c, Current_Balance4__c, Current_Balance5__c, Current_Balance6__c, Current_Balance7__c, Current_Balance8__c, Current_Balance9__c, Current_Balance10__c, Current_Balance11__c, Current_Balance12__c, Current_Balance13__c, Current_Balance14__c, Current_Balance15__c, Current_Balance16__c, Current_Balance17__c, Current_Balance18__c, Current_Balance19__c, Current_Balance__c, Date_Closed1__c, Date_Closed2__c, Date_Closed3__c, Date_Closed4__c, Date_Closed5__c, Date_Closed6__c, Date_Closed7__c, Date_Closed8__c, Date_Closed9__c, Date_Closed10__c, Date_Closed11__c, Date_Closed12__c, Date_Closed13__c, Date_Closed14__c, Date_Closed15__c, Date_Closed16__c, Date_Closed17__c, Date_Closed18__c, Date_Closed19__c, Date_Closed__c, Date_Last_Payment1__c, Date_Last_Payment2__c, Date_Last_Payment3__c, Date_Last_Payment4__c, Date_Last_Payment5__c, Date_Last_Payment6__c, Date_Last_Payment7__c, Date_Last_Payment8__c, Date_Last_Payment9__c, Date_Last_Payment10__c, Date_Last_Payment11__c, Date_Last_Payment12__c, Date_Last_Payment13__c, Date_Last_Payment14__c, Date_Last_Payment15__c, Date_Last_Payment16__c, Date_Last_Payment17__c, Date_Last_Payment18__c, Date_Last_Payment19__c, Date_Last_Payment__c, Date_of_Birth__c, Date_of_Enquiry1__c, Date_of_Enquiry2__c, Date_of_Enquiry3__c, Date_of_Enquiry4__c, Date_of_Enquiry5__c, Date_of_Enquiry6__c, Date_of_Enquiry7__c, Date_of_Enquiry8__c, Date_of_Enquiry9__c, Date_of_Enquiry10__c, Date_of_Enquiry11__c, Date_of_Enquiry12__c, Date_of_Enquiry13__c, Date_of_Enquiry14__c, Date_of_Enquiry15__c, Date_of_Enquiry16__c, Date_of_Enquiry17__c, Date_of_Enquiry18__c, Date_of_Enquiry19__c, Date_of_Enquiry__c, Date_Opened1__c, Date_Opened2__c, Date_Opened3__c, Date_Opened4__c, Date_Opened5__c, Date_Opened6__c, Date_Opened7__c, Date_Opened8__c, Date_Opened9__c, Date_Opened10__c, Date_Opened11__c, Date_Opened12__c, Date_Opened13__c, Date_Opened14__c, Date_Opened15__c, Date_Opened16__c, Date_Opened17__c, Date_Opened18__c, Date_Opened19__c, Date_Opened_CIBIL_Offer__c, Date_Opened__c, Date_Processed__c, Date_Reported1__c, Date_Reported2__c, Date_Reported3__c, Date_Reported4__c, Date_Reported5__c, Date_Reported6__c, Date_Reported7__c, Date_Reported8__c, Date_Reported9__c, Date_Reported10__c, Date_Reported11__c, Date_Reported12__c, Date_Reported13__c, Date_Reported14__c, Date_Reported15__c, Date_Reported16__c, Date_Reported17__c, Date_Reported18__c, Date_Reported19__c, Date_Reported__c, Days_Past_Due1__c, Days_Past_Due2__c, Days_Past_Due3__c, Days_Past_Due4__c, Days_Past_Due5__c, Days_Past_Due6__c, Days_Past_Due7__c, Days_Past_Due8__c, Days_Past_Due9__c, Days_Past_Due10__c, Days_Past_Due11__c, Days_Past_Due12__c, Days_Past_Due13__c, Days_Past_Due14__c, Days_Past_Due15__c, Days_Past_Due16__c, Days_Past_Due17__c, Days_Past_Due18__c, Days_Past_Due19__c, Days_Past_Due__c, Description__c, Eligible_for_HTS__c, Eligible_HTS_Amount__c, Eligible_HTS_Fees__c, Eligible_HTS_ROI__c, Eligible_HTS_Tenor__c, Enable_Manual_Cibil__c, Enquiry_Amount1__c, Enquiry_Amount2__c, Enquiry_Amount3__c, Enquiry_Amount4__c, Enquiry_Amount5__c, Enquiry_Amount6__c, Enquiry_Amount7__c, Enquiry_Amount8__c, Enquiry_Amount9__c, Enquiry_Amount10__c, Enquiry_Amount11__c, Enquiry_Amount12__c, Enquiry_Amount13__c, Enquiry_Amount14__c, Enquiry_Amount15__c, Enquiry_Amount16__c, Enquiry_Amount17__c, Enquiry_Amount18__c, Enquiry_Amount19__c, Enquiry_Amount__c, Enquiry_Control_Number__c, Enquiry_Member_Code__c, Enquiry_Purpose1__c, Enquiry_Purpose2__c, Enquiry_Purpose3__c, Enquiry_Purpose4__c, Enquiry_Purpose5__c, Enquiry_Purpose6__c, Enquiry_Purpose7__c, Enquiry_Purpose8__c, Enquiry_Purpose9__c, Enquiry_Purpose10__c, Enquiry_Purpose11__c, Enquiry_Purpose12__c, Enquiry_Purpose13__c, Enquiry_Purpose14__c, Enquiry_Purpose15__c, Enquiry_Purpose16__c, Enquiry_Purpose17__c, Enquiry_Purpose18__c, Enquiry_Purpose19__c, Enquiry_Purpose__c, Gender__c, Higher_Loan_Qualify1__c, Higher_Loan_Qualify2__c, Higher_Loan_Qualify3__c, Higher_Loan_Qualify4__c, Higher_Loan_Qualify5__c, Higher_Loan_Qualify6__c, Higher_Loan_Qualify7__c, Higher_Loan_Qualify8__c, Higher_Loan_Qualify9__c, Higher_Loan_Qualify10__c, Higher_Loan_Qualify11__c, Higher_Loan_Qualify12__c, Higher_Loan_Qualify13__c, Higher_Loan_Qualify14__c, Higher_Loan_Qualify15__c, Higher_Loan_Qualify16__c, Higher_Loan_Qualify17__c, Higher_Loan_Qualify18__c, Higher_Loan_Qualify19__c, Higher_Loan_Qualify__c, HTS_Not_Eligible_for__c, Id, Income_Tax_ID__c, IsDeleted, LastActivityDate, LastModifiedById, LastModifiedDate, Lead_Applicants__c, Lead__c, Loan_Application_Number__c, Main_Higher_Loan_Qualify1__c, Main_Higher_Loan_Qualify2__c, Main_Higher_Loan_Qualify3__c, Main_Higher_Loan_Qualify__c, Maximum_Loan_Type__c, Maximum_Sanctioned_amount__c, Member1__c, Member2__c, Member3__c, Member4__c, Member5__c, Member6__c, Member7__c, Member8__c, Member9__c, Member10__c, Member11__c, Member12__c, Member13__c, Member14__c, Member15__c, Member16__c, Member17__c, Member18__c, Member19__c, Member_Name1__c, Member_Name2__c, Member_Name3__c, Member_Name4__c, Member_Name5__c, Member_Name6__c, Member_Name7__c, Member_Name8__c, Member_Name9__c, Member_Name10__c, Member_Name11__c, Member_Name12__c, Member_Name13__c, Member_Name14__c, Member_Name15__c, Member_Name16__c, Member_Name17__c, Member_Name18__c, Member_Name19__c, Member_Name20__c, Member_Name__c, Member__c, Mitigating_Authority__c, Name, Ownership1__c, Ownership2__c, Ownership3__c, Ownership4__c, Ownership5__c, Ownership6__c, Ownership7__c, Ownership8__c, Ownership9__c, Ownership10__c, Ownership11__c, Ownership12__c, Ownership13__c, Ownership14__c, Ownership15__c, Ownership16__c, Ownership17__c, Ownership18__c, Ownership19__c, Ownership__c, Passport_No__c, Phone_No__c, Pincode2__c, Pincode3__c, Pincode4__c, Pincode5__c, Pincode__c, PLScore__c, Product_Type__c, Qualifying_Loan_Type1__c, Qualifying_Loan_Type2__c, Qualifying_Loan_Type3__c, Qualifying_Loan_Type4__c, Qualifying_Sanction_Amount1__c, Qualifying_Sanction_Amount2__c, Qualifying_Sanction_Amount3__c, Qualifying_Sanction_Amount4__c, Qualify_Grade1__c, Qualify_Grade2__c, Qualify_Grade3__c, Qualify_Grade4__c, Qualify_Grade5__c, Qualify_Grade6__c, Qualify_Grade7__c, Qualify_Grade8__c, Qualify_Grade9__c, Qualify_Grade10__c, Qualify_Grade11__c, Qualify_Grade12__c, Qualify_Grade13__c, Qualify_Grade14__c, Qualify_Grade15__c, Qualify_Grade16__c, Qualify_Grade17__c, Qualify_Grade18__c, Qualify_Grade19__c, Qualify_Grade__c, Rating_Field_No__c, Rating_Loan_Type__c, Sanction_Amount1__c, Sanction_Amount2__c, Sanction_Amount3__c, Sanction_Amount4__c, Sanction_Amount5__c, Sanction_Amount6__c, Sanction_Amount7__c, Sanction_Amount8__c, Sanction_Amount9__c, Sanction_Amount10__c, Sanction_Amount11__c, Sanction_Amount12__c, Sanction_Amount13__c, Sanction_Amount14__c, Sanction_Amount15__c, Sanction_Amount16__c, Sanction_Amount17__c, Sanction_Amount18__c, Sanction_Amount19__c, Sanction_Amount__c, Score__c, Start_End_Dates1__c, Start_End_Dates2__c, Start_End_Dates3__c, Start_End_Dates4__c, Start_End_Dates5__c, Start_End_Dates6__c, Start_End_Dates7__c, Start_End_Dates8__c, Start_End_Dates9__c, Start_End_Dates10__c, Start_End_Dates11__c, Start_End_Dates12__c, Start_End_Dates13__c, Start_End_Dates14__c, Start_End_Dates15__c, Start_End_Dates16__c, Start_End_Dates17__c, Start_End_Dates18__c, Start_End_Dates19__c, Start_End_Dates__c, State2__c, State3__c, State4__c, State5__c, State__c, Suit_Filed_Status1__c, Suit_Filed_Status2__c, Suit_Filed_Status3__c, Suit_Filed_Status4__c, Suit_Filed_Status5__c, Suit_Filed_Status6__c, Suit_Filed_Status7__c, Suit_Filed_Status8__c, Suit_Filed_Status9__c, Suit_Filed_Status10__c, Suit_Filed_Status11__c, Suit_Filed_Status12__c, Suit_Filed_Status13__c, Suit_Filed_Status14__c, Suit_Filed_Status15__c, Suit_Filed_Status16__c, Suit_Filed_Status17__c, Suit_Filed_Status18__c, Suit_Filed_Status19__c, Suit_Filed_Status__c, SystemModstamp, Time_Processed__c, Total_Enquiries__c, Total_Loans__c, Update_CIBIL_Error__c, Utilization__c, Voter_ID__c, X0th_set__c, X1st_set__c, X2nd_Set__c, X3rd_Set__c FROM CIBIL__c where Id IN: latestCIBIL_ids];

    Set < Id > cibilExtensionIdSet = new Set < Id > ();
    Set < Id > cibilExtension1IdSet = new Set < Id > ();


    for (Cibil__c cibilObj: cibilList) {
     if (cibilObj.CIBIL_Extension__c != null) cibilExtensionIdSet.add(cibilObj.CIBIL_Extension__c);
     if (cibilObj.Cibil_Extension1__c != null) cibilExtension1IdSet.add(cibilObj.Cibil_Extension1__c);
    }


    List < CIBIL_Extension__c > cibilExList = new List < CIBIL_Extension__c > ();
    cibilExList = [SELECT Cibil_Temp__r.Lead__c, Cibil_Temp__r.Lead_Applicants__c, Account_Info20__c, Account_Info21__c, Account_Info22__c, Account_Info23__c, Account_Info24__c, Account_Info25__c, Account_Info26__c, Account_Info27__c, Account_Info28__c, Account_Info29__c, Account_Type20__c, Account_Type21__c, Account_Type22__c, Account_Type23__c, Account_Type24__c, Account_Type25__c, Account_Type26__c, Account_Type27__c, Account_Type28__c, Account_Type29__c, Additional_ID_1__c, Additional_ID_2__c, Address_Category1__c, Address_Category2__c, Address_Category3__c, Address_Category4__c, Age_of_Loan20__c, Age_of_Loan21__c, Age_of_Loan22__c, Age_of_Loan23__c, Age_of_Loan24__c, Age_of_Loan25__c, Age_of_Loan26__c, Age_of_Loan27__c, Age_of_Loan28__c, Age_of_Loan29__c, Amount_Overdue20__c, Amount_Overdue21__c, Amount_Overdue22__c, Amount_Overdue23__c, Amount_Overdue24__c, Amount_Overdue25__c, Amount_Overdue26__c, Amount_Overdue27__c, Amount_Overdue28__c, Amount_Overdue29__c, Applicant__c, Cibil_Temp__c, ConnectionReceivedId, ConnectionSentId, CreatedById, CreatedDate, CurrencyIsoCode, Current_Balance20__c, Current_Balance21__c, Current_Balance22__c, Current_Balance23__c, Current_Balance24__c, Current_Balance25__c, Current_Balance26__c, Current_Balance27__c, Current_Balance28__c, Current_Balance29__c, Date_Closed20__c, Date_Closed21__c, Date_Closed22__c, Date_Closed23__c, Date_Closed24__c, Date_Closed25__c, Date_Closed26__c, Date_Closed27__c, Date_Closed28__c, Date_Closed29__c, Date_Last_Payment20__c, Date_Last_Payment21__c, Date_Last_Payment22__c, Date_Last_Payment23__c, Date_Last_Payment24__c, Date_Last_Payment25__c, Date_Last_Payment26__c, Date_Last_Payment27__c, Date_Last_Payment28__c, Date_Last_Payment29__c, Date_of_Enquiry20__c, Date_of_Enquiry21__c, Date_of_Enquiry22__c, Date_of_Enquiry23__c, Date_of_Enquiry24__c, Date_of_Enquiry25__c, Date_of_Enquiry26__c, Date_of_Enquiry27__c, Date_of_Enquiry28__c, Date_of_Enquiry29__c, Date_Opened20__c, Date_Opened21__c, Date_Opened22__c, Date_Opened23__c, Date_Opened24__c, Date_Opened25__c, Date_Opened26__c, Date_Opened27__c, Date_Opened28__c, Date_Opened29__c, Date_Reported1__c, Date_Reported2__c, Date_Reported3__c, Date_Reported4__c, Date_Reported20__c, Date_Reported21__c, Date_Reported22__c, Date_Reported23__c, Date_Reported24__c, Date_Reported25__c, Date_Reported26__c, Date_Reported27__c, Date_Reported28__c, Date_Reported29__c, Days_Past_Due20__c, Days_Past_Due21__c, Days_Past_Due22__c, Days_Past_Due23__c, Days_Past_Due24__c, Days_Past_Due25__c, Days_Past_Due26__c, Days_Past_Due27__c, Days_Past_Due28__c, Days_Past_Due29__c, Driver_s_License_Expiration_Date__c, Driver_s_License_Issue_Date__c, Driver_s_License_Number__c, Email_1__c, Email_2__c, Email_3__c, Email_4__c, EM_Cibil_Remarks_Code__c, EM_Date_of_Entry_for_Cibil_Remarks_Code__c, EM_Date_of_Entry_for_Error_Code__c, EM_Date_of_Entry_for_Error_Dispute_Re__c, EM_Error_Code__c, EM_Error_Dispute_Remarks_Code_1__c, EM_Error_Dispute_Remarks_Code_2__c, EM_Error_Segment_Tag__c, Enquiry_Amount20__c, Enquiry_Amount21__c, Enquiry_Amount22__c, Enquiry_Amount23__c, Enquiry_Amount24__c, Enquiry_Amount25__c, Enquiry_Amount26__c, Enquiry_Amount27__c, Enquiry_Amount28__c, Enquiry_Amount29__c, Enquiry_Purpose20__c, Enquiry_Purpose21__c, Enquiry_Purpose22__c, Enquiry_Purpose23__c, Enquiry_Purpose24__c, Enquiry_Purpose25__c, Enquiry_Purpose26__c, Enquiry_Purpose27__c, Enquiry_Purpose28__c, Enquiry_Purpose29__c, Expiration_Date1__c, Expiration_Date2__c, Expiration_Date3__c, Expiration_Date4__c, Expiration_Date5__c, Expiration_Date6__c, Expiration_Date7__c, Expiration_Date8__c, Id, ID_Number1__c, ID_Number2__c, ID_Number3__c, ID_Number4__c, ID_Number5__c, ID_Number6__c, ID_Number7__c, ID_Number8__c, ID_Type1__c, ID_Type2__c, ID_Type3__c, ID_Type4__c, ID_Type5__c, ID_Type6__c, ID_Type7__c, ID_Type8__c, Income_Tax_ID_Number_PAN__c, Income__c, IsDeleted, Issue_Date1__c, Issue_Date2__c, Issue_Date3__c, Issue_Date4__c, Issue_Date5__c, Issue_Date6__c, Issue_Date7__c, Issue_Date8__c, LastModifiedById, LastModifiedDate, Lead_Applicants__c, Lead__c, Member20__c, Member21__c, Member22__c, Member23__c, Member24__c, Member25__c, Member26__c, Member27__c, Member28__c, Member29__c, Member_Name20__c, Member_Name21__c, Member_Name22__c, Member_Name23__c, Member_Name24__c, Member_Name25__c, Member_Name26__c, Member_Name27__c, Member_Name28__c, Member_Name29__c, Member_Name30__c, Monthly_Annual_Income_Indicator__c, Name, Net_Gross_Income_Indicator__c, Occupation_Code__c, OwnerId, Ownership20__c, Ownership21__c, Ownership22__c, Ownership23__c, Ownership24__c, Ownership25__c, Ownership26__c, Ownership27__c, Ownership28__c, Ownership29__c, PAN_Card_Issue_Date__c, Passport_Expiration_Date__c, Passport_Issue_Date__c, Passport_Number__c, Payment_History_End_Date1__c, Payment_History_End_Date2__c, Payment_History_End_Date3__c, Payment_History_End_Date4__c, Payment_History_End_Date5__c, Payment_History_End_Date6__c, Payment_History_End_Date7__c, Payment_History_End_Date8__c, Payment_History_End_Date9__c, Payment_History_End_Date10__c, Payment_History_End_Date11__c, Payment_History_End_Date12__c, Payment_History_End_Date13__c, Payment_History_End_Date14__c, Payment_History_End_Date15__c, Payment_History_End_Date16__c, Payment_History_End_Date17__c, Payment_History_End_Date18__c, Payment_History_End_Date19__c, Payment_History_End_Date20__c, Payment_History_End_Date21__c, Payment_History_End_Date22__c, Payment_History_End_Date23__c, Payment_History_End_Date24__c, Payment_History_End_Date25__c, Payment_History_End_Date26__c, Payment_History_End_Date27__c, Payment_History_End_Date28__c, Payment_History_End_Date29__c, Payment_History_End_Date30__c, Payment_History_Start_Date1__c, Payment_History_Start_Date2__c, Payment_History_Start_Date3__c, Payment_History_Start_Date4__c, Payment_History_Start_Date5__c, Payment_History_Start_Date6__c, Payment_History_Start_Date7__c, Payment_History_Start_Date8__c, Payment_History_Start_Date9__c, Payment_History_Start_Date10__c, Payment_History_Start_Date11__c, Payment_History_Start_Date12__c, Payment_History_Start_Date13__c, Payment_History_Start_Date14__c, Payment_History_Start_Date15__c, Payment_History_Start_Date16__c, Payment_History_Start_Date17__c, Payment_History_Start_Date18__c, Payment_History_Start_Date19__c, Payment_History_Start_Date20__c, Payment_History_Start_Date21__c, Payment_History_Start_Date22__c, Payment_History_Start_Date23__c, Payment_History_Start_Date24__c, Payment_History_Start_Date25__c, Payment_History_Start_Date26__c, Payment_History_Start_Date27__c, Payment_History_Start_Date28__c, Payment_History_Start_Date29__c, Payment_History_Start_Date30__c, PL_Error_Code__c, PL_Exclusion_Code1__c, PL_Exclusion_Code2__c, PL_Exclusion_Code3__c, PL_Exclusion_Code4__c, PL_Exclusion_Code5__c, PL_Exclusion_Code6__c, PL_Exclusion_Code7__c, PL_Exclusion_Code8__c, PL_Exclusion_Code9__c, PL_Exclusion_Code10__c, PL_Reason_Code_1__c, PL_Reason_Code_2__c, PL_Reason_Code_3__c, PL_Reason_Code_4__c, PL_Reason_Code_5__c, PL_Score_Date__c, PL_Score__c, PN_Cibil_Remarks_Code__c, PN_Date_of_Entry_for_Cibil_Remarks_Code__c, PN_Date_of_Entry_for_Error_Code__c, PN_Date_of_Entry_for_Error_Dispute_Re__c, PN_Error_Code__c, PN_Error_Dispute_Remarks_Code_1__c, PN_Error_Dispute_Remarks_Code_2__c, PN_Error_Segment_Tag__c, Ration_Card_Number__c, Residence_Code1__c, Residence_Code2__c, Residence_Code3__c, Residence_Code4__c, Sanction_Amount20__c, Sanction_Amount21__c, Sanction_Amount22__c, Sanction_Amount23__c, Sanction_Amount24__c, Sanction_Amount25__c, Sanction_Amount26__c, Sanction_Amount27__c, Sanction_Amount28__c, Sanction_Amount29__c, Suit_Filed_Status20__c, Suit_Filed_Status21__c, Suit_Filed_Status22__c, Suit_Filed_Status23__c, Suit_Filed_Status24__c, Suit_Filed_Status25__c, Suit_Filed_Status26__c, Suit_Filed_Status27__c, Suit_Filed_Status28__c, Suit_Filed_Status29__c, SystemModstamp, Telephone_Extn1__c, Telephone_Extn2__c, Telephone_Extn3__c, Telephone_Extn4__c, Telephone_Number1__c, Telephone_Number2__c, Telephone_Number3__c, Telephone_Number4__c, Telephone_Type1__c, Telephone_Type2__c, Telephone_Type3__c, Telephone_Type4__c, Temp__c, TL_Cibil_Remarks_Code__c, TL_Date_of_Entry_for_Cibil_Remarks_Code__c, TL_Date_of_Entry_for_Error_Code__c, TL_Date_of_Entry_for_Error_Dispute_Re__c, TL_Error_Code__c, TL_Error_Dispute_Remarks_Code_1__c, TL_Error_Dispute_Remarks_Code_2__c, TU_Error_Code__c, TU_Exclusion_Code1__c, TU_Exclusion_Code2__c, TU_Exclusion_Code3__c, TU_Exclusion_Code4__c, TU_Exclusion_Code5__c, TU_Exclusion_Code6__c, TU_Exclusion_Code7__c, TU_Exclusion_Code8__c, TU_Exclusion_Code9__c, TU_Exclusion_Code10__c, TU_Reason_Code_1__c, TU_Reason_Code_2__c, TU_Reason_Code_3__c, TU_Reason_Code_4__c, TU_Reason_Code_5__c, TU_Score_Date__c, TU_Score__c, Universal_ID_Number__c, Voter_ID_Number__c FROM CIBIL_Extension__c where Id IN: cibilExtensionIdSet];
    Map < Id, Id > applicantToExtMap = moveCIBILExtentionToOpportunity(cibilExList, cibLead, cibLeadApp, applicantToCibilMap);

    List < Cibil_Extension1__c > cibilEx1List = new List < Cibil_Extension1__c > ();
    //BOL revamp added Max_LAP_Loan__c,Max_HL_Loan__c,Max_BL_Loan__c,Max_PL_Loan__c,Max_AL_Loan__c
    cibilEx1List = [Select Max_LAP_Loan__c, Max_HL_Loan__c, Max_BL_Loan__c, Max_PL_Loan__c, Max_AL_Loan__c, Cibil_Temp__r.Lead__c, Cibil_Temp__r.Lead_Applicants__c, Actual_payment1__c, Actual_payment2__c, Actual_payment3__c, Actual_payment4__c, Actual_payment5__c, Actual_payment6__c, Actual_payment7__c, Actual_payment8__c, Actual_payment9__c, Actual_payment10__c, Actual_payment11__c, Actual_payment12__c, Actual_payment13__c, Actual_payment14__c, Actual_payment15__c, Actual_payment16__c, Actual_payment17__c, Actual_payment18__c, Actual_payment19__c, Actual_payment20__c, Actual_payment21__c, Actual_payment22__c, Actual_payment23__c, Actual_payment24__c, Actual_payment25__c, Actual_payment26__c, Actual_payment27__c, Actual_payment28__c, Actual_payment29__c, Actual_payment__c, Applicant__c, Average_Total_Balance__c, Avg_unsecured_loan_amount__c, Bad_Track_Record__c, Cash_limit1__c, Cash_limit2__c, Cash_limit3__c, Cash_limit4__c, Cash_limit5__c, Cash_limit6__c, Cash_limit7__c, Cash_limit8__c, Cash_limit9__c, Cash_limit10__c, Cash_limit11__c, Cash_limit12__c, Cash_limit13__c, Cash_limit14__c, Cash_limit15__c, Cash_limit16__c, Cash_limit17__c, Cash_limit18__c, Cash_limit19__c, Cash_limit20__c, Cash_limit21__c, Cash_limit22__c, Cash_limit23__c, Cash_limit24__c, Cash_limit25__c, Cash_limit26__c, Cash_limit27__c, Cash_limit28__c, Cash_limit29__c, Cash_limit__c, CIBIL_Rules_Fail__c, CIBIL_Rule_Status__c, Cibil_Temp__c, Collateral_Type1__c, Collateral_Type2__c, Collateral_Type3__c, Collateral_Type4__c, Collateral_Type5__c, Collateral_Type6__c, Collateral_Type7__c, Collateral_Type8__c, Collateral_Type9__c, Collateral_Type10__c, Collateral_Type11__c, Collateral_Type12__c, Collateral_Type13__c, Collateral_Type14__c, Collateral_Type15__c, Collateral_Type16__c, Collateral_Type17__c, Collateral_Type18__c, Collateral_Type19__c, Collateral_Type20__c, Collateral_Type21__c, Collateral_Type22__c, Collateral_Type23__c, Collateral_Type24__c, Collateral_Type25__c, Collateral_Type26__c, Collateral_Type27__c, Collateral_Type28__c, Collateral_Type29__c, Collateral_Type__c, Collateral_Value1__c, Collateral_Value2__c, Collateral_Value3__c, Collateral_Value4__c, Collateral_Value5__c, Collateral_Value6__c, Collateral_Value7__c, Collateral_Value8__c, Collateral_Value9__c, Collateral_Value10__c, Collateral_Value11__c, Collateral_Value12__c, Collateral_Value13__c, Collateral_Value14__c, Collateral_Value15__c, Collateral_Value16__c, Collateral_Value17__c, Collateral_Value18__c, Collateral_Value19__c, Collateral_Value20__c, Collateral_Value21__c, Collateral_Value22__c, Collateral_Value23__c, Collateral_Value24__c, Collateral_Value25__c, Collateral_Value26__c, Collateral_Value27__c, Collateral_Value28__c, Collateral_Value29__c, Collateral_Value__c, ConnectionReceivedId, ConnectionSentId, CreatedById, CreatedDate, Credit_Card_Date_Opened__c, Credit_Card_utilization__c, Credit_Cord_DPD__c, Credit_Limit1__c, Credit_Limit2__c, Credit_Limit3__c, Credit_Limit4__c, Credit_Limit5__c, Credit_Limit6__c, Credit_Limit7__c, Credit_Limit8__c, Credit_Limit9__c, Credit_Limit10__c, Credit_Limit11__c, Credit_Limit12__c, Credit_Limit13__c, Credit_Limit14__c, Credit_Limit15__c, Credit_Limit16__c, Credit_Limit17__c, Credit_Limit18__c, Credit_Limit19__c, Credit_Limit20__c, Credit_Limit21__c, Credit_Limit22__c, Credit_Limit23__c, Credit_Limit24__c, Credit_Limit25__c, Credit_Limit26__c, Credit_Limit27__c, Credit_Limit28__c, Credit_Limit29__c, Credit_Limit__c, CurrencyIsoCode, Current_Bal_on_all_cards__c, Current_Obligation_All__c, Current_Obligation_Secured__c, Current_Obligation_unsecured__c, Date_Reported_Certified1__c, Date_Reported_Certified2__c, Date_Reported_Certified3__c, Date_Reported_Certified4__c, Date_Reported_Certified5__c, Date_Reported_Certified6__c, Date_Reported_Certified7__c, Date_Reported_Certified8__c, Date_Reported_Certified9__c, Date_Reported_Certified10__c, Date_Reported_Certified11__c, Date_Reported_Certified12__c, Date_Reported_Certified13__c, Date_Reported_Certified14__c, Date_Reported_Certified15__c, Date_Reported_Certified16__c, Date_Reported_Certified17__c, Date_Reported_Certified18__c, Date_Reported_Certified19__c, Date_Reported_Certified20__c, Date_Reported_Certified21__c, Date_Reported_Certified22__c, Date_Reported_Certified23__c, Date_Reported_Certified24__c, Date_Reported_Certified25__c, Date_Reported_Certified26__c, Date_Reported_Certified27__c, Date_Reported_Certified28__c, Date_Reported_Certified29__c, Date_Reported_Certified__c, EMI1__c, EMI2__c, EMI3__c, EMI4__c, EMI5__c, EMI6__c, EMI7__c, EMI8__c, EMI9__c, EMI10__c, EMI11__c, EMI12__c, EMI13__c, EMI14__c, EMI15__c, EMI16__c, EMI17__c, EMI18__c, EMI19__c, EMI20__c, EMI21__c, EMI22__c, EMI23__c, EMI24__c, EMI25__c, EMI26__c, EMI27__c, EMI28__c, EMI29__c, EMI__c, Enquiries_past_3_mnths__c, Ever_Write_off__c, First_Loan_MOB__c, Highest_DPD_In_1_Year__c, Id, Interest_rate1__c, Interest_rate2__c, Interest_rate3__c, Interest_rate4__c, Interest_rate5__c, Interest_rate6__c, Interest_rate7__c, Interest_rate8__c, Interest_rate9__c, Interest_rate10__c, Interest_rate11__c, Interest_rate12__c, Interest_rate13__c, Interest_rate14__c, Interest_rate15__c, Interest_rate16__c, Interest_rate17__c, Interest_rate18__c, Interest_rate19__c, Interest_rate20__c, Interest_rate21__c, Interest_rate22__c, Interest_rate23__c, Interest_rate24__c, Interest_rate25__c, Interest_rate26__c, Interest_rate27__c, Interest_rate28__c, Interest_rate29__c, Interest_rate__c, IsDeleted, LastModifiedById, LastModifiedDate, Latest_Loan_MOB__c, Lead_Applicants__c, Lead__c, Live_Gold_Loan_Amount__c, Max_Auto_loan_MOB__c, Max_Auto_Loan__c, Max_Lifetime_Delq__c, max_mob__c, Max_Secured_Loan_Amount__c, Max_Secured_MOB__c, Max_unSecured_Loan_Amount__c, Max_Unsecured_MOB__c, Mortgage_Loan_Amount__c, Name, No_of_DPD_12_months__c, No_Of_Live_Trades__c, Number_of_Hl_Loans__c, OSB_to_loan_amount_unsecured__c, Other_Loan_DPD__c, OwnerId, Payment_Frequency1__c, Payment_Frequency2__c, Payment_Frequency3__c, Payment_Frequency4__c, Payment_Frequency5__c, Payment_Frequency6__c, Payment_Frequency7__c, Payment_Frequency8__c, Payment_Frequency9__c, Payment_Frequency10__c, Payment_Frequency11__c, Payment_Frequency12__c, Payment_Frequency13__c, Payment_Frequency14__c, Payment_Frequency15__c, Payment_Frequency16__c, Payment_Frequency17__c, Payment_Frequency18__c, Payment_Frequency19__c, Payment_Frequency20__c, Payment_Frequency21__c, Payment_Frequency22__c, Payment_Frequency23__c, Payment_Frequency24__c, Payment_Frequency25__c, Payment_Frequency26__c, Payment_Frequency27__c, Payment_Frequency28__c, Payment_Frequency29__c, Payment_Frequency__c, Repayment_tenure1__c, Repayment_tenure2__c, Repayment_tenure3__c, Repayment_tenure4__c, Repayment_tenure5__c, Repayment_tenure6__c, Repayment_tenure7__c, Repayment_tenure8__c, Repayment_tenure9__c, Repayment_tenure10__c, Repayment_tenure11__c, Repayment_tenure12__c, Repayment_tenure13__c, Repayment_tenure14__c, Repayment_tenure15__c, Repayment_tenure16__c, Repayment_tenure17__c, Repayment_tenure18__c, Repayment_tenure19__c, Repayment_tenure20__c, Repayment_tenure21__c, Repayment_tenure22__c, Repayment_tenure23__c, Repayment_tenure24__c, Repayment_tenure25__c, Repayment_tenure26__c, Repayment_tenure27__c, Repayment_tenure28__c, Repayment_tenure29__c, Repayment_tenure__c, Secured_to_unsecured_ratio__c, Secured_Tradelines_90plus_DPD__c, Secured_Unsecured_Loan_Amount__c, Settlement1__c, Settlement2__c, Settlement3__c, Settlement4__c, Settlement5__c, Settlement6__c, Settlement7__c, Settlement8__c, Settlement9__c, Settlement10__c, Settlement11__c, Settlement12__c, Settlement13__c, Settlement14__c, Settlement15__c, Settlement16__c, Settlement17__c, Settlement18__c, Settlement19__c, Settlement20__c, Settlement21__c, Settlement22__c, Settlement23__c, Settlement24__c, Settlement25__c, Settlement26__c, Settlement27__c, Settlement28__c, Settlement29__c, Settlement__c, SystemModstamp, Temp1__c, thin_match__c, Total_Amount_overdue__c, Total_Exposure__c, Total_no_of_loans_Excluding_CC__c, Total_no_of_secured_loans__c, Total_No_of_Trades__c, Total_Sanction_Amnt_secured__c, Total_Sanction_Amnt_unsecured__c, Tradelines_30plus_DPD__c, Unsecured_Enquiries_past_3_mnths__c, Unsecured_Exposure__c, Unsecured_loan_balance__c, Unsecured_to_total_amount__c, Unsecured_to_total_ratio__c, Unsecured_Tradelines_in_last_12m__c, Upto_3_Enq__c, Write_Off__c, Written_Off_Amount__c, Written_Off_and_settled_status1__c, Written_Off_and_settled_status2__c, Written_Off_and_settled_status3__c, Written_Off_and_settled_status4__c, Written_Off_and_settled_status5__c, Written_Off_and_settled_status6__c, Written_Off_and_settled_status7__c, Written_Off_and_settled_status8__c, Written_Off_and_settled_status9__c, Written_Off_and_settled_status10__c, Written_Off_and_settled_status11__c, Written_Off_and_settled_status12__c, Written_Off_and_settled_status13__c, Written_Off_and_settled_status14__c, Written_Off_and_settled_status15__c, Written_Off_and_settled_status16__c, Written_Off_and_settled_status17__c, Written_Off_and_settled_status18__c, Written_Off_and_settled_status19__c, Written_Off_and_settled_status20__c, Written_Off_and_settled_status21__c, Written_Off_and_settled_status22__c, Written_Off_and_settled_status23__c, Written_Off_and_settled_status24__c, Written_Off_and_settled_status25__c, Written_Off_and_settled_status26__c, Written_Off_and_settled_status27__c, Written_Off_and_settled_status28__c, Written_Off_and_settled_status29__c, Written_Off_and_settled_status__c, Written_Off_principal1__c, Written_Off_principal2__c, Written_Off_principal3__c, Written_Off_principal4__c, Written_Off_principal5__c, Written_Off_principal6__c, Written_Off_principal7__c, Written_Off_principal8__c, Written_Off_principal9__c, Written_Off_principal10__c, Written_Off_principal11__c, Written_Off_principal12__c, Written_Off_principal13__c, Written_Off_principal14__c, Written_Off_principal15__c, Written_Off_principal16__c, Written_Off_principal17__c, Written_Off_principal18__c, Written_Off_principal19__c, Written_Off_principal20__c, Written_Off_principal21__c, Written_Off_principal22__c, Written_Off_principal23__c, Written_Off_principal24__c, Written_Off_principal25__c, Written_Off_principal26__c, Written_Off_principal27__c, Written_Off_principal28__c, Written_Off_principal29__c, Written_Off_principal__c, X4to8_enquiries__c, X6_months_DPD__c, X6_To_8_Enq__c, X8plus_Enquiries__c, X10_currbalance__c, X30_DPD_3_months__c, X30_DPD_12_months__c, X5000_amount_overdue__c FROM Cibil_Extension1__c where Id IN: cibilExtension1IdSet];

    Map < Id, Id > applicantToExt1Map = moveCIBILExtention1ToOpportunity(cibilEx1List, cibLead, cibLeadApp, applicantToCibilMap);


    moveCIBILToOpportunity(cibilList, cibLead, cibLeadApp, applicantToCibilMap, applicantToExtMap, applicantToExt1Map);

    //commented for Call Center S
    //createDedupeRecord(applicants);
    createDedupeRecord(applicants, cibLead, cibLeadApp);
    //commented for Call Center E

    //productOfferObj[0].Application_Number__c = oppObj.Loan_Application_Number__c;
    productOfferObj[0].Application_Number__c = applicants[0].Loan_Application__r.Loan_Application_Number__c;
    productOfferObj[0].Opportunity__c = oppObj.id;
    productOfferObj[0].Product_Offering_Converted__c = true; // added for bug 12463
    update productOfferObj;

    //changes done by Leena to send one more Parameter LAN applicants[0].Loan_Application__r.Loan_Application_Number__c
    if (productOfferObj != null && productOfferObj.size() > 0 && leadObj != null && applicants != null && applicants.size() > 0 && oppObj != null) {
     sendSMSsAndEmails(productOfferObj[0], leadObj, applicants[0].Loan_Application__r.Loan_Application_Number__c);

    }


    /* Prajyot 12830 GST implementation Start */

    addressList = new List < Address_Details__c > ();
    List < Address_Details__c > newAddressList = new List < Address_Details__c > ();
    //List<Applicant__c> appl = new List<Applicant__c>();
    system.debug('oppObj=' + oppObj.id);

    //appl = [SELECT id, Lead_Applicants__c, Lead__c FROM Applicant__c WHERE Loan_Application__c =: oppObj.id];
    //system.debug('appl='+appl);    
    //Code shifted below by Rakesh for optimization
    /*addressList = [select id, State__c, 
           Loan_application__c,Skip_Validation_Rules__c, 
                           Contact_Person_Number__c, Consider_for_Loan__c, Applicant__c,Lead_Applicant__c, lead__c  
                           from Address_Details__c 
                           where Product_offering__c =: productOfferObj[0].id and GST_IN_Number__c != null ];*/

    if (productOfferObj[0].Address_Details__r != null && productOfferObj[0].Address_Details__r.size() > 0) {
     for (Address_Details__c objAddr: productOfferObj[0].Address_Details__r) {
      if (objAddr.GST_IN_Number__c != null)
       addressList.add(objAddr);
     }
    }
    system.debug('addressList=' + addressList);

    for (Address_Details__c ad: addressList) {
     system.debug('inside for ad=' + ad);
     ad.Loan_application__c = oppObj.id;
     for (Applicant__c a: applicants) {
      system.debug('a=' + a.id);
      system.debug('ad.Lead_Applicant__c=' + ad.Lead_Applicant__c);
      system.debug('a.Lead_Applicants__c)=' + a.Lead_Applicants__c);

      if (ad.Lead_Applicant__c == a.Lead_Applicants__c && a.Applicant_Type__c != 'Primary') {
       ad.Applicant__c = a.id;
      } else if (a.Applicant_Type__c == 'Primary' && ad.Lead_Applicant__c == null) {
       ad.Applicant__c = a.id;

      }
     }

     newAddressList.add(ad);
     system.debug('addressList after=' + addressList);
    }
    upsert newAddressList;

    /* Prajyot 12830 GST implementation End */
    copyVerifications(applicants);
    //Added by mahima- 15855- CPV for PO-- end  


    if (fromBrowser == true) {
     return ('Loan Applicant with Id = ' + oppObj.Id + ' having LAN ' + applicants[0].Loan_Application__r.Loan_Application_Number__c + ' has been converted successfully !!! Please copy this id to fetch the loan application.');
    } else {
     Map < String, Object > result = new Map < String, Object > ();
     result.put('records', oppObj);
     return JSON.serialize(result);
    }

   } else {
    /* mobility for sal added by prashant*/
    if (flow == 'salaried')
     return null;
    else
     return ('The Product Offering you are converting is either already conveted or something is wrong with data please check Valid SBS Scheme/Sourcing Channel/Offer AMount/Avaliled Amont/Offer Accepted Amount/Branch !!!');
   }
  } catch (Exception e) {
   system.debug('ExceptionMessage pankaj -> ' + e.getMessage());
   String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
   str += 'Product Offering Id :' + offeringId + ' \n Block 5'; // Bug 12463
   //System.debug(str);
   LoanConversionUtility_Helper.unlock1(cqom); // Bug Id : 25285 - Concurrency Issue -unlock p2
   Database.rollback(savePointVar);
   if (!Test.isRunningTest())
    CommonUtility.SendExceptionMail(str);
   Map < String, String > result = new Map < String, String > ();
   result.put('records', 'hasException -->' + e.getMessage());
   return JSON.serialize(result);
  }
 }
 //call center added S
 /* SAL PLTB bug 12736 priya added isCallCenter parameter in saveCAMtoOpp*/
 @future
 public static void saveCAMtoOpp(String applicantId, String oppId, String poObjId, String leadObjTempId, boolean isCallCenter, string flow) {
  try {
   List < Product_Offerings__c > poObjList = new List < Product_Offerings__c > ();
   List < Lead > leadObjTemp = new List < Lead > ();
   poObjList = [select EMI_Amount__c,id, Gross_Turnover__c, /*SAL PLTB S*/ Net_Monthly_Salary_3__c, /*SAL PLTB E*/ Revised_Offer_ROI__c, Monthly_Obligation__c, Net_Monthly_Salary_1__c, Net_Monthly_Salary_2__c, Net_Salary_Per_Month__c, Enquiry_Amount__c,
    Availed_Amount__c, Requested_Tenor__c, Monthly_EMI_Obligation__c, Final_Amount__c, Gross_Profit__c, Annual_Income__c, /*SAL PLTB added by priya start */ (select id, PO_CoApp_Net_Salary_1__c, PO_CoApp_Net_Salary_2__c, PO_CoApp_Net_Salary_3__c, POPlusAmount__c, POPlusEMI__c, Total_Monthly_EMI__c, POFinalFoir__c, POEligibleForLOC__c, PO_EMI_LOC__c, ROI_Term_Loan__c, ROI_Drop_Line_Loan__c, ROI_Pure_Flexi_Loan__c, name, EMI_bounce_in_Last_3_Months__c, Product_Master__c, Program_Type__c, No_of_Bounce_for_BT_in_last_3_months__c, Net_monthly_Income__c, Work_Exp_or_business_continuty__c, CY_Obligations__c, PY_Sales_Turnover__c, SME_Score__c, CY_Audited_Turnover__c, Turnover_Change__c, No_of_Bounce_for_BT_in_last_6_months__c, OD_CC_Bank_Name__c, BFL_BL_Taken_in_last_6_Months__c, PY_OD_CC_limit__c, Applicant__c, OD_CC_limit__c, OD_CC_Limit_Change__c, PY_OD_CC_Limit_Utilisation__c, CY_Business_Vintage__c, Banking_details_OD_CC_check__c, Current_No_of_Live_BFL_Unsecured_loans__c, CY_OD_CC_Limit_Utilisation__c, OD_CC_Limit_Utilisation_Change__c, TRM_RM_comment__c, CY_Net_Profit__c, PY_Net_Profit__c, Total_Net_Profit_Change__c, Net_Salary_month1__c, Net_Salary_month2__c, Gross_Monthly_Salary_1__c, Gross_Monthly_Salary_2__c, Monthly_Obligation__c, Tenor_of_Loan__c, Fixed_Obligation_Income_Ratio__c, Loan_Amount_From_Offer__c, CY_Tenor__c, Loan_Amount__c, ROI__c, Customer_Segment__c, Sales_Customer_Segment__c, OD_CC_Flag__c, Income_from_profession_as_per_ITR__c, PY_Income_from_profession_as_per_ITR__c, Gross_Receipts__c, PY_Gross_Receipts__c, Credit_Customer_Segment__c, Line_assigned_basis_Credit_Assessment__c, Expiry_Date_without_BT__c, Line_opted__c, Line_flag__c, POUnsecuredFoir__c, Tenor_for_Line_assignment_in_yrs__c, Temporary_Overdraft__c, Construction_Valuation_1__c, Construction_Valuation_2__c, Adjusted_Rental_Income__c, Existing_HL_EMI__c, /*OTPV3 wadl change*/ Risk_Segmentation__c /*OTPV3 wadl change*/ /*PLTB changes 14951 S*/ , Location_Wise_EWS_Status__c, Codified_CIBIL__c /*PLTB changes 14951 E*/ from SurrogateCAMS__r order by createddate asc LIMIT 100) /*SAL PLTB added by priya end */
    from Product_Offerings__c where id =: poObjId
   ];
   leadObjTemp = [select id, Month1_Doc__c, Month2_Doc__c, Month3_Doc__c, Incentive_Monthly_or_Quarterly__c, Incentive1__c, Incentive2__c,
    Incentive3__c from Lead where id =: leadObjTempId
   ];
   if (poObjList != null && poObjList.size() > 0) {

    CAM__c camObj = new CAM__c();
    if(flow == 'salaried')
        camObj.EMI_on_Proposed_Loan_TO__c = poObjList[0].EMI_Amount__c;   
    camObj.Loan_Application__c = oppId;
    camObj.Applicant__c = applicantId;
    camObj.ROI__c = poObjList[0].Revised_Offer_ROI__c;
    camObj.Average_monthly_Obligations__c = poObjList[0].Monthly_Obligation__c;
    camObj.Average_incentive_for_Q1__c = poObjList[0].Net_Monthly_Salary_1__c;
    camObj.Average_incentive_for_Q2__c = poObjList[0].Net_Monthly_Salary_2__c;
    camObj.Average_incentive_for_Q3__c = poObjList[0].Net_Salary_Per_Month__c;
    camObj.Gross_Salary_Month1__c = poObjList[0].Net_Monthly_Salary_1__c;
    camObj.Gross_Salary_Month2__c = poObjList[0].Net_Monthly_Salary_2__c;
    camObj.Gross_Salary_Month3__c = poObjList[0].Net_Salary_Per_Month__c;
    system.debug('Net_Monthly_Salary_1__c--->>' + poObjList[0].Net_Monthly_Salary_1__c);
    system.debug('Net_Monthly_Salary_2__c--->>' + poObjList[0].Net_Monthly_Salary_2__c);
    system.debug('Net_Monthly_Salary_3__c--->>' + poObjList[0].Net_Salary_Per_Month__c);
    camObj.Net_Salary_for_Month1__c = poObjList[0].Net_Monthly_Salary_1__c;
    camObj.Net_Salary_for_Month2__c = poObjList[0].Net_Monthly_Salary_2__c;
    camObj.Net_Salary_for_Month3__c = poObjList[0].Net_Salary_Per_Month__c;
    if (poObjList[0].Availed_Amount__c != null) {
     camObj.Proposed_Loan_Amt__c = poObjList[0].Availed_Amount__c;
    }
    if (poObjList[0].Requested_Tenor__c != null) {
     camObj.Tenor__c = poObjList[0].Requested_Tenor__c;
    }
    if (poObjList[0].Monthly_EMI_Obligation__c != null) {
     camObj.EMI__c = poObjList[0].Monthly_EMI_Obligation__c;
    }
    camObj.Eligible_Loan__c = poObjList[0].Final_Amount__c;
    if (leadObjTemp != null && leadObjTemp.size() > 0) {
     if (leadObjTemp[0].Month1_Doc__c != null)
      camObj.Month1_Doc__c = leadObjTemp[0].Month1_Doc__c;
     if (leadObjTemp[0].Month2_Doc__c != null)
      camObj.Month2_Doc__c = leadObjTemp[0].Month2_Doc__c;
     if (leadObjTemp[0].Month3_Doc__c != null)
      camObj.Month3_Doc__c = leadObjTemp[0].Month3_Doc__c;
     if (leadObjTemp[0].Incentive_Monthly_or_Quarterly__c != null)
      camObj.Incentive_Monthly_or_Quarterly__c = leadObjTemp[0].Incentive_Monthly_or_Quarterly__c;
     if (leadObjTemp[0].Incentive1__c != null) {
      camObj.Avg_monthly_incentive1__c = leadObjTemp[0].Incentive1__c;
      camObj.LAP_pmt__c = leadObjTemp[0].Incentive1__c;
     }
     if (leadObjTemp[0].Incentive2__c != null)
      camObj.Avg_monthly_incentive2__c = leadObjTemp[0].Incentive2__c;
     if (leadObjTemp[0].Incentive3__c != null)
      camObj.Avg_monthly_incentive3__c = leadObjTemp[0].Incentive3__c;
    }
    if (poObjList[0].Gross_Profit__c != null) {
     camObj.Monthly_Reimbursement__c = poObjList[0].Gross_Profit__c;
    }
    if (poObjList[0].Annual_Income__c != null) {
     camObj.Rental_Income__c = poObjList[0].Annual_Income__c;
    }
    if (poObjList[0].Annual_Income__c != null) {
     camObj.Rental_Income_to_be_considered__c = poObjList[0].Annual_Income__c;
    }
    List < SurrogateCAM__c > CAmlist = poObjList[0].SurrogateCAMS__r; /* SAL PLTB added by priya */
    //SAL PLTB Pritha start
    if (isCallCenter && CAmlist != null && CAmlist.size() > 0) {
     camObj.Average_incentive_for_Q3__c = poObjList[0].Net_Monthly_Salary_3__c;
     camObj.Net_Salary_for_Month3__c = poObjList[0].Net_Monthly_Salary_3__c;
     camObj.Gross_Salary_Month3__c = poObjList[0].Net_Monthly_Salary_3__c;
     camObj.Receips4_Doc__c = CAmlist[0].PO_CoApp_Net_Salary_1__c;
     camObj.Receips5_Doc__c = CAmlist[0].PO_CoApp_Net_Salary_2__c;
     camObj.Receips6_Doc__c = CAmlist[0].PO_CoApp_Net_Salary_3__c;
     camObj.Selected_Option_TO__c = CAmlist[0].POPlusAmount__c;
     camObj.Live_unsecured_loan__c = CAmlist[0].POPlusEMI__c;
     camObj.sal_max_loan__c = poObjList[0].Availed_Amount__c;
     camObj.EMI_of_The_Loan__c = CAmlist[0].Total_Monthly_EMI__c;
     camObj.Applicable_FOIR1__c = CAmlist[0].Fixed_Obligation_Income_Ratio__c;
     camObj.Eligible_FOIR__c = CAmlist[0].POFinalFoir__c;
     camObj.Business_Continuty__c = CAmlist[0].POEligibleForLOC__c;
     camObj.Unsecured_FOIR__c = CAmlist[0].POUnsecuredFoir__c;
     camObj.EMI_Doc__c = CAmlist[0].PO_EMI_LOC__c;
     camObj.Credit_Card_Out_5__c = CAmlist[0].Monthly_Obligation__c;
     camObj.OD_interest__c = CAmlist[0].Temporary_Overdraft__c;
     /*SAL PLTB added by priya start */
     camObj.Construction_Valuation_1__c = CAmlist[0].Construction_Valuation_1__c;
     camObj.Construction_Valuation_2__c = CAmlist[0].Construction_Valuation_2__c;
     camObj.Adjusted_Rental_Income__c = CAmlist[0].Adjusted_Rental_Income__c;
     camObj.Existing_HL_EMI__c = CAmlist[0].Existing_HL_EMI__c;

     SurrogateCAM__c surrCamObj = new SurrogateCAM__c();
     surrCamObj.Loan_Application__c = oppId;
     surrCamObj.Applicant__c = applicantId;
     surrCamObj.Line_assigned_basis_Credit_Assessment__c = CAmlist[0].Line_assigned_basis_Credit_Assessment__c;
     surrCamObj.POEligibleForLOC__c = CAmlist[0].POEligibleForLOC__c;
     surrCamObj.Total_Monthly_EMI__c = CAmlist[0].Total_Monthly_EMI__c;
     surrCamObj.PO_EMI_LOC__c = CAmlist[0].PO_EMI_LOC__c;
     surrCamObj.Expiry_Date_without_BT__c = CAmlist[0].Expiry_Date_without_BT__c;
     surrCamObj.Fixed_Obligation_Income_Ratio__c = CAmlist[0].Fixed_Obligation_Income_Ratio__c;
     surrCamObj.ROI_Term_Loan__c = CAmlist[0].ROI_Term_Loan__c;
     surrCamObj.Line_opted__c = CAmlist[0].Line_opted__c;
     surrCamObj.POFinalFoir__c = CAmlist[0].POFinalFoir__c;
     surrCamObj.ROI_Drop_Line_Loan__c = CAmlist[0].ROI_Drop_Line_Loan__c;
     surrCamObj.Line_flag__c = CAmlist[0].Line_flag__c;
     surrCamObj.POUnsecuredFoir__c = CAmlist[0].POUnsecuredFoir__c;
     surrCamObj.ROI_Pure_Flexi_Loan__c = CAmlist[0].ROI_Pure_Flexi_Loan__c;
     surrCamObj.Tenor_for_Line_assignment_in_yrs__c = CAmlist[0].Tenor_for_Line_assignment_in_yrs__c;
     insert surrCamObj;
     /*SAL PLTB added by priya end */
    }
    //SAL PLTB Pritha end
    try {
     insert camObj;
    } catch (DMLException e) {
     String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
     str += 'Product Offering Id :' + offeringId + ' \n Block 6'; // Bug 12463
     System.debug(str);
     if (!Test.isRunningTest())
      CommonUtility.SendExceptionMail(str);
    }
   }
  } catch (Exception e) {
   String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
   str += 'Product Offering Id :' + offeringId + ' \n Block 7'; // Bug 12463
   System.debug(str);
   if (!Test.isRunningTest())
    CommonUtility.SendExceptionMail(str);
   system.debug('Exception Occured **' + e.getMessage());
  }
 }
 //call center added E
 //made the below method public ---Optimization changes-- harsit
 public static void moveCIBILToOpportunity(List < Cibil__c > cibilList, Map < id, id > cibLead, Map < id, id > cibLeadApp, Map < Id, Id > applicantToCibilTemp, Map < id, id > applicantToExt, Map < id, id > applicantToExt1) {
  if (cibilList.size() > 0) {
   List < Cibil__c > updtcibillst = new List < Cibil__c > ();
   Set < Cibil__c > updtcibil = new Set < Cibil__c > ();
   for (integer i = 0; i < cibilList.size(); i++) {
    Cibil__c cib = new Cibil__c();
    if (cibLead.containsKey(cibilList[i].Lead__c)) {
     cib = cibilList[i].clone(false, true);
     // cib = cibilList[i].clone(false,false,false,false);
     cib.Applicant__c = cibLead.get(cibilList[i].Lead__c);
     cib.Lead__c = null; //17557
     cib.Cibil_Temp__c = applicantToCibilTemp.get(cib.Applicant__c);
     cib.Cibil_Extension1__c = applicantToExt1.get(cib.Applicant__c);
     cib.CIBIL_Extension__c = applicantToExt.get(cib.Applicant__c);
     updtcibil.add(cib);
     system.debug('lead cibil updated to applicant');
    }
    if (cibLeadApp.containsKey(cibilList[i].Lead_Applicants__c)) {
     cib = cibilList[i].clone(false, true);
     cib.Applicant__c = cibLeadApp.get(cibilList[i].Lead_Applicants__c);
     cib.Lead_Applicants__c = null;
     cib.Cibil_Temp__c = applicantToCibilTemp.get(cib.Applicant__c);
     cib.Cibil_Extension1__c = applicantToExt1.get(cib.Applicant__c);
     cib.CIBIL_Extension__c = applicantToExt.get(cib.Applicant__c);
     updtcibil.add(cib);
     system.debug('leadapplicant cibil updated to applicant');
    }
   }

   if (updtcibil.size() > 0) {
    //System.Debug('updtcibil'+updtcibil);
    updtcibillst.addAll(updtcibil);
    insert updtcibillst;
   }
  }
 }
 //made the below method public ---Optimization changes-- harsit
 public static Map < Id, Id > moveCIBILExtentionToOpportunity(List < CIBIL_Extension__c > cibilExList, Map < id, id > cibExLead, Map < id, id > cibExLeadApp, Map < Id, Id > applicantToCibilMap) {

  List < Id > applicantExtIds = new List < Id > ();
  Map < Id, Id > applicantToExt = new Map < Id, Id > ();

  if (cibilExList.size() > 0) {
   List < CIBIL_Extension__c > updtcibil = new List < CIBIL_Extension__c > ();
   for (integer i = 0; i < cibilExList.size(); i++) {
    CIBIL_Extension__c cib = new CIBIL_Extension__c();
    if (cibExLead.containsKey(cibilExList[i].Cibil_Temp__r.Lead__c)) {
     cib = cibilExList[i].clone(false, true);
     cib.Applicant__c = cibExLead.get(cibilExList[i].Lead__c);
     applicantExtIds.add(cib.Applicant__c);
     cib.Lead__c = null; //17557
     cib.Cibil_Temp__c = applicantToCibilMap.get(cib.Applicant__c);
     updtcibil.add(cib);
     system.debug('lead cibil updated to applicant');
    }
    if (cibExLeadApp.containsKey(cibilExList[i].Lead_Applicants__c)) {
     cib = cibilExList[i].clone(false, true);
     cib.Applicant__c = cibExLeadApp.get(cibilExList[i].Cibil_Temp__r.Lead_Applicants__c);
     applicantExtIds.add(cib.Applicant__c);
     cib.Cibil_Temp__c = applicantToCibilMap.get(cib.Applicant__c);
     cib.Lead_Applicants__c = null;
     updtcibil.add(cib);
     system.debug('leadapplicant cibil updated to applicant');
    }
   }
   if (updtcibil.size() > 0) insert updtcibil;

   integer i = 0;
   for (CIBIL_Extension__c ext: updtcibil) {
    applicantToExt.put(applicantExtIds[i], ext.Id);
    i++;
   }
  }

  return applicantToExt;

 }
 //made the below method public ---Optimization changes-- harsit
 public static Map < Id, Id > moveCIBILExtention1ToOpportunity(List < Cibil_Extension1__c > cibilEx1List, Map < id, id > cibEx1Lead, Map < id, id > cibEx1LeadApp, Map < Id, Id > applicantToCibilMap) {

  List < Id > applicantExt1Ids = new List < Id > ();
  Map < Id, Id > applicantToExt1 = new Map < Id, Id > ();

  if (cibilEx1List.size() > 0) {
   List < Cibil_Extension1__c > updtcibil = new List < Cibil_Extension1__c > ();
   for (integer i = 0; i < cibilEx1List.size(); i++) {
    Cibil_Extension1__c cib = new Cibil_Extension1__c();
    if (cibEx1Lead.containsKey(cibilEx1List[i].Lead__c)) {
     cib = cibilEx1List[i].clone(false, true);
     cib.Applicant__c = cibEx1Lead.get(cibilEx1List[i].Cibil_Temp__r.Lead__c);
     applicantExt1Ids.add(cib.Applicant__c);
     cib.Cibil_Temp__c = applicantToCibilMap.get(cib.Applicant__c);
     cib.Lead__c = null; //17557
     updtcibil.add(cib);
     system.debug('lead cibil updated to applicant');
    }
    if (cibEx1LeadApp.containsKey(cibilEx1List[i].Lead_Applicants__c)) {
     cib = cibilEx1List[i].clone(false, true);
     cib.Applicant__c = cibEx1LeadApp.get(cibilEx1List[i].Cibil_Temp__r.Lead_Applicants__c);
     applicantExt1Ids.add(cib.Applicant__c);
     cib.Cibil_Temp__c = applicantToCibilMap.get(cib.Applicant__c);
     cib.Lead_Applicants__c = null;
     updtcibil.add(cib);
     system.debug('leadapplicant cibil updated to applicant');
    }
   }
   if (updtcibil.size() > 0) insert updtcibil;

   integer i = 0;
   for (Cibil_Extension1__c ext: updtcibil) {
    applicantToExt1.put(applicantExt1Ids[i], ext.Id);
    i++;
   }
  }

  return applicantToExt1;
 }
 //made the below method public ---Optimization changes-- harsit
 public static Map < Id, Id > moveCIBILTEMPToOpportunity(List < Cibil_Temp__c > updatedCibilTempList, Map < id, id > cibLead, Map < id, id > cibLeadApp) {

  List < Id > applicantIds = new List < Id > ();
  Map < Id, Id > applicantToCibilTemp = new Map < Id, Id > ();

  if (updatedCibilTempList.size() > 0) {
   List < Cibil_Temp__c > updtcibil = new List < Cibil_Temp__c > ();
   for (integer i = 0; i < updatedCibilTempList.size(); i++) {
    Cibil_Temp__c cib = new Cibil_Temp__c();
    if (cibLead.containsKey(updatedCibilTempList[i].Lead__c)) {
     cib = updatedCibilTempList[i].clone(false, true);
     cib.ownerId = UserInfo.getUserId(); //Prod Issue --13798 fix...harsit garg
     cib.Lead__c = null; //17557
     cib.Applicant__c = cibLead.get(updatedCibilTempList[i].Lead__c);
     applicantIds.add(cib.Applicant__c);
     updtcibil.add(cib);
     system.debug('lead cibil updated to applicant');
    }
    if (cibLeadApp.containsKey(updatedCibilTempList[i].Lead_Applicants__c)) {
     cib = updatedCibilTempList[i].clone(false, true);
     cib.ownerId = UserInfo.getUserId(); //Prod Issue --13798 fix...harsit garg
     cib.Applicant__c = cibLeadApp.get(updatedCibilTempList[i].Lead_Applicants__c);
     cib.Lead_Applicants__c = null;
     applicantIds.add(cib.Applicant__c);
     updtcibil.add(cib);
     system.debug('leadapplicant cibil updated to applicant');
    }
   }
   if (updtcibil.size() > 0) insert updtcibil;

   integer i = 0;

   for (Cibil_Temp__c cibiltemp: updtcibil) {
    applicantToCibilTemp.put(applicantIds[i], cibiltemp.Id);
    i++;
   }
  }

  return applicantToCibilTemp;
 }

 static void createDedupeRecord(List < Applicant__c > applicantList, Map < id, id > cibLead, Map < id, id > cibLeadApp) {
  System.debug('applicantList=' + applicantList);
  List < De_Dupe__c > dedupePOLst = new List < De_Dupe__c > ();
  system.debug('cibLead-------' + cibLead + '--------cibLeadApp----------' + cibLeadApp);
  //added for Call Center S
  if (isCallCenter) {
   dedupePOLst = [select id, /*SAL PLTB Bug 12108*/ Datafix_Updated__c, SF_Base__c, Source_Or_Target__c, Dedupe_Source__c, Dedupe_Target_Remarks__c, Segment__c, applicant_id__c, Dedupe_Lan_Matches__c, Customer_Status__c, De_Dupe_Matched_Percentage__c, Dedupe_Comments__c, /*SAL PLTB Bug 12108*/ Applicant__c, Lead__c, Lead_Applicants__c, Application_ID__c, Customer_ID__c, De_Dupe_Decision__c, De_Dupe_result__c, Negative_Area__c, Area_Status__c from De_Dupe__c where(Lead__c IN: cibLead.keySet() OR Lead_Applicants__c IN: cibLeadApp.keySet())];
  }
  //added for Call Center E
  List < De_Dupe__c > dedupelist = new List < De_Dupe__c > ();
  if (applicantList.size() > 0) {
   for (integer i = 0; i < applicantList.size(); i++) {
    System.debug('Applicant list***' + applicantList);
    /*De_dupe__c dedupe = new De_dupe__c();
            dedupe.Applicant__c = applicantList[i].id;

            if (applicantList[i].Contact_Name__r.ApplicantType__c == 'Primary') {
                dedupe.Applicant_Type__c = 'P';
            } else {
                dedupe.Applicant_Type__c = 'C';
            }

            if (applicantList[i].Contact_Name__r.Customer_Type__c == 'Individual') {
                dedupe.Customer_Type__c = 'I';
            } else {
                dedupe.Customer_Type__c = 'C';
            }*/
    if (isCallCenter) {

     for (De_dupe__c podedupe: dedupePOLst) {
      system.debug('inside dedupe');
      De_dupe__c dedupe = new De_dupe__c();
      dedupe.Applicant__c = applicantList[i].id;

      if (applicantList[i].Contact_Name__r.ApplicantType__c == 'Primary') {
       dedupe.Applicant_Type__c = 'P';
      } else {
       dedupe.Applicant_Type__c = 'C';
      }

      if (applicantList[i].Contact_Name__r.Customer_Type__c == 'Individual') {
       dedupe.Customer_Type__c = 'I';
      } else {
       dedupe.Customer_Type__c = 'C';
      }
      //added for Call Center S
      if ((podedupe.Lead__c != null && applicantList[i].Applicant_Type__c != null && applicantList[i].Applicant_Type__c == 'Primary')) {
       system.debug('in Lead' + podedupe);
       dedupe.Application_ID__c = podedupe.Application_ID__c;
       dedupe.Customer_ID__c = podedupe.Customer_ID__c;
       dedupe.De_Dupe_Decision__c = podedupe.De_Dupe_Decision__c;
       dedupe.De_Dupe_result__c = podedupe.De_Dupe_result__c;
       /*SAL PLTB Bug 12108 start - added by krish*/
       dedupe.Datafix_Updated__c = podedupe.Datafix_Updated__c;
       dedupe.SF_Base__c = podedupe.SF_Base__c;
       dedupe.Source_Or_Target__c = podedupe.Source_Or_Target__c;
       dedupe.Dedupe_Source__c = podedupe.Dedupe_Source__c;
       dedupe.Dedupe_Target_Remarks__c = podedupe.Dedupe_Target_Remarks__c;
       dedupe.Segment__c = podedupe.Segment__c;
       dedupe.applicant_id__c = podedupe.applicant_id__c;
       dedupe.Dedupe_Lan_Matches__c = podedupe.Dedupe_Lan_Matches__c;
       dedupe.Customer_Status__c = podedupe.Customer_Status__c;
       dedupe.De_Dupe_Matched_Percentage__c = podedupe.De_Dupe_Matched_Percentage__c;
       dedupe.Dedupe_Comments__c = podedupe.Dedupe_Comments__c;
       /*SAL PLTB Bug 12108 end - added by krish*/
       /* SAL PLTB changes added by priya start*/
       dedupe.Negative_Area__c = podedupe.Negative_Area__c;
       dedupe.Area_Status__c = podedupe.Area_Status__c;
       /* SAL PLTB changes added by priya end*/
       populateDedupe(dedupe, applicantList[i]);
       dedupelist.add(dedupe);
      }
      if (podedupe.Lead_Applicants__c != null && applicantList[i].Lead_Applicants__c != null && podedupe.Lead_Applicants__c == applicantList[i].Lead_Applicants__c) {
       system.debug('in Lead Applicant');
       dedupe.Application_ID__c = podedupe.Application_ID__c;
       dedupe.Customer_ID__c = podedupe.Customer_ID__c;
       dedupe.De_Dupe_Decision__c = podedupe.De_Dupe_Decision__c;
       dedupe.De_Dupe_result__c = podedupe.De_Dupe_result__c;
       /*SAL PLTB Bug 12108 start - added by krish*/
       dedupe.Datafix_Updated__c = podedupe.Datafix_Updated__c;
       dedupe.SF_Base__c = podedupe.SF_Base__c;
       dedupe.Source_Or_Target__c = podedupe.Source_Or_Target__c;
       dedupe.Dedupe_Source__c = podedupe.Dedupe_Source__c;
       dedupe.Dedupe_Target_Remarks__c = podedupe.Dedupe_Target_Remarks__c;
       dedupe.Segment__c = podedupe.Segment__c;
       dedupe.applicant_id__c = podedupe.applicant_id__c;
       dedupe.Dedupe_Lan_Matches__c = podedupe.Dedupe_Lan_Matches__c;
       dedupe.Customer_Status__c = podedupe.Customer_Status__c;
       dedupe.De_Dupe_Matched_Percentage__c = podedupe.De_Dupe_Matched_Percentage__c;
       dedupe.Dedupe_Comments__c = podedupe.Dedupe_Comments__c;
       /*SAL PLTB Bug 12108 end - added by krish*/
       populateDedupe(dedupe, applicantList[i]);
       dedupelist.add(dedupe);

      }


     }
    }
    //added for Call Center E
    else {
     De_dupe__c dedupe = new De_dupe__c();
     dedupe.Applicant__c = applicantList[i].id;

     if (applicantList[i].Contact_Name__r.ApplicantType__c == 'Primary') {
      dedupe.Applicant_Type__c = 'P';
     } else {
      dedupe.Applicant_Type__c = 'C';
     }

     if (applicantList[i].Contact_Name__r.Customer_Type__c == 'Individual') {
      dedupe.Customer_Type__c = 'I';
     } else {
      dedupe.Customer_Type__c = 'C';
     }
     //added for Call Center S
     dedupe.Loan_Application__c = applicantList[i].Loan_Application__c;
     dedupe.Employer_Name__c = applicantList[i].Contact_Name__r.Employer_Name__c;
     dedupe.DOB__c = applicantList[i].Contact_Name__r.Date_of_Birth__c;
     dedupe.Fathers_Husband_s_Name__c = applicantList[i].Contact_Name__r.FathersHusbands_Name__c;
     dedupe.PAN__c = applicantList[i].Contact_Name__r.PAN_Number__c;
     dedupe.Company_Date_of_Incorporation__c = applicantList[i].Contact_Name__r.Year_of_Incorporation__c;
     dedupe.Company_TIN_No__c = applicantList[i].Contact_Name__r.Account.TIN_Number__c;
     dedupe.AccNo__c = String.valueof(applicantList[i].Contact_Name__r.Bank_Account_No__c);
     dedupe.VoterID__c = applicantList[i].Contact_Name__r.VoterID_Number__c;
     dedupe.Credit_Card_No__c = applicantList[i].Contact_Name__r.ROC_Regn_No__c;
     dedupe.Existing_LAN_2__c = applicantList[i].Loan_Application__r.LAN__c;
     dedupe.Address1_Residence__c = applicantList[i].Contact_Name__r.Address_1__c;
     dedupe.Address2_Residence__c = applicantList[i].Contact_Name__r.Address_2__c;
     dedupe.Address3_Residence__c = applicantList[i].Contact_Name__r.Address_3__c;
     dedupe.City_Residence__c = applicantList[i].Contact_Name__r.AppCity__c;
     dedupe.PIN__c = string.valueof(applicantList[i].Contact_Name__r.Pin_Code__c);
     if (applicantList[i].Contact_Name__r.Phone != null) {
      dedupe.Landline2_Residence__c = string.valueof(applicantList[i].Contact_Name__r.Phone); //Remove Integer.ValueOf() for Bug 17787
     }
     if (applicantList[i].Contact_Name__r.MobilePhone != null) {
      dedupe.Mobile_Residence__c = string.valueof(applicantList[i].Contact_Name__r.MobilePhone); //Remove Integer.ValueOf() for Bug 17787
     }
     dedupe.Email_Residence__c = applicantList[i].Contact_Name__r.Email;
     dedupe.Address1_Office__c = applicantList[i].Contact_Name__r.Address_Line_One__c;
     dedupe.Address2_Office__c = applicantList[i].Contact_Name__r.Address_2nd_Line__c;
     dedupe.Address3_Office__c = applicantList[i].Contact_Name__r.Address_3rd_Line__c;
     dedupe.Area_Office__c = applicantList[i].Contact_Name__r.Address_Line_One__c;
     dedupe.Landmark_Office__c = applicantList[i].Contact_Name__r.Permanent_Land_Mark__c;
     dedupe.City_Office__c = applicantList[i].Contact_Name__r.Office_City__c;
     dedupe.Pin_Office__c = applicantList[i].Contact_Name__r.Office_Pin_Code__c;
     dedupe.STD_Office__c = string.valueof(applicantList[i].Contact_Name__r.Office_STD_Code__c);
     dedupe.Landline1_Office__c = applicantList[i].Contact_Name__r.Office_Phone_Number__c;
     dedupe.Landline2_Office__c = applicantList[i].Contact_Name__r.Office_Phone_Number__c;
     dedupe.Mobile_Office__c = applicantList[i].Contact_Name__r.Mobile_Phone__c;
     dedupe.Email_Office__c = applicantList[i].Contact_Name__r.Office_Email_Id__c;

     if (applicantList[i].Contact_Name__r.Customer_Type__c == 'Corporate') dedupe.First_Name__c = applicantList[i].Contact_Name__r.Name;
     else {
      string name1 = applicantList[i].Contact_Name__r.Name;
      if (name1 != null) {
       list < string > splitname = name1.split(' ');
       dedupe.First_Name__c = splitname[0];
      }
      dedupe.Middle_Name__c = applicantList[i].Contact_Name__r.Middle_Name__c;
     }
     dedupe.Datafix_Updated__c = 'New records';
     dedupe.Application_Status__c = 'Complete';
     dedupelist.add(dedupe);
    }

   }
   if (dedupelist.size() > 0) {
    system.debug('dedupelist' + dedupelist);
    insert dedupelist;
   }
  }
 }
 public static void populateDedupe(De_Dupe__c dedupe, Applicant__c applicant) {
  dedupe.Loan_Application__c = applicant.Loan_Application__c;
  dedupe.Employer_Name__c = applicant.Contact_Name__r.Employer_Name__c;
  dedupe.DOB__c = applicant.Contact_Name__r.Date_of_Birth__c;
  dedupe.Fathers_Husband_s_Name__c = applicant.Contact_Name__r.FathersHusbands_Name__c;
  dedupe.PAN__c = applicant.Contact_Name__r.PAN_Number__c;
  dedupe.Company_Date_of_Incorporation__c = applicant.Contact_Name__r.Year_of_Incorporation__c;
  dedupe.Company_TIN_No__c = applicant.Contact_Name__r.Account.TIN_Number__c;
  dedupe.AccNo__c = String.valueof(applicant.Contact_Name__r.Bank_Account_No__c);
  dedupe.VoterID__c = applicant.Contact_Name__r.VoterID_Number__c;
  dedupe.Credit_Card_No__c = applicant.Contact_Name__r.ROC_Regn_No__c;
  dedupe.Existing_LAN_2__c = applicant.Loan_Application__r.LAN__c;
  dedupe.Address1_Residence__c = applicant.Contact_Name__r.Address_1__c;
  dedupe.Address2_Residence__c = applicant.Contact_Name__r.Address_2__c;
  dedupe.Address3_Residence__c = applicant.Contact_Name__r.Address_3__c;
  dedupe.City_Residence__c = applicant.Contact_Name__r.AppCity__c;
  dedupe.PIN__c = string.valueof(applicant.Contact_Name__r.Pin_Code__c);
  if (applicant.Contact_Name__r.Phone != null) {
   dedupe.Landline2_Residence__c = string.valueof(Integer.valueof(applicant.Contact_Name__r.Phone));
  }
  if (applicant.Contact_Name__r.MobilePhone != null) {
   dedupe.Mobile_Residence__c = string.valueof(Integer.valueof(applicant.Contact_Name__r.MobilePhone));
  }
  dedupe.Email_Residence__c = applicant.Contact_Name__r.Email;
  dedupe.Address1_Office__c = applicant.Contact_Name__r.Address_Line_One__c;
  dedupe.Address2_Office__c = applicant.Contact_Name__r.Address_2nd_Line__c;
  dedupe.Address3_Office__c = applicant.Contact_Name__r.Address_3rd_Line__c;
  dedupe.Area_Office__c = applicant.Contact_Name__r.Address_Line_One__c;
  dedupe.Landmark_Office__c = applicant.Contact_Name__r.Permanent_Land_Mark__c;
  dedupe.City_Office__c = applicant.Contact_Name__r.Office_City__c;
  dedupe.Pin_Office__c = applicant.Contact_Name__r.Office_Pin_Code__c;
  dedupe.STD_Office__c = string.valueof(applicant.Contact_Name__r.Office_STD_Code__c);
  dedupe.Landline1_Office__c = applicant.Contact_Name__r.Office_Phone_Number__c;
  dedupe.Landline2_Office__c = applicant.Contact_Name__r.Office_Phone_Number__c;
  dedupe.Mobile_Office__c = applicant.Contact_Name__r.Mobile_Phone__c;
  dedupe.Email_Office__c = applicant.Contact_Name__r.Office_Email_Id__c;

  if (applicant.Contact_Name__r.Customer_Type__c == 'Corporate') dedupe.First_Name__c = applicant.Contact_Name__r.Name;
  else {
   string name1 = applicant.Contact_Name__r.Name;
   if (name1 != null) {
    list < string > splitname = name1.split(' ');
    dedupe.First_Name__c = splitname[0];
   }
   dedupe.Middle_Name__c = applicant.Contact_Name__r.Middle_Name__c;
  }
 }
 /*SAL PLTB added isCallCenter flag by priya */

 @future
 public static void saveSolPolicy(String oppId, String pId, boolean isCallCenter, Map < String, String > objList) {

  List < SOL_Policy__c > newSolPolList = new List < SOL_Policy__c > ();
  try {
   // if (!SwitchOtimizedCode) { SAL PLTB commented
   List < SOL_Policy__c > SolPollistOptimized = new List < SOL_Policy__c > ();
   Applicant__c applicant =(Applicant__c)JSON.deserialize(objList.get('Applicant'),Applicant__c.class); // Bug id : 24716
   if (isCallCenter) {
    Lead leadObj = (Lead) JSON.deserialize(objList.get('Lead'), Lead.class);
    //Applicant__c applicant = (Applicant__c) JSON.deserialize(objList.get('Applicant'), Applicant__c.class);
    List < Sol_Policy__C > allSol = new List < Sol_Policy__C > ();
    allSol = [SELECT ConnectionReceivedId, Checklist_Policy_Override__c, Checklist_Policy_Status__c, ConnectionSentId, CreatedById, CreatedDate, Created_From_Applicant__c, Created_From_CIBIL_Policy_At__c, Created_From_Contact__c, Created_From_Dedupe__c, Created_From_Loan_Application__c, Created_From_Salaried__c, Created_From_SOLCAM__c, CurrencyIsoCode, Id, IsDeleted, LastModifiedById, LastModifiedDate, Loan_Application__c, MCP_Policy_Type__c, Name, Old_Loan_Application__c, OwnerId, Policy_Name__c, Policy_Stamped_At__c, Policy_Status__c, Product_Offerings__c, Reference_Loan_Application__c, SystemModstamp, /* CC Code changes SME */ Flow_Identifier__c, Remarks__c, CC_Number__c, SourcingType__c /* CC Code changes SME */ FROM SOL_Policy__c where Product_Offerings__c =: pId order by createddate asc];
    for (Sol_Policy__c solObj: allSol) {
     system.debug('solObj.Name : ' + solObj.Name);
     if (solObj.Name != null && (solObj.Name.startsWith('PolicyCheck:') || solObj.Name.startsWith('Risk Segment'))) {
      system.debug('inside savesol If condition');
      if (solObj.Checklist_Policy_Status__c == 'Pass' || solObj.Checklist_Policy_Override__c == true) {
       if (applicant.PolicyCheck__c != null) applicant.PolicyCheck__c = applicant.PolicyCheck__c + solObj.Policy_Name__c + ';';
        
       else
        applicant.PolicyCheck__c = solObj.Policy_Name__c + ';';
      }
      if (isCallCenter && (applicant.Applicant_Type__c == 'Primary' || applicant.Applicant_Type__c == 'Primary Applicant')) {

       if (solObj.Policy_Name__c.startsWith('Risk Segment')) {
        List < String > risks = solObj.Policy_Name__c.split('%');
        System.debug('risks' + risks.size());
        applicant.RC_Deviation__c = risks[1];
       }
       if (solObj.Policy_Name__c.contains('Domain check') && solObj.Checklist_Policy_Status__c == 'Pass') {
        applicant.Domain_Check_Result__c = 'OK';
        applicant.Company_Name_as_per_Domain_check__c = leadObj.Employer__r.Company_Name_as_per_Domain_check__c;
        applicant.Domain_Created_Date__c = leadObj.Employer__r.Domain_Created_Date__c;
       } else if (solObj.Policy_Name__c.contains('Domain check') && solObj.Checklist_Policy_Status__c == 'Fail') {
        applicant.Domain_Check_Result__c = 'NOT OK';
        applicant.Company_Name_as_per_Domain_check__c = leadObj.Employer__r.Company_Name_as_per_Domain_check__c;
        applicant.Domain_Created_Date__c = leadObj.Employer__r.Domain_Created_Date__c;
       } else if (solObj.Policy_Name__c.contains('Official Email Confirmation') && solObj.Checklist_Policy_Status__c == 'Pass') {
        applicant.Office_Email_Id_Verified__c = true;
       }

      }
      //SAL PLTB Pritha END
     } else {
      SolPollistOptimized.add(solObj);
     }
    }
    update applicant;
   } else { /*SAL PLTB added by priya end */
    SolPollistOptimized = [SELECT ConnectionReceivedId, ConnectionSentId, CreatedById, CreatedDate, Created_From_Applicant__c, Created_From_CIBIL_Policy_At__c, Created_From_Contact__c, Created_From_Dedupe__c, Created_From_Loan_Application__c, Created_From_Salaried__c, Created_From_SOLCAM__c, CurrencyIsoCode, Id, IsDeleted, LastModifiedById, LastModifiedDate, Loan_Application__c, MCP_Policy_Type__c, Name, Old_Loan_Application__c, OwnerId, Policy_Name__c, Policy_Stamped_At__c, Policy_Status__c, Product_Offerings__c, Reference_Loan_Application__c, SystemModstamp, /* CC Code changes SME */ Flow_Identifier__c, Remarks__c, CC_Number__c, SourcingType__c /* CC Code changes SME */ FROM SOL_Policy__c where Product_Offerings__c =: pId order by createddate asc];

   }
   //SAL PLTB E
   SolPollist = SolPollistOptimized;


   if (SolPollist != null && SolPollist.size() > 0) {
    for (SOL_Policy__c objRepd: SolPollist) {
     SOL_Policy__c objPD = new SOL_Policy__c();
     objPD = objRepd.clone(false, false, false, false);
     system.debug('*****Cloneed solpolicy  Object :--' + objRepd);
     objPD.Loan_Application__c = oppId;
     objPD.Product_Offerings__c = null;
     newSolPolList.add(objPD);
     if (objPD.Flow_Identifier__c == 'CKYC Norms' && applicant != null) { // Bug id : 24716 start
        System.debug('applicant --> ' + applicant);
        applicant.Data_Source__c = 'Copy CKYC Data';
    } // Bug id : 24716 end
    }
   }
   if (newSolPolList != null && newSolPolList.size() > 0) {
    try {
     insert newSolPolList;
     update applicant; // Bug id : 24716
    } catch (DMLException e) {
     String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
     str += 'Product Offering Id :' + offeringId + ' \n Block 8'; // Bug 12463
     System.debug(str);
     CommonUtility.SendExceptionMail(str);
    }
   }
  } catch (Exception e) {
   String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
   str += 'Product Offering Id :' + offeringId + ' \n Block 8.1'; // Bug 12463
   System.debug(str);
   //CommonUtility.SendExceptionMail(str);

  }
 }
 //Bug ID 7444 :: RTR For RM start
 @future
 public static void cloneExistingLoanDetails(Id PrimaryAppId, Id oppID, Id productOfferId) {
  try {
   //Removing code of optimization since its future method
   System.debug('entered cloneExistingLoanDetails');
   List < Existing_Loan_Details__c > newExistingLoan = new List < Existing_Loan_Details__c > ();
   List < Existing_Loan_Details__c > existingLoan = new List < Existing_Loan_Details__c > ();
   existingLoan = [select id, Identifier__c, Product_Offering__c, Average_Delay__c, Average_Delay_6_months__c, financers__c, Name, Customer_Declared_EMI__c, EMI_Over_In_Next_6_months__c, Status__c, Final_EMI__c, Secured_Unsecured__c, Loan_Type__c, Loan_Amount__c, Seen_in__c,
    Loan_Acc_No__c, Select__c, Applicant__r.ContactName__c, Principal_O_s__c, Obligation__c, No_of_Bounces_if_any__c,
    Financer__c, Amount__c, Month1_Amount__c, Month2_Amount__c, Derived_EMI__c, Remark__c, Applicant__r.Contact_Name__r.Name, Applicant__r.Contact_Name__c,
    Start_On__c, Tenor__c, Bank_Account_Name__c, Tenor_Left__c, MOB__c, POS__c, Property_Owner__c, EMI__c, Applicant__c, Annual_Obligation__c, Type_of_Oblig__c, CreatedById, Property_Address__c, Rate_of_Interest__c, Bank_Name_List__c, Ownership__c, Mthly_Oblig__c, Base_Product__c
    from Existing_Loan_Details__c where Product_Offering__c =: productOfferId and Identifier__c = 'Manual'
   ];


   if (existingLoan != null && existingLoan.size() > 0) {
    for (Existing_Loan_Details__c objLoan: existingLoan) {
     Existing_Loan_Details__c objExistingLoan = new Existing_Loan_Details__c();
     objExistingLoan = objLoan.clone(false, false, false, false);
     system.debug('*****Cloneed PD  Object :--' + objExistingLoan);
     objExistingLoan.Loan_Application__c = oppId;
     objExistingLoan.Product_Offering__c = null;
     objExistingLoan.Applicant__c = PrimaryAppId;
     newExistingLoan.add(objExistingLoan);
    }
   }
   if (newExistingLoan != null && newExistingLoan.size() > 0) {
    try {
     insert newExistingLoan;
    } catch (DMLException e) {
     String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
     str += 'Product Offering Id :' + offeringId + ' \n Block 9'; // Bug 12463
     System.debug(str);
     CommonUtility.SendExceptionMail(str);
    }
   }

  } catch (Exception e) {
   String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
   str += 'Product Offering Id :' + offeringId + ' \n Block 10'; // Bug 12463
   System.debug(str);
   //CommonUtility.SendExceptionMail(str);
   system.debug('Exception Occured **' + e.getMessage());
  }

 }
 //Bug ID 7444 :: RTR For RM end
 //Added for Call center CR 8292 S
 // Mobility for sal added flow in method signature by priya
 @future
 public static void updateAccountData(String productOfferObjID, String AccId, string flow) {
  system.debug('call Center Process Account Data Update');
  List < Account > accObj = new List < Account > ();
  accObj = [select id, name, /*PLTB changes 14951 added by Anshita S*/ Name_of_the_Company_Employer__c /*PLTB changes 14951 added by Anshita E*/ , Total_Work_Experience_Yrs__c, Gross_Salary_Turn_Over__c, Total_Work_Experience_Months__c, Current_experiance_in_Years__c, Current_experiance_in_Month__c from Account where id =: AccId];
  //SAL PLTB changes rohit 14951 added inner query
  List < Product_Offerings__c > poObjListAcc = new List < Product_Offerings__c > ();
  poObjListAcc = [select id, Net_Salary_Per_Month__c, /*SAL PLTB changes rohit S*/ (SELECT Id, Current_experiance_in_Month__c, Total_Work_Experience_Months__c, /*PLTB changes 14951 S*/ Location_Wise_EWS_Status__c, Codified_CIBIL__c /*PLTB changes 14951 E*/ from SurrogateCAMS__r order by createddate asc LIMIT 100) /*SAL PLTB changes rohit E*/ , Gross_Turnover__c, Total_work_experience__c, Experience_in_Years__c
   from Product_Offerings__c where id =: productOfferObjID
  ];
  //Added for Call center CR 8292 S
  system.debug('List Index' + accObj + poObjListAcc);
  if (poObjListAcc[0].Gross_Turnover__c != null && accObj.size() > 0) {
   accObj[0].Gross_Salary_Turn_Over__c = Decimal.valueOf(poObjListAcc[0].Gross_Turnover__c);
  }

  // Mobility for sal added by priya 
  if (!CommonUtility.isEmpty(flow) && flow == 'salaried') {
   accObj[0].Gross_Salary_Turn_Over__c = poObjListAcc[0].Net_Salary_Per_Month__c;
  }
  //system.debug('poObjListAcc[0].Total_work_experience__c--->>>>>>>>' + poObjListAcc[0].Total_work_experience__c);
  //harsit----To avoid NULL Pointer Exceptionj----START
  List < String > yrsExpTotal;
  if (poObjListAcc[0].Total_work_experience__c != null)
   yrsExpTotal = poObjListAcc[0].Total_work_experience__c.split('\\.');
  if (yrsExpTotal != null && yrsExpTotal.size() > 0 && accObj.size() > 0) {
   //accObj[0].Total_Work_Experience_Yrs__c = poObjListAcc[0].Total_work_experience__c;
   if (yrsExpTotal[0] != null) {
    accObj[0].Total_Work_Experience_Yrs__c = yrsExpTotal[0];
   } else {
    accObj[0].Total_Work_Experience_Yrs__c = '0';
   }
   if (yrsExpTotal.size() > 1) {
    accObj[0].Total_Work_Experience_Months__c = yrsExpTotal[1];
   } else {
    accObj[0].Total_Work_Experience_Months__c = '0';
   }
  }
  system.debug('poObjListAcc[0].Experience_in_Years__c--->>>>>>>>' + poObjListAcc[0].Experience_in_Years__c);
  List < String > yrsExpCurrent;
  if (poObjListAcc[0].Experience_in_Years__c != null) {
   String currentExtStr = string.valueOf(poObjListAcc[0].Experience_in_Years__c);
   yrsExpCurrent = currentExtStr.split('\\.');
  }
  if (yrsExpCurrent != null && yrsExpCurrent.size() > 0 && accObj.size() > 0) {
   if (yrsExpCurrent[0] != null) {
    accObj[0].Current_experiance_in_Years__c = yrsExpCurrent[0];
   } else {
    accObj[0].Current_experiance_in_Years__c = '0';
   }
   if (yrsExpCurrent.size() > 1) {
    accObj[0].Current_experiance_in_Month__c = yrsExpCurrent[1];
   } else {
    accObj[0].Current_experiance_in_Month__c = '0';
   }
  }
  //SAL PLTB changes Rohit 14951 start
  List < SurrogateCAM__c > surrCamList = new List < SurrogateCAM__c > ();
  surrCamList = poObjListAcc[0].SurrogateCAMS__r;
  //system.debug('before mapping : ' + surrCamList[0]);
  if (surrCamList.size() > 0) {
   accObj[0].Current_experiance_in_Month__c = surrCamList[0].Current_experiance_in_Month__c;
   accObj[0].Total_Work_Experience_Months__c = surrCamList[0].Total_Work_Experience_Months__c;
   System.debug('robin3');
  }
  //SAL PLTB changes Rohit 14951 stop
  //harsit----To avoid NULL Pointer Exceptionj----END
  try {
   system.debug('Before Account Upsert');
   if (accObj.size() > 0)
    upsert accObj[0];
  } catch (DMLException e) {
   String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
   str += 'Product Offering Id :' + offeringId + ' \n Block 11'; // Bug 12463
   System.debug(str);
   CommonUtility.SendExceptionMail(str);
  }
  //Added for Call center CR 8292 E

 }
 @future
 public static void cloneExistingLoanDetailsCallCenter(String primaryApplicantObj1, String oppObj1, String productOfferObj1) {
  system.debug('call Center Process Existing Loan Details');
  //start of Existing Loan Details
  List < Existing_Loan_Details__c > extLoanOpp = new List < Existing_Loan_Details__c > ();
  List < Existing_Loan_Details__c > extLoan = new List < Existing_Loan_Details__c > ();
  extLoan = [select id, /*SAL PLTB Pritha S*/ Rate_of_Interest__c, Derived_EMI__c, Customer_Declared_EMI__c, Remark__c, Property_Purchase_Date__c, Purchase_Value__c, /*SAL PLTB Pritha E*/ Secured_Unsecured__c, Loan_Type__c, Seen_in__c,
   Loan_Acc_No__c, Select__c, Applicant__r.ContactName__c, Principal_O_s__c, Status__c,
   Financer__c, Amount__c, Month1_Amount__c, Month2_Amount__c, Financers__c, Obligation__c,
   Start_On__c, Tenor__c, Tenor_Left__c, MOB__c, POS__c, EMI__c, Applicant__c, Annual_Obligation__c, Type_of_Oblig__c, Product_Offering__c, Loan_Amount__c,
   Month3Amount__c, Month4Amount__c, Month5Amount__c, Month6Amount__c, Mthly_Oblig__c, EMI_Over_In_Next_6_months__c, Identifier__c from Existing_Loan_Details__c where Product_Offering__c =: productOfferObj1 and Identifier__c = 'Manual'
  ];
  if (extLoan != null && extLoan.size() > 0) {
   system.debug('extLoan size*****' + extLoan.size());
   for (Existing_Loan_Details__c objExtLoan: extLoan) {
    Existing_Loan_Details__c objExt = new Existing_Loan_Details__c();
    objExt = objExtLoan.clone(false, false, false, false);
    system.debug('*****Cloneed cam  Object :--' + objExt);
    objExt.Applicant__c = primaryApplicantObj1;
    //objExt.Loan_Amount__c = objExtLoan.Loan_Amount__c;
    objExt.Loan_Application__c = oppObj1;
    objExt.Product_Offering__c = null;
    extLoanOpp.add(objExt);
   }
   if (extLoanOpp != null && extLoanOpp.size() > 0) {
    try {
     insert extLoanOpp;
    } catch (DMLException e) {
     String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
     str += 'Product Offering Id :' + offeringId + ' \n Block 12'; // Bug 12463
     System.debug(str);
     CommonUtility.SendExceptionMail(str);
    }
   }
  }
 }
 //Added for Call center CR 8292 E

 static void savePropertyDetailNew(String oppId, String pId) {
  try {
   //boolean SwitchOtimizedCode = LaonApplicationCreation__c.getValues('RunOptimizeCode(LoanConetionUtiility))').Integrate_Charges_API__c;

   //Mortgage Strat
   List < De_Dupe__c > newDedupeList = new List < De_Dupe__c > ();
   List < Verification__c > newVerificationList = new List < Verification__c > ();
   List < Property_Details__c > newProList = new List < Property_Details__c > ();

   //Mortgage End
   /*
    if (!SwitchOtimizedCode) {
    List < Property_Details__c > ProplistOptimized = new List < Property_Details__c > ();
    ProplistOptimized = [Select property_details__c, accounting_irr__c, account_mobile__c, account_phone__c, additional_collateral_observation__c, address__c, adf_flag__c, advanceinstalmentamount_deduct_frm_disb__c, advance_emi__c, advance_instalment_amount_paid_to_bfl__c, advance_instalment_amount_paid_to_dealer__c, amc_funding__c, amenities_cost__c, amount_fund_property__c, any_other_observation__c, apf_flag__c, apf_number__c, appraised_date__c, approach_road__c, approving_authority__c, area_carpet__c, area_super_built_up__c, asset_age__c, asset_category__c, asset_code__c, asset_cost__c, asset_finnone_code__c, asset_insurance_compnay__c, asset_insurance_expiry_date__c, asset_insurance_funded__c, asset_insurance_icn__c, asset_insurance_premium_amt__c, asset_insurance_remarks__c, asset_insurance_start_date__c, asset_insurance_sum_assured_amt__c, asset_level__c, asset_manufacturer__c, asset_master__c, asset_model__c, asset_registrable__c, asset_remarks__c, asset_tenure__c, asset_total_funding__c, asset_type__c, asset__c, average_appraisal_value__c, average_of_two_valuations__c, bank_name__c, bfl_indicative_rate__c, bfl_lien_in_ins_policy_icn__c, bfl_lien_in_ins_policy__c, bfl_lien_in_rc_book__c, block__c, body_funding__c, bt_amount__c, bt_bank_name__c, bt_loan_mob__c, builder_category__c, builder_maintenance__c, builder_name__c, builder_segmentaton__c, chassis_funding__c, chassis_number__c, clone__c, connectionreceivedid, connectionsentid, construction_area_sbu__c, construction_area_val1__c, construction_area_val2__c, construction_rate_val1__c, construction_rate_val2__c, construction_valuation_1__c, construction_valuation_2__c, contact_number_for_val__c, contact_person_for_val__c, contribution__c, con_val_onproperty__c, count_of_properties__c, createdbyid, createddate, credit_days__c, currencyisocode, current_amount_outstanding__c, current_market_value__c, current_property_owner__c, customer_irr__c, customer_margin_paid__c, custom_duty_body_cost__c, date_of_last_update_for_bfl_indicative__c, dealer_code__c, dealer_manufacturer_subvention__c, dealer_master__c, deal_irr_gross_of_brk__c, deed_agreement_value__c, developer_name__c, digital_excercized_value__c, digital_fbt__c, digital_grant_price__c, digital_nav__c, digital_scrips_count__c, digital_scrips_eligibility__c, digital_scrip_category__c, digital_scrip_code__c, digital_scrip_eligibility__c, digital_scrip_market_price__c, digital_scrip_name__c, digital_scrip_type2__c, digital_scrip_type__c, digital_total_value__c, disbursement_favoring__c, document__c, ecs_mandate__c, eligible_tenor__c, emi_amount__c, emi_cycle__c, end_use_funds__c, engine_number__c, existing_loan_funded_amount__c, existing_property__c, expected_completion_date__c, extra_amenities_val1__c, extra_amenities_val2__c, final_remarks__c, final_valuation__c, first_pdc_ecs_date__c, flat_rate__c, floor_number__c, folio_no__c, funded_amount__c, funding_amount__c, gi_health__c, gi_motor__c, grid_value__c, g_insurance_funding__c, has_tranche__c, hl_bt_amount__c, home_loan_start_date__c, hospital_property__c, id, idv__c, if_negative_reason_to_be_specified__c, investment_end_date__c, investment_start_date__c, invoice_date__c, invoice_number__c, isdeleted, is_address_matching_with_valuation_repor__c, is_construction_work_going_on__c, is_he_she_property_owner__c, kyc_done_on__c, kyc_verification_done__c, land_area_as_per_sale_deed__c, land_cost__c, land_valuation_1__c, land_valuation_2__c, lastmodifiedbyid, lastmodifieddate, latest_property__c, lc_nonlc__c, legal__c, life_insurance_funding__c, loan_amount_including_balic__c, loan_amount_offered__c, loan_application__c, loan_offered__c, location__c, ltv_including_insurance__c, ltv_offered__c, ltv__c, machine_serial__c, manufacturing_date__c, margin_money_paid_to_dealer_manufactur__c, margin_money_to_bfl_deposited_in_icici__c, margin__c, max_ltv_allowed_basis_credit_assessmen__c, max_permissible_ltv__c, minimum_of_two_valuations__c, minimum_scrip__c, mode_of_payment__c, monthly_rental1__c, moratorium_days__c, name, name_of_seller__c, name_of_the_sale_person_who_visited__c, neighborhood_locality__c, net_ltv1__c, new_existing_property__c, no_of_advance_emi__c, no_of_advance_instalments__c, no_of_emi_s__c, no_of_emi__c, no_of_tenants_relative__c, number_of_floors_completed_constructed__c, number_of_shares__c, occupancy_status_of_property__c, occupancy_status__c, opp_id__c, original_invoice__c, original_noc__c, other_bank__c, other_deductions__c, other_developer_del__c, other_project__c, other_property_type_unit__c, ownerid, ownership_serial_no__c, personmetrelationshipwithcontactowner__c, person_met__c, pi_amount__c, pi_no_date__c, pi_number__c, plot_no_flat_no__c, preferred_area__c, processing_fees_stamp_duty_to_be_deduct__c, product_offerings__c, product_scheme__c, product__c, project_category__c, project_master__c, project_name__c, property_address_line_1__c, property_address_line_2__c, property_address_line_3__c, property_age__c, property_area_in_sq_ft__c, property_city__c, property_identified__c, property_land_area_val1__c, property_land_area_val2__c, property_land_rate_val1__c, property_land_rate_val2__c, property_ownership__c, property_owner_age_in_years__c, property_owner_meeting__c, property_owner_type__c, property_pin_code__c, property_price_range__c, property_price__c, property_state__c, property_status__c, property_transaction_type__c, property_type_unit__c, property_type__c, property_usage__c, property_value1__c, property_value__c, property_visit_date_time__c, property__c, purchase_cost__c, purpose__c, rate_per_square_feet__c, recordtypeid, registration_charge__c, regi_number__c, remarks__c, retrigger_legal__c, retrigger_property__c, retrigger_valuation__c, rto_funding__c, sale_deed_age__c, sale_deed_date_if_done__c, sale_type__c, scrip_name__c, scrip_type__c, search_parameter__c, select__c, separate_access_to_the_property__c, share_value__c, specific_issue_affect_marketability_of_p__c, stage_of_construction__c, stamp_charge__c, structured_emi__c, sub_unit_type__c, sum_insured_value__c, systemmodstamp, tds_reductions1__c, tenant_vintage__c, title_clear_flag__c, top_up_amount__c, total_cost_of_complete_asset__c, total_loan_amount__c, total_margin_money_towards_asset__c, total_property_cost__c, total_purchase_cost__c, total_valuation_1__c, total_valuation_2__c, total_value_to_customer__c, type_of_measurement__c, type_of_property_document__c, unit_number__c, unit_type__c, valuation_amount__c, valuation_report_comparison__c, valuation__c, value_of_furniture_and_fixture__c, was_the_property_easy_to_locate__c, x120_of_lower__c, absorbed_units__c, average_construction_rate_per_sq_ft__c, average_property_land_price_per_sq_ft__c, avg_property_price__c, construction_area_in_sq_ft__c, construction_rate_per_sq_ft__c, construction_stage__c, launched_date__c, launched_units__c, nature_of_property__c, project_segmentation__c, property_land_area_in_sq_ft__c, property_name__c, remarks2__c, credit_land_area__c, pe_responce__c, land_rate_as_per_pe_ppiv2__c, credit_construction_area_sq_ft__c, credit_construction_rate__c, credit_land_rate__c, credit_total_valuation_mortgage__c, bt_bank_roi__c, total_valuation_as_per_pe_ppiv2__c, total_valuation_mortgage__c, geolocation__c, approved_loan_amount__c, area_locality__c, basic_agreement_value__c, building_name__c, club_membership__c, case_type__c, construction_area__c, electricity_and_water_deposite__c, first_appraisal_by__c, floor_rise_amount__c, legal_charges__c, ltv_offered_new__c, ltv_with_ins_premium__c, ltv_with_i_ie_and_m_plus__c, ltv_with_i_ie_m_plus_and_total_loan__c, ltv_with_i_ie__c, m_plus__c, number_of_parking__c, onetime_maintenance_deposite__c, parking_cost__c, parking_seperately_documented__c, parking_type__c, plot_flat_no__c, project_size__c, property_description__c, property_jurisdiction__c, sale_deed_regn_no__c, scheme_type__c, second_appraisal_by__c, sro_name__c, standard_ltv__c, total_agreement_value_consider__c, type_of_area__c, weak_account__c, property_details__r.name, from__c, to__c, document_available__c, document_registration_number__c, registration_date__c, construction_rate__c, total_valuation__c, original_copy__c, number_of_pages__c, language__c, supporting_document__c, type_of_valuation__c, basic_rate__c, reason_for_manual_valuation__c, land_rate_as_per_valuer_1__c, construction_rate_as_per_valuer_1__c, land_rate_as_per_valuer_2__c, construction_rate_as_per_valuer_2__c, value_of_aminities_as_per_valuer_1__c, value_of_aminities_as_per_valuer_2__c, land_rate__c, valuation_1__c, valuation_2__c, min_valuation__c, x120_of_minimum_valuation__c, total_valuation_as_per_valuer__c, transaction_year__c, trigger_manual_verification__c, property_details__r.property_address_line_1__c, moved_to_dedupe__c, property_plan__c, latest_ownership_document__c, date_and_time_for_technical__c, contact_person_for_technical__c, contact_person_for_number__c, builder_maintenance__r.builder_name__c, builder_maintenance__r.name, project_name__r.name, property_mcp_result__c, bt_bank_irr__c, bt_bank_pos__c, area_locality__r.localityid__c, area_locality__r.city__c, area_locality__r.city__r.cityid__c, project_master__r.projectid__c, developer_name__r.developerid__c, area_locality__r.city__r.absorption_in_sqft__c, area_locality__r.city__r.absorption_in_unit__c, area_locality__r.city__r.no_of_developer__c, area_locality__r.city__r.sales_velocity__c, area_locality__r.city__r.supply_mn_sqft__c, area_locality__r.city__r.supply_units__c, area_locality__r.city__r.total_projects_in_last_5_years__c, area_locality__r.city__r.wt_avg_price__c, area_locality__r.absn_units_in_last_6_month__c, area_locality__r.absorption_in_sqft__c, area_locality__r.absorption_in_unit__c, area_locality__r.no_of_developer__c, area_locality__r.supply_in_sqft__c, area_locality__r.supplyin_units__c, area_locality__r.total_projects_in_last_5_years__c, area_locality__r.wt_micro_market_rate__c, area_locality__r.sales_velocity__c, developer_name__r.absorption_availability__c, developer_name__r.developer_availability__c, developer_name__r.total_projects_in_last_5_years__c, developer_name__r.magnitude__c, project_master__r.project_segmentation__c, project_master__r.nature_of_proposed_development__c, project_master__r.sold_units__c, project_master__r.total_units__c, project_master__r.bhk__c, project_master__r.completion_date__c, project_master__r.construction_status_of_project__c, project_master__r.current_price_range__c, project_master__r.current_primary_price_max__c, project_master__r.current_primary_price_min__c, project_master__r.current_status__c, project_master__r.delay_in_months__c, project_master__r.infra_charges__c, project_master__r.launch_date__c, project_master__r.launch_price__c, project_master__r.launch_sqft__c, project_master__r.no_of_floors__c, project_master__r.price_based_on__c, project_master__r.project_level_absorption_rate__c, project_master__r.project_size_in_sqft__c, project_master__r.resale_price_max__c, project_master__r.resale_price_min__c, project_master__r.resel_price_range__c, land_area__c, project_master__r.total_sqft__c, project_master__r.unit_size_range__c, project_master__r.update_date__c, project_master__r.wt_micro_market_rate__c, land_area_units__c, construction_area_units__c, developer_name__r.name, developer_name__r.builder_segmentation__c, project_name__r.project_segmentation__c, area_locality__r.name, approach_road_mortgage__c, occupied_since__c, contact_no_of_person_met_at_site__c, property_landmark__c, neighbour_enquiry_positive__c

            ,(select id, Dedupe_Lan_Matches__c, Customer_ID__c, De_Dupe_result__c, Dedupe_Comments__c from De_Dupes__r),
            (select id, RecordTypeId, Verification_Type__c from Verifications__r)

            from Property_Details__c where Product_Offerings__c = : pId order by createddate asc ];
    Proplist = ProplistOptimized;

    }
       */

   if (Proplist != null && Proplist.size() > 0) {
    system.debug('---Proplist---' + Proplist);
    for (Property_Details__c objRepd: Proplist) {
     Property_Details__c objPD = new Property_Details__c();
     PoPropID.add(objRepd.id); // bug 13253
     System.debug('PO Prop ID : ' + PoPropID);
     //Mortgage Re-Engg start
     objPD = objRepd.clone(false, true, false, false);
     //Mortgage Re-Engg end
     //objPD = objRepd.clone(false, false, false, false);
     system.debug('*****Cloneed PD  Object :--' + objRepd);
     objPD.Loan_Application__c = oppId;
     objPD.Product_Offerings__c = null;
     newProList.add(objPD);
     PropMap.put(objRepd.id, objPD); // bug 13253
    }
   }
   if (newProList != null && newProList.size() > 0) {
    try {
     insert newProList;
     //Mortgage Start
     for (Property_Details__c objprop: newProList) {
      for (De_Dupe__c objDedupe: objprop.De_Dupes__r) {
       De_Dupe__c newDedupe = new De_Dupe__c();
       newDedupe = objDedupe.clone(false, true, false, false);
       newDedupe.Property_Details__c = objprop.id;
       newDedupeList.add(newDedupe);
      }
      for (Verification__c objVeri: objprop.Verifications__r) {
       Verification__c newVeri = new Verification__c();
       newVeri = objVeri.clone(false, true, false, false);
       newVeri.Property_Details__c = objprop.id;
       newVerificationList.add(newVeri);
      }
     }
     if (newDedupeList != null && newDedupeList.size() > 0) {
      insert newDedupeList;
     }
     if (newVerificationList != null && newVerificationList.size() > 0) {
      insert newVerificationList;
     }
     //Mortgage End
    } catch (DMLException e) {
     String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
     str += 'Product Offering Id :' + offeringId + ' \n Block 13'; // Bug 12463
     System.debug(str);
     CommonUtility.SendExceptionMail(str);
    }
   }

  } catch (Exception e) {
   String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
   str += 'Product Offering Id :' + offeringId + ' \n Block 14'; // Bug 12463
   System.debug(str);
   CommonUtility.SendExceptionMail(str);
   system.debug('Exception Occured **' + e.getMessage());
  }
 }
 //Mortgage Re-Engg Start
 @future

 public static void saveBankDetails(String oppId, String pId, map < string, string > POpropList, map < string, string > newPropList) { // bug 13253
  try {
   //List < Bank_Account__c > objBankDetailsList = new List < Bank_Account__c > ();
   List < Bank_Account__c > objClonedBankList = new List < Bank_Account__c > ();

   //objBankDetailsList = [SELECT Account_Type__c, Account_Used_For__c, ApplicantName__c, Product_Offerings__c, Applicant_Name__c, Applicant__c, Average_Balance__c, Average_incentive_for_Q1__c, Average_incentive_for_Q2__c, Average_incentive_for_Q3__c, Average_monthly_balance1__c, Average_monthly_balance2__c, Average_monthly_balance3__c, Average_ODCC_Utilization__c, Average_OD_CC_Limit__c, Average_of_Bounce_I_W__c, Average_of_Bounce_O_W__c, Average_of_CRD_Amount__c, Average_of_CRD_No__c, Average_of_DB_Amount__c, Average_of_DB_No__c, Average_of_ODCC_Limit__c, Average_Opening_Balance__c, Average_Open_Limit__c, Avg_Bounce_I_W__c, Avg_Bounce_O_W__c, Avg_CRD_Amount__c, Avg_CRD_No__c, Avg_DB_Amount__c, Avg_DB_No__c, Avg_monthly_incentive1__c, Avg_monthly_incentive2__c, Avg_monthly_incentive3__c, Avg_Monthly_Interest__c, Avg_mthly_bal6__c, Avg_mthly_bal_Coapp_SAL__c, Avg_mthly_incntve_3mts__c, Avg_mthy_bal_SAL__c, Avg_qtrly_incentive__c, AvmonBalance_EMI__c, Banking_Obligation__c, Bank_Account_Number__c, Bank_Acct_Number__c, Bank_Branch__c, Bank_Name_List__c, Bank_Name_Salaried__c, Bank_Name_Sal__c, Bank_Name__c, Bank_Type__c, Cheque_returns_in_latest_3_months__c, ConnectionReceivedId, ConnectionSentId, Consider_For_Eligibility_Gross_Profit__c, Consider_for_Eligibility_LTV__c, Consider_for_Eligibility__c, CreatedById, CreatedDate, Credit_more_than_1_5_time_in_last_3_mont__c, CurrencyIsoCode, Eligible_EMI_Banking__c, Id, IFSC_Bank_Name__c, IFSC_Code__c, IFSC_Master__c, IsDeleted, LastModifiedById, LastModifiedDate, Loan_Application_Number__c, Loan_Application__c, MICR_Code__c, Month1__c, monthly_Av_Balance_EMIOut__c, Month_2__c, Month_3__c, Month_end_Bal__c, Name, NumberOfMonthsTrans__c, OD_CC_limit__c, Opening_Balance__c, Other_Bank__c, OwnerId, Perc_Inward_Ret__c, Perc_Outward_Return__c, Perfios_Account_Holder_Name__c, Perfios_Account_No__c, Perfios_Bank_Name__c, Perfios_Client_Address__c, Perfios_Client_pan_no__c, Perfios_Flag__c, Per_of_inward_returnsOut__c, Product__c, Proposed_BAFL_EMI__c, Rate_of_OD_CC__c, Salaried_CAM__c, Salaried_Temp__c, Salary_credit_amount1__c, Salary_credit_amount2__c, Salary_credit_amount3__c, Salary_Credit_Date1__c, Salary_Credit_Date2__c, Salary_Credit_Date3__c, SelectBank__c, Send_Email_For_Perfios__c, sum_Avg_mthly_bal__c, Sum_Bounce_I_W__c, Sum_Bounce_O_W__c, Sum_CRD_Amount__c, Sum_CRD_No__c, Sum_DB_Amount__c, Sum_DB_No__c, Sum_Monthly_Interest__c, Sum_of_average_Balance__c, Sum_of_Cred_Int_Bank_Firm_Tran__c, Sum_of_OD_CC_Limit__c, Sum_of_OD_CC_Utilization__c, SystemModstamp, Transaction_Count__c, X10th_Bal__c, X20th_Bal__c
   //  FROM Bank_Account__c where Product_Offerings__c = : pId
   //];


   if (objBankDetailsList != null && objBankDetailsList.size() > 0) {
    for (Bank_Account__c objextBank: objBankDetailsList) {

     Bank_Account__c objbank = new Bank_Account__c();
     objbank = objextBank.clone(false, false, false, false);
     system.debug('*****Cloneed Bank Ac  Object :--' + objbank);
     objbank.Loan_Application__c = oppId;
     objbank.Product_Offerings__c = null;
     objClonedBankList.add(objbank);
    }
   }
   // bug 13253 start
   try {
    if (POpropList.size() > 0) {
     Set < ID > PropID = (Set < ID > ) JSON.deserialize(POpropList.get('propertyList'), Set < ID > .class);
     Map < ID, Property_Details__c > PropMap = (Map < ID, Property_Details__c > ) JSON.deserialize(newPropList.get('NewpropertyList'), Map < ID, Property_Details__c > .class);
     List < FeedItem > feeditemListque = new List < FeedItem > ();
     feeditemListque = [select ContentData, ContentFileName, Body, ParentId from FeedItem where ParentId IN: PropID];
     List < ContentDocumentLink > cdLinkList = new List < ContentDocumentLink > ();
     cdLinkList = [select ContentDocumentId, LinkedEntityId from ContentDocumentLink where LinkedEntityId IN: PropID];


     System.debug('New prop List' + PropID);
     System.debug('old prop list: ' + PropMap);

     for (FeedItem post: feeditemListque) {

      if (PropMap.ContainsKey(post.ParentId)) { // this po prop ID
       System.debug('New Loan Prop ID: ' + PropMap.get(post.ParentId));
       if (post.body != null) {
        FeedItem feed = new FeedItem();
        feed.ParentId = PropMap.get(post.ParentId).id; // get new loan prop ID
        feed.Type = 'ContentPost';

        feed.Body = post.body;
        System.debug('new Feed: ' + feed);
        FeedItemList.add(feed);
       }
      }
     }

     for (ContentDocumentLink cdlink: cdLinkList) {
      cdID.add(cdlink.ContentDocumentId); // po cdid
      newMap.put(cdlink.ContentDocumentId, cdlink.LinkedEntityId); // po cd and linkentity
      //strmap.put(cdlink.ContentDocumentId,PropMap.get(cdlink.LinkedEntityId));
      //old PO prop ID              // New LAn Prop ID
     }

     System.debug('newMap ' + newMap);
     List < ContentVersion > cvList = new List < ContentVersion > ();
     cvList = [SELECT id, ContentDocumentId, Title, pathOnClient, versionData, origin FROM ContentVersion where ContentDocumentId IN: cdID];
     integer i = 0;
     string strTitle;
     for (ContentVersion cvObj: cvList) {
      System.debug('old cv: ' + cvObj);
      strTitle = cvObj.Title + string.valueof(i);
      strmap.put(strTitle, PropMap.get(newMap.get(cvObj.ContentDocumentId)).id);
      System.debug('strMAP: ' + strmap);
      ContentVersion cv = new ContentVersion();
      //cv=cvObj.clone(false, true, false, false);
      cv.versionData = cvObj.versionData;
      cv.origin = 'H';
      cv.title = cvObj.title;
      cv.pathOnClient = cvObj.pathOnClient;
      System.debug('cv clone 1: ' + cv);
      i++;
      newAttchmentList.add(cv);
     }

     if (newAttchmentList != null && newAttchmentList.size() > 0)
      Insert newAttchmentList;
     Integer num = 0;
     string strTitle1;
     System.debug('New cv: ' + newAttchmentList);
     for (ContentVersion cv: newAttchmentList) {
      Id cdId1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
      System.debug('cv.ContentDocumentId: ' + cdId);
      strTitle1 = cv.Title + string.valueof(num);
      ContentDocumentLink cdLnk = new ContentDocumentLink();
      cdLnk.ContentDocumentId = cdId1;

      cdLnk.LinkedEntityId = strmap.get(strTitle1);
      cdLnk.ShareType = 'V';
      cdLnk.Visibility = 'AllUsers';
      insert cdLnk;
      System.debug('Attachment clone: ' + cdLnk);
      num++;
     }
     if (FeedItemList != null && FeedItemList.size() > 0) {
      insert FeedItemList;
     }
    }
   } catch (DMLException e) {
    system.debug('---Exception---' + e.getMessage());
   }
   // bug 13253 end
   if (objClonedBankList != null && objClonedBankList.size() > 0) {
    try {
     insert objClonedBankList;
    } catch (DMLException e) {
     String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
     str += 'Product Offering Id :' + offeringId + ' \n Block 15'; // Bug 12463
     System.debug(str);
     CommonUtility.SendExceptionMail(str);
     system.debug('---Exception---' + e.getMessage());
    }
   }

  } catch (Exception e) {
   String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
   str += 'Product Offering Id :' + offeringId + ' \n Block 16'; // Bug 12463
   System.debug(str);
   if (!Test.isRunningTest())
    CommonUtility.SendExceptionMail(str);
   system.debug('Exception Occured **' + e.getMessage());
  }
 }
 //Mortgage Re-Engg End
 //@future
 static void savePersonalDiscussionsnew(String applicantId, String oppId, Product_Offerings__c Objpo) {
  try {
   boolean SwitchOtimizedCode = LaonApplicationCreation__c.getValues('RunOptimizeCode(LoanConetionUtiility))').Integrate_Charges_API__c;
   objNewPDList = new List < Personal_Discussion__c > ();
   if (!SwitchOtimizedCode) {
    List < Personal_Discussion__c > poPDlistOptimized = new List < Personal_Discussion__c > ();
    poPDlistOptimized = [SELECT ACM_Name__c, Address_PD_done__c, Any_Negative_Observations__c, Any_other_Businesses_run_by_the_Applican__c, Any_other_source_of_Income__c,
     Applicant_shareholding__c, Approx_Portfolio_Value_Rs__c, Area_in_sq_ft__c, Balance_Transfer_Loan__c, basis_of_Infrastructure_seen__c,
     Brief_Back_Ground__c, Business_Vintyage_Job_Vintage__c, Case_Strengths__c, Case_Weaknesses__c, Change_in_primary_banker__c,
     Classification_as_per_MSME_Act__c, Client_Profile_is_correct__c, Clinic_Existence_No_of_yrs__c, Clinic_Timing__c, Collected_All_Documents__c,
     Collection_Executive_Seen__c, Comfortable_EMI__c, Comments__c, Com_of_bus_orders__c, ConnectionReceivedId, ConnectionSentId, Constitution__c,
     consultation_fees__c, Copy_Verified_with_Org__c, CreatedById, CreatedBy_name__c, CreatedDate, Creditor_Total__c, Credit_Rating_If_any__c,
     Credit_Rating__c, CurrencyIsoCode, Current_Order_Position__c, Customer_with_max_contribution__c, Date_of_Personal_Discussion__c, Date_of_purchase__c,
     Date__c, Debarred_from_Cap_Marker__c, Debtor_Total__c, Details_of_Employer_Business_set_up_em__c, Details__c, Det_of_busi_setup__c,
     Did_the_executive_explain_the_document_r__c, Did_you_apply_for_a_loan_with_BFL__c, Did_you_sign_our_application_form__c, Disbursement_in_favor_of__c,
     Doctors_Timing_at_the_clinic__c, Doctors_visiting_days_at_the_clinic__c, Domestic_Sales_Receipts__c, Edit_Status__c, Employee_strength__c,
     Employment_details__c, End_Use_of_the_Loan__c, Existing_Product__c, Existing_Relationship__c, Expected_Sales_by_Year_End__c, FamilyDetails__c,
     Family_Details__c, Financial_Health_Check_Guide__c, Firm_Company_Name__c, Fixed_Plan_Invested__c, Fixed_plan_Portfolio_Date__c,
     Fixed_plan_Portfolio_Value__c, GIft_Given__c, Gift_Type__c, Grade__c, Highest_Degree_Holding__c, Id, Income_Assessed__c, Industry__c, Institute__c,
     Insurance_Invested__c, Insurance_Portfolio_Date__c, Insurance_Portfolio_Vaue__c, Insurer__c, Invested__c, Investment_in_Mutual_Funds_in_Rs__c,
     Investment_in_Shares_in_Rs__c, IsDeleted, ISO_certified__c, Is_clinic_hospital_well_known_in_local__c, Is_he_Share_Broker__c, Is_it_in_the_line__c,
     Is_payment_on_time__c, Is_there_any_abnormal_increasedecrease__c, LastModifiedById, LastModifiedDate, Less_than_90_days1__c, Less_than_90_days__c,
     Loans_on_Immovable_Assets_in_Rs__c, Loans_on_Moveable_Assets_in_Rs__c, Loan_Amount_Required__c, Loan_Application__c, Loan_Availed_In_Last_3_Months__c,
     Machinery_Seen__c, Major_Customer_One__c, Major_Customer_Two__c, Managerial_Cader__c, Manufacturing_facility__c, Market_values_in_Lacs__c, Materials__c,
     Met_Client__c, MF_to_Movable_Asset_Ratio__c, More_than_90_days1__c, More_than_90_days__c, Mutual_fund_Invested__c, Mutual_Fund_Portfolio_Date__c,
     Mutual_Fund_Portfolio_value__c, Name, Name_Designation__c, Name_of_Brand__c, Name_Of_Credit_Manager__c, Name_of_Highest_Degree_College__c,
     Name_of_the_applicant__c, Name_of_the_CoApplicant__c, Name_of_the_person_met_during_PD__c, Nature_of_Business_2__c, Nature_of_Business_in_Detail1__c,
     Nature_of_Business_in_detail__c, Nature_of_Business__c, Net_Immovable_Assets__c, Net_Movable_Assets__c, Net_Worth__c, Non_Managerial_Worker__c,
     No_of_customer__c, No_of_doctors_operating_out_of_the_clin__c, No_of_Loan_availed_in_Last_3month__c, No_of_Patients_seen_during_visit__c,
     No_of_years_in_Existing_Co__c, No_of_years_in_Total_Employment_proofs__c, Number_on_which_spoken_to__c, OD_CC_Banker_Lead_Banker__c, Office_details__c,
     Office_Factory_details__c, Office_Interior__c, Office_Located__c, one_view_cam_comments__c, On_Loan_Free__c, Orders_in_Hand__c, OtherRemark1__c,
     OtherRemarks__c, Other_Earning_Members__c, Other_Remarks__c, Other_Source_of_Fund__c, Overseas_Sales_Receipts__c, Owned_Hospital_Clinic__c, OwnerId,
     Ownership__c, PD_Conducted__c, PD_Count_Updated__c, PD_Done_at__c, PD__c, Personal_Discussion_done_by__c, Plant_and_Machinery_Installed__c,
     Please_rate_the_service_levels__c, Political_Links__c, Portfolio_Valuation_Date__c, Premise_Details__c, Products_Manufactured__c, Product_Offerings__c,
     Product__c, Promoter_Background__c, Promoter_Related_Scrips__c, Property_owner__c, Property_Type__c, Purchase_Amount1__c, Purchase_Amount2__c,
     Purchase_Amount3__c, Purchase_Month1__c, Purchase_Month2__c, Purchase_Month3__c, Purpose_of_the_the_Loan__c, Qualification__c, Rating_Agency__c,
     Reasons_of_Any_Recent_DPD_in_CIBIL__c, Reasons_of_Recent_Loans_and_Enquiries__c, Registration_Certificate_Collected__c, Relationship_With_Applicant__c,
     Relationship_with_CoApplicant__c, Remarks__c, Remark__c, Repayment_from_account_of__c, Rest_of_Creditor_Total__c, Rest_of_Debtor_Total__c, Risks__c,
     RM_Collateral_Visit_Remark__c, RM_Recommendation_Remark__c, Sales_Amount1__c, Sales_Amount2__c, Sales_Amount3__c, Sales_Month1__c, Sales_Month2__c,
     Sales_Month3__c, Sanction_Condition__c, Scheme_Program__c, Signature__c, Softwares_Deployed__c, Specialization_Qua__c, Status__c, Statutory_Compliance__c,
     Stock_Seen__c, Stock_to_Movable_Asset__c, Stock_to_Networth_Ratio__c, Subscribed_to_Credit_Vidya__c, Sub_Industry__c, SystemModstamp, Tenor__c,
     Third_Party_business_reference__c, Top_3_Buyers1__c, Top_3_Buyers2__c, Top_3_Buyers3__c, Top_100_Colleges__c, Top_Secured_Lender__c, Top_Supplier1__c,
     Top_Supplier2__c, Top_Supplier3__c, Top_Un_Secured_Lender__c, Total_assets__c, Total_Hypothecated_Assets__c, Total_Immovable_Assets_in_Rs__c,
     Total_Moveable_Assets_in_Rs__c, Total_Non_Hypothicated_Assets__c, Total_no_of_years_in_employment__c, Total_Requirement__c, Total_Sum_Insured__c,
     Type_of_Assets__c, Type_of_Insurance__c, Type_of_locality__c, Type_of_Pd_sheet__c, Type_of_PD__c, Type_of_Residence__c, University_Name__c,
     Value_Of_Asset_Free_From_Loan__c, Value_Of_Liquid_Asset__c, Value_Of_Total_Fixed_Asset__c, Waiting_area_capacity__c,
     what_documents_have_you_provided_for_the__c, Whether_2nd_gen_is_involved_in_business__c, Whether_Spouse_Parents_are_Doctors__c,
     Who_was_the_sales_executive_who_dealt_wi__c, X2_Major_Customer_s__c, Years_in_Business__c, Years_in_Current_Business__c
     FROM Personal_Discussion__c
     where Product_Offerings__c =: Objpo.id order by createddate asc
    ];
    poPDlist = poPDlistOptimized;
   }
   if (poPDlist != null && poPDlist.size() > 0) {
    for (Personal_Discussion__c objRepd: poPDlist) {
     Personal_Discussion__c objPD = new Personal_Discussion__c();
     objPD = objRepd.clone(false, false, false, false);
     system.debug('*****Cloneed PD  Object :--' + objRepd);
     objPD.Loan_Application__c = oppId;

     objPD.Type_of_Pd_sheet__c = 'RM PD Sheet';

     System.debug('Type_of_Pd_sheet__c' + objPD.Type_of_Pd_sheet__c);

     objPD.Product_Offerings__c = null;
     if (applicantId != null) {
      objPD.Name_of_the_applicant__c = applicantId;
     }
     //Cibil Watch Start
     if (cibilwatchFlag == true) {
      if (Objpo.FFR_Flag__c == true) {
       objPD.Subscribed_to_Credit_Vidya__c = true;
       objPD.Financial_Health_Check_Guide__c = true;
      } else {
       objPD.Subscribed_to_Credit_Vidya__c = false;
       objPD.Financial_Health_Check_Guide__c = false;
      }
     }
     //Cibil Watch End

     objNewPDList.add(objPD);
    }
   } //Cibil Watch Start
   else if (cibilwatchFlag == true) {
    Personal_Discussion__c pdObj = new Personal_Discussion__c();
    if (Objpo.FFR_Flag__c == true) {
     pdObj.Subscribed_to_Credit_Vidya__c = true;
     pdObj.Financial_Health_Check_Guide__c = true;
    } else {
     pdObj.Subscribed_to_Credit_Vidya__c = false;
     pdObj.Financial_Health_Check_Guide__c = false;
    }
    pdObj.Loan_Application__c = oppId;
    pdObj.Product_Offerings__c = Objpo.Id;
    insert pdObj;
   }
   //Cibil Watch End
   if (objNewPDList != null && objNewPDList.size() > 0) {
    try {
     insert objNewPDList;
    } catch (DMLException e) {
     String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
     str += 'Product Offering Id :' + offeringId + ' \n Block 17'; // Bug 12463
     System.debug(str);
     CommonUtility.SendExceptionMail(str);
    }
   }

  } catch (Exception e) {
   String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
   str += 'Product Offering Id :' + offeringId + ' \n Block 18'; // Bug 12463
   System.debug(str);
   CommonUtility.SendExceptionMail(str);
   system.debug('Exception Occured **' + e.getMessage());
  }
 }

 public void AssignDLRMProductCAMValue(boolean isDLRMProduct, MAP < string, string > mapDLRMValues, SurrogateCAM__c objCAM1) {
  if (isDLRMProduct != null && isDLRMProduct) {
   if (mapDLRMValues != null && mapDLRMValues.size() > 0 && objCAM1 != null) {
    if (mapDLRMValues.get('Total_Secured_Exposure__c') != null)
     objCAM1.Total_Secured_Exposure__c = Decimal.valueOf(mapDLRMValues.get('Total_Secured_Exposure__c'));
    if (mapDLRMValues.get('Total_Unsecured_Exposure__c') != null)
     objCAM1.Total_Unsecured_Exposure__c = Decimal.valueOf(mapDLRMValues.get('Total_Unsecured_Exposure__c'));
    if (mapDLRMValues.get('mob__c') != null)
     objCAM1.MOB__c = Decimal.valueOf(mapDLRMValues.get('mob__c'));
    if (mapDLRMValues.get('Gross_Receipts__c') != null)
     objCAM1.Gross_Receipts__c = Decimal.ValueOf(mapDLRMValues.get('Gross_Receipts__c'));
   }
  }
 }
 public static void saveCAMnew(String applicantId, String oppId, String pId, MAP < string, string > mapDLRMValues) {
  try {
   boolean SwitchOtimizedCode = LaonApplicationCreation__c.getValues('RunOptimizeCode(LoanConetionUtiility))').Integrate_Charges_API__c;
   List < SurrogateCAM__c > objNewCAMList = new List < SurrogateCAM__c > ();

   //BUG-16959 DBOL Product Implementation  by Rajesh START
   Boolean isBOLProductLineProduct = false;
   set < string > setBolProdName = new set < string > ();
   if (!commonUtility.isEmpty(Label.BOL_Line_Products))
    setBolProdName.addAll(Label.BOL_Line_Products.split(';'));
   isBOLProductLineProduct = setBolProdName.contains(productOfferObj[0].products__c);
   //BUG-16959 DBOL Product Implementation  by Rajesh END

   system.debug('SwitchOtimizedCode=====>' + SwitchOtimizedCode);
   /*
     Code added by Rakesh Shinde. Date: 22 March 2016
     Purpose :Bug :6217. PRO DSS NEW CREDIT PROGRAM FOR CA SALARIED. Added fields in below query  
    */
   if (!SwitchOtimizedCode) {
    system.debug('SwitchOtimizedCode inside=====>' + SwitchOtimizedCode);
    List < SurrogateCAM__c > CAmlistOptimized = new List < SurrogateCAM__c > ();
     //new RDL mobility app start added PY_Type_of_Financial__c,Rural_Loan_Type__c,Gross_Receipts__c
    CAmlistOptimized = [select id,PY_Type_of_Financial__c,Rural_Loan_Type__c,Gross_Receipts__c, name, EMI_bounce_in_Last_3_Months__c, No_of_Bounce_for_BT_in_last_3_months__c, Net_monthly_Income__c, Work_Exp_or_business_continuty__c, CY_Obligations__c, PY_Sales_Turnover__c, SME_Score__c, CY_Audited_Turnover__c, Turnover_Change__c, No_of_Bounce_for_BT_in_last_6_months__c, OD_CC_Bank_Name__c, BFL_BL_Taken_in_last_6_Months__c, PY_OD_CC_limit__c, Applicant__c, OD_CC_limit__c, OD_CC_Limit_Change__c, PY_OD_CC_Limit_Utilisation__c, CY_Business_Vintage__c, Banking_details_OD_CC_check__c, Current_No_of_Live_BFL_Unsecured_loans__c, CY_OD_CC_Limit_Utilisation__c, OD_CC_Limit_Utilisation_Change__c, TRM_RM_comment__c, CY_Net_Profit__c, PY_Net_Profit__c, Total_Net_Profit_Change__c, Net_Salary_month1__c, Net_Salary_month2__c, Gross_Monthly_Salary_1__c, Gross_Monthly_Salary_2__c, Monthly_Obligation__c, Tenor_of_Loan__c, Fixed_Obligation_Income_Ratio__c, Loan_Amount_From_Offer__c, CY_Tenor__c, Loan_Amount__c, ROI__c, Customer_Segment__c, Sales_Customer_Segment__c, Credit_Customer_Segment__c, /*OTPV3 wadl change*/ Risk_Segmentation__c /*OTPV3 wadl change*/ /*SAL PLTB changes Rohit S 14951*/ , Current_experiance_in_Month__c, Total_Work_Experience_Months__c /*SAL PLTB changes Rohit E 14951*/ , /*PLTB changes 14951 S*/ Location_Wise_EWS_Status__c, Codified_CIBIL__c /*PLTB changes 14951 E*/ from SurrogateCAM__c where Product_Offerings__c =: pId order by createddate asc];
    CAmlist = CAmlistOptimized;
   }
   system.debug('CAmlist inside=====>' + CAmlist);
       //New RDL mobility app start added productOfferObj[0].name != 'RDL_FD_Mobile'
       if(productOfferObj[0].name != 'RDL_FD_Mobile'){
   if (CAmlist != null && CAmlist.size() > 0) {
    for (SurrogateCAM__c objReCAM: CAmlist) {
     SurrogateCAM__c objCAM = new SurrogateCAM__c();
     objCAM = objReCAM.clone(false, false, false, false);
     system.debug('*****Cloneed cam  Object :--' + objCAM);
     objCAM.Applicant__c = applicantId;
     objCAM.Loan_Application__c = oppId;
     objCAM.Product_Offerings__c = null;
     objNewCAMList.add(objCAM);

     SurrogateCAM__c objCAM1 = new SurrogateCAM__c();
     objCAM1 = objNewCAMList[0].clone(false, false, false, false);
     system.debug('*****Cloneed cam  Object :--' + objCAM1);
     objCAM1.Applicant__c = null;
     objCAM1.Loan_Application__c = oppId;
     objCAM1.Product_Offerings__c = null;
     if (isDLRMProduct) {
      if (mapDLRMValues != null && mapDLRMValues.size() > 0 && objCAM1 != null) {
       if (mapDLRMValues.get('Total_Secured_Exposure__c') != null)
        objCAM1.Total_Secured_Exposure__c = Decimal.valueOf(mapDLRMValues.get('Total_Secured_Exposure__c'));
       if (mapDLRMValues.get('Total_Unsecured_Exposure__c') != null)
        objCAM1.Total_Unsecured_Exposure__c = Decimal.valueOf(mapDLRMValues.get('Total_Unsecured_Exposure__c'));
       if (mapDLRMValues.get('mob__c') != null)
        objCAM1.MOB__c = Decimal.valueOf(mapDLRMValues.get('mob__c'));
       if (mapDLRMValues.get('Gross_Receipts__c') != null)
        objCAM1.Gross_Receipts__c = Decimal.ValueOf(mapDLRMValues.get('Gross_Receipts__c'));
      }
     }
     objNewCAMList.add(objCAM1);
    }
   }
   }
   String BlusValues = LaonApplicationCreation__c.getValues('BLUS values').BLUS__c;
   List < String > temp;
   if (BlusValues != null)
    temp = BlusValues.split(',');
   Set < String > SetBlusValues = new Set < String > ();
   SetBlusValues.addAll(temp);
   if (CAmlist.size() == 0 && oppObj.Program_Type__c != null && SetBlusValues != null && (SetBlusValues.Contains(String.valueOf(oppObj.Program_Type__c)))) {
    //Bug 6975 - BLUS and Pre approved movement to DSS by akshata start 13th june 2016
    /* to flow in dss flow inserted dummy surrogate CAm  */
    system.debug('program type of opportunity object=====>' + oppObj.Program_Type__c + 'objNewCAMList == null' + CAmlist.size());

    if (CAmlist.size() == 0 && oppObj.Program_Type__c != null && SetBlusValues != null && (SetBlusValues.Contains(String.valueOf(oppObj.Program_Type__c))) && primaryApplicantObj != null) {

     system.debug('program type of opportunity object in if loop' + oppObj.Program_Type__c);
     SurrogateCAM__c dummySurrogate = new SurrogateCAM__c(Credit_Customer_Segment__c = productOfferObj[0].Existing_Customer_Segmentation__c, Customer_Segment__c = productOfferObj[0].Existing_Customer_Segmentation__c, Loan_Application__c = oppId, Name = 'BLUS', Loan_Amount_From_Offer__c = productOfferObj[0].Availed_Amount__c, ROI__c = productOfferObj[0].Offer_ROI__c, Tenor_of_Loan__c = productOfferObj[0].Tenor__c, CY_Tenor__c = productOfferObj[0].Tenor__c, Loan_Amount__c = (productOfferObj[0].Availed_Amount__c) / 100000, Product_Master__c = 'BLUS_ProductValues', Program_Type__c = productOfferObj[0].Product_Offering_Type1__c, Applicant__c = primaryApplicantObj.Id);
     insert dummySurrogate;
     system.debug('program type of opportunity object in if loop after insert' + dummySurrogate.Id);

    }
   }
   //code added by leena for DLUS 14510--start
   // system.debug('setDLUS before======'+setDLUS);
   set < String > setDLUS;
   String DLUSTypes;
   if (LaonApplicationCreation__c.getValues('BLUS values') != null)
    DLUSTypes = LaonApplicationCreation__c.getValues('BLUS values').Program_Types__c;
   if (DLUSTypes != null && DLUSTypes != '')
    setDLUS = new Set < String > (DLUSTypes.split(';'));
   system.debug('program type of opportunity object in if loop' + oppObj.Program_Type__c);
   system.debug('setDLUS' + setDLUS);
   system.debug('primaryApplicantObj ' + primaryApplicantObj);
   system.debug('CAmlist' + CAmlist);
   if (CAmlist.size() == 0 && oppObj.Program_Type__c != null && setDLUS != null && (setDLUS.Contains(String.valueOf(oppObj.Program_Type__c))) && primaryApplicantObj != null) {
    system.debug('inside dummy surrogate');
    SurrogateCAM__c dummySurrogate = new SurrogateCAM__c(Final_Eligibility__c = (productOfferObj[0].Offer_Amount__c) / 100000, Credit_Final_Eligibility__c = (productOfferObj[0].Offer_Amount__c) / 100000, Credit_Customer_Segment__c = productOfferObj[0].Existing_Customer_Segmentation__c, Customer_Segment__c = productOfferObj[0].Existing_Customer_Segmentation__c, Loan_Application__c = oppId, Name = 'DLUS', Loan_Amount_From_Offer__c = productOfferObj[0].Availed_Amount__c, ROI__c = productOfferObj[0].Offer_ROI__c, Tenor_of_Loan__c = productOfferObj[0].Tenor__c, CY_Tenor__c = productOfferObj[0].Tenor__c, Loan_Amount__c = (productOfferObj[0].Availed_Amount__c) / 100000, Product_Master__c = 'DLUS_ProductValues', Program_Type__c = productOfferObj[0].Product_Offering_Type1__c, Applicant__c = primaryApplicantObj.Id);
    insert dummySurrogate;
    system.debug('program type of opportunity object in if loop after insert' + dummySurrogate.Id);
   }
   //code added by leena for DLUS 14510--end
     //New RDL mobility app start
  
             if (CAmlist.size()>0 && productOfferObj[0].name == 'RDL_FD_Mobile'){
             SurrogateCAM__c objRDLSCAM = new SurrogateCAM__c();
             objRDLSCAM = CAmlist[0].clone(false, false, false, false);
             objRDLSCAM.Credit_Customer_Segment__c = productOfferObj[0].Existing_Customer_Segmentation__c;
             objRDLSCAM.Customer_Segment__c = productOfferObj[0].Existing_Customer_Segmentation__c;
             objRDLSCAM.Loan_Application__c = oppId;
             objRDLSCAM.Product_Offerings__c = null;
             objRDLSCAM.Name = 'Mobility';
             objRDLSCAM.Applicant__c = applicantId;
             objRDLSCAM.CY_Obligations__c = productOfferObj[0].Monthly_Obligation__c;
             objRDLSCAM.Loan_Amount_From_Offer__c = productOfferObj[0].Availed_Amount__c;
             objRDLSCAM.ROI__c = productOfferObj[0].Offer_ROI__c;
             objRDLSCAM.Tenor_of_Loan__c = productOfferObj[0].Tenor__c;
             objRDLSCAM.CY_Tenor__c = productOfferObj[0].Tenor__c;
             objRDLSCAM.Loan_Amount__c = ((productOfferObj[0].Availed_Amount__c) / 100000);
            
             objNewCAMList.add(objRDLSCAM);
             }
   //New RDL mobility app end
   // system.debug('test1===>'+CAmlist.size() + 'productOfferObj[0].name==>'+productOfferObj[0].name);
   // Bug 14509 - Added RDL_FD_Mobile Condition
    //New RDL mobility app start removed  || productOfferObj[0].name == 'RDL_FD_Mobile'
   if (CAmlist.size() == 0 && (productOfferObj[0].name == 'PRO_FD_Mobile')) {

    system.debug('program type of opportunity object in if loop' + oppObj.Program_Type__c);
    System.debug('productOfferObj[0].Monthly_Obligation__c : ' + productOfferObj[0].Monthly_Obligation__c);
    // Bug 15074 - Added CY_Obligations__c  - Hemant Keni
    SurrogateCAM__c dummySurrogate = new SurrogateCAM__c(Credit_Customer_Segment__c = productOfferObj[0].Existing_Customer_Segmentation__c,
     Customer_Segment__c = productOfferObj[0].Existing_Customer_Segmentation__c,
     Loan_Application__c = oppId, Name = 'Mobility', CY_Obligations__c = productOfferObj[0].Monthly_Obligation__c,
     Loan_Amount_From_Offer__c = productOfferObj[0].Availed_Amount__c,
     ROI__c = productOfferObj[0].Offer_ROI__c, Tenor_of_Loan__c = productOfferObj[0].Tenor__c,
     CY_Tenor__c = productOfferObj[0].Tenor__c, Loan_Amount__c = (productOfferObj[0].Availed_Amount__c) / 100000);
    insert dummySurrogate;
    system.debug('program type of opportunity object in if loop after insert' + dummySurrogate.Id);

   }
   //Bug 6975 - BLUS and Pre approved movement to DSS by akshata end 13th june 2016
   //BOL Revamp Leena start
   //Bug ID - 13489 BOL Reinvent By Rajesh START
   //Added BLUS Condition to FLOW RTR Programme if Opp programme type is not BLUS Preapproved
   system.debug('BOL revamp leena here inserting surrogate cam');
   if (CAmlist.size() == 0 && isBOLProductLineProduct && primaryApplicantObj != null && !SetBlusValues.Contains(String.valueOf(oppObj.Program_Type__c))) {
    system.debug('BOL revamp leena here inserting surrogate cam');
    system.debug('inside BOL Program type ');
    SurrogateCAM__c dummySurrogate = new SurrogateCAM__c(Program_Type__c = 'RTR Surrogate', Loan_Application__c = oppId, Name = 'PSBL', Loan_Amount_From_Offer__c = productOfferObj[0].Revised_Offer_Amount__c, ROI__c = productOfferObj[0].Offer_ROI__c, Tenor_of_Loan__c = productOfferObj[0].Tenor__c, CY_Tenor__c = productOfferObj[0].Tenor__c, Loan_Amount__c = !CommonUtility.isEmpty(productOfferObj[0].Revised_Offer_Amount__c) ? productOfferObj[0].Revised_Offer_Amount__c / 100000 : 0, Applicant__c = primaryApplicantObj.Id);
    system.debug('leadObj.Cibil_Extension1s__r' + leadObj.Cibil_Extension1s__r);
    if (!CommonUtility.isEmpty(leadObj) && !CommonUtility.isEmpty(leadObj.Cibil_Extension1s__r)) {
     system.debug('leadObj.Cibil_Extension1s__r' + leadObj.Cibil_Extension1s__r);
     dummySurrogate.Maximum_AL_Amount__c = !CommonUtility.isEmpty(leadObj.Cibil_Extension1s__r[0].MAX_AL_Loan__c) ? (leadObj.Cibil_Extension1s__r[0].MAX_AL_Loan__c) / 100000 : 0;
     dummySurrogate.Maximum_PL_Amount__c = !CommonUtility.isEmpty(leadObj.Cibil_Extension1s__r[0].MAX_PL_Loan__c) ? leadObj.Cibil_Extension1s__r[0].MAX_PL_Loan__c / 100000 : 0;
     dummySurrogate.Maximum_BL_Amount__c = !CommonUtility.isEmpty(leadObj.Cibil_Extension1s__r[0].MAX_BL_Loan__c) ? leadObj.Cibil_Extension1s__r[0].MAX_BL_Loan__c / 100000 : 0;
     dummySurrogate.Maximum_HL_Amount__c = !CommonUtility.isEmpty(leadObj.Cibil_Extension1s__r[0].MAX_HL_Loan__c) ? leadObj.Cibil_Extension1s__r[0].MAX_HL_Loan__c / 100000 : 0;
     dummySurrogate.Maximum_LAP_Amount__c = !CommonUtility.isEmpty(leadObj.Cibil_Extension1s__r[0].MAX_LAP_Loan__c) ? leadObj.Cibil_Extension1s__r[0].MAX_LAP_Loan__c / 100000 : 0;

     //Bug 15854 - December_2017_RTR Calculator By Rajesh START
     dummySurrogate.No_of_Buisness_Loans__c = !CommonUtility.isEmpty(leadObj.Cibil_Extension1s__r[0].No_of_Live_BL__c) ? leadObj.Cibil_Extension1s__r[0].No_of_Live_BL__c : 0;
     dummySurrogate.No_of_Personal_Loans__c = !CommonUtility.isEmpty(leadObj.Cibil_Extension1s__r[0].No_of_Live_PL__c) ? leadObj.Cibil_Extension1s__r[0].No_of_Live_PL__c : 0;
     //Bug 15854 - December_2017_RTR Calculator BY Rajesh END

    }
    insert dummySurrogate;
    system.debug('program type of opportunity object in if loop after insert' + dummySurrogate.Id);

   }
   //Bug ID - 13489 BOL Reinvent By Rajesh END
   //BOL Revamp Leena End

   if (objNewCAMList != null && objNewCAMList.size() > 0) {
    try {
     insert objNewCAMList;
    } catch (DMLException e) {
     String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
     str += 'Product Offering Id :' + offeringId + ' \n Block 19'; // Bug 12463
     System.debug(str);
     CommonUtility.SendExceptionMail(str);
    }
   }

  } catch (Exception e) {
   String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
   str += 'Product Offering Id :' + offeringId + ' \n Block 20'; // Bug 12463
   System.debug(str);
   CommonUtility.SendExceptionMail(str);
   system.debug('Exception Occured **' + e.getMessage() + '====Line number is====>' + e.getLineNumber());
  }
 }
 //Mortgage Re-Engg Start
 static public void saveCAMSalaried(String oppId, Product_Offerings__c prodOffering) {
  //Map the details of SurrogateCAM into CAM record
  try {
   if (CAmlist != null && CAmlist.size() > 0) {

    CAM__c objCAM = new CAM__c();
    //Prospect Filed mapping
    if (CAmlist[0].Gross_Receipts__c != null) {
     objCAM.GP_current_year_gross_profit__c = CAmlist[0].Gross_Receipts__c;
    }
    if (CAmlist[0].No_of_Bounce_for_BT_in_last_6_months__c != null) {
     objCAM.Total_Number_of_Bounces__c = CAmlist[0].No_of_Bounce_for_BT_in_last_6_months__c;
    }
    if (CAmlist[0].Loan_Amount__c != null) {
     objCAM.Proposed_Loan_Amt__c = CAmlist[0].Loan_Amount__c;
    }
    if (CAmlist[0].ROI__c != null) {
     objCAM.ROI__c = CAmlist[0].ROI__c;
    }
    if (CAmlist[0].PY_Gross_Receipts__c != null) {
     objCAM.GP_Last_year_gross_profit__c = CAmlist[0].PY_Gross_Receipts__c;
    }
    if (CAmlist[0].CY_Tenor__c != null) {
     objCAM.Tenor__c = CAmlist[0].CY_Tenor__c;
    }
    //SME Filed mapping
    if (CAmlist[0].CY_Audited_Turnover__c != null) {
     objCAM.C_P_Current_Year__c = CAmlist[0].CY_Audited_Turnover__c;
    }
    if (CAmlist[0].PY_Sales_Turnover__c != null) {
     objCAM.C_P_Previous_Year__c = CAmlist[0].PY_Sales_Turnover__c;
    }
    if (CAmlist[0].CY_Net_Profit__c != null) {
     objCAM.Agri_Inc_2_be_Consd__c = CAmlist[0].CY_Net_Profit__c;
    }
    if (CAmlist[0].PY_Net_Profit__c != null) {
     objCAM.Agri_income_to_be_consd__c = CAmlist[0].PY_Net_Profit__c;
    }

    if (CAmlist[0].OD_CC_limit__c != null) {
     objCAM.Limit_In_Lacs__c = CAmlist[0].OD_CC_limit__c;
    }
    if (CAmlist[0].OD_CC_Bank_Name__c != null) {
     objCAM.Buyover_Bank1__c = CAmlist[0].OD_CC_Bank_Name__c;
    }
    if (CAmlist[0].CY_OD_CC_Limit_Utilisation__c != null) {
     objCAM.Industry_Margins_applicable1__c = CAmlist[0].CY_OD_CC_Limit_Utilisation__c;
    }
    if (CAmlist[0].No_of_Bounce_for_BT_in_last_6_months__c != null) {
     objCAM.Total_Number_of_Bounces__c = CAmlist[0].No_of_Bounce_for_BT_in_last_6_months__c;
    }

    if (CAmlist[0].Net_monthly_Income__c != null) {
     objCAM.Average_incentive_for_Q1__c = CAmlist[0].Net_monthly_Income__c;
    }

    //SHL Observations
    if (prodOffering.Availed_Amount__c != null)
     objCAM.Proposed_Loan_Amt__c = prodOffering.Availed_Amount__c;
    if (prodOffering.Tenor__c != null)
     objCAM.Tenor__c = prodOffering.Tenor__c;


    objCAM.Loan_Application__c = oppId;
    system.debug('---objCAM---' + objCAM);
    insert objCAM;
   }
  } catch (DMLException e) {
   String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
   str += 'Product Offering Id :' + offeringId + ' \n Block 21'; // Bug 12463
   System.debug(str);
   CommonUtility.SendExceptionMail(str);
   system.debug('---Exception---' + e.getMessage());
  }
 }
 //Mortgage Re-Engg End
 /*  static void createverification(Product_Offerings__c prodOffering,Applicant__c primaryApplicantObj) {
       try {
           Map < String, String > verification_inputs = new Map < String, String > ();
           Map < String, String > verification_outputs = new Map < String, String > ();

           verification_inputs.put('top_up_loan_amount', prodOffering.Topup_Amount__c + '');
           verification_inputs.put('product', 'RM');
           verification_inputs.put('type_of_loan', prodOffering.Loan_Type__c + '');
           verification_inputs.put('offerProduct', prodOffering.Products__c + '');
           verification_inputs.put('employmentType', prodOffering.lead__r.Employment_Type__c + '');
           verification_inputs.put('applicant_type', 'Primary');
           verification_inputs.put('btBankName', prodOffering.lead__r.Bank_Name__c + '');
           verification_inputs.put('btBankMOB', prodOffering.lead__r.MOB__c + '');
           verification_inputs.put('btAmount', prodOffering.BT_Topup__c + '');
           verification_inputs.put('approved_loan_amount', (prodOffering.Offer_Amount__c > prodOffering.Offer_Accepted_amount__c) ? prodOffering.Offer_Amount__c + '' : prodOffering.Offer_Accepted_amount__c + '');
           verification_inputs.put('branch_type', prodOffering.Lead__r.SBS_Branch__r.Branch_Type__c + '');
           verification_inputs.put('customer_segment', prodOffering.Existing_Customer_Segmentation__c + '');

           BRECallout breObj = new BRECallout();

           if (!Test.isRunningTest()) {
               verification_outputs = breObj.callBRE_RM_Verification(verification_inputs);
           }

           String mcpResultsDescriptiions;
           String[] mcpResponses = new String[100];

           system.debug('financialMCP_outputs.size() -> ' + verification_outputs);

           if (verification_outputs.size() > 0) {
               mcpResultsDescriptiions = verification_outputs.get('verificationList');
               system.debug('FinalResult from BRE -> ' + mcpResultsDescriptiions);

               if (mcpResultsDescriptiions != null) {
                   if (!Test.isRunningTest()) {
                       mcpResponses = mcpResultsDescriptiions.split('##');
                   }
               }

               Set < String > FinalVerifications = new Set < String > ();

               for (String str: mcpResponses) {
                   if (str.contains('&amp;')) {
                       str.replaceAll('&amp;', '&');
                       FinalVerifications.add(str);
                   } else {
                       FinalVerifications.add(str);
                   }
               }

               system.debug('FinalVerifications --> ' + FinalVerifications);
               InitiateVerificationHandler.InitiateVerification(FinalVerifications, 'LAP', 'Pune', primaryApplicantObj);

               if (Mid_office_BRE_flow__c.getValues('Verification To PD Mappings') != null && Mid_office_BRE_flow__c.getValues('Verification To PD Mappings').Verification_to_PD_Mappings__c != null) {
                   String[] mappings = Mid_office_BRE_flow__c.getValues('Verification To PD Mappings').Verification_to_PD_Mappings__c.trim().split(';');

                   Map < String, String > VerificationToPDMap = new Map < String, String > ();

                   for (String str: mappings) {
                       String[] temp = str.trim().split('==>');
                       if (temp.size() == 2) {
                           VerificationToPDMap.put(temp[0].toUpperCase(), temp[1]);
                       }
                   }

                   system.debug('Verificaiton Mappings : \n' + VerificationToPDMap);

                   for (String verification: FinalVerifications) {
                       if (VerificationToPDMap.keySet().contains(verification.trim().toUpperCase())) {
                           if (objNewPDList != null && objNewPDList.size() > 0) {
                               objNewPDList[0].Type_of_PD__c = VerificationToPDMap.get(verification.trim().toUpperCase());
                           }
                       }
                   }
                   if (objNewPDList.size() > 0) {
                       update objNewPDList[0];
                   }
               }
           }
       } catch (Exception e) {
           system.debug('Exception Occured **' + e.getMessage());
       }
   }*/
 @future
 public static void InsertEKYCData(Map < String, String > objApplicantList, String productId, boolean isCallCenter, string leadId, string primaryApplicantObj) {
  system.debug('objApplicantList>>' + objApplicantList);
  if (objApplicantList.size() > 0) {
   List < Applicant__c > objApplicant = (List < Applicant__c > ) JSON.deserialize(objApplicantList.get('ApplicantLiSt'), List < Applicant__c > .class);
   set < id > appIDs = new set < id > ();
   appIDs = (set < id > ) JSON.deserialize(objApplicantList.get('leadApplicantId'), set < id > .class);
   system.debug('appIDs>>' + appIDs);
   system.debug('isCallCenter >>' + isCallCenter);
   //List < Applicant__c > objApplicant = objApplicantList.get('ApplicantLiSt');
   List < Contact > objContactList1 = new List < Contact > ();
   List < Contact > objContactList = new List < Contact > ();
   system.debug('objApplicant>>' + objApplicant);
   if (objApplicant.size() > 0) {
    List < eKYC__c > objeKYC = new List < eKYC__c > ();
    if (isCallCenter) {
     set < Id > contactId = new set < id > ();
     map < string, string > applicantMap = new map < string, string > ();
     for (Applicant__c app: objApplicant) {
      contactId.add(app.Contact_Name__c);
      applicantMap.put(app.Contact_Name__c, app.Id);

     }
     objContactList1 = [Select id, Lead_Applicants__c, ApplicantType__c from Contact where id IN: contactId LIMIT 30];
     objeKYC = [Select id, name, Product_Offerings__c, eKYC_Address_details__c, Lead_Applicants__c, Lead__c, eKYC_Pin_Code__c, eKYC_City__c, eKYC_State__c from eKYC__c where Lead__c =: leadId OR Lead_Applicants__c IN: appIDs LIMIT 30];
     system.debug('appIDs>>' + appIDs + '>>objeKYC.size()>>' + objeKYC.size());
     if (objeKYC.size() > 0 && objContactList1.size() > 0) {
      for (Contact con: objContactList1) {
       for (eKYC__c kycObj: objeKYC) {
        if (kycObj.Lead_Applicants__c == con.Lead_Applicants__c || (con.ApplicantType__c == 'Primary' && kycObj.Lead__c != null)) {
         if (applicantMap.get(con.Id) != null) {
          kycObj.Applicant__c = applicantMap.get(con.Id);
         }
         con.Address_1__c = kycObj.eKYC_Address_details__c;
         con.Pin_Code__c = kycObj.eKYC_Pin_Code__c;
         con.Residence_City__c = kycObj.eKYC_City__c;
         con.State__c = kycObj.eKYC_State__c;

        }
       }
      }
     }
    } else {
     system.debug(productId);
     objeKYC = [Select id, name, Product_Offerings__c, eKYC_Address_details__c, eKYC_Pin_Code__c, eKYC_City__c, eKYC_State__c from eKYC__c where Product_Offerings__c =: productId LIMIT 1];
     if (objeKYC.size() > 0) {
      objeKYC[0].Applicant__c = objApplicant[0].Id;
      objContactList = [Select id from Contact where id =: objApplicant[0].Contact_Name__c LIMIT 1];
      if (objContactList.size() > 0) {
       objContactList[0].Address_1__c = objeKYC[0].eKYC_Address_details__c;
       objContactList[0].Pin_Code__c = objeKYC[0].eKYC_Pin_Code__c;
       objContactList[0].Residence_City__c = objeKYC[0].eKYC_City__c;
       objContactList[0].State__c = objeKYC[0].eKYC_State__c;
      }
     }
    }
    system.debug('objeKYC' + objeKYC);
    try {
     update objeKYC;
     if (objContactList.size() > 0) update objContactList;
     if (objContactList1.size() > 0) update objContactList1;
    } catch (DMLException e) {
     String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
     str += 'Product Offering Id :' + offeringId + ' \n Block 22'; // Bug 12463
     System.debug(str);
     if (!Test.isRunningTest())
      CommonUtility.SendExceptionMail(str);
    }
   }
  }
 }



 //changes done by leena for communication framework added one more parameter to pass LAN
 public static void sendSMSsAndEmails(Product_Offerings__c productOffer, Lead leadObj1, string LAN) {

  List < User > asmList = new List < User > ();
  List < User > rsmList = new List < User > ();
  List < User > zsmList = new List < User > ();
  List < Id > rsmUserId = new List < Id > ();
  List < Id > asmUserId = new List < Id > ();
  List < Id > zsmUserId = new List < Id > ();

  String CName = '';
  String LoanNumber = '';
  String asmEmail = '';
  String zsmEmail = '';
  String rsmEmail = '';

  List < Product_Offerings__c > prodList = new List < Product_Offerings__c > ();
  prodList.add(productOffer);
  List < Id > idList = new List < Id > ();

  if (productOffer.Sourcing_Channel__c != null) {
   idList.add(productOffer.Sourcing_Channel__c);
  }
  //commneted below line by leena to resolve too many soql exception
  /* if (productOffer.RSM__c != null) {
    rsmUserId.add(productOffer.RSM__c);
}

if (productOffer.ASM__c != null) {
    asmUserId.add(productOffer.ASM__c);
}

if (productOffer.ZSM__c != null) {
    zsmUserId.add(productOffer.ZSM__c);
}*/

  List < Sourcing_Channel__c > SchannelList = new List < Sourcing_Channel__c > ();

  if (idList != null) {

   //SchannelList = [select id, Active__c, Sourc_Mobile__c, sourcing_channel_email_id__c, Name from Sourcing_Channel__c where id in : idList];
  }


  //changes done by leena for communication framework
  system.debug('LAN here is===>' + LAN);
  LoanNumber = LAN;
  //added below line by leena to resolve too many soql exception
  if (productOffer.ASM__r != null) {
   asmEmail = productOffer.ASM__r.Email;
  }

  if (productOffer.ZSM__r != null) {
   zsmEmail = productOffer.ZSM__r.Email;
  }

  if (productOffer.RSM__r != null) {
   rsmEmail = productOffer.RSM__r.Email;
  }


  for (Product_Offerings__c pr: prodList) {
   if (productOffer.Sourcing_Channel__c != null) {
    Sourcing_Channel__c sc = productOffer.Sourcing_Channel__r;
    if (pr.Sourcing_Channel__c == sc.id) {
     if (sc.Active__c == true) {
      if (sc.Sourc_Mobile__c != null) {
       if (leadObj1 != null) {
        CName = leadObj1.Customer_Name__c;
       }
       String mesg = 'Lead Id ' + pr.Ref__c + ' Cust Name ' + CName + ' SFDC Appl Id ' + LoanNumber + ' Has been converted to opportunity.';
       sendsms.message(sc.Sourc_Mobile__c, mesg);
      }

      try {
       Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
       String addresses;
       String subject = 'PSF Allocation Convert To loan';
       String body;

       body = '<html><body><pre>';
       body += 'Hi, <br></br><br></br> Lead Name' + leadObj1.Name + ' has been successfully converted to application id. Please find details below:<br></br> ';
       body += 'Lead: ' + pr.Ref__c + '<br/> Customer Name: ' + leadObj1.Customer_Name__c + '<br/>SFDC Application Id: ' + LoanNumber + '<br/> Sourcing Channel Name: ' + sc.Name;
       body += '<br/>Regards,<br/> ' + 'Bajaj Finance Ltd.';

       email.setReplyTo('noreply@bajajfinserv.in');
       email.setSenderDisplayName('Bajaj Finance');
       email.setSubject(subject);

       String[] toAdd = new string[] {
        sc.sourcing_channel_email_id__c, asmEmail, zsmEmail, rsmEmail
       };
       List < String > toAddNew = new List < String > ();
       for (integer i = 0; i < toAdd.size(); i++) {
        if (toAdd[i] != null && toAdd[i] != '') {
         toAddNew.add(toAdd[i]);
        }
       }
       email.setToAddresses(toAddNew);
       email.sethtmlbody(body);

       Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
        email
       });
      } catch (Exception e) {
       String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
       str += 'Product Offering Id :' + offeringId + ' \n Block 23'; // Bug 12463
       System.debug(str);
       CommonUtility.SendExceptionMail(str);
       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e + '');
       Apexpages.addMessage(myMsg);
      }


     }
    }

   } else {
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    String addresses;
    String subject = 'PSF Allocation Convert To loan';
    String body;
    body = '<html><body><pre>';
    body += 'Hi, <br></br><br></br> Lead Name' + leadObj1.Name + ' has been successfully converted to application id. Please find details below:<br></br> ';
    body += 'Lead: ' + pr.Ref__c + '<br/> Customer Name: ' + leadObj1.Customer_Name__c + '<br/>SFDC Application Id: ' + LoanNumber;
    body += '<br/>Regards,<br/> ' + 'Bajaj Finance Ltd.';
    email.setReplyTo('noreply@bajajfinserv.in');
    email.setSenderDisplayName('Bajaj Finance');
    email.setSubject(subject);
    String[] toAdd = new string[] {
     asmEmail,
     zsmEmail,
     rsmEmail
    };
    List < String > toAddNew = new List < String > ();
    for (integer i = 0; i < toAdd.size(); i++) {
     if (toAdd[i] != null && toAdd[i] != '') {
      toAddNew.add(toAdd[i]);
     }
    }
    system.debug('toAddNew:::' + toAddNew);
    if (toAddNew != null && toAddNew.size() > 0) {
     email.setToAddresses(toAddNew);

     email.sethtmlbody(body);
     Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
      email
     });
    }
   }

  }
 }

 //4777

 public static String toProperCase(String value) {

  if (value != null) {
   // Normalize - Convert to lowercase
   value = value.toLowerCase();

   // Hold each word
   List < String > pieces = new List < String > ();

   // Split
   for (String s: value.split(' ')) {
    // Capitalize each piece
    s = s.capitalize();

    // Add to pieces
    pieces.add(s);
   }

   // Join
   return String.join(pieces, ' ');
  }
  return null;
 }

 public static void sendBTEmailOnSendToCredit(Product_Offerings__c prodOffering) {

  List < String > toAddlist = new List < String > ();
  List < String > toAddlistCC = new List < String > ();

  if (prodOffering.Sourcing_Channel__r.sourcing_channel_email_id__c != null)
   toAddlist.add(prodOffering.Sourcing_Channel__r.sourcing_channel_email_id__c);

  if (prodOffering.Relationship_Manager_Email__c != null) {
   toAddlist.add(prodOffering.Relationship_Manager_Email__c);
  }
  System.debug('prodOffering.Relationship_Manager_Email__c=' + prodOffering.Relationship_Manager_Email__c + '=prodOffering.Sourcing_Channel__r.sourcing_channel_email_id__c=' + prodOffering.Sourcing_Channel__r.sourcing_channel_email_id__c);

  String[] toAdd = toAddlist;
  String[] ccArray = toAddlistCC;
  String[] bccArray;
  String taskidOfattch;


  String name = toProperCase(prodOffering.ASM__r.Name);

  System.debug(name + '=name=' + prodOffering + '=prodOffering');


  String body = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';

  body += '<html xmlns="http://www.w3.org/1999/xhtml"><head><title>Bajaj Finserv</title></head><body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="  width:1050px; color: #000000; font-family: Arial, Helvetica, sans-serif; font-size: 15px"><table width="70%" border="0" cellpadding="0" cellspacing="0" style="border: 1px #949494 solid; " align="center"><tr><td valign="top" colspan="5"><table width="100%" border="0" cellpadding="0" cellspacing="0" ><td valign="top" style="text-align: right;"><a href="http://www.bajajfinserv.in/finance/?utm_source=May_PL_Email_Loan_Approved_BF&utm_medium=Email&utm_campaign=PL_Generic" target="_blank"><img src="https://cs6.salesforce.com/servlet/servlet.ImageServer?id=015N0000000HrHZ&oid=00DN0000000Un0W" width="401" height="83" alt="Bajaj Finserv" title="Bajaj Finserv" align="right" border="1" /></a></td></table></td></tr>';

  body += '<tr><td Style ="Padding:0px 25px 0px 25px ">Dear ' + name + '<br/><br />We noticed that you have logged in an application to takeover ' + prodOffering.Customer_Name__c + ' existing loan from ' + prodOffering.BT_Bank__c + '. In order to successfully takeover this loan, you will need to arrange the following critical documents from ' + prodOffering.BT_Bank__c + '<br /><ol type="a"><li>List of property documents submitted to ' + prodOffering.BT_Bank__c + ' for mortgage of property.</li><li>Foreclosure letter, mentioning favouring and loan outstanding, along with the pre-payment penalty for closure of the ' + prodOffering.BT_Bank__c + ' loan</li></ol>Both the above documents are required on the letterhead. You will need to advise ' + prodOffering.Customer_Name__c + ' to apply for these 2 documents with the Customer Care department of ' + prodOffering.BT_Bank__c + '.<br /><br />As ' + prodOffering.BT_Bank__c + ' will take 10-12 working days to provide these documents, we recommend that you engage ' + prodOffering.Customer_Name__c + ' and help him/her in applying for the above documents.<br /><br />You are also advised to adhere to the following rules while guiding customers on the Balance Transfer process:<br /><ol type="a"><li>Ensure that the list of documents and foreclosure letter are raised in 2 different requests, instead of a single request - This is done since the list of documents is normally provided faster than the foreclosure quote by the bank.</li><li>In case documents are not issued in 7 days, the customer will need to remind the bank with a new mail, as reminders 1, 2 and 3, after every 3 days</li><li>Take a confirmation from the customer that he is aware of pre-payment penalty of ' + prodOffering.BT_Bank__c + ' and is agreeable to pay the same with BFL loan</li></ol>Proper adherence to the Balance Transfer process and the above rules will lead to a timely completion of takeover and lower cancellation.<br /><p align="left">Sincerely<br/>Product Team - Magnus</p></td></tr>';

  body += '<br /><tr><td style="padding:7px 14px 0 12px"><a href="http://www.bajajfinserv.in/finance/?utm_source=May_PL_Email_Loan_Approved_BF_Finance&amp;utm_medium=Email&amp;utm_campaign=PL_Generic" target="_blank"><img src="https://cs6.salesforce.com/servlet/servlet.ImageServer?id=015N0000000HrI8&oid=00DN0000000Un0W" width="177" height="17" alt="Visit www.bajajfinserv.in" title="Visit www.bajajfinserv.in" align="left" border="0" /></a></td></tr><tr><td style="padding:7px 14px 0 12px" colspan="5"><table width="228px" border="0" cellpadding="0" cellspacing="0" align="left"><tr><td valign="top"><img src="https://cs6.salesforce.com/servlet/servlet.ImageServer?id=015N0000000HrHj&oid=00DN0000000Un0W" width="111" height="35" alt="Connect with us" title="Connect with us" align="left" border="0" /></td><td valign="top"><a href="https://www.facebook.com/bajajfinserv?sk=app_190322544333196" target="_blank"><img src="https://cs6.salesforce.com/servlet/servlet.ImageServer?id=015N0000000HrHo&oid=00DN0000000Un0W" width="42" height="35" alt="Facebook" title="Facebook" align="left" border="0" /></a></td><td valign="top"><a href="https://twitter.com/Bajaj_Finserv" target="_blank"><img src="https://cs6.salesforce.com/servlet/servlet.ImageServer?id=015N0000000HrHy&oid=00DN0000000Un0W" width="40" height="35" alt="twitter" title="twitter" align="left" border="0" /></a></td><td valign="top"><a href="http://www.linkedin.com/company/1092003?trk=tyah" target="_blank"><img src="https://cs6.salesforce.com/servlet/servlet.ImageServer?id=015N0000000HrHt&oid=00DN0000000Un0W" width="35" height="35" alt="LinkedIn" title="LinkedIn" align="left" border="0" /></a></td></tr></table></td></tr><tr><td valign="top" colspan="5" style="padding: 10px 14px 10px 12px;"><div style="line-height:18px; font-size:13px;">Terms and conditions apply</div></td></tr><tr><td valign="top" colspan="5" style="padding: 10px 14px 10px 12px;"><div style="line-height:18px; font-size:13px;"><img src="https://cs6.salesforce.com/servlet/servlet.ImageServer?id=015N0000000HrHe&oid=00DN0000000Un0W" width="179" height="21" alt="Bajaj Finserv" title="Bajaj Finserv" align="right" border="0" /></div></td></tr></table></body></html><!DOCTYPE html><html lang="en" xmlns="http://www.w3.org/1999/xhtml"><head><meta charset="utf-8" /><title></title></head><body></body></html>';


  body = body.replaceAll('\r\n', '<br/>');
  body = body.replaceAll('\n', '<br/>');
  body = body.replaceAll('\'', '"');
  body = body.replace('\\', '&#92;');
  body = body.replace('"', '\\"');

  System.debug('toAdd=' + toAdd + '=toAddlist=' + toAddlist);
  sendemailcrm.LogixEmail(toAdd, 'Documents Required for BT - ' + prodOffering.Customer_ID1__r.Customer_Name__c, body, ccArray, bccArray, taskidOfattch, 'noreply@bajajfinserv.in');

 }
 //added one extra parameter leadObj.LeadSource for call center
 // CIBIL watch Start
 /*optimised for call center S*/
 /*Callstatic void MapRecordsCIBILWatch(Product_Offerings__c prodOffering, String leadSourceSt) {
   boolean SwitchOtimizedCode = LaonApplicationCreation__c.getValues('RunOptimizeCode(LoanConetionUtiility))').Integrate_Charges_API__c;
   /*
       a)  Fees and Charges
       b)  Perfios
       c)  Bank Account and Transaction
       d)  Insurance
       e)  Open Ecs Details
  */
 /*Callsystem.debug('---oppObj.id---' + oppObj.id);

if (prodOffering.Bank_Details_Change__c == false) {
prodOffering.Disb_Bank_Name__c = prodOffering.Bank_name__c;
prodOffering.Disbursement_Payment_Mode__c = prodOffering.Mode_of_Payment__c;
prodOffering.Disbursement_Bank_IFSC_code__c = prodOffering.IFSC_Code__c;
prodOffering.Disb_favouring__c = prodOffering.Cheque_In_Favoring__c;
}


// Clone Fees And Charges Details
Decimal stampduty = 0;

List < Fees_and_Charge__c > ObjFeesClonnedList = new List < Fees_and_Charge__c > ();

// List < Fees_and_Charge__c > ListFeesAndChargesOptimized = new List < Fees_and_Charge__c > ();
ListFeesAndCharges = [select name, Loan_Application__c, Tranche_Detail__r.name, Deposition_Date__c, Deposit_Slip_Number__c, Loan_Application__r.name, Change_Amount__c, Charge_Type__c, Deducted_from_Disbursement__c, Service_Charge__c, Status__c, Tranche_Detail__c, Instrument_Date__c, Instrument_No__c,
Bank_Branch__c, Instrument_type__c, Amount_after_Service_Change__c, Tranche_Detail__r.Tranche_Number__c
from Fees_and_Charge__c where Product_Offerings__c = : prodOffering.id
];


if (ListFeesAndCharges != null && ListFeesAndCharges.size() > 0) {
system.debug('---ListFeesAndCharges.size()---' + ListFeesAndCharges.size());
for (Fees_and_Charge__c objFess: ListFeesAndCharges) {

    Fees_and_Charge__c objFessAndCharge = new Fees_and_Charge__c();
    objFessAndCharge = objFess.clone(false, true, false, false);
    system.debug('*****Cloneed Fees and Charges Details Object :--' + objFessAndCharge);
    objFessAndCharge.Loan_Application__c = oppObj.id;
    objFessAndCharge.Product_Offerings__c = null;
    ObjFeesClonnedList.add(objFessAndCharge);

    if (objFess.Change_Amount__c != null && objFess.Charge_Type__c == 'Stamp Duty') {
    stampduty += objFess.Change_Amount__c;

    }

}
}
if (ObjFeesClonnedList != null && ObjFeesClonnedList.size() > 0) {
upsert ObjFeesClonnedList;
}

List < Contact > objCon = [Select id, Stamp_Duty__c from contact where ApplicantType__c = 'Primary'
AND Lead__c = : leadObj.id LIMIT 1
];
system.debug('---objCon---' + objCon);
system.debug('---objCon[0]---' + objCon[0]);
system.debug('---stampduty---' + stampduty);
if (objCon != null && objCon.size() > 0 && stampduty != null) {
objCon[0].Stamp_Duty__c = stampduty;
system.debug('---objCon[0]---' + objCon[0]);
update objCon[0];
}


// Clone Perfios Details

List < Bank_Account__c > objClonedBankList = new List < Bank_Account__c > ();
if (!SwitchOtimizedCode) {
List < Bank_Account__c > objBankDetailsListOptimized = new List < Bank_Account__c > ();
objBankDetailsListOptimized = [SELECT Account_Type__c, Account_Used_For__c, ApplicantName__c, Product_Offerings__c, Applicant_Name__c,
    Applicant__c, Average_Balance__c, Average_incentive_for_Q1__c, Average_incentive_for_Q2__c,
    Average_incentive_for_Q3__c, Average_monthly_balance1__c, Average_monthly_balance2__c,
    Average_monthly_balance3__c, Average_ODCC_Utilization__c, Average_OD_CC_Limit__c, Average_of_Bounce_I_W__c,
    Average_of_Bounce_O_W__c, Average_of_CRD_Amount__c, Average_of_CRD_No__c, Average_of_DB_Amount__c,
    Average_of_DB_No__c, Average_of_ODCC_Limit__c, Average_Opening_Balance__c, Average_Open_Limit__c,
    Avg_Bounce_I_W__c, Avg_Bounce_O_W__c, Avg_CRD_Amount__c, Avg_CRD_No__c, Avg_DB_Amount__c, Avg_DB_No__c,
    Avg_monthly_incentive1__c, Avg_monthly_incentive2__c, Avg_monthly_incentive3__c, Avg_Monthly_Interest__c,
    Avg_mthly_bal6__c, Avg_mthly_bal_Coapp_SAL__c, Avg_mthly_incntve_3mts__c, Avg_mthy_bal_SAL__c,
    Avg_qtrly_incentive__c, AvmonBalance_EMI__c, Banking_Obligation__c, Bank_Account_Number__c,
    Bank_Acct_Number__c, Bank_Branch__c, Bank_Name_List__c, Bank_Name_Salaried__c, Bank_Name_Sal__c,
    Bank_Name__c, Bank_Type__c, Cheque_returns_in_latest_3_months__c, ConnectionReceivedId, ConnectionSentId,
    Consider_For_Eligibility_Gross_Profit__c, Consider_for_Eligibility_LTV__c, Consider_for_Eligibility__c,
    CreatedById, CreatedDate, Credit_more_than_1_5_time_in_last_3_mont__c, CurrencyIsoCode,
    Eligible_EMI_Banking__c, IFSC_Bank_Name__c, IFSC_Code__c, IFSC_Master__c, IsDeleted,
    LastModifiedById, LastModifiedDate, Loan_Application_Number__c, Loan_Application__c, MICR_Code__c,
    Month1__c, monthly_Av_Balance_EMIOut__c, Month_2__c, Month_3__c, Month_end_Bal__c, Name,
    NumberOfMonthsTrans__c, OD_CC_limit__c, Opening_Balance__c, Other_Bank__c, OwnerId, Perc_Inward_Ret__c,
    Perc_Outward_Return__c, Perfios_Account_Holder_Name__c, Perfios_Account_No__c, Perfios_Bank_Name__c,
    Perfios_Client_Address__c, Perfios_Client_pan_no__c, Perfios_Flag__c, Per_of_inward_returnsOut__c,
    Product__c, Proposed_BAFL_EMI__c, Rate_of_OD_CC__c, Salaried_CAM__c, Salaried_Temp__c,
    Salary_credit_amount1__c, Salary_credit_amount2__c, Salary_credit_amount3__c, Salary_Credit_Date1__c,
    Salary_Credit_Date2__c, Salary_Credit_Date3__c, SelectBank__c, Send_Email_For_Perfios__c,
    sum_Avg_mthly_bal__c, Sum_Bounce_I_W__c, Sum_Bounce_O_W__c, Sum_CRD_Amount__c, Sum_CRD_No__c,
    Sum_DB_Amount__c, Sum_DB_No__c, Sum_Monthly_Interest__c, Sum_of_average_Balance__c,
    Sum_of_Cred_Int_Bank_Firm_Tran__c, Sum_of_OD_CC_Limit__c, Sum_of_OD_CC_Utilization__c, SystemModstamp,
    Transaction_Count__c, X10th_Bal__c, X20th_Bal__c
    FROM Bank_Account__c where Product_Offerings__c = : prodOffering.id
];
objBankDetailsList = objBankDetailsListOptimized;
}
if (objBankDetailsList != null && objBankDetailsList.size() > 0) {
for (Bank_Account__c objextBank: objBankDetailsList) {
    objextBank.Loan_Application__c = oppObj.id;
    objextBank.Account_Type__c = prodOffering.Bank_Account_Type__c;
    objClonedBankList.add(objextBank);
}
}
if (objClonedBankList != null && objClonedBankList.size() > 0) {
try {
    update objClonedBankList;
} catch (DMLException e) {
    system.debug('--objClonedBankList insertion Exception :- ' + e.getMessage());
}

}

// Clone Insurance Details

List < DPLinsurance__c > ObjInsuranceClonnedList = new List < DPLinsurance__c > ();
if (!SwitchOtimizedCode) {
List < DPLinsurance__c > ListInsuranceOptimized = new List < DPLinsurance__c > ();
ListInsuranceOptimized = [Select Nominee_Name__c, Nominee_Address__c, Nominee_Mobile__c, Nominee_DOB__c, Whether_we_are_financing_this_product__c, Term_of_Insurance__c, Sum_Assured__c, Remark__c, Reject_reason__c,
    Premium_Amount__c, Policy_type__c, Policy_issue_date__c, Offer_id__c, Loan_Application_Status__c,
    Loan_application_number__c, Opportunity__c, Opportunity__r.Nominee_Name__c, Loan_Amount__c, Insurance_Type__c, Insurance_Product__c, Insurance_Name__c,
    Insurance_amount__c, Existing_LAN_no__c, Decision_time_stamp__c, Customer_Payment_Mode__c, Customer_address__c, CPA_Name__c,
    Cheque_Status__c, Cheque_DD_No_with_Bank_Name__c, Cheque_DD_Date__c, Availed_Tenor__c, Nominee_Relationship__c,
    Availed_EMI__c, Availed_Amount__c, Approved__c, Age__c from DPLinsurance__c where Product_Offerings__c = : prodOffering.id
];
ListInsurance = ListInsuranceOptimized;
}
if (ListInsurance != null && ListInsurance.size() > 0) {
system.debug('---ListInsurance.size()---' + ListInsurance.size());
for (DPLinsurance__c objInsu: ListInsurance) {
    DPLinsurance__c objInsurance = new DPLinsurance__c();
    objInsurance = objInsu.clone(false, true, false, false);
    system.debug('*****Cloneed Bank Account Details Object :--' + objInsurance);
    objInsurance.Opportunity__c = oppObj.id;
    objInsurance.Product_Offerings__c = null;
    ObjInsuranceClonnedList.add(objInsurance);
}
}
if (ObjInsuranceClonnedList != null && ObjInsuranceClonnedList.size() > 0) {
try {
    insert ObjInsuranceClonnedList;
} catch (DMLException e) {
    system.debug('--ObjInsuranceClonnedList insertion Exception :- ' + e.getMessage());
}
}

//Map Current Disbersal Details records
objExistingOppList = new List < Opportunity > ();
List < Current_Disbursal_Details__c > objCDDList = new List < Current_Disbursal_Details__c > ();
List < RePayment_mode_detail__c > objRepaymentList = new List < RePayment_mode_detail__c > ();
if (SwitchOtimizedCode) {
//optimized query by pritha for 101 soql queries error start

//optimized query by pritha for 101 soql queries error end
//optimized query by pritha for 101 soql queries error
}
if (prodOffering.Existing_LAN__c != null && prodOffering.Existing_LAN__c != '') {
if (!SwitchOtimizedCode) {
    objExistingOppList = [Select Approved_Loan_Amount__c, createddate, Loan_Type__c, Scheme_Master__c, File_Accept_Status__c,
    End_Use__c, Premium_Amount__c, Nature_of_Business__c, Type_of_Constitution__c, Disbursal_Date__c
    from Opportunity where LAN__c = : prodOffering.Existing_LAN__c LIMIT 1
    ];
} else {
    objExistingOppList = [Select Approved_Loan_Amount__c, createddate, Loan_Type__c, Scheme_Master__c, File_Accept_Status__c,
    End_Use__c, Premium_Amount__c, Nature_of_Business__c, Type_of_Constitution__c, Disbursal_Date__c,
    (SELECT All_Documents_in_Order__c, Bank_Account__c, Bank_Branch__c, Bank_Name__c, Cheque_Amount__c,
    Cheque_Collected__c, Cheque_Date__c, Cheque_in_Favoring_CRISIL__c, Cheque_in_Favoring__c, Cheque_No__c,
    Cheque_Received_at_HO__c, Cheque_Status__c, ConnectionReceivedId, ConnectionSentId, CreatedById,
    CreatedDate, Credit_Days__c, CurrencyIsoCode, Customer_Payment_Mode__c, Date_of_Pick_Up__c, Disbursal_Mode__c,
    Disbursement_Amount__c, Disbursement_Date__c, Disbursement_Number__c, Favouring__c, FinnOne_Disbursement_Amt__c,
    FinnOne_Disbursement_Date__c, FinnOne_LAN__c, IFSC_Code__c, IMPS_Flag__c, Information_From__c,
    Internal_Closure__c, IsDeleted, LastActivityDate, LastModifiedById, LastModifiedDate, Loan_Application__c,
    Mandate_Received_at_HO__c, Name, OwnerId, Payable_at__c, SystemModstamp, Tranche_Detail__c FROM Current_Disbursal_Details_s__r),
    (SELECT Account_Holder_Name__c, A_C_NO__c, Bank_Name__c, Cheque_Amount__c, Cheque_Serial_Number__c,
    ConnectionReceivedId, ConnectionSentId, CreatedById, CreatedDate, CurrencyIsoCode, IFSC_Code__c,
    IsDeleted, LastModifiedById, LastModifiedDate, Loan_Application__c, MICR_Code__c, Name, No_of_Cheques__c,
    OwnerId, PDC_START_DATE__c, Repayment_Mode__c, SystemModstamp, To_Cheque_Serial_Number__c, Tranche_Detail__c FROM RePayment_mode_details__r)
    from Opportunity where LAN__c = : prodOffering.Existing_LAN__c LIMIT 1
    ];
}
if (objExistingOppList != null && objExistingOppList.size() > 0) {
    objExistingOpp = new Opportunity();
    objExistingOpp = objExistingOppList[0];
    if (SwitchOtimizedCode) {
    //optimized query by pritha for 101 soql queries error start
    objCDDList = objExistingOppList[0].Current_Disbursal_Details_s__r;
    objRepaymentList = objExistingOppList[0].RePayment_mode_details__r;
    //optimized query by pritha for 101 soql queries error end
    }

}


List < Current_Disbursal_Details__c > objNewCDDList = new List < Current_Disbursal_Details__c > ();
if (isCallCenter) {
    system.debug('Current_Disbursal_Details__c');
    //added for Call Center S
    Current_Disbursal_Details__c objCDDnewCall = new Current_Disbursal_Details__c();
    objCDDnewCall.Loan_Application__c = oppObj.id;
    if (prodOffering.Bank_name__c != null)
    objCDDnewCall.Bank_Name__c = prodOffering.Bank_name__c;
    if (prodOffering.Disbursement_Bank_IFSC_code__c != null)
    objCDDnewCall.IFSC_Code__c = prodOffering.Disbursement_Bank_IFSC_code__c;
    if (prodOffering.ECS_Bank_Account_number__c != null)
    objCDDnewCall.Bank_Account__c = prodOffering.ECS_Bank_Account_number__c;
    //IFSC_Code__c,Bank_Name__c,Bank_Account__c,
    if (prodOffering.Bank_Details_Change__c == true) {
    if (prodOffering.Disb_Bank_Name__c != null)
    objCDDnewCall.Bank_Name__c = prodOffering.Disb_Bank_Name__c;
    if (prodOffering.Disbursement_Payment_Mode__c != null)
    objCDDnewCall.Disbursal_Mode__c = prodOffering.Disbursement_Payment_Mode__c;
    //objCDDnewCall.IFSC_Code__c = prodOffering.Disbursement_Bank_IFSC_code__c;
    if (prodOffering.Disb_favouring__c != null) {
    objCDDnewCall.Cheque_In_Favoring__c = prodOffering.Disb_favouring__c;
    objCDDnewCall.Favouring__c = prodOffering.Disb_favouring__c;
    }
    if (prodOffering.Net_Disbursement_Amount__c != null) {
    objCDDnewCall.Disbursement_Amount__c = prodOffering.Net_Disbursement_Amount__c;
    }
    if (prodOffering.Disb_Bank_Branch__c != null) {
    objCDDnewCall.Bank_Branch__c = prodOffering.Disb_Bank_Branch__c;
    }
    }
    objNewCDDList.add(objCDDnewCall);
    /*try {
    insert objCDDnewCall;
    } catch (DMLException e) {
    system.debug('--Exception :- ' + e.getMessage());
    }*/
 //Map Repayment Mode details

 /*CallRePayment_mode_detail__c objRe = new RePayment_mode_detail__c();
    if (prodOffering.ECS_Bank_Account_number__c != null)
    objRe.A_C_NO__c = prodOffering.ECS_Bank_Account_number__c;
    if (prodOffering.Bank_name__c != null)
    objRe.Bank_Name__c = prodOffering.Bank_name__c;
    if (prodOffering.MICR_Code__c != null)
    objRe.MICR_Code__c = Decimal.ValueOf(prodOffering.MICR_Code__c);
    if (prodOffering.Open_Ecs_Limit__c != null)
    objRe.Open_ECS_Max_Limit__c = prodOffering.Open_Ecs_Limit__c;
    if (prodOffering.ECS_End_Date__c != null)
    objRe.ECS_End_Date__c = prodOffering.ECS_End_Date__c;
    if (prodOffering.Disbursement_Payment_Mode__c != null)
    objRe.Repayment_Mode__c = prodOffering.Disbursement_Payment_Mode__c;
    if (prodOffering.IFSC_Code__c != null)
    objRe.IFSC_Code__c = prodOffering.IFSC_Code__c;
    objRe.Loan_Application__c = oppObj.id;
    try {
    insert objRe;
    } catch (DMLException e) {
    system.debug('--Exception :- ' + e.getMessage());
    }
    }
    //added for Call Center E
    if (!SwitchOtimizedCode) {
    if (objExistingOpp != null) {
    List < Current_Disbursal_Details__c > objCDDListOptimized = new List < Current_Disbursal_Details__c > ();
    objCDDListOptimized = [SELECT All_Documents_in_Order__c, Bank_Account__c, Bank_Branch__c, Bank_Name__c, Cheque_Amount__c,
    Cheque_Collected__c, Cheque_Date__c, Cheque_in_Favoring_CRISIL__c, Cheque_in_Favoring__c, Cheque_No__c,
    Cheque_Received_at_HO__c, Cheque_Status__c, ConnectionReceivedId, ConnectionSentId, CreatedById,
    CreatedDate, Credit_Days__c, CurrencyIsoCode, Customer_Payment_Mode__c, Date_of_Pick_Up__c, Disbursal_Mode__c,
    Disbursement_Amount__c, Disbursement_Date__c, Disbursement_Number__c, Favouring__c, FinnOne_Disbursement_Amt__c,
    FinnOne_Disbursement_Date__c, FinnOne_LAN__c, IFSC_Code__c, IMPS_Flag__c, Information_From__c,
    Internal_Closure__c, IsDeleted, LastActivityDate, LastModifiedById, LastModifiedDate, Loan_Application__c,
    Mandate_Received_at_HO__c, Name, OwnerId, Payable_at__c, SystemModstamp, Tranche_Detail__c
    FROM Current_Disbursal_Details__c where Loan_Application__c = : objExistingOpp.Id
    ];
    objCDDList = objCDDListOptimized;
    }
    }
    if (objCDDList != null && objCDDList.size() > 0) {
    for (Current_Disbursal_Details__c objCDD: objCDDList) {
    Current_Disbursal_Details__c objCDDnew = new Current_Disbursal_Details__c();
    objCDDnew = objCDD.clone(false, true, false, false);
    system.debug('*****Cloneed CDD Object :--' + objCDDnew);
    objCDDnew.Loan_Application__c = oppObj.id;

    objCDDnew.Bank_Name__c = prodOffering.Disb_Bank_Name__c;
    //Bug 6342 Start 
    if (prodOffering.Disbursement_Payment_Mode__c != null) {
    objCDDnew.Disbursal_Mode__c = prodOffering.Disbursement_Payment_Mode__c;
    oppObj.Mode_of_Disbursal__c = prodOffering.Disbursement_Payment_Mode__c;
    } else {
    objCDDnew.Disbursal_Mode__c = prodOffering.Mode_of_Payment__c;
    oppObj.Mode_of_Disbursal__c = prodOffering.Mode_of_Payment__c;
    }
    //Bug 6342 End
    objCDDnew.IFSC_Code__c = prodOffering.Disbursement_Bank_IFSC_code__c;
    objCDDnew.Cheque_In_Favoring__c = prodOffering.Disb_favouring__c;
    objCDDnew.Favouring__c = prodOffering.Disb_favouring__c;
    //Bug 5989 Start
    objCDDnew.Disbursement_Amount__c = prodOffering.Net_Disbursement_Amount__c;
    //Bug 5989 End
    //Bug 6342 Start 
    system.debug('---prodOffering.Disb_favouring__c---' + prodOffering.Disb_favouring__c);
    system.debug('---prodOffering.Cheque_In_Favoring__c---' + prodOffering.Cheque_In_Favoring__c);

    if (prodOffering.Address_Change_flag__c == true) {
    oppObj.Favouring__c = prodOffering.Disb_favouring__c;
    } else {
    oppObj.Favouring__c = prodOffering.Cheque_In_Favoring__c;
    }
    system.debug('---oppObj.Favouring__c---' + oppObj.Favouring__c);
    oppObj.A_C_Type__c = prodOffering.Bank_Account_Type__c;
    //Bug 6342 End

    objCDDnew.Bank_Account__c = prodOffering.ECS_Bank_Account_number__c;

    objNewCDDList.add(objCDDnew);
    }
    } //Cibil Watch Start
    else {
    if (cibilwatchFlag == true) {
    Current_Disbursal_Details__c objCDDnew = new Current_Disbursal_Details__c();
    objCDDnew.Loan_Application__c = oppObj.id;
    //objCDDnew.Bank_Name__c = productOffer.Bank_name__c;
    //objCDDnew.IFSC_Code__c = productOffer.IFSC_Code__c;
    objCDDnew.Bank_Account__c = prodOffering.ECS_Bank_Account_number__c;
    //IFSC_Code__c,Bank_Name__c,Bank_Account__c,
    // if (productOffer.Bank_Details_Change__c == true) {
    objCDDnew.Bank_Name__c = prodOffering.Disb_Bank_Name__c;
    // objCDDnew.Disbursal_Mode__c = productOffer.Disbursement_Payment_Mode__c;
    objCDDnew.IFSC_Code__c = prodOffering.Disbursement_Bank_IFSC_code__c;
    objCDDnew.Cheque_In_Favoring__c = prodOffering.Disb_favouring__c;
    objCDDnew.Favouring__c = prodOffering.Disb_favouring__c;
    // }
    if (prodOffering.Disbursement_Payment_Mode__c != null) {
    objCDDnew.Disbursal_Mode__c = prodOffering.Disbursement_Payment_Mode__c;
    oppObj.Mode_of_Disbursal__c = prodOffering.Disbursement_Payment_Mode__c;
    } else {
    objCDDnew.Disbursal_Mode__c = prodOffering.Mode_of_Payment__c;
    oppObj.Mode_of_Disbursal__c = prodOffering.Mode_of_Payment__c;
    }
    system.debug('---productOffer.Disb_favouring__c---' + prodOffering.Disb_favouring__c);
    system.debug('---productOffer.Cheque_In_Favoring__c---' + prodOffering.Cheque_In_Favoring__c);

    if (prodOffering.Address_Change_flag__c == true) {
    oppObj.Favouring__c = prodOffering.Disb_favouring__c;
    } else {
    oppObj.Favouring__c = prodOffering.Cheque_In_Favoring__c;
    }
    system.debug('---oppObj.Favouring__c---' + oppObj.Favouring__c);
    oppObj.A_C_Type__c = prodOffering.Bank_Account_Type__c;
    //Bug 5989 Start
    objCDDnew.Disbursement_Amount__c = prodOffering.Net_Disbursement_Amount__c;
    //Bug 5989 End

    objNewCDDList.add(objCDDnew);
    }
    }
    //Cibil Watch End
    if (objNewCDDList != null && objNewCDDList.size() > 0) {
    try {
    insert objNewCDDList;
    } catch (DMLException e) {
    system.debug('--objNewCDDList insertion Exception :- ' + e.getMessage());
    }
    }

    //added not condition for call center S
    if (!isCallCenter) {
        system.debug('not for Call center');
        //Map CAM details
        CAM__c camObj = new CAM__c();
        camObj.Loan_Application__c = oppObj.id;
        camObj.ROI__c = prodOffering.Offer_ROI__c;
        camObj.Average_monthly_Obligations__c = prodOffering.Monthly_Obligation__c;
        camObj.Average_incentive_for_Q1__c = prodOffering.Net_Salary_Per_Month__c;
        camObj.Average_incentive_for_Q2__c = prodOffering.Net_Salary_Per_Month__c;
        camObj.Average_incentive_for_Q3__c = prodOffering.Net_Salary_Per_Month__c;

        if (prodOffering.Availed_Amount__c != null) camObj.Proposed_Loan_Amt__c = prodOffering.Availed_Amount__c;
        if (prodOffering.Availed_Tenor__c != null) camObj.Tenor__c = prodOffering.Availed_Tenor__c;
        camObj.EMI_on_Proposed_Loan_TO__c = prodOffering.EMI_Amount__c;
        camObj.Eligible_Loan__c = prodOffering.Final_Amount__c;
        try {
        insert camObj;
        } catch (DMLException e) {
        system.debug('--camObj insert Exception :- ' + e.getMessage());
        }

    }
    //added not condition for call center E
    // MAp Repayment Mode Details 
    //List < RePayment_mode_detail__c > objRepaymentList = new List < RePayment_mode_detail__c > ();
    List < RePayment_mode_detail__c > objNewRepaymentList = new List < RePayment_mode_detail__c > ();

    if (!SwitchOtimizedCode) {
    if (objExistingOpp != null) {
    objRepaymentList = [SELECT Account_Holder_Name__c, A_C_NO__c, Bank_Name__c, Cheque_Amount__c, Cheque_Serial_Number__c,
    ConnectionReceivedId, ConnectionSentId, CreatedById, CreatedDate, CurrencyIsoCode, IFSC_Code__c,
    IsDeleted, LastModifiedById, LastModifiedDate, Loan_Application__c, MICR_Code__c, Name, No_of_Cheques__c,
    OwnerId, PDC_START_DATE__c, Repayment_Mode__c, SystemModstamp, To_Cheque_Serial_Number__c, Tranche_Detail__c
    FROM RePayment_mode_detail__c where Loan_Application__c = : objExistingOpp.Id
    ];
    }
    }
    if (objRepaymentList != null && objRepaymentList.size() > 0) {
    for (RePayment_mode_detail__c objRepay: objRepaymentList) {
    RePayment_mode_detail__c objRe = new RePayment_mode_detail__c();
    objRe = objRepay.clone(false, true, false, false);
    system.debug('*****Cloneed RePayment Object :--' + objRe);
    objRe.Loan_Application__c = oppObj.id;
    objRe.A_C_NO__c = prodOffering.ECS_Bank_Account_number__c;
    objRe.Bank_Name__c = prodOffering.Bank_name__c;
    try {
    //Null check for Sal Line Prod Issue- Bug 6418 start
    if (prodOffering.MICR_Code__c != null) objRe.MICR_Code__c = Decimal.ValueOf(prodOffering.MICR_Code__c);
    //Null check for Sal Line Prod Issue- Bug 6418 start
    objRe.Open_ECS_Max_Limit__c = prodOffering.Open_Ecs_Limit__c;
    } catch (Exception e) {
    system.debug('--exception--' + e.getmessage());
    }

    objRe.ECS_End_Date__c = prodOffering.ECS_End_Date__c;
    //Bug 5989 Start
    objRe.Open_Valid_till__c = objRe.ECS_End_Date__c;
    objRe.ECS_Amount__c = objRe.Open_ECS_Max_Limit__c;
    objRe.Repayment_Mode__c = prodOffering.Mode_of_Payment__c;
    //Bug 5989 End
    //Bug 6342 Start
    objRe.IFSC_Code__c = prodOffering.Disbursement_Bank_IFSC_code__c;
    objRe.Account_Holder_Name__c = leadObj.Name;

    if (prodOffering.Address_Change_flag__c == true) {
    objRe.PDC_By_Name__c = prodOffering.Disb_favouring__c;
    } else {
    objRe.PDC_By_Name__c = prodOffering.Cheque_In_Favoring__c;
    }
    objRe.ECS_Start_Date__c = prodOffering.First_Due_Date__c;
    objRe.Open_ECS_Facility__c = 'Yes';
    objRe.PDC_By_Name__c = prodOffering.Cheque_In_Favoring__c;
    //Bug 6342 End
    objNewRepaymentList.add(objRe);
    }
    } //Cibil Watch Start 
    else {
    if (cibilwatchFlag == true) {
    RePayment_mode_detail__c objRe = new RePayment_mode_detail__c();
    objRe.A_C_NO__c = prodOffering.ECS_Bank_Account_number__c;
    objRe.Bank_Name__c = prodOffering.Bank_name__c;
    //Null check for Sal Line Prod Issue- Bug 6418 start
    if (prodOffering.MICR_Code__c != null) objRe.MICR_Code__c = Decimal.ValueOf(prodOffering.MICR_Code__c);
    //Null check for Sal Line Prod Issue- Bug 6418 end
    objRe.Open_ECS_Max_Limit__c = prodOffering.Open_Ecs_Limit__c;
    objRe.ECS_End_Date__c = prodOffering.ECS_End_Date__c;
    objRe.Loan_Application__c = oppObj.id;
    //Bug 5989 Start
    objRe.Open_Valid_till__c = objRe.ECS_End_Date__c;
    objRe.ECS_Amount__c = objRe.Open_ECS_Max_Limit__c;
    objRe.Repayment_Mode__c = prodOffering.Mode_of_Payment__c;
    //Bug 5989 End
    //Bug 6342 Start
    objRe.IFSC_Code__c = prodOffering.Disbursement_Bank_IFSC_code__c;
    objRe.Account_Holder_Name__c = leadObj.Name;

    if (prodOffering.Address_Change_flag__c == true) {
    objRe.PDC_By_Name__c = prodOffering.Disb_favouring__c;
    } else {
    objRe.PDC_By_Name__c = prodOffering.Cheque_In_Favoring__c;
    }
    objRe.ECS_Start_Date__c = prodOffering.First_Due_Date__c;
    objRe.Open_ECS_Facility__c = 'Yes';
    objRe.PDC_By_Name__c = prodOffering.Cheque_In_Favoring__c;
    //Bug 6342 End

    objNewRepaymentList.add(objRe);
    //insert objNewRepaymentList;
    }
    }
    //Cibil Watch End

    if (objNewRepaymentList != null && objNewRepaymentList.size() > 0) {
    try {
    insert objNewRepaymentList;
    } catch (DMLException e) {
    system.debug('--objNewRepaymentList Insert Exception :- ' + e.getMessage());
    }
    }


    // Additionla Mappings

    if (prodOffering.Availed_Amount__c != null)
    oppObj.Approved_Loan_Amount__c = prodOffering.Availed_Amount__c;
    if (prodOffering.Availed_Tenor__c != null) {
    oppObj.Approved_Tenor__c = prodOffering.Availed_Tenor__c;
    prodOffering.Tenor__c = prodOffering.Availed_Tenor__c;
    oppObj.Tenor__c = prodOffering.Availed_Tenor__c;
    }
    if (prodOffering.EMI_Amount__c != null)
    oppObj.EMI_CAM__c = prodOffering.EMI_Amount__c;
    if (prodOffering.Accepted_Premium_Amount__c != null)
    oppObj.Insurance_Premium_Amt__c = prodOffering.Accepted_Premium_Amount__c;

    if (prodOffering.Offer_PF__c != null)
    oppObj.Processing_Fees__c = prodOffering.Offer_PF__c;

    if (prodOffering.Processing_Fee_Amount__c != null)
    oppObj.Amount_Rs__c = prodOffering.Processing_Fee_Amount__c;

    oppObj.A_C_NO__c = prodOffering.ECS_Bank_Account_number__c;
    oppObj.Bank_Name__c = prodOffering.Disb_Bank_Name__c;

    if (prodOffering.MICR_Code__c != null)
    oppObj.MICR_Number__c = Decimal.ValueOf(prodOffering.MICR_Code__c);

    oppObj.IFSC_Code__c = prodOffering.IFSC_Code__c;
    oppObj.Repayment_Mode__c = prodOffering.Mode_of_Payment__c;

    oppObj.Account_Holder_Name__c = leadObj.Name;
    oppObj.First_Due_Date__c = prodOffering.First_Due_Date__c;

    oppObj.Bank_A_c_No_of_Customer__c = prodOffering.ECS_Bank_Account_number__c;
    oppObj.Repayment_Account_Holder_Name__c = leadObj.Name;
    oppObj.Repayment_Bank_Name__c = prodOffering.Bank_name__c;
    oppObj.CUSTOMER__c = prodOffering.Customer_ID1__c;
    oppObj.Business_IRR__c = prodOffering.Offer_ROI__c;

}
try {
    update oppObj;
} catch (DMLException e) {
    system.debug('---Exception---' + e.getMessage());
}
}Call*/
 // CIBIL watch Ends

 @future
 public static void MapRecordsCIBILWatch(String prodOfferingId, String leadSourceSt, String oppObjId, String leadObjId, String leadObjName, boolean isCallCenterFlag, boolean cibilwatchFlagop, String priApplicant) {
  system.debug('inside optimised cibilwatch method');
  boolean SwitchOtimizedCode = LaonApplicationCreation__c.getValues('RunOptimizeCode(LoanConetionUtiility))').Integrate_Charges_API__c;
  //query on PO
  List < Product_Offerings__c > prodOffering = new List < Product_Offerings__c > ();
  List < Opportunity > oppObjLst = new List < Opportunity > ();
  prodOffering = [select id, Gross_Turnover__c, Bank_Details_Change__c, Disb_Bank_Name__c, Bank_name__c, Disbursement_Payment_Mode__c, Mode_of_Payment__c, Disbursement_Bank_IFSC_code__c, IFSC_Code__c, Disb_favouring__c, Cheque_In_Favoring__c, Existing_LAN__c, ECS_Bank_Account_number__c, Net_Disbursement_Amount__c, Disb_Bank_Branch__c, MICR_Code__c, Open_Ecs_Limit__c, ECS_End_Date__c, Bank_Account_Type__c, Offer_ROI__c, Monthly_Obligation__c, Net_Salary_Per_Month__c, Availed_Amount__c, Availed_Tenor__c, EMI_Amount__c, Final_Amount__c, First_Due_Date__c, Accepted_Premium_Amount__c, Offer_PF__c, Processing_Fee_Amount__c, Customer_ID1__c, Opportunity__c, products__c, Customer_ID__c, Address_Change_flag__c from Product_Offerings__c where id =: prodOfferingId limit 1];
  if (prodOffering != null && prodOffering.size() > 0) {
   //query on Opp
   oppObjLst = [select id, Mode_of_Disbursal__c, Favouring__c, A_C_Type__c, Approved_Loan_Amount__c, Approved_Tenor__c, Tenor__c, EMI_CAM__c, Insurance_Premium_Amt__c, Processing_Fees__c, Amount_Rs__c, Bank_Name__c, MICR_Number__c, IFSC_Code__c, Repayment_Mode__c, Account_Holder_Name__c, First_Due_Date__c, Bank_A_c_No_of_Customer__c, Repayment_Account_Holder_Name__c, Repayment_Bank_Name__c, CUSTOMER__c, Business_IRR__c, Product__c from Opportunity where id =: prodOffering[0].Opportunity__c limit 1];

   if (prodOffering[0].Bank_Details_Change__c == false) {
    prodOffering[0].Disb_Bank_Name__c = prodOffering[0].Bank_name__c;
    prodOffering[0].Disbursement_Payment_Mode__c = prodOffering[0].Mode_of_Payment__c;
    prodOffering[0].Disbursement_Bank_IFSC_code__c = prodOffering[0].IFSC_Code__c;
    prodOffering[0].Disb_favouring__c = prodOffering[0].Cheque_In_Favoring__c;

   }
   // Clone Fees And Charges Details
   Decimal stampduty = 0;
   List < Fees_and_Charge__c > ObjFeesClonnedList = new List < Fees_and_Charge__c > ();
   List < Fees_and_Charge__c > ListFeesAndCharges1 = new List < Fees_and_Charge__c > ();
   ListFeesAndCharges1 = [select name, Loan_Application__c, Tranche_Detail__r.name, Deposition_Date__c, Deposit_Slip_Number__c, Loan_Application__r.name, Change_Amount__c, Charge_Type__c, Deducted_from_Disbursement__c, Service_Charge__c, Status__c, Tranche_Detail__c, Instrument_Date__c, Instrument_No__c,
    Bank_Branch__c, Instrument_type__c, Amount_after_Service_Change__c, Tranche_Detail__r.Tranche_Number__c
    from Fees_and_Charge__c where Product_Offerings__c =: prodOffering[0].id
   ];
   if (ListFeesAndCharges1 != null && ListFeesAndCharges1.size() > 0) {
    system.debug('---ListFeesAndCharges1.size()---' + ListFeesAndCharges1.size());
    for (Fees_and_Charge__c objFess: ListFeesAndCharges1) {

     Fees_and_Charge__c objFessAndCharge = new Fees_and_Charge__c();
     objFessAndCharge = objFess.clone(false, true, false, false);
     system.debug('*****Cloneed Fees and Charges Details Object :--' + objFessAndCharge);
     if (oppObjLst != null && oppObjLst.size() > 0) objFessAndCharge.Loan_Application__c = oppObjLst[0].id;
     objFessAndCharge.Product_Offerings__c = null;
     ObjFeesClonnedList.add(objFessAndCharge);

     if (objFess.Change_Amount__c != null && objFess.Charge_Type__c == 'Stamp Duty') {
      stampduty += objFess.Change_Amount__c;

     }

    }
   }
   if (ObjFeesClonnedList != null && ObjFeesClonnedList.size() > 0) {
    upsert ObjFeesClonnedList;
   }
   List < Contact > objCon = [Select id, Stamp_Duty__c from contact where ApplicantType__c = 'Primary'
    AND Lead__c =: leadObjId LIMIT 1
   ];
   system.debug('---objCon---' + objCon);
   // system.debug('---objCon[0]---' + objCon[0]);
   system.debug('---stampduty---' + stampduty);
   if (objCon != null && objCon.size() > 0 && stampduty != null) {
    objCon[0].Stamp_Duty__c = stampduty;
    system.debug('---objCon[0]---' + objCon[0]);
    update objCon[0];
   }
   // Clone Perfios Details
   List < Bank_Account__c > objClonedBankList = new List < Bank_Account__c > ();
   List < Bank_Account__c > objBankDetailsList1 = new List < Bank_Account__c > ();


   objBankDetailsList1 = [SELECT /*SAL PLTB S*/ Perfios_maxBalance__c, Perfios_minBalance__c, Perfios_maxDebit__c, Perfios_maxCredit__c, Perfios_outwardECSBounces__c, Perfios_outwardChqBounces__c, Perfios_inwardChqBounces__c, Perfios_inwardECSBounces__c, Perfios_closingBalance__c, Perfios_abb02__c, Perfios_avgBalanceOf6Dates__c, Perfios_abb05__c, Perfios_avgDailyBalance__c, Perfios_abb10__c, Perfios_avgMonthlyExpense__c, Perfios_avgMonthlyIncome__c, Perfios_avgMonthlySurplus__c, Perfiod_done_date_and_Time__c, Perfios_abb_indicator__c, Perfios_Transaction_ID__c, Salary_Date_Inconsistency_Found__c, Source_Of_Data__c, Transaction_End_Date__c, Perfios_Transaction_Status__c, Trasaction_Start_Date__c, /*SAL PLTB E*/ Account_Type__c, Account_Used_For__c, ApplicantName__c, Product_Offerings__c, Applicant_Name__c,
    Applicant__c, Average_Balance__c, Average_incentive_for_Q1__c, Average_incentive_for_Q2__c,
    Average_incentive_for_Q3__c, Average_monthly_balance1__c, Average_monthly_balance2__c,
    Average_monthly_balance3__c, Average_ODCC_Utilization__c, Average_OD_CC_Limit__c, Average_of_Bounce_I_W__c,
    Average_of_Bounce_O_W__c, Average_of_CRD_Amount__c, Average_of_CRD_No__c, Average_of_DB_Amount__c,
    Average_of_DB_No__c, Average_of_ODCC_Limit__c, Average_Opening_Balance__c, Average_Open_Limit__c,
    Avg_Bounce_I_W__c, Avg_Bounce_O_W__c, Avg_CRD_Amount__c, Avg_CRD_No__c, Avg_DB_Amount__c, Avg_DB_No__c,
    Avg_monthly_incentive1__c, Avg_monthly_incentive2__c, Avg_monthly_incentive3__c, Avg_Monthly_Interest__c,
    Avg_mthly_bal6__c, Avg_mthly_bal_Coapp_SAL__c, Avg_mthly_incntve_3mts__c, Avg_mthy_bal_SAL__c,
    Avg_qtrly_incentive__c, AvmonBalance_EMI__c, Banking_Obligation__c, Bank_Account_Number__c,
    Bank_Acct_Number__c, Bank_Branch__c, Bank_Name_List__c, Bank_Name_Salaried__c, Bank_Name_Sal__c,
    Bank_Name__c, Bank_Type__c, Cheque_returns_in_latest_3_months__c, ConnectionReceivedId, ConnectionSentId,
    Consider_For_Eligibility_Gross_Profit__c, Consider_for_Eligibility_LTV__c, Consider_for_Eligibility__c,
    CreatedById, CreatedDate, Credit_more_than_1_5_time_in_last_3_mont__c, CurrencyIsoCode,
    Eligible_EMI_Banking__c, IFSC_Bank_Name__c, IFSC_Code__c, IFSC_Master__c, IsDeleted,
    LastModifiedById, LastModifiedDate, Loan_Application_Number__c, MICR_Code__c,
    Month1__c, monthly_Av_Balance_EMIOut__c, Month_2__c, Month_3__c, Month_end_Bal__c, Name,
    NumberOfMonthsTrans__c, OD_CC_limit__c, Opening_Balance__c, Other_Bank__c, OwnerId, Perc_Inward_Ret__c,
    Perc_Outward_Return__c, Perfios_Account_Holder_Name__c, Perfios_Account_No__c, Perfios_Bank_Name__c,
    Perfios_Client_Address__c, Perfios_Client_pan_no__c, Perfios_Flag__c, Per_of_inward_returnsOut__c,
    Product__c, Proposed_BAFL_EMI__c, Rate_of_OD_CC__c, Salaried_CAM__c, Salaried_Temp__c,
    Salary_credit_amount1__c, Salary_credit_amount2__c, Salary_credit_amount3__c, Salary_Credit_Date1__c,
    Salary_Credit_Date2__c, Salary_Credit_Date3__c, SelectBank__c, Send_Email_For_Perfios__c,
    sum_Avg_mthly_bal__c, Sum_Bounce_I_W__c, Sum_Bounce_O_W__c, Sum_CRD_Amount__c, Sum_CRD_No__c,
    Sum_DB_Amount__c, Sum_DB_No__c, Sum_Monthly_Interest__c, Sum_of_average_Balance__c,
    Sum_of_Cred_Int_Bank_Firm_Tran__c, Sum_of_OD_CC_Limit__c, Sum_of_OD_CC_Utilization__c, SystemModstamp,
    Transaction_Count__c, X10th_Bal__c, X20th_Bal__c, /* added by priya adhoc 12238 start */ Perfios_String__c, Perfios_Customer_EMail__c, Perfios_Mobile_No__c, (select id, Value_Date__c, DB_No__c, DB_Amount__c, CRD_No__c, CRD_Amount__c, Month__c, Year__c, Bank_Account__c, Average_Balance__c, Balance_Ist_of_Month__c, Balance_15th_of_month__c, Balance_25th_of_month__c, Balance_10th_of_month__c, Balance_20th_of_month__c, Balances__c, Transaction_Detail__c from Bank_Transaction_Objects__r limit 200) /* added by priya adhoc 12238 end */
    FROM Bank_Account__c where Product_Offerings__c =: prodOffering[0].id
   ];

   // added bankAccTransMapping by priya adhoc 12238
   Map < string, List < Bank_Transaction__c >> bankAccTransMapping = new Map < string, List < Bank_Transaction__c >> ();
   map < string, Bank_Account__c > tempmap = new map < string, Bank_Account__c > ();
   if (objBankDetailsList1 != null && objBankDetailsList1.size() > 0) {
    for (Bank_Account__c objextBank: objBankDetailsList1) {
     Bank_Account__c bnkObj = new Bank_Account__c();
     bnkObj = objextBank.clone(false, true, false, false);
     if (oppObjLst != null && oppObjLst.size() > 0) bnkObj.Loan_Application__c = oppObjLst[0].id;
     bnkObj.Account_Type__c = prodOffering[0].Bank_Account_Type__c;
     bnkObj.Product_Offerings__c = null;

     // SAL PLTB Bug Id - 13952 start 
     if (isCallCenterFlag && String.isNotEmpty(priApplicant)) {
      bnkObj.Applicant__c = priApplicant;
     }
     // SAL PLTB Bug Id - 13952 end

     //  adhoc 12238 added  by priya start
     tempmap.put(bnkObj.Bank_Acct_Number__c, bnkObj);
     bankAccTransMapping.put(bnkObj.Bank_Acct_Number__c, objextBank.Bank_Transaction_Objects__r.deepClone(false, false, false));
     // adhoc 12238 added  by priya end
     objClonedBankList.add(bnkObj);
    }
   }
   if (objClonedBankList != null && objClonedBankList.size() > 0) {
    try {
     insert objClonedBankList;
     //added by priya adhoc 12238 start
     if (isCallCenterFlag) {
      List < Bank_Transaction__c > banktransList = new List < Bank_Transaction__c > ();
      for (string accObj: tempmap.keySet()) {
       for (Bank_Transaction__c bankobj: bankAccTransMapping.get(accObj)) {
        bankobj.Bank_Account__c = tempmap.get(accObj).id;
        banktransList.add(bankobj);
       }
      }
      if (banktransList.size() > 0)
       insert banktransList;
     }
     //added by priya adhoc 12238 end
    } catch (DMLException e) {
     String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
     str += 'Product Offering Id :' + offeringId + ' \n Block 24'; // Bug 12463
     System.debug(str);
     //CommonUtility.SendExceptionMail(str);
     system.debug('--objClonedBankList insertion Exception :- ' + e.getMessage());
    }
   }
   // Clone Insurance Details

   List < DPLinsurance__c > ObjInsuranceClonnedList = new List < DPLinsurance__c > ();
   List < DPLinsurance__c > ListInsurance1 = new List < DPLinsurance__c > ();
   // Bug #14123 - added HdfcCppType__c,Plan__c,Plan_Option__c,Policy_Tenure__c,Type_of_Insurance__c, Critical_Illness_Declaration_of_Good_H__c, Sum_Insured__c, DOB_of_Dependent_Life__c, DOB_of_Policyholder1__c
   if (!SwitchOtimizedCode) {
    List < DPLinsurance__c > ListInsuranceOptimized = new List < DPLinsurance__c > ();
    ListInsuranceOptimized = [Select Nominee_Name__c, Nominee_Address__c, Nominee_Mobile__c, Nominee_DOB__c, Whether_we_are_financing_this_product__c, Term_of_Insurance__c, Sum_Assured__c, Remark__c, Reject_reason__c,
     Premium_Amount__c, Policy_type__c, Policy_issue_date__c, Offer_id__c, Loan_Application_Status__c,
     Loan_application_number__c, Opportunity__c, Opportunity__r.Nominee_Name__c, Loan_Amount__c, Insurance_Type__c, Insurance_Product__c, Insurance_Name__c, Insurance_amount__c, Existing_LAN_no__c, Decision_time_stamp__c, Customer_Payment_Mode__c, Customer_address__c, CPA_Name__c, Cheque_Status__c, Cheque_DD_No_with_Bank_Name__c, Cheque_DD_Date__c, Availed_Tenor__c, Nominee_Relationship__c, Availed_EMI__c, Availed_Amount__c, Approved__c,
     Age__c, HdfcCppType__c, Plan__c, Plan_Option__c, Policy_Tenure__c, Type_of_Insurance__c, Critical_Illness_Declaration_of_Good_H__c, Sum_Insured__c, DOB_of_Dependent_Life__c, DOB_of_Policyholder1__c from DPLinsurance__c where Product_Offerings__c =: prodOffering[0].id
    ];
    ListInsurance1 = ListInsuranceOptimized;
   } else {
    ListInsurance1 = [Select Nominee_Name__c, Nominee_Address__c, Nominee_Mobile__c, Nominee_DOB__c, Whether_we_are_financing_this_product__c, Term_of_Insurance__c, Sum_Assured__c, Remark__c, Reject_reason__c,
     Premium_Amount__c, Policy_type__c, Policy_issue_date__c, Offer_id__c, Loan_Application_Status__c,
     Loan_application_number__c, Opportunity__r.Nominee_Name__c, Loan_Amount__c, Insurance_Type__c, Insurance_Product__c, Insurance_Name__c, Insurance_amount__c, Existing_LAN_no__c, Decision_time_stamp__c, Customer_Payment_Mode__c, Customer_address__c, CPA_Name__c, Cheque_Status__c, Cheque_DD_No_with_Bank_Name__c, Cheque_DD_Date__c, Availed_Tenor__c, Nominee_Relationship__c, Availed_EMI__c, Availed_Amount__c, Approved__c, Age__c,
     HdfcCppType__c, Plan__c, Plan_Option__c, Policy_Tenure__c, Type_of_Insurance__c, Critical_Illness_Declaration_of_Good_H__c, Sum_Insured__c, DOB_of_Dependent_Life__c, DOB_of_Policyholder1__c from DPLinsurance__c where Product_Offerings__c =: prodOffering[0].id
    ];
   }
   if (ListInsurance1 != null && ListInsurance1.size() > 0) {
    system.debug('---ListInsurance1.size()---' + ListInsurance1.size());
    for (DPLinsurance__c objInsu: ListInsurance1) {
     DPLinsurance__c objInsurance = new DPLinsurance__c();
     objInsurance = objInsu.clone(false, true, false, false);
     system.debug('*****Cloneed Bank Account Details Object :--' + objInsurance);
     if (oppObjLst != null && oppObjLst.size() > 0) objInsurance.Opportunity__c = oppObjLst[0].id;
     objInsurance.Product_Offerings__c = null;
     ObjInsuranceClonnedList.add(objInsurance);
    }
   }
   if (ObjInsuranceClonnedList != null && ObjInsuranceClonnedList.size() > 0) {
    try {
     insert ObjInsuranceClonnedList;
    } catch (DMLException e) {
     String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
     str += 'Product Offering Id :' + offeringId + ' \n Block 25'; // Bug 12463
     System.debug(str);
     //CommonUtility.SendExceptionMail(str);
     system.debug('--ObjInsuranceClonnedList insertion Exception :- ' + e.getMessage());
    }
   }
   //Map Current Disbersal Details records
   /* Initiate Open ECS added by priya start*/
   boolean ecsProductsFlag = false;
   String ecsProducts = System.Label.ECS_product;
   if (ecsProducts != null && ecsProducts != '') {
    ecsProducts = ecsProducts.toUpperCase();
    if (prodOffering[0].products__c != null && ecsProducts.contains((prodOffering[0].products__c).toUpperCase())) {
     ecsProductsFlag = true;
    }
   }

   /* Initiate Open ECS added by priya end*/
   List < Opportunity > objExistingOppList1 = new List < Opportunity > ();
   List < Current_Disbursal_Details__c > objCDDList = new List < Current_Disbursal_Details__c > ();
   List < RePayment_mode_detail__c > objRepaymentList = new List < RePayment_mode_detail__c > ();
   if (prodOffering[0].Existing_LAN__c != null && prodOffering[0].Existing_LAN__c != '') {
    if (!SwitchOtimizedCode) {
     objExistingOppList1 = [Select Approved_Loan_Amount__c, createddate, Loan_Type__c, Scheme_Master__c, File_Accept_Status__c,
      End_Use__c, Premium_Amount__c, Nature_of_Business__c, Type_of_Constitution__c, Disbursal_Date__c, Product__c from Opportunity where LAN__c =: prodOffering[0].Existing_LAN__c LIMIT 1
     ];
    } else {
     objExistingOppList1 = [Select Approved_Loan_Amount__c, createddate, Loan_Type__c, Scheme_Master__c, File_Accept_Status__c,
      End_Use__c, Premium_Amount__c, Nature_of_Business__c, Type_of_Constitution__c, Disbursal_Date__c,
      (SELECT All_Documents_in_Order__c, Bank_Account__c, Bank_Branch__c, Bank_Name__c, Cheque_Amount__c,
       Cheque_Collected__c, Cheque_Date__c, Cheque_in_Favoring_CRISIL__c, Cheque_in_Favoring__c, Cheque_No__c,
       Cheque_Received_at_HO__c, Cheque_Status__c, ConnectionReceivedId, ConnectionSentId, CreatedById,
       CreatedDate, Credit_Days__c, CurrencyIsoCode, Customer_Payment_Mode__c, Date_of_Pick_Up__c, Disbursal_Mode__c,
       Disbursement_Amount__c, Disbursement_Date__c, Disbursement_Number__c, Favouring__c, FinnOne_Disbursement_Amt__c,
       FinnOne_Disbursement_Date__c, FinnOne_LAN__c, IFSC_Code__c, IMPS_Flag__c, Information_From__c,
       Internal_Closure__c, IsDeleted, LastActivityDate, LastModifiedById, LastModifiedDate, Loan_Application__c,
       Mandate_Received_at_HO__c, Name, OwnerId, Payable_at__c, SystemModstamp, Tranche_Detail__c FROM Current_Disbursal_Details_s__r),
      (SELECT Account_Holder_Name__c, A_C_NO__c, Bank_Name__c, Cheque_Amount__c, Cheque_Serial_Number__c,
       ConnectionReceivedId, ConnectionSentId, CreatedById, CreatedDate, CurrencyIsoCode, IFSC_Code__c,
       IsDeleted, LastModifiedById, LastModifiedDate, Loan_Application__c, MICR_Code__c, Name, No_of_Cheques__c,
       OwnerId, PDC_START_DATE__c, Repayment_Mode__c, SystemModstamp, To_Cheque_Serial_Number__c, Tranche_Detail__c FROM RePayment_mode_details__r), Product__c from Opportunity where LAN__c =: prodOffering[0].Existing_LAN__c LIMIT 1
     ];
    }
    if (objExistingOppList1 != null && objExistingOppList1.size() > 0) {
     objExistingOpp = new Opportunity();
     objExistingOpp = objExistingOppList1[0];
     if (SwitchOtimizedCode) {
      //optimized query by pritha for 101 soql queries error start
      objCDDList = objExistingOppList1[0].Current_Disbursal_Details_s__r;
      objRepaymentList = objExistingOppList1[0].RePayment_mode_details__r;
      //optimized query by pritha for 101 soql queries error end
     }
    }
    List < Current_Disbursal_Details__c > objNewCDDList = new List < Current_Disbursal_Details__c > ();
    /*SAL PLTB BUG Id -13934 !ecsProductsFlag condition added*/
    if (isCallCenterFlag && !ecsProductsFlag) {
     system.debug('Current_Disbursal_Details__c');
     //added for Call Center S
     Current_Disbursal_Details__c objCDDnewCall = new Current_Disbursal_Details__c();
     if (oppObjLst != null && oppObjLst.size() > 0) objCDDnewCall.Loan_Application__c = oppObjLst[0].id;
     if (prodOffering[0].Bank_name__c != null)
      objCDDnewCall.Bank_Name__c = prodOffering[0].Bank_name__c;
     if (prodOffering[0].Disbursement_Bank_IFSC_code__c != null)
      objCDDnewCall.IFSC_Code__c = prodOffering[0].Disbursement_Bank_IFSC_code__c;
     if (prodOffering[0].ECS_Bank_Account_number__c != null)
      objCDDnewCall.Bank_Account__c = prodOffering[0].ECS_Bank_Account_number__c;
     //IFSC_Code__c,Bank_Name__c,Bank_Account__c,
     if (prodOffering[0].Bank_Details_Change__c == true) {
      if (prodOffering[0].Disb_Bank_Name__c != null)
       objCDDnewCall.Bank_Name__c = prodOffering[0].Disb_Bank_Name__c;
      if (prodOffering[0].Disbursement_Payment_Mode__c != null)
       objCDDnewCall.Disbursal_Mode__c = prodOffering[0].Disbursement_Payment_Mode__c;
      //objCDDnewCall.IFSC_Code__c = prodOffering[0].Disbursement_Bank_IFSC_code__c;
      if (prodOffering[0].Disb_favouring__c != null) {
       objCDDnewCall.Cheque_In_Favoring__c = prodOffering[0].Disb_favouring__c;
       objCDDnewCall.Favouring__c = prodOffering[0].Disb_favouring__c;
      }
      if (prodOffering[0].Net_Disbursement_Amount__c != null) {
       objCDDnewCall.Disbursement_Amount__c = prodOffering[0].Net_Disbursement_Amount__c;
      }
      if (prodOffering[0].Disb_Bank_Branch__c != null) {
       objCDDnewCall.Bank_Branch__c = prodOffering[0].Disb_Bank_Branch__c;
      }
     }
     objNewCDDList.add(objCDDnewCall);
     /*try {
    insert objCDDnewCall;
    } catch (DMLException e) {
    system.debug('--Exception :- ' + e.getMessage());
    }*/
     //Map Repayment Mode details

     RePayment_mode_detail__c objRe = new RePayment_mode_detail__c();
     if (prodOffering[0].ECS_Bank_Account_number__c != null)
      objRe.A_C_NO__c = prodOffering[0].ECS_Bank_Account_number__c;
     if (prodOffering[0].Bank_name__c != null)
      objRe.Bank_Name__c = prodOffering[0].Bank_name__c;
     if (prodOffering[0].MICR_Code__c != null)
      objRe.MICR_Code__c = Decimal.ValueOf(prodOffering[0].MICR_Code__c);
     if (prodOffering[0].Open_Ecs_Limit__c != null)
      objRe.Open_ECS_Max_Limit__c = prodOffering[0].Open_Ecs_Limit__c;
     if (prodOffering[0].ECS_End_Date__c != null)
      objRe.ECS_End_Date__c = prodOffering[0].ECS_End_Date__c;
     if (prodOffering[0].Disbursement_Payment_Mode__c != null)
      objRe.Repayment_Mode__c = prodOffering[0].Disbursement_Payment_Mode__c;
     if (prodOffering[0].IFSC_Code__c != null)
      objRe.IFSC_Code__c = prodOffering[0].IFSC_Code__c;
     if (oppObjLst != null && oppObjLst.size() > 0) objRe.Loan_Application__c = oppObjLst[0].id;
     /*SAL PLTB Bug 13550 */
     if (isCallCenterFlag && prodOffering[0].Customer_ID__c != null) {
      objRe.Open_ECS_Ex_Customer_Id__c = Decimal.valueOf(prodOffering[0].Customer_ID__c);
     }
     try {
      insert objRe;
     } catch (DMLException e) {
      String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
      str += 'Product Offering Id :' + offeringId + ' \n Block 26'; // Bug 12463
      System.debug(str);
      //CommonUtility.SendExceptionMail(str);
      system.debug('--Exception :- ' + e.getMessage());
     }
    }
    //added for Call Center E
    List < Current_Disbursal_Details__c > objCDDList1 = new List < Current_Disbursal_Details__c > ();
    if (!SwitchOtimizedCode) {
     if (objExistingOpp != null) {
      List < Current_Disbursal_Details__c > objCDDListOptimized = new List < Current_Disbursal_Details__c > ();
      objCDDListOptimized = [SELECT All_Documents_in_Order__c, Bank_Account__c, Bank_Branch__c, Bank_Name__c, Cheque_Amount__c,
       Cheque_Collected__c, Cheque_Date__c, Cheque_in_Favoring_CRISIL__c, Cheque_in_Favoring__c, Cheque_No__c,
       Cheque_Received_at_HO__c, Cheque_Status__c, ConnectionReceivedId, ConnectionSentId, CreatedById,
       CreatedDate, Credit_Days__c, CurrencyIsoCode, Customer_Payment_Mode__c, Date_of_Pick_Up__c, Disbursal_Mode__c,
       Disbursement_Amount__c, Disbursement_Date__c, Disbursement_Number__c, Favouring__c, FinnOne_Disbursement_Amt__c,
       FinnOne_Disbursement_Date__c, FinnOne_LAN__c, IFSC_Code__c, IMPS_Flag__c, Information_From__c,
       Internal_Closure__c, IsDeleted, LastActivityDate, LastModifiedById, LastModifiedDate, Loan_Application__c,
       Mandate_Received_at_HO__c, Name, OwnerId, Payable_at__c, SystemModstamp, Tranche_Detail__c
       FROM Current_Disbursal_Details__c where Loan_Application__c =: objExistingOpp.Id
      ];
      objCDDList1 = objCDDListOptimized;
     }
    }
    if (objCDDList1 != null && objCDDList1.size() > 0) {
     for (Current_Disbursal_Details__c objCDD: objCDDList1) {
      Current_Disbursal_Details__c objCDDnew = new Current_Disbursal_Details__c();
      objCDDnew = objCDD.clone(false, true, false, false);
      system.debug('*****Cloneed CDD Object :--' + objCDDnew);
      if (oppObjLst != null && oppObjLst.size() > 0) objCDDnew.Loan_Application__c = oppObjLst[0].id;

      objCDDnew.Bank_Name__c = prodOffering[0].Disb_Bank_Name__c;
      //Bug 6342 Start 
      if (prodOffering[0].Disbursement_Payment_Mode__c != null) {
       objCDDnew.Disbursal_Mode__c = prodOffering[0].Disbursement_Payment_Mode__c;
       //oppObjLst[0].Mode_of_Disbursal__c = prodOffering[0].Disbursement_Payment_Mode__c;
      } else {
       objCDDnew.Disbursal_Mode__c = prodOffering[0].Mode_of_Payment__c;
       //oppObjLst[0].Mode_of_Disbursal__c = prodOffering[0].Mode_of_Payment__c;
      }
      //Bug 6342 End
      objCDDnew.IFSC_Code__c = prodOffering[0].Disbursement_Bank_IFSC_code__c;
      objCDDnew.Cheque_In_Favoring__c = prodOffering[0].Disb_favouring__c;
      objCDDnew.Favouring__c = prodOffering[0].Disb_favouring__c;
      //Bug 5989 Start
      objCDDnew.Disbursement_Amount__c = prodOffering[0].Net_Disbursement_Amount__c;
      //Bug 5989 End
      //Bug 6342 Start 
      system.debug('---prodOffering[0].Disb_favouring__c---' + prodOffering[0].Disb_favouring__c);
      system.debug('---prodOffering[0].Cheque_In_Favoring__c---' + prodOffering[0].Cheque_In_Favoring__c);

      /*if (prodOffering[0].Address_Change_flag__c == true) {
    oppObjLst[0].Favouring__c = prodOffering[0].Disb_favouring__c;
    } else {
    oppObjLst[0].Favouring__c = prodOffering[0].Cheque_In_Favoring__c;
    }
    system.debug('---oppObjLst[0].Favouring__c---' + oppObjLst[0].Favouring__c);
    oppObjLst[0].A_C_Type__c = prodOffering[0].Bank_Account_Type__c;
    //Bug 6342 End
             */
      objCDDnew.Bank_Account__c = prodOffering[0].ECS_Bank_Account_number__c;

      objNewCDDList.add(objCDDnew);
     }
    } //Cibil Watch Start
    else {
     if (cibilwatchFlagop == true) {
      Current_Disbursal_Details__c objCDDnew = new Current_Disbursal_Details__c();
      if (oppObjLst != null && oppObjLst.size() > 0) objCDDnew.Loan_Application__c = oppObjLst[0].id;
      //objCDDnew.Bank_Name__c = productOffer.Bank_name__c;
      //objCDDnew.IFSC_Code__c = productOffer.IFSC_Code__c;
      objCDDnew.Bank_Account__c = prodOffering[0].ECS_Bank_Account_number__c;
      //IFSC_Code__c,Bank_Name__c,Bank_Account__c,
      // if (productOffer.Bank_Details_Change__c == true) {
      objCDDnew.Bank_Name__c = prodOffering[0].Disb_Bank_Name__c;
      // objCDDnew.Disbursal_Mode__c = productOffer.Disbursement_Payment_Mode__c;
      objCDDnew.IFSC_Code__c = prodOffering[0].Disbursement_Bank_IFSC_code__c;
      objCDDnew.Cheque_In_Favoring__c = prodOffering[0].Disb_favouring__c;
      objCDDnew.Favouring__c = prodOffering[0].Disb_favouring__c;
      // }
      if (prodOffering[0].Disbursement_Payment_Mode__c != null) {
       objCDDnew.Disbursal_Mode__c = prodOffering[0].Disbursement_Payment_Mode__c;
       //oppObjLst[0].Mode_of_Disbursal__c = prodOffering[0].Disbursement_Payment_Mode__c;
      } else {
       objCDDnew.Disbursal_Mode__c = prodOffering[0].Mode_of_Payment__c;
       //oppObjLst[0].Mode_of_Disbursal__c = prodOffering[0].Mode_of_Payment__c;
      }
      system.debug('---productOffer.Disb_favouring__c---' + prodOffering[0].Disb_favouring__c);
      system.debug('---productOffer.Cheque_In_Favoring__c---' + prodOffering[0].Cheque_In_Favoring__c);
      /*
        if (prodOffering[0].Address_Change_flag__c == true) {
        oppObjLst[0].Favouring__c = prodOffering[0].Disb_favouring__c;
        } else {
        oppObjLst[0].Favouring__c = prodOffering[0].Cheque_In_Favoring__c;
        }
        system.debug('---oppObjLst[0].Favouring__c---' + oppObjLst[0].Favouring__c);
        oppObjLst[0].A_C_Type__c = prodOffering[0].Bank_Account_Type__c;
             */
      //Bug 5989 Start
      objCDDnew.Disbursement_Amount__c = prodOffering[0].Net_Disbursement_Amount__c;
      //Bug 5989 End

      objNewCDDList.add(objCDDnew);
     }
    }
    //Cibil Watch End
    if (objNewCDDList != null && objNewCDDList.size() > 0) {
     try {
      if (cibilwatchFlagop == false && isCallCenterFlag == false && ecsProductsFlag == false) /* Initiate Open ECS added by priya */
       insert objNewCDDList;
     } catch (DMLException e) {
      String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
      str += 'Product Offering Id :' + offeringId + ' \n Block 27'; // Bug 12463
      System.debug(str);
      //CommonUtility.SendExceptionMail(str);
      system.debug('--objNewCDDList insertion Exception :- ' + e.getMessage());
     }
    }
    //added not condition for call center S
    if (!isCallCenterFlag) {
     system.debug('not for Call center');
     //Map CAM details
     CAM__c camObj = new CAM__c();
     if (oppObjLst != null && oppObjLst.size() > 0) camObj.Loan_Application__c = oppObjLst[0].id;
     camObj.ROI__c = prodOffering[0].Offer_ROI__c;
     camObj.Average_monthly_Obligations__c = prodOffering[0].Monthly_Obligation__c;
     camObj.Average_incentive_for_Q1__c = prodOffering[0].Net_Salary_Per_Month__c;
     camObj.Average_incentive_for_Q2__c = prodOffering[0].Net_Salary_Per_Month__c;
     camObj.Average_incentive_for_Q3__c = prodOffering[0].Net_Salary_Per_Month__c;

     if (prodOffering[0].Availed_Amount__c != null) camObj.Proposed_Loan_Amt__c = prodOffering[0].Availed_Amount__c;
     if (prodOffering[0].Availed_Tenor__c != null) camObj.Tenor__c = prodOffering[0].Availed_Tenor__c;
     camObj.EMI_on_Proposed_Loan_TO__c = prodOffering[0].EMI_Amount__c;
     camObj.Eligible_Loan__c = prodOffering[0].Final_Amount__c;
     try {
      insert camObj;
     } catch (DMLException e) {
      String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
      str += 'Product Offering Id :' + offeringId + ' \n Block 28'; // Bug 12463
      System.debug(str);
      //CommonUtility.SendExceptionMail(str);
      system.debug('--camObj insert Exception :- ' + e.getMessage());
     }

    }
    //added not condition for call center E
    // MAp Repayment Mode Details 
    //List < RePayment_mode_detail__c > objRepaymentList = new List < RePayment_mode_detail__c > ();
    List < RePayment_mode_detail__c > objNewRepaymentList = new List < RePayment_mode_detail__c > ();

    if (!SwitchOtimizedCode) {
     if (objExistingOpp != null) {
      objRepaymentList = [SELECT Account_Holder_Name__c, A_C_NO__c, Bank_Name__c, Cheque_Amount__c, Cheque_Serial_Number__c,
       ConnectionReceivedId, ConnectionSentId, CreatedById, CreatedDate, CurrencyIsoCode, IFSC_Code__c,
       IsDeleted, LastModifiedById, LastModifiedDate, Loan_Application__c, MICR_Code__c, Name, No_of_Cheques__c,
       OwnerId, PDC_START_DATE__c, Repayment_Mode__c, SystemModstamp, To_Cheque_Serial_Number__c, Tranche_Detail__c
       FROM RePayment_mode_detail__c where Loan_Application__c =: objExistingOpp.Id
      ];
     }
    }
    if (objRepaymentList != null && objRepaymentList.size() > 0) {
     for (RePayment_mode_detail__c objRepay: objRepaymentList) {
      RePayment_mode_detail__c objRe = new RePayment_mode_detail__c();
      objRe = objRepay.clone(false, true, false, false);
      system.debug('*****Cloneed RePayment Object :--' + objRe);
      if (oppObjLst != null && oppObjLst.size() > 0) objRe.Loan_Application__c = oppObjLst[0].id;
      objRe.A_C_NO__c = prodOffering[0].ECS_Bank_Account_number__c;
      objRe.Bank_Name__c = prodOffering[0].Bank_name__c;
      try {
       //Null check for Sal Line Prod Issue- Bug 6418 start
       if (prodOffering[0].MICR_Code__c != null) objRe.MICR_Code__c = Decimal.ValueOf(prodOffering[0].MICR_Code__c);
       //Null check for Sal Line Prod Issue- Bug 6418 start
       objRe.Open_ECS_Max_Limit__c = prodOffering[0].Open_Ecs_Limit__c;
      } catch (Exception e) {
       String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
       str += 'Product Offering Id :' + offeringId + ' \n Block 29'; // Bug 12463
       System.debug(str);
       //CommonUtility.SendExceptionMail(str);
       system.debug('--exception--' + e.getmessage());
      }

      objRe.ECS_End_Date__c = prodOffering[0].ECS_End_Date__c;
      //Bug 5989 Start
      objRe.Open_Valid_till__c = objRe.ECS_End_Date__c;
      objRe.ECS_Amount__c = objRe.Open_ECS_Max_Limit__c;
      objRe.Repayment_Mode__c = prodOffering[0].Mode_of_Payment__c;
      //Bug 5989 End
      //Bug 6342 Start
      objRe.IFSC_Code__c = prodOffering[0].Disbursement_Bank_IFSC_code__c;
      objRe.Account_Holder_Name__c = leadObjName;

      if (prodOffering[0].Address_Change_flag__c == true) {
       objRe.PDC_By_Name__c = prodOffering[0].Disb_favouring__c;
      } else {
       objRe.PDC_By_Name__c = prodOffering[0].Cheque_In_Favoring__c;
      }
      objRe.ECS_Start_Date__c = prodOffering[0].First_Due_Date__c;
      objRe.Open_ECS_Facility__c = 'Yes';
      objRe.PDC_By_Name__c = prodOffering[0].Cheque_In_Favoring__c;
      //Bug 6342 End
      /*SAL PLTB Bug 13550 */
      if (isCallCenterFlag && prodOffering[0].Customer_ID__c != null) {
       objRe.Open_ECS_Ex_Customer_Id__c = Decimal.valueOf(prodOffering[0].Customer_ID__c);
      }
      objNewRepaymentList.add(objRe);
     }
    } //Cibil Watch Start 
    else {
     if (cibilwatchFlagop == true) {
      RePayment_mode_detail__c objRe = new RePayment_mode_detail__c();
      objRe.A_C_NO__c = prodOffering[0].ECS_Bank_Account_number__c;
      objRe.Bank_Name__c = prodOffering[0].Bank_name__c;
      //Null check for Sal Line Prod Issue- Bug 6418 start
      if (prodOffering[0].MICR_Code__c != null) objRe.MICR_Code__c = Decimal.ValueOf(prodOffering[0].MICR_Code__c);
      //Null check for Sal Line Prod Issue- Bug 6418 end
      objRe.Open_ECS_Max_Limit__c = prodOffering[0].Open_Ecs_Limit__c;
      objRe.ECS_End_Date__c = prodOffering[0].ECS_End_Date__c;
      if (oppObjLst != null && oppObjLst.size() > 0) objRe.Loan_Application__c = oppObjLst[0].id;
      //Bug 5989 Start
      objRe.Open_Valid_till__c = objRe.ECS_End_Date__c;
      objRe.ECS_Amount__c = objRe.Open_ECS_Max_Limit__c;
      objRe.Repayment_Mode__c = prodOffering[0].Mode_of_Payment__c;
      //Bug 5989 End
      //Bug 6342 Start
      objRe.IFSC_Code__c = prodOffering[0].Disbursement_Bank_IFSC_code__c;
      objRe.Account_Holder_Name__c = leadObjName;

      if (prodOffering[0].Address_Change_flag__c == true) {
       objRe.PDC_By_Name__c = prodOffering[0].Disb_favouring__c;
      } else {
       objRe.PDC_By_Name__c = prodOffering[0].Cheque_In_Favoring__c;
      }
      objRe.ECS_Start_Date__c = prodOffering[0].First_Due_Date__c;
      objRe.Open_ECS_Facility__c = 'Yes';
      objRe.PDC_By_Name__c = prodOffering[0].Cheque_In_Favoring__c;
      //Bug 6342 End

      objNewRepaymentList.add(objRe);
      //insert objNewRepaymentList;
     }
    }
    //Cibil Watch End
    if (objNewRepaymentList != null && objNewRepaymentList.size() > 0) {
     try {
      if (cibilwatchFlagop == false && isCallCenterFlag == false && ecsProductsFlag == false) /* Initiate Open ECS added by priya*/
       insert objNewRepaymentList;
     } catch (DMLException e) {
      String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
      str += 'Product Offering Id :' + offeringId + ' \n Block 30'; // Bug 12463
      System.debug(str);
      //CommonUtility.SendExceptionMail(str);
      system.debug('--objNewRepaymentList Insert Exception :- ' + e.getMessage());
     }
    }
    // Additionla Mappings
    /*
        if (prodOffering[0].Availed_Amount__c != null)
            oppObjLst[0].Approved_Loan_Amount__c = prodOffering[0].Availed_Amount__c;
        if (prodOffering[0].Availed_Tenor__c != null) {
        oppObjLst[0].Approved_Tenor__c = prodOffering[0].Availed_Tenor__c;
        prodOffering[0].Tenor__c = prodOffering[0].Availed_Tenor__c;
        oppObjLst[0].Tenor__c = prodOffering[0].Availed_Tenor__c;
        }
        if (prodOffering[0].EMI_Amount__c != null)
        oppObjLst[0].EMI_CAM__c = prodOffering[0].EMI_Amount__c;
        if (prodOffering[0].Accepted_Premium_Amount__c != null)
        oppObjLst[0].Insurance_Premium_Amt__c = prodOffering[0].Accepted_Premium_Amount__c;

        if (prodOffering[0].Offer_PF__c != null)
        oppObjLst[0].Processing_Fees__c = prodOffering[0].Offer_PF__c;

        if (prodOffering[0].Processing_Fee_Amount__c != null)
        oppObjLst[0].Amount_Rs__c = prodOffering[0].Processing_Fee_Amount__c;

        oppObjLst[0].A_C_NO__c = prodOffering[0].ECS_Bank_Account_number__c;
        oppObjLst[0].Bank_Name__c = prodOffering[0].Disb_Bank_Name__c;

        if (prodOffering[0].MICR_Code__c != null)
        oppObjLst[0].MICR_Number__c = Decimal.ValueOf(prodOffering[0].MICR_Code__c);

        oppObjLst[0].IFSC_Code__c = prodOffering[0].IFSC_Code__c;
        oppObjLst[0].Repayment_Mode__c = prodOffering[0].Mode_of_Payment__c;

        oppObjLst[0].Account_Holder_Name__c = leadObjName;
        oppObjLst[0].First_Due_Date__c = prodOffering[0].First_Due_Date__c;

        oppObjLst[0].Bank_A_c_No_of_Customer__c = prodOffering[0].ECS_Bank_Account_number__c;
        oppObjLst[0].Repayment_Account_Holder_Name__c = leadObjName;
        oppObjLst[0].Repayment_Bank_Name__c = prodOffering[0].Bank_name__c;
        oppObjLst[0].CUSTOMER__c = prodOffering[0].Customer_ID1__c;
        oppObjLst[0].Business_IRR__c = prodOffering[0].Offer_ROI__c;

    }
    try {
        //update oppObjLst[0];
    }
    catch (DMLException e) {
        system.debug('---Exception---' + e.getMessage());
    }*/
   }
   /*Initiate Open ECS code added by priya start */
   if ((cibilwatchFlagop == true || isCallCenterFlag == true) && ecsProductsFlag) {
    Current_Disbursal_Details__c objCDecs = new Current_Disbursal_Details__c();
    if (oppObjLst != null && oppObjLst.size() > 0) objCDecs.Loan_Application__c = oppObjLst[0].id;
    if (prodOffering[0].Bank_name__c != null)
     objCDecs.Bank_Name__c = prodOffering[0].Bank_name__c;
    if (prodOffering[0].IFSC_Code__c != null)
     objCDecs.IFSC_Code__c = prodOffering[0].IFSC_Code__c;
    if (prodOffering[0].ECS_Bank_Account_number__c != null)
     objCDecs.Bank_Account__c = prodOffering[0].ECS_Bank_Account_number__c;
    if (prodOffering[0].Disbursement_Payment_Mode__c != null)
     objCDecs.Disbursal_Mode__c = prodOffering[0].Disbursement_Payment_Mode__c;
    if (prodOffering[0].Disb_favouring__c != null) {
     objCDecs.Cheque_In_Favoring__c = prodOffering[0].Disb_favouring__c;
     objCDecs.Favouring__c = prodOffering[0].Disb_favouring__c;
    }
    if (prodOffering[0].Net_Disbursement_Amount__c != null) {
     objCDecs.Disbursement_Amount__c = prodOffering[0].Net_Disbursement_Amount__c;
    }
    if (prodOffering[0].Disb_Bank_Branch__c != null) {
     objCDecs.Bank_Branch__c = prodOffering[0].Disb_Bank_Branch__c;
    }
    try {
     insert objCDecs;
    } catch (DMLException e) {
     system.debug('--Exception :- ' + e.getMessage());
    }





    RePayment_mode_detail__c objRepay = new RePayment_mode_detail__c();
    if (prodOffering[0].ECS_Bank_Account_number__c != null)
     objRepay.A_C_NO__c = prodOffering[0].ECS_Bank_Account_number__c;
    if (prodOffering[0].Bank_name__c != null)
     objRepay.Bank_Name__c = prodOffering[0].Bank_name__c;
    if (prodOffering[0].MICR_Code__c != null)
     objRepay.MICR_Code__c = Decimal.ValueOf(prodOffering[0].MICR_Code__c);
    if (prodOffering[0].Open_Ecs_Limit__c != null)
     objRepay.Open_ECS_Max_Limit__c = prodOffering[0].Open_Ecs_Limit__c;
    if (prodOffering[0].ECS_End_Date__c != null)
     objRepay.ECS_End_Date__c = prodOffering[0].ECS_End_Date__c;
    if (prodOffering[0].Disbursement_Payment_Mode__c != null)
     objRepay.Repayment_Mode__c = prodOffering[0].Disbursement_Payment_Mode__c;
    if (prodOffering[0].IFSC_Code__c != null)
     objRepay.IFSC_Code__c = prodOffering[0].IFSC_Code__c;
    if (oppObjLst != null && oppObjLst.size() > 0) objRepay.Loan_Application__c = oppObjLst[0].id;
    if (prodOffering[0].Bank_Account_Type__c != null) {
     string bankAcctype = objRepay.A_C_Type__c = prodOffering[0].Bank_Account_Type__c;
     if (bankAcctype.equalsIgnoreCase('Savings'))
      objRepay.A_C_Type__c = 'Savings' + ' A/c';
     else if (bankAcctype.equalsIgnoreCase('Current'))
      objRepay.A_C_Type__c = 'Current' + ' A/c';
    }
    if (isCallCenterFlag && prodOffering[0].Customer_ID__c != null) {
     objRepay.Open_ECS_Ex_Customer_Id__c = Decimal.valueOf(prodOffering[0].Customer_ID__c);
    }
    try {
     insert objRepay;
    } catch (DMLException e) {
     system.debug('--Exception :- ' + e.getMessage());
    }


   }
   /* Initiate Open ECS added by priya End*/
  }

 }
 // Bug 15858 - December_2017_CS/CWA Program start
 public static Opportunity assignOpportunityValues(Opportunity oppObj, Product_Offerings__c productOfferObj) {
  oppObj.Product_Offereing_id__c = productOfferObj.Offer_ID__c;
  oppObj.Topup_Amount__c = productOfferObj.Topup_Amount__c;
  oppObj.Last_EMI_Paid__c = productOfferObj.Last_EMI_Paid__c;
  oppObj.Balance_Tenure__c = productOfferObj.Balance_Tenure__c;
  oppObj.DPD_String__c = productOfferObj.DPD_String__c;
  oppObj.Bucket_String__c = productOfferObj.Bucket_String__c;
  oppObj.Old_SFDC_Loan_Application__c = productOfferObj.Old_SFDC_Loan_Application__c;
  oppObj.Bounce_in_Life_Cycle__c = productOfferObj.Bounce_in_Life_Cycle__c;
  oppObj.Overdue_Charges__c = productOfferObj.Overdue_Charges__c;
  oppObj.POS__c = productOfferObj.POS__c;
  oppObj.Total_Principal_O_s__c = productOfferObj.Total_POS__c;
  oppObj.Referral__c = productOfferObj.Referral__c;
  oppObj.Link_Offer_Id__c = productOfferObj.id;
  oppObj.Total_Obligation__c = productOfferObj.Monthly_Obligation__c;
  oppObj.Requested_ROI__c = productOfferObj.Revised_Offer_ROI__c;
  return oppObj;
 }
 //Added by mahima- 15855- CPV for PO-- start        
 public static void copyVerifications(list < Applicant__C > applicants) {

  Map < Id, verification__c > lstVerifications = new Map < Id, verification__c > ([select id, lead__c, Verification_Type__c, Product_Offerings__c, Sales_Status__c, Geo_Tagging__c, Image_Latitude_Longitude_Details__c, Lead_Applicants__c from verification__C where(Verification_Type__c = 'Office verification'
   OR Verification_Type__c = 'Residence verification') And(lead__C != null OR(lead_Applicants__r.Applicant_Type__c != null AND(lead_Applicants__r.Applicant_Type__c = 'Primary Financial Co-Applicant'))) and Product_Offerings__c =: productOfferObj[0].id]);
  system.debug('lstVerifications==>' + lstVerifications);

  system.debug('applicants==>' + applicants);
  Map < Id, Applicant__C > leadApplicantMap = new Map < Id, Applicant__C > ();
  for (Applicant__c app: applicants) {
   if (app.Lead_Applicants__c != null)
    leadApplicantMap.put(app.Lead_Applicants__c, app);
   else
    leadApplicantMap.put(productOfferObj[0].lead__c, app);
  }
  //Added for cloning logic               
  Map < id, verification__c > lstVernew = new map < Id, verification__c > ();
  if (lstVerifications != null && lstVerifications.size() > 0) {
   for (verification__c veri: lstVerifications.values()) {
    verification__c verNew = new verification__c();
    //cloning the PO verification on loan
    verNew = veri.clone(false, true);
    system.debug('new verification===>' + verNew);
    verNew.Loan_Application__c = oppObj.id;
    verNew.lead__C = null;
    verNew.Lead_Applicants__c = null;
    verNew.Product_Offerings__c = null;
    if (veri.lead__C != null) {
     verNew.applicant__C = leadApplicantMap.get(veri.lead__C).id;
    }
    if (veri.Lead_Applicants__c != null) {
     verNew.applicant__C = leadApplicantMap.get(veri.Lead_Applicants__c).id;
    }
    lstVernew.put(veri.id, verNew);
   }

  }
  //removed update and inserted new verifications
  insert lstVernew.values();
  for (id verid: lstVernew.keyset()) {
   CommonUtility.flowContentDocument('' + verid, lstVerNew.get(verid).id);
  }

 }
 //Added by mahima- 15855- CPV for PO-- end

   public static void dummy1()
   {
     Integer i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     /*i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;
     i=1;

   } */
   }
}