@isTest
public class SurveybatchTest {

    
    static void setUpData(Date surveyDate){
        Contact contactRec = new Contact(FirstName = 'Joe', LastName = 'Test',Email = 'joe@test.com');
        insert contactRec;
        
        List<Customer__c> customerList = new List<Customer__c>();
        Customer__c customer1 = new Customer__c(Contact__c = contactRec.Id,survey_date__c = surveyDate,first_name__c = 'Joe',last_name__c = 'frazer');
        Customer__c customer2 = new Customer__c(Contact__c = contactRec.Id,survey_date__c = surveyDate,first_name__c = 'Joe',last_name__c = 'Gentz');
        
        customerList.add(customer1);
        customerList.add(customer2);
        
        insert customerList;
    }
    
    
    /*
     * Test Case - For customer records with today's survey date , email should be sent and survey date should be set to null
     * Type - Positive
     * */
    @isTest
    static void testSurveybatch(){
        
        setUpData(System.today());
        
        Test.startTest();       
        Database.executeBatch(new Surveybatch(),5);        
        Test.stopTest();
        
        Customer__c custRec = [SELECT survey_date__c FROM Customer__c LIMIT 1];       
        System.assertEquals(null, custRec.survey_date__c);
    }
    
    /*
     * Test Case - For customer records with no survey date , should not be picked in batch
     * Type - Negative
     * */
    @isTest
    static void testSurveybatchWithoutSurvey(){
        
        setUpData(null);
        
        Test.startTest();       
        Database.executeBatch(new Surveybatch(),5);        
        Test.stopTest();
        
        Customer__c custRec = [SELECT survey_date__c FROM Customer__c LIMIT 1];       
        System.assertEquals(null, custRec.survey_date__c);
    }
    
    @isTest static void testCreateOutOfOfficeRecord() {
        // Insert a test OutOfOffice record
        OutOfOffice ooo = new OutOfOffice(
            StartDate = Date.today(),
            EndDate = Date.today().addDays(1),
            Message='My message',
            UserId = UserInfo.getUserId()
        );
        insert ooo;
    }
    
}