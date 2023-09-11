({
	doInit : function(component, event, helper) {
        helper.showhidespinner(component,event,true);
		 /*DMS bug 24317s*/
         helper.getDMSDocuments(component,event);
        /*DMS bug 24317s*/
    	helper.getChecklistDocOnload(component, event);
    },
    getChecklistDoc : function(component, event, helper) {
        helper.showhidespinner(component,event,true);
		helper.getDocuments(component,event,true);
	},
     geDeviationDoc : function(component, event, helper) {
        helper.showhidespinner(component,event,true);
		helper.getDocuments(component,event,false);
	},

    saveManDeviation : function(component, event, helper) {
        helper.showhidespinner(component,event,true);
		helper.savemanualDev(component,event,helper);
    },
    saveAutoDeviation : function(component, event, helper) {
		helper.saveautoDev(component,event,helper);
    },
    
    toggleAssVersion : function(component, event, helper)
    {
        console.log(event.target.getAttribute('id'));
        var click=event.target.getAttribute('id');
        console.log('click'+click);
        component.set('v.myid',click);
        
        var cls=component.get('v.class') ;
        if(cls=='hideCls'){
            component.set("v.class", 'showCls');
           
            
        }else{
            component.set("v.class", 'hideCls');
        }        
    },
    toggleAssVersion1 : function(component, event, helper)
    {
        console.log(event.target.getAttribute('id'));
        var click=event.target.getAttribute('id');
        console.log('click'+click);
        component.set('v.myid1',click);
        
        var cls=component.get('v.class1') ;
        if(cls=='hideCls'){
            component.set("v.class1", 'showCls');
           
            
        }else{
            component.set("v.class1", 'hideCls');
        }        
    },
    addDeviation : function(component, event, helper) {
        helper.showhidespinner(component,event,true);
        helper.addDev(component,event,helper);
	},
    updateChkRecords : function(component, event, helper) {
        helper.showhidespinner(component,event,true);
        console.log('in updateChkRecord');
		var params = event.getParam('arguments');
        if (params) {
			console.log(params.checklistIDs+'>status>'+params.status);
            var checklistIDs = params.checklistIDs;
            var status = params.status;
            helper.UpdateRecords(component,checklistIDs,status);
        }
        else{
            helper.showhidespinner(component,event,false);
        }
	},
    callVerificationAPI : function(component, event, helper) {
        $A.util.addClass(component.find("veriBtn"),'disablediv');
        $A.util.removeClass(component.find("veriBtn"),'enablediv');
        helper.showhidespinner(component,event,true);
    	helper.callVerificationAPI(component,event);
         var showhideevent =  $A.get("e.c:passVerificationList");
        showhideevent.fire();
        console.log('after event fire!');
	}
})