({
    doInit : function(component, event, helper){
        //component.set("v.parentId",component.get("v.recordId"));
        //console.log('Init of Documents List start'+component.get("v.recordId"));
        helper.getAllAttachments(component);
       
        console.log('Init of Documents List end');
    },
    deleteAttachment : function(component, event, helper){
        var id = event.getSource().get("v.value");
        var name = event.getSource().get("v.name");
        /*17138 added if else*/
        if(component.get("v.flow") == 'Mobility2'){
            helper.showhidespinner(component,event,true);
            helper.deleteAttachmentMob(component, id,name);
        }
        else{
            helper.deleteAttachment(component, id);
        }
        
    },
    showUploadedDocs : function(component, event, helper){
        /*Bug 17138 s*/
         
        if(event.getParam("flow") == 'Mobility2'){
            component.set("v.flow",'Mobility2');
			   //23578 
        component.set("v.isPhotoPres",event.getParam("containsPhoto"));
        console.log(component.get("v.isPhotoPres"));
            helper.showhidespinner(component,event,true);
        }
        /*Bug 17138 e*/
        helper.getAllAttachments(component);
    },/*added by swapnil for DMS 24317 s*/
    getDMSDocs :function(component, event, helper) {
        var params = event.getParam('arguments');
         component.set("v.DMSDocmap",params["DMSDocmaps"]);
    }
     /*added by swapnil for DMS 24317  e*/
})