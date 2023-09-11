({
	getDisablecheckbox: function (component) {
		console.log('child getDisablecheckbox' + component.get("v.residenceAddress"));

		if (!$A.util.isEmpty(component.get("v.kyc")) && !$A.util.isEmpty(component.get("v.kyc").eKYC_Address_details__c)) {
			console.log('inside if of getDisableCheckBox');
			component.find("copyekycaddress").set("v.disabled", false);
            // $A.util.addClass(component.find("copyekycaddress"), "slds-show");
		} else
        {
			component.find("copyekycaddress").set("v.disabled", true);
           // $A.util.addClass(component.find("copyekycaddress"), "slds-hide");
        }

		console.log('inside getDisableCheckBox at last');
		console.log(component.get("v.po.Product_Offering_Converted__c"));
	},
	updateLookups: function (component, event) {
		var record = event.getParam('record');
		console.log("record-->" + record.Id);
		var lead = component.get("v.lead");
		lead.Segment_Master__c = record.Id;
		component.set("v.lead", lead);
	},
	validateMCP: function (component, event) {
		console.log("inside child helper");
		var lead = component.get("v.lead");
		var po = component.get("v.po");
		var isEmpty,
		isValid = true;
		var lst = [{
				value: lead.Gender__c,
				auraId: "gender",
				message: "Please Select Gender"
			}, {
				value: lead.DOB__c,
				auraId: "dateOfBirth",
				message: "Enter Date of Birth"
			}, {
				value: lead.PAN__c,
				auraId: "pannumber",
				message: "Enter PAN Number"
			}, {
				value: lead.Resi_Pin_Code__c,
				auraId: "pincode",
				message: "Enter Pin Code"
			}, {
				value: lead.Email,
				auraId: "personalemail",
				message: "Enter Email Id"
			}, {
				value: po.Products__c,
				auraId: "offerproduct",
				message: "Please Select Offer Product"
			}, {
				value: component.get("v.residenceAddress"),
				auraId: "address",
				message: "Enter Address"
			}, {
				value: po.Products__c,
				auraId: "offerproduct",
				message: "Please Select Offer Product"
			},{
				value: po.Net_Salary_Per_Month__c,
				auraId: "avg3monthsalary",
				message: "Please Enter Salary"
			},
             {
				value: component.get("v.employerSearchKeyword"),
				auraId: "employerName",
				message: "Enter Employer"
			}/*,
             {
				value: lead.Employer_Name__c,
				auraId: "EmpNameIFOthers",
				message: "Enter Employer Name"
			}*/
		];
		for (var i = 0; i < lst.length; i++) {
			isEmpty = this.isEmpty(lst[i].value);
            isValid = isValid && !isEmpty;
            if(component.get("v.ifOther"))
            	isValid = isValid && (!$A.util.isEmpty(component.get("v.lead.Employer_Name__c")));
            this.addRemoveInputError(component, lst[i].auraId, isEmpty && lst[i].message);
		}
		console.log("childisValid" + isValid);
       	return isValid;
	}, //key=== "offerproduct"
	addRemoveInputError: function (component, key, message) {
      
		if (key === "employerName") {
			/*component.find(key).set("v.errors", [{
						message: message ? ("Please " + message) : ""
					}
				]);*/
		} 
		else if(key == "EmpNameIFOthers"){
			
		}else if(key !== "employerName"){
			console.log("inside gender");
			console.log('component.find(key) 1 : ' + key + ' - ' + JSON.stringify(component.find(key)));
			console.log('component.find(key) 2 : ' + component.find(key).get('v.validity'));
			if (!component.find(key).get('v.validity').valid) {
				console.log('Valid : ');
				component.find(key).showHelpMessageIfInvalid();
			}
		}
	},
	isEmpty: function (value) {
		return ($A.util.isEmpty(value) || $A.util.isUndefined(value) || value === 0);
	},
	openCloseSearchResults: function (component, key, open) {
		var resultPanel = component.find(key + "SearchResult");
		$A.util.addClass(resultPanel, open ? 'slds-is-open' : 'slds-is-close');
		$A.util.removeClass(resultPanel, open ? 'slds-is-close' : 'slds-is-open');
	},
	startSearch: function (component, key) {
        var keyword = component.get("v." + key + "SearchKeyword");
		if (keyword.length > 2 && !component.get('v.searching')) {
			component.set('v.searching', true);
			component.set('v.oldSearchKeyword', keyword);
			this.searchHelper(component, key, keyword);
		} else if (keyword.length <= 2) {
			component.set("v." + key + "List", null);
			this.openCloseSearchResults(component, key, false);
		}
	},
	searchHelper: function (component, key, keyword) {
		this.executeApex(component, "fetch" + this.toCamelCase(key), {
			'searchKeyWord': keyword
		}, function (error, result) {
			if (!error && result) {
				this.handleSearchResult(component, key, result);
			}
		});
	},
	handleSearchResult: function (component, key, result) {
		component.set('v.searching', false);
		if (component.get('v.oldSearchKeyword') !== component.get("v." + key + "SearchKeyword")) {
			component.set("v." + key + "List", null);
			this.startSearch(component, key);
		} else {
			component.set("v." + key + "List", result);
			this.showHideMessage(component, key, !result.length);
			this.openCloseSearchResults(component, key, true);
		}
	},
	toCamelCase: function (str) {
		return str[0].toUpperCase() + str.substring(1);
	},
	executeApex: function (component, method, params, callback) {
		var action = component.get("c." + method);
		action.setParams(params);
		console.log('calling method' + method);
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				console.log('response.getReturnValue()' + response.getReturnValue());
				callback.call(this, null, response.getReturnValue());
			} else if (state === "ERROR") {
				console.log('error');
				console.log(response.getError());

				var errors = ["Some error occured. Please try again. "];
				var array = response.getError();
				for (var i = 0; i < array.length; i++) {
					var item = array[i];
					if (item && item.message) {
						errors.push(item.message);
					}
				}
				console.log('calling method failed ' + method);
				callback.call(this, errors, response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	},
	showHideMessage: function (component, key, show) {
		component.set("v.message", show ? 'No Result Found...' : '');
		this.showHideDiv(component, key + "Message", show);
	},
	showHideDiv: function (component, divId, show) {

		$A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
	},
    wordWrap :function(component,text,width){
    
    },

})