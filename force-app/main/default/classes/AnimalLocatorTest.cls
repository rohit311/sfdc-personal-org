@isTest
public class AnimalLocatorTest{
    @isTest static void testPostCallout() {
    
         Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
         String response = AnimalLocator.getAnimalNameById(1);
         
         System.assert(response != '');
    }
}