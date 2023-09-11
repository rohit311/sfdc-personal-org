({
    doInit : function(component, event, helper) {
        component.set("v.isOpen", true);
          /* CR 22307 s */
            var stage = component.get("v.stageName");
            if(component.get("v.isMobilityFlag") && (stage == 'Underwriting' || stage == 'Re-Appraise- Loan amount' || stage == 'Re-Appraise- IRR' || stage == 'Re-Appraise- Reject Case' || stage == 'Re-Appraise- Tenor'))
            {
             component.set("v.displayReadOnly",false);
            } 
            else if(component.get("v.isMobilityFlag")){
            component.set("v.displayReadOnly",true);
            }
            /* CR 22307 e */
			// Bug 23064 start
            if(stage == 'Underwriting' && component.get("v.salesprofilecheck") == true)
            {
                component.set("v.displayReadOnly",true);
                
            } 
            // Bug 23064 stop
        try {
            helper.getData(component);
            helper.getPANCheckStatusData(component, event);
            helper.getCreditObservation(component);
            helper.getConsistProfileName(component);
            console.log('find doInit -->', document.getElementById('a2K0k0000003GU1EAM'));
        } catch(err) {
            console.log('Something went wrong --> '+ err.message + " stack --> " + err.stack);
        }
    },
    closeModalWindow : function(component, event, helper) {
        try {
            if (component.get("v.productNotFound") == 'success') {
                component.destroy();
            } else if (component.get("v.productNotFound") == 'fail') {
                component.destroy();
            }
        } catch(err) {
            alert("Error in closeModalWindow --> " + err.message + " stack --> " + err.stack);
        }
    },
    validatePanBtnClick : function(component, event, helper) {
        event.preventDefault();
        var values = component.get("v.wrapperList");
        console.log("inside validate pan click -->", component.get("v.wrapperList"));
        helper.invokeNsdlApi(component);
    },
    saveBtnClick : function(component, event, helper) {
        helper.saveTatMaster(component, event);
    },
    closeCustomToast: function(component, event, helper){
        helper.closeToast(component);
    },
    doneRendering: function(component, event, helper) {
        if (!component.get("v.isDoneRendering") && component.get("v.wrapperList") != null) {
            for (var j = 0; j<component.get("v.wrapperList").length; j++) {
                var tatValues = component.get("v.wrapperList")[j].tatMasterInstance;
                console.log('in tatValues --> ', tatValues);
                for(var i = 0; i < tatValues.length; i++) {
                    if (document.getElementById(tatValues[i].Id) != null && document.getElementById(tatValues[i].Id) != undefined) {
                        component.set("v.isDoneRendering", true);
                        console.log('auraId id -->', tatValues[i].Id);
                        console.log('auraId PCS -->', tatValues[i].PAN_Check_Status__c);
                        if (tatValues[i].PAN_Check_Status__c != 'Details could not be fetched') {
                            // disable the field
                            console.log('inside if -->');
                            $A.util.addClass(document.getElementById(tatValues[i].Id), 'disable');
                       }
                   }
               }
           }
        }
    },

})