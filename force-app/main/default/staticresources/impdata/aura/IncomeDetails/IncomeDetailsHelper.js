({
    saveIncomeDetailsHelper: function(component,event,newCam,newApplicant,myid) {
        console.log('  asdf'+myid);
        this.executeApex(component, 'saveIncomeDetailsMethod', {
            "newCam" :newCam,"newApplicant":newApplicant,"myid":myid
            //"newCam" :'hi',"newApplicant":'hi',"myid":'hi'
            
        },
                         
                         function (error, result) {
                             console.log('result is'+result);
                             if (!error && result) {
                                 var data = JSON.parse(result);
                                 component.set("v.cam", data.camObj); 
                                 component.set("v.applicant",data.currApp);
                                 this.displayToastMessage(component,event,'Success','Income details saved successfully','success');
                                 
                                 this.showhidespinner(component,event,false);
                             }
                             else{
                                 this.displayToastMessage(component,event,'Success','Income details saved successfully','success');
                                 this.showhidespinner(component,event,false);
                             }
                             
                             
                         });
        
        
    },   
    
    loadIncomeDetails : function(component,event) {
        var camSelectList = ["Month1_Doc__c","Month2_Doc__c","Month3_Doc__c"];
        var appSelectList = ["LTA_Frequency__c"];
        var selectListNameMap = {};
        selectListNameMap["CAM__c"] = camSelectList;
        selectListNameMap["Applicant__c"] = appSelectList;
        this.executeApex(component, 'getCam_ApplicantMethod', {
            "myid" :component.get("v.loanid"),'objectFieldJSON':JSON.stringify(selectListNameMap)
        },
                         function (error, result) {
                             if (!error && result) {
                                 var data = JSON.parse(result);
                                 var picklistFields = data.picklistData;
                                 var camPickFlds = picklistFields["CAM__c"];
                                 var appPickFlds = picklistFields["Applicant__c"];
                                 var typeOfIncentiveList = ['Monthly','Quarterly'];
                                 component.set("v.typeOfIncentiveList",typeOfIncentiveList);
                                 component.set("v.Month1_Doc__c",camPickFlds["Month1_Doc__c"]);
                                 component.set("v.Month2_Doc__c",camPickFlds["Month2_Doc__c"]);
                                 component.set("v.Month3_Doc__c",camPickFlds["Month3_Doc__c"]); 
                                 component.set("v.freqList",appPickFlds["LTA_Frequency__c"]); 
                                 console.log('result  Incentive_Monthly_or_Quarterly: '+data.camObj.Incentive_Monthly_or_Quarterly__c);
                                 var typeOfIncentive ;
                                 if(!$A.util.isEmpty(data.camObj)){
                                    typeOfIncentive = data.camObj.Incentive_Monthly_or_Quarterly__c;
                                 }
                                 
                                 var container1 = component.find("monthly");
                                 var container2 = component.find("quarterly");
                                 if(typeOfIncentive=='Monthly')
                                 {
                                     
                                     $A.util.addClass(container2, 'slds-hide'); 
                                     $A.util.removeClass(container1, 'slds-hide'); 
                                     
                                 }
                                 if(typeOfIncentive=='Quarterly')
                                 {
                                     $A.util.addClass(container1, 'slds-hide'); 
                                     $A.util.removeClass(container2, 'slds-hide'); 
                                     
                                 }
                                 component.set("v.cam", data.camObj); 
                                 component.set("v.applicant",data.applicantPrimary) 
                                 
                             }
                         });
        
        
        /*    this.executeApex(component, 'loadAverageMethod', {
            "myid" :component.get("v.loanid"),
        },
                         function (error, result) {
                             if (!error && result) {
                                 console.log('result  : '+result);
                                 component.set("v.cam", result); 
                             }
                         });
              this.executeApex(component, 'loadApplicantMethod', {
            "myid" :component.get("v.loanid"),
        },
                         function (error, result) {
                             if (!error && result) {
                                 console.log('result  : '+result);
                                 component.set("v.applicant", result); 
                             }
                         });
           
      */     
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
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    
    fetchData : function(component, event){
        console.log('here');
        var camSelectList = ["Month1_Doc__c","Month2_Doc__c","Month3_Doc__c"];
        var appSelectList = ["LTA_Frequency__c"];
        var selectListNameMap = {};
        selectListNameMap["CAM__c"] = camSelectList;
        selectListNameMap["Applicant__c"] = appSelectList;
        /*var fieldsList = new Object();
        
        fieldsList ={"fieldList": ["Month1_Doc__c","Month2_Doc__c","Month3_Doc__c"]};*/
        this.executeApex(component,"fetchPicklistDataMethod",selectListNameMap,function(error, result){
            if(!error && result){
                var typeOfIncentiveList = ['Monthly','Quarterly'];
                component.set("v.typeOfIncentiveList",typeOfIncentiveList);
                var response = JSON.parse(result);
                console.log('map data '+response["Month1_Doc__c"]);
                component.set("v.Month1_Doc__c",response["Month1_Doc__c"]);
                component.set("v.Month2_Doc__c",response["Month2_Doc__c"]);
                component.set("v.Month3_Doc__c",response["Month3_Doc__c"]); 
                component.set("v.freqList",response["LTA_Frequency__c"]); 
            }
            
            
        });
    },
    showhidespinner:function(component, event, showhide){
        console.log('in show hide');
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
        console.log('after event fire');
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
    validateData :function (component) {
        var list = ["renInc","monReimb","lapPMT","incq1","inc1","inc2","inc3","lta","hlSal"];
        console.log('list'+list.length);
        var isvalid =true;
        for (var i = 0; i < list.length; i++) {
            console.log('list[i]>>' + list[i]+component.find(list[i]));
            var bankCmp = component.find(list[i]);
            if ($A.util.isArray(bankCmp)) {
                bankCmp.forEach(cmp => {
                    if (!cmp.get("v.validity").valid)
                    {
                    
                    isvalid = false;
                    cmp.showHelpMessageIfInvalid();
                }
                                })
            } else {
                if (!bankCmp.get("v.validity").valid)
                {
                    
                    isvalid = false;
                    bankCmp.showHelpMessageIfInvalid();
                }
            }
            /*if (component.find(list[i]) && !component.find(list[i]).get("v.validity").valid)
            {
               
                isvalid = false;
                component.find(list[i]).showHelpMessageIfInvalid();
            }*/
        }
        
        return isvalid;
    },           
})