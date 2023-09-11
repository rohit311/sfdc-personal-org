({
	  sendback : function(component,event,helper){
    
         var targetCmp = component.find("childCmpbody");
        console.log(targetCmp);
        var body = targetCmp.get("v.body");
        targetCmp.set("v.body",''); 
        var evt1 = $A.get("e.c:DestroyChild");
        evt1.fire();
        
  
        
        var evt = $A.get("e.c:navigateToParent");
        evt.setParams({
            "display" : true
        });
        evt.fire();
        component.destroy();
    },

})