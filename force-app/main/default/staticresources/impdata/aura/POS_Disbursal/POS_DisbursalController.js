({
    doinit:function (component,event,helper) {
    
        helper.getAccountType(component);
        helper.getRepaymentMode(component);
       
        
        console.log('value to evalute: '+component.get("v.rmdObj.Mandate_Process_Stage__c"));
        console.log('values '+component.get("v.cddId") + 'test'+component.get("v.rmdId"));
        
        if(helper.isEmpty(component.get("v.cddId")))
            helper.setDisbursmentData(component);
        else{
            component.set('v.isDisbursmentSaved',true);
             var cddObj=JSON.parse(JSON.stringify(component.get('v.cddObj')));    
            component.set('v.oldCddObj', cddObj);
             // 22141 S
            component.set("v.showConfirmAccount",'true');
            //22141 E
        }
        
        if(helper.isEmpty(component.get("v.rmdId")))
        {
            component.set("v.rmdObj.Loan_Application__c",component.get("v.OppObj.Id"));
            component.set("v.rmdObj.PDC_By_Name__c",component.get("v.OppObj.Name"));
            component.set("v.rmdId",component.get("v.rmdId.Id"));
        }
        else
        {
             var rmd=JSON.parse(JSON.stringify(component.get('v.rmdObj')));    
             component.set('v.oldRmdObj', rmd);
             component.set("v.isRepaymentSaved",true);
        } 
        
        if(component.get("v.shouldBeDisable") == true && component.get("v.OppObj").StageName != 'Post Approval Sales')
            helper.disableDisbursalForm(component);
        
        helper.fetchIfscMaster(component);
        helper.setStageIcon(component);
        
        
        // window.setTimeout added for bugId: 22740
        window.setTimeout(
        $A.getCallback(function() {
        helper.updateIsCddRmdBankDetailsSame(component);
        helper.updateEmandateDisabled(component);
        }),1000); 
    },
    
    saveDisbursmentDetails:function (component,event,helper) {
        if(helper.ValidateDisbursdalSection(component)){
             //US: 9537 USERSTORY_IMPS Initiation to be mandatory start
             if(helper.validateIMPSDetails(component,'SaveDisbursalData'))
            helper.saveDisbursmentDetails(component,helper);
        }
    },
    
    saveRepaymentDetails:function (component,event,helper) {
       // debugger
        if(component.get('v.isDisbursmentSaved')){
            if(helper.ValidateRepaymentSection(component)){ 
                // true
               // helper.refreshMandateProcess(component,event,helper);
                
                if(component.get("v.oldRmdObj.Mandate_Process_Stage__c") == "In Progress" || component.get("v.oldRmdObj.Mandate_Process_Stage__c") == "Finished")
                {
                    component.set("v.confirmBoxInvockedFrom","saveRepaymentDetails"); 
                    helper.openConfirmBox(component,event,helper);
                    //component.set("v.isConfirmBoxOpen","true");
                }
                else
                    helper.saveRepaymentDetails(component,helper);
            }
        }
        else{
            helper.ShowToast(component,"Error!", "Disbursement Bank Details should be saved before saving Repayment Bank", "error");
        } 
        
    },
    
    closeConfirmBox: function (component,event,helper){
        helper.closeConfirmBox(component,event,helper);
        //component.set("v.isConfirmBoxOpen","false");
    },
    
    confirmOkTakeAction : function(component,event,helper){
       // debugger
        if(component.get("v.confirmBoxInvockedFrom") == "saveRepaymentDetails")
            helper.saveRepaymentDetails(component,helper);
        else if(component.get("v.confirmBoxInvockedFrom") == "initiateOpenECS")
            helper.initiateOpenECS(component)
        
        helper.closeConfirmBox(component,event,helper);
        //component.set("v.isConfirmBoxOpen","false");
    },
    
    initiateOpenECS : function (component,event,helper) {
        
        if(component.get('v.isDisbursmentSaved')){
            // helper.refreshMandateProcess(component,event,helper);
            if(component.get("v.oldRmdObj.Mandate_Process_Stage__c") == "In Progress" || component.get("v.oldRmdObj.Mandate_Process_Stage__c") == "Finished")
            {
                component.set("v.confirmBoxInvockedFrom","initiateOpenECS");
                helper.openConfirmBox(component,event,helper);
                //component.set("v.isConfirmBoxOpen","true"); 
            }
            else
                helper.initiateOpenECS(component);
        }  
        else
            helper.ShowToast(component,"Error!", "Disbursement Bank Details should be saved before saving Repayment Bank", "error");
        
    },
    
    fetchIfscMaster : function (component,event,helper) {
        helper.fetchIfscMaster(component);
    },
    validateAccNumber : function(component, event, helper) {
        component.set("v.cddObj.Bank_Account__c", (''+component.get("v.cddObj.Bank_Account__c")).replace(/[a-zA-z]/g, ''));
        helper.addRemoveInputError(component, "bankAccountNumber", !component.get("v.cddObj.Bank_Account__c") && "Please Enter Valid Account Number");
        
    },
    setOldbankAcc : function(component, event, helper) {
        
        if (component.get("v.cddObj").Bank_Account__c != component.get("v.oldBnkAcc")) {
            component.set("v.oldBnkAcc", component.get("v.cddObj").Bank_Account__c);
            component.set("v.cddObj.IMPS_Result__c", null);
            component.set("v.cddObj.IMPS_Transaction_No__c", null);
            component.set("v.cddObj.IMPSDateTime__c", null);
        }
    },
    
    setOldIfscValue : function(component, event, helper) {
        
        if (component.get("v.cddObj").IFSC_Code__c != component.get("v.oldIfscCode")) {
            component.set("v.oldIfscCode", component.get("v.cddObj").IFSC_Code__c);
            component.set("v.cddObj.IMPS_Result__c", null);
            component.set("v.cddObj.IMPS_Transaction_No__c", null);
            component.set("v.cddObj.IMPSDateTime__c", null);
        }
    },
    
    sendToBranchOPS : function(component, event, helper) {console.log('fdasjnkl');
      if(helper.ValidateDisbursdalSection(component) && helper.ValidateRepaymentSection(component))
        {
            //6863 USERSTORY_Validations before triggering E-Agreement start
            helper.validateEagreeEappfun(component);
        }
                                                          
                                                         },
    submitToBranchOPSUser :  function(component, event, helper) {
        helper.addRemoveInputError(component, "opsUserList", !component.get("v.SelectedOpsUser") && "Please Select User");
        if(component.get("v.SelectedOpsUser"))
        {
            //added by sachin to check required documents
            helper.verifyDocs(component,'submitToBranchOPSUser');
        }
        
    },
    validateECSBarcode : function(component, event, helper) {
   
        helper.validateECSBarcode(component)
    },
    OpenEAgreement : function (component,event,helper){
        
        
        
    },
    // 22141 S
    confirmDetails :function(component,event,helper){
        console.log('in controller');
        helper.ConfirmBankDetails(component);
    } ,    
    // 22141 E
    calculateDisbursmentAmount : function (component,event,helper){	
        helper.FetchOpportunity(component);
    },
    validateImps : function(component,event,helper) {
        console.log('in here -->', JSON.stringify(component.get("v.cddObj")));
        // First time and if Bank account or IFSC code is changed
        if (
            component.get("v.cddObj").IMPS_Result__c == null || 
            component.get("v.oldIfscCode") != component.get("v.cddObj").IFSC_Code__c ||
            component.get("v.oldBnkAcc") != component.get("v.cddObj").Bank_Account__c
        ) {
            console.log('in here if -->');
            //CR YK start
            console.log('=====>>success '+component.get("v.cddObj").Successful_IMPS_Count__c);
            console.log('=====>>failure '+component.get("v.cddObj").Failure_IMPS_Count__c);
            if(component.get("v.cddObj").Successful_IMPS_Count__c == undefined)
                component.get("v.cddObj").Successful_IMPS_Count__c = 0;
            if(component.get("v.cddObj").Failure_IMPS_Count__c == undefined)
                component.get("v.cddObj").Failure_IMPS_Count__c = 0;
            
            if(component.get("v.cddObj").Successful_IMPS_Count__c < 3 && component.get("v.cddObj").Failure_IMPS_Count__c < 5)	
                helper.invokeCheckIMPS(component);
            else
                helper.ShowToast(component, "Info!", "Validate IMPS Limit Reached!" , "info");
            //CR YK end
        } else if (component.get("v.cddObj").IMPS_Result__c == 'Successful Transaction' || component.get("v.cddObj").IMPS_Transaction_No__c != null) {
            // disable Validate IMPS button
            if(component.find("validateIMPS") != undefined) component.find("validateIMPS")[0].getElement().disabled = true;
        } else if (component.get("v.cddObj").IMPS_Result__c != null && component.get("v.cddObj").IMPS_Result__c != 'Successful Transaction' && component.get("v.cddObj").IMPS_Transaction_No__c == null) {
            // show wait and abort modal
            helper.showHideDiv(component, "alertDialog", true);
        }
    },
    wait : function (component, event, helper) {
        console.log('clicked wait -->');
        // On click of wait
        helper.showHideDiv(component, "alertDialog", false);
        helper.invokeReCheckIMPS(component);
    },
    abort : function (component, event, helper) {
        // disable Validate IMPS button
        helper.showHideDiv(component, "alertDialog", false);
        component.find("validateIMPS")[0].getElement().disabled = true;
    },
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        
        var cmpTarget = component.find('agreement');
        var cmpBack = component.find('ModalbackdropUpload');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
        helper.showHideDiv(component, "agreement", true);
        component.set("v.isEagreementClicked",true);
        
        //Added for E-Sign bugId: 21335
        if(component.get('v.OppObj.Id')!= '0060k000006JwJTAA0')
        helper.saveEAgreementAsPDF(component, event, helper);   
        
    },
    
    /*openConfirmBox: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        
        var cmpTarget = component.find('eMandateConfirmBox');
        var cmpBack = component.find('ModalbackdropeMandateConfirmBox');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
        helper.showHideDiv(component, "eMandateConfirmBox", false);      
    },
    
    closeConfirmBox: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        
        var cmpTarget = component.find('eMandateConfirmBox');
        var cmpBack = component.find('ModalbackdropeMandateConfirmBox');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpBack, 'slds-backdrop--open');
        helper.showHideDiv(component, "eMandateConfirmBox", true);   
    },*/
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        
        var cmpTarget = component.find('agreement');
        var cmpBack = component.find('ModalbackdropUpload');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        helper.showHideDiv(component, "uploadModal", false);
    },
    openOpsModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        
        helper.getOpsChecklistData(component,helper);
        var cmpTarget = component.find('OPSChecklist');
        var cmpBack = component.find('ModalbackdropUploadOps');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
        helper.showHideDiv(component, "OPSChecklist", true);
        
    },
    
    closeOpsModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        var cmpTarget = component.find('OPSChecklist');
        var cmpBack = component.find('ModalbackdropUploadOps');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        helper.showHideDiv(component, "uploadModal", false);
    },
    dateChange: function(component, event, helper){
        console.log("dateChange");
        console.log(component.get("v.rmdObj.ECS_Start_Date__c"));  
    },
    convertToUpperCase: function(component, event, helper){
        helper.convertToUpperCase(component, event, helper);
    },
    
    refreshMandateProcess : function (component, event, helper){
       // disabled="{!v.OppObj.StageName != 'Post Approval Sales' ? 'true':'false'}"
        if(component.get("v.OppObj.StageName") == 'Post Approval Sales')
        helper.refreshMandateProcess(component, event, helper);
    },
    onSelectChange:function(component){
        if(component.get("v.oldRmdObj") && component.get("v.oldRmdObj").Repayment_Mode__c=='SI')
        component.set("v.isDisableEmandate",false);
        else
            component.set("v.isDisableEmandate",true);
        
    },
    
    onChangeRepaymentMode: function(component,event, helper){
        helper.updateEmandateDisabled(component);
    },
     //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement start
    send_E_AggrementDIPOS:function(component, event, helper) {
  //6863 Validations before triggering E-Agreement
        helper.checkValidation(component,event); 
    }
      //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement end
    //Added for E-Sign bugId: 21335
    /*sendMailForEsign:function(component, event, helper){
      helper.sendMailForEsign(component, event, helper);   
    }*/
  
})