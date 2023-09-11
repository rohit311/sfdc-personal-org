({
    doInit : function(component, event, helper){
      console.log(' mcp exppppppppppppppppppppppp>>'+component.get("v.netsalary"));
    },
    DestroyChildCmp: function(component, event, helper) {
        //component.set("v.body",'');
        component.destroy();
    }
    
})