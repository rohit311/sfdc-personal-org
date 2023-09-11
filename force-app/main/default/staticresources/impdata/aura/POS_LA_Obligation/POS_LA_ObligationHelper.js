({
    FieldList : [],
    PicklistProp : [],
    IdList : [],
    LoanObject : [],
    ApplicantId : '',
    
    setFieldData : function(component) {
		this.FieldList = [];
        component.set("v.showDetailsComponent", false);
        this.IdList.splice(0,this.IdList.length);
        var loanObj;
        var loanAppId = component.get("v.loanAppID");        
         //US:31397 UserStory_Checks to be skipped for GCO start added Campaign_Code__c
        var queryString = "SELECT Id, Account.Date_of_Birth__c, StageName, Approved_Loan_Amount__c, Loan_Application_Number__c, Product__c,  "+
            				" Tenor__c, (SELECT Name,Campaign_Code__c, Contact_Customer_Type__c ,Id, Applicant_Type__c, ContactName__c, Contact_Name__c,  Contact_Name__r.Date_of_Birth__c "+
            				" FROM Loan_Application__r ), (SELECT Id FROM Existing_Loan_Details__r  WHERE Applicant__r.Applicant_Type__c = 'Primary' AND MOB__c >= 10 AND "+
            				" Status__c = 'Live' AND Loan_Type__c IN ('HL', 'HL – Improvement', 'HL – Top Up', 'LAP', 'Housing Loan', 'Property Loan') ORDER BY Loan_Amount__c DESC LIMIT 3) "+
            				" FROM Opportunity WHERE Id = \'"+ loanAppId +"'\ " ;
        
        var action = component.get("c.fetchObligationRecords");
        action.setParams({
            "queryString": queryString
        });
        action.setCallback(this, function(response){
        	var state = response.getState();
        	if (component.isValid() && state === "SUCCESS") {
                //console.log('inside success...'+JSON.stringify(response.getReturnValue()));
                loanObj = response.getReturnValue();
                if(loanObj.length > 0)
                {
                    this.LoanObject = loanObj[0];
                    //populate applicants picklist
                    var applicantList = loanObj[0].Loan_Application__r;
                    if(applicantList) {
                        for(var index = 0, len = applicantList.length; index < len; ++index) {
                            var applicant = applicantList[index];
                            if(applicant.Contact_Name__c &&  applicant.Contact_Customer_Type__c  !=null && applicant.Applicant_Type__c == 'Primary') {                    
                                var AppNameAndType = applicant.Id;
                                this.ApplicantId = applicant.Id;
                             /*   this.PicklistProp.push({
                                    label : AppNameAndType,
                                    value : AppNameAndType,
                                    selected : true,
                                    disabled : false
                                });
                             */
                            }
                        }
                    }
                    // Populate Id list
                    var InsuranceList = loanObj[0].Existing_Loan_Details__r;
                    console.log('----->>'+JSON.stringify(InsuranceList));
                    if(InsuranceList) {
                        for(var index = 0, len = InsuranceList.length; index < len; ++index) {                            
                            if(InsuranceList[index].Id) {
                                this.IdList.push(InsuranceList[index].Id.toString());
                            }
                        }
                    }
                    console.log('----->>'+JSON.stringify(this.IdList));
                }
        	}
            console.log();
            if(loanObj.length > 0)
            {
                this.populateFieldData(component);
               // this.handleSalMobFlowEventHelper(component);
               // set isReadOnly value on load
               if (loanObj.StageName == 'Post Approval Sales') {
                   component.set("v.isReadOnly", true);
                   this.triggerDisableFormEvent(component, loanObj.StageName);
               }
            }
    	});
        $A.enqueueAction(action);		
	},
    triggerDisableFormEvent: function(component, loanStage){
        var event = $A.get("e.c:DisableFormEvent");;
        event.setParams({"loanStage": loanStage});
        event.fire();
    },
    populateFieldData : function(component) {
        //populate FielList and IdList
        //console.log('inside populateFieldData......'+JSON.stringify(this.FieldList));
        
         this.FieldList.push({
                "FieldName" : "Loan_Type__c",
                "FieldLabel" : "Loan Type",
                "FieldRequired" : true,
                "FieldRequiredConditions" : null,
                "FieldVisibleInTable" : true,
                "FieldVisibleInModal" : true,
                "FieldValidation" : null,
                "FieldSequence" : 1,	
            });
        
        this.FieldList.push({
                "FieldName" : "Loan_Amount__c",
                "FieldLabel" : "Loan Amount",
                "FieldRequired" : true,
                "FieldVisibleInTable" : true,
                "FieldVisibleInModal" : true,
                "FieldValidation" : null,
                "FieldSequence" : 2,
            });
        
        	this.FieldList.push({
                "FieldName" : "Start_On__c",
                "FieldLabel" : "Start Date",
                "FieldRequired" : true,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : true,
                "FieldSequence" : 3
        	});
        
            this.FieldList.push({
                "FieldName" : "Status__c",
                "FieldLabel" : "Status",
                "FieldRequired" : true,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : true,
                "FieldValidation" : null,
                "FieldSequence" : 4
            });
        
        	this.FieldList.push({
                "FieldName" : "financers__c",
                "FieldLabel" : "Financer",
                "FieldRequired" : true,
                "FieldVisibleInTable" : true,
                "FieldVisibleInModal" : true,
                "FieldValidation" : null,
                "FieldSequence" : 5,
            });
        
        	this.FieldList.push({
                "FieldName" : "MOB__c",
                "FieldLabel" : "MOB",
                "FieldReadOnly" : true,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : true,
                "FieldValidation" : null,
                "FieldSequence" : 6
            });
        	
        	this.FieldList.push({
                "FieldName" : "Rate_of_Interest__c",
                "FieldLabel" : "ROI",
                "FieldRequired" : true,
                "FieldVisibleInTable" : true,
                "FieldVisibleInModal" : true,
                "FieldValidation" : null,
                "FieldSequence" : 7
            });
        
        	this.FieldList.push({
                "FieldName" : "Applicant__c",
                "FieldLabel" : "Applicant",
                "FieldRequired" : true,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : false,
                "FieldValue" : this.ApplicantId,
                "FieldSequence" : 8                
            });
        
        	this.FieldList.push({
                "FieldName" : "Loan_Application__c",
                "FieldLabel" : "Loan Application",
                "FieldRequired" : true,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : false,
                "FieldValidation" : null,
                "FieldSequence" : 9,
            	"FieldValue" : component.get("v.loanAppID")
            });
        
        this.FieldList.push({
                "FieldName" : "Obligation__c",
                "FieldLabel" : "Obligation",
                "FieldRequired" : true,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : false,
                "FieldValidation" : null,
                "FieldSequence" : 10,
            	"FieldValue" : 'Yes'
            });
        
        this.FieldList.push({
                "FieldName" : "Type_of_Oblig__c",
                "FieldLabel" : "Type of Obligation",
                "FieldRequired" : true,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : false,
                "FieldValidation" : null,
                "FieldSequence" : 11,
            	"FieldValue" : 'Individual'
            });
    
        component.set("v.IdList", this.IdList);
        console.log('idlist -->', component.get("v.IdList"));
        component.set("v.FieldList", this.FieldList);
        component.set("v.showDetailsComponent", true);
    },
    // US_27806_CKYC Details to be mandatory
	isEmpty: function(value){
        return ($A.util.isEmpty(value) || $A.util.isUndefined(value) || value === 0);
    },
	// US_27806_CKYC Details to be mandatory
    processToDisbursal : function(component,event) {
        console.log('stp,nostp'+component.get("v.stpNonStp"));
          //US:31397 UserStory_Checks to be skipped for GCO start
          var GCOflag='false';
          console.log('LoanObject here is==>'+this.LoanObject);
		  console.log('applicant of loan are here ==>'+this.LoanObject.Loan_Application__r);
		  var applicantList = this.LoanObject.Loan_Application__r;
                    if(applicantList) {
                        for(var index = 0, len = applicantList.length; index < len; ++index) {
                            var applicant = applicantList[index];
                            if(applicant.Contact_Name__c &&  applicant.Contact_Customer_Type__c  !=null && applicant.Applicant_Type__c == 'Primary') {
							  var GCOCampaigns = $A.get("$Label.c.GCO_Campaigns");
                                var GCOCampaignList = [];
                                GCOCampaignList = GCOCampaigns.split(',');
							 console.log('GCOCampaignList is==>'+GCOCampaignList);
                                if(GCOCampaignList.includes(applicant.Campaign_Code__c))
                                {
                                    GCOflag  = 'true';
                                }
                              console.log('primary applicant campign code is==>'+applicant.Campaign_Code__c);
                              console.log('GCOflag is==>'+GCOflag);
                            }
                        }
                    }
           //US:31397 UserStory_Checks to be skipped for GCO end
        //Bug 24237 S added STP check on proceed for disbursal
        if(component.get("v.stpNonStp") == "STP"){
            //22141 S
            //US:31397 UserStory_Checks to be skipped for GCO added condition of GCO
            if(component.get("v.FraudResult") == "MATCH" || GCOflag=='true'){
            // 22141 E   
            // US_27806_CKYC Details to be mandatory -- added below if
		     if(!( this.isEmpty(component.get("v.contact").Marital_Status__c) || this.isEmpty(component.get("v.contact").Father_Spouse__c) ||
				   this.isEmpty(component.get("v.contact").Father_Spouse_Salutation__c) || this.isEmpty(component.get("v.contact").Father_Spouse_First_Name__c) ||
				   this.isEmpty(component.get("v.contact").Father_Spouse_Last_Name__c) || this.isEmpty(component.get("v.contact").Mother_First_Name__c) ||
				   this.isEmpty(component.get("v.contact").Mother_Last_Name__c) || /* this.isEmpty(component.get("v.applicantObject").CKYC_No__c)  || */
				   this.isEmpty(component.get("v.applicantObject").Proof_of_Address_Submitted_for_Permanent__c) || this.isEmpty(component.get("v.applicantObject").Proof_of_Residence_Address_Submitted__c))){ 
				    
            	this.executeApex(component, "POSsubmitToCredit", {"loanId" : component.get("v.loanAppID")}, function(error, result) {
                     if(!error && result) {
                         result = JSON.parse(result);
                         console.log(result);
                         if (result.status == "Success") 
                         {   
                            console.log('isndie sucee');
                            var action1 = component.get("c.fetchStageHistory");
                            action1.setParams({ loanId : component.get("v.loanAppID") });
                            component.set("v.spinnerFlag","true");             
                            action1.setCallback(this, function(responsen) {
                                component.set("v.spinnerFlag","false");
                                console.log('inside callback');
                                var state = responsen.getState();
                                console.log(state);
                                //alert(responsen.getReturnValue());
                                if (state === "SUCCESS") {
                                    if(responsen.getReturnValue() == 'Underwriting')
                                    {
                                        this.invisibleMonitoringCall(component);
                                    }
                                    else
                                    {
                                        this.ShowToast(component, "Error!",'Error in Underwriting Stage , Sending back to DSA/PSF' , "error");
                                       this.callSendBack(component);
                                        
                                    }
                                }
                    		});
                    		$A.enqueueAction(action1);
                         }else{
                              this.ShowToast(component, "Error!",result.message , "error");
                              this.callSendBack(component);
                         }  
                     }
             	});
            	//22141 S
            	} // US_27806_CKYC Details to be mandatory
             else{
					console.log('showing CKYC error as Please fill CKYC mandetry data');	
					this.ShowToast(component, "Error!","Please fill CKYC mandatory  data" , "error");
						   
					  }  // US_27806_CKYC Details to be mandatory
          	}
            else{
                    
                this.ShowToast(component, "Error!","Customer Mobile Number is Changed, this is no longer a STP case" , "error");
                       
            } 
        }
	else{
        	this.ShowToast(component, "Error!","Cannot Proceed,LAN is not of STP flow or stage is not correct" , "error");

        }
        //22141 E
    },
    
    //YK 16774 separeted this API call to avoid DML and callout exception start
    invisibleMonitoringCall : function(component,event) {
         this.executeApex(component, "callInvisibleMonitoring", {"loanId" : component.get("v.loanAppID")}, function(error, result) {
             if(!error && result) {
                 result = JSON.parse(result);
                 console.log('inside im AP')
                 console.log(result);
                 if (result.status == "Success") 
                 {   
                     // this.ShowToast(component, "Success!",result.message , "success");
                      this.SubmitToApproval(component);
                 }else{
                      this.ShowToast(component, "Error!",result.message , "error");
                      this.callSendBack(component);
                 }  
             }
         });
    },
    //YK 16774 separeted this API call to avoid DML and callout exception end
    
    SubmitToApproval : function(component){
        this.executeApex(component, "POSSubmitToApproval", {"loanId" : component.get("v.loanAppID")}, function(error, result) {
            if(!error && result) {
                console.log('inside submit approval');
                result = JSON.parse(result);
                console.log(result);
                if (result.status == "Success") 
                {   
                    console.log('Inside sucess approved');
                    			var action1 = component.get("c.fetchStageHistory");
                        action1.setParams({ loanId : component.get("v.loanAppID") });
                    	component.set("v.spinnerFlag","true");
                        action1.setCallback(this, function(responsen) {
                            component.set("v.spinnerFlag","false");
                            console.log('inside callback submittoapproval');
                        var state = responsen.getState();
                        console.log(state);
                            
                     //alert(' Approval  '+responsen.getReturnValue());
                        if (state === "SUCCESS") {
                            console.log('approval response state'+responsen.getReturnValue())
                            if(responsen.getReturnValue() == 'Approved')
                            {
                                this.SubmitToPOstApprovalsal(component);
                            }
                            else
                            {
                                this.ShowToast(component, "Error!",'Error in Approved Stage , Sending back to DSA/PSF' , "error");
                               this.callSendBack(component);
                                
                            }
                        }
                    });
                    $A.enqueueAction(action1);
                  //  console.log('inside success of approval');
                 //   this.ShowToast(component, "Success!",result.message , "success");
                   // this.SubmitToPOstApprovalsal(component);
                }else{
                    this.ShowToast(component, "Error!",result.message , "error");
                    this.callSendBack(component);
                }  
            }
        });
    },
    SubmitToPOstApprovalsal : function(component){
        this.executeApex(component, "POSpostApprovalSales", {"loanId" : component.get("v.loanAppID")}, function(error, result) {
            if(!error && result) {
                result = JSON.parse(result);
                if (result.status == "Success") 
                {   
                    this.ShowToast(component, "Success!",result.message , "success");
                    this.FetchOpportunity(component);
                }else{
                    this.ShowToast(component, "Error!",result.message , "erroe");
                    this.callSendBack(component);
                }  
            }
        });
    }, 
    FetchOpportunity : function(component){
        this.executeApex(component, "queryData", {"oppId" : component.get("v.loanAppID")}, function(error, result) {
            if(!error && result) {
                console.log(result[0]);
              component.set("v.OppObj",result[0]);
                console.log(component.get("v.OppObj").StageName);
              if (component.get("v.OppObj").StageName == 'Post Approval Sales') {
                  this.disableObligationForm(component);
                  this.triggerDisableFormEvent(component, component.get("v.OppObj").StageName);
              }
              if (component.get("v.OppObj").StageName == 'DSA/PSF Login') {
                  this.enableObligationForm(component);
                  this.triggerEnableFormEvent(component, component.get("v.OppObj").StageName);
              }
            }
        });
    },
    triggerEnableFormEvent: function(component, loanStage){
        var event = $A.get("e.c:EnableFormEventOnSendBack");;
        event.setParams({"loanStage": loanStage});
        event.fire();
    },
    triggerDisableFormEvent: function(component, loanStage){
        var event = $A.get("e.c:DisableFormEvent");
        event.setParams({"loanStage": loanStage});
        event.fire();
    },
     callSendBack : function(component){
        this.executeApex(component, "sendback ", {"loanId" : component.get("v.loanAppID")}, function(error, result) {
            if(!error && result) {
                result = JSON.parse(result);
                if (result.status == "Success") 
                {   
                    this.ShowToast(component, "Success!",result.message , "success");
                    this.FetchOpportunity(component);
                }else{
                    this.ShowToast(component, "Error!",result.message , "error");
                }  
            }
        });
    },
    ShowToast : function(component, title, message, type){
        var ShowToastEvent = $A.get("e.c:ShowToastEvent");
        ShowToastEvent.setParams({
            "title": title,
            "message":message,
            "type":type,
        });
        ShowToastEvent.fire();
    },
    executeApex: function(component, method, params, callback){
        var action = component.get("c."+method); 
        action.setParams(params);
        component.set("v.spinnerFlag","true");
        action.setCallback(this, function(response) {
            component.set("v.spinnerFlag","false");
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
                this.ShowToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    disableObligationForm : function(component) {
        component.set("v.isReadOnly", true);
    },
    enableObligationForm : function(component) {
        component.set("v.isReadOnly", false);
    },
    isCPVDone : function(component) { // 3rd July 2019 Needhi - Adhoc S
        var loanAppId = component.get("v.loanAppID");
        this.executeApex(component, "fetchCPVData", {"loanId" : loanAppId}, function(error, result) {
            console.log('result --> ' + result);
            if(!error && (result == false)) {
                this.ShowToast(component, "Error!", 'Please complete CPV', "error");
            } else {
                console.log('Continue with STP flow...');
                this.processToDisbursal(component , event);//added this--inplace of helper
            }
        });
    } // 3rd July 2019 Needhi - Adhoc E
})