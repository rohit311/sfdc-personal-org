({
    getCardData : function(component,event) {
		 //23578 start 24716
        var ckycFlow = new Object();
        /*ckycFlow["flowtype"] = "Salaried";
        ckycFlow["object"] = "Opportunity";
        component.set("v.ckycFlow",ckycFlow);
        var currDate = new Date();
        var month = 0;
        month = currDate.getMonth()+1;
        component.set("v.currentDate",currDate.getFullYear()+'-'+month+'-'+currDate.getDate());*/
        ckycFlow["flowtype"] = "detail";
        ckycFlow["object"] = "Opportunity";
        ckycFlow["resource"] = "Opportunity_CkycConfig"; // newly added 
        component.set("v.ckycFlow",ckycFlow);
        //23578 stop 24716
        console.log('in helper of SAL_SalesCmp');
        var action = component.get("c.getCardData");
        var contSelectList = ["Marital_Status__c","Father_Spouse__c","Occupation_CKYC__c","Residence_Type__c","Father_Spouse_Salutation__c","Occupation_CKYC__c"];
        var appSelectList = ["Proof_of_Identity__c","Proof_of_Address_Submitted_for_Permanent__c"];
        var accSelectList = ["Gender__c","Preferred_language__c"];//24675 added Preferred_language__c    
        var ExisLoanSelectList=["Type_of_Oblig__c","Status__c","financers__c","Loan_Type__c"];//US 983
        var OppSelectList=["Loan_Variant__c"];//US 1652
        var selectListNameMap = {};
        selectListNameMap["Applicant__c"] = appSelectList;
        selectListNameMap["Contact"] = contSelectList;
        selectListNameMap["Account"] = accSelectList;
        selectListNameMap["Existing_Loan_Details__c"] = ExisLoanSelectList;//US 983 rohit
        selectListNameMap["Opportunity"] = OppSelectList;//US 1652 
        action.setParams({"oppId": component.get("v.recordId"), "objectFieldJSON" : JSON.stringify(selectListNameMap)});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var responseStr = JSON.parse(response.getReturnValue());
                 //24668 start
                if(responseStr.finAppl){
                	component.set("v.finAppl",responseStr.finAppl);
                    var appTypeLst = component.get("v.appTypeLst");
                    appTypeLst.push("Financial Co-Applicant");
                     component.set("v.appTypeLst",appTypeLst);
                     component.set("v.finApplCon",responseStr.objConFin);
                }
                //24668 stop
                /*City CR s*/
				//US 983 rohit start
                if(responseStr.allApps){
                    
                    var allApps = responseStr.allApps;
                    allApps.push(responseStr.applicantPrimary);
                    console.log('here is all apps '+JSON.stringify(allApps));
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
                // Added for Ext prod issue Rohit start
                if(responseStr.fetchExtSeperate === false){  
                    if(responseStr.opp && responseStr.opp.Existing_Loan_Details__r && responseStr.opp.Existing_Loan_Details__r.records){
                        var obligLst = new Array();
                        var exObj;
                        for(var i=0;i<responseStr.opp.Existing_Loan_Details__r.records.length;i++){
                            exObj = new Object();
                            exObj = responseStr.opp.Existing_Loan_Details__r.records[i];
                            console.log ('identifier value='+exObj.Identifier__c);
                            obligLst.push({"exObj":exObj,"deleteRecord":false,"startDate":exObj.Start_On__c});
                            
                        }
                        component.set("v.obligLst",obligLst);
                        console.log('obligLst-----'+obligLst);
                        console.log(responseStr.opp.Existing_Loan_Details__r);
                    
                        
    
                    }
                }
                 
                if(responseStr.fetchExtSeperate === true){
                	this.fetchExtDet(component,event);
                }
                // Added for Ext prod issue Rohit stop
                //US 983 rohit stop                
                var cityList = responseStr.cityList;
                var finalCityList = [];
                for(var key in cityList){
                    var stateMap = cityList[key];
                    var state = stateMap['state'];
                    finalCityList.push({city : key,state : state});
                }
                component.set("v.cityList",finalCityList);
                /*City CR e*/
                console.log('.inside success.'+responseStr.picklistData["Applicant__c"]["Proof_of_Identity__c"]);
                //console.log('...inside success...'+responseStr.accObj.Area_Locality__r.Name);
                var picklistFields = responseStr.picklistData;
                var appPickFields = picklistFields["Applicant__c"];
                var conPickFields = picklistFields["Contact"];
                var accPickFlds = picklistFields["Account"];
                var oppFields= picklistFields["Opportunity"]; //US 1652
                //US 983 rohit start
                var exiLoanPickFlds = picklistFields["Existing_Loan_Details__c"];
                component.set("v.oblType", exiLoanPickFlds["Type_of_Oblig__c"]);
                component.set("v.statusLst", exiLoanPickFlds["Status__c"]);
                component.set("v.finLst", exiLoanPickFlds["financers__c"]);
                component.set("v.loanTypeLst", exiLoanPickFlds["Loan_Type__c"]);
                //US 983 rohit stop                
                component.set("v.maritalStatusList", conPickFields["Marital_Status__c"]);
                component.set("v.fatherSpouseList", conPickFields["Father_Spouse__c"]);
                component.set("v.F_S_salutationlist", conPickFields["Father_Spouse_Salutation__c"]);
                component.set("v.employmentTypeList", conPickFields["Occupation_CKYC__c"]);
                component.set("v.residenceTypeList", conPickFields["Residence_Type__c"]);
                component.set("v.OccupationList", conPickFields["Occupation_CKYC__c"]);
                component.set("v.documentTypeList", appPickFields["Proof_of_Identity__c"]);
                component.set("v.permDocumentList", appPickFields["Proof_of_Address_Submitted_for_Permanent__c"]);
                                component.set("v.loanVariantList", oppFields["Loan_Variant__c"]);//US 1652
                component.set("v.genderList", accPickFlds["Gender__c"]);
				component.set("v.preLangList", accPickFlds["Preferred_language__c"]);//24675
                console.log('theme isCommunityUsr'+responseStr.isCommunityUsr);
                component.set("v.theme", responseStr.theme);
                if (!$A.util.isEmpty(responseStr.isCommunityUsr))
                    component.set('v.iscommunityUser', responseStr.isCommunityUsr);
                if(responseStr.poobj!=null)
                {
                if(!$A.util.isEmpty(responseStr.poobj.Customer_ID1__r))
                {
                                    component.set("v.custId",responseStr.poobj.Customer_ID1__r.Id);

                }
                }
                else{ component.set("v.custId",'') }
                console.log('dsaUserprofile'+responseStr.myProflieName);
                component.set("v.dsaUser", responseStr.dsaUser);
                component.set("v.profileName", responseStr.myProflieName);
                component.set("v.oppObj", responseStr.opp);
                if(!$A.util.isEmpty(responseStr.secondarycibilList)) //10647
                {
                    component.set("v.secondaryCibilRecs", responseStr.secondarycibilList);   
                } 
                console.log('LAN no.'+responseStr.opp.Loan_Application_Number__c);
                /*24673 s*/
                var loginUser = responseStr.loginuser;
                if(!$A.util.isEmpty(loginUser) && !$A.util.isEmpty(loginUser.Product__c) && loginUser.Product__c.includes('RDPL')){
                    console.log('rdpl '+loginUser.Product__c.includes('RDPL'));
                    component.set("v.oppObj.Product__c", 'RDPL');  
                    var productList = component.get("v.productList");
                    productList.push('RDPL');
                    component.set("v.productList",productList);
                }
                
                console.log('loginuser products'+loginUser.Id);
                /*24673 e*/
                //added for bug 23577 Start
                if(component.get('v.fromcloneflag') == true && !$A.util.isEmpty(responseStr.opp) && !$A.util.isEmpty(responseStr.opp.StageName)){
                    
                      component.set("v.oppObj.StageName", '');
                }
                //added for bug 23577 Stop
                component.set("v.cibDetails",responseStr.cibDetails);//Bug 22624
                /* CR 22307 s*/
                if(!$A.util.isEmpty(responseStr.opp) && !$A.util.isEmpty(responseStr.opp.StageName))
                component.set("v.stageName", responseStr.opp.StageName); /* CR 22307 e*/
				//console.log('accountsendback'+responseStr.accObj.Send_Back_Reason__c);
                // user story 985 s
                if(responseStr.accObj && responseStr.accObj.Send_Back_Reason__c){
                    if(responseStr.accObj.Send_Back_Reason__c.includes(";"))
                   	component.set("v.Sendbacklist",responseStr.accObj.Send_Back_Reason__c.split(";"));
                  else
                     component.set("v.Sendbacklist",responseStr.accObj.Send_Back_Reason__c); 
                }
                // user story 985 e
                component.set("v.accObj", responseStr.accObj);
               // console.log('accountid'+responseStr.accObj.Id);
                component.set("v.priAppObj", responseStr.applicantPrimary);
				//23578 start
                 if(component.get("v.priAppObj") && component.get("v.priAppObj").Data_Source__c && (component.get("v.priAppObj").Data_Source__c == 'CKYC Search' || component.get("v.priAppObj").Data_Source__c == 'Copy CKYC Data' || component.get("v.priAppObj").Data_Source__c == 'Edit CKYC Data')){
                    if(component.get("v.priAppObj").Data_Source__c != 'CKYC Search')
                    	component.set("v.isCkycReadOnly",true);
                    component.set("v.dataSource",component.get("v.priAppObj").Data_Source__c);
                    if(component.get("v.priAppObj").Data_Source__c == 'Copy CKYC Data'){
                        
                        //var lanPg = component.find("landPg");
        				//lanPg.setCKYCfieldsParent();
                    }
                }
                //23578 stop
                console.log(responseStr.applicantPrimary);
                console.log(JSON.stringify(component.get("v.priAppObj")));
                component.set("v.priConObj", responseStr.objCon);
                component.set("v.bankAccount", responseStr.bankObj);//bankaccount partial CR
                console.log('responseStr.bankObj:: '+JSON.stringify( responseStr.bankObj));
                 if (!$A.util.isEmpty(responseStr.objCon)) {
                        var officeResiAdd = '';
                        if(responseStr.objCon.Address_Line_One__c != null)
                            officeResiAdd = officeResiAdd + responseStr.objCon.Address_Line_One__c;
                        if(responseStr.objCon.Address_2nd_Line__c != null)
                            officeResiAdd = officeResiAdd + ' ' + responseStr.objCon.Address_2nd_Line__c;
                        if(responseStr.objCon.Address_3rd_Line__c != null)
                            officeResiAdd = officeResiAdd + ' ' + responseStr.objCon.Address_3rd_Line__c;
                        component.set("v.officeAddress",officeResiAdd);
                        
                    } 
                //console.log('tatMasterRecord'+responseStr.tatMasterRecord.PAN_Number__c);
                if(!$A.util.isEmpty(responseStr.tatMasterRecord))
                    component.set("v.tatMasterRecord", responseStr.tatMasterRecord);   
                 component.set("v.TatTime", responseStr.TatTime);
                if(!$A.util.isEmpty(responseStr.cibilExt1))
                {
                    component.set("v.cibilExt1", responseStr.cibilExt1);   
                }
                if(!$A.util.isEmpty(responseStr.cibilExt))
                {
                    component.set("v.cibilExt", responseStr.cibilExt1);   
                }
                if(!$A.util.isEmpty(responseStr.cibilobj))
                {
                    component.set("v.cibilobj", responseStr.cibilobj);   
                }
                if(!$A.util.isEmpty(responseStr.cibilTempobj))
                {
                    component.set("v.cibilTemp", responseStr.cibilTempobj);   
                }
                 if(!$A.util.isEmpty(responseStr.camObj)) //1652
                {
                			component.set("v.camObj",responseStr.camObj);
                }
                
                component.set("v.isPreapproved" ,responseStr.isPreapproved);
                console.log('theme-->'+component.get("v.isPreapproved"));
                //Rohit submit to sales start
                if(responseStr.isPLTB == false && responseStr.isTeleCaller == true){
                    component.set("v.isSalesVisible" ,true);
                }    
                else{
                    component.set("v.isSalesVisible" ,false);
                }
                if(responseStr.ekycobj != null && responseStr.ekycobj != undefined){
                    component.set("v.kyc",responseStr.ekycobj);
                    component.set("v.isEkycDone",true);
                    console.log('in ekyc parent '+response.ekycobj);
                }    
                //Hrushikesh added SalesRejectStatus Flag Logic
                    if(responseStr.opp.StageName=='Sales Reject')
                    {
                       component.set("v.salesRejectStage",false);
                    }
                //Rohit submit to sales stop
                if(component.get("v.theme") == 'Theme4d')
                {
                    var cmpTarget = component.find('boxBorder');
                    $A.util.addClass(cmpTarget, 'slds-box slds-box_x-small');
                    
                }
                var oppStage = responseStr.opp.StageName;
                if(oppStage != null)
                {
                    if(oppStage == 'DSA/PSF Login')
                    {
                        component.set("v.stageCompletion","20%") ;
                    }
                    else if(oppStage == 'Underwriting')
                    {
                        component.set("v.stageCompletion","40%");
                    }
                        else if(oppStage == 'Post Approval Sales')
                        {
                            component.set("v.stageCompletion","60%");
                        }
                            else if(oppStage == 'Branch Ops')
                            {
                                component.set("v.stageCompletion","80%");
                            }
                                else if(oppStage == 'Moved To Finnone')
                                {
                                    component.set("v.stageCompletion","100%");
                                    $A.util.addClass(component.find("progressSpan"),"slds-progress-bar__value_success");
                                }    
                }
                else{
                    component.set("v.stageCompletion","0%");
                }
                
                if(responseStr.msgStatus != 'NO_ERROR' && $A.util.isEmpty(responseStr.opp))
                    component.set("v.cmpLoadMsg", responseStr.msgStatus);
                if(responseStr.opp.Product__c != 'SAL' && responseStr.opp.Product__c != 'SPL' && $A.util.isEmpty(responseStr.opp))
                    component.set("v.cmpLoadMsg", 'This action is not applicable for given product.');
                   
            }
            component.set("v.openTab",true);
            //US21328s
                     //var landPg = component.find("landPg");
                     //landPg.toggleTab();//US21328e
            this.showhidespinner(component,event,false);
        });
        $A.enqueueAction(action);  
    },
    
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
    showToast: function(component, title, message, type){
      
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({ 
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "30000"
            });    
            toastEvent.fire();
        } else {
            var toastTheme = component.find("toastTheme");
            $A.util.removeClass(toastTheme, "slds-theme--error");
            $A.util.removeClass(toastTheme, "slds-theme--success");
            if(type == 'error'){
                $A.util.addClass(toastTheme, "slds-theme--error");
            } else if(type == 'success'){
                $A.util.addClass(toastTheme, "slds-theme--success");
            }
            component.find("toastText").set("v.value", message);
            component.find("toastTtitle").set("v.value", title+' ');
            this.showHideDiv(component, "customToast", true);
        }
    },
      /*Bug 18669 Start*/
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
     getEKYCRec : function(component,randomNum,PrimaryApp){
        console.log('randomNum inside getEKYCRec  sales comp helper '+randomNum);
        this.executeApex(component, "getEkycRec", {ranNum: randomNum}, function(error, result){
            console.log('inside execute apex');
            if(!error && result){
                console.log('in method salescomp>>>'+ result);
                var data = result;
                console.log('data salescomp>>'+JSON.stringify(data));
                
                console.log('data.bio_Ekyc__c in salescomp: '+data.bio_Ekyc__c);
				if(data.bio_Ekyc__c == true){
                    console.log('inside biometric field conditionSalesComp');
					component.set("v.kyc",data);
                   var appEvent = $A.get("e.c:InitiateKYCForm");
                        if(appEvent){
                            console.log('inside appeventsalescomp::');
                            appEvent.setParams({ "kyc" : data});
                            appEvent.fire();
                        }
				}
                console.log('ssm inside helper app id'+PrimaryApp.Id);
                 console.log('ssm inside helper kyc id'+component.get('v.kyc').Id);
                console.log('ssm inside helper kyc app id'+component.get('v.kyc.Applicant__c'));
                 if(component.get('v.kyc') != null || !$A.util.isEmpty(component.get('v.kyc'))) {
                     console.log('inside after event::'+component.get('v.kyc.Applicant__c'));
                  if(component.get('v.kyc.Applicant__c') != null){
                       console.log('inside after event if::'+PrimaryApp);
                      var app = PrimaryApp;
                      app.eKYC_Processing__c = true;
                      console.log('inside app after event::'+JSON.stringify(app));
                     component.set('v.priAppObj',app);
                      console.log('inside app after event priAppObj::'+ JSON.stringify(component.get('v.priAppObj')));
                   }
               }
            }
        });
    },
    /*Bug 18669 End*/
      fetchEkycDetailsHelper : function(component,event,PrimaryApp) {
         console.log('in fetch aadhar sales comp::'+component.get('v.kyc'));
           console.log('in fetch aadhar sales comp random number::'+component.get('v.randomNum'));
         console.log('aadharValueDss is : '+component.get('v.aadharValueDss'));
          if((component.get('v.kyc') !=  undefined)||(component.get('v.kyc') !=  'undefined')||$A.util.isEmpty(component.get('v.kyc').Id == false)){
            // console.log('in fetch aadhar sales comp ekyc photo::'+component.get('v.kyc').eKYC_Photo__c);
      	}
         // console.log('kyc is in sales comp tab active is::'+$A.util.isEmpty(component.get('v.kyc').Id));
          if($A.util.isEmpty(component.get('v.kyc'))||(component.get('v.kyc') ==  undefined)||$A.util.isEmpty(component.get('v.kyc').Id)){
        if(component.get('v.aadharValueDss') == 'Biometric'){
            console.log('in if');
          this.getEKYCRec(component,component.get("v.randomNum"),PrimaryApp);
           
        }
        }
       /* Bug 18669 End*/
        
    },
    /*SAL 2.0 CR's s*/
    getDataOnReinitiation : function(component, event){
        
        console.log('in fire reini'+component.get("v.cibilReinitiated"));
        if(component.get("v.cibilReinitiated")){
        	this.getCardData(component,event);
            this.showhidespinner(component,event,true);
        }
        
    },
    /*SAL 2.0 CR's e*/
    // Added for Ext prod issue Rohit start
    fetchExtDet : function(component,event){
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
                        console.log ('identifier value='+exObj.Identifier__c);
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