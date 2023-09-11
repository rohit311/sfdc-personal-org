({
    createLoanHelper : function(component,successfulRecordList){
        console.log('Inside createloan***'+JSON.stringify(successfulRecordList));
        var utility = component.find("toastCmp");
        var createLoan = component.get("c.createLoanFromCSV");
        createLoan.setParams({
            "successData" : JSON.stringify(successfulRecordList)            
        });
        createLoan.setCallback(this,function(response){
            var status = response.getState();
            component.set("v.isProcessing", false);
            if(status === "SUCCESS"){
                var resp = response.getReturnValue();
                if(resp.includes('EXCEPTION')){
                    console.log('An error occurred: '+resp.split('EXCEPTION')[1]);
                    utility.showToast('Error!', 'An error occurred while calling batch to create loan', 'error'); 
                }
                else{
                    utility.showToast('Success!', 'Congratulations! Loan application has been submitted successfully!', 'success'); 
                }
            }
            else if(status === "ERROR"){
                var errors = response.getError();
                if (errors[0] && errors[0].message) {
                    //component.set("v.errorMsg", errors[0].message);
                    console.log('Error message****'+errors[0].message);
                    //alert('error');
                    utility.showToast('Error!', 'Error occurred while calling method to create loan.', 'error'); 
                } 
            }
        }); 
        $A.enqueueAction(createLoan);
    },
    
    
    initializeData : function(component, event, helper)
    {
        var srcLabelValues=$A.get("$Label.c.csv_Upload_Sourcing_Channel");
        var objToAdd ={
            "First_Name__c": "",
            "Middle_Name__c":"",
            "Last_Name__c":"",
        };
        component.set("v.custScripName",objToAdd);
        component.set("v.selectedSourceChannel", '');
        component.set("v.branchName", '');
        
        ///clearing lookup component for Branch 
        var childCmp = component.find("branch");
        childCmp.clearLookup();
        
        component.set("v.showInsurance",false);
        
        var srcChannel = [];
        
        if(srcLabelValues){
            srcChannel = srcLabelValues.split(';');
        }
        
        var sChannelList = [];    sChannelList.push({label:'--None--', value: null});
        if (srcChannel)
        {
            for(var i =0; i< srcChannel.length; i++)
            {
                if (srcChannel[i])
                {
                    sChannelList.push({
                        label : srcChannel[i],
                        value : srcChannel[i]
                    });
                }
            }
        }
        
        /*****start -- 26645 fetching all the picklist values from Backend *****/
        var action = component.get("c.fetchPicklistValues");
        action.setCallback(this, function(response){
            //console.log('Response: '  + response.getReturnValue() );
            var obj = JSON.parse(response.getReturnValue() );
            var gender = obj.Gender;
            var	state = obj.State;
            var city = obj.City;
            var occupation = obj.Occupation;
            var profession = obj.Profession;
            var marital_status = obj.Marital_Status;
            console.log(obj);
            
            var genderList = [];	genderList.push({label:'--None--', value: null});
            for(var v of gender.split(',')){
                genderList.push({
                    label : v,
                    value : v
                });
            }
            component.set("v.genderList" , genderList);
            //===================Gender below ==========================================
            var stateList = [];	genderList.push({label:'--None--', value: null});
            for(var v of state.split(',')){
                stateList.push({
                    label : v,
                    value : v
                });
            }
            component.set("v.stateList" , stateList);
            //===================occupation below ==========================================
            var occupationList = [];	occupationList.push({label:'--None--', value: null});
            for(var v of occupation.split(',')){
                occupationList.push({
                    label : v,
                    value : v
                });
            }
            component.set("v.occupationList" , occupationList);
            //===================profession below==========================================
            var professionList = [];	professionList.push({label:'--None--', value: null});
            for(var v of profession.split(',')){
                professionList.push({
                    label : v,
                    value : v
                });
            }
            component.set("v.professionList" , professionList);
            //===================MaritalStatus below ==========================================
            var maritalStatusList = [];	maritalStatusList.push({label:'--None--', value: null});
            for(var v of marital_status.split(',')){
                maritalStatusList.push({
                    label : v,
                    value : v
                });
            }
            component.set("v.maritalStatusList" , maritalStatusList);
            //===================State below==========================================
            var stateList = [];	stateList.push({label:'--None--', value: null});
            for(var v of state.split(',')){
                stateList.push({
                    label : v,
                    value : v
                });
            }
            component.set("v.stateList" , stateList);
            //===================City below==========================================
            var cityList = [];	cityList.push({label:'--None--', value: null});
            for(var v of city.split(',')){
                cityList.push({
                    label : v,
                    value : v
                });
            }
            component.set("v.cityList" , cityList);
            
        });
        $A.enqueueAction(action);
        /*****end   -- 26645 fetching all the picklist values from Backend *****/
        
        component.set("v.sourceChannelList",sChannelList);
        console.log('Sourcing channels****'+JSON.stringify(component.get("v.sourceChannelList")));
    }
    
})