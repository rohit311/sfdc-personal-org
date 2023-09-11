public class displayRecordCntrl {


    @AuraEnabled
    public static List<Account> fetchAccount(String accId){
        
        return [SELECT Name,Customer_ID__c,Potential_Value__c FROM Account WHERE Id = :accId];
    }

}