({
	onInit : function(component, event, helper) {
        component.set("v.isProcessing", true);
        var action = component.get("c.getDashboardMap");
        action.setParams({oId : component.get("v.oId") });
        //action.setStorable(true);
        
        action.setCallback(this, function(res){
            
            var vRes = JSON.parse( res.getReturnValue() );            
            console.log('res.getReturnValue()'  + res.getReturnValue());
            component.set("v.isProcessing", false);
            component.set("v.db_elements", vRes );
            
            //Deciding sent-to-finnone's faith! :-P
            var sentToFinnoneFlag = true;
            console.log('vRes' +vRes);
            for(var i=0;i<vRes.length;i++)
            {
                if(vRes[i].IsComplete == 'false')
                {
                    sentToFinnoneFlag = false; 
                    break;
                }
            }
            component.set("v.allowSentToFinnone", sentToFinnoneFlag);
            //component.set("v.allowSentToFinnone", true); //=Uncomment it for testing purpose! G
        });
        $A.enqueueAction(action);
	}
})