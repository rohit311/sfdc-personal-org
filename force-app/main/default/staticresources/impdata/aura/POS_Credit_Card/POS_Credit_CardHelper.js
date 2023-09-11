({
     showToast : function(component, title, message, type){  
        var self = this;
        console.log(self);
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){ //Standard toast message : if supports standard toast message
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "3000"
            });    
            toastEvent.fire();
        }else{ //Custom toast message : if doesn not support standard toast message
            var customToast = component.find('customToast');
            $A.util.removeClass(customToast, 'slds-hide');
            var toastTheme = component.find("toastTheme");
            $A.util.removeClass(toastTheme,"slds-theme--error");
            $A.util.removeClass(toastTheme,"slds-theme--success");
            if(type == 'error'){
                $A.util.addClass(toastTheme,"slds-theme--error");
            }
            else if(type == 'success'){
                $A.util.addClass(toastTheme,"slds-theme--success");
            }
            component.find("toastText").set("v.value", message);
            component.find("toastTtitle").set("v.value", title+' ');
            
            setTimeout($A.getCallback(() => this.closeToast(component)), 3000); //Auto close custom toast message
        }
    },
    closeToast : function(component){ 
               
        var customToast = component.find("customToast");
        $A.util.addClass(customToast,"slds-hide");
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme,"slds-theme--error");
        $A.util.removeClass(toastTheme,"slds-theme--success");
    }, 
    getPicklistOptions:function(component){
          component.set("v.showSpinner",true);
        var action = component.get("c.fetchPicklistOption");
        action.setParams({ flow:component.get("v.flow") });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
             debugger;
            var state = response.getState();
            component.set("v.showSpinner",false);
            if (state === "SUCCESS") {
                component.set("v.variantOpions",response.getReturnValue());
            }
        })
             $A.enqueueAction(action);
    },
	 //US:24037 USERSTORY_Requirement for CA Cards start 
     getPicklistOptionsMstatus:function(component){
          component.set("v.showSpinner",true);
        var action = component.get("c.fetchPicklistOptionMStatus");
        action.setParams({ flow:component.get("v.flow") });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
             debugger;
            var state = response.getState();
            component.set("v.showSpinner",false);
            if (state === "SUCCESS") {
                component.set("v.maritalStatusOpions",response.getReturnValue());
            }
        })
             $A.enqueueAction(action);
    },
     //US:24037 USERSTORY_Requirement for CA Cards end
    sendDocument:function(component,lstDocuments,isResend){
         component.set("v.showSpinner",true);
        var action = component.get("c.sendDocumentToSTS");
        action.setParams({ flow:component.get("v.flow"),record:component.get("v.record"),strlstDocuments: JSON.stringify(lstDocuments),appNo:component.get("v.Application_Number")});
        debugger;
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
             debugger;
            var state = response.getState();
            component.set("v.showSpinner",false);
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                 var result= response.getReturnValue();
                if(result.isSuccess){
                    component.set("v.lstDocuments",result.data);
                    if(isResend)
                        this.showToast(component,'Success',"Document send successfully",'success');
                    else     
                        this.showToast(component,'Success',result.msg,'success');
                   
                }
               // else
                   // this.showToast('Error','error',result.msg);
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
    },
    //added for US 17397-USERSTORY_Credit card E-application Standalone sourcing
 
    saveDataCC:function(component){
       
      component.set("v.showSpinner",true);
           if (!$A.util.isEmpty(component.get("v.motherNm")) && !$A.util.isEmpty(component.get("v.fatherNm"))) {
              this.setPOFMLValues(component); 
          }
        var action = component.get("c.saveCCdata");
        action.setParams({record:component.get("v.record")}); 
        action.setCallback(this, function(response) {
             debugger;
            console.log('Callback started');
            var state = response.getState();
            component.set("v.showSpinner",false);
            if (state === "SUCCESS") {
                 
            }else{
                
            }
            });
         $A.enqueueAction(action);
    },
    saveData:function(component){
       component.set("v.showSpinner",true);
       if (!$A.util.isEmpty(component.get("v.motherNm")) && !$A.util.isEmpty(component.get("v.fatherNm"))) {//US : 2702
        if (component.get("v.flow")=="PO") {
            this.setPOFMLValues(component);
        } else {
            this.setLAFMLValues(component);
        }
       }//US : 2702
        var action = component.get("c.saveOrApply");
        //action.setParams({flow:component.get("v.flow"), record:component.get("v.record") , strlstDocuments:JSON.stringify(component.get("v.lstDocuments"))});
        action.setParams({flow:component.get("v.flow"), record:component.get("v.record") , strlstDocuments:JSON.stringify(component.get("v.lstDocuments")), val:JSON.stringify(component.get("v.conObj"))});//US : 2702
       console.log('savedata -->');
        action.setCallback(this, function(response) {
             debugger;
            var state = response.getState();
            component.set("v.showSpinner",false);
            if (state === "SUCCESS") {
                var result= response.getReturnValue()
                if(result.isSuccess){
                    //if(!component.get("v.Customer_Interest__c") ||component.get("v.Customer_Interest__c")=='No')
                    if(!component.get("v.Customer_Interest__c") )//US : 2702 ||component.get("v.Customer_Interest__c")=='No'
                         this.showToast(component,'Success',"Details saved successfully",'success');
                    else {
                        debugger;// removed from below '&& component.get("v.flow")=="PO"'
                        console.log('component.get("v.flow")'+component.get("v.flow"));
                        if((component.get("v.CC_Disposition__c") == 'Bundled' && component.get("v.flow")=="PO")||  component.get("v.flow")!="PO" )//this.CheckDocReceived(component)
                        { 
                            this.showToast(component,'Success',result.msg,'success');
                            var timetocolse=200;
                            if(component.get("v.isDSS") == 'true'){
                                timetocolse=500;
                            }
                            window.setTimeout(
                                $A.getCallback(function() {
                                    component.set("v.isOpen",false);
                                }), timetocolse
                            );
                            
                        }
                        else{
                             component.set("v.isConfirmOpen",true); 
                            }
                        }
                        //US : 2702
                        var cmpEvent = $A.get("e.c:ShareParentalData");
                        debugger;
                        if (component.get("v.flow")=="PO" && !$A.util.isEmpty(cmpEvent)) {
                            var data = new Object();
                            var rec = component.get("v.record");
                            console.log('rec --> ', rec);
                            if (!$A.util.isEmpty(rec) && !$A.util.isEmpty(rec.Lead__r)) {
                                if (!$A.util.isEmpty(rec.Lead__r.Mother_First_Name__c)) {
                                    data["Mother_First_Name__c"] = rec.Lead__r.Mother_First_Name__c;
                                }
                                if (!$A.util.isEmpty(rec.Lead__r.Mother_Last_Name__c)) {
                                    data["Mother_Last_Name__c"] = rec.Lead__r.Mother_Last_Name__c;
                                }
                                if (!$A.util.isEmpty(rec.Lead__r.Mother_Middle_Name__c)) {
                                    data["Mother_Middle_Name__c"] = rec.Lead__r.Mother_Middle_Name__c;
                                }
                                if (!$A.util.isEmpty(rec.Lead__r.Father_Spouse_First_Name__c)) {
                                    data["Father_Spouse_First_Name__c"] = rec.Lead__r.Father_Spouse_First_Name__c;
                                }
                                if (!$A.util.isEmpty(rec.Lead__r.Father_Spouse_Last_Name__c)) {
                                    data["Father_Spouse_Last_Name__c"] = rec.Lead__r.Father_Spouse_Last_Name__c;
                                }
                                if (!$A.util.isEmpty(rec.Lead__r.Father_Spouse_Middle_Name__c)) {
                                    data["Father_Spouse_Middle_Name__c"] = rec.Lead__r.Father_Spouse_Middle_Name__c;
                                }
                                console.log('data --> ' , data);
                                cmpEvent.setParams({"ccParentalData" : data});
                                debugger;
                                cmpEvent.fire();
                            }
                        }
                        var cmpEvent1 = $A.get("e.c:CC_Data");
                        if (!$A.util.isEmpty(cmpEvent1)) {
                            console.log('data --> ' , component.get("v.CC_Disposition__c"));
                            cmpEvent1.setParams({"ccData" : component.get("v.CC_Disposition__c")});
                            debugger;
                            cmpEvent1.fire();
                        }
                }
                else
                     this.showToast(component,'Error',result.msg,'error');
                
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
    },
    sendCCRequestToSTS : function (component) {
        component.set("v.showSpinner",true);
		var action = component.get("c.ccCreationRequestSTS");
            action.setParams({identifier: component.get("v.flow"),recordId:component.get("v.recordId")});
		
		// Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
             debugger;
            component.set("v.isOpen",false);
            var state = response.getState();
            component.set("v.showSpinner",false);
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                 var result= response.getReturnValue();
                 if (result.isSuccess) {
                     var data = result.data;
                     if(data.CC_Number__c) {
                        component.set("v.Application_Number", data.CC_Number__c);
                         var button = component.find('applyButton');
                         if(button != undefined && button != null) button.set('v.disabled',true);
                         this.showToast(component,'Success',result.msg,'success');
                         if(!$A.util.isEmpty(component.get("v.CC_Disposition__c")) && component.get("v.CC_Disposition__c") == 'Only Credit Card')// US : 2702
                             this.sendDocument(component,component.get("v.lstDocuments"));
                         this.SendConfirmSMS(component);   //US:17397 USERSTORY_Credit card E-application Standalone sourcing //Bug 17397
                     }
                 }
                else
                    this.showToast(component,'Error',result.msg,'error');
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
    },
    getDocument:function(component){
        component.set("v.showSpinner",true);
        var action = component.get("c.GetDocumentDetails");
        action.setParams({ strId:component.get("v.recordId") });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
             debugger;
            var state = response.getState();
            component.set("v.showSpinner",false);
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                 var result= response.getReturnValue();
                if(result.isSuccess)
                 component.set("v.lstDocuments",result.data);
    
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
    },
    getCCLimit : function(component){
        component.set("v.showSpinner",true);
        var action = component.get("c.GetCCLimitFromSTS");
        action.setParams({ strId:component.get("v.recordId") });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            component.set("v.showSpinner",false);
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                var result= response.getReturnValue()
                if(result.isSuccess)
                {
                    var record=result.data;
                    var conObj = result.con; //US : 2702
                        component.set("v.record",record);
                    if( component.get("v.flow")=="PO" ){
                        if(record.Product_Offering_Converted__c || record.Opportunity__c)
                            component.set("v.readOnlyMode",true );
                        if(record.Lead__r){
                            //component.set("v.Customer_Interest__c",(record.Lead__r.Customer_Interest__c=='Yes') ? true : false);
                            component.set("v.CC_Disposition__c",record.Lead__r.CC_Disposition__c);/*US : 2702*/
                            component.set("v.CC_Variant__c",record.Credit_Card_Type__c);
								//US:24037 USERSTORY_Requirement for CA Cards start
							 component.set("v.maritalStatus",record.Lead__r.Marital_Status__c);
                            console.log('cc --> ' + component.get("v.CC_Disposition__c"));
                            if(!$A.util.isEmpty(component.get("v.CC_Disposition__c")) && component.get("v.CC_Disposition__c") != 'Not Eligible' && component.get("v.CC_Disposition__c") != 'Not Interested') {
                                component.set("v.Customer_Interest__c", true);
                                debugger;
                            } else {
                                component.set("v.Customer_Interest__c", false);
                                debugger;
                            }
                            if (!$A.util.isEmpty(record.Lead__r.Father_Spouse_First_Name__c) || !$A.util.isEmpty(record.Lead__r.Father_Spouse_Last_Name__c)) {
								    console.log('fathers first name '+record.Lead__r.Father_Spouse_First_Name__c);
                                    var FathersName = '';
                                    if(!$A.util.isEmpty(record.Lead__r.Father_Spouse_First_Name__c)){
                                        FathersName = record.Lead__r.Father_Spouse_First_Name__c;
                                    }
                                    if (!$A.util.isEmpty(record.Lead__r.Father_Spouse_Middle_Name__c)){
                                         FathersName = FathersName + ' ' + record.Lead__r.Father_Spouse_Middle_Name__c;
                                    }
                                    if(!$A.util.isEmpty(record.Lead__r.Father_Spouse_Last_Name__c)){
                                        FathersName = FathersName + ' ' + record.Lead__r.Father_Spouse_Last_Name__c;
                                    }
                                    component.set("v.fatherNm",FathersName); 
                            }
                            
                            if (!$A.util.isEmpty(record.Lead__r.Mother_First_Name__c) || !$A.util.isEmpty(record.Lead__r.Mother_Last_Name__c)) {
								    console.log('mothers first name B'+record.Lead__r.Mother_First_Name__c);
                                    var MothersName = '';
                                    if(!$A.util.isEmpty(record.Lead__r.Mother_First_Name__c)){
                                        MothersName = record.Lead__r.Mother_First_Name__c;
                                    }
                                    if (!$A.util.isEmpty(record.Lead__r.Mother_Middle_Name__c)){
                                         MothersName = MothersName + ' ' + record.Lead__r.Mother_Middle_Name__c;
                                    }
                                    if(!$A.util.isEmpty(record.Lead__r.Mother_Last_Name__c)){
                                        MothersName = MothersName + ' ' + record.Lead__r.Mother_Last_Name__c;
                                    }
                                    component.set("v.motherNm",MothersName); 
                            }
                             // US:17397 USERSTORY_Credit card E-application Standalone sourcing start
                           console.log('record.Card_Number__c==>'+record.Card_Number__c);
                            if(!$A.util.isEmpty(record.Card_Number__c))
                            {
                                  component.set("v.AlreadyAccepted",false);
                            }else{
                             if(!$A.util.isEmpty(record.Lead__r.CC_Declaration_Timestamp__c)){
                              
                                if(record.Lead__r.CC_Declaration_Timestamp__c.includes('Accepted')){
                                   
                                    component.set("v.AlreadyAccepted",false);
                                }else{
                                    
                                  component.set("v.AlreadyAccepted",true);  
                                }
                            }
                            }
                            // US:17397 USERSTORY_Credit card E-application Standalone sourcing end
                        }
                        if(record.SOL_Policys__r && record.SOL_Policys__r.length>0)
                        {
                             component.set("v.ccSolRecord",record.SOL_Policys__r[0] );
                            if(record.SOL_Policys__r[0].CC_Number__c)
                             component.set("v.readOnlyMode",true );
                             if(record.SOL_Policys__r[0].CC_Number__c)
                             component.set("v.headerMsg","Application Number : "+ record.SOL_Policys__r[0].CC_Number__c);
                         else
                             component.set("v.headerMsg",result.msg);
                        }
                        else
                            component.set("v.headerMsg",result.msg);
                        // US : 2702
                        console.log('ckycResp --> ', component.get("v.ckycResp"));
                        if (!$A.util.isEmpty(component.get("v.ckycResp"))) {
                            try {
                                var respMap = component.get("v.ckycResp");
                                console.log('mother --> ', respMap["CKYCMotherFullName"]);
                                console.log('father --> ', respMap["CKYCFatherFullName"]);
                                if ($A.util.isEmpty(record.Lead__r.Mother_First_Name__c) && !$A.util.isEmpty(respMap["CKYCMotherFullName"])) {
                                    component.set("v.motherNm",respMap["CKYCMotherFullName"]);
                                }
                                if ($A.util.isEmpty(record.Lead__r.Father_Spouse_First_Name__c) && !$A.util.isEmpty(respMap["CKYCFatherFullName"])) {
                                    component.set("v.fatherNm",respMap["CKYCFatherFullName"]);
                                }
                            } catch (e) {
                                console.log('something wrong in ckyc data /event -->', e);
                            }
                        }
                    }else
                    {
                        if(record.Account){
                            //component.set("v.Customer_Interest__c",(record.Account.Customer_Interest__c=='Yes') ? true : false);
                            console.log('picklist data -->' , component.get("v.ccDisposition"));
                            debugger;
                            console.log('b cc --> ' + record.Account.CC_Disposition__c);
                            component.set("v.tempCCD", record.Account.CC_Disposition__c);
                            component.set("v.CC_Disposition__c",component.get("v.tempCCD"));/*US : 2707*/
                            component.set("v.CC_Variant__c",record.Account.CC_Variant__c);
							//US:24037 USERSTORY_Requirement for CA Cards start
							 component.set("v.maritalStatus",conObj.Marital_Status__c);
                            console.log('a cc --> ' + component.get("v.CC_Disposition__c"));
                            if(!$A.util.isEmpty(component.get("v.CC_Disposition__c")) && component.get("v.CC_Disposition__c") != 'Not Eligible' && component.get("v.CC_Disposition__c") != 'Not Interested') {
                                component.set("v.Customer_Interest__c", true);
                                debugger;
                            } else {
                                component.set("v.Customer_Interest__c", false);
                                debugger;
                            }
                            // Set mothers and fathers name
                            if (!$A.util.isEmpty(result.con)) {
                                component.set("v.conObj", result.con);
                                console.log('conObj --> ', result.con);
                                //conObj = component.get("v.conObj");
                            }
                            if (!$A.util.isEmpty(conObj)) {
                                var FathersName = '';
                                if(!$A.util.isEmpty(conObj.Father_Spouse_First_Name__c)){
                                    FathersName = conObj.Father_Spouse_First_Name__c;
                                }
                                if (!$A.util.isEmpty(conObj.Father_Spouse_Middle_Name__c)){
                                     FathersName = FathersName + ' ' + conObj.Father_Spouse_Middle_Name__c;
                                }
                                if(!$A.util.isEmpty(conObj.Father_Spouse_Last_Name__c)){
                                    FathersName = FathersName + ' ' + conObj.Father_Spouse_Last_Name__c;
                                }
                                component.set("v.fatherNm",FathersName);
                            }
                            if (!$A.util.isEmpty(conObj)) {
                                var MothersName = '';
                                if(!$A.util.isEmpty(conObj.Mother_First_Name__c)){
                                    MothersName = conObj.Mother_First_Name__c;
                                }
                                if (!$A.util.isEmpty(conObj.Mother_Middle_Name__c)){
                                     MothersName = MothersName + ' ' + conObj.Mother_Middle_Name__c;
                                }
                                if(!$A.util.isEmpty(conObj.Mother_Last_Name__c)){
                                    MothersName = MothersName + ' ' + conObj.Mother_Last_Name__c;
                                }
                                component.set("v.motherNm",MothersName);
                            }//component.set("v.Customer_Interest__c",(record.Account.Customer_Interest__c=='Yes') ? true : false);
                            console.log('picklist data -->' , component.get("v.ccDisposition"));
                            debugger;
                            console.log('b cc --> ' + record.Account.CC_Disposition__c);
                            component.set("v.tempCCD", record.Account.CC_Disposition__c);
                            component.set("v.CC_Disposition__c",component.get("v.tempCCD"));/*US : 2707*/
                            component.set("v.CC_Variant__c",record.Account.CC_Variant__c);
                            console.log('a cc --> ' + component.get("v.CC_Disposition__c"));
                            if(!$A.util.isEmpty(component.get("v.CC_Disposition__c")) && component.get("v.CC_Disposition__c") != 'Not Eligible' && component.get("v.CC_Disposition__c") != 'Not Interested') {
                                component.set("v.Customer_Interest__c", true);
                                debugger;
                            } else {
                                component.set("v.Customer_Interest__c", false);
                                debugger;
                            }
                            // Set mothers and fathers name
                            if (!$A.util.isEmpty(result.con)) {
                                component.set("v.conObj", result.con);
                                console.log('conObj --> ', result.con);
                                //conObj = component.get("v.conObj");
                            }
                            if (!$A.util.isEmpty(conObj)) {
                                var FathersName = '';
                                if(!$A.util.isEmpty(conObj.Father_Spouse_First_Name__c)){
                                    FathersName = conObj.Father_Spouse_First_Name__c;
                                }
                                if (!$A.util.isEmpty(conObj.Father_Spouse_Middle_Name__c)){
                                     FathersName = FathersName + ' ' + conObj.Father_Spouse_Middle_Name__c;
                                }
                                if(!$A.util.isEmpty(conObj.Father_Spouse_Last_Name__c)){
                                    FathersName = FathersName + ' ' + conObj.Father_Spouse_Last_Name__c;
                                }
                                component.set("v.fatherNm",FathersName);
                            }
                            if (!$A.util.isEmpty(conObj)) {
                                var MothersName = '';
                                if(!$A.util.isEmpty(conObj.Mother_First_Name__c)){
                                    MothersName = conObj.Mother_First_Name__c;
                                }
                                if (!$A.util.isEmpty(conObj.Mother_Middle_Name__c)){
                                     MothersName = MothersName + ' ' + conObj.Mother_Middle_Name__c;
                                }
                                if(!$A.util.isEmpty(conObj.Mother_Last_Name__c)){
                                    MothersName = MothersName + ' ' + conObj.Mother_Last_Name__c;
                                }
                                component.set("v.motherNm",MothersName);
                            }
                        }
                        if(record.SOL_Policys__r && record.SOL_Policys__r.length>0)
                        {
                             component.set("v.ccSolRecord",record.SOL_Policys__r[0] );
                           if(record.SOL_Policys__r[0].CC_Number__c)
                             component.set("v.readOnlyMode",true )
                             if(record.SOL_Policys__r[0].CC_Number__c)
                             component.set("v.headerMsg","Application Number : "+ record.SOL_Policys__r[0].CC_Number__c);
                         else
                             component.set("v.headerMsg",result.msg);
                        }
                        else
                            component.set("v.headerMsg",result.msg);
                        // US : 2702
                        console.log('ckycResp --> ', component.get("v.ckycResp"));
                        if (!$A.util.isEmpty(component.get("v.ckycResp"))) {
                            try {
                                var respMap = component.get("v.ckycResp");
                                console.log('mother --> ', respMap["CKYCMotherFullName"]);
                                console.log('father --> ', respMap["CKYCFatherFullName"]);
                                if ($A.util.isEmpty(conObj.Mother_First_Name__c) && !$A.util.isEmpty(respMap["CKYCMotherFullName"])) {
                                    component.set("v.motherNm",respMap["CKYCMotherFullName"]);
                                }
                                if ($A.util.isEmpty(conObj.Father_Spouse_First_Name__c) && !$A.util.isEmpty(respMap["CKYCFatherFullName"])) {
                                    component.set("v.fatherNm",respMap["CKYCFatherFullName"]);
                                }
                            } catch (e) {
                                console.log('something wrong in ckyc data /event -->', e);
                            }
                        }
                    }
                       
                   component.set("v.isMCPDedupePassSTS",true);
                     
                }
                else{
                        console.log('error in else of result --> ' , result.msg);
                        component.set("v.showSpinner",true);
                        component.set("v.CC_Disposition__c", 'Not Eligible');/*US : 2702*/
                        try {
                            if (!$A.util.isEmpty(component.get("v.recordId"))) {
                                var action1 = component.get("c.saveNotEligible");
                                action1.setParams({"recordId":component.get("v.recordId") });
                                action1.setCallback(this, function(response) {
                                    debugger;
                                    var state = response.getState();
                                    component.set("v.showSpinner",false);
                                    component.set("v.headerMsg",result.msg);
                                    component.set("v.isMCPDedupePassSTS",false);
                                    var cmpEvent1 = $A.get("e.c:CC_Data");
                        			if (!$A.util.isEmpty(cmpEvent1)) {
                            			console.log('data --> ' , component.get("v.CC_Disposition__c"));
                            			cmpEvent1.setParams({"ccData" : component.get("v.CC_Disposition__c")});
                            			debugger;
                            			cmpEvent1.fire();
                        			}	
                                });
                                $A.enqueueAction(action1);
                            } else {
                                console.log('record Id is blank');
                            }
                        } catch (e) {
                            console.log('error while saving not eligible --> ', e);
                        }
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
    },
       //US:17397 USERSTORY_Credit card E-application Standalone sourcing start
    SendConsentToCustomer: function(component,event,helper){
        console.log('inside send consent to customer helper');
        console.log('**Record**'+component.get("v.record")+' **Record ID**'+component.get("v.recordId"));
        //var rec=component.get("v.record");
        component.set("v.showSpinner",true);
        var action = component.get("c.sendConsentToCustomer");
        action.setParams({ POId:component.get("v.recordId") });
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            component.set("v.showSpinner",false);
            if (state === "SUCCESS") {
                console.log('**Email sent to Customer successfully**');
            	this.showToast(component, "Success!","Email sent to Customer successfully", "Success");
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
    },
    SendConfirmSMS: function(component){
        console.log('inside send CC confirm sms to customer helper');
        console.log('**Record**'+component.get("v.record")+' **Record ID**'+component.get("v.recordId"));
        //var rec=component.get("v.record");
        component.set("v.showSpinner",true);
        var action = component.get("c.SendConfirmSMS");
        action.setParams({ POId:component.get("v.recordId") });
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            component.set("v.showSpinner",false);
            if (state === "SUCCESS") {
                console.log('**SMS sent to Customer successfully**');
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
    },
     //US:17397 USERSTORY_Credit card E-application Standalone sourcing end
    CheckDocuments : function(component){
       var doclst=JSON.parse(JSON.stringify(component.get("v.lstDocuments")));
        for(var doc in doclst)
        {
            /*if(doclst[doc].Upload_Status==false && component.get("v.isDSS")=='false') For Bug 23180 by Rohan*/
            if(doclst[doc].Upload_Status==false)
            {
                   this.showToast(component,'Error','Please Upload all required Documents for Credit Card','error');
               return false;
                
            }
        }
        return true;
    },
       CheckCardLimit : function(component){
      
           var record=component.get("v.record");
          if( component.get("v.flow")=="PO"){
			  if(record && record.Card_limit__c && record.Card_limit__c>0)
                return true;
              else {
			   this.showToast(component,'Error','This Application cannot be processed as Eligible Credit Card Limit is '+record.Card_limit__c+'.','error');              
               return false;
               }  
           }
           else {
               if(record && record.Card_Limit__c && record.Card_Limit__c>0)
               	 return true;
			   else {
			    this.showToast(component,'Error','This Application cannot be processed as Eligible Credit Card Limit is '+record.Card_Limit__c+'.','error');              
                return false;
                }  
           }
            /*if(record && record.Card_limit__c && record.Card_limit__c>0)
                return true;
           else {
			   this.showToast(component,'Error','This Application cannot be processed as Eligible Credit Card Limit is '+record.Card_limit__c+'.','error');              
               return false;
               }*/

    },
    CheckDisposionField:function(component){
        var record= component.get("v.record");
        if(record.Field_Desposition_Status__c && record.Field_Disposition_1__c)
            return true;
        else
        {
         this.showToast(component,'Error','Please select Field Disposition Status to Apply for Credit Card','error');           
            return false;
        }
            
     
    },
    CheckDocReceived:function(component){
          var record= component.get("v.record");
          if(record.Field_Desposition_Status__c==='Docs Received' && record.Field_Disposition_1__c=='Docs Received')
              return true;
          else
              return false;
    },
	
    creditCardClick: function(component) {
        debugger;
        console.log('creditCardClick start isMCPDedupePassSTS', component.get("v.isMCPDedupePassSTS"));/*US : 2702*/
        console.log('start cc disposition -->' + component.get("v.CC_Disposition__c"));
        console.log('cc Customer_Interest__c -->' + component.get("v.Customer_Interest__c"));
        /*US : 2702 start*/
        debugger;
        if (component.get("v.isMCPDedupePassSTS") == false) {
            // set value as Not eligible
            component.set("v.CC_Disposition__c", 'Not Eligible');
            component.set("v.isOpen",true);
            this.getCCLimit(component);
        } else {
            /*US : 2702 end*/
            component.set("v.showResend",true);
            var lapsTime=$A.get("$Label.c.CC_Resend_VisTime");
            window.setInterval(
                $A.getCallback(function() { 
                   component.set("v.showResend",false);
                }), lapsTime*60*1000
            );
            component.set("v.isOpen",true);
            this.getCCLimit(component);
            this.getDocument(component);
        }
        console.log('last cc disposition -->' + component.get("v.CC_Disposition__c"));
        debugger;
    }, 
    cCDPicklistOptions:function(component){
        component.set("v.showSpinner",true);
        var action = component.get("c.fetchCCDPicklistOption");
        action.setParams({ flow:component.get("v.flow") });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
             debugger;
            var state = response.getState();
            component.set("v.showSpinner",false);
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log('data --> ' , data);
                // set cc disposition drop down values, as per identifier we have to set value
                var valToRemove = [];
                if (component.get("v.flow") === "PO") {
                    valToRemove = ['Not Eligible'];
                    // US_16142__CIBIL Validation for Credit Card-Standalone
					if(component.get("v.isValidCibil")===false)
                        valToRemove = ['Not Eligible', 'Only Credit Card'];
					// US_16142__CIBIL Validation for Credit Card-Standalone
                } else {
                    valToRemove = ['Not Eligible', 'Only Credit Card'];
                }
                var filtered = [];
                for (var i = 0; i<data.length; i++) {
                    if (!valToRemove.includes(data[i])) {
                        filtered.push(data[i]);
                    }
                }
                console.log('filtered --> ' , filtered);
                // ccDisposition is list
                // CC_Disposition__c is string
                component.set("v.ccDisposition", filtered);
            }
        })
        $A.enqueueAction(action);
    },
    setPOFMLValues : function(component, event, helper) { //US : 2702
        if (!$A.util.isEmpty(component.get("v.motherNm")) && !$A.util.isEmpty(component.get("v.fatherNm"))) {
            var mn = component.get("v.motherNm");
            var fn = component.get("v.fatherNm");
            var salutation = ['MR', 'MRS', 'MR.', 'MRS.'];
            var mnList = mn.split(' ');
            mnList = salutation.includes(mnList[0]) === true ? mnList.splice(0, 1) : mnList;
            console.log('mnList --> ', mnList);
            var fnList = fn.split(' ');
            fnList = salutation.includes(fnList[0]) === true ? fnList.splice(0, 1) : fnList;
            console.log('fnList --> ', fnList);
            switch (mnList.length) {
                case 0: {
                    console.log('should not come here!');
                    break;
                }
                case 1: {
                    component.set("v.record.Lead__r.Mother_First_Name__c", mnList[0]);
                    break;
                }
                case 2: {
                    component.set("v.record.Lead__r.Mother_First_Name__c", mnList[0]);
                    component.set("v.record.Lead__r.Mother_Last_Name__c", mnList[1]);
                    break;
                }
                case 3: {
                    component.set("v.record.Lead__r.Mother_First_Name__c", mnList[0]);
                    component.set("v.record.Lead__r.Mother_Middle_Name__c", mnList[1]);
                    component.set("v.record.Lead__r.Mother_Last_Name__c", mnList[2]);
                    break;
                }
                default: {
                    component.set("v.record.Lead__r.Mother_First_Name__c", mnList[0]);
                    component.set("v.record.Lead__r.Mother_Last_Name__c", mnList[mnList.length - 1]);
                }
           } // switch
           switch (fnList.length) {
                case 0: {
                    console.log('should not come here!');
                    break;
                }
                case 1: {
                    component.set("v.record.Lead__r.Father_Spouse_First_Name__c", fnList[0]);
                    break;
                }
                case 2: {
                    component.set("v.record.Lead__r.Father_Spouse_First_Name__c", fnList[0]);
                    component.set("v.record.Lead__r.Father_Spouse_Last_Name__c", fnList[1]);
                    break;
                }
                case 3: {
                    component.set("v.record.Lead__r.Father_Spouse_First_Name__c", fnList[0]);
                    component.set("v.record.Lead__r.Father_Spouse_Middle_Name__c", fnList[1]);
                    component.set("v.record.Lead__r.Father_Spouse_Last_Name__c", fnList[2]);
                    break;
                }
                default: {
                    component.set("v.record.Lead__r.Father_Spouse_First_Name__c", fnList[0]);
                    component.set("v.record.Lead__r.Father_Spouse_Last_Name__c", fnList[fnList.length - 1]);
                }
           } // switch
       }
    },
    setLAFMLValues : function(component, event, helper) { //US : 2702
        if (!$A.util.isEmpty(component.get("v.motherNm")) && !$A.util.isEmpty(component.get("v.fatherNm"))) {
            var mn = component.get("v.motherNm");
            var fn = component.get("v.fatherNm");
            var salutation = ['MR', 'MRS', 'MR.', 'MRS.'];
            var mnList = mn.split(' ');
            mnList = salutation.includes(mnList[0]) === true ? mnList.splice(0, 1) : mnList;
            console.log('mnList --> ', mnList);
            var fnList = fn.split(' ');
            fnList = salutation.includes(fnList[0]) === true ? fnList.splice(0, 1) : fnList;
            console.log('fnList --> ', fnList);
            switch (mnList.length) {
                case 0: {
                    console.log('should not come here!');
                    break;
                }
                case 1: {
                    component.set("v.conObj.Mother_First_Name__c", mnList[0]);
                    break;
                }
                case 2: {
                    component.set("v.conObj.Mother_First_Name__c", mnList[0]);
                    component.set("v.conObj.Mother_Last_Name__c", mnList[0]);
                    break;
                }
                case 3: {
                    component.set("v.conObj.Mother_First_Name__c", mnList[0]);
                    component.set("v.conObj.Mother_Middle_Name__c", mnList[1]);
                    component.set("v.conObj.Mother_Last_Name__c", mnList[2]);
                    break;
                }
                default: {
                    component.set("v.conObj.Mother_First_Name__c", mnList[0]);
                    component.set("v.conObj.Mother_Last_Name__c", mnList[mnList.length - 1]);
                }
           } // switch
           switch (fnList.length) {
                case 0: {
                    console.log('should not come here!');
                    break;
                }
                case 1: {
                    component.set("v.conObj.Father_Spouse_First_Name__c", fnList[0]);;
                    break;
                }
                case 2: {
                    component.set("v.conObj.Father_Spouse_First_Name__c", fnList[0]);
                    component.set("v.conObj.Father_Spouse_Last_Name__c", fnList[1]);
                    break;
                }
                case 3: {
                    component.set("v.conObj.Father_Spouse_First_Name__c", fnList[0]);
                    component.set("v.conObj.Father_Spouse_Middle_Name__c", fnList[1]);
                    component.set("v.conObj.Father_Spouse_Last_Name__c", fnList[2]);
                    break;
                }
                default: {
                    component.set("v.conObj.Father_Spouse_First_Name__c", fnList[0]);
                    component.set("v.conObj.Father_Spouse_Last_Name__c", fnList[fnList.length - 1]);
                }
           } // switch
       }
    }
})