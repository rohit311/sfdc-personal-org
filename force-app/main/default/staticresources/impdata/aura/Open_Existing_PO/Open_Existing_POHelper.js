({
	doinit : function(component, event) {
        this.executeApex(component, "getPO", {
            poId : component.get("v.recordId")
        }, function(error, result){
            if(result && !error){
                
                var po = JSON.parse(JSON.stringify(result));
                //alert('Po : ' + po);
                //alert('Po : '+ po.Products__c);
                if(po.Products__c === 'RDL')
                	component.set('v.productFlow' , 'RDL');
                this.openComponent(component, event);
            }
        });
        
        	
	},
    
    openComponent : function(component, event){
        var evt = $A.get("e.force:navigateToComponent");
        if(evt){
            evt.setParams({
                componentDef : "c:DoctorPRO",
                componentAttributes: {
                    poId : component.get("v.recordId"),
                    productFlow : (component.get('v.productFlow') === 'RDL' ? 'RDL' : 'PROMOBILITY')
                }
            });
      
            evt.fire();
            
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();	  
        }else{
            //alert('Inside createcomponent');
            $A.createComponent("c:DoctorPRO", {
                poId : 'a100k000000Twq3',
                productFlow : (component.get('v.productFlow') === 'RDL' ? 'RDL' : 'PROMOBILITY')
            }, function(newCmp) {
                if (component.isValid()) {
                    component.set("v.body", newCmp);
                }
            });            
        }
    },
    
    executeApex: function(component, method, params, callback){
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
                this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }    
    
})