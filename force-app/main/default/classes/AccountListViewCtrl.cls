public without sharing class AccountListViewCtrl {

    @AuraEnabled
    public static List<Account> getAccounts(Integer pageSize, Integer pageNumber, String sortField, String sortOrder){
      try {
        String query = 'SELECT Name,Industry,AnnualRevenue from Account order by '+String.escapeSingleQuotes(sortField)+' '+String.escapeSingleQuotes(sortOrder)+' NULLS LAST limit :pageSize offset ' + pageSize*pageNumber;
        return (List<Account>)Database.query(query);
      } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
      }
    }

    @AuraEnabled
    public static Integer getTotalAccountRecords(){
      try {
        String countString = 'SELECT count() FROM Account';
        Integer countOfAccountRecords = Database.countQuery(countString);
        return countOfAccountRecords;
      } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
      }
    }

    @AuraEnabled
    public static List<Account> getAccountsBySearch(String searchKeyword, Integer pageSize, Integer pageNumber){
      try {
        Integer totalRecordsToFetch = pageSize*pageNumber;
        String likeValue = '%'+searchKeyword+'%';
        return [SELECT Name,Industry,AnnualRevenue from Account WHERE Name LIKE :likeValue ORDER BY Name LIMIT :pageSize OFFSET :totalRecordsToFetch];
      } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
      }
    }

    @AuraEnabled
    public static String updateAccounts(String accList) {
      try {

      Map<String,object> accMap = (Map<String,object>)JSON.deserializeUntyped(accList);
      List<Account> accToUpdate = new List<Account>();

      for (String accId : accMap.keySet()) {
        accToUpdate.add(new Account(Id = accId,AnnualRevenue = Integer.valueOf((String)accMap.get(accId))));
      }

      update accToUpdate;
      return 'success';

      } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
      }
    }
}