({
	checkCustomer : function(component) {
        try{
            var oppId = component.get("v.oppId");
            console.log('oppId  ------ ' + oppId );
            if(oppId != null){
                var act = component.get("c.checkCustomerRec");
                act.setParams({"opp" : oppId });
                act.setCallback(this,function(response){	
                    			var state = response.getState();
                    			console.debug('state:- '+state);
                                if(state == "SUCCESS"){
                                    console.log('MAP:- '+response.getReturnValue());
                                    var returnVal = response.getReturnValue();
                                    console.log('returnVal   - ' + returnVal );
                                    component.set("v.errorMessage" , 'SUCCESS');
                                    component.set("v.isSuccess", true);
                                    var ecsMap=response.getReturnValue();
                                    var data=JSON.stringify(ecsMap);
                                    var obj=JSON.parse(data);
                                    console.log('ecsMap:- '+data);
                                    if(obj.accNo=='null')
        							{
                                        console.log('ecsMap1:- '+obj.accNo);
                                        component.set("v.disabled", true);
        							}
                                    else if(obj.ERROR=='No Customer'){
                                        component.set("v.errorMessage" , 'Customer is not tagged in Loan Application ...!!!' );
                                        component.set("v.isSuccess", false);
                                        component.set("v.disabled", true);
                                        console.log('v.isSuccess '+component.get("v.isSuccess"));
                                    }else if(obj.APIError=='API Error'){
                                        component.set("v.errorMessage" , 'Problem while processing request Please try again later ...!!!' );
                                        component.set("v.isSuccess", false);
                                    }
                                    
                                    component.set("v.ECSMap",response.getReturnValue());
                                    
                                    
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
        console.log('in Clone Functionality HELPER');
         var oppId = component.get("v.oppId");
        var act = component.get("c.createRepayRecord");
        act.setParams({"LoanId" : oppId , "RepayMap" : component.get("v.ECSMap") });
        console.log('in Clone Functionality HELPER -- '+act);
        act.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var returnVal = response.getReturnValue();
                console.log('returnVal -----'+returnVal);
                if(returnVal.indexOf('SUCCESS') != -1){
                    var title = "Success";
        			var message = "Repayment Details Save Successfully ...!!!";
                    var type = "success";
                    var fadeTimeout = 3000;
                    this.displayMessage(component, title, message, type, fadeTimeout, true);
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
            }
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
})