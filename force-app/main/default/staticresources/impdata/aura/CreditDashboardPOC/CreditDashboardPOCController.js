({
    doInit: function(component, event, helper) {
        /*var oppId = component.get("v.oppId");
       // component.set('v.oppId',oppId);
        //oppId = "0065D000002tzzH";
        console.log('oppId>>' + oppId);
        if (!$A.util.isEmpty(oppId)) {
            helper.showhidespinner(component,event,true);
            helper.getoppDetails(component, event);
            helper.fetchpicklistdata(component,event,'');
        }*/
		 /* CR 22307 s */
        var stage = component.get("v.stageName");
        console.log('stage is'+stage);
        if(stage == 'Underwriting' || component.get("v.loan.Consider_for_Re_Appraisal__c") == true || stage == 'Approved' || stage == 'Re-Appraise- Loan amount' || stage == 'Re-Appraise- IRR' || stage == 'Re-Appraise- Reject Case' || stage == 'Re-Appraise- Tenor')
        {
         component.set("v.displayReadOnly",false);
        } 
        else{
        component.set("v.displayReadOnly",true);
        }
       /* CR 22307 e */
        
        // Bug 23064 start
       if(stage == 'Underwriting' && component.get("v.salesprofilecheck") == true)
            {
            component.set("v.displayReadOnly",true);
             
            } 
        // Bug 23064 stop
        
    }, 
    setDisplay : function(component, event, helper){
        component.set("v.homeFlag", event.getParam("display"));
        console.log('firing event');
        
        var oppId = component.get("v.oppId");
        if (!$A.util.isEmpty(oppId)) {
            //helper.showhidespinner(component,event,true);// US 13724 
            helper.getoppDetails(component, event);
            helper.fetchpicklistdata(component,event,'');
        }
    },
    setParentAttributVar : function(component, event, helper){
        if (!$A.util.isEmpty(event.getParam("SecName"))) {    
            if(event.getParam("SecName") == "dedupe")
                component.set("v.dedupeList", event.getParam("dedupeList"));
            else if(event.getParam("SecName") == "pan"){
                component.set("v.panDetailsList", event.getParam("panDetailsList"));
                component.set("v.panDashboardData", event.getParam("panDashboardData"));
            }
                
            else if(event.getParam("SecName") == "verify"){
                    if (!$A.util.isEmpty(event.getParam("bankverification")))
                        component.set("v.bankverification", event.getParam("bankverification"));
                    if (!$A.util.isEmpty(event.getParam("officeverification")))
                        component.set("v.officeverification", event.getParam("officeverification"));
                    if (!$A.util.isEmpty(event.getParam("resPerverification")))
                        component.set("v.resPerverification", event.getParam("resPerverification"));
                    if (!$A.util.isEmpty(event.getParam("resCurverification"))) 
                        component.set("v.resCurverification", event.getParam("resCurverification"));
                	if (!$A.util.isEmpty(event.getParam("bankVerifyDone")))
                        component.set("v.bankVerifyDone", event.getParam("bankVerifyDone"));
                  if (!$A.util.isEmpty(event.getParam("verStatus")))
                        component.set("v.verComplete", event.getParam("verStatus"));
             }
             else if(event.getParam("SecName") == "telepd"){
                 component.set("v.pdObj", event.getParam("pdObj"));
                 component.set("v.pddone", event.getParam("pddone"));
                 component.set("v.telepdstatusdashboard", event.getParam("telepdstatusdashboard"));
                 component.set("v.quesdetailslist", event.getParam("quesdetailslist")); 
              } 
              else if(event.getParam("SecName") == "eligibility"){ 
                 component.set("v.camObj", event.getParam("camObj"));
              }
            else if(event.getParam("SecName") == "sanction"){ 
                 component.set("v.sanctionList", event.getParam("discrepancyList"));
                 var sanctionList = component.get("v.sanctionList");
             if(!$A.util.isEmpty(sanctionList)){
              for(var i=0 ; i< sanctionList.length ; i++){
                if(!$A.util.isEmpty(sanctionList[i].Status__c) && (sanctionList[i].Status__c == 'Pending' || sanctionList[i].Status__c == 'Re-opened')) {
                    component.set("v.SanctionFinalOutput",'Not done');
                     console.log('inside sanctionn if pk'+component.get("v.SanctionFinalOutput")+sanctionList[i].Status__c);
                    break;
                }
                else if(sanctionList[i].Status__c !== 'Pending' || sanctionList[i].Status__c !== 'Re-opened'){
                    component.set("v.SanctionFinalOutput",'Done');
                    console.log('inside sanctionn pk else'+component.get("v.SanctionFinalOutput")+sanctionList[i].Status__c);
                   
                }
               }
                
              }
            }
            else if(event.getParam("SecName") == "BankSummary"){ 
              	component.set("v.bankObj", event.getParam("bankObj"));
              }
            
            
        } 
    },
    /* navigateToSearch : function(component, event, helper) {
        component.set("v.homeFlag",false);
        $A.createComponent(
            /* "c:PANCheckCmp",{ "secName" : 'PANCheck',
                                 "OppID" : "0060k000006WBr9"},
                "c:CreditDashboard",{ "oppId" : "0060k000006WBr9"},
                function(newComponent){
                    component.set("v.body",newComponent);
                }
            )
    },*/
    navigateToPAN : function(component, event, helper) {
      //  component.set("v.homeFlag",false);
        $A.createComponent(
            "c:NSDL_PAN_Check",
            {
             /*   "panDetailsList" : component.get("v.panDetailsList"),
                "displayPANSave" : component.get("v.displayPANSave"), 
                "OppID"  : component.get("v.oppId"), 
                "secName" :"PANCheck", 
                "panDashboardData" : component.get("v.panDashboardData")*/
                 LoanId : component.get("v.oppId"),
                 productName : component.get("v.loan.Product__c"),
                  isMobilityFlag:true  ,
                stageName : component.get("v.stageName"), /* CR 22307 */
                salesprofilecheck :component.get("v.salesprofilecheck"), //Bug 23064
            },
            function(newComponent){
                component.set("v.body",newComponent);
            }
        );
    },
    
    navigateToMCP : function(component, event, helper) {
        component.set("v.homeFlag",false);
        $A.createComponent(
            "c:MCPCreditDashboard1",
            {
                "agesolpolicy" : component.get("v.agesolpolicy"),
                "salsolpolicy" : component.get("v.salsolpolicy"), 
                "expsolpolicy" : component.get("v.expsolpolicy"),
                "oppId"  : component.get("v.oppId"), 
                "secName" :"MCPCheck", 
                "account" : component.get("v.account"),
                "age" : component.get("v.age"),
                "netsalary" : component.get("v.netsalary"),
                "appType":component.get("v.appType") //24668 added appType
            },
            function(newComponent){
                component.set("v.body",newComponent);
            }
        );
    },
    navigateToDedupe : function(component, event, helper) {
        component.set("v.homeFlag",false);
        $A.createComponent(
            "c:DedupeCreditDashboard1",
            {
                "dedupeDashboardData" : component.get("v.dedupeDashboardData"),
                "dedupeList" : component.get("v.dedupeList"), 
                "customerList" : component.get("v.customerList"),
                "loan" : component.get("v.loan"),
                "oppId"  : component.get("v.oppId"), 
                "displayreferral" : component.get("v.displayreferral"),
                "isCommunityUsr" : component.get("v.isCommunityUsr"),
                "theme" : component.get("v.theme"),
                "stageName" : component.get("v.stageName"), /* CR 22307 */
                "salesprofilecheck" :component.get("v.salesprofilecheck"), //Bug 23064
            },
            
            function(newComponent){
                component.set("v.body",newComponent);
            }
        );
    },
    navigateToCibil : function(component, event, helper) {
        component.set("v.homeFlag",false);
        $A.createComponent(
            "c:CibilCreditDashboard1",
            {
                "cibilTemp" : component.get("v.cibilTemp"),
                "cibilExt1" : component.get("v.cibilExt1"), 
                "cibil" : component.get("v.cibil"),
                "secondaryCibilRecs" : component.get("v.secondaryCibilRecs"),
                "applicantObj" : component.get("v.applicantObj"),
                "oppId"  : component.get("v.oppId"), 
                "cibilDashboardData" : component.get("v.cibilDashboardData"),
                "isCommunityUsr" : component.get("v.isCommunityUsr"),
                "theme" : component.get("v.theme"),
                "stageName" : component.get("v.stageName"), /* CR 22307 */
                "salesprofilecheck" :component.get("v.salesprofilecheck"), //Bug 23064
                "sourCateg":component.get("v.sourCateg"), //Bug 23820 22018
            },
            function(newComponent){
                component.set("v.body",newComponent);
            }
        );
    }, 
    navigateToEmp : function(component, event, helper) {
        component.set("v.homeFlag",false);
        
        $A.createComponent(
            "c:EmploymentCreditDashboard1",
            {
                "contentId" : component.get("v.contentId"),
                "empCheckDashboardData" : component.get("v.empCheckDashboardData"), 
                "conObj" : component.get("v.conObj"),
                "accObj" : component.get("v.account"),
                "applicantObj" : component.get("v.applicantObj"),
                "oppId"  : component.get("v.oppId"), 
                "officeverification" : component.get("v.officeverification"),
                "isCommunityUsr" : component.get("v.isCommunityUsr"),
                "theme" : component.get("v.theme"),
                "appType":component.get("v.appType") //24668 added appType
            },
            function(newComponent){
                
                component.set("v.body",newComponent);
            }
        )
    }, 
    navigateToBank : function(component, event, helper) {
        component.set("v.homeFlag",false);
        $A.createComponent(
            "c:BankingCreditDashboard1",
            {
                "bankObj" : component.get("v.bankObj"),
                "bankVerifyDone" : component.get("v.bankVerifyDone"), 
                "conObj" : component.get("v.conObj"),
                "camObj" : component.get("v.camObj"),
                "oppId"  : component.get("v.oppId"),
                 "accObj" : component.get("v.account"),
                "isCommunityUsr" : component.get("v.isCommunityUsr"),
                "theme" : component.get("v.theme"),
                "bankCheckDashboardData" : component.get("v.bankCheckDashboardData"),
                "disbObj":component.get("v.disbObj"),//24315
                "repayObj":component.get("v.repayObj") //24315
                
            },
            function(newComponent){
                component.set("v.body",newComponent);
            }
        )
    }, 
    navigateToVerification : function(component, event, helper) {
        component.set("v.homeFlag",false);
        $A.createComponent(
            "c:VerificationsCreditDashboard1",
            {
                "bankObj" : component.get("v.bankObj"),
                "bankVerifyDone" : component.get("v.bankVerifyDone"), 
                "bankVerObj" : component.get("v.bankverification"),
                "OfcVerObj" : component.get("v.officeverification"),
                "resPerVerObj" : component.get("v.resPerverification"),
                "resCurVerObj" : component.get("v.resCurverification"), 
                "poObj" : component.get("v.poObj"),
                "verifyList" : component.get("v.verifyList"),
                "eKycObj" : component.get("v.eKycObj"),
                "eKycAddress" : component.get("v.eKycAddress"), 
                "accObj" : component.get("v.account"),
                "negativeAreaVal" : component.get("v.negativeAreaVal"),
                "oppId"  : component.get("v.oppId"), 
                "isCommunityUsr" : component.get("v.isCommunityUsr"),
                "theme" : component.get("v.theme"),
                "verComplete":component.get("v.verComplete") ,
                "negativeAreastatus":component.get("v.negativeAreastatus") ,
                "bankCheckDashboardData" : component.get("v.bankCheckDashboardData"),
                "stageName" : component.get("v.stageName"), /* CR 22307 */
                "salesprofilecheck" :component.get("v.salesprofilecheck"), //Bug 23064
				"showDGComp" : component.get("v.showDGComp"),//bug 24316,
                "appType":component.get("v.appType") //24668
            },
            function(newComponent){
                component.set("v.body",newComponent);
            }
        )
    }, 
    navigateToPD : function(component, event, helper) {
        component.set("v.homeFlag",false);
        $A.createComponent(
            "c:TelePDCreditDashboard1",
            {
                "quesdetailslist" : component.get("v.quesdetailslist"),
                "telepdstatusdashboard" : component.get("v.telepdstatusdashboard"), 
                "pdObj" : component.get("v.pdObj"),
                "pddone" : component.get("v.pddone"),
                "oppId"  : component.get("v.oppId"), 
                "appId" : component.get("v.applicantObj.id"),
                "stageName" : component.get("v.stageName"), /* CR 22307 */
                "salesprofilecheck" :component.get("v.salesprofilecheck"), //Bug 23064
            },
            function(newComponent){
                component.set("v.body",newComponent);
            }
        )
    },
    navigateToDocumentsPreview : function(component, event, helper) {
        component.set("v.homeFlag",false);
        $A.createComponent(
            "c:SAL_UWDocuments",
            {
                "parentId" : component.get("v.applicantObj.Id"),
                
            },
            function(newComponent){
                component.set("v.body",newComponent);
            }
        )
    },
    navigateToEligibility : function(component, event, helper) {
        component.set("v.homeFlag",false)
        //22017 start
        var  ishybridflexi; 
       if(!$A.util.isEmpty(component.get("v.loan").Scheme_Master__r))
         	ishybridflexi =component.get("v.loan").Scheme_Master__r.IsHybridFlexi__c;
        else
            ishybridflexi =false;
         //22017 end
        $A.createComponent(
            "c:EligibilityScreen1",
            {
                "oppId"  : component.get("v.oppId"), 
                "secName" :"eligibility", 
                "camObj" : component.get("v.camObj"), 
                "accObj" : component.get("v.account"), 
                "appObj" : component.get("v.applicantObj"),
                "downSizeList" : component.get("v.downSizeList"),
                "srcamObj":component.get("v.srcamObj"),
                "isHybirdFlexi":ishybridflexi,//22017
                "loan": component.get("v.loan"),
                "stageName" : component.get("v.stageName"), /* CR 22307 */
                "salesprofilecheck" :component.get("v.salesprofilecheck"), //Bug 23064
                "final_foir": component.get("v.final_foir") /* Bug 23715 */
            },
            function(newComponent){
                component.set("v.body",newComponent);
            }
        );
        
    }, 
    navigateToSanction : function(component, event, helper) {
        component.set("v.homeFlag",false);
        $A.createComponent(
            "c:sanctionConditionDashboard1",
            {
                "SanctionFinalOutput" : component.get("v.SanctionFinalOutput"),
                "oppId"  : component.get("v.oppId"), 
                "discrepancyList" : component.get("v.sanctionList"),
                "existingDisList" : component.get("v.existingDisList"),
                "Status__c" : component.get("v.Status__c"),
                "stageName" : component.get("v.stageName"),/* CR 22307 */
                "loan" : component.get("v.loan"), /* CR 22307 */
                "salesprofilecheck" :component.get("v.salesprofilecheck"), //Bug 23064
            },
            function(newComponent){
                component.set("v.body",newComponent);
            }
        )
    },
     navigateToFinalApproval : function(component, event, helper) {
        component.set("v.homeFlag",false);
         console.log('pk hold reason'+component.get("v.HoldOption"));
        $A.createComponent(
            "c:SAL_OppDocument",
            {
                "oppId"  : component.get("v.oppId"),
                "profileName" : component.get("v.profileName"),
                "creditofficerList" : component.get("v.creditofficerList"),
                "isdisablePricingbutton" : component.get("v.isdisablePricingbutton"),
                "isUnderwitercmp" : true,
                "iscommunityUser" : component.get("v.iscommunityUser"),
                "camObj" : component.get("v.camObj"),
                "isdiablebutton" : component.get("v.isdiablebutton"),
                "rejectOption" : component.get("v.rejectOption"),
                "rejectOption1" : component.get("v.rejectOption1"),
				"sendbackoption": component.get("v.sendbackoption"), //Added for user story 985
                "HoldOption" :  component.get("v.HoldOption"),
                "nameTheme" : component.get("v.nameTheme"),
                "Accobj" : component.get("v.account"),
                "Conobj" : component.get("v.conObj"),  //changed conobj to Conobj as there is no conobj attribute in SAL_OppDocument
                "primaryApp" : component.get("v.applicantObj"), 
                "Oppobj" : component.get("v.loan"),
                "isdiablesendback" : component.get("v.isdiablesendback"),
				"stageName" : component.get("v.stageName"), /* CR 22307 */
				"salesprofilecheck" :component.get("v.salesprofilecheck"), //Bug 23064
				"rules" : component.get("v.rules"),//11806
                "obligLst" : component.get("v.obligLst"),
				"pdObj" : component.get("v.pdObj"),                
            },
            function(newComponent,status,error){
                console.log('status is'+status+error);
                component.set("v.body",newComponent);

            }
        )
    },
    /*navigateToPANPOC : function(component, event, helper) {
       component.set("v.homeFlag",false);
        $A.createComponent(
            "c:NSDL_PAN_CheckPOC",
            {
             /*   "panDetailsList" : component.get("v.panDetailsList"),
                "displayPANSave" : component.get("v.displayPANSave"), 
                "OppID"  : component.get("v.oppId"), 
                "secName" :"PANCheck", 
                "panDashboardData" : component.get("v.panDashboardData")*/
              /* LoanId : component.get("v.oppId"),
                 productName : component.get("v.loan.Product__c"),
                isMobilityFlag:true,
                nameTheme : component.get("v.nameTheme")
            },
            function(newComponent){
                component.set("v.body",newComponent);
                console.log('component created');
            }
        );
    },*/
    /*20939 RCU s*/
    navigateToDemographicsChange : function(component, event, helper) {
        
        
        component.set("v.homeFlag",false);
        $A.createComponent(
            "c:CriticalDemographicsDashboard",
            {
                "LoanObj" : component.get("v.loan"),
                "DemogAction"  : component.get("v.DemogAction"), 
                "DemogChange" : component.get("v.DemogChange"),
                "appObj" : component.get("v.applicantObj"),
                "bankObj" : component.get("v.bankObj"),//Bug 20939 RCU
                "dedupeList" : component.get("v.dedupeList"), //Bug 20939 RCU
                "camObj" : component.get("v.camObj"),
                "stageName" : component.get("v.stageName"), /* CR 22307 */
				"salesprofilecheck" :component.get("v.salesprofilecheck"), //Bug 23064 
                "profileName": component.get("v.profileName")
            },
            function(newComponent){
                component.set("v.body",newComponent);
            }	
            
        )               
        
    }
    /*20939 RCU e*/
    /*7689*/
    ,    navigateToUnderwriterView : function(component, event, helper) {
        component.set("v.homeFlag",false);
        var deDupeObj = new Object();
        if(component.get("v.dedupeList"))
            deDupeObj = component.get("v.dedupeList")[0];
        
        console.log('dedpue '+deDupeObj);
        $A.createComponent(
            "c:UnderwriterView",
            {
                "oppId"  : component.get("v.oppId"),
                "cibilTemp" : component.get("v.cibilTemp"),
                "isUnderwitercmp" : true, 
                "camObj" : component.get("v.camObj"),
                "Accobj" : component.get("v.account"),
                "conObj" : component.get("v.conObj"),
                "primaryApp" : component.get("v.applicantObj"), 
                "Oppobj" : component.get("v.loan"),
                "bankObj" : component.get("v.bankObj"),
                "dedupeObj" : component.get("v.dedupeObj"),
                "sanctionList":component.get("v.sanctionList")
            },
            function(newComponent){
                component.set("v.body",newComponent);
            }
        )
    }, /*7689*/
    //24668 start
    onAppChange : function(component, event, helper){
        var oppId = component.get("v.oppId");
        if (!$A.util.isEmpty(oppId)) {
            helper.showhidespinner(component,event,true);
            helper.getoppDetails(component, event);
            helper.fetchpicklistdata(component,event,'');
        }
    },
     //24668 stop
})