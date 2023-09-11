({
    getDedupeRecord : function(component) {
        
        var loanId = component.get("v.loanId");
        console.log('loanId  ------ ' + loanId );
        if(loanId != null){
            var act = component.get("c.getDedupeRec");
            act.setParams({"loan" : loanId });
            act.setCallback(this,function(response){	
                var state = response.getState();
                if(state == "SUCCESS"){
                    
                    var returnVal = response.getReturnValue();
                    
                    
                    component.set("v.Dedupe",response.getReturnValue());
                    
                }
            });
            $A.enqueueAction(act);
        }
        
    },
    
    getOpportunityObj : function(component) {
        
        var loanId = component.get("v.loanId");
        if(loanId != null){
            var act = component.get("c.getOpportunity");
            act.setParams({"loan" : loanId });
            act.setCallback(this,function(response){	
                var state = response.getState();
                if(state == "SUCCESS"){
                    var returnVal = response.getReturnValue();
                    console.log('return val: ' + returnVal);
                    component.set("v.LoanApplication",response.getReturnValue());
                }
                var customer=response.getReturnValue().CUSTOMER__c;
                var prodoffer=response.getReturnValue().Product_Offerings__r;
                var newarr=[];
                
                console.log('prodoffer:::' +  JSON.stringify(prodoffer) );
                debugger;
                if(typeof prodoffer!='undefined')
                {
                    console.log('hence proved PO is not undefeind');
                    if(typeof customer!='undefined')
                    {
                        console.log('hence proved customer is not undefeind');
                        var app=response.getReturnValue().Loan_Application__r;
                        for(var i in app)
                            {
                                if(app[i].Applicant_Type__c!='Primary')
                                {
                                    newarr.push(app[i]);
                                }
                                
                            }
                        component.set("v.Applicants",newarr);
                    }
                    // -- 23710 :: Added all the applicants if Customer is null and PO is not null. 
                    else
                    {
                        component.set("v.Applicants",response.getReturnValue().Loan_Application__r);
                    }
                }
                else
                {
                    component.set("v.Applicants",response.getReturnValue().Loan_Application__r);
                }
            });
            $A.enqueueAction(act);
        }
        
    },
    
    
    getDedupeRecordForApplicant : function(component) {
        
        var loanId = component.get("v.loanId");
        var appId = component.get("v.selectedApplicant");
        console.log('loanId  ------ ' + loanId );
        if(loanId != null){
            var act = component.get("c.getDedupeRecApplicant");
            act.setParams({
                "loan" : loanId ,
                "appId" : appId
            });
            act.setCallback(this,function(response){	
                var state = response.getState();
                if(state == "SUCCESS"){
                    
                    var returnVal = response.getReturnValue();
                    console.log('APPLICAN DEDUPE : \n'+returnVal);
                    console.log('  component.get("v.selectedApplicant") : '+  component.get("v.selectedApplicant"));
                    if(returnVal.length>0)
                        component.set("v.TotalDedupes" , returnVal.length);
                    else
                        component.set("v.TotalDedupes" , 0);
                    console.log('  component.get("v.TotalDedupes") : '+  component.get("v.TotalDedupes")); 
                    
                    var isDedupeLinkedFlag=false;
                    for(var i = 0, size = returnVal.length; i < size ; i++){
                        console.log(' >> '+returnVal[i].Customer_ID__c);
                        console.log(' \t '+returnVal[i].Applicant__r.Contact_Name__r.CIF_Id__c);
                        console.log(' \t '+returnVal[i].Customer_ID__c);
                        if(typeof returnVal[i]!='undefined' && returnVal[i]!='' && typeof returnVal[i].Customer_ID__c!='undefined' && returnVal[i].Customer_ID__c!='' && typeof returnVal[i].Applicant__r.Contact_Name__r.CIF_Id__c!='undefined' && returnVal[i].Applicant__r.Contact_Name__r.CIF_Id__c!=''){
                            if(returnVal[i].Customer_ID__c===returnVal[i].Applicant__r.Contact_Name__r.CIF_Id__c){
                                console.log('If SAME');
                                //component.set("v.IsDedupeLinked" , true); 
                                isDedupeLinkedFlag=true;
                                console.log('isDedupeLinkedFlag : '+isDedupeLinkedFlag);
                            }
                        }
                    }
                    
                    if(isDedupeLinkedFlag === true ){
                        console.log('Setting IsDedupeLinked true');
                        component.set("v.IsDedupeLinked" , true);
                    }else{
                        console.log('Setting IsDedupeLinked false');
                        component.set("v.IsDedupeLinked" , false);
                    }
                    console.log('  component.get("v.IsDedupeLinked") : '+  component.get("v.IsDedupeLinked"));                    
                    component.set("v.Dedupe",response.getReturnValue());
                    
                    component.set("v.selectedDedupeId" , "");
                    component.set("v.storeRadioValue" , false);
                    component.set("v.storeRadioText" , "");
                    component.set("v.saveBtnLabel","Save");
                    component.set("v.resetBtnLabel","Reset");
                    component.set("v.waitingFlag",false);
                    //15580--S
                    var opportunity=component.get("v.LoanApplication");
                    var stage=opportunity.Sent_To_Finnone__c;
                    
                    console.log('stage   - ' + stage );
                    
                    if(stage==true)
                        
                    {
                        component.set("v.disabled", true);
                        
                    }
                    //15580--E
                }
            });
            $A.enqueueAction(act);
        }
        
    },
    
    updateDedupeLinkingHelper: function(component, event, selectedDedupeId,selectedApplicantId) {
        var action = component.get('c.updateOnDedupeLinking');
        action.setParams({
            "dedupeId": selectedDedupeId,
            "appId":selectedApplicantId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(state);
                if (response.getReturnValue() != '') {
                    console.log('The following error has occurred. updateDedupeLinkingHelper-->' + response.getReturnValue());
                    //component.set("v.PageMsg",'Dedupe Linking Failed!');
                    component.set("v.selectedDedupeId" , "");
                    component.set("v.storeRadioValue" , false);
                    component.set("v.storeRadioText" , "");
                    alert(response.getReturnValue());
                    //this.superRerender();
                    
                } else {
                    console.log('check it--> update successful');
                    //alert(response.getReturnValue());
                    alert('Dedupe Linking successful!');
                    //component.set("v.PageMsg",'Dedupe Linking successful!');
                }  
                //this.onLoad(component, event);
                this.getDedupeRecordForApplicant(component);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    
    updateDedupeLinkingResetHelper: function(component, event, lanId,appId) {
        var action = component.get('c.updateOnDedupeReset');
        action.setParams({
            "loan": lanId,
            "appId":appId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(state);
                if (response.getReturnValue() != '') {
                    console.log('The following error has occurred. updateDedupeLinkingResetHelper -->' + response.getReturnValue());
                    component.set("v.selectedDedupeId" , "");
                    component.set("v.storeRadioValue" , false);
                    component.set("v.storeRadioText" , "");
                    
                    alert(response.getReturnValue());
                    
                    //this.superRerender();
                } else {
                    console.log('updateDedupeLinkingResetHelper -->  successful');
                    //alert(response.getReturnValue());
                    component.set("v.selectedDedupeId" , "");
                    component.set("v.storeRadioValue" , false);
                    component.set("v.storeRadioText" , "");
                    //component.set("v.IsDedupeLinked" , false); 
                    alert('Dedupe Linking Reset successful!');
                    
                    //this.superRerender();
                }  
                //this.onLoad(component, event);
                this.getDedupeRecordForApplicant(component);
                //this.superRerender();
            }
            
        });
        $A.enqueueAction(action);
    }
})