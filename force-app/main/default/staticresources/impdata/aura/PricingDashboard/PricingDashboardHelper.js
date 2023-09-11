({  
    CO_ID_TO_CO_NAME_MAP : {},
    
    getDashboardDetails : function(component,event) {
        var iscopyperfiosdetails = false;//22017
        var SIrepaymentmode = false;//22017
        this.showhidespinner(component,event,true);
        this.executeApex(component, 'getPricingDashboardDetails', {
            "oppId": component.get("v.oppId")  
        }, function(error, result){
            console.log('Result of getPricingDashboardDetails ' +result);
            if(!error && result){
                
                var data = JSON.parse(result);
                //24668 start
                if(data.finAppl){                    
                    component.set("v.finAppl",data.finAppl);
                    var appTypeLst = component.get("v.appTypeLst");
                    appTypeLst.push("Financial Co-Applicant");
                    component.set("v.appTypeLst",appTypeLst);
                }
                //24668 stop
                console.log('data is '+JSON.stringify(data));
                console.log('branch location '+ data.BranchName);//data.Branch_Name__r.location_Category__c
                component.set("v.primaryapplicant",data.applicantPrimary);//23578
                
                /*  added by swapnil for  Centralized Sampling changes Epic Id User Story ID 5331 s */
                if(data.bankObj){
                    component.set("v.bankObj",data.bankObj);//23578 
                }
                if (!$A.util.isEmpty(data.accObj)) {
                    component.set("v.Accobj", data.accObj);
                }
                if(!$A.util.isEmpty(data.veriList))
                    component.set("v.allVeriList",data.veriList);
                if(data.opp.StageName && data.opp.StageName != 'Post Approval Sales' )
                    component.find("chkSample").set("v.disabled",true);
                /*US_5574 S*/
                var rsaVeriList;
                if(component.get("v.allVeriList")){
                    rsaVeriList=component.get("v.allVeriList");  
                    //var rsaReason=JSON.stringify(rsaVeriList);
                    for(var i in rsaVeriList )
                    {
                        if(rsaVeriList[i].RSA_Reason__c =='Initiated through RCU' &&(rsaVeriList[i].Status__c=='Negative'||rsaVeriList[i].Status__c=='Fraud'))
                        {
                            component.set("v.rcuFlag",true);
                        }
                    }
                }
                /*US_5574 E*/
                if(!$A.util.isEmpty(data.solPolicys)){
                    var allsol = data.solPolicys;
                    var CentralisedSOL=[];
                    console.log('@@swapnil sol list '+JSON.stringify(allsol));
                    
                    for(var i=0; i<allsol.length; i++){
                        if(allsol[i].Name == 'Centralized Sampling'){
                            
                            CentralisedSOL.push(allsol[i]);
                        }
                    }
                    if(CentralisedSOL) 
                        component.set("v.centralisedSampling",CentralisedSOL) //5331 
                        centralisedSampling=component.get("v.centralisedSampling"); //5331
                    //alert('centralisedSampling '+JSON.stringify(centralisedSampling));
                    /* if(!centralisedSampling)
                        component.find("BranchOpsButtonId").set("v.disabled",true); */
                    
                    // alert('CentralisedSOL.length '+CentralisedSOL.length+' '+centralisedSampling);
                    if(CentralisedSOL) {
                        for(var i=0;i<CentralisedSOL.length;i++)
                        {
                            console.log('@@swapnil sol is '+CentralisedSOL[0].Name);
                            if( CentralisedSOL[i] && CentralisedSOL[i].Name && CentralisedSOL[i].Name.toUpperCase() === ('Centralized Sampling').toUpperCase()){
                                component.set("v.CentralisedSOL",CentralisedSOL[i]);
                                if(component.get("v.CentralisedSOL.Remarks__c")=='Complete'){                          
                                    component.find("chkSample").set("v.disabled",true);
                                }else  if(component.get("v.CentralisedSOL.Remarks__c")=='Required'){
                                    component.find("chkSample").set("v.disabled",false);
                                }
                                
                            }
                        }
                    }
                }
                //component.set("v.SOLPolicyList",data.CentralisedSOL);
                
                /* added by swapnil for  Centralized Sampling changes Epic Id User Story ID 5331 e */
                
                console.log('data.applicantPrimary '+JSON.stringify(data.applicantPrimary) );
                if(!($A.util.isEmpty(component.get("v.oppId"))))
                {
                    component.set("v.nameTheme",data.theme);
                    component.set("v.oppObj",data.opp);
                    var rsaVeriDone = data.rsaVeriDone; //20939 added rsaVeriDone
                    
                    var solList = data.SOLPolicyList;//24313
                    console.log('solList'+solList);
                    var loanApplication = data.opp;
                    var solPolicys = data.solPolicys; //24673
                    var Applicantdata = data.applicantPrimary;
                    var ekycObj = data.ekycobj;
                    var insuranceList = data.insuranceList;
                    var states = data.statesEkyc;
                    var applicantAccount = data.accObj;
                    var applicantContact = data.objCon;
                    var bankAccountObj = data.bankObj;
                    console.log('Bank Object is '+data.bankObj);
                    var discrepancyList = data.sanctionList;
                    var sanctionlist = data.existingDisList;
                    discrepancyList.push.apply(discrepancyList,sanctionlist);
                    var repaymentModeDtlList = data.repayList;// for E-mandate check 
                    var verificationList = data.veriList;
                    console.log('veriList is '+data.veriList);
                    var DeDupeList = data.dedupeList;
                    var disbursalList = data.disburement;
                    var officeVerificationFound = false;
                    var residenceVerificationFound = false;
                    var permanentAddressVerificationFound = false;
                    var bankVerificationFound = false;
                    component.set("v.isCommunityUser",data.isCommunityUsr);
                    component.set("v.stage",loanApplication.StageName);
                    component.set("v.DeDupeList",DeDupeList);//24668
                    if(!($A.util.isEmpty(component.get("v.oppId")))&&(bankAccountObj)){//24315s
                        component.set("v.isPerfiosSameAsSalary",bankAccountObj.Perfios_account_same_as_Salary_account__c == false);
                    }//24315e
                    if(loanApplication.StageName != 'Post Approval Sales'){//22307
                        component.set("v.disablebranchops",true);
                    }
                    // console.log('data.dedupeList'+data.dedupeList.length);
                    console.log(applicantContact);
                    console.log(states);
                    /*24673 s*/
                    if(component.get('v.oppObj').Product__c == 'RDPL'){
                        for(var i=0;i<solPolicys.length;i++){
                            if(solPolicys[i].Name.includes('Rental Agreement') && !$A.util.isEmpty(solPolicys[i].Agreement_URL__c))
                                component.set("v.isRentalAgreement",true);
                        }
                    }
                    /*24673 e*/
                    // component.set("v.isEkyc",data.ekycObj.bio_Ekyc__c);
                    /* for(insurance__c obj : insuranceList)
                {
                    
                } */
                    //insurance component set
                    component.set("v.isInsurance", true);
                    
                    
                    console.log($A.get("$Label.c.EnableBioEkyc"));
                    /*DNS added bye swapnil 24317 s*/
                    component.set("v.primaryapplicant",Applicantdata);
                    //alert(JSON.stringify(Applicantdata));
                    
                    
                    if(!$A.util.isEmpty(Applicantdata.Proof_of_Identity__c))
                        component.set("v.CKYCPOI",Applicantdata.Proof_of_Identity__c);                        
                    
                    if(!$A.util.isEmpty(Applicantdata.Proof_of_Address_Submitted_for_Permanent__c))
                        component.set("v.CKYCPOA",Applicantdata.Proof_of_Address_Submitted_for_Permanent__c);
                    
                    console.log('CKYCPOI'+ component.get("v.CKYCPOI"));
                    console.log('CKYCPOA'+ component.get("v.CKYCPOA"));
                    
                    /*DNS added bye swapnil 24317 e*/
                    
                    //24313
                    if(solList){
                        for(var i=0;i<solList.length;i++)
                        {
                            var obj = solList[i];
                            if(obj.Policy_Name__c == 'Customer Consent'){
                                
                                console.log('in consent if>>'+obj.RetriggerBRE__c);
                                if(obj.RetriggerBRE__c == false) {  
                                    component.set("v.isConsent", true);
                                    console.log('in success consent>>'+obj.RetriggerBRE__c);
                                }
                                else{
                                    if(obj.RetriggerBRE__c == true){
                                        component.set("v.isConsent", false);
                                        // component.set("v.showCOSelectPanel", false);
                                        console.log('in error consent>>'+obj.RetriggerBRE__c);
                                    }
                                }
                                break;
                            }						
                        }
                    }
                    //24313
                    
                    //E-mandate check begins
                    /*Bug 22624 s*/ 
                    if(!$A.util.isEmpty(Applicantdata) && !$A.util.isEmpty(Applicantdata.PFApproveStatus__c) && Applicantdata.PFApproveStatus__c.includes('Pending')){
                        component.set("v.rateApprDone",false);    
                    }         
                    /*Bug 22624 e*/        
                    if(!($A.util.isEmpty(repaymentModeDtlList)))
                    {
                        // console.log('pk repay'+repaymentModeDtlList.length);      
                        // console.log(repaymentModeDtlList);            
                        for(var i=0;i<repaymentModeDtlList.length;i++)
                        {
                            console.log('inside if pk'+repaymentModeDtlList[i].Copy_Perfios_Details__c);
                            if(repaymentModeDtlList[i].Copy_Perfios_Details__c )
                                iscopyperfiosdetails = true;
                            if(repaymentModeDtlList[i].Repayment_Mode__c == 'SI' )
                                SIrepaymentmode = true;
                            
                        }
                        for(var i=0;i<repaymentModeDtlList.length;i++)
                        {
                            if(repaymentModeDtlList.length > 2 && repaymentModeDtlList[i].Repayment_Mode__c == 'Security Cheque')
                                component.set("v.isrepaywithoutsecurity",true);
                        }
                        
                        console.log('ecs0pk' + (repaymentModeDtlList[0].Copy_Perfios_Details__c )); 
                        console.log('Open_ECS_Facility__c ' + repaymentModeDtlList[0].Open_ECS_Facility__c +'Repayment_Mode__c '+ repaymentModeDtlList[0].Repayment_Mode__c );
                        if(!($A.util.isEmpty(repaymentModeDtlList[0].Open_ECS_Facility__c)))   //null check for Open_ECS_Facility
                        {
                            console.log('pk details'+repaymentModeDtlList[0].Open_ECS_Facility__c+repaymentModeDtlList[0].Repayment_Mode__c+repaymentModeDtlList[0].UMRN__c);
                            if((repaymentModeDtlList[0].Open_ECS_Facility__c.toLowerCase() == "existing"
                                && repaymentModeDtlList[0].Loan_Application__r.CUSTOMER__c != null)
                               || (repaymentModeDtlList[0].Open_ECS_Facility__c.toLowerCase() == "yes"
                                   && (!($A.util.isEmpty(repaymentModeDtlList[0].Repayment_Mode__c)))
                                   && repaymentModeDtlList[0].Repayment_Mode__c.toLowerCase() == "si"
                                   && repaymentModeDtlList[0].UMRN__c != null))
                            {
                                component.set("v.isEmandate",true);
                            }
                            else
                            {
                                component.set("v.isEmandate",false);
                                
                            }
                        }
                        else
                        {
                            component.set("v.isEmandate",false);
                            
                        }
                        
                    }
                    else
                    {
                        component.set("v.isEmandate",false);
                        
                    }
                    //E-mandate check ends
                    // Ekyc Check Begins
                    var curr_state = '';
                    if(!($A.util.isEmpty(applicantAccount)) && !($A.util.isEmpty(applicantAccount.Current_State__c)))
                    {
                        console.log('ekyc');
                        curr_state = applicantAccount.Current_State__c.toLowerCase();
                        
                    }
                    if(states.indexOf(curr_state)>(-1))
                    {
                        component.set("v.isEkyc",true);
                    }
                    else
                    {
                        
                        if($A.get("$Label.c.EnableBioEkyc") == 'true' )
                        {
                            console.log('check ekyc');
                            if($A.get("$Label.c.MandatoryBioEkyc") == 'true')
                            {	
                                if(!($A.util.isEmpty(applicantContact)))
                                {  
                                    if(applicantContact.Customer_address_matches_with_eKYC__c == 'Yes' && !($A.util.isEmpty(ekycObj)))
                                    {
                                        component.set("v.isEkyc",ekycObj.bio_Ekyc__c);
                                    }
                                }
                            }
                            else
                            {
                                if(!($A.util.isEmpty(applicantContact)))
                                {  
                                    if(applicantContact.Customer_address_matches_with_eKYC__c == 'Yes' && data.applicantPrimary.bio_Ekyc__c == true)
                                    {
                                        component.set("v.isEkyc",true);
                                        console.log('ekyc1');
                                    }
                                    else if(applicantContact.Customer_address_matches_with_eKYC__c == 'Yes')
                                    {
                                        component.set("v.isEkyc",data.applicantPrimary.eKYC_Processing__c);
                                    }
                                }
                                
                            }
                        }
                        else
                        {	
                            console.log('check ekyc');
                            if(!($A.util.isEmpty(applicantContact)))
                            {  
                                if(applicantContact.Customer_address_matches_with_eKYC__c == 'Yes')
                                {
                                    component.set("v.isEkyc",data.applicantPrimary.eKYC_Processing__c);
                                    console.log('ekyc1');
                                    
                                }
                            }
                        }
                    }
                    
                    //ekyc check ends
                    //
                    //perfios check begins
                    if($A.util.isEmpty(bankAccountObj))
                    {
                        console.log("bank obj empty");
                        component.set("v.isPerfiosResponse",true);
                    }
                    else{
                        console.log("bank object not empty");
                        if(bankAccountObj.Perfios_Flag__c == true)
                        {
                            component.set("v.isPerfiosResponse",true);
                        }
                        else
                        {
                            component.set("v.isPerfiosResponse",false);
                            
                        }
                        
                        
                        
                    }
                    //perfios check ends
                    //discrepancy check start
                    // console.log('pk length'+discrepancyList.length);
                    if($A.util.isEmpty(discrepancyList))
                    {
                        console.log("no discrepancy record");
                        component.set("v.isDiscrepancyClosed",true);
                        console.log('discrepancy flag' +component.get("v.isDiscrepancyClosed"));
                    }
                    else
                    {
                        console.log('going to disc else'+discrepancyList.length);
                        for(var i=0;i<discrepancyList.length;i++)
                        {
                            console.log(discrepancyList[i].Status__c);
                            if(discrepancyList[i].Status__c == "Closed" || discrepancyList[i].Status__c == "Discrepancy Resolved")
                            {
                                component.set("v.isDiscrepancyClosed",true);
                            }
                            else
                            {
                                component.set("v.isDiscrepancyClosed",false);
                                break;
                            }
                        }
                    }
                    //discrepancy check ends
                    //24315 start
                     if(!($A.util.isEmpty(bankAccountObj)) && bankAccountObj.Perfios_account_same_as_Salary_account__c==true)
                        {
                            component.set("v.bankApprovedByCredit",true);
                        }
                    //24315 end
                    //24315 CR start
                    if(!$A.util.isEmpty(disbursalList) && !($A.util.isEmpty(repaymentModeDtlList))){
                        var bankfield = 'Bank_Acct_Number__c';
                        if(!($A.util.isEmpty(bankAccountObj))&& bankAccountObj.Perfios_Flag__c)
                            bankfield = 'Perfios_Account_No__c';
                        else
                            bankfield = 'Bank_Acct_Number__c';
                        var  disbursalbankmtach = false;
                        var  disbursalrepaymatch = false;
                        var  repaybankmtach = false;
                        for(var i=0;i<disbursalList.length;i++){
                            if(disbursalList[i].Disbursal_Mode__c =='RTGS' || disbursalList[i].Disbursal_Mode__c =='NEFT')
                            {   
                                if(disbursalList[i].Bank_Account__c == bankAccountObj[bankfield])
                                    disbursalbankmtach = true;
                                for(var j=0;j<repaymentModeDtlList.length;j++){
                                    if(repaymentModeDtlList[j].Repayment_Mode__c == 'SI' || repaymentModeDtlList[j].Repayment_Mode__c == 'ECS')
                                    {
                                        if(disbursalList[i].Bank_Account__c == repaymentModeDtlList[j].A_C_NO__c && disbursalList[i].Bank_Account__c == bankAccountObj[bankfield] && bankAccountObj[bankfield] == repaymentModeDtlList[j].A_C_NO__c){
                                             component.set("v.isBankAccMatch",true);
                                              break;
                                        }
                                        if(repaymentModeDtlList[i].A_C_NO__c == bankAccountObj[bankfield])
                                            repaybankmtach = true;
                                    }
                                }
                                
                            }
                        }
                        
                        /*if(disbursalbankmtach && disbursalrepaymatch && repaybankmtach)
                            component.set("v.isBankAccMatch",true);
                        else
                            component.set("v.isBankAccMatch",false);*/
                    }
                    else{
                        component.set("v.isBankAccMatch",false);//24315
                    }
                    //24315 CR end
                    
                    if(!($A.util.isEmpty(Applicantdata)))
                    {
                        //Customer Acceptance check begins
                        if(!($A.util.isEmpty(Applicantdata.IP_Address_Timestamp__c)))
                        {
                            if(Applicantdata.IP_Address_Timestamp__c != 'Acceptance Pending' && Applicantdata.IP_Address_Timestamp__c!=null && Applicantdata.IP_Address_Timestamp__c.toUpperCase().includes('ACCEPTED') && Applicantdata.Reject_Reason__c ==null)
                            {
                                console.log("customer acceptance");
                                component.set("v.isCustomerConsent",true);
                            }	
                        }
                        
                        //Customer Acceptance check ends
                        if(!($A.util.isEmpty(Applicantdata.Application_Form_Timestamp__c)))
                        {
                            if(Applicantdata.Application_Form_Timestamp__c != 'Acceptance Pending' && Applicantdata.Application_Form_Timestamp__c!=null && Applicantdata.Application_Form_Timestamp__c.toUpperCase().includes('ACCEPTED'))
                            {
                                component.set("v.isAppForm",true);
                            }	
                        }
                        //SFDC Applicability check begins
                        console.log("Applicant data not empty "+Applicantdata);
                        if(Applicantdata.Risk_Segmentation__c != 'HR' && Applicantdata.Risk_Segmentation__c != 'VHR')
                        {
                            console.log("in Risk Segmentation");
                            component.set("v.isSPDCApplicable",true);
                        }
                        //SFDC Applicability check begins
                    }
                    
                    
                    //verification check start
                    if(!($A.util.isEmpty(verificationList)))
                    {
                        for(var i = 0 ; i< verificationList.length ;i++)
                        {
                            /* 24316 s*/
                            if(verificationList[i].Verification_Type__c == 'Front End Sampling'){
                                component.set('v.isCentralizedSampling',true);  
                                component.set('v.VeriSamplingObj',verificationList[i]);
                                console.log('');
                            }
                            /*24316 e */
                            /*if(verificationList[i].verification_type__c == 'Residence verification' && verificationList[i].status__c == 'Positive')
                                {
                                    component.set("v.isCurrentAddressVerified",true);
                                }

                                if(verificationList[i].verification_type__c == 'Office verification' && verificationList[i].status__c == 'Positive')
                                {
                                    component.set("v.isOfficeVerified",true);
                                }
                               
                                if(verificationList[i].verification_type__c == 'Bank Statements' && verificationList[i].status__c == 'Positive')
                                {
                                    component.set("v.isBankVerified",true);
                                }
                                
                               if(verificationList[i].verification_type__c == 'PERMANENT ADDRESS VERIFICATION' && verificationList[i].status__c == 'Positive')
                                {
                                    component.set("v.isPermanentAddressVerified",true);
                                }*/
                            
                            //new check for verification
                            if(verificationList[i].Geo_Tagging__c == false){
                                if(verificationList[i].Verification_Type__c == 'Residence verification')
                                {
                                    if(verificationList[i].Credit_Status__c == 'Irrelevant' || verificationList[i].Credit_Status__c == 'Complete' || verificationList[i].Credit_Status__c == 'Not Required')
                                        component.set("v.isCurrentAddressVerified",true);
                                    residenceVerificationFound = true;	   
                                }
                                
                                if(verificationList[i].Verification_Type__c == 'Office verification')
                                {
                                    if(verificationList[i].Credit_Status__c == 'Irrelevant' || verificationList[i].Credit_Status__c == 'Complete' || verificationList[i].Credit_Status__c == 'Not Required')
                                        component.set("v.isOfficeVerified",true);
                                    officeVerificationFound = true;
                                }
                                
                                if(verificationList[i].Verification_Type__c == 'Bank Statements')
                                {
                                    if(verificationList[i].Credit_Status__c == 'Irrelevant' || verificationList[i].Credit_Status__c == 'Complete' || verificationList[i].Credit_Status__c == 'Not Required')
                                        component.set("v.isBankVerified",true);
                                    bankVerificationFound = true;
                                }
                                
                                if(verificationList[i].Verification_Type__c == 'PERMANENT ADDRESS VERIFICATION')
                                {
                                    if(verificationList[i].Credit_Status__c == 'Irrelevant' || verificationList[i].Credit_Status__c == 'Complete' || verificationList[i].Credit_Status__c == 'Not Required')
                                        component.set("v.isPermanentAddressVerified",true);
                                    permanentAddressVerificationFound = true;
                                }
                            }
                        }
                        
                        if(residenceVerificationFound == false)
                        {
                            component.set("v.isCurrentAddressVerified",true);
                        }
                        if(officeVerificationFound == false)
                        {
                            component.set("v.isOfficeVerified",true);
                        }
                        if(bankVerificationFound == false)
                        {
                            component.set("v.isBankVerified",true);
                        }
                        if(permanentAddressVerificationFound == false)
                        {
                            component.set("v.isPermanentAddressVerified",true);
                        }
                    }
                    else
                    {
                        console.log("No verification Record found");
                        component.set("v.isPermanentAddressVerified",true);
                        component.set("v.isBankVerified",true);
                        component.set("v.isOfficeVerified",true);
                        component.set("v.isCurrentAddressVerified",true);
                    }
                    
                    //verification check ends
                    /* 24316 s *//*commented by swapnil for 5331 *//*
                    if(component.get("v.isCentralizedSampling") && (Applicantdata.Centralised_Sampling_Status__c != null && Applicantdata.Centralised_Sampling_Status__c != 'Screened') && (component.get("v.VeriSamplingObj") != null && (component.get("v.VeriSamplingObj").Status__c == 'Fraud' || component.get("v.VeriSamplingObj").Status__c == 'Negative'))){
                        component.find("FinnOneButtonId").set("v.disabled",true);  
                    	console.log('inside centralised sampling disable condition');
                    }
                    else{
                        //component.find("FinnOneButtonId").set("v.disabled",false); 
                    }
                    /* 24316 e */
                    //de-dupe check begins
                    if(!$A.util.isEmpty(loanApplication) && !$A.util.isEmpty(Applicantdata) && !$A.util.isEmpty(applicantContact))
                    {
                        console.log('in loanApplication'+loanApplication.CUSTOMER__c+Applicantdata.Dedupe_Linking_Done__c+applicantContact.CIF_Id__c);
                        if(loanApplication.CUSTOMER__c == null)
                        {
                            if($A.util.isEmpty(DeDupeList))
                            {
                                component.set("v.isDeDupe",true);
                                console.log('dedupe flag '+component.get("v.isDeDupe"));
                            }
                            else
                            {
                                if(!($A.util.isEmpty(Applicantdata)))
                                {
                                    if(!($A.util.isEmpty(Applicantdata.Dedupe_Linking_Done__c)))
                                    {
                                        console.log('check dedupe');
                                        if(Applicantdata.Dedupe_Linking_Done__c.toLowerCase() == 'reset')
                                            component.set("v.isDeDupe",true);
                                        else if(!($A.util.isEmpty(applicantContact)))
                                        {
                                            if(Applicantdata.Dedupe_Linking_Done__c.toLowerCase() == 'save' && !$A.util.isEmpty(applicantContact.CIF_Id__c))
                                                component.set("v.isDeDupe",true);
                                        } 
                                    }      
                                }
                            }
                        }
                        else
                        {
                            console.log('setting true');
                            component.set("v.isDeDupe",true);
                        }
                    }
                    //de-dupe check ends
                    //
                    //IMPS check begins
                    if(!($A.util.isEmpty(disbursalList)))
                    {
                        for(var i=0;i<disbursalList.length ; i++)
                        {	
                            console.log("disbursal pk "+iscopyperfiosdetails+disbursalList[i].Repay_Disb_Diff__c);
                            
                            if(disbursalList[i].IMPS_Result__c != null && disbursalList[i].IMPS_Result__c == 'Successful Transaction')
                            {
                                component.set("v.isIMPS",true);
                            }
                            else if(!disbursalList[i].Repay_Disb_Diff__c && iscopyperfiosdetails )
                            {
                                component.set("v.isIMPS",true);
                            }
                                else if(!disbursalList[i].Repay_Disb_Diff__c && SIrepaymentmode )
                                {
                                    component.set("v.isIMPS",true);
                                }
                                    else
                                    {
                                        component.set("v.isIMPS",false);
                                        
                                        break;
                                    }
                            
                        }
                        
                    }	//list never empty
                    
                    //IMPS check ends
                    //
                    //Geo Tagging check begins
                    if(!($A.util.isEmpty(verificationList)))
                    {
                        console.log('verilist not empty');
                        for(var i=0;i<verificationList.length ; i++)
                        {
                            console.log('pk verification'+verificationList[i].Verification_Type__c+verificationList[i].Image_Latitude_Longitude_Details__c);
                            console.log(verificationList[i]);
                            if(verificationList[i].Verification_Type__c == 'Residence verification' || verificationList[i].Verification_Type__c == 'Office verification')
                            {	
                                
                                if(verificationList[i].Geo_Tagging__c == true && $A.util.isEmpty(verificationList[i].Image_Latitude_Longitude_Details__c) && verificationList[i].Credit_Status__c != 'Irrelevant'){
                                    component.set("v.isGeoTagging",false);    
                                    console.log('in geoYes');
                                    
                                }
                                else if(verificationList[i].Geo_Tagging__c == true && !$A.util.isEmpty(verificationList[i].Image_Latitude_Longitude_Details__c) && ($A.util.isEmpty(verificationList[i].Credit_Status__c) || verificationList[i].Credit_Status__c == 'Insufficient')){
                                    component.set("v.isGeoTagging",false);
                                }                                
                            }
                            
                            
                        }       
                    }  
                    
                    
                    //Geo Tagging check ends
                    /*DMS bug 24317s*/
                    this.getDMSDocuments(component,event);
                    /*DMS bug 24317s*/
                    this.colorDashboard(component,event);
                    this.uploadVerification(component,event);
                    
                } 
            }
            var customerConsent = component.get("v.isCustomerConsent");
            var retriggerConsent = component.get("v.isConsent");//24313
            var isAppForm = component.get("v.isAppForm");
            // var isBanking = component.get("v.isBanking");
            var isBankAccMatch = component.get("v.isBankAccMatch");//24315
            var bankApprovedByCredit=component.get("v.bankApprovedByCredit");//24315
            var eKyc = component.get("v.isEkyc"); 
            var eMandate = component.get("v.isEmandate");
            var IMPS = component.get("v.isIMPS");
            var SPDC = component.get("v.isSPDCApplicable");
            var perfios = component.get("v.isPerfiosResponse");
            var deDupe = component.get("v.isDeDupe");
            var insurance = component.get("v.isInsurance");
            var discrepancy = component.get("v.isDiscrepancyClosed");
            var residenceVerification = component.get("v.isCurrentAddressVerified");
            var officeVerification = component.get("v.isOfficeVerified");
            var permanentAddrVerification = component.get("v.isPermanentAddressVerified");
            var BankVerification = component.get("v.isBankVerified");
            var geoTagging = component.get("v.isGeoTagging");
            var rateApprDone = component.get("v.rateApprDone"); /*Bug 22624 s and added rateApprDone flag*/ 
            var hideAadhaar = component.get("v.hideAadhaarSection"); 
            /*5331 s*/
            component.set("v.centralisedSampling",data.centrSamp) 
            var centralisedSampling=component.get("v.centralisedSampling"); 
            console.log('@@swapnil centralisedSampling '+centralisedSampling);
            /*5331 e*/
            //SAL 2.0 CR's added same in condition below
            //22624 added rateApprDone Flag in IF
            //console.log('google;'+rateApprDone +isBanking +isAppForm+customerConsent +eMandate + IMPS+SPDC +
            //   perfios +deDupe+ insurance+ discrepancy + residenceVerification+officeVerification + permanentAddrVerification  + BankVerification+geoTagging + hideAadhaar+ eKyc) //Commented eKyc == true for Bug 22047
            //24315- isBankAccMatch==true && condition added for bank account match
            console.log('checkinga'+discrepancy+residenceVerification+hideAadhaar);
            console.log('Abhishek send finnone isBankAccMatch::'+isBankAccMatch+'bankApprovedByCredit::'+bankApprovedByCredit+' rateApprDone::'+rateApprDone+'isAppForm::'+isAppForm+'customerConsent::'+customerConsent+'eMandate::'+eMandate+'IMPS::'+IMPS+'SPDC::'+SPDC+
                        'perfios::'+perfios+'deDupe::'+deDupe+'insurance::'+insurance+'discrepancy::'+discrepancy+'residenceVerification::'+residenceVerification
                        +'officeVerification::'+officeVerification+'permanentAddrVerification::'+permanentAddrVerification+'BankVerification::'+BankVerification+'geoTagging::'+geoTagging+'hideAadhaar::'+hideAadhaar);
            if((isBankAccMatch==true || bankApprovedByCredit==true)&&rateApprDone == true && isAppForm == true && customerConsent == true && eMandate == true && IMPS == true && SPDC == true&& perfios == true && deDupe == true && insurance == true && discrepancy == true && residenceVerification == true 
               && officeVerification == true && permanentAddrVerification == true && BankVerification == true && geoTagging == true /*&& hideAadhaar ==false Bug-26833*/) //Commented eKyc == true for Bug 22047 
            {	
                if(component.get("v.stageName") == 'Post Approval Sales')
                    component.find("FinnOneButtonId").set("v.disabled",false);
            }
            else{
                component.find("FinnOneButtonId").set("v.disabled",true);   
                console.log('button disabled');
            }
            this.showhidespinner(component,event,false);   
        });
        
    },
    executeApex: function(component, method, params,callback){
        console.log('params'+JSON.stringify(params));
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log('response.getReturnValue()'+response.getReturnValue());
                callback.call(this, null, response.getReturnValue());
            } else if(state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message){
                        errors.push(item.message);
                    }
                }
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    sendBackHelper : function (component,event){
        debugger;
        console.log("inside send back");
        this.showhidespinner(component,event,true);
        this.executeApex(component, 'sendBackToCredit', {
            "oppObj": JSON.stringify(component.get("v.oppObj"))  
        }, function(error, result){
            console.log("inside send back1");
            if(!error && result)
            { console.log("inside send back2");
             if((!$A.util.isEmpty(result)))						
             {
                 console.log('mob status'+result);
                 if(result == 'Success'){
                     // user story 978 s
                     var updateidentifier =  $A.get("e.c:Update_identifier");
                     updateidentifier.setParams({
                         "eventName": 'Pricing Dashboard',
                         "oppId":component.get("v.oppObj").Id
                     });
                     
                     updateidentifier.fire();
                     
                     // user story 978 e
                     if(component.get('v.nameTheme') == 'Theme3' || component.get('v.nameTheme') == 'Theme2'){
                         if(component.get('v.isCommunityUser')==true || component.get('v.isCommunityUser')=='true')
                             window.location.href = '/Partner/006?fcf=00B90000009P3lt';
                         else
                             window.location.href = '/006?fcf=00B90000009P3lt';
                     }
                     else if(component.get('v.nameTheme') == 'Theme4d'){
                         window.location.href = '/lightning/o/Opportunity/list?filterName=00B90000009P3lt&0.source=alohaHeader';
                     }	
                         else if(component.get('v.nameTheme') == 'Theme4t')
                             this.onLoadRecordCheckForSF1(component, event);
                     
                     this.showhidespinner(component,event,false);
                     this.displayToastMessage(component,event,'Success','Application successfully sent back!','success');
                 }
                 else{
                     this.showhidespinner(component,event,false);
                     this.displayToastMessage(component,event,'Error',result,'error');
                 }
                 
                 
             }
             
             else{
                 this.showhidespinner(component,event,false);
                 this.displayToastMessage(component,event,'Error','Failed to send back.','error');
             }
            }
            else{
                console.log('mob status'+result);
                this.showhidespinner(component,event,false);
                this.displayToastMessage(component,event,'Error','Failed to send back.','error');
            }
        });
        
    },
    colorDashboard : function (component,event){
        var iconMap = [];
        var checkMap = component.get("v.checklistMap");
        this.showhidespinner(component,event,false);
        /*24673 s*/
        if(component.get('v.oppObj.Product__c') == 'RDPL'){
            console.log('isRentalAgreement'+component.get("v.isRentalAgreement"));
            if(component.get("v.isRentalAgreement")==true)
            {
                
                //$A.util.addClass(document.getElementById('customer consent'),'green-color');
                iconMap.push({
                    name: 'Rental Agreement',
                    value: 'action:approval'
                });
                for(var j=0;j<checkMap.length;j++){
                    if(checkMap[j].name == 'Rental Agreement'){
                        checkMap[j].showDocUploader = 'false';
                    }
                }
            }
            else
            {
                iconMap.push({
                    name: 'Rental Agreement',
                    value: 'action:close'
                });
            }
        }
        /*24673 e*/
        if(component.get("v.isAppForm")==true)
        {
            
            //$A.util.addClass(document.getElementById('customer consent'),'green-color');
            iconMap.push({
                name: 'Customer consent on Application Form',
                value: 'action:approval'
            });
            for(var j=0;j<checkMap.length;j++){
                if(checkMap[j].name == 'Customer consent on Application Form'){
                    checkMap[j].showDocUploader = 'false';
                }
            }
            //component.find('file-uploader-Customer consent on e-Agreement').set('v.showUploadButton', false);    
        }
        else
        {
            iconMap.push({
                name: 'Customer consent on Application Form',
                value: 'action:close'
            });
            //$A.util.addClass(document.getElementById('customer consent'),'orange-color');
        }
        /*Bug 22624 s*/
        if(component.get("v.rateApprDone")==true)
        {
            
            //$A.util.addClass(document.getElementById('customer consent'),'green-color');
            iconMap.push({
                name: 'Rate Approval',
                value: 'action:approval'
            });
            for(var j=0;j<checkMap.length;j++){
                if(checkMap[j].name == 'Rate Approval'){
                    checkMap[j].showDocUploader = 'false';
                }
            }
            //component.find('file-uploader-Customer consent on e-Agreement').set('v.showUploadButton', false);    
        }
        else
        {
            iconMap.push({
                name: 'Rate Approval',
                value: 'action:close'
            });
            //$A.util.addClass(document.getElementById('customer consent'),'orange-color');
        }
        /*Bug 22624 e*/
        if(component.get("v.isBankAccMatch")==true)//24315
        {
            //$A.util.addClass(document.getElementById('customer consent'),'green-color');
            component.set('v.allowToSendBack',true);
            iconMap.push({
                name: 'Repayment and Disbursal Match',
                value: 'action:approval'
            });
            for(var j=0;j<checkMap.length;j++){
                if(checkMap[j].name == 'Repayment and Disbursal Match'){
                    checkMap[j].showDocUploader = 'false';
                    //alert('uploaded');
                }
            }
            //component.find('file-uploader-Customer consent on e-Agreement').set('v.showUploadButton', false);    
        }
        else
        {
            iconMap.push({
                name: 'Repayment and Disbursal Match',
                value: 'action:close'
            });
            //$A.util.addClass(document.getElementById('customer consent'),'orange-color');
        }
        if(component.get("v.isCustomerConsent")==true)
        {
            
            //$A.util.addClass(document.getElementById('customer consent'),'green-color');
            iconMap.push({
                name: 'Customer consent on e-Agreement',
                value: 'action:approval'
            });
            for(var j=0;j<checkMap.length;j++){
                if(checkMap[j].name == 'Customer consent on e-Agreement'){
                    checkMap[j].showDocUploader = 'false';
                }
            }
            //component.find('file-uploader-Customer consent on e-Agreement').set('v.showUploadButton', false);    
        }
        else
        {
            iconMap.push({
                name: 'Customer consent on e-Agreement',
                value: 'action:close'
            });
            //$A.util.addClass(document.getElementById('customer consent'),'orange-color');
        }
        //console.log('length is'+iconMap.length);
        
        if(component.get("v.isEkyc") == true)
        {
            iconMap.push({
                name: 'KYC',
                value: 'action:approval'
            });
            for(var j=0;j<checkMap.length;j++){
                if(checkMap[j].name == 'KYC'){
                    checkMap[j].showDocUploader = 'false';
                }
            }
            //$A.util.addClass(document.getElementById('ekyc'), 'green-color');
            
            //component.find('file-uploader-Demographics through ekyc and Biometric ekyc').set('v.showUploadButton', false);
        }
        else
        {
            iconMap.push({
                name: 'KYC',
                value: 'action:close'
            });
            //$A.util.addClass(document.getElementById('ekyc'), 'orange-color');
        }
        if(component.get("v.isInsurance") == true)
        {
            console.log('in insurance');
            iconMap.push({
                name: 'Insurance details captured',
                value: 'action:approval'
            });
            for(var j=0;j<checkMap.length;j++){
                if(checkMap[j].name == 'Insurance details captured'){
                    checkMap[j].showDocUploader = 'false';
                }
            }
            //$A.util.addClass(document.getElementById('insurance'),'green-color');
        }
        else
        {
            iconMap.push({
                name: 'Insurance details captured',
                value: 'action:close'
            });
            //$A.util.addClass(document.getElementById('insurance'),'orange-color');
        }
        //23578 start
        console.log('ckyc data '+component.get("v.primaryapplicant").Data_Source__c+'------ '+!component.get("v.primaryapplicant").Proof_of_Residence_Address_Submitted__c);
        if(component.get("v.primaryapplicant") && component.get("v.primaryapplicant").Data_Source__c && component.get("v.primaryapplicant").Data_Source__c == 'Copy CKYC Data' && (!component.get("v.primaryapplicant").Proof_of_Residence_Address_Submitted__c || (component.get("v.primaryapplicant").Proof_of_Residence_Address_Submitted__c && component.get("v.primaryapplicant").Proof_of_Residence_Address_Submitted__c != 'Utility bill'))){
            iconMap.push({
                name: 'C-KYC',
                value: 'action:approval'
            });
            
            for(var j=0;j<checkMap.length;j++){
                if(checkMap[j].name == 'C-KYC'){
                    checkMap[j].showDocUploader = 'false';
                }
            }
            component.set("v.isUploadCkyc",true);
            
        }
        else{
            iconMap.push({
                name: 'C-KYC',
                value: 'action:close'
            });
        }
        //23578 stop
        if(component.get("v.isPerfiosResponse")==true)
        {
            iconMap.push({
                name: 'Perfios Response Recieved',
                value: 'action:approval'
            });
            for(var j=0;j<checkMap.length;j++){
                if(checkMap[j].name == 'Perfios Response Recieved'){
                    checkMap[j].showDocUploader = 'false';
                }
            }
            //$A.util.addClass(document.getElementById('perfios'),'green-color');
            //component.find('file-uploader-Perfios Response Recieved').set('v.showUploadButton', false);
        }
        else
        {
            iconMap.push({
                name: 'Perfios Response Recieved',
                value: 'action:close'
            });
            //$A.util.addClass(document.getElementById('perfios'),'orange-color');   
        }
        if(component.get("v.isDiscrepancyClosed")==true)
        {
            iconMap.push({
                name: 'Sanction Condition/Discrepancy status',
                value: 'action:approval'
            });
            for(var j=0;j<checkMap.length;j++){
                if(checkMap[j].name == 'Sanction Condition/Discrepancy status'){
                    checkMap[j].showDocUploader = 'false';
                }
            }
            //$A.util.addClass(document.getElementById('discrepancy'),'green-color');
        }
        else
        {
            iconMap.push({
                name: 'Sanction Condition/Discrepancy status',
                value: 'action:close'
            });
            //$A.util.addClass(document.getElementById('discrepancy'),'orange-color');   
        }
        //E-mandate check begins
        if(component.get("v.isEmandate")==true)
        {
            iconMap.push({
                name: 'E-Mandate and Repayment fields status',
                value: 'action:approval'
            });
            for(var j=0;j<checkMap.length;j++){
                if(checkMap[j].name == 'E-Mandate and Repayment fields status'){
                    checkMap[j].showDocUploader = 'false';
                }
            }
            // $A.util.addClass(document.getElementById('emandate'),'green-color');
            //component.find('file-uploader-E-Mandate and Repayment fields status').set('v.showUploadButton', false);
        }
        else
        {
            iconMap.push({
                name: 'E-Mandate and Repayment fields status',
                value: 'action:close'
            });
            //$A.util.addClass(document.getElementById('emandate'),'orange-color');   
        }
        //E-mandate check ends
        if(component.get("v.isSPDCApplicable") == true)
        {
            iconMap.push({
                name: 'SPDC Applicability',
                value: 'action:approval'
            });
            for(var j=0;j<checkMap.length;j++){
                if(checkMap[j].name == 'SPDC Applicability'){
                    checkMap[j].showDocUploader = 'false';
                }
            }
            //$A.util.addClass(document.getElementById('SPDC'),'green-color');
            //component.find('file-uploader-SPDC Applicability').set('v.showUploadButton', false);
        }
        else
        {
            iconMap.push({
                name: 'SPDC Applicability',
                value: 'action:close'
            });
            //$A.util.addClass(document.getElementById('SPDC'),'orange-color');
        }
        
        if(component.get("v.isOfficeVerified")==true)
        {
            iconMap.push({
                name: 'Office Verification status',
                value: 'action:approval'
            });
            for(var j=0;j<checkMap.length;j++){
                if(checkMap[j].name == 'Office Verification status'){
                    checkMap[j].showDocUploader = 'false';
                }
            }
            //$A.util.addClass(document.getElementById('office verification'),'green-color');
        }
        else
        {
            iconMap.push({
                name: 'Office Verification status',
                value: 'action:close'
            });
            //$A.util.addClass(document.getElementById('office verification'),'orange-color');
        }
        if(component.get("v.isBankVerified")==true)
        {
            iconMap.push({
                name: 'Bank Verification status',
                value: 'action:approval'
            });
            for(var j=0;j<checkMap.length;j++){
                if(checkMap[j].name == 'Bank Verification status'){
                    checkMap[j].showDocUploader = 'false';
                }
            }
            //$A.util.addClass(document.getElementById('Bank verification'),'green-color');
        }
        else
        {
            iconMap.push({
                name: 'Bank Verification status',
                value: 'action:close'
            });
            //$A.util.addClass(document.getElementById('Bank verification'),'orange-color');
        }
        if(component.get("v.isCurrentAddressVerified")==true)
        {
            iconMap.push({
                name: 'Current Address Verification status',
                value: 'action:approval'
            });
            for(var j=0;j<checkMap.length;j++){
                if(checkMap[j].name == 'Current Address Verification status'){
                    checkMap[j].showDocUploader = 'false';
                }
            }
            //$A.util.addClass(document.getElementById('Residence verification'),'green-color');
        }
        else
        {
            iconMap.push({
                name: 'Current Address Verification status',
                value: 'action:close'
            });
            //$A.util.addClass(document.getElementById('Residence verification'),'orange-color');
        }
        if(component.get("v.isPermanentAddressVerified")==true)
        {
            iconMap.push({
                name: 'Permanent Address Verification status',
                value: 'action:approval'
            });
            for(var j=0;j<checkMap.length;j++){
                if(checkMap[j].name == 'Permanent Address Verification status'){
                    checkMap[j].showDocUploader = 'false';
                }
            }
            //$A.util.addClass(document.getElementById('Permanent Address verification'),'green-color');
        }
        else
        {
            iconMap.push({
                name: 'Permanent Address Verification status',
                value: 'action:close'
            });
            //$A.util.addClass(document.getElementById('Permanent Address verification'),'orange-color');
        }
        console.log('dedupe linking'+component.get("v.isDeDupe"));
        if(component.get("v.isDeDupe")==true)
        {
            iconMap.push({
                name: 'De-dupe linking completed',
                value: 'action:approval'
            });
            for(var j=0;j<checkMap.length;j++){
                if(checkMap[j].name == 'De-dupe linking completed'){
                    checkMap[j].showDocUploader = 'false';
                }
            }
            //$A.util.addClass(document.getElementById('De dupe'),'green-color');
        }
        else
        {
            iconMap.push({
                name: 'De-dupe linking completed',
                value: 'action:close'
            });
            //$A.util.addClass(document.getElementById('De dupe'),'orange-color');
        }
        if(component.get("v.isIMPS")==true)
        {
            iconMap.push({
                name: 'IMPS and Disbursement fields status',
                value: 'action:approval'
            });
            for(var j=0;j<checkMap.length;j++){
                if(checkMap[j].name == 'IMPS and Disbursement fields status'){
                    checkMap[j].showDocUploader = 'false';
                }
            }
            //$A.util.addClass(document.getElementById('IMPS'),'green-color');
            //component.find('file-uploader-IMPS and Disbursement fields status').set('v.showUploadButton', false);
        }
        else
        {
            iconMap.push({
                name: 'IMPS and Disbursement fields status',
                value: 'action:close'
            });
            //$A.util.addClass(document.getElementById('IMPS'),'orange-color');
        }
        if(component.get("v.isGeoTagging")==true)
        {
            iconMap.push({
                name: 'Geo Tagging',
                value: 'action:approval'
            });
            for(var j=0;j<checkMap.length;j++){
                if(checkMap[j].name == 'Geo Tagging'){
                    checkMap[j].showDocUploader = 'false';
                }
            }
            //$A.util.addClass(document.getElementById('Geo Tagging'),'green-color');
        }
        else
        { 
            iconMap.push({
                name: 'Geo Tagging',
                value: 'action:close'
            });
            //$A.util.addClass(document.getElementById('Geo Tagging'),'orange-color');
        }
        console.log('betweeen');
        component.set("v.mapOfIcons",iconMap);
        
        for(var i=0;i<checkMap.length;i++){
            if(component.get("v.isCustomerConsent")==true && checkMap[i].type== 'CustomerConsent'){
                checkMap[i].showUpload = false;
            }
            //24315 condition added for bank acc match component.get("v.isBankAccMatch")==true &&
            if(component.get("v.isBankAccMatch")==true && checkMap[i].type== 'BankCheck'){
                checkMap[i].showUpload = false;
            }
            if(component.get("v.isAppForm")==true && checkMap[i].type== 'AppForm'){
                checkMap[i].showUpload = false;
            }
            if(component.get("v.isEkyc")==true && checkMap[i].type== 'eKyc'){
                checkMap[i].showUpload = false;
            }
            if(component.get("v.isPerfiosResponse")==true && checkMap[i].type== 'Perfios'){
                checkMap[i].showUpload = false;
            }
            if(component.get("v.isEmandate")==true && checkMap[i].type== 'eMandate'){
                checkMap[i].showUpload = false;
            }
            if(component.get("v.isSPDCApplicable")==true && checkMap[i].type== 'SPDC'){
                checkMap[i].showUpload = false;
            }
            if(component.get("v.isIMPS")==true && checkMap[i].type== 'IMPS'){
                checkMap[i].showUpload = false;
            }
        }
        component.set("v.checklistMap",checkMap);
        /*if(component.get("v.isCustomerConsent")==true){
            component.find('file-uploader-CustomerConsent').set('v.showUploadButton', false); 
        }
        
        if(component.get("v.isEkyc") == true){
            component.find('file-uploader-eKyc').set('v.showUploadButton', false);
        }
        
        if(component.get("v.isPerfiosResponse")==true){
            component.find('file-uploader-Perfios').set('v.showUploadButton', false);
        }
        	
        if(component.get("v.isEmandate")==true){
            component.find('file-uploader-eMandate').set('v.showUploadButton', false);
        }
        if(component.get("v.isSPDCApplicable") == true){
            component.find('file-uploader-SPDC').set('v.showUploadButton', false);
        }
        if(component.get("v.isIMPS")==true){
            component.find('file-uploader-IMPS').set('v.showUploadButton', false);
        }
        console.log('betweeen1');*/
    },
    
    sendToFinnOne : function (component,event){
        this.showhidespinner(component,event,true);
        var customerConsent = component.get("v.isCustomerConsent");
        var isAppForm = component.get("v.isAppForm");
        // var isBanking = component.get("v.isBanking");
        var isBankAccMatch = component.get("v.isBankAccMatch");//24315
        var bankApprovedByCredit= component.get("v.bankApprovedByCredit");//24315
        var eKyc = component.get("v.isEkyc"); 
        var eMandate = component.get("v.isEmandate");
        var IMPS = component.get("v.isIMPS");
        var SPDC = component.get("v.isSPDCApplicable");
        var perfios = component.get("v.isPerfiosResponse");
        var deDupe = component.get("v.isDeDupe");
        var insurance = component.get("v.isInsurance");
        var discrepancy = component.get("v.isDiscrepancyClosed");
        var residenceVerification = component.get("v.isCurrentAddressVerified");
        var officeVerification = component.get("v.isOfficeVerified");
        var permanentAddrVerification = component.get("v.isPermanentAddressVerified");
        var BankVerification = component.get("v.isBankVerified");
        var geoTagging = component.get("v.isGeoTagging");
        var rateApprDone = component.get("v.rateApprDone");/*Bug 22624 s and added rateApprDone flag*/
        var hideAadhaarSec = component.get("v.hideAadhaarSection");//SAL 2.0 CR's
        var isRentalAgreement = component.get("v.isRentalAgreement"); //24673  
        //24315 condition added for bank acc match isBankAccMatch == true &&
        //24673 added isRentalAgreement
        if((isRentalAgreement || component.get('v.oppObj').Product__c != 'RDPL') && (isBankAccMatch == true || bankApprovedByCredit==true) && isAppForm == true && customerConsent == true && eMandate == true && IMPS == true && SPDC == true 
           && perfios == true && deDupe == true && insurance == true && discrepancy == true && residenceVerification == true 
           && officeVerification == true && permanentAddrVerification == true && BankVerification == true && geoTagging == true) //Commented eKyc == true for Bug 22047  
        {
            //Bug 24313
            if(component.get("v.isConsent") == false){
                console.log('in sendtofin');
                this.showhidespinner(component,event,false);
                this.displayToastMessage(component,event,'Error','Please resend E application form/E agreement again to customer as data is changed in system after customer acceptance','Error');
                return;
            }
            // Bug 24313
            component.set("v.isSendToFinnOne",true);
            // alert('before');
            this.executeApex(component, 'sendToFinnOne', {
                "oppId": component.get("v.oppId")  
            }, function(error, result){
                if(!error)
                {
                    console.log('here');
                    if(($A.util.isEmpty(result)))						
                    {
                        console.log('here1');
                        if(component.get('v.nameTheme') == 'Theme3' || component.get('v.nameTheme') == 'Theme2'){
                            if(component.get('v.isCommunityUser')==true || component.get('v.isCommunityUser')=='true')
                                window.location.href = '/Partner/006?fcf=00B90000009P3lt';
                            else
                                window.location.href = '/006?fcf=00B90000009P3lt';
                        }
                        else if(component.get('v.nameTheme') == 'Theme4d'){
                            window.location.href = '/lightning/o/Opportunity/list?filterName=00B90000009P3lt&0.source=alohaHeader';
                        }	
                            else if(component.get('v.nameTheme') == 'Theme4t'){
                                this.onLoadRecordCheckForSF1(component, event);
                            }
                        console.log('here 4');
                        this.showhidespinner(component,event,false);
                        this.displayToastMessage(component,event,'Success','Application successfully sent to FinnOne!','success');
                        
                    }
                    
                    else{
                        this.showhidespinner(component,event,false);
                        this.displayToastMessage(component,event,'Error',result,'error');
                    }
                }
                else{
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error',result,'error');
                }
            });
        } //22624 If added //24315 added condition for bank acc match isBankAccMatch == true
        //24673 added isRentalAgreement
        /*else if((isRentalAgreement == true || component.get('v.oppObj').Product__c != 'RDPL') && (isBankAccMatch == true || bankApprovedByCredit==true) && rateApprDone == true && isBanking == true && isAppForm == true && customerConsent == true && eKyc == false && eMandate == true && IMPS == true && SPDC == true 
                && perfios == true && deDupe == true && insurance == true && discrepancy == true && residenceVerification == true 
                && officeVerification == true && permanentAddrVerification == true && BankVerification == true && geoTagging == true)
        {
            this.showhidespinner(component,event,false);
            this.displayToastMessage(component,event,'Error','Please perform Ekyc!!!,Application cannot be sent to FinnOne','error');
            
        }*/
        else
        {
            
            this.showhidespinner(component,event,false);
            this.displayToastMessage(component,event,'Error','Application cannot be sent to FinnOne!','error');
            
            
            console.log("Cannot be sent to FinnOne");
        }
        
    },
    
    sendToBranchOps : function (component,event){
        debugger;
        this.showhidespinner(component,event,true);
        console.log('upload ckyc '+component.get("v.isUploadCkyc"));
        var ckycStatus = component.get("v.isUploadCkyc");//23578
        var deDupe = component.get("v.isDeDupe");
        var insurance = component.get("v.isInsurance");
        //var isBanking = component.get("v.isBanking");
        var isBankAccMatch = component.get("v.isBankAccMatch"); //24315
        var bankApprovedByCredit=component.get("v.bankApprovedByCredit");//24315
        var discrepancy = component.get("v.isDiscrepancyClosed");
        var bankVerification = component.get("v.isBankVerified");
        var officeVerification = component.get("v.isOfficeVerified");
        var residenceVerification = component.get("v.isCurrentAddressVerified");
        var permanentVerification = component.get("v.isPermanentAddressVerified");
        var geoTagging = component.get("v.isGeoTagging");
        var customerConsent = component.get("v.isCustomerConsent");
        var isAppForm = component.get("v.isAppForm");
        var eKyc = component.get("v.isEkyc"); 
        var eMandate = component.get("v.isEmandate");
        var isrepaywithoutsecurity = component.get("v.isrepaywithoutsecurity");
        var IMPS = component.get("v.isIMPS");
        var SPDC = component.get("v.isSPDCApplicable");
        var perfios = component.get("v.isPerfiosResponse");
        var geoTaggingBranchOps = component.get("v.isGeoTaggingToBranchOps");
        var rateApprDone = component.get("v.rateApprDone");/*Bug 22624*/
        var hideAadhaarSec = component.get("v.hideAadhaarSection");//SAL 2.0 CR's
        
        var isRentalAgreement = component.get("v.isRentalAgreement"); //24673
        // this.sendToFinnOne(component,event);
        /* if(customerConsent == true && eKyc == true && eMandate == true && IMPS == true && SPDC == true 
           && perfios == true && deDupe == true && insurance == true && discrepancy == true && residenceVerification == true 
           && officeVerification == true && permanentAddrVerification == true && BankVerification == true && geoTagging == true)
        {
            //message The Application can go to FinnOne Directly
            this.showhidespinner(component,event,false);
            this.displayToastMessage(component,event,'Success','Application can be sent to FinnOne Directly!','success');
            Console.log("The Application can go to FinnOne Directly")
        }*/
        component.set("v.isUploadeKyc",true);
        ckycStatus=true;
        console.log('test ekyc'+isrepaywithoutsecurity);
        console.log('bv'+isBankAccMatch+'ss'+deDupe+'ss'+insurance+'ss'+discrepancy+'ss'+bankVerification+'ss'+officeVerification+'ss'+residenceVerification+'ss'+permanentVerification+'ss'+geoTagging+'ss'+geoTaggingBranchOps+'ss'+ckycStatus);
        if(isBankAccMatch== false && bankApprovedByCredit==false ){
            this.displayToastMessage(component,event,'Error','Required bank account not matching. Case needs to be sent back by uploading bank statement','error');
            this.showhidespinner(component,event,false);
        }//24315
        else if( deDupe == false || insurance == false || discrepancy == false || 
                bankVerification == false || officeVerification == false || residenceVerification == false || permanentVerification == false || geoTagging == false ||ckycStatus == false || isrepaywithoutsecurity)//23578 added ckycStatus
        {
            console.log('send to BranchOps flags'+deDupe+insurance+discrepancy+bankVerification+officeVerification+residenceVerification+permanentVerification+geoTagging+ckycStatus+isrepaywithoutsecurity);
            component.set("v.isSendToBranchOps",false);
            //hold in pricing
            console.log("Application Cannot be sent to BranchOps")
            this.showhidespinner(component,event,false);
            this.displayToastMessage(component,event,'Error','Application cannot be sent to BranchOps!','error');
            //this.callSubmitToBranchOpsHelper(component,event);//delete this
            
        }
            else
            {
                this.uploadVerification(component,event);  
                console.log('pk test'+component.get("v.isSendToFinnOne") +isrepaywithoutsecurity +component.get("v.isUploadCompleted"));
                if(!isrepaywithoutsecurity && (component.get("v.isUploadCompleted")==true || component.get("v.isSendToFinnOne")==true ))
                {
                    this.callSubmitToBranchOpsHelper(component,event);
                    //component.set("v.isSendToBranchOps",true);
                    
                    //this.displayToastMessage(component,event,'Success','Application successfully sent to BranchOps!','success');
                    // Send to Branch Ops If all docs are provided
                    console.log("Send to BranchOps ")
                }
                //SAL 2.0 CR's added ekyc in condition // 24315 bank acc match condition added
                // 24673 added isRentalAgreement conditions
                
                else if(((isBankAccMatch== true || bankApprovedByCredit==true) || rateApprDone == true || component.get("v.isUploadBanking")) && (isRentalAgreement || component.get("v.isUploadRentalAgreement") == true || component.get('v.oppObj').Product__c != 'RDPL') && (isAppForm == true || component.get("v.isUploadAppForm") == true) && (customerConsent == true || component.get("v.isUploadCustomerConsent") == true) && (eMandate == true||component.get("v.isUploadeMandate") == true) &&  !isrepaywithoutsecurity && (IMPS == true||component.get("v.isUploadIMPS") == true) && (SPDC == true || component.get("v.isUploadSPDC") == true) 
                        && (perfios == true || component.get("v.isUploadPerfios") == true) && deDupe == true && insurance == true && discrepancy == true && residenceVerification == true 
                        && officeVerification == true && permanentVerification == true && bankVerification == true && (geoTagging == true || geoTaggingBranchOps==true)) //Commented eKyc == true for Bug 22047
                {
                    console.log("in new if");
                    this.callSubmitToBranchOpsHelper(component,event);
                }
                    else{
                        
                        this.showhidespinner(component,event,false);
                        this.displayToastMessage(component,event,'Error','Application cannot be sent to BranchOps!, One or more documents are not uploaded','error');
                        
                    }
            }
    },
    
    displayToastMessage:function(component,event,title,message,type)
    {
        console.log('inside displayToastMessage'+message+type);
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    },
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
            
        });
        showhideevent.fire();
    },
    selectOpsCreditOfficerHelper : function(component, event) {
        
        this.showhidespinner(component,event,true);
        console.log('loanAppID ---helper---->> '+component.get("v.oppId"));
        var action = component.get("c.selectOpsCreditOfficerCntrl"); 
        action.setParams({
            "oppId": component.get("v.oppId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                console.log('...inside success...');
                var wrapperObj = response.getReturnValue();
                
                component.set("v.showCOSelectPanel", false);
                console.log('wrapperObj.errorMessageString--->> '+wrapperObj.errorMessageString);
                console.log('wrapperObj.showSalesHierarchyMsg--->> '+wrapperObj.showSalesHierarchyMsg);
                console.log('wrapperObj.coIdToCoNameMap--->> '+JSON.stringify(wrapperObj.coIdToCoNameMap));
                
                if(wrapperObj.errorMessageString == 'NO_ERROR' && wrapperObj.showSalesHierarchyMsg == false)
                {
                    
                    console.log('showCOSelectPanel----->> true');
                    var coOfficerList = [];
                    for(var key in wrapperObj.coIdToCoNameMap)
                    {
                        console.log('inside map iteration.....');
                        coOfficerList.push({value:wrapperObj.coIdToCoNameMap[key], key:key});
                        console.log({value:wrapperObj.coIdToCoNameMap[key], key:key});
                    }
                    component.set("v.creditOfficerList", coOfficerList);
                    component.set("v.showCOSelectPanel", true);
                    component.set("v.isTextBoxEnabled",false);
                    this.CO_ID_TO_CO_NAME_MAP = wrapperObj.coIdToCoNameMap;
                }
                else if(wrapperObj.errorMessageString != 'NO_ERROR')
                {
                    //show error message toast..
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error', wrapperObj.errorMessageString, 'error');
                    
                }
                    else if(wrapperObj.showSalesHierarchyMsg != false)
                    {
                        //show Info message toast..
                        var infoMsg = 'Send mail to Sales Hierarchy is Mandatory! Proposed Rate is below the system prescribed rate. Please take necessary approvals before proceeding';
                        this.showhidespinner(component,event,false);
                        this.displayToastMessage(component,event,'Error', infoMsg, 'error');
                        
                    }
            }
        });
        $A.enqueueAction(action);
        //24313
        console.log('in br ops 1>>'+component.get("v.isConsent"));
        if(component.get("v.isConsent") == false){
            console.log('in br ops');
            this.showhidespinner(component,event,false);
            this.displayToastMessage(component,event,'Error','Please resend E application form/E agreement again to customer as data is changed in system after customer acceptance','Error');
        }
        
        var retriggerConsent = component.get("v.isConsent");//24313
        //24313
        var customerConsent = component.get("v.isCustomerConsent");
        var eKyc = component.get("v.isEkyc"); 
        var eMandate = component.get("v.isEmandate");
        var IMPS = component.get("v.isIMPS");
        var SPDC = component.get("v.isSPDCApplicable");
        var perfios = component.get("v.isPerfiosResponse");
        var deDupe = component.get("v.isDeDupe");
        var insurance = component.get("v.isInsurance");
        var discrepancy = component.get("v.isDiscrepancyClosed");
        var residenceVerification = component.get("v.isCurrentAddressVerified");
        var officeVerification = component.get("v.isOfficeVerified");
        var permanentAddrVerification = component.get("v.isPermanentAddressVerified");
        var BankVerification = component.get("v.isBankVerified");
        var geoTagging = component.get("v.isGeoTagging");
        //var Banking = component.get("v.isBanking");
        var isBankAccMatch = component.get("v.isBankAccMatch");//24315
        var bankApprovedByCredit=component.get("v.bankApprovedByCredit"); //24315
        var rateApprDone = component.get("v.rateApprDone");/*Bug 22624 s and added rateApprDone flag*/
        var hideAadhaar = component.get("v.hideAadhaarSection");
        debugger;
        var isRentalAgreement = component.get("v.isRentalAgreement"); //24673
        // this.sendToFinnOne(component,event);        // 24315 added condtion for bank acc match isBankAccMatch == true && 
        if((isBankAccMatch == true || bankApprovedByCredit==true) && isRentalAgreement/*24673*/ && rateApprDone == true &&  customerConsent == true && eMandate == true && IMPS == true && SPDC == true 
           && perfios == true && deDupe == true && insurance == true && discrepancy == true && residenceVerification == true 
           && officeVerification == true && permanentAddrVerification == true && BankVerification == true && geoTagging == true && hideAadhaar ==false) //Commented eKyc == true for Bug 22047
        { 
            //message The Application can go to FinnOne Directly
            this.showhidespinner(component,event,false);
            component.set("v.isSendToFinnOne",true);
            
            this.displayToastMessage(component,event,'Info','This Application can be sent to FinnOne Directly!','info');
            console.log("The Application can go to FinnOne Directly")
        }
        this.showhidespinner(component,event,false);
    }, 
    
    callSubmitToBranchOpsHelper : function(component, event) {
        debugger;
        this.showhidespinner(component,event,true);
        var apprId = '';
        for(var key in this.CO_ID_TO_CO_NAME_MAP)
        {
            if(this.CO_ID_TO_CO_NAME_MAP[key] == component.get("v.selectedCreditOfficer"))
            {
                apprId = key;
            }
        }
        var action = component.get("c.callSubmitToBranchOpsCntrl");							//add to pricing controller and make call to pricing controller v1
        action.setParams({
            "oppId": component.get("v.oppId"),
            "approverId" : apprId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                console.log('...inside success...');
                var wrapperObj = response.getReturnValue();
                component.set("v.showspinnerflag",false);
                console.log('wrapperObj.errorMessageString--222->> '+wrapperObj.errorMessageString);
                console.log('wrapperObj.showSalesHierarchyMsg--222->> '+wrapperObj.showSalesHierarchyMsg);
                console.log('wrapperObj.coIdToCoNameMap--222->> '+JSON.stringify(wrapperObj.coIdToCoNameMap));
                
                if(wrapperObj.errorMessageString == 'NO_ERROR')
                {
                    // user story 978 s
                    var updateidentifier =  $A.get("e.c:Update_identifier");
                    updateidentifier.setParams({
                        "eventName": 'Pricing Dashboard',
                        "oppId":component.get("v.oppObj").Id
                    });
                    updateidentifier.fire();
                    // user story 978 e
                    this.showhidespinner(component,event,false);
                    //window.location.href ='/006/o';
                    if(component.get('v.nameTheme') == 'Theme3' || component.get('v.nameTheme') == 'Theme2'){
                        if(component.get('v.isCommunityUser')==true || component.get('v.isCommunityUser')=='true')
                            window.location.href = '/Partner/006?fcf=00B90000009P3lt';
                        else
                            window.location.href = '/006?fcf=00B90000009P3lt';
                    }
                    
                    else if(component.get('v.nameTheme') == 'Theme4d')
                        window.location.href = '/lightning/o/Opportunity/list?filterName=00B90000009P3lt&0.source=alohaHeader';
                        else if(component.get('v.nameTheme') == 'Theme4t')
                            this.onLoadRecordCheckForSF1(component, event);
                    this.displayToastMessage(component,event,'Success', 'Application Successfully sent to BranchOps!!', 'success');
                }
                else if(wrapperObj.errorMessageString != 'NO_ERROR')
                {
                    //show error message toast..
                    this.showhidespinner(component,event,false);
                    console.log('calling error msg');
                    console.log(errorstr);
                    var errorstr = wrapperObj.errorMessageString;
                    this.displayToastMessage(component,event,'Error', wrapperObj.errorMessageString, 'error');
                }
            }
            this.showhidespinner(component,event,false);
        });
        $A.enqueueAction(action);
        
    },
    
    onLoadRecordCheckForSF1 : function(component, event) {
        //alert('onLoadRecordCheckForSF1');
        var action = component.get('c.getLoanApplicationListViewsPAS');			//add to pricing controller and make call to pricing controller v1
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var listviews = response.getReturnValue();
                //alert('listviews'+listviews.Id);
                //component.set('v.nameTheme', response.getReturnValue());
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": listviews.Id,
                    "listViewName": null,
                    "scope": "Opportunity"
                });
                navEvent.fire();
            }
        });
        $A.enqueueAction(action);
        //alert('enqueueAction');
    },
    confirmSubmitToBranchOps : function(component, event, helper) {
        var cmpTarget = component.find('overrideModalbox');
        var cmpBack = component.find('Modalbackdrop');
        //$A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpTarget, 'slds-hide');
        $A.util.addClass(cmpTarget, 'slds-show');
        $A.util.addClass(cmpBack, 'slds-backdrop_open');
    },
    
    uploadVerification : function(component, event){
        var checkMap = [];
        var appId=component.get("v.primaryapplicant.Id")+''; //added by swapnil for DMS uploader 24317 
        console.log('Primary app id '+appId);
        this.executeApex(component, 'getUploadVerification', {
            "PrimaryAppId":appId //added by swapnil for DMS uploader 24317 
        }, function(error, result){
            //code to fetch upload details
            if(!error && result)
            {
                var flag=1;
                var data = JSON.parse(result);
                var checkMap = component.get("v.checklistMap");
                var isckypoi = false;//23578
                var isckypoa = false;//23578
                var DMSDoclist=component.get("v.DMSDocmap"); //DMS added by swapnil 24317 s
                console.log('@@swapnil DMSDoclist ' + JSON.stringify(DMSDoclist));
                
                for(var i =0; i<data.length; i++)
                {																					//one flag
                    if(!($A.util.isEmpty(data[i].Title)))
                    {	
                        /*24673 s*/
                        if(component.get('v.oppObj.Product__c') == 'RDPL'){
                            if(data[i].Title.includes("Rental Agreement")) {
                                for(var j=0;j<checkMap.length;j++){
                                    if(checkMap[j].name == 'Rental Agreement'){
                                        checkMap[j].upload = 'true';
                                        checkMap[j].toggle = 'true';
                                    }
                                }
                                component.set("v.isUploadRentalAgreement",true); 
                            }
                            if(!component.get("v.isRentalAgreement")){
                                component.find("FinnOneButtonId").set("v.disabled",true);  
                            }
                        }
                        /*24673 e*/
                        //23578 start
                        //
                        // alert(data[i].Title.includes(DMSDoclist[component.get('v.CKYCPOA')]));
                        console.log('data '+data[i].Title.includes('CKYC.'));
                        if((data[i].Title.includes('CKYC.') && !data[i].Title.includes('CKYC_img') )  || data[i].Title.includes(DMSDoclist[component.get('v.CKYCPOI')]) || data[i].Title.includes(component.get('v.CKYCPOI')))//DMS added by swapnil 24317 
                        {
                            for(var j=0;j<checkMap.length;j++){
                                if(checkMap[j].name == 'C-KYC'){
                                    checkMap[j].upload = 'true';
                                    checkMap[j].toggle = 'true';
                                }
                            }
                            //component.set("v.isUploadCkyc",true); 
                            isckypoi = true;
                            console.log('in both docs true'); 
                        }
                        
                        
                        if(data[i].Title.includes("CKYC_img") ||  data[i].Title.includes(DMSDoclist[component.get('v.CKYCPOA')]) || data[i].Title.includes(component.get('v.CKYCPOA')))//DMS added by swapnil 24317 
                        {
                            for(var j=0;j<checkMap.length;j++){
                                if(checkMap[j].name == 'C-KYC'){
                                    checkMap[j].upload_img = 'true';
                                    checkMap[j].toggle_img = 'true';
                                }
                            }
                            isckypoa = true;
                            
                        }
                        if(data[i].Title.includes("Repayment and Disbursal Match")) //24315 
                        {
                            component.set('v.allowToSendBack',true);
                        }
                        if(component.get("v.isUploadCkyc") != true){
                            component.set("v.isUploadCkyc",isckypoi && isckypoa);
                        }
                        console.log('is both docs '+ data[i].Title.includes("CKYC_img")); 
                        //23578 stop
                        if(data[i].Title.includes("Customer consent on e-Agreement") || data[i].Title.includes(DMSDoclist['Customer consent on e-Agreement']))//DMS added by swapnil 24317 
                        {
                            
                            for(var j=0;j<checkMap.length;j++){
                                if(checkMap[j].name == 'Customer consent on e-Agreement'){
                                    checkMap[j].upload = 'true';
                                    checkMap[j].toggle = 'true';
                                }
                            }
                            component.set("v.isUploadCustomerConsent",true);
                            //component.find('CustomerConsent-toggle').set("v.checked",true);
                            //$A.util.addClass(component.find('CustomerConsent-toggle'),'slds-theme_success');
                        }
                        
                        if(data[i].Title.includes("Repayment and Disbursal Match") || data[i].Title.includes(DMSDoclist['Repayment and Disbursal Match']))//DMS added by swapnil 24317 
                        {
                            
                            for(var j=0;j<checkMap.length;j++){
                                if(checkMap[j].name == 'Repayment and Disbursal Match'){
                                    checkMap[j].upload = 'true';
                                    checkMap[j].toggle = 'true';
                                }
                            }
                            component.set("v.isUploadBanking",true);
                            //component.find('CustomerConsent-toggle').set("v.checked",true);
                            //$A.util.addClass(component.find('CustomerConsent-toggle'),'slds-theme_success');
                        }
                        if(data[i].Title.includes("Customer consent on Application Form")|| data[i].Title.includes(DMSDoclist['Customer consent on Application Form']))//DMS added by swapnil 24317 
                        {
                            
                            for(var j=0;j<checkMap.length;j++){
                                if(checkMap[j].name == 'Customer consent on Application Form'){
                                    checkMap[j].upload = 'true';
                                    checkMap[j].toggle = 'true';
                                }
                            }
                            component.set("v.isUploadAppForm",true);
                            //component.find('CustomerConsent-toggle').set("v.checked",true);
                            //$A.util.addClass(component.find('CustomerConsent-toggle'),'slds-theme_success');
                        }
                        else if(data[i].Title.includes("KYC") || data[i].Title.includes(DMSDoclist['KYC']))//DMS added by swapnil 24317 
                        {
                            for(var j=0;j<checkMap.length;j++){
                                if(checkMap[j].name == 'KYC'){
                                    checkMap[j].toggle = 'true';
                                }
                            }
                            component.set("v.isUploadeKyc",true);
                            //component.find('ekyc-toggle').set("v.checked",true);
                            //$A.util.addClass(component.find('ekyc-toggle'),'green-color');
                        }
                            else if(data[i].Title.includes("Perfios Response Recieved") || data[i].Title.includes(DMSDoclist['Perfios Response Recieved']))//DMS added by swapnil 24317 
                            {
                                for(var j=0;j<checkMap.length;j++){
                                    if(checkMap[j].name == 'Perfios Response Recieved'){
                                        checkMap[j].toggle = 'true';
                                    }
                                }
                                component.set("v.isUploadPerfios",true);
                                //component.find('perfios-toggle').set("v.checked",true);
                            } 
                                else if(data[i].Title.includes("E-Mandate and Repayment fields status") ||data[i].Title.includes(DMSDoclist['E-Mandate and Repayment fields status'])){//DMS added by swapnil 24317
                                    for(var j=0;j<checkMap.length;j++){
                                        if(checkMap[j].name == 'E-Mandate and Repayment fields status'){
                                            console.log('in emandate');
                                            checkMap[j].toggle = 'true';
                                        }
                                    }
                                    component.set("v.isUploadeMandate",true);
                                    //component.find('emandate-toggle').set("v.checked",true);
                                }  
                                    else if(data[i].Title.includes("SPDC Applicability") || data[i].Title.includes(DMSDoclist['SPDC Applicability']))//DMS added by swapnil 24317 
                                    {
                                        for(var j=0;j<checkMap.length;j++){
                                            if(checkMap[j].name == 'SPDC Applicability'){
                                                checkMap[j].toggle = 'true';
                                            }
                                        }
                                        component.set("v.isUploadSPDC",true);
                                        //component.find('SPDC-toggle').set("v.checked",true);
                                    }
                                        else if(data[i].Title.includes("IMPS and Disbursement fields status")  || data[i].Title.includes(DMSDoclist['IMPS and Disbursement fields status']))//DMS added by swapnil 24317 
                                        {
                                            for(var j=0;j<checkMap.length;j++){
                                                if(checkMap[j].name == 'IMPS and Disbursement fields status'){
                                                    checkMap[j].toggle = 'true';
                                                }
                                            }
                                            component.set("v.isUploadIMPS",true);
                                            //component.find('IMPS-toggle').set("v.checked",true);
                                        }
									else if(data[i].Title.includes("Rate Approval")){                                      
                                            for(var j=0;j<checkMap.length;j++){
                                                if(checkMap[j].name == 'Rate Approval'){
                                                    checkMap[j].toggle = 'true';
                                                }
                                            }
                        
									}   
                        
                    }  
                }
                console.log('checkmaop'+checkMap.length);
                component.set("v.checklistMap",checkMap);
                if(component.get("v.isUploadCustomerConsent") && component.get("v.isUploadeKyc") && component.get("v.isUploadPerfios") && component.get("v.isUploadeMandate") && component.get("v.isUploadSPDC") && component.get("v.isUploadIMPS") && component.get("v.isUploadCkyc"))//23578 added isUploadCkyc
                {
                    component.set("v.isUploadCompleted",true);
                }
            }
            
        });
    },
    /*24673 s*/
    checkAggStatusHelper : function(component,event) {
        this.showhidespinner(component,event,true);
        this.executeApex(component, 'checkRentalAggStatusApp', {
            "oppId": component.get("v.oppId")  
        }, function(error, result){
            console.log('error::'+error);
            console.log('result::'+result);
            component.set("v.aggStatus",result);
            if(result != null && result != '')
                this.displayToastMessage(component,event,'Success','Success','success');
            else if(!error || result == null || result == '')  	
                this.displayToastMessage(component,event,'Error','Error','error');
            
            this.showhidespinner(component,event,false);
        });
    },
    /*24673 e*/
    /*DMS 24317 s*/
    getDMSDocuments : function(component, event, helper){
        var product=component.get("v.oppObj.Product__c");
        console.log('DMS Prod '+product);
        this.executeApex(component, "getDMSDocuments", {
            "product":product
        }, function (error, result) {
            if (!error && result) {
                component.set("v.DMSDocmap",result);
                console.log('DMS result '+JSON.stringify(result));
                
            }
            else{
                console.log('DMS invalid file name');
            }
        });       
    },
    //24668 start
    populateApplData : function(component, event){
        this.setUIforApplicant(component, event);
        
        this.fetchApplData(component, event);    
        
    },
    setUIforApplicant : function(component, event){
        var checkMapForFinApp = [];
        
        checkMapForFinApp.push({
            name: 'Perfios Response Recieved',
            toggle: 'false',
            type : '',
            showUpload : 'true',
            showDocUploader : 'false'
        });
        checkMapForFinApp.push({            
            name: 'De-dupe linking completed',
            toggle: 'false',
            type : '',
            showUpload : 'true',
            showDocUploader : 'false'
        });
        
        component.set("v.checklistMapForFinApp",checkMapForFinApp);
    },
    fetchApplData : function(component, event){
        this.showhidespinner(component,event,true);
        var self = this;
        this.executeApex(component, 'getApplData', {
            "appId": component.get("v.curAppId")  
        }, function(error, result){
            var data = JSON.parse(result);
            console.log('data');
            console.log(data["bankAccLst"]);
            if(!data["bankAccLst"]){
                component.set("v.isPerRespForFinApp",true);                                    
            }
            else{
                
                var bankObjLst = JSON.parse(data["bankAccLst"]);
                console.log('ooooooooo');
                console.log(bankObjLst);
                if(bankObjLst && bankObjLst.length >0){
                    
                    var bankObj =  bankObjLst[0];
                    
                    //component.set("v.bankObj",bankObj); //Epic Id 5331 
                    
                    console.log(bankObj.Perfios_Flag__c);
                    if(bankObj.Perfios_Flag__c === true)
                    {
                        console.log('bankObjLst  '+bankObj.Perfios_Flag__c);
                        component.set("v.isPerRespForFinApp",true);
                    }
                    else
                    {
                        component.set("v.isPerRespForFinApp",false);
                        
                    }
                }
                else
                {
                    component.set("v.isPerRespForFinApp",true);
                }
            }
            
            var DeDupeList = component.get("v.DeDupeList");
            console.log('DeDupeList');
            console.log(component.get("v.finAppl").Contact_Name__r.CIF_Id__c);
            var opp = component.get("v.oppObj");
            if(opp.CUSTOMER__c == null){
                
                
                
                if(DeDupeList){
                    var isCoappDeDone = false;
                    for(var j=0;j<DeDupeList.length;j++){
                        if(DeDupeList[j].Applicant__c == component.get("v.curAppId")){                              
                            isCoappDeDone = true;
                            break;
                        }
                        
                    }
                    component.set("v.isDeDupeForFinApp",isCoappDeDone);
                }
                else{
                    
                    if(!($A.util.isEmpty(component.get("v.finAppl"))))
                    {
                        if(!($A.util.isEmpty(component.get("v.finAppl").Dedupe_Linking_Done__c)))
                        {
                            console.log('check dedupe');
                            if(component.get("v.finAppl").Dedupe_Linking_Done__c.toLowerCase() == 'reset')
                                component.set("v.isDeDupeForFinApp",true);
                            else if(!($A.util.isEmpty(component.get("v.finAppl").Contact_Name__r.CIF_Id__c)))
                            {
                                if(component.get("v.finAppl").Dedupe_Linking_Done__c.toLowerCase() == 'save' && !$A.util.isEmpty(component.get("v.finAppl").Contact_Name__r.CIF_Id__c))
                                    component.set("v.isDeDupeForFinApp",true);
                            } 
                        }      
                    }
                }
            }
            else{
                component.set("v.isDeDupeForFinApp",true);
            }
            
            self.genIconsForAppl(component, event);
            this.showhidespinner(component,event,false); 
            
        });        
    },
    genIconsForAppl : function(component, event){
        var iconMap = [];
        console.log('isPerRespForFinApp '+component.get("v.isPerRespForFinApp"));
        console.log('isDeDupeForFinApp '+component.get("v.isDeDupeForFinApp"));
        if(component.get("v.isPerRespForFinApp")==true){
            iconMap.push({
                name: 'Perfios Response Recieved',
                value: 'action:approval'
            });
            
        }
        else{
            
            iconMap.push({
                name: 'Perfios Response Recieved',
                value: 'action:close'
            });
        }
        
        if(component.get("v.isDeDupeForFinApp")==true){
            iconMap.push({
                name: 'De-dupe linking completed',
                value: 'action:approval'
            });
        }
        else{
            iconMap.push({
                name: 'De-dupe linking completed',
                value: 'action:close'
            });
            
        }
        
        component.set("v.mapOfIconsForFinApp",iconMap);
        console.log('icons');
        console.log(component.get("v.mapOfIconsForFinApp"));
    },
    //24668 stop
    /*added by swapnil for  Centralized Sampling changes Epic Id User Story ID 5331 s*/
    chk2 : function(component, event) {
        this.showhidespinner(component,event,true);
        console.log('inside call opportubity'+JSON.stringify(component.get("v.oppObj"))+' input primary app '+JSON.stringify(component.get("v.primaryapplicant"))+' input bankObj '+JSON.stringify(component.get("v.bankObj"))+' input Acc obj '+JSON.stringify(component.get("v.Accobj"))+' input VeriList '+JSON.stringify(component.get("v.CentralisedSOL")));
        this.executeApex(component, "checkCentralizedSampling", {
            'loanid': component.get("v.oppId"),
            'jsonOppobj':JSON.stringify(component.get("v.oppObj")),
            'jsonAppobj':JSON.stringify(component.get("v.primaryapplicant")),
            'jsonBankObj':JSON.stringify(component.get("v.bankObj")),
            'jsonAccountObj':JSON.stringify(component.get("v.Accobj")),
            'CentralisedSOL':JSON.stringify(component.get("v.CentralisedSOL"))
        }, function (error, result) {
            var resp = result;
            //alert(resp);
            if (!error && resp) {
                if(resp == 'success'){
                    this.getDashboardDetails(component,event);
                    this.showhidespinner(component,event,false);//24316 e 
                    this.displayToastMessage(component,event,'Success','Centralized Sampling check done','success');
                    this.showhidespinner(component,event,false);
                }
            }
            else{
                console.log('inside call error '+error);
                this.showhidespinner(component,event,false);
            }
            //this.showhidespinner(component,event,false);//24316 e   
            
            
        }); 
        
    }
    /*added by swapnil for  Centralized Sampling changes Epic Id User Story ID 5331 e*/
    
    
})