({
	doInitHandler : function(component,event,helper) 
    {
        var oppId = component.get("v.oppId");
        var fetchApplicantAction = component.get("c.getapplicantDetails");
        fetchApplicantAction.setParams({"loanId":oppId});
        fetchApplicantAction.setCallback(this, function(response) {
        	var state = response.getState();
            if (state === "SUCCESS") 
            {
                var response = JSON.parse(response.getReturnValue() );
                component.set('v.applicantRecordId', response.applicantId);
                component.set('v.profileName', response.ProfileName);

                component.find("loanRecordHandler").reloadRecord(true, function(){
                    component.set('v.schemeRecordId',component.get('v.loanRecord.Scheme_Master__c'));
                    
                    component.find("schemeMasterRecord").reloadRecord(true, function(){

                        var hybridFlexi = component.get('v.schemeRecord.IsHybridFlexi__c');

                        if(component.get('v.loanRecord.Scheme_Master__c') && hybridFlexi && hybridFlexi == true){
                            component.set('v.IsHybridFlexi',true); //Bug 22413 String value was being assigned to IsHybridFlexi earlier
                        }
                        var unsecuredLabel=$A.get("$Label.c.Top_Up_Unsecured_Products");
                        var loanProduct=component.get('v.loanRecord.Product__c');
                        var loanStageName=component.get('v.loanRecord.StageName');
                        var productCodes=unsecuredLabel.split(";");
                        
                        for(var i=0,size=productCodes.length;i<size;i++)
                        {
                            if(productCodes[i]===loanProduct){
                                component.set('v.dedupeLinkFlag',true);
                                break;
                             }
                         }
                        
                        if(!(loanProduct == 'PSBL' || loanProduct == 'SBS CS PSBL' || loanProduct == 'DOCTORS' || loanProduct == 'PRO')){
                            component.set('v.isdisabled',true);
                        }
                    });
                }); 
                component.find("applicantRecordHandler").reloadRecord();
            }
       });
      $A.enqueueAction(fetchApplicantAction);
      
	},
    
    onSaveHandler : function(component,event,helper)
    {
        var hybridFlexiFlag = component.get('v.IsHybridFlexi');
        var message = '';
        var profile = component.get('v.profileName');
        
        if(component.get('v.IsHybridFlexi')!= 'false')
        {
            var loanProduct = component.get('v.loanRecord.Product__c');
         	var tenor=component.get('v.loanRecord.Approved_Tenor__c');                                  
            var temp = tenor - 12;
            if(hybridFlexiFlag == true && !component.find("pureFlexiPeriod").get("v.value")){
                message='Pure Flexi period is required for hybrid flexi';
            }
            else if(hybridFlexiFlag == true && temp==0){
                message='For Hybrid Flexi Tenor must be greater than 12 .Please change the tenor value or scheme';
            }
            else if(hybridFlexiFlag == true && component.find("pureFlexiPeriod").get("v.value")==0){
                 message='Pure Flexi period cannot be 0 ';  
             }
            else if(hybridFlexiFlag == true && temp!=0 && component.find("pureFlexiPeriod").get("v.value") > temp){
                 message='Pure Flexi period cannot be greater than '+temp;   
            }
        }
        return message;
	},
    
    calculate : function(rate, nper, pv)
    {
        var result = 0.0;
        if (pv && rate && nper) {
            result = Math.round((pv * rate) / (1 - Math.pow(1 + rate, -nper)));
        }
        return result;
    },
    
})