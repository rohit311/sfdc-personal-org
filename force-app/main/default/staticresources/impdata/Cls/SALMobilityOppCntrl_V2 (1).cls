public without sharing class SALMobilityOppCntrl_V2{
    public static Boolean isAutoCredit = false;   // Bug Id : 21804
    public static Boolean allDataCalled = false;
    
    public static oppData allData;
    public static Set<String> triggeredBRE = new Set<String>(); //20939
    //Bug 22624 Rohit start
    public class CibilDetailsWrapper{
        @AuraEnabled
        public List<DetailedCibilReportPageController.AccountInfo> liveAccounts;
        @AuraEnabled
        public List<DetailedCibilReportPageController.AccountInfo> closedAccounts;
        @AuraEnabled
        public Cibil__c cibil;
        @AuraEnabled
        public Integer pl;
        @AuraEnabled
        public Integer hl;
        @AuraEnabled
        public Integer cd;
        @AuraEnabled
        public Integer al;
        @AuraEnabled
        public Integer card;  
        @AuraEnabled  
        public Integer el;
        @AuraEnabled
        public Integer tw;
        @AuraEnabled
        public Integer od;
        @AuraEnabled
        public Integer gl;
        @AuraEnabled
        public Integer pllive;
        @AuraEnabled
        public Integer hllive;
        @AuraEnabled
        public Integer allive;
        @AuraEnabled
        public Integer cardlive;
        @AuraEnabled
        public Integer ellive;
        @AuraEnabled
        public Integer cdlive;
        @AuraEnabled
        public Integer twlive;
        @AuraEnabled
        public Integer odlive;
        @AuraEnabled
        public Integer gllive;
        @AuraEnabled
        public Integer totaldpd;
        @AuraEnabled
        public Integer pldpd;
        @AuraEnabled
        public Integer hldpd;
        @AuraEnabled
        public Integer aldpd;
        @AuraEnabled
        public Integer carddpd;
        @AuraEnabled
        public Integer eldpd;
        @AuraEnabled
        public Integer cddpd;
        @AuraEnabled
        public Integer twdpd;
        @AuraEnabled
        public Integer oddpd;
        @AuraEnabled
        public Integer gldpd;
        @AuraEnabled
        public Integer plenq;
        @AuraEnabled
        public Integer hlenq;
        @AuraEnabled
        public Integer alenq;
        @AuraEnabled
        public Integer cardenq;
        @AuraEnabled
        public Integer elenq;
        @AuraEnabled
        public Integer cdenq;
        @AuraEnabled
        public Integer twenq;
        @AuraEnabled
        public Integer odenq;
        @AuraEnabled
        public Integer glenq;
    }
    //Bug 22624 Rohit stop
    /* Bug 22624 Start - Hrushikesh Sprint 5C */
    public static  String viewCreditReport(String appId, String cibid, String cibilTempId, String leadId)
    {
        OTPOneViewCIBILController.appId=appId;
        OTPOneViewCIBILController.cibid=cibid;
        OTPOneViewCIBILController.cibilTempId=cibilTempId;
        OTPOneViewCIBILController.leadId=leadId;
        OTPOneViewCIBILController.flag='mobilityV2';
        
        OTPOneViewCIBILController obj=new OTPOneViewCIBILController(null);
        System.debug('Output'+OTPOneViewCIBILController.dss);
        return JSON.serialize(OTPOneViewCIBILController.dss);       
    }
    /* Bug 22624 Stop - Hrushikesh Sprint 5C */
    public static String getCam_Applicant(String myid,  String objectFieldJSON)
    {
        oppData dss = new oppData();
        dss.picklistData = LighteningUtilities.getPicklistValues(objectFieldJSON);
        CAM__c cam = new CAM__c();
        if(!CommonUtility.isEmpty(myid) ){
            List<CAM__c>  camList = [select Business_Continuty__c,/*24997 s*/Gross_Salary_Month1__c,Gross_Salary_Month2__c,Gross_Salary_Month3__c,/*24997 e*/Average_incentive_for_Q1__c,EMI_on_Proposed_Loan_TO__c,Average_incentive_for_Q3__c,Average_incentive_for_Q2__c,Maxi_EMI_Cust__c,Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c,Id,Proposed_Loan_Amt__c, ROI__c, Tenor__c, EMI_of_The_Loan__c, sal_max_loan__c,Eligible_FOIR__c,Receips5_Doc__c,Receips6_Doc__c,Unsecured_FOIR__c, Applicable_FOIR1__c, Loan_Application__c,Average_Monthly_Net_Income1__c,Net_Salary_for_Month1__c,Monthly_Reimbursement__c,Avg_mthly_incntve_3mts__c,Rental_Income__c,Receips4_Doc__c,Existing_HL_EMI__c,Total_Mthly_Oblig__c,EMI__c,Net_Salary_for_Month2__c,Net_Salary_for_Month3__c,Eligible_Loan__c,Month1_Doc__c,Month2_Doc__c,Month3_Doc__c,LAP_pmt__c,Avg_monthly_incentive1__c,Avg_monthly_incentive2__c,Avg_monthly_incentive3__c,Incentive_Monthly_or_Quarterly__c,LAP_EMI__c from cam__c where Loan_Application__c = : myid];
            if(!CommonUtility.isEmpty(camList)){
                cam = camList[0];
            }
        }
        Applicant__c app = new Applicant__c();
        if(!CommonUtility.isEmpty(myid) ){
            List<Applicant__c> applist   = [select id,LTA_Medical__c,LTA_Frequency__c,Proof_of_Registered_Address_Submitted__c from Applicant__c where Loan_Application__c = : myid  AND Applicant_Type__c = 'Primary'];
            if(!CommonUtility.isEmpty(applist)){
                app=applist[0];
                
            }
        }
        dss.applicantPrimary=app;
        dss.camObj=cam;
        System.debug('hereiam'+dss.applicantPrimary);
        return JSON.serialize(dss);       
        
    }
    
    public static List<String> updatePolicy(List<String> itemlist,String oppId)
    {
        try{
            List<SOL_Policy__c> SOLPolicyList;
            List<SOL_Policy__c> tempSOLPolicyList;
            Set<String> displayErrorList=new Set<String>();
            List<String> listToSend=new List<String>();
            Boolean flag=false;
            System.debug('plz2'+oppId);
            SOLPolicyList=[select id, Policy_Name__c,Remarks__c,Disposition_Status__c,Checklist_Policy_Status__c from SOL_Policy__c where Loan_Application__c = : oppId AND Name LIKE 'Sales2.0%'];
            
            System.debug('plz1'+SOLPolicyList);
            system.debug('itemList'+itemlist);
            for(String str:itemlist)
            {
                String[] data=str.split(';');// EKYC data[0], Related Data data[1]
                for(SOL_Policy__c sol: SOLPolicyList)
                {
                    flag=false; //set to False for each iteration
                    String temp=sol.Policy_Name__c;
                    System.debug(data[0]+'ppp'+data[1]+'  '+temp);
                    if((temp.toUpperCase()).contains(data[0].toUpperCase()))
                    {
                        flag=true;          //if contains then True
                        System.debug(data[0]+'ppp'+data[1]+'  '+data[1]);
                        //sol.Policy_Name__c=temp.replace('Fail','Pass');
                        System.debug('replace '+sol.Policy_Name__c);
                        sol.Checklist__c=data[0];
                        sol.Disposition_Status__c=data[1];
                        //update sol;
                    }
                }
            }
            for(String str1:itemlist)
            {
                flag=false; //set to False for each iteration
                String[] data1=str1.split(';');// EKYC data[0], Related Data data[1]
                for(SOL_Policy__c sol: SOLPolicyList)
                {
                    String temp=sol.Policy_Name__c;
                    if((temp.toUpperCase()).contains(data1[0].toUpperCase()))
                    {
                        flag=false;
                        break;
                    }
                    else
                    {
                        flag=true;
                    }   
                }
                if(flag==true){
                    if(data1[0] == 'Company Listing Check' || data1[0] == 'Negative Area'){
                        SOL_Policy__c sol = new SOL_Policy__c();
                        sol.Name = 'Sales2.0 '+data1[0];
                        sol.Policy_Name__c = data1[0];
                        sol.Checklist__c=data1[0];
                        sol.Loan_Application__c = oppId;
                        sol.Disposition_Status__c = data1[1];
                        SOLPolicyList.add(sol);
                    }else{
                        displayErrorList.add(''+data1[0]);
                    }
                }
                
            }
            System.debug('Things not found in SOL POlicies : '+displayErrorList);
            if(SOLPolicyList.size() > 0)
                upsert SOLPolicyList;
            listToSend.addAll(displayErrorList);
            return listToSend;
            
        }catch(Exception e)
        {
            System.debug('Error in update Policy'+e.getMessage());
        }
        return null;
    } 
    
    
    public class SOLDependentList {
        @AuraEnabled          
        public String key;
        @AuraEnabled          
        public List<String> value;
        
        public SOLDependentList(String key, List<String> value)
        {
            this.key=key;
            this.value=value;
        }
        
    }
    //method - Hrushikesh 
    public static List<SOLDependentList> getDisposition(String fldDisposition, String controllingField, String dependentField){
        // added for bug id 21851 start
        Boolean hideAadhaarSection = Boolean.valueOf(CommonUtility.getAadhaarSectionStatus('Ekyc_Integration','hideAadhaarSection',''));
        // added for bug id 21851 stop
        Map<String,List<String>> options = new Map<String,List<String>>();
        List<SOLDependentList> solDependentList1 = new List<SOLDependentList>();
        system.debug('inside getmyDisposition'+fldDisposition+controllingField+dependentField);
        Map<String,List<String>> dependentData = DynamicFieldsController.getFieldDependencies('SOL_Policy__c',controllingField,'Disposition_Status__c');
        for (String key : dependentData.keySet()) {
            List<String> value = dependentData.get(key);
            System.debug('Key = ' + key + ', Value = ' + value);
            SOLDependentList sol=new SOLDependentList(key,value);
            
            solDependentList1.add(sol);
            
        }
        // added if for bug id 21851 start
        List<SOLDependentList> solDependentListTemp = new List<SOLDependentList>();
        for(SOLDependentList solObj:solDependentList1){
            if(solObj.key == 'E KYC' && hideAadhaarSection == true){
            }else{
                solDependentListTemp.add(solObj);
            }
        }
        solDependentList1 = solDependentListTemp;
        // added if for bug id 21851 stop
        system.debug('HH inside getDisposition 1'+dependentData );
        system.debug('inside getDisposition 2'+options);
        
        
        return solDependentList1;
    }
    public static String callPANBreOnCKYC(String accObj,String conObj,String oppObj,String appObj ,String loanId) {
        Applicant__c applicantObj;
        if(appObj != null)
            applicantObj= (Applicant__c)JSON.deserialize(appObj,Applicant__c.class);
        if(applicantObj != null)
        {
            if(applicantObj.Applicant_Type__c == 'Primary' && applicantObj.PANBREDone__c == false && applicantObj.Re_Initiate_De_Dupe__c == true)
            {
                return SALMobilityOppCntrl_V2.callPANBRE(accObj, conObj, oppObj, appObj);   
            }
            else
                return null;
        }
        return null;
    }
    public static String callPANBreOnDocument(String accObj,String conObj,String oppObj,String appObj ,String loanId) {
        Applicant__c applicantObj;
        if(appObj != null)
            applicantObj= (Applicant__c)JSON.deserialize(appObj,Applicant__c.class);
        System.debug('applicantob'+applicantObj.PANBREDone__c);
        System.debug('applicantob'+applicantObj.Cibil_Retrigger_Initiated__c);
        if(applicantObj != null)
        {
            if(applicantObj.Applicant_Type__c == 'Primary' && applicantObj.PANBREDone__c == false && applicantObj.Cibil_Retrigger_Initiated__c == true)
            {
                return SALMobilityOppCntrl_V2.callPANBRE(accObj, conObj, oppObj, appObj);   
            }
            else
                return null;
        }
        return null;  
    }
    public static String callPANBreOnDemographic(String accObj,String conObj,String oppObj,String appObj,String loanId) {
        SOL_Policy__c solPolicyrec;
        oppData dss = new oppData();
        System.debug('in method'+accObj);
        /* List<SOL_Policy__c> SOLPolicyList=[select id,Remarks__c,Old_Address_Value__c, Policy_Name__c,Checklist_Policy_Status__c from SOL_Policy__c where Loan_Application__c = : loanId AND Policy_Name__c LIKE '%Primary Pan Check%' Limit 1];
if(SOLPolicyList != null && SOLPolicyList.size() > 0)
{
System.debug('in method in sol policy');
solPolicyrec= SOLPolicyList[0];
}
if(solPolicyrec != null)
{
System.debug('in method in address value');
if(solPolicyrec.Old_Address_Value__c != null)
{
system.debug('in bre done');
dss.status = 'PANBRE Done';
return JSON.serialize(dss);
}
else{
system.debug('in callPAN');
return SALMobilityOppCntrl_V2.callPANBRE(accObj, conObj, oppObj, appObj);
}
}
else{
system.debug('in else');
}*/
        List<SOL_Policy__c> SOLPolicyList=[select id,Remarks__c,Disposition_Status__c,Old_Address_Value__c, Policy_Name__c,Checklist_Policy_Status__c from SOL_Policy__c where Loan_Application__c = : loanId AND Policy_Name__c LIKE '%Primary Pan Check Pass%' Limit 1];
        if(SOLPolicyList != null && SOLPolicyList.size() > 0)
        {
            dss.status = 'PANBRE Done';
            return JSON.serialize(dss);
        }
        else{           
            return SALMobilityOppCntrl_V2.callPANBRE(accObj, conObj, oppObj, appObj);
            
        }
    }    
    //method for otp Verification in office email
    public static String verifyOtp(String contObj, String applicantObj, String otpValue){
        //call officle email Domain Check
        System.debug('contObj--->'+contObj);
        System.debug('applicantObj-->'+applicantObj);
        System.debug('otpValue-->'+otpValue);
        Contact cont = (Contact)JSON.deserialize(contObj,Contact.class);
        Applicant__c appObj = (Applicant__c)JSON.deserialize(applicantObj,Applicant__c.class);
        if(cont != null){
            List<Contact > conList = new List<Contact >();
            conList = [SELECT Id,Sex__c, Name, One_time_Password__c,Employer__r.KID__c,Employer__c from Contact where Id =: cont.id  ];
            if(!CommonUtility.isEmpty(conList)){
                if(conList[0].One_time_Password__c  == otpValue && appObj.Applicant_type__c == 'Primary'){
                    appObj.Office_Email_Id_Verified__c = true;
                    update appObj;
                    return 'success';
                }
            }
        }
        return 'fail';
        
    }
    public static String saveOfferInhanced(String accJSON){
        oppData dss = new oppData();
        try{
            Account acc;
            if(accJSON != null){
                acc= (Account)JSON.deserialize(accJSON,Account.class);
                System.debug('inside saveOfferInhanced'+acc);
                acc.Offer_Inhanced__c= true;
                update acc; 
                dss.accObj = acc;
                System.debug('inside saveOfferInhanced'+acc.Offer_Inhanced__c);
                dss.status= 'Success';
            }
            else{
                dss.status= 'account is null';
            }
        }
        catch(Exception e)
        {
            System.debug('exception'+e.getLineNumber()+e.getMessage());
            String str = e.getMessage();
            dss.status = str;
        }
        
        
        return JSON.serialize(dss);
    }
    public static List<String> PANCheckCoApp(String PAN, String ProductName) {
        oppData data = new oppData();
        System.debug('Pan number is '+PAN+ProductName);
        String response;
        List<String> spltString;
        List<String> nameOfContact=new List<String>();
        
        try {
            tempuriOrg.BFL_PAN_Check_HTSSoap obj = new tempuriOrg.BFL_PAN_Check_HTSSoap();
            //system.abortJob(jobId);
            system.debug('encrypted pan '+CommonUtility.encryptURLParamFrPan(PAN) +'  encrypted product '+CommonUtility.encryptURLParamFrPan(ProductName));
            if(!Test.isRunningTest())
                response = obj.PANVerification(CommonUtility.encryptURLParamFrPan(PAN), CommonUtility.encryptURLParamFrPan(ProductName));
            else
                response = 'ZaoIka30AZ1gzw1e5IxMDgaLHFiD6gqfLxqH/UphsMOoZBtfUfVQf2adT8Pv/axc5VKhoxYOHJd/6b~A4qZIag==';
            //response = obj.PANVerification(PAN, ProductName);
            System.debug('response -->' + response);
            if (String.isBlank(response)) {
                system.debug('in callout exception');
                throw new CalloutException();
            }
            else{
                response = CommonUtility.decryptURLParamFrPan(response); 
                
                spltString = response.split('\\^');
                if(spltString.size() > 0){
                    system.debug('Splitstring'+(spltString[0])+'-- ');
                    if((spltString[1] != null && spltString[1] !='' && spltString[2] != null && spltString[2] != '' && spltString[3] != '' && spltString[3] != null)){
                        String firstName,middleName;   
                        String lastName;    
                        firstName = spltString[1];
                        if(spltString[2] != 'null')
                            middleName =spltString[2];
                        else
                            middleName ='';
                        lastName = spltString[3];
                        nameOfContact.add(firstName);
                        nameOfContact.add(middleName);
                        nameOfContact.add(lastName);
                        
                        
                        
                    }
                }
            }
        }catch(Exception e){
            System.debug('exception -->'+e.getMessage()+e.getLineNumber());
        }
        
        return nameOfContact;
    }
    
    
    public static String PANCheck(String panNumber, String product , String oppId,String stracc,String strcon,Boolean isDual) {
        String response;
        Opportunity opp;
        List<SOL_Policy__c> ListToBeInsert = new List<SOL_Policy__c>();
        Account acc;
        Contact con;
        //Rohit added null check
        if(stracc != null)
            acc = (Account)JSON.deserialize(stracc,Account.class);
        
        oppData dss = new oppData();
        getAllData(oppId,dss);
        
        System.debug('robin '+acc);
        
        if(strcon != null)    
            con = (Contact)JSON.deserialize(strcon,Contact.class);
        List<String> spltString;
        oppData data = new oppData();
        
        //Opportunity_data data= new Opportunity_data();
        try {
            tempuriOrg.BFL_PAN_Check_HTSSoap obj = new tempuriOrg.BFL_PAN_Check_HTSSoap();
            //system.abortJob(jobId);
            system.debug('encrypted pan '+CommonUtility.encryptURLParamFrPan(panNumber) +'  encrypted product '+CommonUtility.encryptURLParamFrPan(product));
            if(!Test.isRunningTest())
                response = obj.PANVerification(CommonUtility.encryptURLParamFrPan(panNumber), CommonUtility.encryptURLParamFrPan(product));
            else
                response = 'ZaoIka30AZ1gzw1e5IxMDgaLHFiD6gqfLxqH/UphsMOoZBtfUfVQf2adT8Pv/axc5VKhoxYOHJd/6b~A4qZIag==';
            System.debug('response -->' + response);
            if (String.isBlank(response)) {
                system.debug('in callout exception');
                throw new CalloutException();
            }
            else{
                response = CommonUtility.decryptURLParamFrPan(response);
                system.debug('decrypt response'+response);
                spltString = response.split('\\^');
                
            }
            System.debug('spltString.size()'+spltString.size());
            if (spltString != null & spltString.size() < 4) {//added for prod issue 24463
                system.debug('in callout exception');
                throw new CalloutException();
            } 
            SOL_Policy__c panPolicy = new SOL_Policy__c();
            SOL_Policy__c panPolicy1 = new SOL_Policy__c();  /*Bug 20939*/
            TAT_Master__c tatMasterRecord = new TAT_Master__c();
            if(dss != null && dss.applicantPrimary != null && dss.applicantPrimary.TAT_Masters__r.size() > 0)
                tatMasterRecord = dss.applicantPrimary.TAT_Masters__r[0];
            
            tatMasterRecord.PAN_Source__c = 'Input';
            Map<String,SOL_Policy__c> solMap = new Map<String,SOL_Policy__c>();
            List<SOL_Policy__c> oldSolPly = new List<SOL_Policy__c>();
            if(spltString.size() > 0){
                Map<String, Integer> monthsMap = new Map<String, Integer> {
                    'JAN'  => 1, 'FEB' => 2, 'MAR' => 3, 'APR' => 4, 'MAY' => 5, 'JUN' => 6, 'JUL' => 7, 'AUG' => 8, 'SEP' => 9, 'OCT' => 10, 'NOV' => 11, 'DEC' => 12
                        };
                            String finalDate = null;
                tatMasterRecord.PAN_Number__c = spltString[0];
                if (spltString.size() > 1) {
                    
                    if (spltString[1] != 'null' && spltString[1] != '') 
                        tatMasterRecord.Name__c = spltString[1];
                    if(spltString[2] != 'null' && spltString[2] != '')
                        tatMasterRecord.Name__c += ' ' + spltString[2];
                    if(spltString[3] != 'null' && spltString[3] != '')
                        tatMasterRecord.Name__c += ' ' + spltString[3];
                    if (String.isNotBlank(spltString[4])) {
                        List<String> dateList = spltString[4].split('-');
                        if(dateList.size() == 3) {
                            dateList[1] = String.valueOf(monthsMap.get(dateList[1]));
                            Date d = Date.parse(dateList[1]+'/' + dateList[0]+'/'+dateList[2]);
                            System.debug('d --> '+ d);
                            //Datetime dt = datetime.newInstance(d.year(), d.month(),d.day());
                            //Datetime dt = datetime.newInstance(Integer.valueOf(dateList[2]), Integer.valueOf(dateList[1]), Integer.valueOf(dateList[0]));
                            //System.debug('dt --> '+ dt);
                            //finalDate = dt.format('dd/MM/yyyy');
                            //System.debug('finalDate -->' + Date.parse(finalDate));
                            //tatMasterRecord.Last_Modified_Date__c = Date.parse(finalDate);
                            tatMasterRecord.Last_Modified_Date__c = d;//Date.parse(finalDate);
                            System.debug('tatMasterRecord.Last_Modified_Date__c -->' + tatMasterRecord.Last_Modified_Date__c);
                        }
                    }
                    if (String.isNotBlank(spltString[5])) {
                        tatMasterRecord.PAN_Check_Status__c = spltString[5];
                        
                    }
                } else {
                    System.debug('insode else -->');
                    tatMasterRecord.PAN_Check_Status__c = 'Details could not be fetched';
                }
                if(tatMasterRecord.PAN_Check_Status__c == 'Existing and Valid')
                    tatMasterRecord.NSDL_Response__c = 'Success';
                else
                    tatMasterRecord.NSDL_Response__c = 'Failure';
                if(dss.applicantPrimary != null)
                    tatMasterRecord.Applicant__c = dss.applicantPrimary.Id;
                
                system.debug('Splitstring'+(spltString[0])+'-- '+panNumber);
                //Rohit added null check & sol policy delete insert logic start
                List<SOL_Policy__c> solList = [SELECT Id,Remarks__c,Policy_Name__c,Loan_Application__c,New_Address_Value__c,Disposition_Status__c FROM SOL_Policy__c WHERE Loan_Application__c=:oppId AND Policy_Name__c LIKE '%Pan Check%'];
                System.debug('robin pan sol policy '+solList);
                
                if(solList != null && solList.size()>0){
                    for(SOL_Policy__c sol : solList){
                        if(sol.Policy_Name__c.contains('Primary Pan Check'))
                            solMap.put('Primary Pan Check',sol);
                        else if(sol.Policy_Name__c.contains('Dual Pan Check'))
                            solMap.put('Dual Pan Check',sol);
                        else if(sol.Policy_Name__c == 'Primary Pan Check Fail')
                            solMap.put('Primary Pan Check FAIL',sol);
                        else if(sol.Policy_Name__c == 'Dual Pan Check FAIL')
                            solMap.put('Dual Pan Check FAIL',sol);
                        else if(sol.Policy_Name__c == 'NSDL Pan Check') /*Bug 20939*/
                            solMap.put('NSDL Pan Check',sol);
                    }
                }
                /*Bug 20939 s */
                if(spltString[0] != null && spltString[0] == panNumber){
                    /*Bug 20939 e */  
                    if(!isDual){
                        
                        System.debug('in not null acc');        
                        if (spltString[1] != null && spltString[1] != '')
                        acc.First_Name__c = spltString[1];
                      else
                        acc.First_Name__c = '';
                      if (spltString[2] != null && spltString[2] != '')
                       acc.Middle_Name__c = spltString[2];
                      else
                       acc.Middle_Name__c = '';
                      if (spltString[3] != null && spltString[3] != '')
                        acc.Last_Name__c = spltString[3];
                      else
                        acc.Last_Name__c = '';
                        acc.PAN_Check_Status__c = spltString[5];
                        
                        if(solMap.get('Primary Pan Check') != null)
                            oldSolPly.add(solMap.get('Primary Pan Check'));
                        
                        panPolicy.Policy_Name__c = 'Primary Pan Check';
                        panPolicy.Name = 'Sales2.0-Primary Pan Check';
                        panPolicy.New_Address_Value__c = response;
                        panPolicy.Policy_Status__c = 'OK';  
                        if(oppId != null && oppId != '')
                            panPolicy.Loan_Application__c = oppId;
                        
                        if(dss.applicantPrimary != null)
                            panPolicy.Applicant_Name__c = dss.applicantPrimary.Id;
                        
                        ListToBeInsert.add(panPolicy);
                        /*Bug 20939 s */
                        if(solMap.get('NSDL Pan Check') != null)
                            panPolicy1 = solMap.get('NSDL Pan Check') ;
                        else
                            panPolicy1 = new SOL_Policy__c();
                        panPolicy1.Policy_Name__c = 'NSDL Pan Check';
                        panPolicy1.Name = 'Sales2.0 NSDL Pan Check';
                        panPolicy1.Policy_Status__c = 'OK';  
                        if(oppId != null && oppId != '')
                            panPolicy1.Loan_Application__c = oppId;
                        
                        if(dss.applicantPrimary != null)
                            panPolicy1.Applicant_Name__c = dss.applicantPrimary.Id;
                        panPolicy1.RetriggerBRE__c = false;
                        triggeredBRE.add('NSDL Pan Check'); //Retrigger BRE added by Priya
                        ListToBeInsert.add(panPolicy1);
                        /*Bug 20939 e */
                    }
                    else{
                        
                        System.debug('in acc null');
                        
                        panPolicy.Policy_Name__c = 'Dual Pan Check';
                        panPolicy.Name = 'Dual Pan Check';
                        panPolicy.New_Address_Value__c = response;
                        panPolicy.Policy_Status__c = 'OK';
                        
                        if(oppId != null && oppId != '')  
                            panPolicy.Loan_Application__c = oppId;
                        
                        if(dss.applicantPrimary != null)
                            panPolicy.Applicant_Name__c = dss.applicantPrimary.Id;
                        
                        if(solMap.get('Dual Pan Check') != null)
                            oldSolPly.add(solMap.get('Dual Pan Check'));
                        
                        ListToBeInsert.add(panPolicy);    
                        
                    }
                }/*Bug 20939 s */
                else
                {
                    if(!isDual){
                        
                        if(solMap.get('NSDL Pan Check') != null)
                            panPolicy1 = solMap.get('NSDL Pan Check') ;
                        else
                            panPolicy1 = new SOL_Policy__c();
                        panPolicy1.Policy_Name__c = 'NSDL Pan Check';
                        panPolicy1.Name = 'Sales2.0 NSDL Pan Check';
                        panPolicy1.Policy_Status__c = 'OK';  
                        if(oppId != null && oppId != '')
                            panPolicy1.Loan_Application__c = oppId;
                        
                        if(dss.applicantPrimary != null)
                            panPolicy1.Applicant_Name__c = dss.applicantPrimary.Id;
                        panPolicy1.RetriggerBRE__c = false;
                        triggeredBRE.add('NSDL Pan Check'); //Retrigger BRE added by Priya
                        ListToBeInsert.add(panPolicy1);
                        /* Retrigger added by priya e*/
                        acc.PAN_Check_Status__c = spltString[5];
                    } /*Bug 20939 e*/
                }
            }
            else{
                
                System.debug('in else ');
                if(!isDual){
                    acc.First_Name__c = '';
                    acc.Middle_Name__c = '';
                    acc.Last_Name__c = '';
                    acc.PAN_Check_Status__c = '';
                    panPolicy.Policy_Name__c = 'Primary Pan Check FAIL';
                    panPolicy.Name = 'Sales2.0 Primary Pan Check FAIL';
                    
                    panPolicy.New_Address_Value__c = '';
                    panPolicy.Policy_Status__c = 'Rejected';  
                    
                    if(oppId != null && oppId != '')  
                        panPolicy.Loan_Application__c = oppId;
                    
                    if(dss.applicantPrimary != null)
                        panPolicy.Applicant_Name__c = dss.applicantPrimary.Id;
                    
                    if(solMap.get('Primary Pan Check FAIL') != null)
                        oldSolPly.add(solMap.get('Primary Pan Check FAIL'));
                    ListToBeInsert.add(panPolicy);
                }
                else{
                    panPolicy.Policy_Name__c = 'Dual Pan Check FAIL';
                    panPolicy.Name = 'Dual Pan Check FAIL';
                    panPolicy.New_Address_Value__c = '';
                    panPolicy.Policy_Status__c = 'Rejected';    
                    panPolicy.Loan_Application__c = oppId;
                    if(dss.applicantPrimary != null)
                        panPolicy.Applicant_Name__c = dss.applicantPrimary.Id;
                    
                    if(solMap.get('Dual Pan Check FAIL') != null)
                        oldSolPly.add(solMap.get('Dual Pan Check FAIL'));
                    ListToBeInsert.add(panPolicy);
                    
                }
            }
            if(oldSolPly.size()>0)
                delete oldSolPly;
            System.debug('before insert...');
            
            //Rohit added null check & sol policy delete insert logic stop
            if(oppId != null && oppId != '') {
                upsert ListToBeInsert;
                upsert tatMasterRecord;
            }
            
            if(!isDual)
                data.PanCheckSOlPolicy = ListToBeInsert;
            if(con != null)
                data.objCon = con;
            System.debug('acc data'+con);
            if(oppId != '' && oppId != null && acc != null)
            {
                update acc;
                
            }
            data.tatMasterRecord = tatMasterRecord;
            data.accObj = acc;
            data.status = 'success';  /*Bug 20939*/
            String responsedata = JSON.serialize(data);
            System.debug('responsedata -->'+responsedata);
            return responsedata;
        } catch (Exception e)  {
            system.debug('exception in pancheck'+e.getMessage()+e.getLineNumber());
            //return e.getMessage();
            return 'exception in PAN check';//pan check prod issue
        } 
    }
    public static String saveCamDetails(Map<String,String> params){
        oppData data = new oppData();
        CAM__c cam;
        Account acc;
        List<Account> accList;
        Bank_Account__c bankAcc;
        List<Opportunity> oppList;
        Opportunity opp;
        system.debug('bank acc'+params.get('bankObj'));
        try{
            if(params.get('JSONCamObj') != null)
                cam = (CAM__c)JSON.deserialize(params.get('JSONCamObj'),CAM__c.class);
            System.debug('camlist '+cam);
            if(params.get('empAccount') != null)
                accList = (List<Account>)JSON.deserialize(params.get('empAccount'),List<Account>.class);
            if(params.get('bankObj') != null)
                bankAcc = (Bank_Account__c)JSON.deserialize(params.get('bankObj'),Bank_Account__c.class);
            if(params.get('empOpp') != null)
                oppList = (List<Opportunity>)JSON.deserialize(params.get('empOpp'),List<Opportunity>.class);
            
            if(accList != null && accList.size() > 0)
            {
                acc= accList[0];
            }
            if(oppList != null && oppList.size() > 0)
            {
                opp= oppList[0];
            }
            if(cam != null){
                Oppdata mcpResp = SALMobilityOppCntrl_V2.callMCP(params); 
                //Map<String,Object> mcpResp = (Map<String,Object>)JSON.deserializeUntyped(mcpResult);
                System.debug('cam before save'+cam);
                acc = (Account)mcpResp.accObj;
                //conobj = mcpResp.get('objCon');
                //loanobj = mcpResp.get('opp');
                //appObj1 = mcpResp.get('applicantPrimary');
                if (cam.Average_incentive_for_Q1__c != null && cam.Average_incentive_for_Q2__c != null && cam.Average_incentive_for_Q3__c != null) cam.Construction_Valuation_1__c = ((cam.Average_incentive_for_Q1__c + cam.Average_incentive_for_Q2__c + cam.Average_incentive_for_Q3__c) / 3).round(system.roundingMode.CEILING);
                if (cam.Average_incentive_for_Q1__c == null && cam.Average_incentive_for_Q2__c == null && cam.Average_incentive_for_Q3__c == null) cam.Construction_Valuation_1__c = 0;
                
                if (cam.Receips4_Doc__c != null && cam.Receips5_Doc__c != null && cam.Receips6_Doc__c != null) cam.Construction_Valuation_2__c = ((cam.Receips4_Doc__c + cam.Receips5_Doc__c + cam.Receips6_Doc__c) / 3).round(system.roundingMode.CEILING);
                if (cam.Receips4_Doc__c == null && cam.Receips5_Doc__c == null && cam.Receips6_Doc__c == null) cam.Construction_Valuation_2__c = 0;
                /*RSL Mobility bug 22018s*/
                if(opp.product__c=='RSL' && bankAcc!=null){
                    cam.Payment_Date_1__c=bankAcc.Salary_Credit_Date1__c;
                    cam.Payment_Date_2__c=bankAcc.Salary_Credit_Date2__c;
                    cam.Payment_Date_3__c=bankAcc.Salary_Credit_Date3__c;
                }
                /*RSL Mobility 22018e*/
                upsert cam;//Prod issue-24773
                System.debug('cam after save'+cam);
                //System.debug('cam before save'+cam);
                data.camObj = cam;
                data.accObj =acc;
                /* 17139 loan stage issue start*/
                String loanstage = opp.StageName;
                /* 17139 loan stage issue start*/
                System.debug('mcp result '+mcpResp.status);
                if(mcpResp != null){
                    data.status = (String)mcpResp.status;
                    if((String)mcpResp.status == 'MCP check failed'){
                        opp.StageName = 'MCP Reject';
                        update opp;
                    }
                    
                }
                else{
                    opp.StageName = loanstage ;
                    update opp;
                }
                data.opp = opp;
            }
            if(bankAcc != null)
                upsert bankAcc;
        }
        catch(Exception ex){
            System.debug('exception '+ex.getMessage()+' - '+ex.getLineNumber());
            data.status =  ex.getMessage()+'-'+ex.getLineNumber();
        }
        return JSON.serialize(data);
    }
    public static String saveLoanApplication(String loan,String acc,String con,String appObj,String PolicyLst,String ekycObj,String tatMasterRecord,String ckycSms,String attachments){
        System.debug('dssopp'+appObj);
        oppData dss = new oppData();
        TAT_Master__c tatMaster = new TAT_Master__c();
        Opportunity loanobj =(Opportunity) JSON.deserialize(loan, Opportunity.class);
          /* US_956 S*/
        if (loanobj.Application_Source__c != null) 
        loanobj.LeadSource = loanobj.Application_Source__c;
        /* US_956 E*/
        System.debug('loanobj product -->'+loanobj.Product__c);
        eKYC__c ekycOb;
        if(!commonutility.isEmpty(tatMasterRecord)){
            tatMaster = (TAT_Master__c)JSON.deserialize(tatMasterRecord,TAT_Master__c.class);
            system.debug('ekycobj'+tatMaster);
        }
        
        if(!commonutility.isEmpty(ekycObj)){
            ekycOb = (eKYC__c)JSON.deserialize(ekycObj,eKYC__c.class);
            system.debug('ekycobj'+ekycOb);
        }
        Boolean loancreationRej = false;
        List<SOL_Policy__c> SolPolicyLst;
        if(PolicyLst != null)
        {
            //genericDataBank = (List<Bank_Account__c>)JSON.deserialize(JSONBankAccountLst, List<Bank_Account__c>.class);
            SolPolicyLst = (List<SOL_Policy__c>) JSON.deserialize(PolicyLst, List<SOL_Policy__c>.class);
        }
        Account accobj =(Account) JSON.deserialize(acc,Account.class);
        Contact conobj = (Contact)JSON.deserialize(con, Contact.class);
        Applicant__c appObj1 = (Applicant__c)JSON.deserialize(appObj,Applicant__c.class);
        System.debug('inside pk save'+appObj1.Office_Email_Id_Verified__c);
        try{
            //City CR commented below lines
            //String city = SOLDynamicController.getCityFromPincode(String.valueOf(accobj.PinCode__c));
            /* accobj.Current_Residence_Address1__c = conobj.Resi_Area__c;//commented for prod adhoc
if(CommonUtility.isEmpty(accobj.Current_Residence_Address2__c))
accobj.Current_Residence_Address2__c = String.valueOf(Integer.valueOf(accobj.PinCode__c));
if(CommonUtility.isEmpty(accobj.Current_Residence_Address3__c))
accobj.Current_Residence_Address3__c = accobj.Current_City__c;*/
            //accobj.Current_City__c = city;
            accObj.Current_Residence_Address1__c = conobj.Address_1__c;
            accObj.Current_Residence_Address2__c = conobj.Address_2__c;
            accObj.Current_Residence_Address3__c = conobj.Address_3__c;
            
            accObj.Current_PinCode__c = accobj.PinCode__c;
            /* Bug 23485 Territory Starts*/
            accobj.product__c=loanobj.Product__c;
            /* Bug 23485 Territory Ends*/
            //String state =SOLDynamicController.fetchStateRemote(city);
            //accobj.Current_State__c = state;
            conobj.AppCity__c = accobj.Current_City__c;
            conobj.Residence_City__c = accObj.Current_City__c;
            conobj.State__c = accobj.Current_State__c;
            /*conobj.Address_1__c = accObj.Current_Residence_Address1__c;//commented for prod adhoc
conobj.Address_2__c = accObj.Current_Residence_Address2__c;
conobj.Address_3__c = accObj.Current_Residence_Address3__c;*/
            conobj.Employer__c = accObj.Employer__c;
            
            system.debug('accobj.mobile'+accobj.Mobile__c);
            conobj.Mobile__c = accObj.Mobile__c;
            if(CommonUtility.isEmpty(loanobj.Id))
            {
                
                set < id > accIdset = new set < id > ();
                Decimal numberofdays;
                Decimal custmsettingvalue = 0;
                List < sObject > sObjectList = new List < sObject > ();
                List < Contact > ContactList = new List < Contact > ();
                List < sobject > opprejchkList = new List < sobject > ();
                
                ContactList = [select name, Sex__c,PAN_Number__c,AccountId, Relationship_Borrower__c, Permanent_State__c,EMI_Bounce_in_last_3_months__c from Contact where(PAN_Number__c = : accobj.PANNumber__c and Mobile__c = : accobj.Mobile__c AND AccountId != null)
                               or(Date_of_Birth__c = : accobj.Date_of_Birth__c and PAN_Number__c = : accobj.PANNumber__c AND AccountId != null)
                               or(Date_of_Birth__c = : accobj.Date_of_Birth__c and Mobile__c = : accobj.Mobile__c)
                              ];
                System.debug('>>ContactList>>'+ContactList);
                String idStr = '';
                for (contact cc: ContactList) {
                    if (cc.AccountId != null) {
                        accIdset.add(cc.AccountId);
                    }
                }
                opprejchkList = [select Reject_reason__c,name, Link_Offer_id__c, LeadSource, createddate, id, Product__c, StageName, Revised_EMI__c, Moratorium_Period__c, EMI_Type__c, Revised_Loan_Amount__c, Type_of_Moratorium_Interest__c,Total_Monthly_Oblig__c from Opportunity where AccountId in : accIdset AND AccountId != null];
                
                system.debug('>>opprejchkList>>'+opprejchkList);
                if (opprejchkList.size() > 0) {
                    sObjectList.addAll(opprejchkList);
                    loanobj.Existing_Customer__c = 'Existing Customer';
                }
                List < sobject > salrejectList = new List < sobject > ();
                salrejectList = [select createddate from salaried__c where(Pan__c = : accobj.PANNumber__c and Mobile__c = : String.valueOf(accobj.Mobile__c))
                                 or(Date_Of_Birth__c = : accobj.Date_of_Birth__c and Pan__c = : accobj.PANNumber__c)
                                 or(Date_Of_Birth__c = : accobj.Date_of_Birth__c and Mobile__c = : String.valueOf(accobj.Mobile__c))
                                ];
                
                if (salrejectList.size() > 0) sObjectList.addAll(salrejectList);
                sObjectList.sort();
                if (LaonApplicationCreation__c.getValues('Loancreation') != null) {
                    custmsettingvalue = LaonApplicationCreation__c.getvalues('Loancreation').Numberofdays__c;
                }
                if (sObjectList.size() >= 1 ) {
                    for (integer i = sObjectList.size() - 1; i >= 0; i--) { 
                        if (sObjectList[i].getSObjectType().getDescribe().getName() == 'Opportunity') {
                            ////OTPv3 TeleRM Rohit condition changed
                            system.debug('>>stage>>'+sObjectList[i].get('StageName')+'>>product>>'+sObjectList[i].get('Product__c'));
                            String validProducts=System.Label.ValidMobilityV2Products;    // Bug 22018 - RSL Mobility Hrushikesh 
                            if ((sObjectList[i].get('StageName') != 'Rejected' && sObjectList[i].get('StageName') != 'Sales Reject' && sObjectList[i].get('StageName') != 'MCP Reject')&& (validProducts.contains(sObjectList[i].get('Product__c')+';'))){ //22018 Hrushikesh
                                Date myDate = date.newinstance(((datetime) sObjectList[i].get('CreatedDate')).year(), ((datetime) sObjectList[i].get('CreatedDate')).month(), ((datetime) sObjectList[i].get('CreatedDate')).day());
                                numberofdays = mydate.daysBetween(date.TODAY());
                                if (numberofdays < custmsettingvalue) {
                                    loancreationRej = true;
                                    break;
                                }
                            }
                        } else if (sObjectList[i].getSObjectType().getDescribe().getName() == 'Salaried__c') {
                            Date myDate = date.newinstance(((datetime) sObjectList[i].get('CreatedDate')).year(), ((datetime) sObjectList[i].get('CreatedDate')).month(), ((datetime) sObjectList[i].get('CreatedDate')).day());
                            numberofdays = mydate.daysBetween(date.TODAY());
                            if (numberofdays < custmsettingvalue) {
                                loancreationRej = true;
                                break;
                            }
                        }
                    }
                }
                if(!loancreationRej){
                    Boolean  isLinePOAvl = CommonUtility.getCheckLinePO(String.valueof(accobj.Mobile__c),accobj.PANNumber__c ,accObj.Date_of_birth__c, loanobj.Product__c);
                    if(!isLinePOAvl){
                    STring oppString = Json.serialize(new List<Opportunity>{loanobj});
                    String accString = Json.serialize(new List<Account>{accobj});
                    String conString = Json.serialize(new LIst<Contact>{conobj});
                    String appString = Json.serialize(new LIst<Applicant__c>{appObj1});
                    Map<String,String> params = new Map<String,String>();
                    params.put('empAccount',accString);
                    params.put('empOpp',oppString);
                    params.put('empContact',conString);
                    params.put('appObj',appString);
                    params.put('TypeForMCP','DOB');
                    params.put('solPolicySrc','Sales2.0');
                    Oppdata mcpResp = SALMobilityOppCntrl_V2.callMcp(params);
                    
                    //Oppdata mcpResp = (Oppdata)JSON.deserializeUntyped(mcpResult);
                    system.debug('mcpresp'+mcpResp);
                    accobj = (Account)mcpResp.accObj;
                    conobj = (Contact)mcpResp.objCon;
                    loanobj = (Opportunity)mcpResp.opp;
                    appObj1 = (Applicant__c)mcpResp.applicantPrimary;
                    system.debug('ekycobj'+ekycOb.Id);
                    if(ekycOb != null && ekycOb.Id != null){
                        ekycOb.Applicant__c = appObj1.Id;
                        update ekycOb;
                    }
                    if(tatMaster != null){
                        tatMaster.Applicant__c = appObj1.Id;
                        upsert tatMaster;
                    }
                    
                    //System.debug('robin '+mcpResult);
                    if(mcpResp != null && ((String)mcpResp.status) == 'Success'){
                        dss.status = 'Your loan Application has been created successfully'; 
                        /*Added by swapnil Bug 20939 start*/
                        try{
                            // System.debug();
                            
                            queuablesendSMSonLACreation LASendSMSEmail = new queuablesendSMSonLACreation(loanobj,appObj1,'On app creation');
                            ID jobID = System.enqueueJob(LASendSMSEmail);
                            // sendSMSonLACreation(loanObj.Id,appObj1.Id); 
                        }catch(EXception e){
                            System.debug('Error occrred during sms or email sendging '+e.getMessage()+' on line '+e.getLineNumber());
                        }  
                        /*Added by swapnil Bug 20939 end*/ 
                    }
                    else if(mcpResp != null && ((String)mcpResp.status) == 'MCP check failed'){
                        loanobj.StageName = 'MCP Reject';
                        dss.status = 'We cannot proceed due to MCP Failure';
                    }
                    else{
                        dss.status = 'Internal server error. Please try again.';
                    }
                    upsert loanobj;
                    //23578 ckyc start
                    if(loanobj.Id != null){
                        System.debug('inside ckyc'); 
                        List<SOL_Policy__c> ckycToDel = [SELECT ID,Name,Loan_Application__c FROM SOL_Policy__c WHERE Loan_Application__c = :loanobj.Id AND Name = 'Ckyc response'];
                        System.debug('ckyc list '+ckycToDel);
                        if(!CommonUTility.isEmpty(ckycToDel))
                            delete ckycToDel;
                    }
                    //23578 ckycs stop
                    SALMobilityOppCntrl_V2.createCibiltemp(conobj,loanobj,appObj1,SolPolicyLst); 
                    } 
                    else{
                        dss.status = 'Line PO already exists for this customer. Kindly convert the PO';
                    }
                }
                else{
                    dss.status = 'We cannot proceed due to duplicate data!';
                }
                
            }
            else{
                STring oppString = Json.serialize(new List<Opportunity>{loanobj});
                String accString = Json.serialize(new List<Account>{accobj});
                String conString = Json.serialize(new LIst<Contact>{conobj});
                String appString = Json.serialize(new LIst<Applicant__c>{appObj1});
                Map<String,String> params = new Map<String,String>();
                params.put('empAccount',accString);
                params.put('empOpp',oppString);
                params.put('empContact',conString);
                params.put('appObj',appString);
                params.put('TypeForMCP','DOB');
                params.put('solPolicySrc','Sales2.0');
                Oppdata mcpResp = SALMobilityOppCntrl_V2.callMcp(params);
                accobj = (Account)mcpResp.accObj;
                conobj = (Contact)mcpResp.objCon;
                loanobj = (Opportunity)mcpResp.opp;
                appObj1 = (Applicant__c)mcpResp.applicantPrimary;
                if(ekycOb != null && ekycOb.Id != null){
                    if(!CommonUtility.isEmpty(appObj1))
                        ekycOb.Applicant__c = appObj1.Id;
                    update ekycOb;
                }
                if(tatMaster != null){
                    if(!CommonUtility.isEmpty(appObj1))
                        tatMaster.Applicant__c = appObj1.Id;
                    upsert tatMaster;
                }
                if(mcpResp != null && ((String)mcpResp.status) == 'Success'){
                    dss.status = 'Your loan application has been saved successfully.';
                }
                else if(mcpResp != null && ((String)mcpResp.status) == 'MCP check failed'){
                    loanobj.StageName = 'MCP Reject';
                    dss.status = 'We cannot proceed due to MCP Failure';
                }
                else{
                    dss.status = 'Internal server error. Please try again.';
                }
                upsert loanobj;    
                //23578 ckyc start
                if(loanobj.Id != null){
                    System.debug('inside ckyc'); 
                    List<SOL_Policy__c> ckycToDel = [SELECT ID,Name,Loan_Application__c FROM SOL_Policy__c WHERE Loan_Application__c = :loanobj.Id AND Name = 'Ckyc response'];
                    System.debug('ckyc list '+ckycToDel);
                    if(!CommonUTility.isEmpty(ckycToDel))
                        delete ckycToDel;
                }
                //23578 ckycs stop
                SALMobilityOppCntrl_V2.createCibiltemp(conobj,loanobj,appObj1,SolPolicyLst);  
                /*Added by swapnil Bug 20939 start*/
                try{
                    System.debug('testing');
                    
                    queuablesendSMSonLACreation LASendSMSEmail = new queuablesendSMSonLACreation(loanobj,appObj1,'On app creation');
                    ID jobID = System.enqueueJob(LASendSMSEmail);
                    // sendSMSonLACreation(loanObj.Id,appObj1.Id); 
                }catch(EXception e){
                    System.debug('Error occrred during sms or email sendging '+e.getMessage()+' on line '+e.getLineNumber());
                }  
                /*Added by swapnil Bug 20939 end*/
                
                
            }
            //23578 ckyc start
            if(!CommonUtility.isEmpty(attachments) && appObj1.ID != null)
                insertCkycdocs(attachments,appObj1.id);
            //23578 ckyc stop 
            System.debug('inside pk save'+appObj1.Id+appObj1.Office_Email_Id_Verified__c);
            System.debug('line 611');
            if(ckycsms != null && ckycsms != ''){
                List<SMS_Sent__c> ckycSmsLst = (List<SMS_Sent__c>)JSON.deserialize(ckycsms,List<SMS_Sent__c>.class);
                if(!CommonUtility.isEmpty(ckycSmsLst)){
                    for(SMS_Sent__c sms : ckycSmsLst){
                        sms.LoanApplication__c = loanobj.Id;
                    }
                    upsert ckycSmsLst;
                }
            }
            
            getAllData(loanobj.Id,dss);
            
            
        }
        catch(Exception e)
        {
            System.debug('exception'+e.getLineNumber()+e.getMessage()+e.getCause());
            dss.status = 'exception'+e.getMessage(); 
        }
        return JSON.serialize(dss);
    }
    public static void createCibiltemp(Contact conobj,Opportunity loanobj,Applicant__c appObj1, List<SOL_Policy__c> solPolLst) 
    {
        List<Opportunity> oppo=[select id, Loan_Application_Number__c from Opportunity where id =: loanobj.Id LIMIT 1];
        /*String txtMsg = Label.CibilInfoMsgToCust;
txtMsg= txtMsg.replace('xxxxxxx', oppo[0].Loan_Application_Number__c);*/
        List<SOL_Policy__c> listToBeInsert = new List<SOL_Policy__c>();
        //sendsms.message(String.valueOf(conobj.Mobile__c) , txtMsg);
        List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(loanobj);
        List<Applicant__c> appList = new List<Applicant__c>();
        appList.add(appObj1);
        GeneralCommunicationHandler.sendSMS(oppList,appList,'CIBIL Consent SMS-Cust');
        //system.debug('aconobjcc.Mobile__c,txtMsg ====' + conobj.Mobile__c+ '------' + txtMsg);
        /*SMS_Sent__c smssentobjver = new SMS_Sent__c();
smssentobjver.Name = 'Cibil Information to customer';
smssentobjver.SMS_Sent_Number__c = String.valueOf(conobj.Mobile__c);
smssentobjver.LoanApplication__c = (!CommonUtility.isEmpty(loanobj)) ? loanobj.Id : null;
smssentobjver.SMS_Text_Sent__c = txtMsg;
smssentobjver.SMS_Sent_Time__c = system.now();

insert smssentobjver;*/
        if(solPolLst != null && solPolLst.size() > 0)
        {
            for(SOL_Policy__c policy :solPolLst)
            {
                policy.Loan_Application__c = loanobj.Id;
                policy.Applicant_Name__c = appObj1.id;
                listToBeInsert.add(policy);
            }
        }
        if(listToBeInsert != null && listToBeInsert.size() > 0)
        {
            upsert listToBeInsert;
        }
        List < De_Dupe__c > DeDupe = [select id from De_Dupe__c where Applicant__c = : appObj1.id];
        
        if (DeDupe != null && DeDupe.size() > 0) delete DeDupe;
        if (appObj1.DeDupe_Counter__c == null) appObj1.DeDupe_Counter__c = 0;
        appObj1.DeDupe_Counter__c = appObj1.DeDupe_Counter__c + 1;
        upsert appObj1;
        DedupeService.insertDedupeSource(conobj, appObj1, loanobj);
        //Cibil Temp
        if(!appObj1.movedToCibilTemp__c){
            //CibilService.createCibilTempRecord(conobj, appObj1);
        }
    }
    public void createPolicyRecord(String Name,String policyName, Id oppId, Id applicantId,List<SOL_Policy__c> policyList) {
        SOL_Policy__c sp = new SOL_Policy__c();
        sp.Policy_Name__c = policyName;
        sp.Name = Name;
        sp.Loan_Application__c = oppId;
        sp.Applicant_Name__c = applicantId; 
        
        policyList.add(sp);
        system.debug('*****policyList *' + policyList.size());
    }
    public static void createPolicyRecord(List<SOL_Policy__c> policyList,String policyName, String policyStatus, Id oppId, Id applicantId,String Name) {//Name parameter added by Anshita
        SOL_Policy__c sp = new SOL_Policy__c();
        sp.Name = Name;
        sp.Policy_Name__c = policyName;
        sp.Policy_Status__c = policyStatus;
        sp.Loan_Application__c = oppId;
        sp.Applicant_Name__c = applicantId;
        
        policyList.add(sp);
        system.debug('*****policyList *' + policyList.size());
    }
    public static String callPANBRE(String acc,String con,String loanobj,String appObj1) 
    {
        System.debug('in appobj'+acc);
        oppData dss = new oppData();
        String result = '';
        try{
            Opportunity loan;
            Account accobj;
            Contact conobj;
            Applicant__c appObj;
            if(loanobj != null)
                loan =(Opportunity) JSON.deserialize(loanobj, Opportunity.class);
            System.debug('loanobj product -->'+loan.Product__c);
            if(acc != null)
                accobj =(Account) JSON.deserialize(acc,Account.class);
            if(con != null)
                conobj = (Contact)JSON.deserialize(con, Contact.class);
            if(appObj1 != null)
                appObj = (Applicant__c)JSON.deserialize(appObj1,Applicant__c.class);
            System.debug('in appobj'+accObj);
            List < Cibil_Extension1__c > cibilExt1List = new List < Cibil_Extension1__c > ();
            List < CIBIL_Extension__c > cibilExtLst = new List < CIBIL_Extension__c > ();
            List <CIBIL__c> cibilLst = new List <CIBIL__c> ();
            List<CIBIL_secondary_match__c> secCibil = new List<CIBIL_secondary_match__c>();
            Cibil_Extension1__c cibilExt1 ;
            CIBIL_Extension__c cibilExtobj ;
            CIBIL__c cibilobj;
            boolean resnotRecieved = false;
            if(appObj != null)
                cibilExt1List = [select /*OTP v3 CRs*/liveLoanAmount__c,securedToTotalRatioAmount__c,X30_DPD_6_months__c,/*OTP V3 CR e*/id, No_of_Live_PL__c, Unsecured_Exposure__c, Written_Off_principal__c, Max_Secured_Loan_Amount__c, Max_unSecured_Loan_Amount__c, max_mob__c, Written_Off_principal9__c, Average_Total_Balance__c,Settlement1__c,
                                 Written_Off_principal8__c, Written_Off_principal7__c, Written_Off_principal6__c, Written_Off_principal5__c, Written_Off_principal4__c, Written_Off_principal3__c, Written_Off_principal2__c,
                                 Written_Off_principal29__c, Written_Off_principal28__c, Written_Off_principal27__c, Written_Off_principal26__c, Written_Off_principal25__c, Written_Off_principal24__c, Written_Off_principal23__c, Written_Off_principal22__c, Written_Off_principal21__c, Written_Off_principal20__c, Written_Off_principal1__c, Written_Off_principal19__c, Written_Off_principal18__c, Written_Off_principal17__c, Written_Off_principal16__c, Written_Off_principal15__c, Written_Off_principal14__c, Written_Off_principal13__c, Written_Off_principal12__c, Written_Off_principal11__c, Written_Off_principal10__c, Written_Off_and_settled_status__c, Written_Off_and_settled_status9__c, Written_Off_and_settled_status8__c, Written_Off_and_settled_status7__c, Written_Off_and_settled_status6__c, Written_Off_and_settled_status5__c, Written_Off_and_settled_status4__c, Written_Off_and_settled_status3__c, Written_Off_and_settled_status2__c, Written_Off_and_settled_status29__c, Written_Off_and_settled_status28__c, Written_Off_and_settled_status27__c, Written_Off_and_settled_status26__c, Written_Off_and_settled_status25__c, Written_Off_and_settled_status24__c, Written_Off_and_settled_status23__c, Written_Off_and_settled_status22__c, Written_Off_and_settled_status21__c, Written_Off_and_settled_status20__c, Written_Off_and_settled_status1__c, Written_Off_and_settled_status19__c, Written_Off_and_settled_status18__c, Written_Off_and_settled_status17__c, Written_Off_and_settled_status16__c, Written_Off_and_settled_status15__c, Written_Off_and_settled_status14__c, Written_Off_and_settled_status13__c, Written_Off_and_settled_status12__c, Written_Off_and_settled_status11__c, Written_Off_and_settled_status10__c, Write_Off__c, Bad_Track_Record__c, Tradelines_30plus_DPD__c, Total_Amount_overdue__c, Max_Lifetime_Delq__c, Ever_Write_off__c, Secured_Tradelines_90plus_DPD__c, No_Of_Live_Trades__c, Total_No_of_Trades__c, Unsecured_Tradelines_in_last_12m__c, First_Loan_MOB__c, Latest_Loan_MOB__c, Unsecured_to_total_ratio__c, Secured_to_unsecured_ratio__c, Unsecured_to_total_amount__c, OSB_to_loan_amount_unsecured__c, Credit_Card_utilization__c, Avg_unsecured_loan_amount__c, Unsecured_loan_balance__c, Total_Sanction_Amnt_unsecured__c, Total_Sanction_Amnt_secured__c, Max_Secured_MOB__c,
                                 Current_Obligation_All__c, Current_Obligation_Secured__c, Current_Obligation_unsecured__c, Enquiries_past_3_mnths__c, Unsecured_Enquiries_past_3_mnths__c, Current_Bal_on_all_cards__c, Total_no_of_loans_Excluding_CC__c, Highest_DPD_In_1_Year__c, X30_DPD_12_months__c, X30_DPD_3_months__c, Written_Off_Amount__c, Live_Gold_Loan_Amount__c, Total_no_of_secured_loans__c, X5000_amount_overdue__c, Number_of_Hl_Loans__c, Applicant__r.Applicant_Type__c
                                 /*SAL Policy Chnage Start*/
                                 , No_of_PL_Enq_in_Last_12_Months__c, No_of_PL_Enq_in_Last_6_Months__c, Sum_of_Amount_Overdue__c /*SAL Policy Chnage End*/
                                 from Cibil_Extension1__c where Applicant__c = : appObj.id limit 1
                                ];
            if (cibilExt1List != null && cibilExt1List.size() > 0) {
                cibilExt1 = cibilExt1List[0];
            }
            dss.cibilExt1 = cibilExt1;
            if(appObj != null)
                secCibil = [select id,PAN_Number__c from CIBIL_secondary_match__c where Applicant__c =: appObj.id];//22624 added Pan number
            if(appObj != null)
                cibilExtLst = [SELECT Unsecured_to_Secured_ratio__c ,Suit_Filed__c,written_off_settled_status__c,Settlement_Status__c,     Asset_classification_view__c,EMI_bounce_3_months__c,EMI_bounce_6_months__c,Total_current_outstanding__c,X90_DPD_6_months__c,X30_DPD_CC__c,DPD_CC__c,X30_DPD_Gold_Loan__c,Account_Type20__c,Account_Type21__c,Account_Type22__c,Account_Type23__c,Account_Type24__c,Account_Type25__c,Account_Type26__c, 
                               Account_Type27__c,Account_Type28__c,Account_Type29__c,Applicant__c,Current_Balance20__c,Current_Balance21__c,Current_Balance22__c,Current_Balance23__c,
                               Current_Balance24__c,Current_Balance25__c,Current_Balance26__c,Current_Balance27__c,Current_Balance28__c,Current_Balance29__c
                               FROM CIBIL_Extension__c where Applicant__c =: appObj.id limit 1];
            
            if (cibilExtLst != null && cibilExtLst.size() > 0) {
                cibilExtobj = cibilExtLst[0];
            }
            dss.cibilExt = cibilExtobj;
            
            //prod adhoc field binding change start
            List<Cibil_Temp__c> cibTempList = new List<Cibil_Temp__c>();
            Cibil_Temp__c cibTemp = new Cibil_Temp__c();
            if (appObj != null && appObj.Cibil_Temps__r != null && appObj.Cibil_Temps__r.size() > 0)
            {
                cibTempList = appObj.Cibil_Temps__r;
            }
            if (cibTempList != null && cibTempList.size() > 0) {
                cibTemp = cibTempList[0];
            }
            //prod adhoc field binding change end
            // cibTempList = [SELECT id, DPD_cluster_Segment__c FROM Cibil_Temp__c where Applicant__c =: appObj.id limit 1];
            if(appObj != null)
                cibilLst =[SELECT Name,Applicant_Name__c,Account_Type1__c,Account_Type2__c,Account_Type3__c,Account_Type4__c,Account_Type5__c,Account_Type6__c,Account_Type7__c,Account_Type8__c,
                           Account_Type9__c,Account_Type10__c,Account_Type11__c,Account_Type12__c,Account_Type13__c,Account_Type14__c,Account_Type15__c,Account_Type16__c,
                           Account_Type17__c,Account_Type18__c,Account_Type19__c,Account_Type__c,Applicant__c,Current_Balance1__c,Current_Balance2__c,Current_Balance3__c,
                           Current_Balance4__c,Current_Balance5__c,Current_Balance6__c,Current_Balance7__c,Current_Balance8__c,Current_Balance9__c,Current_Balance10__c,
                           Current_Balance11__c,Current_Balance12__c,Current_Balance13__c,Current_Balance14__c,Current_Balance15__c,Current_Balance16__c,Current_Balance17__c,
                           Current_Balance18__c,Current_Balance19__c,Current_Balance__c FROM CIBIL__c where Applicant__c =: appObj.id limit 1];
            
            if (cibilLst != null && cibilLst.size() > 0) {
                cibilobj = cibilLst[0];
            }
            dss.cibilobj = cibilobj;
            //22624 logic COUNT Start
            Integer count=0; 
            if(loan.PAN_Number__c !=null && secCibil.size()>0)
            {      
                for(CIBIL_secondary_match__c secObj:secCibil)
                {    
                    if(secObj.PAN_Number__c!=null && secObj.PAN_Number__c != loan.PAN_Number__c )
                    {
                        count++;
                    }
                }
            } //22624 logic COUNT Stop 
            
            Map<String,String> inputMap = new Map<String,String>();
            inputMap.put('loan_id',(loan != null && loan.Loan_Application_Number__c != null) ? String.valueof(loan.Loan_Application_Number__c) : '');
            inputMap.put('product',(loan != null && loan.Product__c != null) ? String.valueof(loan.Product__c) : '');
            inputMap.put('date_of_birth',(accobj != null && accobj.Date_of_Birth__c != null) ? String.valueof(accobj.Date_of_Birth__c) : '');
            inputMap.put('pan', (accobj != null && accobj.PANNumber__c != null) ? String.valueOf(accobj.PANNumber__c) : '');
            inputMap.put('pan_status',(accobj != null && accobj.PAN_Check_Status__c != null)?String.valueOf(accobj.PAN_Check_Status__c) : '');
            //inputMap.put('dual_pan_records_found',(secCibil != null && secCibil.size() > 0)? 'YES':'NO'); //commented for 22624
            inputMap.put('dual_pan_records_found',(count>0)? 'YES':'NO'); //Bug 22624
            if (Loan != null && loan.Branch_Name__c != null && loan.Branch_Name__r.name != null) {
                inputMap.put('branch_Name', loan.Branch_Name__r.name);
            } else {
                inputMap.put('branch_Name','');
            }
            System.debug('branch name -->'+inputMap.get('branch_name'));
            inputMap.put('EPFO_api_response',accobj != null && accobj.epfo_result__c != null ? 'YES' : 'NO');
            inputMap.put('EPFO_test_result',accobj != null && accobj.epfo_result__c != null ? accobj.epfo_result__c : '');
            inputMap.put('email_triggered',conobj.Office_Email_sent__c!= null && conobj.Office_Email_sent__c ? 'YES' : 'NO');
            inputMap.put('email_verified',appObj.Office_Email_Id_Verified__c  != null ? String.valueof(appObj.Office_Email_Id_Verified__c) : '');
            inputMap.put('domain_check',appObj.Domain_Check_Result__c  != null ? String.valueof(appObj.Domain_Check_Result__c ) : '');
            
            inputMap.put('mob',(accobj != null && accobj.Mobile__c != null) ? String.valueOf(accobj.Mobile__c) : '0');
            inputMap.put('emi_bounce_last_3months',(cibilExtobj != null && cibilExtobj.EMI_bounce_3_months__c != null)?String.valueof(cibilExtobj.EMI_bounce_3_months__c) :'0');
            inputMap.put('emi_bounce_last_6months',(cibilExtobj != null && cibilExtobj.EMI_bounce_6_months__c != null)?String.valueof(cibilExtobj.EMI_bounce_6_months__c) :'0');
            inputMap.put('overdue_amount',(cibilExt1 != null && cibilExt1.Sum_of_Amount_Overdue__c != null)? String.valueOf(cibilExt1.Sum_of_Amount_Overdue__c ):'0');
            inputMap.put('dpd30_in_last_6months',(cibilExt1 != null && cibilExt1.X30_DPD_6_months__c != null) ? String.valueOf(cibilExt1.X30_DPD_6_months__c) : 'No');
            inputMap.put('dpd90_in_last_6months', (cibilExtobj != null && cibilExtobj.X90_DPD_6_months__c != null)?cibilExtobj.X90_DPD_6_months__c :'No');
            inputMap.put('no_of_live_PL',(cibilExt1 != null && cibilExt1.No_of_Live_PL__c != null) ? String.valueof(cibilExt1.No_of_Live_PL__c) : '0');
            inputMap.put('cc_dpd',(cibilExtobj != null && cibilExtobj.DPD_CC__c != null)?cibilExtobj.DPD_CC__c :'No');
            inputMap.put('gold_loan_dpd',(cibilExtobj != null && cibilExtobj.X30_DPD_Gold_Loan__c != null)?cibilExtobj.X30_DPD_Gold_Loan__c :'No');
            inputMap.put('total_current_outstanding',(cibilExtobj != null && cibilExtobj.Total_current_outstanding__c != null)?String.valueOf(cibilExtobj.Total_current_outstanding__c) :'0');
            inputMap.put('cc_30dpd',(cibilExtobj != null && cibilExtobj.X30_DPD_CC__c != null)?cibilExtobj.X30_DPD_CC__c :'No');
            inputMap.put('asset_classification_view',(cibilExtobj != null && cibilExtobj.Asset_classification_view__c != null)?cibilExtobj.Asset_classification_view__c :'No');
            if (appObj != null && appObj.CIBIL_Score__c != null && appObj.CIBIL_Score__c == '000-1') inputMap.put('CIBIL_Score', '0');
            else inputMap.put('CIBIL_Score', (appObj != null && appObj.CIBIL_Score__c != null) ? String.valueof(appObj.CIBIL_Score__c) : '0');
            inputMap.put('suit_filed',(cibilExtobj != null && cibilExtobj.Suit_Filed__c != null) ? cibilExtobj.Suit_Filed__c :'No');
            inputMap.put('net_Salary_for_Month1',(accObj != null && accObj.Gross_Salary_Turn_Over__c != null) ?String.valueOf(accObj.Gross_Salary_Turn_Over__c):'0');
            inputMap.put('number_of_HL_Loans',(cibilExt1 != null && cibilExt1.Number_of_Hl_Loans__c != null) ? String.valueof(cibilExt1.Number_of_Hl_Loans__c) : '0');
            inputMap.put('noOfPLEnquiriesIn12M',(cibilExt1 != null && cibilExt1.No_of_PL_Enq_in_Last_12_Months__c != null) ? String.valueof(cibilExt1.No_of_PL_Enq_in_Last_12_Months__c) : '0');
            inputMap.put('settlement',(cibilExtobj != null && cibilExtobj.Settlement_Status__c != null ) ? String.valueOf(cibilExtobj.Settlement_Status__c): 'No');
            inputMap.put('written_off_settled_status',(cibilExtobj != null && cibilExtobj.written_off_settled_status__c != null )? String.valueOf(cibilExtobj.written_off_settled_status__c) : 'No');
            inputMap.put('noOfPLEnquiriesIn6M', (cibilExt1 != null && cibilExt1.No_of_PL_Enq_in_Last_6_Months__c != null) ? String.valueof(cibilExt1.No_of_PL_Enq_in_Last_6_Months__c) : '0');
            system.debug('conobj : '+conobj);
            //System.debug('conobj.Employer__r.Company_Category__c is : '+conobj.Employer__r.Company_Category__c);
            inputMap.put('company_Category',(conobj != null && conobj.Employer__r != null && conobj.Employer__r.Company_Category__c != null)?conobj.Employer__r.Company_Category__c :'');
            inputMap.put('unsecuredLoanRatio',(cibilExtobj != null && cibilExtobj.Unsecured_to_Secured_ratio__c != null) ? String.valueof(cibilExtobj.Unsecured_to_Secured_ratio__c) : '0');
            inputMap.put('dpd_cluster_segment', (cibTemp != null && cibTemp.DPD_cluster_Segment__c != null) ? String.valueOf(cibTemp.DPD_cluster_Segment__c) : '');
            System.debug('Value of DPD: ' + String.valueOf(cibTemp.DPD_cluster_Segment__c));
            Map<String, Object> resultMap; 
            List<De_Dupe__c> dedupeLst = [select id, name, Property_Details__c, Property_Details__r.id, Property_Details__r.Name, Applicant__r.Applicant_Type__c, Applicant__r.id, Applicant__r.Contact_Name__r.Name, Dedupe_Source__c, Dedupe_Lan_Matches__c, Applicant__c, Applicant__r.Contact_Name__c, Datafix_Updated__c, Application_Status__c,
                                          Application_ID__c, Random_Dedupe__c, Area_Status__c, Customer_Status__c,
                                          Customer_ID__c, Dedupe_Comments__c, De_Dupe_result__c, De_Dupe_Decision__c, Segment__c, SF_Base__c, Source_Or_Target__c from De_Dupe__c where Loan_Application__c = : loan.Id
                                         ];
            
            if(cibilobj != null && cibilExtobj != null && cibilExt1 != null && dedupeLst != null){
                BRECallout br = new BRECallout();
                //System.debug('cibil -->'+dedupeLst[0]);
                if (!Test.isRunningTest())
                    resultMap = br.callPANBRE(inputMap,dedupeLst);
                else
                    resultMap = (Map<String,Object>)JSON.deserializeUntyped('{"EPFO_check":null,"employment_check":"","pan_triggers_list":[],"codified_dedupe_list":[],"codified_dedupe_output":"POSITIVE","codified_output_list":[],"pan_check_output":"FAIL","pan_series_trigger":"NO","cibil_dashboard":"Positive","codified_cibil_result":"POSITIVE","locationBasedEWSCategory":null,"ewsRuleDescription":null,"ews_rule_policy":null,"riskCodesPerLocation":"T3_AGE45, SAL40K, CIBIL780;T3_AGE55, SAL40K","pan_check_dashboard":"NOT CONFIRMED","loanId":null}');
                System.debug('after Call');
            }
            else{
                resnotRecieved = true;
                dss.status ='CIBIL And Dedupe response are not received yet.';
                
            }
            dss.applicantPrimary = appObj;
            dss.opp = loan;
            checkSecondaryCibil(dss);
            List<SOL_Policy__c> policyLst = new List<SOL_Policy__c>();
            List<SOL_Policy__c> OldpolicyLst = new List<SOL_Policy__c>();
            SOL_Policy__c PANChecksol = new SOL_Policy__c();
            Map<String , SOL_Policy__c> OldpolicyMap = new Map<String,SOL_Policy__c>();
            Map<String , SOL_Policy__c> OldplcyMapWOSls2 = new Map<String,SOL_Policy__c>();
            System.debug('Result Finall One'+resultMap);
            if (Test.isRunningTest())
                resultMap = (Map<String,Object>)JSON.deserializeUntyped('{"EPFO_check":"Negative","employment_check":"Successful","pan_triggers_list":[],"codified_dedupe_list":["mob<3","mob<3","mob<3","mob<3"],"codified_dedupe_output":"NOT CONFIRMED","codified_output_list":["Suit Filed"],"pan_check_output":"PASS","pan_series_trigger":"NO","cibil_dashboard":"Refer","codified_cibil_result":"NEGATIVE","locationBasedEWSCategory":";BL_780, HL, Enq_All","ewsRuleDescription":null,"ews_rule_policy":";BL_780, HL, Enq_All","riskCodesPerLocation":"BL_780, HL, ENQ_ALL;PVT LTD_750, HL;UNLISTED_750, NSAL50K","pan_check_dashboard":"SUCCESSFUL","loanId":null}');
            
            if(resultMap != null)
            {
                OldpolicyLst =[select Name,Old_Address_Value__c,Policy_Name__c from SOL_Policy__c where Loan_Application__c =: loan.Id];
                System.debug('OldpolicyLst is :'+OldpolicyLst);
                
                for(SOL_Policy__c policy : OldpolicyLst)
                {
                    if(policy.Name.contains('Sales2.0')){
                        if(policy.Name.equalsIgnoreCase('Sales2.0-Primary Pan Check'))
                        {
                            PANChecksol= policy;
                            system.debug('PANChecksol : '+PANChecksol);
                        }
                        else{
                            OldpolicyMap.put(policy.Name,policy);  
                        }
                    }
                    else{
                        OldplcyMapWOSls2.put(policy.Name,policy);
                    }
                    
                }
                SOL_Policy__c solEmp;
                if(OldpolicyMap != null && OldpolicyMap.size() > 0 )//containsKey check added by Anshita
                {
                    if(OldpolicyMap.containsKey('Sales2.0 Employment Check Pass'))
                        solEmp= OldpolicyMap.get('Sales2.0 Employment Check Pass');
                    else if(OldpolicyMap.containsKey('Sales2.0 Employment Check Fail'))
                        solEmp= OldpolicyMap.get('Sales2.0 Employment Check Fail');
                    else
                        solEmp= new SOL_Policy__c();
                    system.debug('solPolicy inside if: '+solEmp);
                }else
                {
                    solEmp= new SOL_Policy__c();
                    system.debug('solPolicy inside else: '+solEmp);
                }
                if(resultMap.get('employment_check') != null && String.valueof(resultMap.get('employment_check')).toUpperCase() == 'SUCCESSFUL'){
                    solEmp.Name = 'Sales2.0 Employment Check Pass';
                    solEmp.Policy_Name__c = 'Employment Check Pass';
                    solEmp.Policy_Status__c = 'OK';
                }
                else{
                    solEmp.Name = 'Sales2.0 Employment Check Fail';
                    solEmp.Policy_Name__c = 'Employment Check Fail';
                    solEmp.Policy_Status__c = 'Rejected';
                    
                }
                /*Bug 20939 s*/
                triggeredBRE.add('Employment Check');
                solEmp.RetriggerBRE__c = false;
                /*Bug 20939 e*/
                solEmp.Old_Address_Value__c = JSON.serialize(resultMap);
                solEmp.Applicant_Name__c = appObj.Id;
                solEmp.Loan_Application__c = Loan.Id;
                policyLst.add(solEmp);
                if(resultMap.get('codified_cibil_result') != null)
                {
                    appObj.Codified_CIBIL__c = (String)resultMap.get('codified_cibil_result');
                }
                if(resultMap.get('cibil_dashboard') != null){
                    SOL_Policy__c solPolicy;
                    
                    if(OldpolicyMap != null && OldpolicyMap.size() > 0 && OldpolicyMap.containsKey('Sales2.0-Codified CIBIL'))//containsKey check added by Anshita
                    {
                        solPolicy = OldpolicyMap.get('Sales2.0-Codified CIBIL');
                        system.debug('solPolicy inside if: '+solPolicy);
                    }else
                    {
                        solPolicy = new SOL_Policy__c();
                        system.debug('solPolicy inside else: '+solPolicy);
                    }
                    if(resultMap.get('cibil_dashboard') != null && String.valueof(resultMap.get('cibil_dashboard')).equalsIgnoreCase('positive')) //Bug 19272 (refer -> positive)
                    {
                        system.debug('inside cibil_dashboard before');
                        solPolicy.Policy_Name__c='CIBIL Check Pass';  
                        system.debug('inside cibil_dashboard after');
                        solPolicy.Policy_Status__c='OK';
                    }
                    else{
                        solPolicy.Policy_Name__c='CIBIL Check Fail'; 
                        solPolicy.Policy_Status__c='Rejected'; 
                        
                    }
                    String rem = '';
                    if(resultMap.get('codified_output_list') != null){
                        for(Object str : (List<Object>)resultMap.get('codified_output_list')){
                            rem += String.valueof(str)+';';
                        }
                    }
                    /*Bug 20939 s*/
                    triggeredBRE.add('CIBIL Check');
                    solPolicy.RetriggerBRE__c = false;
                    /*Bug 20939 e*/
                    solPolicy.Remarks__c = rem;
                    solPolicy.Name = 'Sales2.0-Codified CIBIL';
                    solPolicy.Loan_Application__c = loan.id;
                    solPolicy.Applicant_Name__c = appObj.id;
                    solPolicy.Old_Address_Value__c = JSON.serialize(resultMap);
                    policyLst.add(solPolicy);
                    
                    
                }
                //codified_dedupe_output changes added by Anshita
                if(resultMap.get('codified_dedupe_output') != null)
                {
                    SOL_Policy__c solPolicy;
                    system.debug('codified_dedupe_output : '+resultMap.get('codified_dedupe_output'));
                    appObj.Codified_DeDupe__c = (String)resultMap.get('codified_dedupe_output');
                    
                    //OldpolicyMap if/else condition added by Anshita
                    if(OldpolicyMap != null && OldpolicyMap.size() > 0 && OldpolicyMap.containsKey('Sales2.0-Codified DeDupe'))
                    {
                        solPolicy = OldpolicyMap.get('Sales2.0-Codified DeDupe');
                    }else
                    {
                        solPolicy = new SOL_Policy__c();
                    }
                    if(resultMap.get('codified_dedupe_output') != null && resultMap.get('codified_dedupe_output') == 'NOT CONFIRMED')
                    {
                        solPolicy.Policy_Name__c='Dedupe Check Fail'; 
                        solPolicy.Policy_Status__c='Rejected';
                        
                        
                        
                    }
                    else{
                        solPolicy.Policy_Name__c='Dedupe Check Pass';  
                        solPolicy.Policy_Status__c='OK';
                    }
                    String rem = '';
                    if(resultMap.get('codified_dedupe_list') != null){
                        for(Object str : (List<Object>)resultMap.get('codified_dedupe_list')){
                            rem += String.valueof(str)+';';
                        }
                    }
                    solPolicy.RetriggerBRE__c = false;/*Bug 20939*/
                    solPolicy.Remarks__c = rem;
                    solPolicy.Name = 'Sales2.0-Codified DeDupe';
                    //solPolicy.Policy_Name__c='Dedupe Check Pass';
                    solPolicy.Loan_Application__c = loan.id;
                    solPolicy.Applicant_Name__c = appObj.id;
                    solPolicy.Old_Address_Value__c = JSON.serialize(resultMap);
                    triggeredBRE.add('Dedupe Check'); /*Bug 20939*/
                    policyLst.add(solPolicy);
                    
                }
                //resultMap.put('ews_rule_policy','Test EWS');
                if(resultMap.get('ews_rule_policy') != null)
                {
                    SOL_Policy__c solPolicy;
                    //if/else condition added by Anshita
                    if(OldplcyMapWOSls2 != null && OldplcyMapWOSls2.size() > 0 && OldplcyMapWOSls2.containsKey('EWS'))
                    {
                        solPolicy = OldplcyMapWOSls2.get('EWS');
                    }else
                    {
                        solPolicy = new SOL_Policy__c();
                    }
                    if(OldplcyMapWOSls2 != null && OldplcyMapWOSls2.containsKey('EWS')){
                        delete OldplcyMapWOSls2.get('EWS');
                    }
                    /*solPolicy.Name = 'EWS';
solPolicy.Policy_Name__c='EWS';
solPolicy.Loan_Application__c = loan.id;
solPolicy.Applicant_Name__c = appObj.id;
solPolicy.Old_Address_Value__c = JSON.serialize(resultMap);
policyLst.add(solPolicy);*/
                    String ewsRulePol = (String)resultMap.get('ews_rule_policy');
                    
                    if(ewsRulePol != null && ewsRulePol != ''){
                        List<String> ews_rule_list = ewsRulePol.split('#');
                        system.debug('ews_rule_list is : '+ews_rule_list);
                        if(ews_rule_list.size() > 1 ){
                            for(String str : ews_rule_list[1].split(';')){
                                
                                if(str != null && str != ''){
                                    createPolicyRecord(policyLst, 'EWS Rule Description Policy : '+str, 'Rejected', loan.id, appObj.id,'EWS');//Extra parameter added by Anshita
                                }
                            }
                        }
                        else{
                            createPolicyRecord(policyLst,'EWS Rule Description Policy Fail', 'Rejected', loan.id, appObj.id,'EWS');//Extra parameter added by Anshita
                            
                        }
                    }
                    //Null condition addded by Anshita
                    if(resultMap.get('locationBasedEWSCategory') != null){
                        appObj.Location_Wise_EWS_Status__c = (String)resultMap.get('locationBasedEWSCategory');
                    }
                }
                if(resultMap.get('pan_check_output') != null)
                {
                    SOL_Policy__c solPolicy;
                    solPolicy = PANChecksol;
                    if(resultMap.get('pan_check_dashboard') != null && resultMap.get('pan_check_dashboard') == 'SUCCESSFUL')
                    { 
                        solPolicy.Name = 'Sales2.0-Primary Pan Check';
                        solPolicy.Policy_Name__c='Primary Pan Check Pass';  
                        solPolicy.Policy_Status__c='OK';
                    }
                    else{
                        solPolicy.Name = 'Sales2.0-Primary Pan Check';
                        solPolicy.Policy_Name__c='Primary Pan Check Fail'; 
                        solPolicy.Policy_Status__c='Rejected';
                        
                    }
                    String rem = '';
                    if(resultMap.get('pan_triggers_list') != null){
                        for(Object str : (List<Object>)resultMap.get('pan_triggers_list')){
                            rem += String.valueof(str)+';';
                        }
                    }
                    solPolicy.Remarks__c = rem;
                    //String PANoutput = resultMap.get('pan_check_dashboard')+'_'+resultMap.get('pan_series_trigger')+'_'+resultMap.get('pan_check_output');
                    solPolicy.RetriggerBRE__c = false;/*Bug 20939*/
                    solPolicy.Old_Address_Value__c = JSON.serialize(resultMap);
                    solPolicy.Loan_Application__c = loan.id;
                    solPolicy.Applicant_Name__c = appObj.id;
                    triggeredBRE.add('Primary Pan Check');/*Bug 20939*/
                    policyLst.add(solPolicy);
                    
                }
                if(resultMap.get('ews_rule_policy') != null)
                    appObj.RC_Deviation__c = (String)resultMap.get('ews_rule_policy');
                
                
                if(policyLst != null && policyLst.size() > 0)
                {
                    system.debug('sol policy'+policyLst.size());
                    appObj.PANBREDone__c = true;
                    upsert policyLst;
                    update appObj;
                }
                
                dss.applicantPrimary = appObj;
                dss.SOLPolicyList = policyLst;
                dss.status ='Success';    
                
                
            }
            else{
                if(!resnotRecieved)
                    dss.status ='Error while calling BRE.';
            }
        }
        catch(Exception e)
        {
            dss.status = e.getMessage() + e.getLineNumber()+e.getStackTraceString();
            System.debug('result -->'+e.getMessage() + e.getLineNumber());
        }
        return JSON.serialize(dss); 
    }
    
    public static Opportunity salesReject(String jsonoppObj){
        List < sObject > genericData = new List < sObject > ();
        System.debug('inside salesReject'+jsonoppObj);
        Opportunity oppObj= new Opportunity ();
        try {
            genericData = (List < sObject > )JSON.deserialize(jsonoppObj, List < sObject > .class);
            if (genericData != null) 
                oppObj= (Opportunity)genericData[0];
            oppObj.StageName = 'Sales Reject';
            update oppObj;
        } catch(Exception e)
        {
            System.debug('Exception'+e.getMessage()+' at Line Number: ' + e.getLineNumber());
            return null;
        }
        return oppObj;
    }
    /* EPFO callout + Office email verification + office email domain check*/
    public static String doEPFOChecks(String acc, String opp, String cont){
        OppData dss = new OppData();
        try{
            Contact contObj = (Contact)JSON.deserialize(cont,Contact.class);
            Opportunity oppObj = (Opportunity)JSON.deserialize(opp,Opportunity.class);
            Account accObj = (Account)JSON.deserialize(acc,Account.class);
            System.debug('oppObj--->'+oppObj);
            //EPFO
            accObj.Employer__r = null;
            String base64Data = '';
            if(!CommonUtility.isEmpty(contObj) ){
                try{
                     //added for bug id 22019 start
     sobject sobj;
     sobj = contObj;
     //added for bug id 22019 stop
      Map < String, String > epfoResult = FioranoCallout.callEPFO(sobj, null); //method signature changed for bug id 22019 start
                    if(epfoResult != null){
                        system.debug('epfoResult.getstatusCode'+epfoResult.get('statusCode'));
                        accObj.EPFO_Result__c = epfoResult.get('statusCode');
                        
                        base64Data =  epfoResult.get('pdfB64');
                        /*Bug 20939 s*/
                        List < SOL_Policy__c > policyList = new List < SOL_Policy__c > ();
                        SOL_Policy__c  SolObj = new  SOL_Policy__c ();
                        policyList = [select id, Policy_Name__c,New_Address_Value__c ,Old_Address_Value__c,Policy_Status__c,Loan_Application__c,Checklist_Policy_Status__c, Applicant_Name__c from SOL_Policy__c where Loan_Application__c = : oppObj.Id AND Name LIKE 'Sales2.0 EPFO Details' limit 1];
                        if(!CommonUtility.isEmpty(policyList) && policyList[0].Policy_Name__c.contains('EPFO Details')){
                            SolObj = policyList[0];
                        }
                        else{
                            SolObj = new SOL_Policy__c();
                            SolObj.Name = 'Sales2.0 EPFO Details';
                            SolObj.Policy_Name__c = 'EPFO Details';
                            SolObj.Loan_Application__c = oppObj.Id;
                        }
                        SolObj.RetriggerBRE__c = false;
                        upsert SolObj;
                        triggeredBRE.add('EPFO Details'); /*Bug 20939 e*/
                        
                    }
                    else
                        System.debug('Error in callout!');
                }   
                catch(Exception e)
                {
                    System.debug('Exception: '+e.getMessage()+' Line Number:'+e.getLineNumber()+' Stack trace: '+e.getStackTraceString());
                }
                
            }
            if (Test.isRunningTest())
                base64Data = 'test data';
            
            if(base64Data != null && base64Data != ''){
                ContentVersion DataFile = new ContentVersion();
                DataFile.versionData = EncodingUtil.base64Decode(base64Data);
                DataFile.title = 'EPFO result';
                DataFile.pathOnClient ='/EPFOResult.pdf';
                insert DataFile;
                
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = [select ContentDocumentId from ContentVersion where id =: DataFile.id].ContentDocumentId;
                cdl.LinkedEntityId = accObj.Id;
                cdl.ShareType = 'V';
                insert cdl;
            }
            contObj.Employer__r = null;
            upsert accObj;  
            upsert contObj;  
            List<Account> accList = [SELECT PAN_Check_Status__c,Preferred_language__c,Name_of_the_Company_Employer__c,Type_of_Salary__c,Educational_Qualification__c,Offer_Inhanced__c,Type_of_Educational_Institution__c,Current_experiance_in_Month__c,Current_experiance_in_Years__c,Total_Work_Experience_Months__c,Total_Work_Experience_Yrs__c,Qualification__c,Gross_Salary_Turn_Over__c,Residence_TypeAcc__c,Id,Name, First_Name__c,PinCode__c,Area_Locality__r.id,Area_Locality__r.Name,Area_Locality__r.Affluence__c,Area_Locality__c,Last_Name__c,Middle_Name__c,Current_City__c,Current_State__c,Date_of_Birth__c,Mobile__c,PANNumber__c,Gender__c,DesignationOTP__c,Office_Address_1st_Line__c,Office_Address_2nd_Line__c,Office_Address_3rd_Line__c,Office_Pin_Code__c,Office_Landline_Number1__c,Permanent_Residence_Address1__c,Permanent_Residence_Address2__c,Permanent_Residence_Address3__c,Permanent_PinCode__c,Permanent_Telephone_Number__c,Current_Residence_Address1__c,Current_Residence_Address2__c,Current_Residence_Address3__c,Current_PinCode__c,Employer__c,Type_Of_Industry__c,Email_Id__c,Marital_Status__c,Employer__r.Name,EPFO_Result__c,Employer__r.Sub_Industry__c,Downsizing_Reasons__c,Preffered_Mode_to_Connect__c  from Account where Id =: oppObj.AccountId ];
            
            dss.objCon = contObj;
            dss.accObj = accList[0];
            dss.status = 'success';
        }
        catch(Exception e)
        {
            System.debug('Exception'+e.getMessage()+' at Line Number: ' + e.getLineNumber());
            dss.status = 'Error while processing';
        }
        return JSON.serialize(dss);
    }
    
    public static String doEmploymentChecks(String acc, String opp, String cont){
        OppData dss = new OppData();
        try{
            Contact contObj = (Contact)JSON.deserialize(cont,Contact.class);
            Opportunity oppObj = (Opportunity)JSON.deserialize(opp,Opportunity.class);
            Account accObj = (Account)JSON.deserialize(acc,Account.class);
            System.debug('oppObj--->'+oppObj);
            
            
            
            List<Applicant__c> appList = [select /*Ekyc Start */eKYC_Processing__c,Proof_of_Registered_Address_Submitted__c,HashCode__c,/*Ekyc stop */id,Risk_Segmentation__c,Contact_Name__r.Years_At_Residence__c, Contact_Name__r.office_no_check_on_company_site__c, Contact_Name__r.SFDC_Dedupe_check__c, Contact_Name__r.PAN_Response__c, Contact_Name__r.Linkedin_check_result__c, Contact_Name__r.Google_check_result__c, Contact_Name__r.PAN__c, Contact_Name__r.Last_Modified_Date__c, Contact_Name__r.Name_of_the_PAN_holder__c, Contact_Name__r.Employer__r.Domain_Name__c, Contact_Name__r.Employer__r.Company_Category__c, Existing_Customer__c, Owned_Residence__c, Is_spouse_Working_Financial_CoApp__c, Loan_Application__r.Scheme_Master__c, Name, Contact_Name__r.Mobile__c, Loan_Application__r.Requested_ROI__c, Loan_Application__r.Sourcing_Channel__r.branch__c, Loan_Application__r.Referral__c, Loan_Application__r.Existing_Customer__c, Loan_Application__r.Account.Sourcing_Channel__r.branch__c, Update_CIBIL_Error__c, Descriptin__c, Type_of_Borrower__c, Re_Initiate_De_Dupe__c, Integrate_with_CIBIL__c, Contact_Name__c, Contact_Name__r.Name, Contact_Name__r.Customer_Profile__c,
                                          Contact_Name__r.Designation__c,Codified_CIBIL__c, Contact_Name__r.Employer_Name__c, Contact_Name__r.Qualification__c, Contact_Name__r.Address_1__c, Contact_Name__r.Total_Work_Experience_Yrs__c, Contact_Name__r.Current_experiance_in_Years__c,
                                          PD_Status__c, Bank_Status__c, FINANCIAL_VERIFICATION__c, Contact_Name__r.Address_2__c, FCU_Status__c, ITR_Status__c, Office_SE_Status__c, Office_SAL_Status__c, Contact_Name__r.Company_Category__c,
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
                                          Tele_PD__c, Physical_PD__c, CLINIC_HOSPITAL__c, PAN_Number__c, Employer_Check__c, PAN_Check__c ,RSA_flag__c,RSA_Loan_application_status__c,RSA_Remarks__c,Degree_Status__c,Khata_Certificate_Status__c,
                                          Plan_Status__c,Commencement_Certificate_Status__c,Address_Proof_Status__c,Shop_Act_License_Status__c,Occupation_Certificate_Status__c,Property_Tax_Receipt_Status__c,Verification_ID_Proof_Status__c,Vehicle_Registration_number__c,Vehicle_Registration_date__c,CKYC_No__c,Identity_Document_No__c,Identity_Document_Expiry_Date__c,Proof_of_Address_Submitted_for_Permanent__c,Proof_of_Identity__c,DeDupe_Counter__c, movedToCibilTemp__c,Drop_Line_Flexi_Period__c,Office_Email_Id_Verified__c,Domain_Check_Result__c,IP_Address_Timestamp__c
                                          from Applicant__c where Loan_Application__c =: oppObj.Id  and Applicant_Type__c= 'Primary' LIMIT 1 ];
            if(!CommonUtility.isEmpty(appList)) dss.applicantPrimary = appList.get(0);
            //Office Email Verification
            String otpVal = GeneralUtilities.generateOTPPwd(5);
            contObj.One_Time_Password__c = otpVal;
            Map <String, String> mapObj = new Map <String, String>();
            mapObj.put('Account',JSON.serialize(accObj));
            mapObj.put('Contact',JSON.serialize(contObj));
            mapObj.put('Opportunity',opp);
            
            callOfficeEmailVerify(mapObj);
            gensendSMS(oppObj,null,'On Email Verification'); //20939 Hrushikesh Added
            contObj.Office_Email_sent__c = true;
            if(contObj.Id != null)
            {
                contObj.Employer__r = null; //added for bug 22071 Prashant
                update contObj;                                                                                      
            }                                                                                     
            if(accObj.Id != null)
                update accObj; 
            //call officle email Domain Check
            Map <String, String> domain_mapObj = new Map <String, String>();
            domain_mapObj.put('oppid',oppObj.id);
            domain_mapObj.put('grouptype','salaried');
            domain_mapObj.put('grouptype','Individual');
            domain_mapObj.put('product',oppObj.Product__c);
            if(!Test.isRunningTest()){
                //SalesDemographicDetailsCtrl sobj = new SalesDemographicDetailsCtrl(oppObj.id,'Individual','salaried', oppObj.Product__c);
                // System.debug('Applicant data here'+sobj.apps);
                // sobj.callEmailDomainCheck(sobj.apps); 
                emaildomainnew(domain_mapObj);
                
            }
            
            dss.objCon = contObj;
            dss.accObj = accObj;
            dss.status = 'success';
            /*Bug 20939 s*/
            List < SOL_Policy__c > policyList = new List < SOL_Policy__c > ();
            SOL_Policy__c  SolObj = new  SOL_Policy__c ();
            policyList = [select id, Policy_Name__c,New_Address_Value__c ,Old_Address_Value__c,Policy_Status__c,Loan_Application__c,Checklist_Policy_Status__c, Applicant_Name__c from SOL_Policy__c where Loan_Application__c = : oppObj.Id AND Name LIKE 'Sales2.0 Office Email Verification' limit 1];
            if(!CommonUtility.isEmpty(policyList) && policyList[0].Policy_Name__c.contains('Office Email Verification')){
                SolObj = policyList[0];
            }
            else{
                SolObj = new SOL_Policy__c();
                SolObj.Name = 'Sales2.0 Office Email Verification';
                SolObj.Policy_Name__c = 'Office Email Verification';
                SolObj.Loan_Application__c = oppObj.Id;
            }
            SolObj.RetriggerBRE__c = false;
            upsert SolObj;
            triggeredBRE.add('Office Email Verification'); /*Bug 20939 e*/
        }
        catch(Exception e)
        {
            System.debug('Exception'+e.getMessage()+' at Line Number: ' + e.getLineNumber());
            dss.status = 'Error while processing';
        }
        return JSON.serialize(dss);
    }
    @Future(callout=true)
    public static void emaildomainnew(Map<String,String> domain_mapObj){
        String oppid =  domain_mapObj .get('oppid');
        // domain_mapObj .get('grouptype','salaried');
        // domain_mapObj .get('grouptype','Individual');
        String product = domain_mapObj .get('product');
        SalesDemographicDetailsCtrl sobj = new SalesDemographicDetailsCtrl(oppid,'Individual','salaried',product);
        sobj.callEmailDomainCheck(sobj.apps); 
    }
    /*20939 changed body from email template */
    @Future(callout=true)
    public static void callOfficeEmailVerify(Map<String,String> objMap){
        Account accObj =  (Account)JSON.deserialize(objMap.get('Account'),Account.class);
        Contact contObj = (Contact)JSON.deserialize(objMap.get('Contact'),Contact.class);
        Opportunity newOpp = (Opportunity)JSON.deserialize(objMap.get('Opportunity'),Opportunity.class);
        
        String[] bccArray;
        String replyURL = '';
        Mid_office_BRE_flow__c BRE_Flow = Mid_office_BRE_flow__c.getValues('BRE Flow');
        replyURL = BRE_Flow.OTPV2_office_email_confirmantion__c;
        //replyURL = 'otpofficeemailverification@34k987r20n7nuqtptamfca3kobca6a2a0phqwkxpfyu2qakx9b.n-b4nrmac.cs6.apex.sandbox.salesforce.com';
        BAFL_EmailServicesLogix.EmailServicesPort stub = new BAFL_EmailServicesLogix.EmailServicesPort();
        stub.timeout_x = 120000;
        
        String[] ccArray;
        ccArray = new String[] {};
            if(Test.isRunningTest())
            contObj = [select Sex__c,Permanent_Pin_Code__c,FirstName,LastName,One_Time_Password__c,Permanent_State__c,Office_Email_sent__c,Permanant_City__c,months_of_Residence__c,Permanant_Address_Line_2__c,Permanant_Address_Line_1__c,Permanant_Address_Line_3__c, Address_1__c , Address_2__c , Address_3__c , Residence_City__c , State__c , Occupation_CKYC__c , Address_Line_One__c , Address_2nd_Line__c , Address_3rd_Line__c , Office_Pin_Code__c , Office_Phone_Number__c , Office_City__c , Office_State__c , Email , Marital_Status__c , Father_Spouse__c , Father_Spouse_Salutation__c , Father_Spouse_First_Name__c , Father_Spouse_Last_Name__c , Mother_First_Name__c , Mother_Last_Name__c , Residence_Type__c ,id,Name,Office_Email_Id__c from contact where id =: contObj.id];
        
        System.debug('contObj.Name****'+contObj.Name+'  '+contObj.FirstName+'contObj.Office_Email_Id__c'+contObj.Office_Email_Id__c);
        String intBody;
        if (contObj.Name != null && contObj.Office_Email_Id__c != null) {
            List<EmailTemplate> emailTemp = [SELECT Id,HTMLValue,Body,Name from EmailTemplate where Name = 'SAL/PL Office Email Verification -Cust'];
            EmailTemplate em = emailTemp[0];
            intBody = em.HTMLValue;
            if(intBody != null){
                intBody = intBody.replace('"','\\"');
                intBody = intBody.replaceAll('<p>\\s','<p>');
                intBody = intBody.trim();
                intBody = intBody.replaceAll('(\\s+)', ' ');
                intBody = intBody.replace('**LAN**',newOpp.Loan_Application_Number__c);
                intBody = intBody.replace('**Customer Name**',contObj.Name);
                intBody = intBody.replace('**OTP**',contObj.One_Time_Password__c);
                intBody = intBody.replace('**Click here**','<a href=\\"'+Label.bflsiteuserURL+'/SAL_PLTBVerification?Id='+newOpp.Id+'&EmailFor=OfficeEmailVerifyOpp\\" target=\\"_blank\\" style=\\"color:#000;text-decoration:none;\\"><strong><u>Click here </u></strong></a>');
                
            }
            
            
            String emailAddr = contObj.Office_Email_Id__c;
            System.debug('body'+intbody);
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
                                                                                      newOpp.Loan_Application_Number__c + ' : ' + contObj.Name,
                                                                                      intBody,
                                                                                      'bajaj');
            contObj.Office_Email_sent__c = true;
            update contObj;                                                                                      
            
            
        }
        
    }
    public static String getOpportunity(String oppId , String objectFieldJSON) {
        oppData dss = new oppData();
        dss.picklistData = LighteningUtilities.getPicklistValues(objectFieldJSON);
        User UserInfoDetails = [select id, Profile.Name, Name from User where id = : UserInfo.getUserId() LIMIT 1];
        System.debug('--UserInfoDetails --' + UserInfoDetails);
        dss.isCommunityUsr = CommonUtility.hasCommunityProfile(new Set<String>{UserInfoDetails.Profile.Name});
        getAllData(oppId,dss);
        getCriticalDemog(dss,dss.oppList,oppId,dss.dedupeList);//US 524
        List<String> options = new List<String>();
        system.debug('inside getDisposition pk1'+dss.opp.Product__c);
        String product = dss.opp.Product__c;
        Map<String,List<String>> dependentData = DynamicFieldsController.getFieldDependencies('Opportunity','Product__c','Reject_Reason__c');
        if(dependentData.containsKey(product))
        {
            options = dependentData.get(product);
        }
        dss.options = options;
        system.debug('inside getDisposition pk1'+product);
        system.debug('inside getDisposition pk2'+options);
        System.debug('loan opp-->');
        String responsedata = JSON.serialize(dss);
        return responsedata;
    }
    //Bug 22624 Rohit start
    public static CibilDetailsWrapper prepareCibilData(Id cibilId){
        
        CibilDetailsWrapper CibDetails = new CibilDetailsWrapper();
        DetailedCibilReportPageController.cibilId = cibilId;
        DetailedCibilReportPageController.switchSf1 = true;
        DetailedCibilReportPageController detailCntrl = new DetailedCibilReportPageController();
        
        CibDetails.cibil = detailCntrl.extnAccounts;
        CibDetails.pl = detailCntrl.pl;
        CibDetails.hl = detailCntrl.hl;
        CibDetails.cd = detailCntrl.cd;
        CibDetails.al = detailCntrl.al;
        CibDetails.card = detailCntrl.card;
        CibDetails.el= detailCntrl.el;
        CibDetails.tw = detailCntrl.tw;
        CibDetails.od = detailCntrl.od;
        CibDetails.gl= detailCntrl.gl;
        CibDetails.pllive= detailCntrl.pllive;
        CibDetails.hllive = detailCntrl.hllive;
        CibDetails.allive= detailCntrl.allive;
        CibDetails.cardlive= detailCntrl.cardlive;
        CibDetails.ellive= detailCntrl.ellive;
        CibDetails.cdlive = detailCntrl.cdlive;
        CibDetails.twlive= detailCntrl.twlive;
        CibDetails.odlive= detailCntrl.odlive;
        CibDetails.gllive= detailCntrl.gllive;
        CibDetails.totaldpd= detailCntrl.totaldpd;
        CibDetails.pldpd = detailCntrl.pldpd;
        CibDetails.hldpd= detailCntrl.hldpd;
        CibDetails.aldpd= detailCntrl.aldpd;
        CibDetails.carddpd= detailCntrl.carddpd;
        CibDetails.eldpd= detailCntrl.eldpd;
        CibDetails.cddpd= detailCntrl.cddpd;
        CibDetails.twdpd= detailCntrl.twdpd;
        CibDetails.oddpd= detailCntrl.oddpd;
        CibDetails.gldpd= detailCntrl.gldpd;
        CibDetails.plenq= detailCntrl.plenq;
        CibDetails.hlenq= detailCntrl.hlenq;
        CibDetails.alenq= detailCntrl.alenq;
        CibDetails.cardenq= detailCntrl.cardenq;
        CibDetails.elenq= detailCntrl.elenq;
        CibDetails.cdenq= detailCntrl.cdenq;
        CibDetails.twenq= detailCntrl.twenq;
        CibDetails.odenq= detailCntrl.odenq;
        CibDetails.glenq= detailCntrl.glenq;
        CibDetails.liveAccounts = detailCntrl.liveAccounts;
        CibDetails.closedAccounts = detailCntrl.closedAccounts;
        
        return CibDetails;
    }
    //Bug 22624 Rohit stop
    /*Sales 2.0 added by Krish s*/
    public static String getCardData (String oppId,string objectFieldJSON){
        System.debug('oppId-->'+oppId);
        oppData dss = new oppData();
        getAllData(oppId,dss);
        //Bug 22624 Rohit start
        CibilDetailsWrapper CibDetails = new CibilDetailsWrapper();
        //System.debug('rohit --> '+dss.cibilobj.id);
        if(dss.cibilobj != null){
            CibDetails = prepareCibilData(dss.cibilobj.id);
        }
        
        dss.CibDetails = CibDetails;
        //Bug 22624 Rohit stop
        try
        {
            dss.picklistData = LighteningUtilities.getPicklistValues(objectFieldJSON);
            Opportunity oppDSS = dss.opp;
            String profileName = dss.myProflieName;
            if(oppDSS != null)
            {
                if(oppDSS.Product__c != 'SAL' && oppDSS.Product__c != 'SPL')
                {
                    dss.msgStatus =  'This action is not applicable for given product.';
                }
                else 
                {
                    dss.msgStatus = 'NO_ERROR';
                }
                
                if(oppDSS.StageName == 'DSA/PSF Login')
                {                       
                    if(profileName == 'System Administrator' || profileName == 'Sys Admin Persistent' || profileName == 'Sales Co-Ordinator' || profileName == 'Sourcing Partners' || profileName == 'Area Sales Manager' || profileName == 'Partner Pro PSF' || profileName == 'Partner Pro PSF For SAL' || profileName == 'Partner Mortgage Psf' || profileName == 'Partner PSBL PSF' || profileName == 'Area Relationship Manager' || profileName == 'Mortgage Area Sales Manager' || profileName == 'Zonal Sales Manager' || profileName == 'National Sales Manager' || profileName == 'Regional Sales Manager' || profileName == 'Product Support' || profileName == 'Product Manager' || profileName == 'RSA Manager' || profileName == 'Referral Partners' || profileName == 'SAL Tele Calling Team' || profileName == 'Lead Verifier' || profileName == 'Regional Sales Manager Without reports' || profileName == 'FD Area Sales Manager' || profileName == 'PSF Profile'|| profileName == 'CPA Login Partner' || profileName == 'Area Relationship Manager' || profileName == 'Digital Lounge Business Head' || profileName == 'Digital Lounge National Head' || profileName == 'Digital Lounge PSF' || profileName == 'Digital Lounge Quality Manager' || profileName == 'Digital Lounge Relationship Manager' || profileName == 'Digital Lounge Senior Manager' || profileName == 'Digital Lounge Subject Matter Expert' || profileName == 'Digital Lounge Team Manager' || profileName == 'Regional Relationship Manager' || profileName == 'Zonal Relationship Manager' || profileName == 'Rural Tele Calling Team' || profileName == 'Partner Pro PSF for SAL-PL' )
                    {
                        dss.msgStatus = 'NO_ERROR';
                    }
                    else 
                    {
                        dss.msgStatus = 'This action is not applicable for current user.';
                    }
                }
                else
                {
                    dss.msgStatus = 'This action is applicable only when stage is DSA/PSF Login.';
                }
            }
        }
        catch(Exception e)
        {
            System.debug('inside getcarddata details'+e.getMessage()+e.getLineNumber()+e.getCause());
        }
        system.debug('JSON.serialize(dss)>>'+JSON.serialize(dss));
        return JSON.serialize(dss);
    }
    /*Sales 2.0 added by Krish e*/
    public class oppData {
        public String ckycStatus;//23578
        public String sourCateg;//CR 23820/22018 Rohit
        public Boolean impsRepAcc = false; //24997
        public CibilDetailsWrapper cibDetails;//Bug 22624 Rohit
        public Boolean rsaVeriDone = true; //20939 RCU
        public String product; //added by swapnil fro RSL mobility 22018 22485
        public List<Verification_Agency_Master__c> veriAgency; //20939 RCU
        public List<ContentDocumentLink > veriAtt; //20939 RCU
        public Boolean reTriggerIM = false;//20939 IM
        public Map<String,Map<String,String>> cityList; //City CR
        public String NoOfSolPolicyWithBreFlagTrue;/*Bug 20939*/
        public Tat_Master__c tatMasterRecord;
        public Contact objCon;
        Public User loginuser;
        public Map<String, Map<String, List<String>>> picklistData;
        public map<string,List<LightningDocumentWrapper>> checklistdocument;
        public Opportunity opp;
        //Bug id 20939 RCU start
        public String  DemogChange;
        public String  DemogAction;
        public Boolean isCriticalChange;
        public list<Opportunity> oppList;
        public Map<String,Object> criticalDemogMap;
        //Bug id 20939 RCU end 
        public String theme;
        public String myProflieName;
        public Applicant__c applicantPrimary;
        public Applicant__c currApp;
        public Account accObj;
        public eKYC__c ekycobj;
        public Product_Offerings__c poobj;  
        public List<SObject> attchements;
        public List<String> applicantNameList;
        public List<Bank_Account__c> bankList;
        public List<String> bankNameList;
        public List<String> options; 
        public List<Applicant__c> allApps;
        public List<Contact> allCons;
        public boolean isCommunityUsr;
        public boolean dsaUser;
        public CAM__c camObj;
        public SurrogateCAM__c srcamObj;
        public Bank_Account__c bankObj;
        public List<TelePDQuestionMaster__c> posList;
        public List<Verification__c> veriList;
        public List<De_Dupe__c> dedupeList;
        public List<SOL_Policy__c> SOLPolicyList;
        public List<SOL_Policy__c> addOnSolList;//Bug 24667
        public SOL_Policy__c solObj = new SOL_Policy__c();//Bug 24667
        public String noAddonCards;//Bug 24667
        public List<SOL_Policy__c> PanCheckSOlPolicy;
        public Boolean isPreapproved;
        public  Cibil_Extension1__c cibilExt1;
        public  Cibil_Extension__c cibilExt;
        public  CIBIL__c cibilobj;
        public List<CUSTOMER_INFO__c> customerList;
        public  Cibil_Temp__c cibilTempobj;
        public List<CIBIL_secondary_match__c> secondarycibilList;
        public Current_Disbursal_Details__c disObj = new Current_Disbursal_Details__c();
        public RePayment_mode_detail__c repObj = new RePayment_mode_detail__c(); //17556
        public Set<String> topUpList;
        public Set<String> BTList;
        //rohit added for submit to sales S
        public Boolean isTeleCaller;
        public Boolean isFieldAgent;
        public Boolean isPLTB;
        //rohit added for submit to sales E
        //Rohit added for PanCheck S
        public List<SALMobilityCntrl_V2.PanCheckWrapper> panCheckList;
        //Rohit added for PanCheck E
        //hrushikesh added below variables
        public String currentTheme;
        public Sourcing_Channel__c defaultSourcingChannelName;       
        public Boolean dsaFlowFlag;         //for dsaFlowFlag set unset
        public Map<String,Object> mobMap;
        public String status;
        public String Perfiosstatus;
        public String msgStatus;
        //Rohit added for user id S
        public String userId;
        public String BranchName;
        //Rohit added for user id E
        /* Bug : 17139  */
        List<SALMobilityOppCntrl_V2.PDquestionslist> allpdquestions;
        public List < Discrepancy__c > sanctionList = new List < Discrepancy__c >();
        public List < Discrepancy__c > existingDisList = new List < Discrepancy__c >();
        public List<Current_Disbursal_Details__c> disburement= new List < Current_Disbursal_Details__c >();
        public List<RePayment_mode_detail__c> repayList= new List < RePayment_mode_detail__c >();
        public Personal_Discussion__c pdObj;
        public List <DPLinsurance__c> insuranceList = new List<DPLinsurance__c>();
        public List<String> statesEkyc = new List<String>();
        public string contentId;
        public List<Deviation_Master__c> devList = new List<Deviation_Master__c>();
        public List<SALMobilityCntrl_V2.SelectOption> creditofcList = new List<SALMobilityCntrl_V2.SelectOption>();
        public List<String> dsaPsfTat;
        public map<String,String> emiCardoptions;//22017
        public map<String,String> eliteCardoptions;//22017
        public Boolean isValidIM_Products; //Bug: 22018 RSL Mobility
        public String maxLimitROI; //Sprint 5C 22624
        public String TatTime;
        public List<SMS_Sent__c> ckycsms;//23578  
        
    }
    
    public static List<Applicant__c> retApplicants(Id recId){
        system.debug('recId'+recId);
        if(recId != null)
            return [SELECT eKYC_Processing__c,id,Proof_of_Residence_Address_Submitted__c,Proof_of_Registered_Address_Submitted__c,Proof_of_Address_Submitted_for_Permanent__c,Company_Name__c,Type_of_Borrower__c,Company_Type__c,Customer_Name__c, DeDupe_Counter__c, movedToCibilTemp__c, Contact_Name__c, Contact_Name__r.id,Refferal_Identifier__c,Subscribed_to_Credit_Vidya__c,Financial_Health_Check_Guide__c,ROI_PO__c,Pure_Flexi_Period__c,Pure_Flexi_EMI__c,Drop_Line_Flexi_Period__c,Vehicle_Registration_number__c,Vehicle_Registration_date__c,CKYC_No__c,Identity_Document_No__c,Identity_Document_Expiry_Date__c,Proof_of_Identity__c,Contact_Name__r.Pin_Code__c,Contact_Name__r.Address_1__c,Contact_Name__r.Address_2__c,Contact_Name__r.Address_3__c,Contact_Name__r.Name,Contact_Name__r.Mobile__c,Applicant_Type__c,Customer_ID__c,Contact_name__r.Date_of_Birth__c,Contact_Name__r.PAN_Number__c,Contact_Name__r.CIBIl_Score__c FROM Applicant__c where Loan_Application__c =: recId];
        else
            return null;
    }
    /*Sales 2.0 added by Krish s*/
    public static String retApplicantsData(Id recId){
        system.debug('inside'+recId);
        oppData data = new oppData();
        List<Applicant__c> allApp = new List<Applicant__c>();
        allApp = [select  /*23578 S*/Data_Source__c,/*23578 E*//*City CR s*/Proof_of_Residence_Address_Submitted__c,Contact_Name__r.State__c,/*City CR e*/Proof_of_Registered_Address_Submitted__c,Financial_Health_Check_Guide__c,Elite_Card__c,Cibil_Retrigger_Initiated__c,Company_Name_as_per_Domain_check__c,Domain_Email_Remark__c,PANBREDone__c,/*Ekyc Start */Consent_on_app_form__c,eKYC_Processing__c,HashCode__c,/*Ekyc stop */id,Risk_Segmentation__c,Contact_Name__r.Years_At_Residence__c, Contact_Name__r.office_no_check_on_company_site__c, Contact_Name__r.SFDC_Dedupe_check__c, Contact_Name__r.PAN_Response__c, Contact_Name__r.Linkedin_check_result__c, Contact_Name__r.Google_check_result__c, Contact_Name__r.PAN__c, Contact_Name__r.Last_Modified_Date__c, Contact_Name__r.Name_of_the_PAN_holder__c, Contact_Name__r.Employer__r.Domain_Name__c, Contact_Name__r.Employer__r.Company_Category__c, Existing_Customer__c, Owned_Residence__c, Is_spouse_Working_Financial_CoApp__c, Loan_Application__r.Scheme_Master__c, Name, Contact_Name__r.Mobile__c, Loan_Application__r.Requested_ROI__c, Loan_Application__r.Sourcing_Channel__r.branch__c, Loan_Application__r.Referral__c, Loan_Application__r.Existing_Customer__c, Loan_Application__r.Account.Sourcing_Channel__r.branch__c, Update_CIBIL_Error__c, Descriptin__c, Type_of_Borrower__c, Re_Initiate_De_Dupe__c, Integrate_with_CIBIL__c, Contact_Name__c, Contact_Name__r.Name, Contact_Name__r.Customer_Profile__c,
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
                  (SELECT id,Date_Reported1__c,Date_Reported2__c,Date_Reported3__c,Date_Reported4__c,Suit_Filed_Status20__c,Suit_Filed_Status21__c,Suit_Filed_Status22__c,Suit_Filed_Status23__c,Suit_Filed_Status24__c,Suit_Filed_Status25__c,Suit_Filed_Status26__c,Suit_Filed_Status27__c,Suit_Filed_Status28__c,Suit_Filed_Status29__c,X90_DPD_6_months__c, Asset_classification_view__c, X30_DPD_CC__c, DPD_CC__c,X30_DPD_Gold_Loan__c, Total_current_outstanding__c, Suit_Filed__c, Settlement_Status__c, written_off_settled_status__c,Unsecured_to_Secured_ratio__c,No_of_PL_Enq_in_Last_3_Months__c FROM CIBIL_Extension__r),(SELECT id,DPD_cluster_Segment__c FROM Cibil_Temps__r),(select Applicant__r.name,applicant__r.Contact_Name__r.name, id,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              Address_Line1__c,Address_Line2__c, Address_Line3__c, Address_Line4__c 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ,State1__c, State2__c, State3__c, State4__c
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ,Pin_Code1__c, Pin_Code2__c, Pin_Code3__c, Pin_Code4__c,initiatedFor__c, Cibil_Temp__r.CIBIL_Score__c, SecondaryMatch_Record__c  
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              from  CIBIL_secondary_match__r where CIBIL__r.CIBIL_Extension__r.Cibil_Temp__r.SecondaryMatch_Record__c != true and CIBIL__c != null ORDER BY CreatedDate desc),(SELECT id,X30_DPD_6_months__c,No_of_Live_PL__c,No_of_PL_Enq_in_Last_6_Months__c ,No_of_PL_Enq_in_Last_12_Months__c,Sum_of_Amount_Overdue__c FROM Cibil_Extension1s__r)  
                  //Added RSA related Fields By Rajendra for bug id 11714
                  ,RSA_flag__c,RSA_Loan_application_status__c,RSA_Remarks__c,Degree_Status__c,Khata_Certificate_Status__c,
                  Plan_Status__c,Commencement_Certificate_Status__c,Address_Proof_Status__c,Shop_Act_License_Status__c,Occupation_Certificate_Status__c,Property_Tax_Receipt_Status__c,Verification_ID_Proof_Status__c,Vehicle_Registration_number__c,Vehicle_Registration_date__c,CKYC_No__c,Identity_Document_No__c,Identity_Document_Expiry_Date__c,Proof_of_Address_Submitted_for_Permanent__c,Proof_of_Identity__c,DeDupe_Counter__c, movedToCibilTemp__c,Drop_Line_Flexi_Period__c,Office_Email_Id_Verified__c,Domain_Check_Result__c,IP_Address_Timestamp__c
                  from Applicant__c where Loan_Application__c =: recId];
        Set<Id> conId = new Set<Id>();
        for(Applicant__c app : allApp){
            conId.add(app.Contact_Name__c);
        }
        List<Contact> allCon = new List<Contact>();
        allCon = [SELECT Father_Spouse__c,Father_Spouse_Salutation__c,Occupation_CKYC__c,Mother_Last_Name__c,Mother_Middle_Name__c,Mother_First_Name__c,Father_Spouse_Last_Name__c,Father_Spouse_Middle_Name__c,Father_Spouse_First_Name__c,Employer__r.Name,Special_Profile_Employer__c,Residence_Landline_phone__c,Designation_type__c,id,DesignationOTP__c ,Permenant_Phone__c ,Permanent_STD__c ,Permanent_State__c ,Aadhar_Number__c ,Extension_Number__c ,Gender__c,Current_experiance_in_Years__c,bank_name1__c , CIN__c, DIN__c, Years_At_Residence__c, Name, FirstName, Relationship_Borrower__c, Customer_Profile__c, LastName, Middle_Name__c, Address_1__c, Address_2__c, Address_3__c,
                  AppCity__c, Pin_Code__c, STD_Code__c, Phone_Number__c, Mobile__c, FathersHusbands_Name__c,
                  Date_of_Birth__c, Age__c, Sex__c, Marital_Status__c, Dependents__c, Qualification__c, PassPort_Number__c,
                  Type_Of_Constitution__c, Relationship_with_Borrower__c, PAN_Number__c, ApplicantType__c,
                  Type_of_Borrower__c, State__c, Industry__c, Type_of_Rating__c, SSI_TIME__c, Rating_Loan__c,
                  Employer_Name__c, Address_Line_One__c, Address_2nd_Line__c, Address_3rd_Line__c, Permanent_Land_Mark__c,
                  Contact_Person_At_This_Address__c, Employer__c, Occupatipn__c, Year_in_Service_Business__c,
                  Office_Pin_Code__c, Office_STD_Code__c, Preferred_communication_address__c, Office_Contact_Number__c,
                  SME_SSI__c, Office_Email_Id__c, Office_State__c, Name_of_the_Company_Employer__c, Nature_of_Business__c,
                  Name_of_the_firm__C, Company_Type__c, Office_Contact_Person__c, Designation__c, Name_Of_The_Degree__c,
                  Service_Tax_Reg_Number__c, email__C, Office_City__c, Property_Owner__C, Customer_Type__c,
                  Occupation__c, Demat_A_C_No__c, DP_Details__c, Client_ID__c, EMI_Bounce_in_last_3_months__c,
                  Permanent_Address_same_as_Residence__c, Department__c, Name_of_Employer__c, Year_of_Incorporation__c,
                  Email, Office_Email_Id_for_Fraud__c, TAN_Number__c, Permanant_City__c, Net_Salary__c, Permanent_Mobile__c,
                  Permanent_Pin_Code__c, Residence_City__c, Permanant_Address_Line_1__c, Total_Work_Experience_Yrs__c,
                  Permanant_Address_Line_2__c, Permanant_Address_Line_3__c, Total_Work_Experience_Months__c,
                  Office_Landline_Number1__c, Office_Landline_Number2__c, Residence_Type__c,VoterID_Number__c, Employee_Number__c, Company_Category__c,Account.TIN_Number__c,Bank_Account_No__c,ROC_Regn_No__c,Office_Phone_Number__c,Mobile_Phone__c,Phone,MobilePhone,
                  /*Start of champion challenger changes*/
                  Business_Name__c
                  /*End of champion challenger changes*/,Customer_address_matches_with_eKYC__c/*OTP V3 -Anshita*/,Customer_address_matches_with_perfios__c /*OTP V3 - Anshita*/,Perfios_Address__c /*OTP V3- Anshita*/,Customer_address_matches_with_cibil__c/* OTP V3 - Anshita */
                  from Contact where id IN: conId];
        data.allApps = allApp;
        data.allCons = allCon;
        data.theme = UserInfo.getUiThemeDisplayed();
        system.debug('allApp'+allApp);
        return JSON.serialize(data);
    }
    
    public static String getCoApplicantData(String recId,String oppId,string objectFieldJSON){
        system.debug('oppId'+oppId);
        oppData data = new oppData();
        List<opportunity> oppList = [SELECT Name,AccountId,Processing_Fees__c,Loan_Application_Number__c from Opportunity where Id =: oppId];
        Opportunity oppObj = new Opportunity();
        if(oppList.size() > 0){
            oppObj = oppList[0];
        }
        List<Account> accList = [SELECT PAN_Check_Status__c,Type_of_Salary__c,Educational_Qualification__c,Offer_Inhanced__c,Type_of_Educational_Institution__c,Current_experiance_in_Month__c,Current_experiance_in_Years__c,Total_Work_Experience_Months__c,Total_Work_Experience_Yrs__c,Qualification__c,Gross_Salary_Turn_Over__c,Residence_TypeAcc__c,Id,Name, First_Name__c,PinCode__c,Area_Locality__r.id,Area_Locality__r.Name,Area_Locality__r.Affluence__c,Area_Locality__c,Last_Name__c,Middle_Name__c,Current_City__c,Current_State__c,Date_of_Birth__c,Mobile__c,PANNumber__c,Gender__c,DesignationOTP__c,Office_Address_1st_Line__c,Office_Address_2nd_Line__c,Office_Address_3rd_Line__c,Office_Pin_Code__c,Office_Landline_Number1__c,Permanent_Residence_Address1__c,Permanent_Residence_Address2__c,Permanent_Residence_Address3__c,Permanent_PinCode__c,Permanent_Telephone_Number__c,Current_Residence_Address1__c,Current_Residence_Address2__c,Current_Residence_Address3__c,Current_PinCode__c,Employer__c,Type_Of_Industry__c,Email_Id__c,Marital_Status__c,Employer__r.Name,EPFO_Result__c,Employer__r.Sub_Industry__c,Downsizing_Reasons__c,Preffered_Mode_to_Connect__c  from Account where Id =: oppObj.AccountId ];
        Account accObj = new Account();
        if(accList.size() > 0){
            accObj = accList[0];
        }
        system.debug('account'+accObj);
        data.opp = oppObj;
        data.accObj = accObj;
        
        data.picklistData = LighteningUtilities.getPicklistValues(objectFieldJSON);
        return JSON.serialize(data);
    }
    /*Sales 2.0 added by Krish e*/
    public static string generateChecklistDocumnet(String oppId)
    {
        oppData data = new oppData();
        System.debug('inside generateChecklistDoc'+ oppId);
        map<string,List<LightningDocumentWrapper>> docMap = new map<string,List<LightningDocumentWrapper>>();
        try{
            
            
            if(!CommonUtility.isEmpty(oppId)){
                SalesEligibilityDetailsCtrl sobj = new SalesEligibilityDetailsCtrl(oppId);
                sobj.grouptype = 'salaried';
                sobj.salPOFlow = false;
                sobj.LoanId  = oppId;
                sobj.isFromSales = true;
                if(!Test.isRunningTest())
                    sobj.callBREForDeviations(); 
                if(!CommonUtility.isEmpty(SalesEligibilityDetailsCtrl.mobilityerror)){
                    List<LightningDocumentWrapper> picklistVal  = new List<LightningDocumentWrapper>();
                    LightningDocumentWrapper  pickData = new LightningDocumentWrapper();
                    pickData.docName = 'Error while generating documents.';
                    picklistVal.add(pickData);
                    if(picklistVal != null && picklistVal.size() > 0){
                        docMap.put('ErrorMessage',picklistVal);
                    }
                }
                else{
                    List < SalesEligibilityDetailsCtrl.DocumentWrapper > docWrapperList = new List < SalesEligibilityDetailsCtrl.DocumentWrapper > ();
                    List < SalesEligibilityDetailsCtrl.DocumentWrapper > deviationDocWrapperList = new List < SalesEligibilityDetailsCtrl.DocumentWrapper > ();
                    docWrapperList  = sobj.docWrapperList;
                    deviationDocWrapperList = sobj.deviationDocWrapperList ;
                    system.debug('docWrapperList >>'+docWrapperList);
                    system.debug('deviationDocWrapperList >>'+deviationDocWrapperList);
                    /*if(docWrapperList != null && docWrapperList.size() > 0){
docMap.standardDocList = docWrapperList;
}
if(deviationDocWrapperList != null && deviationDocWrapperList.size() > 0){
docMap.deviationDocList = deviationDocWrapperList;
}*/
                    
                    List<LightningDocumentWrapper> standardDocList  = new List<LightningDocumentWrapper>();
                    List<LightningDocumentWrapper> deviationDocList  = new List<LightningDocumentWrapper>();
                    List<LightningDocumentWrapper> picklistVal  = new List<LightningDocumentWrapper>();
                    if(docWrapperList != null && docWrapperList.size() > 0){
                        
                        for(SalesEligibilityDetailsCtrl.DocumentWrapper documentObj : docWrapperList){
                            LightningDocumentWrapper  docObj = new LightningDocumentWrapper();
                            docObj.docName   = documentObj.docName; 
                            docObj.rowNum = documentObj.rowNum;
                            docObj.docFamObj = documentObj.docFamObj; 
                            docObj.showPicklist = documentObj.showPicklist; 
                            docObj.selectedDoc = documentObj.selectedDoc; 
                            List<string> docList = new List<string>();
                            if(documentObj.documentList != null && documentObj.documentList.size() > 0){
                                for(System.selectoption option :documentObj.documentList){
                                    docList.add(option.getvalue());
                                }
                            }
                            docObj.documentList = docList; 
                            docObj.singleDoc = documentObj.singleDoc; 
                            standardDocList.add(docObj);
                        }
                    }
                    docMap.put('standardDoc',standardDocList);
                    
                    if(deviationDocWrapperList != null && deviationDocWrapperList.size() > 0){
                        
                        for(SalesEligibilityDetailsCtrl.DocumentWrapper documentObj : deviationDocWrapperList){
                            LightningDocumentWrapper  docObj = new LightningDocumentWrapper();
                            docObj.deviationName    = documentObj.deviationName ; 
                            docObj.rowNum = documentObj.rowNum;
                            docObj.docFamObj = documentObj.docFamObj; 
                            docObj.showPicklist = documentObj.showPicklist; 
                            docObj.selectedDoc = documentObj.selectedDoc; 
                            List<string> docList = new List<string>();
                            if(documentObj.documentList != null && documentObj.documentList.size() > 0){
                                for(System.selectoption option :documentObj.documentList){
                                    docList.add(option.getvalue());
                                }
                            }
                            docObj.documentList = docList;  
                            docObj.singleDoc = documentObj.singleDoc;
                            deviationDocList.add(docObj);
                        }
                    }
                    docMap.put('deviationDoc',deviationDocList);
                    
                    if(docMap.size() > 0){
                        List<SObject> attchementsList = LighteningUtilities.getAllDocuments(oppId);
                        if(attchementsList.size() > 0)
                            data.attchements = attchementsList;
                    }
                    
                    LightningDocumentWrapper  pickData = new LightningDocumentWrapper();
                    List<string> checkSelectList = new List<string>{'Sales_Status__c'};
                        Map<String, Object> selectListNameMap  = new  Map<String, Object>();
                    selectListNameMap.put('Checklist__c',checkSelectList);
                    
                    pickData.picklistData = LighteningUtilities.getPicklistValues(JSON.serialize(selectListNameMap)); 
                    picklistVal.add(pickData);
                    if(picklistVal != null && picklistVal.size() > 0){
                        docMap.put('picklistDataList',picklistVal);
                    }
                    if(docMap.size() > 0){
                        data.checklistdocument = docMap;
                    }
                }
                
            }
            // }
        }
        catch(Exception error){
            List<LightningDocumentWrapper> picklistVal  = new List<LightningDocumentWrapper>();
            LightningDocumentWrapper  pickData = new LightningDocumentWrapper();
            pickData.docName = 'Error while generating documents.';
            picklistVal.add(pickData);
            if(picklistVal != null && picklistVal.size() > 0){
                docMap.put('ErrorMessage',picklistVal);
            }
            return null;
            
        }
        system.debug('docMap>>'+docMap);
        return JSON.serialize(data);
    }
    public static string saveAutoDev(String devList) {
        List<LightningDocumentWrapper> deviationList  = new List<LightningDocumentWrapper>();
        List<Checklist__c> chkList = new List<Checklist__c>();
        
        if(devList != null )
            deviationList = (List<LightningDocumentWrapper>)JSON.deserialize(devList, List<LightningDocumentWrapper>.class);
        for(LightningDocumentWrapper obj : deviationList){
            chkList.add(obj.docFamObj);
        }
        if(chkList.size() > 0)
            update chkList;
        return null;
    }
    public static string saveManDev(String devList) {
        List<LightningDocumentWrapper> deviationList  = new List<LightningDocumentWrapper>();
        List<Checklist__c> chkList = new List<Checklist__c>();
        
        if(devList != null )
            deviationList = (List<LightningDocumentWrapper>)JSON.deserialize(devList, List<LightningDocumentWrapper>.class);
        for(LightningDocumentWrapper obj : deviationList){
            chkList.add(obj.docFamObj);
        }
        if(chkList.size() > 0)
            update chkList;
        return null;
    }
    
    public static string createChecklist(String oppObj) {
        Opportunity loanApp = new Opportunity();
        if(oppObj != null )
            loanApp = (Opportunity)JSON.deserialize(oppObj, Opportunity.class);
        system.debug('op id is'+loanApp.Id);
        //23578 start
        List<Applicant__c> appLst = [SELECT Id,Loan_Application__c,Applicant_Type__c FROM Applicant__c WHERE Loan_Application__c = :loanApp.Id AND Applicant_Type__c ='Primary'];
        //23578 stop
        oppData data = new oppData();
        try{
            List<Document_Family__c> docFamilyMaster = [select id, Name, Documents__c, Is_OTP_Standard_Document__c from Document_Family__c where (Document_Code__c != null OR Deviation_Code__c != null)];
            Map < id, Document_Family__c > docFamilyMap = new Map < id, Document_Family__c > ();
            for (Document_Family__c docFam: docFamilyMaster) {
                docFamilyMap.put(docFam.id, docFam);
            }
            List<Checklist__c> checklistTrnxList = new List<Checklist__c>();
            checklistTrnxList = [select id,Status__c,Deviation_Master__r.Deviation_Type__c,Deviation_Master__r.Deviation_Description__c,DocumentFmlyName__r.Documents__c,Mitigants_Remark__c,Deviation_Master__r.Minimum_Approving_Authority__c, Sales_Status__c, CPA_Status__c, Document__c, Checklist_Parameter__c, Checklist_Parameter__r.Document_Family__r.Documents__c,
                                 Checklist_Parameter__r.Document_Family__r.Name, Checklist_Parameter__r.Mandatory__c, Mandatory__c,
                                 Checklist_Parameter__r.Active__c, Checklist_Parameter__r.Type_of_Document__c, Checklist_Parameter__r.DeviationMaster__c,
                                 Checklist_Parameter__r.Stages__c, Checklist_Parameter__r.Customer_Segmentation__c, Deviation_Master__r.Deviation_name__c, DocumentFmlyName__r.Name,
                                 Checklist_Parameter__r.DeviationMaster__r.Deviation_name__c, DocumentFmlyName__r.Document_Code__c, DocumentFmlyName__r.Deviation_Code__c, DocumentFmlyName__c,
                                 Deviation_Master__c, Manual__c, to_be_approved_by__c, Branch_Remark__c from Checklist__c
                                 where Loan_Application__c = : loanApp.Id
                                ];
            List<LightningDocumentWrapper> standardDocumentList  = new List<LightningDocumentWrapper>();
            List<LightningDocumentWrapper> deviationList  = new List<LightningDocumentWrapper>();
            List<LightningDocumentWrapper> manualList  = new List<LightningDocumentWrapper>();
            if (checklistTrnxList != null && checklistTrnxList.size() > 0) {
                
                
                Integer rowCount = 0;
                Integer devRowCount = 0;
                for (Checklist__c checkListTrnx: checklistTrnxList) {
                    if(checkListTrnx.Manual__c == false){
                        Document_Family__c docFamObj = new Document_Family__c();
                        docFamObj = (docFamilyMap.get(checkListTrnx.DocumentFmlyName__c));
                        if (docFamObj != null) {
                            system.debug('*outside ddev prepare' + checkListTrnx.Deviation_Master__c);
                            if (checkListTrnx.Deviation_Master__c != null) {
                                devRowCount += 1;
                                LightningDocumentWrapper wrapperObjForDev = new LightningDocumentWrapper(checkListTrnx, docFamObj.Documents__c, devRowCount); 
                                system.debug('wrapperObjForDev>>'+wrapperObjForDev);
                                deviationList.add(wrapperObjForDev);
                            } else {
                                rowCount += 1;
                                LightningDocumentWrapper wrapperObj = new LightningDocumentWrapper(checkListTrnx, docFamObj.Documents__c, rowCount); 
                                system.debug('wrapperObj>>'+wrapperObj);
                                standardDocumentList.add(wrapperObj);
                            }
                        }
                    }
                    else{
                        Document_Family__c docFamObj = new Document_Family__c();
                        docFamObj = (docFamilyMap.get(checkListTrnx.DocumentFmlyName__c));
                        if (docFamObj != null) {
                            system.debug('*outside ddev prepare' + checkListTrnx.Deviation_Master__c);
                            if (checkListTrnx.Deviation_Master__c != null) {
                                devRowCount += 1;
                                LightningDocumentWrapper wrapperObjForManDev = new LightningDocumentWrapper(checkListTrnx, docFamObj.Documents__c, devRowCount); 
                                //system.debug('wrapperObjForDev>>'+wrapperObjForDev);
                                manualList.add(wrapperObjForManDev);
                            } 
                        }
                    }
                }
            }
            map<string,List<LightningDocumentWrapper>> checkMap = new map<string,List<LightningDocumentWrapper>>(); 
            if(deviationList.size() > 0){
                checkMap.put('deviationDoc',deviationList);
            }
            if(manualList.size() > 0){
                checkMap.put('manualDoc',manualList);
            }
            if(standardDocumentList.size() > 0){
                checkMap.put('standardDoc',standardDocumentList);
            }  
            if(checkMap.size() > 0){
                List<SObject> attchementsList = LighteningUtilities.getAllDocuments(loanApp.Id);
                //23578 start
                if(!CommonUtility.isEmpty(appLst)){
                    List<SObject> primAttList = LighteningUtilities.getAllDocuments(appLst[0].Id);
                    if(!CommonUtility.isEmpty(primAttList))
                        attchementsList.addAll(primAttList);
                    
                }
                //23578 stop
                if(attchementsList.size() > 0)
                    data.attchements = attchementsList;
            }
            List<LightningDocumentWrapper> picklistVal  = new List<LightningDocumentWrapper>();
            LightningDocumentWrapper  pickData = new LightningDocumentWrapper();
            List<string> checkSelectList = new List<string>{'Sales_Status__c'};
                Map<String, Object> selectListNameMap  = new  Map<String, Object>();
            selectListNameMap.put('Checklist__c',checkSelectList);
            
            pickData.picklistData = LighteningUtilities.getPicklistValues(JSON.serialize(selectListNameMap)); 
            picklistVal.add(pickData);
            if(picklistVal != null && picklistVal.size() > 0){
                checkMap.put('picklistDataList',picklistVal);
            }
            if(checkMap.size() > 0){
                data.checklistdocument = checkMap;
            }
            List<Deviation_Master__c> deviations = [Select Id, Name, Deviation_Description__c, Deviation_Code__c, BRE_Deviation_Code__c from Deviation_Master__c
                                                    where Product__c = : loanApp.Product__c and Active_Flag__c = true and BRE_Deviation_Code__c != null
                                                   ];
            List<Deviation_Master__c> optionsDev = new List < Deviation_Master__c > ();
            for (integer i = 0; i < deviations.size(); i++) {
                optionsDev.add(deviations[i]);
            }
            data.devList = optionsDev;
        }
        catch(Exception e){
            return null;
        }
        return JSON.serialize(data);
    }
    /*Sales 2.0 added by Krish s*/
    public static List<Applicant__c> delCoApplicant(Id recId,List<Applicant__c> appList) {
        system.debug('appList'+appList.size()+recId);
        List<Applicant__c> appToDel = new List<Applicant__c>();
        List<Contact> conToDel = new List<Contact>();
        for(Integer i=0;i<appList.size();i++){
            if(appList[i].Id == recId){
                conToDel.add(new Contact(Id=appList[i].Contact_Name__c));
                appToDel.add(appList[i]);
                appList.remove(i);
            }
        }
        if(appToDel.size() > 0)
            delete appToDel;
        if(conToDel.size() > 0)
            delete conToDel;
        return appList;
    }
    /*Sales 2.0 added by Krish e*/
    public static String getOppBasedOnLAN(String LANnumber)
    {
        oppData dss = new oppData();
        List<opportunity> oppObj = [select id,LAN__c,Loan_Application_Number__c from opportunity where Loan_Application_Number__c = :LANnumber];
        if(!CommonUtility.isEmpty(oppObj))
            getAllData(oppObj[0].id,dss);
        system.debug('JSON.serialize(dss)>>'+JSON.serialize(dss));
        return JSON.serialize(dss);
    }
    public static String getOppDetails(String loanApplicationId,String objectFieldJSON ) {
        oppData dss = new oppData();
        getAllData(loanApplicationId, dss);
        //20939 added start
        //US 524 commented below code
        //getCriticalDemog(dss, dss.oppList, loanApplicationId, dss.dedupeList);
        //20939 added end
        system.debug('JSON.serialize(dss)>>' + JSON.serialize(dss));
        /* Sales compliance getallquestions third parameter added by swapnil false bug 22485*/
        if (!CommonUtility.isEmpty(loanApplicationId)) { //22018
            dss.allpdquestions = getallquestions(dss.isPreapproved, dss.pdObj, false, dss.Product); /* Bug : 17139  */ /* 22018 */
        }
        if(!CommonUtility.isEmpty(objectFieldJSON))
            dss.picklistData = LighteningUtilities.getPicklistValues(objectFieldJSON);
        List < String > options = new List < String > ();
        String product = dss.opp.Product__c;
        Map < String, List < String >> dependentData = DynamicFieldsController.getFieldDependencies('Opportunity', 'Product__c', 'Reject_Reason__c');
        if (dependentData.containsKey(product)) {
            options = dependentData.get(product);
        }
        dss.options = options;
        return JSON.serialize(dss);
    }
    
    
    public static String getUWOppDetails(String loanApplicationId)
    {
        oppData dss = new oppData();
        getAllData(loanApplicationId,dss);
        system.debug('JSON.serialize(dss)>>'+JSON.serialize(dss));
        return JSON.serialize(dss);
    }
    
    public static void getAllData(String oppId,oppData dss){
        //logic for DSA Flow -Hrushikesh
        dss.cityList = CommonUtility.city_stateMapping(); //City CR
        
        StaticResource staticresc;
        dss.theme = UserInfo.getUiThemeDisplayed();
        Map<String,Object> ALLMap = new Map<String,Object>();
        String jsnBody;
        staticresc = [SELECT Body,Id,Name FROM StaticResource WHERE Name = 'SalariedCustomSettings' limit 1]; 
        if(staticresc != null)
            jsnBody = staticresc.Body.toString();
        ALLMap = (Map<String,Object>)JSON.deserializeUnTyped(jsnBody);
        Map<String,Object> breMap =(Map<String,Object>)ALLMap.get('Mobility 2');
        dss.mobMap = breMap; //20939
        dss.criticalDemogMap=(Map<String,Object>)ALLMap.get('CriticalDemog'); //20939 RCU
        String profiles = (String)breMap.get('profiles');
        Set<String> profilesSet = new Set<String>();
        profilesSet.addAll(profiles.split(';'));
        System.debug('Hi code-> '+profilesSet);
        
        //Rohit added for userId S
        dss.userId = UserInfo.getUserId();
        //Rohit added for userId E
        Id profileId= userinfo.getProfileId();
        List<Profile> prof = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String profileName='';
        if(prof != null && prof.size() > 0)//soql optimization
            profileName=prof[0].Name; 
        system.debug('ProfileName'+profileName);
        dss.myProflieName = profileName;
        dss.dsaFlowFlag=false;      //initialize to false first
        User u = [select id,Profile.Name,Name,Branch_City__c,Email,Product__c,IsActive from User where id =: userInfo.getUserId()];//added Branch_City__c for Bug 17930(CR)
        dss.loginuser = u;
        dss.isCommunityUsr = CommonUtility.hasCommunityProfile(new Set<String>{u.Profile.Name});
        for(String profileString:profilesSet)
        {
            if(profileString.equalsIgnoreCase(profileName))
            {
                system.debug('inloop');
                dss.dsaFlowFlag=true;  //set flag=true
            }
        }
        String dsaProfile = (String)breMap.get('dsaProfile');
        Set<String> dsaSet = new Set<String>();
        dsaSet.addAll(dsaProfile.split(';'));
        dss.dsaUser = false;
        if(dsaSet != null){
            if(dsaSet.contains(profileName))
                dss.dsaUser = true;
        }
        System.debug('Dsaflow flag= '+dss.dsaFlowFlag);
        
        
        
        //end of DSA Flow Logic
        
        //Code for DefaultSourcing Channel
        System.debug('ONE');
        User oUser = u;/* [SELECT Id,Name,Profile.Name,Branch_City__c,Email,Product__c,IsActive
FROM User Where id =: userInfo.getUserId()];*///soql optimization
        
        system.debug('ouser'+oUser.Product__c+oUser.Email);
        List<Sourcing_Channel__c> sourcingChannelList = [SELECT Id,Branch__r.SAL_Branch_Type__c,Branch_Name__c,sourcing_channel_user__r.id,Branch__c,Branch__r.Name, Name,sourcing_channel_email_id__c,Active__c,Product__c, Reporting_Manager__c, Reporting_Manager__r.Email
                                                         FROM Sourcing_Channel__c
                                                         WHERE sourcing_channel_email_id__c = :oUser.Email
                                                         AND Active__c = true
                                                        ];
        Set<String> uProd = new Set<String>();
        if(oUser != null && oUser.Product__c != null)
            uProd.addAll(oUser.Product__c.split(';'));
        
        
        system.debug('sourcingChannelList++'+sourcingChannelList);                                                
        system.debug('oUser++'+oUser);                                                
        if(!CommonUtility.isEmpty(sourcingChannelList)){
            for(Sourcing_Channel__c sc : sourcingChannelList)
            {
                Set<String> srcProd = new Set<String>();
                if(sc.Product__c != null)
                    srcProd.addAll(sc.Product__c.split(';'));
                
                for(String prod : uProd){
                    
                    if(srcprod.contains(prod)){
                        system.debug('uProd'+prod+'src prod'+srcProd);
                        dss.defaultSourcingChannelName = sc;
                        //break;
                    }
                }
                //if(oUser.Branch_City__c!=null && sc.Branch_Name__c!=null && oUser.Branch_City__c.contains(sc.Branch_Name__c))
                
            }
            system.debug('po.sourcingChannelName++'+dss.defaultSourcingChannelName.Product__c);                                                    
        }
        //end of logic
        
        
        boolean ConvertedFromPO = false;
        if(!CommonUtility.isEmpty(oppId)){
            
            List<Opportunity> oppList = [SELECT Loan_Variant__c,/*25051 s */OwnerId/*25051 e*/,/*22018 s*/Sourcing_Channel__r.Channel_Category__c,/*22018 e*/Hold_Reason__c,/*SAL 2.0 CR s*/ Account.PinCode__c, /*SAL 2.0 CR e*/PAN_Number__c,/*22307*/Consider_for_Re_Appraisal__c,/*22182 s*/Scheme_Master__c,Loan_Amount_with_Premium__c,/*22182 e*//*US 524 s*/CUSTOMER__r.Demog_Error__c,/*US 524 e*/CUSTOMER__r.Name,POS__c,CUSTOMER__c,/*Bug id 20939 RCU start*/Account.DesignationOTP__c,CUSTOMER__r.PAN_Demog__c,CUSTOMER__r.Mobile_Demog__c,CUSTOMER__r.DOB_Demog__c,CUSTOMER__r.Bank_account_number_demog__c,CUSTOMER__r.Residence_demog__c,CUSTOMER__r.Last_Modified_date_Demog__c,Existing_Customer__c, Link_Offer_id__c,Account.Offer_Inhanced__c,/*Bug id 20939 end*/Created_Time__c, /*Pricing*/Area_SM__c, /*Pricing*/IFSC_Code__c ,A_C_No__c, Mode_of_Disbursal__c, Bank_Name__c, Account_Holder_Name__c, Favouring__c,MICR_Number__c ,Repayment_Account_Holder_Name__c, Bank_A_c_No_of_Customer__c, Repayment_Bank_Name__c, Repayment_Mode__c, First_Due_Date__c,  A_C_Type__c, Account.Flow__c,Relationship_Manager__c,Tenor__c,Approved_Rate__c,EMI_CAM__c,Requested_ROI__c,Sourcing_Channel__r.Id,Sourcing_Channel__r.Reporting_Manager__c,id,Industry__r.Industry__c,Offer_Amount__c,Reject_Reason__c,Name,StageName,Telecaller_Name__c,Customer_Type__c, Product__c,Main_Sub_Industry__c,Branch_Name__c,Branch_Name__r.SAL_Branch_Type__c, LAN__c, AccountId, Quality_Check_Status__c, Sourcing_Channel__c, Sourcing_Channel__r.Name, Referral__c, Referral__r.Name, Application_Source__c, Loan_Application_Number__c,Type_Of_Loan__c,COO_Comments__c,Approved_Loan_Amount__c,Scheme_Master__r.Name,Scheme_Master__r.IsHybridFlexi__c,Approved_Tenor__c,Processing_Fees__c,Branch_Name__r.name,/*US_982*/If_Yes__c,End_Use__c,/*US_982*/
                                         (select id from Product_Offerings__r),
                                         (select Business_Continuty__c,/*20939 RCU s*/Month1__c,Month2__c,Month3__c,/*20939 RCU e*/id,LAP_EMI__c,EMI_on_Proposed_Loan_TO__c,Avg_qtrly_incentive__c,Average_incentive_for_Q1__c,Average_incentive_for_Q3__c,Average_incentive_for_Q2__c,Maxi_EMI_Cust__c,Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c,Average_Monthly_Net_Income1__c,Applicable_FOIR1__c,Loan_Application__c,EMI_of_The_Loan__c,Receips5_Doc__c,Receips6_Doc__c,Unsecured_FOIR__c,Eligible_FOIR__c,Total_Mthly_Oblig__c,EMI__c,ROI__c,sal_max_loan__c,Net_Salary_for_Month1__c,Net_Salary_for_Month2__c,Net_Salary_for_Month3__c,Proposed_Loan_Amt__c,Tenor__c,Eligible_Loan__c,Monthly_Reimbursement__c,Avg_mthly_incntve_3mts__c,Rental_Income__c,Receips4_Doc__c,Existing_HL_EMI__c,Month1_Doc__c,Month2_Doc__c,Month3_Doc__c,LAP_pmt__c,Avg_monthly_incentive1__c,Avg_monthly_incentive2__c,Avg_monthly_incentive3__c,Incentive_Monthly_or_Quarterly__c 
                                          ,/*24997 s*/Gross_Salary_Month1__c,Gross_Salary_Month2__c,Gross_Salary_Month3__c/*24997 e*/ from CAMs__r),
                                         /*Bug 20939 s*/(select id,name,Policy_Name__c,/*Added for 22018 s*/Old_Address_Value__c,Applicant_Name__r.Contact_Name__r.Name,New_Address_Value__c,/*Added for 22018 e*/Remarks__c,Disposition_Status__c,Checklist_Policy_Status__c,/*24667 s*/Add_on_Holder_DOB__c,Add_on_Holder_Email__c,Add_on_Holder_First_Name__c,Add_on_Holder_Last_Name__c,Add_on_Holder_Middle_Name__c,Add_on_holder_Mobile__c,Add_on_Holder_Relation__c,Applicant_Name__c,Charge_Type__c/*24667 e*/ from SOL_Policys__r),/*Bug 20939 e*/
                                         //fields added for US 983 in next query
                                         (select Final_EMI__c,Status__c,Obligation__c,Financers__c,Loan_Type__c,POS__c,EMI__c , /*983*/Type_of_Oblig__c,Applicant__r.ContactName__c,Loan_Amount__c,Derived_EMI__c,Customer_Declared_EMI__c,Start_On__c,Principal_O_s__c,Applicant__c,MOB__c,Identifier__c/*983*/ from Existing_Loan_Details__r),
                                         (select /*20939 s*/Existing_cust_demog_change__c,Demog_change_action__c,/*20939 e*/Customer_Status__c,Dedupe_Source__c,Source_Or_Target__c from De_Dupes__r),
                                         (select /*CR 24122 s*/Perfios_Statement_Status_1__c ,Perfios_Statement_Status_2__c,Perfios_Statement_Status_3__c , /*CR 24122 e*/Salary_Credit_Date1__c,Salary_Credit_Date2__c,Salary_Credit_Date3__c,Perfios_inwardChqBounces__c,Perfios_inwardECSBounces__c,Perfios_Bank_Name__c from Bank_Account__r),
                                         (select id,IMPS_Count__c,UMRN__c,Disbursement_To__c, IMPS_Flag__c, Bank_Branch__c, name, Tranche_Detail__c, Loan_Application__c, Internal_Closure__c, Disbursement_Amount__c, Disbursal_Mode__c, Disbursement_Date__c,
                                          FinnOne_Disbursement_Date__c,Repay_Disb_Diff__c,Successful_IMPS_Count__c,Failure_IMPS_Count__c ,IFSC_Code__c, Favouring__c,isTopUp__c,Tranche_Detail__r.Tranche_Number__c, Bank_Name__c, Bank_Account__c, Payable_at__c, Credit_Days__c, IMPS_Result__c,Information_From__c
                                          from Current_Disbursal_Details_s__r),
                                         
                                         (select id,Question1__c,Question2__c,Question3__c,Question4__c,Question5__c,Question6__c,Question7__c,Question8__c,Question9__c,Question10__c,Question11__c,Question12__c,Question13__c,Question14__c,Question15__c,Question16__c,Question17__c,Question18__c,Question19__c,Question20__c,Question21__c,Question22__c,Question23__c,Question24__c,Question25__c,Question26__c,Question27__c,Question28__c,Question29__c,Question30__c,
                                          /*added for RSL Mobility bug 22018 s*/Question31__c,Question32__c,Question33__c,Question34__c,Question35__c,Question36__c,Question37__c,Question38__c,Question39__c,Question40__c,Question41__c,/*added for RSL Mobility bug 22018 e*/
                                          Type_of_PD__c,Tele_PD_Applicability__c,Name_of_the_applicant__c,PD_Conducted__c, PD_Ok__c,CO_comment__c from Personal_Discussion_s__r),
                                         (SELECT Id,/*22107 s*/Copy_Perfios_Details__c/* 22107 end*/, A_C_type__c,ECS_Barcode_No__c,Open_ECS_Facility__c, Open_ECS_Ex_Customer_Id__c, Open_Valid_till__c, Open_ECS_Max_Limit__c, ECS_Start_Date__c, ECS_End_Date__c, ECS_Amount__c, name, Loan_Application__c, A_C_NO__c, MICR_Code__c, PDC_START_DATE__c, IFSC_Code__c, Account_Holder_Name__c,Bank_Name__c, No_of_Cheques__c, Cheque_Serial_Number__c, Repayment_Mode__c, To_Cheque_Serial_Number__c, Cheque_Amount__c, Tranche_Detail__c, Bank_Branch__c, PDC_By_Name__c ,Loan_Application__r.CUSTOMER__c  ,Mandate_Process_Stage__c,UMRN__c FROM RePayment_mode_details__r)
                                         ,(select id,Insurance_Product__c from Insurance__r)
                                         ,(select /*20939 RCU s*/RSA_Reason__c ,Initiated_by_invisible_monitoring__c, /*20939 RCU e*/id, name, Status__c, Verification_Type__c,Credit_Status__c,Geo_Tagging__c,Image_Latitude_Longitude_Details__c from Verification__r) 
                                         from Opportunity where id = : oppId];            
            String imProductsStr ='';//22018 S
            if(ALLMap != null)
                imProductsStr = (String) ALLMap.get('ValidIM_Products');
            if(imProductsStr != null && imProductsStr!='')
                dss.isValidIM_Products =imProductsStr.contains(oppList[0].Product__c+';')?true:false; // Bug 22018 - RSL Mobility Hrushikesh 
            Account accObj = new Account(); 
            if(!CommonUtility.isEmpty(oppList)){
   //Added for Bug 24667 s
              // List<SOL_Policy__c> allSols = oppList[0].SOL_Policys__r;//commented for prod issue
                    if(!CommonUtility.isEmpty(oppList[0]) && !CommonUtility.isEmpty(oppList[0].SOL_Policys__r)){
                        List<SOL_Policy__c> addOnSolList =new List<SOL_Policy__c>();
                        List<SOL_Policy__c> addonLst = new List<SOL_Policy__c>();
                            for(SOL_Policy__c Sol : oppList[0].SOL_Policys__r){
                                if(Sol.Name == 'Sales 2.0 Add on Card'){
                                     addonLst.add(Sol);
                                     System.debug('sol obj '+sol.Add_on_Holder_First_Name__c);
                                }
                                
                            }
                            
                        dss.addOnSolList = addonLst;
                    }
                 //added for bug 24667 e
                dss.opp = oppList.get(0);
                /* Bug : 17556 S  Pricing */ 
                List<DPLinsurance__c> insuranceList =new List<DPLinsurance__c>();/* [select id from DPLinsurance__c where Opportunity__c =: oppId];*/// soql optimization
                if(!CommonUtility.isEmpty(oppList))
                {
                    dss.insuranceList =oppList[0].insurance__r; 
                }
                /* Bug : 17556 E */
                /*Critical demographics 20939 start*/
                dss.oppList=oppList;
                /*Critical demographics 20939 end*/
                //Bug 23820/22018 start
                if(oppList.get(0).Sourcing_Channel__r != null && oppList.get(0).Sourcing_Channel__r.Channel_Category__c != null)
                    dss.sourCateg = oppList.get(0).Sourcing_Channel__r.Channel_Category__c;
                else
                    dss.sourCateg = ''; 
                dss.Product = oppList[0].Product__c;//22018
                //Bug 23820/22018 stop  
                if(!CommonUtility.isEmpty(oppList) && !CommonUtility.isEmpty(oppList[0].Product_Offerings__r) ){
                    dss.isPreapproved = true;
                }
                else
                    dss.isPreapproved = false;
                /* Bug : 17139 S */
                if(!CommonUtility.isEmpty(oppList) && !CommonUtility.isEmpty(oppList[0].Personal_Discussion_s__r) ){
                    dss.pdObj= oppList[0].Personal_Discussion_s__r[0];
                }
                else 
                    dss.pdObj = new Personal_Discussion__c();
                /* Bug : 17139 E */
                List<Account> accList = [SELECT /*user story 985 s*/Send_Back_Reason__c,/*user story 985 e*/ Flow__c,/*22018 flow added*/Purpose_of_Facility__c,PAN_Check_Status__c,Preferred_language__c,Name_of_the_Company_Employer__c,Type_of_Salary__c,Educational_Qualification__c,Offer_Inhanced__c,Type_of_Educational_Institution__c,Current_experiance_in_Month__c,Current_experiance_in_Years__c,Total_Work_Experience_Months__c,Total_Work_Experience_Yrs__c,Qualification__c,Gross_Salary_Turn_Over__c,Residence_TypeAcc__c,Id,Name, First_Name__c,PinCode__c,Area_Locality__r.id,Area_Locality__r.Name,Area_Locality__r.Affluence__c,Area_Locality__c,Last_Name__c,Middle_Name__c,Current_City__c,Current_State__c,Date_of_Birth__c,Mobile__c,PANNumber__c,Gender__c,DesignationOTP__c,Office_Address_1st_Line__c,Office_Address_2nd_Line__c,Office_Address_3rd_Line__c,Office_Pin_Code__c,Office_Landline_Number1__c,Permanent_Residence_Address1__c,Permanent_Residence_Address2__c,Permanent_Residence_Address3__c,Permanent_PinCode__c,Permanent_Telephone_Number__c,Current_Residence_Address1__c,Current_Residence_Address2__c,Current_Residence_Address3__c,Current_PinCode__c,Employer__c,Type_Of_Industry__c,Email_Id__c,Marital_Status__c,Employer__r.Name,EPFO_Result__c,Employer__r.Sub_Industry__c,Downsizing_Reasons__c,Preffered_Mode_to_Connect__c   from Account where Id =: oppList.get(0).AccountId ];
                
                if(!CommonUtility.isEmpty(accList)){
                    accObj = accList[0];
                    dss.accObj = accObj ;
                    system.debug('accObj'+accObj.DesignationOTP__c);
                    /* Bug : 17139 S */                   
                    List<ContentDocumentLink> contentDocumentLinkRecords= [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:accObj.Id];
                    //Set<Id> resultIds = (new Map<Id,ContentDocumentLink>(contentDocumentLinkRecords)).keySet();
                    if(!CommonUtility.isEmpty(contentDocumentLinkRecords)){
                        List<id> resultIds = new List<Id>();
                        for(ContentDocumentLink cdObj :contentDocumentLinkRecords){
                            resultIds.add(cdObj.ContentDocumentId);
                        }
                        if(!CommonUtility.isEmpty(resultIds)){
                            List<ContentDocument> contentdocumentRecords= [Select Id ,Title from ContentDocument Where ID In :resultIds and title ='EPFO result' order by CreatedDate Desc limit 1];
                            if(!CommonUtility.isEmpty(contentdocumentRecords)){
                                dss.contentId = contentdocumentRecords[0].Id;
                            }
                        }
                    }
                    /* Bug : 17139 E  */
                }
            }
            //Tat calculation
            List<OpportunityFieldHistory> OppLst = [Select Field, CreatedDate,NewValue from OpportunityFieldHistory where Field= 'StageName' and OpportunityId =: oppId  ORDER BY CreatedDate DESC limit 1 ];
            if(!CommonUtility.isEmpty(OppLst)){
                system.debug('OppLst[0].CreatedDate-'+OppLst[0].CreatedDate);
                system.debug('current date-'+datetime.now());
                
                Long sysDate=datetime.now().getTime();
                Long dt2Long = OppLst[0].CreatedDate.getTime();
                String finalTatTime= getStageTime(sysDate,dt2Long);
                dss.TatTime= finalTatTime;
            }
            else
            {
                Long sysDate=datetime.now().getTime();
                Long dt2Long = oppList[0].Created_Time__c.getTime();
                String finalTatTime= getStageTime(sysDate,dt2Long);
                dss.TatTime= finalTatTime;
            }
            //Tat calculation end
            List<CAM__c> camList = [SELECT Business_Continuty__c,/*20939 RCU s*/Month1__c,Month2__c,Month3__c,/*20939 RCU e*/Multiplier__c,EMI_on_Proposed_Loan_TO__c,Secured_FOIR__c,LAP_EMI__c,Avg_qtrly_incentive__c ,Average_incentive_for_Q1__c,Approved_CAM__c,Average_incentive_for_Q3__c,Average_incentive_for_Q2__c,Maxi_EMI_Cust__c,Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c,Id,Proposed_Loan_Amt__c, ROI__c, Tenor__c, EMI_of_The_Loan__c, sal_max_loan__c,Eligible_FOIR__c,Receips5_Doc__c,Receips6_Doc__c,Unsecured_FOIR__c, Applicable_FOIR1__c, Loan_Application__c,Average_Monthly_Net_Income1__c,Net_Salary_for_Month1__c,Monthly_Reimbursement__c,Avg_mthly_incntve_3mts__c,Rental_Income__c,Receips4_Doc__c,Existing_HL_EMI__c,Total_Mthly_Oblig__c,EMI__c,Net_Salary_for_Month2__c,Net_Salary_for_Month3__c,Eligible_Loan__c,Month1_Doc__c,Month2_Doc__c,Month3_Doc__c,LAP_pmt__c,Avg_monthly_incentive1__c,Avg_monthly_incentive2__c,Avg_monthly_incentive3__c,Incentive_Monthly_or_Quarterly__c FROM CAM__c WHERE Loan_Application__c=:oppId];
            dss.camObj = new CAM__c();
            if(!CommonUtility.isEmpty(camList)){
                dss.camObj = camList[0];
                System.debug('Req loan amt'+camList.get(0));
            } 
            List<SurrogateCAM__c> srcamList = [SELECT id,Line_opted__c,Line_assigned_basis_Credit_Assessment__c,Expiry_Date_without_BT__c,Maximum_EMI_as_per_Multiplier__c FROM SurrogateCAM__c WHERE Loan_Application__c=:oppId limit 1];
            if(!CommonUtility.isEmpty(srcamList)){
                dss.srcamObj = srcamList[0];
            }
            List<De_Dupe__c> dedupelist = [select /*20939 s*/Existing_cust_demog_change__c,Demog_change_action__c,/*20939 e*/Applicant__r.Applicant_Type__c, Negative_Area__c,id, name,De_Dupe_Matched_Percentage__c, Dedupe_Lan_Matches__c, Applicant__c, Applicant__r.Contact_Name__c, Datafix_Updated__c, Application_Status__c,
                                           Application_ID__c, Random_Dedupe__c, Area_Status__c, Customer_Status__c, Applicant__r.Contact_Name__r.Name, Match_Status__c,
                                           Customer_ID__c, Dedupe_Comments__c, De_Dupe_result__c, De_Dupe_Decision__c, Segment__c, SF_Base__c, Source_Or_Target__c,Dedupe_Target_Remarks__c, Dedupe_Source__c,REJ_MATCHED_PRCNTG__c  from De_Dupe__c where Loan_Application__c = : oppId And Applicant__c != null order by Applicant__c,Source_Or_Target__c/*Bug 12114*/
                                          ];
            System.debug('Dedupe Query '+dedupelist);
            Set<String> dedupecutomerid = new Set<String>(); 
            if(!CommonUtility.isEmpty(dedupelist)){
                dss.dedupeList = dedupelist;
                
                for(De_Dupe__c dedupe:dedupelist)
                {
                    dedupecutomerid.add(dedupe.Customer_ID__c);
                }
            }
            System.debug('pk customerlistid'+dedupecutomerid);
            List<CUSTOMER_INFO__c> customerlist = new List<CUSTOMER_INFO__c>();
            if(!CommonUtility.isEmpty(dedupecutomerid)){
                customerlist= [select Id,Name from CUSTOMER_INFO__c where name IN :dedupecutomerid];
            }
            System.debug('pk customerlist'+customerlist);
            dss.customerList = customerlist;
            /*20939 RCU commented
List<Verification__c> AllVerify = [select id, name, Status__c, Verification_Type__c,Credit_Status__c,Geo_Tagging__c,Image_Latitude_Longitude_Details__c from Verification__c where Loan_Application__c = : oppId];
if(!CommonUtility.isEmpty(AllVerify)){
dss.veriList = AllVerify; 
}*/
            
            System.debug('oppId-->'+oppId);
            
            // contact con =  dss.objCon;
            List<Applicant__c> appList = [select Domain_Created_Date__c,/*7736*/ ASM_Comments__c,/*Swapnil employee Loan 20934 s*/ Emp_tele_identifier__c, Employee_Modified__c, /*20934 s*/ Decline_Reasons__c, /*20934 e*/ Customer_Decline_Reasons__c, ModifiedStatus__c, /*Swapnil employee Loan 20934 e*//*22624 s*/PFApproveStatus__c,/*22624 e*//*23578 S*/Data_Source__c,Proof_of_Residence_Address_Submitted__c,/*23578 E*//*22017 s*/EMI_Card__c,Elite_card_product__c,/*22017 end*//*Bug 20939*/aiding_underwritter__c,suspacted_pan_score__c,Score_card__c ,Loan_Application__r.Account.Flow__c,/*Bug 20939*//*20939 RCU s*/FORM_16__c,Contact_Name__r.State__c,KYC_Verifications__c, Contact_Name__r.Office_State__c, Contact_Name__r.Employer__c, Check_RSA__c, PROFILE_VERIFICATION__c/*20939 RCU e*/,Application_Form_Timestamp__c,Pure_Flexi_Period__c,Pure_Flexi_EMI__c,RC_Deviation__c,Contact_Name__r.Permanant_City__c,Refferal_Identifier__c,Financial_Health_Check_Guide__c,Elite_Card__c,Cibil_Retrigger_Initiated__c,Company_Name_as_per_Domain_check__c,Domain_Email_Remark__c,PANBREDone__c,/*Ekyc Start */Consent_on_app_form__c,eKYC_Processing__c,HashCode__c,/*Ekyc stop */id,Risk_Segmentation__c,Contact_Name__r.Years_At_Residence__c, Contact_Name__r.office_no_check_on_company_site__c, Contact_Name__r.SFDC_Dedupe_check__c, Contact_Name__r.PAN_Response__c, Contact_Name__r.Linkedin_check_result__c, Contact_Name__r.Google_check_result__c, Contact_Name__r.PAN__c, Contact_Name__r.Last_Modified_Date__c, Contact_Name__r.Name_of_the_PAN_holder__c, Contact_Name__r.Employer__r.Domain_Name__c, Contact_Name__r.Employer__r.Company_Category__c, Existing_Customer__c, Owned_Residence__c, Is_spouse_Working_Financial_CoApp__c, Loan_Application__r.Scheme_Master__c, Name, Contact_Name__r.Mobile__c, Loan_Application__r.Requested_ROI__c, Loan_Application__r.Sourcing_Channel__r.branch__c, Loan_Application__r.Referral__c, Loan_Application__r.Existing_Customer__c, Loan_Application__r.Account.Sourcing_Channel__r.branch__c, Update_CIBIL_Error__c, Descriptin__c, Type_of_Borrower__c, Re_Initiate_De_Dupe__c, Integrate_with_CIBIL__c, Contact_Name__c, Contact_Name__r.Name, Contact_Name__r.Customer_Profile__c,
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
                                          (Select Name, TypeP__c, PAN_Number__c, PAN_Source__c, PAN_Check_Status__c, Comment__c, Credit_Observation__c, Override_Flag__c, NSDL_Response__c, Name__c, Last_Modified_Date__c From TAT_Masters__r),
                                          (SELECT Applicant_Name__c,Address_Line2__c, Address_Line2_of_c3__c , Address_Line2_of_c4__c, Address_Line3__c, Date_Opened__c,Suit_Filed_Status__c,Suit_Filed_Status1__c,Suit_Filed_Status2__c,Suit_Filed_Status3__c,Suit_Filed_Status4__c,Suit_Filed_Status5__c,Suit_Filed_Status6__c,Suit_Filed_Status7__c,Suit_Filed_Status8__c,Suit_Filed_Status9__c,Suit_Filed_Status10__c,Suit_Filed_Status11__c,Suit_Filed_Status12__c,Suit_Filed_Status13__c,Suit_Filed_Status14__c,Suit_Filed_Status15__c,Suit_Filed_Status16__c,Suit_Filed_Status17__c,Suit_Filed_Status18__c,Suit_Filed_Status19__c,Name,CIBIL_Fired_time__c FROM CIBILs__r), //24997 added CIBIL_Fired_time__c
                                          (SELECT id,Date_Reported1__c,Date_Reported2__c,Date_Reported3__c,Date_Reported4__c,Suit_Filed_Status20__c,Suit_Filed_Status21__c,Suit_Filed_Status22__c,Suit_Filed_Status23__c,Suit_Filed_Status24__c,Suit_Filed_Status25__c,Suit_Filed_Status26__c,Suit_Filed_Status27__c,Suit_Filed_Status28__c,Suit_Filed_Status29__c,X90_DPD_6_months__c, Asset_classification_view__c, X30_DPD_CC__c, DPD_CC__c,X30_DPD_Gold_Loan__c, Total_current_outstanding__c, Suit_Filed__c, Settlement_Status__c, written_off_settled_status__c,Unsecured_to_Secured_ratio__c,No_of_PL_Enq_in_Last_3_Months__c FROM CIBIL_Extension__r),(SELECT id,DPD_cluster_Segment__c FROM Cibil_Temps__r),(select Applicant__r.name,applicant__r.Contact_Name__r.name, id,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      Address_Line1__c,Address_Line2__c, Address_Line3__c, Address_Line4__c 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ,State1__c, State2__c, State3__c, State4__c
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ,Pin_Code1__c, Pin_Code2__c, Pin_Code3__c, Pin_Code4__c,initiatedFor__c, Cibil_Temp__r.CIBIL_Score__c, SecondaryMatch_Record__c  
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      from  CIBIL_secondary_match__r where CIBIL__r.CIBIL_Extension__r.Cibil_Temp__r.SecondaryMatch_Record__c != true and CIBIL__c != null ORDER BY CreatedDate desc),(SELECT id,X30_DPD_6_months__c,No_of_Live_PL__c,No_of_PL_Enq_in_Last_6_Months__c ,No_of_PL_Enq_in_Last_12_Months__c,Sum_of_Amount_Overdue__c FROM Cibil_Extension1s__r)  
                                          //Added RSA related Fields By Rajendra for bug id 11714
                                          ,RSA_flag__c,RSA_Loan_application_status__c,RSA_Remarks__c,Degree_Status__c,Khata_Certificate_Status__c,
                                          Plan_Status__c,Proof_of_Registered_Address_Submitted__c,Commencement_Certificate_Status__c,Address_Proof_Status__c,Shop_Act_License_Status__c,Occupation_Certificate_Status__c,Property_Tax_Receipt_Status__c,Verification_ID_Proof_Status__c,Vehicle_Registration_number__c,Vehicle_Registration_date__c,CKYC_No__c,Identity_Document_No__c,Identity_Document_Expiry_Date__c,Proof_of_Address_Submitted_for_Permanent__c,Proof_of_Identity__c,DeDupe_Counter__c, movedToCibilTemp__c,Drop_Line_Flexi_Period__c,Office_Email_Id_Verified__c,Domain_Check_Result__c,IP_Address_Timestamp__c,
                                          (Select eKYC_Photo__c,Location__c,Masked_Email__c,Masked_Phone__c,id,eKYC_Gender__c,bio_Ekyc__c,eKYC_Response__c,Name,Applicant__c,eKYC_City__c,eKYC_State__c,eKYC_Address_details__c,eKYC_Pin_Code__c,eKYC_First_Name__c,eKYC_Last_Name__c,eKYC_Date_of_Birth__c,House__c from eKYC__r)
                                          from Applicant__c where Loan_Application__c =: oppId];
            applicant__c primaryApp = new applicant__c();
            
            
            if(!CommonUtility.isEmpty(appList)){
                
                List<applicant__c> coapplist = new List<applicant__c>();
                for(integer i=0;i<appList.size();i++){
                    if(appList[i].Applicant_Type__c == 'Primary'){
                        //system.debug('domain remark is'+appList[i].Id+appList[i].Domain_Email_Remark__c);
                        dss.applicantPrimary = appList[i];
                        primaryApp = appList[i];
                    }
                    else
                        coapplist.add(appList[i]);
                }
                
                System.debug('inside pk save'+appList.size()+primaryApp.Office_Email_Id_Verified__c);
                //23578 start
                dss.ckycStatus = dss.applicantPrimary.Data_Source__c;
                //23578 stop
                dss.allApps = coapplist;
                if(!CommonUtility.isEmpty(primaryApp) && !CommonUtility.isEmpty(primaryApp.TAT_Masters__r) ){
                    dss.tatMasterRecord = primaryApp.TAT_Masters__r[0];
                }
                if(!CommonUtility.isEmpty(primaryApp) && !CommonUtility.isEmpty(primaryApp.Cibil_Extension1s__r) ){
                    dss.cibilExt1 = primaryApp.Cibil_Extension1s__r[0];
                }
                if(!CommonUtility.isEmpty(primaryApp) && !CommonUtility.isEmpty(primaryApp.CIBIL_Extension__r) ){
                    dss.cibilExt = primaryApp.CIBIL_Extension__r[0];
                }
                if(!CommonUtility.isEmpty(primaryApp) && !CommonUtility.isEmpty(primaryApp.CIBILs__r) ){
                    dss.cibilobj  = primaryApp.CIBILs__r[0];
                }    
                if(!CommonUtility.isEmpty(primaryApp.Cibil_Temps__r) ){
                    dss.cibilTempobj  = primaryApp.Cibil_Temps__r[0];
                }
                if(!CommonUtility.isEmpty(primaryApp.CIBIL_secondary_match__r) ){
                    dss.secondarycibilList  = primaryApp.CIBIL_secondary_match__r;
                }
            }
            /*20939 RCU changed logic and moved code*/
            dss.veriList = new List<verification__c>(); //20939
            List<Verification__c> AllVerify = new List<Verification__c>(); /*[select RSA_Reason__c ,Initiated_by_invisible_monitoring__c,id, name, Status__c, Verification_Type__c,Credit_Status__c,Geo_Tagging__c,Image_Latitude_Longitude_Details__c from Verification__c where Loan_Application__c = : oppId]; *///soql optimization
            if(!CommonUtility.isEmpty(oppList) && oppList[0].Verification__r != null && oppList[0].Verification__r.size() > 0){
                AllVerify.addAll(oppList[0].Verification__r);
            }
            if(!CommonUtility.isEmpty(AllVerify)){
                for(Verification__c veri : AllVerify){
                    if(veri.RSA_Reason__c != 'Initiated through RSA' && veri.Initiated_by_invisible_monitoring__c == false){
                        dss.veriList.add(veri);
                    }
                    else if(!CommonUtility.isEmpty(oppList.get(0)) && !CommonUtility.isEmpty(oppList.get(0).Product__c) && primaryApp.Check_RSA__c == 'Yes' && (oppList.get(0).Product__c != 'RSL') && primaryApp.Score_card__c > 8 && veri.Status__c != 'Positive' && veri.Status__c != 'Refer'){ //US 899
                        dss.rsaVeriDone = false;
                    }
                }
            }
            //added field Number_of_Add_on_card__c for bug 24667
            List<Product_Offerings__c> poList = [SELECT /*Submit to credit S*/Resi_City__c,Resi_State__c,Customer_ID1__r.Id,Lead__r.FirstName,Customer_ID__c,Lead__r.Resi_State__c,Lead__r.Resi_City__c,Lead__r.lastName,Lead__r.Number_of_Add_on_card__c,OwnerId,Lead_Source__c,Products__c,Lead__r.Id,KYC_verification_Done__c,Bank_Details_Change__c,ECS_End_Date__c,/*Submit to credit E*/id,Address_Line_1__c,Address_Line_2__c,Address_Line_3__c,Pin_Code__c /*added for bug id 18661 start*/,Lead__r.middle_name__c/*added for bug id 18661 end*/
                                                 ,Lead__r.Residence_Address_Line1__c,Lead__r.Residence_Address_Line2__c,Lead__r.Residence_Address_Line3__c,Lead__r.Resi_Pin_Code__c from Product_Offerings__c where Opportunity__c =: oppId LIMIT 1];
            system.debug('poList>>>>>>>>>>>>'+poList);
            if(!CommonUtility.isEmpty(poList)){
                dss.poobj = poList.get(0);
                dss.noAddonCards = String.valueOf(poList.get(0).Lead__r.Number_of_Add_on_card__c);//Bug 24667
                system.debug('poList addoncards>>>>>>>>>>>>'+poList.get(0).Lead__r.Number_of_Add_on_card__c);
                system.debug('poList>>>>>>>>>>>>' + poList.get(0).Lead__r.Resi_City__c);
            }
            
            System.debug('appList'+appList.size());
            if(!CommonUtility.isEmpty(primaryApp)){ 
                //24997 added permanent mobile
                List<Contact> conList = [SELECT Permanent_Mobile__c,Resi_Area__c,Sex__c,Residence_City__c,Employer__r.KID__c,Employer__c,months_of_Residence__c,CIF_Id__c,Permanent_State__c,Permanant_City__c,Office_State__c,EMI_Bounce_in_last_3_months__c,Educational_Qualification__c,DesignationOTP__c,id, Name, Email,Employer_Name__c,Date_of_Birth__c,Office_Email_Id__c, Special_Profile_Employer__c,Stamp_Duty__c,LastName,Marital_Status__c,ApplicantType__c,Residence_Type__c,Permanant_Address_Line_1__c,Permanant_Address_Line_2__c,Permanant_Address_Line_3__c,Permanent_Pin_Code__c, Years_At_Residence__c,Address_Line_One__c,Address_2nd_Line__c,Address_3rd_Line__c,Office_Pin_Code__c,Office_Landline_Number1__c,FathersHusbands_Name__c, PAN_Number__c, Year_of_Incorporation__c, Account.TIN_Number__c, Bank_Account_No__c, VoterID_Number__c, ROC_Regn_No__c,
                                         Address_1__c, Address_2__c,Office_Email_sent__c, Address_3__c,AppCity__c, Pin_Code__c, Phone, MobilePhone, Permanent_Land_Mark__c, Office_City__c,
                                         Office_STD_Code__c,Employer__r.Company_Category__c,Office_Phone_Number__c,Mobile_Phone__c, Customer_Type__c,FirstName,Middle_Name__c, CIN__c,DIN__c 
                                         ,Father_Spouse__c,Father_Spouse_Salutation__c,Occupation_CKYC__c,Mother_Last_Name__c,Mother_Middle_Name__c,Mother_First_Name__c,Father_Spouse_Last_Name__c,Father_Spouse_Middle_Name__c,Father_Spouse_First_Name__c,Customer_address_matches_with_eKYC__c,Customer_address_matches_with_perfios__c,state__c,Perfios_Address__c,Customer_Add_Matches_With_Previous_Add__c
                                         from Contact where id=: primaryApp.Contact_Name__r.id LIMIT 1];
                if(!CommonUtility.isEmpty(conList)){ 
                    dss.objCon = conList.get(0);
                }
                
                
                List <Bank_Account__c> banksallists = [select /*CR 24122 s*/Perfios_Statement_Status_1__c ,Perfios_Statement_Status_2__c,Perfios_Statement_Status_3__c , /*CR 24122 e*/IFSC_Code__c,Perfios_inwardChqBounces__c,Perfios_inwardECSBounces__c,Salary_credit_amount1__c,Salary_credit_amount2__c,Salary_credit_amount3__c,Salary_Credit_Date1__c,Salary_Credit_Date2__c,Salary_Credit_Date3__c,/*Submit to credit S*/SalCrdtDateInconsistencyInPerfiose__c,Salary_Date_Inconsistency_Found__c,Salary_Amount_Difference__c,narration1__c,narration2__c,narration3__c,HVTinPerfios__c,Latest_bounce_in_Perfios__c,/*Submit to credit E*/id, Bank_Type__c, name, Bank_Name__c, Bank_Account_Number__c, IFSC_Bank_Name__c, Bank_Acct_Number__c, Bank_Branch__c, Applicant__c, Applicant__r.Applicant_Type__c,Perfios_Flag__c, Send_Email_For_Perfios__c,StatusOfBankAccount__c,Source_Of_Data__c,Perfios_abb02__c,Perfios_abb05__c,Perfios_abb10__c,Perfios_Bank_Name__c,Authenticity__c,Authenticity_Score_Flag__c,Perfios_Account_No__c,Perfios_Client_Address__c from Bank_Account__c where Loan_Application__c = : oppId and Applicant__c =: primaryApp.id];
                if(!CommonUtility.isEmpty(banksallists)){
                    dss.bankObj = banksallists[0]; 
                }
                else
                   dss.bankObj = new Bank_Account__c();
                
                
            }
            
            
            List<eKYC__c> ekycList = new List<eKYC__c>();
            if(!CommonUtility.isEmpty(primaryApp) && primaryApp.eKYC__r != null && primaryApp.eKYC__r.size() > 0)
            {
                ekycList =primaryApp.eKYC__r;/*[Select eKYC_Photo__c,Location__c,Masked_Email__c,Masked_Phone__c,id,eKYC_Gender__c,bio_Ekyc__c,eKYC_Response__c,Name,Applicant__c,eKYC_City__c,eKYC_State__c,eKYC_Address_details__c,eKYC_Pin_Code__c,eKYC_First_Name__c,eKYC_Last_Name__c,eKYC_Date_of_Birth__c,House__c from eKYC__c where Applicant__c=:primaryApp.id Limit 1];*///soql optimization
                if(!CommonUtility.isEmpty(ekycList)){
                    dss.ekycobj= ekycList[0];
                }
            }
            
            
            //Rohit submit to sales start
            if(!CommonUtility.isEmpty(dss.poObj))
                dss.isPLTB = checkForPLTB(dss.poObj);
            /*List<Profile> ProfileList = [Select Name from Profile where Id =:userinfo.getProfileId()];
if(ProfileList != null && ProfileList.size()>0 && ProfileList[0].Name == 'Tele Calling Team')
dss.isTeleCaller = true;
else dss.isTeleCaller = false;*/
            oUser = u;/*[SELECT Id,Name,Profile.Name
FROM User Where id =: userInfo.getUserId()];*/ //soql optimization
            String setTeleCallerProfile = System.Label.TeleCaller_ProfileName;
            if(setTeleCallerProfile.contains(oUser.Profile.Name))
                dss.isTeleCaller = true;
            else dss.isTeleCaller = false;
            //Rohit submit to sales stop
            String setFieldProfile = System.Label.FieldAgents_ProfileName;
            system.debug('setFieldProfile : '+setFieldProfile);  
            if(setFieldProfile.contains(oUser.Profile.Name))
                dss.isFieldAgent = true;
            //Rohit pan check start
            List<TAT_Master__c> tatList = new  List<TAT_Master__c>();
            system.debug('dss os'+dss.applicantPrimary);
            if(!CommonUtility.isEmpty(primaryApp) && primaryApp.TAT_Masters__r != null && primaryApp.TAT_Masters__r.size() > 0){
                tatList.addAll(primaryApp.TAT_Masters__r);/* = [SELECT Name,TypeP__c,Credit_Observation__c FROM TAT_Master__c WHERE Applicant__c =:dss.applicantPrimary.Id];*/// soql optimization
            }
            List<SOL_Policy__c> solList = [SELECT id,/*24313 s*/RetriggerBRE__c,/*24313 e*/copyAddressFrom__c,Name,Policy_Name__c,Policy_Status__c,New_Address_Value__c,Old_Address_Value__c,Applicant_Name__r.Contact_Name__r.Name,Applicant_Name__r.PAN_Number__c FROM SOL_Policy__c WHERE Loan_Application__c =:oppId AND (Name Like 'Sales2.0%' OR Name Like 'Dual%')];
            if(!CommonUtility.isEmpty(solList)){
                dss.SOLPolicyList  = solList;
            }
            List<SOL_Policy__c> panPolicies = new List<SOL_Policy__c>();
            List<SALMobilityCntrl_V2.PanCheckWrapper> panWrapperList = new List<SALMobilityCntrl_V2.PanCheckWrapper>();
            for(SOL_Policy__c sol : solList){
                if(sol.Policy_Name__c.contains('Primary Pan Check')){
                    panPolicies.add(sol);   
                }
                else if(sol.Policy_Name__c.contains('Dual Pan Check')){
                    panPolicies.add(sol);
                }
            }
            System.debug('sol list '+solList);
            if(panPolicies.size()>0){
                for(SOL_Policy__c sol : panPolicies){
                    SALMobilityCntrl_V2.PanCheckWrapper panWrapper = new SALMobilityCntrl_V2.PanCheckWrapper();
                    
                    if(sol.Policy_Name__c.contains('Primary Pan Check')){//== 'Primary Pan Check'){ 
                        panWrapper.panType = 'Primary';
                        
                        if(sol.Old_Address_Value__c != null){
                            Map<String,Object> panOutput = (Map<String,Object>)json.deserializeUntyped(sol.Old_Address_Value__c);
                            System.debug('robin pan map '+panOutput);
                            /*if(panOutput != null && panOutput.get('Pan_Series_Output') != null ){                            
Map<String,Object> innerMap = (Map<String,Object>)panOutput.get('Pan_Series_Output');

if(innerMap != null)
panWrapper.panSeriesTrigger = (String)innerMap.get('pan_series_trigger');
System.debug('inner map '+innerMap);
}*/
                            if(panOutput != null && panOutput.get('pan_series_trigger') != null ){
                                panWrapper.panSeriesTrigger = (String)panOutput.get('pan_series_trigger');
                            }
                        }
                    }   
                    else if(sol.Policy_Name__c.contains('Dual Pan Check')){ //== 'Dual Pan Check'){
                        panWrapper.panType = 'Dual';
                        if(tatList != null && tatList.size()>0)
                            panWrapper.tatRec = tatList[0];
                        
                    }
                    panWrapper.AppName = sol.Applicant_Name__r.Contact_Name__r.Name;
                    if(sol.New_Address_Value__c != null){
                        String[] panData = sol.New_Address_Value__c.split('\\^');   
                        panWrapper.panNumber = panData[0];
                        SALMobilityCntrl_V2.PanDetailsWrapper panDetails = new SALMobilityCntrl_V2.PanDetailsWrapper();
                        panDetails.Name = panData[1]+' '+panData[2]+' '+panData[3];
                        panDetails.title = panData[1];
                        panDetails.status = panData[5];
                        panDetails.LastModification = panData[4];
                        
                        panWrapper.panDetails = panDetails;
                        
                    }
                    else{
                        panWrapper.panNumber = accObj.PANNumber__c;
                    }
                    
                    panWrapperList.add(panWrapper);                 
                }
                dss.panCheckList = panWrapperList;
                System.debug('in panwrapper if '+panWrapperList);
            }
            else{
                SALMobilityCntrl_V2.PanCheckWrapper panWrapper = new SALMobilityCntrl_V2.PanCheckWrapper();
                panWrapper.panNumber = accObj.PANNumber__c;
                panWrapperList.add(panWrapper); 
                dss.panCheckList = panWrapperList; 
            }
            
            //Rohit pan check stop
            /* Bug : 17139 S */
            List< Discrepancy__c > discrepancy = new List< Discrepancy__c >();
            discrepancy = [select Name,Type__c,Discrepancy_Stage__c, Date_Time__c, Party_Type__c, Party_Name__c,
                           Discrepancy_Description__c, LoanApplication__c,
                           RaiserName__c, Description__c,
                           Priority__c, Resolution_Remarks__c, Status__c, Discrepancy_Party__c, Applicant_Name__c,
                           Raiser_Role__c, createddate, Category__c,
                           Assigned_To__c, Closed_Date__c, Resolver_Name__c, OTPDiscrepancyCategory__c, OTPDiscrepancyDocuments__c
                           /*Mortgage Start*/
                           , Remarks__c, Discrepancy_Type__c /*Mortgage End*/
                           from Discrepancy__c where LoanApplication__c = : oppId/* and Type__c = 'SanctionCondition'*/
                           order by Status__c asc, createddate asc
                          ];
            for(Discrepancy__c dis : discrepancy){
                if(dis.Type__c == 'SanctionCondition'){
                    dss.sanctionList.add(dis);
                }
                else{
                    dss.existingDisList.add(dis);
                }
            }
            /*if(!CommonUtility.isEmpty(discrepancy) ){
dss.sanctionList.addAll(discrepancy);
}*/
            System.debug('populate Befr');
            if(!CommonUtility.isEmpty(oppList) && !CommonUtility.isEmpty(oppList[0]) && !CommonUtility.isEmpty(oppList[0].Current_Disbursal_Details_s__r) ){
                dss.disburement.addAll(oppList[0].Current_Disbursal_Details_s__r);
                /*24997 s*/
                Current_Disbursal_Details__c disObj = oppList[0].Current_Disbursal_Details_s__r[0];
                for(IFSC_Master__c ifsc : [SELECT Id from IFSC_Master__c where IFSC_Code__c =: disObj.IFSC_Code__c AND Is_IMPS_Enabled__c = true]){
                    dss.impsRepAcc = true;
                }
                /*24997 e*/
                System.debug('populate Disbursment'+oppList[0].Current_Disbursal_Details_s__r);  
                System.debug('populate Disbursment'+oppList[0].Current_Disbursal_Details_s__r[0].Bank_name__c);           
                
            }
            if(!CommonUtility.isEmpty(oppList) && !CommonUtility.isEmpty(oppList[0]) && !CommonUtility.isEmpty(oppList[0].RePayment_mode_details__r) ){
                dss.repayList.addAll(oppList[0].RePayment_mode_details__r);
            } 
            /* Bug : 17139 E */  
            dss.creditofcList = getCreditOfficerPicklist(oppId);            
        }
        else
        {
            dss.opp = new Opportunity();
            dss.pdObj = new Personal_Discussion__c(); /* Bug : 17139  */  
            dss.accObj = new Account();
            dss.applicantPrimary = new Applicant__c();
            dss.objCon = new Contact();
            dss.ekycobj = new eKYC__c();
            dss.poobj = new Product_Offerings__c();
            dss.isPreapproved = false;
            //Rohit added null check
            if(dss.veriList != null )
                dss.veriList[0] = new Verification__c();
            
        }
        // List<Profile> prof = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];soql optimization
        if(prof != null && prof.size() > 0)//soql optimization
            dss.myProflieName = prof[0].Name;
        dss.theme = UserInfo.getUiThemeDisplayed();
        allDataCalled = true;
        allData = dss;
        
        
    }
    
    
    /*  public static String saveContactRecord(String jsonContactRecord, String jsonAccountRecord, String loanApplicationId)
{
try
{
Account genericDataAcc = new Account();
Account objAcc = new Account();
oppData dss = new oppData();
Contact objCon = new Contact();
system.debug('jsonContactRecord+'+jsonContactRecord);
Contact genericDataCon = new Contact();
if(!CommonUtility.isEmpty(jsonContactRecord))
{
genericDataCon = (Contact)JSON.deserialize(jsonContactRecord, Contact.class);
system.debug('genericDataCon+'+genericDataCon);
if (genericDataCon != null)
objCon = genericDataCon;

genericDataAcc = (Account)JSON.deserialize(jsonAccountRecord, Account.class);
if (genericDataAcc != null)
objAcc = genericDataAcc;

objCon.Residence_City__c = SOLDynamicController.getCityFromPincode(String.valueOf(objCon.Pin_Code__c));
objCon.State__c = SOLDynamicController.fetchStateRemote(String.valueOf(objCon.Residence_City__c));

objAcc.Current_Residence_Address1__c = objCon.Address_1__c;
objAcc.Current_Residence_Address2__c = objCon.Address_2__c;
objAcc.Current_Residence_Address3__c = objCon.Address_3__c;
objAcc.Current_PinCode__c = objCon.Pin_Code__c;
objAcc.Current_City__c = objCon.Residence_City__c;
objAcc.Current_State__c = objCon.State__c;

UPDATE objAcc;
system.debug('objAcc+'+objAcc);

UPDATE objCon;
system.debug('objCon+'+objCon);

dss.objCon = objCon;
dss.accObj = objAcc;

//oppData dss = new oppData();
//getAllData(loanApplicationId,dss);
//DedupeService data = new DedupeService();
//DedupeService.insertDedupeSource(dss.objCon, dss.applicantPrimary, dss.opp);

//CibilService cibil = new CibilService();
//CibilService.createCibilTempRecord(dss.objCon, dss.applicantPrimary);
}
return JSON.serialize(dss);
}
catch(Exception ex)
{
return null;
//System.debug('I am at line ' + String.valueOf(ex.getLineNumber()) +' '+ ex.getMessage());
}
}*/
    public static String saveContactRecord(String jsonContactRecord, String jsonAccountRecord, String loanApplicationId,String jsonpaddresspolicy)
    {
        try
        {
            Account genericDataAcc = new Account();
            Account objAcc = new Account();
            oppData dss = new oppData();
            Contact objCon = new Contact();
            SOL_Policy__c addresspolicy = new SOL_Policy__c();
            List<SOL_Policy__c> addresspolicyList = new List<SOL_Policy__c>();
            system.debug('jsonpaddresspolicy pk+'+jsonpaddresspolicy);
            Contact genericDataCon = new Contact();
            
            
            if(!CommonUtility.isEmpty(jsonContactRecord))
            {
                genericDataCon = (Contact)JSON.deserialize(jsonContactRecord, Contact.class);
                system.debug('genericDataCon+'+genericDataCon);
                if (genericDataCon != null)
                    objCon = genericDataCon;
                
                genericDataAcc = (Account)JSON.deserialize(jsonAccountRecord, Account.class);
                if (genericDataAcc != null)
                    objAcc = genericDataAcc;
                /*Commented for City CR
String city = SOLDynamicController.getCityFromPincode(String.valueOf(objCon.Pin_Code__c));
objCon.Residence_City__c = city;
objCon.State__c = SOLDynamicController.fetchStateRemote(String.valueOf(city));

if(CommonUtility.isEmpty(city) || CommonUtility.isEmpty(SOLDynamicController.fetchStateRemote(String.valueOf(city)))){
dss.status = 'City Fail';
return JSON.serialize(dss);
} 
/*2.0 CR e*/
                if(!CommonUtility.isEmpty(jsonpaddresspolicy))
                {
                    addresspolicy = (SOL_Policy__c)JSON.deserialize(jsonpaddresspolicy, SOL_Policy__c.class);
                    upsert addresspolicy ;
                    addresspolicyList.add(addresspolicy); 
                }
                //system.debug('city is'+city);
                objCon.AppCity__c = objCon.Residence_City__c;
                objAcc.Current_Residence_Address1__c = objCon.Address_1__c;
                objAcc.Current_Residence_Address2__c = objCon.Address_2__c;
                objAcc.Current_Residence_Address3__c = objCon.Address_3__c;
                objAcc.Current_PinCode__c = objCon.Pin_Code__c;
                objAcc.Current_City__c = objCon.Residence_City__c;
                objAcc.Current_State__c = objCon.State__c;
                
                UPDATE objAcc;
                system.debug('objAcc+'+objAcc);
                
                UPDATE objCon;
                system.debug('objCon+'+objCon);
                
                dss.objCon = objCon;
                dss.accObj = objAcc;
                dss.solPolicylist = addresspolicyList;
                
            }
            return JSON.serialize(dss);
        }
        catch(Exception ex)
        {
            System.debug('Exception in contact save'+ex.getMessage()+ex.getLineNumber());
            return null;
            //System.debug('I am at line ' + String.valueOf(ex.getLineNumber()) +' '+ ex.getMessage());
        }
    }
    public static String updateAppDetails(Account accObj,Contact conObj, Applicant__c appObj,Opportunity oppObj,eKYC__c ekycObj,List<SMS_Sent__c> CkycsmsObj,List<SOL_Policy__c> solLst,String attachments){
        system.debug('Accoutn'+accObj);
        system.debug('Contact'+conObj);
        system.debug('Applicant'+appObj);
        
        try{
            oppData data = new oppData();
            Boolean isCreate = false;
            if(appObj.Id == null) isCreate = true;
            //String resCity = SOLDynamicController.getCityFromPincode(String.valueof(conObj.Pin_Code__c));
            //conObj.Residence_City__c = resCity;
            conObj.AppCity__c = conObj.Residence_City__c;
            Map<String,String> resiMap = GeneralUtilities.fetchStateStdRemote(conObj.Residence_City__c);
            //conObj.State__c = resiMap.get('State');
            /*2.0 CR s
if(CommonUtility.isEmpty(resCity) || CommonUtility.isEmpty(resiMap.get('State'))){
data.status = 'City Fail';
return JSON.serialize(data);
} 
2.0 CR e*/
            if(resiMap.get('Std') != null)
                conObj.STD_Code__c = Decimal.valueOf(resiMap.get('Std'));
            //String perCity = SOLDynamicController.getCityFromPincode(String.valueof(conObj.Permanent_Pin_Code__c));
            //conObj.Permanant_City__c = perCity;
            Map<String,String> perMap = GeneralUtilities.fetchStateStdRemote(conObj.Permanant_City__c);
            //conObj.Permanent_State__c = perMap.get('State');
            /*2.0 CR s
if(!CommonUtility.isEmpty(conObj.Permanent_Pin_Code__c) && (CommonUtility.isEmpty(perCity) || CommonUtility.isEmpty(perMap.get('State')))){
data.status = 'City Fail';
return JSON.serialize(data);
} 
2.0 CR e*/
            if(perMap.get('Std') != null)
                conObj.Permanent_STD__c = Decimal.valueOf(perMap.get('Std'));
            //String offCity = SOLDynamicController.getCityFromPincode(String.valueof(conObj.Office_Pin_Code__c));
            //conObj.Office_City__c = offCity;
            Map<String,String> offMap = GeneralUtilities.fetchStateStdRemote(conObj.Office_City__c);
            //conObj.Office_State__c = offMap.get('State');
            /*2.0 CR s
if(!CommonUtility.isEmpty(conObj.Office_Pin_Code__c) && (CommonUtility.isEmpty(offCity) || CommonUtility.isEmpty(offMap.get('State')))){
data.status = 'City Fail';
return JSON.serialize(data);
} 
2.0 CR e*/
            if(offMap.get('Std') != null)
                conObj.Office_STD_Code__c = Decimal.valueOf(offMap.get('Std'));
            system.debug('App Type'+appObj.Applicant_Type__c);
            if(appObj.Applicant_Type__c == 'Primary'){
                accObj.Permanent_City__c = conObj.Permanant_City__c;
                accObj.Permanent_State__c = conObj.Permanent_State__c;
                accObj.Current_City__c = conObj.Residence_City__c;
                accObj.Current_State__c = conObj.State__c;
                accObj.Office_City__c = conObj.Office_City__c;
                accObj.Office_State__c = conObj.Office_State__c;
                upsert accObj;
                upsert oppObj;
                List<SOL_Policy__c> solPolicyList= new List<SOL_Policy__c>();       
                solPolicyList=[select id, Policy_Name__c,Checklist_Policy_Status__c from SOL_Policy__c where Loan_Application__c = : oppObj.Id AND Name LIKE 'Sales2.0%'    ];
                /*20939 s
List<SOL_Policy__c> listToDel = new List<SOL_Policy__c>(); */
                List<SOL_Policy__c> newList = new List<SOL_Policy__c>();
                SOl_policy__c sp = new Sol_policy__c();
                /*20939 e*/
                for(SOL_Policy__c sol : solPolicyList){
                    if(sol.Policy_Name__c.contains('Veri- Permanent'))
                        sp = sol; //20939
                }
                
                //20939 changed below logic from delete insert to upsert
                if(conObj.Residence_Type__c == 'Owned by Self/Spouse' || conObj.Residence_Type__c == 'Owned by Parent/Sibling'){
                    
                    sp.Policy_Name__c = 'Veri- Permanent Pass';
                    sp.Policy_Status__c = 'OK';
                    sp.Loan_Application__c = oppObj.Id;
                    sp.Applicant_Name__c = appObj.Id;
                    sp.RetriggerBRE__c = false;
                    newList.add(sp);
                    //OpportunityMobilityUtility.policyList = solPolicyList;  
                    //OpportunityMobilityUtility.createPolicyRecord('Veri- Permanent Pass', 'OK', oppObj.Id,appObj.Id );
                    for(SOL_Policy__c sol : newList){
                        String name = 'Sales2.0';
                        if(sol.Policy_Name__c == 'Veri- Permanent Pass')
                            sol.Name = name+' Veri- Permanent';
                    }
                    
                }    
                else{
                    sp.Policy_Name__c = 'Veri- Permanent Fail';
                    sp.Policy_Status__c = 'Rejected';
                    sp.Loan_Application__c = oppObj.Id;
                    sp.Applicant_Name__c = appObj.Id;
                    newList.add(sp);
                    //OpportunityMobilityUtility.policyList = solPolicyList;  
                    //OpportunityMobilityUtility.createPolicyRecord('Veri- Permanent Pass', 'OK', oppObj.Id,appObj.Id );
                    for(SOL_Policy__c sol : newList){
                        String name = 'Sales2.0';
                        if(sol.Policy_Name__c == 'Veri- Permanent Fail')
                            sol.Name = name+' Veri- Permanent';
                    }
                    //upsert newList;
                } 
                if(newList.size() > 0)
                    upsert newList;
                //if(listToDel.size() > 0)
                //delete listToDel;
            }
            upsert conObj;
            appObj.Contact_Name__c = conObj.Id;
            upsert appObj;
            //23578 ckyc start
            if(!CommonUtility.isEmpty(CkycsmsObj)){
                for(SMS_Sent__c sms : CkycsmsObj){
                    sms.LoanApplication__c = oppObj.Id;
                }
                upsert ckycsmsObj;
            }
            if(!CommonUtility.isEmpty(attachments) && appObj.Id != null){
                List<ContentDocumentLink> contVerToDel = [SELECT ID,ContentDocument.title,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :appObj.Id AND ContentDocument.title LIKE '%CKYC%'];
                
                if(!CommonUTility.isEmpty(contVerToDel))
                    delete contVerToDel;
                
                List<ContentVersion> ckycAttachLst = new List<ContentVersion>();
                List<Map<String,String>> attMap = new List<Map<String,String>>();
                attMap = (List<Map<String,String>>)JSON.deserialize(attachments,List<Map<String,String>>.class);
                for(Map<String,String> imgData : attMap){
                    System.debug('image '+imgData);
                    //ckycAttachLst.add(attach);
                    
                    ContentVersion DataFile = new ContentVersion();                  
                    //DataFile.versionDAta = Blob.valueOf(imgData.get('image'));
                    DataFile.versionDAta = EncodingUtil.base64Decode(imgData.get('image'));
                    DataFile.title = imgData.get('Name');   
                    dataFile.PathOnClient = '/'+imgData.get('Name')+'.'+imgData.get('extension');             
                    ckycAttachLst.add(DataFile);
                    
                    
                }
                
                insert ckycAttachLst;
                Set<Id> contVSet = new Set<Id>();
                for(ContentVersion cv : ckycAttachLst){
                    contVSet.add(cv.Id);
                }
                
                
                List<ContentVersion> ckycUpLst = [SELECT ContentDocumentId from ContentVersion where id IN :contVSet];
                List<ContentDocumentLink> conLnlLst = new List<ContentDocumentLink>();
                for(ContentVersion conVr : ckycUpLst){
                    ContentDocumentLink cdl = new ContentDocumentLink();
                    cdl.ContentDocumentId = conVr.ContentDocumentId;
                    cdl.LinkedEntityId = appObj.id;
                    cdl.ShareType = 'V';
                    conLnlLst.add(cdl);
                }
                insert conLnlLst;
                System.debug('attachments here');
            }
            
            List<SOL_Policy__c> ckycToDel = [SELECT ID,Applicant_Name__c FROM SOL_Policy__c WHERE Applicant_Name__c = :appObj.Id AND Name = 'Ckyc response'];
            if(!CommonUTility.isEmpty(ckycToDel))
                delete ckycToDel;
            
            System.debug('app id '+appObj.Id);           
            if(!CommonUtility.isEmpty(solLst)){ 
                System.debug('sol list '+solLst);          
                for(SOL_Policy__c sol : solLst){
                    if(sol != null)  
                        sol.Applicant_Name__c = appObj.Id;
                }
                if(!solLst.contains(null))
                    upsert solLst;
            }           
            //23578 stop
            if(ekycObj != null && ekycObj.Id != null){
                ekycObj.Applicant__c = appObj.Id;
                update ekycObj;
            }
            system.debug('iscreate'+isCreate+appObj.movedToCibilTemp__c);
            if(isCreate){
                if(!appObj.movedToCibilTemp__c){
                    //CibilService.isMobility = true;
                    //CibilService.createCibilTempRecord(conObj, appObj);
                }
                DedupeService.insertDedupeSource(conObj, appObj, oppObj);
            }
            
            data.currApp = appObj;
            data.objCon = conObj;
            data.opp = oppObj;
            data.accObj = accObj;
            return JSON.serialize(data);
        }
        catch(Exception e){
            system.debug('Exception'+e.getMessage()+e.getLineNUmber());
            return '';
        }
    }
    
    public static String getCkycDetails(String oppID,String objectFieldJSON){
        oppData data= new oppData();
        system.debug('getAllDataCalled '+allDataCalled );
        if(allDataCalled == true){
            data = allData;
        }
        else{
            getAllData(oppID,data);
        }
        try{
            data.picklistData = LighteningUtilities.getPicklistValues(objectFieldJSON);
        }catch(Exception e)
        {
            System.debug('inside ckyc details'+e.getMessage()+e.getLineNumber()+e.getCause());
        }
        return JSON.serialize(data);
    }
    public static String getDedupeDetails(String oppID,String objectFieldJSON){
        oppData data= new oppData();
        //getAllData(oppID,data);
        try{
            data.picklistData = LighteningUtilities.getPicklistValues(objectFieldJSON);
        }catch(Exception e)
        {
            System.debug('inside dedupe details'+e.getMessage()+e.getLineNumber()+e.getCause());
        }
        return JSON.serialize(data);
    }
    
    public static String getDashboardDetails(String oppID,String objectFieldJSON){
        System.debug('hello');
        System.debug('Theme is '+UserInfo.getUiThemeDisplayed());
        oppData data= new oppData();
        data.currentTheme=UserInfo.getUiThemeDisplayed();
        System.debug('hello');
        List<Verification__c> verificationList;
        List<Verification__c> finalverificationList=new List<Verification__c>();
        List<De_Dupe__c> dedupelist=new List<De_Dupe__c>();
        List<Applicant__c> applicant=new List<Applicant__c>();
        List<SOL_Policy__c> tempSOLPolicyList;
        
        
        List<eKYC__c> ekycList = new List<eKYC__c>();
        //getAllData(oppID,data);
        try{
            //logic for MCP check && PAN Check
            System.debug('Opportunity id is '+oppID);
            List<Opportunity> oppList = [Select AccountID,Loan_Application_Number__c from Opportunity where id =: oppID];
            Opportunity oppObj = new Opportunity();
            if(oppList.size() > 0){
                oppObj = oppList[0];
            }
            
            if(oppID != null && oppID != ''){
                List<Account> accList = [SELECT PAN_Check_Status__c,Type_of_Salary__c,Educational_Qualification__c,Offer_Inhanced__c,Type_of_Educational_Institution__c,Current_experiance_in_Month__c,Current_experiance_in_Years__c,Total_Work_Experience_Months__c,Total_Work_Experience_Yrs__c,Qualification__c,Gross_Salary_Turn_Over__c,Residence_TypeAcc__c,Id,Name, First_Name__c,PinCode__c,Area_Locality__r.id,Area_Locality__r.Name,Area_Locality__r.Affluence__c,Area_Locality__c,Last_Name__c,Middle_Name__c,Current_City__c,Current_State__c,Date_of_Birth__c,Mobile__c,PANNumber__c,Gender__c,DesignationOTP__c,Office_Address_1st_Line__c,Office_Address_2nd_Line__c,Office_Address_3rd_Line__c,Office_Pin_Code__c,Office_Landline_Number1__c,Permanent_Residence_Address1__c,Permanent_Residence_Address2__c,Permanent_Residence_Address3__c,Permanent_PinCode__c,Permanent_Telephone_Number__c,Current_Residence_Address1__c,Current_Residence_Address2__c,Current_Residence_Address3__c,Current_PinCode__c,Employer__c,Type_Of_Industry__c,Email_Id__c,Marital_Status__c,Employer__r.Name,EPFO_Result__c,Employer__r.Sub_Industry__c,Downsizing_Reasons__c,Preffered_Mode_to_Connect__c   from Account where id =: oppObj.AccountID LIMIT 1];
                if(accList.size() > 0){
                    data.accObj = accList[0];
                }
                tempSOLPolicyList=[select id, Remarks__c,Policy_Name__c,Disposition_Status__c,Checklist_Policy_Status__c from SOL_Policy__c where Loan_Application__c = : oppID AND Name LIKE 'Sales2.0%'    ];
                if(!CommonUtility.isEmpty(tempSOLPolicyList)){
                    data.SOLPolicyList=tempSOLPolicyList;
                }
            }
            System.debug('T  '+tempSOLPolicyList);
            System.debug('SOL Policies Are '+data.SOLPolicyList);
            //end of MCP check logic
            
            List<Product_Offerings__c> poList = [SELECT Resi_City__c,Resi_State__c,Lead__r.FirstName,Lead__r.Resi_State__c,Lead__r.Resi_City__c,Lead__r.lastName,OwnerId,Lead_Source__c,Products__c,Lead__r.Id,KYC_verification_Done__c,Bank_Details_Change__c,ECS_End_Date__c,/*Submit to credit E*/id,Address_Line_1__c,Address_Line_2__c,Address_Line_3__c,Pin_Code__c from Product_Offerings__c where Opportunity__c =: oppID LIMIT 1];
            if(!CommonUtility.isEmpty(poList)){
                data.poobj = poList.get(0);
            }
            
            
            //get applicant for EKYC logic
            applicant=[select id, eKYC_Processing__c,Codified_CIBIL__c,Proof_of_Registered_Address_Submitted__c from Applicant__c where Loan_Application__c =: oppID  and Applicant_Type__c= 'Primary' LIMIT 1 ];
            if(!CommonUtility.isEmpty(applicant)){
                data.applicantPrimary=applicant[0];
                ekycList =[Select id,bio_Ekyc__c,House__c from eKYC__c where Applicant__c=:applicant[0].id Limit 1];
                if(!CommonUtility.isEmpty(ekycList)){
                    data.ekycobj= ekycList[0];
                }
            }
            
            //end of EKYC logic
            
            
            data.picklistData = LighteningUtilities.getPicklistValues(objectFieldJSON);
            System.debug('hello1');
            
            verificationList = [SELECT  /*20939 s*/Applicant__c,/*20939 e*/Id,Verification_Type__c,Status__c FROM Verification__c WHERE Loan_Application__c=:oppID AND RSA_Reason__c != 'Initiated through RSA' AND Initiated_by_invisible_monitoring__c = false]; //20939 RCU added and conditions
            
            System.debug('Query of Verification' + verificationList);
            if(!CommonUtility.isEmpty(verificationList)){
                //data.veriList = verificationList;
                System.debug('verificationList: '+verificationList);
                for (Verification__c veri : verificationList) {
                    String temp=veri.Verification_Type__c;  
                    if(temp!=null){
                        if(temp.contains('Bank') || temp.contains('Office') || temp.contains('Residence') || temp.contains('PERMANENT') )
                        {
                            finalverificationList.add(veri);
                        }    
                        
                    }
                    
                }
                
                System.debug('VerificationList final: '+finalverificationList);
                data.veriList = finalverificationList;
                
            }
            dedupelist.clear();
            if(!CommonUtility.isEmpty(oppID)){
                dedupelist=[SELECT  id,Source_Or_Target__c,Area_Status__c FROM De_Dupe__c WHERE Loan_Application__c=:oppID AND Source_Or_Target__c='Source'];
                //dedupelist[0].Area_Status__c='Positive';  //for testing
                System.debug('Dedupe Query '+dedupelist);
                if(!CommonUtility.isEmpty(dedupelist)){
                    List<De_Dupe__c> dedupeList1 = new List<De_Dupe__c>();
                    dedupeList1.add(dedupelist[0]);
                    data.dedupeList = dedupeList1 ;
                    System.debug('Final Dedupe OBJ'+data.dedupeList);
                }
            }
            else
                data.dedupeList = null;
        }catch(Exception e)
        {
            System.debug('inside getDashboard Details details '+e.getMessage()+e.getLineNumber()+e.getCause());
        }
        
        return JSON.serialize(data);
    }    
    
    
    
    public static String updateCKYCDetails(String jsoncontactObj, String jsonaccountObj, String jsonappObj, String oppObj,Boolean copyresiaddress) {
        system.debug('inside  updateCKYCDetails' + jsoncontactObj + jsonaccountObj + jsonappObj + copyresiaddress + oppObj);
        List < sObject > genericData = new List < sObject > ();
        oppData data= new oppData();
        Contact contactObj = new Contact();
        try {
            genericData = (List < sObject > )JSON.deserialize(jsoncontactObj, List < sObject > .class);
            if (genericData != null) 
                contactObj = (Contact)genericData[0];
            
            Account accountObj = new Account();
            genericData = (List < sObject > )JSON.deserialize(jsonaccountObj, List < sObject > .class);
            if (genericData != null) 
                accountObj = (Account)genericData[0];
            Opportunity oppObject = new Opportunity();
            genericData = (List < sObject > )JSON.deserialize(oppObj, List < sObject > .class);
            if (genericData != null) 
                oppObject = (Opportunity)genericData[0];
            if (!CommonUtility.isEmpty(contactObj)) {
                system.debug('contactObj.Permanent_Pin_Code__c' + contactObj.Permanent_Pin_Code__c);
                //Commented for City CR
                /*if (!CommonUtility.isEmpty(String.valueOf(contactObj.Permanent_Pin_Code__c))) {
String City;
if (copyresiaddress) {
contactObj.Permanant_City__c = accountObj.Current_City__c;
contactObj.Permanent_State__c = accountObj.Current_State__c;
} else {
City = SOLDynamicController.getCityFromPincode(String.valueOf(contactObj.Permanent_Pin_Code__c));
contactObj.Permanant_City__c = City;
if (!CommonUtility.isEmpty(City))
contactObj.Permanent_State__c = SOLDynamicController.fetchStateRemote(City);

if(CommonUtility.isEmpty(City) || CommonUtility.isEmpty(SOLDynamicController.fetchStateRemote(City))){
data.status = 'City Fail';
return JSON.serialize(data);
} 

}
system.debug('contactObj.Permanant_City__c ' + contactObj.Permanant_City__c);
system.debug('contactObj.Permanent_State__c ' + contactObj.Permanent_State__c);
}
if (!CommonUtility.isEmpty(contactObj.Office_Pin_Code__c)) {
String City = SOLDynamicController.getCityFromPincode(contactObj.Office_Pin_Code__c);
contactObj.Office_City__c = City;
if (!CommonUtility.isEmpty(City))
contactObj.Office_State__c = SOLDynamicController.fetchStateRemote(City);

if(CommonUtility.isEmpty(City) || CommonUtility.isEmpty(SOLDynamicController.fetchStateRemote(City))){
data.status = 'City Fail';
return JSON.serialize(data);
} 
system.debug('contactObj.Office_City__c ' + contactObj.Office_City__c);
system.debug('contactObj.Office_State__c ' + contactObj.Office_State__c);
}*/
                update contactObj;
            }
            
            if (!CommonUtility.isEmpty(accountObj)) {
                accountObj.Permanent_PinCode__c =contactObj.Permanent_Pin_Code__c;
                accountObj.Permanent_City__c = contactObj.Permanant_City__c;
                accountObj.Permanent_State__c = contactObj.Permanent_State__c;
                accountObj.Office_City__c = contactObj.Office_City__c;
                accountObj.Office_State__c = contactObj.Office_State__c;
                if(contactObj.Office_Pin_Code__c != null)
                    accountObj.Office_Pin_Code__c = Decimal.valueof(contactObj.Office_Pin_Code__c);
                accountObj.Residence_TypeAcc__c = contactObj.Residence_Type__c;
                accountObj.Marital_Status__c = contactObj.Marital_status__c;
                
                
                update accountObj;
            }
            
            oppObject.Customer_Email_Id__c = contactObj.Email__c;
            upsert oppObject;
            Applicant__c appObj = new Applicant__c();
            genericData = (List < sObject > )JSON.deserialize(jsonappObj, List < sObject > .class);
            if (genericData != null) 
                appObj= (Applicant__c)genericData[0];
            if (!CommonUtility.isEmpty(appObj)) {
                update appObj;
            }
            /*added by swapnil bug :20939 s*/
            update accountObj;
            try{
                System.debug('On app creation cust email called method');
                gensendSMS(oppObject,null,'On app creation cust email');
            }catch(Exception e){
                
            }
            /*added by swapnil bug :20939 e*/
            List<SOL_Policy__c> solPolicyList= new List<SOL_Policy__c>();       
            solPolicyList=[select id, Policy_Name__c,Checklist_Policy_Status__c from SOL_Policy__c where Loan_Application__c = : oppObject.Id AND Name LIKE 'Sales2.0%'    ];
            /*20939 s
List<SOL_Policy__c> listToDel = new List<SOL_Policy__c>();*/
            List<SOL_Policy__c> newList= new List<SOL_Policy__c>();       
            SOl_policy__c sp = new Sol_policy__c(); 
            /*20939 e*/
            for(SOL_Policy__c sol : solPolicyList){
                if(sol.Policy_Name__c.contains('Veri- Permanent'))
                    sp = sol; //20939
            }
            //20939 changed below logic from delete insert to upsert
            if( contactObj.Residence_Type__c == 'Owned by Self/Spouse'|| contactObj.Residence_Type__c == 'Owned by Parent/Sibling'){
                
                sp.Policy_Name__c = 'Veri- Permanent Pass';
                sp.Policy_Status__c = 'OK';
                sp.Loan_Application__c = oppObject.Id;
                sp.Applicant_Name__c = appObj.Id;
                sp.RetriggerBRE__c = false;
                newList.add(sp);
                //OpportunityMobilityUtility.policyList = solPolicyList;  
                //OpportunityMobilityUtility.createPolicyRecord('Veri- Permanent Pass', 'OK', oppObj.Id,appObj.Id );
                for(SOL_Policy__c sol : newList){
                    String name = 'Sales2.0';
                    if(sol.Policy_Name__c == 'Veri- Permanent Pass')
                        sol.Name = name+' Veri- Permanent';
                }
                
            }    
            else{
                sp.Policy_Name__c = 'Veri- Permanent Fail';
                sp.Policy_Status__c = 'Rejected';
                sp.Loan_Application__c = oppObject.Id;
                sp.Applicant_Name__c = appObj.Id;
                newList.add(sp);
                //OpportunityMobilityUtility.policyList = solPolicyList;  
                //OpportunityMobilityUtility.createPolicyRecord('Veri- Permanent Pass', 'OK', oppObj.Id,appObj.Id );
                for(SOL_Policy__c sol : newList){
                    String name = 'Sales2.0';
                    if(sol.Policy_Name__c == 'Veri- Permanent Fail')
                        sol.Name = name+' Veri- Permanent';
                }
                //upsert newList;
            } 
            if(newList.size() > 0)
                upsert newList;
            //if(listToDel.size() > 0)
            //delete listToDel;
            data.accObj =accountObj;
            data.applicantPrimary = appObj;
            data.objCon = contactObj;
            
        } catch (Exception ex) {
            System.debug(' inside updateCKYCDetails exception' + ex.getMessage() + ex.getLineNumber() + ex.getCause());
            return null;
        }
        return JSON.serialize(data);
    }
    
    public static string saveDedupeRecords(String oppId, string deduperec)
    {
        List<De_Dupe__c> dedupeList = (List<De_Dupe__c>) JSON.deserialize(deduperec, List<De_Dupe__c>.class);
        upsert dedupeList;
        oppData dss = new oppData();
        dss.dedupeList = dedupeList;
        return JSON.serialize(dss);
    }
    /* Bug : 17139  S */
    public static string updateVerificationRecord(String oppId, string verifyRecs)
    {
        List<verification__c> verifyList = (List<verification__c>) JSON.deserialize(verifyRecs, List<verification__c>.class);
        upsert verifyList;
        oppData dss = new oppData();
        dss.veriList = verifyList;
        return JSON.serialize(dss);
    }
    public static string fireVerifications(String oppId, string verType)
    {
        oppData dss = new oppData();
        try{
            List<Opportunity> oppList = [Select Branch_Name__r.Name,Product__c from Opportunity where Id =: oppId];
            Opportunity Loan = new Opportunity();
            if(oppList != null && oppList.size() > 0)
                Loan = oppList[0];       
            List < Verification_Agency_Master__c > lstVAM = [select Id, Name, Location__c, Mail_Id__c, Verification_Types__c, Verification_Agency_User__c, Product__c, Active_Flag__c, Bank_Name__c, Verification_Agency_Type__c
                                                             //Added Extra field to identity if currenty verification agency is of RSA type or not 
                                                             ,Is_RSA_Agency__c
                                                             FROM Verification_Agency_Master__c where Product__c includes(: Loan.Product__c) and Active_Flag__c = true AND  Verification_Agency_Type__c != 'Fraud' AND (Verification_Agency_User__c = null OR (Verification_Agency_User__c != null AND Verification_Agency_User__r.IsActive = true))];
            
            List<applicant__c> applist = [select Id,PAN_Number__c,Applicant_Type__c,Contact_Name__c,Loan_Application__r.owner.id,Contact_Name__r.Address_1__c,Contact_Name__r.Address_2__c,Contact_Name__r.Address_3__c,Contact_Name__r.Pin_Code__c,Contact_Name__r.Office_City__c,Contact_Name__r.Phone_Number__c,Contact_Name__r.Mobile__c,Contact_Name__r.Designation__c,Contact_Name__r.Office_State__c,Contact_Name__r.Office_Phone_Number__c,Contact_Name__r.Address_Line_One__c,Contact_Name__r.Address_2nd_Line__c,Contact_Name__r.Address_3rd_Line__c,Contact_Name__r.Office_Pin_Code__c,Contact_Name__r.Employer__c,Contact_Name__r.Employer__r.name,Contact_Name__r.Name_of_Employer__c,Contact_Name__r.AppCity__c,Proof_of_Registered_Address_Submitted__c from applicant__c where Loan_Application__c = : oppId and Applicant_Type__c = 'Primary'];
            if(applist.size() > 0){
                Applicant__c app = new Applicant__C();
                app = applist[0];
                Verification__c ObjVfy = new Verification__c();
                objVfy.Applicant__c = app.Id;
                if (app.Contact_Name__c != null) {
                    objVfy.Contact__c = app.Contact_Name__c;
                }
                if(app.Contact_Name__r.Office_City__c != null) {
                    objVfy.Office_City__c = app.Contact_Name__r.Office_City__c;
                }
                if (app.Contact_Name__r.Mobile__c != null) {
                    objVfy.Mobile_Number__c = app.Contact_Name__r.Mobile__c;
                }
                
                objVfy.Loan_Application__c = oppId;
                objVfy.OwnerId = app.Loan_Application__r.owner.id;
                
                if (verType == 'Residence verification') {
                    String StrResAdd = '';
                    if (app.Contact_Name__r.Address_1__c != null) {
                        StrResAdd = app.Contact_Name__r.Address_1__c;
                    }
                    if (app.Contact_Name__r.Address_2__c != null) {
                        StrResAdd = StrResAdd + ',' + app.Contact_Name__r.Address_2__c;
                    }
                    if (app.Contact_Name__r.Address_3__c != null) {
                        StrResAdd = StrResAdd + ',' + app.Contact_Name__r.Address_3__c;
                    }
                    if (app.Contact_Name__r.Pin_Code__c != null) {
                        StrResAdd = StrResAdd + ',' + app.Contact_Name__r.Pin_Code__c;
                    }
                    objVfy.Address__c = StrResAdd;
                    
                    if (app.Contact_Name__r.Phone_Number__c != null) {
                        objVfy.Phone_number__c = app.Contact_Name__r.Phone_Number__c;
                    }
                    objVfy.Verification_Type__c = 'Residence verification';
                    
                }
                else if (verType == 'PERMANENT ADDRESS VERIFICATION') {
                    String StrResAdd = '';
                    if (app.Contact_Name__r.Address_1__c != null) {
                        StrResAdd = app.Contact_Name__r.Address_1__c;
                    }
                    if (app.Contact_Name__r.Address_2__c != null) {
                        StrResAdd = StrResAdd + ',' + app.Contact_Name__r.Address_2__c;
                    }
                    if (app.Contact_Name__r.Address_3__c != null) {
                        StrResAdd = StrResAdd + ',' + app.Contact_Name__r.Address_3__c;
                    }
                    if (app.Contact_Name__r.Pin_Code__c != null) {
                        StrResAdd = StrResAdd + ',' + app.Contact_Name__r.Pin_Code__c;
                    }
                    objVfy.Address__c = StrResAdd;
                    if (app.Contact_Name__r.Phone_Number__c != null) {
                        objVfy.Phone_number__c = app.Contact_Name__r.Phone_Number__c;
                    }
                    objVfy.Verification_Type__c = 'PERMANENT ADDRESS VERIFICATION';
                    
                }
                else if (verType == 'Office verification') 
                {
                    if (app.Contact_Name__r.Designation__c != null) {
                        objVfy.Designation__c = app.Contact_Name__r.Designation__c;
                    }
                    if (app.Contact_Name__r.Office_Phone_Number__c != null) {
                        objVfy.Phone_number__c = app.Contact_Name__r.Office_Phone_Number__c;
                    }
                    string StrOffAdd ='',StrPayOff ='';
                    if (app.Contact_Name__r.Address_Line_One__c != null) {
                        StrOffAdd = app.Contact_Name__r.Address_Line_One__c;
                    }
                    if (app.Contact_Name__r.Address_2nd_Line__c != null) {
                        StrOffAdd = StrOffAdd + ',' + app.Contact_Name__r.Address_2nd_Line__c;
                    }
                    if (app.Contact_Name__r.Address_3rd_Line__c != null) {
                        StrOffAdd = StrOffAdd + ',' + app.Contact_Name__r.Address_3rd_Line__c;
                    }
                    if (app.Contact_Name__r.Office_City__c != null) {
                        StrOffAdd = StrOffAdd + ',' + app.Contact_Name__r.Office_City__c;
                    }
                    if (app.Contact_Name__r.Office_Pin_Code__c != null) {
                        StrOffAdd = StrOffAdd + ',' + app.Contact_Name__r.Office_Pin_Code__c;
                    }
                    if (app.Contact_Name__r.Employer__c != null) {
                        objVfy.Employer_Name__c = app.Contact_Name__r.Employer__r.name;
                    }
                    objVfy.Address__c = StrOffAdd;
                    //Bug 5709 Ends
                    if (app.Contact_Name__r.Name_of_Employer__c != null) {
                        objVfy.Others_Employer__c = app.Contact_Name__r.Name_of_Employer__c;
                    }
                    
                    if (app.Contact_Name__r.Address_Line_One__c != null) {
                        StrPayOff = app.Contact_Name__r.Address_Line_One__c;
                    }
                    if (app.Contact_Name__r.Address_2nd_Line__c != null) {
                        StrPayOff = StrPayOff + ',' + app.Contact_Name__r.Address_2nd_Line__c;
                    }
                    if (app.Contact_Name__r.Address_3rd_Line__c != null) {
                        StrPayOff = StrPayOff + ',' + app.Contact_Name__r.Address_3rd_Line__c;
                    }
                    if (app.Contact_Name__r.Office_City__c != null) {
                        StrPayOff = StrPayOff + ',' + app.Contact_Name__r.Office_City__c;
                    }
                    if (app.Contact_Name__r.Office_Pin_Code__c != null) {
                        StrPayOff = StrPayOff + ',' + app.Contact_Name__r.Office_Pin_Code__c;
                    }
                    if (app.Contact_Name__r.Office_State__c != null) {
                        StrPayOff = StrPayOff + ',' + app.Contact_Name__r.Office_State__c;
                    }
                    objVfy.Employer_Address__c = StrPayOff;
                    
                    /*
if (app.Contact_Name__r.Address_1st_Line__c != null) {
StrRegdOffAdd = app.Contact_Name__r.Address_1__c;
}
if (app.Contact_Name__r.Address_2__c != null) {
StrRegdOffAdd = StrRegdOffAdd + ',' + app.Contact_Name__r.Address_2__c;
}
if (app.Contact_Name__r.Address_3__c != null) {
StrRegdOffAdd = StrRegdOffAdd + ',' + app.Contact_Name__r.Address_3__c;
}
if (app.Contact_Name__r.AppCity__c != null) {
StrRegdOffAdd = StrRegdOffAdd + ',' + app.Contact_Name__r.AppCity__c;
}
if (app.Contact_Name__r.Pin_Code__c != null) {
StrRegdOffAdd = StrRegdOffAdd + ',' + app.Contact_Name__r.Pin_Code__c;
}*/
                    objVfy.Verification_Type__c = 'Office verification';
                }
                else if(verType == 'Bank Statements') 
                {
                    List<Bank_Account__c> banksallists = new List<Bank_Account__c>();
                    banksallists = [select id, Bank_Type__c, name, Bank_Name__c, Bank_Account_Number__c, IFSC_Bank_Name__c, Bank_Acct_Number__c, Bank_Branch__c, Applicant__c, Applicant__r.Applicant_Type__c,Perfios_Flag__c, Send_Email_For_Perfios__c,StatusOfBankAccount__c,Salary_Credit_Date1__c,Salary_Credit_Date2__c,Salary_Credit_Date3__c from Bank_Account__c where Loan_Application__c = :oppId AND Applicant__c = : app.Id LIMIT 1];
                    if(banksallists.size() > 0 && app.Id == banksallists[0].Applicant__c){
                        objVfy.Applicant_Type__c = app.Applicant_Type__c;
                        objVfy.PAN_Number__c = app.PAN_Number__c;
                        objVfy.Name_of_the_Bank__c = banksallists[0].Bank_Name__c;
                        objVfy.Account_No__c = banksallists[0].Bank_Acct_Number__c; 
                        objVfy.Name_of_the_Branch__c = banksallists[0].Bank_Branch__c;
                        
                    }
                    for (integer i = 0; i < lstVAM.size(); i++) {
                        if (lstVAM[i].Product__c != null && lstVAM[i].Verification_Types__c != null && Loan.Branch_Name__r.Name != null) {
                            if ((lstVAM[i].Verification_Types__c.CONTAINS('Bank Statements')) && (!commonUtility.isEmpty(lstVAM[i].Location__c) && lstVAM[i].Location__c.ToUpperCase() == Loan.Branch_Name__r.Name.ToUpperCase())) {
                                system.debug('***%%match**lstVAM****' + lstVAM);
                                objVfy.Verification_Agency__c = lstVAM[i].id;
                                
                                if (lstVAM[i].Verification_Agency_User__c == null) {
                                    objVfy.hiddenText__c = lstVAM[i].Id + ',' + lstVAM[i].Mail_Id__c;
                                } else {
                                    objVfy.hiddenText__c = lstVAM[i].Id + ',' + lstVAM[i].Mail_Id__c + ',' + lstVAM[i].Verification_Agency_User__c;
                                    objVfy.OwnerId = lstVAM[i].Verification_Agency_User__c;
                                }
                            }
                        }
                    }
                    objVfy.Verification_Type__c = 'Bank Statements';
                }
                insert objVfy;
                List<verification__c> veriList = new List<verification__c>();
                veriList.add(objVfy);
                dss.veriList = veriList;
                if(verType == 'Residence verification'){
                    app.Residence_Status__c = true;
                }
                else if(verType == 'PERMANENT ADDRESS VERIFICATION'){
                    app.Permanent_Address_Verification__c = true;
                }
                else if(verType == 'Office verification'){
                    app.Office_Status__c = true;
                }
                else if(verType == 'Bank Statements') 
                {
                    app.Bank_Status__c = true;
                }
                update app;
            }
        }
        catch(Exception e){
            system.debug('Exception>>'+e.getMessage());
        }
        return JSON.serialize(dss);
    }
    /* Bug : 17139 E */
    public static string saveChecklistdocuments(String oppId, string standardDoc , string deviationDoc)
    {
        List<LightningDocumentWrapper> standardDocList = (List<LightningDocumentWrapper>) JSON.deserialize(standardDoc, List<LightningDocumentWrapper>.class);
        List<LightningDocumentWrapper> deviationDocList = (List<LightningDocumentWrapper>) JSON.deserialize(deviationDoc, List<LightningDocumentWrapper>.class);
        oppData dss = new oppData();
        
        system.debug('standardDocList>>'+standardDocList);
        system.debug('deviationDocList>>'+deviationDocList);
        try {
            List < Checklist__c > checklistTrnxListToUpdate = new List < Checklist__c > ();
            List < SalesEligibilityDetailsCtrl.DocumentWrapper > docWrapperList = new List < SalesEligibilityDetailsCtrl.DocumentWrapper > ();
            List < SalesEligibilityDetailsCtrl.DocumentWrapper > deviationDocWrapperList = new List < SalesEligibilityDetailsCtrl.DocumentWrapper > ();
            if(standardDocList != null && standardDocList.size() > 0){
                
                for(LightningDocumentWrapper documentObj : standardDocList){
                    /*   SalesEligibilityDetailsCtrl.DocumentWrapper  docObj = new SalesEligibilityDetailsCtrl.DocumentWrapper();
docObj.docName   = documentObj.docName; 
docObj.rowNum = documentObj.rowNum;
docObj.docFamObj = documentObj.docFamObj; 
docObj.showPicklist = documentObj.showPicklist; 
docObj.selectedDoc = documentObj.selectedDoc; 
//docObj.documentList = documentObj.documentList; 
docObj.singleDoc = documentObj.singleDoc; 
docWrapperList.add(docObj);*/
                    checklistTrnxListToUpdate.add(documentObj.docFamObj);
                }
            }
            
            if(deviationDocList != null && deviationDocList.size() > 0){
                
                for(LightningDocumentWrapper documentObj : deviationDocList){
                    /* SalesEligibilityDetailsCtrl.DocumentWrapper  docObj = new SalesEligibilityDetailsCtrl.DocumentWrapper();
docObj.deviationName    = documentObj.deviationName ; 
docObj.rowNum = documentObj.rowNum;
docObj.docFamObj = documentObj.docFamObj; 
docObj.showPicklist = documentObj.showPicklist; 
docObj.selectedDoc = documentObj.selectedDoc; 
// docObj.documentList = documentObj.documentList; 
docObj.singleDoc = documentObj.singleDoc;
deviationDocWrapperList.add(docObj);*/
                    checklistTrnxListToUpdate.add(documentObj.docFamObj);
                }
            }
            
            
            /*  for (SalesEligibilityDetailsCtrl.DocumentWrapper obj: docWrapperList) {
system.debug('obj.selectedDoc>>'+obj.selectedDoc);
if (obj.selectedDoc != null && obj.selectedDoc != '') obj.docFamObj.Document__c = obj.selectedDoc;
else if (obj.singleDoc != null && obj.singleDoc != '') obj.docFamObj.Document__c = obj.singleDoc;
checklistTrnxListToUpdate.add(obj.docFamObj);
system.debug('savedoc>>>'+obj.docFamObj.Document__c);
}
for (SalesEligibilityDetailsCtrl.DocumentWrapper obj: deviationDocWrapperList) {
if (obj.selectedDoc != null && obj.selectedDoc != '') obj.docFamObj.Document__c = obj.selectedDoc;
else if (obj.singleDoc != null && obj.singleDoc != '') obj.docFamObj.Document__c = obj.singleDoc;
checklistTrnxListToUpdate.add(obj.docFamObj);

}*/
            if(checklistTrnxListToUpdate != null && checklistTrnxListToUpdate.size() > 0)
                upsert checklistTrnxListToUpdate;
            
            /*  Integer documentCount = 0;
for (Checklist__c chk: checklistTrnxListToUpdate) 
{
system.debug('chk.Sales_Status__c==' + chk.Sales_Status__c);
if (chk.Mandatory__c == true && chk.Sales_Status__c != 'Received') 
documentCount = documentCount + 1;
}
*/
            /* if (documentCount > 0) 
{
dss.status = 'Document Error';
} 
else 
{
dss.isCheckListRecord = true;
}*/
            return 'success';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Status has been recorded successfully !!'));
            // savedMessage = 'Details saved successfully.';
            // savedMessageBody = 'Details saved successfully';
        } catch (Exception e) {
            //savedMessage = 'Exception occured: '+e.getMessage();
            //savedMessageBody = 'Exception occured: '+e.getMessage();
            system.debug('error'+e);
        }
        return null;
        // return JSON.serialize(dss); 
    }
    
    
    public static String fetchPerfiosBankAccount(String fetchLoanApplicationId)
    {
        system.debug('Opp Id++'+fetchLoanApplicationId);            
        oppData data = new oppData();
        List<String> appList = new List<String>();
        Set<Id> setAppId = new Set<Id>();
        /*Rohit added for mcp Start
getAllData(fetchLoanApplicationId,data);
Decimal averageSal = 0.0;
if(data.camObj != null){

if(data.camObj.Net_Salary_for_Month1__c != null)averageSal+=data.camObj.Net_Salary_for_Month1__c;
if(data.camObj.Net_Salary_for_Month2__c!= null)averageSal+=data.camObj.Net_Salary_for_Month2__c;
if(data.camObj.Net_Salary_for_Month3__c!= null)averageSal+=data.camObj.Net_Salary_for_Month3__c;
}
Account acc = data.accObj;
if(acc != null && averageSal > 0.0){
acc.Gross_Salary_Turn_Over__c = averageSal/3;
//update acc;
}
//Rohit added for mcp stop */
        List<Bank_Account__c> listBankAcc = new List<Bank_Account__c>();
        try
        {
            if(fetchLoanApplicationId != NULL)
            {
                List<Applicant__c> listApplicant = [SELECT Id,Applicant_Type__c,Proof_of_Registered_Address_Submitted__c,Loan_Application__c,Contact_Name__c,ContactName__c
                                                    FROM Applicant__c
                                                    WHERE Loan_Application__c =: fetchLoanApplicationId];
                system.debug('listApplicant++'+listApplicant);            
                
                if(listApplicant.size() > 0)
                {
                    for(Applicant__c app : listApplicant) 
                    {
                        if (app != null && app.ContactName__c != null)
                        {
                            system.debug('Loop++'+app.ContactName__c);                    
                            setAppId.add(app.Id);
                            appList.add(app.ContactName__c);    
                        }
                    }
                    data.allApps = listApplicant;
                    data.applicantNameList = appList;
                    system.debug('Data App++'+data.applicantNameList);            
                }  
                system.debug('setAppId++'+setAppId);
                
                List<Bank_Account__c> listBankAccount = new List<Bank_Account__c>();
                listBankAccount = [SELECT Salary_Credit_Date1__c,Perfios_inwardChqBounces__c,Perfios_inwardECSBounces__c,Salary_Credit_Date2__c,Salary_Credit_Date3__c,Id,Perfios_Bank_Name__c,Bank_Account_Number__c,Perfios_Start_Date__c,Perfios_End_Date__c,Perfios_Flag__c,Applicant__r.ContactName__c,Bank_Acct_Number__c,Bank_Name__c,Applicant__c,Loan_Application__c,Applicant__r.Applicant_Type__c,Bank_Name_List__c, Send_Email_For_Perfios__c 
                                   FROM Bank_Account__c 
                                   WHERE Loan_Application__c =: fetchLoanApplicationId]; //AND Salaried_CAM__c = true
                
                system.debug('listBankAccount++'+listBankAccount);
                if(listBankAccount.size() > 0)
                {
                    for(Bank_Account__c bank : listBankAccount) 
                    {
                        if (bank != null)
                        {
                            listBankAcc.add(bank);    
                        }
                    }
                    data.bankList = listBankAcc;
                    system.debug('Data Bank++'+data.bankList);            
                    
                }
                Bank_Account__c bank = new Bank_Account__c();
                data.bankNameList = getselectOptions(bank, 'Bank_Name_List__c'); 
                system.debug('Data Bank++'+data.bankNameList); 
                List<Cam__c> camList = [select Business_Continuty__c,/*24997 s*/Gross_Salary_Month1__c,Gross_Salary_Month2__c,Gross_Salary_Month3__c/*24997 e*/,id,LAP_EMI__c,Avg_qtrly_incentive__c,Average_incentive_for_Q1__c,Average_incentive_for_Q3__c,Average_incentive_for_Q2__c,Maxi_EMI_Cust__c,Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c,Average_Monthly_Net_Income1__c,Applicable_FOIR1__c,Loan_Application__c,EMI_of_The_Loan__c,Receips5_Doc__c,Receips6_Doc__c,Unsecured_FOIR__c,Eligible_FOIR__c,Total_Mthly_Oblig__c,EMI__c,ROI__c,sal_max_loan__c,Net_Salary_for_Month1__c,Net_Salary_for_Month2__c,Net_Salary_for_Month3__c,Proposed_Loan_Amt__c,Tenor__c,Eligible_Loan__c,Monthly_Reimbursement__c,Avg_mthly_incntve_3mts__c,Rental_Income__c,Receips4_Doc__c,Existing_HL_EMI__c,Month1_Doc__c,Month2_Doc__c,Month3_Doc__c,LAP_pmt__c,Avg_monthly_incentive1__c,Avg_monthly_incentive2__c,Avg_monthly_incentive3__c,Incentive_Monthly_or_Quarterly__c 
                                        from CAM__c where Loan_Application__c =:fetchLoanApplicationId];
                if(camList != null && camList.size() >0)
                    data.camObj = camList[0];
                system.debug('data.camObj'+data.camObj);
            }
        }
        catch(Exception e)
        {
            system.debug('exception'+e.getMessage()+'Line number'+e.getLineNumber()+'   '+e.getStackTraceString());
        }
        return JSON.serialize(data);
    }
    
    public static List <String> getselectOptions(sObject objObject, string fld) 
    {
        List <String> allOpts = new List <String> ();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        List <Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : values) 
        {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
    
    //Rohit mobility Employment start
    
    public static String saveEmploymentDetails(Map<String,String> params){
        
        System.debug('robin in class '+JSON.deserialize(params.get('empContact'),LIst<Contact>.class));
        Account acc ;
        Contact con;
        Opportunity opp;
        List<Account> accList = (List<Account>)JSON.deserialize(params.get('empAccount'),LIst<Account>.class);
        LIst<Contact> conList = (List<Contact>)JSON.deserialize(params.get('empContact'),LIst<Contact>.class);
        LIst<Opportunity> oppList = (List<Opportunity>)JSON.deserialize(params.get('empOpp'),LIst<Opportunity>.class);
        if(accList != null && accList.size()>0)
            acc = accLIst[0];
        
        if(conList != null && conList.size()>0)
            con= conLIst[0];    
        if(oppList != null && oppList.size()>0)
            opp= oppList[0];    
        
        oppData dss = new oppData();
        
        if(acc != null && con != null && acc.Id != null && con.Id != null){
            try{
                /*City CR s*/
                acc.Office_City__c = con.Office_City__c;
                acc.Office_State__c = con.Office_State__c;
                acc.Office_Pin_Code__c = Decimal.valueof(con.Office_Pin_Code__c);
                /*City CR e*/
                update acc;
                con.DesignationOTP__c = acc.DesignationOTP__c;
                con.Total_Work_Experience_Yrs__c = Decimal.valueOf(acc.Total_Work_Experience_Yrs__c);
                con.Total_Work_Experience_Months__c = Decimal.valueOf(acc.Total_Work_Experience_Months__c);
                con.Current_experiance_in_Years__c = acc.Current_experiance_in_Years__c;
                con.Current_experiance_in_Month__c = acc.Current_experiance_in_Month__c;
                con.Qualification__c = acc.Qualification__c;
                con.DesignationOTP__c = acc.DesignationOTP__c;
                
                //Commented for City CR
                /*if (!CommonUtility.isEmpty(con.Office_Pin_Code__c)) {
String City = SOLDynamicController.getCityFromPincode(con.Office_Pin_Code__c);
con.Office_City__c = City;
system.debug('city is'+City);
if (!CommonUtility.isEmpty(City))
con.Office_State__c = SOLDynamicController.fetchStateRemote(City);
else
con.Office_State__c =null;

if(CommonUtility.isEmpty(City) || CommonUtility.isEmpty(SOLDynamicController.fetchStateRemote(City))){
system.debug('in city fail');
dss.status = 'City Fail';
return JSON.serialize(dss);
} 
system.debug('contactObj.Office_City__c ' + con.Office_City__c);
system.debug('contactObj.Office_State__c ' + con.Office_State__c);
}*/
                update con;
                dss.objCon = con;
                dss.accObj = acc;
                dss.opp = opp;
                dss.status = 'Success';
                System.debug('in success');
                return JSON.serialize(dss);
            }catch(Exception ex){
                System.debug('Exception --> '+ex.getMessage() +'  '+ex.getLineNumber());
                dss.status = 'Internal Server Error , Please try again later.';
                return JSON.serialize(dss);
            }
            
        }
        
        dss.status ='Failure';
        return JSON.serialize(dss);           
        
    }
    
    
    public static Oppdata callMCP(Map<String,String> params){
        //System.debug('params--->'+params.get('TypeForMCP'));
        Account acc;// = (Account)params.get('empAccount');
        Contact con; //= (Contact)params.get('empContact');
        Opportunity opp;// = (Opportunity)params.get('empOpp');
        Applicant__c appPrimary = new Applicant__c();
        CAM__c cam;
        String mcpType;
        Decimal averageSal = 0.0;
        String solPolicySrc;
        List<SOL_Policy__c> oldSol;
        List<Account> accList = (List<Account>)JSON.deserialize(params.get('empAccount'),List<Account>.class);
        LIst<Contact> conList = (List<Contact>)JSON.deserialize(params.get('empContact'),List<Contact>.class);
        LIst<Applicant__c> appLIst= new List<Applicant__c>();
        System.debug('appPrimary pk'+params.get('appObj'));
        if(params.get('appObj') != null && params.get('appObj') != ''){
            appLIst= (List<Applicant__c>)JSON.deserialize(params.get('appObj'),List<Applicant__c>.class);
            if(appList != null && appList.size()>0)
                appPrimary = appList[0]; 
            
            System.debug('appPrimary pk'+appPrimary );
        }
        LIst<Opportunity> oppLIst= (List<Opportunity>)JSON.deserialize(params.get('empOpp'),List<Opportunity>.class);
        mcpType = params.get('TypeForMCP');
        System.debug('mcpType'+mcpType);
        solPolicySrc = params.get('solPolicySrc');
        
        
        if(accList != null && accList.size()>0)
            acc = accLIst[0];
        
        if(conList != null && conList.size()>0)
            con= conLIst[0];   
        
        if(oppList != null && oppList.size()>0)
            opp= oppLIst[0]; 
        
        
        if(params.get('JSONCamObj') != null) 
            cam = (CAM__c)JSON.deserialize(params.get('JSONCamObj'),CAM__c.class);
        
        OppData dss = new oppData();
        System.debug('robin appPrimary mcp '+appPrimary);
        MAP < String, String> mapOfPolicyParameters = new MAP < String, String>();
        MAP < String, Object > mapOfPolicyResult = new MAP < String, Object> ();
        List<BRECallout.mcpList> MCPResult = new List<BRECallout.mcpList>();
        String FinalMCPResult = '';
        List < SOL_Policy__c > policyList = new List < SOL_Policy__c > ();
        List < SOL_Policy__c > policyhistroyList = new List < SOL_Policy__c > ();
        SOL_Policy__c  desigantionpolicy = new  SOL_Policy__c ();
        SOL_Policy__c  qualificationpolicy = new  SOL_Policy__c ();
        SOL_Policy__c  institutionpolicy = new  SOL_Policy__c ();
        SOL_Policy__c  totalworkexppolicy = new  SOL_Policy__c ();
        if(opp != null)
            policyList = [select id, Policy_Name__c,New_Address_Value__c ,Old_Address_Value__c,Policy_Status__c, Loan_Application__c,Checklist_Policy_Status__c, Applicant_Name__c
                          from SOL_Policy__c where Loan_Application__c = : opp.id AND Name LIKE 'Sales2.0%'
                         ];
        Map<String,Sol_Policy__c> solPolMap = new Map<String,Sol_Policy__c>(); //20939
        if(!CommonUtility.isEmpty(policyList) ){
            for(SOL_Policy__c sol: policyList)
            {
                /*20939 s*/
                String name = sol.Policy_Name__c;
                name = name.replace(' Pass','');
                name = name.replace(' Fail','');
                system.debug('name is'+name);
                solPolMap.put(name,sol);
                /*20939 e*/
                if(sol.Policy_Name__c.contains('Designation History'))
                    desigantionpolicy = sol;
                if(sol.Policy_Name__c.contains('Qualification History'))
                    qualificationpolicy = sol;
                if(sol.Policy_Name__c.contains('Institution History'))
                    institutionpolicy = sol;
                if(sol.Policy_Name__c.contains('Total Work Exp History'))
                    totalworkexppolicy = sol;
                
            }
        }
        if(!commonutility.isEmpty(desigantionpolicy) && !commonutility.isEmpty(desigantionpolicy.New_Address_Value__c))
        {
            if(desigantionpolicy.New_Address_Value__c !=  acc.DesignationOTP__c)
            {
                desigantionpolicy.Old_Address_Value__c = desigantionpolicy.New_Address_Value__c;
                desigantionpolicy.New_Address_Value__c = acc.DesignationOTP__c;
            }
        }
        else{
            desigantionpolicy.Name = 'Sales2.0 Designation History';
            desigantionpolicy.Policy_Name__c = 'Designation History';
            desigantionpolicy.Loan_Application__c = opp.Id;
            desigantionpolicy.Applicant_Name__c = appPrimary.Id;
            desigantionpolicy.New_Address_Value__c = acc.DesignationOTP__c;
        }
        
        if(!commonutility.isEmpty(qualificationpolicy) && !commonutility.isEmpty(qualificationpolicy.New_Address_Value__c))
        {
            if(qualificationpolicy.New_Address_Value__c !=  acc.Qualification__c)
            {
                qualificationpolicy.Old_Address_Value__c = qualificationpolicy.New_Address_Value__c;
                qualificationpolicy.New_Address_Value__c = acc.Qualification__c;
            }
        }
        else{
            qualificationpolicy.Name = 'Sales2.0 Qualification History';
            qualificationpolicy.Policy_Name__c = 'Qualification History';
            qualificationpolicy.Loan_Application__c = opp.Id;
            qualificationpolicy.Applicant_Name__c = appPrimary.Id;
            qualificationpolicy.New_Address_Value__c = acc.Qualification__c;
        }
        if(!commonutility.isEmpty(totalworkexppolicy) && !commonutility.isEmpty(totalworkexppolicy.New_Address_Value__c))
        {
            if(totalworkexppolicy.New_Address_Value__c !=  acc.Total_Work_Experience_Yrs__c+':'+acc.Total_Work_Experience_Months__c)
            {
                totalworkexppolicy.Old_Address_Value__c = totalworkexppolicy.New_Address_Value__c;
                totalworkexppolicy.New_Address_Value__c = acc.Total_Work_Experience_Yrs__c+':'+acc.Total_Work_Experience_Months__c;
            }
        }
        else{
            totalworkexppolicy.Name = 'Sales2.0 Total Work Exp History';
            totalworkexppolicy.Policy_Name__c = 'Total Work Exp History';
            totalworkexppolicy.Loan_Application__c = opp.Id;
            totalworkexppolicy.Applicant_Name__c = appPrimary.Id;
            totalworkexppolicy.New_Address_Value__c = acc.Total_Work_Experience_Yrs__c+':'+acc.Total_Work_Experience_Months__c;
        }
        if(!commonutility.isEmpty(institutionpolicy) && !commonutility.isEmpty(institutionpolicy.New_Address_Value__c))
        {
            if(institutionpolicy.New_Address_Value__c !=  acc.Type_of_Educational_Institution__c)
            {
                institutionpolicy.Old_Address_Value__c = institutionpolicy.New_Address_Value__c;
                institutionpolicy.New_Address_Value__c = acc.Type_of_Educational_Institution__c;
            }
        }
        else{
            institutionpolicy.Name = 'Sales2.0 Institution History';
            institutionpolicy.Policy_Name__c = 'Institution History';
            institutionpolicy.Loan_Application__c = opp.Id;
            institutionpolicy.Applicant_Name__c = appPrimary.Id;
            institutionpolicy.New_Address_Value__c = acc.Type_of_Educational_Institution__c;
        }
        policyhistroyList.add(desigantionpolicy);
        policyhistroyList.add(qualificationpolicy);
        policyhistroyList.add(institutionpolicy);
        policyhistroyList.add(totalworkexppolicy);
        try{
            
            
            
            if(opp != null){
                
                //getAllData(opp.Id,dss);
                if(cam != null)
                {
                    system.debug('cam is'+cam+mcpType);
                    if(cam.Average_incentive_for_Q1__c!= null)averageSal+=cam.Average_incentive_for_Q1__c;
                    if(cam.Average_incentive_for_Q2__c!= null)averageSal+=cam.Average_incentive_for_Q2__c;
                    if(cam.Average_incentive_for_Q3__c!= null)averageSal+=cam.Average_incentive_for_Q3__c;
                    
                    
                    if(acc != null && averageSal > 0.0){
                        acc.Gross_Salary_Turn_Over__c = averageSal/3;
                    }
                }
                String branchName = '';
                String appSource = '';
                String dob = '';
                String compType = '';
                String loanId = '';
                String splProfile ='';
                String netSalary = '';
                String industry = '';
                String product = '';  
                Decimal totalEmpVintage = 0,currentEmpVintage = 0;  
                String branchType = '';
                String enhanceFlag='false';
                
                
                loanId =  opp.Id;
                product = opp.Product__c;
                List<Branch_Master__c> bList = [SELECT Name, Branch_Type__c from Branch_Master__c where Id =: opp.Branch_Name__c limit 1];
                if(bList.size() > 0)
                    branchName = bList[0].Name;
                List<Segment_Master__c>  segmentMaster = [SELECT Name, Sub_Industry__c, Company_Category__c from Segment_Master__c where Id =: acc.Employer__c];
                // system.debug('months'+Integer.valueof(acc.Total_Work_Experience_Months__c)/12+acc.Current_experiance_in_Month__c);
                if(acc.Offer_Inhanced__c==true)
                    enhanceFlag='true';
                if(opp.Application_Source__c != null)
                    appSource = opp.Application_Source__c;
                if(mcpType != null && mcpType == 'Experience' || mcpType.toUpperCase() == 'SAL'){
                    if(acc.Date_of_Birth__c != null)
                        dob = String.valueOf(acc.Date_of_Birth__c);
                    if(acc.Total_Work_Experience_Yrs__c != null)                
                        totalEmpVintage += Decimal.valueOf(acc.Total_Work_Experience_Yrs__c);   
                    if(acc.Total_Work_Experience_Months__c != null)                                 
                        totalEmpVintage += (Decimal.valueof(acc.Total_Work_Experience_Months__c)/12.0).setScale(2);   
                    if(acc.Current_experiance_in_Years__c != null)
                        currentEmpVintage+=Decimal.valueOf(acc.Current_experiance_in_Years__c);
                    if(acc.Current_experiance_in_Month__c != null)                                 
                        currentEmpVintage+= (Decimal.valueof(acc.Current_experiance_in_Month__c)/12.0).setScale(2);  
                    System.debug('in experience'+totalEmpVintage+currentEmpVintage );    
                }
                if(mcpType.toUpperCase() == 'DOB'){
                    
                    if(acc.Date_of_Birth__c != null)
                        dob = String.valueOf(acc.Date_of_Birth__c);
                    if(bList.size() > 0) /* 17139 */
                        branchType = bList[0].Branch_Type__c;
                    
                }
                
                if(mcpType.toUpperCase() == 'SAL'){
                    List<CAM__c> camList =new List<CAM__c>();
                    
                    
                    System.debug('robin cam '+cam);
                    if(cam != null){
                        Decimal avgSal = 0.0;                                          
                        avgSal = (cam.Average_incentive_for_Q1__c+cam.Average_incentive_for_Q2__c+cam.Average_incentive_for_Q3__c)/3;
                        if(avgSal != 0.0)
                            netSalary = String.valueOf(avgSal); 
                    }
                    if(bList.size() > 0) /* 17139 */
                        branchType = bList[0].Branch_Type__c;
                    if(segmentMaster[0].Company_Category__c  != null)
                        compType = segmentMaster[0].Company_Category__c;
                    if(segmentMaster[0].Sub_Industry__c  != null)
                        industry = segmentMaster[0].Sub_Industry__c;
                    //updated below three tags -Hrushikesh
                    if(acc.Date_of_Birth__c != null)
                        dob = String.valueOf(acc.Date_of_Birth__c);
                    if(bList.size() > 0) /* 17139 */
                        branchType = bList[0].Branch_Type__c;
                    
                    
                    
                    
                }
                
                if(con.Special_Profile_Employer__c != null)
                    splProfile = String.valueOf(con.Special_Profile_Employer__c);
                
                
                
                
                
                mapOfPolicyParameters.put('branch_name',branchName);  
                mapOfPolicyParameters.put('branchType',branchType);                 
                mapOfPolicyParameters.put('application_source',appSource);//need to know mapping
                mapOfPolicyParameters.put('date_of_birth',dob);
                mapOfPolicyParameters.put('company_type',compType);
                
                
                mapOfPolicyParameters.put('total_employment_vintage',String.valueOf(totalEmpVintage));
                mapOfPolicyParameters.put('current_employment_vintage',String.valueOf(currentEmpVintage));
                mapOfPolicyParameters.put('loan_id',loanId);
                mapOfPolicyParameters.put('specialProfile',splProfile);
                mapOfPolicyParameters.put('net_salary',netSalary);
                mapOfPolicyParameters.put('industry',industry);
                mapOfPolicyParameters.put('product',product);
                mapOfPolicyParameters.put('enhanced_offer',enhanceFlag); 
                
                
                System.debug('mapofpolicy '+mapOfPolicyParameters);
                
                if(!Test.isRunningTest()){
                    BRECallout breObj = new BRECallout();
                    mapOfPolicyResult = breObj.callBREMCPMobilityV2(mapOfPolicyParameters);             
                }
                
                if (mapOfPolicyResult != null && mapOfPolicyResult.size() > 0) {
                    FinalMCPResult = (STring)mapOfPolicyResult.get('mcp_policy');
                    MCPResult = (List<BRECallout.mcpList>)mapOfPolicyResult.get('mcp_List');
                }
                System.debug('oppid -->'+opp.id);
                System.debug('oppid -->'+appList.size());
                if(appList == null || appList.size() == 0){
                    appList = retApplicants(opp.id); 
                    //Applicant__c appPrimary = new Applicant__c();
                    System.debug('in appluicant list-->'+appList);
                    if(appList != null && appList.size()>0){
                        for(Applicant__c app :appList){
                            System.debug('in for loop');
                            if(app.Applicant_Type__c == 'Primary'){
                                System.debug('in if loop');
                                appPrimary = app;
                                break;
                            }
                        }
                    }
                }
                acc.Employer__r = null;
                con.Employer__r = null;
                System.debug('appPrimary -->'+acc.Employer__c+acc.Employer__r);
                String appId = (appPrimary != null)?appPrimary.Id :'';
                System.debug('mcp type '+mcpType);
                upsert policyhistroyList;
                system.debug('pin and state'+acc.Current_State__c+acc.Current_PinCode__c);
                upsert acc;
                con.AccountId =acc.id;
                system.debug('con is '+con);
                upsert con;
                opp.AccountId =acc.id;
                if(opp.Id == null){
                    if (opp.CloseDate == null) opp.CloseDate = System.Today() + 20;
                    if(opp.Application_Received_Date__c == null)    opp.Application_Received_Date__c  = System.today();
                    
                }
                upsert opp;
                appPrimary.Contact_Name__c = con.id;
                appPrimary.Loan_Application__c=opp.id;
                
                upsert appPrimary;
                dss.opp = opp;
                dss.objCon = con;
                dss.accObj = acc;
                dss.applicantPrimary = appPrimary;
                String tempPass=mcpType +' MCP PASS';
                String tempFail=mcpType +' MCP FAIL';
                /*commented for 20939 s
oldSol=[SELECT Id,name,Policy_Name__c,Loan_Application__c,New_Address_Value__c FROM SOL_Policy__c WHERE Loan_Application__c = : Opp.id AND (Policy_Name__c =: tempPass OR Policy_Name__c =: tempFail)];
delete oldSol;
e */
                if (FinalMCPResult != null && FinalMCPResult.ToUpperCase() == 'MCP FAIL') {
                    System.debug('in mcp fail '+FinalMCPResult);
                    policyList = [select id, Policy_Name__c, Policy_Status__c, Loan_Application__c, Applicant_Name__c
                                  from SOL_Policy__c where Loan_Application__c = : opp.id
                                 ];
                    
                    policyList.clear();       
                    //OpportunityMobilityUtility.policyList = policyList;  //20939 commented
                    /*20939 s*/
                    SOl_policy__c sp = new Sol_policy__c();
                    if(solPolMap.containskey(mcpType+' MCP'))
                        sp = solPolMap.get(mcpType+' MCP');
                    sp.Policy_Name__c = mcpType + ' MCP Fail';
                    sp.Policy_Status__c = 'Rejected';
                    sp.Loan_Application__c = Opp.Id;
                    sp.Applicant_Name__c = appId;
                    policyList.add(sp);
                    /*20939 e*/
                    /*commented for 20939
if(mcpType != null )
OpportunityMobilityUtility.createPolicyRecord(mcpType + ' MCP Fail', 'Rejected', Opp.id,appId);
*/
                    
                    if(MCPREsult != null && MCPREsult.size()>0){        
                        for (BRECallout.mcpList str: MCPResult) {
                            if (str != null && str.mcpDesc != '' && str.mcpDesc.ToUpperCase().contains('FAIL')) {
                                /*20939 s*/
                                SOl_policy__c sp1 = new Sol_policy__c();
                                if(solPolMap.containskey(str.mcpDesc.replace('PASS','')))
                                    sp1 = solPolMap.get(str.mcpDesc.replace('FAIL',''));
                                sp1.Policy_Name__c = str.mcpDesc;
                                sp1.Policy_Status__c = 'Rejected';
                                sp1.Loan_Application__c = Opp.Id;
                                sp1.Applicant_Name__c = appId;
                                policyList.add(sp1);
                                //OpportunityMobilityUtility.createPolicyRecord(str.mcpDesc, 'Rejected', Opp.id,appId );
                                /*20939 e*/
                            }                       
                        }
                    }
                    
                    if (policyList != null && policyList.size() > 0){
                        if(solPolicySrc != null){
                            for(SOL_Policy__c solp : policyList){
                                solp.Name = solPolicySrc+' MCP FAIL';
                                solp.Remarks__c = mcpType +' MCP Fail';
                                solp.RetriggerBRE__c = false; //20939
                                triggeredBRE.add(mcpType + ' MCP'); /*Bug 20939*/
                            }
                        }
                        
                        upsert policyList;
                    }   
                    
                    dss.status ='MCP check failed';
                    return dss; 
                }
                else if(FinalMCPResult != null && FinalMCPResult.ToUpperCase() == ('MCP Pass').toUpperCase()){
                    policyList = [select id, Policy_Name__c, Policy_Status__c, Loan_Application__c, Applicant_Name__c
                                  from SOL_Policy__c where Loan_Application__c = : opp.id
                                 ];
                    policyList.clear();
                    //OpportunityMobilityUtility.policyList = policyList; //20939 commented
                    
                    /*commented for 20939
if(mcpType != null )
OpportunityMobilityUtility.createPolicyRecord(mcpType +' MCP Pass', 'OK', Opp.id,appId);
*/
                    /*20939 s*/
                    SOl_policy__c sp = new Sol_policy__c();
                    if(solPolMap.containskey(mcpType+' MCP'))
                        sp = solPolMap.get(mcpType+' MCP');
                    system.debug('sp'+sp);
                    sp.Policy_Name__c = mcpType+' MCP Pass';
                    sp.Policy_Status__c = 'OK';
                    sp.Loan_Application__c = opp.Id;
                    sp.Applicant_Name__c = appId;
                    policyList.add(sp);
                    /*20939 e*/
                    if(MCPREsult != null && MCPREsult.size()>0){        
                        for (BRECallout.mcpList str: MCPResult) {
                            if (str != null && str.mcpDesc != '' && str.mcpDesc.ToUpperCase().contains('PASS')) {
                                /*20939 s*/
                                //OpportunityMobilityUtility.createPolicyRecord(str.mcpDesc, 'Rejected', Opp.id,appId );
                                SOl_policy__c sp1 = new Sol_policy__c();
                                if(solPolMap.containskey(str.mcpDesc.replace('PASS','')))
                                    sp1 = solPolMap.get(str.mcpDesc.replace('PASS',''));
                                sp1.Policy_Name__c = str.mcpDesc;
                                sp1.Policy_Status__c = 'Ok';
                                sp1.Loan_Application__c = Opp.Id;
                                sp1.Applicant_Name__c = appId;
                                policyList.add(sp1);
                                /*20939 e*/
                            }                       
                        }
                    }
                    
                    if (policyList != null && policyList.size() > 0){
                        if(solPolicySrc != null){
                            for(SOL_Policy__c solp : policyList){
                                solp.Name = solPolicySrc+' MCP Pass';
                                /*Bug 20939 s*/
                                solp.Remarks__c = '';
                                solp.RetriggerBRE__c = false;
                                triggeredBRE.add(mcpType + ' MCP'); 
                                /*Bug 20939 e*/
                            }
                        }
                        String temp=mcpType +' MCP Pass';
                        
                        upsert policyList; //20939 changes to upsert
                    }
                    
                    dss.status = 'Success';
                    return dss;
                    
                }
                else{
                    dss.status = 'Internal Server Error , Please try again later';
                    return dss;
                    
                }
            }           
            
        }catch(Exception ex){
            System.debug('Exception --> '+ex.getMessage() +'  '+ex.getLineNumber()+' '+ex.getStackTraceString());
            dss.status = 'Internal Server Error , Please try again later';
            return dss;
        }
        dss.status ='';  
        return dss;    
    }
    
    //Rohit mobility Employment end
    //Rohit ekyc mobility v2 start
    public static String saveEkycOpp(Map<String,String> params){
        System.debug('params '+params); 
        oppData dss = new oppData();
        
        try{ 
            if(params != null){
                
                eKYC__c kyc;
                Applicant__c app;
                
                List<eKYC__c> kycList = (List<eKYC__c>)JSON.deserialize(params.get('kyc'),List<eKYC__c>.class);
                List<Applicant__c> appList = (List<Applicant__c>)JSON.deserialize(params.get('appPrime'),List<Applicant__c>.class);
                
                if(kycList != null && kycList.size()>0)
                    kyc = kycList[0];
                
                if(appList != null && appList.size()>0)
                    app = appList[0];
                
                if(kyc != null && app != null){
                    kyc.Applicant__c = app.Id;
                    kyc.eKYC_Random_Number__c = fetchRandomNum(100);
                    kyc.Product__c = app.Product__c;
                    kyc.Source__c = app.Product__c;
                    System.debug('random number '+kyc.eKYC_Random_Number__c);
                    
                    app.eKYC_Processing__c = true;
                    app.HashCode__c = kyc.eKYC_Aadhaar_Number__c;
                    
                    update kyc;
                    update app;
                    
                    dss.currApp = app;
                    dss.ekycobj = kyc;
                    dss.status ='Success';
                    
                    return JSON.serialize(dss);
                }       
            }  
        }catch(Exception ex){
            System.debug('Exception '+ex.getMessage() +'  '+ex.getLineNumber());
            dss.status = 'Internal Server Error , Please try again later';
            return JSON.serialize(dss);
        } 
        dss.status = '';
        return JSON.serialize(dss);
    }
    
    public static Integer fetchRandomNum(Integer size){
        Double d = math.random() * size;
        return d.intValue();  
        
    }
    
    /*  function added for BugID  19124 start */
    public static String createSalMcpSOL(String oppId,String accJSON)
    {
        try{
            System.debug('in createSalMcpSOL');
            Account acc;
            SOL_Policy__c sp = new SOL_Policy__c();
            List<SOL_Policy__c> solPolicyList= new List<SOL_Policy__c>();       
            solPolicyList=[select id, Policy_Name__c from SOL_Policy__c where Loan_Application__c = : oppId AND Policy_Name__c LIKE '%Sal MCP%'];
            if(accJSON != null){
                acc= (Account)JSON.deserialize(accJSON,Account.class);
                System.debug('inside createSalMcpSOL'+acc);
                if(acc.Offer_Inhanced__c==false)
                {
                    sp.Name = 'Sales2.0 MCP Pass';
                    sp.Policy_Name__c ='Sal MCP Pass';
                    sp.Loan_Application__c = oppId;
                    sp.Policy_Status__c = 'OK';
                    insert sp;
                    System.debug('in if of createSalMcpSOL');               
                }   
                else
                {
                    if(CommonUtility.isEmpty(solPolicyList))
                    {
                        sp.Name = 'Sales2.0 MCP Pass';
                        sp.Policy_Name__c ='Sal MCP Pass';
                        sp.Loan_Application__c = oppId;
                        insert sp;  
                        System.debug('in else');                
                    }
                }
            }
            system.debug('*****policy inserted for SAL *' + sp);
        }catch(Exception e)
        {
            System.debug('Exception in creating SAL policy Record '+e.getLineNumber()+ e.getMessage());
        }
        return 'Pass';
    }
    /*  function added for BugID  19124 End */
    
    public static String fetchEkyc(String parentId){
        if(parentId != null){
            List<eKYC__c> ekycList = [SELECT eKYC_Mobile_Number__c,eKYC_Address_details__c,eKYC_E_mail__c,Id,eKYC_First_Name__c,eKYC_Last_Name__c,bio_Ekyc__c,eKYC_Gender__c,eKYC_Date_of_Birth__c,House__c,Masked_Email__c,Masked_Phone__c,Location__c,eKYC_Photo__c,eKYC_City__c,eKYC_State__c,eKYC_Pin_Code__c FROM eKYC__c WHERE Applicant__c =:parentId];
            
            ResponseDTO resDTO = new ResponseDTO();
            System.debug('ekycl list '+ekycList);
            if(ekycList != null && ekycList.size()>0){
                resDTO.ekycmobility = ekycList[0];
                resDTO.status = 'SUCCESS';
                resDTO.message = 'SUCCESS';
                
                return  JSON.serialize(resDTO); 
            }
            
            resDTO.status = 'Failure';
            resDTO.message = 'Failure';
            System.debug('here in else '+JSON.serialize(resDTO));
            return  JSON.serialize(resDTO); 
        }
        else{
            return null;
        }
    }
    //Rohit ekyc mobility v2 stop
    public static String callVerificationAPI(string oppId){
        
        BRECallout breObj = new BRECallout();
        String BRECodes = '';
        Map < String, String > mapOfVerifications = new Map < String, String > ();
        Map < String, String > mapOfInputVerifications = new Map < String, String > ();
        
        try{
            if(!commonutility.isEmpty(oppId)){
                Integer hlCount = 0;
                oppData dss = new oppData();
                getAllData(oppId,dss);
                List < Existing_Loan_Details__c > ExistLoans = [select id, Secured_Unsecured__c, Loan_Type__c, Seen_in__c,
                                                                Loan_Acc_No__c, Select__c, Applicant__r.ContactName__c, Principal_O_s__c, Status__c, Customer_Declared_EMI__c,
                                                                Financer__c, Amount__c, Month1_Amount__c, Month2_Amount__c, Financers__c, Obligation__c, Loan_Amount__c, EMI_Over_In_Next_6_months__c,
                                                                Start_On__c, Tenor__c, Tenor_Left__c, MOB__c, POS__c, EMI__c, Applicant__c, Annual_Obligation__c, Type_of_Oblig__c,
                                                                Month3Amount__c, Month4Amount__c, Month5Amount__c, Month6Amount__c, Mthly_Oblig__c, Remark__c, Derived_EMI__c
                                                                from Existing_Loan_Details__c where Loan_Application__c = : oppId order by CreatedDate
                                                               ];
                system.debug('Exist Loans'+ExistLoans);
                for (Existing_Loan_Details__c exp: ExistLoans) {
                    if ((exp.Loan_Type__c == 'HL' || exp.Loan_Type__c == 'Housing Loan' || exp.Loan_Type__c == 'Home Loan') && exp.Obligation__c == 'Yes') {
                        hlCount = hlCount + 1;
                    }
                }
                Applicant__c PrimaryApp = new Applicant__c();
                if(!commonutility.isEmpty(dss.applicantPrimary)){
                    PrimaryApp = dss.applicantPrimary;
                }
                Opportunity Loan = dss.opp;
                Account acc = dss.accObj;
                CAM__c camObj  = dss.camObj;
                Personal_Discussion__c pdObj = dss.pdObj; /* Bug : 17139  */
                Bank_Account__c bankObj = dss.bankObj;
                Contact con = dss.objCon;
                String datevariation = '';
                if(!CommonUtility.isEmpty(bankObj)){
                    if((!CommonUtility.isEmpty(bankObj.Perfios_Flag__c) && bankObj.Perfios_Flag__c == true)){
                        
                        Integer date1,date2,date3;
                        Integer diffDays12,diffDays13,diffDays23;
                        
                        if(!CommonUtility.isEmpty(bankObj.Salary_Credit_Date1__c))
                            date1 = bankObj.Salary_Credit_Date1__c.day();
                        if(!CommonUtility.isEmpty(bankObj.Salary_Credit_Date2__c))
                            date2 = bankObj.Salary_Credit_Date2__c.day();
                        if(!CommonUtility.isEmpty(bankObj.Salary_Credit_Date3__c))
                            date3 = bankObj.Salary_Credit_Date3__c.day();
                        if(!CommonUtility.isEmpty(date1) && !CommonUtility.isEmpty(date2)){
                            
                            diffDays12 = math.abs(date1-date2);
                            /*Integer months = date1.monthsBetween(date2);
for(Integer i = 0;i<months;i++){
Integer mon = date1.month()+i;
Integer days = date.daysInMonth(date1.year(),mon);
//system.debug('days in month'+days+'---'+diffDays12);
if(mon == date1.month() && date1.day() > 15 && date2.day() < 15){
}else{
diffDays12 = diffDays12 - days;
}
}*/
                            //diffDays12 = Integer.valueof(date1.getTime() - date2.getTime());
                            //integer Days = Integer.valueOf((Date2.getTime() - Date1.getTime())/(1000*60*60*24));
                            //system.debug('value of days'+days+'----'+diffDays12);
                        }
                        if(!CommonUtility.isEmpty(date1) && !CommonUtility.isEmpty(date3)){
                            diffDays13 = math.abs(date1-date3);
                        }
                        if(!CommonUtility.isEmpty(date2) && !CommonUtility.isEmpty(date3)){
                            diffDays23 = math.abs(date2-date3);
                        }
                        
                        if((!CommonUtility.isEmpty(diffDays12) && diffDays12 > 5) || (!CommonUtility.isEmpty(diffDays13) && diffDays13 > 5) || (!CommonUtility.isEmpty(diffDays23) &&diffDays23 >5))
                        {
                            datevariation = 'YES';
                        }
                        else
                        {
                            datevariation = 'NO';
                        }
                    }
                    else
                        datevariation = 'NO';
                }
                String amountvariation = '';
                if(!CommonUtility.isEmpty(camObj)){
                    Decimal amount1 = 0,amount2 = 0,amount3 = 0,diffamount12 = 0,diffAmount13 = 0,diffAmount23 = 0,averageSal = 0;
                    if(!CommonUtility.isEmpty(camObj.Average_incentive_for_Q1__c))
                        amount1 = camObj.Average_incentive_for_Q1__c;
                    if(!CommonUtility.isEmpty(camObj.Average_incentive_for_Q2__c))
                        amount2 = camObj.Average_incentive_for_Q2__c;
                    if(!CommonUtility.isEmpty(camObj.Average_incentive_for_Q3__c))
                        amount3 = camObj.Average_incentive_for_Q3__c;
                    
                    if(amount1 != 0){
                        diffamount12 = (amount1-amount2)/amount1;
                        diffAmount13 = (amount1-amount3)/amount1;
                    }
                    if(amount2 != 0){
                        diffAmount23 = (amount2-amount3)/amount2;
                    }
                    if((diffamount12 !=0 && diffamount12 > 0.15) || (!CommonUtility.isEmpty(diffAmount13) && diffAmount13 > 0.15) || (!CommonUtility.isEmpty(diffAmount23) && diffAmount23 > 0.15))
                    {
                        amountvariation = 'YES';
                    }
                    else
                    {
                        amountvariation = 'NO';
                    }
                }
                else
                    amountvariation = 'NO';
                mapOfInputVerifications.put('product', Loan.product__c);
                mapOfInputVerifications.put('no_of_home_loans', (hlCount != null) ? String.valueof(hlCount) : '0');
                mapOfInputVerifications.put('branch_name', Loan != null && Loan.Branch_Name__c != null ? Loan.Branch_Name__r.name : '');
                mapOfInputVerifications.put('residential_type', (PrimaryApp.Contact_Name__r.Residence_Type__c != null) ? String.valueof(PrimaryApp.Contact_Name__r.Residence_Type__c) : '');
                mapOfInputVerifications.put('application_source', Loan.Application_Source__c != null ? Loan.Application_Source__c : ''); //Added for Bug 23064
                mapOfInputVerifications.put('loan_id', (Loan.Loan_Application_Number__c != null) ? Loan.Loan_Application_Number__c : '');
                mapOfInputVerifications.put('date_of_birth', (acc.Date_of_Birth__c != null) ? String.valueof(acc.Date_of_Birth__c) : '');
                mapOfInputVerifications.put('net_salary', (camObj.Avg_qtrly_incentive__c != null) ? String.valueof(camObj.Avg_qtrly_incentive__c) : '0');
                mapOfInputVerifications.put('source_of_data', (bankObj != null && bankObj.Source_Of_Data__c != null) ? String.valueof(bankObj.Source_Of_Data__c) : '');
                mapOfInputVerifications.put('loanAmount', (camObj.Proposed_Loan_Amt__c != null) ? String.valueof(camObj.Proposed_Loan_Amt__c) : '0');
                mapOfInputVerifications.put('company_type',acc.Type_Of_Industry__c  != null ? String.valueof(acc.Type_Of_Industry__c) : '');
                mapOfInputVerifications.put('EPFO_api_response',acc.epfo_result__c != null ? 'YES' : 'NO');
                mapOfInputVerifications.put('EPFO_test_result',acc.epfo_result__c != null ? acc.epfo_result__c : '');
                mapOfInputVerifications.put('email_triggered',con.Office_Email_sent__c!= null && con.Office_Email_sent__c ? 'YES' : 'NO');
                mapOfInputVerifications.put('email_verified',PrimaryApp.Office_Email_Id_Verified__c  != null ? String.valueof(PrimaryApp.Office_Email_Id_Verified__c) : '');
                mapOfInputVerifications.put('domain_check',PrimaryApp.Domain_Check_Result__c  != null ? String.valueof(PrimaryApp.Domain_Check_Result__c ) : '');
                mapOfInputVerifications.put('perfios_trigger_flag',bankObj != null && bankObj.Send_Email_For_Perfios__c   != null ? String.valueof(bankObj.Send_Email_For_Perfios__c ) : '');
                mapOfInputVerifications.put('perfios_response_flag',bankObj != null && bankObj.Perfios_Flag__c  != null ? String.valueof(bankObj.Perfios_Flag__c) : '');
                mapOfInputVerifications.put('authenticity_score_flag',bankObj != null && bankObj.Authenticity__c != null ? 'true' : 'false');
                mapOfInputVerifications.put('address_matching_eKYC',con.Customer_address_matches_with_eKYC__c  != null ? String.valueof(con.Customer_address_matches_with_eKYC__c) : '');
                mapOfInputVerifications.put('address_matching_perfios',con.Customer_address_matches_with_perfios__c  != null ? String.valueof(con.Customer_address_matches_with_perfios__c) : '');
                //Rohit banking details start
                mapOfInputVerifications.put('salary_selected',acc.Type_of_Salary__c != null ? acc.Type_of_Salary__c : '');               
                mapOfInputVerifications.put('inward_cheque_bounce',bankObj != null && bankObj.Perfios_inwardChqBounces__c  != null ? String.valueof(bankObj.Perfios_inwardChqBounces__c) : '0');
                mapOfInputVerifications.put('inward_ecs_bounce',bankObj != null && bankObj.Perfios_inwardECSBounces__c  != null ? String.valueof(bankObj.Perfios_inwardECSBounces__c) : '0');
                mapOfInputVerifications.put('salary_credit_date_variation',datevariation);//mapping
                mapOfInputVerifications.put('salary_amount_difference',amountvariation);//mapping
                mapOfInputVerifications.put('salary1',camObj != null && camObj.Average_incentive_for_Q1__c != null ?String.valueof(camObj.Average_incentive_for_Q1__c) : '0');
                mapOfInputVerifications.put('salary2',camObj != null && camObj.Average_incentive_for_Q2__c != null ?String.valueof(camObj.Average_incentive_for_Q2__c) : '0');
                mapOfInputVerifications.put('salary3',camObj != null && camObj.Average_incentive_for_Q3__c != null ?String.valueof(camObj.Average_incentive_for_Q3__c) : '0');
                mapOfInputVerifications.put('salary_date1',bankObj != null && bankObj.Salary_Credit_Date1__c != null ?String.valueof(bankObj.Salary_Credit_Date1__c) : '');
                mapOfInputVerifications.put('salary_date2',bankObj != null && bankObj.Salary_Credit_Date2__c != null ?String.valueof(bankObj.Salary_Credit_Date2__c) : '');
                mapOfInputVerifications.put('salary_date3',bankObj != null && bankObj.Salary_Credit_Date3__c != null ?String.valueof(bankObj.Salary_Credit_Date3__c) : '');
                mapOfInputVerifications.put('bank_name',bankObj != null && bankObj.Perfios_Bank_Name__c!= null ?bankObj.Perfios_Bank_Name__c: '');
                mapOfInputVerifications.put('authenticity_score',bankObj != null && bankObj.Authenticity__c != null ? String.valueof(bankObj.Authenticity__c) : '0');
                /*CR 24122 s*/
                mapOfInputVerifications.put('perfios_Perfios_Statement_Status_1',bankObj != null && bankObj.Perfios_Statement_Status_1__c != null ? String.valueof(bankObj.Perfios_Statement_Status_1__c) : '');
                mapOfInputVerifications.put('perfios_Perfios_Statement_Status_2',bankObj != null && bankObj.Perfios_Statement_Status_2__c != null ? String.valueof(bankObj.Perfios_Statement_Status_2__c) : '');
                mapOfInputVerifications.put('perfios_Perfios_Statement_Status_3',bankObj != null && bankObj.Perfios_Statement_Status_3__c != null ? String.valueof(bankObj.Perfios_Statement_Status_3__c) : '');
                /*CR 24122 e*/
                if(loan.product__c=='RSL'){ //22018
                    mapOfInputVerifications.put('sourcing_channel_risk',dss.opp != null && dss.opp.Sourcing_Channel__r.Channel_Category__c  != null ? String.valueof(dss.opp.Sourcing_Channel__r.Channel_Category__c) : '');
                } 
                else
                    mapOfInputVerifications.put('sourcing_channel_risk',''); //22018
                //Rohit banking details stop
                mapOfInputVerifications.put('processType', Loan.Product_Offerings__r != null && Loan.Product_Offerings__r.size() > 0 ? 'Pre Approved' : '');
                //telepd parameters start
                mapOfInputVerifications.put('offer_type',acc != null && acc.Offer_Inhanced__c != null && acc.Offer_Inhanced__c == true ? 'enhanced':'');
                mapOfInputVerifications.put('riskSegmentClassification',PrimaryApp != null && PrimaryApp.Risk_Segmentation__c  != null ? String.valueof(PrimaryApp.Risk_Segmentation__c) : '');
                mapOfInputVerifications.put('approved_loan_amount',camObj.sal_max_loan__c != null ? String.valueof(camObj.sal_max_loan__c ) : '0');
                //telepd parameters end
                mapOfInputVerifications.put('residence_vintage',con != null && con.months_of_Residence__c != null ? con.months_of_Residence__c :'');
                System.debug('pk verification request'+mapOfInputVerifications);
                if (!Test.isRunningTest()) {
                    mapOfVerifications = breObj.callBREVerificationsv2(mapOfInputVerifications);
                }
                else{
                    mapOfVerifications.put('output_map','{"salary_credit_date_variation":"NO","salary_credit_amt_variation":"NO","tele_pd":"YES","geo_tagging_flag_residence_c":false,"geo_tagging_flag_residence_p":false,"geo_tagging_flag_office":false,"authenticity_score_result":"","residence_stability":"NA","banking_output":null,"employment_check":"Unsuccessful","domain_check":"NOT OK","office_mail_verification":"Confirmed","EPFO_check":"Not Done","loanId":"532052036789"}');
                    
                }
                String BREVerificationCodes = '';
                List < String > verificationCodes = new List < String > ();
                List<SOL_Policy__c> solPolicyList= new List<SOL_Policy__c>();       
                solPolicyList=[select id, Policy_Name__c,Checklist_Policy_Status__c from SOL_Policy__c where Loan_Application__c = : oppId AND Name LIKE 'Sales2.0%'    ];
                //List<SOL_Policy__c> listToDel = new List<SOL_Policy__c>(); //20939 commented
                Map<String,Sol_Policy__c> solPolMap = new Map<String,Sol_Policy__c>(); //20939
                SOL_Policy__c solBan = new SOL_Policy__c();
                for(SOL_Policy__c sol : solPolicyList){
                    /*20939 s*/
                    String name = sol.Policy_Name__c;
                    name = name.replace(' Pass','');
                    name = name.replace(' Fail','');
                    system.debug('name is'+name);
                    solPolMap.put(name,sol);
                    //if(sol.Policy_Name__c.contains('Banking Check') || sol.Policy_Name__c.contains('Veri- Permanent') || sol.Policy_Name__c.contains('Veri- Current') || sol.Policy_Name__c.contains('Veri- Banking') || sol.Policy_Name__c.contains('Veri- Office'))
                    //listToDel.add(sol);
                    /*20939 e*/
                }
                //delete listToDel; //20939 commented
                if(solPolMap.containskey('Banking Check'))
                    solBan = solPolMap.get('Banking Check');
                solBan.Loan_Application__c = Loan.Id;
                
                solBan.Applicant_Name__c = PrimaryApp.Id;
                solBan.Old_Address_Value__c = mapOfVerifications.get('output_map');
                system.debug('verification out'+mapOfVerifications.get('output_map'));
                Map<String,Object> mapOutput = (Map<String,Object>)JSON.deserializeUntyped(mapOfVerifications.get('output_map'));
                if(mapOutput != null && bankObj != null){
                    bankObj.Authenticity_Score_Flag__c = (String)mapOutput.get('authenticity_score_result');
                    if(!CommonUtility.isEmpty(mapOutput.get('salary_credit_amt_variation')))
                    {
                        if(mapOutput.get('salary_credit_amt_variation') == 'NO')
                            bankObj.Salary_Amount_Difference__c =false;
                        else 
                            bankObj.Salary_Amount_Difference__c =true;
                    }
                    if(!CommonUtility.isEmpty(mapOutput.get('salary_credit_date_variation')))
                    {
                        if(mapOutput.get('salary_credit_date_variation') == 'NO')
                            bankObj.Salary_Date_Inconsistency_Found__c =false;
                        else 
                            bankObj.Salary_Date_Inconsistency_Found__c =true;
                    }
                    upsert bankObj;
                }
                /* Bug : 17139 S */
                if(mapOutput != null && pdObj != null){
                    System.debug('inside telepd update');
                    pdObj.Tele_PD_Applicability__c= (String)mapOutput.get('tele_pd');
                    pdObj.Loan_Application__c = Loan.Id;
                    pdObj.Name_of_the_applicant__c = PrimaryApp.id;//prod issue @24728
                    upsert pdObj;
                    System.debug('inside pd'+pdObj.id + Loan.Id);
                }
                /* Bug : 17139 E */
                
                if(acc.Offer_Inhanced__c){
                    if(mapOfVerifications.get('banking_output') != null && mapOfVerifications.get('banking_output').toUpperCase() == 'SUCCESSFUL'){
                        solBan.Name = 'Sales2.0 Banking Check Pass';
                        solBan.Policy_Name__c = 'Banking Check Pass';
                        solBan.Policy_Status__c = 'OK';
                    }
                    /*CR 24666 s*/
                    else if(mapOfVerifications.get('banking_output') == null || mapOfVerifications.get('banking_output') == ''){
                        solBan.Name = 'Sales2.0 Banking Check Pass';
                        solBan.Policy_Name__c = 'Banking Check Pass';
                        solBan.Policy_Status__c = 'OK';
                    } 
                    /*CR 24666 e*/ 
                    else{
                        solBan.Name = 'Sales2.0 Banking Check Fail';
                        solBan.Policy_Name__c = 'Banking Check Fail';
                        solBan.Policy_Status__c = 'Rejected';
                    }
                }
                else{
                    solBan.Name = 'Sales2.0 Banking Check Pass';
                    solBan.Policy_Name__c = 'Banking Check Pass';
                    solBan.Policy_Status__c = 'OK';
                }
                List<SOL_Policy__c> listToUpdate = new List<SOL_Policy__c>();
                listToUpdate.add(solban);
                
                //insert listToUpdate; //20939 commented
                triggeredBRE.add('Banking Check'); /*Bug 20939*/
                System.debug('mapOfVerifications==' + mapOfVerifications);
                if (mapOfVerifications != null && mapOfVerifications.size() > 0) {
                    BREVerificationCodes = mapOfVerifications.get('BREVerificationCodes');
                    System.debug('BREVerificationCodes==' + BREVerificationCodes);
                    if (BREVerificationCodes != '' && BREVerificationCodes != null) {
                        for (String str1: BREVerificationCodes.split(',')) {
                            if (str1 != null && str1 != '') {
                                verificationCodes.add(str1.ToUpperCase());
                            }
                        }
                    }
                    System.debug('verificationCodes==' + verificationCodes);
                    
                    COVerificationController classObj = new COVerificationController('MobilityV2',oppId);
                    classObj.verificationCodes  = verificationCodes;
                    classObj.mapOutput = mapOutput;
                    classObj.processVerificationRecords(dss.opp,PrimaryApp);
                    
                    //Rohit solpolicy creation start
                    List<Verification__c> verificationList = [SELECT /*20939 s*/Geo_Tagging__c,/*20939 e*/Id,Verification_Type__c,Loan_Application__c FROM Verification__c WHERE Loan_Application__c =:oppId AND RSA_Reason__c != 'Initiated through RSA' AND Initiated_by_invisible_monitoring__c = false]; //20939 RCU added and conditions
                    Boolean veriPer = false,veriOfc = false,veriBan = false,veriCur = false;
                    List < SOL_Policy__c > verPolicyList = new List < SOL_Policy__c > ();
                    OpportunityMobilityUtility.policyList = verPolicyList;
                    if(verificationList != null && verificationList.size()>0){
                        System.debug('robin verification '+verificationList);
                        
                        OpportunityMobilityUtility.policyList = verPolicyList;
                        Boolean imAdded = false; //20939 RCU
                        for(Verification__c ver : verificationList){
                            /*20939 IM s*/
                            if(ver.Geo_Tagging__c == true){
                                if(solPolMap.containskey('Invisible Monitoring')){
                                    SOl_policy__c sp = solPolMap.get('Invisible Monitoring');
                                    sp.RetriggerBRE__c = true;
                                    if(!imAdded){
                                        listToUpdate.add(sp);
                                        imAdded = true;
                                    }
                                }
                            }
                            /*20939 IM e*/
                            if(ver.Verification_Type__c == 'PERMANENT ADDRESS VERIFICATION'){
                                veriPer = true;
                                /*20939 s*/
                                SOl_policy__c sp = new Sol_policy__c();
                                if(solPolMap.containskey('Veri- Permanent'))
                                    sp = solPolMap.get('Veri- Permanent');
                                sp.Policy_Name__c = 'Veri- Permanent Fail';
                                sp.Policy_Status__c = 'Rejected';
                                sp.Loan_Application__c = oppId;
                                sp.Applicant_Name__c = PrimaryApp.Id;
                                listToUpdate.add(sp);
                                //OpportunityMobilityUtility.createPolicyRecord('Veri- Permanent Fail', 'Rejected', oppId,PrimaryApp.Id );triggeredBRE.add('Veri- Permanent'); /*Bug 20939*/
                                /*20939 e*/
                            }
                            
                            if(ver.Verification_Type__c == 'Residence verification'){
                                veriCur = true;
                                /*20939 s*/
                                SOl_policy__c sp = new Sol_policy__c();
                                if(solPolMap.containskey('Veri- Current'))
                                    sp = solPolMap.get('Veri- Current');
                                sp.Policy_Name__c = 'Veri- Current Fail';
                                sp.Policy_Status__c = 'Rejected';
                                sp.Loan_Application__c = oppId;
                                sp.Applicant_Name__c = PrimaryApp.Id;
                                listToUpdate.add(sp);
                                //OpportunityMobilityUtility.createPolicyRecord('Veri- Current Fail', 'Rejected', oppId,PrimaryApp.Id ); 
                                /*20939 e*/
                                triggeredBRE.add('Veri- Current');/*Bug 20939*/
                            }
                            
                            if(ver.Verification_Type__c == 'Office verification'){
                                veriOfc = true;
                                /*20939 s*/
                                SOl_policy__c sp = new Sol_policy__c();
                                if(solPolMap.containskey('Veri- Office'))
                                    sp = solPolMap.get('Veri- Office');
                                sp.Policy_Name__c = 'Veri- Office Fail';
                                sp.Policy_Status__c = 'Rejected';
                                sp.Loan_Application__c = oppId;
                                sp.Applicant_Name__c = PrimaryApp.Id;
                                listToUpdate.add(sp);
                                //OpportunityMobilityUtility.createPolicyRecord('Veri- Office Fail', 'Rejected', oppId,PrimaryApp.Id );
                                /*20939 e*/
                                triggeredBRE.add('Veri- Office'); /*Bug 20939*/
                            }
                            
                            if(ver.Verification_Type__c == 'Bank Statements'){
                                veriBan = true;
                                /*20939 s*/
                                SOl_policy__c sp = new Sol_policy__c();
                                if(solPolMap.containskey('Veri- Banking'))
                                    sp = solPolMap.get('Veri- Banking');
                                sp.Policy_Name__c = 'Veri- Banking Fail';
                                sp.Policy_Status__c = 'Rejected';
                                sp.Loan_Application__c = oppId;
                                sp.Applicant_Name__c = PrimaryApp.Id;
                                listToUpdate.add(sp);
                                //OpportunityMobilityUtility.createPolicyRecord('Veri- Banking Fail', 'Rejected', oppId,PrimaryApp.Id );
                                /*20939 e*/
                                triggeredBRE.add('Veri- Banking'); /*Bug 20939*/
                            }
                            
                        }   
                        
                        
                    }
                    system.debug('after');
                    if(!veriPer){
                        /*20939 s*/
                        SOl_policy__c sp = new Sol_policy__c();
                        if(solPolMap.containskey('Veri- Permanent'))
                            sp = solPolMap.get('Veri- Permanent');
                        sp.Policy_Name__c = 'Veri- Permanent Pass';
                        sp.Policy_Status__c = 'OK';
                        sp.Loan_Application__c = oppId;
                        sp.Applicant_Name__c = PrimaryApp.Id;
                        listToUpdate.add(sp);
                        //OpportunityMobilityUtility.createPolicyRecord('Veri- Permanent Pass', 'OK', oppId,PrimaryApp.Id );
                        /*20939 e*/
                        triggeredBRE.add('Veri- Permanent'); /*Bug 20939*/
                    }
                    if(!veriBan){
                        /*20939 s*/
                        SOl_policy__c sp = new Sol_policy__c();
                        if(solPolMap.containskey('Veri- Banking'))
                            sp = solPolMap.get('Veri- Banking');
                        sp.Policy_Name__c = 'Veri- Banking Pass';
                        sp.Policy_Status__c = 'OK';
                        sp.Loan_Application__c = oppId;
                        sp.Applicant_Name__c = PrimaryApp.Id;
                        listToUpdate.add(sp);
                        //OpportunityMobilityUtility.createPolicyRecord('Veri- Banking Pass', 'OK', oppId,PrimaryApp.Id );
                        /*20939 e*/
                        triggeredBRE.add('Veri- Banking'); /*Bug 20939*/
                    }
                    if(!veriOfc){
                        /*20939 s*/
                        SOl_policy__c sp = new Sol_policy__c();
                        if(solPolMap.containskey('Veri- Office'))
                            sp = solPolMap.get('Veri- Office');
                        sp.Policy_Name__c = 'Veri- Office Pass';
                        sp.Policy_Status__c = 'OK';
                        sp.Loan_Application__c = oppId;
                        sp.Applicant_Name__c = PrimaryApp.Id;
                        listToUpdate.add(sp);
                        //OpportunityMobilityUtility.createPolicyRecord('Veri- Office Pass', 'OK', oppId,PrimaryApp.Id );
                        /*20939 e*/
                        triggeredBRE.add('Veri- Office'); /*Bug 20939*/
                    }
                    if(!veriCur){
                        /*20939 s*/
                        SOl_policy__c sp = new Sol_policy__c();
                        if(solPolMap.containskey('Veri- Current'))
                            sp = solPolMap.get('Veri- Current');
                        sp.Policy_Name__c = 'Veri- Current Pass';
                        sp.Policy_Status__c = 'OK';
                        sp.Loan_Application__c = oppId;
                        sp.Applicant_Name__c = PrimaryApp.Id;
                        listToUpdate.add(sp);
                        //OpportunityMobilityUtility.createPolicyRecord('Veri- Current Pass', 'OK', oppId,PrimaryApp.Id );
                        /*20939 e*/
                        triggeredBRE.add('Veri- Current'); /*Bug 20939*/
                    }
                    system.debug('veri policy list'+verPolicyList.size());
                    if(listToUpdate.size()>0){
                        for(SOL_Policy__c sol : listToUpdate){
                            System.debug('in sol '+sol.Policy_Name__c);
                            String name = 'Sales2.0';
                            if(sol.Policy_Name__c == 'Veri- Permanent Pass' || sol.Policy_Name__c == 'Veri- Permanent Fail')
                                sol.Name = name+' Veri- Permanent';
                            else if(sol.Policy_Name__c == 'Veri- Current Pass' || sol.Policy_Name__c == 'Veri- Current Fail')
                                sol.Name = name+' Veri- current';
                            else if(sol.Policy_Name__c == 'Veri- Office Pass' || sol.Policy_Name__c == 'Veri- Office Fail')
                                sol.Name = name+' Veri- Office';
                            else if(sol.Policy_Name__c == 'Veri- Banking Pass' || sol.Policy_Name__c == 'Veri- Banking Fail')
                                sol.Name = name+' Veri- Banking';
                            if(sol.Policy_Name__c != 'Invisible Monitoring') //20939
                                sol.RetriggerBRE__c = false; /* 20939 */
                        }      
                        System.debug('robin sol list '+verPolicyList);                     
                        //insert verPolicyList; //20939 commented
                        upsert listToUpdate; //20939
                    }
                    //Rohit solpolicy creation stop
                }
                
            }
            
        }
        catch(Exception e){
            
            system.debug('Exception>>>'+e.getMessage()+e.getCause()+e.getLineNumber());
        }
        return null;
        //      return callDocumentAPI(oppId);
    }
    public static String callDeviationAPI(string oppId,Boolean bothDeviDocFlag){
        map<string,List<LightningDocumentWrapper>> docMap = new map<string,List<LightningDocumentWrapper>>();
        BRECallout breObj = new BRECallout();
        List < String > DeviationBRECodesList = new List < String > ();
        List < String > standardBRECodesList = new List < String > ();
        MAP < String, String > mapOfPolicyParameters = new MAP < String, String > ();
        MAP < String, String > breDeviationRespose = new MAP < String, String > ();
        MAP < String, String > breStandardDocRespose = new MAP < String, String > ();
        Cibil_Temp__c cibTemp = new Cibil_Temp__c();//prod adhoc field binding change
        
        try{
            oppData data = new oppData();
            if(!commonutility.isEmpty(oppId)){
                
                oppData dss = new oppData();
                getAllData(oppId,dss);
                Applicant__c PrimaryApp = new Applicant__c();
                if(!commonutility.isEmpty(dss.applicantPrimary)){
                    PrimaryApp = dss.applicantPrimary;
                }
                
                //23578 start
                List<ContentVersion> PrimAttchmtsLst = LighteningUtilities.getAllContentDocs(PrimaryApp.Id);
                List<String> primAttchLst = new List<String>();
                for(ContentVersion obj : PrimAttchmtsLst){
                    if(obj.Title != null && obj.Title == 'CKYC Photo'){
                        primAttchLst.add('PHOTOGRAPH');     
                    }   
                }
                
                //23578 stop
                List < Verification__c > AllVerify = new List < Verification__c >();
                Opportunity Loan = dss.opp;
                Cibil_Extension1__c cibilExt1 = dss.cibilExt1;
                Account acc = dss.accObj;
                CAM__c camObj  = dss.camObj;
                Bank_Account__c bankObj = dss.bankObj;
                Contact con = dss.objCon;
                eKYC__c ekycObj  = dss.ekycobj;
                cibTemp = dss.cibilTempobj; //prod adhoc field binding change
                AllVerify = dss.veriList;
                Integer insuranceREc = 0;
                insuranceREc = [select count() from DPLinsurance__c where Opportunity__c =:oppId];
                String  OfficeVerification = '', ResidenceVerification = '';
                
                String credit_status = 'Complete',resi_geo = 'Negative',ofc_geo = 'Negative';
                system.debug('^^^^AllVerify^' + AllVerify);
                if (AllVerify != null && AllVerify.size() > 0) {
                    for (Verification__c ve: AllVerify) {
                        if(ve.Credit_Status__c == 'Insufficient'){
                            credit_status = 'Insufficient';
                        }
                        if (ve.Verification_Type__c == 'Residence verification' && ve.Geo_Tagging__c) {
                            resi_geo = 'Positive';
                        } else if (ve.Verification_Type__c == 'Office verification' && ve.Geo_Tagging__c) {
                            ofc_geo = 'Positive';
                        }
                        
                    }
                    
                }
                String fraudMatch = 'No', badMatch = 'No', ecsBounce = 'No',chqBounce = 'No';
                for(De_dupe__c ded : Loan.De_Dupes__r){
                    if(ded.Source_Or_Target__c == 'Target' && ded.Dedupe_Source__c == 'Fraud'){
                        fraudmatch = 'Yes';
                    }
                    if(ded.Source_Or_Target__c == 'Target' && ded.Customer_Status__c == 'Bad'){
                        badMatch = 'Yes';
                    }
                }
                Current_Disbursal_Details__c currDis = new Current_Disbursal_Details__c();
                if(Loan.Current_Disbursal_Details_s__r != null && Loan.Current_Disbursal_Details_s__r.size() > 0)
                    currDis = Loan.Current_Disbursal_Details_s__r[0];
                Decimal sumEcsBounce = 0.0;
                Decimal sumChqBounce = 0.0;
                for(Bank_Account__c bankAcc : Loan.Bank_Account__r){
                    if(bankAcc.Perfios_inwardECSBounces__c != null && bankAcc.Perfios_inwardECSBounces__c > 0){
                        sumEcsBounce = bankAcc.Perfios_inwardECSBounces__c + sumEcsBounce; 
                    }
                    if(bankAcc.Perfios_inwardChqBounces__c != null && bankAcc.Perfios_inwardChqBounces__c > 0){
                        sumChqBounce = bankAcc.Perfios_inwardChqBounces__c + sumChqBounce;
                    }
                }
                system.debug('PrimaryApp'+PrimaryApp);
                CIBIL__c cibObj = new CIBIL__c();
                if(PrimaryApp.CIBILs__r != null && PrimaryApp.CIBILs__r.size() > 0){
                    List<CIBIL__c> cibList =  PrimaryApp.CIBILs__r;
                    cibObj = cibList[0];
                }
                Cibil_Extension__c cibExtObj = new Cibil_Extension__c();
                if(PrimaryApp.Cibil_Extension__r != null && PrimaryApp.Cibil_Extension__r.size() > 0){
                    List<Cibil_Extension__c> cibExtList = PrimaryApp.Cibil_Extension__r;
                    cibExtObj = cibExtList[0];
                }
                String resStability = '';
                List<Sol_Policy__c> solPlcyList = [SELECT Name,Old_Address_Value__c from Sol_policy__c where Loan_Application__c =: Loan.Id AND Name LIKE 'Sales2.0 Banking Check%'];
                if(solPlcyList != null && solPlcyList.size() >0){
                    if(solPlcyList[0].Old_Address_Value__c != null && solPlcyList[0].Old_Address_Value__c != ''){
                        Map<String,Object> result = (Map<String,Object>)JSON.deserializeuntyped(solPlcyList[0].Old_Address_Value__c);
                        if(result != null && result.get('residence_stability') != null)
                            resStability = String.valueof(result.get('residence_stability'));
                    }
                }
                Decimal totalEmpVintage = 0;
                Decimal currentEmpVintage = 0;
                if(acc.Total_Work_Experience_Yrs__c != null)                
                    totalEmpVintage += Decimal.valueOf(acc.Total_Work_Experience_Yrs__c);   
                if(acc.Total_Work_Experience_Months__c != null)                                 
                    totalEmpVintage += (Decimal.valueof(acc.Total_Work_Experience_Months__c)/12.0).setScale(2); 
                if(acc.Current_experiance_in_Years__c != null)
                    currentEmpVintage+=Decimal.valueOf(acc.Current_experiance_in_Years__c);
                if(acc.Current_experiance_in_Month__c != null)                                 
                    currentEmpVintage+= (Decimal.valueof(acc.Current_experiance_in_Month__c)/12.0).setScale(2); 
                //REST Call for Deviation Documents to BRE
                mapOfPolicyParameters.put('loan_id', (Loan != null && Loan.Loan_Application_Number__c != null) ? Loan.Loan_Application_Number__c : '');
                mapOfPolicyParameters.put('product', (Loan != null && Loan.product__c != null)?Loan.product__c:'');
                if (Loan != null && loan.Branch_Name__c != null && loan.Branch_Name__r.name != null) {
                    mapOfPolicyParameters.put('branch_name', loan.Branch_Name__r.name);
                } else {
                    mapOfPolicyParameters.put('branch_name','');
                }
                mapOfPolicyParameters.put('date_of_birth',acc != null && acc.Date_of_Birth__c != null ? String.valueOf(acc.Date_of_Birth__c) : '');
                mapOfPolicyParameters.put('offer_type',acc != null && acc.Offer_Inhanced__c != null && acc.Offer_Inhanced__c == true ? 'true':'false');
                mapOfPolicyParameters.put('risk_segment',PrimaryApp != null && PrimaryApp.Risk_Segmentation__c  != null ? String.valueof(PrimaryApp.Risk_Segmentation__c) : '');
                mapOfPolicyParameters.put('overdue_amount',cibilExt1 != null && cibilExt1.Sum_of_Amount_Overdue__c != null ? String.valueof(cibilExt1.Sum_of_Amount_Overdue__c) :'0');
                mapOfPolicyParameters.put('dpd30_in_last_6months', (cibilExt1 != null && cibilExt1.X30_DPD_6_months__c != null) ? String.valueOf(cibilExt1.X30_DPD_6_months__c) : 'No');
                mapOfPolicyParameters.put('dpd90_in_last_6months',cibExtObj != null && cibExtObj.X90_DPD_6_months__c!= null ? cibExtObj.X90_DPD_6_months__c:'No');
                mapOfPolicyParameters.put('asset_classification_view',cibExtObj != null && cibExtObj.Asset_classification_view__c!= null ? cibExtObj.Asset_classification_view__c:'No');
                mapOfPolicyParameters.put('cc_dpd',cibExtObj != null && cibExtObj.DPD_CC__c!= null ? cibExtObj.DPD_CC__c:'No');
                mapOfPolicyParameters.put('cc_30dpd',cibExtObj != null && cibExtObj.X30_DPD_CC__c!= null ? cibExtObj.X30_DPD_CC__c:'No');//added for sal 2.0 CR 
                mapOfPolicyParameters.put('gold_loan_dpd',cibExtObj != null && cibExtObj.X30_DPD_Gold_Loan__c!= null ? cibExtObj.X30_DPD_Gold_Loan__c:'No'); 
                mapOfPolicyParameters.put('dpd_cluster_segment', cibTemp.DPD_cluster_Segment__c != null ? cibTemp.DPD_cluster_Segment__c : '');//prod adhoc field binding change
                if (PrimaryApp != null && PrimaryApp.CIBIL_Score__c != null && PrimaryApp.CIBIL_Score__c == '000-1') mapOfPolicyParameters.put('cibil_score', '0');
                else mapOfPolicyParameters.put('cibil_score', (PrimaryApp != null && PrimaryApp.CIBIL_Score__c != null) ? String.valueof(PrimaryApp.CIBIL_Score__c) : '0');
                
                //mapOfPolicyParameters.put('cibil_score',PrimaryApp.CIBIL_Score__c  != null ? PrimaryApp.CIBIL_Score__c  : '0');
                mapOfPolicyParameters.put('bad_match', badMatch);
                mapOfPolicyParameters.put('application_source',Loan.Application_Source__c != null  ? Loan.Application_Source__c : '');//need to know mapping
                mapOfPolicyParameters.put('specialProfile',con.Special_Profile_Employer__c != null ? String.valueOf(con.Special_Profile_Employer__c) : '');
                mapOfPolicyParameters.put('company_type',acc.Type_Of_Industry__c  != null ? acc.Type_Of_Industry__c  : '');
                mapOfPolicyParameters.put('total_employment_vintage',String.valueOf(totalEmpVintage));
                mapOfPolicyParameters.put('current_employment_vintage',String.valueOf(currentEmpVintage));
                mapOfPolicyParameters.put('net_salary',acc.Gross_Salary_Turn_Over__c != null ? String.valueOf(acc.Gross_Salary_Turn_Over__c) : '0');
                mapOfPolicyParameters.put('domain_check',PrimaryApp.Domain_Check_Result__c  != null ? String.valueof(PrimaryApp.Domain_Check_Result__c ) : '');
                mapOfPolicyParameters.put('approved_loan_amount',camObj.Eligible_Loan__c  != null ? String.valueof(camObj.Eligible_Loan__c ) : '0');//need to know mapping
                mapOfPolicyParameters.put('requested_loan_amount', (camObj.Proposed_Loan_Amt__c != null) ? String.valueof(camObj.Proposed_Loan_Amt__c) : '0.0');
                //mapOfPolicyParameters.put('max_loan_as_per_foir', camObj.LAP_EMI__c != null ? String.valueof(camObj.LAP_EMI__c) :'0');
                mapOfPolicyParameters.put('max_loan_as_per_multiplier', (camObj.Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c != null) ?  String.valueof(camObj.Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c) :'0');
                mapOfPolicyParameters.put('loan_type', (Loan.Type_Of_Loan__c != null) ? Loan.Type_Of_Loan__c : '');//need to know mapping
                mapOfPolicyParameters.put('inward_ecs', String.valueOf(sumEcsBounce));
                mapOfPolicyParameters.put('cheque_bounce', String.valueOf(sumChqBounce));
                mapOfPolicyParameters.put('residence_stability',resStability);
                mapOfPolicyParameters.put('salary_date1',bankObj != null && bankObj.Salary_Credit_Date1__c != null ?String.valueof(bankObj.Salary_Credit_Date1__c) : '');
                mapOfPolicyParameters.put('salary_date2',bankObj != null && bankObj.Salary_Credit_Date2__c != null ?String.valueof(bankObj.Salary_Credit_Date2__c) : '');
                mapOfPolicyParameters.put('salary_date3',bankObj != null && bankObj.Salary_Credit_Date3__c != null ?String.valueof(bankObj.Salary_Credit_Date3__c) : '');
                
                
                mapOfPolicyParameters.put('credit_status',credit_status);
                mapOfPolicyParameters.put('emi_bounce_last_3months', (con.EMI_Bounce_in_last_3_months__c != null) ? String.valueOf(con.EMI_Bounce_in_last_3_months__c) : '0');
                mapOfPolicyParameters.put('fraud_match',fraudMatch);
                mapOfPolicyParameters.put('industry', acc != null && acc.Employer__c != null && acc.Employer__r.Sub_Industry__c!= null  ? String.valueof(acc.Employer__r.Sub_Industry__c) : '');//need to know mapping
                
                mapOfPolicyParameters.put('email_confirmation',String.valueof(PrimaryApp.Office_Email_Id_Verified__c));
                mapOfPolicyParameters.put('processType', Loan.Product_Offerings__r != null && Loan.Product_Offerings__r.size() > 0 ? 'Pre Approved' : '');
                mapOfPolicyParameters.put('EPFO_check', acc.EPFO_Result__c != null ? acc.EPFO_Result__c : '');
                mapOfPolicyParameters.put('maxLoanAmountAsPerFoir', camObj.LAP_EMI__c != null ? String.valueof(camObj.LAP_EMI__c ) :'0');
                mapOfPolicyParameters.put('final_loan_amount', (camObj.Proposed_Loan_Amt__c != null) ? String.valueof(camObj.Proposed_Loan_Amt__c) : '0');
                mapOfPolicyParameters.put('enhanced_offer',acc != null ? String.valueof(acc.Offer_Inhanced__c) : 'false'); 
                mapOfPolicyParameters.put('ews_segment',PrimaryApp != null && PrimaryApp.RC_Deviation__c != null ? String.valueof(PrimaryApp.RC_Deviation__c) : ''); 
                Map < String, Object > result = new Map < String, Object >();
                if (!Test.isRunningTest()) 
                    result = breObj.callBREDeviationsv2(mapOfPolicyParameters);
                else{
                    String output = '{"Deviations":[{"approver":"ACM","description":"","loanId":"5123520382028","deviation":"CIBIL SCORE DEVIATION"},{"approver":"RCM","description":"","loanId":"5123520382028","deviation":"EXPERIENCE DEVIATION"}]}';
                    result = (Map < String, Object >)JSON.deserializeUntyped(output);
                }
                
                System.debug('deviation response'+result );
                List<Object> devResultList = new List<Object>();
                devResultList = (List<Object>)result.get('Deviations');
                Map<String, String> deviationApproverCodes = new Map<String, String>();
                if(!CommonUtility.isEmpty(devResultList))
                {
                    for(Object obj : devResultList){
                        Map<String, Object> deviationArray= (Map<String, Object>)obj;
                        deviationApproverCodes.put(String.valueof(deviationArray.get('deviation')),String.valueof(deviationArray.get('approver')));
                    }
                }
                system.debug('deviationApproverCodes'+deviationApproverCodes);
                //REST Call for Standard Documents to BRE
                mapOfPolicyParameters.put('product', (Loan != null && Loan.product__c != null)?Loan.product__c:'');
                mapOfPolicyParameters.put('loan_id', (Loan != null && Loan.Loan_Application_Number__c != null) ? Loan.Loan_Application_Number__c : '');
                mapOfPolicyParameters.put('date_of_birth',acc != null && acc.Date_of_Birth__c != null ? String.valueOf(acc.Date_of_Birth__c) : '');
                if (Loan != null && loan.Branch_Name__c != null && loan.Branch_Name__r.name != null) {
                    mapOfPolicyParameters.put('branch_Name', loan.Branch_Name__r.name);
                } else {
                    mapOfPolicyParameters.put('branch_Name','');
                }
                if(bankObj != null && bankObj.Perfios_Flag__c != null)
                {
                    if(bankObj.Perfios_Flag__c)
                        mapOfPolicyParameters.put('perfios_response_flag','YES');
                    else
                        mapOfPolicyParameters.put('perfios_response_flag','NO');
                }
                else{
                    mapOfPolicyParameters.put('perfios_response_flag','NO');
                }
                //  mapOfPolicyParameters.put('perfios_response_flag',bankObj != null && bankObj.Perfios_Flag__c  != null ? String.valueof(bankObj.Perfios_Flag__c) : '');
                mapOfPolicyParameters.put('office_verification', ofc_geo);
                mapOfPolicyParameters.put('residence_current_verification', resi_geo);
                
                mapOfPolicyParameters.put('address_match_with_ekyc_address',con != null && con.Customer_address_matches_with_eKYC__c  != null ? String.valueof(con.Customer_address_matches_with_eKYC__c) : '');
                mapOfPolicyParameters.put('risk_segment',PrimaryApp != null && PrimaryApp.Risk_Segmentation__c  != null ? String.valueof(PrimaryApp.Risk_Segmentation__c) : '');
                mapOfPolicyParameters.put('ekyc_response',ekycObj != null && ekycObj.eKYC_Response__c  != null ? 'YES' : 'NO'); 
                mapOfPolicyParameters.put('dpd30_in_last_6months', (cibilExt1 != null && cibilExt1.X30_DPD_6_months__c != null) ? String.valueOf(cibilExt1.X30_DPD_6_months__c) : '');
                mapOfPolicyParameters.put('residence_type', acc != null && acc.Residence_TypeAcc__c != null ? String.valueOf(acc.Residence_TypeAcc__c) : '');
                // mapOfPolicyParameters.put('email_verification',PrimaryApp != null && PrimaryApp.Office_Email_Id_Verified__c  != null ? String.valueof(PrimaryApp.Office_Email_Id_Verified__c) : '');
                if(PrimaryApp != null && PrimaryApp.Office_Email_Id_Verified__c != null)
                {
                    if(PrimaryApp.Office_Email_Id_Verified__c)
                        mapOfPolicyParameters.put('email_verification','YES');
                    else
                        mapOfPolicyParameters.put('email_verification','NO');
                }
                mapOfPolicyParameters.put('offer_type',acc != null && acc.Offer_Inhanced__c != null && acc.Offer_Inhanced__c == true ? 'enhanced':'');
                mapOfPolicyParameters.put('overdue_amount',cibilExt1 != null && cibilExt1.Sum_of_Amount_Overdue__c != null ? String.valueof(cibilExt1.Sum_of_Amount_Overdue__c) :'0');
                mapOfPolicyParameters.put('umrn',currDis != null && currDis.UMRN__c != null ? currDis.UMRN__c : '');
                mapOfPolicyParameters.put('asset_classification_view',cibExtObj != null && cibExtObj.Asset_classification_view__c!= null ? cibExtObj.Asset_classification_view__c:'No');
                mapOfPolicyParameters.put('total_current_outstanding',cibExtObj != null && cibExtObj.Total_current_outstanding__c!= null ? String.valueof(cibExtObj.Total_current_outstanding__c):'0');
                mapOfPolicyParameters.put('consent_on_app_form',PrimaryApp.Consent_on_app_form__c != null ? 'Yes' : 'No');
                mapOfPolicyParameters.put('dpd90_in_last_6months',cibExtObj != null && cibExtObj.X90_DPD_6_months__c!= null ? cibExtObj.X90_DPD_6_months__c:'No');
                mapOfPolicyParameters.put('cc_dpd',cibExtObj != null && cibExtObj.DPD_CC__c!= null ? cibExtObj.DPD_CC__c:'No');
                mapOfPolicyParameters.put('cc_30dpd',cibExtObj != null && cibExtObj.X30_DPD_CC__c!= null ? cibExtObj.X30_DPD_CC__c:'No');
                mapOfPolicyParameters.put('gold_loan_dpd',cibExtObj != null && cibExtObj.X30_DPD_Gold_Loan__c!= null ? cibExtObj.X30_DPD_Gold_Loan__c:'No'); 
                mapOfPolicyParameters.put('no_of_live_PL', (cibilExt1 != null && cibilExt1.No_of_Live_PL__c != null) ? String.valueOf(cibilExt1.No_of_Live_PL__c) :'0'); 
                mapOfPolicyParameters.put('no_of_insurances', insuranceREc != null ? String.valueOf(insuranceREc) : '0');
                mapOfPolicyParameters.put('consent_on_agreement_form',PrimaryApp != null && PrimaryApp.IP_Address_Timestamp__c  != null ? 'YES' : 'NO');
                mapOfPolicyParameters.put('suit_filed',cibExtObj != null && cibExtObj.Suit_Filed__c!= null ? cibExtObj.Suit_Filed__c:'No');
                mapOfPolicyParameters.put('address_match_with_aadhaar_address',String.valueof(con.Customer_address_matches_with_eKYC__c) == 'true' ? 'Yes' : 'No');
                mapOfPolicyParameters.put('application_source',Loan.Application_Source__c != null  ? Loan.Application_Source__c : '');//Bug 22624
                mapOfPolicyParameters.put('company_category', (con != null && con.Employer__r != null && con.Employer__r.Company_Category__c != null) ? con.Employer__r.Company_Category__c : ''); //24997
                Map<String, String> docMandate = new Map<String, String>();
                Map < String, Object> docResult = new Map < String, Object>();
                /*Bug 20939 s*/
                List < SOL_Policy__c > policyList = new List < SOL_Policy__c > ();
                List < SOL_Policy__c > policyInsertList = new List < SOL_Policy__c > ();
                Map<string,SOL_Policy__c> SOLPolicyMap = new Map<string,SOL_Policy__c>();
                policyList = [select id, Policy_Name__c,New_Address_Value__c ,Old_Address_Value__c,Policy_Status__c,Loan_Application__c,Checklist_Policy_Status__c, Applicant_Name__c from SOL_Policy__c where Loan_Application__c = : oppId AND (Name LIKE 'Sales2.0 Standard Document Details' OR Name LIKE 'Sales2.0 Deviation Details') limit 2];
                system.debug('policyList>>'+policyList);
                if(!commonutility.isEmpty(policyList)){
                    for(SOL_Policy__c solObj :policyList){
                        SOLPolicyMap.put(solObj.Policy_Name__c,solObj);
                    }
                }
                /*Bug 20939 e*/ 
                if(bothDeviDocFlag)
                {
                    
                    if (!Test.isRunningTest()) 
                        docResult = breObj.callBREDocumentsv2sal(mapOfPolicyParameters);
                    else{
                        String output = '{"Documents":[{"loanId":null,"document_code":"APPLICATION FORM","document_status":"MANDATORY"},{"loanId":null,"document_code":"AGREEMENT FORM","document_status":"MANDATORY"}]}';
                        docResult = (Map < String, Object>)JSON.deserializeUntyped(output);
                    }
                    System.debug('document response'+docResult );
                    List<Object> docResultList = (List<Object>)docResult.get('Documents');
                    
                    for(Object obj : docResultList){
                        Map<String, Object> docArray= (Map<String, Object>)obj;
                        docMandate.put(String.valueof(docArray.get('document_code')),String.valueof(docArray.get('document_status')));
                    }
                    system.debug('docMandate'+docMandate);
                    /*Bug 20939 s*/
                    SOL_Policy__c  SolObj = new  SOL_Policy__c ();
                    if(!CommonUtility.isEmpty(SOLPolicyMap) && SOLPolicyMap.containsKey('Standard Document Details')){
                        SolObj = SOLPolicyMap.get('Standard Document Details');
                    }
                    else{
                        SolObj = new SOL_Policy__c();
                        SolObj.Name = 'Sales2.0 Standard Document Details';
                        SolObj.Policy_Name__c = 'Standard Document Details';
                        SolObj.Loan_Application__c = oppId;
                        SolObj.Applicant_Name__c = dss.applicantPrimary.Id;
                        //SolObj.Old_Address_Value__c = dynOfferResult;
                        
                    }
                    SolObj.RetriggerBRE__c = false;
                    policyInsertList.add(SolObj);
                    triggeredBRE.add('Standard Document Details'); 
                    /*Bug 20939 e*/
                }
                system.debug('docMandate'+docMandate);
                /*Bug 20939 s*/
                SOL_Policy__c SolObj1 = new  SOL_Policy__c ();
                if(!CommonUtility.isEmpty(SOLPolicyMap) && SOLPolicyMap.containsKey('Deviation Details')){
                    SolObj1 = SOLPolicyMap.get('Deviation Details');
                }
                else{
                    SolObj1 = new SOL_Policy__c();
                    SolObj1.Name = 'Sales2.0 Deviation Details';
                    SolObj1.Policy_Name__c = 'Deviation Details';
                    SolObj1.Loan_Application__c = oppId;
                    SolObj1.Applicant_Name__c = dss.applicantPrimary.Id;
                    //SolObj.Old_Address_Value__c = dynOfferResult;
                    
                }
                SolObj1.RetriggerBRE__c = false;
                policyInsertList.add(SolObj1);
                system.debug('policyInsertList>>'+policyInsertList);
                upsert policyInsertList;
                triggeredBRE.add('Deviation Details'); 
                /*Bug 20939 e*/
                List<Document_Family__c> docFamilyMaster = [select id, name, Documents__c, Is_OTP_Standard_Document__c, Product__c, Document_Code__c, Deviation_Code__c, Customer_Segment__c from Document_Family__c where(Document_Code__c != null OR Deviation_Code__c != null) AND Product__c INCLUDES(: Loan.Product__c)];
                
                List<Deviation_Master__c> devMasterList = [select Deviation_Code__c, id, Name, Active_Flag__c, Product__c, Deviation_Type__c, Deviation_name__c, BRE_Deviation_Code__c
                                                           from Deviation_Master__c where Active_Flag__c = true and BRE_Deviation_Code__c != null AND Product__c = : Loan.Product__c
                                                          ];
                List < Deviation_Master__c > allDevMasterList = new List < Deviation_Master__c > ();
                List < Document_Family__c > AllDocList = new List < Document_Family__c > ();
                List < Document_Family__c > allstandardDocList = new List < Document_Family__c > ();
                if (devMasterList != null && devMasterList.size() > 0) {
                    for (Deviation_Master__c devObj: devMasterList) {
                        for (String str: deviationApproverCodes.keySet()) {
                            if (devObj.BRE_Deviation_Code__c != null) {
                                system.debug('dev code'+devObj.BRE_Deviation_Code__c+'---'+devObj.Id);
                                if (str.ToUpperCase() == devObj.BRE_Deviation_Code__c.ToUpperCase()) allDevMasterList.add(devObj);
                            }
                            
                        }
                        
                    }
                    
                }
                system.debug('Deviation master list' + allDevMasterList.size());
                if (docFamilyMaster != null && docFamilyMaster.size() > 0) {
                    for (Document_Family__c docObj: docFamilyMaster) {
                        if (deviationApproverCodes != null && deviationApproverCodes.size() > 0) { //For deviaitons BRE
                            for (String str: deviationApproverCodes.keySet()) {
                                
                                if ((docObj.Deviation_Code__c != null && (str.ToUpperCase() == docObj.Deviation_Code__c.ToUpperCase()))) AllDocList.add(docObj);
                            }
                        }
                        
                        //For standard doc list
                        system.debug('docMandate::' + docMandate);
                        if (docMandate != null && docMandate.size() > 0) {
                            for (String str1: docMandate.keySet()) {
                                system.debug('docObj.Deviation_Code__c::' + docObj.Deviation_Code__c);
                                
                                if ((docObj.Document_Code__c != null && (str1.ToUpperCase() == docObj.Document_Code__c.ToUpperCase()))) allstandardDocList.add(docObj);
                            }
                        }
                    }
                }
                List<Checklist__c> checklistTrnxList = new List<Checklist__c>();
                if(bothDeviDocFlag)
                    checklistTrnxList = [select id,Deviation_Master__c,Status__c,Deviation_Master__r.Deviation_Type__c,Deviation_Master__r.name, Sales_Status__c, CPA_Status__c, Loan_Application__c, Document__c, Checklist_Parameter__c, Checklist_Parameter__r.Document_Family__r.Documents__c, Checklist_Parameter__r.Document_Family__r.Name, Checklist_Parameter__r.Mandatory__c,
                                         Checklist_Parameter__r.Active__c, Checklist_Parameter__r.Type_of_Document__c, DocumentFmlyName__c, to_be_approved_by__c,
                                         Checklist_Parameter__r.Stages__c, Checklist_Parameter__r.Customer_Segmentation__c, DocumentFmlyName__r.Name, DocumentFmlyName__r.Documents__c,
                                         Checklist_Parameter__r.DeviationMaster__c, Checklist_Parameter__r.DeviationMaster__r.Deviation_name__c, Manual__c, Branch_Remark__c
                                         from Checklist__c where Loan_Application__c = : loan.Id];
                else
                    checklistTrnxList = [select id,Deviation_Master__c,Status__c,Deviation_Master__r.Deviation_Type__c,Deviation_Master__r.name, Sales_Status__c, CPA_Status__c, Loan_Application__c, Document__c, Checklist_Parameter__c, Checklist_Parameter__r.Document_Family__r.Documents__c, Checklist_Parameter__r.Document_Family__r.Name, Checklist_Parameter__r.Mandatory__c,
                                         Checklist_Parameter__r.Active__c, Checklist_Parameter__r.Type_of_Document__c, DocumentFmlyName__c, to_be_approved_by__c,
                                         Checklist_Parameter__r.Stages__c, Checklist_Parameter__r.Customer_Segmentation__c, DocumentFmlyName__r.Name, DocumentFmlyName__r.Documents__c,
                                         Checklist_Parameter__r.DeviationMaster__c, Checklist_Parameter__r.DeviationMaster__r.Deviation_name__c, Manual__c, Branch_Remark__c
                                         from Checklist__c where Loan_Application__c = : loan.Id AND Deviation_Master__c != null];
                /* purpose of the code :- We do not have to delete the deviation whcih are already 
raised and are already approved by respective higher authority
*/
                String deviationProducts = LaonApplicationCreation__c.getValues('RemoveDocumentChecklist').PDDDeviation__c;
                List< Checklist__c > checklistTrnxListNotDelete = new List< Checklist__c > ();
                List< Checklist__c > checklistTrnxListDelete = new List< Checklist__c > ();
                List<Attachment> attList = [SELECT ID,Name FROM Attachment WHERE parentId =: loan.Id]; 
                List<ContentDocumentLink> conDocList = [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, IsDeleted, ShareType,
                                                        ContentDocument.Title, ContentDocument.createdDate, ContentDocument.FileType
                                                        FROM ContentDocumentLink 
                                                        WHERE LinkedEntityId =: loan.Id];
                
                if (deviationProducts!=null && deviationProducts.contains(Loan.Product__c))
                { 
                    Map<String,Set<Checklist__c>> mapofChecklist=new  Map<String,Set<Checklist__c>>();
                    CommonUtility.salMobilityFlag = true; /*SAL 2.0 checklist CR s*/
                    mapofChecklist=CommonUtility.createdDelNotDelChklist(checklistTrnxList,AllDocList,allDevMasterList);
                    if(mapofChecklist!=null && mapofChecklist.size()>0)
                    {
                        if(mapofchecklist.get('NotDeletedChk')!=null && mapofchecklist.get('NotDeletedChk').size()>0)
                        {
                            checklistTrnxListNotDelete.addAll(mapofchecklist.get('NotDeletedChk'));
                            
                        }
                        if(mapofchecklist.get('DeletedChk')!=null && mapofchecklist.get('DeletedChk').size()>0)
                            checklistTrnxListDelete.addAll(mapofchecklist.get('DeletedChk'));
                    }
                    if (checklistTrnxListDelete!= null && checklistTrnxListDelete.size() > 0){
                        List<Attachment> attToDel = new List<Attachment>();
                        List<ContentDocumentLink> conDocListDel = new List<ContentDocumentLink>();
                        
                        for(Attachment att : attList){
                            for(Checklist__c chk : checklistTrnxListDelete){
                                if(chk.Deviation_Master__c != null && chk.Deviation_Master__r.Name != null && att.name != null && att.name.contains(chk.Deviation_Master__r.Name)){
                                    attToDel.add(att);
                                }
                                else if(bothDeviDocFlag && chk.DocumentFmlyName__c != null && chk.DocumentFmlyName__r.Name != null && att.name != null && att.name.contains(chk.DocumentFmlyName__r.Name)){
                                    attToDel.add(att);
                                }
                            }
                        }
                        for(ContentDocumentLink att : conDocList){
                            for(Checklist__c chk : checklistTrnxListDelete){
                                if(chk.Deviation_Master__c != null && chk.Deviation_Master__r.Name != null && att.ContentDocument.Title != null && att.ContentDocument.Title.contains(chk.Deviation_Master__r.Name)){
                                    if(!conDocListDel.contains(att))
                                        conDocListDel.add(att);
                                }
                                else if(bothDeviDocFlag && chk.DocumentFmlyName__c != null && chk.DocumentFmlyName__r.Name != null && att.ContentDocument.Title != null && att.ContentDocument.Title.contains(chk.DocumentFmlyName__r.Name)){
                                    if(!conDocListDel.contains(att))
                                        conDocListDel.add(att);
                                }
                            }
                        }
                        if(attToDel.size() > 0) delete attToDel;
                        if(conDocListDel.size() > 0) delete conDocListDel;
                        delete checklistTrnxListDelete;
                    }
                    
                } 
                else
                {
                    if(attList != null && attList.size() > 0) delete attList;
                    if(conDocList != null && conDocList.size() > 0) delete conDocList;
                    if (checklistTrnxList!= null && checklistTrnxList.size() > 0)
                        delete checklistTrnxList;
                }
                //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal end
                Boolean goInside = true;
                set<Id> alladdeddeviation_id = new set<Id>();
                checklistTrnxList.clear();
                system.debug('AllDocList==' + AllDocList);
                //Deviation Documents List
                Set<String> docNotDelList = new Set<String>();
                Set<String> devNotDelList = new Set<String>();
                if (checklistTrnxListNotDelete != null && checklistTrnxListNotDelete.size() > 0) {
                    for (Checklist__c chd: checklistTrnxListNotDelete) {
                        if(chd.DocumentFmlyName__c != null && chd.Deviation_Master__c == null)
                            docNotDelList.add(chd.DocumentFmlyName__c);
                        else if(chd.DocumentFmlyName__c != null && chd.Deviation_Master__c != null)
                            devNotDelList.add(chd.Deviation_Master__c);
                    }
                }
                if (AllDocList != null && AllDocList.size() > 0) {
                    for (Document_Family__c docObj: AllDocList) {
                        for (Deviation_Master__c dev: allDevMasterList) {
                            if ((docObj.Deviation_Code__c != null && dev.BRE_Deviation_Code__c != null) && (docObj.Deviation_Code__c == dev.BRE_Deviation_Code__c)) {
                                Checklist__c checkListTrans = new Checklist__c();
                                checkListTrans.Loan_Application__c = loan.id;
                                checkListTrans.DocumentFmlyName__c = docObj.id;
                                checkListTrans.Deviation_Master__c = dev.id;
                                checkListTrans.to_be_approved_by__c = deviationApproverCodes.get(dev.BRE_Deviation_Code__c);
                                checkListTrans.Mandatory__c = true;
                                //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal start
                                /* purpose of the code :- We do not have to delete the deviation whcih are already 
raised and are already approved by respective higher authority
*/
                                if (deviationProducts!=null && deviationProducts.contains(loan.Product__c))
                                {
                                    if (checklistTrnxListNotDelete != null && checklistTrnxListNotDelete.size() > 0) {
                                         if(!devNotDelList.contains(dev.id))
                                             checklistTrnxList.add(checkListTrans);
                                     }
                                     else {
                                      System.debug('pk else 2');
                                      checklistTrnxList.add(checkListTrans);
                                      alladdeddeviation_id.add(dev.id);
                                     }
                                }
                                else{
                                    System.debug('pk else 3');
                                    checklistTrnxList.add(checkListTrans);
                                    alladdeddeviation_id.add(dev.id);
                                }
                                //Code added by Leena Kharche Bug 13015 - Enhancement of Reappraisal end
                                
                            }
                        }
                    }
                }
                //Standard Document List
                system.debug('allstandardDocList>>'+allstandardDocList);
                
                if (allstandardDocList != null && allstandardDocList.size() > 0) {
                    for (Document_Family__c docObj: allstandardDocList) {
                        if (docObj.Document_Code__c != null) {
                            Checklist__c checkListTransaction = new Checklist__c();
                            checkListTransaction.Loan_Application__c = Loan.id;
                            checkListTransaction.DocumentFmlyName__c = docObj.id;
                            //23578 start
                            SYstem.debug('here ');
                            if(primAttchLst.contains(docObj.Document_Code__c)){
                                checkListTransaction.Sales_Status__c = 'Received';  
                            }
                            //23578 stop
                            system.debug('checklist man'+docObj.Document_Code__c+'--'+docMandate.get(docObj.Document_Code__c));
                            if (docMandate.get(docObj.Document_Code__c) == 'MANDATORY') {
                                checkListTransaction.Applicant__c = PrimaryApp.id;
                                checkListTransaction.Mandatory__c = true;
                            } else 
                                checkListTransaction.Applicant__c = PrimaryApp.id;
                            system.debug('checkListTransaction>>'+checkListTransaction);
                            /*SAL 2.0 checklist CR s*/
                            
                            if(!docNotDelList.contains(docObj.id))
                                checklistTrnxList.add(checkListTransaction);
                            /*SAL 2.0 checklist CR e*/
                        }
                    }
                }
                system.debug('checklistTrnxList==' + checklistTrnxList);
                system.debug('checklistTrnxList==' + checklistTrnxList.size());
                if (checklistTrnxList.size() > 0) insert checklistTrnxList;
                
                List < SalesEligibilityDetailsCtrl.DocumentWrapper > docWrapperList = new List < SalesEligibilityDetailsCtrl.DocumentWrapper > ();
                List < SalesEligibilityDetailsCtrl.DocumentWrapper > deviationDocWrapperList = new List < SalesEligibilityDetailsCtrl.DocumentWrapper > ();
                List < Document_Family__c > docFamilyMaster2 = new List < Document_Family__c > ();   // To avoid view state error BUG ID 15198
                docFamilyMaster2 = [select id, Name, Documents__c, Is_OTP_Standard_Document__c from Document_Family__c where(Document_Code__c != null OR Deviation_Code__c != null)];
                Map < id, Document_Family__c > docFamilyMap = new Map < id, Document_Family__c > ();
                for (Document_Family__c docFam: docFamilyMaster2 ) {
                    docFamilyMap.put(docFam.id, docFam);
                    //system.debug('docFam==' + docFam);
                }
                // system.debug('docFamilyMap==' + docFamilyMap);
                checklistTrnxList = [select id, Sales_Status__c, Status__c,Deviation_Master__r.Deviation_Type__c,Deviation_Master__r.Minimum_Approving_Authority__c,CPA_Status__c, Document__c, Checklist_Parameter__c, Checklist_Parameter__r.Document_Family__r.Documents__c,
                                     Checklist_Parameter__r.Document_Family__r.Name, Checklist_Parameter__r.Mandatory__c, Mandatory__c,
                                     Checklist_Parameter__r.Active__c, Checklist_Parameter__r.Type_of_Document__c, Checklist_Parameter__r.DeviationMaster__c,
                                     Checklist_Parameter__r.Stages__c, Checklist_Parameter__r.Customer_Segmentation__c, Deviation_Master__r.Deviation_name__c, DocumentFmlyName__r.Name,
                                     Checklist_Parameter__r.DeviationMaster__r.Deviation_name__c, DocumentFmlyName__r.Document_Code__c, DocumentFmlyName__r.Deviation_Code__c, DocumentFmlyName__c,
                                     Deviation_Master__c, Manual__c, to_be_approved_by__c, Branch_Remark__c from Checklist__c
                                     where Loan_Application__c = : Loan.Id and Manual__c = false
                                    ];
                system.debug('aftr checklistTrnxList==' + checklistTrnxList);
                if (checklistTrnxList != null && checklistTrnxList.size() > 0) {
                    deviationDocWrapperList.clear();
                    docWrapperList.clear();
                    Integer rowCount = 0;
                    Integer devRowCount = 0;
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
                                SalesEligibilityDetailsCtrl.DocumentWrapper wrapperObjForDev = new SalesEligibilityDetailsCtrl.DocumentWrapper(checkListTrnx, docFamObj.Documents__c, devRowCount);
                                deviationDocWrapperList.add(wrapperObjForDev);
                            } else {
                                rowCount += 1;
                                system.debug('*inside std doc list prepare' + checkListTrnx);
                                
                                SalesEligibilityDetailsCtrl.DocumentWrapper wrapperObj = new SalesEligibilityDetailsCtrl.DocumentWrapper(checkListTrnx, docFamObj.Documents__c, rowCount);
                                docWrapperList.add(wrapperObj);
                            }
                        }
                    }
                }
                Map<String,Object> checkMap =  (Map<String,Object>)dss.mobMap.get('CheckList');
                
                List<LightningDocumentWrapper> standardDocList  = new List<LightningDocumentWrapper>();
                List<LightningDocumentWrapper> deviationDocList  = new List<LightningDocumentWrapper>();
                List<LightningDocumentWrapper> picklistVal  = new List<LightningDocumentWrapper>();
                if(docWrapperList != null && docWrapperList.size() > 0){
                    
                    for(SalesEligibilityDetailsCtrl.DocumentWrapper documentObj : docWrapperList){
                        LightningDocumentWrapper  docObj = new LightningDocumentWrapper();
                        docObj.docName   = documentObj.docName; 
                        docObj.rowNum = documentObj.rowNum;
                        docObj.docFamObj = documentObj.docFamObj; 
                        docObj.showPicklist = documentObj.showPicklist; 
                        docObj.selectedDoc = documentObj.selectedDoc; 
                        system.debug('checkMap.get(documentObj.docName)'+checkMap.get(documentObj.docName));
                        if(checkMap.get(documentObj.docName) != null){
                            docObj.docCount = Integer.valueof(checkMap.get(documentObj.docName));
                        }
                        else{
                            docObj.docCount = 1;
                        }
                        List<string> docList = new List<string>();
                        if(documentObj.documentList != null && documentObj.documentList.size() > 0){
                            for(System.selectoption option :documentObj.documentList){
                                docList.add(option.getvalue());
                            }
                        }
                        docObj.documentList = docList; 
                        docObj.singleDoc = documentObj.singleDoc; 
                        standardDocList.add(docObj);
                    }
                }
                docMap.put('standardDoc',standardDocList);
                
                if(deviationDocWrapperList != null && deviationDocWrapperList.size() > 0){
                    
                    for(SalesEligibilityDetailsCtrl.DocumentWrapper documentObj : deviationDocWrapperList){
                        LightningDocumentWrapper  docObj = new LightningDocumentWrapper();
                        docObj.deviationName    = documentObj.deviationName ; 
                        docObj.rowNum = documentObj.rowNum;
                        docObj.docFamObj = documentObj.docFamObj; 
                        docObj.showPicklist = documentObj.showPicklist; 
                        docObj.selectedDoc = documentObj.selectedDoc; 
                        system.debug('checkMap.get(documentObj.docName)'+checkMap.get(documentObj.deviationName ));
                        if(checkMap.get(documentObj.deviationName ) != null){
                            docObj.docCount = Integer.valueof(checkMap.get(documentObj.deviationName));
                        }
                        else{
                            docObj.docCount = 1;
                        }
                        List<string> docList = new List<string>();
                        if(documentObj.documentList != null && documentObj.documentList.size() > 0){
                            for(System.selectoption option :documentObj.documentList){
                                docList.add(option.getvalue());
                            }
                        }
                        docObj.documentList = docList;  
                        docObj.singleDoc = documentObj.singleDoc;
                        deviationDocList.add(docObj);
                    }
                }
                docMap.put('deviationDoc',deviationDocList);
                system.debug('docMap'+docMap);
                if(docMap.size() > 0){
                    List<SObject> attchementsList = LighteningUtilities.getAllDocuments(oppId);
                    system.debug('atttachment list'+attchementsList.size());
                    if(attchementsList.size() > 0)
                        data.attchements = attchementsList;
                }
                
                LightningDocumentWrapper  pickData = new LightningDocumentWrapper();
                List<string> checkSelectList = new List<string>{'Sales_Status__c'};
                    Map<String, Object> selectListNameMap  = new  Map<String, Object>();
                selectListNameMap.put('Checklist__c',checkSelectList);
                
                pickData.picklistData = LighteningUtilities.getPicklistValues(JSON.serialize(selectListNameMap)); 
                picklistVal.add(pickData);
                if(picklistVal != null && picklistVal.size() > 0){
                    docMap.put('picklistDataList',picklistVal);
                }
                system.debug('docMap'+docMap);
                if(docMap.size() > 0){
                    data.checklistdocument = docMap;
                }
            }
            return JSON.serialize(data);
        }
        catch(Exception e){
            system.debug('Exception>>>'+e.getLineNumber()+e.getMessage());
            return null;
            
            
        }
        
    }
    
    public static String upsertPerfiosBankAccount(String loanId,String JSONBankAccountLst)
    {
        System.debug('jsonBankAccountRecord++'+JSONBankAccountLst);
        oppData oppCard = new oppData();
        List <Bank_Account__c> genericDataBank = new List <Bank_Account__c>();
        List <Bank_Account__c> Listtobesent = new List <Bank_Account__c>();
        SET <Bank_Account__c> InitiatePerfios = new SET<Bank_Account__c>();
        List<Bank_Account__c> FinalLst = new List<Bank_Account__c>();
        //SET<ID> setID = new SET<ID>();
        boolean emailsend = false;
        //String loanId =params.get('LoanId');
        //List < sObject > genericData = new List < sObject > ();
        List<Bank_Account__c> listBankAccount = new List<Bank_Account__c>();
        listBankAccount = [SELECT Salary_Credit_Date1__c,Salary_Credit_Date2__c,Salary_Credit_Date3__c,Id,Perfios_Bank_Name__c,Bank_Account_Number__c,Perfios_Start_Date__c,Perfios_End_Date__c,Perfios_Flag__c,Applicant__r.ContactName__c,Bank_Acct_Number__c,Bank_Name__c,Applicant__c,Loan_Application__c,Applicant__r.Applicant_Type__c,Bank_Name_List__c, Send_Email_For_Perfios__c 
                           FROM Bank_Account__c 
                           WHERE Loan_Application__c =:loanId AND Send_Email_For_Perfios__c = true];
        if(JSONBankAccountLst != null)
        {
            
            genericDataBank = (List<Bank_Account__c>)JSON.deserialize(JSONBankAccountLst, List<Bank_Account__c>.class);
            for(integer i=0;i<genericDataBank.size();i++)
            {
                genericDataBank[i].Loan_Application__c = loanId;
                genericDataBank[i].Bank_Name__c = genericDataBank[i].Bank_Name_List__c;
                genericDataBank[i].Salaried_CAM__c = true;
                if(genericDataBank[i].Send_Email_For_Perfios__c == true)
                {
                    InitiatePerfios.add(genericDataBank[i]);
                    emailsend = true;
                }
                
                
            }
        }
        try
        {
            if(listBankAccount == null || listBankAccount.size() ==0){
                
                System.debug('genericDataBank++'+genericDataBank);
                
                if(emailsend)
                {
                    for(Bank_Account__c ban : genericDataBank) 
                    {
                        if(InitiatePerfios.contains(ban))
                            ban.Send_Email_For_Perfios__c = false;
                        
                        Listtobesent.add(ban);
                        
                    }
                    upsert Listtobesent;
                    for(Bank_Account__c ban : InitiatePerfios) 
                    {
                        ban.Send_Email_For_Perfios__c = true;
                        FinalLst.add(ban);
                    }
                    SendEmailForPerfios initiate = new SendEmailForPerfios();
                    initiate.sendEmailToCustomer(FinalLst, LoanId);
                    oppCard.Perfiosstatus='Perfios Initiated Successfully.';
                }
                else{
                    if(genericDataBank != null)
                    {
                        upsert genericDataBank;
                    }
                    oppCard.Perfiosstatus='Record Saved Successfully.';
                }
                
            }
            else{
                if(genericDataBank != null)
                {
                    System.debug('rohit gendata'+listBankAccount.size()+'--- '+InitiatePerfios.size());
                    //Rohit added for Bug 22077 start - 21869
                    Listtobesent = new List<Bank_Account__c>();
                    Set<String> bankNos = new Set<String>();
                    for(Bank_Account__c upban : listBankAccount){
                        bankNos.add(upban.Bank_Acct_Number__c);
                    }
                    
                    for(Bank_Account__c ban : InitiatePerfios) 
                    {
                        
                        if(!bankNos.contains(ban.Bank_Acct_Number__c)){
                            System.debug('inside...');
                            ban.Send_Email_For_Perfios__c = false;                       
                            Listtobesent.add(ban);                                                          
                        }
                        
                    }
                    upsert Listtobesent;
                    System.debug('sent list '+Listtobesent.size());
                    for(Bank_Account__c ban : Listtobesent){
                        ban.Send_Email_For_Perfios__c = true;
                    }
                    SendEmailForPerfios initiate = new SendEmailForPerfios();
                    initiate.sendEmailToCustomer(Listtobesent, LoanId);
                    
                    //Rohit added for Bug 22077 stop - 21869
                    upsert genericDataBank;
                }
                oppCard.Perfiosstatus='Perfios Alredy Initiated for this loan application.';
                
            }
            List<Bank_Account__c> updatedBankAccount = new List<Bank_Account__c>();
            updatedBankAccount = [SELECT Salary_Credit_Date1__c,Salary_Credit_Date2__c,Salary_Credit_Date3__c,Id,Perfios_Bank_Name__c,Bank_Account_Number__c,Perfios_Start_Date__c,Perfios_End_Date__c,Perfios_Flag__c,Applicant__r.ContactName__c,Bank_Acct_Number__c,Bank_Name__c,Applicant__c,Loan_Application__c,Applicant__r.Applicant_Type__c,Bank_Name_List__c, Send_Email_For_Perfios__c 
                                  FROM Bank_Account__c 
                                  WHERE Loan_Application__c =:loanId];
            oppCard.bankList=updatedBankAccount;
        }
        catch(Exception e)
        {
            System.debug('Exception'+e.getMessage()+' at Line Number: ' + e.getLineNumber());
            return null;
        }
        /*Added by swapnil Bug 20939 start*/
        Opportunity oppObj=[select id,Account.flow__c,Loan_Application_Number__c from Opportunity where id= :loanId limit 1];
        if(oppObj!=null && oppObj.Account.flow__c.equalsIgnoreCase('Mobility V2')){ 
            System.Debug('IsMobiltiyV2');
            try{
                // System.debug();
                
                gensendSMS([select id from Opportunity where id =:loanId limit 1],null,'On LA Perfios');
                // sendSMSonLACreation(loanObj.Id,appObj1.Id); 
            }catch(EXception e){
                System.debug('Error occrred during sms or email sendging '+e.getMessage()+' on line '+e.getLineNumber());
            }  
        }
        /*Added by swapnil Bug 20939 end*/
        return JSON.serialize(oppCard);
    }
    public static Opportunity salesReject(Opportunity oppObj){
        oppObj.StageName = 'Sales Reject';
        try{
            update oppObj;
        } catch(Exception e)
        {
            System.debug('Exception'+e.getMessage()+' at Line Number: ' + e.getLineNumber());
            return null;
        }
        return oppObj;
    }
    /*Sales 2.0 added by Krish s*/
    public static String getPOSData(String oppId,String objectFieldJSON){
        StaticResource staticresc;
        Map<String,Object> ALLMap = new Map<String,Object>();
        String jsnBody;
        staticresc = [SELECT Body,Id,Name FROM StaticResource WHERE Name = 'SalariedCustomSettings' limit 1]; 
        if(staticresc != null)
            jsnBody = staticresc.Body.toString();
        ALLMap = (Map<String,Object>)JSON.deserializeUnTyped(jsnBody);
        Map<String,Object> breMap =(Map<String,Object>)ALLMap.get('Mobility 2');
        String topUp = (String)breMap.get('topupvalues');
        String btval = (String)breMap.get('btvalues');
        Set<String> topUpSet = new Set<String>();
        Set<String> btSet = new Set<String>();
        topUpSet.addAll(topUp.split(';'));
        btSet.addAll(btval.split(';'));
        
        oppData data = new oppData();
        data.topUpList = topUpSet;
        data.BTList = btSet;
        List<TelePDQuestionMaster__c> posList = new List<TelePDQuestionMaster__c>();
        posList = [SELECT POS_Type__c,ExistingLAN__c,BalanceAmount__c,CustomerName__c,DisbursementType__c,ApiResponse__c from TelePDQuestionMaster__c where LoanApplication__c =: oppId];
        Opportunity opp = new Opportunity(); 
        opp = [SELECT /*22182 s*/Loan_Amount_with_Premium__c,/*22182 e*/CUSTOMER__r.Name,POS__c,Scheme_Master__c,Loan_Variant__c,IFSC_Code__c ,A_C_No__c, Mode_of_Disbursal__c, Bank_Name__c, Account_Holder_Name__c, Favouring__c,MICR_Number__c ,Repayment_Account_Holder_Name__c, Bank_A_c_No_of_Customer__c, Repayment_Bank_Name__c, Repayment_Mode__c, First_Due_Date__c,  A_C_Type__c, Account.Flow__c,Relationship_Manager__c,Tenor__c,Approved_Rate__c,EMI_CAM__c,Requested_ROI__c,Sourcing_Channel__r.Id,Sourcing_Channel__r.Reporting_Manager__c,id,Industry__r.Industry__c,Offer_Amount__c,Reject_Reason__c,Name,StageName,Telecaller_Name__c,Customer_Type__c, Product__c,Main_Sub_Industry__c,Branch_Name__c,Branch_Name__r.SAL_Branch_Type__c, LAN__c, AccountId, Quality_Check_Status__c, Sourcing_Channel__c, Sourcing_Channel__r.Name, Referral__c, Referral__r.Name, Application_Source__c, Loan_Application_Number__c,Type_Of_Loan__c,COO_Comments__c,Approved_Loan_Amount__c,Scheme_Master__r.Name,Scheme_Master__r.IsHybridFlexi__c,Approved_Tenor__c,Processing_Fees__c,Branch_Name__r.name,/*US_982*/If_Yes__c,End_Use__c,/*US_982*/
               (select id from Product_Offerings__r),
               (select id,LAP_EMI__c,EMI_on_Proposed_Loan_TO__c,Average_incentive_for_Q1__c,Average_incentive_for_Q3__c,Average_incentive_for_Q2__c,Maxi_EMI_Cust__c,Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c,Average_Monthly_Net_Income1__c,Applicable_FOIR1__c,Loan_Application__c,EMI_of_The_Loan__c,Receips5_Doc__c,Receips6_Doc__c,Unsecured_FOIR__c,Eligible_FOIR__c,Total_Mthly_Oblig__c,EMI__c,ROI__c,sal_max_loan__c,Net_Salary_for_Month1__c,Net_Salary_for_Month2__c,Net_Salary_for_Month3__c,Proposed_Loan_Amt__c,Tenor__c,Eligible_Loan__c,Monthly_Reimbursement__c,Avg_mthly_incntve_3mts__c,Rental_Income__c,Receips4_Doc__c,Existing_HL_EMI__c,Month1_Doc__c,Month2_Doc__c,Month3_Doc__c,LAP_pmt__c,Avg_monthly_incentive1__c,Avg_monthly_incentive2__c,Avg_monthly_incentive3__c,Incentive_Monthly_or_Quarterly__c 
                ,/*24997 s*/Gross_Salary_Month1__c,Gross_Salary_Month2__c,Gross_Salary_Month3__c/*24997 e*/ from CAMs__r),
               (select Final_EMI__c,Status__c,Obligation__c,Financers__c,Loan_Type__c,POS__c from Existing_Loan_Details__r),
               (select Customer_Status__c,Dedupe_Source__c,Source_Or_Target__c from De_Dupes__r),
               (select Perfios_inwardChqBounces__c,Perfios_inwardECSBounces__c,Perfios_Bank_Name__c from Bank_Account__r),
               (select id,IMPS_Count__c, UMRN__c,Disbursement_To__c, IMPS_Flag__c, Bank_Branch__c, name, Tranche_Detail__c, Loan_Application__c, Internal_Closure__c, Disbursement_Amount__c, Disbursal_Mode__c, Disbursement_Date__c,
                FinnOne_Disbursement_Date__c,Successful_IMPS_Count__c,Failure_IMPS_Count__c ,IFSC_Code__c, Favouring__c,isTopUp__c,Tranche_Detail__r.Tranche_Number__c, Bank_Name__c, Bank_Account__c, Payable_at__c, Credit_Days__c, IMPS_Result__c
                from Current_Disbursal_Details_s__r),
               
               (select id,Question1__c,Question2__c,Question3__c,Question4__c,Question5__c,Question6__c,Question7__c,Question8__c,Question9__c,Question10__c,Question11__c,Question12__c,Question13__c,Question14__c,Question15__c,Question16__c,Question17__c,Question18__c,Question19__c,Question20__c,Question21__c,Question22__c,Question23__c,Question24__c,Question25__c,Question26__c,Question27__c,Question28__c,Question29__c,Question30__c,
                Type_of_PD__c,Tele_PD_Applicability__c,Name_of_the_applicant__c,PD_Conducted__c, PD_Ok__c,CO_comment__c from Personal_Discussion_s__r),
               (SELECT Id, A_C_type__c,ECS_Barcode_No__c,Open_ECS_Facility__c, Open_ECS_Ex_Customer_Id__c, Open_Valid_till__c, Open_ECS_Max_Limit__c, ECS_Start_Date__c, ECS_End_Date__c, ECS_Amount__c, name, Loan_Application__c, A_C_NO__c, MICR_Code__c, PDC_START_DATE__c, IFSC_Code__c, Account_Holder_Name__c,Bank_Name__c, No_of_Cheques__c, Cheque_Serial_Number__c, Repayment_Mode__c, To_Cheque_Serial_Number__c, Cheque_Amount__c, Tranche_Detail__c, Bank_Branch__c, PDC_By_Name__c ,Loan_Application__r.CUSTOMER__c,UMRN__c FROM RePayment_mode_details__r)
               
               from Opportunity where id = : oppId];
        data.opp = opp;
        data.posList = posList;
        data.picklistData = LighteningUtilities.getPicklistValues(objectFieldJSON);
        data.theme = UserInfo.getUiThemeDisplayed();
         List < SOL_Policy__c > SOLList = new List < SOL_Policy__c > ();
          Integer count = 0;
          /*20939 s*/
          SOLList = [select id, name, Policy_Name__c, Remarks__c, Disposition_Status__c, Checklist_Policy_Status__c from SOL_Policy__c where Loan_Application__c =: oppId AND Name LIKE 'Sales2.0%'
           and RetriggerBRE__c = true
          ];
          for (SOL_Policy__c sol: SOLList) {
           if (sol.Policy_Name__c != null && sol.Policy_Name__c.contains('Invisible Monitoring'))
            data.reTriggerIM = true;
           else
            count++;
          }
          data.NoOfSolPolicyWithBreFlagTrue = String.valueOf(count);
          /*20939 IM e*/
        return JSON.serialize(data);
    }
    public static String saveDataTU(Opportunity oppObj,TelePDQuestionMaster__c posOb,List<TelePDQuestionMaster__c> posList,String accJSON){
        oppData data = new oppData();
        upsert posList;
        if(!CommonUtility.isEmpty(posOb) && posOb.Id != null){
            delete posOb;
        }
        update oppObj;
        GeneralUtilities.splitTopUp(oppObj);
        data.posList = posList;
        data.opp = oppObj;
        createSalMcpSOL(oppObj.Id, accJSON);
        /*22182 s*/
        //List<Opportunity> oppList=[select id,EMI_CAM__c,Scheme_Master__c,Approved_Tenor__c,Approved_Rate__c,Loan_Amount_with_Premium__c,Scheme_Master__r.IsHybridFlexi__c from Opportunity where id =: oppObj.Id];
        //Opportunity loan=oppList[0];
        Applicant__c applicantprimary=[select id,Pure_Flexi_Period__c,Drop_Line_Flexi_Period__c,Pure_Flexi_EMI__c from Applicant__c where Loan_Application__c =: oppObj.Id AND Applicant_Type__c ='Primary' ];
        
        String emiVal = SAL_PricingCtrlV2.calculateEMIValue(oppObj,applicantPrimary); //22182
        if(emiVal != null){
            oppObj.EMI_CAM__c = Decimal.valueof(emiVal); //22182
            if(!CommonUtility.isEmpty(oppObj.Scheme_Master__c) && !CommonUtility.isEmpty(oppObj.Scheme_Master__r.IsHybridFlexi__c) && oppObj.Scheme_Master__r.IsHybridFlexi__c == true)
                applicantPrimary.Pure_Flexi_EMI__c =  ((oppObj.Loan_Amount_with_Premium__c *oppObj.Approved_Rate__c) / 1200);
        }
        update applicantPrimary;
        update oppObj;
        data.opp = oppObj;
        /*22182 e*/
        return JSON.serialize(data);
    }
    public static String saveDataBT(Opportunity oppObj,TelePDQuestionMaster__c posOb,List<TelePDQuestionMaster__c> posList,String accJSON){
        oppData data = new oppData();
        List<TelePDQuestionMaster__c> posListNew = new List<TelePDQuestionMaster__c>();
        
        system.debug('Existing LAN'+posOb.ExistingLAN__c+posOb.Id);
        if(!CommonUtility.isEmpty(posOb.ExistingLAN__c)){
            posListNew.add(posOb);
            upsert posOb;
        }
        else{
            if(!CommonUtility.isEmpty(posOb.Id)){
                posList.add(posOb);
            }
        }
        List<TelePDQuestionMaster__c> posToDel = new List<TelePDQuestionMaster__c>();    
        if(!CommonUtility.isEmpty(posList)){
            for(TelePDQuestionMaster__c pos : posList){
                if(pos.Id != null)
                    posToDel.add(pos);
            }
            if(posToDel.size() > 0)
                delete posToDel;
        }
        List<Current_Disbursal_Details__c> delTPDQ= [select id, Disbursement_To__c, IMPS_Flag__c, Bank_Branch__c, name, Tranche_Detail__c, Loan_Application__c, Internal_Closure__c, Disbursement_Amount__c, Disbursal_Mode__c, Disbursement_Date__c,
                                                     IFSC_Code__c, Favouring__c,isTopUp__c,Tranche_Detail__r.Tranche_Number__c, Bank_Name__c, Bank_Account__c, Payable_at__c, Credit_Days__c
                                                     from Current_Disbursal_Details__c where Loan_Application__c = : oppObj.id AND isTopUp__c =true
                                                    ];
        if(delTPDQ.size() > 0){
            delete delTPDQ;
        }
        update oppObj;
        data.opp = oppObj;
        data.posList = posListNew;
        createSalMcpSOL(oppObj.Id, accJSON);
        /*22182 s*/
        //List<Opportunity> oppList=[select id,EMI_CAM__c,Scheme_Master__c,Approved_Tenor__c,Approved_Rate__c,Loan_Amount_with_Premium__c,Scheme_Master__r.IsHybridFlexi__c from Opportunity where id =: oppObj.Id];
        //Opportunity loan=oppList[0];
        Applicant__c applicantprimary=[select id,Pure_Flexi_Period__c,Drop_Line_Flexi_Period__c,Pure_Flexi_EMI__c from Applicant__c where Loan_Application__c =: oppObj.Id AND Applicant_Type__c ='Primary' ];
        
        String emiVal = SAL_PricingCtrlV2.calculateEMIValue(oppObj,applicantPrimary); //22182
        if(emiVal != null){
            oppObj.EMI_CAM__c = Decimal.valueof(emiVal); //22182
            if(!CommonUtility.isEmpty(oppObj.Scheme_Master__c) && !CommonUtility.isEmpty(oppObj.Scheme_Master__r.IsHybridFlexi__c) && oppObj.Scheme_Master__r.IsHybridFlexi__c == true)
                applicantPrimary.Pure_Flexi_EMI__c =  ((oppObj.Loan_Amount_with_Premium__c *oppObj.Approved_Rate__c) / 1200);
        }
        update applicantPrimary;
        update oppObj;
        data.opp = oppObj;
        /*22182 e*/
        return JSON.serialize(data);
    }
    public static String fetchPOS(Opportunity oppObj,TelePDQuestionMaster__c posOb,List<TelePDQuestionMaster__c> posList){
        oppData data = new oppData();
        
        TopUpController.fetch(posList);
        system.debug('posOb'+posOb);
        if(!CommonUtility.isEmpty(posOb) && posOb.Id != null){
            delete posOb;
        }
        update oppObj;
        List<TelePDQuestionMaster__c> posNewList = new List<TelePDQuestionMaster__c>();
        posNewList = [SELECT POS_Type__c,ExistingLAN__c,BalanceAmount__c,CustomerName__c,DisbursementType__c,ApiResponse__c from TelePDQuestionMaster__c where LoanApplication__c =: oppObj.Id];
        data.posList = posNewList;
        data.opp = oppObj;
        return JSON.serialize(data);
    }
    public static String delposListTU(Opportunity oppObj,String recordId,List<TelePDQuestionMaster__c> posList){
        oppData data = new oppData();
        List<TelePDQuestionMaster__c> posToDel = new List<TelePDQuestionMaster__c>();
        for(Integer i=0;i<posList.size();i++){
            if(posList[i].Id == recordId){
                posToDel.add(posList[i]);
                posList.remove(i);
            }
        }
        List<Current_Disbursal_Details__c> delTPDQ= [select id, Disbursement_To__c, IMPS_Flag__c, Bank_Branch__c, name, Tranche_Detail__c, Loan_Application__c, Internal_Closure__c, Disbursement_Amount__c, Disbursal_Mode__c, Disbursement_Date__c,
                                                     IFSC_Code__c, Favouring__c,isTopUp__c,Tranche_Detail__r.Tranche_Number__c, Bank_Name__c, Bank_Account__c, Payable_at__c, Credit_Days__c
                                                     from Current_Disbursal_Details__c where Loan_Application__c = : oppObj.id AND isTopUp__c =true
                                                    ];
        if(delTPDQ.size() > 0){
            Decimal disAmt = delTPDQ[0].Disbursement_Amount__c;
            for(TelePDQuestionMaster__c pos : posToDel){
                if(pos.DisbursementType__c == 'Close Existing'){
                    disAmt -= pos.BalanceAmount__c;
                }
            }
            delTPDQ[0].Disbursement_Amount__c = disAmt;
            if(delTPDQ[0].Disbursement_Amount__c <= 0){
                delete delTPDQ[0];
            }
            else{
                upsert delTPDQ[0];
            }
        }
        
        
        if(posToDel.size() > 0)
            delete posToDel;
        data.posList = posList;
        return JSON.serialize(data);
    }
    public static String saveDataOther(Opportunity oppObj,TelePDQuestionMaster__c posOb,List<TelePDQuestionMaster__c> posList,String accJSON){
        Account accObj = (Account)JSON.deserialize(accJSON,Account.class);//22017
        oppData data = new oppData();
        if(!CommonUtility.isEmpty(posOb))
            posList.add(posOb);
        List<TelePDQuestionMaster__c> posToDel = new List<TelePDQuestionMaster__c>();    
        if(!CommonUtility.isEmpty(posList)){
            for(TelePDQuestionMaster__c pos : posList){
                if(pos.Id != null)
                    posToDel.add(pos);
            }
            if(posToDel.size() > 0)
                delete posToDel;
        }
        update oppObj;
        update accObj;//22017
        List<Current_Disbursal_Details__c> delTPDQ= [select id, Disbursement_To__c, IMPS_Flag__c, Bank_Branch__c, name, Tranche_Detail__c, Loan_Application__c, Internal_Closure__c, Disbursement_Amount__c, Disbursal_Mode__c, Disbursement_Date__c,
                                                     IFSC_Code__c, Favouring__c,isTopUp__c,Tranche_Detail__r.Tranche_Number__c, Bank_Name__c, Bank_Account__c, Payable_at__c, Credit_Days__c
                                                     from Current_Disbursal_Details__c where Loan_Application__c = : oppObj.id AND isTopUp__c =true
                                                    ];
        if(delTPDQ.size() > 0){
            delete delTPDQ;
        }
        List<TelePDQuestionMaster__c> posListNew = new List<TelePDQuestionMaster__c>();
        data.opp = oppObj;
        data.posList = posListNew;
        createSalMcpSOL(oppObj.Id, accJSON);
        /*22182 s*/
        //List<Opportunity> oppList=[select id,EMI_CAM__c,Scheme_Master__c,Approved_Tenor__c,Approved_Rate__c,Loan_Amount_with_Premium__c,Scheme_Master__r.IsHybridFlexi__c from Opportunity where id =: oppObj.Id];
        //Opportunity loan=oppList[0];
        Applicant__c applicantprimary=[select id,Pure_Flexi_Period__c,Drop_Line_Flexi_Period__c,Pure_Flexi_EMI__c from Applicant__c where Loan_Application__c =: oppObj.Id AND Applicant_Type__c ='Primary' ];
        
        String emiVal = SAL_PricingCtrlV2.calculateEMIValue(oppObj,applicantPrimary); //22182
        if(emiVal != null){
            oppObj.EMI_CAM__c = Decimal.valueof(emiVal); //22182
            if(!CommonUtility.isEmpty(oppObj.Scheme_Master__c) && !CommonUtility.isEmpty(oppObj.Scheme_Master__r.IsHybridFlexi__c) && oppObj.Scheme_Master__r.IsHybridFlexi__c == true)
                applicantPrimary.Pure_Flexi_EMI__c =  ((oppObj.Loan_Amount_with_Premium__c *oppObj.Approved_Rate__c) / 1200);
        }
        update applicantPrimary;
        update oppObj;
        data.opp = oppObj;
        /*22182 e*/
        return JSON.serialize(data);
    }
    /*Sales 2.0 added by Krish e*/
    //Rohit submit to credit start
    public static String selectCreditOfficer(string loanAppId) 
    {
        Boolean showCreditSection = false;
        Boolean finalPolresult;
        Integer documentCount = 0;
        List <String> documentNames = new List <String> ();
        try
        {
            Boolean incompleteData = false;
            String fields = '';
            List<String> bankAccFields = new List<String>();
            List<String> appFields = new List<String>{'Proof_of_Residence_Address_Submitted__c'};
                List<String> oppFields = new List<String>{'Processing_Fees__c'};
                    List<String> conFields = new List<String>{'Resi_Area__c','Address_1__c','Address_2__c','Address_3__c','Residence_City__c','State__c','Occupation_CKYC__c','Address_Line_One__c','Address_2nd_Line__c','Address_3rd_Line__c','Office_Pin_Code__c','Office_Phone_Number__c','Office_City__c','Office_State__c','Email','Residence_Type__c'};
                        List<String> camFields = new List<String>{'Proposed_Loan_Amt__c', 'EMI_on_Proposed_Loan_TO__c','Tenor__c', 'ROI__c'};
                            List<String> accFields = new List<String>{'PANNumber__c','First_Name__c','Last_Name__c','Date_of_Birth__c','Mobile__c','PinCode__c','Employer__c','DesignationOTP__c','Qualification__c','Type_of_Educational_Institution__c','Total_Work_Experience_Yrs__c','Total_Work_Experience_Months__c','Current_experiance_in_Years__c','Current_experiance_in_Month__c'};
                                List<Opportunity> oppList = [Select Processing_Fees__c,AccountId,(SELECT Id, Policy_Status__c, Loan_Application__c FROM SOL_Policys__r WHERE Policy_Name__c LIKE 'NSDL Pan Check%') from Opportunity where Id =: loanAppId];
            List<Account> accList = [Select  Offer_Inhanced__c ,epfo_result__c,Type_of_Salary__c,Gender__c , PANNumber__c , First_Name__c , Last_Name__c , Date_of_Birth__c , Mobile__c , PinCode__c , Area_Locality__c , Employer__c , DesignationOTP__c , Qualification__c , Type_of_Educational_Institution__c , Total_Work_Experience_Yrs__c , Total_Work_Experience_Months__c , Current_experiance_in_Years__c , Current_experiance_in_Month__c ,Id,Downsizing_Reasons__c,Preffered_Mode_to_Connect__c from Account where Id =: oppList[0].AccountId];
            List<Applicant__c> appList = [Select  Proof_of_Residence_Address_Submitted__c,Identity_Document_Expiry_Date__c,Proof_of_Identity__c , Identity_Document_No__c , Proof_of_Address_Submitted_for_Permanent__c ,Id,Contact_Name__c from Applicant__c where Loan_Application__c =: loanAppId AND Applicant_Type__c = 'Primary'];
            List<Contact> conList = [Select Resi_Area__c,Permanent_Pin_Code__c,Permanent_State__c,Permanant_City__c,months_of_Residence__c,Permanant_Address_Line_2__c,Permanant_Address_Line_1__c,Permanant_Address_Line_3__c, Address_1__c , Address_2__c , Address_3__c , Residence_City__c , State__c , Occupation_CKYC__c , Address_Line_One__c , Address_2nd_Line__c , Address_3rd_Line__c , Office_Pin_Code__c , Office_Phone_Number__c , Office_City__c , Office_State__c , Email , Marital_Status__c , Father_Spouse__c , Father_Spouse_Salutation__c , Father_Spouse_First_Name__c , Father_Spouse_Last_Name__c , Mother_First_Name__c , Mother_Last_Name__c , Residence_Type__c ,Id,Sex__c from Contact where Id =: appList[0].Contact_Name__c];
            List<CAM__c> camList = [Select Business_Continuty__c,Average_incentive_for_Q2__c,Average_incentive_for_Q1__c,Average_incentive_for_Q3__c,EMI_on_Proposed_Loan_TO__c,Proposed_Loan_Amt__c,ROI__c,Tenor__c,Id,Total_Mthly_Oblig__c,LAP_EMI__c from CAM__c where Loan_Application__c =: loanAppId ] ;
            List<Bank_Account__c> bankAccList = new List<Bank_Account__c>();
            bankAccList  = [Select Salary_Credit_Date2__c,Salary_Credit_Date1__c,Salary_Credit_Date3__c from Bank_Account__c where Loan_Application__c =: loanAppId];
            Map<String,String> nameFields = new Map<String,String>{ 'Proof_of_Residence_Address_Submitted__c' => 'Proof of residence address submitted','Risk_Segmentation__c' => 'Risk Segmentation','Type_of_Loan__c' => 'Loan Type','Permanent_Pin_Code__c' => 'Permanent Pincode', 'Type_of_Salary__c' => 'Type of salary', 'Identity_Document_Expiry_Date__c' => 'Identity document expiry date','Proof_of_Identity__c' => 'Proof of Identity', 'Identity_Document_No__c' => 'Identity Document Number', 'Proof_of_Address_Submitted_for_Permanent__c' => 'Proof of address submitted for permanent', 'Processing_Fees__c' => 'Processing Fees', 'Address_1__c' => 'Residence Address Line 1', 'Address_2__c' => 'Residence Address Line 2', 'Address_3__c' => 'Residence Address Line 3', 'Residence_City__c' => 'Residence City', 'State__c' => 'Residence State', 'Occupation_CKYC__c' => 'Occupation', 'Address_Line_One__c' => 'Office Address Line 1', 'Address_2nd_Line__c' => 'Office Address Line 2', 'Address_3rd_Line__c' => 'Office Address Line 3', 'Office_Pin_Code__c' => 'Office Pincode', 'Office_Phone_Number__c' => 'Office Tele Number', 'Office_City__c' => 'Office City', 'Office_State__c' =>'Office State', 'Email' => 'Personal Email Id', 'Marital_Status__c' => 'Marital Status', 'Father_Spouse__c' => 'Father/Spouse Name', 'Father_Spouse_Salutation__c' => 'Father/Spouse Salutation', 'Father_Spouse_First_Name__c' => 'Father/Spouse First Name', 'Father_Spouse_Last_Name__c' => 'Father/Spouse Last Name', 'Mother_First_Name__c' => 'Mothers First Name', 'Mother_Last_Name__c' => 'Mothers Last Name', 'Residence_Type__c' => 'Residence Type', 'Proposed_Loan_Amt__c' => 'Loan Amount', 'EMI_on_Proposed_Loan_TO__c' => 'EMI', 'Tenor__c' => 'Tenor', 'ROI__c' => 'ROI', 'Gender__c' => 'Gender', 'PANNumber__c' => 'PAN', 'First_Name__c' => 'First Name', 'Last_Name__c' => 'Last Name', 'Date_of_Birth__c' => 'Date of Birth', 'Mobile__c' => 'Mobile', 'PinCode__c' => 'Residence Pincode', 'Area_Locality__c' => 'Area/Locality', 'Employer__c' => 'Employer', 'DesignationOTP__c' => 'Designation', 'Qualification__c' => 'Qualification', 'Type_of_Educational_Institution__c' => 'Institution', 'Total_Work_Experience_Yrs__c' => 'Total Work Experience in Years' ,'Total_Work_Experience_Months__c'  => 'Total Work Experience in Months','Current_experiance_in_Years__c'  => 'Current Work Experience in Years','Current_experiance_in_Month__c'  => 'Current Work Experience in Months', 'Average_incentive_for_Q1__c' => 'Net Salary 1', 'Average_incentive_for_Q2__c' => 'Net Salary 2', 'Average_incentive_for_Q3__c' => 'Net Salary 3', 'Salary_Credit_Date1__c' => 'Salary Credit Date 1', 'Salary_Credit_Date2__c' => 'Salary Credit Date 2', 'Salary_Credit_Date3__c' => 'Salary Credit Date 3', 'Permanant_Address_Line_1__c' => 'Permanent Address Line 1', 'Permanant_Address_Line_2__c' => 'Permanent Address Line 2', 'Permanant_Address_Line_3__c' => 'Permanent Address Line 3', 'Permanant_City__c' => 'Permanent City', 'Permanent_State__c' => 'Permanent State', 'months_of_Residence__c' => 'Months at Residence'};
                //if(appList[0].Proof_of_Identity__c != 'Voters ID card' && appList[0].Proof_of_Identity__c != 'PAN Card')
                //appFields.add('Identity_Document_Expiry_Date__c');
                
                if(conList[0].Residence_Type__c != 'Owned by Self/Spouse' && conList[0].Residence_Type__c != 'Owned by Parent/Sibling'){
                    conFields.add('Permanant_Address_Line_2__c');
                    conFields.add('Permanant_Address_Line_3__c');
                    conFields.add('Permanant_Address_Line_1__c');
                    conFields.add('Permanent_Pin_Code__c');
                    conFields.add('Permanant_City__c');
                    conFields.add('Permanent_State__c');
                    conFields.add('months_of_Residence__c');
                    appFields.add('Proof_of_Address_Submitted_for_Permanent__c');
                }
            if(accList[0].Offer_Inhanced__c){
                camFields.add('Average_incentive_for_Q1__c');
                camFields.add('Average_incentive_for_Q2__c');
                camFields.add('Average_incentive_for_Q3__c');
                camFields.add('EMI_on_Proposed_Loan_TO__c');
                accFields.add('Type_of_Salary__c');
                bankAccFields.add('Salary_Credit_Date1__c');
                bankAccFields.add('Salary_Credit_Date2__c');
                bankAccFields.add('Salary_Credit_Date3__c');
            }
            for(String str : conFields){
                if(conList[0].get(str) == null || String.valueof(conList[0].get(str)) == ''){
                    incompleteData = true;
                    system.debug('str is'+str);
                    fields += nameFields.get(str) + '; ';
                    system.debug('incomplete field'+str);
                }
            }
            for(String str : bankAccFields){
                if(bankAccList != null && bankAccList.size() > 0 && (bankAccList[0].get(str) == null || String.valueof(bankAccList[0].get(str)) == '')){
                    incompleteData = true;
                    system.debug('str is'+str);
                    fields += nameFields.get(str) + '; ';
                    system.debug('incomplete field'+str);
                }
            }
            for(String str : appFields){
                if(appList[0].get(str) == null || String.valueof(appList[0].get(str)) == ''){
                    incompleteData = true;
                    system.debug('str is'+str);
                    fields += nameFields.get(str) + '; ';
                    system.debug('incomplete field'+str);
                }
            }
            for(String str : accFields){
                if(accList[0].get(str) == null || String.valueof(accList[0].get(str)) == ''){
                    incompleteData = true;
                    system.debug('str is'+str);
                    fields += nameFields.get(str) + '; ';
                    system.debug('incomplete field'+str);
                }
            }
            for(String str : camFields){
                if(camList != null && camList.size() > 0){
                    if(camList[0].get(str) == null || String.valueof(camList[0].get(str)) == ''){
                        incompleteData = true;
                        system.debug('str is'+str);
                        fields += nameFields.get(str) + '; ';
                        system.debug('incomplete field'+str);
                    }
                }
                else{
                    incompleteData = true;
                }
            }
            for(String str : oppFields){
                if(oppList[0].get(str) == null || String.valueof(oppList[0].get(str)) == ''){
                    incompleteData = true;
                    system.debug('str is'+str);
                    fields += nameFields.get(str) + '; ';
                    system.debug('incomplete field'+str);
                }
            }
            system.debug('incompletedata'+incompleteData);
            if(incompleteData)
                return 'incompleteData - '+fields;
            else if(!CommonUtility.isEmpty(accList) && CommonUtility.isEmpty(accList[0].epfo_result__c))
                return 'EPFO NOT DONE';
            else if(!CommonUtility.isEmpty(oppList) && CommonUtility.isEmpty(oppList[0].SOL_Policys__r))
                return 'PAN CHECK NOT DONE';
            system.debug('afte rincomplete');
            List <Checklist__c> docChecklist = [SELECT Id, Name,Deviation_Master__c,Deviation_Master__r.Minimum_Approving_Authority__c,  Document_Type__c, Mandatory__c, Sales_Status__c, Document__c 
                                                FROM Checklist__c 
                                                WHERE Loan_Application__c =: loanAppId];
            
            system.debug('docChecklist.size()==' + docChecklist.size());
            
            //Rohit added for PLTB condition Start
            /* Bug 22624 Start - Hrushikesh Sprint 5C */ 
            List<SOL_Policy__c> tempSOLPolicyList=[select id, Remarks__c,Policy_Name__c,Disposition_Status__c,Checklist_Policy_Status__c from SOL_Policy__c where Loan_Application__c = : loanAppId AND (Name LIKE 'Sales2.0 Standard Document Details'  OR Name LIKE 'Sales2.0 Deviation Details')  ];
            if(CommonUtility.isEmpty(tempSOLPolicyList)){
                return 'hit_generate_checklist';  
                
            }
            
            /* Bug 22624 Stop - Hrushikesh Sprint 5C */
            oppData dss = new oppData();
            
            getAllData(loanAppId,dss);
            
            
            
            System.debug('dss po '+dss.poObj);
            if(dss.poobj != null){
                Boolean callCenterFlag = checkForPLTB(dss.poobj);
                if(callCenterFlag && dss.isTeleCaller ){
                    List<String> failedpolicies = new List<String>(); 
                    Map<String,Boolean> policyResult = fetchCheckListMap(dss.poobj,dss);
                    System.debug('policyMap '+policyResult);
                    if(policyResult != null){
                        for(String str : policyResult.keySet()){
                            system.debug('policyResult.get(str)'+str+'--'+policyResult.get(str));
                            if(policyResult.get(str) == false){
                                finalPolresult = false;
                                failedpolicies.add(str);
                            }
                        }
                    }
                    System.debug('failed list '+failedpolicies);
                    if(finalPolResult == false){
                        System.debug('in pltb failure');
                        //assign owner of po tp opportuntiy
                        Id poOwner = dss.poobj.OwnerId;
                        /*if(poOwner != null){
Opportunity pltbOpp = dss.opp;
pltbOpp.OwnerId = poOwner;
pltbOpp.StageName = 'DSA/PSF Login';                       
try{
update pltbOpp; 
}catch(Exception ex){
System.debug('Exception '+ex.getLineNumber());
return 'PLTB Failure';
}
return 'PLTB Success';
}*/
                        try{
                            return sendToSales(dss.opp);
                        }catch(Exception ex){
                            System.debug('pk'+ex.getLineNumber()+ex.getMessage());
                            return 'PLTB Failure';
                        }
                    }
                    
                }
            }
            //Rohit added for PLTB condition stop
            for (Checklist__c chk: docChecklist) 
            {
                system.debug('chk.Sales_Status__c==' + chk.Sales_Status__c);
                system.debug('chk.Document__c==' + chk.Document__c);
                if (chk.Document__c != null) documentNames.add(chk.Document__c);
                if(chk.Deviation_master__c == null){
                    if (chk.Mandatory__c == true && chk.Sales_Status__c != 'Received') documentCount = documentCount + 1;
                }
                else{
                    if (chk.Mandatory__c == true && chk.Sales_Status__c != 'Received' && chk.Deviation_Master__r.Minimum_Approving_Authority__c == dss.myProflieName) documentCount = documentCount + 1;
                }
            }
            //Bug 20939 RCU added below condition
            if (dss.myProflieName != 'SAL Tele Calling Team' && documentCount > 0) 
            {
                // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'All mandatory documents are not collected.You cannot proceed to CPA stage!!'));
            } 
            else 
            {
                showCreditSection = true;
            }
        }
        catch(Exception ex)
        {
            System.debug('ex++'+ex.getMessage()+' '+ex.getLineNumber());
            return 'Failure'; 
        }
        return showCreditSection? 'showCreditSection':'CreditFailure';
    }
    
    public static String checkSecondaryCibil(oppData dss){
        
        System.debug('dss opp'+dss.opp.Id);
        List<CIBIL_secondary_match__c> secCibilList = new List<CIBIL_secondary_match__c>();
        secCibilList=[SELECT Id,PAN_Number__c,Cibil_12_Secondary__c FROM CIBIL_secondary_match__c WHERE Cibil_12_Secondary__c =:dss.opp.Id ];
        
        if(secCibilList.size()>0){
            CIBIL_secondary_match__c secCibil = secCibilList[0];
            Applicant__c appPrim = dss.applicantPrimary;
            
            if(appPrim != null && appPrim.PAN_Number__c != null && secCibil.PAN_Number__c != null){
                if(appPrim.PAN_Number__c.toUpperCase() != secCibil.PAN_Number__c.toUpperCase()){
                    //call dual pan 
                    System.debug('pan didnt match ...');
                    String response = PANCheck(secCibil.PAN_Number__c,label.Product_For_PAN_Check,appPrim.Loan_Application__c,null,null,true);
                    return 'Success';
                }
                else{
                    System.debug('pan matched!! ...');
                    return 'PAN matched';
                }   
            }           
            
        }
        System.debug('data not present...');
        return 'Data not present';
    }
    
    //2.0 CR's changed method
    public static String sendToSales(Opportunity loan) {
        String loanOwner;
        List < Sales_Officer_Limit__c > allSolimt = new List < Sales_Officer_Limit__c > ();
        allSolimt = [select id, PSFASMSelected__c, Area_Pincodes__c, Data_Source__c, Sales_Officer_Name__c, Sales_Officer_Name__r.Mobile_number__c, Reporting_Manager_Name__c, Reporting_Manager_Name__r.Mobile_number__c, ASM_Branch__c, Selected_Flag__c, Designation__c, Location__c, Product__c, Max_Number__c from Sales_Officer_Limit__c where
                     Active__c = true And Sales_Officer_Name__r.IsActive = true AND Product__c =: loan.Product__c AND (Designation__c =: 'Area Sales Manager' OR Designation__c =: 'PSF Community')
                    ];
        List < Sales_Officer_Limit__c > solForAuto = new List < Sales_Officer_Limit__c > ();
        List < Sales_Officer_Limit__c > psfList = new List < Sales_Officer_Limit__c > ();
        List < Sales_Officer_Limit__c > asmList = new List < Sales_Officer_Limit__c > ();
        Boolean assigned = false;
        String pincode = String.valueof(loan.Account.PinCode__c);
        for (Sales_Officer_Limit__c sol: allSolimt) {
            if ((sol.Designation__c == 'Area Sales Manager' || sol.Designation__c == 'PSF Community') && sol.Location__c != null && sol.Data_Source__c != null && sol.area_pincodes__c != null && sol.Location__c.containsIgnoreCase(loan.Branch_Name__r.name) && sol.Data_Source__c.containsIgnoreCase('Assist One') && sol.area_pincodes__c.contains(pincode) && sol.Product__c == loan.Product__c) {
                if (sol.Designation__c == 'PSF Community') {
                    psfList.add(sol);
                } else if (sol.Designation__c == 'Area Sales manager') {
                    asmList.add(sol);
                }
                
            }
        }
        solForAuto.addAll(psfList);
        solForAuto.addAll(asmList);
        system.debug('solForAuto' + solForAuto);
        for (Sales_Officer_Limit__c sol: solForAuto) {
            if (sol.PSFASMSelected__c == false) {
                loanOwner = sol.sales_officer_name__c;
                sol.PSFASMSelected__c = true;
                assigned = true;
                break;
            }
        }
        if (assigned == false) {
            for (Sales_Officer_Limit__c sol: solForAuto) {
                if (sol.PSFASMSelected__c == true)
                    sol.PSFASMSelected__c = false;
            }
            for (Sales_Officer_Limit__c sol: solForAuto) {
                if (sol.PSFASMSelected__c == false) {
                    loanOwner = sol.sales_officer_name__c;
                    sol.PSFASMSelected__c = true;
                    assigned = true;
                    break;
                }
            }
        }
        if (solForAuto.size() > 0) {
            upsert solForAuto;
        }
        else{
            return 'Sales not available';
        }
        if (loanOwner != null) {
            loan.OwnerId = loanOwner;
            loan.StageName = 'DSA/PSF Login';
            System.debug('before update');
            update loan;
            
            return 'Success';
        }
        
        return 'Failure';
        
    }
    
    
    public static List<SALMobilityCntrl_V2.SelectOption> getCreditOfficerPicklist(string LoanId)
    {
        List <SALMobilityCntrl_V2.SelectOption> optionsAppr = new List <SALMobilityCntrl_V2.SelectOption> ();
        List<Opportunity> listLoanApp = new List<Opportunity>();
        Opportunity objLoanApp = new Opportunity();
        listLoanApp = [SELECT POS__c,Id,BranchName__c,Branch_Name__c,createddate,Product__c,Branch_Name__r.Name,Loan_Application_Flow__c
                       FROM Opportunity 
                       WHERE Id = : LoanId];
        
        Date COLStampdate;
        Boolean COLStampFlag;
        if(listLoanApp.size() > 0)
        {
            objLoanApp = listLoanApp[0];
            
            if (LaonApplicationCreation__c.getValues('Hierarchy Stamping') != null) 
            {
                String COLDate = LaonApplicationCreation__c.getValues('Hierarchy Stamping').Credit_Hierarchy_Stamping_Date__c;
                if (COLDate != null) {
                    system.debug('***COLDate***' + COLDate);
                    COLStampdate = date.parse(COLDate);
                }
            }
            system.debug('***COLStampdate***' + COLStampdate);
            
            if (COLStampdate != null && objLoanApp != null && COLStampdate < objLoanApp.createddate) {
                COLStampFlag = true;
            }
            
            List<Credit_Officer_Limit__c> listCreditOfficerLimit = new List<Credit_Officer_Limit__c>();
            listCreditOfficerLimit = [SELECT Id, Name, Designation__c, City__c, SW_Excess_Limit__c, W_Excess_Limit__c, WL_Excess_Limit__c, LSO_Normal_Excess_Limit__c, Pre_Approved_Amount__c, Number_of_Deviations__c, Credit_Officer_Name__r.Isactive, Credit_Officer_Name__r.id,
                                      Credit_Officer_Name__r.name, Credit_Officer_Name__c, Loan_Amount__c, User_Type__c, Flow__c
                                      FROM Credit_Officer_Limit__c
                                      WHERE product__c = : objLoanApp.Product__c 
                                      AND Credit_Officer_Name__r.Isactive = true 
                                      AND Active_Flag__c = true 
                                      AND User_Type__c != 'OPs User' 
                                      AND City__c INCLUDES(:objLoanApp.BranchName__c)];
            
            system.debug('listCreditOfficerLimit++'+listCreditOfficerLimit);
            
            if (listCreditOfficerLimit.size() > 0) 
            {
                for (Integer i = 0; i < listCreditOfficerLimit.size(); i++) 
                {
                    //system.debug('branch+'+objLoanApp.Branch_Name__c);
                    if (objLoanApp.Branch_Name__c == null) {
                        
                        //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Branch value is empty. Unable to continue'));
                    } 
                    else {
                        if ((listCreditOfficerLimit[i].Credit_Officer_Name__c != null) && (listCreditOfficerLimit[i].city__c != null) && objLoanApp != null && objLoanApp.Branch_Name__r != null && objLoanApp.Branch_Name__r.name != null) {
                            system.debug('listCreditOfficerLimit[i].City__c.toUpperCase(): ' + listCreditOfficerLimit[i].City__c.toUpperCase()+' '+objLoanApp.Branch_Name__r.name.toUpperCase());
                            if (COLStampFlag == true) {
                                if (listCreditOfficerLimit[i].City__c.toUpperCase().contains(objLoanApp.Branch_Name__r.name.toUpperCase()) && listCreditOfficerLimit[i].Flow__c != null && objLoanApp.Loan_Application_Flow__c != null && listCreditOfficerLimit[i].Flow__c.contains(objLoanApp.Loan_Application_Flow__c)) {
                                    system.debug('if city matches');
                                    optionsAppr.add(new SALMobilityCntrl_V2.SelectOption(listCreditOfficerLimit[i].Id, listCreditOfficerLimit[i].Credit_Officer_Name__r.name + '-' + listCreditOfficerLimit[i].Designation__c));
                                }
                            } 
                            else {
                                if (listCreditOfficerLimit[i].City__c.toUpperCase().contains(objLoanApp.Branch_Name__r.name.toUpperCase())) {
                                    system.debug('if city matches');
                                    optionsAppr.add(new SALMobilityCntrl_V2.SelectOption(listCreditOfficerLimit[i].Id, listCreditOfficerLimit[i].Credit_Officer_Name__r.name + '-' + listCreditOfficerLimit[i].Designation__c));
                                }
                            }
                        }
                        //optionsAppr.add(new SALMobilityController.SelectOption(listCreditOfficerLimit[i].Id, listCreditOfficerLimit[i].Credit_Officer_Name__r.name + '-' + listCreditOfficerLimit[i].Designation__c));
                    }
                }
            }
        }
        system.debug('optionsAppr ---->' + optionsAppr);
        //optionsAppr.sort();
        return optionsAppr;
    }
    
    public static void fetchApplicant(string loanApplicationId, String app, string StrAppr1)
    {   
        system.debug('loandapplication id'+loanApplicationId);
        Applicant__c primaryApp = (Applicant__c)JSON.deserialize(app,Applicant__c.class);
        Applicant__c objApplicantPrimary = new Applicant__c();
        try
        {
            update primaryApp;
            if(loanApplicationId != NULL)
            {
                List<Applicant__c> listApplicantPrimary = new List<Applicant__c>();
                
                listApplicantPrimary  = [select /*OTP V3 CR s*/Contact_Name__r.Permanant_City__c,Proof_of_Registered_Address_Submitted__c,Contact_Name__r.Years_At_Residence__c,Location_wise_ews_status__c,Risk_Segmentation__c,Codified_Cibil__c,Contact_Name__r.special_profile_employer__c,Contact_Name__r.Employer__r.Employer_List__c,/*OTP V3 CR e*/Contact_Name__r.date_of_Birth__c,/*SAL PLTB Pritha S*/ LTA_Medical__c, LTA_Frequency__c, /*SAL PLTB Pritha E*/Underwriter_RSA_Remark__c,ROIFlexi__c, ROILoc__c, ROINormal__c, ROI_PO__c, Contact_Name__r.Current_Employment_Vintage__c, Contact_Name__r.TAN_Found_In_Master__c, Contact_Name__r.office_no_check_on_company_site__c, Contact_Name__r.SFDC_Dedupe_check__c, Contact_Name__r.PAN_Response__c, Contact_Name__r.Linkedin_check_result__c, Contact_Name__r.Google_check_result__c, Contact_Name__r.PAN__c, Contact_Name__r.Last_Modified_Date__c, Contact_Name__r.Name_of_the_PAN_holder__c, Contact_Name__r.Designation__c, Contact_Name__r.Employer__r.Domain_Name__c, Contact_Name__r.Employer__r.Company_Category__c, ContactName__c, Contact_Name__r.Name, Existing_Customer__c, Applicant_Type__c, SegmentaionResult__c, Loan_Application__c, Contact_Name__r.Office_Email_Id__c,
                                         per_of_Loan_Amount_HI__c, per_of_Loan_Amount_LI__c,ASM_Comments__c, Bundled_VAS__c, Bundled_VAS_Type__c, Contact_Name__r.EMI_Bounce_in_last_3_months__c,
                                         Credit_Card_Check__c, Credit_Card_Type__c, FFR_Tag__c, Health_Insurance__c, Health_Insurance_Amount__c, Contact_Name__r.Total_Employment_vintage_Year__c,
                                         Life_Insurance__c, Life_Insurance_Amount__c, All_Standard_Docs_Received__c, All_Deviation_Docs_Received__c, Offer_Segmentation__c, SME_Score__c,
                                         All_Disbursement_Docs_Received__c, Is_PL_BT__c, cibil_score__c, Loan_Application__r.Bank_A_c_No_of_Customer__c, Underwriter_Remarks__c, Contact_Name__r.Residence_Type__c,
                                         Contact_Name__r.Customer_Type__c, Contact_Name__r.Age_of_Applicant__c, Contact_Name__r.Age_Round_Down__c, Contact_Mobile__c,
                                         RSA_Employee_ID__c, RSA_Loan_application_status__c, RSA_Remarks__c, RSA_flag__c, EMI_Holiday_Opted__c,
                                         Identified_for_Invisible_Monitoring__c, Invisible_Monitoring_Skipped__c, Invisible_Monitoring_Triggered__c, Invisible_monitoring__c, Verifications_returned_by_IM_BRE__c,
                                         /* Start of MSME BL changes */
                                         Hub_Name__c, Submit_To_Credit_SMS_sent__c
                                         /* End of MSME BL changes */
                                         , /*Mortgage*/ Contact_Name__r.Residence_City__c, Contact_Name__r.Property_Owner__c, BT_Bank_Type__c, Contact_Name__r.Occupatipn__c
                                         /* SAL Policy Changes Start */
                                         , RC_Decline__c, RC_Deviation__c, Contact_Name__r.Name_of_Employer__c /* SAL Policy Changes End */ , Approved__c, approvedbysales__c // Added by Mahima --Ops Efficiency 
                                         /*added by akshata invisible monitoring DL*/
                                         , RSA_initiation_Date__c, RSA_TAT__c, RSA_Closure_Date__c, /*Rasika added PD_Time__c,PD_Flag__c */ PD_Time__c, PD_Flag__c, LastModifiedDate, Office_Email_Id_Verified__c, Total_Employment_Vintage__c, Domain_Created_Date__c /* bug 11151*/ 
                                         ,PAN_Number__c//Added By rajendra to avoid issue for invisible monitoring pan number field is not found. 
                                         ,Applicant_Cibil_TU_Score__c,//Added By rajendra for Controllership trigger.
                                         (select Date_of_Enquiry__c,Date_of_Enquiry1__c,Date_of_Enquiry2__c,Date_of_Enquiry3__c,Date_of_Enquiry4__c,
                                          Date_of_Enquiry5__c,Date_of_Enquiry6__c,Date_of_Enquiry7__c,Date_of_Enquiry8__c,Date_of_Enquiry9__c,
                                          Date_of_Enquiry10__c,Date_of_Enquiry11__c,Date_of_Enquiry12__c,Date_of_Enquiry13__c,Date_of_Enquiry14__c
                                          ,Date_of_Enquiry15__c,Date_of_Enquiry16__c,Date_of_Enquiry17__c,Date_of_Enquiry18__c,Date_of_Enquiry19__c
                                          from CIBILs__r ),
                                         (select Date_of_Enquiry20__c,Date_of_Enquiry21__c,Date_of_Enquiry22__c,Date_of_Enquiry23__c 
                                          ,Date_of_Enquiry24__c,Date_of_Enquiry25__c,Date_of_Enquiry26__c,Date_of_Enquiry27__c
                                          ,Date_of_Enquiry28__c,Date_of_Enquiry29__c,Unsecured_to_Secured_ratio__c,No_of_PL_Enq_in_Last_3_Months__c from CIBIL_Extension__r) 
                                         from Applicant__c WHERE Loan_Application__c = : loanApplicationId 
                                         AND Applicant_Type__c = 'Primary' 
                                         LIMIT 1];
                
                if(listApplicantPrimary.size() > 0)
                {
                    objApplicantPrimary = listApplicantPrimary[0];
                    objApplicantPrimary.Loan_Application__c = loanApplicationId;
                    objApplicantPrimary.ASM_Comments__c = primaryApp.ASM_Comments__c;
                    system.debug('hi++'+objApplicantPrimary.Loan_Application__c);
                    OpportunityMobilityUtility.isAutoCredit= SALMobilityOppCntrl_V2.isAutoCredit;// Bug Id : 21804
                    UPDATE objApplicantPrimary;
                    Pagereference p = OpportunityMobilityUtility.submitappr(loanApplicationId,StrAppr1);
                    System.debug('method+p++'+p);            
                }
            }
        }
        catch(Exception ex)
        {
            system.debug('Applicant++'+ex.getMessage());
        }
        //Pagereference p;
        //p = new pagereference(site.getBaseUrl()+'/006/o');
        //return p;
    }
    
    public static Pagereference submitappr(String loanApplicationId, String StrAppr1) 
    { 
        Pagereference p;
        try
        {
            system.debug('loanApplicationId++'+loanApplicationId);
            system.debug('StrAppr1++'+StrAppr1);
            if(!Test.isRunningTest())
            {
                SalesEligibilityDetailsCtrl sobj = new SalesEligibilityDetailsCtrl(loanApplicationId);
                User UserInfoDetails = [select id, Profile.Name, Name from User where id = : UserInfo.getUserId() LIMIT 1];
                System.debug('--UserInfoDetails --' + UserInfoDetails);
                sobj.isCommunityUsr = CommonUtility.hasCommunityProfile(new Set<String>{UserInfoDetails.Profile.Name});
                sobj.grouptype = 'salaried';
                //sobj.product = 'SAL';
                sobj.salPOFlow = false;
                sobj.StrAppr1 = StrAppr1;
                system.debug('isnside submitappr');
                p = sobj.submitappr();
                system.debug('p++'+p);
            }
        }
        catch(Exception ex)
        {
            System.debug('I am at line ' + String.valueOf(ex.getLineNumber()) +' '+ ex.getMessage());
        }
        return p;
    }   
    
    public static Boolean checkForPLTB(Product_Offerings__c productOffer){
        
        Set < String > callCentreProdlbl = new Set < String > ();
        Set < String > callCentrelbl = new Set < String > ();
        Boolean callCenterProcessFlag = false;
        
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
            system.debug('label:-' + Label.Call_Centre_Idetifier);
            String[]arr1 = Label.Call_Centre_Idetifier.split(';');
            for (String str1: arr1) {
                callCentrelbl.add(str1.ToUpperCase());
            }
        }
        
        if (callCentreProdlbl != null && callCentreProdlbl.size() > 0 && callCentrelbl != null && callCentrelbl.size() > 0) 
        {
            system.debug('inside callCentreProdlbl' + productOffer+ 'callCentrelbl' + callCentrelbl);
            if (productOffer != null && productOffer.Products__c != null && callCentreProdlbl.contains(productOffer.Products__c.ToUpperCase())) {
                if (productOffer.Lead_Source__c != null && callCentrelbl.contains(productOffer.Lead_Source__c.ToUpperCase())) {
                    callCenterProcessFlag = true;
                }
            }
        }
        
        return callCenterProcessFlag;
    }
    
    public static List<String> plcyList;
    public static Map<String,Boolean> fetchCheckListMap(Product_Offerings__c productoffer,oppData dss){
        try{
            List<Lead> ldobj;
            Map<String,Boolean> policyResult = new Map<String,Boolean>();      
            Map<String,SOL_Policy__c> tempmap = new Map<String,SOL_Policy__c>();
            
            SOL_Policy__c solObj;
            
            popultplcy();
            System.debug('list '+plcyList);
            List<Product_Offerings__c > po = [select KYC_verification_Done__c,Bank_Details_Change__c,Lead__r.Id from Product_Offerings__c where Id= : productoffer.Id limit 1];
            if(po != null && po.size()>0)
                ldobj= [select FirstName,LastName,(SELECT Id,Number_of_Hl_Loans__c,X6_months_DPD__c,X30_DPD_12_months__c,X5000_amount_overdue__c,No_of_Live_PL__c FROM Cibil_Extension1s__r),De_Dupe__r.Customer_Status__c,De_Dupe__r.Negative_Area__c,Company_Category__r.Company_Category__c,Applicant_Type__c,Employer__c,Office_Email_ID__c,CIBIL_Score__c,PAN__c,/*SAL PLTB Bug 13263 fixed by priya start*/Customer_Mobile__c,Employer__r.Name,Designation__c,Income_Salary__c,Resi_City__c/*SAL PLTB Bug 13263 fixed by priya end*/ from Lead where id= : productoffer.Lead__r.Id Limit 1];
            List<Bank_Account__c> bnklst = [select Perfios_Flag__c,Perfios_Bank_Name__c,SalCrdtDateInconsistencyInPerfiose__c,HVTinPerfios__c,Latest_bounce_in_Perfios__c from Bank_Account__c where Product_Offerings__c = :productoffer.Id limit 50];     
            
            if(plcyList != null){
                
                for(String str: plcyList)
                {           
                    if(str == 'Official Email Confirmation'){
                        policyResult.put(str,ofcEmailCheck(dss.SOLPolicyList));
                    }
                    /*else if(str == 'Domain check'){
policyResult.put(str,checkDomain(dss.applicantPrimary));                       
}*/
                    else if(str == 'Cibil Pass'){
                        policyResult.put(str,cibilCheck(dss.applicantPrimary));
                    }
                    else if(str == 'Dedupe Pass'){
                        policyResult.put(str,dedupCheck(dss.dedupeList));
                    }   
                    else if(str == 'Perfios Confirmation'){      
                        policyResult.put(str,perfiosCheck(bnklst));
                    }   
                    else if(str == 'Banking Details Change'){
                        policyResult.put(str,bnkDtlCheck(productoffer));
                    }
                    else if(str == 'Open ECS limit check'){
                        policyResult.put(str,opnECSCheck(productoffer));
                    }
                    else if(str == 'Pan Check'){
                        policyResult.put(str,panCheck(dss));
                    }
                    else if(str == 'Company listing check'){
                        policyResult.put(str,cmpnyLstngChk(ldobj[0]));
                    }
                    else if(str == 'Latest bounce in Perfios check'){
                        policyResult.put(str,LtstbouncChk(bnklst));
                    }
                    else if(str == 'Salary credit date inconsistency in Perfios check'){
                        policyResult.put(str,SalCrdtDtIncnsistncyChk(bnklst));
                    }
                    else if(str == 'HVT in perfios check'){
                        policyResult.put(str,HVTChk(bnklst));
                    }
                    else if(str == 'Negative Area Check'){
                        policyResult.put(str,negativeAreaCheck(ldobj[0]));
                    }
                    else if(str == 'Employment Check'){
                        policyResult.put(str,employerCheck(dss.applicantPrimary));
                    }                           
                }
                
            }
            return policyResult;
        }
        catch(Exception e){
            return null;
        }
        
    }
    
    public static void popultplcy()
    {
        
        plcyList = new List<String>();
        Map<String, Object> clst;
        StaticResource staticRsrc ;
        staticRsrc = [SELECT Body,Id,Name FROM StaticResource WHERE Name = 'CkeckListJson' limit 1];
        String jsnBody= staticRsrc.Body.tostring();
        Map<String,Object> chklstMap = (Map<String,Object>) JSON.deserializeUntyped(jsnBody);
        Map<String,Object> jsonField = new Map<String,Object>();
        for(String jsonKey: chklstMap.keySet())
        {
            jsonField =(Map<String, Object>)chklstMap.get(jsonKey);
            for(String val: jsonField.keyset())
            {
                Map<String, Object> jsonf =(Map<String, Object>)jsonField.get(val);
                String lbl= (String)jsonf.get('LBL');
                if(jsonf.get('MNDTRY') == 'TRUE')
                    plcyList.add(lbl); 
            }
        }
    }
    
    public static Boolean employerCheck(Applicant__c app){
        
        if(app != null && app.Office_Email_Id_Verified__c == true){
            return true;
        }
        
        return false;
    }
    
    public static Boolean ofcEmailCheck( List<SOL_Policy__c> solList){
        if(!CommonUtility.isEmpty(solList))
        {
            for(SOL_Policy__c sol : solList){
                if(sol.Policy_Name__c.contains('Employment Check Pass') && sol.Policy_Status__c == 'OK')
                    return true;
                
            }
        }
        return false;
        /*if(po != null && po.KYC_verification_Done__c == 'Yes'){
return true;
}
else{
return false;
} */              
        
    }
    
    public static Boolean cibilCheck(Applicant__c app){
        /*List < CIBIL_Extension1__c > LeadCibiExtList = new List < CIBIL_Extension1__c > ();
LeadCibiExtList = ldobj.Cibil_Extension1s__r;*/
        if(app != null && app.CIBIL_Score__c >= '00780' && !CommonUtility.isEmpty(app.Codified_CIBIL__c) && app.Codified_CIBIL__c.toUpperCase() == 'POSITIVE' ){
            return true;   
        }
        /* else if(ldobj.CIBIL_Score__c > '00699' && ldobj.CIBIL_Score__c < '00780' && LeadCibiExtList.size()>0 && LeadCibiExtList[0].Number_of_Hl_Loans__c > 0){
return true;
}
else if(LeadCibiExtList.size()>0 && LeadCibiExtList[0].X6_months_DPD__c != 'Yes' && LeadCibiExtList[0].X30_DPD_12_months__c != 'Yes'){
return true;
}
else if(LeadCibiExtList.size()>0 && LeadCibiExtList[0].X5000_amount_overdue__c != 'Yes'){
return true;
}
else if(LeadCibiExtList.size()>0 && LeadCibiExtList[0].No_of_Live_PL__c < 4){
return true;
}*/
        
        return false;
    }
    
    public static Boolean dedupCheck(List<De_Dupe__c> dedupeList){
        if(!CommonUtility.isEmpty(dedupeList)){
            for(De_Dupe__c dedupe : dedupeList){
                if(dedupe.Applicant__r.Applicant_Type__c == 'Primary' && dedupe.Source_Or_Target__c == 'Target' && (dedupe.Customer_Status__c != 'Good' && dedupe.Customer_Status__c != 'Refer')){
                    return false;
                }
                
            }
        }
        return true;
        /*
if(ldObj != null && ldObj.De_Dupe__r != null && ldObj.De_Dupe__r.Customer_Status__c == 'Good'){
return true;
}
else if(ldObj != null && ldObj.De_Dupe__r != null && ldObj.De_Dupe__r.Customer_Status__c == 'Bad'){
return false;
}
else if(ldObj != null && ldObj.De_Dupe__r != null && ldObj.De_Dupe__r.Customer_Status__c == 'No Match'){
return false;
}
else if(ldObj != null && ldObj.De_Dupe__r != null && ldObj.De_Dupe__r.Customer_Status__c == 'Refer'){
return true;
}

return false;*/
    }
    
    public static Boolean perfiosCheck(List<Bank_Account__c> bnklst){
        Boolean isPerfiosdone = false;
        if(bnklst != null && bnklst.size()>0){          
            for(Bank_Account__c bnk : bnklst) {
                if(bnk.Perfios_Flag__c == true ){
                    isPerfiosdone = true;
                    break;   
                }           
            }
            
        }       
        return isPerfiosdone;
    }   
    
    public static Boolean bnkDtlCheck(Product_Offerings__c po){
        if(po.Bank_Details_Change__c == true){
            return false;    
        }
        else{
            return true;
        }                                        
    }
    public static Boolean opnECSCheck(Product_Offerings__c po){
        if(po.ECS_End_Date__c > date.today()){
            return true;    
        }
        else{
            return false;
        }                              
        
    }
    
    public static Boolean cmpnyLstngChk(Lead leadObj){
        String CompanyCategory = '';
        if (leadObj != null && leadObj.Employer__c != null) {
            List < Segment_Master__c > segMtrListTemp = [select id, Name, Company_Category__c from Segment_Master__c where id = : leadObj.Employer__c limit 1];
            if (segMtrListTemp != null && segMtrListTemp.size() > 0) {
                CompanyCategory = segMtrListTemp[0].Company_Category__c;
            }
        }
        if(CompanyCategory != null){
            if(CompanyCategory.toUpperCase() == 'OTHERS'){
                
                return false;    
            }
            else{
                return true;
            }
        }
        return false;               
        
    }
    
    public static Boolean LtstbouncChk(List<Bank_Account__c> bnklst){
        if(bnklst != null && bnklst.size() > 0){
            if(bnklst[0].Latest_bounce_in_Perfios__c == true ){
                return false; 
            }   
            else{
                return true;
            }
        }
        return false;               
        
    }
    
    public static Boolean SalCrdtDtIncnsistncyChk(List<Bank_Account__c> bnklst){
        if(bnklst != null && bnklst.size() > 0){
            if(bnklst[0].SalCrdtDateInconsistencyInPerfiose__c == true ){
                return false;
            }
            else{
                return true;
            }
        }
        return false;               
        
    }
    
    public static Boolean HVTChk(List<Bank_Account__c> bnklst){
        if(bnklst != null && bnklst.size() > 0){
            if(bnklst[0].HVTinPerfios__c == true ){
                return false;  
            }
            else{
                return true;
            }
        }
        return false;             
        
    }
    
    public static Boolean negativeAreaCheck(Lead ldobj){
        if(ldObj != null && ldObj.De_Dupe__r != null && ldObj.De_Dupe__r.Negative_Area__c){
            return false;       
        }
        return true;
        
    }
    
    /*public static Boolean checkDomain(Applicant__c app){

if(app != null && app.Domain_Check_Result__c != null && (app.Domain_Check_Result__c == 'OK' || app.Domain_Check_Result__c == 'Pass'))
return true;

return false;
}
*/
    public static Boolean panCheck(oppData dss){
        try{
            List<Sol_Policy__c> solList = [SELECT Id,Policy_Status__c,Loan_Application__c FROM Sol_Policy__c WHERE Loan_Application__c =:dss.opp.Id AND Policy_Name__c LIKE 'PAN%'];
            if(solList != null && solList.size()>0 && solList[0].Policy_Status__c != null && solList[0].Policy_Status__c.toUpperCase() != 'REJECTED')
                return true;
            
            return false; 
        }
        catch(Exception e){
            return false;
        }
        
        
    }
    //Rohit submit to credit stop
    /*Sales 2.0 added by Krish s*/
     public static String getOfferDetails(Opportunity oppObj,Account accObj,Applicant__c appObj,Contact conObj){
        Decimal offerAmt ;
        String businesses = Label.Business_Loans;
        Set<String> busSt = new Set<String>(businesses.toUpperCase().split(';'));
        Set<String> homeSt = new Set<String>(((String)CommonUtility.getStaticResourceData('SalariedCustomSettings','Home Loans','')).toUpperCase().split(';'));
        Set<String> perSt = new Set<String>(((String)CommonUtility.getStaticResourceData('SalariedCustomSettings','Personal Loans','')).toUpperCase().split(';'));
        Set<String> autoSt = new Set<String>(((String)CommonUtility.getStaticResourceData('SalariedCustomSettings','Auto Loans','')).toUpperCase().split(';'));
        
        system.debug('---'+oppObj+accObj+appObj+'pkarea'+perSt);
        oppData dss= new oppData (); 
        try{
            Product_Offerings__c POobj;
            
            Cibil_Extension1__c cibext1 = new Cibil_Extension1__c();
            Cibil_Extension__c cibext = new Cibil_Extension__c();
            CAM__c camObj = new CAM__c();
            List < Cibil_Extension1__c > cibilExt1List = new List < Cibil_Extension1__c > ();
            List < CIBIL_Extension__c > cibilExtLst = new List < CIBIL_Extension__c > ();
            List<Existing_Loan_Details__c> extLoanList = new List<Existing_Loan_Details__c>();
            List < CIBIL__c> cibilList = new List < CIBIL__c> (); //22017
            if(oppObj.Existing_Loan_Details__r != null && oppObj.Existing_Loan_Details__r.size() > 0){
                extLoanList = oppObj.Existing_Loan_Details__r;
            }
            if(oppObj.CAMs__r != null && oppObj.CAMs__r.size() > 0){
                List<CAM__c> lstCAM = oppObj.CAMs__r;
                if(lstCAM != null && lstCAM.size() > 0)
                    camobj =  lstCAM[0]; 
            }
            /*22017 s*/
            Cibil__c cibilobj = new Cibil__c();
            if(appObj != null)
                cibilList = [select /*24318 start */Ownership__c, Ownership1__c, Ownership2__c, Ownership3__c, Ownership4__c, Ownership5__c, Ownership6__c, Ownership7__c, Ownership8__c, Ownership9__c, Ownership10__c, Ownership11__c, Ownership12__c, Ownership13__c, Ownership14__c, Ownership15__c, Ownership16__c, Ownership17__c, Ownership18__c, Ownership19__c,Date_Opened__c,Date_Opened1__c,Date_Opened2__c,Date_Opened3__c,Date_Opened4__c,Date_Opened5__c,Date_Opened6__c,Date_Opened7__c,
                             Date_Opened8__c,Date_Opened9__c,Date_Opened10__c,Date_Opened11__c,Date_Opened12__c,Date_Opened13__c,Date_Opened14__c,
                             Date_Opened15__c,Date_Opened16__c,Date_Opened17__c,Date_Opened18__c,Date_Opened19__c,/*24318 stop*/Account_Type1__c,Account_Type2__c,Account_Type3__c,Account_Type4__c,Account_Type5__c,Account_Type6__c,Account_Type7__c,Account_Type8__c,
                             Account_Type9__c,Account_Type10__c,Account_Type11__c,Account_Type12__c,Account_Type13__c,Account_Type14__c,Account_Type15__c,Account_Type16__c,
                             Account_Type17__c,Account_Type18__c,Account_Type19__c,Account_Type__c,Sanction_Amount__c,Sanction_Amount1__c,Sanction_Amount10__c,Sanction_Amount11__c,Sanction_Amount12__c,Sanction_Amount13__c,Sanction_Amount14__c,Sanction_Amount15__c,Sanction_Amount16__c,Sanction_Amount17__c,Sanction_Amount18__c,Sanction_Amount19__c,Sanction_Amount2__c,Sanction_Amount3__c,Sanction_Amount4__c,Sanction_Amount5__c,Sanction_Amount6__c,Sanction_Amount7__c,Sanction_Amount8__c,Sanction_Amount9__c from CIBIL__c where Applicant__c = : appObj.id limit 1];
            if (cibilList != null && cibilList.size() > 0) {
                cibilobj = cibilList[0];
            }
            /*22017 e*/
            if(appObj != null)
                cibilExt1List = [select /*OTP v3 CRs*/liveLoanAmount__c,securedToTotalRatioAmount__c,X30_DPD_6_months__c,/*OTP V3 CR e*/id, No_of_Live_PL__c, Unsecured_Exposure__c, Written_Off_principal__c, Max_Secured_Loan_Amount__c, Max_unSecured_Loan_Amount__c, max_mob__c, Written_Off_principal9__c, Average_Total_Balance__c,Settlement1__c,
                                 Written_Off_principal8__c, Written_Off_principal7__c, Written_Off_principal6__c, Written_Off_principal5__c, Written_Off_principal4__c, Written_Off_principal3__c, Written_Off_principal2__c,
                                 Written_Off_principal29__c, Written_Off_principal28__c, Written_Off_principal27__c, Written_Off_principal26__c, Written_Off_principal25__c, Written_Off_principal24__c, Written_Off_principal23__c, Written_Off_principal22__c, Written_Off_principal21__c, Written_Off_principal20__c, Written_Off_principal1__c, Written_Off_principal19__c, Written_Off_principal18__c, Written_Off_principal17__c, Written_Off_principal16__c, Written_Off_principal15__c, Written_Off_principal14__c, Written_Off_principal13__c, Written_Off_principal12__c, Written_Off_principal11__c, Written_Off_principal10__c, Written_Off_and_settled_status__c, Written_Off_and_settled_status9__c, Written_Off_and_settled_status8__c, Written_Off_and_settled_status7__c, Written_Off_and_settled_status6__c, Written_Off_and_settled_status5__c, Written_Off_and_settled_status4__c, Written_Off_and_settled_status3__c, Written_Off_and_settled_status2__c, Written_Off_and_settled_status29__c, Written_Off_and_settled_status28__c, Written_Off_and_settled_status27__c, Written_Off_and_settled_status26__c, Written_Off_and_settled_status25__c, Written_Off_and_settled_status24__c, Written_Off_and_settled_status23__c, Written_Off_and_settled_status22__c, Written_Off_and_settled_status21__c, Written_Off_and_settled_status20__c, Written_Off_and_settled_status1__c, Written_Off_and_settled_status19__c, Written_Off_and_settled_status18__c, Written_Off_and_settled_status17__c, Written_Off_and_settled_status16__c, Written_Off_and_settled_status15__c, Written_Off_and_settled_status14__c, Written_Off_and_settled_status13__c, Written_Off_and_settled_status12__c, Written_Off_and_settled_status11__c, Written_Off_and_settled_status10__c, Write_Off__c, Bad_Track_Record__c, Tradelines_30plus_DPD__c, Total_Amount_overdue__c, Max_Lifetime_Delq__c, Ever_Write_off__c, Secured_Tradelines_90plus_DPD__c, No_Of_Live_Trades__c, Total_No_of_Trades__c, Unsecured_Tradelines_in_last_12m__c, First_Loan_MOB__c, Latest_Loan_MOB__c, Unsecured_to_total_ratio__c, Secured_to_unsecured_ratio__c, Unsecured_to_total_amount__c, OSB_to_loan_amount_unsecured__c, Credit_Card_utilization__c, Avg_unsecured_loan_amount__c, Unsecured_loan_balance__c, Total_Sanction_Amnt_unsecured__c, Total_Sanction_Amnt_secured__c, Max_Secured_MOB__c,
                                 Current_Obligation_All__c, Current_Obligation_Secured__c, Current_Obligation_unsecured__c, Enquiries_past_3_mnths__c, Unsecured_Enquiries_past_3_mnths__c, Current_Bal_on_all_cards__c, Total_no_of_loans_Excluding_CC__c, Highest_DPD_In_1_Year__c, X30_DPD_12_months__c, X30_DPD_3_months__c, Written_Off_Amount__c, Live_Gold_Loan_Amount__c, Total_no_of_secured_loans__c, X5000_amount_overdue__c, Number_of_Hl_Loans__c, Applicant__r.Applicant_Type__c
                                 /*SAL Policy Chnage Start*/
                                 , No_of_PL_Enq_in_Last_12_Months__c, No_of_PL_Enq_in_Last_6_Months__c, Sum_of_Amount_Overdue__c /*SAL Policy Chnage End*/
                                 from Cibil_Extension1__c where Applicant__c = : appObj.id limit 1
                                ];
            if (cibilExt1List != null && cibilExt1List.size() > 0) {
                cibext1 = cibilExt1List[0];
            }
            if(appObj != null)
                cibilExtLst = [SELECT /*24318 start */Ownership20__c, Ownership21__c, Ownership22__c, Ownership23__c, Ownership24__c, Ownership25__c, Ownership26__c, Ownership27__c, Ownership28__c, Ownership29__c,Date_Opened20__c,Date_Opened21__c,Date_Opened22__c,Date_Opened23__c,Date_Opened24__c,Date_Opened25__c,Date_Opened26__c,Date_Opened27__c,Date_Opened28__c,Date_Opened29__c,/*24318 stop *//*22017 s*/Sanction_Amount20__c,Sanction_Amount21__c,Sanction_Amount22__c,Sanction_Amount23__c,Sanction_Amount24__c,Sanction_Amount25__c,Sanction_Amount26__c,Sanction_Amount27__c,Sanction_Amount28__c,Sanction_Amount29__c,/*22017 e*/No_of_PL_Enq_in_Last_3_Months__c,Unsecured_to_Secured_ratio__c ,Suit_Filed__c,written_off_settled_status__c,Settlement_Status__c,     Asset_classification_view__c,EMI_bounce_3_months__c,EMI_bounce_6_months__c,Total_current_outstanding__c,X90_DPD_6_months__c,X30_DPD_CC__c,DPD_CC__c,X30_DPD_Gold_Loan__c,Account_Type20__c,Account_Type21__c,Account_Type22__c,Account_Type23__c,Account_Type24__c,Account_Type25__c,Account_Type26__c, 
                               Account_Type27__c,Account_Type28__c,Account_Type29__c,Applicant__c,Current_Balance20__c,Current_Balance21__c,Current_Balance22__c,Current_Balance23__c,
                               Current_Balance24__c,Current_Balance25__c,Current_Balance26__c,Current_Balance27__c,Current_Balance28__c,Current_Balance29__c
                               FROM CIBIL_Extension__c where Applicant__c =: appObj.id limit 1];
            
            if (cibilExtLst != null && cibilExtLst.size() > 0) {
                cibext = cibilExtLst[0];
            }
            /*if(appObj.Cibil_Extension1s__r != null && appObj.Cibil_Extension1s__r.size() > 0){
List<Cibil_Extension1__c> lstCibExt1 = appObj.Cibil_Extension1s__r;
if(lstCibExt1 != null && lstCibExt1.size() > 0)
cibext1 =  lstCibExt1[0]; 
}
if(appObj.Cibil_Extension__r != null && appObj.Cibil_Extension__r.size() > 0){
List<Cibil_Extension__c> lstCibExt = appObj.Cibil_Extension__r;
if(lstCibExt != null && lstCibExt.size() > 0)
cibext =  lstCibExt[0]; 
}*/
            
            Integer totalObligAmount = 0;
            Integer numberOfHLLoans = 0;
            String EverHLInCIBIL = 'NO';
            Set < String > ListOfHLprod = new Set < String > ();
            String everHLProducts = ATOSParameters__c.getValues('PLOCEverHLInCIBIL').Product__c;
            if (everHLProducts != null && everHLProducts != '') {
                for (String str: everHLProducts.split(',')) {
                    ListOfHLprod.add(str.ToUpperCase());
                }
            }
            system.debug('EverHLInCIBIL'+EverHLInCIBIL+ListOfHLprod);
            Decimal monthly_loan_obligations_unsec = 0.0;
            Decimal monthly_loan_obligations_sec = 0.0;
            ATOSParameters__c unsecured = new ATOSParameters__c();
            String UnsecuredLoans = '';
            unsecured = ATOSParameters__c.getValues('Unsecured');
            if (unsecured != null && unsecured.value__c != null) {
                unsecuredLoans = unsecured.value__c;
            }
            ATOSParameters__c secured = new ATOSParameters__c();
            secured = ATOSParameters__c.getValues('Secured');
            String securedLoans = '';
            if (secured != null && secured.value__c != null) {
                securedLoans = secured.value__c;
            }
            Decimal totalEMI = 0.0;
            Decimal unsec_exist_emi = 0.0;//24318
            for (Existing_Loan_Details__c exp: extLoanList) {
                /*22017 s*/
                if(exp.Obligation__c == 'Yes' && exp.Status__c == 'Live'){
                    //24318 start
                    if(unsecuredLoans.indexOf(exp.Loan_Type__c) != -1){
                        unsec_exist_emi+=exp.Final_EMI__c;
                    }
                    //24318 stop
                
                    if(exp.Loan_Type__c == 'Credit Card' || exp.Loan_Type__c == 'Overdraft'){
                        if(exp.POS__c != null){
                            Decimal val = (0.05*exp.POS__c);
                            system.debug('Loan type'+val);
                            totalEMI += val;
                        }
                    }
                    else{
                        if(exp.Final_EMI__c != null)
                            totalEMI += exp.Final_EMI__c;
                    }
                }
                /*22017 e*/
                system.debug('existing loan'+exp.Loan_Type__c+'--'+exp.POS__c+'--'+exp.EMI__c);
                if(unsecuredLoans.indexOf(exp.Loan_Type__c) != -1 && exp.Obligation__c == 'Yes'){
                    
                    if(exp.Loan_Type__c == 'Credit Card' || exp.Loan_Type__c == 'Overdraft'){
                        if(exp.POS__c != null){
                            Decimal val = (0.05*exp.POS__c);
                            system.debug('Loan type'+val);
                            monthly_loan_obligations_unsec += val;
                        }
                    }
                    else{
                        if(exp.Final_EMI__c != null)
                            monthly_loan_obligations_unsec += exp.Final_EMI__c;
                    }
                    
                }
                if(securedLoans.indexOf(exp.Loan_Type__c) != -1 && exp.Obligation__c == 'Yes'){
                    
                    if(exp.Loan_Type__c == 'Credit Card' || exp.Loan_Type__c == 'Overdraft'){
                        if(exp.POS__c != null){
                            Decimal val = (0.05*exp.POS__c);
                            system.debug('Loan type'+val);
                            monthly_loan_obligations_sec += val;
                        }
                    }
                    else{
                        if(exp.Final_EMI__c != null)
                            monthly_loan_obligations_sec += exp.Final_EMI__c;
                    }
                    
                }
                if (exp.Loan_Type__c != null && ListOfHLprod.contains(exp.Loan_Type__c.ToUpperCase())) {
                    EverHLInCIBIL = 'YES';
                }
                if (exp.Status__c == 'Live' && exp.Obligation__c == 'Yes' && exp.Financers__c != null && exp.Loan_Type__c != null && exp.Financers__c == 'Bajaj Finance Ltd' && (exp.Loan_Type__c == 'PL' || exp.Loan_Type__c.toLowerCase() == 'personal loan')) {
                    if (exp.POS__c != null)
                        
                        totalObligAmount = totalObligAmount + integer.valueof(exp.POS__c);
                }
                if ((exp.Loan_Type__c == 'HL' || exp.Loan_Type__c == 'Housing Loan' || exp.Loan_Type__c == 'Home Loan') && exp.Obligation__c == 'Yes') {
                    numberOfHLLoans = numberOfHLLoans + 1;
                }
            }
            system.debug('monthly_loan_obligations_sec pk'+ monthly_loan_obligations_unsec+'  '+monthly_loan_obligations_sec);
            Decimal Total_monthly_loan_obligations = 0.0;
            Total_monthly_loan_obligations = monthly_loan_obligations_unsec + monthly_loan_obligations_sec ;
            //22017 start
            MAP < String, String> mapOfRSParameters = new MAP < String, String>();
            mapOfRSParameters.put('cibil_Score',appObj.CIBIL_Score__c  != null ? appObj.CIBIL_Score__c  : '0');
            mapOfRSParameters.put('number_of_HL_Loans',cibext1 != null && cibext1.Number_of_Hl_Loans__c != null ? String.valueof(cibext1.Number_of_Hl_Loans__c)  : '0');
            mapOfRSParameters.put('noOfPLEnquiriesIn6M',cibext1.No_of_PL_Enq_in_Last_6_Months__c  != null ? String.valueof(cibext1.No_of_PL_Enq_in_Last_6_Months__c)  : '0');
            mapOfRSParameters.put('noOfPLEnquiriesIn12M',cibext1.No_of_PL_Enq_in_Last_12_Months__c  != null ? String.valueof(cibext1.No_of_PL_Enq_in_Last_12_Months__c)  : '0');
            
            
            Map<String,Object> segmentationResult = new Map<String, Object>();
            BRECallout breObj1 = new BRECallout(); 
            if (!Test.isRunningTest())
                segmentationResult = breObj1.callBRERisksSgmentation(mapOfRSParameters);
            if(!CommonUtility.isEmpty(segmentationResult))
            {
                Map<String,Object> riskmap = new map<String,Object>();
                riskmap = (Map<String,Object>)segmentationResult.get('Segment_Output');
                if(riskmap.get('riskSegmentClassification') != null && riskmap.get('riskSegmentClassification') != ''){
                    System.debug('pk result'+riskmap.get('riskSegmentClassification')); 
                    appObj.Risk_Segmentation__c = (String) riskmap.get('riskSegmentClassification');
                }
       if(!CommonUtility.isEmpty(accObj.flow__c) && accObj.flow__c=='Mobility V2' && !CommonUtility.isEmpty(oppObj.Product__c) && oppObj.Product__c=='RSL')
       {
           if(CommonUtility.isEmpty(oppObj.Sourcing_Channel__r.Channel_Category__c))
                appObj.Risk_Segmentation__c='';
           else{
           if(oppObj.Sourcing_Channel__r.Channel_Category__c=='Low Risk')appObj.Risk_Segmentation__c='LR';
           if(oppObj.Sourcing_Channel__r.Channel_Category__c=='Medium Risk')appObj.Risk_Segmentation__c='MR';
           if(oppObj.Sourcing_Channel__r.Channel_Category__c=='High Risk')appObj.Risk_Segmentation__c='HR';
           }
       }//if block for RSL only added for 22018
            }
            //22017 end
            if(oppObj.Product_Offerings__r != null && oppObj.Product_Offerings__r.size() > 0){
                
                List<Product_Offerings__c> lstPO = oppObj.Product_Offerings__r;
                if(lstPO != null && lstPO.size() > 0)
                    dss.POobj =  lstPO[0]; 
                dss.isPreapproved = true;
                upsert appObj;
                
            }
            
            else{
                system.debug('in else');
                dss.isPreapproved = false;
                Decimal totalEmpVintage = 0;
                if(accObj.Total_Work_Experience_Yrs__c != null)                
                    totalEmpVintage += Decimal.valueOf(accObj.Total_Work_Experience_Yrs__c);   
                if(accObj.Total_Work_Experience_Months__c != null)                                 
                    totalEmpVintage += (Decimal.valueof(accObj.Total_Work_Experience_Months__c)/12.0).setScale(2);   
                
                system.debug('accobj desig'+accObj.DesignationOTP__c);
                MAP < String, String> mapOfPolicyParameters = new MAP < String, String>();
                
                Decimal loanAmount = 0.0;
                /*22017 s*/
                String account_type_flag = 'No';
                String account_type='';
                String hlaccount_type='';
                String alaccount_type='';
                String placcount_type='';
                Integer hlMaxAmt = 0;
                Integer alMaxAmt = 0;
                Integer plMaxAmt = 0;
                Integer finalLoanAmt = 0;
                //24318 start
                mapOfPolicyParameters.put('loan_id',oppObj.Id);
                mapOfPolicyParameters.put('product',(oppObj != null && oppObj.Product__c != null) ? String.valueof(oppObj.Product__c) : ''); //22018
                mapOfPolicyParameters.put('branch_name', oppObj != null && oppObj.Branch_Name__c != null ? oppObj.Branch_Name__r.name : '');
                mapOfPolicyParameters.put('sub_industry',accObj.Employer__c != null && accObj.Employer__r.Sub_Industry__c != null ? accObj.Employer__r.Sub_Industry__c : '');
                mapOfPolicyParameters.put('system_designation',conObj.DesignationOTP__c != null ? conObj.DesignationOTP__c : '');//mapping
                mapOfPolicyParameters.put('total_employment_vintage',String.Valueof(totalEmpVintage));
                mapOfPolicyParameters.put('qualification',accObj.Qualification__c != null ? accObj.Qualification__c : '');
                mapOfPolicyParameters.put('institute_name',accObj.Type_of_Educational_Institution__c != null ? accObj.Type_of_Educational_Institution__c : '');
                mapOfPolicyParameters.put('company_name',appObj.Company_Name__c != null ? appObj.Company_Name__c : '');
                mapOfPolicyParameters.put('final_foir',camobj.Eligible_FOIR__c != null ?String.Valueof(camobj.Eligible_FOIR__c):'0');
                mapOfPolicyParameters.put('unsecured_foir',camobj.Unsecured_FOIR__c != null ?String.Valueof(camobj.Unsecured_FOIR__c):'0');
                mapOfPolicyParameters.put('monthly_loan_obligations',STring.valueof(Total_monthly_loan_obligations.setScale(2)));
                mapOfPolicyParameters.put('bajaj_loan_obligations','0');
                mapOfPolicyParameters.put('CIBIL_Score',appObj.CIBIL_Score__c  != null ? appObj.CIBIL_Score__c  : '0');
                mapOfPolicyParameters.put('number_of_HL_Loans',cibext1 != null && cibext1.Number_of_Hl_Loans__c != null ? String.valueof(cibext1.Number_of_Hl_Loans__c)  : '0');
                mapOfPolicyParameters.put('noOfPLEnquiriesIn6M',cibext1.No_of_PL_Enq_in_Last_6_Months__c  != null ? String.valueof(cibext1.No_of_PL_Enq_in_Last_6_Months__c)  : '0');
                mapOfPolicyParameters.put('noOfPLEnquiriesIn12M',cibext1.No_of_PL_Enq_in_Last_12_Months__c  != null ? String.valueof(cibext1.No_of_PL_Enq_in_Last_12_Months__c)  : '0');
                mapOfPolicyParameters.put('codified_cibil',appObj.Codified_CIBIL__c != null ? appObj.Codified_CIBIL__c  : '');//codified cibil CR
                mapOfPolicyParameters.put('cibil_type',(EverHLInCIBIL != null && EverHLInCIBIL == 'YES')?'THICK' :'THIN');
                mapOfPolicyParameters.put('company_category',(conObj != null && conObj.Employer__r != null && conobj.Employer__r.Company_Category__c != null)?conObj.Employer__r.Company_Category__c :'');
                mapOfPolicyParameters.put('securedUnsecuredRatio',(cibext != null && cibext.Unsecured_to_Secured_ratio__c!= null)? String.valueof(cibext.Unsecured_to_Secured_ratio__c)  : '0.0');
                mapOfPolicyParameters.put('cibil_pl_enq_3months',   (cibext != null && cibext.No_of_PL_Enq_in_Last_3_Months__c   != null)? String.valueof(cibext.No_of_PL_Enq_in_Last_3_Months__c ) : '0');
                mapOfPolicyParameters.put('cibil_pl_enq_6months',(cibext1 != null && cibext1.No_of_PL_Enq_in_Last_6_Months__c   != null)? String.valueof(cibext1.No_of_PL_Enq_in_Last_6_Months__c )  : '0');
                mapOfPolicyParameters.put('loan_amount','0');//mapping
                mapOfPolicyParameters.put('affluence',(accobj!= null && accobj.Area_Locality__r != null && accobj.Area_Locality__r.Affluence__c!= null)?accobj.Area_Locality__r.Affluence__c:'');
                mapOfPolicyParameters.put('dob',(accobj!= null && accobj.Date_of_Birth__c != null ?String.valueof(accobj.Date_of_Birth__c):'')); 
                mapOfPolicyParameters.put('monthly_loan_obligations_unsec',String.valueof(monthly_loan_obligations_unsec.setScale(2)));
                mapOfPolicyParameters.put('applicable_foir',camObj != null && camobj.Applicable_FOIR1__c != null ?String.valueof(camobj.Applicable_FOIR1__c):'0'); 
                mapOfPolicyParameters.put('monthly_salary',accObj.Gross_Salary_Turn_Over__c  != null ? String.valueof(accObj.Gross_Salary_Turn_Over__c)  : '0');
                mapOfPolicyParameters.put('existing_loan_EMI',String.valueof(totalEMI.setScale(2)));//mapping
                mapOfPolicyParameters.put('assumed_loan_amt','0');//mapping
                mapOfPolicyParameters.put('unsecured_existing_loan_EMI',String.valueOf(unsec_exist_emi.setScale(2)));
                //24318 stop
                
                
                //24318 start
                List<Map<String,String>> accLst = new List<Map<String,String>>();
                Map<String,String> firstMap = new Map<String,String>();
                
                
                if(cibilobj.Account_Type__c != null && cibilobj.Account_Type__c != '' && cibilobj.Account_Type__c != 'NO DATA'){
                        
                        if(homeSt.contains(((String)cibilobj.Account_Type__c).toUpperCase())){
                            /*if(cibilobj.Sanction_Amount__c > hlMaxAmt){
hlMaxAmt = Integer.valueof(cibilobj.Sanction_Amount__c);
hlaccount_type = cibilobj.Account_Type__c;
}*/                         account_type_flag = 'Yes';       
                            if(cibilobj.Account_Type__c != 'LAP')
                                firstMap.put('account_type','HL');
                            else
                                firstMap.put('account_type','LAP');                                                        
                            
                        }
                        else if(autoSt.contains(((String)cibilobj.Account_Type__c).toUpperCase())){
                            account_type_flag = 'Yes';
                            firstMap.put('account_type','AL');
                            
                        }
                        else if(perSt.contains(((String)cibilobj.Account_Type__c).toUpperCase())){
                            account_type_flag = 'Yes';
                            firstMap.put('account_type','PL');
                        }
                        else if(busSt.contains(((String)cibilobj.Account_Type__c).toUpperCase())){
                            account_type_flag = 'Yes';
                            firstMap.put('account_type','BL');
                            
                        }
                        if(cibilobj.Date_Opened__c != null){
                            firstMap.put('loan_start_date',String.valueof(cibilobj.Date_Opened__c));
                        }
                        else
                            firstMap.put('loan_start_date','');
                        
                        firstMap.put('ownership_type',cibilobj.Ownership__c);
                        firstMap.put('loan_amount',String.valueof(cibilobj.Sanction_Amount__c));
                        
                        if(securedLoans != '' && securedLoans.indexOf(cibilobj.Account_Type__c) != -1)
                            firstMap.put('secured_OR_unsecured','secured');
                        else 
                            firstMap.put('secured_OR_unsecured','unsecured');
                        
                        if(!firstMap.isEmpty() && firstMap.get('account_type') != null && firstMap.get('account_type') != '')
                        accLst.add(firstMap); 
                        
                    /*else if(cibilobj.Account_Type__c == 'Auto Loan'){
if(cibilobj.Sanction_Amount__c > alMaxAmt){
alMaxAmt = Integer.valueof(cibilobj.Sanction_Amount__c);
alaccount_type = cibilobj.Account_Type__c;
}
}
else if(cibilobj.Account_Type__c == 'Personal Loan' || cibilobj.Account_Type__c == 'PL'){
if(cibilobj.Sanction_Amount__c > plMaxAmt){
plMaxAmt = Integer.valueof(cibilobj.Sanction_Amount__c);
placcount_type = cibilobj.Account_Type__c;
}
}*/
                } 
                
                
                for(integer j=1;j<=19;j++){
                    String accType= 'Account_Type'+j+'__c';
                    String sancAmt = 'Sanction_Amount'+j+'__c';
                    String dateopened = 'Date_Opened'+j+'__c';//24318
                    String ownership = 'Ownership'+j+'__c';//24318
                    Map<String,String> accMap = new Map<String,String>();//24318
                    
                    if(cibilobj.get(accType) != null && cibilobj.get(accType) != '' && cibilobj.get(accType) != 'NO DATA'){
                        SYstem.debug('account  '+autoSt.contains(((String)cibilobj.Account_Type__c).toUpperCase()));
                        System.debug(cibilobj.get(accType));
                        if(homeSt.contains(((String)cibilobj.get(accType)).toUpperCase())){
                            /*if(Integer.valueof(cibilobj.get(sancAmt)) > hlMaxAmt){
hlMaxAmt = Integer.valueof(cibilobj.get(sancAmt));
hlaccount_type = (String)cibilobj.get(accType);
}*/
                            account_type_flag = 'Yes';
                            if(cibilobj.get(accType) != 'LAP')
                                accMap.put('account_type','HL');
                            else
                                accMap.put('account_type','LAP'); 
                            
                            
                        }
                        else if(autoSt.contains(((String)cibilobj.get(accType)).toUpperCase())){
                            /*if(Integer.valueof(cibilobj.get(sancAmt)) > alMaxAmt){
alMaxAmt = Integer.valueof(cibilobj.get(sancAmt));
alaccount_type = (String)cibilobj.get(accType);
}*/
                            account_type_flag = 'Yes';
                            accMap.put('account_type','AL');
                        }
                        else if(perSt.contains(((String)cibilobj.get(accType)).toUpperCase())){
                            /*if(Integer.valueof(cibilobj.get(sancAmt)) > plMaxAmt){
plMaxAmt = Integer.valueof(cibilobj.get(sancAmt));
placcount_type = (String)cibilobj.get(accType);
}*/
                            account_type_flag = 'Yes';
                            accMap.put('account_type','PL');
                        }
                        else if(busSt.contains(((String)cibilobj.get(accType)).toUpperCase())){
                            System.debug('here ');
                            account_type_flag = 'Yes';
                            accMap.put('account_type','BL');
                        }
                        if(cibilobj.get(dateopened) != null){
                            DateTime openDate = (DateTime)cibilobj.get(dateopened);
                            accMap.put('loan_start_date',String.valueof(date.newinstance(openDate.year(), openDate.month(), openDate.day())));
                        }
                     
                            accMap.put('ownership_type',String.valueof(cibilobj.get(ownership)));
                            accMap.put('loan_amount',String.valueof(cibilobj.get(sancAmt)));
                            if(cibilobj.get(accType) != null && securedLoans != '' && securedLoans.indexOf((String)cibilobj.get(accType)) != -1)
                                accMap.put('secured_OR_unsecured','secured');
                            else 
                                accMap.put('secured_OR_unsecured','unsecured');
                            
                            if(!accMap.isEmpty() && accMap.get('account_type') != null && accMap.get('account_type') != '')
                                accLst.add(accMap);
                                                  
                    }
                }  
                for(integer j=20;j<=29;j++){
                    String accType= 'Account_Type'+j+'__c';
                    String sancAmt = 'Sanction_Amount'+j+'__c';
                    String dateopened = 'Date_Opened'+j+'__c';//24318
                    String ownership = 'Ownership'+j+'__c';//24318
                    Map<String,String> accMap = new Map<String,String>();//24318
                    
                    if(cibExt.get(accType) != null && cibExt.get(accType) != '' && cibExt.get(accType) != 'NO DATA'){  
                        if(homeSt.contains((String)cibExt.get(accType))){
                            account_type_flag = 'Yes';
                            /* if(Integer.valueof(cibExt.get(sancAmt)) > hlMaxAmt){
hlMaxAmt = Integer.valueof(cibExt.get(sancAmt));
hlaccount_type = (String)cibExt.get(accType);
}*/
                            if(cibExt.get(accType) != 'LAP')
                                accMap.put('account_type','HL');
                            else
                                accMap.put('account_type','LAP'); 
                            
                        }
                        else if(autoSt.contains(((String)cibExt.get(accType)).toUpperCase())){
                            account_type_flag = 'Yes';
                            /*if(Integer.valueof(cibExt.get(sancAmt)) > alMaxAmt){
alMaxAmt = Integer.valueof(cibExt.get(sancAmt));
alaccount_type = (String)cibExt.get(accType);
}*/
                            accMap.put('account_type','AL');
                        }
                        else if(perSt.contains(((String)cibExt.get(accType)).toUpperCase())){
                            account_type_flag = 'Yes';
                            /*if(Integer.valueof(cibExt.get(sancAmt)) > plMaxAmt){
plMaxAmt = Integer.valueof(cibExt.get(sancAmt));
placcount_type = (String)cibExt.get(accType);
}*/
                            accMap.put('account_type','PL');
                        }
                        else if(busSt.contains(((String)cibExt.get(accType)).toUpperCase())){
                            account_type_flag = 'Yes';
                            accMap.put('account_type','BL');
                        }
                        
                        
                        if(cibExt.get(dateopened) != null){
                            DateTime openDate = (DateTime)cibExt.get(dateopened);
                            accMap.put('loan_start_date',String.valueof(date.newinstance(openDate.year(), openDate.month(), openDate.day())));
                        }
                       
                            accMap.put('ownership_type',(String)cibExt.get(ownership));
                            accMap.put('loan_amount',String.valueof(cibExt.get(sancAmt)));
                            if(cibExt.get(accType) != null && securedLoans != '' && securedLoans.indexOf((String)cibExt.get(accType)) != -1)
                                accMap.put('secured_OR_unsecured','secured');
                            else 
                                accMap.put('secured_OR_unsecured','unsecured');
                            
                            if(!accMap.isEmpty() && accMap.get('account_type') != null && accMap.get('account_type') != '')
                                accLst.add(accMap);
                                                  
                    }
                }
                
                mapOfPolicyParameters.put('account_Details',JSON.serialize(accLst));
                System.debug('accLst '+accLst);
                /*if(hlMaxAmt != 0){
finalLoanAmt = hlMaxAmt;
account_type = hlaccount_type;
}
else if(alMaxAmt != 0){
finalLoanAmt = alMaxAmt;
account_type = alaccount_type ;
}
else if(plMaxAmt != 0){
finalLoanAmt = plMaxAmt;
account_type = placcount_type ;
}
System.debug('pk cibil score'+appObj.CIBIL_Score__c );
mapOfPolicyParameters.put('monthly_loan_obligations',String.valueof(Total_monthly_loan_obligations.setScale(2)));*/
                
                
                
                //mapOfPolicyParameters.put('monthly_loan_obligations',String.valueof(totalEMI.setScale(2)));
                mapOfPolicyParameters.put('account_type',account_type);
                mapOfPolicyParameters.put('account_type_flag',account_type);
                
                
                /*22017 e*/
                mapOfPolicyParameters.put('call_type','ELIGIBILITY');
                
                
                
                mapOfPolicyParameters.put('application_source',oppObj.Application_Source__c != null ? oppObj.Application_Source__c : ''); //22624 Sprint 5C
                mapOfPolicyParameters.put('customer_segment',appObj.Risk_Segmentation__c  != null ? appObj.Risk_Segmentation__c  : '');
                system.debug('pl enq 6'+cibext1.No_of_PL_Enq_in_Last_6_Months__c);
                system.debug('affluence'+accobj.Area_Locality__r.Affluence__c);
                
                mapOfPolicyParameters.put('sanctioned_loan_amount',String.valueof(finalLoanAmt));
                //24318 stop
                
                Map<String,Object> dynOfferResult = new Map<String, Object>();
                BRECallout breObj = new BRECallout(); 
                if (!Test.isRunningTest())
                    dynOfferResult = breObj.callBREDynamicOffer(mapOfPolicyParameters);
                else{
                    String output = '{"sal002_output":"ELIGIBILITY","Eligibility":{"loanId":null,"eligible_loan_amount":0,"riskSegmentClassification":"VHR","offer_roi":11.7800,"offer_tenor":60,"offer_emi":0,"offer_pf":1.5,"monthly_income":0.00000000000000000000}}';
                    dynOfferResult = (Map<String,Object>)JSON.deserializeUnTyped(output);
                }
                Map < String, Object > offerGeneratedMap = new Map < String, Object > ();
                if (dynOfferResult != null) {
                    
                    
                    /*Bug 20939 s*/
                    List < SOL_Policy__c > policyList = new List < SOL_Policy__c > ();
                    SOL_Policy__c  SolObj = new  SOL_Policy__c ();
                    policyList = [select id, Policy_Name__c,New_Address_Value__c ,Old_Address_Value__c,Policy_Status__c,Loan_Application__c,Checklist_Policy_Status__c, Applicant_Name__c from SOL_Policy__c where Loan_Application__c = : oppObj.Id AND Name LIKE 'Sales2.0 Dynamic Offer Amount' limit 1];
                    if(!CommonUtility.isEmpty(policyList) && policyList[0].Policy_Name__c.contains('Dynamic Offer Amount')){
                        SolObj = policyList[0];
                    }
                    else{
                        SolObj = new SOL_Policy__c();
                        SolObj.Name = 'Sales2.0 Dynamic Offer Amount';
                        SolObj.Policy_Name__c = 'Dynamic Offer Amount';
                        SolObj.Loan_Application__c = oppObj.Id;
                        SolObj.Applicant_Name__c = appObj.Id;
                        //SolObj.Old_Address_Value__c = dynOfferResult;
                        
                    }
                    SolObj.RetriggerBRE__c = false;
                    
                    
                    upsert SolObj;
                    triggeredBRE.add('Dynamic Offer Amount'); /*Bug 20939 e*/
                    if(dynOfferResult.get('Eligibility') != null && dynOfferResult.get('Eligibility') != '')
                        offerGeneratedMap = (Map < String, Object > ) dynOfferResult.get('Eligibility');
                    if(offerGeneratedMap.get('eligible_loan_amount') != null && offerGeneratedMap.get('eligible_loan_amount') != ''){
                        system.debug('offerGeneratedMap'+offerGeneratedMap.get('eligible_loan_amount'));
                        Decimal offAmt = (Decimal)offerGeneratedMap.get('eligible_loan_amount');
                        offerAmt = oppObj.Offer_Amount__c;
                        oppObj.Offer_Amount__c = offAmt.setScale(2);
                        //appObj.Risk_Segmentation__c = (String)offerGeneratedMap.get('riskSegmentClassification');
                    }
                    //Rohit added for tenor and roi mapping start
                    
                    Boolean isCamChanged  = false;
                    if(offerGeneratedMap.get('offer_roi') != null ){
                        oppObj.Approved_Rate__c = (Decimal)offerGeneratedMap.get('offer_roi');  
                        oppObj.Requested_ROI__c = (Decimal)offerGeneratedMap.get('offer_roi');  
                        System.debug('in offer roi ');
                        if(camObj != null ){            
                            isCamChanged = true;
                            camObj.ROI__c = (Decimal)offerGeneratedMap.get('offer_roi'); 
                        }   
                        else
                            camObj.ROI__c = (Decimal)offerGeneratedMap.get('offer_roi'); 
                        
                    }
                    System.debug('monthly_income pk1'+offerGeneratedMap.get('monthly_income'));
                    if(offerGeneratedMap.get('monthly_income') != null ){
                        if(camObj != null ){            
                            isCamChanged = true;
                            System.debug('monthly_income pk2'+offerGeneratedMap.get('monthly_income'));
                            camObj.Monthly_Reimbursement__c = (Decimal)offerGeneratedMap.get('monthly_income');
                            camObj.Average_Monthly_Net_Income1__c = (Decimal)offerGeneratedMap.get('monthly_income'); 
                            system.debug('before insert'+camObj.Average_Monthly_Net_Income1__c);
                        } 
                        else
                        {   
                            camObj.Average_Monthly_Net_Income1__c = (Decimal)offerGeneratedMap.get('monthly_income');  
                            camObj.Monthly_Reimbursement__c = (Decimal)offerGeneratedMap.get('monthly_income');
                        }                      
                    }
                    if(offerGeneratedMap.get('offer_tenor') != null ){
                        oppObj.Approved_Tenor__c = (Decimal)offerGeneratedMap.get('offer_tenor');   
                        oppObj.Tenor__c = (Decimal)offerGeneratedMap.get('offer_tenor');    
                        System.debug('in offer tenor ');
                        if(camObj != null ){        
                            isCamChanged = true;
                            camObj.Tenor__c = (Decimal)offerGeneratedMap.get('offer_tenor');                    
                        }    
                        else
                            camObj.Tenor__c = (Decimal)offerGeneratedMap.get('offer_tenor');      
                    }
                    
                    // Priyanka added for offer emi ,processing fees and final PF start
                    system.debug('offerGeneratedMap=='+offerGeneratedMap);
                    if(offerGeneratedMap.get('offer_emi') != null ){
                        oppObj.EMI_CAM__c = (Decimal)offerGeneratedMap.get('offer_emi');  
                        System.debug('in offer emi ');
                        if(camObj != null ){        
                            isCamChanged = true;
                            camObj.EMI_on_Proposed_Loan_TO__c = (Decimal)offerGeneratedMap.get('offer_emi');                    
                        } 
                        else
                            camObj.EMI_on_Proposed_Loan_TO__c = (Decimal)offerGeneratedMap.get('offer_emi');        
                    }
                    if(offerGeneratedMap.get('offer_pf') != null ){
                        oppObj.Processing_Fees__c = (Decimal)offerGeneratedMap.get('offer_pf');     
                        System.debug('in offer pf '+oppObj.Processing_Fees__c);
                        
                    }
                    // Priyanka added for offer emi ,processing fees and final PF end
                    /*221017 s*/
                    if(offerGeneratedMap.get('max_eligibility_as_per_foir') != null ){
                        camObj.LAP_EMI__c = (Decimal)offerGeneratedMap.get('max_eligibility_as_per_foir');
                    }
                    if(offerGeneratedMap.get('unsec_foir') != null ){
                        camObj.Unsecured_FOIR__c = (Decimal)offerGeneratedMap.get('unsec_foir');
                    }
                    if(offerGeneratedMap.get('final_foir') != null ){
                        camObj.Eligible_FOIR__c = (Decimal)offerGeneratedMap.get('final_foir');
                    }
                    /*221017 e*/
                    update oppObj;
                    update appObj;
                    
                    //CR for sol policy start
                    policyList = [select id, Policy_Name__c,New_Address_Value__c ,Old_Address_Value__c,Policy_Status__c,Loan_Application__c,Checklist_Policy_Status__c, Applicant_Name__c,Old_Loan_Application__c from SOL_Policy__c where Loan_Application__c = : oppObj.Id AND Name LIKE 'Sales2.0 Dynamic Offer Amount' limit 1];
                    if(!CommonUtility.isEmpty(PolicyList)){
                        Sol_Policy__c sol = PolicyList[0];
                        Map<String,String> offerChMap = new Map<String,String>();
                        offerChMap.put('NewValue',String.valueOf(oppObj.Offer_Amount__c));
                        offerChMap.put('OldValue',offerAmt != null ? String.valueOf(offerAmt) : '0');
                        sol.Old_Address_Value__c = JSON.serialize(offerChMap);
                        update sol;
                        
                        
                    }
                    //CR for sol ploicy stop
                }
                
                
            }
            /*22017 s*/
            camObj.Average_incentive_for_Q1__c = accObj.Gross_Salary_Turn_Over__c;
            camObj.Average_incentive_for_Q2__c = accObj.Gross_Salary_Turn_Over__c;
            camObj.Average_incentive_for_Q3__c = accObj.Gross_Salary_Turn_Over__c;
            if (camObj.Average_incentive_for_Q1__c != null && camObj.Average_incentive_for_Q2__c != null && camObj.Average_incentive_for_Q3__c != null) camObj.Construction_Valuation_1__c = ((camObj.Average_incentive_for_Q1__c + camObj.Average_incentive_for_Q2__c + camObj.Average_incentive_for_Q3__c) / 3).round(system.roundingMode.CEILING);
            if (camObj.Average_incentive_for_Q1__c == null && camObj.Average_incentive_for_Q2__c == null && camObj.Average_incentive_for_Q3__c == null) camObj.Construction_Valuation_1__c = 0;
                 
            /*22017 e*/
            camObj.Proposed_Loan_Amt__c = oppObj.Offer_Amount__c;
            camObj.Loan_Application__c = oppObj.Id;
            camObj.Applicant__c = appObj.Id;
            camObj.Type_of_CAM_Entity__c = 'Salaried';
            system.debug('dss.objCon'+dss.objCon);
            dss.objCon=conObj;
            system.debug('dss.objCon1'+dss.objCon);
            
            if(dss.objCon != null)
                camObj.Type_Cust__c = dss.objCon.Customer_Type__c;
            system.debug('camObj'+camObj);
            upsert camObj;
            system.debug('after insert'+camObj.Average_Monthly_Net_Income1__c);
            system.debug('camObj'+camObj);
            dss.camObj = camObj;
            dss.opp = oppObj;
            dss.applicantPrimary = appObj;
            dss.status = 'success';  /*Bug 20939*/
        }catch(exception e)
        {
            System.debug('exception'+e.getLineNumber()+e.getStackTraceString());
            return null;
        }
        return JSON.serialize(dss);
    }
    /*Sales 2.0 added by Krish e*/
    
    public static String getOppLandingDetails(String oppId){
        oppData dss = new oppData (); 
        getAllData(oppId,dss);
        system.debug('JSON.serialize(dss)>>'+JSON.serialize(dss));
        return JSON.serialize(dss);
    }
    //Hrushikesh - Re-Trigger Dedupe button on Demographic Cmp.
    public static void retriggerDedupe(String oppId){
        List<De_Dupe__c> dedupeobj=[SELECT  id FROM De_Dupe__c WHERE Loan_Application__c=:oppId ];
        
        /*   
List<Contact> contactobj=[SELECT id FROM Contact WHERE Loan_Application__c=:oppId AND ApplicantType__c='Primary'];
List<Applicant__c> primaryApplicantobj=[SELECT id FROM Applicant__c WHERE Loan_Application__c=:oppId AND Applicant_Type__c='Primary'];
List<Opportunity> opportunity =[SELECT id FROM Opportunity where id =:oppId]; */
        
        oppData dss = new oppData (); 
        getAllData(oppId,dss);
        
        System.debug('Dedupe Query '+dss.objCon);
        System.debug('Contact Query '+dss.applicantPrimary);
        System.debug('Applicant Query '+dss.opp);
        
        if(!CommonUtility.isEmpty(dedupeobj)){
            try {
                delete dedupeobj;
            } catch (DmlException e) {
                System.debug('Exception in retriggerDedupeFunction '+e.getMessage());   
            }
            System.debug('savepoint1');
            
        }
        try{
            /*Bug 20939 s*/
            if(dss.applicantPrimary.Loan_Application__r.Account.Flow__c == 'Mobility V2'){
                
                GeneralUtilities.reTriggerBRE(dss.applicantPrimary,'Dedupe'); //Retrigger BRE added by Priya
                
                
            }
            /*Bug 20939 e*/
            DedupeService.insertDedupeSource(dss.objCon, dss.applicantPrimary, dss.opp);
        }catch(Exception e){
            System.debug('Exception in retriggerDedupeFunction2 '+e.getMessage());   
        }
    }
    
    //Income Details Section Methods Start
    //https://opfocus.com/json-deserialization-techniques-in-salesforce/
    public static String saveIncomeDetails(String newCam,String newApplicant,String myid) {
        OppData dss = new OppData();
        System.debug('inSAVEINCOMEMETHOD '+newCam+newApplicant);  
        CAM__c cam = (CAM__c)JSON.deserialize(newCam,CAM__c.class);
        Applicant__c applicant = (Applicant__c)JSON.deserialize(newApplicant,Applicant__c.class);
        System.debug('here hello');
        cam.Loan_Application__c=myid;
        applicant.Loan_Application__c=myid;
        try{
            upsert cam; 
            upsert applicant;
            List<CAM__c>  camList = [select Business_Continuty__c,Average_incentive_for_Q1__c,EMI_on_Proposed_Loan_TO__c,Average_incentive_for_Q3__c,Average_incentive_for_Q2__c,Maxi_EMI_Cust__c,Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c,Id,Proposed_Loan_Amt__c, ROI__c, Tenor__c, EMI_of_The_Loan__c, sal_max_loan__c,Eligible_FOIR__c,Receips5_Doc__c,Receips6_Doc__c,Unsecured_FOIR__c, Applicable_FOIR1__c, Loan_Application__c,Average_Monthly_Net_Income1__c,Net_Salary_for_Month1__c,Monthly_Reimbursement__c,Avg_mthly_incntve_3mts__c,Rental_Income__c,Receips4_Doc__c,Existing_HL_EMI__c,Total_Mthly_Oblig__c,EMI__c,Net_Salary_for_Month2__c,Net_Salary_for_Month3__c,Eligible_Loan__c,Month1_Doc__c,Month2_Doc__c,Month3_Doc__c,LAP_pmt__c,Avg_monthly_incentive1__c,Avg_monthly_incentive2__c,Avg_monthly_incentive3__c,Incentive_Monthly_or_Quarterly__c,LAP_EMI__c from cam__c where Loan_Application__c = : myid];
            if(!CommonUtility.isEmpty(camList)){
                cam = camList[0];
            }
            dss.camObj=cam;
            dss.currApp=applicant;
            return JSON.serialize(dss);       
            
            
        }catch(Exception e)
        { System.debug('Exception '+e.getMessage()+e.getLineNumber());}
        return JSON.serialize(dss);       
    } 
    
    public static CAM__c loadAverage(String myid) {
        CAM__c cam = new CAM__c();
        if(!CommonUtility.isEmpty(myid) ){
            List<CAM__c>  camList = [select id,Business_Continuty__c,Monthly_Reimbursement__c,EMI_on_Proposed_Loan_TO__c,Avg_mthly_incntve_3mts__c,Rental_Income__c,Receips4_Doc__c,Existing_HL_EMI__c,Month1_Doc__c,Month2_Doc__c,Month3_Doc__c,LAP_pmt__c,Avg_monthly_incentive1__c,Avg_monthly_incentive2__c,Avg_monthly_incentive3__c,Incentive_Monthly_or_Quarterly__c,LAP_EMI__c from cam__c where Loan_Application__c = : myid];
            if(!CommonUtility.isEmpty(camList)){
                cam = camList[0];
            }
        }
        return cam;
    }
    
    public static Applicant__c loadApplicant(String myid) {
        Applicant__c app = new Applicant__c();
        if(!CommonUtility.isEmpty(myid) ){
            List<Applicant__c> applist   = [select id,LTA_Medical__c,Proof_of_Registered_Address_Submitted__c,LTA_Frequency__c from Applicant__c where Loan_Application__c = : myid  AND Applicant_Type__c = 'Primary'];
            if(!CommonUtility.isEmpty(applist)){
                app=applist[0];
                
            }
        }
        return app;
        
        
    }
    
    
    public static String fetchPicklistData(List<String> fieldList){
        Cam__c acc = new Cam__c();
        Map<String,List<String>> valuesMap = new Map<String,List<String>>();
        
        List<String> picValues = new List<String>();
        for(String str : fieldList){
            picValues = new List<String>();
            Schema.sObjectType objType = acc.getSObjectType();
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
            Map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
            List <Schema.PicklistEntry> values = fieldMap.get(str).getDescribe().getPickListValues();
            for (Schema.PicklistEntry a : values) 
            {
                picValues.add(a.getValue());
            }
            if(picValues != null)
                valuesMap.put(str,picValues);   
        }
        SYstem.debug('values in APex '+valuesMap);
        return JSON.serialize(valuesMap);       
        
    }
    
    public static CAM__c updateCam(String camObj,String accObj,String appObj) {//change parameters for 22017
        String oppId;
        CAM__c cam = new CAM__c();
        Account acc = new Account();
        Applicant__c app  =new Applicant__c();
        if(cam != null)
            cam = (CAM__c)JSON.deserialize(camObj ,CAM__c.class);
        if(accObj != null)
            acc = (Account)JSON.deserialize(accObj,Account.class);
        if (!CommonUtility.isEmpty(appObj))//changed for 22017
            app = (Applicant__c)JSON.deserialize(appObj,Applicant__c.class);
        try{
            if(cam != null)
            {
                upsert cam;
                oppId=cam.Loan_Application__c;
            }
            if(accObj != null && acc != null)
            {
                upsert acc;
            }
            if(!CommonUtility.isEmpty(appObj) && !CommonUtility.isEmpty(app))//added for 22017
                upsert app;
            /*22182 s*/
            if(oppId!=null)
            {
                List<Opportunity> oppList=[select id,EMI_CAM__c,Scheme_Master__c,Approved_Tenor__c,Approved_Rate__c,Loan_Amount_with_Premium__c,Scheme_Master__r.IsHybridFlexi__c from Opportunity where id =: oppId ];
                Opportunity loan=oppList[0];
                Applicant__c applicantprimary=[select id,Pure_Flexi_Period__c,Drop_Line_Flexi_Period__c,Pure_Flexi_EMI__c from Applicant__c where Loan_Application__c =: oppId AND Applicant_Type__c ='Primary' ];
                
                String emiVal = SAL_PricingCtrlV2.calculateEMIValue(Loan,applicantPrimary); //22182
                if(emiVal != null){
                    Loan.EMI_CAM__c = Decimal.valueof(emiVal); //22182
                    if(!CommonUtility.isEmpty(loan.Scheme_Master__c) && !CommonUtility.isEmpty(loan.Scheme_Master__r.IsHybridFlexi__c) && loan.Scheme_Master__r.IsHybridFlexi__c == true)
                        applicantPrimary.Pure_Flexi_EMI__c =  ((Loan.Loan_Amount_with_Premium__c *Loan.Approved_Rate__c) / 1200);
                }
                update applicantPrimary;
                update Loan;
            }
            /*22182 e*/
        }
        catch(Exception e){
            System.debug('Error occured while updating Cam'+e+ e.getLineNumber());
            return null;
        }
        return cam;
    }
    public static String updateCamAndOppMethod(String camObj,String oppObj) {
        oppData dss = new oppData();
        CAM__c cam = new CAM__c();
        cam = (CAM__c)JSON.deserialize(camObj ,CAM__c.class);
        Opportunity Loan = new Opportunity();
        Loan = (Opportunity)JSON.deserialize(oppObj ,Opportunity.class);
        System.debug('loan + cam pk'+cam+'loan'+Loan);
        List<Existing_Loan_Details__c> extLoanList = new List<Existing_Loan_Details__c>();
        extLoanList = [select id,Status__c,Obligation__c,Secured_Unsecured__c,Financers__c,Loan_Type__c,POS__c,EMI__c from Existing_Loan_Details__c where Loan_Application__c =: Loan.id];
        
        String SegmentProduct = '';
        String product = Loan.Product__c;
        String securedLoans = '';
        String SegmentSecuredProduct = '';
        String UnsecuredLoans = '';
        String SegmentUnsecuredProduct = '';
        double secamtsum, securedFOIR, creditCardAmt, OverDraft, overdraftAmt,percentValueOfCredit,emiValOfMin,percentValueOfdraft,UnsecuredCredit;
        secamtsum = 0;
        creditCardAmt = 0;
        securedFOIR = 0;
        OverDraft = 0;
        overdraftAmt = 0;
        percentValueOfCredit  = 0.0;
        emiValOfMin = 0.0;
        percentValueOfdraft=0.0;
        UnsecuredCredit = 0.0;
        ATOSParameters__c SegmentProducts = new ATOSParameters__c();
        SegmentProducts = ATOSParameters__c.getValues('SegmentationProducts');
        
        if (SegmentProducts != null && SegmentProducts.Product__c != null) {
            SegmentProduct = SegmentProducts.Product__c;
        }
        ATOSParameters__c secured = new ATOSParameters__c();
        secured = ATOSParameters__c.getValues('SegmentationSecuredLoan');
        
        if (secured != null && secured.value__c != null && secured.Product__c != null) {
            securedLoans = secured.value__c;
            SegmentSecuredProduct = secured.Product__c;
        }
        
        ATOSParameters__c Unsecured = new ATOSParameters__c();
        Unsecured = ATOSParameters__c.getValues('SegmentationUnSecuredLoan');
        
        
        if (Unsecured != null && Unsecured.value__c != null && Unsecured.Product__c != null) {
            UnsecuredLoans = Unsecured.value__c;
            SegmentUnsecuredProduct = Unsecured.Product__c;
        }
        
        System.debug('extLoanList pk'+extLoanList);
        if (!CommonUtility.isEmpty(extLoanList)){
            for (Existing_Loan_Details__c exp: extLoanList) {
                
                if (Product != null && SegmentProduct != null && SegmentProduct.ToUpperCase().contains(product.ToUppercase())) {
                    
                    if (securedLoans.indexOf(exp.Loan_Type__c) != -1 && SegmentSecuredProduct.indexOf(Loan.Product__c) != -1) {
                        if (exp.Status__c == 'Live' && exp.EMI__c != null)
                            securedFOIR += exp.EMI__c;
                    }
                    if (UnsecuredLoans.indexOf(exp.Loan_Type__c) != -1 && SegmentUnsecuredProduct.indexOf(Loan.Product__c) != -1) {
                        if (exp.Status__c == 'Live' && exp.EMI__c != null)
                            secamtsum += exp.EMI__c;
                    }
                } else {
                    if (exp.Secured_Unsecured__c == 'Unsecured' && exp.Status__c == 'Live') {
                        if (exp.EMI__c != null) secamtsum += exp.EMI__c;
                    }
                    if (exp.Secured_Unsecured__c == 'Secured' && exp.Status__c == 'Live') {
                        if (exp.EMI__c != null) securedFOIR += exp.EMI__c;
                    }
                    if (exp.Loan_Type__c == 'Credit Card' && exp.Status__c == 'Live' && exp.Obligation__c == 'Yes') {
                        if (exp.POS__c != null) creditCardAmt += exp.POS__c;
                    }
                    if (exp.Loan_Type__c == 'Overdraft' && exp.Status__c == 'Live' && exp.Obligation__c == 'Yes') {
                        if (exp.POS__c != null) overdraftAmt += exp.POS__c;
                    }
                }
            }
        }
        if (creditCardAmt != null) {
            percentValueOfCredit = Decimal.valueOf((creditCardAmt * 5) / 100).setScale(2);
        }
        if (overdraftAmt != null) {
            percentValueOfdraft = Decimal.valueOf((overdraftAmt * 5) / 100).setScale(2);
            
        }
        
        if (cam.ROI__c != null && cam.Tenor__c != null && cam.Proposed_Loan_Amt__c != null) emiValOfMin = PMT(double.valueof(cam.ROI__c / 1200), Integer.valueOf(cam.Tenor__c), cam.Proposed_Loan_Amt__c);
        UnsecuredCredit = secamtsum + percentValueOfCredit + emiValOfMin + percentValueOfdraft;
        System.debug('UnsecuredCredit pk'+UnsecuredCredit );
        System.debug('UnsecuredCredit total pk'+secamtsum + percentValueOfCredit + emiValOfMin + percentValueOfdraft);
        if (cam.Average_Monthly_Net_Income1__c != null && cam.Average_Monthly_Net_Income1__c != 0) {
            if (UnsecuredCredit != null) cam.Unsecured_FOIR__c = ((Double.valueOf(UnsecuredCredit) / cam.Average_Monthly_Net_Income1__c) * 100).setScale(2);
            if (securedFOIR != null) cam.Secured_FOIR__c = ((Double.valueOf(securedFOIR) / cam.Average_Monthly_Net_Income1__c) * 100).setScale(2);
        }
        if (cam.Unsecured_FOIR__c != null && cam.Secured_FOIR__c != null) {
            cam.Eligible_FOIR__c = Integer.valueOf(cam.Unsecured_FOIR__c + cam.Secured_FOIR__c);
        }
        System.debug('pk secured Tunsecured'+cam.Unsecured_FOIR__c + cam.Secured_FOIR__c);
        try{
            upsert cam;
            upsert Loan;
            dss.camObj=cam;
            dss.opp=Loan;
        }
        catch(Exception e){
            System.debug('Error occured while updating updateCamAndOpp() Method '+e+ e.getLineNumber());
            return null;
        }
        return JSON.serialize(dss);
    }
    
    /** Aman Porwal - Retrigger Cibil - S **/
    public static void retriggerCIBILOperation(String jsonOppRecord, String jsonConRecord, String jsonAppRecord) 
    {
        Opportunity oppObj = new Opportunity();
        oppObj = (Opportunity)JSON.deserialize(jsonOppRecord,Opportunity.class);
        
        Applicant__c appObj= new Applicant__C ();
        appObj= (Applicant__C )JSON.deserialize(jsonAppRecord,Applicant__c.class);
        
        Contact contObj = new Contact();
        contObj = (Contact)JSON.deserialize(jsonConRecord,Contact.class);
        List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(oppObj);
        List<Applicant__c> appList = new List<Applicant__c>();
        appList.add(appObj);
        GeneralCommunicationHandler.sendSMS(oppList,appList,'CIBIL Consent SMS-Cust');
        /*String txtMsg = Label.CibilInfoMsgToCust;
sendsms.message(String.valueOf(contObj.Mobile__c) , txtMsg);
system.debug('aconobjcc.Mobile__c,txtMsg ====' + contObj.Mobile__c+ '------' + txtMsg);
SMS_Sent__c smssentobjver = new SMS_Sent__c();
smssentobjver.Name = 'Cibil Information to customer';
smssentobjver.SMS_Sent_Number__c = String.valueOf(contObj.Mobile__c);
smssentobjver.LoanApplication__c = (!CommonUtility.isEmpty(oppObj)) ? oppObj.Id : null;
smssentobjver.SMS_Text_Sent__c = txtMsg;
smssentobjver.SMS_Sent_Time__c = system.now();
INSERT smssentobjver;*/
        
        List < Cibil_Temp__c > cibTemp = new List < Cibil_Temp__c >();
        cibTemp = [SELECT id, CIBIL_Match_Check__c, CIBIL_Score__c, CIBIL_Response__c, (SELECT id FROM CIBILs__r), (SELECT id FROM CIBIL_Extension__r), (SELECT id FROM Cibil_Extension1s__r) FROM Cibil_Temp__c WHERE Applicant__c = : appObj.id FOR UPDATE];
        
        List < CIBIL__c > cibilrelList = new List < CIBIL__c > ();
        List < CIBIL_Extension__c >  cibilextrelList = new List < CIBIL_Extension__c > ();
        List < Cibil_Extension1__c >  cibilext1relList = new List < Cibil_Extension1__c > ();
        
        for(Cibil_temp__c cibiltmprcrds :cibTemp)
        {
            if (!(String.isBlank(cibiltmprcrds.CIBIL_Response__c) && String.isBlank(cibiltmprcrds.CIBIL_Score__c) && (cibiltmprcrds.CIBIL_Match_Check__c == '--None--' || String.isBlank(cibiltmprcrds.CIBIL_Match_Check__c)))) {   
                
                if (cibiltmprcrds.CIBILs__r.size() > 0)
                    cibilrelList.addAll(cibiltmprcrds.CIBILs__r);
                
                if (cibiltmprcrds.CIBIL_Extension__r.size() > 0)
                    cibilextrelList.addAll(cibiltmprcrds.CIBIL_Extension__r);
                
                if (cibiltmprcrds.Cibil_Extension1s__r.size() > 0)
                    cibilext1relList.addAll(cibiltmprcrds.Cibil_Extension1s__r);
            }
        }
        DELETE cibTemp;
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
        System.debug('inisde pk'+appObj.Id);
        List<Existing_Loan_details__c> deleteObligation;
        deleteObligation = [select id from Existing_Loan_Details__c where applicant__c =: appObj.Id];
        if (deleteObligation != null && deleteObligation.size() > 0) {
            delete deleteObligation;
            system.debug('Obligation Deleted');
        }
        if(!CommonUtility.isEmpty(appObj) && !CommonUtility.isEmpty(oppObj)){
            GeneralUtilities.reTriggerBRE(appObj,'Dedupe');  /*Bug 20939 */
            CibilService.createCibilTempRecord(contObj, appObj);
        }
    }
    /** Aman Porwal - Retrigger Cibil - E **/
    
    /** Aman Porwal - Retrigger Dedupe - S **/
    public static void retriggerDedupeOperation(String jsonOppRecord, String jsonConRecord, String jsonAppRecord) 
    {
        Opportunity oppObj = new Opportunity();
        oppObj = (Opportunity)JSON.deserialize(jsonOppRecord,Opportunity.class);
        
        Applicant__c appObj= new Applicant__C ();
        appObj= (Applicant__C )JSON.deserialize(jsonAppRecord,Applicant__c.class);
        
        Contact contObj = new Contact();
        contObj = (Contact)JSON.deserialize(jsonConRecord,Contact.class);
        
        List<De_Dupe__c> dedupeobj = [SELECT  id FROM De_Dupe__c WHERE Loan_Application__c=:oppObj.Id];
        if(!CommonUtility.isEmpty(dedupeobj))
        {
            try 
            {
                DELETE dedupeobj;
            }
            catch (DmlException e) 
            {
                System.debug('Exception in retriggerDedupeFunction '+e.getMessage());   
            }
            System.debug('savepoint1');
        }
        
        if(!CommonUtility.isEmpty(oppObj) && !CommonUtility.isEmpty(appObj) && !CommonUtility.isEmpty(contObj)){
            GeneralUtilities.reTriggerBRE(appObj,'Dedupe'); /*Bug 20939 */
            DedupeService.insertDedupeSource(contObj, appObj, oppObj);
        }
    }
    /** Aman Porwal - Retrigger Dedupe - E **/
    
public static String saveUWLandingPage(String accObj, String conObj, String oppObj, String oldemployername, String applicantObj) {
  try {
   Account accRec = (Account) JSON.deserialize(accObj, Account.class);
   Contact conRec = (Contact) JSON.deserialize(conObj, Contact.class);
   Opportunity oppRec = (Opportunity) JSON.deserialize(oppObj, Opportunity.class);
   Applicant__c appRec = (Applicant__c) JSON.deserialize(applicantObj, Applicant__c.class);

   system.debug('accRec--->' + accRec);
   system.debug('conRec--->' + conRec);
   system.debug('oppRec--->' + oppRec);
   system.debug('inside saveuw pk--->' + oldemployername);
   UPDATE accRec;
   UPDATE conRec;
   UPDATE oppRec;
   UPDATE appRec;
   List < SOL_Policy__c > solPolicyList = new List < SOL_Policy__c > ();
   solPolicyList = [select id, Policy_Name__c, Checklist_Policy_Status__c, Old_Address_Value__c, New_Address_Value__c from SOL_Policy__c where Loan_Application__c =: oppRec.Id AND Name = 'Sales2.0 Employer_Change'];
   if (!commonutility.isEmpty(solPolicyList) && !commonutility.isEmpty(solPolicyList[0].New_Address_Value__c)) {
    if (solPolicyList[0].New_Address_Value__c != accRec.Employer__r.Name) {
     solPolicyList[0].Old_Address_Value__c = solPolicyList[0].New_Address_Value__c;
     solPolicyList[0].New_Address_Value__c = accRec.Employer__r.Name;
     upsert solPolicyList[0];
    }
   } else {
    SOL_Policy__c sp = new SOL_Policy__c();
    sp.Name = 'Sales2.0 Employer_Change';
    sp.Policy_Name__c = 'Employer_Change';
    sp.Loan_Application__c = oppRec.Id;
    sp.Applicant_Name__c = appRec.Id;
    sp.New_Address_Value__c = accRec.Employer__r.Name;
    sp.Old_Address_Value__c = oldemployername;
    insert sp;
   }
  } catch (Exception e) {
   System.debug('Exception' + e.getMessage() + ' at Line Number: ' + e.getLineNumber());
   return 'error';
  }
  return 'success';
 }    
    /** Hrushikesh added SEND TO CREDIT VISIBILITY CHECK Functionality **/
    
    public static String checkAllSolPolicies(String oppId,String objectFieldJSON){
        Opportunity Loan =  [select id,Product__c,stageName,Telecaller_Name__c,Relationship_Manager__c from opportunity where id = : oppId];//22018
        Boolean readyForSendToCredit = true; 
        List<De_Dupe__c> dedupelist=new List<De_Dupe__c>();
        oppData dss = new oppData();
        Integer count = 0;
        List<SOL_Policy__c> SOLList = new List<SOL_Policy__c>();
        /*20939 s*/
        SOLList = [select id,name,Policy_Name__c,Remarks__c,Disposition_Status__c,Checklist_Policy_Status__c from SOL_Policy__c where Loan_Application__c = : oppId AND Name LIKE 'Sales2.0%' and RetriggerBRE__c = true];
        for(SOL_Policy__c sol : SOLList){
            if(sol.Policy_Name__c != null && sol.Policy_Name__c.contains('Invisible Monitoring'))
                dss.reTriggerIM = true;
            else
                count++;
        }
        dss.NoOfSolPolicyWithBreFlagTrue= String.valueOf(count);
        /*20939 IM e*/
        dss.status = 'true';
        dss.picklistData = LighteningUtilities.getPicklistValues(objectFieldJSON);
        De_Dupe__c deDupeObj=new De_Dupe__c();
        dedupelist=[SELECT  id,Source_Or_Target__c,Area_Status__c FROM De_Dupe__c WHERE Loan_Application__c=:oppId AND Source_Or_Target__c='Source'];
        if(!CommonUtility.isEmpty(dedupelist)){
            deDupeObj=dedupelist[0];           
        }
        List<SOL_Policy__c> solPolicyList= new List<SOL_Policy__c>();       
        solPolicyList=[select id, Policy_Name__c,Checklist_Policy_Status__c from SOL_Policy__c where Loan_Application__c = : oppId AND Name LIKE 'Sales2.0%'    ];
        if(deDupeObj.Area_Status__c=='Positive')
        {
            if(solPolicyList.size()>=11)
            {
                List<Applicant__c> applicant=new List<Applicant__c>();
                applicant=[select id, eKYC_Processing__c,Proof_of_Registered_Address_Submitted__c from Applicant__c where Loan_Application__c =: oppId  and Applicant_Type__c= 'Primary' LIMIT 1 ];
                Applicant__c primaryApplicant= applicant[0];
                if(!CommonUtility.isEmpty(applicant)){
                    if(primaryApplicant.eKYC_Processing__c!=false) //only if Ekyc is passed, go inside loop
                    {
                        
                        for(SOL_Policy__c solpolicy:solPolicyList)
                        {
                            String tempName=(solpolicy.Policy_Name__c).toLowerCase();
                            if((tempName).contains('fail'))
                            {
                                dss.status='false';
                                System.debug('IN For'+solpolicy.Policy_Name__c);
                            }
                        }
                        
                    }
                    else
                    {dss.status='false';} //if no EKYC
                    
                }  
            }
            else
            {dss.status='false';
             System.debug('There are no SOL  11 POLICIES');
            }
        }else
        {dss.status='false';
        }
        String validProducts=CommonUtility.getStaticResourceData('SalariedCustomSettings','ValidIM_Products','');   // Bug 22018 - RSL Mobility Hrushikesh 
        dss.isValidIM_Products =validProducts.contains(Loan.Product__c+';')?true:false; // Bug 22018 - RSL Mobility Hrushikesh 
        User UserInfoDetails = [select id, Profile.Name, Name from User where id = : UserInfo.getUserId() LIMIT 1];
        dss.isCommunityUsr = CommonUtility.hasCommunityProfile(new Set<String>{UserInfoDetails.Profile.Name});
        return JSON.serialize(dss);
    }
    public static List<Map<String, Object>> fetchHVTDetails(String oppId){
        system.debug('opp id is'+oppId);
        Bank_Account__c bankAcc = new Bank_Account__c();
        List<Bank_Account__c> bankAccList = [SELECT perfios_string__c from Bank_Account__c where Loan_Application__c =: oppId];
        if(bankAccList.size() > 0){
            bankAcc = bankAccList[0];
            if(bankAcc.perfios_string__c != null && bankAcc.perfios_string__c != ''){
                String perfiosResp = bankAcc.perfios_string__c;
                Map<String,Object> ALLMap = (Map<String,Object>)JSON.deserializeUnTyped(perfiosResp);
                Map<String,Object> creditsMap =(Map<String,Object>)ALLMap.get('top5CreditsPerMonth');
                system.debug('top5CreditsPerMonth'+creditsMap );
                List<Object> credList = (List<Object>)creditsMap.get('xns');
                system.debug('credList'+credList);
                List<Map<String, Object>> myMaps = new List<Map<String, Object>>();
                for(Object str : credList){
                    myMaps.add((Map<String, Object>)str);
                    //system.debug('recMap'+recMap);
                }
                Map<String,String> monthNameMap=new Map<String, String>{'1' =>'January', '2'=>'February', '3'=>'March', '4'=>'April', '5'=>'May',
                    '6'=>'June', '7'=>'July', '8'=>'August', '9'=>'September','10'=>'October',
                    '11'=>'November', '12'=>'December'};
                        for(Map<String,Object> str : myMaps){
                            //Date d = Date.valueOf('2013-05-05');
                            Date d = Date.valueOf(String.valueof(str.get('date')));
                            String month = String.valueof(d.month());
                            String year = String.valueof(d.year());
                            String day = String.valueof(d.day());
                            //system.debug('strrr'+month);
                            str.put('month',monthNameMap.get(month));
                            str.put('dateSal',str.get('date'));
                            str.put('narration',str.get('narration'));
                            
                            str.put('year',day+', '+monthNameMap.get(month)+', '+year);
                            
                        }
                
                return myMaps;
            }
            else{
                return null;
            }
        }
        else{
            return null;
        }
        //return null;
    }
    /* Bug : 17139  */
    public class PDquestionslist{
        @AuraEnabled          
        public String title;
        @AuraEnabled          
        public List<String> answer;
        @AuraEnabled          
        public String mandatory;
        @AuraEnabled          
        public String type;
        @AuraEnabled          
        public String selectedvalue;
        @AuraEnabled          
        public Boolean showQues;
        @AuraEnabled          
        public Integer index;
        public PDquestionslist(String title,List<String> answer,String mandatory,String type,String selectedvalue)
        {
            this.title=title;
            this.answer=answer;
            this.mandatory=mandatory;
            this.type=type;
            this.selectedvalue = selectedvalue;
            showQues = true;
        }
        
    }
    /*chagned method signature  compliance start bug 22485 */
    public static List < PDquestionslist > getallquestions(Boolean isPreapproved, Personal_Discussion__c pdObj, Boolean isSalesCompliance, String product){ //22018
        List<PDquestionslist> PDquestionslistdata= new List<PDquestionslist>();
        StaticResource staticresc;
        List<String> answerlist = new List<String>();
        Map<String,Object> ALLMap = new Map<String,Object>();
        Map<String,Object> quedetailsmap = new Map<String,Object>();
        String jsnBody;
        String selectedvalue;
        /*if(isSalesCompliance) condition added by swapnil sales compliance start bug 22485 */
        if (isSalesCompliance) {
            staticresc = [SELECT Body, Id, Name FROM StaticResource WHERE Name = 'salesComplianceQuestions'
                          limit 1
                         ];
            if (staticresc != null)
                jsnBody = staticresc.Body.toString();
            ALLMap = (Map < String, Object > ) JSON.deserializeUnTyped(jsnBody);
            quedetailsmap = (Map < String, Object > ) ALLMap.get('Questions_sales_compliance');
            
        } else { /*sales compliance end bug 22485 */
            
            staticresc = [SELECT Body,Id,Name FROM StaticResource WHERE Name = 'MobilityPDquestions' limit 1]; 
            if(staticresc != null)
                jsnBody = staticresc.Body.toString();
            ALLMap = (Map<String,Object>)JSON.deserializeUnTyped(jsnBody);
            if(isPreapproved != null && isPreapproved && !product.equalsIgnoreCase('RSL'))//22018
                quedetailsmap=(Map<String,Object>)ALLMap.get('Questions_Pre-approved');
            /*added by swapnil for RSL mobility bug 22018 s*/
            else if(product.equalsIgnoreCase('RSL')){
                quedetailsmap=(Map<String,Object>)ALLMap.get('Questions_enhance_offer_RSL');
            } /*added by swapnil for RSL mobility bug 22018 s*/   else
                quedetailsmap = (Map < String, Object > ) ALLMap.get('Questions_enhance_offer');
        } /*sales compliance else end bug 22485 */      
        Integer i=1;
        for (String key : quedetailsmap.keySet()) {
            Map<String,Object> questions=(Map<String,Object>)quedetailsmap.get(key);
            String title= (String)questions.get('Title');
            String allanswer = (String)questions.get('Answer');
            if(allanswer != null && allanswer.Contains(';')){
                answerlist = allanswer.split(';');
            }
            String fieldapiname =  'Question'+i+'__c';
            String questionanswer;
            if(pdObj != null)
                questionanswer = (String)pdObj.get(fieldapiname);
            if(questionanswer != null && questionanswer.Contains('-')){
                String[] answer = questionanswer.split('-');
                if(answer != null && answer.size() ==2 && answer[1] != null)
                    selectedvalue = answer[1];
                /*Condition added by swapnil sales compliance start bug 22485 */
                else if (answer != null && answer.size() == 3 && answer[1] != null && answer[2] != null)
                    selectedvalue = answer[1] + '-' + answer[2];
                /*Condition added by swapnil sales compliance end bug 22485*/
                //added for bug 22018
                else  if(answer != null && answer.size() ==4 && answer[1] != null && answer[2] != null && answer[3] != null) //22018
                    selectedvalue = answer[1]+'-'+answer[2]+'-'+answer[3];//22018
                else
                    selectedvalue='';
            }
            String mandatory= (String)questions.get('Mandatory');
            String type= (String)questions.get('Type');
            System.debug('title= ' + title+ ', answer= ' + answerlist +',mandatory='+ mandatory+',type = '+ type);
            PDquestionslist pdobject=new PDquestionslist(title,answerlist,mandatory,type,selectedvalue);
            
            PDquestionslistdata.add(pdobject);
            i++;
        }
        
        return PDquestionslistdata;
    }
    public static Personal_Discussion__c updatepdrecord(String jsonpdObj){
        Personal_Discussion__c pdobj = new Personal_Discussion__c();
        try{
            pdobj = (Personal_Discussion__c)JSON.deserialize(jsonpdObj,Personal_Discussion__c.class);
            upsert pdobj;
        } catch(Exception e)
        {
            System.debug('Exception inside updatepdrecord'+e.getMessage()+' at Line Number: ' + e.getLineNumber());
            return null;
        }
        return pdobj;
    }
    public static String approveloan(String loanid,String jsonoppobj){
        COFinantialController cofctrl;
        Opportunity loan = new Opportunity();
        try{
            loan = (Opportunity)JSON.deserialize(jsonoppobj,Opportunity.class);
            //upsert loan;
            cofctrl = new COFinantialController(loanid,loan.COO_Comments__c ,loan.Reject_Reason__c ,loan.Reject_Reason_1__c);
            cofctrl.appr();
        } catch(Exception e)
        {
            System.debug('Exception inside approveloan'+e.getMessage()+' at Line Number: ' + e.getLineNumber());
            return null;
        }
        return cofctrl.mobilitystatus;
    }
    public static String sendBackToSales(String loanid,String jsonoppobj){
        COFinantialController cofctrl;
        Opportunity loan = new Opportunity();
        try{
            loan = (Opportunity)JSON.deserialize(jsonoppobj,Opportunity.class);
            //upsert loan;
            cofctrl = new COFinantialController(loanid,loan.COO_Comments__c ,'' ,'');
            cofctrl.sendBackToSales();
        } catch(Exception e)
        {
            System.debug('Exception inside approveloan'+e.getMessage()+' at Line Number: ' + e.getLineNumber());
            return null;
        }
        return cofctrl.mobilitystatus;
    }
    
    public static String submitForRecommend(String loanid,String jsonoppobj,string SelCreditUser){
        COFinantialController cofctrl;
        Opportunity loan = new Opportunity();
        try{
            loan = (Opportunity)JSON.deserialize(jsonoppobj,Opportunity.class);
            //upsert loan;
            cofctrl = new COFinantialController(loanid,loan.COO_Comments__c ,loan.Reject_Reason__c ,loan.Reject_Reason_1__c);
            cofctrl.StrApprNew  = SelCreditUser;
            cofctrl.Recommend();
        } catch(Exception e)
        {
            System.debug('Exception inside approveloan'+e.getMessage()+' at Line Number: ' + e.getLineNumber());
            return null;
        }
        return cofctrl.mobilitystatus;
    }
    public static String rejectloan(String loanid,String jsonoppobj){
        COFinantialController cofctrl;
        Opportunity loan = new Opportunity();
        try{
            loan = (Opportunity)JSON.deserialize(jsonoppobj,Opportunity.class);
            cofctrl =new COFinantialController(loanid,loan.COO_Comments__c ,loan.Reject_Reason__c ,loan.Reject_Reason_1__c);
            cofctrl.acmrej();
            // upsert loan;
        } catch(Exception e)
        {
            System.debug('Exception inside approveloan'+e.getMessage()+' at Line Number: ' + e.getLineNumber());
            return (String)e.getMessage() ;
        }
        return cofctrl.mobilitystatus;
    }
    public static String fetchEmpPicklistData(String PicklistJSON){
        oppData dss = new oppData();
        dss.picklistData = LighteningUtilities.getPicklistValues(PicklistJSON);
        return JSON.serialize(dss);
    }
    public static String saveDeviationRec(Id deviationId,String oppObj,String appObj){
        oppData dss = new oppData();
        Opportunity Loan = new Opportunity();
        Applicant__c applicantPrimary = new Applicant__c();
        if(oppObj != null )
            Loan = (Opportunity)JSON.deserialize(oppObj, Opportunity.class);
        if(appObj != null )
            applicantPrimary = (Applicant__c)JSON.deserialize(appObj, Applicant__c.class);
        if (deviationId != null) {
            List < Document_Family__c > docFamilyList = new List < Document_Family__c > ();
            List < Deviation_Master__c > devList = new List < Deviation_Master__c > ();
            devList = [Select id, Deviation_Code__c, BRE_Deviation_Code__c from Deviation_Master__c where Product__c =: Loan.Product__c and Active_Flag__c = true AND Id = : deviationId];
            
            List < Checklist__c > manualList = new List < Checklist__c > ();
            if (devList.size() > 0) {
                docFamilyList = [select name, Documents__c, Is_OTP_Standard_Document__c, Product__c, Document_Code__c, Deviation_Code__c, Customer_Segment__c from Document_Family__c where Product__c INCLUDES(: Loan.Product__c) AND Deviation_Code__c != null];
                List < String > devStr = new List < String > ();
                List < String > docStr = new List < String > ();
                if (docFamilyList != null && docFamilyList.size() > 0) {
                    for (Deviation_Master__c dev: devList) {
                        for (Document_Family__c doc: docFamilyList) {
                            if ((doc.Deviation_Code__c.contains(dev.BRE_Deviation_Code__c)) || (doc.Deviation_Code__c == dev.BRE_Deviation_Code__c)) {
                                Checklist__c newCheckList = new Checklist__c(Applicant__c = applicantPrimary.id,Loan_Application__c = Loan.id, Deviation_Master__c = dev.id, DocumentFmlyName__c = doc.id, Manual__c = true);
                                manualList.add(newCheckList);
                                
                            }
                            
                        }
                    }
                }
            }
            if (manualList != null && manualList.size() > 0)
                insert manualList;
        }
        //dss.picklistData = LighteningUtilities.getPicklistValues(PicklistJSON);
        return SALMobilityOppCntrl_V2.createChecklist(oppObj);
    }
    public static String submitForPricing(String loanid,String jsonoppobj){
        oppData dss = new oppData();
        dss.theme = UserInfo.getUiThemeDisplayed();
        Opportunity Loan = new Opportunity();
        try{
            Loan =  [select id,stageName,Telecaller_Name__c,Relationship_Manager__c from opportunity where id = : loanId];
            if(!CommonUtility.isEmpty(Loan) ){
                if(Loan.stageName == 'Approved'){
                    List < User > userList = new List < User > ();
                    system.debug('****Loan.Relationship_Manager__c*' + Loan.Relationship_Manager__c);
                    if (Loan.Relationship_Manager__c != null)
                        userList = [SELECT FirstName, Profile.Name FROM User WHERE Id = : Loan.Relationship_Manager__c];
                    if (userList != null && userList.size() > 0) {
                        system.debug('****Loan.createdById*' + userList);
                        Loan.ownerId = userList[0].id;
                        Loan.approver__c = 'Area Sales Manager';
                        Loan.stageName = 'Post Approval Sales';
                        update Loan;
                        dss.opp = Loan;
                        dss.status = 'Success';
                    }
                    else
                        dss.status = 'Error';
                    
                }else
                    dss.status = 'Loan Application must be approved before sending for Pricing !!!';
                
                
            }
        }
        catch(Exception e){
            system.debug('Error Message'+e.getMessage());
            dss.status = 'Error';
        }
        return JSON.serialize(dss);
    }
    /* Bug : 17139 E */
    
    /* Bug : 17556 S  Pricing */
    
    /* Bug : 17556 S */
    public class VerificationWrapper{
        Verification__c verification {get; set;}
        Integer imagesCount {get; set;}
    }
    public static String saveVerificationStatus(String veri){
        try{
            List<VerificationWrapper> verWrapper = new List<VerificationWrapper>();
            List<Verification__c> verList = new List<Verification__c>();
            if(veri != null )
                verWrapper = (List<VerificationWrapper>)JSON.deserialize(veri, List<VerificationWrapper>.class);
            for(VerificationWrapper ver : verWrapper){
                verList.add(ver.verification);
            }
            if(verList.size() > 0)
                update verList;
            return 'success';
        }
        
        
        catch(Exception e){
            return 'failure';
        }
    }
    public Static double PMT(double rate, integer nper, decimal pv) {
        system.debug('******rate********' + rate + '**nper*' + nper + '*pv**' + pv);
        Double result = 0.0;
        if (pv != null && rate != null && nper != null) {
            result = Math.round((pv * rate) / (1 - Math.pow(1 + rate, -nper)));
            system.debug('****result**' + result);
        }
        return result;
    }
    public static string updateBankRec(String jsonbankObj){
        oppData dss = new oppData();
        Bank_Account__c bankobj = new Bank_Account__c();
        try{
            bankobj = (Bank_Account__c)JSON.deserialize(jsonbankObj,Bank_Account__c.class);
            upsert bankobj;
            dss.bankobj = bankobj;
        } catch(Exception e)
        {
            System.debug('Exception inside updatebankObj'+e.getMessage()+' at Line Number: ' + e.getLineNumber());
            return null;
        }
        
        return JSON.serialize(dss);  
    }
    
    //TAT CR
    public static string getStageTime(Long dt1, Long dt2)
    {      
        Long milliseconds = dt1 - dt2;
        Long seconds = milliseconds / 1000;   
        Long minutes =(seconds / 60);   
        Long hours = (minutes / 60);   
        Long days = (hours / 24);
        
        Long hoursAfterMod=math.mod(hours,60);
        Long minAfterMod=math.mod(minutes,60);
        system.debug('minutes -'+minutes);
        system.debug('hours -'+hours);
        system.debug('days -'+days);
        return days+' Days '+hoursAfterMod+' Hours '+minAfterMod+' Minutes';
    }
    
    /*Bug 18669 Start*/
    public static eKYC__c getEkycRec(String ranNum){ 
        eKYC__c ekycObj = new eKYC__c();
        eKYCObj = [SELECT Applicant__c,eKYC_Last_Name__c,bio_Ekyc__c,Auth_Code__c,Country__c,CreatedDate,Device_Type__c,eKYC_Aadhaar_Number__c,eKYC_Address_details__c,eKYC_City__c,eKYC_Date_of_Birth__c,eKYC_details_changed_flag__c,eKYC_District__c,eKYC_Enquiry_Number__c,eKYC_E_mail__c,eKYC_Family_details_S_O_W_O__c,eKYC_First_Name__c,eKYC_Gender__c,eKYC_Landmark__c,eKYC_matching_with_customer_details__c,eKYC_Mobile_Number__c,eKYC_Photo__c,eKYC_Pin_Code__c,eKYC_processing__c,eKYC_Response__c,eKYC_State__c,Error_Description__c,Error_Source__c,Id,Lead_Applicants__c,Lead__c,Name,Product_Offerings__c,Product__c,Random_Number__c,Reference_Number__c,Source__c,Sub_District__c,Transaction_Id__c,Location__c FROM eKYC__c where Random_Number__c =:ranNum ORDER BY CreatedDate limit 1];
        system.debug('ekyc Object inside controller is : '+eKYCObj);
        return eKYCObj;
    }
    /*Bug 18669 End*/
    
    //Bug 20995 start
    public static String getEkycRecById(String ekycId){ 
        eKYC__c ekycObj = new eKYC__c();
        eKYCObj = [SELECT Applicant__c,eKYC_Last_Name__c,bio_Ekyc__c,Auth_Code__c,Country__c,CreatedDate,Device_Type__c,eKYC_Aadhaar_Number__c,eKYC_Address_details__c,eKYC_City__c,eKYC_Date_of_Birth__c,eKYC_details_changed_flag__c,eKYC_District__c,eKYC_Enquiry_Number__c,eKYC_E_mail__c,eKYC_Family_details_S_O_W_O__c,eKYC_First_Name__c,eKYC_Gender__c,eKYC_Landmark__c,eKYC_matching_with_customer_details__c,eKYC_Mobile_Number__c,eKYC_Photo__c,eKYC_Pin_Code__c,eKYC_processing__c,eKYC_Response__c,eKYC_State__c,Error_Description__c,Error_Source__c,Id,Lead_Applicants__c,Lead__c,Name,Product_Offerings__c,Product__c,Random_Number__c,Reference_Number__c,Source__c,Sub_District__c,Transaction_Id__c,Location__c FROM eKYC__c where ID =:ekycId ORDER BY CreatedDate limit 1];
        system.debug('ekyc Object inside controller is : '+eKYCObj);
        ResponseDTO resDTO = new ResponseDTO();
        
        if(eKYCObj != null ){
            resDTO.ekycmobility = eKYCObj;
            resDTO.status = 'SUCCESS';
            resDTO.message = 'SUCCESS';
            
            return  JSON.serialize(resDTO); 
        }
        
        resDTO.status = 'Failure';
        resDTO.message = 'Failure';
        System.debug('here in else '+JSON.serialize(resDTO));
        return  JSON.serialize(resDTO);
        
    }
    //Bug 20995 stop
    /*Bug 20939 s*/
    public static String retriggerBRECalls(String loanid){
        Opportunity loan = new Opportunity();
        try{
            List<SOL_Policy__c> SOLPolicyList = new List<SOL_Policy__c>();
            Map<string,SOL_Policy__c> SOLPolicyMap = new Map<string,SOL_Policy__c>();
            SOLPolicyList = [select id,name,Policy_Name__c,Remarks__c,Disposition_Status__c,Checklist_Policy_Status__c from SOL_Policy__c where Loan_Application__c = : loanid AND Name LIKE 'Sales2.0%' and RetriggerBRE__c = true];
            system.debug('SOLPolicyList>>'+SOLPolicyList);
            
            oppData dss = new oppData();
            /*added by Hrushikesh*/
            dss.NoOfSolPolicyWithBreFlagTrue= String.valueOf(SOLPolicyList.size()); 
            string TypeForMCP = '';
            if(!commonutility.isEmpty(SOLPolicyList)){
                for(SOL_Policy__c solObj :SOLPolicyList){
                    //   SOLPolicyMap.put(solObj.name,solObj);
                    SOLPolicyMap.put(solObj.Policy_Name__c,solObj);
                }
                if(SOLPolicyMap.containsKey('Experience MCP Fail') || SOLPolicyMap.containsKey('Experience MCP Pass'))
                    TypeForMCP = 'Experience';
                else if(SOLPolicyMap.containsKey('Sal MCP Fail') || SOLPolicyMap.containsKey('Sal MCP Pass'))
                    TypeForMCP = 'SAL';
                else if(SOLPolicyMap.containsKey('DOB MCP Fail') || SOLPolicyMap.containsKey('DOB MCP Pass'))
                    TypeForMCP = 'DOB';
                /*if(SOLPolicyMap.containsKey('EWS') || SOLPolicyMap.containsKey('Employment Check Pass') || SOLPolicyMap.containsKey('Employment Check Fail') || SOLPolicyMap.containsKey('CIBIL Check Pass') || SOLPolicyMap.containsKey('CIBIL Check Fail') || SOLPolicyMap.containsKey('Dedupe Check Fail') || SOLPolicyMap.containsKey('Dedupe Check Pass') || SOLPolicyMap.containsKey('Primary Pan Check Pass') || SOLPolicyMap.containsKey('Primary Pan Check Fail') || SOLPolicyMap.containsKey('Experience MCP Fail') || SOLPolicyMap.containsKey('Experience MCP Pass') || SOLPolicyMap.containsKey('SAL MCP Fail') || SOLPolicyMap.containsKey('SAL MCP Pass') || SOLPolicyMap.containsKey('DOB MCP Fail') || SOLPolicyMap.containsKey('DOB MCP Pass') || SOLPolicyMap.containsKey('Dynamic Offer Amount') || SOLPolicyMap.containsKey('EPFO Details') || SOLPolicyMap.containsKey('Eligibility Details') || SOLPolicyMap.containsKey('NSDL Pan Check')){
system.debug('in getAllData');
getAllData(loanid,dss);
system.debug('end getAllData');
}*/
                getAllData(loanid,dss);
                /*  if(SOLPolicyMap.containsKey('Experience MCP Fail') || SOLPolicyMap.containsKey('Experience MCP Pass') || SOLPolicyMap.containsKey('SAL MCP Fail') || SOLPolicyMap.containsKey('SAL MCP Pass') || SOLPolicyMap.containsKey('DOB MCP Fail') || SOLPolicyMap.containsKey('DOB MCP Pass')){
system.debug('in MCP');
/*Map<String,String> params = new Map<String,String>();
params.put('JSONCamObj',JSON.serialize(dss.camObj));
params.put('empAccount','['+ JSON.serialize(dss.accObj) + ']');
params.put('empOpp','['+ JSON.serialize(dss.opp)  + ']'); 
params.put('empContact','['+ JSON.serialize(dss.objCon)  + ']'); 
params.put('appObj','['+ JSON.serialize(dss.applicantPrimary)  + ']');  
params.put('solPolicySrc','Sales2.0');
if(SOLPolicyMap.containsKey('Experience MCP Fail') || SOLPolicyMap.containsKey('Experience MCP Pass'))
params.put('TypeForMCP','Experience');
else if(SOLPolicyMap.containsKey('SAL MCP Fail') || SOLPolicyMap.containsKey('SAL MCP Pass'))
params.put('TypeForMCP','SAL');
else if(SOLPolicyMap.containsKey('DOB MCP Fail') || SOLPolicyMap.containsKey('DOB MCP Pass'))
params.put('TypeForMCP','DOB');
system.debug('params>>>'+params);
oppData data = new oppData(); **
SALMobilityOppCntrl_V2.retriggerMCP(loanid,TypeForMCP);
//data = SALMobilityOppCntrl_V2.callMCP(params);
system.debug('end MCP');                    
} */
                if(SOLPolicyMap.containsKey('Experience MCP Fail') || SOLPolicyMap.containsKey('Experience MCP Pass')){
                    SALMobilityOppCntrl_V2.retriggerMCP(loanid,'Experience');
                }
                if(SOLPolicyMap.containsKey('Sal MCP Fail') || SOLPolicyMap.containsKey('Sal MCP Pass')){
                    SALMobilityOppCntrl_V2.retriggerMCP(loanid,'Sal');
                }
                if(SOLPolicyMap.containsKey('DOB MCP Fail') || SOLPolicyMap.containsKey('DOB MCP Pass')){
                    SALMobilityOppCntrl_V2.retriggerMCP(loanid,'DOB');
                }
                if(SOLPolicyMap.containsKey('NSDL Pan Check')){
                    system.debug('in NSDL Pan Check');
                    queuableNSDLPANCheck nsdlJob = new queuableNSDLPANCheck(loanid);
                    ID jobID = System.enqueueJob(nsdlJob);
                }
                if(SOLPolicyMap.containsKey('EPFO Details')){  
                    system.debug('in else if epfo');
                    queuableEPFO updateJob = new queuableEPFO(loanid);
                    ID jobID = System.enqueueJob(updateJob);
                }   
                if(SOLPolicyMap.containsKey('Office Email Verification')){  
                    system.debug('in Office Email Verification');
                    string result = SALMobilityOppCntrl_V2.doEmploymentChecks(JSON.serialize(dss.accObj),JSON.serialize(dss.opp),JSON.serialize(dss.objCon));
                    system.debug('in Office Email Verification'+result);
                } 
                if(SOLPolicyMap.containsKey('EWS') || SOLPolicyMap.containsKey('Employment Check Pass') || SOLPolicyMap.containsKey('Employment Check Fail') || SOLPolicyMap.containsKey('CIBIL Check Pass') || SOLPolicyMap.containsKey('CIBIL Check Fail') || SOLPolicyMap.containsKey('Dedupe Check Fail') || SOLPolicyMap.containsKey('Dedupe Check Pass') || SOLPolicyMap.containsKey('Primary Pan Check Pass') || SOLPolicyMap.containsKey('Primary Pan Check Fail')){
                    system.debug('in panbre'); 
                    queuablePANBRE updateJob = new queuablePANBRE(loanid);
                    ID jobID = System.enqueueJob(updateJob);
                    /* SALMobilityOppCntrl_V2.retriggerPANBRE(loanid);
oppData dss1 = new oppData();
dss1 =  (SALMobilityOppCntrl_V2.oppData)JSON.deserialize(panValue, SALMobilityOppCntrl_V2.oppData.class); 
dss.cibilExt1 = dss1.cibilExt1;
dss.cibilExt =  dss1.cibilExt;
dss.cibilobj = dss1.cibilobj;
dss.applicantPrimary = dss1.applicantPrimary;*/
                    
                }
                
                if(SOLPolicyMap.containsKey('Dynamic Offer Amount')){
                    system.debug('in Dynamic Offer Amount'); 
                    queuableDyanmicOffer OfferJob = new queuableDyanmicOffer(loanid);
                    ID jobID = System.enqueueJob(OfferJob);
                    /*SALMobilityOppCntrl_V2.retriggerDynamicOffer(loanid); */
                    system.debug('end Dynamic Offer Amount>>>');
                }
                if(SOLPolicyMap.containsKey('Eligibility Details')){
                    system.debug('in Eligibility');  
                    queuableEligibility EligibilityJob = new queuableEligibility(loanid);
                    ID jobID = System.enqueueJob(EligibilityJob);
                    system.debug('in Eligibility');
                }
                
                if(SOLPolicyMap.containsKey('Banking Check Pass') || SOLPolicyMap.containsKey('Banking Check Fail') || SOLPolicyMap.containsKey('Veri- Permanent Fail') || SOLPolicyMap.containsKey('Veri- Current Fail') || SOLPolicyMap.containsKey('Veri- Office Fail') || SOLPolicyMap.containsKey('Veri- Banking Fail') || SOLPolicyMap.containsKey('Veri- Permanent Pass') || SOLPolicyMap.containsKey('Veri- Current Pass') || SOLPolicyMap.containsKey('Veri- Office Pass') || SOLPolicyMap.containsKey('Veri- Banking Pass')){
                    system.debug('in verification');
                    SALMobilityOppCntrl_V2.retriggerverification(loanid); 
                }
                if(SOLPolicyMap.containsKey('Deviation Details') && SOLPolicyMap.containsKey('Standard Document Details')){
                    SALMobilityOppCntrl_V2.retriggerDeviation(loanid,true); 
                }
                else if(SOLPolicyMap.containsKey('Standard Document Details')){  
                    SALMobilityOppCntrl_V2.retriggerDeviation(loanid,true); 
                }
                else if(SOLPolicyMap.containsKey('Deviation Details')){  
                    SALMobilityOppCntrl_V2.retriggerDeviation(loanid,false); 
                }
                
                /* SAL NSDL CHECK (need to check if do we need to call panbre or nsdl pn check) saveEmpDetails Sales2.0 Total Work Exp History  -> need to update new address and old address value acc.Total_Work_Experience_Yrs__c+':'+acc.Total_Work_Experience_Months__c */
            }
            
            //do epfo , office email verification , then fire verification
            //codified cibil , codefied dedupe , PANBRE
            //fire document deviation
        } catch(Exception e)
        {
            System.debug('Exception>>>>'+e.getMessage()+' at Line Number: ' + e.getLineNumber());
            return null;
        }
        return 'success';
    } 
    
    public class queuableNSDLPANCheck implements Queueable,database.Allowscallouts {
        private string oppId;
        
        public queuableNSDLPANCheck(string loanid) {
            this.oppId = loanid;
        }
        
        public void execute(QueueableContext context) {
            oppData dss = new oppData();
            getAllData(oppId,dss);
            string result = SALMobilityOppCntrl_V2.PANCheck(dss.accObj.PANNumber__c,dss.opp.Product__c,oppId,JSON.serialize(dss.accObj),JSON.serialize(dss.objCon),false);
            system.debug('in execute queuableNSDLPANCheck'+result);
            oppData dss1 = new oppData();
            dss1 =  (SALMobilityOppCntrl_V2.oppData)JSON.deserialize(result, SALMobilityOppCntrl_V2.oppData.class);
            if(dss1.status == 'success'){
                //call PAN BRE
                system.debug('in queuableNSDLPANCheck calling PAN BRE');
                if(!Test.isRunningTest()){
                    queuablePANBRE updateJob = new queuablePANBRE(oppId);
                    ID jobID = System.enqueueJob(updateJob);
                }
            }   
            
        }
    }
    /*bug 20939 RCU s*/
    //US 524 changed definition
    public static void getCriticalDemog(OppData dss,List<Opportunity> oppList,String  oppId,list<De_dupe__c> dedupelist ) {
        
        if(CommonUtility.isEmpty(oppList)){
            return;
        }
        if(!CommonUtility.isEmpty(oppList) && !CommonUtility.isEmpty(oppList[0].CUSTOMER__c)){
            if(!CommonUtility.isEmpty(oppList[0].CUSTOMER__r.Demog_Error__c) || !CommonUtility.isEmpty(oppList[0].CUSTOMER__r.DOB_Demog__c) || !CommonUtility.isEmpty(oppList[0].CUSTOMER__r.Residence_demog__c) || !CommonUtility.isEmpty(oppList[0].CUSTOMER__r.PAN_Demog__c) || !CommonUtility.isEmpty(oppList[0].CUSTOMER__r.Mobile_Demog__c) || !CommonUtility.isEmpty(oppList[0].CUSTOMER__r.Bank_account_number_demog__c))
                dss.isCriticalChange=true;
        }
        system.debug('dss.isCriticalChange'+dss.isCriticalChange);
        /*Map<String,Object> citicalDemogValues = dss.criticalDemogMap;
        
        boolean criticalDemogFlag=false;
        Date myDate;
        Integer   numberofdays;
        
       // System.debug('Number of days sice latest data changed '+numberofdays);
       // System.debug('Value from Custom setting '+Integer.valueOf(citicalDemogValues.get('DaysToTrack')));
        System.debug('oppList size  '+oppList.size());
        if(!CommonUtility.isEmpty(oppList) && !CommonUtility.isEmpty(oppList[0].CUSTOMER__c) && !CommonUtility.isEmpty(oppList[0].CUSTOMER__r.Last_Modified_date_Demog__c) ){
            myDate =oppList[0].CUSTOMER__r.Last_Modified_date_Demog__c;
            numberofdays = mydate.daysBetween(date.TODAY());
            if(Integer.valueOf(citicalDemogValues.get('DaysToTrack'))>=numberofdays){
                criticalDemogFlag=true;
                dss.isCriticalChange=true;
            }
            System.debug('criticalDemogFlag after check is '+criticalDemogFlag);
        }
        if(!CommonUtility.isEmpty(oppList[0].CUSTOMER__c) && !CommonUtility.isEmpty(dedupelist)){   
            De_dupe__c objDedupe=new De_dupe__c();
            objDedupe=null;
            for(De_dupe__c de : dedupelist){
                if(de.Source_Or_Target__c=='Source'){
                    objDedupe=de;
                }
            }
            /*
List<Bank_Account__c> banksallists = new List<Bank_Account__c>();
banksallists = [select id, Source_Of_Data__c,Authenticity_Score_Flag__c from Bank_Account__c where Loan_Application__c = :oppId LIMIT 1];

System.debug('criticalDemogFlag before check is '+criticalDemogFlag);                
if(criticalDemogFlag){  
System.debug('swapnil Dedupe values are '+objDedupe);
//CUSTOMER__r.Last_Modified_date_Demog__c
if(!CommonUtility.isEmpty(oppList[0].CUSTOMER__r.PAN_Demog__c)){

System.debug('Pan Changed '+oppList[0].CUSTOMER__r.PAN_Demog__c);
objDedupe.Existing_cust_demog_change__c=String.valueOf(citicalDemogValues.get('PAN_Demog__c')).split(';')[0];
objDedupe.Demog_change_action__c=String.valueOf(citicalDemogValues.get('PAN_Demog__c')).split(';')[1];

}else if(!CommonUtility.isEmpty(oppList[0].CUSTOMER__r.Bank_account_number_demog__c)){

System.debug('Bank Account chagned '+oppList[0].CUSTOMER__r.Bank_account_number_demog__c);


if(CommonUtility.isEmpty(oppList[0].Link_Offer_id__c)){ //for pre-approved offers 
System.debug('Non pre approved case');
if(!CommonUtility.isEmpty(banksallists) && (banksallists[0].Source_Of_Data__c=='Uploaded Statements' || banksallists[0].Source_Of_Data__c=='NetBanking Account')){
if(banksallists[0].Authenticity_Score_Flag__c=='Pass'){

objDedupe.Existing_cust_demog_change__c=String.valueOf(citicalDemogValues.get('Bank_account_number_demog__c')).split(';')[0];
objDedupe.Demog_change_action__c=String.valueOf(citicalDemogValues.get('Bank_account_number_demog__c')).split(';')[1];

}else if(banksallists[0].Authenticity_Score_Flag__c=='Fail'){

objDedupe.Existing_cust_demog_change__c=String.valueOf(citicalDemogValues.get('Bank_account_number_demog__c')).split(';')[2];
objDedupe.Demog_change_action__c=String.valueOf(citicalDemogValues.get('Bank_account_number_demog__c')).split(';')[3];

}else{
objDedupe.Existing_cust_demog_change__c='';
objDedupe.Demog_change_action__c='';
}

}else{
objDedupe.Existing_cust_demog_change__c='';
objDedupe.Demog_change_action__c='';
}

}else{
System.debug('Pre approved case');
objDedupe.Existing_cust_demog_change__c='Flows back to normal underwriting';
objDedupe.Demog_change_action__c='Send for normal underwriting';
}   
}else if(!CommonUtility.isEmpty(oppList[0].CUSTOMER__r.DOB_Demog__c)){

System.debug('DOB changed '+oppList[0].CUSTOMER__r.DOB_Demog__c);
objDedupe.Existing_cust_demog_change__c=String.valueOf(citicalDemogValues.get('DOB_Demog__c')).split(';')[0];

objDedupe.Demog_change_action__c=String.valueOf(citicalDemogValues.get('DOB_Demog__c')).split(';')[1];
} else if(!CommonUtility.isEmpty(oppList[0].CUSTOMER__r.Mobile_Demog__c)){

System.debug('Mobile Changed '+oppList[0].CUSTOMER__r.Mobile_Demog__c);
objDedupe.Existing_cust_demog_change__c=String.valueOf(citicalDemogValues.get('Mobile_Demog__c')).split(';')[0];
objDedupe.Demog_change_action__c=String.valueOf(citicalDemogValues.get('Mobile_Demog__c')).split(';')[1];

} else if(!CommonUtility.isEmpty(oppList[0].CUSTOMER__r.Residence_demog__c)){

System.debug('Residence Address change '+oppList[0].CUSTOMER__r.Residence_demog__c);
objDedupe.Existing_cust_demog_change__c=String.valueOf(citicalDemogValues.get('Residence_demog__c')).split(';')[0];
objDedupe.Demog_change_action__c=String.valueOf(citicalDemogValues.get('Residence_demog__c')).split(';')[1];
}
}else{

System.debug('In Else criticalDemogFlag  is '+criticalDemogFlag);
objDedupe.Existing_cust_demog_change__c='';
objDedupe.Demog_change_action__c='';
criticalDemogFlag=false;
dss.isCriticalChange=false;

}
            try{
                
                //upsert objDedupe;
                if(objDedupe != null){
                    dss.DemogChange=objDedupe.Existing_cust_demog_change__c;
                    dss.DemogAction=objDedupe.Demog_change_action__c;
                    
                }
                // System.debug('Upserting de dupe --> '+dss.DemogChange+' --> '+dss.DemogAction);
                
            }
            catch(DMLException e){
                System.debug('Exception while upserting de dupe Message '+e.getMessage()+'   On Line '+e.getLineNumber());
            }
        }*/
        
    }   
    public class queuablesendSMSonLACreation implements Queueable,database.Allowscallouts {
        
        private list<Opportunity> listOpp=new list<Opportunity>(); 
        private list<Applicant__c> listApp=new list<Applicant__c>();
        Private String action;
        public queuablesendSMSonLACreation(Opportunity loan,Applicant__c app,String action) {
            listOpp.add(loan);
            listApp.add(app);
            this.action=action;
        }
        public queuablesendSMSonLACreation(Opportunity loan,String action) {
            listOpp.add(loan);
            this.action=action;
        }
        
        public void execute(QueueableContext context) {
            if(action.equalsIgnoreCase('On app creation')){
                System.debug('Action is '+action);
                GeneralCommunicationHandler.sendSMS(listOpp ,listApp ,'CIBIL Consent SMS-Cust'); 
                
                //GeneralCommunicationHandler.sendSMS(listOpp ,listApp ,'LA received-Cust');
                //GeneralCommunicationHandler.sendSMS(listOpp,'LA Created confirmation-Cust');
                //GeneralCommunicationHandler.sendSMS(listOpp,'LA Created confirmation-Int');
                GeneralCommunicationHandler.sendSMS(listOpp,'Email SPAM check-Cust');
                //GeneralCommunicationHandler.sendSMS(listOpp,'LA login-Cust');
                //GeneralCommunicationHandler.sendEmail(listOpp,'LA login-Cust');
            }
            else if(action.equalsIgnoreCase('On LA Acceptance to Cust')){
                System.debug('Inside If');
                System.debug('listOpp::'+listOpp);
                GeneralCommunicationHandler.sendSMS(listOpp,'Feedback SMS-Cust');
                //GeneralCommunicationHandler.sendEmail(listOpp,'Feedback Email-Cust');
                GeneralCommunicationHandler.sendSMS(listOpp,'LA cust acceptance-Cust');
                //uncommented below line bug 22890
                //GeneralCommunicationHandler.sendEmail(listOpp,'LA cust acceptance-Cust');
                
            }
            
        }
    }
    @future(callout=true)
    public static void sendFeedbackEmail(String loanId){
        Opportunity loan = [Select Id, Customer_Email_Id__c from Opportunity where Id =: loanId];
        String intBody;
        List<EmailTemplate> emailTemp = [SELECT Id,HTMLValue,Body,Name from EmailTemplate where Name = 'SAL Feedback Email'];
        EmailTemplate em = emailTemp[0];
        intBody = em.HTMLValue;
        if(intBody != null){
            intBody = intBody.replace('"','\\"');
            intBody = intBody.replaceAll('<p>\\s','<p>');
            intBody = intBody.trim();
            intBody = intBody.replaceAll('(\\s+)', ' ');
            intBody = intBody.replace('**bitly**','<a href=\\"'+Label.bitly_org_link+'/SAL_Feedback_Page?oppId='+loan.Id+'\\">Here</a>');
            
        }
        
        
        String emailAddr = loan.Customer_Email_Id__c;
        System.debug('body'+intbody);
        String[] toAddresses = new String[] {
            emailAddr
                };
                    String replyURL = '';
        String[] bccArray;
        String[] ccArray;
        BAFL_EmailServicesLogix.EmailServicesPort stub = new BAFL_EmailServicesLogix.EmailServicesPort();
        BAFL_EmailServicesLogix.SendEmailResponse er = stub.SendEmail('spl.mailconfirmation@bajajfinserv.in',
                                                                      replyURL,
                                                                      toAddresses,
                                                                      ccArray,
                                                                      bccArray,
                                                                      'Normal',
                                                                      new BAFL_EmailServicesLogix.Attachment[] {},
                                                                      'Feedback',
                                                                      intBody,
                                                                      'bajaj');
    }
    public static void gensendSMS(Opportunity loan,Applicant__c app,String action){
        
        list<Opportunity> listOpp=new list<Opportunity>(); 
        list<Applicant__c> listApp=new list<Applicant__c>();
        
        listOpp.add(loan);
        listApp.add(app);
        
        
        if(action.equalsIgnoreCase('On app system reject')){
            //GeneralCommunicationHandler.sendSMS(listOpp, 'LA System Reject-Int');
            
            GeneralCommunicationHandler.sendSMS(listOpp, 'LA Rejected-Int'); 
            GeneralCommunicationHandler.sendEmail(listOpp, 'LA Rejected-Int'); 
            
            
        }
        else if(action.equalsIgnoreCase('On app reject Cust')){
            //GeneralCommunicationHandler.sendSMS(listOpp, 'LA rejection-Cust');
            //GeneralCommunicationHandler.sendEmail(listOpp, 'LA rejection-Cust');
            GeneralCommunicationHandler.sendSMS(listOpp, 'LA Rejected-Cust');
            GeneralCommunicationHandler.sendEmail(listOpp, 'LA Rejected-Cust');
        }
        else if(action.equalsIgnoreCase('On LA Acceptance to Cust')){
            GeneralCommunicationHandler.sendSMS(listOpp,'Feedback SMS-Cust');
            // GeneralCommunicationHandler.sendEmail(listOpp,'Feedback Email-Cust');
            GeneralCommunicationHandler.sendSMS(listOpp,'LA cust acceptance-Cust');
        }
        else if(action.equalsIgnoreCase('On app send to credit')){
            System.debug('Action credit is '+action);
            GeneralCommunicationHandler.sendSMS(listOpp, 'LA sumitted to credit-Int');    
        }else if(action.equalsIgnoreCase('On app creation cust email')){
            System.debug('Action credit is On app creation cust email');
            GeneralCommunicationHandler.sendEmail(listOpp,'LA Created confirmation-Cust');
            //GeneralCommunicationHandler.sendEmail(listOpp,'LA login-Cust');
        }else if(action.equalsIgnoreCase('On app send back to sales')){
            System.debug('Action back to sales is '+action);
            //GeneralCommunicationHandler.sendSMS(listOpp, 'LA queries to customer-Cust'); 
            //GeneralCommunicationHandler.sendEmail(listOpp, 'LA queries to customer-Cust'); 
            GeneralCommunicationHandler.sendSMS(listOpp, 'LA Discrepancies raised-Int');
            //GeneralCommunicationHandler.sendEmail(listOpp, 'LA Discrepancies raised-Int');
            //GeneralCommunicationHandler.sendSMS(listOpp,'LA Doc queries-Cust');
            //GeneralCommunicationHandler.sendEmail(listOpp,'LA Doc queries-Cust');
            /*one sms and email is pending*/
        }/*else if(action.equalsIgnoreCase('On LA view agreement')){
GeneralCommunicationHandler.sendSMS(listOpp,'LA view agreement-Cust');
GeneralCommunicationHandler.sendEmail(listOpp,'LA view agreement-Cust');
}*/else if(action.equalsIgnoreCase('On LA Perfios')){
    GeneralCommunicationHandler.sendSMS(listOpp,'LA cust perfios-Cust');  
}/*else if(action.equalsIgnoreCase('On LA Acceptance to ASM')){
GeneralCommunicationHandler.sendEmail(listOpp,'LA cust E-agreement and E sign-Int');
} */else if(action.equalsIgnoreCase('On LA E-Mandate')){
    //GeneralCommunicationHandler.sendSMS(listOpp,'LA register E-EMI payments-Cust');
    GeneralCommunicationHandler.sendEmail(listOpp,'LA register E-EMI payments-Cust');
}else if(action.equalsIgnoreCase('On app send back to sales from credit')){
    
}else if(action.equalsIgnoreCase('On app CIBIL check request')){
    GeneralCommunicationHandler.sendSMS(listOpp,'LA CIBIL check-Cust');
    GeneralCommunicationHandler.sendEmail(listOpp,'LA CIBIL check-Cust');
}else if(action.equalsIgnoreCase('On LA wating ACM for action')){
    GeneralCommunicationHandler.sendSMS(listOpp,'LA waiting no decisioned-Int');
}else if(action.equalsIgnoreCase('On LA wating ASM for action')){
    GeneralCommunicationHandler.sendSMS(listOpp,'LA Discrepancies waiting-Int');
}   
        else if(action.equalsIgnoreCase('Office Email Verification Reminder')){
            GeneralCommunicationHandler.sendSMS(listOpp,'Office Email Veri Rem-Cust');
            //GeneralCommunicationHandler.sendEmail(listOpp,'Office Email Veri Rem-Cust');
        }else if(action.equalsIgnoreCase('Office Email Veri Pending-Cust')){
            GeneralCommunicationHandler.sendSMS(listOpp,'Office Email Veri Pending-Cust');
            //GeneralCommunicationHandler.sendEmail(listOpp,'Office Email Veri Rem-Cust');
        }
        else if(action.equalsIgnoreCase('On Email Verification')){
            GeneralCommunicationHandler.sendSMS(listOpp,'Official email ID verification-Cust');
        }  else if(action.equalsIgnoreCase('Assing to sales')){
            GeneralCommunicationHandler.sendSMS(listOpp,'LA assigned to customer-Int');    
            GeneralCommunicationHandler.sendEmail(listOpp,'LA assigned to customer-Int');
        }    
        
        
        
    }
    public static String updateVerificationData(String appObj,String veriList,String vamList) {
        try{
            Applicant__c applicantObj = new Applicant__c();
            List<Verification__c> veri = new List<Verification__c>();
            if(appObj != null)
                applicantObj = (Applicant__c)JSON.deserialize(appObj,Applicant__c.class);
            if(veriList != null)
                veri = (List<Verification__c>)JSON.deserialize(veriList,List<Verification__c>.class); 
            if(applicantObj != null)
                update applicantObj;
            upsert veri;
            oppData dss = new oppData();
            dss.veriList = veri;
            dss.applicantPrimary = applicantObj;
            return JSON.serialize(dss);
        }
        catch(Exception e){
            system.debug('Exception is::'+e.getMessage()+e.getLineNumber());
            return 'Fail';
        }
        
    }
    public static String sendVerificationMail(String veriList,String vamList){
        try{
            Map<String,Object> allMap = GeneralUtilities.fetchStaticRescMap();
            Map<String,Object> rcuMap = new Map<String,Object>();
            if(allMap != null && allMap.containsKey('RCU Processes'))
                rcuMap = (Map<String,Object>)allMap.get('RCU Processes');   
            String rcuEmail = (String)rcuMap.get('RCU Email ID'); 
            List<Verification__c> veri = new List<Verification__c>();
            List < Opportunity > oppList = new List < Opportunity > (); //US_953
            List<Verification_Agency_Master__c> vam = new List<Verification_Agency_Master__c>();
            if(veriList != null)
                veri = (List<Verification__c>)JSON.deserialize(veriList,List<Verification__c>.class); 
                oppList = [Select id, Branch_Name__r.Branch_RCU_Email_id__c from Opportunity where id =: veri[0].Loan_Application__c]; //US_953
            if(vamList != null)
                vam = (List<Verification_Agency_Master__c>)JSON.deserialize(vamList,List<Verification_Agency_Master__c>.class);    
            Boolean emailSent = false;
            if(veri != null){
                Set<String> newveri = new Set<String>();
                for(Verification__c ver : veri){
                    newveri.add(ver.Id);
                }  
                //List<Verification__c> veriNew = [SELECT Verification_Type__c,Loan_Application__r.Loan_Application_Number__c,Verification_Agency__c from Verification__c where Id in: newveri];
                 List < Verification__c > veriNew= [SELECT Name,Verification_Type__c,/*US_953*/Contact_Name__c/*US_953*/,Loan_Application__r.Loan_Application_Number__c,Loan_Application__r.Branch_City__c,Loan_Application__r.product__c,Verification_Agency__c from Verification__c where Id in: newveri];
                if (oppList != null && oppList.size() > 0 && veriNew != null && veriNew.size() > 0) //US_953
                      GeneralCommunicationHandler.sendSMS(oppList, veriNew, 'RCU verification'); //US_953
                Map<String,String> agencyMap = new Map<String,String>();
                for(Verification_Agency_Master__c vamRec : vam){
                    agencyMap.put(vamRec.Id,vamRec.Mail_Id__c);
                }
                Map<String,String> cdLst = new Map<String,String>();
                for(ContentDocumentLink cdLnk : [SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN :newveri]){
                    cdLst.put(cdLnk.LinkedEntityId,cdLnk.ContentDocumentId);
                }
                List<ContentVersion> cvLst = [SELECT ContentDocumentId, Title, CreatedDate,versionData FROM ContentVersion WHERE ContentDocumentId IN :(cdLst.values()) LIMIT 25];
                for(Verification__c veriRec : veriNew){
                    emailSent = true;
                    List<String> attIds = new List<String>();
                    for(ContentVersion att : cvLst){
                        if(att.Title.contains(veriRec.Verification_Type__c) && att.ContentDocumentId == cdLst.get(veriRec.Id)){
                            attids.add(att.ContentDocumentId);
                        }
                    }
                   string templateName = 'AutoemailtoRCUAgency'; //US_953
                    Id whatId = veriRec.id;
                    string fromName = 'noreply@bajajfinserv.in';
                    string replyTo = '';
                    string[]toAddresses = new String[]{};
                    String[]CC = new String[]{};
                        if (veriRec.Verification_Agency__c != null && agencyMap.containsKey(veriRec.Verification_Agency__c))
                        toAddresses.add(agencyMap.get(veriRec.Verification_Agency__c));
                    CC.addAll(rcuEmail.split(';'));
                     if (oppList != null && oppList.size() > 0 && oppList[0].Branch_Name__r.Branch_RCU_Email_id__c != null) //US_953
                          cc.addAll((oppList[0].Branch_Name__r.Branch_RCU_Email_id__c).split(',')); //US_953
                    system.debug('toaddresses'+toAddresses);
                    
                    string[]bcc;
                    String Priority = 'Normal';
                    BAFL_EmailServicesLogix.Attachment[]Attachments = new BAFL_EmailServicesLogix.Attachment[]{};
                    string Subject = 'RSA Verification ,'+' LAN No: '+ veriRec.Loan_Application__r.Loan_Application_Number__c +' '+',Product: '+veriRec.Loan_Application__r.product__c +', City: '+veriRec.Loan_Application__r.Branch_City__c;//US_953
                    String CostCenter = 'bajaj';
                    system.debug('before calling'+toAddresses);
                    if (!Test.isRunningTest())
                        GeneralUtilities.SendEmailUsingBAFLLogix(templateName ,whatID,fromName,replyTo,toAddresses,CC,bcc,'Normal',Subject,'bajaj',attids);    
                    
                }
            }
            return 'Success';
        }
        catch(Exception e){
            system.debug('Exception'+e.getMessage()+e.getLineNumber());
            return 'Failure';
        }
    }
    public static String getVerificationData(String oppId,String objectFieldJSON) {
        oppData dss = new oppData();
        dss.picklistData = LighteningUtilities.getPicklistValues(objectFieldJSON);
        List<Opportunity> oppList = [SELECT Product__c,Account.Permanent_City__c,Branch_Name__r.Name from Opportunity where Id =: oppId];
        Opportunity Loan = new Opportunity();
        Loan = oppList[0];
        List<Verification__c> veriList = [SELECT /*20939 s*/Loan_Application__r.Loan_Application_Number__c,Verification_Agency__r.Mail_Id__c,Applicant__c,/*20939 e*/Id,Contact__r.Name,Document_Particulars__c,RSA_Verification_Remark__c,FCU_report_remark__c,Net_Salary__c,Month__c,Salary_Credit_Date__c,Name_of_the_Bank__c,Account_No__c,Upload_status__c,Name_of_the_Branch__c,PAN_Number__c,Address__c,Phone_number__c,Mobile_Number__c,Employer_Name__c,Office_Address_Type__c,Employer_Address__c,Designation__c,Verification_Type__c,Status__c,Verification_Agency__c,Remarks__c,VerificationCategory__c,VerificationRate__c,OpsRemarks__c,NoBill__c
                                          FROM Verification__c WHERE Loan_Application__c=:oppId AND RSA_Reason__c = 'Initiated through RSA'];
        
        List<Verification_Agency_Master__c> lstVAM = [select Id, Name, Mail_Id__c, Verification_Types__c, Verification_Agency_User__c, Product__c, Active_Flag__c, 
                                                      Bank_Name__c, Location__c, Verification_Agency_Type__c,Is_RSA_Agency__c
                                                      FROM Verification_Agency_Master__c where Is_RSA_Agency__c = true AND Product__c includes(: Loan.Product__c) 
                                                      AND ( Location__c = : Loan.Branch_Name__r.Name or Location__c =: Loan.Account.Permanent_City__c )
                                                      AND Verification_Agency_Type__c != 'Fraud' AND (Verification_Agency_User__c = null OR (Verification_Agency_User__c != null AND Verification_Agency_User__r.IsActive = true))
                                                      AND active_flag__c = true];
        dss.veriList = veriList;
        dss.veriAgency = lstVAM;
        List<Id> parentIds = new List<Id>();
        for(Verification__c ver : veriList){
            parentIds.add(ver.Id);
        }
        system.debug('parentIds'+parentIds);
        if(parentIds != null && parentIds.size() > 0)
            dss.veriAtt = [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, IsDeleted, ShareType,
                           ContentDocument.Title, ContentDocument.createdDate, ContentDocument.FileType
                           FROM ContentDocumentLink 
                           WHERE LinkedEntityId IN: parentIds ];
        else
            dss.veriAtt = new List<ContentDocumentLink>();                                    
        return JSON.serialize(dss);
    }
    public static void sendCreditApproveMessage(String oppId,Opportunity oppObj,Boolean journeyPLTB){
        try{       
            String docList='';
            List<Checklist__c> checklists= [select id,DocumentFmlyName__r.Name,Mandatory__c,Deviation_Master__c   from Checklist__c where Loan_Application__c =: oppId And Deviation_Master__c  ='' AND Mandatory__c=true];
            if(!commonutility.isEmpty(checklists)){
                for(Integer i=1;i<=checklists.size();i++){
                    docList=docList+', '+ i+'. '+checklists.get(i-1).DocumentFmlyName__r.Name;
                }
                
            }
            System.debug(docList);
            
            Set<String> setProdRes = new Set<String>();
            String productList = '';
            List<String> listmsg=new List<String>(); 
            
            SMS_Sent__c npsSMS = new SMS_Sent__c();
            if(AtosParameters__c.getValues('ResponsysAPI') != null && AtosParameters__c.getValues('ResponsysAPI').Product__c != null)
                productList = AtosParameters__c.getValues('ResponsysAPI').Product__c;
            setProdRes.addAll(productList.split(';'));
            List<Rack_Rate__c> rrMaster = new List<Rack_Rate__c>();
            rrMaster = [SELECT name,Products__c,SMS_Text__c,Additional_SMS_Text__c,Campaign_Name__c,ReceipientsAPINames__c,resendFlag__c,SMS_Type__c,Dynamic_Parameters__c,isPriority__c,Event__c,Used_For__c from Rack_Rate__c where Event__c = 'SAL LA Approval W Sanc' OR Event__c = 'SAL LA Approval W Sanc CC' LIMIT 2];
            Rack_Rate__c rrRec = new Rack_Rate__c();
            for(Rack_Rate__c rr : rrMaster){
                if(rr.Event__c == 'SAL LA Approval W Sanc' && !journeyPLTB)
                    rrRec = rr;
                else if(rr.Event__c == 'SAL LA Approval W Sanc CC' && journeyPLTB)
                    rrRec = rr;
            }
            String prodSMSMsg=rrRec.SMS_Text__c;
            if(rrRec.Additional_SMS_Text__c != null)
                prodSMSMsg += rrRec.Additional_SMS_Text__c;
            String event;
            Map<String, String> dynPar = new Map<String, String>();
            
            if(setProdRes.contains(oppObj.Product__c) && rrMaster[0].Used_For__c == 'Responsys'){
                
                dynPar.put('P_LAN',oppObj.Loan_Application_Number__c);
                dynPar.put('P_APPROVEDLAN', String.valueOf(oppObj.Loan_Amount_with_Premium__c));
                //dynPar.put('P_APPROVED_RATE', String.valueOf(oppObj.Approved_Rate__c));
                //dynPar.put('P_APPROVED_TENOR', String.valueOf(oppObj.Approved_Tenor__c));
                if(!journeyPLTB){
                    dynPar.put('P_SALESNAME',oppObj.Relationship_Manager__r.Name);
                    dynPar.put('P_SALESMOBILE', oppObj.Relationship_Manager__r.Mobile_number__c);
                }
                if(docList != null && docList != '')
                    dynPar.put('P_Document', docList);
                else
                    dynPar.put('P_Document', 'none');
                
                npsSMS.LoanApplication__c = oppId;
                npsSMS.Name = rrRec.Event__c;
                npsSMS.SMS_Sent_Number__c = String.valueOf(oppObj.Account.Mobile__c);//String.valueOf(oppObj.Account.Mobile__c); 
                npsSMS.Status__c = 'Pending';
                npsSMS.Event__c = rrRec.Campaign_Name__c;
                npsSMS.SMS_Type__c = rrRec.SMS_Type__c;
                npsSMS.SMS_Receiver__c='Primary Applicant';
                //npsSMS.SMS_Text_Sent__c=rrMaster[0].SMS_Text__c+rrMaster[0].Additional_SMS_Text__c;
                npsSMS.SMS_Parameters__c = JSON.serialize(dynPar);
                insert npsSMS;
                System.debug('O '+npsSMS);
                
            }
            if(rrMaster[0].Used_For__c == 'Value First')
            {
                
                prodSMSMsg= prodSMSMsg.replace('**LAN**',oppObj.Loan_Application_Number__c);
                prodSMSMsg= prodSMSMsg.replace('**Loan Amount**',String.valueOf(oppObj.Loan_Amount_with_Premium__c));
                // prodSMSMsg= prodSMSMsg.replace('**ROI**',String.valueOf(oppObj.Approved_Rate__c));
                //prodSMSMsg= prodSMSMsg.replace('**Tenor**', String.valueOf(oppObj.Approved_Tenor__c));
                if(!journeyPLTB){
                    if(!CommonUtility.isEmpty(oppObj.Relationship_Manager__r.Name)){prodSMSMsg= prodSMSMsg.replace('**Sales Name**',oppObj.Relationship_Manager__r.Name);}
                    if(!CommonUtility.isEmpty(oppObj.Relationship_Manager__r.Mobile_number__c)){prodSMSMsg= prodSMSMsg.replace('**Sales Mobile**', oppObj.Relationship_Manager__r.Mobile_number__c);}
                }
                if(docList != null && docList != '')
                    prodSMSMsg= prodSMSMsg.replace('**Documents**',docList);
                else
                    prodSMSMsg= prodSMSMsg.replace('**Collected Document**','none');
                
                npsSMS.LoanApplication__c = oppId;
                npsSMS.Name = rrRec.Event__c;
                npsSMS.SMS_Sent_Number__c = String.valueOf(oppObj.Account.Mobile__c);
                npsSMS.Status__c = 'Sent';
                npsSMS.SMS_Type__c = rrRec.SMS_Type__c;
                npsSMS.SMS_Receiver__c='Primary Applicant';
                if(prodSMSMsg.length() > 255) {
                    npsSMS.SMS_Text_Sent__c = prodSMSMsg.substring(0,255).trim();
                    npsSMS.Additional_SMS_Text_Sent__c = prodSMSMsg.substring(255,prodSMSMsg.length()).trim();
                } else {
                    npsSMS.SMS_Text_Sent__c = prodSMSMsg.trim();  
                }
                //npsSMS.SMS_Text_Sent__c=prodSMSMsg;
                npsSMS.SMS_Sent__c = true;
                npsSMS.SMS_Sent_Time__c = system.now();
                insert npsSMS;
                sendsms.message(String.valueOf(oppObj.Account.Mobile__c), prodSMSMsg);//String.valueOf(oppObj.Account.Mobile__c)
                System.debug('O->  '+npsSMS);
            }
            
        }catch(Exception e){
            System.debug('Exception on sendCreditApproveMessage '+e.getMessage()+e.getLineNumber());
        }   }
    
    public static void sendCreditApproveMessageToCM(String oppId,Opportunity oppObj){
        try{       
            String docList='';
            List<Checklist__c> checklists= [select id,DocumentFmlyName__r.Name,Mandatory__c,Deviation_Master__c   from Checklist__c where Loan_Application__c =: oppId And Deviation_Master__c  ='' AND Mandatory__c=true];
            if(!commonutility.isEmpty(checklists)){
                for(Integer i=1;i<=checklists.size();i++){
                    docList=docList + i+'. '+checklists.get(i-1).DocumentFmlyName__r.Name+'\n';
                }
            }
            System.debug(docList);
            
            Set<String> setProdRes = new Set<String>();
            String productList = '';
            List<String> listmsg=new List<String>(); 
            
            SMS_Sent__c npsSMS = new SMS_Sent__c();
            if(AtosParameters__c.getValues('ResponsysAPI') != null && AtosParameters__c.getValues('ResponsysAPI').Product__c != null)
                productList = AtosParameters__c.getValues('ResponsysAPI').Product__c;
            setProdRes.addAll(productList.split(';'));
            List<Rack_Rate__c> rrMaster = new List<Rack_Rate__c>();
            rrMaster = [SELECT name,Products__c,SMS_Text__c,Additional_SMS_Text__c,Campaign_Name__c,ReceipientsAPINames__c,resendFlag__c,SMS_Type__c,Dynamic_Parameters__c,isPriority__c,Event__c,Used_For__c from Rack_Rate__c where Event__c='SAL LA Approval - Int' LIMIT 2];
            String prodSMSMsg=rrMaster[0].SMS_Text__c;
            if(rrMaster[0].Additional_SMS_Text__c != null)
                prodSMSMsg += rrMaster[0].Additional_SMS_Text__c;
            String event;
            Map<String, String> dynPar = new Map<String, String>();
            
            if(setProdRes.contains(oppObj.Product__c) && rrMaster[0].Used_For__c == 'Responsys'){
                
                dynPar.put('P_LAN',oppObj.Loan_Application_Number__c);
                dynPar.put('P_CUSTOMERNAME',oppObj.Account.Name);
                if(docList != null && docList != '')
                    dynPar.put('P_Collected_Document', docList);
                else
                    dynPar.put('P_Collected_Document', 'none');
                
                
                npsSMS.LoanApplication__c = oppId;
                npsSMS.Name = rrMaster[0].Event__c;
                npsSMS.SMS_Sent_Number__c = String.valueOf(oppObj.Relationship_Manager__r.Mobile_number__c);//String.valueOf(oppObj.Account.Mobile__c); 
                npsSMS.Status__c = 'Pending';
                npsSMS.Event__c = 'S_CREDIT_APPROVALSALES';
                npsSMS.SMS_Type__c = rrMaster[0].SMS_Type__c;
                npsSMS.SMS_Receiver__c='Relationship Manager';
                //npsSMS.SMS_Text_Sent__c=rrMaster[0].SMS_Text__c+rrMaster[0].Additional_SMS_Text__c;
                npsSMS.SMS_Parameters__c = JSON.serialize(dynPar);
                
                System.debug('O '+npsSMS);
                
            }
            if(rrMaster[0].Used_For__c == 'Value First')
            {
                prodSMSMsg= prodSMSMsg.replace('**customer_name**',oppObj.Account.Name);
                prodSMSMsg= prodSMSMsg.replace('**LAN**',oppObj.Loan_Application_Number__c);
                if(docList != null && docList != '')
                    prodSMSMsg= prodSMSMsg.replace('**Collected Document**',docList);
                else
                    prodSMSMsg= prodSMSMsg.replace('**Collected Document**','none');
                
                
                
                npsSMS.LoanApplication__c = oppId;
                npsSMS.Name = rrMaster[0].Event__c;
                npsSMS.SMS_Sent_Number__c = String.valueOf(oppObj.Relationship_Manager__r.Mobile_number__c);
                npsSMS.Status__c = 'Sent';
                npsSMS.SMS_Type__c = rrMaster[0].SMS_Type__c;
                npsSMS.SMS_Sent_Time__c = system.now();
                npsSMS.SMS_Receiver__c='Relationship Manager';
                if(prodSMSMsg.length() > 255) {
                    npsSMS.SMS_Text_Sent__c = prodSMSMsg.substring(0,255).trim();
                    npsSMS.Additional_SMS_Text_Sent__c = prodSMSMsg.substring(255,prodSMSMsg.length()).trim();
                } else {
                    npsSMS.SMS_Text_Sent__c = prodSMSMsg.trim();  
                }
                //npsSMS.SMS_Text_Sent__c=prodSMSMsg;
                npsSMS.SMS_Sent__c = true;
                sendsms.message(String.valueOf(oppObj.Relationship_Manager__r.Mobile_number__c), prodSMSMsg);//String.valueOf(oppObj.Account.Mobile__c)
                System.debug('O->  '+npsSMS);
            }
            
            if(npsSMS != null)
                insert npsSMS;
        }catch(Exception e){
            System.debug('Exception on sendCreditApproveMessageToCM '+e.getMessage()+e.getLineNumber());
        }   }
    
    @future(callout=true)
    public static void sendCreditApproveMailToCM(String oppId,Boolean callCenter){
        try{     
            String custBody = '';
            String intBody = '';
            Opportunity oppObj = new Opportunity();
            List<EmailTemplate> emailTemp = [SELECT Id,HTMLValue,Body,Name from EmailTemplate where Name = 'SAL LA Approve- Int' OR Name = 'SAL LA Approve-Cust'];
            for(EmailTemplate em : emailTemp){
                if(em.Name == 'SAL LA Approve- Int'){
                    intBody = em.HTMLValue;
                }
                else if(em.Name == 'SAL LA Approve-Cust'){
                    custBody = em.HTMLValue;
                }
            }
            List<Opportunity> oppList = [SELECT Application_Source__c ,Account.Current_Email_Id__c,Relationship_Manager__r.Mobile_number__c,Relationship_Manager__r.Name,Relationship_Manager__r.Email,Approved_Tenor__c,Loan_Application_Number__c,Approved_Rate__c,Approved_Loan_Amount__c,Account.name from Opportunity where Id =: oppid]; //22624 Sprint 5C Application_Source__c  Added
            if(oppList != null && oppList.size() > 0)
                oppObj = oppList[0];
            String docList='';
            List<Checklist__c> checklists= [select id,DocumentFmlyName__r.Name,Mandatory__c,Deviation_Master__c   from Checklist__c where Loan_Application__c =: oppId And Deviation_Master__c  ='' AND Mandatory__c=true];
            if(!commonutility.isEmpty(checklists)){
                for(Integer i=1;i<=checklists.size();i++){
                    docList=docList+ i+'. '+checklists.get(i-1).DocumentFmlyName__r.Name+'<br />';
                }
            }
            if(!callCenter){
                if(intBody != null){
                    intBody = intBody.replace('"','\\"');
                    intBody = intBody.replaceAll('<p>\\s','<p>');
                    intBody = intBody.trim();
                    intBody = intBody.replaceAll('(\\s+)', ' ');
                    if(oppObj.Approved_Rate__c != null)
                        intBody = intBody.replace('**ROI**',String.valueOf(oppObj.Approved_Rate__c));
                    if(oppObj.Approved_Tenor__c != null)
                        intBody = intBody.replace('**Tenor**', String.valueOf(oppObj.Approved_Tenor__c));
                    if(oppObj.Approved_Loan_Amount__c != null)
                        intBody = intBody.replace('**Loan Amount**',String.valueOf(oppObj.Approved_Loan_Amount__c));
                    intBody = intBody.replace('**LAN**',oppObj.Loan_Application_Number__c);
                    intBody = intBody.replace('**Customer Name**',oppObj.Account.Name);
                    intBody = intBody.replace('**PSFName**',oppObj.Relationship_Manager__r.Name);
                    if(docList != null && docList != '')
                        intBody = intBody.replace('**DocList**','Request you to please connect with the customer to complete the following:<br />'+docList);
                    else
                        intBody = intBody.replace('**DocList**',' ');
                }
                string[]toAddresses = new String[]{};
                    toAddresses.add(oppObj.Relationship_Manager__r.Email);
                String[]CC;
                string[]bcc;
                string Subject = 'Congratulations! loan appllication '+oppObj.Loan_Application_Number__c +'for '+oppObj.Account.Name +'approved';
                system.debug('Body is'+intBody);
                system.debug('To addresses'+toAddresses);
                BAFL_EmailServicesLogix.EmailServicesPort stub = new BAFL_EmailServicesLogix.EmailServicesPort();
                stub.timeout_x = 120000;
                BAFL_EmailServicesLogix.SendEmailResponse er = stub.SendEmail('noreply@bajajfinserv.in',
                                                                              'otpofficeemailverification@6hifw8v4ew6qa26r5whiw37rq2yorch4vylpptp0njgfwqxjc.o-51mo2mam.cs5.apex.sandbox.salesforce.com',
                                                                              toAddresses,
                                                                              CC,
                                                                              bcc,
                                                                              'Normal',
                                                                              new BAFL_EmailServicesLogix.Attachment[]{},
                                                                              Subject,                    
                                                                              intBody,
                                                                              'bajaj');
                //////////Send mail to customer Start
                
            }
            if(custBody != null){
                custBody = custBody.replace('"','\\"');
                custBody = custBody.replaceAll('<p>\\s','<p>');
                custBody = custBody.trim();
                custBody = custBody.replaceAll('(\\s+)', ' '); 
                custBody = custBody.replace('**LAN**',oppObj.Loan_Application_Number__c);
                custBody = custBody.replace('**Customer Name**',oppObj.Account.Name);
                if(oppObj.Approved_Loan_Amount__c != null)
                    custBody=custBody.replace('**Loan Amount**',String.valueOf(oppObj.Approved_Loan_Amount__c));
                if(oppObj.Approved_Rate__c != null)
                    custBody=custBody.replace('**ROI**',String.valueOf(oppObj.Approved_Rate__c));
                if(oppObj.Approved_Tenor__c != null)
                    custBody=custBody.replace('**Tenor**',String.valueOf(oppObj.Approved_Tenor__c));
                custBody=custBody.replace('**Sales Name**',String.valueOf(oppObj.Relationship_Manager__r.Name));
                custBody=custBody.replace('**Sales Mobile**',String.valueOf(oppObj.Relationship_Manager__r.Mobile_number__c));       
                if(docList != null && docList != '')
                    custBody = custBody.replace('**Documents**','We request you to keep the following document handy:<br />'+docList);
                else
                    custBody=custBody.replace('**Documents** ','');
            }
            string[]toAddressesCust = new String[]{};
                toAddressesCust.add(oppObj.account.current_email_id__c);
            String[]CC1;
            string[]bcc1;
            string Subject1 = 'Loan appllication '+oppObj.Loan_Application_Number__c+' is approved';
            system.debug('Body is'+intBody);
            system.debug('To addresses'+toAddressesCust);
            BAFL_EmailServicesLogix.EmailServicesPort stub1 = new BAFL_EmailServicesLogix.EmailServicesPort();
            stub1.timeout_x = 120000;
            BAFL_EmailServicesLogix.SendEmailResponse er1 = stub1.SendEmail('noreply@bajajfinserv.in',
                                                                            'otpofficeemailverification@6hifw8v4ew6qa26r5whiw37rq2yorch4vylpptp0njgfwqxjc.o-51mo2mam.cs5.apex.sandbox.salesforce.com',
                                                                            toAddressesCust,
                                                                            CC1,
                                                                            bcc1,
                                                                            'Normal',
                                                                            new BAFL_EmailServicesLogix.Attachment[]{},
                                                                            Subject1,                    
                                                                            custBody,
                                                                            'bajaj');
            
            
            
            
        }catch(Exception e){
            System.debug('Exception on sendCreditApproveMessageToCM '+e.getMessage()+e.getLineNumber());
        }   
    }
    @auraEnabled
    public static String callIM(string oppId){
        try{
            Map < String, String > mapOfInputVerifications = new Map < String, String > ();
            De_Dupe__c dedupeObj;
            Map<String,Object> resultofIM=new Map<String,Object>();
            String imScore='',demog_changes_action='',existing_customer_demog_chenges='',aiding_underwritter='',suspacted_pan_score='',verificationType='',geo_tagging_location='',date_of_first_loan='',sanctioned_amount='0';
            List<Opportunity> oppList=[SELECT Account.Type_of_Salary__c,Sourcing_Channel__r.Channel_Category__c,Account.epfo_result__c,Account.PANNumber__c,Account.Mobile__c,Account.Date_of_Birth__c,Account.Type_of_Educational_Institution__c,Account.Qualification__c,Account.Total_Work_Experience_Yrs__c,Account.Total_Work_Experience_Months__c,/*22307*/Consider_for_Re_Appraisal__c,POS__c,/*US 524 s*/CUSTOMER__r.Demog_Error__c,/*US 524 e*/CUSTOMER__c,/*Bug id 20939 RCU start*/Loan_Amount_with_Premium__c,Account.DesignationOTP__c,Customer__r.Name,CUSTOMER__r.PAN_Demog__c,CUSTOMER__r.Mobile_Demog__c,CUSTOMER__r.DOB_Demog__c,CUSTOMER__r.Bank_account_number_demog__c,CUSTOMER__r.Residence_demog__c,CUSTOMER__r.Last_Modified_date_Demog__c,Existing_Customer__c, Link_Offer_id__c,Account.Offer_Inhanced__c,/*Bug id 20939 end*/Created_Time__c, /*Pricing*/Area_SM__c, /*Pricing*/IFSC_Code__c ,A_C_No__c, Mode_of_Disbursal__c, Bank_Name__c, Account_Holder_Name__c, Favouring__c,MICR_Number__c ,Repayment_Account_Holder_Name__c, Bank_A_c_No_of_Customer__c, Repayment_Bank_Name__c, Repayment_Mode__c, First_Due_Date__c,  A_C_Type__c, Account.Flow__c,Relationship_Manager__c,Tenor__c,Approved_Rate__c,EMI_CAM__c,Requested_ROI__c,Sourcing_Channel__r.Id,Sourcing_Channel__r.Reporting_Manager__c,id,Industry__r.Industry__c,Offer_Amount__c,Reject_Reason__c,Name,StageName,Telecaller_Name__c,Customer_Type__c, Product__c,Main_Sub_Industry__c,Branch_Name__c,Branch_Name__r.SAL_Branch_Type__c, LAN__c, AccountId, Quality_Check_Status__c, Sourcing_Channel__c, Sourcing_Channel__r.Name, Referral__c, Referral__r.Name, Application_Source__c, Loan_Application_Number__c,Type_Of_Loan__c,COO_Comments__c,Approved_Loan_Amount__c,Scheme_Master__r.Name,Scheme_Master__r.IsHybridFlexi__c,Approved_Tenor__c,Processing_Fees__c,Branch_Name__r.name,/*US_982*/If_Yes__c,End_Use__c,/*US_982*/
                                       (select id from Product_Offerings__r),
                                       (select  /*20939 RCU s*/Month1__c,Month2__c,Month3__c,/*20939 RCU e*/ id,LAP_EMI__c,EMI_on_Proposed_Loan_TO__c,Avg_qtrly_incentive__c,Average_incentive_for_Q1__c,Average_incentive_for_Q3__c,Average_incentive_for_Q2__c,Maxi_EMI_Cust__c,Max_Loan_Amnt_as_p_NAS_Multip_PL_Oblig__c,Average_Monthly_Net_Income1__c,Applicable_FOIR1__c,Loan_Application__c,EMI_of_The_Loan__c,Receips5_Doc__c,Receips6_Doc__c,Unsecured_FOIR__c,Eligible_FOIR__c,Total_Mthly_Oblig__c,EMI__c,ROI__c,sal_max_loan__c,Net_Salary_for_Month1__c,Net_Salary_for_Month2__c,Net_Salary_for_Month3__c,Proposed_Loan_Amt__c,Tenor__c,Eligible_Loan__c,Monthly_Reimbursement__c,Avg_mthly_incntve_3mts__c,Rental_Income__c,Receips4_Doc__c,Existing_HL_EMI__c,Month1_Doc__c,Month2_Doc__c,Month3_Doc__c,LAP_pmt__c,Avg_monthly_incentive1__c,Avg_monthly_incentive2__c,Avg_monthly_incentive3__c,Incentive_Monthly_or_Quarterly__c 
                                        ,/*24997 s*/Gross_Salary_Month1__c,Gross_Salary_Month2__c,Gross_Salary_Month3__c/*24997 e*/ from CAMs__r),
                                       /*Bug 20939 s*/(select id,name,Policy_Name__c,Remarks__c,Disposition_Status__c,Checklist_Policy_Status__c from SOL_Policys__r),/*Bug 20939 e*/
                                       (select Loan_Amount__c,Final_EMI__c,Status__c,Obligation__c,Financers__c,Loan_Type__c,POS__c,EMI__c from Existing_Loan_Details__r),
                                       (select /*20939 s*/Existing_cust_demog_change__c,Demog_change_action__c,/*20939 e*/ Customer_Status__c,Dedupe_Source__c,Source_Or_Target__c from De_Dupes__r),
                                       (select Salary_Credit_Date1__c,Salary_Credit_Date2__c,Salary_Credit_Date3__c,Perfios_inwardChqBounces__c,Perfios_inwardECSBounces__c,Perfios_Bank_Name__c,Bank_Name__c,Perfios_Flag__c,Source_Of_Data__c,Authenticity__c from Bank_Account__r),
                                       (select id from Verification__r) 
                                       
                                       from Opportunity where id = : oppId];
            
            List<Applicant__c> appList = [select  /*5220 s*/ App_Pan_String__c, /*5220 s*/aiding_underwritter__c,suspacted_pan_score__c,Score_card__c,/*Ekyc Start */eKYC_Processing__c,Proof_of_Registered_Address_Submitted__c,HashCode__c,/*Ekyc stop */id,Risk_Segmentation__c,Contact_Name__r.Years_At_Residence__c, Contact_Name__r.office_no_check_on_company_site__c, Contact_Name__r.SFDC_Dedupe_check__c, Contact_Name__r.PAN_Response__c, Contact_Name__r.Linkedin_check_result__c, Contact_Name__r.Google_check_result__c, Contact_Name__r.PAN__c, Contact_Name__r.Last_Modified_Date__c, Contact_Name__r.Name_of_the_PAN_holder__c, Contact_Name__r.Employer__r.Domain_Name__c, Contact_Name__r.Employer__r.Company_Category__c, Existing_Customer__c, Owned_Residence__c, Is_spouse_Working_Financial_CoApp__c, Loan_Application__r.Scheme_Master__c, Name, Contact_Name__r.Mobile__c, Loan_Application__r.Requested_ROI__c, Loan_Application__r.Sourcing_Channel__r.branch__c, Loan_Application__r.Referral__c, Loan_Application__r.Existing_Customer__c, Loan_Application__r.Account.Sourcing_Channel__r.branch__c, Update_CIBIL_Error__c, Descriptin__c, Type_of_Borrower__c, Re_Initiate_De_Dupe__c, Integrate_with_CIBIL__c, Contact_Name__c, Contact_Name__r.Name, Contact_Name__r.Customer_Profile__c,
                                          Contact_Name__r.Designation__c,Codified_CIBIL__c, Contact_Name__r.Employer_Name__c, Contact_Name__r.Qualification__c, Contact_Name__r.Address_1__c, Contact_Name__r.Total_Work_Experience_Yrs__c, Contact_Name__r.Current_experiance_in_Years__c,
                                          PD_Status__c, Bank_Status__c, FINANCIAL_VERIFICATION__c, Contact_Name__r.Address_2__c, FCU_Status__c, ITR_Status__c, Office_SE_Status__c, Office_SAL_Status__c, Contact_Name__r.Company_Category__c,
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
                                          Tele_PD__c, Physical_PD__c, CLINIC_HOSPITAL__c, PAN_Number__c, Employer_Check__c, PAN_Check__c ,RSA_flag__c,RSA_Loan_application_status__c,RSA_Remarks__c,Degree_Status__c,Khata_Certificate_Status__c,
                                          Plan_Status__c,Commencement_Certificate_Status__c,Address_Proof_Status__c,Shop_Act_License_Status__c,Occupation_Certificate_Status__c,Property_Tax_Receipt_Status__c,Verification_ID_Proof_Status__c,Vehicle_Registration_number__c,Vehicle_Registration_date__c,CKYC_No__c,Identity_Document_No__c,Identity_Document_Expiry_Date__c,Proof_of_Address_Submitted_for_Permanent__c,Proof_of_Identity__c,DeDupe_Counter__c, movedToCibilTemp__c,Drop_Line_Flexi_Period__c,Office_Email_Id_Verified__c,Domain_Check_Result__c,IP_Address_Timestamp__c,(SELECT 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             Date_Opened1__c,Date_Opened2__c,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             Date_Opened3__c,Date_Opened4__c,Date_Opened5__c,Date_Opened6__c,Date_Opened7__c,Date_Opened8__c,Date_Opened9__c,Date_Opened10__c,Date_Opened11__c,Date_Opened12__c,Date_Opened13__c,Date_Opened14__c,Date_Opened15__c,Date_Opened16__c,Date_Opened17__c,Date_Opened18__c,Date_Opened19__c,Date_Opened_CIBIL_Offer__c,Date_Opened__c,Date_Processed__c,Sanction_Amount1__c,Sanction_Amount2__c,Sanction_Amount3__c,Sanction_Amount4__c,Sanction_Amount5__c,Sanction_Amount6__c,Sanction_Amount7__c,Sanction_Amount8__c,Sanction_Amount9__c,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             Sanction_Amount10__c,Sanction_Amount11__c,Sanction_Amount12__c,Sanction_Amount13__c,Sanction_Amount14__c,Sanction_Amount15__c,Sanction_Amount16__c,Sanction_Amount17__c,Sanction_Amount18__c,Sanction_Amount19__c,Sanction_Amount__c
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             FROM CIBILs__r LIMIT 1),(select id,Existing_cust_demog_change__c,Demog_change_action__c from De_Dupes__r where Source_Or_Target__c='Source' ),( select id,Date_Opened29__c, Date_Opened28__c, Date_Opened27__c, Date_Opened26__c, Date_Opened25__c,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            Date_Opened24__c, Date_Opened23__c, Date_Opened22__c, Date_Opened21__c, Date_Opened20__c, Sanction_Amount20__c, Sanction_Amount21__c, Sanction_Amount22__c, Sanction_Amount23__c, Sanction_Amount24__c, Sanction_Amount25__c, Sanction_Amount26__c, Sanction_Amount27__c, Sanction_Amount28__c, Sanction_Amount29__c
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            From CIBIL_Extension__r) 
                                          from Applicant__c where Loan_Application__c =: oppId  and Applicant_Type__c= 'Primary' LIMIT 1 ];
            Map<String,Object> rcuMap = CommonUtility.getMapFromStaticResource('SalariedCustomSettings','RCU Processes');
            String UnsecuredLoans = '',businessloans = '',hlLoans = '';
            unsecuredLoans = (String)rcuMap.get('Unsecured Loans');
            businessLoans = Label.Business_Loans;
            hlLoans = (String)rcuMap.get('HL/PL Loans');
            String hl = 'no',bl = 'no',unsecLoan = 'no';    
            Decimal hlAmt = 0.0,unsecAmt = 0.0;     
            oppData dss = new oppData();
            if(appList != null && appList.size() > 0)
                dss.applicantPrimary = appList[0];
            if(oppList[0].Bank_Account__r != null && oppList[0].Bank_Account__r.size() > 0)
                dss.bankObj= oppList[0].Bank_Account__r[0];
            if(oppList[0].CAMs__r != null && oppList[0].CAMs__r.size() > 0)
                dss.camObj= oppList[0].CAMs__r[0];
            if(opplist != null && opplist.size() > 0)
                dss.opp=opplist[0];
            
            if(!CommonUtility.isEmpty(dss.applicantPrimary) && !CommonUtility.isEmpty(dss.applicantPrimary.CIBIL_Extension__r) ){
                dss.cibilExt = dss.applicantPrimary.CIBIL_Extension__r[0];
            }
            if(!CommonUtility.isEmpty(dss.applicantPrimary) && !CommonUtility.isEmpty(dss.applicantPrimary.CIBILs__r) ){
                dss.cibilobj  = dss.applicantPrimary.CIBILs__r[0];
            }  
            if(!CommonUtility.isEmpty(dss.applicantPrimary) && !CommonUtility.isEmpty(dss.applicantPrimary.De_Dupes__r) ){
                dedupeObj  = dss.applicantPrimary.De_Dupes__r[0];
            }  
            for(Existing_Loan_Details__c ext : dss.opp.Existing_Loan_Details__r){
                if(ext.Loan_Type__c != null && ext.Loan_Type__c != ''){
                    if(hlLoans.indexOf(ext.Loan_Type__c) != -1){
                        hl = 'yes';
                        if(ext.Loan_Amount__c > hlAmt)
                            hlAmt = ext.Loan_Amount__c;
                    }
                    if(businessLoans.indexOf(ext.Loan_Type__c) != -1){
                        bl = 'yes';
                    }
                    if(unsecuredLoans.indexOf(ext.Loan_Type__c) != -1){ 
                        unsecLoan = 'yes';
                        if(ext.Loan_Amount__c > unsecAmt)
                            unsecAmt = ext.Loan_Amount__c;
                    }
                }
            }
            if(!CommonUtility.isEmpty(dss.cibilobj)){
                Date MinDate =  dss.cibilobj.Date_Opened__c;
                String dateOpenedNext;
                for(integer j=1;j<=19;j++){
                    dateOpenedNext= 'Date_Opened'+j+'__c';
                    if(MinDate > Date.valueof( dss.cibilobj.get(dateOpenedNext)))
                    {
                        MinDate=Date.valueof( dss.cibilobj.get(dateOpenedNext));
                    } 
                }
                Date MinDateFromCibilExtsn =  dss.cibilExt.Date_Opened20__c;   
                for(integer j=21;j<=29;j++){
                    dateOpenedNext= 'Date_Opened'+j+'__c';
                    if(dss.cibilExt != null && dss.cibilExt.get(dateOpenedNext) != null){
                        if(MinDateFromCibilExtsn > Date.valueof( dss.cibilExt.get(dateOpenedNext)))
                        {
                            MinDateFromCibilExtsn=Date.valueof( dss.cibilExt.get(dateOpenedNext));
                        } 
                    }
                }
                System.debug('min date='+ MinDate+' _____  '+MinDateFromCibilExtsn+'  ');
                if(MinDate!=null && MinDateFromCibilExtsn!=null)
                    date_of_first_loan=String.valueOf((MinDate<MinDateFromCibilExtsn)?MinDate:MinDateFromCibilExtsn);
                if(MinDate==null && MinDateFromCibilExtsn!=null)
                    date_of_first_loan=String.valueOf(MinDateFromCibilExtsn);
                if(MinDateFromCibilExtsn==null && MinDate!=null)
                    date_of_first_loan=String.valueOf(MinDate);
                
                Decimal MaxAmount =  dss.cibilobj.Sanction_Amount__c;
                String amountNext;
                for(integer j=1;j<=19;j++){
                    amountNext= 'Sanction_Amount'+j+'__c';
                    if(dss.cibilobj.get(amountNext) !=null && MaxAmount < Decimal.valueof(''+dss.cibilobj.get(amountNext)))
                    {
                        MaxAmount=Decimal.valueof(''+dss.cibilobj.get(amountNext));
                    } 
                }
                Decimal MaxAmountFromCibilExtsn =  dss.cibilExt.Sanction_Amount20__c;   
                for(integer j=21;j<=29;j++){
                    amountNext= 'Sanction_Amount'+j+'__c';
                    if(dss.cibilExt != null && dss.cibilExt.get(amountNext) !=null  && MaxAmountFromCibilExtsn > Decimal.valueof(''+dss.cibilExt.get(amountNext)))
                    {
                        MaxAmountFromCibilExtsn=Decimal.valueof(''+dss.cibilExt.get(amountNext));
                    } 
                }
                System.debug('Max Amount='+ MaxAmount+' _____  '+MaxAmountFromCibilExtsn+'  ');
                if(MaxAmount==0 && MaxAmountFromCibilExtsn>0)
                    sanctioned_amount =String.valueOf((MaxAmount<MaxAmountFromCibilExtsn)?MaxAmount:MaxAmountFromCibilExtsn);
                if(MaxAmount==0  && MaxAmountFromCibilExtsn>0)
                    sanctioned_amount=String.valueOf(MaxAmountFromCibilExtsn);
                if(MaxAmountFromCibilExtsn==0 && MaxAmount>0)
                    sanctioned_amount=String.valueOf(MaxAmount);
                
                
            }
            
            
            List<Contact> conList = [ select id,Employer__r.Company_Category__c,Address_1__c,Address_2__c,Address_3__c,Pin_Code__c,Residence_City__c,State__c,Office_Email_sent__c,Residence_Type__c,Sex__c from Contact where id=: dss.applicantPrimary.Contact_Name__r.id];
            dss.objCon = conList[0];
            
            List<Verification__c> veriList = [select id, Month__c, name, Status__c, Verification_Type__c,Credit_Status__c,Geo_Tagging__c,Image_Latitude_Longitude_Details__c from Verification__c where Loan_Application__c = : oppId And Geo_Tagging__c=true ]; 
            String geo_tagging_flag='';
            if(veriList !=null && veriList.size()>0) 
            {
                geo_tagging_flag='true';
            }
            else
                geo_tagging_flag='false';
            for(Verification__c vobj:veriList)
            {
                if(vobj.Verification_Type__c=='Office verification' && vobj.Geo_Tagging__c==true)
                    geo_tagging_location='Office';
                if(vobj.Verification_Type__c=='Residence verification' && vobj.Geo_Tagging__c==true)
                    geo_tagging_location='Residence';
            }
            Decimal salaryAvg=0;
            if(dss.camObj != null && dss.camObj.Average_incentive_for_Q1__c  != null)
                salaryAvg+=dss.camObj.Average_incentive_for_Q1__c;
            if(dss.camObj != null && dss.camObj.Average_incentive_for_Q2__c  != null)
                salaryAvg+=dss.camObj.Average_incentive_for_Q2__c;
            if(dss.camObj != null && dss.camObj.Average_incentive_for_Q3__c  != null)
                salaryAvg+=dss.camObj.Average_incentive_for_Q3__c;
            if(salaryAvg>0)
                salaryAvg=(salaryAvg/3).setScale(2);
            
            Decimal totalworkexp=0.0;
            if(dss.opp.Account.Total_Work_Experience_Yrs__c != null)
                totalworkexp+=Decimal.valueOf(dss.opp.Account.Total_Work_Experience_Yrs__c);    
            if(dss.opp.Account.Total_Work_Experience_Months__c != null)
                totalworkexp+=(Decimal.valueof(dss.opp.Account.Total_Work_Experience_Months__c)/12.0).setScale(2); 
            String address ='';
            if(dss.objCon != null && dss.objCon.Address_1__c  != null)
                address+=dss.objCon.Address_1__c;
            if(dss.objCon != null && dss.objCon.Address_2__c  != null)
                address+=dss.objCon.Address_2__c;
            if(dss.objCon != null && dss.objCon.Address_3__c  != null)
                address+=dss.objCon.Address_3__c;
            if(dss.objCon != null && dss.objCon.Pin_Code__c  != null)
                address+=dss.objCon.Pin_Code__c;
            if(dss.objCon != null && dss.objCon.Residence_City__c  != null)
                address+=dss.objCon.Residence_City__c;
            if(dss.objCon != null && dss.objCon.State__c  != null)
                address+=dss.objCon.State__c;
            System.debug('Hi Check'+dss.opp.Account.PANNumber__c);
            mapOfInputVerifications.put('pan_number',dss.opp.Account.PANNumber__c != null ? String.valueof(dss.opp.Account.PANNumber__c) : '');
            mapOfInputVerifications.put('cibil_score', dss.applicantPrimary != null && dss.applicantPrimary.CIBIL_Score__c != null ? String.valueof(dss.applicantPrimary.CIBIL_Score__c) : '0');
            mapOfInputVerifications.put('date_of_first_loan',date_of_first_loan!=null ? date_of_first_loan : '' );
            mapOfInputVerifications.put('loan_type',dss.opp != null && dss.opp.Type_Of_Loan__c  != null ? String.valueof(dss.opp.Type_Of_Loan__c) : '');
            mapOfInputVerifications.put('sanctioned_amount',sanctioned_amount);
            mapOfInputVerifications.put('total_work_exp',String.valueof(totalworkexp));
            mapOfInputVerifications.put('sourcing_channel_risk',dss.opp != null && dss.opp.Sourcing_Channel__r.Channel_Category__c  != null ? String.valueof(dss.opp.Sourcing_Channel__r.Channel_Category__c) : '');
            mapOfInputVerifications.put('company_category', dss.objCon != null && dss.objCon.Employer__r.Company_Category__c  != null ? String.valueof(dss.objCon.Employer__r.Company_Category__c) : '');
            mapOfInputVerifications.put('designation',dss.opp.Account.DesignationOTP__c != null ? String.valueof(dss.opp.Account.DesignationOTP__c) : '' );
            mapOfInputVerifications.put('salary_identified_through_perfios',dss.opp.Account.Type_of_Salary__c!= null ? String.valueof(dss.opp.Account.Type_of_Salary__c) : '');
            mapOfInputVerifications.put('qualification',dss.opp.Account.Qualification__c != null ? String.valueof(dss.opp.Account.Qualification__c) : '');
            mapOfInputVerifications.put('edu_institute',dss.opp.Account.Type_of_Educational_Institution__c != null ? String.valueof(dss.opp.Account.Type_of_Educational_Institution__c) : '');
            mapOfInputVerifications.put('offer_type',dss.opp.Account.Offer_Inhanced__c != null && dss.opp.Account.Offer_Inhanced__c ? 'enhanced' : '');
            mapOfInputVerifications.put('mobile',dss.opp.CUSTOMER__r.Mobile_Demog__c != null ? 'true' : 'false');
            mapOfInputVerifications.put('bank_account',dss.opp.CUSTOMER__r.Bank_account_number_demog__c != null ? 'true' : 'false');
            mapOfInputVerifications.put('pan',dss.opp.CUSTOMER__r.PAN_Demog__c != null ? 'true' : 'false');
            mapOfInputVerifications.put('dob',dss.opp.CUSTOMER__r.DOB_Demog__c != null ? 'true' : 'false');
            mapOfInputVerifications.put('resi_addr',dss.opp.CUSTOMER__r.Residence_demog__c != null ? 'true' : 'false');
            mapOfInputVerifications.put('perfios_response_flag',dss.bankObj != null && dss.bankObj.Perfios_Flag__c  != null ? String.valueof(dss.bankObj.Perfios_Flag__c) : '');
            mapOfInputVerifications.put('bank_name',dss.bankObj != null && dss.bankObj.Bank_Name__c  != null ? String.valueof(dss.bankObj.Bank_Name__c) : '');
            mapOfInputVerifications.put('source_of_data',dss.bankObj != null && dss.bankObj.Source_Of_Data__c  != null ? String.valueof(dss.bankObj.Source_Of_Data__c) : '');
            mapOfInputVerifications.put('authenticity_score',dss.bankObj != null && dss.bankObj.Authenticity__c  != null ? String.valueof(dss.bankObj.Authenticity__c) : '0');
            mapOfInputVerifications.put('branch_name',dss.opp.Branch_Name__r.name  != null ? String.valueof(dss.opp.Branch_Name__r.name  ) : '');
            mapOfInputVerifications.put('date_of_birth',dss.opp.Account.Date_of_Birth__c != null ? String.valueof(dss.opp.Account.Date_of_Birth__c) : '');
            mapOfInputVerifications.put('salary',String.valueOf(salaryAvg));
            mapOfInputVerifications.put('email_triggered',dss.applicantPrimary.Office_Email_Id_Verified__c != null && dss.applicantPrimary.Office_Email_Id_Verified__c? 'Yes' : 'No');
            mapOfInputVerifications.put('domain_check',dss.applicantPrimary != null && dss.applicantPrimary.Domain_Check_Result__c != null ? String.valueof(dss.applicantPrimary.Domain_Check_Result__c) : '');
            
            mapOfInputVerifications.put('EPFO_api_response',dss.opp.Account.epfo_result__c != null ? String.valueof(dss.opp.Account.epfo_result__c) : '');
            mapOfInputVerifications.put('residential_type',dss.objCon != null && dss.objCon.Residence_Type__c  != null ? String.valueof(dss.objCon.Residence_Type__c) : '');
            mapOfInputVerifications.put('address_change_flag','NO');  
            mapOfInputVerifications.put('geo_tagging_location',geo_tagging_location);
            mapOfInputVerifications.put('geo_tagging_flag',geo_tagging_flag);
            mapOfInputVerifications.put('HL_PL',hl);
            mapOfInputVerifications.put('HL_PL_amount',String.valueof(hlAmt));
            mapOfInputVerifications.put('unsecured_loan',unsecLoan);
            mapOfInputVerifications.put('unsecured_loan_amount',String.valueof(unsecAmt));
            mapOfInputVerifications.put('business_loan',bl);
            System.debug(mapOfInputVerifications);
            
            BRECallout breObj=new BRECallout();
            resultofIM=breObj.callIM(mapOfInputVerifications);  
            if(resultofIM!=null &&   !CommonUtility.isEmpty(resultofIM) )
            {   
                imScore=String.valueOf(resultofIM.get('IM_score'));
                System.debug('Imscore is '+imScore);
                dss.applicantPrimary.Score_card__c=Decimal.valueOf(imScore);
                aiding_underwritter=String.valueOf(resultofIM.get('aiding_underwritter'));
                dss.applicantPrimary.aiding_underwritter__c=aiding_underwritter;
                suspacted_pan_score=String.valueOf(resultofIM.get('suspacted_pan_score'));
                dss.applicantPrimary.suspacted_pan_score__c=suspacted_pan_score;
                demog_changes_action=String.valueOf(resultofIM.get('demog_changes_action'));
                system.debug('dedupe obj is'+demog_changes_action);
                if(dedupeObj!=null){
                    existing_customer_demog_chenges=String.valueOf(resultofIM.get('existing_customer_demog_chenges'));
                    dedupeObj.Existing_cust_demog_change__c=String.valueOf(existing_customer_demog_chenges);
                    dedupeObj.Demog_change_action__c=String.valueOf(demog_changes_action);
                    system.debug('action is'+existing_customer_demog_chenges);
                    upsert dedupeObj;
                }
                
                 /*5220 s */
                system.debug('LENGTH_SWAP@@@ '+(resultofIM.get('pan_IM_Score_list')));
                if(!commonutility.isEmpty(String.valueOf(resultofIM.get('pan_IM_Score_list')))){
                    
                    // system.debug('LENGTH_SWAP'+lengthBRE);
                    List<Object> panScores = (List<Object>)resultofIM.get('pan_IM_Score_list');
                    dss.applicantPrimary.App_Pan_String__c=JSON.serialize(panScores);
                }
                /*5220 e*/
                
                upsert dss.applicantPrimary; 
            }  
            //resultofIM.put('verification_Type','BANK STATEMENT,OFFICE SETUP,Residence Verification');
            if(!CommonUtility.isEmpty(resultofIM) && !CommonUtility.isEmpty(resultofIM.get('verification_Type')))
            {
                
                verificationType=String.valueOf(resultofIM.get('verification_Type'));
                //List<Verification__c> vList = [ select id, Verification_Type__c, Initiated_by_invisible_monitoring__c from Verification__c where Initiated_by_invisible_monitoring__c=true AND Loan_Application__c=: oppId ];
                //if(vList!=null && vList.size()>0) 
                //{
                   // delete vList;
                //}
                COVerificationController classObj = new COVerificationController('MobilityV2 IM',oppId);
                List<String> verificationCodes = verificationType.split(',');
                classObj.verificationCodes  = verificationCodes;
                
                classObj.processVerificationRecords(dss.opp,dss.applicantPrimary);
                
                /*Verification__c veriObj=new Verification__c();
veriObj.Loan_Application__c  =oppId;
veriObj.Initiated_by_invisible_monitoring__c=true;
veriObj.Verification_Type__c =verificationType;
insert veriObj;*/
            }  
            // till here
            //SOL POLICY CREATION OF IM
            List<SOL_Policy__c> SOLPolicyList=[select id,Remarks__c,Disposition_Status__c,Old_Address_Value__c, Policy_Name__c,Checklist_Policy_Status__c from SOL_Policy__c where Loan_Application__c = : oppId AND Policy_Name__c LIKE '%Invisible Monitoring%' Limit 1];
            SOL_Policy__c sp=new SOL_Policy__c();
            if(SOLPolicyList != null && SOLPolicyList.size() > 0)
            {
                sp = SOLPolicyList[0];
            }        
            
            sp.Name = 'Sales2.0 Invisible Monitoring';
            sp.Policy_Name__c ='Invisible Monitoring';
            sp.Loan_Application__c = oppId;
            sp.RetriggerBRE__c = false;
            upsert sp;
            return JSON.serialize(dss); 
        }catch(Exception e){System.debug('Exception callIM '+ e.getMessage() +e.getLineNumber());}
        return null;
    }
    /*Bug 20939 e*/
    //23578 rohit start
    public static String setCkycresp(String data){
        Map<String,String> respMap = new Map<String,String>();
        Map<String,sObject> parsedMap = new Map<String,sObject>();
        respMap = (Map<String,String>)JSON.deserialize(data,Map<String,String>.class);
        oppData dss = new oppData();
        
        
        
        dss.status = 'success';           
        //parsedMap = CommonUtility.populateObj('Opportunity_CkycConfig','Salaried',respMap);
        parsedMap = CommonUtility.populateObj('Opportunity_CkycConfig','detail',respMap); //24716
        if(parsedMap.get('Contact') != null){
            dss.objCon = (Contact)parsedMap.get('Contact');                 
        }
        if(parsedMap.get('Account') != null){
            dss.accObj = (Account)parsedMap.get('Account');                 
        }
        if(parsedMap.get('Applicant__c') != null){
            dss.applicantPrimary = (Applicant__c)parsedMap.get('Applicant__c');                 
        }
        
        
        
        
        return JSON.serialize(dss); 
        
    } 
    //23578 rohit stop
    public class queuableEPFO implements Queueable,database.Allowscallouts {
        private string oppId;
        
        public queuableEPFO(string loanid) {
            this.oppId = loanid;
        }
        
        public void execute(QueueableContext context) {
            oppData dss = new oppData();
            getAllData(oppId,dss);
            string result = SALMobilityOppCntrl_V2.doEPFOChecks(JSON.serialize(dss.accObj),JSON.serialize(dss.opp),JSON.serialize(dss.objCon));
            system.debug('in EPFO check execute queuableEPFO'+result);
            oppData dss1 = new oppData();
            dss1 =  (SALMobilityOppCntrl_V2.oppData)JSON.deserialize(result, SALMobilityOppCntrl_V2.oppData.class);
            if(dss1.status == 'success'){
                //call PAN BRE
                system.debug('in else if epfo');
                if(!Test.isRunningTest()){
                    queuablePANBRE updateJob = new queuablePANBRE(oppId);
                    ID jobID = System.enqueueJob(updateJob);
                }
                //Call Verification
                system.debug('calling verification');
                SALMobilityOppCntrl_V2.retriggerverification(oppId);
            }   
            
        }
    }
    public class queuablePANBRE implements Queueable,database.Allowscallouts {
        private string oppId;
        
        public queuablePANBRE(string loanid) {
            this.oppId = loanid;
        }
        
        public void execute(QueueableContext context) {
            oppData dss = new oppData();
            getAllData(oppId,dss); 
            string panValue = SALMobilityOppCntrl_V2.callPANBRE(JSON.serialize(dss.accObj),JSON.serialize(dss.objCon),JSON.serialize(dss.opp),JSON.serialize(dss.applicantPrimary));  
            system.debug('queuablePANBRE execute>>'+panValue);
            oppData dss1 = new oppData();
            dss1 =  (SALMobilityOppCntrl_V2.oppData)JSON.deserialize(panValue, SALMobilityOppCntrl_V2.oppData.class);
            if(dss1.status == 'Success'){
                //call Deviation
                system.debug('queuablePANBRE Success deviation call');
                SALMobilityOppCntrl_V2.retriggerDeviation(oppId,false);
            }
            
        }
    }  
    public class queuableDyanmicOffer implements Queueable,database.Allowscallouts {
        private string oppId;
        
        public queuableDyanmicOffer(string loanid) {
            this.oppId = loanid;
        }
        
        public void execute(QueueableContext context) {
            oppData dss = new oppData();
            getAllData(oppId,dss);
            string offerData = SALMobilityOppCntrl_V2.getOfferDetails(dss.opp,dss.accObj,dss.applicantPrimary,dss.objCon); 
            system.debug(' in queuableDyanmicOffer>>>'+offerData); 
            if(!commonutility.isEmpty(offerData)){
                oppData dss1 = new oppData();
                dss1 =  (SALMobilityOppCntrl_V2.oppData)JSON.deserialize(offerData, SALMobilityOppCntrl_V2.oppData.class);
                if(dss1.status == 'success'){
                    //call Deviation,Document
                    SALMobilityOppCntrl_V2.retriggerDeviation(oppId,true);
                    //Call Verification
                    system.debug('calling verification');
                    SALMobilityOppCntrl_V2.retriggerverification(oppId);
                }
            }
            
        }
    }
    
    public class queuableEligibility implements Queueable,database.Allowscallouts {
        private string oppId;
        
        public queuableEligibility(string loanid) {
            this.oppId = loanid;
        }
        
        public void execute(QueueableContext context) {
            oppData dss = new oppData();
            getAllData(oppId,dss); 
            string result = OpportunityMobilityUtility.callEligibiltySegmentation(oppId,JSON.serialize(dss.camObj));
            OpportunityMobilityUtility.DssData dss1 = new OpportunityMobilityUtility.DssData();
            dss1 =  (OpportunityMobilityUtility.DssData)JSON.deserialize(result,OpportunityMobilityUtility.DssData.class); 
            system.debug('retriggerEligibility status'+dss1.status);
            if(!commonutility.isEmpty(dss1) && dss1.status == 'Success'){
                List < SOL_Policy__c > policyList = new List < SOL_Policy__c > ();
                SOL_Policy__c  SolObj = new  SOL_Policy__c ();
                policyList = [select id, Policy_Name__c,New_Address_Value__c ,Old_Address_Value__c,Policy_Status__c,Loan_Application__c,Checklist_Policy_Status__c, Applicant_Name__c from SOL_Policy__c where Loan_Application__c = : oppId AND Name LIKE 'Sales2.0 Eligibility Details' limit 1];
                if(!CommonUtility.isEmpty(policyList) && policyList[0].Policy_Name__c.contains('Eligibility Details')){
                    SolObj = policyList[0];
                }
                else{
                    SolObj = new SOL_Policy__c();
                    SolObj.Name = 'Sales2.0 Eligibility Details';
                    SolObj.Policy_Name__c = 'Eligibility Details';
                    SolObj.Loan_Application__c = oppId;
                    SolObj.Applicant_Name__c = dss.applicantPrimary.Id;
                    //SolObj.Old_Address_Value__c = dynOfferResult;
                    
                }
                SolObj.RetriggerBRE__c = false;
                upsert SolObj;
                triggeredBRE.add('Eligibility Details'); 
                //call Deviation,Document
                SALMobilityOppCntrl_V2.retriggerDeviation(oppId,true);
                //Call Verification
                system.debug('calling verification');
                SALMobilityOppCntrl_V2.retriggerverification(oppId);
            }
            system.debug('end retriggerEligibility>>>');
        }
    }
    /* 
@future(callout=true)   
public static void retriggerEpfo(string loanid){
oppData dss = new oppData();
getAllData(loanid,dss);
string result = SALMobilityOppCntrl_V2.doEPFOChecks(JSON.serialize(dss.accObj),JSON.serialize(dss.opp),JSON.serialize(dss.objCon));
system.debug('in EPFO check'+result);

} */
    @future(callout=true)   
    public static void retriggerMCP(string loanid,string TypeForMCP){
        oppData dss = new oppData();
        getAllData(loanid,dss); 
        Map<String,String> params = new Map<String,String>();
        params.put('JSONCamObj',JSON.serialize(dss.camObj));
        params.put('empAccount','['+ JSON.serialize(dss.accObj) + ']');
        params.put('empOpp','['+ JSON.serialize(dss.opp)  + ']'); 
        params.put('empContact','['+ JSON.serialize(dss.objCon)  + ']'); 
        params.put('appObj','['+ JSON.serialize(dss.applicantPrimary)  + ']');  
        params.put('solPolicySrc','Sales2.0');
        params.put('TypeForMCP',TypeForMCP);
        system.debug('params>>>'+params);
        oppData data = new oppData();
        data = SALMobilityOppCntrl_V2.callMCP(params);
        system.debug('end MCP');                    
    }
      @future(callout=true)
public static void retriggerPANBRE(string loanid){
oppData dss = new oppData();
getAllData(loanid,dss); 
string panValue = SALMobilityOppCntrl_V2.callPANBRE(JSON.serialize(dss.accObj),JSON.serialize(dss.objCon),JSON.serialize(dss.opp),JSON.serialize(dss.applicantPrimary));
system.debug('panValue>>>>>'+panValue);                    
}  /*
@future(callout=true)
public static void retriggerDynamicOffer(string loanid){
oppData dss = new oppData();
getAllData(loanid,dss); 
string offerData = SALMobilityOppCntrl_V2.getOfferDetails(dss.opp,dss.accObj,dss.applicantPrimary,dss.objCon); 
system.debug('end Dynamic Offer Amount>>>'+offerData);               
} 
@future(callout=true)
public static void retriggerEligibility(string loanid){
oppData dss = new oppData();
getAllData(loanid,dss); 
string result = OpportunityMobilityUtility.callEligibiltySegmentation(loanid,JSON.serialize(dss.camObj));
OpportunityMobilityUtility.DssData dss1 = new OpportunityMobilityUtility.DssData();
dss1 =  (OpportunityMobilityUtility.DssData)JSON.deserialize(result,OpportunityMobilityUtility.DssData.class); 
system.debug('retriggerEligibility status'+dss1.status);
if(!commonutility.isEmpty(dss1) && dss1.status == 'Success'){
List < SOL_Policy__c > policyList = new List < SOL_Policy__c > ();
SOL_Policy__c  SolObj = new  SOL_Policy__c ();
policyList = [select id, Policy_Name__c,New_Address_Value__c ,Old_Address_Value__c,Policy_Status__c,Loan_Application__c,Checklist_Policy_Status__c, Applicant_Name__c from SOL_Policy__c where Loan_Application__c = : loanid AND Name LIKE 'Sales2.0 Eligibility Details' limit 1];
if(!CommonUtility.isEmpty(policyList) && policyList[0].Policy_Name__c.contains('Eligibility Details')){
SolObj = policyList[0];
}
else{
SolObj = new SOL_Policy__c();
SolObj.Name = 'Sales2.0 Eligibility Details';
SolObj.Policy_Name__c = 'Eligibility Details';
SolObj.Loan_Application__c = loanid;
SolObj.Applicant_Name__c = dss.applicantPrimary.Id;
//SolObj.Old_Address_Value__c = dynOfferResult;

}
SolObj.RetriggerBRE__c = false;
upsert SolObj;
}
system.debug('end retriggerEligibility>>>');
} */
    @future(callout=true)
    public static void retriggerverification(string loanid){
        string result = SALMobilityOppCntrl_V2.callVerificationAPI(loanid);
        system.debug('result>>>'+result);
    }
    @future(callout=true)
    public static void retriggerDeviation(string loanid,boolean flag){
        string result = SALMobilityOppCntrl_V2.callDeviationAPI(loanid,flag);
        
        system.debug('result>>>'+result);
    }
    /*Bug 20939 */
    /*added for centralised sampling*/
    public static string checkCentralizedSampling(String loanid,String jsonOppobj,String jsonAppobj,String jsonBankObj, String jsonAccountObj, String jsonVeriList){
        opportunity oppObj = (Opportunity)JSON.deserialize(jsonOppobj,Opportunity.class);
        Account accObj = (Account)JSON.deserialize(jsonAccountObj,Account.class);
        Bank_account__c bankObj = (Bank_Account__c)JSON.deserialize(jsonBankObj,Bank_Account__c.class);
        Applicant__c appObj = (Applicant__c)JSON.deserialize(jsonAppobj,Applicant__c.class);
        if((oppObj.StageName == 'Approved') && (AccObj.Offer_Inhanced__c == true || oppObj.product_Offerings__r == null || (oppObj.product_Offerings__r != null && oppObj.product_Offerings__r.size() == null)) && ((bankObj.Perfios_Flag__c && bankobj.Source_Of_Data__c == 'PDF Upload' && AccObj.Type_of_Salary__c == 'Manual') || (bankObj.Perfios_Flag__c && bankobj.Source_Of_Data__c == 'Net Banking' && AccObj.Type_of_Salary__c == 'Manual') || (bankObj.Perfios_Flag__c == false) || (bankObj.Perfios_Flag__c) || (bankObj.Perfios_Flag__c && bankobj.Source_Of_Data__c == 'Manual') || (bankObj.Perfios_Flag__c && bankobj.Source_Of_Data__c == 'PDF Upload')) && (!appObj.RSA_flag__c) && (!appObj.Invisible_Monitoring_Triggered__c)){
        }
        return null;
    }
    /*added for centralised sampling*/
    public static String holdLoan(String loanid, String jsonoppobj) {
        Opportunity loan = new Opportunity();
        try {
            loan = (Opportunity) JSON.deserialize(jsonoppobj, Opportunity.class);
            
            String referal = LOan.Referral__c;
            if (referal == 'None') {
                Loan.Referral__c = null;
            }
            
            Loan.stagename = 'Hold';
            update Loan;
            
            // Bug Id : 19243 Hold Functionality S
            //Bug 24829 Added StageName in soql
            Opportunity opp = [Select Id,StageName,Prior_Application_Stage__c, Product__c, OwnerId, Account.Queue_Master__c,Account.Queue_Master__r.QID__c/*Bug Id : 23549*/ from Opportunity where Id =: Loan.Id LIMIT 1];
            System.debug('prior vlaue -->' + opp);
            
            if (opp != null && String.isNotBlank(opp.Prior_Application_Stage__c)) {
                String[] splitStrArr = opp.Prior_Application_Stage__c.split(';');
                if (splitStrArr != null && splitStrArr.size() == 2 && splitStrArr[0] == 'Underwriting') {
                    Boolean isAutoAllocation = AutoQueueAllocationUtility.updateCreditUserOccupied('Hold', opp, null);
                }
            }
            // Bug Id : 19243 Hold Functionality E
            
        } catch (Exception e) {
            System.debug('Exception inside approveloan' + e.getMessage() + ' at Line Number: ' + e.getLineNumber());
            return e.getMessage();
        }
        return 'success';
    }
    public static String UnHold(String jsonoppobj) {
        Opportunity loan = new Opportunity();
        try {
            loan = (Opportunity) JSON.deserialize(jsonoppobj, Opportunity.class);
            Boolean result = false;
            if (loan != null && String.isNotBlank(loan.Prior_Application_Stage__c)) {
                String[] splitStrArr = loan.Prior_Application_Stage__c.split(';');
                if (splitStrArr != null && splitStrArr.size() == 2 && splitStrArr[0] == 'Underwriting') {
                    result = AutoQueueAllocationUtility.unHoldAutoQueueLogic('Hold', Loan);
                }
            }
            System.debug('unhold result -->' + result);
            if (!result) {
                System.debug('unhold old flow -->');
                String referal = loan.Referral__c;
                if (referal == 'None') {
                    Loan.Referral__c = null;
                }
                Loan.UnHold__c = true;
                update Loan;
            }
            return 'success';
        } catch (Exception e) {
            System.debug('exception e'+e.getMessage()+e.getLineNumber());
            return e.getMessage();
        }
    }
    //23578 start
    @future(callout = true)
    public static void insertCkycdocs(String attachments,String appId){
        if(!CommonUtility.isEmpty(attachments) && appId != null){
            
            List<ContentDocumentLink> contVerToDel = [SELECT ID,ContentDocument.title,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :appId AND ContentDocument.title LIKE '%CKYC%'];
            
            if(!CommonUTility.isEmpty(contVerToDel))
                delete contVerToDel;
            
            List<ContentVersion> ckycAttachLst = new List<ContentVersion>();
            List<Map<String,String>> attMap = new List<Map<String,String>>();
            attMap = (List<Map<String,String>>)JSON.deserialize(attachments,List<Map<String,String>>.class);
            for(Map<String,String> imgData : attMap){
                System.debug('image '+imgData);
                //ckycAttachLst.add(attach);
                
                ContentVersion DataFile = new ContentVersion();                  
                //DataFile.versionDAta = Blob.valueOf(imgData.get('image'));
                DataFile.versionDAta = EncodingUtil.base64Decode(imgData.get('image'));
                DataFile.title = imgData.get('Name');   
                dataFile.PathOnClient = '/'+imgData.get('Name')+'.'+imgData.get('extension');             
                ckycAttachLst.add(DataFile);
                
                
            }
            
            insert ckycAttachLst;
            Set<Id> contVSet = new Set<Id>();
            for(ContentVersion cv : ckycAttachLst){
                contVSet.add(cv.Id);
            }
            
            
            List<ContentVersion> ckycUpLst = [SELECT ContentDocumentId from ContentVersion where id IN :contVSet];
            List<ContentDocumentLink> conLnlLst = new List<ContentDocumentLink>();
            for(ContentVersion conVr : ckycUpLst){
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = conVr.ContentDocumentId;
                cdl.LinkedEntityId = appId;
                cdl.ShareType = 'V';
                conLnlLst.add(cdl);
            }
            insert conLnlLst;
            System.debug('attachments here');
        }
    }
    //23578 stop
     @future
     public static void updateACMEvent(String actionName,String oppId,String appId)
    {
    try{
    User oUser = [SELECT Id, Name, Profile.Name, Branch_City__c, Email, Product__c, IsActive FROM User Where id =: userInfo.getUserId()];
    String timestamp = String.valueof(datetime.now());
    String event_acm =   oUser.Name +'--'+actionName+'--'+ timestamp +' ; ';
    List<TAT_Master__c> tatMasterList=new List<TAT_Master__c>();
    tatMasterList = [select id,Name,TAT_Name__c,ACM_Event_History__c,Loan_Application__c,Applicant__c from TAT_Master__c where Loan_Application__c = : oppId AND TAT_Name__c = 'Credit Allocation History'];
    System.debug('pk tat size'+tatMasterList.size());
    if(tatMasterList.size() == 0 ){
    TAT_Master__c identifiertat = new TAT_Master__c();
    identifiertat.TAT_Name__c = 'Credit Allocation History';
    identifiertat.ACM_Event_History__c = event_acm;
    if(oppId != null && oppId != '')
        identifiertat.Loan_Application__c = oppId;
    if(appId != null && appId != '')
       identifiertat.Applicant__c = appId; 
     insert identifiertat;
    }
    else if(tatMasterList != null && tatMasterList.size() >0 )
    {
    tatMasterList[0].ACM_Event_History__c = tatMasterList[0].ACM_Event_History__c + event_acm;
    update tatMasterList[0];
   }
   }catch(Exception e)
   {
    System.debug('Exception inside identifier'+e.getMessage()+e.getLineNumber());
   }
   }
   /*Doc Uploader s*/
    public static string stampFileName(String fileName,List<String> docIds){
        try{
        List<ContentVersion> cvList=[select Id,Consent_For_Upload__c,Applicant__c,Title  from ContentVersion where ContentDocumentId  IN: docIds ];
        for(Integer i = 0;i < cvList.size();i++){
            Integer instance = i+1;
            cvList[i].Title = FileName+'|'+instance;
        }
        update cvList;
        return 'Success';
        }
        catch(Exception e){
            return 'Fail';
        }
    }
    /*Doc Uploader e*/
     //Added for 928 start
 public static List < Opportunity > getEmployerOpportunityData(String employerName, String employerCategory) {
  List < Opportunity > opList = [select StageName, Name, CreatedDate from Opportunity where Account.Name_of_the_Company_Employer__c =: employerName and CreatedDate = LAST_N_DAYS: 180];
  System.debug('opList== ' + opList);
  return opList;
 }
 //Added for 928 stop  
    
 // US 1649 start

 public class PsfData {

  @AuraEnabled
  String psfId {
   get;
   set;
  }
  @AuraEnabled
  String psfName {
   get;
   set;
  }
  @AuraEnabled
  Integer countOfOpps {
   get;
   set;
  }
  @AuraEnabled
  List < Opportunity > psfOpps {
   get;
   set;
  }

 }




 public static String fetchPsfTableData() {
  User loggedInUser = [SELECT Id, FirstName, LastName FROM User WHERE Id =: UserInfo.getUserId()];
  List < Id > psfOfficerIdList = New List < Id > ();
  List < Sales_Officer_Limit__c > subordsDup = new List < Sales_Officer_Limit__c >
   (
    [SELECT Id, Sales_Officer_Name__c, Sales_Officer_Name__r.FirstName, Sales_Officer_Name__r.LastName
     FROM Sales_Officer_Limit__c
     WHERE Reporting_Manager_Name__r.FirstName =: loggedInUser.FirstName
     AND Reporting_Manager_Name__r.LastName =: loggedInUser.LastName
     AND Sales_Officer_Name__r.isActive = True
    ]
   );

 System.debug('attachments here '+subordsDup);
  for (Sales_Officer_Limit__c temp: subordsDup) {
   psfOfficerIdList.add(temp.Sales_Officer_Name__c);
  }
  Set < Id > psfOfficerIdSet = new Set < Id > (psfOfficerIdList);
  List < Sales_Officer_Limit__c > subords = new List < Sales_Officer_Limit__c > ();

  for (Sales_Officer_Limit__c temp: subordsDup) {

   if (psfOfficerIdSet.size() > 0) {

    if (psfOfficerIdSet.contains(temp.Sales_Officer_Name__c)) {
     subords.add(temp);
     psfOfficerIdSet.remove(temp.Sales_Officer_Name__c);
    }
   } else
    break;
  }

  //  Date startDate = Date.today().addDays(-Integer.valueOf(psfDateRange()));
  List < Opportunity > opsMasterList = new List < Opportunity > ();
  opsMasterList = [SELECT Id, Loan_Amount__c, Area__c, Application_Number__c, CUSTOMER__r.Customer_Name__c,
   Loan_Application_Number__c, Sourcing_Channel__c, Sourcing_Channel__r.Name, OwnerId, Created_Time__c,
   AccountId
   FROM Opportunity
   WHERE OwnerId IN: psfOfficerIdList
   AND StageName = 'DSA/PSF Login'
   /*   AND CreatedDate >= :startDate*/
   AND CreatedDate >= LAST_N_DAYS: 15
  ];

  List < Psfdata > psfLoanList = new List < PsfData > ();

  for (Sales_Officer_Limit__c uname: subords) {
   PsfData obj = new PsfData();
   obj.psfId = uname.Sales_Officer_Name__c;
   obj.psfName = uname.Sales_Officer_Name__r.FirstName + ' ' + uname.Sales_Officer_Name__r.LastName;
   obj.psfOpps = new List < Opportunity > ();
   for (Opportunity temp: opsMasterList)
    if (temp.OwnerId == uname.Sales_Officer_Name__c)
     obj.psfOpps.add(temp);

   obj.countOfOpps = obj.psfOpps.size();
   psfLoanList.add(obj);
  }

  return JSON.serialize(psfLoanList);


 }


 public static String updateOpps(String oppsToUpdate, String acsToUpdate) {
  List < Opportunity > extLst = new List < Opportunity > ();
  Profile loginUserProfile = [SELECT Name FROM Profile WHERE Id =: USerInfo.getProfileId() LIMIT 1];
  String profName = loginUserProfile.Name;

  System.debug('accounts recieved=' + acsToUpdate);

  if (oppsToUpdate != null && oppsToUpdate != '') {
   extLst = (List < Opportunity > ) JSON.deserialize(oppsToUpdate, List < Opportunity > .class);

   List < Opportunity > ops = new List < Opportunity > ();

   for (Opportunity op: extLst) {
    op.Relationship_Manager__c = op.OwnerId;

    if (profName.contains('Regional Sales Manager')) op.Area_SM__c = op.OwnerId;
    else if (profName.contains('Zonal Sales Manager')) op.Regional_SM__c = op.OwnerId;
    else if (profName.contains('National Sales Manager')) op.Zonal_SM__c = op.OwnerId;

    ops.add(op);
   }

   try {
    if (!CommonUtility.isEmpty(extLst)) {
     System.debug('before update=' + extLst);
     update ops;
    }
   } catch (Exception ex) {
    System.debug('exception ' + ex.getstacktraceSTring());
    return JSON.serialize(ex.getMessage());
   }

  }

  List < Account > actLst = new List < Account > ();
  if (acsToUpdate != null && acsToUpdate != '') {
   System.debug('Inside account update code');
   actLst = (List < Account > ) JSON.deserialize(acsToUpdate, List < Account > .class);
   try {
    /*   if(!CommonUtility.isEmpty(actLst)){
           System.debug ('before update account='+actLst);
           update actLst;
      
       }*/
    // logic added to reflect updated owner profile name in account record
    if (!CommonUtility.isEmpty(actLst)) {
     System.debug('before update account=' + actLst);
     update actLst;

     List < Id > actIds = new List < Id > ();
     for (Account a: actLst) actIds.add(a.Id);

     List < Account > acProfiles = new List < Account > ();
     acProfiles = [SELECT Id, Owner.Profile.Name, Owner_Profile__c FROM Account WHERE Id IN: actIds];

     List < Account > updatedAcProfiles = new List < Account > ();
     for (Account a: acProfiles) {
      a.Owner_Profile__c = a.Owner.Profile.Name;
      updatedAcProfiles.add(a);
     }
     System.debug('Account with profiles = ' + updatedAcProfiles);
     update updatedAcProfiles;
    }
   } catch (Exception ex) {
    System.debug('exception ' + ex.getstacktraceSTring());
    return JSON.serialize(ex.getMessage());
   }

  }

  return JSON.serialize(extLst);
 }

 public static Boolean psfProfileCheck(String loggedInUserProfile) {

  Map < String, Object > rescMap = GeneralUtilities.fetchStaticRescMap();
  rescMap = (Map < String, Object > ) rescMap.get('psfLoanDataValues');
  String conValue = (String) rescMap.get('validProfiles');
  System.debug(conValue.contains(loggedInUserProfile));
  return conValue.contains(loggedInUserProfile);


 }

 public static Integer psfDateRange() {


  Map < String, Object > rescMap = GeneralUtilities.fetchStaticRescMap();
  Integer dateRange;
  rescMap = (Map < String, Object > ) rescMap.get('psfLoanDataValues');
  if(!CommonUtility.isEmpty(rescMap))
  dateRange = Integer.valueOf(rescMap.get('dateRange'));
  return dateRange;


 }

 // US 1649 end
 
 
    
}