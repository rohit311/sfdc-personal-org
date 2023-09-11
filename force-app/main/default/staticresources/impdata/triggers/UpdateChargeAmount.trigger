/**
*Author :Leena 6/21/2016
*Enhancement : Charges API Integration
*Purpose :
*a. FFR Charge – If my finnone charge code matches the one defined in custom setting "Charges API FFR/StampDuty Codes" FFR Finnone charge code . Then we need to use the same logic which exists in DM for displaying the FFR Charge and this Amount should get updated in Charge Amt field in Fees and charges for this charge code.
*b.Stamp Duty :- If my Finnone charge code is from  the one defined in custom settuing "Charges API FFR/StampDuty Codes"  Stamp duty charge code. Then we need to update the charge amount with the one which exists in Contact object( i.e the filed which we have defined as formula field in automation of stamp duty).
*/
//added after insert,after update and after delete for bug 24313
trigger UpdateChargeAmount on Fees_and_Charge__c(before insert,after insert,after delete,after update) {
    static Set<id> LoanIdsSet = new Set<id>(); // 24313
    static List<Opportunity> oppLstSt;// 24313
    system.debug('inside trigger -- UpdateChargeAmount -- Start \n');
    //Rohit Line for RSL 15425 - added set  
    transient Set<Id> existingfeesPO = new Set<Id>();
    transient List < Fees_and_Charge__c > FeesToBeUpdated = new List < Fees_and_Charge__c > ();
    //Mahima fees and charges enhancement start
    transient  List<Tranche_Details__c> allTranchesList=new List<Tranche_Details__c>();
    //Mahima fees and charges enhancement start
    transient List < Applicant__c > allApplicantOfLoan = new List < Applicant__c > ();
    transient List < SOL_Policy__c > addOnSols = new List < SOL_Policy__c > ();//Bug 24667
    transient Map < String,Integer > solCntMap = new Map < String,Integer > ();//Bug 24667
    transient List < Fees_and_Charge__c > allFeesAndcharges = new List < Fees_and_Charge__c > ();
    transient List < Opportunity > AllFees = new List < Opportunity > ();
    transient List < Product_Offerings__c > AllPOFees = new List < Product_Offerings__c > ();
    // 17556 start -hrushikesh
    boolean SALMobilityChangeAmountFFR = false;
    boolean SALMobilityChangeAmountEliteCard = false;
    boolean SALMobilityChangeAmountCreditCard = false;
    //17556 stop -hrushikesh
    //22017 start
    Double Elitecardcharges=0;
    Double EMIcardcharges=0;
    StaticResource salariedStaticRes,PremiumChargeRes, stateFeeConditions,empStaticResource; //5492
    //22017 end
    //22019 start
    List < String > LineProducts = new List < String > ();
    StampDutyStatesWrapper StampDutyStates = new StampDutyStatesWrapper();
    Map < string, list < Ranges >> mp = new Map < string, list < Ranges >> ();
    String StampDutyState = '';
    
    public class States {
        public String Name;
        public List < Ranges > Ranges;
    }
    
    public class Ranges {
        public String MinValue;
        public String MaxValue;
        public String Percent;
    }
    
    public class StampDutyStatesWrapper {
        public List < States > States;
    }
    //22019 end
    transient set < Id > allLoanIDs = new set < Id > ();
    transient set < Id > allfeesid = new set < Id > ();
    //Mahima fees and charges enhancement start
    transient boolean Mortgageflag=false;
    
    transient  set<Id>allTrancheid=new set<Id>();
    //Mahima fees and charges enhancement end
    transient set < Id > allPOid = new set < Id > ();
    transient Applicant__c PrimaryApplicant;
    boolean ChargesAPIIntegration;
    //charges product changes start
    set < String > setProductCredit;
    String productsCharges;
    boolean ChargesAPIIntegrationProduct = false;
    Map<Id, Product_Offerings__c> mapPO = new Map<Id, Product_Offerings__c>(); //24848
    //bug id 17664 - implementation done for all the products start
    String loanAppId = '';
    //bug id 17664 - implementation done for all the products end
    
    //charges product changes end
    //22017 start
    //Addy to reduce number of queries
    
    //Moved query from below and made changes for bug 24313
    Map<String, Opportunity>oppmap = new Map<String,Opportunity>();
    if(Trigger.isInsert){
        for (Fees_and_Charge__c fees1: Trigger.New) {
            allfeesid.add(fees1.Loan_Application__c);
            //bug id 17664 - implementation done for all the products start
            loanAppId = String.valueOf(fees1.Loan_Application__c);
            //bug id 17664 - implementation done for all the products end
        }
        
        if (allfeesid != null && allfeesid.size() > 0)
            //added for Bug 24487 EMI Card
            AllFees = [select id, Loan_Amount__c, /* bug 17556 s*/Account.Flow__c/*bug 17556 e*/,Account.Product__c, (select id, Line_opted__c from SurrogateCAMS__r), Product__c /*24848 s*/, Branch_Name__c, Branch_Name__r.Branch_State_Province__c, Loan_Amount_with_Premium__c/*24848 e*/ from Opportunity where id IN: allfeesid];
        for(Opportunity opps : AllFees){
            
            oppmap.put(opps.id,opps);
            
        }
        if(Trigger.isBefore) {
            List < StaticResource > sr = new List<StaticResource>();//below content added 5492
            List<StaticResource> staticResList = [SELECT Body,Name
                                                  FROM StaticResource
                                                  WHERE (Name = 'PremiumCharge' or Name='EmployeeLoanStaticResource' or  Name = 'SalariedCustomSettings' or Name = 'state_Fee_Conditions' or Name = 'StatesStampDutyLogic' or Name = 'StampDutyChargesStateWise')  LIMIT 5]; // 22019 added values in where conditions
            for(StaticResource str:staticResList){
                if(str.Name.contains('PremiumCharge'))
                    PremiumChargeRes = str;
                if(str.Name.contains('SalariedCustomSettings')) 
                    salariedStaticRes = str;//22019 s
      if(str.Name.contains('EmployeeLoanStaticResource'))//5492
                    empStaticResource  =str; 
                if(str.Name.contains('state_Fee_Conditions')) 
                    stateFeeConditions = str;
                if(str.Name.contains('StatesStampDutyLogic') || str.Name.contains('StampDutyChargesStateWise')) 
                    sr.add(str);
            }//22019 e
            //22017 end
            //22019 start
            String rescBody = '';
            Map < String, Object > rescMap = new Map < String, Object > ();
            if (salariedStaticRes != null) {
                System.debug('nk insde');
                rescBody = salariedStaticRes.Body.toString();
                if (rescBody != '') {
                    rescMap = (Map < String, Object > ) JSON.deserializeUntyped(rescBody);
                    LineProducts = ((String) rescMap.get('SALLineChangesAllProducts')).split(';');
                }
            }
            //List < StaticResource > sr = [SELECT  id,body,Name FROM StaticResource WHERE Name = 'StatesStampDutyLogic' OR Name = 'StampDutyChargesStateWise' LIMIT 10];
            
            //22019 end
            // SAL Mobility Addition CR - Aman Porwal - S 
            boolean SALMobilityChangeAmount = false;
            // SAL Mobility Addition CR - Aman Porwal - E
            System.debug('Initial values...........');
            for (Fees_and_Charge__c feeRec: Trigger.New){
                System.debug('feeRec '+feeRec);
            }
            
            
            
            for (Fees_and_Charge__c fees1: Trigger.New) {
                allPOid.add(fees1.Product_Offerings__c);
            }//added for Bug 24487
            if (allfeesid != null && allfeesid.size() > 0)
                AllFees = [select /* Bug:25671--S*/Loan_Amount__c,/* Bug:25671--E*/id,Account.Flow__c,/*20934*/application_source__c,/*20934*/Account.Product__c, (select id, Line_opted__c from SurrogateCAMS__r), Product__c /*24848 s*/, Branch_Name__c, Branch_Name__r.Branch_State_Province__c, Loan_Amount_with_Premium__c/*24848 e*/ from Opportunity where id IN: allfeesid];
            if (allPOid != null && allPOid.size() > 0)
                AllPOFees = [select id, Processing_Fee_Amount__c,/* Line for RSL 15425 S */ (SELECT Id,Product_Offerings__c,Charge_Type__c FROM Fees_and_Charges__r)/* Line for RSL 15425 E */, Products__c, Unsecured_W_O_BT_Line_Available__c, availed_amount__c,offer_amount__c ,UTM_source__c,New_Line_assigned__c,Resi_Pick_State__c, SBS_Scheme__r.Stamp_Duty_State__c /*24848 s*/, final_amount__c, lead__r.SBS_Branch__c , lead__r.SBS_Branch__r.Branch_State_Province__c, Product__c /*24848 e*/ from Product_Offerings__c where id IN: allPOid];//added UTM_Source offer_amount,availed_amount for 22019
            //Rohit Line for RSL 15425 start
            List<Fees_and_Charge__c> poFeesList = new List<Fees_and_Charge__c>();
            for(Product_Offerings__c po : AllPOFees)
            {
                mapPO.put(po.Id, po);   //24848
                if(po.Fees_and_Charges__r != null && po.Fees_and_Charges__r.size()>0) 
                    poFeesList.addAll(po.Fees_and_Charges__r);
            }
            for(Fees_and_Charge__c  fee3 : poFeesList)
                if(fee3.Charge_Type__c == 'Line Utilization')
            {
                existingfeesPO.add(fee3.Product_Offerings__c);
            }
            //rohit Line for RSL 15425 stop
            if (!Test.isRunningTest())
                ChargesAPIIntegration = LaonApplicationCreation__c.getValues('Charges API Integration').Integrate_Charges_API__c;
            //New CR for product
            else{
                chargesAPIIntegration = true;
            }
            
            //if (!Test.isRunningTest())
            if (LaonApplicationCreation__c.getValues('Charges API Integration') != null)
                productsCharges = LaonApplicationCreation__c.getValues('Charges API Integration').Products__c;
            system.debug('productsCharges =====>' + productsCharges);
            if (productsCharges != null && productsCharges != '')
                setProductCredit = new Set < String > (productsCharges.split(','));
            
            
            
            if (ChargesAPIIntegration != null) {
                if (ChargesAPIIntegration) {
                    system.debug('inside trigger');
                    for (Fees_and_Charge__c fees: Trigger.New) {
                        if (fees.Loan_Application__c != null) {
                            allLoanIDs.add(fees.Loan_Application__c);
                            system.debug('allLoanIDs--->' + allLoanIDs);
                        }
                        
                        //Mahima fees and charges enhancement start
                        for(Fees_and_Charge__c fees1:Trigger.New){
                            allTrancheid.add(fees1.Tranche_Detail__c);
                        }
                        if (LaonApplicationCreation__c.getValues('Mortgage Products') != null) 
                        {
                            String MortgageProducts = LaonApplicationCreation__c.getValues('Mortgage Products').Current_product__c;
                            if (MortgageProducts != null) {
                                try{
                                    system.debug('***MortgageProducts***' + MortgageProducts);
                                    String[] arr = MortgageProducts.split(';');
                                    for (String str: arr) {
                                        if (AllFees!=null && AllFees.size()>0 ) 
                                        {     
                                            if (str.equalsIgnoreCase(AllFees[0].Product__c)) {
                                                Mortgageflag = true;
                                            }
                                        }
                                        
                                    }
                                } catch(Exception e)
                                {
                                    system.debug('Exception is ====>'+e+'  at line number'+e.getLineNumber());
                                }
                            }
                        }
                        //Mahima fees and charges enhancement end
                        
                        //system.debug('allLoanIDs are'+allLoanIDs);
                        //  system.debug('setProductCredit are'+setProductCredit);
                        // system.debug('fees.size'+setProductCredit.size());
                        //charges product changes start
                        //Mahima fees and charges enhancement start added Mortgageflag
                        if ((setProductCredit != null && setProductCredit.size() > 0 && ((AllFees != null && AllFees.size() > 0) || (AllPOFees != null && AllPOFees.size() > 0)))||  Mortgageflag) {
                            system.debug('condition is true==');
                            // system.debug('fees.Loan_Application__r.Product__c.ToUpperCase() '+fees.Loan_Application__r.Product__c.ToUpperCase());
                            
                            //Mahima fees and charges enhancement start added Mortgageflag
                            if ((AllFees != null && AllFees.size() > 0 && setProductCredit.contains(AllFees[0].Product__c)) || (AllPOFees != null && AllPOFees.size() > 0 && setProductCredit.contains(AllPOFees[0].Products__c)) || Mortgageflag) {
                                ChargesAPIIntegrationProduct = true;
                                
                            } else {
                                ChargesAPIIntegrationProduct = false;
                            }
                            
                        } //charges product changes end
                    }
                    //Added for bug 24667 s
                    system.debug('allLoanIDs:::' + allLoanIDs);
                    system.debug('allPOid:::' + allPOid);
                    if ((allLoanIDs != null && allLoanIDs.size() > 0) || (allPOid != null && allPOid.size() > 0)){
                        addOnSols = [Select id,Add_on_Holder_DOB__c,Add_on_Holder_Email__c,Add_on_Holder_First_Name__c,Add_on_Holder_Last_Name__c,Add_on_Holder_Middle_Name__c,Add_on_holder_Mobile__c,Add_on_Holder_Relation__c,Applicant_Name__c,Charge_Type__c from SOL_Policy__c where Loan_Application__c =:allLoanIDs and name like '%add on%'];
                        system.debug('***addOnSols***' + addOnSols); 
                        
                    }
                    for (SOL_Policy__c addSols: addOnSols) {                
                        if(addSols.Charge_Type__c != null && !solCntMap.containsKey(addSols.Charge_Type__c)){
                            solCntMap.put(addSols.Charge_Type__c,1);
                        }
                        else{
                            Integer cnt = solCntMap.get(addSols.Charge_Type__c);
                            solCntMap.put(addSols.Charge_Type__c,cnt+1);
                        }
                    }
                    system.debug('***solCntMap***' +solCntMap);  
                    //Added for bug 24667 e
                    system.debug('ChargesAPIIntegrationProduct ' + ChargesAPIIntegrationProduct);
                    if (ChargesAPIIntegrationProduct == true) {
                        if ((allLoanIDs != null && allLoanIDs.size() > 0) || (allPOid != null && allPOid.size() > 0)) {
                            if (allLoanIDs != null && allLoanIDs.size() > 0)
                                allApplicantOfLoan = [Select id, Applicant_Type__c,EMI_Card__c,Elite_card_product__c,Financial_Health_Check_Guide__c, Elite_Card__c,Credit_Card_Charges__c,Loan_Application__c, Contact_Name__r.Stamp_Duty__c, Loan_Application__r.Loan_Amount_with_Premium__c, Loan_Application__r.Processing_Fees__c , /* 21414 Stmap Duty Fields */ Contact_Name__r.State__c,  Contact_Name__r.Residence_City__c from Applicant__c where Loan_Application__c IN: allLoanIDs];
                            //Mahima fees and charges enhancement start
                            if(allTrancheid!=null && allTrancheid.size()>0)
                                allTranchesList=[select id,Tranche_Recommended_Amount__c from Tranche_Details__c where id IN : allTrancheid];
                            //Mahima fees and charges enhancement end
                            
                            /* SAL Mobility Addition CR - Aman Porwal - S  
                            for (Applicant__c applicant: allApplicantOfLoan) {
                            if(applicant!=null && applicant.Financial_Health_Check_Guide__c == false && applicant.Applicant_Type__c == 'Primary'){
                            SALMobilityChangeAmount = true;
                            system.debug('inside for loop>>>'+SALMobilityChangeAmount);
                            break;
                            }
                            }
                            
                            for (Fees_and_Charge__c fees: Trigger.New) {
                            system.debug('inside for1 loop>>>');
                            if (LaonApplicationCreation__c.getValues('SAL Mobility Charges API FFR Codes') != null) 
                            {
                            system.debug('inside for1 if>>>');
                            String salMobilityFFRCode = LaonApplicationCreation__c.getValues('SAL Mobility Charges API FFR Codes').FFR_Finnone_charge_code__c;
                            try{
                            system.debug('inside for1 try>>>salMobilityFFRCode:'+salMobilityFFRCode);
                            List<String> tempstr = salMobilityFFRCode.split(',');
                            String temp = '';
                            for(string str : tempstr)
                            {
                            if(Str.trim().length() > 0)
                            temp = temp+str;
                            }
                            salMobilityFFRCode=temp;
                            system.debug('inside for1 try>>>salMobilityFFRCodeAfter:'+salMobilityFFRCode);
                            system.debug('inside for1 try>>>AllFees:'+AllFees);
                            system.debug('inside for1 try>>>AllFees[0].Account.Flow__c:'+AllFees[0].Account.Flow__c);
                            system.debug('inside for1 try>>>SALMobilityChangeAmount:'+SALMobilityChangeAmount);
                            if (salMobilityFFRCode != null && AllFees!=null && AllFees.size()>0 && AllFees[0].Account.Flow__c == 'Mobility' && SALMobilityChangeAmount) {
                            system.debug('inside for1 if1>>>');
                            if (fees.Finnone_ChargeId__c != null) {
                            system.debug('inside for1 if2>>>');
                            system.debug('fees.Finnone_ChargeId__c=====>' + fees.Finnone_ChargeId__c);
                            String finnCode = ';'+fees.Finnone_ChargeId__c+';';
                            if (salMobilityFFRCode.contains(finnCode)) {
                            system.debug('inside for1 if3>>>');
                            fees.Change_Amount__c = 0;
                            system.debug('inside for1 if3After>>>'+fees.Change_Amount__c);
                            break;
                            }
                            }
                            }
                            }
                            catch(Exception e)
                            {
                            system.debug('Exception is ====>'+e+'  at line number'+e.getLineNumber());
                            }
                            }
                            }
                            // SAL Mobility Addition CR - Aman Porwal - E*/
                            
                            for (Fees_and_Charge__c fees: Trigger.New) {
                                for (Applicant__c applicant: allApplicantOfLoan) {
                                    if (applicant.Loan_Application__c == fees.Loan_Application__c && applicant.Applicant_Type__c == 'Primary') {
                                        
                                        PrimaryApplicant = applicant;
                                        system.debug('Primary applicant is===>' + PrimaryApplicant);
                                        break;
                                    }
                                }
                                // 21414 AP
                                List<Rack_Rate__c> RackList = new List<Rack_Rate__c>();
                                String oppPOState;
                                String oppPOProduct;
                                if(!CommonUtility.isEmpty(AllFees) && PrimaryApplicant != null && PrimaryApplicant.Contact_Name__r.State__c != null && AllFees[0].Product__c != null){
                                    oppPOState = AllFees[0].Branch_name__r.Branch_State_Province__c;//--25274 //oppPOState = PrimaryApplicant.Contact_Name__r.State__c;
                                    oppPOProduct = AllFees[0].Product__c;
                                }
                                else if(!CommonUtility.isEmpty(AllPOFees) && AllPOFees[0].Resi_Pick_State__c != null && String.isNotEmpty(AllPOFees[0].Products__c)){
                                    oppPOState = AllPOFees[0].lead__r.SBS_Branch__r.Branch_State_Province__c    ;//25274 -- //oppPOState = AllPOFees[0].Resi_Pick_State__c;
                                    oppPOProduct = AllPOFees[0].Products__c;
                                }
                                if(String.isNotEmpty(oppPOState) && String.isNotEmpty(oppPOProduct) && Label.Stamp_Duty_Revamp_Switch == 'true')
                                {
                                    System.debug('reached here');
                                    
                                    RackList = [ Select id , Product_SD__c , Stamp_Duty_Procure_Charges__c , Stamp_Duty_Charges__c , State__c, Active_Flag__c , Stamp_duty_procure_percentage__c, Applicable_On_SD__c , Stamp_Duty_Charge_ID__c , Stamp_duty_procure_charge_ID__c from Rack_Rate__c where
                                                State__c = :oppPOState and Active_Flag__c = true and Products__c includes(:oppPOProduct) order by CreatedDate desc limit 1 ];
                                }
                                System.debug('RackList  : '+RackList );
                                transient decimal ChargeAmount;
                                
                                transient String[] arrayOfFFRFinnoneCodes;
                                transient String[] arrayOfStampDutyCodes;
                                //Addy
                                transient String[] arrayOfProcureFeeCodes;
                                //Addy
                                transient String[] arrayOfLineChargesCodes;
                                transient string StampDutyFinnonechargescodes;
                                String[] arrayOfProcessingfeeCodes;
                                
                                transient string FFRFinnonechargescodes;
                                transient string ProceFeesFinnonechargescodes;
                                transient string LineChargesCodes;
                                transient Integer lineCharges = 0;
                                if (!Test.isRunningTest()) {
                                    if (allLoanIDs != null && allLoanIDs.size() > 0 && AllFees != null && AllFees.size() > 0) {
                                        ChargeAmount = ProductSMS__c.getValues(AllFees[0].Product__c).Charges__c;
                                    }
                                }
                                if (allPOid != null && allPOid.size() > 0 && AllPOFees != null && AllPOFees.size() > 0) {
                                    ChargeAmount = ProductSMS__c.getValues(AllPOFees[0].Products__c).Charges__c;
                                    if (AllPOFees[0].Unsecured_W_O_BT_Line_Available__c != null) {
                                        
                                        if (ProductSMS__c.getValues(AllPOFees[0].Products__c) != null && ProductSMS__c.getValues(AllPOFees[0].Products__c).MaxLineAssignedAmount__c != null) {
                                            Integer MAXlineCharges = Integer.valueof(ProductSMS__c.getValues(AllPOFees[0].Products__c).MaxLineAssignedAmount__c);
                                            
                                            if (AllPOFees[0].Unsecured_W_O_BT_Line_Available__c <= MAXlineCharges) lineCharges = Integer.valueof(ProductSMS__c.getValues(AllPOFees[0].Products__c).LineFeesLessThanMaxLineAmount__c);
                                            else if (AllPOFees[0].Unsecured_W_O_BT_Line_Available__c > MAXlineCharges) lineCharges = Integer.valueof(ProductSMS__c.getValues(AllPOFees[0].Products__c).LineFeesMoreThanMaxLineAmount__c);
                                            system.debug('LineCharegs are===>' + lineCharges);
                                            system.debug('AllPOFees====>' + AllPOFees);
                                            system.debug('AllPOFees ProductSMS__c.getValues(AllPOFees[0].Products__c====>' + ProductSMS__c.getValues(AllPOFees[0].Products__c));
                                            
                                        }
                                    }
                                }
                                if (!Test.isRunningTest())
                                    FFRFinnonechargescodes = LaonApplicationCreation__c.getValues('Charges API FFR/StampDuty Codes').FFR_Finnone_charge_code__c;
                                
                                if (!Test.isRunningTest())
                                    StampDutyFinnonechargescodes = LaonApplicationCreation__c.getValues('Charges API FFR/StampDuty Codes').Stamp_duty_charge_code__c;
                                //New changes for proc fee-Tejashree-Saturday
                                System.debug('StampDutyFinnonechargescodes'+StampDutyFinnonechargescodes);
                                if (!Test.isRunningTest())
                                    ProceFeesFinnonechargescodes = LaonApplicationCreation__c.getValues('Charges API FFR/StampDuty Codes').Processing_fee_charge_code__c;
                                if (!Test.isRunningTest())
                                    LineChargesCodes = LaonApplicationCreation__c.getValues('Charges API FFR/StampDuty Codes').Line_charges_Codes__c;
                                
                                if (LineChargesCodes != null && LineChargesCodes != '')
                                    arrayOfLineChargesCodes = LineChargesCodes.split(',');
                                system.debug('arrayOfLineChargesCodes=====>' + arrayOfLineChargesCodes);
                                if (FFRFinnonechargescodes != null && FFRFinnonechargescodes != '')
                                    arrayOfFFRFinnoneCodes = FFRFinnonechargescodes.split(',');
                                //Addy 23463
                                if (!CommonUtility.isEmpty(RackList) && String.isNotEmpty(RackList[0].Stamp_Duty_Charge_ID__c))
                                    arrayOfStampDutyCodes = RackList[0].Stamp_Duty_Charge_ID__c.split(',');
                                else if(StampDutyFinnonechargescodes != null && StampDutyFinnonechargescodes != '')
                                    arrayOfStampDutyCodes = StampDutyFinnonechargescodes.split(',');
                                if (!CommonUtility.isEmpty(RackList) && String.isNotEmpty(RackList[0].Stamp_duty_procure_charge_ID__c))
                                    arrayOfProcureFeeCodes = RackList[0].Stamp_duty_procure_charge_ID__c.split(',');
                                else if(ProceFeesFinnonechargescodes != null && ProceFeesFinnonechargescodes != '')
                                    arrayOfProcureFeeCodes = ProceFeesFinnonechargescodes.split(',');
                                //New changes for proc fee-Tejashree-Saturday
                                if (ProceFeesFinnonechargescodes != null && ProceFeesFinnonechargescodes != '')
                                    arrayOfProcessingfeeCodes = ProceFeesFinnonechargescodes.split(',');
                                system.debug('arrayOfStampDutyCodes====>' + arrayOfStampDutyCodes);
                                system.debug('arrayOfProcureFeeCodes====>' + arrayOfProcureFeeCodes);
                                system.debug('arrayOfFFRFinnoneCodes====>' + arrayOfFFRFinnoneCodes);
                                if (allPOid != null && allPOid.size() > 0 && AllPOFees != null && AllPOFees.size() > 0) {
                                    if (arrayOfLineChargesCodes != null && arrayOfLineChargesCodes.size() > 0) {
                                        for (string FFRLinecode: arrayOfLineChargesCodes) {
                                            //Rohit Line for RSL 15425 - added condition for duplication                                
                                            //if (fees.Finnone_ChargeCode__c != null) {
                                            if (fees.Finnone_ChargeCode__c != null && !existingfeesPO.contains(fees.Product_Offerings__c)) {
                                                system.debug('fees.Finnone_ChargeCode__c=====>' + fees.Finnone_ChargeCode__c);
                                                system.debug('Integer.valueOf(fees.Finnone_ChargeCode__c)' + Integer.valueOf(fees.Finnone_ChargeCode__c));
                                                system.debug('Integer.valueOf(FFRLinecode)' + Integer.valueOf(FFRLinecode));
                                                if (Integer.valueOf(fees.Finnone_ChargeCode__c) == Integer.valueOf(FFRLinecode)) {
                                                    system.debug('LineCharegs are match found===>' + lineCharges);
                                                    fees.Change_Amount__c = lineCharges;
                                                    fees.Charge_Type__c = 'Line Utilization';
                                                    //FeesToBeUpdated.add(fees);  
                                                    break;
                                                }
                                            }
                                            //Rohit Line for RSL 15425 - added else block start
                                            else if(existingfeesPO.contains(fees.Product_Offerings__c) && fees.Charge_Type__c == 'Line Utilization')
                                            {
                                                
                                                fees.Charge_Type__c.addError('Duplicate Record');
                                            }
                                            //Rohit Line for RSL 15425 - added else block stop
                                            
                                        }
                                    }
                                }
                                
                                
                                /*
                                * @Gaurav: Added Product 'SOL' in below condition so that Line Utilization record 
                                * should be created when OPS click on Fetch charges from Disbursement Screen.
                                * SOL Line Assignment - 22 Feb 2017
                                * Bug ID - 11552
                                */
                                if (allLoanIDs != null && allLoanIDs.size() > 0 && AllFees != null && AllFees.size() > 0 && (AllFees[0].Product__c == 'SAL' || AllFees[0].Product__c == 'SPL' || AllFees[0].Product__c == 'SOL') && AllFees[0].SurrogateCAMS__r.size() > 0 && AllFees[0].SurrogateCAMS__r[0].Line_opted__c == 'YES') {
                                    if (arrayOfLineChargesCodes != null && arrayOfLineChargesCodes.size() > 0) {
                                        for (string LineCode: arrayOfLineChargesCodes) {
                                            system.debug('LineCode=====>' + LineCode);
                                            system.debug('fees.Finnone_ChargeCode__c=====>' + fees.Finnone_ChargeCode__c);
                                            if (Integer.valueOf(fees.Finnone_ChargeCode__c) == Integer.valueOf(LineCode)) {
                                                system.debug('condition matches=====>');
                                                fees.Charge_Type__c = 'Line Utilization';
                                            }
                                        }
                                    }
                                    
                                }
                                if (arrayOfFFRFinnoneCodes != null && arrayOfFFRFinnoneCodes.size() > 0) {
                                    for (string FFRFinnonecode: arrayOfFFRFinnoneCodes) {
                                        if (fees.Finnone_ChargeCode__c != null) {
                                            if (Integer.valueOf(fees.Finnone_ChargeCode__c) == Integer.valueOf(FFRFinnonecode)) {
                                                system.debug('match ffr finnione code====>' + ChargeAmount);
                                                fees.Change_Amount__c = ChargeAmount;
                                                fees.Charge_Type__c = 'Financial Health Check Guide ( Credit Vidya )';
                                                FeesToBeUpdated.add(fees);
                                                break;
                                            }
                                        }
                                    }
                                }
                                System.debug((RackList.size() > 0));
                                // 21414 Stamp Duty AP
                                System.debug('fees chare code ' +fees.Finnone_ChargeCode__c);
                                //Addy 23463
                                Contact appCon = new Contact();
                                if(PrimaryApplicant != null)
                                    appCon.Id = PrimaryApplicant.Contact_Name__c;
                                
                                if (arrayOfStampDutyCodes != null && arrayOfStampDutyCodes.size() > 0 && Label.Stamp_Duty_Revamp_Switch == 'false') {
                                    for (string stampDutycode: arrayOfStampDutyCodes) {
                                        if (fees.Finnone_ChargeCode__c != null) {
                                            system.debug('fees.Finnone_ChargeCode__c===>' + fees.Finnone_ChargeCode__c);
                                            system.debug('stampDutycode' + stampDutycode);
                                            System.debug('fees.Loan_Application__c' + fees.Loan_Application__c);
                                            
                                            if (Integer.valueOf(fees.Finnone_ChargeCode__c) == Integer.valueOf(stampDutycode)) 
                                            {
                                                /*** 24848 start ****/
                                                String val = NULL; 
                                                if( fees.Loan_Application__c  != NULL && oppmap.containsKey(fees.Loan_Application__c) )
                                                {
                                                    val = Fees_Utility.fetchUnsecuredStampDuty( oppmap.get(fees.Loan_Application__c) );
                                                }
                                                else if ( fees.Product_Offerings__c != NULL && mapPO.containsKey(fees.Product_Offerings__c))
                                                {
                                                    val = Fees_Utility.fetchUnsecuredStampDuty( mapPO.get(fees.Product_Offerings__c) );
                                                }
                                                
                                                if( val == 'SUCCESS')
                                                {
                                                    fees.Change_Amount__c = 0;
                                                    appCon.Stamp_Duty__c = 0;
                                                    FeesToBeUpdated.add(fees);
                                                }
                                                else if( val == 'FAILURE'){
                                                    fees.Charge_Type__c.addError('Please enter proper values in Configuration. ');
                                                }
                                                else 
                                                {                                                    
                                                    /*** 24848 end   ****/ //Processing with existing flow. 
                                                    
                                                    if (PrimaryApplicant != null) {
                                                        system.debug('update stamp duty finnione code====>' + PrimaryApplicant.Contact_Name__r.Stamp_Duty__c);
                                                        System.debug('\n FeesToBeUpdated '+fees);
                                                        fees.Change_Amount__c = PrimaryApplicant.Contact_Name__r.Stamp_Duty__c;                                                    
                                                        FeesToBeUpdated.add(fees);
                                                    }
                                                }///closing else 24848 
                                                break;
                                            }
                                        }
                                    }
                                }
                                
                                //System.debug('fees chare code ' +fees.Finnone_ChargeCode__c);
                                else if ( Label.Stamp_Duty_Revamp_Switch == 'true' && fees.Finnone_ChargeCode__c != null && RackList.size() > 0 && RackList[0].Active_Flag__c == true )
                                {
                                    Map<String,Object> stateFeeMap = new Map<String,Object>();
                                    String srState = '';
                                    Decimal statePerc = 100, procureCharge = 0;
                                    Decimal loanAmount;
                                    if(!CommonUtility.isEmpty(AllFees) && AllFees[0].Loan_Amount_with_Premium__c != null)
                                        loanAmount = AllFees[0].Loan_Amount_with_Premium__c;    //24848 
                                    else if(!CommonUtility.isEmpty(AllPOFees) && AllPOFees[0].Final_Amount__c != null)
                                        loanAmount = AllPOFees[0].Final_Amount__c;  //24848
                                    System.debug('loanAmt'+loanAmount);
                                    System.debug('sr Name Addy'+stateFeeConditions!=null);
                                    if (stateFeeConditions != null)
                                        stateFeeMap = (Map<String,Object>) JSON.deserializeUntyped(stateFeeConditions.body.toString());
                                    if(stateFeeMap.get('State') != null)
                                        srState = stateFeeMap.get('State').toString();
                                    for(String laVal: stateFeeMap.keyset())
                                        if(laVal != null && laVal != 'State'){
                                            if(laVal.contains('>') && loanAmount > Decimal.valueof(laVal.subString(1)))
                                                statePerc = Decimal.valueOf(stateFeeMap.get(laVal).toString());
                                            else if(laVal.contains('<') && loanAmount <= Decimal.valueof(laVal.subString(1)))
                                                statePerc = Decimal.valueOf(stateFeeMap.get(laVal).toString());
                                        }
                                    //String primaryappState = PrimaryApplicant.Contact_Name__r.State__c ;
                                    System.debug('\n'+fees.Charge_Desc__c+'\n inside first if' +fees.Finnone_ChargeCode__c); 
                                    System.debug('arrayOfStampDutyCodes '+arrayOfStampDutyCodes+'\n --> '+arrayOfStampDutyCodes.contains(String.valueOf( Integer.valueOf(fees.Finnone_ChargeCode__c) ))+' : '+String.valueOf(fees.Finnone_ChargeCode__c) );                 
                                    if(arrayOfStampDutyCodes!=null && arrayOfStampDutyCodes.contains(String.valueOf( Integer.valueOf(fees.Finnone_ChargeCode__c) ) ))
                                    {
                                        System.debug('PrimaryApplicant  : '+PrimaryApplicant );
                                        fees.Charge_Type__c = 'Stamp Duty';
                                        system.debug('update stamp duty finnione code====>');
                                        System.debug('RackList[0].Stamp_Duty_Charges__c  : '+RackList[0].Stamp_Duty_Charges__c);
                                        
                                        /*** 24848 start ****/
                                        String val = NULL; 
                                        
                                        if(fees.Loan_Application__c != NULL && oppmap.containsKey(fees.Loan_Application__c) )
                                        {
                                            val =  Fees_Utility.fetchUnsecuredStampDuty( oppmap.get(fees.Loan_Application__c) );
                                        }
                                        else if ( fees.Product_Offerings__c != NULL && mapPO.containsKey(fees.Product_Offerings__c))
                                        {
                                            val = Fees_Utility.fetchUnsecuredStampDuty( mapPO.get(fees.Product_Offerings__c) );
                                        }
                                        if( val == 'SUCCESS')
                                        {
                                            fees.Change_Amount__c = 0;
                                            FeesToBeUpdated.add(fees);
                                            appCon.Stamp_Duty__c = 0;
                                        }
                                        else if( val == 'FAILURE')
                                        {
                                            fees.Charge_Type__c.addError('enter proper values in Configuration.');
                                            FeesToBeUpdated.add(fees);
                                        }
                                        else
                                        {   
                                            /*** 24848 end   ****/ //Processing with existing flow resumes -- removed code to store and reQuery rackrates from the val which was returned. 
                                            System.debug('Rack list : ' + racklist[0]);
                                            if(RackList[0].Stamp_Duty_Charges__c != null)
                                            {
                                                System.debug('considering rack list charges');
                                                if(String.isNotEmpty(srState) && srState == oppPOState && statePerc!=null && loanAmount!=null){
                                                    fees.Change_Amount__c =  (statePerc * loanAmount)/100;
                                                    //Addy 23463
                                                    appCon.Stamp_Duty__c = (statePerc * loanAmount)/100;
                                                    System.debug('considering rack list charges');
                                                    System.debug(fees.Change_Amount__c);
                                                    FeesToBeUpdated.add(fees);
                                                }
                                                else
                                                {
                                                    fees.Change_Amount__c = RackList[0].Stamp_Duty_Charges__c;
                                                    //Addy 23463
                                                    appCon.Stamp_Duty__c = RackList[0].Stamp_Duty_Charges__c;
                                                    System.debug('fees.Change_Amount__c : '+fees.Change_Amount__c);
                                                    System.debug(' Other than MH \n FeesToBeUpdated '+fees);
                                                    FeesToBeUpdated.add(fees);
                                                }
                                            }
                                        }//else close
                                    }
                                    
                                    System.debug('>>> Checking with procurement codes : '  +  arrayOfProcureFeeCodes);
                                    System.debug('>>> Checking for procurement codes : '  +  fees.Finnone_ChargeCode__c);
                                    System.debug('Fees record : ' + fees);
                                    
                                    if (arrayOfProcureFeeCodes != null && arrayOfProcureFeeCodes.contains(String.valueOf( Integer.valueOf(fees.Finnone_ChargeCode__c)))){
                                        System.debug('inside second if' +fees.Finnone_ChargeCode__c);
                                        if (PrimaryApplicant != null) 
                                        {
                                            system.debug('update stamp duty finnione code====>');
                                            if(RackList[0].Stamp_Duty_Charges__c != null)
                                            {
                                                fees.Charge_Type__c = 'Stamp Duty Procure Charge';
                                                /** START : 25274 -- making ZERO if values are under particular threshold. **/
                                                String val = NULL;
                                                if(fees.Loan_Application__c != NULL && oppmap.containsKey(fees.Loan_Application__c) )
                                                {
                                                    val =  Fees_Utility.fetchUnsecuredStampDuty( oppmap.get(fees.Loan_Application__c) );
                                                }
                                                else if ( fees.Product_Offerings__c != NULL && mapPO.containsKey(fees.Product_Offerings__c))
                                                {
                                                    val = Fees_Utility.fetchUnsecuredStampDuty( mapPO.get(fees.Product_Offerings__c) );
                                                }
                                                
                                                if( val == 'SUCCESS'){
                                                    fees.Change_Amount__c =0;
                                                    appCon.Stamp_Duty__c = 0;
                                                    FeesToBeUpdated.add(fees);
                                                }
                                                else if(val == 'FAILURE'){
                                                    fees.Charge_Type__c.addError('Please enter proper values in Configuration.');
                                                    FeesToBeUpdated.add(fees);
                                                }
                                                else{
                                                    /** END : 25274 -- making ZERO if values are under particular threshold. **/
                                                    
                                                    if(String.isNotEmpty(srState) && srState == oppPOState && statePerc!=null && loanAmount!=null){
                                                        Decimal stampAmt = (statePerc * loanAmount)/100;
                                                        fees.Change_Amount__c = (RackList[0].Stamp_duty_procure_percentage__c * stampAmt)/100;
                                                        FeesToBeUpdated.add(fees);
                                                    }
                                                    else{
                                                        Decimal procurementcharge = (RackList[0].Stamp_duty_procure_percentage__c * RackList[0].Stamp_Duty_Charges__c)/100;
                                                        System.debug('procurement charge' +procurementcharge);
                                                        fees.Change_Amount__c = procurementcharge;
                                                        System.debug('\n FeesToBeUpdated '+fees);
                                                        FeesToBeUpdated.add(fees);
                                                    }
                                                } //25274 -- else bracket ended. 
                                            }
                                        }
                                        else//25783 
                                        {//in case of PO there will be no Primary applicant. 
                                            //// 25783 start /////////////
                                            if(RackList[0].Stamp_Duty_Charges__c != null)
                                            {
                                                fees.Charge_Type__c = 'Stamp Duty Procure Charge';
                                                /** START : 25274 -- making ZERO if values are under particular threshold. **/
                                                String val = NULL;
                                                if ( fees.Product_Offerings__c != NULL && mapPO.containsKey(fees.Product_Offerings__c))
                                                {
                                                    val = Fees_Utility.fetchUnsecuredStampDuty( mapPO.get(fees.Product_Offerings__c) );
                                                }
                                                
                                                if( val == 'SUCCESS'){
                                                    fees.Change_Amount__c =0;
                                                    appCon.Stamp_Duty__c = 0;
                                                    FeesToBeUpdated.add(fees);
                                                }
                                                else if(val == 'FAILURE'){
                                                    fees.Charge_Type__c.addError('Please enter proper values in Configuration.');
                                                    FeesToBeUpdated.add(fees);
                                                }
                                                else{
                                                    /** END : 25274 -- making ZERO if values are under particular threshold. **/
                                                    
                                                    if(String.isNotEmpty(srState) && srState == oppPOState && statePerc!=null && loanAmount!=null){
                                                        Decimal stampAmt = (statePerc * loanAmount)/100;
                                                        fees.Change_Amount__c = (RackList[0].Stamp_duty_procure_percentage__c * stampAmt)/100;
                                                        FeesToBeUpdated.add(fees);
                                                    }
                                                    else{
                                                        Decimal procurementcharge = (RackList[0].Stamp_duty_procure_percentage__c * RackList[0].Stamp_Duty_Charges__c)/100;
                                                        System.debug('procurement charge' +procurementcharge);
                                                        fees.Change_Amount__c = procurementcharge;
                                                        System.debug('\n FeesToBeUpdated '+fees);
                                                        FeesToBeUpdated.add(fees);
                                                    }
                                                } //25274 -- else bracket ended. 
                                            }
                                        }
                                        //// 25783 end  /////////////
                                    }

                                    //if(arrayOfStampDutyCodes != null && arrayOfStampDutyCodes.size() > 0){
                                    //22019 stamp duty logic start
                                    if (!commonUtility.isEmpty(AllPOFees)) {
                                        for (product_offerings__c po: AllPOFees) {
                                            system.debug('po id current is'+po.id);
                                            System.debug('LineProducts' + LineProducts);
                                            System.debug(arrayOfStampDutyCodes.contains(String.valueOf( Integer.valueOf(fees.Finnone_ChargeCode__c))));
                                            System.debug(LineProducts.contains(po.products__c));
                                            
                                            /**** start : 25274 -- added for procurement charges ***/
                                            Boolean flag = false;
                                            if(fees.Charge_Desc__c.containsIgnoreCase('Adminis')  || fees.Charge_Desc__c.containsIgnoreCase('Stamp')){
                                                String val = NULL;
                                                if(fees.Loan_Application__c != NULL && oppmap.containsKey(fees.Loan_Application__c) )
                                                {
                                                    val =  Fees_Utility.fetchUnsecuredStampDuty( oppmap.get(fees.Loan_Application__c) );
                                                }
                                                else if ( fees.Product_Offerings__c != NULL && mapPO.containsKey(fees.Product_Offerings__c))
                                                {
                                                    val = Fees_Utility.fetchUnsecuredStampDuty( mapPO.get(fees.Product_Offerings__c) );
                                                }
                                                
                                                if( val == 'SUCCESS'){
                                                    fees.Change_Amount__c =0;
                                                    FeesToBeUpdated.add(fees);
                                                }
                                                else if(val == 'FAILURE'){
                                                    fees.Charge_Type__c.addError('Please enter proper values in Configuration.');
                                                    FeesToBeUpdated.add(fees);
                                                }
                                                else{
                                                    flag = true;
                                                }
                                            }
                                            if (LineProducts.contains(po.products__c) && po.new_Line_Assigned__c && arrayOfStampDutyCodes.contains(String.valueOf( Integer.valueOf(fees.Finnone_ChargeCode__c)))  &&  !fees.Charge_Desc__c.containsIgnoreCase('stamp') && flag == true) 
                                            {
                                                if (po.Resi_Pick_State__c != null) 
                                                {
                                                    //StaticResName = 'StatesStampDutyLogic';
                                                    /*if (!CommonUtility.isEmpty(sr)) {
                                                    for (StaticResource resc: sr) {
                                                    }
                                                    }
                                                    StaticResName = 'SalariedCustomSettings';
                                                    sr = Database.query('SELECT  id,body,Name FROM StaticResource WHERE Name = :StaticResName LIMIT 1');*/
                                                    //Map < String, Object > allMap;
                                                    Map < String, Object > utmNameMap;
                                                    Map < String, Object > chargesMap;
                                                    List < Object > stampDutyList;
                                                    Map < String, Object > stampDutyMap = new Map < String, Object > ();
                                                    //allMap = (Map < String, object > ) JSON.deserializeUntyped(sr.body.toString());
                                                    String uTMNaneString = (String) rescMap.get('UTM_SourceNames');
                                                    system.debug('uTMNaneString>>>' + uTMNaneString);
                                                    List < String > utmList = (List < String > ) uTMNaneString.split(';');
                                                    Decimal FinalAmount = (po.Availed_Amount__c != null ? po.availed_amount__c : po.offer_amount__c);
                                                    system.debug('utmList>>>' + utmList);
                                                    system.debug('po.utm_source__c>>>' + po.utm_source__c);
                                                    if (utmList.contains(po.utm_source__c)) 
                                                    {
                                                        utmNameMap = (Map < String, object > ) rescMap.get('UTM_Sources');
                                                        chargesMap = (Map < String, object > ) utmNameMap.get(po.utm_source__c); //
                                                        system.debug('inside utm source>>>' + po.utm_source__c);
                                                        system.debug('chargesMap>>>' + chargesMap);
                                                        system.debug('utmNameMap>>>' + utmNameMap);
                                                        
                                                        if (!CommonUtility.isEmpty(po.SBS_Scheme__r.Stamp_Duty_State__c))
                                                            StampDutyState = po.SBS_Scheme__r.Stamp_Duty_State__c.toLowerCase();
                                                        else if (!CommonUtility.isEmpty(po.Resi_Pick_State__c))
                                                            StampDutyState = po.Resi_Pick_State__c.toLowerCase();
                                                        
                                                        system.debug('state is' + StampDutyState);
                                                        
                                                        if (!CommonUtility.isEmpty(chargesMap)) {
                                                            stampDutyList = (List < Object > ) chargesMap.get('StampDutyState');
                                                        }
                                                        system.debug('inside stampDutyList>>>' + stampDutyList);
                                                        if (!CommonUtility.isEmpty(stampDutyList)) {
                                                            Map < String, Object > stampDutyMapTemp;
                                                            for (Object sd: stampDutyList) {
                                                                stampDutyMapTemp = (Map < String, Object > ) JSON.deserializeUntyped(JSON.serialize(sd));
                                                                if (StampDutyState == stampDutyMapTemp.get('Name')) {
                                                                    stampDutyMap.put('Name', stampDutyMapTemp.get('Name'));
                                                                    stampDutyMap.put('Ranges', stampDutyMapTemp.get('Ranges'));
                                                                }
                                                            }
                                                        }
                                                        system.debug('stampDutyMap>>>' + stampDutyMap);
                                                        
                                                        
                                                        if (!CommonUtility.isEmpty(StampDutyState) && stampDutyMap.get('Name') != null && stampDutyMap.get('Name') == StampDutyState) {
                                                            List < Object > StateRanges = (List < Object > ) JSON.deserializeUntyped(JSON.serialize(stampDutyMap.get('Ranges')));
                                                            Map < String, Object > range;
                                                            for (Object range1: StateRanges) {
                                                                range = (Map < String, Object > ) JSON.deserializeUntyped(JSON.serialize(range1));
                                                                if (FinalAmount != null && integer.valueof(range.get('MinValue')) <= FinalAmount && ((range.get('MaxValue')) != 'infinite' && integer.valueof(range.get('MaxValue')) > FinalAmount) || (range.get('MaxValue') == 'infinite')) {
                                                                    String per = (String) range.get('Percent');
                                                                    Decimal Percent = Decimal.valueOf(per);
                                                                    system.debug('> > > mod: ' + Math.Mod(Integer.valueOf(Math.CEIL(Percent * FinalAmount)), 100));
                                                                    
                                                                    if (Math.Mod(Integer.valueOf(Math.CEIL(Percent * FinalAmount)), 100) != 0 || Math.Mod(Integer.valueOf(Percent * FinalAmount), 100) != 0) {
                                                                        
                                                                        Fees.change_amount__c = Math.CEIL((Percent * FinalAmount) / 100) * 100;
                                                                        FeesToBeUpdated.add(Fees);
                                                                        break;
                                                                    } else {
                                                                        Fees.change_amount__c = Percent * FinalAmount;
                                                                        FeesToBeUpdated.add(Fees);
                                                                        system.debug('> > > contact.Stamp_Duty__c: ' + Fees);
                                                                        break;
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    } 
                                                    else 
                                                    {
                                                        system.debug('UTM source is null');
                                                        /*** 24848 start ****/
                                                        String val = NULL; 
                                                        if(fees.Loan_Application__c != NULL && oppmap.containsKey(fees.Loan_Application__c) )
                                                        {
                                                            val =  Fees_Utility.fetchUnsecuredStampDuty( oppmap.get(fees.Loan_Application__c) );
                                                        }
                                                        else if ( fees.Product_Offerings__c != NULL && mapPO.containsKey(fees.Product_Offerings__c))
                                                        {
                                                            val = Fees_Utility.fetchUnsecuredStampDuty( mapPO.get(fees.Product_Offerings__c) );
                                                        }
                                                        if( val == 'SUCCESS')
                                                        {
                                                            fees.Change_Amount__c = 0;
                                                            FeesToBeUpdated.add(fees);                                                        
                                                            StampDutyState = NULL; 
                                                        }
                                                        else if( val == 'FAILURE')
                                                        {
                                                            fees.Charge_Type__c.addError('enter proper values in Configuration.');
                                                            StampDutyState = NULL; 
                                                        }
                                                        else
                                                        {
                                                            StampDutyState = val;
                                                        }
                                                        /*** 24848 e ***/
                                                        
                                                        if (!CommonUtility.isEmpty(po.Resi_Pick_State__c))
                                                            StampDutyState = po.Resi_Pick_State__c.toLowerCase();
                                                        
                                                        if (!CommonUtility.isEmpty(StampDutyState))
                                                            system.debug('> > > StampDutyState: ' + StampDutyState);
                                                        
                                                        //StampDutyStatesWrapper StampDutyStates = new StampDutyStatesWrapper();
                                                        //Map<string,list<Ranges>> mp = new Map<string,list<Ranges>>();
                                                        
                                                        if (!CommonUtility.isEmpty(sr)) {
                                                            for (StaticResource resc: sr) {
                                                                if (resc.Name == 'StatesStampDutyLogic' && resc.Body != null) {
                                                                    StampDutyStates = (StampDutyStatesWrapper) System.JSON.deserialize(resc.Body.toString(), StampDutyStatesWrapper.class);
                                                                }
                                                            }
                                                        }
                                                        
                                                        if (!CommonUtility.isEmpty(StampDutyStates) &&
                                                            !CommonUtility.isEmpty(StampDutyStates.states)) {
                                                                for (States st: StampDutyStates.states) {
                                                                    mp.put(st.Name.toLowerCase(), st.Ranges);
                                                                }
                                                            }
                                                        if (!CommonUtility.isEmpty(StampDutyState) &&
                                                            mp.get(StampDutyState) != null) 
                                                        {
                                                            List < Ranges > StateRanges = new List < Ranges > ();
                                                            StateRanges = mp.get(StampDutyState);
                                                            
                                                            for (Ranges range: StateRanges) 
                                                            {
                                                                /*system.debug('app.Loan_Application__r.Loan_Amount_with_Premium__c:'+app.Loan_Application__r.Loan_Amount_with_Premium__c);
                                                                system.debug('integer.valueof(range.MinValue):'+integer.valueof(range.MinValue));
                                                                system.debug('app.Loan_Application__r.Loan_Amount_with_Premium__c):'+app.Loan_Application__r.Loan_Amount_with_Premium__c);
                                                                system.debug('range.MaxValue:'+range.MaxValue);
                                                                */
                                                                if (FinalAmount != null && integer.valueof(range.MinValue) <= FinalAmount && (
                                                                    (range.MaxValue != 'infinite' && integer.valueof(range.MaxValue) > FinalAmount ) ||
                                                                    (range.MaxValue == 'infinite')
                                                                )) 
                                                                {
                                                                    Decimal Percent = Decimal.ValueOf(range.Percent);
                                                                    
                                                                    system.debug('> > > mod: ' + Math.Mod(Integer.valueOf(Math.CEIL(Percent * FinalAmount)), 100));
                                                                    
                                                                    if (Math.Mod(Integer.valueOf(Math.CEIL(Percent * FinalAmount)), 100) != 0 || Math.Mod(Integer.valueOf(Percent * FinalAmount), 100) != 0) {
                                                                        
                                                                        Fees.change_Amount__c = Math.CEIL((Percent * FinalAmount) / 100) * 100;
                                                                        
                                                                        system.debug('> > > math.ceil: ' + Fees.change_amount__c);
                                                                        
                                                                        FeesToBeUpdated.add(fees);
                                                                        break;
                                                                    } else {
                                                                        
                                                                        //Fees.change_Amount__c = decimal.valueof(range.Percent) * FinalAmount;
                                                                        //FeesToBeUpdated.add(fees);
                                                                        system.debug('> > > contact.Stamp_Duty__c: ' + fees.change_amount__c);
                                                                        break;
                                                                    }
                                                                }
                                                            }
                                                        } 
                                                        else 
                                                        {
                                                            String contents; // = sr.body.toString();
                                                            if (!CommonUtility.isEmpty(sr)) {
                                                                for (StaticResource resc: sr) {
                                                                    if (resc.Name == 'StampDutyChargesStateWise' && resc.Body != null) {
                                                                        contents = resc.Body.toString();
                                                                    }
                                                                }
                                                            }
                                                            
                                                            if (contents != null && contents != '')
                                                            {
                                                                String selectedState;
                                                                
                                                                if (!CommonUtility.isEmpty(StampDutyState))
                                                                    selectedState = StampDutyState;
                                                                
                                                                for (String line: contents.split('\n')) 
                                                                {
                                                                    system.debug('line.split : ' + line);
                                                                    if (line != null && line != '') 
                                                                    {
                                                                        String[] arrayofStateNstampDuty = line.split(',');
                                                                        
                                                                        system.debug('arrayofState: ' + arrayofStateNstampDuty[0]);
                                                                        
                                                                        if (selectedState != NULL && selectedState.equals(arrayofStateNstampDuty[0].toLowerCase())) 
                                                                        {
                                                                            system.debug('schemeMaster Matched in txt');
                                                                            
                                                                            if (arrayofStateNstampDuty.size() > 0 && arrayofStateNstampDuty[1] != null) 
                                                                            {
                                                                                Integer stampd = 0;
                                                                                stampd = Integer.valueOf(arrayofStateNstampDuty[1].trim());
                                                                                Fees.change_Amount__c = stampd;
                                                                                FeesToBeUpdated.add(Fees);
                                                                                break;
                                                                            }
                                                                            
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                            
                                            
                                        }
                                    }
                                    //22019 stamp duty logic end
                                    //}
                                    //new changes by Tejashree
                                    if (arrayOfProcessingfeeCodes != null && arrayOfProcessingfeeCodes.size() > 0) {
                                        for (string ProcFeecode: arrayOfProcessingfeeCodes) {
                                            if (fees.Finnone_ChargeCode__c != null) {
                                                system.debug('fees.Finnone_ChargeCode__c===>' + fees.Finnone_ChargeCode__c);
                                                system.debug('ProcFeecode' + ProcFeecode);
                                                if (Integer.valueOf(fees.Finnone_ChargeCode__c) == Integer.valueOf(ProcFeecode)) {
                                                    if (AllPOFees != null && AllPOFees.size() > 0 && allPOid != null && allPOid.size() > 0) {
                                                        fees.Change_Amount__c = AllPOFees[0].Processing_Fee_Amount__c;
                                                    }
                                                    system.debug('match ProcFeecode finnione code====>');
                                                    if (PrimaryApplicant != null) {
                                                        Double servicetaxval, servtax, profeeamo, totalpro,cesstax ;//added cesstax  17566
                                                        servicetaxval = 0;
                                                        servtax = 0;
                                                        profeeamo = 0;
                                                        cesstax = 0;//17566
                                                        if (PrimaryApplicant.Loan_Application__r.Loan_Amount_with_Premium__c != null && PrimaryApplicant.Loan_Application__r.Processing_Fees__c != null) profeeamo = (PrimaryApplicant.Loan_Application__r.Loan_Amount_with_Premium__c * PrimaryApplicant.Loan_Application__r.Processing_Fees__c) / 100;
                                                        
                                                        if (ATOSParameters__c.getValues('Service Tax').value__c != null) servicetaxval = Double.ValueOf(ATOSParameters__c.getValues('Service Tax').value__c);
                                                         //US 17566 s
                                                        String cessAmt = CommonUtility.checkCessAmt(AllFees[0].Id);
                                                        if(cessAmt != 'No Cess'){
                                                            //Following line modified by Gulshan for Cess Tax Handling
                                                            //servicetaxval += Double.valueof(cessAmt);
                                                            cesstax = profeeamo * Double.valueof(cessAmt);
                                                        }
                                                        //US 17566 e
                                                        system.debug('profeeamo::' + profeeamo + '***servicetaxval::' + servicetaxval);
                                                        servtax = profeeamo * servicetaxval;
                                                        system.debug('profeeamo::' + profeeamo + '***servtax::' + servtax);
                                                        totalpro = profeeamo + servtax +cesstax ;//added cesstax  for 17566
                                                        
                                                        system.debug('totalpro==>' + totalpro);
                                                        fees.Change_Amount__c = totalpro;
                                                        FeesToBeUpdated.add(fees);
                                                        
                                                    }
                                                    //Mahima fees and charges enhancement start
                                                    if(Mortgageflag)
                                                    {
                                                        
                                                        Tranche_Details__c objtranche1=new Tranche_Details__c();
                                                        Double processingFee;
                                                        for(Tranche_Details__c objtranche:allTranchesList)
                                                        {
                                                            if(fees.Tranche_Detail__c==objtranche.id)
                                                            {
                                                                objtranche1=objtranche;
                                                                break;
                                                            }
                                                        }
                                                        processingFee=(PrimaryApplicant.Loan_Application__r.Processing_Fees__c*objtranche1.Tranche_Recommended_Amount__c)/100;
                                                        fees.Change_Amount__c = processingFee;
                                                        
                                                        
                                                    }
                                                    //Mahima fees and charges enhancement ends
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                                
                                //Addy 23463
                                if(appCon != null && String.isNotEmpty(appCon.Id) && fees.Charge_Type__c == 'Stamp Duty')
                                    update appCon;
                            }
                            // SAL Mobility Addition CR - Aman Porwal - S  Updated- Hrushikesh
                            for (Applicant__c applicant: allApplicantOfLoan) {
                                System.debug('Applicants Elite flag'+applicant.Elite_Card__c);
                                if(applicant!=null && applicant.Financial_Health_Check_Guide__c == false && applicant.Applicant_Type__c == 'Primary'){
                                    SALMobilityChangeAmountFFR = true;
                                    System.debug('ffr gets true');
                                    //break;
                                }
                                if(applicant!=null && applicant.Applicant_Type__c == 'Primary'){//22017
                                    if(applicant.Elite_card_product__c != null)
                                        Elitecardcharges = Double.valueOf(applicant.Elite_card_product__c);
                                    //added AND condition for BUG 24487 EMI CARD 
                                    if(applicant.EMI_Card__c != null&&applicant.EMI_Card__c!='Not Interested')
                                        EMIcardcharges = Double.valueOf(applicant.EMI_Card__c);
                                    if(AllFees[0].application_source__c=='Online Employee Loans') //20934
                                        EMIcardcharges = Double.valueOf(applicant.EMI_Card__c);                        
                                }
                                /*if(applicant!=null && applicant.Elite_Card__c == false && applicant.Applicant_Type__c == 'Primary'){
                                SALMobilityChangeAmountEliteCard = true;
                                System.debug('elite gets true');
                                
                                }*/
                                                                /*if(applicant!=null && applicant.Credit_Card_Charges__c == false && applicant.Applicant_Type__c == 'Primary'){
                                SALMobilityChangeAmountCreditCard = true;
                                System.debug('credit gets true');
                                }*/
                            }
                            // 22017 start
                            String jsonString = '';
                            String salMobilityFFRCode,salMobilityEliteCode,salMobilityEMICode;
                            Map<String, Object> jsonBody = new Map<String, Object>();
                            Map<String,Object> ChargeCodeMap = new Map<String,String>();
                            Map<String,Object> addOnChargeCode = new Map<String,Object>();//bug 24667
                            System.debug('pk before');
                            if(salariedStaticRes != null)
                            {
                                System.debug('pk insde');
                                jsonString = salariedStaticRes.Body.toString();//changed for 22017
                                if(jsonString != '')
                                {
                                    jsonBody = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
                                    ChargeCodeMap = (Map<String,Object>) jsonBody.get('Charges');
                                    addOnChargeCode = (Map<String,Object>) jsonBody.get('AddOnCardChargeId');//bug 24667
                                }
                            }
                            if(!CommonUtility.isEmpty(ChargeCodeMap)) 
                                for(String key:ChargeCodeMap.keySet()){
                                    if(key=='FFR_Charges'){
                                        salMobilityFFRCode=String.valueOf(ChargeCodeMap.get(key));
                                    }
                                    if(key=='EliteCard_Charges'){
                                        salMobilityEliteCode=String.valueOf(ChargeCodeMap.get(key));
                                    }
                                    if(key=='EMICard_Charges'){
                                        salMobilityEMICode=String.valueOf(ChargeCodeMap.get(key));
                                    }
                                }
                            //22017 end
                            System.debug('Elite code is ='+ salMobilityFFRCode + salMobilityEliteCode + salMobilityEMICode);
                            for (Fees_and_Charge__c fees: Trigger.New) {  
                                  //bug 24667 s
                                  system.debug('***addOnSols***' + addOnSols);
                                  system.debug('***solCntMap***' +String.valueOf(Integer.valueof(fees.Finnone_ChargeId__c)));
                                  system.debug('chargeids'+fees.Finnone_ChargeId__c);
                                  system.debug('chargecodeSR'+addOnChargeCode.containskey(String.valueOf(fees.Finnone_ChargeId__c)));
                                if(addOnChargeCode.containskey(String.valueOf(Integer.valueof(fees.Finnone_ChargeId__c))) && (addOnSols.size() > 0)){
                                    
                                    Integer cnt = solCntMap.get((String)addOnChargeCode.get(String.valueOf(Integer.valueof(fees.Finnone_ChargeId__c))));
                                    System.debug('cnt '+cnt);
                                    if(cnt != null)
                                        fees.Change_Amount__c = Decimal.valueOf((String)addOnChargeCode.get(String.valueOf(Integer.valueof(fees.Finnone_ChargeId__c))))*cnt;
                                    fees.Deducted_from_Disbursement__c = 'Yes';
                                    fees.Instrument_type__c = 'Deduct from Disb';
                                }else if((fees.Charge_Desc__c.contains('ADD ON CARD FEE')) && (addOnSols.size() == 0)){
                                    system.debug('In here Add');
                                   fees.Change_Amount__c = 0; 
                                }
                                //bug 24667 e
                                /* if (LaonApplicationCreation__c.getValues('SAL Mobility Charges API FFR Codes') != null) 
                                {
                                String salMobilityFFRCode = LaonApplicationCreation__c.getValues('SAL Mobility Charges API FFR Codes').FFR_Finnone_charge_code__c;
                                String salMobilityEliteCode = LaonApplicationCreation__c.getValues('SAL Mobility Charges API FFR Codes').Value__c;  //this field is refer for Elite charge code
                                System.debug('Elite code is ='+ salMobilityFFRCode + salMobilityEliteCode );
                                // String salMobilityCreditCode = LaonApplicationCreation__c.getValues('SAL Mobility Charges API FFR Codes').Line_charges_Codes__c; // this is used for Credit card Charge code
                                */
                                try{
                                    //System.debug('What is allFees'+AllFees[0].Account.Flow__c);//Bug 24487
 String docFeeCode= CommonUtility.getStaticResourceData('EmployeeLoanStaticResource','DocumentationFee_ChargeCode','');//5492
                                     String Stamp_duty_Code= CommonUtility.getStaticResourceData('SalariedCustomSettings','stampDutycode','');//5492
                                   
                                    if (AllFees!=null && AllFees.size()>0 && (AllFees[0].Account.Flow__c == 'Mobility V2' || AllFees[0].Account.Flow__c == 'Mobility' ||AllFees[0].Account.Product__c=='PRO')) {
                                        if (fees.Finnone_ChargeId__c != null) {
                                            system.debug('fees.Finnone_ChargeId__c=====>' + fees.Finnone_ChargeId__c);
                                            //String finnCode = ';'+fees.Finnone_ChargeId__c+';';
                                            String finnCode=''+fees.Finnone_ChargeId__c;
                                            if ((finnCode.contains(salMobilityFFRCode))&& (SALMobilityChangeAmountFFR==true)) {
                                                fees.Change_Amount__c = 0;
                                                System.debug('for FFR');
                                            }
                                            //22017 start
                                            if (salMobilityEliteCode != null && finnCode.contains(salMobilityEliteCode)) {
                                                fees.Change_Amount__c = Elitecardcharges;
                                                System.debug('for Elite');
                                            }
                                            if (salMobilityEMICode != null && finnCode.contains(salMobilityEMICode)) {
                                                fees.Change_Amount__c = EMIcardcharges;
                                                System.debug('for EMI');
                                            }
                                            //22017 end
if (finnCode.contains(docFeeCode) && fees.Change_Amount__c != null) {//5492
                                                                System.debug('in docfee'+AllFees[0].Loan_Amount_with_Premium__c+AllFees[0].Account.Flow__c);
                                                 if(AllFees[0].Loan_Amount_with_Premium__c>=500000 && AllFees[0].Account.Flow__c == 'Mobility V2')
                                                        {
                                                           fees.Change_Amount__c=0; 
                                                            System.debug('in docfee');
                                                        }
                                            }
                                            if(finnCode.contains(Stamp_duty_Code) && fees.Change_Amount__c != null) {//5492
                                                                                                            System.debug('in stamp');
                                                 if(AllFees[0].Loan_Amount_with_Premium__c<500000 && AllFees[0].Account.Flow__c == 'Mobility V2')
                                                        {
                                                           fees.Change_Amount__c=0; 
                                                           System.debug('in stamp');
                                                        }
                                                
                                            }//5492 stop
                                            /*if ((finnCode.contains(salMobilityEliteCode))&& (SALMobilityChangeAmountEliteCard==true)) {
                                            fees.Change_Amount__c = 0;
                                            System.debug('for Elite');
                                            }
                                            if (salMobilityCreditCode.contains(finnCode)&& (SALMobilityChangeAmountCreditCard==true)) {
                                            fees.Change_Amount__c = 0;
                                            System.debug('for crredit card');
                                            }*/
                                        }
                                    }
                                }
                                catch(Exception e)
                                {
                                    system.debug('Exception is ====>'+e+'  at line number'+e.getLineNumber());
                                }
                                // }
                            }
                            // SAL Mobility Addition CR - Aman Porwal - E
                            system.debug('charges to be updated ---0->' + FeesToBeUpdated);
                        }
                    }
                }
            } 
            
            /*IMPS Account Validation : 13907 S*/
            String UserID = UserInfo.getUserId();
            UserID = UserID.substring(0, 15);
            Boolean IMPSUpdateCharge = false;
            User usrinfo = [select id, Profile.Name, Name from User where id = : UserID LIMIT 1];
            String ProfileName = usrinfo.Profile.Name;
            List<String> lab;
            if(Label.IMPS_Product != null) 
                lab = String.valueOf(Label.IMPS_Product).split('=');
            
            List<String> IMPSProd ;
            List<String> IMPSProfile ; 
            if(AllFees != null && AllFees.size() > 0 && AllFees[0] != null && lab != null && lab.size() > 0 && lab[0] != null && lab[1] != null)
            {   
                IMPSProd = lab[0].split(';');
                IMPSProfile = lab[1].split(';');
                if((new Set<String>(IMPSProd)).Contains(AllFees[0].product__c) && (new Set<String>(IMPSProfile)).Contains(ProfileName))
                {
                    IMPSUpdateCharge = true;
                }
                
                // Bug 17664 : start
                List<String> stpMobileProduct = new List<String>();
                stpMobileProduct = Label.IMPS_Product_Mobility.split(';');
                List<Account> accList = new List<Account>();
                if (allApplicantOfLoan != null && allApplicantOfLoan.size() > 0) 
                    accList = [Select Process_Flow__c From Account where Applicant__c = : allApplicantOfLoan[0].Id ];
                System.debug('accList --> ' + accList);
                //Bug 24237 added non stp c in or
                // STP flow with product match allow charge update
                //Added for 27th May 2019
                if ((new Set<String>(stpMobileProduct)).Contains(AllFees[0].product__c) && accList != null && accList.size() > 0 && (accList[0].Process_Flow__c == 'STP'|| accList[0].Process_Flow__c == 'NON_STP_C'|| accList[0].Process_Flow__c == 'NON_STP_B')) {
                    IMPSUpdateCharge = true;
                }
                // Bug 17664 : end
            }
            System.debug('IMPSUpdatechange -->'+IMPSUpdateCharge);
            if(IMPSUpdateCharge){
                System.debug('in method-->');
                Id LoanId ;
                List<Current_Disbursal_Details__c> DisList = new List<Current_Disbursal_Details__c>();
                Decimal IMPSProcessingFeeAmt = 0.0;
                Decimal IMPSChargeAmt = 0.0;
                String IMPSCodes = Label.IMPS_Charge_Code;
                SET<String> Accnums = new SET<String>();
                List<String> ChargeCodes = IMPSCodes.split(';');
                for (Fees_and_Charge__c fees: Trigger.New) {
                    LoanId = fees.Loan_Application__c;
                }
                DisList = [select Bank_Account__c,Successful_IMPS_Count__c,id,Failure_IMPS_Count__c from Current_Disbursal_Details__c where Loan_Application__c =: LoanId];
                System.debug('in method DisList -->'+DisList.size());
                for(Current_Disbursal_Details__c dis : DisList)
                {
                    System.debug('Accnums --->'+Accnums);
                    if(!Accnums.contains(dis.Bank_Account__c))
                    {
                        System.debug('in if');
                        if(dis.Successful_IMPS_Count__c != null && dis.Successful_IMPS_Count__c > 0)
                        {
                            IMPSProcessingFeeAmt = IMPSProcessingFeeAmt +(dis.Successful_IMPS_Count__c * Decimal.valueOf(Label.IMPS_Processing_fee));
                            IMPSChargeAmt= IMPSChargeAmt + (dis.Successful_IMPS_Count__c * Decimal.valueOf(Label.IMPS_Transaction_charge));
                            System.debug('IMPSProcessingFeeAmt-->'+IMPSProcessingFeeAmt+'IMPSChargeAmt -->'+IMPSChargeAmt);
                        }
                        if(dis.Failure_IMPS_Count__c != null && dis.Failure_IMPS_Count__c > 0)
                        {
                            IMPSProcessingFeeAmt = IMPSProcessingFeeAmt + (dis.Failure_IMPS_Count__c * Decimal.valueOf(Label.IMPS_Processing_fee));
                        }
                        Accnums.add(dis.Bank_Account__c);
                    }
                }
                System.debug('before for');
                for (Fees_and_Charge__c fees: Trigger.New) {
                    System.debug('in for fees.Finnone_ChargeCode__c'+fees.Finnone_ChargeId__c+'ChargeCodes'+ChargeCodes);
                    if(fees.Finnone_ChargeId__c != null && ChargeCodes != null )
                    {
                        if(fees.Finnone_ChargeId__c == Decimal.valueOf(ChargeCodes[0]))
                            fees.Change_Amount__c = IMPSProcessingFeeAmt;
                        else if(fees.Finnone_ChargeId__c == Decimal.valueOf(ChargeCodes[1])){
                            fees.Change_Amount__c = IMPSChargeAmt;
                            System.debug('fees.Change_Amount__c'+fees.Change_Amount__c);
                        }
                    }   
                }
            }
            /*IMPS Account Validation : 13907 E*/
            
            //bug id 17664 - implemenation done for all products start
            /*List<StaticResource> staticResList = [SELECT Body
            FROM StaticResource
            WHERE Name = 'PremiumCharge' LIMIT 1];*/ //commented by prashant for sprint 5B
            String jsonString = '';
            Map<String, Object> jsonBody = new Map<String, Object>();
            Map<String, Object> chargeIdDescJsonMap = new Map<String, Object>();
            Map<String, String> chargeIdDescMap = new Map<String, String>();
            //Rohit added null check
            System.debug('loanAppId --> '+loanAppId);
            if(PremiumChargeRes != null && loanAppId !='' && loanAppId != null)//changed for 22017
            {
                jsonString = PremiumChargeRes.Body.toString();//changed for 22017
                if(jsonString != '')
                {
                    jsonBody = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
                    
                    chargeIdDescJsonMap = (Map<String, Object>)jsonBody.get('PremiumCharge');
                    
                    if(chargeIdDescJsonMap.size() > 0)
                    {
                        for(String key : chargeIdDescJsonMap.keySet())
                        {
                            String value = String.valueOf(chargeIdDescJsonMap.get(key));
                            chargeIdDescMap.put(key,value);
                        }
                        
                        system.debug('chargeIdDescMap --->> '+chargeIdDescMap);
                        
                        List<DPLinsurance__c> insuranceList = [SELECT Id, Insurance_Product__c, Premium_Amount__c FROM DPLinsurance__c WHERE Opportunity__c =: loanAppId];
                        //loanAppId to declared as a variable above..
                        Map<String, DPLinsurance__c> insuranceProdObjectMap = new Map<String, DPLinsurance__c>();
                        for(DPLinsurance__c insuranceObj : insuranceList)
                        {
                            //Added by Rakesh :Bug 23751 : made map key as case insensitive  
                            if(String.IsNotBlank(insuranceObj.Insurance_Product__c))
                                insuranceProdObjectMap.put(insuranceObj.Insurance_Product__c.toUppercase(), insuranceObj);
                        }
                        if(insuranceList.size() > 0)
                        {
                            for (Fees_and_Charge__c feesObj : Trigger.New)
                            {
                                system.debug('feesObj.Finnone_ChargeId__c ----->> '+feesObj.Finnone_ChargeId__c);
                                // String chargeDesc = chargeIdDescMap.get(String.valueOf(feesObj.Finnone_ChargeId__c).split('\\.')[0]);
                                
                                // Added by harshal to avoid Null Pointer [To increase Code Coverage of PricingDisbmntDetails_Ctrl ]
                                String tempKey = '';
                                if(feesObj.Finnone_ChargeId__c !=null){
                                    tempKey = String.valueOf(feesObj.Finnone_ChargeId__c).split('\\.')[0];
                                }
                                String chargeDesc = chargeIdDescMap.get(tempKey);
                                // Added by harshal end
                                
                                system.debug('chargeDesc ---->> '+chargeDesc);
                                if(chargeDesc != null)
                                {
                                    //Added by Rakesh :Bug 23751 : made map key as case insensitive
                                    DPLinsurance__c insuranceObj =new  DPLinsurance__c();//= insuranceProdObjectMap.get(chargeDesc.toUppercase());
                                    if(String.IsNotBlank(chargeDesc))
                                        insuranceObj = insuranceProdObjectMap.get(chargeDesc.toUppercase());
                                    
                                    system.debug('insuranceObj ---->> '+insuranceObj);
                                    feesObj.Change_Amount__c = insuranceObj != null ? (insuranceObj.Premium_Amount__c != null ? Decimal.valueOf(insuranceObj.Premium_Amount__c) : 0) : 0;
                                }
                                system.debug(feesObj.Charge_Desc__c+' charge amount --->> '+feesObj.Change_Amount__c);
                            }
                        }
                    }
                }
            }
        }
        //Added for Bug 24313 start
        if(Trigger.isAfter) {
            system.debug('inside isInsert-isAfter');
            set<Id> setLoan = new set<id>();
            for(Fees_and_Charge__c feesc:trigger.new){
                system.debug('feesc.LoanApplication'+feesc.Loan_Application__c);
                if(feesc.Loan_Application__c != null){
                    Opportunity Loan = oppMap.get(feesc.Loan_Application__c);
                    if(Loan.Account.Flow__c == 'Mobility V2')
                        setLoan.add(feesc.Loan_Application__c);
                }
            }
            system.debug('Loanset'+setLoan);
            if(setLoan.size() > 0)
                GeneralUtilities.ResendConsentMailValidation('Fees_and_Charge__c',setLoan);
        }
    }
    if(Trigger.isAfter && Trigger.isDelete ){
        //Map<String, Opportunity>oppmap = new Map<String,Opportunity>();
        
        for (Fees_and_Charge__c fees1: Trigger.old) {
            if(fees1.Loan_Application__c != null)
                allfeesid.add(fees1.Loan_Application__c);
            
        }
        
        if (allfeesid != null && allfeesid.size() > 0)
            
            AllFees = GeneralUtilities.getOpportunities(allfeesid);
        for(Opportunity opps : AllFees){
            
            oppmap.put(opps.id,opps);
            
        }
        set<Id> setLoan = new set<id>();
        for(Fees_and_Charge__c feesc:trigger.old){
            
            if(feesc.Loan_Application__c != null){
                Opportunity Loan = oppMap.get(feesc.Loan_Application__c);
                if(Loan.Account.Flow__c == 'Mobility V2')
                    setLoan.add(feesc.Loan_Application__c);
            }
            GeneralUtilities.ResendConsentMailValidation('Fees_and_Charge__c',setLoan);
        }
        //Added for Bug 24313 stop    
        
        system.debug('inside trigger -- UpdateChargeAmount -- End \n');
    }
    /*Retrigger BRE 24313/20939 s */
    if(Trigger.isAfter && trigger.isUpdate){
        for(Fees_and_Charge__c FeesCharge:trigger.new){
            if(FeesCharge.Loan_Application__c != null)
                LoanIdsSet.add(FeesCharge.Loan_Application__c);//24313
        }
        
        Map<Id, Opportunity> oppMap;
        System.debug('loanIDset'+LoanIdsSet);
        if(!CommonUtility.isEmpty(LoanIdsSet)){
            //System.debug('AccountFlowCheck'+FeesCharge.Loan_Application__r.AccountId);
            oppLstSt = GeneralUtilities.getOpportunities(LoanIdsSet);//Bug 24313
            List<Opportunity> oppLst = oppLstSt;//24313
            if(!CommonUtility.isEmpty(oppLst)){
                oppMap = new Map<Id, Opportunity>();
                for(Opportunity opp : oppLst)
                    oppMap.put(opp.Id,opp);
            }
            System.debug('Yes'+oppMap);
        }
        Map<String,Object> allMap = new Map<String,Object>();
        allMap = GeneralUtilities.fetchRetriggerRescMap();
        Map<String,SOL_Policy__c> solPolicyToUpdateMap = new map<String,SOL_Policy__c>();
        for(Fees_and_Charge__c FeesCharge:trigger.new){
            Opportunity Loan = new Opportunity();
            if(oppMap != null && oppMap.containsKey(FeesCharge.Loan_Application__c) && oppMap.get(FeesCharge.Loan_Application__c) != null){
                Loan = oppMap.get(FeesCharge.Loan_Application__c);
            }
            
            system.debug('in mobility'+Loan.Account.Flow__c);
            if(Loan != null && Loan.Account.Flow__c == 'Mobility V2'){
                Map<String, SOL_Policy__c> solPolicyMAPToUpdate=new Map<String, SOL_Policy__c>();
                Map<String,Object> feesFields = new Map<String,Object>();
                if(!commonutility.isEmpty(allMap)){
                    feesFields = (Map<String,Object>)ALLMap.get('Fees_and_Charge__c');
                    System.debug('Hi'+feesFields );
                    if(!commonutility.isEmpty(feesFields)){
                        solPolicyToUpdateMap = GeneralUtilities.reTriggerBREGen(Trigger.oldmap.get(FeesCharge.Id),FeesCharge,Loan,feesFields,solPolicyToUpdateMap);
                    }
                }
            }
            
        }
        if(solPolicyToUpdateMap != null && solPolicyToUpdateMap.size() > 0){
            update solPolicyToUpdateMap.values();  
        }
        /*Retrigger BRE 24313/20939 e */
    }   
}//bug id 17664 - implementation done for all products end