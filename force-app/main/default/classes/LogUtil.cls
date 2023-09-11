public class LogUtil {

    public static void createlog(String typeVal,String Description){
        log__c logRecord = new log__c(Type__c = typeVal,Description__c = Description);
        
        insert logRecord;
        
    }
}