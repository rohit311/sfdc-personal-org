({
    
      // Bug 24927 S
    setGCOCampaignParameters: function(component) {
        var GCOCampaigns = $A.get("$Label.c.GCO_Campaigns");
        var GCOCampaignList = [];
        GCOCampaignList = GCOCampaigns.split(',');
        component.set("v.GCOCampaignList",GCOCampaignList);

    },
     // Bug 24927 E
   setDispValue: function(component, event,helper) {
       component.set("v.DispDataModified",true);
   },
    
	activateTab: function(component, tabId) {
		if(tabId !== "customerTab" && !component.get("v.isSubmitted")){
        	var msg = "Please save customer details to access CPV and disposition tab.";
            this.showToast(component,"Info:",msg,"info");
        //8734:USERSTORY_Disposition to capture response for Partially filled starts    
        }else if(tabId == "dispositionTab" && component.get("v.DispDataModified") == true){
            this.showToast(component,"Info:","Disposition Data Modified.Please submit Customer Details First !","info");
            
        }
        //8734:USERSTORY_Disposition to capture response for Partially filled ends
            else {
        
            $A.util.removeClass(component.find("customerTab"), "slds-active");
            $A.util.removeClass(component.find("documentTab"), "slds-active");
            $A.util.removeClass(component.find("dispositionTab"), "slds-active");
            $A.util.addClass(component.find(tabId), "slds-active");
            
            this.showHideDiv(component, "customerTabContent", false);
            this.showHideDiv(component, "documentTabContent", false);
            this.showHideDiv(component, "dispositionTabContent", false);
            this.showHideDiv(component, tabId+"Content", true);
            
            //POS YK s
            if(tabId == "dispositionTab")
            {
                var isCheckProcess = component.get("v.IsCheckProcess");
                if(isCheckProcess!=true)
                {
                    var cmp = component.find("POS_Offer_Details_Child");
                    cmp.callSTPIntegration();
                }
                 
               
            }
            //POS YK e
        }
	}, 
    setSubmitted: function(component, event){
		var isSubmitted = event.getParam('isSubmitted');
      
        if(isSubmitted != true)
			component.set("v.isSubmitted", isSubmitted); //bug-18322
        else{
            component.set("v.isSubmitted", true);
  			//8734:USERSTORY_Disposition to capture response for Partially filled starts
            component.set("v.DispDataModified",false);
   			//8734:USERSTORY_Disposition to capture response for Partially filled ends

        }
            
          var offer = event.getParam('offer');
      	  if(offer.converted == true)
          	component.set("v.IsCheckProcess", true); 
        
    },
    closeToast: function(component){
        this.showHideDiv(component, "customToast", false);
    },
    showHideDiv: function(component, divId, show){
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
    fetchSOlPolicies1 : function(component){
    	this.executeApex(component, "FetchSolPolicy", {"poId" : component.get("v.poId")}, function(error, result){
            if(!error && result)
              {
				component.set("v.SolPolicy", result.SOL_Policys__r);
			  }  

        });
	},
        
    executeApex: function(component, method, params, callback){
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                callback.call(this, null, response.getReturnValue());
            } else if(state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message){
                        errors.push(item.message);
                    }
                }
                this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    //Priyanka
    callSTPBREIntegration : function(component, divId, show){
       /* this.executeApex(component, "BRESTPCall", {"poId" : component.get("v.poId")}, function(error, result){
            if(!error && result){
                console.log(result);
                result = JSON.parse(result);
                if(result.status === "Success"){
                     this.showToast(component, "Success!",result.message, "success");
                     //this.fetchSOlPolicies(component);
                     var event = $A.get("e.c:UpdateAlldata");;
                     event.fire();
                    
                    console.log('STP Success!');
            	}else if(result.status === "FAILED")
                {
                 	this.showToast(component, "Info!",result.message, "info");
                    console.log('failed bre stp call');
                }
            }
        });*/
    },
    
    /*fetchSOlPolicies : function(component){
    	this.executeApex(component, "FetchSolPolicy", {"poId" : component.get("v.poId")}, function(error, result){
            if(!error && result)
            {
                component.set("v.SolPolicy", result);
                var stpNonStpVar = 'STP';
                if(component.get("v.SolPolicy"))
                {
                    console.log('sol policy size---->> '+component.get("v.SolPolicy").length);
                    if(component.get("v.SolPolicy").length > 0)
                    	stpNonStpVar = 'Non-STP';
                }
                //POS YK s
                var stpNonStpEvent = $A.get("e.c:POS_StpNonStpFlow");
                if(stpNonStpEvent != undefined)
                {
                    console.log('firing stpNonStpEvent... in pos_po_pro')
                    stpNonStpEvent.setParams({ "flowName" : stpNonStpVar });
                    stpNonStpEvent.fire();
                }
                //POS YK e
            }
        });
	},*/
    
    showToast: function(component, title, message, type){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({ 
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "3000"
            });   
            toastEvent.fire();
        } else {
          
            var toastTheme = component.find("toastTheme");
            $A.util.removeClass(toastTheme, "slds-theme--error");
            $A.util.removeClass(toastTheme, "slds-theme--success");
            if(type == 'error'){
                
                $A.util.addClass(toastTheme, "slds-theme--error");
            } else if(type == 'success'){   
                $A.util.addClass(toastTheme, "slds-theme--success");
            }
             else if(type == 'info'){
                $A.util.addClass(toastTheme, "slds-theme--info");
            }
            
            component.find("toastText").set("v.value", message);
            component.find("toastTtitle").set("v.value", title+' ');
            this.showHideDiv(component, "customToast", true);
        }
    },
    
    
})