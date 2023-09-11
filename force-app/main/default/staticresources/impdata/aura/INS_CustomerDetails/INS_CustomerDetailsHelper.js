({
    loadCustData : function(component, event, helper) {
        console.log('INSCustomerDetails INIT');
        var params = component.get("v.objParam");
        component.set("v.isSpinner",true);
        console.log('Params::' + JSON.stringify(component.get("v.objParam")));
        this.setTabOnLoad(component, event, helper);
        this.executeApex(component, "loadInsData", {
            "objParam":JSON.stringify(component.get("v.objParam"))
            
        }, function(error, result){
            if(!error && result){
                console.log('Customer Detail Result ***' + JSON.stringify(result.insWalletList));
                component.set("v.customerWrp",result);
                if(result.CustRec){
                    component.set("v.customerRec", result.CustRec);
                    component.set("v.insWalletList", result.insWalletList);
					this.setRecs(component,event,helper, result.insWalletList);
					component.set("v.mapProdNameIPM", result.mapProdNameAndIPMObj);
					console.log("mapProdNameIPM: "+JSON.stringify(component.get("v.mapProdNameIPM")));
                    if(result.custIntList){
                        this.setInteractionDetails(component,event,helper);
                        /*
                        for(var i=0; i<result.custIntList.length;i++){
                            result.custIntList[i].CreatedDate = this.dateTimeStrToDateStr(result.custIntList[i].CreatedDate);
                        }
                        component.set("v.interactionLst", result.custIntList);
                        */
                    }
                    //Set Preferred Communication Address 
                    if(component.get("v.customerRec") && component.get("v.selTabId") == "1"){
                        console.log("CAME FOR RADIO!");
                        var custRec =  component.get("v.customerRec");
                        if(custRec.Preferred_Communication_Address_1__c)
                            component.find("idResRadio").set("v.value",true);
                        else if(custRec.Preferred_Communication_Address__c)
                            component.find("idOffRadio").set("v.value",true);
                     }
                    //this.setLoanDetails(component,event,helper);
                    // this.setInteractionDetails(component,event,helper);
                    component.set("v.isSpinner",false);
                }
                
                else{
                    //Set Fmaily record
                }
                //Set Picklist Values
                this.setPickVals(component, event, helper, result); 
                //Set Disabled Fields with respect to profile
               this.setProfDisableFields(component,event,helper);
                
            }
            else{
                console.log('ERROR In INS_CustomerDetails' );
                component.set("v.isSpinner",false);
            }
        });
        
    },
    /** Below method disables/enables the fields based on the Profiles**/
    setProfDisableFields: function(component,event,helper){
        var profLbl = $A.get("$Label.c.INS_Branch_Profiles");
        var currentUserProf = component.get("v.customerWrp.mapWrpData.LoggedInUserProfile");
        console.log('profLbl ::' + profLbl);
        if(profLbl){
            var profArr = profLbl.split(';');
            console.log('profArr ::' + profArr);
            if(profArr.indexOf(currentUserProf) > -1){
                component.set("v.profDisableFlag",true);
            }
        }
        
        //console.log( 'CurrentUSer ::'+ JSON.stringify($A.get("$SObjectType.CurrentUser")));

    },
    /** Belwo method sets the diff types of Loan Lists **/
    setLoanDetails:function(component,event,helper){
        var loanList = component.get("v.customerRec.Loans__r");
        console.log('loanList ::' + JSON.stringify(loanList));
        var bajajLoans = [];
        var otherLoans = [];
        
        if(loanList){
            for(var i=0; i<loanList.length;i++){
                if(loanList[i].Lender_Name__c && loanList[i].Lender_Name__c.toUpperCase() == 'BAJAJ'){
                    bajajLoans.push(loanList[i]);
                }else{
                    otherLoans.push(loanList[i]);
                }
            }
    	}
        //console.log('bajajLoans ::' + JSON.stringify(bajajLoans));
		//console.log('otherLoans ::' + JSON.stringify(otherLoans));        
        component.set("v.BajajLoanLst",bajajLoans);
        component.set("v.OtherLoanLst",otherLoans);
    },
    
    /** Below method sets the sepecific tabs on page load**/
    setTabOnLoad: function(component, event, helper){
        var params = component.get("v.objParam");
        var tabId =  params.tabId.split('_')[1];
        if(tabId == 'prof')
            component.set("v.selTabId","1");
        else if(tabId == 'intr')
            component.set("v.selTabId","2");
        else
            component.set("v.selTabId","3");
    },
    setTabDataHelper: function(component,event,helper){
        var tabIndex = event.getSource().getLocalId();
        console.log('tabIndex ::' + tabIndex);
        component.set("v.tabIndex",tabIndex);
    },
    toggleAccordion : function(component,event,helper) {
    
        var targetId= event.target.getAttribute('id'); 
        console.log('TargetId : '+ targetId);
        var tabIndex = component.get("v.tabIndex");
		if(tabIndex == "1"){
        
			if(targetId=="subname1" || targetId=="subicon1" || targetId=="subsection1"){
				this.showHideSubSection(component,"subicon1","subsection1Content",4)
			}else if(targetId=="subname2" || targetId=="subicon2" || targetId=="subsection2"){
				this.showHideSubSection(component,"subicon2","subsection2Content",4)
			}else if(targetId=="subname3" || targetId=="subicon3" || targetId=="subsection3"){
				this.showHideSubSection(component,"subicon3","subsection3Content",4)
				//this.callBureauApi(component,event, helper);
			}else if(targetId=="subname4" || targetId=="subicon4" || targetId=="subsection4"){
				this.showHideSubSection(component,"subicon4","subsection4Content",4)
			}
		}
		else if(tabIndex == "2"){
			if(targetId=="subname1_int" || targetId=="subicon1_int" || targetId=="subsection1_int"){
				this.showHideSubSection(component,"subicon1_int","subsection1Content_int",2)
			}else if(targetId=="subname2_int" || targetId=="subicon2_int" || targetId=="subsection2_int"){
				this.showHideSubSection(component,"subicon2_int","subsection2Content_int",2)
			}
		}
	},
    showHideSubSection: function(component,iconId,sectionId,length){
        var i, section, icon;
		var tabIndex = component.get("v.tabIndex");
        for(i=1 ; i<=length ; i++){
            console.log('i = '+i);
            
			if(tabIndex == "1"){
				section = 'subsection'+i+'Content';
				icon = 'subicon'+i;
			}
			else if(tabIndex == "2"){
				section = 'subsection'+i+'Content_int';
				icon = 'subicon'+i+'_int';
			}	
            else if(tabIndex == "3"){
                section = 'subsection'+i+'Content_prod';
                icon = 'subicon'+i+'_prod';
            }
			console.log('icon : '+ icon);
            console.log('section === >> '+section);
            console.log('sectionId === >> '+sectionId);
            if(document.getElementById(icon)){
				if(icon == iconId){
					var x = document.getElementById(icon).innerHTML;
					if(x =="[-]")
						document.getElementById(icon).innerHTML = "[+]"; 
					else
						document.getElementById(icon).innerHTML = "[-]";    	
				}
				else
					document.getElementById(icon).innerHTML = "[+]";
			}	
			if(document.getElementById(section)){
				if(section == sectionId)
					document.getElementById(section).classList.toggle('slds-hide');
				else
					document.getElementById(section).classList.add('slds-hide');
			}
        }
    },
    getDpndntPklHelper: function(component, event, helper){
        console.log("Selected Disposition: "+component.get("v.selectedDisp"));
        var selectedDisp = component.get("v.selectedDisp");
        var brDispPickVals = component.get("v.brDispPickVals");
        // var lstSubDisposition = [];
        // console.log("selectedDisp: "+selectedDisp);
        // console.log("brDispPickVals: "+JSON.stringify(brDispPickVals[selectedDisp]));
        // console.log("mapDependentPk: "+JSON.stringify(component.get("v.mapDependentPk")[selectedDisp]));
        /*
        brDispPickVals[selectedDisp].forEach(function(brSubDispVal){
            if(component.get("v.mapDependentPk")[selectedDisp].indexOf(brSubDispVal) > -1){
                lstSubDisposition.push(brSubDispVal);
            }
        });
        */
        component.set("v.lstSubDisposition", brDispPickVals[selectedDisp]);
        // component.set("v.lstSubDisposition", component.get("v.mapDependentPk")[selectedDisp]);
        console.log("lstSubDisposition: "+component.get("v.lstSubDisposition"));
    },
    returnBrPickVals : function(component, event, helper){
        var brDispPickVals = {};
        brDispPickVals["Sale"] = ["BALIC product", "FGLI product"];
        brDispPickVals["Appointment"] = ["Meeting (F2F)"];
        //Bug #26232 - Changed Not Contactable to Non Contactable
        brDispPickVals["Not Contactable"] = ["Busy", "Disconnected by Customer", "Not reachable", "Switched Off", "Wrong number"];
        brDispPickVals["Not Interested"] = ["Already have policy", "Do not call", "Financial problem", "Insured by employer", "Interested in other product", "Service issues with BFL", "Service issues with insurance partner"];
        brDispPickVals["Follow Up"] = ["Telephonic", "Meeting"];
        // brDispPickVals.dispVals = ["Sale", "Appointment", "Not Contactable", "Not Interested", "Follow Up"];
        // brDispPickVals.subDispVals = [["Issuance pending", "Issued"], ["Meeting"], ["Busy", "Disconnected by Customer", "Not reachable", "Switched Off", "Wrong number"], ["Already have policy", "Do not call", "Financial problem", "Insured by employer", "Interested in other product", "Service issues with BFL", "Service issues with insurance partner"], ["Telephonic", "Meeting"]];
        return brDispPickVals;                               
    },
    setPickVals: function(component, event, helper, result){
        var brDispPickVals = this.returnBrPickVals();
        component.set("v.brDispPickVals", brDispPickVals);
        console.log("brDispPickVals "+JSON.stringify(component.get("v.brDispPickVals")));
        if(result.lstTitle)
            component.set("v.lstTitle", result.lstTitle);
        if(result.lstMarStatus)
            component.set("v.lstMaritalStatus", result.lstMarStatus);
        if(result.lstCityRes)
            component.set("v.lstCityRes", result.lstCityRes);
        if(result.lstCityOff)
            component.set("v.lstCityOff", result.lstCityOff);  
        if(result.lstCountryRes)
            component.set("v.lstCountryRes", result.lstCountryRes);  
        if(result.lstCountryOff)
            component.set("v.lstCountryOff", result.lstCountryOff);
        if(result.lstPrefLang)
            component.set("v.lstPrefLang",result.lstPrefLang);
         if(result.lstOccupation)
            component.set("v.lstOccupation",result.lstOccupation);
        if(result.lstDisposition){
            var lstAllDisposition = result.lstDisposition;
            component.set("v.lstAllDisposition", result.lstDisposition);
            var lstDisposition =[];
            Object.keys(component.get("v.brDispPickVals")).forEach(function(brDispPickVal){
                // if(lstAllDisposition.indexOf(brDispPickVal) > -1){
                    lstDisposition.push(brDispPickVal);
                // } 
            });
          
            component.set("v.lstDisposition", lstDisposition);
        }
        
        // if(result.lstDisposition)
        // component.set("v.lstDisposition", Object.keys(component.get("v.brDispPickVals")));
        if(result.lstSubDisposition)
            component.set("v.lstAllSubDisposition", result.lstSubDisposition);
        if(result.lstChannel)
            component.set("v.lstChannel", result.lstChannel);
        if(result.mapDependentPk)
            component.set("v.mapDependentPk", result.mapDependentPk);
        // this.setBrDispVals();
        console.log("lstAllDisposition: "+JSON.stringify(component.get("v.lstAllDisposition")));
    },
    backToMainHelper: function(component,event,helper){
        component.set("v.InsMainFlag", false);
        var calledFrm = component.get("v.objParam.calledFrm");
        console.log('calledFrm ::' + calledFrm);
      
        //Called from Main Cmp
        if(calledFrm == 'MAINCMP' ){
            var compEvent = component.getEvent("INSMainCmpvent");
            var evtParam = {};
            evtParam.MainCmpFlag = true;
            compEvent.setParams({"MainCmpParam" : evtParam });
            compEvent.fire();
        }
        else if(calledFrm == 'NTBCMP' || calledFrm=='CalendarCMP'){
            var compEvent = component.getEvent("INSHomePgEvent");
            var evtParam = {};
            evtParam.homeFlag = true;
            //evtParam.isTileCmpFlag= false;
            compEvent.setParams({"HomeEventParam" : evtParam });
            compEvent.fire();
        }
      
    },
    validateFields: function(component,event,helper, idsTocheck){
        var validIntr = component.find(idsTocheck).reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            console.log('valid ' + JSON.stringify(inputCmp));
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        return validIntr;
    },
    saveDemogDetHelper: function(component,event,helper){
        try{
            var isValidData = true;
            var btnId = event.getSource().getLocalId();
		    var formId;
            
			if(btnId == 'personalDetailsId') {
				formId = 'custDetailForm';
			} else if(btnId == 'addressDetailsId') {
				formId = 'AddrDetailForm';
			} 
			
            isValidData = this.validateFields(component,event,helper,formId);
            console.log('isValidData ::' + isValidData);
            
            //Set Preferred Communication Address
            var custLcl = component.get("v.customerRec");
            var prefAddr = component.get("v.prefAddr");
            if(prefAddr == 'idResRadio'){
                custLcl.Preferred_Communication_Address_1__c = true;
                custLcl.Preferred_Communication_Address__c = false;
            }
            else{
                custLcl.Preferred_Communication_Address_1__c = false;
                custLcl.Preferred_Communication_Address__c = true;
            }
            
            console.log('Rec Customer 1'+ JSON.stringify(component.get("v.customerRec")));
            console.log('Rec Customer 2'+ JSON.stringify(custLcl));
            if(isValidData){
                 component.set("v.isSpinner",true);
                this.executeApex(component, "saveCustDetails", {
                    "recCust":custLcl
                    
                }, function(error, result){
                    if(!error && result){
                        component.set("v.isSpinner",false); 
                        this.showNotification(event,"SuccessToast1","successmsg1","<b>Success!</b>,Record Saved Successfully");	
                        console.log('SAVED REC ::' + JSON.stringify(result));
                        component.set("v.customerRec",result);
                    }
                    else{
                        component.set("v.isSpinner",false); 
                        this.showNotification(event, 'ErrorToast1', 'errormsg1', '<b>Error!</b> Error in Saving Customer Details');
                    }
                });
            }
            
        } catch(err){
            component.set("v.isSpinner",false); 
            this.showNotification(event, 'ErrorToast1', 'errormsg1', '<b>Error!</b> Exception in Saving Customer Details');
        }
       
    },
    /*
    setInteractionDetails: function(component,event,helper){
        try{
            var intList = component.get("v.customerRec.Pipeline_Trackers__r");
            var interactions = [];
            
            if(intList){
                for(var i=0; i<intList.length;i++){
                    intList[i].CreatedDate = this.dateTimeStrToDateStr(intList[i].CreatedDate);
                    // console.log("createdDate type: "+ this.dateTimeStrToDateStr(intList[i].CreatedDate));
                    interactions.push(intList[i]);
                }
            }
            component.set("v.interactionLst",interactions);
            console.log("interactions: "+component.get("v.interactionLst"));
        }
        catch(err){
            console.log("Error in setInteractionDetails: ", err);
        }
    },
    */
    setInteractionDetails: function(component,event,helper){
        try{
            var result = component.get("v.customerWrp");
            for(var i=0; i<result.custIntList.length;i++){
                result.custIntList[i].CreatedDate = this.dateTimeStrToDateStr(result.custIntList[i].CreatedDate);
                if(result.custIntList[i].Events && result.custIntList[i].Events != null){
                    var istStartDateTime = new Date(result.custIntList[i].Events[0].StartDateTime);
					var istEndDateTime = new Date(result.custIntList[i].Events[0].EndDateTime);
                    result.custIntList[i].calendarData = 'From : ' + this.convertJSDateTimeToStringAmPmTime(istStartDateTime) + ', To: ' + this.convertJSDateTimeToStringAmPmTime(istEndDateTime) + ', > ' + result.custIntList[i].Events[0].Description; 
                }
                else
                    result.custIntList[i].calendarData = "No Appointment"; 
            }
            component.set("v.interactionLst", result.custIntList);
            console.log("interactions: "+component.get("v.interactionLst"));
        }
        catch(err){
            console.log("Error in setInteractionDetails: ", err);
        }
    },
    convertJSDateTimeToStringAmPmTime: function(date){
        var hours = date.getHours();
		var minutes = date.getMinutes();
		var ampm = hours >= 12 ? 'pm' : 'am';
		hours = hours % 12;
		hours = hours ? hours : 12; // the hour '0' should be '12'
		minutes = minutes < 10 ? '0' + minutes : minutes;
		var strTime = (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear() + ' ' + hours + ':' + minutes + ' ' + ampm;
		return strTime;
    },
    dateTimeStrToDateStr: function(dtTimeStr){
        try{
            var localDate = new Date(dtTimeStr);
            var localDateStr = localDate.toLocaleString();
            console.log("localDateStr: "+localDateStr);
            var dateStr = localDateStr.split(",")[0];
            var dd = dateStr.split("/")[1].padStart(2, '0');
            var mm = dateStr.split("/")[0].padStart(2, '0');
            var yyyy = dateStr.split("/")[2];
            return dd + '/' + mm + '/' + yyyy;
        }
        catch(err){
            console.log("Error in dateTimeStrToDateStr: "+dateTimeStrToDateStr);
        }
    },
    saveIntHelper: function(component, event, helper){
        try{
        	console.log("INSIDE saveIntHelper!");
            var isValidData = true;
            var btnId = event.getSource().getLocalId();
            var formId;
            var appntFields = this.returnAppFields();
            console.log("location1: "+component.get("v.appStartTime"));
            var appStartTime = component.get("v.appStartTime");
            var appEndTime = component.get("v.appEndTime");
            
            var formattedStartDate = $A.localizationService.formatDate(appStartTime, "yyyy-MM-ddTHH:mm:ss");
            var formattedEndDate = $A.localizationService.formatDate(appEndTime, "yyyy-MM-ddTHH:mm:ss");
            console.log("formattedStartDate: "+formattedStartDate);
            
            var isValidAppDate = true;
            if(!component.get("v.shwMeetInp")){
                for(var i = 0; i< appntFields.length; i++){
                    // console.log("appntFields: "+component.get(appntFields[i]));
                    component.set(appntFields[i], "");
                }
            }else{
                isValidAppDate = this.validateAppDate(component, event, helper, appStartTime, appEndTime);
            }
            console.log("location2: "+component.get("v.appStartTime"));
            if(btnId == 'intDetailsId') {
                formId = 'intDetailForm';
            }
            if(formId){
            	isValidData = this.validateFields(component,event,helper,formId);
	            isValidData = isValidData && isValidAppDate;
            }
            console.log('INSIDE saveIntHelper isValidData: ' + isValidData);
            // console.log('Rec Customer'+ JSON.stringify(component.get("v.customerRec")));
            if(isValidData){
                console.log("INSIDE saveIntHelper VALID!");
                component.set("v.isSpinner", true);
				var selectedDisp = component.get("v.selectedDisp");
				var currentDate = new Date();
				var currGMTDateTime = currentDate.toISOString();
				var intObj = {};
				intObj.Follow_up_Date__c = currGMTDateTime;
				intObj.CUSTOMER__c = component.get("v.customerRec").Id;
				intObj.FOS_Disposition__c = selectedDisp;
				intObj.FOS_Subdisposition__c = component.get("v.selectedSubDisp");
				intObj.Meeting_Type__c = component.get("v.selectedChannel");
				intObj.Summary__c = component.get("v.comments");
				if(selectedDisp == "Sale"){
					intObj.Insurance_Event_End__c = currGMTDateTime;
				}
				intObj.shwMeetInp = component.get("v.shwMeetInp");
				intObj.Event = {};
				if(intObj.shwMeetInp){
					// intObj.Event.StartDateTime = component.get("v.appStartTime");
					intObj.Event.StartDateTime = formattedStartDate;
					intObj.Event.EndDateTime = formattedEndDate;
					intObj.Event.Location = component.get("v.location");
					intObj.Event.Subject = component.get("v.subject");
                    intObj.Event.Description = component.get("v.selectedDisp") + ' - ' + component.get("v.customerRec").First_Name__c + ' ' + component.get("v.customerRec").Last_Name__c + '/ Contact : ' + component.get("v.customerRec").Mobile__c + '/ @ ' + component.get("v.location") + ' / Subject : ' + component.get("v.subject");
					intObj.Event.WhatId = "Customer Interaction's Id";
					intObj.Event.IsReminderSet = true;
					intObj.Event.ReminderDateTime = currGMTDateTime; 
					intObj.Event.IsVisibleInSelfService = true;
				}
				console.log("intObj: "+JSON.stringify(intObj));
				this.executeApex(component, "insertInteraction", {
                    "intObj": JSON.stringify(intObj)
                }, function(error, result){
                    if(!error && result){
                        component.set("v.isSpinner",false); 
                        this.showNotification(event,"SuccessToast1","successmsg1","<b>Success!</b>,Record Saved Successfully");	
                        // console.log('SAVED REC ::' + JSON.stringify(result));
                        // component.set("v.customerRec",result);
                        this.resetInteraction(component, event, helper);
                        this.showHideSubSection(component,"subicon1_int","subsection1Content_int",2);
                        this.showHideSubSection(component,"subicon2_int","subsection2Content_int",2);
                        var interactionLst = [];
                        if(component.get("v.interactionLst"))
                        	interactionLst = component.get("v.interactionLst");
                        result.CreatedDate = this.getDateInDDMMYYYY(new Date());
                        // console.log("shwMeetInp1: "+component.get("v.shwMeetInp"));
                        // console.log("shwMeetInp2: "+intObj.shwMeetInp);
                        if(intObj.shwMeetInp){
                            var istStartDateTime = new Date(intObj.Event.StartDateTime);
                            var istEndDateTime = new Date(intObj.Event.EndDateTime);
                            result.calendarData = 'From : ' + this.convertJSDateTimeToStringAmPmTime(istStartDateTime) + ', To: ' + this.convertJSDateTimeToStringAmPmTime(istEndDateTime) + ', > ' + intObj.Event.Description; 
                            // console.log("Start Time: "+this.convertJSDateTimeToStringAmPmTime(istStartDateTime));
                            // console.log("Start Time: "+ component.get("v.appStartTime"));
                        }
                        else
                            result.calendarData = "No Appointment";
                        interactionLst.push(result);
                        component.set("v.interactionLst", interactionLst);
                    }
                    else{
                        component.set("v.isSpinner",false); 
                        this.showNotification(event, 'ErrorToast1', 'errormsg1', '<b>Error!</b> Error in Interaction Details');
                    }
                });
            }
            else{
                console.log("INSIDE saveIntHelper INVALID!");
            }    
        }
        catch(err){
            component.set("v.isSpinner",false); 
            console.log("Error: "+err);
            this.showNotification(event, 'ErrorToast1', 'errormsg1', '<b>Error!</b> Exception in Saving Interaction Details!');
        }
        
    },
    getDateInDDMMYYYY: function(date){
        // var today = new Date();
        var dd = String(date.getDate()).padStart(2, '0');
        var mm = String(date.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = date.getFullYear();
        
        return dd + '/' + mm + '/' + yyyy;
    },
    validateAppDate: function(component, event, helper, appStartTime, appEndTime){
        try{
            var isValid = true;
            var currentDate = new Date();
			var currGMTDateTime = currentDate.toISOString();
            console.log("appEndTime: "+appEndTime+" appStartTime: "+appStartTime+" currGMTDateTime: "+currGMTDateTime);
            if(appStartTime && appEndTime){
                if(this.isEarlierDate(appStartTime, currGMTDateTime)){
                    console.log("Appoint Start Date/ Time eariler than today!");
                    this.showNotification(event, 'ErrorToast1', 'errormsg1', '<b>Error!</b> Appoint Start Date/ Time eariler than today!');
                    return false;
                }
                else if(this.isEarlierDate(appEndTime, currGMTDateTime)){
                    console.log("Appoint End Date/ Time eariler than today!");
                    this.showNotification(event, 'ErrorToast1', 'errormsg1', '<b>Error!</b> Appoint End Date/ Time eariler than today!');
                    return false;
                }
                else if(this.isEarlierDate(appEndTime, appStartTime)){
                    console.log("Appoint End Date/ Time eariler than Appoint Start Date/ Time!");
                    this.showNotification(event, 'ErrorToast1', 'errormsg1', '<b>Error!</b> Appoint End Date/ Time eariler than Appoint Start Date/ Time!');
                    return false;
                }
            }
            
			return true;
        }
        catch(err){
            console.log("ERROR IN validateAppDate: "+err);
        }
    },
	isEarlierDate: function(dateTime1, dateTime2){
		try{
			var date1 = Date.parse(dateTime1);
			var date2 = Date.parse(dateTime2);
			if(date1 >= date2){
				return false;
			}
			return true;
		}
		catch(err){
			console.log("ERROR IN isEarlierDate: "+err);
		}
	},
    resetInteraction: function(component, event, helper){
        component.set("v.selectedDisp","");
        component.set("v.selectedSubDisp","");
        component.set("v.selectedChannel","");
        component.set("v.comments","");
        component.set("v.appStartTime","");
        component.set("v.appEndTime","");
        component.set("v.location","");
        component.set("v.subject","");
        component.set("v.shwMeetInp", false);
    },
    /*dateString2Date: function(dateString) {
      var dt  = dateString.split(/\-|\s/);
      return new Date(dt.slice(0,3).reverse().join('-') + ' ' + dt[3]);
    },*/
    returnAppFields: function(component, event, helper){
        return ["v.location", "v.appStartTime", "v.appEndTime", "v.subject"];
    },
	setRecs: function(component,event,helper,tempLst){
		//var tempLst = this.getLstOfRec(component,event,helper);
        var pageSize = component.get("v.pageSize");
        var totalRecs = tempLst.length;
        console.log('totalRecs ::' + totalRecs + 'type ::' + typeof totalRecs);
        component.set("v.totalRecords", totalRecs);
        component.set("v.startPage",0);
        component.set("v.currentPage",1);
        component.set("v.endPage",pageSize);
        //var totRec = component.get("v.ListCustomer").length;
        var rem = totalRecs % pageSize;
        if(rem > 0){
            component.set("v.totalPages",Math.floor((totalRecs/pageSize))+1);
        }
        else{
            component.set("v.totalPages",(totalRecs/pageSize));
        }
        var newPoList = [];
        var PaginationList = [];
        for(var i=0; i< pageSize; i++){
            if(tempLst.length > i){
                PaginationList.push(tempLst[i]);    
            }
        }
        console.log('PaginationList: '+PaginationList.length);
        component.set('v.PaginationList', PaginationList);
        
    },
    next : function(component, event, helper){
        var sObjectList = component.get('v.insWalletList');	
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i= end ; i<end+pageSize; i++){
            if(sObjectList.length > i){
                Paginationlist.push(sObjectList[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        // component.set("v.sortAsc",false);
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set("v.currentPage",component.get("v.currentPage")+1);
    },
    
    previous : function(component, event, helper){
		var sObjectList = component.get('v.insWalletList');
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                Paginationlist.push(sObjectList[i]);
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        // component.set("v.sortAsc",false);
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set("v.currentPage",component.get("v.currentPage")-1);
    },
	sendInsProductDetailsHelper: function(component, event, helper){
		component.set("v.isSpinner",true); 
		var prodNameAndId = event.getSource().get('v.value');
        // console.log('msg: '+prodNameAndId);
		var insProductName = prodNameAndId.split("|")[0];
		console.log('msg: '+insProductName);
		var stResName = '';
		if(insProductName != null && insProductName !=''){
			if(insProductName.includes('-') ){
				stResName = insProductName.replace(/-/g,'');
				stResName = stResName.replace(/ /g,'');
				stResName = 'PrdBrochure' + stResName;
			}
		}
		console.log('stResName: '+stResName);
		var inputJSON = {"customerID": component.get("v.customerRec").Id,"staticRsrName":stResName,"insWalletId":prodNameAndId.split("|")[1] };
        console.log('inputJSON-->'+JSON.stringify(inputJSON));
		
		this.executeApex(component, "sendInsProductDetailsApex", {
			"jsonInput": JSON.stringify(inputJSON)
		}, function(error, result){
			console.log('result: '+result+" type: "+typeof result);
			if(!error && result){
				component.set("v.isSpinner",false); 
				result = JSON.parse(result);
				console.log('SAVED REC ::' + JSON.stringify(result.status));
				// component.set("v.customerRec",result);
				if (result.status == 'success')
                	this.showNotification(event,"SuccessToast1","successmsg1","<b>Success!</b>, "+result.message);
					// $rootScope.showStatus(resultData.message, "success");
                if(result.status == 'noCustEmailId')
                    this.showNotification(event, 'ErrorToast1', 'errormsg1', '<b>Error!</b> '+result.message);
					// $rootScope.showStatus(resultData.message, "noCustEmailId");
                if(result.status == 'noBrochure')
					this.showNotification(event, 'ErrorToast1', 'errormsg1', '<b>Error!</b> '+result.message);
			}
			else{
				component.set("v.isSpinner",false); 
				this.showNotification(event, 'ErrorToast1', 'errormsg1', '<b>Error!</b> Error in sending email. Please contact Asmita Rajput!');
			}
		});
	},
	getProdFeaturesHelper: function(component, event, helper) {
		var prodNameAndId = event.getSource().get('v.value');
		var insProductName = prodNameAndId.split("|")[0];
        component.set("v.insProductName",insProductName);
		console.log("insProductName: "+insProductName);
		// $A.get('$Resource.SLDSv2') + '/assets/images/avatar1.jpg'
		// ,'Insurance_Product_Features/AgeAgnostic/index.html")
		/*
		var path = $A.get("$Resource.Insurance_Product_Features")+ '/AgeAgnostic/index.html';
		console.log("path: "+path);
		var req = new XMLHttpRequest();
        req.open("GET", path);
        req.addEventListener("load", $A.getCallback(function(result) {
			console.log("result: "+JSON.stringify(result));
            window.open("https://www.w3schools.com");
			// window.open(result);
			// component.set("v.attribute", req.response);
        }));
        req.send(null);
        */
        component.set("v.isModalOpen", true);
                
        window.setTimeout(function(){
            console.log("scrolling to ", component.find("auraid-modal-container").getElement());
            //component.find("auraid-modal-container").getElement().focus({preventScroll:false});
            component.find("auraid-modal-container").getElement().scrollIntoView({ 
                behavior: 'smooth',
                block: 'center'
            });
        }, 100);
        
		// $Resource.Insurance_Product_Features,'Insurance_Product_Features/AgeAgnostic/index.html'
		/*
        var path = $A.get("$Resource.StaticResourceName");
        var req = new XMLHttpRequest();
        req.open("GET", path);
        req.addEventListener("load", $A.getCallback(function() {
            component.set("v.attribute", req.response);
        }));
        req.send(null);
		*/
    },
    //BureauMart Callout
    callBureauApi: function(component, event, helper){
       
		var cust = component.get("v.customerRec");
        console.log('Name :::'+ cust.Name + 'ID::' + cust.Id );
        
        if(!component.get('v.isBureauApiCalled')){
             console.log('INSIDE Bureau API');
            component.set('v.isBureauApiCalled', true);
            this.executeApex(component, "BureaumartCallout1", {
                "customerName":cust.Name,
                "customerId": cust.Id
                
            }, function(error, result){
                console.log('Bureau API reuslt::' + JSON.stringify(result));
                if(!error && result!= null){ 
                    component.set("v.customerRec.Loans__r",result);
                }
               	this.setLoanDetails(component,event,helper);
            });
        }
        
    },
                        
    closeModelCall: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isModalOpen", false);
    },
    showNotification : function(event,toastid,messageid,message) {
        console.log(':::'+toastid+messageid+message);
        var appEvent = $A.get("e.c:InvokeNotificationEVT");
        appEvent.setParams({
            "toastid" : toastid ,
            "messageid" : messageid ,
            "message" : message 	
        });
        appEvent.fire();
    },
    executeApex: function(component, method, params, callback){
		// console.log("executeApex: "+JSON.stringify(method)+" params: "+JSON.stringify(params));
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
			console.log("state: "+state);
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
                //this.showNotification(event,'ErrorToast1', 'errormsg1', '<b>Error!</b>,'+ errors.join(", ") );
                callback.call(this, errors, response.getReturnValue());
                
            }
        });
        $A.enqueueAction(action);
    }

})