@RestResource(urlMapping='/sample')
global class SampleApexRest {

  @HttpPost
  global static String InsertHsData() {
    Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(
      RestContext.request.requestBody.toString()
    );

    List<Object> apiList = (List<Object>)params.get('compositeRequest');
    List<sObject> recordList = new List<sObject>();
    for (Integer i=0;i<apiList.size();i++) {
      Map<String,Object> body = (Map<String,Object>)(((Map<String,Object>)apiList[i]).get('body'));
      String url = (String)(((Map<String,Object>)apiList[i]).get('url'));
      String apiMethod = (String)(((Map<String,Object>)apiList[i]).get('method'));
      if(url.contains('Account') && apiMethod.equalsIgnoreCase('post')) {
        recordList.add(new Account(Name = (String)body.get('Name')));
      }
      else if(url.contains('Contact') && apiMethod.equalsIgnoreCase('post')) {
        recordList.add(new Contact(LastName = (String)body.get('LastName'), FirstName = (String)body.get('FirstName')));
      }

      System.debug('request -> '+JSON.serializePretty(apiList[i]));
    }

    upsert recordList;


    return 'success1';
  }
}