({
    scriptsLoaded : function(component, event, helper) {
        
    },
    MCPRejectEvent: function(component, event, helper) {
    console.log('in event of MCPREJECT');
        component.set("v.MCPRejectON1",false);
    },
	doInit : function(component, event, helper) {
        
        console.log('inside doint'+  component.get("v.homeFlag"));
       component.set("v.tabVisiblityclone",!component.get('v.fromcloneflag')); //added for bug 23577
        helper.getHideAadhaarSectionHelper(component); //  added for bug id 22047
       // helper.showhidespinner(component,event,true);
      /* if(component.get("v.oppId") != '')
        {
            component.set("v.recordId",component.get("v.oppId"));
        }
        console.log('oppId in parent'+component.get("v.recordId"));
        // check component loading start...
        console.log('checkRedirectionValidity --pricingId-->> '+component.get("v.pricingId"));
    	var action = component.get("c.checkRedirectionValidity");
        action.setParams({
            "oppId": component.get("v.recordId"),
            "flowName": 'dssOppFlow'
        });
        action.setCallback(this, function(response){
        	var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
                console.log('...inside success...');
                var wrapperObj = response.getReturnValue();
                console.log('wrapperObj.errorMessageString--->> '+wrapperObj.errorMessageString);
           		if(wrapperObj.errorMessageString != 'NO_ERROR')
                {
                    component.set("v.cmpLoadMsg", wrapperObj.errorMessageString);
                }    
        	}
    	});
        $A.enqueueAction(action);*/       
        // check component loading end... 
        
        var action = component.get("c.checkRedirectionValidity");
            action.setParams({
                "oppId": component.get("v.recordId"),
                "flowName": 'dssOppFlow',
                "version" :'Mobility V2'
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    console.log('...inside success...');
                    var wrapperObj = response.getReturnValue();
                    
                    console.log('wrapperObj.errorMessageString--->> '+wrapperObj.errorMessageString);
                    if(wrapperObj.errorMessageString != 'NO_ERROR')
                    {
                        helper.showhidespinner(component,event,false);
                        component.set("v.cmpLoadMsg", wrapperObj.errorMessageString);
                    }
                    else
                        helper.getCardData(component,event);
                    
                }
                });
            $A.enqueueAction(action); 
         
        
        //helper.getCardData(component,event);      
	},
    fireFinalOff : function(component, event, helper){
        //   added for bug id 18669 start
         console.log('inside controller fireFinalOff::'+component.get('v.priAppObj'));
        helper.fetchEkycDetailsHelper(component,event,component.get('v.priAppObj'));  
        //   added for bug id 18669 end
        var appEvent = $A.get("e.c:fireDynOffer");
        if(appEvent){
            appEvent.fire();
        }    
    },
    fireCKYCDemographic: function(component, event, helper){
     //   console.log('in fire demo-->'+JSON.stringify(component.get("v.priAppObj")));
    	 //   added for bug id 18669 start
     	 console.log('inside controller fireCKYCDemographic::'+component.get('v.priAppObj'));
        helper.fetchEkycDetailsHelper(component,event,component.get('v.priAppObj'));  
         //   added for bug id 18669 end
        var appEvent = $A.get("e.c:firePanBreCheck");
        if(appEvent){
            appEvent.fire();
        }    
    },
    fireCKYCDemographic1 :function(component, event, helper){
      if(component.get("v.stageName") == 'DSA/PSF Login'){ /* CR 22307 */
       var appEvent = $A.get("e.c:firePanBreCheck");
        if(appEvent){
            appEvent.fire();
        }
        var appEvent1 = $A.get("e.c:checkSOlPolicy");
        if(appEvent1){
            appEvent1.fire();
        }
      }
    },   
     closeModel : function (component, event, helper) {
            var modalname = component.find("dashboardModel");
           $A.util.removeClass(modalname, "slds-show");
			$A.util.addClass(modalname, "slds-hide");
    },
    navigateToMyPO : function(component, event, helper) {
        //component.destroy();
        /*var evt = $A.get("e.force:navigateToComponent");
        if(evt){
            evt.setParams({
                componentDef : "c:SAL_POMainScreen",
                componentAttributes: {
                    productOfferingId : event.getParam("productOfferingId")
                }
            });
            evt.fire();
        }
        else{
            alert('test');
            window.location.href = "/apex/SAL_Lightning_Out_V2?recordId="+event.getParam("productOfferingId");
            /*var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/apex/SAL_Lightning_Out_V2?recordId="+event.getParam("productOfferingId"),
                "isredirect": "true",
            });
            urlEvent.fire();
        }*/
        //component.set("v.body",'');
        component.set("v.homeFlag",false);
        $A.createComponent(
            "c:SAL_POMainScreen",{"productOfferingId":event.getParam("productOfferingId")},
            function(newComponent){
                component.set("v.body",newComponent);
            }
        )
        
    },
    openDashboard : function(component, event, helper) {
        
                  $A.util.removeClass(component.find("dashboardModel"), "slds-hide");
		   $A.util.addClass(component.find("dashboardModel"), "slds-show");
       /* if(component.get("v.toggleI"))
        {
            component.set("v.toggleI",false);
            component.set("v.body",[]);
        }
        else{
            component.set("v.toggleI",true);
            $A.createComponent(
                "c:SalesDashboard",{},
                function(newComponent){
                    component.set("v.body",newComponent);
                }
            )
        } */
        
    },
    showToast :  function(component,event,helper) {
        alert('show toast');
       helper.showToast(component, event.getParam("title"), event.getParam("message"), event.getParam("type"));
    },
    fetchEkycDetails : function(component,event,helper) {
        console.log('inside controller fetch::'+component.get('v.priAppObj'));
        helper.fetchEkycDetailsHelper(component,event,component.get('v.priAppObj'));        
        
        helper.getDataOnReinitiation(component,event);
    },
      setConAcc:function(component, event, helper){// sal 2.0 adhoc
    
       var priConObj =  event.getParam("conObj");
       var accObj =  event.getParam("accObj");
       if(!$A.util.isEmpty(priConObj)) 
       		component.set("v.priConObj",priConObj);
       if(!$A.util.isEmpty(accObj)) 
       		component.set("v.accObj",accObj);
    }

    
})