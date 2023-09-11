({
	backToHomeHelper: function(component,event,helper){
       
        component.set("v.InsMainFlag", false);
        component.set("v.openCustDetails",false);
       
        var compEvent = component.getEvent("INSHomePgEvent");
        var evtParam = {};
        evtParam.homeFlag = true;
    
        compEvent.setParams({"HomeEventParam" : evtParam });
		compEvent.fire();
    }
})