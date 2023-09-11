({
    doInit : function(component, event, helper){
       
    },
    showSpinner : function(component, event, helper){
        $A.util.removeClass(component.find("spinner"),"slds-hide");
    },
    hideSpinner : function(component, event, helper){
        $A.util.addClass(component.find("spinner"),"slds-hide");
    },
   	getDetails : function(component, event, helper){ 
    	var kyc = event.getParam("kyc");
        var po = event.getParam("po");
       
        var offer = event.getParam("offer");
        component.set("v.kyc", kyc);
        component.set("v.po", po);
        //PSL changes : Nikhil Bugfix #11766
        component.set("v.offer", offer);
        console.log("In Getdetails.......");
        component.set("v.areDetailsFetched", true);
       
    },

    setOfferConverted : function(component, event, helper){
      //  helper.setOfferConverted(component);
    }, 
	
})