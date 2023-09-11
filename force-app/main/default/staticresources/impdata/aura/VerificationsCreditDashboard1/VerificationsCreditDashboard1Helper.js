({
	
    toggleAssVersion : function(component, event) {
        console.log(event.target.getAttribute('id'));
        var click=event.target.getAttribute('id');
        component.set('v.myid',click);
        
        var cls=component.get('v.class') ;
        if(cls=='hideCls'){
            component.set("v.class", 'showCls');
           
            
        }else{
            component.set("v.class", 'hideCls');
        }        
    },
    fetchpicklistdata: function (component, oppId) {
    	var statusselectList = ["Credit_Status__c"];
		var selectListNameMap = {};
		selectListNameMap["Verification__c"] = statusselectList;
		console.log('selectListNameMap' + selectListNameMap);
       this.showhidespinner(component,event,true); 
       var action = component.get('c.getDedupeDetails');
        action.setParams({
            "oppID": oppId,
			"objectFieldJSON": JSON.stringify(selectListNameMap)
            
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            this.showhidespinner(component,event,false); 
            if (state == "SUCCESS") {
                if(!$A.util.isEmpty(response.getReturnValue())){
                    var data = JSON.parse(response.getReturnValue());
                    var picklistFields = data.picklistData;
					var dedupePickFlds = picklistFields["Verification__c"];
				
                    var creditStatusList = ['Complete','Not Required','Insufficient'];
                    //component.set("v.creditStatusList", dedupePickFlds["Credit_Status__c"]);
                    component.set("v.creditStatusList",creditStatusList);
                }
            }else
                console.log('error');
            
        });
        $A.enqueueAction(action);
    },
    saveVerificationRecords : function(component,event){
        
     var verificationList  = [];
      	if(!$A.util.isEmpty(component.get("v.bankVerObj")))
          verificationList.push(component.get("v.bankVerObj"));
        if(!$A.util.isEmpty(component.get("v.OfcVerObj")))
            verificationList.push(component.get("v.OfcVerObj"));
        if(!$A.util.isEmpty(component.get("v.resPerVerObj")))
            verificationList.push(component.get("v.resPerVerObj"));
        if(!$A.util.isEmpty(component.get("v.resCurVerObj")))
            verificationList.push(component.get("v.resCurVerObj"));
        console.log(JSON.stringify(verificationList));
    // var verificationList = component.get("v.verifyList");
     if(!$A.util.isEmpty(verificationList)){
         this.showhidespinner(component,event,true); 
            var action = component.get('c.updateVerificationRecords');
            action.setParams({
                "oppId" : component.get('v.oppId'),
                "verifyRecs" : JSON.stringify(verificationList)
            });
            action.setCallback(this, function(response){
                //this.hideSpinner(component);
                this.showhidespinner(component,event,false); 
                var state = response.getState();
                if (state == "SUCCESS") {
                    console.log('success');
                  
                    var verComplete = true;
                     if (!$A.util.isEmpty(verificationList)){
                        for(var i=0;i<verificationList.length;i++){
                            console.log(verificationList[i].Verification_Type__c.toUpperCase());
                            if(!$A.util.isEmpty(verificationList[i].Verification_Type__c) && verificationList[i].Verification_Type__c.toUpperCase() == 'OFFICE VERIFICATION'){
                                if($A.util.isEmpty(verificationList[i].Credit_Status__c) || verificationList[i].Credit_Status__c == 'Insufficient')
                                    verComplete = false;
                            }if(!$A.util.isEmpty(verificationList[i].Verification_Type__c) && verificationList[i].Verification_Type__c.toUpperCase() == 'PERMANENT ADDRESS VERIFICATION'){
                                if($A.util.isEmpty(verificationList[i].Credit_Status__c) || verificationList[i].Credit_Status__c == 'Insufficient')
                                    verComplete = false;
                            } if(!$A.util.isEmpty(verificationList[i].Verification_Type__c) && verificationList[i].Verification_Type__c.toUpperCase() == 'RESIDENCE VERIFICATION'){
                                if($A.util.isEmpty(verificationList[i].Credit_Status__c) || verificationList[i].Credit_Status__c == 'Insufficient')
                                    verComplete = false;
                            }if(!$A.util.isEmpty(verificationList[i].Verification_Type__c) && verificationList[i].Verification_Type__c.toUpperCase() == 'BANK STATEMENTS'){
                                if($A.util.isEmpty(verificationList[i].Credit_Status__c) || verificationList[i].Credit_Status__c == 'Insufficient')
                                    verComplete = false;
                            }
                        }
                        if(!$A.util.isEmpty(component.get("v.negativeAreastatus")) && component.get("v.negativeAreastatus") == 'Negative' && verComplete)
                   {

                       verComplete = false;
                   }
                         
                        component.set("v.verComplete",verComplete);
                    } 
                      var evt = $A.get("e.c:SetParentAttributes");
                            evt.setParams({
                                "officeverification" : component.get("v.OfcVerObj"),
                                "bankverification" : component.get("v.bankVerObj"),
                                "resPerverification" : component.get("v.resPerVerObj"),
                                "resCurverification" : component.get("v.resCurVerObj"),
                                "SecName":"verify",
                                "verStatus": component.get("v.verComplete")
                            });
                            evt.fire();
                    this.displayToastMessage(component,event,'Success','Details Saved Successfully.','success');
                }
                else{
                   this.displayToastMessage(component,event,'Error','Error Occoured','Error');
                }
            });
            $A.enqueueAction(action);
        }
        else
            alert('No Records to update');
        
    },
    fireVerifications : function(component){
     var verificationList = component.get("v.verifyList");
     var verType = component.get("v.verType");
     this.showhidespinner(component,event,true); 
      var action = component.get('c.fireSALVerifications');
            action.setParams({
                "oppId" : component.get('v.oppId'),
                "verType" : verType
            });
            action.setCallback(this, function(response){
                //this.hideSpinner(component);
                var state = response.getState();
                 if (state == "SUCCESS") {
                    if(!$A.util.isEmpty(response.getReturnValue())){
                        this.showhidespinner(component,event,false); 
                    	var data = JSON.parse(response.getReturnValue());
                        if(!$A.util.isEmpty(data.veriList)){
                            var evt = $A.get("e.c:SetParentAttributes");
                            if(verType == 'Residence verification'){
                                component.set("v.resCurVerObj",data.veriList[0]);
                                evt.setParams({
                                "resCurverification" : data.veriList[0],
                                "SecName":"verify"
                            });
                            }
                            else if(verType == 'PERMANENT ADDRESS VERIFICATION'){
                                component.set("v.resPerVerObj",data.veriList[0]);
                                evt.setParams({
                                "resPerverification" : data.veriList[0],
                                "SecName":"verify"
                            });
                            }
                            else if(verType == 'Office verification'){
                               component.set("v.OfcVerObj",data.veriList[0]);
                                evt.setParams({
                                "officeverification" : data.veriList[0],
                                "SecName":"verify"
                            });
                            }
                            else if(verType == 'Bank Statements'){
                               component.set("v.bankVerObj",data.veriList[0]);
                               component.set("v.bankVerifyDone", "Yes");
                                evt.setParams({
                                "bankverification" : data.veriList[0],
                                    "bankVerifyDone" : "Yes",
                                "SecName":"verify"
                            });
                            }
                            evt.fire();
                            var verifyList = component.get("v.verifyList");
                            verifyList.push(verifyList);
                            this.displayToastMessage(component,event,'Success','Verication created successfully.','success');
                        }
                            
                            
                    }
                }
                else{
                  this.displayToastMessage(component,event,'Error','Error Occoured','Error');
                }
            });
            $A.enqueueAction(action);
          
    },
    showhidespinner:function(component, event, showhide){
      //  alert('in showhide');
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },
    displayToastMessage:function(component,event,title,message,type)
    {
        //alert('inside displayToastMessage'+message+type);
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    }
})