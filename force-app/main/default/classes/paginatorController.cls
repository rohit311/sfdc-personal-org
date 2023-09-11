public with sharing class paginatorController {
    public paginatorController() {

    }


    @AuraEnabled(cacheable=true)
    public static List<Account> fetchRecords(){
      try {
        List<Account> accountList = [SELECT Name,Phone,Active__c FROM Account LIMIT 100];

        return accountList;
      } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
      }
    }
}