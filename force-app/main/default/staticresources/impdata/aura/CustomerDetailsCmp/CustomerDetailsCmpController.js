({
    handleSave : function(component, event, helper) {
        
        var panInp = component.find("CustPAN");
        var mobInp = component.find("mobNum");
        var pinInp = component.find("custPin");
        var emailinp = component.find("emailinp");
        var error = false;
        //alert(component.get("v.customer.Last_Name__c") && component.get("v.customer.Mobile__c") && component.get("v.customer.Customer_Email__c") && component.get("v.customer.PAN__c"));
        if(component.get("v.customer.Last_Name__c") && component.get("v.customer.Mobile__c") && component.get("v.customer.Customer_Email__c") && component.get("v.customer.PAN__c") && component.get("v.customer.Address1_New__c") && component.get("v.customer.Address2_New__c") && component.get("v.customer.GENDER__c") && component.get("v.customer.State_New__c") && component.get("v.customer.City_New__c") && component.get("v.customer.Pin_Code_New__c") && component.get("v.customer.DOB__c")){
            if(!$A.util.isEmpty(component.get("v.customer.PAN__c"))&& (!panInp.get("v.validity").valid)){
                panInp.showHelpMessageIfInvalid();
                error = true;
            }
            
            if(!$A.util.isEmpty(component.get("v.customer.Mobile__c"))&& (!mobInp.get("v.validity").valid)){
                mobInp.showHelpMessageIfInvalid();
                error = true;
            }
            if(!$A.util.isEmpty(component.get("v.customer.Customer_Email__c")) && (!emailinp.get("v.validity").valid)){
                emailinp.showHelpMessageIfInvalid();        
                error = true;        
            }
          
            if(!$A.util.isEmpty(component.get("v.customer.Pin_Code_New__c")) && (!pinInp.get("v.validity").valid)){
                pinInp.showHelpMessageIfInvalid();        
                error = true;        
            }
            if(error == false){                                            
                component.set("v.Spinner",true);                             
                helper.saveLeadHelper(component, event);
            }
            
        }else{
            helper.displayToastMessage(component,event,'Error','Please enter mandatory fields ','error');
            
        }        
    },
    checkCustomer : function(component, event, helper) {
        var params = event.getParam('arguments');
        //save parameters to pass for comparision
        component.set("v.mobileNo",component.get("v.customer").Mobile__c);
        component.set("v.panStr",component.get("v.customer").PAN__c);
        
        component.find("saveButtonId").set("v.disabled", false);
        
        if(params){
            var isNew = params.isNew;
            console.log('is new '+isNew);
            
            if(component.get("v.customer").First_Name__c){
                component.find("firstName").set("v.disabled", true);                
            }
            else{
                component.find("firstName").set("v.disabled", false); 
                
            }
            
            if(component.get("v.customer").DOB__c){
                component.find("Custdob").set("v.disabled", true);                
            }
            else{
                component.find("Custdob").set("v.disabled", false); 
                
            }
            if(component.get("v.customer").GENDER__c){
                component.find("Custgender").set("v.disabled", true);                
            }
            else{
                component.find("Custgender").set("v.disabled", false); 
                
            }
            
            //CR 24405 start
            if(component.get("v.customer").PAN__c){
                component.find("CustPAN").set("v.disabled", true);                
            }
            else{
                component.find("CustPAN").set("v.disabled", false); 
                
            }
            //CR 24405 stop
            
            if(isNew){
                component.set("v.customer",new Object());
                console.log(component.get("v.customer"));
                
                
                component.find("Custdob").set("v.disabled", false);
                component.find("Custgender").set("v.disabled", false);
                component.find("CustPAN").set("v.disabled", false);
            }
            else{              
              
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
            for(var i=0;i<cityList.length;i++){
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
        var customer = component.get("v.customer");
        customer.State_New__c = selectedCity.state;
        customer.City_New__c = selectedCity.city;
        component.set("v.customer",customer);
        helper.openCloseSearchResults(component, 'city', false);    
    },
    /*City CR e*/
    updateCity : function (component, event, helper) {
        var cityInp = component.find("CustCity");
        	cityInp.focus();
        console.log('in city update');
    },
    //CR not given start
    handleCibilDone : function (component, event, helper) {
        component.find("CustPAN").set("v.disabled", true);
    },
     fetchDemogData : function (component, event, helper) {
      
      
        if(component.get('v.customer.Pin_Code_New__c') && component.find("custPin") && component.find("custPin").get("v.validity").valid){
             console.log('here '+component.get('v.customer.Pin_Code_New__c')); 
             helper.fetchCityState(component, event);
        }
        
    },
    //CR not given stop
})