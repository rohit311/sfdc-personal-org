({
    doInit: function(component, event, helper) {
       
       
        var action = component.get('c.getUserData');
        console.log('inside init');
        action.setCallback(this,function(response){
            var state = response.getState();
       		console.log('inside callback');
            if(state == 'SUCCESS')
            {
                
                component.set("v.isCommunityUsr", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
         // Bug 24927 S
         helper.setGCOCampaignParameters(component);
        // Bug 24927 E
       
    },
    
	menuItemClick: function(component, event, helper){ 
        helper.activateTab(component, event.target.getAttribute('id'));
    },
    SetCheckProcessFlag: function(component, event, helper){ 
         component.set('v.IsCheckProcess',true);
        
    },
    enableDocAndDispos : function(component, event, helper){
        helper.setSubmitted(component, event);
    },
    gotoNextTab: function(component, event, helper){
        helper.activateTab(component, event.getParam('tabId'));
    },
    closeCustomToast : function(component, event, helper){
        helper.closeToast(component);
    },
   displayCibil : function(component, event, helper) {
       var data = event.getParam('showCibil') || '';
        var poId =  event.getParam('poId');
       component.set('v.poId',poId);
        var cmpTarget = component.find('ModalboxCibil');
        var cmpBack = component.find('ModalbackdropCibil');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
        helper.showHideDiv(component, "ModalboxCibil", true);
	},
    //8734:USERSTORY_Disposition to capture response for Partially filled starts
     handleDispEvent: function(component, event, helper){
        helper.setDispValue(component);     
    },
    //8734:USERSTORY_Disposition to capture response for Partially filled ends

     closeModalCibil:function(component,event,helper){    
        var cmpTarget = component.find('ModalboxCibil');
        var cmpBack = component.find('ModalbackdropCibil');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        helper.showHideDiv(component, "ModalboxCibil", false);
    },
    displaySTP: function(component,event,helper) {
         
        var data = event.getParam('showSTP') || '';
        component.set("v.poId",data);
        helper.fetchSOlPolicies1(component); 
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
       
    },
       closeModal:function(component,event,helper){    
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    //Priyanka
    callSTPIntegration : function(component, event, helper) {
  
		helper.callSTPBREIntegration(component, event);
	},
    

})