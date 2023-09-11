({
	populateUMRN : function(component, event) {
        this.showhidespinner(component, event, true);
        var self = this;
        console.log('here in populateUMRN');
        this.executeApex(component,"getUMRN",{"oppId":component.get("v.oppId")},function(error, result){
            self.showhidespinner(component, event, false);
            console.log('inside '+result);
            if(!error && result){
                console.log('result '+result);
                if(!$A.util.isEmpty(result)){
                    
                    if(result != 'error' && result != 'no response'){
                        
                        var repayList = JSON.parse(result);
                        component.set("v.repayList",repayList);
                        component.set("v.isDisabled",true);
                        console.log('repayObj : ');
                        console.log(repayList[0].UMRN__c);
                        self.displayToastMessage(component,event,'Success','UMRN fetched successfully !','success');
                    }
                    else if(result == 'no response'){
                        self.displayToastMessage(component,event,'Info','UMRN not found','info');                        
                    }
                    else if(result == 'error'){
                        self.displayToastMessage(component,event,'Error','Internal server error , Please try again later','error');    
                    }
                }
                
                
            }
            
            
            
        });
	},
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