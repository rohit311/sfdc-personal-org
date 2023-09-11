({
	doInit: function(component, event, helper) {
        console.log('in do init'+component.get("v.view"));
        var poId;
        helper.showhidespinner(component,event,true);
        if(component.get("v.productOfferingId") != null)
        	poId = component.get("v.productOfferingId");
        else if(component.get("v.recordId") != null)
        	poId = component.get("v.recordId");
        console.log('poId : '+poId);
        var action = component.get("c.checkPOUsernames");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var result = response.getReturnValue();
                console.log('PO username result'+result);
                if(result == 'Success'){
                    helper.getPODetails(component, poId);
        			console.log('OBJ LEAD inside main IS :'+JSON.stringify(component.get("v.objLead")));
                }else{
                    //helper.showhidespinner(component,event,false);
                    helper.showhidespinner(component,event,false);
                    component.set("v.cmpLoadMsg", result);
                }
            }
            else{
                helper.showhidespinner(component,event,false);
                component.set("v.cmpLoadMsg", 'Unable to open PO view page');
                console.log('state is error');
            }
        });
        $A.enqueueAction(action);
    },
    /*commented the code for bug 18566 Start*/
    /*backToStdRecordPage: function(component, event, helper) {
        helper.showhidespinner(component,event,true);
        var poId;
        if(component.get("v.productOfferingId") != null)
        	poId = component.get("v.productOfferingId");
        else
        	poId = component.get("v.recordId");
        console.log('poId++'+poId);
        helper.backToStdRecordPage(component, event,poId);
    },*/
    /*commented the code for bug 18566 Start*/
    /*Bug 18566 Start*/
    sendback : function(component,event,helper){
        //console.log("view is"+component.get("v.view"));
        if(component.get("v.view") == '' || component.get("v.view") == 'recordview'){
            helper.showhidespinner(component,event,true);
            var poId;
            if(component.get("v.productOfferingId") != null)
                poId = component.get("v.productOfferingId");
            else
                poId = component.get("v.recordId");
            console.log('poId++'+poId);
            helper.backToStdRecordPage(component, event,poId);
        }
        else{
            var targetCmp = component.find("childMainCmpbody");
            console.log(targetCmp);
            var view = component.get("v.view");
            var body = targetCmp.get("v.body");
            targetCmp.set("v.body",''); 
            var evt1 = $A.get("e.c:DestroyChild");
            evt1.fire();
            
            var evt = $A.get("e.c:navigateToParent");
            console.log("view is"+component.get("v.view"));
            evt.setParams({
                "display" : false,
                "view" : view
            });
            evt.fire();
            component.destroy();
        }
        
    }
    /*Bug 18566 End*/
    
})