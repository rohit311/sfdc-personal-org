({
	toggleAssVersion : function(component, event, helper) {
    	//helper.toggleAssVersion(component, event);     
    },
    doInit : function(component, event, helper){
       // alert('in doint');
       /* CR 22307 s */
            var stage = component.get("v.stageName");
            if(stage == 'Underwriting' || stage == 'Re-Appraise- Loan amount' || stage == 'Re-Appraise- IRR' || stage == 'Re-Appraise- Reject Case' || stage == 'Re-Appraise- Tenor')
            {
             component.set("v.displayReadOnly",false);
            } 
            else{
            component.set("v.displayReadOnly",true);
            }
            /* CR 22307 e */
        // Bug 23064 start
            if(stage == 'Underwriting' && component.get("v.salesprofilecheck") == true)
            { 
                component.set("v.displayReadOnly",true);
                
            } 
            // Bug 23064 stop
    },
    DestroyChildCmp: function(component, event, helper) {
        component.set("v.body",'');
        component.destroy();
    },
    setParentAttributVar: function(component, event, helper) {
     if(event.getParam("SecName") == "sanction"){ 
                 component.set("v.discrepancyList", event.getParam("discrepancyList"));
      }
        var sanctionList = component.get("v.discrepancyList");
         if(!$A.util.isEmpty(sanctionList)){
            for(var i=0 ; i< sanctionList.length ; i++){
                if(!$A.util.isEmpty(sanctionList[i].Status__c) && (sanctionList[i].Status__c == 'Pending' || sanctionList[i].Status__c =='Re-opened')) {
                    component.set("v.SanctionFinalOutput",'Not done');
                    break;
                }
                else if(sanctionList[i].Status__c !== 'Pending' || sanctionList[i].Status__c !== 'Re-opened'){
                    component.set("v.SanctionFinalOutput",'Done');
                }
         }
                
              
        }
    }
})