({
	getCardData : function(component,event) {
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
            
        });
        
        $A.enqueueAction(action);  
	},
})