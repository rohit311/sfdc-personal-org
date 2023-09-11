({
	init : function(component, event, helper) {
		
        helper.getWalletData(component);
        helper.getDedupeData(component);
        component.find("idProceedBtn").set("v.disabled", true);
        if(component.get('v.matchedDedupe') != null)
        	component.find("idCreatCustBtn").set("v.disabled", true);
        else
            component.find("idCreatCustBtn").set("v.disabled", false);
        
        helper.getSOLData(component, event, helper);
        //helper.getInsWalletData(component);
        //helper.showToast(component,helper,event);
        
	},
    
    reInitDedupe: function(component, event, helper){
        helper.reInitDedupe(component);
        component.find("idProceedBtn").set("v.disabled", true);
        //this.init(component, event, helper);
        helper.getWalletData(component);
        helper.getDedupeData(component);
    },
    
    getSelectedName: function(component, event, helper){
        component.find("idProceedBtn").set("v.disabled", false);
        //var selectedRows = event.getParam('selectedRows')
        var getWhichBtn = event.getSource().get("v.value");
        var getWhichBtn2 = event.getSource().get("v.text");
        //var selectedRow = helper.getmatchRec(component)
        
        component.set('v.selectedRecId',getWhichBtn2);
        console.log('v.selectedRecId --->' + component.get('v.selectedRecId'));
       
       
        helper.getmatchDedupe(component);
	},
    
    createDedupeCust: function(component, event, helper){
        var selectedRows = component.get('v.matchedDedupe');
        helper.createDedupeCustHelper(component);
    },
    
    createCustCallout: function(component, event, helper){
        helper.createCustCallout(component, event, helper);
        
    }
   
})