({
	executeApex: function(component, method, params, callback){
		$A.util.removeClass(component.find("spinner"),"slds-hide");
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('State -->' , state);
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
                //this.showToast(component, "Error!", errors.join(", "), "error"); // Bug Id : 25285 - Concurrency Issue start -unlock p2
                callback.call(this, errors, response.getReturnValue());
                this.showToast(component, "Error!", errors.join(", "), "error");// Bug Id : 25285 - Concurrency Issue start -unlock p2
            }
            $A.util.addClass(component.find("spinner"),"slds-hide");
        });
        $A.enqueueAction(action);
    },
    
    setSelectOptions: function(component, data, label, cmpId){
        var opts = [{"class": "optionClass", label: "Select " + label, value: ""}];
        for(var i=0; i < data.length; i++){
            opts.push({"class": "optionClass", label: ''+data[i], value: data[i]});
        }
        component.find(cmpId).set("v.options", opts);
    },
    
    getPicklistData: function(component, ObjName, fieldName, label, cmpId) {
        this.executeApex(component, "getPicklist", { "ObjName" : ObjName, "fieldName" : fieldName, }, function(error, result){
            if(!error && result){
                this.setSelectOptions(component, result, label, cmpId);
            }
        });
    },
    
    populateDispositionData: function(component){
    	var po_fds = component.get("v.ProductOffer.Field_Desposition_Status__c");
        var schmname = component.get("v.ProductOffer.Scheme__r.Name");
        var srcchnl = component.get("v.ProductOffer.Sourcing_Channel__r.Name");
        this.populateDispositionDataInternal(component, "FieldDisposition", {
            "ObjName" : "Product_Offerings__c",
            "controlField": "Field_Disposition_1__c",
            "dependentField": "Field_Desposition_Status__c",
            "fldValue": component.get("v.ProductOffer.Field_Disposition_1__c")
        }, function(){
        	component.set("v.ProductOffer.Field_Desposition_Status__c",po_fds);
            if(component.get("v.ProductOffer.Field_Desposition_Status__c") != null && component.get("v.ProductOffer.Field_Desposition_Status__c") != undefined){
                this.populateFieldCheckData(component);
            }
        }); 
        component.set("v.schemeSearchKeyword",schmname);
        component.set("v.sourceSearchKeyword",srcchnl);
        this.markRed(component.find("FieldDisposition1"),false);
        this.markRed(component.find("FieldDisposition"),false);
    },
    populateFieldCheckData: function(component){
    	var po_fcs = component.get("v.ProductOffer.Field_Check_Status__c");
        this.populateDispositionDataInternal(component, "FieldCheckStatus", {
            "ObjName" : "Product_Offerings__c",
            "controlField": "Field_Desposition_Status__c",
            "dependentField": "Field_Check_Status__c",
            "fldValue": component.get("v.ProductOffer.Field_Desposition_Status__c")
        }, function(){
        	component.set("v.ProductOffer.Field_Check_Status__c",po_fcs);
        });
    },
    populateDispositionDataInternal: function(component, elementId, params, callback) {
        this.executeApex(component, 'getDependOptions', params, function(error, result){
            if(!error && result){
                this.setSelectOptions(component, result, "", elementId);
                  component.find(elementId).set("v.disabled", component.get("v.isConverted"));
            } 
            callback.call(this);
        });
    },
    
    startSearch: function(component, key){
        var keyword = component.get("v."+key+"SearchKeyword");
        if(keyword.length > 2 && !component.get('v.searching')){
            component.set('v.searching', true);
            component.set('v.oldSearchKeyword', keyword);
            this.searchHelper(component, key, keyword);
        } else if(keyword.length <= 2){ 
            component.set("v."+key+"List", null);
            this.openCloseSearchResults(component, key, false);
        }
    },
    searchHelper: function(component, key, keyword) { 
        this.executeApex(component, "fetch"+this.toCamelCase(key), {
            'searchKeyWord': keyword
        }, function(error, result){
            if(!error && result){
                this.handleSearchResult(component, key, result); 
            }
        });
    },
    handleSearchResult: function(component, key, result){
        component.set('v.searching', false);        
        if(component.get('v.oldSearchKeyword') !== component.get("v."+key+"SearchKeyword")){
            component.set("v."+key+"List", null); 
            this.startSearch(component, key);
        } else {
            component.set("v."+key+"List", result); 
            this.showHideMessage(component, key, !result.length);
            this.openCloseSearchResults(component, key, true);
        } 
    },
    
    toCamelCase: function(str){
        return str[0].toUpperCase() + str.substring(1);
    },
    
    
    
    getResidentialCity: function(component) {
        this.executeApex(component, "fetchCities", {}, function(error, result){
            if(!error && result){
                component.set("v.AllCities", result || []);
            } 
        });
    },
        getDocsMandFlag: function(component) {
            if($A.get("$Label.c.BL_Mob_App_Docs_Mandatory")!=null){
                if ($A.get("$Label.c.BL_Mob_App_Docs_Mandatory")=='Y')
               	 component.set("v.checkAllDocReceived", true);
                else
                 component.set("v.checkAllDocReceived", false);
            }
            else
				 component.set("v.checkAllDocReceived", false);
            
    },
    
        getCIBILfromLead: function(component){
            this.executeApex(component, "getCIBILfromLead", {
                "leadId" : component.get("v.leadID")
              }, function(error, result){
                if (result != null)
                  if(!error && result){
                    component.set("v.leadCibilId",result) 
                } else if(!error){
                    this.showToast(component, "Error!", "Please check the data " + error, "error");
                }
            });
      
    },
        getmobileValidResult: function(component){
          this.executeApex(component, "mobileValidationResult", {
                "leadId" : component.get("v.leadID")
              }, function(error, result){
                if (result != null)
                  if(!error && result){
                    component.set("v.mobileValidResult",result) 
                } else if(!error){
                   console.log('cibil temp not present');
                }
            });
      
    },
    searchCity: function(component, keyword, cmpId) {
        if(keyword.length > 0){
            var all = component.get("v.AllCities") || [];
            var filterValues = [];
            for(var i = 0; i < all.length; i++){
                var value = all[i];
                if(value.toLowerCase().includes(keyword.toLowerCase())){
                    filterValues.push(value);
                }
            }
            component.set("v.filteredCities", filterValues);
            this.showHideMessage(component, cmpId, !filterValues.length);
            this.openCloseSearchResults(component, cmpId, true);
        } else {  
            component.set("v.filteredCities", null); 
            this.openCloseSearchResults(component, cmpId, false);
        }
    },
    
    showHideMessage: function(component, key, show){
        component.set("v.message", show ? 'No Result Found...' :  '');
        this.showHideDiv(component, key+"Message", show);
    },
    
    showHideDiv: function(component, divId, show){
        if(divId !== "nextButtonId"){
            $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        }
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
    
    openCloseSearchResults: function(component, key, open){
        var resultPanel = component.find(key+"SearchResult");
        $A.util.addClass(resultPanel, open ? 'slds-is-open' : 'slds-is-close');
        $A.util.removeClass(resultPanel, open ? 'slds-is-close' : 'slds-is-open');
    },
    
    getMappingState: function(component, city, isOffice){
        this.executeApex(component, "MappingState", { "city" : city,}, function(error, result){
            if(!error && result){
            	if(isOffice){
            		component.set("v.ProductOffer.Office_State__c", result);
            	}
            	else{
            		component.set("v.ProductOffer.Resi_State__c", result);
            	}
            }
        });
    },
    
    saveCustomerDetails: function(component, event, helper) {
    	
    	var recordId = component.get("v.ProductOffer.Lead__c");
    	var LdProfission = component.get("v.ProductOffer.Lead__r.Profession_Type__c");
        var LdPANNumber = component.get("v.ProductOffer.Lead__r.PAN__c");
        var LdDOB = component.get("v.ProductOffer.Lead__r.DOB__c");
        var isValid = true;
        if(!this.validatePAN(component)){
        	this.markRed(component.find("PAN"),true,"Enter valid PAN Number");
        	this.showToast(component, "Error!", "Enter valid PAN Number", "error");
            isValid = false;
        }
        else{
            this.markRed(component.find("PAN"), false, "");
        }
        if(!this.validateDOB(component)){
        	this.markRed(component.find("DOB"),true,"Enter valid DOB");
        	this.showToast(component, "Error!", "Enter valid DOB", "error");
            isValid = false;
        }
        else
            this.markRed(component.find("DOB"), false, "");
        
		if(LdProfission)
    		this.markRed(component.find("ProfessionType"),false,"");
        else{
        	this.markRed(component.find("ProfessionType"),true,"Select valid Profession");
        	this.showToast(component, "Error!", "Profession field can not be empty", "error");
            isValid = false;
        }
 		if(isValid)
			this.executeApex(component, "saveCustomer", { "recordId" : recordId, "LdProfission" : LdProfission, "LdPANNumber" : LdPANNumber, "LdDOB" : LdDOB,}, function(error, result){
            if(!error && result){
            	this.showToast(component, "Success!", "Customer Details updated successfully", "success");
            	this.toNextTab(component, event);
            	this.fetchDemographicDetails(component, event, helper);
            }
        });
        
    },
    
    savePoDetails: function(component, event) {
                console.log("0");
    	var tabId= event.getSource().get("v.value");
    	var pofd1 = component.get("v.ProductOffer.Field_Disposition_1__c");
    	var field1 = component.find("FieldDisposition1");
    	var pofd = component.get("v.ProductOffer.Field_Desposition_Status__c");
    	var field2 = component.find("FieldDisposition");
        var allowSave = true;
      	if(tabId == 't6'){
    		if(pofd1 == null || pofd1 == undefined || pofd1 == ""){
    			this.markRed(field1,true,"Field Disposition 1 cannot be blank ");
    			allowSave = false;
    		}
    		else{
    			this.markRed(field1,false,"");
    		}
    		if(pofd == null || pofd == undefined || pofd == ""){
    			this.markRed(field2,true,"Field Disposition cannot be blank ");
    			allowSave = false;
    		}
    		else{
    			this.markRed(field2,false,"");
    		}
    	}
        console.log("2");

    	var po = component.get("v.ProductOffer");
    	if(allowSave && component.get("v.isValidAmount") == true){
    	    this.executeApex(component, "savePo", { "productOffer" : po, }, function(error, result){
	            if(!error && result){
	            	if(tabId == 't6')
	            	this.showToast(component, "Success!", "Disposition Details updated successfully", "success");
	            	else if(tabId != 't3')
	            	this.showToast(component, "Success!", "Record saved successfully", "success");
	            	
	            }
	        });
    	}
    },
	saveDemogDetails: function(component, event) {
                console.log("3");
    	var tabId= event.getSource().get("v.value");
        var allowSave = true;
        if(tabId == 't3'){
		var addresscheckbox = component.find("EditAddress").get("v.value");
            console.log('---->'+addresscheckbox)
		if(addresscheckbox)
		{
			var addline1 = component.find("AddressLine1").get("v.value");
			var addline2 = component.find("AddressLine2").get("v.value");
			var addline3 = component.find("AddressLine3").get("v.value");
			var residenceCity = component.find("residenceCity").get("v.value");
			var ResiState = component.find("ResiState").get("v.value");
			var PinCode = component.find("PinCode").get("v.value");
					console.log("1");
				if(addline1 == null || addline1 == undefined || addline1 == ""){
				this.markRed(component.find("AddressLine1"),true,"Residence Address Line 1 cannot be blank ");
				allowSave = false;
			}
			else{
				this.markRed(component.find("AddressLine1"),false,"");
			}
			if(addline2 == null || addline2 == undefined || addline2 == ""){
				this.markRed(component.find("AddressLine2"),true,"Residence Address Line 2 cannot be blank ");
				allowSave = false;
			}
			else{
				this.markRed(component.find("AddressLine2"),false,"");
			}
			if(addline3 == null || addline3 == undefined || addline3 == ""){
				this.markRed(component.find("AddressLine3"),true,"Residence Address Line 3 cannot be blank ");
				allowSave = false;
			}
			else{
				this.markRed(component.find("AddressLine3"),false,"");
			}
			if(residenceCity == null || residenceCity == undefined || residenceCity == ""){
				this.markRed(component.find("residenceCity"),true,"Residence City cannot be blank ");
				allowSave = false;
			}
			else{
				this.markRed(component.find("residenceCity"),false,"");
			}
			if(ResiState == null || ResiState == undefined || ResiState == ""){
				this.markRed(component.find("ResiState"),true,"Residence State cannot be blank ");
				allowSave = false;
			}
			else{
				this.markRed(component.find("ResiState"),false,"");
			}
			if(PinCode == null || PinCode == undefined || PinCode == ""){
				this.markRed(component.find("PinCode"),true,"Residence Pincode cannot be blank ");
				allowSave = false;
			}
			else{
				this.markRed(component.find("PinCode"),false,"");
			}
		}
		else
		{
			var daddline1 = component.find("D_AddressLine1").get("v.value");
			var daddline2 = component.find("D_AddressLine2").get("v.value");
			var daddline3 = component.find("D_AddressLine3").get("v.value");
			var dresidenceCity = component.find("D_ResiCity").get("v.value");
			var dResiState = component.find("D_ResiState").get("v.value");
			var dPinCode = component.find("D_ResiPinCode").get("v.value");
					console.log("1");
			if(daddline1 == null || daddline1 == undefined || daddline1 == ""){
				this.markRed(component.find("D_AddressLine1"),true,"Residence Address Line 1 cannot be blank ");
				allowSave = false;
			}
			else{
				this.markRed(component.find("D_AddressLine1"),false,"");
			}
			if(daddline2 == null || daddline2 == undefined || daddline2 == ""){
				this.markRed(component.find("D_AddressLine2"),true,"Residence Address Line 2 cannot be blank ");
				allowSave = false;
			}
			else{
				this.markRed(component.find("D_AddressLine2"),false,"");
			}
			if(daddline3 == null || daddline3 == undefined || daddline3 == ""){
				this.markRed(component.find("D_AddressLine3"),true,"Residence Address Line 3 cannot be blank ");
				allowSave = false;
			}
			else{
				this.markRed(component.find("D_AddressLine3"),false,"");
			}
			if(dresidenceCity == null || dresidenceCity == undefined || dresidenceCity == ""){
				this.markRed(component.find("D_ResiCity"),true,"Residence City cannot be blank ");
				allowSave = false;
			}
			else{
				this.markRed(component.find("D_ResiCity"),false,"");
			}
			if(dResiState == null || dResiState == undefined || dResiState == ""){
				this.markRed(component.find("D_ResiState"),true,"Residence State cannot be blank ");
				allowSave = false;
			}
			else{
				this.markRed(component.find("D_ResiState"),false,"");
			}
			if(dPinCode == null || dPinCode == undefined || dPinCode == ""){
				this.markRed(component.find("D_ResiPinCode"),true,"Residence Pincode cannot be blank ");
				allowSave = false;
			}
			else{
				this.markRed(component.find("D_ResiPinCode"),false,"");
			}
		}
        }
    	
    	var po = component.get("v.ProductOffer");
    	if(allowSave){
    	    this.executeApex(component, "saveDemogDetails", { "productOffer" : po, }, function(error, result){
	            if(!error && result){
	            	if(tabId == 't3'){
	            		this.showToast(component, "Success!", "Demographic Details updated successfully", "success");
	            		this.toNextTab(component, event);
	            	}
	            }
	        });
    	}
    },
      createCIBIL: function(component, callback){
            this.executeApex(component, "createCibilTempRecord", {
                "leadId" : component.get("v.leadID"),
                "po" : component.get("v.ProductOffer"),
                "retrigger": component.get("v.isRetriggerCIBIL")
            }, function(error, result){
                if(!error && result){
                    component.set("v.cibilTempId", result);
                    this.setTimeout(this.showSpinner, this, 1, component);
                    this.setTimeout(this.checkForCIBILScore, this, 5000, component);              
                } else if(!error){
                    this.showToast(component, "Error!", "Please check the data and reinitiate. " + error, "error");
                }
            });
    },
     checkForCIBILScore: function(component){
         this.executeApex(component, "checkForCibilScore", {
            "cibilTempId": component.get("v.cibilTempId")
        }, function(error, result){
            if(!error && result){
                result = JSON.parse(result);
                if(result.status === "ERROR"){
                    this.showToast(component, 'Error!', result.message, 'error');
                } else if(result.status === "RECEIVED"){
                    //22141 S
                    this.getmobileValidResult(component);
                    //22141 E
                    
                    component.set("v.cibilScore",result.message);
                    var event = $A.get("e.c:BLMobilityPOCardEvent");
                    event.setParams({"cibilScore": result.message});
        			event.fire();
                } else {
                    this.showHideDiv(component, "alertDialog", true);
                }
            }
        });
    },
    
     setTimeout: function(callback, context, time, component){
        window.setTimeout(
            $A.getCallback(function(){
                if(!component || component.isValid()){
                    callback.call(context || this, component);
                }
            }), time
        );
    },
     showSpinner: function(component){
        this.showHideDiv(component, "waiting", true);
    },
    hideSpinner: function(component){
        this.showHideDiv(component, "waiting", false);
    },
     disableForm: function(component){
        var list = [
            "ProfessionType","EditAddress","InitiateCibil","appIdentityProof","appAddressProof","appOwnershipProof",
            "coappIdenPic", "coappAddrPic","FieldDisposition1","FieldDisposition","FieldCheckStatus","AvailedAmount","AvailedTenor",
            "LoanType","ProgramType","schemeName","sourceName"];
        for(var i = 0; i < list.length; i++){
            var element = component.find(list[i]);
            if (element != undefined && element != null){
                if($A.util.isArray(element)){
                     element.forEach(cmp => {
      					cmp.set("v.disabled", true);
   					 })
                     }
                else
                 element.set("v.disabled", true);
            }
        }
        //component.set("v.CoKYCpickval",'');
        //component.set("v.CoAddresspickval",'');
		var event = $A.get("e.c:LoanConversionEvent");
        var loanNumber = component.get("v.ProductOffer.Opportunity__r.Loan_Application_Number__c");
        if (loanNumber!=null && loanNumber!='' && loanNumber!= undefined){
            event.setParams({"loanNumber": loanNumber});
            event.fire();
         }
    },   
    triggerBLMobilityPOCardEvent: function(component){
        var displayOfferEvent = $A.get("e.c:BLMobilityPOCardEvent");
        var cibilScore = component.get("v.cibilScore");
        var loanNumber = component.get("v.loanNumber");
        displayOfferEvent.setParams({ 
            "loanNumber": loanNumber,
            "cibilScore": cibilScore,
            "checkconvert":component.get("v.isConverted")
        });
        displayOfferEvent.fire();
    },
    disableAllFields: function(component){
        var savebuttons = component.find("Savebtn");
        if(savebuttons != undefined && savebuttons.length != undefined)
           for(var btn=0; btn < savebuttons.length; btn++)
                    savebuttons[btn].set("v.disabled",true);
        this.disableForm(component);
    },
	
    convertToLoanApplication: function(component){
	
	  this.executeApex(component, "beforsendToSalesConvert", {
            "leadId": component.get("v.ProductOffer.Lead__c"), 
           	"poId": component.get("v.recordId")
        }, function(error, result){
					if(!error && result){
						var po = result;
						var flow = "";
						
						if (po.Customer_ID1__c != null) {
							flow = po.Customer_ID1__r.Flow__c;
						}
						else
							flow ='None';
						
						var ACMName =null;
						var Sendtoname ='Sales';
						
						this.executeApex(component, "sendToSalesConvert", {
							"leadId": component.get("v.ProductOffer.Lead__c"), 
							"poId": component.get("v.recordId"),
							"flow" : flow,
							"ACMName" :ACMName,
							"Sendtoname" : Sendtoname
						}, function(error, result){
							if(!error && result){
								var data = result.split('---');
								if(data[0] == 'success'){
								component.set("v.loanId", data[1]);
								//this.postConvertion(component);
								this.showToast(component, "Success!", "Converted to Loan Application successfully LAN:"+data[2], "success");
								component.set("v.isShowConvert",false);
								component.set("v.isShowSubitToCredit",true);
								component.set("v.isConverted",true);    
								var event = $A.get("e.c:BLMobilityPOCardEvent");
								event.setParams({"loanNumber": data[2],"checkconvert":component.get("v.isConverted")});
								event.fire();
								this.disableAllFields(component);
								}
								else if(data[0] == 'error'){
									this.showToast(component, "Error!", "Failed to Convert Loan Application - "+data[1], "error");
								}
							} else {
								this.showToast(component, "Error!", "Call back Failed due to Unknown Error !!", "error");
							}
						});
					}
						
				}
				);
		}
        
       /* this.executeApex(component, "sendToSalesConvert", {
            "leadId": component.get("v.ProductOffer.Lead__c"), 
           	"poId": component.get("v.recordId")
        }, function(error, result){
            if(!error && result){
                var data = result.split('---');
                if(data[0] == 'success'){
                component.set("v.loanId", data[1]);
                //this.postConvertion(component);
                this.showToast(component, "Success!", "Converted to Loan Application successfully LAN:"+data[2], "success");
                component.set("v.isShowConvert",false);
                component.set("v.isShowSubitToCredit",true);
                component.set("v.isConverted",true);    
                var event = $A.get("e.c:BLMobilityPOCardEvent");
        		event.setParams({"loanNumber": data[2],"checkconvert":component.get("v.isConverted")});
        		event.fire();
                this.disableAllFields(component);
                }
                else if(data[0] == 'error'){
                	this.showToast(component, "Error!", "Failed to Convert Loan Application - "+data[1], "error");
                }
            } else {
                this.showToast(component, "Error!", "Call back Failed due to Unknown Error !!", "error");
            }
        });
    }*/,
    
    linktoPO: function(component){
    	
        this.executeApex(component, "linkeKYCtoPO", {
            "Cekyc": component.get("v.customerEKYC"),
             "poId": component.get("v.recordId"),
             "leadId": component.get("v.leadID")
        }, function(error, result){
            if(!error && result){
                this.showToast(component, "Success!", "Your Aadhaar was linked to Product Offering ", "success");
                
            } else {
                this.showToast(component, "Error!", "Your Aadhaar was not linked to Product Offering", "error");
            }
        });
    },
    
    postConvertion: function(component){
    	
        this.executeApex(component, "postConvertion", {
            "loanId": component.get("v.loanId"),
             "poId": component.get("v.recordId")
        }, function(error, result){
            if(!error && result){
                //this.showToast(component, "Success!", "Post convertion Success ", "success");
                this.populateCreditSelectList(component);
            } else {
                this.showToast(component, "Error!", "Post convertion Failed", "error");
            }
        });
    }, 
        //Start Bug Id : 21804
        submitToAutoApproval:function(component){
            this.executeApex(component, 'submitForAutoApproval', {
                        "approverId": component.get("v.autoAllocateduser"),
                        "poId": component.get("v.recordId"),
                        "loanId": component.get("v.loanId"),
                        "isAutoCredit" : true
                    }, function(error, result) {
                        console.log('error -->' , error);
                        var parsedVal = JSON.parse(result);
                		console.log('if -->' + parsedVal);
                        if (!error && result === 'true') {
                            this.showToast(component, "Success!", "Loan application submitted to credit successfully", "success");
                           component.set("v.isShowSubitToCredit", false);
                            if(component.find("acm"))
                           component.find("acm").set("v.disabled",true);
     
                        } 
                        if(error || result === 'false'){// Bug Id : 25285 - Concurrency Issue start -unlock p2
                            //this.showToast(component, "Error!", "Failed to submit to approver", "error");
                            this.executeApex(component, 'unlockRecord', {"colId": component.get("v.autoAllocateduser")},
	         					function(error, result) {});
                        }// Bug Id : 25285 - Concurrency Issue end -unlock p2
                        
                    });
          
        },
    populateCreditSelectList: function(component){
     //Bug Id : 21804
        this.executeApex(component, 'autoQueueAllocation', {
                "loanId": component.get("v.recordId")//component.get("v.loanId")
            },
            function(error, result) {
                console.log('error -->' , error);
                var parsedVal = JSON.parse(result);
                console.log('if -->' + parsedVal);
                if (!error && parsedVal != null && parsedVal != undefined) {

                     component.set("v.autoAllocateduser", parsedVal);
                     component.set("v.isOpen", true);
                }
                else if(error || result === 'false'){// Bug Id : 25285 - Concurrency Issue start -unlock p2
                    this.executeApex(component, 'unlockRecord', {"colId": component.get("v.autoAllocateduser")},
	         		function(error, result) {});
                }// Bug Id : 25285 - Concurrency Issue end -unlock p2
                else
                {
                    var recordId1 = component.get("v.recordId");
                    this.executeApex(component, "getACM", { "id1" : recordId1 }, function(error, result){
                        if(!error && result){
                            component.set("v.ACM", true);
                            var options = [{"class": "optionClass", label: "Select", value: ""}];
                            for(var i = 0; i < result.length; i++){
                                options.push({"class": "optionClass", label: result[i].Credit_Officer_Name__r.Name, value: result[i].Id});
                            }
                            var element = component.find("acm");
                            element.set("v.options", options);
                        }
                        if(error || result === 'false'){// Bug Id : 25285 - Concurrency Issue start -unlock p2
                            this.executeApex(component, 'unlockRecord', {"colId": component.get("v.autoAllocateduser")},
                            function(error, result) {});
                        }// Bug Id : 25285 - Concurrency Issue end -unlock p2
                    });
                    
                }
                
            });
        
        
    },
    
    saveACM : function(component){
       // Bug Id : 21804
        var autoAllocateduser=  component.get("v.autoAllocateduser");
        if(autoAllocateduser && !$A.util.isEmpty(autoAllocateduser))
        {
            this.submitToAutoApproval(component) 
        }
        else
        {
            var loanId = component.get("v.loanId");
            var recordId1 = component.get("v.recordId");      
            var selectedACM = component.find("acm").get("v.value");
            this.executeApex(component, "saveACM", { "poId" : recordId1, "acm" : selectedACM }, function(error, result){
                if(!error && result){
                    if(result == "true") {
                        this.showToast(component, "Success!", "Loan Application Successfully Submitted to Credit !", "success");
                        component.set("v.isShowSubitToCredit", false);
                        component.find("acm").set("v.disabled",true);
                    }
                    else
                        this.showToast(component, "Error!", 'There was an error while submitting to Credit, '+result, "error");
                    
                }
            });
        }
    },
    
     //End Bug Id : 21804    
	fetchCustomerDetails: function(component) {
	
		var recordId1 = component.get("v.recordId");
        this.executeApex(component, "CustomerDetails", { "id1" : recordId1 }, function(error, result){
            if(!error && result){
            	component.set("v.ProductOffer", result.Po1);
                component.set("v.isConverted", component.get("v.ProductOffer.Product_Offering_Converted__c"));
            	this.triggerBLMobilityPOCardEvent(component);
                if(component.get("v.LeadApplicants") == null)
                component.set("v.LeadApplicants", result.coApplicants);
            }
        });
	},
	
	fetchDemographicDetails: function(component, event, helper) {
	
		component.set("v.AddressChangeFlag", false);
		var recordId1 = component.get("v.recordId");
        this.executeApex(component, "DemographicDetails", { "id1" : recordId1 }, function(error, result){
            if(!error && result){
            	component.set("v.ProductOffer", result);
            }
        }); 
	},
	
	fetchDocumentDetails: function(component,isSaveNxt,event) {
		$A.util.addClass(component.find("uploadedDocs"),"slds-hide");
		component.set("v.uploadedAttachments", null);
		var DocLst = null;
    	var CoApplicants = null;
    	var eKYC ;
		var recordId1 = component.get("v.recordId");
        this.executeApex(component, "DocumentDetails", { "id1" : recordId1 }, function(error, result){
            if(!error && result){
            	DocLst = result.cvLst;
            	CoApplicants = result.coApplicants;
            	eKYC = result.ekycLst;
            	if(eKYC !=undefined && eKYC != null){
                	if(eKYC.length > 0 && component.get("v.customerEKYC") == null ){
                		component.set("v.customerEKYC",eKYC[0]);
                		component.set("v.isEKYCcompleted",true);
                	}
                }
                
            	if(CoApplicants !=undefined && CoApplicants != null){
                	if(CoApplicants.length > 0 && component.get("v.LeadApplicants") == null )
                	component.set("v.LeadApplicants",CoApplicants);
                }
                
            	if(DocLst !=undefined && DocLst != null){
            		if(DocLst.length > 0){
	                	component.set("v.uploadedAttachments", DocLst);
	                    $A.util.removeClass(component.find("uploadedDocs"),"slds-hide");
	                    this.checkRequiredDocs(component);
	                }
	                else{
	                    $A.util.addClass(component.find("uploadedDocs"),"slds-hide");
	                    component.set("v.AllDocReceived",false);
	                }
            	}
                
            }
        }); 
	},
	
	checkRequiredDocs: function(component,isValidate,event) {
		var Docs = component.get("v.uploadedAttachments");
        var LAlist = component.get("v.LeadApplicants");
		var identy = false;
		var addrs = false;
		var ownershp = false;
		var coappIdentyary = [];
		var coappAddrsary = [];
		var coappIdenty = true;
		var coappAddrs = true;
		if(component.get("v.LeadApplicants") != null)
		for(var k=0;k<component.get("v.LeadApplicants").length;k++){
			coappIdentyary.push(false);
			coappAddrsary.push(false);
			coappIdenty = false;
			coappAddrs = false;
		}
		
		this.resetDocs(component);
		
		if(Docs !=undefined && Docs != null)
		for(var i = 0; i < Docs.length; i++){
			var title = Docs[i].Title.split('_')[0];
			if(title.toLowerCase() == 'Identity'.toLowerCase() ){
				component.find("identityPf").set("v.fileName", Docs[i].Title);
                var ident = Docs[i].Title;
                ident = ident.split("_")[1];
                ident = ident.split("_")[0];
                component.set("v.KYCpickval",ident);
				component.find("identityPf").refresh();
				identy = true;
			}
			else if(title.toLowerCase() == 'Address'.toLowerCase() ){
				component.find("addressPf").set("v.fileName", Docs[i].Title);
                var addpf = Docs[i].Title;
                addpf = addpf.split("_")[1];
                addpf = addpf.split("_")[0];
        		component.set("v.Addresspickval",addpf);
				component.find("addressPf").refresh();
				addrs = true;
			}
			else if(title.toLowerCase() == 'Ownership'.toLowerCase() ){
				component.find("OwnershipPf").set("v.fileName", Docs[i].Title);
                var ownpf = Docs[i].Title;
                ownpf = ownpf.split("_")[1];
                ownpf = ownpf.split("_")[0];
        		component.set("v.Ownershippickval",ownpf);
				component.find("OwnershipPf").refresh();
				ownershp = true;
			}
			else if(LAlist !=undefined && LAlist != null){
				for(var k=0;k<LAlist.length;k++){
					var coapname = LAlist[k].Name;
					if(title.toLowerCase().includes(('CoAppl-Identity-'+coapname).toLowerCase())){
						coappIdentyary[k] = true;
						break;
					}
					else if(title.toLowerCase().includes(('CoAppl-Address-'+coapname).toLowerCase())){
						coappAddrsary[k] = true;
						break;
					}
				}
			}
			
		}
		for(var kk=0;kk<coappIdentyary.length; kk++){
			if(coappIdentyary[kk] == false){
			coappIdenty = coappIdentyary[kk];
			break;}
			else coappIdenty = true;
		}
		for(var kk=0;kk<coappAddrsary.length; kk++){
			if(coappAddrsary[kk] == false){
			coappAddrs = coappAddrsary[kk];
			break;}
			else coappAddrs = true;
		}
        if(component.get("v.checkAllDocReceived") && !component.get("v.isConverted")){
            if(((identy && addrs) || component.get("v.isEKYCcompleted")) && ownershp && coappIdenty && coappAddrs)
            component.set("v.AllDocReceived",true);
            else
            component.set("v.AllDocReceived",false);
        }
        else {
           component.set("v.AllDocReceived",true);
    	}
		if(isValidate == true){
			if(! component.get("v.AllDocReceived")){
	    		this.showToast(component, "Error!", "Upload all required Documents", "error");
	    	}
	    	else{
	    		if(event != undefined)
	    		this.toNextTab(component, event);
	    	}
		}
		
	},
	
	resetDocs : function(component) {
		component.find("identityPf").set("v.fileName", 'No file chosen');
		component.find("identityPf").refresh();
		component.find("addressPf").set("v.fileName", 'No file chosen');
		component.find("addressPf").refresh();
		component.find("OwnershipPf").set("v.fileName", 'No file chosen');
		component.find("OwnershipPf").refresh();

        var coapAdd = component.find("CoApplicant-Address");
		var coapiden = component.find("CoApplicant-Identity");
		if(coapAdd != undefined && coapAdd != null){
			if(coapAdd.length != undefined){
			for(var k=0;k<coapAdd.length; k++){
				coapAdd[k].set("v.fileName", 'No file chosen');
				coapAdd[k].refresh();
				coapiden[k].set("v.fileName", 'No file chosen');
				coapiden[k].refresh();
			}
			}
			else{
				coapAdd.set("v.fileName", 'No file chosen');
				coapAdd.refresh();
				coapiden.set("v.fileName", 'No file chosen');
				coapiden.refresh();
			}
		}
    },
    
    fetchDocsOnly : function(component) {
    	component.set("v.uploadedAttachments", null);
    	var recordId1 = component.get("v.recordId");
        this.executeApex(component, "DocumentDetails", { "id1" : recordId1 }, function(error, result){
            if(!error && result){
            	var DocLst = result.cvLst;
            	if(DocLst !=undefined && DocLst != null){
            		if(DocLst.length > 0){
	                	component.set("v.uploadedAttachments", DocLst);
	                    $A.util.removeClass(component.find("uploadedDocs"),"slds-hide");
	                }
	                else{
	                    $A.util.addClass(component.find("uploadedDocs"),"slds-hide");
	                }
            	}
                
            }
        }); 
    },
    
	deleteFile : function(component, contentVer) {
		var attachId = contentVer.ContentDocumentId;
        this.executeApex(component, "removeFile", { "attachId" : attachId }, function(error, result){
            if(!error && result){
            	this.showToast(component, "Success!", contentVer.Title+" has been deleted ", "success");
            	this.resetDocs(component);
            	this.fetchDocumentDetails(component,false);
            }
        });
    },
	
	fetchDispositionDetails: function(component) {
		
		var recordId1 = component.get("v.recordId");
		this.fetchDocumentDetails(component,false);
        this.executeApex(component, "DispositionDetails", { "id1" : recordId1 }, function(error, result){
            if(!error && result){
            	component.set("v.ProductOffer", result);
            	this.populateDispositionData(component);
            	this.ShowConvert(component);
            	
            }
        });
	},
	
	toNextTab: function(component, event) {
		var tabId= event.getSource().get("v.value");
		if(tabId == "t1"){
            var tabNum = tabId.slice(1);
            var NexTabId = 't'+ (parseInt(tabNum)+1).toString();
            var CurrentTab = component.find(tabId);
            $A.util.removeClass(CurrentTab, 'slds-active ActiveBar cBLMobilityOfferDetailComp');
            var CurrentTabDetail = component.find(tabId+'detail');
            $A.util.removeClass(CurrentTabDetail, 'slds-show');
            $A.util.addClass(CurrentTabDetail, 'slds-hide');
            var NextTab = component.find(NexTabId);
            $A.util.addClass(NextTab, 'slds-active ActiveBar cBLMobilityOfferDetailComp');
            var NextTabDetail = component.find(NexTabId+'detail');
            $A.util.removeClass(NextTabDetail, 'slds-hide');
			$A.util.addClass(NextTabDetail, 'slds-show');
			this.fetchCustomerDetails(component);
		}
        //Added by Rohan for Tab Next functionality from Customer Details and Document Details
		if(tabId == "t2" || tabId == "t4"){
            var tabNum = tabId.slice(1);
            var NexTabId = 't'+ (parseInt(tabNum)+1).toString();
            var CurrentTab = component.find(tabId);
            $A.util.removeClass(CurrentTab, 'slds-active ActiveBar cBLMobilityOfferDetailComp');
            var CurrentTabDetail = component.find(tabId+'detail');
            $A.util.removeClass(CurrentTabDetail, 'slds-show');
            $A.util.addClass(CurrentTabDetail, 'slds-hide');
            var NextTab = component.find(NexTabId);
            $A.util.addClass(NextTab, 'slds-active ActiveBar cBLMobilityOfferDetailComp');
            var NextTabDetail = component.find(NexTabId+'detail');
            $A.util.removeClass(NextTabDetail, 'slds-hide');
			$A.util.addClass(NextTabDetail, 'slds-show');
		}        
      	//Added by Rohan for Tab Next functionality from Customer Details and Document Details
		if(tabId == "t3"){
            var addresscheckbox = component.find("EditAddress").get("v.value");
            var allowSave = true;
            if(!addresscheckbox)
            {
                var daddline1 = component.find("D_AddressLine1").get("v.value");
                var daddline2 = component.find("D_AddressLine2").get("v.value");
                var daddline3 = component.find("D_AddressLine3").get("v.value");
                var dresidenceCity = component.find("D_ResiCity").get("v.value");
                var dResiState = component.find("D_ResiState").get("v.value");
                var dPinCode = component.find("D_ResiPinCode").get("v.value");
                if(daddline1 == null || daddline1 == undefined || daddline1 == ""){
                    this.markRed(component.find("D_AddressLine1"),true,"Residence Address Line 1 cannot be blank ");
                    allowSave = false;
                }
                else{
                    this.markRed(component.find("D_AddressLine1"),false,"");
                }
                if(daddline2 == null || daddline2 == undefined || daddline2 == ""){
                    this.markRed(component.find("D_AddressLine2"),true,"Residence Address Line 2 cannot be blank ");
                    allowSave = false;
                }
                else{
                    this.markRed(component.find("D_AddressLine2"),false,"");
                }
                if(daddline3 == null || daddline3 == undefined || daddline3 == ""){
                    this.markRed(component.find("D_AddressLine3"),true,"Residence Address Line 3 cannot be blank ");
                    allowSave = false;
                }
                else{
                    this.markRed(component.find("D_AddressLine3"),false,"");
                }
                if(dresidenceCity == null || dresidenceCity == undefined || dresidenceCity == ""){
                    this.markRed(component.find("D_ResiCity"),true,"Residence City cannot be blank ");
                    allowSave = false;
                }
                else{
                    this.markRed(component.find("D_ResiCity"),false,"");
                }
                if(dResiState == null || dResiState == undefined || dResiState == ""){
                    this.markRed(component.find("D_ResiState"),true,"Residence State cannot be blank ");
                    allowSave = false;
                }
                else{
                    this.markRed(component.find("D_ResiState"),false,"");
                }
                if(dPinCode == null || dPinCode == undefined || dPinCode == ""){
                    this.markRed(component.find("D_ResiPinCode"),true,"Residence Pincode cannot be blank ");
                    allowSave = false;
                }
                else{
                    this.markRed(component.find("D_ResiPinCode"),false,"");
                }
            }
            if(allowSave)
            {
				console.log('Nexttab')
                var tabNum = tabId.slice(1);
                var NexTabId = 't'+ (parseInt(tabNum)+1).toString();
                var CurrentTab = component.find(tabId);
                $A.util.removeClass(CurrentTab, 'slds-active ActiveBar cBLMobilityOfferDetailComp');
                var CurrentTabDetail = component.find(tabId+'detail');
                $A.util.removeClass(CurrentTabDetail, 'slds-show');
                $A.util.addClass(CurrentTabDetail, 'slds-hide');
                var NextTab = component.find(NexTabId);
                $A.util.addClass(NextTab, 'slds-active ActiveBar cBLMobilityOfferDetailComp');
                var NextTabDetail = component.find(NexTabId+'detail');
                $A.util.removeClass(NextTabDetail, 'slds-hide');
				$A.util.addClass(NextTabDetail, 'slds-show');
                this.fetchDocumentDetails(component,false);
            }
            else
                this.showToast(component, "Error!", "Please enter all the RESIDENCE ADDRESS fields", "error");
		}
		if(tabId == "t5"){
            
            var tabNum = tabId.slice(1);
            var NexTabId = 't'+ (parseInt(tabNum)+1).toString();
            var CurrentTab = component.find(tabId);
            $A.util.removeClass(CurrentTab, 'slds-active ActiveBar cBLMobilityOfferDetailComp');
            var CurrentTabDetail = component.find(tabId+'detail');
            $A.util.removeClass(CurrentTabDetail, 'slds-show');
            $A.util.addClass(CurrentTabDetail, 'slds-hide');
            var NextTab = component.find(NexTabId);
            $A.util.addClass(NextTab, 'slds-active ActiveBar cBLMobilityOfferDetailComp');
            var NextTabDetail = component.find(NexTabId+'detail');
            $A.util.removeClass(NextTabDetail, 'slds-hide');
			$A.util.addClass(NextTabDetail, 'slds-show');
			this.fetchDispositionDetails(component);
		}
		
	},
	
	validateDispositionFields :function(component){
		var isValid = "true";
    	
    	var FieldDisposition1 = component.find("FieldDisposition1");
    	var FieldDisposition = component.find("FieldDisposition");
    	var FieldCheckStatus = component.find("FieldCheckStatus");
    	var AvailedAmount = component.find("AvailedAmount");
    	var AvailedTenor = component.find("AvailedTenor");
    	var LoanType = component.find("LoanType");
    	var ProgramType = component.find("ProgramType");
    	var schemeName = component.find("schemeName");
    	var sourceName = component.find("sourceName");
    	
    	var FieldDisposition1_val = component.get("v.ProductOffer.Field_Disposition_1__c");
    	var FieldDisposition_val = component.get("v.ProductOffer.Field_Desposition_Status__c");
    	var FieldCheckStatus_val = component.get("v.ProductOffer.Field_Check_Status__c");
    	var AvailedAmount_val = component.get("v.ProductOffer.Availed_Amount__c");
    	var AvailedTenor_val = component.get("v.ProductOffer.Availed_Tenor__c");
    	var LoanType_val = component.get("v.ProductOffer.Loan_Type__c");
    	var ProgramType_val = component.get("v.ProductOffer.Program_Type__c");
    	var schemeName_val = component.get("v.ProductOffer.Scheme__c");
    	var sourceName_val = component.get("v.ProductOffer.Sourcing_Channel__c");
		
		if(FieldDisposition1_val == null || FieldDisposition1_val == undefined || FieldDisposition1_val == ""){
			this.markRed(FieldDisposition1,true,"Field Disposition 1 Status cannot be Empty ");
			isValid = "false";
		}
		if(FieldDisposition_val == null || FieldDisposition_val == undefined || FieldDisposition_val == ""){
			this.markRed(FieldDisposition,true,"Field Disposition Status cannot be Empty ");
			isValid = "false";
		}
		if(FieldCheckStatus_val == null || FieldCheckStatus_val == undefined || FieldCheckStatus_val == ""){
			this.markRed(FieldCheckStatus,true,"Field Check Status cannot be Empty ");
			isValid = "false";
		}
		if(AvailedAmount_val == null || AvailedAmount_val == undefined || AvailedAmount_val == ""){
			this.markRed(AvailedAmount,true,"Applied Loan Amount cannot be Empty ");
			isValid = "false";
		}
		if(AvailedTenor_val == null || AvailedTenor_val == undefined || AvailedTenor_val == ""){
			this.markRed(AvailedTenor,true,"Availed Tenor cannot be Empty ");
			isValid = "false";
		}
		if(LoanType_val == null || LoanType_val == undefined || LoanType_val == ""){
			this.markRed(LoanType,true,"Type of Loan cannot be Empty ");
			isValid = "false";
		}
		if(ProgramType_val == null || ProgramType_val == undefined || ProgramType_val == ""){
			this.markRed(ProgramType,true,"Program Type cannot be Empty ");
			isValid = "false";
		}
		if(schemeName_val == null || schemeName_val == undefined || schemeName_val == ""){
			this.markRed(schemeName,true,"Scheme Name cannot be Empty ");
			isValid = "false";
		}
		if(sourceName_val == null || sourceName_val == undefined || sourceName_val == ""){
			this.markRed(sourceName,true,"Source Channel cannot be Empty ");
			isValid = "false";
		}
		
		if(isValid == "true"){
			component.set("v.isValidDispositionFields",true);
		}
		else{
			component.set("v.isValidDispositionFields",false);
		}
    },
    
    checkForMandatory : function(component){
    	var recordId1 = component.get("v.recordId");
        this.executeApex(component, "fetchFieldInfo", { "id1" : recordId1 }, function(error, result){
            if(!error && result){
            	if(result.Po1.Lead__r.Profession_Type__c == null || result.Po1.Lead__r.Profession_Type__c ==undefined || result.Po1.Lead__r.Profession_Type__c ==''){
            		this.markRed(component.find("ProfessionType"),true,"Select a Valid Profession");
            		component.set("v.isAllowConvert",false);
                    this.showToast(component, "Error!", "Select a Valid Profession!", "error");
				}
                else {
                    if(component.get("v.cibilScore") == null || component.get("v.cibilScore") ==undefined || component.get("v.cibilScore") ==''){
                        component.set("v.isAllowConvert",false);
                        this.showToast(component, "Error!", "CIBIL is not Initiated!", "error");
                    }
                    else
                        component.set("v.isAllowConvert",true);
                }
                if(component.get("v.isAllowConvert") == true){
                    this.validateDispositionFields(component);
                    this.checkRequiredDocs(component,true);
                    if(component.get("v.isValidDispositionFields") == true && 
                       component.get("v.AllDocReceived") == true && 
                       component.get("v.isAllowConvert") == true)
                    {
                        component.set("v.isAllowConvert",true);
                        $A.util.removeClass(component.find("spinner"),"slds-hide");
                        this.convertToLoanApplication(component);
                    }
                    else{
                        component.set("v.isAllowConvert",false);
                        this.showToast(component, "Error!", "Failed to Convert Loan Application!", "error");
                    }
                }
            }
        });
    	
    },
    
    ShowConvert : function(component){
    	if(component.get("v.ProductOffer.Field_Disposition_1__c") == "Docs Received" && component.get("v.ProductOffer.Field_Desposition_Status__c") == "Docs Received" && component.get("v.isConverted") != true){
    		component.set("v.isShowConvert",true);
    	}
    	else{
    		component.set("v.isShowConvert",false);
    	}
    },
    
	validatePIN : function(component,pinName, cmpId){
        component.set(pinName, component.get(pinName).replace(/[a-zA-z]/g, ''));
        return this.validateField(component, cmpId, /^[1-9]\d{5}$/, "Pin Code");
    },
    
    validateAmount : function(component,avlamt, cmpId){
        return this.validateField(component, cmpId, /^\d+(\.\d{1,2})?$/, "Number ");
    },
    
    validateaddress35 : function(component,fld, cmpId){
        if(component.get(fld).length > 35){
        	component.set(fld, component.get(fld).substring(0,35));
        }
    },
    
    validateField: function(component, key, pattern, error){
        var field = component.find(key); 
        var value = '' + field.get("v.value");
        var valid = !!(value == '' || pattern.test(value.trim())); 

        if(valid)
        this.markRed(field,false,"");
        else
        this.markRed(field,true,"Enter a valid " + error);
        
        return valid;
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
    },
    
    markRed: function(field, err,msg){
    	if(err){
    	$A.util.addClass(field, 'error1 cBLMobilityOfferDetailComp');
    	field.set("v.errors", [{message: msg}]);
    	}
    	else{
    	$A.util.removeClass(field, 'error1 cBLMobilityOfferDetailComp');
    	field.set("v.errors", null);
    	}
    },
    validatePAN : function(component){
        var pan_val = component.get("v.ProductOffer.Lead__r.PAN__c");
        if(pan_val == null || pan_val == undefined || pan_val == "")
			return false;
        else{
        	component.set("v.ProductOffer.Lead__r.PAN__c", (component.get("v.ProductOffer.Lead__r.PAN__c") || "").toUpperCase());
        	return this.validateField(component, "PAN", /[A-Za-z]{5}\d{4}[A-Za-z]{1}/, "PAN number");
        }
    },
    validateDOB: function(component){
        var dob = new Date(component.get('v.ProductOffer.Lead__r.DOB__c')).getTime();
        if(isNaN(dob)) return true;
        var dtToday = (new Date()).getTime();
        var timeDiff = dtToday - dob;
        var diffDays = (timeDiff / (1000 * 3600 * 24 * 365.25)).toFixed(3); 
        var result = this.isEmpty(dob) || (diffDays > 24.999 && diffDays <= 70.00);
        component.find("DOB").set("v.errors", [{message: result ? "" : "Customer age should be greater than 25 and less than 71"}]);
        return result;
    },
    isEmpty: function(value){
        return ($A.util.isEmpty(value) || $A.util.isUndefined(value) || value === 0);
    },
	
})