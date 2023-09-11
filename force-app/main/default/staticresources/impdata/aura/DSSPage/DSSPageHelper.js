({
    /*
     *	@author 		: 	Persistent Systems
     *   @description	: 	Method To toggle section, Implementation of Accordian
     *   @version		: 	1.0
     */
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
                //this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getDssDetails: function(component, oppId){        
        console.log('getDssDetails start');
        this.showSpinner(component);
        var oppSelectList = ["Product__c","Application_Source__c"];
        var accSelectList = ["Current_experiance_in_Years__c", "Current_experiance_in_Month__c", "Type_Of_Industry__c", "Gender__c","Total_Work_Experience_Months__c", "Total_Work_Experience_Yrs__c"];
        var contSelectList = ["Marital_Status__c", "Residence_Type__c"];
        var selectListNameMap = {};
        selectListNameMap["Account"] = accSelectList;
        selectListNameMap["Opportunity"] = oppSelectList;
        selectListNameMap["Contact"] = contSelectList;
        this.executeApex(component, "getDssDetails", {"oppId": oppId,"objectFieldJSON" : JSON.stringify(selectListNameMap)}, function(error, result){
            console.log('error>>'+error);
            console.log(result);
            if(!error && result){
                var data = JSON.parse(result);
                console.log('data>>'+data);
                var picklistFields = data.picklistData;
                var accPickFlds = picklistFields["Account"];
                var oppPickFields = picklistFields["Opportunity"];
                var conPickFields = picklistFields["Contact"];
                
                component.set("v.typeOfIndustryList", accPickFlds["Type_Of_Industry__c"]);
                // component.set("v.productList", oppPickFields["Product__c"]);
                component.set("v.gender", accPickFlds["Gender__c"]);
                component.set("v.applicationSource", oppPickFields["Application_Source__c"]);
                component.set("v.totalexpMon", accPickFlds["Total_Work_Experience_Months__c"]);
                component.set("v.totalexpYr", accPickFlds["Total_Work_Experience_Yrs__c"]);
                console.log('DSS+Yr+'+JSON.stringify(accPickFlds["Total_Work_Experience_Yrs__c"]));
                component.set("v.currentexpMon", accPickFlds["Current_experiance_in_Month__c"]);
                component.set("v.currentexpYr", accPickFlds["Current_experiance_in_Years__c"]);
                component.set("v.maritalStatusList", conPickFields["Marital_Status__c"]);
                component.set("v.resTypeList", conPickFields["Residence_Type__c"]);
                component.set("v.oppObj", data.opp);
                component.set("v.accObj", data.accPrimary);
                //console.log('referralname'+data.opp.Referral__r.Name);
                if(!$A.util.isEmpty(data.opp.Referral__r) && !$A.util.isEmpty(data.opp.Referral__r.Name))
					component.set("v.oppObj.Referral__r.Name", data.opp.Referral__r.Name);
                //Rohit set savedAccObj 
             
                if(!$A.util.isEmpty(data.accPrimary) && !$A.util.isEmpty(data.accPrimary.Mobile__c))
                {
                    var mobileNo = "tel:"+ data.accPrimary.Mobile__c;
                    component.set("v.mobilenumber",mobileNo);
                }
                if($A.util.isEmpty(oppId) || (!$A.util.isEmpty(data.accPrimary) && !$A.util.isEmpty(data.accPrimary.PANNumber__c))){
                    component.set("v.panFlag", false);
                } else
                {
                    component.set("v.panFlag", true);
                }
                console.log('DSS++'+JSON.stringify(data.contPrimary));
                component.set("v.contObj", data.contPrimary);
                console.log('SET v.contObj ', JSON.stringify([component.get("v.contObj")]));
                var createContact = component.get('v.contObj');
                if(createContact.Residence_Type__c == 'Rented - With friends'
                   || createContact.Residence_Type__c == 'Rented - Staying Alone' 
                   || createContact.Residence_Type__c == 'Rented - With family'
                   || createContact.Residence_Type__c == 'Rented')
                    component.set('v.isMonthAtResiRequired',true);
                else      
                    component.set('v.isMonthAtResiRequired',false);
                
                component.set("v.applicantObj", data.applicantPrimary);
                if(!$A.util.isEmpty(data.theme))
                    component.set('v.theme',data.theme);
                if(component.get('v.theme') == 'Theme4d' && component.get("v.flow") == false){
                    var maindiv = component.find('offer-pg');
                    $A.util.addClass(maindiv,'divWidth'); 
                    
                }
                
                if(component.get('v.theme') == 'Theme3' || component.get('v.theme') == 'Theme2')
                { 
                    var flowVal = this.getUrlParameter(component,'flow');
                    console.log('flowVal>>'+flowVal);
                    if(!$A.util.isEmpty(flowVal) && flowVal =='new'){
                        this.activateTab(component,'ObligationTab',false);
                    } 
                }
                if (!$A.util.isEmpty(data.ekycobj)) {
                    component.set("v.kyc", data.ekycobj);
                    console.log('kyc details' + data.ekycobj.eKYC_Pin_Code__c);
                }
                if (!$A.util.isEmpty(data.camObj)) {
                    component.set("v.camObj", data.camObj);
                }
                var resiAdd = '';
                if(data.accPrimary.Current_Residence_Address1__c != null)
                    resiAdd = resiAdd + data.accPrimary.Current_Residence_Address1__c;
                if(data.accPrimary.Current_Residence_Address2__c != null)
                    resiAdd = resiAdd + ' ' + data.accPrimary.Current_Residence_Address2__c;
                if(data.accPrimary.Current_Residence_Address3__c != null)
                    resiAdd = resiAdd + ' ' + data.accPrimary.Current_Residence_Address3__c;
                component.set("v.resiAddress",resiAdd);
                
                var permanentResiAdd = '';
                if(data.contPrimary.Permanant_Address_Line_1__c != null)
                    permanentResiAdd = permanentResiAdd + data.contPrimary.Permanant_Address_Line_1__c;
                if(data.contPrimary.Permanant_Address_Line_2__c != null)
                    permanentResiAdd = permanentResiAdd + ' ' + data.contPrimary.Permanant_Address_Line_2__c;
                if(data.contPrimary.Permanant_Address_Line_3__c != null)
                    permanentResiAdd = permanentResiAdd + ' ' + data.contPrimary.Permanant_Address_Line_3__c;
                component.set("v.permanentAddress",permanentResiAdd);
                console.log("checkdataPer" + component.get("v.permanentAddress"));
                
                var officeResiAdd = '';
                if(data.contPrimary.Address_Line_One__c != null)
                    officeResiAdd = officeResiAdd + data.contPrimary.Address_Line_One__c;
                if(data.contPrimary.Address_2nd_Line__c != null)
                    officeResiAdd = officeResiAdd + ' ' + data.contPrimary.Address_2nd_Line__c;
                if(data.contPrimary.Address_3rd_Line__c != null)
                    officeResiAdd = officeResiAdd + ' ' + data.contPrimary.Address_3rd_Line__c;
                component.set("v.officeAddress",officeResiAdd);
                console.log("checkdataOff" + component.get("v.officeAddress"));
                
                if (!$A.util.isEmpty(component.get("v.accObj")) && !$A.util.isEmpty(component.get("v.accObj.Employer__r"))) {
                    
                    if(component.get("v.accObj.Employer__r.Name").toLowerCase() == 'others' || component.get("v.accObj.Employer__r.Name").toLowerCase() == 'other' || component.get("v.accObj.Employer__r.Name").toLowerCase() == 'company not listed'){                    
                        component.set("v.isOther",true);
                    } 
                    else{
                        component.set("v.isOther",false);
                    }
                }
                var disableTabevent = $A.get("e.c:disableOppTabs");
                if(component.get("v.oppId") != null)
                {
                    disableTabevent.setParams({
                        "disableTrue" : false
                    }); 
                }
                else
                {
                    disableTabevent.setParams({
                        "disableTrue" : true
                    }); 
                }
                disableTabevent.fire();
                
            }
            this.getDisablecheckbox(component);
            this.hideSpinner(component); 
        });
        console.log('getDssDetails end');
    },
    /*
     *	@author 		: 	Persistent Systems
     *   @description	: 	Method To hide and show sections
     *   @version		: 	1.0
     */
    showHideSection: function(component,iconId,sectionId){
        var i;
        var length = 3;
        if(component.get("v.oppId") != null)
        {
            length = 6;
        }
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
        for(i=1 ; i<3 ; i++){ 
            var icon = 'subicon'+i;
            var section = 'subsection'+i+'Content';
            console.log('icon : '+ icon);
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
    getCompanyCat : function(component,employerId){
        console.log('employerId'+employerId);
        this.executeApex(component, "getCompanyCat", {employerId: employerId}, function(error, result){
            if(!error && result){
                var data = result;
                console.log('data'+data);
                component.set("v.accObj.Type_Of_Industry__c",data);
            }
        });
    },
    
    submitMCPDetails : function (component,  event, helper){
        var employername = component.get("v.accObj.Employer__r.Name");
        var referralname = component.get("v.oppObj.Referral__r.Name");
        var scourcingName = component.get(" v.oppObj.Sourcing_Channel__r.Name");
        
        this.showSpinner(component);
        var accObj = component.get("v.accObj");
        var contObj = component.get("v.contObj");
        var oppObj = component.get("v.oppObj");
        
        console.log('oppObj submitMCPDetails');
        console.log(oppObj);
        var applicantObj = component.get("v.applicantObj");
        if (accObj.First_Name__c != null) {
            accObj.Name = accObj.First_Name__c;
            if (accObj.Middle_Name__c != null)
                accObj.Name = accObj.Name + ' ' + accObj.Middle_Name__c;
        }
        if (accObj.Last_Name__c != null)
            accObj.Name = accObj.Name + ' ' + accObj.Last_Name__c;
        accObj.Group_Type__c = 'salaried';
        accObj.Flow__c = 'Mobility';
        accObj.Sourcing_Channel__c = oppObj.Sourcing_Channel__c;
        accObj.PANNumber__c = accObj.PANNumber__c.toUpperCase(); //custPANVar.toUpperCase();
        //custPANVar = custPANVar.toUpperCase();
        //component.set("v.accObj", accObj);
        if(component.get("v.accObj.Employer__r.Name.Id") != null){
            accObj.Employer__c = component.get("v.accObj.Employer__r.Name.Id");
            delete accObj['Employer__r'];
        }
        this.setResidenceAddress(component,event,accObj,contObj);
        /* map Contact Obj*/
        contObj.FirstName = accObj.First_Name__c;
        contObj.Middle_Name__c = accObj.Middle_Name__c;
        contObj.LastName = accObj.Last_Name__c;
        contObj.ApplicantType__c = 'Primary';
        contObj.Date_of_Birth__c = accObj.Date_of_Birth__c;
        contObj.Customer_Type__c = 'Individual';
        contObj.Current_experiance_in_Years__c = accObj.Current_experiance_in_Years__c;
        contObj.Current_experiance_in_Month__c = accObj.Current_experiance_in_Month__c;
        contObj.Adhaar_Number__c = accObj.Adhaar_Number__c;
        if (accObj.Total_Work_Experience_Yrs__c != null) contObj.Total_Work_Experience_Yrs__c = accObj.Total_Work_Experience_Yrs__c;
        if (accObj.Total_Work_Experience_Months__c != null) contObj.Total_Work_Experience_Months__c = accObj.Total_Work_Experience_Months__c;
        contObj.Mobile__c = accObj.Mobile__c;
        contObj.PAN_Number__c = accObj.PANNumber__c;
        contObj.Employer__c = accObj.Employer__c;
        contObj.Company_Category__c = accObj.Type_Of_Industry__c;
        contObj.Company_Type__c = accObj.Company_Type__c;
        contObj.Name_of_the_Company_Employer__c = accObj.Name_of_the_Company_Employer__c;
        contObj.Residence_City__c = accObj.Current_City__c;
        contObj.Address_1__c = accObj.Current_Residence_Address1__c;
        contObj.Address_2__c = accObj.Current_Residence_Address2__c;
        contObj.Address_3__c = accObj.Current_Residence_Address3__c;
        contObj.STD_Code__c = accObj.Current_STDCode__c;
        if(accObj.Mobile__c != null) contObj.Mobile_Phone__c = accObj.Mobile__c;
        if(accObj.Gender__c != null ){
            if(accObj.Gender__c == 'Female'){
                contObj.Sex__c = 'F';
            }
            if( accObj.Gender__c == 'Male'){
                contObj.Sex__c = 'M';
            }
        }
        
        /* Map Opportunity*/
        oppObj.Name = accObj.Name;
        oppObj.stageName = 'DSA/PSF Login';
        oppObj.Approver__c = 'DSA';
        oppObj.Loan_Application_Flow__c = 'Mid Office 1';
        oppObj.Customer_Type__c = 'Individual';
        if (oppObj.Application_Source__c != null) oppObj.LeadSource = oppObj.Application_Source__c;
        if(component.get("v.oppObj.Sourcing_Channel__r.Name.Id") != null){
            component.set("v.oppObj.Sourcing_Channel__c",component.get("v.oppObj.Sourcing_Channel__r.Name.Id"));
            delete oppObj['Sourcing_Channel__r'];
        }
        //console.log('>>referral>>'+component.get("v.oppObj.Referral__r"));
        console.log('11'); 
        console.log(component.get("v.oppObj.Referral__r")); 
        console.log('22'); 
        console.log(component.get("v.oppObj.Referral__r.Name")); 
        console.log('33'); 
        console.log(component.get("v.oppObj.Referral__r.Name.Id")); 
        
        if(component.get("v.oppObj.Referral__r") != null || component.get("v.oppObj.Referral__r.Name") != null || component.get("v.oppObj.Referral__r.Name.Id") != null){
            component.set("v.oppObj.Referral__c",component.get("v.oppObj.Referral__r.Name.Id"));
            if(component.get("v.oppObj.Referral__r.Name.Id") == null)
            {
                component.set("v.oppObj.Referral__c",'');
                oppObj.Referral__c = null;
            }
            console.log("referral"+component.get("v.oppObj.Referral__r.Name.Id"));
            delete oppObj['Referral__r'];
        }
        
        /*Map Applicant*/
        applicantObj.Customer_Name__c = accObj.First_Name__c + ' ' + accObj.Last_Name__c;
        applicantObj.Applicant_Type__c = 'Primary';
        applicantObj.Company_Name__c = contObj.Name_of_the_Company_Employer__c;
        applicantObj.Designation__c = contObj.Designation__c;
        applicantObj.Department__c = contObj.Department__c;
        applicantObj.Company_Type__c = contObj.Company_Type__c;
        applicantObj.Name_of_Employer__c = contObj.Name_of_Employer__c;
        applicantObj.Preferred_communication_address__c = contObj.Preferred_communication_address__c;
        applicantObj.Contact_Mobile__c = contObj.Mobile_Phone__c;
        this.executeApex(component, "saveMCP", {"oppId": component.get("v.oppId"), "accObj" : JSON.stringify(accObj), "oppObj" : JSON.stringify(oppObj),"contObj" : JSON.stringify(contObj),"applicantObj" : JSON.stringify(applicantObj),"kycobj" : JSON.stringify(component.get("v.kyc"))},function(error, result){
            if(!error && result){
                var data = JSON.parse(result);
                console.log('data'+data);
                if(data.status.includes('MCP Successfully done')){
                    component.set("v.oppObj", data.opp);
                    component.set("v.tempOppId", data.opp.Id);
                    console.log('referralname'+referralname);
                    //if(!$A.util.isEmpty(referralname)) 
                   	component.set("v.oppObj.Referral__r.Name", referralname);
                    component.set("v.oppObj.Sourcing_Channel__r.Name", scourcingName);
                    //(employername);
                    component.set("v.accObj", data.accPrimary);
                    //component.set("v.custPAN", data.accPrimary.PANNumber__c);
                    component.set("v.accObj.Employer__r.Name", employername);
                    component.set("v.contObj", data.contPrimary);
                    component.set("v.applicantObj", data.applicantPrimary);
                    component.set("v.camObj", data.camObj);
                    component.set("v.mcpSuccess", "Success");
                    
                    this.displayMessage(component, 'SuccessToast1', 'successmsg1', '<b>Success!</b> MCP done Successfully');
                    var disableTabevent = $A.get("e.c:disableOppTabs");
                    disableTabevent.setParams({
                        "disableTrue" : false
                    });
                    disableTabevent.fire();
                    this.hideSpinner(component);
                    if(!component.get("v.oppId"))
                    {
                        var cmpTarget = component.find('overrideModalbox');
                        var cmpBack = component.find('Modalbackdrop');
                        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
                        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
                    }
                    
                }
                else
                    if(data.status.includes('We cannot proceed due to duplicate data'))
                    {
                        this.displayMessage(component, 'ErrorToast1', 'errormsg1',data.status) ;
                        this.hideSpinner(component);
                    }
                    else if(data.status.includes('Exception'))
                    {
                        this.displayMessage(component, 'ErrorToast1', 'errormsg1',data.status) ;
                        this.hideSpinner(component);
                    }
                        else{
                            component.set("v.oppObj", data.opp);
                            component.set("v.tempOppId", data.opp.Id);
                            
                            component.set("v.accObj", data.accPrimary);
                            
                            component.set("v.contObj", data.contPrimary);
                            component.set("v.applicantObj", data.applicantPrimary);
                            
                            this.displayMessage(component, 'ErrorToast1', 'errormsg1', '<b>Error!</b>,Error while processing!');
                        }
                
                component.set("v.mcpSuccess", "Fail");
                component.set("v.oppObj.Sourcing_Channel__r.Name", scourcingName);
                component.set("v.accObj.Employer__r.Name", employername);
                console.log('referralname>>'+referralname);
                if(!$A.util.isEmpty(referralname))
                    component.set("v.oppObj.Referral__r.Name", referralname);
                var disableTabevent = $A.get("e.c:disableOppTabs");
                disableTabevent.setParams({
                    "disableTrue" : true
                });
                disableTabevent.fire();
                
                console.log('eKyc>>'+component.get("v.kyc.Id"));
                if(!$A.util.isEmpty(component.get("v.kyc")) && !$A.util.isEmpty(component.get("v.kyc.Id")))
                {
                    var appEkycEvent = $A.get("e.c:Sal_Opp_EkycEvent");
                    appEkycEvent.setParams({
                        "eKycObj" : component.get("v.kyc")
                    });
                    appEkycEvent.fire();
                }
                
                this.hideSpinner(component);
                console.log('end submit');
            }
            
            this.hideSpinner(component);
            
        });
        
    },
    setResidenceAddress : function (component, event,accObj,contObj) {
        
        var residenceAddress = component.get("v.resiAddress");
        console.log('robin '+residenceAddress.trim().indexOf(' '));
        //Rohit added for bug 18279
        if(residenceAddress.trim().indexOf(' ') === -1){
            
            if(residenceAddress.length >= 70){
                 var slices = Math.round((residenceAddress.length)/3);
                 var resiadd = residenceAddress.substr(0,slices);
                 console.log('slices '+slices);
                 accObj.Current_Residence_Address1__c  = contObj.Address_1__c  = resiadd;
                 accObj.Current_Residence_Address2__c  = contObj.Address_2__c  = residenceAddress.substr(slices+1,2*slices);
                 accObj.Current_Residence_Address3__c  = contObj.Address_3__c  = residenceAddress.substr(2*slices,residenceAddress.length-1);
            }
            else if(residenceAddress.length >=35 &&  residenceAddress.length <70){
                 var slices = Math.round((residenceAddress.length)/2);
                 var resiadd = residenceAddress.substr(0,slices);
                 accObj.Current_Residence_Address1__c  = contObj.Address_1__c  = resiadd;
                 accObj.Current_Residence_Address2__c  = contObj.Address_2__c  = residenceAddress.substr(slices+1,residenceAddress.length-1);
            }
            else if(residenceAddress.length <35){
                  accObj.Current_Residence_Address1__c  = contObj.Address_1__c  = residenceAddress;   
            }
        }
        else{
        
        if (residenceAddress) {
            var result = [], line = [];
            var length = 0;
            residenceAddress.split(" ").forEach(function(word) {
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
            if(result[0])
                accObj.Current_Residence_Address1__c  = contObj.Address_1__c  = result[0];
            else
                accObj.Current_Residence_Address1__c  = contObj.Address_1__c  ='';
            if(result[1])
                accObj.Current_Residence_Address2__c  = contObj.Address_2__c  =result[1];
            else
                accObj.Current_Residence_Address2__c  = contObj.Address_2__c ='';
            if(result[2])
                accObj.Current_Residence_Address3__c  = contObj.Address_3__c  =result[2];
            else
                accObj.Current_Residence_Address3__c  = contObj.Address_3__c ='';
          
        }
        }
        
        
    },
    displayMessage: function (component, toastid, messageid, message) {
        document.getElementById(toastid).style.display = "block";
        if(component.get('v.theme') == 'Theme4d'){
            var toastClasses = document.getElementById("ErrorToast").classList;
            toastClasses.add("lightningtoast");
            document.getElementById("SuccessToast").classList.add("lightningtoast");  
        }
        document.getElementById(messageid).innerHTML = message;
        console.log('message'+message);
        
        setTimeout(function () {
            document.getElementById(messageid).innerHTML = "";
            document.getElementById(toastid).style.display = "none";
        }, 3000);
    },
    closeToastnew: function (component) {
        document.getElementById('successmsg1').innerHTML = "";
        document.getElementById('SuccessToast1').style.display = "none";
    },
    closeToastError: function (component) {
        document.getElementById('errormsg1').innerHTML = "";
        document.getElementById('ErrorToast1').style.display = "none";
    },
    
    getDisablecheckbox: function (component) {
        console.log("checkdata" + component.get("v.resiAddress"));
        //var checkCmp = component.find("address"); 
        console.log("valueofaddress : " + $A.util.isEmpty(component.get("v.kyc.eKYC_Address_details__c")));
        if (!$A.util.isEmpty(component.get("v.kyc")) && !$A.util.isEmpty(component.get("v.kyc.eKYC_Address_details__c"))) {
            console.log('inside if of getDisableCheckBox');
            component.find("copyekycaddress").set("v.disabled", false);
        } else
            component.find("copyekycaddress").set("v.disabled", true);
        
        console.log('inside getDisableCheckBox at last');
    },
    activateTab: function(component, tabId,onstageclick) {
        
        console.log('tabId>>>'+tabId); 
       	 component.set("v.disablePrev", false); 
       	 component.set("v.disableNext", false);
        $A.util.removeClass(component.find("AadharTab"), "slds-is-current slds-is-active");
        $A.util.removeClass(component.find("McpTab"), "slds-is-current slds-is-active");
        $A.util.removeClass(component.find("ObligationTab"), "slds-is-current slds-is-active");
        $A.util.removeClass(component.find("EligibilityTab"), "slds-is-current slds-is-active"); 
        $A.util.removeClass(component.find("McpOutputTab"), "slds-is-current slds-is-active");
        $A.util.removeClass(component.find("CommunicationTab"), "slds-is-current slds-is-active");
        $A.util.removeClass(component.find("PerfiosTab"), "slds-is-current slds-is-active");
        
        $A.util.addClass(component.find("AadharTab"), "slds-is-incomplete");
        $A.util.addClass(component.find("McpTab"), "slds-is-incomplete");
        $A.util.addClass(component.find("ObligationTab"), "slds-is-incomplete");
        $A.util.addClass(component.find("EligibilityTab"), "slds-is-incomplete");
        $A.util.addClass(component.find("McpOutputTab"), "slds-is-incomplete");
        $A.util.addClass(component.find("CommunicationTab"), "slds-is-incomplete");
        $A.util.addClass(component.find("PerfiosTab"), "slds-is-incomplete");
        console.log('robin '+component.find("McpTab"));
        $A.util.removeClass(component.find(tabId), "slds-is-incomplete");
        $A.util.addClass(component.find(tabId), "slds-is-current slds-is-active");
        
        this.showHideDiv(component, "AadharTabContent", false);
        this.showHideDiv(component, "McpTabContent", false);
        this.showHideDiv(component, "ObligationTabContent", false);
        this.showHideDiv(component, "EligibilityTabContent", false); 
        this.showHideDiv(component, "McpOutputTabContent", false); 
        this.showHideDiv(component, "CommunicationTabContent", false); 
        this.showHideDiv(component, "PerfiosTabContent", false); 
        this.showHideDiv(component, tabId+"Content", true);
        if(onstageclick){ 
            var activepath = component.get("v.activePath");
            var pathList = component.get("v.pathList");
            var currentPos = 1;
            var prevPos = 1;
            var pathscroll = false;
            for(var i=0; i < pathList.length; i++) {
                if(pathList[i] == activepath){
                    prevPos = i+1;
                }
                if(pathList[i] == tabId){
                    currentPos = i+1;
                }
            }
            if(prevPos < currentPos){
                pathscroll = true;
            }
            console.log('pathscroll>>'+pathscroll+'prevPos>>'+prevPos+'>>currentPos>>'+currentPos);
            var scrollContainer = $(".offer-pg-cont");
            var items = $(".stage_item");
            var item = this.fetchItem(component,scrollContainer, items, pathscroll);
            var currentleft = scrollContainer.scrollLeft();
            var addleft = item.position().left + scrollContainer.scrollLeft();
            console.log('scrollcontainer>>'+currentleft+'>>addleft>>'+addleft+'>>item position>>'+item.position().left);
            if(pathscroll && (addleft > currentleft)){
                scrollContainer.animate({"scrollLeft": item.position().left + scrollContainer.scrollLeft()}, 400); 
            }
            else if(pathscroll == false && (addleft < currentleft) )
                scrollContainer.animate({"scrollLeft": item.position().left + scrollContainer.scrollLeft()}, 400);
        }
        component.set("v.activePath", tabId);
        if(tabId == 'AadharTab'){
            if(component.get("v.hideAadhaarSection") == false){//added if condition for 21851   
               component.set("v.disablePrev", true);
           	   component.set("v.StageNum",1); 
            }
        }
        else if(tabId == 'PerfiosTab'){
            component.set("v.disableNext", true);   
             //added if else condition for 21851 start
                if(component.get("v.hideAadhaarSection") == false){
                     component.set("v.StageNum",7);
                }
                else if(component.get("v.hideAadhaarSection") == true){
                    component.set("v.StageNum",6);
                }   //added if else condition for 21851 end
        }else if(tabId == 'McpTab'){
                //added if else condition for 21851 start
                if(component.get("v.hideAadhaarSection") == false){
                     component.set("v.StageNum",2);
                }else if(component.get("v.hideAadhaarSection") == true){
                    component.set("v.disablePrev", true);
                    component.set("v.StageNum",1);
                }   //added if else condition for 21851 end
                 
                if($A.util.isEmpty(component.get("v.oppId"))){
                    component.set("v.disableNext", true);
                }
            } else if(tabId == 'ObligationTab'){
                    //added if else condition for 21851 start
                    if(component.get("v.hideAadhaarSection") == false){
                          component.set("v.StageNum",3);
                    }
                    else if(component.get("v.hideAadhaarSection") == true){
                        component.set("v.StageNum",2);
                    }   //added if else condition for 21851 end
                   
                }else if(tabId == 'EligibilityTab'){
                     //added if else condition for 21851 start
                    if(component.get("v.hideAadhaarSection") == false){
                          component.set("v.StageNum",4);
                    }
                    else if(component.get("v.hideAadhaarSection") == true){
                        component.set("v.StageNum",3);
                    }   //added if else condition for 21851 end
                } else if(tabId == 'McpOutputTab'){
                         //added if else condition for 21851 start
                        if(component.get("v.hideAadhaarSection") == false){
                              component.set("v.StageNum",5);
                        }
                        else if(component.get("v.hideAadhaarSection") == true){
                            component.set("v.StageNum",4);
                        }   //added if else condition for 21851 end
                 }else if(tabId == 'CommunicationTab'){
                        //added if else condition for 21851 start
                        if(component.get("v.hideAadhaarSection") == false){
                              component.set("v.StageNum",6);
                        }
                        else if(component.get("v.hideAadhaarSection") == true){
                            component.set("v.StageNum",5);
                        }   //added if else condition for 21851 end
                } 
        console.log('in activateTab end');
    },
    fetchItem :function(component,container, items, isNext) {
        var i,
            scrollLeft = container.scrollLeft();
        //set isNext default to true if not set
        if (isNext === undefined) {
            isNext = true;
        }
        if (isNext && container[0].scrollWidth - container.scrollLeft() <= container.outerWidth()) {
            //we reached the last one so return the first one for looping:
            return $(items[0]);
        }
        //loop through items
        for (i = 0; i < items.length; i++) {
            
            if (isNext && $(items[i]).position().left > 0) {
                //this item is our next item as it's the first one with non-negative "left" position
                return $(items[i]); 
            } else if (!isNext && $(items[i]).position().left >= 0) {
                //this is our previous item as it's the one with the smallest negative "left" position
                //if we're at item 0 just return the last item instead for looping
                return i == 0 ? $(items[items.length - 1]) : $(items[i-1]);
            }
        }
        
        //nothing found
        return null;
    },
    showHideDiv: function(component, divId, show){
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
    showSpinner: function (component) {
        this.showHideDiv(component, "waiting", true);
    },
    hideSpinner: function (component) {
        this.showHideDiv(component, "waiting", false);
    },
    getUrlParameter : function(component,sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;
        console.log('sPageURL>>'+sPageURL);
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');
            
            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }
    },
    updateeKYCForOpp: function(component,event)
    {
        var kyc = component.get("v.kyc");
        if (kyc) {
            kyc.Applicant__c = component.get("v.applicantObj").Id;
            component.set('v.kyc', kyc);
            console.log("KYC : " + kyc.Id);
            if (!$A.util.isEmpty(kyc.Id) && !$A.util.isEmpty(component.get("v.applicantObj").Id) ) {
                console.log("KYC inside : " + kyc.Id);
                var kyc = component.get("v.kyc");
                var action = component.get("c.saveKYCforOpp");
                var params = {
                    ekycObj : kyc,
                    appObj : component.get("v.applicantObj")
                };
                action.setParams(params);
                action.setCallback(this, function (response) {
                    var state = response.getState()
                    var result = response.getReturnValue();
                    console.log('ekyc result1'+result);
                    if (state === 'SUCCESS' && result) {
                        console.log('ekyc result' + result);
                        component.set("v.kyc", result);
                        console.log(result);  
                    }
                }); 
                $A.enqueueAction(action);
            }
        }
    },
    /*Bug 18669 Start*/
     getEKYCRecHelper : function(component,randomNum){
        console.log('randomNum inside helper '+randomNum);
        this.executeApex(component, "getEkycRec", {ranNum: randomNum}, function(error, result){
            console.log('inside execute apex');
            if(!error && result){
                console.log('in method>>>'+ result);
                var data = result;
                console.log('data'+JSON.stringify(data));
                console.log('data.bio_Ekyc__c : '+data.bio_Ekyc__c);
				if(data.bio_Ekyc__c == true){
                    console.log('inside biometric field condition');
					component.set("v.kyc",data);
                   var appEvent = $A.get("e.c:InitiateKYCForm");
                        if(appEvent){
                            appEvent.setParams({ "kyc" : data});
                            appEvent.fire();
                        }
				}
            }
        });
    }
    /*Bug 18669 End  */
})