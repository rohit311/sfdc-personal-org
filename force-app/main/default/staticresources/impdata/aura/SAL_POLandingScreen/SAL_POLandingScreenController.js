({
	doInit: function(component, event, helper) {
        var objPO = component.get("v.productOffering");
		//5881 s
        if($A.util.isEmpty(objPO.Offer_Amount__c)){
            component.set("v.isOfferEmpty",true);
        }
        else{
             component.set("v.isOfferEmpty",false);
        }
        
        if(objPO.Availed_Amount__c != null && objPO.Availed_Amount__c != 0){
            component.set("v.showEmi",true);
        }
		//5881 e
       // component.set("v.productOffering",objPO);
       // Commented Above line for bug 17749
      /* var lead = JSON.stringify(component.get('v.objLead'));
        console.log('Lead 111: '+lead);
       
        if (lead.Employer__r){
			component.set("v.companyCategory", lead.Employer__r.Company_Category__c);
            component.set("v.selectedEmployer", lead.Employer__r.Name);
		}*/
        console.log('in do init of landing');
        var dispoCmp = component.find("dispositionScreen");
        dispoCmp.getPO();
        
         /*23064 start
    
   
        var validExotelProd;
        component.set("v.displayExotel",false);
        helper.executeApex(component,'getvalidExotelProduct', {
            
        }, function (error, result) {
            if (!error && result) {
                
                var data=JSON.parse(result);
                component.set("v.validExotelProd",data);
                validExotelProd=component.get("v.validExotelProd");
              //  alert('gere '+component.get("v.productOffering.Products__c"));
                for(var i=0 ; i < validExotelProd.length ; i++){
                    if(component.get("v.productOffering.Products__c") && validExotelProd[i] && validExotelProd[i].toUpperCase() === component.get("v.productOffering.Products__c").toUpperCase()){
                        component.set("v.displayExotel",true);
                    }
                }
                
            }else{
                alert('no data');
            }
         }); 
      23064 end*/
        
    },
    savePODetailData: function(component, event, helper) {
        
        var objPO = component.get("v.productOffering");
        var leadObj = component.get("v.objLead");
        var scam = component.get("v.scam");//Bug 18576
        console.log('objPO++'+objPO.Products__c);
        console.log('objPO is : '+JSON.stringify(objPO));
        console.log('leadObj is : '+JSON.stringify(leadObj));
        console.log('scam is : '+JSON.stringify(scam));
        if(((component.get("v.ifOther")== true) && ($A.util.isEmpty(leadObj.Employer_Name__c)))){	  
            helper.displayToastMessage(component,event,'Error','Please fill all the required details','error');
        }else{
            helper.showhidespinner(component,event,true);
        	helper.savePODetailData(component,objPO,leadObj,scam);//Bug 18576
    	}
    },
    /*Bug 18576 Start*/
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
        component.set("v.segId", selectedEmployer.Id);
        console.log('scamId is : '+component.get('v.segId'));
		// this.displayEmpData(component);
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
    DestroyChildCmp: function(component, event, helper) {
        console.log('child destroy'); 
       // var numbers =[];
       // component.set("v.lstPo",numbers);
        component.destroy();
    },
//5881 s
    showErrFields: function(component,event,helper){
        console.log('event handeled');
        var errFields = event.getParam("errFields");
        var passFields = event.getParam("passFields");
        var availamounterror = false;
        if(component.get("v.productOffering.Availed_Amount__c" ) != null && component.get("v.productOffering.Availed_Amount__c" ) != 0 && $A.util.isEmpty(errFields)){
            component.set('v.showEmi',true);
        }else{
            component.set('v.showEmi',false);
        }
        //console.log('passFields '+passFields);
        if(!$A.util.isEmpty(errFields)){
        	for(var i=0; i < errFields.length; i++){
                if(errFields[i] != 'Availed_Amount__c'){
                	var field = component.find(errFields[i]);
                	$A.util.addClass(field,'slds-has-error');
                }else{
                    availamounterror = true;
                }
                //field.showHelpMessageIfInvalid();
       	 	}
        }
        console.log('passFields '+passFields);
        if(!$A.util.isEmpty(passFields)){
            for(var j=0; j < passFields.length; j++){
                if(errFields[i] != 'Availed_Amount__c'){
                	console.log('passField is '+passFields[j]);
                	var field = component.find(passFields[j]);
                	$A.util.removeClass(field,'slds-has-error');
                }else{
                    availamounterror = false;
                }
            }
        }
        if($A.util.isEmpty(errFields) && !availamounterror){
            var objPO = component.get("v.productOffering");
            if($A.util.isEmpty(objPO.Offer_Amount__c)){
                component.set("v.isOfferEmpty",true);
            }
            else{
                component.set("v.isOfferEmpty",false);
            }
        }
        if(availamounterror)
			helper.displayToastMessage(component,event,'Error','Availed amount cannot be greater than Offer amount','error');
    },
//5881 e
    /*Bug 18576 End*/
    /*added by swapnil 23064 
    makeacall : function(component,event,helper){
       helper.showhidespinner(component,event,true);
       helper.displayToastMessage(component,event,'Success','Calling....','success'); 
        
        console.log('Swapnil '+component.get("v.objLead"));
        var LeadId = component.get("v.objLead.Id")+'';
     //  alert(LeadId);
        var fromNumber;
       
        if(component.get("v.userInfo.Mobile_number__c"))
            fromNumber=component.get("v.userInfo.Mobile_number__c");
        else if(component.get("v.userInfo.Phone"))
            fromNumber=component.get("v.userInfo.Phone");
        else if(component.get("v.userInfo.MobilePhone"))
            fromNumber=component.get("v.userInfo.MobilePhone");
        // callToCustomerCallback
         helper.executeApex(component,'callToCustomer', {
             "frommobile" : 'none', //fromNumber,
             "tomobile" : component.get("v.objLead.Customer_Mobile__c")+'',
             "objName":"Lead",
             "Id" : LeadId,
             "Product":component.get("v.productOffering.Products__c").toUpperCase()
         }, function (error, result) {
             if (!error && result) {
                 console.log('Callback done '+JSON.stringify(result));
                 if(result !== 'Success'){
                     helper.displayToastMessage(component,event,'Error',result,'error');
                 }
                helper.showhidespinner(component,event,false);
             }else{
                 console.log('error '+leadId);
                  helper.displayToastMessage(component,event,'Error',result,'error');
    }
         }); 
    },
 added by swapnil 23064 e*/
})