({
    //20939 --S--(Garima)
    onInit : function(component, event, helper) {
        var action = component.get("c.checkRSAVerification");
        action.setParams({oppId : component.get("v.oId") });
        
        action.setCallback(this, function(res){
            var resp = res.getReturnValue();
            component.set("v.rsaVeriDone", resp);
        });
        $A.enqueueAction(action);
         //US_1409 S
        var recId = component.get("v.oId");
        var fetchOpp = component.get("c.fetchOpp");
        fetchOpp.setParams({rID : recId});
        fetchOpp.setCallback(this, function(response){
            var res = response.getReturnValue();
        component.set('v.record' ,res.opp);
            component.set('v.nameTheme',res.theme);
          if(component.get("v.record").Product__c=='SAL'|| component.get("v.record").Product__c=='SPL'||component.get("v.record").Product__c=='RSL'||component.get("v.record").Product__c=='RDPL' )  
          {
              component.set("v.isSendBack",false);
              console.log('Inside 3');
          }
            else
                 component.set("v.isSendBack",true);
             console.log('Inside 4');
                
        });
        
        $A.enqueueAction(fetchOpp);
        //Bug:26186 Start
        var action = component.get("c.getProfileInfo");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var staticLabel = $A.get("$Label.c.Rst_finnone_for_opsusr");
            //alert(JSON.stringify(staticLabel));
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              //  alert('pk'+storeResponse+staticLabel);
                if(storeResponse != staticLabel){
                    component.set("v.sndfinone", true);
                }
            }
        });
        $A.enqueueAction(action);
        //Bug:26186 End
            /*
        var getBaseUrl=component.get("c.getBaseUrl");
        getBaseUrl.setCallback(this, function(response){
          var res = response.getReturnValue();
           var state = response.getState()
            if (component.isValid() && state === 'SUCCESS') {
               component.set('v.baseUrl', res);
                 }
             });
  $A.enqueueAction(getBaseUrl);
        */
//US_1409 E
    },
    //20939 --E--(Garima)
    
    
    onSendToFinone : function(component, event, helper) 
    { 
        component.set("v.isProcessing", true);
        
		var action = component.get("c.doPreSendFinnone");
        action.setParams({oId: component.get("v.oId")});
        action.setStorable(true);
        action.setCallback(this, function(res){
            
            var utility = component.find("toastCmp");
            
            var response = res.getReturnValue()           
            if(response.indexOf('SUCCESS') != -1)
            {
                var sMsg = response.substr(7, response.length-1 );
                if(sMsg.length > 1){
                    var cnfrmAns;
                    if(sMsg.indexOf('SUCCESS') != -1)
                    {
                        cnfrmAns  = true;
                    }
                    else
                    {
                        cnfrmAns = confirm(sMsg);    
                    }
                    
                    if(cnfrmAns)
                    {
                        //Need to proceed with sendFInnone method from Disbursement page.
                        var postAction = component.get("c.sendToFinnOne");
                        postAction.setParams({ oId : component.get("v.oId") });
                        postAction.setCallback(this, function(responsePostFinnone){
                            var resPostFinnone = responsePostFinnone.getReturnValue();
                            
                            if(($A.util.isEmpty(resPostFinnone))){
                                // user story 978 s
                                 var updateidentifier =  $A.get("e.c:Update_identifier");
                                 updateidentifier.setParams({
                                "eventName": 'Branch Ops',
                                "oppId":component.get("v.oId")
                                  });
                               updateidentifier.fire();
                                 // user story 978 e
                                utility.showToast('Success!', 'Loan applicantion send to finnone successfully! Please refresh to see effects' , 'success');   
                            }
                            else
                            {
                                utility.showToast('Error!', resPostFinnone , 'error');
                            }                            
                        });
                        $A.enqueueAction(postAction);
                    }    
                }                
            }
            else if(response.indexOf('FAILURE') != -1) 
            {
                var fMsg = response.substr(7, response.length-1 );
                utility.showToast('Error!', fMsg , 'error');
            }
            else
            {
                utility.showToast('Error!', 'Something went wrong. Please contact your administrator. ' , 'error');
            }
            
            component.set("v.isProcessing", false);
        });
        $A.enqueueAction(action);
	},
    
    onSendBack : function(component, event, helper){
        //component.set("v.simpleRecord.COO_Comments__c", "");
        component.find('recordHandler').reloadRecord(true);//yasar

        component.set("v.showSendBackComments", true);
    },
    
    onSendBackDone: function(component, event, helper)
    {        
        component.set("v.isProcessing", true);
        
       if(component.get("v.simpleRecord.COO_Comments__c"))
        {
            component.find("recordHandler").saveRecord($A.getCallback(function(saveResult) {
                // NOTE: If you want a specific behavior(an action or UI behavior) when this action is successful 
                // then handle that in a callback (generic logic when record is changed should be handled in recordUpdated event handler)
                if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") 
                {                    
                    try
                    {
                        helper.handleSendBack(component);                    
                    }
                    catch(err){
                        console.log('Err while handling send back with comment:' + err);
                        component.set("v.isProcessing", false);
                    }
                    
                    console.log('Value: ' + component.get("v.simpleRecord.COO_Comments__c") );                                        
                    console.log("Updated successfully!");
                } else if (saveResult.state === "INCOMPLETE") 
                {
                    component.set("v.isProcessing", false);
                    console.log("User is offline, device doesn't support drafts.");
                } else if (saveResult.state === "ERROR") 
                {
                    component.set("v.isProcessing", false);
                    console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                } 
                else 
                {
					component.set("v.isProcessing", false);
                    console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                }
            }));    
        }
        else
        {
            try{
                helper.handleSendBack(component);
            }
            catch(err){
                component.set("v.isProcessing", false);
                console.log('Err while handling send back without comment:' + err);
            }
        }
    },
    
    onSendBackCancel: function(cmp, evt, helper){ 
        cmp.set("v.simpleRecord.COO_Comments__c" , '');
        cmp.set("v.showSendBackComments" , false);
    },
  
    
})