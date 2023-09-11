({
    doInit : function(component, event, helper) {
        var objPO = component.get("v.productOffering");
        console.log('field sub'+objPO.Field_Desposition_Status__c);
        component.set("v.smartLeadSource", objPO.Lead_Source__c);
        helper.enableFollowUpdate(component);
        //helper.populatesubdispoData(component,event);
        
        var selectOptions = [];
        selectOptions.push({ value:"Docs Received", label:"Docs Received" });
        selectOptions.push({ value:"Not Contactable", label:"Not Contactable" });
        if(component.get("v.isTeleCaller")){
            selectOptions.push({ value:"Follow Up", label:"Follow Up" });
            selectOptions.push({ value:"Sale", label:"Sale" });
            selectOptions.push({ value:"Transfer to Field", label:"Transfer to Field" });
        }
        else{
            selectOptions.push({ value:"Followup", label:"Followup" });
        }
        
        selectOptions.push({ value:"Not Eligible", label:"Not Eligible" });
        selectOptions.push({ value:"Not Interested", label:"Not Interested" });
        //selectOptions.push({ value:"Converted", label:"Converted" });
        component.set("v.fieldDispositionList", selectOptions);
        component.set("v.teleCallingList", selectOptions);
    },
    validateFollowupDate: function (component, event, helper) {
        helper.validateFollowupDate(component);
    },
    cutLookupSour: function (component, event, helper) {
        event.getSource().set("v.value",'');
        helper.openCloseSearchResults(component, 'source', false);
    },
    cutLookupRef: function (component, event, helper) {
        event.getSource().set("v.value",'');
        helper.openCloseSearchResults(component, 'referral', false);
    },
    cutLookupLeadSrc: function (component, event, helper) {
        event.getSource().set("v.value",'');
        helper.openCloseSearchResults(component, 'smartLead', false);
    },
    // bug 19606 S -Priyanka
    validateSourcingChannel: function (component, event, helper) {
       var val=component.find("sourceName").get("v.value");
        if(component.get("v.isSourcingRequired") && (val==''|| val==null)){
             component.find("sourceName").set("v.errors", [{
                 message: " COMPLETE THIS FIELD"
        }    ]);
          
        }
        
    },// bug 19606 E -Priyanka
    enableFollowUpdate: function (component, event, helper) {
        console.log('inside enableConvert');
        helper.enableFollowUpdate(component);
       // if(component.get("v.isFieldAgent"))
        	//helper.populatesubdispoData(component,event);
    },
    picklistTeleCalling: function (component, event, helper) {
        helper.picklistTeleCalling(component);
        if(component.get("v.isFieldAgent"))
        	helper.populatesubdispoData(component,event);
    },
    saveDispositionRecord: function (component, event, helper) {
        var objPO = component.get("v.productOffering");
        //var objLead = component.get("v.leadObj");
        helper.saveDispositionRecord(component,objPO,true,false);//added one more parameter in Method,Bug 17795//added parameter 5881
    },
    sourceKeyPressController: function (component, event, helper) {
        console.log('insourcekey');
        component.set("v.srcChSel",false);
        helper.startSearch(component, 'source');
    },
    smartLeadSourcePressController: function (component, event, helper) {
        console.log('insourcekey');
        component.set("v.leadSrcSel",false);
        helper.searchLeadSource(component, event);
    },
    selectSource: function (component, event, helper) {
        var index = event.currentTarget.dataset.record;
        var selectedSource = component.get("v.sourceList")[index];
        console.log(selectedSource);
        var keyword = selectedSource.Name;
        console.log('keyword>>' + keyword);
        component.set("v.selectedSource", selectedSource);
        component.set("v.sourceSearchKeyword", keyword);
        component.set("v.productOffering.Sourcing_Channel__c", selectedSource.Id);
        helper.openCloseSearchResults(component, "source", false);
        component.find("sourceName").set("v.errors", [{
            message: ""
        }
                                                     ]);
        component.set("v.srcChSel",true);  
    },
    referralKeyPressController: function (component, event, helper) {
        console.log('inreferralkey');
        component.set("v.refSel",false);
        helper.startSearch(component, 'referral');
    },
    selectReferral: function (component, event, helper) {
        var index = event.currentTarget.dataset.record;
        var selectedReferral = component.get("v.referralList")[index];
        console.log(selectedReferral);
        var keyword = selectedReferral.Name;
        console.log('keyword Referral>>' + keyword);
        component.set("v.selectedReferral", selectedReferral);
        component.set("v.referralSearchKeyword", keyword);
        component.set("v.productOffering.Referral__c", selectedReferral.Id);
        helper.openCloseSearchResults(component, "referral", false);
        component.find("referralName").set("v.errors", [{
            message: ""
        }
                                                      
                                                       ]);
        component.set("v.refSel",true);  
    },
    convertPO: function (component, event, helper) {
        console.log('component'+component.get("v.productOffering"));
        //helper.showhidespinner(component,helper,true);
        //helper.covertOSend(component,component.get("v.productOffering"));
        helper.checkLAN(component,component.get("v.productOffering"));
    },
    closeToastnew: function (component, event, helper) {
        document.getElementById("successmsg1").innerHTML = '';
		document.getElementById("SuccessToast1").style.display = "none";
        component.find("toastURL").set("v.label", '');
		
    },
    selectLeadSource: function(component, event, helper){
        var index = event.currentTarget.dataset.record; 
        var selectedResidenceCity = component.get("v.smartleadSourceList")[index];
        component.set("v.smartLeadSource", selectedResidenceCity);
        component.set("v.productOffering.Lead_Source__c", selectedResidenceCity);
        helper.openCloseSearchResults(component, "smartLead", false);https://bflhts--uat1.cs57.my.salesforce.com/_ui/common/apex/debug/ApexCSIPage#
        if (!$A.util.isEmpty(component.find("smartLeadSourceName"))) {
            component.find("smartLeadSourceName").set("v.errors", [{
                message: ""
            }
                                                                  ]);
        }
        component.set("v.leadSrcSel",true);
    },
    navigateToOppComponent: function (component, event, helper) {
		// helper.navigateToOppComponent(component,'23142314','');
		console.log('navigateToOppComponent' + component.get("v.loanId") + '>>theme' + component.get("v.theme"));
		//debugger;
		var loanId = component.get("v.loanId");
		if (!$A.util.isEmpty(loanId)) {
			if (component.get("v.theme") == 'Theme3' || component.get("v.theme") == 'Theme2') {
				if(component.get('v.iscommunityUser'))
                    window.location.href = "/Partner/apex/SAL_Sales_Page?recordId=" + loanId+"&newloanFlag=false";
                else{
                    console.log('loan id is>>'+ loanId);
                    window.location.href = "/apex/SAL_Sales_Page?recordId=" + loanId;
                    
			 }
					
			} else if (component.get("v.theme") == 'Theme4d' || component.get("v.theme") == 'Theme4t') {
				var evt = $A.get("e.force:navigateToComponent");
                if(evt){
                    console.log('evt : '+evt);
                    evt.setParams({
                        componentDef: "c:Open_Existing_LA_SAL",
                        componentAttributes: {
                            "recordId": loanId,
                            "newloanFlag" : false
                        }
                    });
                    evt.fire();
                }
                else{
                    window.location.href = "/apex/SAL_Sales_Page?recordId=" + loanId;
                }
			}
           component.destroy(); 
		}
	},
     DestroyChildCmp: function(component, event, helper) {
        console.log('child destroy'); 
        //var numbers =[];
        //component.set("v.lstPo",numbers);
        component.destroy();
    }
})