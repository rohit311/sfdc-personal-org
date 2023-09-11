({
    eKycCheck : function(component, event) {
        var loanAppId = component.get('v.parentId'); 
        var action = component.get('c.getSelectCreditOfficer');
        action.setParams({
            loanApplicationId : loanAppId 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('SON.parse(response.getReturnValue())>>');
            console.log(JSON.parse(response.getReturnValue()));
            if (state === "SUCCESS") {
                var data = JSON.parse(response.getReturnValue());
                if(!$A.util.isEmpty(data.checklistdocument)){
                    if(!$A.util.isEmpty(data.checklistdocument.standardDoc))
                	component.set("v.standardChecklist",data.checklistdocument.standardDoc);
                	if(!$A.util.isEmpty(data.checklistdocument.deviationDoc))
               		component.set("v.deviationChecklist",data.checklistdocument.deviationDoc);
                    
                    //Rohit 16111 CR S
					component.set("v.isEkycMandatory", data.aadharMandatory);
                	component.set("v.isEkycdone", data.appEkyc);
                	console.log('rohit '+component.get('v.isEkycMandatory')+'----'+component.get('v.isEkycdone'));
					//Rohit 16111 CR E
                    
                    if(!$A.util.isEmpty(data.checklistdocument.picklistDataList) && !$A.util.isEmpty(data.checklistdocument.picklistDataList[0].picklistData)){                    
                        var picklistFields = data.checklistdocument.picklistDataList[0].picklistData;
                        var checklistPickFlds = picklistFields["Checklist__c"];
                        console.log(checklistPickFlds);
                         console.log( checklistPickFlds["Sales_Status__c"]);
                        component.set("v.statusList", checklistPickFlds["Sales_Status__c"]);
                    }
                }
                if(!$A.util.isEmpty(data.theme)){
                    component.set('v.nameTheme',data.theme);
                }
                if (!$A.util.isEmpty(data.isCommunityUsr)){
                        component.set('v.iscommunityUser', data.isCommunityUsr);
                }
                console.log('result+aman+'+JSON.stringify(response.getReturnValue())+'--'+JSON.parse(response.getReturnValue()));
                component.set('v.kyc',JSON.parse(response.getReturnValue()).ekycobj);
                console.log(component.get('v.kyc'));
                component.set('v.documentMessage',JSON.parse(response.getReturnValue()).status);
            }
        });
        $A.enqueueAction(action);
    },
   onLoadRecordCheck : function(component, event) {
        var action = component.get('c.getOppActionTabData');
        var loanAppId = component.get('v.parentId');
        action.setParams({
            loanApplicationId : loanAppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(response.getReturnValue())) {
                     var data = JSON.parse(response.getReturnValue());
                    if (!$A.util.isEmpty(data.theme)){
                         component.set('v.nameTheme', data.theme);
                     }
					if (!$A.util.isEmpty(data.isCommunityUsr)){
                        component.set('v.iscommunityUser', data.isCommunityUsr);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    onLoadRecordCheckForSF1 : function(component, event) {
        var action = component.get('c.getLoanApplicationListViews');
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var listviews = response.getReturnValue();
                //component.set('v.nameTheme', response.getReturnValue());
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": listviews.Id,
                    "listViewName": null,
                    "scope": "Opportunity"
                });
                navEvent.fire();
            }
        });
        $A.enqueueAction(action);
        //alert('enqueueAction');
    },
    loadData: function(component, event) {
        var loanAppId = component.get('v.parentId'); 
        var action = component.get('c.getCreditOfficerLimit');
        action.setParams({
            loanApplicationId : loanAppId 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.wrapperList', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    applicantRecord: function(component, event) {
        //call apex class method
       
        var loanAppId = component.get('v.parentId'); 
        var primaryAppLicant = component.get('v.primaryApp'); 
        var isSuccessMsg = true;
        var picklistId = component.find("wrapId");
        if(picklistId.get("v.validity").valid)
            console.log('picklistId'+isSuccessMsg);
        else{
            picklistId.showHelpMessageIfInvalid();
            isSuccessMsg = false;
        }
        
         //Rohit 16111 CR added condition S
        
        //if((component.get('v.isEkycMandatory') == true && component.get('v.isEkycdone') == true) || (component.get('v.isEkycMandatory') == false)){

            var action = component.get('c.getFetchApplicant');
            action.setParams({
                loanApplicationId : loanAppId, 
                priApp : primaryAppLicant,
                StrAppr1 : component.get('v.selectedValue')
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS"){
                     this.hideSpinner(component);
                }
                else
                    this.hideSpinner(component);
            });
            if(isSuccessMsg == true)
            {
                 this.showSpinner(component);
                $A.enqueueAction(action);
                
                if(component.get('v.nameTheme') =='Theme3' || component.get('v.nameTheme') =='Theme2'){
                    if(component.get('v.iscommunityUser'))
                        window.location.href = '/Partner/006/o';
                    else
                        window.location.href = '/006/o';
           		 }else if(component.get('v.nameTheme') == 'Theme4d')
                    window.location.href = '/one/one.app?source=alohaHeader#/sObject/Opportunity/list?filterName=Recent';
                else if(component.get('v.nameTheme') == 'Theme4t')
                    this.onLoadRecordCheckForSF1(component, event);
            }
       /* } else{
            this.displayMessage(component, 'ErrorToast', 'errormsg', '<b>Error!</b>,Please initiate Ekyc !');
        }*/
        //Rohit 16111 CR added condition E 
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
     closeSuccessToastHelper : function(component, event){
        document.getElementById('parentSuccessToast').style.display = "none";
        document.getElementById('parentSuccessMsg').innerHTML = "";
    },
    closeErrorToastHelper : function(component){
		document.getElementById('parentErrorToast').style.display = "none";
        document.getElementById('parentErrorMsg').innerHTML = "";
        
    },
    closeInfoToastHelper : function(component){
		document.getElementById('displayInfoToast').style.display = "none";
        document.getElementById('displayInfoMsg').innerHTML = "";
        
    },
     displayMessage: function (component, toastid, messageid, message) {
        document.getElementById(toastid).style.display = "block";
       // if(component.get('v.nameTheme') == 'Theme4d'){
      //  var toastClasses = document.getElementById("ErrorToast").classList;
            // toastClasses.add("lightningtoast");
        //document.getElementById(toastid).classList.add("lightningtoast");  
        // }
        document.getElementById(messageid).innerHTML = message;
        console.log('message'+message +'toastid>>'+toastid+'messageid>>'+messageid);
        
        setTimeout(function () {
            document.getElementById(messageid).innerHTML = "";
            document.getElementById(toastid).style.display = "none";
        }, 3000);
    },
    getDocuments : function(component, event,helper) {
    
    	var action = component.get('c.generateChecklistDoc');
        action.setParams({
            "oppId" : component.get('v.parentId')
        });
        action.setCallback(this, function(response){
            
            var state = response.getState();
            if (state == "SUCCESS") {
                console.log('generate checklist result');
                console.log(response.getReturnValue());
                var data = response.getReturnValue();
                if(!$A.util.isEmpty(data.ErrorMessage)){
                    this.hideSpinner(component);
                     console.log('generate checklist result1');
                      console.log(response.getReturnValue());
                	this.displayMessage(component, 'displayErrorToast', 'displayErrorMsg', '<b>Error!</b>,Error while processing!');
                }
                else {
                    if(!$A.util.isEmpty(data.standardDoc))
                	component.set("v.standardChecklist",data.standardDoc);
                    if(!$A.util.isEmpty(data.deviationDoc))
                        component.set("v.deviationChecklist",data.deviationDoc);
                    if(!$A.util.isEmpty(data.picklistDataList) && !$A.util.isEmpty(data.picklistDataList[0].picklistData)){
                        
                        var picklistFields = data.picklistDataList[0].picklistData;
                        var checklistPickFlds = picklistFields["Checklist__c"];
                        console.log(checklistPickFlds);
                         console.log( checklistPickFlds["Sales_Status__c"]);
                        component.set("v.statusList", checklistPickFlds["Sales_Status__c"]);
                        
                        
                    }
                        
                    
                    console.log(data.standardDoc);
                    this.hideSpinner(component);
                    this.displayMessage(component, 'displaysuccessToast','displaysuccessMsg', '<b>Success!</b> Documents and deviations generated successfully.');
             
                }
                      
            }
            else{
                this.hideSpinner(component);
                this.displayMessage(component, 'displayErrorToast', 'displayErrorMsg', '<b>Error!</b>,Error while processing!');
            }
                
        });
        $A.enqueueAction(action);
	},
    saveDocuments : function(component, event,helper) {
        var action = component.get('c.savedocuments');
        action.setParams({
            "oppId" : component.get('v.parentId'),
            "standardDoc" : JSON.stringify(component.get("v.standardChecklist")),
            "deviationDoc" : JSON.stringify(component.get("v.deviationChecklist"))
        });
        action.setCallback(this, function(response){
            this.hideSpinner(component);
            var state = response.getState();
            if (state == "SUCCESS") {
                console.log('success');
                component.set('v.documentMessage',JSON.parse(response.getReturnValue()).status);
                this.displayMessage(component, 'displaysuccessToast','displaysuccessMsg', '<b>Success!</b> Details saved successfully.');
            }
            else
              this.displayMessage(component, 'displayErrorToast', 'displayErrorMsg', '<b>Error!</b>,Error while processing!');
        });
        $A.enqueueAction(action);
    }
})