({
    doInit : function(component, event, helper){
       /* CR 22307 s */
        console.log('inside cibil credit ',component.get("v.cibilDashboardData"));
          var stage = component.get("v.stageName");
            if(stage == 'Underwriting' || stage == 'Re-Appraise- Loan amount' || stage == 'Re-Appraise- IRR' || stage == 'Re-Appraise- Reject Case' || stage == 'Re-Appraise- Tenor')
            {
             component.set("v.displayReadOnly",false);
            } 
            else{
            component.set("v.displayReadOnly",true);
            }
          if(component.get("v.displayReadOnly") == true){
            if(component.find("saveButtonId") != undefined){
                var btn = component.find("saveButtonId");
                btn.set('v.disabled',true);
            }
            //component.set("v.secondaryCibilRecs",component.get("v.dummyRec")); // Removed for Bug 24130
        }  /* CR 22307 e */
        // Bug 23064 start
            if(stage == 'Underwriting' && component.get("v.salesprofilecheck") == true)
            {
                component.set("v.displayReadOnly",true);
                
            } 
            // Bug 23064 stop
    },
   
    redirectToViewCibilReport : function (component, event, helper) {
        console.log(component.get("v.cibil.Id"));
        /*24997 added if else*/
        if(component.get("v.theme") == 'Theme4t')
            component.set("v.isViewReportModalOpen", true);
        else
            window.open('/apex/OTPOneViewCIBILpage?id=' + component.get("v.cibil.Id")+'&appId='+component.get("v.applicantObj.Id"),'_blank', 'toolbar=0,location=0,menubar=0');
    },
    closeModel : function (component, event, helper) {
    	component.set("v.isViewReportModalOpen", false);
        component.set("v.showcibilpopup",false );
    },
	redirectToOneViewCibilReport : function (component, event, helper) {
        /*24997 added if else*/
        if(component.get("v.theme") == 'Theme4t')
            component.set("v.isOneViewReportModalOpen", true);
        else
            window.open('/apex/DetailedCibilReportPage?id=' + component.get("v.cibil.Id"),'_blank', 'toolbar=0,location=0,menubar=0'); 
    },
    closeOneViewModel : function (component, event, helper) {
    	component.set("v.isOneViewReportModalOpen", false);
    }, 
    opencibilpopup: function (component, event, helper) {
        if(!$A.util.isEmpty(component.get("v.secondaryCibilRecs")))
    	   component.set("v.showcibilpopup",true );
    }, 
    DestroyChildCmp: function(component, event, helper) {
        component.set("v.body",'');
        component.destroy();
    }

  
})