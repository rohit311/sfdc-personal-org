({
    doInit: function(component, event, helper) {
        // event.stopPropagation();
        
        helper.getHideAadhaarSectionHelper(component);//added for bug id 21851   
        helper.getSpecializationData(component);
        
        helper.getProfessionTypeData(component);
        helper.getPracticeTypeData(component);
        helper.getResidentialTypeData(component);
        console.log('calling function');
        
        //helper.getExperienceData(component); 
        
        //New RDL Mobility app start 
        
        /* if(component.get("v.poId")!='' && component.find("profession").get("v.value") == 'Taxconsultant'){
      Console.log('inside showHideDiv');
            helper.showHideDiv(component, "financialDetails", true);
        }*/
        //New RDL Mobility app end
        // Bug 14509 s
        console.log('v.productFlow==>'+component.get("v.productFlow"));
        if(component.get("v.productFlow") === 'RDL'){
            helper.getDegreeData(component);
        }
        // Bug 14509 E
        
        helper.getResidentialCity(component);
        var poId = component.get("v.poId");
        if(poId){
            console.log('inside getCustomerDetails');
            helper.getCustomerDetails(component, poId);
        }
        
        helper.updateForm(component);
        
    },
    /*changeDegree: function(component, event, helper){ 
        if(component.get("v.po.Type_of_Degree__c")=='Graduate' || component.get("v.po.Type_of_Degree__c")=='Post Graduate'){
        console.log('inside changeDegree');
       var result=['Other'];
      helper.setSelectOptions(component, result, "Degree", "degree");
        }
           component.set("v.po.Degree__c" , 'Other'); 
        //component.set("{!v.po.Degree__c}",'Other')
       
    },*/
    showFinancialSection: function(component, event, helper){ 
        helper.showFinancialSection(component);
    },
    updateFormNew : function(component, event, helper){ 
        helper.updateFormNew(component,component.get("v.po"));
    },
    UpdateForm : function(component, event, helper){ 
        helper.updateForm(component,component.get("v.po"));
    },
    initiateKYCForm: function(component, event, helper){ 
        helper.setKycData(component, event.getParam("kyc") || {});
        helper.setOldLeadData(component);
    },
    sourceKeyPressController: function(component, event, helper){
        helper.startSearch(component, 'source');
    },
    branchKeyPressController: function(component, event, helper){
        helper.startSearch(component, 'branch');
    }, 
    collegeKeyPressController: function(component, event, helper){
        helper.startSearch(component, 'college');
    },
    residenceCityKeyPressController: function(component, event, helper){
        helper.searchCity(component);
    },
    collegeCityKeyPressController: function(component, event, helper){
        helper.searchCollegeCity(component);
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
        component.set("v.po.Sourcing_Channel__c", selectedSource.Id);
        helper.openCloseSearchResults(component, "source", false);
        component.find("sourceName").set("v.errors", [{message:""}]);
    },
    selectResidenceCity: function(component, event, helper){
        var index = event.currentTarget.dataset.record; 
        var selectedResidenceCity = component.get("v.filteredResidenceCities")[index];
        component.set("v.residenceCitySearchKeyword", selectedResidenceCity);
        component.set("v.lead.Resi_City__c", selectedResidenceCity);
        helper.openCloseSearchResults(component, "residenceCity", false);
    },
    selectCollegeCity: function(component, event, helper){
        var index = event.currentTarget.dataset.record; 
        var selectedResidenceCity = component.get("v.filteredCollegeCities")[index];
        component.set("v.collegeCitySearchKeyword", selectedResidenceCity);
        component.set("v.po.Resi_Pick_City__c", selectedResidenceCity);
        helper.openCloseSearchResults(component, "collegeCity", false);
    },
    selectBranch: function(component, event, helper){ 
        var index = event.currentTarget.dataset.record; 
        var selectedBranch = component.get("v.branchList")[index]; 
        component.set("v.selectedBranch" , selectedBranch); 
        component.set("v.branchSearchKeyword", selectedBranch.Name);
        component.set("v.lead.SBS_Branch__c", selectedBranch.Id);
        helper.openCloseSearchResults(component, "branch", false);
        component.find("branchName").set("v.errors", [{message:""}]);
    },
    showIncomeSection: function(component, event, helper){
        if(component.get("v.scam.PY_Type_of_Financial__c")=='Financial' && component.get("v.scam.Rural_Loan_Type__c")=='Cash Profit')
        {
            helper.showHideDiv(component, "incomeCAcashFinancial", true);
            helper.showHideDiv(component, "incomeCAGrossFinancial", false);
        }
        if(component.get("v.scam.PY_Type_of_Financial__c")=='Financial' && component.get("v.scam.Rural_Loan_Type__c")=='Gross Receipt')
        {
            helper.showHideDiv(component, "incomeCAcashFinancial", false);
            helper.showHideDiv(component, "incomeCAGrossFinancial", true);
        }
    },
    selectCollege: function(component, event, helper){ 
        var index = event.currentTarget.dataset.record; 
        var selectedCollege = component.get("v.collegeList")[index]; 
        component.set("v.selectedCollege" , selectedCollege); 
        component.set("v.collegeSearchKeyword", selectedCollege.Name);
        component.set("v.po.Sector_Industry__c", selectedCollege.Id);
        helper.openCloseSearchResults(component, "college", false);
        component.find("collegeName").set("v.errors", [{message:""}]);
    },
    grabOffer: function(component, event, helper){
        helper.grabOffer(component, event.target.id);
    },
    
    
    submitDetails: function(component, event, helper) {
        // console.log('obligation here on changeS==>'+component.find("obligations").get("v.value"));
        var lead = component.get("v.lead");
        var po = component.get("v.po");	//	Bug 15558 - hemant Keni
        if($A.util.isEmpty(lead.FirstName) || $A.util.isEmpty(lead.LastName) || $A.util.isEmpty(lead.MobilePhone)){
            helper.showToast(component, 'Error!', 'Please fill First Name, Last Name and Mobile Number before submitting the details.', 'error');
        }
        
        else if (helper.validate(component)){
            helper.calculateExp(component, event, helper);
            helper.setResidenceAddress(component);
            // Bug 15558 - Hemant Keni - added PO condition in OR of existing offer.
            //alert('isRetriggerRequired : '+!helper.isRetriggerRequired(component) + ' isExistingOffer : '+component.get("v.isExistingOffer") + ' ID : '+ po.Id);
            console.log('retrigger===>'+helper.isRetriggerRequired(component));
            console.log('existing offer===>'+component.get("v.isExistingOffer"));
            console.log('po offer===>'+po);
            console.log('po offer id===>'+po.Id);
            if(!helper.isRetriggerRequired(component) && (component.get("v.isExistingOffer") || (po && po.Id)))
            {
                console.log('Creating lead data on submit');
                helper.createLeadData(component); 
            } else {
                helper.checkForExistingOffers(component);
            }
        }
    },
    disableForm: function(component, event, helper){
        helper.disableForm(component);
    },
    validatePAN: function(component, event, helper) {
        helper.validatePAN(component);
    },
    validatePIN: function(component, event, helper) {
        helper.validatePIN(component);
    },
    validateMobileNumber: function(component, event, helper){
        helper.validateMobileNumber(component)
    },
    validateEmail: function(component, event, helper){
        helper.validateEmail(component);
    },
    validateFirstName: function(component, event, helper){
        helper.validateFirstName(component);
    },
    validateLastName: function(component, event, helper){
        helper.validateLastName(component);
    },
    validateAddress: function(component, event, helper){
        helper.validateAddress(component);
    },
    validateGrossReceipt : function(component, event ,helper){
        helper.validateGrossReceipt(component);
    },
    validateCashProfit : function(component, event ,helper){
        helper.validateCashProfit(component);
    },
    validateTurnOver : function(component, event ,helper){
        helper.validateTurnOver(component);
    },
    validateShopVintage : function(component, event ,helper){
        helper.validateShopVintage(component);
    },
    // Bug 13675 S - hemant Keni
    validateObligation : function(component, event ,helper){
        helper.validateObligation(component);
    },
    // Bug 13675 E - hemant Keni
    wait: function(component, event, helper){
        helper.showHideDiv(component, "alertDialog", false);
        helper.setTimeout(helper.showSpinner, helper, 1, component);
        helper.setTimeout(helper.checkForCIBILScore, helper, 10000, component);
    },
    abort: function(component, event, helper){
        helper.showHideDiv(component, "alertDialog", false);
    },
    gotoNextTab: function(component, event, helper){
        var gotoNextTab = $A.get("e.c:GotoNextTab");;
        gotoNextTab.setParams({ "tabId": 'documentTab' });
        gotoNextTab.fire();
    },
    closeModalPopup: function(component, event, helper){
        helper.showHideDiv(component, "grabOffers", false);
    },
    dummy:function(component, event, helper){
    },
    closeCustomToast: function(component, event, helper){
        helper.closeToast(component);
    },
    showSpinner: function(component, event, helper){
        helper.showSpinner(component);
        
    },
    hideSpinner: function(component, event, helper){
        
        helper.hideSpinner(component);
        
    },
    onChangeOFSpecialisation: function(component, event, helper) { // Bug 15858 - December_2017_CS/CWA Program start
        if(event.getSource().get("v.value").toLowerCase() === 'cs' || event.getSource().get("v.value").toLowerCase() === 'cwa') {
            //alert('inside if');
            var o = [];
            o.push({"class": "optionClass", label: "Select " + "Practice Type", value: ""});
            o.push({"class": "optionClass", label: "SEP", value: "SEP"});
            //alert(component.find("practiceType"));
            component.find("practiceType").set("v.options", o);
        } else {
            helper.getPracticeTypeData(component);
        }
    },
    displayCibil : function(component, event, helper) {
        
        var data = event.getParam('showCibil') || '';
        var poId =  event.getParam('poId');
        console.log(poId);
        component.set('v.poId',poId);
        if("{!v.isCommunityUsr}" == true)
            component.set('v.cibilURL','/Partner/apex/CibilReportOnPO?id=' + poId);
        else
            component.set('v.cibilURL','/apex/CibilReportOnPO?id=' + poId);
        var cmpTarget = component.find('ModalboxCibil');
        var cmpBack = component.find('ModalbackdropCibil');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
        helper.showHideDiv(component, "ModalboxCibil", true);
    },
    closeModalCibil:function(component,event,helper){    
        var cmpTarget = component.find('ModalboxCibil');
        var cmpBack = component.find('ModalbackdropCibil');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        helper.showHideDiv(component, "ModalboxCibil", false);
    }
})