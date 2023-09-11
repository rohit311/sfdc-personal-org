public class HistoryTrackingCall {

    //(label = 'History Tracking Method' description = 'Called from History Tracking process')
    
    @InvocableMethod
    public static void calledMethod()
    {

        History_Tracking__c hisTracRec = [SELECT Name,Grade__c FROM History_Tracking__c LIMIT 1];
        hisTracRec.Score__c =0 ;
        update hisTracRec;
                System.debug('--> '+hisTracRec.Name);
        
    }
}