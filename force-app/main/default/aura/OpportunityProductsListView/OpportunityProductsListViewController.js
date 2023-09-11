({
	doInit : function(component, event, helper) {
		helper.getOppProducts(component, event);
	},
    addProd :  function(component, event, helper) {
      var oppProducts = component.get("v.oppProducts");
        
        if(oppProducts){
            oppProducts = new Array();            
        }
        
        
        var prod = new Object();
        prod.OpportunityId = component.get("v.oppId");
        prod.sobjectType = 'OpportunityLineItem';
        
        oppProducts.push(prod);
        component.set("v.oppProducts",oppProducts);
    },
    saveProds : function(component, event, helper) {
        helper.saveLineItems(component, event);
    },
})