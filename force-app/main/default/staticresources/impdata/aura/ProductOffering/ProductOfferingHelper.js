({
	getProductOfferings: function(component, converted, submitted) {
        this.executeApex(component, 'getProductOfferings', {
            "poId": component.get("v.poId")
        }, function(error, result){
            if(!error && result){
                this.setPOData(component, result);
                var convertible = (result.Field_Desposition_Status__c === "Docs Received"); 
                var all = (converted && submitted) || (!converted && !convertible);
        		this.disableButtons(component, all, true, !(!converted && convertible), !(converted && !submitted), true);
            }
        });
    },
    populateFieldDispositionData: function(component, converted) {
        this.executeApex(component, 'getFieldDisposition', {}, function(error, result){
            if(!error && result){
                this.setSelectOptions(component, result, "", "fieldDisposition");
                if(component.get("v.po.Field_Disposition_1__c")){
                    this.populateDispositionData(component, converted);
                    this.showHideFollowupFields(component);
                }
            }
        });
    },
    populateDispositionData: function(component, converted){
        this.populateDispositionDataInternal(component, converted, "disposition", {
            "controllingField": "Field_Disposition_1__c",
            "dependentField": "Field_Desposition_Status__c",
            "fldDisposition": component.get("v.po.Field_Disposition_1__c")
        }, function(){
            if(component.get("v.po.Field_Desposition_Status__c")){
                this.populateFieldCheckData(component, converted);
            }
        });
    },
    populateFieldCheckData: function(component, converted){
        this.populateDispositionDataInternal(component, converted, "fieldCheckStatus", {
            "controllingField": "Field_Desposition_Status__c",
            "dependentField": "Field_Check_Status__c",
            "fldDisposition": component.get("v.po.Field_Desposition_Status__c")
        }, function(){});
    },
    populateDispositionDataInternal: function(component, converted, elementId, params, callback) {
        this.executeApex(component, 'getDisposition', params, function(error, result){
            if(!error && result){
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
    populateCreditSelectList: function(component){
        this.executeApex(component, 'fetchCreditDetails', {
            "poId": component.get("v.poId")
        }, function(error, result){
            if(!error && result){
                var options = [{"class": "optionClass", label: "Select", value: ""}];
                for(var i = 0; i < result.length; i++){
                    options.push({"class": "optionClass", label: result[i].Credit_Officer_Name__r.Name, value: result[i].Id});
                }
                var element = component.find("creditOfficer");
                element.set("v.options", options);
                element.set("v.disabled", false);
                this.disableButtons(component, true);
            } else {
                this.disableForm(component);
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
                this.showToast(component, "Success!", "Submitted successfully", "success");
            } else {
				this.showToast(component, "Error!", "Failed to submit approver", "error");                
            }
            this.disableForm(component);
        });
    },
    convertToLoanApplication: function(component){
        
        //Bug 19505 - commented existing convert and repoaced with POS approach
		/*this.executeApex(component, 'sendToSalesConvert', {
            "leadId": component.get("v.po.Lead__c"), 
           	"poId": component.get("v.poId")
        }, function(error, result){
            if(!error && result && result.length && result.includes(';')){
                var data = result.split(';');
                component.set("v.loanId", data[1]);
                this.triggerPostConvertEvent(component, data[0], data[1]); 	//	Bug 15855 
                this.showToast(component, "Success!", "Converted successfully ", "success");
                this.disableButtons(component, false, true, true, false, true);
                this.disableFields(component, true);
            } else {
                this.showToast(component, "Error!", "Failed to convert loan application", "error");
                this.disableForm(component);
            }
        });*/
        this.convertToLoanApplication1(component);
    },
    convertToLoanApplication1: function(component){
        this.executeApex(component, 'convertToLoanRemoteOne', {
            			"leadId": component.get("v.po.Lead__c"), 
           				"poId": component.get("v.poId")
       				 }, function(error, result){
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
    //	Bug 15855 S - Changed signature
    triggerPostConvertEvent: function(component, loanNumber, oppId){
        var event = $A.get("e.c:LoanConversionEvent");
        console.log('After conversion oppId : '+oppId);
        event.setParams({
            "loanNumber": loanNumber,
            "loanId" : oppId
        });
        event.fire();
        console.log('triggerPostConvertEvent triggerred');
    },
    //	Bug 15855 E
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
                 //Rohit 16111 CR S
				var parsedResult = JSON.parse(result);
                component.set("v.isEkycMandatory", parsedResult.ekycMandatory);
                component.set("v.isEkycdone", parsedResult.leadEkyc);

				//Rohit 16111 CR E
                var disposition = component.find("disposition").get("v.value");
                this.disableButtons(component, false, true, (disposition !== "Docs Received"), true, true);
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
        po.Field_Desposition_Status__c = newPO.Field_Desposition_Status__c || po.Field_Desposition_Status__c;
        po.Field_Check_Status__c = newPO.Field_Check_Status__c || po.Field_Check_Status__c;
        po.Field_Disposition_1__c = newPO.Field_Disposition_1__c || po.Field_Disposition_1__c;
        //PSL changes : Nikhil Bugfix # : Populate Offer Amount on disposition from Offer Amount if not in Revised Offer Amount
        po.Revised_Offer_Amount__c = newPO.Revised_Offer_Amount__c || newPO.Offer_Amount__c || po.Revised_Offer_Amount__c;
        po.Card_Disposition_Field__c = newPO.Card_Disposition_Field__c || po.Card_Disposition_Field__c;
        po.Availed_Amount__c = newPO.Availed_Amount__c || po.Availed_Amount__c;
        po.Field_Remarks__c = newPO.Field_Remarks__c || po.Field_Remarks__c;
        po.Offer_Date__c = newPO.Offer_Date__c || po.Offer_Date__c;
        po.Field_Followup_Date__c = newPO.Field_Followup_Date__c || po.Field_Followup_Date__c;
        po.Lead__r = newPO.Lead__r || po.Lead__r;
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
        component.find("saveButtonId").set("v.disabled", all || save);
        component.find("convertToLoanButtonId").set("v.disabled", all || convert);
        component.find("populateCreditSelectListButtonId").set("v.disabled", all || credits);
        component.find("submitToCreditApproverButtonId").set("v.disabled", all || submit);
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
        return (po.Field_Disposition_1__c && po.Field_Desposition_Status__c && po.Revised_Offer_Amount__c && validFollowup);
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
        action.setCallback(this, function(response) {
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
                this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
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
    }
})