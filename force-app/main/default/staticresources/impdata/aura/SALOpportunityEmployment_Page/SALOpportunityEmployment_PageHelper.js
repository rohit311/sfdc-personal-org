({
	saveData : function(component, event) {
       debugger;
        var empContact = component.get("v.empContact");
        var empAccount = component.get("v.empAccount");
       /*var result = this.splitAddress(component,event,"office_address");
        console.log('inside saveckyc offi'+result);
        if(!$A.util.isEmpty(result))
        {
            if(result[0])
                empContact.Address_Line_One__c = result[0];
            else
                empContact.Address_Line_One__c ='';
            if(result[1])
                empContact.Address_2nd_Line__c =result[1];
            else
                empContact.Address_2nd_Line__c='';
            if(result[2])
                empContact.Address_3rd_Line__c =result[2];
            else
                empContact.Address_3rd_Line__c='';
            
            
            
        }*/
    	empAccount.Office_Address_1st_Line__c = empContact.Address_Line_One__c;
        empAccount.Office_Address_2nd_Line__c = empContact.Address_2nd_Line__c;
        empAccount.Office_Address_3rd_Line__c = empContact.Address_3rd_Line__c;
        component.set("v.empContact", empContact); 
		component.set("v.empAccount", empAccount);        
        
        var params = new Object();
        var self = this;
        params["empAccount"] = JSON.stringify([component.get("v.empAccount")]);
        params["empContact"] = JSON.stringify([component.get("v.empContact")]);
        params["empOpp"] = JSON.stringify([component.get("v.empOpp")]);
        params["appObj"] = JSON.stringify([component.get("v.priAppObj")]);
                    
        //self.showParentToastHelper('parentInfoToastEmp','parentInfoMsgEmp','Please wait, Saving details ...',true);
        //this.displayToastMessage(component,event,'Message','Please wait, Saving details ...','message'); 
        console.log('robin '+JSON.stringify([component.get("v.TypeForMCP")]));
        var oppList = [];
        oppList.push(component.get("v.empOpp"));
        console.log('opplist '+JSON.stringify(oppList));
        this.executeApex(component,"saveEmpDetails",{"params":{ "empAccount":JSON.stringify([component.get("v.empAccount")]),
                                                               "empContact":JSON.stringify([component.get("v.empContact")]),                                                              
                                                               "empOpp" : JSON.stringify(oppList),
                                                               "appObj":JSON.stringify([component.get("v.priAppObj")]),
                                                               "solPolicySrc":component.get("v.solPolicySrc"),
                                                               "TypeForMCP":component.get("v.TypeForMCP")
                                                               
                                                              }},
                         function(error,result){
                              //self.closeParentToastHelper('parentInfoToastEmp','parentInfoToastEmp');
                              
                              console.log('here '+result);
                              var response = JSON.parse(result);
                             console.log('here response.status'+response.status);
                             if(response.status == "City Fail"){
                                 this.showhidespinner(component,event,false); 
                                 this.displayToastMessage(component,event,'Error','Unable to save details. City/State mapping not available for pincode.','error');
                             }
                             else if(!error && response.status == "Success"){  
                                  // user story 978 start
                                if(component.get("v.stageName") == 'DSA/PSF Login' && component.get("v.isUWCheck") == false) {
                                var updateidentifier =  $A.get("e.c:Update_identifier");
                                updateidentifier.setParams({
                                    "eventName": 'Employment Details',
                                    "oppId":component.get("v.empOpp").Id
                                });
                                updateidentifier.fire();
                                }
                                // user story 978 end
                                 var oppStage = response.opp.StageName;
                                 if(oppStage != null)
                                 {
                                     if(oppStage == 'DSA/PSF Login')
                                     {
                                         component.set("v.stageCompletion","20%") ;
                                     }
                                 }
                                 //var isfromCredit = component.get("v.isfromCredit");
                                 component.set("v.empOpp",response.opp);
                                 component.set("v.empContact",response.objCon);
                                 component.set("v.empAccount",response.accObj);
                                 this.showhidespinner(component,event,false);
                                 //self.showParentToastHelper('parentInfoToastEmp','parentInfoMsgEmp','Details saved successfully. Please wait, initiating MCP ...',true); 
                                 this.displayToastMessage(component,event,'Success','Details saved and MCP Passed !','success');                                      
                                 
                                 
                             }   
                             else if(response.status == "Failure"){
                                 this.showhidespinner(component,event,false);
                                // self.closeParentToastHelper('parentSuccessToast','parentsuccessMsg');
                                 //self.showParentToastHelper('parentErrorToastEmp','parentErrorMsgEmp','Details not present !',false);
                             	this.displayToastMessage(component,event,'Error','Details not present !','error');

                             }
                             else if(response.status == "MCP FAIL"){
                                 var oppStage = response.opp.StageName;
                                 if(oppStage == 'MCP Reject')
                                 {
                                     console.log('in mcp reject Console');
                                     component.set("v.stageCompletion","0%") ;
                                     
                                 }
                                 component.set("v.empOpp",response.opp);
                             	this.showhidespinner(component,event,false);
                                this.displayToastMessage(component,event,'Error','Experience MCP Fail!','error'); 
                                                                      location.reload();

                             }
                             else{
                                  this.showhidespinner(component,event,false);
                                 //self.showParentToastHelper('parentErrorToastEmp','parentErrorMsgEmp','Internal Server error , Please try again later !',false);    
                             	 this.displayToastMessage(component,event,'Error','Internal Server error , Please try again later !','error');
                             }
        				}
        );

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
    showParentToastHelper : function(toastDivId, messageDivId, message,isPermanent){
        
    document.getElementById(toastDivId).style.display = "block";
    document.getElementById(messageDivId).style.display = "block"; 
	document.getElementById(messageDivId).innerHTML = message;
       
    if(!isPermanent){
        setTimeout(function () {
            document.getElementById(toastDivId).style.display = "none";
			document.getElementById(messageDivId).innerHTML = "";
		}, 5000);
    }
   },
   closeParentToastHelper: function(toastDivId, messageDivId){
       console.log('robin helper '+document.getElementById(toastDivId));
       if(document.getElementById(toastDivId) != null && document.getElementById(toastDivId) != undefined){
      	  document.getElementById(toastDivId).style.display = "none";
       }
       if(document.getElementById(messageDivId) != null && document.getElementById(messageDivId) != undefined){
	     document.getElementById(messageDivId).style.display = "none"; 
       }    
   },
   /* fetchData : function(component, event){
        console.log('here');
        var fieldsList = new Object();
        fieldsList ={"fieldList": ["Total_Work_Experience_Yrs__c","Total_Work_Experience_Months__c","Current_experiance_in_Years__c","Current_experiance_in_Month__c","Type_of_Educational_Institution__c","DesignationOTP__c","Qualification__c"]};
        this.executeApex(component,"fetchPicklistData",fieldsList,function(error, result){
            if(!error && result){
                
                var sortFunction = function(a,b) { 
                    					if (isNaN(a) || isNaN(b)) {
    										return a > b ? 1 : -1;
  										}
  										return a - b;
                				   }   
                var response = JSON.parse(result);
                console.log('map data '+response);
                component.set("v.accTotalExpYrs",response["Total_Work_Experience_Yrs__c"].sort(sortFunction));
                component.set("v.accTotalExpMonths",response["Total_Work_Experience_Months__c"].sort(sortFunction));
                component.set("v.accCurrExpYrs",response["Current_experiance_in_Years__c"].sort(sortFunction));
                component.set("v.accCurrExpMonths",response["Current_experiance_in_Month__c"].sort(sortFunction));
            	component.set("v.typeOfEduInstitute",response["Type_of_Educational_Institution__c"].sort(sortFunction));
                component.set("v.qualification",response["Qualification__c"].sort(sortFunction));
                component.set("v.designationList",response["DesignationOTP__c"].sort(sortFunction));
            }
            
            
        });
    },*/
	fetchData : function(component, event){
		var accSelectList = ["Total_Work_Experience_Yrs__c","Total_Work_Experience_Months__c","Current_experiance_in_Years__c","Current_experiance_in_Month__c","Type_of_Educational_Institution__c","DesignationOTP__c","Qualification__c"];
		var conPickList = ["Occupation_CKYC__c"];
		var selectListNameMap = {};
		selectListNameMap["Account"] = accSelectList;
		selectListNameMap["Contact"] = conPickList;
		this.executeApex(component,"fetchEmpPicklistData",{"PicklistJSON" : JSON.stringify(selectListNameMap)},function(error, result){
            if(!error && result){
                this.showhidespinner(component,event,false);
                var response = JSON.parse(result);
                var picklistFields = response.picklistData;
				var accPickFlds = picklistFields["Account"];
				var conPickFlds = picklistFields["Contact"];
				
                component.set("v.accTotalExpYrs",accPickFlds["Total_Work_Experience_Yrs__c"]);
                component.set("v.accTotalExpMonths",accPickFlds["Total_Work_Experience_Months__c"]);
                component.set("v.accCurrExpYrs",accPickFlds["Current_experiance_in_Years__c"]);
                component.set("v.accCurrExpMonths",accPickFlds["Current_experiance_in_Month__c"]);
            	component.set("v.typeOfEduInstitute",accPickFlds["Type_of_Educational_Institution__c"]);
                component.set("v.qualification",accPickFlds["Qualification__c"]);
                component.set("v.designationList",accPickFlds["DesignationOTP__c"]);
				component.set("v.OccupationList",conPickFlds["Occupation_CKYC__c"]);
                /*City CR s*/
                if(!$A.util.isEmpty(component.get('v.empContact.Office_City__c'))){
                    component.set("v.validCity",true);
                    component.set("v.citySearchKeyword", component.get('v.empContact.Office_City__c'));
                }
                /*City CR e*/
            }
            
        });
	},
    splitAddress: function (component,event,key) {
        var totalAddress = component.find(key).get("v.value");
        var result = [];
        if (totalAddress) {
            var line = [];
            var length = 0;
            totalAddress.split(" ").forEach(function(word) {
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
        }
        return result;
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
    } ,
    
    
     showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },
      //underwriter screen changes start
    startSearch: function (component, key) {
        var keyword = component.get("v." + key + "SearchKeyword");
        //var keyword = component.get("v.AreaSearchKeyword");
        console.log("keyword" + keyword+"key"+key);
        if (keyword.length > 2 && !component.get('v.areasearching')) {
                component.set('v.areasearching', true);
                component.set('v.oldAreaKeyword', keyword);
                console.log('keyword -->'+component.get('v.oldAreaKeyword'));
                this.searchHelper(component, key, keyword);
            }
            else if (keyword.length <= 2) {
                console.log("keyword" + keyword+"key"+key);
                component.set("v." + key + "List", null);
                this.openCloseSearchResults(component, key, false);
            }
        
    },
    openCloseSearchResults: function (component, key, open) {
        var resultPanel = component.find(key + "SearchResult");
        $A.util.addClass(resultPanel, open ? 'slds-is-open' : 'slds-is-close');
        $A.util.removeClass(resultPanel, open ? 'slds-is-close' : 'slds-is-open');
    },
    searchHelper: function (component, key, keyword) {
        console.log('executeApex>>' + keyword + '>>key>>' + key);
        var pincode = component.get("v.empAccount.PinCode__c").toString();
        console.log('executeApex>>' + keyword + '>>key>>' + key+pincode); 
        this.executeApex(component, "fetch" + this.toCamelCase(key), {
            'searchKeyWord': keyword,
            'pincode':pincode
        }, function (error, result) {
            console.log('result : ' + result);
            if (!error && result) {
                this.handleSearchResult(component, key, result);
            }
            else
             component.set('v.areasearching', false);
        });
    },
    handleSearchResult: function (component, key, result) {
        console.log('key :  handleSearchResult' + key);
        console.log(result);
        console.log('v.oldSearchKeyword :' + component.get('v.oldSearchKeyword') + '  -> SearchKeyword : ' + component.get("v." + key + "SearchKeyword"));
        
        console.log('inside handleserach'+component.get('v.oldSearchKeyword')+component.get("v." + key + "SearchKeyword"));
        if(key == 'Employer')
        {
            component.set('v.empsearching', false);
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
        if(key == 'area')
        {
            component.set('v.areasearching', false);
            if (!$A.util.isEmpty(component.get("v." + key + "SearchKeyword")) && component.get('v.oldAreaKeyword') !== component.get("v." + key + "SearchKeyword")) {
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
    toCamelCase: function (str) {
        return str[0].toUpperCase() + str.substring(1);
    },
    //underwriter screen changes end
})