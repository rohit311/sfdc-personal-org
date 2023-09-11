({
    saveLoanData : function(component, event, helper) {
        if (this.validateForm(component)) {
           // component.set("v.spinnerFlag","true");
            var appliedTenor = component.get("v.surrogateCamObj").CY_Tenor__c;
            var pureFlexi = component.get("v.applicantObj").Pure_Flexi_Period__c;
            if(pureFlexi == null || pureFlexi == undefined || pureFlexi == '')
                pureFlexi = 0;
            if (appliedTenor >= pureFlexi) {
               component.set("v.applicantObj.Drop_Line_Flexi_Period__c", ( appliedTenor - pureFlexi ));
            } else {
               component.set("v.applicantObj.Drop_Line_Flexi_Period__c", "");
            }
            
            
            var officeAddress = component.get("v.officeAddress");
            var str1 = ''; 
            var str2 = '';
            var str3 = '';
            var addarr = [];
            
            if(officeAddress){
                addarr = officeAddress.split(' ');
                if(addarr.length>0){
                    var count = Math.floor(addarr.length/3);
                    for(var i=0;i<count;i++){
                        str1=str1+' '+ addarr[i];
                        str2=str2+' '+ addarr[i+count];
                        str3=str3+' '+ addarr[i+count+count];
                    } 
                    if(count*3<addarr.length){
                        for(var i=count*3;i<addarr.length;i++)
                            str3 = str3 +' '+ addarr[i];
                    } 
                    
                    
                }
            }
          	if (officeAddress) {
                str1 = ''; 
            	str2 = '';
            	str3 = '';
               var totalLength = officeAddress.length;
               var length = totalLength / 3;
               if (totalLength > 120) {
                officeAddress = officeAddress.substring(0, 120);
                length = 40;
               }
               str1 = officeAddress.substring(0, length);
               str2 = officeAddress.substring(length, length * 2);
               str3 = officeAddress.substring(length * 2, totalLength);
              }			
            console.log('str1 -->' + str1);
            console.log('str2 -->' + str2);
            console.log('str3 -->' + str3);
            
            component.set("v.surrogateCamObj.Tenor_of_Loan__c",component.get("v.surrogateCamObj").CY_Tenor__c);
            
            
            
            //var opp = {'Loan_Variant__c': component.get("v.oppObj").Loan_Variant__c,'End_Use__c': component.get("v.oppObj").End_Use__c,'Id': component.get("v.oppObj").Id,'Scheme_Master__c' : component.get("v.oppObj").Scheme_Master__c};
            //var opp = {'Loan_Variant__c': component.get("v.oppObj").Loan_Variant__c,'End_Use__c': component.get("v.oppObj").End_Use__c,'Id': component.get("v.oppObj").Id,'Scheme_Master__c' : component.get("v.oppObj").Scheme_Master__c, 'Approved_Tenor__c': component.get("v.surrogateCamObj").CY_Tenor__c, 'Tenor__c': component.get("v.surrogateCamObj").CY_Tenor__c};
            var ApprovedLoanAmount = (component.get("v.surrogateCamObj").Loan_Amount__c) * 100000;
            // Bug 23801 Type_Of_Loan__c added S
            var opp =   {'Loan_Variant__c': component.get("v.oppObj").Loan_Variant__c,'Type_Of_Loan__c':component.get("v.oppObj").Type_Of_Loan__c,'End_Use__c': component.get("v.oppObj").End_Use__c,'Id': component.get("v.oppObj").Id,'Scheme_Master__c' : component.get("v.oppObj").Scheme_Master__c, 'Approved_Tenor__c': component.get("v.surrogateCamObj").CY_Tenor__c, 'Tenor__c': component.get("v.surrogateCamObj").CY_Tenor__c, 'Approved_Loan_Amount__c': ApprovedLoanAmount, 'Loan_Amount__c' : ApprovedLoanAmount };
            //Bug 23801 E    
            //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement start set office state
            var accObj = {'Id':component.get("v.oppObj").AccountId,'Office_Address_1st_Line__c': str1 ,'Office_Address_2nd_Line__c': str2 ,'Office_Address_3rd_Line__c': str3 , 'Office_City__c':component.get("v.oppObj.Account.Office_City__c"),'Office_Pin_Code__c':component.get("v.oppObj.Account.Office_Pin_Code__c"),'Type_of_Ownership__c':component.get("v.oppObj.Account.Type_of_Ownership__c"),'Office_State__c':component.get("v.oppObj.Account.Office_State__c")};
            //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement start
            var  conObj = {'Id':component.get("v.conID"),'Address_Line_One__c':str1,'Address_2nd_Line__c':str2,'Address_3rd_Line__c':str3,'Office_City__c':component.get("v.oppObj.Account.Office_City__c"),'Office_Pin_Code__c':component.get("v.oppObj.Account.Office_Pin_Code__c"),'Office_State__c':component.get("v.oppObj.Account.Office_State__c")};        
            //Bug ID 23676 Ends
            //Bug ID 23676 Added conObj in JSON
            var data = {'pdObj': component.get("v.personalDiscussion"), 'oppObj': opp, 'accObj': accObj,'conObj':conObj,'sCamObj' : component.get("v.surrogateCamObj"), 'appObj': component.get("v.applicantObj")};
            console.log('data --> ' , data);
            console.log('this is applicant');
            console.log(component.get("v.applicantObj"));
            this.executeApex(component, "saveData", {"loanData" : JSON.stringify(data)}, function(error, result) {
                      //  component.set("v.spinnerFlag","false");
                if(!error && result) {
                    // show toast
                    console.log('result here -->', result);
                    this.showToast(component, "Success", "Loan Info Saved Successfully", "success");
                } else {
                    console.log('not here -->');
                    this.showToast(component, "Error", "Loan Info could not be saved", "error");
                }
            });
        }
    },
    getScheme : function(component, event) {
        var keyword = component.get("v.schemeSearchKeyword");
        console.log('keyword --> ' + keyword);
        this.executeApex(component, "getScheme", {}, function(error, result){
            if(!error && result) {
                //console.log('result -->', result);
                component.set("v.schemeRecords", result || []);

                // Set scheme value
                console.log('default values --> ' , component.get("v.oppObj").Scheme_Master__c);
                if (component.get("v.oppObj").Scheme_Master__c != '' && component.get("v.oppObj").Scheme_Master__c != undefined) {
                    var all = component.get("v.schemeRecords") || [];

                    for(var i = 0; i < all.length; i++) {
                        var value = all[i];
                        console.log('all --> ' + (value.Id == component.get("v.oppObj").Scheme_Master__c));
                        if(value.Id == component.get("v.oppObj").Scheme_Master__c) {
                        	console.log('value --> ' , value);
                            //component.find("scheme").set("v.value", value.Name);
                            component.set("v.schemeSearchKeyword", value.Name);
                            break;
                        }
                    }
                }
            }
        });
        
    },
    //Bug 23801 S
    gettypeOfLoan : function(component, event) {
    	this.executeApex(component, "GetLoanTypeValues",{"objDetail":component.get("v.oppObj"),"fields":"Type_Of_Loan__c"}, 
        	function(error, result){
            	if(!error && result){
                	console.log('values are'+result.Type_Of_Loan__c.dependentValueMap); 
            		var ObjMap = result.Type_Of_Loan__c.dependentValueMap;
                    var typeOfLoanList =[];
             		for (var key in ObjMap) {
                        if(key == 'Doctors Loan'){
                            console.log(key);
                            typeOfLoanList = ObjMap[key];
                            console.log('picklist entries are'+typeOfLoanList);
                        }
                    }
                    typeOfLoanList = typeOfLoanList.sort();
                    component.set("v.typeOfLoanList",typeOfLoanList);
                    console.log("type of loan values"+component.get("v.typeOfLoanList"));
                }
		
            });
    },
     //Bug 23801 E
    getPickListOptionValues : function(component, event) {
        var oppSelectList = ["Loan_Variant__c","End_Use__c"];
        var accSelectList = ["Office_City__c","Type_of_Ownership__c"];
        //var personalDiscSelectList = ["Type_of_PD__c"];

        var selectListNameMap = {};
        selectListNameMap["Opportunity"] = oppSelectList;
        selectListNameMap["Account"] = accSelectList;
        //selectListNameMap["Personal_Discussion__c"] = personalDiscSelectList;
        console.log('picklist value -->', JSON.stringify(selectListNameMap));

        this.executeApex(component, "getSelectListOptions", {"objectFieldJSON" : JSON.stringify(selectListNameMap)}, function(error, result) {
            if(!error && result) {
                var data = JSON.parse(result);
                var picklistFields = data.picklistData;
                var oppPickFields = picklistFields["Opportunity"];
                var accPickFields = picklistFields["Account"];
                //var personalDiscPickFields = picklistFields["Personal_Discussion__c"];

                //console.log('oppPickFields["Loan_Variant__c"] --> ' + oppPickFields["Loan_Variant__c"]);
                console.log('oppPickFields["End_Use__c"] --> ' + oppPickFields["End_Use__c"]);
                //console.log('personalDiscPickFields["Type_of_PD__c"] --> ' + personalDiscPickFields["Type_of_PD__c"]);
                //console.log('accPickFields["Office_City__c"] --> ' + accPickFields["Office_City__c"]);
                //console.log('accPickFields["Type_of_Ownership__c"] --> ' + accPickFields["Type_of_Ownership__c"]);
                component.set("v.loanVariantList", oppPickFields["Loan_Variant__c"]);
                component.set("v.endUseList", oppPickFields["End_Use__c"]);
                //component.set("v.typeOfPDList", personalDiscPickFields["Type_of_PD__c"]);
                component.set("v.officeCityList", accPickFields["Office_City__c"]);
                component.set("v.officeOwnershipList", accPickFields["Type_of_Ownership__c"]);
                console.log('component.et("v.loanVariantList" -->' + component.get("v.loanVariantList"));
                //console.log('component.get("v.typeOfPDList" -->' + component.get("v.typeOfPDList"));
                this.setDefaultValues(component, event);
            }
            else {
                //show spinner code here...
                //this.showhidespinner(component,event,false);   
            }
        });
        
    },
    //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement start
     searchStateAsperCity: function(component,city) {
      console.log('selected city--->'+city);
         this.executeApex(component, "fetchState", {"inputcity" : city}, function(error, result) {
            if(!error && result) {
                console.log('state selected is==>'+result);
               component.set("v.oppObj.Account.Office_State__c",result)
            }
            
        });
    },
    //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement end
     // 31 jan S
        searchCity: function(component) {
        var keyword = component.get("v.officeCitySearchKeyword"); 
            console.log('keyword is'+keyword);
        if(keyword.length > 0){
            var all = component.get("v.officeCityList") || [];
            var filterValues = [];
            for(var i = 0; i < all.length; i++){
                var value = all[i];
                if(value.toLowerCase().includes(keyword.toLowerCase())){
                    filterValues.push(value);
                }
            }
            console.log('filterValues'+filterValues);
            component.set("v.filteredOfficeCities", filterValues);
            this.showHideMessage(component, "officeCity", !filterValues.length);
            this.openCloseSearchResults(component, "officeCity", true);
        } else {  
            component.set("v.filteredOfficeCities", null); 
            this.openCloseSearchResults(component, "officeCity", false);
        }
    },
     // 31 jan E
    executeApex: function(component, method, params,callback){
        //console.log('params'+JSON.stringify(params));
        var action = component.get("c."+method); 
        action.setParams(params);
        component.set("v.spinnerFlag","true");
        action.setCallback(this, function(response) {
            component.set("v.spinnerFlag","false");
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log('response.getReturnValue() --> ', response.getReturnValue());
                callback.call(this, null, response.getReturnValue());
            } else if(state === "ERROR") {
                console.log('----------------------------------->');
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
    setDefaultValues : function(component, event) {
        //console.log('loanVariant_SelectOption -->', component.find("loanVariant_SelectOption"));
        /*component.find("loanVariant_SelectOption")[0].set("v.label", 'HYBRID');
        component.find("endUse_SelectOption")[0].set("v.label", 'Business Use');
        component.find("typeOfPD_SelectOption")[0].set("v.label", 'PD not Required');
        component.find("officeOwnership_SelectOption")[0].set("v.label", 'Owned by Self/Spouse');*/
        console.log('lv --> ' , JSON.stringify(component.get("v.oppObj")));
        if(component.get("v.oppObj").Loan_Variant__c == null || component.get("v.oppObj").Loan_Variant__c == undefined) {
            component.set("v.oppObj.Loan_Variant__c", 'HYBRID');
            if (component.get("v.oppObj").StageName == 'Post Approval Sales') {
                if (component.find("hybridFlexiTenor") != undefined) component.find("hybridFlexiTenor").set("v.disabled", true);
            }
        }
        if(component.get("v.oppObj").End_Use__c == null || component.get("v.oppObj").End_Use__c == undefined) {
            component.set("v.oppObj.End_Use__c", 'Business Use');
        }
        console.log('pd --> ' , (component.get("v.personalDiscussion.Type_of_PD__c")));
        if(component.get("v.personalDiscussion").Type_of_PD__c == null || component.get("v.personalDiscussion").Type_of_PD__c == undefined) {
            component.set("v.personalDiscussion.Type_of_PD__c", 'PD not required');
        }
        console.log(' own -->', component.get("v.oppObj").Account);
        if(component.get("v.oppObj").Account.Type_of_Ownership__c == null || component.get("v.oppObj").Account.Type_of_Ownership__c == undefined) {
            component.set("v.oppObj.Account.Type_of_Ownership__c", 'Clinic Ownership');
        }
    },
    searchScheme : function(component) {
        try {
        var keyword = component.get("v.schemeSearchKeyword");
        console.log('keyword --> ' + keyword); 
        if(keyword.length > 0){
            var all = component.get("v.schemeRecords") || [];
            var filterValues = [];
            console.log('--> ', (component.get("v.oppObj").Loan_Variant__c));
            console.log(component.get("v.surrogateCamObj"));
            for(var i = 0; i < all.length; i++){
                var value = all[i];
                
                if(value.Name.toLowerCase().includes(keyword.toLowerCase())) {
                    console.log('value --> ' , value);
                    
                    if (value.Active__c == true && component.get("v.oppObj").Loan_Variant__c == 'HYBRID' && value.flexi_flag__c == true && value.IsHybridFlexi__c == true) {
                        filterValues.push(value);
                    } else if (value.Active__c == true && component.get("v.oppObj").Loan_Variant__c == 'DROPLINE FLEXI' && value.flexi_flag__c == true && value.IsHybridFlexi__c == false && value.is_Pure_Flexi__c == false) {
                        filterValues.push(value);
                    } else if (value.Active__c == true && component.get("v.oppObj").Loan_Variant__c == 'REGULAR' && value.flexi_flag__c == false && value.IsHybridFlexi__c == false && value.is_Pure_Flexi__c == false) {
                        filterValues.push(value);
                    } else if (value.Active__c == true && component.get("v.oppObj").Loan_Variant__c == 'PURE FLEXI' && value.flexi_flag__c == true && value.is_Pure_Flexi__c == true) {
                        filterValues.push(value);
                    }
                }
            }
            console.log('filterValues --> ' , filterValues);
            component.set("v.filteredScheme", filterValues);
            console.log('filteredScheme --> ', component.get("v.filteredScheme"));
            this.showHideMessage(component, "scheme", !filterValues.length);
            this.openCloseSearchResults(component, "scheme", true);
        } else {
            component.set("v.filteredScheme", null); 
            this.openCloseSearchResults(component, "scheme", false);
        }
        } catch (err) {
           console.log('err -->', err.message);
        }
    },
    openCloseSearchResults: function(component, key, open) {
        var resultPanel = component.find(key+"SearchResult");
        $A.util.addClass(resultPanel, open ? 'slds-is-open' : 'slds-is-close');
        $A.util.removeClass(resultPanel, open ? 'slds-is-close' : 'slds-is-open');
    },
    showHideMessage : function(component, key, show) {
        component.set("v.message", show ? 'No Result Found...' :  '');
        this.showHideDiv(component, key+"Message", show);
    },
    fetchData : function(component, key, show) {
        console.log('oppId --> ', component.get("v.oppId"));
        this.executeApex(component, "fetchData", {"loanId": component.get("v.oppId")}, function(error, result) {
            if(!error && result) {
                //console.log('result 1 --> ', result);
                console.log('result 2 --> ', result.oppObj);
                console.log('result 3 --> ', result.pdObj);
                //console.log('result 4 --> ', result.appObj);
                console.log('result 5 --> ', result.sCamObj);

                component.set("v.oppObj", result.oppObj);
                console.log('oppObj --> ' , component.get("v.oppObj"));

                component.set("v.personalDiscussion", result.pdObj);
                console.log('pdObj --> ' , component.get("v.personalDiscussion"));

                component.set("v.applicantObj", result.appObj);
                console.log('applicant --> ' , component.get("v.applicantObj"));
				//Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement start
				console.log("Contact ID is"+result.appObj.Contact_Name__c);
				component.set("v.conID",result.appObj.Contact_Name__c);
				//Bug 23676 Ends
                component.set("v.surrogateCamObj", result.sCamObj);
                console.log('sCAM --> ' , component.get("v.surrogateCamObj"));
                // 31 jan S
                component.set("v.officeCitySearchKeyword",component.get("v.oppObj.Account.Office_City__c"));
                // 31 jan E

                if (component.get("v.surrogateCamObj").Loan_Amount__c != '' && component.get("v.surrogateCamObj").Loan_Amount__c != undefined) {
                    var value = component.get("v.surrogateCamObj.Loan_Amount__c");
                    console.log('amt -->' , value / 100000);
                    //component.set("v.appliedAmtInLacs", value / 100000);
                }
                
                console.log('1 -->' + component.get("v.oppObj.Account.Office_Address_1st_Line__c"));
				console.log('2 -->' + component.get("v.oppObj.Account.Office_Address_2nd_Line__c"));
				console.log('3 -->' + component.get("v.oppObj.Account.Office_Address_3rd_Line__c"));
                //component.set("v.officeAddress",component.get("v.oppObj.Account.Office_Address_1st_Line__c")?component.get("v.oppObj.Account.Office_Address_1st_Line__c"):''+' '+component.get("v.oppObj.Account.Office_Address_2nd_Line__c")?component.get("v.oppObj.Account.Office_Address_2nd_Line__c"):''+' '+component.get("v.oppObj.Account.Office_Address_3rd_Line__c")?component.get("v.oppObj.Account.Office_Address_3rd_Line__c"):'');
                var add = '';
				if (component.get("v.oppObj.Account.Office_Address_1st_Line__c") != undefined && component.get("v.oppObj.Account.Office_Address_1st_Line__c") != '' && component.get("v.oppObj.Account.Office_Address_1st_Line__c") != null)
					add += component.get("v.oppObj.Account.Office_Address_1st_Line__c");
				if (component.get("v.oppObj.Account.Office_Address_2nd_Line__c") != undefined && component.get("v.oppObj.Account.Office_Address_2nd_Line__c") != '' && component.get("v.oppObj.Account.Office_Address_2nd_Line__c") != null)
					add = add + ' ' + component.get("v.oppObj.Account.Office_Address_2nd_Line__c");
				if (component.get("v.oppObj.Account.Office_Address_3rd_Line__c") != undefined && component.get("v.oppObj.Account.Office_Address_3rd_Line__c") != '' && component.get("v.oppObj.Account.Office_Address_3rd_Line__c") != null)
					add = add + ' ' + component.get("v.oppObj.Account.Office_Address_3rd_Line__c");
				console.log('add --> ', add);
                component.set("v.officeAddress",add);
                console.log('asas --> ' , component.get("v.officeAddress"));
                console.log('component.get("v.oppObj").StageName -->', component.get("v.oppObj.StageName"));
            } else {
            }
        });
    },
    showHideDiv: function(component, divId, show) {
        console.log('inside --> ' , component.find(divId));
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
    validateForm : function(component) {
        var opp = component.get("v.oppObj");
        var app = component.get("v.applicantObj");
        var sCam = component.get("v.surrogateCamObj");
        var pd = component.get("v.personalDiscussion");
        var isEmpty, isValid = true;
        var lst = [
            {value: sCam.Loan_Amount__c, auraId: "appliedAmount", message: "Please enter Applied Amount (in Lacs) field value"},
            {value: opp.Loan_Variant__c, auraId: "loanVariant", message: "Please enter Loan Variant field value"},
            {value: sCam.CY_Tenor__c, auraId: "appliedTenor", message: "Please enter Applied Tenor (Months) field value"},
            {value: opp.Scheme_Master__c, auraId: "scheme", message: "Please enter Scheme field value"},
            {value: opp.End_Use__c, auraId: "endUse", message: "Please enter End Use field value"},
            //Bug 23801 added typeOfLoan
            {value: opp.Type_Of_Loan__c, auraId: "typeOfLoan", message: "Please select Type of Loan"},
            {value: component.get("v.officeAddress"), auraId: "officeAddr", message: "Please enter Office Address field value"},
            {value: opp.Account.Office_City__c, auraId: "officeCity", message: "Please enter Office City field value"},
            {value: opp.Account.Office_Pin_Code__c, auraId: "officePincode", message: "Please enter Office Pincode field value"},
            {value: opp.Account.Type_of_Ownership__c, auraId: "officeOwnership", message: "Please enter Office Ownership field value"}
        ];
        if (component.get("v.oppObj").Loan_Variant__c == 'HYBRID') {
            lst.push({value: app.Pure_Flexi_Period__c, auraId: "hybridFlexiTenor", message: "Please enter Pure Flexi Tenor (Months) field value"});
        }
        for(var i = 0; i < lst.length; i++) { 
            isEmpty = this.isEmpty(lst[i].value);
            //console.log('isEmpty --> ' , isEmpty);
            //console.log('lst[i].message --> ' , lst[i].message);
            //console.log('lst[i].value --> ' , lst[i].value);
            //console.log('sCam.Loan_Amount_From_Offer__c --> ' , sCam.Loan_Amount_From_Offer__c);
            if (sCam.Loan_Amount_From_Offer__c == undefined) sCam.Loan_Amount_From_Offer__c = 0;
            if (lst[i].auraId == 'appliedAmount' && lst[i].value < 0) { // Bug Id : 19839
                lst[i].message = 'The amount can not be negative';
                isEmpty = true;
            }
            
             if (lst[i].auraId == 'appliedTenor' && lst[i].value < 0) { 
                lst[i].message = 'The Applied tenor can not be negative';
                isEmpty = true;
            }
             if (lst[i].auraId == 'hybridFlexiTenor' && lst[i].value < 0) { 
                lst[i].message = 'The Pure Flexi Tenor can not be negative';
                isEmpty = true;
            }
            //Loan.Approved_Loan_Amount__c = sCam.Loan_Amount_From_Offer__c > 99999 ? sCam.Loan_Amount_From_Offer__c : sCam.Loan_Amount_From_Offer__c * 100000; 
            // 11th Feb SCAM issue
            var scamfromoffer = sCam.Loan_Amount_From_Offer__c > 99999 ? sCam.Loan_Amount_From_Offer__c : sCam.Loan_Amount_From_Offer__c * 100000;
            if (lst[i].auraId == 'appliedAmount' && (lst[i].value * 100000) > scamfromoffer) {
                lst[i].message = 'The amount can not be more than offer amount';
                isEmpty = true;
            }
            if (lst[i].auraId == 'hybridFlexiTenor') {
                console.log('lst[i].value --> ' , lst[i].value);
                console.log('sCam.CY_Tenor__c --> ' , sCam.CY_Tenor__c);
                if (lst[i].value > sCam.CY_Tenor__c) {
                    lst[i].message = 'Pure Flexi Tenor (Months) cannot be greater than Applied Tenor (Months)';
                    isEmpty = true;
                }
            }
            if (lst[i].auraId == 'officePincode') {
                //console.log('lst[i].value  --> ' , (lst[i].value) );
                //console.log('lst[i].value.length  --> ' , (lst[i].value).toString().length );
                var returnValue = this.validatePIN(component);
                console.log('returnValue -->', returnValue);
                if (!returnValue) {
                	lst[i].message = 'Pincode can accept only 6 digits and no alphabets allowed';
                    isEmpty = true;
                }
                console.log('isEmpty -->', isEmpty);           
            }
            //console.log('q len -->', lst[i].value);
            isValid = isValid && !isEmpty;
            this.addRemoveInputError(component, lst[i].auraId, isEmpty && lst[i].message);
        }
        //console.log('isValid -->', isValid);
        
       //isValid = isValid && !this.ValidateTenor(component);
        
        return isValid;
     },
    ValidateTenor : function(component)
    {
       // if(!this.isEmpty(component.get("v.applicantObj.Drop_Line_Flexi_Period__c"))){
      //      var isValid = parseFloat(component.get("v.surrogateCamObj.CY_Tenor__c")) >  parseFloat(component.get("v.applicantObj.Drop_Line_Flexi_Period__c"));
      //      this.addRemoveInputError(component, "hybridFlexiTenor", isValid && "Hybrid Flexi Tenor shoult not be greater than Applied Tenor");
      //     console.log(isValid);
      //  }
    
        //return isValid;
    },
    addRemoveInputError: function(component, key, message){
        //console.log('key -->', key);
        //console.log('cmp -->', component.find(key));
        //console.log('msg --> ', message);
        component.find(key).set("v.errors", [{message: message ? (message) : ""}]);
    },
    isEmpty: function(value){
        return ($A.util.isEmpty(value) || $A.util.isUndefined(value) || value === 0);
    },
    showToast : function(component, title, message, type) {
        var ShowToastEvent = $A.get("e.c:ShowToastEvent");
        ShowToastEvent.setParams({
            "title": title,
            "message":message,
            "type":type,
        });
        ShowToastEvent.fire();
    },
    disableLoanInfoForm : function(component) {
        //Bug 23801 added typeOfLoan
        var list = [
            "appliedAmount", "loanVariant", "hybridFlexiTenor", "scheme", "endUse","typeOfLoan",
            "typeOfPD", "officeAddr", "officeCity", "officePincode", "officeOwnership"
        ];
        
        window.setTimeout(
                $A.getCallback(function() {
                    for(var i = 0; i < list.length; i++){
                        console.log('list[i] ----->> '+list[i]);
                        console.log('component.find(list[i]) ---->> '+component.find(list[i]));
                        if(component.find(list[i])){
                            debugger;
                           component.find(list[i]).set("v.disabled", true); 
                        }
                            
                    }
             	}), 2000
             );
        
        // disable button
       // if(component.find("saveOpp"))
       // component.find("saveOpp").getElement().disabled = true;
		//window.setTimeout(
        	//$A.getCallback(function() {
          //      debugger;
                //component.find("gstDetails").getElement().style.pointerEvents="none";
               // component.find("gstDetails").getElement().style.cursor="default";
        	//}), 2000
      //  );
    },
    enableLoanInfoForm : function(component) {
        //Bug 23801 added typeOfLoan
        var list = [
            "appliedAmount", "loanVariant", "hybridFlexiTenor", "scheme", "endUse","typeOfLoan", 
            "typeOfPD", "officeAddr", "officeCity", "officePincode", "officeOwnership"
        ];
        for(var i = 0; i < list.length; i++){
            if(component.find(list[i]))
            component.find(list[i]).set("v.disabled", false);
        }
        // disable button
        //if(component.find("saveOpp"))
        //	component.find("saveOpp").getElement().disabled = false;
        //component.find("gstDetails").getElement().style.pointerEvents="auto";
        //component.find("gstDetails").getElement().style.cursor="pointer";
    },
    validateField: function(component, key, pattern, error){
        var field = component.find(key); 
        var value = '' + field.get("v.value");
        console.log('field ====>> '+field);
        console.log('value ====>> '+value);
        var valid = true;
        valid = ((value == '' || value == 'undefined' || $A.util.isEmpty(value))|| pattern.test(value.trim())); 
        console.log('valid ====>> '+valid);
        field.set("v.errors", [{message: valid ? "Enter a valid " + error:""}]);
        return valid;
    },
    validatePIN : function(component){
        console.log('inside validate pin -->');
        console.log('wwwwww====>> '+component.get("v.oppObj.Account.Office_Pin_Code__c"));
        if (component.get("v.oppObj.Account.Office_Pin_Code__c") != undefined) 
            //component.set("v.oppObj.Account.Office_Pin_Code__c", component.get("v.oppObj.Account.Office_Pin_Code__c").toString().replace(/[a-zA-z]/g, ''));
        return this.validateField(component, "officePincode", /^[1-9]\d{5}$/, "Pin Code");
    },
    validateAppliedTenor: function(component){
        if (component.get("v.surrogateCamObj.CY_Tenor__c") != undefined) component.set("v.surrogateCamObj.CY_Tenor__c", (''+component.get("v.surrogateCamObj.CY_Tenor__c")).toString().replace(/[a-zA-z]/g, ''));
        return this.validateField(component, "appliedTenor", /^[1-9]\d{9}/, "Applied Tenor (Months)");
    },
    validateHybridFlexiTenor: function(component){
        if (component.get("v.applicantObj.Drop_Line_Flexi_Period__c") != undefined) component.set("v.applicantObj.Drop_Line_Flexi_Period__c", (''+component.get("v.applicantObj.Drop_Line_Flexi_Period__c")).toString().replace(/[a-zA-z]/g, ''));
        return this.validateField(component, "hybridFlexiTenor", /^[1-9]\d{9}/, "Hybrid Flexi Tenor (Months)");
    },
})