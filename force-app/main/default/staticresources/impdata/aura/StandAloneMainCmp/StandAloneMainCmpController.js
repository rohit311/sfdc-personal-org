({
	handleShareEvent : function(component, event, helper) {
		var customer = event.getParam("custObj"); 
        console.log(event.getParam("isNew"));
        component.set("v.customer",customer);
        component.set("v.isNew",event.getParam("isNew"));
        console.log("customer  "+customer);
        
        if(customer){
         $A.util.removeClass(component.find('CustdetailsId'), 'slds-hide');
         //Bug 24447 start   
         $A.util.removeClass(component.find("ProddetailsId"),'slds-show');
         $A.util.addClass(component.find("ProddetailsId"),'slds-hide');
         
         var prodDetails = component.find('ProdDetailsCmp');
         prodDetails.resetComp();   
         //Bug 24447 stop   
         component.set("v.openSection","Custdetails"); 
         var childCmp= component.find('detailsCmp');		            
        childCmp.setCustfields(event.getParam("isNew"));
        
        }
        else{
            component.set("v.customer",new Object());
            $A.util.addClass(component.find('CustdetailsId'), 'slds-hide');
            $A.util.addClass(component.find('ProddetailsId'), 'slds-hide');
        }
        
	},
    doInit : function(component, event, helper) {
        component.set("v.Spinner",true);
        var currDate = new Date();
        currDate.setFullYear( currDate.getFullYear() - 18 );
        var month = 0;
        month = currDate.getMonth()+1;
        component.set("v.currentDate",currDate.getFullYear()+'-'+month+'-'+currDate.getDate());
        console.log('date '+component.get("v.currentDate"));
        helper.fetchConfigData(component, event);
        
    },
    handleLeadShareEvent : function(component, event, helper) {
        var lead = event.getParam("leadObj"); 
        console.log(event.getParam("insObj").Id);
        component.set("v.leadObj",lead);       
        component.set("v.isdataChanged",true);
        $A.util.removeClass(component.find('ProddetailsId'), 'slds-hide');
        //CR 24406 start
        var prodDetails = component.find('ProdDetailsCmp');
        prodDetails.callcibilReset();
        //CR 24406 stop
        
        component.set("v.openSection","Proddetails");
    },
    openDashboard : function(component, event, helper) {
        console.log('here');
        $A.createComponent(
            "c:SalInsuranceDashboard",{},
                function(newComponent){
                    component.set("v.body",newComponent);
                
                }
            ) 
        component.set("v.isOpen",true);
    },
    closeModel : function(component, event, helper) {
        component.set("v.isOpen",false);
    },
    sendback : function(component, event, helper) {
    	  var targetCmp = component.find("StandAloneDiv");
        var body = targetCmp.get("v.body");
        targetCmp.set("v.body", ''); 
        console.log('view is'+component.get("v.view"));
        var evt = $A.get("e.c:navigateToParent");
        evt.setParams({
            "display" : true,
            "view" : component.get("v.view")
        });
        evt.fire();
        component.destroy();
    
    },
    handlePayShareEvent : function(component, event, helper) {
        //Disable save button once payment link is send
        component.set("v.isPayLinkSend",true);
    },
    //CR not given start
    handleCibilShareEvent : function(component, event, helper) {
        //Disable PAN field in Customer details section if cibil is initiated
        var CustDetails = component.find('detailsCmp');
        CustDetails.cibilDoneHandler();
    },
    //CR not given stop
})