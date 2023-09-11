({
    
    FieldList : [],
    IdList : [],
    LoanObject : [],
    //trancheNumberList : [], //20985
	productOfferObject : [],
    ApplicantId : '',
    AppNameAndType : '',
    
    setFieldData : function(component) {
        this.FieldList = [];
        this.IdList = [];
        var loanObj, POObj;
		var action;
		var applicantList;
		var flow = component.get("v.flow");
        var isMortgageProduct= false; //20985
        if(flow == "OPP" || flow == "ELA") { // Added for 22181
            console.log("flow: ",flow+" "+component.get("v.loanAppID"));
			action = component.get("c.fetchAccount");
			action.setParams({
				"recordId" : component.get("v.loanAppID")
			});
		} else
			if(flow == "PO") {
				action = component.get("c.fetchPO");
				action.setParams({
					"recordId" : component.get("v.poID")
				});
			}

		if(action) {
			action.setCallback(this, function(response){
				var state = response.getState();
                console.log("response: ", JSON.stringify(response));
				if (component.isValid() && state === "SUCCESS") {
                    console.log("response: ", JSON.stringify(response));
                    if(flow == "OPP" || flow == "ELA") {
						loanObj = response.getReturnValue();
						if(loanObj && loanObj.length > 0) {
							this.LoanObject = loanObj[0];
							applicantList = loanObj[0].Loan_Application__r;
							var InsuranceList = loanObj[0].Insurance__r;
							if(InsuranceList) {
								for(var index = 0, len = InsuranceList.length; index < len; ++index) {
									if(InsuranceList[index].Id) {
										this.IdList.push(InsuranceList[index].Id.toString());
									}
								}
							}
                             //20985 S
                            var loanProduct = loanObj[0].Product__c;
                            var labelVal = $A.get("$Label.c.MortgageProductsLabel");
                            if(labelVal.includes(loanProduct)){
                                isMortgageProduct = true;
                            } 
                            /*if(isMortgageProduct){
                            var relatedTrancheNumbers = loanObj[0].Tranche_Details__r;
                             this.trancheNumberList.push({
                                label : '--None--',
                                value : 0,
                                selected : true,
                                disabled : false
                            });
                                
                                if(!$A.util.isEmpty(relatedTrancheNumbers) && relatedTrancheNumbers){
                            for(var index = 0, len = relatedTrancheNumbers.length; index < len; ++index) {
                                var tranche = relatedTrancheNumbers[index];
                                this.trancheNumberList.push({
                                    label : tranche.Name,
                                    value : tranche.Name,
                                    selected : true,
                                    disabled : false
                                });
                            }
                                }
                               
                            }*/
                            //20985 E 
						}
					} else  
						if(flow == "PO") {
							POObj = response.getReturnValue();
							if(POObj && POObj.length > 0) {
								this.productOfferObject = POObj[0];
								var InsuranceList = POObj[0].Insurance__r;
								if(InsuranceList) {
									for(var index = 0, len = InsuranceList.length; index < len; ++index) {
										if(InsuranceList[index].Id) {
											this.IdList.push(InsuranceList[index].Id.toString());
										}
									}
								}
							}	
						}
					
					var PicklistProp = [];
					PicklistProp.push({
						label : '--None--',
						value : '',
						selected : true,
						disabled : false
					});
                    if(flow == "OPP" || flow == "ELA") { // Added for 22181
                    
						if(applicantList && applicantList.length > 0) {
							var isSalMobilityFlow = component.get("v.isSalMobilityFlow");
							for(var index = 0, len = applicantList.length; index < len; ++index) {
								var applicant = applicantList[index];
								if(applicant.Contact_Name__c && applicant.Contact_Customer_Type__c != null && applicant.Contact_Customer_Type__c != "Corporate") {
									if(isSalMobilityFlow) {
										if(applicant.Applicant_Type__c == 'Primary') {
											this.AppNameAndType = applicant.ContactName__c + " - " + applicant.Applicant_Type__c;
											PicklistProp.push({
												label : this.AppNameAndType,
												value : this.AppNameAndType,
												selected : true,
												disabled : false
											});
											break;
										}	
									} else {
										this.AppNameAndType = applicant.ContactName__c + " - " + applicant.Applicant_Type__c;
										PicklistProp.push({
											label : this.AppNameAndType,
											value : this.AppNameAndType,
											selected : true,
											disabled : false
										});
									}
								}
							}
                            console.log("populateFieldData");
							this.populateFieldData(component, PicklistProp,isMortgageProduct); //20985 isMortgageProduct
						}	
					} else 
						if(flow == "PO") {
							if(this.productOfferObject) {
								this.AppNameAndType = this.productOfferObject.Lead__r.Name;
								PicklistProp.push({
									label : this.productOfferObject.Lead__r.Name,
									value : this.productOfferObject.Lead__r.Name,
									selected : true,
									disabled : false
								});
							}
							this.populateFieldData(component, PicklistProp,isMortgageProduct);//20985 isMortgageProduct
						}
				}
			});
			$A.enqueueAction(action);	
		}		
    },	
    
    populateFieldData : function(component, PicklistProp,isMortgageProduct) {//20985 isMortgageProduct
        // Start of flag changes to enable premium amount
        var HTSCalculatorProducts = $A.get("$Label.c.HTSCalculatorProducts");
        if(HTSCalculatorProducts) {
            HTSCalculatorProducts = HTSCalculatorProducts.split(",");
        }
        // End of flag changes to enable premium amount
        
        // Start of changes - 22181
		var flow = component.get("v.flow");
		var ELAFlag;
		if(flow == "ELA") {
			ELAFlag = true;	
		} else {
			ELAFlag = false;
		}
		var PicklistValuesMapping;
		if(ELAFlag) {
			PicklistValuesMapping = new Object();
			var dependentValues = new Object();
			dependentValues["General Insurance"] = ["CPP"];
			dependentValues["Life Insurance"] = ["HDFC Life"];
			PicklistValuesMapping["Type_of_Insurance__c-Insurance_Type__c"] = dependentValues;
			
			dependentValues = new Object();
			dependentValues["CPP"] = ["WALLET PROTECT"];
			dependentValues["HDFC Life"] = ["HDFC CREDIT PROTECTION PLUS"];
			PicklistValuesMapping["Insurance_Type__c-Insurance_Product__c"] = dependentValues;
            
            dependentValues = new Object();
			dependentValues["WALLET PROTECT"] = [];
			dependentValues["HDFC CREDIT PROTECTION PLUS"] = ["Single"];
			PicklistValuesMapping["Insurance_Product__c-HdfcCppType__c"] = dependentValues;
            
            dependentValues = new Object();
			dependentValues["WALLET PROTECT"] = [];
			dependentValues["HDFC CREDIT PROTECTION PLUS"] = ["Decreasing"];
			PicklistValuesMapping["Insurance_Product__c-Sum_Assured_Type__c"] = dependentValues;
            
            dependentValues = new Object();
			dependentValues["WALLET PROTECT"] = [];
			dependentValues["HDFC CREDIT PROTECTION PLUS"] = ["base+ci"];
			PicklistValuesMapping["Insurance_Product__c-Plan_Option__c"] = dependentValues;
            
            dependentValues = new Object();
			dependentValues["WALLET PROTECT"] = ["3"];
			dependentValues["HDFC CREDIT PROTECTION PLUS"] = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"];
			PicklistValuesMapping["Insurance_Product__c-Policy_Tenure__c"] = dependentValues;
            
            dependentValues = new Object();
            dependentValues["HDFC CREDIT PROTECTION PLUS"] = [];
			dependentValues["WALLET PROTECT"] = ["399", "599", "999", "1299", "2499", "3399", "3599", "5000", "7500", "10000"];
			PicklistValuesMapping["Insurance_Product__c-Plan__c"] = dependentValues;
		}
		// End of changes - 22181
		
		var isSalMobilityFlow = component.get("v.isSalMobilityFlow");
		var isApplicantRequired, isApplicantReadOnly;
        if(isSalMobilityFlow || ELAFlag) { // Added for 22181
			isApplicantRequired = false;
			isApplicantReadOnly = true;
		} else {
			isApplicantRequired = true;
			isApplicantReadOnly = false;
		}
		
		this.FieldList.push({
            "FieldName" : "Insurance_ID__c",
            "FieldLabel" : "Insurance ID",
            "FieldVisibleInTable" : true,
            "FieldVisibleInModal" : true,
            "FieldSequence" : 1
        });
		if(ELAFlag) {
			var insFormNoHide = new Object({
										"ConditionsArray" : [
											{
												"FieldName" : "Insurance_Product__c",
												"FieldValues" : ["WALLET PROTECT", "HDFC CREDIT PROTECTION PLUS"],
												"ConditionType" : "Positive",
												"ConditionName" : "C1"
											}
										],
										"FinalConditionLogic" : "C1"
									});	
		}
        this.FieldList.push({
            "FieldName" : "Insurance_form_number__c",
            "FieldLabel" : "Insurance Form Number",
            "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["CPP SHIELD"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    }
                ],
                "FinalConditionLogic" : "C1"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : insFormNoHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldSequence" : 2
        });
		
		if(isSalMobilityFlow || ELAFlag) {
			this.FieldList.push({
				"FieldName" : "Insurer_Name__c",
				"FieldLabel" : "Insured Name",
				"FieldValue" : this.AppNameAndType,
				"FieldRequired" : isApplicantRequired,
				"FieldReadOnly" : isApplicantReadOnly,
				"FieldVisibleInTable" : true,
				"FieldVisibleInModal" : true,
				"FieldType" : "PICKLIST",
				"PicklistProp" : PicklistProp,
				"FieldSequence" : 3
			});	
		} else {
			this.FieldList.push({
				"FieldName" : "Insurer_Name__c",
				"FieldLabel" : "Insured Name",
				"FieldRequired" : isApplicantRequired,
				"FieldReadOnly" : isApplicantReadOnly,
				"FieldVisibleInTable" : true,
				"FieldVisibleInModal" : true,
				"FieldType" : "PICKLIST",
				"PicklistProp" : PicklistProp,
				"FieldSequence" : 3
			});
		}
        this.FieldList.push({
            "FieldName" : "Type_of_Insurance__c",
            "FieldLabel" : "Type Of Insurance",
            "FieldRequired" : true,
            "FieldRequiredConditions" : null,
            "FieldVisibleInTable" : true,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 4
        });
        this.FieldList.push({
            "FieldName" : "Insurance_Type__c",
            "FieldLabel" : "Insurance Type",
            "FieldRequired" : true,
            "FieldRequiredConditions" : null,
            "FieldVisibleInTable" : true,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 5
        });
        this.FieldList.push({
            "FieldName" : "Insurance_Product__c",
            "FieldLabel" : "Insurance Product",
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["ICICI Lombard GIC Ltd"],
                        "ConditionType" : "Negative",
                        "ConditionName" : "C1"
                    }
                ],
                "FinalConditionLogic" : "C1"
            },
            "FieldVisibleInTable" : true,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 6
        });
        this.FieldList.push({
            "FieldName" : "Premium_Amount__c",
            "FieldLabel" : "Premium Amount",
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : HTSCalculatorProducts,
                        "ConditionType" : "Negative",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["GCPP"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    },
                    {
                        "FieldName" : "Accidental_Permanent_Total_Disability__c",
                        "FieldValues" : ["Y"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C3"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["CONTENT - MY HOME"],
                        "ConditionType" : "Negative",
                        "ConditionName" : "C4"
                    }
                ],
                "FinalConditionLogic" : "((C1 || (C2 && C3)) && C4)"
            },
            "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BAGIC", "HDFC Life", "CPP", "ICICI Prudential","IHO"],//Bug:22426
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["BAGIC EXTRA CARE", "BAGIC EXTRA CARE PLUS", "HDFC GROUP HEALTH SHIELD", "PREMIUM PERSONAL GUARD", "PROFESSIONAL INDEMNITY FOR DOCTORS" ,"AGE AGNOSTIC", "PERSONAL ACCIDENT", "WALLET PROTECT", "BAGIC COMPREHENSIVE CARE", "MY HOME", "CPP SHIELD", "CPP LIV CARE" , "I PRU GLS","BHFL IHO PROPERTY CARE","BHFL CPP LIFE CARE"],//Bug:22426,//Bug:23777
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    },
                    {
                        "FieldName" : "Accidental_Permanent_Total_Disability__c",
                        "FieldValues" : ["Y"],
                        "ConditionType" : "Negative",
                        "ConditionName" : "C3"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["GCPP"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C4"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : HTSCalculatorProducts,
                        "ConditionType" : "Positive",
                        "ConditionName" : "C5"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["CONTENT - MY HOME"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C6"
                    }
                ],
                "FinalConditionLogic" : "((C3 && C4 && C5) || (C1 && C2 && C5) || C6)"
            },
			"FieldHide" : ELAFlag,
            "FieldVisibleInTable" : true,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 7
        });
		var sumAssured;
		if(ELAFlag) {
			sumAssured = this.LoanObject.Approved_Loan_Amount__c;
			var sumAssuredHide = new Object({
										"ConditionsArray" : [
											{
												"FieldName" : "Insurance_Product__c",
												"FieldValues" : ["WALLET PROTECT"],
												"ConditionType" : "Positive",
												"ConditionName" : "C1"
											}
										],
										"FinalConditionLogic" : "C1"
									});
		}
        this.FieldList.push({
            "FieldName" : "Sum_Assured__c",
            "FieldLabel" : "Sum Assured",
			"FieldValue" : sumAssured,
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BALIC", "BAGIC", "HDFC Life", "TATA AIG","ICICI Prudential"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["GCPP", "GROUP TERM LIFE", "BAGIC COMPREHENSIVE CARE", "MY HOME", "FAMILY FLOATER HEALTH GUARD", "INDIVIDUAL HEALTH GUARD", "HDFC GROUP HEALTH SHIELD", "WALLET PROTECT", "TAGIC GROUP CREDIT SECURE PLUS","I PRU GLS"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
            "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BAGIC", "CPP", "IHO"],//Bug:22426
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["BAGIC EXTRA CARE", "BAGIC EXTRA CARE PLUS", "PREMIUM PERSONAL GUARD", "PROFESSIONAL INDEMNITY FOR DOCTORS", "AGE AGNOSTIC", "PERSONAL ACCIDENT", "CPP SHIELD", "CPP LIV CARE", "BAGIC FAMILY HEALTH CARE","BHFL IHO PROPERTY CARE","BHFL CPP LIFE CARE","CONTENT - MY HOME"],//Bug:22426,//Bug:23777
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : sumAssuredHide,
            "FieldVisibleInTable" : true,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 8
        });
        this.FieldList.push({
            "FieldName" : "Whether_we_are_financing_this_product__c",
            "FieldLabel" : "Financed By BFL",
            "FieldValue" : "Yes",
            "FieldReadOnly" : false,
			"FieldHide" : ELAFlag,
            //"FieldHideConditions" : financedHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 9,
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["CONTENT - MY HOME"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    }
                ],
                "FinalConditionLogic" : "C1"
            },
          "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["CONTENT - MY HOME"],
                        "ConditionType" : "Negative",
                        "ConditionName" : "C1"
                    }
                ],
                "FinalConditionLogic" : "C1"
            }   
        });
        this.FieldList.push({
            "FieldName" : "Customer_Payment_Mode__c",
            "FieldLabel" : "Payment Mode",
            "FieldValue" : "Deducted from disbursement",
            "FieldReadOnly" : false,
			"FieldHide" : ELAFlag,
            //"FieldHideConditions" : paymentModeHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 10,
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["CONTENT - MY HOME"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    }
                ],
                "FinalConditionLogic" : "C1"
            },
           "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["CONTENT - MY HOME"],
                        "ConditionType" : "Negative",
                        "ConditionName" : "C1"
                    }
                ],
                "FinalConditionLogic" : "C1"
            }
        });
		if(ELAFlag) {
			var policyTenureHide = new Object({
												"ConditionsArray" : [
													{
														"FieldName" : "Insurance_Product__c",
														"FieldValues" : ["WALLET PROTECT", "HDFC CREDIT PROTECTION PLUS"],
														"ConditionType" : "Negative",
														"ConditionName" : "C1"
													}
												],
												"FinalConditionLogic" : "C1"
											});	
		}
        this.FieldList.push({
            "FieldName" : "Policy_Tenure__c",
            "FieldLabel" : "Policy Tenure",
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BALIC", "BAGIC", "HDFC Life", "CPP", "TATA AIG","ICICI Prudential","IHO"],//Bug:22426
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["GCPP", "GROUP TERM LIFE", "PERSONAL ACCIDENT", "BAGIC COMPREHENSIVE CARE", "PROFESSIONAL INDEMNITY FOR DOCTORS", "MY HOME", "HDFC CREDIT PROTECTION PLUS", "HDFC CREDIT PROTECTION", "HDFC GROUP HEALTH SHIELD", "FAMILY FLOATER HEALTH GUARD", "INDIVIDUAL HEALTH GUARD", "PREMIUM PERSONAL GUARD", "WALLET PROTECT", "CPP HNI", "CPP VARIANT", "BAGIC EXTRA CARE PLUS", "AGE AGNOSTIC", "CPP SHIELD", "CPP LIV CARE", "BAGIC FAMILY HEALTH CARE", "TAGIC GROUP CREDIT SECURE PLUS","I PRU GLS","BHFL IHO PROPERTY CARE","BHFL CPP LIFE CARE","CONTENT - MY HOME"],//Bug:22426,//Bug:23777
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : policyTenureHide,
            "FieldVisibleInTable" : true,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 11
        });
		if(!isMortgageProduct) {
            var ihoPremHide = new Object({
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["IHO"],
                        "ConditionType" : "Negative",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["BHFL IHO PROPERTY CARE"],
                        "ConditionType" : "Negative",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 || C2"
            });   
        }
		//Bug:22426 S
		this.FieldList.push({
            "FieldName" : "IHO_Premium_Amount__c",
            "FieldLabel" : "IHO Premium Amount",
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["IHO"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["BHFL IHO PROPERTY CARE"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
            "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["IHO"],
                        "ConditionType" : "Negative",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["BHFL IHO PROPERTY CARE"],
                        "ConditionType" : "Negative",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
			"FieldHide" : !isMortgageProduct,
			"FieldHideConditions" : ihoPremHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 12
        });
		//Bug:22426 E
		
		//Bug:23777 Start
		if(!isMortgageProduct) {
            var cppPremHide = new Object({
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["CPP"],
                        "ConditionType" : "Negative",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["BHFL CPP LIFE CARE"],
                        "ConditionType" : "Negative",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            });   
        }
        this.FieldList.push({
            "FieldName" : "BHFL_CPP_LYF_CARE_Premium_Amt__c",
            "FieldLabel" : "CPP Premium Amount",
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["CPP"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["BHFL CPP LIFE CARE"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
            "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["CPP"],
                        "ConditionType" : "Negative",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["BHFL CPP LIFE CARE"],
                        "ConditionType" : "Negative",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
			"FieldHide" : !isMortgageProduct,
			"FieldHideConditions" : cppPremHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 13
        });
		//Bug:23777 End
        if(ELAFlag) {
			var ambCoverHide = new Object({
											"ConditionsArray" : [
												{
													"FieldName" : "Insurance_Product__c",
													"FieldValues" : ["WALLET PROTECT", "HDFC CREDIT PROTECTION PLUS"],
													"ConditionType" : "Positive",
													"ConditionName" : "C1"
												}
											],
											"FinalConditionLogic" : "C1"
										});	
		}
        this.FieldList.push({
            "FieldName" : "Ambulance_Cover__c",
            "FieldLabel" : "Ambulance Cover",
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BAGIC"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["BAGIC EXTRA CARE PLUS"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
            "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BAGIC"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["BAGIC EXTRA CARE PLUS"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "!(C1 && C2)"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : ambCoverHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 14
        });
		if(ELAFlag) {
			var sumInsOptHide = new Object({
											"ConditionsArray" : [
												{
													"FieldName" : "Insurance_Product__c",
													"FieldValues" : ["WALLET PROTECT", "HDFC CREDIT PROTECTION PLUS"],
													"ConditionType" : "Positive",
													"ConditionName" : "C1"
												}
											],
											"FinalConditionLogic" : "C1"
										});	
		}
        this.FieldList.push({
            "FieldName" : "Sum_Insured__c",
            "FieldLabel" : "Sum Insured Options",
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BAGIC", "CPP"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["FAMILY FLOATER HEALTH GUARD", "INDIVIDUAL HEALTH GUARD", "PREMIUM PERSONAL GUARD", "AGE AGNOSTIC", "PROFESSIONAL INDEMNITY FOR DOCTORS", "PERSONAL ACCIDENT", "BAGIC EXTRA CARE PLUS", "CPP SHIELD", "CPP LIV CARE", "BAGIC FAMILY HEALTH CARE","CONTENT - MY HOME"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
            
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : sumInsOptHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 15
        });
		if(ELAFlag) {
			var dedAmtHide = new Object({
											"ConditionsArray" : [
												{
													"FieldName" : "Insurance_Product__c",
													"FieldValues" : ["WALLET PROTECT", "HDFC CREDIT PROTECTION PLUS"],
													"ConditionType" : "Positive",
													"ConditionName" : "C1"
												}
											],
											"FinalConditionLogic" : "C1"
										});	
		}
        this.FieldList.push({
            "FieldName" : "Deductible_Amount__c",
            "FieldLabel" : "Deductible Amount",
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BAGIC"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["BAGIC EXTRA CARE PLUS"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
            "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BAGIC"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["BAGIC EXTRA CARE PLUS"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "!(C1 && C2)"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : dedAmtHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 16
        });
		if(ELAFlag) {
			var planOptHide = new Object({
											"ConditionsArray" : [
												{
													"FieldName" : "Insurance_Product__c",
													"FieldValues" : ["WALLET PROTECT", "HDFC CREDIT PROTECTION PLUS"],
													"ConditionType" : "Positive",
													"ConditionName" : "C1"
												}
											],
											"FinalConditionLogic" : "C1"
										});	
		}
		var planOptVal;
		if(ELAFlag) {
			planOptVal = "base+ci";
		}
        this.FieldList.push({
            "FieldName" : "Plan_Option__c",
            "FieldLabel" : "Plan Option",
			"FieldValue" : planOptVal,
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BAGIC", "HDFC Life","ICICI Prudential"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["BAGIC EXTRA CARE", "HDFC CREDIT PROTECTION PLUS", "HDFC CREDIT PROTECTION", "HDFC GROUP HEALTH SHIELD","I PRU GLS"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
            "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["HDFC Life", "BAGIC", "BALIC", "CPP", "TATA AIG"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["BAGIC EXTRA CARE", "HDFC CREDIT PROTECTION", "HDFC CREDIT PROTECTION PLUS", "HDFC GROUP HEALTH SHIELD"],
                        "ConditionType" : "Negative",
                        "ConditionName" : "C2"
                    }
                    
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : planOptHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 17
        });
		if(ELAFlag) {
			var planHide = new Object({
										"ConditionsArray" : [
											{
												"FieldName" : "Insurance_Product__c",
												"FieldValues" : ["HDFC CREDIT PROTECTION PLUS"],
												"ConditionType" : "Positive",
												"ConditionName" : "C1"
											}
										],
										"FinalConditionLogic" : "C1"
									});	
		}
        this.FieldList.push({
            "FieldName" : "Plan__c",
            "FieldLabel" : "Plan",
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BAGIC", "CPP"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["BAGIC EXTRA CARE", "BAGIC EXTRA CARE PLUS", "FAMILY FLOATER HEALTH GUARD", "INDIVIDUAL HEALTH GUARD", "PREMIUM PERSONAL GUARD", "AGE AGNOSTIC", "WALLET PROTECT", "BAGIC FAMILY HEALTH CARE"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : planHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 18
        });
		/*if(ELAFlag) {
			var HDFCCPPHide = new Object({
											"ConditionsArray" : [
												{
													"FieldName" : "Insurance_Product__c",
													"FieldValues" : ["WALLET PROTECT"],
													"ConditionType" : "Positive",
													"ConditionName" : "C1"
												}
											],
											"FinalConditionLogic" : "C1"
										});	
		}*/
		var HDFCCPPVal;
		if(ELAFlag) {
			HDFCCPPVal = "Single";
		}
        this.FieldList.push({
            "FieldName" : "HdfcCppType__c",
            "FieldLabel" : "HDFC CPP Type",
			"FieldValue" : HDFCCPPVal,
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["HDFC Life"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["HDFC CREDIT PROTECTION PLUS"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
            "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["HDFC Life"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["HDFC CREDIT PROTECTION PLUS"],
                        "ConditionType" : "Negative",
                        "ConditionName" : "C2"
                    },
                     {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["CONTENT - MY HOME"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C3"
                    }
                ],
                "FinalConditionLogic" : "(C1 && C2) || C3"
            },
			"FieldHide" : ELAFlag,
			//"FieldHideConditions" : HDFCCPPHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 19
        });
		if(ELAFlag) {
			var sumAssuredHide = new Object({
										"ConditionsArray" : [
											{
												"FieldName" : "Insurance_Product__c",
												"FieldValues" : ["WALLET PROTECT", "HDFC CREDIT PROTECTION PLUS"],
												"ConditionType" : "Positive",
												"ConditionName" : "C1"
											}
										],
										"FinalConditionLogic" : "C1"
									});	
		}
		var sumAssuredVal;
		if(ELAFlag) {
			sumAssuredVal = "Decreasing";
		}
        this.FieldList.push({
            "FieldName" : "Sum_Assured_Type__c",
            "FieldLabel" : "Sum Assured Type",
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BALIC", "HDFC Life","ICICI Prudential"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["GCPP", "GROUP TERM LIFE", "HDFC CREDIT PROTECTION PLUS", "HDFC CREDIT PROTECTION", "HDFC GROUP HEALTH SHIELD","I PRU GLS"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
            "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["HDFC Life", "BAGIC", "CPP", "TATA AIG","IHO"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["HDFC CREDIT PROTECTION", "HDFC CREDIT PROTECTION PLUS", "HDFC GROUP HEALTH SHIELD"],
                        "ConditionType" : "Negative",
                        "ConditionName" : "C2"
                    }                                       
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : sumAssuredHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 20
        });
		if(ELAFlag) {
			var dobDepHide = new Object({
										"ConditionsArray" : [
											{
												"FieldName" : "Insurance_Product__c",
												"FieldValues" : ["WALLET PROTECT", "HDFC CREDIT PROTECTION PLUS"],
												"ConditionType" : "Positive",
												"ConditionName" : "C1"
											}
										],
										"FinalConditionLogic" : "C1"
									});	
		}
        this.FieldList.push({
            "FieldName" : "DOB_of_Dependent_Life__c",
            "FieldLabel" : "DOB of Dependent Life",
            "FieldRequiredConditions" : null,
            "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["HDFC Life", "BAGIC", "ICICI Lombard", "ICICI Lombard GIC Ltd", "MAX Bupa", "CPP", "TATA AIG","ICICI Prudential"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["HDFC CREDIT PROTECTION PLUS"],
                        "ConditionType" : "Negative",
                        "ConditionName" : "C2"
                    },
                    {
                        "FieldName" : "HdfcCppType__c",
                        "FieldValues" : ["Single"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C3"
                    }
                ],
                "FinalConditionLogic" : "C1 && (C2 || C3)"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : dobDepHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 21
        });
		if(ELAFlag) {
			var dobPolHide = new Object({
										"ConditionsArray" : [
											{
												"FieldName" : "Insurance_Product__c",
												"FieldValues" : ["WALLET PROTECT", "HDFC CREDIT PROTECTION PLUS"],
												"ConditionType" : "Positive",
												"ConditionName" : "C1"
											}
										],
										"FinalConditionLogic" : "C1"
									});	
		}
        this.FieldList.push({
            "FieldName" : "DOB_of_Policyholder1__c",
            "FieldLabel" : "DOB of Policyholder1",
            "FieldRequiredConditions" : null,
            "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["HDFC Life", "BAGIC", "ICICI Lombard", "ICICI Lombard GIC Ltd", "MAX Bupa", "CPP", "TATA AIG","ICICI Prudential"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["HDFC CREDIT PROTECTION PLUS"],
                        "ConditionType" : "Negative",
                        "ConditionName" : "C2"
                    },
                    {
                        "FieldName" : "HdfcCppType__c",
                        "FieldValues" : ["Single"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C3"
                    }
                ],
                "FinalConditionLogic" : "C1 && (C2 || C3)"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : dobPolHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 22
        });
		if(ELAFlag) {
			var nomNameHide = new Object({
											"ConditionsArray" : [
												{
													"FieldName" : "Insurance_Product__c",
													"FieldValues" : ["WALLET PROTECT"],
													"ConditionType" : "Positive",
													"ConditionName" : "C1"
												}
											],
											"FinalConditionLogic" : "C1"
										});	
		}
        this.FieldList.push({
            "FieldName" : "Nominee_Name__c",
            "FieldLabel" : "Nominee Name",
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BALIC", "BAGIC", "HDFC Life", "CPP", "TATA AIG","ICICI Prudential","IHO"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["GCPP", "GROUP TERM LIFE", "BAGIC EXTRA CARE PLUS", "PERSONAL ACCIDENT", "BAGIC COMPREHENSIVE CARE", "HDFC CANCER CARE", "HDFC CREDIT PROTECTION", "HDFC CREDIT PROTECTION PLUS", "HDFC GROUP HEALTH SHIELD", "FAMILY FLOATER HEALTH GUARD", "INDIVIDUAL HEALTH GUARD", "CPP LIV CARE", "BAGIC FAMILY HEALTH CARE", "TAGIC GROUP CREDIT SECURE PLUS","I PRU GLS","BHFL IHO PROPERTY CARE","BHFL CPP LIFE CARE"],//Bug:23777
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : nomNameHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : "^[A-Za-z\s\. \(\)]+$",
            "FieldSequence" : 23
        });
		if(ELAFlag) {
			var nomRelHide = new Object({
											"ConditionsArray" : [
												{
													"FieldName" : "Insurance_Product__c",
													"FieldValues" : ["WALLET PROTECT"],
													"ConditionType" : "Positive",
													"ConditionName" : "C1"
												}
											],
											"FinalConditionLogic" : "C1"
										});	
		}
        this.FieldList.push({
            "FieldName" : "Nominee_Relationship__c",
            "FieldLabel" : "Nominee Relationship",
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BALIC", "BAGIC", "HDFC Life", "CPP", "TATA AIG","ICICI Prudential","IHO"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["GCPP", "GROUP TERM LIFE", "BAGIC EXTRA CARE PLUS", "PERSONAL ACCIDENT", "BAGIC COMPREHENSIVE CARE", "HDFC CANCER CARE", "HDFC CREDIT PROTECTION", "HDFC CREDIT PROTECTION PLUS", "HDFC GROUP HEALTH SHIELD", "FAMILY FLOATER HEALTH GUARD", "INDIVIDUAL HEALTH GUARD", "CPP LIV CARE", "BAGIC FAMILY HEALTH CARE", "TAGIC GROUP CREDIT SECURE PLUS","I PRU GLS","BHFL IHO PROPERTY CARE","BHFL CPP LIFE CARE"],//Bug:23777
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : nomRelHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 24
        });
		if(ELAFlag) {
			var nomDobHide = new Object({
											"ConditionsArray" : [
												{
													"FieldName" : "Insurance_Product__c",
													"FieldValues" : ["WALLET PROTECT"],
													"ConditionType" : "Positive",
													"ConditionName" : "C1"
												}
											],
											"FinalConditionLogic" : "C1"
										});	
		}
        this.FieldList.push({
            "FieldName" : "Nominee_DOB__c",
            "FieldLabel" : "Nominee DOB",
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BALIC", "HDFC Life", "BAGIC", "CPP", "TATA AIG","ICICI Prudential","IHO"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["GCPP", "GROUP TERM LIFE", "LIFE INSURANCE", "HDFC CANCER CARE", "HDFC CREDIT PROTECTION", "HDFC CREDIT PROTECTION PLUS", "HDFC GROUP HEALTH SHIELD", "CPP LIV CARE", "BAGIC FAMILY HEALTH CARE", "TAGIC GROUP CREDIT SECURE PLUS","I PRU GLS","BHFL IHO PROPERTY CARE","BHFL CPP LIFE CARE"],//Bug:23777
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : nomDobHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 25
        });
        this.FieldList.push({
            "FieldName" : "Nominee_Age__c",
            "FieldLabel" : "Nominee Age",
			"FieldHide" : ELAFlag,
			//"FieldHideConditions" : nomAgeHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 26
        });                             
        this.FieldList.push({
            "FieldName" : "Nominee_Address__c",
            "FieldLabel" : "Nominee Address",
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BALIC", "HDFC Life", "CPP"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["GCPP", "GROUP TERM LIFE", "LIFE INSURANCE", "HDFC CANCER CARE"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
			"FieldHide" : ELAFlag,
			//"FieldHideConditions" : nomAddHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 27
        });
		if(ELAFlag) {
			var nomMobHide = new Object({
											"ConditionsArray" : [
												{
													"FieldName" : "Insurance_Product__c",
													"FieldValues" : ["WALLET PROTECT"],
													"ConditionType" : "Positive",
													"ConditionName" : "C1"
												}
											],
											"FinalConditionLogic" : "C1"
										});	
		}
        this.FieldList.push({
            "FieldName" : "Nominee_Mobile__c",
            "FieldLabel" : "Nominee Mobile",
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["HDFC Life", "CPP"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["HDFC CREDIT PROTECTION", "HDFC CREDIT PROTECTION PLUS", "HDFC GROUP HEALTH SHIELD"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
            "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["TATA AIG"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["TAGIC GROUP CREDIT SECURE PLUS"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : nomMobHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : "^[6-9][0-9]{9}$",
            "FieldSequence" : 28
        });
		if(ELAFlag) {
			var insPartyHide = new Object({
											"ConditionsArray" : [
												{
													"FieldName" : "Insurance_Product__c",
													"FieldValues" : ["WALLET PROTECT", "HDFC CREDIT PROTECTION PLUS"],
													"ConditionType" : "Positive",
													"ConditionName" : "C1"
												}
											],
											"FinalConditionLogic" : "C1"
										});	
		}
        this.FieldList.push({
            "FieldName" : "Insurance_Party_type__c",
            "FieldLabel" : "Insurance Party Type",
            "FieldValue" : "Party to Loan",
            "FieldReadOnly" : true,
			"FieldHide" : ELAFlag,
            "FieldHideConditions" : insPartyHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 29
        });
        this.FieldList.push({
            "FieldName" : "App_Type__c",
            "FieldLabel" : "Applicant Type",
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : false,
            "FieldValidation" : null,
            "FieldSequence" : 30
        });
		if(ELAFlag) {
			var insTermHide = new Object({
											"ConditionsArray" : [
												{
													"FieldName" : "Insurance_Product__c",
													"FieldValues" : ["WALLET PROTECT", "HDFC CREDIT PROTECTION PLUS"],
													"ConditionType" : "Positive",
													"ConditionName" : "C1"
												}
											],
											"FinalConditionLogic" : "C1"
										});	
		}
        this.FieldList.push({
            "FieldName" : "Insurance_term__c",
            "FieldLabel" : "Insurance Term",
            "FieldReadOnly" : true,
			"FieldHide" : ELAFlag,
            "FieldHideConditions" : insTermHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 31
        });
		if(ELAFlag) {
			var criIllHide = new Object({
											"ConditionsArray" : [
												{
													"FieldName" : "Insurance_Product__c",
													"FieldValues" : ["WALLET PROTECT", "HDFC CREDIT PROTECTION PLUS"],
													"ConditionType" : "Positive",
													"ConditionName" : "C1"
												}
											],
											"FinalConditionLogic" : "C1"
										});	
		}
        this.FieldList.push({
            "FieldName" : "Critical_Illness__c",
            "FieldLabel" : "Critical Illness",
			"FieldValue" : "N",
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["BAGIC FAMILY HEALTH CARE", "TAGIC GROUP CREDIT SECURE PLUS", "CPP LIV CARE","BHFL IHO PROPERTY CARE","CONTENT - MY HOME"],
                        "ConditionType" : "Negative",
                        "ConditionName" : "C1"
                    }
                ],
                "FinalConditionLogic" : "C1"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : criIllHide,
            "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["ICICI Prudential","BAGIC"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["I PRU GLS","CONTENT - MY HOME"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 32
        });
		var DGHVal;
		if(ELAFlag) {
			DGHVal = "Y";
			var DGHHide = new Object({
											"ConditionsArray" : [
												{
													"FieldName" : "Insurance_Product__c",
													"FieldValues" : ["WALLET PROTECT"],
													"ConditionType" : "Positive",
													"ConditionName" : "C1"
												}
											],
											"FinalConditionLogic" : "C1"
										});
		}
        this.FieldList.push({
            "FieldName" : "Declaration_of_good_health__c",
            "FieldLabel" : "Declaration of Good Health",
			"FieldValue" : DGHVal,
            "FieldRequired" : true,
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : DGHHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 33
        });
		if(ELAFlag) {
			var APTDHide = new Object({
											"ConditionsArray" : [
												{
													"FieldName" : "Insurance_Product__c",
													"FieldValues" : ["WALLET PROTECT", "HDFC CREDIT PROTECTION PLUS"],
													"ConditionType" : "Positive",
													"ConditionName" : "C1"
												}
											],
											"FinalConditionLogic" : "C1"
										});	
		}
        this.FieldList.push({
            "FieldName" : "Accidental_Permanent_Total_Disability__c",
            "FieldLabel" : "Accidental Permanent Total Disability",
			"FieldValue" : "N",
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BALIC"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["GCPP", "GROUP TERM LIFE"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
            "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BAGIC", "HDFC Life", "CPP","ICICI Prudential"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["BAGIC EXTRA CARE PLUS", "PERSONAL ACCIDENT", "BAGIC COMPREHENSIVE CARE", "PROFESSIONAL INDEMNITY FOR DOCTORS", "MY HOME", "FAMILY FLOATER HEALTH GUARD", "INDIVIDUAL HEALTH GUARD", "HDFC CREDIT PROTECTION", "HDFC CREDIT PROTECTION PLUS", "HDFC GROUP HEALTH SHIELD", "CPP SHIELD", "CPP LIV CARE","I PRU GLS","CONTENT - MY HOME"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : APTDHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldSequence" : 34
        });
		if(ELAFlag) {
			var sourceHide = new Object({
											"ConditionsArray" : [
												{
													"FieldName" : "Insurance_Product__c",
													"FieldValues" : ["WALLET PROTECT", "HDFC CREDIT PROTECTION PLUS"],
													"ConditionType" : "Positive",
													"ConditionName" : "C1"
												}
											],
											"FinalConditionLogic" : "C1"
										});	
		}
        this.FieldList.push({
            "FieldName" : "Source__c",
            "FieldLabel" : "Source",
			"FieldValue" : "Web Based",
            "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["CPP"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["CPP SHIELD"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : sourceHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 35
        });
		if(ELAFlag) {
			var appNameHide = new Object({
											"ConditionsArray" : [
												{
													"FieldName" : "Insurance_Product__c",
													"FieldValues" : ["WALLET PROTECT"],
													"ConditionType" : "Positive",
													"ConditionName" : "C1"
												}
											],
											"FinalConditionLogic" : "C1"
										});	
		}
        this.FieldList.push({
            "FieldName" : "Appointee_Name__c",
            "FieldLabel" : "Appointee Name",
            "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["CPP"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["CPP SHIELD"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : appNameHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : "^[A-Za-z\s\. \(\)]+$",
            "FieldSequence" : 36
        });
		if(ELAFlag) {
			var appRelHide = new Object({
											"ConditionsArray" : [
												{
													"FieldName" : "Insurance_Product__c",
													"FieldValues" : ["WALLET PROTECT"],
													"ConditionType" : "Positive",
													"ConditionName" : "C1"
												}
											],
											"FinalConditionLogic" : "C1"
										});	
		}
        this.FieldList.push({
            "FieldName" : "Appointee_Relationship_with_Nominee__c",
            "FieldLabel" : "Appointee Relationship with Nominee",
            "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["CPP"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["CPP SHIELD"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : appRelHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldSequence" : 37
        });
		if(ELAFlag) {
			var appDobHide = new Object({
											"ConditionsArray" : [
												{
													"FieldName" : "Insurance_Product__c",
													"FieldValues" : ["WALLET PROTECT"],
													"ConditionType" : "Positive",
													"ConditionName" : "C1"
												}
											],
											"FinalConditionLogic" : "C1"
										});	
		}
        this.FieldList.push({
            "FieldName" : "Appointee_DOB__c",
            "FieldLabel" : "Appointee DOB",
            "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["CPP"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["CPP SHIELD"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : appDobHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldValidation" : null,
            "FieldSequence" : 38
        });
		if(ELAFlag) {
			var heightHide = new Object({
											"ConditionsArray" : [
												{
													"FieldName" : "Insurance_Product__c",
													"FieldValues" : ["WALLET PROTECT", "HDFC CREDIT PROTECTION PLUS"],
													"ConditionType" : "Positive",
													"ConditionName" : "C1"
												}
											],
											"FinalConditionLogic" : "C1"
										});	
		}
        this.FieldList.push({
            "FieldName" : "Height_In_Cms__c",
            "FieldLabel" : "Height (In Cms)",
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BALIC","ICICI Prudential"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["GCPP", "GROUP TERM LIFE","I PRU GLS"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
            "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BAGIC", "HDFC Life", "CPP", "TATA AIG"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["BAGIC EXTRA CARE PLUS", "PERSONAL ACCIDENT", "PROFESSIONAL INDEMNITY FOR DOCTORS", "MY HOME", "FAMILY FLOATER HEALTH GUARD", "INDIVIDUAL HEALTH GUARD", "HDFC CREDIT PROTECTION", "HDFC CREDIT PROTECTION PLUS", "HDFC GROUP HEALTH SHIELD", "CPP SHIELD", "CPP LIV CARE", "BAGIC FAMILY HEALTH CARE", "TAGIC GROUP CREDIT SECURE PLUS","CONTENT - MY HOME"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : heightHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldSequence" : 39
        });
		if(ELAFlag) {
			var weightHide = new Object({
											"ConditionsArray" : [
												{
													"FieldName" : "Insurance_Product__c",
													"FieldValues" : ["WALLET PROTECT", "HDFC CREDIT PROTECTION PLUS"],
													"ConditionType" : "Positive",
													"ConditionName" : "C1"
												}
											],
											"FinalConditionLogic" : "C1"
										});	
		}
        this.FieldList.push({
            "FieldName" : "Weight_In_Kg__c",
            "FieldLabel" : "Weight (In Kg)",
            "FieldRequiredConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BALIC","ICICI Prudential"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["GCPP", "GROUP TERM LIFE","I PRU GLS"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
            "FieldReadOnlyConditions" : {
                "ConditionsArray" : [
                    {
                        "FieldName" : "Insurance_Type__c",
                        "FieldValues" : ["BAGIC", "HDFC Life", "CPP", "TATA AIG"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C1"
                    },
                    {
                        "FieldName" : "Insurance_Product__c",
                        "FieldValues" : ["BAGIC EXTRA CARE PLUS", "PERSONAL ACCIDENT", "BAGIC COMPREHENSIVE CARE", "PROFESSIONAL INDEMNITY FOR DOCTORS", "MY HOME", "FAMILY FLOATER HEALTH GUARD", "INDIVIDUAL HEALTH GUARD", "HDFC CREDIT PROTECTION", "HDFC CREDIT PROTECTION PLUS", "HDFC GROUP HEALTH SHIELD", "CPP SHIELD", "CPP LIV CARE", "BAGIC FAMILY HEALTH CARE", "TAGIC GROUP CREDIT SECURE PLUS","CONTENT - MY HOME"],
                        "ConditionType" : "Positive",
                        "ConditionName" : "C2"
                    }
                ],
                "FinalConditionLogic" : "C1 && C2"
            },
			"FieldHide" : ELAFlag,
			"FieldHideConditions" : weightHide,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : true,
            "FieldSequence" : 40
        });
		if(ELAFlag) {
			var polNoHide = new Object({
										"ConditionsArray" : [
											{
												"FieldName" : "Insurance_Product__c",
												"FieldValues" : ["WALLET PROTECT"],
												"ConditionType" : "Positive",
												"ConditionName" : "C1"
											}
										],
										"FinalConditionLogic" : "C1"
									});	
		}
        this.FieldList.push({
            "FieldName" : "Policy_number__c",
            "FieldLabel" : "Policy number",
            "FieldReadOnly" : true,
			"FieldHide" : ELAFlag,
            "FieldHideConditions" : polNoHide,
            "FieldVisibleInTable" : true,
            "FieldVisibleInModal" : true,
            "FieldSequence" : 41
        });
		if(ELAFlag) {
			var insErrorHide = new Object({
											"ConditionsArray" : [
												{
													"FieldName" : "Insurance_Product__c",
													"FieldValues" : ["WALLET PROTECT"],
													"ConditionType" : "Positive",
													"ConditionName" : "C1"
												}
											],
											"FinalConditionLogic" : "C1"
										});	
		}
        this.FieldList.push({
            "FieldName" : "Insurance_API_Error__c",
            "FieldLabel" : "Insurance API Error",
            "FieldReadOnly" : true,
			"FieldHide" : ELAFlag,
            "FieldHideConditions" : insErrorHide,
            "FieldVisibleInTable" : true,
            "FieldVisibleInModal" : true,
            "FieldSequence" : 42
        });
        this.FieldList.push({
            "FieldName" : "API_Callout_Attempt_Count__c",
            "FieldLabel" : "API Callout Attempt Count",
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : false,
            "FieldSequence" : 43
        });
        this.FieldList.push({
            "FieldName" : "API_Callout_Time__c",
            "FieldLabel" : "API Callout Time",
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : false,
            "FieldSequence" : 44
        });
        this.FieldList.push({
            "FieldName" : "Response_Date__c",
            "FieldLabel" : "Response Date",
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : false,
            "FieldSequence" : 45
        });
        this.FieldList.push({
            "FieldName" : "Request_Pick_Time__c",
            "FieldLabel" : "Request Pick Time",
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : false,
            "FieldSequence" : 46
        });
        this.FieldList.push({
            "FieldName" : "ResponseCode__c",
            "FieldLabel" : "Response Code",
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : false,
            "FieldSequence" : 47
        });
        this.FieldList.push({
            "FieldName" : "Validate_Insurance__c",
            "FieldLabel" : "Validate Insurance",
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : false,
            "FieldSequence" : 48
        });
        this.FieldList.push({
            "FieldName" : "Product_Flag__c",
            "FieldLabel" : "Product Flag",
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : false,
            "FieldSequence" : 49
        });
        
        if(flow == "PO" && this.productOfferObject) {
            this.FieldList.push({
                "FieldName" : "Opportunity__c",
                "FieldLabel" : "Loan Application",
                "FieldValue" : this.productOfferObject.Opportunity__c,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : false,
                "FieldSequence" : 50
            });
            if(this.productOfferObject.Opportunity__c) {
                this.FieldList.push({
                    "FieldName" : "Opportunity__r.StageName",
                    "FieldLabel" : "Loan Application Stage",
                    "FieldValue" : this.productOfferObject.Opportunity__r.StageName,
                    "FieldVisibleInTable" : false,
                    "FieldVisibleInModal" : false,
                    "FieldSequence" : 51
                });
            }
            this.FieldList.push({
                "FieldName" : "Product_Offerings__c",
                "FieldLabel" : "Product Offerings",
                "FieldValue" : this.productOfferObject.Id,
                "FieldRequiredConditions" : null,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : false,
                "FieldValidation" : null,
                "FieldSequence" : 52
            });
            if(this.productOfferObject.Lead__c) {
                this.FieldList.push({
                    "FieldName" : "Product_Offerings__r.Lead__r.DOB_Cibil__c",
                    "FieldLabel" : "DOB",
                    "FieldValue" : this.productOfferObject.Lead__r.DOB_Cibil__c,
                    "FieldVisibleInTable" : false,
                    "FieldVisibleInModal" : false,
                    "FieldSequence" : 53
                }); 
                this.FieldList.push({
                    "FieldName" : "Product_Offerings__r.Lead__r.DOB__c",
                    "FieldLabel" : "DOB1",
                    "FieldValue" : this.productOfferObject.Lead__r.DOB__c,
                    "FieldVisibleInTable" : false,
                    "FieldVisibleInModal" : false,
                    "FieldSequence" : 54
                });
            }
            this.FieldList.push({
                "FieldName" : "Product_Offerings__r.Offer_Amount__c",
                "FieldLabel" : "Offer Amount",
                "FieldValue" : this.productOfferObject.Offer_Amount__c,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : false,
                "FieldSequence" : 55
            });
            this.FieldList.push({
                "FieldName" : "Product_Offerings__r.Id",
                "FieldLabel" : "Product Offerings Id",
                "FieldValue" : this.productOfferObject.Id,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : false,
                "FieldSequence" : 56
            });
            this.FieldList.push({
                "FieldName" : "Product_Offerings__r.Products__c",
                "FieldLabel" : "Offer Product",
                "FieldValue" : this.productOfferObject.Products__c,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : false,
                "FieldSequence" : 57
            });
            this.FieldList.push({
                "FieldName" : "Product_Offerings__r.Tenor__c",
                "FieldLabel" : "Tenor",
                "FieldValue" : this.productOfferObject.Tenor__c,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : false,
                "FieldSequence" : 58
            });
            this.FieldList.push({
                "FieldName" : "Product_Offerings__r.Lead__c",
                "FieldLabel" : "Lead Id",
                "FieldValue" : this.productOfferObject.Lead__c,
                "FieldVisibleInTable" : false,
                "FieldVisibleInModal" : false,
                "FieldSequence" : 59
            });
        } else 
            if((flow == "OPP" || flow == "ELA") && this.LoanObject) {
                if(this.LoanObject.Account) {
                    this.FieldList.push({
                        "FieldName" : "Opportunity__r.Account.Date_of_Birth__c",
                        "FieldLabel" : "DOB",
                        "FieldValue" : this.LoanObject.Account.Date_of_Birth__c,
                        "FieldVisibleInTable" : false,
                        "FieldVisibleInModal" : false,
                        "FieldSequence" : 50
                    });
                }
                this.FieldList.push({
                    "FieldName" : "Opportunity__r.Approved_Loan_Amount__c",
                    "FieldLabel" : "Approved Loan Amount",
                    "FieldValue" : this.LoanObject.Approved_Loan_Amount__c,
                    "FieldVisibleInTable" : false,
                    "FieldVisibleInModal" : false,
                    "FieldSequence" : 51
                });
                this.FieldList.push({
                    "FieldName" : "Opportunity__r.Loan_Application_Number__c",
                    "FieldLabel" : "Loan Application Number",
                    "FieldValue" : this.LoanObject.Loan_Application_Number__c,
                    "FieldVisibleInTable" : false,
                    "FieldVisibleInModal" : false,
                    "FieldSequence" : 52
                });
                this.FieldList.push({
                    "FieldName" : "Opportunity__c",
                    "FieldLabel" : "Loan Application",
                    "FieldValue" : this.LoanObject.Id,
                    "FieldVisibleInTable" : false,
                    "FieldVisibleInModal" : false,
                    "FieldSequence" : 53
                });
                this.FieldList.push({
                    "FieldName" : "Opportunity__r.StageName",
                    "FieldLabel" : "Loan Application Stage",
                    "FieldValue" : this.LoanObject.StageName,
                    "FieldVisibleInTable" : false,
                    "FieldVisibleInModal" : false,
                    "FieldSequence" : 54
                });
                this.FieldList.push({
                    "FieldName" : "Opportunity__r.Product__c",
                    "FieldLabel" : "Product",
                    "FieldValue" : this.LoanObject.Product__c,
                    "FieldVisibleInTable" : false,
                    "FieldVisibleInModal" : false,
                    "FieldSequence" : 55
                });
                this.FieldList.push({
                    "FieldName" : "Opportunity__r.Tenor__c",
                    "FieldLabel" : "Tenor",
                    "FieldValue" : this.LoanObject.Tenor__c,
                    "FieldVisibleInTable" : false,
                    "FieldVisibleInModal" : false,
                    "FieldSequence" : 56
                });
                component.set("v.product", this.LoanObject.Product__c);
            }
        this.FieldList.push({
            "FieldName" : "Saved_Via_Lightning__c",
            "FieldLabel" : "Saved Via Lightning",
            "FieldRequired" : false,
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : false,
            "FieldValidation" : null,
            "FieldSequence" : 60
        });
        this.FieldList.push({
            "FieldName" : "CreatedDate",
            "FieldLabel" : "Created Date",
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : false,
            "FieldSequence" : 61
        });
        this.FieldList.push({
            "FieldName" : "Premium_Amount_Params__c",
            "FieldLabel" : "Premium Amount Params",
            "FieldVisibleInTable" : false,
            "FieldVisibleInModal" : false,
            "FieldSequence" : 62
        });
		// 20985 S 
        /*if(isMortgageProduct){
         this.FieldList.push({
            "FieldName" : "Tranche_Number__c",
                "FieldLabel" : "Tranche Number",
                "FieldRequired" : false,
                "FieldVisibleInTable" : true,
                "FieldVisibleInModal" : true,
                "FieldType" : "PICKLIST",
                "PicklistProp" : this.trancheNumberList  
        });
        }*/
        //20985 E 
        component.set("v.IdList", this.IdList);
        component.set("v.FieldList", this.FieldList);
        console.log('FLDLIST::'+JSON.stringify(component.get("v.FieldList")));
        component.set("v.showDetailsComponent", true);
		if(ELAFlag) {
			component.set("v.PicklistValuesMapping", PicklistValuesMapping);	
		}
    }
})