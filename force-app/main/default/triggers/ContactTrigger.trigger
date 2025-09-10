/**
 * 
 * 1) When a Contact is created under an Account with Is_Active__c = true,   
the Account’s Address__c should automatically flow into the Contact’s Contact_Address__c.  
  
2) If an Active Contact’s Contact_Address__c is updated, then it's Account’s Address__c should also be updated with this value. After that, all Active Contacts under the same Account should sync their Contact_Address__c with the updated Account Address__c.  
  
(Note: You're not allowed to use Account Trigger)
 * */

trigger ContactTrigger on Contact (before insert, after update) {
    if (Trigger.isBefore && Trigger.isInsert) {
        ContactTriggerHandler.beforeInsertHandler(Trigger.new);
    }
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        ContactTriggerHandler.afterUpdateHandler(Trigger.oldMap, Trigger.newMap);
    }
}