@isTest
global class MockResponseForfeed implements HttpCalloutMock{
    HttpResponse[] responses = new HttpResponse[0];
    
    global void addResponse(HttpResponse response) {
        responses.add(response);
    }
    
	global HTTPResponse respond(HTTPRequest req) {
    	HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setBody('<item>test news</item>');
        res.setStatusCode(200);
        return responses.remove(0);
        
    }
}