({
    saveEMICard : function(component,event) {
        debugger;
        component.set("v.spinnerFlag","true");
        var identifierFlag;
        if(component.get("v.isLAFlag")){
            identifierFlag='LAN';
        }else{
            identifierFlag='PO'; 
        }
        var oldva = component.get("v.OldVAl");
        var isvalid = true;
        var list = ["prefrence"];
        for (var i = 0; i < list.length; i++) {
            if (component.find(list[i]) && component.find(list[i]).get("v.required") == true && $A.util.isEmpty(component.find(list[i]).get("v.value")))
            {
                isvalid = false;
                component.find(list[i]).showHelpMessageIfInvalid();
            }
        }
        if(isvalid){
            console.log('value selected is --> '+component.get("v.EMICardSelected"));
            this.executeApex(component,"saveEmiDetails",{"idPOLA":component.get("v.IdEMI"),"Identifier":identifierFlag,"value":component.get("v.EMICardSelected")},
                             function(error, result) {
                                 if (!error && result) {
                                     console.log("Sucess of save EMI details");
                                     if(component.get("v.isLAFlag")){
                                         this.callupdateFeesandCharge(component,event);  
                                     }else{
                                         if(component.get("v.EMICardSelected")=='Bundled'){
                                             component.set("v.spinnerFlag","false");
                                              component.set("v.isOpen",false);
                                             this.showtoast(component,event,'Success',"Details Saved Successfully, EMI Card will be processed with Loan Application!",'success');
                                             
                                         }
                                         else{
                                             component.set("v.spinnerFlag","false"); 
                                              component.set("v.isOpen",false);
                                             this.showtoast(component,event,'Success',"Details Saved Successfully!",'success');
                                             
                                         }
                                     }
                                 }else{
                                     component.set("v.spinnerFlag","false");
                                     console.log('error occured');
                                 }
                             });
        }else{
            this.showtoast(component,event,'Error',"Please select EMI Card Preference!!",'error');
            component.set("v.spinnerFlag","false");
        }
    } ,
    executeApex: function(component, method , params , callback){
        var action = component.get("c."+method);
        action.setParams(params);
        console.log('In executeapex');
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('reponse, ',response);
            if (state === "SUCCESS") {
                console.log('Success... ');
                callback.call(this, null, response.getReturnValue());
            } 
            else if (state === "ERROR") {
                console.log('Error calling method'+response.getReturnValue()+method);
                callback.call(this, null, response.getReturnValue());
                
            }
        });
        $A.enqueueAction(action);
    },
    showtoast:function(component,event, title, message, type){
        var self = this;
        console.log('self',self);
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){ //Standard toast message : if supports standard toast message
            console.log('Inside standard toast');
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "3000"
            });    
            toastEvent.fire();
        }else{//Custom toast message : if doesn not support standard toast message
            console.log('inside displayToastMessage'+message+type);
            var showhideevent =  $A.get("e.c:ShowCustomToast");
            console.log('showhideevent--> '+showhideevent);
            showhideevent.setParams({
                "title": title,
                "message":message,
                "type":type
            });
            showhideevent.fire();     
        }
    },
    getEMIcardpref:function(component,helper){
        console.log('Inside getpicklist val');
        component.set("v.spinnerFlag","true");
        this.executeApex(component,"getEMICardValues",{},
                         function(error, result) {
                             if (!error && result) {
                                 console.log("Sucess"+result);
                                 component.set("v.spinnerFlag","false");
                                 component.set("v.PrefrenceList",result);
                             }else{
                                 component.set("v.spinnerFlag","false");
                                 console.log('error occured');
                             }
                         });
    },
    autopopoulatedata: function(component){
        component.set("v.spinnerFlag","true");
        var identifierFlag;
        if(component.get("v.isLAFlag")){
            identifierFlag='LAN';
        }else{
            identifierFlag='PO'; 
        }
        console.log('Id is of passed-->'+component.get("v.IdEMI"));
        this.executeApex(component,"getEMICardPreference",{"IDofEMI":component.get("v.IdEMI"),"identifier":identifierFlag},
                         function(error, result) {
                             if (!error && result) {
                                 console.log("Sucess of autopopulate"+result);
                                 component.set("v.EMICardSelected",result);
                                 component.set("v.OldVAl",result);
                                 component.set("v.EMICardpref",result);
                                 component.set("v.spinnerFlag","false");
                             }else{
                                 component.set("v.spinnerFlag","false");
                                 console.log('error occured');
                             }
                         });
    },
    callupdateFeesandCharge : function(component,event){
        console.log('inside fetchchargesForDSS');
        this.executeApex(component,"callupdateFees",{"loanid":component.get("v.IdEMI")},
                         function(error, result) {
                             if (!error && result) {
                                 console.log("Sucess of fetchcharge"+result);
                                 if(component.get("v.isMobility")&&component.get("v.isLAFlag")){
                                     var EMIfeesevent = $A.get("e.c:handleEmiCardFeesCharges");
                                     console.log('EMIfeesevent-->'+EMIfeesevent);
                                     EMIfeesevent.fire();
                                 }
                                 component.set("v.spinnerFlag","false");
                                 if(component.get("v.isLAFlag")){
                                     console.log('Inside DSS fflow');
                                     component.set("v.isOpen",false);
                                     if(!component.get("v.isMobility"))
                                     location.reload();
                                 }
                                 if(component.get("v.EMICardSelected")=='Bundled'){
                                     component.set("v.spinnerFlag","false");
                                     this.showtoast(component,event,'Success',"Details Saved Successfully, EMI Card will be processed with Loan Application!",'success');
                                 }
                                 else{
                                     component.set("v.spinnerFlag","false"); 
                                     this.showtoast(component,event,'Success',"Details Saved Successfully!",'success');
                                     
                                 }
                             }else{
                                 component.set("v.spinnerFlag","false");
                                 console.log('error occured in fetchcharges');
                                 this.autopopoulatedata(component);
                                 this.showtoast(component,event,'Error!',"Problem processing the request!!",'error');
                                 
                             }
                         });
    }
})