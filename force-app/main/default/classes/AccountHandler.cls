public with sharing class AccountHandler {

   public static Account insertNewAccount(String n)
   {

       Account acct;       
try { 
    acct = new Account(Name=n);
    //insert acct; 
    Contact con = new Contact(LastName = n);
    insert con;
} catch (DmlException e) { 
    return null;
 
} 
 return acct;
   
   }
 
 public static void insertAccount(Integer n){
     List<Account> addAccounts = new List<Account>();
     
     while(n>0){
         Account acc = new Account(Name = 'Acme Inc '+n ,AccountNumber = 'A000'+n );
         addAccounts.add(acc);
         n--;
     }
     
     insert addAccounts;
     
 }
}