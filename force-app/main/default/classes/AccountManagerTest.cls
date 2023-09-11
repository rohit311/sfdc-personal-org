@isTest
public class AccountManagerTest{
   
   @isTest
   static void testRestService(){
      RestRequest request = new RestRequest();
      Account acc = new Account(Name = 'test');
      insert acc;
// Set request properties
request.requestUri =
    'https://rohit311-dev-ed.my.salesforce.com/services/apexrest/Accounts/'
    + acc.id+'/contacts';
request.httpMethod = 'GET';
// Set other properties, such as parameters
request.params.put('status', 'Working');
// more awesome code here....
// Finally, assign the request to RestContext if used
RestContext.request = request;

Account accNew = AccountManager.getAccount();
   }

}