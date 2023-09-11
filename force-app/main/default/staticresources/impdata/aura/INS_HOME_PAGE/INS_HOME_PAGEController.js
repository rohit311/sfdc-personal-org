({
    openTileCmp : function(component, event, helper) {
        //console.log(event.getSource().getLocalId());
        //console.log('event ::' + JSON.stringify(event));
        //component.set("v.isSpinner", true);
        var tileId = event.currentTarget.id;
        console.log("tileId::" + tileId);
       
        var ChildParam = {};
        ChildParam.tileId =tileId ;
        //ChildParam.isParentFlag = component.get("v.homeFlag");
        component.set("v.ChildParam",ChildParam);
        console.log('ChildParam ::' + JSON.stringify(component.get("v.ChildParam")));
        component.set("v.homeFlag", false);
        component.set("v.tileId",tileId);
       
        console.log('homeFlag:::'+ component.get("v.homeFlag"));
    },
    handleHmPgEvt: function(component, event, helper){
        console.log('Inside Event Handler');
        var evtParams = event.getParams();
        console.log('evtParams ::' + JSON.stringify(evtParams));
        
        if(evtParams.HomeEventParam.homeFlag){
            console.log('ggggcc');
            component.set("v.homeFlag",true);
        	component.set("v.tileId",null);
        }
     
        	
    }
})