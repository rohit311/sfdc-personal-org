public without sharing class SALMobilityCntrl_V2{


  public String primaryappid{
    get;
    set;
    }
     public String oppid{
        get;
        set;
    }
    public static String DuplicateLoanId{get;set;}
    public static String DuplicateBarCodeNo{get;set;}
    public static String DuplicateLAN{get;set;}
    
    @AuraEnabled
    /*****************************************************
     * Method Name  : getPicklistValues 
     * Purpose      : To get all required picklist values on init.
     * Param        : @objectFieldJSON : object field map of values required.
     * Return       : Serialized map of object, field, and field values.
     * Invoked From : SAL20_DisbDashboard 
     * ***************************************************/
    public static String getPicklistValues(String objectFieldJSON) {
        System.debug(JSON.serialize(LighteningUtilities.getPicklistValues(objectFieldJSON)));
        return JSON.serialize(LighteningUtilities.getPicklistValues(objectFieldJSON));
    }
    
    
    public SALMobilityCntrl_V2() {
       if (Apexpages.currentPage() != null && Apexpages.currentPage().getParameters().get('priamryappid') != null && Apexpages.currentPage().getParameters().get('priamryappid') != '') 
            primaryappid = Apexpages.currentPage().getParameters().get('priamryappid');
        else
            primaryappid = '';
       if (Apexpages.currentPage() != null && Apexpages.currentPage().getParameters().get('oppid') != null && Apexpages.currentPage().getParameters().get('oppid') != '') 
            oppid= Apexpages.currentPage().getParameters().get('oppid');
        else
            oppid= '';
           // System.currentPageReference().getParameters().put('id', oppid);
       // ApexPages.currentPage().getParameters().put('id',oppid);
        
         SecondaryCIBILCtrl ctrl = new SecondaryCIBILCtrl();
         //SecondaryCIBILCtrl.oppidNew = oppid;
         System.debug('inside SALMobilityCntrl_V2'+ primaryappid+'oppid ='+oppid);
         
     }
    @AuraEnabled
    public static String checkPOUsernames() {
        if(autoCompleteController.checkMobilityV2POUsernames() == true)
            return 'Success';
        else
            return 'You are not allowed to view this page';
    }
    @ AuraEnabled
    public static String getTheme() {
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String MyProflieName = PROFILE[0].Name;
        Boolean isCommunityUsr = false;
        isCommunityUsr = CommonUtility.hasCommunityProfile(new Set<String>{MyProflieName});
        
        return UserInfo.getUiThemeDisplayed()+';'+MyProflieName+';'+isCommunityUsr ;
    }
//Start Bug 23064
     @ AuraEnabled
    public static boolean getuserprofile() {
        boolean salesprofilecheck=false;
        Id profId = UserInfo.getProfileId();
        Profile loggeduserprofile = [Select Name from Profile where Id =:profId limit 1];
        String salesprofile = CommonUtility.getStaticResourceData('SalariedCustomSettings','SalesProfiles','');
       // return salesprofile;
        system.debug('NAME'+loggeduserprofile.Name+'salesprofile'+salesprofile);
        if(salesprofile.contains(loggeduserprofile.Name)){
           salesprofilecheck = true; 
        }
        return salesprofilecheck;
     }
    
   /* Previous working logic
    @ AuraEnabled
        public static List <Sales_Officer_Limit__c> fetchSOLData(string OPP) {
            system.debug('OPP'+OPP);
            
            Opportunity Loan = (Opportunity)JSON.deserialize(OPP,Opportunity.class);
           
            String MobilityProducts=System.Label.ValidMobilityV2Products; 
            system.debug('MobilityProducts'+MobilityProducts);
            List<String> prods = MobilityProducts.split(';');
            Sales_Officer_Limit__c finalSOL = new Sales_Officer_Limit__c (); 
            List <Sales_Officer_Limit__c> optionsAppr = new List <Sales_Officer_Limit__c>();
            Id loggedUserId = UserInfo.getUserId();
            Map< Id, Sales_Officer_Limit__c > heirarchyMap = new Map< Id, Sales_Officer_Limit__c > (); 
            for (Sales_Officer_Limit__c sol: [select id,Customer_Rating__c,FFR_Percent__c, WIRR__c, WPF__c, LI_PREMIUM__c, LI_Percent__c, HI_PREMIUM__c, HI_Percent__c, Sales_Officer_Name__r.email, Sales_Officer_Name__c, Sales_Officer_Name__r.Mobile_number__c, Sales_Officer_Name__r.name, Reporting_Manager_Name__c, Reporting_Manager_Designation__c,
                                              Reporting_Manager_Name__r.Mobile_number__c, ASM_Branch__c, Selected_Flag__c, Designation__c, Location__c, Product__c,
                                              Max_Number__c,Sales_officer_Email__c,CPP_Percent__c,FFR_Penetration__c,Total_Number_Of_Cases__c,Portfolio_Health__c,DesignationCount__c,Reporting_Manager_Name__r.name from Sales_Officer_Limit__c where Active__c = true And Sales_Officer_Name__r.IsActive = true and Product__c IN : prods
                                             ]) {
                                                // System.debug('OffNAME'+sol.Sales_Officer_Name__c);
                                                 if(sol.Sales_Officer_Name__c != null && sol.Sales_Officer_Name__c == loggedUserId)
                                                     finalSOL=sol;
                                                 
                                                     heirarchyMap.put(sol.Reporting_Manager_Name__c, sol);   
                                             }
            system.debug('heirarchyMap'+heirarchyMap);
          
            
            if(heirarchyMap.size()>0){
                system.debug('final SOL check :'+finalSOL);
                do {
                    
                    if(finalSOL != null && finalSOL.Sales_Officer_Name__c != null){
                        optionsAppr.add(finalSOL); 
                        finalSOL = heirarchyMap.get(finalSOL.Sales_Officer_Name__c);
                    }
                    system.debug('final SOL check :'+finalSOL);
                } while (finalSOL != null);
                
            }
            system.debug('finalSalesAppr'+optionsAppr.size());
            
            return optionsAppr;
        }  */

    /* Sw-Logic for heirarchy
      @ AuraEnabled
        public static List <Sales_Officer_Limit__c> fetchSOLData(string OPP) {
            system.debug('OPP'+OPP);
            
            Opportunity Loan = (Opportunity)JSON.deserialize(OPP,Opportunity.class);
            String MobilityProducts=System.Label.ValidMobilityV2Products; 
            system.debug('MobilityProducts'+MobilityProducts);
            Id loggedUserId = UserInfo.getUserId();
            List<String> prods = MobilityProducts.split(';');
            Map<Id,Sales_Officer_Limit__c> finalSOL = new  Map<Id,Sales_Officer_Limit__c> (); 
            List <Sales_Officer_Limit__c> optionsAppr = new List <Sales_Officer_Limit__c>();
            
            
            Map<String,Sales_Officer_Limit__c>  heirarchyMap = new Map<String, Sales_Officer_Limit__c> (); 
            
            List<Sales_Officer_Limit__c>lstOldSOL= new List<Sales_Officer_Limit__c>();
            finalSOL =new Map<Id,Sales_Officer_Limit__c> ([select id,Customer_Rating__c,FFR_Percent__c, WIRR__c, WPF__c, LI_PREMIUM__c, LI_Percent__c, HI_PREMIUM__c, HI_Percent__c, Sales_Officer_Name__r.email, Sales_Officer_Name__c, Sales_Officer_Name__r.Mobile_number__c, Sales_Officer_Name__r.name, Reporting_Manager_Name__c, Reporting_Manager_Designation__c,
                                              Reporting_Manager_Name__r.Mobile_number__c,ASM_Branch__c, Selected_Flag__c, Designation__c, Location__c, Product__c,
                                              Max_Number__c,Sales_officer_Email__c,CPP_Percent__c,FFR_Penetration__c,Total_Number_Of_Cases__c,Portfolio_Health__c,DesignationCount__c,Reporting_Manager_Name__r.name from Sales_Officer_Limit__c where Active__c = true And Sales_Officer_Name__r.IsActive = true and Product__c IN : prods and Location__c INCLUDES (:Loan.Branch_Name__r.name)
                                             order by createdDate desc]);
            //Adding logged in user into heirarchyMap-->firt in heirarchy
            for(Sales_Officer_Limit__c logUser:finalSOL.values()){
                if(logUser.Sales_Officer_Name__c != null && logUser.Sales_Officer_Name__c == loggedUserId)
                {
                    System.debug('Logged in user found '+logUser);
                    if(!heirarchyMap.containsKey(logUser.Sales_Officer_Name__c))
                    {
                         heirarchyMap.put(logUser.Sales_Officer_Name__c,logUser);
                          optionsAppr.add(logUser);
                    }  
                    break;
                }
            }
            
            for (Sales_Officer_Limit__c sol: finalSOL.values()) {
               System.debug('My heirarchyMap '+heirarchyMap);
                if(sol.Reporting_Manager_Name__c!=null && heirarchyMap.containsKey(sol.Reporting_Manager_Name__c)){
                  
                    heirarchyMap.put(sol.Sales_Officer_Name__c,sol);
                 
                     optionsAppr.add(sol);
                }                           
            }                                  
                                              
            system.debug('heirarchyMap '+heirarchyMap.size()+heirarchyMap);
            system.debug('finalSOL123 '+finalSOL);
            
            
            
            system.debug('optionsAppr'+optionsAppr.size()+optionsAppr);
            
            return optionsAppr;
        }  */
     @ AuraEnabled
        public static List <Sales_Officer_Limit__c> fetchSOLData(string OPP) {
            //system.debug('OPP'+OPP);
            //Opportunity Loan = (Opportunity)JSON.deserialize(OPP,Opportunity.class);
            String MobilityProducts=System.Label.ValidMobilityV2Products; 
            system.debug('MobilityProducts'+MobilityProducts);
            List<String> prods = MobilityProducts.split(';');
            Sales_Officer_Limit__c finalSOL = new Sales_Officer_Limit__c (); 
            Set <Sales_Officer_Limit__c> optionsAppr = new Set <Sales_Officer_Limit__c>();
            Id loggedUserId = UserInfo.getUserId();
            Map< Id, set<Sales_Officer_Limit__c> > heirarchyMap = new Map< Id, set<Sales_Officer_Limit__c>> (); 
            Set<Sales_Officer_Limit__c>lstOldSOL= new Set<Sales_Officer_Limit__c>();
            for (Sales_Officer_Limit__c sol: [select id,Sum_of_Approved_Loan_Amount_CurrMonth__c,Customer_Rating__c,FFR_Percent__c, WIRR__c, WPF__c, LI_PREMIUM__c, LI_Percent__c, HI_PREMIUM__c, HI_Percent__c, Sales_Officer_Name__r.email, Sales_Officer_Name__c, Sales_Officer_Name__r.Mobile_number__c, Sales_Officer_Name__r.name, Reporting_Manager_Name__c, Reporting_Manager_Designation__c,
                                              Reporting_Manager_Name__r.Mobile_number__c,ASM_Branch__c, Selected_Flag__c, Designation__c, Location__c, Product__c,
                                              Max_Number__c,Sales_officer_Email__c,CPP_Percent__c,FFR_Penetration__c,Total_Number_Of_Cases__c,Portfolio_Health__c,DesignationCount__c,Reporting_Manager_Name__r.name from Sales_Officer_Limit__c where Active__c = true And Sales_Officer_Name__r.IsActive = true and Product__c IN : prods 
                                             ]) {
                                                // System.debug('OffNAME'+sol.Sales_Officer_Name__c);
                                                 if(sol.Sales_Officer_Name__c != null && sol.Sales_Officer_Name__c == loggedUserId)
                                                 {
                                                     finalSOL=sol;
                                                     optionsAppr.add(finalSOL);
                                                 }
                                                 if(sol.Reporting_Manager_Name__c!=null ){
                                                    if(heirarchyMap.containsKey(sol.Reporting_Manager_Name__c))
                                                    {
                                                        lstOldSOL=heirarchyMap.get(sol.Reporting_Manager_Name__c);
                                                        lstOldSOL.add(sol);
                                                        heirarchyMap.put(sol.Reporting_Manager_Name__c, lstOldSOL); 
                                                    } 
                                                     else
                                                         heirarchyMap.put(sol.Reporting_Manager_Name__c, new Set<Sales_Officer_Limit__c>{sol});   
                                                 }
                                                    
                                             }
            system.debug('heirarchyMap'+heirarchyMap.size()+heirarchyMap);
            system.debug('finalSOL123'+finalSOL);
            
            if(heirarchyMap.size()>0){
               getHeirarchySol(finalSOL,heirarchyMap,optionsAppr);
            }
            system.debug('optionsAppr'+optionsAppr.size()+optionsAppr);
            
            return new List<Sales_Officer_Limit__c>(optionsAppr);
        }  
    
    
    public static List<Sales_Officer_Limit__c> getHeirarchySol(Sales_Officer_Limit__c sol,Map< Id, Set<Sales_Officer_Limit__c> > heirarchyMap,Set<Sales_Officer_Limit__c> optionsAppr){
       Set<Sales_Officer_Limit__c> lstSOL = heirarchyMap.get(sol.Sales_Officer_Name__c);
        if(lstSOL!=null && lstSOL.size()>0)
        {
            optionsAppr.addAll(lstSOL);
            for(Sales_Officer_Limit__c childSol :lstSOL)
           
                    getHeirarchySol(childSol,heirarchyMap,optionsAppr);
                
                           
        }
        return new List<Sales_Officer_Limit__c>(optionsAppr);
    }
     
   
    //End Bug 23064
    @ AuraEnabled
    public static String callConvertToLAField(String flow, String poId) {
         System.debug('poObj'+poId);
         Map < String, Object > params = new Map < String,Object > {
            'poId' => poId,
            'Sendtoname' => 'Sales',
            'flow' => 'salaried',
            'salariedFlow' => 'mobility2'
            
        };
        system.debug('sendToSalesConvert>>' + params);
        Boolean isdualLAN = SFDCMobilePOUtility.checkDualLAN(poId);
        if(isdualLAN){
            return 'failduetopancheck';
        }
        else
            return mobility_pro.sendtoSalesConvert(JSON.serialize(params));
    
    }
    @ AuraEnabled
    public static String getProductOfferingData(String productOfferingId,string objectFieldJSON) {
        return SALMobilityPOCntrl_V2.getProductOfferingData(productOfferingId,objectFieldJSON);
    }
    
    @ AuraEnabled
    public static String savePO(String jsonPOrecord) { 
        system.debug('jsonPOrecord inside Aura Apex : '+jsonPOrecord);
        List<String> str = new List<String>();
        str=jsonPOrecord.split(';');

        String jsonLeadrecord;
        system.debug('strsize'+str.size());
        if(str.size() > 1)
            jsonLeadrecord = str[1];
        system.debug('jsonLeadrecord inside Aura Apex : '+jsonLeadrecord);
        String jsonScamrecord;
        if(str.size() > 2)
            jsonScamrecord = str[2];
        system.debug('jsonScamrecord inside Aura Apex : '+jsonScamrecord);
        return SALMobilityPOCntrl_V2.savePO(jsonPOrecord,jsonLeadrecord,jsonScamrecord); 
    }
    
    @ AuraEnabled
    public static String getPOListViewData(String selectedTab) {
        return SALMobilityPOCntrl_V2.getPOListViewData(selectedTab);
    }
    
    @ AuraEnabled
    public static String getPOList() {
        return SALMobilityPOCntrl_V2.getPOList();
    }
    
    @ AuraEnabled
    public static String generateOtp(String mobilenumber,String poId) { //20939 RCU changed method signature
            if(!CommonUtility.isEmpty(mobilenumber))
                mobilenumber= '(' + mobilenumber.substring(0, 3) + ') ' + mobilenumber.substring(3, 6) + '-' + mobilenumber.substring(6);
            System.debug('inside generateotp'+mobilenumber);
        return SALMobilityPOCntrl_V2.generateOtp(mobilenumber,poId); //20939 RCU added extra parameter
        }
    @ AuraEnabled
        public static Boolean updateOtp(String parentId,String otpValue) {
            System.debug('inside updateotp'+parentId + otpValue);
            return SALMobilityPOCntrl_V2.updateOtp(parentId,otpValue);
        }
    
    
    @AuraEnabled
    public static List < Segment_Master__c > fetchEmployer(String searchKeyWord) {
        return [SELECT id, Name, Company_Category__c,KID__c FROM Segment_Master__c WHERE Name LIKE: (searchKeyWord + '%') AND Active_Flag__c = true];
    }
    
    @AuraEnabled
    public static List<String> getDisposition(String fldDisposition, String controllingField, String dependentField){
        return SALMobilityPOCntrl_V2.getDisposition(fldDisposition,controllingField,dependentField);
    }
    
    @AuraEnabled
    public static List < Sourcing_Channel__c > fetchSource(String searchKeyWord) {
        return SALMobilityPOCntrl_V2.fetchSource(searchKeyWord);
    }
    
    @AuraEnabled
    public static List < Referral__c > fetchReferral(String searchKeyWord) {
        return SALMobilityPOCntrl_V2.fetchReferral(searchKeyWord);
    }
    @auraenabled
    public static String getItems (String searchString){
        system.debug('searchString>>'+searchString);
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(searchString);
        String PANString =(string)m.get('PANString');
        String NAMEString =(string)m.get('NAMEString');
        String MOBILEString =(string)m.get('MOBILEString');
        system.debug('PANString>>'+PANString);
        return SALMobilityPOCntrl_V2.getPOOfferItems(PANString,NAMEString,MOBILEString);
    }
     @auraenabled
    public static String getLoanItemsnew (String mobileString){
        system.debug('inside getitems mobileString>>'+mobileString);
     return SALMobilityPOCntrl_V2.getPOOfferItems('','',mobileString);
    }
    @auraenabled
    public static String getLoanItems (String searchString){
        system.debug('searchString>>'+searchString);
        List<String> searchList = searchString.split(';');
        system.debug('searchList'+searchList.size());
        //Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(searchString);
        /*String PANString =(string)m.get('PANString');
        String NAMEString =(string)m.get('NAMEString');
        String MOBILEString =(string)m.get('MOBILEString');*/
        String PANString = '';
        if(searchList.size() > 0)
           PANString =searchList[0];
        String NAMEString = '';
        if(searchList.size() > 1)   
            NAMEString = searchList[1];
        String MOBILEString = '';
        if(searchList.size() > 2)   
            MOBILEString = searchList[2];
       if(searchList.size() > 3)   
           MOBILEString += searchList[3];
        system.debug('PANString>>'+PANString+NAMEString +MOBILEString );
       return SALMobilityPOCntrl_V2.getPOOfferItems(PANString,NAMEString,MOBILEString);
    }
    @auraenabled
    public static String getUserIDfromApex (){
        return SALMobilityPOCntrl_V2.getUserIDfromApex();
    }
    /*Sprint 5 23064 s*/
    
    @auraenabled
    public static String getvalidExotelProduct(){
        return SALMobilityPOCntrl_V2.getvalidExotelProduct();
    }
    @auraenabled  
    public static String getApplicant(String frommobile,String tomobile,String oppId){
        Applicant__c appObj=[select id,loan_application__r.Product__c from Applicant__c where loan_application__c =:oppId limit 1];
        return callToCustomer( frommobile, tomobile,appObj.id,'Applicant__c',appObj.loan_application__r.Product__c);
   //   return 'null';
    }
    
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
        return CommonUtility.callToCustomer(frommobile,tomobile,commObj,Product);
        
    } 
   
    public static String callToCustomerCallback(sObject commObj){
       
        return CommonUtility.callToCustomerCallback(commObj);
      
    } 
     /*Sprint 5 23064 e*/
    @auraenabled
    public static user fetchUser(){
        return SALMobilityPOCntrl_V2.fetchUser();
    }
     @AuraEnabled
    public static void changeOwnerFunction(String productofferid) {
          SALMobilityPOCntrl_V2.changeOwnerFunction(productofferid);
        }
    
    @AuraEnabled
    public static void assignToTelecaller(String productofferid) {
           SALMobilityPOCntrl_V2.assignToTelecaller(productofferid);
     }
       //Rohit submit to credit start
    public class SelectOption {
        @AuraEnabled
        public String label { get;set; }
        @AuraEnabled
        public String value { get;set; }
        public SelectOption(String value, String label) {
            this.value = value;
            this.label = label;
        }
        
        @AuraEnabled
        public CIBIL_secondary_match__c secondary{get; set;}
        @AuraEnabled
        public boolean oneInitiated{get; set;}
        @AuraEnabled
        public boolean twoInitiated{get; set;}
        @AuraEnabled
        public boolean threeInitiated{get; set;}
        @AuraEnabled
        public boolean fourInitiated{get; set;}
        @AuraEnabled
        public List<Cibil_Temp__c> cibilTempLst{get;set;}
        public SelectOption(CIBIL_secondary_match__c secondary, boolean oneInitiated, boolean twoInitiated,boolean threeInitiated,boolean fourInitiated,List<Cibil_Temp__c> cibilTempLst) {
            this.secondary = secondary;
            this.oneInitiated = oneInitiated;
            this.twoInitiated = twoInitiated;
            this.threeInitiated = threeInitiated;
            this.fourInitiated = fourInitiated;
            this.cibilTempLst = cibilTempLst;
        }
    }
    
    @AuraEnabled
    public static String getSelectCreditOfficer(string loanApplicationId) {
        return SALMobilityOppCntrl_V2.selectCreditOfficer(loanApplicationId);
      // return null;
        
    }
    @AuraEnabled
    public static List<SALMobilityCntrl_V2.SelectOption> getCreditOfficerLimit(string loanApplicationId) {
       return SALMobilityOppCntrl_V2.getCreditOfficerPicklist(loanApplicationId);
     //return null;
        
    }
    @AuraEnabled
    public static void getFetchApplicant(string loanApplicationId, String priApp, string StrAppr1) {
        system.debug('loanApplicationId'+loanApplicationId);
        SALMobilityOppCntrl_V2.fetchApplicant(loanApplicationId,priApp,StrAppr1);
        
    }
    //Rohit submit to credit stop  
    
    
   
    @AuraEnabled 
    public static String getCam_ApplicantMethod(String myid,String objectFieldJSON)
    {
        return  SALMobilityOppCntrl_V2.getCam_Applicant(myid,objectFieldJSON);
    }
      @AuraEnabled 
    public static String checkAllSolPoliciesMethod(String oppId,String objectFieldJSON){
        System.debug('ID IS '+oppId);
        return SALMobilityOppCntrl_V2.checkAllSolPolicies(oppId,objectFieldJSON);
        
    }      
    @AuraEnabled 
    public static String fetchPicklistDataMethod(List<String> fieldList){
        return  SALMobilityOppCntrl_V2.fetchPicklistData(fieldList);
        
    }
    @AuraEnabled 
    public static Applicant__c loadApplicantMethod(String myid) {
        return SALMobilityOppCntrl_V2.loadApplicant(myid);
    }
    @AuraEnabled 
    public static CAM__c loadAverageMethod(String myid) {
        return  SALMobilityOppCntrl_V2.loadAverage(myid);
        
    }
    /*
      @AuraEnabled 
    public static void saveIncomeDetailsMethod( String newCam,String newApplicant,String myid) {
        SALMobilityOppCntrl_V2.saveIncomeDetails(newCam,newApplicant,myid);
        
    }*/
     
      @AuraEnabled 
    public static String saveIncomeDetailsMethod(String newCam,String newApplicant,String myid) {
        return SALMobilityOppCntrl_V2.saveIncomeDetails(newCam,newApplicant,myid);
        
    }
    
    @AuraEnabled 
    public static String callPANBRE(String acc,String con,String loanobj,String appObj1) {
        return SALMobilityOppCntrl_V2.callPANBRE(acc,con,loanobj,appObj1);
        
    }
    @AuraEnabled 
    public static String callPANBreOnDocument(String accObj,String conObj,String oppObj,String appObj ,String loanId) {
        return SALMobilityOppCntrl_V2.callPANBreOnDocument(accObj,conObj,oppObj,appObj,loanId);
        //return null;
        
    }
    @AuraEnabled 
    public static String callPANBreOnDemographic(String accObj,String conObj,String oppObj,String appObj ,String loanId) {
        return SALMobilityOppCntrl_V2.callPANBreOnDemographic(accObj,conObj,oppObj,appObj,loanId);
        //return null;
        
    }
     @AuraEnabled 
    public static String callPANBreOnCKYC(String accObj,String conObj,String oppObj,String appObj ,String loanId) {
        return SALMobilityOppCntrl_V2.callPANBreOnCKYC(accObj,conObj,oppObj,appObj,loanId);
        
        
    }
    @ AuraEnabled
        public static Boolean CheckUserId(String created_date1){
            System.debug('inside controller'+created_date1);
            return null;//autoCompleteController.checkSALMobilityUsernames(created_date1);
        }
    
    @AuraEnabled
    public static void retriggerDedupeMethod(String oppId)
    {
        SALMobilityOppCntrl_V2.retriggerDedupe(oppId);
    }
    
    @AuraEnabled
    public static List<String> updateSolPolicies(List<String> itemlist,String oppId)
    {
     return SALMobilityOppCntrl_V2.updatePolicy(itemlist,oppId);
    }
    @ AuraEnabled
    public static String doEPFOChecks(String accObj, String oppObj, String cont){
        return SALMobilityOppCntrl_V2.doEPFOChecks(accObj, oppObj, cont);
    }
    @ AuraEnabled
        public static List<SALMobilityOppCntrl_V2.SOLDependentList> getDispositionforSOL(String fldDisposition, String controllingField, String dependentField){
            return SALMobilityOppCntrl_V2.getDisposition(fldDisposition,controllingField,dependentField);
        }
    
    @ AuraEnabled
        public static String verifyOtp(String contObj, String applicantObj, String otpValue){
            System.debug('contObj--->'+contObj);
            System.debug('applicantObj-->'+applicantObj);
            return SALMobilityOppCntrl_V2.verifyOtp(contObj, applicantObj, otpValue);
        }
    @ AuraEnabled
        public static String doEmploymentChecks(String accObj, String oppObj, String cont){
            return SALMobilityOppCntrl_V2.doEmploymentChecks(accObj, oppObj, cont);
        }
    
        @ AuraEnabled
        public static String getCardData(String oppId,string objectFieldJSON){
            return SALMobilityOppCntrl_V2.getCardData(oppId,objectFieldJSON);
        }
    @ AuraEnabled
        public static String saveOfferInhanced(String accJSON){
            return SALMobilityOppCntrl_V2.saveOfferInhanced(accJSON);
            
        }
    @ AuraEnabled
        public static List<Area_Locality__c> fetchArea(String searchKeyWord,String pincode){
            System.debug('Pincode is '+pincode);
        List<Area_Locality__c> arealiclist = new List<Area_locality__c>();
        if(!CommonUtility.isEmpty(pincode))
        arealiclist  = [SELECT id, Name FROM Area_Locality__c WHERE Name LIKE: (searchKeyWord + '%') and Pincode__c =: Integer.valueof(pincode)];
           // return [SELECT id, Name FROM Area_Locality__c WHERE Name LIKE: (searchKeyWord + '%') and Pincode__c =: Integer.valueof(pincode.trim())];
        System.debug('area locality pk'+arealiclist +pincode);
       return arealiclist;
        }
    
   @AuraEnabled
    public static string generateChecklistDoc(String oppId,Boolean bothDeviDocFlag)
    {
        system.debug('in deviationdoc');
       return SALMobilityOppCntrl_V2.callDeviationAPI(oppId,bothDeviDocFlag);
      //  return null;
    }
    @AuraEnabled
    public static string getDocOnLoad(String Oppobj)
    {
        return SALMobilityOppCntrl_V2.createChecklist(Oppobj);
    }
    @AuraEnabled
    public static string savedocuments(String oppId, string standardDoc , string deviationDoc)
    {
        return SALMobilityOppCntrl_V2.saveChecklistdocuments(oppId,standardDoc,deviationDoc);
    }
    @AuraEnabled
    public static String retAllApps(Id recordId){
        return SALMobilityOppCntrl_V2.retApplicantsData(recordId);
    }
    @AuraEnabled
    public static String saveDeviation(Id devSelected,String oppObj,String appObj){
        return SALMobilityOppCntrl_V2.saveDeviationRec(devSelected,oppObj,appObj);
    }
    @AuraEnabled
    public static String saveManDev(String deviationList){
        return SALMobilityOppCntrl_V2.saveManDev(deviationList);
    }
    @AuraEnabled
    public static String saveAutoDev(String deviationList){
        return SALMobilityOppCntrl_V2.saveAutoDev(deviationList);
    }
    @AuraEnabled
    public static String updateApplicantsData(String accObj,String conObj,String appObj,String oppObj,String ekycObj){
        system.debug('inside'+ekycObj);
        Account accOb = (Account)JSON.deserialize(accObj,Account.class);
        Contact conOb = (Contact)JSON.deserialize(conObj,Contact.class);
        Applicant__c appOb = (Applicant__c)JSON.deserialize(appObj,Applicant__c.class);
        Opportunity oppOb = (Opportunity)JSON.deserialize(oppObj,Opportunity.class);
        eKYC__c ekycOb = (eKYC__c)JSON.deserialize(ekycObj,eKYC__c.class);
        return SALMobilityOppCntrl_V2.updateAppDetails(accOb,conOb,appOb,oppOb,ekycOb);
    }
    @AuraEnabled
    public static String getCoApplicants(String loanId, String appId,String objectFieldJSON){
        return SALMobilityOppCntrl_V2.getCoApplicantData(appId,loanId,objectFieldJSON);
    }
    @AuraEnabled
    public static List<Applicant__c> delCoApp(Id recordId,String oppId){
        List<Applicant__c> appList = [select Financial_Health_Check_Guide__c,Elite_Card__c,Cibil_Retrigger_Initiated__c,Company_Name_as_per_Domain_check__c,Domain_Email_Remark__c,PANBREDone__c,/*Ekyc Start */Consent_on_app_form__c,eKYC_Processing__c,HashCode__c,/*Ekyc stop */id,Risk_Segmentation__c,Contact_Name__r.Years_At_Residence__c, Contact_Name__r.office_no_check_on_company_site__c, Contact_Name__r.SFDC_Dedupe_check__c, Contact_Name__r.PAN_Response__c, Contact_Name__r.Linkedin_check_result__c, Contact_Name__r.Google_check_result__c, Contact_Name__r.PAN__c, Contact_Name__r.Last_Modified_Date__c, Contact_Name__r.Name_of_the_PAN_holder__c, Contact_Name__r.Employer__r.Domain_Name__c, Contact_Name__r.Employer__r.Company_Category__c, Existing_Customer__c, Owned_Residence__c, Is_spouse_Working_Financial_CoApp__c, Loan_Application__r.Scheme_Master__c, Name, Contact_Name__r.Mobile__c, Loan_Application__r.Requested_ROI__c, Loan_Application__r.Sourcing_Channel__r.branch__c, Loan_Application__r.Referral__c, Loan_Application__r.Existing_Customer__c, Loan_Application__r.Account.Sourcing_Channel__r.branch__c, Update_CIBIL_Error__c, Descriptin__c, Type_of_Borrower__c, Re_Initiate_De_Dupe__c, Integrate_with_CIBIL__c, Contact_Name__c, Contact_Name__r.Name, Contact_Name__r.Customer_Profile__c,
                                          Contact_Name__r.Designation__c,Codified_CIBIL__c, Contact_Name__r.Employer_Name__c, Contact_Name__r.Qualification__c, Contact_Name__r.Address_1__c, Contact_Name__r.Total_Work_Experience_Yrs__c, Contact_Name__r.Current_experiance_in_Years__c,
                                          DPD_cluster_Segment__c,PD_Status__c, Bank_Status__c, FINANCIAL_VERIFICATION__c, Contact_Name__r.Address_2__c, FCU_Status__c, ITR_Status__c, Office_SE_Status__c, Office_SAL_Status__c, Contact_Name__r.Company_Category__c,
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
                                          Loan_Application__r.Product__c, Loan_Application__r.Account.Sourcing_Channel__c, Loan_Application__r.Account.Tenor__c, Loan_Application__r.Account.Referral_Name__c, Permanent_Address_Verification__c, Bureau_Segment__c,
                                          Loan_Application__r.Employee_Type__c, Loan_Application__r.Loan_Application_Number__c, Loan_Application__r.Loan_Amount__c, Loan_Application__r.Tenor__c, Contact_Name__r.Customer_Add_Matches_With_Previous_Add__c,
                                          Tele_PD__c, Physical_PD__c, CLINIC_HOSPITAL__c, PAN_Number__c, Employer_Check__c, PAN_Check__c ,Dedupe_Linking_Done__c,Reject_Reason__c,
                                          //DG: Automated Verification Enhancement: Added Cibil sub query
                                          (SELECT Address_Line2__c, Address_Line2_of_c3__c , Address_Line2_of_c4__c, Address_Line3__c, Date_Opened__c,Suit_Filed_Status__c,Suit_Filed_Status1__c,Suit_Filed_Status2__c,Suit_Filed_Status3__c,Suit_Filed_Status4__c,Suit_Filed_Status5__c,Suit_Filed_Status6__c,Suit_Filed_Status7__c,Suit_Filed_Status8__c,Suit_Filed_Status9__c,Suit_Filed_Status10__c,Suit_Filed_Status11__c,Suit_Filed_Status12__c,Suit_Filed_Status13__c,Suit_Filed_Status14__c,Suit_Filed_Status15__c,Suit_Filed_Status16__c,Suit_Filed_Status17__c,Suit_Filed_Status18__c,Suit_Filed_Status19__c FROM CIBILs__r), 
                                          (SELECT id,Date_Reported1__c,Date_Reported2__c,Date_Reported3__c,Date_Reported4__c,Suit_Filed_Status20__c,Suit_Filed_Status21__c,Suit_Filed_Status22__c,Suit_Filed_Status23__c,Suit_Filed_Status24__c,Suit_Filed_Status25__c,Suit_Filed_Status26__c,Suit_Filed_Status27__c,Suit_Filed_Status28__c,Suit_Filed_Status29__c,X90_DPD_6_months__c, Asset_classification_view__c, X30_DPD_CC__c, DPD_CC__c,X30_DPD_Gold_Loan__c, Total_current_outstanding__c, Suit_Filed__c, Settlement_Status__c, written_off_settled_status__c FROM CIBIL_Extension__r),(SELECT id,DPD_cluster_Segment__c FROM Cibil_Temps__r),(select Applicant__r.name,applicant__r.Contact_Name__r.name, id,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       Address_Line1__c,Address_Line2__c, Address_Line3__c, Address_Line4__c 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       ,State1__c, State2__c, State3__c, State4__c
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       ,Pin_Code1__c, Pin_Code2__c, Pin_Code3__c, Pin_Code4__c,initiatedFor__c, Cibil_Temp__r.CIBIL_Score__c, SecondaryMatch_Record__c  
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       from  CIBIL_secondary_match__r where CIBIL__r.CIBIL_Extension__r.Cibil_Temp__r.SecondaryMatch_Record__c != true and CIBIL__c != null ORDER BY CreatedDate desc),(SELECT id,X30_DPD_6_months__c,No_of_Live_PL__c,No_of_PL_Enq_in_Last_6_Months__c ,No_of_PL_Enq_in_Last_12_Months__c,Sum_of_Amount_Overdue__c FROM Cibil_Extension1s__r)  
                                          //Added RSA related Fields By Rajendra for bug id 11714
                                          ,RSA_flag__c,RSA_Loan_application_status__c,RSA_Remarks__c,Degree_Status__c,Khata_Certificate_Status__c,
                                          Plan_Status__c,Commencement_Certificate_Status__c,Address_Proof_Status__c,Shop_Act_License_Status__c,Occupation_Certificate_Status__c,Property_Tax_Receipt_Status__c,Verification_ID_Proof_Status__c,Vehicle_Registration_number__c,Vehicle_Registration_date__c,CKYC_No__c,Identity_Document_No__c,Identity_Document_Expiry_Date__c,Proof_of_Address_Submitted_for_Permanent__c,Proof_of_Identity__c,DeDupe_Counter__c, movedToCibilTemp__c,Drop_Line_Flexi_Period__c,Office_Email_Id_Verified__c,Domain_Check_Result__c,IP_Address_Timestamp__c
                                          from Applicant__c where Loan_Application__c =: oppId];
        return SALMobilityOppCntrl_V2.delCoApplicant(recordId,appList );
    }
    
    @AuraEnabled
    public static String getOppDetails(String loanApplicationId,String objectFieldJSON){
       return SALMobilityOppCntrl_V2.getOppDetails(loanApplicationId,objectFieldJSON);
       //return null;
    }
    @AuraEnabled
    public static String getDedupeOppDetails(String LANnumber){
        return SALMobilityOppCntrl_V2.getOppBasedOnLAN(LANnumber);
    }
     @AuraEnabled
    public static String getDedupeOppDetailsforLAN(String LANnumber){
        return SALMobilityOppCntrl_V2.getOppBasedOnLAN(LANnumber);
    }
    @AuraEnabled
    public static String getUWOppDetails(String loanApplicationId){
        return SALMobilityOppCntrl_V2.getUWOppDetails(loanApplicationId);
    }
     @AuraEnabled
    public static String saveContactRecord(String jsonContactRecord, String jsonAccountRecord ,String loanApplicationId,String jsonpaddresspolicy){
            
       return SALMobilityOppCntrl_V2.saveContactRecord(jsonContactRecord, jsonAccountRecord, loanApplicationId,jsonpaddresspolicy);
      // return null;
    }
    
    @ AuraEnabled
        public static String getCkycDetails(String oppID,string objectFieldJSON) {
            return SALMobilityOppCntrl_V2.getCkycDetails(oppID,objectFieldJSON);
        }
        @ AuraEnabled
        public static String getDedupeDetails(String oppID,string objectFieldJSON) {
            return SALMobilityOppCntrl_V2.getDedupeDetails(oppID,objectFieldJSON);
        }
        @AuraEnabled
    public static string saveDedupeRecords(String oppId, string dedupeRecs)
    {
        return SALMobilityOppCntrl_V2.saveDedupeRecords(oppId,dedupeRecs);
    }
    @ AuraEnabled
        public static String getDashboardDetails(String oppID,string objectFieldJSON) {
            return SALMobilityOppCntrl_V2.getDashboardDetails(oppID,objectFieldJSON);
        }
    
    @ AuraEnabled
        public static String updateCKYCDetails(String jsoncontactObj, String jsonaccountObj, String jsonappObj, String oppObj,Boolean copyresiaddress) {
            System.debug('inside updateCKYCDetails');
            return SALMobilityOppCntrl_V2.updateCKYCDetails(jsoncontactObj,jsonaccountObj,jsonappObj,oppObj,copyresiaddress);
        }
    @ AuraEnabled
        public static Applicant__c reInitiateCib(string recId) {
            system.debug('recId'+recId);
            Set<Id> idSet = new Set<Id>();
            idSet.add(recId);
            if(idSet.size() > 0){
                CibilService.isMobility = true;
                Applicant__c appObj = GeneralUtilities.initiateCibilForApplicant(idSet,true);
                return appObj;
            }
            return null;
        }
    
    @ AuraEnabled
        public static String fetchPerfiosBankAccount(String fetchLoanApplicationId) {
            return SALMobilityOppCntrl_V2.fetchPerfiosBankAccount(fetchLoanApplicationId);
        }
    @AuraEnabled
    public static String callBREverification(string oppId){
        return SALMobilityOppCntrl_V2.callVerificationAPI(oppId);
    }
    
    //Rohit mobility Employment start
    @AuraEnabled
    public static String saveEmpDetails(Map<String,String> params){
        Map<String,Object> saveResp = new Map<String,Object>();
        List<Opportunity> oppList;
        Opportunity opp;
        if(params.get('empOpp') != null)
            oppList = (List<Opportunity>)JSON.deserialize(params.get('empOpp'),List<Opportunity>.class);
        if(oppList != null && oppList.size() > 0)
        {
            opp= oppList[0];
        }
        try{
        Contact con;
        LIst<Contact> conList = (List<Contact>)JSON.deserialize(params.get('empContact'),LIst<Contact>.class);
        
        if(conList != null && conList.size()>0)
            con= conLIst[0]; 
        //Commented for City CR
        /*if (!CommonUtility.isEmpty(con.Office_Pin_Code__c)) {
            String City = SOLDynamicController.getCityFromPincode(con.Office_Pin_Code__c);
            
            if(CommonUtility.isEmpty(City) || CommonUtility.isEmpty(SOLDynamicController.fetchStateRemote(City))){
                system.debug('in city fail');
                saveResp.put('status','City Fail');    
                return JSON.serialize(saveResp);
            } 
              
            system.debug('contactObj.Office_City__c ' + con.Office_City__c);
            system.debug('contactObj.Office_State__c ' + con.Office_State__c);
        }*/
        SALMobilityOppCntrl_V2.Oppdata mcpResp = SALMobilityOppCntrl_V2.callMcp(params);
        String saveResult =SALMobilityOppCntrl_V2.saveEmploymentDetails(params);
        
        //Map<String,Object> mcpResp = (Map<String,Object>)JSON.deserializeUntyped(mcpResult);
        saveResp = (Map<String,Object>)JSON.deserializeUntyped(saveResult);
        String stage_name = opp.StageName;
        system.debug('saveResp'+saveResp);
        System.debug('robin '+mcpResp.status);
        if(((String)mcpResp.status) == 'Success' &&  ((String)saveResp.get('status')) == 'Success'){
            opp.StageName = stage_name;
            update opp;
            saveResp.put('opp',opp);
            return JSON.serialize(saveResp);
        }
        else if(((String)mcpResp.status) == 'MCP check failed'){
            saveResp.put('status','MCP FAIL');
            
            opp.StageName = 'MCP Reject';
            update opp;
            saveResp.put('opp',opp);
            return JSON.serialize(saveResp);
        }
        else if(((String)saveResp.get('status')) == 'City Fail'){
            saveResp.put('status','City Fail');    
            return JSON.serialize(saveResp);
        }
        saveResp.put('status','Internal Server error , Please try again later !');
        }
        catch(Exception e){
            system.debug('Exception---'+e.getMessage()+e.getLineNumber());
        }
        return JSON.serialize(saveResp);
    }
    
    @AuraEnabled
    public static String callMCPMobility(Map<String,String> params){
        return JSON.serialize(SALMobilityOppCntrl_V2.callMCP(params));    
        //return null;
    }
    //Rohit mobility Employment stop
    @AuraEnabled
    public static Opportunity salesReject(String jsonoppObj){
        return SALMobilityOppCntrl_V2.salesReject(jsonoppObj);
    }
     
    @AuraEnabled
    public static String saveLoanApplicationDummy(String loan,String acc,String con,String appObj,String policylst,String ekycObj,String tatMasterRecord){
        system.debug('ekyc'+tatMasterRecord);
        return SALMobilityOppCntrl_V2.saveLoanApplication(loan,acc,con,appObj,policylst,ekycObj,tatMasterRecord);
        //return null;
    }
    @AuraEnabled 
    public static List<Opportunity> getOppList() {
//Added Product__c in query for bug 23064        
List<Opportunity> oppList = [SELECT Id,Product__c,Loan_Amount__c,StageName,Loan_Application_Number__c,Name,Mobile__c,Application_Source__c from Opportunity where Relationship_Manager__c =: Userinfo.getUserId() AND CreatedDate = LAST_N_DAYS:30]; //added AND condition for 2.0 CR
        return oppList;
        //return null; 
    }
    @AuraEnabled 
    public static String PANCheck(String panNumber, String product , String oppId,String acc,String con) {
        return SALMobilityOppCntrl_V2.PANCheck(panNumber,product,oppId,acc,con,false);
        //return null; 
    }
    
    @AuraEnabled 
    public static List<String> PANCheckCoApp1(String PanNumber, String ProductName) {
                System.debug('First Check rc'+PanNumber);

        return SALMobilityOppCntrl_V2.PANCheckCoApp(PanNumber,ProductName);
    }
    @AuraEnabled 
    public static String fetchPicklistData(List<String> fieldList){
        Account acc = new Account();
        Map<String,List<String>> valuesMap = new Map<String,List<String>>();
        
        List<String> picValues = new List<String>();
        for(String str : fieldList){
            picValues = SALMobilityOppCntrl_V2.getselectOptions(acc,str);
            if(picValues != null)
                valuesMap.put(str,picValues);   
        }
        SYstem.debug('rohit '+valuesMap);
        return JSON.serialize(valuesMap);       
        
    }
    //Rohit mobility Employment end
    
    @AuraEnabled
    public static String upsertPerfiosBankAccount(String loanId,String JSONBankAccountLst){
        return SALMobilityOppCntrl_V2.upsertPerfiosBankAccount(loanId,JSONBankAccountLst);
    }
    @AuraEnabled
    public static ListView getLoanApplicationListViews() 
    {
        ListView listviews = [SELECT Id, Name 
                              FROM ListView 
                              WHERE SobjectType = 'Opportunity'
                              AND Id = '00B90000001PLctEAG' 
                              LIMIT 1];
        //AND Name = 'Recently Viewed Loan Applications'
        system.debug('listviews++'+listviews.Id+' '+listviews);
        return listviews;
    }
    //Rohit mobility v2 - MCP  start
    @AuraEnabled
    public static String callMCPforDOB(Map<String,String> params){
        return JSON.serialize(SALMobilityOppCntrl_V2.callMCP(params));
        //return null;
    }
    //Rohit mobility v2 - MCP  stop 
    //Rohit Ekyc start
    @AuraEnabled
    public static String saveEkycForOpp(Map<String,String> params){
        return SALMobilityOppCntrl_V2.saveEkycOpp(params);
    }
    
    @AuraEnabled
    public static String fetchEkycRec(String parentId){
        return SALMobilityOppCntrl_V2.fetchEkyc(parentId);
    }
    //Rohit Ekyc stop
    @AuraEnabled public static String getOpportunityData(String oppId , String objectFieldJSON) {
        return SALMobilityOppCntrl_V2.getOpportunity(oppId,objectFieldJSON);
    }
    @AuraEnabled 
    public static String getPOSData(String oppId,String objectFieldJSON){
        system.debug('oppId'+oppId);
        return SALMobilityOppCntrl_V2.getPOSData(oppId,objectFieldJSON);
    }
    @AuraEnabled 
    public static String fetchPOSTU(String oppObj,String posObj,String posList){
        TelePDQuestionMaster__c posOb = (TelePDQuestionMaster__c)JSON.deserialize(posObj,TelePDQuestionMaster__c.class);
        Opportunity oppOb = (Opportunity)JSON.deserialize(oppObj,Opportunity.class);
        List<TelePDQuestionMaster__c> posListt = (List<TelePDQuestionMaster__c>)JSON.deserialize(posList,List<TelePDQuestionMaster__c>.class);
        return SALMobilityOppCntrl_V2.fetchPOS(oppOb,posOb,posListt);
    }
    @AuraEnabled 
    public static String savePOSDataTU(String oppObj,String posObj,String posList,String accJSON){
        Opportunity oppOb = (Opportunity)JSON.deserialize(oppObj,Opportunity.class);
        TelePDQuestionMaster__c posOb = (TelePDQuestionMaster__c)JSON.deserialize(posObj,TelePDQuestionMaster__c.class);
        List<TelePDQuestionMaster__c> posListt = (List<TelePDQuestionMaster__c>)JSON.deserialize(posList,List<TelePDQuestionMaster__c>.class);
        return SALMobilityOppCntrl_V2.saveDataTU(oppOb,posOb,posListt,accJSON);
    }   
    @AuraEnabled 
    public static String savePOSDataBT(String oppObj,String posObj,String posList,String accJSON){
        Opportunity oppOb = (Opportunity)JSON.deserialize(oppObj,Opportunity.class);
        TelePDQuestionMaster__c posOb = (TelePDQuestionMaster__c)JSON.deserialize(posObj,TelePDQuestionMaster__c.class);
        List<TelePDQuestionMaster__c> posListt = (List<TelePDQuestionMaster__c>)JSON.deserialize(posList,List<TelePDQuestionMaster__c>.class);
        return SALMobilityOppCntrl_V2.saveDataBT(oppOb,posOb,posListt,accJSON);
    }   
    @AuraEnabled 
    public static String delposList(String oppObj,String recordId,String posListTU){
        Opportunity oppOb = (Opportunity)JSON.deserialize(oppObj,Opportunity.class);
        List<TelePDQuestionMaster__c> posListt = (List<TelePDQuestionMaster__c>)JSON.deserialize(posListTU,List<TelePDQuestionMaster__c>.class);
        return SALMobilityOppCntrl_V2.delposListTU(oppOb,recordId,posListt);
    }
    
    @AuraEnabled 
    public static String savePOSDataOth(String oppObj,String posObj,String posList,String accJSON){
        Opportunity oppOb = (Opportunity)JSON.deserialize(oppObj,Opportunity.class);
        TelePDQuestionMaster__c posOb = (TelePDQuestionMaster__c)JSON.deserialize(posObj,TelePDQuestionMaster__c.class);
        List<TelePDQuestionMaster__c> posListt = (List<TelePDQuestionMaster__c>)JSON.deserialize(posList,List<TelePDQuestionMaster__c>.class);
        return SALMobilityOppCntrl_V2.saveDataOther(oppOb,posOb,posListt,accJSON);
    }  
   
    

    @AuraEnabled
    public static String getOfferDetails(String oppObj, String accObj, String appObj, String conObj){
        system.debug('oppObj'+oppObj+'-------'+accObj+'-----'+appObj);
        Account accOb = (Account)JSON.deserialize(accObj,Account.class);
        Contact conOb = (Contact)JSON.deserialize(conObj,Contact.class);
        Applicant__c appOb = (Applicant__c)JSON.deserialize(appObj,Applicant__c.class);
        Opportunity oppOb = (Opportunity)JSON.deserialize(oppObj,Opportunity.class);
        return SALMobilityOppCntrl_V2.getOfferDetails(oppOb,accOb,appOb,conOb);
    }

    
    @AuraEnabled
    public static String getOppLandingDetails(String oppId){
        return SALMobilityOppCntrl_V2.getOppLandingDetails(oppId);
    }
     @ AuraEnabled
    public static CAM__c updateCam(String camObj,String accObj,String appObj) {//change parameters for 22017
       return SALMobilityOppCntrl_V2.updateCam(camObj,accObj,appObj);
      // return null;
     }
         @ AuraEnabled
         public static String updateCamAndOpp(String camObj,String oppObj) {
                 return SALMobilityOppCntrl_V2.updateCamAndOppMethod(camObj,oppObj);
         }

      @ AuraEnabled
    public static String callEligibiltySegmentation(String oppId, String camObj) {
        System.debug('oppId'+oppId);
        return OpportunityMobilityUtility.callEligibiltySegmentation(oppId, camObj);
    }
    
    //Rohit added for submit to sales start
    //2.0 CR's
    @AuraEnabled
    public static String sendToSalesOpp(String loanId){
        //SAL 2.0 CR's added Account.Pin_Code__c
        List<Opportunity> oppList =[SELECT Branch_Name__r.name,Product__c,Account.PinCode__c,Id,Sourcing_Channel__r.Id,Sourcing_Channel__r.Reporting_Manager__c FROM Opportunity WHERE Id=:loanId];
        
        if(oppList != null && oppLIst.size()>0){
        
            Opportunity loan = oppList[0];
            return SALMobilityOppCntrl_V2.sendToSales(Loan);
                }
        return 'Failure';
    }
    
    //Rohit added for submit to sales stop
    
   //save cam start
    @AuraEnabled
    public static String saveCamDetails(Map<String,String> params){
      return SALMobilityOppCntrl_V2.saveCamDetails(params);
    }
    //save cam stop
    
    public static List<CIBIL_secondary_match__c> getSecondary(String oppId)
    {
        List<Applicant__c> allApp = new List<Applicant__c>();
        allApp = [SELECT eKYC_Processing__c,id,Proof_of_Residence_Address_Submitted__c,Proof_of_Registered_Address_Submitted__c,Proof_of_Address_Submitted_for_Permanent__c,Company_Name__c,Type_of_Borrower__c,Company_Type__c,Customer_Name__c, DeDupe_Counter__c, movedToCibilTemp__c, Contact_Name__c, Contact_Name__r.id,Refferal_Identifier__c,Subscribed_to_Credit_Vidya__c,Financial_Health_Check_Guide__c,ROI_PO__c,Pure_Flexi_Period__c,Pure_Flexi_EMI__c,Drop_Line_Flexi_Period__c,Vehicle_Registration_number__c,Vehicle_Registration_date__c,CKYC_No__c,Identity_Document_No__c,Identity_Document_Expiry_Date__c,Proof_of_Identity__c,Contact_Name__r.Pin_Code__c,Contact_Name__r.Address_1__c,Contact_Name__r.Address_2__c,Contact_Name__r.Address_3__c,Contact_Name__r.Name,Contact_Name__r.Mobile__c,Applicant_Type__c,Customer_ID__c,Contact_name__r.Date_of_Birth__c,Contact_Name__r.PAN_Number__c FROM Applicant__c where Loan_Application__c =:oppId];
        system.debug('allApp++'+allApp);
        Set<Id> setApplicantIds = new Set<Id>();
        for(Applicant__c app : allApp){
            setApplicantIds.add(app.Id);
        }
        system.debug('setApplicantIds++'+setApplicantIds);    
        List<CIBIL_secondary_match__c> secondryCIBILS = new List<CIBIL_secondary_match__c>();
        secondryCIBILS = [SELECT Applicant__r.name,applicant__r.Contact_Name__r.name, id, Address_Line1__c,Address_Line2__c, Address_Line3__c, Address_Line4__c, 
                         State1__c, State2__c, State3__c, State4__c,Pin_Code1__c, Pin_Code2__c, Pin_Code3__c, Pin_Code4__c,initiatedFor__c, Cibil_Temp__r.CIBIL_Score__c, SecondaryMatch_Record__c  
                         FROM CIBIL_secondary_match__c 
                         WHERE Applicant__c IN: setApplicantIds
                         //AND CIBIL__r.CIBIL_Extension__r.Cibil_Temp__r.SecondaryMatch_Record__c != true 
                         //AND CIBIL__c != null 
                         ORDER BY CreatedDate DESC];
        system.debug('secondryCIBILS++'+secondryCIBILS);
        return secondryCIBILS;
    } 

    @AuraEnabled
    public static List<SelectOption> getSecondaryCIBILS(String oppId)
    {
        List<CIBIL_secondary_match__c> secondryCIBILS = getSecondary(oppId);
        system.debug('secondryCIBILS++'+secondryCIBILS);
        List<SelectOption> wrapper = new List<SelectOption>();
        Boolean oneInitiated;
        Boolean twoInitiated;
        Boolean threeInitiated;
        Boolean fourInitiated;
        for(CIBIL_secondary_match__c match : secondryCIBILS)
        {   
            if(match.initiatedFor__c != null)
            {
                if(match.initiatedFor__c.contains('1'))
                    oneInitiated = true;
                else
                    oneInitiated = false;
                    
                if(match.initiatedFor__c.contains('2'))
                    twoInitiated = true;
                else
                    twoInitiated = false;
                    
                if(match.initiatedFor__c.contains('3'))
                    threeInitiated = true;
                else
                    threeInitiated = false;
                    
                if(match.initiatedFor__c.contains('4'))
                    fourInitiated = true;
                else
                    fourInitiated = false;
            }
            else
            {
                oneInitiated = false;
                twoInitiated = false;
                threeInitiated = false;
                fourInitiated = false;
            }
            
            List<Cibil_Temp__c> cibilTempLst = getCibiltempList(match.Id);
            system.debug('cibilTempLst++'+cibilTempLst);
            wrapper.add(new SelectOption(match,oneInitiated, twoInitiated, threeInitiated, fourInitiated,cibilTempLst));
        }
        return wrapper; 
    }
    
    public static List<Cibil_Temp__c> getCibiltempList(String matchId)
    {
        List<Cibil_Temp__c> cibilLst = new List<Cibil_Temp__c>();
        //cibilLst = [SELECT Id,Fire_Date__c,CIBIL_Score__c,Initiated_for_address__c,Applicant__c,(SELECT Id FROM CIBILs__r LIMIT 1) FROM Cibil_Temp__c WHERE Secondary_CIBIL_Match__c = :matchId  AND Initiated_for_address__c IN (1,2,3,4)  ORDER BY Initiated_for_address__c LIMIT 4];
        cibilLst = [SELECT Id,Initiated_for_address__c,Fire_Date__c,CIBIL_Score__c FROM Cibil_Temp__c WHERE Secondary_CIBIL_Match__c = :matchId];
        system.debug('cibilLst ----->'+cibilLst);
        return cibilLst;
    } 
    
   
    
   
    @ AuraEnabled
    public static List<Map<String,Object>> fetchHVTDetails(String loanId){
      return SALMobilityOppCntrl_V2.fetchHVTDetails(loanId);
      //return null;
    }
    /* Bug : 17139 S */
    @AuraEnabled
    public static SALMobilityController.DetailsWrapperClass checkRedirectionValidity(String oppId, String flowName,string version)
    {
        return SALMobilityController.checkRedirectionValidity(oppId,flowName,version);
    }
    
    @AuraEnabled
    public static String getSanctionDetails(String oppId)
    {
        return SALMobilityPricingCntrl_V2.getSanctionDetailsMethod(oppId);
    }
    @AuraEnabled
    public static LIst<Discrepancy__c> saveSanctionDetailsMethod(String loanId,String JSONDiscrepancyList)
    {
       return SALMobilityPricingCntrl_V2.saveSanctionDetails(loanId,JSONDiscrepancyList);  
    }
    
    @ AuraEnabled
        public static List<Scheme_Master__c> fetchScheme(String searchKeyWord,string oppId){
            if(!commonutility.isEmpty(oppId)){
                List<opportunity>  oppList =  [select id,Branch_Name__c,Branch_Name__r.Market_Type__c from Opportunity where id =:oppId ];
                if(!commonutility.isEmpty(oppList) && !commonutility.isEmpty(oppList[0].Branch_Name__c))
                    return [SELECT id, Name FROM Scheme_Master__c WHERE Name LIKE: (searchKeyWord + '%') and Market_Type__c = :oppList[0].Branch_Name__r.Market_Type__c and Active__c = true];
            }
            return null;
        }
    @AuraEnabled
    public static string updateVerificationRecords(String oppId, string verifyRecs)
    {
        return SALMobilityOppCntrl_V2.updateVerificationRecord(oppId,verifyRecs);
    }
    @AuraEnabled
    public static string fireSALVerifications(String oppId, string verType)
    {
        return SALMobilityOppCntrl_V2.fireVerifications(oppId,verType);
    }
     //Rohit pancheck start
    public class PanCheckWrapper{
        @AuraEnabled 
        public String panType;
        @AuraEnabled 
        public String AppName;
        @AuraEnabled 
        public String panStatus;
        @AuraEnabled 
        public String panNumber;
        @AuraEnabled 
        public PanDetailsWrapper panDetails;
        @AuraEnabled
        public String panSeriesTrigger;
        @AuraEnabled
        public Boolean isPANCheckDone;
        @AuraEnabled
        public TAT_Master__c tatRec;
    }
    
    public class PanDetailsWrapper{
        @AuraEnabled 
        public String title;
        @AuraEnabled 
        public String Name;
        @AuraEnabled 
        public String status;
        @AuraEnabled 
        public String LastModification;
        
    }
    
    @AuraEnabled    
    public static String updateTatRec(String tatRec,String loanId){
        
        
        try{  
            if(!CommonUtility.isEmpty(tatRec)){
                system.debug('tatrec'+loanId);
                List<SALMobilityCntrl_V2.PanCheckWrapper> panWrapperList = new List<SALMobilityCntrl_V2.PanCheckWrapper>();
                panWrapperList = (List<SALMobilityCntrl_V2.PanCheckWrapper>) JSON.deserialize(tatRec, List<SALMobilityCntrl_V2.PanCheckWrapper>.class);
                List < TAT_Master__c  > tatListToUpdate = new List < TAT_Master__c  > ();
                for(SALMobilityCntrl_V2.PanCheckWrapper PANObj : panWrapperList){
                    if(!CommonUtility.isEmpty(PANObj.tatRec))
                        tatListToUpdate.add(PANObj.tatRec);
                }
                if(!CommonUtility.isEmpty(tatListToUpdate)){
                    update tatListToUpdate;
                    SOL_Policy__c policy = new SOL_Policy__c();
                    List<SOL_Policy__c> SOLPolicyList=[select id,Remarks__c,Disposition_Status__c,Old_Address_Value__c, Policy_Name__c,Checklist_Policy_Status__c from SOL_Policy__c where Loan_Application__c =: loanId AND (Policy_Name__c LIKE '%Primary Pan Check Pass%' OR Policy_Name__c LIKE '%Primary Pan Check Fail%') Limit 1];
                    if(SOLPolicyList != null && SOLPolicyList.size() > 0)
                    {
                        policy = SOLPolicyList[0];
                    }
                    String value = policy.Old_Address_Value__c;
                    if(value != null && value != ''){
                        if(tatListToUpdate[0].Credit_Observation__c == 'Relevant'){
                            if(value.contains('"pan_check_dashboard":"NOT CONFIRMED"'))
                                value = value.replace('"pan_check_dashboard":"NOT CONFIRMED"','"pan_check_dashboard":"SUCCESSFUL"');
                            else if(value.contains('"pan_check_dashboard":null'))
                                value = value.replace('"pan_check_dashboard":null','"pan_check_dashboard":"SUCCESSFUL"');
                            else if(value.contains('"pan_check_dashboard":""'))
                                value = value.replace('"pan_check_dashboard":""','"pan_check_dashboard":"SUCCESSFUL"');
                            
                            
                        }
                        else{
                            if(value.contains('"pan_check_dashboard":"SUCCESSFUL"'))
                                value = value.replace('"pan_check_dashboard":"SUCCESSFUL"','"pan_check_dashboard":"NOT CONFIRMED"');
                        }
                        policy.Old_Address_Value__c = value;
                            update policy;
                    }
                    if(policy.Old_Address_Value__c != null && policy.Old_Address_Value__c !='')   
                        return policy.Old_Address_Value__c;
                    else
                        return 'success';
                }
            }
        }catch(Exception ex){
            
            System.debug('Exception '+ex);
            return null;
        }
        return null;
    }
    //Rohit pancheck stop
    
    /** Aman Porwal - UW Landing - Start */
    @ AuraEnabled
        public static void retriggerCIBILOperation(String jsonOppRecord, String jsonConRecord, String jsonAppRecord)
    { 
        SALMobilityOppCntrl_V2.retriggerCIBILOperation(jsonOppRecord, jsonConRecord, jsonAppRecord);
    }
    /** Aman Porwal - UW Landing - End */
    
    /** Aman Porwal - UW Landing - Start */
    @ AuraEnabled
        public static void retriggerDedupeOperation(String jsonOppRecord, String jsonConRecord, String jsonAppRecord) 
    {
        SALMobilityOppCntrl_V2.retriggerDedupeOperation(jsonOppRecord, jsonConRecord, jsonAppRecord); 
    }
    /** Aman Porwal - UW Landing - End */
    
    @AuraEnabled
    public static String saveUWLandingPage(String accObj, String conObj,String oppObj,String oldemployername,String applicantId){
      return SALMobilityOppCntrl_V2.saveUWLandingPage(accObj, conObj,oppObj,oldemployername,applicantId);
    }
    
    @ AuraEnabled
    public static String approveloan(String loanid,String jsonoppobj){
    System.debug('inside parent loanid'+loanid);
      return SALMobilityOppCntrl_V2.approveloan(loanid,jsonoppobj);
     }
     @ AuraEnabled
    public static String sendBackToSales(String loanid,String jsonoppobj){
    System.debug('inside parent sendBackToSales loanid'+loanid);
      return SALMobilityOppCntrl_V2.sendBackToSales(loanid,jsonoppobj);
     }
     @ AuraEnabled
    public static String submitForRecommend(String loanid,String jsonoppobj,string SelCreditUser){
    System.debug('inside parent loanid'+loanid+'>>SelCreditUser>>'+SelCreditUser);
    return SALMobilityOppCntrl_V2.submitForRecommend(loanid,jsonoppobj,SelCreditUser);
     }
     @AuraEnabled
    public static String rejectloan(String loanid,String jsonoppobj){
    System.debug('inside parent loanid'+loanid);
        return SALMobilityOppCntrl_V2.rejectloan(loanid,jsonoppobj);
    }
    
     @AuraEnabled
    public static Personal_Discussion__c updatepdrecord(String jsonpdObj){
        return SALMobilityOppCntrl_V2.updatepdrecord(jsonpdObj);
    }
    @AuraEnabled
    public static string fetchEmpPicklistData(String PicklistJSON){
        return SALMobilityOppCntrl_V2.fetchEmpPicklistData(PicklistJSON);
    }
    @AuraEnabled
    public static String submitForPricingApp(String loanid,String jsonoppobj){
        System.debug('inside parent loanid'+loanid);
        return SALMobilityOppCntrl_V2.submitForPricing(loanid,jsonoppobj);
    }
    /* Bug : 17139 E */
    
    /* Bug : 17556 S  Pricing 
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
    public static String fetchRepaymentObject(String repayId){
        return SALMobilityPricingCntrl_V2.fetchRepaymentObject(repayId);
    }
     @AuraEnabled
    public static String fetchDisbursementObject(String disbId){
        System.debug('inside fetchDisbursementObject '+disbId);
        return SALMobilityPricingCntrl_V2.fetchDisbursementObject(disbId);
    }
    @AuraEnabled
    public static String sendMail(String opp, Decimal approvedROI ,Decimal proposedROI,Decimal  approvedPF,Decimal  proposedPF){
        return SALMobilityPricingCntrl_V2.sendMail(opp, approvedROI, proposedROI, approvedPF, proposedPF);
    }
    @AuraEnabled
    public static String approvePricing(String loan){
        System.debug('loan--->'+loan);
        return SALMobilityPricingCntrl_V2.approvePricing(loan);
    }
    */
    
    /*** 20391 start ***/
    @AuraEnabled
    public static String fetchData(Id loanAppId, String objectFieldJSON){
        System.debug('loanAppId--->'+loanAppId);
        return SALMobilityPricingCntrl_V2.fetchData(loanAppId, objectFieldJSON);
    }
    /*** 20391 end ***/
    
    /* Hrushikesh Pricing methods Start*/
    /*@AuraEnabled
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
        try
        {
            boolean PFApproved = false;
            boolean ROIApproved = false;
            parametersMap.put('ERROR_MSG_STRING', 'NO_ERROR');
            List<Opportunity> loanList = [SELECT Id, Product__c, Scheme_Master__r.flexi_flag__c, Scheme_Master__r.PLOC_scheme__c, Approved_Rate__c, 
                createddate, Loan_Application_Flow__c, Branch_Name__c, Branch_Name__r.name, Program_Type__c, Approver__c, ownerid, BranchName__c
                FROM Opportunity Where Id =: oppId];
            
            List<Applicant__c> applicantList = [SELECT Id, mail_to_Sales_Hierarchy__c, ROIFlexi__c, ROILoc__c, ROINormal__c, ROIApproveStatus__c, PFApproveStatus__c  
                FROM Applicant__c WHERE  Loan_Application__c =: oppId AND Applicant_Type__c = 'Primary'];             
                
            if(commonutility.isEmpty(applicantList[0].ROIApproveStatus__c))
                ROIApproved = true;
            else{
                if(!applicantList[0].ROIApproveStatus__c.contains('Pending'))
                {
                    ROIApproved = true;
                }
            }
    
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
                    if(PFApproved && ROIApproved){
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
                                    and Product__c = : Loan.Product__c and City__c INCLUDES(: Branch) 
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
    public static String getUploadVerification(String oppId)
    {
        return SALMobilityPricingCntrl_V2.getUploadVerification(oppId);
    }
    
    @AuraENabled
    public static void acceptOffer(String oppId)
    {
        SALMobilityPricingCntrl_V2.acceptOffer(oppId);
    }
    
     @AuraEnabled
    public static String sendToFinnOne(String oppId){
        PricingDisbmntDetails_Ctrl obj = new PricingDisbmntDetails_Ctrl(oppId);
        obj.senttoFinnone();
        system.debug(obj.mobilitystatus);
        return obj.mobilitystatus;
    }
    */
    
    @AuraEnabled
    public static String getDiscrepancyDetailsMethod(String myid,  String objectFieldJSON, String controllingField, String dependentField)
    {
        return SALMobilityPricingCntrl_V2.getDiscrepancyDetails(myid,objectFieldJSON,controllingField, dependentField);
    } 
    /*public class CurrentDisbDetailsWrapper {
        @AuraEnabled public Current_Disbursal_Details__c disbObj;
        @AuraEnabled public Boolean isTransactionalError;
        @AuraEnabled public Boolean isAPIError;
        @AuraEnabled public String errorMsg;
    }

        @AuraEnabled
    public static CurrentDisbDetailsWrapper invokeCheckIMPS(String cddObject){ 
       //  Current_Disbursal_Details__c currentDisbursalDetails) 
       System.debug('print object cdd  '+cddObject);
         Current_Disbursal_Details__c currentDisbursalDetails = (Current_Disbursal_Details__c)JSON.deserialize(cddObject,Current_Disbursal_Details__c.class);

        System.debug('currentDisbursalDetails -->' + currentDisbursalDetails);
        Current_Disbursal_Details__c disbObj = currentDisbursalDetails;//(Current_Disbursal_Details__c)JSON.deserialize(currentDisbursalDetails, Current_Disbursal_Details__c.class);
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
                    IMPSresponse = BRECallout.CallIMPSWebService(IMPSinput);
                    System.debug('IMPSresponse --> ' + IMPSresponse);

                    if(IMPSresponse != null && IMPSresponse.size() > 0) {
                        if((IMPSresponse.get('respCode') != null && ((new Set<String>(errorcodes)).Contains(IMPSresponse.get('respCode'))) )|| IMPSresponse.get('respDesc') == 'Internal Server Error') {
                            disbObj.IMPS_Transaction_No__c = IMPSresponse.get('traceNumber');
                            disbObj.IMPS_Result__c = IMPSresponse.get('respDesc');
                            disbObj.IMPSDateTime__c = IMPSresponse.get('dateTime'); 
                            disbObj.Favouring__c = IMPSresponse.get('beneName');
                            cddWrapper.errorMsg = 'Internal Server Error.';
                            cddWrapper.isAPIError = true;
                        } else if(IMPSresponse.get('respDesc') != null) {
                            disbObj.IMPS_Transaction_No__c = IMPSresponse.get('traceNumber');
                            disbObj.IMPS_Result__c = IMPSresponse.get('respDesc');
                            disbObj.IMPSDateTime__c = IMPSresponse.get('dateTime'); 
                            disbObj.Favouring__c = IMPSresponse.get('beneName');
                            cddWrapper.isTransactionalError = true;
                            if(IMPSresponse.get('respDesc') == 'Successful Transaction') {
                                disbObj.Successful_IMPS_Count__c++;
                                cddWrapper.errorMsg = 'Account Validated Succesfully,so no need to collect cancelled cheque.';
                                cddWrapper.isAPIError = false;
                                cddWrapper.isTransactionalError = false;
                            } else {
                                disbObj.Failure_IMPS_Count__c++;
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
        Map <String, String> chargesAPIResponse = breCallout.callCharegesAPIService(chargesValuesMap);
        system.debug('chargesAPIResponse =====>> '+chargesAPIResponse);
        if (chargesAPIResponse.get('result') == 'SUCCESS') 
        {
            return queryFeesNCharges(loanObject);
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
      // added for bug id 21851 start
    @AuraEnabled
    public static Boolean getHideAadhaarSection()
    {   
          return Boolean.valueOf(CommonUtility.getAadhaarSectionStatus('Ekyc_Integration','hideAadhaarSection',''));
    }
   //added for bug id 21851 stop
     //Referral Enhancement Start - Hrushikesh bug id : 19263
    @AuraEnabled
     public static String updateLead_PO(String leadList, SALMobilityPricingCntrl_V2.ContactApplicantWrapper cont)
     {
         List<Lead> newLeadsList = (List<Lead>)JSON.deserialize(leadList,Lead.class);
        // Contact contact = (Contact)JSON.deserialize(conObj,Contact.class);
         return SALMobilityPricingCntrl_V2.updateLead_POMethod(newLeadsList,cont);
     }
    
      @AuraEnabled
     public static String getDiaryColorMethod()
     {
     return SALMobilityPricingCntrl_V2.getDiaryColor();
     }
   @AuraEnabled
     public static String getPOsMethod(String searchLimit)
     {
       return SALMobilityPricingCntrl_V2.getPOs(searchLimit);   
     } 

     //Added by swapnil for referral program
      @ AuraEnabled
    public static List<Demographic_Mapping__c> fetchCity(String searchKeyWord){
        return [SELECT Id, Name FROM Demographic_Mapping__c WHERE Name LIKE: (searchKeyWord + '%')];
    }
   //Referral Enhancement Start - Hrushikesh bug id : 19263 end
    /*Bug 20939 RCU s*/
    @AuraEnabled 
    public static String getVerificationData(String oppId,String objectFieldJSON) {
      return SALMobilityOppCntrl_V2.getVerificationData(oppId,objectFieldJSON);
       
    }
    @AuraEnabled 
    public static String updateVerificationData(String appObj,String veriList,String vamList) {
        return SALMobilityOppCntrl_V2.updateVerificationData(appObj,veriList,vamList);
       
    }
    @AuraEnabled 
    public static String sendVerificationMail(String veriList,String vamList) {
        return SALMobilityOppCntrl_V2.sendVerificationMail(veriList,vamList);
       
    }
     @AuraEnabled 
    public static String callIM(String loanId) {
        return SALMobilityOppCntrl_V2.callIM(loanId);
       
    }
    /*Bug 20939 RCU e*/
    /*Bug 20939 s*/
    @ AuraEnabled
    public static String retriggerBRECalls(String loanid){
      System.debug('loanid>>>'+loanid);
      return SALMobilityOppCntrl_V2.retriggerBRECalls(loanid);
    }
    /*Bug 20939 e*/
     /* Bug 22624 Start - Hrushikesh Sprint 5C */

    // Bug Id : 21804 start
    @AuraEnabled
    public static String autoQueueAllocation(String opp) {
        System.debug('opp -->' + opp);
        Id result = null;
        try {
            Id oppRecord = opp; //(Opportunity) JSON.deserialize(opp, Opportunity.class);
            Opportunity oppRecord1 = [select Product__c, Account.Queue_Master__c,Account.Queue_Master__r.QID__c/*Bug Id : 23549*/, Branch_City__c from Opportunity where id =: oppRecord LIMIT 1];
            AutoQueueAllocationUtility.Response res = AutoQueueAllocationUtility.autoAllocationQueue(oppRecord1, 'mobility_LA');
            System.debug('res --> ' + res);
            if (res != null) {
                String poolUser = Label.Pool_User;
                if (poolUser == res.credituserId) {
                    return JSON.serialize(res.credituserId);
                }
                List < Credit_Officer_Limit__c > colList = 
                    [select id, name, Designation__c, City__c, Credit_Officer_Name__r.Isactive, Credit_Officer_Name__r.id, Credit_Officer_Name__r.name, Credit_Officer_Name__c
                     from Credit_Officer_Limit__c
                     where product__c =: oppRecord1.Product__c AND
                     Credit_Officer_Name__r.Isactive = true AND
                     Active_Flag__c = true AND
                     User_Type__c != 'OPs User'
                     AND City__c INCLUDES(: oppRecord1.Branch_City__c) AND Credit_Officer_Name__c =: res.credituserId
                    ];
                system.debug('colList'+colList);
                for (Credit_Officer_Limit__c col: colList) {
                    res.credituserId = null;
                    if (res.queueType != null && res.queueType == 'Branch Queue') {
                        if (
                            col.Designation__c == 'Credit Manager' || col.Designation__c == 'Area Credit Manager' || col.Designation__c == 'Regional Credit Manager' || col.Designation__c == 'Zonal Credit Manager' ||
                            col.Designation__c == 'National Credit Manager' || col.Designation__c == 'Business Head' || col.Designation__c == 'City Head' || col.Designation__c == 'Chief-Credit & Operations' ||
                            col.Designation__c == 'Chief Risk Officer' || col.Designation__c == 'National Risk Manager' || col.Designation__c == 'President'
                        ) {
                            result = col.Id;
                            break;
                        }
                    }
                    if (res.queueType != null && res.queueType == 'Centralized Queue') {
                        if (col.Designation__c == 'Centralized ACM' || col.Designation__c == 'Centralized RCM') {
                            result = col.Id;
                            break;
                        }
                    }
                }
                if (colList == null && colList.size() == 0) result = null;
            }
            System.debug('after result --> ' + result);
            return JSON.serialize(result);
        } catch (Exception exceptionInstance) {
            System.debug('Exception --> ' + exceptionInstance.getLineNumber() + '        ' + exceptionInstance.getStackTraceString());
            throw new AuraHandledException(exceptionInstance.getMessage());
        }
    }
    /* Bug 22624 Start - Hrushikesh Sprint 5C */

    @AuraEnabled
    public static String viewCreditReportMethod(String appId, String cibid, String cibilTempId, String leadId)
    {
       return SalMobilityOppcntrl_V2.viewCreditReport( appId,  cibid,  cibilTempId,  leadId);
    }
    /* Bug 22624 Stop - Hrushikesh Sprint 5C */
    @AuraEnabled
    public static void submitForAutoApproval(string loanApplicationId, String priApp, string StrAppr1,boolean isAutoCredit) {
        system.debug('loanApplicationId'+loanApplicationId);
        
        if(isAutoCredit)
            SALMobilityOppCntrl_V2.isAutoCredit= isAutoCredit;
        
        SALMobilityOppCntrl_V2.fetchApplicant(loanApplicationId,priApp,StrAppr1);
        
    }
    // Bug Id : 21804 end
    //sal 2.0 new cr start
    @ AuraEnabled
    public static String holdloan(String loanid,String jsonoppobj){
    System.debug('inside parent loanid'+loanid);
      return SALMobilityOppCntrl_V2.holdLoan(loanid,jsonoppobj);
     }
      @ AuraEnabled
    public static String unholdloan(String jsonoppobj){
    System.debug('inside parent loanid'+jsonoppobj);
      return SALMobilityOppCntrl_V2.UnHold(jsonoppobj);
     }
    //sal 2.0 new cr end
}