({
	getProductOfferings: function(component, converted, submitted) {
                       
        this.executeApex(component, 'getProductOfferings', {
            "poId": component.get("v.poId")
        }, function(error, result){
            if(!error && result){
              //Bug 24237 S
                 debugger;
              //  console.log('result is#'+JSON.parse(JSON.stringify(result)));
                var poResult = result;
                if(poResult.Opportunity__r!=null &&poResult.Opportunity__r!=undefined)
                {
                    console.log('poResult'+poResult.Opportunity__r.StageName);  
                    component.set("v.oppStageName",poResult.Opportunity__r.StageName);
                         
                }
                 //Bug 24237 E
                 // Bug 22425 CC Code changes SME S 
                var segmentList=[];
                if($A.get("$Label.c.CC_Pro_Loan_Seg"))
                 segmentList = $A.get("$Label.c.CC_Pro_Loan_Seg").split(',');
                 debugger;
                // US : 2702
                if(!result.SOL_Policys__r && segmentList.length>0 && result.Lead__r != null && result.Lead__r.Profession_Type__c && segmentList.includes(result.Lead__r.Profession_Type__c.toUpperCase())  && ($A.util.isEmpty(result.Lead__r.CC_Disposition__c)))
                     component.set("v.ccAlert",true);
              //  Bug 22425 CC Code changes SME E 
                this.setPOData(component, result);
                var convertible = (result.Field_Desposition_Status__c === "Docs Received"); 
                //Bug 24927 S if GCO and residence address not changed ,then CPV not mandatory
                var GCOCampaignLists = component.get("v.GCOCampaignList");
                if(GCOCampaignLists.includes(result.Campaign_Type__c) && result.Lead__r.Resi_Address_Changed__c == false)
                {
                	component.set("v.iscpvMandatory",false);     
                }
                //Bug 24927 E
                var all = (converted && submitted) || (!converted && !convertible);
                console.log('inside get product offerings');
                console.log(submitted);
                console.log((converted === "true"||converted === true));
        		this.disableButtons(component, all, true, !(!converted && convertible), !((converted === "true"||converted === true) && !submitted), true);
            }
        });
    },
    populateFieldDispositionData: function(component, converted) {
        this.executeApex(component, 'getFieldDisposition', {}, function(error, result){
            console.log('=======>> '+result);
            if(!error && result){
                var fieldDisposition1 = component.get("v.po.Field_Disposition_1__c");
                console.log('Acomponent.get("v.po.Field_Disposition_1__c")'+component.get("v.po.Field_Disposition_1__c"));
                this.setSelectOptions(component, result, "", "fieldDisposition");
               // 8734:USERSTORY_Disposition starts 
                component.set("v.po.Field_Disposition_1__c",fieldDisposition1);
               // 8734:USERSTORY_Disposition ends 
                if(component.get("v.po.Field_Disposition_1__c")){
                    // 8734:USERSTORY_Disposition starts 
                    this.populateDispositionData(component, converted,true);
                    // 8734:USERSTORY_Disposition ends 
                    this.showHideFollowupFields(component);
                }
            }
        });
    },
    // 8734:USERSTORY_Disposition starts 
    populateDispositionData: function(component, converted,onload) {
        if(!onload){
            console.log('test value'+component.get("v.po.Field_Desposition_Status__c"));
            this.populateDispositionDataInternal(onload,component, converted, "disposition", {
            "controllingField": "Field_Disposition_1__c",
            "dependentField": "Field_Desposition_Status__c",
            "fldDisposition": component.get("v.po.Field_Disposition_1__c")
        }, function(){
            if(component.get("v.po.Field_Desposition_Status__c")){
                    this.populateFieldCheckData(component, converted,onload);
            }
        });
        } 
        else{
           	var fieldDispositionStatus = component.get("v.fieldDispositionStatus");
            console.log('Field_Desposition_Status__c#'+fieldDispositionStatus);
            var result = [];
            result.push(fieldDispositionStatus);
            this.setSelectOptions(component, result, "", "disposition");
            var self = this;
            window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.po.Field_Desposition_Status__c",fieldDispositionStatus);
                    if (component.get("v.po.Field_Desposition_Status__c")) {
                        self.populateFieldCheckData(component, converted,onload);
                    }
                }), 1000
            );
            
        }
    },
    
    populateFieldCheckData: function(component, converted,onload) {
      //  var self = component;
     	var fieldCheckStatus = component.get("v.po.Field_Check_Status__c");
        if(!onload){
            console.log('fieldCheckStatus'+fieldCheckStatus);
            this.populateDispositionDataInternal(onload,component, converted, "fieldCheckStatus", {
            "controllingField": "Field_Desposition_Status__c",
            "dependentField": "Field_Check_Status__c",
            "fldDisposition": component.get("v.po.Field_Desposition_Status__c")
            }, function() {
                
            }); 
        }else{
            var fieldCheckStatusVal = component.get("v.fieldCheckStatus");
            console.log('#fieldCheckStatus'+fieldCheckStatusVal);
            var result = [];
            result.push(fieldCheckStatusVal);
            this.setSelectOptions(component, result, "", "fieldCheckStatus");
            component.set("v.po.Field_Check_Status__c",fieldCheckStatusVal);

        }
      
    },
    // 8734:USERSTORY_Disposition ends 
    populateDispositionDataInternal: function(onload,component, converted, elementId, params, callback) {
        var fieldCheckStatus = component.get("v.po.Field_Check_Status__c");
        this.executeApex(component, 'getDisposition', params, function(error, result){
            if(!error && result){
                console.log('#converted');
                this.setSelectOptions(component, result, "", elementId);
                component.find(elementId).set("v.disabled", !!converted);
            } else {
                this.disableForm(component);
            }
            callback.call(this);
        });
    },
    showHideFollowupFields: function(component, converted){
        if(this.isEnableFollowupFields(component)){
            $A.util.removeClass(component.find("followup"), 'slds-hide');
            if(converted){
                this.disableFollowupFields(component);
            }
        } else {
           component.find("followUpDate").set("v.value","");
           $A.util.addClass(component.find("followup"), 'slds-hide');
        }
    },
    isEnableFollowupFields: function(component){
        return (component.get("v.po.Field_Disposition_1__c") === 'Followup');
    },
    setSelectOptions: function(component, data, label, cmpId){
        var opts = [{"class": "optionClass", label: "Select " + label, value: ""}];
        for(var i=0; i < data.length; i++){
            opts.push({"class": "optionClass", label: data[i], value: data[i]});
        }
        component.find(cmpId).set("v.options", opts);
    },
    populateCreditSelectList: function(component) {
        // Bug Id : 21804
        // auto allocation has error sent display that TBD
        console.log('loan id -->' + component.get("v.loanId"));
        this.executeApex(component, 'autoQueueAllocation', {
            "opp": component.get("v.loanId")
        },
                         function(error, result) {
                             console.log('error -->', error);
                             var parsedVal = JSON.parse(result);
                             console.log('if -->' + parsedVal);
                             if (!error && parsedVal != null && parsedVal != undefined) {
                                 // based on that invoke submitApprover
                                 console.log('result -->', JSON.stringify(result));
                                 //debugger;
                                 console.log('parsedVal -->', parsedVal);
                                 //debugger;
                                 var confirmVar = confirm("Are you sure you want to send to Credit?");
                                 if (confirmVar == true) {
                                     this.executeApex(component, 'submitApprover', {
                                         "approverId": parsedVal,
                                         "poId": component.get("v.poId"),
                                         "loanId": component.get("v.loanId"),
                                         "isAutoCredit": true
                                     }, function(error, result) {
                                         if (!error && result === 'true') {
                                             this.showToast(component, "Success!", "Loan application submitted to credit successfully", "success");
                                             component.set("v.isAutoCredit", true); // Bug Id : 22446
                                         }
                                         if(error || result === 'false'){// Bug Id : 25285 - Concurrency Issue start -unlock p2
                            				if (parsedVal != null && parsedVal != undefined) {
                                             	this.executeApex(component, 'unlockRecord', {"colId": parsedVal},
                            					function(error, result) {});
                                            }
                        				}// Bug Id : 25285 - Concurrency Issue end -unlock p2
                                         this.disableForm(component);
                                     });
                                 }  else {
                                     if (parsedVal != null && parsedVal != undefined) {  // Bug Id : 25285 - Concurrency Issue start
                                         console.log('clicked cancel to auto allocation --> ');
                                         this.executeApex(component, 'unlockRecord', {"colId": parsedVal},
                                         function(error, result) {});
                                     }  // Bug Id : 25285 - Concurrency Issue end
                                 }
                             } else {
                                 console.log('else -->');
                                 debugger;
                                 this.executeApex(component, 'fetchCreditDetails', {
                                     "poId": component.get("v.poId")
                                 }, function(error, result) {
                                     if (!error && result) {
                                         var options = [{
                                             "class": "optionClass",
                                             label: "Select",
                                             value: ""
                                         }];
                                         for (var i = 0; i < result.length; i++) {
                                             options.push({
                                                 "class": "optionClass",
                                                 label: result[i].Credit_Officer_Name__r.Name,
                                                 value: result[i].Id
                                             });
                                         }
                                         var element = component.find("creditOfficer");
                                         element.set("v.options", options);
                                         element.set("v.disabled", false);
                                         this.disableButtons(component, true);
                                         $A.util.removeClass(component.find("creditOfficerDiv"), 'slds-hide');
                                         //debugger;
                                     } else {
                                         this.disableForm(component);
                                     }
                                 });
                             }
                         });
    },
    submitCreditApprover: function(component) {
        this.executeApex(component, 'submitApprover', {
            "approverId": component.find("creditOfficer").get("v.value"),
            "poId": component.get("v.poId"),
            "loanId": component.get("v.loanId")
        }, function(error, result){
            if(!error && result === 'true'){
                this.showToast(component, "Success!", "Loan application submitted to credit successfully", "success");
            } else {// Bug Id : 25285 - Concurrency Issue start -unlock p2
				this.showToast(component, "Error!", "Failed to submit to approver", "error"); 
                this.executeApex(component, 'unlockRecord', {"colId": component.find("creditOfficer").get("v.value")},
                function(error, result) {});
                        // Bug Id : 25285 - Concurrency Issue end -unlock p2
            }
            this.disableForm(component);
        });
    },
    
     checkCPVDone: function(component){
       
    },
    
    convertToLoanApplication: function(component){
        
         this.executeApex(component, 'IsCPVDone', {            
           	"poId": component.get("v.poId")
        }, function(error, result){
            console.log(result);
            console.log(error);
            if(!error){
                 //Bug 24927 S added iscpvMandatory if in condition
                var GCOCampaignLists = component.get("v.GCOCampaignList");
				console.log('GCO list'+GCOCampaignLists);
                console.log('campaign type vaLUE'+component.get("v.po.Campaign_Type__c"));
                if(GCOCampaignLists.includes(component.get("v.po.Campaign_Type__c"))){
                    if(component.get("v.iscpvMandatory") == true){
                        if (result == true) {
                            console.log('resultA');
                            this.convertToLoanApplication1(component);
                        }
                        else
               {
                            console.log('resultB');
                            this.showToast(component, "Error!", "CPV not yet done, please complete CPV before convert to Loan Application", "error"); 
           		 }
                    }
                    else
                    {
                        this.convertToLoanApplication1(component);
                    }
                }
                else{
                    if(result == true)                        
                    { 
                   this.convertToLoanApplication1(component);
               }
             else
                        this.showToast(component, "Error!", "CPV not yet done, please complete CPV before convert to Loan Application", "error");
                }
               
            } 
        });
               
    },
    convertToLoanApplication1: function(component){
        console.log('convertToLoanRemoteOne');
        this.executeApex(component, 'convertToLoanRemoteOne', {
            			"leadId": component.get("v.po.Lead__c"), 
           				"poId": component.get("v.poId")
       				 }, function(error, result){
                         console.log(result);
                         if(!error && result && result.length && !result.includes("exception")){
                             var resObjOne = JSON.parse(result);
                             var outputMapOne = resObjOne["outputMap"];
                             var jasonstr = JSON.stringify(outputMapOne);
                            if(resObjOne["status"].indexOf('success') != -1){
                                 this.convertToLoanTwo(component,jasonstr);
                            }else if(resObjOne["status"].indexOf('fail') != -1){
                                 this.showToast(component, "Error!", resObjOne["message"], "error");
                            	 this.rollBackAll(component,jasonstr);
                            }              
                         }
				
            });
    },
    convertToLoanTwo : function(component,jasonstr){
        this.executeApex(component, 'convertToLoanRemoteTwo', {
             "jsonStr":jasonstr
        }, function(error, result){
            if(!error && result && result.length && !result.includes("exception")){
                var resObjOne = JSON.parse(result);
                console.log('second output');
                console.log(resObjOne);
                var outputMapOne = resObjOne["outputMap"];
                console.log('outputMAP');
                console.log(outputMapOne);
                var oppId = outputMapOne["oppObjId"];
                console.log('oppId');
                console.log(oppId);
                component.set("v.oppId",oppId);
                var jasonstr = JSON.stringify(outputMapOne)
                if(resObjOne["status"].indexOf('success') != -1){
                    this.convertToLoanthird(component,jasonstr);
                }else  if(resObjOne["status"].indexOf('fail') != -1){
                    this.showToast(component, "Error!", resObjOne["message"], "error");
                    this.rollBackAll(component,jasonstr);
                }              
            }
            
        });
    },
    convertToLoanthird : function(component,jasonstr){
        this.executeApex(component, 'convertToLoanFutureCalls', {
             "jsonStr":jasonstr
        }, function(error, result){
            if(!error && result && result.length && !result.includes("exception")){
                var resObjOne = JSON.parse(result);
                var outputMapOne = resObjOne["outputMap"];
                var jasonstr = JSON.stringify(outputMapOne)
                console.log('resultobjone');
                console.log(resObjOne);
                if(resObjOne["status"].indexOf('success') != -1){
                	  component.set("v.loanId", component.get("v.oppId"));
                    this.postConversionActivity(component,jasonstr);

                    
                }else  if(resObjOne["status"].indexOf('fail') != -1){
                    this.showToast(component, "Error!", resObjOne["message"], "error");
                    this.rollBackAll(component,jasonstr);
                }              
            }
            
        });
    },
    rollBackAll : function(component,jasonstr){
        this.executeApex(component, 'deleteAllData', {
            "jsonStr":jasonstr
        }, function(error, result){
              var resObjOne = JSON.parse(result);
              var outputMapOne = resObjOne["outputMap"];
              var jasonstr = JSON.stringify(outputMapOne)
        	  if(resObjOne["status"].indexOf('success') != -1){
                  this.showToast(component, "Error!", "Loan Application not Converted successfully ", "error");
              }else if(resObjOne["status"].indexOf('fail') != -1){
                  this.showToast(component, "Error!", resObjOne["message"], "error");
              }
        });
    },
    postConversionActivity : function(component,jasonstr){
        this.executeApex(component, 'getLANData', {
            "poId":component.get("v.poId")
        }, function(error, result){
        	if(result){
                console.log('inside postconversion');
                 component.set("v.isconvertedPO", true); //18430
                this.triggerPostConvertEvent(component, result.Opportunity__r.Loan_Application_Number__c, result.Opportunity__r.Id);
              
                this.showToast(component, "Success!", "Loan Application "+result.Opportunity__r.Loan_Application_Number__c+"Converted successfully ", "success");
                this.disableButtons(component, false, true, true, false, true);
                this.disableFields(component, true);
               
            }
                  
        });
    },
    triggerPostConvertEvent: function(component, loanNumber, loanID){
        var event = $A.get("e.c:LoanConversionEvent");;
        event.setParams({"loanNumber": loanNumber});
        event.setParams({"loanId": loanID});
     //   alert('firing LoanConversionEvent inside triggerPostConvertEvent');
        event.fire();
        this.showHideBtnPostConversion(component)
    },
    
    //POS YK
    showHideBtnPostConversion : function(component)
    {
		$A.util.addClass(component.find("saveButtonIdDiv"), 'slds-hide');
        if(component.get("v.stpNonStp") == 'STP')
            $A.util.removeClass(component.find("goToLoanApplicationBtnIdDiv"), 'slds-hide');
    },
    //POS YK
    
    saveDispositionData: function(component) { 
        var po = component.get("v.po");
        po.Follow_Up_Date__c = null;
        po.Field_Followup_Date__c = component.find("followUpDate").get("v.value") || null;
        po.attributes = {type: 'Product_Offerings__c'}; 
        po.Offer_Date__c = component.find("offerDate").get("v.value") || null;
        
        this.executeApex(component, 'saveDisposition', {
            "PO": JSON.stringify([po])
        }, function(error, result){
            if(!error && result){
                var disposition = component.find("disposition").get("v.value");
                console.log('component.get("v.isconvertedPO")');
                console.log(component.get("v.isconvertedPO"));
                if(component.get("v.isconvertedPO")==true){
                    console.log('inside trueP');
                    this.disableButtons(component, false, true, true, true, true);       //bug-18338             
                }
                
                else{
                    this.disableButtons(component, false, true, (disposition !== "Docs Received"), true, true);
                     console.log('inside falseP');
                  }
                
                this.showToast(component, "Success!", "Saved successfully", "success");
            } else {
                this.disableForm(component);
            }
        });  
    },
    setPOData: function(component, newPO){
        var po = component.get("v.po");
        po.Id = newPO.Id || po.Id;
        po.Lead__c = newPO.Lead__c || po.Lead__c;
        po.Lead_Name__c = newPO.Lead_Name__c || po.Lead_Name__c;
        po.Alternate_Mobile_No__c = newPO.Alternate_Mobile_No__c || po.Alternate_Mobile_No__c;
        var fieldDispositionStatus = newPO.Field_Desposition_Status__c || po.Field_Desposition_Status__c;
        component.set("v.fieldDispositionStatus",fieldDispositionStatus);
        po.Field_Desposition_Status__c = newPO.Field_Desposition_Status__c || po.Field_Desposition_Status__c;
        var fieldCheckStatus =  newPO.Field_Check_Status__c || po.Field_Check_Status__c;
        component.set("v.fieldCheckStatus",fieldCheckStatus);
        po.Field_Check_Status__c = newPO.Field_Check_Status__c || po.Field_Check_Status__c;
        po.Field_Disposition_1__c = newPO.Field_Disposition_1__c || po.Field_Disposition_1__c;
        var fieldDisposition1 = newPO.Field_Disposition_1__c || po.Field_Disposition_1__c;
        component.set("v.fieldDisposition1",fieldDisposition1);
        //PSL changes : Nikhil Bugfix # : Populate Offer Amount on disposition from Offer Amount if not in Revised Offer Amount
        po.Revised_Offer_Amount__c = newPO.Revised_Offer_Amount__c || newPO.Offer_Amount__c || po.Revised_Offer_Amount__c;
        po.Card_Disposition_Field__c = newPO.Card_Disposition_Field__c || po.Card_Disposition_Field__c;
        po.Availed_Amount__c = newPO.Availed_Amount__c || po.Availed_Amount__c;
        po.Field_Remarks__c = newPO.Field_Remarks__c || po.Field_Remarks__c;
        po.Offer_Date__c = newPO.Offer_Date__c || po.Offer_Date__c;
        po.Field_Followup_Date__c = newPO.Field_Followup_Date__c || po.Field_Followup_Date__c;
        po.Lead__r = newPO.Lead__r || po.Lead__r;
        //Bug 24927 S
        po.Campaign_Type__c = newPO.Campaign_Type__c || po.Campaign_Type__c;
        //Bug 24927 E
        component.set("v.po", po); 
    },
    disableFields: function(component, all, flds){
        component.find("alternateMobileNumber").set("v.disabled", all || flds.includes("alternateMobileNumber"));
        component.find("disposition").set("v.disabled", all || flds.includes("disposition"));
        component.find("fieldDisposition").set("v.disabled", all || flds.includes("fieldDisposition"));
        component.find("fieldCheckStatus").set("v.disabled", all || flds.includes("fieldCheckStatus"));
        component.find("creditOfficer").set("v.disabled", all || flds.includes("creditOfficer"));
        component.find("fieldRemarks").set("v.disabled", all || flds.includes("fieldRemarks"));
        component.find("offerAmount").set("v.disabled", all || flds.includes("offerAmount"));
        component.find("offerDate").set("v.disabled", all || flds.includes("offerDate"));
        if(this.isEnableFollowupFields(component)){
            this.disableFollowupFields(component);
        }
    },
    disableFollowupFields: function(component){
        component.find("followup").set("v.disabled", all || flds.includes("followup"));
        component.find("followUpDate").set("v.disabled", all || flds.includes("followUpDate"));
    },
    disableButtons: function(component, all, save, convert, credits, submit){ 
        debugger;
        component.find("saveButtonId").set("v.disabled", all || save);
        
        component.find("convertToLoanButtonId").set("v.disabled", all || convert);
        //POS YK s
        console.log('disabled convertToLoanButtonId====>> '+component.find("convertToLoanButtonId").get("v.disabled"));
        
        if(component.find("convertToLoanButtonId").get("v.disabled") == true)
            $A.util.addClass(component.find("convertToLoanButtonIdDiv"), 'slds-hide');
        else
        	$A.util.removeClass(component.find("convertToLoanButtonIdDiv"), 'slds-hide');
        //POS YK e
        console.log('all & credits');
        console.log(all +'and'+ credits);
        console.log(component.get("v.isconvertedPO")===true);
        if(component.get("v.isconvertedPO")===true){
            component.find("populateCreditSelectListButtonId").set("v.disabled", all || credits);
        } 
        
        //POS YK s
        console.log('disabled populateCreditSelectListButtonId====>> '+component.find("populateCreditSelectListButtonId").get("v.disabled"));
        if(component.find("populateCreditSelectListButtonId").get("v.disabled") == true)
            $A.util.addClass(component.find("populateCreditSelectListButtonIdDiv"), 'slds-hide');
        else if(component.get("v.stpNonStp") != 'STP'){
            console.log(' creditselectList button');
           
            $A.util.removeClass(component.find("populateCreditSelectListButtonIdDiv"), 'slds-hide');
        }
        	
        //POS YK e
           console.log(all+'orrr'+submit);     
        component.find("submitToCreditApproverButtonId").set("v.disabled", all || submit);
        
        //POS YK s
        console.log('disabled submitToCreditApproverButtonId====>> '+component.find("submitToCreditApproverButtonId").get("v.disabled"));
        if(component.find("submitToCreditApproverButtonId").get("v.disabled") == true)
            $A.util.addClass(component.find("submitToCreditApproverButtonIdDiv"), 'slds-hide');
        //else{
             if(component.get("v.stpNonStp") != 'STP' && component.get("v.isconvertedPO")==true){
                 console.log('non-stp case');
                // $A.util.removeClass(component.find("creditOfficerDiv"), 'slds-hide');
                 if(component.get("v.isconvertedPO")==true) {
                     console.log('inside remove hide class');
                     $A.util.removeClass(component.find("submitToCreditApproverButtonIdDiv"), 'slds-hide');
                 }
             }
        //}
         if(component.get("v.stpNonStp") == 'STP'){
              $A.util.addClass(component.find("creditOfficerDiv"), 'slds-hide');
           console.log('stp case');
            if(component.get("v.isconvertedPO")==true) 
                $A.util.removeClass(component.find("goToLoanApplicationBtnIdDiv"), 'slds-hide');
         }
        //POS YK e
         //Bug 24237 S
         // Added  for 27th May 2019 change NON_STP_B
           if (component.get("v.stpNonStp") == 'NON_STP_C' || component.get("v.stpNonStp") == 'NON_STP_B') {
                
               
                console.log('NON_STP_C or  NON_STP_B case');
                if (component.get("v.isconvertedPO") == true &&  component.get("v.oppStageName")=='Post Approval Sales')
                {
                    if(component.find("creditOfficerDiv")){
						$A.util.addClass(component.find("creditOfficerDiv"), 'slds-hide');                        
                    }
                    if(component.find("submitToCreditApproverButtonId")){
						$A.util.addClass(component.find("submitToCreditApproverButtonId"), 'slds-hide');                        
                    }
                    if(component.find("populateCreditSelectListButtonIdDiv")){
                        $A.util.addClass(component.find("populateCreditSelectListButtonIdDiv"), 'slds-hide');
                    }
                    $A.util.removeClass(component.find("goToLoanApplicationBtnIdDiv"), 'slds-hide');
        			
                } 
           }
         //Bug 24237 E
    },
    disableForm: function(component){
      	this.disableFields(component, true);
        this.disableButtons(component, true);  
    },
    onDataChange: function(component){
        this.disableButtons(component, false, false, true, true, true);
    },
    validate: function(component){
        var po = component.get("v.po");
        console.log('PO -->' , JSON.stringify(component.get("v.po")));
        // US : 2702
        /*if(!result.SOL_Policys__r && segmentList.length>0 && result.Lead__r != null && result.Lead__r.Profession_Type__c && segmentList.includes(result.Lead__r.Profession_Type__c.toUpperCase())  && ($A.util.isEmpty(result.Lead__r.CC_Disposition__c)))
             component.set("v.ccAlert",true);*/
        var fieldDisposition = component.find("fieldDisposition");
        var disposition = component.find("disposition");
        var offerAmount = component.find("offerAmount");
        var followupDate = component.find("followUpDate");
		var validFollowup = true;
        
        po.Field_Disposition_1__c = fieldDisposition.get('v.value');
        po.Field_Desposition_Status__c = disposition.get('v.value');
        po.Revised_Offer_Amount__c = offerAmount.get('v.value');
        po.Field_Followup_Date__c = followupDate.get('v.value');
        
        fieldDisposition.set("v.errors", po.Field_Disposition_1__c ? null : [{message:"Select Field Disposition"}]);
        disposition.set("v.errors", po.Field_Desposition_Status__c ? null : [{message:"Select Sub Disposition"}]);
        offerAmount.set("v.errors", po.Revised_Offer_Amount__c ? null : [{message:"Enter offer amount"}]);
        
        if(po.Field_Disposition_1__c == 'Followup' && !po.Field_Followup_Date__c){
            followupDate.set("v.errors", [{message: "Enter followup date."}]);
            validFollowup = false;
        } else {
            followupDate.set("v.errors", [{message: ""}]);
        }
        return (po.Field_Disposition_1__c && po.Field_Desposition_Status__c && po.Revised_Offer_Amount__c && validFollowup && this.validateField(component, "alternateMobileNumber", /^[7-9]\d{9}/, "mobile number"));
    },
    validateField: function(component, key, pattern, error){
        var field = component.find(key);
        var value = field.get("v.value");
        var valid = !!(value == '' || pattern.test(value));
        field.set("v.errors", [{message: valid ? "" : "Enter a valid " + error}]);
        return valid;
    },
    executeApex: function(component, method, params, callback){
        var action = component.get("c."+method);
        action.setParams(params);
         component.set("v.spinnerFlag1","true");
        action.setCallback(this, function(response) {
             component.set("v.spinnerFlag1","false");
            var state = response.getState();
            if(state === "SUCCESS"){
                callback.call(this, null, response.getReturnValue());
            } else if(state === "ERROR") {
                var errors = [];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message){
                        errors.push(item.message);
                    }
                }
                //this.showToast(component, "Error!", errors.join(", "), "error");// Bug Id : 25285 - Concurrency Issue end -unlock p2
                callback.call(this, errors, response.getReturnValue());
                this.showToast(component, "Error!", errors.join(", "), "error");// Bug Id : 25285 - Concurrency Issue end -unlock p2
            }
        });
        $A.enqueueAction(action);
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
            
            $A.util.removeClass(component.find("customToast"), "slds-hide");
            $A.util.removeClass(toastTheme, "slds-theme--error");
        	$A.util.removeClass(toastTheme, "slds-theme--success");
            
            if(type == 'error'){
                $A.util.addClass(toastTheme, "slds-theme--error");
            } else if(type == 'success'){
                $A.util.addClass(toastTheme, "slds-theme--success");
            }
            component.find("toastText").set("v.value", message);
            component.find("toastTtitle").set("v.value", title+' ');
        }
    },
    closeToast: function(component){
        var toastTheme = component.find("toastTheme");
        $A.util.addClass(component.find("customToast"), "slds-hide");
        $A.util.removeClass(toastTheme, "slds-theme--error");
        $A.util.removeClass(toastTheme, "slds-theme--success");
    },//added for Bug 24487
    getEmiCardPrefValidation:function(component){
        debugger;
        var IDpo= component.get("v.po").Id;
        console.log('IDpo--',IDpo);
        this.executeApex(component,"getEmiCardPrefonSubmit",{"poid":IDpo},
                         function(error, result) {
                             if (!error && result) {
                                 this.saveDispositionData(component);
                             }else{
                                 this.showToast(component, "Error!", "Please select EMI Card Preference!!", "error");
                             }
                         });
    },
})