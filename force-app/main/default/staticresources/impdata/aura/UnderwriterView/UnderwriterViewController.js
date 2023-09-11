({
    doInit : function(component, event, helper){
   
        console.log('Init o end');
    },
       DestroyChildCmp: function(component, event, helper) {
        component.set("v.body",'');
        component.destroy();
         //  alert('s');
    }
})