({
    showLoanNumber: function(component, event, helper){
        helper.setLoanNumber(component, event);
    },
	setOffer : function(component, event, helper){
        helper.setOfferDetails(component, event);
    }
    ,
     closeModal:function(component,event,helper){    
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    openmodalCibil: function(component,event,helper) {
       
        var displayCibilEvent = $A.get("e.c:showCibilModal");
        
        displayCibilEvent.setParams({ 
            "showCibil": 'True',
            "poId":component.get("v.PO.Id")
        });
        displayCibilEvent.fire();
        
    },
     closeModalCibil:function(component,event,helper){    
        var cmpTarget = component.find('ModalboxCibil');
        var cmpBack = component.find('ModalbackdropCibil');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    openProcessmodal: function(component,event,helper) {
        var displaySTPEvent = $A.get("e.c:showSTPModal");
        displaySTPEvent.setParams({ 
            "showSTP": component.get("v.PO.Id")
        });
        displaySTPEvent.fire();
    },

    
	ToggleCollapse : function(component, event, helper) { 
		helper.ToggleCollapseHandler(component, event);
	},
   
    callSTPIntegration : function(component, event, helper) {
		helper.callSTPBREIntegration(component, event);
     
	},
     closeCustomToast: function(component, event, helper){
        helper.closeToast(component);
    },
    
    setSTPData: function(component, event, helper){
        helper.setSTPData(component);
    },
   /*  uploadDoc : function(component, event, helper) {
       
        var cmpTarget = component.find('uploadModal');
        var cmpBack = component.find('ModalbackdropUpload');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
        helper.showHideDiv(component, "uploadModal", true);     
        var poId = component.get("v.PO.Id");
        
        var evt = $A.get("e.c:POS_PO_PassParam");
        evt.setParams({"POId":poId });
		evt.fire();
       
	},
     closeuploadModal:function(component,event,helper){    
        var cmpTarget = component.find('uploadModal');
        var cmpBack = component.find('ModalbackdropUpload');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        helper.showHideDiv(component, "uploadModal", false);
    },
	*/ 
    navigateToCPV : function(component,event,helper)
    {
        helper.navigateToCPV(component,event);
    }

})