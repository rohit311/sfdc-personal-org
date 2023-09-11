public class WeatherForeCastController{

    public static String fetchWeatherForecast(String cityName){
        String weatherForecast = '';
        
        try{
            Http httpObj = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://api.openweathermap.org/data/2.5/weather?q='+cityName+'&appid=e75f0bdabf8aa531c4612ff959d5eef1');
            req.setMethod('GET');
            HttpResponse res = httpObj.send(req);
            String responseString = res.getBody();
            
            Map<String,Object> responseMap = (Map<String,Object>)JSON.deserializeUnTyped(responseString);
            List<Object> weatherList = (LIst<Object>)responseMap.get('weather');
            Map<String,Object> weatherMap = (Map<String,Object>)(weatherList[0]); 
            System.debug('responseString '+weatherMap.get('description'));
        
        }
        catch(Exception ex){
        
        }
        
        return weatherForecast;
    }

}