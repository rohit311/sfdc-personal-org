({
    saveContactForCommunication : function(component, event, helper) {
        var createContact = component.get('v.contact'); 
        var isInValidMsg = true;
        var conMaritalStatusId = component.find("conMaritalStatus");
        if(conMaritalStatusId.get("v.validity").valid)
            console.log('conMaritalStatusId'+isInValidMsg);
        else{
            conMaritalStatusId.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var conResidenceTypeId = component.find("conResidenceType");
        if(conResidenceTypeId.get("v.validity").valid)
            console.log('conResidenceTypeId'+isInValidMsg);
        else{
            conResidenceTypeId.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        if(component.get('v.isMonthAtResiRequired') == true)
        {
            var conMonthAtResidenceId = component.find("conMonthAtResidence");
            if(conMonthAtResidenceId.get("v.validity").valid)
                console.log('conMonthAtResidence'+isInValidMsg);
            else{
                conMonthAtResidenceId.showHelpMessageIfInvalid();
                isInValidMsg = false;
            }
        }
        
        console.log('Res++'+component.get("v.contact.Residence_Type__c"));
        if((component.get("v.contact.Residence_Type__c") != 'Owned by Self/Spouse') && 
           (component.get("v.contact.Residence_Type__c") != 'Owned by Parent/Sibling'))
        {
            console.log('conPermanentAddress-Outer');
            var conPermanentAddressId = component.find("conPermanentAddress");
            if(!($A.util.isUndefined(conPermanentAddressId)))
                if(conPermanentAddressId.get("v.validity").valid)
                    console.log('conPermanentAddress'+isInValidMsg);
                else{
                    conPermanentAddressId.showHelpMessageIfInvalid();
                    isInValidMsg = false;
                }
            
            var conPermanentPinCodeId = component.find("conPermanentPinCode");
            if(!($A.util.isUndefined(conPermanentPinCodeId)))
                if(conPermanentPinCodeId.get("v.validity").valid)
                    console.log('conPermanentPinCode'+isInValidMsg);
                else{
                    conPermanentPinCodeId.showHelpMessageIfInvalid();
                    isInValidMsg = false;
                }
        }
        var conOfficeAddressId = component.find("conOfficeAddress");
        if(conOfficeAddressId.get("v.validity").valid)
            console.log('conOfficeAddress'+isInValidMsg);
        else{
            conOfficeAddressId.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var conOfficePinCodeId = component.find("conOfficePinCode");
        if(conOfficePinCodeId.get("v.validity").valid)
            console.log('conOfficePinCode'+isInValidMsg);
        else{
            conOfficePinCodeId.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var conOfficeLandlineNumberId = component.find("conOfficeLandlineNumber");
        if(conOfficeLandlineNumberId.get("v.validity").valid)
            console.log('conOfficeLandlineNumber'+isInValidMsg);
        else{
            conOfficeLandlineNumberId.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var isTotalYearLessValidMsg = true;
        var isTotalYearEqualValidMsg = true;
        if(parseInt(component.get("v.account.Total_Work_Experience_Yrs__c") ) < parseInt(component.get("v.account.Current_experiance_in_Years__c")))
            isTotalYearLessValidMsg = false; 
        else if(parseInt(component.get("v.account.Total_Work_Experience_Yrs__c")) == parseInt(component.get("v.account.Current_experiance_in_Years__c"))){
            if(parseInt(component.get("v.account.Total_Work_Experience_Months__c") ) < parseInt(component.get("v.account.Current_experiance_in_Month__c")))
                isTotalYearEqualValidMsg = false;
        }
        
        //YK CKYC...
        var ckycValidationErrorFlag = false;
        if((component.find("documentProof").get("v.value") == 'Passport' ||  component.find("documentProof").get("v.value") == 'Driving License') && !component.find("docExpirydate").get("v.value"))
        {
            ckycValidationErrorFlag = true;
        }
        
        var mcpFormYear = component.find("mcpFormYearId");
        if(mcpFormYear.get("v.validity").valid)
            console.log('mcpFormYear'+isInValidMsg);
        else{
            mcpFormYear.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        var mcpFormMonth = component.find("mcpFormMonthId");
        if(mcpFormMonth.get("v.validity").valid)
            console.log('mcpFormMonth'+isInValidMsg);
        else{
            mcpFormMonth.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var cmcpForm1 = component.find("mcpForm1");
        if(cmcpForm1.get("v.validity").valid)
            console.log('cmcpForm1'+isInValidMsg);
        else{
            cmcpForm1.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        var cmcpForm2 = component.find("mcpForm2");
        if(cmcpForm2.get("v.validity").valid)
            console.log('cmcpForm2'+isInValidMsg);
        else{
            cmcpForm2.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var conFatherSpouse = component.find("conFatherSpouse");
        if(conFatherSpouse.get("v.validity").valid)
            console.log('conFatherSpouse'+isInValidMsg);
        else{
            conFatherSpouse.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var conFatherSpouseSalutation = component.find("conFatherSpouseSalutation");
        if(conFatherSpouseSalutation.get("v.validity").valid)
            console.log('conFatherSpouseSalutation'+isInValidMsg);
        else{
            conFatherSpouseSalutation.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var conFatherSpouseFirstNameVal = component.find("conFatherSpouseFirstNameVal");
        if(conFatherSpouseFirstNameVal.get("v.validity").valid)
            console.log('conFatherSpouseFirstNameVal'+isInValidMsg);
        else{
            conFatherSpouseFirstNameVal.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var conFatherSpouseLastNameVal = component.find("conFatherSpouseLastNameVal");
        if(conFatherSpouseLastNameVal.get("v.validity").valid)
            console.log('conFatherSpouseLastNameVal'+isInValidMsg);
        else{
            conFatherSpouseLastNameVal.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var motherFirstNameVal = component.find("motherFirstNameVal");
        if(motherFirstNameVal.get("v.validity").valid)
            console.log('motherFirstNameVal'+isInValidMsg);
        else{
            motherFirstNameVal.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var motherLastNameVal = component.find("motherLastNameVal");
        if(motherLastNameVal.get("v.validity").valid)
            console.log('motherLastNameVal'+isInValidMsg);
        else{
            motherLastNameVal.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var documentProof = component.find("documentProof");
        if(documentProof.get("v.validity").valid)
            console.log('documentProof'+isInValidMsg);
        else{
            documentProof.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var documentNumber = component.find("documentNumber");
        if(documentNumber.get("v.validity").valid)
            console.log('documentNumber'+isInValidMsg);
        else{
            documentNumber.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var docExpirydate = component.find("docExpirydate");
        if(docExpirydate.get("v.validity").valid)
            console.log('docExpirydate'+isInValidMsg);
        else{
            docExpirydate.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        helper.setPermanentAddress(component);
        helper.setOfficeAddress(component);
        console.log('Acc+'+JSON.stringify([component.get("v.account")]));
        console.log('Con+'+JSON.stringify([component.get("v.contact")]));
        
        var action = component.get('c.getsaveContactForSalOppComm');
        action.setParams({
            "jsonAccountRecord": JSON.stringify([component.get("v.account")]),
            "jsonContactRecord": JSON.stringify([component.get("v.contact")]),
            "jsonApplicantRecord": JSON.stringify([component.get("v.applicantObject")])
        });
        console.log('conId+'+createContact);
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS')
            {
                console.log('hi');
                component.set("v.disablepage",false);
                //helper.hideSpinner(component);
                helper.displayMessage(component, 'SuccessToast3', 'successmsg3', 'Success! Saved Successfully');     
                
            }
            else if(state == 'ERROR')
            {     
                component.set("v.disablepage",false);
                console.log('Error while creating Contact Record!!');
            }
        });
        
        console.log('Contact Record Saved Successfully!!'+isInValidMsg);
        if(isInValidMsg == true && isTotalYearLessValidMsg == true && isTotalYearEqualValidMsg == true && ckycValidationErrorFlag == false)
        {
            //helper.showSpinner(component);
            component.set("v.disablepage",true);
            console.log('Contact Record Saved Successfully!!');
            $A.enqueueAction(action);
            component.set('v.isMsgShownTrue',true);
        }
        else
        {
            helper.displayMessage(component, 'ErrorToast3', 'errormsg3', 'Error! Please fill all required fields.');
        }
        //YK CKYC 
        if(ckycValidationErrorFlag == true)
            helper.displayMessage(component, 'ErrorToast3', 'errormsg3', 'Error! Please select Identity Document Expiry Date.');
        
        if(isTotalYearLessValidMsg == false)
        {
            if(parseInt(component.get("v.account.Total_Work_Experience_Yrs__c") ) < parseInt(component.get("v.account.Current_experiance_in_Years__c"))){
                
                helper.displayMessage(component, 'ErrorToast3', 'errormsg3', '<b>Error!</b> Total experience cannot be less than current experience.');
            }
        }
        if(isTotalYearEqualValidMsg == false)
        {
            if(parseInt(component.get("v.account.Total_Work_Experience_Yrs__c")) == parseInt(component.get("v.account.Current_experiance_in_Years__c"))){
                if(parseInt(component.get("v.account.Total_Work_Experience_Months__c") ) < parseInt(component.get("v.account.Current_experiance_in_Month__c")))
                {
                    helper.displayMessage(component, 'ErrorToast3', 'errormsg3', '<b>Error!</b> Total experience cannot be less than current experience.');	
                }
            }
        }
    },
    doInit: function(component, event, helper) {
        //alert('Child');
        var loanId = component.get('v.oppId');
        var contact = component.get('v.contact');
        
        console.log('loanId++'+ JSON.stringify(contact) );
        
        //YK CYKC
        var selectOptions = [];
        selectOptions.push({ value:"Passport", label:"Passport" });
        selectOptions.push({ value:"PAN Card", label:"PAN Card" });
        selectOptions.push({ value:"Voters ID card", label:"Voters ID card" });
        selectOptions.push({ value:"Driving License", label:"Driving License" });
        selectOptions.push({ value:"ITR", label:"ITR" });
        selectOptions.push({ value:"Bank Statements", label:"Bank Statements" });
        selectOptions.push({ value:"Shops & Establishment certificate", label:"Shops & Establishment certificate" });
        selectOptions.push({ value:"Trade license certificate", label:"Trade license certificate" });
        selectOptions.push({ value:"SSI regn certificate", label:"SSI regn certificate" });
        selectOptions.push({ value:"Sales Tax/ VAT Reg certificate", label:"Sales Tax/ VAT Reg certificate" });
        selectOptions.push({ value:"Partnership Deed", label:"Partnership Deed" });
        selectOptions.push({ value:"MoA", label:"MoA" });
        selectOptions.push({ value:"Export-Import Code certificate", label:"Export-Import Code certificate" });
        selectOptions.push({ value:"Factory regn certificate", label:"Factory regn certificate" });
        selectOptions.push({ value:"Other", label:"Other" });
        
        component.set("v.docProofList", selectOptions);
        
        /*component.set('v.contact',component.get('v.contact'));
        component.set('v.account',component.get('v.account'));
        component.set('v.totalexpYr',component.get('v.totalexpYr'));
        component.set('v.totalexpMon',component.get('v.totalexpMon'));
        component.set('v.maritalStatusList',component.get('v.maritalStatusList'));
        component.set('v.resTypeList',component.get('v.resTypeList'));
        component.set('v.currentexpYr',component.get('v.currentexpYr'));
        component.set('v.currentexpMon',component.get('v.currentexpMon'));

        console.log('loanId+2+'+JSON.stringify(component.get('v.contact.Address_Line_One__c')));
        console.log('Year++'+JSON.stringify(component.get('v.totalexpYr')));
        */
        
        
        /*var action = component.get('c.getContactData');
        console.log('action++'+action);
        action.setParams({
            fetchLoanApplicationId : loanId 
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS')
            {
                //component.set('v.contact',response.getReturnValue());
                console.log('response.getReturnValue()'+response.getReturnValue());
                helper.fetchPickListVal(component, 'Marital_Status__c', 'conMaritalStatus');
                helper.fetchResTypePickListVal(component, 'Residence_Type__c', 'conResidenceType');
                helper.fetchMCPYearPickListVal(component, 'Total_Work_Experience_Yrs__c', 'mcpFormYearId');
                helper.fetchMCPMonthPickListVal(component, 'Total_Work_Experience_Months__c', 'mcpFormMonthId');
                
                var permanantAdd1 = component.get('v.contact.Permanant_Address_Line_1__c');
                var permanantAdd2 = component.get('v.contact.Permanant_Address_Line_2__c');
                var permanantAdd3 = component.get('v.contact.Permanant_Address_Line_3__c');
                var permanantAdd123 = permanantAdd1;
                if(permanantAdd2 != undefined)
                    permanantAdd123 = permanantAdd1+" "+permanantAdd2;
                if(permanantAdd3 != undefined)
                    permanantAdd123 = permanantAdd1+" "+permanantAdd2+" "+permanantAdd3;
                component.set('v.contact.Permanant_Address_Line_1__c',permanantAdd123);
                
                var officeAdd1 = component.get('v.contact.Address_Line_One__c');
                var officeAdd2 = component.get('v.contact.Address_2nd_Line__c');
                var officeAdd3 = component.get('v.contact.Address_3rd_Line__c');
                var officeAdd123 = officeAdd1;
                if(officeAdd2 != undefined)
                    officeAdd123 = officeAdd1+" "+officeAdd2;
                if(officeAdd3 != undefined)
                    officeAdd123 = officeAdd1+" "+officeAdd2+" "+officeAdd3;
                component.set('v.contact.Address_Line_One__c',officeAdd123);
            }
            else if(state == 'ERROR')
                console.log('Error while creating Contact Record!!');
                });
                */
        
        //$A.enqueueAction(action);
        //alert('Child Finish');
        
        //Bug 23146 - CKYC POI/ POA validation : Start
        try{
            if(component.get('v.oppId') && component.get("c.getCkycDetails")){
                var param = {"oppoId": component.get('v.oppId')};
                var action = component.get("c.getCkycDetails"); 
                action.setParams(param);
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if(state === "SUCCESS"){
                        if(response && response.getReturnValue()){
                            component.set("v.oppObj", response.getReturnValue());
                            
                            //Apply active validations to CKYC fields
                            helper.applyCkycValidation(component, event, true, true); 
                            
                        }
                    } 
                });
                $A.enqueueAction(action);
            }
        }catch(e){
            console.log('Exception ', e);
        }
        //Bug 23146 - CKYC POI/ POA validation : End
        
    },
    onPicklistChange: function(component, event, helper) {
        var createContact = component.get('v.contact');
        if(createContact.Residence_Type__c == 'Owned by Self/Spouse' 
           || createContact.Residence_Type__c == 'Owned by Parent/Sibling')
            component.set('v.isOwnedTrue',false);
        else      
            component.set('v.isOwnedTrue',true);
        
        if(createContact.Residence_Type__c == 'Rented - With friends'
           || createContact.Residence_Type__c == 'Rented - Staying Alone' 
           || createContact.Residence_Type__c == 'Rented - With family'
           || createContact.Residence_Type__c == 'Rented')
            component.set('v.isMonthAtResiRequired',true);
        else      
            component.set('v.isMonthAtResiRequired',false);        
    },
    toggleSecondtab : function(component, event, helper) {
        console.log('hi'+event.target.id);
        helper.toggleAccordion(component,event);
    },
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    },
    hideSpinner : function(component,event,helper){
        component.set("v.Spinner", false);
    },
    closeToastnew: function (component, event, helper) {
        helper.closeToastnew(component, event.target.id);
    },
    closeToastError: function (component, event, helper) {
        helper.closeToastError(component, event.target.id);
    },
    setPermanentAddress: function (component) {
        alert('hi+setPermanentAddress');
        var contactRec = component.get('v.contact');
        alert('hi+setPermanentAddress'+contactRec);
        var permanentAddress = component.find("conPermanentAddress").get("v.value");
        console.log('permanentAddress+'+permanentAddress.length());
        if (permanentAddress) {
            var result = [], line = [];
            var length = 0;
            permanentAddress.split(" ").forEach(function(word) {
                if ((length + word.length) >= 35) {
                    result.push(line.join(" "));
                    line = []; length = 0;
                }
                length += word.length + 1;
                console.log('word'+word);
                line.push(word);
                console.log('line'+line);
            });
            if (line.length > 0) {
                result.push(line.join(" "));
                console.log('final result'+result);
            }
            if(result[0])
            {
                contactRec.Permanant_Address_Line_1__c = result[0];
                //component.set("v.contact.Permanant_Address_Line_1__c", contactRec.Permanant_Address_Line_1__c);
            }
            else
                contactRec.Permanant_Address_Line_1__c = '';
            if(result[1])
            {
                contactRec.Permanant_Address_Line_2__c = result[1];
                //component.set("v.contact.Permanant_Address_Line_2__c", contactRec.Permanant_Address_Line_2__c);
            }
            else
                contactRec.Permanant_Address_Line_2__c = '';
            if(result[2])
                contactRec.Permanant_Address_Line_3__c = result[2];
            else
                contactRec.Permanant_Address_Line_3__c = '';
        }
        console.log('Permanant_Address_Line_1__c' + contactRec.Permanant_Address_Line_1__c);
    },
    
    //YK
    togglePanel : function(component, event, helper) {
        console.log('event.getcource --->> '+event.target.getAttribute('id'));
        var eventSource = event.target.getAttribute('id');
        if(eventSource == 'demogHeaderDiv' || eventSource == 'demogIcon' || eventSource == 'demogLabelSpan')
        {
            var x = document.getElementById('demogIcon').innerHTML;
            if(x =="[-]")
            {
                document.getElementById('demogIcon').innerHTML = "[+]"; 
                $A.util.addClass(component.find("demogSection"), 'slds-hide');
                
                //   document.getElementById('ckycIcon').innerHTML = "[-]";
                //   $A.util.toggleClass(component.find("ckycSection"), 'slds-hide');
            }
            else
            {
                document.getElementById('demogIcon').innerHTML = "[-]";
                $A.util.toggleClass(component.find("demogSection"), 'slds-hide');
                
                document.getElementById('ckycIcon').innerHTML = "[+]"; 
                $A.util.addClass(component.find("ckycSection"), 'slds-hide');
            }
        }else if(eventSource == 'ckycHeaderDiv' || eventSource == 'ckycIcon' || eventSource == 'ckycLabelSpan')
        {
            var x = document.getElementById('ckycIcon').innerHTML;
            if(x =="[-]")
            {
                document.getElementById('ckycIcon').innerHTML = "[+]"; 
                $A.util.addClass(component.find("ckycSection"), 'slds-hide');
                
                //   document.getElementById('demogIcon').innerHTML = "[-]";
                //   $A.util.toggleClass(component.find("demogSection"), 'slds-hide');
            }
            else
            {
                document.getElementById('ckycIcon').innerHTML = "[-]";
                $A.util.toggleClass(component.find("ckycSection"), 'slds-hide');
                
                document.getElementById('demogIcon').innerHTML = "[+]"; 
                $A.util.addClass(component.find("demogSection"), 'slds-hide');
            }
        }
    },
    
    checkRequiredField : function (component, event, helper) {
        var docType = event.getSource().get("v.value");
        console.log('docType ------>> '+docType);
        if(docType == 'Passport' || docType == 'Driving License')
        {
            component.find("docExpirydate").set("v.required", true);
            console.log('---1--->> '+component.find("docExpirydate").get("v.value"));
        }
        else
        {
            component.find("docExpirydate").set("v.required", false);
            console.log('---2--->> '+component.find("docExpirydate").get("v.value"));
        }
        
        helper.validateCkycDetails(component, event, true); //Bug 23146 - CKYC POI/ POA validation
    },
    
    validateCkycDetails_POI: function (component, event, helper){
        /**
         * @desc    Called on blur for POI number field and on change of POI field for custom validation
         * @param   component, event, helper
         * @return  NA  
         * @requirement    Bug 23146 - CKYC POI/ POA validation
         */
        //Call to halper for validation
        helper.validateCkycDetails(component, event, true);
    },
    
    afterScriptsLoaded_CKYCValidation: function (component, event, helper){
        /**
         * @desc    Verify after CKYC Validation script is loaded 
         * @param   component, event, helper
         * @return  NA  
         * @requirement    Bug 23146 - CKYC POI/ POA validation
         */
        
        console.log('Controller afterScriptsLoaded_CKYCValidation ');
        if(typeof CKYC_Validation != "undefined"){ 
            console.log('CKYC Validation script is loaded succesfully!', CKYC_Validation);
            
            
        }
    },
    
})