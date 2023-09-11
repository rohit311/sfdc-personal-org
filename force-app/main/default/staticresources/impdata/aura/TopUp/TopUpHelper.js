({
	initialize: function(component, event, helper) 
    {
        var data = component.get('v.lstTopUp');
        var oppId = component.get("v.oppId");
        console.log('data---'+data);
        var action = component.get("c.fetchTopUp");
        action.setParams({"oppId":oppId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnVal = response.getReturnValue();
               
                var fetchPicklistValues = component.get("c.getPicklistValues");
                fetchPicklistValues.setParams({
                    sObjectName : "TelePDQuestionMaster__c",
                    fieldName : "DisbursementType__c"
                });
                
                fetchPicklistValues.setCallback(this, function(res){
					var statusCode = response.getState();
            		if (statusCode === "SUCCESS") 
                    {
                    	var mapKeys =[];
                        var retVal = res.getReturnValue();
                        for (var  key in retVal ) {
                            mapKeys.push({value:retVal[key], key:key});
                            console.log('key:'  + key + ':: val :'  +retVal[key] );
                        }
                        component.set("v.opts" , mapKeys);
                        component.set("v.lstTopUp", returnVal);
                    }
                    try{
                        var oppId = component.get("v.oppId");
                        console.log('oppId  ------ fetch' + oppId );
                        if(oppId != null){
                            var act = component.get("c.opportunityRec");
                            component.set("v.Spinner", false);
                            act.setParams({"opp" : oppId });
                            act.setCallback(this,function(response){	
                                var state = response.getState();
                                console.log('state   - ' + state );
                                if(state == "SUCCESS"){
                                    var returnVal1 = response.getReturnValue();
                                    console.log('returnVal1   - ' + returnVal1 );
                                    component.set("v.opp",returnVal1);
                                    
                                    var opportunity=component.get("v.opp");
                                    var stage=opportunity.StageName;
                                    var isTopUp = false;
                                    if(opportunity.Scheme_Master__r!=null && opportunity.Scheme_Master__r.istopup__c!=null) 
                                    	isTopUp=opportunity.Scheme_Master__r.istopup__c;
                                    console.log('stage   - ' + stage );
                                    console.log('isTopUp   - ' + isTopUp );
                                    
                                    console.log('disabled   - ' + component.get("v.isAddNewDisabledn") );
                                    if((stage=='Moved To Finnone')||(isTopUp==false))
                                    //if(returnVal1=='CIBIL & CAM')
                                    {
                                        
                                        component.set("v.disabled", true);
                                        component.set("v.isAddNewDisabledn",true);
                                        component.set('v.isAddNewDisabled', true);
                                    }
                                    console.log('disabled11   - ' + component.get("v.isAddNewDisabledn") );
                                }
                            });
                            
                            $A.enqueueAction(act);
                			
            			}
                        
        			} catch(err) {
                        console.debug('Error in Customer --> ' + err.message + ' stack --> ' + err.stack);
                    }
                });
                $A.enqueueAction(fetchPicklistValues);
            }
        });
       	$A.enqueueAction(action);
        
       
        
		/*var objArray = [{
            "Id": "1",
            "Existing_LAN": "123456789",
            "Balance": "1000",
            "Customer_Name": "J Doe",
            "Disbursement_Type": "Fresh",
            "Api_Response": "SUCCESS"
        }, {
            "Id": "2",
            "Existing_LAN": "234567891",
            "Balance": "2000",
            "Customer_Name": "K Doe",
            "Disbursement_Type": "Fresh",
            "Api_Response": "SUCCESS"
        }, {
            "Id": "3",
            "Existing_LAN": "345678912",
            "Balance": "3000",
            "Customer_Name": "M Doe",
            "Disbursement_Type": "TopUp",
            "Api_Response": "SUCCESS"
        }];


        console.log('obj Array :' + JSON.stringify(objArray));
        component.set('v.data', objArray);
         this.setDisbTypeOptions(component, event, helper);*/
        
	},
    
    handleSelectAll: function(component, event, helper) 
    {
        //get the header checkbox value  
        var selectedHeaderCheck = event.getSource().get("v.value");
        // get all checkbox on table with "boxPack" aura id (all iterate value have same Id)
        // return the List of all checkboxs element 
        var getAllId = component.find("boxPack");
        // check if select all (header checkbox) is true then true all checkboxes on table in a for loop  
        // and set the all selected checkbox length in selectedCount attribute.
        // if value is false then make all checkboxes false in else part with play for loop 
        // and select count as 0 
        if (selectedHeaderCheck == true) {
            for (var i = 0; i < getAllId.length; i++) {
                component.find("boxPack")[i].set("v.value", true);
            }
        } else {
            for (var i = 0; i < getAllId.length; i++) {
                component.find("boxPack")[i].set("v.value", false);
            }
        }
    },
    removeDeletedRow: function(component, event, helper) {
        var index = event.currentTarget.dataset.index;
        var oppId = component.get("v.oppId");
        var opportunity=component.get("v.opp");
        var stage=opportunity.StageName;
        console.log('stage1   - ' + stage );
        console.log('index'+index);    
        var AllRowsList = component.get("v.lstTopUp");
        AllRowsList.splice(index, 1);
        component.set("v.lstTopUp", AllRowsList);
        var remove = component.get("c.deleteRow");
        component.set("v.Spinner", true);
        remove.setParams({"index" : index , "oppId": oppId });
        remove.setCallback(this,function(response){	
            var state = response.getState();
            console.log('state   - ' + state );
            if(state == "SUCCESS"){
                var returnVal = response.getReturnValue();
                console.log('returnVal   - ' + returnVal );
                this.initialize(component,event,helper)
                var sObjectEvent = $A.get("e.c:TopUpEvent");
        		sObjectEvent.fire();
                
            }
        });
        
		this.initialize(component,event,helper)
        component.set("v.Spinner", false);
        $A.enqueueAction(remove);
        
    },
    /*handleDelRow: function(component, event, helper) {
        // create var for store record id's for selected checkboxes  
        var delId = [];
        // get all checkboxes 
        var getAllId = component.find("boxPack");
        var iArray = [];
        // play a for loop and check every checkbox values 
        // if value is checked(true) then add those Id (store in Text attribute on checkbox) in delId var.
        for (var i = 0; i < getAllId.length; i++) {
            if (getAllId[i].get("v.value") == true) {
                delId.push(getAllId[i].get("v.text"));
                iArray.push(i);
            }
        }
        
        if($A.util.isEmpty(delId) ){
        	alert('Please select at least one checkbox.');
        }
        else
        {
        	
            console.log('indices to del : ' + iArray);
            var existingArr = component.get("v.lstTopUp");
            var newArr = [];
            for(var i in existingArr )
            {
                var flag = true;
                for(var j in delId)
                {
                    if(delId[j] == existingArr[i].Id){
                        flag = false;
                        break;
                    }
                    else{
                        flag = true;
                    }
                }
                
                if(flag){
                    newArr.push(existingArr[i]);
                }
            }
            
            console.log('before push: ' + JSON.stringify(newArr) );
            
            component.set("v.lstTopUp", newArr);
            
            
            /*var valuesArr = component.get("v.data");
            for (var i = iArray.length -1; i >= 0; i--)
            {
   				valuesArr.splice(iArray[i],1);
            }
            component.set("v.data", valuesArr);
            
        }
        
    },*/
    handleAddRow: function(component, event, helper)
    {
        console.log('before Add Row');
        var data = component.get('v.lstTopUp');
        var oppId = component.get("v.oppId");
        console.log('data --------------'+data.length);
        if(data.length == 5){
            component.set('v.isAddNewDisabled', true);
            alert('You can not add more than 5 records ...!!! ');
        }
        else{
            var existingArray = component.get("v.lstTopUp");
            /*var action = component.get("c.addRowObject");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var returnVal = response.getReturnValue();
                    existingArray.push(returnVal);    
                    component.set("v.lstTopUp", existingArray);
                }
                
            });
            $A.enqueueAction(action);*/
            
             var objToAdd ={
                //"Id": "",
                "ExistingLAN__c": "",
                "BalanceAmount__c": 0,
                 "LoanApplication__c":oppId,
                "DisbursementType__c": "--NONE--",
                "CustomerName__c": "",
                "ApiResponse__c": "",
                "sobjectType":"TelePDQuestionMaster__c"
            };
            existingArray.push(objToAdd);    
            component.set("v.lstTopUp",existingArray); 
            
            /*var objToPush = {
                "Id": "4",
                "ExistingLAN__c": "456789123",
                "BalanceAmount__c": "4000",
                "CustomerName__c": "L Doe",
                "DisbursementType__c": "Parallel",
                "ApiResponse__c": "SUCCESS"
            };
            
            //var existingArray = component.get("v.data");
            var existingArray = component.get("v.lstTopUp");
            
            existingArray.push(objToPush);
            component.set("v.lstTopUp" , existingArray);
            this.setDisbTypeOptions(component, event, helper);*/
    	}
    },
    
    setDisbTypeOptions : function(component, event, helper)
    {
        var lstSelectOption = component.find('InputSelectDynamic');
        for (var i in lstSelectOption) 
        {
            if($A.util.isEmpty(lstSelectOption[i].get("v.options") ) )
            {
                var opts = [{
                    class: "optionClass",
                    label: "Close Existing",
                    value: "Close Existing"
                }, {
                    class: "optionClass",
                    label: "Parallel",
                    value: "Parallel"
                }, {
                    class: "optionClass",
                    label: "TopUp",
                    value: "TopUp"
                }];
                lstSelectOption[i].set("v.options", opts)
            }
        }
	},
    
    validateBeforeSave: function(component, event, helper){
        console.log('before save');
        var data = component.get('v.lstTopUp');
        var oppId=component.get('v.oppId');
        console.log('data for saving : ' + JSON.stringify(data));
        
        var flag = false;
        for(var i in data)
        {
            
            if(!flag)
            {
            	var tempLAN = data[i].ExistingLAN__c;
                var bal=data[i].BalanceAmount__c;
                var type=data[i].DisbursementType__c;
                if(bal==0 && type=='Close Existing')
                {
                    flag = true;
                    alert('Can not save as balance amount is 0.');
                }
               for(var j in data)
                {
                    if(j === i){
                        console.log(j + ' == ' + i);
                        continue;
                    }
                    else
                    {
                        if(tempLAN === data[j].ExistingLAN__c){
                            flag = true;
                            alert('Same id found. Please check.');
                            break;
                        }
                       
                    }
                }    
            }
        else
            {
                break;
            }
  
        }
        console.log('data---'+data);
        
        console.log('Data for Saving.  ' + JSON.stringify(data) );
        if(flag==false){
        var saveRec = component.get("c.saveRecord");
        component.set("v.Spinner", true);
            saveRec.setParams({"teleRec" : JSON.stringify(data) ,"oppId":oppId,"isDisbDashboard":component.get("v.isDisbDashboard")}); //Bug:23506--Added isDisbDashboard to argument
        saveRec.setCallback(this,function(response){	
            var state = response.getState();
            console.log('state   - ' + state );
            if(state == "SUCCESS"){
                var returnVal = response.getReturnValue();
                console.log('returnVal   - ' + JSON.stringify(returnVal) );
                if (response.getReturnValue() != '') {
                 	alert(response.getReturnValue());
                    component.set("v.Spinner", false);
                }else{
                    this.initialize(component,event,helper)
                    var title = "Success";
                    var message = "Record Saved Successfully ...!!!";
                    var type = "success";
                    var fadeTimeout = 3000;
                    this.displayMessage(component, title, message, type, fadeTimeout, true);
                    
                    var sObjectEvent = $A.get("e.c:TopUpEvent");
                    sObjectEvent.fire();
                    component.set("v.Spinner", false);
                }
                 
            }
        });
       
        $A.enqueueAction(saveRec);
        } 
        
    },
    
    fetchPOS : function(component,event,helper) {
        console.log('state   - '  );
        var data = component.get('v.lstTopUp');
                
        var flag = false;
        for(var i in data)
        {
            
            if(!flag)
            {
            	var tempLAN = data[i].ExistingLAN__c;
                var tempbal = data[i].BalanceAmount__c;
                var tempType= data[i].DisbursementType__c;
                for(var j in data)
                {
                    if(j === i){
                        console.log(j + ' == ' + i);
                        continue;
                    }
                    else
                    {
                        if(tempLAN === data[j].ExistingLAN__c){
                            flag = true;
                            alert('Same id found. Please check.');
                            break;
                        }
                       
                    }
                }    
            }
        else
            {
                break;
            }
  
        }
        if(flag==false){
        var fetch = component.get("c.fetch");
        component.set("v.Spinner", true);
        fetch.setParams({"lan" : data });
        fetch.setCallback(this,function(response){	
            var state = response.getState();
            console.log('state   - ' + state );
            if(state == "SUCCESS"){
                var returnVal = response.getReturnValue();
                //Bug 19193: Top Up Changes (Garima) Start - To get count of negative POS amount records
                var negativePOS = '';
                if(returnVal){
                	negativePOS = returnVal.split(";")[1];
                }
                var title = "Success";
                var message = "POS Details fetched Successfully ...!!!";
                if(negativePOS > 0){
                    message+='\n'+'Negative POS amount fetched for '+negativePOS+' LAN.';
                }
                //Bug 19193: Top Up Changes (Garima) End
                var type = "success";
                var fadeTimeout = 3000;
                console.log('Return value*****'+returnVal);
                // Bug 23362 ***S**
                if(returnVal && returnVal.includes('EXCEPTION:')){
                    message = returnVal.split('EXCEPTION:')[1].split(";")[0];
                }
                // Bug 23362 ***E**
                if(returnVal){ // Bug:20465 Added null check to show alert only if non null value returned
                	alert(message);
                } //bug 20465 null check end
                this.displayMessage(component, title, message, type, fadeTimeout, true);
                var sObjectEvent = $A.get("e.c:CloneEvent");
                sObjectEvent.fire();
                this.initialize(component,event,helper);
                console.log('after js init');
                component.set("v.Spinner", false);
            }
            else
            {
                console.log('exception ');
                //smthing went wrng
            }
        });
        $A.enqueueAction(fetch);
        }
        
	},
    displayMessage : function(component, title, message, type, fadeTimeout, isAutoClose) {
        console.debug('Inside EDGE');
    	$A.createComponent(
            "c:ToastMessage",
            {
                "title": title,
                "message": message,
                "type": type,
                "fadeTimeout": fadeTimeout,
                "isAutoClose" : isAutoClose
            },
            function(newComp) {
                var body = [];
                body.push(newComp);
                component.set("v.body", body);
                console.debug('--------------------------'+JSON.stringify(body));

            }
        );    
    },
})