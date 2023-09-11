({
    doInit  : function(component, event, helper) {
        
        helper.fetchSOLDetails(component); 
        
    },
    
    selectUserData : function(component, event, helper){
     debugger;  
        var solList=component.get("v.SOLList");
        var sol;
        component.set("v.SOLobj",'');
        for(sol in solList)
        {
            if(solList[sol].Id==component.get("v.selectedSolId"))
                component.set("v.SOLobj",solList[sol]);
            
        }
        
    },
    
    onCrossButton : function(component,event,helper)
    {
        var modalname = component.find("dashboardModel");
        $A.util.removeClass(modalname, "slds-show");
        $A.util.addClass(modalname, "slds-hide");
    },
    
})