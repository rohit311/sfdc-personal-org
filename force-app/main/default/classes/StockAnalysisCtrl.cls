public class StockAnalysisCtrl{

public class ResponseData{

@AuraEnabled
public String Status;
@AuraEnabled
public String msg;
@AuraEnabled
public List<Map<String,String>> respMap;

}


@AuraEnabled
public static String callStockApi(String keyword){
    
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    String endpoint = System.Label.StockAPIEndpoint;
    endpoint = endpoint.replace('KW',keyword); 
    endpoint = endpoint.replace('KEY','UKUWZ1DGI4ECRBAX');
    System.debug('endpoint '+endpoint);
    request.setEndpoint(endpoint);
    request.setMethod('GET');
    HttpResponse response = http.send(request);
    
    ResponseData respData = new ResponseData();
    
    if(response.getStatusCode() == 200){
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        System.debug('results '+results);
        System.debug('results '+results.get('bestMatches'));
        respData.Status = 'Success';
        List<Object> dataLst = (List<Object>)results.get('bestMatches');
        if(dataLst != null && dataLst.size()>0){  
        
        List<Map<String,Object>> result = new List<Map<String,Object>>();
        for(Object obj : dataLst)
           result.add((Map<String,Object>)obj);
        
        List<Map<String,String>> parsedRes = new List<Map<String,String>>();
        parsedRes = generateMap(result);
        respData.respMap = parsedRes;
        System.debug('---> '+respData.respMap);
        }
    }

    return JSON.serialize(respData);
}

public static List<Map<String,String>> generateMap(List<Map<String,Object>> resMapList){
    
    if(resMapList != null && resMapList.size()>0){
        List<Map<String,String>> mapLst = new List<Map<String,String>>();
    
        Map<String,String> genMap;
        
        for(Map<String,Object> resMap :resMapList){            
            genMap = new Map<String,String>();
            for(String key : resMap.Keyset()){
                genMap.put(key,(String)resMap.get(key));
            }
            if(genMap.keySet().size()>0)
                mapLst.add(genMap);
            
        }
       if(mapLst.size()>0)
        return mapLst;   
    }
    
    return null;
}

public static String restCallout(Map<String,String> params){
    //will write generic method for callouts
    return null;

} 


}