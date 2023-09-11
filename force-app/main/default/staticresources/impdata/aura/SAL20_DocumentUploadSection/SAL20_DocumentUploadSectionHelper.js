({  
    CO_ID_TO_CO_NAME_MAP : {},
    
    getDashboardDetails : function(component,event) {
        
        this.showhidespinner(component,event,true);
        this.executeApex(component, 'getPricingDashboardDetails', {
            "oppId": component.get("v.oppId")  
        }, function(error, result){
            console.log('Result of getPricingDashboardDetails ' +result);
            if(!error && result){
                
                var data = JSON.parse(result);
                console.log('data is '+data);
                if(!($A.util.isEmpty(component.get("v.oppId"))))
                {
                    component.set("v.nameTheme",data.theme);
                    component.set("v.oppObj",data.opp);
                    var loanApplication = data.opp;
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
                    var DeDupeList = data.dedupeList;
                    var disbursalList = data.disburement;
                    var officeVerificationFound = false;
                    var residenceVerificationFound = false;
                    var permanentAddressVerificationFound = false;
                    var bankVerificationFound = false;
                    component.set("v.isCommunityUser",data.isCommunityUsr);
                    component.set("v.stage",loanApplication.StageName);
                    // console.log('data.dedupeList'+data.dedupeList.length);
                    console.log(applicantContact);
                    console.log(states);
                    // component.set("v.isEkyc",data.ekycObj.bio_Ekyc__c);
                    /* for(insurance__c obj : insuranceList)
                {
                    
                } */
                    //insurance component set
                    component.set("v.isInsurance", true);
                    
                    
                    console.log($A.get("$Label.c.EnableBioEkyc"));
                    console.log($A.get("$Label.c.MandatoryBioEkyc"));
                    
                    
                 
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
                            console.log('customer consent on application form first if');
                            if(Applicantdata.Application_Form_Timestamp__c != 'Acceptance Pending' && Applicantdata.Application_Form_Timestamp__c!=null && Applicantdata.Application_Form_Timestamp__c.toUpperCase().includes('ACCEPTED'))
                            {
                                console.log('customer consent on application form second if');
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
                                  
                                if(verificationList[i].Geo_Tagging__c == true && $A.util.isEmpty(verificationList[i].Image_Latitude_Longitude_Details__c)){
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
                    console.log('pk dashboard'+component.get("v.isGeoTaggingToBranchOps")+component.get("v.isGeoTagging"));
                    this.colorDashboard(component,event);
                    this.uploadVerification(component,event);
                    
                } 
            }
            var customerConsent = component.get("v.isCustomerConsent");
            var isAppForm = component.get("v.isAppForm");
        	var isBanking = component.get("v.isBanking");
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
            var hideAadhaar = component.get("v.hideAadhaarSection");
            
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
        if(component.get("v.isBanking")==true)
        {
            
            //$A.util.addClass(document.getElementById('customer consent'),'green-color');
            iconMap.push({
                name: 'Banking',
                value: 'action:approval'
            });
            for(var j=0;j<checkMap.length;j++){
                if(checkMap[j].name == 'Banking'){
                    checkMap[j].showDocUploader = 'false';
                }
            }
            //component.find('file-uploader-Customer consent on e-Agreement').set('v.showUploadButton', false);    
        }
        else
        {
            iconMap.push({
                name: 'Banking',
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
            if(component.get("v.isBanking")==true && checkMap[i].type== 'BankCheck'){
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
        var isBanking = component.get("v.isBanking");
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
        var hideAadhaarSec = component.get("v.hideAadhaarSection");//added for bug id 21851
        
        if(isBanking == true  && isAppForm == true && customerConsent == true && eKyc == true && eMandate == true && IMPS == true && SPDC == true 
           && perfios == true && deDupe == true && insurance == true && discrepancy == true && residenceVerification == true 
           && officeVerification == true && permanentAddrVerification == true && BankVerification == true && geoTagging == true &&hideAadhaarSec == true)
        {
            component.set("v.isSendToFinnOne",true);
            
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
        }
        else if(isBanking == true && isAppForm == true && customerConsent == true && eKyc == false && eMandate == true && IMPS == true && SPDC == true 
                && perfios == true && deDupe == true && insurance == true && discrepancy == true && residenceVerification == true 
                && officeVerification == true && permanentAddrVerification == true && BankVerification == true && geoTagging == true)
        {
            this.showhidespinner(component,event,false);
            this.displayToastMessage(component,event,'Error','Please perform Ekyc!!!,Application cannot be sent to FinnOne','error');
            
        }
            else
            {
                
                this.showhidespinner(component,event,false);
                this.displayToastMessage(component,event,'Error','Application cannot be sent to FinnOne!','error');
                
                
                console.log("Cannot be sent to FinnOne");
            }
        
    },
    
    sendToBranchOps : function (component,event){
        this.showhidespinner(component,event,true);
        var deDupe = component.get("v.isDeDupe");
        var insurance = component.get("v.isInsurance");
        var isBanking = component.get("v.isBanking");
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
        var IMPS = component.get("v.isIMPS");
        var SPDC = component.get("v.isSPDCApplicable");
        var perfios = component.get("v.isPerfiosResponse");
        var geoTaggingBranchOps = component.get("v.isGeoTaggingToBranchOps");
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
        
        console.log('test ekyc'+component.get("v.isUploadeKyc"));
        if( deDupe == false || insurance == false || discrepancy == false || 
           bankVerification == false || officeVerification == false || residenceVerification == false || permanentVerification == false || geoTagging == false)
        {
            component.set("v.isSendToBranchOps",false);
            //hold in pricing
            console.log("Application Cannot be sent to BranchOps")
            this.showhidespinner(component,event,false);
            this.displayToastMessage(component,event,'Error','Application cannot be sent to BranchOps!','error');
        }
        else
        {
            this.uploadVerification(component,event);    
            console.log('show aadhar'+component.get("v.hideAadhaarSection"));
            if(component.get("v.isUploadCompleted")==true || component.get("v.isSendToFinnOne")==true )
            {
                this.callSubmitToBranchOpsHelper(component,event);
                console.log("Send to BranchOps ")
            }
            // added hideAadhaarSection for Bug 22047
            else if((isBanking == true || component.get("v.isUploadBanking")) && (isAppForm == true || component.get("v.isUploadAppForm") == true) && (customerConsent == true || component.get("v.isUploadCustomerConsent") == true)&& (component.get("v.hideAadhaarSection") || (eKyc == true||component.get("v.isUploadeKyc") == true)) && (eMandate == true||component.get("v.isUploadeMandate") == true) && (IMPS == true||component.get("v.isUploadIMPS") == true) && (SPDC == true || component.get("v.isUploadSPDC") == true) 
                    && (perfios == true || component.get("v.isUploadPerfios") == true) && deDupe == true && insurance == true && discrepancy == true && residenceVerification == true 
                    && officeVerification == true && permanentVerification == true && bankVerification == true && (geoTagging == true || geoTaggingBranchOps==true))
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
        var Banking = component.get("v.isBanking");
        // this.sendToFinnOne(component,event);
        if(customerConsent == true && eKyc == true && eMandate == true && IMPS == true && SPDC == true 
           && perfios == true && deDupe == true && insurance == true && discrepancy == true && residenceVerification == true 
           && officeVerification == true && permanentAddrVerification == true && BankVerification == true && geoTagging == true && Banking == true)
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
        this.executeApex(component, 'getUploadVerification', {
            "oppId": component.get("v.oppId")  
        }, function(error, result){
            //code to fetch upload details
            if(!error && result)
            {
                var flag=1;
                var data = JSON.parse(result);
                var checkMap = component.get("v.checklistMap");
                for(var i =0; i<data.length; i++)
                {																					//one flag
                    if(!($A.util.isEmpty(data[i].Title)))
                    {
                        if(data[i].Title.includes("Customer consent on e-Agreement")) 
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
                        if(data[i].Title.includes("Banking")) 
                        {
                            
                            for(var j=0;j<checkMap.length;j++){
                                if(checkMap[j].name == 'Banking'){
                                    checkMap[j].upload = 'true';
                                    checkMap[j].toggle = 'true';
                                }
                            }
                            component.set("v.isUploadBanking",true);
                            //component.find('CustomerConsent-toggle').set("v.checked",true);
                            //$A.util.addClass(component.find('CustomerConsent-toggle'),'slds-theme_success');
                        }
                        if(data[i].Title.includes("Customer consent on Application Form")) 
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
                        else if(data[i].Title.includes("KYC")){
                            for(var j=0;j<checkMap.length;j++){
                                if(checkMap[j].name == 'KYC'){
                                    checkMap[j].toggle = 'true';
                                }
                            }
                            component.set("v.isUploadeKyc",true);
                            //component.find('ekyc-toggle').set("v.checked",true);
                            //$A.util.addClass(component.find('ekyc-toggle'),'green-color');
                        }
                            else if(data[i].Title.includes("Perfios Response Recieved")){
                                for(var j=0;j<checkMap.length;j++){
                                    if(checkMap[j].name == 'Perfios Response Recieved'){
                                        checkMap[j].toggle = 'true';
                                    }
                                }
                                component.set("v.isUploadPerfios",true);
                                //component.find('perfios-toggle').set("v.checked",true);
                            } 
                                else if(data[i].Title.includes("E-Mandate and Repayment fields status")){
                                    for(var j=0;j<checkMap.length;j++){
                                        if(checkMap[j].name == 'E-Mandate and Repayment fields status'){
                                            console.log('in emandate');
                                            checkMap[j].toggle = 'true';
                                        }
                                    }
                                    component.set("v.isUploadeMandate",true);
                                    //component.find('emandate-toggle').set("v.checked",true);
                                }  
                                    else if(data[i].Title.includes("SPDC Applicability")){
                                        for(var j=0;j<checkMap.length;j++){
                                            if(checkMap[j].name == 'SPDC Applicability'){
                                                checkMap[j].toggle = 'true';
                                            }
                                        }
                                        component.set("v.isUploadSPDC",true);
                                        //component.find('SPDC-toggle').set("v.checked",true);
                                    }
                                        else if(data[i].Title.includes("IMPS and Disbursement fields status"))
                                        {
                                            for(var j=0;j<checkMap.length;j++){
                                                if(checkMap[j].name == 'IMPS and Disbursement fields status'){
                                                    checkMap[j].toggle = 'true';
                                                }
                                            }
                                            component.set("v.isUploadIMPS",true);
                                            //component.find('IMPS-toggle').set("v.checked",true);
                                        }
                        
                    }  
                }
                console.log('checkmaop'+checkMap.length);
                component.set("v.checklistMap",checkMap);
                if(component.get("v.isUploadCustomerConsent") && component.get("v.isUploadeKyc") && component.get("v.isUploadPerfios") && component.get("v.isUploadeMandate") && component.get("v.isUploadSPDC") && component.get("v.isUploadIMPS") )
                {
                    component.set("v.isUploadCompleted",true);
                }
            }
            
        });
    }
    
})