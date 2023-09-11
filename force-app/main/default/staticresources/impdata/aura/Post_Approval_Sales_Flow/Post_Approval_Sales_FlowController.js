({
    menuItemClick: function(component, event, helper){ 
        helper.activateTab(component, event.target.getAttribute('id'));
    },
    doInit : function(component, event, helper) {
        component.set("v.showspinnerflag",true);
        component.set("v.pricingId",component.get("v.recordId"));
        //alert('vv++'+component.get("v.pricingId")+' '+component.get("v.recordId"));
       /* var action = component.get("c.getUIThemeDescription");
        action.setParams({
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                 component.set("v.Spinner",false);
                component.set('v.nameTheme', response.getReturnValue());
                
                if(component.get('v.nameTheme') == 'Lightning Experience'){
                	var maindiv = component.find('docDiv');
                    $A.util.removeClass(maindiv,'offer-pg1'); 
                    $A.util.addClass(maindiv,'offer-pg1-exp'); 
                }
                                
            }
                 component.set("v.Spinner",false);

        });*/
        
        //YK check component loading start...
        console.log('checkRedirectionValidity --pricingId-->> '+component.get("v.pricingId"));
    	var action = component.get("c.checkRedirectionValidity");
        action.setParams({
            "oppId": component.get("v.pricingId"),
            "flowName": 'pricingFlow'
        });
        action.setCallback(this, function(response){
        	var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
                console.log('...inside success...');
                var wrapperObj = response.getReturnValue();
                console.log('wrapperObj.errorMessageString--->> '+wrapperObj.errorMessageString);
           		if(wrapperObj.errorMessageString != 'NO_ERROR')
                {
                    component.set("v.cmpLoadMsg", wrapperObj.errorMessageString);
                }    
        	}
    	});
        $A.enqueueAction(action);        
        //YK check component loading end...
        var action = component.get("c.getPostApprovalSalesData");
        action.setParams({
            "loanApplicationId": component.get("v.pricingId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
               component.set("v.showspinnerflag",false);
                 if (!$A.util.isEmpty(response.getReturnValue())) {
                     var data = JSON.parse(response.getReturnValue());
                     if (!$A.util.isEmpty(data.applicantPrimary)){
                            component.set('v.primaryapplicant', data.applicantPrimary);
                         console.log(data.applicantPrimary);
                         	if(!$A.util.isEmpty(data.applicantPrimary.Send_pricing_email_to_customer__c)){
                         		component.set('v.isEmailSend', data.applicantPrimary.Send_pricing_email_to_customer__c);
                     		}
                     } 
					if (!$A.util.isEmpty(data.theme)){
                         component.set('v.nameTheme', data.theme);
                         if(component.get('v.nameTheme') =='Theme4d'){
                            var maindiv = component.find('docDiv');
                            $A.util.removeClass(maindiv,'offer-pg1'); 
                            $A.util.addClass(maindiv,'offer-pg1-exp'); 
                         }
					 }
					if (!$A.util.isEmpty(data.isCommunityUsr)){
                        component.set('v.iscommunityUser', data.isCommunityUsr);
                    }
                 }
            }
            else
                component.set("v.showspinnerflag",false);
        });
        $A.enqueueAction(action);
    },
    pricingEmailToCustomer : function(component, event, helper) {
		component.set("v.showspinnerflag",true);
        var action = component.get("c.sendPricingEmailToCustomer");
        //alert("Action there!");
        action.setParams({
            "oppId": component.get("v.pricingId"),
            "firtEMIDate": component.get("v.EMI1stDate"),
            "lastEMIDate": component.get("v.EMILastDate"),
            "brokenPeriodInt": component.get("v.BPI"),
            "emi": component.get("v.EMI")
        });
        action.setCallback(this, function(response) {
            component.set('v.isEmailSend', false);
            if (response.getState() == "SUCCESS") {
                component.set('v.isEmailSend', response.getReturnValue());
                component.set("v.showspinnerflag",false);
            }
            else
               component.set("v.showspinnerflag",false);
           
        });
        $A.enqueueAction(action);
        console.log('If - Saved - Send to Customer');
        
    },
    handleDisbusmentAttr : function(component, event, helper) {
        component.set("v.EMI1stDate", event.getParam("EMI1stDate"));
        component.set("v.EMILastDate", event.getParam("EMILastDate"));
        component.set("v.BPI", event.getParam("BPI"));
        component.set("v.EMI", event.getParam("EMI"));
        console.log("EMI1stDate+" + component.get("v.EMI1stDate"));
    },
   
    save : function(component, event, helper) {
        component.set("v.showspinnerflag",true);
        var docType = component.find("selectedDoc");
        if(docType){
            var selectedDoc = docType.get('v.value');
            console.log('selectedDoc : '+ selectedDoc);
            if(selectedDoc != ''){
                var docCMP = component.find("file-uploader-1");
                console.log('docCMP : '+ docCMP);
                if(docCMP){
                    docCMP.uploadDoc();
                     component.set("v.showspinnerflag",false);
                }
                 component.set("v.showspinnerflag",false);
            }else{
                 component.set("v.showspinnerflag",false);
                helper.showParentToastHelper('parentErrorToast', 'parentErrorMsg', 'Error! Please select document type.');
            }
        }
    },
    reset : function(component, event, helper){
        var docCMP = component.find("file-uploader-1");
        console.log('docCMP : '+ docCMP);
        if(docCMP){
            docCMP.resetDoc();
        }        
    },
    stageItemClick: function(component, event, helper){ 
        helper.activateStageTab(component, event.target.getAttribute('id'),true);
    },
    prevStage :function(component, event, helper){ 
        var previous ='';
        console.log('activepath>>'+component.get("v.activePath"));
        var activepath = component.get("v.activePath");
        var pathList = component.get("v.pathList");
        for(var i=0; i < pathList.length; i++) {
            if(pathList[i] == activepath){
                component.set("v.disablePrev", false); 
                component.set("v.disableNext", false);
                if(i !=0){
                    previous = pathList[i-1];
                    helper.activateStageTab(component,previous,false);
                }
                if(i==1){
                    component.set("v.disablePrev", true); 
                }
                component.set("v.StageNum",i);
            }
        }
        var items = $(".testing");
        var scrollContainer = $(".offer-pg-cont1");
        var item = helper.fetchItem(component,scrollContainer, items, false);
        if (item) {
            var currentleft = scrollContainer.scrollLeft();
            var addleft = item.position().left + scrollContainer.scrollLeft();
            if(addleft < currentleft){
                scrollContainer.animate({"scrollLeft": item.position().left + scrollContainer.scrollLeft()}, 400);
            }
        }
    }, 
    nextStage :function(component, event, helper){ 
        var next ='';
        var activepath = component.get("v.activePath");
        var pathList = component.get("v.pathList");
        for(var i=0; i < pathList.length; i++) {
            if(pathList[i] == activepath){
                component.set("v.disablePrev", false); 
                component.set("v.disableNext", false); 
                if(i !=1){
                    next = pathList[i+1];
                    helper.activateStageTab(component,next,false);
                }
                if(i==1){
                    component.set("v.disableNext", true); 
                }
                component.set("v.StageNum",i+2);    
            }
        }
        var items = $(".testing");
        var scrollContainer = $(".offer-pg-cont1");
        var item = helper.fetchItem(component,scrollContainer, items, true);
        if (item) {
            var currentleft = scrollContainer.scrollLeft();
            var addleft = item.position().left + scrollContainer.scrollLeft();
            if(addleft > currentleft){
                scrollContainer.animate({"scrollLeft": item.position().left + scrollContainer.scrollLeft()}, 400); 
            }
        }
    },
    pricingSendBackToUW : function(component, event, helper){ 
        component.set("v.isTextBoxEnabled",true);
        component.set("v.showCOSelectPanel", false);
        console.log('pricingSendBackToUW');
    },
    pricingDone : function(component, event, helper) { 
        component.set("v.showspinnerflag",true);
        console.log('UW++'+component.get("v.loanApplication.COO_Comments__c"));
        console.log('UW1++'+component.get("v.loanApplication.Approver__c"));
        console.log('UW2++'+component.get("v.loanApplication.OwnerId"));
        var action = component.get("c.sendBackToUWFunctionality");
        action.setParams({
            jsonloanApplication : JSON.stringify([component.get("v.loanApplication")])
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                 component.set("v.showspinnerflag",false);
                component.set("v.loanApplication.COO_Comments__c",component.get("v.loanApplication.COO_Comments__c"));
            }
             component.set("v.showspinnerflag",false);
        });
        $A.enqueueAction(action);
       
        if(component.get('v.nameTheme') == 'Theme3' || component.get('v.nameTheme') == 'Theme2'){
            if(component.get('v.iscommunityUser'))
                window.location.href = '/Partner/006/o';
            else
       		 	window.location.href = '/006/o';
        }
        else if(component.get('v.nameTheme') == 'Theme4d')
            window.location.href = '/one/one.app?source=alohaHeader#/sObject/Opportunity/list?filterName=Recent';
        else if(component.get('v.nameTheme') == 'Theme4t')
            helper.onLoadRecordCheckForSF1(component, event);
        console.log('If - Saved - Send to Customer');
    },
    pricingCancel : function(component, event, helper){ 
        component.set("v.isTextBoxEnabled",false); 
    },
    
    /** Submit to branch ops button functionality start... YK **/
    
    selectOpsCreditOfficer : function(component, event, helper) {
        console.log('loanAppID ------->> '+component.get("v.pricingId"));
        helper.selectOpsCreditOfficerHelper(component, event);
	},
    
 /*   confirmSubmitToBranchOps : function(component, event, helper) {
        var cmpTarget = component.find('overrideModalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
	},
 */   
    callSubmitToBranchOps : function(component, event, helper) {
        console.log('loanAppID ------->> '+component.get("v.pricingId"));
        helper.callSubmitToBranchOpsHelper(component, event);
        var cmpTarget = component.find('overrideModalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
	},
    
    closeModal : function(component,event){    
        var cmpTarget = component.find('overrideModalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    
    submitToBranchOps : function(component, event, helper){
        console.log('component.get("v.selectedCreditOfficer") ----->> '+component.get("v.selectedCreditOfficer"));
        if(component.get("v.selectedCreditOfficer") == '-- None --')
    		helper.showParentToastHelper('parentInfoToast', 'parentInfoMsg', 'Kindly select Credit Officer first.');
        else
            helper.confirmSubmitToBranchOps(component, event, helper);
	},
    /** Submit to branch ops button functionality end... YK **/
    closeParentSuccessToast: function (component, event, helper) {
		helper.closeSuccessToastHelper(component);
	},
	
    closeParentErrorToast: function (component, event, helper) {
		helper.closeErrorToastHelper(component);
	},
    
    closeParentInfoToast: function (component, event, helper) {
		helper.closeInfoToastHelper(component);
	},
    showSpinner: function(component, event, helper) {
        helper.showSpinner(component,event); 
   },
    hideSpinner : function(component,event,helper){
       helper.hideSpinner(component,event); 
    },	
    documentPicklistCheck : function(component,event,helper)
    {
		var selected = component.find('selectedDoc').get('v.value');
        console.log('+selected+'+selected);
    },
   showorhidespinner: function(component,event,helper)
    {
        console.log('inside showorhidespinner'+component.get("v.showspinnerflag"));
        if(component.get("v.showspinnerflag"))
            helper.showSpinner(component);           
        else
            helper.hideSpinner(component);
    },
    showDocumentToast: function(component,event,helper)
    {
         var messagetype = component.get("v.documentToast")
         if(messagetype)
         {
         var Allstr = messagetype.split(",");
         if(messagetype.includes("Error"))
         helper.showParentToastHelper('parentErrorToast', 'parentErrorMsg','Error! ' +Allstr[1]);
         else
          helper.showParentToastHelper('parentSuccessToast', 'parentSuccessMsg','Success! '+Allstr[1]);        
         }
         component.set("v.documentToast",'');
    }
})