({
	handleAdditem : function(component, event, helper) {
		
        //if(helper.validation(component))
        //{
            var cItem=event.getParam("item");
            //helper.createItem(component,cItem);
		//}
      
         var action=component.get("c.saveItem");   
            action.setParams({
                "cItem":newCitem
            });
            
            action.setCallback(this,function(response){
                var state=response.getState();
                
                if(component.isValid() && state==="SUCCESS")
                {
                     var Clist=component.get("v.items");
                    Clist.push(response.getReturnValue());
                     component.set("v.items",Clist);
				}
                
            });   
            
        component.set("v.newItem",{'sobjectType':'Camping_Item__c',
                'Name': '',
                'Quantity__c': 0,
                'Price__c': 0,
                'Packed__c': false});
           
		
	},
    doInit:  function(component, event, helper) {
        
        var action=component.get("c.getItems");
        
        action.setCallback(this,function(response){
            var state=response.getState();
            if(component.isValid() && state==="SUCCESS")
            {
                component.set("v.items",response.getReturnValue());
			}
            else
            {
                console.log("error "+state);
            }
            $A.enqueueAction(action);
            
        });
    }
})