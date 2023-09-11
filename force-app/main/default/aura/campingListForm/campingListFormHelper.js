({
	createItem : function(component) {
		var cItem=component.get("v.newItem");
        
        var createEvent=component.getEvent("addItemEvent");
        createEvent.setParams({"item":cItem});
        
        component.set("v.newItem",{'sobjectType':'Camping_Item__c',
                'Name': '',
                'Quantity__c': 0,
                'Price__c': 0,
                'Packed__c': false});
	}
})