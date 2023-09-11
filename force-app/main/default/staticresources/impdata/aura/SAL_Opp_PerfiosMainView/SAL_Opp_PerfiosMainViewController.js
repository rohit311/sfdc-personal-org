({
    doInit: function(component, event, helper) {
        var loanId = component.get('v.loan.Id');
        
        
        var action = component.get('c.fetchPerfiosBankAccount');
        action.setParams({
            "fetchLoanApplicationId" : loanId
        });
        
        action.setCallback(this,function(response){	
            var state = response.getState();
            console.log('state is '+state);
            if(state == 'SUCCESS')
            {
                component.set("v.callChilddoinit",true);
                var data = JSON.parse(response.getReturnValue());
                //Rohit added for mcp start 
                if (!$A.util.isEmpty(data) &&  !$A.util.isEmpty(data.accObj)) {
                    component.set('v.account',data.accObj);
                }
                var acc= component.get('v.account');
                if(acc != null && acc.Type_of_Salary__c == 'Perfios')
                {
                    component.set("v.isToDisabled", true);
                }
                
                if (!$A.util.isEmpty(data) &&  !$A.util.isEmpty(data.accObj)) {
                    component.set('v.contact',data.objCo);
                }
                if (!$A.util.isEmpty(data) &&  !$A.util.isEmpty(data.opp)) {
                    component.set('v.loan',data.opp);
                }
                if (!$A.util.isEmpty(data.camObj)) {
                	var camObj = data.camObj;
                    console.log('camobj'+camObj.Id);
                    var amount1 = 0,amount2 = 0,amount3 = 0,averageSal = 0;
                    if(!$A.util.isEmpty(camObj.Average_incentive_for_Q1__c))
                        amount1 = camObj.Average_incentive_for_Q1__c;
                    if(!$A.util.isEmpty(camObj.Average_incentive_for_Q2__c))
                        amount2 = camObj.Average_incentive_for_Q2__c;
                    if(!$A.util.isEmpty(camObj.Average_incentive_for_Q3__c))
                        amount3 = camObj.Average_incentive_for_Q3__c;
                    averageSal = amount1 + amount2 + amount3;
                    if(averageSal != 0)
                        averageSal = parseFloat(averageSal/3).toFixed(2); 
                    component.set("v.averageSal",averageSal);
                }
                
                console.log('averageSal'+amount1+amount2+amount3)
                //Rohit added for mcp stop 
                
                if (!$A.util.isEmpty(data) &&  !$A.util.isEmpty(data.applicantNameList)) {
                    component.set('v.applicantNameList',data.applicantNameList);
                }
                console.log('applicants-->'+data.allApps);
                if (!$A.util.isEmpty(data) &&  !$A.util.isEmpty(data.allApps)) {
                    component.set('v.applicantList',data.allApps);
                }
                if (!$A.util.isEmpty(data) &&  !$A.util.isEmpty(data.bankList)) {
                    component.set('v.bankAccountList',data.bankList);
                }
                console.log('here perfios'+component.get('v.bankAccountList').length);
                component.set('v.bankNameList',data.bankNameList);
                if($A.util.isEmpty(component.get('v.bankAccountList'))){
                    helper.createBankAccountData(component, event);  
                }
                else{
                    var banklst = component.get('v.bankAccountList');
                    component.set("v.bankAccount",banklst[0]);
                }
                    
                
                var banklst = component.get('v.bankAccountList');
                console.log('bankObj'+component.get("v.bankAccValid"));
                /*if(banklst != null){
                    for(var i=0 ;i<banklst.length ; i++)
                    {
                        if(banklst[i] != null && banklst[i].Applicant__r != null && banklst[i].Applicant__r.Applicant_Type__c != null && banklst[i].Applicant__r.Applicant_Type__c == 'Primary')
                        {
                            
                            component.set("v.bankAccount",banklst[i]);
                            component.set("v.bankAccount.Type_Of_Salary__c",banklst[i].Type_Of_Salary__c);
                            if(component.get("v.bankAccount.Type_Of_Salary__c") == 'Perfios')
                            {
                                component.set("v.isToDisabled", true);
                            }
                        }
                    }
                }*/
                var applst = component.get("v.applicantList");
                console.log(applst.length);
                var count = 0;
                if(applst != null){ 
                    for(var i=0 ;i<applst.length; i++)
                    {
                        console.log(applst[i].Id);
                        if(applst[i] != null && applst[i].Applicant_Type__c == 'Financial Co-Applicant')
                        {
                            component.set("v.isFinancialApplicant",true);
                        }
                        
                    }
                }      // console.log('Bank Name' + component.get('v.bankNameList'));
                
            }
            else if(state == 'ERROR')
                console.log('Error while creating Contact Record!!');
        });
        $A.enqueueAction(action);
    },
    SelectPerfios: function(component, event, helper) {
        console.log('in controller');
        console.log('option -->'+component.get("v.account.Type_of_Salary__c"));
        
        if(!$A.util.isEmpty(component.get("v.account.Type_of_Salary__c")))
        {
            if(component.get("v.account.Type_of_Salary__c") == 'Perfios')
            {
                helper.fetchHVT(component,event);
                component.set("v.isToDisabled", true);
                component.set("v.isOpen", true);
            }
            else{
                component.set("v.isToDisabled", false);
                component.set("v.isOpen", false);  
            }
            
        }
        
    },
    initiatePerfiosForAppandCoApp: function(component, event, helper) {
        helper.showhidespinner(component,event,true); 
        if (helper.validateRequired(component, event) == 0) {
          var isValid = true;
          var invalidCount = 0;
         var bankCmp = component.find("bankListCmp");
        
        if ($A.util.isArray(bankCmp)) {
            bankCmp.forEach(cmp => {
                isValid = cmp.isvaliddate();
                console.log('isvaliddate pk'+ isValid);
                if(!isValid){
                	invalidCount++;
            	}
            })
        } else {
           isValid = bankCmp.isvaliddate();
                console.log('isvaliddate pk'+ isValid);
           if(!isValid){
               invalidCount++;
            }
        }
          console.log('isvalidcount pk'+ invalidCount);
            if (invalidCount == 0) {
            var banklst =component.get("v.bankAccountList");
            // alert('1++'+banklst.length);
            //console.log('banklst'+banklst[1].Send_Email_For_Perfios__c);
            if(banklst != null){
                for(var i=0 ;i<banklst.length;i++)
                {
                    //var banklst = JSON.stringify(banklst[i]);
                    
                    delete(banklst[i].Applicant__r);
                    //console.log(banklst);
                    //console.log('banklst'+banklst[i].Applicant__c);
                }
            }
            helper.executeApex(component, "upsertPerfiosBankAccount", {"loanId":component.get("v.loan.Id"), "JSONBankAccountLst" :JSON.stringify(component.get("v.bankAccountList"))}, function(error, result){
                
                console.log('result --> '+result);
                if(!error && result && !result.includes('Exception')){
                    var data = JSON.parse(result);
                    if (!$A.util.isEmpty(data) &&  !$A.util.isEmpty(data.bankList)) {
                        component.set('v.bankAccountList',data.bankList);
                        if(!$A.util.isEmpty(component.get('v.bankAccountList'))){
                            var banklst = component.get('v.bankAccountList');
                            component.set("v.bankAccount",banklst[0]);
                        }
                       /* banklst= data.bankList;
                        if(banklst != null){
                            for(var i=0 ;i<banklst.length ; i++)
                            {
                                if(banklst[i] != null && banklst[i].Applicant__r != null && banklst[i].Applicant__r.Applicant_Type__c != null && banklst[i].Applicant__r.Applicant_Type__c == 'Primary')
                                {
                                    component.set("v.bankAccount",banklst[i]);
                                   // component.set("v.bankAccount.Type_Of_Salary__c",banklst[i].Type_Of_Salary__c);
                                    if(component.get("v.bankAccount.Type_Of_Salary__c") == 'Perfios')
                                    {
                                        component.set("v.isToDisabled", true);
                                    }
                                    
                                }
                            }
                        }*/
                        helper.showhidespinner(component,event,false); 
                    }
                    if (!$A.util.isEmpty(data) &&  !$A.util.isEmpty(data.Perfiosstatus)) {
                        helper.showhidespinner(component,event,false); 
                        //alert(data.Perfiosstatus);
                    }
                    helper.displayToastMessage(component,event,'Success','Perfios initiated successfully','success');
                }
                else{
                    helper.showhidespinner(component,event,false);  
                     helper.displayToastMessage(component,event,'Error','Failed to save record !','error');
                }
                    
            });
        }
            else
              {
            helper.showhidespinner(component,event,false); 
            helper.displayToastMessage(component,event,'Error','Please enter valid date','error');//6216
        }  
        }
        else{
            helper.showhidespinner(component,event,false); 
            helper.displayToastMessage(component,event,'Error','Please fill all required data','error');
        }
    },
    addNewRow: function(component, event, helper) {
        helper.createBankAccountData(component, event);
    },
    SelectNetSalary : function(component, event, helper) {
        console.log(component.get("v.account.Type_of_Salary__c"));
        helper.fetchHVT(component,event);
    },
    closeModel: function(component, event, helper) { 
        component.set("v.isOpen", false);
    },
    SaveHVTDetails: function(component, event, helper) {
        helper.saveHVTDetails(component);
    },
    SaveSalaryDetails: function(component, event, helper) {
        helper.saveSalaryDetails(component);
    },
    showModal : function(component, event, helper) {
        
        document.getElementById("newClientSectionId").style.display = "block";
        
    },
    
    hideModal : function(component,event, helper){
        
        document.getElementById("newClientSectionId").style.display = "none" ;
    }
})