({
    sendback : function(component,event,helper){
        var evt = $A.get("e.c:navigateToDashboard");
        evt.setParams({
            "display" : true
        });
        evt.fire();
        component.destroy();
        var evt1 = $A.get("e.c:DestroyDashboardChild");
        
        evt1.fire();
    },
})