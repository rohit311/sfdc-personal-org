({
    getData : function(component) {
        var oppId = component.get("v.oppId");
        if(oppId != null){
            this.executeApex(component, "getDisbursmentData", {
                "oppId" : oppId
            }, function (error, result) {
                
                if (!error && result) { 
                    console.log('result '+result);
                    var objlst = JSON.parse(result);
                    component.set("v.repay",objlst.repay);
                    component.set("v.opp",objlst.opp);
                    component.set("v.emi",objlst.emiTemp);
                    component.set("v.tenor",objlst.tenorTemp);
                    component.set("v.disb",objlst.disb);
                    component.set("v.bankAcc",objlst.bankAcc);
                    component.set("v.primaryApplicant",objlst.primaryApplicant);
                    component.set("v.con",objlst.con);
                    component.set("v.processingFee",objlst.processingFee);
                    component.set("v.netDisbursementAmount",objlst.netDisbursementAmount);
                    if(!$A.util.isEmpty(objlst.repay))
                    {
                        component.set("v.ECSAmount",objlst.repay.ECS_Amount__c);
                    }
                    component.set("v.LastDate",objlst.LastDate);
                    //alert('H'+objlst.primaryApplicant.KYC_Verifications__c+objlst.repay.Open_ECS_Facility__c);
                    console.log('insurance list is '+JSON.stringify(objlst.opp.Insurance__r));
                    //console.log(objlst.primaryApplicant.Customer_Decline_Reasons__c+'ok'+objlst.primaryApplicant.Application_Form_Timestamp__c + objlst.primaryApplicant.IP_Address_Timestamp__c )
                    /*if(objlst.opp.Loan_Type == 'Flexi Term Loan'){
                        component.set("v.ECSAmount",objlst.primaryApplicant.Pure_Flexi_EMI__c);
                    }else{
                        component.set("v.ECSAmount",objlst.opp.EMI_CAM__c);
                    }*/
                    if(objlst.opp.Insurance__r != null){
                        component.set("v.isInsurancePresent",true);
                        component.set("v.insuranceList",objlst.opp.Insurance__r);
                        
                        console.log('this is '+ component.get('v.insuranceList')[0].Insurance_Product__c);
                    }
                    
                    if(objlst.primaryApplicant.KYC_Verifications__c ==true)
                    {
                        component.set("v.KycCheck",true);
                    }
                    if(objlst.repay!=null && objlst.repay.Open_ECS_Facility__c !=null && objlst.repay.Open_ECS_Facility__c =='Existing')
                    {
                        component.set("v.EcsCheck",true);
                    }
                    if(objlst.opp.StageName != 'Post Approval Sales' || objlst.primaryApplicant.Employee_Modified__c == true || !$A.util.isEmpty(objlst.primaryApplicant.Decline_Reasons__c) ){//|| !$A.util.isEmpty(objlst.primaryApplicant.Customer_Decline_Reasons__c) ){
                        console.log('inside read only condition+ '+objlst.primaryApplicant.Employee_Modified__c+objlst.opp.StageName+objlst.primaryApplicant.Decline_Reasons__c);
                    	component.set("v.displayReadOnly",true);
                    }
                    else{
                        component.set("v.displayReadOnly",false);
                    }
                     console.log('in empty'+objlst.primaryApplicant.Application_Form_Timestamp__c);
                    if(objlst.primaryApplicant.IP_Address_Timestamp__c==null )
                    {
                        console.log('in empty'+objlst.primaryApplicant.Application_Form_Timestamp__c);
                        //component.set("v.disableECSButton",false);
                        //component.set("v.showValidationMsgOnSubmit",true);
                        component.set("v.showSubmit",false);
                        component.set("v.showConfirm",true);
                    } 
                    //component.set("v.disableECSButton",false); //initially it will false
                    if(objlst.primaryApplicant.Application_Form_Timestamp__c=='Acceptance Pending' ||objlst.primaryApplicant.IP_Address_Timestamp__c=='Acceptance Pending' )
                    {
                        console.log('dont show sumbit button');
                        component.set("v.disableECSButton",true);
                        component.set("v.showValidationMsgOnSubmit",true);
                        component.set("v.showSubmit",true);
                        component.set("v.showConfirm",false);
                    } 
                    else if(!$A.util.isEmpty(objlst.primaryApplicant.Application_Form_Timestamp__c) && !$A.util.isEmpty(objlst.primaryApplicant.IP_Address_Timestamp__c) && objlst.primaryApplicant.Application_Form_Timestamp__c.includes("Accepted") && objlst.primaryApplicant.IP_Address_Timestamp__c.includes("Accepted")){
                        component.set("v.showValidationMsgOnSubmit",false);
                        component.set("v.disableECSButton",true);
                        component.set("v.showSubmit",true);
                        component.set("v.showConfirm",false);

                    }
                    this.showhidespinner(component,event,false);
                    if(objlst.primaryApplicant.Emp_tele_identifier__c == true)
                    {
                        component.find("ConfirmTC").set("v.disabled", true);
                        component.find("eMandateButton").set("v.disabled", true);
                    }
                    this.callDoinitMethodToRefrshVASPage(component,event);
                    
                }
            });
        }
        
    },
    checkCustomer : function(component) {
        var oppId = component.get("v.oppId");
        if(oppId != null){
            this.executeApex(component, "initiateOpenEcsForEmployeeLoanMethod", {
                "opp" : oppId
            }, function (error, result) {
                
                if (!error && result) { 
                    console.log('Hv result repayObj '+result);
                    var objlst = JSON.parse(result);
                    // console.log('repayObject got in return -->'+JSON.stringify(repayObj));
                    component.set("v.repay",objlst.repay);
                    console.log('Status of ECS '+objlst.isOpenEcsSuccess+objlst.repay.ECS_Start_Date__c);
          
                    this.showhidespinner(component,event,false);
                    if(objlst.isOpenEcsSuccess == 'false')
                    {
                        var emandate = component.find("emandate");
                        emandate.employeeLoanDirectCall();
                    }
                    if(objlst.isOpenEcsSuccess == 'true')
                    {
                        this.getData(component);
                        this.displayToastMessage(component,event,'Success','Initiated Open ECS successfully','success');
                        
                    }
                }
                
            });
        }
    },
    sendBothMails:function(component,event){
        this.showhidespinner(component,event,true)
        component.set("v.disableECSButton",true);
        console.log('Hirhe ='+component.get("v.repay"));
        this.executeApex(component, 'sendE_aggrementMail', {
            "oppId":component.get('v.oppId')
        },   
                         function (error, result) {
                             if (!error && result) {
                                 this.displayToastMessage(component,event,'Success','Dear Customer , we have sent E-Mail/SMS containing links for accepting E-Application and E-Agreement','success');
                             }
                             else{
                                 this.displayToastMessage(component,event,'Error','Error in sending Mail','error');
                             }
                             
                             this.showhidespinner(component,event,false);   
                         }); 
     
    },
    clicksubmitMethod:function(component,event){
        this.showhidespinner(component,event,true);
        this.executeApex(component, 'sendToFinnoneOrBranchOps', {
            "oppId":component.get('v.oppId')
        },   
                         function (error, result) {
                             console.log('yeos '+result);
                             if (!error && result) {
                                 if(result != 'Acceptance Pending'){
                                 var objlst = JSON.parse(result);
                                 console.log('eys'+objlst.FinnoneErrorMsg);
                                  if(objlst.showKYCError=='true' || objlst.showRiskSegmentationError=='true'){
                                     if(objlst.showKYCError=='true' && objlst.showRiskSegmentationError!='true')
                                         this.displayToastMessage(component,event,'Error','Kindly upload 1.KYC in Upload Document Section and re-click on submit to faster processing of your loan application','error');
                                      else if(objlst.showKYCError!='true' && objlst.showRiskSegmentationError=='true')
                                         this.displayToastMessage(component,event,'Error','Kindly upload 1. Three Post Dated Cheques in Upload Document Section and re-click on submit to faster processing of your loan application','error');
                                      else if(objlst.showKYCError=='true' && objlst.showRiskSegmentationError=='true')
                                         this.displayToastMessage(component,event,'Error','Kindly upload 1.KYC, 2. Three Post Dated Cheques in Upload Document Section and re-click on submit to faster processing of your loan application','error');
                                  }else if(!$A.util.isEmpty(objlst.FinnoneErrorMsg))
                                 {
                                     this.displayToastMessage(component,event,'Error','Unable to send to Finnone '+objlst.FinnoneErrorMsg,'error');
                                 }
                                     else if(!$A.util.isEmpty(objlst.sentToWhere)){
                                         this.displayToastMessage(component,event,'Success','Loan application has been sent to '+objlst.sentToWhere+' successfully','success');
                                         component.set("v.isExit",true);
                                     }
                                         else
                                             this.displayToastMessage(component,event,'Error','Unable to send to BranchOps/Finnone','error');
                                 }else if(result == 'Acceptance Pending'){
                                     this.displayToastMessage(component,event,'Info','Please accept Application and E-Aggreement Form','info');
                                 }
                             }
                             else{console.log('error in disb');}
                             
                             this.showhidespinner(component,event,false);   
                         }); 
    },
    executeApex : function(component, method, params,callback){
        
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
    callDoinitMethodToRefrshVASPage : function(component, event){
            var appEvent = $A.get("e.c:reloadVASPage");
            if(appEvent){
                appEvent.fire();
           
     }
    },
    // Added by Anurag for 22181
    firePassInsuranceEvent : function(component, insuranceList){
        console.log("VALIDATIONS EVT FIRED");
        var compEvents = $A.get("e.c:InsuranceCMPValidations");
        console.log('firePassInsuranceEvent ===>> ',compEvents);
        compEvents.setParams({ "insuranceList" : insuranceList });
        compEvents.fire();
     }
    })
/*
 *  <!-- <lightning:accordionSection class="color1" name="Insurance Details Section" label="Insurance Details Section">
            <aura:if isTrue ="{!v.isInsurancePresent}">    
                
                <div class="slds-form-element slds-p-top--x-small slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--6-of-6 slds-large-size--12-of-12">
                    <div class="slds-form-element__control">
                        <aura:iteration items="{!v.insuranceList}" var="insuranceObj" indexVar = "index">
                            <div class="slds-form-element slds-p-top--x-small slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--3-of-6 slds-large-size--4-of-12">
                                <lightning:input aura:id="{!'insuranceObj'+(index+1)}" name="{!'Insurance Product '+(index+1)}" value="{!insuranceObj.Insurance_Product__c}" label="{!'Insurance Product '+(index+1)}" disabled="true"/>
                            </div>
                        </aura:iteration>
                    </div>
                </div>
                <aura:set attribute="else">
                    <div class="slds-form-element slds-p-top--x-small slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--6-of-6 slds-large-size--12-of-12">
                        <div class="slds-form-element__control">
                            <ui:message severity="warning" closable="false">
                                <lightning:icon iconName="utility:info" variant="warning" class="iconSize"/>&nbsp;
                                <span> No Insurance products present currently </span>
                            </ui:message>                            </div>
                    </div>
                </aura:set>
            </aura:if>
        </lightning:accordionSection> -->
 */