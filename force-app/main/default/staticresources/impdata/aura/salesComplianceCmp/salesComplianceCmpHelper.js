({
    executeApex: function(component, method, params,callback){
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
    savepdrecordhelper : function(component, event) {
        this.showhidespinner(component,event,true);
        console.log('in helper');
        var pd = component.get("v.pdObj");
        pd.Loan_Application__c=component.get("v.oppId");
        pd.Name_of_the_applicant__c =component.get("v.appId") ;
        var pddone = component.get("v.pddone");
        if(!$A.util.isEmpty(pddone) && pddone == 'Yes')
            pd.PD_Conducted__c = true;
        else
            pd.PD_Conducted__c = false;
        component.set("v.pdObj",pd);
        
        this.executeApex(component,"updatepdrecord",{"jsonpdObj":JSON.stringify(component.get("v.pdObj"))},function (error, result) {
            console.log(JSON.stringify(result));
            if(!error && result != null && result != undefined){
                this.displayToastMessage(component,event,'Success','PD record updated successfully','success');
                component.set("v.pdObj",result);
                var modalname = component.find("dashboardModel");
                $A.util.removeClass(modalname, "slds-show");
                $A.util.addClass(modalname, "slds-hide");
                this.showhidespinner(component,event,false);
                
                var getResult =$A.get("e.c:getAuditResult");
            			console.log('getResult'+getResult);
              			getResult.fire();
            }
            else
                this.showhidespinner(component,event,false);
            
        });
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