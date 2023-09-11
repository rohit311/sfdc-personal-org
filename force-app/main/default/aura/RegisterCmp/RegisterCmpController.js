({
	closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
      helper.closeCmp(component, event, helper);  
   },
    doInit : function(component, event, helper) {
		
	},
    createUser : function(component, event, helper) {
        helper.createUser(component, event);
    }
})