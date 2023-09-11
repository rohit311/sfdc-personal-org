({
    doInit : function(component, event, helper){
     	 helper.getEmployerOpportunityData(component, event); //Added for 928 
    },
   /* onApplicantListChange : function(component, event, helper){
        console.log('onApplicantListChange');
        helper.onApplicantListChange(component, event);     
    },*/
    toggleAssVersion : function(component, event, helper) {
    	helper.toggleAssVersion(component, event);     
    },
    previewAttchment: function(component, event, helper) {
        var contentId = component.get("v.contentId");
        //alert('contentId>>>>'+contentId);
       // helper.previewPdf(component,event,contentId);
     //  alert('previewPdf>>'+component.get('v.theme'));//+'>>'+component.get('v.theme')+'>>'+component.get('v.isCommunityUsr'));
        if(component.get('v.theme') =='Theme3' || component.get('v.theme') =='Theme2' || component.get('v.theme') =='Theme4d'){
            if(component.get('v.isCommunityUsr'))
                window.open('/Partner/'+contentId,'_blank');
            else
            { 
               window.open('/'+contentId,'_blank');
            }
           
        }
        else{
            $A.get('e.lightning:openFiles').fire({
                recordIds: [contentId]
            });
            
        }
    },
     DestroyChildCmp: function(component, event, helper) {
        //component.set("v.body",'');
        component.destroy();
    }
})