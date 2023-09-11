({
    fetchData : function(component, event){
        
        if(!$A.util.isEmpty(component.get("v.appNew")))
        {
        this.executeApex(component , "fetchEkycRec",{"parentId":component.get("v.appNew").Id}, function(error,result){
                                                                console.log('in ekyc callback '+result);
                                                                var response = JSON.parse(result);
            													if(response != null && response.status == 'SUCCESS'){
                													component.set("v.isEkycDone",true);
                                                                    component.set("v.kyc",response.ekycmobility);
                                                                    console.log('in ekyc callback '+response.ekycmobility.eKYC_Address_details__c);
                                                                    //Bug 21064 S
                                                                    if(response.ekycmobility != null && response.ekycmobility != undefined && response.ekycmobility.eKYC_Address_details__c != null && response.ekycmobility.eKYC_Address_details__c.includes('---')){
                                                                        
                                                                        component.set("v.ekycAddress",response.ekycmobility.eKYC_Address_details__c.replace('---',''));
                                                                    	console.log(response.ekycmobility);
                                                                    }
                                                                    //Bug 21064 E
                                                                    if(response.ekycmobility != null && response.ekycmobility.bio_Ekyc__c == true){
                                                                    	component.set("v.ekycSource",'Bio - metric');    
                                                                    }
                                                                    else{
                                                                        component.set("v.ekycSource",'OTP');
                                                                    }
            												    }	
           														else{
                													component.set("v.isEkycDone",false);				
            													}							            
                       });
        }
                        },
	activateTab: function(component, tabId) {
        
        $A.util.removeClass(component.find("KYCTab"), "slds-active");
       
        $A.util.addClass(component.find(tabId), "slds-active");
        
        this.showHideDiv(component, "KYCTabContent", false);
        
        this.showHideDiv(component, tabId+"Content", true);
    },
     showHideDiv: function (component, divId, show) {
        console.log('divId>>' + divId + '  ' + show);
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
    saveEkyc: function(component, event){
      console.log('robin  ');
      var kyc = component.get("v.kyc");
      var self = this;
        if(kyc != null && kyc != undefined){
            this.executeApex(component , "saveEkycForOpp",{"params":{"appPrime":JSON.stringify([component.get("v.appNew")]),
                                                                     "kyc":JSON.stringify([component.get("v.kyc")])}},
                             										 function(error,result){
                                                                         console.log('in ekyc callback '+result);
                                                                         var response= JSON.parse(result);
                                                                         console.log(response);
                                                                         if(response != null && (response.status.toUpperCase() == 'SUCCESS')){
                                                                          	self.fetchData(component,null);	
                                                                         }
                                                                     });
            
        }  
        
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
    }
})