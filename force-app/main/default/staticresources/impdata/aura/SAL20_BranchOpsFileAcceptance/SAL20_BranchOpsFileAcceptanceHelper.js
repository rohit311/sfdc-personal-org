({
	doInitHandler : function(component,event,helper) 
    {
		try
        {
            var action = component.get("c.fetchLoanFields");
            action.setParams({loanId: component.get("v.oppId")} );
            action.setCallback(this, function( res){
                console.log('' + component.get("v.loanRecordError"));
                if ('FAILURE' != res.getReturnValue())
                {
                    var utility = component.find("toastCmp");
                    
                    var response = JSON.parse(res.getReturnValue() );
                    var optsFileAcceptance = JSON.parse(response.FileAcceptance);        
                    var optsLoanVariant =  JSON.parse(response.LoanVariant);
                    var optsLoanType =  JSON.parse(response.LoanType);
                    var optsProductSegment = JSON.parse(response.ProductSegment);

                    var optsFA = [];    optsFA.push({label:'--None--', value: null});
                    var optsLV = [];    optsLV.push({ label: '--None--', value: null });
                    var optsLT = [];    optsLT.push({ label: '--None--', value: null });
                    var optsPS = [];    optsPS.push({ label: '--None--', value: null });
                    
                    if (optsFileAcceptance)
                    {
                        for(var i =0; i< optsFileAcceptance.length; i++)
                        {
                            if (optsFileAcceptance[i])
                            {
                                optsFA.push({
                                    label : optsFileAcceptance[i],
                                    value : optsFileAcceptance[i]
                                });
                            }
                        }
                    }

                    if (optsLoanVariant) 
                    {
                        for (var i = 0; i < optsLoanVariant.length; i++) 
                        {
                            if (optsLoanVariant[i]) 
                            {
                                optsLV.push({
                                    label: optsLoanVariant[i],
                                    value: optsLoanVariant[i]
                                });
                            }
                        }
                    }
                    
                    if (optsLoanType) 
                    {
                        for (var i = 0; i < optsLoanType.length; i++) 
                        {
                            if (optsLoanType[i]) 
                            {
                                optsLT.push({
                                    label: optsLoanType[i],
                                    value: optsLoanType[i]
                                });
                            }
                        }
                    }
                    if (optsProductSegment) 
                    {
                        for (var i = 0; i < optsProductSegment.length; i++) 
                        {
                            if (optsProductSegment[i]) 
                            {
                                optsPS.push({
                                    label: optsProductSegment[i],
                                    value: optsProductSegment[i]
                                });
                            }
                        }
                    }
                    
                    component.find("loanRecordHandler").reloadRecord(true, function(){
                    	var schemeName = component.get("v.loanRecord.Scheme_Master__c");
                        if(schemeName){
                            component.set("v.searchWord",component.get("v.loanRecord.Scheme_Master__r.Name"));                
                        }
                        else{
                          component.set("v.searchWord",null);  
                        }
                    });
                    component.set("v.optionsFileAcceptance" ,optsFA);
                    component.set("v.optionsLoanVariant",optsLV);
                    component.set("v.optionsLoanType",optsLT);
                    component.set("v.optionsProductSegment",optsPS);
                }
                else{
                    utility.showToast('Error!', 'Something went wrong! Please check with your administrator!' , 'error');
                }
            });
            $A.enqueueAction(action);
        }catch(err){
			console.log('Exception occurred while fetching data');                
        }
	}
})