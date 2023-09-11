({    
    createDummyRow: function(component, event) {
        var RowItemList = component.get("v.discrepancyList");
        if(RowItemList.length == 0)
        {
            RowItemList.push({
                'sobjectType': 'Discrepancy__c',
                'LoanApplication__c' : component.get('v.loanid')
            });
            component.set("v.discrepancyList", RowItemList);
        }
        else
        {

            var lastElement=RowItemList.length-1;
            
            if($A.util.isEmpty(RowItemList[lastElement].Status__c)  || $A.util.isEmpty(RowItemList[lastElement].OTPDiscrepancyDocuments__c) || $A.util.isEmpty(RowItemList[lastElement].OTPDiscrepancyCategory__c))
            {
                this.displayToastMessage(component,event,'Error','Please Enter Values','error');
            } 
            else
            {
                RowItemList.push({
                    'sobjectType': 'Discrepancy__c',
                    'LoanApplication__c' : component.get('v.loanid')
                });
            }
            component.set("v.discrepancyList", RowItemList);        
        }
    },
    /* getSanctionDetailsMethod: function(component, event) {
        this.executeApex(component, 'getSanctionDetails', {
            "oppId" :component.get("v.loanid")   },
                         function (error, result) {
                             if (!error && result) {
                                 var data = JSON.parse(result);
                                 component.set("v.discrepancyList",data.discrepancyList);
                                 console.log(data.discrepancyList+'Helo');
                                 
                             }
                         });
    },*/
    
    
    SaveSanctionDetails: function(component, event) {
        var discList = component.get("v.discrepancyList");
        if(!$A.util.isEmpty(discList))
        {            
            for(var i=0 ; i< discList.length ; i++)
            {
                if($A.util.isEmpty(discList[i].id))
                {
                    discList[i].Type__c = 'SanctionCondition';
                    if($A.util.isEmpty(discList[i].OTPDiscrepancyCategory__c) 
                       && $A.util.isEmpty(discList[i].OTPDiscrepancyDocuments__c) 
                       && $A.util.isEmpty(discList[i].Status__c) 
                       && $A.util.isEmpty(discList[i].Resolution_Remarks__c))
                    {
                        discList.splice(i,1);
                    }
                }
            }  
            component.set("v.discrepancyList",discList);
        }
        
        this.executeApex(component, 'saveSanctionDetailsMethod', {
            "loanid" :component.get("v.loanid") , "JSONDiscrepancyList" :JSON.stringify(component.get("v.discrepancyList"))
            
        },
                         
                         function (error, result) {
                             
                             if (!error && result) {
                                 var utility = component.find("toastCmp");
                                 utility.showToast('Success!', 'Sanction details saved successfully.', 'success');
                                 //this.displayToastMessage(component,event,'Success','Sanction details saved successfully','success');//-Commented for #20391 deployment purpose; later for mobility purpose can be removed comment of toas.
                                 this.showhidespinner(component,event,false);
                                 if(!$A.util.isEmpty(result))
                                 {
                                     component.set("v.discrepancyList",result);
                                 }
                                 if(component.get("v.flow") == "credit"){
                                     var evt = $A.get("e.c:SetParentAttributes");
                                     if(evt)
                                     {
                                         evt.setParams({
                                             "discrepancyList" : component.get("v.discrepancyList"),
                                             "SecName":"sanction"
                                         });
                                         evt.fire(); 
                                     }
                                        
                                 }
                             }
                             else{
                                 this.displayToastMessage(component,event,'error','Error in Saving','error');
                                 this.showhidespinner(component,event,false);
                             }
                             
                             
                         });
        
        
    },   
    
    executeApex: function(component, method, params,callback){
        
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state === "SUCCESS"){
                
                callback.call(this, null, response.getReturnValue());
            } else if(state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message){
                        errors.push(item.message);
                    }
                }
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },
    displayToastMessage:function(component,event,title,message,type)
    {
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    },
})