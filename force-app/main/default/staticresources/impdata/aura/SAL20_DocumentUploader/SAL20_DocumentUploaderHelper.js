({
    getDashboardDetails : function(component,event) {
        
        this.showhidespinner(component,event,true);
        this.executeApex(component, 'getPricingDashboardDetails', {
            "oppId": component.get("v.oppId")  
        }, function(error, result){
            
            if(!error && result){                
                var data = JSON.parse(result);
                
                component.set("v.primaryapplicant",data.applicantPrimary);//25333 Neha
                if(!($A.util.isEmpty(component.get("v.oppId"))))
                {
					
                    //component.set("v.nameTheme",data.theme);
                    
                    component.set("v.oppObj",data.opp);
                    var loanApplication = data.opp;
                    var Applicantdata = data.applicantPrimary;
                    var ekycObj = data.ekycobj;
                    
                    var states = data.statesEkyc;
                    var applicantAccount = data.accObj;
                    var applicantContact = data.objCon;
                    var bankAccountObj = data.bankObj;
                    
                    var discrepancyList = data.sanctionList;
                    
                    var repaymentModeDtlList = data.repayList;// for E-mandate check 
                    var verificationList = data.veriList;
                    
                    var disbursalList = data.disburement;
                    var fileNames = data.fileName;
                    // Ekyc Check Begins
                    var curr_state = '';
                    if(!($A.util.isEmpty(applicantAccount)) && !($A.util.isEmpty(applicantAccount.Current_State__c)))
                    {
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
                    /* Bug 25333 changes start */
                    //console.log(!$A.util.isEmpty(Applicantdata) + '&&' + !$A.util.isEmpty(Applicantdata.PFApproveStatus__c) + '&&' + Applicantdata.PFApproveStatus__c.includes('Pending'.ignoreCase));
                    if(!$A.util.isEmpty(Applicantdata) && !$A.util.isEmpty(Applicantdata.PFApproveStatus__c) && (Applicantdata.PFApproveStatus__c).toUpperCase().includes('PENDING')){
                        component.set("v.rateApprDone",false);    
                    }         
                    
                    /* Bug 25333 chnages end */
                    //perfios check begins
                    if($A.util.isEmpty(bankAccountObj))
                    {
                        component.set("v.isPerfiosResponse",true);
                    }
                    else{
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
                    //Repayment and Disbursal Match
                    if(/*25333 Start*/ !$A.util.isEmpty(bankAccountObj) && /*25333 End*/!$A.util.isEmpty(disbursalList) && !($A.util.isEmpty(repaymentModeDtlList))){
                        if(disbursalList[0].Repay_Disb_Diff__c)
                            component.set("v.isBanking",false);  
                        else{
                            console.log('***'+bankAccountObj.IFSC_Code__c + '****' + disbursalList[0].IFSC_Code__c + '****' + repaymentModeDtlList[0].IFSC_Code__c + '****'  + (disbursalList[0].Bank_Account__c == repaymentModeDtlList[0].A_C_NO__c) +' **** ' +bankAccountObj.Perfios_Account_No__c   );
                            if(/*25333 Start */(bankAccountObj.IFSC_Code__c != disbursalList[0].IFSC_Code__c) || (bankAccountObj.IFSC_Code__c != repaymentModeDtlList[0].IFSC_Code__c) ||  /*25333 End*/(disbursalList[0].IFSC_Code__c != repaymentModeDtlList[0].IFSC_Code__c) || (disbursalList[0].Bank_Account__c != repaymentModeDtlList[0].A_C_NO__c)/*25333 Start*/  || (bankAccountObj.Perfios_Account_No__c != repaymentModeDtlList[0].A_C_NO__c) || (disbursalList[0].Bank_Account__c != bankAccountObj.Perfios_Account_No__c)/*25333 End*/ )
                                component.set("v.isBanking",false);
                            else
                                component.set("v.isBanking",true);
                        }
                    }
                    else
                        component.set("v.isBanking",false);
                    if(!($A.util.isEmpty(Applicantdata)))
                    {
                        //Customer Acceptance check begins
                        if(!($A.util.isEmpty(Applicantdata.IP_Address_Timestamp__c)))
                        {
                            if(Applicantdata.IP_Address_Timestamp__c != 'Acceptance Pending' && Applicantdata.IP_Address_Timestamp__c!=null && Applicantdata.IP_Address_Timestamp__c.toUpperCase().includes('ACCEPTED') && Applicantdata.Reject_Reason__c ==null)
                            {
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
                        if(Applicantdata.Risk_Segmentation__c != 'HR' && Applicantdata.Risk_Segmentation__c != 'VHR')
                        {
                            component.set("v.isSPDCApplicable",true);
                        }
                        //SFDC Applicability check begins
                    }
                    //Geo Tagging check begins
                    if(!($A.util.isEmpty(verificationList)))
                    {
                        for(var i=0;i<verificationList.length ; i++)
                        {
                            if(verificationList[i].Verification_Type__c == 'Residence verification' || verificationList[i].Verification_Type__c == 'Office verification')
                            {	
                                if(verificationList[i].Geo_Tagging__c == true && $A.util.isEmpty(verificationList[i].Image_Latitude_Longitude_Details__c)){
                                    component.set("v.isGeoTagging",false);    
                                }  
                                else if(verificationList[i].Geo_Tagging__c == true && !$A.util.isEmpty(verificationList[i].Image_Latitude_Longitude_Details__c) && ($A.util.isEmpty(verificationList[i].Credit_Status__c) || verificationList[i].Credit_Status__c == 'Insufficient')){
                                    component.set("v.isGeoTagging",false);
                                }                                
                            }                            
                        }       
                    }  
                    
                    /*DMS bug 24317s*/
                    this.getDMSDocuments(component,event);
                    /*DMS bug 24317s*/
                    //Geo Tagging check ends
                    
                    this.colorDashboard(component,event);
                    this.uploadVerification(component,event);
                } 
            }
            this.showhidespinner(component,event,false);   
        });
        
    },
    
    executeApex: function(component, method, params,callback)
    {
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
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
    
    colorDashboard : function (component,event)
    {
        var checkMap = component.get("v.checklistMap");
        this.showhidespinner(component,event,false);
        for(var j=0;j<checkMap.length;j++){
            
            if(checkMap[j].name == 'Customer consent on Application Form'){
                if(component.get("v.isAppForm")==true)
                {
                    checkMap[j].isComplete = 'true';
                    checkMap[j].showDocUploader = 'false';
                }
                else{
                    checkMap[j].isComplete = 'false';
                }
            }
            /* start of Bug 25333 chnages  
            if(checkMap[j].name == 'Banking')
            {
                if(component.get("v.isBanking")==true)
        		{
            		checkMap[j].isComplete = 'true';
                    checkMap[j].showDocUploader = 'false';
            	}
                else{
                    checkMap[j].isComplete = 'false';
                }
        	} end of Bug 25333 chnages
            */
            if(checkMap[j].name == 'Customer consent on e-Agreement')
            {
                if(component.get("v.isCustomerConsent")==true)
                {
                    checkMap[j].isComplete = 'true';
                    checkMap[j].showDocUploader = 'false';
                }
                else{
                    checkMap[j].isComplete = 'false';
                }
            }
            /* start of Bug 25333 chnages
            if(checkMap[j].name == 'KYC')
            {
                if(component.get("v.isEkyc")==true)
        		{
            		checkMap[j].isComplete = 'true';
                    checkMap[j].showDocUploader = 'false';
            	}
                else{
                    checkMap[j].isComplete = 'false';
                }
        	}end of Bug 25333 chnages*/
            if(checkMap[j].name == 'Perfios Response Recieved')
            {
                if(component.get("v.isPerfiosResponse")==true)
                {
                    checkMap[j].isComplete = 'true';
                    checkMap[j].showDocUploader = 'false';
                }
                else{
                    checkMap[j].isComplete = 'false';
                }
            }
            if(checkMap[j].name == 'SPDC Applicability')
            {
                if(component.get("v.isSPDCApplicable")==true)
                {
                    checkMap[j].isComplete = 'true';
                    checkMap[j].showDocUploader = 'false';
                }
                else{
                    checkMap[j].isComplete = 'false';
                }
            }
            if(checkMap[j].name == 'Geo Tagging')
            {
                if(component.get("v.isGeoTagging")==true)
                {
                    checkMap[j].isComplete = 'true';
                    checkMap[j].showDocUploader = 'false';
                }
                else{
                    checkMap[j].isComplete = 'false';
                }
            }
            /* Bug 25333 changes start */
            if(checkMap[j].name == 'Rate Approval')
            {
                if(component.get("v.rateApprDone")==true)
                {
                    checkMap[j].isComplete = 'true';
                    checkMap[j].showDocUploader = 'false';
                }
                else{
                    checkMap[j].isComplete = 'false';
                }
            }   
            if(checkMap[j].name == 'Repayment and Disbursal Match')
            {
                if(component.get("v.isBanking")==true)
                {
                    checkMap[j].isComplete = 'true';
                    checkMap[j].showDocUploader = 'false';
                }
                else{
                    //console.log('In else Repayment');
                    checkMap[j].isComplete = 'false';
                }
            } 
            //   console.log('ckyc data '+component.get("v.primaryapplicant").Data_Source__c+'------ '+!component.get("v.primaryapplicant").Proof_of_Residence_Address_Submitted__c);
            
            if(checkMap[j].name == 'C-KYC')
            {
                if(component.get("v.primaryapplicant") && component.get("v.primaryapplicant").Data_Source__c && component.get("v.primaryapplicant").Data_Source__c == 'Copy CKYC Data' && (!component.get("v.primaryapplicant").Proof_of_Residence_Address_Submitted__c || (component.get("v.primaryapplicant").Proof_of_Residence_Address_Submitted__c && component.get("v.primaryapplicant").Proof_of_Residence_Address_Submitted__c != 'Utility bill')))
                {
                    console.log('In if ckyc');
                    checkMap[j].isComplete = 'true';
                    checkMap[j].showDocUploader = 'false';
                }
                else{
                    console.log('In else ckyc');
                    checkMap[j].isComplete = 'false';
                }
            }               
            
            /* Bug 25333 changes end */            
        }
    },    
    
    uploadVerification : function(component, event)
    {
        var checkMap = [];
        this.executeApex(component, 'getUploadVerification', {
            "PrimaryAppId": component.get("v.parentId")  //Added for DMS by swapnil 24317
        }, function(error, result){
            //code to fetch upload details
            if(!error && result)
            {
                var flag=1;
                
                var data = JSON.parse(result);
                var checkMap = component.get("v.checklistMap");
                console.log(' checkMap '+JSON.stringify(checkMap)+' checkMap size '+checkMap.length);
                var DMSDoclist=component.get("v.DMSDocmap"); //DMS added by swapnil 24317 s
                console.log('@@swapnil DMSDoclist ' + JSON.stringify(DMSDoclist));
                for(var i =0; i<data.length; i++)
                {	
                    if(!($A.util.isEmpty(data[i].Title)))
                    {
                        console.log('data' +JSON.stringify(data));
                        for(var j=0;j<checkMap.length;j++){
                            /*25333 S*/
                            if(data[i].Title.includes("Repayment and Disbursal Match")) 
                            {
                                //console.log('in repayment if1 ');
                                for(var j=0;j<checkMap.length;j++){
                                    if(checkMap[j].name == 'Repayment and Disbursal Match'){
                                        console.log('in repayment if2 ');
                                        checkMap[j].toggle = 'true';
                                    }
                                }
                                //component.set("v.isUploadBanking",true);
                                //component.find('CustomerConsent-toggle').set("v.checked",true);
                                //$A.util.addClass(component.find('CustomerConsent-toggle'),'slds-theme_success');
                            }
                            console.log('data *********** Title'+data[i].Title.includes('CK-YC.'));
                            if((data[i].Title.includes('CK-YC.') || data[i].Title.includes('CK-YC.')) && !data[i].Title.includes('CK-YC_img') )//DMS added by swapnil 24317 
                            {
                                console.log('in ckyc if1 ');
                                for(var j=0;j<checkMap.length;j++){
                                    if(checkMap[j].name == 'C-KYC'){
                                        // checkMap[j].upload = 'true';
                                        // console.log('in ckyc if2');
                                        checkMap[j].toggle = 'true';
                                        
                                    }
                                }
                                //component.set("v.isUploadCkyc",true); 
                                //isckypoi = true;
                                console.log('in both docs true'); 
                            }/*25333 E*/
                            if(data[i].Title.includes("Customer consent on e-Agreement") || data[i].Title.includes(DMSDoclist['Customer consent on e-Agreement']))//DMS added by swapnil 24317 
                            {
                                if(checkMap[j].name == 'Customer consent on e-Agreement'){
                                    checkMap[j].toggle = 'true';
                                }
                            }
                            /* Bug 25333 changes Start
                            else if(data[i].Title.includes("Banking") || data[i].Title.includes(DMSDoclist['Banking']))//DMS added by swapnil 24317 
                            {
                                 if(checkMap[j].name == 'Banking'){
                                     checkMap[j].toggle = 'true';
                                 }
                            }Bug 25333 changes end */
                            else if(data[i].Title.includes("Customer consent on Application Form")|| data[i].Title.includes(DMSDoclist['Customer consent on Application Form']))//DMS added by swapnil 24317 
                            {
                                if(checkMap[j].name == 'Customer consent on Application Form'){
                                    checkMap[j].toggle = 'true';
                                }
                            }
                            /* Bug 25333 changes start
                            else if(data[i].Title.includes("KYC")  || data[i].Title.includes(DMSDoclist['KYC'])){//DMS added by swapnil 24317 
                            {
                                if(checkMap[j].name == 'KYC'){
                                	checkMap[j].toggle = 'true';
                                }
                            }Bug 25333 changes end */
                                else if(data[i].Title.includes("Perfios Response Recieved") || data[i].Title.includes(DMSDoclist['Perfios Response Recieved'])){//DMS added by swapnil 24317 
                                    
                                    if(checkMap[j].name == 'Perfios Response Recieved'){
                                        checkMap[j].toggle = 'true';
                                    }
                                } 
                                    else if(data[i].Title.includes("SPDC Applicability") || data[i].Title.includes(DMSDoclist['SPDC Applicability'])){//DMS added by swapnil 24317 
                                        
                                        if(checkMap[j].name == 'SPDC Applicability'){
                                            checkMap[j].toggle = 'true';
                                        }
                                    }
                                        else if(data[i].Title.includes("DEGREE CERTIFICATE") || data[i].Title.includes(DMSDoclist['DEGREE CERTIFICATE'])){//DMS added by swapnil 24317 
                                            
                                            if(checkMap[j].name == 'Degree'){
                                                checkMap[j].toggle = 'true';
                                                //component.set('v.isDegreeCertificate',true);
                                                if(component.get("v.isDegreeCertificate")==true)
                                                {
                                                    checkMap[j].isComplete = 'true';
                                                    checkMap[j].showDocUploader = 'false';
                                                }
                                                else{
                                                    checkMap[j].isComplete = 'false';
                                                }
                                            }
                                        }
                        }  
                    }
                }
                component.set("v.checklistMap",checkMap);
            }
        });
    },    
    showhidespinner:function(component, event, showhide)
    {
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    }, /*DMS 24317 s*/
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
    },/*DMS upload 24317 s*/
    deleteDocToggle : function (component, event,FileName){
        var checkMap = component.get("v.checklistMap");
        var DMSDoclist= component.get("v.DMSDocmap");
        
        for(var i=0; i<checkMap.length; i++){
            if(checkMap[i].name == FileName || checkMap[i].title == FileName || FileName.includes(DMSDoclist[checkMap[i].name]) ){
                checkMap[i].toggle='false';
            }
        }
        component.set("v.checklistMap",checkMap);
    }
    /*DMS upload 24317 e*/
})