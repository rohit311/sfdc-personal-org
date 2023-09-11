@istest
public class LeadProcessorTest {

    @testSetup
    static void setup()
    {
        List<Lead> lst=new LIst<Lead>();
        for(Integer i=0;i<200;i++)
        {
            lst.add(new Lead(LastName='name'+i,LeadSource='x',Company='xyz'));
        }
        
        insert lst;
    }
    
    @istest
    public static void testLeadProcessor()
    {
        Test.startTest();
        
        LeadProcessor lp=new LeadProcessor();
        ID batchId=Database.executeBatch(lp);
        Test.stopTest();
        
        System.assert(200==[SELECT count() FROM Lead WHERE LeadSource=:'Dreamforce']);
    }
}