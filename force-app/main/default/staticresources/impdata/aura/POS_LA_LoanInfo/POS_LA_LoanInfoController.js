({
    doInit : function(component, event, helper) {
        try {
            console.log(component.get("v.applicantObj"));
           helper.fetchData(component);
            helper.getPickListOptionValues(component, event);
            helper.getScheme(component);
            //23801 S
            helper.gettypeOfLoan(component);
            //23801 E
             console.log(component.get("v.applicantObj"));
             console.log('hellll');
           
        } catch (exceptionInstance) {
            console.log('Something wrong in DoInit method --> ' + exceptionInstance.message);
            console.log('stack details DoInit method --> ' + exceptionInstance.stack);
        }
    },
    saveLoanData : function(component, event, helper) {
        helper.saveLoanData(component, event, helper);
    },
    schemeKeyPressController : function(component, event, helper){
        helper.searchScheme(component);  
    },
    selectScheme : function(component, event, helper){
        var index = event.currentTarget.dataset.record; 
        var selectedScheme = component.get("v.filteredScheme")[index];
        component.set("v.schemeSearchKeyword", selectedScheme.Name);
        console.log('selectedScheme -->' , selectedScheme.Id);
        component.set("v.oppObj.Scheme_Master__c", selectedScheme.Id);
        console.log('scheme -->' + component.get("v.oppObj.Scheme_Master__c"));
        helper.openCloseSearchResults(component, "scheme", false);
    },
    openGSTModal: function(component,event,helper) {
        console.log('inside openGSTModal -->');
        component.set("v.showGST", true);
        console.log('value of gst -->', component.get("v.showGST"));
    },
    closeModalGST : function(component,event,helper) {
        var cmpTarget = component.find('GSTModalbox');
        var cmpBack = component.find('GSTModalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        component.set("v.showGST", false);
    },
    storeValue : function(component,event,helper) {
        console.log('on change --> ', component.get("v.appliedAmtInLacs"));
        if (component.get("v.appliedAmtInLacs") != '' && component.get("v.appliedAmtInLacs") != undefined) {
            var value = component.get("v.appliedAmtInLacs");
            console.log('storeValue amt -->' , value * 100000);
            component.set("v.surrogateCamObj.Loan_Amount__c", value * 100000);
        }
    },
    loanVariantChange : function(component, event, helper) {
        var selectedLV = component.find("loanVariant").get("v.value");
        console.log('selectedLV ------->> ' + selectedLV);
        if(selectedLV != '') {
            component.set("v.oppObj.Loan_Variant__c", selectedLV);
        } else {
            component.set("v.oppObj.Loan_Variant__c", '');
        }
        component.find("scheme").set("v.value", '');
        component.set("v.oppObj.Scheme_Master__c", '');
        console.log('scheme -->' + component.get("v.oppObj.Scheme_Master__c"));
    },
    endUseChange : function(component, event, helper) {
        var selectedEU = component.find("endUse").get("v.value");
        console.log('selectedEU ------->> ' + selectedEU);
        if(selectedEU != '') {
            component.set("v.oppObj.End_Use__c", selectedEU);
        } else {
            component.set("v.oppObj.End_Use__c", '');
        }
	},
    typeOfPDChange : function(component, event, helper) {
        var selectedTypeOfPD = component.find("typeOfPD").get("v.value");
        console.log('selectedTypeOfPD ------->> ' + selectedTypeOfPD);
        if(selectedTypeOfPD != '') {
            component.set("v.personalDiscussion.Type_of_PD__c", selectedTypeOfPD);
        } else {
            component.set("v.personalDiscussion.Type_of_PD__c", '');
        }
    },
    	// Bug 23801 S
       typeOfLoanChange : function(component, event, helper) {
        var selectedLoanType = component.find("typeOfLoan").get("v.value");
        console.log('selectedLoanType ------->> ' + selectedLoanType);
        if(selectedLoanType != '') {
            component.set("v.oppObj.Type_Of_Loan__c", selectedLoanType);
        } else {
            component.set("v.oppObj.Type_Of_Loan__c", '');
        }
	},
     //Bug 23801 E
   /* officeCityChange : function(component, event, helper) {
        var selectedOC = component.find("officeCity").get("v.value");
        console.log('selectedOC ------->> ' + selectedOC);
        if(selectedOC != '') {
            component.set("v.oppObj.Account.Office_City__c", selectedOC);
        } else {
            component.set("v.oppObj.Account.Office_City__c", '');
        }
	},*/
    // 31 jan S
     officeCityKeyPressController: function(component, event, helper){
        helper.searchCity(component);  
    },
     selectOfficeCity: function(component, event, helper){
        var index = event.currentTarget.dataset.record; 
     	var selectedOfficeCity = component.get("v.filteredOfficeCities")[index];
         //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement start
         helper.searchStateAsperCity(component,selectedOfficeCity);
        component.set("v.officeCitySearchKeyword", selectedOfficeCity);
        component.set("v.oppObj.Account.Office_City__c", selectedOfficeCity);
        helper.openCloseSearchResults(component, "officeCity", false);
        
    },
    // 31 jan E
	officeOwnershipChange : function(component, event, helper) {
        var selectedOO = component.find("officeOwnership").get("v.value");
        console.log('selectedOO ------->> ' + selectedOO);
        if(selectedOO != '') {
            component.set("v.oppObj.Account.Type_of_Ownership__c", selectedOO);
        } else {
            component.set("v.oppObj.Account.Type_of_Ownership__c", '');
        }
    },
    disableLoanInfoForm : function(component, event, helper) {
        console.log('=====>> inside loan info disable form ')
       component.set("v.oppObj.StageName",event.getParam("loanStage"));
        helper.disableLoanInfoForm(component);
    },
    enableLoanInfoForm : function(component, event, helper) {
        component.set("v.oppObj.StageName",event.getParam("loanStage"));
        helper.enableLoanInfoForm(component);
    },
    ValidateTenor : function(component, event, helper) {
        helper.ValidateTenor(component);
    },
    validateTenor : function(component, event, helper) {
        helper.ValidateTenor(component);
    },
    validateHybridFlexiTenor:function(component,event,helper){
        helper.validateHybridFlexiTenor(component);// added this on 10/12/2018.Method was called but not present.
    },
    //Added by Rohan
    validateAppliedTenor:function(component,event,helper){
        helper.validateAppliedTenor(component);
    }
})