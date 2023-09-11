({
	doInit : function(component, event, helper) {
		
	},
    Submit : function(component,event,helper){
        helper.checkuser(component,event);
    },
    Register : function(component,event,helper){
        
        component.set("v.isNewUser",true);
        helper.createcmp(component,"RegisterCmp",{"isOpen":component.get("v.isNewUser")},"RegisterForm");
        
    },
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    }
    
})