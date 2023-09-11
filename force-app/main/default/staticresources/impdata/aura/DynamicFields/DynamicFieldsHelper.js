({
	/*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called when component is loaded as well as when new record is added. 
    * 						Gets field list passed through attribute which contains field configuration.
    * 						Calls getFieldWrapperList to get additional field configuration from apex.
    * 						Generates an array of JSON objects containing field configuration.
    * 						Gets existing records by calling getRecords.
    * 						Calls generateObjectJSON to generate final object JSON. 
    *   @version		: 	1.0
    */
    setRecords : function(component, isNewRecord) {      
        try {
            
            // Get object name and field properties passed through FieldList attribute
            var ObjectName = component.get("v.ObjectName");
            var SelectedFieldList = component.get("v.FieldList");
            //console.log('SelectedFieldList doinit'+SelectedFieldList);
			console.log("SelectedFieldList: ",JSON.stringify(SelectedFieldList));
            // Get additional field configuration from apex like picklist values / dependent picklist mappings / field types etc 
            this.getFieldWrapperList(component, ObjectName, JSON.stringify(SelectedFieldList), function(response) {
                console.log('state is'+response.getState());
                if(component.isValid() && response.getState() === "SUCCESS") {
                     var ResponseString = response.getReturnValue();
                     var FieldWrapperList = JSON.parse(ResponseString);
					 
                     var FieldNameList = [];        
                     var FieldPropertiesMap = new Object();
                     var NewRecord = new Object();
                     var RecordsList = [];
                     
                     // Generate FieldPropertiesMap which contains field name as key and field properties object as value
                     for(var FieldIndex in FieldWrapperList) {
                         if(FieldWrapperList[FieldIndex].FieldName) {
                             FieldNameList.push(FieldWrapperList[FieldIndex].FieldName);
                             FieldPropertiesMap[FieldWrapperList[FieldIndex].FieldName] = FieldWrapperList[FieldIndex];
                             if(isNewRecord) {
                                 NewRecord[FieldWrapperList[FieldIndex].FieldName] = FieldWrapperList[FieldIndex].FieldValue;
                             } else {
                                 // Start of changes - 22181
                                 if(FieldWrapperList[FieldIndex].FieldVisibleInModal) {
									 FieldWrapperList[FieldIndex].FieldValue = undefined;
								 }
								 // End of changes - 22181
                             }
                             // Start of changes - 22181
							 if(FieldWrapperList[FieldIndex].FieldName == "Opportunity__r.Approved_Loan_Amount__c") {
								 component.set("v.LoanAmount", FieldWrapperList[FieldIndex].FieldValue);
							 }
							 // End of changes - 22181
                         }
                     }
                    
                     var IdList = component.get("v.IdList");
                     var searchCriteria = null;
                     
                     if(isNewRecord) {
                         // Generate object JSON for new record directly
                         RecordsList.push(NewRecord);
                         this.generateObjectJSON(component, RecordsList, FieldWrapperList, isNewRecord);                    
                     } else {
                         // Generate object JSON for existing records
                         this.getRecords(component, ObjectName, FieldNameList, IdList, searchCriteria, function(response) {
                            if (component.isValid() && response.getState() === "SUCCESS") {
                                RecordsList = response.getReturnValue();
                                this.generateObjectJSON(component, RecordsList, FieldWrapperList, isNewRecord);
                                //SAL mobility change YK
                                if(component.get("v.ObjectName") == "Existing_Loan_Details__c" && component.get("v.isSalMobilityFlow") == true)
                                	this.hideObligationDeleteButton(component, component.get("v.ObjectList"));
                           		 /* CR 22307 s */
                                if((component.get("v.displayReadOnly") == true  || (component.get("v.page") == "pricing" && component.get("v.stageName") != 'Post Approval Sales')) && component.get("v.isSalMobilityFlow") == true){
									console.log("INSIDE THIS BIG IF CONDITION!",component.get("v.page"),component.get("v.isSalMobilityFlow"),component.get("v.flow"));
                                    this.disableButtons1(component, true);
                                    component.set("v.isReadOnlyPOSLA",true);
                                }
                                /* CR 22307  e*/
								// Added by Anurag for 22181 CR S
								
								if(component.get("v.flow") == 'ELA' && component.get("v.displayReadOnlyEmployeeLoan")){
									this.disableButtons1(component, true);
								}
								
								// Added by Anurag for 22181 CR E
                            } else {
                                console.debug(response.getState() + " --> " + response.getReturnValue());
                            }
                         }); 	   
                     }
                     component.set("v.FieldPropertiesMap", FieldPropertiesMap);
                }   
            });
        } catch(err) {
            console.debug("Error in setRecords --> " + err.message + " stack --> " + err.stack);
            //alert('Error in setRecords --> ' + err.message + '---- stack --> ' + err.stack);
        }	        
	},
    
   /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	method called to hide delete button if obligation record is created through CIBIL functionality. 
    *   @version		: 	1.0
    */
    
    hideObligationDeleteButton : function(component, objectList) {
        try
        {
            window.setTimeout(
                $A.getCallback(function() {
                    for(var i=0; i<objectList.length; i++)
                    {
                        
                        var recordVar = objectList[i].record;
                        if(recordVar)
                        {
                            
                            if(!recordVar.Identifier__c && recordVar.Identifier__c != undefined) 
                            {
                                
                                console.log('recordVar.Identifier --->> '+recordVar.Identifier__c);
                                var button = document.getElementById("oblig_delete_btn"+i);
                                button.style.visibility = 'hidden';
                            }
                        }
                    }
             	}), 1
             );
        }
        catch(err)
        {
            console.debug("Error in hideObligationDeleteButton --> " + err.message + " stack --> " + err.stack);
        }
    },
    
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called when component is loaded as well as when new record is added.
    * 						Calls getFieldWrapperList to get additional field configuration from apex. 
    *   @version		: 	1.0
    */
    getFieldWrapperList : function(component, ObjectName, FieldJSON, callback) {
        var action = component.get("c.getFieldWrapperList");
        action.setStorable();
        action.setParams({
			"ObjectName" : ObjectName,
            "FieldJSON" : FieldJSON
		});
        if(callback) {
        	action.setCallback(this, callback);
        }
        $A.enqueueAction(action);
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called when component is loaded as well as when new record is added.
    * 						Generates an array of JSON objects containing field configuration.
    *   @version		: 	1.0
    */
    generateObjectJSON : function(component, RecordsList, FieldWrapperList, isNewRecord) {       
        try {
           
            var ObjectName = component.get("v.ObjectName");
            var SelectedFieldList = FieldWrapperList;
            var setPicklistMapping = true; // Added for 22181
            
            var ObjectList = component.get("v.ObjectList");
            if(!isNewRecord) {
                ObjectList = [];
            }
            
            // Iterate over RecordsList to generate object JSON for existing records
            for(var Record in RecordsList) {
                var FieldValueList = [];
                var rec = RecordsList[Record];
                rec.sobjectType = ObjectName;
                
                // Create metadata for record to be inserted or updated
                var recordMetadata = {};
                recordMetadata["type"] = ObjectName;
                recordMetadata["url"] = "/services/data/v39.0/sobjects/" + ObjectName + "/" + rec["Id"];
                rec.attributes = recordMetadata;
                
                var PicklistProp = [];
                var JSONFields = {};
                
                // Set record id as null for new record
                if(isNewRecord) {
                    rec.Id = null;
                }
                
                // Iterate over SelectedFieldList to set field properties
                var PicklistValuesMapping = new Object();
                for(var Field in SelectedFieldList) {
				
                    var val;
                    var FieldName = SelectedFieldList[Field].FieldName;
                    var FieldVisibleInTable = SelectedFieldList[Field].FieldVisibleInTable;
                    var FieldVisibleInModal = SelectedFieldList[Field].FieldVisibleInModal;
                    // Check for field type REFERENCE
                    if(SelectedFieldList[Field].FieldType == 'REFERENCE') {
                        if(FieldName.includes(".Name")) {
                            // If related field is Name then remove Name and get actual field API name
                            FieldName = FieldName.replace(".Name", "");
                            if(rec[FieldName] != undefined && rec[FieldName] != null) {
                                val = rec[FieldName]['Name'];    
                            } else {
                                val = '';
                            }
                            if(FieldName.includes("__r")) {
                                FieldName = FieldName.replace("__r", "__c");    
                            } else {
                                FieldName = FieldName + 'Id';
                            }
                        } else {
                            // If related field is not Name then get multi level relationship list and iterate over that list
                            FieldVisibleInTable = false;
                            FieldVisibleInModal = false;
                            var FieldAPIList = FieldName.split(".");
                            var TempRec = rec;
                            if(TempRec && FieldAPIList) {
                                for(var i = 0; i < FieldAPIList.length; i++) {
                                    var FieldAPIName = FieldAPIList[i];
                                    if(TempRec && FieldAPIName) {
                                        TempRec = TempRec[FieldAPIName];    
                                    }
                                    if(i == FieldAPIList.length - 1) {
                                        val = TempRec;
                                    }
                                }
                            } else {
                                val = rec[FieldName];
                            }
                        } 
                    } else
                        if(SelectedFieldList[Field].FieldType == 'PICKLIST' || SelectedFieldList[Field].FieldType == 'MULTIPICKLIST') {
                            // Check for field type PICKLIST and MULTIPICKLIST
                            var PicklistValues;
                            val = rec[FieldName];
                            // For controlling picklist populate PicklistValues retrieved from apex
                            if(SelectedFieldList[Field].CtrlFieldName == null) {
                                PicklistValues = SelectedFieldList[Field].PicklistValues;
                                if(PicklistValues != undefined) {
                                    var old_index = PicklistValues.indexOf(val);
                                    var new_index = 0;
                                    if (new_index >= PicklistValues.length) {
                                        var k = new_index - PicklistValues.length;
                                        while ((k--) + 1) {
                                            PicklistValues.push(undefined);
                                        }
                                    }
                                    PicklistValues.splice(new_index, 0, PicklistValues.splice(old_index, 1)[0]);    
                                }
                            } else {
                                // For dependent picklist populate PicklistValues retrieved from apex and set controlling picklist value
                                var CtrlFieldName = SelectedFieldList[Field].CtrlFieldName;
                                
                                // Generate PicklistValuesMapping which contains controlling field and dependent field combination as key and DependentValues map as value
                                // Start of changes - 22181
								var CtrlValue = rec[CtrlFieldName];
								var DependentValuesMap = new Object();
                           
                                var tempMapping = component.get("v.PicklistValuesMapping");
                                if(tempMapping) {
                                    for(var fieldKey in tempMapping) {
                                        if(fieldKey == (CtrlFieldName + '-' + FieldName)) {
                                            DependentValuesMap = tempMapping[CtrlFieldName + '-' + FieldName];
                                        }   
                                    }
                                    setPicklistMapping = false;
                                } else {
                                    PicklistValuesMapping[CtrlFieldName + '-' + FieldName] = SelectedFieldList[Field].DependentValues;
                                    DependentValuesMap = SelectedFieldList[Field].DependentValues;
                                }
                                
                                PicklistValues = DependentValuesMap[CtrlValue];	
                                //console.log("CtrlFieldName :: " + CtrlFieldName + " CtrlValue :: " + CtrlValue + " FieldName :: " + FieldName + " PicklistValues :: " + JSON.stringify(PicklistValues));
                                // End of changes - 22181
                                
                                if(PicklistValues) {
                                    var old_index = PicklistValues.indexOf(val);
                                    var new_index = 0;
                                    if (new_index >= PicklistValues.length) {
                                        var k = new_index - PicklistValues.length;
                                        while ((k--) + 1) {
                                            PicklistValues.push(undefined);
                                        }
                                    }
                                    PicklistValues.splice(new_index, 0, PicklistValues.splice(old_index, 1)[0]);    
                                }
                            }
                            
                            // Generate PicklistProp list
                            if(SelectedFieldList[Field].FieldType == 'PICKLIST') {
                                PicklistProp.push({
                                    label : '--None--',
                                    value : '',
                                    selected : true,
                                    disabled : false
                                });    
                            }
                            for(var ValueIndex in PicklistValues) {
                                var value = PicklistValues[ValueIndex];
                                var selected = false;
                                if(val != undefined && val.includes(value)) {
                                    selected = true;
                                }
                                if(value) {
                                    PicklistProp.push({
                                        label : value,
                                        value : value,
                                        selected : selected,
                                        disabled : false
                                    });    
                                }
                            }
                        } else 
                            if(SelectedFieldList[Field].FieldType == 'DATE' || SelectedFieldList[Field].FieldType == 'DATETIME') {
                                // Check for field type DATE and DATETIME
                                val = rec[FieldName];
                                if(!val) {
                                    val = null;
                                } 
                            } else
                                if(SelectedFieldList[Field].FieldType == 'DOUBLE' || SelectedFieldList[Field].FieldType == 'INTERGER'){
                                    val = rec[FieldName];
                                } else {
                                    val = rec[FieldName];
                                    if(!val) { 
                                        val = '';
                                    }
                                }
                    
                    // Field type DATE and DATETIME change format
                    if(SelectedFieldList[Field].FieldValue) {
                        var formatDate = new Date(SelectedFieldList[Field].FieldValue);
                        if(formatDate.getTime() && isNaN(SelectedFieldList[Field].FieldValue)) {
                            var month = formatDate.getMonth() + 1;
                            if(month < 10) {
                                month = "0" + month;
                            }
                            var day = formatDate.getDate();
                            if(day < 10) {
                                day = "0" + day;
                            }
                            val = formatDate.getFullYear() + "-" + month + "-" + day;
                        } else {
                            val = SelectedFieldList[Field].FieldValue;
                        }
                    }
                    
                    if(SelectedFieldList[Field].PicklistProp) {
                        PicklistProp = SelectedFieldList[Field].PicklistProp;
                    }
                    
                    // Start of insurance flow logic
                    if(ObjectName == "DPLinsurance__c") {
                       	if(FieldName == "Insurer_Name__c") {
                       		val = rec["Insurer_Name__c"];
                            if(rec["App_Type__c"]) {
                                val = val + " - " + rec["App_Type__c"];
                            }
                       	}
                    } else
                        if(ObjectName == "Service_To_Sales__c") {
                            if(FieldName == "Nominee_Name__c" || FieldName == "Nominee_Relationship__c") {
                                val = rec[FieldName];
                                if(!val && rec["DPLinsurance__r." + FieldName]) {
                                    val = rec["DPLinsurance__r." + FieldName];
                                }
                            }
                        }
                    // End of insurance flow logic
                    
                    // Set all field properties
                    FieldValueList.push({
                        FieldValue : val,
                        CtrlFieldName : SelectedFieldList[Field].CtrlFieldName,
                        FieldName : FieldName,
                        FieldLabel : SelectedFieldList[Field].FieldLabel,
                        FieldType : SelectedFieldList[Field].FieldType,
                        PicklistProp : PicklistProp,
                        ParentObjName : SelectedFieldList[Field].ParentObjName,
                        FieldVisibleInTable : FieldVisibleInTable,
                        FieldVisibleInModal : FieldVisibleInModal,
                        FieldReadOnly : SelectedFieldList[Field].FieldReadOnly,
                        FieldRequired : SelectedFieldList[Field].FieldRequired,
                        FieldHide : SelectedFieldList[Field].FieldHide, // Added for 22181
                        FieldRequiredConditions : SelectedFieldList[Field].FieldRequiredConditions,
                        FieldReadOnlyConditions : SelectedFieldList[Field].FieldReadOnlyConditions,
                        FieldHideConditions : SelectedFieldList[Field].FieldHideConditions, // Added for 22181
                        FieldValidation : SelectedFieldList[Field].FieldValidation,
                        FieldSequence : SelectedFieldList[Field].FieldSequence
                    });
                    PicklistProp = []; // Empty the array
                }
                
                // Start of changes - 22181
                if(setPicklistMapping) {	
                 	component.set("v.PicklistValuesMapping", PicklistValuesMapping);   
                }
                // End of changes - 22181
                
                // Sort all field properties as per the sequence given in field JSON
                FieldValueList.sort(function (a, b) {
                    return a.FieldSequence - b.FieldSequence;
                });
                console.log("ObjectIndex: ",ObjectList.length);
                ObjectList.push({ 
                    selected : false,
                    editBtnDisabled : false,
                    deleteBtnDisabled : false,
                    viewBtnDisabled : false,
                    addMemBtnDisabled : false, // Only for insurance flow - 22181
					medQueBtnDisabled : false, // Only for insurance flow - 22181
                    record : rec, 
                    fields : FieldValueList
                });
            }
            console.log("ObjectIndex: ",ObjectList.length);
            if(isNewRecord) {
                // For new record set newly created JSON object in modal
                var ObjectIndex = ObjectList.length;
                //ObjectList[ObjectIndex - 1].fields=ObjectList[ObjectIndex - 2].fields;
                component.set("v.ObjectVar", ObjectList[ObjectIndex - 1]);
                component.set("v.Index", ObjectIndex - 1); 
                component.set("v.isOpen", true);
                
                // Start of changes - 22181
				component.set("v.isAddInsView", true);
				var objectListELA = ObjectList;
				component.set("v.ObjectListELA", objectListELA.pop());
				// console.log("objectListELA: ",JSON.stringify(objectListELA));
				// console.log("objectList: ",JSON.stringify(ObjectList));
				var objectListELANew = component.get("v.ObjectListELA");
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
				component.set("v.isAddInsView", false);
				// End of changes - 22181
            } else {
                // For existing records set ObjectList in table
                component.set("v.ObjectList", ObjectList);       
            }
            
            this.setTableHeight(component); // Set table height
            this.disableButtons(component, false); // Enable all buttons
            this.doneRendering(component); // Set default rendering flag 
            
            // Start of insurance flow logic
            if(ObjectName == "DPLinsurance__c" || ObjectName == "Service_To_Sales__c") {
                // Toggle buttons only for insurance flow
                this.toggleInsuranceButtons(component, ObjectName);
            }
            // End of insurance flow logic
        } catch(err) {
            console.debug("Error in generateObjectJSON --> " + err.message + " stack --> " + err.stack);
            //alert('Error in generateObjectJSON --> ' + err.message + '---- stack --> ' + err.stack);
        }
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called only for insurance flow.
    * 						Toggles edit, delete and view buttons for individual records.
    * 						Also toggles Add New, Save and Cancel button.
    *   @version		: 	1.0
    */
    toggleInsuranceButtons : function(component, ObjectName) {
        try {
        	var ObjectList = component.get("v.ObjectList");
            // Get constants stored in custom label
            var validationAttemptsLabel = $A.get("$Label.c.Insurance_Validation_Attempts");
            var networkErrorLabel = $A.get("$Label.c.Insurance_Validation_Network_Error_Code");
            var stageName, policyNumber, validateFlag, insProd;
            
            for(var ObjIndx in ObjectList) {
                var recordVar = ObjectList[ObjIndx].record;
                if(recordVar) {
                    if(ObjectName == "DPLinsurance__c") {
                        if(recordVar.Opportunity__r) {
                        	stageName = recordVar.Opportunity__r.StageName;    
                        }
                        policyNumber = recordVar.Policy_number__c;
                        validateFlag = recordVar.Validate_Insurance__c;
                        insProd = recordVar.Insurance_Product__c;
                    } else
                        if(ObjectName == "Service_To_Sales__c" && recordVar.DPLinsurance__r) {
                            if(recordVar.DPLinsurance__r.Opportunity__r) {
                            	stageName = recordVar.DPLinsurance__r.Opportunity__r.StageName;    
                            }
                            policyNumber = recordVar.DPLinsurance__r.Policy_number__c;
                        	validateFlag = recordVar.DPLinsurance__r.Validate_Insurance__c;
                        	insProd = recordVar.DPLinsurance__r.Insurance_Product__c;
                        }
                    
                    // Disable edit, delete and view buttons when following condition is satisfied
                    if(stageName == "Moved To Finnone" || policyNumber || validateFlag == "Y" || validateFlag == "P") {
                        ObjectList[ObjIndx].editBtnDisabled = true;
                        ObjectList[ObjIndx].deleteBtnDisabled = true;
                    }
                }
            }
            
            // Disable edit, delete and add new buttons when following condition is satisfied
            if(ObjectName == "DPLinsurance__c") {
				// console.log("stageName: "+stageName);
            	if(stageName == "Moved To Finnone") {
                    component.set("v.isDisabled", true);
                }    
            } else
                if(ObjectName == "Service_To_Sales__c") {
                    if(stageName == "Moved To Finnone" || policyNumber || validateFlag == "Y" || validateFlag == "P") {
                        component.set("v.isDisabled", true);
                    }
                }
            
            component.set("v.ObjectList", ObjectList);    
        } catch(err) {
            console.debug("Error in toggleInsuranceButtons --> " + err.message + " stack --> " + err.stack);
            //alert('Error in toggleInsuranceButtons --> ' + err.message + '---- stack --> ' + err.stack);
        }
    },
	
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is used to adjust table height which is displayed on UI.
    * 						Adjusts the height till number of records are less than or equal to DefaultRecords count.
    * 						Maximum number of records displayed are five. 
    * 						Table becomes scrollable for more than five records.
    *   @version		: 	1.0
    */
    setTableHeight : function(component) {
        try {
        
        	var ObjectList = component.get("v.ObjectList");
            // Default height for single row of table
            var CalculatedHeight = 100;
            if(component.get("v.isPosLaFlow")) {
                CalculatedHeight= 50;
            }
            // Get DefaultRecords count which indicates maximum rows after which table becomes scrollable
            var DefaultRecords = component.get("v.DefaultRecords");
             
            if(ObjectList && ObjectList.length > DefaultRecords) {
                // If number of rows are more than DefaultRecords then height of table is 300px
                CalculatedHeight = 300;
            } else {
                // If number of rows are less than DefaultRecords then height of table is calculated as per formula given below
                CalculatedHeight = CalculatedHeight * (ObjectList.length + 1); // One is added in ObjectList length for column headers
            }
            component.set("v.CalculatedHeight", CalculatedHeight);    
        } catch(err) {
            console.debug("Error in setTableHeight --> " + err.message + " stack --> " + err.stack);
            //alert('Error in setTableHeight -->  ' + err.message + '---- stack --> ' + err.stack);
        }    
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is used to set isDoneRendering flag once the component is rendered.
    *   @version		: 	1.0
    */
    doneRendering : function(component) {
        console.log("doneRendering!");
        if(!component.get("v.isDoneRendering")) {
            component.set("v.isDoneRendering", true);
        }
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is used to get all picklist values for selected object and field.
    *   @version		: 	1.0
    */
    getPicklistValues : function(component, ObjectName, FieldName, callback) {
    	var action = component.get("c.getPicklistValues");
        action.setParams({
			"ObjectName" : ObjectName,
            "FieldName" : FieldName
		});
        if(callback) {
        	action.setCallback(this, callback);
        }
        $A.enqueueAction(action);
	},
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is used to get all records for selected object and field based on IdList and searchCriteria.
    *   @version		: 	1.0
    */
    getRecords : function(component, ObjectName, FieldSet, IdList, searchCriteria, callback) {
    	var action = component.get("c.getRecords");
        action.setStorable();
        action.setParams({
			"ObjectName" : ObjectName,
            "FieldList" : FieldSet,
            "IdList" : IdList,
            "searchCriteria" : searchCriteria
		});
        if(callback) {
        	action.setCallback(this, callback);
        }
        $A.enqueueAction(action);
	},
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is used to execute business logic before deleting specific record.
    *   @version		: 	1.0
    */
    executeBusinessLogicBeforeDelete : function(component) {
        try {
        	// Add new logic here to be executed before delete
                
            this.generateRecordJSONforDelete(component);
            
            // Add new logic here to be executed after delete
        } catch(err) {
            console.debug("Error in executeBusinessLogicBeforeDelete --> " + err.message + " stack --> " + err.stack);
            //alert('Error in executeBusinessLogicBeforeDelete -->  ' + err.message + '---- stack --> ' + err.stack);
        }
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is used to execute business logic before updating / inserting specific record.
    *   @version		: 	1.0
    */
    executeBusinessLogicBeforeUpsert : function(component,event) {
        try {
            
            console.log('AP1'+component.get("v.ObjectName"));
            var ObjectName = component.get("v.ObjectName");
          	var ObjectVar = component.get("v.ObjectVar");
			console.log("ObjectVar: ", JSON.stringify(ObjectVar));
			var recordVar = ObjectVar.record;
			var FieldsList = ObjectVar.fields;
            var prem;
            var sumAssured;
            var proceedBREFlag = true;
            // Only for Insurance section on DSS/Old screens
            if(ObjectName == "DPLinsurance__c") {
                // Add new logic here to be executed before add/save
                
				// Logic to Set 'Saved via Lightning' Component Flag 
                for(var FieldIndx in FieldsList) {
					var FieldVar = FieldsList[FieldIndx];
					if(FieldVar.FieldName == 'Saved_Via_Lightning__c')
						FieldVar.FieldValue = true;
                    // Added by Supriya for Reverse calculator
                   
                    if(FieldVar.FieldName == 'Premium_Amount__c')
                        prem = FieldVar.FieldValue;
                    if(FieldVar.FieldName == 'Sum_Assured__c')
                        sumAssured = FieldVar.FieldValue;
				}
				console.log('Validation rule calling...');
                for(var FieldIndx in FieldsList) {
                    var FieldVar = FieldsList[FieldIndx];
                    if(FieldVar.FieldName == 'Insurance_Product__c')
                    {		
                        console.log('Validation rule calling Insurance_Product__c...');
                        if(FieldVar.FieldValue =="HDFC CREDIT PROTECTION PLUS" || FieldVar.FieldValue == "HDFC CREDIT PROTECTION") 
                        
                        {
                            console.log('Validation rule calling Insurance_Product__c...');
                            
                            console.log('Validation rule calling HDFC...');
                            if((prem && sumAssured) || (!prem && !sumAssured)){
                                console.log('Validation rule calling Premium_Amount__c...');
                              	proceedBREFlag = false;
                                // Display error message
                                var title = "Error";
                                var message = "";
                                if(!prem && !sumAssured){
                                    message = "Please enter sum assured amount or premium amount";
                                }
                                else if(prem && sumAssured){
                                    message = "Only one field to be entered either Premium or Sum Assured";
                                }
                                var type = "error";
                                var fadeTimeout = 3000;
                                this.displayMessage(component, title, message, type, fadeTimeout, true);
                                this.disableButtons(component, false); // Enable all buttons
                            }                                                      
				}
				
                    }
                }
                //console.log('AP2');
                
                // Start of changes - 13076
                var myContentHomePredFlag = false;
                for(var FieldIndx in FieldsList) {
                    
					var FieldVar = FieldsList[FieldIndx];
					if(FieldVar.FieldName == 'Insurance_Product__c')
                    {
                          if(FieldVar.FieldValue =="CONTENT - MY HOME")
                          {
                              proceedBREFlag = false;
                              myContentHomePredFlag = true;
                          }
                    }		    
				}
                if(myContentHomePredFlag)
                {
                    var premMapAttribute = component.get("v.MyContenHomePremMap");
                    var action = component.get("c.getPremiumMyContentHome");
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        if(state === "SUCCESS"){
                            var premMap = response.getReturnValue();
                            console.log('Premium Table'+JSON.stringify(premMap));
                            component.set("v.MyContenHomePremMap",premMap);
                             var sumInsuredOptionVal;
                            var policyTenureVal;
                            var proceedUpsert = false;
                            for(var FieldIndx in FieldsList) {
                                var FieldVar = FieldsList[FieldIndx];
                                if(FieldVar.FieldName == 'Sum_Insured__c')
                                    sumInsuredOptionVal = FieldVar.FieldValue;
                                if(FieldVar.FieldName == 'Policy_Tenure__c')
                                    policyTenureVal = FieldVar.FieldValue;
                            }
                            for(var FieldIndx in FieldsList) {
                                var FieldVar = FieldsList[FieldIndx];
                                if(FieldVar.FieldName == 'Sum_Assured__c')
                                    FieldVar.FieldValue = sumInsuredOptionVal;
                                if(FieldVar.FieldName == 'Insurance_term__c')
                                    FieldVar.FieldValue = policyTenureVal;
                                if(FieldVar.FieldName == 'Premium_Amount__c')
                                {
                                    var premJSON = component.get("v.MyContenHomePremMap");
                                    var premTable = JSON.stringify(premJSON);
                                    if(sumInsuredOptionVal in premJSON)
                                    {
                                        if(premJSON[sumInsuredOptionVal].length >=  policyTenureVal)
                                        {
                                            FieldVar.FieldValue = premJSON[sumInsuredOptionVal][policyTenureVal-1];
                                            proceedUpsert = true;
                                        }
                                    }
                                    if(!proceedUpsert)
                                    {
                                        // Display error message
                                        var errorMessage = "Premium Amount cannot be calculated for given Sum Insured Option ("+sumInsuredOptionVal+") and Policy Tenure ("+policyTenureVal+") !"; 
                                        var title = "Error";
                                        var message = errorMessage;
                                        var type = "error";
                                        var fadeTimeout = 3000;
                                        this.displayMessage(component, title, message, type, fadeTimeout, true);
                                        
                                        this.disableButtons(component, false); // Enable all buttons
                                        // Start of insurance flow logic
                                        if(ObjectName == "DPLinsurance__c") {
                                            // This is called only for insurance flow which toggles all buttons
                                            this.toggleInsuranceButtons(component, ObjectName);
                                        }
                                        
                                    }
                                    
                                }
                            }
                            if(proceedUpsert)
                            {   
                                this.generateRecordJSONforUpsert(component); 
                            }
                        }
                        else
                        {
                            Console.log('Error in loading static resource from Apex !');
                        }                         
                    });
                    $A.enqueueAction(action);
                       
                    }
                // End  of changes - 13076

				
                // Call BRE to get Premium Amount, update Premium_Amount__c and then save records by calling saveRecords() in InsuranceBRECallout()

                if(proceedBREFlag){
                this.InsuranceBRECallout(component);
                    console.log('Validation rule callout..');
                }	
                // Add new logic here to be executed after add/save 
            }
            //YK changes for SAL Mobility..
            else if(ObjectName == "Existing_Loan_Details__c")
            {
                console.log('calling SAL mobility...');
                this.SalMobilityLogic(component);
            } 
            else {
                // Add new logic here to be executed before add/save
                
                // For non other objects call saveRecords() directly
                this.generateRecordJSONforUpsert(component,event);
                
                // Add new logic here to be executed after add/save
            }
        } catch(err) {
            console.debug("Error in executeBusinessLogicBeforeUpsert --> " + err.message + " stack --> " + err.stack);
            //alert('Error in executeBusinessLogicBeforeUpsert -->  ' + err.message + '---- stack --> ' + err.stack);
        }
    },
    
    /*YK
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is used to execute business logic before updating / inserting specific Obligation record.
    *   @version		: 	1.0
    */
    SalMobilityLogic : function(component) {
        try 
        {
            
            var ObjectList = component.get("v.ObjectList");
            var ObjectVar = component.get("v.ObjectVar");
            var ObjectIndex = component.get("v.Index");
            var FieldsList = ObjectVar.fields;
            var MOB = new Date();
            var emiValue = 0;
            var emiValueDec,emiValueDer;
            // Bug 18680 start YK
            var isValid = true;
            // Bug 18680 end
            for(var FieldIndx in FieldsList)
            {
                var FieldVar = FieldsList[FieldIndx];
                if(FieldVar.FieldName == "Start_On__c") {
                    var startDate = new Date(FieldVar.FieldValue);
                    // Bug 18680 start YK
                    if(startDate > new Date())
                    {
                        isValid = false;
                        var title = "Warning";
                        var message = "Start date cannot be a future date.";
                        var type = "warning";
                        var fadeTimeout = 3000;
                        this.displayMessage(component, title, message, type, fadeTimeout, true);
                        this.disableButtons(component, false);
                    }
                    // Bug 18680 end
                     //844 start
					 if(component.get("v.isSalMobilityFlow") == true){
					  MOB = (new Date().getMonth() - startDate.getMonth() + (12 * (new Date().getFullYear() - startDate.getFullYear()))) ;
                     }else //844 stop
                    MOB = (new Date().getMonth() - startDate.getMonth() + (12 * (new Date().getFullYear() - startDate.getFullYear()))) - 1;
                }else 
                    if(FieldVar.FieldName == "Customer_Declared_EMI__c")
                    {
                        emiValueDec = FieldVar.FieldValue;
                    }
                else 
                    if(FieldVar.FieldName == "Derived_EMI__c")
                    {
                        emiValueDer = FieldVar.FieldValue;
                    }
            }
            if(!$A.util.isEmpty(emiValueDec))
                emiValue = emiValueDec;
            else if(!$A.util.isEmpty(emiValueDer))
                emiValue = emiValueDer;
            console.log('MOB --->> '+MOB);
            for(var FieldIndx in FieldsList)
            {
                var FieldVar = FieldsList[FieldIndx];
                if(FieldVar.FieldName == "MOB__c") {
                    console.log('inside mob assignment...');
                    FieldVar.FieldValue = MOB;
                }
                if(FieldVar.FieldName == "EMI__c") {
                    console.log('inside EMI__c assignment...');
                    FieldVar.FieldValue = emiValue;
                }
                // Removed Identifier value as Manual from here.
                FieldsList[FieldIndx] = FieldVar;
            }    
            ObjectVar.fields = FieldsList;
            if(ObjectVar && ObjectIndex) { 
                ObjectList[ObjectIndex] = ObjectVar;
            }
            // Call generateRecordJSONforUpsert to generate JSON of record which is to be saved
            component.set("v.ObjectVar", ObjectVar);
            component.set("v.ObjectList", ObjectList);
            // Bug 18680 start YK
            if(isValid == true)
            	this.generateRecordJSONforUpsert(component,event);
            // Bug 18680 end YK
        } catch(err) {
            console.log("Error in SalMobilityLogic --> " + err.message + " stack --> " + err.stack);
            //alert('Error in SalMobilityLogic --> ' + err.message + '---- stack --> ' + err.stack);
        }
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is used to call BRE to get premium amount.
    * 						Used only for insurance flow. 
    * 						Generates a map of all BRE parameters.
    * 						Gets the response from getCalloutResponse.
    * 						Saves Premium Amount.
    * 						Calls generateRecordJSONforUpsert to generate JSON of record which is to be saved.
    *   @version		: 	1.0
    */
    InsuranceBRECallout : function(component) {
        try {
            var ObjectList = component.get("v.ObjectList");
            var ObjectVar = component.get("v.ObjectVar");
            var ObjectIndex = component.get("v.Index");
            var ParamsMap = new Object();
            var FieldsList = ObjectVar.fields;
			var InsuranceId = ObjectVar.record.Id;
            ParamsMap["InsuranceId"] = InsuranceId;
			
            var flow = component.get("v.flow"); // Added for 22181
            
            // Generate a map of all BRE parameters
            for(var FieldIndx in FieldsList) {
                var FieldVar = FieldsList[FieldIndx];
				/*if(FieldVar.FieldName =="Opportunity__r.Approved_Loan_Amount__c"){
					console.log('VAl::'+FieldVar.FieldValue+ typeof FieldVar.FieldValue);
					console.log('VAl::'+parseFloat(FieldVar.FieldValue).toFixed(4));
					//loanTenure
				}*/
                switch(FieldVar.FieldName) {
                    case "Insurance_Product__c" : ParamsMap["InsuranceProduct"] = FieldVar.FieldValue; 
                        ParamsMap["insuranceName"] = FieldVar.FieldValue;
                        ParamsMap["insurance_name"] = FieldVar.FieldValue; //IPRUGLS
                        continue;
                    case "Insurance_Type__c" : ParamsMap["InsuranceType"] = FieldVar.FieldValue; continue;
                    case "Sum_Assured__c" : ParamsMap["sumAssuredAmount"] = FieldVar.FieldValue;
                        if(FieldVar.FieldValue && FieldVar.FieldValue > 0) {
                        	ParamsMap["sumInsuredAssured"] = FieldVar.FieldValue;    
                        } continue;
                        
                    case "Plan_Option__c" : ParamsMap["planType"] = FieldVar.FieldValue;
                        if(ParamsMap["InsuranceProduct"] == "HDFC GROUP HEALTH SHIELD") {
                        	ParamsMap["planOption"] = FieldVar.FieldValue;    
                        }
                        ParamsMap["Plan_Opted__c"] = FieldVar.FieldValue; continue;
                    case "Opportunity__r.Account.Date_of_Birth__c" : ParamsMap["dob"] = FieldVar.FieldValue;
                        ParamsMap["Date_of_Birth__c"] = FieldVar.FieldValue;
                        ParamsMap["dateOfBirthIHG"] = FieldVar.FieldValue; continue;
                    case "Product_Offerings__r.Lead__r.DOB_Cibil__c" : ParamsMap["dob"] = FieldVar.FieldValue; 
                        ParamsMap["Date_of_Birth__c"] = FieldVar.FieldValue;
                        ParamsMap["dateOfBirthIHG"] = FieldVar.FieldValue; continue;
                    
                    case "Opportunity__r.Approved_Loan_Amount__c" : ParamsMap["originalLoanAmount"] = parseFloat(parseFloat(FieldVar.FieldValue).toFixed(4)); continue; // Math.round(FieldVar.FieldValue * 10000) / 10000; continue;
                    case "Product_Offerings__r.Offer_Amount__c" : ParamsMap["originalLoanAmount"] = parseFloat(parseFloat(FieldVar.FieldValue).toFixed(4)); continue;
                    case "Product_Offerings__r.Id" : ParamsMap["uniqueId"] = FieldVar.FieldValue;
                        ParamsMap["uniqueID"] = FieldVar.FieldValue;
                        ParamsMap["id"] = FieldVar.FieldValue; continue;
                        
                    case "Sum_Assured_Type__c" : ParamsMap["sumAssuredType"] = FieldVar.FieldValue; continue;
                    case "Policy_Tenure__c" : 
                        ParamsMap["policyTenure"] = FieldVar.FieldValue;
                        ParamsMap["policyTerm"] = FieldVar.FieldValue;
                        continue;
                    case "Opportunity__r.Loan_Application_Number__c" : ParamsMap["uniqueId"] = FieldVar.FieldValue; 
                        ParamsMap["uniqueID"] = FieldVar.FieldValue; 
                        ParamsMap["id"] = FieldVar.FieldValue; continue;  
                        
                    case "DOB_of_Dependent_Life__c" : ParamsMap["dobDependentLife"] = FieldVar.FieldValue; continue;
                    case "DOB_of_Policyholder1__c" : ParamsMap["dobFirstLife"] = FieldVar.FieldValue; continue;
                    case "Plan__c" : 
                        if(ParamsMap["InsuranceProduct"] != "HDFC GROUP HEALTH SHIELD") {
                        	ParamsMap["planOption"] = FieldVar.FieldValue;    
                        }
                        ParamsMap["memberCovers"] = FieldVar.FieldValue;
                        var plan = FieldVar.FieldValue;
                        if(plan) {
                            plan = plan.substring(0, plan.indexOf("-"));
                            if(plan) {
                                plan = plan.toUpperCase().trim();
                                ParamsMap["PLAN__c"] = plan;
                            }	
                        } continue; 
                        
                      //Added By Supriya for reverse calcultor
                      
                        console.log('premium amount start..');   	
		            case "Premium_Amount__c" : 
                        if(ParamsMap["InsuranceProduct"] == "HDFC CREDIT PROTECTION" || ParamsMap["InsuranceProduct"]=="HDFC CREDIT PROTECTION PLUS"  ) {
                        	ParamsMap["premiumAmount"] = parseInt(FieldVar.FieldValue);    
						}continue; 
                       
                       console.log('premium amount end..');
                        
                    case "Sum_Insured__c" : ParamsMap["Sum_Insured_Options__c"] = FieldVar.FieldValue;
                        ParamsMap["sumInsuredIHG"] = FieldVar.FieldValue;
                        if(FieldVar.FieldValue && FieldVar.FieldValue > 0) {
                        	ParamsMap["sumInsuredAssured"] = FieldVar.FieldValue;    
                        } continue;
                    case "HdfcCppType__c" : if(FieldVar.FieldValue) {
                                                ParamsMap["lifeInsType"] = FieldVar.FieldValue.toLowerCase();
                                            } continue;
                    case "Insurer_Name__c" : ParamsMap["insurerName"] = FieldVar.FieldValue; continue;
                    
                    case "Opportunity__c" : ParamsMap["LoanId"] = FieldVar.FieldValue;
                         ParamsMap["loan_Id"] = FieldVar.FieldValue;  //IPRUGLS
                        if(FieldVar.FieldValue) {
                            ParamsMap["isPOFlow"] = false;
                        } else {
                            ParamsMap["isPOFlow"] = true;
                        } continue;
					case "Opportunity__r.Product__c" : ParamsMap["productType"] = FieldVar.FieldValue; continue;
                    case "Product_Offerings__r.Products__c" : ParamsMap["productType"] = FieldVar.FieldValue; continue;
                        
                    case "Opportunity__r.Tenor__c" : ParamsMap["loanTenure"] = FieldVar.FieldValue; continue;
                    case "Product_Offerings__r.Tenor__c" : ParamsMap["loanTenure"] = FieldVar.FieldValue; continue;
                    case "Critical_Illness__c" : ParamsMap["criticalIllness"] = FieldVar.FieldValue; continue;
					
					case "Product_Offerings__r.Lead__c" : ParamsMap["LeadId"] = FieldVar.FieldValue; continue;
					case "Ambulance_Cover__c" : ParamsMap["ambulanceCover"] = FieldVar.FieldValue; continue;
					case "Deductible_Amount__c" : ParamsMap["deductibleAmt"] = FieldVar.FieldValue; continue;
                }
            }
            console.log("typeof originalLoanAmount: "+ typeof ParamsMap["originalLoanAmount"]+": "+ParamsMap["originalLoanAmount"]);
            // Start of HTS Calculator Phase 2 changes
            var ObjectName = component.get("v.ObjectName");
            console.log('ObjectName'+ObjectName);
            // Calculate proposal date
            //Proposal date start
            var d = new Date();
            if(ObjectName == 'DPLinsurance__c' && ObjectVar.record.Id) {
                console.log('Created Date :: ' + ObjectVar.record.CreatedDate);
				console.log('ObjectVar Id :: ' + ObjectVar.record.Id);
                d = new Date(ObjectVar.record.CreatedDate);
                console.log('date -->'+d);
            }
            //Proposal date stop
            var month = '' + (d.getMonth() + 1);
            var day = '' + d.getDate();
            var year = d.getFullYear();
            
            if (month.length < 2) month = '0' + month;
            if (day.length < 2) day = '0' + day;
            var finalDate = [year, month, day].join('-');
            ParamsMap["proposalDate"] = finalDate;
            
            ParamsMap["resourceName"] = "HTS_Calculator_WADL_Resource";
            
            var sumInsuredPrdArray = ["PREMIUM PERSONAL GUARD", "PROFESSIONAL INDEMNITY FOR DOCTORS", "AGE AGNOSTIC", "PERSONAL ACCIDENT", "BAGIC EXTRA CARE PLUS", "CPP SHIELD", "CPP LIV CARE", "BAGIC FAMILY HEALTH CARE"];
            var sumInsuredOption, insuranceTerm, sumAssuredPrdFlag = false, cppWalletPrdFlag = false, cppShieldPrdFlag = false, cppLifeCarePrdFlag = false, bagicExtraCarePlusFlag = false, hdfcCreditPrdFlag = false;
            // sumAssuredTagName added for Reverse Calculator
			var endpoint, path, premiumTagName, sumAssuredTagName, errorTagName, insProd, cblDOB, nrmlDOB, planValue, premOption, sumOption, isMortgageProduct= false, bhflIHOFlag = false;//added premOption and sumOption for Bug:22426
            //Bug:23777
			var bhflCppLyfPremFlag = false, cppPremOption, cppSumOption;
            for(var FieldIndx in FieldsList) {
                var FieldVar = FieldsList[FieldIndx];
                // console.log('in path');
				if(FieldVar.FieldName == "Opportunity__c") console.log("Opportunity__c: "+ FieldVar.FieldValue);
                if(FieldVar.FieldName == "Insurance_Product__c") {
                    if(sumInsuredPrdArray.indexOf(FieldVar.FieldValue) > -1){
                        sumAssuredPrdFlag = true;
                    }
                    
                    if(FieldVar.FieldValue) {
						var regex = new RegExp(" ", "g");
                    	insProd = FieldVar.FieldValue.replace(regex, "_");    
                    }
                	path = "HTS_Calculator_WADL_Resource/HTS_Calculator_WADL/" + insProd + "/" + insProd + "_Request.txt";
                	
                    switch(FieldVar.FieldValue) {
                        case "HDFC CREDIT PROTECTION" :
                            endpoint = $A.get("$Label.c.InsuranceHTSCalculatorLabel");
                            premiumTagName = "premiumPayable";
							sumAssuredTagName = "finalSumAssured";
							hdfcCreditPrdFlag = true;
                            errorTagName = "errorMessage";
                            break;
                            
                        case "HDFC CREDIT PROTECTION PLUS" :
                            endpoint = $A.get("$Label.c.InsuranceHTSCalculatorLabel");
                            premiumTagName = "premiumPayable";
							sumAssuredTagName = "finalSumAssured";
							hdfcCreditPrdFlag = true;
                            errorTagName = "errorMessage";
                            break;
                            
                        case "BAGIC EXTRA CARE":
                            endpoint = $A.get("$Label.c.BagicCalloutLabel");
                            premiumTagName = "finalPremium";
                            errorTagName = "errorMessage";
                            break;
                            
                        case "BAGIC EXTRA CARE PLUS" :
                            bagicExtraCarePlusFlag = true;
                            break;
                            
                        case "WALLET PROTECT" :
                            cppWalletPrdFlag = true;
                            break;
                            
                        case "CPP SHIELD" :
                            cppShieldPrdFlag = true;
                            break;
                            
                        case "CPP LIV CARE" :
                            cppLifeCarePrdFlag = true;
                            break;
                            
                        case "I PRU GLS" :
                            endpoint = $A.get("$Label.c.ICICI_Prudential_endpoint");
                            premiumTagName = "totalPremium";
                            errorTagName = "errorMessage";
                            break;
                            
                        default:
                            endpoint = $A.get("$Label.c.HTSCalculatorEndpoint");
                            premiumTagName = "finalPremium";
                            errorTagName = "errorMessage";
                            break;
                    }    
                	ParamsMap["path"] = path;
                    ParamsMap["endpoint"] = endpoint;
                    ParamsMap["premiumTagName"] = premiumTagName;
					ParamsMap["sumAssuredTagName"] = sumAssuredTagName;
                    ParamsMap["errorTagName"] = errorTagName;
                    console.log('path -->'+path);
                    console.log('endpoint -->'+endpoint);
                }
                
                if(FieldVar.FieldName == "Sum_Insured__c" && sumAssuredPrdFlag) {
                    sumInsuredOption = FieldVar.FieldValue;
                }
                
				if(FieldVar.FieldName == "Policy_Tenure__c") {
                    insuranceTerm = FieldVar.FieldValue;
                }
				
                if(FieldVar.FieldName == "Product_Offerings__r.Lead__r.DOB_Cibil__c" && FieldVar.FieldValue) {
					cblDOB = FieldVar.FieldValue;					
				}
                
				if(FieldVar.FieldName == "Product_Offerings__r.Lead__r.DOB__c" && FieldVar.FieldValue) {	
					nrmlDOB = FieldVar.FieldValue;	
				}
				if(FieldVar.FieldName == "Plan__c" && cppWalletPrdFlag) {
					planValue = FieldVar.FieldValue;
					console.log("planValue: ",planValue);
				}
				//Bug:22426 Start
				var loanPrdct = component.get("v.product");
                var labelVal = $A.get("$Label.c.MortgageProductsLabel");
                //console.log('Parameter map::'+ ParamsMap["InsuranceProduct"]);
                if(labelVal.includes(loanPrdct))
					isMortgageProduct = true;
				
				if(isMortgageProduct && ParamsMap["InsuranceProduct"]=='BHFL IHO PROPERTY CARE'){
                    bhflIHOFlag = true;
                }
				//console.log('isMortgageProduct::'+isMortgageProduct);
                //console.log('loanPrdct::'+loanPrdct);
                if(bhflIHOFlag){
                    if(FieldVar.FieldName == "IHO_Premium_Amount__c" && FieldVar.FieldValue)
                        premOption = FieldVar.FieldValue;
                    var path = $A.get("$Resource.IHO_Prem_and_sumAssured");
                    var req = new XMLHttpRequest();
                    req.open("GET", path, false);
                    req.send(null);
                    if (req.status === 200) {
                        //console.log('Static resource status -->' , JSON.parse(req.response));
                        var staticRes = req.response;
                        var requiredData = insuranceTerm +'-'+premOption;
                        var obj = JSON.parse(staticRes, function (key, value) {
                            if (requiredData && key == requiredData) {
                                sumOption = value;
                            }
                        });
                    }
                    console.log('Calculated sumOption::'+sumOption);
                }
                //Bug:22426 End
				
				//Bug:23777 S
				if(isMortgageProduct && ParamsMap["InsuranceProduct"]=='BHFL CPP LIFE CARE'){
                    bhflCppLyfPremFlag = true;
                }
				if(bhflCppLyfPremFlag){
                    if(FieldVar.FieldName == "BHFL_CPP_LYF_CARE_Premium_Amt__c" && FieldVar.FieldValue)
                        cppPremOption = FieldVar.FieldValue;
                    
                    var resPath = $A.get("$Resource.BHFL_Cpp_Prem_nd_sumAssured");
                    var request = new XMLHttpRequest();
                    request.open("GET", resPath, false);
                    request.send(null);
                    if (request.status === 200) {
                        //console.log('Static resource status -->' , JSON.parse(req.response));
                        var statResource = request.response;
                        var requiredInput = insuranceTerm +'-'+cppPremOption;
                        var objct = JSON.parse(statResource, function (key, value) {
                            if (requiredInput && key == requiredInput) {
                                cppSumOption = value;
                            }
                        });
                    }
                    console.log('Calculated CPP sumOption::'+cppSumOption);
                }
				//Bug:23777 E
                FieldsList[FieldIndx] = FieldVar;
            }
            console.log('outside fieldlist');
            if(nrmlDOB) {
                ParamsMap["dob"] = nrmlDOB;
                ParamsMap["Date_of_Birth__c"] = nrmlDOB;
                ParamsMap["dateOfBirthIHG"] = nrmlDOB;
            } else 
                if(cblDOB) {
                    ParamsMap["dob"] = cblDOB;
                	ParamsMap["Date_of_Birth__c"] = cblDOB;
                	ParamsMap["dateOfBirthIHG"] = cblDOB;
                }
            // End of HTS Calculator Phase 2 changes
            
			var isValid = true;
			var msg;
			
            var CPPProducts = $A.get("$Label.c.CPPShield_Products");
            var proType = ParamsMap["productType"];
            var insProduct = ParamsMap["InsuranceProduct"];
			var msg = "Cannot create Insurance for CPP SHIELD if Product Type is "+proType;
            if(!CPPProducts.includes(proType) && insProduct == "CPP SHIELD") {
                isValid = false;
            }
			
			// Only to make deductible amount mandatory when insurance product is BAGIC EXTRA CARE PLUS	
			if(bagicExtraCarePlusFlag && (ParamsMap["deductibleAmt"] === undefined || ParamsMap["deductibleAmt"] === "0")) {
				isValid = false;
				msg = "Deductible amount cannot be zero for BAGIC EXTRA CARE PLUS!";
			}
            
			if(isValid) {
				// Pass the map of all BRE parameters and get response
				this.getCalloutResponse(component, ParamsMap, function(response) {
					console.log("ISVALID! ", JSON.stringify(response));
					if(component.isValid() && response.getState() === "SUCCESS") {
						var ResponseMap = response.getReturnValue();
						var premiumAmount = ResponseMap[premiumTagName];
                        var sumAssured = ResponseMap[sumAssuredTagName];
                        console.log("sumAssured: "+typeof sumAssured+": "+sumAssured+" "+parseInt(sumAssured));
                        var premiumAmountParams = ResponseMap["premiumAmountParams"];
                        console.log("premiumAmountParams! ", JSON.stringify(premiumAmountParams));
						var errorMessage = ResponseMap[errorTagName];
						console.log("errorMessage --> " + JSON.stringify(errorMessage));
						console.log("premiumAmountParams: "+premiumAmountParams);
						console.log("premiumAmount: "+typeof premiumAmount+": "+premiumAmount);
						
						console.log("hdfcCreditPrdFlag: "+typeof hdfcCreditPrdFlag+": "+hdfcCreditPrdFlag);
						console.log("ResponseMap --> " + JSON.stringify(ResponseMap));
						if(errorMessage) {
							if(errorMessage == "Exception") {
								errorMessage = "Premium calculation service is not available! Please refresh the page and try again!";    
							} else {
								if(ParamsMap["InsuranceProduct"] == "BAGIC COMPREHENSIVE CARE" && ResponseMap["isCKYCRequired"]) {
									var occupationWindow = window.open("/apex/ValidateOccupationCKYC?RecordId=" + ResponseMap["RecordId"] + "&flow=" + ResponseMap["flow"], "Update Occupation For BAGIC COMPREHENSIVE CARE", "toolbar=yes,scrollbars=yes,resizable=yes,top=200,left=200,width=500,height=500");
								}
							}
							// Display error message
							var title = "Error";
							var message = errorMessage;
							var type = "error";
							var fadeTimeout = 3000;
							this.displayMessage(component, title, message, type, fadeTimeout, true);
							
							this.disableButtons(component, false); // Enable all buttons
							// Start of insurance flow logic
							if(ObjectName == "DPLinsurance__c") {
								// This is called only for insurance flow which toggles all buttons
								this.toggleInsuranceButtons(component, ObjectName);
							}
							// End of insurance flow logic			
						} else {
							
							if(ParamsMap["InsuranceProduct"] == "BAGIC EXTRA CARE PLUS") {
								var memberMatching = ResponseMap["memberMatching"];
								if(memberMatching) {
									// Display warning message
									component.set("v.validationMsg", null);
								} else {
									var validationMsg = component.get("v.validationMsg");
									var newMsg = "Please add all members to calculate premium for BAGIC EXTRA CARE PLUS";
									if(validationMsg) {
										validationMsg = validationMsg + "\n" + newMsg;
									} else {
										validationMsg = newMsg;	
									}
                                   
									component.set("v.validationMsg", validationMsg);
								}
							}
							
							// Store value in Premium_Amount__c field
							var FieldsList = ObjectVar.fields;
							for(var FieldIndx in FieldsList) {
								
								var FieldVar = FieldsList[FieldIndx];
                                    if(FieldVar.FieldName == "Premium_Amount__c") {
									// Configuration for CPP WALLET PROTECT
									// console.log("Premium_Amount__c");
									if(cppWalletPrdFlag) { 
										FieldVar.FieldValue = planValue;
                                        console.log("FieldVar.FieldValue: ",FieldVar.FieldValue);
                                    }//Bug:22426 S 
									else if(premOption && bhflIHOFlag){
                                        FieldVar.FieldValue = premOption;
                                    }//Bug:22426 E
									//Bug:23777 S 
									else if(cppPremOption && bhflCppLyfPremFlag){
                                        FieldVar.FieldValue = cppPremOption;
                                    }//Bug:23777 E
									else {
											if(!hdfcCreditPrdFlag){
												FieldVar.FieldValue = premiumAmount;
											}
										}
										if(hdfcCreditPrdFlag && parseInt(sumAssured) == 0){
											console.log("CAME HERE FOR PREMIUM");
										FieldVar.FieldValue = premiumAmount;
									}
									if(cppShieldPrdFlag) {
										var CPPPremAmt = $A.get("$Label.c.CPPShield_PreAmt");
										var CPPAmtArr = CPPPremAmt.split(";");
										for(var amtIndx in CPPAmtArr) {
                                            amtIndx = CPPAmtArr[amtIndx];
											var type_amt = amtIndx.split("=");
											if(type_amt[0] == proType) {
												FieldVar.FieldValue = type_amt[1];
											}
										}
									}
									if(cppLifeCarePrdFlag) {
										var CPPPremAmt = $A.get("$Label.c.CPPLifeCare_PreAmt");
										var CPPAmtArr = CPPPremAmt.split(";");
										for(var amtIndx in CPPAmtArr) {
                                            amtIndx = CPPAmtArr[amtIndx];
											var type_amt = amtIndx.split("=");
											if(type_amt[0] == sumInsuredOption) {
												FieldVar.FieldValue = type_amt[1];
											}
										}
									}
								}
								if(FieldVar.FieldName == "Sum_Assured__c") {
									if(sumAssuredPrdFlag && sumInsuredOption) {
										FieldVar.FieldValue = sumInsuredOption;    
									}
                                    // Start of changes - 22181
									if(cppWalletPrdFlag && flow == "ELA") {
										FieldVar.FieldValue = 1;			
									}
									// End of changes - 22181
									//Bug:22426 S
									else if(sumOption && bhflIHOFlag){
	                                    FieldVar.FieldValue = sumOption;
									}
									//Bug:22426 E
									//Bug:23777 S 
									else if(cppSumOption && bhflCppLyfPremFlag){
										FieldVar.FieldValue = cppSumOption;
									}//Bug:23777 E
									// Added by Supriya
									else if(hdfcCreditPrdFlag && parseInt(premiumAmount) == 0){
										console.log("CAME HERE FOR SUM ASSURED");
										FieldVar.FieldValue = sumAssured;
									}
								} else
									if(FieldVar.FieldName == "Insurance_term__c") {
										FieldVar.FieldValue = insuranceTerm;
									} else
                                        if(FieldVar.FieldName == "Premium_Amount_Params__c") {
                                            FieldVar.FieldValue = premiumAmountParams;
                                        }
								
								FieldsList[FieldIndx] = FieldVar;
							}
							
							ObjectVar.fields = FieldsList;
							if(ObjectVar && ObjectIndex) { 
								ObjectList[ObjectIndex] = ObjectVar;
							}
							// Call generateRecordJSONforUpsert to generate JSON of record which is to be saved
							component.set("v.ObjectVar", ObjectVar);
							component.set("v.ObjectList", ObjectList);
							this.generateRecordJSONforUpsert(component,event);    
						}
					} else {
						// Display error message
						var title = "Error";
						var message = "Unable to calculate premium! Please refresh the page and try again!";
						var type = "error";
						var fadeTimeout = 3000;
						this.displayMessage(component, title, message, type, fadeTimeout, true);
						
						this.disableButtons(component, false); // Enable all buttons
						// Start of insurance flow logic
						if(ObjectName == "DPLinsurance__c") {
							// This is called only for insurance flow which toggles all buttons
							this.toggleInsuranceButtons(component, ObjectName);
						}
						// End of insurance flow logic
					}
				});	
			} else {
				// Display error message
				var title = "Error";
				var message = msg;
				var type = "error";
				var fadeTimeout = 3000;
				this.displayMessage(component, title, message, type, fadeTimeout, true);
				
				this.disableButtons(component, false); // Enable all buttons
				if(ObjectName == "DPLinsurance__c") {
					// This is called only for insurance flow which toggles all buttons
					this.toggleInsuranceButtons(component, ObjectName);
				}
			}
        } catch(err) {
            console.debug("Error in InsuranceBRECallout --> " + err.message + " stack --> " + err.stack);
            //alert('Error in InsuranceBRECallout --> ' + err.message + '---- stack --> ' + err.stack);
        }
    },  
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is used to generate JSON structure for record to be inserted / updated.
    * 						Passes generated JSON structure to saveRecords which makes call to apex.
    * 						In case of failure error message is displayed.
    * 						In case of success formula fields are retrieved by calling getRecords again.
    * 						All the disabled buttons are enabled again.
    * 						Success message is displayed if any.
    *   @version		: 	1.0
    */
    generateRecordJSONforUpsert : function(component,event) {
        try {
            var ObjectList = component.get("v.ObjectList");
            var ObjectVar = component.get("v.ObjectVar");
            var ObjectName = component.get("v.ObjectName");
            var ObjectIndex, cppShieldFlag = false;
            
            // Get selected record index
            if(ObjectVar) {
                ObjectVar.selected = true;
                ObjectIndex = component.get("v.Index");  
                ObjectList[ObjectIndex] = ObjectVar;
            }
            
            // Generate JSON structure for record to be inserted / updated
            var SelectedRecords = [];
            
            for(var ObjIndx in ObjectList) {
                if(ObjectList[ObjIndx].selected) {
                    var FieldsArr = ObjectList[ObjIndx].fields;
                    var recordVar = ObjectList[ObjIndx].record;
                    
                    for(var field in FieldsArr) {
                        var FieldVar = FieldsArr[field];
                        if(FieldVar.FieldValue || FieldVar.FieldValue == 0) {
                            var tempVal = FieldVar.FieldValue;
                            recordVar[FieldVar.FieldName] = tempVal;
                        } else {
                            recordVar[FieldVar.FieldName] = null;
                        }
						if(FieldVar.FieldValue == "CPP SHIELD") {
							cppShieldFlag = true;
						}
                        
						if(cppShieldFlag) { 
							if(FieldVar.FieldName == "Policy_Tenure__c") {
								FieldVar.FieldValue = "1";
								recordVar[FieldVar.FieldName] = FieldVar.FieldValue;
							}
						}
                        FieldsArr[field] = FieldVar;
                    }
                    SelectedRecords.push(recordVar);
                    ObjectList[ObjIndx].fields = FieldsArr;
                    ObjectList[ObjIndx].record = recordVar;
                    ObjectList[ObjIndx].selected = false;
                }    
            }
            // Pass generated JSON structure to apex for insert / update
            this.saveRecords(component,event,SelectedRecords, function(response) {
                console.log("SelectedRecords: "+JSON.stringify(SelectedRecords));
                if(component.isValid() && response.getState() === "SUCCESS") {
					console.log("Details has been saved successfully 1!");
                    var ResponseArray = response.getReturnValue();
                    if(ResponseArray && ResponseArray.length > 0) {
						console.log("Details has been saved successfully 2!");
                        if(typeof ResponseArray[0] === "string") {
							console.log("Details has been saved successfully 3!");
                            // In case of error returned type is string which contains error message
                            var errorMsg = ResponseArray[0];
                            var indx;
                            console.log("errorMsg --> " + errorMsg); 
                            if(errorMsg) {
                            	indx = errorMsg.indexOf(",");
                                if(indx >= 0) {
                                	errorMsg = errorMsg.substring(indx + 1);
                                }
                            }
                            
                            if(errorMsg) {
                            	indx = errorMsg.indexOf(":");
                                if(indx >= 0) {
                            		errorMsg = errorMsg.substring(0, indx);
                                }    
                            }
                            // Display error message
                            var title = "Error";
                            var message = errorMsg;
                            var type = "error";
                            var fadeTimeout = 3000;
                            this.displayMessage(component, title, message, type, fadeTimeout, false);
                            
                            this.disableButtons(component, false); // Enable all buttons
                            component.set("v.isValidRecord", false); // Set isValidRecord to false in case of error from server
                            
                            // Start of insurance flow logic
                            if(ObjectName == "DPLinsurance__c" || ObjectName == "Service_To_Sales__c") {
                                // This is called only for insurance flow which toggles all buttons
                                this.toggleInsuranceButtons(component, ObjectName);
                            }
                            // End of insurance flow logic
                        } else {
                            // In case of success returned type is list of records
                            
                            // Start of insurance flow logic
                            if(ObjectName == "DPLinsurance__c") {
                                // This is called only for insurance flow which toggles all buttons
                                this.validatePremium(component);
                            }
                            // End of insurance flow logic
                            
                            ObjectVar.record = ResponseArray[0];
                            var TempFieldNameList = component.get("v.FieldPropertiesMap");
                            var FieldNameList = [];
                            for(var FieldIndx in TempFieldNameList) {
                                var FieldVar = TempFieldNameList[FieldIndx];
                                if(FieldVar.FieldType == "FORMULA" || (ObjectName == "Existing_Loan_Details__c" && FieldVar.FieldName == "Derived_EMI__c")) {
                                    FieldNameList.push(FieldVar.FieldName);
                                }
                            }
                          //  var IdList = component.get("v.IdList");
                          	var IdList = [];
                            IdList.push(ObjectVar.record.Id);  
                            
                            
                            var searchCriteria = null;
                            // In case of success returned type is list of records
                            this.getRecords(component, ObjectName, FieldNameList, IdList, searchCriteria, function(response) {
                                if(component.isValid() && response.getState() === "SUCCESS") {
                                    var ResponseArray = response.getReturnValue();
                                    if(ResponseArray && ResponseArray.length > 0) {
                                        var recordVar = ResponseArray[0];
                                        var FieldList = ObjectVar.fields;
                                        // Get all values for formula fields
                                        for(var FieldIndx in FieldList) {
                                            var FieldVar = FieldList[FieldIndx];
                                            if(FieldVar.FieldType == "FORMULA" || (component.get("v.ObjectName") == "Existing_Loan_Details__c" && FieldVar.FieldName == "Derived_EMI__c")) {
                                                FieldVar.FieldValue = recordVar[FieldVar.FieldName];
                                                FieldList[FieldIndx] = FieldVar;
                                            }
                                        }
                                        
                                        ObjectVar.fields = FieldList;
                                        if(ObjectVar && ObjectIndex) {
                                            ObjectList[ObjectIndex] = ObjectVar;
                                        }
                                        component.set("v.ObjectVar", ObjectVar);
                                        component.set("v.ObjectList", ObjectList);
                                            
                                        //this.setRecords(component,false);// bug 19708
                                        // Display success message
                                        var title = "Success";
                                        var message = "Details has been saved successfully!";
                                        var type = "success";
                                        var fadeTimeout = 3000;
                                        /*17138 s*/
                                        if(component.get("v.flow") == "mobility2" || component.get("v.flow") == "ELA") { // Added condition for 22181
                                            component.set("v.isOpen", false);
                                            // Set isViewRecord flag to false which indicates view mode is closed
                                            component.set("v.isViewRecord", false);
                                        }
                                        /*17138 e*/
										
                                        this.displayMessage(component, title, message, type, fadeTimeout, true);
                                        
                                        this.disableButtons(component, false); // Enable all buttons
                                        
                                        // Start of insurance flow logic
                                        if(ObjectName == "DPLinsurance__c" || ObjectName == "Service_To_Sales__c") {
                                            // This is called only for insurance flow which toggles all buttons
                                            this.toggleInsuranceButtons(component, ObjectName);                                            
                                        }
                                        // End of insurance flow logic
                                        
                                        //YK POS LA 17664 start
                                        if(component.get("v.isInsurancePosLaFlow") == true || component.get("v.flow") == "ELA") // ELA added by Anurag for 22181 23390
                                        {
                                          	console.log("CAME TO SAVE!");
                                            this.firePassInsuranceEvent(component, component.get("v.ObjectList"));
                                        }
                                        //YK POS LA 17664 end
                                        
                                        //YK SAL mobility changes
                                        if(ObjectName == "Existing_Loan_Details__c" && component.get("v.isSalMobilityFlow") == true)
                                        {
                                            this.fireSalMobilityEvent(component, ObjectVar.record.Id);
                                       /*     //fire event for CAM updation..
                                            var compEvents = component.getEvent("salMobileFlowEvent");
                                            compEvents.setParams({ "obligationRecordId" : ObjectVar.record.Id });
                                            compEvents.fire();
                                            console.log('ObjectVar.record.Id ----->> '+ObjectVar.record.Id);
                                       */
                                        }
                                    }	
                                } else {
                                    // Display error message
                                    var title = "Error";
                                    var message = "Something went wrong, please refresh the page and try again!";
                                    var type = "error";
                                    var fadeTimeout = 3000;
                                    this.displayMessage(component, title, message, type, fadeTimeout, true);
                                    
                                    this.disableButtons(component, false); // Enable all buttons
                                    // Start of insurance flow logic
                                    if(ObjectName == "DPLinsurance__c" || ObjectName == "Service_To_Sales__c") {
                                        // This is called only for insurance flow which toggles all buttons
                                        this.toggleInsuranceButtons(component, ObjectName);
                                    }
                                    // End of insurance flow logic
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
								}
								// End of changes - 22181
                            });    
                        }
                    } else {
                        // Display error message
                        var title = "Error";
                        var message = "No response from server!";
                        var type = "error";
                        var fadeTimeout = 3000;
                        this.displayMessage(component, title, message, type, fadeTimeout, true);
                        
                        this.disableButtons(component, false); // Enable all buttons
                        // Start of insurance flow logic
                        if(ObjectName == "DPLinsurance__c" || ObjectName == "Service_To_Sales__c") {
                            // This is called only for insurance flow which toggles all buttons
                            this.toggleInsuranceButtons(component, ObjectName);
                        }
                        // End of insurance flow logic
                    }
                } else {
                    // Display error message
                    var title = "Error";
                    var message = "Something went wrong, please refresh the page and try again!";
                    var type = "error";
                    var fadeTimeout = 3000;
                    this.displayMessage(component, title, message, type, fadeTimeout, true);
                    
                    this.disableButtons(component, false); // Enable all buttons
                    // Start of insurance flow logic
                    if(ObjectName == "DPLinsurance__c" || ObjectName == "Service_To_Sales__c") {
                        // This is called only for insurance flow which toggles all buttons
                        this.toggleInsuranceButtons(component, ObjectName);
                    }
                    // End of insurance flow logic
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
					// location.reload();
                }
                // End of changes - 22181
               if((flow == "ELA" || component.get("v.isSalMobilityFlow") == true) && component.get("v.ObjectName")=='DPLinsurance__c')
				{
					// console.log('in if'+component.get("v.recordId"));
					this.calculateEmi(component,event,component.get("v.recordId"));//added by hrushikesh
					// alert('ok ');
				}
            });
        } catch(err) {
            console.debug("Error in generateRecordJSONforUpsert --> " + err.message + " stack --> " + err.stack);
            //alert('Error in generateRecordJSONforUpsert --> ' + err.message + '---- stack --> ' + err.stack);
        }   
    },
    
    firePassInsuranceEvent : function(component, insuranceList)
    {
        var compEvents = $A.get("e.c:PassInsuranceListEvent");//$A.getEvent("passInsuranceListEvt");
        console.log('firePassInsuranceEvent ===>> '+compEvents);
        compEvents.setParams({ "insuranceList" : insuranceList });
        compEvents.fire();
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is used to validate premium as per right sum assured.
    * 						Called only for insurance flow.
    * 						Displays warning message when premium amount for insurance record exceeds specific percent of approved loan amount. 
    *   @version		: 	1.0
    */
    validatePremium : function(component) {
        try {
           	var ObjectVar = component.get("v.ObjectVar");
            var recordVar = ObjectVar.record;
            var premiumAmt = recordVar["Premium_Amount__c"];
            var insProduct = recordVar["Insurance_Product__c"];
            var approvedAmt;
            var product;
            
     //       alert(premiumAmt+''+''+approvedAmt)
            // Get values for Approved_Loan_Amount__c and Product__c
            if(recordVar) {
            	approvedAmt = recordVar["Opportunity__r.Approved_Loan_Amount__c"];
            	product = recordVar["Opportunity__r.Product__c"];    
            }
            
            // Labels are commented to make them available when component is loaded
            // $Label.c.Default_insurance_premium
			// $Label.c.SPL_insurance_premium
            
            // Get product wise custom label
            var percent;
            var labelName = product + "_insurance_premium";
            var dynamicLabel = '';
            dynamicLabel = $A.get("$Label.c." + labelName);
           // alert($A.get("$Label.c." + labelName));
            if(!isNaN(dynamicLabel) && dynamicLabel) {
                percent = dynamicLabel;
            } else {
                // If product wise custom label is not found then get default custom label
                var labelName = "Default_insurance_premium";
                dynamicLabel = $A.get("$Label.c." + labelName);
                if(dynamicLabel) {
                    percent = dynamicLabel;
                }
            }
            // Display validation message when insurance premium amount is more than specific percentage of approved loan amount
            //alert('prem am -- '+premiumAmt+' approvedAmt-- '+approvedAmt+' percent---- '+percent);
            if(premiumAmt && approvedAmt && percent) {
                if(parseFloat(premiumAmt) > parseFloat(approvedAmt) * parseFloat(percent) / 100) {
					var validationMsg = ""; //component.get("v.validationMsg");
                    // POS LA 17664 start
                    if(component.get("v.isInsurancePosLaFlow") == true)
                    {	
                        var approvedInsuranceRate = component.get("v.posLaApprInsurance");
                        var newMsg = insProduct + " insurance with premium Rs. " + premiumAmt + " exceeds " + approvedInsuranceRate + "% of the approved loan amount";
                    }// POS LA 17664 end
                    else
                    	var newMsg = insProduct + " insurance with premium Rs. " + premiumAmt + " exceeds " + percent + "% of the approved loan amount";
					if(validationMsg) {
						validationMsg = validationMsg + "\n" + newMsg;
					} else {
						validationMsg = newMsg;	
					}
                  
                  
                  	component.set("v.validationMsg", validationMsg);    
                  
					
                } else {
					var validationMsg = component.get("v.validationMsg");
					if(validationMsg && !validationMsg.includes("BAGIC EXTRA CARE PLUS")) {
						component.set("v.validationMsg", null);	
					}
                }
            } else {
				var validationMsg = component.get("v.validationMsg");
                if(validationMsg && !validationMsg.includes("BAGIC EXTRA CARE PLUS")) {
					component.set("v.validationMsg", null);	
				}
            } 
        } catch(err) {
            console.debug("Error in validatePremium --> " + err.message + " stack --> " + err.stack);
            //alert('Error in validatePremium -->  ' + err.message + '---- stack --> ' + err.stack);
        }
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is used to generate JSON structure for record to be deleted
    * 						Removes the deleted record from ObjectList. 
    *   @version		: 	1.0
    */
    generateRecordJSONforDelete : function(component) {
        try {
            var ObjectVar;
            var ObjectIndex = component.get("v.Index");
            var ObjectList;
            
            // Get the index of selected record
            if(ObjectIndex) {
            	ObjectList = component.get("v.ObjectList");
                ObjectVar = ObjectList[ObjectIndex];
            	ObjectVar.selected = true;
            	ObjectList[ObjectIndex] = ObjectVar;
            }    
             
            var SelectedRecords = [];
            for(var obj in ObjectList) {
                if(ObjectList[obj].selected) {           	
                    var recordVar = ObjectList[obj].record;
                    SelectedRecords.push(recordVar);
                    ObjectList[obj].selected = false;
                }    
            }
            
            // Remove the deleted element from list
            ObjectList.splice(ObjectIndex, 1);
            component.set("v.ObjectList", ObjectList);
            this.deleteRecords(component, SelectedRecords);
        } catch(err) {
            console.debug("Error in generateRecordJSONforDelete --> " + err.message + " stack --> " + err.stack);
            //alert('Error in generateRecordJSONforDelete -->  ' + err.message + '---- stack --> ' + err.stack);
        }
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is used to call apex to insert / update records. 
    *   @version		: 	1.0
    */
    saveRecords : function(component,event, SelectedRecords, callback) {       
      //var tr=  {label: "--None--", value: "", selected: true, disabled: false};
		console.log("Details has been!", JSON.stringify(callback));
        var action = component.get("c.upsertRecords");
        action.setParams({
            "JSONData" : JSON.stringify(SelectedRecords)
		});
        
        if(callback) {
          
        	action.setCallback(this, callback);
        }
        
        $A.enqueueAction(action);
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is used to call apex to delete records. 
    *   @version		: 	1.0
    */
    deleteRecords : function(component, SelectedRecords) {
        var action = component.get("c.deleteRecords");
        action.setParams({
            "JSONData" : JSON.stringify(SelectedRecords)
		});
        action.setCallback(this, function(response) {
            if (component.isValid() && response.getState() === "SUCCESS") {                  
                var result = response.getReturnValue();
                var title = "Success";
                var message = "Details has been deleted successfully!";
                var type = "success";
                var fadeTimeout = 3000;
                this.displayMessage(component, title, message, type, fadeTimeout, true);
                
                //YK POS LA 17664 start
                if(component.get("v.isInsurancePosLaFlow") == true || component.get("v.flow") == "ELA") // ELA addded by Anurag for 22181 23390
                    this.firePassInsuranceEvent(component, component.get("v.ObjectList"));
                //YK POS LA 17664 end
                
                //YK SAL mobility changes
                if(component.get("v.ObjectName") == "Existing_Loan_Details__c" && component.get("v.isSalMobilityFlow") == true)
                {
                    this.fireSalMobilityEvent(component, SelectedRecords[0].Id);
                }
                            var flow = component.get("v.flow");
                if((flow == "ELA" || component.get("v.isSalMobilityFlow") == true) && component.get("v.ObjectName")=='DPLinsurance__c')
			{
				// console.log('in if'+component.get("v.recordId"));
				this.calculateEmi(component,event,component.get("v.recordId"));//added by hrushikesh
                alert('calculate emi on delete ');
			}
            } else {
                var title = "Error";
                var message = "Something went wrong, please refresh the page and try again!";
                var type = "error";
                var fadeTimeout = 3000;
                this.displayMessage(component, title, message, type, fadeTimeout, true);
            }
        });
        $A.enqueueAction(action);
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is used to validate all the required fields.
    * 						Calls disableFields helper to disable fields if any.
    * 						Calls toggleAppointeeNameAndDOB only for insurance flow.
    *   @version		: 	1.0
    */
    validateFieldHelper : function(component, event, helper, allFields) {
        try {
            event.preventDefault();
            var FieldCompList = component.find("field_inp");
            var ObjectName = component.get("v.ObjectName");
            var FieldPropertiesMap = component.get("v.FieldPropertiesMap");
            var FieldValuesMap = new Object();
            var isValidRecord = true;
            // Iterate over all the fields and check validation for required fields
            // Mobility changes YK
      //      for(var FieldIndx in FieldCompList) {
      		for(var i=0; i<FieldCompList.length; i++){
                var RequiredField = FieldCompList[i];
                if(RequiredField) {
                    FieldValuesMap[RequiredField.get("v.label")] = RequiredField;
                }
                var FieldName = RequiredField.get("v.label");
                var FieldVar = FieldPropertiesMap[FieldName];
                
                if(allFields) {
                	if(RequiredField.get("v.required") && !RequiredField.get("v.value")) {
                        // If the field is required and value is not entered then display error message
                        RequiredField.set("v.errors", [{message : "* This field is required!"}]);
                        isValidRecord = false;
                    } else {
                        RequiredField.set("v.errors", null);
                        if(FieldVar && FieldVar.FieldValidation) {
                            // If the field is not required or value is entered then check for any regular expression given for the field
                            var regex = new RegExp(FieldVar.FieldValidation, 'gi');
                            var FieldValue = '';
                            if(RequiredField.get("v.value")) {
                                FieldValue = RequiredField.get("v.value").toString();
                            }
                            
                            if(FieldValue && regex && !regex.test(FieldValue)) {
                                // If the regular expression given for the field does not match then display error message
                                RequiredField.set("v.errors", [{message : "Please enter valid " + FieldVar.FieldLabel + "!"}]);
                                isValidRecord = false;
                            } else {
                                // If the regular expression given for the field matches then remove error message
                                RequiredField.set("v.errors", null);
                            }
                        }
                    }    
                }
            }
                
            // Only for lookup fields since we do not use ui component to display lookups
            var error_pnl = component.find("error_pnl");
            if(error_pnl && allFields) {
                if(!Array.isArray(error_pnl)) {
                    if(error_pnl) {
                        error_pnl.set("v.value", "* This field is required!");
                        var lookup_div = document.getElementsByClassName("lookup_div_cls");
                        for(var i = 0; i < lookup_div.length; i++) {
                            var DivVar = lookup_div[i];
                            $A.util.removeClass(DivVar, "lookup_div_cls");
                            $A.util.addClass(DivVar, "error");
                        }     
                        isValidRecord = false;
                    } else {
                        var lookup_div = document.getElementsByClassName("lookup_div_cls");
                        for(var i = 0; i < lookup_div.length; i++) {
                            var DivVar = lookup_div[i];
                            $A.util.removeClass(DivVar, "error");
                            $A.util.addClass(DivVar, "lookup_div_cls");
                        } 
                    }
                } else {
                    for(var pnlIndx in error_pnl) {
                        var ErrPnlVar = error_pnl[pnlIndx];
                        if(ErrPnlVar) {
                            ErrPnlVar.set("v.value", "* This field is required!");
                            var lookup_div = document.getElementsByClassName("lookup_div_cls");
                            for(var i = 0; i < lookup_div.length; i++) {
                                var DivVar = lookup_div[i];
                                $A.util.removeClass(DivVar, "lookup_div_cls");
                                $A.util.addClass(DivVar, "error");
                            }  
                            isValidRecord = false;
                        } else {
                            var lookup_div = document.getElementsByClassName("lookup_div_cls");
                            for(var i = 0; i < lookup_div.length; i++) {
                                var DivVar = lookup_div[i];
                                $A.util.removeClass(DivVar, "error");
                                $A.util.addClass(DivVar, "lookup_div_cls");
                            } 
                        }    
                    }
                }
            }
            
            // Call disableFields to disable fields if any
            this.disableFields(component, FieldValuesMap, allFields);
			
			if(ObjectName == "Service_To_Sales__c") {
				//Bug #25146 S - Field Mandatory check
				var reqFldArr = ['Relationship__c'];
				for(var i=0; i<FieldCompList.length; i++){
					var RequiredField = FieldCompList[i];
					var FieldName = RequiredField.get("v.label");
					if(reqFldArr.indexOf(FieldName) > -1 && RequiredField.get("v.required") && RequiredField.get("v.value") == '--None--'){
						isValidRecord = false;
					}
				}
				//Bug #25146 E
			}
			
            // isValidRecord flag indicates final status of record before saving
            component.set("v.isValidRecord", isValidRecord);
            
            // Only for Insurance Flow
            if(ObjectName == "DPLinsurance__c") {
                // Make appointee name and appointee dob required if nominee age is less than 18
            	//this.toggleAppointeeNameAndDOB(component, FieldValuesMap, allFields);
            }
            
            // Add your helpers here
            
            isValidRecord = component.get("v.isValidRecord");
            // Display error message
            if(allFields && !isValidRecord) {
            	var title = "Alert";
                var message = "Please fill all the mandatory fields!";
                var type = "error";
                var fadeTimeout = 3000;
                this.displayMessage(component, title, message, type, fadeTimeout, true);    
            }
        } catch(err) {
            console.debug("Error in validateFieldHelper --> " + err.message + " stack --> " + err.stack);
            //alert('Error in validateFieldHelper --> ' + err.message + '---- stack --> ' + err.stack);
        }    
   	},
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is used to make appointee name and appointee dob required if nominee age is less than 18.
    *   @version		: 	1.0
    */
    toggleAppointeeNameAndDOB : function(component, FieldValuesMap, allFields) {
        try {
            if(allFields) {
            	var NomineeDOBField = FieldValuesMap["Nominee_DOB__c"];
                var NomineeDOBValue;
                if(NomineeDOBField) {
                    NomineeDOBValue = NomineeDOBField.get("v.value");
                    if(NomineeDOBValue) {
                        NomineeDOBValue = new Date(NomineeDOBValue); 
                    }
                }
                var today_date = new Date();
                var today_year = today_date.getFullYear();
                var today_month = today_date.getMonth();
                var today_day = today_date.getDate();
                var age;
                // Calculate nominee age from nominee dob
                if(NomineeDOBValue) {
                    age = today_year - NomineeDOBValue.getFullYear();
                    if(today_month < (NomineeDOBValue.getMonth() - 1)) {
                        age--;   
                    }
                    if(((NomineeDOBValue.getMonth() - 1) == today_month) && (today_day < NomineeDOBValue.getDate())) {
                        age--;    
                    }
                    
                    var AppointeeName = FieldValuesMap["Appointee_Name__c"];
                    var AppointeeDOB = FieldValuesMap["Appointee_DOB__c"];
                    
                    // Make appointee name and appointee dob required if nominee age is less than 18
                    if(!isNaN(age) && age > 0 && age < 18) {
                        if(!AppointeeName.get("v.disabled") && !AppointeeName.get("v.value")) {
                            AppointeeName.set("v.errors", [{message : "* This field is required!"}]);
                            component.set("v.isValidRecord", false);
                        } else {
                            AppointeeName.set("v.errors", null);
                        }
                        if(!AppointeeDOB.get("v.disabled") && !AppointeeDOB.get("v.value")) {
                            AppointeeDOB.set("v.errors", [{message : "* This field is required!"}]);
                            component.set("v.isValidRecord", false);
                        } else {
                            AppointeeDOB.set("v.errors", null);
                        }
                    } else {
                        AppointeeName.set("v.errors", null);
                        AppointeeDOB.set("v.errors", null);
                    }
                }    
            }    
        } catch(err) {
            console.debug("Error in toggleAppointeeNameAndDOB --> " + err.message + " stack --> " + err.stack);
            //alert('Error in toggleAppointeeNameAndDOB --> ' + err.message + '---- stack --> ' + err.stack);
        }
	},
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is used to disable fields as per the configuration mentioned in the input JSON.
    *   @version		: 	1.0
    */
    disableFields : function(component, FieldValuesMap, allFields) {
        try {
            var ObjectIndex = component.get("v.Index");
            var ObjectVar = component.get("v.ObjectVar");
            var allowDisable = false;
            var allowHide = false, sliderFlag = false; // Bug - 22181
            var enabledFieldsCount = 0;
            var filledFieldsCount = 0;
            
            // First anonymous function to parse string to boolean 
            var parseBoolStr = function (str) {
                var expressions = {};
                var expressionRegex = new RegExp("\\((?:(?:!*true)|(?:!*false)|(?:&&)|(?:\\|\\|)|\\s|(?:!*\\w+))+\\)");
                var expressionIndex = 0;
                str = str.trim();
                while (str.match(expressionRegex)) {
                    var match = str.match(expressionRegex)[0];
                    var expression = 'boolExpr' + expressionIndex;
                    str = str.replace(match, expression);
                    match = match.replace('(', '').replace(')', '');
                    expressions[expression] = match;
                    expressionIndex++;
                }
                
                // Second anonymous function to parse string to boolean
                var evalBoolStr = function (str2, expressions2) {
                    // Third anonymous function to parse string to boolean
                    var toBoolean = function (str3, expressions3) {
                        var inversed = 0;
                        while (str3.indexOf('!') === 0) {
                            str3 = str3.replace('!', '');
                            inversed++;
                        }
                        var validity;
                        if (str3.indexOf('boolExpr') === 0) {
                            validity = evalBoolStr(expressions3[str3], expressions3);
                        } else if (str3 == 'true') {
                            validity = str3 == 'true';
                        } else if (str3 == 'false') {
                            validity = str3 != 'false';
                        }
                        for (var i = 0; i < inversed; i++) {
                            validity = !validity;
                        }
                        return validity;
                    }
                    
                    var conditions = str2.split(' ');
                    if (conditions.length > 0) {
                        var validity = toBoolean(conditions[0], expressions2);
                        for (var i = 1; i + 1 < conditions.length; i += 2) {
                            var comparer = conditions[i];
                            var value = toBoolean(conditions[i + 1], expressions2);
                            switch (comparer) {
                                case '&&':
                                    validity = validity && value;
                                    break;
                                case '||':
                                    validity = validity || value;
                                    break;
                            }
                        }
                        return validity;
                    }
                    return 'Invalid input';
                }
                return evalBoolStr(str, expressions);
            }
            
            if(ObjectVar) {
                var FieldList = ObjectVar.fields;
                for(var FieldIndx in FieldList) {
                    var FieldVar = FieldList[FieldIndx];
                    var FieldCon;
                    
                    // If FieldRequiredConditions is given then check for required property first
                    if(FieldVar.FieldRequiredConditions) {
                        FieldCon = FieldVar.FieldRequiredConditions;
                        if(FieldCon) {
                            var ConArray = FieldCon.ConditionsArray;
                            var ConResultMap = new Object();
                            //YK
                            //for(var ConIndx in ConArray) {
                            for(var i=0; i<ConArray.length; i++){
                                var ConVar = ConArray[i];
                                var FieldName = ConVar.FieldName;
                                var FieldValues = ConVar.FieldValues;
                                FieldValues = FieldValues.map(function(x) { 
                                    return x.toUpperCase(); 
                                });
                                
                                var FieldVal;
                                var FieldProp = FieldValuesMap[FieldName];
                                if(FieldProp) {
                                    FieldVal = FieldProp.get("v.value");
                                }
                                
                                if(FieldVal) {
                                    FieldVal = FieldVal.toUpperCase();    
                                }
                                
                                // Create ConResultMap which indicates a map of condition name as key and final boolean evaluation as value
                                if(ConVar.ConditionType == undefined || ConVar.ConditionType == "Positive") {
                                    ConResultMap[ConVar.ConditionName] = FieldValues.includes(FieldVal);
                                } else 
                                    if(ConVar.ConditionType == "Negative") {                                   
                                        ConResultMap[ConVar.ConditionName] = !FieldValues.includes(FieldVal); 
                                    }
                            }
                            
                            // Generate FinalConditionLogic
                            var FinalConLogic = FieldCon.FinalConditionLogic;
                            for(var ConName in ConResultMap) {
                                if(ConResultMap[ConName] != undefined) {
                                    var regex = new RegExp(ConName, 'g');
                                    FinalConLogic = FinalConLogic.replace(regex, ConResultMap[ConName].toString());    
                                }    
                            }
                            
                            // Evaluate FinalConditionLogic
                            var FinalResult;
                            if(FinalConLogic) {
                                FinalResult = parseBoolStr(FinalConLogic);
                                FieldVar.FieldRequired = FinalResult;
                                if(!FinalResult) {
                                    allowDisable = true;
                                } else {
                                    // If FinalResult is true then field is required and it cannot be disabled
                                    FieldVar.FieldReadOnly = false;
                                }
                            }
                        }
                    } else {
                        // If FieldRequiredConditions is not given then field can be disabled
                        allowDisable = true;
                    }
                    
                    // If allowDisable flag is true and FieldReadOnlyConditions is given then field can be disabled
                    if(allowDisable && FieldVar.FieldReadOnlyConditions) {
                        FieldCon = FieldVar.FieldReadOnlyConditions;
                        if(FieldCon) {
                            var ConArray = FieldCon.ConditionsArray;
                            var ConResultMap = new Object();
                            //YK
                            //for(var ConIndx in ConArray) {
                            for(var i=0; i<ConArray.length; i++){
                                var ConVar = ConArray[i];
                                var FieldName = ConVar.FieldName;
                                var FieldValues = ConVar.FieldValues;
                                FieldValues = FieldValues.map(function(x) { 
                                    return x.toUpperCase(); 
                                });
                                
                                var FieldVal;
                                var FieldProp = FieldValuesMap[FieldName];
                                if(FieldProp) {
                                    FieldVal = FieldProp.get("v.value");
                                }
                                
                                if(FieldVal) {
                                    FieldVal = FieldVal.toUpperCase();    
                                }
                                
                                // Create ConResultMap which indicates a map of condition name as key and final boolean evaluation as value
                                if(ConVar.ConditionType == undefined || ConVar.ConditionType == "Positive") {
                                    ConResultMap[ConVar.ConditionName] = FieldValues.includes(FieldVal);
                                } else 
                                    if(ConVar.ConditionType == "Negative") {                                   
                                        ConResultMap[ConVar.ConditionName] = !FieldValues.includes(FieldVal); 
                                    }
                            }
                            
                            // Generate FinalConditionLogic
                            var FinalConLogic = FieldCon.FinalConditionLogic;
                            for(var ConName in ConResultMap) {
                                if(ConResultMap[ConName] != undefined) {
                                    var regex = new RegExp(ConName, 'g');
                                    FinalConLogic = FinalConLogic.replace(regex, ConResultMap[ConName].toString());    
                                }    
                            }
                            
                            // Evaluate FinalConditionLogic
                            var FinalResult;
                            if(FinalConLogic) {
                                FinalResult = parseBoolStr(FinalConLogic);
                                // Bug - 22181 Start
								FieldVar.FieldReadOnly = FinalResult;
								if(!FinalResult) {
									allowHide = true;
								} else {
                                    // If FinalResult is true then field is displayed
                                    FieldVar.FieldHide = false;
                                }
								// Bug - 22181 End
								
                                // Added by Sainath for 23305 S
                                if(FinalResult && FieldVar.FieldName == "IHO_Premium_Amount__c"){
                                    console.log("INSIDE BLANK VALUES!");
                                    FieldVar.FieldValue = undefined;
                                }
								// Added by Sainath for 23305 E
                            }
                        }
                    } else {
						// If FieldReadOnlyConditions is not given then field can be hidden
                        allowHide = true; // Bug - 22181
					}
                    // Bug - 22181 Start
					// If allowHide flag is true and FieldHideConditions is given then field can be hidden
                    if(allowHide && FieldVar.FieldHideConditions) {
						FieldCon = FieldVar.FieldHideConditions;
                        if(FieldCon) {
                            var ConArray = FieldCon.ConditionsArray;
                            var ConResultMap = new Object();
                            for(var i=0; i<ConArray.length; i++){
                                var ConVar = ConArray[i];
                                var FieldName = ConVar.FieldName;
                                var FieldValues = ConVar.FieldValues;
                                FieldValues = FieldValues.map(function(x) { 
                                    return x.toUpperCase(); 
                                });
                                
                                var FieldVal;
                                var FieldProp = FieldValuesMap[FieldName];
                                if(FieldProp) {
                                    FieldVal = FieldProp.get("v.value");
                                }
                                
                                if(FieldVal) {
                                    FieldVal = FieldVal.toUpperCase();    
                                }
                                
                                // Create ConResultMap which indicates a map of condition name as key and final boolean evaluation as value
                                if(ConVar.ConditionType == undefined || ConVar.ConditionType == "Positive") {
                                    ConResultMap[ConVar.ConditionName] = FieldValues.includes(FieldVal);
                                } else 
                                    if(ConVar.ConditionType == "Negative") {
                                        ConResultMap[ConVar.ConditionName] = !FieldValues.includes(FieldVal); 
                                    }
                            }
                            
                            // Generate FinalConditionLogic
                            var FinalConLogic = FieldCon.FinalConditionLogic;
                            for(var ConName in ConResultMap) {
                                if(ConResultMap[ConName] != undefined) {
                                    var regex = new RegExp(ConName, 'g');
                                    FinalConLogic = FinalConLogic.replace(regex, ConResultMap[ConName].toString());    
                                }    
                            }
                            
                            // Evaluate FinalConditionLogic
                            var FinalResult;
                            if(FinalConLogic) {
                                FinalResult = parseBoolStr(FinalConLogic);
								FieldVar.FieldHide = FinalResult;
								// Added by Anurag for 23182 S
                                if(FinalResult && FieldVar.FieldName == "IHO_Premium_Amount__c"){
                                    FieldVar.FieldValue = undefined;
                                }
								// Added by Anurag for 23182 E
                            }
                        }
					}	
                    // Bug - 22181 End
                    
                    FieldList[FieldIndx] = FieldVar;
                    
                    // Calculate count of number of fields enabled and number of fields for which values are entered properly
                    var currentFieldVar = FieldValuesMap[FieldVar.FieldName];
                    if(FieldVar.FieldVisibleInModal && !FieldVar.FieldReadOnly && !FieldVar.FieldHide && FieldVar.FieldType != "FORMULA") { // Added condition for 22181
                    	enabledFieldsCount++;
                        if(currentFieldVar && currentFieldVar.get("v.value")) {
                            filledFieldsCount++;
                        }
                    }
                    
                    // Start of changes - 22181
					if(FieldVal == "HDFC CREDIT PROTECTION PLUS") {
						sliderFlag = true;
					}
					// End of changes - 22181
                }
                
                ObjectVar.fields = FieldList;
            }
            
            var percentFilled = 0;          
            if(enabledFieldsCount != 0) {
            	percentFilled = (filledFieldsCount / enabledFieldsCount) * 100;    
            }
            
            // Set count of number of fields enabled and number of fields for which values are entered properly and percentage
            component.set("v.filledFieldsCount", filledFieldsCount);
            component.set("v.enabledFieldsCount", enabledFieldsCount);
            component.set("v.percentFilled", parseInt(percentFilled));
            
            // Start of changes - 22181
            var flow = component.get("v.flow"); 
            var ObjectName = component.get("v.ObjectName");
            var sliderParams = component.get("v.sliderParams");
            if(sliderParams && flow == "ELA" && ObjectName == "DPLinsurance__c" && component.find("slider_btn")) {
                sliderParams.disabled = !sliderFlag;
                if(!sliderFlag) {
                    sliderParams.value = 0;
					component.find("slider_btn").set("v.disabled", true);
                } else {
					component.find("slider_btn").set("v.disabled", false);
				}
                component.set("v.sliderParams", sliderParams);
            }
            component.set("v.ObjectVar", ObjectVar);
			// console.log("AFTER SET: ",ObjectVar.fields);
            // End of changes - 22181
        } catch(err) {
            console.debug("Error in disableFields --> " + err.message + " stack --> " + err.stack);
            //alert('Error in disableFields --> ' + err.message + '---- stack --> ' + err.stack);
        }
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is used to disable buttons during any processing.
    *   @version		: 	1.0
    */
    disableButtons : function(component, isDisabled) {
        try{
        var ObjectList = component.get("v.ObjectList");
        console.log("OBJECT LIST: ",ObjectList.length);
        // Mobility changes YK...
        for(var i=0; i<ObjectList.length; i++){
            var objCMP = component.get("v.ObjectList")[i];
            if(objCMP){
            	objCMP.editBtnDisabled = isDisabled;
            	objCMP.deleteBtnDisabled = isDisabled;
            	objCMP.viewBtnDisabled = isDisabled;
            	objCMP.addMemBtnDisabled = isDisabled; // Only for insurance flow - 22181
                objCMP.medQueBtnDisabled = isDisabled; // Only for insurance flow - 22181
            }
            component.get("v.ObjectList")[i] = objCMP;
        } 
        
        component.set("v.isDisabled", isDisabled);
        }catch(err)
        {
            //alert('error occured ---- '+err.message + " -----stack --> " + err.stack);
        }
    },

    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is used to display error / success message by creating ToastMessage component.
    *   @version		: 	1.0
    */
    displayMessage : function(component, title, message, type, fadeTimeout, isAutoClose) {
        try{
			console.log("message: ",message);
            var ObjectName = component.get("v.ObjectName");
            if((component.get("v.isSalMobilityFlow") == true || component.get("v.isPosLaFlow") == true) && ObjectName != "Service_To_Sales__c")
            {
             	if(component.get("v.isInsurancePosLaFlow") == true)   
                {
                    var ShowToastEvent = $A.get("e.c:ShowToastEvent");
                    ShowToastEvent.setParams({
                        "title": title,
                        "message":message,
                        "type":type,
                    });
					ShowToastEvent.fire();
                }
                else{
                    if(type == 'error')
                    {
                        this.showParentToastHelper('parentErrorToast1', 'parentErrorMsg1', message);
                    }
                    else if(type == 'success')
                    {	
                        this.showParentToastHelper('parentSuccessToast1', 'parentSuccessMsg1', message);
                        if(component.get("v.isPosLaFlow") == true)
                        {
                            this.fireReloadObligRecordsEvent(component);
                            
                        }
                            
                    }else if(type == "warning")
                    {
                        this.showParentToastHelper('parentInfoToast1', 'parentInfoMsg1', message);
                    }
                }
            }
            else{
                console.log('inside generic flow...');
                $A.createComponent(
                    "c:ToastMessage",
                    {
                        "title" : title,
                        "message" : message,
                        "type" : type,
                        "fadeTimeout" : fadeTimeout,
                        "isAutoClose" : isAutoClose
                    },
                    function(newComp) {
                        var body = [];
                        body.push(newComp);
                        component.set("v.body", body);
                    }
                );
            }
        }catch(err)
        {
            //alert('error occured in displayMessage ---- '+err.message + " -----stack --> " + err.stack);
        }
    },
    
    /*
     * @description		:	method to fire event that reloads records of obligation in POS LA flow 
     */
    fireReloadObligRecordsEvent : function (component)
    {
        window.setTimeout(
        	$A.getCallback(function() {
                var compEvents = component.getEvent("posLAFlowEvent");
                compEvents.fire();
            }), 3000
		);
    },
    
    /*YK
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called to close custom toast
    *   @version		: 	1.0
    */
	showParentToastHelper : function(toastDivId, messageDivId, message)
    {
        document.getElementById(toastDivId).style.display = "block";
		document.getElementById(messageDivId).innerHTML = message;
        
        setTimeout(function () {
            document.getElementById(toastDivId).style.display = "none";
			document.getElementById(messageDivId).innerHTML = "";
		}, 5000);
	},
	    
    closeSuccessToastHelper : function(component, event){
        document.getElementById('parentSuccessToast1').style.display = "none";
        document.getElementById('parentSuccessMsg1').innerHTML = "";
    },
    
    closeErrorToastHelper : function(component){
		document.getElementById('parentErrorToast1').style.display = "none";
        document.getElementById('parentErrorMsg1').innerHTML = "";
        
    },
    
    closeInfoToastHelper : function(component){
        document.getElementById('parentInfoToast1').style.display = "none";
        document.getElementById('parentInfoMsg1').innerHTML = "";
    },
    
    /*YK
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is called to close custom toast
    *   @version		: 	1.0
    */
    fireSalMobilityEvent : function (component, recordId)
    {
        //fire event for CAM updation..
        var compEvents = component.getEvent("salMobileFlowEvent");
        compEvents.setParams({ "obligationRecordId" : recordId });
        compEvents.fire();
        console.log('ObjectVar.record.Id ----->> '+recordId);
    },
    
    /*
    *	@author 		: 	Persistent Systems
    *   @description	: 	Method is used to get callout response.
    *   @version		: 	1.0
    */
    getCalloutResponse : function(component, paramsMap, callback) {
    	var action = component.get("c.getCalloutResponse");
        action.setParams({
			"paramsMap" : paramsMap
		});
        if(callback) {
        	action.setCallback(this, callback);
        }
        $A.enqueueAction(action);
	},
    calculateEmi : function(component, event,oppId) {
        // var oppId = component.get("v.loanAppID");
        console.log('34'+oppId);
        this.executeApex(component, 'calculateEMIMethodClone', {
            "oppId": oppId,
        }, function(error, result){
            if(!error && result){
                if(!$A.util.isEmpty(result))
                {
					console.log('emi calculated');
                }
            }
        });
      },
    executeApex: function (component, method, params, callback) {
        var action = component.get("c." + method);
        console.log("Method: ",method);
        action.setParams(params);
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state'+state);
            if (state === "SUCCESS") {
                console.log('response.getReturnValue()' + response.getReturnValue());
                callback.call(this, null, response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for (var i = 0; i < array.length; i++) {
                    var item = array[i];
                    if (item && item.message) {
                        errors.push(item.message);
                    }
                }
                //this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
	/* CR 22307 s */
	
	disableButtons1 : function(component, isDisabled) {
        try{
        var ObjectList = component.get("v.ObjectList");
        console.log("OBJECTLIST LENGTH: ",ObjectList.length);
        // Mobility changes YK...
        for(var i=0; i<ObjectList.length; i++){
            var objCMP = component.get("v.ObjectList")[i];
            if(objCMP){
            	objCMP.editBtnDisabled = isDisabled; 
            	objCMP.deleteBtnDisabled = isDisabled;
            	objCMP.viewBtnDisabled = false;
            	objCMP.addMemBtnDisabled = isDisabled; // Only for insurance flow
				// Added by Anurag for 22181 CR S
				if(component.get("v.flow") == 'ELA' && component.get("v.displayReadOnlyEmployeeLoan")){
					objCMP.medQueBtnDisabled = isDisabled;
					component.set("v.isDisabled", false);
				}
				// Added by Anurag for 22181 CR E
            }
            component.get("v.ObjectList")[i] = objCMP;
        } 
        
        component.set("v.isDisabled", isDisabled);
        }catch(err)
        {
            //alert('error occured ---- '+err.message + " -----stack --> " + err.stack);
        }
    },
	 /* CR 22307 e */
    //Bug 25146 S
    hndlBGExtraCarePlus:function(component,event,helper){
        console.log('here' + JSON.stringify(component.get("v.FieldList")));
        console.log('ObjectVar :::' + JSON.stringify(component.get("v.ObjectVar")));
		
        if(component.get("v.InsuranceProduct")){
            var InsProd = component.get("v.InsuranceProduct");
            var prodArr = ['BAGIC EXTRA CARE PLUS'];
           // var prodArr = ['BAGIC EXTRA CARE PLUS','INDIVIDUAL HEALTH GUARD','FAMILY FLOATER HEALTH GUARD']
            if(component.get("v.ObjectName") == 'Service_To_Sales__c' && prodArr.indexOf(InsProd) > -1){
                var fieldLst = component.get("v.FieldList");
                for(var i=0;i<fieldLst.length; i++){
                    if(fieldLst[i].FieldName == 'Height__c' || fieldLst[i].FieldName == 'Weight__c'){
                        fieldLst[i].FieldRequired = true;
                    }
                }
                
                component.set("v.FieldList",fieldLst);
				if(component.get("v.ObjectVar")){
					var fieldLst = component.get("v.ObjectVar.fields");
					for(var i=0;i<fieldLst.length; i++){
						if(fieldLst[i].FieldName == 'Height__c' || fieldLst[i].FieldName == 'Weight__c'){
							fieldLst[i].FieldRequired = true;
						}
					}
					
					component.set("v.ObjectVar.fields",fieldLst);
				}
            } 
        }
       
    }
    //Bug 25146 E
})