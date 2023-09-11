({
	doInit: function (component, event, helper) {
		var oppId = component.get("v.loanId");
        /* CR 22307 s */		
            var stage = component.get("v.stageName");
        if(stage == 'Underwriting' || component.get("v.oppObj.Consider_for_Re_Appraisal__c") == true || stage == 'Re-Appraise- Loan amount' || stage == 'Re-Appraise- IRR' || stage == 'Re-Appraise- Reject Case' || stage == 'Re-Appraise- Tenor')
            {
            component.set("v.displayReadOnly",false);
            } 
            else
             component.set("v.displayReadOnly",true);
         /* CR 22307 e */
		 /* Bug 23064 start*/
        //var userprof = component.get("v.salesprofilecheck");
            if(stage == 'Underwriting' && component.get("v.salesprofilecheck") == true)
            {
            component.set("v.displayReadOnly",true);
            } 
        /* Bug 23064 stop*/
	},
    retriggerDedupe: function(component, event, helper) {
        helper.retriggerDedupe(component,event);
    },
    
    retriggerCIBIL: function(component, event, helper) {
        helper.retriggerCIBIL(component,event);
    },
    doEmploymentCheck: function(component, event, helper){
        var pancmp = component.find("pancheck");
        var isEmptyEmailId = pancmp.checkOfficeEmailId();
		if(isEmptyEmailId)
        	helper.doEmpCheck(component, event);
        else
        	helper.displayToastMessage(component,event,'Error','Please Enter Office Email ID','error');
    },
    callPANBre: function(component, event, helper){
        helper.callPANBre(component,event);
    }, 
    saveDispositionRecord : function(component, event, helper){
        var pancmp = component.find("pancheck");
        var isvalid = pancmp.validateCompany();
        if(isvalid)
        	 helper.saveDispositionRecord(component,event);
        else
        	helper.displayToastMessage(component,event,'Error','Please Enter All Mandatory Fields','error');
       
    },
    doEPFOCheck: function(component, event, helper){
        
        helper.doEPFO(component);
        
    },
})