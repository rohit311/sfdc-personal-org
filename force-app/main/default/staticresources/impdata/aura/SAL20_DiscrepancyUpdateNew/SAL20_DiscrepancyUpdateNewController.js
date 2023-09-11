({
    doInit : function(component, event, helper) {
        component.set("v.isProcessing" , true);
        
        var action = component.get("c.initiateData");
        action.setParams({"loanId": component.get('v.loanId')});
        action.setCallback(this, function( res){
            component.set("v.isProcessing" , false);
            helper.handleCallbackResponse(component, res, '', 'Something went wrong...');
        });
        $A.enqueueAction(action);
    },
    
    onAddDiscrepancy : function(component, event, helper) {
        component.set("v.isProcessing" , true);
        var RowItemList = component.get("v.attributeWrapperObj.discrepancyData"); 
        
        RowItemList.push({
            'sobjectType': 'Discrepancy__c',
            'LoanApplication__c': component.get("v.attributeWrapperObj.loan.Id"),
            'Kit_Acceptance__c': component.get("v.attributeWrapperObj.kitAcceptanceValue"),
            'RaiserName__c': component.get("v.attributeWrapperObj.currentUser.Id"),
            'Raiser_Role__c': component.get("v.attributeWrapperObj.loan.Current_UserRole__c"),
            'Discrepancy_Stage__c': component.get("v.attributeWrapperObj.loan.StageName"),
            'Status__c': 'Pending',
            'Discrepancy_Party__c ': component.get("v.attributeWrapperObj.StrVAContact")
        });
           
        component.set("v.attributeWrapperObj.discrepancyData", RowItemList);
        component.set("v.attributeWrapperObj.sendMssg", false);
        
        component.set("v.isProcessing" , false);
	},
    
    
    onAddSaveDiscrepancy : function(component, event, helper) {
        component.set("v.isProcessing" , true);

        //Handling StrVAContact Start
        var attributeWrapperObj = component.get("v.attributeWrapperObj");        
        var discrepancyData_Arr = component.get("v.attributeWrapperObj.discrepancyData");
        if (discrepancyData_Arr)
        {
            for(var i =0; i< discrepancyData_Arr.length; i++)
            {
                if(i == discrepancyData_Arr.length-1)
                {
                    component.set("v.attributeWrapperObj.StrVAContact" , discrepancyData_Arr[i].Discrepancy_Party__c);
                }
                discrepancyData_Arr[i].Discrepancy_Party__c = '';
            }
        }
        component.set("v.attributeWrapperObj.discrepancyData" , discrepancyData_Arr);
        
        attributeWrapperObj = component.get("v.attributeWrapperObj");
        //Handling StrVAContact End
        
        var action = component.get("c.addSaveDiscrepancy");
        action.setParams({
            "attributeWrapperObjJSON": JSON.stringify ( attributeWrapperObj ),
            "docType": "LogDiscr"
        }); 
        action.setCallback(this, function( res){
            component.set("v.isProcessing" , false);            
            helper.handleCallbackResponse(component, res, 'Discrepany records saved successfully!', 'Something went wrong...');            
        });
        $A.enqueueAction(action);
    },
    
    onSaveDiscrepancy : function(component, event, helper) {
        component.set("v.isProcessing" , true);
        var attributeWrapperObj = component.get("v.attributeWrapperObj");
        
        var action = component.get("c.saveDiscrepancy");
        action.setParams({
            "attributeWrapperObjJSON": JSON.stringify ( attributeWrapperObj ),
            "docType": "LogDiscr"
        }); 
        action.setCallback(this, function( res){
            component.set("v.isProcessing" , false);
            helper.handleCallbackResponse(component, res, 'Discrepany records saved successfully!', 'Something went wrong...');            
        });
        $A.enqueueAction(action);
    },
    
    onSaveDiscrepancyQC : function(component, event, helper) {
        component.set("v.isProcessing" , true);
        var attributeWrapperObj = component.get("v.attributeWrapperObj");
        
        var action = component.get("c.saveDiscrepancy");
        action.setParams({
            "attributeWrapperObjJSON": JSON.stringify ( attributeWrapperObj ),
            "docType": "DisbDiscr"
        }); 
        action.setCallback(this, function( res){
            component.set("v.isProcessing" , false);            
            helper.handleCallbackResponse(component, res, 'Discrepany records saved successfully!', 'Something went wrong...');
        });
        $A.enqueueAction(action);
    },
    
    onSendEmailPending : function(component, event, helper) {
        component.set("v.isProcessing" , true);
        var attributeWrapperObj = component.get("v.attributeWrapperObj");
        
        var action = component.get("c.sendEmailPending");
        action.setParams({
            "attributeWrapperObjJSON": JSON.stringify ( attributeWrapperObj ),
            "docType": "LogDiscr"
        }); 
        action.setCallback(this, function( res){
            component.set("v.isProcessing" , false);            
            helper.handleCallbackResponse(component, res, 'Communication completed successfully!', 'Something went wrong...');           
        });
        $A.enqueueAction(action);
    },
    
    onSendEmailAll : function(component, event, helper) {
        component.set("v.isProcessing" , true);
        var attributeWrapperObj = component.get("v.attributeWrapperObj");
        
        var action = component.get("c.sendEmailAll");
        action.setParams({
            "attributeWrapperObjJSON": JSON.stringify ( attributeWrapperObj ),
            "docType": "LogDiscr"
        }); 
        action.setCallback(this, function( res){
            component.set("v.isProcessing" , false);            
            helper.handleCallbackResponse(component, res, 'Communication completed successfully!', 'Something went wrong...');            
        });
        $A.enqueueAction(action);
    },
    
    onSendEmail : function(component, event, helper) {
        component.set("v.isProcessing" , true);
        var attributeWrapperObj = component.get("v.attributeWrapperObj");
        
        var action = component.get("c.sendEmail");
        action.setParams({
            "attributeWrapperObjJSON": JSON.stringify ( attributeWrapperObj ),
            "docType": "LogDiscr"
        }); 
        action.setCallback(this, function( res){
            component.set("v.isProcessing" , false);            
            helper.handleCallbackResponse(component, res, 'Communication completed successfully!', 'Something went wrong...');            
        });
        $A.enqueueAction(action);
    },
})