({
    getOpportunityData : function(component,event) {
        console.log('in helper');
        this.showhidespinner(component,event,true);
        var loanId = component.get("v.oppId");
        //console.log('var loan --->'+component.get("v.account").Employer__r.Name);
        
        var oppSelectList = ["Application_Source__c","Reject_Reason__c"];
        var selectListNameMap = {};
        selectListNameMap["Opportunity"] = oppSelectList;
        var action = component.get("c.getOpportunityData");
        action.setParams({"oppId":component.get("v.oppId"),"objectFieldJSON":JSON.stringify(selectListNameMap)});
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result -->'+result);
                if(!$A.util.isEmpty(result))
                {
                    var objlst = JSON.parse(result);
                    //prod adhoc address change start
                   if(!$A.util.isEmpty(objlst) && !$A.util.isEmpty(objlst.SOLPolicyList))
                    { 
                        component.set("v.solPolicylist",objlst.SOLPolicyList)
                        var solpolicylist = component.get("v.solPolicylist");
                        console.log("Length of sollist"+solpolicylist.length);
                        for (var i = 0; i < solpolicylist.length; i++) {
                            console.log("pk solpolicy"+solpolicylist[i]);
                            if(!$A.util.isEmpty(solpolicylist[i].Name) && solpolicylist[i].Name == 'Sales2.0 Address Change')
                            {
                                component.set("v.addresschangepolicy",solpolicylist[i]);
                            }
                            break;
                        }
                    }  
                    //prod adhoc address change end

                    //Rohit added for user id start
                    component.set("v.currentUser", objlst.userId);
                    console.log('rohit user id '+objlst.userId);
                    //Rohit added for user id stop
                    console.log('objlistr -->'+JSON.stringify(objlst));
                    //component.set("v.loan", objlst.loan);
                    var loan = component.get("v.loan");
                    //alert('loan id'+loan.Id+objlst.dsaFlowFlag);
                    if($A.util.isEmpty(loan.Id) && objlst.dsaFlowFlag===true){
                        component.set("v.conCreate",false);
                    }
                    if(!$A.util.isEmpty(loan.Id)){
                        component.set("v.officeflag",true);
                    }
                    
                    //alert('loan iss'+component.get("v.conCreate"));
                    
                    //Rohit added undefined check
                    if(loan != undefined && loan.Branch_Name__r != undefined && loan.Branch_Name__r.SAL_Branch_Type__c == 'Tier III')
                    {
                        component.set("v.isSpecialProfile", true);
                    }
                    component.set("v.account", objlst.accObj);
                    if (!$A.util.isEmpty(component.get("v.account")) && !$A.util.isEmpty(component.get("v.account.Employer__r"))) {
                        if(component.get("v.account.Employer__r.Name").toLowerCase() == 'others' || component.get("v.account.Employer__r.Name").toLowerCase() == 'other' || component.get("v.account.Employer__r.Name").toLowerCase() == 'company not listed'){                    
                            component.set("v.isOther",true);
                        } 
                        else{
                            component.set("v.isOther",false);
                        }
                    }
                    if (!$A.util.isEmpty(component.get("v.account")) && !$A.util.isEmpty(component.get("v.account.EPFO_Result__c"))) {
                        component.set("v.epfoShow",true); 
                    }   
                    component.set("v.contact", objlst.objCon);
                    component.set("v.oldOfficeemail", objlst.objCon.Office_Email_Id__c);//prod new CR
                    
                    var con =component.get("v.contact");
                    console.log('con iss'+con);
                    //Rohit added null check
                    if(con != null)
                        component.set("v.specialPro",con.Special_Profile_Employer__c);
                    //component.set("v.applicant", objlst.applicantPrimary);
                    //picklistfields
                    var picklistFields = objlst.picklistData;
                    var oppPickFlds = picklistFields["Opportunity"];
                    component.set("v.appSourceList", oppPickFlds["Application_Source__c"]);
                    component.set("v.rejectOption", oppPickFlds["Reject_Reason__c"]);
                    /* var rejectoptions = component.get("v.rejectOption");
                     var results =[];
                    for (var i = 0; i < rejectoptions.length; i++) {
                        results.push({"label": rejectoptions[i],"value": rejectoptions[i]});
                    }
                    component.set("v.myOptions",results);*/ 
                    console.log('themenameusr'+objlst.isCommunityUsr);
                    component.set("v.nameTheme",objlst.theme);
                    if(component.get('v.nameTheme') =='Theme3' || component.get('v.nameTheme') =='Theme2'){
                        component.set('v.rejectfordesktop',true);
                    }
                    if (!$A.util.isEmpty(objlst.isCommunityUsr)){
                        component.set('v.iscommunityUser', objlst.isCommunityUsr);
                    }
                    if (!$A.util.isEmpty(objlst.loginuser)){
                        component.set('v.userInfo', objlst.loginuser);
                    }
                    var LAN = component.get("v.loan.Loan_Application_Number__c"); //Added for Bug 23577
                    if (!$A.util.isEmpty(objlst.accObj.Mobile__c) && !$A.util.isEmpty(LAN)){ //Added LAN condition for Bug 23577
                        component.set('v.isMobileNumberReadOnly', true);
                        var mobileNo = "tel:"+ objlst.accObj.Mobile__c;//added for bug id 18906
                        component.set('v.mobileNumber', mobileNo);
                    }
                    else
                        component.set('v.isMobileNumberReadOnly', false);
                    if(objlst.isFieldAgent){
                        component.set("v.isFieldAgent", true);
                    }
                    else{
                        component.set("v.isFieldAgent", false);
                    }
                    if(objlst.isTeleCaller){
                        component.set("v.isTeleCaller", true);
                    }
                    else{
                        component.set("v.isTeleCaller", false);
                    }
                    
                    //lookupFields
                    //if sourcing channel not found, then display compare user
                    if(loan.Sourcing_Channel__c === undefined)
                    {
                        console.log('in src'+loan.Sourcing_Channel__c);
                        var selectedSource = objlst.defaultSourcingChannelName;
                        if(!$A.util.isEmpty(selectedSource)){//added if for bug id 18427
                            console.log('selectedSource'+selectedSource);
                            var keyword = selectedSource.Name;
                            var branchtype =selectedSource.Branch__c;
                            
                            component.set("v.loan.Branch_Name__c",branchtype);
                            if(!$A.util.isEmpty(selectedSource.Branch__c))
                                component.set("v.loan.Branch__c",selectedSource.Branch__r.Name);
                            if(!$A.util.isEmpty(selectedSource.sourcing_channel_user__r))
                                  component.set("v.loan.Relationship_Manager__c",selectedSource.sourcing_channel_user__r.Id);
                            else if(!$A.util.isEmpty(selectedSource.Reporting_Manager__r))
                                  component.set("v.loan.Relationship_Manager__c",selectedSource.Reporting_Manager__r.id);
                            if(!$A.util.isEmpty(selectedSource.Reporting_Manager__r)){
                                component.set("v.loan.ASM_email_id__c",selectedSource.Reporting_Manager__r.Email);
                                //component.set("v.loan.Relationship_Manager__c",selectedSource.Reporting_Manager__r.id);
                            }
                            console.log('branchtype -->'+branchtype);
                            if(!$A.util.isEmpty(selectedSource.Branch__c)){
                                if(selectedSource.Branch__r.SAL_Branch_Type__c == 'Tier III')
                                {
                                    component.set("v.isSpecialProfile", true);
                                }
                            }
                            console.log('keyword>>' + keyword);
                            component.set("v.selectedSource", selectedSource);
                            component.set("v.sourceSearchKeyword", keyword);
                            component.set("v.loan.Sourcing_Channel__c", selectedSource.Id);
                        }  
                    }
                    else if (!$A.util.isEmpty(loan.Sourcing_Channel__c))
                        component.set("v.sourceSearchKeyword", loan.Sourcing_Channel__r.Name);
                    var acc = component.get("v.account");
                    console.log('acc-->'+acc);
                    //console.log('area locality -->'+acc.Area_Locality__r.Name);
                    if (!$A.util.isEmpty(acc.Area_Locality__c))
                        component.set("v.areaSearchKeyword", acc.Area_Locality__r.Name);
                    /*City CR s*/
                    if (!$A.util.isEmpty(acc.Current_City__c))
                        component.set("v.citySearchKeyword", acc.Current_City__c);
                    /*City CR e*/
                    if (!$A.util.isEmpty(loan.Referral__c)) {
                        component.set("v.referralSearchKeyword", loan.Referral__r.Name);
                        console.log('referralSearchKeyword' + component.get("v.referralSearchKeyword"));
                    }
                    if(!$A.util.isEmpty(component.get('v.loan.Sourcing_Channel__c')))
                        component.set("v.ValidSourceChannel",true);
                    
                }
                this.showhidespinner(component,event,false);
                
            }
            else{
                this.showhidespinner(component,event,false);
                this.displayToastMessage(component,event,'Error','Error while fetching the record','error');
            }
            //US 21328s        
        if((component.get("v.dataSource")=='Copy CKYC Data') || (component.get("v.dataSource")=='Edit CKYC Data')){
            document.getElementById('subicon4').innerHTML = "[+]";
            $A.util.addClass(component.find('subsection4Content'), 'slds-hide');
            $A.util.removeClass(component.find('subsection4Content'), 'slds-show');
        }
        //US 21328e
        });
        $A.enqueueAction(action);
        
        
        
        
    },
    /* getUserIDfromApex : function(component,event) {
        this.executeApex(component, 'getUserIDfromApex', {},
                         function (error, result) {
                             if (!error && result) {
                                 console.log('result  : '+result);
                                 component.set("v.currentUser", result);
                             }
                         });   
    },*/
    saveLoanApplicationHelper: function (component,event,callfrom) {
        try{
        this.showhidespinner(component,event,true);
        
        var kyc = component.get("v.kyc");
        var loan = component.get("v.loan");
        var accObj = component.get("v.account");
        var contObj = component.get("v.contact");
        var applicantObj = component.get("v.applicant"); 
        //console.log('kyc id is'+kyc.Id);
        console.log(applicantObj);
        //console.log('account area'+accObj.Area_Locality__r.id);
        var pancmp = component.find("pancheck");
        var isvalid = pancmp.validateData();
        var isSourcevalid = this.validateSourceData(component);
        console.log('isSourcevalid-->'+component.get("v.callfrom")+component.get("v.ValidCompanyName"));
        var dateOfBirth = new Date(accObj.Date_of_Birth__c);
        var todaysDate = new Date();
        var validDate = true;
        if(dateOfBirth.getFullYear() > todaysDate.getFullYear()){
            validDate = false;
        }
        else if(dateOfBirth.getFullYear() == todaysDate.getFullYear()){
            if(dateOfBirth.getMonth() > todaysDate.getMonth()){
                validDate = false;
            }
            else if(dateOfBirth.getMonth() == todaysDate.getMonth()){
                if(dateOfBirth.getDate() >= todaysDate.getDate()){
                   	validDate = false;
                }
            }
        }
            
        //dateOfBirth.format("mm/dd/yy");
        //todaysDate.format("mm/dd/yy");
        console.log('dateOfBirth'+dateOfBirth+todaysDate);
        if(!validDate){
            this.displayToastMessage(component,event,'Error','Date of birth should be less than today','error');   
            this.showhidespinner(component,event,false); 
        }
        else if(!component.get("v.ValidSourceChannel")){
            this.displayToastMessage(component,event,'Error','Please select valid Sourcing Channel','error');   
            this.showhidespinner(component,event,false);  
        }
            else if(!component.get("v.ValidReferral")){
                this.displayToastMessage(component,event,'Error','Please select valid Referral','error');   
                this.showhidespinner(component,event,false);  
            }
        
                /*else if(!component.get("v.ValidAreaLocality")){
                    
                    this.displayToastMessage(component,event,'Error','Please select valid Area/Locality','error');   
                    this.showhidespinner(component,event,false);  
                }*/
        			/*City CR s*/
                    else if(!component.get("v.validCity")){
                        
                        this.displayToastMessage(component,event,'Error','Please enter valid City','error');   
                        this.showhidespinner(component,event,false);  
                    }
        			/*City CR e*/
                    else if(component.get("v.callfrom") && !component.get("v.ValidCompanyName")){
                        this.displayToastMessage(component,event,'Error','Please select valid Company Name','error');   
                        this.showhidespinner(component,event,false);  
                    }
                        else
                            if(isvalid && isSourcevalid){
                                
                                if (accObj.First_Name__c != null) {
                                    accObj.Name = accObj.First_Name__c;
                                    if (accObj.Middle_Name__c != null)
                                        accObj.Name = accObj.Name + ' ' + accObj.Middle_Name__c;
                                }
                                if (accObj.Last_Name__c != null)
                                    accObj.Name = accObj.Name + ' ' + accObj.Last_Name__c;
                                accObj.Group_Type__c = 'salaried';
                                accObj.Flow__c = 'Mobility V2';
                                accObj.Sourcing_Channel__c = loan.Sourcing_Channel__c;
                                accObj.PANNumber__c = accObj.PANNumber__c.toUpperCase();
                                console.log('con.Special_Profile_Employer__c'+component.get("v.specialPro"));
                                //contact mapping 
                                contObj.FirstName = accObj.First_Name__c;
                                contObj.Middle_Name__c = accObj.Middle_Name__c;
                                contObj.LastName = accObj.Last_Name__c;
                                contObj.ApplicantType__c = 'Primary';
                                contObj.Date_of_Birth__c = accObj.Date_of_Birth__c;
                                contObj.Customer_Type__c = loan.Customer_Type__c;
                                contObj.Mobile__c = accObj.Mobile__c;
                                contObj.PAN_Number__c = accObj.PANNumber__c;
                                contObj.Pin_Code__c= accObj.PinCode__c;
                                contObj.Special_Profile_Employer__c = component.get("v.specialPro");
								contObj.CKYCDocumentType__c = component.get("v.CKYCDocumentType"); //US11371
                                //component.set("v.con.Special_Profile_Employer__c",component.get("v.specialPro"))
                                if(accObj.Mobile__c != null) contObj.Mobile_Phone__c = accObj.Mobile__c;
                                //prod new CR s
                                if(!$A.util.isEmpty(component.get("v.oldOfficeemail")) && contObj.Office_Email_Id__c.toUpperCase() !== component.get("v.oldOfficeemail").toUpperCase()){
                                    contObj.Office_Email_sent__c = false;
                                    applicantObj.Office_Email_Id_Verified__c = false;
                                } 
                                //prod new CR e
                               component.set("v.oldOfficeemail",contObj.Office_Email_Id__c);//prod new CR

                                //opportuntiy mapping
                                loan.Name = accObj.Name;
                                console.log('product'+loan.Branch_Name__c);
                                loan.stageName = 'DSA/PSF Login';
                                loan.Approver__c = 'DSA';
                                //if(loan.Application_Received_Date__c == null) loan.Application_Received_Date__c = (new Date()).getDate();
                                console.log('loan.Branch_Name__c -->'+loan.Branch_Name__c);
                                console.log('loan.Branch__c -->'+loan.Branch__c);
                                console.log('loan.ASM_email_id__c -->'+loan.ASM_email_id__c);
                                console.log('loan.Relationship_Manager__c -->'+loan.Relationship_Manager__c);
                                loan.Loan_Application_Flow__c = 'Mid Office 1';
                                loan.Customer_Type__c = loan.Customer_Type__c;
                                if(component.get("v.loan.Sourcing_Channel__r.Name.Id") != null){
                                    component.set("v.loan.Sourcing_Channel__c",component.get("v.loan.Sourcing_Channel__r.Name.Id"));
                                    delete loan['Sourcing_Channel__r'];
                                }
                                if(component.get("v.loan.Referral__r") != null && component.get("v.loan.Referral__r.Name.Id") != null){
                                    component.set("v.loan.Referral__c",component.get("v.loan.Referral__r.Name.Id"));
                                    delete loan['Referral__r'];
                                }
                                
                                if(component.get("v.account.Area_Locality__r") != null){
                                    // component.set("v.account.Area_Locality__c",component.get("v.account.Area_Locality__r.id"));
                                    delete loan['Area_Locality__r'];
                                }
                                
                                if(component.get("v.callfrom") && component.get("v.account.Employer__r.Name.Id") != null && component.get("v.account.Employer__r") != null){
                                    component.set("v.account.Employer__c",component.get("v.account.Employer__r"));
                                    delete loan['Employer__r'];
                                }
                                //console.log('kyc obj'+kyc);
                                if(!$A.util.isEmpty(kyc) && !$A.util.isEmpty(kyc.Id)){
                                    //console.log('in set ekyc'+kyc.Id);
                                    applicantObj.eKYC_Processing__c = true;
                                }
                                //console.log('pkinsave'+component.get("v.account.Area_Locality__c"));
								//23578 start 
                            applicantObj.Data_Source__c = component.get("v.dataSource");
                            
                            console.log('robin666');
                            console.log(component.get('v.ckycResp'));
                            var attachments = [];
                            if(component.get('v.ckycResp') && component.get('v.ckycResp')["CKYCPhoto_raw"]){
                                
                                attachments.push(component.get('v.ckycResp')["CKYCPhoto_raw"]);    
                            }
							//23578 stop
                                applicantObj.Customer_Name__c = accObj.First_Name__c + ' ' + accObj.Last_Name__c;
                                applicantObj.Applicant_Type__c = 'Primary';
                                applicantObj.Contact_Mobile__c = contObj.Mobile_Phone__c;
                                console.log('account id'+applicantObj.Applicant_Type__c);
                                var tatMasterRecord = component.get("v.tatMasterRecord");
                                //console.log('tatMasterRecord'+tatMasterRecord.PAN_Number__c);
                                var policylst = component.get("v.PrimaryPNCheckLst");
								//23578 rohit start
                            if(component.get('v.ckycResp')){
                                var ckycResp = Object.assign({}, component.get('v.ckycResp'));
                                delete ckycResp['Applicant__c'];
                                delete ckycResp['Account'];
                                delete ckycResp['Contact'];
                                console.log('in ckyc response robin999');
                                console.log(JSON.parse(ckycResp["CKYCImageDetails"])[0]);
                                
                                //attach all docs from CKYC start 23578
                                if(ckycResp["CKYCImageDetails"]){
                                	var imageLst = JSON.parse(ckycResp["CKYCImageDetails"]);
                                    for(var i =0; i<imageLst.length;i++){ 
                                        if(!imageLst[i].CKYCImageType.includes("Photo")){
                                        	attachments.push({"Name":"CKYC Doc "+imageLst[i].CKYCImageType,"image":imageLst[i].CKYCImageData,"extension":imageLst[i].CKYCImageExtension});
                                        }
                                    }
                                }
                                  if(component.get('v.ckycResp') && component.get('v.ckycResp')["CKYCPhoto"]){
                                
                                attachments.push({"Name":"CKYC Photo","image":component.get('v.ckycResp')["CKYCPhoto"],"extension":"jpg"});    
                           		 }
                                console.log('robin attachs' );
                                component.set("v.attachments",attachments);
                                console.log(JSON.stringify(attachments));
                                //attach all docs from CKYC stop 23578
                                var ckycSolPly = new Object();
                                ckycSolPly.Name = 'Ckyc response';
                                ckycSolPly.attributes = {"type":"SOL_Policy__c"};
                                delete ckycResp["CKYCPhoto"];
                                //ckycSolPly.Old_Loan_Application__c = JSON.stringify(ckycResp["CKYCImageDetails"]);
                                delete ckycResp["CKYCImageDetails"];
                                ckycSolPly.Old_Loan_Application__c	 = JSON.stringify(ckycResp);
                                
                                ckycSolPly.Policy_Name__c = 'Ckyc response';
                                policylst.push(ckycSolPly);
                            }
                            
                           
                          
                            
                            //23578 rohit stop
                                //contObj.Residence_Type__c = '';
                                accObj.Accountant_email_id__c = contObj.Office_Email_Id__c;
                                var addresschangepolicy = component.get("v.addresschangepolicy");
                                if($A.util.isEmpty(component.get("v.addresschangepolicy")) && $A.util.isEmpty(component.get("v.addresschangepolicy").id))
                                {
                                   addresschangepolicy.Name = 'Sales2.0 Address Change';
                                   addresschangepolicy.Policy_Name__c = 'Address Change';
                                   addresschangepolicy.Loan_Application__c = component.get("v.oppId");
                                   addresschangepolicy.Applicant_Name__c = component.get("v.applicant").Id;
                                   addresschangepolicy.copyAddressFrom__c =  'NewAddress';
                                   policylst.push(addresschangepolicy);
                                   component.set("v.addresschangepolicy",addresschangepolicy);
                                }
console.log('Cache is cleared');
                            this.executeApex(component, 'saveLoanApplicationDummy', {
                                
                                "loan" :JSON.stringify(loan),
                                "acc":JSON.stringify(accObj),
                                "con":JSON.stringify(contObj),
                                "appObj":JSON.stringify(applicantObj),
                                "policylst" :JSON.stringify(policylst),
                                "ekycObj":JSON.stringify(kyc),
                                "tatMasterRecord":JSON.stringify(tatMasterRecord),
                                "ckycSms":JSON.stringify(component.get("v.ckycsmsLst")),
                                "attachments":JSON.stringify(component.get("v.attachments"))
                                
                            }, function (error, result) {
                                    console.log('result : ' + result);
                                    if (!error && result && result.length) {
                                        var data = JSON.parse(result);
                                        if(!$A.util.isEmpty(data) && !$A.util.isEmpty(data.status)){
                                            if(data.status == 'We cannot proceed due to duplicate data!'){
                                            	this.showhidespinner(component,event,false);
                                        		this.displayToastMessage(component,event,'Error','We cannot proceed further due to duplicate data','error');   
                                            }
                                            else if(data.status == 'Line PO already exists for this customer. Kindly convert the PO'){
                                            	this.showhidespinner(component,event,false);
                                        		this.displayToastMessage(component,event,'Error','Line PO already exists for this customer. Kindly convert the PO','error');   
                                            }
                                            else{
                                            	component.set("v.loan", data.opp);
                                                console.log('loanapp'+JSON.stringify(data.opp));
                                                component.set("v.contact", data.objCon);
                                                component.set("v.applicant", data.applicantPrimary);
                                               if (data.opp !=null && data.opp.Id != null)
                                                    component.set("v.recordId", data.opp.Id);
                                        component.set('v.tabVisiblityclone',true); //added for bug 23577
                                              if (data.opp !=null && data.opp.Id != null)
                                                component.set("v.oppId", data.opp.Id);
                                                policylst = [];
                                                console.log('We are here');
                                                if(!$A.util.isEmpty(data.SOLPolicyList)){
                                                for(var i=0;i<data.SOLPolicyList.length;i++){
                                                    if(data.SOLPolicyList[i].Name == 'Sales2.0-Primary Pan Check')
                                                        policylst.push(data.SOLPolicyList[i]);
                                                    if(!$A.util.isEmpty(data.SOLPolicyList[i].Name) && data.SOLPolicyList[i].Name == 'Sales2.0 Address Change')//prod adhoc address change
                                                    {
                                						component.set("v.addresschangepolicy",data.SOLPolicyList[i]);
                                                    }

                                                }}
                                                console.log('We are here1');
                                                component.set("v.PrimaryPNCheckLst", policylst);
                                                if (data !=null && data.ekycobj != null && !$A.util.isEmpty(data.ekycobj.eKYC_First_Name__c))
                                                    component.set('v.kyc',data.ekycobj);
                                                else
                                                    component.set('v.disableAadhaar',true);   
                                                
                                                if (data !=null && data.accObj != null)
                                                    component.set("v.account", data.accObj);
                                                else
                                                    component.set('v.disablePAN',true);  
                                                //console.log('account id'+data.accObj.Id);
                                                if (data !=null && data.poobj != null)
                                                    component.set("v.poobj", data.poobj);
                                                else
                                                    component.set('v.disablePO',true); 
                                                var oppStage ;
                                                if (data.opp !=null)
                                                 oppStage = data.opp.StageName;
                                                console.log('stagehere'+oppStage);
                                                if(oppStage != null)
                                                {
                                                    if(oppStage == 'DSA/PSF Login')
                                                    {
                                                        component.set("v.conCreate",true);
                                                        component.set("v.officeflag",true);
                                                        component.set("v.stageCompletion","20%") ;
                                                    }
                                                    else if(oppStage == 'MCP Reject')
                                                    {
                                                        console.log('in mcp reject Console');
                                                        component.set("v.stageCompletion","0%") ;
                                                        component.set("v.MCPRejectON",false) ;
                                                        
                                                        var cmpEvent =  $A.get("e.c:MCPRejectEvent");
                                                        cmpEvent.setParams({
                                                            "flag": false
                                                        });
                                                        cmpEvent.fire();
                                                        console.log('after fire event');
                                                        this.showhidespinner(component,event,false);
                                                    }
                                                }
                                                if(!component.get("v.callfrom"))
                                                    this.showhidespinner(component,event,false);
                                                console.log('DataStatus'+data.status);
                                                if(data.status.includes('successfully'))
                                                {
                                                    this.showhidespinner(component,event,false);
                                                    this.displayToastMessage(component,event,'Success',data.status,'success');
													  //23578 start
                							if(component.get("v.applicant") && component.get("v.applicant").Data_Source__c && (component.get("v.applicant").Data_Source__c == 'Copy CKYC Data' || component.get("v.applicant").Data_Source__c == 'Edit CKYC Data')){
                    							component.set("v.isCkycReadOnly",true);
                                                console.log('here isCkycReadOnly');
                							}
               								 //23578 stop
                                                    //Added for bug 23064 start
                                                    
                                                    var validExotelProd;
                                                    component.set("v.displayExotel",false);
                                                    this.executeApex(component,'getvalidExotelProduct', {
                                                        
                                                    }, function (error, result) {
                                                        
                                                        console.log('result'+result);
                                                        if (!error && result) {
                                                            
                                                            var data=JSON.parse(result);
                                                            //alert(component.get("v.loan.Products__c"));
                                                            component.set("v.validExotelProd",data);
                                                            validExotelProd=component.get("v.validExotelProd");
                                                            console.log('prodsvalid'+validExotelProd);
                                                            for(var i=0 ; i < validExotelProd.length ; i++){
                                                                debugger;
                                                                if(validExotelProd[i].toUpperCase() === component.get("v.loan.Product__c").toUpperCase() ){
                                                                 		component.set("v.displayExotel",true);
                                                                }
                                                            }
                                                            
                                                        }else{
                                                            alert('no data');
                                                        }
                                                    }); 
                                                    //Added for bug 23064 end
                                                    if(component.get("v.callfrom"))
                                                        this.callPANBre(component);
                                                    component.set("v.callfrom",true);
                                                }
                                                else
                                                    this.displayToastMessage(component,event,'Error',data.status,'error');
                                                //Rohit disable fields start
                                                pancmp.disableFields();
                                                //Rohit disable fields stop  
                                            }
                                           // user story 978 start
                                                var updateidentifier =  $A.get("e.c:Update_identifier");
                                                updateidentifier.setParams({
                                                    "eventName": 'Landing Page',
                                                    "oppId":data.opp.Id,
                                                     "appId":data.applicantPrimary.Id
                                                });
                                                updateidentifier.fire();
                                                //user story 978 end
                                            
                                        }
                                        else
                                        {
                                            this.showhidespinner(component,event,false);
                                            this.displayToastMessage(component,event,'Error',data.status,'error');
                                        }
                                    }
                                    else{
                                        this.showhidespinner(component,event,false);
                                        this.displayToastMessage(component,event,'Error','Failed to create loan application.','error');
                                    }
                                    //Rohit mcp call start              
                                    //this.displayToastMessage(component,event,'Message','Please wait, Initiating MCP ...','message');
                                    /*this.executeApex(component, "callMCPforDOB",{"params":{"solPolicySrc":component.get("v.solPolicySrc"),
                                                                       "empAccount":JSON.stringify([component.get("v.account")]),
                                                                       "empContact":JSON.stringify([component.get("v.contact")]),
                                                                       "empOpp":JSON.stringify([component.get("v.loan")]),
                                                                       "TypeForMCP":"DOB"}},function(error, result){
                                                                           if(!error && result == "Success"){
                                                                               this.displayToastMessage(component,event,'Message','MCP Pass','message');    
                                                                           }
                                                                           else if(result == "Failure"){
                                                                               this.displayToastMessage(component,event,'Message','MCP Fail','message');                         
                                                                           }
                                                                               else {
                                                                                   this.displayToastMessage(component,event,'Error','Internal Server error , Please try again !','error');     
                                                                               }
                                                                           
                                                                       });
                //Rohit mcp call stop*/
                             
                         });
                     }
                        else{
                            this.showhidespinner(component,event,false);
                            this.displayToastMessage(component,event,'Error','Please Enter All Mandatory Details','error');
                        }
        
        }catch(e){console.error('saveLoanApplicationHelper Error '+e.lineNumber);}//US11371
    },
        
    showHideDiv: function(component, divId, show){
        console.log('in show hide');
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
    showSpinner: function (component) {
        this.showHideDiv(component, "waiting", true);
    },
    hideSpinner: function (component) {
        this.showHideDiv(component, "waiting", false);
    },
    showhidespinner:function(component, event, showhide){
        console.log('in showhidespinner');
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },
    displayToastMessage:function(component,event,title,message,type)
    {
        
        //alert('display from sal salescmp');
        console.log('inside displayToastMessage'+message+type);
        //24673/25289 start
        var toastEvent = $A.get("e.force:showToast");
        
        if(toastEvent){ //Standard toast message : if supports standard toast message !$A.get("$Browser.isIPhone")
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "3000"
            });    
            toastEvent.fire();
            
        }else {//24673/25289 stop
            var showhideevent =  $A.get("e.c:ShowCustomToast");
            
            showhideevent.setParams({
                "title": title,
                "message":message,
                "type":type
            });
            showhideevent.fire();
        }
    } , 
    
    startSearch: function (component, key) {
        var keyword = component.get("v." + key + "SearchKeyword");
        console.log("keyword" + keyword+"key"+key);
        if(key == 'source')
        {
            if (keyword.length > 2 && !component.get('v.sourcesearching')) {
                console.log("keyword sourcesearching" + keyword+"key"+key);
                component.set('v.sourcesearching', true);
                component.set('v.oldSearchKeyword', keyword);
                this.searchHelper(component, key, keyword);
            }
            else if (keyword.length <= 2) {
                console.log("keyword" + keyword+"key"+key);
                component.set("v." + key + "List", null);
                this.openCloseSearchResults(component, key, false);
            }
        }
        if(key == 'referral')
        {
            if (keyword.length > 2 && !component.get('v.referralsearching')) {
                component.set('v.referralsearching', true);
                component.set('v.oldReferralSearchKeyword', keyword);
                this.searchHelper(component, key, keyword);
            }
            else if (keyword.length <= 2) {
                console.log("keyword" + keyword+"key"+key);
                component.set("v." + key + "List", null);
                this.openCloseSearchResults(component, key, false);
            }
        }
    },
    searchHelper: function (component, key, keyword) {
        console.log('executeApex>>' + keyword + '>>key>>' + key);
        
        this.executeApex(component, "fetch" + this.toCamelCase(key), {
            'searchKeyWord': keyword
        }, function (error, result) {
            console.log('result : ' + result);
            if (!error && result) {
                this.handleSearchResult(component, key, result);
            }
        });
    },
    toCamelCase: function (str) {
        return str[0].toUpperCase() + str.substring(1);
    },
    openCloseSearchResults: function (component, key, open) {
        var resultPanel = component.find(key + "SearchResult");
        $A.util.addClass(resultPanel, open ? 'slds-is-open' : 'slds-is-close');
        $A.util.removeClass(resultPanel, open ? 'slds-is-close' : 'slds-is-open');
    },
    handleSearchResult: function (component, key, result) {
        console.log('key :  handleSearchResult' + key);
        console.log(result);
        console.log('v.oldSearchKeyword :' + component.get('v.oldSearchKeyword') + '  -> SearchKeyword : ' + component.get("v." + key + "SearchKeyword"));
        
        console.log('inside handleserach'+component.get('v.oldSearchKeyword')+component.get("v." + key + "SearchKeyword"));
        if(key == 'source')
        {
            component.set('v.sourcesearching', false);
            if (!$A.util.isEmpty(component.get("v." + key + "SearchKeyword")) && component.get('v.oldSearchKeyword') !== component.get("v." + key + "SearchKeyword")) {
                component.set("v." + key + "List", null);
                this.startSearch(component, key);
            }
            else {
                component.set("v." + key + "List", result);
                //this.showHideMessage(component, key, !result.length);
                this.openCloseSearchResults(component, key, true);
            }
        }
        if(key == 'referral')
        {
            component.set('v.referralsearching', false);
            if (!$A.util.isEmpty(component.get("v." + key + "SearchKeyword")) && component.get('v.oldReferralSearchKeyword') !== component.get("v." + key + "SearchKeyword")) {
                component.set("v." + key + "List", null);
                this.startSearch(component, key);
            }
            else {
                component.set("v." + key + "List", result);
                //this.showHideMessage(component, key, !result.length);
                this.openCloseSearchResults(component, key, true);
            }
        }
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
    isEmpty: function (value) {
        return ($A.util.isEmpty(value) || $A.util.isUndefined(value) || value === 0);
    },
    
    validateSourceData :function (component) {
        var list = ["AppSource","ProductType"];
        var isvalid =true;
        for (var i = 0; i < list.length; i++) {
            console.log('list[i]>>' + list[i]);
            //console.log(component.find(list[i]));
            var a =component.find("AppSource");
            console.log(a);
            if (component.find(list[i]) && !component.find(list[i]).get("v.validity").valid)
            {
                isvalid = false;
                component.find(list[i]).showHelpMessageIfInvalid();
            }
        }
        if($A.util.isEmpty(component.get("v.sourceSearchKeyword")))
        {
            isvalid = false;
            component.find("sourceName").set("v.errors", [{
                message: "Please Enter Value"
            }
                                                         ]);
        }
        
        
        
        
        /* if(this.isEmpty(component.get("v.referralSearchKeyword")))
        {
            
            component.find("referralName").set("v.errors", [{
                message: "Please Enter Value"
            }]);
            
            isvalid = false;
        }*/
        return isvalid;
    },
    salesRejectHelper :function(component,event){
        //this.showhidespinner(component,event,true);
        console.log('inside salesReject');
        var loan = component.get("v.loan");
        loan.Reject_Reason__c = component.get("v.mySelectedvalues");
        component.set("v.loan",loan);
        var jsonoppObj =JSON.stringify([component.get("v.loan")]);
        this.executeApex(component, 'salesReject', {
            "jsonoppObj": jsonoppObj
        }, function(error, result){
            if(!error && result){
                if(!$A.util.isEmpty(result))
                {
                    component.set("v.loan",result);
                    component.set("v.stageCompletion" ,"20%");
                    this.showhidespinner(component,event,false);
                    if(component.get('v.nameTheme') =='Theme3' || component.get('v.nameTheme') =='Theme2'){
                        if(component.get('v.iscommunityUser'))
                            window.location.href = '/Partner/006/o';
                        else
                            window.location.href = '/006/o';
                    }else if(component.get('v.nameTheme') == 'Theme4d')
                        window.location.href = '/lightning/o/Opportunity/list?filterName=Recent';
                        else if(component.get('v.nameTheme') == 'Theme4t')
                            this.onLoadRecordCheckForSF1(component, event);
                }
                else
                    this.showhidespinner(component,event,false);
            }
            else
                this.showhidespinner(component,event,false);
        });
    },
    onLoadRecordCheckForSF1 : function(component, event) {
        var action = component.get('c.getLoanApplicationListViews');
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var listviews = response.getReturnValue();
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
    },
    doEmpCheck : function(component, event) {
        this.showhidespinner(component,event,true);
        this.executeApex(component, "doEmploymentChecks",{
            "accObj": JSON.stringify(component.get("v.account")),
            "oppObj": JSON.stringify(component.get("v.loan")),
            "cont": JSON.stringify(component.get("v.contact"))
        },
                         function(error, result){
                             var objlst = JSON.parse(result);
                             console.log('objlistr -->'+JSON.stringify(objlst.objCon));
                             if(!$A.util.isEmpty(objlst))
                             {
                                 if(objlst.status == 'success')
                                 {
                                     component.set("v.applicant",objlst.applicantPrimary);
                                     component.set("v.contact",objlst.objCon);
                                     component.set("v.account",objlst.accObj);
                                     this.displayToastMessage(component,event,'Success','Employment Check Initiated Successfully','success'); 
                                     this.showhidespinner(component,event,false);
                                 }
                                 else
                                 {
                                     this.displayToastMessage(component,event,'Error',result,'error'); 
                                     this.showhidespinner(component,event,false);
                                 }
                             }
                         });
    },
    doEPFO : function(component, event) {
        this.showhidespinner(component,event,true);
        this.executeApex(component, "doEPFOChecks",{
            "accObj": JSON.stringify(component.get("v.account")),
            "oppObj": JSON.stringify(component.get("v.loan")),
            "cont": JSON.stringify(component.get("v.contact"))
        },
                         function(error, result){
                             var objlst = JSON.parse(result);
                             console.log('objlistr -->'+JSON.stringify(objlst.objCon));
                             if(!$A.util.isEmpty(objlst))
                             {
                                 if(objlst.status == 'success')
                                 {
                                     //component.set("v.applicant",objlst.applicantPrimary);
                                     component.set("v.contact",objlst.objCon);
                                     component.set("v.account",objlst.accObj);
                                     this.displayToastMessage(component,event,'Success','EPFO check done Successfully','success'); 
                                     this.showhidespinner(component,event,false);
                                 }
                                 else
                                 {
                                     this.displayToastMessage(component,event,'Error','Error in EPFO check','error'); 
                                     this.showhidespinner(component,event,false);
                                 }
                             }
                         });
    },
	//23578 start
    setCkycFields : function(component,event) {
        try{
        this.showhidespinner(component,event,true);
        var respMap =  event.getParam("infObj");            
        var months = {"Jan":"01", "Feb":"02", "Mar":"03", "Apr":"04", "May":"05", "Jun":"06", "Jul":"07", "Aug":"08", "Sep":"09", "Oct":"10", "Nov":"11", "Dec":"12"};                
        if(respMap["CKYCDOB"]){
            var dobStr = respMap["CKYCDOB"].split("-");
            var modifedDob = dobStr[2]+'-'+months[dobStr[1]]+'-'+dobStr[0];
            respMap["CKYCDOB"] = modifedDob;
        }
        if(respMap["CKYCOccupation"]){
            var occMapping = {"B-01":"Business","O-01":"Professional","O-02":"Self Employed","O-03":"Retired","O-04":"Housewife","O-05":"Others","S-01":"Public Sector","S-02":"Private Sector","S-03":"Government Sector","X-01":"Others"};
            var occupation = respMap["CKYCOccupation"];
            respMap["CKYCOccupation"] = occMapping[occupation];
        }
        if(respMap["CKYCMaritalStatus"]){
            var marMapp={"01":"Married","02":"Single","03":"Others"}
            var marStatus = respMap["CKYCMaritalStatus"];
            respMap["CKYCMaritalStatus"] = marMapp[marStatus];
        }
        component.set("v.ckycResp",respMap); 
        component.set("v.ckycsmsLst",event.getParam("ckycsmsLst")); 
        var app = JSON.stringify(component.get("v.applicant"));
        var con = JSON.stringify(component.get("v.contact"));
        var acc = JSON.stringify(component.get("v.account"));
        console.log('ckyc response ');
        console.log(respMap);                 
        respMap["Applicant__c"] = app;
        respMap["Account"] = acc;
        respMap["Contact"] = con;
        var self = this;    
        
        this.executeApex(component,"fetchCkycdata",{"data":JSON.stringify(respMap)},function(error, result){
		component.set("v.isCkycAttempted",true);//21328
            var response = JSON.parse(result);
            console.log(response);
            self.showhidespinner(component,event,false);
            if(response && response.status == 'success'){
                component.set("v.dataSource","Copy CKYC Data");
                component.set("v.isCkycDone",true);
                if(component.get("v.ckycResp") && component.get("v.ckycResp")["mobNo"]){
                    self.sendSmsForCkyc(component, event);
                }
                
                if(response.objCon){
                    component.set("v.contact",response.objCon);   
                    var contact = component.get("v.contact");
                    var allAddress = '';
                    
                    if(contact.Permanant_Address_Line_1__c){
                        allAddress = allAddress +contact.Permanant_Address_Line_1__c+' ';
                    }
                    if(contact.Permanant_Address_Line_2__c){
                        allAddress = allAddress +contact.Permanant_Address_Line_2__c+' ';
                    }
                    if(contact.Permanant_Address_Line_3__c){
                        allAddress = allAddress +contact.Permanant_Address_Line_3__c;
                    }
                    var result = self.splitAddress(component,event,allAddress);
                    if(!$A.util.isEmpty(result))
                    {
                        if(result[0])
                            contact.Permanant_Address_Line_1__c = result[0];
                        else
                            contact.Permanant_Address_Line_1__c ='';
                        if(result[1])
                            contact.Permanant_Address_Line_2__c =result[1];
                        else
                            contact.Permanant_Address_Line_2__c='';
                        if(result[2])
                            contact.Permanant_Address_Line_3__c =result[2];
                        else
                            contact.Permanant_Address_Line_3__c=contact.Permanant_City__c;
                        
                        
                    }
                    var conGender = component.get("v.ckycResp")["CKYCGender"];
                    if(conGender){
                        if(conGender == "M"){
                            contact.Sex__c = "M";
                        }
                        else if(conGender == "F"){
                            contact.Sex__c = "F";
                        }
                        
                    }
                    
					//11371s
                    allAddress='';
                    if(contact.Address_1__c){
                        allAddress = allAddress +contact.Address_1__c+' ';
                    }
                    if(contact.Address_2__c){
                        allAddress = allAddress +contact.Address_2__c+' ';
                    }
                    if(contact.Address_3__c){
                        allAddress = allAddress +contact.Address_3__c;
                    }
                    
                    console.log('allAddress '+allAddress);
                    console.log('contact.Address_3__c '+contact.Address_3__c);
                    
                    //result = self.splitAddressResidence(component,event,allAddress);
                    result = self.splitAddress(component,event,allAddress);
                    if(!$A.util.isEmpty(result))
                    {
                        if(result[0])
                            contact.Address_1__c = result[0];
                        else
                            contact.Address_1__c ='';
                        if(result[1])
                            contact.Address_2__c =result[1];
                        else
                            contact.Address_2__c='';
                        if(result[2])
                            contact.Address_3__c =result[2];
                        else
                            contact.Address_3__c= contact.Residence_City__c;
                    }                    
                    //11371e          
                    
                    component.set("v.contact",contact);
                    component.set("v.Ckyccontact",contact); 
                }
                if(response.accObj){
                    component.set("v.account",response.accObj);
                    var accMod = component.get("v.account");
                    var ckycIdentity = JSON.parse(component.get("v.ckycResp")["CKYCIDDetails"]);
                    if(ckycIdentity){
                        for(var j=0;j<ckycIdentity.length;j++){
                            
                            if(ckycIdentity[j]["CKYCIDType"] && ckycIdentity[j]["CKYCIDType"] == "C"){
                                accMod.PANNumber__c = ckycIdentity[j]["CKYCIDNumber"];
                            }
                        }
                        
                    }
                    var gender = component.get("v.ckycResp")["CKYCGender"];
                    if(gender){
                        if(gender == "M"){
                            accMod.Gender__c = "Male";
                        }
                        else if(gender == "F"){
                            accMod.Gender__c = "Female";
                        }
                        
                    }
                    component.set("v.account",accMod);
                    console.log('robin ckyc '+ckycIdentity);
                    //var acc = JSON.parse(JSON.stringify(component.get("v.account")));
                    var acc = Object.assign({}, component.get("v.account"));//deep cloning of objects to retain Ckycaccount out of this component
                    component.set("v.Ckycaccount",acc);
                }
                if(response.applicantPrimary){
                    component.set("v.applicant",response.applicantPrimary);
                    component.set("v.Ckycapplicant",response.applicantPrimary);
                    
                }
                var pancmp = component.find("pancheck");
                pancmp.setCKYCfields(JSON.stringify(component.get("v.applicant")));//23578
            }
            
            
        });  
        }catch(e){console.error('searchdata Error '+e);}//US11371
    },
    toggleTabUtil :  function(component,event,targetId){
        console.log(targetId);
        if( targetId=="subicon4"){
            var x = document.getElementById(targetId).innerHTML;
            console.log(x);
            if(x =="[-]"){
                document.getElementById(targetId).innerHTML = "[+]";
                $A.util.addClass(component.find('subsection4Content'), 'slds-hide');
                $A.util.removeClass(component.find('subsection4Content'), 'slds-show');
            }
            else{
                $A.util.addClass(component.find('subsection4Content'), 'slds-show');
                $A.util.removeClass(component.find('subsection4Content'), 'slds-hide');
                document.getElementById(targetId).innerHTML = "[-]"; 
            }
            
        }
        
    },
    //23578 stop
    callPANBre : function(component) {
        this.showhidespinner(component,event,true);
        var app = JSON.stringify(component.get("v.applicant"));
        console.log('account is'+component.get("v.account").PAN_Check_Status__c);
        this.executeApex(component, "callPANBRE",{"acc":JSON.stringify(component.get("v.account")),
                                                  "con":JSON.stringify(component.get("v.contact")),
                                                  "loanobj":JSON.stringify(component.get("v.loan")),
                                                  "appObj1":JSON.stringify(component.get("v.applicant"))
                                                 },
                         function(error, result){
                             
                             // var result = response.getReturnValue();
                             console.log('result -->'+result);
                             
                             var objlst = JSON.parse(result);
                             console.log('objlistr -->'+JSON.stringify(objlst));
                             if(!$A.util.isEmpty(objlst))
                             {
                                 console.log(objlst.status);
                                 if(objlst.status == 'Success'){
                                     if(!$A.util.isEmpty(objlst.applicantPrimary))
                                     {
                                         component.set("v.applicant" , objlst.applicantPrimary);
                                     }
                                     if(!$A.util.isEmpty(objlst.cibilExt1))
                                     {
                                         component.set("v.cibilExt1", objlst.cibilExt1);   
                                     }
                                     if(!$A.util.isEmpty(objlst.cibilExt))
                                     {
                                         component.set("v.cibilExt", objlst.cibilExt1);   
                                     }
                                     if(!$A.util.isEmpty(objlst.cibilobj))
                                     {
                                         component.set("v.cibilobj", objlst.cibilobj);   
                                     }
                                     this.showhidespinner(component,event,false);
                                     this.displayToastMessage(component,event,'Success','Called BRE Successfully','success'); 
                                     
                                 }
                                 else{
                                     this.showhidespinner(component,event,false);
                                     console.log();
                                     this.displayToastMessage(component,event,'Failure',objlst.status,'failure'); 
                                     
                                 }
                                 
                             }
                             else{
                                 this.showhidespinner(component,event,false);
                                 this.displayToastMessage(component,event,'Failure','Error while calling BRE','failure'); 
                                 
                             }
                             
                         }
                         
                         
                        );  
    },
	 //23578 start
    sendSmsForCkyc : function(component, event){
        
        var params = new Object();
        params["event"] = 'A_CKYC_SMS';
        console.log(component.get("v.ckycResp")["mobNo"]);
        params["mobNo"] = component.get("v.ckycResp")["mobNo"];
        params["smsName"] = 'A_CKYC_SMS';
        params["receiver"]=  'Customer';
        params["RecId"] = component.get("v.oppId");
        this.executeApex(component, "sendCkycSms",{"data":params},function(error, result){
            if(result){
                var response = JSON.parse(result);
                console.log(response);
                component.set("v.ckycsmsLst",response);
            }
            
        });
        
    },
    splitAddress: function (component,event,totalAddress) {      
        var result = [];
        if (totalAddress) {
            var line = [];
            var length = 0;
            totalAddress.split(" ").forEach(function(word) {
                if ((length + word.length) >= 35) {
                    result.push(line.join(" "));
                    line = []; length = 0;
                }
                length += word.length + 1;
                console.log('word'+word);
                line.push(word);
                console.log('line'+line);
            });
            if (line.length > 0) {
                result.push(line.join(" "));
                console.log('final result'+result);
            }
        }
        return result;
    },
    //23578 stop
})