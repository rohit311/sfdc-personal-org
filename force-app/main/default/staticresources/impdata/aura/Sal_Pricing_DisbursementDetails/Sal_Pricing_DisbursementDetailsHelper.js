({
    editRecord : function(component, event) {
       // console.log('list is::'+JSON.stringify(component.get("v.disbList")));
        var disbAppId = event.currentTarget.value; //24315 bankAccount repayList added
        //Bug 20391 : Bug 22062 : Added isDisbDashboard
         $A.createComponent(
            "c:Sal_Pricing_AddDisbursementModalNew",{"header":"Edit Record",
                                                     "disbId":disbAppId,
                                                     "loanId":component.get("v.loanId"),
                                                     "isDisbDashboard": component.get("v.isDisbDashboard"),
                                                     "bankAccount":component.get("v.bankAccount"),
                                                     "opp":component.get("v.loan"), //Added for 1643
                                                     "repayList":component.get("v.repayList")},
            function(newComponent){
                component.set("v.body",newComponent);
            }
        )
    },
    addRecord : function(component, event) {
        var disbAppId = event.currentTarget.value;
        $A.createComponent(
            "c:Sal_Pricing_AddDisbursementModal",{"header":"Add Record","BranchName":component.get("v.BranchName"),
                                                  "loanId":component.get("v.loanId"),"aura:id": "newdiscmp"},
            function(newComponent){
                component.set("v.body",newComponent);
                if(newComponent)
                    newComponent.fetchData();
                
            }
        )
    },
    addRecord1 : function(component, event) {
        var disbAppId = event.currentTarget.value;
        console.log( 'addRecord1 : ' + component.get("v.isDisbDashboard"));
        //Bug 20391 : Bug 22062 : Added isDisbDashboard
        $A.createComponent(
            "c:Sal_Pricing_AddDisbursementModalNew",{"header":"Add Record","BranchName":component.get("v.BranchName"),
                                                     "loanId":component.get("v.loanId"),"aura:id": "newdiscmp",
                                                     "opp":component.get("v.loan"),/* opp added for 1643*/
                                                     "isDisbDashboard": component.get("v.isDisbDashboard")
                                                    },
            function(newComponent){
                component.set("v.body",newComponent);
                if(newComponent)
                    newComponent.fetchData();
                
            }
        )
    },
    cloneBankDetails : function(component, event) {
        // var disbAppId = event.currentTarget.value;
        $A.createComponent(
            "c:cloneBankingDetails",{"header":"Clone Banking Details",
                                     "oppId":component.get("v.loanId"),
                                     "isSALMobilityV2":true},
            function(newComponent){
                component.set("v.body",newComponent);
            }
        )
    },
    deleteRecord : function(component, event){
        var disbAppId = event.currentTarget.value;
   //24315s
        var bankAccountObj=component.get("v.bankAccount");
        bankAccountObj.Perfios_account_same_as_Salary_account__c = false;
        //24315e
        this.executeApex(component, "deleteDisbursementObject", {
            "disbId": disbAppId,
            "loanId": component.get("v.loanId"),
            "bankAccount": JSON.stringify(bankAccountObj) //24315 passed bankAccount
        }, function (error, result) {
            
            if (!error && result) {
                if(result == 'Fail'){
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error','Error while processing!','error');
                }
                else if (result == 'Empty'){
                    component.set("v.disbList",null);
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Succces','Record deleted successfully!','success');
                }
                    else{
                        component.set("v.disbList",JSON.parse(result));
                        this.showhidespinner(component,event,false);
                        this.displayToastMessage(component,event,'Succces','Record deleted successfully!','success');
                    }
                
            }
        });
    },
    fetchData : function(component, event) {
        //var disbAppId = event.currentTarget.value;
        var disbAppId = event.getSource().get("v.value");  //21287
        console.log('DisbappId****'+disbAppId);
        this.showhidespinner(component,event,true);
        this.executeApex(component, "fetchDisbursementObject", {
            "disbId": disbAppId,
            "Loanid":component.get("v.loanId"),
            "objectFieldJSON":''
        }, function (error, result) {
            
            if (!error && result) {
                var result = JSON.parse(result);
                if(result.status == 'Fail'){
                    
                    this.showhidespinner(component,event,false);
                }
                else{
                    console.log('not error: '+ JSON.stringify(result));
                    component.set("v.disb",result);
                    component.set("v.disbursment",result.disObj);
                    console.log('disbobject='+JSON.stringify(result.disObj));
                    
                    
                    this.showhidespinner(component,event,false); 
                    //hrushikesh added cntrl code to helper
                     var IMPSLabelValue= $A.get("$Label.c.IMPSResponse");//25677
                    if ( component.get("v.disb.IMPS_Result__c") == null  ) {
                        
                        if(component.get("v.disb.Successful_IMPS_Count__c") ==null){component.set("v.disb.Successful_IMPS_Count__c",0); }
                        if(component.get("v.disb.Failure_IMPS_Count__c") ==null){component.set("v.disb.Failure_IMPS_Count__c",0);}
                        if(component.get("v.disb.Successful_IMPS_Count__c") < 3 && component.get("v.disb.Failure_IMPS_Count__c") < 5)	
                            this.invokeCheckIMPShelper(component);
                        else
                            this.displayToastMessage(component,event,'Error','Validate IMPS Limit reached','error');
                        // helper.ShowToast(component, "Info!", "Validate IMPS limit reached." , "info");
                    //} else if (component.get("v.disb.IMPS_Result__c") == 'Successful Transaction' || component.get("v.disb").IMPS_Transaction_No__c != null) {
                       } else if (IMPSLabelValue.includes(component.get("v.disb.IMPS_Result__c")) || component.get("v.disb").IMPS_Transaction_No__c != null) { //25677
                        // disable Validate IMPS button
                        if(component.find("validateIMPS") != undefined) 
                            this.displayToastMessage(component,event,'Success','Already Validated!','success');
                        //component.find("validateIMPS")[0].getElement().disabled = true;
                    //}else if (component.get("v.disb.IMPS_Result__c") != 'Successful Transaction') {
                    }else if (IMPSLabelValue.includes(component.get("v.disb.IMPS_Result__c"))){  //25677
                        //alert('trying another time');
                        this.invokeCheckIMPShelper(component);
                    }                    //hrushikesh end
                    
                    //hrushikesh end
                    
                }
            }
            else{
                this.displayToastMessage(component,event,'Error','Error in validate IMPS','error');
                this.showhidespinner(component,event,false); 
            }
        });
    },
    invokeCheckIMPShelper : function(component, eventName) {
        this.showhidespinner(component,event,true);
        component.set(("v.disb.Loan_Application__c"),component.get('v.loanId')); 
        //Bug:20391 Start
        var functionName = '';
        if(eventName == 'recheckIMPS'){
            functionName = 'invokeRecheckIMPS';
        }
        else{
            functionName = 'invokeCheckIMPS';
        }
        //Bug:20391 End
        /* Bug 20391 Added functionName in argument of executeApex instead of harcoded function name*/
        this.executeApex(component, functionName, {"cddObject" : JSON.stringify(component.get("v.disbursment"))}, function(error, result) {
            // console.log('error message is'+result.errorMsg);
            if(!error && result) {
                var disbList = component.get("v.disbList");
                for(var i in disbList){
                    if(disbList[i].Id == result.disbObj.Id){
                        disbList[i] = result.disbObj;
                    }
                } 
                component.set("v.disbList",disbList);
                component.set("v.disbObj", result.disbObj);
                component.set("v.isTransactionalError", result.isTransactionalError);
                component.set("v.isAPIError", result.isAPIError);   
                //console.log('error message is'+result.errorMsg);
                //alert(component.get("v.isAPIError"));
                
                 var IMPSLabelValue= $A.get("$Label.c.IMPSResponse"); //25677
				 console.log('The Label is here'+IMPSLabelValue);
                 if (IMPSLabelValue.includes(component.get("v.disbObj.IMPS_Result__c"))) { //25677
               // if (component.get("v.disbObj.IMPS_Result__c") == 'Successful Transaction') {
                    
                    this.displayToastMessage(component,event,'Success',result.errorMsg,'success'); //21287 - there was no response shown when IMPS was successful
                    // disable Validate IMPS button as part of 21287 ***S***
                    var lVIMPS =   component.find("validateIMPS");
                    for(var i=0; i < lVIMPS.length; i++){
                        console.log('component.get("v.disbObj.Id") '+component.get("v.disbObj.Id"));
                        console.log('lVIMPS[i].get("v.value")  '+lVIMPS[i].get("v.value"));
                        if(lVIMPS[i].get("v.value") == component.get("v.disbObj.Id")){
                            lVIMPS[i].set("v.disabled",true);
                        }
                    }
                    // disable Validate IMPS button as part of 21287 ***E***
                } else if (component.get("v.isAPIError")) {
                    
                    // show wait and abort modal
                    if (result.errorMsg != null || result.errorMsg != undefined) {
                        this.displayToastMessage(component,event,'Error',result.errorMsg,'error');
                        //Error comes bcoz IMPS validation is only for NEFT,RTGS,etc
                    }
                    //this.showHideDiv(component, "alertDialog", true);
                } else if (component.get("v.isTransactionalError")) {
                    
                    if (result.errorMsg != null || result.errorMsg != undefined) {
                        // show toast
                        this.displayToastMessage(component,event,'Error',result.errorMsg,'error');
                        //this.ShowToast(component, "Error!", result.errorMsg, "error");
                    }
                }
                    else{
                        //alert(result.errorMsg);
                        this.displayToastMessage(component,event,'Message',result.errorMsg,'message'); //Bug-22785(Related to 20391) 
                    }
                
                // this.getFeesNChargesRecords(component);
            }
            else
            {
                this.displayToastMessage(component,event,'Error','Validate IMPS not applicable for selected Disbursal Mode.','error');
            }
            //  this.getFeesNChargesRecords(component);
            this.showhidespinner(component,event,false);
            this.BtnRender(component,event);//25677
        });
        
        
    },
    
    //Bug:20391 Start
    recheckIMPS : function(component, event) {
        console.log('Inside recheck****');
        var eventName = event.currentTarget.id;
        console.log('Button clicked***'+eventName);
        var disbAppId = event.currentTarget.value;
        this.showhidespinner(component,event,true);
        this.executeApex(component, "fetchDisbursementObject", {
            "disbId": disbAppId,
            "Loanid":component.get("v.loanId"),
            "objectFieldJSON":''
        }, function (error, result) {
            
            if (!error && result) {
                console.log('Sucess response received****');
                var result = JSON.parse(result);
                if(result.status == 'Fail'){
                    
                    this.showhidespinner(component,event,false);
                }
                else{
                    console.log('not error: '+JSON.stringify(result));
                    component.set("v.disb",result);
                    component.set("v.disbursment",result.disObj); // 20391 merging issue
                    
                    this.showhidespinner(component,event,false); 
                    var IMPSLabelValue= $A.get("$Label.c.IMPSResponse"); //25677
                    console.log('IMPSLabelValue '+IMPSLabelValue);
                   // if ( component.get("v.disb.IMPS_Result__c") != 'Successful Transaction') {
                    if (!IMPSLabelValue.includes(component.get("v.disb.IMPS_Result__c")))  { //25677
                        this.invokeCheckIMPShelper(component,eventName);
                        //this.showhidespinner(component,event,false); // 21287: to hide spinner because it was not disappearing
                    }
                } 
            }
            else{
                this.displayToastMessage(component,event,'Error','Error in recheck IMPS','error');
                this.showhidespinner(component,event,false); 
            }
        });
    },
    //Bug: 20391 End
    /* getFeesNChargesRecords : function(component) {
        console.log('in GetFees');
        this.executeApex(component, "fetchChargesCtrl", {"loanObject" : component.get("v.loan")}, function(error, result) {
            if(!error && result) {
                console.log('queryFeesNCharges --> ' + result);
                if(result != null) {
                    var impsChargeCode = $A.get("$Label.c.IMPS_Charge_Code").split(';');
                    var IMPSProcessingFeeAmt = Decimal.valueOf($A.get("$Label.c.IMPS_Processing_fee"));
                    var IMPSChargeAmt = Decimal.valueOf($A.get("$Label.c.IMPS_Transaction_charge"));
                    component.set("v.feesNChargesList", result);
                    console.log('====>> ' + component.get("v.feesNChargesList").length);
                   
                }
            } else {
            	console.log('result --> ' + result);
                this.displayToastMessage(component,event,'Error','Fees and charges issue','error');
                //this.ShowToast(component, "Error!", 'Fees and charges issue!', "error");
            }
        });
    },*/
    handleUpdateDisbursement : function(component, event){
        this.showhidespinner(component,event,true);
        this.executeApex(component, "fetchDisbursementList", {
            "loan" : JSON.stringify(component.get("v.loan")),
            "disburse" : event.getParam("disburse")
        }, function (error, result) {
            
            if (!error && result) {
                if(result == 'Fail'){
                    this.showhidespinner(component,event,false);
                }
                else{
                    var data = JSON.parse(result);
                    console.log('opp'+data.opp);
                    component.set("v.disbList",data.disburement);
                    component.set("v.loan",data.opp);
                    this.showhidespinner(component,event,false);
                }
                
            }
            console.log('Flag value****'+component.get('v.showIMPSResponse'));
        });
        
    },
    
    executeApex : function(component, method, params,callback){
        
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            console.log('calling method'+method);
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
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }, 
    setdisbursallisthelper:function(component,event)
    { 
        var loanid =component.get("v.loanId");
        console.log('inside handle event1'+component.get("v.loanId"));
        
        var fetchclonedetails = component.get("c.fetchDisbursementclone");
        fetchclonedetails.setParams({"oppid" :loanid});
        fetchclonedetails.setCallback(this,function(response){	
            var state = response.getState();
            console.log('state   - ' + state+response.getReturnValue() );
            if(state == "SUCCESS"){
                var result = response.getReturnValue();
                console.log(result);
                component.set("v.disbList",result);
            }
        });
        $A.enqueueAction(fetchclonedetails);
    },
    displayToastMessage:function(component,event,title,message,type)
    {
        
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
    //Bug-22785(Related to 20391) start
    saveIMPS : function(component, event){
        var disbAppId = event.currentTarget.value;
        console.log('Disbursement Id****'+disbAppId);
        var accntValidate = event.currentTarget.name;
        console.log('Account validate*****'+accntValidate);
        if(accntValidate){
            this.executeApex(component, "saveIMPSResponse", {
                "disbId": disbAppId,
                "accountValidate": accntValidate
            }, function (error, result) {
                if(!error && result){
                    if(result){
                        this.displayToastMessage(component,event,'Success','Response saved successfully!','success');  
                    }
                    else{
                        this.displayToastMessage(component,event,'Error','Failed to save record!','error'); 
                    }
                }   
                else{
                    this.displayToastMessage(component,event,'Error','Failed to save record!','error');  
                }
                this.showhidespinner(component,event,false);
            });   
        }
        else{
            this.displayToastMessage(component,event,'Error','Please enter value for IMPS Account validate','error');
            this.showhidespinner(component,event,false);
        }
        
    },
    //Bug-22785(Related to 20391) end
    
    BtnRender : function(component, event) {
        //Bug 25677---S
        var IMPSResult=[];
        var tempDisbList = component.get('v.disbList');
        
        var IMPSLabelValue= $A.get("$Label.c.IMPSResponse");
        
        console.log('Values:::'+JSON.stringify(tempDisbList));
        
        for ( var key=0; key<tempDisbList.length;key++ ) {
            
            console.log('bankValue'+tempDisbList[key].IMPS_Result__c);   
            console.log('bankKey'+key);
            console.log('bankKey'+tempDisbList[key].IMPS_Beneficiary_Name__c);
            if(!(IMPSLabelValue.includes(tempDisbList[key].IMPS_Result__c))){
                console.log('Its Matching'+tempDisbList[key].Id);
                
                IMPSResult.push({value:true, key1:tempDisbList[key].Id});
                
                
            }
        }
        component.set("v.IMPSRenderMap", IMPSResult);
        console.log('IMPSRenderMap'+JSON.stringify(component.get('v.IMPSRenderMap'))); 
        console.log('Flag value****'+component.get('v.showIMPSResponse'));
        //25677--E
        
        
    }
    
    
})