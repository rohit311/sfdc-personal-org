({
	openBOT : function(component, event, helper) {
        //alert('Inside openBOT');
		window.open("https://chatbot.hellotars.com/conv/HymKbx/",'_blank');
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