({
    getFeesAndChargesData : function(component,event) {
        this.showhidespinner(component,event,true);
        var oppId = component.get("v.OppId");
        console.log('Id is:::'+oppId);
        if(oppId != null){
            this.executeApex(component, "getFeesList", {
                "oppId" : oppId
            }, function (error, result) {
                
                if (!error && result) { 
                                                                          console.log('nanda4'+component.get("v.displayReadOnly"));

                    console.log('Fees'+result);
                    var objlst = JSON.parse(result);
                    console.log('Fees obj'+objlst.FeesWrapperList);
                                        console.log('objlst.showOnVas+ '+objlst.showOnVas);
                   if($A.util.isEmpty(objlst) )
                    {
                       this.getFeesAndChargesData(component,event);
                    }
                    if(!$A.util.isEmpty(objlst)){
                        component.set("v.FeesList",objlst.FeesWrapperList);
                        console.log('Wrapper List'+JSON.stringify(objlst.FeesWrapperList));
                        component.set("v.FeesListRecieved",true);
                        if(component.get("v.showInDisbSectionFlag")) //if loop added by hrushikesh,to reuse in DisbursmentSection
                        {
                            component.set("v.FeesList",objlst.FeesToShowOnDisb);
                            var indexLst = [];
                            var i;
                            for (i = 0; i < objlst.FeesToShowOnDisb.length; i++) { 
                                if(objlst.FeesToShowOnDisb[i].FeesObj.Deducted_from_Disbursement__c!= 'Yes' ||objlst.FeesToShowOnDisb[i].FeesObj.Change_Amount__c==0 )
                                {
                                    //indexLst.push(i);
                                    //objlst.splice(i, 1);
                                }
                                else{
                                    indexLst.push(objlst.FeesToShowOnDisb[i]);
                                }
                            }
                            /*if(indexLst != null && indexLst.length() > 0){
                            	for(i=0;i < indexLst.length;i++){
                                	objlst.splice(indexLst[i],1);
                            	}
                            }*/
                            console.log('indexLst is '+indexLst);
                            component.set("v.FeesList",indexLst); 
                        }
                    }
                    this.showhidespinner(component,event,false);
 
                }  
                                                                         console.log('nanda5'+component.get("v.displayReadOnly"));

            });
        }
        else
                    this.showhidespinner(component,event,false);
    },
    saveFeesAndCharges : function(component,event){
        this.showhidespinner(component,event,true);
        var FeesList = component.get("v.FeesList");
        var id = FeesList.Key + 'Fees';
        console.log('Fees List::: '+FeesList+' '+id);            
        for(var i=0;i<FeesList.size;i++){
            if(component.find(id).get("v.value")){
                FeesList.checked = true;
            }
            else{
                FeesList.checked = false;
            }
        }
        component.set("v.FeesList",FeesList);
        var JsonFeesList = JSON.stringify(FeesList);
        this.executeApex(component, "saveFeesList", {
            "FeesList" : JsonFeesList
        }, function (error, result) {
            if(!error && result){
                if(result.toString() == 'Success'){
                    component.set('v.showNext',true);
                    this.displayToastMessage(component,event,'Success','Details saved successfully','success');
                      this.showhidespinner(component,event,false);
                }
                else{
                    this.displayToastMessage(component,event,'Info','No records to save','info');
                      this.showhidespinner(component,event,false);

                }
            }else{
                this.displayToastMessage(component,event,'Error','An error occured while saving.Please try again later or contact HR','error');
                   this.showhidespinner(component,event,false);

            }
        });
    },
    getDisbursmentData : function(component,event){
        this.showhidespinner(component,event,true);
        var oppId = component.get("v.OppId");
        if(oppId != null){
            this.executeApex(component, "getDisbursmentData", {
                "oppId" : oppId
            }, function (error, result) {
                
                if (!error && result) { 
                    console.log('result '+result);
                    var objlst = JSON.parse(result);
                    component.set("v.oppObj",objlst.opp);
                  console.log('nanda1'+ objlst.primaryApplicant.Employee_Modified__c +component.get("v.displayReadOnly"));
                    
                    if(objlst.opp.StageName != 'Post Approval Sales' || objlst.primaryApplicant.Employee_Modified__c == true || objlst.primaryApplicant.Decline_Reasons__c != null){
                        console.log('inside read only condition');
                    	component.set("v.displayReadOnly",true);
                    }
                    else{
                       // component.set("v.displayReadOnly",false);
                    }
                    if(objlst.primaryApplicant.Emp_tele_identifier__c == true)
                    {
                       console.log('sd'+objlst.primaryApplicant.Emp_tele_identifier__c);
 					   component.set('v.displayReadOnly',true);
                    } else{
                       // component.set("v.displayReadOnly",false);
                    }
                    if(!$A.util.isEmpty(objlst.primaryApplicant.Application_Form_Timestamp__c) || !$A.util.isEmpty(objlst.primaryApplicant.IP_Address_Timestamp__c)){
                        component.set('v.displayReadOnly',true);
                    } else{
                        //component.set("v.displayReadOnly",false);
                    }

                }
                else{
                    console.log("Error:::::"+error);
                    this.displayToastMessage(component,event,'Error','Unable to fetch loan details','error');
                }
                                                      console.log('nanda3'+component.get("v.displayReadOnly"));

                    
            });
                this.showhidespinner(component,event,false);
}
        else{
                    this.showhidespinner(component,event,false);
            this.displayToastMessage(component,event,'Error','No loan record found','error');
        }
        
    },
    executeApex : function(component, method, params,callback){
        
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
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
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    displayToastMessage:function(component,event,title,message,type)
    {
        
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    },
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
            
        });
        showhideevent.fire();
    },
	
	// Start of changes - 22181
	// Added by Anurag for 23390 S
	getInsuranceList : function(component, event, helper) {
		var loanId = component.get("v.OppId");
		var valInsBtn = component.find("validateInsuranceBtn");
        console.log("valInsBtn: ",JSON.stringify(valInsBtn));
        // console.log("valInsBtn: ",component.get("z"));
		this.executeApex(component, "getInsuranceList", {
            "loanId" : loanId
        }, function (error, result) {
            if (!error && result) {

				console.log('result '+result);
				var objlst = JSON.parse(result);
				// component.set("v.oppHasInsurance",objlst.oppHasInsurance);
				if(!objlst.oppHasInsurance){
                    console.log("objlst.oppHasInsurance && valInsBtn");
                    component.set("v.isValInsDisabled", true);
                    console.log("valInsBtn: ",component.get("v.isValInsDisabled"));
                    // valInsBtn.set("v.disabled", true);
                }
				console.log('nanda7'+component.get("v.displayReadOnly"));
			}
			else{
				console.log("Error:::::"+error);
				// this.displayToastMessage(component,event,'Error','Unable to fetch loan details','error');
			}
        });
	},
	// Added by Anurag for 23390 E
	validateInsuranceBeforeNextStageHelper : function(component, event, helper) {
		var nextBtn = component.find("Next");
		var loanId = component.get("v.OppId");
		var action = component.get("c.validateSendFinnone");
		action.setParams({
			"loanId" : loanId
		});
		if(action) {
			action.setCallback(this, function(response) {
				var state = response.getState();
				if(component.isValid() && state === "SUCCESS") {
					var resultStr = response.getReturnValue();
					console.log("resultStr :: " + resultStr);
					var resultObj = JSON.parse(resultStr);
					if(resultObj) {
						if(resultObj.isSuccess) {
							helper.validateMedicalQuestionnaireHelper(component, event, helper);
						} else {
							if(resultObj.allowProceed) {
								var confirmAns = confirm(resultObj.errStr);
								if(confirmAns) {
									helper.validateMedicalQuestionnaireHelper(component, event, helper);
								} else {
									if(nextBtn) {
										nextBtn.set("v.disabled", false);	
									}
								}
							} else {
                                // Added by Anurag for 22181
                                component.set("v.selTabId","tab3");
                                this.displayToastMessage(component,event,'Info',resultObj.errStr,'info');
                                // alert(resultObj.errStr);
								if(nextBtn) {
									nextBtn.set("v.disabled", false);	
								}
							} 
						}
					} else {
                        component.set("v.selTabId","tab3");
                        this.displayToastMessage(component,event,'Info',"Something went wrong! Please refresh the page and try again!",'info');
						// alert("Something went wrong! Please refresh the page and try again!");
						if(nextBtn) {
							nextBtn.set("v.disabled", false);	
						}
					}
				} else {
                    component.set("v.selTabId","tab3");
                    this.displayToastMessage(component,event,'Info',"Something went wrong! Please refresh the page and try again!",'info');
					// alert("Something went wrong! Please refresh the page and try again!");
					if(nextBtn) {
						nextBtn.set("v.disabled", false);	
					}
				}
			});
			$A.enqueueAction(action);
            // Added by Anurag for 22181
            // console.log("v.selTabId: ", component.get("v.selTabId"));
            // console.log("v.selTabId: ", component.find("tabSection").get("v.selectedTabId"));
            // if(event)
            	// event.pause();
		}
	},
	
	validateMedicalQuestionnaireHelper : function(component, event, helper) {
		var nextBtn = component.find("Next");
		var loanId = component.get("v.OppId");
		var action = component.get("c.fdQuesValidate");
		action.setParams({
			"loanId" : loanId
		});
		if(action) {
			action.setCallback(this, function(response) {
				var state = response.getState();
				if(component.isValid() && state === "SUCCESS") {
					var resultStr = response.getReturnValue();
					console.debug("resultStr :: " + resultStr);
					var resultObj = JSON.parse(resultStr);
					if(resultObj.isValid) {
						component.set("v.selTabId", "tab4");
					} else {
						if(resultObj.msgStr1) {
                            // console.log("Med 1");
                            // component.set("v.setTab", false);
                            component.set("v.selTabId","tab3");
                            this.displayToastMessage(component,event,'Info',resultObj.msgStr1,'info');
							// alert(resultObj.msgStr1);
                            // Added by Anurag for 22181
                            // component.set("v.selTabId","tab3");
						} else 
							if(resultObj.msgStr2) {
                                component.set("v.selTabId","tab3");
                                this.displayToastMessage(component,event,'Info',resultObj.msgStr2,'info');
								// alert(resultObj.msgStr2);
                                // Added by Anurag for 22181
                                
							}
                        // console.log("v.selTabId: ", component.get("v.selTabId"));
					}
				} else {
                    component.set("v.selTabId","tab3");
                    this.displayToastMessage(component,event,'Info',"Something went wrong! Please refresh the page and try again!",'info');
					// alert("Something went wrong! Please refresh the page and try again!");
				}
				if(nextBtn) {
					nextBtn.set("v.disabled", false);	
				}
			});
			$A.enqueueAction(action);	
		}
	},
	
	validateInsuranceHelper : function(component, event, helper) { 
		var className = document.getElementById("InsuranceSectionDiv").className;
		if(!className.includes("disabledDiv")) {
			className += " disabledDiv";
			document.getElementById("InsuranceSectionDiv").className = className;
		}
		component.set("v.isValInsDisabled", true);
        /*
		var valInsBtn = component.find("validateInsuranceBtn");
		if(valInsBtn) {
			valInsBtn.set("v.disabled", true);
		}
		*/
        var loanId = component.get("v.OppId");
		var action = component.get("c.validateInsuranceDetails");
		action.setParams({
			"loanId" : loanId
		});
		if(action) {
			action.setCallback(this, function(response) {
				var state = response.getState();
				if(component.isValid() && state === "SUCCESS") {
					var result = response.getReturnValue();
                    console.log("state: ",result);
					var resultStr = JSON.parse(result);
					console.debug("resultStr :: " + resultStr);
					if(resultStr) {
						if(resultStr.isSuccess) {
							if(document.getElementById("InsuranceSectionDiv")) {
								var differenceTimeLabel = $A.get("$Label.c.Insurance_Validation_Interval");
                                // component.set("v.selTabId","tab3");
                                // this.displayToastMessage(component,event,'Info',"Please wait for " + differenceTimeLabel + " seconds",'info');
								alert("Please wait for " + differenceTimeLabel + " seconds");
								
								className = document.getElementById("InsuranceSectionDiv").className;
								className += " disabledDiv";
								document.getElementById("InsuranceSectionDiv").className = className;
								// Added by Anurag
								var that = this;
								setTimeout(function() {
									console.log("this.displayToastMessage 1");
                                    // that.displayToastMessage(component,event,'Info',"Your insurance details are validated!",'success');
									alert("Your insurance details are validated!");
									console.log("this.displayToastMessage 2");
									// alert("Your insurance details are validated!");
									if(document.getElementById("InsuranceSectionDiv")) {
										className = className.replace("disabledDiv", "");
										document.getElementById("InsuranceSectionDiv").className = className;
									}
									component.set("v.isInsuranceSectionVisible", false);
									setTimeout(function() {
										component.set("v.isInsuranceSectionVisible", true);
									}, 100);
								}, differenceTimeLabel * 1000);
							}
						} else {
							var errorMsg = resultStr.errorString;
							if(errorMsg) {
								if(errorMsg == "mandatoryFieldsMissing") {
									var validationWindow = window.open("/apex/ValidateInsuranceDetails?LoanId=" + loanId, "Validate Insurance Details For " + loanId, "toolbar=yes,scrollbars=yes,resizable=yes,top=100,left=200,width=800,height=500");
                                    // console.log("validationWindow!");
                                    // Need to change URL here on each Sandbox
                                    // var validationWindow = window.open("http://uat-bflloans.cs57.force.com/ValidateInsuranceDetails?LoanId=" + loanId, "Validate Insurance Details For " + loanId, "toolbar=yes,scrollbars=yes,resizable=yes,top=100,left=200,width=800,height=500");
                                } else {
                                    component.set("v.selTabId","tab3");
                                    this.displayToastMessage(component,event,'Info',errorMsg,'info');
									// alert(errorMsg);
								}	
							}
							className = className.replace("disabledDiv", "");
							document.getElementById("InsuranceSectionDiv").className = className;
                            component.set("v.isValInsDisabled", false);
                            /*
							if(valInsBtn) {
								valInsBtn.set("v.disabled", false);
							}
                            */
						}
					} else {
						className = className.replace("disabledDiv", "");
						document.getElementById("InsuranceSectionDiv").className = className;
                        component.set("v.isValInsDisabled", false);
                        /*
						if(valInsBtn) {
							valInsBtn.set("v.disabled", false);
						}
                        */
					}
				} else {
					className = className.replace("disabledDiv", "");
					document.getElementById("InsuranceSectionDiv").className = className;
                    component.set("v.isValInsDisabled", false);
                    /*
					if(valInsBtn) {
						valInsBtn.set("v.disabled", false);
					}
                    */
				}
			});
			$A.enqueueAction(action);	
		}
	},
	// End of changes - 22181
	callFeesAndCharges : function(component, event){
        this.showhidespinner(component,event,true);
        console.log('loan id passed is::::'+ component.get("v.OppId"));
        this.executeApex(component,"callCharges",{
            "oppId": component.get("v.OppId")
        },function(error, result){
            if(!error && result){
                console.log('result is VA '+result);
                this.getFeesAndChargesData(component,event);   
               // this.showhidespinner(component,event,false);
                
            }
            
            this.showhidespinner(component, event,false);
        });
        
    },
})