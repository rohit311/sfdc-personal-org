({
    getAppData : function(component,event) {
        var conSelectList = ["ApplicantType__c","Residence_Type__c","Relationship_Borrower__c","Marital_Status__c","Sex__c"];
        var appSelectList = ["Proof_of_Address_Submitted_for_Permanent__c","Proof_of_Registered_Address_Submitted__c","Proof_of_Residence_Address_Submitted__c"];
        var selectListNameMap = {};
        selectListNameMap["Contact"] = conSelectList;
        selectListNameMap["Applicant__c"] = appSelectList;
        console.log('component.get("v.appId")'+component.get("v.oppId"));
        this.executeApex(component, "getCoApplicants", {'appId' : component.get("v.appId"),'loanId' : component.get("v.oppId"),'objectFieldJSON':JSON.stringify(selectListNameMap)}, function(error, result){
            if (!error && result && result.length) {
                var data = JSON.parse(result);
                //component.set("v.conNew", data.objCon);
                console.log('data.accObj'+data.accObj+data.opp)
                component.set("v.accObj", data.accObj);
                component.set("v.oppObj", data.opp);
                /*component.set("v.appNew", data.currApp); 
                console.log('data.currApp'+data.currApp);*/
                
                var currApp = component.get("v.appNew");
                var currCon = component.get("v.conNew");
                if(!$A.util.isEmpty(currApp.Id)){
                    component.set("v.showCkyc",true);
                }
                //23578 start
                if(component.get("v.appNew") && component.get("v.appNew").Data_Source__c && (component.get("v.appNew").Data_Source__c == 'Copy CKYC Data' || component.get("v.appNew").Data_Source__c == 'Edit CKYC Data')){
                    component.set("v.isCkycReadOnly",true);
                    component.set("v.dataSource",component.get("v.appNew").Data_Source__c);
                    document.getElementById("otherSection").style.display = 'block';
                    component.find("skipckyc").set("v.disabled",true);
                    console.log('here isCkycReadOnly');
                }
                //23578 stop
                /*City CR s*/
                if(!$A.util.isEmpty(component.get('v.conNew.Residence_City__c'))){
                    component.set("v.validresicity",true);
                    component.set("v.resicitySearchKeyword", component.get('v.conNew.Residence_City__c'));
                }
                if(!$A.util.isEmpty(component.get('v.conNew.Office_City__c'))){
                    component.set("v.validofccity",true);
                    component.set("v.ofccitySearchKeyword", component.get('v.conNew.Office_City__c'));
                }
                if(!$A.util.isEmpty(component.get('v.conNew.Permanant_City__c'))){
                    component.set("v.validpercity",true);
                    component.set("v.percitySearchKeyword", component.get('v.conNew.Permanant_City__c'));
                }
                /*City CR e*/
                console.log('in check'+currCon.Residence_Type__c);
                if(!$A.util.isEmpty(currCon) && !$A.util.isEmpty(currCon.Residence_Type__c) && currCon.Residence_Type__c!='Owned by Self/Spouse' && currCon.Residence_Type__c!='Owned by Parent/Sibling'){
                    component.set("v.isRented",true);
                }
                if (!$A.util.isEmpty(component.get("v.accObj")) && !$A.util.isEmpty(component.get("v.accObj.Employer__r"))) {
                    if(component.get("v.accObj.Employer__r.Name").toLowerCase() == 'others' || component.get("v.accObj.Employer__r.Name").toLowerCase() == 'other' || component.get("v.accObj.Employer__r.Name").toLowerCase() == 'company not listed'){                    
                        component.set("v.isOther",true);
                    } 
                    else{
                        component.set("v.isOther",false);
                    }
                }
                var picklistFields = data.picklistData;
                var conPickFlds = picklistFields["Contact"];
                component.set("v.coAppTypeList", conPickFlds["ApplicantType__c"]);
                component.set("v.relationList", conPickFlds["Relationship_Borrower__c"]);
                component.set("v.marStatusList", conPickFlds["Marital_Status__c"]);
                component.set("v.genderList", conPickFlds["Sex__c"]);
                component.set("v.residenceTypeList", conPickFlds["Residence_Type__c"]);
                var appPickFlds = picklistFields["Applicant__c"];
                component.set("v.perProofList", appPickFlds["Proof_of_Address_Submitted_for_Permanent__c"]);
                component.set("v.resProofList", appPickFlds["Proof_of_Residence_Address_Submitted__c"]);
                component.set("v.regProofList", appPickFlds["Proof_of_Registered_Address_Submitted__c"]);
                /*Commented code for Bug 18914 start*/
                /*var resiAdd = '';
                if(!$A.util.isEmpty(currCon.Address_1__c)){
                    resiAdd += currCon.Address_1__c;
                }
                if(!$A.util.isEmpty(currCon.Address_2__c)){
                    resiAdd += currCon.Address_2__c;
                }
                if(!$A.util.isEmpty(currCon.Address_3__c)){
                    resiAdd += currCon.Address_3__c;
                }
                component.find("resAdd").set("v.value", resiAdd);*/
                /*Commented code for Bug 18914 End*/
                console.log('is rented'+component.get("v.isRented"));
                /*if(component.get("v.isRented")){
                	var perAdd = '';
                    if(!$A.util.isEmpty(currCon.Permanant_Address_Line_1__c)){
                        perAdd += currCon.Permanant_Address_Line_1__c;
                    }
                    if(!$A.util.isEmpty(currCon.Permanant_Address_Line_2__c)){
                        perAdd += currCon.Permanant_Address_Line_2__c;
                    }
                    if(!$A.util.isEmpty(currCon.Permanant_Address_Line_3__c)){
                        perAdd += currCon.Permanant_Address_Line_3__c;
                    }
                    component.find("perResAdd").set("v.value", perAdd);
                    
                }*/
                
                /*var offAdd = '';
                if(!$A.util.isEmpty(currCon.Address_Line_One__c)){
                    offAdd += currCon.Address_Line_One__c;
                }
                if(!$A.util.isEmpty(currCon.Address_2nd_Line__c)){
                    offAdd += currCon.Address_2nd_Line__c;
                }
                if(!$A.util.isEmpty(currCon.Address_3rd_Line__c)){
                    offAdd += currCon.Address_3rd_Line__c;
                }
                component.find("offAdd").set("v.value", offAdd);*/
                if(!$A.util.isEmpty(currCon.Employer__c)){
                    console.log('data.objCon.Company_Category__r.Name'+currCon.Employer__r.Name);
                    component.set("v.EmployerSearchKeyword", currCon.Employer__r.Name);
                }
                
                this.showhidespinner(component,event,false);
            }
            else{
                this.showhidespinner(component,event,false);
            }
        });
    },
    toggleAccordion : function(component,event) {
        
        var targetId= event.target.getAttribute('id'); 
        console.log('TargetId : '+ targetId);
        if(targetId=="name1" || targetId=="icon1" || targetId=="section1"){
            this.showHideSection(component,"icon1","section1Content");
        }else if(targetId=="name2" || targetId=="icon2" || targetId=="section2"){
            this.showHideSection(component,"icon2","section2Content");
        }else if(targetId=="name3" || targetId=="icon3" || targetId=="section3"){
            this.showHideSection(component,"icon3","section3Content");
        }else if(targetId=="name4" || targetId=="icon4" || targetId=="section4"){
            this.showHideSection(component,"icon4","section4Content");
        }else if(targetId=="name3" || targetId=="icon5" || targetId=="section5"){
            this.showHideSection(component,"icon5","section5Content");
        }else if(targetId=="subname1" || targetId=="subicon1" || targetId=="subsection1"){
            this.showHideSubSection(component,"subicon1","subsection1Content")
        }
            else if(targetId=="subname2" || targetId=="subicon2" || targetId=="subsection2"){
                this.showHideSubSection(component,"subicon2","subsection2Content")
            }
                else if(targetId=="subname3" || targetId=="subicon3" || targetId=="subsection3"){
                    this.showHideSubSection(component,"subicon3","subsection3Content")
                } //23578 start
                    else if(targetId=="subname5" || targetId=="subicon5" || targetId=="subsection5"){
                        this.showHideSubSection(component,"subicon5","subsection5Content")
                    }
        //23578 stop
    },
    showHideSection: function(component,iconId,sectionId){
        var i;
        var length = 4;
        
        for(i=1 ; i<length ; i++){ 
            var icon = 'icon'+i;
            var section = 'section'+i+'Content';
            console.log('icon : '+ iconId);
            if(icon == iconId)
            {
                var x = document.getElementById(icon).innerHTML;
                if(x =="[-]")
                    document.getElementById(icon).innerHTML = "[+]"; 
                else
                    document.getElementById(icon).innerHTML = "[-]";    	
            }else
            {
                document.getElementById(icon).innerHTML = "[+]";
            }
            
            if(section == sectionId)
                $A.util.toggleClass(component.find(section), 'slds-hide'); 
            else
                $A.util.addClass(component.find(section), 'slds-hide'); 
        }
    },
    showHideSubSection: function(component,iconId,sectionId){
        var i;
        for(i=1 ; i<6 ; i++){ //23578 changed to 6
            var icon = 'subicon'+i;
            var section = 'subsection'+i+'Content';
            console.log('icon : '+ icon);
            if(icon == iconId && document.getElementById(icon))//added && for bug id 22047
            {
                var x = document.getElementById(icon).innerHTML;
                if(x =="[-]")
                    document.getElementById(icon).innerHTML = "[+]"; 
                else
                    document.getElementById(icon).innerHTML = "[-]";    	
            }else
            {
                if( document.getElementById(icon))//added if for bug id 22047
                    document.getElementById(icon).innerHTML = "[+]";
            }
            
            if(section == sectionId)
                $A.util.toggleClass(component.find(section), 'slds-hide'); 
            else
                $A.util.addClass(component.find(section), 'slds-hide'); 
        }
    },
    
    startSearch: function (component, key) {
        var keyword = component.get("v." + key + "SearchKeyword");
        console.log("keyword" + keyword+"key"+key);
        if(key == 'Employer')
        {
            if (keyword.length > 2 && !component.get('v.empsearching')) {
                console.log("keyword empsearching" + keyword+"key"+key);
                component.set('v.empsearching', true);
                component.set('v.oldSearchKeyword', keyword);
                this.searchHelper(component, key, keyword);
            }
            else if (keyword.length <= 2) {
                console.log("keyword" + keyword+"key"+key);
                component.set("v." + key + "List", null);
                this.openCloseSearchResults(component, key, false);
            }
        }
    },
    toCamelCase: function (str) {
        return str[0].toUpperCase() + str.substring(1);
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
        if(key == 'Employer')
        {
            component.set('v.empsearching', false);
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
    },
    validateAppData: function(component,dataToVal){
        var validData = true;
        
        for(var i=0;i<dataToVal.length;i++){
            var fieldName = component.find(dataToVal[i]);
            if($A.util.isEmpty(fieldName) || !fieldName.get("v.validity").valid){
                fieldName.showHelpMessageIfInvalid();
                validData = false;
            } 
        }
        return validData;
        
    },
    saveCoApp: function(component, event,partial){
        try{
            console.log("ekyc obj"+component.get("v.kyc"));
            var self = this;//24668    
            var conObj = component.get("v.conNew");
            var validData = true;
            var dataToVal = ['fname','lname','coAppType','mobileNo','panNo','dob','gender','marStatus','resAdd','resAdd2','resAdd3','currPin','perEmail','offEmail','perProof','resi_type'];//resAdd2 and resAdd3 added for Bug 18914 
            if(!partial){
                dataToVal.push('desig','offAdd','offAdd2','offAdd3','offPin','offTele');
                if(component.get("v.isRented")){
                    dataToVal.push('perResAdd','perResAdd2','perResAdd3','perPin','perTele');
                }
            }
            conObj.CKYCDocumentType__c = component.get("v.CKYCDocumentType"); //US11371
            if(conObj.ApplicantType__c == 'Primary'){
                dataToVal.push('regProof');
            }
            else{
                dataToVal.push('resProof');
            }
            /*City CR s*/
            if(!component.get("v.validresicity")){
                this.showhidespinner(component,event,false);
                this.displayToastMessage(component,event,'Error','Please enter valid Current City','error');  
            }
            else if(!component.get("v.validofccity") && !partial){
                this.showhidespinner(component,event,false);
                this.displayToastMessage(component,event,'Error','Please enter valid Office City','error');  
            }
                else if(!partial && !component.get("v.validpercity") && !$A.util.isEmpty(component.get("v.conNew.Residence_Type__c")) && component.get("v.conNew.Residence_Type__c") != 'Owned by Self/Spouse' && 
                        component.get("v.conNew.Residence_Type__c") != 'Owned by Parent/Sibling'){
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error','Please enter valid Permanent City','error');  
                }
                    else{
                        /*City CR e*/
                        validData = this.validateAppData(component,dataToVal);
                        if($A.util.isEmpty(component.find("employer").get("v.value")))
                        {
                            validData = false;
                            component.find("employer").set("v.errors", [{
                                message: "Please Enter Value"
                            }
                                                                       ]);
                        }
                        if(component.get("v.isOther"))
                        {
                            if (component.find("othercompany") && !component.find("othercompany").get("v.validity").valid)
                            {
                                validData = false;
                                component.find("othercompany").showHelpMessageIfInvalid();
                            }
                        }
                        console.log('validData'+validData);
                        if(validData){
                            
                            var newAcc = component.get("v.accObj");
                            var appObj = component.get("v.appNew");
                            var oppObj = component.get("v.oppObj");
                            var result =[];
                            
                            /*result = this.splitAddress(component,event,"resAdd");
            if(!$A.util.isEmpty(result))
            {
                if(result[0])
                    conObj.Address_1__c = result[0];
                else
                    conObj.Address_1__c ='';
                if(result[1])
                    conObj.Address_2__c =result[1];
                else
                    conObj.Address_2__c='';
                if(result[2])
                    conObj.Address_3__c =result[2];
                else
                    conObj.Address_3__c='';
            }*/
                        if(conObj.Residence_Type__c != 'Owned by Self/Spouse' && conObj.Residence_Type__c != 'Owned by Parent/Sibling')
                        {
                            /*result = this.splitAddress(component,event,"perResAdd");
                if(!$A.util.isEmpty(result))
                {
                    if(result[0])
                        conObj.Permanant_Address_Line_1__c = result[0];
                    else
                        conObj.Permanant_Address_Line_1__c ='';
                    if(result[1])
                        conObj.Permanant_Address_Line_2__c =result[1];
                    else
                        conObj.Permanant_Address_Line_2__c='';
                    if(result[2])
                        conObj.Permanant_Address_Line_3__c =result[2];
                    else
                        conObj.Permanant_Address_Line_3__c='';
                }*/
                }
                        else{
                            conObj.Permanent_Pin_Code__c = newAcc.PinCode__c;
                            conObj.Permanant_Address_Line_1__c='';
                            conObj.Permanant_Address_Line_2__c='';
                            conObj.Permanant_Address_Line_3__c='';
                            component.set("v.perResAdd",'');
                        }
                        
                        
                        /*result = this.splitAddress(component,event,"offAdd");
            if(!$A.util.isEmpty(result))
            {
                if(result[0])
                    conObj.Address_Line_One__c = result[0];
                else
                    conObj.Address_Line_One__c ='';
                if(result[1])
                    conObj.Address_2nd_Line__c =result[1];
                else
                    conObj.Address_2nd_Line__c='';
                if(result[2])
                    conObj.Permanant_Address_Line_3__c =result[2];
                else
                    conObj.Address_3rd_Line__c='';
            }*/
                        conObj.Customer_Type__c = 'Individual';
                        appObj.Applicant_Type__c = conObj.ApplicantType__c;
                        appObj.Customer_Name__c = conObj.FirstName+conObj.LastName;
                        appObj.Loan_Application__c = component.get("v.oppId");
                        appObj.Type_of_Borrower__c = conObj.Type_of_Borrower__c;
                        appObj.Company_Name__c = conObj.Name_of_Employer__c;
                        appObj.Company_Type__c = conObj.Company_Type__c;
                        if(conObj.Sex__c == 'M'){
                            conObj.Gender__c = 'Male';
                        }
                        if(conObj.Sex__c == 'F'){
                            conObj.Gender__c = 'Female';
                        }
                        console.log('conObj.FirstName'+newAcc);
                        if(conObj.ApplicantType__c == 'Primary'){
                            console.log('inside');
                            newAcc.First_Name__c = conObj.FirstName;
                            newAcc.Last_Name__c = conObj.LastName;
                            newAcc.Date_of_Birth__c = conObj.Date_of_Birth__c ;
                            newAcc.Mobile__c= conObj.Mobile__c;
                            newAcc.PANNumber__c = conObj.PAN_Number__c;
                            newAcc.Gender__c = conObj.Gender__c;
                            newAcc.Office_Pin_Code__c = conObj.Office_Pin_Code__c;
                            newAcc.DesignationOTP__c = conObj.DesignationOTP__c;
                            newAcc.Office_Address_1st_Line__c = conObj.Address_Line_One__c;
                            newAcc.Office_Address_2nd_Line__c = conObj.Address_2nd_Line__c;
                            newAcc.Office_Address_3rd_Line__c = conObj.Address_3rd_Line__c;
                            newAcc.Office_Landline_Number1__c = conObj.Office_Landline_Number1__c;
                            newAcc.Current_PinCode__c = conObj.Pin_Code__c;
                            newAcc.Permanent_Residence_Address1__c = conObj.Permanant_Address_Line_1__c;
                            newAcc.Permanent_Residence_Address2__c = conObj.Permanant_Address_Line_2__c;
                            newAcc.Permanent_Residence_Address3__c = conObj.Permanant_Address_Line_3__c;
                            newAcc.Permanent_PinCode__c = conObj.Permanent_Pin_Code__c;
                            newAcc.Permanent_Telephone_Number__c = conObj.Permenant_Phone__c;
                            newAcc.Current_Residence_Address1__c = conObj.Address_1__c;
                            newAcc.Current_Residence_Address2__c = conObj.Address_2__c;
                            newAcc.Current_Residence_Address3__c = conObj.Address_3__c;
                            newAcc.Employer__c = conObj.Employer__c;
                            newAcc.Type_Of_Industry__c = conObj.Company_Category__c;
                            newAcc.Email_Id__c = conObj.Email;
                            newAcc.Accountant_email_id__c = conObj.Office_Email_Id__c;
                            newAcc.Current_Email_Id__c = conObj.Email;
                            newAcc.Marital_Status__c = conObj.Marital_status__c;
                            newAcc.Name = newAcc.First_Name__c+' '+newAcc.Last_Name__c;
                            oppObj.Name = newAcc.First_Name__c+' '+newAcc.Last_Name__c;
                        }
                        var ekycObj = component.get("v.kyc");
                        if(!$A.util.isEmpty(ekycObj)){
                            appObj.eKYC_Processing__c = true;
                        }
                        
                        //23578 rohit start
                        if(component.get('v.ckycResp')){
                            var ckycResp = Object.assign({}, component.get('v.ckycResp'));
                            //attach all docs from CKYC start 23578
                            if(ckycResp["CKYCImageDetails"]){
                                var imageLst = JSON.parse(ckycResp["CKYCImageDetails"]);
                                var attachments = [];
                                for(var i =0; i<imageLst.length;i++){                                     
                                    attachments.push({"Name":"CKYC Doc "+imageLst[i].CKYCImageType,"image":imageLst[i].CKYCImageData,"extension":imageLst[i].CKYCImageExtension});
                                }
                            }
                            //attach all docs from CKYC stop 23578
                            var SolPlcLst =  component.get("v.solPolicyFrCoApp");
                            if(!SolPlcLst){
                                SolPlcLst = new Array();
                            }
                            
                            var ckycSolPly = new Object();
                            
                            ckycSolPly.Name = 'Ckyc response';
                            delete ckycResp["CKYCImageDetails"];
                            ckycSolPly.Old_Loan_Application__c = JSON.stringify(ckycResp);
                            ckycSolPly.Policy_Name__c = 'Ckyc response';
                            if(component.get("v.appId")){
                                ckycSolPly.Applicant_Name__c = component.get("v.appId");                    
                            }
                            if(ckycResp)
                            {
                               SolPlcLst.push(ckycSolPly); 
                            }
                            component.set("v.solPolicyFrCoApp",SolPlcLst);
                            
                        }
                        
                        
                        //23578 rohit stop
                        console.log('oppObj'+oppObj+'accObj'+newAcc);
                        
                        this.executeApex(component, "updateApplicantsData", {
                            'oppObj':JSON.stringify(oppObj),'accObj': JSON.stringify(newAcc),'conObj':JSON.stringify(conObj),'appObj':JSON.stringify(appObj),'ekycObj':JSON.stringify(ekycObj),"ckycSMS":JSON.stringify(component.get("v.ckycsmsLst")),"SolPlcLst":JSON.stringify(component.get("v.solPolicyFrCoApp")),"tatMaster":JSON.stringify(component.get("v.tatMasterFrCoApp")),"attachments":JSON.stringify(attachments)
                        }, function (error, result) {
                            console.log('result : ' + result); 
                            if (!error && result) {
                                var data = JSON.parse(result);
                                if(data.status == "City Fail"){
                                    this.showhidespinner(component,event,false); 
                                    this.displayToastMessage(component,event,'Error','Unable to save details. City/State mapping not available for pincode.','error');
                                }
                                else{
                                    component.set("v.isappSaved", true);//24668
                                    component.set("v.conNew", data.objCon);
                                    component.set("v.accObj", data.accObj);
                                    component.set("v.oppObj", data.opp);
                                    component.set("v.appNew", data.currApp);
                                    component.set("v.showCkyc",true);
                                    //24668 start
                                    console.log('before bre '+partial+'---'+component.get("v.appNew").Applicant_Type__c);
                                    if(partial === false && component.get("v.appNew").Applicant_Type__c == 'Financial Co-Applicant'){    
                                        console.log('in bre');
                                        self.callPANBre(component);   
                                    }
                                    //24668 stop
                                    //23578 start
                                    if(component.get("v.appNew") && component.get("v.appNew").Data_Source__c && (component.get("v.appNew").Data_Source__c == 'Copy CKYC Data' || component.get("v.appNew").Data_Source__c == 'Edit CKYC Data')){
                                        component.set("v.isCkycReadOnly",true);
                                        console.log('here isCkycReadOnly');
                                    }
                                    //23578 stop
                                    var showhideevent =  $A.get("e.c:UpdateNewApplicant");
                                    showhideevent.setParams({
                                        "appObj": component.get("v.appNew"),
                                        "conObj": component.get("v.conNew"),
                                        "accObj": component.get("v.accObj"),
                                    });
                                    showhideevent.fire();
                                    this.showhidespinner(component,event,false);
                                    this.displayToastMessage(component,event,'Success','Applicant details saved successfully','success');
                                }
                            }
                            else{
                                this.showhidespinner(component,event,false);
                                this.displayToastMessage(component,event,'Error','Error in saving record','error');
                            }
                        });
                    }
                    else{
                        this.showhidespinner(component,event,false);
                        this.displayToastMessage(component,event,'Error','Please fill all required data','error');
                    }
                }}catch(e){console.error('searchdata Error '+e);}//US11371
    },
    executeApex: function(component, method, params,callback){
        console.log('params'+JSON.stringify(params));
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log('response.getReturnValue()123'+response.getReturnValue());
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
    
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
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
    splitAddress: function (component,event,key) {
        var totalAddress = component.find(key).get("v.value");
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
    PANCheckhelper : function(component,event,recAppId){
        var pan=component.find("panNo").get("v.value");
        var product=component.get("v.Product");
        var con=component.get("v.conNew");
        console.log(con);
        var app=component.get("v.appNew");
        
        
        this.executeApex(component, "PANCheckCoApp1", 
                         {'panNumber':pan, 'product': product,'strApp':JSON.stringify(component.get("v.appNew")),'strcon':JSON.stringify(component.get("v.conNew")),"isDual":false}, 
                          function(error, result){
                             console.log('result'+result);
                             this.displayToastMessage(component,event,'Success','PAN Check Initiated Successfully','success');
                             if (!error && result && (!result.includes('exception'))) {
                                 
                                 
                                 //var data = JSON.parse(result);
                                 this.showhidespinner(component,event,false);
                                 //23578 start
                                 if(result != ''){
                                     var data = JSON.parse(result);
                                      
                                     component.set("v.disablePan",false);
                                     if(component.get("v.isCkycDone") == false){                                                                    
                                         // component.set("v.conNew",data.objConFin);
                                        
                                         	component.set("v.conNew",data.objConFin);
                                        
                                     }
                                     console.log('tatMasterFrCoApp ',data.tatMasterRecordFrCoApp);//27433
                                     component.set("v.solPolicyFrCoApp",data.solPolicyFrCoApp); //27433
                                     component.set("v.tatMasterFrCoApp",data.tatMasterRecordFrCoApp); //27433
                                     component.set("v.panFname",(component.get("v.conNew.FirstName"))); //27433
                                     component.set("v.panLname",(component.get("v.conNew.LastName"))); //27433
                                     //23578 stop 
                                     //this.showhidespinner(component,event,false);
                                 }
                                 else{
                                     //this.displayToastMessage(component,event,'Info','Invalid PAN','info');
                                 }
                                 
                             }              this.showhidespinner(component,event,false);
                             
                         });
        
        
    },
    //added for bug id 21851 start
    getHideAadhaarSectionHelper:function(component)
    {
        var action = component.get("c.getHideAadhaarSection");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('hide aadhaaar>>>'+response.getReturnValue());
                component.set('v.hideAadhaarSection',response.getReturnValue());   
            }         
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action); 
    },//added for bug id 21851 stop
    //23578 start
    setCkycFields :function(component,event) {
        var respMap =  event.getParam("infObj");
        this.showhidespinner(component,event,true);
        var months = {"January":"01", "February":"02", "March":"03", "April":"04", "May":"05", "June":"06", "July":"07", "August":"08", "September":"09", "October":"10", "November":"11", "December":"12"};                
        console.log('dob '+respMap["CKYCDOB"]);
        /*if(respMap["CKYCDOB"]){
            	var dobStr = respMap["CKYCDOB"].split("-");
                var modifedDob = dobStr[2]+'-'+months[dobStr[1]]+'-'+dobStr[0];
                respMap["CKYCDOB"] = modifedDob;
        	}*/
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
        
        var app = JSON.stringify(component.get("v.appNew"));
        var con = JSON.stringify(component.get("v.conNew"));
        component.find("coAppType").set("v.disabled",false);
        respMap["Applicant__c"] = app;
        respMap["Contact"] = con;
        var self = this;
        
        this.executeApex(component,"fetchCkycdata",{"data":JSON.stringify(respMap)},function(error, result){
            var response = JSON.parse(result);
            console.log(response);
            self.showhidespinner(component,event,false);
            component.set("v.isCkycinitiated",true);
            document.getElementById("otherSection").style.display = 'block';
            self.showHideSubSection(component,"subicon5","subsection5Content");
            self.showHideSubSection(component,"subicon2","subsection2Content");
            component.find("skipckyc").set("v.disabled",true);
            if(response && response.status == 'success'){
                console.log('data source '+component.get("v.dataSource"));
                component.set("v.dataSource","Copy CKYC Data");
                self.changeCKYCfields(component,false);
                component.set("v.isCkycDone",true);
                self.sendSmsForCkyc(component,event);
                if(response.objCon){
                    component.set("v.conNew",response.objCon);  
                    var conMod = component.get("v.conNew");
                    var allAddress = '';
                    
                    if(conMod.Permanant_Address_Line_1__c){
                        allAddress = allAddress +conMod.Permanant_Address_Line_1__c+' ';
                    }
                    if(conMod.Permanant_Address_Line_2__c){
                        allAddress = allAddress +conMod.Permanant_Address_Line_2__c+' ';
                    }
                    if(conMod.Permanant_Address_Line_3__c){
                        allAddress = allAddress +conMod.Permanant_Address_Line_3__c;
                    }
                    var result = self.splitAddress(component,event,allAddress);
                    if(!$A.util.isEmpty(result))
                    {
                        if(result[0])
                            conMod.Permanant_Address_Line_1__c = result[0];
                        else
                            conMod.Permanant_Address_Line_1__c ='';
                        if(result[1])
                            conMod.Permanant_Address_Line_2__c =result[1];
                        else
                            conMod.Permanant_Address_Line_2__c='';
                        if(result[2])
                            conMod.Permanant_Address_Line_3__c =result[2];
                        else
                            conMod.Permanant_Address_Line_3__c=conMod.Permanant_City__c;
                        
                        
                    }
                    var conGender = component.get("v.ckycResp")["CKYCGender"];
                    if(conGender){
                        if(conGender == "M"){
                            conMod.Sex__c = "Male";
                        }
                        else if(conGender == "F"){
                            conMod.Sex__c = "Female";
                        }
                        
                    }
                    
                    //11371s
                    allAddress='';
                    if(conMod.Address_1__c){
                        allAddress = allAddress +conMod.Address_1__c+' ';
                    }
                    if(conMod.Address_2__c){
                        allAddress = allAddress +conMod.Address_2__c+' ';
                    }
                    if(conMod.Address_3__c){
                        allAddress = allAddress +conMod.Address_3__c;
                    }
                    
                    result = self.splitAddress(component,event,allAddress);
                    if(!$A.util.isEmpty(result))
                    {
                        if(result[0])
                            conMod.Address_1__c = result[0];
                        else
                            conMod.Address_1__c ='';
                        if(result[1])
                            conMod.Address_2__c =result[1];
                        else
                            conMod.Address_2__c='';
                        if(result[2])
                            conMod.Address_3__c =result[2];
                        else
                            conMod.Address_3__c='';
                    }                    
                    //11371e                    
                    
                    var ckycIdentity = JSON.parse(component.get("v.ckycResp")["CKYCIDDetails"]);
                    if(ckycIdentity){
                        for(var j=0;j<ckycIdentity.length;j++){
                            
                            if(ckycIdentity[j]["CKYCIDType"] && ckycIdentity[j]["CKYCIDType"] == "C"){
                                conMod.PAN_Number__c = ckycIdentity[j]["CKYCIDNumber"];
                            }
                        }
                        component.set("v.conNew",conMod);
                    }
                    console.log('robin ckyc '+ckycIdentity);
                    var contact = Object.assign({}, component.get("v.conNew"));//deep cloning of objects to retain Ckycaccount
                    component.set("v.Ckyccontact",contact); 
                }              
                if(response.applicantPrimary){
                    component.set("v.appNew",response.applicantPrimary);
                    component.set("v.Ckycapplicant",response.applicantPrimary);
                    
                }
                
                
                self.changeCKYCfields(component,false);
            }
            
            
        });  
    },
    changeCKYCfields : function(component,isEditable){
        console.log('in change '+isEditable);
        component.find("fname").set("v.disabled", !isEditable); 
        component.find("lname").set("v.disabled", !isEditable); 
        component.find("mobileNo").set("v.disabled", !isEditable);  
        component.find("panNo").set("v.disabled", !isEditable);
        component.find("dob").set("v.disabled", !isEditable);     
        component.find("resAdd").set("v.disabled", !isEditable);	
        component.find("resAdd2").set("v.disabled", !isEditable); 
        component.find("resAdd3").set("v.disabled", !isEditable); 
        component.find("coAppType").set("v.disabled",false);
    },
    sendSmsForCkyc : function(component, event){
        
        var params = new Object();
        params["event"] = 'A_CKYC_SMS';
        console.log(component.get("v.ckycResp")["mobNo"]);
        params["mobNo"] = component.get("v.ckycResp")["mobNo"];
        params["smsName"] = 'A_CKYC_SMS';
        params["receiver"]=  'Customer';
        params["RecId"] = component.get("v.oppObj").Id;
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
    
    //24668 start
    doEPFO : function(component,event){
        this.showhidespinner(component,event,true);
        console.log('params '+component.get("v.account")+' '+component.get("v.loan")+' '+component.get("v.contObj")+ ' '+ component.get("v.appNew"));
        this.executeApex(component, "doEPFOChecks",{
            "accObj": JSON.stringify(component.get("v.accObj")),
            "oppObj": JSON.stringify(component.get("v.oppObj")),
            "cont": JSON.stringify(component.get("v.conNew")),
            "app": JSON.stringify(component.get("v.appNew"))
        },
                         function(error, result){
                             var objlst = JSON.parse(result);
                             console.log('objlistr -->'+JSON.stringify(objlst.objCon));
                             if(!$A.util.isEmpty(objlst))
                             {
                                 if(objlst.status == 'success')
                                 {
                                     component.set("v.appNew",objlst.currApp);
                                     component.set("v.conNew",objlst.objCon);
                                     component.set("v.accObj",objlst.accObj);
                                     this.displayToastMessage(component,event,'Success','EPFO check done Successfully','success'); 
                                     this.showhidespinner(component,event,false);
                                     component.set("v.epfoShow",true);
                                 }
                                 else
                                 {
                                     this.displayToastMessage(component,event,'Error','Error in EPFO check','error'); 
                                     this.showhidespinner(component,event,false);
                                 }
                             }
                         });
    },
    
    officeemailverify : function(component, event) {
        this.executeApex(component, "verifyOtp",{"contObj" : JSON.stringify(component.get("v.conNew")), "applicantObj" :  JSON.stringify(component.get("v.appNew")), "otpValue" : component.get("v.otpValue")} , function (error, result) {
            console.log('result : ' + result);
            if (!error && result) {
                if(result == 'success'){
                    this.displayToastMessage(component,event,'Success','OTP validated successfully','success');
                    var app = component.get("v.appNew");
                    app.Office_Email_Id_Verified__c = true;
                    component.set("v.appNew",app);
                }
                else{
                    this.displayToastMessage(component,event,'Error','OTP did not match','error');
                }
                
            }
            this.showhidespinner(component,event,false);
            
        });
        
    }, 
    doEmpCheck : function(component, event) {
        this.showhidespinner(component,event,true);
        console.log('con name '+component.get("v.conNew").Name);
        this.executeApex(component, "doEmploymentChecks",{
            "accObj": JSON.stringify(component.get("v.accObj")),
            "oppObj": JSON.stringify(component.get("v.oppObj")),
            "cont": JSON.stringify(component.get("v.conNew")),
            "appId": component.get("v.appNew").Id
        },
                         function(error, result){
                             var objlst = JSON.parse(result);
                             console.log('objlistr -->'+JSON.stringify(objlst.objCon));
                             if(!$A.util.isEmpty(objlst))
                             {
                                 if(objlst.status == 'success')
                                 {
                                     component.set("v.conNew",objlst.objConFin);
                                     component.set("v.appNew",objlst.finAppl);
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
    callPANBre : function(component) {
        this.showhidespinner(component,event,true);
        console.log('appNew '+component.get("v.appNew").EPFO_Result__c);
        var app = JSON.stringify(component.get("v.appNew"));
        console.log('account is'+component.get("v.accObj").PAN_Check_Status__c);
        this.executeApex(component, "callPANBRE",{"acc":JSON.stringify(component.get("v.accObj")),
                                                  "con":JSON.stringify(component.get("v.conNew")),
                                                  "loanobj":JSON.stringify(component.get("v.oppObj")),
                                                  "appObj1":JSON.stringify(component.get("v.appNew"))
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
                                     if(!$A.util.isEmpty(objlst.currapp))
                                     {
                                         component.set("v.appNew" , objlst.currapp);
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
    // 24668 stop
})