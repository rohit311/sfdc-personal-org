({
    
    doInit  : function(component, event, helper) {
        helper.showhidespinner(component,event,true);
        var selectOptions = [];
        selectOptions.push({ value:"Document", label:"Document" });
        selectOptions.push({ value:"Banking", label:"Banking" });
        selectOptions.push({ value:"Eligibility", label:"Eligibility" });
        selectOptions.push({ value:"Employment", label:"Employment" });
        selectOptions.push({ value:"Eligibility", label:"Eligibility" });
        selectOptions.push({ value:"Policy", label:"Policy" });
        selectOptions.push({ value:"Verification", label:"Verification" });
        component.set("v.DependentList", selectOptions);
        console.log('in Doinit on Sanction record ');
        helper.loadDiscrepancyDetails(component,event);
       /* if(component.get('v.discrepancy.OTPDiscrepancyDocuments__c')!=null)
        {
          component.find("documents").set("v.value",component.get('v.discrepancy.OTPDiscrepancyDocuments__c'));     
          component.find("documents").set("v.disabled", false);   
        }*/
        console.log('TINIT '+component.get('v.discrepancy.OTPDiscrepancyDocuments__c') + component.get('v.discrepancy.OTPDiscrepancyCategory__c')+ component.get('v.discrepancy.Status__c') +component.get('v.discrepancy.Resolution_Remarks__c'));
		if(component.get('v.discrepancy.OTPDiscrepancyDocuments__c') ==null && component.get('v.discrepancy.OTPDiscrepancyCategory__c')== null && component.get('v.discrepancy.Status__c')==null && component.get('v.discrepancy.Resolution_Remarks__c')==null)
        {
           
               $A.util.removeClass(document.getElementById('delete'), 'slds-hide');
               $A.util.addClass(document.getElementById('delete'), 'slds-show');
        }
        
    
    },
    getSubPicklist  : function(component, event, helper) {
        helper.showhidespinner(component,event,true);
        helper.getSubPicklist(component, event);
    },
    validateData: function(component){
        var validData = true;
		var dataToVal = ["category","documents","status"];        
        for(var i=0;i<dataToVal.length;i++){
            
            var fieldName = component.find(dataToVal[i]);
            console.log('fieldName'+fieldName);
            if ($A.util.isArray(fieldName)) {
                fieldName.forEach(cmp => {
                    if($A.util.isEmpty(cmp) || !cmp.get("v.validity").valid){
                    cmp.showHelpMessageIfInvalid();
                    validData = false;
                } 
                                  })
            } else {
                if($A.util.isEmpty(fieldName) || !fieldName.get("v.validity").valid){
                    fieldName.showHelpMessageIfInvalid();
                    validData = false;
                }	
            }
        }
        return validData;
        
    },
   
     deleteRecord : function(component, event, helper){
        var discrepancyList = component.get("v.discrepancyList");
        //console.log('posListTU'+posListTU);
        if(discrepancyList.length > 1)
        	discrepancyList.pop();     
        component.set("v.discrepancyList",discrepancyList);
    },
})