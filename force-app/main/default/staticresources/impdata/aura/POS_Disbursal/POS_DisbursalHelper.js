({
    fetchIfscMaster : function(component) {
        if( component.get("v.cddObj.IFSC_Code__c"))
            this.executeApex(component, "fetchBankDetails", {"ifscCode" : component.get("v.cddObj.IFSC_Code__c")}, function(error, result){
                
                if(!error && result.length>0){
                    component.set("v.cddObj.Bank_Name__c",result[0].Bank__c);
                    component.set("v.cddObj.Bank_Branch__c",result[0].Branch__c);
                    
                    if(result[0].MICR__c != undefined)
                        component.set("v.cddLocalMICRCode",result[0].MICR__c);
                    else
                        component.set("v.cddLocalMICRCode",'');    
                    
                      //this.updateIsCddRmdBankDetailsSame(component);
                }else{
                    component.set("v.cddObj.Bank_Name__c",'');
                    component.set("v.cddObj.Bank_Branch__c",'');
                    component.set("v.cddLocalMICRCode",'');
                    this.ShowToast(component, "Warning!","Please Enter Valid IFSC Code", "warning");
                }
                this.ValidateDisbursdalSection(component)
                
            });
    },
    fetchOPSuserList : function(component) {
        this.executeApex(component, "getOPSUserList", {"product" : component.get("v.OppObj.Product__c"),"branch" : component.get("v.OppObj.BranchName__c"),"LoanAppFlow" : component.get("v.OppObj.Loan_Application_Flow__c")}, function(error, result){
            if(!error && result.length>0){
                this.setOPSSelectOptions(component, result, "User", "opsUserList");
            }
        });
    },
    setOPSSelectOptions: function(component, data, label, cmpId){
        var opts = [{"class": "optionClass", label: "Select " + label, value: ""}];
        for(var i=0; i < data.length; i++){
            opts.push({"class": "optionClass", label: ''+data[i].Name, value: data[i].Id});
        }
        component.find(cmpId).set("v.options", opts);
    },
    ShowToast : function(component, title, message, type){
        var ShowToastEvent = $A.get("e.c:ShowToastEvent");
        console.log('ShowToastEvent -->' + ShowToastEvent);
        ShowToastEvent.setParams({
            "title": title,
            "message":message,
            "type":type,
        });
        ShowToastEvent.fire();
    },
    showHideDiv: function(component, divId, show){
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
    addRemoveInputError: function(component, key, message){
        component.find(key).set("v.errors", [{message: message ? (message) : ""}]);
    },
      //US: 9537 USERSTORY_IMPS Initiation to be mandatory start
     validateIMPSDetails : function(component,identifier)
    {
       console.log('inside validateIMPSDetails imps result'+component.get("v.cddObj").IMPS_Transaction_No__c);
        var valid = true;
      if (component.get("v.cddObj").IMPS_Transaction_No__c == null || component.get("v.cddObj").IMPS_Transaction_No__c == '') {
     if(identifier=='SaveDisbursalData')
          this.ShowToast(component,"Error!", "Kindly Validate IMPS to save Disbursement Bank Details", "error");
     else if(identifier=='submitToBranchOps')
         this.ShowToast(component,"Error!", "Kindly Validate IMPS before Submit to Branch Ops", "error");
          valid= false;     
      }
        else
        {
            valid= true;
        }
        console.log('inside validateIMPSDetails valid flag is==>'+valid);
        return valid;
	},
     //US: 9537 USERSTORY_IMPS Initiation to be mandatory start
    saveDisbursmentDetails : function(component,helper){
        component.get("v.cddObj").Loan_Application__c = component.get("v.OppObj.Id");
        console.log('cdd'+component.get("v.cddObj"));
        this.executeApex(component, "saveCurrentDisbDetails", {"currentDisbursalDetails" :component.get("v.cddObj")}, function(error, result){
            console.log(result);
            if(!error && result)
            {
                if(result.errorMsg == '')
                {
                    this.ShowToast(component, "Success!", 'Disbursement Details Saved Successfully', "success");
                    //22141 S
                    component.set("v.showConfirmAccount",'true');
                    //22141 E
                    component.set("v.oldIfscCode", component.get("v.cddObj").IFSC_Code__c);
                    component.set("v.oldBnkAcc", component.get("v.cddObj").Bank_Account__c);
                    component.set("v.isDisbursmentSaved",true);
                    component.set("v.cddObj",result.cddObj);
                    var cddObj=JSON.parse(JSON.stringify(component.get('v.cddObj')));  
                    component.set("v.oldCddObj",cddObj);
                    //this.updateIsCddRmdBankDetailsSame(component);
                    this.updateEmandateDisabled(component);
                }
                else
                    this.ShowToast(component, "Error!", result.errorMsg , "error");
            }
            
        });
        
        component.get("v.rmdObj").Loan_Application__c = component.get("v.OppObj.Id");
        console.log('repayment'+JSON.stringify(component.get("v.rmdObj"))); 
    },
    
  //22141 S
  ConfirmBankDetails: function(component){
      console.log('helper');
        this.executeApex(component, "ConfirmBankDetails", {"OppId" :  component.get("v.OppObj.Id")}, function(error, result){
			console.log(result);
            if(!error && result){
                if(result.includes('already') === true){
                    this.ShowToast(component, "Info!", result , "info");
                }
                else{
                    this.ShowToast(component, "Success!", result , "success");
                }
              
            }
			else
			{
              this.ShowToast(component, "Error!", result , "error");
            }
        });
    },
  // 22141 E  
    sendToBranchOPS : function(component,helper){
        this.executeApex(component, "submitToBranchOPS", {"loanId" :  component.get("v.OppObj.Id"),'StrCOAppr' : component.get("v.SelectedOpsUser")}, function(error, result){
            console.log(result);
            result = JSON.parse(result);
            if(!error && result.status == 'Success'){
                this.ShowToast(component, "Success!", result.message , "success");
                // here, on success loan stage will be Branch Ops
                this.triggerDisableFormEvent(component, 'Branch Ops');
                var oppoObject = component.get("v.OppObj");
                oppoObject.StageName = 'Branch Ops';
                component.set("v.OppObj", oppoObject);
                this.disableDisbursalForm(component);
                //Bug 19948 start
                this.showHideDiv(component,"submitToBranchOPSDiv",false);
                component.set("v.isRepaymentSaved",false);
                component.set("v.isDisbursmentSaved",false);
                this.updateEmandateDisabled(component);
                //Bug 19948 end
            }else{
                this.ShowToast(component, "Error!", result.message , "error");
            }
        });
    },
    triggerDisableFormEvent: function(component, loanStage){
        var event = $A.get("e.c:DisableFormEvent");
        event.setParams({"loanStage": loanStage});
        event.fire();
    },
    
    saveRepaymentDetails : function(component,helper){
        
        this.updateIsCddRmdBankDetailsSame(component);
        
        if(component.get("v.rmdObj.Repayment_Mode__c") == "SI"){
            this.setUpRmdDataEMandate(component,helper);
            this.serverCallToSaveRepaymentDetails(component,helper);
        }
        else if(component.get("v.rmdObj.Repayment_Mode__c") == "ECS"){
            
            if(component.get('v.rmdObj.Open_ECS_Facility__c') == "Existing" && component.get('v.isCddRmdBankDetailsSame') == false){
                this.ShowToast(component,"Error!", "Disbursement bank details must be same as Repayment Bank details,Please click on Initiate Open ECS followed by Save Details", "error");}
            else{
                // Need to confirm if the below if condition is required
                if(component.get('v.rmdObj.Open_ECS_Facility__c') != "Existing"){
                    this.setUpRmdDataForPysicalNACH(component);}
                
                this.serverCallToSaveRepaymentDetails(component,helper);
            }
            
        }
    },
    
    
    
    serverCallToSaveRepaymentDetails : function(component,helper) {
        
        component.set("v.rmdObj.Open_ECS_Ex_Customer_Id__c", component.get("v.OppObj.CUSTOMER__r.Name"));
        component.set("v.rmdObj.Loan_Application__c",component.get("v.OppObj.Id"));
        //component.get("v.rmdObj").Loan_Application__c = component.get("v.OppObj.Id");     
        
        this.executeApex(component, "saveRepaymentDetailsCtrl", {"repaymentDetails" :component.get("v.rmdObj")}, function(error, result){
            console.log(result);
            debugger
            if(!error && result)
            {
                if(result.errorMsg == '')
                {
                    this.ShowToast(component, "Success!", 'Repayment Details Saved Successfully', "success");
                    component.set("v.isRepaymentSaved",true);
                    component.set("v.rmdObj",result.rdObj);
                      var rmd=JSON.parse(JSON.stringify(result.rdObj)); 
                    component.set("v.oldRmdObj",rmd);
                    this.setStageIcon(component);
                    this.updateEmandateDisabled(component);
                }
                else{
                   if(result.errorMsg!=null && result.errorMsg.includes('E-Mandate is Initiated'))
                        result.errorMsg = "E-Mandate is Initiated. Hence you cannot change Bank details, until it finishes off";
                    else
                       result.errorMsg = "An error occured while saving record."; 
                        
                    this.ShowToast(component, "Error!", result.errorMsg , "error");}
            }
            
            this.removeVlaidationMessage(component);
        });
        
    },
     //6863 Validations before triggering E-Agreement S
     checkValidation :  function(component,event){
        this.executeApex(component, "CheckFeesAndCharges", {"oppId" :component.get("v.OppObj.Id")}, function(error, result){
            console.log('1>>>>',result);
             component.set("v.isFeesAndCharges",result);
            if(!error && result) {
               
            }
            console.log('1s>>>>',component.get("v.isFeesAndCharges"));
            this.executeApex(component, "CheckApplicantImg", {"oppId" :component.get("v.OppObj.Id")}, function(error, result){
                console.log('2>>>>',result);
                 component.set("v.isApplicantImg",result);
                if(!error && result) {
                   
                }
                console.log('2s>>>>',component.get("v.isApplicantImg"));
               
                var errMsg ='';
                if(component.get("v.isFeesAndCharges") && component.get("v.isApplicantImg")){
                    this.sendEaggrementDIPOSHelper(component,event);
                }else{            
                    if(!component.get("v.isFeesAndCharges"))
                        errMsg = "Fees & Charges are not saved. ";
                    if(!component.get("v.isApplicantImg"))
                        errMsg = errMsg + "Customer Photo is not uploaded.";
                    this.ShowToast(component,"Error!",errMsg , "error");
                    //alert(errMsg);            
                }            
            });
        });
        
        
    },
    //6863 Validations before triggering E-Agreement E
    getRepaymentMode : function(component)
    {
        var optionsList = ["ECS","SI"];
        this.setSelectOptions(component, optionsList, "Repayment Mode", "repaymentMode");
        
        if(this.isEmpty(component.get("v.rmdId")))
           component.set("v.rmdObj.Repayment_Mode__c", "ECS")
    },
    
    getAccountType :  function(component){
        this.executeApex(component, "getAccountType", {}, function(error, result){
            if(!error && result){
                console.log('resultsq');
                console.log(result);
                this.setSelectOptions(component, result, "Account Type", "accountType");
            }
        });
    },
    
    setSelectOptions: function(component, data, label, cmpId){
        var opts = [{"class": "optionClass", label: "Select " + label, value: ""}];
        for(var i=0; i < data.length; i++){
            opts.push({"class": "optionClass", label: ''+data[i], value: data[i]});
        }
        component.find(cmpId).set("v.options", opts);
    },
    
    initiateOpenECS : function(component){
        console.log('----->> '+component.get("v.OppObj.CUSTOMER__c"));
        if(component.get("v.OppObj.CUSTOMER__c")){
            this.executeApex(component, "checkCustomerRec", {"opp" : component.get("v.OppObj.Id")}, function(error, result){
                if(!error && result){
                    debugger
                    if(result.ecsErrMsg != "null"){	
                        this.ShowToast(component, "Error!", result.ecsErrMsg , "error");
                    }else{
                        
                        var oppObj = component.get("v.OppObj");
                        var cddObj = component.get("v.cddObj");
                        var rmdObj = component.get("v.rmdObj");
                        var emiAmount = 0;
                        if(oppObj.EMI_CAM__c)
                            emiAmount = parseFloat(oppObj.EMI_CAM__c);
                        if(oppObj.Insurance_Premium_Amt__c)
                            emiAmount += parseFloat(oppObj.Insurance_Premium_Amt__c);
                        //condition 2
                        
                        if(parseFloat(result.balLimit) >=  emiAmount){
                            //condition 3
                            
                            if(result.accNo === cddObj.Bank_Account__c && result.ifscCode === cddObj.IFSC_Code__c && result.micrCode == component.get("v.cddLocalMICRCode") && result.bankName === cddObj.Bank_Name__c)
                            { 
                                this.setUpRmdDataForSuccessEcs(component,result);
                                this.ShowToast(component, "Success!", "Customer Details Fetched Successfully" , "success");
                                
                            }else{
                                this.setUpRmdDataForPysicalNACH(component);
                                this.ShowToast(component, "Error!", "No Active Mandate of Disbursement bank is found. Kindly arrange for Fresh Mandate Registration!" , "error");
                            }
                            
                        }else{
                            this.setUpRmdDataForPysicalNACH(component);
                            this.ShowToast(component, "Error!", "ECS Limit is Less than EMI. Kindly arrange for Fresh Mandate Registration!" , "error");
                        }
                        this.saveRepaymentDetails(component,this);
                    }
                }
                
            });
        }else{
            this.setUpRmdDataForPysicalNACH(component);
            this.ShowToast(component, "Error!", "Customer ID is not present. Kindly arrange for Fresh Mandate Registration!" , "error");
        }
    },
    
    
    // Setting E-Mandate (Grid1) Data For Rmd record 
    setUpRmdDataEMandate : function(component){
        
        var myDate = new Date(); 
        myDate.setFullYear(myDate.getFullYear() + 20);
        var myDate1 = myDate.toISOString().slice(0,10);
        var oppObj = component.get("v.OppObj");
        var cddObj = component.get("v.cddObj");
        debugger
        var emiAmount = 0;
        if(oppObj.EMI_CAM__c)
            emiAmount = parseFloat(oppObj.EMI_CAM__c);
        if(oppObj.Insurance_Premium_Amt__c)
            emiAmount += parseFloat(oppObj.Insurance_Premium_Amt__c);
        
        component.set("v.rmdObj.Open_ECS_Facility__c","Yes");
        component.set("v.rmdObj.Open_Valid_till__c", myDate1);
        component.set("v.rmdObj.Open_ECS_Max_Limit__c", parseInt(emiAmount) * 10);
        component.set("v.rmdObj.ECS_End_Date__c", myDate1);
        component.set("v.rmdObj.ECS_Amount__c", parseInt(emiAmount) * 10);
        component.set("v.rmdObj.Account_Holder_Name__c", cddObj.Favouring__c);
        component.set("v.rmdObj.Repayment_Mode__c", "SI");
        component.set("v.rmdObj.A_C_NO__c",cddObj.Bank_Account__c);
        component.set("v.rmdObj.Bank_Name__c", cddObj.Bank_Name__c);
        
        component.set("v.rmdObj.Bank_Branch__c", cddObj.Bank_Branch__c);
        component.set("v.rmdObj.IFSC_Code__c", cddObj.IFSC_Code__c);
        component.set("v.rmdObj.MICR_Code__c", component.get("v.cddLocalMICRCode"));
        component.set("v.rmdObj.Mandate_Process_Stage__c",'Initiated');
        component.set("v.rmdObj.Mandate_Process_Status__c",'');
        component.set("v.rmdObj.UMRN__c",'');
        
        // Added for delete insert of Repayment Object
        component.set("v.rmdObj.ECS_Start_Date__c",component.get("v.OppObj.Due_Day__c"));
       
        
    },
    
    // Setting Successful “Initiate Open ECS” (Grid2) Data For Rmd record 
    setUpRmdDataForSuccessEcs : function(component,result){
        
        var mapAccType={'Savings':'Savings A/c','Current':'Current A/c','OD':'OD','CC':'CC'};
        var rePayObj = component.get("v.rmdObj");
        component.set("v.rmdObj.Open_ECS_Facility__c","Existing");
        rePayObj.A_C_NO__c = result.accNo;
        rePayObj.MICR_Code__c= parseInt(result.micrCode);
        rePayObj.IFSC_Code__c=result.ifscCode;
        rePayObj.Bank_Name__c=result.bankName;
        rePayObj.Bank_Branch__c=result.branchName;
        rePayObj.A_C_Type__c=mapAccType[result.accTYPE];
        rePayObj.Account_Holder_Name__c=result.customerName;
        rePayObj.ECS_End_Date__c= new Date(Date.parse(result.endDate));
        rePayObj.Open_ECS_Max_Limit__c= parseFloat(result.balLimit);
        rePayObj.Repayment_Mode__c = "ECS";
        component.set("v.rmdObj",rePayObj); 
        component.set("v.rmdObj.Mandate_Process_Stage__c",'');
        component.set("v.rmdObj.Mandate_Process_Status__c",'');
        
        // Added for delete insert of Repayment Object
        component.set("v.rmdObj.ECS_Start_Date__c",component.get("v.OppObj.Due_Day__c"));
        
    },
    
    // Setting  Physical NACH (Grid3) Data For Rmd record 
    setUpRmdDataForPysicalNACH : function(component){
        
        var myDate = new Date(); 
        myDate.setFullYear(myDate.getFullYear() + 20);
        var myDate1 = myDate.toISOString().slice(0,10);
        var oppObj = component.get("v.OppObj");
        var cddObj = component.get("v.cddObj");
        
        var emiAmount = 0;
        if(oppObj.EMI_CAM__c)
            emiAmount = parseFloat(oppObj.EMI_CAM__c);
        if(oppObj.Insurance_Premium_Amt__c)
            emiAmount += parseFloat(oppObj.Insurance_Premium_Amt__c);
        
        component.set("v.rmdObj.Open_ECS_Facility__c","Yes");
        component.set("v.rmdObj.Open_Valid_till__c", myDate1);
        component.set("v.rmdObj.Open_ECS_Max_Limit__c", parseInt(emiAmount) * 10);
        component.set("v.rmdObj.ECS_End_Date__c", myDate1);
        component.set("v.rmdObj.ECS_Amount__c", parseInt(emiAmount) * 10);   
        component.set("v.rmdObj.Account_Holder_Name__c", cddObj.Favouring__c);
        component.set("v.rmdObj.Repayment_Mode__c", "ECS");
        component.set("v.rmdObj.A_C_NO__c",cddObj.Bank_Account__c);
        component.set("v.rmdObj.Bank_Name__c", cddObj.Bank_Name__c);       
        
        component.set("v.rmdObj.Bank_Branch__c", cddObj.Bank_Branch__c);
        component.set("v.rmdObj.IFSC_Code__c", cddObj.IFSC_Code__c);
        component.set("v.rmdObj.MICR_Code__c", component.get("v.cddLocalMICRCode"));
        component.set("v.rmdObj.Mandate_Process_Stage__c",'');
        component.set("v.rmdObj.Mandate_Process_Status__c",'');
        
        // Added for delete insert of Repayment Object
        component.set("v.rmdObj.ECS_Start_Date__c",component.get("v.OppObj.Due_Day__c"));
    },
    
    validateDisbursalTab : function(component){
        var valid = true;
        
        return valid;
    },
    
    ValidateDisbursdalSection : function(component){
        
        var disbursalObj = component.get("v.cddObj");
        var isEmpty, isValid = true;
        var lst = [
            {value: disbursalObj.Favouring__c, auraId: "favouring", message: " Please Enter Name"},
            {value: disbursalObj.Bank_Account__c, auraId: "bankAccountNumber", message: " Please Enter Bank Account Number"},
            {value: disbursalObj.IFSC_Code__c, auraId: "ifscCode", message: "Please Enter IFSC Code"},
            {value: disbursalObj.Bank_Name__c, auraId: "bankName", message: "Bank Name Not Available For Entered IFSC "},
            {value: disbursalObj.Bank_Branch__c, auraId: "branckName", message: "Bank Branch Not Available For Entered IFSC"},
            {value: component.get("v.cddLocalMICRCode"), auraId: "micrCode", message: "MICR Code Not Available For Entered IFSC"}
        ]
        
        for(var i = 0; i < lst.length; i++){ 
            isEmpty = this.isEmpty(lst[i].value);           
            isValid = isValid && !isEmpty;
            this.addRemoveInputError(component, lst[i].auraId, isEmpty && lst[i].message);
        }
        
        return isValid;
    },
    
    // Optimization for the below function is needed -- Harshal
    validateECSBarcode :  function(component){
        console.log(component.get("v.rmdObj.Open_ECS_Facility__c"));
        console.log(component.get("v.rmdObj.PDC_By_Name__c"));
        if(component.get("v.rmdObj.Open_ECS_Facility__c") != "Yes" && component.get("v.rmdObj.Open_ECS_Facility__c")  != undefined && component.get("v.rmdObj.Open_ECS_Facility__c")  != "")
            return true;
        
        var barno = component.get("v.rmdObj.ECS_Barcode_No__c");
        if(barno.length != 10)
        {
            this.addRemoveInputError(component, "ecsBarcode", "Enter the correct Barcode No...Length must be 10 character");
            return false;
        }   
        else
        {	if(barno.includes(" "))
        {
            this.addRemoveInputError(component, "ecsBarcode", "Barcode number must not include white spaces");
            return false;
        }
         else
         {
             var Regex1 =    new RegExp("^[0-9]{8}");
             if(Regex1.test(barno.substr(0,8))==false)
             {
                 this.addRemoveInputError(component, "ecsBarcode", "Enter correct value for barcode no...First 9 characters must be Numbers");
                 return false;
             }
             else
             {
                 var Regex2 = new RegExp("^[A-Z 0-9 ! @ # $ / ^ % &]");
                 if(Regex2.test(barno.substr(9,1))==false)
                 {
                     this.addRemoveInputError(component, "ecsBarcode", "Enter correct value for barcode no?Last Character must be either alphanumeric in upper case or contain one of the special characters(!, @, #, $, /, ^, %, &)");
                     return false;
                 }
                 else
                 {
                     var  total = 0;
                     for(var j=0;j<9;j++)
                     {
                         
                         total += parseInt(barno.substr(j,1));
                     }
                     
                     
                     var checkSumMaster = {"0":"0","1":"1","2":"2","3":"3","4":"4","5":"5","6":"6","7":"7","8":"8","9":"9","10":"A","11":"B","12":"C","13":"D","14":"E","15":"F","16":"G","17":"H","18":"I","19":"J","20":"K","21":"L","22":"M","23":"N","24":"O","25":"P","26":"Q","27":"R","28":"S","29":"T","30":"U","31":"V","32":"W","33":"X","34":"Y","35":"Z","36":"!","37":"@","38":"#","39":"$","40":"/","41":"^","42":"%" };
                     var modValue = total % 43;
                     console.log(checkSumMaster[modValue]);
                     if((barno.substr(9,1))!=checkSumMaster[modValue])
                     {
                         this.addRemoveInputError(component, "ecsBarcode", "The entered barcode number have wrong checksum bit");
                         return false;
                     }else{
                         
                         this.addRemoveInputError(component, "ecsBarcode", false && "");
                         return true;
                     }  
                     
                 }
             } 
         }
        }
    },
    ValidateRepaymentSection : function(component){
        var repaymentObj = component.get("v.rmdObj");
        var isEmpty, isValid = true;
        var lst = [
            //{value: repaymentObj.ECS_Barcode_No__c, auraId: "ecsBarcode", message: "Enter Barcode Number"},
            //{value: repaymentObj.ECS_Start_Date__c, auraId: "firstDueDate", message: "Enter First Due Date"},
            {value: repaymentObj.A_C_Type__c, auraId: "accountType", message: "Select Account Type"},
            {value: repaymentObj.Repayment_Mode__c, auraId: "repaymentMode", message: "Select Repayment Mode"},
            {value: repaymentObj.PDC_By_Name__c, auraId: "pdcByName", message: "Enter name"}]
        //debugger
        if( component.get("v.rmdObj.Repayment_Mode__c") == "ECS" && component.get("v.rmdObj.Open_ECS_Facility__c") == "Yes")
            lst.push({value: repaymentObj.ECS_Barcode_No__c, auraId: "ecsBarcode", message: "Enter Barcode Number"});
        
        
        for(var i = 0; i < lst.length; i++){
            isEmpty = this.isEmpty(lst[i].value);
            isValid = isValid && !isEmpty;
            this.addRemoveInputError(component, lst[i].auraId, isEmpty && "Please "+lst[i].message);
            console.log('----lst[i].value--->> '+lst[i].value);
        }
        
        if(component.get("v.rmdObj.Repayment_Mode__c") == "ECS" && component.get("v.rmdObj.Open_ECS_Facility__c") == "Yes")
            isValid = isValid && this.validateECSBarcode(component);
        
        return isValid;
    },
    
    removeVlaidationMessage : function (component){
        var lst = [{ auraId: "accountType", message: ""},
                   { auraId: "repaymentMode", message: ""},
                   { auraId: "pdcByName", message: ""},
                   { auraId: "ecsBarcode", message: ""}           
       ]
        
        for(var i = 0; i < lst.length; i++){
            this.addRemoveInputError(component, lst[i].auraId, lst[i].message);
        }
    },
    
    
    isEmpty: function(value){
        return ($A.util.isEmpty(value) || $A.util.isUndefined(value) || value === 0);
    },
    
    setDisbursmentData :  function(component){
        console.log('==favouring==>> '+component.get("v.OppObj.Name"));
        component.set("v.cddObj.Favouring__c",component.get("v.OppObj.Name"));
        component.set("v.cddObj.Disbursal_Mode__c",'RTGS');
        var DisbDate = new Date();
        DisbDate = DisbDate.toISOString();
        DisbDate = DisbDate.slice(0,10);
        console.log('disbdate'+DisbDate);
        component.set("v.cddObj.Disbursement_Date__c",DisbDate);
        component.set("v.cddObj.Loan_Application__c",component.get("v.OppObj.Id"));
        component.set("v.cddId",component.get("v.cddObj.Id"));    
        this.FetchOpportunity(component);
        console.log('==favouring 222==>> '+component.get("v.cddObj.Favouring__c"));
    },
    FetchOpportunity : function(component){
        this.executeApex(component, "queryData", {"oppId" : component.get("v.recordId")}, function(error, result) {
            if(!error && result) {
                component.set("v.OppObj",result[0]);
                this.calculateDisbursmentAmount(component);	
            }
        });
    },
    calculateDisbursmentAmount : function(component){
        
        if(component.get("v.feesNChargesListParent")){
            var feesLst = component.get("v.feesNChargesListParent");
            var totalchargeAmount = 0;
            
            for(var i =0 ;i<feesLst.length;i++){
                totalchargeAmount += feesLst[i].Change_Amount__c;
                console.log('fdsaf'+feesLst[i].Change_Amount__c);
            }
            console.log('totalchargeAmount==>'+totalchargeAmount);
            console.log(component.get("v.OppObj.Loan_Amount_with_Premium__c"));
           // component.set("v.OppObj.Loan_Amount_with_Premium__c",0)
             console.log(component.get("v.OppObj.Loan_Amount_with_Premium__c"));
            if(!$A.util.isEmpty(component.get("v.OppObj.Loan_Amount_with_Premium__c")) && component.get("v.OppObj.Loan_Amount_with_Premium__c")>=totalchargeAmount){
                var disAmount = component.get("v.OppObj.Loan_Amount_with_Premium__c") - totalchargeAmount;
                console.log('total amount'+totalchargeAmount);  
                component.set("v.cddObj.Disbursement_Amount__c",disAmount);
            }
           /* commented for 6863 else{
                this.ShowToast(component,"Error!", "Loan amount with premium is zero or charge amount exceeds Loan amount with premium", "error");
            }
            */

        }else{
            console.log('fdsafelse');
            component.set("v.cddObj.Disbursement_Amount__c",component.get("v.OppObj.Loan_Amount_with_Premium__c") );
        }
    },
    executeApex: function(component, method, params, callback){
        var action = component.get("c."+method); 
        action.setParams(params);
        component.set("v.spinnerFlag","true");
        action.setCallback(this, function(response) {
            component.set("v.spinnerFlag","false");
            var state = response.getState();
            if(state === "SUCCESS"){
                callback.call(this, null, response.getReturnValue());
            } else if(state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message){
                        errors.push(item.message);
                    }
                }
                this.ShowToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    invokeCheckIMPS : function(component) {
        console.log('inside method --> ' , JSON.stringify(component.get("v.cddObj")));
        //this.executeApex(component, "invokeCheckIMPS", {"currentDisbursalDetails" : JSON.stringify(component.get("v.cddObj"))}, function(error, result) {
        this.executeApex(component, "invokeCheckIMPS", {"currentDisbursalDetails" : component.get("v.cddObj")}, function(error, result) {
            if(!error && result) {
                console.log('result --> ' , result);
                //var data = JSON.parse(result);
                console.log('data --> ' , result);
                component.set("v.cddObj", result.cddObj);
                component.set("v.isTransactionalError", result.isTransactionalError);
                component.set("v.isAPIError", result.isAPIError);
                if (component.get("v.cddObj").IMPS_Result__c == 'Successful Transaction') {
                    console.log('inside if 0 --> ');
                    // disable Validate IMPS button
                    component.find("validateIMPS").getElement().disabled = true;
                    if (result.errorMsg != null || result.errorMsg != undefined) {
                        // show toast
                        this.ShowToast(component, "Success!", result.errorMsg, "success");
                    }
                } else if (component.get("v.isAPIError")) {
                    console.log('inside if 1 --> ');
                    // show wait and abort modal
                    if (result.errorMsg != null || result.errorMsg != undefined) {
                        // show toast
                        this.ShowToast(component, "Error!", result.errorMsg, "error");
                    }
                    this.showHideDiv(component, "alertDialog", true);
                } else if (component.get("v.isTransactionalError")) {
                    console.log('inside if 2 --> ' + result.errorMsg);
                    //component.find("validateIMPS").getElement().disabled = true;
                    if (result.errorMsg != null || result.errorMsg != undefined) {
                        // show toast
                        this.ShowToast(component, "Error!", result.errorMsg, "error");
                    }
                }
                // invoke fetch charges
                this.getFeesNChargesRecords(component);
            }else
            {
                this.ShowToast(component, "Error!", 'An error occured. Please contact system administrator.', "error");
            }
        });
    },
    invokeReCheckIMPS : function(component) {
        
        this.executeApex(component, "invokeReCheckIMPS", {"currentDisbursalDetails" : component.get("v.cddObj")}, function(error, result) {
            if(!error && result) {
                component.set("v.cddObj", result.cddObj);
                component.set("v.isTransactionalError", result.isTransactionalError);
                component.set("v.isAPIError", result.isAPIError);
                if (component.get("v.cddObj").IMPS_Result__c == 'Successful Transaction') {
                    console.log('inside if --> ');
                    // disable Validate IMPS button
                    component.find("validateIMPS").getElement().disabled = true;
                    if (result.errorMsg != null || result.errorMsg != undefined) {
                        // show toast
                        this.ShowToast(component, "Error!", result.errorMsg, "error");
                    }
                } else if (component.get("v.isAPIError") == true) {
                    console.log('inside else if 1 --> ');
                    // show wait and abort modal
                    if (result.errorMsg != null || result.errorMsg != undefined) {
                        // show toast
                        this.ShowToast(component, "Error!", result.errorMsg, "error");
                    }
                    this.showHideDiv(component, "alertDialog", true);
                } else if (component.get("v.isTransactionalError") == true) {
                    console.log('inside else if 2 --> ' + result.errorMsg);
                    //component.find("validateIMPS").getElement().disabled = true;
                    if (result.errorMsg != null || result.errorMsg != undefined) {
                        // show toast
                        this.ShowToast(component, "Error!", result.errorMsg, "error");
                    }
                }
                // invoke fetch charges
                this.getFeesNChargesRecords(component);
            }
        });
    },
    getFeesNChargesRecords : function(component) {
        this.executeApex(component, "fetchChargesCtrl", {"loanObject" :  component.get("v.OppObj")}, function(error, result) {
            if(!error && result) {
                console.log('queryFeesNCharges --> ' + result);
                if(result != null && result.indexOf("error") == -1) {
                    
                    component.set("v.feesNChargesList", result);
                    console.log('====>> ' + component.get("v.feesNChargesList").length);
                    
                }else {
                    console.log('result --> ' + result);
                    this.ShowToast(component, "Error!", 'Fees and charges issue!', "error");
                }
            } else {
                console.log('result --> ' + result);
                this.ShowToast(component, "Error!", 'Fees and charges issue!', "error");
            }
        });
    },
    isEmpty: function(value){
        return ($A.util.isEmpty(value) || $A.util.isUndefined(value) || value === 0);
    },
    getOpsChecklistData : function(component) {
        
        this.executeApex(component, "getProductOffering", {"loanId" :  component.get("v.OppObj.Id")}, function(error, result){
            console.log('Disb Opp id ' +component.get("v.OppObj.Id"));
            if(!error && result.length>0){
                console.log(result);
                component.set("v.AddressChange",result[0].Address_Change_flag__c);
                console.log('address change' + component.get("v.AddressChange"));
                $A.util.isEmpty()
                if(!($A.util.isEmpty(result[0].eKYC__r)))
                {
                    if( result[0].eKYC__r[0].eKYC_Aadhaar_Number__c != undefined && result[0].eKYC__r[0].eKYC_Aadhaar_Number__c != null)
                    { console.log('inside if');
                     component.set("v.ekycops",true); console.log('ekyc 3' +component.get("v.ekycops"));
                    }
                    else
                    {   console.log('inside else');
                     component.set("v.ekycops",'false');
                     
                    }
                }
                else
                {
                    component.set("v.ekycops",false);
                    console.log('ekyc 3' +component.get("v.ekycops"));
                }
            }else
            {
                this.ShowToast(component, "Warning!","Error occured , Please check respective data 1", "warning");
            }
        });
        
        this.executeApex(component, "getFiles", {"loanId" :  component.get("v.OppObj.Id")}, function(error, result){
            console.log('sixe' +result.length);
            if(!error && result.length>0){
                var i;
                for( i = 0 ; i < result.length ; i++)
                {    
                    var test;
                    test = result[i].ContentDocument.Title;
                    console.log('test '+test );
                    //Added by Rohan for Bug ID 20028
                    if(test.indexOf('DEGREE CERTIFICATE') >= 0)
                    {
                        component.set("v.fileOpsCheck" , 'true');
                    }
                    
                    
                }
                
                console.log(result);
                // component.set("v.fileList",result.ContentDocument.Title);               
            }else{
                component.set("v.fileOpsCheck" , 'false');
                console.log('file check' +component.get("v.fileOpsCheck"));
            }
        });
        
         // Bug 23801 S
        this.executeApex(component, "OpsDashboard", {"oppId" :  component.get("v.OppObj.Id")}, function(error, result){
          console.log('sixe' +result);
            debugger;
          if(!error && result){
             
              console.log('result is'+JSON.stringify(result));
              if(result.CDDValid!=null && result.CDDValid!='' && result.CDDValid!= undefined){
                  component.set("v.cddApproved",result.CDDValid);
              }
              if(result.repaymentValid!=null && result.repaymentValid!='' && result.repaymentValid!= undefined){
                  component.set("v.repaymentApproved",result.repaymentValid);
              }
              if(result.nsdlPanValid!=null && result.nsdlPanValid!='' && result.nsdlPanValid!= undefined){
                  component.set("v.nsdlApproved",result.nsdlPanValid);
              }
              if(result.impsValid!=null && result.impsValid!='' && result.impsValid!= undefined){
                  component.set("v.impsApproved",result.impsValid);
              }
              if(result.creditCardValid!=null && result.creditCardValid!='' && result.creditCardValid!= undefined){
                  component.set("v.creditCardApplied",result.creditCardValid);
              }
              //bug 24927
              if(result.isGCOoPS!=null&&result.isGCOoPS!=''&&result.isGCOoPS!=undefined){
                  component.set("v.isGCODisFlag",result.isGCOoPS);
              }
               //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement  start
              if(result.consentAgreement!=null && result.consentAgreement!='' && result.consentAgreement!= undefined){
                  component.set("v.consentAgree",result.consentAgreement);
              }
              if(result.consentApplication!=null && result.consentApplication!='' && result.consentApplication!= undefined){
                  component.set("v.consentApp",result.consentApplication);
              }
              //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement  end
              if(result.exceptionMsg!=null && result.exceptionMsg!='' && result.exceptionMsg!= undefined){
                  this.ShowToast(component, "Warning!", result.exceptionMsg, "warning");
              }
              //Bug 24528 S
              if(result.ccEligible!=null && result.ccEligible!='' && result.ccEligible!= undefined){
                  debugger;
                  console.log('result.ccEligible'+result.ccEligible);
                  component.set("v.ccEligible",result.ccEligible);
              }
              //Bug 24528 E
              //Bug 24927 S
             if(result.isGCO!=null && result.isGCO!='' && result.isGCO!= undefined){
                  console.log('result.isGCO'+result.isGCO);
                  component.set("v.isGCO",result.isGCO);
              }
              if(result.isAddrchanged!=null && result.isAddrchanged!='' && result.isAddrchanged!= undefined){
                  console.log('result.isAddrchanged'+result.isAddrchanged);
                  component.set("v.isAddrchanged",result.isAddrchanged);
              }
			 //Bug 24927 E

            }
            else if(result == null || result == undefined || result == ''){
   		    	this.ShowToast(component, "Warning!","Error occured , Please check respective data", "warning");
          }
        });
         // Bug 23801 E
        
        component.set("v.isOpenOps", true);
        
    },
    disableDisbursalForm : function(component) {
        var list = [
            "favouring", "bankAccountNumber", "ifscCode", "bankName", "branckName", "micrCode",
            "pdcByName", "ecsBarcode", "accountType", "repaymentMode", "opsUserList"
        ];
        for(var i = 0; i < list.length; i++){
            console.log('====YK===>> '+component.find(list[i]));
            if(component.find(list[i]))
                component.find(list[i]).set("v.disabled", true);
        }
        //22141 S added ConfirmBankDetails in list
        // //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement start added sendMailToCustomer
        list = [
            "saveDisbursmentDetails", "initiateOpenECS", "saverepaymentDetails", "eAgreement","sendMailToCustomer", "generateOPSChecklist", "sendToBranchOPS", "validateIMPS",
            "submitToBranchOPS","ConfirmBankDetails"
        ];
        //22141 E
        // disable button
        for(var i = 0; i < list.length; i++){
            console.log('====YK2===>> '+component.find(list[i]));
            if(component.find(list[i]))
                component.find(list[i]).set("v.disabled", true);
            console.log('====YK3===>> '+component.find(list[i]));
        }
    },
    //added by sachin to check required documents 
    verifyDocs : function(component,methodName) {
        
        this.executeApex(component, "fetchDocuments", {"loanId" :  component.get("v.OppObj.Id")}, function(error, result){ 
            //debugger;
            component.set("v.allowIMPS", result.CancelledCheck);
            component.set("v.allowNACH", result.Nach);
            component.set("v.allowAgreement", result.Agreement);
            
            if (component.get("v.cddObj").IMPS_Result__c == 'Successful Transaction' ) {
                component.set("v.allowIMPS", true);
            }
            
            if (component.get("v.rmdObj").UMRN__c != null || component.get("v.rmdObj").Open_ECS_Facility__c== 'Existing') {
                component.set("v.allowNACH", true);
            }
            var errorMsg='Kindly upload';
             //US: 9537 USERSTORY_IMPS Initiation to be mandatory start
            if(!component.get("v.allowIMPS"))
                errorMsg=errorMsg+' Cancelled Cheque as IMPS validation is not successful, '; 
            
            
            if(!component.get("v.allowNACH"))
                errorMsg=errorMsg+' NACH,'; 
            
            //6863 USERSTORY_Validations before triggering E-Agreement start
            if(!component.get("v.allowAgreement"))
             {
             var Isvalid=false;
             if(component.get("v.IPAddressValue")!='' && !component.get("v.IPAddressValue").includes("Accepted"))
             {
                 Isvalid=true;
                 console.log('inside isvalid');
                 // component.set("v.allowAgreement", false);
             }
             else if(component.get("v.IPAddressValue")==''){
                Isvalid=true;
                       console.log('inside isvalid');
                    //  component.set("v.allowAgreement", false);
                 }
                 else
                 {
                      component.set("v.allowAgreement", true);
                 }
             if(Isvalid)
               errorMsg=errorMsg+'  Agreement Copy as E-Agreement is not done for this application ,'; 
             }
           
             //6863 USERSTORY_Validations before triggering E-Agreement end  
            /* To remove last , from error message*/
            errorMsg = errorMsg.slice(0, -1);
            
            if(component.get("v.allowIMPS") && component.get("v.allowNACH") && component.get("v.allowAgreement")){
                
                if(methodName=='submitToBranchOPSUser')
                    this.sendToBranchOPS(component);
                else if(methodName=='sendToBranchOPS'){ 
                    
                    this.updateIsCddRmdBankDetailsSame(component);
                    if(component.get('v.isCddRmdBankDetailsSame')){
                        this.fetchOPSuserList(component);
                        this.showHideDiv(component,"submitToBranchOPSDiv",true);    
                        
                    }
                    else {
                        this.ShowToast(component,"Error!", "Disbursement bank details must be same as Repayment Bank details,Please either click on Initiate Open ECS Or Save Details", "error");
                    }      
                    
                }
                
            }   
            else{
                this.ShowToast(component,"Error!", errorMsg, "error");}
            
        });
    },
    //6863 USERSTORY_Validations before triggering E-Agreement start
    validateEagreeEappfun : function(component) {
        
        this.executeApex(component, "validateEagreeEapp", {"loanId" :  component.get("v.OppObj.Id")}, function(error, result){ 
            //    var isvalidation=true;
            console.log('inside result==>',result);
            if (!error && result) {
                
                component.set("v.IPAddressValue",result.IPAddressValue);
                console.log('IPAddressValue here is===>'+ component.get("v.IPAddressValue"));
                console.log('isValidValue here is===>'+ result.isValidValue);
                
                if(result.isValidValue!=null && result.isValidValue=="true"){
                   
                    console.log('inside if');
                    if(this.validateIMPSDetails(component,'submitToBranchOps')){
                        this.verifyDocs(component,'sendToBranchOPS');
                    }
                }
                else{
                   
                    console.log('inside else');
                    this.ShowToast(component, "Error!","Submit to Branch Ops is not allowed until Customer accepts consent", "Error");
                    return false;
                }
            }
            
        });         
    },
    //6863 USERSTORY_Validations before triggering E-Agreement end
    updateIsCddRmdBankDetailsSame : function (component){ 
        debugger
        if(component.get("v.rmdObj.A_C_NO__c") && 
           (component.get("v.rmdObj.A_C_NO__c") == component.get("v.cddObj.Bank_Account__c")) &&
           (component.get("v.rmdObj.IFSC_Code__c") == component.get("v.cddObj.IFSC_Code__c")) && 
           (component.get("v.rmdObj.Bank_Name__c") == component.get("v.cddObj.Bank_Name__c")) && 
           (component.get("v.rmdObj.MICR_Code__c") == component.get("v.cddLocalMICRCode"))){
            
            component.set('v.isCddRmdBankDetailsSame', "true");
        }
        else{
            component.set('v.isCddRmdBankDetailsSame', "false");       
        }
        
    },
    
    updateEmandateDisabled: function (component){
        
        this.updateIsCddRmdBankDetailsSame(component);
        
        if(component.get("v.OppObj.StageName") == 'Post Approval Sales'
           && component.get("v.isCddRmdBankDetailsSame") == 'true'
           && component.get('v.rmdObj.Repayment_Mode__c') == 'SI'
           && component.get('v.oldRmdObj.Repayment_Mode__c') == 'SI'){
            
            component.set('v.emandateDisabled', "false");  
        }
        else{
            component.set('v.emandateDisabled', "true");  
        }
        
        
    },
    
    convertToUpperCase: function(component, event, helper) {
        
        if(component.get("v.cddObj")!= undefined && component.get("v.cddObj").IFSC_Code__c != undefined) {
            var tempVar = component.get("v.cddObj.IFSC_Code__c");
            tempVar =  tempVar.toUpperCase();
            component.set("v.cddObj.IFSC_Code__c",tempVar);
        } 
    },
    
    
    
    refreshMandateProcess : function (component, event, helper){
        debugger
        this.executeApex(component, "getMandateProcessStage", {"repaymentId" : component.get("v.rmdObj.Id")}, function(error, result){
                
                if(!error && result.length>0){
                    // success logic
                    component.set("v.rmdObj.Mandate_Process_Stage__c", result);
                    component.set("v.oldRmdObj.Mandate_Process_Stage__c", result);
                    this.setStageIcon(component);
                }else{
                   // error logic
                    this.ShowToast(component, "Warning!","Unable to refresh Mandate Process Stage", "warning");
                }   
            });
    },
    
     saveEAgreementAsPDF : function (component, event, helper){
        this.executeApex(component, "saveEAgreementAsPDF", {"loanId" : component.get("v.OppObj.Id")}, function(error, result){
                if( result==true)
                    console.log('E-Agreement saved as pdf: ');
            });
    },
    
    openConfirmBox: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        
        var cmpTarget = component.find('eMandateConfirmBox');
        var cmpBack = component.find('ModalbackdropeMandateConfirmBox');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
        this.showHideDiv(component, "eMandateConfirmBox", true);      
    },
    
    closeConfirmBox: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        
        var cmpTarget = component.find('eMandateConfirmBox');
        var cmpBack = component.find('ModalbackdropeMandateConfirmBox');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpBack, 'slds-backdrop--open');
        this.showHideDiv(component, "eMandateConfirmBox", false);   
    },
    
    setStageIcon: function(component){
        var stage=component.get("v.rmdObj").Mandate_Process_Stage__c;
        if(stage){
            switch(stage) {
                case "Initiated":
                    component.set("v.stageIconName","action:more"); 
                    break;
                case "In Progress":
                   component.set("v.stageIconName","action:change_record_type"); 
                    break;
                case "Finished":
                     component.set("v.stageIconName","action:approval"); 
                    break;
                case  "Failed":
                     component.set("v.stageIconName","action:close"); 
                    break
                default:
                component.set("v.stageIconName","action:reject"); 
            } 
        }
    },
    //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement start
    sendEaggrementDIPOSHelper:function(component,event){
       component.set("v.spinnerFlag","true");
       this.executeApex(component, 'sendMailEAggrementDIPOS', {
          "oppId":component.get('v.OppObj.Id'),
        },   
                        
                         function (error, result) {
                             console.log('error==>'+error);
                             console.log('result==>'+result);
                             if (!error && result) {
                             this.ShowToast(component, "Success!","Email sent to Customer successfully", "Success");
                             }
                             else{
                                 this.ShowToast(component, "Error!","Failed to send mail to Customer", "Error");
                             }
                          component.set("v.spinnerFlag","false");  
                         }); 
    }
      //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement end
       
    
})