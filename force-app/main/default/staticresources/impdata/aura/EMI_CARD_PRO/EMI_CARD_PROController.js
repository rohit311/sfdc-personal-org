({
    doInit: function(component, event, helper) {
        console.log('Id of PO is '+component.get("v.IdEMI"));
        helper.getEMIcardpref(component,helper);
        helper.autopopoulatedata(component,helper);
    
    },
    EMICARDOpenClose:function(component, event, helper) {
        component.set("v.isOpen",true);
        helper.autopopoulatedata(component,helper);
    },
    CloseEverything:function(component,event,helper){
        component.set("v.isOpen",false);
        /*if((!component.get("v.isMobility"))&&component.get("v.isLAFlag"))
        location.reload();*/
    },
    saveEMICard:function(component,event,helper){
        helper.saveEMICard(component,event);
        
    }
})