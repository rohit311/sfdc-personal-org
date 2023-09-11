({
    fetchPickListVal: function(component, fieldName) {
      /* call the apex getselectOptions method which is returns picklist values
         set the picklist values on "picklistOptsList" attribute [String list].
         which attribute used for iterate the select options in component.
       */  
        var action = component.get("c.getselectOptions");
        action.setParams({
             "objApiName": component.get("v.Object"),
             "fldAPIname": component.get("v.Field")
        });
        var opts = [];
         
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    opts.push(allValues[i]);
                }
                component.set("v.picklistOptsList", opts);
            }
        });
        $A.enqueueAction(action);
    },
     showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },
})