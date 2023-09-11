({
	closeModel : function (component, event, helper) {
            var modalname = component.find("dashboardModel");
           $A.util.removeClass(modalname, "slds-show");
			$A.util.addClass(modalname, "slds-hide");
    },
    
    openDashboard1 : function(component, event, helper) {
          // $A.util.removeClass(component.find("dashboardModel"), "slds-hide");
		  // $A.util.addClass(component.find("dashboardModel"), "slds-show");
         $A.createComponent(//24668 added priAppObj & finAppl
             "c:SalesDashboard1",{"oppId":component.get("v.oppObj.Id"),"stageName":component.get("v.stageName"),"priAppObj":component.get("v.priAppObj"),"finAppl":component.get("v.finAppl")},
                function(newComponent){
                    component.set("v.body",newComponent);
                
                }
            ) 
               
    },
    openDashboard : function(component, event, helper) {
          // $A.util.removeClass(component.find("dashboardModel"), "slds-hide");
		  // $A.util.addClass(component.find("dashboardModel"), "slds-show");
         $A.createComponent(
             "c:SalesDashboard",{"oppId":component.get("v.oppObj.Id")},
                function(newComponent){
                    component.set("v.body",newComponent);
                
                }
            ) 
               
    },
      openPricingDashboard : function(component, event, helper) {
         $A.createComponent(
             "c:SAL_PricingDashboard",{"oppId":component.get("v.oppObj.Id")},
                function(newComponent){
                    component.set("v.body",newComponent);
                
                }
            ) 
          
    },
    openPricingDashboard1 : function(component, event, helper) {
         $A.createComponent(
             /*24673 added oppObj*/
             "c:PricingDashboard",{"oppObj":component.get("v.oppObj"),"oppId":component.get("v.oppObj.Id"),"stageName":component.get("v.stageName")},
                function(newComponent){
                    component.set("v.body",newComponent);
                
                }
            ) 
          
    },
     openCreditDashboard : function(component, event, helper) {
         $A.createComponent(
             "c:CreditDashboard",{"oppId":component.get("v.oppObj.Id")},
                function(newComponent){
                    component.set("v.body",newComponent);
                
                }
            ) 
          
    },
      handleComponentEvent : function(cmp, event) {
        var message = event.getParam("message");

        cmp.set("v.messageFromEvent", message);
    }
})