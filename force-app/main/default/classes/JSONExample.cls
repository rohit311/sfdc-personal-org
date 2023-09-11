public class JSONExample {

    public static void serializeRoundTrip(){
        
        List<Account> accList=[SELECT Name,Phone,Industry FROM Account LIMIT 10];
        
        
        String JSONString=JSON.serialize(accList);
        System.debug('Seralized object - '+JSONString);
        
        List<Account> deseralizedList=(List<Account>)JSON.deserialize(JSONString,List<Account>.class);
        System.debug('Deserialized object- '+deseralizedList);
    }
}