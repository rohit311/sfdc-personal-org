({
	sumbit : function(component, event, helper) {
		var regpan = /^([a-zA-Z]){5}([0-9]){4}([a-zA-Z]){1}?$/;
        console.log('-->'+regpan);
        console.log('pan '+component.get("v.panStr").match(regpan));
        var panInp = component.find("panInp");
        if(component.get("v.panStr").match(regpan)){
            console.log('correct pan');
            component.set("v.errors", []);
        }
        else{
            console.log('inp '+panInp);
            //panInp.set("v.errors", [{message:"Invalid PAN: "}]);            
			component.set("v.errors", ["Invalid PAN: "]);
        }
	}
})