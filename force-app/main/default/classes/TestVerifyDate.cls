@istest
public class TestVerifyDate {

    @istest
    public static void testCheckDates()
    {
      test.startTest();
        Date d1=date.newInstance(2015,9,23);
        date d2=date.newInstance(2015,11,24);
        Date d3=date.newInstance(2015,11,21);
        Date d=VerifyDate.CheckDates(d1,d2);
        Date d4=VerifyDate.CheckDates(d3,d2);
        System.debug(d==d1);
        test.stopTest();
    }
    
   
}