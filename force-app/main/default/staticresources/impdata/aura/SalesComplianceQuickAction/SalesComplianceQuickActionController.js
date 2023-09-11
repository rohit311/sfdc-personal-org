({
    doInit : function(component, event, helper) {
        console.log('in nav');
        
        helper.executeApex(component,"getOppId",
                           {
                               "AudId":component.get("v.recordId")
                               
                           },function(error, result){
                               if(!error && result){
                                  
                                   component.set("v.oppId",result); 
                                   var evt = $A.get("e.force:navigateToComponent");
                                   evt.setParams({
                                       componentDef : "c:sales_compliance",
                                       componentAttributes: {
                                           oppId : component.get("v.oppId")
                                       }
                                   });
                                   
                                   evt.fire();                                   
                                   var dismissActionPanel = $A.get("e.force:closeQuickAction");
                                   dismissActionPanel.fire();
                                   
                               }    
                               
                               
                           });
        
        
        
    },
    
})