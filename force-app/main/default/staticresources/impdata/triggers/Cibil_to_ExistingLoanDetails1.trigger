trigger Cibil_to_ExistingLoanDetails1 on CIBIL__c(after insert, after update) {
public String mobProd = '';//844-0mob
    //added for 20311
      List<String> s = new List<String>();
   // s= Label.DummyApplicant.toUpperCase().Split(';');     
        
    s = CommonUtility.dummyapplicantsList(); // Bug-21966
    //Rohit added for bug 21238 start
    Boolean isBlPlProduct = false;
    Boolean isPLBLRisk = false;//Bug 23425
    //Rohit added for bug 21238 stop
    
    //26861 s
    List<String> SecLoans;
    if(!commonUtility.isEmpty(Label.SecuredProducts)){
        SecLoans = Label.SecuredProducts.split(';');
    }
    //26861 e
    public boolean creditcardNumber=false;
    public set < id > cid = new set < id > (); 
    set < id > loanappid = new set < id > ();
    List < Applicant__c > applicant = new List < Applicant__c > ();
    list < CIBIL__c > cibillist = new list < CIBIL__c > ();
    //list < CIBIL__c > cibillistfapp = new list < CIBIL__c > ();
    list < CIBIL__c > clist = new list < CIBIL__c > ();
    //code added Bug : 21238  ELDELDInsertAndMOBCalc start
    Map<String,Object> ALLMap = new Map<String,Object>();//844-0mob
    Map<String,Object> ELDELDInsertAndMOBCalc=new Map<String,Object>();//844-0mob
    Set<String> eldProducts=new Set<String>();//844-0mob
    Set<String> setAccountType=new Set<String>();
    public Decimal maxLoanAmount=0;
    public Decimal maxMOB=0;
    public Decimal mobValue=0;
    public Set<String>appIDsUpdated=new Set<String>();
    //code added Bug : 21238  ELDELDInsertAndMOBCalc end
    //BUG-17470 HPRO 
    public boolean isPROProductLineProduct = false;
    list < CIBIL__c > cibilListToProcess = new list < CIBIL__c > ();
    list < Cibil_Extension1__c > lstCibilExt1 = new list < Cibil_Extension1__c > ();
    list < Cibil_Extension1__c > cexlistToBeUpdated = new list < Cibil_Extension1__c > ();
    public decimal unsecuredCurrentBalance = 0.0, totalLiveUnsecuredSanctionAmount = 0.0, totalUnsecuredSanctionAmount = 0.0, securedCurrentBalance = 0.0, totalSecuredSanctionAmount = 0.0, totalBalance = 0.0, totalClosedUnsecuredSanctionAmount = 0.0, totalSanctionAmount = 0.0, balAmount = 0.0, sanAmount= 0.0;
    public Integer  /*Bug 17138 s*/XDPDCC = 0,X30DPDCC = 0,X90DPD6Months=0,X30DPDGL = 0,assetView = 0,/*Bug 17138 e*/X30DPD3Months = 0,/*OTP V3 Cibil*/ X30DPD6Months = 0, maxDueEver = 0, max, min, liveUnsecuredLoanCnt = 0, allUnsecuredCnt = 0, maxDue = 0, delinquentTradecnt = 0, delinquentSecuredTradelines = 0, totalTL = 0, unsecuredTL = 0, unsecuredTLCnt = 0, enquiry = 0, unsecuredEnquiry = 0, maxDelinquencyCnt = 0;
    public boolean everWriteOff = false;
    public Integer noOfLivePL_BL_Cib_ext1 = 0,TDWithSubstrCount = 0,X30DPD6Months_POS=0,X30DPD12Months=0,X30LessDPD3Months=0,X3LessmonthsDPD = 0,dpdLast24Mnths = 0, noOfDPD24Months = 0;//POS_disbursal// Bug Id : 20187
/* Start added variable by Mahima for Bug-17588*/
   public Integer X30DPD12MonthsWithoutCCGL = 0;
   /* End added variable by Mahima for Bug-17588*/
    
    /*Start: Bug:16959*/
     public boolean isPSBLProductLineProduct = false;
    /*End: Bug:16959*/
    public Date firstLoan, latestLoan;
    set < id > clist2 = new set < id > ();
    String product;
    Boolean isPro=false;
    String lblCiblquery;
    Integer daysclosed = 1000;
    String SegmentProduct='';
    list < Existing_Loan_Details__c > elist = new list < Existing_Loan_Details__c > ();
    list < Existing_Loan_Details__c > eld = new list < Existing_Loan_Details__c > ();
    boolean cibilstart = false;
    date cibilFiredDate;
    List<String> lstCibilExtension = new List<String>();
    Map<String,Cibil_Extension1__c> mapIDCibilExt  = new Map<String,Cibil_Extension1__c>();
    List<String> lstLoanAppliactionIds = new List<String>();
    Map<String,String> mapOppIDAndPoID = new Map<String,String>();
    system.debug('in Cibil_to_ExistingLoanDetails1');
    Set<String> setProdToCheck = new Set<String>();
    String poToUpdate ='';
    Boolean isPOConverted =false;
    //Boolean oppStampedOnPo = false ;
    //17138 added noOfPLEnquiriesIn3M;
    public Integer noOfPLEnquiriesIn3M=0,/* OTP V3 Cibil*/noOfEnquiriesIn12M = 0, noOfPLEnquiriesIn12M=0,noOfPLEnquiriesIn6M=0,sumOfAmountOverdue=0; //SAL Policy Change Strat
    //SAL Policy Rule Changes :: Added by Pritha :: start
    public Integer noOfLivePL_Cib_ext1=0;
    //SAL Policy Rule Changes :: Added by Pritha :: end
    //Added By Rajendra for new HBLS product
    public string ProductForFlowLabel = Label.New_Products_for_Flow;
    //Bug 13830:Custom label added for new products
    public set<string> NewProductsAdded = new set<string>();
    for(String val : System.label.New_Products_Added.split(','))
    {
        
        NewProductsAdded.add(val);
        
    }
     //code added Bug : 21238  ELDELDInsertAndMOBCalc start //844-start
        ALLMap=GeneralUtilities.fetchStaticRescMap();
        ELDELDInsertAndMOBCalc =(Map<String,Object>)ALLMap.get('MOBCalcSALSPL');
        if(ELDELDInsertAndMOBCalc.get('Products')!=null)
        eldProducts.addAll(((String) ELDELDInsertAndMOBCalc.get('Products')).split(','));//844-stop
        if(ELDELDInsertAndMOBCalc.get('AccountType')!=null)
        setAccountType.addAll(((String) ELDELDInsertAndMOBCalc.get('AccountType')).split(','));
        if(ELDELDInsertAndMOBCalc.get('MaxLoanAmount')!=null)
        maxLoanAmount=Integer.valueOf(ELDELDInsertAndMOBCalc.get('MaxLoanAmount'));
        if(ELDELDInsertAndMOBCalc.get('MaxLoanAmount')!=null)
        maxMOB=Integer.valueOf(ELDELDInsertAndMOBCalc.get('MaxMOB'));
        //code added Bug : 21238  ELDELDInsertAndMOBCalc End
    system.debug('List Of Products'+NewProductsAdded);

    
    if (!ControlRecursiveCallofTrigger_Util.hasCibil_to_ExistingLoanDetails()) {
        ControlRecursiveCallofTrigger_Util.setCibil_to_ExistingLoanDetails();
        for (CIBIL__c c: trigger.new) {
            cid.add(c.id);
        }
        
        Map < String, Schema.SObjectField > M1 = Schema.SObjectType.CIBIL__c.fields.getMap();
        String SOQL1 = 'Select ';
        for (String fieldName: M1.keySet()) {                                
            SOQL1 += fieldName + ',';                      
        }
        
        
        /*Prajyot #12269: added Cibil_Temp__r.SecondaryMatch_Record__c*/
        //SOQL1 += ' applicant__r.Product__c ,Lead__r.Recent_PO_for_cibil_requested__r.products__c  ,CIBIL_Extension__r.Amount_Overdue20__c, CIBIL_Extension__r.Amount_Overdue21__c, CIBIL_Extension__r.Amount_Overdue22__c,CIBIL_Extension__r.Amount_Overdue23__c, CIBIL_Extension__r.Amount_Overdue24__c, CIBIL_Extension__r.Amount_Overdue25__c,CIBIL_Extension__r.Amount_Overdue26__c, CIBIL_Extension__r.Amount_Overdue27__c, CIBIL_Extension__r.Amount_Overdue28__c,CIBIL_Extension__r.Amount_Overdue29__c,CIBIL_Extension__r.Sanction_Amount20__c, CIBIL_Extension__r.Sanction_Amount21__c, CIBIL_Extension__r.Sanction_Amount22__c,CIBIL_Extension__r.Sanction_Amount23__c, CIBIL_Extension__r.Sanction_Amount24__c, CIBIL_Extension__r.Sanction_Amount25__c,CIBIL_Extension__r.Sanction_Amount26__c, CIBIL_Extension__r.Sanction_Amount27__c, CIBIL_Extension__r.Sanction_Amount28__c,CIBIL_Extension__r.Sanction_Amount29__c, CIBIL_Extension__r.Suit_Filed_Status20__c, CIBIL_Extension__r.Suit_Filed_Status21__c,CIBIL_Extension__r.Suit_Filed_Status22__c, CIBIL_Extension__r.Suit_Filed_Status23__c, CIBIL_Extension__r.Suit_Filed_Status24__c,CIBIL_Extension__r.Suit_Filed_Status25__c, CIBIL_Extension__r.Suit_Filed_Status26__c, CIBIL_Extension__r.Suit_Filed_Status27__c,CIBIL_Extension__r.Suit_Filed_Status28__c, CIBIL_Extension__r.Suit_Filed_Status29__c, CIBIL_Extension__r.Current_Balance20__c,CIBIL_Extension__r.Current_Balance21__c, CIBIL_Extension__r.Current_Balance22__c, CIBIL_Extension__r.Current_Balance23__c,CIBIL_Extension__r.Current_Balance24__c, CIBIL_Extension__r.Current_Balance25__c, CIBIL_Extension__r.Current_Balance26__c,CIBIL_Extension__r.Current_Balance27__c, CIBIL_Extension__r.Current_Balance28__c, CIBIL_Extension__r.Current_Balance29__c,CIBIL_Extension__r.Date_Closed20__c, CIBIL_Extension__r.Date_Closed21__c, CIBIL_Extension__r.Date_Closed22__c,CIBIL_Extension__r.Date_Closed23__c, CIBIL_Extension__r.Date_Closed24__c, CIBIL_Extension__r.Date_Closed25__c,CIBIL_Extension__r.Date_Closed26__c, CIBIL_Extension__r.Date_Closed27__c, CIBIL_Extension__r.Date_Closed28__c,CIBIL_Extension__r.Date_Closed29__c, CIBIL_Extension__r.Account_Type20__c, CIBIL_Extension__r.Account_Type21__c,CIBIL_Extension__r.Account_Type22__c, CIBIL_Extension__r.Account_Type23__c, CIBIL_Extension__r.Account_Type24__c,CIBIL_Extension__r.Account_Type25__c, CIBIL_Extension__r.Account_Type26__c, CIBIL_Extension__r.Account_Type27__c,CIBIL_Extension__r.Account_Type28__c, CIBIL_Extension__r.Account_Type29__c,      CIBIL_Extension__r.Ownership20__c, CIBIL_Extension__r.Ownership21__c, CIBIL_Extension__r.Ownership22__c, CIBIL_Extension__r.Ownership23__c,CIBIL_Extension__r.Ownership24__c, CIBIL_Extension__r.Ownership25__c, CIBIL_Extension__r.Ownership26__c, CIBIL_Extension__r.Ownership27__c,CIBIL_Extension__r.Ownership28__c, CIBIL_Extension__r.Ownership29__c,CIBIL_Extension__r.Date_Opened20__c, CIBIL_Extension__r.Date_Opened21__c,CIBIL_Extension__r.Date_Opened22__c, CIBIL_Extension__r.Date_Opened23__c, CIBIL_Extension__r.Date_Opened24__c, CIBIL_Extension__r.Date_Opened25__c,CIBIL_Extension__r.Date_Opened26__c, CIBIL_Extension__r.Date_Opened27__c, CIBIL_Extension__r.Date_Opened28__c, CIBIL_Extension__r.Date_Opened29__c,CIBIL_Extension__r.Days_Past_Due20__c, CIBIL_Extension__r.Days_Past_Due21__c,CIBIL_Extension__r.Days_Past_Due22__c, CIBIL_Extension__r.Days_Past_Due23__c,CIBIL_Extension__r.Days_Past_Due24__c, CIBIL_Extension__r.Days_Past_Due25__c, CIBIL_Extension__r.Days_Past_Due26__c, CIBIL_Extension__r.Days_Past_Due27__c,CIBIL_Extension__r.Days_Past_Due28__c, CIBIL_Extension__r.Days_Past_Due29__c, CIBIL_Extension__r.Enquiry_Purpose20__c, CIBIL_Extension__r.Enquiry_Purpose21__c,CIBIL_Extension__r.Enquiry_Purpose22__c, CIBIL_Extension__r.Enquiry_Purpose23__c, CIBIL_Extension__r.Enquiry_Purpose24__c,CIBIL_Extension__r.Enquiry_Purpose25__c, CIBIL_Extension__r.Enquiry_Purpose26__c, CIBIL_Extension__r.Enquiry_Purpose27__c,CIBIL_Extension__r.Enquiry_Purpose28__c, CIBIL_Extension__r.Enquiry_Purpose29__c, CIBIL_Extension__r.Date_of_Enquiry20__c,CIBIL_Extension__r.Date_of_Enquiry21__c, CIBIL_Extension__r.Date_of_Enquiry22__c, CIBIL_Extension__r.Date_of_Enquiry23__c,CIBIL_Extension__r.Date_of_Enquiry24__c, CIBIL_Extension__r.Date_of_Enquiry25__c, CIBIL_Extension__r.Date_of_Enquiry26__c,CIBIL_Extension__r.Date_of_Enquiry27__c, CIBIL_Extension__r.Date_of_Enquiry28__c, CIBIL_Extension__r.Date_of_Enquiry29__c      ,Applicant__r.Loan_Application__c, Applicant__r.Lead__c  ,Applicant__r.Contact_Name__r.ApplicantType__c,Applicant__r.Loan_Application__r.Product__c,CIBIL_Extension__r.CreatedDate from  CIBIL__c where ID IN: cid';
        SOQL1 += ' applicant__r.Product__c ,Lead__r.Recent_PO_for_cibil_requested__r.products__c ,Cibil_Extension1__r.Written_Off_and_settled_status__c,Cibil_Extension1__r.Written_Off_and_settled_status1__c,Cibil_Extension1__r.Written_Off_and_settled_status2__c,Cibil_Extension1__r.Written_Off_and_settled_status3__c,Cibil_Extension1__r.Written_Off_and_settled_status4__c,Cibil_Extension1__r.Written_Off_and_settled_status5__c,Cibil_Extension1__r.Written_Off_and_settled_status6__c,Cibil_Extension1__r.Written_Off_and_settled_status7__c,Cibil_Extension1__r.Written_Off_and_settled_status8__c,Cibil_Extension1__r.Written_Off_and_settled_status9__c,Cibil_Extension1__r.Written_Off_and_settled_status10__c,Cibil_Extension1__r.Written_Off_and_settled_status11__c,Cibil_Extension1__r.Written_Off_and_settled_status12__c,Cibil_Extension1__r.Written_Off_and_settled_status13__c,Cibil_Extension1__r.Written_Off_and_settled_status14__c,Cibil_Extension1__r.Written_Off_and_settled_status15__c,Cibil_Extension1__r.Written_Off_and_settled_status16__c,Cibil_Extension1__r.Written_Off_and_settled_status17__c,Cibil_Extension1__r.Written_Off_and_settled_status18__c,Cibil_Extension1__r.Written_Off_and_settled_status19__c,Cibil_Extension1__r.Written_Off_and_settled_status20__c,Cibil_Extension1__r.Written_Off_and_settled_status21__c,Cibil_Extension1__r.Written_Off_and_settled_status22__c,Cibil_Extension1__r.Written_Off_and_settled_status23__c,Cibil_Extension1__r.Written_Off_and_settled_status24__c,Cibil_Extension1__r.Written_Off_and_settled_status25__c,Cibil_Extension1__r.Written_Off_and_settled_status26__c,Cibil_Extension1__r.Written_Off_and_settled_status27__c,Cibil_Extension1__r.Written_Off_and_settled_status28__c,Cibil_Extension1__r.Written_Off_and_settled_status29__c,CIBIL_Extension__r.Amount_Overdue20__c, CIBIL_Extension__r.Amount_Overdue21__c, CIBIL_Extension__r.Amount_Overdue22__c,CIBIL_Extension__r.Amount_Overdue23__c, CIBIL_Extension__r.Amount_Overdue24__c, CIBIL_Extension__r.Amount_Overdue25__c,CIBIL_Extension__r.Amount_Overdue26__c, CIBIL_Extension__r.Amount_Overdue27__c, CIBIL_Extension__r.Amount_Overdue28__c,CIBIL_Extension__r.Amount_Overdue29__c,CIBIL_Extension__r.Sanction_Amount20__c, CIBIL_Extension__r.Sanction_Amount21__c, CIBIL_Extension__r.Sanction_Amount22__c,CIBIL_Extension__r.Sanction_Amount23__c, CIBIL_Extension__r.Sanction_Amount24__c, CIBIL_Extension__r.Sanction_Amount25__c,CIBIL_Extension__r.Sanction_Amount26__c, CIBIL_Extension__r.Sanction_Amount27__c, CIBIL_Extension__r.Sanction_Amount28__c,CIBIL_Extension__r.Sanction_Amount29__c, CIBIL_Extension__r.Suit_Filed_Status20__c, CIBIL_Extension__r.Suit_Filed_Status21__c,CIBIL_Extension__r.Suit_Filed_Status22__c, CIBIL_Extension__r.Suit_Filed_Status23__c, CIBIL_Extension__r.Suit_Filed_Status24__c,CIBIL_Extension__r.Suit_Filed_Status25__c, CIBIL_Extension__r.Suit_Filed_Status26__c, CIBIL_Extension__r.Suit_Filed_Status27__c,CIBIL_Extension__r.Suit_Filed_Status28__c, CIBIL_Extension__r.Suit_Filed_Status29__c, CIBIL_Extension__r.Current_Balance20__c,CIBIL_Extension__r.Current_Balance21__c, CIBIL_Extension__r.Current_Balance22__c, CIBIL_Extension__r.Current_Balance23__c,CIBIL_Extension__r.Current_Balance24__c, CIBIL_Extension__r.Current_Balance25__c, CIBIL_Extension__r.Current_Balance26__c,CIBIL_Extension__r.Current_Balance27__c, CIBIL_Extension__r.Current_Balance28__c, CIBIL_Extension__r.Current_Balance29__c,CIBIL_Extension__r.Date_Closed20__c, CIBIL_Extension__r.Date_Closed21__c, CIBIL_Extension__r.Date_Closed22__c,CIBIL_Extension__r.Date_Closed23__c, CIBIL_Extension__r.Date_Closed24__c, CIBIL_Extension__r.Date_Closed25__c,CIBIL_Extension__r.Date_Closed26__c, CIBIL_Extension__r.Date_Closed27__c, CIBIL_Extension__r.Date_Closed28__c,CIBIL_Extension__r.Date_Closed29__c, CIBIL_Extension__r.Account_Type20__c, CIBIL_Extension__r.Account_Type21__c,CIBIL_Extension__r.Account_Type22__c, CIBIL_Extension__r.Account_Type23__c, CIBIL_Extension__r.Account_Type24__c,CIBIL_Extension__r.Account_Type25__c, CIBIL_Extension__r.Account_Type26__c, CIBIL_Extension__r.Account_Type27__c,CIBIL_Extension__r.Account_Type28__c, CIBIL_Extension__r.Account_Type29__c,      CIBIL_Extension__r.Ownership20__c, CIBIL_Extension__r.Ownership21__c, CIBIL_Extension__r.Ownership22__c, CIBIL_Extension__r.Ownership23__c,CIBIL_Extension__r.Ownership24__c, CIBIL_Extension__r.Ownership25__c, CIBIL_Extension__r.Ownership26__c, CIBIL_Extension__r.Ownership27__c,CIBIL_Extension__r.Ownership28__c, CIBIL_Extension__r.Ownership29__c,CIBIL_Extension__r.Date_Opened20__c, CIBIL_Extension__r.Date_Opened21__c,CIBIL_Extension__r.Date_Opened22__c, CIBIL_Extension__r.Date_Opened23__c, CIBIL_Extension__r.Date_Opened24__c, CIBIL_Extension__r.Date_Opened25__c,CIBIL_Extension__r.Date_Opened26__c, CIBIL_Extension__r.Date_Opened27__c, CIBIL_Extension__r.Date_Opened28__c, CIBIL_Extension__r.Date_Opened29__c,CIBIL_Extension__r.Days_Past_Due20__c, CIBIL_Extension__r.Days_Past_Due21__c,CIBIL_Extension__r.Days_Past_Due22__c, CIBIL_Extension__r.Days_Past_Due23__c,CIBIL_Extension__r.Days_Past_Due24__c, CIBIL_Extension__r.Days_Past_Due25__c, CIBIL_Extension__r.Days_Past_Due26__c, CIBIL_Extension__r.Days_Past_Due27__c,CIBIL_Extension__r.Days_Past_Due28__c, CIBIL_Extension__r.Days_Past_Due29__c, CIBIL_Extension__r.Enquiry_Purpose20__c, CIBIL_Extension__r.Enquiry_Purpose21__c,CIBIL_Extension__r.Enquiry_Purpose22__c, CIBIL_Extension__r.Enquiry_Purpose23__c, CIBIL_Extension__r.Enquiry_Purpose24__c,CIBIL_Extension__r.Enquiry_Purpose25__c, CIBIL_Extension__r.Enquiry_Purpose26__c, CIBIL_Extension__r.Enquiry_Purpose27__c,CIBIL_Extension__r.Enquiry_Purpose28__c, CIBIL_Extension__r.Enquiry_Purpose29__c, CIBIL_Extension__r.Date_of_Enquiry20__c,CIBIL_Extension__r.Date_of_Enquiry21__c, CIBIL_Extension__r.Date_of_Enquiry22__c, CIBIL_Extension__r.Date_of_Enquiry23__c,CIBIL_Extension__r.Date_of_Enquiry24__c, CIBIL_Extension__r.Date_of_Enquiry25__c, CIBIL_Extension__r.Date_of_Enquiry26__c,CIBIL_Extension__r.Date_of_Enquiry27__c, CIBIL_Extension__r.Date_of_Enquiry28__c, CIBIL_Extension__r.Date_of_Enquiry29__c      ,Applicant__r.Loan_Application__c, Applicant__r.Lead__c  ,Applicant__r.Contact_Name__r.ApplicantType__c,Applicant__r.Loan_Application__r.Product__c,CIBIL_Extension__r.CreatedDate, Cibil_Temp__r.SecondaryMatch_Record__c,CIBIL_Extension__r.Member20__c,CIBIL_Extension__r.Member21__c,CIBIL_Extension__r.Member22__c,CIBIL_Extension__r.Member23__c,CIBIL_Extension__r.Member24__c,CIBIL_Extension__r.Member25__c,CIBIL_Extension__r.Member26__c,CIBIL_Extension__r.Member27__c,CIBIL_Extension__r.Member28__c,Cibil_Temp__r.salaried__c from  CIBIL__c where ID IN: cid';   //Bug 24640 - DG Online for SOL and PLCS
        
        //cibil_rule_status_field__c CIBIL_Extension__r
        System.debug('cid::'+cid + ':::SOQL1:::' + SOQL1 );
        cibillist = Database.query(SOQL1);           
        system.debug('::cibillist::'+cibillist);  
        
        /*system.debug('cccccccccccc' + cid);
        cibillist = [select id, applicant__c, applicant__r.Product__c,CIBIL_Fired_time__c, Lead__c, Lead_Applicants__c, Enable_Manual_Cibil__c, Days_Past_Due1__c, Days_Past_Due2__c, Days_Past_Due3__c,
        Days_Past_Due4__c, Days_Past_Due5__c, Days_Past_Due6__c, Days_Past_Due7__c, Days_Past_Due8__c, Days_Past_Due9__c, Days_Past_Due10__c,
        Days_Past_Due11__c, Days_Past_Due12__c, Days_Past_Due13__c, Days_Past_Due14__c, Days_Past_Due15__c, Days_Past_Due16__c,
        Days_Past_Due17__c, Days_Past_Due18__c, Days_Past_Due19__c, Days_Past_Due__c, Amount_Overdue1__c, Amount_Overdue2__c, Amount_Overdue3__c,
        Amount_Overdue4__c, Amount_Overdue5__c, Amount_Overdue6__c, Amount_Overdue7__c, Amount_Overdue8__c, Amount_Overdue9__c,
        Amount_Overdue10__c, Amount_Overdue11__c, Amount_Overdue12__c, Amount_Overdue13__c, Amount_Overdue14__c, Amount_Overdue15__c,
        Amount_Overdue16__c, Amount_Overdue17__c, Amount_Overdue18__c, Amount_Overdue19__c, Amount_Overdue__c, Suit_Filed_Status1__c,
        Suit_Filed_Status2__c, Suit_Filed_Status3__c, Suit_Filed_Status4__c, Suit_Filed_Status5__c, Suit_Filed_Status6__c, Suit_Filed_Status7__c,
        Suit_Filed_Status8__c, Suit_Filed_Status9__c, Suit_Filed_Status10__c, Suit_Filed_Status11__c, Suit_Filed_Status12__c,
        Suit_Filed_Status13__c, Suit_Filed_Status14__c, Suit_Filed_Status15__c, Suit_Filed_Status16__c, Suit_Filed_Status17__c,
        Suit_Filed_Status18__c, Suit_Filed_Status19__c, Suit_Filed_Status__c, Date_Closed1__c, Date_Closed2__c, Date_Closed3__c,
        Date_Closed4__c, Date_Closed5__c, Date_Closed6__c, Date_Closed7__c, Date_Closed8__c, Date_Closed9__c, Date_Closed10__c, Date_Closed11__c,
        Date_Closed12__c, Date_Closed13__c, Date_Closed14__c, Date_Closed15__c, Date_Closed16__c, Date_Closed17__c, Date_Closed18__c,
        Date_Closed19__c, Date_Closed__c, Date_Opened1__c, Date_Opened2__c, Date_Opened3__c, Date_Opened4__c, Date_Opened5__c, Date_Opened6__c,
        Date_Opened7__c, Date_Opened8__c, Date_Opened9__c, Date_Opened10__c, Date_Opened11__c, Date_Opened12__c, Date_Opened13__c,
        Date_Opened14__c, Date_Opened15__c, Date_Opened16__c, Date_Opened17__c, Date_Opened18__c, Date_Opened19__c, Date_Opened__c,
        Account_Type1__c, Account_Type2__c, Account_Type3__c, Account_Type4__c, Account_Type5__c, Account_Type6__c, Account_Type7__c,
        Account_Type8__c, Account_Type9__c, Account_Type10__c, Account_Type11__c, Account_Type12__c, Account_Type13__c, Account_Type14__c,
        Account_Type15__c, Account_Type16__c, Account_Type17__c, Account_Type18__c, Account_Type19__c, Account_Type__c, Sanction_Amount1__c,
        Sanction_Amount2__c, Sanction_Amount3__c, Sanction_Amount4__c, Sanction_Amount5__c, Sanction_Amount6__c, Sanction_Amount7__c,
        Sanction_Amount8__c, Sanction_Amount9__c, Sanction_Amount10__c, Sanction_Amount11__c, Sanction_Amount12__c, Sanction_Amount13__c,
        Sanction_Amount14__c, Sanction_Amount15__c, Sanction_Amount16__c, Sanction_Amount17__c, Sanction_Amount18__c, Sanction_Amount19__c,
        Sanction_Amount__c, Current_Balance1__c, Current_Balance2__c, Current_Balance3__c, Current_Balance4__c, Current_Balance5__c,
        Current_Balance6__c, Current_Balance7__c, Current_Balance8__c, Current_Balance9__c, Current_Balance10__c, Current_Balance11__c,
        Current_Balance12__c, Current_Balance13__c, Current_Balance14__c, Current_Balance15__c, Current_Balance16__c, Current_Balance17__c,
        Current_Balance18__c, Current_Balance19__c, Current_Balance__c, Enquiry_Purpose1__c, Enquiry_Purpose2__c, Enquiry_Purpose3__c,
        Enquiry_Purpose4__c, Enquiry_Purpose5__c, Enquiry_Purpose6__c, Enquiry_Purpose7__c, Enquiry_Purpose8__c, Enquiry_Purpose9__c,
        Enquiry_Purpose10__c, Enquiry_Purpose11__c, Enquiry_Purpose12__c, Enquiry_Purpose13__c, Enquiry_Purpose14__c, Enquiry_Purpose15__c,
        Enquiry_Purpose16__c, Enquiry_Purpose17__c, Enquiry_Purpose18__c, Enquiry_Purpose19__c, Enquiry_Purpose__c, Date_of_Enquiry1__c,
        Date_of_Enquiry2__c, Date_of_Enquiry3__c, Date_of_Enquiry4__c, Date_of_Enquiry5__c, Date_of_Enquiry6__c, Date_of_Enquiry7__c,
        Date_of_Enquiry8__c, Date_of_Enquiry9__c, Date_of_Enquiry10__c, Date_of_Enquiry11__c, Date_of_Enquiry12__c, Date_of_Enquiry13__c,
        Date_of_Enquiry14__c, Date_of_Enquiry15__c, Date_of_Enquiry16__c, Date_of_Enquiry17__c, Date_of_Enquiry18__c, Date_of_Enquiry19__c,
        Date_of_Enquiry__c, CIBIL_Extension__c, CIBIL_Extension1__c,
        CIBIL_Extension__r.Amount_Overdue20__c, CIBIL_Extension__r.Amount_Overdue21__c, CIBIL_Extension__r.Amount_Overdue22__c,
        CIBIL_Extension__r.Amount_Overdue23__c, CIBIL_Extension__r.Amount_Overdue24__c, CIBIL_Extension__r.Amount_Overdue25__c,
        CIBIL_Extension__r.Amount_Overdue26__c, CIBIL_Extension__r.Amount_Overdue27__c, CIBIL_Extension__r.Amount_Overdue28__c,
        CIBIL_Extension__r.Amount_Overdue29__c,
        CIBIL_Extension__r.Sanction_Amount20__c, CIBIL_Extension__r.Sanction_Amount21__c, CIBIL_Extension__r.Sanction_Amount22__c,
        CIBIL_Extension__r.Sanction_Amount23__c, CIBIL_Extension__r.Sanction_Amount24__c, CIBIL_Extension__r.Sanction_Amount25__c,
        CIBIL_Extension__r.Sanction_Amount26__c, CIBIL_Extension__r.Sanction_Amount27__c, CIBIL_Extension__r.Sanction_Amount28__c,
        CIBIL_Extension__r.Sanction_Amount29__c, CIBIL_Extension__r.Suit_Filed_Status20__c, CIBIL_Extension__r.Suit_Filed_Status21__c,
        CIBIL_Extension__r.Suit_Filed_Status22__c, CIBIL_Extension__r.Suit_Filed_Status23__c, CIBIL_Extension__r.Suit_Filed_Status24__c,
        CIBIL_Extension__r.Suit_Filed_Status25__c, CIBIL_Extension__r.Suit_Filed_Status26__c, CIBIL_Extension__r.Suit_Filed_Status27__c,
        CIBIL_Extension__r.Suit_Filed_Status28__c, CIBIL_Extension__r.Suit_Filed_Status29__c, CIBIL_Extension__r.Current_Balance20__c,
        CIBIL_Extension__r.Current_Balance21__c, CIBIL_Extension__r.Current_Balance22__c, CIBIL_Extension__r.Current_Balance23__c,
        CIBIL_Extension__r.Current_Balance24__c, CIBIL_Extension__r.Current_Balance25__c, CIBIL_Extension__r.Current_Balance26__c,
        CIBIL_Extension__r.Current_Balance27__c, CIBIL_Extension__r.Current_Balance28__c, CIBIL_Extension__r.Current_Balance29__c,
        CIBIL_Extension__r.Date_Closed20__c, CIBIL_Extension__r.Date_Closed21__c, CIBIL_Extension__r.Date_Closed22__c,
        CIBIL_Extension__r.Date_Closed23__c, CIBIL_Extension__r.Date_Closed24__c, CIBIL_Extension__r.Date_Closed25__c,
        CIBIL_Extension__r.Date_Closed26__c, CIBIL_Extension__r.Date_Closed27__c, CIBIL_Extension__r.Date_Closed28__c,
        CIBIL_Extension__r.Date_Closed29__c, CIBIL_Extension__r.Account_Type20__c, CIBIL_Extension__r.Account_Type21__c,
        CIBIL_Extension__r.Account_Type22__c, CIBIL_Extension__r.Account_Type23__c, CIBIL_Extension__r.Account_Type24__c,
        CIBIL_Extension__r.Account_Type25__c, CIBIL_Extension__r.Account_Type26__c, CIBIL_Extension__r.Account_Type27__c,
        CIBIL_Extension__r.Account_Type28__c, CIBIL_Extension__r.Account_Type29__c,
        CIBIL_Extension__r.Ownership20__c, CIBIL_Extension__r.Ownership21__c, CIBIL_Extension__r.Ownership22__c, CIBIL_Extension__r.Ownership23__c,
        CIBIL_Extension__r.Ownership24__c, CIBIL_Extension__r.Ownership25__c, CIBIL_Extension__r.Ownership26__c, CIBIL_Extension__r.Ownership27__c,
        CIBIL_Extension__r.Ownership28__c, CIBIL_Extension__r.Ownership29__c,
        CIBIL_Extension__r.Date_Opened20__c, CIBIL_Extension__r.Date_Opened21__c,
        CIBIL_Extension__r.Date_Opened22__c, CIBIL_Extension__r.Date_Opened23__c, CIBIL_Extension__r.Date_Opened24__c, CIBIL_Extension__r.Date_Opened25__c,
        CIBIL_Extension__r.Date_Opened26__c, CIBIL_Extension__r.Date_Opened27__c, CIBIL_Extension__r.Date_Opened28__c, CIBIL_Extension__r.Date_Opened29__c,
        CIBIL_Extension__r.Days_Past_Due20__c, CIBIL_Extension__r.Days_Past_Due21__c, CIBIL_Extension__r.Days_Past_Due22__c, CIBIL_Extension__r.Days_Past_Due23__c,
        CIBIL_Extension__r.Days_Past_Due24__c, CIBIL_Extension__r.Days_Past_Due25__c, CIBIL_Extension__r.Days_Past_Due26__c, CIBIL_Extension__r.Days_Past_Due27__c,
        CIBIL_Extension__r.Days_Past_Due28__c, CIBIL_Extension__r.Days_Past_Due29__c, CIBIL_Extension__r.Enquiry_Purpose20__c, CIBIL_Extension__r.Enquiry_Purpose21__c,
        CIBIL_Extension__r.Enquiry_Purpose22__c, CIBIL_Extension__r.Enquiry_Purpose23__c, CIBIL_Extension__r.Enquiry_Purpose24__c,
        CIBIL_Extension__r.Enquiry_Purpose25__c, CIBIL_Extension__r.Enquiry_Purpose26__c, CIBIL_Extension__r.Enquiry_Purpose27__c,
        CIBIL_Extension__r.Enquiry_Purpose28__c, CIBIL_Extension__r.Enquiry_Purpose29__c, CIBIL_Extension__r.Date_of_Enquiry20__c,
        CIBIL_Extension__r.Date_of_Enquiry21__c, CIBIL_Extension__r.Date_of_Enquiry22__c, CIBIL_Extension__r.Date_of_Enquiry23__c,
        CIBIL_Extension__r.Date_of_Enquiry24__c, CIBIL_Extension__r.Date_of_Enquiry25__c, CIBIL_Extension__r.Date_of_Enquiry26__c,
        CIBIL_Extension__r.Date_of_Enquiry27__c, CIBIL_Extension__r.Date_of_Enquiry28__c, CIBIL_Extension__r.Date_of_Enquiry29__c
        from CIBIL__c where id = : cid];
        */
        
        if(cibillist!=null && cibillist.size()>0){
            
            if(cibillist[0].applicant__r.Product__c!=null){
                product= cibillist[0].applicant__r.Product__c;
                system.debug('&&&&product::'+product);
            }
            //17th May 2019
            
            // User story 760 USERSTORY_1_Rule 9 change in DI@POS for STP stamping S
            if(cibillist[0].lead__r != null && cibillist[0].lead__r.Recent_PO_for_cibil_requested__r != null && cibillist[0].lead__r.Recent_PO_for_cibil_requested__r.products__c !=null  )
            {
                product = cibillist[0].lead__r.Recent_PO_for_cibil_requested__r.products__c;
                system.debug('&&&&##product::'+product);
            }
            
            // User story 760 USERSTORY_1_Rule 9 change in DI@POS for STP stamping E
            //Rohit added for Bug 21238 start
            if(Label.BLPLProducts != null){
                    List<String> prodLst = Label.BLPLProducts.split(';');
                    if(prodLst != null && prodLst.contains(product))
                        isBlPlProduct = true;                 
            }
            //Rohit added for Bug 21238 stop
        }
        //Segmentation chnages
        ATOSParameters__c SegmentProducts = new ATOSParameters__c();
        SegmentProducts = ATOSParameters__c.getValues('SegmentationProducts');
        if (SegmentProducts != null && SegmentProducts.Product__c!=null) { 
            SegmentProduct = SegmentProducts.Product__c;
        }
        
        ATOSParameters__c secured = new ATOSParameters__c();
        
        String securedLoans = '';
        System.debug('*****SegmentProduct'+SegmentProduct);
        System.debug('*****product'+product);
        
        if(product!=null && SegmentProduct!=null && SegmentProduct.ToUpperCase().contains(product.ToUppercase())){
            secured = ATOSParameters__c.getValues('SegmentationSecuredLoan');
            securedLoans = secured.value__c;
        }else{
            if (secured != null && secured.value__c != null) {
                secured = ATOSParameters__c.getValues('Secured');
                securedLoans = secured.value__c;
            }
        }
        system.debug('cibillist--------'+cibillist);
        for (Cibil__c cb: cibillist) {
            try {
                
                if(cb.Cibil_Extension1__c !=null )
                lstCibilExtension.add(cb.Cibil_Extension1__c);
                if(cb.Applicant__c != null &&  cb.Applicant__r.Loan_Application__c != null)
                lstLoanAppliactionIds.add(cb.Applicant__r.Loan_Application__c);
                system.debug('::lstLoanAppliactionIds::'+lstLoanAppliactionIds);
                
                ATOSParameters__c CBSwitch = new ATOSParameters__c();
                CBSwitch = ATOSParameters__c.getValues('CodifiedBeurau_Switch');
                system.debug('**CBSwitch *'+CBSwitch);
                if (CBSwitch != null && CBSwitch.value__c != null && CBSwitch.value__c == 'ON') {
                    if (cb.Date_Opened__c != null) min = cb.Date_Opened__c.daysBetween(system.today());
                    if (cb.Date_Opened__c != null) max = cb.Date_Opened__c.daysBetween(system.today());
                    cibilFiredDate = cb.CIBIL_Fired_time__c != null ? date.valueOf(cb.CIBIL_Fired_time__c) : system.today();
                    checkMinMaxDate(cb.Date_Opened__c);
                    checkMinMaxDate(cb.Date_Opened1__c);
                    checkMinMaxDate(cb.Date_Opened2__c);
                    checkMinMaxDate(cb.Date_Opened3__c);
                    checkMinMaxDate(cb.Date_Opened4__c);
                    checkMinMaxDate(cb.Date_Opened5__c);
                    checkMinMaxDate(cb.Date_Opened6__c);
                    checkMinMaxDate(cb.Date_Opened7__c);
                    checkMinMaxDate(cb.Date_Opened8__c);
                    checkMinMaxDate(cb.Date_Opened9__c);
                    checkMinMaxDate(cb.Date_Opened10__c);
                    checkMinMaxDate(cb.Date_Opened11__c);
                    checkMinMaxDate(cb.Date_Opened12__c);
                    checkMinMaxDate(cb.Date_Opened13__c);
                    checkMinMaxDate(cb.Date_Opened14__c);
                    checkMinMaxDate(cb.Date_Opened15__c);
                    checkMinMaxDate(cb.Date_Opened16__c);
                    checkMinMaxDate(cb.Date_Opened17__c);
                    checkMinMaxDate(cb.Date_Opened18__c);
                    checkMinMaxDate(cb.Date_Opened19__c);
                    checkMinMaxDate(cb.CIBIL_Extension__r.Date_Opened20__c);
                    checkMinMaxDate(cb.CIBIL_Extension__r.Date_Opened21__c);
                    checkMinMaxDate(cb.CIBIL_Extension__r.Date_Opened22__c);
                    checkMinMaxDate(cb.CIBIL_Extension__r.Date_Opened23__c);
                    checkMinMaxDate(cb.CIBIL_Extension__r.Date_Opened24__c);
                    checkMinMaxDate(cb.CIBIL_Extension__r.Date_Opened25__c);
                    checkMinMaxDate(cb.CIBIL_Extension__r.Date_Opened26__c);
                    checkMinMaxDate(cb.CIBIL_Extension__r.Date_Opened27__c);
                    checkMinMaxDate(cb.CIBIL_Extension__r.Date_Opened28__c);
                    checkMinMaxDate(cb.CIBIL_Extension__r.Date_Opened29__c);
                    
                    
                    System.debug('*****SegmentProduct'+SegmentProduct);
                    System.debug('*****product'+product);
                     //Bug:17470
                          isPROProductLineProduct = getPROProductLineLFlag(product);
                    //Segmentation changes
                    if(product!=null && SegmentProduct!=null && (SegmentProduct.ToUpperCase().contains(product.ToUppercase()) || isPROProductLineProduct )){
                        //commenting below code for optimization
                        /*
                        if(cb.Account_Type__c != 'NO DATA' && cb.Date_Opened__c!=null)
                        calculateMaxDue(cb.Days_Past_Due__c, cb.Account_Type__c,cb.Date_Closed__c,cb.Ownership__c);
                        if(cb.Account_Type1__c != 'NO DATA' && cb.Date_Opened1__c!=null)    
                        calculateMaxDue(cb.Days_Past_Due1__c, cb.Account_Type1__c,cb.Date_Closed1__c,cb.Ownership1__c);
                        if(cb.Account_Type2__c != 'NO DATA' && cb.Date_Opened2__c!=null)      
                        calculateMaxDue(cb.Days_Past_Due2__c, cb.Account_Type2__c,cb.Date_Closed2__c,cb.Ownership2__c);
                        if(cb.Account_Type3__c != 'NO DATA' && cb.Date_Opened3__c!=null)      
                        calculateMaxDue(cb.Days_Past_Due3__c, cb.Account_Type3__c,cb.Date_Closed3__c,cb.Ownership3__c);
                        if(cb.Account_Type4__c != 'NO DATA' && cb.Date_Opened4__c!=null) 
                        calculateMaxDue(cb.Days_Past_Due4__c, cb.Account_Type4__c,cb.Date_Closed4__c,cb.Ownership4__c);
                        if(cb.Account_Type5__c != 'NO DATA' && cb.Date_Opened5__c!=null)      
                        calculateMaxDue(cb.Days_Past_Due5__c, cb.Account_Type5__c,cb.Date_Closed5__c,cb.Ownership5__c);
                        if(cb.Account_Type6__c != 'NO DATA' && cb.Date_Opened6__c!=null)      
                        calculateMaxDue(cb.Days_Past_Due6__c, cb.Account_Type6__c,cb.Date_Closed6__c,cb.Ownership6__c);
                        if(cb.Account_Type7__c != 'NO DATA' && cb.Date_Opened7__c!=null)      
                        calculateMaxDue(cb.Days_Past_Due7__c, cb.Account_Type7__c,cb.Date_Closed7__c,cb.Ownership7__c);
                        if(cb.Account_Type8__c != 'NO DATA' && cb.Date_Opened8__c!=null)      
                        calculateMaxDue(cb.Days_Past_Due8__c, cb.Account_Type8__c,cb.Date_Closed8__c,cb.Ownership8__c);
                        if(cb.Account_Type9__c != 'NO DATA' && cb.Date_Opened9__c!=null)        
                        calculateMaxDue(cb.Days_Past_Due9__c, cb.Account_Type9__c,cb.Date_Closed9__c,cb.Ownership9__c);
                        if(cb.Account_Type10__c != 'NO DATA' && cb.Date_Opened10__c!=null)          
                        calculateMaxDue(cb.Days_Past_Due10__c, cb.Account_Type10__c,cb.Date_Closed10__c,cb.Ownership10__c);
                        if(cb.Account_Type11__c != 'NO DATA' && cb.Date_Opened11__c!=null)          
                        calculateMaxDue(cb.Days_Past_Due11__c, cb.Account_Type11__c,cb.Date_Closed11__c,cb.Ownership11__c);
                        if(cb.Account_Type12__c != 'NO DATA' && cb.Date_Opened12__c!=null)          
                        calculateMaxDue(cb.Days_Past_Due12__c, cb.Account_Type12__c,cb.Date_Closed12__c,cb.Ownership12__c);
                        if(cb.Account_Type13__c != 'NO DATA' && cb.Date_Opened13__c!=null)          
                        calculateMaxDue(cb.Days_Past_Due13__c, cb.Account_Type13__c,cb.Date_Closed13__c,cb.Ownership13__c);
                        if(cb.Account_Type14__c != 'NO DATA' && cb.Date_Opened14__c!=null)          
                        calculateMaxDue(cb.Days_Past_Due14__c, cb.Account_Type14__c,cb.Date_Closed14__c,cb.Ownership14__c);
                        if(cb.Account_Type15__c != 'NO DATA' && cb.Date_Opened15__c!=null)          
                        calculateMaxDue(cb.Days_Past_Due15__c, cb.Account_Type15__c,cb.Date_Closed15__c,cb.Ownership15__c);
                        if(cb.Account_Type16__c != 'NO DATA' && cb.Date_Opened16__c!=null)          
                        calculateMaxDue(cb.Days_Past_Due16__c, cb.Account_Type16__c,cb.Date_Closed16__c,cb.Ownership16__c);
                        if(cb.Account_Type17__c != 'NO DATA' && cb.Date_Opened17__c!=null)          
                        calculateMaxDue(cb.Days_Past_Due17__c, cb.Account_Type17__c,cb.Date_Closed17__c,cb.Ownership17__c);
                        if(cb.Account_Type18__c != 'NO DATA' && cb.Date_Opened18__c!=null)          
                        calculateMaxDue(cb.Days_Past_Due18__c, cb.Account_Type18__c,cb.Date_Closed18__c,cb.Ownership18__c);
                        if(cb.Account_Type19__c != 'NO DATA' && cb.Date_Opened19__c!=null)          
                        calculateMaxDue(cb.Days_Past_Due19__c, cb.Account_Type19__c,cb.Date_Closed19__c,cb.Ownership19__c);
                        if(cb.CIBIL_Extension__r.Account_Type20__c != 'NO DATA' && cb.CIBIL_Extension__r.Date_Opened20__c!=null)        
                        calculateMaxDue(cb.CIBIL_Extension__r.Days_Past_Due20__c, cb.CIBIL_Extension__r.Account_Type20__c,cb.CIBIL_Extension__r.Date_Closed20__c,cb.CIBIL_Extension__r.Ownership20__c);
                        if(cb.CIBIL_Extension__r.Account_Type21__c!= 'NO DATA' && cb.CIBIL_Extension__r.Date_Opened21__c!=null)         
                        calculateMaxDue(cb.CIBIL_Extension__r.Days_Past_Due21__c, cb.CIBIL_Extension__r.Account_Type21__c, cb.CIBIL_Extension__r.Date_Closed21__c,cb.CIBIL_Extension__r.Ownership21__c);
                        if(cb.CIBIL_Extension__r.Account_Type22__c!= 'NO DATA' && cb.CIBIL_Extension__r.Date_Opened22__c!=null)   
                        calculateMaxDue(cb.CIBIL_Extension__r.Days_Past_Due22__c, cb.CIBIL_Extension__r.Account_Type22__c ,cb.CIBIL_Extension__r.Date_Closed22__c,cb.CIBIL_Extension__r.Ownership22__c);
                        if(cb.CIBIL_Extension__r.Account_Type23__c!= 'NO DATA' && cb.CIBIL_Extension__r.Date_Opened23__c!=null)   
                        calculateMaxDue(cb.CIBIL_Extension__r.Days_Past_Due23__c, cb.CIBIL_Extension__r.Account_Type23__c,cb.CIBIL_Extension__r.Date_Closed23__c,cb.CIBIL_Extension__r.Ownership23__c);
                        if(cb.CIBIL_Extension__r.Account_Type24__c!= 'NO DATA' && cb.CIBIL_Extension__r.Date_Opened24__c!=null)         
                        calculateMaxDue(cb.CIBIL_Extension__r.Days_Past_Due24__c, cb.CIBIL_Extension__r.Account_Type24__c,cb.CIBIL_Extension__r.Date_Closed24__c,cb.CIBIL_Extension__r.Ownership24__c);
                        if(cb.CIBIL_Extension__r.Account_Type25__c!= 'NO DATA' && cb.CIBIL_Extension__r.Date_Opened25__c!=null)   
                        calculateMaxDue(cb.CIBIL_Extension__r.Days_Past_Due25__c, cb.CIBIL_Extension__r.Account_Type25__c,cb.CIBIL_Extension__r.Date_Closed25__c,cb.CIBIL_Extension__r.Ownership25__c);
                        if(cb.CIBIL_Extension__r.Account_Type26__c!= 'NO DATA' && cb.CIBIL_Extension__r.Date_Opened26__c!=null)         
                        calculateMaxDue(cb.CIBIL_Extension__r.Days_Past_Due26__c, cb.CIBIL_Extension__r.Account_Type26__c,cb.CIBIL_Extension__r.Date_Closed26__c,cb.CIBIL_Extension__r.Ownership26__c);
                        if(cb.CIBIL_Extension__r.Account_Type27__c!= 'NO DATA' && cb.CIBIL_Extension__r.Date_Opened27__c!=null)         
                        calculateMaxDue(cb.CIBIL_Extension__r.Days_Past_Due27__c, cb.CIBIL_Extension__r.Account_Type27__c,cb.CIBIL_Extension__r.Date_Closed27__c,cb.CIBIL_Extension__r.Ownership27__c);
                        if(cb.CIBIL_Extension__r.Account_Type28__c!= 'NO DATA' && cb.CIBIL_Extension__r.Date_Opened28__c!=null)   
                        calculateMaxDue(cb.CIBIL_Extension__r.Days_Past_Due28__c, cb.CIBIL_Extension__r.Account_Type28__c,cb.CIBIL_Extension__r.Date_Closed28__c,cb.CIBIL_Extension__r.Ownership28__c);
                        if(cb.CIBIL_Extension__r.Account_Type29__c!= 'NO DATA' && cb.CIBIL_Extension__r.Date_Opened29__c!=null)         
                        calculateMaxDue(cb.CIBIL_Extension__r.Days_Past_Due29__c, cb.CIBIL_Extension__r.Account_Type29__c,cb.CIBIL_Extension__r.Date_Closed29__c,cb.CIBIL_Extension__r.Ownership29__c);*/
                        /*SAL Optimization s*/
                        if(cb.Account_Type__c != 'NO DATA' && cb.Date_Opened__c!=null)
                            calculateMaxDue(cb.Days_Past_Due__c, cb.Account_Type__c,cb.Date_Closed__c,cb.Ownership__c,cb.Amount_Overdue__c);
                        for(integer j=1;j<20;j++){
                            String accountType = 'Account_Type'+j+'__c';
                            String dateClosed = 'Date_Closed'+j+'__c';
                            String daysPast = 'Days_Past_Due'+j+'__c';
                            String ownership = 'Ownership'+j+'__c';
                            String amtOver = 'Amount_Overdue'+j+'__c';
                            String dateOpened= 'Date_Opened'+j+'__c';
                            if (cb.get(accounttype) != 'NO DATA' && cb.get(dateOpened) != null){}
                                calculateMaxDue((String)cb.get(daysPast), (String)cb.get(accountType),(Date)cb.get(dateClosed),(String)cb.get(ownership),(String)cb.get(amtOver));
                        }
                        for(integer j=20;j<30;j++){
                            String accountType = 'Account_Type'+j+'__c';
                            String dateClosed = 'Date_Closed'+j+'__c';
                            String daysPast = 'Days_Past_Due'+j+'__c';
                            String ownership = 'Ownership'+j+'__c';
                            String amtOver = 'Amount_Overdue'+j+'__c';
                            String dateOpened= 'Date_Opened'+j+'__c';
                            if (cb.CIBIL_Extension__r != null && cb.CIBIL_Extension__r.get(accounttype) != 'NO DATA' && cb.CIBIL_Extension__r.get(dateOpened) != null){}
                                calculateMaxDue((String)cb.CIBIL_Extension__r.get(daysPast), (String)cb.CIBIL_Extension__r.get(accountType),(Date)cb.CIBIL_Extension__r.get(dateClosed),(String)cb.CIBIL_Extension__r.get(ownership),(String)cb.CIBIL_Extension__r.get(amtOver));
                        }
                        /*SAL Optimization  e*/
                    }else{
                        //commenting below code for sal optimization
                        /*
                        calculateMaxDue(cb.Days_Past_Due__c, cb.Account_Type__c,cb.Date_Closed__c,cb.Ownership__c,cb.Amount_Overdue__c);
                        calculateMaxDue(cb.Days_Past_Due1__c, cb.Account_Type1__c,cb.Date_Closed1__c,cb.Ownership1__c);
                        calculateMaxDue(cb.Days_Past_Due2__c, cb.Account_Type2__c,cb.Date_Closed2__c,cb.Ownership2__c);
                        calculateMaxDue(cb.Days_Past_Due3__c, cb.Account_Type3__c,cb.Date_Closed3__c,cb.Ownership3__c);
                        calculateMaxDue(cb.Days_Past_Due4__c, cb.Account_Type4__c,cb.Date_Closed4__c,cb.Ownership4__c);
                        calculateMaxDue(cb.Days_Past_Due5__c, cb.Account_Type5__c,cb.Date_Closed5__c,cb.Ownership5__c);
                        calculateMaxDue(cb.Days_Past_Due6__c, cb.Account_Type6__c,cb.Date_Closed6__c,cb.Ownership6__c);
                        calculateMaxDue(cb.Days_Past_Due7__c, cb.Account_Type7__c,cb.Date_Closed7__c,cb.Ownership7__c);
                        calculateMaxDue(cb.Days_Past_Due8__c, cb.Account_Type8__c,cb.Date_Closed8__c,cb.Ownership8__c);
                        calculateMaxDue(cb.Days_Past_Due9__c, cb.Account_Type9__c,cb.Date_Closed9__c,cb.Ownership9__c);
                        calculateMaxDue(cb.Days_Past_Due10__c, cb.Account_Type10__c,cb.Date_Closed10__c,cb.Ownership10__c);
                        calculateMaxDue(cb.Days_Past_Due11__c, cb.Account_Type11__c,cb.Date_Closed11__c,cb.Ownership11__c);
                        calculateMaxDue(cb.Days_Past_Due12__c, cb.Account_Type12__c,cb.Date_Closed12__c,cb.Ownership12__c);
                        calculateMaxDue(cb.Days_Past_Due13__c, cb.Account_Type13__c,cb.Date_Closed13__c,cb.Ownership13__c);
                        calculateMaxDue(cb.Days_Past_Due14__c, cb.Account_Type14__c,cb.Date_Closed14__c,cb.Ownership14__c);
                        calculateMaxDue(cb.Days_Past_Due15__c, cb.Account_Type15__c,cb.Date_Closed15__c,cb.Ownership15__c);
                        calculateMaxDue(cb.Days_Past_Due16__c, cb.Account_Type16__c,cb.Date_Closed16__c,cb.Ownership16__c);
                        calculateMaxDue(cb.Days_Past_Due17__c, cb.Account_Type17__c,cb.Date_Closed17__c,cb.Ownership17__c);
                        calculateMaxDue(cb.Days_Past_Due18__c, cb.Account_Type18__c,cb.Date_Closed18__c,cb.Ownership18__c);
                        calculateMaxDue(cb.Days_Past_Due19__c, cb.Account_Type19__c,cb.Date_Closed19__c,cb.Ownership19__c);
                        calculateMaxDue(cb.CIBIL_Extension__r.Days_Past_Due20__c, cb.CIBIL_Extension__r.Account_Type20__c,cb.CIBIL_Extension__r.Date_Closed20__c,cb.CIBIL_Extension__r.Ownership20__c);
                        calculateMaxDue(cb.CIBIL_Extension__r.Days_Past_Due21__c, cb.CIBIL_Extension__r.Account_Type21__c,cb.CIBIL_Extension__r.Date_Closed21__c,cb.CIBIL_Extension__r.Ownership21__c);
                        calculateMaxDue(cb.CIBIL_Extension__r.Days_Past_Due22__c, cb.CIBIL_Extension__r.Account_Type22__c,cb.CIBIL_Extension__r.Date_Closed22__c,cb.CIBIL_Extension__r.Ownership22__c);
                        calculateMaxDue(cb.CIBIL_Extension__r.Days_Past_Due23__c, cb.CIBIL_Extension__r.Account_Type23__c,cb.CIBIL_Extension__r.Date_Closed23__c,cb.CIBIL_Extension__r.Ownership23__c);
                        calculateMaxDue(cb.CIBIL_Extension__r.Days_Past_Due24__c, cb.CIBIL_Extension__r.Account_Type24__c,cb.CIBIL_Extension__r.Date_Closed24__c,cb.CIBIL_Extension__r.Ownership24__c);
                        calculateMaxDue(cb.CIBIL_Extension__r.Days_Past_Due25__c, cb.CIBIL_Extension__r.Account_Type25__c,cb.CIBIL_Extension__r.Date_Closed25__c,cb.CIBIL_Extension__r.Ownership25__c);
                        calculateMaxDue(cb.CIBIL_Extension__r.Days_Past_Due26__c, cb.CIBIL_Extension__r.Account_Type26__c,cb.CIBIL_Extension__r.Date_Closed26__c,cb.CIBIL_Extension__r.Ownership26__c);
                        calculateMaxDue(cb.CIBIL_Extension__r.Days_Past_Due27__c, cb.CIBIL_Extension__r.Account_Type27__c,cb.CIBIL_Extension__r.Date_Closed27__c,cb.CIBIL_Extension__r.Ownership27__c);
                        calculateMaxDue(cb.CIBIL_Extension__r.Days_Past_Due28__c, cb.CIBIL_Extension__r.Account_Type28__c,cb.CIBIL_Extension__r.Date_Closed28__c,cb.CIBIL_Extension__r.Ownership28__c);
                        calculateMaxDue(cb.CIBIL_Extension__r.Days_Past_Due29__c, cb.CIBIL_Extension__r.Account_Type29__c,cb.CIBIL_Extension__r.Date_Closed29__c,cb.CIBIL_Extension__r.Ownership29__c);
                        */
                        /*SAL Optimization s*/
                        //calculateMaxDue(cb.Days_Past_Due__c, cb.Account_Type__c,cb.Date_Closed__c,cb.Ownership__c);
                        for(integer j=1;j<20;j++){
                            String accountType = 'Account_Type'+j+'__c';
                            String dateClosed = 'Date_Closed'+j+'__c';
                            String daysPast = 'Days_Past_Due'+j+'__c';
                            String ownership = 'Ownership'+j+'__c';
                            String amtOver = 'Amount_Overdue'+j+'__c';
                            calculateMaxDue((String)cb.get(daysPast), (String)cb.get(accountType),(Date)cb.get(dateClosed),(String)cb.get(ownership),(String)cb.get(amtOver));
                        }
                        for(integer j=20;j<30;j++){
                            String accountType = 'Account_Type'+j+'__c';
                            String dateClosed = 'Date_Closed'+j+'__c';
                            String daysPast = 'Days_Past_Due'+j+'__c';
                            String ownership = 'Ownership'+j+'__c';
                            String amtOver = 'Amount_Overdue'+j+'__c';
                            //Below added by Rohan, as the amount field was wrongly getting passed from Cibil instead of Cibil Extension.
                            //calculateMaxDue((String)cb.CIBIL_Extension__r.get(daysPast), (String)cb.CIBIL_Extension__r.get(accountType),(Date)cb.CIBIL_Extension__r.get(dateClosed),(String)cb.CIBIL_Extension__r.get(ownership),(String)cb.get(amtOver));
                            calculateMaxDue((String)cb.CIBIL_Extension__r.get(daysPast), (String)cb.CIBIL_Extension__r.get(accountType),(Date)cb.CIBIL_Extension__r.get(dateClosed),(String)cb.CIBIL_Extension__r.get(ownership),(String)cb.CIBIL_Extension__r.get(amtOver));

                        }
                        /*SAL Optimization e*/
                    }
                    checkLastThreeMothEnquiries(cb.Enquiry_Purpose__c, cb.Date_of_Enquiry__c, cb.Account_Type__c);
                    checkLastThreeMothEnquiries(cb.Enquiry_Purpose1__c, cb.Date_of_Enquiry1__c, cb.Account_Type1__c);
                    checkLastThreeMothEnquiries(cb.Enquiry_Purpose2__c, cb.Date_of_Enquiry2__c, cb.Account_Type2__c);
                    checkLastThreeMothEnquiries(cb.Enquiry_Purpose3__c, cb.Date_of_Enquiry3__c, cb.Account_Type3__c);
                    checkLastThreeMothEnquiries(cb.Enquiry_Purpose4__c, cb.Date_of_Enquiry4__c, cb.Account_Type4__c);
                    checkLastThreeMothEnquiries(cb.Enquiry_Purpose5__c, cb.Date_of_Enquiry5__c, cb.Account_Type5__c);
                    checkLastThreeMothEnquiries(cb.Enquiry_Purpose6__c, cb.Date_of_Enquiry6__c, cb.Account_Type6__c);
                    checkLastThreeMothEnquiries(cb.Enquiry_Purpose7__c, cb.Date_of_Enquiry7__c, cb.Account_Type7__c);
                    checkLastThreeMothEnquiries(cb.Enquiry_Purpose8__c, cb.Date_of_Enquiry8__c, cb.Account_Type8__c);
                    checkLastThreeMothEnquiries(cb.Enquiry_Purpose9__c, cb.Date_of_Enquiry9__c, cb.Account_Type9__c);
                    checkLastThreeMothEnquiries(cb.Enquiry_Purpose10__c, cb.Date_of_Enquiry10__c, cb.Account_Type10__c);
                    checkLastThreeMothEnquiries(cb.Enquiry_Purpose11__c, cb.Date_of_Enquiry11__c, cb.Account_Type11__c);
                    checkLastThreeMothEnquiries(cb.Enquiry_Purpose12__c, cb.Date_of_Enquiry12__c, cb.Account_Type12__c);
                    checkLastThreeMothEnquiries(cb.Enquiry_Purpose13__c, cb.Date_of_Enquiry13__c, cb.Account_Type13__c);
                    checkLastThreeMothEnquiries(cb.Enquiry_Purpose14__c, cb.Date_of_Enquiry14__c, cb.Account_Type14__c);
                    checkLastThreeMothEnquiries(cb.Enquiry_Purpose15__c, cb.Date_of_Enquiry15__c, cb.Account_Type15__c);
                    checkLastThreeMothEnquiries(cb.Enquiry_Purpose16__c, cb.Date_of_Enquiry16__c, cb.Account_Type16__c);
                    checkLastThreeMothEnquiries(cb.Enquiry_Purpose17__c, cb.Date_of_Enquiry17__c, cb.Account_Type17__c);
                    checkLastThreeMothEnquiries(cb.Enquiry_Purpose18__c, cb.Date_of_Enquiry18__c, cb.Account_Type18__c);
                    checkLastThreeMothEnquiries(cb.Enquiry_Purpose19__c, cb.Date_of_Enquiry19__c, cb.Account_Type19__c);
                    checkLastThreeMothEnquiries(cb.CIBIL_Extension__r.Enquiry_Purpose20__c, cb.CIBIL_Extension__r.Date_of_Enquiry20__c, cb.CIBIL_Extension__r.Account_Type20__c);
                    checkLastThreeMothEnquiries(cb.CIBIL_Extension__r.Enquiry_Purpose21__c, cb.CIBIL_Extension__r.Date_of_Enquiry21__c, cb.CIBIL_Extension__r.Account_Type21__c);
                    checkLastThreeMothEnquiries(cb.CIBIL_Extension__r.Enquiry_Purpose22__c, cb.CIBIL_Extension__r.Date_of_Enquiry22__c, cb.CIBIL_Extension__r.Account_Type22__c);
                    checkLastThreeMothEnquiries(cb.CIBIL_Extension__r.Enquiry_Purpose23__c, cb.CIBIL_Extension__r.Date_of_Enquiry23__c, cb.CIBIL_Extension__r.Account_Type23__c);
                    checkLastThreeMothEnquiries(cb.CIBIL_Extension__r.Enquiry_Purpose24__c, cb.CIBIL_Extension__r.Date_of_Enquiry24__c, cb.CIBIL_Extension__r.Account_Type24__c);
                    checkLastThreeMothEnquiries(cb.CIBIL_Extension__r.Enquiry_Purpose25__c, cb.CIBIL_Extension__r.Date_of_Enquiry25__c, cb.CIBIL_Extension__r.Account_Type25__c);
                    checkLastThreeMothEnquiries(cb.CIBIL_Extension__r.Enquiry_Purpose26__c, cb.CIBIL_Extension__r.Date_of_Enquiry26__c, cb.CIBIL_Extension__r.Account_Type26__c);
                    checkLastThreeMothEnquiries(cb.CIBIL_Extension__r.Enquiry_Purpose27__c, cb.CIBIL_Extension__r.Date_of_Enquiry27__c, cb.CIBIL_Extension__r.Account_Type27__c);
                    checkLastThreeMothEnquiries(cb.CIBIL_Extension__r.Enquiry_Purpose28__c, cb.CIBIL_Extension__r.Date_of_Enquiry28__c, cb.CIBIL_Extension__r.Account_Type28__c);
                    checkLastThreeMothEnquiries(cb.CIBIL_Extension__r.Enquiry_Purpose29__c, cb.CIBIL_Extension__r.Date_of_Enquiry29__c, cb.CIBIL_Extension__r.Account_Type29__c);

                    securedTradeLines(cb);
                    System.debug('gopiak before update');
                    if (cb.Cibil_Extension1__c != null) {
                        Cibil_Extension1__c cex = new Cibil_Extension1__c(id = cb.Cibil_Extension1__c); 
                        cex.First_Loan_MOB__c = firstLoan;
                        cex.Latest_Loan_MOB__c = latestLoan;
                        cex.Total_Amount_overdue__c = getSumOfAmountOverdue(cb);
                        /* POS_PO-16621  starts*/
                        cex.Written_Off_and_settled_status__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status__c;
                        cex.Written_Off_and_settled_status1__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status1__c;
                        cex.Written_Off_and_settled_status2__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status2__c;
                        cex.Written_Off_and_settled_status3__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status3__c;
                        cex.Written_Off_and_settled_status4__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status4__c;
                        cex.Written_Off_and_settled_status5__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status5__c;
                        cex.Written_Off_and_settled_status6__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status6__c;
                        cex.Written_Off_and_settled_status7__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status7__c;
                        cex.Written_Off_and_settled_status8__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status8__c;
                        cex.Written_Off_and_settled_status9__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status9__c;
                        cex.Written_Off_and_settled_status10__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status10__c;
                        cex.Written_Off_and_settled_status11__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status11__c;
                        cex.Written_Off_and_settled_status12__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status12__c;
                        cex.Written_Off_and_settled_status13__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status13__c;
                        cex.Written_Off_and_settled_status14__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status14__c;
                        cex.Written_Off_and_settled_status15__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status15__c;
                        cex.Written_Off_and_settled_status16__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status16__c;
                        cex.Written_Off_and_settled_status17__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status17__c;
                        cex.Written_Off_and_settled_status18__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status18__c;
                        cex.Written_Off_and_settled_status19__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status19__c;
                        cex.Written_Off_and_settled_status20__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status20__c;
                        cex.Written_Off_and_settled_status21__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status21__c;
                        cex.Written_Off_and_settled_status22__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status22__c;
                        cex.Written_Off_and_settled_status23__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status23__c;
                        cex.Written_Off_and_settled_status24__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status24__c;
                        cex.Written_Off_and_settled_status25__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status25__c;
                        cex.Written_Off_and_settled_status26__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status26__c;
                        cex.Written_Off_and_settled_status27__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status27__c;
                        cex.Written_Off_and_settled_status28__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status28__c;
                        cex.Written_Off_and_settled_status29__c = cb.Cibil_Extension1__r.Written_Off_and_settled_status29__c;
                        /* POS_PO-16621  ends*/
                        totalTL = getNumberTradeLines(cb);
                         system.debug('cex****'+cex);                
                        /* POS_PO-16621  starts*/
                        //POS_disbursal__rule7
                        List<String> Written_settled_List = new List <String>();
                     //   Written_settled_List[0] = cex.Written_Off_and_settled_status__c;
                        Written_settled_List.add(cex.Written_Off_and_settled_status__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status1__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status2__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status3__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status4__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status5__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status6__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status7__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status8__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status9__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status10__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status11__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status12__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status13__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status14__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status15__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status16__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status17__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status18__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status19__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status20__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status21__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status22__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status23__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status24__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status25__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status26__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status27__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status28__c);
                        Written_settled_List.add(cex.Written_Off_and_settled_status29__c);
                        cex.No_Tdl_WO_Settled_Except_CC__c = getSettledTDL(cb,Written_settled_List);
                        /* POS_PO-16621  ends*/
                        cex.Total_No_of_Trades__c = totalTL;
                        /* POS_PO-16621  starts*/
                        //POS_disbursal-counters
                        cex.No_of_TD_with_30_DPD_6_months__c = X30DPD6Months_POS;
                        cex.No_of_TD_with_30_DPD_12_months__c =  X30DPD12Months; 
                         /* Start added parameter by Mahima for Bug-17588*/
                         cex.No_30_DPD_12_Exld_CC_GL__c =  X30DPD12MonthsWithoutCCGL;
                        /* End added parameter by Mahima for Bug-17588*/                        
                        cex.No_of_TD_with_Less_Than_30_DPD_3_months__c = X30LessDPD3Months ;
                        cex.No_Tdl_with_DPD_String__c = TDWithSubstrCount ; 
                        Map <String, Integer> UnsecuredLoanCountMap = getUnsecuredLoanCount(cb); // Added Map for count of unsecured Loan                 
                        cex.Unsecured_Tradelines_in_last_12m__c = UnsecuredLoanCountMap.get('UnsecuredLoanCnt12Mon');
                        cex.No_Unsecured_Avail_6_Month__c = UnsecuredLoanCountMap.get('UnsecuredLoanCnt6Mon');
                        //POS_disbursal-counters-ends
                        /* POS_PO-16621  ends*/
                        System.debug('inside test ');
                        cex.No_Of_Live_Trades__c = getLiveTradeCount(cb);
                        /*POS_PO-16621 starts */
                        system.debug('Gulshan cex final noOfLivePL_BL_Cib_ext1'+noOfLivePL_BL_Cib_ext1);
                        cex.No_Tdl_Bajaj_PL_BL_Live__c = noOfLivePL_BL_Cib_ext1;
                        /*POS_PO-16621 ends */
                        cex.Credit_Card_utilization__c = getCreditCardUtilization(cb);
                        system.debug('&&&creditcardNumber : '+creditcardNumber);
                        if(creditcardNumber == false)
                        cex.Credit_Card_utilization__c=null; 
                        system.debug('&Credit_Card_utilization__c : '+cex.Credit_Card_utilization__c);    
                        system.debug('&&&&unsecuredTLCnt befor calling:: '+unsecuredTLCnt);
                       // unsecuredTL = getUnsecuredLoanCount(cb);
                        cex.Unsecured_Tradelines_in_last_12m__c = unsecuredTL;
                        cex.Unsecured_loan_balance__c = unsecuredCurrentBalance;
                        system.debug('**SegmentProduct*'+SegmentProduct+'**product'+product);
                        if(product!=null && SegmentProduct!=null && SegmentProduct.ToUpperCase().contains(product.ToUppercase())){
                            cex.Total_Sanction_Amnt_unsecured__c = totalClosedUnsecuredSanctionAmount + totalLiveUnsecuredSanctionAmount;
                        }else{
                            cex.Total_Sanction_Amnt_unsecured__c = totalUnsecuredSanctionAmount;
                        }
                        cex.Current_Obligation_All__c = totalBalance;
                        cex.Ever_Write_off__c = CIBILSegmentationHandler.getEverWrittenOff(cb);
                        /* POS_PO-16621 starts  */
                        //POS_disbursal _ rule 3
                        cex.No_Tdl_WO_Overdue_24_Month_Except_CC__c = CIBILSegmentationHandler.TDLOverdue24Month(cb);
                        /* POS_PO-16621 ends  */
                        cex.Max_Lifetime_Delq__c = maxDelinquencyCnt; //maxDue;
                        cex.Tradelines_30plus_DPD__c = delinquentTradecnt;
                        cex.Secured_Tradelines_90plus_DPD__c = delinquentSecuredTradelines;
                        cex.Enquiries_past_3_mnths__c = enquiry;
                        /*POS_PO-16621 starts */
                        //POS_disbursal-rule-5
                        cex.Unsecured_Enquiries_past_3_mnths__c = unsecuredEnquiry;
                        /*POS_PO-16621 ends */
                        /**------**/
                        if(totalBalance!=null && totalTL !=0) 
                        cex.Average_Total_Balance__c = totalBalance.divide(totalTL, 2);
                        
                        System.debug('securedCurrentBalance : '+ securedCurrentBalance);
                        system.debug(totalLiveUnsecuredSanctionAmount + '-- totalLiveUnsecuredSanctionAmount -- totalClosedUnsecuredSanctionAmount ' + totalClosedUnsecuredSanctionAmount);
                        system.debug(unsecuredTLCnt + '-- unsecuredTLCnt - totalUnsecuredSanctionAmount ' + totalUnsecuredSanctionAmount);
                        system.debug('totalSanctionAmount ' + totalSanctionAmount);
                        system.debug('unsecuredCurrentBalance ' + unsecuredCurrentBalance);
                        system.debug(unsecuredTLCnt+ '-- unsecuredTLCnt-- totalTL::' + totalTL);
                        if (totalTL != 0 && unsecuredTLCnt != null) cex.Unsecured_to_total_ratio__c = decimal.valueOf(unsecuredTLCnt).divide(totalTL, 2);
                        if (unsecuredTLCnt != 0) cex.Avg_unsecured_loan_amount__c = (totalClosedUnsecuredSanctionAmount + totalLiveUnsecuredSanctionAmount) / unsecuredTLCnt;
                        if (totalSanctionAmount != 0) cex.Unsecured_to_total_amount__c = ((totalClosedUnsecuredSanctionAmount + totalLiveUnsecuredSanctionAmount) / totalSanctionAmount) * 100;
                        if ((totalClosedUnsecuredSanctionAmount + totalLiveUnsecuredSanctionAmount) > 0) cex.OSB_to_loan_amount_unsecured__c = (unsecuredCurrentBalance / (totalClosedUnsecuredSanctionAmount + totalLiveUnsecuredSanctionAmount)) * 100;
                        if ((totalClosedUnsecuredSanctionAmount + totalLiveUnsecuredSanctionAmount) > 0) cex.Secured_to_unsecured_ratio__c = (totalSecuredSanctionAmount / (totalClosedUnsecuredSanctionAmount + totalLiveUnsecuredSanctionAmount)) * 100;
                        system.debug('totalSecuredSanctionAmount' + totalSecuredSanctionAmount);
                        cex.Total_Sanction_Amnt_secured__c = totalSecuredSanctionAmount;
                        cex.Current_Obligation_Secured__c = securedCurrentBalance;
                        cex.Current_Obligation_unsecured__c = unsecuredCurrentBalance;
                        cex.Current_Bal_on_all_cards__c = balAmount;
                        
                        /************   DL Changes  ***********/
                        cex.Total_no_of_secured_loans__c = securedTradeLines(cb);
                        cex.Highest_DPD_In_1_Year__c = maxdue;
                        if (delinquentTradecnt > 0) cex.X30_DPD_12_months__c = 'Yes';
                        else cex.X30_DPD_12_months__c = 'No';
                        if (X30DPD3Months > 0) cex.X30_DPD_3_months__c = 'Yes';
                        else cex.X30_DPD_3_months__c = 'No';
                        // OTP V3 Cibil S
                        System.debug('X6monthsDPD*****'+X30DPD6Months);
                        if (X30DPD6Months > 0) cex.X30_DPD_6_months__c = 'Yes';
                        else cex.X30_DPD_6_months__c = 'No';
                        cex.Maximum_DPD_ever__c = maxDueEver;
                        // OTP V3 Cibil E
                        /*************************************/
                         /*Bug 17138 s*/
                        system.debug('X30DPDCC '+X90DPD6Months );
                        if (XDPDCC > 0) cb.Cibil_Extension__r.DPD_CC__c = 'Yes';
                        else cb.Cibil_Extension__r.DPD_CC__c = 'No';
                        if (X30DPDCC > 0) cb.Cibil_Extension__r.X30_DPD_CC__c = 'Yes';
                        else cb.Cibil_Extension__r.X30_DPD_CC__c = 'No';
                        if (X30DPDGL > 0) cb.Cibil_Extension__r.X30_DPD_Gold_Loan__c = 'Yes';
                        else cb.Cibil_Extension__r.X30_DPD_Gold_Loan__c = 'No';
                        if(assetView > 0) cb.Cibil_Extension__r.Asset_classification_view__c = 'Yes';
                        else cb.Cibil_Extension__r.Asset_classification_view__c = 'No';
                        if (X90DPD6Months > 0) cb.Cibil_Extension__r.X90_DPD_6_months__c = 'Yes';
                        else cb.Cibil_Extension__r.X90_DPD_6_months__c = 'No';
                        cb.Cibil_Extension__r.No_of_PL_Enq_in_Last_3_Months__c = noOfPLEnquiriesIn3M;
  /*Added by sneha for Bug-20187 start*/
                        CIBIL__C objTmpCbl = CIBILSegmentationHandler.fetchCibil(cb.ID); 
                        cb.Cibil_Extension__r.Number_of_live_AL__c = CIBILSegmentationHandler.NoOfLiveLoan(objTmpCbl,'AL');
                        system.debug('cb.Cibil_Extension__r.Number_of_live_AL__c---->'+cb.Cibil_Extension__r.Number_of_live_AL__c);
                        cb.Cibil_Extension__r.Number_of_live_HL__c = CIBILSegmentationHandler.NoOfLiveLoan(objTmpCbl,'HL');
                        system.debug('cb.Cibil_Extension__r.Number_of_live_HL__c---->'+cb.Cibil_Extension__r.Number_of_live_HL__c);
                        cb.Cibil_Extension__r.Number_of_live_LAP__c = CIBILSegmentationHandler.NoOfLiveLoan(objTmpCbl,'LAP');
                        system.debug('cb.Cibil_Extension__r.Number_of_live_LAP__c---->'+cb.Cibil_Extension__r.Number_of_live_LAP__c);
                        // System.Debug('Cibil Temp Object ' + cb.Cibil_Temp__C + ' Relations field values ' + cb.Cibil_Temp__r.ID + ' Product of Cibil Temp ' + cb.cibil_Temp__r.Product__C);
                        cb.Cibil_Extension__r.Sanction_amount_of_live_loans_of_AL__c = CIBILSegmentationHandler.calSanctionAmount(objTmpCbl,'AL',6,false);
                        system.debug('cb.Cibil_Extension__r.Sanction_amount_of_live_loans_of_AL__c---->'+cb.Cibil_Extension__r.Sanction_amount_of_live_loans_of_AL__c);
                         cb.Cibil_Extension__r.Sanction_amount_of_live_loans_of_BL__c = CIBILSegmentationHandler.calSanctionAmount(objTmpCbl,'BL',6,false);
                        system.debug('cb.Cibil_Extension__r.Sanction_amount_of_live_loans_of_BL__c---->'+cb.Cibil_Extension__r.Sanction_amount_of_live_loans_of_BL__c);
                         cb.Cibil_Extension__r.Sanction_amount_of_live_loans_of_PL__c = CIBILSegmentationHandler.calSanctionAmount(objTmpCbl,'PL',6,false);
                        system.debug('cb.Cibil_Extension__r.Sanction_amount_of_live_loans_of_PL__c---->'+cb.Cibil_Extension__r.Sanction_amount_of_live_loans_of_PL__c);
                         cb.Cibil_Extension__r.Sanction_amount_of_live_loans_of_HL__c = CIBILSegmentationHandler.calSanctionAmount(objTmpCbl,'HL',12,false);
                        system.debug('cb.Cibil_Extension__r.Sanction_amount_of_live_loans_of_HL__c---->'+cb.Cibil_Extension__r.Sanction_amount_of_live_loans_of_HL__c);
                         cb.Cibil_Extension__r.Sanction_amount_of_live_loans_of_LAP__c = CIBILSegmentationHandler.calSanctionAmount(objTmpCbl,'LAP',12,false);
                        system.debug('cb.Cibil_Extension__r.Sanction_amount_of_live_loans_of_LAP__c---->'+cb.Cibil_Extension__r.Sanction_amount_of_live_loans_of_LAP__c);
                        /*Added by sneha for Bug-20187 end*/
                        
                        /*Added by rajendra Bug-23565 start*/
                        cb.Cibil_Extension__r.Sum_of_sanction_amount_of_live_AL_loans__c = CIBILSegmentationHandler.calSanctionAmount(objTmpCbl,'AL',0,true);
                        system.debug('cb.Cibil_Extension__r.Sum_of_sanction_amount_of_live_AL_loans__c---->'+cb.Cibil_Extension__r.Sum_of_sanction_amount_of_live_AL_loans__c);
                         cb.Cibil_Extension__r.Sum_of_sanction_amount_of_live_BL_loans__c = CIBILSegmentationHandler.calSanctionAmount(objTmpCbl,'BL',0,true);
                        system.debug('cb.Cibil_Extension__r.Sum_of_sanction_amount_of_live_BL_loans__c---->'+cb.Cibil_Extension__r.Sum_of_sanction_amount_of_live_BL_loans__c);
                         cb.Cibil_Extension__r.Sum_of_sanction_amount_of_live_PL_loans__c = CIBILSegmentationHandler.calSanctionAmount(objTmpCbl,'PL',0,true);
                        system.debug('cb.Cibil_Extension__r.Sum_of_sanction_amount_of_live_PL_loans__c---->'+cb.Cibil_Extension__r.Sum_of_sanction_amount_of_live_PL_loans__c);
                         cb.Cibil_Extension__r.Sum_of_sanction_amount_live_HL_loans__c = CIBILSegmentationHandler.calSanctionAmount(objTmpCbl,'HL',0,true);
                        system.debug('cb.Cibil_Extension__r.Sum_of_sanction_amount_live_HL_loans__c---->'+cb.Cibil_Extension__r.Sum_of_sanction_amount_live_HL_loans__c);
                         cb.Cibil_Extension__r.Sum_of_sanction_amount_live_LAP_loans__c = CIBILSegmentationHandler.calSanctionAmount(objTmpCbl,'LAP',0,true);
                        system.debug('cb.Cibil_Extension__r.Sum_of_sanction_amount_live_LAP_loans__c---->'+cb.Cibil_Extension__r.Sum_of_sanction_amount_live_LAP_loans__c);
                        /*Added by rajendra for Bug-23565 end*/
                        
cb.Cibil_Extension__r.Number_DPDs_in_last_24__c = noOfDPD24Months;// Bug Id : 20187
                        System.debug('cb.Cibil_Extension__r.Number_DPDs_in_last_24__c --> ' + cb.Cibil_Extension__r.Number_DPDs_in_last_24__c);
                        cb.Cibil_Extension__r.Number_DPD_in_CC_gtr_24_month__c = CIBILSegmentationHandler.DPDOverdueForMoreThan24MonthsInCC(objTmpCbl);// Bug Id : 20187
                        System.debug('cb.Cibil_Extension__r.Number_DPD_in_CC_gtr_24_month__c --> ' + cb.Cibil_Extension__r.Number_DPD_in_CC_gtr_24_month__c);
                        cb.Cibil_Extension__r.Max_MOB_of_live_loans__c = CIBILSegmentationHandler.calMaxMob(objTmpCbl); // Bug Id : 20187
                        system.debug('Max_MOB_of_live_loans__c--->'+cb.Cibil_Extension__r.Max_MOB_of_live_loans__c);
                        
                        
                        
                     //Added By Gulshan for count of No. of Live or Closed (PL or BL or HL or LAP or AL or CC or OTHERS) -- Bug 20245   
                        cb.Cibil_Extension__r.Total_No_of_Specific_Trades__c = getSpecificLoanTradeLines(cb);
                     //Ended By Gulshan for count of No. of Live or Closed (PL or BL or HL or LAP or AL or CC or OTHERS) -- Bug 20245 
                     
                        
                         update cb.Cibil_Extension__r;
                        /*Bug 17138 e*/
                        //SAL Policy Change Start
                        cex.No_of_PL_Enq_in_Last_12_Months__c = noOfPLEnquiriesIn12M;
                        cex.No_of_PL_Enq_in_Last_6_Months__c = noOfPLEnquiriesIn6M;
                        cex.Sum_of_Amount_Overdue__c = sumOfAmountOverdue;
                        //SAL Policy Change End
                        //OTP V3 Cibil S
                        cex.No_of_Enquires_in_12M__c = noOfEnquiriesIn12M;
                        //OTP V3 Cibil E
                        
                        //SAL Policy Rule Changes :: Added by Pritha :: start
                        cex.No_of_Live_PL__c = noOfLivePL_Cib_ext1;
                        //SAL Policy Rule Changes :: Added by Pritha :: end
                        
                        
                        cexlistToBeUpdated.add(cex);
                        system.debug('CEX1 :' + cex);
                    }
                }
            } catch (Exception e) {
                System.debug('Exception occured at line no. '+ e.getLineNumber() + ' Error Message : '+ e.getMessage());
            }

        }
        if (cexlistToBeUpdated != null && cexlistToBeUpdated.size() > 0) update cexlistToBeUpdated;

        //Create Existing Loan Details record only when Cibil is inserted 
        if (Trigger.isInsert) {     
            
            /*ID applicantid = cibillist[0].applicant__c;
                system.debug('applicantid' + applicantid);
                lblCiblquery = label.CibilQuery;
                if (lblCiblquery == 'True') {
                    applicant = [select Loan_Application__c,Loan_Application__r.Product__c, (Select Id From CIBILs__r) From Applicant__c where id = : applicantid];
                } else {
                    applicant = [select Loan_Application__c,Loan_Application__r.Product__c From Applicant__c where id = : applicantid];
                }
                System.debug('applicantsize' + applicant.size());

            list<Lead> L = new List<Lead>();
            L = [select id,(Select products__c,id from Product_Offerings__r) from Lead where id=:cibillist[0].Lead__c];
            
                if (applicant.size() > 0) {
                    if (lblCiblquery == 'True') {
                        cibillistfapp = applicant[0].CIBILs__r;
                        System.debug('cibillistforapplicant' + cibillistfapp.size());
                    }
                    product = applicant[0].Loan_Application__r.Product__c;
            
            if(applicant[0].Loan_Application__c==null && cibillist[0].Lead__c!=null)
            {
                for(Product_Offerings__c PO : L[0].Product_Offerings__r)
                {
                if(PO.products__c=='PRO')
                    isPro=true;
                }
                
            }
                    
                    system.debug('Product is' + product);
                    system.debug('isPro is' + isPro);
                }
                // start code to get ELD 
                System.debug('I got  ELD' + cid);
                Map < String, Schema.SObjectField > M1 = Schema.SObjectType.CIBIL__c.fields.getMap();
                String SOQL1 = 'Select ';
                for (String fieldName: M1.keySet()) {
                    if (!fieldName.contains('enquiry_purpose') && !fieldName.contains('date_reported') && !fieldName.contains('account_info') && !fieldName.contains('Address') && !fieldName.contains('days_past_due') && !fieldName.contains('Date_of_Enquiry') && !fieldName.contains('date_last_payment') && !fieldName.contains('Date_Closed') && !fieldName.contains('date_of_enquiry') && !fieldName.contains('higher_loan_qualify') && !fieldName.contains('qualify_grade') && !fieldName.contains('amount_overdue') && !fieldName.contains('suit_filed_status') && !fieldName.contains('qualifying_loan_type') && !fieldName.contains('Start_End_Dates') && !fieldName.contains('Ownership') && !fieldName.contains('member_name') && !fieldName.contains('Member') && !fieldName.contains('Higher_Loan_Qualify') && !fieldName.contains('Enquiry_Purpose') && !fieldName.contains('enquiry_amount') && !fieldName.contains('amount_overdue') && !fieldName.contains('address_line3_of_c')) {
                        SOQL1 += fieldName + ',';
                    }
                }
        SOQL1 = SOQL1.substring(0, SOQL1.length() - 1);
        SOQL1 += ',Applicant__r.Loan_Application__c,Applicant__r.Contact_Name__r.ApplicantType__c,Applicant__r.Loan_Application__r.Product__c,';
        SOQL1 += 'CIBIL_Extension__r.Amount_Overdue20__c,CIBIL_Extension__r.Amount_Overdue21__c,CIBIL_Extension__r.Amount_Overdue22__c,CIBIL_Extension__r.Amount_Overdue23__c,CIBIL_Extension__r.Amount_Overdue24__c,CIBIL_Extension__r.Amount_Overdue25__c,CIBIL_Extension__r.Amount_Overdue26__c,CIBIL_Extension__r.Amount_Overdue27__c,CIBIL_Extension__r.Amount_Overdue28__c,CIBIL_Extension__r.Amount_Overdue29__c,';
        SOQL1 += 'CIBIL_Extension__r.Sanction_Amount20__c,CIBIL_Extension__r.Sanction_Amount21__c,CIBIL_Extension__r.Sanction_Amount22__c,CIBIL_Extension__r.Sanction_Amount23__c,CIBIL_Extension__r.Sanction_Amount24__c,CIBIL_Extension__r.Sanction_Amount25__c,CIBIL_Extension__r.Sanction_Amount26__c,CIBIL_Extension__r.Sanction_Amount27__c,CIBIL_Extension__r.Sanction_Amount28__c,CIBIL_Extension__r.Sanction_Amount29__c,';
        SOQL1 += 'CIBIL_Extension__r.Suit_Filed_Status20__c,CIBIL_Extension__r.Suit_Filed_Status21__c,CIBIL_Extension__r.Suit_Filed_Status22__c,CIBIL_Extension__r.Suit_Filed_Status23__c,CIBIL_Extension__r.Suit_Filed_Status24__c,CIBIL_Extension__r.Suit_Filed_Status25__c,CIBIL_Extension__r.Suit_Filed_Status26__c,CIBIL_Extension__r.Suit_Filed_Status27__c,CIBIL_Extension__r.Suit_Filed_Status28__c,CIBIL_Extension__r.Suit_Filed_Status29__c,';
        SOQL1 += 'CIBIL_Extension__r.Current_Balance20__c,CIBIL_Extension__r.Current_Balance21__c,CIBIL_Extension__r.Current_Balance22__c,CIBIL_Extension__r.Current_Balance23__c,CIBIL_Extension__r.Current_Balance24__c,CIBIL_Extension__r.Current_Balance25__c,CIBIL_Extension__r.Current_Balance26__c,CIBIL_Extension__r.Current_Balance27__c,CIBIL_Extension__r.Current_Balance28__c,CIBIL_Extension__r.Current_Balance29__c,';
        SOQL1 += 'CIBIL_Extension__r.Date_Closed20__c,CIBIL_Extension__r.Date_Closed21__c,CIBIL_Extension__r.Date_Closed22__c,CIBIL_Extension__r.Date_Closed23__c,CIBIL_Extension__r.Date_Closed24__c,CIBIL_Extension__r.Date_Closed25__c,CIBIL_Extension__r.Date_Closed26__c,CIBIL_Extension__r.Date_Closed27__c,CIBIL_Extension__r.Date_Closed28__c,CIBIL_Extension__r.Date_Closed29__c,';
        SOQL1 += 'CIBIL_Extension__r.Account_Type20__c,CIBIL_Extension__r.Account_Type21__c,CIBIL_Extension__r.Account_Type22__c,CIBIL_Extension__r.Account_Type23__c,CIBIL_Extension__r.Account_Type24__c,CIBIL_Extension__r.Account_Type25__c,CIBIL_Extension__r.Account_Type26__c,CIBIL_Extension__r.Account_Type27__c,CIBIL_Extension__r.Account_Type28__c,CIBIL_Extension__r.Account_Type29__c,';
        SOQL1 += 'CIBIL_Extension__r.Ownership20__c,CIBIL_Extension__r.Ownership21__c,CIBIL_Extension__r.Ownership22__c,CIBIL_Extension__r.Ownership23__c,CIBIL_Extension__r.Ownership24__c,CIBIL_Extension__r.Ownership25__c,CIBIL_Extension__r.Ownership26__c,CIBIL_Extension__r.Ownership27__c,CIBIL_Extension__r.Ownership28__c,CIBIL_Extension__r.Ownership29__c,';
        SOQL1 += 'CIBIL_Extension__r.Date_Opened20__c,CIBIL_Extension__r.Date_Opened21__c,CIBIL_Extension__r.Date_Opened22__c,CIBIL_Extension__r.Date_Opened23__c,CIBIL_Extension__r.Date_Opened24__c,CIBIL_Extension__r.Date_Opened25__c,CIBIL_Extension__r.Date_Opened26__c,CIBIL_Extension__r.Date_Opened27__c,CIBIL_Extension__r.Date_Opened28__c,CIBIL_Extension__r.Date_Opened29__c,';
        SOQL1 += 'CIBIL_Extension__r.Days_Past_Due20__c,CIBIL_Extension__r.Days_Past_Due21__c,CIBIL_Extension__r.Days_Past_Due22__c,CIBIL_Extension__r.Days_Past_Due23__c,CIBIL_Extension__r.Days_Past_Due24__c,CIBIL_Extension__r.Days_Past_Due25__c,CIBIL_Extension__r.Days_Past_Due26__c,CIBIL_Extension__r.Days_Past_Due27__c,CIBIL_Extension__r.Days_Past_Due28__c,CIBIL_Extension__r.Days_Past_Due29__c,';
        SOQL1 += 'CIBIL_Extension__r.Enquiry_Purpose20__c,CIBIL_Extension__r.Enquiry_Purpose21__c,CIBIL_Extension__r.Enquiry_Purpose22__c,CIBIL_Extension__r.Enquiry_Purpose23__c,CIBIL_Extension__r.Enquiry_Purpose24__c,CIBIL_Extension__r.Enquiry_Purpose25__c,CIBIL_Extension__r.Enquiry_Purpose26__c,CIBIL_Extension__r.Enquiry_Purpose27__c,CIBIL_Extension__r.Enquiry_Purpose28__c,CIBIL_Extension__r.Enquiry_Purpose29__c,';
        SOQL1 += 'CIBIL_Extension__r.Date_of_Enquiry20__c,CIBIL_Extension__r.Date_of_Enquiry21__c,CIBIL_Extension__r.Date_of_Enquiry22__c,CIBIL_Extension__r.Date_of_Enquiry23__c,CIBIL_Extension__r.Date_of_Enquiry24__c,CIBIL_Extension__r.Date_of_Enquiry25__c,CIBIL_Extension__r.Date_of_Enquiry26__c,CIBIL_Extension__r.Date_of_Enquiry27__c,CIBIL_Extension__r.Date_of_Enquiry28__c,CIBIL_Extension__r.Date_of_Enquiry29__c ';
        SOQL1 += 'from  CIBIL__c where ID IN: cid';
                System.debug('gggggg' + SOQL1 + 'kkkkkk'); 
                clist = Database.query(SOQL1);
                */
            
            system.debug('::lstCibilExtension::'+lstCibilExtension);
            if(lstCibilExtension != null && lstCibilExtension.size()>0){ 
                lstCibilExt1 = [select id, Repayment_tenure__c, Repayment_tenure1__c, Repayment_tenure2__c, Repayment_tenure3__c, Repayment_tenure4__c, Repayment_tenure5__c, Repayment_tenure6__c, Repayment_tenure7__c, Repayment_tenure8__c, Repayment_tenure9__c, Repayment_tenure10__c, Repayment_tenure11__c, Repayment_tenure12__c, Repayment_tenure13__c, Repayment_tenure14__c, Repayment_tenure15__c, Repayment_tenure16__c, Repayment_tenure17__c, Repayment_tenure18__c, Repayment_tenure19__c, Repayment_tenure20__c, Repayment_tenure21__c, Repayment_tenure22__c, Repayment_tenure23__c, Repayment_tenure24__c, Repayment_tenure25__c, Repayment_tenure26__c, Repayment_tenure27__c, Repayment_tenure28__c, Repayment_tenure29__c, EMI__c, EMI1__c, EMI2__c, EMI3__c, EMI4__c, EMI5__c, EMI6__c, EMI7__c, EMI8__c, EMI9__c, EMI10__c, EMI11__c, EMI12__c, EMI13__c, EMI14__c, EMI15__c, EMI16__c, EMI17__c, EMI18__c, EMI19__c,EMI20__c,EMI21__c,EMI22__c,EMI23__c,EMI24__c,EMI25__c,EMI26__c,EMI27__c,EMI28__c,EMI29__c,Name from Cibil_Extension1__c where id in : lstCibilExtension];
                
                for(Cibil_Extension1__c  objCibilExt  : lstCibilExt1){                              
                    mapIDCibilExt.put(objCibilExt.id,objCibilExt);              
                }               
            }
            system.debug('::mapIDCibilExt::'+mapIDCibilExt);
            
            if(cibillist != null && cibillist.size()>0){                
                String[] productToCheck =Label.Product_for_Ext_Loan_Details_Creation.split(';');
                for(String  prod: productToCheck ){
                    setProdToCheck.add(prod);                   
                }
                system.debug('::setProdToCheck::'+setProdToCheck);
                system.debug('::Applicant::'+cibillist[0].Applicant__r.Lead__c);
                system.debug('::ApplicantDummy::'+ cibillist[0].applicant__c);
                
                //Fetch Lead details for 2 scenarios : 1-Cibil at PO , 2 CIbil at Opp level
                list<Lead> lstLead = new List<Lead>();
                //added for 20311
               
                if(s.contains(string.valueOf(cibillist[0].applicant__c).left(15).toUpperCase())){
                    lstLead = [select /*Bug Id :14509 ,S*/LeadSource,/*Bug Id :14509 ,E*/ Product__c,id,Recent_PO_for_cibil_requested__c ,Recent_PO_for_cibil_requested__r.products__c ,Recent_PO_for_cibil_requested__r.Product_Offering_Converted__c ,(Select products__c,id from Product_Offerings__r) from Lead where id=: cibillist[0].Lead__c ];
                }
                else if(cibillist[0].Applicant__r.Lead__c != null ){
                    lstLead = [select Product__c,id,Recent_PO_for_cibil_requested__c ,Recent_PO_for_cibil_requested__r.products__c ,Recent_PO_for_cibil_requested__r.Product_Offering_Converted__c ,(Select products__c,id from Product_Offerings__r) from Lead where id=:cibillist[0].Applicant__r.Lead__c];
                }
                         
                //added for 20311
                 system.debug('Value of s-->'+s);
                 system.debug('cibillist[0].applicant__c'+cibillist[0].applicant__c);
                 system.debug('s.contains(string.valueOf( cibillist[0].applicant__c).left(15).toUpperCase())'+s.contains(string.valueOf( cibillist[0].applicant__c).left(15).toUpperCase()));
                if(cibillist[0].applicant__c != null && s.contains(string.valueOf( cibillist[0].applicant__c).left(15).toUpperCase())){ 
                    system.debug('::insideif::');
                     //Bug id:14509,Changes by PG for RDL Eligibility Calculator.Start
                        if(lstLead!=null &&  lstLead.size()>0) {

                        //Bug 19254 - Max LAP , Max HL , Max BL , Max PL and Max AL values are not getting stamped on cibil extension1s. By Rajesh
                        set < string > setBolProdName = new set < string > ();
                        if(!commonUtility.isEmpty(Label.BOL_Line_Products))
                            setBolProdName.addAll(Label.BOL_Line_Products.split(';'));
    
                        
                        if(setBolProdName.contains(lstLead[0].Product__c)){
                            product = lstLead[0].Product__c;
                            isPro=true;
                        }
                        //Bug 19254 - Max LAP , Max HL , Max BL , Max PL and Max AL values are not getting stamped on cibil extension1s. By Rajesh
                        
                        if(lstLead[0].Product__c=='BOL'){
                            product='PSBL';
                            isPro=true;
                        }
                    
                        if(lstLead[0].Product__c=='RDL' ||  lstLead[0].LeadSource =='RDL Mobility' ){
                            product='RDL';  
                            isPro=true;
                        }
                          
                       } 
                        //Bug id:14509,Changes by PG for RDL Eligibility Calculator.End
                    if(lstLead != null && lstLead.size()>0 && lstLead[0].Recent_PO_for_cibil_requested__r.products__c != null &&  setProdToCheck.contains(lstLead[0].Recent_PO_for_cibil_requested__r.products__c )){
                        isPro=true;
                        poToUpdate = lstLead[0].Recent_PO_for_cibil_requested__c;
                        product = lstLead[0].Recent_PO_for_cibil_requested__r.products__c ;
                        system.debug('::insideif1::');
                        system.debug('::Product::' + product);
                    }   
                }
                 
                else
                {               
                    system.debug('::insideelse::');                                           
                    //Create map of opportunity Id and PO Id , for existing Opportunity
                    if(lstLoanAppliactionIds != null &&  lstLoanAppliactionIds.size()>0 &&  lstLead != null && lstLead.size()>0 && setProdToCheck.contains(lstLead[0].Recent_PO_for_cibil_requested__r.products__c)) {
                        List<Opportunity> lstOpportunity = new List<Opportunity> ();
                        lstOpportunity=[select id ,(select Id from Product_Offerings__r) from opportunity where id in :lstLoanAppliactionIds];
                        
                        system.debug('::lstOpportunity::'+lstOpportunity);
                        for(Opportunity objOpp : lstOpportunity){
                            system.debug('::PRODOFF::'+objOpp.Product_Offerings__r + '::SIZE::'+objOpp.Product_Offerings__r.size());
                            if(objOpp.Product_Offerings__r != null && objOpp.Product_Offerings__r.size()>0){
                                isPOConverted =true ;              
                                mapOppIDAndPoID.put(objOpp.id ,objOpp.Product_Offerings__r[0].id);
                                system.debug('::mapOppIDAndPoID::'+mapOppIDAndPoID);
                            }          
                        }          
                    }
                    system.debug('::mapOppIDAndPoID::'+mapOppIDAndPoID);
                    
                    /*system.debug('::lstLead::'+lstLead);
                    system.debug('::REQ::'+lstLead[0].Recent_PO_for_cibil_requested__c);
                    system.debug('::PRD::'+lstLead[0].Recent_PO_for_cibil_requested__r.products__c);
                    system.debug('::CNTN::'+setProdToCheck.contains(lstLead[0].Recent_PO_for_cibil_requested__r.products__c));
                    system.debug('::lstLoanAppliactionIds::'+lstLoanAppliactionIds);*/
                    
                    
                    //Create map of opportunity Id and PO Id , using this map to stamp PO ID while creating Existing_Loan_Details__c record 
                    if(lstLead != null && lstLead.size()>0 && lstLead[0].Recent_PO_for_cibil_requested__c != null  && lstLead[0].Recent_PO_for_cibil_requested__r.products__c != null &&  setProdToCheck.contains(lstLead[0].Recent_PO_for_cibil_requested__r.products__c) && lstLoanAppliactionIds != null &&  lstLoanAppliactionIds.size()>0 ){
                        
                        isPro=true;
                        isPOConverted =true ;  
                        mapOppIDAndPoID.put(lstLoanAppliactionIds[0] ,lstLead[0].Recent_PO_for_cibil_requested__c);
                        
                        //Fetch Existing_Loan_Details list to delete when PO is updated with Opportunity
                        List<Existing_Loan_Details__c> lstExtLoanDetailsLcl= new List<Existing_Loan_Details__c>();
                        lstExtLoanDetailsLcl=[Select id,EMI__c from Existing_Loan_Details__c where Product_Offering__c in :mapOppIDAndPoID.values() AND Loan_Application__c=: Label.Dummy_Opportunity];
                        system.debug('lstExtLoanDetailsLcl:::'+ lstExtLoanDetailsLcl);
                        
                        if(lstExtLoanDetailsLcl != null && lstExtLoanDetailsLcl.size()>0)
                        delete lstExtLoanDetailsLcl ;
                    }
                    system.debug('::mapOppIDAndPoIDConv::'+mapOppIDAndPoID);
                    
                    
                    //Harsit----optmization----START
                    //Here, if lblCiblquery is 'true', then retrieving the cibil child records of applicant.... but didn't find any use of them...So commenting out the below code and getting the applicant fields value through cibil records.
                    /*
                    lblCiblquery = label.CibilQuery; // didn't use anywhere
                    ID applicantid = cibillist[0].applicant__c;
                    system.debug('applicantid' + applicantid);
                    if (lblCiblquery == 'True') {
                        applicant = [select Loan_Application__c,Loan_Application__r.Product__c, (Select Id From CIBILs__r) From Applicant__c where id = : applicantid];
                    } else {
                        applicant = [select Loan_Application__c,Loan_Application__r.Product__c From Applicant__c where id = : applicantid];
                    }
                    
                    System.debug('applicantsize' + applicant.size());
                    */
                    //if (applicant.size() > 0) {
                    /*if (lblCiblquery == 'True') {
                            cibillistfapp = applicant[0].CIBILs__r;
                            System.debug('cibillistforapplicant' + cibillistfapp.size());
                        }*/
                    if(cibillist[0].applicant__r.Loan_Application__r != null){
                        product = cibillist[0].applicant__r.Loan_Application__r.Product__c;
                    }
                    if(cibillist[0].applicant__r.Loan_Application__c==null && cibillist[0].Lead__c!=null && lstLead != null && lstLead.size()>0)
                    {
                        if(lstLead[0].Product__c=='BOL')
                        {
                            product='PSBL';
                            isPro=true;
                        }
                    }
                    if(cibillist[0].applicant__r.Loan_Application__c==null && cibillist[0].Lead__c!=null && lstLead != null && lstLead.size()>0)
                    {
                        for(Product_Offerings__c PO : lstLead[0].Product_Offerings__r)
                        {
                            //Bug:17470
                                 isPROProductLineProduct = getPROProductLineLFlag(PO.products__c);
                            if(isPROProductLineProduct)
                            isPro=true;
                            break ;
                        }        
                    }               
                    system.debug('Product is' + product);
                    system.debug('isPro is' + isPro);
                    //}  
                    //harsit-----optmization----END
                }  
                                
            }
            
            /*for (CIBIL__c c: clist) {
                    if (c.Applicant__r.Contact_Name__r.ApplicantType__c != 'Non co-applicant party' && (c.Applicant__r.Loan_Application__r.Product__c == 'SAL' || c.Applicant__r.Loan_Application__r.Product__c == 'RSL' || c.Applicant__r.Loan_Application__r.Product__c == 'SOL' || c.Applicant__r.Loan_Application__r.Product__c == 'SPL' || c.Applicant__r.Loan_Application__r.Product__c == 'SBS CS SAL' || c.Applicant__r.Loan_Application__r.Product__c == 'SHL' || c.Applicant__r.Loan_Application__r.Product__c == 'SBS CS SHL' || c.Applicant__r.Loan_Application__r.Product__c == 'SHOL' || c.Applicant__r.Loan_Application__r.Product__c == 'PSBL'||  (ProductForFlowLabel != null && ProductForFlowLabel.contains(c.Applicant__r.Loan_Application__r.Product__c))) || c.Applicant__r.Loan_Application__r.Product__c == 'DOCTORS' || c.Applicant__r.Loan_Application__r.Product__c == 'PRO' || isPro) || c.Enable_Manual_Cibil__c) {
                        system.debug('#####inside#####clist####for eld  conversion ######');
                        clist1.add(c);

                    }
                }*/

            //elist=[Select id from Existing_Loan_Details__c where Loan_Application__c=:loanappid AND Creation_of_Loan__c='Automatic'];
            
            for (CIBIL__c c: cibillist) {
                /*Start BUG-16959*/
                if(c.Applicant__r.Loan_Application__r.Product__c!=null && c.Applicant__r.Loan_Application__r.Product__c!='')
                isPSBLProductLineProduct = getPSBLorDBOLProductLineFlag(c.Applicant__r.Loan_Application__r.Product__c);
                System.debug('*********c.Applicant__r.Loan_Application__c'+c.Applicant__r.Loan_Application__c +'++++++++++c.Applicant__r.Contact_Name__r.ApplicantType__c'+ c.Applicant__r.Contact_Name__r.ApplicantType__c+'++++++++++c.Applicant__r.Loan_Application__r.Product__c'+c.Applicant__r.Loan_Application__r.Product__c +'++++++++++isPro'+ isPro + '::mapOppIDAndPoIDINS::'+mapOppIDAndPoID);
                    //Bug:17470
                isPROProductLineProduct = getPROProductLineLFlag(c.Applicant__r.Loan_Application__r.Product__c);
                //Create Cibil list for processing for both Flows. 1-Cibil at Lead level 2-Cibil at Opportunity level
               //added for 20311
               
               if((c.applicant__c != null && s.contains(string.valueOf(c.applicant__c).left(15).toUpperCase()) && isPro )|| c.Enable_Manual_Cibil__c || isPOConverted){             
                    cibilListToProcess.add(c);
                    system.debug('::CibilListForDummyApplicant::');
                } 
                //Bug 13830:Custom label added for new products
                
                else if( c.Applicant__r.Loan_Application__c != null && c.Applicant__r.Contact_Name__r.ApplicantType__c != 'Non co-applicant party'  && mapOppIDAndPoID!= null && !mapOppIDAndPoID.containskey(c.Applicant__r.Loan_Application__c) && (c.Applicant__r.Loan_Application__r.Product__c == 'SAL' || c.Applicant__r.Loan_Application__r.Product__c == 'RSL' || c.Applicant__r.Loan_Application__r.Product__c == 'SOL' || c.Applicant__r.Loan_Application__r.Product__c == 'SPL' || c.Applicant__r.Loan_Application__r.Product__c == 'SBS CS SAL' || c.Applicant__r.Loan_Application__r.Product__c == 'HSL' || c.Applicant__r.Loan_Application__r.Product__c == 'SHL' || c.Applicant__r.Loan_Application__r.Product__c == 'SBS CS SHL' || c.Applicant__r.Loan_Application__r.Product__c == 'SHOL' ||( /*BUG-16959 S*/ isPSBLProductLineProduct /*BUG-16959 E*/|| (NewProductsAdded != null && NewProductsAdded.contains(c.Applicant__r.Loan_Application__r.Product__c)) || ProductForFlowLabel != null && ProductForFlowLabel.contains(c.Applicant__r.Loan_Application__r.Product__c)) || c.Applicant__r.Loan_Application__r.Product__c == 'DOCTORS' || isPROProductLineProduct || c.Applicant__r.Loan_Application__r.Product__c == 'Home Loan' || c.Applicant__r.Loan_Application__r.Product__c == 'LAP'|| c.Applicant__r.Loan_Application__r.Product__c == 'RDL' || isPro )  ) {
                    system.debug('#####inside#####cibillist####for eld  conversion ######');
                    cibilListToProcess.add(c);              
                }
                               
            }
            
            system.debug('::cibilListToProcess::'+cibilListToProcess); 
            
            for (CIBIL__c c: cibilListToProcess) { 
                Cibil_Extension1__c objCibilExt = new Cibil_Extension1__c ();   
                if(c.Cibil_Extension1__c != null && mapIDCibilExt != null && mapIDCibilExt.containskey(c.Cibil_Extension1__c))   
                objCibilExt= mapIDCibilExt.get(c.Cibil_Extension1__c);
                
                system.debug('::objCibilExt::'+objCibilExt);
                
                // Cibil_Extension1__c cex=c.Cibil_Extension1__c; 
                /*      
                    ID cex1ID = c.Cibil_Extension1__c;
                cexlist=[select id,Repayment_tenure__c,Repayment_tenure1__c,Repayment_tenure2__c,Repayment_tenure3__c,Repayment_tenure4__c,Repayment_tenure5__c,Repayment_tenure6__c,Repayment_tenure7__c,Repayment_tenure8__c,Repayment_tenure9__c,Repayment_tenure10__c,Repayment_tenure11__c,Repayment_tenure12__c,Repayment_tenure13__c,Repayment_tenure14__c,Repayment_tenure15__c,Repayment_tenure16__c,Repayment_tenure17__c,Repayment_tenure18__c,Repayment_tenure19__c,Repayment_tenure20__c,Repayment_tenure21__c,Repayment_tenure22__c,Repayment_tenure23__c,Repayment_tenure24__c,Repayment_tenure25__c,Repayment_tenure26__c,Repayment_tenure27__c,Repayment_tenure28__c,Repayment_tenure29__c,EMI__c,EMI1__c,EMI2__c,EMI3__c,EMI4__c,EMI5__c,EMI6__c,EMI7__c,EMI8__c,EMI9__c,EMI10__c,EMI11__c,EMI12__c,EMI13__c,EMI14__c,EMI15__c,EMI16__c,EMI17__c,EMI18__c,EMI19__c,EMI20__c,EMI21__c,EMI22__c,EMI23__c,EMI24__c,EMI25__c,EMI26__c,EMI27__c,EMI28__c,EMI29__c,Name from Cibil_Extension1__c where id=:cex1ID];
                    */
                //  system.debug('Cex1'+ cexlist[0].id);  
                
                Existing_Loan_Details__c e = new Existing_Loan_Details__c();
                //When cibil is done at Lead level then stamp Dummy Opp id to ELD
                //added for 20311
                
                if(c.applicant__c != null && s.contains(string.valueOf(c.applicant__c).left(15).toUpperCase()) && isPro ){
                    e.Loan_Application__c = Label.Dummy_Opportunity ;
                    e.Applicant__c = c.applicant__c;
                }else{
                    e.Loan_Application__c = c.Applicant__r.Loan_Application__c; 
                    e.Applicant__c = c.Applicant__c;
                }
                
                
                e.Financer__c = '';
                e.Seen_in__c = 'CIBIL';
                e.Type_of_Oblig__c = 'Individual';  
                //vikas fix S
                // if (objCibilExt != null) {
                //    e.Tenor__c = objCibilExt.Repayment_tenure__c;
                //  e.EMI__c = objCibilExt.EMI__c;
                // }
                //vikas fix S
                //Stamp PO on ELD 
                //added for 20311
                
                if(c.applicant__c != null && s.contains(string.valueOf(c.applicant__c).left(15).toUpperCase()) && isPro && String.isNotEmpty(poToUpdate) )     
                e.Product_Offering__c = poToUpdate;
                else if(mapOppIDAndPoID != null && mapOppIDAndPoID.containskey(c.Applicant__r.Loan_Application__c))              
                e.Product_Offering__c =mapOppIDAndPoID.get(c.Applicant__r.Loan_Application__c) ;
                
                system.debug('::mapOppIDAndPoID1::'+mapOppIDAndPoID);
                system.debug('::LonApp::'+c.Applicant__r.Loan_Application__c);
                system.debug('::poToUpdate::'+ poToUpdate);
                system.debug('::PRODOff::'+ e.Product_Offering__c);
                system.debug('::Appl::'+ e.Applicant__c);
                system.debug('c.Cibil_Temp__r.SecondaryMatch_Record__c='+c.Cibil_Temp__r.SecondaryMatch_Record__c);
                /*Prajyot #12269: added If condition */
                
                if(c.Cibil_Temp__r.SecondaryMatch_Record__c != true)
                {  
                    system.debug('accounttype---'+c.Account_Type__c+'ownership-----'+c.Ownership__c);
                    if (c.Account_Type__c != 'NO DATA' && c.Account_Type__c != null && c.Account_Type__c != '' && ((c.Ownership__c == 'Individual') || (c.Ownership__c == 'joint'))) {
                        system.debug('::e::'+ e);
                        Existing_Loan_Details__c objEld = new Existing_Loan_Details__c();
                        objEld = e.clone(false, true, false, false);
                        //e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
                        objEld.Loan_Type__c = c.Account_Type__c;
                        //e.Financer__c = '';
                        //e.Seen_in__c = 'CIBIL';
                        // e.Tenor__c=12;
                        //e.Type_of_Oblig__c = 'Individual';
                        //e.Applicant__c = c.Applicant__c;
                        // e.Principal_O_s__c=c.Current_Balance__c;
                        if (objCibilExt != null) {
                            objEld.Tenor__c = objCibilExt.Repayment_tenure__c;
                            objEld.EMI__c = objCibilExt.EMI__c;
                        }
                        if (c.Current_Balance__c > 0) objEld.POS__c = c.Current_Balance__c;
                        else objEld.POS__c = 0;
                        
                        /*
                        //Set MOB__c values for Product as PRO
                        if(c.applicant__c != null && c.applicant__c == Label.DummyApplicant && isPro ){
                            assignELDMob(objEld,c.Date_Opened__c,c.Date_closed__c);
                        }   
                        else */
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start added contain condition
                        if ((c.Applicant__r.Loan_Application__r.Product__c == 'SOL'  )|| (eldProducts.contains(c.Applicant__r.Loan_Application__r.Product__c))) {
                            if(System.Label.MobCalculation.equalsIgnoreCase('true'))
                            mobProd = c.Applicant__r.Loan_Application__r.Product__c;//844
                            assignELDMob(objEld,c.Date_Opened__c,c.Date_closed__c);
                            /*if (c.Date_Opened__c != null && c.Date_closed__c == null) {
                                date a = system.today();
                                integer i = a.day();
                                integer j = c.Date_Opened__c.day();
                                system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
                                if (i == j) objEld.MOB__c = c.Date_Opened__c.monthsbetween(system.today()) - 1;
                                else objEld.MOB__c = c.Date_Opened__c.monthsbetween(system.today()) - 2;
                                system.debug('c.Date_Opened__c.monthsbetween(system.today())*************' + c.Date_Opened__c.monthsbetween(system.today()) + 'ccccccccc' + c.Date_closed__c);
                            } else if (c.Date_Opened__c != null) objEld.MOB__c = c.Date_Opened__c.monthsbetween(c.Date_closed__c);*/
                        }
                        objEld.Ownership__c = c.Ownership__c;               
                        
                        if (c.Date_Closed__c != null) {
                            // if(c.Date_Closed__c>=(system.today()-395)){
                            objEld.Status__c = 'Closed';
                            objEld.Obligation__c = 'No';
                            //  }
                        } else {
                            objEld.Status__c = 'Live';
                            objEld.Obligation__c = 'Yes';
                        }
                        objEld.Start_On__c = c.Date_Opened__c;
                        objEld.Loan_Amount__c = c.Sanction_Amount__c;
                        if (c.Date_Closed__c != Null) daysclosed = c.Date_Closed__c.daysbetween(system.today());
                        if (c.Date_Closed__c == null || daysclosed <= 365 || (daysclosed > 365 && !CommonUtility.isEmpty(SecLoans) && SecLoans.contains(objEld.Loan_Type__c))) eld.add(objEld); //26861 changed if condition
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start
                        //Bug 23425
                        if(isPLBLRisk == false)
                            setisBLPLRiskFlag(daysclosed,c.Sanction_Amount__c,c.Applicant__r.Loan_Application__r.Product__c,c.Account_Type__c,mobValue,c.Applicant__c);
                    }
                    if (c.Account_Type1__c != 'NO DATA' && c.Account_Type1__c != null && c.Account_Type1__c != '' && ((c.Ownership1__c == 'Individual') || (c.Ownership1__c == 'joint'))) {
                        system.debug('::e::'+ e);
                        Existing_Loan_Details__c objEld1 = new Existing_Loan_Details__c();
                        objEld1 = e.clone(false, true, false, false);
                        // e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
                        objEld1.Loan_Type__c = c.Account_Type1__c;
                        //e.Financer__c = '';
                        //e.Seen_in__c = 'CIBIL';
                        //e.Tenor__c=12;
                        if (objCibilExt != null) {
                            objEld1.Tenor__c = objCibilExt.Repayment_tenure1__c;
                            objEld1.EMI__c = objCibilExt.EMI1__c;
                        }
                        
                        if (c.Current_Balance1__c > 0) objEld1.POS__c = c.Current_Balance1__c;
                        else objEld1.POS__c = 0;
                        
                        /*
                        //Set MOB__c values for Product as PRO
                        if(c.applicant__c != null && c.applicant__c == Label.DummyApplicant && isPro ){
                            assignELDMob(objEld1,c.Date_Opened__c,c.Date_closed__c);
                        }
                        else */
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start added contain condition
                        if ((c.Applicant__r.Loan_Application__r.Product__c == 'SOL')|| (eldProducts.contains(c.Applicant__r.Loan_Application__r.Product__c))) {
                            if(System.Label.MobCalculation.equalsIgnoreCase('true'))
                            mobProd = c.Applicant__r.Loan_Application__r.Product__c;//844
                            assignELDMob(objEld1,c.Date_Opened1__c,c.Date_closed1__c);
                            /*system.debug('aaaaaaaaaaaaaaaaa' + c.Date_closed1__c);
                            if (c.Date_Opened1__c != null && (c.Date_closed1__c == null)) {
                                date a = system.today();
                                integer i = a.day();
                                integer j = c.Date_Opened1__c.day();
                                system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
                                if (i == j) objEld1.MOB__c = c.Date_Opened1__c.monthsbetween(system.today()) - 1;
                                else objEld1.MOB__c = c.Date_Opened1__c.monthsbetween(system.today()) - 2;
                                system.debug('c.Date_Opened1__c.monthsbetween(system.today())*************' + c.Date_Opened1__c.monthsbetween(system.today()) + 'ccccccccc' + c.Date_closed1__c);
    
                            } else if (c.Date_Opened1__c != null) objEld1.MOB__c = c.Date_Opened1__c.monthsbetween(c.Date_closed1__c);*/
                        }
                        objEld1.Ownership__c = c.Ownership1__c;
                        /*   if(c.Date_Closed1__c<=system.today())
                        {
                            e.Status__c='Closed';
                            e.Obligation__c='No';
                        }
                        else
                        {
                            e.Status__c='Live';
                            e.Obligation__c='Yes';
                        }  */
                        if (c.Date_Closed1__c != null) {
                            //   if(c.Date_Closed1__c>=(system.today()-12)){
                            objEld1.Status__c = 'Closed';
                            objEld1.Obligation__c = 'No';
                            //  }
                        } else {
                            objEld1.Status__c = 'Live';
                            objEld1.Obligation__c = 'Yes';
                        }
                        //e.Type_of_Oblig__c = 'Individual';
                        //e.Applicant__c = c.Applicant__c;
                        // e.Principal_O_s__c=c.Current_Balance1__c;
                        objEld1.Start_On__c = c.Date_Opened1__c;
                        objEld1.Loan_Amount__c = c.Sanction_Amount1__c;
                        if (c.Date_Closed1__c != Null) daysclosed = c.Date_Closed1__c.daysbetween(system.today());
                        if (c.Date_Closed1__c == null || daysclosed <= 365 || (daysclosed > 365 && !CommonUtility.isEmpty(SecLoans) && SecLoans.contains(objEld1.Loan_Type__c))) eld.add(objEld1); //26861 changed if condition
                        
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start
                        //Bug 23425
                        if(isPLBLRisk == false)
                            setisBLPLRiskFlag(daysclosed,c.Sanction_Amount1__c,c.Applicant__r.Loan_Application__r.Product__c,c.Account_Type1__c,mobValue,c.Applicant__c);
                    }
                    system.debug('objEld^^^^^^^^^^^^2');
                    if (c.Account_Type2__c != 'NO DATA' && c.Account_Type2__c != null && c.Account_Type2__c != '' && ((c.Ownership2__c == 'Individual') || (c.Ownership2__c == 'joint'))) {
                        Existing_Loan_Details__c objEld2 = new Existing_Loan_Details__c();
                        objEld2 = e.clone(false, true, false, false);
                        // e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
                        objEld2.Loan_Type__c = c.Account_Type2__c;
                        //e.Financer__c = '';
                        //e.Seen_in__c = 'CIBIL';
                        // e.Tenor__c=12;
                        if (objCibilExt != null) {
                            objEld2.Tenor__c = objCibilExt.Repayment_tenure2__c;
                            objEld2.EMI__c = objCibilExt.EMI2__c;
                        }
                        if (c.Current_Balance2__c > 0) objEld2.POS__c = c.Current_Balance2__c;
                        else objEld2.POS__c = 0;
                        //code added by Bug : 21238  ELDELDInsertAndMOBCalc start added contain condition
                        if ((c.Applicant__r.Loan_Application__r.Product__c == 'SOL') || (eldProducts.contains(c.Applicant__r.Loan_Application__r.Product__c))){
                            if(System.Label.MobCalculation.equalsIgnoreCase('true'))
                            mobProd = c.Applicant__r.Loan_Application__r.Product__c;//844
                            assignELDMob(objEld2,c.Date_Opened2__c,c.Date_closed2__c);
                            /*if (c.Date_Opened2__c != null && c.Date_closed2__c == null) {
                                date a = system.today();
                                integer i = a.day();
                                integer j = c.Date_Opened2__c.day();
                                system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
                                if (i == j) objEld2.MOB__c = c.Date_Opened2__c.monthsbetween(system.today()) - 1;
                                else objEld2.MOB__c = c.Date_Opened2__c.monthsbetween(system.today()) - 2;
                                system.debug('c.Date_Opened2__c.monthsbetween(system.today())*************' + c.Date_Opened2__c.monthsbetween(system.today()) + 'ccccccccc' + c.Date_closed2__c);
    
    
                            } else if (c.Date_Opened2__c != null) objEld2.MOB__c = c.Date_Opened2__c.monthsbetween(c.Date_closed2__c);*/
                        }
                        objEld2.Ownership__c = c.Ownership2__c;
                        /*    if(c.Date_Closed2__c<=system.today())
                        {
                            e.Status__c='Closed';
                            e.Obligation__c='No';
                        }
                        else
                        {
                            e.Status__c='Live';
                            e.Obligation__c='Yes';
                        }
                        */
                        if (c.Date_Closed2__c != null) {
                            // if(c.Date_Closed2__c>=(system.today()-12)){
                            objEld2.Status__c = 'Closed';
                            objEld2.Obligation__c = 'No';
                            //  }
                        } else {
                            objEld2.Status__c = 'Live';
                            objEld2.Obligation__c = 'Yes';
                        }
                        //e.Type_of_Oblig__c = 'Individual';
                        //e.Applicant__c = c.Applicant__c;
                        // e.Principal_O_s__c=c.Current_Balance2__c;
                        objEld2.Start_On__c = c.Date_Opened2__c;
                        objEld2.Loan_Amount__c = c.Sanction_Amount2__c;
                        if (c.Date_Closed2__c != Null) daysclosed = c.Date_Closed2__c.daysbetween(system.today());
                        if (c.Date_Closed2__c == null || daysclosed <= 365 || (daysclosed > 365 && !CommonUtility.isEmpty(SecLoans) && SecLoans.contains(objEld2.Loan_Type__c))) eld.add(objEld2); //26861 changed if condition
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start
                        //Bug 23425
                        if(isPLBLRisk == false)
                            setisBLPLRiskFlag(daysclosed,c.Sanction_Amount2__c,c.Applicant__r.Loan_Application__r.Product__c,c.Account_Type2__c,mobValue,c.Applicant__c);
                    }
                    system.debug('objEld^^^^^^^^^^^^3');
                    if (c.Account_Type3__c != 'NO DATA' && c.Account_Type3__c != null && c.Account_Type3__c != '' && ((c.Ownership3__c == 'Individual') || (c.Ownership3__c == 'joint'))) {
                        Existing_Loan_Details__c objEld3 = new Existing_Loan_Details__c();
                        objEld3 = e.clone(false, true, false, false);
                        // e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
                        objEld3.Loan_Type__c = c.Account_Type3__c;
                        //e.Financer__c = '';
                        //e.Seen_in__c = 'CIBIL';
                        //e.Tenor__c=12;
                        if (objCibilExt != null) {
                            objEld3.Tenor__c = objCibilExt.Repayment_tenure3__c;
                            objEld3.EMI__c =objCibilExt.EMI3__c;
                        }
                        if (c.Current_Balance3__c > 0) objEld3.POS__c = c.Current_Balance3__c;
                        else objEld3.POS__c = 0;
                        //code added  Bug : 21238  ELDELDInsertAndMOBCalc start added contain condition
                        if ((c.Applicant__r.Loan_Application__r.Product__c == 'SOL')|| (eldProducts.contains(c.Applicant__r.Loan_Application__r.Product__c))) {
                            if(System.Label.MobCalculation.equalsIgnoreCase('true'))
                            mobProd = c.Applicant__r.Loan_Application__r.Product__c;//844
                            assignELDMob(objEld3,c.Date_Opened3__c,c.Date_closed3__c);
                            /*if (c.Date_Opened3__c != null && c.Date_closed3__c == null) {
    
                                date a = system.today();
                                integer i = a.day();
                                integer j = c.Date_Opened3__c.day();
                                system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
                                if (i == j) objEld3.MOB__c = c.Date_Opened3__c.monthsbetween(system.today()) - 1;
                                else objEld3.MOB__c = c.Date_Opened3__c.monthsbetween(system.today()) - 2;
                                system.debug('c.Date_Opened3__c.monthsbetween(system.today())*************' + c.Date_Opened3__c.monthsbetween(system.today()) + 'ccccccccc' + c.Date_closed3__c);
    
    
                            } else if (c.Date_Opened3__c != null) objEld3.MOB__c = c.Date_Opened3__c.monthsbetween(c.Date_closed3__c);*/
                        }
                        objEld3.Ownership__c = c.Ownership3__c;
                        /*     if(c.Date_Closed3__c<=system.today())
                        {
                            e.Status__c='Closed';
                            e.Obligation__c='No';
                        }
                        else
                        {
                            e.Status__c='Live';
                            e.Obligation__c='Yes';
                        } */
                        
                        if (c.Date_Closed3__c != null) {
                            // if(c.Date_Closed3__c>=(system.today()-12)){
                            objEld3.Status__c = 'Closed';
                            objEld3.Obligation__c = 'No';
                            //  }
                        } else {
                            objEld3.Status__c = 'Live';
                            objEld3.Obligation__c = 'Yes';
                        }
                        //e.Type_of_Oblig__c = 'Individual';
                        //e.Applicant__c = c.Applicant__c;
                        // e.Principal_O_s__c=c.Current_Balance3__c;
                        objEld3.Start_On__c = c.Date_Opened3__c;
                        objEld3.Loan_Amount__c = c.Sanction_Amount3__c;
                        if (c.Date_Closed3__c != Null) daysclosed = c.Date_Closed3__c.daysbetween(system.today());
                        if (c.Date_Closed3__c == null || daysclosed <= 365 || (daysclosed > 365 && !CommonUtility.isEmpty(SecLoans) && SecLoans.contains(objEld3.Loan_Type__c))) eld.add(objEld3); //26861 changed if condition
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start
                        //Bug 23425
                        if(isPLBLRisk == false)
                            setisBLPLRiskFlag(daysclosed,c.Sanction_Amount3__c,c.Applicant__r.Loan_Application__r.Product__c,c.Account_Type3__c,mobValue,c.Applicant__c);
                    }
                    system.debug('objEld^^^^^^^^^^^^4');
                    if (c.Account_Type4__c != 'NO DATA' && c.Account_Type4__c != null && c.Account_Type4__c != '' && ((c.Ownership4__c == 'Individual') || (c.Ownership4__c == 'joint'))) {
                        Existing_Loan_Details__c objEld4 = new Existing_Loan_Details__c();
                        objEld4 = e.clone(false, true, false, false);
                        // e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
                        objEld4.Loan_Type__c = c.Account_Type4__c;
                        //e.Financer__c = '';
                        //e.Seen_in__c = 'CIBIL';
                        // e.Tenor__c=12;
                        if (objCibilExt != null) {
                            objEld4.Tenor__c = objCibilExt.Repayment_tenure4__c;
                            objEld4.EMI__c = objCibilExt.EMI4__c;
                        }
                        if (c.Current_Balance4__c > 0) objEld4.POS__c = c.Current_Balance4__c;
                        else objEld4.POS__c = 0;
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start added contain condition
                        if ((c.Applicant__r.Loan_Application__r.Product__c == 'SOL')|| (eldProducts.contains(c.Applicant__r.Loan_Application__r.Product__c))) {
                            if(System.Label.MobCalculation.equalsIgnoreCase('true'))
                            mobProd = c.Applicant__r.Loan_Application__r.Product__c;//844
                            assignELDMob(objEld4,c.Date_Opened4__c,c.Date_closed4__c);
                            /*if (c.Date_Opened4__c != null && c.Date_closed4__c == null) {
    
                                date a = system.today();
                                integer i = a.day();
                                integer j = c.Date_Opened4__c.day();
                                system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
                                if (i == j) objEld4.MOB__c = c.Date_Opened4__c.monthsbetween(system.today()) - 1;
                                else objEld4.MOB__c = c.Date_Opened4__c.monthsbetween(system.today()) - 2;
                                system.debug('c.Date_Opened4__c.monthsbetween(system.today())*************' + c.Date_Opened4__c.monthsbetween(system.today()) + 'ccccccccc' + c.Date_closed4__c);
    
    
                            } else if (c.Date_Opened4__c != null) objEld4.MOB__c = c.Date_Opened4__c.monthsbetween(c.Date_closed4__c);*/
                        }
                        objEld4.Ownership__c = c.Ownership4__c;
                        /*   if(c.Date_Closed4__c<=system.today())
                        {
                            e.Status__c='Closed';
                            e.Obligation__c='No';
                        }
                        else
                        {
                            e.Status__c='Live';
                            e.Obligation__c='Yes';
                        }
                        */
                        if (c.Date_Closed4__c != null) {
                            // if(c.Date_Closed4__c>=(system.today()-12)){
                            objEld4.Status__c = 'Closed';
                            objEld4.Obligation__c = 'No';
                            // }
                        } else {
                            objEld4.Status__c = 'Live';
                            objEld4.Obligation__c = 'Yes';
                        }
                        //e.Type_of_Oblig__c = 'Individual';
                        //e.Applicant__c = c.Applicant__c;
                        // e.Principal_O_s__c=c.Current_Balance4__c;
                        objEld4.Start_On__c = c.Date_Opened4__c;
                        objEld4.Loan_Amount__c = c.Sanction_Amount4__c;
                        if (c.Date_Closed4__c != Null) daysclosed = c.Date_Closed4__c.daysbetween(system.today());
                        if (c.Date_Closed4__c == null || daysclosed <= 365 || (daysclosed > 365 && !CommonUtility.isEmpty(SecLoans) && SecLoans.contains(objEld4.Loan_Type__c))) eld.add(objEld4); //26861 changed if condition
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start
                        //Bug 23425
                        if(isPLBLRisk == false)
                            setisBLPLRiskFlag(daysclosed,c.Sanction_Amount4__c,c.Applicant__r.Loan_Application__r.Product__c,c.Account_Type4__c,mobValue,c.Applicant__c);
                    }
                    system.debug('objEld^^^^^^^^^^^^5');
                    if (c.Account_Type5__c != 'NO DATA' && c.Account_Type5__c != null && c.Account_Type5__c != '' && ((c.Ownership5__c == 'Individual') || (c.Ownership5__c == 'joint'))) {
                        Existing_Loan_Details__c objEld5 = new Existing_Loan_Details__c();
                        objEld5 = e.clone(false, true, false, false);
                        // e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
                        objEld5.Loan_Type__c = c.Account_Type5__c;
                        //e.Financer__c = '';
                        //e.Seen_in__c = 'CIBIL';
                        // e.Tenor__c=12;
                        if (objCibilExt != null) {
                            objEld5.Tenor__c = objCibilExt.Repayment_tenure5__c;
                            objEld5.EMI__c = objCibilExt.EMI5__c;
                        }
                        if (c.Current_Balance5__c > 0) objEld5.POS__c = c.Current_Balance5__c;
                        else objEld5.POS__c = 0;
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start added contain condition
                        if ((c.Applicant__r.Loan_Application__r.Product__c == 'SOL') || (eldProducts.contains(c.Applicant__r.Loan_Application__r.Product__c))){
                            if(System.Label.MobCalculation.equalsIgnoreCase('true'))
                            mobProd = c.Applicant__r.Loan_Application__r.Product__c;//844
                            assignELDMob(objEld5,c.Date_Opened5__c,c.Date_closed5__c);
                            /*if (c.Date_Opened5__c != null && c.Date_closed5__c == null) {
    
                                date a = system.today();
                                integer i = a.day();
                                integer j = c.Date_Opened5__c.day();
                                system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
                                if (i == j) objEld5.MOB__c = c.Date_Opened5__c.monthsbetween(system.today()) - 1;
                                else objEld5.MOB__c = c.Date_Opened5__c.monthsbetween(system.today()) - 2;
                                system.debug('c.Date_Opened5__c.monthsbetween(system.today())*************' + c.Date_Opened5__c.monthsbetween(system.today()) + 'ccccccccc' + c.Date_closed5__c);
    
    
                            } else if (c.Date_Opened5__c != null) objEld5.MOB__c = c.Date_Opened5__c.monthsbetween(c.Date_closed5__c);*/
                            
                        }
                        objEld5.Ownership__c = c.Ownership5__c;
                        /*     if(c.Date_Closed5__c<=system.today())
                        {
                            e.Status__c='Closed';
                            e.Obligation__c='No';
                        }
                        else
                        {
                            e.Status__c='Live';
                            e.Obligation__c='Yes';
                        }
                        */
                        if (c.Date_Closed5__c != null) {
                            // if(c.Date_Closed5__c>=(system.today()-12)){
                            objEld5.Status__c = 'Closed';
                            objEld5.Obligation__c = 'No';
                            // }
                        } else {
                            objEld5.Status__c = 'Live';
                            objEld5.Obligation__c = 'Yes';
                        }
                        //e.Type_of_Oblig__c = 'Individual';
                        //e.Applicant__c = c.Applicant__c;
                        // e.Principal_O_s__c=c.Current_Balance5__c;
                        objEld5.Start_On__c = c.Date_Opened5__c;
                        objEld5.Loan_Amount__c = c.Sanction_Amount5__c;
                        if (c.Date_Closed5__c != Null) daysclosed = c.Date_Closed5__c.daysbetween(system.today());
                        if (c.Date_Closed5__c == null || daysclosed <= 365 || (daysclosed > 365 && !CommonUtility.isEmpty(SecLoans) && SecLoans.contains(objEld5.Loan_Type__c))) eld.add(objEld5); //26861 changed if condition
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start
                        //Bug 23425
                        if(isPLBLRisk == false)
                            setisBLPLRiskFlag(daysclosed,c.Sanction_Amount5__c,c.Applicant__r.Loan_Application__r.Product__c,c.Account_Type5__c,mobValue,c.Applicant__c);
                    }
                    system.debug('objEld^^^^^^^^^^^^6');
                    if (c.Account_Type6__c != 'NO DATA' && c.Account_Type6__c != null && c.Account_Type6__c != '' && ((c.Ownership6__c == 'Individual') || (c.Ownership6__c == 'joint'))) {
                        Existing_Loan_Details__c objEld6 = new Existing_Loan_Details__c();
                        objEld6 = e.clone(false, true, false, false);
                        // e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
                        objEld6.Loan_Type__c = c.Account_Type6__c;
                        //e.Financer__c = '';
                        //e.Seen_in__c = 'CIBIL';
                        //e.Tenor__c=12;
                        if (objCibilExt != null) {
                            objEld6.Tenor__c = objCibilExt.Repayment_tenure6__c;
                            objEld6.EMI__c = objCibilExt.EMI6__c;
                        }
                        if (c.Current_Balance6__c > 0) objEld6.POS__c = c.Current_Balance6__c;
                        else objEld6.POS__c = 0;
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start added contain condition
                        if ((c.Applicant__r.Loan_Application__r.Product__c == 'SOL')|| (eldProducts.contains(c.Applicant__r.Loan_Application__r.Product__c))) {
                            if(System.Label.MobCalculation.equalsIgnoreCase('true'))
                            mobProd = c.Applicant__r.Loan_Application__r.Product__c;//844
                            assignELDMob(objEld6,c.Date_Opened6__c,c.Date_closed6__c);
                            /*if (c.Date_Opened6__c != null && c.Date_closed6__c == null) {
    
                                date a = system.today();
                                integer i = a.day();
                                integer j = c.Date_Opened6__c.day();
                                system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
                                if (i == j) objEld6.MOB__c = c.Date_Opened6__c.monthsbetween(system.today()) - 1;
                                else objEld6.MOB__c = c.Date_Opened6__c.monthsbetween(system.today()) - 2;
                                system.debug('c.Date_Opened6__c.monthsbetween(system.today())*************' + c.Date_Opened6__c.monthsbetween(system.today()) + 'ccccccccc' + c.Date_closed6__c);
    
    
                            } else if (c.Date_Opened6__c != null) objEld6.MOB__c = c.Date_Opened6__c.monthsbetween(c.Date_closed6__c);*/
                        }
                        objEld6.Ownership__c = c.Ownership6__c;
                        /*   if(c.Date_Closed6__c<=system.today())
                        {
                            e.Status__c='Closed';
                            e.Obligation__c='No';
                        }
                        else{
                            e.Status__c='Live';
                            e.Obligation__c='Yes';
                        } */
                        if (c.Date_Closed6__c != null) {
                            // if(c.Date_Closed6__c>=(system.today()-12)){
                            objEld6.Status__c = 'Closed';
                            objEld6.Obligation__c = 'No';
                            // }
                        } else {
                            objEld6.Status__c = 'Live';
                            objEld6.Obligation__c = 'Yes';
                        }
                        //e.Type_of_Oblig__c = 'Individual';
                        //e.Applicant__c = c.Applicant__c;
                        // e.Principal_O_s__c=c.Current_Balance6__c;
                        objEld6.Start_On__c = c.Date_Opened6__c;
                        objEld6.Loan_Amount__c = c.Sanction_Amount6__c;
                        if (c.Date_Closed6__c != Null) daysclosed = c.Date_Closed6__c.daysbetween(system.today());
                        if (c.Date_Closed6__c == null || daysclosed <= 365 || (daysclosed > 365 && !CommonUtility.isEmpty(SecLoans) && SecLoans.contains(objEld6.Loan_Type__c))) eld.add(objEld6); //26861 changed if condition
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start
                        //Bug 23425
                        if(isPLBLRisk == false)
                            setisBLPLRiskFlag(daysclosed,c.Sanction_Amount6__c,c.Applicant__r.Loan_Application__r.Product__c,c.Account_Type6__c,mobValue,c.Applicant__c);
                    }
                    system.debug('objEld^^^^^^^^^^^^7');
                    if (c.Account_Type7__c != 'NO DATA' && c.Account_Type7__c != null && c.Account_Type7__c != '' && ((c.Ownership7__c == 'Individual') || (c.Ownership7__c == 'joint'))) {
                        Existing_Loan_Details__c objEld7 = new Existing_Loan_Details__c();
                        objEld7 = e.clone(false, true, false, false);
                        // e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
                        objEld7.Loan_Type__c = c.Account_Type7__c;
                        //e.Financer__c = '';
                        //e.Seen_in__c = 'CIBIL';
                        //e.Tenor__c=12;
                        if (objCibilExt != null) {
                            objEld7.Tenor__c =objCibilExt.Repayment_tenure7__c;
                            objEld7.EMI__c = objCibilExt.EMI7__c;
                        }
                        if (c.Current_Balance7__c > 0) objEld7.POS__c = c.Current_Balance7__c;
                        else objEld7.POS__c = 0;
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start added contain condition
                        if ((c.Applicant__r.Loan_Application__r.Product__c == 'SOL') || (eldProducts.contains(c.Applicant__r.Loan_Application__r.Product__c))){
                            if(System.Label.MobCalculation.equalsIgnoreCase('true'))
                            mobProd = c.Applicant__r.Loan_Application__r.Product__c;//844
                            assignELDMob(objEld7,c.Date_Opened7__c,c.Date_closed7__c);
                            /*if (c.Date_Opened7__c != null && c.Date_closed7__c == null) {
    
                                date a = system.today();
                                integer i = a.day();
                                integer j = c.Date_Opened7__c.day();
                                system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
                                if (i == j) objEld7.MOB__c = c.Date_Opened7__c.monthsbetween(system.today()) - 1;
                                else objEld7.MOB__c = c.Date_Opened7__c.monthsbetween(system.today()) - 2;
                                system.debug('c.Date_Opened7__c.monthsbetween(system.today())*************' + c.Date_Opened7__c.monthsbetween(system.today()) + 'ccccccccc' + c.Date_closed7__c);
    
    
                            } else if (c.Date_Opened7__c != null) objEld7.MOB__c = c.Date_Opened7__c.monthsbetween(c.Date_closed7__c);*/
                        }
                        objEld7.Ownership__c = c.Ownership7__c;
                        /*     if(c.Date_Closed7__c<=system.today())
                        {
                            e.Status__c='Closed';
                            e.Obligation__c='No';
                        }
                        else
                        {
                            e.Status__c='Live';
                            e.Obligation__c='Yes';
                        } */
                        
                        if (c.Date_Closed7__c != null) {
                            // if(c.Date_Closed7__c>=(system.today()-12)){
                            objEld7.Status__c = 'Closed';
                            objEld7.Obligation__c = 'No';
                            // }
                        } else {
                            objEld7.Status__c = 'Live';
                            objEld7.Obligation__c = 'Yes';
                        }
                        //e.Type_of_Oblig__c = 'Individual';
                        //e.Applicant__c = c.Applicant__c;
                        // e.Principal_O_s__c=c.Current_Balance7__c;
                        objEld7.Start_On__c = c.Date_Opened7__c;
                        objEld7.Loan_Amount__c = c.Sanction_Amount7__c;
                        if (c.Date_Closed7__c != Null) daysclosed = c.Date_Closed7__c.daysbetween(system.today());
                        if (c.Date_Closed7__c == null || daysclosed <= 365 || (daysclosed > 365 && !CommonUtility.isEmpty(SecLoans) && SecLoans.contains(objEld7.Loan_Type__c))) eld.add(objEld7); //26861 changed if condition
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start
                        //Bug 23425
                        if(isPLBLRisk == false)
                            setisBLPLRiskFlag(daysclosed,c.Sanction_Amount7__c,c.Applicant__r.Loan_Application__r.Product__c,c.Account_Type7__c,mobValue,c.Applicant__c);
                    }
                    system.debug('objEld^^^^^^^^^^^^8');
                    if (c.Account_Type8__c != 'NO DATA' && c.Account_Type8__c != null && c.Account_Type8__c != '' && ((c.Ownership8__c == 'Individual') || (c.Ownership8__c == 'joint'))) {
                        Existing_Loan_Details__c objEld8 = new Existing_Loan_Details__c();
                        objEld8 = e.clone(false, true, false, false);
                        // e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
                        objEld8.Loan_Type__c = c.Account_Type8__c;
                        //e.Financer__c = '';
                        //e.Seen_in__c = 'CIBIL';
                        // e.Tenor__c=12;
                        if (objCibilExt != null) {
                            objEld8.Tenor__c = objCibilExt.Repayment_tenure8__c;
                            objEld8.EMI__c = objCibilExt.EMI8__c;
                        }
                        if (c.Current_Balance8__c > 0) objEld8.POS__c = c.Current_Balance8__c;
                        else objEld8.POS__c = 0;
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start added contain condition
                        if ((c.Applicant__r.Loan_Application__r.Product__c == 'SOL') || (eldProducts.contains(c.Applicant__r.Loan_Application__r.Product__c))){
                            if(System.Label.MobCalculation.equalsIgnoreCase('true'))
                            mobProd = c.Applicant__r.Loan_Application__r.Product__c;//844
                            assignELDMob(objEld8,c.Date_Opened8__c,c.Date_closed8__c);
                            /*if (c.Date_Opened8__c != null && c.Date_closed8__c == null) {
    
                                date a = system.today();
                                integer i = a.day();
                                integer j = c.Date_Opened8__c.day();
                                system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
                                if (i == j) objEld8.MOB__c = c.Date_Opened8__c.monthsbetween(system.today()) - 1;
                                else objEld8.MOB__c = c.Date_Opened8__c.monthsbetween(system.today()) - 2;
                                system.debug('c.Date_Opened8__c.monthsbetween(system.today())*************' + c.Date_Opened8__c.monthsbetween(system.today()) + 'ccccccccc' + c.Date_closed8__c);
    
    
                            } else if (c.Date_Opened8__c != null) objEld8.MOB__c = c.Date_Opened8__c.monthsbetween(c.Date_closed8__c);*/
                        }
                        objEld8.Ownership__c = c.Ownership8__c;
                        /*     if(c.Date_Closed8__c<=system.today())
                        {
                            e.Status__c='Closed';
                            e.Obligation__c='No';
                        }
                        else
                        {
                            e.Status__c='Live';
                            e.Obligation__c='Yes';
                        }
                        */
                        if (c.Date_Closed8__c != null) {
                            // if(c.Date_Closed8__c>=(system.today()-12)){
                            objEld8.Status__c = 'Closed';
                            objEld8.Obligation__c = 'No';
                            // }
                        } else {
                            objEld8.Status__c = 'Live';
                            objEld8.Obligation__c = 'Yes';
                        }
                        //e.Type_of_Oblig__c = 'Individual';
                        //e.Applicant__c = c.Applicant__c;
                        // e.Principal_O_s__c=c.Current_Balance8__c;
                        objEld8.Start_On__c = c.Date_Opened8__c;
                        objEld8.Loan_Amount__c = c.Sanction_Amount8__c;
                        if (c.Date_Closed8__c != Null) daysclosed = c.Date_Closed8__c.daysbetween(system.today());
                        if (c.Date_Closed8__c == null || daysclosed <= 365 || (daysclosed > 365 && !CommonUtility.isEmpty(SecLoans) && SecLoans.contains(objEld8.Loan_Type__c))) eld.add(objEld8); //26861 changed if condition
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start
                        //Bug 23425
                        if(isPLBLRisk == false)
                            setisBLPLRiskFlag(daysclosed,c.Sanction_Amount8__c,c.Applicant__r.Loan_Application__r.Product__c,c.Account_Type8__c,mobValue,c.Applicant__c);
                    }
                    system.debug('objEld^^^^^^^^^^^^9');
                    if (c.Account_Type9__c != 'NO DATA' && c.Account_Type9__c != null && c.Account_Type9__c != '' && ((c.Ownership9__c == 'Individual') || (c.Ownership9__c == 'joint'))) {
                        Existing_Loan_Details__c objEld9 = new Existing_Loan_Details__c();
                        objEld9 = e.clone(false, true, false, false);
                        // e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
                        objEld9.Loan_Type__c = c.Account_Type9__c;
                        //e.Financer__c = '';
                        //e.Seen_in__c = 'CIBIL';
                        // e.Tenor__c=12;
                        if (objCibilExt != null) {
                            objEld9.Tenor__c =objCibilExt.Repayment_tenure9__c;
                            objEld9.EMI__c = objCibilExt.EMI9__c;
                        }
                        if (c.Current_Balance9__c > 0) objEld9.POS__c = c.Current_Balance9__c;
                        else objEld9.POS__c = 0;
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start added contain condition
                        if ((c.Applicant__r.Loan_Application__r.Product__c == 'SOL') || (eldProducts.contains(c.Applicant__r.Loan_Application__r.Product__c))){
                            if(System.Label.MobCalculation.equalsIgnoreCase('true'))
                            mobProd = c.Applicant__r.Loan_Application__r.Product__c;//844
                            assignELDMob(objEld9,c.Date_Opened9__c,c.Date_closed9__c);
                            /*if (c.Date_Opened9__c != null && c.Date_closed9__c == null) {
    
                                date a = system.today();
                                integer i = a.day();
                                integer j = c.Date_Opened9__c.day();
                                system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
                                if (i == j) objEld9.MOB__c = c.Date_Opened9__c.monthsbetween(system.today()) - 1;
                                else objEld9.MOB__c = c.Date_Opened9__c.monthsbetween(system.today()) - 2;
                                system.debug('c.Date_Opened9__c.monthsbetween(system.today())*************' + c.Date_Opened9__c.monthsbetween(system.today()) + 'ccccccccc' + c.Date_closed9__c);
    
    
                            } else if (c.Date_Opened9__c != null) objEld9.MOB__c = c.Date_Opened9__c.monthsbetween(c.Date_closed9__c);*/
                        }
                        objEld9.Ownership__c = c.Ownership9__c;
                        /*  if(c.Date_Closed9__c<=system.today())
                        {
                            e.Status__c='Closed';
                            e.Obligation__c='No';
                        }
                        else
                        {
                            e.Status__c='Live';
                            e.Obligation__c='Yes';
                        }
                        */
                        
                        if (c.Date_Closed9__c != null) {
                            //   if(c.Date_Closed9__c>=(system.today()-12)){
                            objEld9.Status__c = 'Closed';
                            objEld9.Obligation__c = 'No';
                            //  }
                        } else {
                            objEld9.Status__c = 'Live';
                            objEld9.Obligation__c = 'Yes';
                        }
                        //e.Type_of_Oblig__c = 'Individual';
                        //e.Applicant__c = c.Applicant__c;
                        // e.Principal_O_s__c=c.Current_Balance9__c;
                        objEld9.Start_On__c = c.Date_Opened9__c;
                        objEld9.Loan_Amount__c = c.Sanction_Amount9__c;
                        if (c.Date_Closed9__c != Null) daysclosed = c.Date_Closed9__c.daysbetween(system.today());
                        if (c.Date_Closed9__c == null || daysclosed <= 365 || (daysclosed > 365 && !CommonUtility.isEmpty(SecLoans) && SecLoans.contains(objEld9.Loan_Type__c))) eld.add(objEld9); //26861 changed if condition
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start
                        //Bug 23425
                        if(isPLBLRisk == false)
                            setisBLPLRiskFlag(daysclosed,c.Sanction_Amount9__c,c.Applicant__r.Loan_Application__r.Product__c,c.Account_Type9__c,mobValue,c.Applicant__c);
                    }
                    system.debug('objEld^^^^^^^^^^^^10');
                    if (c.Account_Type10__c != 'NO DATA' && c.Account_Type10__c != null && c.Account_Type10__c != '' && ((c.Ownership10__c == 'Individual') || (c.Ownership10__c == 'joint'))) {
                        Existing_Loan_Details__c objEld10 = new Existing_Loan_Details__c();
                        objEld10 = e.clone(false, true, false, false);
                        // e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
                        objEld10.Loan_Type__c = c.Account_Type10__c;
                        //e.Financer__c = '';
                        //e.Seen_in__c = 'CIBIL';
                        //e.Tenor__c=12;
                        if (objCibilExt != null) {
                            objEld10.Tenor__c = objCibilExt.Repayment_tenure10__c;
                            objEld10.EMI__c = objCibilExt.EMI10__c;
                        }
                        if (c.Current_Balance10__c > 0) objEld10.POS__c = c.Current_Balance10__c;
                        else objEld10.POS__c = 0;
                        //code added  Bug : 21238  ELDELDInsertAndMOBCalc start added contain condition
                        if( (c.Applicant__r.Loan_Application__r.Product__c == 'SOL') || (eldProducts.contains(c.Applicant__r.Loan_Application__r.Product__c))){
                            if(System.Label.MobCalculation.equalsIgnoreCase('true'))
                            mobProd = c.Applicant__r.Loan_Application__r.Product__c;//844
                            assignELDMob(objEld10,c.Date_Opened10__c,c.Date_closed10__c);
                            /*if (c.Date_Opened10__c != null && c.Date_closed10__c == null) {
    
                                date a = system.today();
                                integer i = a.day();
                                integer j = c.Date_Opened10__c.day();
                                system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
                                if (i == j) objEld10.MOB__c = c.Date_Opened10__c.monthsbetween(system.today()) - 1;
                                else objEld10.MOB__c = c.Date_Opened10__c.monthsbetween(system.today()) - 2;
                                system.debug('c.Date_Opened10__c.monthsbetween(system.today())*************' + c.Date_Opened10__c.monthsbetween(system.today()) + 'ccccccccc' + c.Date_closed10__c);
    
    
                            } else if (c.Date_Opened10__c != null) objEld10.MOB__c = c.Date_Opened10__c.monthsbetween(c.Date_closed10__c);*/
                        }
                        objEld10.Ownership__c = c.Ownership10__c;
                        /*     if(c.Date_Closed10__c<=system.today())
                        {
                            e.Status__c='Closed';
                            e.Obligation__c='No';
                        }
                        else
                        {
                            e.Status__c='Live';
                            e.Obligation__c='Yes';
                        } */
                        
                        if (c.Date_Closed10__c != null) {
                            //   if(c.Date_Closed10__c>=(system.today()-12)){
                            objEld10.Status__c = 'Closed';
                            objEld10.Obligation__c = 'No';
                            //   }
                        } else {
                            objEld10.Status__c = 'Live';
                            objEld10.Obligation__c = 'Yes';
                        }
                        //e.Type_of_Oblig__c = 'Individual';
                        //e.Applicant__c = c.Applicant__c;
                        // e.Principal_O_s__c=c.Current_Balance10__c;
                        objEld10.Start_On__c = c.Date_Opened10__c;
                        objEld10.Loan_Amount__c = c.Sanction_Amount10__c;
                        if (c.Date_Closed10__c != Null) daysclosed = c.Date_Closed10__c.daysbetween(system.today());
                        if (c.Date_Closed10__c == null || daysclosed <= 365 || (daysclosed > 365 && !CommonUtility.isEmpty(SecLoans) && SecLoans.contains(objEld10.Loan_Type__c))) eld.add(objEld10); //26861 changed if condition
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start
                        //Bug 23425
                        if(isPLBLRisk == false)
                            setisBLPLRiskFlag(daysclosed,c.Sanction_Amount10__c,c.Applicant__r.Loan_Application__r.Product__c,c.Account_Type10__c,mobValue,c.Applicant__c);
                    }
                    system.debug('objEld^^^^^^^^^^^^11');
                    if (c.Account_Type11__c != 'NO DATA' && c.Account_Type11__c != null && c.Account_Type11__c != '' && ((c.Ownership11__c == 'Individual') || (c.Ownership11__c == 'joint'))) {
                        Existing_Loan_Details__c objEld11 = new Existing_Loan_Details__c();
                        objEld11 = e.clone(false, true, false, false);
                        // e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
                        objEld11.Loan_Type__c = c.Account_Type11__c;
                        //e.Financer__c = '';
                        //e.Seen_in__c = 'CIBIL';
                        //e.Tenor__c=12;
                        if (objCibilExt != null) {
                            objEld11.Tenor__c = objCibilExt.Repayment_tenure11__c;
                            objEld11.EMI__c = objCibilExt.EMI11__c;
                        }
                        if (c.Current_Balance11__c > 0) objEld11.POS__c = c.Current_Balance11__c;
                        else objEld11.POS__c = 0;
                        //code added by Bug : 21238  ELDELDInsertAndMOBCalc start added contain condition
                        if ((c.Applicant__r.Loan_Application__r.Product__c == 'SOL') || (eldProducts.contains(c.Applicant__r.Loan_Application__r.Product__c))){
                            if(System.Label.MobCalculation.equalsIgnoreCase('true'))
                            mobProd = c.Applicant__r.Loan_Application__r.Product__c;//844
                            assignELDMob(objEld11,c.Date_Opened11__c,c.Date_closed11__c);
                            /*if (c.Date_Opened11__c != null && c.Date_closed11__c == null) {
    
                                date a = system.today();
                                integer i = a.day();
                                integer j = c.Date_Opened11__c.day();
                                system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
                                if (i == j) objEld11.MOB__c = c.Date_Opened11__c.monthsbetween(system.today()) - 1;
                                else objEld11.MOB__c = c.Date_Opened11__c.monthsbetween(system.today()) - 2;
                                system.debug('c.Date_Opened11__c.monthsbetween(system.today())*************' + c.Date_Opened11__c.monthsbetween(system.today()) + 'ccccccccc' + c.Date_closed11__c);
    
    
                            } else if (c.Date_Opened11__c != null) objEld11.MOB__c = c.Date_Opened11__c.monthsbetween(c.Date_closed11__c);*/
                        }
                        objEld11.Ownership__c = c.Ownership11__c;
                        /*     if(c.Date_Closed11__c<=system.today())
                        {
                            e.Status__c='Closed';
                            e.Obligation__c='No';
                        }
                        else
                        {
                            e.Status__c='Live';
                            e.Obligation__c='Yes';
                        } */
                        if (c.Date_Closed11__c != null) {
                            //   if(c.Date_Closed11__c>=(system.today()-12)){
                            objEld11.Status__c = 'Closed';
                            objEld11.Obligation__c = 'No';
                            //   }
                        } else {
                            objEld11.Status__c = 'Live';
                            objEld11.Obligation__c = 'Yes';
                        }
                        //e.Type_of_Oblig__c = 'Individual';
                        //e.Applicant__c = c.Applicant__c;
                        // e.Principal_O_s__c=c.Current_Balance11__c;
                        objEld11.Start_On__c = c.Date_Opened11__c;
                        objEld11.Loan_Amount__c = c.Sanction_Amount11__c;
                        if (c.Date_Closed11__c != Null) daysclosed = c.Date_Closed11__c.daysbetween(system.today());
                        if (c.Date_Closed11__c == null || daysclosed <= 365 || (daysclosed > 365 && !CommonUtility.isEmpty(SecLoans) && SecLoans.contains(objEld11.Loan_Type__c))) eld.add(objEld11); //26861 changed if condition
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start
                        //Bug 23425
                        if(isPLBLRisk == false)
                            setisBLPLRiskFlag(daysclosed,c.Sanction_Amount11__c,c.Applicant__r.Loan_Application__r.Product__c,c.Account_Type11__c,mobValue,c.Applicant__c);
                    }
                    system.debug('objEld^^^^^^^^^^^^12');
                    if (c.Account_Type12__c != 'NO DATA' && c.Account_Type12__c != null && c.Account_Type12__c != '' && ((c.Ownership12__c == 'Individual') || (c.Ownership12__c == 'joint'))) {
                        Existing_Loan_Details__c objEld12 = new Existing_Loan_Details__c();
                        objEld12 = e.clone(false, true, false, false);
                        // e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
                        objEld12.Loan_Type__c = c.Account_Type12__c;
                        //e.Financer__c = '';
                        //e.Seen_in__c = 'CIBIL';
                        //  e.Tenor__c=12;
                        if (objCibilExt != null) {
                            objEld12.Tenor__c = objCibilExt.Repayment_tenure12__c;
                            objEld12.EMI__c = objCibilExt.EMI12__c;
                        }
                        if (c.Current_Balance12__c > 0) objEld12.POS__c = c.Current_Balance12__c;
                        else objEld12.POS__c = 0;
                        //code added by Bug : 21238  ELDELDInsertAndMOBCalc start added contain condition
                        if ((c.Applicant__r.Loan_Application__r.Product__c == 'SOL') ||(eldProducts.contains(c.Applicant__r.Loan_Application__r.Product__c))){
                        if(System.Label.MobCalculation.equalsIgnoreCase('true'))
                            mobProd = c.Applicant__r.Loan_Application__r.Product__c;//844
                            assignELDMob(objEld12,c.Date_Opened12__c,c.Date_closed12__c);
                            /*if (c.Date_Opened12__c != null && c.Date_closed12__c == null)
    
                            {
    
                                date a = system.today();
                                integer i = a.day();
                                integer j = c.Date_Opened12__c.day();
                                system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
                                if (i == j) objEld12.MOB__c = c.Date_Opened12__c.monthsbetween(system.today()) - 1;
                                else objEld12.MOB__c = c.Date_Opened12__c.monthsbetween(system.today()) - 2;
                                system.debug('c.Date_Opened12__c.monthsbetween(system.today())*************' + c.Date_Opened12__c.monthsbetween(system.today()) + 'ccccccccc' + c.Date_closed12__c);
    
    
                            } else if (c.Date_Opened12__c != null) objEld12.MOB__c = c.Date_Opened12__c.monthsbetween(c.Date_closed12__c);*/
                        }
                        objEld12.Ownership__c = c.Ownership12__c;
                        /*    if(c.Date_Closed12__c<=system.today())
                        {
                            e.Status__c='Closed';
                            e.Obligation__c='No';
                        }
                        else
                        {
                            e.Status__c='Live';
                            e.Obligation__c='Yes';
                        }  */
                        
                        if (c.Date_Closed12__c != null) {
                            //  if(c.Date_Closed12__c>=(system.today()-12)){
                            objEld12.Status__c = 'Closed';
                            objEld12.Obligation__c = 'No';
                            //  }
                        } else {
                            objEld12.Status__c = 'Live';
                            objEld12.Obligation__c = 'Yes';
                        }
                        //e.Type_of_Oblig__c = 'Individual';
                        //e.Applicant__c = c.Applicant__c;
                        // e.Principal_O_s__c=c.Current_Balance12__c;
                        objEld12.Start_On__c = c.Date_Opened12__c;
                        objEld12.Loan_Amount__c = c.Sanction_Amount12__c;
                        if (c.Date_Closed12__c != Null) daysclosed = c.Date_Closed12__c.daysbetween(system.today());
                        if (c.Date_Closed12__c == null || daysclosed <= 365 || (daysclosed > 365 && !CommonUtility.isEmpty(SecLoans) && SecLoans.contains(objEld12.Loan_Type__c))) eld.add(objEld12); //26861 changed if condition
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start
                        //Bug 23425
                        if(isPLBLRisk == false)
                            setisBLPLRiskFlag(daysclosed,c.Sanction_Amount12__c,c.Applicant__r.Loan_Application__r.Product__c,c.Account_Type12__c,mobValue,c.Applicant__c);
                    }
                    system.debug('objEld^^^^^^^^^^^^13');
                    if (c.Account_Type13__c != 'NO DATA' && c.Account_Type13__c != null && c.Account_Type13__c != '' && ((c.Ownership13__c == 'Individual') || (c.Ownership13__c == 'joint'))) {
                        Existing_Loan_Details__c objEld13 = new Existing_Loan_Details__c();
                        objEld13 = e.clone(false, true, false, false);
                        // e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
                        objEld13.Loan_Type__c = c.Account_Type13__c;
                        //e.Financer__c = '';
                        //e.Seen_in__c = 'CIBIL';
                        // e.Tenor__c=12;
                        if (objCibilExt != null) {
                            objEld13.Tenor__c = objCibilExt.Repayment_tenure13__c;
                            objEld13.EMI__c = objCibilExt.EMI13__c;
                        }
                        if (c.Current_Balance13__c > 0) objEld13.POS__c = c.Current_Balance13__c;
                        else objEld13.POS__c = 0;
                        //code added by Bug : 21238  ELDELDInsertAndMOBCalc start added contain condition
                        if ((c.Applicant__r.Loan_Application__r.Product__c == 'SOL') ||(eldProducts.contains(c.Applicant__r.Loan_Application__r.Product__c))){
                          if(System.Label.MobCalculation.equalsIgnoreCase('true'))
                            mobProd = c.Applicant__r.Loan_Application__r.Product__c;//844
                            assignELDMob(objEld13,c.Date_Opened13__c,c.Date_closed13__c);
                            /*if (c.Date_Opened13__c != null && c.Date_closed13__c == null) {
    
                                date a = system.today();
                                integer i = a.day();
                                integer j = c.Date_Opened13__c.day();
                                system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
                                if (i == j) objEld13.MOB__c = c.Date_Opened13__c.monthsbetween(system.today()) - 1;
                                else objEld13.MOB__c = c.Date_Opened13__c.monthsbetween(system.today()) - 2;
                                system.debug('c.Date_Opened13__c.monthsbetween(system.today())*************' + c.Date_Opened13__c.monthsbetween(system.today()) + 'ccccccccc' + c.Date_closed13__c);
    
    
                            } else if (c.Date_Opened13__c != null) objEld13.MOB__c = c.Date_Opened13__c.monthsbetween(c.Date_closed13__c);*/
                        }
                        objEld13.Ownership__c = c.Ownership13__c;
                        /*   if(c.Date_Closed13__c<=system.today())
                        {
                            e.Status__c='Closed';
                            e.Obligation__c='No';
                        }
                        else
                        {
                            e.Status__c='Live';
                            e.Obligation__c='Yes';
                        }  */
                        if (c.Date_Closed13__c != null) {
                            //if(c.Date_Closed13__c>=(system.today()-12)){
                            objEld13.Status__c = 'Closed';
                            objEld13.Obligation__c = 'No';
                            // }
                        } else {
                            objEld13.Status__c = 'Live';
                            objEld13.Obligation__c = 'Yes';
                        }
                        //e.Type_of_Oblig__c = 'Individual';
                        //e.Applicant__c = c.Applicant__c;
                        // e.Principal_O_s__c=c.Current_Balance13__c;
                        objEld13.Start_On__c = c.Date_Opened13__c;
                        objEld13.Loan_Amount__c = c.Sanction_Amount13__c;
                        if (c.Date_Closed13__c != Null) daysclosed = c.Date_Closed13__c.daysbetween(system.today());
                        if (c.Date_Closed13__c == null || daysclosed <= 365 || (daysclosed > 365 && !CommonUtility.isEmpty(SecLoans) && SecLoans.contains(objEld13.Loan_Type__c))) eld.add(objEld13); //26861 changed if condition
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start
                        //Bug 23425
                        if(isPLBLRisk == false)
                            setisBLPLRiskFlag(daysclosed,c.Sanction_Amount13__c,c.Applicant__r.Loan_Application__r.Product__c,c.Account_Type13__c,mobValue,c.Applicant__c);
                    }
                    system.debug('objEld^^^^^^^^^^^^14');
                    if (c.Account_Type14__c != 'NO DATA' && c.Account_Type14__c != null && c.Account_Type14__c != '' && ((c.Ownership14__c == 'Individual') || (c.Ownership14__c == 'joint'))) {
                        Existing_Loan_Details__c objEld14 = new Existing_Loan_Details__c();
                        objEld14 = e.clone(false, true, false, false);
                        // e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
                        objEld14.Loan_Type__c = c.Account_Type14__c;
                        //e.Financer__c = '';
                        //e.Seen_in__c = 'CIBIL';
                        // e.Tenor__c=12;
                        if (objCibilExt != null) {
                            objEld14.Tenor__c = objCibilExt.Repayment_tenure14__c;
                            objEld14.EMI__c = objCibilExt.EMI14__c;
                        }
                        if (c.Current_Balance14__c > 0) objEld14.POS__c = c.Current_Balance14__c;
                        else objEld14.POS__c = 0;
                        //code added by Bug : 21238  ELDELDInsertAndMOBCalc start added contain condition
                        if ((c.Applicant__r.Loan_Application__r.Product__c == 'SOL')||(eldProducts.contains(c.Applicant__r.Loan_Application__r.Product__c))){
                            if(System.Label.MobCalculation.equalsIgnoreCase('true'))
                            mobProd = c.Applicant__r.Loan_Application__r.Product__c;//844
                            assignELDMob(objEld14,c.Date_Opened14__c,c.Date_closed14__c);
                            /*if (c.Date_Opened14__c != null && c.Date_closed14__c == null) {
    
                                date a = system.today();
                                integer i = a.day();
                                integer j = c.Date_Opened14__c.day();
                                system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
                                if (i == j) objEld14.MOB__c = c.Date_Opened14__c.monthsbetween(system.today()) - 1;
                                else objEld14.MOB__c = c.Date_Opened14__c.monthsbetween(system.today()) - 2;
                                system.debug('c.Date_Opened14__c.monthsbetween(system.today())*************' + c.Date_Opened14__c.monthsbetween(system.today()) + 'ccccccccc' + c.Date_closed14__c);
    
    
                            } else if (c.Date_Opened14__c != null) objEld14.MOB__c = c.Date_Opened14__c.monthsbetween(c.Date_closed14__c);*/
                        }
                        objEld14.Ownership__c = c.Ownership14__c;
                        /*     if(c.Date_Closed14__c<=system.today())
                        {
                            e.Status__c='Closed';
                            e.Obligation__c='No';
                        }
                        else
                        {
                            e.Status__c='Live';
                            e.Obligation__c='Yes';
                        } */
                        if (c.Date_Closed14__c != null) {
                            // if(c.Date_Closed14__c>=(system.today()-12)){
                            objEld14.Status__c = 'Closed';
                            objEld14.Obligation__c = 'No';
                            // }
                        } else {
                            objEld14.Status__c = 'Live';
                            objEld14.Obligation__c = 'Yes';
                        }
                        //e.Type_of_Oblig__c = 'Individual';
                        //e.Applicant__c = c.Applicant__c;
                        // e.Principal_O_s__c=c.Current_Balance14__c;
                        objEld14.Start_On__c = c.Date_Opened14__c;
                        objEld14.Loan_Amount__c = c.Sanction_Amount14__c;
                        if (c.Date_Closed14__c != Null) daysclosed = c.Date_Closed14__c.daysbetween(system.today());
                        if (c.Date_Closed14__c == null || daysclosed <= 365 || (daysclosed > 365 && !CommonUtility.isEmpty(SecLoans) && SecLoans.contains(objEld14.Loan_Type__c))) eld.add(objEld14); //26861 changed if condition
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start
                        //Bug 23425
                        if(isPLBLRisk == false)
                            setisBLPLRiskFlag(daysclosed,c.Sanction_Amount14__c,c.Applicant__r.Loan_Application__r.Product__c,c.Account_Type14__c,mobValue,c.Applicant__c);
                    }
                    system.debug('objEld^^^^^^^^^^^^15');
                    if (c.Account_Type15__c != 'NO DATA' && c.Account_Type15__c != null && c.Account_Type15__c != '' && ((c.Ownership15__c == 'Individual') || (c.Ownership15__c == 'joint'))) {
                        Existing_Loan_Details__c objEld15 = new Existing_Loan_Details__c();
                        objEld15 = e.clone(false, true, false, false);
                        // e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
                        objEld15.Loan_Type__c = c.Account_Type15__c;
                        //e.Financer__c = '';
                        //e.Seen_in__c = 'CIBIL';
                        // e.Tenor__c=12;
                        if (objCibilExt != null) {
                            objEld15.Tenor__c = objCibilExt.Repayment_tenure15__c;
                            objEld15.EMI__c = objCibilExt.EMI15__c;
                        }
                        if (c.Current_Balance15__c > 0) objEld15.POS__c = c.Current_Balance15__c;
                        else objEld15.POS__c = 0;
                        //code added by Bug : 21238  ELDELDInsertAndMOBCalc start added contain condition
                        if ((c.Applicant__r.Loan_Application__r.Product__c == 'SOL')||(eldProducts.contains(c.Applicant__r.Loan_Application__r.Product__c))){
                            if(System.Label.MobCalculation.equalsIgnoreCase('true'))
                            mobProd = c.Applicant__r.Loan_Application__r.Product__c;//844
                            assignELDMob(objEld15,c.Date_Opened15__c,c.Date_closed15__c);
                            /*if (c.Date_Opened15__c != null && c.Date_closed15__c == null) {
    
                                date a = system.today();
                                integer i = a.day();
                                integer j = c.Date_Opened15__c.day();
                                system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
                                if (i == j) objEld15.MOB__c = c.Date_Opened15__c.monthsbetween(system.today()) - 1;
                                else objEld15.MOB__c = c.Date_Opened15__c.monthsbetween(system.today()) - 2;
                                system.debug('c.Date_Opened15__c.monthsbetween(system.today())*************' + c.Date_Opened15__c.monthsbetween(system.today()) + 'ccccccccc' + c.Date_closed15__c);
    
    
                            } else if (c.Date_Opened15__c != null) objEld15.MOB__c = c.Date_Opened15__c.monthsbetween(c.Date_closed15__c);*/
                        }
                        objEld15.Ownership__c = c.Ownership15__c;
                        /*    if(c.Date_Closed15__c<=system.today())
                        {
                            e.Status__c='Closed';
                            e.Obligation__c='No';
                        }
                        else
                        {
                            e.Status__c='Live';
                            e.Obligation__c='Yes';
                        } */
                        if (c.Date_Closed15__c != null) {
                            //  if(c.Date_Closed15__c>=(system.today()-12)){
                            objEld15.Status__c = 'Closed';
                            objEld15.Obligation__c = 'No';
                            // }
                        } else {
                            objEld15.Status__c = 'Live';
                            objEld15.Obligation__c = 'Yes';
                        }
                        //e.Type_of_Oblig__c = 'Individual';
                        //e.Applicant__c = c.Applicant__c;
                        // e.Principal_O_s__c=c.Current_Balance15__c;
                        objEld15.Start_On__c = c.Date_Opened15__c;
                        objEld15.Loan_Amount__c = c.Sanction_Amount15__c;
                        if (c.Date_Closed15__c != Null) daysclosed = c.Date_Closed15__c.daysbetween(system.today());
                        if (c.Date_Closed15__c == null || daysclosed <= 365 || (daysclosed > 365 && !CommonUtility.isEmpty(SecLoans) && SecLoans.contains(objEld15.Loan_Type__c))) eld.add(objEld15); //26861 changed if condition
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start
                        //Bug 23425
                        if(isPLBLRisk == false)
                            setisBLPLRiskFlag(daysclosed,c.Sanction_Amount15__c,c.Applicant__r.Loan_Application__r.Product__c,c.Account_Type15__c,mobValue,c.Applicant__c);
                    }
                    system.debug('objEld^^^^^^^^^^^^16');
                    if (c.Account_Type16__c != 'NO DATA' && c.Account_Type16__c != null && c.Account_Type16__c != '' && ((c.Ownership16__c == 'Individual') || (c.Ownership16__c == 'joint'))) {
                        Existing_Loan_Details__c objEld16 = new Existing_Loan_Details__c();
                        objEld16 = e.clone(false, true, false, false);
                        // e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
                        objEld16.Loan_Type__c = c.Account_Type16__c;
                        //e.Financer__c = '';
                        //e.Seen_in__c = 'CIBIL';
                        //e.Tenor__c=12;               
                        if (objCibilExt != null) {
                            objEld16.Tenor__c = objCibilExt.Repayment_tenure16__c;
                            objEld16.EMI__c = objCibilExt.EMI16__c;
                        }
                        if (c.Current_Balance16__c > 0) objEld16.POS__c = c.Current_Balance16__c;
                        else objEld16.POS__c = 0;
                        //code added by Bug : 21238  ELDELDInsertAndMOBCalc start added contain condition
                        if ((c.Applicant__r.Loan_Application__r.Product__c == 'SOL')||(eldProducts.contains(c.Applicant__r.Loan_Application__r.Product__c))) {
                            if(System.Label.MobCalculation.equalsIgnoreCase('true'))
                            mobProd = c.Applicant__r.Loan_Application__r.Product__c;//844
                            assignELDMob(objEld16,c.Date_Opened16__c,c.Date_closed16__c);
                            /*if (c.Date_Opened16__c != null && c.Date_closed16__c == null) {
    
                                date a = system.today();
                                integer i = a.day();
                                integer j = c.Date_Opened16__c.day();
                                system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
                                if (i == j) objEld16.MOB__c = c.Date_Opened16__c.monthsbetween(system.today()) - 1;
                                else objEld16.MOB__c = c.Date_Opened16__c.monthsbetween(system.today()) - 2;
                                system.debug('c.Date_Opened16__c.monthsbetween(system.today())*************' + c.Date_Opened16__c.monthsbetween(system.today()) + 'ccccccccc' + c.Date_closed16__c);
    
    
                            } else if (c.Date_Opened16__c != null) objEld16.MOB__c = c.Date_Opened16__c.monthsbetween(c.Date_closed16__c);*/
                        }
                        objEld16.Ownership__c = c.Ownership16__c;
                        /*    if(c.Date_Closed16__c<=system.today())
                        {
                            e.Status__c='Closed';
                            e.Obligation__c='No';
                        }
                        else
                        {
                            e.Status__c='Live';
                            e.Obligation__c='Yes';
                        }  */
                        if (c.Date_Closed16__c != null) {
                            //  if(c.Date_Closed16__c>=(system.today()-12)){
                            objEld16.Status__c = 'Closed';
                            objEld16.Obligation__c = 'No';
                            //  }
                        } else {
                            objEld16.Status__c = 'Live';
                            objEld16.Obligation__c = 'Yes';
                        }
                        //e.Type_of_Oblig__c = 'Individual';
                        //e.Applicant__c = c.Applicant__c;
                        // e.Principal_O_s__c=c.Current_Balance16__c;
                        objEld16.Start_On__c = c.Date_Opened16__c;
                        objEld16.Loan_Amount__c = c.Sanction_Amount16__c;
                        if (c.Date_Closed16__c != Null) daysclosed = c.Date_Closed16__c.daysbetween(system.today());
                        if (c.Date_Closed16__c == null || daysclosed <= 365 || (daysclosed > 365 && !CommonUtility.isEmpty(SecLoans) && SecLoans.contains(objEld16.Loan_Type__c))) eld.add(objEld16); //26861 changed if condition
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start
                        //Bug 23425
                        if(isPLBLRisk == false)
                            setisBLPLRiskFlag(daysclosed,c.Sanction_Amount16__c,c.Applicant__r.Loan_Application__r.Product__c,c.Account_Type16__c,mobValue,c.Applicant__c);
                    }
                    system.debug('objEld^^^^^^^^^^^^17');
                    if (c.Account_Type17__c != 'NO DATA' && c.Account_Type17__c != null && c.Account_Type17__c != '' && ((c.Ownership17__c == 'Individual') || (c.Ownership17__c == 'joint'))) {
                        Existing_Loan_Details__c objEld17 = new Existing_Loan_Details__c();
                        objEld17 = e.clone(false, true, false, false);
                        // e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
                        objEld17.Loan_Type__c = c.Account_Type17__c;
                        //e.Financer__c = '';
                        //e.Seen_in__c = 'CIBIL';
                        //e.Tenor__c=12;
                        if (c.Current_Balance17__c > 0) objEld17.POS__c = c.Current_Balance17__c;
                        else objEld17.POS__c = 0;                
                        if (objCibilExt != null) {
                            objEld17.Tenor__c = objCibilExt.Repayment_tenure17__c;
                            objEld17.EMI__c = objCibilExt.EMI17__c;
                        }
                        //code added by Bug : 21238  ELDELDInsertAndMOBCalc start added contain condition
                        if ((c.Applicant__r.Loan_Application__r.Product__c == 'SOL')||(eldProducts.contains(c.Applicant__r.Loan_Application__r.Product__c))){
                            if(System.Label.MobCalculation.equalsIgnoreCase('true'))
                            mobProd = c.Applicant__r.Loan_Application__r.Product__c;//844
                            assignELDMob(objEld17,c.Date_Opened17__c,c.Date_closed17__c);
                            /*if (c.Date_Opened17__c != null && c.Date_closed17__c == null) {
    
                                date a = system.today();
                                integer i = a.day();
                                integer j = c.Date_Opened17__c.day();
                                system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
                                if (i == j) objEld17.MOB__c = c.Date_Opened17__c.monthsbetween(system.today()) - 1;
                                else objEld17.MOB__c = c.Date_Opened17__c.monthsbetween(system.today()) - 2;
                                system.debug('c.Date_Opened17__c.monthsbetween(system.today())*************' + c.Date_Opened17__c.monthsbetween(system.today()) + 'ccccccccc' + c.Date_closed17__c);
    
    
                            } else if (c.Date_Opened17__c != null) objEld17.MOB__c = c.Date_Opened17__c.monthsbetween(c.Date_closed17__c);*/
                        }
                        objEld17.Ownership__c = c.Ownership17__c;
                        /*   if(c.Date_Closed17__c<=system.today())
                        {
                            e.Status__c='Closed';
                            e.Obligation__c='No';
                        }
                        else{
                            e.Status__c='Live';
                            e.Obligation__c='Yes';
                        }  */
                        if (c.Date_Closed17__c != null) {
                            // if(c.Date_Closed17__c>=(system.today()-12)){
                            objEld17.Status__c = 'Closed';
                            objEld17.Obligation__c = 'No';
                            //  }
                        } else {
                            objEld17.Status__c = 'Live';
                            objEld17.Obligation__c = 'Yes';
                        }
                        //e.Type_of_Oblig__c = 'Individual';
                        //e.Applicant__c = c.Applicant__c;
                        // e.Principal_O_s__c=c.Current_Balance17__c;
                        objEld17.Start_On__c = c.Date_Opened17__c;
                        objEld17.Loan_Amount__c = c.Sanction_Amount17__c;
                        if (c.Date_Closed17__c != Null) daysclosed = c.Date_Closed17__c.daysbetween(system.today());
                        if (c.Date_Closed17__c == null || daysclosed <= 365 || (daysclosed > 365 && !CommonUtility.isEmpty(SecLoans) && SecLoans.contains(objEld17.Loan_Type__c))) eld.add(objEld17); //26861 changed if condition
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start
                        //Bug 23425
                        if(isPLBLRisk == false)
                            setisBLPLRiskFlag(daysclosed,c.Sanction_Amount17__c,c.Applicant__r.Loan_Application__r.Product__c,c.Account_Type17__c,mobValue,c.Applicant__c);
                    }
                    system.debug('objEld^^^^^^^^^^^^18');
                    if (c.Account_Type18__c != 'NO DATA' && c.Account_Type18__c != null && c.Account_Type18__c != '' && ((c.Ownership18__c == 'Individual') || (c.Ownership18__c == 'joint'))) {
                        Existing_Loan_Details__c objEld18 = new Existing_Loan_Details__c();
                        objEld18 = e.clone(false, true, false, false);
                        // e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
                        objEld18.Loan_Type__c = c.Account_Type18__c;
                        //e.Financer__c = '';
                        //e.Seen_in__c = 'CIBIL';
                        //e.Tenor__c=12;                
                        if (objCibilExt != null) {
                            objEld18.Tenor__c = objCibilExt.Repayment_tenure18__c;
                            objEld18.EMI__c = objCibilExt.EMI18__c;
                        }
                        if (c.Current_Balance18__c > 0) objEld18.POS__c = c.Current_Balance18__c;
                        else objEld18.POS__c = 0;
                        //code added by Bug : 21238  ELDELDInsertAndMOBCalc start added contain condition
                        if ((c.Applicant__r.Loan_Application__r.Product__c == 'SOL') || (eldProducts.contains(c.Applicant__r.Loan_Application__r.Product__c))){
                            if(System.Label.MobCalculation.equalsIgnoreCase('true'))
                            mobProd = c.Applicant__r.Loan_Application__r.Product__c;//844
                            assignELDMob(objEld18,c.Date_Opened18__c,c.Date_closed18__c);
                            /*if (c.Date_Opened18__c != null && c.Date_closed18__c == null) {
    
                                date a = system.today();
                                integer i = a.day();
                                integer j = c.Date_Opened18__c.day();
                                system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
                                if (i == j) objEld18.MOB__c = c.Date_Opened18__c.monthsbetween(system.today()) - 1;
                                else objEld18.MOB__c = c.Date_Opened18__c.monthsbetween(system.today()) - 2;
                                system.debug('c.Date_Opened18__c.monthsbetween(system.today())*************' + c.Date_Opened18__c.monthsbetween(system.today()) + 'ccccccccc' + c.Date_closed18__c);
    
    
                            } else if (c.Date_Opened18__c != null) objEld18.MOB__c = c.Date_Opened18__c.monthsbetween(c.Date_closed18__c);*/
                        }
                        objEld18.Ownership__c = c.Ownership18__c;
                        /*   if(c.Date_Closed18__c<=system.today())
                        {
                            e.Status__c='Closed';
                            e.Obligation__c='No';
                        }
                        else
                        {
                            e.Status__c='Live';
                            e.Obligation__c='Yes';
                        }  */
                        if (c.Date_Closed18__c != null) {
                            //  if(c.Date_Closed18__c>=(system.today()-12)){
                            objEld18.Status__c = 'Closed';
                            objEld18.Obligation__c = 'No';
                            // }
                        } else {
                            objEld18.Status__c = 'Live';
                            objEld18.Obligation__c = 'Yes';
                        }
                        //e.Type_of_Oblig__c = 'Individual';
                        //e.Applicant__c = c.Applicant__c;
                        // e.Principal_O_s__c=c.Current_Balance18__c;
                        objEld18.Start_On__c = c.Date_Opened18__c;
                        objEld18.Loan_Amount__c = c.Sanction_Amount18__c;
                        if (c.Date_Closed18__c != Null) daysclosed = c.Date_Closed18__c.daysbetween(system.today());
                        if (c.Date_Closed18__c == null || daysclosed <= 365 || (daysclosed > 365 && !CommonUtility.isEmpty(SecLoans) && SecLoans.contains(objEld18.Loan_Type__c))) eld.add(objEld18); //26861 changed if condition
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start
                        //Bug 23425
                        if(isPLBLRisk == false)
                            setisBLPLRiskFlag(daysclosed,c.Sanction_Amount18__c,c.Applicant__r.Loan_Application__r.Product__c,c.Account_Type18__c,mobValue,c.Applicant__c);
                    }
                    system.debug('objEld^^^^^^^^^^^^19');
                    if (c.Account_Type19__c != 'NO DATA' && c.Account_Type19__c != null && c.Account_Type19__c != '' && ((c.Ownership19__c == 'Individual') || (c.Ownership19__c == 'joint'))) {
                        Existing_Loan_Details__c objEld19 = new Existing_Loan_Details__c();
                        objEld19 = e.clone(false, true, false, false);
                        // e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
                        objEld19.Loan_Type__c = c.Account_Type19__c;
                        //e.Financer__c = '';
                        //e.Seen_in__c = 'CIBIL';
                        //e.Tenor__c=12;                
                        if (objCibilExt != null) {
                            objEld19.Tenor__c = objCibilExt.Repayment_tenure19__c;
                            objEld19.EMI__c = objCibilExt.EMI19__c;
                        }
                        if (c.Current_Balance19__c > 0) objEld19.POS__c = c.Current_Balance19__c;
                        else objEld19.POS__c = 0;
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start added contain condition
                        if ((c.Applicant__r.Loan_Application__r.Product__c == 'SOL') || (eldProducts.contains(c.Applicant__r.Loan_Application__r.Product__c))){
                            if(System.Label.MobCalculation.equalsIgnoreCase('true'))
                            mobProd = c.Applicant__r.Loan_Application__r.Product__c;//844
                            assignELDMob(objEld19,c.Date_Opened19__c,c.Date_closed19__c);
                            /*if (c.Date_Opened19__c != null && c.Date_closed19__c == null) {
    
                                date a = system.today();
                                integer i = a.day();
                                integer j = c.Date_Opened19__c.day();
                                system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
                                if (i == j) objEld19.MOB__c = c.Date_Opened19__c.monthsbetween(system.today()) - 1;
                                else objEld19.MOB__c = c.Date_Opened19__c.monthsbetween(system.today()) - 2;
                                system.debug('c.Date_Opened19__c.monthsbetween(system.today())*************' + c.Date_Opened19__c.monthsbetween(system.today()) + 'ccccccccc' + c.Date_closed19__c);
    
    
                            } else if (c.Date_Opened19__c != null) objEld19.MOB__c = c.Date_Opened19__c.monthsbetween(c.Date_closed19__c);*/
                        }
                        objEld19.Ownership__c = c.Ownership19__c;
                        /*      if(c.Date_Closed19__c<=system.today())
                        { 
                            e.Status__c='Closed';
                            e.Obligation__c='No';
                        }
                        else
                        {
                            e.Status__c='Live';
                            e.Obligation__c='Yes';
                        }  */
                        if (c.Date_Closed19__c != null) {
                            // if(c.Date_Closed19__c>=(system.today()-12)){
                            objEld19.Status__c = 'Closed';
                            objEld19.Obligation__c = 'No';
                            // }
                        } else {
                            objEld19.Status__c = 'Live';
                            objEld19.Obligation__c = 'Yes';
                        }
                        //e.Type_of_Oblig__c = 'Individual';
                        //e.Applicant__c = c.Applicant__c;
                        // e.Principal_O_s__c=c.Current_Balance19__c;
                        objEld19.Start_On__c = c.Date_Opened19__c;
                        objEld19.Loan_Amount__c = c.Sanction_Amount19__c;
                        if (c.Date_Closed19__c != Null) daysclosed = c.Date_Closed19__c.daysbetween(system.today());
                        if (c.Date_Closed19__c == null || daysclosed <= 365 || (daysclosed > 365 && !CommonUtility.isEmpty(SecLoans) && SecLoans.contains(objEld19.Loan_Type__c))) eld.add(objEld19); //26861 changed if condition
                        //code added Bug : 21238  ELDELDInsertAndMOBCalc start
                        //Bug 23425
                        if(isPLBLRisk == false)
                            setisBLPLRiskFlag(daysclosed,c.Sanction_Amount19__c,c.Applicant__r.Loan_Application__r.Product__c,c.Account_Type19__c,mobValue,c.Applicant__c);
                        
                    }
                }
                /**********OTP V2 Enhancement starts***************/
                for(integer k=20;k<=29;k++)  
                {
                    String Account_Type= 'Account_Type'+k+'__c';
                    String Ownership = 'Ownership'+k+'__c';
                    String Repayment_tenure = 'Repayment_tenure'+k+'__c';
                    String EMI = 'EMI'+k+'__c';
                    String Current_Balance = 'Current_Balance'+k+'__c';
                    String Date_Opened = 'Date_Opened'+k+'__c';
                    String Date_closed = 'Date_closed'+k+'__c';
                    String Sanction_Amount = 'Sanction_Amount'+k+'__c';
                    mobValue=0;
                    
                    if(c.CIBIL_Extension__c != null)
                    {
                        if (c.CIBIL_Extension__r.get(Account_Type) != 'NO DATA' && c.CIBIL_Extension__r.get(Account_Type) != null && c.CIBIL_Extension__r.get(Account_Type) != '' && ((c.CIBIL_Extension__r.get(Ownership) == 'Individual') || (c.CIBIL_Extension__r.get(Ownership) == 'joint'))) {
                            
                            Existing_Loan_Details__c objEldOTP= new Existing_Loan_Details__c();
                            //When cibil is done at Lead level then stamp Dummy Opp id to ELD
                            //added for 20311
                            
                            if(c.applicant__c != null && s.contains(string.valueOf(c.applicant__c).left(15).toUpperCase()) && isPro ){
                                objEldOTP.Loan_Application__c = Label.Dummy_Opportunity ;
                                objEldOTP.Applicant__c = c.applicant__c;
                            }else{
                                objEldOTP.Loan_Application__c = c.Applicant__r.Loan_Application__c; 
                                objEldOTP.Applicant__c = c.Applicant__c;
                            }               
                            
                            
                            if (objCibilExt != null) {
                                objEldOTP.Tenor__c = objCibilExt.Repayment_tenure__c;
                                objEldOTP.EMI__c = objCibilExt.EMI__c;
                            }
                            
                            //Stamp PO on ELD 
                            //added for 20311
                           
                            if(c.applicant__c != null &&s.contains(string.valueOf( c.applicant__c).left(15).toUpperCase()) && isPro && String.isNotEmpty(poToUpdate) )     
                            objEldOTP.Product_Offering__c = poToUpdate;
                            else if(mapOppIDAndPoID != null && mapOppIDAndPoID.containskey(c.Applicant__r.Loan_Application__c))              
                            objEldOTP.Product_Offering__c =mapOppIDAndPoID.get(c.Applicant__r.Loan_Application__c) ;
                          
                            system.debug('::mapOppIDAndPoIDs::'+mapOppIDAndPoID);
                            system.debug('::LonApp1::'+c.Applicant__r.Loan_Application__c);
                            system.debug('::poToUpdate1::'+ poToUpdate);
                            system.debug('::PRODOff1::'+ objEldOTP.Product_Offering__c);
                            system.debug('::Applicant::'+ objEldOTP.Applicant__c);
                            
                            
                            
                            
                            //Existing_Loan_Details__c e = new Existing_Loan_Details__c();
                            //e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
                            objEldOTP.Loan_Type__c =String.valueof( c.CIBIL_Extension__r.get(Account_Type));
                            objEldOTP.Financer__c = '';
                            objEldOTP.Seen_in__c = 'CIBIL';
                            //e.Tenor__c=12;
                            if (objCibilExt != null) {
                                objEldOTP.Tenor__c = Integer.valueof(objCibilExt.get(Repayment_tenure));
                                objEldOTP.EMI__c = Integer.valueof(objCibilExt.get(EMI));
                            }
                            if (Integer.valueof(c.CIBIL_Extension__r.get(Current_Balance)) > 0)
                            objEldOTP.POS__c = Integer.valueof(c.CIBIL_Extension__r.get(Current_Balance));
                            else
                            objEldOTP.POS__c = 0;
                            //code added Bug : 21238  ELDELDInsertAndMOBCalc start added contain condition
                            if ((c.Applicant__r.Loan_Application__r.Product__c == 'SOL')||(eldProducts.contains(c.Applicant__r.Loan_Application__r.Product__c))) {
                                if (c.CIBIL_Extension__r.get(Date_Opened) != null && c.CIBIL_Extension__r.get(Date_Closed) == null) {
                                    
                                    date a = system.today();
                                    integer i = a.day();
                                    integer j = Date.valueof(c.CIBIL_Extension__r.get(Date_Opened)).day();
                                    system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
                                    if (i == j)
                                    objEldOTP.MOB__c =  Date.valueof(c.CIBIL_Extension__r.get(Date_Opened)).monthsbetween(system.today()) - 1;
                                    else
                                    objEldOTP.MOB__c =  Date.valueof(c.CIBIL_Extension__r.get(Date_Opened)).monthsbetween(system.today()) - 2;
                                    system.debug('c.CIBIL_Extension__r.get(Date_Opened).monthsbetween(system.today())*************' +  Date.valueof(c.CIBIL_Extension__r.get(Date_Opened)).monthsbetween(system.today()) + 'ccccccccc' +  Date.valueof(c.CIBIL_Extension__r.get(Date_Closed)));
                                    
                                    
                                } else if ( Date.valueof(c.CIBIL_Extension__r.get(Date_Opened)) != null)
                                objEldOTP.MOB__c =  Date.valueof(c.CIBIL_Extension__r.get(Date_Opened)).monthsbetween( Date.valueof(c.CIBIL_Extension__r.get(Date_Closed)));
                            }
                            //code added Bug : 21238  ELDELDInsertAndMOBCalc start 
                            mobValue=objEldOTP.MOB__c;
                            //code added Bug : 21238  ELDELDInsertAndMOBCalc end
                            objEldOTP.Ownership__c =  String.valueof(c.CIBIL_Extension__r.get(Ownership));
                            
                            if ( Date.valueof(c.CIBIL_Extension__r.get(Date_Closed)) != null) {
                                objEldOTP.Status__c = 'Closed';
                                objEldOTP.Obligation__c = 'No';
                                
                            } else {
                                objEldOTP.Status__c = 'Live';
                                objEldOTP.Obligation__c = 'Yes';
                            }
                            objEldOTP.Type_of_Oblig__c = 'Individual';
                            objEldOTP.Applicant__c = c.Applicant__c;
                            // e.Principal_O_s__c=c.CIBIL_Extension__r.get(Current_Balance);
                            objEldOTP.Start_On__c =  Date.valueof(c.CIBIL_Extension__r.get(Date_Opened));
                            objEldOTP.Loan_Amount__c =  Integer.valueof(c.CIBIL_Extension__r.get(Sanction_Amount));
                            if ( Date.valueof(c.CIBIL_Extension__r.get(Date_Closed)) != Null)
                            daysclosed =  Date.valueof(c.CIBIL_Extension__r.get(Date_Closed)).daysbetween(system.today());
                            if ( Date.valueof(c.CIBIL_Extension__r.get(Date_Closed)) == null || daysclosed <= 365 || (daysclosed > 365 && !CommonUtility.isEmpty(SecLoans) && SecLoans.contains(objEldOTP.Loan_Type__c))) //26861 changed if condition
                            eld.add(objEldOTP);
                            //code added Bug : 21238  ELDELDInsertAndMOBCalc start
                            //Bug 23425
                            if(isPLBLRisk == false)
                                setisBLPLRiskFlag(daysclosed,Integer.valueof(c.CIBIL_Extension__r.get(Sanction_Amount)),c.Applicant__r.Loan_Application__r.Product__c,String.valueof(c.CIBIL_Extension__r.get(Account_Type)),mobValue,c.Applicant__c);
                            
                        }
                    }
                }
                //Please add below fields in soql1 query
                /*   if (c.CIBIL_Extension__r.Account_Type20__c != 'NO DATA' && c.CIBIL_Extension__r.Account_Type20__c != null && c.CIBIL_Extension__r.Account_Type20__c != '' && ((c.CIBIL_Extension__r.Ownership20__c == 'Individual') || (c.CIBIL_Extension__r.Ownership20__c == 'joint'))) {
            Existing_Loan_Details__c e = new Existing_Loan_Details__c();
            e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
            e.Loan_Type__c = c.CIBIL_Extension__r.Account_Type20__c;
            e.Financer__c = '';
            e.Seen_in__c = 'CIBIL';
            //e.Tenor__c=12;
            if (cexlist.size() > 0) {
            e.Tenor__c = cexlist[0].Repayment_tenure20__c;
            e.EMI__c = cexlist[0].EMI20__c;
            }
            if (c.CIBIL_Extension__r.Current_Balance20__c > 0)
            e.POS__c = c.CIBIL_Extension__r.Current_Balance20__c;
            else
            e.POS__c = 0;
            if (c.Applicant__r.Loan_Application__r.Product__c == 'SOL') {
            if (c.CIBIL_Extension__r.Date_Opened20__c != null && c.CIBIL_Extension__r.Date_closed20__c == null) {

            date a = system.today();
            integer i = a.day();
            integer j = c.CIBIL_Extension__r.Date_Opened20__c.day();
            system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
            if (i == j)
                e.MOB__c = c.CIBIL_Extension__r.Date_Opened20__c.monthsbetween(system.today()) - 1;
            else
                e.MOB__c = c.CIBIL_Extension__r.Date_Opened20__c.monthsbetween(system.today()) - 2;
            system.debug('c.CIBIL_Extension__r.Date_Opened20__c.monthsbetween(system.today())*************' + c.CIBIL_Extension__r.Date_Opened20__c.monthsbetween(system.today()) + 'ccccccccc' + c.CIBIL_Extension__r.Date_closed20__c);


            } else if (c.CIBIL_Extension__r.Date_Opened20__c != null)
            e.MOB__c = c.CIBIL_Extension__r.Date_Opened20__c.monthsbetween(c.CIBIL_Extension__r.Date_closed20__c);
            }
            e.Ownership__c = c.CIBIL_Extension__r.Ownership20__c;

            if (c.CIBIL_Extension__r.Date_Closed20__c != null) {
            e.Status__c = 'Closed';
            e.Obligation__c = 'No';

            } else {
            e.Status__c = 'Live';
            e.Obligation__c = 'Yes';
            }
            e.Type_of_Oblig__c = 'Individual';
            e.Applicant__c = c.Applicant__c;
            // e.Principal_O_s__c=c.CIBIL_Extension__r.Current_Balance20__c;
            e.Start_On__c = c.CIBIL_Extension__r.Date_Opened20__c;
            e.Loan_Amount__c = c.CIBIL_Extension__r.Sanction_Amount20__c;
            if (c.CIBIL_Extension__r.Date_Closed20__c != Null)
            daysclosed = c.CIBIL_Extension__r.Date_Closed20__c.daysbetween(system.today());
            if (c.CIBIL_Extension__r.Date_Closed20__c == null || daysclosed <= 365)
            eld.add(e);
            }
            if (c.CIBIL_Extension__r.Account_Type21__c != 'NO DATA' && c.CIBIL_Extension__r.Account_Type21__c != null && c.CIBIL_Extension__r.Account_Type21__c != '' && ((c.CIBIL_Extension__r.Ownership21__c == 'Individual') || (c.CIBIL_Extension__r.Ownership21__c == 'joint'))) {
            Existing_Loan_Details__c e = new Existing_Loan_Details__c();
            e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
            e.Loan_Type__c = c.CIBIL_Extension__r.Account_Type21__c;
            e.Financer__c = '';
            e.Seen_in__c = 'CIBIL';
            //e.Tenor__c=12;
            if (cexlist.size() > 0) {
            e.Tenor__c = cexlist[0].Repayment_tenure21__c;
            e.EMI__c = cexlist[0].EMI21__c;
            }
            if (c.CIBIL_Extension__r.Current_Balance21__c > 0)
            e.POS__c = c.CIBIL_Extension__r.Current_Balance21__c;
            else
            e.POS__c = 0;
            if (c.Applicant__r.Loan_Application__r.Product__c == 'SOL') {
            if (c.CIBIL_Extension__r.Date_Opened21__c != null && c.CIBIL_Extension__r.Date_closed21__c == null) {

            date a = system.today();
            integer i = a.day();
            integer j = c.CIBIL_Extension__r.Date_Opened21__c.day();
            system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
            if (i == j)
                e.MOB__c = c.CIBIL_Extension__r.Date_Opened21__c.monthsbetween(system.today()) - 1;
            else
                e.MOB__c = c.CIBIL_Extension__r.Date_Opened21__c.monthsbetween(system.today()) - 2;
            system.debug('c.CIBIL_Extension__r.Date_Opened21__c.monthsbetween(system.today())*************' + c.CIBIL_Extension__r.Date_Opened21__c.monthsbetween(system.today()) + 'ccccccccc' + c.CIBIL_Extension__r.Date_closed21__c);


            } else if (c.CIBIL_Extension__r.Date_Opened21__c != null)
            e.MOB__c = c.CIBIL_Extension__r.Date_Opened21__c.monthsbetween(c.CIBIL_Extension__r.Date_closed21__c);
            }
            e.Ownership__c = c.CIBIL_Extension__r.Ownership21__c;

            if (c.CIBIL_Extension__r.Date_Closed21__c != null) {
            // if(c.CIBIL_Extension__r.Date_Closed21__c>=(system.today()-12)){
            e.Status__c = 'Closed';
            e.Obligation__c = 'No';
            // }
            } else {
            e.Status__c = 'Live';
            e.Obligation__c = 'Yes';
            }
            e.Type_of_Oblig__c = 'Individual';
            e.Applicant__c = c.Applicant__c;
            // e.Principal_O_s__c=c.CIBIL_Extension__r.Current_Balance21__c;
            e.Start_On__c = c.CIBIL_Extension__r.Date_Opened21__c;
            e.Loan_Amount__c = c.CIBIL_Extension__r.Sanction_Amount21__c;
            if (c.CIBIL_Extension__r.Date_Closed21__c != Null)
            daysclosed = c.CIBIL_Extension__r.Date_Closed21__c.daysbetween(system.today());
            if (c.CIBIL_Extension__r.Date_Closed21__c == null || daysclosed <= 365)
            eld.add(e);
            }

            if (c.CIBIL_Extension__r.Account_Type22__c != 'NO DATA' && c.CIBIL_Extension__r.Account_Type22__c != null && c.CIBIL_Extension__r.Account_Type22__c != '' && ((c.CIBIL_Extension__r.Ownership22__c == 'Individual') || (c.CIBIL_Extension__r.Ownership22__c == 'joint'))) {
            Existing_Loan_Details__c e = new Existing_Loan_Details__c();
            e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
            e.Loan_Type__c = c.CIBIL_Extension__r.Account_Type22__c;
            e.Financer__c = '';
            e.Seen_in__c = 'CIBIL';
            //e.Tenor__c=12;
            if (cexlist.size() > 0) {
            e.Tenor__c = cexlist[0].Repayment_tenure22__c;
            e.EMI__c = cexlist[0].EMI22__c;
            }
            if (c.CIBIL_Extension__r.Current_Balance22__c > 0)
            e.POS__c = c.CIBIL_Extension__r.Current_Balance22__c;
            else
            e.POS__c = 0;
            if (c.Applicant__r.Loan_Application__r.Product__c == 'SOL') {
            if (c.CIBIL_Extension__r.Date_Opened22__c != null && c.CIBIL_Extension__r.Date_closed22__c == null) {

            date a = system.today();
            integer i = a.day();
            integer j = c.CIBIL_Extension__r.Date_Opened22__c.day();
            system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
            if (i == j)
                e.MOB__c = c.CIBIL_Extension__r.Date_Opened22__c.monthsbetween(system.today()) - 1;
            else
                e.MOB__c = c.CIBIL_Extension__r.Date_Opened22__c.monthsbetween(system.today()) - 2;
            system.debug('c.CIBIL_Extension__r.Date_Opened22__c.monthsbetween(system.today())*************' + c.CIBIL_Extension__r.Date_Opened22__c.monthsbetween(system.today()) + 'ccccccccc' + c.CIBIL_Extension__r.Date_closed22__c);


            } else if (c.CIBIL_Extension__r.Date_Opened22__c != null)
            e.MOB__c = c.CIBIL_Extension__r.Date_Opened22__c.monthsbetween(c.CIBIL_Extension__r.Date_closed22__c);
            }
            e.Ownership__c = c.CIBIL_Extension__r.Ownership22__c;

            if (c.CIBIL_Extension__r.Date_Closed22__c != null) {
            // if(c.CIBIL_Extension__r.Date_Closed22__c>=(system.today()-12)){
            e.Status__c = 'Closed';
            e.Obligation__c = 'No';
            // }
            } else {
            e.Status__c = 'Live';
            e.Obligation__c = 'Yes';
            }
            e.Type_of_Oblig__c = 'Individual';
            e.Applicant__c = c.Applicant__c;
            // e.Principal_O_s__c=c.CIBIL_Extension__r.Current_Balance22__c;
            e.Start_On__c = c.CIBIL_Extension__r.Date_Opened22__c;
            e.Loan_Amount__c = c.CIBIL_Extension__r.Sanction_Amount22__c;
            if (c.CIBIL_Extension__r.Date_Closed22__c != Null)
            daysclosed = c.CIBIL_Extension__r.Date_Closed22__c.daysbetween(system.today());
            if (c.CIBIL_Extension__r.Date_Closed22__c == null || daysclosed <= 365)
            eld.add(e);
            }

            if (c.CIBIL_Extension__r.Account_Type23__c != 'NO DATA' && c.CIBIL_Extension__r.Account_Type23__c != null && c.CIBIL_Extension__r.Account_Type23__c != '' && ((c.CIBIL_Extension__r.Ownership23__c == 'Individual') || (c.CIBIL_Extension__r.Ownership23__c == 'joint'))) {
            Existing_Loan_Details__c e = new Existing_Loan_Details__c();
            e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
            e.Loan_Type__c = c.CIBIL_Extension__r.Account_Type23__c;
            e.Financer__c = '';
            e.Seen_in__c = 'CIBIL';
            //e.Tenor__c=12;
            if (cexlist.size() > 0) {
            e.Tenor__c = cexlist[0].Repayment_tenure23__c;
            e.EMI__c = cexlist[0].EMI23__c;
            }
            if (c.CIBIL_Extension__r.Current_Balance23__c > 0)
            e.POS__c = c.CIBIL_Extension__r.Current_Balance23__c;
            else
            e.POS__c = 0;
            if (c.Applicant__r.Loan_Application__r.Product__c == 'SOL') {
            if (c.CIBIL_Extension__r.Date_Opened23__c != null && c.CIBIL_Extension__r.Date_closed23__c == null) {

            date a = system.today();
            integer i = a.day();
            integer j = c.CIBIL_Extension__r.Date_Opened23__c.day();
            system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
            if (i == j)
                e.MOB__c = c.CIBIL_Extension__r.Date_Opened23__c.monthsbetween(system.today()) - 1;
            else
                e.MOB__c = c.CIBIL_Extension__r.Date_Opened23__c.monthsbetween(system.today()) - 2;
            system.debug('c.CIBIL_Extension__r.Date_Opened23__c.monthsbetween(system.today())*************' + c.CIBIL_Extension__r.Date_Opened23__c.monthsbetween(system.today()) + 'ccccccccc' + c.CIBIL_Extension__r.Date_closed23__c);


            } else if (c.CIBIL_Extension__r.Date_Opened23__c != null)
            e.MOB__c = c.CIBIL_Extension__r.Date_Opened23__c.monthsbetween(c.CIBIL_Extension__r.Date_closed23__c);
            }
            e.Ownership__c = c.CIBIL_Extension__r.Ownership23__c;

            if (c.CIBIL_Extension__r.Date_Closed23__c != null) {
            // if(c.CIBIL_Extension__r.Date_Closed23__c>=(system.today()-12)){
            e.Status__c = 'Closed';
            e.Obligation__c = 'No';
            // }
            } else {
            e.Status__c = 'Live';
            e.Obligation__c = 'Yes';
            }
            e.Type_of_Oblig__c = 'Individual';
            e.Applicant__c = c.Applicant__c;
            // e.Principal_O_s__c=c.CIBIL_Extension__r.Current_Balance23__c;
            e.Start_On__c = c.CIBIL_Extension__r.Date_Opened23__c;
            e.Loan_Amount__c = c.CIBIL_Extension__r.Sanction_Amount23__c;
            if (c.CIBIL_Extension__r.Date_Closed23__c != Null)
            daysclosed = c.CIBIL_Extension__r.Date_Closed23__c.daysbetween(system.today());
            if (c.CIBIL_Extension__r.Date_Closed23__c == null || daysclosed <= 365)
            eld.add(e);
            }

            if (c.CIBIL_Extension__r.Account_Type24__c != 'NO DATA' && c.CIBIL_Extension__r.Account_Type24__c != null && c.CIBIL_Extension__r.Account_Type24__c != '' && ((c.CIBIL_Extension__r.Ownership24__c == 'Individual') || (c.CIBIL_Extension__r.Ownership24__c == 'joint'))) {
            Existing_Loan_Details__c e = new Existing_Loan_Details__c();
            e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
            e.Loan_Type__c = c.CIBIL_Extension__r.Account_Type24__c;
            e.Financer__c = '';
            e.Seen_in__c = 'CIBIL';
            //e.Tenor__c=12;
            if (cexlist.size() > 0) {
            e.Tenor__c = cexlist[0].Repayment_tenure24__c;
            e.EMI__c = cexlist[0].EMI24__c;
            }
            if (c.CIBIL_Extension__r.Current_Balance24__c > 0)
            e.POS__c = c.CIBIL_Extension__r.Current_Balance24__c;
            else
            e.POS__c = 0;
            if (c.Applicant__r.Loan_Application__r.Product__c == 'SOL') {
            if (c.CIBIL_Extension__r.Date_Opened24__c != null && c.CIBIL_Extension__r.Date_closed24__c == null) {

            date a = system.today();
            integer i = a.day();
            integer j = c.CIBIL_Extension__r.Date_Opened24__c.day();
            system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
            if (i == j)
                e.MOB__c = c.CIBIL_Extension__r.Date_Opened24__c.monthsbetween(system.today()) - 1;
            else
                e.MOB__c = c.CIBIL_Extension__r.Date_Opened24__c.monthsbetween(system.today()) - 2;
            system.debug('c.CIBIL_Extension__r.Date_Opened24__c.monthsbetween(system.today())*************' + c.CIBIL_Extension__r.Date_Opened24__c.monthsbetween(system.today()) + 'ccccccccc' + c.CIBIL_Extension__r.Date_closed24__c);


            } else if (c.CIBIL_Extension__r.Date_Opened24__c != null)
            e.MOB__c = c.CIBIL_Extension__r.Date_Opened24__c.monthsbetween(c.CIBIL_Extension__r.Date_closed24__c);
            }
            e.Ownership__c = c.CIBIL_Extension__r.Ownership24__c;

            if (c.CIBIL_Extension__r.Date_Closed24__c != null) {
            // if(c.CIBIL_Extension__r.Date_Closed24__c>=(system.today()-12)){
            e.Status__c = 'Closed';
            e.Obligation__c = 'No';
            // }
            } else {
            e.Status__c = 'Live';
            e.Obligation__c = 'Yes';
            }
            e.Type_of_Oblig__c = 'Individual';
            e.Applicant__c = c.Applicant__c;
            // e.Principal_O_s__c=c.CIBIL_Extension__r.Current_Balance24__c;
            e.Start_On__c = c.CIBIL_Extension__r.Date_Opened24__c;
            e.Loan_Amount__c = c.CIBIL_Extension__r.Sanction_Amount24__c;
            if (c.CIBIL_Extension__r.Date_Closed24__c != Null)
            daysclosed = c.CIBIL_Extension__r.Date_Closed24__c.daysbetween(system.today());
            if (c.CIBIL_Extension__r.Date_Closed24__c == null || daysclosed <= 365)
            eld.add(e);
            }

            if (c.CIBIL_Extension__r.Account_Type25__c != 'NO DATA' && c.CIBIL_Extension__r.Account_Type25__c != null && c.CIBIL_Extension__r.Account_Type25__c != '' && ((c.CIBIL_Extension__r.Ownership25__c == 'Individual') || (c.CIBIL_Extension__r.Ownership25__c == 'joint'))) {
            Existing_Loan_Details__c e = new Existing_Loan_Details__c();
            e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
            e.Loan_Type__c = c.CIBIL_Extension__r.Account_Type25__c;
            e.Financer__c = '';
            e.Seen_in__c = 'CIBIL';
            //e.Tenor__c=12;
            if (cexlist.size() > 0) {
            e.Tenor__c = cexlist[0].Repayment_tenure25__c;
            e.EMI__c = cexlist[0].EMI25__c;
            }
            if (c.CIBIL_Extension__r.Current_Balance25__c > 0)
            e.POS__c = c.CIBIL_Extension__r.Current_Balance25__c;
            else
            e.POS__c = 0;
            if (c.Applicant__r.Loan_Application__r.Product__c == 'SOL') {
            if (c.CIBIL_Extension__r.Date_Opened25__c != null && c.CIBIL_Extension__r.Date_closed25__c == null) {

            date a = system.today();
            integer i = a.day();
            integer j = c.CIBIL_Extension__r.Date_Opened25__c.day();
            system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
            if (i == j)
                e.MOB__c = c.CIBIL_Extension__r.Date_Opened25__c.monthsbetween(system.today()) - 1;
            else
                e.MOB__c = c.CIBIL_Extension__r.Date_Opened25__c.monthsbetween(system.today()) - 2;
            system.debug('c.CIBIL_Extension__r.Date_Opened25__c.monthsbetween(system.today())*************' + c.CIBIL_Extension__r.Date_Opened25__c.monthsbetween(system.today()) + 'ccccccccc' + c.CIBIL_Extension__r.Date_closed25__c);


            } else if (c.CIBIL_Extension__r.Date_Opened25__c != null)
            e.MOB__c = c.CIBIL_Extension__r.Date_Opened25__c.monthsbetween(c.CIBIL_Extension__r.Date_closed25__c);
            }
            e.Ownership__c = c.CIBIL_Extension__r.Ownership25__c;

            if (c.CIBIL_Extension__r.Date_Closed25__c != null) {
            // if(c.CIBIL_Extension__r.Date_Closed25__c>=(system.today()-12)){
            e.Status__c = 'Closed';
            e.Obligation__c = 'No';
            // }
            } else {
            e.Status__c = 'Live';
            e.Obligation__c = 'Yes';
            }
            e.Type_of_Oblig__c = 'Individual';
            e.Applicant__c = c.Applicant__c;
            // e.Principal_O_s__c=c.CIBIL_Extension__r.Current_Balance25__c;
            e.Start_On__c = c.CIBIL_Extension__r.Date_Opened25__c;
            e.Loan_Amount__c = c.CIBIL_Extension__r.Sanction_Amount25__c;
            if (c.CIBIL_Extension__r.Date_Closed25__c != Null)
            daysclosed = c.CIBIL_Extension__r.Date_Closed25__c.daysbetween(system.today());
            if (c.CIBIL_Extension__r.Date_Closed25__c == null || daysclosed <= 365)
            eld.add(e);
            }
            if (c.CIBIL_Extension__r.Account_Type26__c != 'NO DATA' && c.CIBIL_Extension__r.Account_Type26__c != null && c.CIBIL_Extension__r.Account_Type26__c != '' && ((c.CIBIL_Extension__r.Ownership26__c == 'Individual') || (c.CIBIL_Extension__r.Ownership26__c == 'joint'))) {
            Existing_Loan_Details__c e = new Existing_Loan_Details__c();
            e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
            e.Loan_Type__c = c.CIBIL_Extension__r.Account_Type26__c;
            e.Financer__c = '';
            e.Seen_in__c = 'CIBIL';
            //e.Tenor__c=12;
            if (cexlist.size() > 0) {
            e.Tenor__c = cexlist[0].Repayment_tenure26__c;
            e.EMI__c = cexlist[0].EMI26__c;
            }
            if (c.CIBIL_Extension__r.Current_Balance26__c > 0)
            e.POS__c = c.CIBIL_Extension__r.Current_Balance26__c;
            else
            e.POS__c = 0;
            if (c.Applicant__r.Loan_Application__r.Product__c == 'SOL') {
            if (c.CIBIL_Extension__r.Date_Opened26__c != null && c.CIBIL_Extension__r.Date_closed26__c == null) {

            date a = system.today();
            integer i = a.day();
            integer j = c.CIBIL_Extension__r.Date_Opened26__c.day();
            system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
            if (i == j)
                e.MOB__c = c.CIBIL_Extension__r.Date_Opened26__c.monthsbetween(system.today()) - 1;
            else
                e.MOB__c = c.CIBIL_Extension__r.Date_Opened26__c.monthsbetween(system.today()) - 2;
            system.debug('c.CIBIL_Extension__r.Date_Opened26__c.monthsbetween(system.today())*************' + c.CIBIL_Extension__r.Date_Opened26__c.monthsbetween(system.today()) + 'ccccccccc' + c.CIBIL_Extension__r.Date_closed26__c);


            } else if (c.CIBIL_Extension__r.Date_Opened26__c != null)
            e.MOB__c = c.CIBIL_Extension__r.Date_Opened26__c.monthsbetween(c.CIBIL_Extension__r.Date_closed26__c);
            }
            e.Ownership__c = c.CIBIL_Extension__r.Ownership26__c;

            if (c.CIBIL_Extension__r.Date_Closed26__c != null) {
            // if(c.CIBIL_Extension__r.Date_Closed26__c>=(system.today()-12)){
            e.Status__c = 'Closed';
            e.Obligation__c = 'No';
            // }
            } else {
            e.Status__c = 'Live';
            e.Obligation__c = 'Yes';
            }
            e.Type_of_Oblig__c = 'Individual';
            e.Applicant__c = c.Applicant__c;
            // e.Principal_O_s__c=c.CIBIL_Extension__r.Current_Balance26__c;
            e.Start_On__c = c.CIBIL_Extension__r.Date_Opened26__c;
            e.Loan_Amount__c = c.CIBIL_Extension__r.Sanction_Amount26__c;
            if (c.CIBIL_Extension__r.Date_Closed26__c != Null)
            daysclosed = c.CIBIL_Extension__r.Date_Closed26__c.daysbetween(system.today());
            if (c.CIBIL_Extension__r.Date_Closed26__c == null || daysclosed <= 365)
            eld.add(e);
            }
            if (c.CIBIL_Extension__r.Account_Type27__c != 'NO DATA' && c.CIBIL_Extension__r.Account_Type27__c != null && c.CIBIL_Extension__r.Account_Type27__c != '' && ((c.CIBIL_Extension__r.Ownership27__c == 'Individual') || (c.CIBIL_Extension__r.Ownership27__c == 'joint'))) {
            Existing_Loan_Details__c e = new Existing_Loan_Details__c();
            e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
            e.Loan_Type__c = c.CIBIL_Extension__r.Account_Type27__c;
            e.Financer__c = '';
            e.Seen_in__c = 'CIBIL';
            //e.Tenor__c=12;
            if (cexlist.size() > 0) {
            e.Tenor__c = cexlist[0].Repayment_tenure27__c;
            e.EMI__c = cexlist[0].EMI27__c;
            }
            if (c.CIBIL_Extension__r.Current_Balance27__c > 0)
            e.POS__c = c.CIBIL_Extension__r.Current_Balance27__c;
            else
            e.POS__c = 0;
            if (c.Applicant__r.Loan_Application__r.Product__c == 'SOL') {
            if (c.CIBIL_Extension__r.Date_Opened27__c != null && c.CIBIL_Extension__r.Date_closed27__c == null) {

            date a = system.today();
            integer i = a.day();
            integer j = c.CIBIL_Extension__r.Date_Opened27__c.day();
            system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
            if (i == j)
                e.MOB__c = c.CIBIL_Extension__r.Date_Opened27__c.monthsbetween(system.today()) - 1;
            else
                e.MOB__c = c.CIBIL_Extension__r.Date_Opened27__c.monthsbetween(system.today()) - 2;
            system.debug('c.CIBIL_Extension__r.Date_Opened27__c.monthsbetween(system.today())*************' + c.CIBIL_Extension__r.Date_Opened27__c.monthsbetween(system.today()) + 'ccccccccc' + c.CIBIL_Extension__r.Date_closed27__c);


            } else if (c.CIBIL_Extension__r.Date_Opened27__c != null)
            e.MOB__c = c.CIBIL_Extension__r.Date_Opened27__c.monthsbetween(c.CIBIL_Extension__r.Date_closed27__c);
            }
            e.Ownership__c = c.CIBIL_Extension__r.Ownership27__c;

            if (c.CIBIL_Extension__r.Date_Closed27__c != null) {
            // if(c.CIBIL_Extension__r.Date_Closed27__c>=(system.today()-12)){
            e.Status__c = 'Closed';
            e.Obligation__c = 'No';
            // }
            } else {
            e.Status__c = 'Live';
            e.Obligation__c = 'Yes';
            }
            e.Type_of_Oblig__c = 'Individual';
            e.Applicant__c = c.Applicant__c;
            // e.Principal_O_s__c=c.CIBIL_Extension__r.Current_Balance27__c;
            e.Start_On__c = c.CIBIL_Extension__r.Date_Opened27__c;
            e.Loan_Amount__c = c.CIBIL_Extension__r.Sanction_Amount27__c;
            if (c.CIBIL_Extension__r.Date_Closed27__c != Null)
            daysclosed = c.CIBIL_Extension__r.Date_Closed27__c.daysbetween(system.today());
            if (c.CIBIL_Extension__r.Date_Closed27__c == null || daysclosed <= 365)
            eld.add(e);
            }
            if (c.CIBIL_Extension__r.Account_Type28__c != 'NO DATA' && c.CIBIL_Extension__r.Account_Type28__c != null && c.CIBIL_Extension__r.Account_Type28__c != '' && ((c.CIBIL_Extension__r.Ownership28__c == 'Individual') || (c.CIBIL_Extension__r.Ownership28__c == 'joint'))) {
            Existing_Loan_Details__c e = new Existing_Loan_Details__c();
            e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
            e.Loan_Type__c = c.CIBIL_Extension__r.Account_Type28__c;
            e.Financer__c = '';
            e.Seen_in__c = 'CIBIL';
            //e.Tenor__c=12;
            if (cexlist.size() > 0) {
            e.Tenor__c = cexlist[0].Repayment_tenure28__c;
            e.EMI__c = cexlist[0].EMI28__c;
            }
            if (c.CIBIL_Extension__r.Current_Balance28__c > 0)
            e.POS__c = c.CIBIL_Extension__r.Current_Balance28__c;
            else
            e.POS__c = 0;
            if (c.Applicant__r.Loan_Application__r.Product__c == 'SOL') {
            if (c.CIBIL_Extension__r.Date_Opened28__c != null && c.CIBIL_Extension__r.Date_closed28__c == null) {

            date a = system.today();
            integer i = a.day();
            integer j = c.CIBIL_Extension__r.Date_Opened28__c.day();
            system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
            if (i == j)
                e.MOB__c = c.CIBIL_Extension__r.Date_Opened28__c.monthsbetween(system.today()) - 1;
            else
                e.MOB__c = c.CIBIL_Extension__r.Date_Opened28__c.monthsbetween(system.today()) - 2;
            system.debug('c.CIBIL_Extension__r.Date_Opened28__c.monthsbetween(system.today())*************' + c.CIBIL_Extension__r.Date_Opened28__c.monthsbetween(system.today()) + 'ccccccccc' + c.CIBIL_Extension__r.Date_closed28__c);


            } else if (c.CIBIL_Extension__r.Date_Opened28__c != null)
            e.MOB__c = c.CIBIL_Extension__r.Date_Opened28__c.monthsbetween(c.CIBIL_Extension__r.Date_closed28__c);
            }
            e.Ownership__c = c.CIBIL_Extension__r.Ownership28__c;

            if (c.CIBIL_Extension__r.Date_Closed28__c != null) {
            // if(c.CIBIL_Extension__r.Date_Closed28__c>=(system.today()-12)){
            e.Status__c = 'Closed';
            e.Obligation__c = 'No';
            // }
            } else {
            e.Status__c = 'Live';
            e.Obligation__c = 'Yes';
            }
            e.Type_of_Oblig__c = 'Individual';
            e.Applicant__c = c.Applicant__c;
            // e.Principal_O_s__c=c.CIBIL_Extension__r.Current_Balance28__c;
            e.Start_On__c = c.CIBIL_Extension__r.Date_Opened28__c;
            e.Loan_Amount__c = c.CIBIL_Extension__r.Sanction_Amount28__c;
            if (c.CIBIL_Extension__r.Date_Closed28__c != Null)
            daysclosed = c.CIBIL_Extension__r.Date_Closed28__c.daysbetween(system.today());
            if (c.CIBIL_Extension__r.Date_Closed28__c == null || daysclosed <= 365)
            eld.add(e);
            }
            if (c.CIBIL_Extension__r.Account_Type29__c != 'NO DATA' && c.CIBIL_Extension__r.Account_Type29__c != null && c.CIBIL_Extension__r.Account_Type29__c != '' && ((c.CIBIL_Extension__r.Ownership29__c == 'Individual') || (c.CIBIL_Extension__r.Ownership29__c == 'joint'))) {
            Existing_Loan_Details__c e = new Existing_Loan_Details__c();
            e.Loan_Application__c = c.Applicant__r.Loan_Application__c;
            e.Loan_Type__c = c.CIBIL_Extension__r.Account_Type29__c;
            e.Financer__c = '';
            e.Seen_in__c = 'CIBIL';
            //e.Tenor__c=12;
            if (cexlist.size() > 0) {
            e.Tenor__c = cexlist[0].Repayment_tenure29__c;
            e.EMI__c = cexlist[0].EMI29__c;
            }
            if (c.CIBIL_Extension__r.Current_Balance29__c > 0)
            e.POS__c = c.CIBIL_Extension__r.Current_Balance29__c;
            else
            e.POS__c = 0;
            if (c.Applicant__r.Loan_Application__r.Product__c == 'SOL') {
            if (c.CIBIL_Extension__r.Date_Opened29__c != null && c.CIBIL_Extension__r.Date_closed29__c == null) {

            date a = system.today();
            integer i = a.day();
            integer j = c.CIBIL_Extension__r.Date_Opened29__c.day();
            system.debug('iiiiiiiiiiiiiiiiiiiiii' + i + 'jjjjjjjjjjjjjjjjjjjjj' + j);
            if (i == j)
                e.MOB__c = c.CIBIL_Extension__r.Date_Opened29__c.monthsbetween(system.today()) - 1;
            else
                e.MOB__c = c.CIBIL_Extension__r.Date_Opened29__c.monthsbetween(system.today()) - 2;
            system.debug('c.CIBIL_Extension__r.Date_Opened29__c.monthsbetween(system.today())*************' + c.CIBIL_Extension__r.Date_Opened29__c.monthsbetween(system.today()) + 'ccccccccc' + c.CIBIL_Extension__r.Date_closed29__c);


            } else if (c.CIBIL_Extension__r.Date_Opened29__c != null)
            e.MOB__c = c.CIBIL_Extension__r.Date_Opened29__c.monthsbetween(c.CIBIL_Extension__r.Date_closed29__c);
            }
            e.Ownership__c = c.CIBIL_Extension__r.Ownership29__c;

            if (c.CIBIL_Extension__r.Date_Closed29__c != null) {
            // if(c.CIBIL_Extension__r.Date_Closed29__c>=(system.today()-12)){
            e.Status__c = 'Closed';
            e.Obligation__c = 'No';
            // }
            } else {
            e.Status__c = 'Live';
            e.Obligation__c = 'Yes';
            }
            e.Type_of_Oblig__c = 'Individual';
            e.Applicant__c = c.Applicant__c;
            // e.Principal_O_s__c=c.CIBIL_Extension__r.Current_Balance29__c;
            e.Start_On__c = c.CIBIL_Extension__r.Date_Opened29__c;
            e.Loan_Amount__c = c.CIBIL_Extension__r.Sanction_Amount29__c;
            if (c.CIBIL_Extension__r.Date_Closed29__c != Null)
            daysclosed = c.CIBIL_Extension__r.Date_Closed29__c.daysbetween(system.today());
            if (c.CIBIL_Extension__r.Date_Closed29__c == null || daysclosed <= 365)
            eld.add(e);
            }*/
                /**********OTP V2 Enhancement ends***************/
                


                cibilstart = true;
                system.debug('cibilstart ===>'+cibilstart);


            } //end of for   

            //if(cexlistToBeUpdated!=null && cexlistToBeUpdated.size()>0)
            //  update cexlistToBeUpdated;
            
            //Bug 24640 - DG Online for SOL and PLCS : Start
            try{
                if(cibillist!=null && cibillist.size()>0){
                    String salaried_current_id;
                    if(cibillist[0]!=null && cibillist[0].Cibil_Temp__c !=null && cibillist[0].Cibil_Temp__r.salaried__c !=null){
                        salaried_current_id = cibillist[0].Cibil_Temp__r.salaried__c;
                    }
                    System.debug('salaried_current_id : '+salaried_current_id);
                    if(salaried_current_id!=null){
                        if(eld!=null && !eld.isEmpty()){
                            for(Existing_Loan_Details__c obj_eld: eld){
                                Boolean isDummyApplicantDGOnline = CibilService_Salaried.isDummyApplicantDGOnline( obj_eld.applicant__c );
                                
                                if( obj_eld!=null && obj_eld.applicant__c != null && isDummyApplicantDGOnline ){
                                    obj_eld.Salaried__c = salaried_current_id;
                                }
                            }
                        }
                    }
                }
            }catch(Exception e){
                System.debug('Exception : '+ e);
            }
            //Bug 24640 - DG Online for SOL and PLCS : End

            /* end code to get ELD */
            //Bug 13830:Custom label added for new products
            //Condition for RLP added by Mahima- 13485 
            //Bug Id:14509,Added condition for RDL. 
            /*Start BUG-16959*/
            isPSBLProductLineProduct = getPSBLorDBOLProductLineFlag(product);
            /*End BUG-16959*/   
                       //Bug:17470
                isPROProductLineProduct = getPROProductLineLFlag(product);
            if (product  != null  && product != '' &&  (product == 'SOL' || product == 'SPL' || product == 'SBS CS SAL' || product == 'SAL' || product == 'RSL' || product == 'SHL' || product == 'HSL' || product == 'SBS CS SHL' || product == 'SHOL' || (/*BUG-16959 S*/ isPSBLProductLineProduct /*BUG-16959 E*/ ||(NewProductsAdded != null && NewProductsAdded.contains(product)) ||(ProductForFlowLabel != null && ProductForFlowLabel.contains(product))) || product == 'DOCTORS' || isPROProductLineProduct || product == 'LAP' ||  product == 'RLP' || product == 'Home Loan' || product == 'RDL')) {
                System.debug('product is SOL so directly ELD created');
                /*try{
                    insert eld;  
                    }
                    catch(Exception e)
                    {
                        try{
                            system.debug('Exception is==>'+e.getMessage()+' at line number'+e.getLineNumber());
                            String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
                            SOLsendEmail.LogixEmailForDG(new List < String > {
                            'BajajFinserv_HTS@persistent.com',
                            'rajesh_pukale@persistent.com',
                            'harsit_garg@persistent.com'
                            }, UserInfo.getUserName().substringAfterLast('.') + ': Cibil_to_ExistingLoanDetails1 Exception: ', str);
                        }catch(Exception ex)
                        {
                            system.debug('Exception is==>'+ex.getMessage());
                        }
                    }  */                 
                Integer i;
                Integer limit1;
                if(LaonApplicationCreation__c.getValues('CibilUnableTolockRowCount') != null) {
                    limit1= Integer.valueOf(LaonApplicationCreation__c.getValues('CibilUnableTolockRowCount').Numberofdays__c);
                }
                
                // Integer limit=Integer.valueOf(LaonApplicationCreation__c.getValues('CibilUnableTolockRowCount').Numberofdays__c);
                 
                for(i=0;i<=limit1;i++)
                {
                    try
                    {
                        insert eld;
                        system.debug('executed++++++++++++++'+eld);
                        break;
                    }
                    catch(Exception e)
                    {
                        system.debug('unlableTpLockRow'+e);
                    }
                }
                
                /*Raghu start

                if(limit1 != null){
                    try
                    {
                        insert eld;
                    }
                    catch(Exception e)
                    {}
                }
                Raghu end */
            }

            /*else{
        if(cibillist[0].Enable_Manual_Cibil__c==false){ 
            if(cibillistfapp.size()>1){
            //dont get ELD
            System.debug('I cant get ELD');
            }
            else{
            //get ELD
            //  getELD();
            insert eld;
            // System.debug('I can get ELD'+eld[0].Name);
            System.debug('I can get ELD'+eld.size());
            }
            }
        
            else{
            // User sets the flag, so insert ELD
            insert eld;
            }
        } */
        } //end of main if
    }
    

    system.debug('**^^&&&'+cibilstart+'@#@#@@#'+isPro);
    system.debug('product ====>'+product);
    /*Start BUG-16959*/
    isPSBLProductLineProduct = getPSBLorDBOLProductLineFlag(product);
    system.debug('product ====>'+isBlPlProduct );
    /*End BUG-16959*/
    //Bug 13830:Custom label added for new products
                 //Bug:17470
                isPROProductLineProduct = getPROProductLineLFlag(product);
      //Condition for RLP added by Mahima- 13485
       
    if (cibilstart == true && (isBlPlProduct || product == 'SOL' || product=='RDL' || product == 'SAL' || product == 'SPL' || product == 'RSL' || product == 'SBS CS SAL' || product == 'SHL' || product == 'HSL' || product == 'SBS CS SHL' || product == 'SHOL' || (/*BUG-16959 S*/ isPSBLProductLineProduct /*BUG-16959 E*/ || (NewProductsAdded != null && NewProductsAdded.contains(product)) ||(ProductForFlowLabel != null && ProductForFlowLabel.contains(product)))|| product == 'DOCTORS' || isPROProductLineProduct || product == 'Home Loan' || product == 'LAP' || product == 'RLP' || isPro)) {

        List < CIBIL__c > ceRecords1 = new List < CIBIL__c > ();

         system.debug('sssssssssssssssssssss');
        try {
            //Rohit added for bug 21238 start
           // Set<String> appIds  = new Set<String>();
            //Rohit added for bug 21238 stop
            for (CIBIL__c ceRecords: Trigger.new) {
                ceRecords1.add(ceRecords);
                system.debug('kkkkkkkkkk' + ceRecords1);
                //Rohit added for bug 21238 start
                //appIds.add(ceRecords.Applicant__c);
                //Rohit added for bug 21238 stop
            }
            system.debug('inside ispro');
            cibilcheckclass ccs = new cibilcheckclass();
            if(!Test.isRunningTest()){
            ccs.cibilUpdate(ceRecords1);
            //Rohit added for bug 21238 start
            
             //   if(Label.BLPLProducts != null){
              //      List<String> prodLst = Label.BLPLProducts.split(';');
              //      if(prodLst != null && prodLst.contains(product))
              //  ccs.checkBLPLRisk(appIds);
               // }
            //Rohit added for bug 21238 stop
            }

        } catch (exception e) {}


    } //cibil class calling 
    //code added Bug : 21238  ELDELDInsertAndMOBCalc start
   
    public void setisBLPLRiskFlag(Integer daysclosed,Decimal SanctionAmountValue,String productValue,String AccountTypeValue,Decimal mobValue,String applicantID)
    {
         //Rohit added for reverse logic      
        appIDsUpdated.add(applicantID);
        System.debug('rohit '+eldProducts.contains(productValue)+'-'+setAccountType.contains(AccountTypeValue)+'-'+(SanctionAmountValue >= maxLoanAmount)+'-'+(mobValue>=maxMOB));
        if(eldProducts!=null && eldProducts.size()>0 &&  eldProducts.contains(productValue) && setAccountType!=null && setAccountType.size()>0 && setAccountType.contains(AccountTypeValue) && SanctionAmountValue >= maxLoanAmount && mobValue>=maxMOB)
        {            
            isPLBLRisk = true;
        }
    
    
        if(isPLBLRisk != null && isPLBLRisk && appIDsUpdated!=null && appIDsUpdated.size()>0)
        {
            List<Applicant__c>AppList=new List<Applicant__C>();
            List<Applicant__c>AppSetUpdated=new List<Applicant__C>();
            Applist=[select id,is_BL_PL_Risk__c from Applicant__c where id in : appIDsUpdated];
            if(AppList!=null && AppList.size()>0)
            {
                for (Applicant__C app:AppList)
                {
                   // if(app.is_BL_PL_Risk__c==false)
                   // {
                    app.is_BL_PL_Risk__c=isPLBLRisk;
                    AppSetUpdated.add(app);
                   // }
                }
            }
                if(AppSetUpdated!=null && AppSetUpdated.size()>0)
                update AppSetUpdated;
        }
    }
    //code added Bug : 21238  ELDELDInsertAndMOBCalc end
    /*
    Code added by Rakesh Shinde.Date : 21 Jan 2016. 
    BRD : PRO DSS Changes at PO .
    Purpose : This method will calculate value for MOB  
    */
    public void assignELDMob(Existing_Loan_Details__c objExtLoanDet ,Date dateOpened ,Date dateClosed){
        system.debug('::dateOpened::'+dateOpened +'::dateClosed::'+dateClosed);
        if (dateOpened != null && dateClosed == null) { 
            if(System.Label.MobCalculation.equalsIgnoreCase('false')){//added switch 
            system.debug('switch is false::'+System.Label.MobCalculation);
                date a = system.today();
                integer i = a.day();
                integer j = dateOpened.day();           
                if (i == j) objExtLoanDet.MOB__c = dateOpened.monthsbetween(system.today()) - 1;
                else objExtLoanDet.MOB__c = dateOpened.monthsbetween(system.today()) - 2;       
            }else if (System.Label.MobCalculation.equalsIgnoreCase('true')){
                system.debug('switch is true::'+System.Label.MobCalculation);
                if(mobProd != null && mobProd!= '' && eldProducts!=null && eldProducts.size()>0 && eldProducts.contains(mobProd)){//added if for 844 -0 mob start
                         date a = system.today();
                        integer i = a.day();
                        integer j = dateOpened.day();           
                        objExtLoanDet.MOB__c = dateOpened.monthsbetween(system.today()); 
                }else{//added if for 844 -0 mob stop
                    date a = system.today();
                    integer i = a.day();
                    integer j = dateOpened.day();           
                    if (i == j) objExtLoanDet.MOB__c = dateOpened.monthsbetween(system.today()) - 1;
                    else objExtLoanDet.MOB__c = dateOpened.monthsbetween(system.today()) - 2;
                } 
            }           
        } 
        else if (dateOpened != null) 
        objExtLoanDet.MOB__c = dateOpened.monthsbetween(dateClosed);
        system.debug('::MOB::'+objExtLoanDet.MOB__c);
        //code added Bug : 21238  ELDELDInsertAndMOBCalc start 
        mobValue=0;
        mobValue=objExtLoanDet.MOB__c;
        //code added Bug : 21238  ELDELDInsertAndMOBCalc end
    }

    public decimal getSumOfAmountOverdue(CIBIL__C cibilObj) {
        decimal sumAmt = 0;
        if (cibilObj.Amount_Overdue__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.Amount_Overdue__c);
        if (cibilObj.Amount_Overdue1__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.Amount_Overdue1__c);
        if (cibilObj.Amount_Overdue2__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.Amount_Overdue2__c);
        if (cibilObj.Amount_Overdue3__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.Amount_Overdue3__c);
        if (cibilObj.Amount_Overdue4__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.Amount_Overdue4__c);
        if (cibilObj.Amount_Overdue5__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.Amount_Overdue5__c);
        if (cibilObj.Amount_Overdue6__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.Amount_Overdue6__c);
        if (cibilObj.Amount_Overdue7__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.Amount_Overdue7__c);
        if (cibilObj.Amount_Overdue8__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.Amount_Overdue8__c);
        if (cibilObj.Amount_Overdue9__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.Amount_Overdue9__c);
        if (cibilObj.Amount_Overdue10__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.Amount_Overdue10__c);
        if (cibilObj.Amount_Overdue11__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.Amount_Overdue11__c);
        if (cibilObj.Amount_Overdue12__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.Amount_Overdue12__c);
        if (cibilObj.Amount_Overdue13__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.Amount_Overdue13__c);
        if (cibilObj.Amount_Overdue14__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.Amount_Overdue14__c);
        if (cibilObj.Amount_Overdue15__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.Amount_Overdue15__c);
        if (cibilObj.Amount_Overdue16__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.Amount_Overdue16__c);
        if (cibilObj.Amount_Overdue17__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.Amount_Overdue17__c);
        if (cibilObj.Amount_Overdue18__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.Amount_Overdue18__c);
        if (cibilObj.Amount_Overdue19__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.Amount_Overdue19__c);
        if (cibilObj.CIBIL_Extension__r.Amount_Overdue20__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.CIBIL_Extension__r.Amount_Overdue20__c);
        if (cibilObj.CIBIL_Extension__r.Amount_Overdue21__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.CIBIL_Extension__r.Amount_Overdue21__c);
        if (cibilObj.CIBIL_Extension__r.Amount_Overdue22__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.CIBIL_Extension__r.Amount_Overdue22__c);
        if (cibilObj.CIBIL_Extension__r.Amount_Overdue23__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.CIBIL_Extension__r.Amount_Overdue23__c);
        if (cibilObj.CIBIL_Extension__r.Amount_Overdue24__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.CIBIL_Extension__r.Amount_Overdue24__c);
        if (cibilObj.CIBIL_Extension__r.Amount_Overdue25__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.CIBIL_Extension__r.Amount_Overdue25__c);
        if (cibilObj.CIBIL_Extension__r.Amount_Overdue26__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.CIBIL_Extension__r.Amount_Overdue26__c);
        if (cibilObj.CIBIL_Extension__r.Amount_Overdue27__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.CIBIL_Extension__r.Amount_Overdue27__c);
        if (cibilObj.CIBIL_Extension__r.Amount_Overdue28__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.CIBIL_Extension__r.Amount_Overdue28__c);
        if (cibilObj.CIBIL_Extension__r.Amount_Overdue29__c != null) sumAmt = sumAmt + decimal.valueOf(cibilObj.CIBIL_Extension__r.Amount_Overdue29__c);

        return sumAmt;
    }

    public void checkMinMaxDate(Date OpenDate) {
        system.debug('MAX -- ' + max);
        system.debug(OpenDate + '-- OpenDate -- MIN -- ' + min);
        if (OpenDate != null && OpenDate.daysBetween(system.today()) >= max) {
            max = OpenDate.daysBetween(system.today());
            firstLoan = OpenDate;
            system.debug('First loan now -- ' + firstLoan);
        }
        if (OpenDate != null && OpenDate.daysBetween(system.today()) <= min) {
            min = OpenDate.daysBetween(system.today());
            latestLoan = OpenDate;
            system.debug('Latest loan now -- ' + latestLoan);
        }
    }

    public decimal getCreditCardUtilization(CIBIL__C cibilObj) {
        //decimal balAmount = 0;
        //decimal sanAmount = 0;

        ATOSParameters__c creditCardLoans = new ATOSParameters__c();
        String creditCard = '';
        creditCardLoans = ATOSParameters__c.getValues('Credit Card');
        if (creditCardLoans != null && creditCardLoans.value__c != null) {
            creditCard = creditCardLoans.value__c;
        }

        if (cibilObj.Account_Type__c != null && creditCard.indexOf(cibilObj.Account_Type__c) != -1 && cibilObj.Date_Opened__c != null) {
            balAmount = balAmount + cibilObj.Current_Balance__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type1__c != null && creditCard.indexOf(cibilObj.Account_Type1__c) != -1 && cibilObj.Date_Opened1__c != null) {
            balAmount = balAmount + cibilObj.Current_Balance1__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type2__c != null && creditCard.indexOf(cibilObj.Account_Type2__c) != -1 && cibilObj.Date_Opened2__c != null) {
            balAmount = balAmount + cibilObj.Current_Balance2__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type3__c != null && creditCard.indexOf(cibilObj.Account_Type3__c) != -1 && cibilObj.Date_Opened3__c != null) {
            balAmount = balAmount + cibilObj.Current_Balance3__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type4__c != null && creditCard.indexOf(cibilObj.Account_Type4__c) != -1 && cibilObj.Date_Opened4__c != null) {
            balAmount = balAmount + cibilObj.Current_Balance4__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type5__c != null && creditCard.indexOf(cibilObj.Account_Type5__c) != -1 && cibilObj.Date_Opened5__c != null) {
            balAmount = balAmount + cibilObj.Current_Balance5__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type6__c != null && creditCard.indexOf(cibilObj.Account_Type6__c) != -1 && cibilObj.Date_Opened6__c != null) {
            balAmount = balAmount + cibilObj.Current_Balance6__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type7__c != null && creditCard.indexOf(cibilObj.Account_Type7__c) != -1 && cibilObj.Date_Opened7__c != null) {
            balAmount = balAmount + cibilObj.Current_Balance7__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type8__c != null && creditCard.indexOf(cibilObj.Account_Type8__c) != -1 && cibilObj.Date_Opened8__c != null) {
            balAmount = balAmount + cibilObj.Current_Balance8__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type9__c != null && creditCard.indexOf(cibilObj.Account_Type9__c) != -1 && cibilObj.Date_Opened9__c != null) {
            balAmount = balAmount + cibilObj.Current_Balance9__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type10__c != null && creditCard.indexOf(cibilObj.Account_Type10__c) != -1 && cibilObj.Date_Opened10__c != null) {
            balAmount = balAmount + cibilObj.Current_Balance10__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type11__c != null && creditCard.indexOf(cibilObj.Account_Type11__c) != -1 && cibilObj.Date_Opened11__c != null) {
            balAmount = balAmount + cibilObj.Current_Balance11__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type12__c != null && creditCard.indexOf(cibilObj.Account_Type12__c) != -1 && cibilObj.Date_Opened12__c != null) {
            balAmount = balAmount + cibilObj.Current_Balance12__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type13__c != null && creditCard.indexOf(cibilObj.Account_Type13__c) != -1 && cibilObj.Date_Opened13__c != null) {
            balAmount = balAmount + cibilObj.Current_Balance13__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type14__c != null && creditCard.indexOf(cibilObj.Account_Type14__c) != -1 && cibilObj.Date_Opened14__c != null) {
            balAmount = balAmount + cibilObj.Current_Balance14__c;
            creditcardNumber = true;
            
        }
        if (cibilObj.Account_Type15__c != null && creditCard.indexOf(cibilObj.Account_Type15__c) != -1 && cibilObj.Date_Opened15__c != null) {
            balAmount = balAmount + cibilObj.Current_Balance15__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type16__c != null && creditCard.indexOf(cibilObj.Account_Type16__c) != -1 && cibilObj.Date_Opened16__c != null) {
            balAmount = balAmount + cibilObj.Current_Balance16__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type17__c != null && creditCard.indexOf(cibilObj.Account_Type17__c) != -1 && cibilObj.Date_Opened17__c != null) {
            balAmount = balAmount + cibilObj.Current_Balance17__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type18__c != null && creditCard.indexOf(cibilObj.Account_Type18__c) != -1 && cibilObj.Date_Opened18__c != null) {
            balAmount = balAmount + cibilObj.Current_Balance18__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type19__c != null && creditCard.indexOf(cibilObj.Account_Type19__c) != -1 && cibilObj.Date_Opened19__c != null) {
            balAmount = balAmount + cibilObj.Current_Balance19__c;
            creditcardNumber = true;
        }
        if (cibilObj.CIBIL_Extension__c != null) {
            if (cibilObj.CIBIL_Extension__r.Account_type20__c != null && creditCard.indexOf(cibilObj.CIBIL_Extension__r.Account_type20__c) != -1 && cibilObj.CIBIL_Extension__r.Date_Opened20__c != null) {
                balAmount = balAmount + cibilObj.CIBIL_Extension__r.Current_Balance20__c;
                creditcardNumber = true;
            }
            if (cibilObj.CIBIL_Extension__r.Account_type21__c != null && creditCard.indexOf(cibilObj.CIBIL_Extension__r.Account_type21__c) != -1 && cibilObj.CIBIL_Extension__r.Date_Opened21__c != null) {
                balAmount = balAmount + cibilObj.CIBIL_Extension__r.Current_Balance21__c;
                creditcardNumber = true;
            }
            if (cibilObj.CIBIL_Extension__r.Account_type22__c != null && creditCard.indexOf(cibilObj.CIBIL_Extension__r.Account_type22__c) != -1 && cibilObj.CIBIL_Extension__r.Date_Opened22__c != null) {
                balAmount = balAmount + cibilObj.CIBIL_Extension__r.Current_Balance22__c;
                creditcardNumber = true;
            }
            if (cibilObj.CIBIL_Extension__r.Account_type23__c != null && creditCard.indexOf(cibilObj.CIBIL_Extension__r.Account_type23__c) != -1 && cibilObj.CIBIL_Extension__r.Date_Opened23__c != null) {
                balAmount = balAmount + cibilObj.CIBIL_Extension__r.Current_Balance23__c;
                creditcardNumber = true;
            }
            if (cibilObj.CIBIL_Extension__r.Account_type24__c != null && creditCard.indexOf(cibilObj.CIBIL_Extension__r.Account_type24__c) != -1 && cibilObj.CIBIL_Extension__r.Date_Opened24__c != null) {
                balAmount = balAmount + cibilObj.CIBIL_Extension__r.Current_Balance24__c;
                creditcardNumber = true;
            }
            if (cibilObj.CIBIL_Extension__r.Account_type25__c != null && creditCard.indexOf(cibilObj.CIBIL_Extension__r.Account_type25__c) != -1 && cibilObj.CIBIL_Extension__r.Date_Opened25__c != null) {
                balAmount = balAmount + cibilObj.CIBIL_Extension__r.Current_Balance25__c;
                creditcardNumber = true;
            }
            if (cibilObj.CIBIL_Extension__r.Account_type26__c != null && creditCard.indexOf(cibilObj.CIBIL_Extension__r.Account_type26__c) != -1 && cibilObj.CIBIL_Extension__r.Date_Opened26__c != null) {
                balAmount = balAmount + cibilObj.CIBIL_Extension__r.Current_Balance26__c;
                creditcardNumber = true;
            }
            if (cibilObj.CIBIL_Extension__r.Account_type27__c != null && creditCard.indexOf(cibilObj.CIBIL_Extension__r.Account_type27__c) != -1 && cibilObj.CIBIL_Extension__r.Date_Opened27__c != null) {
                balAmount = balAmount + cibilObj.CIBIL_Extension__r.Current_Balance27__c;
                creditcardNumber = true;
            }
            if (cibilObj.CIBIL_Extension__r.Account_type28__c != null && creditCard.indexOf(cibilObj.CIBIL_Extension__r.Account_type28__c) != -1 && cibilObj.CIBIL_Extension__r.Date_Opened28__c != null) {
                balAmount = balAmount + cibilObj.CIBIL_Extension__r.Current_Balance28__c;
                creditcardNumber = true;
            }
            if (cibilObj.CIBIL_Extension__r.Account_type29__c != null && creditCard.indexOf(cibilObj.CIBIL_Extension__r.Account_type29__c) != -1 && cibilObj.CIBIL_Extension__r.Date_Opened29__c != null) {
                balAmount = balAmount + cibilObj.CIBIL_Extension__r.Current_Balance29__c;
                creditcardNumber = true;
            }
        }


        if (cibilObj.Account_Type__c != null && creditCard.indexOf(cibilObj.Account_Type__c) != -1 && cibilObj.Date_Opened__c != null) {
            sanAmount = sanAmount + cibilObj.Sanction_Amount__c ;
            creditcardNumber = true;
            system.debug('**sanAmount in 1 *'+sanAmount);
        }
        if (cibilObj.Account_Type1__c != null && creditCard.indexOf(cibilObj.Account_Type1__c) != -1 && cibilObj.Date_Opened1__c != null) {
            sanAmount = sanAmount + cibilObj.Sanction_Amount1__c ;
            creditcardNumber = true;
            system.debug('**sanAmount in *'+cibilObj.Sanction_Amount1__c);
            system.debug('**sanAmount*'+sanAmount);
        }
        if (cibilObj.Account_Type2__c != null && creditCard.indexOf(cibilObj.Account_Type2__c) != -1 && cibilObj.Date_Opened2__c != null) {
            system.debug('**sanAmount in 22*'+cibilObj.Sanction_Amount2__c);
            creditcardNumber = true;
            sanAmount = sanAmount + cibilObj.Sanction_Amount2__c ;
        }
        system.debug('**sanAmount*'+sanAmount);
        if (cibilObj.Account_Type3__c != null && creditCard.indexOf(cibilObj.Account_Type3__c) != -1 && cibilObj.Date_Opened3__c != null) {
            creditcardNumber = true;
            sanAmount = sanAmount + cibilObj.Sanction_Amount3__c;
        }
        if (cibilObj.Account_Type4__c != null && creditCard.indexOf(cibilObj.Account_Type4__c) != -1 && cibilObj.Date_Opened4__c != null) {
            sanAmount = sanAmount + cibilObj.Sanction_Amount4__c ;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type5__c != null && creditCard.indexOf(cibilObj.Account_Type5__c) != -1 && cibilObj.Date_Opened5__c != null) {
            sanAmount = sanAmount + cibilObj.Sanction_Amount5__c ;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type6__c != null && creditCard.indexOf(cibilObj.Account_Type6__c) != -1 && cibilObj.Date_Opened6__c != null) {
            sanAmount = sanAmount + cibilObj.Sanction_Amount6__c ;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type7__c != null && creditCard.indexOf(cibilObj.Account_Type7__c) != -1 && cibilObj.Date_Opened7__c != null) {
            sanAmount = sanAmount + cibilObj.Sanction_Amount7__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type8__c != null && creditCard.indexOf(cibilObj.Account_Type8__c) != -1 && cibilObj.Date_Opened8__c != null) {
            sanAmount = sanAmount + cibilObj.Sanction_Amount8__c ;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type9__c != null && creditCard.indexOf(cibilObj.Account_Type9__c) != -1 && cibilObj.Date_Opened9__c != null) {
            sanAmount = sanAmount + cibilObj.Sanction_Amount9__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type10__c != null && creditCard.indexOf(cibilObj.Account_Type10__c) != -1 && cibilObj.Date_Opened10__c != null) {
            sanAmount = sanAmount + cibilObj.Sanction_Amount10__c ;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type11__c != null && creditCard.indexOf(cibilObj.Account_Type11__c) != -1 && cibilObj.Date_Opened11__c != null) {
            sanAmount = sanAmount + cibilObj.Sanction_Amount11__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type12__c != null && creditCard.indexOf(cibilObj.Account_Type12__c) != -1 && cibilObj.Date_Opened12__c != null) {
            sanAmount = sanAmount + cibilObj.Sanction_Amount12__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type13__c != null && creditCard.indexOf(cibilObj.Account_Type13__c) != -1 && cibilObj.Date_Opened13__c != null) {
            sanAmount = sanAmount + cibilObj.Sanction_Amount13__c ;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type14__c != null && creditCard.indexOf(cibilObj.Account_Type14__c) != -1 && cibilObj.Date_Opened14__c != null) {
            sanAmount = sanAmount + cibilObj.Sanction_Amount14__c ;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type15__c != null && creditCard.indexOf(cibilObj.Account_Type15__c) != -1 && cibilObj.Date_Opened15__c != null) {
            sanAmount = sanAmount + cibilObj.Sanction_Amount15__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type16__c != null && creditCard.indexOf(cibilObj.Account_Type16__c) != -1 && cibilObj.Date_Opened16__c != null) {
            sanAmount = sanAmount + cibilObj.Sanction_Amount16__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type17__c != null && creditCard.indexOf(cibilObj.Account_Type17__c) != -1 && cibilObj.Date_Opened17__c != null) {
            sanAmount = sanAmount + cibilObj.Sanction_Amount17__c ;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type18__c != null && creditCard.indexOf(cibilObj.Account_Type18__c) != -1 && cibilObj.Date_Opened18__c != null) {
            sanAmount = sanAmount + cibilObj.Sanction_Amount18__c;
            creditcardNumber = true;
        }
        if (cibilObj.Account_Type19__c != null && creditCard.indexOf(cibilObj.Account_Type19__c) != -1 && cibilObj.Date_Opened19__c != null) {
            sanAmount = sanAmount + cibilObj.Sanction_Amount19__c;
            creditcardNumber = true;
        }
        if (cibilObj.CIBIL_Extension__c != null) {
            if (cibilObj.CIBIL_Extension__r.Account_type20__c != null && creditCard.indexOf(cibilObj.CIBIL_Extension__r.Account_type20__c) != -1 && cibilObj.CIBIL_Extension__r.Date_Opened20__c != null) {
                sanAmount = sanAmount + cibilObj.CIBIL_Extension__r.Sanction_Amount20__c ;
                creditcardNumber = true;
            }
            if (cibilObj.CIBIL_Extension__r.Account_type21__c != null && creditCard.indexOf(cibilObj.CIBIL_Extension__r.Account_type21__c) != -1 && cibilObj.CIBIL_Extension__r.Date_Opened21__c != null) {
                sanAmount = sanAmount + cibilObj.CIBIL_Extension__r.Sanction_Amount21__c;
                creditcardNumber = true;
            }
            if (cibilObj.CIBIL_Extension__r.Account_type22__c != null && creditCard.indexOf(cibilObj.CIBIL_Extension__r.Account_type22__c) != -1 && cibilObj.CIBIL_Extension__r.Date_Opened22__c != null) {
                sanAmount = sanAmount + cibilObj.CIBIL_Extension__r.Sanction_Amount22__c ;
                creditcardNumber = true;
            }
            if (cibilObj.CIBIL_Extension__r.Account_type23__c != null && creditCard.indexOf(cibilObj.CIBIL_Extension__r.Account_type23__c) != -1 && cibilObj.CIBIL_Extension__r.Date_Opened23__c != null) {
                sanAmount = sanAmount + cibilObj.CIBIL_Extension__r.Sanction_Amount23__c ;
                creditcardNumber = true;
            }
            if (cibilObj.CIBIL_Extension__r.Account_type24__c != null && creditCard.indexOf(cibilObj.CIBIL_Extension__r.Account_type24__c) != -1 && cibilObj.CIBIL_Extension__r.Date_Opened24__c != null) {
                sanAmount = sanAmount + cibilObj.CIBIL_Extension__r.Sanction_Amount24__c;
                creditcardNumber = true;
            }
            if (cibilObj.CIBIL_Extension__r.Account_type25__c != null && creditCard.indexOf(cibilObj.CIBIL_Extension__r.Account_type25__c) != -1 && cibilObj.CIBIL_Extension__r.Date_Opened25__c != null) {
                sanAmount = sanAmount + cibilObj.CIBIL_Extension__r.Sanction_Amount25__c;
                creditcardNumber = true;
            }
            if (cibilObj.CIBIL_Extension__r.Account_type26__c != null && creditCard.indexOf(cibilObj.CIBIL_Extension__r.Account_type26__c) != -1 && cibilObj.CIBIL_Extension__r.Date_Opened26__c != null) {
                sanAmount = sanAmount + cibilObj.CIBIL_Extension__r.Sanction_Amount26__c ;
                creditcardNumber = true;
            }
            if (cibilObj.CIBIL_Extension__r.Account_type27__c != null && creditCard.indexOf(cibilObj.CIBIL_Extension__r.Account_type27__c) != -1 && cibilObj.CIBIL_Extension__r.Date_Opened27__c != null) {
                sanAmount = sanAmount + cibilObj.CIBIL_Extension__r.Sanction_Amount27__c ;
                creditcardNumber = true;
            }
            if (cibilObj.CIBIL_Extension__r.Account_type28__c != null && creditCard.indexOf(cibilObj.CIBIL_Extension__r.Account_type28__c) != -1 && cibilObj.CIBIL_Extension__r.Date_Opened28__c != null) {
                sanAmount = sanAmount + cibilObj.CIBIL_Extension__r.Sanction_Amount28__c ;
                creditcardNumber = true;
            }
            if (cibilObj.CIBIL_Extension__r.Account_type29__c != null && creditCard.indexOf(cibilObj.CIBIL_Extension__r.Account_type29__c) != -1 && cibilObj.CIBIL_Extension__r.Date_Opened29__c != null) {
                sanAmount = sanAmount + cibilObj.CIBIL_Extension__r.Sanction_Amount29__c;
                creditcardNumber = true;
            }
        }

        decimal creditCardUtilization = 0;
        system.debug('***sanAmount'+sanAmount+'**balAmount'+balAmount);
        if (sanAmount != 0 && balAmount != 0) creditCardUtilization = (balAmount / sanAmount) * 100;

        return creditCardUtilization;

    }
    /* POS_PO-16621 starts*/
    //POS_Dsibursal rule _ 7
    public Integer getSettledTDL(CIBIL__c cb,List<String> Written_settled_List_Local)
    {       System.debug('Inside getSettledTDL'+cb.Ownership__c+Written_settled_List_Local[0]);
        Integer CountTdl_WO_Settled_Except_CC = 0;
        if((Written_settled_List_Local[0]=='Written-off' || Written_settled_List_Local[0]=='Post(WO)Settled'|| Written_settled_List_Local[0]=='Settled' || Written_settled_List_Local[0]=='Restructured') && cb.Account_Type__c != 'Credit Card'){ //Bug-27602 && cb.Account_Type__c != 'Credit Card'
                CountTdl_WO_Settled_Except_CC++;
            }
            for(integer j=1;j<20;j++){
                String Ownerhip = 'Ownership'+j+'__c';   
                System.debug('Inside getSettledTDL2'+cb.get(Ownerhip)+Written_settled_List_Local[j]);
                if( (Written_settled_List_Local[j]=='Written-off' || Written_settled_List_Local[j]=='Post(WO)Settled'|| Written_settled_List_Local[j]=='Settled' || Written_settled_List_Local[j]=='Restructured') && cb.Account_Type__c != 'Credit Card'){ //Bug-27602 && cb.Account_Type__c != 'Credit Card'
                    CountTdl_WO_Settled_Except_CC++;
                }
            }
            
           //In Cibil Extension Object
            for(integer j=20;j<30;j++){
                String Ownerhip = 'Ownership'+j+'__c';      
                 System.debug('Inside getSettledTDL2'+cb.CIBIL_Extension__r.get(Ownerhip)+Written_settled_List_Local[j]);
                if((Written_settled_List_Local[j]=='Written-off' || Written_settled_List_Local[j]=='Post(WO)Settled'|| Written_settled_List_Local[j]=='Settled' || Written_settled_List_Local[j]=='Restructured') && cb.Account_Type__c != 'Credit Card'){ //Bug-27602 && cb.Account_Type__c != 'Credit Card'
                    CountTdl_WO_Settled_Except_CC++;
                }
                
            }
            return CountTdl_WO_Settled_Except_CC;
    }
    /* POS_PO-16621 ends*/
    public integer getNumberTradeLines(CIBIL__C cibilObj) {
        integer tradelineCount = 0;
        if (cibilObj.Account_Type__c != null && cibilObj.Account_Type__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.Account_Type1__c != null && cibilObj.Account_Type1__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.Account_Type2__c != null && cibilObj.Account_Type2__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.Account_Type3__c != null && cibilObj.Account_Type3__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.Account_Type4__c != null && cibilObj.Account_Type4__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.Account_Type5__c != null && cibilObj.Account_Type5__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.Account_Type6__c != null && cibilObj.Account_Type6__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.Account_Type7__c != null && cibilObj.Account_Type7__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.Account_Type8__c != null && cibilObj.Account_Type8__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.Account_Type9__c != null && cibilObj.Account_Type9__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.Account_Type10__c != null && cibilObj.Account_Type10__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.Account_Type11__c != null && cibilObj.Account_Type11__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.Account_Type12__c != null && cibilObj.Account_Type12__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.Account_type13__c != null && cibilObj.Account_Type13__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.Account_type14__c != null && cibilObj.Account_Type14__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.Account_type15__c != null && cibilObj.Account_Type15__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.Account_type16__c != null && cibilObj.Account_Type16__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.Account_type17__c != null && cibilObj.Account_Type17__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.Account_type18__c != null && cibilObj.Account_Type18__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.Account_type19__c != null && cibilObj.Account_Type19__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.CIBIL_Extension__r.Account_type20__c != null && cibilObj.CIBIL_Extension__r.Account_type20__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.CIBIL_Extension__r.Account_type21__c != null && cibilObj.CIBIL_Extension__r.Account_type21__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.CIBIL_Extension__r.Account_type22__c != null && cibilObj.CIBIL_Extension__r.Account_type22__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.CIBIL_Extension__r.Account_type23__c != null && cibilObj.CIBIL_Extension__r.Account_type23__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.CIBIL_Extension__r.Account_type24__c != null && cibilObj.CIBIL_Extension__r.Account_type24__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.CIBIL_Extension__r.Account_type25__c != null && cibilObj.CIBIL_Extension__r.Account_type25__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.CIBIL_Extension__r.Account_type26__c != null && cibilObj.CIBIL_Extension__r.Account_type26__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.CIBIL_Extension__r.Account_type27__c != null && cibilObj.CIBIL_Extension__r.Account_type27__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.CIBIL_Extension__r.Account_type28__c != null && cibilObj.CIBIL_Extension__r.Account_type28__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;
        if (cibilObj.CIBIL_Extension__r.Account_type29__c != null && cibilObj.CIBIL_Extension__r.Account_type29__c.toUpperCase() != 'NO DATA') tradelineCount = tradelineCount + 1;

        return tradelineCount;
    }
 
//Ended By Gulshan for count of No. of Live or Closed (PL or BL or HL or LAP or AL or CC or OTHERS)-- Bug 20245
    public integer getLiveTradeCount(Cibil__c cb) {
        System.debug('inside getLiveTradeCount'+cb);
        if (cb.Sanction_Amount1__c != null) {
            totalSanctionAmount += cb.Sanction_Amount1__c;
        }
        if (cb.Sanction_Amount2__c != null) {
            totalSanctionAmount += cb.Sanction_Amount2__c;
        }
        if (cb.Sanction_Amount3__c != null) {
            totalSanctionAmount += cb.Sanction_Amount3__c;
        }
        if (cb.Sanction_Amount4__c != null) {
            totalSanctionAmount += cb.Sanction_Amount4__c;
        }
        if (cb.Sanction_Amount5__c != null) {
            totalSanctionAmount += cb.Sanction_Amount5__c;
        }
        if (cb.Sanction_Amount6__c != null) {
            totalSanctionAmount += cb.Sanction_Amount6__c;
        }
        if (cb.Sanction_Amount7__c != null) {
            totalSanctionAmount += cb.Sanction_Amount7__c;
        }
        if (cb.Sanction_Amount8__c != null) {
            totalSanctionAmount += cb.Sanction_Amount8__c;
        }
        if (cb.Sanction_Amount9__c != null) {
            totalSanctionAmount += cb.Sanction_Amount9__c;
        }
        if (cb.Sanction_Amount10__c != null) {
            totalSanctionAmount += cb.Sanction_Amount10__c;
        }
        if (cb.Sanction_Amount11__c != null) {
            totalSanctionAmount += cb.Sanction_Amount11__c;
        }
        if (cb.Sanction_Amount12__c != null) {
            totalSanctionAmount += cb.Sanction_Amount12__c;
        }
        if (cb.Sanction_Amount13__c != null) {
            totalSanctionAmount += cb.Sanction_Amount13__c;
        }
        if (cb.Sanction_Amount14__c != null) {
            totalSanctionAmount += cb.Sanction_Amount14__c;
        }
        if (cb.Sanction_Amount15__c != null) {
            totalSanctionAmount += cb.Sanction_Amount15__c;
        }
        if (cb.Sanction_Amount16__c != null) {
            totalSanctionAmount += cb.Sanction_Amount16__c;
        }
        if (cb.Sanction_Amount17__c != null) {
            totalSanctionAmount += cb.Sanction_Amount17__c;
        }
        if (cb.Sanction_Amount18__c != null) {
            totalSanctionAmount += cb.Sanction_Amount18__c;
        }
        if (cb.Sanction_Amount19__c != null) {
            totalSanctionAmount += cb.Sanction_Amount19__c;
        }
        if (cb.Sanction_Amount__c != null) {
            totalSanctionAmount += cb.Sanction_Amount__c;
        }
        if (cb.CIBIL_Extension__r.Sanction_Amount20__c != null) totalSanctionAmount = totalSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount20__c;
        if (cb.CIBIL_Extension__r.Sanction_Amount21__c != null) totalSanctionAmount = totalSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount21__c;
        if (cb.CIBIL_Extension__r.Sanction_Amount22__c != null) totalSanctionAmount = totalSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount22__c;
        if (cb.CIBIL_Extension__r.Sanction_Amount23__c != null) totalSanctionAmount = totalSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount23__c;
        if (cb.CIBIL_Extension__r.Sanction_Amount24__c != null) totalSanctionAmount = totalSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount24__c;
        if (cb.CIBIL_Extension__r.Sanction_Amount25__c != null) totalSanctionAmount = totalSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount25__c;
        if (cb.CIBIL_Extension__r.Sanction_Amount26__c != null) totalSanctionAmount = totalSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount26__c;
        if (cb.CIBIL_Extension__r.Sanction_Amount27__c != null) totalSanctionAmount = totalSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount27__c;
        if (cb.CIBIL_Extension__r.Sanction_Amount28__c != null) totalSanctionAmount = totalSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount28__c;
        if (cb.CIBIL_Extension__r.Sanction_Amount29__c != null) totalSanctionAmount = totalSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount29__c;
        integer cnt = 0;
        System.debug('************SegmentProduct'+SegmentProduct);
                            //Bug:17470
                isPROProductLineProduct = getPROProductLineLFlag(product);
                system.debug('isPROProductLineProduct'+ isPROProductLineProduct + 'product is#'+product);
                
        //if(product!=null && SegmentProduct!=null && SegmentProduct.ToUpperCase().contains(product.ToUppercase())){
        if((product!=null && SegmentProduct!=null && SegmentProduct.ToUpperCase().contains(product.ToUppercase())) || (product!=null && (isPROProductLineProduct))){
            System.debug('********product'+product);
            
            //Rohit added for Bug 21238
            Set<Date> Last3M = new Set<Date>();
            Set<Date> Last6M = new Set<Date>();
            Set<Date> Last12M = new Set<Date>();
            //Rohit added for Bug 21238 
            
            //SAL Policy Change strat  
            // From CIBIL for 1st to 20 records 
            //Code for Number of PL enquiries in last 12 months and 6 months
            if(cb.Date_of_Enquiry__c!=null && cb.Date_of_Enquiry__c!='' && cb.Date_of_Enquiry__c!='NO DATA'){
                
                if(cb.Enquiry_Purpose__c!='NO DATA' && cb.Enquiry_Purpose__c!=null)
                {
                    Integer Date1 =  Integer.valueof(cb.Date_of_Enquiry__c.substring(0,2));
                    Integer Month = Integer.valueof(cb.Date_of_Enquiry__c.substring(2,4));
                    Integer size = cb.Date_of_Enquiry__c.length();
                    Integer Year = Integer.valueof(cb.Date_of_Enquiry__c.substring(4,size));
                    Date EnquiryDate = Date.newInstance(Year, Month, Date1);
                    system.debug('---EnquiryDate---'+EnquiryDate);
                    system.debug('---cb.CreatedDate---'+cb.CreatedDate);
                    Date CreatedDate12 = cb.CreatedDate.date();
                    CreatedDate12 = CreatedDate12.addYears(-1);
                    Date CreatedDate6 = cb.CreatedDate.date();
                    CreatedDate6 = CreatedDate6.addMonths(-6);
                    /*17138 s*/
                    Date CreatedDate3 = cb.CreatedDate.date();
                    CreatedDate3 = CreatedDate3.addMonths(-3);
                    /*17138 e*/
                    system.debug('---CreatedDate Minus 1 Year---'+CreatedDate12);
                    //17138 added and condition in below if
                    if((cb.Enquiry_Purpose__c=='Personal Loan' || (isBlPlProduct && (cb.Enquiry_Purpose__c=='Personal Loan' || cb.Enquiry_Purpose__c=='Business Loan'))) && cb.Member_Name1__c != 'BAJAJ FIN LTD'){
                        /*Bug 17138 s*/
                        if(EnquiryDate>CreatedDate3){
                            noOfPLEnquiriesIn3M++;
                            Last3M.add(EnquiryDate);
                        }
                        /*Bug 17138 e*/
                        if(EnquiryDate>CreatedDate12){
                            noOfPLEnquiriesIn12M++;
                            Last12M.add(EnquiryDate);
                        }
                        if(EnquiryDate>CreatedDate6){
                            noOfPLEnquiriesIn6M++;
                            Last6M.add(EnquiryDate);
                        }
                    }
                    if(EnquiryDate>CreatedDate12){
                        noOfEnquiriesIn12M++;
                    }
                }
            }
            if(cb.Amount_Overdue__c!=null && cb.Amount_Overdue__c!='' && cb.Amount_Overdue__c!='NO DATA'){
                sumOfAmountOverdue = sumOfAmountOverdue + Integer.valueof(cb.Amount_Overdue__c);
            }
            
            
           // System.debug('rohit '+isBlPlProduct);
            for(integer j=1;j<20;j++){
                String DateofEnquiry = 'Date_of_Enquiry'+j+'__c';
                String EnqPurpose = 'Enquiry_Purpose'+j+'__c';
                String AmountOverDue = 'Amount_Overdue'+j+'__c';
                Integer z = j+1; //Bug 17138
                String MemberName = 'Member_Name'+z+'__c'; //Bug 17138
                //c.get(fieldname);
                if(cb.get(DateofEnquiry)!=null){
                    if(cb.get(EnqPurpose)!='NO DATA' && cb.get(EnqPurpose)!=null)
                    {
                        String DateofEnq = String.valueof(cb.get(DateofEnquiry));
                        Integer Date1 =  Integer.valueof(DateofEnq.substring(0,2));
                        Integer Month = Integer.valueof(DateofEnq.substring(2,4));
                        Integer size = DateofEnq.length();
                        Integer Year = Integer.valueof(DateofEnq.substring(4,size));
                        Date EnquiryDate = Date.newInstance(Year, Month, Date1);
                        system.debug('---EnquiryDate---'+EnquiryDate);
                        system.debug('---cb.CreatedDate---'+cb.CreatedDate);
                        Date CreatedDate12 = cb.CreatedDate.date();
                        CreatedDate12 = CreatedDate12.addYears(-1);
                        Date CreatedDate6 = cb.CreatedDate.date();
                        CreatedDate6 = CreatedDate6.addMonths(-6);
                        /*17138 s*/
                        Date CreatedDate3 = cb.CreatedDate.date();
                        CreatedDate3 = CreatedDate3.addMonths(-3);
                        /*17138 e*/

                        system.debug('---CreatedDate Minus 1 Year---'+CreatedDate12);
                        system.debug('---CreatedDate Minus 6 Months---'+(EnquiryDate>CreatedDate3)+'---'+EnquiryDate+'---> '+CreatedDate3+'---'+MemberName);
                        //Rohit added BL/PL condition for 21238
                        if((cb.get(EnqPurpose)=='Personal Loan' || (isBlPlProduct && (cb.get(EnqPurpose)=='Personal Loan' || cb.get(EnqPurpose)=='Business Loan')) ) && cb.get(MemberName) != 'BAJAJ FIN LTD'){ //Bug 17138 added and condition){
                            if(EnquiryDate>CreatedDate12){
                                noOfPLEnquiriesIn12M++;
                                //Rohit added for 21238
                                Last12M.add(EnquiryDate);
                            }
                            if(EnquiryDate>CreatedDate6){
                                noOfPLEnquiriesIn6M++;
                                //Rohit added for 21238
                                Last6M.add(EnquiryDate);
                            }
                            /*Bug 17138 s*/
                            if(EnquiryDate>CreatedDate3){
                                noOfPLEnquiriesIn3M++;
                                //Rohit added for 21238
                                Last3M.add(EnquiryDate);
                            }
                            /*Bug 17138 e*/
                        }
                        if(EnquiryDate>CreatedDate12){
                            noOfEnquiriesIn12M++;
                        }
                    }
                }
                if(cb.get(AmountOverDue)!=null && cb.get(AmountOverDue)!='' && cb.get(AmountOverDue)!='NO DATA'){
                    sumOfAmountOverdue = sumOfAmountOverdue + Integer.valueof(cb.get(AmountOverDue));
                }
            }
            
            
            
            
            //From CIBIL Ext 
            
            // From CIBIL for 21st to 30 records
            //Code for Number of PL enquiries in last 12 months and 6 months
            for(integer j=20;j<30;j++){
                String DateofEnquiry = 'Date_of_Enquiry'+j+'__c';
                String EnqPurpose = 'Enquiry_Purpose'+j+'__c';
                String AmountOverDue = 'Amount_Overdue'+j+'__c';
                Integer z = j+1; //Bug 17138
                String MemberName = 'Member_Name'+z+'__c'; //Bug 17138
                //c.get(fieldname);
                if(cb.CIBIL_Extension__r.get(DateofEnquiry)!=null){
                    if(cb.CIBIL_Extension__r.get(EnqPurpose)!='NO DATA' && cb.CIBIL_Extension__r.get(EnqPurpose)!=null)
                    {
                        
                        String DateofEnq = String.valueof(cb.CIBIL_Extension__r.get(DateofEnquiry));
                        Integer Date1 =  Integer.valueof(DateofEnq.substring(0,2));
                        Integer Month = Integer.valueof(DateofEnq.substring(2,4));
                        Integer size = DateofEnq.length();
                        Integer Year = Integer.valueof(DateofEnq.substring(4,size));
                        Date EnquiryDate = Date.newInstance(Year, Month, Date1);
                        system.debug('---EnquiryDate---'+EnquiryDate);
                        system.debug('---cb.CIBIL_Extension__r.CreatedDate---'+cb.CIBIL_Extension__r.CreatedDate);
                        Date CreatedDate12 = cb.CIBIL_Extension__r.CreatedDate.date();
                        CreatedDate12 = CreatedDate12.addYears(-1);
                        Date CreatedDate6 = cb.CIBIL_Extension__r.CreatedDate.date();
                        CreatedDate6 = CreatedDate6.addMonths(-6);
                        /*17138 s*/
                        Date CreatedDate3 = cb.CreatedDate.date();
                        CreatedDate3 = CreatedDate3.addMonths(-3);
                        /*17138 e*/

                        system.debug('---CreatedDate Minus 1 Year---'+CreatedDate12);
                        system.debug('---CreatedDate Minus 6 Months---'+(EnquiryDate>CreatedDate3)+'---'+EnquiryDate+'---> '+CreatedDate3);
                        //Rohit added BL/PL condition for 21238
                        if((cb.CIBIL_Extension__r.get(EnqPurpose)=='Personal Loan' || (isBlPlProduct && (cb.get(EnqPurpose)=='Personal Loan' || cb.get(EnqPurpose)=='Business Loan')))){
                            if(EnquiryDate>CreatedDate12 && cb.get(MemberName) != 'BAJAJ FIN LTD'){//Bug 17138 added and cond){
                                noOfPLEnquiriesIn12M++;
                                //Rohit added for 21238
                                Last12M.add(EnquiryDate);
                            }
                            if(EnquiryDate>CreatedDate6 ||(isBlPlProduct && cb.get(MemberName) != 'BAJAJ FIN LTD')){
                                noOfPLEnquiriesIn6M++;
                                //Rohit added for 21238
                                Last6M.add(EnquiryDate);
                            }
                            /*Bug 17138 s*/
                            if(EnquiryDate>CreatedDate3 ||(isBlPlProduct && cb.get(MemberName) != 'BAJAJ FIN LTD')){
                                noOfPLEnquiriesIn3M++;
                                //Rohit added for 21238
                                Last3M.add(EnquiryDate);
                            }
                            /*Bug 17138 e*/
                        }
                        if(EnquiryDate>CreatedDate12){
                            noOfEnquiriesIn12M++;
                        }
                    }
                }
                
                if(cb.CIBIL_Extension__r.get(AmountOverDue)!=null && cb.CIBIL_Extension__r.get(AmountOverDue)!='' && cb.CIBIL_Extension__r.get(AmountOverDue)!='NO DATA'){
                    sumOfAmountOverdue = sumOfAmountOverdue + Integer.valueof(cb.CIBIL_Extension__r.get(AmountOverDue));
                }
            }
            //Rohit added for Bug 21238 start
            if(isBlPlProduct){
                noOfPLEnquiriesIn12M = Last12M.size();
                noOfPLEnquiriesIn6M = Last6M.size();
                noOfPLEnquiriesIn3M =  Last3M.size();
            
            }
            //Rohit added for Bug 21238 stop
            system.debug('---noOfPLEnquiriesIn12M---'+Last6M);
            system.debug('---noOfPLEnquiriesIn3M---'+Last3M);
            system.debug('---sumOfAmountOverdue---'+sumOfAmountOverdue);
            
            //SAL Policy Change End
            
            //SAL Policy Rule Changes :: Added by Pritha :: for PL Live Account start
            //In Cibil OBJECT
            
            if(cb.Account_Type__c=='Personal Loan' && cb.Date_Closed__c == null){
                noOfLivePL_Cib_ext1++;
            }
            for(integer j=1;j<20;j++){
                String AccountType = 'Account_Type'+j+'__c';
                String DateClosed = 'Date_Closed'+j+'__c';
                if(cb.get(AccountType)=='Personal Loan' && cb.get(DateClosed) == null){
                    noOfLivePL_Cib_ext1++;
                }
            }
            
            //In Cibil Extension Object
            for(integer j=20;j<30;j++){
                String AccountType = 'Account_Type'+j+'__c';
                String DateClosed = 'Date_Closed'+j+'__c';
                if(cb.CIBIL_Extension__r.get(AccountType)=='Personal Loan' && cb.CIBIL_Extension__r.get(DateClosed) == null){
                    noOfLivePL_Cib_ext1++;
                }
                system.debug('---noOfLivePL_Cib_ext1---'+noOfLivePL_Cib_ext1);
            }
            
            
            //SAL Policy Rule Changes :: Added by Pritha end
            
            /*POS_PO-16621 starts */
            //POS_disbursal-rule9 and CR 23551 S 
            // User story 760 Static Resource implimented for account type                   
            StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'cibilRule9AccountTypes' LIMIT 1];
            if(sr != null){
                String strBody = sr.Body.toString();
                if (strBody != null && !string.isBlank(strBody)){     
                    system.debug('@@1'+strBody);            
                    List<String> accType = strBody.split(';');  
                    system.debug('@@2'+accType.size());  
                    
                    system.debug('@@3AccType::'+cb.Account_Type__c );
                    system.debug('@@4contains::'+accType.contains(cb.Account_Type__c ));
                    if(accType.contains(cb.Account_Type__c ) && cb.Date_Closed__c == null && cb.Member__c.ToUpperCase()=='BAJAJ FIN LTD'){   
                        noOfLivePL_BL_Cib_ext1++;
                    }
                    for(integer j=1;j<20;j++){
                        String AccountType = 'Account_Type'+j+'__c';
                        String DateClosed = 'Date_Closed'+j+'__c';
                        String Member = 'Member'+j+'__c';
                        if(accType.contains(String.valueOf(cb.get(AccountType)))&& cb.get(DateClosed) == null && String.ValueOf(cb.get(Member)).ToUpperCase()=='BAJAJ FIN LTD' ){
                            noOfLivePL_BL_Cib_ext1++;
                        }
                    }
                    //In Cibil Extension Object
                    for(integer j=20;j<30;j++){
                        String AccountType = 'Account_Type'+j+'__c';
                        String DateClosed = 'Date_Closed'+j+'__c';
                        String Member = 'Member'+j+'__c';
                        if(accType.contains(String.valueOf(cb.CIBIL_Extension__r.get(AccountType))) && cb.CIBIL_Extension__r.get(DateClosed) == null && String.valueOf(cb.CIBIL_Extension__r.get(Member)).ToUpperCase()=='BAJAJ FIN LTD'){
                            noOfLivePL_BL_Cib_ext1++;
                        }
                        system.debug('---noOfLivePL_BL_Cib_ext1---'+noOfLivePL_BL_Cib_ext1);
                    }
                }
            }
            //POS_disbursal-rule9 ends and CR 23551 E 
            /* POS_PO-16621 ends */
                    
            if (cb.Date_Closed__c == null) {
                if(cb.Account_Type__c != 'NO DATA' && cb.Date_Opened__c!=null)
                cnt++;
                if(cb.Current_Balance__c!=null)
                totalBalance += cb.Current_Balance__c;
            } 
            if (cb.Date_Closed1__c == null) {
                if(cb.Account_Type1__c != 'NO DATA' && cb.Date_Opened1__c!=null)
                cnt++;
                if(cb.Current_Balance1__c!=null)
                totalBalance += cb.Current_Balance1__c;
            }
            if (cb.Date_Closed2__c == null) {
                if(cb.Account_Type2__c != 'NO DATA' && cb.Date_Opened2__c!=null)
                cnt++;
                if(cb.Current_Balance2__c!=null) 
                totalBalance += cb.Current_Balance2__c;
            }
            if (cb.Date_Closed3__c == null) {
                if(cb.Account_Type3__c != 'NO DATA' && cb.Date_Opened3__c!=null)
                cnt++;
                if(cb.Current_Balance3__c!=null)  
                totalBalance += cb.Current_Balance3__c;
            }
            if (cb.Date_Closed4__c == null) {
                if(cb.Account_Type4__c != 'NO DATA' && cb.Date_Opened4__c!=null)
                cnt++;
                if(cb.Current_Balance4__c!=null)       
                totalBalance += cb.Current_Balance4__c;
            }
            if (cb.Date_Closed5__c == null ) {
                if(cb.Account_Type5__c != 'NO DATA' && cb.Date_Opened5__c!=null)
                cnt++;
                if(cb.Current_Balance5__c!=null)   
                totalBalance += cb.Current_Balance5__c;
            }
            if (cb.Date_Closed6__c == null) {
                if(cb.Account_Type6__c != 'NO DATA' && cb.Date_Opened6__c!=null)  
                cnt++;
                if(cb.Current_Balance6__c!=null)     
                totalBalance += cb.Current_Balance6__c;
            }
            if (cb.Date_Closed7__c == null) {
                if(cb.Account_Type7__c != 'NO DATA' && cb.Date_Opened7__c!=null)  
                cnt++;
                if(cb.Current_Balance7__c!=null)    
                totalBalance += cb.Current_Balance7__c;
            }
            if (cb.Date_Closed8__c == null) {
                if(cb.Account_Type8__c != 'NO DATA' && cb.Date_Opened8__c!=null)  
                cnt++;
                if(cb.Current_Balance8__c!=null) 
                totalBalance += cb.Current_Balance8__c;
            }
            if (cb.Date_Closed9__c == null) {
                if(cb.Account_Type9__c != 'NO DATA' && cb.Date_Opened9__c!=null)  
                cnt++;
                if(cb.Current_Balance9__c !=null) 
                totalBalance += cb.Current_Balance9__c;
            }
            if (cb.Date_Closed10__c == null ) {
                if(cb.Account_Type10__c != 'NO DATA' && cb.Date_Opened10__c!=null)  
                cnt++;
                if(cb.Current_Balance10__c!=null) 
                totalBalance += cb.Current_Balance10__c;
            }
            if (cb.Date_Closed11__c == null) {
                if(cb.Account_Type11__c != 'NO DATA' && cb.Date_Opened11__c!=null)  
                cnt++;
                if(cb.Current_Balance11__c !=null) 
                totalBalance += cb.Current_Balance11__c;
            }
            if (cb.Date_Closed12__c == null && cb.Current_Balance12__c > 1000) {
                if(cb.Account_Type12__c != 'NO DATA' && cb.Date_Opened12__c!=null)  
                cnt++;
                if(cb.Current_Balance12__c !=null) 
                totalBalance += cb.Current_Balance12__c;
            }
            if (cb.Date_Closed13__c == null && cb.Current_Balance13__c > 1000) {
                if(cb.Account_Type13__c != 'NO DATA' && cb.Date_Opened13__c!=null)  
                cnt++;
                if(cb.Current_Balance13__c !=null) 
                totalBalance += cb.Current_Balance13__c;
            }
            if (cb.Date_Closed14__c == null) {
                if(cb.Account_Type14__c != 'NO DATA' && cb.Date_Opened14__c!=null)  
                cnt++;
                if(cb.Current_Balance14__c !=null) 
                totalBalance += cb.Current_Balance14__c;
            }
            if (cb.Date_Closed15__c == null) {
                if(cb.Account_Type15__c != 'NO DATA' && cb.Date_Opened15__c!=null)  
                cnt++;
                if(cb.Current_Balance15__c !=null) 
                totalBalance += cb.Current_Balance15__c;
            }
            if (cb.Date_Closed16__c == null ) {
                if(cb.Account_Type16__c != 'NO DATA' && cb.Date_Opened16__c!=null)  
                cnt++;
                if(cb.Current_Balance16__c !=null) 
                totalBalance += cb.Current_Balance16__c;
            }
            if (cb.Date_Closed17__c == null ) {
                if(cb.Account_Type17__c != 'NO DATA' && cb.Date_Opened17__c!=null)  
                cnt++;
                if(cb.Current_Balance17__c !=null) 
                totalBalance += cb.Current_Balance17__c;
            }
            if (cb.Date_Closed18__c == null) {
                if(cb.Account_Type18__c != 'NO DATA' && cb.Date_Opened18__c!=null)  
                cnt++;
                if(cb.Current_Balance18__c !=null) 
                totalBalance += cb.Current_Balance18__c;
            }
            if (cb.Date_Closed19__c == null) {
                if(cb.Account_Type19__c != 'NO DATA' && cb.Date_Opened19__c!=null)  
                cnt++;
                if(cb.Current_Balance19__c !=null) 
                totalBalance += cb.Current_Balance19__c;
            }
            System.debug('cibil extension'+cb.CIBIL_Extension__c);
            if (cb.CIBIL_Extension__c != null) {
                System.debug('date '+cb.CIBIL_Extension__r.Date_Closed20__c);
                if (cb.CIBIL_Extension__r.Date_Closed20__c == null) {
                    if(cb.CIBIL_Extension__r.Account_Type20__c != 'NO DATA' && cb.CIBIL_Extension__r.Date_Opened20__c!=null)  
                    cnt++;
                    if(cb.CIBIL_Extension__r.Current_Balance20__c!=null)
                    totalBalance += cb.CIBIL_Extension__r.Current_Balance20__c;
                }
                if (cb.CIBIL_Extension__r.Date_Closed21__c == null && cb.CIBIL_Extension__r.Current_Balance21__c > 1000) {
                    if(cb.CIBIL_Extension__r.Account_Type21__c != 'NO DATA' && cb.CIBIL_Extension__r.Date_Opened21__c!=null)  
                    cnt++;
                    if(cb.CIBIL_Extension__r.Current_Balance21__c !=null)
                    totalBalance += cb.CIBIL_Extension__r.Current_Balance21__c;
                }
                if (cb.CIBIL_Extension__r.Date_Closed22__c == null && cb.CIBIL_Extension__r.Current_Balance22__c > 1000) {
                    if(cb.CIBIL_Extension__r.Account_Type22__c != 'NO DATA' && cb.CIBIL_Extension__r.Date_Opened22__c!=null)  
                    cnt++;
                    if(cb.CIBIL_Extension__r.Current_Balance22__c !=null)
                    totalBalance += cb.CIBIL_Extension__r.Current_Balance22__c;
                }
                if (cb.CIBIL_Extension__r.Date_Closed23__c == null && cb.CIBIL_Extension__r.Current_Balance23__c > 1000) {
                    if(cb.CIBIL_Extension__r.Account_Type23__c != 'NO DATA' && cb.CIBIL_Extension__r.Date_Opened23__c!=null)  
                    cnt++;
                    if(cb.CIBIL_Extension__r.Current_Balance23__c !=null)
                    totalBalance += cb.CIBIL_Extension__r.Current_Balance23__c;
                }
                if (cb.CIBIL_Extension__r.Date_Closed24__c == null && cb.CIBIL_Extension__r.Current_Balance24__c > 1000) {
                    if(cb.CIBIL_Extension__r.Account_Type24__c != 'NO DATA' && cb.CIBIL_Extension__r.Date_Opened24__c!=null)  
                    cnt++;
                    if(cb.CIBIL_Extension__r.Current_Balance24__c !=null)
                    totalBalance += cb.CIBIL_Extension__r.Current_Balance24__c;
                }
                if (cb.CIBIL_Extension__r.Date_Closed25__c == null) {
                    if(cb.CIBIL_Extension__r.Account_Type25__c != 'NO DATA' && cb.CIBIL_Extension__r.Date_Opened25__c!=null)  
                    cnt++;
                    if(cb.CIBIL_Extension__r.Current_Balance25__c !=null)
                    totalBalance += cb.CIBIL_Extension__r.Current_Balance25__c;
                }
                if (cb.CIBIL_Extension__r.Date_Closed26__c == null) {
                    if(cb.CIBIL_Extension__r.Account_Type26__c != 'NO DATA' && cb.CIBIL_Extension__r.Date_Opened26__c!=null)  
                    cnt++;
                    if(cb.CIBIL_Extension__r.Current_Balance26__c !=null)
                    totalBalance += cb.CIBIL_Extension__r.Current_Balance26__c; 
                }
                if (cb.CIBIL_Extension__r.Date_Closed27__c == null) {
                    if(cb.CIBIL_Extension__r.Account_Type27__c != 'NO DATA' && cb.CIBIL_Extension__r.Date_Opened27__c!=null)  
                    cnt++;
                    if(cb.CIBIL_Extension__r.Current_Balance27__c !=null)
                    totalBalance += cb.CIBIL_Extension__r.Current_Balance27__c;
                }
                if (cb.CIBIL_Extension__r.Date_Closed28__c == null) {
                    if(cb.CIBIL_Extension__r.Account_Type28__c != 'NO DATA' && cb.CIBIL_Extension__r.Date_Opened28__c!=null)  
                    cnt++;
                    if(cb.CIBIL_Extension__r.Current_Balance28__c !=null)
                    totalBalance += cb.CIBIL_Extension__r.Current_Balance28__c;
                }
                if (cb.CIBIL_Extension__r.Date_Closed29__c == null) {
                    if(cb.CIBIL_Extension__r.Account_Type29__c != 'NO DATA' && cb.CIBIL_Extension__r.Date_Opened29__c!=null)  
                    cnt++;
                    if(cb.CIBIL_Extension__r.Current_Balance29__c !=null)
                    totalBalance += cb.CIBIL_Extension__r.Current_Balance29__c;
                }
            }
            
        }
        else{
            if (cb.Date_Closed__c == null && cb.Current_Balance__c > 1000) {
                cnt++;
                totalBalance += cb.Current_Balance__c;
            }
            if (cb.Date_Closed1__c == null && cb.Current_Balance1__c > 1000) {
                cnt++;
                totalBalance += cb.Current_Balance1__c;
            }
            if (cb.Date_Closed2__c == null && cb.Current_Balance2__c > 1000) {
                cnt++;
                totalBalance += cb.Current_Balance2__c;
            }
            if (cb.Date_Closed3__c == null && cb.Current_Balance3__c > 1000) {
                cnt++;
                totalBalance += cb.Current_Balance3__c;
            }
            if (cb.Date_Closed4__c == null && cb.Current_Balance4__c > 1000) { 
                cnt++;
                totalBalance += cb.Current_Balance4__c;
            }
            if (cb.Date_Closed5__c == null && cb.Current_Balance5__c > 1000) {
                cnt++;
                if(cb.Current_Balance__c > 1000)
                totalBalance += cb.Current_Balance5__c;
            }
            if (cb.Date_Closed6__c == null && cb.Current_Balance6__c > 1000) {
                cnt++;
                totalBalance += cb.Current_Balance6__c;
            }
            if (cb.Date_Closed7__c == null && cb.Current_Balance7__c > 1000) {
                cnt++;
                totalBalance += cb.Current_Balance7__c;
            }
            if (cb.Date_Closed8__c == null && cb.Current_Balance8__c > 1000) {
                cnt++;
                totalBalance += cb.Current_Balance8__c;
            }
            if (cb.Date_Closed9__c == null && cb.Current_Balance9__c > 1000) {
                cnt++;
                totalBalance += cb.Current_Balance9__c;
            }
            if (cb.Date_Closed10__c == null && cb.Current_Balance10__c > 1000) {
                cnt++;
                totalBalance += cb.Current_Balance10__c;
            }
            if (cb.Date_Closed11__c == null && cb.Current_Balance11__c > 1000) {
                cnt++;
                totalBalance += cb.Current_Balance11__c;
            }
            if (cb.Date_Closed12__c == null && cb.Current_Balance12__c > 1000) {
                cnt++;
                totalBalance += cb.Current_Balance12__c;
            }
            if (cb.Date_Closed13__c == null && cb.Current_Balance13__c > 1000) {
                cnt++;
                totalBalance += cb.Current_Balance13__c;
            }
            if (cb.Date_Closed14__c == null && cb.Current_Balance14__c > 1000) {
                cnt++;
                totalBalance += cb.Current_Balance14__c;
            }
            if (cb.Date_Closed15__c == null && cb.Current_Balance15__c > 1000) {
                cnt++;
                totalBalance += cb.Current_Balance15__c;
            }
            if (cb.Date_Closed16__c == null && cb.Current_Balance16__c > 1000) {
                cnt++;
                totalBalance += cb.Current_Balance16__c;
            }
            if (cb.Date_Closed17__c == null && cb.Current_Balance17__c > 1000) {
                cnt++;
                totalBalance += cb.Current_Balance17__c;
            }
            if (cb.Date_Closed18__c == null && cb.Current_Balance18__c > 1000) {
                cnt++;
                totalBalance += cb.Current_Balance18__c;
            }
            if (cb.Date_Closed19__c == null && cb.Current_Balance19__c > 1000) {
                cnt++;
                totalBalance += cb.Current_Balance19__c;
            }
            if (cb.CIBIL_Extension__c != null) {
                if (cb.CIBIL_Extension__r.Date_Closed20__c == null && cb.CIBIL_Extension__r.Current_Balance20__c > 1000) {
                    cnt++;
                    totalBalance += cb.CIBIL_Extension__r.Current_Balance20__c;
                }
                if (cb.CIBIL_Extension__r.Date_Closed21__c == null && cb.CIBIL_Extension__r.Current_Balance21__c > 1000) {
                    cnt++;
                    totalBalance += cb.CIBIL_Extension__r.Current_Balance21__c;
                }
                if (cb.CIBIL_Extension__r.Date_Closed22__c == null && cb.CIBIL_Extension__r.Current_Balance22__c > 1000) {
                    cnt++;
                    totalBalance += cb.CIBIL_Extension__r.Current_Balance22__c;
                }
                if (cb.CIBIL_Extension__r.Date_Closed23__c == null && cb.CIBIL_Extension__r.Current_Balance23__c > 1000) {
                    cnt++;
                    totalBalance += cb.CIBIL_Extension__r.Current_Balance23__c;
                }
                if (cb.CIBIL_Extension__r.Date_Closed24__c == null && cb.CIBIL_Extension__r.Current_Balance24__c > 1000) {
                    cnt++;
                    totalBalance += cb.CIBIL_Extension__r.Current_Balance24__c;
                }
                if (cb.CIBIL_Extension__r.Date_Closed25__c == null && cb.CIBIL_Extension__r.Current_Balance25__c > 1000) {
                    cnt++;
                    totalBalance += cb.CIBIL_Extension__r.Current_Balance25__c;
                }
                if (cb.CIBIL_Extension__r.Date_Closed26__c == null && cb.CIBIL_Extension__r.Current_Balance26__c > 1000) {
                    cnt++;
                    totalBalance += cb.CIBIL_Extension__r.Current_Balance26__c;
                }
                if (cb.CIBIL_Extension__r.Date_Closed27__c == null && cb.CIBIL_Extension__r.Current_Balance27__c > 1000) {
                    cnt++;
                    totalBalance += cb.CIBIL_Extension__r.Current_Balance27__c;
                }
                if (cb.CIBIL_Extension__r.Date_Closed28__c == null && cb.CIBIL_Extension__r.Current_Balance28__c > 1000) {
                    cnt++;
                    totalBalance += cb.CIBIL_Extension__r.Current_Balance28__c;
                }
                if (cb.CIBIL_Extension__r.Date_Closed29__c == null && cb.CIBIL_Extension__r.Current_Balance29__c > 1000) {
                    cnt++;
                    totalBalance += cb.CIBIL_Extension__r.Current_Balance29__c;
                }
            }
        }
        return cnt;
    }
 /* POS_PO-16621 starts */
 //POS Rule 6
    public Map<String,Integer> getUnsecuredLoanCount(Cibil__c cb) { 
        ATOSParameters__c unsecured = new ATOSParameters__c();
        String unsecuredLoans = '';
        system.debug('&&&&product&::: '+product);
        if(product!=null && SegmentProduct!=null && SegmentProduct.ToUpperCase().contains(product.ToUppercase())){
            unsecured = ATOSParameters__c.getValues('SegmentationUnSecuredLoan');
            system.debug('&&&&unsecured &::: '+unsecured );
        }else{
            unsecured = ATOSParameters__c.getValues('Unsecured');
        }
        if (unsecured != null && unsecured.value__c != null) {
            unsecuredLoans = unsecured.value__c;
        }
        //POS_disbursal--created unsecuredLoanCntMap for storing 12  months and 6 months
        Map<String,Integer> unsecuredLoanCntMap = new Map<String,Integer>();
        unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',0);
        unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',0);
        system.debug('&&&&unsecuredLoans &'+unsecuredLoans);
        system.debug('&&&&unsecuredTLCnt count :: '+unsecuredTLCnt);
        if (cb.Account_Type__c != null && unsecuredLoans.indexOf(cb.Account_Type__c) != -1) {
            unsecuredTLCnt++;
            system.debug('&&&&in 1st if&'+unsecuredTLCnt);
        }
        if (cb.Account_Type__c != null && unsecuredLoans.indexOf(cb.Account_Type__c) != -1) {
            
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened__c != null && cb.Date_Opened__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened__c != null && cb.Date_Opened__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.Account_Type__c!='Credit Card' && cb.Date_Closed__c == null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
            
            if (cb.Date_Closed__c == null && cb.Current_Balance__c != null && cb.Current_Balance__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.Current_Balance__c;
                if (cb.Sanction_Amount__c != null && cb.CIBIL_Fired_time__c != null && cb.Date_Opened__c != null && cb.Date_Opened__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.Sanction_Amount__c;
                if (cb.Sanction_Amount__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.Sanction_Amount__c;
            } else if (cb.Sanction_Amount__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.Sanction_Amount__c;
        }
        /*SAL Optimization added by Krish s*/
        for(integer j=1;j<20;j++){
            String accountType = 'Account_Type'+j+'__c';
            String dateClosed = 'Date_Closed'+j+'__c';
            String dateOp = 'Date_Opened'+j+'__c';
            String currBal = 'Current_Balance'+j+'__c';
            String sancAmt = 'Sanction_Amount'+j+'__c';
            String ownership = 'Ownership'+j+'__c';
            if (cb.get(accountType) != null && unsecuredLoans.indexOf((String)cb.get(accountType)) != -1) {
                unsecuredTLCnt++;
                system.debug('&&&&in 2t if&'+unsecuredTLCnt);
            }
            if (cb.get(accountType) != null && unsecuredLoans.indexOf((String)cb.get(accountType)) != -1) {
                
                if (cb.CIBIL_Fired_time__c != null && cb.get(dateOp) != null && date.valueOf(cb.get(dateOp)).monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
                {
                    Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                    temp++;
                    unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
                }
                if (cb.CIBIL_Fired_time__c != null && cb.get(dateOp) != null && date.valueOf(cb.get(dateOp)).monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.get(accountType)!='Credit Card' && cb.get(dateClosed)==null)
                {
                    Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                    temp++;
                    unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
                }
                if (cb.get(dateClosed) == null && Integer.valueof(cb.get(currBal)) != null && Integer.valueof(cb.get(currBal)) > 1000) {
                    liveUnsecuredLoanCnt++;
                    unsecuredCurrentBalance = unsecuredCurrentBalance + Integer.valueof(cb.get(currBal));
                    if (cb.get(sancAmt) != null && cb.CIBIL_Fired_time__c != null && cb.get(dateOp) != null && Date.valueof(cb.get(dateOp)).monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + Integer.valueof(cb.get(sancAmt));
                    if (cb.get(sancAmt) != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + Integer.valueof(cb.get(sancAmt));
                } else if (cb.get(sancAmt) != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + Integer.valueof(cb.get(sancAmt));
            }
        }
        for(integer j=20;j<30;j++){
            String accountType = 'Account_Type'+j+'__c';
            String dateClosed = 'Date_Closed'+j+'__c';
            String dateOp = 'Date_Opened'+j+'__c';
            String currBal = 'Current_Balance'+j+'__c';
            String sancAmt = 'Sanction_Amount'+j+'__c';
            String ownership = 'Ownership'+j+'__c';
            if (cb.Cibil_Extension__r.get(accountType) != null && unsecuredLoans.indexOf((String)cb.Cibil_Extension__r.get(accountType)) != -1) {
                unsecuredTLCnt++;
                system.debug('&&&&in 2t if&'+unsecuredTLCnt);
            }
            if (cb.Cibil_Extension__r.get(accountType) != null && unsecuredLoans.indexOf((String)cb.Cibil_Extension__r.get(accountType)) != -1) {
                
                if (cb.CIBIL_Fired_time__c != null && cb.Cibil_Extension__r.get(dateOp) != null && Date.valueof(cb.Cibil_Extension__r.get(dateOp)).monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
                {
                    Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                    temp++;
                    unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
                }
                if (cb.CIBIL_Fired_time__c != null && cb.Cibil_Extension__r.get(dateOp) != null && Date.valueof(cb.Cibil_Extension__r.get(dateOp)).monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.Cibil_Extension__r.get(accountType)!='Credit Card' && cb.Cibil_Extension__r.get(dateClosed)==null)
                {
                    Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                    temp++;
                    unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
                }
                if (cb.Cibil_Extension__r.get(dateClosed) == null && Integer.valueof(cb.Cibil_Extension__r.get(currBal)) != null && Integer.valueof(cb.Cibil_Extension__r.get(currBal)) > 1000) {
                    liveUnsecuredLoanCnt++;
                    unsecuredCurrentBalance = unsecuredCurrentBalance + Integer.valueof(cb.Cibil_Extension__r.get(currBal));
                    if (cb.Cibil_Extension__r.get(sancAmt) != null && cb.CIBIL_Fired_time__c != null && cb.Cibil_Extension__r.get(dateOp) != null && Date.valueof(cb.Cibil_Extension__r.get(dateOp)).monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + Integer.valueof(cb.Cibil_Extension__r.get(sancAmt));
                    if (cb.Cibil_Extension__r.get(sancAmt) != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + Integer.valueof(cb.Cibil_Extension__r.get(sancAmt));
                } else if (cb.Cibil_Extension__r.get(sancAmt) != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + Integer.valueof(cb.Cibil_Extension__r.get(sancAmt));
            }
            
        }
        /*SAL Optimization added by Krish s*/
        /*if (cb.Account_Type1__c != null && unsecuredLoans.indexOf(cb.Account_Type1__c) != -1) {
            unsecuredTLCnt++;
            system.debug('&&&&in 2t if&'+unsecuredTLCnt);
        }
        if (cb.Account_Type1__c != null && unsecuredLoans.indexOf(cb.Account_Type1__c) != -1) {
            
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened1__c != null && cb.Date_Opened1__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened1__c != null && cb.Date_Opened1__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.Ownership1__c!='Credit Card' && cb.Date_Closed1__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
            if (cb.Date_Closed1__c == null && cb.Current_Balance1__c != null && cb.Current_Balance1__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.Current_Balance1__c;
                if (cb.Sanction_Amount1__c != null && cb.CIBIL_Fired_time__c != null && cb.Date_Opened1__c != null && cb.Date_Opened1__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.Sanction_Amount1__c;
                if (cb.Sanction_Amount1__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.Sanction_Amount1__c;
            } else if (cb.Sanction_Amount1__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.Sanction_Amount1__c;
        }
        if (cb.Account_Type2__c != null && unsecuredLoans.indexOf(cb.Account_Type2__c) != -1) {
            unsecuredTLCnt++;
            system.debug('&&&&i3rdst if&'+unsecuredTLCnt);
        }
        if (cb.Account_Type2__c != null && unsecuredLoans.indexOf(cb.Account_Type2__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened2__c != null && cb.Date_Opened2__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened2__c != null && cb.Date_Opened2__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.Ownership2__c!='Credit Card' && cb.Date_Closed2__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }

        if (cb.Date_Closed2__c == null && cb.Current_Balance2__c != null && cb.Current_Balance2__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.Current_Balance2__c;
                if (cb.Sanction_Amount2__c != null && cb.CIBIL_Fired_time__c != null && cb.Date_Opened2__c != null && cb.Date_Opened2__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.Sanction_Amount2__c;
                if (cb.Sanction_Amount2__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.Sanction_Amount2__c;
            } else if (cb.Sanction_Amount2__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.Sanction_Amount2__c;
        }
        if (cb.Account_Type3__c != null && unsecuredLoans.indexOf(cb.Account_Type3__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.Account_Type3__c != null && unsecuredLoans.indexOf(cb.Account_Type3__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened3__c != null && cb.Date_Opened3__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened3__c != null && cb.Date_Opened3__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.Ownership3__c!='Credit Card' && cb.Date_Closed3__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }

            if (cb.Date_Closed3__c == null && cb.Current_Balance3__c != null && cb.Current_Balance3__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.Current_Balance3__c;
                if (cb.Sanction_Amount3__c != null && cb.CIBIL_Fired_time__c != null && cb.Date_Opened3__c != null && cb.Date_Opened3__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.Sanction_Amount3__c;
                if (cb.Sanction_Amount3__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.Sanction_Amount3__c;
            } else if (cb.Sanction_Amount3__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.Sanction_Amount3__c;
        }
        if (cb.Account_Type4__c != null && unsecuredLoans.indexOf(cb.Account_Type4__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.Account_Type4__c != null && unsecuredLoans.indexOf(cb.Account_Type4__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened4__c != null && cb.Date_Opened4__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened4__c != null && cb.Date_Opened4__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.Ownership4__c!='Credit Card' && cb.Date_Closed4__c!=null)
            {
           
    Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
        if (cb.Date_Closed4__c == null && cb.Current_Balance4__c != null && cb.Current_Balance4__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.Current_Balance4__c;
                if (cb.Sanction_Amount4__c != null && cb.CIBIL_Fired_time__c != null && cb.Date_Opened4__c != null && cb.Date_Opened4__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.Sanction_Amount4__c;
                if (cb.Sanction_Amount4__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.Sanction_Amount4__c;
            } else if (cb.Sanction_Amount4__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.Sanction_Amount4__c;
        }
        if (cb.Account_Type5__c != null && unsecuredLoans.indexOf(cb.Account_Type5__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.Account_Type5__c != null && unsecuredLoans.indexOf(cb.Account_Type5__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened5__c != null && cb.Date_Opened5__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
               
            }
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened5__c != null && cb.Date_Opened5__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.Ownership5__c!='Credit Card' && cb.Date_Closed5__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
        
        if (cb.Date_Closed5__c == null && cb.Current_Balance5__c != null && cb.Current_Balance5__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.Current_Balance5__c;
                if (cb.Sanction_Amount5__c != null && cb.CIBIL_Fired_time__c != null && cb.Date_Opened5__c != null && cb.Date_Opened5__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.Sanction_Amount5__c;
                if (cb.Sanction_Amount5__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.Sanction_Amount5__c;
            } else if (cb.Sanction_Amount5__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.Sanction_Amount5__c;
        }
        if (cb.Account_Type6__c != null && unsecuredLoans.indexOf(cb.Account_Type6__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.Account_Type6__c != null && unsecuredLoans.indexOf(cb.Account_Type6__c) != -1) {

            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened6__c != null && cb.Date_Opened6__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened6__c != null && cb.Date_Opened6__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.Ownership6__c!='Credit Card' && cb.Date_Closed6__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
        if (cb.Date_Closed6__c == null && cb.Current_Balance6__c != null && cb.Current_Balance6__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.Current_Balance6__c;
                if (cb.Sanction_Amount6__c != null && cb.CIBIL_Fired_time__c != null && cb.Date_Opened6__c != null && cb.Date_Opened6__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.Sanction_Amount6__c;
                if (cb.Sanction_Amount6__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.Sanction_Amount6__c;
            } else if (cb.Sanction_Amount6__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.Sanction_Amount6__c;
        }
        if (cb.Account_Type7__c != null && unsecuredLoans.indexOf(cb.Account_Type7__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.Account_Type7__c != null && unsecuredLoans.indexOf(cb.Account_Type7__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened7__c != null && cb.Date_Opened7__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened7__c != null && cb.Date_Opened7__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.Ownership7__c!='Credit Card' && cb.Date_Closed7__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
        if (cb.Date_Closed7__c == null && cb.Current_Balance7__c != null && cb.Current_Balance7__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.Current_Balance7__c;
                if (cb.Sanction_Amount7__c != null && cb.CIBIL_Fired_time__c != null && cb.Date_Opened7__c != null && cb.Date_Opened7__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.Sanction_Amount7__c;
                if (cb.Sanction_Amount7__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.Sanction_Amount7__c;
            } else if (cb.Sanction_Amount7__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.Sanction_Amount7__c;
        }
        if (cb.Account_Type8__c != null && unsecuredLoans.indexOf(cb.Account_Type8__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.Account_Type8__c != null && unsecuredLoans.indexOf(cb.Account_Type8__c) != -1) {
        
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened8__c != null && cb.Date_Opened8__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened8__c != null && cb.Date_Opened8__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.Ownership8__c!='Credit Card' && cb.Date_Closed8__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }   
        
        if (cb.Date_Closed8__c == null && cb.Current_Balance8__c != null && cb.Current_Balance8__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.Current_Balance8__c;
                if (cb.Sanction_Amount8__c != null && cb.CIBIL_Fired_time__c != null && cb.Date_Opened8__c != null && cb.Date_Opened8__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.Sanction_Amount8__c;
                if (cb.Sanction_Amount8__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.Sanction_Amount8__c;
            } else if (cb.Sanction_Amount8__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.Sanction_Amount8__c;
        }
        if (cb.Account_Type9__c != null && unsecuredLoans.indexOf(cb.Account_Type9__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.Account_Type9__c != null && unsecuredLoans.indexOf(cb.Account_Type9__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened9__c != null && cb.Date_Opened9__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened9__c != null && cb.Date_Opened9__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.Ownership9__c!='Credit Card' && cb.Date_Closed9__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
        if (cb.Date_Closed9__c == null && cb.Current_Balance9__c != null && cb.Current_Balance9__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.Current_Balance9__c;
                if (cb.Sanction_Amount9__c != null && cb.CIBIL_Fired_time__c != null && cb.Date_Opened9__c != null && cb.Date_Opened9__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.Sanction_Amount9__c;
                if (cb.Sanction_Amount9__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.Sanction_Amount9__c;
            } else if (cb.Sanction_Amount9__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.Sanction_Amount9__c;
        }
        if (cb.Account_Type10__c != null && unsecuredLoans.indexOf(cb.Account_Type10__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.Account_Type10__c != null && unsecuredLoans.indexOf(cb.Account_Type10__c) != -1) {

        if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened10__c != null && cb.Date_Opened10__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened10__c != null && cb.Date_Opened10__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.Ownership10__c!='Credit Card' && cb.Date_Closed10__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
            if (cb.Date_Closed10__c == null && cb.Current_Balance10__c != null && cb.Current_Balance10__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.Current_Balance10__c;
                if (cb.Sanction_Amount10__c != null && cb.CIBIL_Fired_time__c != null && cb.Date_Opened10__c != null && cb.Date_Opened10__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.Sanction_Amount10__c;
                if (cb.Sanction_Amount10__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.Sanction_Amount10__c;
            } else if (cb.Sanction_Amount10__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.Sanction_Amount10__c;
        }
        if (cb.Account_Type11__c != null && unsecuredLoans.indexOf(cb.Account_Type11__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.Account_Type11__c != null && unsecuredLoans.indexOf(cb.Account_Type11__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened11__c != null && cb.Date_Opened11__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened11__c != null && cb.Date_Opened11__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.Ownership11__c!='Credit Card' && cb.Date_Closed11__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }

        if (cb.Date_Closed11__c == null && cb.Current_Balance11__c != null && cb.Current_Balance11__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.Current_Balance11__c;
                if (cb.Sanction_Amount11__c != null && cb.CIBIL_Fired_time__c != null && cb.Date_Opened11__c != null && cb.Date_Opened11__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.Sanction_Amount11__c;
                if (cb.Sanction_Amount11__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.Sanction_Amount11__c;
            } else if (cb.Sanction_Amount11__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.Sanction_Amount11__c;
        }
        if (cb.Account_Type12__c != null && unsecuredLoans.indexOf(cb.Account_Type12__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.Account_Type12__c != null && unsecuredLoans.indexOf(cb.Account_Type12__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened12__c != null && cb.Date_Opened12__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened12__c != null && cb.Date_Opened12__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.Ownership12__c!='Credit Card' && cb.Date_Closed12__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
            
            if (cb.Date_Closed12__c == null && cb.Current_Balance12__c != null && cb.Current_Balance12__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.Current_Balance12__c;
                if (cb.Sanction_Amount12__c != null && cb.CIBIL_Fired_time__c != null && cb.Date_Opened12__c != null && cb.Date_Opened12__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.Sanction_Amount12__c;
                if (cb.Sanction_Amount12__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.Sanction_Amount12__c;
            } else if (cb.Sanction_Amount12__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.Sanction_Amount12__c;
        }
        if (cb.Account_Type13__c != null && unsecuredLoans.indexOf(cb.Account_Type13__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.Account_Type13__c != null && unsecuredLoans.indexOf(cb.Account_Type13__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened13__c != null && cb.Date_Opened13__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened13__c != null && cb.Date_Opened13__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.Ownership13__c!='Credit Card' && cb.Date_Closed13__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }

        if (cb.Date_Closed13__c == null && cb.Current_Balance13__c != null && cb.Current_Balance13__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.Current_Balance13__c;
                if (cb.Sanction_Amount13__c != null && cb.CIBIL_Fired_time__c != null && cb.Date_Opened13__c != null && cb.Date_Opened13__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.Sanction_Amount13__c;
                if (cb.Sanction_Amount13__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.Sanction_Amount13__c;
            } else if (cb.Sanction_Amount13__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.Sanction_Amount13__c;
        }
        if (cb.Account_Type14__c != null && unsecuredLoans.indexOf(cb.Account_Type14__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.Account_Type14__c != null && unsecuredLoans.indexOf(cb.Account_Type14__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened14__c != null && cb.Date_Opened14__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened14__c != null && cb.Date_Opened14__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.Ownership14__c!='Credit Card' && cb.Date_Closed14__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
            
        if (cb.Date_Closed14__c == null && cb.Current_Balance14__c != null && cb.Current_Balance14__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.Current_Balance14__c;
                if (cb.Sanction_Amount14__c != null && cb.CIBIL_Fired_time__c != null && cb.Date_Opened14__c != null && cb.Date_Opened14__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.Sanction_Amount14__c;
                if (cb.Sanction_Amount14__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.Sanction_Amount14__c;
            } else if (cb.Sanction_Amount14__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.Sanction_Amount14__c;
        }
        if (cb.Account_Type15__c != null && unsecuredLoans.indexOf(cb.Account_Type15__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.Account_Type15__c != null && unsecuredLoans.indexOf(cb.Account_Type15__c) != -1) {

            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened15__c != null && cb.Date_Opened15__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened15__c != null && cb.Date_Opened15__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.Ownership15__c!='Credit Card' && cb.Date_Closed15__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
        if (cb.Date_Closed15__c == null && cb.Current_Balance15__c != null && cb.Current_Balance15__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.Current_Balance15__c;
                if (cb.Sanction_Amount15__c != null && cb.CIBIL_Fired_time__c != null && cb.Date_Opened15__c != null && cb.Date_Opened15__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.Sanction_Amount15__c;
                if (cb.Sanction_Amount15__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.Sanction_Amount15__c;
            } else if (cb.Sanction_Amount15__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.Sanction_Amount15__c;
        }
        if (cb.Account_Type16__c != null && unsecuredLoans != null && cb.Account_Type16__c != null && unsecuredLoans.indexOf(cb.Account_Type16__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.Account_Type16__c != null && unsecuredLoans != null && cb.Account_Type16__c != null && unsecuredLoans.indexOf(cb.Account_Type16__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened16__c != null && cb.Date_Opened16__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened16__c != null && cb.Date_Opened16__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.Ownership16__c!='Credit Card' && cb.Date_Closed16__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
    
        if (cb.Date_Closed16__c == null && cb.Current_Balance16__c != null && cb.Current_Balance16__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.Current_Balance16__c;
                if (cb.Sanction_Amount16__c != null && cb.CIBIL_Fired_time__c != null && cb.Date_Opened16__c != null && cb.Date_Opened16__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.Sanction_Amount16__c;
                if (cb.Sanction_Amount16__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.Sanction_Amount16__c;
            } else if (cb.Sanction_Amount16__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.Sanction_Amount16__c;
        }
        if (cb.Account_Type17__c != null && unsecuredLoans != null && cb.Account_Type17__c != null && unsecuredLoans.indexOf(cb.Account_Type17__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.Account_Type17__c != null && unsecuredLoans.indexOf(cb.Account_Type17__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened17__c != null && cb.Date_Opened17__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened17__c != null && cb.Date_Opened17__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.Ownership17__c!='Credit Card' && cb.Date_Closed17__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }

        if (cb.Date_Closed17__c == null && cb.Current_Balance17__c != null && cb.Current_Balance17__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.Current_Balance17__c;
                if (cb.Sanction_Amount17__c != null && cb.CIBIL_Fired_time__c != null && cb.Date_Opened17__c != null && cb.Date_Opened17__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.Sanction_Amount17__c;
                if (cb.Sanction_Amount17__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.Sanction_Amount17__c;
            } else if (cb.Sanction_Amount17__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.Sanction_Amount17__c;
        }
        if (cb.Account_Type18__c != null && unsecuredLoans != null && cb.Account_Type18__c != null && unsecuredLoans.indexOf(cb.Account_Type18__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.Account_Type18__c != null && unsecuredLoans.indexOf(cb.Account_Type18__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened18__c != null && cb.Date_Opened18__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened18__c != null && cb.Date_Opened18__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.Ownership18__c!='Credit Card' && cb.Date_Closed18__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
        if (cb.Date_Closed18__c == null && cb.Current_Balance18__c != null && cb.Current_Balance18__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.Current_Balance18__c;
                if (cb.Sanction_Amount18__c != null && cb.CIBIL_Fired_time__c != null && cb.Date_Opened18__c != null && cb.Date_Opened18__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.Sanction_Amount18__c;
                if (cb.Sanction_Amount18__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.Sanction_Amount18__c;
            } else if (cb.Sanction_Amount18__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.Sanction_Amount18__c;
        }
        if (cb.Account_Type19__c != null && unsecuredLoans != null && cb.Account_Type19__c != null && unsecuredLoans.indexOf(cb.Account_Type19__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.Account_Type19__c != null && unsecuredLoans.indexOf(cb.Account_Type19__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened19__c != null && cb.Date_Opened19__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
 //Added by mahima - 17588- Bol revamp - start
                System.debug('X12monthsDPD --> ' + X12monthsDPD);
                
                if(X12monthsDPD>0 && (!(accountType.contains('Credit Card') || accountType.contains('Gold Loan')))){
                    X30DPD12MonthsWithoutCCGL++;
                }
                //Added by mahima - 17588- Bol revamp - end
               
            }
            if (cb.CIBIL_Fired_time__c != null && cb.Date_Opened19__c != null && cb.Date_Opened19__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.Ownership19__c!='Credit Card' && cb.Date_Closed19__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
        
        if (cb.Date_Closed19__c == null && cb.Current_Balance19__c != null && cb.Current_Balance19__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.Current_Balance19__c;
                if (cb.Sanction_Amount19__c != null && cb.CIBIL_Fired_time__c != null && cb.Date_Opened19__c != null && cb.Date_Opened19__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.Sanction_Amount19__c;
                if (cb.Sanction_Amount19__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.Sanction_Amount19__c;
            } else if (cb.Sanction_Amount19__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.Sanction_Amount19__c;
        }

        if (cb.CIBIL_Extension__r.Account_Type20__c != null && unsecuredLoans.indexOf(cb.CIBIL_Extension__r.Account_Type20__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened20__c != null && cb.cibil_extension__r.Date_Opened20__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened20__c != null && cb.cibil_extension__r.Date_Opened20__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.cibil_extension__r.Ownership20__c!='Credit Card' && cb.cibil_extension__r.Date_Closed20__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
            
            if (cb.CIBIL_Extension__r.Date_Closed20__c == null && cb.cibil_extension__r.Current_Balance20__c != null && cb.cibil_extension__r.Current_Balance20__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.CIBIL_Extension__r.Current_Balance20__c;
                if (cb.cibil_extension__r.Sanction_Amount20__c != null && cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened20__c != null && cb.cibil_extension__r.Date_Opened20__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount20__c;
                if (cb.cibil_extension__r.Sanction_Amount20__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.cibil_extension__r.Sanction_Amount20__c;
            } else if (cb.CIBIL_Extension__r.Sanction_Amount20__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount20__c;
        }
        if (cb.CIBIL_Extension__r.Account_Type21__c != null && unsecuredLoans.indexOf(cb.CIBIL_Extension__r.Account_Type21__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened21__c != null && cb.cibil_extension__r.Date_Opened21__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened21__c != null && cb.cibil_extension__r.Date_Opened21__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.cibil_extension__r.Ownership21__c!='Credit Card' && cb.cibil_extension__r.Date_Closed21__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
            
        if (cb.CIBIL_Extension__r.Date_Closed21__c == null && cb.cibil_extension__r.Current_Balance21__c != null && cb.cibil_extension__r.Current_Balance21__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.CIBIL_Extension__r.Current_Balance21__c;
                if (cb.cibil_extension__r.Sanction_Amount21__c != null && cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened21__c != null && cb.cibil_extension__r.Date_Opened21__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount21__c;
                if (cb.cibil_extension__r.Sanction_Amount21__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.cibil_extension__r.Sanction_Amount21__c;
            } else if (cb.CIBIL_Extension__r.Sanction_Amount21__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount21__c;
        }
        if (cb.CIBIL_Extension__r.Account_Type22__c != null && unsecuredLoans.indexOf(cb.CIBIL_Extension__r.Account_Type22__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened22__c != null && cb.cibil_extension__r.Date_Opened22__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened22__c != null && cb.cibil_extension__r.Date_Opened22__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.cibil_extension__r.Ownership22__c!='Credit Card' && cb.cibil_extension__r.Date_Closed22__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }

        if (cb.CIBIL_Extension__r.Date_Closed22__c == null && cb.cibil_extension__r.Current_Balance22__c != null && cb.cibil_extension__r.Current_Balance22__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.CIBIL_Extension__r.Current_Balance22__c;
                if (cb.cibil_extension__r.Sanction_Amount22__c != null && cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened22__c != null && cb.cibil_extension__r.Date_Opened22__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount22__c;
                if (cb.cibil_extension__r.Sanction_Amount22__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.cibil_extension__r.Sanction_Amount22__c;
            } else if (cb.CIBIL_Extension__r.Sanction_Amount22__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount22__c;
        }
        if (cb.CIBIL_Extension__r.Account_Type23__c != null && unsecuredLoans.indexOf(cb.CIBIL_Extension__r.Account_Type23__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened23__c != null && cb.cibil_extension__r.Date_Opened23__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened23__c != null && cb.cibil_extension__r.Date_Opened23__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.cibil_extension__r.Ownership23__c!='Credit Card' && cb.cibil_extension__r.Date_Closed23__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
            if (cb.CIBIL_Extension__r.Date_Closed23__c == null && cb.cibil_extension__r.Current_Balance23__c != null && cb.cibil_extension__r.Current_Balance23__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.CIBIL_Extension__r.Current_Balance23__c;
                if (cb.cibil_extension__r.Sanction_Amount23__c != null && cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened23__c != null && cb.cibil_extension__r.Date_Opened23__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount23__c;
                if (cb.cibil_extension__r.Sanction_Amount23__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.cibil_extension__r.Sanction_Amount23__c;
            } else if (cb.CIBIL_Extension__r.Sanction_Amount23__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount23__c;
        }
        if (cb.CIBIL_Extension__r.Account_Type24__c != null && unsecuredLoans.indexOf(cb.CIBIL_Extension__r.Account_Type24__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened24__c != null && cb.cibil_extension__r.Date_Opened24__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened24__c != null && cb.cibil_extension__r.Date_Opened24__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.cibil_extension__r.Ownership24__c!='Credit Card' && cb.cibil_extension__r.Date_Closed24__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
        if (cb.CIBIL_Extension__r.Date_Closed24__c == null && cb.cibil_extension__r.Current_Balance24__c != null && cb.cibil_extension__r.Current_Balance24__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.CIBIL_Extension__r.Current_Balance24__c;
                if (cb.cibil_extension__r.Sanction_Amount24__c != null && cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened24__c != null && cb.cibil_extension__r.Date_Opened24__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount24__c;
                if (cb.cibil_extension__r.Sanction_Amount24__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.cibil_extension__r.Sanction_Amount24__c;
            } else if (cb.CIBIL_Extension__r.Sanction_Amount24__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount24__c;
        }
        if (cb.CIBIL_Extension__r.Account_Type25__c != null && unsecuredLoans.indexOf(cb.CIBIL_Extension__r.Account_Type25__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened25__c != null && cb.cibil_extension__r.Date_Opened25__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened25__c != null && cb.cibil_extension__r.Date_Opened25__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.cibil_extension__r.Ownership25__c!='Credit Card' && cb.cibil_extension__r.Date_Closed25__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
        if (cb.CIBIL_Extension__r.Date_Closed25__c == null && cb.cibil_extension__r.Current_Balance25__c != null && cb.cibil_extension__r.Current_Balance25__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.CIBIL_Extension__r.Current_Balance25__c;
                if (cb.cibil_extension__r.Sanction_Amount25__c != null && cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened25__c != null && cb.cibil_extension__r.Date_Opened25__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount25__c;
                if (cb.cibil_extension__r.Sanction_Amount25__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.cibil_extension__r.Sanction_Amount25__c;
            } else if (cb.CIBIL_Extension__r.Sanction_Amount25__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount25__c;
        }
        if (cb.CIBIL_Extension__r.Account_Type26__c != null && unsecuredLoans.indexOf(cb.CIBIL_Extension__r.Account_Type26__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened26__c != null && cb.cibil_extension__r.Date_Opened26__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened26__c != null && cb.cibil_extension__r.Date_Opened26__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.cibil_extension__r.Ownership26__c!='Credit Card' && cb.cibil_extension__r.Date_Closed26__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
            if (cb.CIBIL_Extension__r.Date_Closed26__c == null && cb.cibil_extension__r.Current_Balance26__c != null && cb.cibil_extension__r.Current_Balance26__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.CIBIL_Extension__r.Current_Balance26__c;
                if (cb.cibil_extension__r.Sanction_Amount26__c != null && cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened26__c != null && cb.cibil_extension__r.Date_Opened26__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount26__c;
                if (cb.cibil_extension__r.Sanction_Amount26__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.cibil_extension__r.Sanction_Amount26__c;
            } else if (cb.CIBIL_Extension__r.Sanction_Amount26__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount26__c;
        }
        if (cb.CIBIL_Extension__r.Account_Type27__c != null && unsecuredLoans.indexOf(cb.CIBIL_Extension__r.Account_Type27__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened27__c != null && cb.cibil_extension__r.Date_Opened27__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened27__c != null && cb.cibil_extension__r.Date_Opened27__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.cibil_extension__r.Ownership27__c!='Credit Card' && cb.cibil_extension__r.Date_Closed27__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
        if (cb.CIBIL_Extension__r.Date_Closed27__c == null && cb.cibil_extension__r.Current_Balance27__c != null && cb.cibil_extension__r.Current_Balance27__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.CIBIL_Extension__r.Current_Balance27__c;
                if (cb.cibil_extension__r.Sanction_Amount27__c != null && cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened27__c != null && cb.cibil_extension__r.Date_Opened27__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount27__c;
                if (cb.cibil_extension__r.Sanction_Amount27__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.cibil_extension__r.Sanction_Amount27__c;
            } else if (cb.CIBIL_Extension__r.Sanction_Amount27__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount27__c;
        }
        if (cb.CIBIL_Extension__r.Account_Type28__c != null && unsecuredLoans.indexOf(cb.CIBIL_Extension__r.Account_Type28__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened28__c != null && cb.cibil_extension__r.Date_Opened28__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened28__c != null && cb.cibil_extension__r.Date_Opened28__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.cibil_extension__r.Ownership28__c!='Credit Card' && cb.cibil_extension__r.Date_Closed28__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
            if (cb.CIBIL_Extension__r.Date_Closed28__c == null && cb.cibil_extension__r.Current_Balance28__c != null && cb.cibil_extension__r.Current_Balance28__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.CIBIL_Extension__r.Current_Balance28__c;
                if (cb.cibil_extension__r.Sanction_Amount28__c != null && cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened28__c != null && cb.cibil_extension__r.Date_Opened28__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount28__c;
                if (cb.cibil_extension__r.Sanction_Amount28__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.cibil_extension__r.Sanction_Amount28__c;
            } else if (cb.CIBIL_Extension__r.Sanction_Amount28__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount28__c;
        }
        if (cb.CIBIL_Extension__r.Account_Type29__c != null && unsecuredLoans.indexOf(cb.CIBIL_Extension__r.Account_Type29__c) != -1) {
            if (cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened29__c != null && cb.cibil_extension__r.Date_Opened29__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12)
            {
                Integer temp  = unsecuredLoanCntMap.get('UnsecuredLoanCnt12Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt12Mon',temp);
            }
            if (cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened29__c != null && cb.cibil_extension__r.Date_Opened29__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 6 && cb.cibil_extension__r.Ownership29__c!='Credit Card' && cb.cibil_extension__r.Date_Closed29__c!=null)
            {
                Integer temp = unsecuredLoanCntMap.get('UnsecuredLoanCnt6Mon');
                temp++;
                unsecuredLoanCntMap.put('UnsecuredLoanCnt6Mon',temp);
            }
        if (cb.CIBIL_Extension__r.Date_Closed29__c == null && cb.cibil_extension__r.Current_Balance29__c != null && cb.cibil_extension__r.Current_Balance29__c > 1000) {
                liveUnsecuredLoanCnt++;
                unsecuredCurrentBalance = unsecuredCurrentBalance + cb.CIBIL_Extension__r.Current_Balance29__c;
                if (cb.cibil_extension__r.Sanction_Amount29__c != null && cb.CIBIL_Fired_time__c != null && cb.cibil_extension__r.Date_Opened29__c != null && cb.cibil_extension__r.Date_Opened29__c.monthsBetween(date.valueOf(cb.CIBIL_Fired_time__c)) <= 12) totalUnsecuredSanctionAmount = totalUnsecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount29__c;
                if (cb.cibil_extension__r.Sanction_Amount29__c != null) totalLiveUnsecuredSanctionAmount = totalLiveUnsecuredSanctionAmount + cb.cibil_extension__r.Sanction_Amount29__c;
            } else if (cb.CIBIL_Extension__r.Sanction_Amount29__c != null) totalClosedUnsecuredSanctionAmount = totalClosedUnsecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount29__c;
        }
        if (cb.CIBIL_Extension__r.Account_Type20__c != null && unsecuredLoans.indexOf(cb.CIBIL_Extension__r.Account_Type20__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.CIBIL_Extension__r.Account_Type21__c != null && unsecuredLoans.indexOf(cb.CIBIL_Extension__r.Account_Type21__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.CIBIL_Extension__r.Account_Type22__c != null && unsecuredLoans.indexOf(cb.CIBIL_Extension__r.Account_Type22__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.CIBIL_Extension__r.Account_Type23__c != null && unsecuredLoans.indexOf(cb.CIBIL_Extension__r.Account_Type23__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.CIBIL_Extension__r.Account_Type24__c != null && unsecuredLoans.indexOf(cb.CIBIL_Extension__r.Account_Type24__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.CIBIL_Extension__r.Account_Type25__c != null && unsecuredLoans.indexOf(cb.CIBIL_Extension__r.Account_Type25__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.CIBIL_Extension__r.Account_Type26__c != null && unsecuredLoans.indexOf(cb.CIBIL_Extension__r.Account_Type26__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.CIBIL_Extension__r.Account_Type27__c != null && unsecuredLoans.indexOf(cb.CIBIL_Extension__r.Account_Type27__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.CIBIL_Extension__r.Account_Type28__c != null && unsecuredLoans.indexOf(cb.CIBIL_Extension__r.Account_Type28__c) != -1) {
            unsecuredTLCnt++;
        }
        if (cb.CIBIL_Extension__r.Account_Type29__c != null && unsecuredLoans.indexOf(cb.CIBIL_Extension__r.Account_Type29__c) != -1) {
            unsecuredTLCnt++;
        }*/
        return unsecuredLoanCntMap;
    }
    /* POS_PO-16621 ends */
    /*public boolean getEverWrittenOff(Cibil__c cb) {
        boolean writeOff = false;
        if (!(cb.Suit_Filed_Status__c == null || cb.Suit_Filed_Status__c == '' || (cb.Suit_Filed_Status__c != null && ((cb.Suit_Filed_Status__c).contains('NO DATA') || (cb.Suit_Filed_Status__c).contains('No Suit Filed') || (cb.Suit_Filed_Status__c).contains('XX') || (cb.Suit_Filed_Status__c).contains('0'))))) {
            writeOff = true;

        }
        if (!(cb.Suit_Filed_Status1__c == null || cb.Suit_Filed_Status1__c == '' || (cb.Suit_Filed_Status1__c != null && ((cb.Suit_Filed_Status1__c).contains('NO DATA') || (cb.Suit_Filed_Status1__c).contains('No Suit Filed') || (cb.Suit_Filed_Status1__c).contains('XX') || (cb.Suit_Filed_Status1__c).contains('0'))))) {
            writeOff = true;

        }
        if (!(cb.Suit_Filed_Status2__c == null || cb.Suit_Filed_Status2__c == '' || (cb.Suit_Filed_Status2__c != null && ((cb.Suit_Filed_Status2__c).contains('NO DATA') || (cb.Suit_Filed_Status2__c).contains('No Suit Filed') || (cb.Suit_Filed_Status2__c).contains('XX') || (cb.Suit_Filed_Status2__c).contains('0'))))) {
            writeOff = true;

        }
        if (!(cb.Suit_Filed_Status3__c == null || cb.Suit_Filed_Status3__c == '' || (cb.Suit_Filed_Status3__c != null && ((cb.Suit_Filed_Status3__c).contains('NO DATA') || (cb.Suit_Filed_Status3__c).contains('No Suit Filed') || (cb.Suit_Filed_Status3__c).contains('XX') || (cb.Suit_Filed_Status3__c).contains('0'))))) {
            writeOff = true;

        }
        if (!(cb.Suit_Filed_Status4__c == null || cb.Suit_Filed_Status4__c == '' || (cb.Suit_Filed_Status4__c != null && ((cb.Suit_Filed_Status4__c).contains('NO DATA') || (cb.Suit_Filed_Status4__c).contains('No Suit Filed') || (cb.Suit_Filed_Status4__c).contains('XX') || (cb.Suit_Filed_Status4__c).contains('0'))))) {
            writeOff = true;

        }
        if (!(cb.Suit_Filed_Status5__c == null || cb.Suit_Filed_Status5__c == '' || (cb.Suit_Filed_Status5__c != null && ((cb.Suit_Filed_Status5__c).contains('NO DATA') || (cb.Suit_Filed_Status5__c).contains('No Suit Filed') || (cb.Suit_Filed_Status5__c).contains('XX') || (cb.Suit_Filed_Status5__c).contains('0'))))) {
            writeOff = true;

        }
        if (!(cb.Suit_Filed_Status6__c == null || cb.Suit_Filed_Status6__c == '' || (cb.Suit_Filed_Status6__c != null && ((cb.Suit_Filed_Status6__c).contains('NO DATA') || (cb.Suit_Filed_Status6__c).contains('No Suit Filed') || (cb.Suit_Filed_Status6__c).contains('XX') || (cb.Suit_Filed_Status6__c).contains('0'))))) {
            writeOff = true;

        }
        if (!(cb.Suit_Filed_Status7__c == null || cb.Suit_Filed_Status7__c == '' || (cb.Suit_Filed_Status7__c != null && ((cb.Suit_Filed_Status7__c).contains('NO DATA') || (cb.Suit_Filed_Status7__c).contains('No Suit Filed') || (cb.Suit_Filed_Status7__c).contains('XX') || (cb.Suit_Filed_Status7__c).contains('0'))))) {
            writeOff = true;

        }
        if (!(cb.Suit_Filed_Status8__c == null || cb.Suit_Filed_Status8__c == '' || (cb.Suit_Filed_Status8__c != null && ((cb.Suit_Filed_Status8__c).contains('NO DATA') || (cb.Suit_Filed_Status8__c).contains('No Suit Filed') || (cb.Suit_Filed_Status8__c).contains('XX') || (cb.Suit_Filed_Status8__c).contains('0'))))) {
            writeOff = true;

        }
        if (!(cb.Suit_Filed_Status9__c == null || cb.Suit_Filed_Status9__c == '' || (cb.Suit_Filed_Status9__c != null && ((cb.Suit_Filed_Status9__c).contains('NO DATA') || (cb.Suit_Filed_Status9__c).contains('No Suit Filed') || (cb.Suit_Filed_Status9__c).contains('XX') || (cb.Suit_Filed_Status9__c).contains('0'))))) {
            writeOff = true;

        }
        if (!(cb.Suit_Filed_Status10__c == null || cb.Suit_Filed_Status10__c == '' || (cb.Suit_Filed_Status10__c != null && ((cb.Suit_Filed_Status10__c).contains('NO DATA') || (cb.Suit_Filed_Status10__c).contains('No Suit Filed') || (cb.Suit_Filed_Status10__c).contains('XX') || (cb.Suit_Filed_Status10__c).contains('0'))))) {
            writeOff = true;

        }
        if (!(cb.Suit_Filed_Status11__c == null || cb.Suit_Filed_Status11__c == '' || (cb.Suit_Filed_Status11__c != null && ((cb.Suit_Filed_Status11__c).contains('NO DATA') || (cb.Suit_Filed_Status11__c).contains('No Suit Filed') || (cb.Suit_Filed_Status11__c).contains('XX') || (cb.Suit_Filed_Status11__c).contains('0'))))) {
            writeOff = true;

        }
        if (!(cb.Suit_Filed_Status12__c == null || cb.Suit_Filed_Status12__c == '' || (cb.Suit_Filed_Status12__c != null && ((cb.Suit_Filed_Status12__c).contains('NO DATA') || (cb.Suit_Filed_Status12__c).contains('No Suit Filed') || (cb.Suit_Filed_Status12__c).contains('XX') || (cb.Suit_Filed_Status12__c).contains('0'))))) {
            writeOff = true;

        }
        if (!(cb.Suit_Filed_Status13__c == null || cb.Suit_Filed_Status13__c == '' || (cb.Suit_Filed_Status13__c != null && ((cb.Suit_Filed_Status13__c).contains('NO DATA') || (cb.Suit_Filed_Status13__c).contains('No Suit Filed') || (cb.Suit_Filed_Status13__c).contains('XX') || (cb.Suit_Filed_Status13__c).contains('0'))))) {
            writeOff = true;

        }
        if (!(cb.Suit_Filed_Status14__c == null || cb.Suit_Filed_Status14__c == '' || (cb.Suit_Filed_Status14__c != null && ((cb.Suit_Filed_Status14__c).contains('NO DATA') || (cb.Suit_Filed_Status14__c).contains('No Suit Filed') || (cb.Suit_Filed_Status14__c).contains('XX') || (cb.Suit_Filed_Status14__c).contains('0'))))) {
            writeOff = true;

        }
        if (!(cb.Suit_Filed_Status15__c == null || cb.Suit_Filed_Status15__c == '' || (cb.Suit_Filed_Status15__c != null && ((cb.Suit_Filed_Status15__c).contains('NO DATA') || (cb.Suit_Filed_Status15__c).contains('No Suit Filed') || (cb.Suit_Filed_Status15__c).contains('XX') || (cb.Suit_Filed_Status15__c).contains('0'))))) {
            writeOff = true;

        }
        if (!(cb.Suit_Filed_Status16__c == null || cb.Suit_Filed_Status16__c == '' || (cb.Suit_Filed_Status16__c != null && ((cb.Suit_Filed_Status16__c).contains('NO DATA') || (cb.Suit_Filed_Status16__c).contains('No Suit Filed') || (cb.Suit_Filed_Status16__c).contains('XX') || (cb.Suit_Filed_Status16__c).contains('0'))))) {
            writeOff = true;

        }
        if (!(cb.Suit_Filed_Status17__c == null || cb.Suit_Filed_Status17__c == '' || (cb.Suit_Filed_Status17__c != null && ((cb.Suit_Filed_Status17__c).contains('NO DATA') || (cb.Suit_Filed_Status17__c).contains('No Suit Filed') || (cb.Suit_Filed_Status17__c).contains('XX') || (cb.Suit_Filed_Status17__c).contains('0'))))) {
            writeOff = true;

        }
        if (!(cb.Suit_Filed_Status18__c == null || cb.Suit_Filed_Status18__c == '' || (cb.Suit_Filed_Status18__c != null && ((cb.Suit_Filed_Status18__c).contains('NO DATA') || (cb.Suit_Filed_Status18__c).contains('No Suit Filed') || (cb.Suit_Filed_Status18__c).contains('XX') || (cb.Suit_Filed_Status18__c).contains('0'))))) {
            writeOff = true;

        }
        if (!(cb.Suit_Filed_Status19__c == null || cb.Suit_Filed_Status19__c == '' || (cb.Suit_Filed_Status19__c != null && ((cb.Suit_Filed_Status19__c).contains('NO DATA') || (cb.Suit_Filed_Status19__c).contains('No Suit Filed') || (cb.Suit_Filed_Status19__c).contains('XX') || (cb.Suit_Filed_Status19__c).contains('0'))))) {
            writeOff = true;

        }
        if (cb.CIBIL_Extension__c != null) {
            if (!(cb.CIBIL_Extension__r.Suit_Filed_Status20__c == null || cb.CIBIL_Extension__r.Suit_Filed_Status20__c == '' || (cb.CIBIL_Extension__r.Suit_Filed_Status20__c != null && ((cb.CIBIL_Extension__r.Suit_Filed_Status20__c).contains('NO DATA') || (cb.CIBIL_Extension__r.Suit_Filed_Status20__c).contains('No Suit Filed') || (cb.CIBIL_Extension__r.Suit_Filed_Status20__c).contains('XX') || (cb.CIBIL_Extension__r.Suit_Filed_Status20__c).contains('0'))))) {
                writeOff = true;

            }
            if (!(cb.CIBIL_Extension__r.Suit_Filed_Status21__c == null || cb.CIBIL_Extension__r.Suit_Filed_Status21__c == '' || (cb.CIBIL_Extension__r.Suit_Filed_Status21__c != null && ((cb.CIBIL_Extension__r.Suit_Filed_Status21__c).contains('NO DATA') || (cb.CIBIL_Extension__r.Suit_Filed_Status21__c).contains('No Suit Filed') || (cb.CIBIL_Extension__r.Suit_Filed_Status21__c).contains('XX') || (cb.CIBIL_Extension__r.Suit_Filed_Status21__c).contains('0'))))) {
                writeOff = true;

            }
            if (!(cb.CIBIL_Extension__r.Suit_Filed_Status22__c == null || cb.CIBIL_Extension__r.Suit_Filed_Status22__c == '' || (cb.CIBIL_Extension__r.Suit_Filed_Status22__c != null && ((cb.CIBIL_Extension__r.Suit_Filed_Status22__c).contains('NO DATA') || (cb.CIBIL_Extension__r.Suit_Filed_Status22__c).contains('No Suit Filed') || (cb.CIBIL_Extension__r.Suit_Filed_Status22__c).contains('XX') || (cb.CIBIL_Extension__r.Suit_Filed_Status22__c).contains('0'))))) {
                writeOff = true;

            }
            if (!(cb.CIBIL_Extension__r.Suit_Filed_Status23__c == null || cb.CIBIL_Extension__r.Suit_Filed_Status23__c == '' || (cb.CIBIL_Extension__r.Suit_Filed_Status23__c != null && ((cb.CIBIL_Extension__r.Suit_Filed_Status23__c).contains('NO DATA') || (cb.CIBIL_Extension__r.Suit_Filed_Status23__c).contains('No Suit Filed') || (cb.CIBIL_Extension__r.Suit_Filed_Status23__c).contains('XX') || (cb.CIBIL_Extension__r.Suit_Filed_Status23__c).contains('0'))))) {
                writeOff = true;

            }
            if (!(cb.CIBIL_Extension__r.Suit_Filed_Status24__c == null || cb.CIBIL_Extension__r.Suit_Filed_Status24__c == '' || (cb.CIBIL_Extension__r.Suit_Filed_Status24__c != null && ((cb.CIBIL_Extension__r.Suit_Filed_Status24__c).contains('NO DATA') || (cb.CIBIL_Extension__r.Suit_Filed_Status24__c).contains('No Suit Filed') || (cb.CIBIL_Extension__r.Suit_Filed_Status24__c).contains('XX') || (cb.CIBIL_Extension__r.Suit_Filed_Status24__c).contains('0'))))) {
                writeOff = true;

            }
            if (!(cb.CIBIL_Extension__r.Suit_Filed_Status25__c == null || cb.CIBIL_Extension__r.Suit_Filed_Status25__c == '' || (cb.CIBIL_Extension__r.Suit_Filed_Status25__c != null && ((cb.CIBIL_Extension__r.Suit_Filed_Status25__c).contains('NO DATA') || (cb.CIBIL_Extension__r.Suit_Filed_Status25__c).contains('No Suit Filed') || (cb.CIBIL_Extension__r.Suit_Filed_Status25__c).contains('XX') || (cb.CIBIL_Extension__r.Suit_Filed_Status25__c).contains('0'))))) {
                writeOff = true;

            }
            if (!(cb.CIBIL_Extension__r.Suit_Filed_Status26__c == null || cb.CIBIL_Extension__r.Suit_Filed_Status26__c == '' || (cb.CIBIL_Extension__r.Suit_Filed_Status26__c != null && ((cb.CIBIL_Extension__r.Suit_Filed_Status26__c).contains('NO DATA') || (cb.CIBIL_Extension__r.Suit_Filed_Status26__c).contains('No Suit Filed') || (cb.CIBIL_Extension__r.Suit_Filed_Status26__c).contains('XX') || (cb.CIBIL_Extension__r.Suit_Filed_Status26__c).contains('0'))))) {
                writeOff = true;

            }
            if (!(cb.CIBIL_Extension__r.Suit_Filed_Status27__c == null || cb.CIBIL_Extension__r.Suit_Filed_Status27__c == '' || (cb.CIBIL_Extension__r.Suit_Filed_Status27__c != null && ((cb.CIBIL_Extension__r.Suit_Filed_Status27__c).contains('NO DATA') || (cb.CIBIL_Extension__r.Suit_Filed_Status27__c).contains('No Suit Filed') || (cb.CIBIL_Extension__r.Suit_Filed_Status27__c).contains('XX') || (cb.CIBIL_Extension__r.Suit_Filed_Status27__c).contains('0'))))) {
                writeOff = true;

            }
            if (!(cb.CIBIL_Extension__r.Suit_Filed_Status28__c == null || cb.CIBIL_Extension__r.Suit_Filed_Status28__c == '' || (cb.CIBIL_Extension__r.Suit_Filed_Status28__c != null && ((cb.CIBIL_Extension__r.Suit_Filed_Status28__c).contains('NO DATA') || (cb.CIBIL_Extension__r.Suit_Filed_Status28__c).contains('No Suit Filed') || (cb.CIBIL_Extension__r.Suit_Filed_Status28__c).contains('XX') || (cb.CIBIL_Extension__r.Suit_Filed_Status28__c).contains('0'))))) {
                writeOff = true;

            }
            if (!(cb.CIBIL_Extension__r.Suit_Filed_Status29__c == null || cb.CIBIL_Extension__r.Suit_Filed_Status29__c == '' || (cb.CIBIL_Extension__r.Suit_Filed_Status29__c != null && ((cb.CIBIL_Extension__r.Suit_Filed_Status29__c).contains('NO DATA') || (cb.CIBIL_Extension__r.Suit_Filed_Status29__c).contains('No Suit Filed') || (cb.CIBIL_Extension__r.Suit_Filed_Status29__c).contains('XX') || (cb.CIBIL_Extension__r.Suit_Filed_Status29__c).contains('0'))))) {
                writeOff = true;

            }
        }
        return writeOff;
    }
*/

    /* POS_PO-16621 rules 1-2-8*/
    public void calculateMaxDue(String due, String accountType,Date closedDate,String Ownership,String amtOver) {
        try {
            String dueString = due;
            Integer AccountwiseTDWithSubstrCount = 0;
            system.debug('dueString --#2777' + dueString);
            list < String > arrayNew = new list < String > ();
            if (dueString != null) {
                dueString = dueString.replace(' NO DATA', '');
                dueString = dueString.replace(' null', '');
                arrayNew = dueString.split(' ');
                system.debug('dueString --#2782' + dueString);
                system.debug('arrayNew::' + arrayNew);
            }
            list < String > splitDate = new list < String > ();
            if (arraynew.size() > 1) splitDate = arraynew[0].split('/');
            system.debug('splitDate --' + splitDate);
            List < string > dueValues = new List < String > ();
            Integer months = 0;
            Integer dpd_months = 0;//added by shilpa for for Bug 15257
            system.debug('splitDate.size() --' + splitDate.size());
            if (splitDate.size() > 2) {
                Date startDate = Date.parse(CIBILSegmentationHandler.convertMonthTextToNumber(splitDate[1]) + '/' + splitDate[0] + '/' + splitDate[2]);
                splitDate = arraynew[2].split('/');
                
                system.debug('arraynew --#2792' + arraynew[2]);
                system.debug('splitDate --#2787' + splitDate);
                Date endDate = Date.parse(CIBILSegmentationHandler.convertMonthTextToNumber(splitDate[1]) + '/' + splitDate[0] + '/' + splitDate[2]);
                dueValues = arrayNew[1].split('-');
                system.debug('***endDate :'+endDate +'**startDate**'+startDate);
                /*added by shilpa for Bug 15257 start*/
                Date todayDt=Date.today();
                system.debug('ms>>>today is '+todayDt);
                //startdt-enddt
                system.debug('startDate.monthsBetween(todayDt) :: '+startDate.monthsBetween(todayDt));
                if (startDate != null) dpd_months = startDate.monthsBetween(todayDt);
                Integer Month3 = 0;
                Integer Month6 = 0;
                Integer Month24 = 0; //2.0 CR
                if(dpd_months<=6){
                    Month6 =1;
                }
                if(dpd_months<=3){
                    Month3 =1;
                }
                /*2.0 CR s*/
                if(dpd_months<=24){
                    Month24 =1;
                }
                /*2.0 CR e*/
                /*added by shilpa for Bug 15257 end*/
                System.debug('6th month'+Month6);
                System.debug('3th month'+Month3);
                if (endDate != null) months = endDate.monthsBetween(startDate);
                Integer i;
                system.debug('**months::'+months);
                integer /*17138*/ccDPD = 0, creditDPD = 0,glDPD = 0,assetViewNo = 0,X6monthsDPD90 = 0 , X3LessmonthsDPD = 0, /*17138*/maxDelequentDPD = 0, maxDelinquentTradecnt = 0, maxSecuredDelequentDPD = 0,X12monthsDPD = 0, X3monthsDPD = 0, X6monthsDPD = 0; //OTP V3 Cibil X6monthsDPD
                Boolean deliquentDPD = false, securedDeliquentDPD = false;
                 Integer last24Months = 0; // Bug Id : 20187 S
                DateTime todaysD = System.now();
                DateTime past24Months = todaysD.addMonths(-24);
                System.debug('past24Months -->' + past24Months + ' startDate --> ' + startDate);
                if (startDate <= Date.valueOf(todaysD) && startDate >= Date.valueOf(past24Months)) {
                    last24Months = 1;
                } // Bug Id : 20187 E
                /* POS_PO-16621 starts */
                  Boolean isBOLProd = CIBILSegmentationHandler.getBOLProductLineProduct(product); // Bug Id : 20187
                 //Added by Rohan on 02-06-2018 | Loop end condition changed from months to months-1
                 //null check
                if(dueValues != null && dueValues.size()!=null && dueValues.size()>0){
                    for (i = 0; i < months-1; i++){
                    system.debug('Gulshan Loop...'+i);
                        if (dueValues.size()<i && dueValues[i] != null ) {
                            system.debug('Gulshan Inside If'+dueValues[i].equalsIgnoreCase('STD'));
                            if (!dueValues[i].equalsIgnoreCase('XXX') && !dueValues[i].equalsIgnoreCase('STD') && !dueValues[i].equalsIgnoreCase('DBT') && !dueValues[i].equalsIgnoreCase('SMA') && !dueValues[i].equalsIgnoreCase('LSS') && !dueValues[i].equalsIgnoreCase('SUB')) {
                                
                                if (Integer.valueOf(dueValues[i]) > 90) {
                                    maxSecuredDelequentDPD = Integer.valueOf(dueValues[i]);
                                }
                            } else if (dueValues[i].equalsIgnoreCase('DBT') || dueValues[i].equalsIgnoreCase('SMA') || dueValues[i].equalsIgnoreCase('LSS') || dueValues[i].equalsIgnoreCase('SUB')) {
                                securedDeliquentDPD = true;
                                //Added by Rohan on 02-06-2018 | Condition Added for Live Loan and GuarantorExcluding
                                system.debug('Inside IF....');
                                system.debug('closedDate::Ownership::'+closedDate+Ownership);
                                if(closedDate == null && Ownership !='Guarantor')
                                {
                                    system.debug('inside if...AccountwiseTDWithSubstrCount  '+AccountwiseTDWithSubstrCount);
                                    AccountwiseTDWithSubstrCount++;
                                    //TDWithSubstrCount++;  // POS_disbursal
                                    
                                }   
                            }
                            
                            system.debug('Gulshan Inside Else');
                            if (!dueValues[i].equalsIgnoreCase('XXX') && !dueValues[i].equalsIgnoreCase('STD') && !dueValues[i].equalsIgnoreCase('DBT') && !dueValues[i].equalsIgnoreCase('SMA') && !dueValues[i].equalsIgnoreCase('LSS') && !dueValues[i].equalsIgnoreCase('SUB')) {
                                system.debug('***dueValues[i] ****:'+dueValues[i] );
                                if (maxDueEver < Integer.valueOf(dueValues[i])) {
                                    maxDueEver = Integer.valueOf(dueValues[i]);
                                    //  system.debug('***maxDueEver ****:'+maxDueEver );
                                    
                                }
                            }
                            //Added by Rohan on 02-06-2018 | Condition Added for Live Loan and GuarantorExcluding
                            else if (dueValues[i].equalsIgnoreCase('DBT') || dueValues[i].equalsIgnoreCase('SMA') || dueValues[i].equalsIgnoreCase('LSS') || dueValues[i].equalsIgnoreCase('SUB')) {
                                system.debug('Else**closedDate::Ownership::'+closedDate+Ownership);
                                if(closedDate == null && Ownership !='Guarantor')
                                {
                                    system.debug('inside else...AccountwiseTDWithSubstrCount  '+AccountwiseTDWithSubstrCount);
                                    AccountwiseTDWithSubstrCount++;
                                    //TDWithSubstrCount++;  // POS_disbursal
                                    
                                }   
                                
                            }
                            
                        }
                        
                    system.debug('AccountwiseTDWithSubstrCount Value   '+AccountwiseTDWithSubstrCount);
                }
                }
                
                /* POS_PO-16621 ends */
                if (months > 12) months = 12;
                system.debug('***months :'+months );
                /* POS_PO-16621 starts */
                  if (isBOLProd && dueValues[i] != null) {// Bug Id : 20187 start
                        if (last24Months == 1) { 
                            if (!dueValues[i].equalsIgnoreCase('XXX') && !dueValues[i].equalsIgnoreCase('000')) {
                                dpdLast24Mnths++;
                            }
                        }
                        System.debug('dpdLast24Mnths inside if -->' + dpdLast24Mnths);
                    } // Bug Id : 20187 end

                 //Added By Gulshan for the Fixing of DI@POS CIBIL Rule 4
                if (AccountwiseTDWithSubstrCount > 0)
                    TDWithSubstrCount++;
                //Ended By Gulshan for the Fixing of DI@POS CIBIL Rule 4
                
                    //Below condition added by Rohan on 02-06-2018
                   system.debug('***Rohan product::'+product);
                   system.debug('product-->'+product);
                    //Bug:17470
                              isPROProductLineProduct = getPROProductLineLFlag(product);
                   if((product!=null && SegmentProduct!=null && SegmentProduct.ToUpperCase().contains(product.ToUppercase())) || (product!=null && (isPROProductLineProduct))){                    system.debug('***in product:');
                       //Bug 17138 s
                       //2.0 CR added if condition
                       system.debug('due months'+Month24+'---'+dpd_months);
                        if(Month24 == 1){
                            Integer noMonths = 24 - dpd_months; //2.0 CR
                            
                                for (i = 0; i < noMonths; i++) {
                                if(dueValues.size() > i){
                                    if (!dueValues[i].equalsIgnoreCase('XXX') && !dueValues[i].equalsIgnoreCase('STD') && !dueValues[i].equalsIgnoreCase('DBT') && !dueValues[i].equalsIgnoreCase('SMA') && !dueValues[i].equalsIgnoreCase('LSS') && !dueValues[i].equalsIgnoreCase('SUB')) {
                                        if (Integer.valueOf(dueValues[i]) >= 30) {
                                            if(accountType == 'Credit Card') creditDPD++; //Bug 17138
                                        }
                                    }
                                }
                            }
                            
                        }
                        system.debug('creditDPD---'+creditDPD);
                        //Bug 17138 e
                    /* POS_PO-16621 ends*/
                    Integer dpdCount6 = 0; //added by prashant for mobility v2
                   //null check                                                                                                                                                            
                if(dueValues != null && dueValues.size()!=null && dueValues.size()>0){
                    for (i = 0; i <= 11; i++) {
                        system.debug('***dueValues size :'+dueValues);
                        system.debug('***i :'+i);
                        if (i >= dueValues.size()) {
                            system.debug('**else:');
                        }else{
                            system.debug('**dueValues[i] for test:'+dueValues[i]);
                            if (!dueValues[i].equalsIgnoreCase('XXX') && !dueValues[i].equalsIgnoreCase('STD') && !dueValues[i].equalsIgnoreCase('DBT') && !dueValues[i].equalsIgnoreCase('SMA') && !dueValues[i].equalsIgnoreCase('LSS') && !dueValues[i].equalsIgnoreCase('SUB')) {
                                if (maxDue < Integer.valueOf(dueValues[i])) {
                                    maxDue = Integer.valueOf(dueValues[i]);
                                }
                                system.debug('***Rohan product::'+product);
                                if((product!=null && SegmentProduct!=null && SegmentProduct.ToUpperCase().contains(product.ToUppercase())) || (product!=null && (isPROProductLineProduct))){
                                    system.debug('***dueValues[i]::'+dueValues[i]);
                                    if (Integer.valueOf(dueValues[i]) >= 30) {
                                        if (Month3==1 && i < 3 - dpd_months) X3monthsDPD++;//added whichMonth for Bug 15257 by shilpa
                                        //if (i < 6 && Month6==1)  X6monthsDPD++;  //OTP V3 Cibil//added whichMonth for Bug 15257 by shilpa
                                         system.debug('dpd_months'+dpd_months+accountType);
                                         if (Month6==1 && i < 6 - dpd_months && accountType != 'Gold Loan' && accountType != 'Credit Card' && accountType != 'CC' )  X6monthsDPD++;  //changed by prashant for mobility v2
                                        system.debug('dpdCount6'+dpdCount6);
                                        //if(dpdCount6 > 1)X6monthsDPD++;
                                        /*POS_PO-16621 starts */
                                        if (i < 12) X12monthsDPD++; //POS_disbursal
                                        system.debug('X12monthsDPD'+X12monthsDPD);
                                        /*POS_PO-16621 ends */
                                        //2.0 CR added conditon below
                                        if(month6 == 1 && i < 6 - dpd_months && accountType == 'Credit Card') ccDPD++; //Bug 17138
                                        if(accountType == 'Gold Loan' && amtOver != null && amtOver != 'NO DATA' && Integer.valueof(amtOver) > 0) glDPD++; //Bug 17138
                                        maxDelinquentTradecnt++;
                                        maxDelequentDPD = Integer.valueOf(dueValues[i]);
                                    }
                                    /*Bug 17138 s*/
                                    //2.0 CR added if condition
                                    if(month6 == 1){
                                        if (accountType != 'Gold Loan' && accountType != 'Credit Card' && accountType != 'CC' && Integer.valueOf(dueValues[i]) >= 90) {
                                            if (i < 6 - dpd_months )  X6monthsDPD90++;
                                        }
                                        else {
                                            if(dueValues[0] != null && dueValues[1] != null && dueValues[2] != null){
                                                if(accountType != 'Gold Loan' && accountType != 'Credit Card'  && accountType != 'CC' && !dueValues[0].equalsIgnoreCase('XXX') && !dueValues[0].equalsIgnoreCase('STD') && !dueValues[0].equalsIgnoreCase('DBT') && !dueValues[0].equalsIgnoreCase('SMA') && !dueValues[0].equalsIgnoreCase('LSS') && !dueValues[0].equalsIgnoreCase('SUB') && !dueValues[1].equalsIgnoreCase('XXX') && !dueValues[1].equalsIgnoreCase('STD') && !dueValues[1].equalsIgnoreCase('DBT') && !dueValues[1].equalsIgnoreCase('SMA') && !dueValues[1].equalsIgnoreCase('LSS') && !dueValues[1].equalsIgnoreCase('SUB') && !dueValues[2].equalsIgnoreCase('XXX') && !dueValues[2].equalsIgnoreCase('STD') && !dueValues[2].equalsIgnoreCase('DBT') && !dueValues[2].equalsIgnoreCase('SMA') && !dueValues[2].equalsIgnoreCase('LSS') && !dueValues[2].equalsIgnoreCase('SUB') && (Integer.valueOf(dueValues[0] ) >= 30 && Integer.valueOf(dueValues[1] ) >= 30 && Integer.valueOf(dueValues[2] ) >= 30))
                                                    X6monthsDPD90++;
                                            }
                                            
                                        }
                                    }
                                    /*Bug 17138 e*/
                                    /*POS_PO-16621 starts */
                                    //POS_disbursal
                                    if (Integer.valueOf(dueValues[i]) > 0 && Integer.valueOf(dueValues[i]) <= 30) {
                                        System.debug('Line 3830 X3LessmonthsDPD '+X3LessmonthsDPD);
                                        if (i < 3)  X3LessmonthsDPD++;
                                       
                                    }
                                    /*POS_PO-16621 ends */
                                }else{ 
                                    if (Integer.valueOf(dueValues[i]) > 30) {
                                        if (Month3==1 && i < 3 - dpd_months) X3monthsDPD++;//added whichMonth for Bug 15257 by shilpa
                                        //if (Month6==1 && i < 6 - dpd_months)  X6monthsDPD++;  //OTP V3 Cibil//added whichMonth for Bug 15257 by shilpa
                                        if (Month6==1 && i < 6 - dpd_months && accountType != 'Gold Loan' && accountType != 'Credit Card' && accountType != 'CC' )  X6monthsDPD++;  //changed by prashant for mobility v2
                                        /*POS_PO-16621 starts */
                                        if (i < 12) X12monthsDPD++; //POS_disbursal
                                        /*POS_PO-16621 ends */
                                        if(month6 == 1 && i < 6 - dpd_months && accountType == 'Credit Card') ccDPD++; //Bug 17138
                                        if(accountType == 'Gold Loan' && amtOver != null && amtOver != 'NO DATA' && Integer.valueof(amtOver) > 0) glDPD++; //Bug 17138
                                        maxDelinquentTradecnt++;
                                        maxDelequentDPD = Integer.valueOf(dueValues[i]);
                                    }
                                    /*Bug 17138 s*/
                                    if(month6 == 1){
                                    if (accountType != 'Gold Loan' && accountType != 'Credit Card' && accountType != 'CC' && Integer.valueOf(dueValues[i]) >= 90) {
                                        if (i < 6 - dpd_months)  X6monthsDPD90++;
                                    }
                                    else if(accountType != 'Gold Loan' && accountType != 'Credit Card'  && accountType != 'CC' && !dueValues[0].equalsIgnoreCase('XXX') && !dueValues[0].equalsIgnoreCase('STD') && !dueValues[0].equalsIgnoreCase('DBT') && !dueValues[0].equalsIgnoreCase('SMA') && !dueValues[0].equalsIgnoreCase('LSS') && !dueValues[0].equalsIgnoreCase('SUB') && !dueValues[1].equalsIgnoreCase('XXX') && !dueValues[1].equalsIgnoreCase('STD') && !dueValues[1].equalsIgnoreCase('DBT') && !dueValues[1].equalsIgnoreCase('SMA') && !dueValues[1].equalsIgnoreCase('LSS') && !dueValues[1].equalsIgnoreCase('SUB') && !dueValues[2].equalsIgnoreCase('XXX') && !dueValues[2].equalsIgnoreCase('STD') && !dueValues[2].equalsIgnoreCase('DBT') && !dueValues[2].equalsIgnoreCase('SMA') && !dueValues[2].equalsIgnoreCase('LSS') && !dueValues[2].equalsIgnoreCase('SUB') && (Integer.valueOf(dueValues[0] ) >= 30 && Integer.valueOf(dueValues[1] ) >= 30 && Integer.valueOf(dueValues[2] ) >= 30))
                                         X6monthsDPD90++;
                                    }
                                    /*Bug 17138 e*/
                                    /*POS_PO-16621 starts */
                                    //POS_disbursal
                                    if (Integer.valueOf(dueValues[i]) > 0 && Integer.valueOf(dueValues[i]) <= 30) {
                                            System.debug('Line 3859 X3LessmonthsDPD '+X3LessmonthsDPD);
                                        if (i < 3)  X3LessmonthsDPD++;
                                       
                                    }
                                    
                                    /*POS_PO-16621 ends */
                                }
                            }else if (dueValues[i].equalsIgnoreCase('DBT') || dueValues[i].equalsIgnoreCase('SMA') || dueValues[i].equalsIgnoreCase('LSS') || dueValues[i].equalsIgnoreCase('SUB')) {
                                deliquentDPD = true;
                                maxDelinquentTradecnt++;
                                assetViewNo++;//Bug 17138
                                if (Month3==1 && i < 3 - dpd_months) X3monthsDPD++;//added whichMonth for Bug 15257 by shilpa
                                //if (Month6==1 && i < 6 - dpd_months)  X6monthsDPD++;  //OTP V3 Cibil//added whichMonth for Bug 15257 by shilpa
                                if (Month6==1 && i < 6 - dpd_months && accountType != 'Gold Loan' && accountType != 'Credit Card' && accountType != 'CC' )  X6monthsDPD++;  //changed by prashant for mobility v2
                                /*POS_PO-16621 starts */
                                if (i < 12) X12monthsDPD++; //POS_disbursal
                                /*POS_PO-16621 ends */
                            }
                        }
                    }}                                                                                                                                                         
                   
                }else{
                    system.debug('Hello else');
                    //Bug 17138 s
                    //2.0 CR added if condition
                    if(Month24 == 1){
                        Integer noMonths = 24 - dpd_months; //2.0 CR
                            for (i = 0; i < noMonths; i++) {
                            if(dueValues.size() > i){
                                if (!dueValues[i].equalsIgnoreCase('XXX') && !dueValues[i].equalsIgnoreCase('STD') && !dueValues[i].equalsIgnoreCase('DBT') && !dueValues[i].equalsIgnoreCase('SMA') && !dueValues[i].equalsIgnoreCase('LSS') && !dueValues[i].equalsIgnoreCase('SUB')) {
                                    if (Integer.valueOf(dueValues[i]) >= 30) {
                                        if(accountType == 'Credit Card') creditDPD++; //Bug 17138
                                    }
                                }
                            }
                        }
                    }
                    //Bug 17138 e
                    system.debug('inside else @@');
                    //null check
                    if(dueValues != null && dueValues.size()!=null && dueValues.size()>0){
                        for (i = 0; i <= months; i++) {
                        system.debug('***dueValues[i] outside if :'+dueValues[i]);
                        system.debug('***dueValues[i] outside if :'+dueValues.size());
                        //if (dueValues.size()<=i && dueValues[i] != null ) {
                        //Below condition is changed to > from < by Gulshan Mathur BUG ID :- 20187
                        if (dueValues.size()> i && dueValues[i] != null ) {
                            system.debug('***dueValues[i]:'+dueValues[i]);
                            if (!dueValues[i].equalsIgnoreCase('XXX') && !dueValues[i].equalsIgnoreCase('STD') && !dueValues[i].equalsIgnoreCase('DBT') && !dueValues[i].equalsIgnoreCase('SMA') && !dueValues[i].equalsIgnoreCase('LSS') && !dueValues[i].equalsIgnoreCase('SUB')) {
                                if (maxDue < Integer.valueOf(dueValues[i])) {
                                    maxDue = Integer.valueOf(dueValues[i]);
                                }
                                              //Bug:17470
                                          isPROProductLineProduct = getPROProductLineLFlag(product); 
                                if((product!=null && SegmentProduct!=null && SegmentProduct.ToUpperCase().contains(product.ToUppercase())) || (product!=null && (isPROProductLineProduct))){
                                    system.debug('***dueValues[i]::'+dueValues[i]);
                                    if (Integer.valueOf(dueValues[i]) >= 30) {
                                        if (Month3==1 && i < 3 - dpd_months) X3monthsDPD++; //added whichMonth for Bug 15257 by shilpa
                                        //if (Month6==1 && i < 6 - dpd_months)  X6monthsDPD++;  //OTP V3 Cibil //added whichMonth for Bug 15257 by shilpa
                                        if (Month6==1 && i < 6 - dpd_months && accountType != 'Gold Loan' && accountType != 'Credit Card' && accountType != 'CC' )  X6monthsDPD++;  //changed by prashant for mobility v2
                                        /*POS_PO-16621 starts */
                                        if (i < 12) X12monthsDPD++; //POS_disbursal
                                        /*POS_PO-16621 ends*/
                                        if(month6 == 1 && i < 6 - dpd_months && accountType == 'Credit Card') ccDPD++; //Bug 17138
                                        if(accountType == 'Gold Loan' && amtOver != null && amtOver != 'NO DATA' && Integer.valueof(amtOver)> 0) glDPD++; //Bug 17138
                                        maxDelinquentTradecnt++;
                                        maxDelequentDPD = Integer.valueOf(dueValues[i]);
                                    }
                                    /*Bug 17138 s*/
                                    if(month6 == 1){
                                    if (accountType != 'Gold Loan' && accountType != 'Credit Card' && accountType != 'CC' && Integer.valueOf(dueValues[i]) >= 90) {
                                        if (i < 6 - dpd_months)  X6monthsDPD90++;
                                    }
                                    else if(accountType != 'Gold Loan' && accountType != 'Credit Card'  && accountType != 'CC' && !dueValues[0].equalsIgnoreCase('XXX') && !dueValues[0].equalsIgnoreCase('STD') && !dueValues[0].equalsIgnoreCase('DBT') && !dueValues[0].equalsIgnoreCase('SMA') && !dueValues[0].equalsIgnoreCase('LSS') && !dueValues[0].equalsIgnoreCase('SUB') && !dueValues[1].equalsIgnoreCase('XXX') && !dueValues[1].equalsIgnoreCase('STD') && !dueValues[1].equalsIgnoreCase('DBT') && !dueValues[1].equalsIgnoreCase('SMA') && !dueValues[1].equalsIgnoreCase('LSS') && !dueValues[1].equalsIgnoreCase('SUB') && !dueValues[2].equalsIgnoreCase('XXX') && !dueValues[2].equalsIgnoreCase('STD') && !dueValues[2].equalsIgnoreCase('DBT') && !dueValues[2].equalsIgnoreCase('SMA') && !dueValues[2].equalsIgnoreCase('LSS') && !dueValues[2].equalsIgnoreCase('SUB') && (Integer.valueOf(dueValues[0] ) >= 30 && Integer.valueOf(dueValues[1] ) >= 30 && Integer.valueOf(dueValues[2] ) >= 30))
                                         X6monthsDPD90++;
                                    }
                                    /*Bug 17138 e*/
                                    /*POS_PO-16621 starts */
                                     //POS_disbursal
                                    if (Integer.valueOf(dueValues[i]) > 0 && Integer.valueOf(dueValues[i]) <= 30) {
                                            System.debug('Line 3915  X3LessmonthsDPD '+X3LessmonthsDPD);
                                        if (i < 3)  X3LessmonthsDPD++;
                                       
                                    }
                                    /*POS_PO-16621 ends*/
                                }else{ 
                                    system.debug('***dueValues[i] inside else ::'+dueValues[i]);
                                    if (Integer.valueOf(dueValues[i]) > 30) {
                                        if (Month3==1 && i < 3 - dpd_months) X3monthsDPD++; //added whichMonth for Bug 15257 by shilpa
                                        //if (Month6==1 && i < 6 - dpd_months)  X6monthsDPD++;  //OTP V3 Cibil //added whichMonth for Bug 15257 by shilpa
                                        if (Month6==1 && i < 6 - dpd_months && accountType != 'Gold Loan' && accountType != 'Credit Card' && accountType != 'CC' )  X6monthsDPD++;  //changed by prashant for mobility v2
                                        /*POS_PO-16621 starts*/
                                        if (i < 12) X12monthsDPD++; //POS_disbursal
                                        /*POS_PO-16621 ends*/
                                        if(month6 == 1 && i < 6 - dpd_months && accountType == 'Credit Card') ccDPD++; //Bug 17138
                                        if(accountType == 'Gold Loan' && amtOver != null && amtOver != 'NO DATA' && Integer.valueof(amtOver)> 0) glDPD++; //Bug 17138
                                        maxDelinquentTradecnt++;
                                        maxDelequentDPD = Integer.valueOf(dueValues[i]);
                                    }
                                    /*Bug 17138 s*/
                                    if(month6 == 1){
                                    if (accountType != 'Gold Loan' && accountType != 'Credit Card' && accountType != 'CC' && Integer.valueOf(dueValues[i]) >= 90) {
                                        if (i < 6 - dpd_months)  X6monthsDPD90++;
                                    }
                                    else if(accountType != 'Gold Loan' && accountType != 'Credit Card'  && accountType != 'CC' && !dueValues[0].equalsIgnoreCase('XXX') && !dueValues[0].equalsIgnoreCase('STD') && !dueValues[0].equalsIgnoreCase('DBT') && !dueValues[0].equalsIgnoreCase('SMA') && !dueValues[0].equalsIgnoreCase('LSS') && !dueValues[0].equalsIgnoreCase('SUB') && !dueValues[1].equalsIgnoreCase('XXX') && !dueValues[1].equalsIgnoreCase('STD') && !dueValues[1].equalsIgnoreCase('DBT') && !dueValues[1].equalsIgnoreCase('SMA') && !dueValues[1].equalsIgnoreCase('LSS') && !dueValues[1].equalsIgnoreCase('SUB') && !dueValues[2].equalsIgnoreCase('XXX') && !dueValues[2].equalsIgnoreCase('STD') && !dueValues[2].equalsIgnoreCase('DBT') && !dueValues[2].equalsIgnoreCase('SMA') && !dueValues[2].equalsIgnoreCase('LSS') && !dueValues[2].equalsIgnoreCase('SUB') && (Integer.valueOf(dueValues[0] ) >= 30 && Integer.valueOf(dueValues[1] ) >= 30 && Integer.valueOf(dueValues[2] ) >= 30))
                                         X6monthsDPD90++;
                                    }
                                    /*Bug 17138 e*/ 
                                    /*POS_PO-16621 starts*/
                                     //POS_disbursal
                                    if (Integer.valueOf(dueValues[i]) > 0 && Integer.valueOf(dueValues[i]) <= 30) {
                                            System.debug('Line 3943 X3LessmonthsDPD '+X3LessmonthsDPD);
                                        if (i < 3)  X3LessmonthsDPD++;
                                       
                                    }
                                    /*POS_PO-16621 ends*/
                                }
                            }else if (dueValues[i].equalsIgnoreCase('DBT') || dueValues[i].equalsIgnoreCase('SMA') || dueValues[i].equalsIgnoreCase('LSS') || dueValues[i].equalsIgnoreCase('SUB')) {
                                deliquentDPD = true;
                                assetViewNo++;//Bug 17138
                                maxDelinquentTradecnt++;
                                if (Month3==1 && i < 3 - dpd_months) X3monthsDPD++; //added whichMonth for Bug 15257 by shilpa
                                //if (Month6==1 && i < 6 - dpd_months)  X6monthsDPD++;  //OTP V3 Cibil //added whichMonth for Bug 15257 by shilpa
                                if (Month6==1 && i < 6 - dpd_months && accountType != 'Gold Loan' && accountType != 'Credit Card' && accountType != 'CC' )  X6monthsDPD++;  //changed by prashant for mobility v2
                                /*POS_PO-16621 starts*/
                                if (i < 12) X12monthsDPD++; 
                                
                                if (Integer.valueOf(dueValues[i]) > 0 && Integer.valueOf(dueValues[i]) <= 30) {
                                            System.debug('Line 3958 X3LessmonthsDPD '+X3LessmonthsDPD);
                                        if (i < 3)  X3LessmonthsDPD++;
                                       
                                    }
                                    /*POS_PO-16621 ends*/
                            }
                        }
                    }
                    }
                    
                }
                if (maxDelinquentTradecnt > maxDelinquencyCnt) {
                    maxDelinquencyCnt = maxDelinquentTradecnt;
                }
                system.debug(maxDelinquencyCnt + '-- maxDelinquencyCnt -- maxDelequentDPD -- ' + maxDelequentDPD);
                //if(maxDelinquentTradecnt > maxDelinquencyCnt)
                //  delinquentTradecnt = maxDelinquentTradecnt;
                //Segmentation changes
                
                if(product!=null && SegmentProduct!=null && SegmentProduct.ToUpperCase().contains(product.ToUppercase())){
                    if (maxDelequentDPD >= 30)
                    delinquentTradecnt++;
                    
                }else{
                    if (maxDelequentDPD > 30 || deliquentDPD) {
                        delinquentTradecnt++;
                    }
                }
                system.debug('--&&&&&& delinquentTradecnt :: '+delinquentTradecnt);
                system.debug('X3monthsDPD ::: '+X3monthsDPD);
                if (X3monthsDPD > 0) X30DPD3Months++;
                system.debug('--&&&&&& X6monthsDPD :: '+X6monthsDPD);
                if (X6monthsDPD > 1) X30DPD6Months++; //OTP V3 Cibil 
                
                /* POS_PO-16621 starts */
                //Following if condition modified By Gulshan for the Fixing of DI@POS CIBIL Rule 1 
                //if(closedDate != null && Ownership != 'Guarantor'){ // POS_disbursal  condition for not guarantor
                 if(closedDate == null && accountType != 'Credit Card' ){  // BUG -27602 && accountType != 'Credit Card' 
                    if (X6monthsDPD > 0) X30DPD6Months_POS++; // POS_disbursal  
                     system.debug('--&&&&&& X6monthsDPD :: '+X6monthsDPD+'--X30DPD6Months_POS'+X30DPD6Months_POS); 
                    if(X12monthsDPD>0 && !(accountType.contains('Credit Card'))) X30DPD12Months++; // POS_disbursal changed by Rohan               
                
                system.debug('Gulshan Semi final X3LessmonthsDPD'+X3LessmonthsDPD);
                //Added by mahima - 17588- Bol revamp - start
                System.debug('X12monthsDPD --> ' + X12monthsDPD);
                
                if(X12monthsDPD>0 && (!(accountType.contains('Credit Card') || accountType.contains('Gold Loan')))){
                    X30DPD12MonthsWithoutCCGL++;
                }
                //Added by mahima - 17588- Bol revamp - end
                System.debug('X30DPD12MonthsWithoutCCGL--> ' + X30DPD12MonthsWithoutCCGL);
                if(X3LessmonthsDPD>0) {
                system.debug('Gulshan final X3LessmonthsDPD'+X3LessmonthsDPD);
                X30LessDPD3Months++;//POS_disbursal
                 system.debug('Gulshan final X30LessDPD3Months'+X30LessDPD3Months);
                }
                    
                }
                /* POS_PO-16621 Ends */
                system.debug('creditDPD'+creditDPD);
                system.debug('ccDPD'+ccDPD);
                if (creditDPD> 0) XDPDCC++; //Bug 17138
                if (ccDPD > 0) X30DPDCC++; //Bug 17138
                if (glDPD > 0) X30DPDGL++; //Bug 17138
                if(assetViewNo > 0) assetView++; //Bug 17138
                if(X6monthsDPD90 > 0) X90DPD6Months++; //Bug 17138
                
                ATOSParameters__c Secured = new ATOSParameters__c();
                String securedLoans = '';
                if(product!=null && SegmentProduct!=null && SegmentProduct.ToUpperCase().contains(product.ToUppercase())){
                    secured = ATOSParameters__c.getValues('SegmentationSecuredLoan');
                    if (secured != null && secured.value__c != null) {
                        securedLoans = secured.value__c;
                    } 
                }else{
                    Secured = ATOSParameters__c.getValues('Secured');
                    if (Secured != null && Secured.value__c != null) {
                        securedLoans = Secured.value__c;
                    }
                }
                if ((maxSecuredDelequentDPD > 90 || securedDeliquentDPD) && accountType != null && securedLoans.indexOf(accountType) != -1) {
                    delinquentSecuredTradelines++;
                }
                 // Bud Id : 20187
                if (dpdLast24Mnths > 0) {
                    noOfDPD24Months++;
                }
            }
        } catch (Exception e) {
            system.debug('--&&&&&& e :: '+e+'**line*'+e.getLineNumber());
        }
    }
    /*Start BUG-16959*/
    public boolean getPSBLorDBOLProductLineFlag(String product){
        boolean isPSBLProductLineProduct1 = false;
        transient string PSBLProductLineProducts = Label.PSBL_ProductLine_Products;
        if(PSBLProductLineProducts != null && PSBLProductLineProducts != '' )
        {
            set < string > setPSBLProdName = new set < string > ();
            setPSBLProdName.addAll(PSBLProductLineProducts.split(';'));
            if (setPSBLProdName != null && setPSBLProdName.size() > 0 && product !='' && product != null ) 
            {
                if(setPSBLProdName.contains(product.toUpperCase()))
                    isPSBLProductLineProduct1 = true;
            }
        }
      return isPSBLProductLineProduct1;
   }
    /*End BUG-16959*/

    private void checkLastThreeMothEnquiries(String purpose, String enquiryDate1, String accountType) {
        String enquiryDateText = enquiryDate1;
        string month = '', day = '', year = '', formatDate = '';
        if (enquiryDateText != null && enquiryDateText.length() == 8) {
            month = enquiryDateText.substring(2, 4);
            day = enquiryDateText.substring(0, 2);
            year = enquiryDateText.substring(4, 8);
            formatDate = month + '/' + day + '/' + year;
            Date enquiryDate = Date.parse(formatDate);
            system.debug(purpose + ' -- purpose enquiryDate - ' + enquiryDate);
            system.debug(cibilFiredDate + ' -- cibilFiredDate -- enquiryDate - ' + enquiryDate.daysBetween(cibilFiredDate));
            //Segmentation changes
            /* if(product!=null && SegmentProduct!=null && SegmentProduct.ToUpperCase().contains(product.ToUppercase())){
                    if (purpose != null && !purpose.equalsIgnoreCase('NO DATA') && (enquiryDate.daysBetween(cibilFiredDate)) <= 90) {
                        ATOSParameters__c unsecured = new ATOSParameters__c();
                        String unsecuredLoans = '';
                        unsecured = ATOSParameters__c.getValues('SegmentationUnSecuredLoan');
                        if (unsecured != null && unsecured.value__c != null) {
                            unsecuredLoans = unsecured.value__c;
                        }
                        if (unsecuredLoans.indexOf(purpose) != -1) {
                            unsecuredEnquiry = unsecuredEnquiry + 1;
                            system.debug('SegmentationUnSecuredLoan - ' + unsecuredEnquiry);
                        }
                        enquiry++;
                    } 
                        
            }else{  */ 
            if (purpose != null && !purpose.equalsIgnoreCase('NO DATA') && (enquiryDate.daysBetween(cibilFiredDate) + 1) < 93) {
                ATOSParameters__c unsecured = new ATOSParameters__c();
                String unsecuredLoans = '';
                unsecured = ATOSParameters__c.getValues('Unsecured');
                if (unsecured != null && unsecured.value__c != null) {
                    unsecuredLoans = unsecured.value__c;
                }
                /* POS_PO-16621 starts */
                //Following By Gulshan for the Fixing of DI@POS CIBIL Rule 5
                //if (unsecuredLoans.indexOf(purpose) != -1) {
                  if (unsecuredLoans.ToUpperCase().indexOf(purpose.ToUpperCase()) != -1) {  
                    unsecuredEnquiry = unsecuredEnquiry + 1;
                    system.debug('unsecuredEnquiry - ' + unsecuredEnquiry);
                }
                /* POS_PO-16621 ends */
                if((enquiryDate<=cibilFiredDate) && (enquiryDate.daysBetween(cibilFiredDate) + 1) < 93)
                enquiry++;
            }
            //}
        }
    }

    public integer securedTradeLines(Cibil__c cb) {
        String securedLoans = '';
        system.debug('**SegmentProduct**'+SegmentProduct+'*product***'+product); 
        if(product!=null && SegmentProduct!=null && SegmentProduct.ToUpperCase().contains(product.ToUppercase())){
            ATOSParameters__c secured = new ATOSParameters__c();
            secured = ATOSParameters__c.getValues('SegmentationSecuredLoan');
            if (secured != null && secured.value__c != null) {
                securedLoans = secured.value__c;
                system.debug('**SegmentProduct*in*'+SegmentProduct);  
            } 
            
        }else{
            
            ATOSParameters__c secured = new ATOSParameters__c();
            secured = ATOSParameters__c.getValues('Secured');
            if (secured != null && secured.value__c != null) {
                securedLoans = secured.value__c;
            }
        }
        system.debug('**securedLoans **'+securedLoans );
        integer unsecuredLoanCnt = 0;
        if (cb.Account_Type__c != null && securedLoans.indexOf(cb.Account_Type__c) != -1) {
            //unsecuredTLCnt++;
            unsecuredLoanCnt++;
            if (cb.Current_Balance1__c != null) securedCurrentBalance = securedCurrentBalance + cb.Current_Balance__c;
            if (cb.Sanction_Amount1__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.Sanction_Amount__c;
        }
        if (cb.Account_Type1__c != null && securedLoans.indexOf(cb.Account_Type1__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.Current_Balance1__c != null) securedCurrentBalance = securedCurrentBalance + cb.Current_Balance1__c;
            if (cb.Sanction_Amount1__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.Sanction_Amount1__c;
        }
        system.debug('**cb.Account_Type2__c**'+cb.Account_Type2__c);
        
        if (cb.Account_Type2__c != null && securedLoans.indexOf(cb.Account_Type2__c) != -1) {
            unsecuredLoanCnt++;
            system.debug('*cb.Sanction_Amount2__c**'+cb.Sanction_Amount2__c);
            if (cb.Current_Balance2__c != null) securedCurrentBalance = securedCurrentBalance + cb.Current_Balance2__c;
            if (cb.Sanction_Amount2__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.Sanction_Amount2__c;
            system.debug('*totalSecuredSanctionAmount *'+totalSecuredSanctionAmount );
        }
        
        if (cb.Account_Type3__c != null && securedLoans.indexOf(cb.Account_Type3__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.Current_Balance3__c != null) securedCurrentBalance = securedCurrentBalance + cb.Current_Balance3__c;
            if (cb.Sanction_Amount3__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.Sanction_Amount3__c;
        }
        if (cb.Account_Type4__c != null && securedLoans.indexOf(cb.Account_Type4__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.Current_Balance4__c != null) securedCurrentBalance = securedCurrentBalance + cb.Current_Balance4__c;
            if (cb.Sanction_Amount4__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.Sanction_Amount4__c;
        }
        if (cb.Account_Type5__c != null && securedLoans.indexOf(cb.Account_Type5__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.Current_Balance5__c != null) securedCurrentBalance = securedCurrentBalance + cb.Current_Balance5__c;
            if (cb.Sanction_Amount5__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.Sanction_Amount5__c;
        }
        if (cb.Account_Type6__c != null && securedLoans.indexOf(cb.Account_Type6__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.Current_Balance6__c != null) securedCurrentBalance = securedCurrentBalance + cb.Current_Balance6__c;
            if (cb.Sanction_Amount6__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.Sanction_Amount6__c;
        }
        if (cb.Account_Type7__c != null && securedLoans.indexOf(cb.Account_Type7__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.Current_Balance7__c != null) securedCurrentBalance = securedCurrentBalance + cb.Current_Balance7__c;
            if (cb.Sanction_Amount7__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.Sanction_Amount7__c;
        }
        if (cb.Account_Type8__c != null && securedLoans.indexOf(cb.Account_Type8__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.Current_Balance8__c != null) securedCurrentBalance = securedCurrentBalance + cb.Current_Balance8__c;
            if (cb.Sanction_Amount8__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.Sanction_Amount8__c;
        }
        if (cb.Account_Type9__c != null && securedLoans.indexOf(cb.Account_Type9__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.Current_Balance9__c != null) securedCurrentBalance = securedCurrentBalance + cb.Current_Balance9__c;
            if (cb.Sanction_Amount9__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.Sanction_Amount9__c;
        }
        if (cb.Account_Type10__c != null && securedLoans.indexOf(cb.Account_Type10__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.Current_Balance10__c != null) securedCurrentBalance = securedCurrentBalance + cb.Current_Balance10__c;
            if (cb.Sanction_Amount10__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.Sanction_Amount10__c;
        }
        if (cb.Account_Type11__c != null && securedLoans.indexOf(cb.Account_Type11__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.Current_Balance11__c != null) securedCurrentBalance = securedCurrentBalance + cb.Current_Balance11__c;
            if (cb.Sanction_Amount11__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.Sanction_Amount11__c;
        }
        if (cb.Account_Type12__c != null && securedLoans.indexOf(cb.Account_Type12__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.Current_Balance12__c != null) securedCurrentBalance = securedCurrentBalance + cb.Current_Balance12__c;
            if (cb.Sanction_Amount12__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.Sanction_Amount12__c;
        }
        if (cb.Account_Type13__c != null && securedLoans.indexOf(cb.Account_Type13__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.Current_Balance13__c != null) securedCurrentBalance = securedCurrentBalance + cb.Current_Balance13__c;
            if (cb.Sanction_Amount13__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.Sanction_Amount13__c;
        }
        if (cb.Account_Type14__c != null && securedLoans.indexOf(cb.Account_Type14__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.Current_Balance14__c != null) securedCurrentBalance = securedCurrentBalance + cb.Current_Balance14__c;
            if (cb.Sanction_Amount14__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.Sanction_Amount14__c;
        }
        if (cb.Account_Type15__c != null && securedLoans.indexOf(cb.Account_Type15__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.Current_Balance15__c != null) securedCurrentBalance = securedCurrentBalance + cb.Current_Balance15__c;
            if (cb.Sanction_Amount15__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.Sanction_Amount15__c;
        }
        if (cb.Account_Type16__c != null && securedLoans.indexOf(cb.Account_Type16__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.Current_Balance16__c != null) securedCurrentBalance = securedCurrentBalance + cb.Current_Balance16__c;
            if (cb.Sanction_Amount16__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.Sanction_Amount16__c;
        }
        if (cb.Account_Type17__c != null && securedLoans.indexOf(cb.Account_Type17__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.Current_Balance17__c != null) securedCurrentBalance = securedCurrentBalance + cb.Current_Balance17__c;
            if (cb.Sanction_Amount17__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.Sanction_Amount17__c;
        }
        if (cb.Account_Type18__c != null && securedLoans.indexOf(cb.Account_Type18__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.Current_Balance18__c != null) securedCurrentBalance = securedCurrentBalance + cb.Current_Balance18__c;
            if (cb.Sanction_Amount18__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.Sanction_Amount18__c;
        }
        if (cb.Account_Type19__c != null && securedLoans.indexOf(cb.Account_Type19__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.Current_Balance19__c != null) securedCurrentBalance = securedCurrentBalance + cb.Current_Balance19__c;
            if (cb.Sanction_Amount19__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.Sanction_Amount19__c;
        }
        if (cb.CIBIL_Extension__r.Account_Type20__c != null && securedLoans.indexOf(cb.CIBIL_Extension__r.Account_Type20__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.CIBIL_Extension__r.Current_Balance20__c != null) securedCurrentBalance = securedCurrentBalance + cb.CIBIL_Extension__r.Current_Balance20__c;
            if (cb.CIBIL_Extension__r.Sanction_Amount20__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount20__c;
        }
        if (cb.CIBIL_Extension__r.Account_Type21__c != null && securedLoans.indexOf(cb.CIBIL_Extension__r.Account_Type21__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.CIBIL_Extension__r.Current_Balance21__c != null) securedCurrentBalance = securedCurrentBalance + cb.CIBIL_Extension__r.Current_Balance21__c;
            if (cb.CIBIL_Extension__r.Sanction_Amount21__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount21__c;
        }
        if (cb.CIBIL_Extension__r.Account_Type22__c != null && securedLoans.indexOf(cb.CIBIL_Extension__r.Account_Type22__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.CIBIL_Extension__r.Current_Balance22__c != null) securedCurrentBalance = securedCurrentBalance + cb.CIBIL_Extension__r.Current_Balance22__c;
            if (cb.CIBIL_Extension__r.Sanction_Amount22__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount22__c;
        }
        if (cb.CIBIL_Extension__r.Account_Type23__c != null && securedLoans.indexOf(cb.CIBIL_Extension__r.Account_Type23__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.CIBIL_Extension__r.Current_Balance23__c != null) securedCurrentBalance = securedCurrentBalance + cb.CIBIL_Extension__r.Current_Balance23__c;
            if (cb.CIBIL_Extension__r.Sanction_Amount23__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount23__c;
        }
        if (cb.CIBIL_Extension__r.Account_Type24__c != null && securedLoans.indexOf(cb.CIBIL_Extension__r.Account_Type24__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.CIBIL_Extension__r.Current_Balance24__c != null) securedCurrentBalance = securedCurrentBalance + cb.CIBIL_Extension__r.Current_Balance24__c;
            if (cb.CIBIL_Extension__r.Sanction_Amount24__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount24__c;
        }
        if (cb.CIBIL_Extension__r.Account_Type25__c != null && securedLoans.indexOf(cb.CIBIL_Extension__r.Account_Type25__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.CIBIL_Extension__r.Current_Balance25__c != null) securedCurrentBalance = securedCurrentBalance + cb.CIBIL_Extension__r.Current_Balance25__c;
            if (cb.CIBIL_Extension__r.Sanction_Amount25__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount25__c;
        }
        if (cb.CIBIL_Extension__r.Account_Type26__c != null && securedLoans.indexOf(cb.CIBIL_Extension__r.Account_Type26__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.CIBIL_Extension__r.Current_Balance26__c != null) securedCurrentBalance = securedCurrentBalance + cb.CIBIL_Extension__r.Current_Balance26__c;
            if (cb.CIBIL_Extension__r.Sanction_Amount26__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount26__c;
        }
        if (cb.CIBIL_Extension__r.Account_Type27__c != null && securedLoans.indexOf(cb.CIBIL_Extension__r.Account_Type27__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.CIBIL_Extension__r.Current_Balance27__c != null) securedCurrentBalance = securedCurrentBalance + cb.CIBIL_Extension__r.Current_Balance27__c;
            if (cb.CIBIL_Extension__r.Sanction_Amount27__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount27__c;
        }
        if (cb.CIBIL_Extension__r.Account_Type28__c != null && securedLoans.indexOf(cb.CIBIL_Extension__r.Account_Type28__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.CIBIL_Extension__r.Current_Balance28__c != null) securedCurrentBalance = securedCurrentBalance + cb.CIBIL_Extension__r.Current_Balance28__c;
            if (cb.CIBIL_Extension__r.Sanction_Amount28__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount28__c;
        }
        if (cb.CIBIL_Extension__r.Account_Type29__c != null && securedLoans.indexOf(cb.CIBIL_Extension__r.Account_Type29__c) != -1) {
            unsecuredLoanCnt++;
            if (cb.CIBIL_Extension__r.Current_Balance29__c != null) securedCurrentBalance = securedCurrentBalance + cb.CIBIL_Extension__r.Current_Balance29__c;
            if (cb.CIBIL_Extension__r.Sanction_Amount29__c != null) totalSecuredSanctionAmount = totalSecuredSanctionAmount + cb.CIBIL_Extension__r.Sanction_Amount29__c;
        }
        system.debug('unsecuredLoanCnt==' + unsecuredLoanCnt);
        system.debug('*totalSecuredSanctionAmount end  *'+totalSecuredSanctionAmount );
        return unsecuredLoanCnt;
    }
    //Added By Gulshan for count of No. of Live or Closed (PL or BL or HL or LAP or AL or CC or OTHERS) -- Bug 20245   

 public integer getSpecificLoanTradeLines(CIBIL__C cibilObj) {
        integer specificLoantradelineCount = 0;
        transient string AutoLoantype = Label.MAX_AL;
        transient string BLLoanType = Label.MAX_BL;
        transient string HLLoanType = Label.MAX_HL;
        transient string LAPLoanType = Label.MAX_LAP;
        transient string PLLoanType = Label.MAX_PL;
        transient string CreditCardLoanType = Label.MAX_CreditCard_Amount;
        Set<String> setLoanTypeToCheck = new Set<String>();
         
        if(AutoLoantype != null && AutoLoantype != '' )
            setLoanTypeToCheck.addAll(AutoLoantype.split(';'));
        if(BLLoanType != null && BLLoanType != '' )
            setLoanTypeToCheck.addAll(BLLoanType.split(';'));
        if(HLLoanType != null && HLLoanType != '' )
            setLoanTypeToCheck.addAll(HLLoanType.split(';'));
        if(LAPLoanType != null && LAPLoanType != '' )
            setLoanTypeToCheck.addAll(LAPLoanType.split(';'));
        if(PLLoanType != null && PLLoanType != '' )
            setLoanTypeToCheck.addAll(PLLoanType.split(';'));
        if(CreditCardLoanType != null && CreditCardLoanType != '' )
            setLoanTypeToCheck.addAll(CreditCardLoanType.split(';'));             

        if (cibilObj.Account_Type__c != null && cibilObj.Account_Type__c.toUpperCase() != 'NO DATA' && setLoanTypeToCheck.contains(cibilObj.Account_Type__c)) 
              specificLoantradelineCount = specificLoantradelineCount + 1;
        
        for(integer j=1;j<20;j++){
            String accountType = 'Account_Type'+j+'__c';
            if(cibilObj.get(accountType) != null && String.valueof(cibilObj.get(accountType)).toUpperCase() != 'NO DATA' && setLoanTypeToCheck.contains(String.valueof(cibilObj.get(accountType)))) 
              specificLoantradelineCount = specificLoantradelineCount + 1;
        }
        
        for(integer j=20;j<30;j++){
            String accountType = 'Account_Type'+j+'__c';
            if(cibilObj.CIBIL_Extension__r.get(accountType) != null && String.valueof(cibilObj.CIBIL_Extension__r.get(accountType)).toUpperCase() != 'NO DATA' && setLoanTypeToCheck.contains(String.valueof(cibilObj.CIBIL_Extension__r.get(accountType)))) 
                specificLoantradelineCount = specificLoantradelineCount + 1;
        }
        
        return specificLoantradelineCount;
    }
//Ended By Gulshan for count of No. of Live or Closed (PL or BL or HL or LAP or AL or CC or OTHERS)-- Bug 20245
    
       /*Bug: 17470 S*/
     public boolean getPROProductLineLFlag(String product){
         Integer a =10;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
            a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
            a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
         a=20;
      
         
        boolean isPROProductLineProduct1 = false;
        transient set < string > setPROProdName = new set < string > ();
        if(!commonUtility.isEmpty(Label.PRO_ProductLine_Products))
            setPROProdName.addAll(Label.PRO_ProductLine_Products.split(';'));
            if (setPROProdName.size() > 0 && product != null && product != '' ) {
                isPROProductLineProduct1 = setPROProdName.contains(product.toUpperCase());
            }
            system.debug('product is ##'+product+' isPROProductLineProduct1'+ isPROProductLineProduct1);
        return isPROProductLineProduct1;
   }
    
        
       
    /*Bug: 17470 E*/
} //end of trigger