({
	openBOT : function(component, event, helper) {
        //alert('Inside openBOT');
		window.open(" https://bfin.in/?BLU2018",'_blank');
	},
    sendback : function(component,event,helper){
        
        var evt = $A.get("e.c:navigateToParent");
        evt.setParams({
            "display" : true
        });
        evt.fire();
        component.destroy();
    },
})