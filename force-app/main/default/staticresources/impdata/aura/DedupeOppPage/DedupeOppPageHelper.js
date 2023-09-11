({
	 displaySec : function(component,event,secId) {
      var acc = component.find(secId);
            for(var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');  
            $A.util.toggleClass(acc[cmp], 'slds-hide');  
       }
    },
     getoppDetailsonLAN : function(component, event) {
         console.log('pk3'+ component.get('v.LANnumber'));
        var action = component.get('c.getDedupeOppDetails');
        action.setParams({
            "LANnumber" : component.get('v.LANnumber')
            
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state == "SUCCESS") {
                console.log('success');
                if(!$A.util.isEmpty(response.getReturnValue())){
                    var data = JSON.parse(response.getReturnValue());
                    console.log('pk');
                    console.log(data);
                    if (!$A.util.isEmpty(data.isCommunityUsr)){
                        component.set('v.iscommunityUser', data.isCommunityUsr);
                    }
                    if (!$A.util.isEmpty(data.theme))
                         component.set('v.theme', data.theme);
                    if (!$A.util.isEmpty(data.opp))
                        component.set('v.opp',data.opp);
                    if (!$A.util.isEmpty(data.accObj)){
                        component.set("v.account", data.accObj);
                        if(!$A.util.isEmpty(data.accObj.PANNumber__c)){
                            var stringX='';
                            var pannumber = data.accObj.PANNumber__c,i=0;
                            for(i=0;i<(pannumber.length-4);i++){
                                stringX = stringX + 'X';
                            }
                            stringX = stringX +  pannumber.substring(pannumber.length - 4);
                            component.set("v.accPANNO",stringX);
                        }
                    }
                        
                     if(!$A.util.isEmpty(data.cibilExt1)) 
                    {
                        component.set("v.cibilExt1", data.cibilExt1);   
                    }
                     if(!$A.util.isEmpty(data.cibilobj))
                    {
                        component.set("v.cibil", data.cibilobj);   
                    }
                    if (!$A.util.isEmpty(data.applicantPrimary))
                        component.set("v.applicantPrimary", data.applicantPrimary);
                    if (!$A.util.isEmpty(data.objCon)){ 
                        if(!$A.util.isEmpty(data.objCon.Office_Email_Id__c)){
                            var officemeailid = data.objCon.Office_Email_Id__c;
                                var string0 = officemeailid.split('@')[0];
                            	var replacestring = '';
                            
                                for(var i=0;i<string0.length;i++){
                                    replacestring = replacestring + 'X';
                                }
                            	replacestring = replacestring + '@' + officemeailid.split('@')[1];
                            	data.objCon.Office_Email_Id__c = replacestring;
                        }
                         component.set("v.conObj", data.objCon);
                    }
                       
                    if (!$A.util.isEmpty(data.camObj))
                    	component.set("v.cam", data.camObj); 
                    if (!$A.util.isEmpty(data.srcamObj))
                    	component.set("v.srcamObj", data.srcamObj); 
                    if (!$A.util.isEmpty(data.allApps)){
                        var stringY ='';
                        for(var i=0;i<data.allApps.length;i++){ 
                        if(!$A.util.isEmpty(data.allApps[i].Contact_Name__c) && !$A.util.isEmpty(data.allApps[i].Contact_Name__r.PAN_Number__c)){
                            stringY = '';
                            for(var j=0;j<(data.allApps[i].Contact_Name__r.PAN_Number__c).length - 4 ;j++){
                                stringY= stringY + 'X';
                            }
                            stringY =stringY +  data.allApps[i].Contact_Name__r.PAN_Number__c.substring(data.allApps[i].Contact_Name__r.PAN_Number__c.length - 4);
                        	data.allApps[i].Contact_Name__r.PAN_Number__c = stringY;
                        }
                        }
                        component.set("v.coappList", data.allApps); 
                    }
                    	
                   // alert(component.get("v.coappList").length);
                    if (!$A.util.isEmpty(data.bankObj)){
                       if(!$A.util.isEmpty(data.bankObj.Bank_Account_Number__c)){
                          	stringZ = '';
                          for(var i=0;i< (data.bankObj.Bank_Account_Number__c.length - 4);i++){
                           	stringZ = stringZ + 'X';
                      	  }
                        	stringZ = stringZ + data.bankObj.Bank_Account_Number__c.substring(data.bankObj.Bank_Account_Number__c.length - 4);
                            data.bankObj.Bank_Account_Number__c = stringZ; 
                        }
                         component.set("v.bankObj", data.bankObj); 
                        
                    }
                    	
                    /*
                    <div class="slds-form-element slds-is-required slds-p-top--x-small slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--3-of-6 slds-large-size--4-of-12">
                                    <div class="slds-form-element__control">
                                        <lightning:input label="Monthly Reimbursement" value="{!v.cam.Monthly_Reimbursement__c}" name="reim" disabled="true"/>
                                    </div>
                                </div>   
                                <div class="slds-form-element slds-is-required slds-p-top--x-small slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--3-of-6 slds-large-size--4-of-12">
                                    <div class="slds-form-element__control">
                                        <lightning:input label="Rental Income"  value="{!v.cam.Rental_Income__c}" name="rentalim" disabled="true"/>
                                    </div>
                                    
                                </div>
                    
                   
                    
                   */
                    
                    
                    
                } 
                
            }
            else
                console.log('error');
            // this.displayMessage(component, 'displayErrorToast', 'displayErrorMsg', '<b>Error!</b>,Error while processing!');
        });
        $A.enqueueAction(action);
        
    }
})