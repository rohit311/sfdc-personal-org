({
    search : function(component, event, helper) {
        console.log('here!!!');
       
            if($A.util.isEmpty(component.get("v.mobileNo")) || $A.util.isEmpty(component.get("v.panStr")))
            {
                console.log('here!!!1');
                helper.displayToastMessage(component,event,'Error','Enter mobile Number and PAN to search ','error');            
            }
            else{
                var panId = component.find("panInput");
                var MobileID = component.find("mobInput");
                console.log('here1');
                if(!$A.util.isEmpty(component.get("v.mobileNo")) && MobileID.get("v.validity").valid){
                    console.log('here1');
                    component.set("v.Spinner",true);
                    helper.searchCustomer(component, event);
                }            
                else if(!$A.util.isEmpty(component.get("v.panStr")) && panId.get("v.validity").valid){
                    console.log('here2');
                    component.set("v.Spinner",true);
                    helper.searchCustomer(component, event);
                }
                    else{
                        if(!MobileID.get("v.validity").valid){
                            MobileID.showHelpMessageIfInvalid(); 
                        }
                        else if(!panId.get("v.validity").valid){
                            panId.showHelpMessageIfInvalid(); 
                        }
                    }
                
            }    
        
    },
    clearSearch : function(component, event, helper) {
        //component.set("v.firstName","");	
        //component.set("v.LastName","");
        component.set("v.mobileNo","");
        component.set("v.panStr","");
        component.set("v.customerList",[]);
        component.set("v.isSearched",false);
        var shareinfo = component.getEvent("shareSearchInfo");
        if(shareinfo){
            shareinfo.setParams({"custObj":null,"isNew":true });
            shareinfo.fire();
        }
        //clear search results component
    },
    closeErrorPanel : function(component, event, helper) {
        component.set("v.isError", false);
        
    },
    handleShareEvent : function(component, event, helper) {
        
        var customer = event.getParam("custObj"); 
        console.log(event.getParam("custObj"));
        component.set("v.customer",customer);
    },
    handleSubmit : function(component, event, helper) {
      
        var shareinfo = component.getEvent("shareSearchInfo");
        var isNew =false;      
        
        console.log('isNew '+component.get("v.customer"));
        if(shareinfo){
            shareinfo.setParams({"custObj":component.get("v.customer"),"isNew":false });
            shareinfo.fire();
        }
       //helper.displayToastMessage(component,event,'Info','Please click on Customer Details section','info');
    },
    handleNewCust : function(component, event, helper) {
       
        var customer = new Object();
        customer.First_Name__c = component.get("v.firstName");
        customer.Last_Name__c = component.get("v.LastName");
        customer.Mobile__c = component.get("v.mobileNo");
        customer.PAN__c = component.get("v.panStr");
        
        component.set("v.customer",customer);
        var shareinfo = component.getEvent("shareSearchInfo");
        if(shareinfo){
            shareinfo.setParams({"custObj":component.get("v.customer"),"isNew":true });
            shareinfo.fire();
        }
        
        //helper.displayToastMessage(component,event,'Info','Please enter Customer Details','info');
    },
    doInit : function(component, event, helper) {
        
        
    },
})