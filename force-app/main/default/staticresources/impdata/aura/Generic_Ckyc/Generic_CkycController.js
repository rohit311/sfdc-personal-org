({
    doInit: function(component, event, helper) {
        console.log('inside ckyc doinit');
        
        /*  if(component.get("v.appObj.eKYC_Processing__c")==false)
        {
           component.find("addMatchekyc").set("v.disabled",true);
            console.log('make it disable');
        }*/
        
        /* CR 22307 s */
        
        var stage = component.get("v.stageName");
        if(component.get("v.isUWCheck") == true && $A.util.isEmpty(component.get("v.page"))){
            if(stage == 'Underwriting' || component.get("v.loan.Consider_for_Re_Appraisal__c") == true || stage == 'Re-Appraise- Loan amount' || stage == 'Re-Appraise- IRR' || stage == 'Re-Appraise- Reject Case' || stage == 'Re-Appraise- Tenor')
            {
                
            } 
            else{
                if(component.find("saveCKYC") != undefined){
                    var btn2 = component.find("saveCKYC");
                    btn2.set('v.disabled',true);
                }
                if(component.find("saveCKYC1") != undefined){
                    var btn3 = component.find("saveCKYC1");
                    btn3.set('v.disabled',true);
                }
                component.set("v.page","pricing");
                component.set("v.stageName","underwriting");
            }
            
        }
        if($A.util.isEmpty(component.get("v.page")) && component.get("v.stageName") != 'DSA/PSF Login' && component.get("v.isUWCheck") == false) {
            if(component.find("saveCKYC") != undefined){
                var btn = component.find("saveCKYC");
                btn.set('v.disabled',true);
            }
            if(component.find("saveCKYC1") != undefined){
                var btn1 = component.find("saveCKYC1");
                btn1.set('v.disabled',true);
            }
            component.set("v.page","pricing");
            component.set("v.stageName","underwriting");
        } 
        /* if(!$A.util.isEmpty(component.get("v.page")) && component.get("v.page") == 'coApp'){
        if(component.get("v.displayReadOnly") == true){
            
        }
    }*/
        /* CR 22307 e */
        
        if(!component.get("v.isUWCheck"))
            helper.showhidespinner(component,event,true);
        
        helper.getCkycDetails(component,event);
        var isUWCheck = component.get("v.isUWCheck");
        if (isUWCheck)
            helper.disableRadioAddress(component,event);
    },
    onPicklistChange: function(component, event, helper) {
        var createContact = component.get('v.contObj');
        if(createContact.Residence_Type__c == 'Owned by Self/Spouse' 
           || createContact.Residence_Type__c == 'Owned by Parent/Sibling')
            component.set('v.isOwnedTrue',false);
        else      
            component.set('v.isOwnedTrue',true);
    },
    updateNewApp: function(component,event,helper){
        console.log('inside ckyc event');
        var appObj =  event.getParam("appObj");
        var conObj =  event.getParam("conObj");
        var accObj =  event.getParam("accObj");
        component.set("v.accObj", accObj);
        component.set("v.contObj", conObj);
        component.set("v.appObj", appObj);
    },
    callPANBre : function(component,event,helper){
        helper.callPANBre(component,event);    
    },
    saveCKYCData: function(component,event,helper)
    {
        
        var isvalid = true;
        var isPermValid = true;
        var list = [];
        if(component.get("v.forprimeAPP"))
        {
            /*22017 changed conditions below*/
            if(!component.get("v.hideSections")&& !component.get("v.isEmployeeLoan")  ){
                list = [
                    "marital_status","personal_email","gender", "father_spouse", "F_S_salutation", "F_S_firstname", "F_S_lastname", "m_firstname", "m_lastname",
                    "documet_type","resi_type", "doc_number","month_at_resi","addMatchPrevious","addMatchekyc","addMatchPerfios","resi_documet_type"];
            }  
            else if(!component.get("v.isConfirm")){
                list = ["personal_email","resi_type","month_at_resi","addMatchPrevious","addMatchekyc","addMatchPerfios","resi_documet_type"];
            }/*Employee Loan Added by swapnil Bug 20934 s*/
                else if(component.get("v.isEmployeeLoan")==true){
                    list = ["permanetCity","permanetSate","father_spouse", "F_S_salutation", "F_S_firstname", "F_S_lastname", "m_firstname", "m_lastname",
                            "resi_type", "doc_number"];
                }/*Employee Loan Added by swapnil Bug 20934 e*/
                    else
                        list = ["personal_email","resi_type"];  
            
        }
        else{  
            list = ["father_spouse", "F_S_salutation","personal_email", "F_S_firstname", "F_S_lastname", "m_firstname", "m_lastname",
                    "documet_type", "doc_number","resi_type"];  
        }
        console.log('after adding');
        if(!component.get("v.hideSections")){
            var docType = component.find("documet_type").get("v.value");
            if(docType != 'PAN Card' && docType != 'Voters ID card'){
                list.push('doc_expiry_date');
            }
        }
        if((component.get("v.contObj.Residence_Type__c") != 'Owned by Self/Spouse') && 
           (component.get("v.contObj.Residence_Type__c") != 'Owned by Parent/Sibling'))
        {
            list.push('perm_documet_type');
            list.push('Permanent_PinCode');
            list.push('perm_address');
            list.push('perm_address2');
            list.push('perm_address3');
            list.push('month_at_resi');
            
        }
        /*City CR s*/
        if(!component.get("v.validCity") && !$A.util.isEmpty(component.get("v.contObj.Residence_Type__c")) && component.get("v.contObj.Residence_Type__c") != 'Owned by Self/Spouse' && 
           component.get("v.contObj.Residence_Type__c") != 'Owned by Parent/Sibling'){
            helper.displayToastMessage(component,event,'Error','Please enter valid Permanent City','error');  
        }
        else{
            /*City CR e*/
            if(component.get("v.hideresidential")){
                var forDeletion = ['perm_documet_type','resi_type','Permanent_PinCode','perm_address','perm_address2','perm_address3','personal_email'];
                list = list.filter(item => !forDeletion.includes(item));
            }
            for (var i = 0; i < list.length; i++) {
                console.log('list[i]>>' + list[i]);
                console.log(component.find(list[i]));
                if (component.find(list[i]) && !component.find(list[i]).get("v.validity").valid)
                {
                    isvalid = false;
                    component.find(list[i]).showHelpMessageIfInvalid();
                }
            }
            
            if(isvalid && isPermValid)
            {
                helper.showhidespinner(component,event,true);
                helper.saveCKYCData(component,event);  
                /*Added by swapnil  employee loan 20934 */
                if(component.get("v.isEmployeeLoan")==true && component.get("v.isConfirm")==true){
                    //component.set("v.isUWCheck",true);
                    return true;
                }
                /*Added by swapnil  employee loan 20934 e*/
            }
            else
            {
                //helper.displayToastMessage(component,event,'Error','Please fill all required data ','error');
                /*Added by swapnil  employee loan 20934 s*/
                if(component.get("v.isEmployeeLoan")==true && component.get("v.isConfirm")==true){
                    component.set("v.isUWCheck",false);
                    return false;
                }else{
                    console.log('calling error toast....');
                    helper.displayToastMessage(component,event,'Error','Please fill all required data ','error');
                }
                
                /*Added by swapnil  employee loan 20934 e*/                  
            }
        }
        
    },
    copyRsiAddress: function (component, event) {
        var checkCmp = component.get("v.copyresiaddressflag");
        var conObj = component.get("v.contObj");
        if (checkCmp === true) {
            console.log("checkCmpinside" + component.get("v.contObj.Address_1__c"));
            conObj.Permanant_Address_Line_1__c = conObj.Address_1__c;
            conObj.Permanant_Address_Line_2__c = conObj.Address_2__c;
            conObj.Permanant_Address_Line_3__c = conObj.Address_3__c;
            //component.set("v.paramAddress", component.get("v.resiAddress"));
            component.set("v.contObj.Permanent_Pin_Code__c",component.get("v.accObj.PinCode__c"));
            /*City CR s*/
            conObj.Permanent_State__c = component.get("v.accObj.Current_State__c");
            conObj.Permanant_City__c = component.get("v.accObj.Current_City__c");
            component.set("v.citySearchKeyword", component.get("v.accObj.Current_City__c"));
            component.set("v.validCity",true); 
            /*City CR e*/
        } else {
            //component.set("v.paramAddress",component.get("v.paramAddressbackup"));
            conObj.Permanant_Address_Line_1__c = '';
            conObj.Permanant_Address_Line_2__c = '';
            conObj.Permanant_Address_Line_3__c = '';
            component.set("v.contObj.Permanent_Pin_Code__c",component.get("v.permpincodebackup"));
            /*City CR s*/
            conObj.Permanent_State__c = '';
            conObj.Permanant_City__c = '';
            component.set("v.citySearchKeyword", '');
            component.set("v.validCity",false); 
            /*City CR e*/
        }
        component.set("v.contObj",conObj);
    },
    changeAadhaaraddress: function(component, event, helper) {
        helper.changeAadhaaraddress(component,event);
    },
    changePerfiosaddress: function(component, event, helper) {
        helper.changePerfiosaddress(component,event);
    },
    changePOaddress: function(component, event, helper) {
        helper.changePOaddress(component,event);
    },
    //underwriter screen changes start
    areaKeyPressController: function (component, event, helper) {
        console.log('insourcekey');
        helper.startSearch(component, 'area');
    },
    selectArea: function (component, event, helper) {
        var index = event.currentTarget.dataset.record;
        var selectedArea = component.get("v.areaList")[index];
        console.log(selectedArea);
        var keyword = selectedArea.Name;
        
        console.log('keyword>>' + selectedArea);
        component.set("v.selectedArea", selectedArea);
        component.set("v.areaSearchKeyword", keyword);
        component.set("v.accObj.Area_Locality__c", selectedArea.Id);
        component.set("v.accObj.Current_Residence_Address1__c",  selectedArea.Name);
        helper.openCloseSearchResults(component, "area", false);
        component.find("areaName").set("v.errors", [{
            message: ""
        }
                                                   ]);
    },
    //underwriter screen changes end
    /*City CR s*/
    cityKeyPressController: function (component, event, helper) {
        component.set("v.validCity",false);  
        var finalCity = [];
        var cityList = component.get("v.cityList");
        var keyword = component.get("v.citySearchKeyword");
        if (keyword.length > 2){
            for(var i in cityList){
                if(cityList[i].city.toUpperCase().startsWith(keyword.toUpperCase()))
                    finalCity.push(cityList[i]);
            }  
            helper.openCloseSearchResults(component, 'city', true); 
        }
        else if (keyword.length <= 2) {
            helper.openCloseSearchResults(component, 'city', false);    
        }
        console.log('citylist'+finalCity.length);
        component.set("v.finalCity",finalCity);
    },
    selectCity: function (component, event, helper) {
        component.set("v.validCity",true);
        var index = event.currentTarget.dataset.record;
        var selectedCity = component.get("v.finalCity")[index];
        var keyword = selectedCity.city;
        console.log('keyword>>' + keyword);
        component.set("v.selectedCity", selectedCity);
        component.set("v.citySearchKeyword", keyword);
        var contObj = component.get("v.contObj");
        contObj.Permanent_State__c = selectedCity.state;
        contObj.Permanant_City__c = selectedCity.city;
        component.set("v.contObj",contObj);
        helper.openCloseSearchResults(component, 'city', false);    
    },
    /*City CR e*/
    
    validateCkycDetails_POI: function (component, event, helper){
        /**
         * @desc    Called on blur for POI number field and on change of POI field for custom validation
         * @param   component, event, helper
         * @return  NA  
         * @requirement    Bug 23146 - CKYC POI/ POA validation
         */
        console.log('Controller validateCkycDetails_POI');
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
            
            //Apply active validations to CKYC fields
            helper.applyCkycValidation(component, event, true, true); 
        }
    },
    
    
})