public with sharing class ParentController1 {

    
    @AuraEnabled
    public static List<Parent1__c> getParent1s(){
        return [SELECT Id,Name,Occupation__c FROM Parent1__c];
    }
}