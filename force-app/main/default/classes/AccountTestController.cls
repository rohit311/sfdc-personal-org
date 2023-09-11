public class AccountTestController{
 

    public String accountId {get;set;}
    public List<Contact> conList {get;set;}
    
    
    public void relatedContacts()
   {
   
   List<Contact> conList = new List<Contact>();
   
   
   if(accountId != null)
   {
   conList = [SELECT Id,Name FROM Contact WHERE Id IN (SELECT ContactId FROM AccountContactRelation WHERE AccountId = :accountId)];
   }
   }
}