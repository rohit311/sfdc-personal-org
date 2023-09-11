({

	//added for bug 23064 Start
    getloggedinuserprofile :function(component, event) {
         var action = component.get("c.getuserprofile");
        action.setCallback(this, function(response){
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    console.log('...inside success...');
                    var profilecheck = response.getReturnValue();
                    console.log('profilecheck'+profilecheck);
                    component.set("v.salesprofilecheck",profilecheck);
              		console.log(component.get('v.salesprofilecheck'));
				}
            });
            $A.enqueueAction(action); 
        },
   //added for bug 23064 Stop
    //added for bug id 22047 start  
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
    },
    //added for bug id 22047 stop
 
    getoppDetails : function(component, event) {
        debugger;
      //  alert('in getOpportunityData');
	  //Added Send_Back_Reason__c for user story 985
        var AccountSelectList = ["Preferred_language__c","Downsizing_Reasons__c","Send_Back_Reason__c","Total_Work_Experience_Yrs__c", "Total_Work_Experience_Months__c", "Current_experiance_in_Years__c", "Current_experiance_in_Month__c","Type_of_Educational_Institution__c"];
        var selectListNameMap = {};
        selectListNameMap["Account"] = AccountSelectList;
        var oppSelectList = ["Reject_Reason_1__c","Reject_Reason__c","Loan_Variant__c"];//1652
        selectListNameMap["Opportunity"] = oppSelectList;
         var ExisLoanSelectList=["Type_of_Oblig__c","Status__c","financers__c","Loan_Type__c"];//US 983
        selectListNameMap["Existing_Loan_Details__c"] = ExisLoanSelectList;//US 983 rohit
        var action = component.get('c.getOpportunityData');
        action.setParams({
            "oppId" : component.get('v.oppId'),
            "objectFieldJSON": JSON.stringify(selectListNameMap)
        });
        action.setCallback(this, function(response){
            this.showhidespinner(component,event,false);
            var state = response.getState();
            if (state == "SUCCESS") {
                console.log('success');
                if(!$A.util.isEmpty(response.getReturnValue())){
                    var data = JSON.parse(response.getReturnValue());
					//24668 start
                    console.log('fin appl '+data.finAppl);
                    if(data.finAppl){
                    	component.set("v.finAppl",data.finAppl);
                        var appTypeLst = component.get("v.appTypeLst");
                        if(!appTypeLst.includes("Financial Co-Applicant"))
                        	appTypeLst.push("Financial Co-Applicant");
                        
                        component.set("v.appTypeLst",appTypeLst);
                    }
                    //24668 stop
                    component.set("v.showfinaloffer",true);//performance issue
                    component.set("v.isValidIM_Products",data.isValidIM_Products); //22018 RSL mobility
                    /*City CR s*/
                    var cityList = data.cityList;
                    var finalCityList = [];
                    for(var key in cityList){
                        var stateMap = cityList[key];
                        var state = stateMap['state'];
                        console.log('city is'+key+'state is'+state);
                        finalCityList.push({city : key,state : state});
                    }
                    component.set("v.cityList",finalCityList);
                    /*City CR e*/
                    console.log(data); 
                    component.set("v.profileName", data.myProflieName);
                     component.set("v.sourCateg", data.sourCateg);//CR 23820
                    console.log('Source Category'+data.sourCateg);
                    var picklistFields = data.picklistData;
                    var accountPickFlds = picklistFields["Account"];
                    var oppPickFlds = picklistFields["Opportunity"];
                     component.set('v.srcamObj',data.srcamObj);//9465
                        //US 983 rohit start
                    var exiLoanPickFlds = picklistFields["Existing_Loan_Details__c"];
                    component.set("v.oblType", exiLoanPickFlds["Type_of_Oblig__c"]);
                    component.set("v.statusLst", exiLoanPickFlds["Status__c"]);
                    component.set("v.finLst", exiLoanPickFlds["financers__c"]);
                    console.log ('financer list ='+component.get("v.finLst"));
                    component.set("v.loanTypeLst", exiLoanPickFlds["Loan_Type__c"]);
                    //US 983 rohit stop
                    component.set("v.rejectOption1", oppPickFlds["Reject_Reason_1__c"]);
                    //component.set("v.rejectOption", oppPickFlds["Reject_Reason__c"]);
					component.set("v.sendbackoption",accountPickFlds["Send_Back_Reason__c"]); // User story 985
                    component.set("v.loanVariantList", oppPickFlds["Loan_Variant__c"]);//US 1652
					/* bug 27068 fix*/
                    component.set("v.preLangList", accountPickFlds["Preferred_language__c"]);
                      component.set("v.downSizeList", accountPickFlds["Downsizing_Reasons__c"]);  
                    console.log ('preferred language check='+component.get ("v.preLangList"));
                    //US 983 rohit start
                       //24315 start
                    if(!$A.util.isEmpty(data.repayList)){
                        component.set("v.repayObj",data.repayList[0]);
                    }
                    if(!$A.util.isEmpty(data.disburement)){
                        component.set("v.disbObj",data.disburement[0]);
                    }
                    console.log('disburement '+ JSON.stringify(data.disburement[0]));
                    //24315 stop
                if(data.allApps){
                    
                    var allApps = data.allApps;
                    allApps.push(data.applicantPrimary);
                    console.log(allApps);
                    var appsToPass = new Array();
                    if(allApps){
                        for(var j=0;j<allApps.length;j++){
                            if(allApps[j].Applicant_Type__c == 'Primary' || allApps[j].Applicant_Type__c == 'Financial Co-Applicant'){
                                
                                appsToPass.push(allApps[j]);
                            }
                        }
                        
                    }
                    component.set("v.allApps",appsToPass);
                }
                var obligLst = new Array();  
                console.log('fetchExtSeperate',data.fetchExtSeperate);    
                if(data.fetchExtSeperate === false){    
                    if(data.opp.Existing_Loan_Details__r && data.opp.Existing_Loan_Details__r.records && !component.get("v.isdoInitCalled")){
                        
                        var exObj;
                        for(var i=0;i<data.opp.Existing_Loan_Details__r.records.length;i++){
                            exObj = new Object();
                            exObj = data.opp.Existing_Loan_Details__r.records[i];
                          
                            if (exObj.EMI__c){
                            var num =parseFloat(exObj.EMI__c);
                            exObj.EMI__c = num.toFixed(2).toString();
                            console.log ('check decimal point='+exObj.EMI__c);
                            }
                            
                            obligLst.push({"exObj":exObj,"deleteRecord":false});
                                                    
                        }
                        component.set("v.obligLst",obligLst);
                        console.log('underwriting helper check='+JSON.stringify(obligLst));
                    }
                }
                if(!component.get("v.isdoInitCalled") && (data.fetchExtSeperate === true)){    
                	this.fetchExtDetl(component,event);    
                }
                component.set("v.isdoInitCalled",true);
              
                    
                //US 983 rohit stop
                    if (!$A.util.isEmpty(data) && !$A.util.isEmpty(data.options))
                    {
                        component.set("v.rejectOption",data.options);
                    }
                    
                    console.log('pkreason'+oppPickFlds["Reject_Reason__c"]);
                    console.log('accountPickFlds["Total_Work_Experience_Yrs__c"] : ' + accountPickFlds["Total_Work_Experience_Yrs__c"]);
                    /*US 524 s*/
                    if(!$A.util.isEmpty(data.isCriticalChange)){
						component.set("v.isCriticalChange",data.isCriticalChange);
						console.log('data.isCriticalChange return  '+component.get("v.isCriticalChange"));
					}
                    /*US 524 e*/

                    if (!$A.util.isEmpty(data.theme))
                    {
                     component.set("v.nameTheme",data.theme);
                    }
                    if (!$A.util.isEmpty(data.dsaUser))
                    {
                     component.set("v.dsaUser",data.dsaUser);
                    } 
                    console.log('pkisCommunityUsr'+oppPickFlds["Reject_Reason__c"]);
                     if (!$A.util.isEmpty(data.isCommunityUsr)){
                        component.set('v.iscommunityUser', data.isCommunityUsr);
                    }
                    if (!$A.util.isEmpty(data.ekycobj))
                    {
                        component.set('v.eKycObj',data.ekycobj);
                        component.set("v.isEkycDone",true);
                        this.eKycSplitAddress(component, event);
                    }
                    if (!$A.util.isEmpty(data.creditofcList))
                    {
                        component.set('v.creditofficerList',data.creditofcList);
                    }
                    if(!$A.util.isEmpty(data.tatMasterRecord))
                    	component.set("v.tatMasterRecord", data.tatMasterRecord);   
                    if (!$A.util.isEmpty(data.poobj)){
                        component.set('v.poObj',data.poobj);
                        
                        if(!$A.util.isEmpty(data.poobj.Customer_ID1__r))
							component.set("v.custId",data.poobj.Customer_ID1__r.Id);
                    }
                    component.set('v.rules',data.RuralRules); //11806
                    if (!$A.util.isEmpty(data.isPreapproved))
						component.set("v.isPreapproved" ,data.isPreapproved);
                    if (!$A.util.isEmpty(data.opp))
                        component.set('v.loan',data.opp);
                    /* CR 22307 s*/
                    console.log('stageName'+data.opp.StageName);
                     if(!$A.util.isEmpty(data.opp) && !$A.util.isEmpty(data.opp.StageName))
                        component.set("v.stageName", data.opp.StageName); /* CR 22307 e*/
                    var loan = component.get("v.loan");
                     if(loan != undefined && loan.Branch_Name__r != undefined && loan.Branch_Name__r.SAL_Branch_Type__c == 'Tier III')
                    {
                        component.set("v.isSpecialProfile", true);
                    }
                     component.set("v.TatTime", data.TatTime);
console.log('Tat time is ='+data.TatTime);
                    if (!$A.util.isEmpty(data.cibilobj))
                        component.set('v.cibilobj',data.cibilobj);
                    if(!$A.util.isEmpty(data.cibilTempobj))
                    {
                        component.set("v.cibilTemp", data.cibilTempobj);   
                    }
                    if (!$A.util.isEmpty(data.cibilExt))
                        component.set('v.cibilExt',data.cibilExt);
                    
                    if (!$A.util.isEmpty(data.cibilExt1))
                        component.set('v.cibilExt1',data.cibilExt1);
                    /* 22018 RSL Mobility Start */
                    
                    /* 22018 RSL Mobility Stop */
                    if (!$A.util.isEmpty(data.objCon)) {
                        component.set("v.conObj", data.objCon);
                        component.set("v.oldOfficeemail", data.objCon.Office_Email_Id__c);//prod new CR
                        console.log('pk gender1'+data.objCon.Sex__c);
                        //component.set("v.isSpecialProfile", data.objCon.Special_Profile_Employer__c);
                        component.set("v.specialPro",data.objCon.Special_Profile_Employer__c);
                        var officeResiAdd = '';
                        if(data.objCon.Address_Line_One__c != null)
                            officeResiAdd = officeResiAdd + data.objCon.Address_Line_One__c;
                        if(data.objCon.Address_2nd_Line__c != null)
                            officeResiAdd = officeResiAdd + ' ' + data.objCon.Address_2nd_Line__c;
                        if(data.objCon.Address_3rd_Line__c != null)
                            officeResiAdd = officeResiAdd + ' ' + data.objCon.Address_3rd_Line__c;
                        component.set("v.officeAddress",officeResiAdd);
                        
                    }
                    if (!$A.util.isEmpty(data.accObj)) {
                        
                        component.set("v.accObj", data.accObj);
                        if(component.get("v.accObj").Employer__r){//24668
                        	component.set("v.EmployerSearchKeyword",component.get("v.accObj").Employer__r.Name);
                        }
                        var mobile_number = component.get("v.mobileNumber");
                        mobile_number = "tel:"+data.accObj.Mobile__c;
                        component.set("v.mobileNumber",mobile_number);
                        /*City CR s*/
                        if (!$A.util.isEmpty(data.accObj.Current_City__c))
                            component.set("v.citySearchKeyword", data.accObj.Current_City__c);
                        /*City CR e*/
                        if (!$A.util.isEmpty(data.accObj.Area_Locality__c))
                        	component.set("v.areaSearchKeyword", data.accObj.Area_Locality__r.Name);
                    }
                    // sal 2.0 new cr s
                      if(!$A.util.isEmpty(data.poobj)){
                        component.set('v.poObj',data.poobj);
                        var address = ''
                        if(!$A.util.isEmpty(component.get("v.poObj.Address_Line_1__c")))
                            address = address + ' ' + component.get("v.poObj.Address_Line_1__c");
                        if(!$A.util.isEmpty(component.get("v.poObj.Address_Line_2__c")))
                            address = address + ' ' + component.get("v.poObj.Address_Line_2__c");
                        if(!$A.util.isEmpty(component.get("v.poObj.Address_Line_3__c")))
                            address = address + ' ' + component.get("v.poObj.Address_Line_3__c");
                        component.set("v.poAddress",address);
                    }
                    if(!$A.util.isEmpty(component.get("v.accObj"))){
                        var address1 = ''
                        if(!$A.util.isEmpty(component.get("v.accObj.Current_Residence_Address1__c")))
                            address1 = address1 + ' ' + component.get("v.accObj.Current_Residence_Address1__c");
                        if(!$A.util.isEmpty(component.get("v.accObj.Current_Residence_Address2__c")))
                            address1 = address1 +  ' ' + component.get("v.accObj.Current_Residence_Address2__c");
                        if(!$A.util.isEmpty(component.get("v.accObj.Current_Residence_Address3__c")))
                            address1 = address1 + ' ' + component.get("v.accObj.Current_Residence_Address3__c");
                        component.set("v.inputAddress",address1);
                    }
                    var eKycObj = component.get('v.eKycObj');
                    if(eKycObj !=null)
                    {
                     var permanentAddress = component.get('v.eKycObj.eKYC_Address_details__c');
                     component.set("v.eKycAddress",permanentAddress);
                    }
                //sal 2.0 new cr e
                      if (!$A.util.isEmpty(component.get("v.accObj")) && !$A.util.isEmpty(component.get("v.accObj.EPFO_Result__c"))) {
                        component.set("v.epfoShow",true); 
                    }
                    if (!$A.util.isEmpty(data.applicantPrimary))
                        component.set("v.applicantObj", data.applicantPrimary);
                    if (!$A.util.isEmpty(data.bankObj))
                        component.set("v.bankObj", data.bankObj);
                    console.log('bank details');
                    console.log(component.get("v.bankObj"));
                    /*24316 s*/
                    if(!$A.util.isEmpty(data.veriList))
                        component.set("v.veriList",data.veriList);
                    /*24316 e*/
                    if (!$A.util.isEmpty(data.camObj))
                        component.set("v.camObj", data.camObj);
                    var bankObj = component.get("v.bankObj");
                    /*if(!$A.util.isEmpty(bankObj)){
                        if($A.util.isEmpty(bankObj.Perfios_Flag__c) || (!$A.util.isEmpty(bankObj.Perfios_Flag__c) && bankObj.Perfios_Flag__c == false)){
                            
                            var date1,date2,date3,diffDays12,diffDays13,diffDays23;
                            if(!$A.util.isEmpty(bankObj.Salary_Credit_Date1__c))
                                date1 = new Date(bankObj.Salary_Credit_Date1__c);
                            if(!$A.util.isEmpty(bankObj.Salary_Credit_Date2__c))
                                var date2 = new Date(bankObj.Salary_Credit_Date2__c);
                            if(!$A.util.isEmpty(bankObj.Salary_Credit_Date3__c))
                                var date3 = new Date(bankObj.Salary_Credit_Date3__c);
                            if(!$A.util.isEmpty(date1) && !$A.util.isEmpty(date2)){
                                var timeDiff12 = Math.abs(date1.getTime() - date2.getTime());
                                diffDays12 = Math.ceil(timeDiff12 / (1000 * 3600 * 24)); 
                            }
                            if(!$A.util.isEmpty(date1) && !$A.util.isEmpty(date3)){
                                var timeDiff13 = Math.abs(date1.getTime() - date3.getTime());
                                diffDays13 = Math.ceil(timeDiff13 / (1000 * 3600 * 24)); 
                            }
                            if(!$A.util.isEmpty(date2) && !$A.util.isEmpty(date3)){
                                var timeDiff23 = Math.abs(date1.getTime() - date2.getTime());
                                diffDays23 = Math.ceil(timeDiff23 / (1000 * 3600 * 24));  
                            }
                            if((!$A.util.isEmpty(diffDays12) && diffDays12 > 5) || (!$A.util.isEmpty(diffDays13) && diffDays13 > 5) || (!$A.util.isEmpty(diffDays23) &&diffDays23 >5))
                            {
                                component.set("v.datevariation","YES");
                            }
                            else
                            {
                                component.set("v.datevariation","NO");
                            }
                        }
                        else
                            component.set("v.datevariation","NO");
                        
                        
                        if($A.util.isEmpty(bankObj.Perfios_abb02__c))
                            bankObj.Perfios_abb02__c =0;
                        if($A.util.isEmpty(bankObj.Perfios_abb05__c))
                            bankObj.Perfios_abb05__c =0;
                        if($A.util.isEmpty(bankObj.Perfios_abb10__c))
                            bankObj.Perfios_abb10__c  =0;
                        var abbvalue = bankObj.Perfios_abb02__c + bankObj.Perfios_abb05__c + bankObj.Perfios_abb10__c;
                        if(abbvalue != 0)
                            abbvalue  = abbvalue / 3;
                        component.set("v.abbvalue",abbvalue);
                        
                        
                        
                    }
                    else{
                        component.set("v.datevariation","NO");
                        component.set("v.abbvalue","0");
                        
                    }
                    console.log('here cam');*/
                    var camObj = component.get("v.camObj");
                    /*if(!$A.util.isEmpty(camObj)){
                        console.log('here cam');
                        var amount1 = 0,amount2 = 0,amount3 = 0,diffamount12 = 0,diffAmount13 = 0,diffAmount23 = 0,averageSal = 0;
                        if(!$A.util.isEmpty(camObj.Average_incentive_for_Q1__c))
                            amount1 = camObj.Average_incentive_for_Q1__c;
                        if(!$A.util.isEmpty(camObj.Average_incentive_for_Q2__c))
                            amount2 = camObj.Average_incentive_for_Q2__c;
                        if(!$A.util.isEmpty(camObj.Average_incentive_for_Q3__c))
                            amount3 = camObj.Average_incentive_for_Q3__c;
                        
                        if(amount1 != 0){
                            diffamount12 = (amount1-amount2)/amount1;
                            diffAmount13 = (amount1-amount3)/amount1;
                        }
                        if(amount2 != 0){
                            diffAmount23 = (amount2-amount3)/amount2;
                        }
                        if((diffamount12 !=0 && diffamount12 > 0.15) || (!$A.util.isEmpty(diffAmount13) && diffAmount13 > 0.15) || (!$A.util.isEmpty(diffAmount23) && diffAmount23 > 0.15))
                        {
                            component.set("v.amountvariation","YES");
                        }
                        else
                        {
                            component.set("v.amountvariation","NO");
                        }
                        averageSal = amount1 + amount2 + amount3;
                        if(averageSal != 0)
                            averageSal = averageSal/3;
                        console.log('averageSal'+averageSal)
                        component.set("v.averageSal",averageSal);
                    }
                    else
                        component.set("v.amountvariation","NO");*/
                    if (!$A.util.isEmpty(data.SOLPolicyList))
                        component.set("v.solpolicyList", data.SOLPolicyList);
                    console.log('underwriter solpolicy');
                    console.log(data.SOLPolicyList);
                    if (!$A.util.isEmpty(data.accObj) && !$A.util.isEmpty(data.accObj.Employer__c)) {
                        var employerSearchKeyword = data.accObj.Employer__r.Name;
                        if (employerSearchKeyword.toUpperCase() == 'COMPANY NOT LISTED' || employerSearchKeyword.toUpperCase() == 'OTHER' || employerSearchKeyword.toUpperCase() == 'OTHERS') {
                            component.set("v.isOther", true);
                        }
                    }
                    var oppStage = data.opp.StageName;
                    if(oppStage == 'DSA/PSF Login' || oppStage == 'Underwriting')
                    {
                        console.log('pkstage'+oppStage);
                       // component.set("v.isdiablebutton",false);
                        component.set("v.isdiablesendback",false);
                    } 
                    if(oppStage == 'Re-Appraise- Loan amount' || oppStage == 'Underwriting' || oppStage == 'Re-Appraise- IRR' || oppStage == 'Re-Appraise- Tenor' || oppStage == 'Re-Appraise- Reject Case')
                    {
                        component.set("v.isdiablebutton",false);
                    }
                    if(oppStage == 'Approved' || oppStage == 'Re-Appraise- Loan amount' || oppStage == 'Underwriting' || oppStage == 'Re-Appraise- IRR' || oppStage == 'Re-Appraise- Tenor' || oppStage == 'Re-Appraise- Reject Case')
                    {
                        console.log('pkstage'+oppStage);
                        component.set("v.isdisablePricingbutton",false);
                    }
                    if(oppStage != null)
                    {
                        if(oppStage == 'DSA/PSF Login')
                        	component.set("v.stageCompletion","20%");
                        else if(oppStage == 'Underwriting')
                            component.set("v.stageCompletion","40%");
                        else if(oppStage == 'Post Approval Sales')
                            component.set("v.stageCompletion","60%");
                        else if(oppStage == 'Branch Ops')
                        	component.set("v.stageCompletion","80%");
                        else if(oppStage == 'Moved To Finnone')
                        {
                            component.set("v.stageCompletion","100%");
                            $A.util.addClass(component.find("progressSpan"),"slds-progress-bar__value_success");
                        }    
                    }
                    else
                        component.set("v.stageCompletion","0%");
                    $A.util.removeClass(component.find("maindiv"),'disablediv');
                    $A.util.addClass(component.find("maindiv"),'enablediv');
                } 
                $A.util.removeClass(component.find("maindiv"),'disablediv');
                $A.util.addClass(component.find("maindiv"),'enablediv');
                
            }
            else{
                console.log('error');
                $A.util.removeClass(component.find("maindiv"),'disablediv');
                $A.util.addClass(component.find("maindiv"),'enablediv');
            }
                
            // this.displayMessage(component, 'displayErrorToast', 'displayErrorMsg', '<b>Error!</b>,Error while processing!');
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
    eKycSplitAddress: function(component, event) {
        var eKycObj = component.get('v.eKycObj');
        if(eKycObj !=null)
        {
            var permanentAddress = component.get('v.eKycObj.eKYC_Address_details__c');
            if (permanentAddress) {
                var result = [], line = [];
                var length = 0;
                permanentAddress.split(" ").forEach(function(word) {
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
                    component.set('v.eKycAddress1',result[0]);
                else
                    component.set('v.eKycAddress1','');
                
                if(result[1])
                    component.set('v.eKycAddress2',result[1]);
                else
                    component.set('v.eKycAddress2','');
                
                if(result[2])
                    component.set('v.eKycAddress3',result[2]);
                else
                    component.set('v.eKycAddress3','');
            }
        }
    },
   // Added for Ext prod issue Rohit start
    fetchExtDetl : function(component,event){
        var action = component.get("c.fetchExtDet"); 
        
        action.setParams({ "oppId" : component.get("v.recordId") });
        
        action.setCallback(this, function(response) {
        	var state = response.getState();
            if (state === "SUCCESS") {
                
            	console.log('in ext details',response.getReturnValue());
                
                var responseData = response.getReturnValue();
                if(responseData){
                     var obligLst = new Array();
                    var exObj;
                    for(var i=0;i<responseData.length;i++){
                        exObj = new Object();
                        exObj = responseData[i];
                        if (exObj.EMI__c){
                            var num =parseFloat(exObj.EMI__c);
                            exObj.EMI__c = num.toFixed(2).toString();
                            console.log ('check decimal point='+exObj.EMI__c);
                        }
                        obligLst.push({"exObj":exObj,"deleteRecord":false,"startDate":exObj.Start_On__c});
                        
                    }
                    component.set("v.obligLst",obligLst);
                    console.log('obligLst-----'+obligLst);
                    
                }
                
            }
            
        });
        
        $A.enqueueAction(action);

    },
    // Added for Ext prod issue Rohit stop
})