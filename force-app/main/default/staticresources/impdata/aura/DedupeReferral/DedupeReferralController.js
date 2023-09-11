({
    getData : function(component, event, helper) {
        console.log('In getData');
        var loanId = component.get("v.loanId");
        
        //helper.getDedupeRecord(component);
        
        helper.getOpportunityObj(component);
    },
    openModel: function(component, event, helper) {
        
        component.set("v.isOpen", true);
        
        component.set("v.Dedupe",null);
        component.set("v.selectedApplicant","");
        component.set("v.IsDedupeLinked",false);
        component.set("v.waitingFlag",false);
        helper.getOpportunityObj(component);
        
        event.preventDefault();
        return false;
    },
    
    closeModel: function(component, event, helper) {
        
        component.set("v.isOpen", false);
        
        //event.preventDefault();
        //return false;
        window.location.reload()//section rerender  nevigatetourl
    },
    
    onGroup: function(component,event,helper){
        
        var getWhichBtn = event.getSource().get("v.value");
        var getWhichBtn2 = event.getSource().get("v.text");
        console.log('getWhichBtn2 : '+getWhichBtn2)
        component.set("v.storeRadioValue" , getWhichBtn); 
        //component.set("v.storeRadioText" , getWhichBtn2); 
        component.set("v.selectedDedupeId" , getWhichBtn2); 
        
        event.preventDefault();
        return false;
        
    },
    
    onSave: function(component,event,helper){
        component.set("v.saveBtnLabel","Saving...");
        component.set("v.waitingFlag",true);
        var selectedDedupeId=component.get("v.selectedDedupeId");
        console.log("selectedDedupeId : "+selectedDedupeId);
        var selectedApplicantId=component.get("v.selectedApplicant");
        console.log("selectedApplicantId : "+selectedApplicantId);
        var totalDedupeRecords=component.get("v.TotalDedupes");
        console.log("totalDedupeRecords : "+totalDedupeRecords);
        console.log("totalDedupeRecords1 : "+Number(totalDedupeRecords));
        if(totalDedupeRecords!=null && typeof totalDedupeRecords!='undefined' && Number(totalDedupeRecords)>=1){ //Bug 22924: changed condition to >=1, earlier it was just checking greater than 1
            if(selectedDedupeId!=null && typeof selectedDedupeId!='undefined' && selectedDedupeId!=''){
                 helper.updateDedupeLinkingHelper(component,event,selectedDedupeId,selectedApplicantId);
            }else{
                alert("Select atleast one dedupe to link!");
                component.set("v.saveBtnLabel","Save");
                component.set("v.waitingFlag",false);
            }
        }else{
            alert("Select atleast one dedupe to link!");
            component.set("v.saveBtnLabel","Save");
            component.set("v.waitingFlag",false);
            //helper.updateDedupeLinkingHelper(component,event,selectedDedupeId,selectedApplicantId);
        }
        
        event.preventDefault();
        return false;
    },
    
    onApplicantSelect: function(component,event,helper){
        console.log('In onApplicantSelect : ')
        var getWhichBtn = event.getSource().get("v.value");
        //var getWhichBtn2 = event.getSource().get("v.text");
        //console.log('getWhichBtn : '+getWhichBtn)
        console.log('getWhichBtn : '+getWhichBtn)
        component.set("v.selectedApplicant" , getWhichBtn); 
        //component.set("v.storeRadioText" , getWhichBtn2);
         var app = component.get("v.Applicants");
        var appId = component.get("v.selectedApplicant");
        
        for(var i in app)
        {
            if(app[i].Id==appId)
            {

                console.log('appId : '+appId);
                var apptype=app[i].Contact_Name__r.Customer_Type__c;
                
                if(apptype=='Corporate')
        		{
            		component.set("v.showCorporate" , true);
        		}
        
            }
        }
        if(getWhichBtn!='' && getWhichBtn!='undefined')
            helper.getDedupeRecordForApplicant(component);
        else{
            component.set("v.Dedupe",null);
            component.set("v.TotalDedupes" , 0);
        }
            
        
        event.preventDefault();
        return false;
    },
    
    onReset: function(component,event,helper){
        component.set("v.resetBtnLabel","Processing...");
        component.set("v.waitingFlag",true);
        var LANId=component.get("v.loanId");
        console.log("LANId : "+LANId);
        var appId=component.get("v.selectedApplicant");
        console.log("appId : "+appId);
        helper.updateDedupeLinkingResetHelper(component,event,LANId,appId);
        
        event.preventDefault();
        return false;
    },
    
})