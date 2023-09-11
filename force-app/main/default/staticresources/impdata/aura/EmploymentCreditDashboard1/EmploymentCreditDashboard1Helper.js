({
    //Added for 928 Start
     getEmployerOpportunityData : function(component,event){
    	
        var employerName = component.get("v.accObj.Name_of_the_Company_Employer__c");
         var employerCategory = component.get("v.accObj.Type_Of_Industry__c");
         if(employerCategory=='BFL Un-Listed Company' || employerCategory=='Others' || employerCategory=='Company not listed' || employerCategory=='De-listed'){
             var action = component.get("c.getEmployerOpportunityData");
             
             action.setParams({
                 'employerName' : employerName,
                 'employerCategory' : employerCategory
             });
           
             action.setCallback(this, function(response) {
                 var state = response.getState();
                 var approvedCount = 0;
                 var rejectedCount = 0;
                 var movedToFinnoneCount = 0;
                 if (component.isValid() && state === "SUCCESS") {
                     var res = response.getReturnValue();
                     console.log('Call 1 : ', response.getReturnValue() );
                     
                     for(var i=0; i<res.length; i++){
                         if(res[i].StageName=='Approved') {
                             approvedCount++; 
                         }else if(res[i].StageName=='Rejected'){
                             rejectedCount++;
                         }else if(res[i].StageName=='Moved To Finnone'){
                             movedToFinnoneCount++ ;
                         }
                     }
                   // setTimeout(function(){
                     component.set("v.approvedStage", approvedCount);
                     component.set("v.rejectStage", rejectedCount);
                     component.set("v.movedToFinoneStage", movedToFinnoneCount);
                   // },100)
                 }
             })
               
             $A.enqueueAction(action);
             
         }
    },
    //Added for 928 stop
    toggleAssVersion : function(component, event) {
        console.log(event.target.getAttribute('id'));
        var click=event.target.getAttribute('id');
        component.set('v.myid',click);
        
        var cls=component.get('v.class') ;
        if(cls=='hideCls'){
            component.set("v.class", 'showCls');
            
            
        }else{
            component.set("v.class", 'hideCls');
        }        
    },
    previewPdf : function(component,event,contentId){
        alert('previewPdf>>'+previewPdf+'>>'+component.get('v.theme')+'>>'+component.get('v.isCommunityUsr'));
        if(component.get('v.theme') =='Theme3' || component.get('v.theme') =='Theme2'){
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
    }
})