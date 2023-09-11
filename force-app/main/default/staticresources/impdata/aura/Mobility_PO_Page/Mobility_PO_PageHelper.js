({
    
    activateTab: function(component, tabId,onstageclick) {
        
        console.log('tabId>>>'+tabId); 
        component.set("v.disablePrev", false); 
        component.set("v.disableNext", false);
        
        $A.util.removeClass(component.find("aadharTab"), "slds-is-current slds-is-active");
        $A.util.removeClass(component.find("poTab"), "slds-is-current slds-is-active");
        $A.util.removeClass(component.find("dispositionTab"), "slds-is-current slds-is-active");
        $A.util.removeClass(component.find("mcpTab"), "slds-is-current slds-is-active");
        
        $A.util.addClass(component.find("aadharTab"), "slds-is-incomplete");
        $A.util.addClass(component.find("poTab"), "slds-is-incomplete");
        $A.util.addClass(component.find("dispositionTab"), "slds-is-incomplete");
        $A.util.addClass(component.find("mcpTab"), "slds-is-incomplete");
        
        $A.util.removeClass(component.find(tabId), "slds-is-incomplete");
        $A.util.addClass(component.find(tabId), "slds-is-current slds-is-active");
        
        this.showHideDiv(component, "aadharTabContent", false);
        this.showHideDiv(component, "poTabContent", false);
        this.showHideDiv(component, "dispositionTabContent", false);
        this.showHideDiv(component, "mcpTabContent", false);
        this.showHideDiv(component, tabId+"Content", true);
        if(onstageclick){ 
            var activepath = component.get("v.activePath");
            var pathList = component.get("v.pathList");
            var currentPos = 1;
            var prevPos = 1;
            var pathscroll = false;
            for(var i=0; i < pathList.length; i++) {
                if(pathList[i] == activepath){
                    prevPos = i+1;
                }
                if(pathList[i] == tabId){
                    currentPos = i+1;
                }
            }
            if(prevPos < currentPos){
                pathscroll = true;
                
                
                
            }
            var scrollContainer = $(".offer-pg-cont");
            var items = $(".slds-path__item");
            //  var item = $(document.getElementById(tabId));
            var item = this.fetchItem(component,scrollContainer, items, pathscroll);
            console.log(item);
            var currentleft = scrollContainer.scrollLeft();
            console.log('currentleft>> prev>>'+currentleft);
            var addleft = item.position().left + scrollContainer.scrollLeft();
            console.log('item.position().left prev>>'+item.position().left);
            console.log('addleft prev>>'+addleft);
            // if(addleft < currentleft){
            scrollContainer.animate({"scrollLeft": item.position().left + scrollContainer.scrollLeft()}, 400);
            //  }
            console.log('prevPos>>'+prevPos+'>>currentPos>>'+currentPos+'>>pathscroll>>'+pathscroll);
        }
        
        component.set("v.activePath", tabId);
        if(tabId == 'aadharTab'){
            component.set("v.disablePrev", true);    
            component.set("v.StageNum",1);
        }
        else if(tabId == 'mcpTab'){
            component.set("v.disableNext", true);   
            component.set("v.StageNum",4);
        }
            else if(tabId == 'poTab'){
                component.set("v.StageNum",2);
            }
                else if(tabId == 'dispositionTab'){
                    component.set("v.StageNum",3);
                }
        
    },
    fetchItem :function(component,container, items, isNext) {
        var i,
            scrollLeft = container.scrollLeft();
        
        //set isNext default to true if not set
        if (isNext === undefined) {
            isNext = true;
        }
        
        if (isNext && container[0].scrollWidth - container.scrollLeft() <= container.outerWidth()) {
            //we reached the last one so return the first one for looping:
            return $(items[0]);
        }
        
        //loop through items
        for (i = 0; i < items.length; i++) {
            
            if (isNext && $(items[i]).position().left > 0) {
                //this item is our next item as it's the first one with non-negative "left" position
                return $(items[i]);
            } else if (!isNext && $(items[i]).position().left >= 0) {
                //this is our previous item as it's the one with the smallest negative "left" position
                //if we're at item 0 just return the last item instead for looping
                return i == 0 ? $(items[items.length - 1]) : $(items[i-1]);
            }
        }
        
        //nothing found
        return null;
    },
    createComponent: function (component, parentcomponent, newcomponentName, parameters) {
        var jsonparameters = {};
        console.log('Inside createcompoent : ');
        if (parameters != null)
            jsonparameters = JSON.parse(parameters);
        //debugger;
        console.log('jsonparameters>>' + jsonparameters);
        $A.createComponent(
            newcomponentName, jsonparameters,
            function (newcomponent, status) {
                console.log('status>>' + status);
                if (status == 'SUCCESS') {
                    var targetCmp = component.find(parentcomponent);
                    var body = targetCmp.get("v.body");
                    body.push(newcomponent);
                    targetCmp.set("v.body", body);
                }
            });
        
    },
    toggleAccordion: function (component, event) {
        
        var targetId = event.target.getAttribute('id');
        if (targetId) {
            var targetNo = targetId.substr(targetId.length - 1);
            var showSection = true;
            console.log('v.sectionContent : ' + component.get('v.sectionContent' + targetNo));
            console.log('TargetId : ' + targetId);
            showSection = component.get('v.sectionContent' + targetNo);
            
            if (targetId == "name2" || targetId == "icon2" || targetId == "section2") {
                if (showSection === true) {
                    var leaddata = component.get("v.lead");
                    if (leaddata) {
                        console.log('leaddata :' + JSON.stringify(leaddata));
                        
                        // this.createComponent(component,"section2Content","c:section2", '{ lead : '+ JSON.stringify(leaddata) + ' }');
                        component.set('v.sectionContent' + targetNo, "false");
                    }
                }
            } else if (targetId == "name3" || targetId == "icon3" || targetId == "section3") {
                if (showSection === true) {
                    //  this.createComponent(component,"section3Content",'c:section3','{}');
                    component.set('v.sectionContent' + targetNo, "false");
                }
            } else if (targetId == "section4" || targetId == "icon4" || targetId == "name4") {
                if (showSection === true) {
                    //   this.createComponent(component,"section4Content",'c:section4','{}');
                    component.set('v.sectionContent' + targetNo, "false");
                }
            }
            
        }
        this.showHideSection(component, "icon" + targetNo, "section" + targetNo + "Content");
        
    },
    showHideSection: function (component, iconId, sectionId) {
        var i;
        for (i = 1; i < 5; i++) {
            var icon = 'icon' + i;
            var section = 'section' + i + 'Content';
            //console.log('icon : '+ icon);
            if (icon == iconId) {
                var x = document.getElementById(icon).innerHTML;
                if (x == "[-]") {
                    document.getElementById(icon).innerHTML = "[+]";
                    
                } else {
                    document.getElementById(icon).innerHTML = "[-]";
                }
            } else {
                document.getElementById(icon).innerHTML = "[+]";
            }
            if (section == sectionId) {
                $A.util.toggleClass(component.find(section), 'slds-hide');
            } else {
                $A.util.addClass(component.find(section), 'slds-hide');
            }
            
        }
    },
    showHideDiv: function (component, divId, show) {
        //console.log('divId>>' + divId + '  ' + show);
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
        
    },
    validateDisposition: function (component) {
		var fielddisposition = '',telefielddisposition = '';
		if(component.get("v.isTeleCaller") == true)
			telefielddisposition = component.get("v.po.TeleCalling_Desposition_Status__c");
		else /* Adhoc 20275 e added sales condition*/
			fielddisposition = component.get("v.po.Field_Disposition_1__c");
        console.log("fielddisposition validateDisposition>>" + fielddisposition);
		// debugger;
		if (fielddisposition == 'Follow Up' && component.get("v.ismcppass")) {
			//debugger;
        var cmpInstance = component.find("followUpDate");
        console.log(cmpInstance);
        console.log('required>>' + cmpInstance.get("v.required"));
			component.set("v.disableConvert", false);
			} else {
			// debugger;
			var cmpInstance = component.find("followUpDate");
			console.log(cmpInstance);
			console.log('required>>' + cmpInstance.get("v.required"));
			if (((fielddisposition != '' && fielddisposition == 'Sale' || fielddisposition == 'Docs Received' || fielddisposition == 'Followup') && component.get("v.ismcppass")) || (telefielddisposition != '' && (telefielddisposition == 'Sale' || telefielddisposition == 'Follow Up') && component.get("v.ismcppass"))) {
            component.set("v.disableConvert", false);
        } else {
            component.set("v.disableConvert", true);
        }
			console.log(component.get("v.disableConvert"));
		}
        
        if((fielddisposition != '' && fielddisposition == 'Docs Received' || fielddisposition == 'Sale') || (telefielddisposition != '' && telefielddisposition == 'Sale'))
            component.set('v.isSourcingChannelAndApplicationRequired',true);
        else      
            component.set('v.isSourcingChannelAndApplicationRequired',false); 
    },
    validateFollowupDate: function (component,event) {
		var fielddisposition = '';
		if(component.get("v.isTeleCaller") == true)
			fielddisposition = component.get("v.po.TeleCalling_Desposition_Status__c");
		else /* Adhoc 20275 e added sales condition*/
			fielddisposition = component.get("v.po.Field_Disposition_1__c");
        var po = component.get("v.po");
        po.Field_Followup_Date__c = component.find("followUpDate").get('v.value');
        component.set("v.po",po);
        console.log('validateFollowupDate'+component.find("followUpDate").get('v.value'));
        if (fielddisposition == 'Followup' && !po.Field_Followup_Date__c) {
            $A.util.addClass(component.find("followupdiv"), "slds-show");
            // component.find("followUpDate").set("v.errors", [{message: "Please select Follow UP date"}]);
            return true;
        } else {
            console.log('inside else of follow up');
            $A.util.removeClass(component.find("followupdiv"), "slds-show");
            $A.util.addClass(component.find("followupdiv"), "slds-hide");
        }
        //component.find("followUpDate").set("v.errors", [{message: ""}]);
        return false;
    },
    blankFollowupDate: function (component,event) {
		var fielddisposition = '';
		if(component.get("v.isTeleCaller") == true)
			fielddisposition = component.get("v.po.TeleCalling_Desposition_Status__c");
		else /* Adhoc 20275 e added sales condition*/
			fielddisposition = component.get("v.po.Field_Disposition_1__c");
        var followUpDateTime = component.get("v.po.Follow_Up_Date__c");
        console.log('validateFollowupDate'+component.find("followUpDate").get('v.value'));
		if(fielddisposition == 'Followup')
            component.find("followUpDate").set('v.value',followUpDateTime);
        else
        	component.find("followUpDate").set('v.value','');
	},
    startSearch: function (component, key) {
        var keyword = component.get("v." + key + "SearchKeyword");
        console.log("keyword" + keyword);
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
    handleSearchResult: function (component, key, result) {
        console.log('key : ' + key)
        console.log('v.oldSearchKeyword :' + component.get('v.oldSearchKeyword') + '  -> SearchKeyword : ' + component.get("v." + key + "SearchKeyword"));
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
    showHideMessage: function (component, key, show) {
        component.set("v.message", show ? 'No Result Found...' : '');
        this.showHideDiv(component, key + "Message", show);
    },
    openCloseSearchResults: function (component, key, open) {
        var resultPanel = component.find(key + "SearchResult");
        $A.util.addClass(resultPanel, open ? 'slds-is-open' : 'slds-is-close');
        $A.util.removeClass(resultPanel, open ? 'slds-is-close' : 'slds-is-open');
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
                //this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getNewPO: function (component) {
        this.executeApex(component, "getBlankPO", {}, function (error, result) {
            if (!error && result) {
                component.set("v.po", result);
            }
        });
        
    },
    getNewlead: function (component) {
        this.executeApex(component, "getBlankLead", {}, function (error, result) {
            if (!error && result) {
                component.set("v.lead", result);
            }
        });
        
    },
    
    /* Mobility for SAL added by priya start*/
    getPODetails: function (component, poId) {
		var poSelectList = ["Field_Disposition_1__c", "Field_Desposition_Status__c", "Lead_Source__c", "Products__c","TeleCalling_Desposition_Status__c","Tele_Calling_Sub_disposition__c"];
        var leadPickList = ["Gender__c"];
        var selectListNameMap = {};
        selectListNameMap["Product_Offerings__c"] = poSelectList;
        selectListNameMap["Lead"] = leadPickList;
        console.log('selectListNameMap' + selectListNameMap);
        this.executeApex(component, "getPODetails", {
            "poId": poId,
            "objectFieldJSON": JSON.stringify(selectListNameMap)
        }, function (error, result) {
            if (!error && result) {
                var data = JSON.parse(result);
                console.log('data' + JSON.stringify(data));
                console.log('pk'+data.po.Product_Offering_Converted__c);
                var mcpCmp = component.find("mcpComponent");
                /* Adhoc 20275 s */
                if (!$A.util.isEmpty(data.isTeleCaller))
                	component.set("v.isTeleCaller", data.isTeleCaller);
                if (!$A.util.isEmpty(data.isFieldAgent))
                	component.set("v.isFieldAgent", data.isFieldAgent);
               /* Adhoc 20275 e */
                if (!$A.util.isEmpty(data.po) && !$A.util.isEmpty(data.po.Product_Offering_Converted__c) && data.po.Product_Offering_Converted__c != false) {
                    this.disableForm(component);
                    document.getElementById("POFields").classList.add("disabledPOPage");
                    mcpCmp.disableChildForm(component);
                    if(!$A.util.isEmpty(data.po.Opportunity__r) && !$A.util.isEmpty(data.po.Opportunity__r.Loan_Application_Number__c))
                    {
                        console.log('Hi++3'+data.po.Opportunity__r.Loan_Application_Number__c +" -- "+ data.po.Opportunity__r.Id);
                        this.triggerPostConvertEvent(component, data.po.Opportunity__r.Loan_Application_Number__c, data.po.Opportunity__r.Id);    
                    }
                }
                console.log('Hi 1');
                //Rohit 16111 CR S
                if(!$A.util.isEmpty(data) && !$A.util.isEmpty(data.aadharMandatory))
                    component.set("v.isEkycMandatory", data.aadharMandatory);
                if(!$A.util.isEmpty(data) && !$A.util.isEmpty(data.leadEkyc))
                    component.set("v.isEkycdone", data.leadEkyc);
                console.log('rohit '+component.get('v.isEkycMandatory')+'----'+component.get('v.isEkycdone'));
                //Rohit 16111 CR E
                if(!$A.util.isEmpty(data) && !$A.util.isEmpty(data.lead) && !$A.util.isEmpty(data.lead.Employer__r))
                {
                    console.log('employer'+data.lead.Employer__r.Name);
                component.set("v.employerSearchKeyword", data.lead.Employer__r.Name);
                }
                var picklistFields = data.picklistData;
                var poPickFlds = picklistFields["Product_Offerings__c"];
                var leadPickFlds = picklistFields["Lead"];
                console.log('picklistFields00' + data.po);
                component.set("v.dispositionlist", poPickFlds["Field_Disposition_1__c"]);
                //	component.set("v.subdispositionlist", poPickFlds["Field_Desposition_Status__c"]);
				component.set("v.teleCallingList", poPickFlds["TeleCalling_Desposition_Status__c"]);
                component.set("v.teleCallingSubList", poPickFlds["Tele_Calling_Sub_disposition__c"]);
                component.set("v.leadsource", poPickFlds["Lead_Source__c"]);
                component.set("v.productList", poPickFlds["Products__c"]);
                component.set("v.genderList", leadPickFlds["Gender__c"]);
                
                if(!$A.util.isEmpty(data.lead) && !$A.util.isEmpty(data.lead.Customer_Mobile__c)){
                    var mobile_number = component.get("v.mobilenumber");
                    mobile_number = "tel:"+data.lead.Customer_Mobile__c;
                    component.set("v.mobilenumber",mobile_number);
                }
                
                var residenceaddress = '';
                if (!$A.util.isEmpty(data.lead) && !$A.util.isEmpty(data.lead.Residence_Address_Line1__c))
                    residenceaddress = residenceaddress + data.lead.Residence_Address_Line1__c;
                if (!$A.util.isEmpty(data.lead) && !$A.util.isEmpty(data.lead.Residence_Address_Line2__c))
                    residenceaddress = residenceaddress + ' ' + data.lead.Residence_Address_Line2__c;
                if (!$A.util.isEmpty(data.lead) && !$A.util.isEmpty(data.lead.Residence_Address_Line3__c))
                    residenceaddress = residenceaddress + ' ' + data.lead.Residence_Address_Line3__c;
                component.set("v.residenceAddress", residenceaddress);
                
                component.set("v.po", data.po);
                component.set("v.lead", data.lead);
                if (!$A.util.isEmpty(data.scam))
                {
                    var scam = component.get("v.scam");
                    console.log('inside create po'+data.scam.Id+'  '+data.scam.Special_Profile_Employer__c);
                    scam.Id = data.scam.Id;
                    scam.Special_Profile_Employer__c = data.scam.Special_Profile_Employer__c;
                    component.set("v.scam",scam);
                }
                if (!$A.util.isEmpty(data.isCommunityUsr)){
                    component.set('v.iscommunityUser', data.isCommunityUsr);
                }
                this.validateDisposition(component);
                if (!$A.util.isEmpty(data.po) && !$A.util.isEmpty(data.po.Sourcing_Channel__r)) {
                    console.log('data.po.Sourcing_Channel__r.Name' + data.po.Sourcing_Channel__r.Name);
                    component.set("v.sourceSearchKeyword", data.po.Sourcing_Channel__r.Name);
                    console.log('sourcing' + component.get("v.sourceSearchKeyword"));
                }
                if (!$A.util.isEmpty(data.ekycobj)) {
                    component.set("v.kyc", data.ekycobj);
                    console.log('kyc details' + data.ekycobj);
                }
                //console.log('emp name parent>>' + data.lead.Employer__r.Name);
                if(!$A.util.isEmpty(data.lead) && !$A.util.isEmpty(data.lead.Employer__r))
                    mcpCmp.displayEmpData(data.lead.Employer__r.Name, data.lead.Employer__r.Company_Category__c, data.lead.PAN__c, data.po.Product_Offering_Converted__c);
                if(!$A.util.isEmpty(data.lead) && !$A.util.isEmpty(data.lead.PAN__c))
                    mcpCmp.disablePAN(data.lead.PAN__c);
                
                var convertedpo =false;
                if(!$A.util.isEmpty(data.po) && !$A.util.isEmpty(data.po.Product_Offering_Converted__c))
                    convertedpo = data.po.Product_Offering_Converted__c;
                component.set("v.followUpDateTimeForDis", data.po.Follow_Up_Date__c);
                if (!$A.util.isEmpty(data.solpolicy)) {
                    console.log('solpolicy details' + data.solpolicy.Policy_Name__c);
					/* Adhoc 20275 s*/
					var fielddisposition = '',telefielddisposition = '';
					if(component.get("v.isTeleCaller") == true)
						telefielddisposition = component.get("v.po.TeleCalling_Desposition_Status__c");
					else /* Adhoc 20275 e added telefielddisposition condition*/
						fielddisposition = component.get("v.po.Field_Disposition_1__c"); 
					if (((fielddisposition != '' && (fielddisposition == 'Docs Received' || fielddisposition == 'Sale'  || fielddisposition == 'Followup')) || (telefielddisposition != '' && (telefielddisposition == 'Sale' || telefielddisposition == 'Follow Up'))) && !convertedpo)
                        component.set("v.disableConvert", false);
                    component.set("v.ismcppass", true);
                } else {
                    console.log('solpolicy details else');
                    component.set("v.disableConvert", true);
                    component.set("v.ismcppass", false);
                }
				if((fielddisposition != '' && fielddisposition == 'Docs Received' || fielddisposition == 'Sale') || (telefielddisposition != '' && telefielddisposition == 'Sale'))
                    component.set('v.isSourcingChannelAndApplicationRequired',true);
                else      
                    component.set('v.isSourcingChannelAndApplicationRequired',false);
                
				if(component.get("v.isFieldAgent") == true) /* Adhoc 20275*/
                this.populatesubdispoData(component);
            }
        });
        this.hideSpinner(component);
    },
    disableForm: function (component) {
        var list = [
            "firstName", "lastName", "OfferAmount", "cibilNotes", "disposition",
			"followUpDate", "subDisposition","dispoRemarks","teleCallingId","teleCallingSubId"];
        for (var i = 0; i < list.length; i++) {
            console.log('Hello++'+list[i]);
            if (!$A.util.isEmpty(component.find(list[i]))){
                console.log(component.find(list[i]));
            component.find(list[i]).set("v.disabled", true);
        }
				
		}
        var cmpTarget = component.find('followUpDate');
        $A.util.addClass(cmpTarget, 'applybackground');
      //  component.find("subDisposition").set("v.disabled", true);
        
        component.set("v.isdisabled", true);
        component.set("v.disableConvert", true);
        //component.find("saveButtonId").getElement().disabled = true;
        //component.find("convertToLoanButtonId").getElement().disabled = true;
    },
    
    convertToLoanApplication: function (component) {
        console.log('convertToLoanApplication');
        //Rohit 16111 CR added condition S
        
        //if((component.get('v.isEkycMandatory') == true && component.get('v.isEkycdone') == true) || (component.get('v.isEkycMandatory') == false)){
        this.executeApex(component, 'sendToSalesConvert', {
            "flow": 'salaried',
            "poObj": JSON.stringify([component.get("v.po")]),
            "LeadObj": JSON.stringify([component.get("v.lead")])
        }, function (error, result) {
            console.log('convertToLoanApplication error' + error);
            if (!error && result && result.length) {
                if( result.includes(';')){
                    var data = result.split(';');
                    console.log('data>>' + data);
                    component.set("v.loanId", data[1]);
                    component.set("v.theme", data[2]);
                    this.triggerPostConvertEvent(component, data[0], data[1]);
                    this.disableForm(component);
                    var mcpCmp = component.find("mcpComponent");
                    mcpCmp.disableChildForm(component);
                    this.hideSpinner(component);
                    var templateData = ['Salesforce', {
                        url: 'http://www.webkul.com/',
                        label: 'Click Here',
                    }
                                       ];
                    this.displayMessage(component, 'SuccessToast1', 'successmsg1', 'Success!,Converted successfully to LAN :' + data[0], "Click Here");
                    
                    //this.showToast(component, "Success!", "Converted successfully to LAN :" + data[0], "success", "Click Here");
                    
                }
                else if(result == 'failduetopancheck'){
                    this.displayMessage(component, 'ErrorToast', 'errormsg', 'Fail!,We are unable to process your application at this stage due to internal policy norms not met.');
                    component.set("v.ismcppass", false);
                    component.set("v.disableConvert", true);
                    this.hideSpinner(component);
                    
                }
                
            } else {
                this.hideSpinner(component);
                //this.showToast(component, "Error!", "Failed to convert loan application", "error");
                // this.disableForm(component);
                this.displayMessage(component, 'ErrorToast', 'errormsg', '<b>Error!</b>,Failed to convert loan application.');
                console.log('error>>');
            }
            this.hideSpinner(component);
        });
        // }
        /* else{
            this.displayMessage(component, 'ErrorToast', 'errormsg', '<b>Error!</b>,Please initiate Ekyc !');
        }*/
        //Rohit 16111 CR added condition E 
    },
    navigateToOppComponent: function (component, event, helper, loanNumber, loanId) {
        /*  console.log('navigateToOppComponent');
		loanId ='0065D000002KAyf';
		debugger;
		var evt = $A.get("e.force:navigateToComponent");
		evt.setParams({
		componentDef: "c:Opp_DSS_flow",
		componentAttributes: {
		//   "oppId":'0065D000002KAyf'
		}

		});
		evt.fire();*/
    },
    triggerPostConvertEvent: function (component, loanNumber, loanId) {
        var event = $A.get("e.c:LoanConversionEvent");
        event.setParams({
            "loanNumber": loanNumber,
            "loanId": loanId
        });
        event.fire();
    },
    updateLookups: function (component, event) {
        var record = event.getParam('record');
        console.log("record-->" + record.Id);
        var po = component.get("v.po");
        console.log(po);
        po.Sourcing_Channel__c = record.Id;
        component.set("v.po", po);
        console.log(po);
    },
    /* Mobility for SAL added by priya end*/
    showToast: function (component, title, message, type, messagelabel) {
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type": type,
                "mode": "dismissible",
                "duration": "2000"
            });
            toastEvent.fire();
        } else {
            console.log('showToast else');
            var toastTheme = component.find("toastTheme");
            $A.util.removeClass(toastTheme, "slds-theme--error");
            $A.util.removeClass(toastTheme, "slds-theme--success");
            if (type == 'error') {
                $A.util.addClass(toastTheme, "slds-theme--error");
            } else if (type == 'success') {
                $A.util.addClass(toastTheme, "slds-theme--success");
            }
            // message =message.link("https://www.w3schools.com");
            component.find("toastText").set("v.value", message);
            component.find("toastTtitle").set("v.value", title + ' ');
            //console.log('messagelabel>>' + messagelabel);
            if (!$A.util.isEmpty(messagelabel)) {
                console.log('in if');
                component.find("toastURL").set("v.label", messagelabel);
                // component.find("toastURL").set("v.value", this.navigateToOppComponent);
            }
            this.showHideDiv(component, "customToast", true);
        }
    },
    
    closeToast: function (component) {
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme, "slds-theme--error");
        $A.util.removeClass(toastTheme, "slds-theme--success");
        this.showHideDiv(component, "customToast", false);
    },
    isEmpty: function (value) {
        return ($A.util.isEmpty(value) || $A.util.isUndefined(value) || value === 0);
    },
    validateallInputData: function (component,partialSave) {
        console.log('inside validate');
        var fielddisposition = component.get("v.po.Field_Disposition_1__c");
        var lead = component.get("v.lead");
        var po = component.get("v.po");
        var isEmpty,
            isValid = true;
        var lst = [{
            value: po.Availed_Amount__c,
            auraId: "OfferAmount",
            message: "Enter Offer Amount"
        }, {
            value: po.Availed_Tenor__c,
            auraId: "offerTenor",
            message: "Enter Offer Tenor"
			}/*,
                   {
                       value: component.get("v.po.Field_Disposition_1__c "),
                       auraId: "disposition",
                       message: "Select Disposition"
			}*/
                  ];
         for (var i = 0; i < lst.length; i++) {
			isEmpty = this.isEmpty(lst[i].value);
			isValid = isValid && !isEmpty;
                this.addRemoveInputError(component, lst[i].auraId, isEmpty && lst[i].message);
            }
        
        console.log('isValidpk' + isValid);
        var mcpvalid = true;
        if(!partialSave){ 
            console.log('isValid partialSave' + isValid);
            var mcpCmp = component.find("mcpComponent");
            mcpvalid = mcpCmp.validateMCP();
        }
        
        console.log('after mcp section mcpvalid' + mcpvalid);
        isValid = isValid && mcpvalid
        
        console.log('after mcp section mcpvalid' + isValid);
        var isfollowupvalid = this.validateFollowupDate(component)
        isValid = isValid && !isfollowupvalid
        console.log('after follow up section followup' + isValid);
        console.log('isValid2' + isValid);
        console.log('fielddispositionValue' + fielddisposition);
		/* adhoc 20275 s*/
		if(component.get("v.isFieldAgent") == true && $A.util.isEmpty(component.get("v.po.Field_Disposition_1__c"))){
			isValid = false;
			this.addRemoveInputError(component, "disposition", 'Please select dispostion');
		}
		if(component.get("v.isTeleCaller") == true && $A.util.isEmpty(component.get("v.po.TeleCalling_Desposition_Status__c"))){
			isValid = false;
			this.addRemoveInputError(component, "teleCallingId", 'Please select dispostion');
		}
		/* adhoc 20275 e*/
        if(fielddisposition == 'Docs Received'
           || fielddisposition == 'Sales')
        {
            if($A.util.isEmpty(component.get("v.sourceSearchKeyword")) || $A.util.isEmpty(component.get("v.po.Lead_Source__c"))) 
            {
                isValid = false;
                if($A.util.isEmpty(component.get("v.sourceSearchKeyword")) && component.get("v.isSourcingChannelAndApplicationRequired"))
                    this.addRemoveInputError(component, "sourceName", 'Please Enter Sourcing Channel');
                if($A.util.isEmpty(component.get("v.po.Lead_Source__c")) && component.get("v.isSourcingChannelAndApplicationRequired"))
                    this.addRemoveInputError(component, "applicationsource", 'Please Enter application source');
            }
        }
        
        if (!isValid) {
            this.displayMessage(component, 'ErrorToast', 'errormsg', '<b>Error!</b>, Please fill all the required data before submitting the details.');
            //this.showToast(component, 'Error!', 'Please fill all the required data before submitting the details.', 'error');
        } else
            this.closeToastError(component);
        //this.closeToast(component);
        
        return isValid;
    },
    addRemoveInputError: function (component, key, message) {
        var fielddisposition = component.get("v.po.Field_Disposition_1__c");
        // if (key !== "sourceName")
        // {   //key === 'applicationsource' ||
            if (key === "offerTenor" ||key==='OfferAmount' || key==='disposition' ||key ==='offerTenor' ||key === 'sourceName'|| key ==='applicationsource' || key === 'teleCallingId')
        {     console.log(key);
         component.find(key).showHelpMessageIfInvalid();
         console.log('2nd'+key);
        }
        else
        {
            Console.log(key);
            component.find(key).set("v.errors", [{
                message: message ? ("Please " + message) : ""
            }
                                                ]);
        }
        //}
        /* if(fielddisposition == 'Docs Received'
               || fielddisposition == 'Sales')
        {
            var conMaritalStatusId = component.find("applicationsource");
            if (key === "applicationsource")
            {
                if(conMaritalStatusId.get("v.validity").valid)
                    console.log('conMaritalStatusId');
                else
                    conMaritalStatusId.showHelpMessageIfInvalid();
            }
        }
        if (key === "sourceName" )
        {
        	var conMaritalStatusId = component.find("sourceName");
            if(conMaritalStatusId.get("v.validity").valid)
                console.log('conMaritalStatusId');
            else
                conMaritalStatusId.showHelpMessageIfInvalid();
        }   */ 
    },
    
    createLeadData: function (component,partialSave) {
        var lead = component.get("v.lead");
        lead.Company = 'Others';
        lead.Applicant_Type__c = 'Primary Applicant';
        lead.Customer_Type__c = 'Individual';
        lead.Employment_Type__c = 'Salaried';
        console.log('inside createlead data helper' + lead.Id);
        lead.UTM_Source__c = 'SAL_Mobility';
        lead.attributes = {
            type: 'Lead'
        };
        lead.Id = lead.Id !== '' ? lead.Id : null;
        console.log('leaddata' + JSON.stringify(lead));
        console.log('inside createlead data helper' + lead.Id);
        this.executeApex(component, "createLead", {
            "jsonlead": JSON.stringify([lead]),
            "poID" :component.get("v.po.Id")
        }, function (error, result) {
            console.log('inside leadexecute : ' + result + 'error' + error);
            if (!error && result) {
                console.log('inside leadexecute' + result);
                this.setLeadData(component, result);
                this.createPOData(component,partialSave);
                // this.hideSpinner(component);
                //this.showToast(component, "Success!", "Saved successfully", "success");
                //this.displayMessage(component, 'SuccessToast1', 'successmsg1', '<b>Success!</b>, Saved successfully');
            } else {
                this.displayMessage(component, 'ErrorToast', 'errormsg', '<b>Fail!</b>, Failed To Save');
                this.hideSpinner(component);
            }
        });
    },
    setLeadData: function (component, newLead) {
        console.log('setLeadData inside');
        var lead = component.get("v.lead");
        lead.Id = newLead.Id || lead.Id;
        lead.FirstName = newLead.FirstName || lead.FirstName;
        lead.LastName = newLead.LastName || lead.LastName;
        lead.Email = newLead.Email || lead.Email;
        lead.PAN__c = newLead.PAN__c || lead.PAN__c;
        lead.DOB__c = newLead.DOB__c || lead.DOB__c;
        var newMobile = newLead.Customer_Mobile__c;
        if (newLead.Customer_Mobile__c != undefined && typeof newLead.Customer_Mobile__c == "string")
            newMobile = newMobile.replace(/[^0-9.]/g, "");
        
        lead.Customer_Mobile__c = '' + (newMobile || lead.Customer_Mobile__c);
        lead.Resi_Pin_Code__c = '' + (newLead.Resi_Pin_Code__c || lead.Resi_Pin_Code__c);
        lead.Residence_Address_Line1__c = newLead.Residence_Address_Line1__c || lead.Residence_Address_Line1__c;
        lead.Residence_Address_Line2__c = newLead.Residence_Address_Line2__c || lead.Residence_Address_Line2__c;
        lead.Residence_Address_Line3__c = newLead.Residence_Address_Line3__c || lead.Residence_Address_Line3__c;
        
        component.set("v.lead", lead);
        component.set("v.residenceAddress", lead.Residence_Address_Line1__c +' '+lead.Residence_Address_Line2__c+' '+lead.Residence_Address_Line3__c);
        console.log('setLeadData exit');
    },
    setOldLeadData: function (component) {
        console.log('setOldLeadData inside');
        var lead = component.get("v.lead");
        var oldLead = component.get("v.oldLead") || {};
        oldLead.FirstName = lead.FirstName;
        oldLead.LastName = lead.LastName;
        oldLead.Customer_Mobile__c = lead.Customer_Mobile__c;
        oldLead.PAN__c = lead.PAN__c;
        oldLead.DOB__c = lead.DOB__c; // Bug 14716
        component.set("v.oldLead", oldLead);
        console.log('setOldLeadData completed');
    },
    createPOData: function (component,partialSave) {
        console.log('inside createPOData partialSave>>'+partialSave);
        var po = component.get("v.po");
        console.log('AP++'+JSON.stringify(component.get("v.po")));
        po.Lead__c = component.get("v.lead").Id;
        po.Id = po.Id !== '' ? po.Id : null;
        /*po.Data_Mart_Status__c = 'LIVE';
		po.Process_Type__c = 'PRE APPROVED';
		var today = new Date();
		today.toISOString().substring(0, 10);
		po.Offer_Date__c = today.toISOString().substring(0, 10);*/
        po.UTM_Source__c = 'SAL_Mobility';
        //   po.Total_Employment_Vintage__c = component.get("v.po").Total_work_experience__c;
        //po.Field_Followup_Date__c = component.find("followUpDate").get("v.value");
        
        console.log('inside folloepo'+component.find("followUpDate").get("v.value"));
	//	po.Tele_Calling_Sub_disposition__c = component.find("subDisposition").get("v.value") || null;
	//	po.Field_Disposition_1__c = component.find("disposition").get("v.value") || null;
        po.Follow_Up_Date__c = component.get("v.followUpDateTimeForDis");
        //po.Field_Disposition_1__c = component.find("disposition").get("v.value") || null;
        //sourceName
        if($A.util.isEmpty(component.get("v.sourceSearchKeyword"))) 
            component.set("v.po.Sourcing_Channel__c", '');
        console.log("createpo" + po);
        po.attributes = {
            type: 'Product_Offerings__c'
        };
        this.executeApex(component, "createProductOffering", {
            "jsonPO": JSON.stringify([po])
        }, function (error, result) {
            console.log('inside createPOData result' + result + error);
            if (!error && result) {
                console.log(result);
                this.setPOData(component, result);
                if(!partialSave)
                    this.updatesurrogateCam(component);
                else{
                    this.hideSpinner(component);
                    this.displayMessage(component, 'SuccessToast1', 'successmsg1', '<b>Success!</b>, Saved successfully');
                }
                
            }else {
                this.hideSpinner(component);
                this.displayMessage(component, 'ErrorToast', 'errormsg', '<b>Fail!</b>, Failed To Save');  
            }
        });
    },
    updatesurrogateCam: function(component)
    {
        var scam =component.get("v.scam");
        scam.Id = scam.Id !== '' ?scam.Id : null;
        scam.Product_Offerings__c = component.get("v.po").Id;
        console.log('inside scamupdate'+scam);
        this.executeApex(component, 'updatesurrogateCam', {
            "scam": scam
        }, function(error, result){
            if(!error && result){
                console.log('inside scamupdate'+result);
                var scam =component.get("v.scam");
                scam.Id = result.Id || scam.Id;
                console.log('result.Special_Profile_Employer__c'+result.Special_Profile_Employer__c+'  '+result.Id);
                scam.Special_Profile_Employer__c = result.Special_Profile_Employer__c || scam.Special_Profile_Employer__c;
                component.set("v.scam", scam);
                this.checkMCP(component);
            }
        });
        
    },
    setPOData: function (component, newPO) {
        
        var po = component.get("v.po");
        console.log('inside setpodata newPO'+JSON.stringify(newPO));
        
        po.Id = newPO.Id ;
        po.Lead__c = newPO.Lead__c ;
        po.Sourcing_Channel__c = newPO.Sourcing_Channel__c;
        console.log('po.Sourcing_Channel__c' + po.Sourcing_Channel__c + ' Hey ' + newPO.Sourcing_Channel__c);
        
        //po.Total_Employment_Vintage__c = '' + (newPO.Total_Employment_Vintage__c || po.Total_Employment_Vintage__c);
        console.log('Products__c : NEW PO - ' + newPO.Products__c + '  PO - ' + po.Products__c);
        console.log('newPO.Products__c' + newPO.Products__c + '  ' + po.Products__c);
        po.Products__c = newPO.Products__c || po.Products__c;
        if (!$A.util.isEmpty(newPO.Sourcing_Channel__c)){
            var sourcingChannel = newPO.Sourcing_Channel__r.Name;
            /* if(newPO.Sourcing_Channel__r.FinnOne_Code__c){
			sourcingChannel += ' - ' + newPO.Sourcing_Channel__r.FinnOne_Code__c;
			}
			if(newPO.Sourcing_Channel__r.Branch__r){
			sourcingChannel += ' - ' + newPO.Sourcing_Channel__r.Branch__r.Name;
			}*/
            // console.log('sourcingChannel1'+sourcingChannel);
            //component.set("v.sourceSearchKeyword", sourcingChannel);
            var selectedSource = component.get("v.selectedSource");
            selectedSource.Id = newPO.Sourcing_Channel__c;
            selectedSource.Name = newPO.Sourcing_Channel__r.Name;
            selectedSource.FinnOne_Code__c = newPO.Sourcing_Channel__r.FinnOne_Code__c;
            selectedSource.Branch__c = newPO.Sourcing_Channel__r.Branch__c;
            //component.set("v.selectedSource", selectedSource);
        }
        else
            component.set("v.sourceSearchKeyword", '');  
        //component.set("v.po", po);
    },
    
    checkMCP: function (component, event) {
        var poId = component.get("v.poID");
        console.log('inside check mcp' + poId);
        this.executeApex(component, "checkMcpResult", {
            "poid": poId
        }, function (error, result) {
            console.log('Error : ' + error + ' --Result : ' + result);
            //result ='Fail';
            if (!error && result) {
                console.log(' --Result : ' + result);
                this.hideSpinner(component);
                if (result === 'Pass') {
                    console.log(' --Result1 : ' + result);
                    //this.showToast(component, "Success!", "MCP Pass", "success");
                    this.displayMessage(component, 'SuccessToast1', 'successmsg1', 'Success!, MCP Pass');
                    component.set("v.ismcppass", true);
					/* Adhoc 20275 s*/
					var fielddisposition = '',telefielddisposition = '';
					if(component.get("v.isTeleCaller") == true)
						telefielddisposition = component.get("v.po.TeleCalling_Desposition_Status__c");
					else /* Adhoc 20275 e added telefielddisposition condition*/
						fielddisposition = component.get("v.po.Field_Disposition_1__c"); 
					if ((fielddisposition != '' && (fielddisposition == 'Docs Received' || fielddisposition == 'Sale'  || fielddisposition == 'Followup')) || (telefielddisposition != '' && (telefielddisposition == 'Sale' || telefielddisposition == 'Follow Up')))
                        component.set("v.disableConvert", false);
				} else if (result === 'Fail') {
                    console.log(' --Result2 : ' + result);
                    //this.showToast(component, "Fail!", "MCP Fail", "error");
                    this.displayMessage(component, 'ErrorToast', 'errormsg', 'Fail!, MCP Fail');
                    component.set("v.ismcppass", false);
                    component.set("v.disableConvert", true);
                    this.hideSpinner(component);
                }
                    else if(result === 'failduetopancheck'){
                        console.log(' --Result3 : ' + result);
                        this.displayMessage(component, 'ErrorToast', 'errormsg', 'Fail!,We are unable to process your application at this stage due to internal policy norms not met.');
                        component.set("v.ismcppass", false);
                        component.set("v.disableConvert", true);
                        this.hideSpinner(component);
                    }
            }else {
                console.log(' --Result4 : ' + result);
                //this.showToast(component, "Wait!", "Server Is Down", "info");
                this.displayMessage(component, 'ErrorToast', 'errormsg', 'Wait!, Server Is Down');
                component.set("v.ismcppass", false);
                component.set("v.disableConvert", true);
                this.hideSpinner(component);
            }
            this.hideSpinner(component);
        });
    },
    
    showSpinner: function (component) {
        this.showHideDiv(component, "waiting", true);
    },
    hideSpinner: function (component) {
        this.showHideDiv(component, "waiting", false);
    },
    
    closeToastnew: function (component) {
        document.getElementById('successmsg1').innerHTML = "";
        document.getElementById('SuccessToast1').style.display = "none";
    },
    closeToastError: function (component) {
        document.getElementById('errormsg').innerHTML = "";
        document.getElementById('ErrorToast').style.display = "none";
    },
    displayMessage: function (component, toastid, messageid, message, messagelabel) {
        
        document.getElementById(messageid).innerHTML = message;
        document.getElementById(toastid).style.display = "block";
        if (!$A.util.isEmpty(messagelabel)) {
            console.log('in if');
            component.set("v.isdisableURL", false);
            component.find("toastURL").set("v.label", messagelabel);
        }
        else
            setTimeout(function () {
                document.getElementById(messageid).innerHTML = "";
                document.getElementById(toastid).style.display = "none";
            }, 3000);
        //component.set("v.disableConvert", true);
    },
    populatesubdispoData: function(component, converted){
        this.showSpinner(component);
        this.populateDispositionDataInternal(component, converted, "subDisposition", {
            "controllingField": "Field_Disposition_1__c",
            "dependentField": "	Field_Desposition_Status__c",
            "fldDisposition": component.get("v.po.Field_Disposition_1__c")
        }, function(){});
    },
    populateDispositionDataInternal: function(component, converted, elementId, params, callback) {
        console.log('inside populateDispositionDataInternal');
        this.executeApex(component, 'getDisposition', params, function(error, result){
            console.log('populateDispositionDataInternal'+result);
            if(!error && result){
                if(!$A.util.isEmpty(result))
                {
                    component.set("v.subdispositionlist",result);
                    if (!component.get("v.po.Product_Offering_Converted__c"))
                        component.find("subDisposition").set("v.disabled", false);
                }
                else
                {
                    component.find("subDisposition").set("v.disabled", true);
                    component.set("v.po.Field_Desposition_Status__c",'');
                }
                this.hideSpinner(component);
            } 
            this.hideSpinner(component);
            callback.call(this);
        });
    },
    
})