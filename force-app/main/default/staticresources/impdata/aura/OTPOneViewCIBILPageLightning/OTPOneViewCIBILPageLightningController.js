({
	 onCrossButton : function(component,event,helper)
    {
        var modalname = component.find("dashboardModel");
        $A.util.removeClass(modalname, "slds-show");
        $A.util.addClass(modalname, "slds-hide");
    },
    doInit: function(component, event, helper){
            console.log('in helper');
	helper.getData(component,event);
	},
    displayValue : function(component, event, helper){
        if(component.get("v.messageString") == "Next"){
        	component.set("v.messageString","Previous");
        }
        else{
            component.set("v.messageString","Next");           
        }
        
    }
})