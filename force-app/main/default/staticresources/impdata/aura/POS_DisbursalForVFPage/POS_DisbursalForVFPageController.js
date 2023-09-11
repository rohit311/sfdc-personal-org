({
	doinit:function (component,event,helper) {
       // for Display Model,set the "isOpen" attribute to "true"
       helper.getOpsChecklistData(component,helper);
       component.set("v.isOpenOps", true);
		
	},
    
     closeOpsModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "False"  
      component.set("v.isOpenOps", false);
   }
    
})