public class feedComponentController {

    @AuraEnabled
    public static String getFeedData(){
        String feedData = '';
        try{
            ApiCallout feedCallout = new feedApiCallout();
            HttpResponse response =  feedCallout.fetchResponse(null);
            
            if(response.getStatusCode() >= 200 && response.getStatusCode() < 300){
                feedData = response.getBody(); 
            }
            else{
                feedData = System.Label.Server_error ;
                 LogUtil.createlog('API',response.getStatusCode()+' : '+response.getStatus());	
            }
        }
        catch(Exception ex){
            feedData = System.Label.Server_error;
             LogUtil.createlog('Exception',ex.getMessage());	
        }
        return feedData;
    }
}