({
    doInit: function(component, event, helper)
    {
        helper.initializeData(component, event, helper);
    },
    
    
    saveCustomer:function(component, event, helper)
    {
        var utility = component.find("toastCmp");
        component.set("v.isProcessing", true);
        try
        {
            var error = false;
            var list = ["selectNCSource","lastName","searchPan","NavSum","Units"];
            
            for (var i = 0; i < list.length; i++) 
            {
                if (component.find(list[i]) && !component.find(list[i]).get("v.validity").valid)
                {
                    error = true;
                    component.find(list[i]).showHelpMessageIfInvalid();
                }
            }
            if(error)
            {
                //alert('Fill all mandatory details');
                utility.showToast('Error!', 'Fill all mandatory details', 'error');
                component.set("v.isProcessing", false);
            }
            else if(!component.get("v.branchName")){
                utility.showToast('Error!', 'Branch Name is required', 'error');
                component.set("v.isProcessing", false);
            }
            else
            {
                console.log('Going for save****'+JSON.stringify(component.get("v.custScripName")));
                //var custScripName = component.get("v.custScripName");
                var saveScrip = component.get("c.saveCustDetails");
                saveScrip.setParams({
                    					scripData:JSON.stringify(component.get("v.custScripName")),
                    					"srcChannelName" : component.get("v.selectedSourceChannel")
                    
                                    });
                saveScrip.setCallback(this,function(response){
                    var resp = response.getState();
                    if(resp == "SUCCESS"){
                        console.log('response on save***'+response.getReturnValue());
                        if(!response.getReturnValue().includes('EXCEPTION')){
                            //alert('Save successful!!!');
                            component.set('v.custScripName',JSON.parse(response.getReturnValue()));
                            component.set("v.showInsurance",true);
                            utility.showToast('Success!', 'Data saved successfully. Please click submit for Loan Creation!' , 'success');
                        }
                        else{
                            var msg=response.getReturnValue();
                            var error = response.getReturnValue().split(':');
                            var msg= ''
                            if(error!=null && error.length>1)
                                msg = response.getReturnValue().split(':')[1];
                            utility.showToast('Error!', msg , 'error');
                            console.log('Error in save***'+response.getReturnValue());
                        }
                    }
                    else{
                        utility.showToast('Error!', 'An error occurred. Please contact your admin', 'error');
                        console.log('Error in save***'+response.getReturnValue());
                    }
                    component.set("v.isProcessing", false);
                });
                $A.enqueueAction(saveScrip);
                /*var custScripName = component.get("v.custScripName");
                console.log('Entered values****'+JSON.stringify(custScripName));
                var custScripNameJson =JSON.stringify(custScripName);
                let csvFilebody = `[${custScripNameJson}]`;
                console.log('Controller body***'+csvFilebody);
                
                console.log('data for server call****'+JSON.stringify(component.get("v.custScripName")));
                
                var fileBody = component.get("c.createString");
                var utility = component.find("toastCmp");
                fileBody.setParams({
                    "scripName" : JSON.stringify(component.get("v.custScripName")),
                    "srcChannelName" : component.get("v.selectedSourceChannel"),
                    "flow" : "Single_Screen"
                    
                });
                
                fileBody.setCallback(this,function(response){
                    var status = response.getState();
                    if(status === "SUCCESS"){
                        var responseData = response.getReturnValue();
                        if(!responseData.includes('EXCEPTION')){
                            console.log('Response returned*****'+responseData);
                            var allRec = JSON.parse(responseData).AllRecordsList;
                            var allRecordsList = JSON.parse(allRec);
                            var allRecMap = JSON.parse(responseData).AllRecordsMap;
                            var allRecordsMap = JSON.parse(allRecMap);
                            var insertMap = JSON.parse(responseData).InsertStatusMap;
                            var insertStatusMap = JSON.parse(insertMap);
                            var successRec = JSON.parse(responseData).SuccessRecList;
                            var successRecList = JSON.parse(successRec);
                            component.set("v.successfulRecords",successRecList);
                            
                            var a = allRecordsList[0]['PANNumber']+'-'+allRecordsList[0]['PolicyNumber']+'-'+allRecordsList[0]['Sfin'];
                            console.log('Key***'+a);
                            
                            var csvStringResult =insertStatusMap[a];
                            if(csvStringResult == 'Success')
                            {
                                //alert('Save successfull');
                                utility.showToast('Success!', 'Data saved successfully !!', 'success');
                                var successfulRecordList = component.get("v.successfulRecords");
                                helper.createloan(component,successfulRecordList);
                            }
                            else
                            {
                                //alert(csvStringResult);
                                utility.showToast('Error!', csvStringResult, 'error');  
                            }
                        }
                        else
                        {
                            //alert('Error occurred');
                            utility.showToast('Error!', responseData, 'error');  
                        }
                        
                    }
                    else if(status === "ERROR"){
                        var errors = response.getError();
                        if (errors[0] && errors[0].message) {
                            console.log('Error message****'+errors[0].message);
                            //component.set("v.errorMsg", errors[0].message);
                            alert('error while calling method to upload record ');
                            utility.showToast('Error!', 'Error occurred while calling method to upload record. Please contact your administrator', 'error'); 
                        } 
                    }
                    component.set("v.isProcessing", false);
                }); 
                $A.enqueueAction(fileBody);*/
            }    
        }
        catch(err){
            console.log('Error while saving***'+err);
            component.set("v.isProcessing", false);
        }
    },
  	
    assignBranchToScripName : function(component, event, helper){
        //console.log('Branch id to fetch :  '  +  JSON.stringify(component.get("v.branchName") ) );
        try
        {
            var o = JSON.parse(  JSON.stringify( component.get("v.branchName") ) );        
            component.set("v.custScripName.Branch_Name__c", o.Name);
            component.set("v.custScripName.Branch_SF_Id__c", o.Id);
        }catch(err){
            console.log('Something went wrong : ' + err);
        }
    },
    
    createLoan : function(component, event, helper)
    {
        var savedRecord = component.get('v.custScripName');
        component.set("v.isProcessing", true);
        helper.createLoanHelper(component, savedRecord)
    }
})