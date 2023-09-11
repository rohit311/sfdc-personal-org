({
	doInit : function(component, event, helper) {
		var accAction = component.get("c.fetchAccount");
        accAction.setParams({"accId":component.get("v.accId")});
        
        component.set("v.spinner",true);
        
        var accPromise = helper.executeAction(component,accAction);
        accPromise.then(
            $A.getCallback(function(result){   
                component.set("v.spinner",false);
                console.log('result',result.Contacts[0]);
                component.set("v.account",result);
                component.set("v.pageTitle","Account - "+result.Name);
                
                if(result.Contacts && result.Contacts.length > 0){
                    component.set("v.contactList",result.Contacts);
                }
                
                if(result.Opportunities && result.Opportunities.length > 0){
                    component.set("v.oppList",result.Opportunities);
                }
                
                if(result.Cases && result.Cases.length > 0){
                    component.set("v.casesList",result.Cases);
                }
            }),
            $A.getCallback(function(error){
                component.set("v.spinner",false);
                alert('Some error occured '+error);
                
            })
        );
	},
    
})