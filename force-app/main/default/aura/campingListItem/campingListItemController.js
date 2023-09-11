({
	packItem : function(component, event, helper) {
        var item=component.get("v.item",true);
        item.Packed__c=true;
        component.set("v.item",item);
        console.log(item.Packed__c);
        //item.set("v.Packed__c",true);
        component.set("v.item.Packed__c",true);
        var btnClicked=event.getSource();
        btnClicked.set("v.disabled",true);
		//var p=component.get("v.item.Packed__c");
        //console.log(p);         
       
	}
})