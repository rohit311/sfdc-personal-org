@isTest
public class ParkLocatorTest{

    @isTest static void testCallout() {   
    
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        String[] arr = ParkLocator.country('Germany');
    }

}