({
	init: function(component, event, helper) {
		component.set("v.hot",true);
		component.set("v.fresh",false);
    	component.set("v.followUp",false);
    	component.set("v.docsRec",false);
    	component.set("v.others",false);
    	
    	var action = component.get("c.fetchPOs");
        $A.util.removeClass(component.find("spinner"),"slds-hide");
        action.setCallback(this, function(response){
            
        	var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();
                var hotPOs =result['Hot'];
	            if(hotPOs.length > 0){
	                component.set("v.hotPOs", hotPOs);           
	            }
	            var freshPOs =result['Fresh'];
	            if(freshPOs.length > 0){
	                component.set("v.freshPOs", freshPOs);
	            }
	            var followUpPOs =result['FollowUp'];     
	            if(followUpPOs.length > 0){
	                component.set("v.followUpPOs", followUpPOs);
	            }
	            var docsRecPOs =result['DocsReceived'];
	            if(docsRecPOs.length > 0){
	                component.set("v.docsRecPOs", docsRecPOs);
	            }
	            var InterestedPos =result['Interested'];     
	            if(InterestedPos.length > 0){
	                component.set("v.InterestedPOs", InterestedPos);
	            }
	            var NotContactablePos =result['NotContactable'];     
	            if(NotContactablePos.length > 0){
	                component.set("v.NotContactablePOs", NotContactablePos);
	            }
	            var NotInterestedPos =result['NotInterested'];
	            if(NotInterestedPos.length > 0){
	                component.set("v.NotInterestedPOs", NotInterestedPos);
	            }
	            var RejectedPos =result['Rejected'];     
	            if(RejectedPos.length > 0){
	                component.set("v.RejectedPOs", RejectedPos);
	            }
	            var othersPOs =result['Others'];     
	            if(othersPOs.length > 0){
	                component.set("v.otherPOs", othersPOs);
	            }
                var hotPOsList = component.find("hotPOsList");
                hotPOsList.refresh();
                $A.util.addClass(component.find("spinner"),"slds-hide");
            }
            else{
            	$A.util.addClass(component.find("spinner"),"slds-hide");
            	alert('Please Try again');
            }
        })        
		$A.enqueueAction(action);
	},
	
	tabAction: function(component, event, helper) {
		for(var i=1;i<=6;i++) {
			var tmptab = component.find('t'+i.toString());
			var tmptabDetail = component.find('t'+i.toString()+'detail');
			$A.util.removeClass(tmptab, 'slds-active');
			$A.util.removeClass(tmptabDetail, 'slds-show');
			$A.util.addClass(tmptabDetail, 'slds-hide');
		}
		
		var tabId= event.currentTarget.dataset.index;
		var ActiveTab = component.find(tabId);
		var ActiveTabDetail = component.find(tabId+'detail');
		
		$A.util.addClass(ActiveTab, 'slds-active');
		$A.util.removeClass(tmptabDetail, 'slds-hide');
		$A.util.addClass(ActiveTabDetail, 'slds-show');
		
		helper.hideAllTabs(component);
		
		if(tabId == "t1")
		component.set("v.hot",true);
		if(tabId == "t2")
		component.set("v.fresh",true);
		if(tabId == "t3")
		component.set("v.followUp",true);
		if(tabId == "t4")
		component.set("v.docsRec",true);
		if(tabId == "t5")
		component.set("v.others",true);
    },
    innerTabAction: function(component, event, helper) {
		for(var i=1;i<=6;i++) {
			var tmptab = component.find('t'+i.toString()+i.toString());
			var tmptabDetail = component.find('t'+i.toString()+i.toString()+'detail');
			$A.util.removeClass(tmptab, 'slds-active');
			$A.util.removeClass(tmptabDetail, 'slds-show');
			$A.util.addClass(tmptabDetail, 'slds-hide');
		}
		
		var tabId= event.currentTarget.dataset.index;
		var ActiveTab = component.find(tabId);
		var ActiveTabDetail = component.find(tabId+'detail');
		
		$A.util.addClass(ActiveTab, 'slds-active');
		$A.util.removeClass(tmptabDetail, 'slds-hide');
		$A.util.addClass(ActiveTabDetail, 'slds-show');
		
		helper.hideAllInnerTabs(component);
		
		if(tabId == "t11")
		component.set("v.Interested",true);
		if(tabId == "t22")
		component.set("v.NotContactable",true);
		if(tabId == "t33")
		component.set("v.NotInterested",true);
		if(tabId == "t44")
		component.set("v.Rejected",true);
		if(tabId == "t55")
		component.set("v.other",true);
    },
})