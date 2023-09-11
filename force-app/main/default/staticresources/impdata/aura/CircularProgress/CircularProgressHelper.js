({
	/*
    *   @description	: 	Method is called when component is initialized.
    * 						Method is called when value of actualProgress or value of totalProgress changes.
    *   @version		: 	1.0
    */
    doInit : function(component, event, helper)  {
        // Call helper to calculate percentage
        helper.computeProgress(component, event, helper); 
	},
    
    /*
    *   @description	: 	Method is called to calculate percentage.
    *   @version		: 	1.0
    */
	computeProgress : function(component, event, helper)  {
        var totalVal = component.get("v.totalProgress");
        var actualVal = component.get("v.actualProgress"); 
        
        if(totalVal && actualVal && !isNaN(parseInt(totalVal)) && isFinite(totalVal) && !isNaN(parseInt(actualVal)) && isFinite(actualVal)) {
            // Calculate degree of circle to set percentage 
            var percVal = parseInt(actualVal) / parseInt(totalVal) ;
            var progressVal = parseInt(percVal * 360) ;
            // Calculate percentage
            component.set("v.cirDeg", progressVal);
            component.set("v.perText", parseInt(percVal * 100) +'%'); 
        }
    },
})