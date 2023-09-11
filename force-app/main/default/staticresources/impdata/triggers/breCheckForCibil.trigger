trigger breCheckForCibil on CIBIL__c (after insert,after update) {
    try{
        
        List<CIBIL__c> newCibilList = Trigger.new;
        List<CIBIL__c> oldCibilList = Trigger.old;
        system.debug('newtttttttt->'+newCibilList);
        system.debug('oldtttttttt->'+oldCibilList);
        Boolean runCibilBRECheck = false;
        if(Trigger.isInsert){
        	if(!CommonUtility.isEmpty(newCibilList))
        		runCibilBRECheck = true;
        }else{
        	if(!CommonUtility.isEmpty(oldCibilList) && !CommonUtility.isEmpty(newCibilList)){
            	if(newCibilList[0].CIBIL_Score__c != oldCibilList[0].CIBIL_Score__c){
            		runCibilBRECheck = true;
            	}
        	}
        }
        if(runCibilBRECheck)
        	CommonUtility.BRECalloutCibilCheck(new Map<String,String>{'cibil_id'=>newCibilList[0].Id});
    }catch(Exception ex){
    
    }
}