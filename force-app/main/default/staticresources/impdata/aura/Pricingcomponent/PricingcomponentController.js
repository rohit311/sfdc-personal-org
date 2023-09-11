({
	doInit: function (component, event, helper) {
        //added for bug id 21851 start   
       // helper.getHideAadhaarSectionHelper(component);
         var action = component.get("c.getHideAadhaarSection");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				console.log('hide aadhaaar DSS>>>'+response.getReturnValue());
               		component.set('v.hideAadhaarSection',response.getReturnValue()); 
                if(component.get("v.hideAadhaarSection")==false){
                    var tempPathList = ['AadharTab','commercialTab','InsuranceTab','LineEligibilityTab','feesTab','DisbursementTab','dummy'];
                    component.set('v.pathList',tempPathList); 
                     component.set('v.activePath','AadharTab');
                    component.set('v.disablePrev',true);
                    component.set('v.disableNext',false);
                    
                }else if(component.get("v.hideAadhaarSection")==true){
                   var tempPathList = ['commercialTab','InsuranceTab','LineEligibilityTab','feesTab','DisbursementTab','dummy'];
                	 component.set('v.pathList',tempPathList);  
                    component.set('v.activePath','commercialTab');
                    component.set('v.disablePrev',true);
					component.set('v.disableNext',false);
                    $A.util.removeClass(component.find("commercialTabContent"), "slds-hide");
                    $A.util.addClass(component.find("commercialTabContent"), "slds-show");
                    $A.util.removeClass(component.find("commercialTab"), "slds-is-incomplete");
                    $A.util.addClass(component.find("commercialTab"), "slds-is-current slds-is-active");
                }
            }         
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action); 
        //added for 21851 end
		component.set("v.showspinnerflag",true);
		var oppSelectList = ["Type_Of_Loan__c"];
        var surogateselectList = ["Line_opted__c"];
        var selectListNameMap = {};
        selectListNameMap["SurrogateCAM__c"] = surogateselectList;
        selectListNameMap["Opportunity"] = oppSelectList;

		var loanId = component.get('v.pricingId');
		//helper.fetchPricingPickListVal(component, 'Type_Of_Loan__c', 'loanTypeId');
		console.log('loanId++' + loanId);
		var action = component.get('c.getDssDetails');
		console.log('action++' + action);
		action.setParams({
			"oppId" : loanId,
            "objectFieldJSON" : JSON.stringify(selectListNameMap)
		});
    	action.setCallback(this, function (response) {
			var state = response.getState();
			if (state == 'SUCCESS') {
                 component.set("v.showspinnerflag",false);
				console.log(response.getReturnValue());
				if (!$A.util.isEmpty(response.getReturnValue())) {
					var data = JSON.parse(response.getReturnValue());
                    console.log('Amannnnnnnnnnnnnnnnnnnnnnnnnnn');
                    console.log(data.dropLine);
                    console.log(data.disAmount);
                    if (!$A.util.isEmpty(data.picklistData))
                    var picklistFields = data.picklistData;
                    console.log(picklistFields["SurrogateCAM__c"]);
                    console.log('picklistDataOpportunity'+picklistFields["Opportunity"]);
                    if (!$A.util.isEmpty(picklistFields))
                    {
                        if (!$A.util.isEmpty(picklistFields["Opportunity"]))
                   			 component.set("v.loanTypeList",picklistFields["Opportunity"]["Type_Of_Loan__c"]);
                         if (!$A.util.isEmpty(picklistFields["SurrogateCAM__c"]))
                			component.set("v.lineoptedList",picklistFields["SurrogateCAM__c"]["Line_opted__c"]); 
                    }
					if (!$A.util.isEmpty(data.opp))
						component.set('v.loanApplication', data.opp);
                    
                    component.set('v.disbusment.Disbursement_Amount__c', data.disAmount);
                    
					if (!$A.util.isEmpty(data.currentdisbursal))
						component.set('v.disbusment', data.currentdisbursal);
					if (!$A.util.isEmpty(data.applicantPrimary))
                    {
						component.set('v.applicantObj', data.applicantPrimary);
                        component.set('v.DropLineFlexi', data.dropLine);
                        console.log('Bhai++'+component.get('v.DropLineFlexi'));
                    }
                    console.log('AP++'+component.get('v.applicantObj').Drop_Line_Flexi_Period__c);
                    console.log('11++'+data.applicantPrimary);
					if (!$A.util.isEmpty(data.contPrimary))
						component.set('v.contObj', data.contPrimary);
					if (!$A.util.isEmpty(data.scamOpp))
						component.set('v.scam', data.scamOpp);
                    if (!$A.util.isEmpty(data.opp.StageName)){
						component.set('v.loanstage', data.opp.StageName);
                        component.set('v.showAadharComp', true);/*bug 18669*/
                        //component.set('v.stageName',data.opp.StageName);/*bug 18669*/
                    }
					if (!$A.util.isEmpty(data.theme))
						component.set('v.theme', data.theme);
					var scrollContainer = $(".offer-pg");
					// alert('theme>>'+component.get('v.theme')+' width>> '+scrollContainer.width());


					if (component.get('v.theme') == 'Theme4d') {
						var maindiv = component.find('offer-pg');
						$A.util.addClass(maindiv, 'divWidth');

					} else if (component.get('v.theme') == 'Theme4t') {
						var maindiv = component.find('offer-pg');
                        
						//  $A.util.addClass(maindiv,'divWidth1');

					}
				}
			} else if (state == 'ERROR')
                 component.set("v.showspinnerflag",false);
		});
		$A.enqueueAction(action);

	},
    
	handleDisbusmentAttr: function (component, event, helper) {
		component.set("v.EMI1stDate", event.getParam("EMI1stDate"));
		component.set("v.EMILastDate", event.getParam("EMILastDate"));
		component.set("v.BPI", event.getParam("BPI"));
		component.set("v.EMI", event.getParam("EMI"));
		console.log("EMI1stDate+" + component.get("v.EMI1stDate"));
	},
	menuItemClick: function (component, event, helper) {
		component.set("v.helpmessage", event.target.getAttribute('id'));
		helper.activateTab(component, event.target.getAttribute('id'), true);
        console.log('inside menuitem');
        /*Bug 18669 Start*/
        console.log('aadharValueDss is : '+component.get('v.aadharValuePricing'));
        if(component.get('v.aadharValuePricing') == 'Biometric'){
        console.log('Random Number inside Menu ItemClick : '+component.get("v.randomNum"));
        helper.getEKYCRec(component,component.get("v.randomNum"));
        
        console.log('KYC Applicant Id : '+component.get('v.kyc.Applicant__c'));
         if(component.get('v.kyc.Applicant__c') != null){
             component.set('v.applicantObj.eKYC_Processing__c',true);
         }
        }
        /*Bug 18669 End*/
	},
	prevStage: function (component, event, helper) {
		var previous = '';
		var activepath = component.get("v.activePath");
		var pathList = component.get("v.pathList");
		for (var i = 0; i < pathList.length; i++) {
			if (pathList[i] == activepath) {
				component.set("v.disablePrev", false);
				component.set("v.disableNext", false);
                 /*Bug 18669 Start*/
                console.log('pathList[i-1] is : '+pathList[i-1]);
                if(pathList[i-1] == 'AadharTab'){
                    if(component.get('v.aadharValuePricing') == 'Biometric'){
                        helper.getEKYCRec(component,component.get("v.randomNum"));
                        if(component.get('v.kyc.Applicant__c') != null){
                            component.set('v.applicantObj.eKYC_Processing__c',true);
                        }
                    }
                }
                /*Bug 18669 End*/
				console.log('i>>>' + i);
				if (i != 0) {
					previous = pathList[i - 1];
					helper.activateTab(component, previous, false);
				}
				if (i == 1) {
					component.set("v.disablePrev", true);
				}
				component.set("v.StageNum", i);
			}
		}
		var items = $(".stage_item");
		var scrollContainer = $(".offer-pg-cont");
		var item = helper.fetchItem(component, scrollContainer, items, false);

		if (item) {
			var currentleft = scrollContainer.scrollLeft();
			var addleft = item.position().left + scrollContainer.scrollLeft();
			//alert('scrollcontainer>>'+currentleft+'>>addleft>>'+addleft+'>>item position>>'+item.position().left);
			if (addleft < currentleft) {
				scrollContainer.animate({
					"scrollLeft": item.position().left + scrollContainer.scrollLeft()
				}, 400);
			}
		}
	},
	nextStage: function (component, event, helper) {
		var next = '';
		var activepath = component.get("v.activePath");
		var pathList = component.get("v.pathList");
		for (var i = 0; i < pathList.length; i++) {
			if (pathList[i] == activepath) {
				component.set("v.disablePrev", false);
				component.set("v.disableNext", false);
                /*Bug 18669 Start*/
                if(component.get('v.aadharValuePricing') == 'Biometric'){
                    if(pathList[i+1] == 'commercialTab'){
                        console.log('Random Number inside Menu ItemClick : '+component.get("v.randomNum"));
                        helper.getEKYCRec(component,component.get("v.randomNum")); 
                        if(component.get('v.kyc.Applicant__c') != null){
                            component.set('v.applicantObj.eKYC_Processing__c',true);
                        }
                    }
                }
                /*Bug 18669 End*/
                //Rohit changed to 6 from 4
				if (i != 5) {
					next = pathList[i + 1];
					helper.activateTab(component, next, false);
				}
				if (i == 4) {
					component.set("v.disableNext", true);
				}
				component.set("v.StageNum", i + 2);
			}
		}
		var items = $(".stage_item");
		var scrollContainer = $(".offer-pg-cont");
		var item = helper.fetchItem(component, scrollContainer, items, true);

		if (item) {
			//scroll to item
			var currentleft = scrollContainer.scrollLeft();
			var addleft = item.position().left + scrollContainer.scrollLeft();
			//alert('scrollcontainer>>'+currentleft+'>>addleft>>'+addleft+'>>item position>>'+item.position().left);
			if (addleft > currentleft) {
				scrollContainer.animate({
					"scrollLeft": item.position().left + scrollContainer.scrollLeft()
				}, 400);
			}
		}
	},
     showorhidespinner: function(component,event,helper)
        {
        console.log('inside showorhidespinner'+component.get("v.showspinnerflag"));
        if(component.get("v.showspinnerflag"))
          helper.showSpinner(component);           
        else
          helper.hideSpinner(component);
        },
    
})