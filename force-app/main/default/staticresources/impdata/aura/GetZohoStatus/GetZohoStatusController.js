({	
    doInit: function(component, event, helper) { 
        //alert(component.get("v.recordId"));
    helper.GetStatus(component);             
  },
     closeCustomToast : function(component, event, helper){
        helper.closeToast(component);
    },
})