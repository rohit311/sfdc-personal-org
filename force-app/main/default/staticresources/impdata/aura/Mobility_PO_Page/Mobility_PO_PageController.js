({
    menuItemClick: function(component, event, helper){ 
        helper.activateTab(component, event.target.getAttribute('id'),true);
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
                console.log('i>>>'+i);
                if(i !=0){
                    previous = pathList[i-1];
                    helper.activateTab(component,previous,false);
                }
                if(i==1){
                    component.set("v.disablePrev", true); 
                }
                component.set("v.StageNum",i);
            }
        }
        
        
        var items = $(".slds-path__item");
        var scrollContainer = $(".offer-pg-cont");
        
        console.log(items);
        console.log(scrollContainer);
        
        var item = helper.fetchItem(component,scrollContainer, items, false);
        console.log(item);
        if (item) {
            //scroll to item
            console.log(item.position().left + scrollContainer.scrollLeft());
            var currentleft = scrollContainer.scrollLeft();
            console.log('currentleft>> prev>>'+currentleft);
            var addleft = item.position().left + scrollContainer.scrollLeft();
            console.log('item.position().left prev>>'+item.position().left);
            console.log('addleft prev>>'+addleft);
            if(addleft < currentleft){
                scrollContainer.animate({"scrollLeft": item.position().left + scrollContainer.scrollLeft()}, 400);
            }
            
            
        }
        
    }, 
    nextStage :function(component, event, helper){ 
        var next ='';
        console.log('activepath>>'+component.get("v.activePath"));
        var activepath = component.get("v.activePath");
        var pathList = component.get("v.pathList");
        for(var i=0; i < pathList.length; i++) {
            if(pathList[i] == activepath){
                component.set("v.disablePrev", false); 
                component.set("v.disableNext", false); 
                console.log('i>>>'+i);
                if(i !=3){
                    next = pathList[i+1];
                    helper.activateTab(component,next,false);
                }
                if(i==2){
                    component.set("v.disableNext", true); 
                }
                component.set("v.StageNum",i+2);    
            }
        }
        
        var items = $(".slds-path__item");
        var scrollContainer = $(".offer-pg-cont");
        
        var item = helper.fetchItem(component,scrollContainer, items, true);
        
        if (item) {
            //scroll to item
            var currentleft = scrollContainer.scrollLeft();
            console.log('currentleft next>>'+currentleft);
            var addleft = item.position().left + scrollContainer.scrollLeft();
            console.log('item.position().left next>>'+item.position().left);
            console.log('addleft next>>'+addleft);
            if(addleft > currentleft){
                scrollContainer.animate({"scrollLeft": item.position().left + scrollContainer.scrollLeft()}, 400); 
            }
        }
    },
    
    hideicon: function(component,event)
    {
        console.log('inside icon');
        var a = document.getElementsByClassName("slds-datepicker");
        console.log(a[0]);
        for(var i=0; i < a.length; i++){
            a[i].style.visibility="hidden";
        } 
    },
    doInit: function (component, event, helper) {
        helper.showSpinner(component);
		var sPageURL = decodeURIComponent(window.location.href);
		console.log('doinit>>' + sPageURL);
       
		var poId = component.get("v.recordId");

		console.log('poId>>' + poId);
       
		if (poId) {
			component.set('v.poID', component.get("v.recordId"));
			helper.getPODetails(component, poId);
           // helper.populatesubdispoData(component);
		}
		/* Adhoc 20275 s */
        var fielddisposition = '',telefielddisposition = '';
		if(component.get("v.isTeleCaller") == true)
			telefielddisposition = component.get("v.po.TeleCalling_Desposition_Status__c");
		else /* Adhoc 20275 e added sales condition*/
			fielddisposition = component.get("v.po.Field_Disposition_1__c");
        if((fielddisposition != '' && (fielddisposition == 'Docs Received'
           || fielddisposition == 'Sale')) || telefielddisposition == 'Sale')
            component.set('v.isSourcingChannelAndApplicationRequired',true);
        else      
            component.set('v.isSourcingChannelAndApplicationRequired',false); 
        
	},
	enableConvert: function (component, event, helper) {
        console.log('inside enableConvert');
		//adhoc 20275
		if(component.get("v.isFieldAgent") == true)
        helper.populatesubdispoData(component);
        helper.validateDisposition(component);
        helper.blankFollowupDate(component,event);
    },
    updateLookup: function (component, event, helper) {
        
        helper.updateLookups(component, event);
    },
    //for updating ekyc Details in Lead And product offerings fire from Aadharverification comp
    initiateKYCForm: function (component, event) {
        component.set("v.kyc", event.getParam("kyc"));
        console.log("kyc details" + component.get("v.kyc"));
    },
    toggletab: function (component, event, helper) {
        console.log('hi' + event.target.id);
        //helper.toggleAccordion(component,event.target.id);
        //helper.toggleAccordion(component, event);
        //   component.find("disposition").set("v.value",'HOLD');//component.get("v.po").Field_Disposition_1__c);
    },
    navigateToOppComponent: function (component, event, helper) {
        // helper.navigateToOppComponent(component,'23142314','');
        console.log('navigateToOppComponent' + component.get("v.loanId") + '>>theme' + component.get("v.theme"));
        //debugger;
        var loanId = component.get("v.loanId");
        if (!$A.util.isEmpty(loanId)) {
            if (component.get("v.theme") == 'Theme3' || component.get("v.theme") == 'Theme2') {
                if(component.get('v.iscommunityUser'))
                    window.location.href = "/Partner/apex/SALMobility_Opp_page?recordId=" + loanId;
                else
                    window.location.href = "/apex/SALMobility_Opp_page?recordId=" + loanId;
            } else if (component.get("v.theme") == 'Theme4d' || component.get("v.theme") == 'Theme4t') {
                var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef: "c:Opp_DSS_flow",
                    componentAttributes: {
                        "oppId": loanId
                    }
                });
                evt.fire();
            }
            component.destroy(); 
        }
    },
    convertToLoanApplication: function (component, event, helper) {
        var lead = component.get("v.lead");
        //  helper.closeToast(component);
        if ($A.util.isEmpty(lead.FirstName) || $A.util.isEmpty(lead.LastName) || $A.util.isEmpty(lead.Customer_Mobile__c)) {
            helper.showToast(component, 'Error!', 'Please fill First Name, Last Name and Mobile Number before submitting the details.', 'error');
        } else if (helper.validateallInputData(component,false)) {
            helper.showSpinner(component);
            var mcpCmp = component.find("mcpComponent");
            mcpCmp.setResidenceAddress(component);
            helper.convertToLoanApplication(component);
        }
    },
    selectSource: function (component, event, helper) {
        var index = event.currentTarget.dataset.record;
        var selectedSource = component.get("v.sourceList")[index];
        console.log('------');
        console.log(selectedSource);
        var keyword = selectedSource.Name;
        console.log('keyword>>' + keyword);
        component.set("v.selectedSource", selectedSource);
        if(!$A.util.isEmpty(keyword))
        {
            component.set("v.sourceSearchKeyword", keyword);
        }
        else
        {
            component.set("v.sourceSearchKeyword", '');
        }
        component.set("v.po.Sourcing_Channel__c", selectedSource.Id);
        console.log('sourcingchanel'+component.get("v.po.Sourcing_Channel__c"));
        var lead = component.get("v.lead");
        lead.SBS_Branch__c = selectedSource.Branch__c;
        console.log('Branch__r.id' + selectedSource.Branch__c);
        component.set("v.lead", lead);
        console.log('branch name' + component.get("v.lead.SBS_Branch__c"));
        helper.openCloseSearchResults(component, "source", false);
        /*component.find("sourceName").set("v.errors", [{
					message: ""
				}
			]);*/
    },
    makerequiredfollowup: function (component, event, helper) {
        helper.validateDisposition(component);
    },
    validateFollowupDate: function (component, event, helper) {
        helper.validateFollowupDate(component,event);
    },
    validateFollowupDate1:function (component, event, helper) {
        console.log('validateFollowupDate1'+component.find("followUpDate").get('v.value'));
    },
    sourceKeyPressController: function (component, event, helper) {
        console.log('insourcekey');
        helper.startSearch(component, 'source');
    },
    saveDispositionData: function (component, event, helper) {
        console.log('priya>>>' + component.get('v.po.Name'));
    },
    
    
    dispSubmitDetails: function (component, event, helper) {
        var lead = component.get("v.lead");
        if ($A.util.isEmpty(lead.FirstName) || $A.util.isEmpty(lead.LastName) || $A.util.isEmpty(lead.Customer_Mobile__c)) {
            //helper.showToast(component, 'Error!', 'Please fill First Name, Last Name and Mobile Number before submitting the details.', 'error');
            helper.displayMessage(component, 'ErrorToast', 'errormsg', '<b>Error!</b>,Please fill First Name, Last Name and Mobile Number before submitting the details');
        } else if (helper.validateallInputData(component,true)) {
            helper.showSpinner(component); 
            //helper.createPOData(component,true);
            helper.createLeadData(component,true);
        }
    },
    
    //Save Lead And Po Data
    submitDetails: function (component, event, helper) {
        var lead = component.get("v.lead");
        if ($A.util.isEmpty(lead.FirstName) || $A.util.isEmpty(lead.LastName) || $A.util.isEmpty(lead.Customer_Mobile__c)) {
            //helper.showToast(component, 'Error!', 'Please fill First Name, Last Name and Mobile Number before submitting the details.', 'error');
            helper.displayMessage(component, 'ErrorToast', 'errormsg', '<b>Error!</b>,Please fill First Name, Last Name and Mobile Number before submitting the details');
            
        } /*else if ($A.util.isEmpty(component.get("v.po.Experience_in_Years__c")) && $A.util.isEmpty(component.get("v.po.Total_work_experience__c"))) {
			if (parseInt(component.get("v.po.Experience_in_Years__c")) > parseInt(component.get("v.po.Total_work_experience__c")))
				helper.displayMessage(component, 'ErrorToast', 'errormsg', '<b>Error!</b>,Total work Exp can not be less than current Exp');
			console.log('inside validexp' + component.get("v.po.Total_work_experience__c"));
		}*/ else if (helper.validateallInputData(component,false)) {
            helper.showSpinner(component);
            var mcpCmp = component.find("mcpComponent");
            mcpCmp.setResidenceAddress(component);
            if (component.get("v.poID"))
                helper.createLeadData(component,false);	
        }
    },
    closeCustomToast: function (component, event, helper) {
        helper.closeToast(component);
    },
    closeModalPopup: function (component, event, helper) {
        helper.showHideDiv(component, "grabOffers", false);
    },
    
    closeToastnew: function (component, event, helper) {
        helper.closeToastnew(component, event.target.id);
    },
    closeToastError: function (component, event, helper) {
        helper.closeToastError(component, event.target.id);
    },
    //Rohit 16111 added Method S
    validateEkyc:function(component, event, helper){
        var staticResc = $A.get('$Resource.Ekyc_Integration');
        if(staticResc != null){
            var jsnBodyEkyc = staticResc.toString();
            console.log(jsnBodyEkyc);
            var allMap = JSON.parse(jsnBodyEkyc);
            console.log('hhhh '+(typeof allMap));
        }
    }
    //Rohit 16111 added Method E
})