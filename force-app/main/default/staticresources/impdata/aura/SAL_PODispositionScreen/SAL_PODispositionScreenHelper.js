({
    validateFollowupDate: function (component) {
        var productOffering = component.get("v.productOffering");
        productOffering.Field_Followup_Date__c = component.find("followUpDate").get('v.value');
        return false;
    },
    enableFollowUpdate: function (component) {
        var objPO = component.get("v.productOffering");
        var convertedpo = objPO.Product_Offering_Converted__c;
        var teleDisposition = objPO.TeleCalling_Desposition_Status__c;
        var fieldDisposition = objPO.Field_Disposition_1__c;
        console.log('values is'+teleDisposition);
        if(!$A.util.isEmpty(component.get("v.referralSearchKeyword"))){
            component.set("v.refSel",true);
        }
        if(!$A.util.isEmpty(component.get("v.smartLeadSource"))){
            component.set("v.leadSrcSel",true);
        }
        if(!$A.util.isEmpty(component.get("v.sourceSearchKeyword"))){
            component.set("v.srcChSel",true);
        }
        console.log('profile'+component.get("v.isTeleCaller")+component.get("v.isFieldAgent"));
        if(component.get("v.isTeleCaller"))
        {
            if ((!$A.util.isEmpty(teleDisposition) && (teleDisposition == 'Sale' || teleDisposition == 'Follow Up')))
            {
                console.log("pk inside" +teleDisposition);
                component.set("v.isSourcingRequired",true);
            }
            else
             component.set("v.isSourcingRequired",false);   
        
            if ((!$A.util.isEmpty(teleDisposition) && teleDisposition == 'Follow Up'))
                component.set("v.enableFollowUp", true);
            else 
                component.set("v.enableFollowUp", false);
            
            if ((!$A.util.isEmpty(teleDisposition) && (teleDisposition == 'Sale' || teleDisposition == 'Follow Up'))
                && convertedpo == false)
                component.set("v.disableConvert", false);
            else
                component.set("v.disableConvert", true); 
        }
        if(component.get("v.isFieldAgent"))
        {
            if ((!$A.util.isEmpty(fieldDisposition) && (fieldDisposition == 'Docs Received' || fieldDisposition == 'Followup')))
            {
                console.log("pk inside" +fieldDisposition);
                component.set("v.isSourcingRequired",true);
            }
            else
             component.set("v.isSourcingRequired",false);  
            
            if ((!$A.util.isEmpty(fieldDisposition) && fieldDisposition == 'Followup'))
                component.set("v.enableFollowUp", true);
            else 
                component.set("v.enableFollowUp", false);
            
            if ((!$A.util.isEmpty(fieldDisposition) && (fieldDisposition == 'Docs Received' || fieldDisposition == 'Followup'))
                && convertedpo == false)
                component.set("v.disableConvert", false);
            else
                component.set("v.disableConvert", true);
        }
        //component.set("v.disableConvert", false);
        var selectDependentOptions = [];
        //alert('fieldDisposition++'+fieldDisposition);
        if(fieldDisposition == 'Docs Received')
        {
            selectDependentOptions.push({ value:"Docs Received", label:"Docs Received" });
        }
        else if(fieldDisposition == 'Not Contactable')
        {
            selectDependentOptions.push({ value:"Phone Ringing- No Response", label:"Phone Ringing- No Response" });
            selectDependentOptions.push({ value:"Phone Switched Off", label:"Phone Switched Off" });
            selectDependentOptions.push({ value:"SMS Not Delivered", label:"SMS Not Delivered" });
            selectDependentOptions.push({ value:"Wrong No", label:"Wrong No" });
            //alert('selectDependentOptions++'+selectDependentOptions);
        }
        else if(fieldDisposition == 'Followup')
        {
            selectDependentOptions.push({ value:"Call Back", label:"Call Back"});
            selectDependentOptions.push({ value:"Appointment Fixed", label:"Appointment Fixed" });
            selectDependentOptions.push({ value:"Documents not ready", label:"Documents not ready" });
            //alert('selectDependentOptions+Follow+'+selectDependentOptions);
        }
        else if(fieldDisposition == 'Not Eligible')
        {
            selectDependentOptions.push({ value:"CIBIL Negative", label:"CIBIL Negative" });
            selectDependentOptions.push({ value:"Salary norms not met", label:"Salary norms not met" });
            selectDependentOptions.push({ value:"FOIR", label:"FOIR" });
            selectDependentOptions.push({ value:"Banking", label:"Banking" });
            selectDependentOptions.push({ value:"Profile", label:"Profile" });
            selectDependentOptions.push({ value:"Company not listed", label:"Company not listed" });
            selectDependentOptions.push({ value:"Dedupe", label:"Dedupe" });
            selectDependentOptions.push({ value:"Negative Area", label:"Negative Area" });
        }
        else if(fieldDisposition == 'Not Contactable')
        {
            selectDependentOptions.push({ value:"Phone Ringing- No Response", label:"Phone Ringing- No Response" });
            selectDependentOptions.push({ value:"Phone Switched Off", label:"Phone Switched Off" });
            selectDependentOptions.push({ value:"SMS Not Delivered", label:"SMS Not Delivered" });
            selectDependentOptions.push({ value:"Wrong No", label:"Wrong No" });
        }
        else if(fieldDisposition == 'Not Interested')
        {
            selectDependentOptions.push({ value:"NI-Processing Fee- Unsecured", label:"NI-Processing Fee- Unsecured" });
            selectDependentOptions.push({ value:"NI-ROI-Unsecured Loan", label:"NI-ROI-Unsecured Loan" });
            selectDependentOptions.push({ value:"NI-TENURE", label:"NI-TENURE" });
            selectDependentOptions.push({ value:"NI- INSURANCE", label:"NI- INSURANCE" });
            selectDependentOptions.push({ value:"NI-OFFER AMOUNT", label:"NI-OFFER AMOUNT" });
            selectDependentOptions.push({ value:"NI-No requirement", label:"NI-No requirement" });
            selectDependentOptions.push({ value:"NI - Due to TAT", label:"NI - Due to TAT" });
            selectDependentOptions.push({ value:"Irate Customer", label:"Irate Customer" });
            selectDependentOptions.push({ value:"Prefers Competitors", label:"Prefers Competitors" });
            selectDependentOptions.push({ value:"Availed from Competitor", label:"Availed from Competitor" });
        }
        /*else if(fieldDisposition == 'Converted')
        {
            selectDependentOptions.push({ value:"Converted", label:"Converted" });
        }*/
        var selectDependentOptionsTel = [];
        //alert('teleDisposition++'+teleDisposition);
        if(teleDisposition == 'Docs Received')
        {
            selectDependentOptionsTel.push({ value:"Docs Received", label:"Docs Received" });
        }
        else if(teleDisposition == 'Not Contactable')
        {
            selectDependentOptionsTel.push({ value:"Phone Ringing- No Response", label:"Phone Ringing- No Response" });
            selectDependentOptionsTel.push({ value:"Phone Switched Off", label:"Phone Switched Off" });
            selectDependentOptionsTel.push({ value:"SMS Not Delivered", label:"SMS Not Delivered" });
            selectDependentOptionsTel.push({ value:"Wrong No", label:"Wrong No" });
            //alert('selectDependentOptionsTel++'+selectDependentOptionsTel);
        }
        else if(teleDisposition == 'Follow Up')
        {
            selectDependentOptionsTel.push({ value:"Call Back", label:"Call Back"});
            selectDependentOptionsTel.push({ value:"Appointment Fixed", label:"Appointment Fixed" });
            selectDependentOptionsTel.push({ value:"Documents not ready", label:"Documents not ready" });
            //alert('selectDependentOptionsTel+Follow+'+selectDependentOptionsTel);
        }
        else if(teleDisposition == 'Sale')
        {
            selectDependentOptionsTel.push({ value:"Sale", label:"Sale"});
        }
        else if(teleDisposition == 'Transfer to Field')
        {
            selectDependentOptionsTel.push({ value:"Transfer to Field", label:"Transfer to Field"});
        }
        else if(teleDisposition == 'Not Eligible')
        {
            selectDependentOptionsTel.push({ value:"CIBIL Negative", label:"CIBIL Negative" });
            selectDependentOptionsTel.push({ value:"Salary norms not met", label:"Salary norms not met" });
            selectDependentOptionsTel.push({ value:"FOIR", label:"FOIR" });
            selectDependentOptionsTel.push({ value:"Banking", label:"Banking" });
            selectDependentOptionsTel.push({ value:"Profile", label:"Profile" });
            selectDependentOptionsTel.push({ value:"Company not listed", label:"Company not listed" });
            selectDependentOptionsTel.push({ value:"Dedupe", label:"Dedupe" });
            selectDependentOptionsTel.push({ value:"Negative Area", label:"Negative Area" });
        }
        else if(teleDisposition == 'Not Contactable')
        {
            selectDependentOptionsTel.push({ value:"Phone Ringing- No Response", label:"Phone Ringing- No Response" });
            selectDependentOptionsTel.push({ value:"Phone Switched Off", label:"Phone Switched Off" });
            selectDependentOptionsTel.push({ value:"SMS Not Delivered", label:"SMS Not Delivered" });
            selectDependentOptionsTel.push({ value:"Wrong No", label:"Wrong No" });
        }
        else if(teleDisposition == 'Not Interested')
        {
            selectDependentOptionsTel.push({ value:"NI-Processing Fee- Unsecured", label:"NI-Processing Fee- Unsecured" });
            selectDependentOptionsTel.push({ value:"NI-ROI-Unsecured Loan", label:"NI-ROI-Unsecured Loan" });
            selectDependentOptionsTel.push({ value:"NI-TENURE", label:"NI-TENURE" });
            selectDependentOptionsTel.push({ value:"NI- INSURANCE", label:"NI- INSURANCE" });
            selectDependentOptionsTel.push({ value:"NI-OFFER AMOUNT", label:"NI-OFFER AMOUNT" });
            selectDependentOptionsTel.push({ value:"NI-No requirement", label:"NI-No requirement" });
            selectDependentOptionsTel.push({ value:"NI - Due to TAT", label:"NI - Due to TAT" });
            selectDependentOptionsTel.push({ value:"Irate Customer", label:"Irate Customer" });
            selectDependentOptionsTel.push({ value:"Prefers Competitors", label:"Prefers Competitors" });
            selectDependentOptionsTel.push({ value:"Availed from Competitor", label:"Availed from Competitor" });
        }
        component.set("v.fieldSubDispositionList", selectDependentOptions);
        component.set("v.teleCallingSubList", selectDependentOptionsTel);
        
    },
    picklistTeleCalling: function (component) {
        var objPO = component.get("v.productOffering");
        var convertedpo = objPO.Product_Offering_Converted__c;
        var teleDisposition = objPO.TeleCalling_Desposition_Status__c;
        var fieldDisposition = objPO.Field_Disposition_1__c;
        /*
        if (!$A.util.isEmpty(objPO.TeleCalling_Desposition_Status__c) && objPO.TeleCalling_Desposition_Status__c == 'Sale')
        {
            component.set("v.productOffering.Field_Disposition_1__c",'Docs Received');
            component.set("v.productOffering.Field_Desposition_Status__c",'Docs Received');
        }*/
        if(component.get("v.isTeleCaller"))
        {
            if (!$A.util.isEmpty(teleDisposition) && teleDisposition == 'Follow Up')
                component.set("v.enableFollowUp", true);
            else 
                component.set("v.enableFollowUp", false);
            
            if ((!$A.util.isEmpty(teleDisposition) && teleDisposition == 'Sale')
                && !convertedpo)
                component.set("v.disableConvert", false);
            else
                component.set("v.disableConvert", true);
        }
        if(component.get("v.isFieldAgent"))
        {
            if ((fieldDisposition!='' && fieldDisposition == 'Docs Received')
                && !convertedpo)
                component.set("v.disableConvert", false);
            else
                component.set("v.disableConvert", true);
        }
    },
    saveDispositionRecord: function(component, objPO,showMsg,fromconvert){//added one more parameter in Method,Bug 17795//added param 5881   
		var res = true;
        if(!fromconvert){
        	var reqdFields = ['PO.Offer_Amount__c','Lead.DOB__c','PO.Offer_ROI__c','PO.Tenor__c','PO.EMI_Amount__c','PO.Resi_Pick_State__c','PO.Pin_Code__c']
        	res = this.checkValidity(component,event,reqdFields,false);
        }

		var isInValidMsg = true;
        var isInValidFollow = true;
        var isFieldAgent = component.get("v.isFieldAgent");
        var isTeleCaller = component.get("v.isTeleCaller");
        var teleCallerId = component.find("teleCallerId");
        if(!$A.util.isEmpty(teleCallerId) && teleCallerId.get("v.validity").valid)
            console.log('teleCallerId'+isInValidMsg);
        else{
            if(typeof teleCallerId != 'undefined'){//added if condition for bug id 18390
                teleCallerId.showHelpMessageIfInvalid();
                isInValidMsg = false;
            }
        }
        /*var sourceList = component.get("v.smartleadSourceList");
        var srcName = component.find("smartLeadSourceName").get("v.value");
        console.log('sourceList'+sourceList.length);
        for(var i in sourceList){
            console.log('srcname'+sourceList[i].Name);
        }*/
        console.log('lead src sel'+component.get("v.leadSrcSel"));
        var todaysDate = new Date();
        if(isTeleCaller)
        {
           
             objPO.Dependent_Action__c =  objPO.TeleCalling_Desposition_Status__c;//prod issue
            var poProduct = component.find("teleCallingId");
            if(!$A.util.isEmpty(poProduct) && poProduct.get("v.validity").valid)
                console.log('poProduct'+isInValidMsg);
            else{
                poProduct.showHelpMessageIfInvalid();
                isInValidMsg = false;
            }
            var teleCallingSubId = component.find("teleCallingSubId");
            if(!$A.util.isEmpty(teleCallingSubId) && teleCallingSubId.get("v.validity").valid)
                console.log('poProduct'+isInValidMsg);
            else{
                teleCallingSubId.showHelpMessageIfInvalid();
                isInValidMsg = false;
            }
            /*if($A.util.isEmpty(component.find("smartLeadSourceName").get("v.value")))
            {
                isInValidMsg = false;
                component.find("smartLeadSourceName").set("v.errors", [{
                    message: "Please Enter Value"
                }
                                                                      ]);
            }*/
            if (component.find("teleCallingId")!='' && component.find("teleCallingId").get('v.value') =='Follow Up' && $A.util.isEmpty(component.find("followUpDate").get('v.value'))) {
                console.log('insie false');
                $A.util.addClass(component.find("followupdiv"), "slds-show");
                isInValidMsg = false;
            } else {
                if(component.find("teleCallingId")!='' && component.find("teleCallingId").get('v.value') =='Follow Up'){
                    var followUpDate = new Date(component.find("followUpDate").get('v.value'));
                    if(todaysDate > followUpDate){
                        $A.util.addClass(component.find("followupdiv"), "slds-show");
                        isInValidFollow = false;
                        //this.displayToastMessage(component,event,'Info','Please enter future follow up date','info'); 
                    }
                    else{
                        $A.util.removeClass(component.find("followupdiv"), "slds-show");
                        $A.util.addClass(component.find("followupdiv"), "slds-hide");
                    }
                }
                else{
                    $A.util.removeClass(component.find("followupdiv"), "slds-show");
                    $A.util.addClass(component.find("followupdiv"), "slds-hide");
                }
                
                
            }
        }
        if(isFieldAgent)
        {
            var fieldDisposition = component.find("fieldDispositionId");
            if(fieldDisposition!='' && fieldDisposition!=undefined && fieldDisposition.get("v.validity").valid)
                console.log('fieldDisposition'+isInValidMsg);
            else{
                fieldDisposition.showHelpMessageIfInvalid();
                isInValidMsg = false;
            }
            var fieldSubDisposition = component.find("fieldSubDispositionId");
            if(fieldSubDisposition!='' && fieldSubDisposition!=undefined && fieldSubDisposition.get("v.validity").valid)
                console.log('fieldSubDisposition'+isInValidMsg);
            else{
                fieldSubDisposition.showHelpMessageIfInvalid();
                isInValidMsg = false;
            } 
            
            if (component.find("fieldDispositionId")!='' && component.find("fieldDispositionId").get('v.value') =='Followup' && $A.util.isEmpty(component.find("followUpDate").get('v.value'))) {
                $A.util.addClass(component.find("followupdiv"), "slds-show");
                isInValidMsg = false;
            } else {
                if (component.find("fieldDispositionId")!='' && component.find("fieldDispositionId").get('v.value') =='Followup'){
                	var followUpDate = new Date(component.find("followUpDate").get('v.value'));
            		if(todaysDate > followUpDate){
                		$A.util.addClass(component.find("followupdiv"), "slds-show");
                		isInValidFollow = false;
                    //this.displayToastMessage(component,event,'Info','Please Enter future follow up date','info');   
            		}    
                }
                
                $A.util.removeClass(component.find("followupdiv"), "slds-show");
                $A.util.addClass(component.find("followupdiv"), "slds-hide");
            } 
        }
        /*if($A.util.isEmpty(component.get("v.sourceSearchKeyword")))
        {
            isInValidMsg = false;
            component.find("sourceName").set("v.errors", [{
                message: "Please Enter Value"
            }
                                                         ]);
        }*/
        if($A.util.isEmpty(component.get("v.referralSearchKeyword"))){
            objPO.Referral__c = component.get("v.referralSearchKeyword");
        }
        objPO.UTM_Source__c = 'SAL_Mobility2';
		//bug 17557 s added by kishore 
		var objLead = component.get("v.objLead");
		//bug 17557 e added by kishore
		console.log('TeleCaller remarks is '+objPO.Tele_Caller_Remarks__c);
        var action = component.get('c.savePO');
        action.setParams({
            "jsonPOrecord": JSON.stringify([objPO]) + ';' + JSON.stringify([objLead]),
        });
        //appended param for 5881
        action.setCallback(this,function(response){
            var state = response.getState();
            //alert(response.getReturnValue());
            console.log('response is>>>'+state+' value>>>'+response.getReturnValue());
            if(state == 'SUCCESS')
            {
                var resultMap = JSON.parse(response.getReturnValue());
				var productOffering = resultMap['po']; //5881
                var leadObj = resultMap['lead'];//5881
                console.log(response.getReturnValue());
                var emiAmount = productOffering.EMI_Amount__c;
                if(emiAmount){
                	productOffering.EMI_Amount__c = emiAmount.toFixed(2); 
                }
                console.log('emi amount ---- '+productOffering.EMI_Amount__c);
                component.set("v.productOffering",productOffering);
                component.set("v.leadObj",leadObj);//5881
                //if(component.get("v.iscommunityUser") == false)
                //    component.set("v.productOffering.Sourcing_Channel__r.Name","");
                this.showhidespinner(component,event,false);
                console.log('showMsg : '+showMsg);
                //added if condition for showMsg,Bug 17795
                if(showMsg){
                    this.displayToastMessage(component,event,'Success','Data Saved Successfully','success');
                }
            }
            else
            {
                this.showhidespinner(component,event,false);
                //added if condition for showMsg,Bug 17795
                if(showMsg){
                    this.displayToastMessage(component,event,'Error','Failed To Save Data','error');
                }
            }
        });
        console.log('isInValidMsg'+isInValidMsg+'--');
        if(!$A.util.isEmpty(component.find("smartLeadSourceName")) && !$A.util.isEmpty(component.find("smartLeadSourceName").get("v.value")) && !component.get("v.leadSrcSel")){
            this.displayToastMessage(component,event,'Error','Please select valid lead source','error');   
            this.showhidespinner(component,event,false);  
            return false;
        }
        else if(!$A.util.isEmpty(component.find("referralName")) && !$A.util.isEmpty(component.find("referralName").get("v.value")) && !component.get("v.refSel")){
            this.displayToastMessage(component,event,'Error','Please select valid Referral','error');   
            this.showhidespinner(component,event,false);  
            return false;
        }
        
        else if(component.get("v.isSourcingRequired") && ($A.util.isEmpty(component.find("sourceName").get("v.value")) || component.get("v.srcChSel") == false)){
            this.displayToastMessage(component,event,'Error','Please select valid sourcing channel','error');   
              component.find("sourceName").set("v.errors", [{
                 message: " COMPLETE THIS FIELD"
        }    ]);
            this.showhidespinner(component,event,false);  
            return false;
        }
        else if(isInValidFollow == false){
        	this.displayToastMessage(component,event,'Error','Please enter future follow up date','error');   
            this.showhidespinner(component,event,false);  
            return false;
        }
        else if(isInValidMsg == true)
        {                  
            this.showhidespinner(component,event,true);
            console.log('remarks'+objPO.Tele_Caller_Remarks__c);
             if(fromconvert){
            	var reqdFields = ['PO.Offer_Amount__c','Lead.DOB__c','PO.Offer_ROI__c','PO.Tenor__c','PO.EMI_Amount__c','PO.Resi_Pick_State__c','PO.Pin_Code__c']
        	
                var res = this.checkValidity(component,event,reqdFields,true);
        	}
            if(res)
            	$A.enqueueAction(action);
            else
                this.showhidespinner(component,event,false);
        }
        else{
            this.displayToastMessage(component,event,'Error','Please fill all Required Fields','error');   
            this.showhidespinner(component,event,false);
        }
        return isInValidMsg;
    },
    populatesubdispoData: function(component,event){
        this.populateDispositionDataInternal(component, "fieldSubDispositionId", {
            "controllingField": "Field_Disposition_1__c",
            "dependentField": "Field_Desposition_Status__c",
            "fldDisposition": component.get("v.productOffering.Field_Disposition_1__c")
        }, function(){});
    },
    populateDispositionDataInternal: function(component, elementId, params, callback) {
        var isdisable = component.get("v.isPOconverted");
        this.executeApex(component, 'getDisposition', params, function(error, result){
            console.log('a');
            if(!error && result){
                if(!$A.util.isEmpty(result))
                {            console.log('b');
                 
                 component.set("v.fieldSubDispositionList",result);
                component.find("fieldSubDispositionId").set("v.disabled", false);
                }
                else
                {
                    component.find("fieldSubDispositionId").set("v.disabled", true);
                    component.set("v.productOffering.Field_Desposition_Status__c",'');
                }
            } 
            component.set("v.isPOconverted",isdisable);
            callback.call(this);
        });
    },
    executeApex: function (component, method, params, callback) {
        var action = component.get("c." + method);
        action.setParams(params);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('response.getReturnValue()' + response.getReturnValue());
                callback.call(this, null, response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for (var i = 0; i < array.length; i++) {
                    var item = array[i];
                    if (item && item.message) {
                        errors.push(item.message);
                    }
                }
                //this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    covertOSend: function(component , poObj){
        /*put validations here*/
         this.showhidespinner(component,event,true);
        console.log('poObj'+poObj.Id);
          poObj.Dependent_Action__c =  poObj.TeleCalling_Desposition_Status__c;//prod issue
        /*var validData = this.saveDispositionRecord(component , poObj,false);//added one more parameter in Method,Bug 17795
        this.showhidespinner(component,event,true);
        console.log('validData'+validData);*/
        //if(validData){
            console.log('inside convert')
            this.executeApex(component, 'callConvertToLAField', 
                             {
                                 "flow": 'salaried',
                                 "poId": poObj.Id,
                             }, function(error, result){
                                 console.log('Converted '+result+error);
                                 if (!error && result && result.length) {
                                     if( result.includes(';')){
                                         console.log('Converted successfully');
                                         var data = result.split(';');
                                         console.log('data>>' + data);
                                         component.set("v.loanId", data[1]);
                                         //component.set("v.theme", data[2]);
                                         component.set("v.isPOconverted",true);
                                         this.showhidespinner(component,event,false);
                                         this.displayMessage(component, 'SuccessToast1', 'successmsg1', 'Converted successfully to LAN :' + data[0], "Click Here");
                                     }
                                     else if(result == 'failduetopancheck'){
                                         this.showhidespinner(component,event,false);
                                         this.displayToastMessage(component,event,'Error','We are unable to process your application at this stage due to internal policy norms not met.','error');
                                     }
                                 } 
                                 else{
                                     this.showhidespinner(component,event,false);
                                     this.displayToastMessage(component,event,'Error','Failed to convert loan application.','error');
                                 }
                                 
                             });
       /* }
        else{
            this.showhidespinner(component,event,false);
        }*/
        
    },
    startSearch: function (component, key) {
        var keyword = component.get("v." + key + "SearchKeyword");
        console.log("keyword" + keyword+"key"+key);
        if(key == 'source')
        {
            if (keyword.length > 2 && !component.get('v.sourcesearching')) {
                console.log("keyword sourcesearching" + keyword+"key"+key);
                component.set('v.sourcesearching', true);
                component.set('v.oldSearchKeyword', keyword);
                this.searchHelper(component, key, keyword);
            }
            else if (keyword.length <= 2) {
                console.log("keyword" + keyword+"key"+key);
                component.set("v." + key + "List", null);
                this.openCloseSearchResults(component, key, false);
            }
        }
        if(key == 'referral')
        {
            if (keyword.length > 2 && !component.get('v.referralsearching')) {
                component.set('v.referralsearching', true);
                component.set('v.oldReferralSearchKeyword', keyword);
                this.searchHelper(component, key, keyword);
            }
            else if (keyword.length <= 2) {
                console.log("keyword" + keyword+"key"+key);
                component.set("v." + key + "List", null);
                this.openCloseSearchResults(component, key, false);
            }
        }
    },
    searchHelper: function (component, key, keyword) {
        console.log('executeApex>>' + keyword + '>>key>>' + key);
        this.executeApex(component, "fetch" + this.toCamelCase(key), {
            'searchKeyWord': keyword
        }, function (error, result) {
            console.log('result : ' + result);
            if (!error && result) {
                this.handleSearchResult(component, key, result);
            }
        });
    },
    openCloseSearchResults: function (component, key, open) {
        var resultPanel = component.find(key + "SearchResult");
        $A.util.addClass(resultPanel, open ? 'slds-is-open' : 'slds-is-close');
        $A.util.removeClass(resultPanel, open ? 'slds-is-close' : 'slds-is-open');
    },
    
    toCamelCase: function (str) {
        return str[0].toUpperCase() + str.substring(1);
    },
    handleSearchResult: function (component, key, result) {
        console.log('key :  handleSearchResult' + key);
        console.log(result);
        console.log('v.oldSearchKeyword :' + component.get('v.oldSearchKeyword') + '  -> SearchKeyword : ' + component.get("v." + key + "SearchKeyword"));
        
        console.log('inside handleserach'+component.get('v.oldSearchKeyword')+component.get("v." + key + "SearchKeyword"));
        if(key == 'source')
        {
            component.set('v.sourcesearching', false);
            if (!$A.util.isEmpty(component.get("v." + key + "SearchKeyword")) && component.get('v.oldSearchKeyword') !== component.get("v." + key + "SearchKeyword")) {
                component.set("v." + key + "List", null);
                this.startSearch(component, key);
            }
            else {
                component.set("v." + key + "List", result);
                //this.showHideMessage(component, key, !result.length);
                this.openCloseSearchResults(component, key, true);
            }
        }
        if(key == 'referral')
        {
            component.set('v.referralsearching', false);
            if (!$A.util.isEmpty(component.get("v." + key + "SearchKeyword")) && component.get('v.oldReferralSearchKeyword') !== component.get("v." + key + "SearchKeyword")) {
                component.set("v." + key + "List", null);
                this.startSearch(component, key);
            }
            else {
                component.set("v." + key + "List", result);
                //this.showHideMessage(component, key, !result.length);
                this.openCloseSearchResults(component, key, true);
            }
        }
    },
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    }, 
    searchLeadSource: function(component) {
        var keyword = component.get("v.smartLeadSource"); 
        if(keyword.length > 2){
            var all = component.get("v.leadSourceList") || [];
            var filterValues = [];
            for(var i = 0; i < all.length; i++){
                var value = all[i];
                if(value.toLowerCase().includes(keyword.toLowerCase())){
                    filterValues.push(value);
                }
            }
            component.set("v.smartleadSourceList", filterValues);
            //this.showHideMessage(component, "residenceCity", !filterValues.length);
            this.openCloseSearchResults(component, "smartLead", true);
        } else {  
            component.set("v.smartleadSourceList", null); 
            this.openCloseSearchResults(component, "smartLead", false);
        }
    },
    displayToastMessage:function(component,event,title,message,type)
    {
        console.log('inside displayToastMessage'+message+type);
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type,
            
        });
        showhideevent.fire();
    },
    displayMessage: function (component, toastid, messageid, message, messagelabel) {
        
        document.getElementById(messageid).innerHTML = message;
        document.getElementById(toastid).style.display = "block";
        if (!$A.util.isEmpty(messagelabel)) {
            console.log('in if');
            component.find("toastURL").set("v.label", messagelabel);
        }
    },
    //Rohit added for 101 start
    checkLAN : function(component , poObj){
        console.log('poObj'+poObj.Id);
        var validData = this.saveDispositionRecord(component,poObj,false,true);//added one more parameter in Method,Bug 17795//added one more parameter 5881
		this.showhidespinner(component,event,true);
		var reqdFields = ['PO.Offer_Amount__c','Lead.DOB__c','PO.Offer_ROI__c','PO.Tenor__c','PO.EMI_Amount__c','PO.Resi_Pick_State__c','PO.Pin_Code__c'];//5881
        var isInValidMsg = this.checkValidity(component,event,reqdFields,true);//5881 
        console.log('validData'+validData);
        var self = this;
         if(validData && isInValidMsg){ //5881
              this.executeApex(component, 'checkDualLAN', 
                             {                                
                                 "poId": poObj.Id,
                             }, function(error, result){
                                 console.log('Converted '+result+error);
                                 if (!error && result) {
                                     if(result == 'false'){
                                       
                                        self.covertOSend(component,poObj);
                                     }
                                     else{
                                         this.showhidespinner(component,event,false);
                                         this.displayToastMessage(component,event,'Error','We are unable to process your application at this stage due to internal policy norms not met.','error');
                                     }
                                 } 
                                 else{
                                     this.showhidespinner(component,event,false);
                                     this.displayToastMessage(component,event,'Error','Failed to convert loan application.','error');
                                 }
                                 
                             });
         }
        else{
			if(!isInValidMsg){ //5881 s
                 this.displayToastMessage(component,event,'Error','Please enter all required fields before conversion','error');
            }//5881 e
            this.showhidespinner(component,event,false);
        }
    },
    ////Rohit added for 101 stop
    //user story 5881 s
    checkValidity: function(component,event,reqdFields,fromConvert){
        console.log('inside here');
        var flag = false;
        var Errfields = [];
        var passField = [];
        if(!$A.util.isEmpty(reqdFields)){
            for(var i=0 ; i < reqdFields.length ; i++) {
                var splitfield = reqdFields[i].split('.');
                console.log('splitfield is '+splitfield);
                if(splitfield[0] == 'Lead'){
                    console.log('splitfield is '+component.get('v.objLead'));
                    if(fromConvert){
                        if($A.util.isEmpty(component.get('v.objLead')[splitfield[1]])){
                           flag = true;
                            //break;
                            Errfields.push(splitfield[1]);
                        }else{
                            passField.push(splitfield[1]);
                        }
                    }else{
                        passField.push(splitfield[1]);
                    }
                    	//return false;
                }
                if(splitfield[0] == 'PO'){
                    console.log('splitfield is '+component.get('v.productOffering')[splitfield[1]]);
                    if(fromConvert){
                        if($A.util.isEmpty(component.get('v.productOffering')[splitfield[1]])){
                            console.log('inside false for PO');
                            flag = true;
                            //break;
                            //return false;
                            Errfields.push(splitfield[1]);
                        }else{
                            passField.push(splitfield[1]);
                            
                        }
                    }else{
                        passField.push(splitfield[1]);
                    
                    }
                }
                /*if(!$A.util.isEmpty(component.find(key))){
                    if(!component.find(key).get("v.validity").valid){
                        return false;
                    }
                }*/
			}
        }
        if(component.get('v.productOffering')["Availed_Amount__c"] > component.get('v.productOffering')["Offer_Amount__c"]){
            flag = true;
            Errfields.push("Availed_Amount__c");
        }
        else{ 
             passField.push("Availed_Amount__c");
        }
        var appEvent = $A.get("e.c:DisplayErrFieldsPO");
		appEvent.setParams({ "errFields" : Errfields,
                            "passFields" : passField
                           });
        appEvent.fire();
		console.log('event fired');
       
        	if(!flag){
            	console.log('returning true');
        		return true;
        	}
        	else{
        		console.log('returning false');
            	return false;
        
        	}

       
    }
    //User story 5881 e
})