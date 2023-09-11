public class feedApiCallout implements ApiCallout{

    public HttpResponse fetchResponse(HttpRequest request){
        
        Http http = new Http();
        request = new HttpRequest();
        request.setEndpoint('callout:Yahoo_feed');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        return response;
    }
    
    
}