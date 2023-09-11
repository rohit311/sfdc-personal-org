({
	doInit : function(component, event, helper) {
		console.log('here');
	},
    searchData : function(component, event, helper){
        console.log('... '+(typeof component.get("v.StkName")));
        component.set("v.isLoading",true);
        if(component.get("v.StkName") != null && component.get("v.StkName") != '' && component.get("v.StkName").length>=2){
        	helper.fetchData(component, event);
        }
        else{
            component.set("v.isError",true);
            component.set("v.errorMsg",'Please enter atleast 2 characters');
            component.set("v.isLoading",false);
            console.log('in else');
        }
        console.log('in create '+component.get("v.isDataFetched"));
        
    },
    redirectToLogin : function(component, event, helper){
        
        helper.openLogin(component, event);
        var loginDiv = component.find("loginLinkDiv");
        $A.util.toggleClass(loginDiv, "hidecls");
    },
    logout : function(component, event, helper) {
        //helper.createcmp();
        component.set("v.contact",null);
        var loginDiv = component.find("tablediv");
        $A.util.toggleClass(loginDiv, "hidecls");
        //need to do additional changes here
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