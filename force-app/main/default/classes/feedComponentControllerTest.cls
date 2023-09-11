@isTest
public class feedComponentControllerTest {
    
    
    /*
     * Test Case - Response should be fetched from endpoint for a valid response
     * Type - Positive
     * */
	@isTest 
    static void testgetFeedData() {
        MockResponseForfeed mock = new MockResponseForfeed();
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setBody('<item>test news</item>');
        res.setStatusCode(200);       
        mock.addResponse(res);
                
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        
        String response = feedComponentController.getFeedData();
        System.assertEquals('<item>test news</item>', response);
        
        Test.stopTest();
    }
    
    
    /*
     * Test Case - If API is unavailable , system should return error message
     * Type - Negative
     * */
    @isTest
    static void testgetFeedDataForUnavailable(){
        MockResponseForfeed mock = new MockResponseForfeed();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setBody('');
        res.setStatusCode(500);       
        mock.addResponse(res);
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        
        Test.startTest();
        
        String response = feedComponentController.getFeedData();
        System.assertEquals('Server error', response);
        
        Test.stopTest();
    }
}