({
    
    
	calculate : function(component, event, helper) {
		var one=component.find("inputOne").get("v.value");
        var two=component.find("inputTwo").get("v.value");
        var three=component.find("inputThree").get("v.value");
        var answer=parseInt(one)+parseInt(tw0)-parseInt(three);
        component.find("totalValue").set("v.value",answer);
	}
})