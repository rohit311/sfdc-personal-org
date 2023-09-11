({
	getOpsChecklistData : function(component) {
    
    var oppId = component.get("v.oppId");
    this.executeApex(component, "getProductOffering", {"loanId" :  oppId}, function(error, result){
      console.log('Disb Opp id ' +oppId);
        if(!error && result.length>0){
          console.log(result);
          component.set("v.AddressChange",result[0].Address_Change_flag__c);
          console.log('address change' + component.get("v.AddressChange"));
            $A.util.isEmpty()
           if(!($A.util.isEmpty(result[0].eKYC__r)))
           {
                if( result[0].eKYC__r[0].eKYC_Aadhaar_Number__c != undefined && result[0].eKYC__r[0].eKYC_Aadhaar_Number__c != null)
                { console.log('inside if');
                   component.set("v.ekycops",true); console.log('ekyc 3' +component.get("v.ekycops"));
                }
               else
               {   console.log('inside else');
                   component.set("v.ekycops",false);
                   
               }
            }
            }else
            {
                 this.ShowToast(component, "Warning!","Error occured , Please check respective data 1", "warning");
            }
        });
        //8594 55
         this.executeApex(component, "getFiles", {"loanId" :  oppId}, function(error, result){
          console.log('sixe' +result.length);
          if(!error && result.length>0){
          var i;
          for( i = 0 ; i < result.length ; i++)
          {    
              var test;
              test = result[i].ContentDocument.Title;
              console.log('test '+test );
              //Added by Rohan for Bug ID 20028
              if(test.indexOf('DEGREE CERTIFICATE') >= 0)
              {
                  component.set("v.fileOpsCheck" , 'true');
              }
                  
            
          }
            //console.log('Files Result' +result[6].ContentDocument.Title);
          console.log(result);
         // component.set("v.fileList",result.ContentDocument.Title);               
            }else{
                 component.set("v.fileOpsCheck" , 'false');
                 console.log('file check' +component.get("v.fileOpsCheck"));
            }
        });
        
        
        // Bug 23801 S
        this.executeApex(component, "OpsDashboard", {"oppId" :  oppId}, function(error, result){
          console.log('sixe' +result);
            debugger;
          if(!error && result){
             
              console.log('result is'+JSON.stringify(result));
              if(result.CDDValid!=null && result.CDDValid!='' && result.CDDValid!= undefined){
                  component.set("v.cddApproved",result.CDDValid);
              }
              if(result.repaymentValid!=null && result.repaymentValid!='' && result.repaymentValid!= undefined){
                  component.set("v.repaymentApproved",result.repaymentValid);
              }
              if(result.nsdlPanValid!=null && result.nsdlPanValid!='' && result.nsdlPanValid!= undefined){
                  component.set("v.nsdlApproved",result.nsdlPanValid);
              }
              if(result.impsValid!=null && result.impsValid!='' && result.impsValid!= undefined){
                  component.set("v.impsApproved",result.impsValid);
              }
              if(result.creditCardValid!=null && result.creditCardValid!='' && result.creditCardValid!= undefined){
                  component.set("v.creditCardApplied",result.creditCardValid);
              }
               //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement  start
              if(result.consentAgreement!=null && result.consentAgreement!='' && result.consentAgreement!= undefined){
                  component.set("v.consentAgree",result.consentAgreement);
              }
              if(result.consentApplication!=null && result.consentApplication!='' && result.consentApplication!= undefined){
                  component.set("v.consentApp",result.consentApplication);
              }
               //bug 24927
              if(result.isGCOoPS!=null&&result.isGCOoPS!=''&&result.isGCOoPS!=undefined){
                  component.set("v.isGCODisFlag",result.isGCOoPS);
              }
              //Bug 23676 - February 2019 - OTP Based acceptance of E-Application and E-Agreement  end
             //Bug 24528 S
              if(result.ccEligible!=null && result.ccEligible!='' && result.ccEligible!= undefined){
                  component.set("v.ccEligible",result.ccEligible);
              }
              //Bug 24528 E
              //   //Bug 24927 S
             if(result.isGCO!=null && result.isGCO!='' && result.isGCO!= undefined){
                  console.log('result.isGCO'+result.isGCO);
                  component.set("v.isGCO",result.isGCO);
              }
               if(result.isAddrchanged!=null && result.isAddrchanged!='' && result.isAddrchanged!= undefined){
                  console.log('result.isAddrchanged'+result.isAddrchanged);
                  component.set("v.isAddrchanged",result.isAddrchanged);
              }
			 //Bug 24927 E
              if(result.exceptionMsg!=null && result.exceptionMsg!='' && result.exceptionMsg!= undefined){
                  this.ShowToast(component, "Warning!", result.exceptionMsg, "warning");
              }
				
            }
           else if(result == null || result == undefined || result == ''){
   				this.ShowToast(component, "Warning!","Error occured , Please check respective data", "warning");
            }
        });
         // Bug 23801 E
        
        component.set("v.isOpenOps", true);
        
	},
    
    executeApex: function(component, method, params, callback){
        var action = component.get("c."+method); 
        action.setParams(params);
        component.set("v.spinnerFlag","true");
        action.setCallback(this, function(response) {
            component.set("v.spinnerFlag","false");
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
                this.ShowToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    ShowToast : function(component, title, message, type){
        var ShowToastEvent = $A.get("e.c:ShowToastEvent");
        console.log('ShowToastEvent -->' + ShowToastEvent);
        ShowToastEvent.setParams({
            "title": title,
            "message":message,
            "type":type,
        });
        ShowToastEvent.fire();
    },
})