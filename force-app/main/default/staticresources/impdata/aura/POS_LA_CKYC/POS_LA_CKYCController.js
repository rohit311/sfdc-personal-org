({
	doInit: function(component, event, helper) {
		helper.getPickListOptionValues(component, event);	
        console.log('pickValue');
        console.log(component.get("v.applicantObject"));
        console.log(component.get("v.applicantObject.CKYC_No__c"));
        console.log('applicant values'+JSON.stringify(component.get("v.applicantObject")));
	},
    
    saveCKYCData: function(component,event,helper)
    {
        var contact = component.get("v.contact");
        var applicantObject = component.get("v.applicantObject");
        var isEmpty, isValid = true;
        // commented contact.Occupation_CKYC__c for Bug Id 24716(not found in UI)
        var lst = [
            // US_27806_CKYC Details to be mandatory
            {value: contact.Marital_Status__c, auraId: "marital_status", message: "Please enter marital status"},	            
            {value: contact.Father_Spouse__c, auraId: "conFatherSpouse", message: "Please enter Father / Spouse value"},
            {value: contact.Father_Spouse_Salutation__c, auraId: "conFatherSpouseSalutation", message: "Please enter Father / Spouse Salutation"},
           // US_27806_CKYC Details to be mandatory
          //  {value: contact.Occupation_CKYC__c, auraId: "o_e_type", message: "Please select a value"},
            {value: applicantObject.Proof_of_Identity__c, auraId: "documentProof", message: "Please select a value"},
            {value: applicantObject.Proof_of_Address_Submitted_for_Permanent__c, auraId: "perm_documet_type", message: "Please select a value"},
            {value: applicantObject.Proof_of_Residence_Address_Submitted__c, auraId: "resi_documet_type", message: "Please select a value"},
            {value: applicantObject.Identity_Document_No__c, auraId: "documentNumber", message: "Please enter a value"}
        ];
        // US_27806_CKYC Details to be mandatory
            var isValid1 = true;
            var isValid2 = true;
            var isValid3 = true;
            var isValid4 = true;
         if(
             helper.isEmpty(component.find('conFatherSpouseFirstNameVal').get('v.value')) ||
             (component.find('conFatherSpouseFirstNameVal').reportValidity() == false)
         ){
             
            component.find('conFatherSpouseFirstNameVal').showHelpMessageIfInvalid();
           isValid1 = false; 
        }
         if(
             helper.isEmpty(component.find('conFatherSpouseLastNameVal').get('v.value')) ||
             (component.find('conFatherSpouseLastNameVal').reportValidity()  == false)
         ){             
            component.find('conFatherSpouseLastNameVal').showHelpMessageIfInvalid();
            isValid2 = false;
        }
        if(
            helper.isEmpty(component.find('motherFirstNameVal').get('v.value')) ||
            (component.find('motherFirstNameVal').reportValidity() == false)
          ){
            
           component.find('motherFirstNameVal').showHelpMessageIfInvalid();
           isValid3 = false; 
        }
        console.log('Needhi --> ' + component.find('motherLastNameVal').reportValidity());
        if(
            helper.isEmpty(component.find('motherLastNameVal').get('v.value')) ||
            (component.find('motherLastNameVal').reportValidity() == false)
        ){
            
        component.find('motherLastNameVal').showHelpMessageIfInvalid();
            isValid4 = false;
            
        }
        console.log('value of isValid1 is-----' + isValid1);
        console.log('value of isValid2 is-----' + isValid2);
        console.log('value of isValid3 is-----' + isValid3);
        console.log('value of isValid4 is-----' + isValid4);
      // US_27806_CKYC Details to be mandatory
        for(var i = 0; i < lst.length; i++){ 
            isEmpty = helper.isEmpty(lst[i].value);
            isValid = isValid && !isEmpty;
            helper.addRemoveInputError(component, lst[i].auraId, isEmpty && lst[i].message);
        }  
        console.log('saveCKYCData'+isValid);
        if(isValid && isValid1 && isValid2 && isValid3 && isValid4) // US_27806_CKYC Details to be mandatory
        {
            helper.callSaveCKYCData(component,event);  
        }
    },
    disablecKycForm : function(component, event, helper) {
        helper.disablecKycForm(component);
    },
    enablecKycForm : function(component, event, helper) {
        helper.enablecKycForm(component);
    },
})