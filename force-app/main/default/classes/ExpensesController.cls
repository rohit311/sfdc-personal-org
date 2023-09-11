public with sharing class ExpensesController {

    
    @AuraEnabled
    public static LIst<Expense__c> getExpenses(){
        return [SELECT Name,Amount__c,Client__c,Date__c,Reimbursed__c FROM Expense__c];
    }
}