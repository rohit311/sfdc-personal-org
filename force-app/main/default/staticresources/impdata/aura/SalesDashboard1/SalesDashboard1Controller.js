({  
    doInit  : function(component, event, helper) {
        //added for bug id 21851 start
        helper.getHideAadhaarSectionHelper(component);
       
        //added for 21851 end
        helper.populateDispositionDataInternal(component,event);
        var listchange = [];
         //24668 start
        component.set("v.curAppId",component.get("v.priAppObj").Id);
        var appTypeLst = component.get("v.appTypeLst");
        if(component.get("v.finAppl") && component.get("v.finAppl").Id){
            appTypeLst.push("Financial Co-Applicant");
            component.set("v.appTypeLst",appTypeLst);
            console.log(component.get("v.appTypeLst"));
        }
        //24668 stop
        window.setTimeout(
           $A.getCallback(function() {
               helper.showhidespinner(component,event,true);
               helper.fetchAccountDetails(component,event);
            }), 2000
        );
        
     
    },
    onCrossButton : function(component,event,helper)
    {
        var modalname = component.find("dashboardModel");
        $A.util.removeClass(modalname, "slds-show");
        $A.util.addClass(modalname, "slds-hide");
    },
    
    onclickbutton: function(component, event, helper) {
        //$A.util.addClass(document.getElementById('CIBIL'), 'orange-color');       
        helper.fetchAccountDetails(component,event);
    },
    
    onselectchange: function(component, event, helper) {
        var item=component.get("v.listchange");
        var changedValue=event.getSource().get('v.value');
        console.log('changed val'+changedValue);
        if(!changedValue.includes('NONE'))
        {
            item.push(changedValue);          
        }
        
    },
    updateRecords:function(component, event, helper) {
        
        var cmpEvent = component.getEvent("eventDashboard");
        /*console.log('test '+cmpEvent);
        cmpEvent.setParams({
            "message" : "A component event fired me. "});
        cmpEvent.fire();     */     
        helper.updateDetails(component,event);

        
    },
     //24668 Rohit start
    onAppChange : function(component, event, helper) {
    	//alert('hii');
    	//alert(component.get("v.finAppl").Id);
        component.set("v.listchange",new Array());
        if(component.get("v.appType") == 'Financial Co-Applicant'){
            component.set("v.curAppId",component.get("v.finAppl").Id);   
           
        }
        else{
            
            component.set("v.curAppId",component.get("v.priAppObj").Id); 
        }
        
         helper.populateDispositionDataInternal(component,event);
        
        
          window.setTimeout(
           				$A.getCallback(function() {
               				helper.showhidespinner(component,event,true);
               				helper.fetchAccountDetails(component,event);
            			}), 2000
        			 );
        
    },
    //24668 Rohit stop
    
    
})