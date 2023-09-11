({
	
    toggleAssVersion : function(component, event) {
        console.log(event.target.getAttribute('id'));
        var click=event.target.getAttribute('id');
        component.set('v.myid',click);
        
        var cls=component.get('v.class') ;
        if(cls=='hideCls'){
            component.set("v.class", 'showCls');
           
            
        }else{
            component.set("v.class", 'hideCls');
        }        
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
            if(!error && result != null && result != undefined){
                 this.displayToastMessage(component,event,'Success','PD record updated successfully','success');
                component.set("v.pdObj",result);
                
                this.showhidespinner(component,event,false);
                if(component.get("v.pdObj.Tele_PD_Applicability__c") == 'NO')
               		 component.set("v.telepdstatusdashboard",'Waived');
                else if(component.get("v.pdObj.Tele_PD_Applicability__c") == 'YES' && !$A.util.isEmpty(result.PD_Conducted__c) && result.PD_Conducted__c)
                {
                	 component.set("v.telepdstatusdashboard",'Positive');
                    // component.set("v.cibilDashboardData.cibil_dashboard",'Positive');
                }
                else
                     component.set("v.telepdstatusdashboard",'Pending');
                if(!$A.util.isEmpty(result.PD_Conducted__c) && result.PD_Conducted__c)
               		 component.set("v.pddone",'Yes');
                else
                   component.set("v.pddone",'No');
                var evt = $A.get("e.c:SetParentAttributes");
                    evt.setParams({
                        "pdObj" : component.get("v.pdObj"),
                        "pddone":component.get("v.pddone"), 
                        "telepdstatusdashboard":component.get("v.telepdstatusdashboard"),
                        "quesdetailslist" : component.get("v.quesdetailslist"),
                        "SecName":"telepd"
                    });
                    evt.fire();
            }
            else
                this.showhidespinner(component,event,false);
                
        });
    },

        executeApex: function(component, method, params,callback){
        console.log('params'+JSON.stringify(params));
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log('response.getReturnValue()'+response.getReturnValue());
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