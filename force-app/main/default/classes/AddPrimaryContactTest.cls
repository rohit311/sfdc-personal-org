@isTest
public class AddPrimaryContactTest{

    @isTest
    public static void testAddPrimaryContact(){
       List<Account> accList = new List<Account>();
       for(Integer i=0;i<100;i++){
          Account acc = new Account(Name = 'test'+i);
          if(i<50)
            acc.BillingState = 'NY';
          else
            acc.BillingState = 'CA';  
            
            accList.add(acc);
          
       }
       insert accList;
       Contact con = new Contact(LastName = 'test');
       insert con;
       Set<Id> accIds = new Set<Id>();
       for(Account acc:accList)
           accIds.add(acc.Id);
       
       AddPrimaryContact updater = new AddPrimaryContact(con,'CA');
       Test.startTest();      
           System.enqueueJob(updater);
       Test.stopTest();  
       System.assertEquals(50,[SELECT Id FROM Contact WHERE AccountId IN :accIds].size());
    }

}