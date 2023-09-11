({
	doInit:function(component,event,helper) {
	},
	
	showMoreFields : function(component, event, helper) {
		component.set("v.fewmoreFields", false);
		component.set("v.hidefewmoreFields", true);
	},
	
    hideMoreFields : function(component, event, helper) {		
		component.set("v.fewmoreFields", true);
	},
	navigateToMyComponent : function(component, event, helper) {
		var lead1 = component.get("v.po.Lead__c");
        var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:BLMobilityOfferDetailComp",
                componentAttributes: {
                    recordId : component.get("v.po.Id")
                }
            });
        if (lead1 != null && lead1 != '' && lead1 != undefined){
            evt.fire();
        }
        else{
            var message ='Lead not attached';
            helper.invalidPO(component,message);
        }
            
	},
    
    gotoURL : function(component, event, helper) {
         helper.gotoURL(component);
    },
	showOfferData: function(component, event, helper){
        helper.setOfferData(component, event);
    },
	
	navigateToHome : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:BLMobiltyHomePagecomp",
        });
        evt.fire();
	},
})