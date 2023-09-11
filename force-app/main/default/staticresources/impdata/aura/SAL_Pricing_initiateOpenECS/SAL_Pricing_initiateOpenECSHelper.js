({
    checkCustomer : function(component) {
        try{
            var oppId = component.get("v.oppId");
            
            if(oppId != null){
                var act = component.get("c.checkCustomerRec");
                act.setParams({"opp" : oppId });
                act.setCallback(this,function(response){	
                    var state = response.getState();
                    console.debug('state:- '+state);
                    if(state == "SUCCESS"){
                        
                        var returnVal = response.getReturnValue();
                        
                        component.set("v.errorMessage" , 'SUCCESS');
                        component.set("v.isSuccess", true);
                        var ecsMap=response.getReturnValue();
                        var data=JSON.stringify(ecsMap);
                        var obj=JSON.parse(data);
                        
                        if(obj.accNo=='null')
                        {
                            
                            component.set("v.disabled", true);
                        }
                        else if(obj.ERROR=='No Customer'){
                            component.set("v.errorMessage" , 'Customer is not tagged in Loan Application ...!!!' );
                            component.set("v.isSuccess", false);
                            component.set("v.disabled", true);
                            
                        }else if(obj.APIError=='API Error'){
                            component.set("v.errorMessage" , 'Problem while processing request Please try again later ...!!!' );
                            component.set("v.isSuccess", false);
                        }
                        
                        
                        if(ecsMap.accNo=='null')
                            ecsMap.accNo=' ';
                        if(ecsMap.ifscCode=='null')
                            ecsMap.ifscCode=' ';
                        if(ecsMap.bankName=='null')
                            ecsMap.bankName=' ';
                        if(ecsMap.branchName=='null')
                            ecsMap.branchName=' ';
                        if(ecsMap.accTYPE=='null')
                            ecsMap.accTYPE=' ';
                        if(ecsMap.customerName=='null')
                            ecsMap.customerName=' ';
                        if(ecsMap.endDate=='null')
                            ecsMap.endDate=' ';
                        if(ecsMap.balLimit=='null')
                            ecsMap.balLimit=' ';
                        
                      //  component.set("v.ECSMap",response.getReturnValue());
                        
              			  component.set("v.ECSMap",ecsMap);
                        /*if(response.getReturnValue() != null){
                                        console.debug('First Val - ');
                                    }*/
                                    /*if(returnVal.indexOf('SUCCESS') != -1){
                                        component.set("v.errorMessage" , 'SUCCESS');
                                        component.set("v.isSuccess", true);
                                    }
                                    else if(obj.ERROR=='No Customer'){
                                        component.set("v.errorMessage" , 'Customer is not tagged in Loan Application ...!!!' );
                                        component.set("v.isSuccess", true);
                                        console.log('v.isSuccess '+component.get("v.isSuccess"));
                                    }
                                    else if(returnVal.indexOf('API Error') != -1){
                                        component.set("v.errorMessage" , 'Problem while processing request Please try again later ...!!!' );
                                        component.set("v.isSuccess", true);
                                    } */
                                }
                    
                });
                $A.enqueueAction(act);
            }
        } catch(err) {
            console.debug('Error in checkCustomer --> ' + err.message + ' stack --> ' + err.stack);
        }
    },
    createCloneRepay : function(component){
         if(!this.checkValidEcs(component,event))//22017
          {
            var title = "Info";
            var message = "ECS Bank details i.,e, Bank A/c No/IFSC/MICR/Bank Name is not same as Perfios";
            var type = "info";
            var fadeTimeout = 2000;
            this.displayMessage(component, title, message, type, fadeTimeout, true);
          }
        var oppId = component.get("v.oppId");
        var act = component.get("c.createRepayRecord");
        act.setParams({"LoanId" : oppId , "RepayMap" : component.get("v.ECSMap") });
        
        act.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var returnVal = response.getReturnValue();
                
                if(returnVal.indexOf('SUCCESS') != -1){
                    var title = "Success";
                    var message = "Repayment Details Save Successfully ...!!!";
                    var type = "success";
                    var fadeTimeout = 3000;
                    this.displayMessage(component, title, message, type, fadeTimeout, true);
                                            this.showhidespinner(component,event,false);
                    component.set("v.isOpen" , false);
                    //window.location.reload();
                    var sObjectEvent = $A.get("e.c:CloneEvent");
                    sObjectEvent.fire();
                }
                else
                {
                    var title = "Failure";
                    var message = " Problem while inserting Repayment record...!!!";
                    var type = "error";
                    var fadeTimeout = 3000;
                    this.displayMessage(component, title, message, type, fadeTimeout, true);
                    component.set("v.isOpen" , false);
                    
                }
                                                            this.showhidespinner(component,event,false);

            }
            else
                   this.showhidespinner(component,event,false);
        });
        $A.enqueueAction(act);
    },
    displayMessage : function(component, title, message, type, fadeTimeout, isAutoClose) {
        console.debug('Inside EDGE');
        $A.createComponent(
            "c:ToastMessage",
            {
                "title": title,
                "message": message,
                "type": type,
                "fadeTimeout": fadeTimeout,
                "isAutoClose" : isAutoClose
            },
            function(newComp) {
                var body = [];
                body.push(newComp);
                component.set("v.body", body);
                console.debug('--------------------------'+JSON.stringify(body));
                
            }
        );    
    },
     showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
            
        });
        showhideevent.fire();
    },
    checkValidEcs:function(component, event){
        var ecsMap = component.get("v.ECSMap");
        var bankobj = component.get("v.bankAccount");
        if(!$A.util.isEmpty(ecsMap) && !$A.util.isEmpty(bankobj))
        {
            if(!$A.util.isEmpty(ecsMap.accNo) && !$A.util.isEmpty(bankobj.Perfios_Account_No__c) && ecsMap.accNo == bankobj.Perfios_Account_No__c
              &&  !$A.util.isEmpty(ecsMap.micrCode) && !$A.util.isEmpty(bankobj.MICR_Code__c) && ecsMap.micrCode == bankobj.MICR_Code__c 
              &&  !$A.util.isEmpty(ecsMap.bankName) && !$A.util.isEmpty(bankobj.Perfios_Bank_Name__c) && ecsMap.bankName == bankobj.Perfios_Bank_Name__c
              &&  !$A.util.isEmpty(ecsMap.ifscCode) && !$A.util.isEmpty(bankobj.IFSC_Code__c) && ecsMap.ifscCode == bankobj.IFSC_Code__c)
                return true;
            else
                return false;
        }
    }
    
})