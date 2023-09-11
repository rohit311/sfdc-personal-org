({
    
    getAllVerifications : function(component){
        console.log('Inside Helpers Doinit');
        var parentId = component.get("v.parentId");
        var flow = component.get("v.flow");
        console.log('flow 11 **'+flow); 
        console.log('inside id'+parentId);
        if(parentId && flow){
            this.executeApex(component, "getAllVerifications",{
                "flow" : flow,
                "vParentID" : parentId
            }, function(error, result){
                console.log('Result11 ', result);
                console.log('Error', error);
                //console.log('Length : '+ result.length);
                if(!error && result ){
                    var count=0; //17138
                    var verificationTypeIfGeoTagging = []; //17138
                    var verificationList = result;
                    //console.log('verificationList : '+ typeof verificationList +JSON.stringify(verificationList));
                    //var wrapperString = JSON.stringify(verificationList);
                    var wrapperList = JSON.parse(verificationList);
                    //component.set("v.verificationList",wrapperList);
                    console.log('verificationList : '+JSON.stringify(verificationList));
                    /*17138 s*/
                    var wrapperListNew = [];
                    for( var i in wrapperList)
                    {
                    	if(component.get("v.flowV2") == 'mobilityV2'){
                        	/*17556 added if else */
                            if(wrapperList[i].verification.Geo_Tagging__c == true){
                            	verificationTypeIfGeoTagging.push(wrapperList[i].verification.Verification_Type__c);
                                count=count+1;    
                            }
                            wrapperListNew.push(wrapperList[i]);
                            /*if(wrapperList[i].verification.Geo_Tagging__c == true && component.get("v.flowV3forPricing") != 'mobilityv2_pricing')
                            {
                                //console.log('asdfasdf'+wrapperList[i].verification.Verification_Type__c);
                                //verificationTypeIfGeoTagging.push(wrapperList[i].verification.Verification_Type__c);
                                //count=count+1;
                                wrapperListNew.push(wrapperList[i]);
                            }
                            else if(wrapperList[i].verification.Geo_Tagging__c == true && $A.util.isEmpty(wrapperList[i].verification.Sales_Status__c) && component.get("v.flowV3forPricing") == 'mobilityv2_pricing')
                            {
                                //console.log('asdfasdf'+wrapperList[i].verification.Verification_Type__c);
                                //verificationTypeIfGeoTagging.push(wrapperList[i].verification.Verification_Type__c);
                                //count=count+1;
                                wrapperListNew.push(wrapperList[i]);
                            }  */ 
                            
                        
                            
                        }   
                        else{
                            //console.log('in check'+wrapperList[i].verification.Verification_Type__c);
                            if(wrapperList[i].verification.Verification_Type__c == 'Office verification' || wrapperList[i].verification.Verification_Type__c == 'Residence verification'){
                            	wrapperListNew.push(wrapperList[i]); 
                            }
                        }
                        
                        /*var showhideevent =  $A.get("e.c:PassCountOfVerificationListToParent");
                    showhideevent.setParams({ "count": count})
                    showhideevent.fire();*/
                    }
                    
                    //console.log('Only Geo tagging  '+verificationTypeIfGeoTagging);
                    if(component.get("v.flowV2") == 'mobilityV2'){
                    	component.set("v.verificationType",verificationTypeIfGeoTagging);
                        console.log(component.get("v.verificationType"));
                    }
                    component.set("v.verificationList",wrapperListNew);
                    /*17138 e*/
                    //console.log('wrapperList Size : '+ wrapperList.length);
                    //for(var i=0; i<wrapperList.length; i++){
                    //    console.log('V : '+ wrapperList[i].imagesCount );
                    //}
                }
            });
        }
    },
    deleteVerification : function(component, verId){
        console.log('Deleting Verification : '+verId);
        this.executeApex(component, "deleteVerification", {
            "verId" : verId
        },function(error, result){
            if(!error){
                this.updateVerificationListEvent(component);
                //this.showToast(component, 'Success!',"Verification record deleted successfully",'success');
                //this.showToast(component, 'Success!', "Customer Details Saved successfully. Please proceed to the next Tab.", 'success');
            }    
        }); 
    },
    updateVerificationListEvent : function(component){
        var verficationUpdateEvent = $A.get("e.c:UpdateVerificationList"); 
        if(verficationUpdateEvent){
            console.log('Got the event');
            verficationUpdateEvent.fire();
        }
    },
    /*17138 s*/
    saveVeriRecords : function(component){
        var validData = true;
        var veriWrapper = component.get("v.verificationList");
        if(veriWrapper != null && veriWrapper.length > 0){
            for(var i=0;i<veriWrapper.length;i++){
                console.log('status'+veriWrapper[i].verification.Sales_Status__c);
                if($A.util.isEmpty(veriWrapper[i].verification.Sales_Status__c) || veriWrapper[i].verification.Sales_Status__c=='--Select--'){
                    validData = false;
                } 
            }
            if(validData){
                
                this.executeApex(component, "saveVerificationStatus", {
                    "verificationList" : JSON.stringify(veriWrapper)
                },function(error, result){
                    if(!error){
                        this.displayToastMessage(component,event, 'Success','Verifications saved successfully','success');
                        this.showhidespinner(component,event,false); 
                    }    
                    else{
                        this.displayToastMessage(component, event,'Error','Failed to save verification.','error');
                        this.showhidespinner(component,event,false); 
                    }
                }); 
            }
            else{
                this.showhidespinner(component,event,false); 
                this.displayToastMessage(component,event, 'Error','Please enter status for all verification','error');
            }
        }
        else{
            this.showhidespinner(component,event,false); 
            this.displayToastMessage(component,event, 'Error','There are no records to save','error');
        }
        
    
    },
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },
    displayToastMessage:function(component,event,title,message,type)
    {
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    },
    /*17138 e*/
    executeApex: function(component, method, params, callback){
        var action = component.get("c."+method); 
        action.setParams(params);
        //console.log('Executing Apex : '+ method);
        action.setCallback(this, function(response) {
            //console.log('Response : '+ response);
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
                this.showToast(component, "Error!", errors.join(", ") , "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    showToast: function(component, title, message, type){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({ 
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "30000"
            });    
            toastEvent.fire();
        } else {
            var toastTheme = component.find("toastTheme1");
            $A.util.removeClass(toastTheme, "slds-theme--error");
            $A.util.removeClass(toastTheme, "slds-theme--success");
            if(type == 'error'){
                $A.util.addClass(toastTheme, "slds-theme--error");
            } else if(type == 'success'){
                $A.util.addClass(toastTheme, "slds-theme--success");
            }
            component.find("toastText1").set("v.value", message);
            component.find("toastTtitle1").set("v.value", title+' ');
            this.showHideDiv(component, "customToast1", true);
        }
    },
    showHideDiv: function(component, divId, show){
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },     
    closeToast: function(component){
        var toastTheme = component.find("toastTheme1");
        if(toastTheme){
            $A.util.removeClass(toastTheme, "slds-theme--error");
            $A.util.removeClass(toastTheme, "slds-theme--success");
            this.showHideDiv(component, "customToast1", false);
        }
    },   
})