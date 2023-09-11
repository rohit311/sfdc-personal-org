({
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called when component is loaded. 
    * 						This method executes helper method to initialize existing records if any.
    *   @version		: 	1.0
    */
    doInit : function(component, event, helper) {
        window.setTimeout(
				$A.getCallback(function() {
        try {
            //debugger;
            component.set("v.ObjectList",[]);
            console.debug("here");
			// Start of changes - 22181
            var flow = component.get("v.flow"); 
            var ObjectName = component.get("v.ObjectName");
            if(flow == "ELA" && ObjectName == "DPLinsurance__c") {
            	var sliderParams = new Object();
                sliderParams.min = 50;
                sliderParams.max = 200;
                sliderParams.step = 10;
                //sliderParams.size = 'large';
				//sliderParams.class = 'slds-theme_alt-inverse';
                sliderParams.disabled = true;
                sliderParams.value = 50;
                sliderParams.label = "Loan % to be covered";
                sliderParams.variant = "label-hidden";
                component.set("v.sliderParams", sliderParams);
            }
            // End of changes - 22181
        	// Set existing records for selected object if any
        	helper.setRecords(component, false);
            //Bug 23556 S
            //alert(component.get("v.isCommunityUsr"))
            if(component.get("v.isCommunityUsr") == true){
            	component.set("v.RSAPage", "/Partner/apex/RightSumAssuredPage?product=" + component.get("v.product") + "&recordID=" + component.get("v.recordId"));
            }
            else{
                component.set("v.RSAPage", "/apex/RightSumAssuredPage?product=" + component.get("v.product") + "&recordID=" + component.get("v.recordId"));
            }
            //Bug 23556 E
            
            //Bug 25146 S
            helper.hndlBGExtraCarePlus(component,event,helper);
            //Bug 25146 E
           
           
        } catch(err) {
            console.debug("Error in doInit --> " + err.message + " stack --> " + err.stack);
        }
                    }), 3000
			); 
   	},
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called when slider is changed. Added for 22181.
    * 						This method is called only in insurance flow for employee loan automation.
    *   @version		: 	1.0
    */
    sliderChange : function(component, event, helper) {
        try {
         	var flow = component.get("v.flow"); 
            var ObjectName = component.get("v.ObjectName");
			//var sliderVar = event.getParam("value");
			var sliderVar = component.get("v.sliderParams");
			var LoanAmount = component.get("v.LoanAmount");
            if(flow == "ELA" && ObjectName == "DPLinsurance__c" && sliderVar && LoanAmount) {
				var percentVal = sliderVar.value / 100;
				if(percentVal <= 2) {
					var fieldArr = component.find("field_inp");
					if(fieldArr) {
						for(var i = 0; i < fieldArr.length; i++) {
							var label = fieldArr[i].get("v.label");
							if(label == "Sum_Assured__c") {
								fieldArr[i].set("v.value", LoanAmount * percentVal);
								break;
							}
						}   
					}	
				}
            }   
        } catch(err) {
            console.debug("Error in sliderChange --> " + err.message + " stack --> " + err.stack);
        }
    },
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called while adding new policy members for FFHG and IHG insurance products. 
    * 						Applicable only for insurance flow.
    *   @version		: 	1.0
    */
    addPolicyMembers : function(component, event, helper) {
        try {
        	event.preventDefault();
            
            // Get the index of selected record and retrieve selected element from ObjectList
            var ObjectIndex = event.currentTarget.dataset.index;
            var ObjectList = component.get("v.ObjectList");
            var ObjectVar = ObjectList[ObjectIndex];
            var isSalMobilityFlow = component.get("v.isSalMobilityFlow");
            var isInsurancePosLaFlow = component.get("v.isInsurancePosLaFlow");
            
            if(ObjectVar) {
                var recordVar = ObjectVar.record;
                // Open add member window in a popup
                if(recordVar) {
                	var insuranceId = recordVar.Id;
                    var loanId = recordVar.Opportunity__c;
                    var isTablet = $A.get("$Browser.isTablet");
                    var isPhone = $A.get("$Browser.isPhone");
                    var urlEvent = $A.get("e.force:navigateToURL");
                    if(isPhone || isTablet) {
                    	if(urlEvent) {
                            urlEvent.setParams({
                                "url": "/apex/AddPolicyMembers?LoanId=" + loanId + "&InsuranceId=" + insuranceId + "&isSalMobilityFlow=" + isSalMobilityFlow + "&isInsurancePosLaFlow=" + isInsurancePosLaFlow
                            });
                            urlEvent.fire();
                        }    
                    } else {
                    	var memberWindow = window.open("/apex/AddPolicyMembers?LoanId=" + loanId + "&InsuranceId=" + insuranceId + "&isSalMobilityFlow=" + isSalMobilityFlow + "&isInsurancePosLaFlow=" + isInsurancePosLaFlow, "Add Policy Members For " + insuranceId, "toolbar=yes,scrollbars=yes,resizable=yes,top=100,left=100,width=1200,height=800");    
                    }                   
                }    
            }
        } catch(err) {
            console.debug("Error in addPolicyMembers --> " + err.message + " stack --> " + err.stack);
        }
    },
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called to fill up the Feedback Questions. 
    * 						Applicable only for insurance flow.
    *   @version		: 	1.0
    */
    openFDQuestion : function(component, event, helper) {
        try {
        	event.preventDefault();
            
            // Get the index of selected record and retrieve selected element from ObjectList
            var ObjectIndex = event.currentTarget.dataset.index;
            var ObjectList = component.get("v.ObjectList");
            var ObjectVar = ObjectList[ObjectIndex];
            
            if(ObjectVar) {
                var recordVar = ObjectVar.record;
                // Open add member window in a popup
                if(recordVar) {
                	var insuranceId = recordVar.Id;
                    // decOfGdHlth added by Anurag for 24942 22181
                    var decOfGdHlth = recordVar.Declaration_of_good_health__c;
                    // console.log("decOfGdHlth: ",decOfGdHlth);
                    //var loanId = recordVar.Opportunity__c;
                    var fdQueWindow = window.open("/apex/InsuranceQuestionnaire?InsuranceId=" + insuranceId+"&dgh="+decOfGdHlth, "Feedback Questionnaire", "toolbar=yes,scrollbars=yes,resizable=yes,top=100,left=300,width=1000,height=500");
                }    
            }
        } catch(err) {
            console.debug("Error in openfeedbackQuestion --> " + err.message + " stack --> " + err.stack);
        }
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called while adding new record. 
    * 						Executes helper method to create field configuration for new record to be inserted. 
    * 						It also disables all buttons on the UI during processing.
    *   @version		: 	1.0
    */
    addNewRecord : function(component, event, helper) {
        try {
        	event.preventDefault(); 
            // Disable all buttons till processing
            helper.disableButtons(component, true); 
            // Initialize count of all the fields which are filled to zero
            component.set("v.filledFieldsCount", 0); 
            // Initialize count of all the fields which are enabled to one
            component.set("v.enabledFieldsCount", 1);
            // Initialize percentage of fields which are filled to zero
            component.set("v.percentFilled", 0);
            // Initialize isNewRecord flag to true which indicates creation of new record
            component.set("v.isNewRecord", true);
            // Set field configuration for new record to be created
            helper.setRecords(component, true);
            
            component.set("v.validationMsg","");
            var ObjectList = component.get("v.ObjectList");
        	console.log("OBJECT LISTAAA: ",ObjectList.length);
        } catch(err) {
            console.debug("Error in addNewRecord --> " + err.message + " stack --> " + err.stack);
            //alert('Error in addNewRecord jscntrl --> ' + err.message + '---- stack --> ' + err.stack);
        }
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called while editing individual record. 
    * 						Opens modal window for selected record. 
    * 					  	Sets index for selected record. 
    * 						Validates all the fields and sets accessibility for fields.
    *   @version		: 	1.0
    */
    editRecord : function(component, event, helper) {
        try {
            event.preventDefault();
            
            // Initialize isOpen flag to open modal window
            component.set("v.isOpen", true);
            // Initialize isNewRecord flag to false which indicates existing record 
            component.set("v.isNewRecord", false);
            
			// Start of changes - 22181
			var flow = component.get("v.flow");
			if(flow == "ELA") {
				var tableDiv = component.find("tableDiv");
				if(tableDiv) {
					$A.util.addClass(tableDiv, "disabledDiv");
				}
				var addBtn = component.find("addBtnDiv");
				if(addBtn) {
					$A.util.addClass(addBtn, "disabledDiv");		
				}
			}
			// End of changes - 22181
			
            // Get the index of selected record and retrieve selected element from ObjectList
            var ObjectIndex = event.currentTarget.dataset.index;
            var ObjectList = component.get("v.ObjectList");
            var ObjectVar = ObjectList[ObjectIndex];
            
            // Set the index of selected record
            component.set("v.Index", ObjectIndex);
            component.set("v.validationMsg","");
            // Set field configuration for record to be edited
            component.set("v.ObjectVar", ObjectVar);    
            
            // Validates all the fields and set accessibility for fields
            var validateField = async function() {
                helper.validateFieldHelper(component, event, helper, false);
            }
            var FunVar = validateField();;
            helper.hndlBGExtraCarePlus(component, event, helper)
        } catch(err) {
            console.debug("Error in editRecord --> " + err.message + " stack --> " + err.stack);
        }
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called while deleting individual record. 
    * 						Sets index for selected record.
    * 					  	Performs any business logic before delete. 
    * 						Adjusts table height after deleting record.
    *   @version		: 	1.0
    */
    deleteRecord : function(component, event, helper) {
        try {
            event.preventDefault();
            // Get the index of selected record and retrieve selected element from ObjectList
            var ObjectIndex = event.currentTarget.dataset.index;
            component.set("v.Index", ObjectIndex);
            
            // Execute business logic before delete if any
            helper.executeBusinessLogicBeforeDelete(component);
            // Adjust table height after deleting record 
            helper.setTableHeight(component);
        } catch(err) {
            console.debug("Error in deleteRecord --> " + err.message + " stack --> " + err.stack);
        }
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called while viewing individual record. 
    * 					  	Sets index for selected record.
    * 					  	Opens modal window to view record. 
    * 					  	Executes validate helper to disable all fields in view mode.
    *   @version		: 	1.0
    */
    viewRecord : function(component, event, helper) {
        try {
            event.preventDefault();
            // Initialize isOpen flag to open modal window
            component.set("v.isOpen", true);
            // Initialize isNewRecord flag to false which indicates existing record
            component.set("v.isNewRecord", false);
            // Initialize isViewRecord flag which indicates view mode
            component.set("v.isViewRecord", true);
            
			// Start of changes - 22181
			var flow = component.get("v.flow");
			if(flow == "ELA") {
				var tableDiv = component.find("tableDiv");
				if(tableDiv) {
					$A.util.addClass(tableDiv, "disabledDiv");
				}
				var addBtn = component.find("addBtnDiv");
				if(addBtn) {
					$A.util.addClass(addBtn, "disabledDiv");		
				}
			}
			// End of changes - 22181
			
            // Get the index of selected record and retrieve selected element from ObjectList
            var ObjectIndex = event.currentTarget.dataset.index;
            var ObjectList = component.get("v.ObjectList");
            var ObjectVar = ObjectList[ObjectIndex];
            
            // Set the index of selected record
            component.set("v.Index", ObjectIndex);
            
            // Set field configuration for record to be viewed
            component.set("v.ObjectVar", ObjectVar);
            
            // Validates all the fields and set accessibility for fields
            var validateField = async function() {
                helper.validateFieldHelper(component, event, helper, false);
            }
            var FunVar = validateField();
        } catch(err) {
            console.debug("Error in viewRecord --> " + err.message + " stack --> " + err.stack);
        }
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called while saving existing / new record. 
    * 					  	Disables all buttons during processing.
    * 					  	Validates all the fields and sets accessibility for fields. 
    * 					  	If all the fields are valid then it executes business logic before calling save.
    * 						If any of the field is invalid then it executes logic to disable buttons if required.
    *   @version		: 	1.0
    */
    saveRecords : function(component, event, helper) {
        try {
            event.preventDefault();
            var ObjectName = component.get("v.ObjectName");
            helper.disableButtons(component, true);
            
            // Validates all the fields and sets isValidRecord at the end
            var validateField = async function() {
                helper.validateFieldHelper(component, event, helper, true);
            }
            var FunVar = validateField();
            var isValidRecord = component.get("v.isValidRecord");
         	
            // If isValidRecord is true then execute business logic and save records
            if(isValidRecord) {
                // Execute business logic first and then call saveRecord to save records
                var businessLogic = async function() {
                    helper.executeBusinessLogicBeforeUpsert(component,event);
                }
                var busLogic = businessLogic();
            } else {
                // Enable all buttons
                helper.disableButtons(component, false);
                
                // Start of insurance flow logic
                if(ObjectName == "DPLInsurance__c" || ObjectName == "Service_To_Sales__c") {
                    // This method is called only for DPLInsurance__c and Service_To_Sales__c object screen which toggles insurance flow buttons
                    helper.toggleInsuranceButtons(component, ObjectName);
                }
                // End of insurance flow logic
                
                // Set table height 
                helper.setTableHeight(component);
            }
            // ELA added by Anurag for 23583
            // console.log("INSIDE SAVE RECORDS: "+component.get("v.isSalMobilityFlow"));
            var flow = component.get("v.flow");
           // alert('before');
            if((flow == "ELA" || component.get("v.isSalMobilityFlow") == true) && component.get("v.ObjectName")=='DPLinsurance__c')
			{
				// console.log('in if'+component.get("v.recordId"));
				 // user story 978 s
                     var updateidentifier =  $A.get("e.c:Update_identifier");
                     updateidentifier.setParams({
                    "eventName": 'Pricing Insurance Details',
                    "oppId":component.get("v.recordId")
                      });
                   updateidentifier.fire();
                   // user story 978 e
				helper.calculateEmi(component,event,component.get("v.recordId"));//added by hrushikesh
                //alert('ok ');
			}
        } catch(err) {
            console.debug("Error in saveRecords --> " + err.message + " stack --> " + err.stack);
        }   
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called by SelectedRecordEvent declared in the component markup. 
    * 					  	Gets the index of selected record.
    * 					  	Gets the lookup field API name.
    * 						Gets the record id from selected record in the event. 
    * 					  	Sets lookup record id as value for lookup field.
    *   @version		: 	1.0
    */
    getRecordId : function(component, event, helper) {
        try {
            // Get the lookup record from the event
            var LookupRecord = event.getParam("record");
            
            // Get the index of selected record and retrieve selected element from ObjectList
            var index = component.get("v.Index");
            var LookupField = component.get("v.LookupField");
            var ObjectList = component.get("v.ObjectList");
            
            if(ObjectList[index]) {
                var recordVar = ObjectList[index].record;
                // Set the value for lookup field
                if(LookupRecord) {
                    recordVar[LookupField.replace("__r", "__c")] = LookupRecord.Id;    
                }
                ObjectList[index].record = recordVar;
                var fields = ObjectList[index].fields;
                for(var fieldIndex in fields) {
                    var field = fields[fieldIndex];
                    if(field.FieldName == LookupField) {
                        field.FieldValue = LookupRecord.Name;
                        break;
                    }
                }
            }
            component.set("v.ObjectList", ObjectList);
        } catch(err) {
            console.debug("Error in getRecordId --> " + err.message + " stack --> " + err.stack);
        }
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called on selecting specific record from list of lookup records. 
    * 					  	Sets the lookup field name for the record.
    * 					  	Validates all the fields and sets accessibility for fields.
    *   @version		: 	1.0
    */
    setLookupField : function(component, event, helper) {
        try {
            console.log('in set lookup');
        	// Set the lookup field name for selected record 
            var fieldname = event.currentTarget.dataset.fieldname;
            component.set("v.LookupField", fieldname);
            
            // Validates all the fields and set accessibility for fields
            var validateField = async function() {
                helper.validateFieldHelper(component, event, helper, false);
            }
            var FunVar = validateField();    
        } catch(err) {
            console.debug("Error in setLookupField --> " + err.message + " stack --> " + err.stack);
        }    
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called to close modal window.
    * 						Resets all the important flags and counters.
    * 					  	Removes the record from list on UI if it is not added in the database.
    *   @version		: 	1.0
    */
    closeModalWindow : function(component, event, helper) {
        try {
            console.log('hi');
        	event.preventDefault();
            // Set isOpen flag to false to close modal window
            component.set("v.isOpen", false);
            // Set isViewRecord flag to false which indicates view mode is closed
            component.set("v.isViewRecord", false);
            
            // Remove the record from list on UI if it is not added in the database
            var ObjectList = component.get("v.ObjectList");
          //  for(var ObjIndx in ObjectList) {
          	for(var i=0; i<ObjectList.length; i++){
                var RecordVar = ObjectList[i].record;
                if(RecordVar.Id == null) {
                    ObjectList.splice(i, 1);
                }
            }
            // Start of changes - 22181
			var flow = component.get("v.flow");
			if(flow == "ELA") {
				var tableDiv = component.find("tableDiv");
				if(tableDiv) {
					$A.util.removeClass(tableDiv, "disabledDiv");
				}
				var addBtn = component.find("addBtnDiv");
				if(addBtn) {
					$A.util.removeClass(addBtn, "disabledDiv");		
				}
				if(component.get("v.isNewRecord") == false)
					$A.get("e.force:refreshView").fire();
			}
			// End of changes - 22181
            // Reset all the important flags and counters
            component.set("v.ObjectList", ObjectList);
            component.set("v.ObjectVar", null);
            component.set("v.filledFieldsCount", 0);
            component.set("v.enabledFieldsCount", 1);
            component.set("v.percentFilled", 0);
            
            // Set table height
            helper.setTableHeight(component);
            var flow = component.get("v.flow");
            if((flow == "ELA" || component.get("v.isSalMobilityFlow") == true) && component.get("v.ObjectName")=='DPLinsurance__c')
            {
                console.log('in if'+component.get("v.recordId"));
                helper.calculateEmi(component,event,component.get("v.recordId"));
            }
            if(component.get("v.isSalMobilityFlow") != true && component.get("v.isPosLaFlow") != true && component.get("v.flow") != "ELA") { // Added condition for 22181
                //console.log('refresh.........');
                window.location.href = window.location.href;
            }
        } catch(err) {
            console.debug("Error in closeModalWindow --> " + err.message + " stack --> " + err.stack);
        }
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called to set dependent picklist mapping.
    * 						Gets controlling field API name along with new value selected on UI.
    * 					  	Gets controlling and dependent picklist values mapping.
    * 						Sets the dependent picklist values as per the controlling picklist value.
    *   @version		: 	1.0
    */
    setDependentPicklistMapping : function(component, event, helper) {        
        try {
            console.log('in set field map');
            // Get the new value of controlling picklist selected on the UI, controlling picklist name and selected record index
            var newValue = event.currentTarget.dataset.value;
            var index = event.currentTarget.dataset.index;
            var ctrlfieldname = event.currentTarget.dataset.fieldname;
            var PicklistValuesMap = component.get("v.PicklistValuesMapping");
            console.debug('newValue :: ' + newValue + ' ctrlfieldname :: ' );
            // Get the index of selected record and retrieve selected element from ObjectList
            var ObjectList;
            var ObjVar;
            if(index) {
                ObjectList = component.get("v.ObjectList");
                ObjVar = ObjectList[index];
            } else {
                ObjVar = component.get("v.ObjectVar");
            }
            var fields = ObjVar.fields;
            console.log('fields'+fields);
            var FieldPropertiesMap = component.get("v.FieldPropertiesMap");
            var ResultFieldsMap = new Object();
            var counter = 0;
			
			// Anonymous function to set dependent picklist mapping          
            var setDependentPicklistMapping = function (fieldname, NewControllingValue) {
                // Iterate over the map of controlling and dependent picklist values to select all the dependent fields of controlling field
                for(var key in PicklistValuesMap) {
                    var combination = key.split("-");
                    var CtrlFieldName;
                    var DepFieldName;
                    if(combination && combination.length == 2) {
                    	CtrlFieldName = combination[0];
                    	DepFieldName = combination[1];    
                    }
                    
                    // If the controlling field is found then generate an array of PicklistProp for dependent picklist field
					if(CtrlFieldName == fieldname) {
                        var DependentValuesMap = PicklistValuesMap[key];                       
                        var EmptyPicklistProp = [];
                        EmptyPicklistProp.push({
                            label : '--None--',
                            value : '',
                            selected : true,
                            disabled : false
                        });
                        var NewPicklistProp = [];
                        NewPicklistProp.push({
                            label : '--None--',
                            value : '',
                            selected : true,
                            disabled : false
                        });
                        
                        // Set the dependent picklist values as per the controlling picklist value
                        var NewDependentValue;
                        var DepField = FieldPropertiesMap[DepFieldName];
                        if(DepField && NewControllingValue) {
                            var NewPicklistValues = DependentValuesMap[NewControllingValue];
                            if(NewPicklistValues && NewPicklistValues.length > 0 && !NewPicklistValues.includes(undefined)) {
                                NewDependentValue = NewPicklistValues[0];    
                            }
                           
                        /*     for(var NewValueIndex=0; NewValueIndex< NewPicklistValues.length;NewValueIndex++){
                             	NewPicklistProp.push({
                                    label : NewPicklistValues[NewValueIndex],
                                    value : NewPicklistValues[NewValueIndex],
                                    selected : false,
                                    disabled : false
                                });
                             
                             }
                          */   
                            
                            var Index=0;
                            for(var NewValueIndex in NewPicklistValues) {
                                Index++;
                                NewPicklistProp.push({
                                    label : NewPicklistValues[NewValueIndex],
                                    value : NewPicklistValues[NewValueIndex],
                                    selected : false,
                                    disabled : false
                                });
                                
                                if(!(Index < NewPicklistValues.length))
                                    break;
                            }
                           
                            
                            
                            if(NewDependentValue) {
                                DepField.PicklistProp = NewPicklistProp;
                                DepField.FieldValue = NewDependentValue;
                                ObjVar.record[DepField.FieldName] = NewDependentValue; // Set dependent field value                       
                            } else {
                                DepField.FieldValue = '';
                                ObjVar.record[DepField.FieldName] = ''; // Set dependent field value
                                DepField.PicklistProp = EmptyPicklistProp;
                            }
                            ObjVar.record[fieldname] = NewControllingValue; // Set controlling field value
                        } else {
                            DepField.FieldValue = '';
                            DepField.PicklistProp = EmptyPicklistProp;
                        }
                        ResultFieldsMap[DepFieldName] = DepField;
                        setDependentPicklistMapping(DepField.FieldName, NewDependentValue);
                        counter++;
                    }
            	}
            }    
            
            // Call anonymous function for the first level controlling and dependent picklist mapping
            setDependentPicklistMapping(ctrlfieldname, newValue);
            
            // Assign all the new values to the picklist fields
            var isReadOnly = false;
			for(var FieldIndex in fields) {
				var FieldVar = fields[FieldIndex];
                console.log('fieldvar'+FieldVar.FieldName);
				if(FieldVar && ResultFieldsMap[FieldVar.FieldName]) {
					FieldVar = ResultFieldsMap[FieldVar.FieldName];
					fields[FieldIndex] = FieldVar;
				}
                if(counter == 0 && ctrlfieldname == FieldVar.FieldName) {
                    FieldVar.FieldValue = newValue;
                    fields[FieldIndex] = FieldVar;
                }
                // SAL Mobility - Obligation - Manual value - Aman Porwal
                if(FieldVar.FieldName == "Loan_Type__c" && component.get("v.isNewRecord") == true && component.get("v.isSalMobilityFlow") == true)
                {
                    if(FieldVar.FieldReadOnly == true || FieldVar.FieldReadOnly == undefined)
                    {
                    	isReadOnly = true;
                    }
                }
                if(FieldVar.FieldName == "Identifier__c" && isReadOnly == true) 
                {
                    console.log('in identifier');
                    FieldVar.FieldValue = 'Manual';
                }
                // SAL Mobility - Obligation - Manual value - Aman Porwal
			}
            
            // Validate all the fields and set accessibility
            var validateField = async function() {
                helper.validateFieldHelper(component, event, helper, false);
            }
            var FunVar = validateField();
            
            ObjVar.fields = fields;          
            if(index) {
                ObjectList[index] = ObjVar;
                component.set("v.ObjectList", ObjectList);    
            } else {
                component.set("v.ObjectVar", ObjVar);
            }
            
        } catch(err) {
            console.log("Error in setDependentPicklistMapping --> " + err.message + " stack --> " + err.stack);
        }    
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called to set multi picklist values.
    * 						Gets the index of selected record.
    * 					  	Gets the unique field id from the markup.
    * 						Sets the multi picklist values.
    *   @version		: 	1.0
    */
    setMultiPicklistValues : function(component, event, helper) {
        try {
        	event.preventDefault();
            // Get the index of record and field name
            var index = event.currentTarget.dataset.index;
            var fieldname = event.currentTarget.dataset.fieldname;
            
            var ObjectList;
            var ObjVar;
            if(index != null) {
                ObjectList = component.get("v.ObjectList");
                ObjVar = ObjectList[index];
            } else {
                ObjVar = component.get("v.ObjectVar");
            }
            
            var FinalValues = '';
            var fields = ObjVar.fields;
            
            // Get the unique FieldId
            var FieldId;
            if(index) {
                FieldId = fieldname + "_multi_pick_" + index;    
            } else {
                FieldId = fieldname + "_multi_pick";
            }
            
            // Set all the values for multi picklist
            var PicklistProp = [];
            var selectedFieldList = document.getElementById(FieldId);
            for (var i = 0; i < selectedFieldList.length; i++) {           
                if (selectedFieldList.options[i].selected) {
                    FinalValues += selectedFieldList.options[i].value + ';';
                }
                PicklistProp.push({
                    label : selectedFieldList.options[i].value,
                    value : selectedFieldList.options[i].value,
                    selected : selectedFieldList.options[i].selected,
                    disabled : false
                });
            }
            
            // Set PicklistProp for multi picklist
            for(var FieldIndex in fields) {
                if(fields[FieldIndex].FieldName == fieldname) {
                    fields[FieldIndex].FieldValue = FinalValues;
                    fields[FieldIndex].PicklistProp = PicklistProp;
                    break;
                }
            }
            
            ObjVar.record[fieldname] = FinalValues;
            ObjVar.fields = fields; 
            
            if(index != null) {
                ObjectList[index] = ObjVar;
                component.set("v.ObjectList", ObjectList);
            } else {
                component.set("v.ObjectVar", ObjVar);    
            }
            
            // Validate all the fields and set accessibility
            var validateField = async function() {
                helper.validateFieldHelper(component, event, helper, false);
            }
            var FunVar = validateField();    
        } catch(err) {
            console.debug("Error in setMultiPicklistValues --> " + err.message + " stack --> " + err.stack);
        }
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called to validate all the required fields and to set accessibility.
    *   @version		: 	1.0
    */
    validateField : function(component, event, helper) {
        try {
        	event.preventDefault();
            var validateField = async function() {
                helper.validateFieldHelper(component, event, helper, false);
            }
            var FunVar = validateField();    
        } catch(err) {
            console.debug("Error in validateField --> " + err.message + " stack --> " + err.stack);
        }
   	},
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called to add error CSS class after getting error for specific field.
    *   @version		: 	1.0
    */
    handleError : function(component, event, helper) {
        try {
        	var ErrorComp = event.getSource();
        	$A.util.addClass(ErrorComp, "error");    
        } catch(err) {
            console.debug("Error in handleError --> " + err.message + " stack --> " + err.stack);
        }   
    },
	
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called to remove error CSS class after resolving error for specific field.
    *   @version		: 	1.0
    */
    handleClearError : function(component, event, helper) {
        try {
        	var ErrorComp = event.getSource();
        	$A.util.removeClass(ErrorComp, "error");    
        } catch(err) {
            console.debug("Error in handleClearError --> " + err.message + " stack --> " + err.stack);
        }   
    },
    
    /*YK
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called to close custom toast
    *   @version		: 	1.0
    */    
    closeParentSuccessToast: function (component, event, helper) {
		helper.closeSuccessToastHelper(component);
	},
	
    closeParentErrorToast: function (component, event, helper) {
		helper.closeErrorToastHelper(component);
	},
    
    closeParentInfoToast: function (component, event, helper) {
		helper.closeInfoToastHelper(component);
	}
})