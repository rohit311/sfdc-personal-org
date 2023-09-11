({
	init: function(component, event, helper) {
		
		component.set("v.LeadApplicants", null);
		helper.getPicklistData(component, "Product_Offerings__c","Program_Type__c","ProgramType", "ProgramType");
		helper.getPicklistData(component, "Lead","Profession_Type__c","Profession", "ProfessionType");
		helper.getPicklistData(component, "Product_Offerings__c","Loan_Type__c","Loan Type", "LoanType");
		helper.getPicklistData(component, "Product_Offerings__c","Field_Disposition_1__c","Field Disposition1", "FieldDisposition1");
		helper.getResidentialCity(component);
 		helper.getDocsMandFlag(component);
		var action = component.get("c.OfferDetails");
        action.setParams({
                            "id1":component.get("v.recordId"),
                        });
                        
        action.setCallback(this, function(response){
            
            if (component.isValid() && response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.ProductOffer", result);
                component.set("v.leadID", result.Lead__c);
                component.set("v.isConverted", result.Product_Offering_Converted__c);
	            helper.getCIBILfromLead(component);
                //22141 S
                 helper.getmobileValidResult(component);
                // 22141 E
                if(component.get("v.isConverted") == true){
            		helper.disableAllFields(component);
                    component.set("v.loanNumber", result.Opportunity__r.Loan_Application_Number__c); 
                     component.set("v.isShowSubitToCredit", (result.Opportunity__r.StageName== 'DSA/PSF Login'));
            	}
                component.set("v.cibilScore", result.Lead__r.CIBIL_Score__c); 
                helper.triggerBLMobilityPOCardEvent(component);
            }
        })        
		$A.enqueueAction(action); 
	},
	
	onDispo1Change: function(component, event, helper){
        helper.populateDispositionData(component);
        helper.ShowConvert(component);
    },
	
	onDispoChange: function(component, event, helper){
        helper.populateFieldCheckData(component);
        helper.ShowConvert(component);
    },
    
    onFieldCheckChange: function(component, event, helper){
    	var FieldCheckStatus_val = component.get("v.ProductOffer.Field_Check_Status__c");
    	if(FieldCheckStatus_val != null && FieldCheckStatus_val != undefined && FieldCheckStatus_val != ""){
        helper.markRed(component.find("FieldCheckStatus"),false);
        }
    },
    
    onTenorChange: function(component, event, helper){
    	var tenor_val = component.get("v.ProductOffer.Availed_Tenor__c");
    	if(tenor_val != null && tenor_val != undefined && tenor_val != ""){
        helper.markRed(component.find("AvailedTenor"),false);
        }
    },
    
    onLoanTypeChange: function(component, event, helper){
    	var LoanType_val = component.get("v.ProductOffer.Loan_Type__c");
    	if(LoanType_val != null && LoanType_val != undefined && LoanType_val != ""){
        helper.markRed(component.find("LoanType"),false);
        }
    },
    onProgramTypeChange: function(component, event, helper){
    	var ProgramType_val = component.get("v.ProductOffer.Program_Type__c");
    	if(ProgramType_val != null && ProgramType_val != undefined && ProgramType_val != ""){
        helper.markRed(component.find("ProgramType"),false);
        }
    },
    
    sourceKeyPressController: function(component, event, helper){
        helper.startSearch(component, 'source'/*, component.get("v.ProductOffer.Sourcing_Channel__c")*/);
    },
    
    schemeKeyPressController: function(component, event, helper){
        helper.startSearch(component, 'scheme'/*,component.get("v.ProductOffer.Scheme__c")*/);
    },
    
    selectSource: function(component, event, helper){
        var index = event.currentTarget.dataset.record;
     	var selectedSource = component.get("v.sourceList")[index];
        var keyword = selectedSource.Name;
        if(selectedSource.Branch__r && selectedSource.Branch__r.Name){
            keyword += ' - ' + selectedSource.Branch__r.Name;
        }
        if(selectedSource.Reporting_Manager__r.Name !== undefined){
            keyword += ' - ' + selectedSource.Reporting_Manager__r.Name;
        }
        component.set("v.selectedSource" , selectedSource); 
        component.set("v.sourceSearchKeyword", keyword);
        component.set("v.ProductOffer.Sourcing_Channel__c", selectedSource.Id);
        helper.openCloseSearchResults(component, "source", false);
        component.find("sourceName").set("v.errors", [{message:""}]);
    },
    
    selectScheme: function(component, event, helper){
        var index = event.currentTarget.dataset.record;
     	var selectedScheme = component.get("v.schemeList")[index];
        var keyword = selectedScheme.Name;

        component.set("v.selectedScheme" , selectedScheme); 
        component.set("v.schemeSearchKeyword", keyword);
        component.set("v.ProductOffer.Scheme__c", selectedScheme.Id);
        helper.openCloseSearchResults(component, "scheme", false);
        component.find("schemeName").set("v.errors", [{message:""}]);
    },
    
	residenceCityKeyPressController: function(component, event, helper){
        helper.searchCity(component, component.get("v.ProductOffer.Resi_City__c"), 'residenceCity');
    },
    
    officeCityKeyPressController: function(component, event, helper){
        helper.searchCity(component, component.get("v.ProductOffer.Office_City__c"), 'officeCity');
    },
    
    selectResidenceCity: function(component, event, helper){
        var index = event.currentTarget.dataset.record; 
     	var selectedResidenceCity = component.get("v.filteredCities")[index];
        component.set("v.ProductOffer.Resi_City__c", selectedResidenceCity); 
        helper.getMappingState(component, selectedResidenceCity, false);
        helper.openCloseSearchResults(component, "residenceCity", false);
    },
    
    selectOfficeCity: function(component, event, helper){
        var index = event.currentTarget.dataset.record; 
     	var selectedOfficeCity = component.get("v.filteredCities")[index];
        component.set("v.ProductOffer.Office_City__c", selectedOfficeCity); 
        helper.getMappingState(component, selectedOfficeCity, true);
        helper.openCloseSearchResults(component, "officeCity", false);
    },
    
    showCPV: function(component, event, helper) {
    	component.set("v.isCpv",true);
	},
	
	NextCPV: function(component, event, helper) {
    	component.set("v.isCpv",true);
    	helper.checkRequiredDocs(component,true,event);
	},
    
	getCustomerDetails: function(component, event, helper) {
		helper.fetchCustomerDetails(component);
	},
	
	isValidProf: function(component, event, helper) {
		if(component.get("v.ProductOffer.Lead__r.Profession_Type__c"))
		helper.markRed(component.find("ProfessionType"),false);
	},
	
	getDemographicDetails: function(component, event, helper) {
		helper.fetchDemographicDetails(component, event, helper);
	},
	
	getDocumentDetails: function(component, event, helper) {
		component.set("v.KYCpickval",'');
        component.set("v.Addresspickval",'');
        component.set("v.Ownershippickval",'');
		helper.fetchDocumentDetails(component);
	},
	
	refreshDocList: function(component, event, helper) {
		helper.fetchDocsOnly(component);
	},
	
	removeDoc: function(component, event, helper) {
		var contVer = event.getSource().get("v.value");
		component.set("v.selectedDeleteFile",contVer);
		component.set("v.isDeletePop",true);
	},
	cancelDelete : function(component, event, helper) {
		component.set("v.isDeletePop",false);
	},
	confirmDelete: function(component, event, helper) {
		helper.deleteFile(component,component.get("v.selectedDeleteFile"));
		component.set("v.isDeletePop",false);
	},
	
	getDispositionDetails: function(component, event, helper) {
		helper.fetchDispositionDetails(component);
	},
	
	editAddress: function(component, event, helper) {
	},
	NextTab: function(component, event, helper) {
	
		helper.toNextTab(component, event);
		
	},
	
	SaveNextCustomerDetails: function(component, event, helper) {
		helper.saveCustomerDetails(component,event);
		
	},
	SaveNextDemographicDetails: function(component, event, helper) {
		//helper.savePoDetails(component, event);
		helper.saveDemogDetails(component, event);
	},
    initiateCIBIL: function(component, event, helper) {
		helper.createCIBIL(component, event);
		
	},
     showSpinner: function(component, event, helper){
        helper.showSpinner(component);
    },
    hideSpinner: function(component, event, helper){
        helper.hideSpinner(component);
    },
    wait: function(component, event, helper){
        helper.showHideDiv(component, "alertDialog", false);
        helper.setTimeout(helper.showSpinner, helper, 1, component);
        helper.setTimeout(helper.checkForCIBILScore, helper, 10000, component);
    },
    abort: function(component, event, helper){
        helper.showHideDiv(component, "alertDialog", false);
    },
	save: function(component, event, helper) {
        helper.savePoDetails(component, event);
    },
    
    showACM: function(component, event, helper) {
        helper.populateCreditSelectList(component);
    },
    
    onACMChange: function(component, event, helper){
    	component.set("v.isOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        var parsedVal = component.get("v.autoAllocateduser");
        if (parsedVal != null && parsedVal != undefined) {  // Bug Id : 25285 - Concurrency Issue start
	         console.log('clicked cancel to auto allocation --> ');
	         this.executeApex(component, 'unlockRecord', {"colId": parsedVal},
	         function(error, result) {});
	     }  // Bug Id : 25285 - Concurrency Issue end
    	component.set("v.isOpen", false);
    },
    
    acceptedACM: function(component, event, helper){
    	component.set("v.isOpen", false);
    	helper.saveACM(component);
    },
    
    convert2Loan: function(component, event, helper) {
    	helper.checkForMandatory(component);
    },
	
	linktoPO: function(component, event, helper) {
		var kycRec = event.getParam("kyc");
		component.set("v.customerEKYC",kycRec);
		helper.linktoPO(component);
	},
	
	tabAction: function(component, event, helper) {
		
		for(var i=1;i<=7;i++) {
			var tmptab = component.find('t'+i.toString());
			var tmptabDetail = component.find('t'+i.toString()+'detail');
			$A.util.removeClass(tmptab, 'slds-active ActiveBar cBLMobilityOfferDetailComp');
			$A.util.removeClass(tmptabDetail, 'slds-show');
			$A.util.addClass(tmptabDetail, 'slds-hide');
		}
		
		var tabId= event.currentTarget.dataset.index;
		var ActiveTab = component.find(tabId);
		var ActiveTabDetail = component.find(tabId+'detail');
		$A.util.addClass(ActiveTab, 'slds-active ActiveBar cBLMobilityOfferDetailComp');
		$A.util.removeClass(ActiveTabDetail, 'slds-hide');
		$A.util.addClass(ActiveTabDetail, 'slds-show');
		
    },
    
    
    validatePIN: function(component, event, helper) {
        helper.validatePIN(component,'v.ProductOffer.Pin_Code__c','PinCode');
    },
    validateOfficePIN: function(component, event, helper) {
        helper.validatePIN(component,'v.ProductOffer.Office_Pin_Code__c','Officepincode');
    },
    
    onAmountChange: function(component, event, helper) {
        helper.validateAmount(component,'v.ProductOffer.Availed_Amount__c','AvailedAmount');
    },
    
    CorrectAmount: function(component, event, helper) {
    	var valid = component.get("v.ProductOffer.Availed_Amount__c") <= component.get("v.ProductOffer.Offer_Amount__c");
    	var field = component.find("AvailedAmount");
  		
  		if(valid){
  		helper.markRed(field,false,"");
  		component.set("v.isValidAmount",true);
  		}
        else{
        helper.markRed(field,true,"Enter amount less than Offered Amount ");
        component.set("v.isValidAmount",false);
        }
        
    },
    validateadd1 : function(component, event, helper) {
        helper.validateaddress35(component,'v.ProductOffer.Address_Line_1__c','AddressLine1');
    },
    validateadd2 : function(component, event, helper) {
        helper.validateaddress35(component,'v.ProductOffer.Address_Line_2__c','AddressLine2');
    },
    validateadd3 : function(component, event, helper) {
        helper.validateaddress35(component,'v.ProductOffer.Address_Line_3__c','AddressLine3');
    },
    offvalidateadd1 : function(component, event, helper) {
        helper.validateaddress35(component,'v.ProductOffer.Office_Address_1__c','AddressLine1');
    },
    offvalidateadd2 : function(component, event, helper) {
        helper.validateaddress35(component,'v.ProductOffer.Office_Address_2__c','AddressLine1');
    },
    offvalidateadd3 : function(component, event, helper) {
        helper.validateaddress35(component,'v.ProductOffer.Office_Address_3__c','AddressLine1');
    },
    
    closeCustomToast: function(component, event, helper){
        helper.closeToast(component);
    },
	selectedCA : function(component, event, helper){
        component.find("CoApplicant-Identity").set("v.fileName", "No file chosen");
        component.find("CoApplicant-Address").set("v.fileName", "No file chosen");
        component.find("CoApplicant-Identity").refresh();
        component.find("CoApplicant-Address").refresh();
        component.set("v.CoKYCpickval",'');
        component.set("v.CoAddresspickval",'');
        var caname = component.get("v.coname")
        var Docs = component.get("v.uploadedAttachments");
        if(component.get("v.isConverted") == true){
        	helper.disableForm(component);
        }
        if(component.get("v.LeadApplicants") && Docs!= null && Docs !=undefined){
            for(var i = 0; i < Docs.length; i++){
        	var title = Docs[i].Title.split('_')[0];
            if(title.toLowerCase().includes(('CoAppl-Identity-'+caname).toLowerCase()))
            {
                component.find("CoApplicant-Identity").set("v.fileName", Docs[i].Title);
                var coappidntpf = Docs[i].Title;
                coappidntpf = coappidntpf.split("_")[1];
                coappidntpf = coappidntpf.split("_")[0];
                component.set("v.CoKYCpickval",coappidntpf);
                component.find("CoApplicant-Identity").refresh();
            }
            if(title.toLowerCase().includes(('CoAppl-Address-'+caname).toLowerCase()))
            {
                component.find("CoApplicant-Address").set("v.fileName", Docs[i].Title);
                var coappaddpf = Docs[i].Title;
                coappaddpf = coappaddpf.split("_")[1];
                coappaddpf = coappaddpf.split("_")[0];
                component.set("v.CoAddresspickval",coappaddpf);
                component.find("CoApplicant-Address").refresh();
            }
        }
        }
    },
    validatePAN: function(component, event, helper) {
        helper.validatePAN(component);
    },
    validateDOB: function(component, event, helper) {
        helper.validateDOB(component);
    }
})