({
	doInit : function(component, event, helper) {
        component.set("v.isProcessing" , true);
        
        var action = component.get("c.initiateData");
        action.setParams({
            "loanId": component.get('v.loanId'),
            "documentType": component.get('v.documentType')              
        });
        action.setCallback(this, function( res){
            component.set("v.isProcessing" , false);
            helper.handleCallbackResponse(component, res, '', 'Something went wrong...');
        });
        $A.enqueueAction(action);
    },
    
    onSaveDocumentStatus : function(component, event, helper) {
        component.set("v.isProcessing" , true);
        var attributeWrapperObj = component.get("v.attributeWrapperObj");
        
        var action = component.get("c.saveTransactionDocuments");
        action.setParams({
            "attributeWrapperObjJSON": JSON.stringify ( attributeWrapperObj )
        }); 
        action.setCallback(this, function( res){
            component.set("v.isProcessing" , false);
            
            helper.handleCallbackResponse(component, res, 'Document status updated successfully!', 'Something went wrong...');
            
        });
        $A.enqueueAction(action);
    },   
})