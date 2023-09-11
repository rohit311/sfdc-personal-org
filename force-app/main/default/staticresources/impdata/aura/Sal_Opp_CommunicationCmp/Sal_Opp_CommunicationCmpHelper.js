({
    toggleAccordion : function(component,event) {
        var targetId= event.target.getAttribute('id'); 
        console.log('TargetId : '+ targetId);
        if(targetId=="name1Comm" || targetId=="icon1Comm" || targetId=="section1Comm"){
            this.showHideSection(component,"icon1Comm","section1CommContent");
        }else if(targetId=="name1Per" || targetId=="icon1Per" || targetId=="section1Per"){
            this.showHideSection(component,"icon1Per","section1PerContent");
        }
    },
    showHideSection: function(component,iconId,sectionId){
        var i;
        for(i=1 ; i<2; i++){ 
            var icon;
            var section;
            if(iconId == "icon1Comm")
            {
                icon = 'icon'+i+'Comm';
                section = 'section'+i+'CommContent';
            }
            else if(iconId == "icon1Per")
            {
                icon = 'icon'+i+'Per';
                section = 'section'+i+'PerContent';
            }
            console.log('icon : '+ icon);
            if(icon == iconId)
            {
                var x = document.getElementById(icon).innerHTML;
                alert('x++'+x);
                if(x =="[-]")
                {
                    console.log('Hix++'+x);
                    document.getElementById(icon).innerHTML = "[+]";
                }
                else
                {
                    console.log('Byex++'+x);
                    document.getElementById(icon).innerHTML = "[-]";
                }       	
            }
            else
            {
                document.getElementById(icon).innerHTML = "[+]";
            }
            if(section == sectionId)
            {
                $A.util.toggleClass(component.find(section), 'slds-hide'); 
            }else
            {
                $A.util.addClass(component.find(section), 'slds-hide'); 
            }
        }
    },
    closeToastnew: function (component) {
        document.getElementById('successmsg3').innerHTML = "";
        document.getElementById('SuccessToast3').style.display = "none";
    },
    closeToastError: function (component) {
        document.getElementById('errormsg3').innerHTML = "";
        document.getElementById('ErrorToast3').style.display = "none";
    },
    
    displayMessage: function (component, toastid, messageid, message) {
        document.getElementById(toastid).style.display = "block";
        if(component.get('v.theme') == 'Theme4d'){
            var toastClasses = document.getElementById("ErrorToastcomm").classList;
            toastClasses.add("lightningtoast");
            document.getElementById("SuccessToastcomm").classList.add("lightningtoast");  
        }
        document.getElementById(messageid).innerHTML = message;
        console.log('message'+message +component.get('v.theme'));
        
        setTimeout(function () {
            document.getElementById(messageid).innerHTML = "";
            document.getElementById(toastid).style.display = "none";
        }, 3000);
    },
    
    setPermanentAddress: function(component)
    {
        var contactRec = component.get('v.contact');
        var accountRec = component.get('v.account');
        if(component.find("conPermanentAddress") != undefined)
            var permanentAddress = component.find("conPermanentAddress").get("v.value");
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
            if(result[0]){
                contactRec.Permanant_Address_Line_1__c = result[0];
                accountRec.	Permanent_Residence_Address1__c = result[0];
            }
            else{
                contactRec.Permanant_Address_Line_1__c = '';
                accountRec.	Permanent_Residence_Address1__c = '';
            }
            if(result[1]){
                contactRec.Permanant_Address_Line_2__c = result[1];
                accountRec.	Permanent_Residence_Address2__c = result[1];
            }
            else{
                contactRec.Permanant_Address_Line_2__c = '';
                accountRec.	Permanent_Residence_Address2__c = '';
            }
            if(result[2]){
                contactRec.Permanant_Address_Line_3__c = result[2];
                accountRec.	Permanent_Residence_Address3__c = result[2];
            }
            else{
                contactRec.Permanant_Address_Line_3__c = '';
                accountRec.	Permanent_Residence_Address3__c = '';
            }
        }
        console.log('Permanant_Address_Line_1__c' + contactRec.Permanant_Address_Line_1__c);
    },
    setOfficeAddress: function(component)
    {
        var contactRec = component.get('v.contact');
        var officeAddress = component.find("conOfficeAddress").get("v.value");
        if (officeAddress) {
            var result = [], line = [];
            var length = 0;
            officeAddress.split(" ").forEach(function(word) {
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
                contactRec.Address_Line_One__c = result[0];
            else
                contactRec.Address_Line_One__c = '';
            if(result[1])
                contactRec.Address_2nd_Line__c = result[1];
            else
                contactRec.Address_2nd_Line__c = '';
            if(result[2])
                contactRec.Address_3rd_Line__c = result[2];
            else
                contactRec.Address_3rd_Line__c = '';
        }
    },
    showHideDiv: function(component, divId, show){
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
    showSpinner: function (component) {
        this.showHideDiv(component, "waiting", true);
    },
    hideSpinner: function (component) {
        this.showHideDiv(component, "waiting", false);
    },
    
    validateCkycDetails: function(component, event, validatePOIFields){ 
        /**
         * @desc    Validate CKYC fields and add custom validity 
         * @param   component, event
         * 			validatePOIFields - flag indicating whether to validate Indentity Id(POI) field
         * @return  NA  
         * @requirement    Bug 23146 - CKYC POI/ POA validation
         */
        
        try{
            console.log('Helper validateCkycDetails ');
            console.log(validatePOIFields);
            
            //Is CKYCValidation Applicable : Start
            let isCKYCValidationApplicable = false;
            if( component.get('v.oppObj') && component.get('v.oppObj.Id') && component.get('v.oppObj.CreatedDate') ){
                if(typeof CKYC_Validation != "undefined"){
                    if(typeof CKYC_Validation.isCKYCValidationApplicable != "undefined" ){
                        isCKYCValidationApplicable = CKYC_Validation.isCKYCValidationApplicable( component.get('v.oppObj.Id'), component.get('v.oppObj.CreatedDate') );
                    }
                }
            }
            if(!isCKYCValidationApplicable){
                return true;
            }
            //Is CKYCValidation Applicable : End
            
            let isValid = true;
            
            //Validation: Configuration : Start
            let AllMessages, Validation_Details_POI_Number, keywords_document_name;
            if(typeof CKYC_Validation != "undefined"){
                //Get all Validation message details
                if(typeof CKYC_Validation.getAllMessages != "undefined" ){
                    AllMessages = CKYC_Validation.getAllMessages();
                }
                //Get all Validation details for identity document number field
                if(typeof CKYC_Validation.getValidation_Details_Proof_of_ID_Document_Number != "undefined" ){
                    Validation_Details_POI_Number = CKYC_Validation.getValidation_Details_Proof_of_ID_Document_Number();
                }
                //Get all keywords for identity document
                if(typeof CKYC_Validation.getKeywords_Proof_of_ID_Document_Name != "undefined" ){
                    keywords_document_name = CKYC_Validation.getKeywords_Proof_of_ID_Document_Name();
                }
            }
            //Validation: Configuration : End
            
            //Validation: POI Number Field : Start
            if(validatePOIFields){
                let isKeyPresent = false;
                let ele_proof = component.find('documentProof');
                let ele_id = component.find('documentNumber');
                
                if(keywords_document_name && Validation_Details_POI_Number && ele_proof && ele_id){
                    let ele_proof_value = ele_proof.get('v.value');
                    let ele_id_value = ele_id.get('v.value'); 
                    let custom_validation_msg ='';
                    
                    //Resetting maxlength attributes
                    ele_id.set('v.maxlength', null );
                    ele_id.set('v.messageWhenTooLong', null );
                    
                    let isDisabled = false; //Field disabled check
                    if(ele_id.get('v.disabled') && ele_id.get('v.disabled') == true){
                        isDisabled = ele_id.get('v.disabled');
                    }
                    console.log('isDisabled', isDisabled);
                    
                    if(ele_proof_value){
                        ele_proof_value = ele_proof_value.toLowerCase();
                        for(let i=0; i < keywords_document_name.length; i++){
                            let key = keywords_document_name[i];
                            //Check if document name is maintained in ckyc validation script
                            if(ele_proof_value.includes(key) && Validation_Details_POI_Number[key]){
                                isKeyPresent = true;
                                //Apply max length attribute 
                                if( Validation_Details_POI_Number[key].maxlength  ){
                                    ele_id.set('v.maxlength', Validation_Details_POI_Number[key].maxlength );
                                }
                                
                                //Test against valid regex pattern maintained in ckyc validation script 
                                if(ele_id_value && !isDisabled){ //Do not validate if field is disabled 
                                    let pattern = new RegExp(Validation_Details_POI_Number[key].regex_javascript_pattern);
                                    let isValid_current = pattern.test(ele_id_value);
                                    isValid = isValid && isValid_current;
                                    if(!isValid_current){
                                        custom_validation_msg ='Please enter valid ID Number';
                                        //Set message as per message maitained in ckyc validation script
                                        if(AllMessages && Validation_Details_POI_Number[key].validation_msg && AllMessages[Validation_Details_POI_Number[key].validation_msg].message_invalid){
                                            custom_validation_msg = AllMessages[Validation_Details_POI_Number[key].validation_msg].message_invalid;
                                        }
                                    }else{
                                        custom_validation_msg = '';
                                    }
                                }
                                break;
                            }
                        }
                        //Set custom validation to element
                        if(ele_id_value && !isDisabled){ //Do not apply validation if field is disabled
                            ele_id.setCustomValidity(custom_validation_msg);
                            ele_id.reportValidity();  
                        }
                    }
                }
                console.log('After POI Validation : ',isValid);
            }
            //Validation: POI Number Field : End
        }catch(e){
            console.log('Exception in validateCkycDetails ', e);
        }
    },
    
    applyCkycValidation: function(component, event, applyToNameFields, applyToPOIFields){
        /**
         * @desc    Apply active validations for CKYC fields i.e. pattern, maxlength etc. 
         * @param   component, event
         * 			applyToNameFields - flag indicating whether to apply validation to Name fields
         * 			applyToPOIFields - flag indicating whether to apply validation to Indentity Id(POI) field
         * @return  NA  
         * @requirement    Bug 23146 - CKYC POI/ POA validation
         */
        try{
            console.log('applyCkycValidation');
            
            //Is CKYCValidation Applicable : Start
            let isCKYCValidationApplicable = false;
            if( component.get('v.oppObj') && component.get('v.oppObj.Id') && component.get('v.oppObj.CreatedDate') ){
                if(typeof CKYC_Validation != "undefined"){
                    if(typeof CKYC_Validation.isCKYCValidationApplicable != "undefined" ){
                        isCKYCValidationApplicable = CKYC_Validation.isCKYCValidationApplicable( component.get('v.oppObj.Id'), component.get('v.oppObj.CreatedDate') );
                    }
                }
            }
            if(!isCKYCValidationApplicable){
                return true;
            }
            //Is CKYCValidation Applicable : End
            
            //Validation: Configuration : Start
            let Validation_Details_Name_Field,  Validation_Details_POI_Number, keywords_document_name;
            if(typeof CKYC_Validation != "undefined"){ 
                //Get Validation details for name field
                if(typeof CKYC_Validation.getValidation_Details_Name_Field != "undefined" ){
                    Validation_Details_Name_Field = CKYC_Validation.getValidation_Details_Name_Field();
                }
                //Get all Validation details for identity document number field
                if(typeof CKYC_Validation.getValidation_Details_Proof_of_ID_Document_Number != "undefined" ){
                    Validation_Details_POI_Number = CKYC_Validation.getValidation_Details_Proof_of_ID_Document_Number();
                }
                //Get all keywords for identity document
                if(typeof CKYC_Validation.getKeywords_Proof_of_ID_Document_Name != "undefined" ){
                    keywords_document_name = CKYC_Validation.getKeywords_Proof_of_ID_Document_Name();
                }
            }
            //Validation: Configuration : End
            
            //Apply html regex pattern to name fields : Start
            if(applyToNameFields){
                let fields_name = ['conFatherSpouseFirstNameVal', 'conFatherSpouseLastNameVal', 'motherFirstNameVal', 'motherLastNameVal']; 
                for(let i=0; i < fields_name.length; i++){
                    //Get name element
                    let ele_name = component.find(fields_name[i]);
                    if(ele_name){
                        if(Validation_Details_Name_Field && Validation_Details_Name_Field.regex_html_pattern){
                            console.log('applying pattern ', Validation_Details_Name_Field.regex_html_pattern);
                            ele_name.set("v.pattern", Validation_Details_Name_Field.regex_html_pattern);
                        }
                    }
                }
            }
            //Apply html regex pattern to name fields : End
            
            //Apply maxlength to POI fields : Start
            if(applyToPOIFields){
                let ele_proof = component.find('documentProof');
                let ele_id = component.find('documentNumber');
                if(keywords_document_name && Validation_Details_POI_Number && ele_proof && ele_id){
                    let ele_proof_value = ele_proof.get('v.value');
                    let ele_id_value = ele_id.get('v.value');
                    
                    //Resetting maxlength attributes
                    ele_id.set('v.maxlength', null );
                    ele_id.set('v.messageWhenTooLong', null );
                    if(ele_proof_value){
                        ele_proof_value = ele_proof_value.toLowerCase();
                        for(let i=0; i < keywords_document_name.length; i++){
                            let key = keywords_document_name[i];
                            //Check if document name is maintained in ckyc validation script
                            if(ele_proof_value.includes(key) && Validation_Details_POI_Number[key]){
                                //Apply max length attribute 
                                if( Validation_Details_POI_Number[key].maxlength  ){
                                    ele_id.set('v.maxlength', Validation_Details_POI_Number[key].maxlength );
                                }
                                break;
                            }
                        }
                    }
                }
            }
            //Apply maxlength pattern to POI fields : End
        }catch(e){
            console.log('Exception in applyCkycValidation ', e);
        }
    },
    
})