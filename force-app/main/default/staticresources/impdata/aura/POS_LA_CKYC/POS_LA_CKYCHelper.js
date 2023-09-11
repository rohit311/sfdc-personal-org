({
	getPickListOptionValues : function(component, event) {
		var contSelectList = ["Marital_Status__c","Father_Spouse__c","Father_Spouse_Salutation__c","Occupation_CKYC__c"];
        var appSelectList = ["Proof_of_Identity__c","Proof_of_Address_Submitted_for_Permanent__c","Proof_of_Residence_Address_Submitted__c"];
        
        var selectListNameMap = {};
        selectListNameMap["Applicant__c"] = appSelectList;
        selectListNameMap["Contact"] = contSelectList;
        this.executeApex(component, "getSelectListOptions", {"objectFieldJSON" : JSON.stringify(selectListNameMap)}, function(error, result){
            if(!error && result)
            {
                var data = JSON.parse(result);
                var picklistFields = data.picklistData;
                var appPickFields = picklistFields["Applicant__c"];
                var conPickFields = picklistFields["Contact"];
                console.log('data is'+ data);
                
                component.set("v.maritalStatusList", conPickFields["Marital_Status__c"]);
                component.set("v.fatherOrSpouseList", conPickFields["Father_Spouse__c"]);
                component.set("v.fatherSpouseSalutationlist", conPickFields["Father_Spouse_Salutation__c"]);
                component.set("v.employmentTypeList", conPickFields["Occupation_CKYC__c"]);
                component.set("v.docProofList", appPickFields["Proof_of_Identity__c"]);
                component.set("v.permDocumentList", appPickFields["Proof_of_Address_Submitted_for_Permanent__c"]);
                component.set("v.resiDocumentList", appPickFields["Proof_of_Residence_Address_Submitted__c"]);
                console.log('contact -->', JSON.stringify(component.get("v.contact")));
               console.log('ckyc number is -->'+component.get("v.applicantObject.CKYC_No__c"));
                console.log('Proof_of_Residence_Address_Submitted__c is -->'+component.get("v.applicantObject.Proof_of_Residence_Address_Submitted__c"));
                var proof = component.get("v.applicantObject.Proof_of_Residence_Address_Submitted__c");
                //Commented below for  Bug Id : 24716
                if(!$A.util.isEmpty(component.get("v.applicantObject.CKYC_No__c")) && !$A.util.isUndefined(component.get("v.applicantObject.CKYC_No__c")))
                {
                    component.set("v.loadSection", true);
                    if(component.get("v.applicantObject").Proof_of_Identity__c == '' || component.get("v.contact").Proof_of_Identity__c == undefined)
        			{
            			component.set("v.applicantObject.Proof_of_Identity__c", "PAN Card");
                    }
        
        			if(component.get("v.applicantObject").Identity_Document_No__c == '' || component.get("v.applicantObject").Identity_Document_No__c == undefined)
        			{
            			component.set("v.applicantObject.Identity_Document_No__c", component.get("v.contact.PAN_Number__c "));
        			}
                    
                    console.log(proof);
                    if (!$A.util.isEmpty(proof)) {
                        var lst = component.get("v.resiDocumentList");
                        debugger;
                        //var proof = component.get("v.applicantObject.Proof_of_Residence_Address_Submitted__c");
                           lst.push(proof);
                        console.log('lst -->', lst);
                        debugger;
                        component.set("v.resiDocumentList", lst);
                        component.set("v.applicantObject.Proof_of_Residence_Address_Submitted__c", proof);
                        console.log('here --> ');
                    }
                }
                else{
                    this.setDefaultValues(component, event);
                }
                
                console.log('component.get("v.shouldBeDisable") -->', component.get("v.shouldBeDisable"));
                if (component.get("v.shouldBeDisable") == true) {
                    this.disablecKycForm(component);
                }
                // US_27806_CKYC Details to be mandatory 
			   if(!this.isEmpty(component.get("v.applicantObject.CKYC_No__c"))){
			       component.find("ckycNo").set("v.disabled", true);
                   console.log('ckyc number is present, disabled field-->');
			   }
			   // US_27806_CKYC Details to be mandatory
            }
        });
        
	},
    
    executeApex: function(component, method, params,callback){
        var action = component.get("c."+method); 
        action.setParams(params);
        component.set("v.spinnerFlag","true");
        action.setCallback(this, function(response) {
            component.set("v.spinnerFlag","false");
            var state = response.getState();
            if(state === "SUCCESS"){
                callback.call(this, null, response.getReturnValue());
            } else if(state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message){
                        errors.push(item.message);
                    }
                }
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    setDefaultValues : function(component, event)
    {
        if(component.get("v.contact").Marital_Status__c == '' || component.get("v.contact").Marital_Status__c == undefined)
        {
            component.set("v.contact.Marital_Status__c", 'Married');
        }
        if(component.get("v.contact").Father_Spouse__c == '' || component.get("v.contact").Father_Spouse__c == undefined)
        {
            component.set("v.contact.Father_Spouse__c", "Spouse");
        }
        
        if(component.get("v.contact").Father_Spouse_Salutation__c == '' || component.get("v.contact").Father_Spouse_Salutation__c == undefined)
        {
            component.set("v.contact.Father_Spouse_Salutation__c", "Mr");
        }
        
        if(component.get("v.contact").Occupation_CKYC__c == '' || component.get("v.contact").Occupation_CKYC__c == undefined)
        {
            component.set("v.contact.Occupation_CKYC__c", "Professional");
        }
		
        if(component.get("v.applicantObject").Proof_of_Identity__c == '' || component.get("v.contact").Proof_of_Identity__c == undefined)
        {
            component.set("v.applicantObject.Proof_of_Identity__c", "PAN Card");
        }
        
        if(component.get("v.applicantObject").Identity_Document_No__c == '' || component.get("v.applicantObject").Identity_Document_No__c == undefined)
        {
            component.set("v.applicantObject.Identity_Document_No__c", component.get("v.contact.PAN_Number__c "));
        }
        
        component.set("v.loadSection", true);
    },
    
    callSaveCKYCData : function(component,event)
    {
        var contactObj = component.get("v.contact");
        var applObj = component.get("v.applicantObject");
        
        this.executeApex(component, "saveCKYCDataCtrl", {"contactObjJSON" : JSON.stringify(contactObj), "applicantObjJSON" : JSON.stringify(applObj)}, function(error, result){
            if(!error && result)
            {
                console.log('result'+result);
                if(result == 'success')
                {
                    this.showToast(component, 'Success', 'Records saved successfully.', 'success');
                    // US_27806_CKYC Details to be mandatory 
                       if(!this.isEmpty(component.get("v.applicantObject.CKYC_No__c"))){
                           component.find("ckycNo").set("v.disabled", true);
                           console.log('ckyc number is present, disabled field-->');
                       }
			        // US_27806_CKYC Details to be mandatory
                }
                else
                {
                    this.showToast(component, 'Error', 'An error occured. Record not saved.', 'error');
                }
            }
        });
    },
    
    showToast : function(component, title, message, type){
            var ShowToastEvent = $A.get("e.c:ShowToastEvent");
            ShowToastEvent.setParams({
                "title": title,
                "message":message,
                "type":type,
            });
            ShowToastEvent.fire();
    },
    
    isEmpty: function(value){
        return ($A.util.isEmpty(value) || $A.util.isUndefined(value) || value === 0);
    },
    
    addRemoveInputError: function(component, key, message){
        if(component.find(key))
        component.find(key).set("v.errors", [{message: message ? (message) : ""}]);
    },
    disablecKycForm : function(component) {
        console.log('inside diable');
        var list = [
            "ckycNo", "marital_status", "conFatherSpouse", "conFatherSpouseSalutation", "conFatherSpouseFirstNameVal", "conFatherSpouseMiddleNameVal", "documentNumber",
            "conFatherSpouseLastNameVal", "motherFirstNameVal", "motherMiddleNameVal", "motherLastNameVal", "o_e_type", "documentProof", "perm_documet_type", "resi_documet_type"
        ];
        for(var i = 0; i < list.length; i++){
            if(component.find(list[i]))
            component.find(list[i]).set("v.disabled", true);
        }
        // disable button
        if (component.find("save") != undefined)
            component.find("save").set("v.disabled", true);
    },
    enablecKycForm : function(component) {
        var list = [
            "ckycNo", "marital_status", "conFatherSpouse", "conFatherSpouseSalutation", "conFatherSpouseFirstNameVal", "conFatherSpouseMiddleNameVal", "documentNumber",
            "conFatherSpouseLastNameVal", "motherFirstNameVal", "motherMiddleNameVal", "motherLastNameVal", "o_e_type", "documentProof", "perm_documet_type", "resi_documet_type"
        ];
      //  debugger;
        for(var i = 0; i < list.length; i++){
            if(component.find(list[i]))
            component.find(list[i]).set("v.disabled", false);
        }
        // disable button
        if (component.find("save") != undefined)
            component.find("save").set("v.disabled", false);
     //   debugger;
    },
})