({
	onInit : function(component, event, helper) 
    {
        console.log( 'Yay! I got the address ----> ' + component.get("v.ipAddr") );
        component.set("v.showSpinner", true);
		var action = component.get("c.getReport");
        try{
            action.setCallback(this, function(response){
                var res = response.getReturnValue();
                console.log(res);            	
                component.set("v.budgets" , JSON.parse(res) );
                component.set("v.showSpinner", false);
            });
        }catch(errorData){
            component.set("v.showSpinner", false);
        }
        $A.enqueueAction(action);
	},
    
    onAssetConfirmation : function(cmp, evt, helper){
        
        $A.createComponent('c:Budget_AssetConfirmation', { ipAddr :  cmp.get("v.ipAddr") }, function(newCmp, status, errMsg){
            if(cmp.isValid() && newCmp.isValid()  && status == 'SUCCESS'){                
                var cmpTarget = cmp.find('Modalbox');
                var body = cmpTarget.get("v.body");
                body.push(newCmp);
                cmpTarget.set("v.body", body);
            }
        });
        
        
    },
    
})