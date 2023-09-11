({
	doInit : function(component, event, helper) {
		console.log(component.get("v.dataRows"));
        
	},
    fetchData : function(component, event, helper) {
        component.set("v.dataRows",event.getParam("Response"));
        console.log('from event');
        console.log(component.get("v.dataRows"));
        helper.parseData(component, event);
    },
    addEntity : function(component, event, helper) {
        //var a = event.getSource();
        var ctarget = event.currentTarget;
    	var index = ctarget.dataset.index;
    	console.log(index);
        //console.log(event); 
        
        var selMap = component.get("v.dataRows")[index];
        console.log(selMap);
        
        helper.createcmp(component,"EditSecurity",
                         {"conId":component.get("v.conId"),
                          "symbol":selMap[6].value,
                          "SecName":selMap[5].value,
                          "type":selMap[4].value,
                          "isOpen":true}
                         ,"AddSecuritydiv");
    }
})