({
    callFetchData : function(component, event) {
    	var loanObj;
        var action = component.get("c.queryData");
        console.log('loan object id is:');
        console.log(component.get("v.LoanId"));
        action.setParams({
            "oppId": component.get("v.LoanId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                
                loanObj = response.getReturnValue();
                console.log('loanObj ====>> '+ JSON.stringify(loanObj));
                debugger;
                if(loanObj.length > 0 && (loanObj[0].StageName == 'DSA/PSF Login' || loanObj[0].StageName == 'Post Approval Sales' || loanObj[0].StageName == 'Branch Ops' || loanObj[0].StageName == 'Moved To Finnone' ))
                {
                    //Bug 24237 S
                    component.set("v.stpNonStp",loanObj[0].Account.Process_Flow__c);
                    //Bug 24237 E
                    component.set("v.oppoObj", loanObj[0]);
                    component.set("v.accountObj", loanObj[0].Account);
                    
                     //Bug 22425 CC Code changes SME S
					if(loanObj[0].SOL_Policys__r != undefined){
                        if(loanObj[0].SOL_Policys__r[0].CC_Number__c!=undefined && loanObj[0].SOL_Policys__r[0].CC_Number__c!='' && loanObj[0].SOL_Policys__r[0].CC_Number__c!=null){
                            component.set("v.isCreditDoneAtPO",'true');  
                        }
                    }
                    //Bug 22425 CC Code changes SME E
                    if(loanObj[0].Fees_and_Charges__r != undefined)
                    	component.set("v.feesNChargesListParent", loanObj[0].Fees_and_Charges__r);
                    if(loanObj[0].Insurance__r != undefined)
                    	component.set("v.insuranceListParent", loanObj[0].Insurance__r);
                    //Bug 22141 S
                    if(loanObj[0].Loan_Application__r != undefined)
                    {
                        component.set("v.applicantParent", loanObj[0].Loan_Application__r[0]);
                    	console.log('applicant parent');
                    	console.log(loanObj[0].Loan_Application__r[0].Id);
                        component.set("v.appId",loanObj[0].Loan_Application__r[0].Id);
                        this.callFraudValidationCheck(component,event);
                        
                    }
					// Bug 22141 E

                    if(loanObj[0].Loan_Application__r != undefined)
                    	component.set("v.applicantParent", loanObj[0].Loan_Application__r[0]);
                    console.log('applicant parent');
                    console.log(component.get("v.applicantParent"));

                    component.set("v.contactParent", component.get("v.applicantParent").Contact_Name__r);

                    if(loanObj[0].Current_Disbursal_Details_s__r != undefined)
                    {
                    	component.set("v.currentDisbDetailsId", loanObj[0].Current_Disbursal_Details_s__r[0].Id);
                        console.log('first test'+component.get("v.currentDisbDetailsId"));
                        component.set("v.cddObjParent", loanObj[0].Current_Disbursal_Details_s__r[0]);
                    }
                    
                    if(loanObj[0].RePayment_mode_details__r != undefined)
                    {
                    	component.set("v.repaymentDetailsId", loanObj[0].RePayment_mode_details__r[0].Id);
                        component.set("v.rmdObjParent", loanObj[0].RePayment_mode_details__r[0]);
                    }
                    
                    if(loanObj[0].Product_Offerings__r != undefined)
                    	component.set("v.productOffering", loanObj[0].Product_Offerings__r[0]);
                    component.set("v.isStp", true);
                    if (component.get("v.oppoObj").StageName == 'Post Approval Sales' || component.get("v.oppoObj").StageName == 'Branch Ops' || component.get("v.oppoObj").StageName == 'Moved To Finnone') 
                    {
                        this.triggerDisableFormEvent(component, component.get("v.oppoObj").StageName);
                    }

                } else {
                    debugger;
                   this.showToast(component, 'Info', 'LAN is not of STP flow or stage is not correct', 'info');
                   component.set("v.isStp", false);
                }
            }
        });
        $A.enqueueAction(action);
        
    },
        //Bug 22141 S
        callFraudValidationCheck : function(component, event) {
        var action = component.get("c.fraudValidationCheck");
        action.setParams({
            "appId": component.get("v.appId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {   
                debugger;
                component.set("v.FraudValidationResult",response.getReturnValue());
            	console.log(component.get("v.FraudValidationResult"));
            }
            
        });
        $A.enqueueAction(action);
        
    },
    //Bug 22141 E
    
    activateTab: function(component, tabId) {
        
        $A.util.removeClass(component.find("loanInfotab"), "slds-active");
        $A.util.removeClass(component.find("ckycTab"), "slds-active");
        $A.util.removeClass(component.find("obligationTab"), "slds-active");
        $A.util.removeClass(component.find("commercialsTab"), "slds-active");
        $A.util.removeClass(component.find("insuranceTab"), "slds-active");
        $A.util.removeClass(component.find("feesTab"), "slds-active");
        $A.util.removeClass(component.find("disbursalTab"), "slds-active");
        $A.util.addClass(component.find(tabId), "slds-active");
        
        this.showHideDiv(component, "loanInfotabContent", false);
        this.showHideDiv(component, "ckycTabContent", false);
        this.showHideDiv(component, "obligationTabContent", false);
        this.showHideDiv(component, "commercialsTabContent", false);
        this.showHideDiv(component, "insuranceTabContent", false);
        this.showHideDiv(component, "feesTabContent", false);
        this.showHideDiv(component, "disbursalTabContent", false);
        this.showHideDiv(component, tabId+"Content", true);
    },
    showHideDiv: function(component, divId, show){
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
         
    hideAllTabs : function(component){
    	component.set("v.hot",false);
    	component.set("v.fresh",false);
    	component.set("v.followUp",false);
    	component.set("v.docsRec",false);
    	component.set("v.others",false);
    },
    showToast: function(component, title, message, type){
        
        var toastEvent = $A.get("e.force:showToast");
      
        if(toastEvent){
            toastEvent.setParams({ 
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "3000"
            });    
            toastEvent.fire();
        } else {
            var toastTheme = component.find("toastTheme");
            $A.util.removeClass(toastTheme, "slds-theme--error");
            $A.util.removeClass(toastTheme, "slds-theme--success");
            if(type == 'error'){
                $A.util.addClass(toastTheme, "slds-theme--error");
            } else if(type == 'success'){
                $A.util.addClass(toastTheme, "slds-theme--success");
            }
            component.find("toastText").set("v.value", message);
            component.find("toastTtitle").set("v.value", title+' ');
            this.showHideDiv(component, "customToast", true);
        }
    },
    closeToast: function(component){
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme, "slds-theme--error");
        $A.util.removeClass(toastTheme, "slds-theme--success");
        this.showHideDiv(component, "customToast", false);
    },
    triggerDisableFormEvent: function(component, loanStage){
        var event = $A.get("e.c:DisableFormEvent");
       
        console.log('loanstage'+loanStage);
        event.setParams({"loanStage": loanStage});
       
        event.fire();
        /*var LANCard = component.find("LanCard");
  		LANCard.DisableLANCard(loanstage);
        */
        //console.log('event -->', event);
        component.set("v.shouldBeDisable",true);
    },
    assignDefaultToPassInsuranceListEvt: function(component){
    var compEvents = $A.get("e.c:PassInsuranceListEvent");//$A.getEvent("passInsuranceListEvt");
        console.log('inside assignDefaultToPassInsuranceListEvt');
        console.log('firePassInsuranceEvent ===>> '+compEvents);
        compEvents.setParams({ "insuranceList" : [] });
        compEvents.fire();
	},
    // Bug 23556 S
  getUserInfo: function(component){
      
        var action = component.get('c.getUserDataLAN');
        console.log('inside get user');
        action.setCallback(this,function(response){
            var state = response.getState();
       		console.log('inside callback');
            if(state == 'SUCCESS')
            {
                
                component.set("v.isCommunityUsr", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
   
	},//added for 24487 EMI Card
    updateFetchCharges : function(component,event,helper){
        console.log('Calling chaegre api');
        var action = component.get("c.queryFeesNCharges");
        action.setParams({
            "loanObject": component.get("v.oppoObj"),
       });
       action.setCallback(this, function(response){
        	var state = response.getState();
            console.log('====response '+response.getReturnValue());
        	if (component.isValid() && state === "SUCCESS") {
                if(response.getReturnValue() != null)
                {
                   component.set("v.feesNChargesListParent", response.getReturnValue());
                    //console.log('====>> '+component.get("v.feesNChargesList").length);
                   
            	}
           }
           	});
        $A.enqueueAction(action);
    },
      //6863 Validations before triggering E-Agreement S
     callCommercialDetails : function(component,event,helper){
        this.executeApex(component, "callCommercialDetails", {"opp" : component.get("v.oppoObj")}, function(error, result) {
            
        });
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
                this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
    //6863 Validations before triggering E-Agreement E
})