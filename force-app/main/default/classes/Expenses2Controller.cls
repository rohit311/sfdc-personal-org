public class Expenses2Controller {

    
    @AuraEnabled
    public static List<Expense__c> getExpenses(){
        
        return [SELECT Id,Amount__c ,Client__c,Date__c,Reimbursed__c FROM Expense__c];
    }
}