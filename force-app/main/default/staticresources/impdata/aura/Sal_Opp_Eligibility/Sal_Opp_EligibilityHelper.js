({
    executeApex: function(component, method, params,callback){
        console.log('params'+JSON.stringify(params));
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            console.log('in eligibility');
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
                //this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    callEligibiltySegm : function (component){
        console.log('in eligibility');
        
        this.executeApex(component, "callEligibiltySegmentation", {"oppId": component.get("v.oppId"), "camObj" : JSON.stringify(component.get("v.camObj"))}, function(error, result){
            if(!error && result){
                 component.set("v.disablepage",false);
                console.log('Record changed'+result);
                var appData = JSON.parse(result);
                console.log('App Record changed'+appData);
                console.log(appData);
                //$A.get('e.force:refreshView').fire();
                component.set("v.rerender",true);
                component.set("v.camObj",appData.camObj);
                
                //Display Success message
                this.displayMessage(component, 'SuccessToast2', 'successmsg2', '<b>Success!</b> Eligibility calculated successfully!');
                
                console.log('in eligibility'+appData.camObj.Id);
                //console.log('appData.applicantPrimary'+JSON.stringify(appData.applicantPrimary.CAMs__r.records[0].sal_max_loan__c));
                var appEvent = $A.get("e.c:ApplicantData");
                appEvent.setParams({
                    "primaryApp" : appData.applicantPrimary,
                    "cibil" : appData.cibil,
                    "cam" : appData.camObj,
                    "dedupe" : appData.dedupeObj,
                    "cibilExt1" : appData.cibilExt1,
                    "cibilTempObj" : appData.cibilTempObj,
                    "maxEligibleLoanAmtMCP" : appData.maxEligiAmtMCP});
                appEvent.fire();
                //this.hideSpinner(component);
                component.set("v.disablepage",false);
            }
            else if($A.util.isEmpty(result)){
                component.set("v.disablepage",false);
                this.displayMessage(component, 'ErrorToast2', 'errormsg2', '<b>Error!</b> No response from server!');
                //this.hideSpinner(component);
            }else{
                component.set("v.disablepage",false);
                this.displayMessage(component, 'ErrorToast2', 'errormsg2', '<b>Error!</b> Problem occured while calculating eligibility!');
                //this.hideSpinner(component);
            }
        });
    },
    updateCamObj : function(component) {
        console.log('component.get("v.camObj")'+component.get("v.camObj.Tenor__c"));
       // this.showSpinner(component);
        component.set("v.disablepage",true);
        this.executeApex(component, "updateCam", {"camObj": JSON.stringify(component.get("v.camObj"))}, function(error, result){
            if(!error && result){
                if(result == 'Success'){
                    this.callEligibiltySegm(component);
                }
            }
            else if($A.util.isEmpty(result)){
                this.displayMessage(component, 'ErrorToast2', 'errormsg2', '<b>Error!</b> No response from server!');
                component.set("v.disablepage",false);
               // this.hideSpinner(component);
            }else{
                this.displayMessage(component, 'ErrorToast2', 'errormsg2', '<b>Error!</b> Problem occured while calculating eligibility!');
                component.set("v.disablepage",false);
                //this.hideSpinner(component);
            }
        });
    },
     displayMessage: function (component, toastid, messageid, message) {
      
        document.getElementById(toastid).style.display = "block";
        if(component.get('v.theme') == 'Theme4d'){
        var toastClasses = document.getElementById("ErrorToastelg").classList;
             toastClasses.add("lightningtoast");
        document.getElementById("SuccessToastelg").classList.add("lightningtoast");  
         }
         console.log('message'+message);
        document.getElementById(messageid).innerHTML = message;
        
        
        setTimeout(function () {
            document.getElementById(messageid).innerHTML = "";
            document.getElementById(toastid).style.display = "none";
        }, 3000);
      
    },
    closeToastSuc: function (component) {
        document.getElementById('successmsg2').innerHTML = "";
        document.getElementById('SuccessToast2').style.display = "none";
    },
    closeToastErr: function (component) {
        document.getElementById('errormsg2').innerHTML = "";
        document.getElementById('ErrorToast2').style.display = "none";
    },
    
    showSpinner: function (component) {
        this.showHideDiv(component, "waiting", true);
    },
    hideSpinner: function (component) {
        this.showHideDiv(component, "waiting", false);
    },
    showHideDiv: function(component, divId, show){
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
})