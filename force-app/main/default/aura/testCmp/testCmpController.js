({
	handleClick : function(component, event, helper) {
		var childCmp = component.find("childCmp");
        childCmp.dummyMethod("testing","hds");
	},
     handleSaveRecord: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
           // record is loaded (render other component which needs record data value)
            console.log("Record is loaded successfully.");
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
         
         window.open("https://rohit311-dev-ed.lightning.force.com/lightning/r/Account/0010I00002G5e2oQAB/view"); 
    }
})