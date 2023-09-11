({
	calcGroupType : function(component, event, helper) {
        //22552
        var prod ='', gt = '', accFlow='';
        var opp = component.get("v.record");
        prod = opp.Product__c;
        gt = opp.Account.Group_Type__c;
        accFlow = opp.Account.Flow__c;
        console.log('here');
        console.log(gt);
        var getGroupType = component.get("c.fetchGroupType");
        getGroupType.setParams({product : prod,
                                accGT : gt,
                                flow : accFlow});
        getGroupType.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log(response.getReturnValue());
                var GTRes = response.getReturnValue();
                console.log('flow inside callback' + accFlow);
                var GTResObj, tabNames;
        		if(GTRes != 'failed')
            		GTResObj = JSON.parse(GTRes);
                if(GTResObj && accFlow == 'Mobility V2'){
                    component.set("v.SALMV2",true);
                    console.log(component.get("v.SALMV2"));
                    tabNames = GTResObj.tabNames.split(',');
                    console.log(tabNames[0]);
                    component.set("v.MobTab1",tabNames[0]);
                    component.set("v.MobTab2",tabNames[1]);
                    component.set("v.MobTab3",tabNames[2]);
                }
            	component.set("v.GTResponse" ,response.getReturnValue());
                var GTRes = component.get("v.GTResponse");
        		console.log(GTRes);
            }
			else
                console.log('failed');
        });        
        $A.enqueueAction(getGroupType);
        
       
    }
})