({ 
    doInit : function(component,event,helper)
    {
      /*  console.log('inside e init');
      
       var action = component.get("c.fetchBaseUrl");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var baseurln= response.getReturnValue();
            console.log('base '+baseurln);
            component.set("v.baseurl", baseurln);
            });
        $A.enqueueAction(action);*/
        helper.fetchCmnUsr(component,event);
    },
	loadpdf : function(component, event, helper) {
        var url = location.href;  // entire url including querystring - also: window.location.href;
		helper.loadpdf(component,event);
	},
    
})