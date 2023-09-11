({
	onInit : function(component, event, helper) 
    {
        var rId = component.get("v.recordId");
        var action = component.get("c.getGroupType");
        action.setParams({oId: rId} );
        action.setCallback(this, function( res){
            var gType = res.getReturnValue();
            if(gType !== undefined && gType !== null && gType !== '')
            {
                var sVerificationReportURL = '/apex/COVerificationVF?id=' + rId + '&grouptype=' + gType;            
                var s_cpvURL = '/apex/VerificationDetailsPage?id='  + rId;    
                
                component.set("v.verificationReportURL", sVerificationReportURL);
                component.set("v.cpvURL", s_cpvURL);
            }
            else
            {
                var utility = component.find("toastCmp");
                utility.showToast('Error!', 'Something went wrong! Please check with your administrator!' , 'error');                
            }
            
        });
		
        $A.enqueueAction(action);
        
	}
})