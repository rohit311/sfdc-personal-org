({
    onInit : function(component, event, helper) 
    {
        var utility = component.find("toastCmp");
        helper.getChrgBifurDetails(component);
        var oppId = component.get("v.oId");
        if(oppId)
        {
            helper.fetchFees(component, event, helper);
        }
        else{
            utility.showToast('Error!', 'Something went wrong. Please contact your administrator!' , 'error');
        }
        helper.isChargesIntegration(component);
    },
    saveFeesAndCharges : function(component, event, helper)
    {
		helper.saveFees(component, event, helper);
    },
    
    fetchChargesAPI : function(component, event, helper)
    {
        var utility = component.find("toastCmp");
        component.set("v.isProcessing", true);
        helper.executeApex(component,"callChargesAPI",{ requestOpp : JSON.stringify(component.get("v.opp")) },
                           function(error,result){
                               var response = JSON.parse(result);
                               component.set("v.isProcessing", false);
                               if(!error){
                                   if(response.result != "FAILED")
                                   {
                                       component.set("v.lFnC" , response);
                                       helper.segregate(component);
                                       utility.showToast('Success!', 'Fees and Charges fetched successfully!' , 'success');
                                       helper.saveFees(component, event, helper);
                                   }
                                   else
                                   {
                                       utility.showToast('Error!', 'Not able to fetch charges at this moment.Please contact your administrator!' , 'error');                                       
                                   }
                               }
                               else
                               {
                                   utility.showToast('Error!', 'Something went wrong. Please contact your administrator!' , 'error');
                                   if (error[0] && error[0].message) {
                                       console.log("Error message: " +errors[0].message);
                                   }
                                   else{
                                       console.log("unknown error");
                                   }
                               }
                               
                           });
    },
    
    addCharges : function(component, event, helper)
    {
        component.set("v.newFlag","true");
        var charge = new Object();
        charge.Status__c="-- None --";
        var fncNewList = component.get("v.lFnCNew");
        fncNewList.push(charge);
        component.set("v.lFnCNew",fncNewList);
    },
    
    cancelCharges : function(component, event, helper)
    {
        var newList = component.get("v.lFnCNew");
        newList.splice(-1,1);
        component.set("v.lFnCNew",newList);
        if(newList.length==0)
            component.set("v.newFlag","false");
    },
    
    
    handleToggle: function(cmp, evt, helper)
    { //Added function for Bug 20391 : Bug 22065 : Expand and Collapse functionality
        try{
            var ctarget = evt.currentTarget;
            var id_str = ctarget.dataset.value;
            
            var myMap = cmp.get("v.chargeTypes");
            myMap[id_str] = !myMap[id_str] ;
            cmp.set("v.chargeTypes", myMap);            
        }catch(e){console.log(e);}        
    }, 
})