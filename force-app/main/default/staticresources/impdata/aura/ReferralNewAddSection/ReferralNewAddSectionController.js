({
    validateReferralSection : function(component, event,helper){
        var name=component.get("v.refName"); 
        var mobile=component.get("v.refMobile"); 
        var city= component.get("v.City");
        var empl=component.get("v.employer"); 
        var isValid = false; 
          var leadList=component.get("v.leadList"); 
         var phone=component.find("refMobile").get("v.value");
        
        if(leadList.length>=2 && leadList!=null){
            for(var i=0; i<leadList.length-1;i++){
                console.log('length '+leadList.length+' 1 '+leadList[i].Customer_Mobile__c+' 2 '+phone );
                if(leadList[i].Customer_Mobile__c==phone){
                   return isValid;
                }
            }
        }
        
        if(!$A.util.isEmpty("name") && !$A.util.isEmpty("mobile") && !$A.util.isEmpty("city") && !$A.util.isEmpty("empl")){
            
            if(component.find("refName").get("v.validity").valid && component.find("refMobile").get("v.validity").valid && component.find("City").get("v.value")!=='' && component.find("employer").get("v.value")!='' && helper.isEmployerSelected(component,"Employer")   && helper.isCitySelected(component,"City") ){
                isValid = true;
                return isValid;
            }
            if(helper.isEmployerSelected(component,"Employer")==false){
                
                $A.util.addClass(component.find('employer'), 'slds-has-error');            
            }
            return isValid;
        }
        
        return isValid;
    },
    empKeyPressController: function (component, event, helper) {
        component.set("v.isEmployerSelected",false);
        helper.startSearch(component, 'Employer');
    },
    areaKeyPressController: function (component, event, helper) {
       console.log('isKeyPressed start '+component.get("v.oldAreaKeywordCity") +'  flag '+ component.get("v.isKeyPressed")+' component.find("City").get("v.value") '+component.get("v.CitySearchKeyword"));
        component.set("v.isKeyPressed",false);
        if(component.get("v.oldAreaKeywordCity") !=component.get("v.CitySearchKeyword")){
               component.set("v.isKeyPressed",true);
      		 
        }
        console.log('isKeyPressed end '+component.get("v.isKeyPressed"));
    
     if(component.get("v.isKeyPressed")){
          console.log('isKeyPressed true'); 
    		 component.set("v.isCitySelected",false);
       		  helper.startSearch(component, 'City');
       }
    },
    selectEmployer: function (component, event, helper) {
        var index = event.currentTarget.dataset.record;
        var selectedEmployer = component.get("v.EmployerList")[index];
        var keyword = selectedEmployer.Name;
        component.set("v.selectedEmployer", keyword);
        component.set("v.EmployerSearchKeyword", keyword);
        component.set("v.lead.Employer__c", selectedEmployer.Id);
        helper.openCloseSearchResults(component, "Employer", false);
        component.set("v.isEmployerSelected",true);
        
        component.find("employer").set("v.errors", [{
            message: ""
        }
                                                   ]);
        $A.util.removeClass(component.find('employer'), 'slds-has-error');            
        
    },
    selectArea: function (component, event, helper) {
        var index = event.currentTarget.dataset.record;
        var selectedArea = component.get("v.CityList")[index];
        var keyword = selectedArea.Name;
        
        component.set("v.selectedArea", selectedArea);
        component.set("v.CitySearchKeyword", keyword);
        component.set("v.lead.Resi_City__c",keyword);
        
        helper.openCloseSearchResults(component, "City", false);
        component.set("v.isCitySelected",true);
        
        component.find("City").set("v.errors", [{
            message: ""
        }
                                               ]);
    },
    doInit : function(component, event, helper){
        
        component.set("v.CitySearchKeyword",component.get("v.User").City__c);
        component.set("v.oldAreaKeywordCity",component.get("v.User").City__c);
        component.set("v.lead.Resi_City__c",component.get("v.User").City__c);
     
        var leadList=component.get("v.leadList"); 
        
      
    }
})