({
	updateidentifier : function(component, event, helper) {
        console.log('in update identifier component');
       var eventName =  event.getParam("eventName");
       var oppId =  event.getParam("oppId");
       var appId = event.getParam("appId");
         // alert('inside update 2');
       if (!$A.util.isEmpty(eventName) && !$A.util.isEmpty(oppId))
       helper.updateidentifierhelper(component,eventName,oppId,appId);
	}
     

})