({
    saveData : function(component, event) {
        this.showhidespinner(component,event,true);
        /*SAL 2.0 CR's s*/
        console.log(component.get("v.loan.Approved_Loan_Amount__c") +' ----- '+ component.get("v.maxLoanAmt"));
        if($A.util.isEmpty(component.get("v.loan.Approved_Loan_Amount__c")) && component.get("v.loan.Approved_Loan_Amount__c") > component.get("v.maxLoanAmt")){
            this.displayToastMessage(component,event,'Error','Loan amount should not be blank and should be less than '+component.get("v.maxLoanAmt"),'error');    
            this.showhidespinner(component,event,false);
        }
        else{
            /*SAL 2.0 CR's e*/
            this.executeApex(component, 'approvePricing', {
                "loan": JSON.stringify(component.get("v.loan")),
                "appObj" : JSON.stringify(component.get("v.applicantPrimary")),
                "acc": JSON.stringify(component.get("v.acc"))
                
            }, function(error, result){
                if(!error && result){
                    if(!$A.util.isEmpty(result))
                    {
                        var dataObj = JSON.parse(result);
                        //prod issue start
                        component.set("v.loan",dataObj.opp);
                        component.set("v.acc",dataObj.accObj);
                        component.set("v.applicantPrimary",dataObj.applicantPrimary);
                        component.set("v.EMI",dataObj.opp.EMI_CAM__c);
                        //location.reload();
                        // user story 978 s
                        var updateidentifier =  $A.get("e.c:Update_identifier");
                        updateidentifier.setParams({
                            "eventName": 'Pricing Loan Details',
                            "oppId":component.get("v.loan").Id
                        });
                        updateidentifier.fire();
                        // user story 978 e
                        this.displayToastMessage(component,event,'Success','Rate and PF approved successfully!','success');
                    }
                    this.showhidespinner(component,event,false);
                }
            });
        }
    },
    calcDropLinePeriod: function(component,event){
        
        var flexiperiodValue;
        var tenorValue;
        var droplineId;
        var temp = 0;
        flexiperiodValue = component.find("PureFlexPeriod1").get("v.value");
        tenorValue = component.find("tenorLoan").get("v.value");
        droplineId = component.find("DropLinPeriod1").get("v.value");
        if(!$A.util.isEmpty(tenorValue))
            temp = parseInt(tenorValue - flexiperiodValue);
        if(!$A.util.isEmpty(temp)){
            component.find("DropLinPeriod1").set("v.value",temp);
        }
    },
    sendApprMailHelper : function(component, evemt) {
        this.showhidespinner(component,event,true);
        console.log('loan=- '+component.get("v.selectedValue"));
        /*SAL 2.0 CR's s*/
        if($A.util.isEmpty(component.get("v.loan.Approved_Loan_Amount__c")) || component.get("v.loan.Approved_Loan_Amount__c") > component.get("v.maxLoanAmt")){
            this.displayToastMessage(component,event,'Error','Loan amount should not be blank and should be less than '+component.get("v.maxLoanAmt"),'error');    
            this.showhidespinner(component,event,false);
        }
        else{
            /*SAL 2.0 CR's e*/
            // alert( component.get("v.approvedRate") + component.get("v.proposedRate"));
            this.executeApex(component, 'sendMailAppr', {
                "opp": JSON.stringify(component.get("v.loan")),
                "approvedROI" : component.get("v.approvedRate"), 
                "proposedROI" :  component.get("v.proposedRate"),
                "approvedPF" : component.get("v.approvedPF"),
                "proposedPF" :component.get("v.proposedPF"),
                "selectedOfficer" : component.get("v.selectedValue")
                
            }, function(error, result){
                if(!error && result){
                    if(!$A.util.isEmpty(result))
                    {
                        if(result == 'Success'){
                            // user story 978 s
                            var updateidentifier =  $A.get("e.c:Update_identifier");
                            updateidentifier.setParams({
                                "eventName": 'Pricing Loan Details',
                                "oppId":component.get("v.loan").Id
                            });
                            updateidentifier.fire();
                            // user story 978 e
                            
                            this.displayToastMessage(component,event,'Success','Mail has been sent to heirarchy, Please wait for Approval!','success');
                            component.set("v.selectApproval",false);
                        }
                        else{
                            this.displayToastMessage(component,event,'Error','Failed to send mail to hierarchy','fail');
                        }
                    }
                    this.showhidespinner(component,event,false);
                }
                else{
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error','Failed to send mail','error');
                }
            });
        }
    },
    sendEmailToHeirarchy : function(component, evemt) {
        //debugger;
        this.showhidespinner(component,event,true);
        console.log('loan=- '+JSON.stringify(component.get("v.loan")));
        this.executeApex(component, 'sendMail', {
            "opp": JSON.stringify(component.get("v.loan")),
            "approvedROI" : component.get("v.approvedRate"), 
            "proposedROI" :  component.get("v.proposedRate"),
            "approvedPF" : component.get("v.approvedPF"),
            "proposedPF" :component.get("v.proposedPF"),
            "appObj" : JSON.stringify(component.get("v.applicantPrimary")),
        }, function(error, result){
            if(!error && result){
                if(!$A.util.isEmpty(result))
                    console.log('Result'+result);
                {
                    if(result == 'Sales Master not maintained' || result=='[]'){
                        this.displayToastMessage(component,event,'Info','Sales Master not maintained','info');
                    }
                    else if(result == 'show no error msg'){
                        this.displayToastMessage(component,event,'Info','All Okay','info');
                    }
                    else if(result == 'ROI/PF cannot be approved'){
                        this.displayToastMessage(component,event,'Error','ROI/PF cannot be approved','error');
                    }
                    else if(result == 'invalidROIPF'){
                        this.displayToastMessage(component,event,'Error','ROI/PF cannot be approved','error');
                        component.set("v.selectApproval",false);
                         if(!component.get("v.showApprove"))
      				    component.find("sendMail").set("v.disabled",false);
                    }
                        else if (result == 'default'){
                        this.displayToastMessage(component,event,'Info','Kindly Approve','info');
                        component.set("v.showApprove",true);
                        component.set("v.selectApproval",false);
                           
                        }
                    
                    else{
                        component.set("v.solList",JSON.parse(result));
                        component.set("v.selectApproval",true);
                        component.set("v.selectedValue",(JSON.parse(result))[0].value);
                        component.set("v.showApprove",false);//this is for button 1652
                        this.displayToastMessage(component,event,'Info','Please select sales officer','info');
                    }
                    console.log('sollist'+component.get("v.solList").length);
                }
                this.showhidespinner(component,event,false);
            }
            else{
                this.displayToastMessage(component,event,'Error','Failed to send mail','error');
            }
        });
    },
    executeApex: function(component, method, params,callback){
        
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
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
})