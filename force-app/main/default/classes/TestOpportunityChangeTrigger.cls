@isTest
public class TestOpportunityChangeTrigger {

    @isTest
    static void testCreateAndUpdateOpportunity(){
        Opportunity opp = new Opportunity(Name = 'Sell 100 Widgets',StageName = 'Prospecting',CloseDate = Date.today().addMonths(3));
        insert opp;
        
        Test.getEventBus().deliver();
        
        Opportunity oppRec = [SELECT StageName FROM Opportunity LIMIT 1];
        oppRec.StageName = 'Closed Won';
        update oppRec;
        
        Test.getEventBus().deliver();
        
        Task[] taskLst = [SELECT Id,Subject FROM Task];
        System.assertEquals(1,taskLst.size());
        
    }
    
}