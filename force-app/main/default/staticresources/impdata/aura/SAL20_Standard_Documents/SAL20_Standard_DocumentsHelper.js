({
    
    handleCallbackResponse : function(component, res, successMsg, errorMsg){
        let state = res.getState();
        
        var utility = component.find("toastCmp");        
        if (state === "SUCCESS") {
            // Process server success response
            if ( !res.getReturnValue().startsWith('FAILURE')){ 
                var response = JSON.parse(res.getReturnValue() );
                component.set("v.attributeWrapperObj" , response);
                if(successMsg)
                    utility.showToast('Success!', successMsg, 'success');
            }else{
                if(errorMsg)
                    utility.showToast('Error!', errorMsg+' \n '+res.getReturnValue(), 'error');
            }
        }
        else if (state === "ERROR") {
            // Process error returned by server
            if(errorMsg)
                utility.showToast('Error!', errorMsg, 'error');
        }
    }
})