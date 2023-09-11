({
    fetchPicklistValues : function(component, event) {
        var ContentVersionList = ["Document_Type__c","Document_Name__c"]; 
        var selectListNameMap = {};
        selectListNameMap["ContentVersion"] = ContentVersionList;
        
        var action = component.get("c.PicklistValues");
        action.setParams({ objectFieldJSON : JSON.stringify(selectListNameMap) });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = JSON.parse(response.getReturnValue());
                var picklistFields = data.picklistData;
                var CVList = picklistFields["ContentVersion"];
                component.set("v.DocTypeValues", CVList["Document_Type__c"]);
                console.log("in fetch picklist values");
                console.log(component.get("v.DocTypeValues"));
                console.log(component.get("v.DocNameValues"));
                //component.set("v.DocNameValues", CVList["Document_Name__c"]); 
            }
        })
        $A.enqueueAction(action);
    },
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },
    displayToastMessage:function(component,event,title,message,type)
    {
        console.log('inside displayToastMessage'+message+type);
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    }, 
})