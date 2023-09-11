@isTest
global class AnimalLocatorMock implements HttpCalloutMock{


    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"animal": ["majestic badger", "fluffy bunny", "scary bear", "chicken", "mighty moose"]}');
        response.setBody('{"animal": {"name":"test"}}');
        response.setStatusCode(200);
        return response; 
    }
}