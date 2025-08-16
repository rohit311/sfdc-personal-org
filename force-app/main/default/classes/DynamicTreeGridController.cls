public with sharing class DynamicTreeGridController {
    public DynamicTreeGridController() {

    }

    @AuraEnabled(Cacheable=true)
    public static List<Account> getParentAccounts(){
      try {
        return [SELECT Name, Type FROM Account WHERE ParentId = NULL LIMIT 20];
      } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
      }
    }

    @AuraEnabled
    public static List<Account> getChildAccounts(Id parentId){
      try {
        return [
            SELECT Name, Type, Parent.Name
            FROM Account
            WHERE ParentId = :parentId
        ];
      } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
      }
    }
}