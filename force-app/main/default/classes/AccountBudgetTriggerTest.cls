@isTest
public class AccountBudgetTriggerTest {

    static void setupContacts() {
		List<Contact> contactList = new List<Contact>();
        Account acc = new Account(Name = 'Majesto Insurance',Budget__c = 0);
      	insert acc;
        
        Contact con1 = new Contact(LastName = 'Robin',AccountId = acc.Id,Use_Marketing_Budget__c = true);
        contactList.add(con1);
        Contact con2 = new Contact(LastName = 'Rohan',AccountId = acc.Id,Use_Sales_Budget__c = true);
        contactList.add(con2);
        Contact con3 = new Contact(LastName = 'Rohan',AccountId = acc.Id);
        contactList.add(con3);
        insert contactList;
        
        acc.Budget__c = 100;
        update acc;
    }    	
    
    @isTest
    static void checkBudget(){
        
        setupContacts();
        System.Test.startTest();
        
        Contact con1 = [SELECT Budget__c FROM Contact WHERE Use_Sales_Budget__c = true LIMIT 1];
        System.assertEquals(60.0,con1.Budget__c );
       	con1 = [SELECT Budget__c FROM Contact WHERE Use_Marketing_Budget__c = true LIMIT 1];
        System.assertEquals(40.0,con1.Budget__c );
        con1 = [SELECT Budget__c FROM Contact WHERE Use_Marketing_Budget__c = false AND Use_Sales_Budget__c = false  LIMIT 1];
        System.assertEquals(null,con1.Budget__c );
        
        System.Test.stopTest();
    }
}