({
    markMandatoryFieldsRed: function(component, event) {
        var selectedValue=component.find('disbursalMode').get("v.value");
        //initialy all remove class
        /*$A.util.addClass(component.find('disbursalMode'), 'slds-has-error');
        $A.util.removeClass(component.find('favouring'), 'slds-has-error');   
        $A.util.removeClass(component.find('bankAccount'), 'slds-has-error');       
        $A.util.removeClass(component.find('disbAmount'), 'slds-has-error');       
        $A.util.removeClass(component.find('payableAt'), 'slds-has-error');       
        $A.util.removeClass(component.find('bankName'), 'slds-has-error');   
        $A.util.removeClass(component.find('ifscCode'), 'slds-has-error');       
        $A.util.removeClass(component.find('bankName'), 'slds-has-error');   */
        component.find('favouring').set("v.required",false); 
        component.find('bankAccount').set("v.required",false); 
        component.find('disbAmount').set("v.required",false); 
        component.find('payableAt').set("v.required",false); 
        component.find('bankName').set("v.required",false); 
        component.find('ifscCode').set("v.required",false); 
        
        if(selectedValue=='CHEQUE')
        {
            component.find('favouring').set("v.required",true);   
            component.find('bankAccount').set("v.required",true);   
            component.find('disbAmount').set("v.required",true);   
            component.find('payableAt').set("v.required",true);   
            /*$A.util.addClass(component.find('favouring'), 'slds-has-error');       
            $A.util.addClass(component.find('bankAccount'), 'slds-has-error');       
            $A.util.addClass(component.find('disbAmount'), 'slds-has-error');       
            $A.util.addClass(component.find('payableAt'), 'slds-has-error');       */
        }
        if(selectedValue=='DD')
        {
            component.find('favouring').set("v.required",true);   
            component.find('ifscCode').set("v.required",true);   
            component.find('bankName').set("v.required",true);   
            /*$A.util.addClass(component.find('favouring'), 'slds-has-error');    
            $A.util.addClass(component.find('ifscCode'), 'slds-has-error');    
            $A.util.addClass(component.find('bankName'), 'slds-has-error');*/    
        }
        if(selectedValue=='DRAFT')
        {
            component.find('favouring').set("v.required",true);   
            component.find('bankAccount').set("v.required",true);   
            //component.find('disbAmount').set("v.required",true);  //Bug 22865: Disbursement amount should be non mandatory. So commented this.  
            component.find('payableAt').set("v.required",true);
            component.find('bankName').set("v.required",true); //Bug 22865: Bank name should be mandatory
            /*$A.util.addClass(component.find('favouring'), 'slds-has-error');    
            $A.util.addClass(component.find('bankAccount'), 'slds-has-error');    
            $A.util.addClass(component.find('disbAmount'), 'slds-has-error');    
            $A.util.addClass(component.find('payableAt'), 'slds-has-error');*/  
        }
        if(selectedValue=='FUND TRANSFER')
        {
            component.find('favouring').set("v.required",true); 
            component.find('ifscCode').set("v.required",true); 
            component.find('bankName').set("v.required",true); 
            /*$A.util.addClass(component.find('favouring'), 'slds-has-error');    
            $A.util.addClass(component.find('ifscCode'), 'slds-has-error');    
            $A.util.addClass(component.find('bankName'), 'slds-has-error');*/                    
        }
        if(selectedValue=='IMPS')
        {
            component.find('favouring').set("v.required",true); 
            component.find('ifscCode').set("v.required",true); 
            component.find('bankName').set("v.required",true); 
            component.find('bankAccount').set("v.required",true); //Bug 22865: bank account has to be mandatory
            /*$A.util.addClass(component.find('favouring'), 'slds-has-error');                    
            $A.util.addClass(component.find('ifscCode'), 'slds-has-error');                    
            $A.util.addClass(component.find('bankName'), 'slds-has-error');*/                   
            
        }
        if(selectedValue=='NEFT')
        {		
            component.find('favouring').set("v.required",true); 
            component.find('bankAccount').set("v.required",true); 
            component.find('ifscCode').set("v.required",true); 
            component.find('bankName').set("v.required",true); 
            /*$A.util.addClass(component.find('favouring'), 'slds-has-error');                    
            $A.util.addClass(component.find('bankAccount'), 'slds-has-error');                    
            $A.util.addClass(component.find('ifscCode'), 'slds-has-error');                    
            $A.util.addClass(component.find('bankName'), 'slds-has-error');*/                    
        }
        if(selectedValue=='RTGS')
        {
            component.find('favouring').set("v.required",true); 
            component.find('bankAccount').set("v.required",true); 
            component.find('ifscCode').set("v.required",true); 
            component.find('bankName').set("v.required",true); 
            /*$A.util.addClass(component.find('favouring'), 'slds-has-error');                    
            $A.util.addClass(component.find('bankAccount'), 'slds-has-error');                    
            $A.util.addClass(component.find('ifscCode'), 'slds-has-error');                    
            $A.util.addClass(component.find('bankName'), 'slds-has-error');*/                   		
        }      
    },
    fetchData : function(component, event) {
        var disbObjList = ["IMPS_Flag__c","Disbursal_Mode__c"];
        var selectListNameMap = {};
        selectListNameMap["Current_Disbursal_Details__c"] = disbObjList;
        this.showhidespinner(component,event,true);
        console.log('param1*****'+component.get("v.disbId"));
        console.log('param2*****'+component.get("v.loanId"));
        console.log('param3*****'+JSON.stringify(selectListNameMap));
        this.executeApex(component, "fetchDisbursementObject", {
            "disbId": component.get("v.disbId"),
            "Loanid":component.get("v.loanId"),
            "objectFieldJSON":JSON.stringify(selectListNameMap)
        }, function (error, result) {
            console.log('result : ' + result);
            if (!error && result) {
                var result = JSON.parse(result);
                var picklistFields = result.picklistData;
                var disbPickFlds = picklistFields["Current_Disbursal_Details__c"];
                component.set("v.disbModeList", disbPickFlds["Disbursal_Mode__c"]);
                component.set("v.impsList", disbPickFlds["IMPS_Flag__c"]);
                
                //Bug 20391 : Bug 22062  : Add defult value : Start
                try{
                    var isDisbDashboard = component.get("v.isDisbDashboard");
                    if(isDisbDashboard){
                        if(result.disObj!=null && (result.disObj.Disbursal_Mode__c==null || result.disObj.Disbursal_Mode__c=='' || result.disObj.Disbursal_Mode__c==undefined ) ){
                            result.disObj.Disbursal_Mode__c = 'RTGS';
                            this.markMandatoryFieldsRed(component,event); //Bug22865: to markmandatory fields for RTGS on load
                            //console.log(result.disObj);
                        }
                        
                        if(result.disObj!=null && (result.disObj.Disbursement_Amount__c!=null || result.disObj.Disbursement_Amount__c!='' || result.disObj.Disbursement_Amount__c!=undefined ) ){
                            //console.log(result.disObj);
                            component.set("v.allow_sum_Disbursement_Amount", result.disObj.Disbursement_Amount__c);
                        }
                    }else{
                       // result.disObj.Disbursement_Amount__c = '';
                    }
                }catch(e){console.log(e);}
                //Bug 20391 : Bug 22062  : Add defult value : End
                
                
                console.log('result.status : '+result.status);
                if(result.status == 'Fail'){
                    component.set("v.disb",result.disObj);
                    //component.set("v.checkboxStatus",false); //by default, not checked and fields diabled
                    component.find('payableAt').set('v.value',result.BranchName);
                    this.showhidespinner(component,event,false);
                   this.cloneFromRepayHelper(component, event);
                }
                else{
                    
                    component.set("v.disb",result.disObj);
                    component.find('ifscCode').set('v.disabled',true );
                    component.find('bankName').set('v.disabled',true);
                    component.find('favouring').set('v.disabled',true);
                    component.find('bankAccount').set('v.disabled',true);

                    var diff = component.get("v.disb.Repay_Disb_Diff__c");
                    if(!diff)
                    {           
                       // this.cloneFromRepayHelper(component, event); commented for prod issue by prashant
                    }
                    this.showhidespinner(component,event,false); //Bug 22125
                    this.markMandatoryFieldsRed(component,event);//mark initial mandatory fields
                    this.disableFieldsForTopUp(component,event);//Disable fields if topup is ticked
                    
                }
                 if($A.util.isEmpty(component.get("v.disb.Disbursal_Mode__c")))
                   component.find("disbursalMode").set("v.value",'RTGS');//22017
            }
        });
        //alert('component.get("v.loanId")'+component.get("v.loanId"));
        //component.find('loan_app_field').set('v.value', component.get("v.loanId"));
    },
    saveDisb : function(component, event) {
           //24315s
        var bankAccMatch="";
        var disbursalList=component.get("v.disb");
        var bankAccountObj=component.get("v.bankAccount");
        var repaymentModeDtlList=component.get("v.repayList");
        console.log('bankAccountObj '+ bankAccountObj);
        console.log('repaymentModeDtlList ');
        console.log(repaymentModeDtlList);
        /*if(bankAccountObj.Perfios_Flag__c)
        {
            if((disbursalList.Bank_Account__c != repaymentModeDtlList[0].A_C_NO__c) || (bankAccountObj.Perfios_Account_No__c != repaymentModeDtlList[0].A_C_NO__c) || (disbursalList.Bank_Account__c != bankAccountObj.Perfios_Account_No__c))
            {
                bankAccountObj.Perfios_account_same_as_Salary_account__c = false;
                bankAccMatch=JSON.stringify(bankAccountObj);
            }
        }
        else if((disbursalList.Bank_Account__c != repaymentModeDtlList[0].A_C_NO__c) || (bankAccountObj.Bank_Acct_Number__c != repaymentModeDtlList[0].A_C_NO__c) || (disbursalList.Bank_Account__c != bankAccountObj.Bank_Acct_Number__c))
        {
            bankAccountObj.Perfios_account_same_as_Salary_account__c = false;
            bankAccMatch=JSON.stringify(bankAccountObj);
        }*/
        //24315e
         /*US_1476--*/
        if(!component.get("v.ifscActive"))
        {
            this.displayToastMessage(component,event,'Error',"IFSC is not Active",'error');
            this.showhidespinner(component,event,false);  
        }
        else{

		var disb = component.get("v.disb"); //Bug 24313
        if($A.util.isEmpty(disb.Loan_Application__c)) ////Bug 24313
            disb.Loan_Application__c = component.get("v.loanId");//Bug 24313
        this.showhidespinner(component,event,true);
        this.executeApex(component, "saveDisbursementObj", {
            "disb": JSON.stringify(component.get("v.disb")),
			 "opp":JSON.stringify(component.get("v.opp")),//Addede for 1643
  "bankAccount": bankAccMatch //24315 passed bankAccMatch
        }, function (error, result) {
            if(!error && result){
                var disbId = result;
                 // user story 978 s
                 var updateidentifier =  $A.get("e.c:Update_identifier");
                 updateidentifier.setParams({
                "eventName": 'Pricing Disbursement Details',
                "oppId":component.get("v.loanId")
                  });
               updateidentifier.fire();
                // user story 978 e
                this.handleSuccess(component,event,disbId);
                this.displayToastMessage(component,event,'Success','Disbursement Record added successfully!','success');
                //this.displayToastMessage(component,event,'Success','Record saved successfully!','error');
                this.showhidespinner(component,event,false);
            }   
            else{
                this.displayToastMessage(component,event,'Error','Failed to save record!','error');
                this.showhidespinner(component,event,false);
            }
        }
                        );  
        }
        
    },
    executeApex : function(component, method, params,callback){
        console.log('params'+JSON.stringify(params));
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log('response.getReturnValue()'+response.getReturnValue());
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
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    handleSuccess : function(component, event,disbId){
        console.log('in success'+disbId);
        this.showhidespinner(component,event,true);
        var disbEvent = $A.get("e.c:updateDisbursementList");
        disbEvent.setParams({
            "disburse" : disbId
        });
        disbEvent.fire();
        component.destroy();
        
        
        
    },
    
    displayToastMessage:function(component,event,title,message,type)
    {
        //alert('in displaytoast');
        console.log('inside displayToastMessage'+message+type);
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    },
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
            
        });
        showhideevent.fire();
    },
    handleOnBlur : function(component, event, ifscMicr){
        this.showhidespinner(component,event,true);
        var ifscMicrCode;
        if(ifscMicr.includes("IFSC")){
            ifscMicrCode = component.find("ifscCode").get("v.value")
        }
        this.executeApex(component, "fetchIFSCData", {
            "ifscmicrCode": ifscMicrCode,
            "fieldAPI": ifscMicr
        }, function (error, result) {
            if (!error && result) {
                if(result == 'Fail'){
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error','Record not found or MICR is inactive!','error');//5431 message updated for MICR
                }
                else if(result.includes("Error")){
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error','Error occured!','error');
                }
                    else{
                        
                        
                        // console.log('ifscObj.MICR_Code__c'+ifscObj.MICR__c);
                        //component.find('micr_code').set('v.value', ifscObj.MICR__c);
                        //US5431s
                        //var ifscObj = JSON.parse(result);
                        //component.set("v.ifscActive",ifscObj.IFSC_Active__c);/*US_1476 */
                        
                        var ifscList = JSON.parse(result);                         
                        component.set("v.ifscActive",ifscList[0].IFSC_Active__c);/*US_1476 */
                        
                         if(component.get("v.ifscActive")){
                        component.find('ifscCode').set('v.value', ifscList[0].IFSC_Code__c);
                        component.find('bankName').set('v.value', ifscList[0].Bank__c);
                        component.find('bankBranch').set('v.value', ifscList[0].Branch__c);
                                                 
                        //component.find('ifscCode').set('v.value', ifscObj.IFSC_Code__c);
                        //component.find('bankName').set('v.value', ifscObj.Bank__c);
                        //component.find('bankBranch').set('v.value', ifscObj.Branch__c);
                        //US5431e
                        
                        this.showhidespinner(component,event,false);
                        this.displayToastMessage(component,event,'Success','Data fetched!','success');
                         }
                        else{
                            
                             this.displayToastMessage(component,event,'Error','IFSC is not active.Please enter another IFSC code','error');
                             this.showhidespinner(component,event,false);
                             return null;
                            }/*US_1476 E*/
                    }
            }
        });
    },
    checkMandatoryFields :  function(component, event, helper){
        var selectedValue=component.find('disbursalMode').get("v.value");
        var favouring =component.find('favouring').get("v.value");
        var ifscCode =component.find('ifscCode').get("v.value");
        var bankName =component.find('bankName').get("v.value");
        var bankAccount =component.find('bankAccount').get("v.value");
        var bankBranch =component.find('bankBranch').get("v.value");
        var disbAmount =component.find('disbAmount').get("v.value");
        //var impsFlag =component.find('impsFlag').get("v.value");
        //var finnoneDisbDate =component.find('finnoneDisbDate').get("v.value");
        var payableAt =component.find('payableAt').get("v.value");
        
        var allowToSave=false;
        if(selectedValue=='CHEQUE')
        {
            if(!$A.util.isEmpty(favouring) && !$A.util.isEmpty(bankAccount) && !$A.util.isEmpty(disbAmount) && !$A.util.isEmpty(payableAt) )
            {
                allowToSave=true;
            }
        }
        if(selectedValue=='DD')
        {
            if(!$A.util.isEmpty(favouring) && !$A.util.isEmpty(ifscCode) && !$A.util.isEmpty(bankName) )
            {
                allowToSave=true;
            }
        }
        if(selectedValue=='DRAFT')
        {
            if(!$A.util.isEmpty(favouring) && !$A.util.isEmpty(bankAccount) && !$A.util.isEmpty(disbAmount) && !$A.util.isEmpty(payableAt) )
            {
                allowToSave=true;
            }
        }
        if(selectedValue=='FUND TRANSFER')
        {
            if(!$A.util.isEmpty(favouring) && !$A.util.isEmpty(ifscCode) && !$A.util.isEmpty(bankName) )
            {
                allowToSave=true;
            }      
        }
        if(selectedValue=='IMPS')
        {
            if(!$A.util.isEmpty(favouring) && !$A.util.isEmpty(ifscCode) && !$A.util.isEmpty(bankName) )
            {
                allowToSave=true;
            }    
        }
        if(selectedValue=='NEFT')
        {
            if(!$A.util.isEmpty(favouring) && !$A.util.isEmpty(bankAccount) && !$A.util.isEmpty(ifscCode) && !$A.util.isEmpty(bankName)  )
            {
                allowToSave=true;
            }    
        }
        if(selectedValue=='RTGS')
        {
            if(!$A.util.isEmpty(favouring) && !$A.util.isEmpty(bankAccount) && !$A.util.isEmpty(ifscCode) && !$A.util.isEmpty(bankName)  )
            {
                allowToSave=true;
            }    
        }
        //CHECK For Allow To Save flag
        if(allowToSave==false)
        {
            this.displayToastMessage(component,event,'Error','Please Fill Mandatory Fields','error');
        }
        if(allowToSave==true)
        {
            this.saveDisb(component, event);
        }
        
        
    },
    disableFieldsForTopUp:  function(component, event, helper){
        if(component.get("v.isTopup")==true)
        {
            component.find("favouring").set("v.disabled",true);
            component.find("disbAmount").set("v.disabled",true);
            component.find("bankName").set("v.disabled",true);
            component.find("bankAccount").set("v.disabled",true);
            component.find("bankBranch").set("v.disabled",true);
            component.find("Payable_at__c").set("v.disabled",true);
            //component.find("finnoneDisbDate").set("v.disabled",true);
            
            
        }
    },
    cloneFromRepayHelper:  function(component, event, helper){
        //this.showhidespinner(component,event,true);
        this.executeApex(component, "cloneRepayRecord", {
            "oppId":component.get("v.loanId")
        }, function (error, result) {
            console.log('result : ' + result);
            if (!error && result) {
                if(result == 'Fail'){
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error','Unable to clone Repayment Record','error');
                    console.log('ss');
                }
                else{          
                    var result = JSON.parse(result);
                    this.showhidespinner(component,event,false);
                    console.log('ewrewr'+result.Account_Holder_Name__c);
                    
                    //     console.log('Clonned Repay Object'+JSON.stringify(result));
                    component.find('ifscCode').set('v.value',result.IFSC_Code__c );
                    component.find('bankName').set('v.value',result.Bank_Name__c );
                    component.find('favouring').set('v.value',result.Account_Holder_Name__c );
                    component.find('bankAccount').set('v.value',result.A_C_NO__c );
                    var disbObj = component.get("v.disb");
                    disbObj.Favouring__c = result.Account_Holder_Name__c;
                    component.set("v.disb",disbObj);
                    console.log('LIST=-'+result.A_C_NO__c);
                    component.find('ifscCode').set('v.disabled',true );
                    component.find('bankName').set('v.disabled',true);
                    component.find('favouring').set('v.disabled',true);
                    component.find('bankAccount').set('v.disabled',true);
                    //component.set("v.isRepayAndDisb_Different",false); //both are same
                    
                    //component.find('Repay_Disb_Diff__c').set('v.value',false);
                    
                    
                    
                }
            }
        });
    }
})