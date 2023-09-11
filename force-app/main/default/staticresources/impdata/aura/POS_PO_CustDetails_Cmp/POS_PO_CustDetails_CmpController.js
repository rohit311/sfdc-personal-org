({
    //8734:USERSTORY_Disposition to capture response for Partially filled starts
    closeDispositionModal: function(component,event,helper) {
        component.set('v.isDispShow',false);
        
    },
    openDispositionModal: function(component,event,helper) {
        component.set('v.isDispShow',true);
        component.set("v.dispSpinner","true");
    },
  //8734:USERSTORY_Disposition to capture response for Partially filled starts -->
	doInit: function(component, event, helper) {
        
        helper.getHideAadhaarSectionHelper(component);//added for bug id 21851   
        helper.getDegreeType(component);
        // bugId: 18158 E        
        helper.getSpecializationData(component);
        helper.getProfessionTypeData(component);
        helper.getPracticeTypeData(component);
        //window.setTimeout($A.getCallback(function() { helper.getResidentialTypeData(component); }), 5000);
        helper.getResidentialTypeData(component);
        helper.getSalutation(component);
        helper.getExperienceData(component);
       //Bug 24237 S
        helper.getUserData(component);
       //Bug 24237 E
        // Bug 14509 s
       // helper.fetchOfficeAddress(component,helper); 
       // console.log('===mob button visible ==>> +component.get("v.lead'));
	   try {
           helper.setIncSecFieldVisibility(component); // 19995
        } catch (e) {
            console.log('in controller catch --> ', e);
        }
        if(component.get("v.productFlow") === 'RDL')
        	helper.getDegreeData(component);
        // Bug 14509 E
        helper.getResidentialCity(component);
        var poId = component.get("v.poId");
        if(poId){
            helper.getCustomerDetails(component, poId);
            component.set("v.displayExotel",true); // May-2019 Enhancement :-- 2275: USERSTORY_Calling through Exotel  Enhancement start
        }       
        // debugger;
       helper.updateForm(component);
         
         navigator.geolocation.getCurrentPosition(function(position) {
              try {
             	if(position.coords.latitude == null) {
                	helper.showToast(component, "Warning!", "Device Location not found", "warning");
             	}
             }catch(e) {
                 helper.showToast(component, "Exception!", " Device Location not found", "warning");
             }
            },
            function (error) { 
               
                if (error.code == 1){
                  helper.showToast(component, "Warning!", "Please Turn on your Device Location. ", "warning");
                 
//Added by GC for Segmentation V2
   if(poId){
        }else{
    helper.setFamilyHospitalflag(component);
        }
                }
                if (error.code == 3 || error.PERMISSION_DENIED) {
                    helper.showToast(component, "Warning!", "Please Turn on your Device Location. ", "warning");
                }  
            },
        		{
            		maximumAge:0,
                	enableHighAccuracy: false,
            		timeout:5000
        		});
        
	},
    UpdateForm : function(component, event, helper){
//added by Gopika for segmentation v2 
      helper.updateForm(component,component.get("v.po"));
       component.set("v.collegeSearchKeyword", "");
       component.set("v.collegeDoctorSearchKeyword", "");
    },
     sendSms : function(component, event, helper){ 
      helper.sendSms(component);
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
    },//Added for Segementation V2 Bug 23971 by GC s
 hospitalOfConsultancyKeyPress : function(component, event, helper){
        helper.startSearch(component, 'hospital');
    },
    collegeDoctorKeyPressController :  function(component, event, helper){
        console.log('Here inside college dr');
        helper.startSearch(component, 'collegeDoctor');
    },//Added for Segementation V2 Bug 23971 by GC e
    residenceCityKeyPressController: function(component, event, helper){
        helper.searchCity(component);  
    },
    
    permanentCityKeyPressController: function(component, event, helper){
        helper.searchPermanentCity(component);
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
        //Bug 24237 S
        var listOfBranchs = component.get("v.listOfBranch");
        if(listOfBranchs.includes(selectedSource.Branch__r.Name.toUpperCase())){ //.toUpperCase()
            component.set("v.sourcingVaildationFlag","true");
        }
        console.log('selectedSource.PSF_Employee_ID__c'+selectedSource.PSF_Employee_ID__c);
        if(selectedSource.PSF_Employee_ID__c !== undefined){
            component.set("v.SourcingEmpId",selectedSource.PSF_Employee_ID__c);
            console.log("sourcing channel empID"+component.get("v.SourcingEmpId"));
        }
        //Bug 24237 E
        component.set("v.selectedSource" , selectedSource); 
        component.set("v.sourceSearchKeyword", keyword);
        component.set("v.po.Sourcing_Channel__c", selectedSource.Id);
        helper.openCloseSearchResults(component, "source", false);
        component.find("sourceName").set("v.errors", [{message:""}]);
        
        //Auto Populate Branch By rajesh
        var selectedBranch = selectedSource.Branch__r; 
        component.set("v.selectedBranch" , selectedBranch); 
        component.set("v.branchSearchKeyword", selectedBranch.Name);
        component.set("v.lead.SBS_Branch__c", selectedBranch.Id);
        helper.openCloseSearchResults(component, "branch", false);
      },
    selectResidenceCity: function(component, event, helper){
        var index = event.currentTarget.dataset.record; 
     	var selectedResidenceCity = component.get("v.filteredResidenceCities")[index];
        component.set("v.residenceCitySearchKeyword", selectedResidenceCity);
        component.set("v.lead.Resi_City__c", selectedResidenceCity);
        helper.openCloseSearchResults(component, "residenceCity", false);
        helper.copyPermanentAddr(component, event);
    },
    
    selectPermanentCity: function(component, event, helper){
        var index = event.currentTarget.dataset.record; 
     	var selectedPermanentCity = component.get("v.filteredPermanentCities")[index];
        component.set("v.permanentCitySearchKeyword", selectedPermanentCity);
        component.set("v.lead.Per_City__c", selectedPermanentCity);
        helper.openCloseSearchResults(component, "permanentCity", false);
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
    selectCollege: function(component, event, helper){ 
     	var index = event.currentTarget.dataset.record; 
     	var selectedCollege = component.get("v.collegeList")[index]; 
        component.set("v.selectedCollege" , selectedCollege); 
        component.set("v.collegeSearchKeyword", selectedCollege.Name);
        component.set("v.po.Sector_Industry__c", selectedCollege.Id);
        helper.openCloseSearchResults(component, "college", false);
        component.find("collegeName").set("v.errors", [{message:""}]);
    },
     //Added for Segementation V2 Bug 23971 by GC s
     selectCollegeDoctor : function(component,event,helper){
        debugger;
        var index = event.currentTarget.dataset.record; 
     	var selectedCollege = component.get("v.collegeDoctorList")[index]; 
        component.set("v.selectedCollege" , selectedCollege); 
        component.set("v.collegeDoctorSearchKeyword", selectedCollege.Name);
        component.set("v.po.Sector_Industry__c", selectedCollege.Id);
        helper.openCloseSearchResults(component, "collegeDoctor", false);
          },
selectHospitalOfconsultancy : function(component,event,helper){
        debugger;
        var index = event.currentTarget.dataset.record; 
        var selectedCollege = component.get("v.hospitalList")[index]; 
        component.set("v.selectedHospital" , selectedCollege);
         component.set("v.hospitalSearchKeyword", selectedCollege.Name);
        component.set("v.lead.Hospital_of_Consultancy__c", selectedCollege.Id);
        helper.openCloseSearchResults(component, "hospital", false);
          },
     setDoctorFamilyFlag:function(component,event,helper){
        helper.setDoctorFamilyFlag(component);
    },
    //Added for Segementation V2 Bug 23971 by GC e
    grabOffer: function(component, event, helper){
        helper.grabOffer(component, event.target.id);
    },
    submitDetails: function(component, event, helper) {
         
        //helper.fetchOfficeAddress(component,helper);
        debugger;
        var lead = component.get("v.lead");
        console.log('lead --> ' + JSON.stringify(lead));
        debugger;
        var po = component.get("v.po");	//	Bug 15558 - hemant Keni
        if($A.util.isEmpty(lead.FirstName) || $A.util.isEmpty(lead.LastName) || ($A.util.isEmpty(lead.MobilePhone) &&  $A.util.isEmpty(lead.PAN__c))){
            helper.showToast(component, 'Error!', 'Please fill First Name, Last Name and Mobile Number OR PAN before submitting the details.', 'error');
        }
        else if (helper.fetchOfficeAddress(component,helper) && helper.validate(component,helper)){
		     debugger;
             component.set("v.spinnerFlag","true");
            helper.setResidenceAddress(component);
            // Bug 15558 - Hemant Keni - added PO condition in OR of existing offer.
            if(!helper.isRetriggerRequired(component) && (component.get("v.isExistingOffer") || (po && po.Id))){
                helper.createLeadData(component); 
                component.set("v.displayExotel",true); // May-2019 Enhancement :-- 2275: USERSTORY_Calling through Exotel  Enhancement start
            } else {
                helper.checkForExistingOffers(component,helper);
                component.set("v.displayExotel",true); // May-2019 Enhancement :-- 2275: USERSTORY_Calling through Exotel  Enhancement start
            }
        }
        debugger;
       //  component.set("v.spinnerFlag","false");
	},
    
    disableForm: function(component, event, helper){
       helper.disableForm(component);
    },
    
    validatePAN: function(component, event, helper) {
        helper.validatePAN(component);
    },
    
    validatePIN: function(component, event, helper) {
        helper.validatePIN(component);
        helper.copyPermanentAddr(component, event);
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
        helper.copyPermanentAddr(component, event);
    },
    
    // Bug 13675 S - hemant Keni
    validateObligation : function(component, event ,helper){
    	helper.validateObligation(component);
    },
    
    // Bug 13675 E - hemant Keni
    wait: function(component, event, helper){
        helper.showHideDiv(component, "alertDialog", false);
        component.set("v.spinnerFlag","true");
        //helper.setTimeout(helper.showSpinner, helper, 1, component);
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
    
    //POS YK s
    setDefaultValues : function(component, event, helper)
    {
   		//var docType = event.getSource().getLocalId();
       	//console.log('=====>> '+docType);
       	// var id2 = event.target.getAttribute('id');
       	// console.log('=====>> '+id2);
        var auraId = event.getSource().getLocalId();
        if(auraId == "salutation")
        {
            var salutation = event.getSource().get("v.value");
            console.log('----salutation-->> '+salutation);
            var lead = component.get("v.lead");
            if(salutation == 'Mr.')
                lead.Gender__c = 'Male';  
            else
                lead.Gender__c = 'Female';
            component.set("v.lead", lead);
        }
    },
     // May-2019 Enhancement :-- 2275: USERSTORY_Calling through Exotel  Enhancement start
	openActionWindow : function(component, event, helper) {
	     var lead = component.get("v.lead");
		 var url = lead.CallRecodingURL__c;
		 window.open(url);
	},
    // May-2019 Enhancement :-- 2275: USERSTORY_Calling through Exotel  Enhancement End
     //Bug 24927 S 
    EnableAddressFields : function(component, event, helper)
    {
    	helper.EnableAddressFields(component, event);
	},
    //Bug 24927 E
    copyPermaAddr : function(component, event, helper)
    {
    	helper.copyPermanentAddr(component, event);
	},
    
    validatePermanentAddress: function(component, event, helper){
        helper.validateAddress(component);
    },
    
    validatePermanentPIN : function(component, event, helper) {
        helper.validatePIN(component);
        //POS YK
        helper.copyPermanentAddr(component, event);
    },
    //POS YK e
 
    setPanValue : function(component, event, helper) {
        var pan = component.get("v.lead").PAN__c;
        component.set("v.oldPanNumber", pan);
    },
    
    //POS YK s
    //16621 : Changed by Rohan: Moved to helper for RSA saving during lead creation
    setRSAValue : function(component, event, helper){
        //console.log('======VJrsa '+component.get("v.rsaFlag"));
        helper.setRSAValue(component);
    },
    //Added for Segementation V2 Bug 23971 by GC
    setRunningHospitalFlag: function(component, event, helper){
        helper.setRunningHospitalFlag(component);
    },
     validateDORWithDOB : function(component,event,helper){
         helper.validateDORWithDOB(component);
    
     },
        //POS YK e
    calculateVintage : function(component,event,helper){
        var s = component.get("v.po.COP_Date__c");
	    var copDate = new Date(component.get("v.po.COP_Date__c")).getTime();
        var dtToday = (new Date()).getTime();
       
        
        if(dtToday < copDate){
            component.set("v.po.COP_Date__c","");
        	return;
        }
      
        if(component.get("v.po.COP_Date__c")){
            
           var DifMs = Date.now() - Date.parse(component.get("v.po.COP_Date__c"));
           var ExpDate = new Date(DifMs); 
           component.set("v.po.Total_Employment_Vintage__c",Math.abs(ExpDate.getUTCFullYear() - 1970));
          
        }else if(component.find("practiceExperience")){
            		//debugger;
                  component.set("v.po.Total_Employment_Vintage__c",component.find("practiceExperience").get("v.value")); 
           
        }
     
    },
    openCkycModel: function(component, event, helper) { // Bug Id : 24716
        var ckycFlow = new Object();
        ckycFlow["flowtype"] = "detail";
        ckycFlow["object"] = "Product_Offerings__c";
        ckycFlow["resource"] = "Opportunity_CkycConfig"; // newly added
        if(!$A.util.isEmpty(component.get("v.lead.MobilePhone"))) {
            console.log('sales user entered mob --> ' + component.get("v.lead.MobilePhone"));
            ckycFlow["mobNo"] = component.get("v.lead.MobilePhone");
        }
        console.log('sales user entered pan --> ' + component.get("v.lead.PAN__c"));
        if(!$A.util.isEmpty(component.get("v.lead.PAN__c"))) {
            console.log('sales user entered mob --> ' + component.get("v.lead.PAN__c"));
            ckycFlow["panNo"] = component.get("v.lead.PAN__c");
        }
        component.set("v.ckycFlow", ckycFlow);
        component.set("v.isShow", true);
    },
    closeCkycModel: function(component, event, helper) { // Bug Id : 24716
        component.set("v.isShow", false);
    },
    setCkyc : function(component, event, helper) { // Bug Id : 24716
        helper.setCkycFields(component, event);
    },
    setParentalData : function(component, event, helper) {//US : 2702
        debugger;
        console.log('setParentalData here --> ');
        try {
            var resp = event.getParam("ccParentalData");
            if (!$A.util.isEmpty(resp) && !$A.util.isEmpty(component.get("v.lead"))) {
                console.log('setParentalData here --> ', resp);
                if (!$A.util.isEmpty(resp["Mother_First_Name__c"])) component.set("v.lead.Mother_First_Name__c",resp["Mother_First_Name__c"]);
                if (!$A.util.isEmpty(resp["Mother_Last_Name__c"])) component.set("v.lead.Mother_Last_Name__c",resp["Mother_Last_Name__c"]);
                if (!$A.util.isEmpty(resp["Mother_Middle_Name__c"])) component.set("v.lead.Mother_Middle_Name__c",resp["Mother_Middle_Name__c"]);
                if (!$A.util.isEmpty(resp["Father_Spouse_First_Name__c"])) component.set("v.lead.Father_Spouse_First_Name__c",resp["Father_Spouse_First_Name__c"]);
                if (!$A.util.isEmpty(resp["Father_Spouse_Last_Name__c"])) component.set("v.lead.Father_Spouse_Last_Name__c",resp["Father_Spouse_Last_Name__c"]);
                if (!$A.util.isEmpty(resp["Father_Spouse_Middle_Name__c"])) component.set("v.lead.Father_Spouse_Middle_Name__c",resp["Father_Spouse_Middle_Name__c"]);
                console.log('value in event --> ', component.get("v.lead.Mother_First_Name__c"));
            }
        } catch (e) {
            console.log('exception in ShareParentalData event from CC --> ', e);
        }
    },
	setccData:function(component, event, helper) {//US : 2702
        debugger;
        console.log('setccData here --> ');
        try {
            var resp = event.getParam("ccData");
            if (!$A.util.isEmpty(resp) && !$A.util.isEmpty(component.get("v.lead"))) {
               console.log('resp --> ', resp);
               component.set("v.lead.CC_Disposition__c",resp);
            } else {
            }
        } catch (e) {
            console.log('exception in CC_Data event from CC --> ', e);
        }
    },
    setSearch : function(component, event, helper) { // US : 13265
        try {
            helper.setSearchCkyc(component, event);
        } catch (e) {
            console.log('serach event --> ', e);
        }
    }
})