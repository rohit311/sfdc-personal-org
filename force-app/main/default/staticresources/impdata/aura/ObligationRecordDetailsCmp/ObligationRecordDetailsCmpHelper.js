({
    
    FieldList : [],
    PicklistProp : [],
    IdList : [],
    LoanObject : [],
    ApplicantId : '',
    
    setFieldData : function(component) {
        console.log('in setFieldData');
		this.FieldList = [];
        var loanObj;
        var action = component.get("c.fetchObligations");
        action.setParams({
            "recordId": component.get("v.loanAppID")
        });
        action.setCallback(this, function(response){
        	var state = response.getState();
        	if (component.isValid() && state === "SUCCESS") {
                console.log('inside success...obligation');
                loanObj = response.getReturnValue();
                if(loanObj.length > 0)
                {
                    this.LoanObject = loanObj[0];
                    //populate applicants picklist
                    var applicantList = loanObj[0].Loan_Application__r;
                    if(applicantList) {
                        for(var index = 0, len = applicantList.length; index < len; ++index) {
                            var applicant = applicantList[index];
                            /*22624 Sprint 5C s*/
                            if(component.get("v.flow") == 'mobility2'){
                                var AppNameAndType = applicant.ContactName__c + " - " + applicant.Applicant_Type__c;
                                this.ApplicantId = applicant.Id;
                                this.PicklistProp.push({
                                    label : AppNameAndType,
                                    value : applicant.Id,
                                    selected : true,
                                    disabled : false
                                });    
                            }
                            else{
                                /*22624 Sprint 5C e*/
                            if(applicant.Contact_Name__c &&  applicant.Contact_Customer_Type__c  !=null && applicant.Contact_Customer_Type__c != "Corporate" && applicant.Applicant_Type__c == 'Primary') {                    
                                var AppNameAndType = applicant.Id;
                                this.ApplicantId = applicant.Id;
                                this.PicklistProp.push({
                                    label : AppNameAndType,
                                    value : AppNameAndType,
                                    selected : true,
                                    disabled : false
                                });
                            }
                        }
                    }
                    }
                    
                    // Populate Id list
                    var InsuranceList = loanObj[0].Existing_Loan_Details__r;
                    if(InsuranceList) {
                        for(var index = 0, len = InsuranceList.length; index < len; ++index) {                            
                            if(InsuranceList[index].Id) {
                                this.IdList.push(InsuranceList[index].Id.toString());
                            }
                        }
                    }
                }
        	}
            if(loanObj.length > 0)
            {
                this.populateFieldData(component);
                this.handleSalMobFlowEventHelper(component);
            }
    	});
        $A.enqueueAction(action);		
	},	
    
    populateFieldData : function(component) {
        //populate FielList and IdList
        console.log('inside populateFieldData......'+JSON.stringify(this.FieldList));
        /*22624 Sprint 5C s*/
        if(component.get("v.flow") == 'mobility2'){
            console.log('pk flow 1'+component.get("v.flow"));
        
         this.FieldList.push({
                "FieldName" : "Applicant__c",
                "FieldLabel" : "Applicant",
                "FieldRequired" : true,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : true,
                "FieldType" : "PICKLIST",
                "PicklistProp" : this.PicklistProp,
                "FieldSequence" : 1,
             	"FieldReadOnlyConditions" : {
                    "ConditionsArray" : [
                        {
                            "FieldName" : "Identifier__c",
                            "FieldValues" : [""],
                            "ConditionType" : "Positive",
                            "ConditionName" : "C1"
                        }
                    ],
                    "FinalConditionLogic" : "C1"
                    
                },
            });
        this.FieldList.push({
                "FieldName" : "Name_Borrower__c",
                "FieldLabel" : "Applicant",
                "FieldRequired" : true,
                "FieldVisibleInTable" : true,
                "FieldVisibleInModal" : false,
                "FieldSequence" : 1,
                
            });
                } 
        /*22624 Sprint 5C e*/
        
         this.FieldList.push({
                "FieldName" : "Loan_Type__c",
                "FieldLabel" : "Loan Type",
                "FieldRequired" : false,
                "FieldRequiredConditions" : null,
                "FieldVisibleInTable" : true,
                "FieldVisibleInModal" : true,
                "FieldValidation" : null,
                "FieldSequence" : 1,
             	"FieldReadOnlyConditions" : {
                    "ConditionsArray" : [
                        {
                            "FieldName" : "Identifier__c",
                            "FieldValues" : [""],
                            "ConditionType" : "Positive",
                            "ConditionName" : "C1"
                        }
                    ],
                    "FinalConditionLogic" : "C1"
                } 	
            });
        
        this.FieldList.push({
                "FieldName" : "Loan_Amount__c",
                "FieldLabel" : "Loan Amount",
                "FieldRequiredConditions" : null,
                "FieldVisibleInTable" : true,
                "FieldVisibleInModal" : true,
                "FieldValidation" : null,
                "FieldSequence" : 2,
            	"FieldReadOnlyConditions" : {
                    "ConditionsArray" : [
                        {
                            "FieldName" : "Identifier__c",
                            "FieldValues" :["Manual"],//prod adhoc disable this field for cibil's obligation
                            "ConditionType" : "Negative",//prod adhoc
                            "ConditionName" : "C1"
                        }
                    ],
                    "FinalConditionLogic" : "C1"
                } 
            });
        
        this.FieldList.push({
                "FieldName" : "POS__c",
                "FieldLabel" : "Current balance",
                "FieldRequired" : true,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : true,
                "FieldValidation" : null,
                "FieldSequence" : 3,
            	"FieldReadOnlyConditions" : {
                    "ConditionsArray" : [
                        {
                            "FieldName" : "Identifier__c",
                            "FieldValues" : ["Manual"],//prod adhoc
                            "ConditionType" : "Negative",//prod adhoc
                            "ConditionName" : "C1"
                        }
                    ],
                    "FinalConditionLogic" : "C1"
                },
            //Rohit added for bug 21031 start
            "FieldRequiredConditions":{
                "ConditionsArray" : [
                        {
                            "FieldName" : "Identifier__c",
                            "FieldValues" : ["Manual"],
                            "ConditionType" : "Positive",
                            "ConditionName" : "C1"
                        }
                    ],
                    "FinalConditionLogic" : "C1"
            }
            //Rohit added for bug 21031 stop
            });
        
            this.FieldList.push({
                "FieldName" : "Customer_Declared_EMI__c",
                "FieldLabel" : "Declared EMI",
                "FieldRequired" : false,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : true,
                "FieldValidation" : null,
                "FieldSequence" : 4,
                "FieldReadOnly" : false
            });
        
        this.FieldList.push({
                "FieldName" : "Derived_EMI__c",
                "FieldLabel" : "Derived EMI",
                "FieldRequired" : false,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : true,
                "FieldValidation" : null,
                "FieldSequence" : 5,
            	"FieldReadOnly" : true
            });
        
        	this.FieldList.push({
                "FieldName" : "Start_On__c",
                "FieldLabel" : "Start Date",
                "FieldRequired" : true,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : true,
                "FieldSequence" : 6
        	});
        
            this.FieldList.push({
                "FieldName" : "Status__c",
                "FieldLabel" : "Status",
                "FieldRequired" : true,
                "FieldVisibleInTable" : true,
                "FieldVisibleInModal" : true,
                "FieldValidation" : null,
                "FieldSequence" : 7
            });
        
        	this.FieldList.push({
                "FieldName" : "MOB__c",
                "FieldLabel" : "MOB",
                "FieldReadOnly" : true,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : true,
                "FieldValidation" : null,
                "FieldSequence" : 8
            });
        
        	this.FieldList.push({
                "FieldName" : "Applicant__c",
                "FieldLabel" : "Applicant",
                "FieldRequired" : true,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : false,
                "FieldValue" : this.ApplicantId,
                "FieldSequence" : 9                
            });
        
        	this.FieldList.push({
                "FieldName" : "Loan_Application__c",
                "FieldLabel" : "Loan Application",
                "FieldRequired" : true,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : false,
                "FieldValidation" : null,
                "FieldSequence" : 10,
            	"FieldValue" : component.get("v.loanAppID")
            });
        
        this.FieldList.push({
                "FieldName" : "Obligation__c",
                "FieldLabel" : "Obligation",
                "FieldRequired" : true,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : false,
                "FieldValidation" : null,
                "FieldSequence" : 11,
            	"FieldValue" : 'Yes'
            });
        
        this.FieldList.push({
                "FieldName" : "EMI__c",
                "FieldLabel" : "EMI",
                "FieldRequired" : true,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : false,
                "FieldValidation" : null,
                "FieldSequence" : 12
            });
        
        this.FieldList.push({
                "FieldName" : "Type_of_Oblig__c",
                "FieldLabel" : "Type of Obligation",
                "FieldRequired" : true,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : false,
                "FieldValidation" : null,
                "FieldSequence" : 13,
            	"FieldValue" : 'Individual'
            });
        
        this.FieldList.push({
                "FieldName" : "Identifier__c",
                "FieldLabel" : "Identifier",
                "FieldRequired" : false,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : true,
                "FieldValidation" : null,
                "FieldSequence" : 14,
            	"FieldValue" : '',
            	"FieldReadOnly" : true,
            });
        /*17138 s*/
         this.FieldList.push({
                "FieldName" : "financers__c",
                "FieldLabel" : "Financer Name",
                "FieldRequired" : false,
                "FieldRequiredConditions" : null,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : true,
                "FieldValidation" : null,
                "FieldSequence" : 15
            });
        /*17138 e*/
        /*24997 s*/
        this.FieldList.push({
                "FieldName" : "Remark__c",
                "FieldLabel" : "Remarks",
                "FieldRequired" : false,
                "FieldRequiredConditions" : null,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : true,
                "FieldValidation" : null,
                "FieldSequence" : 16
            });
        /*24997 e*/
        component.set("v.IdList", this.IdList);
        component.set("v.FieldList", this.FieldList);
        component.set("v.showDetailsComponent", true);
    },
    
    handleSalMobFlowEventHelper : function(component, event) {
   //     var obligationRecId = event.getParam("obligationRecordId");
   //     console.log('obligationRecId ---helper---->> '+obligationRecId);
        console.log('loanAppID ----helper--->> '+component.get("v.loanAppID"));

        var action = component.get("c.updateCamScam");
        action.setParams({
            "oppId": component.get("v.loanAppID")
        });
        
        action.setCallback(this, function(response){
        	var state = response.getState();
        	if (component.isValid() && state === "SUCCESS") {
                console.log('inside success updateCamScam...');
                var camObj = response.getReturnValue();
                console.log('Total_Mthly_Oblig__c ---->> '+camObj.Total_Mthly_Oblig__c);
                component.set("v.camObject", camObj);
        	}
    	});
        $A.enqueueAction(action);
    },
    
})