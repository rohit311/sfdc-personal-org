({
	doInit : function(component, event, helper) {
        helper.getDecryptEmployeeId(component,event);
        console.log('In landing page '+component.get("v.EmployeeId"));
            var url1 = $A.get('$Resource.employeeLoanBackground');
            component.set('v.employeeLoanBackground', url1);
        //helper.getOffer(component, event);
         
	},
    getID : function(component, event, helper) {
       var message = event.getParam("Id");
       var offerAvailable = event.getParam("offerAvailable");
       var detailsAvailable = event.getParam("detailsAvailable");
       component.set("v.OppId",message);
       var tabid = event.getParam("tabid");
       component.set("v.selTabId",tabid); 
	   component.set("v.isDetailsAvailable",detailsAvailable);
       component.set("v.isOfferAvailabel",false);
       component.set("v.currentStageIsMydetails",event.getParam("stageIsMyDetails"));
        
     //  alert(component.get("v.isOfferAvailabel"));
       console.log('In Get ID'+message+event.getParam("stageIsMyDetails"));
           

        
	},
    tabSelected :function(component, event, helper) {
		var tabID=component.get("v.selTabId");
        console.log('tabselected'+tabID);
        //var oppId = component.get("v.OppId")
	},
    trackApplications : function(component, event, helper) {
		var tabID=component.get("v.selTabId");
        console.log('tabselected'+tabID);
        component.set("v.modalHeader","Track Applications");
        var cmpTarget = component.find('overrideModalbox');
         var cmpBack = component.find('Modalbackdrop');
        //$A.util.addClass(cmpTarget, 'slds-fade-in-open');
         $A.util.removeClass(cmpTarget, 'slds-hide');
         $A.util.addClass(cmpTarget, 'slds-show');
         $A.util.addClass(cmpBack, 'slds-backdrop_open');
        
	},
          
    closeWindow :  function(component, event, helper) {
     
        var cmpTarget = component.find('overrideModalbox');
        $A.util.removeClass(cmpTarget, 'slds-show');
        $A.util.addClass(cmpTarget, 'slds-hide');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack, 'slds-backdrop_open');
    },
    uploader : function(component, event, helper) {
		var tabID=component.get("v.selTabId");
        console.log('tabselected'+tabID);
        component.set("v.modalHeader","Upload Documents");
        var cmpTarget = component.find('overrideModalbox');
         var cmpBack = component.find('Modalbackdrop');
        //$A.util.addClass(cmpTarget, 'slds-fade-in-open');
         $A.util.removeClass(cmpTarget, 'slds-hide');
         $A.util.addClass(cmpTarget, 'slds-show');
         $A.util.addClass(cmpBack, 'slds-backdrop_open');
        
	},
     showInfoMessage : function(component, event, helper){
        $A.util.removeClass(component.find("info1"), "slds-hide");
        console.log('sd');
    },
    hideInfoMessage : function(component, event, helper){
        $A.util.addClass(component.find("info1"), "slds-hide");
        console.log('23');
    },
     callDoinitMethodToRefrsh : function(component, event, helper){
            // Added by Anurag for 22181. Event to fire Insurance validations
			helper.firePassInsuranceEvent(component, []);
         	var appEvent = $A.get("e.c:reloadEmployeeLoanDisbSection");
            if(appEvent){
                appEvent.fire();
            }
    },
      callDoinitMethodToRefrshVASPage : function(component, event, helper){
            var appEvent = $A.get("e.c:reloadVASPage");
            if(appEvent){
                appEvent.fire();
           
       }
         
    },
})