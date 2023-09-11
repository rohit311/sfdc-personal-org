@isTest
public class AccountProcessorTest{

    @IsTest
    public static void testAccountP(){
        
        
        Account acc = new Account(Name = 'test',Industry='Agriculture',Active__c='Yes');
        insert acc;
        Account acc2 = new Account(Name = 'test',Industry='Agriculture',Active__c='Yes');
        insert acc2;
        Contact con = new Contact(LastName = 'test contact',AccountId  = acc.Id);
        insert con;
        System.debug('in test class '+acc.Contacts);
        
        Test.startTest();
        List<Id> accIds = new List<Id>();
        accIds.add(acc.Id);
        accIds.add(acc2.Id);
        AccountProcessor.countContacts(accIds);
        Test.stopTest();
    }
}