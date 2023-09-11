({
	doInit : function(component, event, helper) {
         /* CR 22307 s */
        var stage = component.get("v.stageName");
		if(component.get("v.isUWCheck") == true){
			if(stage == 'Underwriting' || component.get("v.empOpp.Consider_for_Re_Appraisal__c") == true || stage == 'Re-Appraise- Loan amount' || stage == 'Re-Appraise- IRR' || stage == 'Re-Appraise- Reject Case' || stage == 'Re-Appraise- Tenor')
			{
			component.set("v.displayReadOnly",false);
			} 
			else{
				component.set("v.displayReadOnly",true);
			  
			}
			 
		}
	   if(component.get("v.stageName") != 'DSA/PSF Login' && component.get("v.isUWCheck") == false) {
		 component.set("v.displayReadOnly",true);
	    }
       /* CR 22307 e */
	    // Bug 23064 start
       if(stage == 'Underwriting' && component.get("v.salesprofilecheck") == true)
            {
            component.set("v.displayReadOnly",true);
             
            } 
        // Bug 23064 stop
        if(!component.get("v.isUWCheck"))
         helper.showhidespinner(component,event,true);
        
       helper.fetchData(component, event);
        console.log('rohit '+component.get("v.empAccount").Id+'>>isfromCredit>>'+component.get("v.isfromCredit"));
      
	},
    saveinfo : function(component, event, helper) {
        var empAccount= component.get("v.empAccount");
        var empContact = component.get("v.empContact");
         var isvalid = true;
         var list = [];
          list = [
             "designationName", "qualificationName", "institutionName", "totalWorkExpYrs", "accTotalExpMonths",
            "currWorkExpYrs", "currWorkExpMon","occupation_type","office_address","office_address2","office_address3","office_pincode","office_tele"];  
        
        for (var i = 0; i < list.length; i++) {
            console.log('list[i]>>' + list[i]);
            console.log(component.find(list[i]));
            if (component.find(list[i]) && !component.find(list[i]).get("v.validity").valid)
            {
                isvalid = false;
                component.find(list[i]).showHelpMessageIfInvalid();
            }
        }
     /*if(component.get("v.isUWCheck") && $A.util.isEmpty(component.get("v.areaSearchKeyword")))
        {
            isvalid = false;
            component.find("areaName").set("v.errors", [{
                message: "Please Enter Value"
            }
                                                         ]);
        } commented for 2.0 CR*/ 
         if(!isvalid)
        {
            helper.displayToastMessage(component,event,'Error','Please fill all required data ','error');
            
        }else if(parseInt(empAccount.Total_Work_Experience_Yrs__c) <parseInt(empAccount.Current_experiance_in_Years__c) || ((parseInt(empAccount.Total_Work_Experience_Yrs__c) == parseInt(empAccount.Current_experiance_in_Years__c)) && parseInt(empAccount.Total_Work_Experience_Months__c) <parseInt(empAccount.Current_experiance_in_Month__c))){
        	helper.displayToastMessage(component,event,'Error','Current experience cannot be greater than total experience !','error');
        }
        /*City CR s*/
        else if(!component.get("v.validCity")){
            helper.displayToastMessage(component,event,'Error','Please enter valid City','error');  
        }
        /*City CR e*/
        else
        {
            helper.showhidespinner(component,event,true);
            helper.saveData(component, event);  
        }
	},
    closeParentToast : function(component, event, helper){
      var eventId= event.getSource().getLocalId();
        console.log('robin '+eventId);
        if(eventId == "SuccessButton"){
        	helper.closeParentToastHelper('parentSuccessToastEmp','parentsuccessMsgEmp');    
        }  
        else if(eventId == "errorButton"){
            helper.closeParentToastHelper('parentErrorToastEmp','parentErrorMsgEmp');
        }
        else if(eventId == "infoButton"){
            helper.closeParentToastHelper('parentInfoToastEmp','parentInfoMsgEmp');    
        }
    },
    /* CR start */
    areaKeyPressController: function (component, event, helper) {
        console.log('insourcekey');
        helper.startSearch(component, 'area');
    },
     selectArea: function (component, event, helper) {
        var index = event.currentTarget.dataset.record;
        var selectedArea = component.get("v.areaList")[index];
        console.log(selectedArea);
        var keyword = selectedArea.Name;
        
        console.log('keyword>>' + selectedArea);
        component.set("v.selectedArea", selectedArea);
        component.set("v.areaSearchKeyword", keyword);
        component.set("v.accObj.Area_Locality__c", selectedArea.Id);
        component.set("v.accObj.Current_Residence_Address1__c",  selectedArea.Name);
        helper.openCloseSearchResults(component, "area", false);
        component.find("areaName").set("v.errors", [{
            message: ""
        }
                                                     ]);
    },
    /*City CR s*/
    cityKeyPressController: function (component, event, helper) {
     
    	component.set("v.validCity",false);  
        var finalCity = [];
        var cityList = component.get("v.cityList");
        var keyword = component.get("v.citySearchKeyword");
        //alert('cityList'+cityList[i].city);
        
        if (keyword.length > 2){
            for(var i in cityList){
               //Below if Added for RSL issue Bug 25061
                if(cityList[i].city && !$A.util.isEmpty(cityList[i].city) && cityList[i].city != 'Undefined'){
                     if(cityList[i].city.toUpperCase().startsWith(keyword.toUpperCase()))
                      finalCity.push(cityList[i]);
                }
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
        var empContact = component.get("v.empContact");
        empContact.Office_State__c = selectedCity.state;
        empContact.Office_City__c = selectedCity.city;
        component.set("v.empContact",empContact);
        helper.openCloseSearchResults(component, 'city', false);    
    },
    /*City CR e*/
})