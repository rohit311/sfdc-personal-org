trigger FamilyAndConsultantDetailsTrigger on Service_To_Sales__c (before insert, after insert, 
    before update, after update, 
    before delete, after delete) {
    
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            FamilyAndConsultantDetailsHandler HandlerObj = new FamilyAndConsultantDetailsHandler(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
            HandlerObj.validatePolicyMembers();
        }
    }
	
	if(Trigger.isBefore) {
        if(Trigger.isDelete) {
			FamilyAndConsultantDetailsHandler HandlerObj = new FamilyAndConsultantDetailsHandler(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
            HandlerObj.updatePremiumAfterDelete();	
		}
	}	
}