public with sharing class AccountController {

    @AuraEnabled
    public static List<Account> findAll() {
        System.debug('Inside findAll');
    return [SELECT id, name, Location__Latitude__s, Location__Longitude__s
            FROM Account
            WHERE Location__Latitude__s != NULL AND Location__Longitude__s != NULL
            LIMIT 50];
    }

    @AuraEnabled
    public static Account fetchAccount(String accId){
    return [SELECT id, name,Potential_Value__c,Customer_ID__c,NumberofLocations__c,SLAExpirationDate__c,Industry,(SELECT Name,Title,Email FROM Contacts),
            (SELECT Name,StageName,Amount,CloseDate FROM Opportunities),(SELECT Subject,Priority,Status,CaseNumber FROM Cases)
            FROM Account
            WHERE Id = :accId];

    }

    // 76
    public static Account duplicateAccount(Account accRec) {
      return accRec.clone(false,false,false,false);
    }

}