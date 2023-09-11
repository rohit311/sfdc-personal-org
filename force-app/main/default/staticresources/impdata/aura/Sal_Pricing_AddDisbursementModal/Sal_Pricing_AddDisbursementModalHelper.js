({
    markMandatoryFieldsRed: function(component, event) {
        var selectedValue=component.find('disbursalMode').get("v.value");
        //initialy all remove class
        $A.util.removeClass(component.find('favouring'), 'slds-has-error');   
        $A.util.removeClass(component.find('bankAccount'), 'slds-has-error');       
        $A.util.removeClass(component.find('disbAmount'), 'slds-has-error');       
        $A.util.removeClass(component.find('payableAt'), 'slds-has-error');       
        $A.util.removeClass(component.find('bankName'), 'slds-has-error');   
        $A.util.removeClass(component.find('ifscCode'), 'slds-has-error');       
        $A.util.removeClass(component.find('bankName'), 'slds-has-error');   
        
        
        
        if(selectedValue=='CHEQUE')
        {
            $A.util.addClass(component.find('favouring'), 'slds-has-error');       
            $A.util.addClass(component.find('bankAccount'), 'slds-has-error');       
            $A.util.addClass(component.find('disbAmount'), 'slds-has-error');       
            $A.util.addClass(component.find('payableAt'), 'slds-has-error');       
        }
        if(selectedValue=='DD')
        {
            $A.util.addClass(component.find('favouring'), 'slds-has-error');    
            $A.util.addClass(component.find('ifscCode'), 'slds-has-error');    
            $A.util.addClass(component.find('bankName'), 'slds-has-error');    
        }
        if(selectedValue=='DRAFT')
        {
            $A.util.addClass(component.find('favouring'), 'slds-has-error');    
            $A.util.addClass(component.find('bankAccount'), 'slds-has-error');    
            $A.util.addClass(component.find('disbAmount'), 'slds-has-error');    
            $A.util.addClass(component.find('payableAt'), 'slds-has-error');    
        }
        if(selectedValue=='FUND TRANSFER')
        {
            $A.util.addClass(component.find('favouring'), 'slds-has-error');    
            $A.util.addClass(component.find('ifscCode'), 'slds-has-error');    
            $A.util.addClass(component.find('bankName'), 'slds-has-error');                    
        }
        if(selectedValue=='IMPS')
        {
            $A.util.addClass(component.find('favouring'), 'slds-has-error');                    
            $A.util.addClass(component.find('ifscCode'), 'slds-has-error');                    
            $A.util.addClass(component.find('bankName'), 'slds-has-error');                    
            
        }
        if(selectedValue=='NEFT')
        {		
            $A.util.addClass(component.find('favouring'), 'slds-has-error');                    
            $A.util.addClass(component.find('bankAccount'), 'slds-has-error');                    
            $A.util.addClass(component.find('ifscCode'), 'slds-has-error');                    
            $A.util.addClass(component.find('bankName'), 'slds-has-error');                    
        }
        if(selectedValue=='RTGS')
        {
            $A.util.addClass(component.find('favouring'), 'slds-has-error');                    
            $A.util.addClass(component.find('bankAccount'), 'slds-has-error');                    
            $A.util.addClass(component.find('ifscCode'), 'slds-has-error');                    
            $A.util.addClass(component.find('bankName'), 'slds-has-error');                    		
        }      
    },
    fetchData : function(component, event) {
        this.showhidespinner(component,event,true);
        this.executeApex(component, "fetchDisbursementObject", {
            "disbId": component.get("v.disbId"),
            "Loanid":component.get("v.loanId"),
            "objectFieldJSON":''
        }, function (error, result) {
            console.log('result : ' + result);
            if (!error && result) {
                var result = JSON.parse(result);
                if(result.status == 'Fail'){
					//component.set("v.disb",result.disObj);
                    component.set("v.checkboxStatus",false); //by default, not checked and fields diabled
                    component.find('payableAt').set('v.value',result.BranchName);
                    this.showhidespinner(component,event,false);
                    this.cloneFromRepayHelper(component, event);
                }
                else{
                    
                    component.set("v.disb",result);
                    //console.log(result.disbObj.isTopUp__c);
                    console.log('before setting');
                    console.log(JSON.stringify(component.get("v.disb")));
                    console.log('after setting');
                    // alert(component.find("isTopUpId").get("v.value"));
                    console.log('TRY'+component.get("v.disb.isTopUp__c"));
                    component.find('impsFlag').set('v.value', component.get("v.disb.IMPS_Flag__c"));
                    component.find('disbursalMode').set('v.value', component.get("v.disb.Disbursal_Mode__c"));
                    component.find('favouring').set('v.value'),component.get("v.disb.Favouring__c");
                    var diff=''+JSON.stringify(component.get("v.disb.Repay_Disb_Diff__c"));
                    if(diff == 'true')
                    { 
                        component.set("v.checkboxStatus",true); 
                    }
                    else
                    {          
                        component.set("v.checkboxStatus",false); 
                        this.cloneFromRepayHelper(component, event);
                    }
                  //  console.log('LIJLKJ '+component.find("Repay_Disb_Diff__c").get('v.value') );
                   
                    //component.find('Repay_Disb_Diff__c').set('v.value'),component.get("v.disb.Repay_Disb_Diff__c");
                    //console.log('Kr-'+component.get("v.disb.Repay_Disb_Diff__c"));
                    //component.find('successCount').set('v.value'),component.get("v.disb.Failure_IMPS_Count__c");
                    //component.find('failureCount').set('v.value'),component.get("v.disb.Successful_IMPS_Count__c");
                    this.showhidespinner(component,event,false);
                    this.markMandatoryFieldsRed(component,event);//mark initial mandatory fields
                    this.disableFieldsForTopUp(component,event);//Disable fields if topup is ticked
                    
                }
            }
        });
        //alert('component.get("v.loanId")'+component.get("v.loanId"));
        //component.find('loan_app_field').set('v.value', component.get("v.loanId"));
    },
    saveDisb : function(component, event) {
        /*  if(component.get("v.isRepayAndDisb_Different")==false) 
        {
            component.find('Repay_Disb_Diff__c').set('v.value',false); 
        }
        else
        {      component.find('Repay_Disb_Diff__c').set('v.value',true); }*/
        
        console.log('check before saving');
        component.find("edit").submit();
        console.log('after saving');
        
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
    handleSuccess : function(component, event){
        this.showhidespinner(component,event,true);
        var disbEvent = $A.get("e.c:updateDisbursementList");
        disbEvent.setParams({
            "disburse" : event.getParams().response.id
        });
        disbEvent.fire();
        if(event.getParams().response.id != null && component.get("v.disb.Id") == null){
            component.destroy();
            this.displayToastMessage(component,event,'Success','Disbursement Record added successfully!','success');
        }
        else{
            component.destroy();
            this.displayToastMessage(component,event,'Success','Disbursement Details updated successfully!','success');
        }
        
        
    },
    
    displayToastMessage:function(component,event,title,message,type)
    {
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
                    this.displayToastMessage(component,event,'Error','Record not found!','error');
                }
                else if(result.includes("Error")){
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error','Error occured!','error');
                }
                    else{
                        var ifscObj = JSON.parse(result);
                        // console.log('ifscObj.MICR_Code__c'+ifscObj.MICR__c);
                        //component.find('micr_code').set('v.value', ifscObj.MICR__c);
                        component.find('ifscCode').set('v.value', ifscObj.IFSC_Code__c);
                        component.find('bankName').set('v.value', ifscObj.Bank__c);
                        component.find('bankBranch').set('v.value', ifscObj.Branch__c);
                        this.showhidespinner(component,event,false);
                        this.displayToastMessage(component,event,'Success','Data fetched!','success');
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
        var impsFlag =component.find('impsFlag').get("v.value");
        var finnoneDisbDate =component.find('finnoneDisbDate').get("v.value");
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
            this.displayToastMessage(component,event,'Error','Please Fill Mandatory Fields','Error');
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
            component.find("finnoneDisbDate").set("v.disabled",true);
            
            
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