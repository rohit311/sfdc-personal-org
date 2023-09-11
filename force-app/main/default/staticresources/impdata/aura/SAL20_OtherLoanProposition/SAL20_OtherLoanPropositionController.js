({
	doInit : function(component, event, helper) 
    {
        try
        {
            var eliteCardProducts = $A.get("$Label.c.EliteCardProducts").toUpperCase();
            var group=component.get("v.grouptype");
			console.log('group type*****'+group);
            if(component.get('v.oppId'))
            {
                var fetchAction = component.get("c.fetchOtherLoanDetails");
                fetchAction.setParams({"loanId": component.get('v.oppId')});
                fetchAction.setCallback(this, function( res){
                    if(res.getReturnValue())
                    {
                        var response = JSON.parse(res.getReturnValue() );
                        if(response.allApplicants){
                            component.set("v.applicantRecords",JSON.parse(response.allApplicants));
                        }
                        if(response.camObj){
                            component.set("v.camObj",JSON.parse(response.camObj)); 
                        }
                        
                        var optsEMIType = JSON.parse(response.emiType);
                        var optscycleDate = JSON.parse(response.cycleDate);
                        var optsholidayMonths = JSON.parse(response.holidayMonths);
                        var optsEMI = [];    optsEMI.push({label:'--None--', value: null});
                        var optscycle = [];    optscycle.push({label:'--None--', value: null});
                        var optsmonths = [];    optsmonths.push({label:'--None--', value: null});
                        
                        if (optsEMIType)
                        {
                            for(var i =0; i< optsEMIType.length; i++)
                            {
                                if (optsEMIType[i])
                                {
                                    optsEMI.push({
                                        label : optsEMIType[i],
                                        value : optsEMIType[i]
                                    });
                                }
                            }
                        }
                        if (optscycleDate)
                        {
                            for(var i =0; i< optscycleDate.length; i++)
                            {
                                if (optscycleDate[i])
                                {
                                    optscycle.push({
                                        label : optscycleDate[i],
                                        value : optscycleDate[i]
                                    });
                                }
                            }
                        }
                        if (optsholidayMonths)
                        {
                            for(var i =0; i< optsholidayMonths.length; i++)
                            {
                                if (optsholidayMonths[i])
                                {
                                    optsmonths.push({
                                        label : optsholidayMonths[i],
                                        value : optsholidayMonths[i]
                                    });
                                }
                            }
                        }
                        component.set("v.optionsEMItype" ,optsEMI);
                        component.set("v.optionsCycleDate" ,optscycle);
                        component.set("v.optionsHolidayMonths" ,optsmonths);
                        
                        var allApplicants = component.get("v.applicantRecords");
                        
                        /*** For loop begins  ***/
                        for(var i=0;i<allApplicants.length;i++)
                        {
                            if (allApplicants[i].Applicant_Type__c == 'Primary') 
                            {
                                if(allApplicants[i].Contact_Name__c && allApplicants[i].Contact_Name__r.Customer_Type__c != null && allApplicants[i].Contact_Name__r.Customer_Type__c == 'Corporate')
                                {
                                    if(allApplicants[i].CIBIL_Score__c != null && (allApplicants[i].CIBIL_Score__c == '00000' || allApplicants[i].CIBIL_Score__c == '000-1'))
                                    {
                                        component.set("v.isDisabledFFR",false);
                                    }
                                }

                                component.set("v.primaryApplicant",allApplicants[i]);
                                
                                if(component.get("v.primaryApplicant.EMI_Holiday_Months__c"))
                                {
                                    var temp = component.get("v.primaryApplicant.EMI_Holiday_Months__c").split(';');
                                    component.set('v.holidayOptions',temp);
                                }
                            }
                            
                            if(allApplicants[i].Contact_Name__c && allApplicants[i].Contact_Name__r.Customer_Type__c != null && allApplicants[i].Contact_Name__r.Customer_Type__c == 'Corporate' && allApplicants[i].Applicant_Type__c == 'Primary Financial Co-Applicant')
                            {
                                if(allApplicants[i].CIBIL_Score__c != null && (allApplicants[i].CIBIL_Score__c == '00000' || allApplicants[i].CIBIL_Score__c == '000-1'))
                                {
                                    component.set("v.isDisabledFFR",false);
                                }
                            }
                            
                            if(allApplicants[i].Contact_Name__c && allApplicants[i].Contact_Name__r.Customer_Type__c != null && allApplicants[i].Contact_Name__r.Customer_Type__c != 'Corporate') 
                            {
                                if(allApplicants[i].CIBIL_Score__c != null && (allApplicants[i].CIBIL_Score__c == '00000' || allApplicants[i].CIBIL_Score__c == '000-1'))
                                {
                                    component.set("v.isDisabledFFR",false);
                                }
                            }
                        }
                        /*** End of For ****/    
                    }
                    
                    component.find("loanRecordHandler").reloadRecord(true, function(){
                        var loanProduct = component.get('v.loanRecord.Product__c').toUpperCase();
                        var productlist = response.product.toUpperCase();

                        if(productlist.includes(loanProduct)){
                            component.set("v.blindDataFlag",true);  
                        }
                        if(eliteCardProducts.includes(loanProduct)){
                            component.set("v.isEliteCardProduct",true);
                        }
                        
                        /***** Setting flag for view insight that is set on load -- S --****/
                        var disbDate= component.get('v.loanRecord.Disbursal_Date__c');
                        /** Getting todays date in format same as disbursal date -- S -- ***/
                        var today = new Date();
                        var dd = today.getDate();
                        var mm = today.getMonth()+1; //January is 0!
                        var yyyy = today.getFullYear();
                        
                        if(dd<10) {
                            dd = '0'+dd
                        } 
                        
                        if(mm<10) {
                            mm = '0'+mm
                        } 
                        
                        today = yyyy + '-' + mm + '-' + dd;

                        /** Getting todays date in format same as disbursal date -- E -- ***/
                        if(disbDate)
                        {
                            if(today>=disbDate+30)
                            {
                                component.set("v.disabl",true);
                            }
                            else
                            {
                                component.set("v.disabl",false);
                            }
                            
                        }
                        /***** Setting flag for view insight that is set on load -- E --****/
                    }); // End of reload Loan Record
                });
                $A.enqueueAction(fetchAction);
            }
        }catch(err){
            console.log('Exception occurred while fetching data****'+err);                
        }
    },
    
    onCalculateEMIType : function(component, event, helper) 
    {
        var loanData = JSON.stringify(component.get('v.loanRecord'));
        var primaryAppData = JSON.stringify(component.get('v.primaryApplicant'));
        var camObjData = JSON.stringify(component.get('v.camObj'));

        try
        {
            component.set("v.isProcessing",true);
            var calculateEMIAction = component.get("c.calculateEMIType");
            calculateEMIAction.setParams({"loanData": loanData,
                                          "camObjData": camObjData,
                                          "applicantPrimaryData": primaryAppData
                                         });
            calculateEMIAction.setCallback(this, function( res){
                if(res.getReturnValue()){
                    var response  = res.getReturnValue();
                    var resp =[];
                    resp = response.split(':');

                    if(response.includes('SUCCESS')){
                        helper.showToast(component,'Success!', resp[1] , 'success');
                    }
                    else{
                        helper.showToast(component,'Error!', resp[1] , 'error');
                    }
                }
                else{
                    helper.showToast(component,'Error!','An error occurred while EMI calculation. Please contact your administrator.' , 'error');    
                }
                component.set("v.isProcessing",false);   
            });
            $A.enqueueAction(calculateEMIAction);
        }catch(err){
            console.log('Exception occurred while EMI type calculation****'+err); 
            component.set("v.isProcessing",false);
        }
    },
    
    onsubscribeToFFR : function(component, event, helper)
    {
        var applicantData = component.get('v.applicantRecords');
        
        try
        {
            component.set("v.isProcessing",true);

            var subscribeToFFRAction = component.get("c.subscribeToFFR");
            subscribeToFFRAction.setParams({"appListData": JSON.stringify(applicantData),
                                            "loanId": component.get('v.oppId')
                                           });
            subscribeToFFRAction.setCallback(this, function( res){
                if(res.getReturnValue()){
                    var response  = res.getReturnValue();

                    if(response.includes('SUCCESS')){
                        helper.showToast(component,'Success!', 'Subscribe to FFR done Successfully!!' ,'success' );
                    }
                }
                else{
                    helper.showToast(component,'Error!', 'Please contact your administrator' , 'error');     
                }
                component.set("v.isProcessing",false);
            });
            $A.enqueueAction(subscribeToFFRAction);                                
        }catch(err){
            console.log('Exception occurred while subscribe to FFR****'+err);                
        }
    },
    
    onsendToCreditVidya1 : function(component, event, helper) 
    {
        var selectedAppId = event.getSource().get("v.name");
        
        try{
            component.set("v.isProcessing",true);
            
            var sendToCreditVidyaAction = component.get("c.sendToCreditVidya1");
            sendToCreditVidyaAction.setParams({"loanData": JSON.stringify(component.get('v.loanRecord')),
                                               "selectedApplicant": selectedAppId
                                              });
            sendToCreditVidyaAction.setCallback(this, function( res){
                if(res.getReturnValue())
                {
                    var response  = res.getReturnValue();

                    if(response.includes('SUCCESS')){
                        helper.showToast(component,'Success!', response.split(':')[1] ,'success');
                    }
                    else if(response.includes('EXCEPTION')){
                        helper.showToast(component,'Error!', 'Please contact your administrator' , 'error');
                    }
					else if(response.includes('Reinitiate'))
                    {
                        component.set('v.reinitiateCredit',true);    
                    }
					else{
                        helper.showToast(component,'Error!', response , 'error');     
                    }
                }
                else{
                    helper.showToast(component,'Error!', 'Please contact your administrator' , 'error');     
                }
                component.set("v.isProcessing",false);
            });
            $A.enqueueAction(sendToCreditVidyaAction);                                
        }catch(err){
            console.log('Exception occurred initiate insight****'+err);
            component.set("v.isProcessing",false);
        }
    },
    
    oncreditVidyaURLForDisplay : function(component, event, helper) 
    {
        var selectedAppId = event.getSource().get("v.name");
        
        try
        {
            component.set("v.isProcessing",true);
            
            var sendToCreditVidyaAction = component.get("c.creditVidyaURLForDisplay");
            sendToCreditVidyaAction.setParams({"selectedApplicant1": selectedAppId
                                              });
            sendToCreditVidyaAction.setCallback(this, function( res){
                if(res.getReturnValue()){
                    var response  = res.getReturnValue();

                    if(response.includes('EXCEPTION')){
                        helper.showToast(component,'Error!', 'Please contact your administrator' , 'error');
                    }
                    else{
                        window.open(response);
                    }
                }
                else{
                    helper.showToast(component,'Info!', 'URL is blank' , 'info');     
                }
                component.set("v.isProcessing",false);
            });
            $A.enqueueAction(sendToCreditVidyaAction);                                
        }catch(err){
            console.log('Exception occurred while credit vidys url display****'+err);
            component.set("v.isProcessing",false);
        }
    },
    closeCustomToast: function(cmp, evt, helper)
    {	
        helper.closeToast(cmp);
    },
    
    onReinitiateCreditVidya: function(component, event, helper) 
    {
        component.set("v.reinitiateCredit", false);
        try{
            component.set("v.isProcessing",true);
            
            var reinitiateCreditVidyaAction = component.get("c.ReinitiateCreditVidya");
            reinitiateCreditVidyaAction.setParams({"loanData": JSON.stringify(component.get('v.loanRecord'))
                                                  });
            reinitiateCreditVidyaAction.setCallback(this, function( res){
                if(res.getReturnValue()){
                    var response  = res.getReturnValue();
                    if(response.includes('SUCCESS')){
                        helper.showToast(component,'Success!', response.split(':')[1] ,'success');
                    }
                    else{
                        helper.showToast(component,'Error!', response , 'error');
                    }
                }
                else{
                    helper.showToast(component,'Error!', 'Please contact your administrator' , 'error');    
                }
                component.set("v.isProcessing",false);
            });
            $A.enqueueAction(reinitiateCreditVidyaAction);                                
        }
        catch(err){
            console.log('Exception occurred while reinitiate credit vidya****'+err);
            component.set("v.isProcessing",false);
        }
    },
    
    onCancelReinitiate: function(component, event, helper) 
    {
        component.set('v.reinitiateCredit',false);
    },
    
    onsaveFinancialHealth: function(component, event, helper)
    {
        var primaryAppData = JSON.stringify(component.get('v.primaryApplicant'));
        
        try{
            component.set("v.isProcessing",true);
            
            var saveAction = component.get("c.saveFinancialHealth");
            saveAction.setParams({"applicantPrimaryData":primaryAppData
                                 });
            saveAction.setCallback(this, function( res){
                if(res.getReturnValue()){
                    var response  = res.getReturnValue();
                    if(response.includes('SUCCESS')){
                        helper.showToast(component,'Success!', 'Save sucessfull!!!', 'success');
                    }
                }
                else{
                    helper.showToast(component,'Error!','An error occurred while Save. Please contact your administrator.' , 'error');
                }
                component.set("v.isProcessing",false);   
            });
            $A.enqueueAction(saveAction);
            
        }catch(err){
            console.log('Exception occurred while Save****'+err); 
            component.set("v.isProcessing",false);
        }
    },
    
    onsubscribeToEMIH: function(component, event, helper)
    {
        var primaryAppData = JSON.stringify(component.get('v.primaryApplicant'));

        try{
            component.set("v.isProcessing",true);
            
            if(component.get("v.primaryApplicant.EMI_Holiday_Months__c")){
                var subscribeToEMIHAction = component.get("c.subscribeToEMIH");
                subscribeToEMIHAction.setParams({"applicantPrimaryData": primaryAppData,
                                                 "loanProduct": component.get('v.loanRecord.Product__c')
                                                });
                subscribeToEMIHAction.setCallback(this, function( res){
                    if(res.getReturnValue()){
                        var response  = res.getReturnValue();

                        if(response.includes('SUCCESS')){
                            helper.showToast(component,'Success!', 'Subscribe to EMI holidays successfull!!!', 'success');
                        }
                        else if(response.includes('ERROR')){
                            helper.showToast(component,'Error!', response.split(':')[1], 'error');
                        }
                    }
                    else{
                        helper.showToast(component,'Error!','An error occurred while Save. Please contact your administrator.' , 'error');
                    }
                    component.set("v.isProcessing",false);   
                });
                $A.enqueueAction(subscribeToEMIHAction); 
            }
            else{
                helper.showToast(component,'Error!', 'Please enter a value for months', 'error');
            }
            
        }catch(err){
            console.log('Exception occurred while Save****'+err); 
            component.set("v.isProcessing",false);
        }
    },
    
    ondisableEMIHoliday: function(component, event, helper)
    {
        try
        {
            component.set("v.isProcessing",true);
            
            var disableEMIAction = component.get("c.disableEMIHoliday");
            disableEMIAction.setParams({"primaryApp": JSON.stringify(component.get('v.primaryApplicant'))
                                       });
            disableEMIAction.setCallback(this, function( res){
                if(res.getReturnValue())
                {
                    var response  = res.getReturnValue();
                    
                    if(response.includes('SUCCESS')){
                        helper.showToast(component,'Success!', 'EMI Holiday disabled successfully!!' ,'success' );
                    }
                }
                else{
                    helper.showToast(component,'Error!', 'Please contact your administrator' , 'error');     
                }
                component.set("v.isProcessing",false);
            });
            $A.enqueueAction(disableEMIAction);                                
        }catch(err)
        {
            console.log('Exception occurred while disabling EMI Holiday****'+err);
            component.set("v.isProcessing",false);
        } 
    },
    
    handleMonthChange: function (component, event, helper) 
    {
        var selectedValues = event.getParam("value");
        component.set("v.holidayOptions", selectedValues);
        var hMonths;
        if(selectedValues){
            for(var i=0;i<selectedValues.length;i++){
                if(i!=0)
                    hMonths+=';'+selectedValues[i];
                else{
                    hMonths=selectedValues[i]; 
                }
            }
        }
        if(hMonths)
        component.set('v.primaryApplicant.EMI_Holiday_Months__c',hMonths);
    },
})