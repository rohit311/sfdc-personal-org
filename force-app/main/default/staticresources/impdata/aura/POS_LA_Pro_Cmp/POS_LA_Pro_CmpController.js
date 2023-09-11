({
    doInit: function(component, event, helper){
        helper.callFetchData(component, event);
        helper.assignDefaultToPassInsuranceListEvt(component);
        // Bug 23556 S
        helper.getUserInfo(component);
        // Bug 23556 E
        
    },
    
    
	Navigate: function(component, event, helper) {
		component.set("v.TabId",event.getParam("TabId"));
    },
   	tabSelected: function(component,event,helper) {
		console.log(component.get("v.TabId"));
        console.log('====>> '+JSON.stringify(component.get("v.insuranceListParent")));
        if(component.get("v.TabId") == 'Insurance' && (component.get("v.accountObj").Is_Commercial_Data_Saved__c != true))
        {
            component.set("v.TabId", "Commercial");
            helper.showToast(component, 'Info', 'Kindly save Commercial details first.', 'info');
        }
         
         
       	if(component.get("v.TabId") == 'Fees')
        {
            if (component.get("v.oppoObj").StageName != 'Branch Ops' && component.get("v.oppoObj").StageName != 'Moved To Finnone') 
            	helper.showToast(component, 'Info', 'Please click on Fetch Charges if any Insurance is Added/Edited!', 'info');
        }
     
       if(component.get("v.TabId") == 'Disbursal' && (component.get("v.feesNChargesListParent") == undefined || component.get("v.feesNChargesListParent").length == undefined || component.get("v.feesNChargesListParent").length < 1))
        {
            console.log('inside disbursal tab');
            component.set("v.TabId", "Fees");
            helper.showToast(component, 'Info', 'Please add Fees and Charges first!', 'info');
        }
       else if(component.get("v.TabId") == 'Disbursal')
        {
             console.log('inside disbursal tab commerical');
            //6863 Validations before triggering E-Agreement S
        helper.callCommercialDetails(component,event,helper);   
        //6863 Validations before triggering E-Agreement E
        }        
         
    },
    showToast :  function(component,event,helper) {
       event.stopPropagation();
       helper.showToast(component, event.getParam("title"), event.getParam("message"), event.getParam("type"));
    },//added for Bug 22487
    handleEMICardFetchEvent:function(component,event,helper){
       helper.updateFetchCharges(component,event,helper);
    },
    closeCustomToast: function(component, event, helper){
        helper.closeToast(component);
    }
})