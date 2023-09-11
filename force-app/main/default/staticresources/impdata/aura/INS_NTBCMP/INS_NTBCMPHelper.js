({
    initNTBHelper: function(component,event,helper) {
        
        this.executeApex(component, "fetchCustData", {}, function(error, result){
            if(!error && result){
                console.log('result' + JSON.stringify(result));
                component.set("v.wrapperObj",result);
            }
        });
    },
    searchCustHelper : function(component,event,helper) {
        var isValid = helper.validateBeforeSearch(component,event,helper);
        console.log('isValid ::' + isValid);
        
        console.log('ins NTB ::' + JSON.stringify(component.get("v.searchObj")));
        if(isValid){
            component.set("v.isSpinner",true);
            this.executeApex(component, "searchNTBCust", {
                "searchJSON":JSON.stringify(component.get("v.searchObj"))
                
            }, function(error, result){
                if(!error && result){
                    console.log('result' + JSON.stringify(result));
                    var lclList = [];
                    for(var i =0; i<result.length; i++){
                        lclList.push(result[i]);
                    }
                    component.set('v.CustomerList',lclList);
                    this.setRecs(component,event,helper);
                    component.set("v.isSpinner",false);
                }               
                else{
                    component.set("v.isSpinner",false);
                    console.log('ERROR in Search Customer');
                }
            });
        }
    },
    validateBeforeSearch:  function(component,event,helper){
        var isValid = false;
        var arrFields = ['Fname', 'Lname', 'DOB', 'Mobile', 'pan'];
        var searchobj = component.get("v.searchObj");
        for(var i=0; i<arrFields.length ;i++){
            if(searchobj[[arrFields[i]]]){
                isValid = true;
                break;
            }
            else
                isValid = false;
        }
        if(!isValid)
            this.showNotification(event, 'ErrorToast1', 'errormsg1', '<b>Error!</b> First Name and Mobile No. are mandatory for search');
        
        if(isValid){
            isValid = component.find('ntbSearchForm').reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                console.log('valid ' + JSON.stringify(inputCmp));
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
        }
        console.log('isValid ::' + isValid);	
        return isValid;
    },
    
    setRecs: function(component,event,helper){
        
        var tempLst = component.get('v.CustomerList');
        
        var pageSize = component.get("v.pageSize");
        var totalRecs = tempLst.length;
        console.log('totalRecs ::' + totalRecs + 'type ::' + typeof totalRecs);
        component.set("v.totalRecords", totalRecs);
        component.set("v.startPage",0);
        component.set("v.currentPage",1);
        component.set("v.endPage",pageSize);
        //var totRec = component.get("v.ListCustomer").length;
        var rem = totalRecs % pageSize;
        console.log('rem ::' + rem);
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
        
        //Logic to enable/disable Profile, Interaction and product buttons based on FOS assignment
        helper.setBtnState(component,event,helper,tempLst,PaginationList);
        
        //component.set("v.ListCustomer",custLst);
        console.log('PaginationList'+ JSON.stringify(PaginationList));
        component.set('v.PaginationList', PaginationList);
        
    },
    setBtnState: function(component, event, helper, recList, PaginationList){
        var loggedInUserID =  component.get("v.wrapperObj.mapWrpData.LoggedInUserId");
        var mapCustPgRec = {} 
        for(var i=0; i<recList.length; i++ ){
           
            for(var j=0; j<PaginationList.length; j++) {
                mapCustPgRec[recList[i].Id] = PaginationList[i];
                if(recList[i].Id == PaginationList[i].Id){
                    if(PaginationList[i].Insurance_Agent__c){
                        if(PaginationList[i].Insurance_Agent__r.Sales_Officer_Name__c != loggedInUserID ){
                            PaginationList[i].BtnDisableFlag = true; 
                        }
                        else
                             PaginationList[i].BtnDisableFlag = false; 
                    }
                    else{
                    	//When no agent is assigned
                        PaginationList[i].BtnDisableFlag = true;    
                    }
                         
                }
            }
        }
   
        console.log('mapCustPgRec ::' + JSON.stringify(mapCustPgRec));
        component.set("v.CustPgRecMap",mapCustPgRec);
        return PaginationList;
    
    },
    next : function(component, event, helper){
        var sObjectList;
        sObjectList = component.get('v.CustomerList');
        
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
        var sObjectList;
        sObjectList = component.get('v.CustomerList');
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
    openCustInfoHelper: function(component, event, helper){
        console.log('event ::' + JSON.stringify(event.currentTarget.title));
        var objId = event.currentTarget.name;
        console.log("objId::" + objId);
        var btnId = event.currentTarget.title;
        //var btnId = event.currentTarget.id;
        console.log("btnId::" + btnId);
        
        var objType = btnId.split('_')[0];
        console.log("objType::" +  objType);
        
        var paramJSON ={};
        paramJSON.tabId = btnId;
        paramJSON.recId = objId;
        paramJSON.objType = objType;
        paramJSON.calledFrm = 'NTBCMP';
        
        console.log('paramJSON :::' + JSON.stringify(paramJSON));
        component.set("v.childParam",paramJSON);
        component.set("v.openCustDetails",true);
        component.set("v.showNTBCmp", false);
        
        //Call INS_customerDetails init method 
        //var custDetailCmp = component.find('custCmpId');
        //custDetailCmp.initMethod();
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
    backToHomeHelper: function(component, event, helper){
        component.set("v.showNTBCmp",false);
        var compEvent = component.getEvent("INSHomePgEvent");
        var evtParam = {};
        evtParam.homeFlag = true;
        //evtParam.isTileCmpFlag= false;
        compEvent.setParams({"HomeEventParam" : evtParam });
        compEvent.fire();  
    },
    doAssignment: function(component,event,helper){
		
		var custRec = component.get("v.assignMeCust");
        console.log('custRec ::: '+ JSON.stringify(custRec));
		if(custRec)
			this.fetchAssignSOL(component,event,helper,custRec);
		
	},	
    fetchAssignSOL: function(component, event, helper, customerRec){
        var CustPgRecMap = component.get("v.CustPgRecMap");
        var PaginationList = component.get("v.PaginationList");
        var loggedUserId = component.get("v.wrapperObj.mapWrpData.LoggedInUserId");
        var custList = component.get("v.CustomerList");
        
        console.log('customerRec ::'+ JSON.stringify(customerRec));
        console.log('USER ID' + loggedUserId);
        component.set("v.isSpinner", true);
        
        try{
            this.executeApex(component, "fetchSOLData", {
                "userID":loggedUserId,
                "CustRec" : customerRec
            }, function(error, result){
                console.log('result ::' + JSON.stringify(result));
                if(!error && result){
                    component.set("v.isSpinner", false);
                    if(result.isAgentAssigned){
                        helper.showNotification(event,"SuccessToast1","successmsg1","<b>Success!</b>,Customer has been assigned to you !!!");	
                        if(CustPgRecMap[customerRec.Id])
                            CustPgRecMap[customerRec.Id].BtnDisableFlag = false;
                        
                        /**Update the customer record with updated SOL data to avoid assigning the agent 
                        again in case of double click of assign to me button **/
                        for(var i=0;i<custList.length;i++){
                            
                            if(custList[i].Id == result.CustRec.Id){
                                if(!custList[i].Insurance_Agent__r){
                                    custList[i].Insurance_Agent__r = {};
                                    custList[i].Insurance_Agent__r.Sales_Officer_Name__r = {};
                                    custList[i].Insurance_Agent__c = result.CustRec.Insurance_Agent__c;
                                }
                                custList[i].Insurance_Agent__r.Id = result.CustRec.Insurance_Agent__c;
                                custList[i].Insurance_Agent__r.Sales_Officer_Name__c = loggedUserId;
                               
                                custList[i].Insurance_Agent__r.Sales_Officer_Name__r.Id = loggedUserId;
                                custList[i].Insurance_Agent__r.Sales_Officer_Name__r.Name = component.get("v.wrapperObj.mapWrpData.LoggedInUserName");
                            }
                        }
                        component.set("v.CustomerList",custList);
                        console.log('CustomerList ::' + JSON.stringify(custList));
                    }
                    else{
                        helper.showNotification(event, 'ErrorToast1', 'errormsg1', '<b>Error!</b> ERROR in assigning the Customer to FOS');
					}
                    //helper.showNotification(event,"SuccessToast1","successmsg1","<b>Success!</b>,"+result.msg);	
                    //helper.showNotification(event,"SuccessToast1","successmsg1","<b>Success!</b>,Customer has been assigned to you !!!");	
                }
                else{
                    component.set("v.isSpinner", false);
                    helper.showNotification(event, 'ErrorToast1', 'errormsg1', '<b>Error!</b> ERROR in assigning the Customer to FOS');
                }
                component.set("v.PaginationList",PaginationList);
                
            });
        }catch(e){
            component.set("v.isSpinner", false);
            helper.showNotification(event, 'ErrorToast1', 'errormsg1', '<b>Error!</b>' + e.message);
        }
    },
    executeApex: function(component, method, params, callback){
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
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
                //this.showNotification(event,'ErrorToast1', 'errormsg1', '<b>Error!</b>,'+ errors.join(", ") );
                callback.call(this, errors, response.getReturnValue());
                
            }
        });
        $A.enqueueAction(action);
    }
})