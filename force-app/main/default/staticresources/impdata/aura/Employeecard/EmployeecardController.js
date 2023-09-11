({
	doInit : function(component, event, helper) {
	   helper.getData(component,event);
              var url1 = $A.get('$Resource.employeeLoanBackground');
            component.set('v.employeeLoanBackground', url1);
                          var url1 = $A.get('$Resource.bajaj_finserv_logo');
            component.set('v.backgroundImageURL', url1);
    },
     getID : function(component, event, helper) {
       var message = event.getParam("Id"); component.set("v.OppId",message);
       console.log('Igjgh'+message);
       helper.getData(component,event);
   

        
	},
})