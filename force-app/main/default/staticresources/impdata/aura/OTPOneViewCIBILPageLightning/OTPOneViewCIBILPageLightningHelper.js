({
  getData : function(component) {
        var appId = component.get("v.appId");
        var cibid = component.get("v.cibid");
        var cibilTempId = component.get("v.cibilTempId");
        var leadId = component.get("v.leadId");

            this.executeApex(component, "viewCreditReportMethod", {
                "appId" : appId,"cibid" : cibid, "cibilTempId" : cibilTempId, "leadId" : leadId
            }, function (error, result) {
                
                if (!error && result) { 
                    console.log('result '+result);
                    var objlst = JSON.parse(result);
                    component.set("v.objCIBIL",objlst.objCIBIL);
                    component.set("v.cibilext",objlst.cibilext);
                    component.set("v.cibilext1",objlst.cibilext1);
                    console.log('cibil ext');
                    console.log(objlst.cibilext);
                }
                 

            });
        
        
    },
      executeApex : function(component, method, params,callback){
        
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                
                callback.call(this, null, response.getReturnValue());
            } else if(state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message){
                        errors.push(item.message);
                    }
                }
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    displayToastMessage:function(component,event,title,message,type)
    {
        
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    },
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
            
        });
        showhideevent.fire();
    },
})