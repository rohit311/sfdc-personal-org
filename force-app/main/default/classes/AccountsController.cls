public class AccountsController {

    @AuraEnabled
   public static List<Account> getAccounts() {
       return [SELECT Id, name, industry, Type, NumberOfEmployees, TickerSymbol, Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode
       FROM Account ORDER BY createdDate ASC];
   }   
    
   @AuraEnabled
    public static list<Account> retriveAccs(String strAccName) {
        strAccName = '%' + strAccName + '%';
        list<Account> lstAccs = [SELECT  Id, Name, Industry, Phone, Type From Account WHERE Name LIKE :strAccName];

        if(lstAccs.isEmpty()) {
           // throw new Exception('No Record Found..');
        }
        return lstAccs; 
    }

}