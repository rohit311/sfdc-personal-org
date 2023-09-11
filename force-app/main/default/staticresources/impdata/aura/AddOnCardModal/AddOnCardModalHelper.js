({
    fetchAddOnData : function(component, event) {
        debugger;
        try{
        var solObjList = ["Charge_Type__c"];
        var selectListNameMap = {};
        selectListNameMap["SOL_Policy__c"] = solObjList;
        //this.showhidespinner(component,event,true);
        console.log('param1*****'+component.get("v.solId"));
        console.log('param2*****'+component.get("v.loanId"));
        console.log('param3*****'+JSON.stringify(selectListNameMap));
        this.executeApex(component, "fetchAddOnSolObject", {
            "solId": component.get("v.solId"),
            "Loanid":component.get("v.loanId"),
            "objectFieldJSON":JSON.stringify(selectListNameMap)
        }, 
                         function (error, result) {
                             console.log('result : ' + result);
                             if (!error && result) {
                                 if(result == 'Fail'){
                    				this.showhidespinner(component,event,false);
                                 }else{
                                 var result = JSON.parse(result);
                                 var picklistFields = result.picklistData;
                                 var solPickFlds = picklistFields["SOL_Policy__c"];
                                 component.set("v.chargeTypeLst", solPickFlds["Charge_Type__c"]); 
                                 console.log('SOLresult : ' +JSON.stringify(result.solObj));
                                 if(result.solObj)
                                     component.set("v.sol",result.solObj);
                                 }
                             }                   
                         }
                        );
            }catch(exception){
            console.log('exception is'+exception);
            this.showhidespinner(component,event,false);
        } 
    },
    saveAddOnDetails : function(component, event) {
        debugger;
         try{
        var sol = component.get("v.sol");
            
        console.log('hd '+sol.Charge_Type__c);
        sol.Loan_Application__c = component.get("v.loanId");
        sol.Applicant_Name__c = component.get("v.appId");
        console.log('applicantname '+component.get("v.appId"));
        this.showhidespinner(component,event,true);
        this.executeApex(component, "saveAddOnCardDetails", {
            "sol": JSON.stringify(sol),
            "loanId":component.get("v.loanId")//added for bug id 5284 /24667
        }, function (error, result) {
            if(!error && result){
			 //added for cr 5284 /24667 start
                console.log('result is::'+result);
                if(result == 'EMIError')
                    	 this.displayToastMessage(component,event,'Success','EMI Card is not present !','error');
                else{
                    var updsol = JSON.parse(result);//added for cr 5284 /24667 stop
                //var updsol = result;//commented for cr 5284 /24667 stop
                console.log('saveAddOnDetails res '+JSON.stringify(result));
                this.handleSuccess(component,event,updsol);
                this.displayToastMessage(component,event,'Success','Add-on Card added successfully!','success');
				}
                this.showhidespinner(component,event,false);
            }   
            else{
                this.displayToastMessage(component,event,'Error','Failed to save record!','error');
                this.showhidespinner(component,event,false);
            }
        }
                        ); 
             }catch(exception){
            console.log('exception is'+exception);
            this.showhidespinner(component,event,false);
        } 
        
    },
    executeApex: function(component, method, params,callback){
        
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
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
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    handleSuccess : function(component, event,addOnsolObj){
        //console.log('in success'+solId);
        this.showhidespinner(component,event,true);
        var disbEvent = component.getEvent('updateAddOnSolList');
        console.log('disbEvent '+disbEvent);
        disbEvent.setParams({
            "addOnsolObj" : addOnsolObj,
            "addOnsolID" :addOnsolObj.Id
        });
        disbEvent.fire();
        component.destroy();
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
    },
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
            
        });
        showhideevent.fire(); 
    },
})