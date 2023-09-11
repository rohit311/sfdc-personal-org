({
    goBack : function (component, event, helper){
        component.destroy();
        
    },
    doInit : function(component, event, helper) {
        debugger;
		var currDate = new Date();
        currDate.setFullYear( currDate.getFullYear() - 18 );
        var month = 0;
        month = currDate.getMonth()+1;
        component.set("v.currentDate",currDate.getFullYear()+'-'+month+'-'+currDate.getDate());
        console.log('date '+component.get("v.currentDate")); 
        console.log(component.get("v.addOnSollist"));
        helper.fetchAddOnData(component, event);
    },
    saveAddOnDetails : function(component, event, helper){
        var list = [];
        var isvalid = true;
        list = ["chargetype","firstname","lastname", "dob", "mobile", "email", "relationname"];
        for (var i = 0; i < list.length; i++) {
            console.log('list[i]>>' + list[i]);
            console.log(component.find(list[i]));
            if (component.find(list[i]) && !component.find(list[i]).get("v.validity").valid)
            {
                isvalid = false;
                component.find(list[i]).showHelpMessageIfInvalid();
            }
        }
        if(isvalid){
           helper.saveAddOnDetails(component, event); 
        }
       
    
    },
	myAction : function(component, event, helper) {
		
	}
})