({   
    fetchDataFromServer: function(component)
    {
        //Fetching object data from Server.        
        if(!component)	return;	//Deliberating written the same 
        var fetchBlindData = component.get("c.fetchBlindDataObjs");
        var utility = component.find("toastCmp");
        
        //to avoid calling for the null component. 
        if(!fetchBlindData)	return;
        fetchBlindData.setParams({oId : component.get("v.oId") });
        fetchBlindData.setCallback(this, function(response){
            var resObjs = response.getReturnValue();
            
            var objMap = JSON.parse(resObjs);
            var errVal = objMap.Error;
            if(errVal)
            {               
                component.set("v.noBlindDataEntry", true);
                if(errVal.indexOf('ByPass') == -1)
                {
                    utility.showToast('Error!', errVal , 'error');                    
                }
                
				return;                
            }
            
            var  oppVal  = objMap.loan;
            if(oppVal){
                component.set("v.opp", oppVal);
            }
            
            var appVal = objMap.PrimaryApplicant;
            if(appVal){                
                component.set("v.primaryApplicant" , appVal);
            }
            
            var pdVal = objMap.PersonalDiscussion;
            if(pdVal)
            {
                component.set("v.pdObj" , pdVal);
            }
            
            var pickVals = objMap.lDF;
            if(pickVals)
            {
                var optsDF = [];    optsDF.push({ label: '--None--', value: null });                
                for(var i =0; i< pickVals.length; i++)
                {
                    if (pickVals[i])
                    {
                        optsDF.push({
                            label : pickVals[i],
                            value : pickVals[i]
                        });
                    }
                }
                
                component.set("v.optionsDF", optsDF);
            }
            
            var pickValAcType = objMap.lAT; 
            if(pickValAcType)
            {
                var optsAT = [];    optsAT.push({ label: '--None--', value: null });                
                for(var i =0; i< pickValAcType.length; i++)
                {
                    if (pickValAcType[i])
                    {
                        optsAT.push({
                            label : pickValAcType[i],
                            value : pickValAcType[i]
                        });
                    }
                }
                
                component.set("v.optionsAT", optsAT);
            }
            
            var rmdVal = objMap.RMD;
            if(rmdVal){
                component.set("v.repayObj" , rmdVal);
            }
        });
        $A.enqueueAction(fetchBlindData);
    },
    
    saveData : function(component)
    {
        var saveAction = component.get("c.saveBlindData");
        var utility = component.find("toastCmp");
        
        var strPD = JSON.stringify(component.get("v.pdObj"));
        var strApp = JSON.stringify(component.get("v.primaryApplicant"));
        var oppId = component.get("v.oId");
        
        saveAction.setParams({rPD : strPD, rPA: strApp, oId : oppId});
        
        saveAction.setCallback(this, function(response){
            var retVal = response.getReturnValue();
            
            if('SUCCESS' == retVal)
            {
                component.set("v.isProcecssing" , false);
                utility.showToast('Success!', 'Blind Data Entry Saved Successfully!' , 'success');
            }
            else
            {
                var retVal = ret.substring(7 , retVal.length-1);
                component.set("v.isProcecssing" , false);
                utility.showToast('Error!', retVal , 'error');
            }
            
        });
        
        $A.enqueueAction(saveAction);
    }
})