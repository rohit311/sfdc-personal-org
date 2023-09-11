({
    activateTab: function(component, tabId) {
        
        $A.util.removeClass(component.find("pricingTab"), "slds-active");
        $A.util.removeClass(component.find("documentTab"), "slds-active");
        $A.util.removeClass(component.find("ActionsTab"), "slds-active");
        $A.util.addClass(component.find(tabId), "slds-active");
        
        this.showHideDiv(component, "pricingTabContent", false);
        this.showHideDiv(component, "documentTabContent", false);
        this.showHideDiv(component, "ActionsTabContent", false);
        this.showHideDiv(component, tabId+"Content", true);
    },
    
    showToast : function(component, title, message, type) {
        console.log('message ----->> '+message);
        var toastEvent = $A.get("e.force:showToast");
        console.log('toastEvent --111-->> '+toastEvent);
        if(toastEvent){
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "3000"
            });    
            toastEvent.fire();
        }else{
			var showToast = $A.get("e.c:ShowCustomToast");
            console.log('showToast --222-->> '+showToast);
            showToast.fire(title, message, type);     
           
        }		
	},
    fetchPricingPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getSelectPicklistOPtions");
        action.setParams({
            "objObject": component.get("v.loanApplication"),
            "fld": fieldName
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                console.log('allValues+'+allValues);
                component.set("v.loanTypeList", allValues);
            }
        });
        $A.enqueueAction(action);
    },
    
    activateStageTab: function(component, tabId,onstageclick) {
		component.set("v.disablePrev", false); 
		component.set("v.disableNext", false);
	
		$A.util.removeClass(component.find("docUploderTab"), "slds-is-current slds-is-active");
		$A.util.removeClass(component.find("docUplodedTab"), "slds-is-current slds-is-active");
	   
		$A.util.addClass(component.find("docUploderTab"), "slds-is-incomplete");
		$A.util.addClass(component.find("docUplodedTab"), "slds-is-incomplete");
	   
		 $A.util.removeClass(component.find(tabId), "slds-is-incomplete");
		$A.util.addClass(component.find(tabId), "slds-is-current slds-is-active");
						
		this.showHideDiv(component, "docUploderTabContent", false);
		this.showHideDiv(component, "docUplodedTabContent", false);
		
		this.showHideDiv(component, tabId+"Content", true);
        if(onstageclick){ 
			var activepath = component.get("v.activePath");
			var pathList = component.get("v.pathList");
			var currentPos = 1;
			var prevPos = 1;
			var pathscroll = false;
			for(var i=0; i < pathList.length; i++) {
				if(pathList[i] == activepath){
					prevPos = i+1;
				}
				if(pathList[i] == tabId){
					currentPos = i+1;
				}
			}
			if(prevPos < currentPos){
				pathscroll = true;
			}
            console.log('pathscroll>>'+pathscroll+'prevPos>>'+prevPos+'>>currentPos>>'+currentPos);
			var scrollContainer = $(".offer-pg-cont1");
			var items = $(".testing");
			var item = this.fetchItem(component,scrollContainer, items, pathscroll);
            if(item){
                var currentleft = scrollContainer.scrollLeft();
                var addleft = item.position().left + scrollContainer.scrollLeft();
                if(pathscroll && (addleft > currentleft))
                    scrollContainer.animate({"scrollLeft": item.position().left + scrollContainer.scrollLeft()}, 400);
                else if(pathscroll == false && (addleft < currentleft) )
                    scrollContainer.animate({"scrollLeft": item.position().left + scrollContainer.scrollLeft()}, 400);
            }
			
        }
		component.set("v.activePath", tabId);
        if(tabId == 'docUploderTab'){
			  component.set("v.disablePrev", true);    
              component.set("v.StageNum",1);
        }
        else if(tabId == 'docUplodedTab'){
			  component.set("v.disableNext", true);   
             component.set("v.StageNum",2);
        }
    },
    fetchItem :function(component,container, items, isNext) {
        var i,
        scrollLeft = container.scrollLeft();
		//set isNext default to true if not set
		if (isNext === undefined) {
			isNext = true;
		}
		if (isNext && container[0].scrollWidth - container.scrollLeft() <= container.outerWidth()) {
			//we reached the last one so return the first one for looping:
			return $(items[0]);
        }
		//loop through items
		for (i = 0; i < items.length; i++) {

			if (isNext && $(items[i]).position().left > 0) {
				//this item is our next item as it's the first one with non-negative "left" position
				return $(items[i]);
			} else if (!isNext && $(items[i]).position().left >= 0) {
				//this is our previous item as it's the one with the smallest negative "left" position
				//if we're at item 0 just return the last item instead for looping
				return i == 0 ? $(items[items.length - 1]) : $(items[i-1]);
			}
		}
		//nothing found
		return null;
    },
    
    /** ..............Submit to branch ops button functionality start............. YK **/
    CO_ID_TO_CO_NAME_MAP : {},
    
	selectOpsCreditOfficerHelper : function(component, event) {
        console.log('loanAppID ---helper---->> '+component.get("v.pricingId"));
    	var action = component.get("c.selectOpsCreditOfficerCntrl");
        action.setParams({
            "oppId": component.get("v.pricingId")
        });
        action.setCallback(this, function(response){
        	var state = response.getState();
        	if (component.isValid() && state === "SUCCESS") {
                console.log('...inside success...');
                var wrapperObj = response.getReturnValue();
                
                component.set("v.showCOSelectPanel", false);
                console.log('wrapperObj.errorMessageString--->> '+wrapperObj.errorMessageString);
                console.log('wrapperObj.showSalesHierarchyMsg--->> '+wrapperObj.showSalesHierarchyMsg);
                console.log('wrapperObj.coIdToCoNameMap--->> '+JSON.stringify(wrapperObj.coIdToCoNameMap));
                
                if(wrapperObj.errorMessageString == 'NO_ERROR' && wrapperObj.showSalesHierarchyMsg == false)
                {
					
                    console.log('showCOSelectPanel----->> true');
                    var coOfficerList = [];
                    for(var key in wrapperObj.coIdToCoNameMap)
                    {
                        console.log('inside map iteration.....');
                        coOfficerList.push({value:wrapperObj.coIdToCoNameMap[key], key:key});
                    }
                    component.set("v.creditOfficerList", coOfficerList);
                	component.set("v.showCOSelectPanel", true);
                    component.set("v.isTextBoxEnabled",false);
                    this.CO_ID_TO_CO_NAME_MAP = wrapperObj.coIdToCoNameMap;
                }
                else if(wrapperObj.errorMessageString != 'NO_ERROR')
                {
                    //show error message toast..
                    this.showParentToastHelper('parentErrorToast', 'parentErrorMsg', wrapperObj.errorMessageString);
                    
                }
                //Rohit 16111 CR added for Ekyc S
                else if(wrapperObj.showEkycMandatoryMsg != false)
                {
                    var ekycMsg ='Please initiate Ekyc !';
                    this.showParentToastHelper('parentInfoToast', 'parentInfoMsg', ekycMsg);
                }    
                //Rohit 16111 CR added for Ekyc E
                else if(wrapperObj.showSalesHierarchyMsg != false)
                {
                    //show Info message toast..
                    var infoMsg = 'Send mail to Sales Hierarchy is Mandatory! Proposed Rate is below the system prescribed rate. Please take necessary approvals before proceeding';
                    this.showParentToastHelper('parentInfoToast', 'parentInfoMsg', infoMsg);
                }
                
        	}
    	});
        $A.enqueueAction(action);
	}, 
    
    callSubmitToBranchOpsHelper : function(component, event) {
        component.set("v.showspinnerflag",true);
    	console.log('loanAppID ------->> '+component.get("v.pricingId"));
        var apprId = '';
        for(var key in this.CO_ID_TO_CO_NAME_MAP)
        {
            if(this.CO_ID_TO_CO_NAME_MAP[key] == component.get("v.selectedCreditOfficer"))
            {
                apprId = key;
            }
        }
        var action = component.get("c.callSubmitToBranchOpsCntrl");
        action.setParams({
            "oppId": component.get("v.pricingId"),
            "approverId" : apprId
        });
        action.setCallback(this, function(response){
        	var state = response.getState();
        	if (component.isValid() && state === "SUCCESS") {
                console.log('...inside success...');
                var wrapperObj = response.getReturnValue();
                component.set("v.showspinnerflag",false);
                console.log('wrapperObj.errorMessageString--222->> '+wrapperObj.errorMessageString);
                console.log('wrapperObj.showSalesHierarchyMsg--222->> '+wrapperObj.showSalesHierarchyMsg);
                console.log('wrapperObj.coIdToCoNameMap--222->> '+JSON.stringify(wrapperObj.coIdToCoNameMap));
                
                if(wrapperObj.errorMessageString == 'NO_ERROR')
                {
                    component.set("v.showspinnerflag",false);
                   if(component.get('v.nameTheme') == 'Theme3' || component.get('v.nameTheme') == 'Theme2'){
						if(component.get('v.iscommunityUser'))
                            window.location.href = '/Partner/006/o';
                        else
                            window.location.href = '/006/o';
                	}else if(component.get('v.nameTheme') == 'Theme4d')
                    	window.location.href = '/lightning/o/Opportunity/list?filterName=Recent';
                    else if(component.get('v.nameTheme') == 'Theme4t')
                    	this.onLoadRecordCheckForSF1(component, event);
                }
                else if(wrapperObj.errorMessageString != 'NO_ERROR')
                {
                    //show error message toast..
                    component.set("v.showspinnerflag",false);
                    this.showParentToastHelper('parentErrorToast', 'parentErrorMsg', wrapperObj.errorMessageString);
                }
        	}
    	});
        $A.enqueueAction(action);
	},
    
    showParentToastHelper : function(toastDivId, messageDivId, message)
    {
        console.log('---->>> '+document.getElementById(toastDivId));
        document.getElementById(toastDivId).style.display = "block";
		document.getElementById(messageDivId).innerHTML = message;
        
        setTimeout(function () {
            document.getElementById(toastDivId).style.display = "none";
			document.getElementById(messageDivId).innerHTML = "";
		}, 5000);
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
        document.getElementById('parentInfoToast').style.display = "none";
        document.getElementById('parentInfoMsg').innerHTML = "";
    },
    
    confirmSubmitToBranchOps : function(component, event, helper) {
        var cmpTarget = component.find('overrideModalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
	},
    /** Submit to branch ops button functionality end... YK **/
    
    onLoadRecordCheckForSF1 : function(component, event) {
        var action = component.get('c.getLoanApplicationListViews');
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var listviews = response.getReturnValue();
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
    },
    
    showHideDiv: function (component, divId, show) {
        console.log('divId>>' + divId + '  ' + show);
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
    showSpinner: function (component) {
		this.showHideDiv(component, "waiting", true);
	},
	hideSpinner: function (component) {
		this.showHideDiv(component, "waiting", false);
	}
})