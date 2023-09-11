({
    getData : function(component) {
        var lan = component.get("v.LoanId");
        var pName = component.get("v.productName");
         console.log('curreny LAN no -->' , lan);
         console.log('Current product -->' , pName);
        this.executeApex(component, "getNSDLPANdataCloned", {"LoanId" : lan, "productName" : pName}, function(error, result){
            if (result == null) {
                component.set("v.productNotFound", 'fail');
            } else if(!error && result) {
                console.log('success get data -->' , result.length);
                if (result.length > 0) {
                    this.setTableHeight(component, result); // Set table height
                    debugger;
                    console.log(result);
                    component.set("v.wrapperList", result);
                    component.set("v.productNotFound", 'success');
                } else {
                    console.log('here -->');
                    component.set("v.productNotFound", 'fail');
                    console.log('product not found --> ' , component.get("v.productNotFound"));
                }
            }
        });
    },
    getPANCheckStatusData : function(component, event) {
        console.log('inside pan method -->');
        this.executeApex(component, "getPANCheckStatus", {}, function(error, result) {
            if(!error && result){
                console.log('result -->' + result);
                result.splice(0, 0, "Select PAN Check Status");
                component.set('v.panChkStatusValues', result);
                console.log('in status --> ', component.get("v.wrapperList"));
            }
        });
    },
    getCreditObservation : function(component) {
        this.executeApex(component, "getCreditObservation", {}, function(error, result){
            if(!error && result){
                result.splice(0, 0, "Select Credit Observation");
                component.set('v.creditObvValues', result);
            }
        });
    },
    getConsistProfileName: function(component) {
        this.executeApex(component, "consistProfileName", {}, function(error, result){
            if(!error && result){
                console.log('getConsistProfileName --> ' , result);
                component.set('v.isAccessible', result);
            }
        });
    },
    invokeNsdlApi: function(component, data, label, cmpId) {
        // invoke apex method
        var responseString = new Array();
        this.executeApex(component, "validatePan", {"appDetailsString": JSON.stringify(component.get("v.wrapperList"))}, function(error, result) {
            if(!error && result) {
                console.log('invokeNsdlApi result --> ' + result);
                if (result != ''  && result.length > 0) {
                    component.set('v.tatList', result);
                    var tatRecords = component.get('v.tatList');
                    var timeOutLabel = $A.get("$Label.c.NSDL_TIMEOUT_INT_SECS");
                    for (var i=0; i < tatRecords.length; i++) {
                        // invoke actual wsdl method
                        this.setTimeout(this.showSpinner, this, 1, component);
                        this.setTimeout(this.calloutSyncM, this, timeOutLabel, component, i);
                   }
                } // if ends
                else {
                    // show toast message about no single pan qualified for validation
                    this.hideSpinner(component);
					if(component.get("v.isMobilityFlag") == true)
						this.displayToastMessage(component,event,'Message!','No Records found for validation!','success');
					else
						this.showToast(component, "Message!", 'No Records found for validation!', "success");
                }
            } else {
                // check if toast required here too
            }
        });
    },
    calloutSyncM: function(component, i) {
        var responseString = new Array();
        component.set("v.tatReponseString", responseString);
        var tatRecords = component.get('v.tatList');
        var d = new Date();
        console.log('i --> ' + i + ' pan --> ' + tatRecords[i].PAN_Number__c + ' time --> ' + d);
        this.executeApex(component, "calloutSync", {"panNumber": tatRecords[i].PAN_Number__c , "product": component.get("v.productName")}, function(error, result) {
            //this.showSpinner(component);
           try { 
			if(result != null && result != '' && !error && result) {
                //var dd = new Date();
                console.log('result -->' + result);
                console.log('result.status -->', result.status);
                console.log('while component.get("v.tatReponseString") --> ', component.get("v.tatReponseString"));
                if (component.get("v.tatReponseString").length > 0) {
                    responseString = component.get("v.tatReponseString");
                }
                console.log('calloutSyncM --> ' , result);
                responseString.push(result);
                component.set("v.tatReponseString", responseString);
                console.log('tatRecords --> ', tatRecords.length);
                console.log('component.get("v.tatReponseString") --> ', component.get("v.tatReponseString").length);
                if (tatRecords.length == responseString.length) {
                    //debugger;
                    //this.hideSpinner(component);
                    console.log('inside if --> ', responseString);
                    //debugger;
                    console.log('final values --> ', component.get("v.tatReponseString"));
                    try {
                        this.showSpinner(component);
                        this.parseStringResponse(component, component.get("v.tatReponseString"));
                        this.hideSpinner(component);
                    } catch (err) {
                        console.log(err);
                        this.hideSpinner(component);
                    }
                    //debugger;
                }
            }
			else
			{
				   result = tatRecords[i].PAN_Number__c+'^^^^^Details could not be fetched';
				   responseString.push(result);
				   component.set("v.tatReponseString", responseString);
				   this.parseStringResponse(component, component.get("v.tatReponseString"));
				   this.hideSpinner(component);
			}
		}
		catch (err) {
                        console.log(err);
                        this.hideSpinner(component);
                    }
		
        });
    },
    setTimeout: function(callback, context, time, component, i){
        window.setTimeout(
            $A.getCallback(function(){
                if(!component || component.isValid()){
                    callback.call(context || this, component, i);
                }
            }), time
        );
        //debugger;
    },
    parseStringResponse: function(component, responseString) {
        console.log(' parseStringResponse here -->');
       //   console.log('splitResult --> ' + $A.localizationService.formatDate("11-AUG-17", "YYYY-MM-DD"));
        var splitResult = '';
        var appDetailsList = component.get("v.wrapperList");
        var tatRecords = component.get('v.tatList');
        var tatMasterRecords = [];
        for (var i = 0; i < appDetailsList.length; i++) {
            for(var j = 0; j < appDetailsList[i].tatMasterInstance.length; j++) {
                for(var k = 0; k < responseString.length; k++) {
                    splitResult = responseString[k].split('^');
                  //  console.log('splitResult --> ' + $A.localizationService.formatDate('11-AUG-17', "YYYY-MM-DD"));
                    if (splitResult.length > 1) {
                        if (appDetailsList[i].tatMasterInstance[j].PAN_Number__c === splitResult[0]) { // Match PAN Number and populate the values
                            /*if (
                                (splitResult[1] != 'null' && splitResult[1] != '') && 
                                (splitResult[2] != 'null' && splitResult[2] != '') && 
                                (splitResult[3] != 'null' && splitResult[3] != '')
                            ) {
                                appDetailsList[i].tatMasterInstance[j].Name__c = splitResult[1] + ' ' + splitResult[2] + ' ' + splitResult[3];
                            }*/
							if (splitResult[1] == 'null')  splitResult[1] = '';
							if (splitResult[2] == 'null')  splitResult[2] = '';
                            if (splitResult[3] == 'null')  splitResult[3] = '';
                            appDetailsList[i].tatMasterInstance[j].Name__c = splitResult[1] + ' ' + splitResult[2] + ' ' + splitResult[3];
                            if (splitResult[4] != 'null' && splitResult[4] != '') {
                               //debugger; code by amar bagal start
                                var strDate = splitResult[4].split('-');
                                var mnth = strDate[1];
                               if (strDate[1] == 'JAN')
                                  mnth = '01';
                                 else if (strDate[1] == 'FEB')
                               mnth = '02';
                                 else if (strDate[1] == 'MAR')
                               mnth = '03';
                                else if (strDate[1] == 'APR')
                               mnth = '04';
                                else if (strDate[1] == 'MAY')
                               mnth = '05';
                                else if (strDate[1] == 'JUN')
                               mnth = '06';
                                else if (strDate[1] == 'JUL')
                               mnth = '07';
                                else if (strDate[1] == 'AUG')
                               mnth = '08';
                                else if (strDate[1] == 'SEP')
                               mnth = '09';
                                else if (strDate[1] == 'OCT')
                               mnth = '10';
                                else if (strDate[1] == 'NOV')
                               mnth = '11';
                                else if (strDate[1] == 'DEC')
                               mnth = '12';
                                
                                var today =  mnth +'/'+ strDate[0] + '/' + '20'+strDate[2];
                                //debugger; code by amar bagal end
                                component.set("v.dateStr", $A.localizationService.formatDate(today, "MM/DD/YYYY")); //8/11/2017
                                console.log('setMonthValue --> ', component.get("v.dateStr"));
                                appDetailsList[i].tatMasterInstance[j].Last_Modified_Date__c = component.get("v.dateStr");
                            }
                            appDetailsList[i].tatMasterInstance[j].PAN_Check_Status__c = this.ruleCondition(splitResult);
                            if (appDetailsList[i].tatMasterInstance[j].PAN_Check_Status__c == 'Existing and Valid') {
                                appDetailsList[i].tatMasterInstance[j].NSDL_Response__c = 'Success';
                            } else {
                                appDetailsList[i].tatMasterInstance[j].NSDL_Response__c = 'Failure';
                            }
                            tatMasterRecords.push(appDetailsList[i].tatMasterInstance[j]);
                            break;
                        }
                    } else {
                        var flag1 = false;
                        for (var a = 0; a < tatRecords.length; a++) {
                            if (
                                appDetailsList[i].tatMasterInstance[j].Id == tatRecords[a].Id &&
                                tatRecords[a].PAN_Check_Status__c != 'Existing and Valid' &&
                                tatRecords[a].PAN_Check_Status__c != 'Fake PAN' &&
                                tatRecords[a].PAN_Check_Status__c != 'Fake' &&
                                tatRecords[a].PAN_Check_Status__c != 'Not in ITD database'
                            ) {
                                appDetailsList[i].tatMasterInstance[j].PAN_Check_Status__c = 'Details could not be fetched';
                                appDetailsList[i].tatMasterInstance[j].NSDL_Response__c = 'Failure';
                                tatMasterRecords.push(appDetailsList[i].tatMasterInstance[j]);
                                flag1 = true;
                                break;
                            }
                        }
                        if (flag1) break;
                    }
                }
            }
        }
        //debugger;
        console.log('finally appDetailsList -->', appDetailsList);
        console.log('tatMasterRecords --> ', tatMasterRecords);
        //debugger;
        component.set("v.tatList", tatMasterRecords);
        //debugger;
        component.set("v.wrapperList", appDetailsList);
        console.log('tatlist final --> ', component.get("v.tatList"));
        try {
        this.executeApex(component, "saveDetails", {"tatMasterList" : component.get("v.tatList")}, function(error, result){
            //debugger;
            if(!error && result) {
                var tatValues = component.get("v.tatList");
                console.log('in tatValues --> ', tatValues);
                for(var i = 0; i < tatValues.length; i++) {
                    console.log('auraId id -->', tatValues[i].Id);
                    console.log('auraId PCS -->', tatValues[i].PAN_Check_Status__c);
                    if (tatValues[i].PAN_Check_Status__c != 'Details could not be fetched') {
                        // disable the field
                        console.log('inside if -->');
                        $A.util.addClass(document.getElementById(tatValues[i].Id), 'disable');
                    }
                }
				if(component.get("v.isMobilityFlag") == true)
                	this.displayToastMessage(component,event,'Success','Details saved successfully.','success');
                else
					this.showToast(component, "success!", 'Details Saved!', "success");
            } else {
                console.log('save details --> ' , err);
            }
        });
        } catch(err) {
            //debugger;
            console.log('save details --> ' , err);
        }
    },
    executeApex: function(component, method, params, callback){
       //debugger;
        var action = component.get("c."+method); 
        action.setParams(params);
        try {
            action.setCallback(this, function(response) {
                var state1 = response.getState();
                console.log('state1 --> ', state1);
                if(state1 === "SUCCESS"){
                    console.log('response.getReturnValue() --> ' + response.getReturnValue());
                    //debugger;
                    callback.call(this, null, response.getReturnValue());
                    //debugger;
                    //console.log('----------> ' , component.get("v.tatReponseString"));
                } else if(state1 === "ERROR") {
                    var errors = ["Some error occured. Please try again. "];
                    var array = response.getError();
                    for(var i = 0; i < array.length; i++) {
                        var item = array[i];
                        if(item && item.message) {
                            errors.push(item.message);
                        }
                    }
                    console.log('error -->' , errors.join(", "));
                    this.showToast(component, "Error!", errors.join(", "), "error");
                    callback.call(this, errors, response.getReturnValue());
                }
            });
            this.showSpinner(component);
        } catch (errorInstance) {
            alert('Exception --> ' + errorInstance.message + ' stack --> ' + errorInstance.stack);
        }
        $A.enqueueAction(action);
    },
    saveTatMaster: function(component, event) {

        event.preventDefault();
        var datavalues = component.get("v.wrapperList");
        console.log('datavalues -->', datavalues);
        var tatMasterList = [];
        var flag = false;
        for (var i = 0; i< datavalues.length; i++) {
            for(var j = 0; j < datavalues[i].tatMasterInstance.length; j++) {
                tatMasterList.push(datavalues[i].tatMasterInstance[j]);
                //debugger;
                console.log('co --> ' ,datavalues[i].tatMasterInstance[j].Credit_Observation__c);
                if (
                    datavalues[i].tatMasterInstance[j].PAN_Source__c == 'Secondary Cibil' && 
                    (datavalues[i].tatMasterInstance[j].Credit_Observation__c == undefined || datavalues[i].tatMasterInstance[j].Credit_Observation__c == 'Select Credit Observation')
                ) {
                    //debugger;
                    console.log('pan --> ' , datavalues[i].tatMasterInstance[j].PAN_Number__c);
                    console.log('ele -->' , document.getElementById(datavalues[i].tatMasterInstance[j].PAN_Number__c));
                    $A.util.addClass(document.getElementById(datavalues[i].tatMasterInstance[j].PAN_Number__c), 'slds-show');
                    $A.util.removeClass(document.getElementById(datavalues[i].tatMasterInstance[j].PAN_Number__c), 'slds-hide');
                    flag = true;
                } else {
                    $A.util.removeClass(document.getElementById(datavalues[i].tatMasterInstance[j].PAN_Number__c), 'slds-show');
                    $A.util.addClass(document.getElementById(datavalues[i].tatMasterInstance[j].PAN_Number__c), 'slds-hide');
                }
            }
        }
        if (flag) {
            this.hideSpinner(component);
            return;
        }
        console.log('tatMasterList -->', tatMasterList);
        debugger;
        component.set("v.tatList", tatMasterList);
        console.log('tatMasterList comp -->', component.get("v.tatList"));

        this.executeApex(component, "saveDetails", {"tatMasterList" : component.get("v.tatList")}, function(error, result){
            if(!error && result){
                    var tatValues = component.get("v.tatList");
                    console.log('in tatValues --> ', tatValues);
                    for(var i = 0; i < tatValues.length; i++) {
                        console.log('auraId id -->', tatValues[i].Id);
                        console.log('auraId PCS -->', tatValues[i].PAN_Check_Status__c);
                        if (tatValues[i].PAN_Check_Status__c != 'Details could not be fetched') {
                            // disable the field
                            console.log('inside if -->');
                            $A.util.addClass(document.getElementById(tatValues[i].Id), 'disable');
                        }
                    }
                //}
                this.hideSpinner(component);
				if(component.get("v.isMobilityFlag") == true)
                	this.displayToastMessage(component,event,'Success','Details saved successfully.','success');
                else
                this.showToast(component, "success!", 'Details Saved!', "success");
            }
        });
    },
    ruleCondition: function(splitResult) {
        if (splitResult[5] === 'Existing and Valid') {
            return 'Existing and Valid';
        } /*else if (splitResult[5] === 'PAN – Active DOB – Different') { Commented as No rule on same
            return '';
        }*/ else if (splitResult[5] === 'Fake PAN' || splitResult[5] === 'Fake') {
            return 'Fake PAN';
        } else if (splitResult[5] === 'Not in ITD database') {
           return 'Not in ITD database';
        } /*else if (splitResult[5] === 'Input PAN No Not Updated') { Pan number will never be blank ideally
           return '';
        }*/ else {
            return 'Details could not be fetched';
        }
    },
    closeToast: function(component) {
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme, "slds-theme--error");
        $A.util.removeClass(toastTheme, "slds-theme--success");
        this.showHideDiv(component, "customToast", false);
    },
    showToast: function(component, title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({ 
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "30000"
            });    
            toastEvent.fire();
        } else {
            var toastTheme = component.find("toastTheme");
            $A.util.removeClass(toastTheme, "slds-theme--error");
            $A.util.removeClass(toastTheme, "slds-theme--success");
            if(type == 'error'){
                $A.util.addClass(toastTheme, "slds-theme--error");
            } else if(type == 'success'){
                $A.util.addClass(toastTheme, "slds-theme--success");
            }
            component.find("toastText").set("v.value", message);
            component.find("toastTtitle").set("v.value", title+' ');
            this.showHideDiv(component, "customToast", true);
        } 
    },
    showHideDiv: function(component, divId, show){
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
    showSpinner: function(component){
        this.showHideDiv(component, "waiting", true);
    },
    hideSpinner: function(component){
        this.showHideDiv(component, "waiting", false);
    },
    setTableHeight : function(component, dataList) {
        try {
            var count = 0;
            for (var i=0; i<dataList.length;i++) {
                count = count + dataList[i].tatMasterInstance.length;
            }
            console.log('count --> ' , count);

            // Default height for single row of table
            var CalculatedHeight = 60;
            // Get DefaultRecords count which indicates maximum rows after which table becomes scrollable
            var DefaultRecords = 1;
             
            if(count > DefaultRecords) {
                // If number of rows are more than DefaultRecords then height of table is 300px
                CalculatedHeight = 350;
            } else {
                // If number of rows are less than DefaultRecords then height of table is calculated as per formula given below
                CalculatedHeight = CalculatedHeight * (dataList.length + 1); // One is added in ObjectList length for column headers
            }
            component.set("v.CalculatedHeight", CalculatedHeight);    
        } catch(err) {
            console.debug("Error in setTableHeight --> " + err.message + " stack --> " + err.stack);
        }    
    },
    displayToastMessage:function(component,event,title,message,type)
    {
        console.log('inside displayToastMessage'+message+type);
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    },
})