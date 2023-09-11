({
    getAppList : function(component,event,flag) {
        this.executeApex(component, 'retAllApps', 
                         {
                             "recordId": component.get("v.recordId"),
                         }, function(error, result){
                             if (!error && result) {
                                 console.log('result'+result);
                                 var data = JSON.parse(result);
                                 component.set("v.coAppList",data.allApps);
                                 component.set("v.conList",data.allCons);
                                 for(var i =0;i<data.allApps.length;i++){
                                     console.log('data.allApps[i].Applicant_Type__c'+data.allApps[i].Applicant_Type__c);
                                     if(data.allApps[i].Applicant_Type__c == 'Primary'){
                                         component.set("v.primApp",data.allApps[i]);
                                     

                                     }
                                     
                                     
                                 }
                                 component.set("v.theme",data.theme);
                                 console.log('component.get("v.theme")'+component.get("v.theme"))
                                 if(flag){
                                     console.log('fire event');
                                     var showhideevent =  $A.get("e.c:UpdatePerfiosList");
                                     showhideevent.setParams({
                                         "appList": component.get("v.coAppList")
                                     });
                                     showhideevent.fire();
                                 }
                                 this.showhidespinner(component,event,false);
                                 //console.log('result'+component.get("v.primApp").Applicant_Type__c);
                                  console.log('Cibil 3score is'+component.get("v.primApp.CIBIL_Score__c"));
                             } 
                             else{
                                 this.showhidespinner(component,event,true);
                                 //this.displayToastMessage(component,event,'Error','Failed to convert loan application.','error');
                             }
                             
                         });
        
    },
    PANCheck : function(component,event,recAppId){
        this.executeApex(component, 'PANCheckCoApp', 
                         {
                             "recordId": recAppId,
                         }, function(error, result){
                             if (!error && result) {
                                 
                                 console.log('result'+result);
                                 var data = JSON.parse(result);
                                 this.showhidespinner(component,event,false);
                                 var allApps;
								 allApps= component.get("v.coAppList");
                                 for(var i =0;i<allApps.length;i++){
                                     alert(recAppId+allApps[i].Id);
                                     //console.log('data.allApps[i].Applicant_Type__c'+data.allApps[i].Applicant_Type__c);
                                     if(allApps[i].Id ==recAppId){
                                         component.set("v.coAppList[i]",result.currApp);
                                         var ii=component.get("v.coAppList[i]");
                                         console.log(ii);
                                     

                                     }
                                     
                                     
                                 }                               
                             }
                         });
        
        
    },
    editRec : function(component,event,recAppId){
        component.set("v.isOpen",false);
        console.log('recAppId'+recAppId);
        component.set("v.currAppId",recAppId);
        var conList = component.get("v.conList");
        var coAppList = component.get("v.coAppList");
        var curCon;
        var curApp;
        for(var i=0;i<coAppList.length;i++){
            if(coAppList[i].Id == recAppId){
                curApp = coAppList[i];
            }
        }
        for(var i=0;i<conList.length;i++){
            if(conList[i].Id == curApp.Contact_Name__c){
                curCon = conList[i];
            }
        }
        console.log('curApp'+curApp.Id+'curCon'+curCon.Id);
        $A.createComponent(
            "c:Add_CoApplicant",
            {
                "oppId" : component.get("v.recordId"),
                "appId" : component.get("v.currAppId"),
                "primApp" : component.get("v.primApp"),
                "accObj" : component.get("v.accObj"),
                "oppObj" : component.get("v.oppObj"),
                "conNew" : curCon,
                "appNew" : curApp,
                "cityList" : component.get("v.cityList"),
                "currentDate":component.get("v.currentDate"),//23578
                "ckycFlow":component.get("v.ckycFlow"), //23578
            },
            function(newComponent){
                component.set("v.body",newComponent);
            }
        );
        
    },
    reiniCibil : function(component,event,recAppId){
        console.log('inside');
        this.executeApex(component, 'reInitiateCib', 
                         {
                             "recId" : recAppId
                         }, function(error, result){
                             if (!error && result) {
                                 if(result.Applicant_Type__c == 'Primary'){
                                     component.set("v.primApp",result);
                                 }
                                 this.showhidespinner(component,event,false);
                                 this.displayToastMessage(component,event,'Success','CIBIL re-initiated','success'); 
                             } 
                             else{
                                 this.showhidespinner(component,event,false);
                                 this.displayToastMessage(component,event,'Error','Error in CIBIL re-initiation','error');
                             }
                             
                         });
        
    },
    delRec : function(component,event,recId){
        console.log('recId'+recId);
        var coAppList = component.get("v.coAppList");
        console.log('coAppList'+coAppList);
        this.executeApex(component, 'delCoApp', 
                         {
                             "recordId": recId,"oppId":component.get("v.recordId")
                         }, function(error, result){
                             console.log(error+'---'+result);
                             if (!error && result && result.length) {
                                 component.set("v.coAppList",result);
                                 var showhideevent =  $A.get("e.c:UpdatePerfiosList");
                                 showhideevent.setParams({
                                     "appList": component.get("v.coAppList")
                                 });
                                 showhideevent.fire();
                                 this.showhidespinner(component,event,false);
                                 this.displayToastMessage(component,event,'Success','Applicant deleted','success');
                             }
                             else if(!error){
                                 component.set("v.coAppList",result);
                                 this.showhidespinner(component,event,false);
                                 this.displayToastMessage(component,event,'Error','Failed to delete applicant','error');
                             }
                                 else{
                                     this.showhidespinner(component,event,false);
                                     this.displayToastMessage(component,event,'Error','Failed to delete applicant','error');
                                 }
                             
                         });
        console.log('coAppList'+coAppList.length);
        //component.set("v.coAppList",coAppList);
    },
    executeApex: function (component, method, params, callback) {
        console.log('method'+method);
        var action = component.get("c." + method);
        console.log('robin '+action);
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
    showhidespinner:function(component, event, showhide){
        console.log('here');
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
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
    },//29248 start
    FetchCibilDetails : function(component,event){
        this.executeApex(component, 'fetchcibildata', 
                         {
                             "cibilid": component.get("v.cibilId"),
                         }, function(error, result){
                             if (!error && result) {
                                  component.set("v.cibDetails",result);
                                 console.log('cibil data pk'+JSON.stringify(result));
                             }
                             
                         } );
        
        
    },//29248 end
})