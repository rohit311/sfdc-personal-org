({
	doInit: function(component, event, helper) {
        helper.editableOrNot(component);
        helper.getAddedpropertyList(component);
        helper.getPicklistval(component);
  
    },
       submitDetails : function(component,event,helper){
       helper.submitpropertydata(component,event,helper); 
       },
    CloseEverything : function(component, event, helper) {
    component.destroy();
    },
    showOnUpdateSection: function(component,event,helper){
        console.log('Inside this');
        helper.showOnUpdateSectionHelper(component, event, helper);
    },
    PropertyMCPController : function(component,event,helper){
        event.preventDefault();
        console.log('Calling helper for BRE');
        helper.invokeBREMCP(component,event,helper);
    },
    cancelDetails: function(component,event,helper){
        helper.cancelDetailsHelper(component,event,helper);
    },
    
     areaOfPropertyVisibility: function(component,event,helper){
      helper.areaOfPropertyVisibilityHelper(component,event,helper);
    },
    
    
    
})