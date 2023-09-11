({
    doInit : function(component, event, helper){
         /* CR 22307 s */
        var stage = component.get("v.stageName");
        if(stage == 'Underwriting' || stage == 'Re-Appraise- Loan amount' || stage == 'Re-Appraise- IRR' || stage == 'Re-Appraise- Reject Case' || stage == 'Re-Appraise- Tenor')
        {
            component.set("v.displayReadOnly",false);
        } 
        else{
            component.set("v.displayReadOnly",true);
        }
        // Bug 23064 start
            if(stage == 'Underwriting' && component.get("v.salesprofilecheck") == true)
            { 
                component.set("v.displayReadOnly",true);
                
            } 
            // Bug 23064 stop
        
        if(component.get("v.displayReadOnly") == true){
            if(component.find("Bank Statements") != undefined){
                var btn = component.find("Bank Statements");
                btn.set('v.disabled',true);
            }
            if(component.find("PERMANENT ADDRESS VERIFICATION") != undefined){
                var btn1 = component.find("PERMANENT ADDRESS VERIFICATION");
                btn1.set('v.disabled',true);
            }
            if(component.find("Residence verification") != undefined){
                var btn2 = component.find("Residence verification");
                btn2.set('v.disabled',true);
            }
            if(component.find("Office verification") != undefined){
                var btn3 = component.find("Office verification");
                btn3.set('v.disabled',true);
            }
           /* component.set("v.bankVerObj",component.get("v.tempVerRec"));
            component.set("v.resPerVerObj",component.get("v.tempVerRec"));
            component.set("v.resCurVerObj",component.get("v.tempVerRec"));
            component.set("v.OfcVerObj",component.get("v.tempVerRec"));*/
        }  /* CR 22307 e */
        var oppId = component.get("v.oppId");
        if(!$A.util.isEmpty(component.get("v.poObj"))){
            var address = ''
            if(!$A.util.isEmpty(component.get("v.poObj.Address_Line_1__c")))
                address = address + component.get("v.poObj.Address_Line_1__c");
            if(!$A.util.isEmpty(component.get("v.poObj.Address_Line_2__c")))
                address = address + component.get("v.poObj.Address_Line_2__c");
            if(!$A.util.isEmpty(component.get("v.poObj.Address_Line_3__c")))
                address = address + component.get("v.poObj.Address_Line_3__c");
            component.set("v.poAddress",address);
        }
        if(!$A.util.isEmpty(component.get("v.accObj"))){
            var address1 = ''
            if(!$A.util.isEmpty(component.get("v.accObj.Current_Residence_Address1__c")))
                address1 = address1 + component.get("v.accObj.Current_Residence_Address1__c");
            if(!$A.util.isEmpty(component.get("v.accObj.Current_Residence_Address2__c")))
                address1 = address1 + component.get("v.accObj.Current_Residence_Address2__c");
            if(!$A.util.isEmpty(component.get("v.accObj.Current_Residence_Address3__c")))
                address1 = address1 + component.get("v.accObj.Current_Residence_Address3__c");
            component.set("v.inputAddress",address1);
        }
       helper.fetchpicklistdata(component,oppId);
    }, 
    saveVerification : function(component, event, helper){
        var oppId = component.get("v.oppId");
       helper.saveVerificationRecords(component,event);
    }, 
    fireVerification : function(component, event, helper){
        var oppId = component.get("v.oppId");
        var verType = event.getSource().getLocalId();
        component.set('v.verType',verType)
      helper.fireVerifications(component);
    },
   toggleAssVersion : function(component, event, helper) {
    	helper.toggleAssVersion(component, event);     
    },
    redirectToVericationReport : function (component, event, helper) {
        if(component.get("v.displayReadOnly") == false)  /* 22307 */
        component.set("v.isVerificationModalOpen", true);
    },
    closeVerificationModel : function (component, event, helper) {
    	component.set("v.isVerificationModalOpen", false);
    },
	redirectToGeoTaggingReport : function (component, event, helper) {
        if(component.get("v.displayReadOnly") == false)  /* 22307 */
    	component.set("v.isGeotaggingModalOpen", true);
    },
    closeGeoTaggingModel : function (component, event, helper) {
    	component.set("v.isGeotaggingModalOpen", false);
    }, 
    DestroyChildCmp: function(component, event, helper) {
        component.set("v.body",'');
        component.destroy();
    }
})