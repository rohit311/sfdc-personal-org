public class AnimalLocator{


    public static String getAnimalNameById(Integer id){
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+id);
      request.setMethod('GET');
      //request.setHeader('Content-Type', 'application/json;charset=UTF-8');
      //request.setBody('{"id":'+id+);
      Map<String, Object> animal= new Map<String, Object>();
      HttpResponse response = http.send(request);
      String name = '';
      
      if (response.getStatusCode() == 200) {
        Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        animal = (Map<String, Object>) results.get('animal');
       
      }
       return (String)animal.get('name');  
    }

}