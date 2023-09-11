({
	doInit: function(component, event, helper) {
        var loanId = component.get('v.oppId');
        console.log('loanId++'+loanId);
         /* CR 22307 s */
        var stage = component.get("v.stageName");
        if(component.get("v.isUnderwitercmp") == true){
            if(stage == 'Underwriting' || component.get("v.loan.Consider_for_Re_Appraisal__c") == true || stage == 'Re-Appraise- Loan amount' || stage == 'Re-Appraise- IRR' || stage == 'Re-Appraise- Reject Case' || stage == 'Re-Appraise- Tenor')
            {
                component.set("v.displayReadOnly",false);
            } 
            else
                component.set("v.displayReadOnly",true);
        }
        if(component.get("v.stageName") != 'DSA/PSF Login' && component.get("v.isUnderwitercmp") == false) {
            component.set("v.displayReadOnly",true);
            
        }
        /* CR 22307 e */
		// Bug 23064 start
       
        if(stage == 'Underwriting' && component.get("v.salesprofilecheck") == true)
            {
            component.set("v.displayReadOnly",true);
             
            } 
        // Bug 23064 stop
        helper.loadAllData(component, event,loanId);
        //added for bug id 21851 start
        helper.getHideAadhaarSectionHelper(component);
        //added for 21851 end
    },
    initiateKYCForm : function(component, event, helper){ 
        
       component.set("v.eKycObj", event.getParam("kyc"));
       if (!$A.util.isEmpty(component.get("v.eKycObj")) && !$A.util.isEmpty(component.get("v.eKycObj.eKYC_First_Name__c")))
           component.set('v.disableAadhaar',false);
       else
           	component.set('v.disableAadhaar',true);
    },
    callPANBre :function(component, event, helper) {
        if(!component.get("v.isUnderwitercmp"))
        	helper.callPANBre(component,event);
    },
    pinChange : function(component, event, helper){
        helper.pinChangeHelper(component);
    },
    selectArea: function (component, event, helper) {
        component.set("v.ValidAreaLocality",true);
        var index = event.currentTarget.dataset.record;
        var selectedArea = component.get("v.areaList")[index];
        console.log(selectedArea);
        var keyword = selectedArea.Name;
        
        console.log('keyword>>' + selectedArea);
        component.set("v.selectedArea", selectedArea);
        component.set("v.areaSearchKeyword", keyword);
        component.set("v.accObj.Area_Locality__c", selectedArea.Id);
        console.log('pkaraea'+component.get("v.accObj.Area_Locality__c"));
        //component.set("v.account.Current_Residence_Address1__c",  selectedArea.Name);
		//component.set("v.account.Area_Locality__r.Name", selectedArea.Name);
        //console.log('Area loc master'+component.get("v.account").Area_Locality__r.Name) ;
        helper.openCloseSearchResults(component, "area", false);
        component.find("areaName").set("v.errors", [{
            message: ""
        }
                                                     ]);
    },
    changePOaddress: function(component, event, helper) {
        component.set("v.AddressFrom","POAddress");
        helper.changePOaddress(component,event);
    },
    areaKeyPressController: function (component, event, helper) {
        console.log('insourcekey');
        component.set("v.ValidAreaLocality",false);
        helper.startSearch(component, 'area');
    },
    changeAadhaaraddress: function(component, event, helper) {
        component.set("v.AddressFrom","AadhaarAddress");
        helper.changeAadhaaraddress(component,event);
    },
    changeNewaddress: function(component, event, helper) {
         component.set("v.AddressFrom","NewAddress");
        helper.changeNewaddress(component,event);
    },
    saveContactDetails: function(component, event, helper) {
        var isvalid = true;
        var list = [];
        list = ["resAdd","resPin","resAdd2","resAdd3","areaLoc"];/*resAdd2 and resAdd3 added for Bug 18914*/
        
        for (var i = 0; i < list.length; i++) {
            if (component.find(list[i]) && !component.find(list[i]).get("v.validity").valid)
            {
                isvalid = false;
                component.find(list[i]).showHelpMessageIfInvalid();
            }
        }
        /*if($A.util.isEmpty(component.get("v.areaSearchKeyword")))
        {
            isvalid = false;
            component.find("areaName").set("v.errors", [{
                message: "Please Enter Value"
            }
                                                         ]);
        }*/
        /*City CR s*/
        if(!component.get("v.validCity"))
        {
            isvalid = false;
            helper.displayToastMessage(component,event,'Error','Please select valid city ','error');
        }
        /*City CR e*/
        else if(isvalid)
        {
            helper.showhidespinner(component,event,true);
            helper.saveContactDetails(component,event);
        }
        else
        {
           helper.displayToastMessage(component,event,'Error','Please fill all required data ','error');
        }        
    },
    retriggerDedupe: function(component, event, helper) {
        helper.showhidespinner(component, event,true);
        helper.reTriggerDedupeHelper(component,event);
    },
    /*City CR s*/
    cityKeyPressController: function (component, event, helper) {
    	component.set("v.validCity",false);  
        var finalCity = [];
        var cityList = component.get("v.cityList");
        var keyword = component.get("v.citySearchKeyword");
        if (keyword.length > 2){
            for(var i in cityList){
                if(cityList[i].city.toUpperCase().startsWith(keyword.toUpperCase()))
                    finalCity.push(cityList[i]);
            }  
            helper.openCloseSearchResults(component, 'city', true); 
        }
        else if (keyword.length <= 2) {
        	helper.openCloseSearchResults(component, 'city', false);    
        }
        console.log('citylist'+finalCity.length);
        component.set("v.finalCity",finalCity);
    },
    selectCity: function (component, event, helper) {
    	component.set("v.validCity",true);
        var index = event.currentTarget.dataset.record;
        var selectedCity = component.get("v.finalCity")[index];
        var keyword = selectedCity.city;
        console.log('keyword>>' + keyword);
        component.set("v.selectedCity", selectedCity);
        component.set("v.citySearchKeyword", keyword);
        var conObj = component.get("v.conObj");
        conObj.State__c = selectedCity.state;
        conObj.Residence_City__c = selectedCity.city;
        component.set("v.conObj",conObj);
        helper.openCloseSearchResults(component, 'city', false);    
    },
    /*City CR e*/
    /*SAL 2.0 CR's s*/
    retriggerCIBIL: function(component, event, helper) {
        helper.retriggerCIBIL(component,event);
    },
    /*SAL 2.0 CR's e*/

})