@istest
public class DailyLeadProcessorTest {

    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    @istest
    public static void DailyLeadPTest()
    {
        List<Lead> lst=new LIst<Lead>();
        
        for(Integer i=0;i<200;i++)
         {
            Lead l=new Lead(LastName='n'+i,Company='xyz',LeadSource='');
             lst.add(l);
         }
        
        insert lst;
        
        Test.startTest();
        
       String strid=System.schedule('DailyLeadProcessor',CRON_EXP,new DailyLeadProcessor());
        test.stopTest();
    }
    
    
}