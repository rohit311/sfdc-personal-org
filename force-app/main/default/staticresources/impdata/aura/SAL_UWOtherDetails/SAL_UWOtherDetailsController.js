({
	doInit: function(component, event, helper) {
        helper.showhidespinner(component,event,true);
         /* CR 22307 s */
         var stage = component.get("v.stageName");
         if(stage == 'Underwriting' || component.get("v.oppObj.Consider_for_Re_Appraisal__c") == true || stage == 'Re-Appraise- Loan amount' || stage == 'Re-Appraise- IRR' || stage == 'Re-Appraise- Reject Case' || stage == 'Re-Appraise- Tenor')
         {
             component.set("v.displayReadOnly",false);
         } 
         else{
            component.set("v.displayReadOnly",true);
         } /* CR 22307 e */
		 
        helper.getCkycDetails(component,event);
		 // Bug 23064 start
       if(stage == 'Underwriting' && component.get("v.salesprofilecheck") == true)
            {
            component.set("v.displayReadOnly",true);
             
            } 
        // Bug 23064 stop
    },
    onPicklistChange: function(component, event, helper) {
        var createContact = component.get('v.contObj');
        if(createContact.Residence_Type__c == 'Owned by Self/Spouse' 
           || createContact.Residence_Type__c == 'Owned by Parent/Sibling')
            component.set('v.isOwnedTrue',false);
        else      
            component.set('v.isOwnedTrue',true);
    },
    saveData: function(component,event,helper)
    {
        var isvalid = true;
        var isPermValid = true;
        var list = [];
        list = ["resi_type", "month_at_resi","addMatchPrevious","addMatchekyc","addMatchPerfios"];
        
        if((component.get("v.contObj.Residence_Type__c") != 'Owned by Self/Spouse') && 
           (component.get("v.contObj.Residence_Type__c") != 'Owned by Parent/Sibling'))
        {
            list.push('Permanent_PinCode');
            list.push('perm_address');
            list.push('perm_address2');
            list.push('perm_address3');
            
        }
        /*City CR s*/
        if(!component.get("v.validCity") && !$A.util.isEmpty(component.get("v.contObj.Residence_Type__c")) && component.get("v.contObj.Residence_Type__c") != 'Owned by Self/Spouse' && 
           component.get("v.contObj.Residence_Type__c") != 'Owned by Parent/Sibling'){
            helper.displayToastMessage(component,event,'Error','Please enter valid Permanent City','error');  
        }
        else{
            /*City CR e*/
            for (var i = 0; i < list.length; i++) {
                console.log('list[i]>>' + list[i]);
                console.log(component.find(list[i]));
                if (component.find(list[i]) && !component.find(list[i]).get("v.validity").valid)
                {
                    isvalid = false;
                    component.find(list[i]).showHelpMessageIfInvalid();
                }
            }
            
            if(isvalid && isPermValid)
            {
                helper.showhidespinner(component,event,true);
                helper.saveCKYCData(component,event);  
            }
            else
            {
                helper.displayToastMessage(component,event,'Error','Please fill all required data ','error');
            }
        }
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
        var contObj = component.get("v.contObj");
        contObj.Permanent_State__c = selectedCity.state;
        contObj.Permanant_City__c = selectedCity.city;
        component.set("v.contObj",contObj);
        helper.openCloseSearchResults(component, 'city', false);    
    },
    /*City CR e*/
})