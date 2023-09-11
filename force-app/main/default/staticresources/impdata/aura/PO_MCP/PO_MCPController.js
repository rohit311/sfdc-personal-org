({
	doInit: function (component, event, helper) {
		console.log('child donint');
            

		console.log(component.get('v.po'));
		var lead = component.get('v.lead');
		console.log(lead);
		if (lead.Employer__r)
			component.set("v.companyCategory", component.get('v.lead').Employer__r.Company_Category__c);
	},
	disableChildForm: function (component) {
		var list = [
			"pannumber", "dateOfBirth", "address", "gender", "pincode", "avg3monthsalary", "offerproduct",
			"personalemail", "officeemail","employerName", "copyekycaddress", "profile", "EmpNameIFOthers"];
		for (var i = 0; i < list.length; i++) {
			console.log('list[i]>>' + list[i]);
			console.log(component.find(list[i]));
			if (component.find(list[i]))
				component.find(list[i]).set("v.disabled", true);
            document.getElementById("mcpId").classList.add("disabledMCP");
		}
	},
	updateLookup: function (component, event, helper) {

		helper.updateLookups(component, event);
	},

	initiateKYCForm: function (component, event) {
        
		component.set("v.kyc", event.getParam("kyc"));
		//console.log("kyc details" + ($A.util.isEmpty(component.get("v.residenceAddress")))+(!$A.util.isEmpty(component.get("v.kyc").eKYC_Address_details__c)));
        if(!$A.util.isEmpty(component.get("v.kyc"))){
            //Rohit added null check
            if (component.get("v.kyc")!=null && !$A.util.isEmpty(component.get("v.kyc").eKYC_Address_details__c)) {
                component.find("copyekycaddress").set("v.disabled", false);
            } else
            {
                component.find("copyekycaddress").set("v.disabled", true);
            }
        }
        else{
        	component.find("copyekycaddress").set("v.disabled", true);
    	}
        var kyc = component.get("v.kyc"); 
		if (kyc) {
			kyc.Lead__c = component.get("v.lead").Id;
			kyc.Product_Offerings__c = component.get("v.po").Id;
			component.set('v.kyc', kyc);
			console.log("KYC : " + kyc.Id);
			if (!$A.util.isEmpty(kyc.Id)) {
                console.log("KYC inside : " + kyc.Id);
				//helper.updateKYC(component); 
				var kyc = JSON.stringify([component.get("v.kyc")]);
                var leadObj = JSON.stringify([component.get("v.lead")]);
                var action = component.get("c.saveKYC");
                var params={
			    "ekyc": kyc,
			    "leadObj": leadObj,
			    "poId": component.get("v.po").Id
                };
		        action.setParams(params);
		        action.setCallback(this, function (response) {
                var state = response.getState()
				var result=response.getReturnValue();
                console.log('ekyc result1'+result);
			    if (state === 'SUCCESS' && result) {
				console.log('ekyc result' + result);
				component.set("v.kyc", result);
                console.log(result);  
			   }
			//this.hideSpinner(component);
		});
                $A.enqueueAction(action);

			}
		}
	},
	copyekycaddress: function (component, event) {
		var checkCmp = component.get("v.copyekycaddressflag");
		console.log("checkCmp" + component.get("v.copyekycaddressflag"));
		console.log('addres>>' + component.get("v.residenceAddress"));
		console.log('ekyc addres>>' + component.get("v.kyc.eKYC_Address_details__c"));
		if($A.util.isEmpty(component.get("v.resCopyAddress")))
            component.set("v.resCopyAddress", component.get("v.residenceAddress"));
        if($A.util.isEmpty(component.get("v.copyLeadDOB")))
        	component.set("v.copyLeadDOB", component.get("v.lead.DOB__c"));
        if($A.util.isEmpty(component.get("v.copyLeadGender")))
        	component.set("v.copyLeadGender", component.get("v.lead.Gender__c"));
        if($A.util.isEmpty(component.get("v.copyLeadPincode")))
        	component.set("v.copyLeadPincode", component.get("v.lead.Resi_Pin_Code__c"));
        if($A.util.isEmpty(component.get("v.copyLeadEmail")))
        	component.set("v.copyLeadEmail", component.get("v.lead.Email"));
        if($A.util.isEmpty(component.get("v.copyLeadMobile")))
        	component.set("v.copyLeadMobile", component.get("v.lead.Customer_Mobile__c"));
        
        if (checkCmp === true) {
			console.log("checkCmpinside" + component.get("v.copyekycaddressflag"));
			component.set("v.residenceAddress", component.get("v.kyc.eKYC_Address_details__c"));
            console.log(JSON.stringify(component.get("v.kyc")));
            //console.log();
            var ekyc = component.get("v.kyc");
            var lead = component.get('v.lead');
            lead.FirstName = component.get("v.kyc.eKYC_First_Name__c");
            lead.LastName = component.get("v.kyc.eKYC_Last_Name__c");
            lead.DOB__c = component.get("v.kyc.eKYC_Date_of_Birth__c");
            lead.DOB__c = component.get("v.kyc.eKYC_Date_of_Birth__c");
            lead.Email = component.get("v.kyc.eKYC_E_mail__c");
            lead.Customer_Mobile__c = component.get("v.kyc.eKYC_Mobile_Number__c");
            //Rohit added for gender S
            console.log('robin '+component.get("v.kyc.eKYC_Gender__c"));
            if(component.get("v.kyc.eKYC_Gender__c") != undefined && component.get("v.kyc.eKYC_Gender__c") != ''){
                if(component.get("v.kyc.eKYC_Gender__c") == 'F'){
                     lead.Gender__c = 'Female';
                }
                else if(component.get("v.kyc.eKYC_Gender__c") == 'M'){
                     lead.Gender__c = 'Male';
                }
            }
            //Rohit added for gender E
            lead.Resi_Pin_Code__c = component.get("v.kyc.eKYC_Pin_Code__c");
			component.set("v.lead", lead);
		} 
        else {
			component.set("v.residenceAddress", component.get("v.resCopyAddress"));
			component.find("address").set("v.value", component.get("v.resCopyAddress"));
            component.set("v.lead.DOB__c", component.get("v.copyLeadDOB"));
            component.set("v.lead.Gender__c", component.get("v.copyLeadGender"));
            component.set("v.lead.Resi_Pin_Code__c", component.get("v.copyLeadPincode"));
            component.set("v.lead.Email", component.get("v.copyLeadEmail"));
            component.set("v.lead.Customer_Mobile__c", component.get("v.copyLeadMobile"));
		}
	},
	validateMCP: function (component, event, helper) {
		console.log("inside child controller");
		return helper.validateMCP(component, event);
	},
	selectEmployer: function (component, event, helper) {
		var index = event.currentTarget.dataset.record;
		var selectedEmployer = component.get("v.employerList")[index];
		component.set("v.selectedEmployer", selectedEmployer);
		component.set("v.employerSearchKeyword", selectedEmployer.Name);
		component.set("v.lead.Employer__c", selectedEmployer.Id);
		helper.openCloseSearchResults(component, "employer", false);
		/*component.find("employerName").set("v.errors", [{
					message: ""
				}
			]);*/
		console.log('emp name' + component.get("v.employerSearchKeyword"));
		var employerSearchKeyword = component.get("v.employerSearchKeyword");
		component.set("v.ifOther", false);
		if (employerSearchKeyword.toUpperCase() == 'COMPANY NOT LISTED' || employerSearchKeyword.toUpperCase() == 'OTHER' || employerSearchKeyword.toUpperCase() == 'OTHERS') {
			//alert("other");
			component.set("v.ifOther", true);
		}
		component.set("v.companyCategory", selectedEmployer.Company_Category__c);
		// this.displayEmpData(component);
	},
	displayEmpData: function (component, event, helper) {
		//  var employerSearchKeyword  = event.getParam('empname');//component.get("v.employerSearchKeyword");
		// console.log('employerSearchKeyword>>'+ employerSearchKeyword);
		helper.getDisablecheckbox(component);
		var params = event.getParam('arguments');
		console.log('params>>>>>>>>>>>');
		console.log(JSON.stringify(params));
		if (params) {
			var employerSearchKeyword = params.empname;
			var isConverted = params.isPoConverted;
			console.log('pan value>>' + params.pannumber);
			if ($A.util.isEmpty(params.pannumber)) {
				console.log('empty');
				component.find("pannumber").set("v.disabled", false);
			} else
				component.find("pannumber").set("v.disabled", true);
            
			if (!$A.util.isEmpty(employerSearchKeyword) && (employerSearchKeyword.toUpperCase() == 'COMPANY NOT LISTED' || employerSearchKeyword.toUpperCase() == 'OTHER' || employerSearchKeyword.toUpperCase() == 'OTHERS')) {
				//alert("other");
				component.set("v.ifOther", true);
				if (isConverted) {
					component.find("pannumber").set("v.disabled", true);
					component.find("EmpNameIFOthers").set("v.disabled", true);
					component.find("profile").set("v.disabled", true);
				}
                component.set("v.employerSearchKeyword", employerSearchKeyword);
                console.log('employerSearchKeyword' + employerSearchKeyword);
			}
			component.set("v.companyCategory", params.category);
		}
	},
    disablePAN: function (component, event, helper) {
		var params = event.getParam('arguments');
		if (params) {
			console.log('pan value>>' + params.pannumber);
			if ($A.util.isEmpty(params.pannumber)) {
				console.log('empty');
				component.find("pannumber").set("v.disabled", false);
			} else
				component.find("pannumber").set("v.disabled", true);
		}
	},
	employerKeyPressController: function (component, event, helper) {
        console.log('emp name' + component.get("v.employerSearchKeyword"));
		var employerSearchKeyword = component.get("v.employerSearchKeyword");
		component.set("v.ifOther", false);
		if (employerSearchKeyword.toUpperCase() == 'COMPANY NOT LISTED' || employerSearchKeyword.toUpperCase() == 'OTHER' || employerSearchKeyword.toUpperCase() == 'OTHERS') {
			//alert("other");
			component.set("v.ifOther", true);
		}
		component.set("v.companyCategory", '');
		helper.startSearch(component, 'employer');
	},
	setResidenceAddress: function (component, event) {
		var lead = component.get("v.lead");
        var residenceAddress = component.find("address").get("v.value");
        if (residenceAddress) {
        var result = [], line = [];
        var length = 0;
        residenceAddress.split(" ").forEach(function(word) {
        if ((length + word.length) >= 35) {
            result.push(line.join(" "));
            line = []; length = 0;
        }
        length += word.length + 1;
            console.log('word'+word);
        line.push(word);
        console.log('line'+line);
       });
       if (line.length > 0) {
        result.push(line.join(" "));
           console.log('final result'+result);
       }
        if(result[0])
        {
         console.log('result[0]'+result[0]);
        lead.Residence_Address_Line1__c = result[0];
        }
        else
        lead.Residence_Address_Line1__c ='';
        if(result[1])
        {
        console.log('result[1]'+result[1]);
	    lead.Residence_Address_Line2__c =result[1];
        }
        else
        lead.Residence_Address_Line2__c='';
        if(result[2])
        {
        console.log('result[2]'+result[2]);
	    lead.Residence_Address_Line3__c =result[2];
        }
        else
        lead.Residence_Address_Line3__c='';
        }
        component.set("v.lead", lead);
	},
  
})